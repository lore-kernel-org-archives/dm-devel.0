From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 6/6] dm cache: add cache block invalidation
	support
Date: Mon, 11 Nov 2013 12:20:48 -0500
Message-ID: <1384190448-3861-7-git-send-email-snitzer@redhat.com>
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

Cache block invalidation is removing an entry from the cache without
writing it back.  Cache blocks can be invalidated via the
'invalidate_cblocks' message, which takes an arbitrary number of cblock
ranges:
   invalidate_cblocks [<cblock>|<cblock begin>-<cblock end>]*

E.g.
   dmsetup message my_cache 0 invalidate_cblocks 2345 3456-4567 5678-6789

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/cache.txt |   12 ++-
 drivers/md/dm-cache-target.c          |  225 ++++++++++++++++++++++++++++++++-
 2 files changed, 233 insertions(+), 4 deletions(-)

diff --git a/Documentation/device-mapper/cache.txt b/Documentation/device-mapper/cache.txt
index ff6639f..fc9d2df 100644
--- a/Documentation/device-mapper/cache.txt
+++ b/Documentation/device-mapper/cache.txt
@@ -244,12 +244,22 @@ The message format is:
 E.g.
    dmsetup message my_cache 0 sequential_threshold 1024
 
+
+Invalidation is removing an entry from the cache without writing it
+back.  Cache blocks can be invalidated via the invalidate_cblocks
+message, which takes an arbitrary number of cblock ranges.
+
+   invalidate_cblocks [<cblock>|<cblock begin>-<cblock end>]*
+
+E.g.
+   dmsetup message my_cache 0 invalidate_cblocks 2345 3456-4567 5678-6789
+
 Examples
 ========
 
 The test suite can be found here:
 
-https://github.com/jthornber/thinp-test-suite
+https://github.com/jthornber/device-mapper-test-suite
 
 dmsetup create my_cache --table '0 41943040 cache /dev/mapper/metadata \
 	/dev/mapper/ssd /dev/mapper/origin 512 1 writeback default 0'
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 8c02177..41e664b 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -150,6 +150,25 @@ struct cache_stats {
 	atomic_t discard_count;
 };
 
