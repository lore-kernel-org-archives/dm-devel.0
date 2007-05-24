From: dwysocha@redhat.com
Subject: [patch 3/3] Add retries to hp hardware handler when path
	activation command completes w/err
Date: Thu, 24 May 2007 01:17:50 -0400
Message-ID: <20070524051814.331323536@redhat.com>
References: <20070524051747.219219749@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline;
	filename=dm-hp-sw-add-retries-handle-not-ready.patch
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
Cc: Mike Christie <michaelc@cs.wisc.edu>, Dave Wysochanski <dave.wysochanski@redhat.com>
List-Id: dm-devel.ids

This patch depends on the following patch:
dm-mpath: Add MP_RETRY_PG_INIT flag for hw handlers to tell dm-mpath to retry

Add retries to hp hardware handler if path initialization command completes
with a check condition.  For now we just assume we can retry the command
because we only have partial information on the check conditions of the 
HP hardware.  Testing has shown that sending additional path initialization
commands do no extra harm so we just be conservative and retry 5 times.

Signed-off-by: Dave Wysochanski <dave.wysochanski@redhat.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

--
Index: linux-2.6.22-rc1/drivers/md/dm-hp-sw.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/md/dm-hp-sw.c
+++ linux-2.6.22-rc1/drivers/md/dm-hp-sw.c
@@ -17,20 +17,58 @@
 #include <linux/types.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
 
 #include "dm.h"
 #include "dm-hw-handler.h"
 
 #define DM_MSG_PREFIX "multipath hp"
 
+#define HP_SW_PG_INIT_RETRIES 5
+
 struct hp_sw_context {
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	unsigned pg_init_count;
 };
 
+/**
+ * hp_sw_error_is_retryable - Is an HP-specific check condition retryable?
+ * @req: path activation request
+ *
+ * Examine error codes of request and determine whether the error is retryable.
+ * Some error codes are already retried by scsi-ml (see
+ * scsi_decide_disposition), but some HP specific codes are not.
+ * The intent of this routine is to supply the logic for the HP specific
+ * check conditions.
+ *
+ * Returns:
+ *  1 - command completed with retryable error
+ *  0 - command completed with non-retryable error
+ *
+ * Possible optimizations
+ * 1. More hardware-specific error codes
+ */
+static int hp_sw_error_is_retryable(struct request *req)
+{
+	/*
+	 * NOT_READY is known to be retryable
+	 * For now we just dump out the sense data and call it retryable
+	 */
+	if ((status_byte(req->errors) == CHECK_CONDITION) &&
+	    (driver_byte(req->errors) & DRIVER_SENSE))
+		__scsi_print_sense("hp_sw", req->sense, req->sense_len);
+
+	/*
+	 * At this point we don't have complete information about all the error
+	 * codes from this hardware, so we are just conservative and retry
+	 * when in doubt.
+	 */
+	return 1;
+}
 
 /**
  * hp_sw_end_io - Completion handler for HP path activation.
- * @req: failover request
+ * @req: path activation request
  * @error: scsi-ml error
  *
  *  Check sense data, free request structure, and notify dm that
@@ -38,24 +76,38 @@ struct hp_sw_context {
  *
  * Context: scsi-ml softirq
  *
- * Possible optimizations
- * 1. Actually check sense data for retryable error (e.g. NOT_READY)
  */
 static void hp_sw_end_io(struct request *req, int error)
 {
 	struct dm_path *path = req->end_io_data;
+	struct hp_sw_context *h = path->hwhcontext;
 	unsigned err_flags;
 
 	if (!error) {
+		h->pg_init_count = 0;
 		err_flags = 0;
-		DMDEBUG("hp_sw: path activation command on %s - success",
+		DMDEBUG("hp_sw: %s path activation command - success",
 		       	path->dev->name);
 	} else {
-		DMWARN("hp_sw: path activation command on %s - error=0x%x",
+		DMWARN("hp_sw: %s path activation command - error=0x%x",
 		       path->dev->name, error);
+		if (hp_sw_error_is_retryable(req)) {
+			if (h->pg_init_count <= HP_SW_PG_INIT_RETRIES) {
+				DMWARN("hp_sw: %s path activation command "
+				       "count=%d",
+				       path->dev->name, h->pg_init_count);
+				err_flags = MP_RETRY_PG_INIT;
+				goto exit;
+			} else
+				DMWARN("hp_sw: %s path activation command "
+				       "out of retries",
+				       path->dev->name);
+		}
+		DMWARN("hp_sw: %s path activation fail", path->dev->name);
+		h->pg_init_count = 0;
 		err_flags = MP_FAIL_PATH;
 	}
-
+ exit:
 	req->end_io_data = NULL;
 	__blk_put_request(req->q, req);
 	dm_pg_init_complete(path, err_flags);
@@ -126,25 +178,31 @@ static void hp_sw_pg_init(struct hw_hand
 {
 	struct request *req;
 	struct hp_sw_context *h;
+	unsigned err_flags;
 
 	path->hwhcontext = hwh->context;
 	h = (struct hp_sw_context *) hwh->context;
+	h->pg_init_count++;
 
 	req = hp_sw_get_request(path);
 	if (!req) {
-		DMERR("hp_sw: path activation command allocation fail on %s ",
+		DMERR("hp_sw: %s path activation command allocation fail ",
 		      path->dev->name);
 		goto fail;
 	}
 
-	DMDEBUG("hp_sw: path activation command sent on %s",
-		path->dev->name);
+	DMDEBUG("hp_sw: %s path activation command sent, pg_init_count=%d",
+		path->dev->name, h->pg_init_count);
 
 	elv_add_request(req->q, req, ELEVATOR_INSERT_FRONT, 1);
 	return;
 
  fail:
-	dm_pg_init_complete(path, MP_FAIL_PATH);
+	if (h->pg_init_count <= HP_SW_PG_INIT_RETRIES)
+		err_flags = MP_RETRY_PG_INIT;
+	else
+		err_flags = MP_FAIL_PATH;
+	dm_pg_init_complete(path, err_flags);
 }
 
 static int hp_sw_create(struct hw_handler *hwh, unsigned argc, char **argv)
@@ -155,6 +213,7 @@ static int hp_sw_create(struct hw_handle
 	if (!h)
 		return -ENOMEM;
 	hwh->context = h;
+	h->pg_init_count = 0;
 	return 0;
 }
 
@@ -182,7 +241,7 @@ static int __init hp_sw_init(void)
 	if (r < 0)
 		DMERR("hp_sw: register failed %d", r);
 
-	DMINFO("hp_sw version 0.0.2 loaded");
+	DMINFO("hp_sw version 0.0.3 loaded");
 
 	return r;
 }

-- 
