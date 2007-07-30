From: Dave Wysochanski <dwysocha@redhat.com>
Subject: Re: [patch 3/3] Add retries to hp hardware handler if
	path initialization command completes with a check condition.
Date: Mon, 30 Jul 2007 18:16:28 -0400
Message-ID: <1185833789.4547.29.camel@linux-cxyg>
References: <20070726044447.846195205@redhat.com>
	<20070726044720.980015296@redhat.com>
	<1185477543.17399.59.camel@linuxchandra>
	<1185822636.4547.8.camel@linux-cxyg>  <46AE534B.7090205@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-KTXdSdiHQeuyehxq3Fgz"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46AE534B.7090205@cs.wisc.edu>
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


--=-KTXdSdiHQeuyehxq3Fgz
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-07-30 at 16:08 -0500, Mike Christie wrote:
> Dave Wysochanski wrote:
> > On Thu, 2007-07-26 at 12:19 -0700, Chandra Seetharaman wrote:
> >> On Thu, 2007-07-26 at 00:44 -0400, dwysocha@redhat.com wrote:
> >>> plain text document attachment (dm-hp-sw-add-retries-handle-not-
> >>> ready.patch)
> >>> This patch adds retries to the hp hardware handler, and utilizes the 
> >>> MP_RETRY flag of dm-multipath.  For now in the hp handler, if we get a 
> >>> pg_init completed with a check condition we just assume we can retry the
> >>> pg_init command.  We make this assumption because of incomplete data on
> >>> specific check condition code of the HP hardware, and because testing
> >>> has shown the HP path initialization command to be idempotent.
> >>> The number of times we retry is settable via the "pg_init_retries"
> >>> multipath map feature.
> >>>
> >>>
> >>> Index: linux-2.6.23-rc1/drivers/md/dm-hp-sw.c
> >>> ===================================================================
> >>> --- linux-2.6.23-rc1.orig/drivers/md/dm-hp-sw.c
> >>> +++ linux-2.6.23-rc1/drivers/md/dm-hp-sw.c
> >>> @@ -18,6 +18,7 @@
> >>>  #include <linux/types.h>
> >>>  #include <scsi/scsi.h>
> >>>  #include <scsi/scsi_cmnd.h>
> >>> +#include <scsi/scsi_dbg.h>
> >>>
> >>>  #include "dm.h"
> >>>  #include "dm-hw-handler.h"
> >>> @@ -26,8 +27,42 @@
> >>>
> >>>  struct hp_sw_context {
> >>>  	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
> >>> +	unsigned argc;
> >>>  };
> >>>
> >>> +/**
> >>> + * hp_sw_error_is_retryable - Is an HP-specific check condition retryable?
> >>> + * @req: path activation request
> >>> + *
> >>> + * Examine error codes of request and determine whether the error is retryable.
> >>> + * Some error codes are already retried by scsi-ml (see
> >>> + * scsi_decide_disposition), but some HP specific codes are not.
> >>> + * The intent of this routine is to supply the logic for the HP specific
> >>> + * check conditions.
> >>> + *
> >>> + * Returns:
> >>> + *  1 - command completed with retryable error
> >>> + *  0 - command completed with non-retryable error
> >>> + *
> >>> + * Possible optimizations
> >>> + * 1. More hardware-specific error codes
> >>> + */
> >>> +static int hp_sw_error_is_retryable(struct request *req)
> >>> +{
> >>> +	/*
> >>> +	 * NOT_READY is known to be retryable
> >>> +	 * For now we just dump out the sense data and call it retryable
> >>> +	 */
> >>> +	if (status_byte(req->errors) == CHECK_CONDITION)
> >>> +		__scsi_print_sense("hp_sw", req->sense, req->sense_len);
> >>> +
> >>> +	/*
> >>> +	 * At this point we don't have complete information about all the error
> >>> +	 * codes from this hardware, so we are just conservative and retry
> >>> +	 * when in doubt.
> >>> +	 */
> >>> +	return 1;
> >>> +}
> >>>
> >>>  /**
> >>>   * hp_sw_end_io - Completion handler for HP path activation.
> >>> @@ -39,8 +74,6 @@ struct hp_sw_context {
> >>>   *
> >>>   * Context: scsi-ml softirq
> >>>   *
> >>> - * Possible optimizations
> >>> - * 1. Actually check sense data for retryable error (e.g. NOT_READY)
> >>>   */
> >>>  static void hp_sw_end_io(struct request *req, int error)
> >>>  {
> >>> @@ -52,11 +85,17 @@ static void hp_sw_end_io(struct request 
> >>>  		DMDEBUG("%s path activation command - success",
> >>>  		       	path->dev->name);
> >>>  	} else {
> >>> -		DMWARN("path activation command on %s - error=0x%x",
> >>> -		       path->dev->name, error);
> >>> +		if (hp_sw_error_is_retryable(req)) {
> >>> +			DMDEBUG("%s path activation command retry",
> >>> +			       path->dev->name);
> >> mixed use of space and tabs
> >>> +			err_flags = MP_RETRY;
> >>> +			goto out;
> >>> +		}
> >>> +		DMWARN("%s path activation fail - error=0x%x",
> >>> +			path->dev->name, error);
> >>>  		err_flags = MP_FAIL_PATH;
> >>>  	}
> >>> -
> >>> + out:
> >> space in front of label
> >>
> >>>  	req->end_io_data = NULL;
> >>>  	__blk_put_request(req->q, req);
> >>>  	dm_pg_init_complete(path, err_flags);
> >>> @@ -134,17 +173,16 @@ static void hp_sw_pg_init(struct hw_hand
> >>>  	if (!req) {
> >>>  		DMERR("%s path activation command allocation fail ",
> >>>  		      path->dev->name);
> >>> -		goto fail;
> >>> +		goto retry;
> >>>  	}
> >>>
> >>> -	DMDEBUG("path activation command sent on %s",
> >>> -		path->dev->name);
> >>> +	DMDEBUG("%s path activation command sent", path->dev->name);
> >>>
> >>>  	blk_execute_rq_nowait(req->q, NULL, req, 1, hp_sw_end_io);
> >>>  	return;
> >>>
> >>> - fail:
> >>> -	dm_pg_init_complete(path, MP_FAIL_PATH);
> >>> + retry:
> >>> +	dm_pg_init_complete(path, MP_RETRY);
> >>>  }
> >>>
> >>>  static int hp_sw_create(struct hw_handler *hwh, unsigned argc, char **argv)
> >>> @@ -181,7 +219,7 @@ static int __init hp_sw_init(void)
> >>>  	if (r < 0)
> >>>  		DMERR("register failed %d", r);
> >>>  	else
> >>> -		DMINFO("version 0.0.2 loaded");
> >>> +		DMINFO("version 0.0.3 loaded");
> >>>
> >>>  	return r;
> >>>  }
> >>>
> > 
> > Attached should fix the whitespace issues mentioned.
> > 
> 
> That seems more odd with the other code. Please do not just use tabs for 
> spacing on those places. Keep it consistent with the rest of the dm code.
> 

