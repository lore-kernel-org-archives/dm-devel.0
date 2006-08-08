From: egoggin@emc.com
Subject: patch to dm-emc.c
Date: Tue, 8 Aug 2006 13:19:23 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1356@CORPUSMX40A.corp.emc.com>
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

Alasdair,

The two major motivations for this patch are (1) to implement a path group
follow-over capability for EMC CLARiiON logical units and (2) to improve the
event logging of the hardware handler interface.  This follow-over feature
is meant to avoid (not just delaying) switching path groups for a CLARiiON
logical unit whenever the currently active path group has been changed by
software external to the multipathing software running on a host.  The
typical use cases for needing this feature involve either a multi-node
cluster or an array based remote mirror.  Just delaying the path group
switch will terminate the remote mirror in the latter case.

This patch to dm-mpath.c, dm-hw-handler.h, and dm-emc.c provides the
following capabilities.

1. Adds an optional init() function to the optional dm hardware handler
interface called during the invocation of multipath_ctr.  This function is
passed the contents of the name field of the mapped_device and a target
device path to be used if it is necessary to send I/O to the device as part
of its initialization.

2. For those mapped devices which have dm hardware handlers, the hwhcontext
field of each of the mapped device's target paths is set to point to the
same per device context field for the hardware handler.

3. Changed the internals of dm-emc.c quite a bit.  Some of the bigger items
are:
	a. A status function is created for the dm-emc.c hardware handler.
It is setup to return its perspective of current and default path groups for
its block device for a STATUSTYPE_INFO message and its parameters for a
STATUSTYPE_TABLE message.
	b. Changed the DMINFO, DMWARN, and DMERR log messages to be more
informative primarily by adding an indication of the mapped device and
target path names involved.  In both cases these names are displayed as
"<major>:<minor>" portions of the dev_t.
	c. Eliminated the allocation of both a bio and a request structure
from the servicing of a pg_init request.  Bios are simply not used and a
pre-allocated request structure is used instead of allocating one via
get_request in order to avoid very real deadlock potential in cases where
target queue read/write queue request thresholds have already been exceeded
at the time the pg_init is to be serviced.
	d. SCSI sense information is now available for I/Os issued during
the servicing of a pg_init request since the I/Os are issued as block
requests using blk_execute_rq interface instead of as a bio using
elv_add_request.
	e. Now tracks the current and default path groups for each mapped
device in order to return these values in the STATUSTYPE_INFO message
request.
	f.  Servicing pg_init request now pushed to background kemchd kernel
worker threads dedicated to this purpose.  A pg_init request is now serviced
by one of these threads.
	g. Servicing a pg_init request now will usually involve 3 I/Os, each
issued synchronously (inquiry, mode select, inquiry) by a dm-emc worker
thread instead of 1 I/O (mode select) issued asynchronously by the
dm-multipath worker thread.
	h. A mode select command is not sent to the device if the hardware
handler's notion of the current path group is different from the actual
current path group as determined by a VPD inquiry page 0xC0 request.

Ed


*** drivers/md/dm-mpath.c.orig	Thu Aug  3 04:04:54 2006
--- drivers/md/dm-mpath.c	Sun Aug  6 00:27:31 2006
***************
*** 700,705 ****
--- 700,709 ----
  	struct arg_set as;
  	unsigned pg_count = 0;
  	unsigned next_pg_num;
+ 	struct priority_group *pg;
+ 	struct pgpath *pgpath;
+ 	struct path *path = NULL;
+ 	struct hw_handler *hwh;
  
  	as.argc = argc;
  	as.argv = argv;
***************
*** 710,715 ****
--- 714,720 ----
  		return -EINVAL;
  	}
  
+ 	m->ti = ti;
  	r = parse_features(&as, m, ti);
  	if (r)
  		goto bad;
***************
*** 750,757 ****
  		goto bad;
  	}
  
  	ti->private = m;
- 	m->ti = ti;
  
  	return 0;
  
--- 755,784 ----
  		goto bad;
  	}
  
