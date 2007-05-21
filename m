From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc1-mm1 PATCH 6/10] dm-log-split-suspend.patch
Date: Mon, 21 May 2007 17:05:36 -0500
Message-ID: <1179785136.13913.29.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

 brassow

Index: linux-2.6.22-rc1-mm1/drivers/md/dm-log.c
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-log.c
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-log.c
@@ -696,7 +696,7 @@ static struct dirty_log_type _disk_type 
 	.module = THIS_MODULE,
 	.ctr = disk_ctr,
 	.dtr = disk_dtr,
-	.suspend = disk_flush,
+	.postsuspend = disk_flush,
 	.resume = disk_resume,
 	.get_region_size = core_get_region_size,
 	.is_clean = core_is_clean,
Index: linux-2.6.22-rc1-mm1/drivers/md/dm-log.h
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-log.h
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-log.h
@@ -32,7 +32,8 @@ struct dirty_log_type {
 	 * There are times when we don't want the log to touch
 	 * the disk.
 	 */
-	int (*suspend)(struct dirty_log *log);
+	int (*presuspend)(struct dirty_log *log);
+	int (*postsuspend)(struct dirty_log *log);
 	int (*resume)(struct dirty_log *log);
 
 	/*
Index: linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
@@ -1465,7 +1465,7 @@ static void mirror_postsuspend(struct dm
 	wait_event(_kmirrord_recovery_stopped,
 		   !atomic_read(&ms->rh.recovery_in_flight));
 
-	if (log->type->suspend && log->type->suspend(log))
+	if (log->type->postsuspend && log->type->postsuspend(log))
 		/* FIXME: need better error handling */
 		DMWARN("log suspend failed");
 }
