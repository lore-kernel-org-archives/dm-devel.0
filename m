From: Edward Goggin <egoggin@emc.com>
Subject: 1st of 2 patches for dm_emc.c and dm-multipath hardware
	handler interface
Date: Thu, 31 Aug 2006 10:32:09 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1397@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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
Cc: michaelc@cs.wisc.edu, agk@redhat.com
List-Id: dm-devel.ids

This is the 2nd take on a set of patches submitted about
3 weeks ago intended to (1) avoid unnecessary dm-multipath
path group switch-over events for EMC CLARiiON and
(2) improve the event logging of the dm-multipath hardware
handler interface.

This patch set differs from previous patch set by:

- There are now two patches -- the first for content
specific to the EMC CLARiiON dm-multipath hardware
handler dm_emc.c. -- the second to dm, dm-multipath,
and dm-multipath hardware handler framework code to
support an improved event logging capability for=20
hardware handlers.

- The dm_emc.c hw handler now gets requests from
blk_get_request instead of using pre-allocated requests.
As a result, the rq_init macro of ll_rw_blk.c is no
longer converted to a function and exported.

- The dm_emc.c hw handler now issues its ios asynchronously
via blk_execute_rq_nowait and has a single threaded worker
queue to allocate and queue the io requests.

- The 2nd patch exports dm_put instead of a new function
dm_table_put_md.

- The 2nd patch modifies the dm-multipath hardware handler
interface by adding a 4th parameter, a ptr to the mapped
device, to the create callout instead of adding a new init
callout.  dm_mpath.c and dm_emc.c are changed to pass and
use this additional parameter respectively.

- Coding and patch conventions followed.
	use "diff -up"
	no lines of code > 80 chars
	avoids mixed case variable names
	start else clause on same line as "}"
	EXPORT_SYMBOL_GPL reference immediately after function

This is the first patch (dm_emc.c only) in a set of 2 patches.

Signed-off-by: Ed Goggin <egoggin@emc.com>
--- linux-2.6.18-rc4/drivers/md/dm-emc.c.orig	2006-08-28
22:37:34.000000000 -0500
+++ linux-2.6.18-rc4/drivers/md/dm-emc.c	2006-08-28
22:20:17.000000000 -0500
@@ -7,227 +7,448 @@
  * Multipath support for EMC CLARiiON AX/CX-series hardware.
  */
=20
+/* Code borrowed from dm-lsi-rdac by Mike Christie */
+
 #include "dm.h"
 #include "dm-hw-handler.h"
 #include <scsi/scsi.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_cmnd.h>
=20
-#define DM_MSG_PREFIX "multipath emc"
+#define DM_MSG_PREFIX		"multipath emc"
+#define TRESPASS_PAGE		0x22
+#define BUFFER_SIZE		0x80
+#define EMC_HANDLER_TIMEOUT	(60 * HZ)
+#define UNBOUND_LU		-1
=20
+/*
+ * Four variations of the CLARiiON trespass MODE_SENSE page.
+ */
+unsigned char long_trespass_and_hr_pg[] =3D {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x09,                 /* Page length - 2 */
+	0x01,  		      /* Trespass code + Honor reservation bit
*/
+	0xff, 0xff,           /* Trespass target */
+	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
+};
+unsigned char long_trespass_pg[] =3D {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x09,                 /* Page length - 2 */
+	0x81,  		      /* Trespass code + Honor reservation bit
*/
+	0xff, 0xff,           /* Trespass target */
+	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
+};
+unsigned char short_trespass_and_hr_pg[] =3D {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x02,                 /* Page length - 2 */
+	0x01,  		      /* Trespass code + Honor reservation bit
*/
+	0xff,                 /* Trespass target */
+};
+unsigned char short_trespass_pg[] =3D {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x02,                 /* Page length - 2 */
+	0x81,  		      /* Trespass code + Honor reservation bit
*/
+	0xff,                 /* Trespass target */
+};
+
+/*
+ * EMC hardware handler context structure containing CLARiiON LU
specific
+ * information for a particular dm multipath mapped device.
+ */
 struct emc_handler {
 	spinlock_t lock;
-
-	/* Whether we should send the short trespass command (FC-series)
-	 * or the long version (default for AX/CX CLARiiON arrays). */
+	struct hw_handler *hwh;
+	struct path *path;
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
+	 * and completion sequence of all commands for same multipath.
*/
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	/* which SP (A=3D0,B=3D1,UNBOUND=3D-1) is dflt SP for path's mapped
dev */
+	int default_sp;
+	/* which SP (A=3D0,B=3D1,UNBOUND=3D-1) is active for path's mapped dev
*/
+	int current_sp;
+	/*
+	 * flag when set (reset) differentiates get_sp_info after
(before)
+	 * pg_init
+	 */
+	int pg_init_sent;
 };
