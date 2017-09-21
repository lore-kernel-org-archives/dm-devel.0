From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] dm-mpath: Improve handling of busy paths
Date: Fri, 22 Sep 2017 06:58:48 +0800
Message-ID: <20170921225847.GF6854@ming.t460p>
References: <20170920181212.5532-1-bart.vanassche@wdc.com>
	<20170920223605.GC5105@ming.t460p>
	<1505949968.2509.32.camel@wdc.com>
	<20170921014102.GA6854@ming.t460p>
	<1506009224.2521.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1506009224.2521.12.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>, "snitzer@redhat.com" <snitzer@redhat.com>, "hare@suse.com" <hare@suse.com>
List-Id: dm-devel.ids

On Thu, Sep 21, 2017 at 03:53:45PM +0000, Bart Van Assche wrote:
> On Thu, 2017-09-21 at 09:41 +0800, Ming Lei wrote:
> > On Wed, Sep 20, 2017 at 11:26:09PM +0000, Bart Van Assche wrote:
> > > dm-mpath request submission latency if the underlying driver returns
> > > "busy" frequently without touching the "return DM_MAPIO_DELAY_REQUEUE"
> > 
> > I already explained, the DM_MAPIO_DELAY_REQUEUE can be changed
> > to DM_MAPIO_REQUEUE at least for dm-rq-mq via SCHED_RESTART, even
> > for dm-rq-sq, it should be possible but need to make sure there
> > is in-flight requests because we run queue in rq_completed().
> 
> Sorry but I think that would be wrong because it would result in the dm-mpath
> driver to busy-wait for a request if blk_get_request(..., GFP_ATOMIC) fails
> either due to all tags having been allocated or because the path is dying.
> Have you had a look at commit 1c23484c355e ("dm-mpath: do not lock up a CPU
> with requeuing activity")? Do you understand the purpose of that change?

This issue shouldn't be related with 1c23484c355e ("dm-mpath: do not lock
up a CPU with requeuing activity"), but we still can return DM_MAPIO_DELAY_REQUEUE
when queue is dying.

Also I don't think 1c23484c355e makes sense and still like a workaround,
when one underlying queue is dying, the I/O to be requeued should be
switched to another path in the following dispatch, and finally the I/O
should be failed if all paths are down. So how can the requeue activity
lock up a CPU when get_request() returns NULL and queue is dying?

Actually the big performance issue is in that DM_MAPIO_DELAY_REQUEUE is
returned when get_request() returns NULL, this way will make .queue_rq()
return BLK_STS_OK, and lie to block layer, and actually BLK_STS_RESOURCE
should have been returned. Then I/O merge becomes hard to do.

> 
> > As I explained, this patch can't fix the I/O merge issue since it is easy
> > to trigger queue busy before running out of requests, that is why I
> > changes the 'nr_request' in the patch 5 of 'dm-mpath: improve I/O schedule'.
> 
> Sorry but I don't think that *any* value of nr_requests can prevent that the
> dm-mpath driver submits requests against a busy path. If multiple LUNs are
> associated with the same SCSI host and I/O is ongoing against multiple LUNs
> concurrently then it is not possible to choose a value for nr_requests that
> prevents that a request is queued against a busy SCSI device. How about using
> something like the (untested) patch below to prevent that requests are queued
> against a busy SCSI path?

Actually the 'nr_requests' is set for each path/underlying queue in my
patch, not per dm queue.

> 
> 
> [PATCH] scsi_lld_busy(): Improve busy detection
> 
> To achieve optimal I/O scheduling it is important that the
> dm-mpath driver returns "busy" if the path it will submit a
> request to is busy. Hence also check whether the target and
> the host are busy from inside scsi_lld_busy(). Note:
> dm_mq_queue_rq() calls scsi_lld_busy() as follows:
> 
> 	if (ti->type->busy && ti->type->busy(ti))
> 		return BLK_STS_RESOURCE;

OK, looks good to call pgpath_busy() in multipath_clone_and_map()
before allocating request, and make sure BLK_STS_RESOURCE is
returned to block layer.

-- 
Ming
