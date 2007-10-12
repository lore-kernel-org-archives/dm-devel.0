From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 24/25] dm log: split suspend
Date: Fri, 12 Oct 2007 18:23:37 +0100
Message-ID: <20071012172337.GJ24157@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Jonathan Brassow <jbrassow@redhat.com>

There are now two phases to a suspend in device-mapper -
presuspend and postsuspend.  This patch removes the
single 'suspend' in the logging API and replaces it with
'presuspend' and 'postsuspend' functions to align it 
better with core device-mapper.

A subsequent patch will make use of 'presuspend'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-log.c   |    2 +-
 drivers/md/dm-log.h   |    3 ++-
 drivers/md/dm-raid1.c |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.23/drivers/md/dm-log.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-log.c	2007-10-12 12:36:13.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-log.c	2007-10-12 15:03:32.000000000 +0100
@@ -696,7 +696,7 @@ static struct dirty_log_type _disk_type 
 	.module = THIS_MODULE,
 	.ctr = disk_ctr,
 	.dtr = disk_dtr,
-	.suspend = disk_flush,
+	.postsuspend = disk_flush,
 	.resume = disk_resume,
 	.get_region_size = core_get_region_size,
 	.is_clean = core_is_clean,
Index: linux-2.6.23/drivers/md/dm-log.h
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-log.h	2007-10-12 12:36:13.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-log.h	2007-10-12 15:03:32.000000000 +0100
@@ -32,7 +32,8 @@ struct dirty_log_type {
 	 * There are times when we don't want the log to touch
 	 * the disk.
 	 */
-	int (*suspend)(struct dirty_log *log);
+	int (*presuspend)(struct dirty_log *log);
+	int (*postsuspend)(struct dirty_log *log);
 	int (*resume)(struct dirty_log *log);
 
 	/*
Index: linux-2.6.23/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-raid1.c	2007-10-12 13:15:36.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-raid1.c	2007-10-12 15:03:32.000000000 +0100
@@ -1305,7 +1305,7 @@ static void mirror_postsuspend(struct dm
 	wait_event(_kmirrord_recovery_stopped,
 		   !atomic_read(&ms->rh.recovery_in_flight));
 
-	if (log->type->suspend && log->type->suspend(log))
+	if (log->type->postsuspend && log->type->postsuspend(log))
 		/* FIXME: need better error handling */
 		DMWARN("log suspend failed");
 }
