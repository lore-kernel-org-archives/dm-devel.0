From: dwysocha@redhat.com
Subject: [patch 2/3] Add MP_RETRY_PG_INIT flag for hw handlers to
	tell dm-mpath to retry pg_init.
Date: Thu, 24 May 2007 01:24:04 -0400
Message-ID: <20070524052419.595099764@redhat.com>
References: <20070524052402.946400092@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-mpath-add-retry-pg-init.patch
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

-- 
