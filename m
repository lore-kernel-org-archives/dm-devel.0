From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 2.6.20-rc5] dm-multipath: fix stall on noflush
	suspend/resume
Date: Fri, 19 Jan 2007 19:47:27 -0500
Message-ID: <45B1669F.90102@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080906070406080902050500"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080906070406080902050500
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Allow noflush suspend/resume of device-mapper device only for
the case where the device size is unchanged.

Otherwise, dm-multipath devices can stall when resumed if noflush
was used when suspending them, all paths have failed and
queue_if_no_path is set.

Explanation:
 1. Something is doing fsync() on the block dev,
    holding inode->i_sem
 2. The fsync write is blocked by all-paths-down and queue_if_no_path
 3. Someone requests to suspend the dm device with noflush.
    Pending writes are left in queue.
 4. In the middle of dm_resume(), __bind() tries to get
    inode->i_sem to do __set_size() and waits forever.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

---
'noflush suspend' is a new device-mapper feature introduced in
early 2.6.20. So I hope the fix being included before 2.6.20 is
released.

Example of reproducer:
 1. Create a multipath device by dmsetup
 2. Fail all paths during mkfs
 3. Do dmsetup suspend --noflush and load new map with healthy paths
 4. Do dmsetup resume


 drivers/md/dm.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)


--------------080906070406080902050500
Content-Type: text/x-patch;
 name="dm-noflush-fix-stall-on-resume.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-noflush-fix-stall-on-resume.patch"

Index: linux-2.6.19/drivers/md/dm.c
===================================================================
--- linux-2.6.19.orig/drivers/md/dm.c	2006-12-12 22:02:29.000000000 +0000
+++ linux-2.6.19/drivers/md/dm.c	2007-01-05 15:15:53.000000000 +0000
@@ -1116,7 +1116,8 @@ static int __bind(struct mapped_device *
 	if (size != get_capacity(md->disk))
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	__set_size(md, size);
+	if (md->suspended_bdev)
+		__set_size(md, size);
 	if (size == 0)
 		return 0;
 
@@ -1265,6 +1266,11 @@ int dm_swap_table(struct mapped_device *
 	if (!dm_suspended(md))
 		goto out;
 
+	/* without bdev, the device size cannot be changed */
+	if (!md->suspended_bdev)
+		if (get_capacity(md->disk) != dm_table_get_size(table))
+			goto out;
+
 	__unbind(md);
 	r = __bind(md, table);
 
@@ -1342,11 +1348,14 @@ int dm_suspend(struct mapped_device *md,
 	/* This does not get reverted if there's an error later. */
 	dm_table_presuspend_targets(map);
 
-	md->suspended_bdev = bdget_disk(md->disk, 0);
-	if (!md->suspended_bdev) {
-		DMWARN("bdget failed in dm_suspend");
-		r = -ENOMEM;
-		goto flush_and_out;
+	/* bdget() can stall if the pending I/Os are not flushed */
+	if (!noflush) {
+		md->suspended_bdev = bdget_disk(md->disk, 0);
+		if (!md->suspended_bdev) {
+			DMWARN("bdget failed in dm_suspend");
+			r = -ENOMEM;
+			goto flush_and_out;
+		}
 	}
 
 	/*
@@ -1474,8 +1483,10 @@ int dm_resume(struct mapped_device *md)
 
 	unlock_fs(md);
 
-	bdput(md->suspended_bdev);
-	md->suspended_bdev = NULL;
+	if (md->suspended_bdev) {
+		bdput(md->suspended_bdev);
+		md->suspended_bdev = NULL;
+	}
 
 	clear_bit(DMF_SUSPENDED, &md->flags);
 

--------------080906070406080902050500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080906070406080902050500--
