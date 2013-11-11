From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/6] dm cache policy mq: reduce memory
	requirements
Date: Mon, 11 Nov 2013 12:20:46 -0500
Message-ID: <1384190448-3861-5-git-send-email-snitzer@redhat.com>
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

Rather than storing the cblock in each cache entry, we allocate all
entries in an array and infer the cblock from the entry position.

Saves 4 bytes of memory per cache block.  In addition, this gives us an
easy way of looking up cache entries by cblock.

We no longer need to keep an explicit bitset to track which cblocks
have been allocated.  And no searching is needed to find free cblocks.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-policy-mq.c |  543 +++++++++++++++++----------------------
 1 files changed, 231 insertions(+), 312 deletions(-)

diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 444f0bf..782bf85 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -26,19 +26,6 @@ static unsigned next_power(unsigned n, unsigned min)
 
 /*----------------------------------------------------------------*/
 
-static unsigned long *alloc_bitset(unsigned nr_entries)
-{
-	size_t s = sizeof(unsigned long) * dm_div_up(nr_entries, BITS_PER_LONG);
-	return vzalloc(s);
-}
-
-static void free_bitset(unsigned long *bits)
-{
-	vfree(bits);
-}
-
-/*----------------------------------------------------------------*/
-
 /*
  * Large, sequential ios are probably better left on the origin device since
  * spindles tend to have good bandwidth.
@@ -233,18 +220,107 @@ struct entry {
 	struct hlist_node hlist;
 	struct list_head list;
 	dm_oblock_t oblock;
-	dm_cblock_t cblock;	/* valid iff in_cache */
 
 	/*
 	 * FIXME: pack these better
 	 */
-	bool in_cache:1;
 	bool dirty:1;
 	unsigned hit_count;
 	unsigned generation;
 	unsigned tick;
 };
 
