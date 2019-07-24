From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 1/2] blk-mq: add callback of .cleanup_rq
Date: Wed, 24 Jul 2019 12:18:13 -0400
Message-ID: <20190724161813.GA13896@redhat.com>
References: <20190724031258.31688-1-ming.lei@redhat.com>
 <20190724031258.31688-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190724031258.31688-2-ming.lei@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Jul 23 2019 at 11:12pm -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> dm-rq needs to free request which has been dispatched and not completed
> by underlying queue. However, the underlying queue may have allocated
> private data for this request in .queue_rq(), so the request private data
> will be leaked in dm multipath IO code path.
> 
> Add one new callback of .cleanup_rq() to fix the memory leak.

Think the above kind of glosses over the nature of the issue.  While
this issue _is_ unique to request-based DM multipath's use of blk-mq it
ultimately is a failing of the existing blk-mq interface that SCSI's
per-request private data is leaking.  SO all said, I'd rather this patch
header reflect the nuance of why you skinned the cat like you have.

Something like this would be a better header IMHO:

SCSI maintains its own driver private data hooked off of each SCSI
request.  An upper layer driver (e.g. dm-rq) may need to retry these
SCSI requests, before SCSI has fully dispatched them, due to a lower
level SCSI driver's resource limitation identified in scsi_queue_rq().
Currently SCSI's per-request private data is leaked when the upper layer
driver (dm-rq) frees and then retries these requests in response to
BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE returns from scsi_queue_rq().

This usecase is so specialized that it doesn't warrant training an
existing blk-mq interface (e.g. blk_mq_free_request) to allow SCSI to
account for freeing its driver private data -- doing so would add an
extra branch for handling a special case that all other consumers of
SCSI (and blk-mq) won't ever need to worry about.

So the most pragmatic way forward is to delegate freeing SCSI driver
private data to the upper layer driver (dm-rq).  Do so by calling a new
blk_mq_cleanup_rq() method from dm-rq.  A following commit will
implement the .cleanup_rq() hook in scsi_mq_ops.


> Another use case is to free request when the hctx is dead during
> cpu hotplug context.

Not seeing any point forecasting this .cleanup_rq() hook's potential
ability to address that cpu hotplug case; the future patch that provides
that fix can deal with it.  Reality is the existing SCSI per-request
private data leak justifies this new hook on its own.

Mike
