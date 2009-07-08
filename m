From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] Allow multipath devices to be created for
	readonly devices
Date: Wed, 8 Jul 2009 14:17:59 +0530
Message-ID: <200907081417.59976.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>
Subject: Allow multipath devices to be created for readonly devices

Currently we cannot create device-mapper tables for multipath devices
whenever they are read-only.This patch modifies the device-mapper to
set the 'READ-ONLY' flag automatically whenever a read-only is added
to the table.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6-dm/drivers/md/dm.c
===================================================================
--- linux-2.6-dm.orig/drivers/md/dm.c
+++ linux-2.6-dm/drivers/md/dm.c
@@ -322,16 +322,26 @@ static void __exit dm_exit(void)
 static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mapped_device *md;
+	int retval = 0;
 
 	spin_lock(&_minor_lock);
 
 	md = bdev->bd_disk->private_data;
-	if (!md)
+	if (!md) {
+		retval = -ENXIO;
 		goto out;
+	}
 
 	if (test_bit(DMF_FREEING, &md->flags) ||
 	    test_bit(DMF_DELETING, &md->flags)) {
 		md = NULL;
+		retval = -ENXIO;
+		goto out;
+	}
+
+	if (bdev_read_only(bdev) && (mode & FMODE_WRITE)) {
+		md = NULL;
+		retval = -EROFS;
 		goto out;
 	}
 
@@ -341,7 +351,7 @@ static int dm_blk_open(struct block_devi
 out:
 	spin_unlock(&_minor_lock);
 
-	return md ? 0 : -ENXIO;
+	return retval;
 }
 
 static int dm_blk_close(struct gendisk *disk, fmode_t mode)
@@ -1948,6 +1958,14 @@ static int __bind(struct mapped_device *
 
 	__bind_mempools(md, t);
 
+	dm_get_table(md);
+	if (dm_table_get_mode(t) & FMODE_WRITE) {
+		set_disk_ro(md->disk, 0);
+	} else {
+		set_disk_ro(md->disk, 1);
+	}
+	dm_table_put(md->map);
+
 	write_lock_irqsave(&md->map_lock, flags);
 	md->map = t;
 	dm_table_set_restrictions(t, q, limits);
Index: linux-2.6-dm/drivers/md/dm-table.c
===================================================================
--- linux-2.6-dm.orig/drivers/md/dm-table.c
+++ linux-2.6-dm/drivers/md/dm-table.c
@@ -455,11 +455,19 @@ static int __table_get_device(struct dm_
 		dd->dm_dev.mode = mode;
 		dd->dm_dev.bdev = NULL;
 
-		if ((r = open_dev(dd, dev, t->md))) {
+		r = open_dev(dd, dev, t->md);
+		if (r == -EROFS) {
+			dd->dm_dev.mode &= ~FMODE_WRITE;
+			r = open_dev(dd, dev, t->md);
+		}
+		if (r) {
 			kfree(dd);
 			return r;
 		}
 
+		if (dd->dm_dev.mode != mode)
+			t->mode = dd->dm_dev.mode;
+
 		format_dev_t(dd->dm_dev.name, dev);
 
 		atomic_set(&dd->count, 0);
