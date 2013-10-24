From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 07/24] dm cache: be much more aggressive about
	promoting writes to discarded blocks
Date: Thu, 24 Oct 2013 14:30:20 -0400
Message-ID: <1382639437-27007-8-git-send-email-snitzer@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
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
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Previously these promotions only got priority if there were unused cache
blocks.  Now we give them priority if there are any clean blocks in the
cache.

The fio_soak_test in the device-mapper-test-suite now gives uniform
performance across subvolumes (~16 seconds).

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-policy-mq.c | 84 ++++++++++++++++++++++++++++++-----------
 1 file changed, 63 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 35e6798..152e979 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -151,6 +151,21 @@ static void queue_init(struct queue *q)
 }
 
 /*
+ * Checks to see if the queue is empty.
+ * FIXME: reduce cpu usage.
+ */
+static bool queue_empty(struct queue *q)
+{
+	unsigned i;
+
+	for (i = 0; i < NR_QUEUE_LEVELS; i++)
+		if (!list_empty(q->qs + i))
+			return false;
+
+	return true;
+}
+
+/*
  * Insert an entry to the back of the given level.
  */
 static void queue_push(struct queue *q, unsigned level, struct list_head *elt)
@@ -444,6 +459,11 @@ static bool any_free_cblocks(struct mq_policy *mq)
 	return mq->nr_cblocks_allocated < from_cblock(mq->cache_size);
 }
 
+static bool any_clean_cblocks(struct mq_policy *mq)
+{
+	return !queue_empty(&mq->cache_clean);
+}
+
 /*
  * Fills result out with a cache block that isn't in use, or return
  * -ENOSPC.  This does _not_ mark the cblock as allocated, the caller is
@@ -689,17 +709,18 @@ static int demote_cblock(struct mq_policy *mq, dm_oblock_t *oblock, dm_cblock_t
 static unsigned adjusted_promote_threshold(struct mq_policy *mq,
 					   bool discarded_oblock, int data_dir)
 {
-	if (discarded_oblock && any_free_cblocks(mq) && data_dir == WRITE)
+	if (data_dir == READ)
+		return mq->promote_threshold + READ_PROMOTE_THRESHOLD;
+
+	if (discarded_oblock && (any_free_cblocks(mq) || any_clean_cblocks(mq))) {
 		/*
 		 * We don't need to do any copying at all, so give this a
-		 * very low threshold.  In practice this only triggers
-		 * during initial population after a format.
+		 * very low threshold.
 		 */
 		return DISCARDED_PROMOTE_THRESHOLD;
+	}
 
-	return data_dir == READ ?
-		(mq->promote_threshold + READ_PROMOTE_THRESHOLD) :
-		(mq->promote_threshold + WRITE_PROMOTE_THRESHOLD);
+	return mq->promote_threshold + WRITE_PROMOTE_THRESHOLD;
 }
 
 static bool should_promote(struct mq_policy *mq, struct entry *e,
@@ -773,6 +794,17 @@ static int pre_cache_entry_found(struct mq_policy *mq, struct entry *e,
 	return r;
 }
 
+static void insert_entry_in_pre_cache(struct mq_policy *mq,
+				      struct entry *e, dm_oblock_t oblock)
+{
+	e->in_cache = false;
+	e->dirty = false;
+	e->oblock = oblock;
+	e->hit_count = 1;
+	e->generation = mq->generation;
+	push(mq, e);
+}
+
 static void insert_in_pre_cache(struct mq_policy *mq,
 				dm_oblock_t oblock)
 {
@@ -790,30 +822,41 @@ static void insert_in_pre_cache(struct mq_policy *mq,
 		return;
 	}
 
-	e->in_cache = false;
-	e->dirty = false;
-	e->oblock = oblock;
-	e->hit_count = 1;
-	e->generation = mq->generation;
-	push(mq, e);
+	insert_entry_in_pre_cache(mq, e, oblock);
 }
 
 static void insert_in_cache(struct mq_policy *mq, dm_oblock_t oblock,
 			    struct policy_result *result)
 {
+	int r;
 	struct entry *e;
 	dm_cblock_t cblock;
 
 	if (find_free_cblock(mq, &cblock) == -ENOSPC) {
-		result->op = POLICY_MISS;
-		insert_in_pre_cache(mq, oblock);
-		return;
-	}
+		r = demote_cblock(mq, &result->old_oblock, &cblock);
+		if (unlikely(r)) {
+			result->op = POLICY_MISS;
+			insert_in_pre_cache(mq, oblock);
+			return;
+		}
 
-	e = alloc_entry(mq);
-	if (unlikely(!e)) {
-		result->op = POLICY_MISS;
-		return;
+		/*
+		 * This will always succeed, since we've just demoted.
+		 */
+		e = pop(mq, &mq->pre_cache);
+		result->op = POLICY_REPLACE;
+
+	} else {
+		e = alloc_entry(mq);
+		if (unlikely(!e))
+			e = pop(mq, &mq->pre_cache);
+
+		if (unlikely(!e)) {
+			result->op = POLICY_MISS;
+			return;
+		}
+
+		result->op = POLICY_NEW;
 	}
 
 	e->oblock = oblock;
@@ -824,7 +867,6 @@ static void insert_in_cache(struct mq_policy *mq, dm_oblock_t oblock,
 	e->generation = mq->generation;
 	push(mq, e);
 
-	result->op = POLICY_NEW;
 	result->cblock = e->cblock;
 }
 
-- 
1.8.1.4
