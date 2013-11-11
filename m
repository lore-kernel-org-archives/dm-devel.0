From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5/6] dm cache: add remove_cblock method to policy
	interface
Date: Mon, 11 Nov 2013 12:20:47 -0500
Message-ID: <1384190448-3861-6-git-send-email-snitzer@redhat.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Implement policy_remove_cblock() and add remove_cblock method to the mq
policy.  These methods will be used by the following cache block
invalidation patch which adds the 'invalidate_cblocks' message to the
cache core.

Also, update some comments in dm-cache-policy.h

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-policy-internal.h |    5 ++++
 drivers/md/dm-cache-policy-mq.c       |   35 +++++++++++++++++++++++++++++++++
 drivers/md/dm-cache-policy.h          |   21 ++++++++++++++++---
 3 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-cache-policy-internal.h b/drivers/md/dm-cache-policy-internal.h
index a75f7e7..2256a1f 100644
--- a/drivers/md/dm-cache-policy-internal.h
+++ b/drivers/md/dm-cache-policy-internal.h
@@ -64,6 +64,11 @@ static inline void policy_remove_mapping(struct dm_cache_policy *p, dm_oblock_t
 	p->remove_mapping(p, oblock);
 }
 
+static inline int policy_remove_cblock(struct dm_cache_policy *p, dm_cblock_t cblock)
+{
+	return p->remove_cblock(p, cblock);
+}
+
 static inline void policy_force_mapping(struct dm_cache_policy *p,
 					dm_oblock_t current_oblock, dm_oblock_t new_oblock)
 {
diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 782bf85..7209fab 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -304,6 +304,15 @@ static void free_entry(struct entry_pool *ep, struct entry *e)
 	list_add(&e->list, &ep->free);
 }
 
+/*
+ * Returns NULL if the entry is free.
+ */
+static struct entry *epool_find(struct entry_pool *ep, dm_cblock_t cblock)
+{
+	struct entry *e = ep->entries + from_cblock(cblock);
+	return e->hlist.pprev ? e : NULL;
+}
+
 static bool epool_empty(struct entry_pool *ep)
 {
 	return list_empty(&ep->free);
@@ -1020,6 +1029,31 @@ static void mq_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
 	mutex_unlock(&mq->lock);
 }
 
+static int __remove_cblock(struct mq_policy *mq, dm_cblock_t cblock)
+{
+	struct entry *e = epool_find(&mq->cache_pool, cblock);
+
+	if (!e)
+		return -ENODATA;
+
+	del(mq, e);
+	free_entry(&mq->cache_pool, e);
+
+	return 0;
+}
+
+static int mq_remove_cblock(struct dm_cache_policy *p, dm_cblock_t cblock)
+{
+	int r;
+	struct mq_policy *mq = to_mq_policy(p);
+
+	mutex_lock(&mq->lock);
+	r = __remove_cblock(mq, cblock);
+	mutex_unlock(&mq->lock);
+
+	return r;
+}
+
 static int __mq_writeback_work(struct mq_policy *mq, dm_oblock_t *oblock,
 			      dm_cblock_t *cblock)
 {
@@ -1139,6 +1173,7 @@ static void init_policy_functions(struct mq_policy *mq)
 	mq->policy.load_mapping = mq_load_mapping;
 	mq->policy.walk_mappings = mq_walk_mappings;
 	mq->policy.remove_mapping = mq_remove_mapping;
+	mq->policy.remove_cblock = mq_remove_cblock;
 	mq->policy.writeback_work = mq_writeback_work;
 	mq->policy.force_mapping = mq_force_mapping;
 	mq->policy.residency = mq_residency;
diff --git a/drivers/md/dm-cache-policy.h b/drivers/md/dm-cache-policy.h
index 33369ca..052c00a 100644
--- a/drivers/md/dm-cache-policy.h
+++ b/drivers/md/dm-cache-policy.h
@@ -135,9 +135,6 @@ struct dm_cache_policy {
 	 */
 	int (*lookup)(struct dm_cache_policy *p, dm_oblock_t oblock, dm_cblock_t *cblock);
 
-	/*
-	 * oblock must be a mapped block.  Must not block.
-	 */
 	void (*set_dirty)(struct dm_cache_policy *p, dm_oblock_t oblock);
 	void (*clear_dirty)(struct dm_cache_policy *p, dm_oblock_t oblock);
 
@@ -159,8 +156,24 @@ struct dm_cache_policy {
 	void (*force_mapping)(struct dm_cache_policy *p, dm_oblock_t current_oblock,
 			      dm_oblock_t new_oblock);
 
-	int (*writeback_work)(struct dm_cache_policy *p, dm_oblock_t *oblock, dm_cblock_t *cblock);
+	/*
+	 * This is called via the invalidate_cblocks message.  It is
+	 * possible the particular cblock has already been removed due to a
+	 * write io in passthrough mode.  In which case this should return
+	 * -ENODATA.
+	 */
+	int (*remove_cblock)(struct dm_cache_policy *p, dm_cblock_t cblock);
 
+	/*
+	 * Provide a dirty block to be written back by the core target.
+	 *
+	 * Returns:
+	 *
+	 * 0 and @cblock,@oblock: block to write back provided
+	 *
+	 * -ENODATA: no dirty blocks available
+	 */
+	int (*writeback_work)(struct dm_cache_policy *p, dm_oblock_t *oblock, dm_cblock_t *cblock);
 
 	/*
 	 * How full is the cache?
-- 
1.7.4.4
