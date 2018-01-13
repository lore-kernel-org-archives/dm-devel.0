From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 0/5] dm-rq: improve sequential I/O
	performance
Date: Sat, 13 Jan 2018 23:04:35 +0800
Message-ID: <20180113150434.GC8013@ming.t460p>
References: <20180112014232.GB25090@ming.t460p>
	<20180112015721.GB32298@redhat.com>
	<20180112033308.GC25090@ming.t460p>
	<20180112171840.GA4541@redhat.com>
	<1515778013.2396.3.camel@wdc.com>
	<20180112174000.GB5134@redhat.com>
	<1515779211.2396.11.camel@wdc.com>
	<20180112180635.GD5134@redhat.com>
	<1515783288.2396.37.camel@wdc.com>
	<20180112223117.GA6332@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180112223117.GA6332@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: dm-devel.ids

On Fri, Jan 12, 2018 at 05:31:17PM -0500, Mike Snitzer wrote:
> On Fri, Jan 12 2018 at  1:54pm -0500,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
> > On Fri, 2018-01-12 at 13:06 -0500, Mike Snitzer wrote:
> > > OK, you have the stage: please give me a pointer to your best
> > > explaination of the several.
> > 
> > Since the previous discussion about this topic occurred more than a month
> > ago it could take more time to look up an explanation than to explain it
> > again. Anyway, here we go. As you know a block layer request queue needs to
> > be rerun if one or more requests are waiting and a previous condition that
> > prevented the request to be executed has been cleared. For the dm-mpath
> > driver, examples of such conditions are no tags available, a path that is
> > busy (see also pgpath_busy()), path initialization that is in progress
> > (pg_init_in_progress) or a request completes with status, e.g. if the
> > SCSI core calls __blk_mq_end_request(req, error) with error != 0. For some
> > of these conditions, e.g. path initialization completes, a callback
> > function in the dm-mpath driver is called and it is possible to explicitly
> > rerun the queue. I agree that for such scenario's a delayed queue run should
> > not be triggered. For other scenario's, e.g. if a SCSI initiator submits a
> > SCSI request over a fabric and the SCSI target replies with "BUSY" then the
> > SCSI core will end the I/O request with status BLK_STS_RESOURCE after the
> > maximum number of retries has been reached (see also scsi_io_completion()).
> > In that last case, if a SCSI target sends a "BUSY" reply over the wire back
> > to the initiator, there is no other approach for the SCSI initiator to
> > figure out whether it can queue another request than to resubmit the
> > request. The worst possible strategy is to resubmit a request immediately
> > because that will cause a significant fraction of the fabric bandwidth to
> > be used just for replying "BUSY" to requests that can't be processed
> > immediately.
> 
> The thing is, the 2 scenarios you are most concerned about have
> _nothing_ to do with dm_mq_queue_rq() at all.  They occur as an error in
> the IO path _after_ the request is successfully retrieved with
> blk_get_request() and then submitted.
>  
> > The intention of commit 6077c2d706097c0 was to address the last mentioned
> > case.
> 
> So it really makes me question why you think commit 6077c2d706097c0
> addresses the issue you think it does.  And gives me more conviction to
> remove 6077c2d706097c0.
> 
> It may help just by virtue of blindly kicking the queue if
> blk_get_request() fails (regardless of the target is responding with
> BUSY or not).  Very unsatisfying to say the least.
> 
> I think it'd be much more beneficial for dm-mpath.c:multipath_end_io()
> to be trained to be respond more intelligently to BLK_STS_RESOURCE.
> 
> E.g. set BLK_MQ_S_SCHED_RESTART if requests are known to be outstanding
> on the path.  This is one case where Ming said the queue would be
> re-run, as detailed in this header:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=5b18cff4baedde77e0d69bd62a13ae78f9488d89
> 
> And Jens has reinforced to me that BLK_MQ_S_SCHED_RESTART is a means to
> kicking the queue more efficiently.  _BUT_ I'm not seeing any external
> blk-mq interface that exposes this capability to a blk-mq driver.  As is
> BLK_MQ_S_SCHED_RESTART gets set very much in the bowels of blk-mq
> (blk_mq_sched_mark_restart_hctx).
> 
> SO I have to do more homework here...
> 
> Ming or Jens: might you be able to shed some light on how dm-mpath
> would/could set BLK_MQ_S_SCHED_RESTART?  A new function added that can

When BLK_STS_RESOURCE is returned from .queue_rq(), blk_mq_dispatch_rq_list()
will check if BLK_MQ_S_SCHED_RESTART is set.

If it has been set, the queue won't be rerun for this request, and the queue
will be rerun until one in-flight request is completed, see blk_mq_sched_restart()
which is called from blk_mq_free_request().

If BLK_MQ_S_SCHED_RESTART isn't set, queue is rerun in blk_mq_dispatch_rq_list(),
and BLK_MQ_S_SCHED_RESTART is set before calling .queue_rq(), see
blk_mq_sched_mark_restart_hctx() which is called in blk_mq_sched_dispatch_requests().

This mechanism can avoid continuous running queue in case of STS_RESOURCE, that
means drivers wouldn't worry about that by adding random delay.


-- 
Ming
