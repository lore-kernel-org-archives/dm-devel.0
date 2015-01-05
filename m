From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Mon, 5 Jan 2015 16:35:57 -0500
Message-ID: <20150105213557.GA5030@redhat.com>
References: <5498389D.6070909@acm.org> <20141222184910.GB8054@redhat.com>
	<54999756.70303@acm.org>
	<1v2g6masssbu88ans1r6lres.1419354811001@email.android.com>
	<CAMM=eLd_A+fRBHDvcDqwF1a9co+G7XZvVhRyBd1AjxOdgjKhbA@mail.gmail.com>
	<549AB979.4050302@acm.org> <20141224182143.GA12922@redhat.com>
	<20141224185529.GA13246@redhat.com>
	<20141224192643.GA30461@redhat.com> <54A6DB1D.4030201@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54A6DB1D.4030201@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Fri, Jan 02 2015 at 12:53pm -0500,
Bart Van Assche <bvanassche@acm.org> wrote:

> On 12/24/14 20:26, Mike Snitzer wrote:
> > This fixes it:
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index cdd84e9..138ffb2 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -2030,6 +2030,8 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
> >  		return -EIO;
> >  
> >  	if (q->mq_ops) {
> > +		if (blk_queue_io_stat(rq->q))
> > +			blk_account_io_start(rq, true);
> >  		blk_mq_insert_request(rq, false, true, true);
> >  		return 0;
> >  	}
> > 
> > I've folded this fix into this commit (and rebased the 'for-next' and
> > 'dm-for-3.20-blk-mq' branches):
> > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=1fd5e9c83c4ae6a5144783855e9b29a8f42bdc4a
> 
> Hello Mike,
> 
> Thanks, my tests confirm that this patch indeed fixes the issue I had
> reported. Unfortunately this doesn't mean that the blk-mq multipath code
> is already working perfectly. Most of the time I/O requests are
> processed within the expected time but sometimes I/O processing takes
> much more time than what I expected:
>
> # /usr/bin/time -f %e mkfs.xfs -f /dev/dm-0 >/dev/null
> 0.02
> # /usr/bin/time -f %e mkfs.xfs -f /dev/dm-0 >/dev/null
> 0.02
> # /usr/bin/time -f %e mkfs.xfs -f /dev/dm-0 >/dev/null
> 8.68
> 
> However, if I run the same command on the underlying device it always
> completes within the expected time.

I don't have very large blk-mq devices, but I can work on that.
How large is the blk-mq device in question?

Also, how much memory does the system have?  Is memory fragmented at
all?  With this change the requests are cloned using memory allocated
from block core's blk_get_request (rather than a dedicated mempool in DM
core).

Any chance you could use 'perf record' to try to analyze where the
kernel is spending its time?

Thanks for your continued help in testing these changes.

Mike
