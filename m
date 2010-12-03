From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 11 of 15] md new param to_sync_page_io
Date: Fri, 3 Dec 2010 13:55:31 -0600
Message-ID: <201012031955.oB3JtV1K003563@hydrogen.msp.redhat.com>
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
List-Id: dm-devel.ids

Patch name: md-new-param-to_sync_page_io.patch

Add new parameter to 'sync_page_io'.

The new parameter allows us to distinguish between metadata and data
operations.  This becomes important later when we add the ability to
use separate devices for data and metadata.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/bitmap.c
===================================================================
--- linux-2.6.orig/drivers/md/bitmap.c
+++ linux-2.6/drivers/md/bitmap.c
@@ -213,7 +213,7 @@ static struct page *read_sb_page(mddev_t
 
 		if (sync_page_io(rdev, target,
 				 roundup(size, bdev_logical_block_size(rdev->bdev)),
-				 page, READ)) {
+				 page, READ, 1)) {
 			page->index = index;
 			attach_page_buffers(page, NULL); /* so that free_buffer will
 							  * quietly no-op */
Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -794,7 +794,7 @@ static void bi_complete(struct bio *bio,
 }
 
 int sync_page_io(mdk_rdev_t *rdev, sector_t sector, int size,
-		 struct page *page, int rw)
+		 struct page *page, int rw, int metadata_op)
 {
 	struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, rdev->mddev);
 	struct completion event;
@@ -828,7 +828,7 @@ static int read_disk_sb(mdk_rdev_t * rde
 		return 0;
 
 
-	if (!sync_page_io(rdev, rdev->sb_start, size, rdev->sb_page, READ))
+	if (!sync_page_io(rdev, rdev->sb_start, size, rdev->sb_page, READ, 1))
 		goto fail;
 	rdev->sb_loaded = 1;
 	return 0;
Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h
+++ linux-2.6/drivers/md/md.h
@@ -493,7 +493,7 @@ extern void md_super_write(mddev_t *mdde
 			   sector_t sector, int size, struct page *page);
 extern void md_super_wait(mddev_t *mddev);
 extern int sync_page_io(mdk_rdev_t *rdev, sector_t sector, int size,
-			struct page *page, int rw);
+			struct page *page, int rw, int metadata_op);
 extern void md_do_sync(mddev_t *mddev);
 extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
Index: linux-2.6/drivers/md/raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/raid1.c
+++ linux-2.6/drivers/md/raid1.c
@@ -1366,7 +1366,7 @@ static void sync_request_write(mddev_t *
 							 sect + rdev->data_offset,
 							 s<<9,
 							 bio->bi_io_vec[idx].bv_page,
-							 READ)) {
+							 READ, 0)) {
 						success = 1;
 						break;
 					}
@@ -1392,7 +1392,7 @@ static void sync_request_write(mddev_t *
 							 sect + rdev->data_offset,
 							 s<<9,
 							 bio->bi_io_vec[idx].bv_page,
-							 WRITE) == 0)
+							 WRITE, 0) == 0)
 						md_error(mddev, rdev);
 				}
 				d = start;
@@ -1407,7 +1407,7 @@ static void sync_request_write(mddev_t *
 							 sect + rdev->data_offset,
 							 s<<9,
 							 bio->bi_io_vec[idx].bv_page,
-							 READ) == 0)
+							 READ, 0) == 0)
 						md_error(mddev, rdev);
 				}
 			} else {
@@ -1490,7 +1490,7 @@ static void fix_read_error(conf_t *conf,
 			    sync_page_io(rdev,
 					 sect + rdev->data_offset,
 					 s<<9,
-					 conf->tmppage, READ))
+					 conf->tmppage, READ, 0))
 				success = 1;
 			else {
 				d++;
@@ -1515,7 +1515,7 @@ static void fix_read_error(conf_t *conf,
 			    test_bit(In_sync, &rdev->flags)) {
 				if (sync_page_io(rdev,
 						 sect + rdev->data_offset,
-						 s<<9, conf->tmppage, WRITE)
+						 s<<9, conf->tmppage, WRITE, 0)
 				    == 0)
 					/* Well, this device is dead */
 					md_error(mddev, rdev);
@@ -1532,7 +1532,7 @@ static void fix_read_error(conf_t *conf,
 			    test_bit(In_sync, &rdev->flags)) {
 				if (sync_page_io(rdev,
 						 sect + rdev->data_offset,
-						 s<<9, conf->tmppage, READ)
+						 s<<9, conf->tmppage, READ, 0)
 				    == 0)
 					/* Well, this device is dead */
 					md_error(mddev, rdev);
Index: linux-2.6/drivers/md/raid10.c
===================================================================
--- linux-2.6.orig/drivers/md/raid10.c
+++ linux-2.6/drivers/md/raid10.c
@@ -1561,7 +1561,7 @@ static void fix_read_error(conf_t *conf,
 						       r10_bio->devs[sl].addr +
 						       sect + rdev->data_offset,
 						       s<<9,
-						       conf->tmppage, READ);
+						       conf->tmppage, READ, 0);
 				rdev_dec_pending(rdev, mddev);
 				rcu_read_lock();
 				if (success)
@@ -1599,7 +1599,7 @@ static void fix_read_error(conf_t *conf,
 				if (sync_page_io(rdev,
 						 r10_bio->devs[sl].addr +
 						 sect + rdev->data_offset,
-						 s<<9, conf->tmppage, WRITE)
+						 s<<9, conf->tmppage, WRITE, 0)
 				    == 0) {
 					/* Well, this device is dead */
 					printk(KERN_NOTICE
@@ -1637,7 +1637,7 @@ static void fix_read_error(conf_t *conf,
 						 r10_bio->devs[sl].addr +
 						 sect + rdev->data_offset,
 						 s<<9, conf->tmppage,
-						 READ) == 0) {
+						 READ, 0) == 0) {
 					/* Well, this device is dead */
 					printk(KERN_NOTICE
 					       "md/raid10:%s: unable to read back "
