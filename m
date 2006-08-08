From: egoggin@emc.com
Subject: RE: patch to dm-emc.c
Date: Tue, 8 Aug 2006 15:22:46 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D135B@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Tuesday, August 08, 2006 2:07 PM, Mike Anderson wrote

> 
> Would it be possible to repost the patch in unified format? 
> The first part
> of the patch is, but the last part is not.

Sure.  Here's the patch content in unified format for dm-mpath.c,
dm-hw-handler.h, and dm-emc.c.  This patch is dependent on
(1) small changes to both dm-table.c and device-mapper.h in
order to create and export dm_table_put_md and (2) small
changes to both ll_rw_blk.c and blkdev.h to export rq_init
as a non-inlined function.  Those changes were sent as
separate patch emails.

--- drivers/md/dm-mpath.c.orig	2006-08-03 04:04:54.000000000 -0500
+++ drivers/md/dm-mpath.c	2006-08-07 01:38:23.000000000 -0500
@@ -700,6 +700,10 @@
 	struct arg_set as;
 	unsigned pg_count = 0;
 	unsigned next_pg_num;
+	struct priority_group *pg;
+	struct pgpath *pgpath;
+	struct path *path = NULL;
+	struct hw_handler *hwh;
 
 	as.argc = argc;
 	as.argv = argv;
@@ -710,6 +714,7 @@
 		return -EINVAL;
 	}
 
+	m->ti = ti;
 	r = parse_features(&as, m, ti);
 	if (r)
 		goto bad;
@@ -750,8 +755,30 @@
 		goto bad;
 	}
 
+	/*
+	 * Link all paths of mapped device to the same hwh context.
+	 */
+	hwh = &m->hw_handler;
+	if (hwh->type) {
+		list_for_each_entry(pg, &m->priority_groups, list) {
+			list_for_each_entry(pgpath, &pg->pgpaths, list) {
+				(path = &pgpath->path)->hwhcontext =
hwh->context;
+			}
+		}
+	}
+
+	/*
+	 * Initialize the hardware context now that all paths are setup,
+	 * pass any one of the paths to be used to access the device.
+	 */
+	if (hwh->type && hwh->type->init && path) {
+		/* pass mapped device name for event logging */
+		const char *name =
dm_device_name(dm_table_get_md(ti->table));
+		hwh->type->init(hwh, name, path);
+		dm_table_put_md(ti->table);
+	}
+
 	ti->private = m;
-	m->ti = ti;
 
 	return 0;
 

--- drivers/md/dm-hw-handler.h.orig	2006-08-03 04:04:54.000000000 -0500
+++ drivers/md/dm-hw-handler.h	2006-08-03 04:04:54.000000000 -0500
@@ -29,6 +29,8 @@
 
 	int (*create) (struct hw_handler *handler, unsigned int argc,
 		       char **argv);