=20
-#define TRESPASS_PAGE 0x22
-#define EMC_FAILOVER_TIMEOUT (60 * HZ)
+static int send_cmd(struct emc_handler *h, struct path *path, int cmd,
+		    rq_end_io_fn *endio);
+static rq_end_io_fn sp_info_endio, pg_init_endio;
+static int parse_sp_info_reply(struct request *req, struct emc_handler
*h,
+			       struct path *path, int *default_sp,
+			       int *current_sp, int *new_current_sp);
+static int parse_pg_init_reply(struct request *req, struct emc_handler
*h,
+			       struct path *path);
=20
-/* Code borrowed from dm-lsi-rdac by Mike Christie */
+struct workqueue_struct *kemchd;
=20
-static inline void free_bio(struct bio *bio)
-{
-	__free_page(bio->bi_io_vec[0].bv_page);
-	bio_put(bio);
+/*
+ * Parse EVPD 0xC0 INQUIRY cmd reply.
+ */
+static int parse_sp_info_reply(struct request *req, struct emc_handler
*h,
+			       struct path *path, int *default_sp,
+			       int *current_sp, int *new_current_sp)
+{
+	int err =3D 0;
+
+	if (req->errors =3D=3D 0) {
+		/* check for in-progress ucode upgrade (NDU) */
+		if (h->buffer[48] !=3D 0) {
+			DMWARN("Detected in-progress ucode upgrade NDU "
+			       "operation while finding current active "
+			       "SP using path %s.", path->dev->name);
+			err =3D MP_BYPASS_PG;
+		} else {
+			*default_sp =3D h->buffer[5];
+
+			if (h->buffer[4] =3D=3D 2)
+				/* SP for path (in h->buffer[8]) is
current */
+				*current_sp =3D h->buffer[8];
+			else {
+				if (h->buffer[4] =3D=3D 1)
+					/* SP for this path is NOT
current */
+					if (h->buffer[8] =3D=3D 0)
+						*current_sp =3D 1;
+					else
+						*current_sp =3D 0;
+				else
+					/* unbound LU or LUNZ */
+					*current_sp =3D UNBOUND_LU;
+			}
+			*new_current_sp =3D  h->buffer[8];
+		}
+	} else {
+		struct scsi_sense_hdr sshdr;
+
+		err =3D MP_FAIL_PATH;
+
+		if (req->sense_len && scsi_normalize_sense(req->sense,
+
req->sense_len,
+							   &sshdr))
+			DMERR("Found valid sense data 0x%2x, 0x%2x,
0x%2x "
+			      "while finding current active SP using
path %s.",
+		       	      sshdr.sense_key, sshdr.asc, sshdr.ascq,
+			      path->dev->name);
+		else DMERR("Error 0x%x finding current active SP using "
+		     	   "path %s.", req->errors, path->dev->name);
+	}
+
+	return (err);
 }
=20
-static int emc_endio(struct bio *bio, unsigned int bytes_done, int
error)
+/*
+ * Parse MODE_SELECT cmd reply.
+ */
+static int parse_pg_init_reply(struct request *req, struct emc_handler
*h,
+			       struct path *path)
 {
-	struct path *path =3D bio->bi_private;
+	struct scsi_sense_hdr sshdr;
+	int err =3D 0;
=20
-	if (bio->bi_size)
-		return 1;
+	if (req->sense_len && scsi_normalize_sense(req->sense,
+						   req->sense_len,
&sshdr)) {
=20
-	/* We also need to look at the sense keys here whether or not to
-	 * switch to the next PG etc.
-	 *
-	 * For now simple logic: either it works or it doesn't.
-	 */
-	if (error)
-		dm_pg_init_complete(path, MP_FAIL_PATH);
-	else
-		dm_pg_init_complete(path, 0);
+		DMERR("Found valid sense data 0x%2x, 0x%2x, 0x%2x while
"
+		      "sending CLARiiON trespass command using path
%s.",
+		      sshdr.sense_key, sshdr.asc, sshdr.ascq,
path->dev->name);
+
+		if ((sshdr.sense_key =3D 0x05) &&
+	    	    (sshdr.asc =3D 0x04) &&
+	    	    (sshdr.ascq =3D 0x00)) {
+			/*
+			 * Array based copy in progress -- do not send
+			 * pg_init or copy will be aborted mid-stream.
+			 */
+			DMWARN("Array Based Copy in progress while "
+			       "sending CLARiiON trespass command "
+			       "using path %s.", path->dev->name);
+			err =3D MP_BYPASS_PG;
+		} else if ((sshdr.sense_key =3D 0x02) &&
+	    	    	 (sshdr.asc =3D 0x04) &&
+	    	    	 (sshdr.ascq =3D 0x03)) {
+			/*
+			 * LUN Not Ready - Manual Intervention Required
+			 * indicates in-progress ucode upgrade (NDU).
+			 */
+			DMWARN("Detected in-progress ucode upgrade NDU "
+			       "operation while sending CLARiiON
trespass "
+			       " command using path %s.",
path->dev->name);
+			err =3D MP_BYPASS_PG;
+		} else
+			err =3D MP_FAIL_PATH;
+	} else if (req->errors) {
+		DMERR("Error 0x%x while sending CLARiiON trespass
command "
+		      "using path %s.", req->errors, path->dev->name);
+		err =3D MP_FAIL_PATH;
+	}
=20
-	/* request is freed in block layer */
-	free_bio(bio);
+	/* release ref on block request */
+	__blk_put_request(req->q, req);
=20
-	return 0;
+	return (err);
 }
=20
-static struct bio *get_failover_bio(struct path *path, unsigned
data_size)
+/*
+ * Completion handler for EVPD page 0xC0 INQUIRY cmd.
+ */
+static void sp_info_endio(struct request *req, int uptodate)
 {
-	struct bio *bio;
-	struct page *page;
+	struct path *path =3D req->end_io_data;
+	struct emc_handler *h =3D (struct emc_handler *)path->hwhcontext;
+	int default_sp, current_sp, new_current_sp;
+	unsigned long flags;
+	int err_flags;
=20
-	bio =3D bio_alloc(GFP_ATOMIC, 1);
-	if (!bio) {
-		DMERR("get_failover_bio: bio_alloc() failed.");
-		return NULL;
-	}
+	if ((err_flags =3D parse_sp_info_reply(req, h, path, &default_sp,
+					     &current_sp,
&new_current_sp))) {
+		dm_pg_init_complete(path, err_flags);
=20
-	bio->bi_rw |=3D (1 << BIO_RW);
-	bio->bi_bdev =3D path->dev->bdev;
-	bio->bi_sector =3D 0;
-	bio->bi_private =3D path;
-	bio->bi_end_io =3D emc_endio;
-
-	page =3D alloc_page(GFP_ATOMIC);
-	if (!page) {
-		DMERR("get_failover_bio: alloc_page() failed.");
-		bio_put(bio);
-		return NULL;
+		/* release ref on block request */
+		__blk_put_request(req->q, req);
+
+		return;
 	}
=20
-	if (bio_add_page(bio, page, data_size, 0) !=3D data_size) {
-		DMERR("get_failover_bio: alloc_page() failed.");
-		__free_page(page);
-		bio_put(bio);
-		return NULL;
+	/* release ref on block request */
+	__blk_put_request(req->q, req);
+
+	spin_lock_irqsave(&h->lock, flags);
+	if (h->pg_init_sent) {
+		h->default_sp =3D default_sp;
+		h->current_sp =3D current_sp;
+		h->pg_init_sent =3D 0;
+		spin_unlock_irqrestore(&h->lock, flags);
+
+		/* done now */
+		dm_pg_init_complete(path, 0);
+	} else {
+		spin_unlock_irqrestore(&h->lock, flags);
+
+		/*
+	 	 * Do not issue the actual pg_init request if either (1)
+	 	 * we do not know the identity of the current SP or (2)
+		 * the prospective new SP is already current.
+	 	 */
+		if ((current_sp !=3D UNBOUND_LU) &&
+		    (new_current_sp =3D=3D current_sp)) {
+
+			spin_lock_irqsave(&h->lock, flags);
+			if (h->default_sp =3D=3D UNBOUND_LU) {
+				h->default_sp =3D default_sp;
+				h->current_sp =3D current_sp;
+			}
+			spin_unlock_irqrestore(&h->lock, flags);
+
+			/* yet, its as good as doing it */
+			dm_pg_init_complete(path, 0);
+			DMINFO("Ignoring path group switch-over command
for "
+			       "CLARiiON SP%s since mapped device is "
+			       "already initialized for path %s.",
+		       	       current_sp ? "B" : "A", path->dev->name);
+		} else {
+			/* send path initialization request */
+			DMINFO("Issuing CLARiiON trespass command to "
+	       		       "activate SP%s using path %s.",
+			       new_current_sp ? "B" : "A",
path->dev->name);
+
+			h->path =3D path;	/* kemchd will use this path */
+			queue_work(kemchd, &h->wkq);
+		}
 	}
=20
-	return bio;
+	return;
+}
+
+/*
+ * Completion handler for MODE_SELECT cmd.
+ */
+static void pg_init_endio(struct request *req, int uptodate)
+{
+	struct path *path =3D req->end_io_data;
+	struct emc_handler *h =3D (struct emc_handler *)path->hwhcontext;
+	int err_flags;
+
+	if ((err_flags =3D parse_pg_init_reply(req, h, path)))
+		dm_pg_init_complete(path, err_flags);
+
+	/* release ref on block request */
+	__blk_put_request(req->q, req);
+
+	/* send sp_info request */
+	h->pg_init_sent =3D 1;
+	queue_work(kemchd, &h->wkq);
+
+	return;
 }
=20
-static struct request *get_failover_req(struct emc_handler *h,
-					struct bio *bio, struct path
*path)
+/*
+ * Get block request for REQ_BLOCK_PC command issued to path.
Currently
+ * limited to MODE_SELECT (trespass) and INQUIRY (VPD page 0xC0)
commands.
+ *
+ * Uses data and sense buffers in hardware handler context structure
and
+ * assumes serial servicing of commands, both issuance and completion.
+ */
+static struct request *get_req(struct path *path, int opcode)
 {
+	struct emc_handler *h =3D (struct emc_handler *)path->hwhcontext;
+	struct request_queue *q =3D bdev_get_queue(path->dev->bdev);
 	struct request *rq;
-	struct block_device *bdev =3D bio->bi_bdev;
-	struct request_queue *q =3D bdev_get_queue(bdev);
+	void *buffer;
+	int len =3D 0;
=20
-	/* FIXME: Figure out why it fails with GFP_ATOMIC. */
-	rq =3D blk_get_request(q, WRITE, __GFP_WAIT);
+	rq =3D blk_get_request(q, (opcode =3D=3D MODE_SELECT) ? WRITE : READ,
+			     __GFP_WAIT);
 	if (!rq) {
-		DMERR("get_failover_req: blk_get_request failed");
+		DMERR("dm-emc: get_req: blk_get_request failed");
 		return NULL;
 	}
=20
-	rq->bio =3D rq->biotail =3D bio;
-	blk_rq_bio_prep(q, rq, bio);
-
-	rq->rq_disk =3D bdev->bd_contains->bd_disk;
+	memset(&rq->cmd, 0, BLK_MAX_CDB);
+	rq->cmd[0] =3D opcode;
+	rq->cmd_len =3D COMMAND_SIZE(rq->cmd[0]);
=20
-	/* bio backed don't set data */
-	rq->buffer =3D rq->data =3D NULL;
-	/* rq data_len used for pc cmd's request_bufflen */
-	rq->data_len =3D bio->bi_size;
+	switch (opcode) {
+	case MODE_SELECT:
+		rq->flags |=3D REQ_RW;
+		rq->cmd[1] =3D 0x10;
+		len =3D h->short_trespass ?
sizeof(short_trespass_and_hr_pg) :
+				        sizeof(long_trespass_and_hr_pg);
+		buffer =3D h->short_trespass ?
+			       h->hr ? short_trespass_and_hr_pg
+				     : short_trespass_pg
+			     :
+			       h->hr ? long_trespass_and_hr_pg
+				     : long_trespass_pg;
+		/*
+		 * Can't DMA from kernel BSS -- must copy selected
trespass
+		 * command mode page contents to context buffer which is
+		 * allocated by kmalloc.
+		 */
+		BUG_ON((len > BUFFER_SIZE));
+		memcpy(h->buffer, buffer, len);
+		break;
+	case INQUIRY:
+		rq->cmd[1] =3D 0x1;
+		rq->cmd[2] =3D 0xC0;
+		len =3D BUFFER_SIZE;
+		memset(h->buffer, 0, BUFFER_SIZE);
+		break;
+	default:
+		BUG_ON(1);
+		break;
+	}
+	rq->cmd[4] =3D len;
+
+	rq->buffer =3D rq->data =3D h->buffer;
+	rq->data_len =3D len;
+	rq->bio =3D rq->biotail =3D NULL;
=20
 	rq->sense =3D h->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len =3D 0;
=20
-	memset(&rq->cmd, 0, BLK_MAX_CDB);
-
-	rq->timeout =3D EMC_FAILOVER_TIMEOUT;
-	rq->flags |=3D (REQ_BLOCK_PC | REQ_FAILFAST | REQ_NOMERGE);
+	rq->flags |=3D (REQ_BLOCK_PC | REQ_FAILFAST);
+	rq->timeout =3D EMC_HANDLER_TIMEOUT;
+	rq->retries =3D 0;
=20
 	return rq;
 }
=20
-static struct request *emc_trespass_get(struct emc_handler *h,
-					struct path *path)
+/*
+ * Send cmd and setup asynchronous i/o completion handler.
+ */
+static int send_cmd(struct emc_handler *h, struct path *path, int cmd,
+		    rq_end_io_fn *endio)
 {
-	struct bio *bio;
+	struct request_queue *q =3D bdev_get_queue(path->dev->bdev);
 	struct request *rq;
-	unsigned char *page22;
-	unsigned char long_trespass_pg[] =3D {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x09,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor
reservation bit */
-		0xff, 0xff,           /* Trespass target */
-		0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
-		};
-	unsigned char short_trespass_pg[] =3D {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x02,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor
reservation bit */
-		0xff,                 /* Trespass target */
-		};
-	unsigned data_size =3D h->short_trespass ?
sizeof(short_trespass_pg) :
-				sizeof(long_trespass_pg);
-
-	/* get bio backing */
-	if (data_size > PAGE_SIZE)
-		/* this should never happen */
-		return NULL;
-
-	bio =3D get_failover_bio(path, data_size);
-	if (!bio) {
-		DMERR("emc_trespass_get: no bio");
-		return NULL;
-	}
-
-	page22 =3D (unsigned char *)bio_data(bio);
-	memset(page22, 0, data_size);
=20
-	memcpy(page22, h->short_trespass ?
-		short_trespass_pg : long_trespass_pg, data_size);
+	/* get and initialize block request */
+	rq =3D get_req(path, cmd);
+	if (!rq)
+		return MP_FAIL_PATH;
+
+	/* issue the cmd asynchronously (at head of q) */
+	rq->end_io_data =3D path;
+	blk_execute_rq_nowait(q, NULL, rq, 1, endio);
+	return 0;
+}
=20
-	/* get request for block layer packet command */
-	rq =3D get_failover_req(h, bio, path);
-	if (!rq) {
-		DMERR("emc_trespass_get: no rq");
-		free_bio(bio);
-		return NULL;
+/*
+ * Work queue service routine used to issue i/o without already holding
+ * a request queue lock.
+ */
+static void service_wkq(void *data)
+{
+	struct emc_handler *h =3D (struct emc_handler *)data;
+	struct path *path =3D h->path;
+	int err_flags;
+
+	if (h->pg_init_sent) {
+		if ((err_flags =3D send_cmd(h, path, INQUIRY,
+					  sp_info_endio))) {
+			h->pg_init_sent =3D 0;
+			dm_pg_init_complete(path, err_flags);
+		}
+	}
+	else {
+		/* send pg_init request */
+		if ((err_flags =3D send_cmd(h, path, MODE_SELECT,
+					  pg_init_endio)))
+			dm_pg_init_complete(path, err_flags);
 	}
-
-	/* Prepare the command. */
-	rq->cmd[0] =3D MODE_SELECT;
-	rq->cmd[1] =3D 0x10;
-	rq->cmd[4] =3D data_size;
-	rq->cmd_len =3D COMMAND_SIZE(rq->cmd[0]);
-
-	return rq;
 }
=20
+/* initialize path group command */
 static void emc_pg_init(struct hw_handler *hwh, unsigned bypassed,
 			struct path *path)
 {
-	struct request *rq;
-	struct request_queue *q =3D bdev_get_queue(path->dev->bdev);
+	struct emc_handler *h =3D (struct emc_handler *)hwh->context;
+	int err_flags;
=20
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
+	path->hwhcontext =3D h; /* needed by endio handlers */
=20
-	/* FIXME: The request should be pre-allocated. */
-	rq =3D emc_trespass_get(hwh->context, path);
-	if (!rq) {
-		DMERR("emc_pg_init: no rq");
-		goto fail_path;
-	}
-
-	DMINFO("emc_pg_init: sending switch-over command");
-	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
+	if ((err_flags =3D send_cmd(h, path, INQUIRY, sp_info_endio)))
+		dm_pg_init_complete(path, err_flags);
 	return;
-
-fail_path:
-	dm_pg_init_complete(path, MP_FAIL_PATH);
 }
=20
-static struct emc_handler *alloc_emc_handler(void)
+static struct emc_handler *alloc_emc_handler(unsigned int
short_trespass,
+					     unsigned hr)
 {
-	struct emc_handler *h =3D kmalloc(sizeof(*h), GFP_KERNEL);
+	struct emc_handler *h =3D kzalloc(sizeof(*h), GFP_KERNEL);
=20
 	if (h) {
-		memset(h, 0, sizeof(*h));
 		spin_lock_init(&h->lock);
+
+		INIT_WORK(&h->wkq, service_wkq, h);
+
+		if ((h->short_trespass =3D short_trespass))
+			DMINFO("Short trespass command to be sent.");
+		else
+			DMINFO("Long trespass command to be sent
(default).");
+		if ((h->hr =3D hr))
+			DMINFO("Honor reservation bit will be set.");
+		else
+			DMINFO("Honor reservation bit is not set
(default).");
+
+		h->default_sp =3D UNBOUND_LU;
+		h->current_sp =3D UNBOUND_LU;
 	}
=20
 	return h;
@@ -243,37 +464,30 @@ static int emc_create(struct hw_handler=20
 		hr =3D 0;
 		short_trespass =3D 0;
 	} else if (argc !=3D 2) {
-		DMWARN("incorrect number of arguments");
+		DMWARN("Incorrect number (0x%x) of arguments.  "
+		       "Should be 2.", argc);
 		return -EINVAL;
 	} else {
 		if ((sscanf(argv[0], "%u", &short_trespass) !=3D 1)
 			|| (short_trespass > 1)) {
-			DMWARN("invalid trespass mode selected");
+			DMWARN("Invalid trespass mode (0x%x) selected.",
+			       short_trespass);
 			return -EINVAL;
 		}
=20
 		if ((sscanf(argv[1], "%u", &hr) !=3D 1)
 			|| (hr > 1)) {
-			DMWARN("invalid honor reservation flag
selected");
+			DMWARN("Invalid honor reservation flag (0x%x).",
hr);
 			return -EINVAL;
 		}
 	}
=20
-	h =3D alloc_emc_handler();
+	h =3D alloc_emc_handler(short_trespass, hr);
 	if (!h)
 		return -ENOMEM;
=20
 	hwh->context =3D h;
-
-	if ((h->short_trespass =3D short_trespass))
-		DMWARN("short trespass command will be send");
-	else
-		DMWARN("long trespass command will be send");
-
-	if ((h->hr =3D hr))
-		DMWARN("honor reservation bit will be set");
-	else
-		DMWARN("honor reservation bit will not be set
(default)");
+	h->hwh =3D hwh;
=20
 	return 0;
 }
@@ -324,6 +538,31 @@ static unsigned emc_error(struct hw_hand
 	return dm_scsi_err_handler(hwh, bio);
 }
=20
+static int emc_status(struct hw_handler *hwh, status_type_t type,
+		      char *result, unsigned int maxlen)
+{
+	struct emc_handler *h =3D (struct emc_handler *)hwh->context;
+	unsigned long flags;
+
+	int sz =3D 0;
+
+	spin_lock_irqsave(&h->lock, flags);
+
+	if (type =3D=3D STATUSTYPE_INFO)
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
 static struct hw_handler_type emc_hwh =3D {
 	.name =3D "emc",
 	.module =3D THIS_MODULE,
@@ -331,6 +570,7 @@ static struct hw_handler_type emc_hwh =3D=20
 	.destroy =3D emc_destroy,
 	.pg_init =3D emc_pg_init,
 	.error =3D emc_error,
+	.status =3D emc_status,
 };
=20
 static int __init dm_emc_init(void)
@@ -338,19 +578,30 @@ static int __init dm_emc_init(void)
 	int r =3D dm_register_hw_handler(&emc_hwh);
=20
 	if (r < 0)
-		DMERR("register failed %d", r);
+		DMERR("Register failed %d.", r);
+	else {
+		kemchd =3D create_singlethread_workqueue("kemchd");
+		if (!kemchd) {
+			DMERR("Failed to create workqueue kemchd.");
+			dm_unregister_hw_handler(&emc_hwh);
+			return -ENOMEM;
+		}
+	}
=20
-	DMINFO("version 0.0.3 loaded");
+	DMINFO("Version 0.0.4 loaded.");
=20
 	return r;
 }
=20
 static void __exit dm_emc_exit(void)
 {
-	int r =3D dm_unregister_hw_handler(&emc_hwh);
+	int r;
+
+	destroy_workqueue(kemchd);
=20
+	r =3D dm_unregister_hw_handler(&emc_hwh);
 	if (r < 0)
-		DMERR("unregister failed %d", r);
+		DMERR("Unregister failed %d.", r);
 }
=20
 module_init(dm_emc_init);