+ 	/*
+ 	 * Link all paths of mapped device to the same hwh context.
+ 	 */
+ 	hwh = &m->hw_handler;
+ 	if (hwh->type) {
+ 		list_for_each_entry(pg, &m->priority_groups, list) {
+ 			list_for_each_entry(pgpath, &pg->pgpaths, list) {
+ 				(path = &pgpath->path)->hwhcontext =
hwh->context;
+ 			}
+ 		}
+ 	}
+ 
+ 	/*
+ 	 * Initialize the hardware context now that all paths are setup,
+ 	 * pass any one of the paths to be used to access the device.
+ 	 */
+ 	if (hwh->type && hwh->type->init && path) {
+ 		/* pass mapped device name for event logging */
+ 		const char *name =
dm_device_name(dm_table_get_md(ti->table));
+ 		hwh->type->init(hwh, name, path);
+ 		dm_table_put_md(ti->table);
+ 	}
+ 
  	ti->private = m;
  
  	return 0;


*** drivers/md/dm-hw-handler.h.orig	Thu Aug  3 04:04:54 2006
--- drivers/md/dm-hw-handler.h	Thu Aug  3 04:04:54 2006
***************
*** 29,34 ****
--- 29,36 ----
  
  	int (*create) (struct hw_handler *handler, unsigned int argc,
  		       char **argv);
