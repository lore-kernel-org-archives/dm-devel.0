From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] Emulate BLKRRPART on device-mapper
Date: Wed, 8 Jul 2009 14:14:50 +0530
Message-ID: <200907081414.50698.knikanth@suse.de>
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
Subject: Emulate BLKRRPART on device-mapper

Partitions on device-mapper devices are managed by kpartx (if at
all). So if we were just to send out a 'change' event if someone
called BLKRRPART on these devices, kpartx will be triggered via udev
and can manage the partitions accordingly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6-dm/drivers/md/dm.c
===================================================================
--- linux-2.6-dm.orig/drivers/md/dm.c
+++ linux-2.6-dm/drivers/md/dm.c
@@ -394,19 +394,25 @@ static int dm_blk_ioctl(struct block_dev
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
-	/* We only support devices that have a single target */
-	if (dm_table_get_num_targets(map) != 1)
-		goto out;
-
-	tgt = dm_table_get_target(map, 0);
-
 	if (dm_suspended(md)) {
 		r = -EAGAIN;
 		goto out;
 	}
 
-	if (tgt->type->ioctl)
-		r = tgt->type->ioctl(tgt, cmd, arg);
+	if (cmd == BLKRRPART) {
+		/* Emulate Re-read partitions table */
+		kobject_uevent(&disk_to_dev(md->disk)->kobj, KOBJ_CHANGE);
+		r = 0;
+	} else {
+		/* We only support devices that have a single target */
+		if (dm_table_get_num_targets(map) != 1)
+			goto out;
+
+		tgt = dm_table_get_target(map, 0);
+
+		if (tgt->type->ioctl)
+			r = tgt->type->ioctl(tgt, cmd, arg);
+	}
 
 out:
 	dm_table_put(map);
