From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/4] void unregister_blkdev - delete redundant messages
Date: Sat, 30 Jun 2007 12:12:12 +0900
Message-ID: <20070630031212.GD4045@APFDCB5C>
References: <20070630031013.GC4045@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754604AbXF3DVb@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070630031013.GC4045@APFDCB5C>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Eberhard Moenkeberg <emoenke@gwdg.de>, Joe Thornber <dm-devel@redhat.com>, Grant Likely <grant.likely@secretlab.ca>
List-Id: dm-devel.ids

No need to warn unregister_blkdev() failure by the callers.
(The previous patch makes unregister_blkdev() print error message in
error case)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/block/acsi.c         |    4 +---
 drivers/block/loop.c         |    3 +--
 drivers/block/z2ram.c        |    4 +---
 drivers/cdrom/cdu31a.c       |    4 +---
 drivers/cdrom/mcdx.c         |   11 ++---------
 drivers/cdrom/sbpcd.c        |    5 +----
 drivers/cdrom/sjcd.c         |    9 ++++-----
 drivers/cdrom/sonycd535.c    |    6 ++----
 drivers/md/dm.c              |    4 +---
 drivers/s390/block/dcssblk.c |    7 +------
 drivers/sbus/char/jsflash.c  |    3 +--
 11 files changed, 16 insertions(+), 44 deletions(-)

Index: 2.6-mm/drivers/block/acsi.c
===================================================================
--- 2.6-mm.orig/drivers/block/acsi.c
+++ 2.6-mm/drivers/block/acsi.c
@@ -1775,9 +1775,7 @@ void cleanup_module(void)
 	del_timer( &acsi_timer );
 	blk_cleanup_queue(acsi_queue);
 	atari_stram_free( acsi_buffer );
-
-	if (unregister_blkdev( ACSI_MAJOR, "ad" ) != 0)
-		printk( KERN_ERR "acsi: cleanup_module failed\n");
+	unregister_blkdev(ACSI_MAJOR, "ad");
 
 	for (i = 0; i < NDevices; i++) {
 		del_gendisk(acsi_gendisk[i]);
Index: 2.6-mm/drivers/block/z2ram.c
===================================================================
--- 2.6-mm.orig/drivers/block/z2ram.c
+++ 2.6-mm/drivers/block/z2ram.c
@@ -371,9 +371,7 @@ static void __exit z2_exit(void)
 {
     int i, j;
     blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), 256);
-    if ( unregister_blkdev( Z2RAM_MAJOR, DEVICE_NAME ) != 0 )
-	printk( KERN_ERR DEVICE_NAME ": unregister of device failed\n");
-
+    unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
     del_gendisk(z2ram_gendisk);
     put_disk(z2ram_gendisk);
     blk_cleanup_queue(z2_queue);
Index: 2.6-mm/drivers/s390/block/dcssblk.c
===================================================================
--- 2.6-mm.orig/drivers/s390/block/dcssblk.c
+++ 2.6-mm/drivers/s390/block/dcssblk.c
@@ -747,14 +747,9 @@ dcssblk_check_params(void)
 static void __exit
 dcssblk_exit(void)
 {
-	int rc;
-
 	PRINT_DEBUG("DCSSBLOCK EXIT...\n");
 	s390_root_dev_unregister(dcssblk_root_dev);
-	rc = unregister_blkdev(dcssblk_major, DCSSBLK_NAME);
-	if (rc) {
-		PRINT_ERR("unregister_blkdev() failed!\n");
-	}
+	unregister_blkdev(dcssblk_major, DCSSBLK_NAME);
 	PRINT_DEBUG("...finished!\n");
 }
 
Index: 2.6-mm/drivers/sbus/char/jsflash.c
===================================================================
--- 2.6-mm.orig/drivers/sbus/char/jsflash.c
+++ 2.6-mm/drivers/sbus/char/jsflash.c
@@ -619,8 +619,7 @@ static void __exit jsflash_cleanup_modul
 	jsf0.busy = 0;
 
 	misc_deregister(&jsf_dev);
-	if (unregister_blkdev(JSFD_MAJOR, "jsfd") != 0)
-		printk("jsfd: cleanup_module failed\n");
+	unregister_blkdev(JSFD_MAJOR, "jsfd");
 	blk_cleanup_queue(jsf_queue);
 }
 
Index: 2.6-mm/drivers/cdrom/mcdx.c
===================================================================
--- 2.6-mm.orig/drivers/cdrom/mcdx.c
+++ 2.6-mm/drivers/cdrom/mcdx.c
@@ -1050,13 +1050,7 @@ static void __exit mcdx_exit(void)
 		kfree(stuffp);
 	}
 
-	if (unregister_blkdev(MAJOR_NR, "mcdx") != 0) {
-		xwarn("cleanup() unregister_blkdev() failed\n");
-	}
-#if !MCDX_QUIET
-	else
-	xinfo("cleanup() succeeded\n");
-#endif
+	unregister_blkdev(MAJOR_NR, "mcdx");
 	blk_cleanup_queue(mcdx_queue);
 }
 
