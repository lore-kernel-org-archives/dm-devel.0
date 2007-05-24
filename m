From: Dave Wysochanski <dwysocha@redhat.com>
Subject: Re: [2.6.22-rc1 PATCH] dm-hp-sw: HP Active/Passive
	hardware handler baseline
Date: Wed, 23 May 2007 22:12:50 -0400
Message-ID: <1179972770.8636.15.camel@linux-cxyg>
References: <1179951517.6397.11.camel@linux-cxyg> <4654AF71.90401@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4654AF71.90401@cs.wisc.edu>
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

On Wed, 2007-05-23 at 16:17 -0500, Mike Christie wrote:
> Dave Wysochanski wrote:
> > +#include <scsi/scsi.h>
> > +#include <scsi/scsi_cmnd.h>
> > +#include <scsi/scsi_dbg.h>
> > +#include <scsi/scsi_device.h>
> > +#include <scsi/scsi_host.h>
> > +#include <scsi/scsi_transport_fc.h>
> > +#include <linux/list.h>
> > +#include <linux/types.h>
> 
> you should do linux includes then scsi ones. Do you even need the fc,
> host or cmnd includes?
> 
Indeed, some of them are unnecessary, thanks.
scsi_cmnd.h is necessary for SCSI_SENSE_BUFFERSIZE.  The only other one
I need is scsi/scsi.h (for START_STOP and COMMAND_SIZE).  Will rearrange
and fix.


> > +
> > +#include "dm.h"
> > +#include "dm-hw-handler.h"
> > +
> > +#define DM_MSG_PREFIX "multipath hp"
> > +
> > +struct hp_sw_context {
> > +	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
> > +};
> > +
> > +
> > +/**
> > + * hp_sw_end_io - Completion handler for HP path activation.
> > + * @req: failover request
> > + * @error: scsi-ml error
> > + *
> > + *  Check sense data, free request structure, and notify dm that
> > + *  pg initialization has completed.
> > + *
> > + * Context: scsi-ml softirq
> > + *
> > + * Possible optimizations
> > + * 1. Actually check sense data for retryable error (e.g. NOT_READY)
> > + */
> > +static void hp_sw_end_io(struct request *req, int error)
> > +{
> > +	struct dm_path *path = req->end_io_data;
> > +	unsigned err_flags;
> > +
> > +	if (!error) {
> > +		err_flags = 0;
> > +		DMDEBUG("hp_sw: path activation command on %s - success",
> > +		       	path->dev->name);
> > +	}
> > +	else {
> 
> else should be on the same line as "{"
> 

done.

> 
> I also think we should handle the NOT_READY case that was reported before.
> 

Will do.

> 
> > +		DMWARN("hp_sw: path activation command on %s - error=0x%x",
> > +		       path->dev->name, error);
> > +		err_flags = MP_FAIL_PATH;
> > +	}
> > +
> > +	req->end_io_data = NULL;
> > +	__blk_put_request(req->q, req);
> > +	dm_pg_init_complete(path, err_flags);
> > +}
> > +
> > +/**
> > + * hp_sw_get_request - Allocate an HP specific path activation request
> > + * @path: path on which request will be sent (needed for request queue)
> > + *
> > + * The START command is used for path activation request.
> > + * These arrays are controller-based failover, not LUN based.
> > + * One START command issued to a single path will fail over all
> > + * LUNs for the same controller.
> > + *
> > + * Possible optimizations
> > + * 1. Make timeout configurable
> > + * 2. Preallocate request
> > + */
> > +static struct request *hp_sw_get_request(struct dm_path *path)
> > +{
> > +	struct request *req=NULL;
> > +	struct block_device *bdev = path->dev->bdev;
> > +	struct request_queue *q = bdev_get_queue(bdev);
> > +	struct hp_sw_context *h = path->hwhcontext;
> > +
> > +	req = blk_get_request(q, WRITE, GFP_ATOMIC);
> > +	if (req == NULL)
> > +		goto exit;
> > +
> > +	req->timeout = 60*HZ;
> > +
> > +	req->errors = 0;
> > +	req->cmd_type = REQ_TYPE_BLOCK_PC;
> > +	req->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
> > +	req->end_io = hp_sw_end_io;
> > +	req->end_io_data = path;
> > +	req->sense = h->sense;
> > +	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
> > +
> > +	memset(&req->cmd, 0, BLK_MAX_CDB);
> > +	req->cmd[0] = START_STOP;
> > +	req->cmd[4] = 1;
> > +	req->cmd_len = COMMAND_SIZE(req->cmd[0]);
> > +exit:
> > +	return req;
> > +}
> > +
> > +/**
> > + * hp_sw_pg_init - HP path activation implementation.
> > + * @hwh: hardware handler specific data
> > + * @bypassed: unused; is the path group bypassed? (see dm-mpath.c)
> > + * @path: path to send initialization command
> > + *
> > + * Send an HP-specific path activation command on 'path'.
> > + * Do not try to optimize in any way, just send the activation command.
> > + * More than one path activation command may be sent to the same controller.
> > + * This seems to work fine for basic failover support.
> > + *
> > + * Possible optimizations
> > + * 1. Detect an in-progress activation request and avoid submitting another one
> > + * 2. Model the controller and only send a single activation request at a time
> > + * 3. Determine the state of a path before sending an activation request
> > + *
> > + * Context: kmpathd (see process_queued_ios() in dm-mpath.c)
> > + */
> > +static void hp_sw_pg_init(struct hw_handler *hwh, unsigned bypassed,
> > +			  struct dm_path *path)
> > +{
> > +	struct request *req;
> > +	struct hp_sw_context *h;
> > +	unsigned err_flags;
> > +
> > +	path->hwhcontext = hwh->context;
> > +	h = (struct hp_sw_context *) hwh->context;
> > +
> 
> you do not need the case do you?
> 

Do you mean "the context"?  I don't understand this comment.

Also, just looked and I probably do not need err_flags in hp_sw_pg_init.
