From: NeilBrown <neilb@suse.de>
Subject: [PATCH 23/24] md/bitmap: separate out loading a bitmap from
	initialising the structures.
Date: Tue, 01 Jun 2010 19:56:20 +1000
Message-ID: <20100601095620.565.16503.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

dm makes this distinction between ->ctr and ->resume, so we need to
too.

Also get the new bitmap_load to clear out the bitmap first, as this is
most consistent with the dm suspend/resume approach

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |   69 +++++++++++++++++++++++++++++++++++----------------
 drivers/md/bitmap.h |    1 +
 drivers/md/md.c     |   13 ++++++++--
 3 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9376526..1ba1e12 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1681,7 +1681,6 @@ int bitmap_create(mddev_t *mddev)
 	unsigned long pages;
 	struct file *file = mddev->bitmap_info.file;
 	int err;
-	sector_t start;
 	struct sysfs_dirent *bm = NULL;
 
 	BUILD_BUG_ON(sizeof(bitmap_super_t) != 256);
@@ -1763,13 +1762,40 @@ int bitmap_create(mddev_t *mddev)
 	if (!bitmap->bp)
 		goto error;
 
-	/* now that we have some pages available, initialize the in-memory
-	 * bitmap from the on-disk bitmap */
-	start = 0;
-	if (mddev->degraded == 0
-	    || bitmap->events_cleared == mddev->events)
-		/* no need to keep dirty bits to optimise a re-add of a missing device */
-		start = mddev->recovery_cp;
+	printk(KERN_INFO "created bitmap (%lu pages) for device %s\n",
+		pages, bmname(bitmap));
+
+	mddev->bitmap = bitmap;
+
+
+	return (bitmap->flags & BITMAP_WRITE_ERROR) ? -EIO : 0;
+
+ error:
+	bitmap_free(bitmap);
+	return err;
+}
+
+int bitmap_load(mddev_t *mddev)
+{
+	int err = 0;
+	sector_t sector = 0;
+	struct bitmap *bitmap = mddev->bitmap;
+
+	if (!bitmap)
+		goto out;
+
+	/* Clear out old bitmap info first:  Either there is none, or we
+	 * are resuming after someone else has possibly changed things,
+	 * so we should forget old cached info.
+	 * All chunks should be clean, but some might need_sync.
+	 */
+	while (sector < mddev->resync_max_sectors) {
+		int blocks;
+		bitmap_start_sync(bitmap, sector, &blocks, 0);
+		sector += blocks;
+	}
+	bitmap_close_sync(bitmap);
+
 	if (mddev->bitmap_info.log) {
 		unsigned long i;
 		struct dm_dirty_log *log = mddev->bitmap_info.log;
@@ -1778,29 +1804,30 @@ int bitmap_create(mddev_t *mddev)
 				bitmap_set_memory_bits(bitmap,
 						       (sector_t)i << CHUNK_BLOCK_SHIFT(bitmap),
 						       1);
-		err = 0;
-	} else
-		err = bitmap_init_from_disk(bitmap, start);
+	} else {
+		sector_t start = 0;
+		if (mddev->degraded == 0
+		    || bitmap->events_cleared == mddev->events)
+			/* no need to keep dirty bits to optimise a
+			 * re-add of a missing device */
+			start = mddev->recovery_cp;
 
+		err = bitmap_init_from_disk(bitmap, start);
+	}
 	if (err)
-		goto error;
-
-	printk(KERN_INFO "created bitmap (%lu pages) for device %s\n",
-		pages, bmname(bitmap));
-
-	mddev->bitmap = bitmap;
+		goto out;
 
 	mddev->thread->timeout = mddev->bitmap_info.daemon_sleep;
 	md_wakeup_thread(mddev->thread);
 
 	bitmap_update_sb(bitmap);
 
-	return (bitmap->flags & BITMAP_WRITE_ERROR) ? -EIO : 0;
-
- error:
-	bitmap_free(bitmap);
+	if (bitmap->flags & BITMAP_WRITE_ERROR)
+		err = -EIO;
+out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(bitmap_load);
 
 static ssize_t
 location_show(mddev_t *mddev, char *page)
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index a7a1113..e872a7b 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -254,6 +254,7 @@ struct bitmap {
 
 /* these are used only by md/bitmap */
 int  bitmap_create(mddev_t *mddev);
+int bitmap_load(mddev_t *mddev);
 void bitmap_flush(mddev_t *mddev);
 void bitmap_destroy(mddev_t *mddev);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f24efd2..e0a9bf8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4568,7 +4568,11 @@ static int do_md_run(mddev_t *mddev)
 	err = md_run(mddev);
 	if (err)
 		goto out;
-
+	err = bitmap_load(mddev);
+	if (err) {
+		bitmap_destroy(mddev);
+		goto out;
+	}
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
 	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
@@ -5356,8 +5360,11 @@ static int set_bitmap_file(mddev_t *mddev, int fd)
 	err = 0;
 	if (mddev->pers) {
 		mddev->pers->quiesce(mddev, 1);
-		if (fd >= 0)
+		if (fd >= 0) {
 			err = bitmap_create(mddev);
+			if (!err)
+				err = bitmap_load(mddev);
+		}
 		if (fd < 0 || err) {
 			bitmap_destroy(mddev);
 			fd = -1; /* make sure to put the file */
@@ -5606,6 +5613,8 @@ static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_offset;
 			mddev->pers->quiesce(mddev, 1);
 			rv = bitmap_create(mddev);
+			if (!rv)
+				rv = bitmap_load(mddev);
 			if (rv)
 				bitmap_destroy(mddev);
 			mddev->pers->quiesce(mddev, 0);


