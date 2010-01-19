From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 2/3] dm-raid1: add cancel_presuspend function
Date: Tue, 19 Jan 2010 15:41:29 -0500
Message-ID: <4B5618F9.8050103@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

When suspend is interrupted after presuspend procedure, mirror target
needs to reset and release following variables:
  - reset ms->suspend flag
  - release semaphore (rh->recovery_count)


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-raid1.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.33-rc1-dm/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.33-rc1-dm.orig/drivers/md/dm-raid1.c
+++ linux-2.6.33-rc1-dm/drivers/md/dm-raid1.c
@@ -1311,6 +1311,14 @@ static void mirror_postsuspend(struct dm
 		DMWARN("log postsuspend failed");
 }
 
+static void mirror_cancel_presuspend(struct dm_target *ti)
+{
+	struct mirror_set *ms = ti->private;
+
+	atomic_set(&ms->suspend, 0);
+	dm_rh_start_recovery(ms->rh);
+}
+
 static void mirror_resume(struct dm_target *ti)
 {
 	struct mirror_set *ms = ti->private;
@@ -1412,6 +1420,7 @@ static struct target_type mirror_target 
 	.end_io	 = mirror_end_io,
 	.presuspend = mirror_presuspend,
 	.postsuspend = mirror_postsuspend,
+	.cancel_presuspend = mirror_cancel_presuspend,
 	.resume	 = mirror_resume,
 	.status	 = mirror_status,
 	.iterate_devices = mirror_iterate_devices,

-- 
Takahiro Yasui
Hitachi Computer Products (America), Inc.