+/*
+ * Rather than storing the cblock in an entry, we allocate all entries in
+ * an array, and infer the cblock from the entry position.
+ *
+ * Free entries are linked together into a list.
+ */
+struct entry_pool {
+	struct entry *entries, *entries_end;
+	struct list_head free;
+	unsigned nr_allocated;
+};
+
+static int epool_init(struct entry_pool *ep, unsigned nr_entries)
+{
+	unsigned i;
+
+	ep->entries = vzalloc(sizeof(struct entry) * nr_entries);
+	if (!ep->entries)
+		return -ENOMEM;
+
+	ep->entries_end = ep->entries + nr_entries;
+
+	INIT_LIST_HEAD(&ep->free);
+	for (i = 0; i < nr_entries; i++)
+		list_add(&ep->entries[i].list, &ep->free);
+
+	ep->nr_allocated = 0;
+
+	return 0;
+}
+
+static void epool_exit(struct entry_pool *ep)
+{
+	vfree(ep->entries);
+}
+
+static struct entry *alloc_entry(struct entry_pool *ep)
+{
+	struct entry *e;
+
+	if (list_empty(&ep->free))
+		return NULL;
+
+	e = list_entry(list_pop(&ep->free), struct entry, list);
+	INIT_LIST_HEAD(&e->list);
+	INIT_HLIST_NODE(&e->hlist);
+	ep->nr_allocated++;
+
+	return e;
+}
+
+/*
+ * This assumes the cblock hasn't already been allocated.
+ */
+static struct entry *alloc_particular_entry(struct entry_pool *ep, dm_cblock_t cblock)
+{
+	struct entry *e = ep->entries + from_cblock(cblock);
+	list_del(&e->list);
+
+	INIT_LIST_HEAD(&e->list);
+	INIT_HLIST_NODE(&e->hlist);
+	ep->nr_allocated++;
+
+	return e;
+}
+
+static void free_entry(struct entry_pool *ep, struct entry *e)
+{
+	BUG_ON(!ep->nr_allocated);
+	ep->nr_allocated--;
+	INIT_HLIST_NODE(&e->hlist);
+	list_add(&e->list, &ep->free);
+}
+
+static bool epool_empty(struct entry_pool *ep)
+{
+	return list_empty(&ep->free);
+}
+
+static bool in_pool(struct entry_pool *ep, struct entry *e)
+{
+	return e >= ep->entries && e < ep->entries_end;
+}
+
+static dm_cblock_t infer_cblock(struct entry_pool *ep, struct entry *e)
+{
+	return to_cblock(e - ep->entries);
+}
+
+/*----------------------------------------------------------------*/
+
 struct mq_policy {
 	struct dm_cache_policy policy;
 
@@ -254,6 +330,13 @@ struct mq_policy {
 	struct io_tracker tracker;
 
 	/*
+	 * Entries come from two pools, one of pre-cache entries, and one
+	 * for the cache proper.
+	 */
+	struct entry_pool pre_cache_pool;
+	struct entry_pool cache_pool;
+
+	/*
 	 * We maintain three queues of entries.  The cache proper,
 	 * consisting of a clean and dirty queue, contains the currently
 	 * active mappings.  Whereas the pre_cache tracks blocks that
@@ -300,25 +383,6 @@ struct mq_policy {
 	unsigned promote_threshold;
 
 	/*
-	 * We need cache_size entries for the cache, and choose to have
-	 * cache_size entries for the pre_cache too.  One motivation for
-	 * using the same size is to make the hit counts directly
-	 * comparable between pre_cache and cache.
-	 */
-	unsigned nr_entries;
-	unsigned nr_entries_allocated;
-	struct list_head free;
-
-	/*
-	 * Cache blocks may be unallocated.  We store this info in a
-	 * bitset.
-	 */
-	unsigned long *allocation_bitset;
-	unsigned nr_cblocks_allocated;
-	unsigned find_free_nr_words;
-	unsigned find_free_last_word;
-
-	/*
 	 * The hash table allows us to quickly find an entry by origin
 	 * block.  Both pre_cache and cache entries are in here.
 	 */
@@ -328,50 +392,6 @@ struct mq_policy {
 };
 
 /*----------------------------------------------------------------*/
-/* Free/alloc mq cache entry structures. */
-static void concat_queue(struct list_head *lh, struct queue *q)
-{
-	unsigned level;
-
-	for (level = 0; level < NR_QUEUE_LEVELS; level++)
-		list_splice(q->qs + level, lh);
-}
-
-static void free_entries(struct mq_policy *mq)
-{
-	struct entry *e, *tmp;
-
-	concat_queue(&mq->free, &mq->pre_cache);
-	concat_queue(&mq->free, &mq->cache_clean);
-	concat_queue(&mq->free, &mq->cache_dirty);
-
-	list_for_each_entry_safe(e, tmp, &mq->free, list)
-		kmem_cache_free(mq_entry_cache, e);
-}
-
-static int alloc_entries(struct mq_policy *mq, unsigned elts)
-{
-	unsigned u = mq->nr_entries;
-
-	INIT_LIST_HEAD(&mq->free);
-	mq->nr_entries_allocated = 0;
-
-	while (u--) {
-		struct entry *e = kmem_cache_zalloc(mq_entry_cache, GFP_KERNEL);
-
-		if (!e) {
-			free_entries(mq);
-			return -ENOMEM;
-		}
-
-
-		list_add(&e->list, &mq->free);
-	}
-
-	return 0;
-}
-
-/*----------------------------------------------------------------*/
 
 /*
  * Simple hash table implementation.  Should replace with the standard hash
@@ -407,54 +427,9 @@ static void hash_remove(struct entry *e)
 
 /*----------------------------------------------------------------*/
 
-/*
- * Allocates a new entry structure.  The memory is allocated in one lump,
- * so we just handing it out here.  Returns NULL if all entries have
- * already been allocated.  Cannot fail otherwise.
- */
-static struct entry *alloc_entry(struct mq_policy *mq)
-{
-	struct entry *e;
-
-	if (mq->nr_entries_allocated >= mq->nr_entries) {
-		BUG_ON(!list_empty(&mq->free));
-		return NULL;
-	}
-
-	e = list_entry(list_pop(&mq->free), struct entry, list);
-	INIT_LIST_HEAD(&e->list);
-	INIT_HLIST_NODE(&e->hlist);
-
-	mq->nr_entries_allocated++;
-	return e;
-}
-
-/*----------------------------------------------------------------*/
-
-/*
- * Mark cache blocks allocated or not in the bitset.
- */
-static void alloc_cblock(struct mq_policy *mq, dm_cblock_t cblock)
-{
-	BUG_ON(from_cblock(cblock) > from_cblock(mq->cache_size));
-	BUG_ON(test_bit(from_cblock(cblock), mq->allocation_bitset));
-
-	set_bit(from_cblock(cblock), mq->allocation_bitset);
-	mq->nr_cblocks_allocated++;
-}
-
-static void free_cblock(struct mq_policy *mq, dm_cblock_t cblock)
-{
-	BUG_ON(from_cblock(cblock) > from_cblock(mq->cache_size));
-	BUG_ON(!test_bit(from_cblock(cblock), mq->allocation_bitset));
-
-	clear_bit(from_cblock(cblock), mq->allocation_bitset);
-	mq->nr_cblocks_allocated--;
-}
-
 static bool any_free_cblocks(struct mq_policy *mq)
 {
-	return mq->nr_cblocks_allocated < from_cblock(mq->cache_size);
+	return !epool_empty(&mq->cache_pool);
 }
 
 static bool any_clean_cblocks(struct mq_policy *mq)
@@ -462,48 +437,6 @@ static bool any_clean_cblocks(struct mq_policy *mq)
 	return !queue_empty(&mq->cache_clean);
 }
 
-/*
- * Fills result out with a cache block that isn't in use, or return
- * -ENOSPC.  This does _not_ mark the cblock as allocated, the caller is
- * reponsible for that.
- */
-static int __find_free_cblock(struct mq_policy *mq, unsigned begin, unsigned end,
-			      dm_cblock_t *result, unsigned *last_word)
-{
-	int r = -ENOSPC;
-	unsigned w;
-
-	for (w = begin; w < end; w++) {
-		/*
-		 * ffz is undefined if no zero exists
-		 */
-		if (mq->allocation_bitset[w] != ~0UL) {
-			*last_word = w;
-			*result = to_cblock((w * BITS_PER_LONG) + ffz(mq->allocation_bitset[w]));
-			if (from_cblock(*result) < from_cblock(mq->cache_size))
-				r = 0;
-
-			break;
-		}
-	}
-
-	return r;
-}
-
-static int find_free_cblock(struct mq_policy *mq, dm_cblock_t *result)
-{
-	int r;
-
-	if (!any_free_cblocks(mq))
-		return -ENOSPC;
-
-	r = __find_free_cblock(mq, mq->find_free_last_word, mq->find_free_nr_words, result, &mq->find_free_last_word);
-	if (r == -ENOSPC && mq->find_free_last_word)
-		r = __find_free_cblock(mq, 0, mq->find_free_last_word, result, &mq->find_free_last_word);
-
-	return r;
-}
-
 /*----------------------------------------------------------------*/
 
 /*
@@ -520,34 +453,35 @@ static unsigned queue_level(struct entry *e)
 	return min((unsigned) ilog2(e->hit_count), NR_QUEUE_LEVELS - 1u);
 }
 
+static bool in_cache(struct mq_policy *mq, struct entry *e)
+{
+	return in_pool(&mq->cache_pool, e);
+}
+
 /*
  * Inserts the entry into the pre_cache or the cache.  Ensures the cache
- * block is marked as allocated if necc.  Inserts into the hash table.  Sets the
- * tick which records when the entry was last moved about.
+ * block is marked as allocated if necc.  Inserts into the hash table.
+ * Sets the tick which records when the entry was last moved about.
  */
 static void push(struct mq_policy *mq, struct entry *e)
 {
 	e->tick = mq->tick;
 	hash_insert(mq, e);
 
-	if (e->in_cache) {
-		alloc_cblock(mq, e->cblock);
+	if (in_cache(mq, e))
 		queue_push(e->dirty ? &mq->cache_dirty : &mq->cache_clean,
 			   queue_level(e), &e->list);
-	} else
+	else
 		queue_push(&mq->pre_cache, queue_level(e), &e->list);
 }
 
 /*
  * Removes an entry from pre_cache or cache.  Removes from the hash table.
- * Frees off the cache block if necc.
  */
 static void del(struct mq_policy *mq, struct entry *e)
 {
 	queue_remove(&e->list);
 	hash_remove(e);
-	if (e->in_cache)
-		free_cblock(mq, e->cblock);
 }
 
 /*
@@ -564,8 +498,6 @@ static struct entry *pop(struct mq_policy *mq, struct queue *q)
 
 	e = container_of(h, struct entry, list);
 	hash_remove(e);
-	if (e->in_cache)
-		free_cblock(mq, e->cblock);
 
 	return e;
 }
@@ -599,9 +531,7 @@ static void check_generation(struct mq_policy *mq)
 	struct list_head *head;
 	struct entry *e;
 
-	if ((mq->hit_count >= mq->generation_period) &&
-	    (mq->nr_cblocks_allocated == from_cblock(mq->cache_size))) {
-
+	if ((mq->hit_count >= mq->generation_period) && (epool_empty(&mq->cache_pool))) {
 		mq->hit_count = 0;
 		mq->generation++;
 
@@ -668,7 +598,7 @@ static void requeue_and_update_tick(struct mq_policy *mq, struct entry *e)
  * - set the hit count to a hard coded value other than 1, eg, is it better
  *   if it goes in at level 2?
  */
-static int demote_cblock(struct mq_policy *mq, dm_oblock_t *oblock, dm_cblock_t *cblock)
+static int demote_cblock(struct mq_policy *mq, dm_oblock_t *oblock)
 {
 	struct entry *demoted = pop(mq, &mq->cache_clean);
 
@@ -682,12 +612,14 @@ static int demote_cblock(struct mq_policy *mq, dm_oblock_t *oblock, dm_cblock_t
 		 */
 		return -ENOSPC;
 
-	*cblock = demoted->cblock;
 	*oblock = demoted->oblock;
-	demoted->in_cache = false;
-	demoted->dirty = false;
-	demoted->hit_count = 1;
-	push(mq, demoted);
+	free_entry(&mq->cache_pool, demoted);
+
+	/*
+	 * We used to put the demoted block into the pre-cache, but I think
+	 * it's simpler to just let it work it's way up from zero again.
+	 * Stops blocks flickering in and out of the cache.
+	 */
 
 	return 0;
 }
@@ -735,9 +667,9 @@ static int cache_entry_found(struct mq_policy *mq,
 {
 	requeue_and_update_tick(mq, e);
 
-	if (e->in_cache) {
+	if (in_cache(mq, e)) {
 		result->op = POLICY_HIT;
-		result->cblock = e->cblock;
+		result->cblock = infer_cblock(&mq->cache_pool, e);
 	}
 
 	return 0;
@@ -751,11 +683,12 @@ static int pre_cache_to_cache(struct mq_policy *mq, struct entry *e,
 			      struct policy_result *result)
 {
 	int r;
-	dm_cblock_t cblock;
+	struct entry *new_e;
 
-	if (find_free_cblock(mq, &cblock) == -ENOSPC) {
+	/* Ensure there's a free cblock in the cache */
+	if (epool_empty(&mq->cache_pool)) {
 		result->op = POLICY_REPLACE;
-		r = demote_cblock(mq, &result->old_oblock, &cblock);
+		r = demote_cblock(mq, &result->old_oblock);
 		if (r) {
 			result->op = POLICY_MISS;
 			return 0;
@@ -763,12 +696,20 @@ static int pre_cache_to_cache(struct mq_policy *mq, struct entry *e,
 	} else
 		result->op = POLICY_NEW;
 
-	result->cblock = e->cblock = cblock;
+	new_e = alloc_entry(&mq->cache_pool);
+	BUG_ON(!new_e);
+
+	new_e->oblock = e->oblock;
+	new_e->dirty = false;
+	new_e->hit_count = e->hit_count;
+	new_e->generation = e->generation;
+	new_e->tick = e->tick;
 
 	del(mq, e);
-	e->in_cache = true;
-	e->dirty = false;
-	push(mq, e);
+	free_entry(&mq->pre_cache_pool, e);
+	push(mq, new_e);
+
+	result->cblock = infer_cblock(&mq->cache_pool, new_e);
 
 	return 0;
 }
@@ -793,21 +734,10 @@ static int pre_cache_entry_found(struct mq_policy *mq, struct entry *e,
 	return r;
 }
 
-static void insert_entry_in_pre_cache(struct mq_policy *mq,
-				      struct entry *e, dm_oblock_t oblock)
-{
-	e->in_cache = false;
-	e->dirty = false;
-	e->oblock = oblock;
-	e->hit_count = 1;
-	e->generation = mq->generation;
-	push(mq, e);
-}
-
 static void insert_in_pre_cache(struct mq_policy *mq,
 				dm_oblock_t oblock)
 {
-	struct entry *e = alloc_entry(mq);
+	struct entry *e = alloc_entry(&mq->pre_cache_pool);
 
 	if (!e)
 		/*
@@ -821,7 +751,11 @@ static void insert_in_pre_cache(struct mq_policy *mq,
 		return;
 	}
 
-	insert_entry_in_pre_cache(mq, e, oblock);
+	e->dirty = false;
+	e->oblock = oblock;
+	e->hit_count = 1;
+	e->generation = mq->generation;
+	push(mq, e);
 }
 
 static void insert_in_cache(struct mq_policy *mq, dm_oblock_t oblock,
@@ -829,10 +763,10 @@ static void insert_in_cache(struct mq_policy *mq, dm_oblock_t oblock,
 {
 	int r;
 	struct entry *e;
-	dm_cblock_t cblock;
 
-	if (find_free_cblock(mq, &cblock) == -ENOSPC) {
-		r = demote_cblock(mq, &result->old_oblock, &cblock);
+	if (epool_empty(&mq->cache_pool)) {
+		result->op = POLICY_REPLACE;
+		r = demote_cblock(mq, &result->old_oblock);
 		if (unlikely(r)) {
 			result->op = POLICY_MISS;
 			insert_in_pre_cache(mq, oblock);
@@ -842,31 +776,21 @@ static void insert_in_cache(struct mq_policy *mq, dm_oblock_t oblock,
 		/*
 		 * This will always succeed, since we've just demoted.
 		 */
-		e = pop(mq, &mq->pre_cache);
-		result->op = POLICY_REPLACE;
+		e = alloc_entry(&mq->cache_pool);
+		BUG_ON(!e);
 
 	} else {
-		e = alloc_entry(mq);
-		if (unlikely(!e))
-			e = pop(mq, &mq->pre_cache);
-
-		if (unlikely(!e)) {
-			result->op = POLICY_MISS;
-			return;
-		}
-
+		e = alloc_entry(&mq->cache_pool);
 		result->op = POLICY_NEW;
 	}
 
 	e->oblock = oblock;
-	e->cblock = cblock;
-	e->in_cache = true;
 	e->dirty = false;
 	e->hit_count = 1;
 	e->generation = mq->generation;
 	push(mq, e);
 
-	result->cblock = e->cblock;
+	result->cblock = infer_cblock(&mq->cache_pool, e);
 }
 
 static int no_entry_found(struct mq_policy *mq, dm_oblock_t oblock,
@@ -897,13 +821,16 @@ static int map(struct mq_policy *mq, dm_oblock_t oblock,
 	int r = 0;
 	struct entry *e = hash_lookup(mq, oblock);
 
-	if (e && e->in_cache)
+	if (e && in_cache(mq, e))
 		r = cache_entry_found(mq, e, result);
+
 	else if (iot_pattern(&mq->tracker) == PATTERN_SEQUENTIAL)
 		result->op = POLICY_MISS;
+
 	else if (e)
 		r = pre_cache_entry_found(mq, e, can_migrate, discarded_oblock,
 					  data_dir, result);
+
 	else
 		r = no_entry_found(mq, oblock, can_migrate, discarded_oblock,
 				   data_dir, result);
@@ -930,9 +857,9 @@ static void mq_destroy(struct dm_cache_policy *p)
 {
 	struct mq_policy *mq = to_mq_policy(p);
 
-	free_bitset(mq->allocation_bitset);
 	kfree(mq->table);
-	free_entries(mq);
+	epool_exit(&mq->cache_pool);
+	epool_exit(&mq->pre_cache_pool);
 	kfree(mq);
 }
 
@@ -980,8 +907,8 @@ static int mq_lookup(struct dm_cache_policy *p, dm_oblock_t oblock, dm_cblock_t
 		return -EWOULDBLOCK;
 
 	e = hash_lookup(mq, oblock);
-	if (e && e->in_cache) {
-		*cblock = e->cblock;
+	if (e && in_cache(mq, e)) {
+		*cblock = infer_cblock(&mq->cache_pool, e);
 		r = 0;
 	} else
 		r = -ENOENT;
@@ -991,38 +918,34 @@ static int mq_lookup(struct dm_cache_policy *p, dm_oblock_t oblock, dm_cblock_t
 	return r;
 }
 
-/*
- * FIXME: __mq_set_clear_dirty can block due to mutex.
- * Ideally a policy should not block in functions called
- * from the map() function.  Explore using RCU.
- */
-static void __mq_set_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock, bool set)
+static void __mq_set_clear_dirty(struct mq_policy *mq, dm_oblock_t oblock, bool set)
 {
-	struct mq_policy *mq = to_mq_policy(p);
 	struct entry *e;
 
-	mutex_lock(&mq->lock);
 	e = hash_lookup(mq, oblock);
-	if (!e)
-		DMWARN("__mq_set_clear_dirty called for a block that isn't in the cache");
-	else {
-		BUG_ON(!e->in_cache);
+	BUG_ON(!e || !in_cache(mq, e));
 
-		del(mq, e);
-		e->dirty = set;
-		push(mq, e);
-	}
-	mutex_unlock(&mq->lock);
+	del(mq, e);
+	e->dirty = set;
+	push(mq, e);
 }
 
 static void mq_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
 {
-	__mq_set_clear_dirty(p, oblock, true);
+	struct mq_policy *mq = to_mq_policy(p);
+
+	mutex_lock(&mq->lock);
+	__mq_set_clear_dirty(mq, oblock, true);
+	mutex_unlock(&mq->lock);
 }
 
 static void mq_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
 {
-	__mq_set_clear_dirty(p, oblock, false);
+	struct mq_policy *mq = to_mq_policy(p);
+
+	mutex_lock(&mq->lock);
+	__mq_set_clear_dirty(mq, oblock, false);
+	mutex_unlock(&mq->lock);
 }
 
 static int mq_load_mapping(struct dm_cache_policy *p,
@@ -1032,13 +955,8 @@ static int mq_load_mapping(struct dm_cache_policy *p,
 	struct mq_policy *mq = to_mq_policy(p);
 	struct entry *e;
 
-	e = alloc_entry(mq);
-	if (!e)
-		return -ENOMEM;
-
-	e->cblock = cblock;
+	e = alloc_particular_entry(&mq->cache_pool, cblock);
 	e->oblock = oblock;
-	e->in_cache = true;
 	e->dirty = false;	/* this gets corrected in a minute */
 	e->hit_count = hint_valid ? hint : 1;
 	e->generation = mq->generation;
@@ -1047,52 +965,58 @@ static int mq_load_mapping(struct dm_cache_policy *p,
 	return 0;
 }
 
+static int mq_save_hints(struct mq_policy *mq, struct queue *q,
+			 policy_walk_fn fn, void *context)
+{
+	int r;
+	unsigned level;
+	struct entry *e;
+
+	for (level = 0; level < NR_QUEUE_LEVELS; level++)
+		list_for_each_entry(e, q->qs + level, list) {
+			r = fn(context, infer_cblock(&mq->cache_pool, e),
+			       e->oblock, e->hit_count);
+			if (r)
+				return r;
+		}
+
+	return 0;
+}
+
 static int mq_walk_mappings(struct dm_cache_policy *p, policy_walk_fn fn,
 			    void *context)
 {
 	struct mq_policy *mq = to_mq_policy(p);
 	int r = 0;
-	struct entry *e;
-	unsigned level;
 
 	mutex_lock(&mq->lock);
 
-	for (level = 0; level < NR_QUEUE_LEVELS; level++)
-		list_for_each_entry(e, &mq->cache_clean.qs[level], list) {
-			r = fn(context, e->cblock, e->oblock, e->hit_count);
-			if (r)
-				goto out;
-		}
-
-	for (level = 0; level < NR_QUEUE_LEVELS; level++)
-		list_for_each_entry(e, &mq->cache_dirty.qs[level], list) {
-			r = fn(context, e->cblock, e->oblock, e->hit_count);
-			if (r)
-				goto out;
-		}
+	r = mq_save_hints(mq, &mq->cache_clean, fn, context);
+	if (!r)
+		r = mq_save_hints(mq, &mq->cache_dirty, fn, context);
 
-out:
 	mutex_unlock(&mq->lock);
 
 	return r;
 }
 
-static void mq_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
+static void __remove_mapping(struct mq_policy *mq, dm_oblock_t oblock)
 {
-	struct mq_policy *mq = to_mq_policy(p);
 	struct entry *e;
 
-	mutex_lock(&mq->lock);
-
 	e = hash_lookup(mq, oblock);
-
-	BUG_ON(!e || !e->in_cache);
+	BUG_ON(!e || !in_cache(mq, e));
 
 	del(mq, e);
-	e->in_cache = false;
-	e->dirty = false;
-	push(mq, e);
+	free_entry(&mq->cache_pool, e);
+}
+
+static void mq_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	struct mq_policy *mq = to_mq_policy(p);
 
+	mutex_lock(&mq->lock);
+	__remove_mapping(mq, oblock);
 	mutex_unlock(&mq->lock);
 }
 
@@ -1105,7 +1029,7 @@ static int __mq_writeback_work(struct mq_policy *mq, dm_oblock_t *oblock,
 		return -ENODATA;
 
 	*oblock = e->oblock;
-	*cblock = e->cblock;
+	*cblock = infer_cblock(&mq->cache_pool, e);
 	e->dirty = false;
 	push(mq, e);
 
@@ -1125,17 +1049,17 @@ static int mq_writeback_work(struct dm_cache_policy *p, dm_oblock_t *oblock,
 	return r;
 }
 
-static void force_mapping(struct mq_policy *mq,
-			  dm_oblock_t current_oblock, dm_oblock_t new_oblock)
+static void __force_mapping(struct mq_policy *mq,
+			    dm_oblock_t current_oblock, dm_oblock_t new_oblock)
 {
 	struct entry *e = hash_lookup(mq, current_oblock);
 
-	BUG_ON(!e || !e->in_cache);
-
-	del(mq, e);
-	e->oblock = new_oblock;
-	e->dirty = true;
-	push(mq, e);
+	if (e && in_cache(mq, e)) {
+		del(mq, e);
+		e->oblock = new_oblock;
+		e->dirty = true;
+		push(mq, e);
+	}
 }
 
 static void mq_force_mapping(struct dm_cache_policy *p,
@@ -1144,7 +1068,7 @@ static void mq_force_mapping(struct dm_cache_policy *p,
 	struct mq_policy *mq = to_mq_policy(p);
 
 	mutex_lock(&mq->lock);
-	force_mapping(mq, current_oblock, new_oblock);
+	__force_mapping(mq, current_oblock, new_oblock);
 	mutex_unlock(&mq->lock);
 }
 
@@ -1154,7 +1078,7 @@ static dm_cblock_t mq_residency(struct dm_cache_policy *p)
 	struct mq_policy *mq = to_mq_policy(p);
 
 	mutex_lock(&mq->lock);
-	r = to_cblock(mq->nr_cblocks_allocated);
+	r = to_cblock(mq->cache_pool.nr_allocated);
 	mutex_unlock(&mq->lock);
 
 	return r;
@@ -1227,7 +1151,6 @@ static struct dm_cache_policy *mq_create(dm_cblock_t cache_size,
 					 sector_t origin_size,
 					 sector_t cache_block_size)
 {
-	int r;
 	struct mq_policy *mq = kzalloc(sizeof(*mq), GFP_KERNEL);
 
 	if (!mq)
@@ -1235,8 +1158,18 @@ static struct dm_cache_policy *mq_create(dm_cblock_t cache_size,
 
 	init_policy_functions(mq);
 	iot_init(&mq->tracker, SEQUENTIAL_THRESHOLD_DEFAULT, RANDOM_THRESHOLD_DEFAULT);
-
 	mq->cache_size = cache_size;
+
+	if (epool_init(&mq->pre_cache_pool, from_cblock(cache_size))) {
+		DMERR("couldn't initialize pool of pre-cache entries");
+		goto bad_pre_cache_init;
+	}
+
+	if (epool_init(&mq->cache_pool, from_cblock(cache_size))) {
+		DMERR("couldn't initialize pool of cache entries");
+		goto bad_cache_init;
+	}
+
 	mq->tick_protected = 0;
 	mq->tick = 0;
 	mq->hit_count = 0;
@@ -1244,8 +1177,6 @@ static struct dm_cache_policy *mq_create(dm_cblock_t cache_size,
 	mq->promote_threshold = 0;
 	mutex_init(&mq->lock);
 	spin_lock_init(&mq->tick_lock);
-	mq->find_free_nr_words = dm_div_up(from_cblock(mq->cache_size), BITS_PER_LONG);
-	mq->find_free_last_word = 0;
 
 	queue_init(&mq->pre_cache);
 	queue_init(&mq->cache_clean);
@@ -1253,31 +1184,19 @@ static struct dm_cache_policy *mq_create(dm_cblock_t cache_size,
 
 	mq->generation_period = max((unsigned) from_cblock(cache_size), 1024U);
 
-	mq->nr_entries = 2 * from_cblock(cache_size);
-	r = alloc_entries(mq, mq->nr_entries);
-	if (r)
-		goto bad_cache_alloc;
-
-	mq->nr_entries_allocated = 0;
-	mq->nr_cblocks_allocated = 0;
-
 	mq->nr_buckets = next_power(from_cblock(cache_size) / 2, 16);
 	mq->hash_bits = ffs(mq->nr_buckets) - 1;
 	mq->table = kzalloc(sizeof(*mq->table) * mq->nr_buckets, GFP_KERNEL);
 	if (!mq->table)
 		goto bad_alloc_table;
 
-	mq->allocation_bitset = alloc_bitset(from_cblock(cache_size));
-	if (!mq->allocation_bitset)
-		goto bad_alloc_bitset;
-
 	return &mq->policy;
 
-bad_alloc_bitset:
-	kfree(mq->table);
 bad_alloc_table:
-	free_entries(mq);
-bad_cache_alloc:
+	epool_exit(&mq->cache_pool);
+bad_cache_init:
+	epool_exit(&mq->pre_cache_pool);
+bad_pre_cache_init:
 	kfree(mq);
 
 	return NULL;
@@ -1287,7 +1206,7 @@ bad_cache_alloc:
 
 static struct dm_cache_policy_type mq_policy_type = {
 	.name = "mq",
-	.version = {1, 0, 0},
+	.version = {1, 1, 0},
 	.hint_size = 4,
 	.owner = THIS_MODULE,
 	.create = mq_create
@@ -1295,7 +1214,7 @@ static struct dm_cache_policy_type mq_policy_type = {
 
 static struct dm_cache_policy_type default_policy_type = {
 	.name = "default",
-	.version = {1, 0, 0},
+	.version = {1, 1, 0},
 	.hint_size = 4,
 	.owner = THIS_MODULE,
 	.create = mq_create
-- 
1.7.4.4
