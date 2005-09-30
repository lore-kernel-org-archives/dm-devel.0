From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFT/RFC 2/4] add dm_scsi helpers
Date: Fri, 30 Sep 2005 14:42:16 -0500
Message-ID: <1128109336.24395.23.camel@max>
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

I took this function from the cleanup I am doing in the
scsi layer. Unfortunately that work needs some things
fleshed out so I do not know when it will ever be merged.
For now so that dm can move forward I put only what we need
in dm-hw-handler.c and when the scsi-ml work gets
finished I hope we can merge the two or most likely add a
wrapper around the scsi function since we need mempools for
some of our structs.

Still on the todo is to evaluate the rq->errors in more depth,
incase we need to retry the same path or pg immediately or
not report a failure on some errors.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/md/dm-hw-handler.c b/drivers/md/dm-hw-handler.c
--- a/drivers/md/dm-hw-handler.c
+++ b/drivers/md/dm-hw-handler.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005 Mike Christie, All rights reserved.
  *
  * This file is released under the GPL.
  *
@@ -10,6 +11,9 @@
 #include "dm-hw-handler.h"
 
 #include <linux/slab.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_cmnd.h>
 
 struct hwh_internal {
 	struct hw_handler_type hwht;
@@ -149,6 +153,129 @@ int dm_unregister_hw_handler(struct hw_h
 	return 0;
 }
 
+struct dm_scsi_io_context {
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	struct scsi_sense_hdr sense_hdr;
+	struct hw_handler *hwh;
+	struct path *path;
+};
+
+int dm_scsi_init_context_pool(struct hw_handler *hwh)
+{
+	struct dm_scsi_io_context *scsi_ioc;
+
+	scsi_ioc = kzalloc(sizeof(*scsi_ioc), GFP_KERNEL);
+	if (!scsi_ioc)
+		return -ENOMEM;
+
+	hwh->pg_init_context = scsi_ioc;
+	return 0;	
+}
+
+void dm_scsi_destroy_context_pool(struct hw_handler *hwh)
+{
+	kfree(hwh->pg_init_context);
+}
+
+/*
+ * TODO: we should check the error values a little more closely
+ * to decide what we want to do.
+ *
+ * For example for DID_BUS_BUSY, we may just want to try another
+ * pg, but retry this one if the next pg fails with a hard error.
+ * However, we may also want to allow hw_handlers to get more info
+ * so we will see what they need.
+ */
+static void dm_scsi_end_rq(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+	struct dm_scsi_io_context *scsi_ioc = rq->end_io_data;
+	struct hw_handler *hwh = scsi_ioc->hwh;
+	struct path *path = scsi_ioc->path;
+	unsigned err;
+
+	if (host_byte(rq->errors) != DID_OK ||
+	    msg_byte(rq->errors) != COMMAND_COMPLETE) {
+		err = MP_FAIL_PATH;
+		goto done;
+	}
+
+	switch (status_byte(rq->errors)) {
+	case GOOD:
+		err = 0;
+		break;
+	case CHECK_CONDITION:
+		scsi_normalize_sense(rq->sense, SCSI_SENSE_BUFFERSIZE,
+				     &scsi_ioc->sense_hdr);
+		err = hwh->type->rq_error(path, rq->errors,
+					  &scsi_ioc->sense_hdr);
+		break;
+	default:
+		err = MP_FAIL_PATH;
+	};
+done:
+	dm_pg_init_complete(path, err);
+	__blk_put_request(q, rq);
+	blk_put_queue(q);
+}
+
+int dm_scsi_execute_rq(struct hw_handler *hwh, struct path *path,
+		       const unsigned char *cmd, int data_direction,
+		       void *buffer, unsigned bufflen, int timeout,
+		       unsigned int gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(path->dev->bdev);
+	struct block_device *bdev = path->dev->bdev;
+	struct dm_scsi_io_context *scsi_ioc = hwh->pg_init_context;
+	struct request *rq;
+
+	BUG_ON(!scsi_ioc);
+
+	if (!q) {
+		DMERR("Could not get queue.");
+		return -EINVAL;
+	}
+
+	/*
+	 * make sure someone does not free this queue while we are
+	 * touching it
+	 */
+	if (blk_get_queue(q))
+		return -EINVAL;
+
+	rq = blk_get_request(q, data_direction == DMA_TO_DEVICE, gfp_mask);
+	if (!rq)
+		goto put_queue;
+
+	if (bufflen && blk_rq_map_kern(q, rq, buffer, bufflen, gfp_mask))
+		goto put_rq;
+
+	rq->sense = scsi_ioc->sense;
+	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense_len = 0;
+
+	memset(&rq->cmd, 0, BLK_MAX_CDB);
+	rq->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(rq->cmd, cmd, rq->cmd_len);
+
+	scsi_ioc->hwh = hwh;
+	scsi_ioc->path = path;
+	rq->end_io_data = scsi_ioc;
+
+	rq->timeout = timeout;
+	rq->flags |= (REQ_BLOCK_PC | REQ_FAILFAST | REQ_NOMERGE);
+
+	blk_execute_rq_nowait(q, bdev->bd_contains->bd_disk, rq, 1,
+			      dm_scsi_end_rq);
+	return 0;
+
+put_rq:
+	blk_put_request(rq);
+put_queue:
+	blk_put_queue(q);
+	return -ENOMEM;
+}
+
 unsigned dm_scsi_err_handler(struct hw_handler *hwh, struct bio *bio)
 {
 #if 0
@@ -214,3 +341,6 @@ unsigned dm_scsi_err_handler(struct hw_h
 EXPORT_SYMBOL_GPL(dm_register_hw_handler);
 EXPORT_SYMBOL_GPL(dm_unregister_hw_handler);
 EXPORT_SYMBOL_GPL(dm_scsi_err_handler);
+EXPORT_SYMBOL_GPL(dm_scsi_execute_rq);
+EXPORT_SYMBOL_GPL(dm_scsi_init_context_pool);
+EXPORT_SYMBOL_GPL(dm_scsi_destroy_context_pool);
diff --git a/drivers/md/dm-hw-handler.h b/drivers/md/dm-hw-handler.h
--- a/drivers/md/dm-hw-handler.h
+++ b/drivers/md/dm-hw-handler.h
@@ -10,15 +10,17 @@
 #define	DM_HW_HANDLER_H
 
 #include <linux/device-mapper.h>
-
+#include <scsi/scsi_cmnd.h>
 #include "dm-mpath.h"
 
 struct hw_handler_type;
 struct hw_handler {
 	struct hw_handler_type *type;
 	void *context;
+	void *pg_init_context;		/* for protocol (SCSI, DASD, etc) use */
 };
 
+struct scsi_sense_hdr;
 /*
  * Constructs a hardware handler object, takes custom arguments
  */
@@ -36,6 +38,8 @@ struct hw_handler_type {
 	unsigned (*error) (struct hw_handler *hwh, struct bio *bio);
 	int (*status) (struct hw_handler *hwh, status_type_t type,
 		       char *result, unsigned int maxlen);
+	unsigned (*rq_error) (struct path *path, int result,
+			      struct scsi_sense_hdr *sense);
 };
 
 /* Register a hardware handler */
@@ -53,6 +57,19 @@ void dm_put_hw_handler(struct hw_handler
 /* Default err function */
 unsigned dm_scsi_err_handler(struct hw_handler *hwh, struct bio *bio);
 
+/* Create/destroy scsi context pool for failover */
+int dm_scsi_init_context_pool(struct hw_handler *hwh);
+void dm_scsi_destroy_context_pool(struct hw_handler *hwh);
+
+/*
+ * execute a request, the hw_handler will be notified of the result
+ * in its rq_error function.
+ */
+int dm_scsi_execute_rq(struct hw_handler *hwh, struct path *path,
+		       const unsigned char *cmd, int data_direction,
+		       void *buffer, unsigned bufflen, int timeout,
+		       unsigned int gfp_mask);
+
 /* Error flags for err and dm_pg_init_complete */
 #define MP_FAIL_PATH 1
 #define MP_BYPASS_PG 2
