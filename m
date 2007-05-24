From: Dave Wysochanski <dwysocha@redhat.com>
Subject: [2.6.22-rc1 PATCH] dm-mpath: Add MP_RETRY_PG_INIT flag
	for hw handlers to tell dm-mpath to retry pg_init.
Date: Wed, 23 May 2007 23:38:39 -0400
Message-ID: <1179977919.8636.26.camel@linux-cxyg>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Add MP_RETRY_PG_INIT flag for hw handlers to tell dm-mpath to retry pg_init.
Useful for cases where a hw handler sends a path initialization command to
the storage and it completes with an error code indicating the command should
be retried.

Index: linux-2.6.22-rc1/drivers/md/dm-hw-handler.h
===================================================================
--- linux-2.6.22-rc1.orig/drivers/md/dm-hw-handler.h
+++ linux-2.6.22-rc1/drivers/md/dm-hw-handler.h
@@ -58,5 +58,6 @@ unsigned dm_scsi_err_handler(struct hw_h
 #define MP_FAIL_PATH 1
 #define MP_BYPASS_PG 2
 #define MP_ERROR_IO  4	/* Don't retry this I/O */
+#define MP_RETRY_PG_INIT 8
 
 #endif
Index: linux-2.6.22-rc1/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/md/dm-mpath.c
+++ linux-2.6.22-rc1/drivers/md/dm-mpath.c
@@ -999,7 +999,9 @@ void dm_pg_init_complete(struct dm_path 
 		bypass_pg(m, pg, 1);
 
 	spin_lock_irqsave(&m->lock, flags);
-	if (err_flags) {
+	if (err_flags & MP_RETRY_PG_INIT)
+		m->pg_init_required = 1;
+	else if (err_flags) {
 		m->current_pgpath = NULL;
 		m->current_pg = NULL;
 	} else if (!m->pg_init_required)
