From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 05/24] dm cache policy mq: implement
	writeback_work() and mq_{set, clear}_dirty()
Date: Thu, 24 Oct 2013 14:30:18 -0400
Message-ID: <1382639437-27007-6-git-send-email-snitzer@redhat.com>
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

There are now two multiqueues for in cache blocks.  A clean one and a
dirty one.

writeback_work comes from the dirty one.  Demotions come from the clean
one.

There are two benefits:
- Performance improvement, since demoting a clean block is a noop.
- The cache cleans itself when io load is light.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-policy-mq.c | 140 ++++++++++++++++++++++++++++++++++------
 1 file changed, 122 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 0410a08..108380d 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -224,6 +224,7 @@ struct entry {
 	 * FIXME: pack these better
 	 */
 	bool in_cache:1;
+	bool dirty:1;
 	unsigned hit_count;
 	unsigned generation;
 	unsigned tick;
@@ -238,13 +239,15 @@ struct mq_policy {
 	struct io_tracker tracker;
 
 	/*
-	 * We maintain two queues of entries.  The cache proper contains
-	 * the currently active mappings.  Whereas the pre_cache tracks
-	 * blocks that are being hit frequently and potential candidates
-	 * for promotion to the cache.
+	 * We maintain three queues of entries.  The cache proper,
+	 * consisting of a clean and dirty queue, contains the currently
+	 * active mappings.  Whereas the pre_cache tracks blocks that
+	 * are being hit frequently and potential candidates for promotion
+	 * to the cache.
 	 */
 	struct queue pre_cache;
-	struct queue cache;
+	struct queue cache_clean;
+	struct queue cache_dirty;
 
 	/*
 	 * Keeps track of time, incremented by the core.  We use this to
@@ -324,7 +327,8 @@ static void free_entries(struct mq_policy *mq)
 	struct entry *e, *tmp;
 
 	concat_queue(&mq->free, &mq->pre_cache);
-	concat_queue(&mq->free, &mq->cache);
+	concat_queue(&mq->free, &mq->cache_clean);
+	concat_queue(&mq->free, &mq->cache_dirty);
 
 	list_for_each_entry_safe(e, tmp, &mq->free, list)
 		kmem_cache_free(mq_entry_cache, e);
@@ -508,7 +512,8 @@ static void push(struct mq_policy *mq, struct entry *e)
 
 	if (e->in_cache) {
 		alloc_cblock(mq, e->cblock);
-		queue_push(&mq->cache, queue_level(e), &e->list);
+		queue_push(e->dirty ? &mq->cache_dirty : &mq->cache_clean,
+			   queue_level(e), &e->list);
 	} else
 		queue_push(&mq->pre_cache, queue_level(e), &e->list);
 }
@@ -580,7 +585,16 @@ static void check_generation(struct mq_policy *mq)
 		mq->generation++;
 
 		for (level = 0; level < NR_QUEUE_LEVELS && count < MAX_TO_AVERAGE; level++) {
-			head = mq->cache.qs + level;
+			head = mq->cache_clean.qs + level;
+			list_for_each_entry(e, head, list) {
+				nr++;
+				total += e->hit_count;
+
+				if (++count >= MAX_TO_AVERAGE)
+					break;
+			}
+
+			head = mq->cache_dirty.qs + level;
 			list_for_each_entry(e, head, list) {
 				nr++;
 				total += e->hit_count;
@@ -633,19 +647,28 @@ static void requeue_and_update_tick(struct mq_policy *mq, struct entry *e)
  * - set the hit count to a hard coded value other than 1, eg, is it better
  *   if it goes in at level 2?
  */
-static dm_cblock_t demote_cblock(struct mq_policy *mq, dm_oblock_t *oblock)
+static int demote_cblock(struct mq_policy *mq, dm_oblock_t *oblock, dm_cblock_t *cblock)
 {
-	dm_cblock_t result;
-	struct entry *demoted = pop(mq, &mq->cache);
+	struct entry *demoted = pop(mq, &mq->cache_clean);
 
-	BUG_ON(!demoted);
-	result = demoted->cblock;
+	if (!demoted)
+		/*
+		 * We could get a block from mq->cache_dirty, but that
+		 * would add extra latency to the triggering bio as it
+		 * waits for the writeback.  Better to not promote this
+		 * time and hope there's a clean block next time this block
+		 * is hit.
+		 */
+		return -ENOSPC;
+
+	*cblock = demoted->cblock;
 	*oblock = demoted->oblock;
 	demoted->in_cache = false;
+	demoted->dirty = false;
 	demoted->hit_count = 1;
 	push(mq, demoted);
 
-	return result;
+	return 0;
 }
 
 /*
@@ -705,11 +728,16 @@ static int cache_entry_found(struct mq_policy *mq,
 static int pre_cache_to_cache(struct mq_policy *mq, struct entry *e,
 			      struct policy_result *result)
 {
+	int r;
 	dm_cblock_t cblock;
 
 	if (find_free_cblock(mq, &cblock) == -ENOSPC) {
 		result->op = POLICY_REPLACE;
-		cblock = demote_cblock(mq, &result->old_oblock);
+		r = demote_cblock(mq, &result->old_oblock, &cblock);
+		if (r) {
+			result->op = POLICY_MISS;
+			return 0;
+		}
 	} else
 		result->op = POLICY_NEW;
 
@@ -717,6 +745,7 @@ static int pre_cache_to_cache(struct mq_policy *mq, struct entry *e,
 
 	del(mq, e);
 	e->in_cache = true;
+	e->dirty = false;
 	push(mq, e);
 
 	return 0;
@@ -760,6 +789,7 @@ static void insert_in_pre_cache(struct mq_policy *mq,
 	}
 
 	e->in_cache = false;
+	e->dirty = false;
 	e->oblock = oblock;
 	e->hit_count = 1;
 	e->generation = mq->generation;
@@ -787,6 +817,7 @@ static void insert_in_cache(struct mq_policy *mq, dm_oblock_t oblock,
 	e->oblock = oblock;
 	e->cblock = cblock;
 	e->in_cache = true;
+	e->dirty = false;
 	e->hit_count = 1;
 	e->generation = mq->generation;
 	push(mq, e);
@@ -917,6 +948,36 @@ static int mq_lookup(struct dm_cache_policy *p, dm_oblock_t oblock, dm_cblock_t
 	return r;
 }
 
+// FIXME: can __mq_set_clear_dirty block?
+static void __mq_set_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock, bool set)
+{
+	struct mq_policy *mq = to_mq_policy(p);
+	struct entry *e;
+
+	mutex_lock(&mq->lock);
+	e = hash_lookup(mq, oblock);
+	if (!e)
+		DMWARN("__mq_set_clear_dirty called for a block that isn't in the cache");
+	else {
+		BUG_ON(!e->in_cache);
+
+		del(mq, e);
+		e->dirty = set;
+		push(mq, e);
+	}
+	mutex_unlock(&mq->lock);
+}
+
+static void mq_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	__mq_set_clear_dirty(p, oblock, true);
+}
+
+static void mq_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	__mq_set_clear_dirty(p, oblock, false);
+}
+
 static int mq_load_mapping(struct dm_cache_policy *p,
 			   dm_oblock_t oblock, dm_cblock_t cblock,
 			   uint32_t hint, bool hint_valid)
@@ -931,6 +992,7 @@ static int mq_load_mapping(struct dm_cache_policy *p,
 	e->cblock = cblock;
 	e->oblock = oblock;
 	e->in_cache = true;
+	e->dirty = true;	/* this gets corrected in a minute */
 	e->hit_count = hint_valid ? hint : 1;
 	e->generation = mq->generation;
 	push(mq, e);
@@ -949,7 +1011,14 @@ static int mq_walk_mappings(struct dm_cache_policy *p, policy_walk_fn fn,
 	mutex_lock(&mq->lock);
 
 	for (level = 0; level < NR_QUEUE_LEVELS; level++)
-		list_for_each_entry(e, &mq->cache.qs[level], list) {
+		list_for_each_entry(e, &mq->cache_clean.qs[level], list) {
+			r = fn(context, e->cblock, e->oblock, e->hit_count);
+			if (r)
+				goto out;
+		}
+
+	for (level = 0; level < NR_QUEUE_LEVELS; level++)
+		list_for_each_entry(e, &mq->cache_dirty.qs[level], list) {
 			r = fn(context, e->cblock, e->oblock, e->hit_count);
 			if (r)
 				goto out;
@@ -974,9 +1043,39 @@ static void mq_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
 
 	del(mq, e);
 	e->in_cache = false;
+	e->dirty = false;
+	push(mq, e);
+
+	mutex_unlock(&mq->lock);
+}
+
+static int __mq_writeback_work(struct mq_policy *mq, dm_oblock_t *oblock,
+			      dm_cblock_t *cblock)
+{
+	struct entry *e = pop(mq, &mq->cache_dirty);
+
+	if (!e)
+		return -ENODATA;
+
+	*oblock = e->oblock;
+	*cblock = e->cblock;
+	e->dirty = false;
 	push(mq, e);
 
+	return 0;
+}
+
+static int mq_writeback_work(struct dm_cache_policy *p, dm_oblock_t *oblock,
+			     dm_cblock_t *cblock)
+{
+	int r;
+	struct mq_policy *mq = to_mq_policy(p);
+
+	mutex_lock(&mq->lock);
+	r = __mq_writeback_work(mq, oblock, cblock);
 	mutex_unlock(&mq->lock);
+
+	return r;
 }
 
 static void force_mapping(struct mq_policy *mq,
@@ -988,6 +1087,7 @@ static void force_mapping(struct mq_policy *mq,
 
 	del(mq, e);
 	e->oblock = new_oblock;
+	e->dirty = true;
 	push(mq, e);
 }
 
@@ -1059,10 +1159,12 @@ static void init_policy_functions(struct mq_policy *mq)
 	mq->policy.destroy = mq_destroy;
 	mq->policy.map = mq_map;
 	mq->policy.lookup = mq_lookup;
+	mq->policy.set_dirty = mq_set_dirty;
+	mq->policy.clear_dirty = mq_clear_dirty;
 	mq->policy.load_mapping = mq_load_mapping;
 	mq->policy.walk_mappings = mq_walk_mappings;
 	mq->policy.remove_mapping = mq_remove_mapping;
-	mq->policy.writeback_work = NULL;
+	mq->policy.writeback_work = mq_writeback_work;
 	mq->policy.force_mapping = mq_force_mapping;
 	mq->policy.residency = mq_residency;
 	mq->policy.tick = mq_tick;
@@ -1095,7 +1197,9 @@ static struct dm_cache_policy *mq_create(dm_cblock_t cache_size,
 	mq->find_free_last_word = 0;
 
 	queue_init(&mq->pre_cache);
-	queue_init(&mq->cache);
+	queue_init(&mq->cache_clean);
+	queue_init(&mq->cache_dirty);
+
 	mq->generation_period = max((unsigned) from_cblock(cache_size), 1024U);
 
 	mq->nr_entries = 2 * from_cblock(cache_size);
-- 
1.8.1.4