Ok - see attached.



--=-KTXdSdiHQeuyehxq3Fgz
Content-Disposition: attachment;
	filename=dm-hp-sw-add-retries-handle-not-ready.patch
Content-Type: text/x-patch; name=dm-hp-sw-add-retries-handle-not-ready.patch;
	charset=utf-8
Content-Transfer-Encoding: 7bit

Add retries to hp hardware handler if path initialization command completes
with a check condition.  

This patch adds retries to the hp hardware handler, and utilizes the 
MP_RETRY flag of dm-multipath.  For now in the hp handler, if we get a 
pg_init completed with a check condition we just assume we can retry the
pg_init command.  We make this assumption because of incomplete data on
specific check condition code of the HP hardware, and because testing
has shown the HP path initialization command to be idempotent.
The number of times we retry is settable via the "pg_init_retries"
multipath map feature.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
Index: linux-2.6.23-rc1/drivers/md/dm-hp-sw.c
===================================================================
--- linux-2.6.23-rc1.orig/drivers/md/dm-hp-sw.c
+++ linux-2.6.23-rc1/drivers/md/dm-hp-sw.c
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
 
 #include "dm.h"
 #include "dm-hw-handler.h"
@@ -28,6 +29,39 @@ struct hp_sw_context {
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
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
+	if (status_byte(req->errors) == CHECK_CONDITION)
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
@@ -39,8 +73,6 @@ struct hp_sw_context {
  *
  * Context: scsi-ml softirq
  *
- * Possible optimizations
- * 1. Actually check sense data for retryable error (e.g. NOT_READY)
  */
 static void hp_sw_end_io(struct request *req, int error)
 {
@@ -52,11 +84,17 @@ static void hp_sw_end_io(struct request 
 		DMDEBUG("%s path activation command - success",
 			path->dev->name);
 	} else {
-		DMWARN("%s path activation command - error=0x%x",
+		if (hp_sw_error_is_retryable(req)) {
+			DMDEBUG("%s path activation command - retry",
+				path->dev->name);
+			err_flags = MP_RETRY;
+			goto out;
+		}
+		DMWARN("%s path activation fail - error=0x%x",
 		       path->dev->name, error);
 		err_flags = MP_FAIL_PATH;
 	}
-
+out:
 	req->end_io_data = NULL;
 	__blk_put_request(req->q, req);
 	dm_pg_init_complete(path, err_flags);
@@ -134,7 +172,7 @@ static void hp_sw_pg_init(struct hw_hand
 	if (!req) {
 		DMERR("%s path activation command - allocation fail",
 		      path->dev->name);
-		goto fail;
+		goto retry;
 	}
 
 	DMDEBUG("%s path activation command - sent", path->dev->name);
@@ -142,8 +180,8 @@ static void hp_sw_pg_init(struct hw_hand
 	blk_execute_rq_nowait(req->q, NULL, req, 1, hp_sw_end_io);
 	return;
 
-fail:
-	dm_pg_init_complete(path, MP_FAIL_PATH);
+retry:
+	dm_pg_init_complete(path, MP_RETRY);
 }
 
 static int hp_sw_create(struct hw_handler *hwh, unsigned argc, char **argv)
@@ -180,7 +218,7 @@ static int __init hp_sw_init(void)
 	if (r < 0)
 		DMERR("register failed %d", r);
 	else
-		DMINFO("version 0.0.2 loaded");
+		DMINFO("version 0.0.3 loaded");
 
 	return r;
 }

--=-KTXdSdiHQeuyehxq3Fgz
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-KTXdSdiHQeuyehxq3Fgz--
