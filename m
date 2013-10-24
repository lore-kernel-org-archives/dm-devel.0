From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 14/24] dm cache: use is_write_io() in more places
Date: Thu, 24 Oct 2013 14:30:27 -0400
Message-ID: <1382639437-27007-15-git-send-email-snitzer@redhat.com>
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

From: Heinz Mauelshagen <heinzm@redhat.com>

Use is_write_io() consistently where it is makes sense.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-target.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 3bf8cc7..5fb4d64 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -631,12 +631,17 @@ static void check_if_tick_bio_needed(struct cache *cache, struct bio *bio)
 	spin_unlock_irqrestore(&cache->lock, flags);
 }
 
+static bool is_write_io(struct bio *bio)
+{
+	return bio_data_dir(bio) == WRITE;
+}
+
 static void remap_to_origin_clear_discard(struct cache *cache, struct bio *bio,
 				  dm_oblock_t oblock)
 {
 	check_if_tick_bio_needed(cache, bio);
 	remap_to_origin(cache, bio);
-	if (bio_data_dir(bio) == WRITE)
+	if (is_write_io(bio))
 		clear_discard(cache, oblock_to_dblock(cache, oblock));
 }
 
@@ -644,7 +649,7 @@ static void remap_to_cache_dirty(struct cache *cache, struct bio *bio,
 				 dm_oblock_t oblock, dm_cblock_t cblock)
 {
 	remap_to_cache(cache, bio, cblock);
-	if (bio_data_dir(bio) == WRITE) {
+	if (is_write_io(bio)) {
 		set_dirty(cache, oblock, cblock);
 		clear_discard(cache, oblock_to_dblock(cache, oblock));
 	}
@@ -1172,21 +1177,16 @@ static bool spare_migration_bandwidth(struct cache *cache)
 	return current_volume < cache->migration_threshold;
 }
 
-static bool is_write_io(struct bio *bio)
-{
-	return bio_data_dir(bio) == WRITE;
-}
-
 static void inc_hit_counter(struct cache *cache, struct bio *bio)
 {
-	atomic_inc(bio_data_dir(bio) == READ ?
-		   &cache->stats.read_hit : &cache->stats.write_hit);
+	atomic_inc(is_write_io(bio) ?
+		   &cache->stats.write_hit : &cache->stats.read_hit);
 }
 
 static void inc_miss_counter(struct cache *cache, struct bio *bio)
 {
-	atomic_inc(bio_data_dir(bio) == READ ?
-		   &cache->stats.read_miss : &cache->stats.write_miss);
+	atomic_inc(is_write_io(bio) ?
+		   &cache->stats.write_miss : &cache->stats.read_miss);
 }
 
 static void issue_cache_bio(struct cache *cache, struct bio *bio,
-- 
1.8.1.4
