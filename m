From: Jan Blunck <jblunck@suse.de>
Subject: [patch 08/11] dm: remove SECTOR_SHIFT define
Date: Fri, 10 Aug 2007 22:02:12 +0200
Message-ID: <42082.7044094496$1186776762@news.gmane.org>
References: <20070810200204.455820246@suse.de>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm/dm-remove-SECTOR_SHIFT.diff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Sector size on Linux is always 512 bytes. Don't even try to give the
impression this is changeable.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-io.c     |    3 +--
 drivers/md/dm-stripe.c |    2 +-
 drivers/md/dm-table.c  |    4 ++--
 drivers/md/dm.c        |    2 +-
 drivers/md/dm.h        |    2 --
 5 files changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -293,8 +293,7 @@ static void do_region(int rw, unsigned i
 		 * bvec for bio_get/set_region() and decrement bi_max_vecs
 		 * to hide it from bio_add_page().
 		 */
-		num_bvecs = dm_sector_div_up(remaining,
-					     (PAGE_SIZE >> SECTOR_SHIFT));
+		num_bvecs = dm_sector_div_up(remaining, PAGE_SIZE >> 9);
 		num_bvecs = 1 + min_t(int, bio_get_nr_vecs(where->bdev),
 				      num_bvecs);
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -100,7 +100,7 @@ static int stripe_ctr(struct dm_target *
 	 * chunk_size is a power of two
 	 */
 	if (!chunk_size || (chunk_size & (chunk_size - 1)) ||
-	    (chunk_size < (PAGE_SIZE >> SECTOR_SHIFT))) {
+	    (chunk_size < (PAGE_SIZE >> 9))) {
 		ti->error = "Invalid chunk size";
 		return -EINVAL;
 	}
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -428,7 +428,7 @@ static void close_dev(struct dm_dev *d, 
  */
 static int check_device_area(struct dm_dev *dd, sector_t start, sector_t len)
 {
-	sector_t dev_size = dd->bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	sector_t dev_size = dd->bdev->bd_inode->i_size >> 9;
 
 	if (!dev_size)
 		return 1;
@@ -702,7 +702,7 @@ static void check_for_valid_limits(struc
 	if (!rs->max_hw_segments)
 		rs->max_hw_segments = MAX_HW_SEGMENTS;
 	if (!rs->hardsect_size)
-		rs->hardsect_size = 1 << SECTOR_SHIFT;
+		rs->hardsect_size = 512;
 	if (!rs->max_segment_size)
 		rs->max_segment_size = MAX_SEGMENT_SIZE;
 	if (!rs->seg_boundary_mask)
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1104,7 +1104,7 @@ static void __set_size(struct mapped_dev
 	set_capacity(md->disk, size);
 
 	mutex_lock(&md->suspended_bdev->bd_inode->i_mutex);
-	i_size_write(md->suspended_bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
+	i_size_write(md->suspended_bdev->bd_inode, (loff_t)size << 9);
 	mutex_unlock(&md->suspended_bdev->bd_inode->i_mutex);
 }
 
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -62,8 +62,6 @@
 #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
 			  0 : scnprintf(result + sz, maxlen - sz, x))
 
-#define SECTOR_SHIFT 9
-
 /*
  * Definitions of return values from target end_io function.
  */

-- 
