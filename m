From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 0/5] dm-rq: improve sequential I/O performance
Date: Sat, 13 Jan 2018 10:14:47 -0500
Message-ID: <20180113151446.GB11158@redhat.com>
References: <20180112171840.GA4541@redhat.com>
 <1515778013.2396.3.camel@wdc.com>
 <20180112174000.GB5134@redhat.com>
 <1515779211.2396.11.camel@wdc.com>
 <20180112180635.GD5134@redhat.com>
 <1515783288.2396.37.camel@wdc.com>
 <AT5PR8401MB0387801D9DC1686503921AE5AB170@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
 <20180113005213.GB7207@redhat.com>
 <1515805255.2396.94.camel@wdc.com>
 <20180113013705.GC7207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180113013705.GC7207@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "elliott@hpe.com" <elliott@hpe.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 12 2018 at  8:37pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Jan 12 2018 at  8:00pm -0500,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
> > On Fri, 2018-01-12 at 19:52 -0500, Mike Snitzer wrote:
> > > It was 50 ms before it was 100 ms.  No real explaination for these
> > > values other than they seem to make Bart's IB SRP testbed happy?
> > 
> > But that constant was not introduced by me in the dm code.
> 
> No actually it was (not that there's anything wrong with that):
> 
> commit 06eb061f48594aa369f6e852b352410298b317a8
> Author: Bart Van Assche <bart.vanassche@sandisk.com>
> Date:   Fri Apr 7 16:50:44 2017 -0700
> 
>     dm mpath: requeue after a small delay if blk_get_request() fails
> 
>     If blk_get_request() returns ENODEV then multipath_clone_and_map()
>     causes a request to be requeued immediately. This can cause a kworker
>     thread to spend 100% of the CPU time of a single core in
>     __blk_mq_run_hw_queue() and also can cause device removal to never
>     finish.
> 
>     Avoid this by only requeuing after a delay if blk_get_request() fails.
>     Additionally, reduce the requeue delay.
> 
>     Cc: stable@vger.kernel.org # 4.9+
>     Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> Note that this commit actually details a different case where a
> blk_get_request() (in existing code) return of -ENODEV is a very
> compelling case to use DM_MAPIO_DELAY_REQUEUE.
> 
> SO I'll revisit what is appropriate in multipath_clone_and_map() on
> Monday.

Sleep helped.  I had another look and it is only the old .request_fn
blk_get_request() code that even sets -ENODEV (if blk_queue_dying).

But thankfully the blk_get_request() error handling in
multipath_clone_and_map() checks for blk_queue_dying() and will return
DM_MAPIO_DELAY_REQUEUE.

So we're all set for this case.

Mike