@@ -1240,8 +1234,7 @@ static int __init mcdx_init_drive(int dr
 		release_region(stuffp->wreg_data, MCDX_IO_SIZE);
 		kfree(stuffp);
 		put_disk(disk);
-		if (unregister_blkdev(MAJOR_NR, "mcdx") != 0)
-			xwarn("cleanup() unregister_blkdev() failed\n");
+		unregister_blkdev(MAJOR_NR, "mcdx");
 		blk_cleanup_queue(mcdx_queue);
 		return 2;
 	}
Index: 2.6-mm/drivers/cdrom/sjcd.c
===================================================================
--- 2.6-mm.orig/drivers/cdrom/sjcd.c
+++ 2.6-mm/drivers/cdrom/sjcd.c
@@ -1792,9 +1792,9 @@ out2:
 out1:
 	blk_cleanup_queue(sjcd_queue);
 out0:
-	if ((unregister_blkdev(MAJOR_NR, "sjcd") == -EINVAL))
-		printk("SJCD: cannot unregister device.\n");
-	return (-EIO);
+	unregister_blkdev(MAJOR_NR, "sjcd");
+
+	return -EIO;
 }
 
 static void __exit sjcd_exit(void)
@@ -1803,8 +1803,7 @@ static void __exit sjcd_exit(void)
 	put_disk(sjcd_disk);
 	release_region(sjcd_base, 4);
 	blk_cleanup_queue(sjcd_queue);
-	if ((unregister_blkdev(MAJOR_NR, "sjcd") == -EINVAL))
-		printk("SJCD: cannot unregister device.\n");
+	unregister_blkdev(MAJOR_NR, "sjcd");
 	printk(KERN_INFO "SJCD: module: removed.\n");
 }
 
Index: 2.6-mm/drivers/md/dm.c
===================================================================
--- 2.6-mm.orig/drivers/md/dm.c
+++ 2.6-mm/drivers/md/dm.c
@@ -165,9 +165,7 @@ static void local_exit(void)
 {
 	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
-
-	if (unregister_blkdev(_major, _name) < 0)
-		DMERR("unregister_blkdev failed");
+	unregister_blkdev(_major, _name);
 
 	_major = 0;
 
Index: 2.6-mm/drivers/block/loop.c
===================================================================
--- 2.6-mm.orig/drivers/block/loop.c
+++ 2.6-mm/drivers/block/loop.c
@@ -1536,8 +1536,7 @@ static void __exit loop_exit(void)
 		loop_del_one(lo);
 
 	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
-	if (unregister_blkdev(LOOP_MAJOR, "loop"))
-		printk(KERN_WARNING "loop: cannot unregister blkdev\n");
+	unregister_blkdev(LOOP_MAJOR, "loop");
 }
 
 module_init(loop_init);
Index: 2.6-mm/drivers/cdrom/cdu31a.c
===================================================================
--- 2.6-mm.orig/drivers/cdrom/cdu31a.c
+++ 2.6-mm/drivers/cdrom/cdu31a.c
@@ -3210,9 +3210,7 @@ errout0:
 	printk(KERN_ERR PFX "Unable to register with Uniform cdrom driver\n");
 	put_disk(disk);
 errout1:
-	if (unregister_blkdev(MAJOR_NR, "cdu31a")) {
-		printk(KERN_WARNING PFX "Can't unregister block device\n");
-	}
+	unregister_blkdev(MAJOR_NR, "cdu31a");
 errout2:
 	release_region(cdu31a_port, 4);
 errout3:
Index: 2.6-mm/drivers/cdrom/sbpcd.c
===================================================================
--- 2.6-mm.orig/drivers/cdrom/sbpcd.c
+++ 2.6-mm/drivers/cdrom/sbpcd.c
@@ -5830,10 +5830,7 @@ int __init sbpcd_init(void)
 		if (!p->sbp_buf) {
 			msg(DBG_INF,"data buffer (%d frames) not available.\n",
 				buffers);
-			if ((unregister_blkdev(MAJOR_NR, major_name) == -EINVAL))
-			{
-				printk("Can't unregister %s\n", major_name);
-			}
+			unregister_blkdev(MAJOR_NR, major_name);
 			release_region(CDo_command,4);
 			blk_cleanup_queue(sbpcd_queue);
 			return -EIO;
Index: 2.6-mm/drivers/cdrom/sonycd535.c
===================================================================
--- 2.6-mm.orig/drivers/cdrom/sonycd535.c
+++ 2.6-mm/drivers/cdrom/sonycd535.c
@@ -1675,10 +1675,8 @@ sony535_exit(void)
 	del_gendisk(cdu_disk);
 	put_disk(cdu_disk);
 	blk_cleanup_queue(sonycd535_queue);
-	if (unregister_blkdev(MAJOR_NR, CDU535_HANDLE) == -EINVAL)
-		printk("Uh oh, couldn't unregister " CDU535_HANDLE "\n");
-	else
-		printk(KERN_INFO CDU535_HANDLE " module released\n");
+	unregister_blkdev(MAJOR_NR, CDU535_HANDLE);
+	printk(KERN_INFO CDU535_HANDLE " module released\n");
 }
 
 module_init(sony535_init);
