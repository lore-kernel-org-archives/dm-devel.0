From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Sat, 13 Jan 2018 22:34:07 +0800
Message-ID: <20180113143356.GA10690@ming.t460p>
References: <1515710256.2752.72.camel@sandisk.com>
 <20180112014232.GB25090@ming.t460p>
 <20180112015721.GB32298@redhat.com>
 <20180112033308.GC25090@ming.t460p>
 <20180112171840.GA4541@redhat.com>
 <1515778013.2396.3.camel@wdc.com>
 <20180112174000.GB5134@redhat.com>
 <1515779211.2396.11.camel@wdc.com>
 <20180112180635.GD5134@redhat.com>
 <1515783288.2396.37.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515783288.2396.37.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>
List-Id: dm-devel.ids

On Fri, Jan 12, 2018 at 06:54:49PM +0000, Bart Van Assche wrote:
> On Fri, 2018-01-12 at 13:06 -0500, Mike Snitzer wrote:
> > OK, you have the stage: please give me a pointer to your best
> > explaination of the several.
> 
> Since the previous discussion about this topic occurred more than a month
> ago it could take more time to look up an explanation than to explain it
> again. Anyway, here we go. As you know a block layer request queue needs to
> be rerun if one or more requests are waiting and a previous condition that
> prevented the request to be executed has been cleared. For the dm-mpath
> driver, examples of such conditions are no tags available, a path that is
> busy (see also pgpath_busy()), path initialization that is in progress
> (pg_init_in_progress) or a request completes with status, e.g. if the
> SCSI core calls __blk_mq_end_request(req, error) with error != 0. For some
> of these conditions, e.g. path initialization completes, a callback
> function in the dm-mpath driver is called and it is possible to explicitly
> rerun the queue. I agree that for such scenario's a delayed queue run should
> not be triggered. For other scenario's, e.g. if a SCSI initiator submits a
> SCSI request over a fabric and the SCSI target replies with "BUSY" then the
> SCSI core will end the I/O request with status BLK_STS_RESOURCE after the
> maximum number of retries has been reached (see also scsi_io_completion()).
> In that last case, if a SCSI target sends a "BUSY" reply over the wire back
> to the initiator, there is no other approach for the SCSI initiator to
> figure out whether it can queue another request than to resubmit the
> request. The worst possible strategy is to resubmit a request immediately
> because that will cause a significant fraction of the fabric bandwidth to
> be used just for replying "BUSY" to requests that can't be processed
> immediately.

That isn't true, when BLK_STS_RESOURCE is returned to blk-mq, blk-mq
will apply BLK_MQ_S_SCHED_RESTART to hold the queue until one in-flight
request is completed, please see blk_mq_sched_restart() which is called
from blk_mq_free_request().

Also now we have IO schedulers, when blk_get_request() in dm-mpath returns
NULL, it doesn't provide underlying queue's BUSY accurately or in time, since
at default size of scheduler tags is double size of driver tags. So it isn't
good to depend blk_get_request() only to evaluate queue's busy status, this
patchset provides underlying's dispatch result directly to blk-mq, and can deal
with this case much better.

> 
> The intention of commit 6077c2d706097c0 was to address the last mentioned
> case. It may be possible to move the delayed queue rerun from the
> dm_queue_rq() into dm_requeue_original_request(). But I think it would be
> wrong to rerun the queue immediately in case a SCSI target system returns
> "BUSY".

Again, queue won't be rerun immediately after STS_RESOURCE is returned to
blk-mq. And BLK_MQ_S_SCHED_RESTART should address your concern on continuous
resubmission in case of running out of requests, right?

Thanks,
Ming