+/*
+ * Defines a range of cblocks, begin to (end - 1) are in the range.  end is
+ * the one-past-the-end value.
+ */
+struct cblock_range {
+	dm_cblock_t begin;
+	dm_cblock_t end;
+};
+
+struct invalidation_request {
+	struct list_head list;
+	struct cblock_range *cblocks;
+
+	atomic_t complete;
+	int err;
+
+	wait_queue_head_t result_wait;
+};
+
 struct cache {
 	struct dm_target *ti;
 	struct dm_target_callbacks callbacks;
@@ -241,6 +260,7 @@ struct cache {
 
 	bool need_tick_bio:1;
 	bool sized:1;
+	bool invalidate:1;
 	bool commit_requested:1;
 	bool loaded_mappings:1;
 	bool loaded_discards:1;
@@ -251,6 +271,12 @@ struct cache {
 	struct cache_features features;
 
 	struct cache_stats stats;
+
+	/*
+	 * Invalidation fields.
+	 */
+	spinlock_t invalidation_lock;
+	struct list_head invalidation_requests;
 };
 
 struct per_bio_data {
@@ -283,6 +309,7 @@ struct dm_cache_migration {
 	bool demote:1;
 	bool promote:1;
 	bool requeue_holder:1;
+	bool invalidate:1;
 
 	struct dm_bio_prison_cell *old_ocell;
 	struct dm_bio_prison_cell *new_ocell;
@@ -904,8 +931,11 @@ static void migration_success_post_commit(struct dm_cache_migration *mg)
 			list_add_tail(&mg->list, &cache->quiesced_migrations);
 			spin_unlock_irqrestore(&cache->lock, flags);
 
-		} else
+		} else {
+			if (mg->invalidate)
+				policy_remove_mapping(cache->policy, mg->old_oblock);
 			cleanup_migration(mg);
+		}
 
 	} else {
 		if (mg->requeue_holder)
@@ -1115,6 +1145,7 @@ static void promote(struct cache *cache, struct prealloc *structs,
 	mg->demote = false;
 	mg->promote = true;
 	mg->requeue_holder = true;
+	mg->invalidate = false;
 	mg->cache = cache;
 	mg->new_oblock = oblock;
 	mg->cblock = cblock;
@@ -1137,6 +1168,7 @@ static void writeback(struct cache *cache, struct prealloc *structs,
 	mg->demote = false;
 	mg->promote = false;
 	mg->requeue_holder = true;
+	mg->invalidate = false;
 	mg->cache = cache;
 	mg->old_oblock = oblock;
 	mg->cblock = cblock;
@@ -1161,6 +1193,7 @@ static void demote_then_promote(struct cache *cache, struct prealloc *structs,
 	mg->demote = true;
 	mg->promote = true;
 	mg->requeue_holder = true;
+	mg->invalidate = false;
 	mg->cache = cache;
 	mg->old_oblock = old_oblock;
 	mg->new_oblock = new_oblock;
@@ -1188,6 +1221,7 @@ static void invalidate(struct cache *cache, struct prealloc *structs,
 	mg->demote = true;
 	mg->promote = false;
 	mg->requeue_holder = true;
+	mg->invalidate = true;
 	mg->cache = cache;
 	mg->old_oblock = oblock;
 	mg->cblock = cblock;
@@ -1525,6 +1559,58 @@ static void writeback_some_dirty_blocks(struct cache *cache)
 }
 
 /*----------------------------------------------------------------
+ * Invalidations.
+ * Dropping something from the cache *without* writing back.
+ *--------------------------------------------------------------*/
+
+static void process_invalidation_request(struct cache *cache, struct invalidation_request *req)
+{
+	int r = 0;
+	uint64_t begin = from_cblock(req->cblocks->begin);
+	uint64_t end = from_cblock(req->cblocks->end);
+
+	while (begin != end) {
+		r = policy_remove_cblock(cache->policy, to_cblock(begin));
+		if (!r) {
+			r = dm_cache_remove_mapping(cache->cmd, to_cblock(begin));
+			if (r)
+				break;
+
+		} else if (r == -ENODATA) {
+			/* harmless, already unmapped */
+			r = 0;
+
+		} else {
+			DMERR("policy_remove_cblock failed");
+			break;
+		}
+
+		begin++;
+        }
+
+	cache->commit_requested = true;
+
+	req->err = r;
+	atomic_set(&req->complete, 1);
+
+	wake_up(&req->result_wait);
+}
+
+static void process_invalidation_requests(struct cache *cache)
+{
+	struct list_head list;
+	struct invalidation_request *req, *tmp;
+
+	INIT_LIST_HEAD(&list);
+	spin_lock(&cache->invalidation_lock);
+	list_splice_init(&cache->invalidation_requests, &list);
+	spin_unlock(&cache->invalidation_lock);
+
+	list_for_each_entry_safe (req, tmp, &list, list)
+		process_invalidation_request(cache, req);
+}
+
+/*----------------------------------------------------------------
  * Main worker loop
  *--------------------------------------------------------------*/
 static bool is_quiescing(struct cache *cache)
@@ -1593,7 +1679,8 @@ static int more_work(struct cache *cache)
 			!bio_list_empty(&cache->deferred_writethrough_bios) ||
 			!list_empty(&cache->quiesced_migrations) ||
 			!list_empty(&cache->completed_migrations) ||
-			!list_empty(&cache->need_commit_migrations);
+			!list_empty(&cache->need_commit_migrations) ||
+			cache->invalidate;
 }
 
 static void do_worker(struct work_struct *ws)
@@ -1605,6 +1692,7 @@ static void do_worker(struct work_struct *ws)
 			writeback_some_dirty_blocks(cache);
 			process_deferred_writethrough_bios(cache);
 			process_deferred_bios(cache);
+			process_invalidation_requests(cache);
 		}
 
 		process_migrations(cache, &cache->quiesced_migrations, issue_copy);
@@ -2271,6 +2359,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 
 	cache->need_tick_bio = true;
 	cache->sized = false;
+	cache->invalidate = false;
 	cache->commit_requested = false;
 	cache->loaded_mappings = false;
 	cache->loaded_discards = false;
@@ -2284,6 +2373,9 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	atomic_set(&cache->stats.commit_count, 0);
 	atomic_set(&cache->stats.discard_count, 0);
 
+	spin_lock_init(&cache->invalidation_lock);
+	INIT_LIST_HEAD(&cache->invalidation_requests);
+
 	*result = cache;
 	return 0;
 
@@ -2833,7 +2925,128 @@ err:
 }
 
 /*
- * Supports <key> <value>.
+ * A cache block range can take two forms:
+ *
+ * i) A single cblock, eg. '3456'
+ * ii) A begin and end cblock with dots between, eg. 123-234
+ */
+static int parse_cblock_range(struct cache *cache, const char *str,
+			      struct cblock_range *result)
+{
+	char dummy;
+	uint64_t b, e;
+	int r;
+
+	/*
+	 * Try and parse form (ii) first.
+	 */
+	r = sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
+	if (r < 0)
+		return r;
+
+	if (r == 2) {
+		result->begin = to_cblock(b);
+		result->end = to_cblock(e);
+		return 0;
+	}
+
+	/*
+	 * That didn't work, try form (i).
+	 */
+	r = sscanf(str, "%llu%c", &b, &dummy);
+	if (r < 0)
+		return r;
+
+	if (r == 1) {
+		result->begin = to_cblock(b);
+		result->end = to_cblock(from_cblock(result->begin) + 1u);
+		return 0;
+	}
+
+	DMERR("invalid cblock range '%s'", str);
+	return -EINVAL;
+}
+
+static int validate_cblock_range(struct cache *cache, struct cblock_range *range)
+{
+	uint64_t b = from_cblock(range->begin);
+	uint64_t e = from_cblock(range->end);
+	uint64_t n = from_cblock(cache->cache_size);
+
+	if (b >= n) {
+		DMERR("begin cblock out of range: %llu >= %llu", b, n);
+		return -EINVAL;
+	}
+
+	if (e > n) {
+		DMERR("end cblock out of range: %llu > %llu", e, n);
+		return -EINVAL;
+	}
+
+	if (b >= e) {
+		DMERR("invalid cblock range: %llu >= %llu", b, e);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int request_invalidation(struct cache *cache, struct cblock_range *range)
+{
+	struct invalidation_request req;
+
+	INIT_LIST_HEAD(&req.list);
+	req.cblocks = range;
+	atomic_set(&req.complete, 0);
+	req.err = 0;
+	init_waitqueue_head(&req.result_wait);
+
+	spin_lock(&cache->invalidation_lock);
+	list_add(&req.list, &cache->invalidation_requests);
+	spin_unlock(&cache->invalidation_lock);
+	wake_worker(cache);
+
+	wait_event(req.result_wait, atomic_read(&req.complete));
+	return req.err;
+}
+
+static int process_invalidate_cblocks_message(struct cache *cache, unsigned count,
+					      const char **cblock_ranges)
+{
+	int r = 0;
+	unsigned i;
+	struct cblock_range range;
+
+	if (!passthrough_mode(&cache->features)) {
+		DMERR("cache has to be in passthrough mode for invalidation");
+		return -EPERM;
+	}
+
+	for (i = 0; i < count; i++) {
+		r = parse_cblock_range(cache, cblock_ranges[i], &range);
+		if (r)
+			break;
+
+		r = validate_cblock_range(cache, &range);
+		if (r)
+			break;
+
+		/*
+		 * Pass begin and end origin blocks to the worker and wake it.
+		 */
+		r = request_invalidation(cache, &range);
+		if (r)
+			break;
+	}
+
+	return r;
+}
+
+/*
+ * Supports
+ *	"<key> <value>"
+ * and
+ *     "invalidate_cblocks [(<begin>)|(<begin>-<end>)]*
  *
  * The key migration_threshold is supported by the cache target core.
  */
@@ -2841,6 +3054,12 @@ static int cache_message(struct dm_target *ti, unsigned argc, char **argv)
 {
 	struct cache *cache = ti->private;
 
+	if (!argc)
+		return -EINVAL;
+
+	if (!strcmp(argv[0], "invalidate_cblocks"))
+		return process_invalidate_cblocks_message(cache, argc - 1, (const char **) argv + 1);
+
 	if (argc != 2)
 		return -EINVAL;
 
-- 
1.7.4.4
