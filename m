From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH RESEND] blk-mq: insert request not through ->queue_rq
 into sw/scheduler queue
Date: Wed, 19 Aug 2020 07:52:20 +0800
Message-ID: <20200818235220.GA2712797@T590>
References: <20200818090728.2696802-1-ming.lei@redhat.com>
 <92162ee6-0fa0-dafd-69b1-af285ee61044@kernel.dk>
 <20200818152022.GB6842@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200818152022.GB6842@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Aug 18, 2020 at 11:20:22AM -0400, Mike Snitzer wrote:
> On Tue, Aug 18 2020 at 10:50am -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
> > On 8/18/20 2:07 AM, Ming Lei wrote:
> > > c616cbee97ae ("blk-mq: punt failed direct issue to dispatch list") supposed
> > > to add request which has been through ->queue_rq() to the hw queue dispatch
> > > list, however it adds request running out of budget or driver tag to hw queue
> > > too. This way basically bypasses request merge, and causes too many request
> > > dispatched to LLD, and system% is unnecessary increased.
> > > 
> > > Fixes this issue by adding request not through ->queue_rq into sw/scheduler
> > > queue, and this way is safe because no ->queue_rq is called on this request
> > > yet.
> > > 
> > > High %system can be observed on Azure storvsc device, and even soft lock
> > > is observed. This patch reduces %system during heavy sequential IO,
> > > meantime decreases soft lockup risk.
> > 
> > Applied, thanks Ming.
> 
> Hmm, strikes me as strange that this is occurring given the direct
> insertion into blk-mq queue (bypassing scheduler) is meant to avoid 2
> layers of IO merging when dm-mulipath is stacked on blk-mq path(s).  The
> dm-mpath IO scheduler does all merging and underlying paths' blk-mq
> request_queues are meant to just dispatch the top-level's requests.
> 
> So this change concerns me.  Feels like this design has broken down.
> 

'bypass_insert' is 'true' when blk_insert_cloned_request() is
called from device mapper code, so this patch doesn't affect dm.

> Could be that some other entry point was added for the
> __blk_mq_try_issue_directly() code?  And it needs to be untangled away
> from the dm-multipath use-case?

__blk_mq_try_issue_directly() can be called from blk-mq directly, that
is the case this patch is addressing, if one request can't be queued to
LLD because of running out of budget or driver tag, it should be added to
scheduler queue for improving io merge, meantime we can avoid too many
requests dispatched to hardware.


Thanks,
Ming
