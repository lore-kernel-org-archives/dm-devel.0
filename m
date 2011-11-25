From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm: fix discard support in dm_io
Date: Fri, 25 Nov 2011 20:28:09 +0100
Message-ID: <1322249289-1263-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: lczerner@redhat.com, snitzer@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

This patch adds support for discard request to dm_io interface.

Currently dm_mirror can send REQ_DISCARD bios if running over
discard enabled device and without support in dm_io the system
crashes badly.

BUG: unable to handle kernel paging request at 00800000
IP:  __bio_add_page.part.17+0xf5/0x1e0
...
 bio_add_page+0x56/0x70
 dispatch_io+0x1cf/0x240 [dm_mod]
 ? km_get_page+0x50/0x50 [dm_mod]
 ? vm_next_page+0x20/0x20 [dm_mod]
 ? mirror_flush+0x130/0x130 [dm_mirror]
 dm_io+0xdc/0x2b0 [dm_mod]
...

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-io.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index ad2eba4..81bfce7 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -296,6 +296,8 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 	unsigned offset;
 	unsigned num_bvecs;
 	sector_t remaining = where->count;
+	struct request_queue *q = bdev_get_queue(where->bdev);
+	sector_t discard_sectors;
 
 	/*
 	 * where->count may be zero if rw holds a flush and we need to
@@ -305,9 +307,13 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		/*
 		 * Allocate a suitably sized-bio.
 		 */
-		num_bvecs = dm_sector_div_up(remaining,
-					     (PAGE_SIZE >> SECTOR_SHIFT));
-		num_bvecs = min_t(int, bio_get_nr_vecs(where->bdev), num_bvecs);
+		if (rw & REQ_DISCARD)
+			num_bvecs = 1;
+		else {
+			num_bvecs = dm_sector_div_up(remaining,
+						     (PAGE_SIZE >> SECTOR_SHIFT));
+			num_bvecs = min_t(int, bio_get_nr_vecs(where->bdev), num_bvecs);
+		}
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
@@ -315,10 +321,16 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		bio->bi_destructor = dm_bio_destructor;
 		store_io_and_region_in_bio(bio, io, region);
 
-		/*
-		 * Try and add as many pages as possible.
-		 */
-		while (remaining) {
+		if (rw & REQ_DISCARD) {
+			discard_sectors = min_t(sector_t,
+						q->limits.max_discard_sectors,
+						remaining);
+			bio->bi_size = discard_sectors << SECTOR_SHIFT;
+			remaining -= discard_sectors;
+		} else while (remaining) {
+			/*
+			 * Try and add as many pages as possible.
+			 */
 			dp->get_page(dp, &page, &len, &offset);
 			len = min(len, to_bytes(remaining));
 			if (!bio_add_page(bio, page, len, offset))
-- 
1.7.7.3
