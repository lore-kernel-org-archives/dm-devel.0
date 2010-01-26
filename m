From: Dave Wysochanski <dwysocha@redhat.com>
Subject: [PATCH] dm_ioctl: Only send a change uevent when a
	resume ioctl changes the device.
Date: Tue, 26 Jan 2010 12:56:10 -0500
Message-ID: <1264528570-10498-1-git-send-email-dwysocha@redhat.com>
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

Resume ioctls may result in no changes to the device and thus they
should not generate change uevents.  For example, if a device is
not suspended when a resume ioctl occurs, we should not send a
uevent.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
---
 drivers/md/dm-ioctl.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 1d66932..0c1cf53 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -851,6 +851,7 @@ static int do_suspend(struct dm_ioctl *param)
 
 static int do_resume(struct dm_ioctl *param)
 {
+	int send_uevent = 0;
 	int r = 0;
 	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct hash_cell *hc;
@@ -895,18 +896,21 @@ static int do_resume(struct dm_ioctl *param)
 			set_disk_ro(dm_disk(md), 0);
 		else
 			set_disk_ro(dm_disk(md), 1);
+		send_uevent = 1;
 	}
-
-	if (dm_suspended_md(md))
+	if (dm_suspended_md(md)) {
 		r = dm_resume(md);
+		send_uevent = 1;
+	}
 
 	if (old_map)
 		dm_table_destroy(old_map);
 
-	if (!r) {
+	if (send_uevent)
 		dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
+
+	if (!r)
 		r = __dev_status(md, param);
-	}
 
 	dm_put(md);
 	return r;
-- 
1.6.5.3
