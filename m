From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] dm-mpath: flush workqueues before suspend
	completes
Date: Thu, 12 Nov 2009 18:55:22 +0900
Message-ID: <4AFBDB8A.4080900@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
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
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

Current dm-mpath target may not be quiet even after suspend completes
because some workqueues (e.g. device_handler's work, event handling)
are not flushed during the suspend sequence, although suspended
devices/targets should be quiet.

This patch lets dm-mpath be quiet during the suspend sequence by
flushing workqueues in postsuspend function.

Note: Even with this patch, multipath_message ioctl can kick such works
      for already-suspended devices/targets.
      Other patches are needed for it.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-mpath.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

Index: 2.6.32-rc6/drivers/md/dm-mpath.c
===================================================================
--- 2.6.32-rc6.orig/drivers/md/dm-mpath.c
+++ 2.6.32-rc6/drivers/md/dm-mpath.c
@@ -885,13 +885,18 @@ static int multipath_ctr(struct dm_targe
 	return r;
 }
 
-static void multipath_dtr(struct dm_target *ti)
+static void flush_multipath_work(void)
 {
-	struct multipath *m = (struct multipath *) ti->private;
-
 	flush_workqueue(kmpath_handlerd);
 	flush_workqueue(kmultipathd);
 	flush_scheduled_work();
+}
+
+static void multipath_dtr(struct dm_target *ti)
+{
+	struct multipath *m = ti->private;
+
+	flush_multipath_work();
 	free_multipath(m);
 }
 
@@ -1261,6 +1266,11 @@ static void multipath_presuspend(struct 
 	queue_if_no_path(m, 0, 1);
 }
 
+static void multipath_postsuspend(struct dm_target *ti)
+{
+	flush_multipath_work();
+}
+
 /*
  * Restore the queue_if_no_path setting.
  */
@@ -1567,13 +1577,14 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 1, 0},
+	.version = {1, 1, 1},
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
 	.map_rq = multipath_map,
 	.rq_end_io = multipath_end_io,
 	.presuspend = multipath_presuspend,
+	.postsuspend = multipath_postsuspend,
 	.resume = multipath_resume,
 	.status = multipath_status,
 	.message = multipath_message,
