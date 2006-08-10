From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: patch to dm-emc.c
Date: Thu, 10 Aug 2006 03:43:15 -0400
Message-ID: <44DAE393.4040107@cs.wisc.edu>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D135B@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D135B@CORPUSMX40A.corp.emc.com>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

egoggin@emc.com wrote:
>  
> +	/*
> +	 * Link all paths of mapped device to the same hwh context.
> +	 */
> +	hwh = &m->hw_handler;
> +	if (hwh->type) {
> +		list_for_each_entry(pg, &m->priority_groups, list) {
> +			list_for_each_entry(pgpath, &pg->pgpaths, list) {
> +				(path = &pgpath->path)->hwhcontext =
> hwh->context;


This and some other places got wrapped.


> +			}
> +		}
> +	}
> +
> +	/*
> +	 * Initialize the hardware context now that all paths are setup,
> +	 * pass any one of the paths to be used to access the device.
> +	 */
> +	if (hwh->type && hwh->type->init && path) {
> +		/* pass mapped device name for event logging */
> +		const char *name =
> dm_device_name(dm_table_get_md(ti->table));
> +		hwh->type->init(hwh, name, path);
> +		dm_table_put_md(ti->table);
> +	}
> +
>  	ti->private = m;
> -	m->ti = ti;
>  
>  	return 0;
>  
> 
> --- drivers/md/dm-hw-handler.h.orig	2006-08-03 04:04:54.000000000 -0500
> +++ drivers/md/dm-hw-handler.h	2006-08-03 04:04:54.000000000 -0500
> @@ -29,6 +29,8 @@
>  
>  	int (*create) (struct hw_handler *handler, unsigned int argc,
>  		       char **argv);
> +	void (*init) (struct hw_handler *hwh, const char *name,
> +		      struct path *path);
>  	void (*destroy) (struct hw_handler *hwh);
>  
>  	void (*pg_init) (struct hw_handler *hwh, unsigned bypassed,
> 
> 
> --- drivers/md/dm-emc.c.orig	2006-08-03 04:04:54.000000000 -0500
> +++ drivers/md/dm-emc.c	2006-08-06 20:40:48.000000000 -0500
> @@ -10,224 +10,391 @@
>  #include "dm.h"
>  #include "dm-hw-handler.h"
>  #include <scsi/scsi.h>
> +#include <scsi/scsi_eh.h>
>  #include <scsi/scsi_cmnd.h>
>  
> -#define DM_MSG_PREFIX "multipath emc"
> +#define DM_MSG_PREFIX		"multipath emc"
> +#define TRESPASS_PAGE		0x22
> +#define BUFFER_SIZE		0x80
> +#define EMC_HANDLER_TIMEOUT	(60 * HZ)
> +#define	UNBOUND_LU		-1
> +
> +/*
> + * Four variations of the CLARiiON trespass MODE_SENSE page.
> + */
> +unsigned char long_trespass_and_hr_pg[] = {
> +	0, 0, 0, 0,
> +	TRESPASS_PAGE,        /* Page code */
> +	0x09,                 /* Page length - 2 */
> +	0x01,  		      /* Trespass code + Honor reservation bit */
> +	0xff, 0xff,           /* Trespass target */
> +	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
> +};
> +unsigned char long_trespass_pg[] = {
> +	0, 0, 0, 0,
> +	TRESPASS_PAGE,        /* Page code */
> +	0x09,                 /* Page length - 2 */
> +	0x81,  		      /* Trespass code + Honor reservation bit */
> +	0xff, 0xff,           /* Trespass target */
> +	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
> +};
> +unsigned char short_trespass_and_hr_pg[] = {
> +	0, 0, 0, 0,
> +	TRESPASS_PAGE,        /* Page code */
> +	0x02,                 /* Page length - 2 */
> +	0x01,  		      /* Trespass code + Honor reservation bit */
> +	0xff,                 /* Trespass target */
> +};
> +unsigned char short_trespass_pg[] = {
> +	0, 0, 0, 0,
> +	TRESPASS_PAGE,        /* Page code */
> +	0x02,                 /* Page length - 2 */
> +	0x81,  		      /* Trespass code + Honor reservation bit */
> +	0xff,                 /* Trespass target */
> +};
>  
> +/*
> + * EMC hardware handler context structure containing CLARiiON LU specific
> + * information for a particular dm multipath mapped device.
> + */
>  struct emc_handler {
>  	spinlock_t lock;
> -
> -	/* Whether we should send the short trespass command (FC-series)
> -	 * or the long version (default for AX/CX CLARiiON arrays). */
> +	/* name of mapped device */
> +	char name[16];
> +	struct hw_handler *hwh;
> +	struct work_struct wkq;
> +	struct request req;

You should not have to do this should you? The queue has a mempool of
requests. The only way it could be exhausted is if some app is hogging
them by doing SG_IO (since dm bd_claims the device), you do not use
GFP_WAIT in your allocation, and you really hit some nasty case where
your process is starved because you keep missing the chance to allocate
a request that is freed and put back in the pool. If you are that
unlucky and that happens though, you would have problems elsewhere
though so maybe a generic solution to make sure no one gets starved
would be better.


> +	struct path *path;
> +	/* Use short trespass command (FC-series) or the long version
> +	 * (default for AX/CX CLARiiON arrays). */
>  	unsigned short_trespass;
> -	/* Whether or not to honor SCSI reservations when initiating a
> -	 * switch-over. Default: Don't. */
> +	/* Whether or not (default) to honor SCSI reservations when
> +	 * initiating a switch-over. */
>  	unsigned hr;
> -
> +	/* I/O buffer for both MODE_SELECT and INQUIRY commands. */
> +	char buffer[BUFFER_SIZE];
> +	/* SCSI sense buffer for commands -- assumes serial issuance
> +	 * and completion sequence of all commands for same multipath. */
>  	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
> +	/* which SP (A=0,B=1,UNBOUND=-1) is default SP for path's mapped dev
> */
> +	int defaultSP;
> +	/* which SP (A=0,B=1,UNBOUND=-1) is active for path's mapped dev */
> +	int currentSP;
>  };
>  
> -#define TRESPASS_PAGE 0x22
> -#define EMC_FAILOVER_TIMEOUT (60 * HZ)
> +struct workqueue_struct *kemchd;
>  
>  /* Code borrowed from dm-lsi-rdac by Mike Christie */
>  
> -static inline void free_bio(struct bio *bio)
> +/*
> + * Get block request for REQ_BLOCK_PC command issued to path.  Currently
> + * limited to MODE_SENSE (trespass) and INQUIRY (VPD page 0xC0) commands.
> + *
> + * Uses data and sense buffers in hardware handler context structure and
> + * assumes serial servicing of commands, both issuance and completion.
> + */
> +static struct request *get_req(struct path *path, int opcode)
>  {
> -	__free_page(bio->bi_io_vec[0].bv_page);
> -	bio_put(bio);
> -}
> +	struct emc_handler *h = (struct emc_handler *)path->hwhcontext;
> +	struct request_queue *q = bdev_get_queue(path->dev->bdev);
> +	struct request *rq;
> +	void *buffer;
> +	int len = 0;
>  
> -static int emc_endio(struct bio *bio, unsigned int bytes_done, int error)
> -{
> -	struct path *path = bio->bi_private;
> +	/*
> +	 * Re-use the pre-allocated request struct in order to avoid
> deadlock
> +	 * scenarios trying to allocate a request on a target queue which is
> +	 * over its read or write request threshold.
> +	 */
> +	rq = &h->req;
> +	rq_init(q, rq);
> +	rq->elevator_private = NULL;
> +	rq->rq_disk = NULL;
> +	rq->rl = NULL;
> +	rq->flags = 0;
>  
> -	if (bio->bi_size)
> -		return 1;
> +	memset(&rq->cmd, 0, BLK_MAX_CDB);
> +	rq->cmd[0] = opcode;
> +	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
>  
> -	/* We also need to look at the sense keys here whether or not to
> -	 * switch to the next PG etc.
> -	 *
> -	 * For now simple logic: either it works or it doesn't.
> -	 */
> -	if (error)
> -		dm_pg_init_complete(path, MP_FAIL_PATH);
> -	else
> -		dm_pg_init_complete(path, 0);
> +	switch (opcode) {
> +	case MODE_SELECT:
> +		rq->flags |= REQ_RW;
> +		rq->cmd[1] = 0x10;
> +		len = h->short_trespass ? sizeof(short_trespass_and_hr_pg) :
> +				        sizeof(long_trespass_and_hr_pg);
> +		buffer = h->short_trespass ?
> +					       h->hr ?
> short_trespass_and_hr_pg
> +			      	      		     : short_trespass_pg
> +				           :
> +					       h->hr ?
> long_trespass_and_hr_pg
> +			      			     : long_trespass_pg;
> +		/* Can't DMA from kernel BSS -- must copy selected trespass
> +		 * command mode page contents to context buffer which is
> +		 * allocated from kmalloc memory. */
> +		BUG_ON((len > BUFFER_SIZE));
> +		memcpy(h->buffer, buffer, len);
> +		break;
> +	case INQUIRY:
> +		rq->cmd[1] = 0x1;
> +		rq->cmd[2] = 0xC0;
> +		len = BUFFER_SIZE;
> +		memset(h->buffer, 0, BUFFER_SIZE);
> +		break;
> +	default:
> +		BUG_ON(1);
> +		break;
> +	}
> +	rq->cmd[4] = len;
> +
> +	rq->buffer = rq->data = h->buffer;


You should use one of the block layer helpers. And yes I know they
allocate mem so fix the bio code so that it is also fixed for the path
testers :)


> +	rq->data_len = len;
> +	rq->bio = rq->biotail = NULL;
>  
> -	/* request is freed in block layer */
> -	free_bio(bio);
> +	rq->sense = h->sense;
> +	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
> +	rq->sense_len = 0;
>  
> -	return 0;
> +	rq->flags |= (REQ_BLOCK_PC | REQ_FAILFAST);
> +	rq->timeout = EMC_HANDLER_TIMEOUT;
> +	rq->retries = 0;
> +
> +	return rq;
>  }
>  
> -static struct bio *get_failover_bio(struct path *path, unsigned data_size)
> +/*
> + * Initialize hwhandler context structure ... defaultSP and currentSP
> fields.
> + */
> +static int getSPInfo(struct emc_handler *h, struct path *path, int
> *defaultSP,
> +		     int *currentSP, int *newCurrentSP)
>  {


Here and throughout the rest of the patch, don't add mixed case and
follow the 80 col rule please.


> -	struct bio *bio;
> -	struct page *page;
> +	struct request_queue *q = bdev_get_queue(path->dev->bdev);
> +	struct request *rq;
> +	int err = 0;
>  
> -	bio = bio_alloc(GFP_ATOMIC, 1);
> -	if (!bio) {
> -		DMERR("get_failover_bio: bio_alloc() failed.");
> -		return NULL;
> +	/* get and initialize block request */
> +	rq = get_req(path, INQUIRY);
> +	if (!rq)
> +		return MP_FAIL_PATH;
> +
> +	/* issue the cmd (at head of q) & synchronously wait for completion
> */
> +	blk_execute_rq(q, NULL, rq, 1);
> +	if (rq->errors == 0) {
> +		/* check for in-progress ucode upgrade (NDU) */
> +		if (h->buffer[48] != 0) {
> +			DMWARN("getSPInfo: Detected in-progress ucode
> upgrade NDU operation while finding current active SP for mapped device %s
> using path %s.",
> +			       h->name, path->dev->name);
> +			err = MP_BYPASS_PG;
> +		}
> +		else {


the "else" here and other places should be on the same line as the "}".
See the coding style doc.


> +			*defaultSP = h->buffer[5];
> +
> +			if (h->buffer[4] == 2)
> +				/* SP for path (in h->buffer[8]) is current
> */
> +				*currentSP = h->buffer[8];
> +			else {
> +				if (h->buffer[4] == 1)
> +					/* SP for this path is NOT current
> */
> +					if (h->buffer[8] == 0)
> +						*currentSP = 1;
> +					else
> +						*currentSP = 0;
> +				else
> +					/* unbound LU or LUNZ */
> +					*currentSP = UNBOUND_LU;
> +			}
> +			*newCurrentSP =  h->buffer[8];
> +		}
>  	}
> +	else {
> +		struct scsi_sense_hdr sshdr;
>  
> -	bio->bi_rw |= (1 << BIO_RW);
> -	bio->bi_bdev = path->dev->bdev;
> -	bio->bi_sector = 0;
> -	bio->bi_private = path;
> -	bio->bi_end_io = emc_endio;
> +		err = MP_FAIL_PATH;
>  
> -	page = alloc_page(GFP_ATOMIC);
> -	if (!page) {
> -		DMERR("get_failover_bio: alloc_page() failed.");
> -		bio_put(bio);
> -		return NULL;
> +		if (rq->sense_len && scsi_normalize_sense(rq->sense,
> +						  	  rq->sense_len,
> &sshdr)) {
> +			DMERR("getSPInfo: Found valid sense data %02x, %2x,
> %2x while finding current active SP for mapped device %s using path %s.",
> +		       	       sshdr.sense_key, sshdr.asc, sshdr.ascq,
> +			       h->name, path->dev->name);
> +		}
> +		else DMERR("getSPInfo: Error 0x%x finding current active SP
> for mapped devicce %s using path %s.", rq->errors, h->name,
> path->dev->name);
>  	}
>  
> -	if (bio_add_page(bio, page, data_size, 0) != data_size) {
> -		DMERR("get_failover_bio: alloc_page() failed.");
> -		__free_page(page);
> -		bio_put(bio);
> -		return NULL;
> -	}
> +	blk_put_request(rq);
>  
> -	return bio;
> +	return err;
>  }
>  
> -static struct request *get_failover_req(struct emc_handler *h,
> -					struct bio *bio, struct path *path)
> +/* initialize path group command */
> +static int pgInit(struct emc_handler *h, struct path *path)
>  {
> +	struct request_queue *q = bdev_get_queue(path->dev->bdev);
> +	struct scsi_sense_hdr sshdr;
>  	struct request *rq;
> -	struct block_device *bdev = bio->bi_bdev;
> -	struct request_queue *q = bdev_get_queue(bdev);
> +	int err = 0;
>  
> -	/* FIXME: Figure out why it fails with GFP_ATOMIC. */
> -	rq = blk_get_request(q, WRITE, __GFP_WAIT);
> -	if (!rq) {
> -		DMERR("get_failover_req: blk_get_request failed");
> -		return NULL;
> +	/* get and initialize block request */
> +	rq = get_req(path, MODE_SELECT);
> +	if (!rq)
> +		return MP_FAIL_PATH;
> +
> +	DMINFO("pgInit: Sending switch-over command for mapped device %s
> using path %s.",
> +	       h->name, path->dev->name);
> +
> +	/* issue the cmd (at head of q) & synchronously wait for completion
> */
> +	blk_execute_rq(q, NULL, rq, 1); 



Why synchronously? For lot-o-devices we do not want to do do this do we?
We have functions and callbacks now to do this properly asynchronously.
