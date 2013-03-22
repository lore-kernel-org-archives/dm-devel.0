From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] dm: dm-cache fails to write the cache device in writethrough
 mode
Date: Fri, 22 Mar 2013 13:11:51 -0700
Message-ID: <20130322201151.GB5357@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Paul Taysom <taysom@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org
List-Id: dm-devel.ids

The new writethrough strategy for dm-cache issues a bio to the origin device,
remaps the bio to the cache device, and issues the bio to the cache device.
However, the block layer modifies bi_sector and bi_size, so we need to preserve
these or else nothing gets written to the cache (bi_size == 0).  This fixes the
problem where someone writes a block through the cache, but a subsequent reread
(from the cache) returns old contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/md/dm-cache-target.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 66120bd..0db0ad2 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -205,6 +205,8 @@ struct per_bio_data {
 	struct cache *cache;
 	dm_cblock_t cblock;
 	bio_end_io_t *saved_bi_end_io;
+	unsigned int bi_size;
+	sector_t bi_sector;
 };
 
 struct dm_cache_migration {
@@ -643,6 +645,8 @@ static void writethrough_endio(struct bio *bio, int err)
 		return;
 	}
 
+	bio->bi_sector = pb->bi_sector;
+	bio->bi_size = pb->bi_size;
 	remap_to_cache(pb->cache, bio, pb->cblock);
 
 	/*
@@ -667,6 +671,12 @@ static void remap_to_origin_then_cache(struct cache *cache, struct bio *bio,
 	pb->cache = cache;
 	pb->cblock = cblock;
 	pb->saved_bi_end_io = bio->bi_end_io;
+	/*
+	 * The block layer modifies bi_size and bi_sector, so we must save
+	 * them for when we re-issue the bio against the cache device.
+	 */
+	pb->bi_size = bio->bi_size;
+	pb->bi_sector = bio->bi_sector;
 	bio->bi_end_io = writethrough_endio;
 
 	remap_to_origin_clear_discard(pb->cache, bio, oblock);
