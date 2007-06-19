From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] Add logical unit follow-over capability to dm-emc
Date: Tue, 19 Jun 2007 15:52:21 -0500
Message-ID: <1182286341.2580.9.camel@madmax>
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
To: egoggin@vmware.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

This is a update to Ed Goggin's patch which added logical unit follow-over
capability and improved the event logging of dm-emc.c. The only difference
between Ed's last versions and this is that I updated the patch for upstream
by:
- Updating to new work queue api.
- Updating for dm_path rename.
- Update for hwh.md change.

This patch keeps dm-emc in step with dm-rdac feature wise (transition sense
decoding, failback/failover optimizations, etc).

Alasdair, if you think scsi hw handlers are going to be a long drawn out
process, then Ed's work would be nice for users so they have the same
level of support as rdac users.

Signed-off-by: Edward Goggin <egoggin@lcld0081.lss.emc.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Patch was made against 2.6.22-rc5.

--- linux-2.6.22-rc5/drivers/md/dm-emc.c	2007-06-16 21:09:12.000000000 -0500
+++ linux-2.6.22-rc5.work/drivers/md/dm-emc.c	2007-06-19 15:02:27.000000000 -0500
@@ -7,228 +7,461 @@
  * Multipath support for EMC CLARiiON AX/CX-series hardware.
  */
 
+/* Code borrowed from dm-lsi-rdac by Mike Christie */
+
 #include "dm.h"
 #include "dm-hw-handler.h"
 #include <scsi/scsi.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_cmnd.h>
 
-#define DM_MSG_PREFIX "multipath emc"
+#define DM_MSG_PREFIX		"multipath emc"
+#define TRESPASS_PAGE		0x22
+#define BUFFER_SIZE		0x80
+#define EMC_HANDLER_TIMEOUT	(60 * HZ)
+#define UNBOUND_LU		-1
 
+/*
+ * Four variations of the CLARiiON trespass MODE_SELECT page.
+ */
+unsigned char long_trespass_and_hr_pg[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x09,                 /* Page length - 2 */
+	0x01,  		      /* Trespass code + Honor reservation bit */
+	0xff, 0xff,           /* Trespass target */
+	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
+};
+unsigned char long_trespass_pg[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x09,                 /* Page length - 2 */
+	0x81,  		      /* Trespass code + Honor reservation bit */
+	0xff, 0xff,           /* Trespass target */
+	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
+};
+unsigned char short_trespass_and_hr_pg[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x02,                 /* Page length - 2 */
+	0x01,  		      /* Trespass code + Honor reservation bit */
+	0xff,                 /* Trespass target */
+};
+unsigned char short_trespass_pg[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x02,                 /* Page length - 2 */
+	0x81,  		      /* Trespass code + Honor reservation bit */
+	0xff,                 /* Trespass target */
+};
+
+/*
+ * EMC hardware handler context structure containing CLARiiON LU specific
+ * information for a particular dm multipath mapped device.
+ */
 struct emc_handler {
 	spinlock_t lock;
-
-	/* Whether we should send the short trespass command (FC-series)
-	 * or the long version (default for AX/CX CLARiiON arrays). */
+	struct hw_handler *hwh;
+	struct dm_path *path;
+	struct work_struct wkq;
+	/* Use short trespass command (FC-series) or the long version
+	 * (default for AX/CX CLARiiON arrays). */
 	unsigned short_trespass;
-	/* Whether or not to honor SCSI reservations when initiating a
-	 * switch-over. Default: Don't. */
+	/* Whether or not (default) to honor SCSI reservations when
+	 * initiating a switch-over. */
 	unsigned hr;
-
+	/* I/O buffer for both MODE_SELECT and INQUIRY commands. */
+	char buffer[BUFFER_SIZE];
+	/* SCSI sense buffer for commands -- assumes serial issuance
+	 * and completion sequence of all commands for same multipath. */
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	/* which SP (A=0,B=1,UNBOUND=-1) is dflt SP for path's mapped dev */
+	int default_sp;
+	/* which SP (A=0,B=1,UNBOUND=-1) is active for path's mapped dev */
+	int current_sp;
+	/*
+	 * flag when set (reset) differentiates get_sp_info after (before)
+	 * pg_init
+	 */
+	int pg_init_sent;
 };
 
