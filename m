From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: [PATCH] dm cache: fix race affecting dirty block count
Date: Thu, 31 Jul 2014 21:31:27 +0300
Message-ID: <1406831487-18750-1-git-send-email-anssi.hannula@iki.fi>
References: <53D32999.6080206@iki.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53D32999.6080206@iki.fi>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: dm-devel.ids

nr_dirty is updated without locking, causing it to drift so that it is
non-zero (either a small positive integer, or a very large one when an
underflow occurs) even when there are no actual dirty blocks.

Fix that by using an atomic type for nr_dirty.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Joe Thornber <ejt@redhat.com>
Cc: stable@vger.kernel.org

---

So here's a patch for the issue I reported a few days ago.

I'm not sure what the actual effects of having wrong nr_dirty are
beyond the wrong value reported to userspace. Having wrong nr_dirty
causes dm_table_event(cache->ti->table) to be called at incorrect times,
but I'm not sure what the implications of that are.

So someone more knowledged should really amend my commit message
accordingly so that it explains the user-visible issues :)

I did notice that after a reboot (after having incorrect nr_dirty) the
entire cache was considered to be dirty and a full writeback occurred,
but I don't know if that was related at all.


 drivers/md/dm-cache-target.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 0df3ec085ebb..83a7eb5ef113 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -154,7 +154,7 @@ struct cache {
 	/*
 	 * cache_size entries, dirty if set
 	 */
-	dm_cblock_t nr_dirty;
+	atomic_t nr_dirty;
 	unsigned long *dirty_bitset;
 
 	/*
@@ -403,7 +403,7 @@ static bool is_dirty(struct cache *cache, dm_cblock_t b)
 static void set_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cblock)
 {
 	if (!test_and_set_bit(from_cblock(cblock), cache->dirty_bitset)) {
-		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) + 1);
+		atomic_inc(&cache->nr_dirty);
 		policy_set_dirty(cache->policy, oblock);
 	}
 }
@@ -412,8 +412,7 @@ static void clear_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cbl
 {
 	if (test_and_clear_bit(from_cblock(cblock), cache->dirty_bitset)) {
 		policy_clear_dirty(cache->policy, oblock);
-		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) - 1);
-		if (!from_cblock(cache->nr_dirty))
+		if (atomic_dec_return(&cache->nr_dirty) == 0)
 			dm_table_event(cache->ti->table);
 	}
 }
@@ -2003,7 +2002,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	init_waitqueue_head(&cache->migration_wait);
 
 	r = -ENOMEM;
-	cache->nr_dirty = 0;
+	atomic_set(&cache->nr_dirty, 0);
 	cache->dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));
 	if (!cache->dirty_bitset) {
 		*error = "could not allocate dirty bitset";
@@ -2513,7 +2512,7 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 		       (unsigned) atomic_read(&cache->stats.demotion),
 		       (unsigned) atomic_read(&cache->stats.promotion),
 		       (unsigned long long) from_cblock(residency),
-		       cache->nr_dirty);
+		       (unsigned) atomic_read(&cache->nr_dirty));
 
 		if (cache->features.write_through)
 			DMEMIT("1 writethrough ");
-- 
1.8.4.5