+ 	void (*init) (struct hw_handler *hwh, const char *name,
+ 		      struct path *path);
  	void (*destroy) (struct hw_handler *hwh);
  
  	void (*pg_init) (struct hw_handler *hwh, unsigned bypassed,

*** drivers/md/dm-emc.c.orig	Thu Aug  3 04:04:54 2006
--- drivers/md/dm-emc.c	Sun Aug  6 20:40:48 2006
***************
*** 10,233 ****
  #include "dm.h"
  #include "dm-hw-handler.h"
  #include <scsi/scsi.h>
  #include <scsi/scsi_cmnd.h>
  
! #define DM_MSG_PREFIX "multipath emc"
  
  struct emc_handler {
  	spinlock_t lock;
! 
! 	/* Whether we should send the short trespass command (FC-series)
! 	 * or the long version (default for AX/CX CLARiiON arrays). */
  	unsigned short_trespass;
! 	/* Whether or not to honor SCSI reservations when initiating a
! 	 * switch-over. Default: Don't. */
  	unsigned hr;
! 
  	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
  };
  
! #define TRESPASS_PAGE 0x22
! #define EMC_FAILOVER_TIMEOUT (60 * HZ)
  
  /* Code borrowed from dm-lsi-rdac by Mike Christie */
  
! static inline void free_bio(struct bio *bio)
  {
! 	__free_page(bio->bi_io_vec[0].bv_page);
! 	bio_put(bio);
! }
  
! static int emc_endio(struct bio *bio, unsigned int bytes_done, int error)
! {
! 	struct path *path = bio->bi_private;
  
! 	if (bio->bi_size)
! 		return 1;
  
! 	/* We also need to look at the sense keys here whether or not to
! 	 * switch to the next PG etc.
! 	 *
! 	 * For now simple logic: either it works or it doesn't.
! 	 */
! 	if (error)
! 		dm_pg_init_complete(path, MP_FAIL_PATH);
! 	else
! 		dm_pg_init_complete(path, 0);
  
! 	/* request is freed in block layer */
! 	free_bio(bio);
  
! 	return 0;
  }
  
! static struct bio *get_failover_bio(struct path *path, unsigned data_size)
  {
! 	struct bio *bio;
! 	struct page *page;
  
! 	bio = bio_alloc(GFP_ATOMIC, 1);
! 	if (!bio) {
! 		DMERR("get_failover_bio: bio_alloc() failed.");
! 		return NULL;
  	}
  
! 	bio->bi_rw |= (1 << BIO_RW);
! 	bio->bi_bdev = path->dev->bdev;
! 	bio->bi_sector = 0;
! 	bio->bi_private = path;
! 	bio->bi_end_io = emc_endio;
  
! 	page = alloc_page(GFP_ATOMIC);
! 	if (!page) {
! 		DMERR("get_failover_bio: alloc_page() failed.");
! 		bio_put(bio);
! 		return NULL;
  	}
  
! 	if (bio_add_page(bio, page, data_size, 0) != data_size) {
! 		DMERR("get_failover_bio: alloc_page() failed.");
! 		__free_page(page);
! 		bio_put(bio);
! 		return NULL;
! 	}
  
! 	return bio;
  }
  
! static struct request *get_failover_req(struct emc_handler *h,
! 					struct bio *bio, struct path *path)
  {
  	struct request *rq;
! 	struct block_device *bdev = bio->bi_bdev;
! 	struct request_queue *q = bdev_get_queue(bdev);
  
! 	/* FIXME: Figure out why it fails with GFP_ATOMIC. */
! 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
! 	if (!rq) {
! 		DMERR("get_failover_req: blk_get_request failed");
! 		return NULL;
  	}
  
! 	rq->bio = rq->biotail = bio;
! 	blk_rq_bio_prep(q, rq, bio);
! 
! 	rq->rq_disk = bdev->bd_contains->bd_disk;
! 
! 	/* bio backed don't set data */
! 	rq->buffer = rq->data = NULL;
! 	/* rq data_len used for pc cmd's request_bufflen */
! 	rq->data_len = bio->bi_size;
  
! 	rq->sense = h->sense;
! 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
! 	rq->sense_len = 0;
  
! 	memset(&rq->cmd, 0, BLK_MAX_CDB);
  
! 	rq->timeout = EMC_FAILOVER_TIMEOUT;
! 	rq->flags |= (REQ_BLOCK_PC | REQ_FAILFAST | REQ_NOMERGE);
  
! 	return rq;
  }
  
! static struct request *emc_trespass_get(struct emc_handler *h,
! 					struct path *path)
  {
! 	struct bio *bio;
! 	struct request *rq;
! 	unsigned char *page22;
! 	unsigned char long_trespass_pg[] = {
! 		0, 0, 0, 0,
! 		TRESPASS_PAGE,        /* Page code */
! 		0x09,                 /* Page length - 2 */
! 		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation
bit */
! 		0xff, 0xff,           /* Trespass target */
! 		0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
! 		};
! 	unsigned char short_trespass_pg[] = {
! 		0, 0, 0, 0,
! 		TRESPASS_PAGE,        /* Page code */
! 		0x02,                 /* Page length - 2 */
! 		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation
bit */
! 		0xff,                 /* Trespass target */
! 		};
! 	unsigned data_size = h->short_trespass ? sizeof(short_trespass_pg) :
! 				sizeof(long_trespass_pg);
! 
! 	/* get bio backing */
! 	if (data_size > PAGE_SIZE)
! 		/* this should never happen */
! 		return NULL;
! 
! 	bio = get_failover_bio(path, data_size);
! 	if (!bio) {
! 		DMERR("emc_trespass_get: no bio");
! 		return NULL;
! 	}
! 
! 	page22 = (unsigned char *)bio_data(bio);
! 	memset(page22, 0, data_size);
! 
! 	memcpy(page22, h->short_trespass ?
! 		short_trespass_pg : long_trespass_pg, data_size);
! 
! 	/* get request for block layer packet command */
! 	rq = get_failover_req(h, bio, path);
! 	if (!rq) {
! 		DMERR("emc_trespass_get: no rq");
! 		free_bio(bio);
! 		return NULL;
! 	}
! 
! 	/* Prepare the command. */
! 	rq->cmd[0] = MODE_SELECT;
! 	rq->cmd[1] = 0x10;
! 	rq->cmd[4] = data_size;
! 	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
  
! 	return rq;
  }
  
  static void emc_pg_init(struct hw_handler *hwh, unsigned bypassed,
  			struct path *path)
  {
! 	struct request *rq;
! 	struct request_queue *q = bdev_get_queue(path->dev->bdev);
  
! 	/*
! 	 * We can either blindly init the pg (then look at the sense),
! 	 * or we can send some commands to get the state here (then
! 	 * possibly send the fo cmnd), or we can also have the
! 	 * initial state passed into us and then get an update here.
! 	 */
! 	if (!q) {
! 		DMINFO("emc_pg_init: no queue");
! 		goto fail_path;
! 	}
  
! 	/* FIXME: The request should be pre-allocated. */
! 	rq = emc_trespass_get(hwh->context, path);
! 	if (!rq) {
! 		DMERR("emc_pg_init: no rq");
! 		goto fail_path;
  	}
  
- 	DMINFO("emc_pg_init: sending switch-over command");
- 	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
  	return;
- 
- fail_path:
- 	dm_pg_init_complete(path, MP_FAIL_PATH);
  }
  
! static struct emc_handler *alloc_emc_handler(void)
  {
! 	struct emc_handler *h = kmalloc(sizeof(*h), GFP_KERNEL);
  
  	if (h) {
- 		memset(h, 0, sizeof(*h));
  		spin_lock_init(&h->lock);
  	}
  
  	return h;
--- 10,400 ----
  #include "dm.h"
  #include "dm-hw-handler.h"
  #include <scsi/scsi.h>
+ #include <scsi/scsi_eh.h>
  #include <scsi/scsi_cmnd.h>
  
! #define DM_MSG_PREFIX		"multipath emc"
! #define TRESPASS_PAGE		0x22
! #define BUFFER_SIZE		0x80
! #define EMC_HANDLER_TIMEOUT	(60 * HZ)
! #define	UNBOUND_LU		-1
! 
! /*
!  * Four variations of the CLARiiON trespass MODE_SENSE page.
!  */
! unsigned char long_trespass_and_hr_pg[] = {
! 	0, 0, 0, 0,
! 	TRESPASS_PAGE,        /* Page code */
! 	0x09,                 /* Page length - 2 */
! 	0x01,  		      /* Trespass code + Honor reservation bit */
! 	0xff, 0xff,           /* Trespass target */
! 	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
! };
! unsigned char long_trespass_pg[] = {
! 	0, 0, 0, 0,
! 	TRESPASS_PAGE,        /* Page code */
! 	0x09,                 /* Page length - 2 */
! 	0x81,  		      /* Trespass code + Honor reservation bit */
! 	0xff, 0xff,           /* Trespass target */
! 	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
! };
! unsigned char short_trespass_and_hr_pg[] = {
! 	0, 0, 0, 0,
! 	TRESPASS_PAGE,        /* Page code */
! 	0x02,                 /* Page length - 2 */
! 	0x01,  		      /* Trespass code + Honor reservation bit */
! 	0xff,                 /* Trespass target */
! };
! unsigned char short_trespass_pg[] = {
! 	0, 0, 0, 0,
! 	TRESPASS_PAGE,        /* Page code */
! 	0x02,                 /* Page length - 2 */
! 	0x81,  		      /* Trespass code + Honor reservation bit */
! 	0xff,                 /* Trespass target */
! };
  
+ /*
+  * EMC hardware handler context structure containing CLARiiON LU specific
+  * information for a particular dm multipath mapped device.
+  */
  struct emc_handler {
  	spinlock_t lock;
! 	/* name of mapped device */
! 	char name[16];
! 	struct hw_handler *hwh;
! 	struct work_struct wkq;
! 	struct request req;
! 	struct path *path;
! 	/* Use short trespass command (FC-series) or the long version
! 	 * (default for AX/CX CLARiiON arrays). */
  	unsigned short_trespass;
! 	/* Whether or not (default) to honor SCSI reservations when
! 	 * initiating a switch-over. */
  	unsigned hr;
! 	/* I/O buffer for both MODE_SELECT and INQUIRY commands. */
! 	char buffer[BUFFER_SIZE];
! 	/* SCSI sense buffer for commands -- assumes serial issuance
! 	 * and completion sequence of all commands for same multipath. */
  	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+ 	/* which SP (A=0,B=1,UNBOUND=-1) is default SP for path's mapped dev
*/
+ 	int defaultSP;
+ 	/* which SP (A=0,B=1,UNBOUND=-1) is active for path's mapped dev */
+ 	int currentSP;
  };
  
! struct workqueue_struct *kemchd;
  
  /* Code borrowed from dm-lsi-rdac by Mike Christie */
  
! /*
!  * Get block request for REQ_BLOCK_PC command issued to path.  Currently
!  * limited to MODE_SENSE (trespass) and INQUIRY (VPD page 0xC0) commands.
!  *
!  * Uses data and sense buffers in hardware handler context structure and
!  * assumes serial servicing of commands, both issuance and completion.
!  */
! static struct request *get_req(struct path *path, int opcode)
  {
! 	struct emc_handler *h = (struct emc_handler *)path->hwhcontext;
! 	struct request_queue *q = bdev_get_queue(path->dev->bdev);
! 	struct request *rq;
! 	void *buffer;
! 	int len = 0;
  
! 	/*
! 	 * Re-use the pre-allocated request struct in order to avoid
deadlock
! 	 * scenarios trying to allocate a request on a target queue which is
! 	 * over its read or write request threshold.
! 	 */
! 	rq = &h->req;
! 	rq_init(q, rq);
! 	rq->elevator_private = NULL;
! 	rq->rq_disk = NULL;
! 	rq->rl = NULL;
! 	rq->flags = 0;
  
! 	memset(&rq->cmd, 0, BLK_MAX_CDB);
! 	rq->cmd[0] = opcode;
! 	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
  
! 	switch (opcode) {
! 	case MODE_SELECT:
! 		rq->flags |= REQ_RW;
! 		rq->cmd[1] = 0x10;
! 		len = h->short_trespass ? sizeof(short_trespass_and_hr_pg) :
! 				        sizeof(long_trespass_and_hr_pg);
! 		buffer = h->short_trespass ?
! 					       h->hr ?
short_trespass_and_hr_pg
! 			      	      		     : short_trespass_pg
! 				           :
! 					       h->hr ?
long_trespass_and_hr_pg
! 			      			     : long_trespass_pg;
! 		/* Can't DMA from kernel BSS -- must copy selected trespass
! 		 * command mode page contents to context buffer which is
! 		 * allocated from kmalloc memory. */
! 		BUG_ON((len > BUFFER_SIZE));
! 		memcpy(h->buffer, buffer, len);
! 		break;
! 	case INQUIRY:
! 		rq->cmd[1] = 0x1;
! 		rq->cmd[2] = 0xC0;
! 		len = BUFFER_SIZE;
! 		memset(h->buffer, 0, BUFFER_SIZE);
! 		break;
! 	default:
! 		BUG_ON(1);
! 		break;
! 	}
! 	rq->cmd[4] = len;
! 
! 	rq->buffer = rq->data = h->buffer;
! 	rq->data_len = len;
! 	rq->bio = rq->biotail = NULL;
  
! 	rq->sense = h->sense;
! 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
! 	rq->sense_len = 0;
  
! 	rq->flags |= (REQ_BLOCK_PC | REQ_FAILFAST);
! 	rq->timeout = EMC_HANDLER_TIMEOUT;
! 	rq->retries = 0;
! 
! 	return rq;
  }
  
! /*
!  * Initialize hwhandler context structure ... defaultSP and currentSP
fields.
!  */
! static int getSPInfo(struct emc_handler *h, struct path *path, int
*defaultSP,
! 		     int *currentSP, int *newCurrentSP)
  {
! 	struct request_queue *q = bdev_get_queue(path->dev->bdev);
! 	struct request *rq;
! 	int err = 0;
  
! 	/* get and initialize block request */
! 	rq = get_req(path, INQUIRY);
! 	if (!rq)
! 		return MP_FAIL_PATH;
! 
! 	/* issue the cmd (at head of q) & synchronously wait for completion
*/
! 	blk_execute_rq(q, NULL, rq, 1);
! 	if (rq->errors == 0) {
! 		/* check for in-progress ucode upgrade (NDU) */
! 		if (h->buffer[48] != 0) {
! 			DMWARN("getSPInfo: Detected in-progress ucode
upgrade NDU operation while finding current active SP for mapped device %s
using path %s.",
! 			       h->name, path->dev->name);
! 			err = MP_BYPASS_PG;
! 		}
! 		else {
! 			*defaultSP = h->buffer[5];
! 
! 			if (h->buffer[4] == 2)
! 				/* SP for path (in h->buffer[8]) is current
*/
! 				*currentSP = h->buffer[8];
! 			else {
! 				if (h->buffer[4] == 1)
! 					/* SP for this path is NOT current
*/
! 					if (h->buffer[8] == 0)
! 						*currentSP = 1;
! 					else
! 						*currentSP = 0;
! 				else
! 					/* unbound LU or LUNZ */
! 					*currentSP = UNBOUND_LU;
! 			}
! 			*newCurrentSP =  h->buffer[8];
! 		}
  	}
+ 	else {
+ 		struct scsi_sense_hdr sshdr;
  
! 		err = MP_FAIL_PATH;
  
! 		if (rq->sense_len && scsi_normalize_sense(rq->sense,
! 						  	  rq->sense_len,
&sshdr)) {
! 			DMERR("getSPInfo: Found valid sense data %02x, %2x,
%2x while finding current active SP for mapped device %s using path %s.",
! 		       	       sshdr.sense_key, sshdr.asc, sshdr.ascq,
! 			       h->name, path->dev->name);
! 		}
! 		else DMERR("getSPInfo: Error 0x%x finding current active SP
for mapped devicce %s using path %s.", rq->errors, h->name,
path->dev->name);
  	}
  
! 	blk_put_request(rq);
  
! 	return err;
  }
  
! /* initialize path group command */
! static int pgInit(struct emc_handler *h, struct path *path)
  {
+ 	struct request_queue *q = bdev_get_queue(path->dev->bdev);
+ 	struct scsi_sense_hdr sshdr;
  	struct request *rq;
! 	int err = 0;
  
! 	/* get and initialize block request */
! 	rq = get_req(path, MODE_SELECT);
! 	if (!rq)
! 		return MP_FAIL_PATH;
! 
! 	DMINFO("pgInit: Sending switch-over command for mapped device %s
using path %s.",
! 	       h->name, path->dev->name);
! 
! 	/* issue the cmd (at head of q) & synchronously wait for completion
*/
! 	blk_execute_rq(q, NULL, rq, 1); 
! 
! 	if (rq->sense_len && scsi_normalize_sense(rq->sense,
! 						  rq->sense_len, &sshdr)) {
! 		DMERR("pgInit: Found valid sense data %02x, %2x, %2x while
sending switch-over command for mapped device %s using path %s.",
! 		       sshdr.sense_key, sshdr.asc, sshdr.ascq,
! 		       h->name, path->dev->name);
! 		if ((sshdr.sense_key = 0x05) &&
! 	    	    (sshdr.asc = 0x04) &&
! 	    	    (sshdr.ascq = 0x00)) {
! 			/*
! 			 * Array based copy in progress -- do not send
! 			 * pg_init or copy will be aborted mid-stream.
! 			 */
! 			DMWARN("pgInit: Array Based Copy in progress while
sending switch-over command for mapped device %s using path %s.",
! 			       h->name, path->dev->name);
! 			err = MP_BYPASS_PG;
! 		}
! 		else if ((sshdr.sense_key = 0x02) &&
! 	    	    	 (sshdr.asc = 0x04) &&
! 	    	    	 (sshdr.ascq = 0x03)) {
! 			/*
! 			 * LUN Not Ready - Manual Intervention Required
! 			 * indicates in-progress ucode upgrade (NDU).
! 			 */
! 			DMWARN("pgInit: Detected in-progress ucode upgrade
NDU operation while sending switch-over command for mapped device %s using
path %s.",
! 			       h->name, path->dev->name);
! 			err = MP_BYPASS_PG;
! 		} else
! 			err = MP_FAIL_PATH;
! 	}
! 	else if (rq->errors) {
! 		DMERR("pgInit: Error 0x%x while sending switch-over command
for mapped device %s using path %s.",
! 		       rq->errors, h->name, path->dev->name);
! 		err = MP_FAIL_PATH;
! 	}
! 
! 	/* release ref on block request */
! 	blk_put_request(rq);
! 
! 	return (err);
! }
! 
! static void servicePgInit(struct emc_handler *h, struct path *path)
! {
! 	int defaultSP, currentSP, newCurrentSP;
! 	int errFlags;
! 
! 	DMINFO("servicePgInit: Servicing switch-over command for mapped
device %s using path %s.",
! 	       h->name, path->dev->name);
! 
! 	if ((errFlags = getSPInfo(h, path, &defaultSP, &currentSP,
! 				  &newCurrentSP))) {
! 		dm_pg_init_complete(path, errFlags);
! 		return;
! 	}
! 	/*
! 	 * Do not issue pg_init if either (1) we do not know the identity
! 	 * of the current SP or (2) the prospective new SP is already
current.
! 	 */
! 	if ((currentSP != UNBOUND_LU) && (newCurrentSP == currentSP)) {
! 		/* yet, its as good as doing it */
! 		dm_pg_init_complete(path, 0);
! 		DMINFO("servicePgInit: Ignoring switch-over command since
path group %u of mapped device %s is already initialized for path %s.",
! 		       currentSP, h->name, path->dev->name);
! 		return;
  	}
  
! 	/* issue pg_init */
! 	if ((errFlags = pgInit(h, path))) {
! 		dm_pg_init_complete(path, errFlags);
! 		return;
! 	}
  
! 	/* update our perspective */
! 	if ((errFlags = getSPInfo(h, path, &defaultSP, &currentSP,
! 			     	  &newCurrentSP)) == 0) {
! 		unsigned long flags;
  
! 		spin_lock_irqsave(&h->lock, flags);
! 		h->defaultSP = defaultSP;
! 		h->currentSP = currentSP;
! 		spin_unlock_irqrestore(&h->lock, flags);
! 	}
  
! 	/* done now ... let pgInit errFlags override those of 2nd getSPInfo
*/
! 	dm_pg_init_complete(path, 0);
  
! 	return;
  }
  
! static void service_wkq(void *data)
  {
! 	struct emc_handler *h = (struct emc_handler *)data;
  
! 	servicePgInit(h, h->path);
! 	return;
  }
  
+ /* initialize path group command */
  static void emc_pg_init(struct hw_handler *hwh, unsigned bypassed,
  			struct path *path)
  {
! 	struct emc_handler *h = (struct emc_handler *)hwh->context;
  
! 	h->path = path;	// kemchd will use this path to service the pg_init
! 	queue_work(kemchd, &h->wkq);
! 	return;
! }
  
! static void emc_init(struct hw_handler *hwh, const char *name, struct path
*path)
! {
! 	struct emc_handler *h = (struct emc_handler *)hwh->context;
! 	int defaultSP, currentSP, newCurrentSP;
! 	int errFlags;
! 
! 	/* update our perspective */
! 	if ((errFlags = getSPInfo(h, path, &defaultSP, &currentSP,
! 			     	  &newCurrentSP)) == 0) {
! 		unsigned long flags;
! 
! 		spin_lock_irqsave(&h->lock, flags);
! 		h->defaultSP = defaultSP;
! 		h->currentSP = currentSP;
! 		strncpy(h->name, name, 16);
! 		spin_unlock_irqrestore(&h->lock, flags);
  	}
+ 	DMINFO("emc_init: Setting up hardware handler for mapped device %s
using path %s.", h->name, path->dev->name);
  
  	return;
  }
  
! static struct emc_handler *alloc_emc_handler(unsigned int short_trespass,
! 					     unsigned hr)
  {
! 	struct emc_handler *h = kzalloc(sizeof(*h), GFP_KERNEL);
  
  	if (h) {
  		spin_lock_init(&h->lock);
+ 
+ 		INIT_WORK(&h->wkq, service_wkq, h);
+ 
+ 		if ((h->short_trespass = short_trespass))
+ 			DMINFO("Short trespass command will be sent.");
+ 		else
+ 			DMINFO("Long trespass command will be sent
(default).");
+ 		if ((h->hr = hr))
+ 			DMINFO("Honor reservation bit will be set.");
+ 		else
+ 			DMINFO("Honor reservation bit will not be set
(default).");
+ 
+ 		h->defaultSP = UNBOUND_LU;
+ 		h->currentSP = UNBOUND_LU;
  	}
  
  	return h;
***************
*** 243,279 ****
  		hr = 0;
  		short_trespass = 0;
  	} else if (argc != 2) {
! 		DMWARN("incorrect number of arguments");
  		return -EINVAL;
  	} else {
  		if ((sscanf(argv[0], "%u", &short_trespass) != 1)
  			|| (short_trespass > 1)) {
! 			DMWARN("invalid trespass mode selected");
  			return -EINVAL;
  		}
  
  		if ((sscanf(argv[1], "%u", &hr) != 1)
  			|| (hr > 1)) {
! 			DMWARN("invalid honor reservation flag selected");
  			return -EINVAL;
  		}
  	}
  
! 	h = alloc_emc_handler();
  	if (!h)
  		return -ENOMEM;
  
  	hwh->context = h;
! 
! 	if ((h->short_trespass = short_trespass))
! 		DMWARN("short trespass command will be send");
! 	else
! 		DMWARN("long trespass command will be send");
! 
! 	if ((h->hr = hr))
! 		DMWARN("honor reservation bit will be set");
! 	else
! 		DMWARN("honor reservation bit will not be set (default)");
  
  	return 0;
  }
--- 410,440 ----
  		hr = 0;
  		short_trespass = 0;
  	} else if (argc != 2) {
! 		DMWARN("Incorrect number (0x%x) of arguments.  Should be
two.",
! 		       argc);
  		return -EINVAL;
  	} else {
  		if ((sscanf(argv[0], "%u", &short_trespass) != 1)
  			|| (short_trespass > 1)) {
! 			DMWARN("Invalid trespass mode (0x%x) selected.",
! 			       short_trespass);
  			return -EINVAL;
  		}
  
  		if ((sscanf(argv[1], "%u", &hr) != 1)
  			|| (hr > 1)) {
! 			DMWARN("Invalid honor reservation flag (0x%x)
selected.",
! 			       hr);
  			return -EINVAL;
  		}
  	}
  
! 	h = alloc_emc_handler(short_trespass, hr);
  	if (!h)
  		return -ENOMEM;
  
  	hwh->context = h;
! 	h->hwh = hwh;
  
  	return 0;
  }
***************
*** 324,336 ****
--- 485,524 ----
  	return dm_scsi_err_handler(hwh, bio);
  }
  
+ static int emc_status(struct hw_handler *hwh, status_type_t type,
+ 		      char *result, unsigned int maxlen)
+ {
+ 	struct emc_handler *h = (struct emc_handler *)hwh->context;
+ 	unsigned long flags;
+ 
+ 	int sz = 0;
+ 
+ 	spin_lock_irqsave(&h->lock, flags);
+ 
+ 	if (type == STATUSTYPE_INFO)
+ 		DMEMIT("2 %d %d ", h->defaultSP, h->currentSP);
+ 	else {
+ 		if (h->short_trespass || h->hr)
+ 			DMEMIT("3 %s %u %u ", hwh->type->name,
+ 			       h->short_trespass, h->hr);
+ 		else
+ 			DMEMIT("1 %s ", hwh->type->name);
+ 	}
+ 
+ 	spin_unlock_irqrestore(&h->lock, flags);
+ 
+ 	return sz;
+ }
+ 
  static struct hw_handler_type emc_hwh = {
  	.name = "emc",
  	.module = THIS_MODULE,
  	.create = emc_create,
+ 	.init	= emc_init,
  	.destroy = emc_destroy,
  	.pg_init = emc_pg_init,
  	.error = emc_error,
+ 	.status = emc_status,
  };
  
  static int __init dm_emc_init(void)
***************
*** 338,356 ****
  	int r = dm_register_hw_handler(&emc_hwh);
  
  	if (r < 0)
! 		DMERR("register failed %d", r);
  
! 	DMINFO("version 0.0.3 loaded");
  
  	return r;
  }
  
  static void __exit dm_emc_exit(void)
  {
! 	int r = dm_unregister_hw_handler(&emc_hwh);
  
  	if (r < 0)
! 		DMERR("unregister failed %d", r);
  }
  
  module_init(dm_emc_init);
--- 526,555 ----
  	int r = dm_register_hw_handler(&emc_hwh);
  
  	if (r < 0)
! 		DMERR("Register failed %d.", r);
! 	else {
! 		kemchd = create_workqueue("kemchd");
! 		if (!kemchd) {
! 			DMERR("Failed to create workqueue kemchd.");
! 			dm_unregister_hw_handler(&emc_hwh);
! 			return -ENOMEM;
! 		}
! 	}
  
! 	DMINFO("version 0.0.4 loaded");
  
  	return r;
  }
  
  static void __exit dm_emc_exit(void)
  {
! 	int r;
! 
! 	destroy_workqueue(kemchd);
  
+ 	r = dm_unregister_hw_handler(&emc_hwh);
  	if (r < 0)
! 		DMERR("Unregister failed %d.", r);
  }
  
  module_init(dm_emc_init);