-#define TRESPASS_PAGE 0x22
-#define EMC_FAILOVER_TIMEOUT (60 * HZ)
+static int send_cmd(struct emc_handler *h, struct dm_path *path, int cmd,
+		    rq_end_io_fn *endio);
+static rq_end_io_fn sp_info_endio, pg_init_endio;
+static int parse_sp_info_reply(struct request *req, struct emc_handler *h,
+			       struct dm_path *path, int *default_sp,
+			       int *current_sp, int *new_current_sp);
+static int parse_pg_init_reply(struct request *req, struct emc_handler *h,
+			       struct dm_path *path);
 
-/* Code borrowed from dm-lsi-rdac by Mike Christie */
+struct workqueue_struct *kemchd;
 
-static inline void free_bio(struct bio *bio)
-{
-	__free_page(bio->bi_io_vec[0].bv_page);
-	bio_put(bio);
+/*
+ * Parse EVPD 0xC0 INQUIRY cmd reply.
+ */
+static int parse_sp_info_reply(struct request *req, struct emc_handler *h,
+			       struct dm_path *path, int *default_sp,
+			       int *current_sp, int *new_current_sp)
+{
+	int err = 0;
+
+	if (req->errors == 0) {
+		/* check for in-progress ucode upgrade (NDU) */
+		if (h->buffer[48] != 0) {
+			DMWARN("Detected in-progress ucode upgrade NDU "
+			       "operation while finding current active "
+			       "SP for mapped device %s using path %s.",
+			       dm_device_name(h->hwh->md), path->dev->name);
+			err = MP_BYPASS_PG;
+		} else {
+			*default_sp = h->buffer[5];
+
+			if (h->buffer[4] == 2)
+				/* SP for path (in h->buffer[8]) is current */
+				*current_sp = h->buffer[8];
+			else {
+				if (h->buffer[4] == 1)
+					/* SP for this path is NOT current */
+					if (h->buffer[8] == 0)
+						*current_sp = 1;
+					else
+						*current_sp = 0;
+				else
+					/* unbound LU or LUNZ */
+					*current_sp = UNBOUND_LU;
+			}
+			*new_current_sp =  h->buffer[8];
+		}
+	} else {
+		struct scsi_sense_hdr sshdr;
+
+		err = MP_FAIL_PATH;
+
+		if (req->sense_len && scsi_normalize_sense(req->sense,
+                                                           req->sense_len,
+							   &sshdr))
+			DMERR("Found valid sense data 0x%2x, 0x%2x, 0x%2x "
+			      "while finding current active SP for "
+			      "mapped device %s using path %s.",
+                              sshdr.sense_key, sshdr.asc, sshdr.ascq,
+			      dm_device_name(h->hwh->md), path->dev->name);
+		else DMERR("Error 0x%x finding current active SP for "
+                           "mapped device %s using path %s.", req->errors,
+			   dm_device_name(h->hwh->md), path->dev->name);
+	}
+
+	return (err);
 }
 
-static int emc_endio(struct bio *bio, unsigned int bytes_done, int error)
+/*
+ * Parse MODE_SELECT cmd reply.
+ */
+static int parse_pg_init_reply(struct request *req, struct emc_handler *h,
+			       struct dm_path *path)
 {
-	struct dm_path *path = bio->bi_private;
+	struct scsi_sense_hdr sshdr;
+	int err = 0;
 
-	if (bio->bi_size)
-		return 1;
+	if (req->sense_len && scsi_normalize_sense(req->sense,
+						   req->sense_len, &sshdr)) {
 
-	/* We also need to look at the sense keys here whether or not to
-	 * switch to the next PG etc.
-	 *
-	 * For now simple logic: either it works or it doesn't.
-	 */
-	if (error)
-		dm_pg_init_complete(path, MP_FAIL_PATH);
-	else
-		dm_pg_init_complete(path, 0);
+		DMERR("Found valid sense data 0x%2x, 0x%2x, 0x%2x while "
+                      "sending CLARiiON trespass command for mapped "
+		      "device %s using path %s.",
+		       sshdr.sense_key, sshdr.asc, sshdr.ascq,
+		       dm_device_name(h->hwh->md), path->dev->name);
+
+		if ((sshdr.sense_key = 0x05) &&
+                    (sshdr.asc = 0x04) &&
+                    (sshdr.ascq = 0x00)) {
+			/*
+			 * Array based copy in progress -- do not send
+			 * pg_init or copy will be aborted mid-stream.
+			 */
+			DMWARN("Array Based Copy in progress while "
+			       "sending CLARiiON trespass command for "
+			       "mapped device %s using path %s.",
+			       dm_device_name(h->hwh->md), path->dev->name);
+			err = MP_BYPASS_PG;
+		} else if ((sshdr.sense_key = 0x02) &&
+                           (sshdr.asc = 0x04) &&
+                           (sshdr.ascq = 0x03)) {
+			/*
+			 * LUN Not Ready - Manual Intervention Required
+			 * indicates in-progress ucode upgrade (NDU).
+			 */
+			DMWARN("Detected in-progress ucode upgrade NDU "
+			       "operation while sending CLARiiON trespass "
+			       " command for mapped device %s using path %s.",
+			       dm_device_name(h->hwh->md), path->dev->name);
+			err = MP_BYPASS_PG;
+		} else
+			err = MP_FAIL_PATH;
+	} else if (req->errors) {
+		DMERR("Error 0x%x while sending CLARiiON trespass command "
+		      "for apped device %s using path %s.", req->errors,
+		      dm_device_name(h->hwh->md), path->dev->name);
+		err = MP_FAIL_PATH;
+	}
 
-	/* request is freed in block layer */
-	free_bio(bio);
+	/* release ref on block request */
+	__blk_put_request(req->q, req);
 
-	return 0;
+	return (err);
 }
 
-static struct bio *get_failover_bio(struct dm_path *path, unsigned data_size)
+/*
+ * Completion handler for EVPD page 0xC0 INQUIRY cmd.
+ */
+static void sp_info_endio(struct request *req, int uptodate)
 {
-	struct bio *bio;
-	struct page *page;
+	struct dm_path *path = req->end_io_data;
+	struct emc_handler *h = (struct emc_handler *)path->hwhcontext;
+	int default_sp, current_sp, new_current_sp;
+	unsigned long flags;
+	int err_flags;
 
-	bio = bio_alloc(GFP_ATOMIC, 1);
-	if (!bio) {
-		DMERR("get_failover_bio: bio_alloc() failed.");
-		return NULL;
-	}
+	if ((err_flags = parse_sp_info_reply(req, h, path, &default_sp,
+					     &current_sp, &new_current_sp))) {
+		dm_pg_init_complete(path, err_flags);
 
-	bio->bi_rw |= (1 << BIO_RW);
-	bio->bi_bdev = path->dev->bdev;
-	bio->bi_sector = 0;
-	bio->bi_private = path;
-	bio->bi_end_io = emc_endio;
-
-	page = alloc_page(GFP_ATOMIC);
-	if (!page) {
-		DMERR("get_failover_bio: alloc_page() failed.");
-		bio_put(bio);
-		return NULL;
+		/* release ref on block request */
+		__blk_put_request(req->q, req);
+
+		return;
 	}
 
-	if (bio_add_page(bio, page, data_size, 0) != data_size) {
-		DMERR("get_failover_bio: alloc_page() failed.");
-		__free_page(page);
-		bio_put(bio);
-		return NULL;
+	/* release ref on block request */
+	__blk_put_request(req->q, req);
+
+	spin_lock_irqsave(&h->lock, flags);
+	if (h->pg_init_sent) {
+		h->default_sp = default_sp;
+		h->current_sp = current_sp;
+		h->pg_init_sent = 0;
+		spin_unlock_irqrestore(&h->lock, flags);
+
+		/* done now */
+		dm_pg_init_complete(path, 0);
+	} else {
+		spin_unlock_irqrestore(&h->lock, flags);
+		/*
+                 * Do not issue the actual pg_init request if either (1)
+		 * we do not know the identity of the current SP or (2)
+		 * the prospective new SP is already current.
+                 */
+		if ((current_sp != UNBOUND_LU) &&
+		    (new_current_sp == current_sp)) {
+
+			spin_lock_irqsave(&h->lock, flags);
+			if (h->default_sp == UNBOUND_LU) {
+				h->default_sp = default_sp;
+				h->current_sp = current_sp;
+			}
+			spin_unlock_irqrestore(&h->lock, flags);
+
+			/* yet, its as good as doing it */
+			dm_pg_init_complete(path, 0);
+
+			DMINFO("Ignoring path group switch-over command for "
+			       "CLARiiON SP%s since mapped device %s is "
+			       "already initialized for path %s.",
+                               current_sp ? "B" : "A",
+			       dm_device_name(h->hwh->md), path->dev->name);
+		} else {
+			/* send path initialization request */
+			DMINFO("Issuing CLARiiON trespass command to "
+                               "activate SP%s for mapped device %s using "
+			       "path %s.", new_current_sp ? "B" : "A",
+                               dm_device_name(h->hwh->md), path->dev->name);
+
+			h->path = path;	/* kemchd will use this path */
+			queue_work(kemchd, &h->wkq);
+		}
 	}
 
-	return bio;
+	return;
+}
+
+/*
+ * Completion handler for MODE_SELECT cmd.
+ */
+static void pg_init_endio(struct request *req, int uptodate)
+{
+	struct dm_path *path = req->end_io_data;
+	struct emc_handler *h = (struct emc_handler *)path->hwhcontext;
+	int err_flags;
+
+	if ((err_flags = parse_pg_init_reply(req, h, path)))
+		dm_pg_init_complete(path, err_flags);
+
+	/* release ref on block request */
+	__blk_put_request(req->q, req);
+
+	/* send sp_info request */
+	h->pg_init_sent = 1;
+	queue_work(kemchd, &h->wkq);
+
+	return;
 }
 
-static struct request *get_failover_req(struct emc_handler *h,
-					struct bio *bio, struct dm_path *path)
+/*
+ * Get block request for REQ_BLOCK_PC command issued to path.  Currently
+ * limited to MODE_SELECT (trespass) and INQUIRY (VPD page 0xC0) commands.
+ *
+ * Uses data and sense buffers in hardware handler context structure and
+ * assumes serial servicing of commands, both issuance and completion.
+ */
+static struct request *get_req(struct dm_path *path, int opcode)
 {
+	struct emc_handler *h = (struct emc_handler *)path->hwhcontext;
+	struct request_queue *q = bdev_get_queue(path->dev->bdev);
 	struct request *rq;
-	struct block_device *bdev = bio->bi_bdev;
-	struct request_queue *q = bdev_get_queue(bdev);
+	void *buffer;
+	int len = 0;
 
-	/* FIXME: Figure out why it fails with GFP_ATOMIC. */
-	rq = blk_get_request(q, WRITE, __GFP_WAIT);
+	rq = blk_get_request(q, (opcode == MODE_SELECT) ? WRITE : READ,
+			     __GFP_WAIT);
 	if (!rq) {
-		DMERR("get_failover_req: blk_get_request failed");
+		DMERR("dm-emc: get_req: blk_get_request failed");
 		return NULL;
 	}
 
-	rq->bio = rq->biotail = bio;
-	blk_rq_bio_prep(q, rq, bio);
-
-	rq->rq_disk = bdev->bd_contains->bd_disk;
+	memset(&rq->cmd, 0, BLK_MAX_CDB);
+	rq->cmd[0] = opcode;
+	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
 
-	/* bio backed don't set data */
-	rq->buffer = rq->data = NULL;
-	/* rq data_len used for pc cmd's request_bufflen */
-	rq->data_len = bio->bi_size;
+	switch (opcode) {
+	case MODE_SELECT:
+		rq->cmd_flags |= REQ_RW;
+		rq->cmd[1] = 0x10;
+		len = h->short_trespass ? sizeof(short_trespass_and_hr_pg) :
+				        sizeof(long_trespass_and_hr_pg);
+		buffer = h->short_trespass ?
+			       h->hr ? short_trespass_and_hr_pg
+				     : short_trespass_pg
+			     :
+			       h->hr ? long_trespass_and_hr_pg
+				     : long_trespass_pg;
+		/*
+		 * Can't DMA from kernel BSS -- must copy selected trespass
+		 * command mode page contents to context buffer which is
+		 * allocated by kmalloc.
+		 */
+		BUG_ON((len > BUFFER_SIZE));
+		memcpy(h->buffer, buffer, len);
+		break;
+	case INQUIRY:
+		rq->cmd[1] = 0x1;
+		rq->cmd[2] = 0xC0;
+		len = BUFFER_SIZE;
+		memset(h->buffer, 0, BUFFER_SIZE);
+		break;
+	default:
+		BUG_ON(1);
+		break;
+	}
+	rq->cmd[4] = len;
+
+	if (blk_rq_map_kern(q, rq, h->buffer, len, __GFP_WAIT)) {
+		DMERR("dm-emc: get_req: blk_rq_map_kern failed");
+		blk_put_request(rq);
+		return NULL;
+	}
 
 	rq->sense = h->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
 
-	memset(&rq->cmd, 0, BLK_MAX_CDB);
-
-	rq->timeout = EMC_FAILOVER_TIMEOUT;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
+	rq->timeout = EMC_HANDLER_TIMEOUT;
+	rq->retries = 0;
 
 	return rq;
 }
 
-static struct request *emc_trespass_get(struct emc_handler *h,
-					struct dm_path *path)
+/*
+ * Send cmd and setup asynchronous i/o completion handler.
+ */
+static int send_cmd(struct emc_handler *h, struct dm_path *path, int cmd,
+		    rq_end_io_fn *endio)
 {
-	struct bio *bio;
+	struct request_queue *q = bdev_get_queue(path->dev->bdev);
 	struct request *rq;
-	unsigned char *page22;
-	unsigned char long_trespass_pg[] = {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x09,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation bit */
-		0xff, 0xff,           /* Trespass target */
-		0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
-		};
-	unsigned char short_trespass_pg[] = {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x02,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation bit */
-		0xff,                 /* Trespass target */
-		};
-	unsigned data_size = h->short_trespass ? sizeof(short_trespass_pg) :
-				sizeof(long_trespass_pg);
-
-	/* get bio backing */
-	if (data_size > PAGE_SIZE)
-		/* this should never happen */
-		return NULL;
-
-	bio = get_failover_bio(path, data_size);
-	if (!bio) {
-		DMERR("emc_trespass_get: no bio");
-		return NULL;
-	}
 
-	page22 = (unsigned char *)bio_data(bio);
-	memset(page22, 0, data_size);
-
-	memcpy(page22, h->short_trespass ?
-		short_trespass_pg : long_trespass_pg, data_size);
+	/* get and initialize block request */
+	rq = get_req(path, cmd);
+	if (!rq)
+		return MP_FAIL_PATH;
+
+	/* issue the cmd asynchronously (at head of q) */
+	rq->end_io_data = path;
+	blk_execute_rq_nowait(q, NULL, rq, 1, endio);
+	return 0;
+}
 
-	/* get request for block layer packet command */
-	rq = get_failover_req(h, bio, path);
-	if (!rq) {
-		DMERR("emc_trespass_get: no rq");
-		free_bio(bio);
-		return NULL;
+/*
+ * Work queue service routine used to issue i/o without already holding
+ * a request queue lock.
+ */
+static void service_wkq(struct work_struct *work)
+{
+	struct emc_handler *h = container_of(work, struct emc_handler, wkq);
+	struct dm_path *path = h->path;
+	int err_flags;
+
+	if (h->pg_init_sent) {
+		if ((err_flags = send_cmd(h, path, INQUIRY,
+					  sp_info_endio))) {
+			h->pg_init_sent = 0;
+			dm_pg_init_complete(path, err_flags);
+		}
+	}
+	else {
+		/* send pg_init request */
+		if ((err_flags = send_cmd(h, path, MODE_SELECT,
+					  pg_init_endio)))
+			dm_pg_init_complete(path, err_flags);
 	}
-
-	/* Prepare the command. */
-	rq->cmd[0] = MODE_SELECT;
-	rq->cmd[1] = 0x10;
-	rq->cmd[4] = data_size;
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
-
-	return rq;
 }
 
+/* initialize path group command */
 static void emc_pg_init(struct hw_handler *hwh, unsigned bypassed,
 			struct dm_path *path)
 {
-	struct request *rq;
-	struct request_queue *q = bdev_get_queue(path->dev->bdev);
+	struct emc_handler *h = (struct emc_handler *)hwh->context;
+	int err_flags;
 
-	/*
-	 * We can either blindly init the pg (then look at the sense),
-	 * or we can send some commands to get the state here (then
-	 * possibly send the fo cmnd), or we can also have the
-	 * initial state passed into us and then get an update here.
-	 */
-	if (!q) {
-		DMINFO("emc_pg_init: no queue");
-		goto fail_path;
-	}
+	path->hwhcontext = h; /* needed by endio handlers */
 
-	/* FIXME: The request should be pre-allocated. */
-	rq = emc_trespass_get(hwh->context, path);
-	if (!rq) {
-		DMERR("emc_pg_init: no rq");
-		goto fail_path;
-	}
-
-	DMINFO("emc_pg_init: sending switch-over command");
-	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
+	if ((err_flags = send_cmd(h, path, INQUIRY, sp_info_endio)))
+		dm_pg_init_complete(path, err_flags);
 	return;
-
-fail_path:
-	dm_pg_init_complete(path, MP_FAIL_PATH);
 }
 
-static struct emc_handler *alloc_emc_handler(void)
+static struct emc_handler *alloc_emc_handler(unsigned int short_trespass,
+					     unsigned hr)
 {
-	struct emc_handler *h = kmalloc(sizeof(*h), GFP_KERNEL);
+	struct emc_handler *h = kzalloc(sizeof(*h), GFP_KERNEL);
 
 	if (h) {
-		memset(h, 0, sizeof(*h));
 		spin_lock_init(&h->lock);
+
+		INIT_WORK(&h->wkq, service_wkq);
+
+		if ((h->short_trespass = short_trespass))
+			DMINFO("Short trespass command to be sent.");
+		else
+			DMINFO("Long trespass command to be sent (default).");
+		if ((h->hr = hr))
+			DMINFO("Honor reservation bit will be set.");
+		else
+			DMINFO("Honor reservation bit is not set (default).");
+
+		h->default_sp = UNBOUND_LU;
+		h->current_sp = UNBOUND_LU;
 	}
 
 	return h;
@@ -244,37 +477,30 @@ static int emc_create(struct hw_handler 
 		hr = 0;
 		short_trespass = 0;
 	} else if (argc != 2) {
-		DMWARN("incorrect number of arguments");
+		DMWARN("Incorrect number (0x%x) of arguments.  "
+		       "Should be 2.", argc);
 		return -EINVAL;
 	} else {
 		if ((sscanf(argv[0], "%u", &short_trespass) != 1)
 			|| (short_trespass > 1)) {
-			DMWARN("invalid trespass mode selected");
+			DMWARN("Invalid trespass mode (0x%x) selected.",
+			       short_trespass);
 			return -EINVAL;
 		}
 
 		if ((sscanf(argv[1], "%u", &hr) != 1)
 			|| (hr > 1)) {
-			DMWARN("invalid honor reservation flag selected");
+			DMWARN("Invalid honor reservation flag (0x%x).", hr);
 			return -EINVAL;
 		}
 	}
 
-	h = alloc_emc_handler();
+	h = alloc_emc_handler(short_trespass, hr);
 	if (!h)
 		return -ENOMEM;
 
 	hwh->context = h;
-
-	if ((h->short_trespass = short_trespass))
-		DMWARN("short trespass command will be send");
-	else
-		DMWARN("long trespass command will be send");
-
-	if ((h->hr = hr))
-		DMWARN("honor reservation bit will be set");
-	else
-		DMWARN("honor reservation bit will not be set (default)");
+	h->hwh = hwh;
 
 	return 0;
 }
@@ -325,6 +551,31 @@ static unsigned emc_error(struct hw_hand
 	return dm_scsi_err_handler(hwh, bio);
 }
 
+static int emc_status(struct hw_handler *hwh, status_type_t type,
+		      char *result, unsigned int maxlen)
+{
+	struct emc_handler *h = (struct emc_handler *)hwh->context;
+	unsigned long flags;
+
+	int sz = 0;
+
+	spin_lock_irqsave(&h->lock, flags);
+
+	if (type == STATUSTYPE_INFO)
+		DMEMIT("2 %d %d ", h->default_sp, h->current_sp);
+	else {
+		if (h->short_trespass || h->hr)
+			DMEMIT("3 %s %u %u ", hwh->type->name,
+			       h->short_trespass, h->hr);
+		else
+			DMEMIT("1 %s ", hwh->type->name);
+	}
+
+	spin_unlock_irqrestore(&h->lock, flags);
+
+	return sz;
+}
+
 static struct hw_handler_type emc_hwh = {
 	.name = "emc",
 	.module = THIS_MODULE,
@@ -332,6 +583,7 @@ static struct hw_handler_type emc_hwh = 
 	.destroy = emc_destroy,
 	.pg_init = emc_pg_init,
 	.error = emc_error,
+	.status = emc_status,
 };
 
 static int __init dm_emc_init(void)
@@ -339,19 +591,30 @@ static int __init dm_emc_init(void)
 	int r = dm_register_hw_handler(&emc_hwh);
 
 	if (r < 0)
-		DMERR("register failed %d", r);
+		DMERR("Register failed %d.", r);
+	else {
+		kemchd = create_singlethread_workqueue("kemchd");
+		if (!kemchd) {
+			DMERR("Failed to create workqueue kemchd.");
+			dm_unregister_hw_handler(&emc_hwh);
+			return -ENOMEM;
+		}
+	}
 
-	DMINFO("version 0.0.3 loaded");
+	DMINFO("Version 0.0.4 loaded.");
 
 	return r;
 }
 
 static void __exit dm_emc_exit(void)
 {
-	int r = dm_unregister_hw_handler(&emc_hwh);
+	int r;
+
+	destroy_workqueue(kemchd);
 
+	r = dm_unregister_hw_handler(&emc_hwh);
 	if (r < 0)
-		DMERR("unregister failed %d", r);
+		DMERR("Unregister failed %d.", r);
 }
 
 module_init(dm_emc_init);
