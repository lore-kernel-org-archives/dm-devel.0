From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] Allow switch device-mapper tables to READ-WRITE
Date: Wed, 8 Jul 2009 14:19:20 +0530
Message-ID: <200907081419.20857.knikanth@suse.de>
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
Subject: Allow switch device-mapper tables to READ-WRITE

Switching a device-mapper table to READ-ONLY works quite well, but
we can't switch back to READ-WRITE as this change will be masked out.
So get rid of this masking and use the flags directly.
And implement a fallback to automatically switch to read-only.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6-dm/drivers/md/dm-table.c
===================================================================
--- linux-2.6-dm.orig/drivers/md/dm-table.c
+++ linux-2.6-dm/drivers/md/dm-table.c
@@ -403,10 +403,15 @@ static int upgrade_mode(struct dm_dev_in
 
 	dd_new = dd_old = *dd;
 
-	dd_new.dm_dev.mode |= new_mode;
+	dd_new.dm_dev.mode = new_mode;
 	dd_new.dm_dev.bdev = NULL;
 
 	r = open_dev(&dd_new, dd->dm_dev.bdev->bd_dev, md);
+	if (r == -EROFS) {
+		dd_new.dm_dev.mode &= ~FMODE_WRITE;
+		r = open_dev(&dd_new, dd->dm_dev.bdev->bd_dev, md);
+	}
+
 	if (r)
 		return r;
 
@@ -473,7 +478,7 @@ static int __table_get_device(struct dm_
 		atomic_set(&dd->count, 0);
 		list_add(&dd->list, &t->devices);
 
-	} else if (dd->dm_dev.mode != (mode | dd->dm_dev.mode)) {
+	} else if (dd->dm_dev.mode != mode) {
 		r = upgrade_mode(dd, mode, t->md);
 		if (r)
 			return r;