+	void (*init) (struct hw_handler *hwh, const char *name,
+		      struct path *path);
 	void (*destroy) (struct hw_handler *hwh);
 
 	void (*pg_init) (struct hw_handler *hwh, unsigned bypassed,


--- drivers/md/dm-emc.c.orig	2006-08-03 04:04:54.000000000 -0500
+++ drivers/md/dm-emc.c	2006-08-06 20:40:48.000000000 -0500
@@ -10,224 +10,391 @@
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
+#define	UNBOUND_LU		-1
+
+/*
+ * Four variations of the CLARiiON trespass MODE_SENSE page.
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
 
+/*
+ * EMC hardware handler context structure containing CLARiiON LU specific
+ * information for a particular dm multipath mapped device.
+ */
 struct emc_handler {
 	spinlock_t lock;
-
-	/* Whether we should send the short trespass command (FC-series)
-	 * or the long version (default for AX/CX CLARiiON arrays). */
+	/* name of mapped device */
+	char name[16];
+	struct hw_handler *hwh;
+	struct work_struct wkq;
+	struct request req;
+	struct path *path;
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
+	/* which SP (A=0,B=1,UNBOUND=-1) is default SP for path's mapped dev
*/
+	int defaultSP;
+	/* which SP (A=0,B=1,UNBOUND=-1) is active for path's mapped dev */
+	int currentSP;
 };
 
-#define TRESPASS_PAGE 0x22
-#define EMC_FAILOVER_TIMEOUT (60 * HZ)
+struct workqueue_struct *kemchd;
 
 /* Code borrowed from dm-lsi-rdac by Mike Christie */
 
-static inline void free_bio(struct bio *bio)
+/*
+ * Get block request for REQ_BLOCK_PC command issued to path.  Currently
+ * limited to MODE_SENSE (trespass) and INQUIRY (VPD page 0xC0) commands.
+ *
+ * Uses data and sense buffers in hardware handler context structure and
+ * assumes serial servicing of commands, both issuance and completion.
+ */
+static struct request *get_req(struct path *path, int opcode)
 {
-	__free_page(bio->bi_io_vec[0].bv_page);
-	bio_put(bio);
-}
+	struct emc_handler *h = (struct emc_handler *)path->hwhcontext;
+	struct request_queue *q = bdev_get_queue(path->dev->bdev);
+	struct request *rq;
+	void *buffer;
+	int len = 0;
 
-static int emc_endio(struct bio *bio, unsigned int bytes_done, int error)
-{
-	struct path *path = bio->bi_private;
+	/*
+	 * Re-use the pre-allocated request struct in order to avoid
deadlock
+	 * scenarios trying to allocate a request on a target queue which is
+	 * over its read or write request threshold.
+	 */
+	rq = &h->req;
+	rq_init(q, rq);
+	rq->elevator_private = NULL;
+	rq->rq_disk = NULL;
+	rq->rl = NULL;
+	rq->flags = 0;
 
-	if (bio->bi_size)
-		return 1;
+	memset(&rq->cmd, 0, BLK_MAX_CDB);
+	rq->cmd[0] = opcode;
+	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
 
-	/* We also need to look at the sense keys here whether or not to
-	 * switch to the next PG etc.
-	 *
-	 * For now simple logic: either it works or it doesn't.
-	 */
-	if (error)
-		dm_pg_init_complete(path, MP_FAIL_PATH);
-	else
-		dm_pg_init_complete(path, 0);
+	switch (opcode) {
+	case MODE_SELECT:
+		rq->flags |= REQ_RW;
+		rq->cmd[1] = 0x10;
+		len = h->short_trespass ? sizeof(short_trespass_and_hr_pg) :
+				        sizeof(long_trespass_and_hr_pg);
+		buffer = h->short_trespass ?
+					       h->hr ?
short_trespass_and_hr_pg
+			      	      		     : short_trespass_pg
+				           :
+					       h->hr ?
long_trespass_and_hr_pg
+			      			     : long_trespass_pg;
+		/* Can't DMA from kernel BSS -- must copy selected trespass
+		 * command mode page contents to context buffer which is
+		 * allocated from kmalloc memory. */
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
+	rq->buffer = rq->data = h->buffer;
+	rq->data_len = len;
+	rq->bio = rq->biotail = NULL;
 
-	/* request is freed in block layer */
-	free_bio(bio);
+	rq->sense = h->sense;
+	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense_len = 0;
 
-	return 0;
+	rq->flags |= (REQ_BLOCK_PC | REQ_FAILFAST);
+	rq->timeout = EMC_HANDLER_TIMEOUT;
+	rq->retries = 0;
+
+	return rq;
 }
 
-static struct bio *get_failover_bio(struct path *path, unsigned data_size)
+/*
+ * Initialize hwhandler context structure ... defaultSP and currentSP
fields.
+ */
+static int getSPInfo(struct emc_handler *h, struct path *path, int
*defaultSP,
+		     int *currentSP, int *newCurrentSP)
 {
-	struct bio *bio;
-	struct page *page;
+	struct request_queue *q = bdev_get_queue(path->dev->bdev);
+	struct request *rq;
+	int err = 0;
 
-	bio = bio_alloc(GFP_ATOMIC, 1);
-	if (!bio) {
-		DMERR("get_failover_bio: bio_alloc() failed.");
-		return NULL;
+	/* get and initialize block request */
+	rq = get_req(path, INQUIRY);
+	if (!rq)
+		return MP_FAIL_PATH;
+
+	/* issue the cmd (at head of q) & synchronously wait for completion
*/
+	blk_execute_rq(q, NULL, rq, 1);
+	if (rq->errors == 0) {
+		/* check for in-progress ucode upgrade (NDU) */
+		if (h->buffer[48] != 0) {
+			DMWARN("getSPInfo: Detected in-progress ucode
upgrade NDU operation while finding current active SP for mapped device %s
using path %s.",
+			       h->name, path->dev->name);
+			err = MP_BYPASS_PG;
+		}
+		else {
+			*defaultSP = h->buffer[5];
+
+			if (h->buffer[4] == 2)
+				/* SP for path (in h->buffer[8]) is current
*/
+				*currentSP = h->buffer[8];
+			else {
+				if (h->buffer[4] == 1)
+					/* SP for this path is NOT current
*/
+					if (h->buffer[8] == 0)
+						*currentSP = 1;
+					else
+						*currentSP = 0;
+				else
+					/* unbound LU or LUNZ */
+					*currentSP = UNBOUND_LU;
+			}
+			*newCurrentSP =  h->buffer[8];
+		}
 	}
+	else {
+		struct scsi_sense_hdr sshdr;
 
-	bio->bi_rw |= (1 << BIO_RW);
-	bio->bi_bdev = path->dev->bdev;
-	bio->bi_sector = 0;
-	bio->bi_private = path;
-	bio->bi_end_io = emc_endio;
+		err = MP_FAIL_PATH;
 
-	page = alloc_page(GFP_ATOMIC);
-	if (!page) {
-		DMERR("get_failover_bio: alloc_page() failed.");
-		bio_put(bio);
-		return NULL;
+		if (rq->sense_len && scsi_normalize_sense(rq->sense,
+						  	  rq->sense_len,
&sshdr)) {
+			DMERR("getSPInfo: Found valid sense data %02x, %2x,
%2x while finding current active SP for mapped device %s using path %s.",
+		       	       sshdr.sense_key, sshdr.asc, sshdr.ascq,
+			       h->name, path->dev->name);
+		}
+		else DMERR("getSPInfo: Error 0x%x finding current active SP
for mapped devicce %s using path %s.", rq->errors, h->name,
path->dev->name);
 	}
 
-	if (bio_add_page(bio, page, data_size, 0) != data_size) {
-		DMERR("get_failover_bio: alloc_page() failed.");
-		__free_page(page);
-		bio_put(bio);
-		return NULL;
-	}
+	blk_put_request(rq);
 
-	return bio;
+	return err;
 }
 
-static struct request *get_failover_req(struct emc_handler *h,
-					struct bio *bio, struct path *path)
+/* initialize path group command */
+static int pgInit(struct emc_handler *h, struct path *path)
 {
+	struct request_queue *q = bdev_get_queue(path->dev->bdev);
+	struct scsi_sense_hdr sshdr;
 	struct request *rq;
-	struct block_device *bdev = bio->bi_bdev;
-	struct request_queue *q = bdev_get_queue(bdev);
+	int err = 0;
 
-	/* FIXME: Figure out why it fails with GFP_ATOMIC. */
-	rq = blk_get_request(q, WRITE, __GFP_WAIT);
-	if (!rq) {
-		DMERR("get_failover_req: blk_get_request failed");
-		return NULL;
+	/* get and initialize block request */
+	rq = get_req(path, MODE_SELECT);
+	if (!rq)
+		return MP_FAIL_PATH;
+
+	DMINFO("pgInit: Sending switch-over command for mapped device %s
using path %s.",
+	       h->name, path->dev->name);
+
+	/* issue the cmd (at head of q) & synchronously wait for completion
*/
+	blk_execute_rq(q, NULL, rq, 1); 
+
+	if (rq->sense_len && scsi_normalize_sense(rq->sense,
+						  rq->sense_len, &sshdr)) {
+		DMERR("pgInit: Found valid sense data %02x, %2x, %2x while
sending switch-over command for mapped device %s using path %s.",
+		       sshdr.sense_key, sshdr.asc, sshdr.ascq,
+		       h->name, path->dev->name);
+		if ((sshdr.sense_key = 0x05) &&
+	    	    (sshdr.asc = 0x04) &&
+	    	    (sshdr.ascq = 0x00)) {
+			/*
+			 * Array based copy in progress -- do not send
+			 * pg_init or copy will be aborted mid-stream.
+			 */
+			DMWARN("pgInit: Array Based Copy in progress while
sending switch-over command for mapped device %s using path %s.",
+			       h->name, path->dev->name);
+			err = MP_BYPASS_PG;
+		}
+		else if ((sshdr.sense_key = 0x02) &&
+	    	    	 (sshdr.asc = 0x04) &&
+	    	    	 (sshdr.ascq = 0x03)) {
+			/*
+			 * LUN Not Ready - Manual Intervention Required
+			 * indicates in-progress ucode upgrade (NDU).
+			 */
+			DMWARN("pgInit: Detected in-progress ucode upgrade
NDU operation while sending switch-over command for mapped device %s using
path %s.",
+			       h->name, path->dev->name);
+			err = MP_BYPASS_PG;
+		} else
+			err = MP_FAIL_PATH;
+	}
+	else if (rq->errors) {
+		DMERR("pgInit: Error 0x%x while sending switch-over command
for mapped device %s using path %s.",
+		       rq->errors, h->name, path->dev->name);
+		err = MP_FAIL_PATH;
+	}
+
+	/* release ref on block request */
+	blk_put_request(rq);
+
+	return (err);
+}
+
+static void servicePgInit(struct emc_handler *h, struct path *path)
+{
+	int defaultSP, currentSP, newCurrentSP;
+	int errFlags;
+
+	DMINFO("servicePgInit: Servicing switch-over command for mapped
device %s using path %s.",
+	       h->name, path->dev->name);
+
+	if ((errFlags = getSPInfo(h, path, &defaultSP, &currentSP,
+				  &newCurrentSP))) {
+		dm_pg_init_complete(path, errFlags);
+		return;
+	}
+	/*
+	 * Do not issue pg_init if either (1) we do not know the identity
+	 * of the current SP or (2) the prospective new SP is already
current.
+	 */
+	if ((currentSP != UNBOUND_LU) && (newCurrentSP == currentSP)) {
+		/* yet, its as good as doing it */
+		dm_pg_init_complete(path, 0);
+		DMINFO("servicePgInit: Ignoring switch-over command since
path group %u of mapped device %s is already initialized for path %s.",
+		       currentSP, h->name, path->dev->name);
+		return;
 	}
 
-	rq->bio = rq->biotail = bio;
-	blk_rq_bio_prep(q, rq, bio);
-
-	rq->rq_disk = bdev->bd_contains->bd_disk;
-
-	/* bio backed don't set data */
-	rq->buffer = rq->data = NULL;
-	/* rq data_len used for pc cmd's request_bufflen */
-	rq->data_len = bio->bi_size;
+	/* issue pg_init */
+	if ((errFlags = pgInit(h, path))) {
+		dm_pg_init_complete(path, errFlags);
+		return;
+	}
 
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = 0;
+	/* update our perspective */
+	if ((errFlags = getSPInfo(h, path, &defaultSP, &currentSP,
+			     	  &newCurrentSP)) == 0) {
+		unsigned long flags;
 
-	memset(&rq->cmd, 0, BLK_MAX_CDB);
+		spin_lock_irqsave(&h->lock, flags);
+		h->defaultSP = defaultSP;
+		h->currentSP = currentSP;
+		spin_unlock_irqrestore(&h->lock, flags);
+	}
 
-	rq->timeout = EMC_FAILOVER_TIMEOUT;
-	rq->flags |= (REQ_BLOCK_PC | REQ_FAILFAST | REQ_NOMERGE);
+	/* done now ... let pgInit errFlags override those of 2nd getSPInfo
*/
+	dm_pg_init_complete(path, 0);
 
-	return rq;
+	return;
 }
 
-static struct request *emc_trespass_get(struct emc_handler *h,
-					struct path *path)
+static void service_wkq(void *data)
 {
-	struct bio *bio;
-	struct request *rq;
-	unsigned char *page22;
-	unsigned char long_trespass_pg[] = {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x09,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation
bit */
-		0xff, 0xff,           /* Trespass target */
-		0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
-		};
-	unsigned char short_trespass_pg[] = {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x02,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation
bit */
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
-
-	page22 = (unsigned char *)bio_data(bio);
-	memset(page22, 0, data_size);
-
-	memcpy(page22, h->short_trespass ?
-		short_trespass_pg : long_trespass_pg, data_size);
-
-	/* get request for block layer packet command */
-	rq = get_failover_req(h, bio, path);
-	if (!rq) {
-		DMERR("emc_trespass_get: no rq");
-		free_bio(bio);
-		return NULL;
-	}
-
-	/* Prepare the command. */
-	rq->cmd[0] = MODE_SELECT;
-	rq->cmd[1] = 0x10;
-	rq->cmd[4] = data_size;
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
+	struct emc_handler *h = (struct emc_handler *)data;
 
-	return rq;
+	servicePgInit(h, h->path);
+	return;
 }
 
+/* initialize path group command */
 static void emc_pg_init(struct hw_handler *hwh, unsigned bypassed,
 			struct path *path)
 {
-	struct request *rq;
-	struct request_queue *q = bdev_get_queue(path->dev->bdev);
+	struct emc_handler *h = (struct emc_handler *)hwh->context;
 
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
+	h->path = path;	// kemchd will use this path to service the pg_init
+	queue_work(kemchd, &h->wkq);
+	return;
+}
 
-	/* FIXME: The request should be pre-allocated. */
-	rq = emc_trespass_get(hwh->context, path);
-	if (!rq) {
-		DMERR("emc_pg_init: no rq");
-		goto fail_path;
+static void emc_init(struct hw_handler *hwh, const char *name, struct path
*path)
+{
+	struct emc_handler *h = (struct emc_handler *)hwh->context;
+	int defaultSP, currentSP, newCurrentSP;
+	int errFlags;
+
+	/* update our perspective */
+	if ((errFlags = getSPInfo(h, path, &defaultSP, &currentSP,
+			     	  &newCurrentSP)) == 0) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&h->lock, flags);
+		h->defaultSP = defaultSP;
+		h->currentSP = currentSP;
+		strncpy(h->name, name, 16);
+		spin_unlock_irqrestore(&h->lock, flags);
 	}
+	DMINFO("emc_init: Setting up hardware handler for mapped device %s
using path %s.", h->name, path->dev->name);
 
-	DMINFO("emc_pg_init: sending switch-over command");
-	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
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
+		INIT_WORK(&h->wkq, service_wkq, h);
+
+		if ((h->short_trespass = short_trespass))
+			DMINFO("Short trespass command will be sent.");
+		else
+			DMINFO("Long trespass command will be sent
(default).");
+		if ((h->hr = hr))
+			DMINFO("Honor reservation bit will be set.");
+		else
+			DMINFO("Honor reservation bit will not be set
(default).");
+
+		h->defaultSP = UNBOUND_LU;
+		h->currentSP = UNBOUND_LU;
 	}
 
 	return h;
@@ -243,37 +410,31 @@
 		hr = 0;
 		short_trespass = 0;
 	} else if (argc != 2) {
-		DMWARN("incorrect number of arguments");
+		DMWARN("Incorrect number (0x%x) of arguments.  Should be
two.",
+		       argc);
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
+			DMWARN("Invalid honor reservation flag (0x%x)
selected.",
+			       hr);
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
@@ -324,13 +485,40 @@
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
+		DMEMIT("2 %d %d ", h->defaultSP, h->currentSP);
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
 	.create = emc_create,
+	.init	= emc_init,
 	.destroy = emc_destroy,
 	.pg_init = emc_pg_init,
 	.error = emc_error,
+	.status = emc_status,
 };
 
 static int __init dm_emc_init(void)
@@ -338,19 +526,30 @@
 	int r = dm_register_hw_handler(&emc_hwh);
 
 	if (r < 0)
-		DMERR("register failed %d", r);
+		DMERR("Register failed %d.", r);
+	else {
+		kemchd = create_workqueue("kemchd");
+		if (!kemchd) {
+			DMERR("Failed to create workqueue kemchd.");
+			dm_unregister_hw_handler(&emc_hwh);
+			return -ENOMEM;
+		}
+	}
 
-	DMINFO("version 0.0.3 loaded");
+	DMINFO("version 0.0.4 loaded");
 
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
