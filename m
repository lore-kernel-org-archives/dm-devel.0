From: Ming Lei <ming.lei@redhat.com>
Subject: Re: dm-rq: do not update rq partially in each ending bio
Date: Sat, 26 Aug 2017 01:14:50 +0800
Message-ID: <20170825171449.GC13937@ming.t460p>
References: <20170825152749.14435-1-ming.lei@redhat.com>
 <20170825154839.GA1695@redhat.com>
 <20170825160850.GA13937@ming.t460p>
 <20170825163233.GB1900@redhat.com>
 <20170825170752.GB13937@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170825170752.GB13937@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: dm-devel.ids

On Sat, Aug 26, 2017 at 01:07:53AM +0800, Ming Lei wrote:
> On Fri, Aug 25, 2017 at 12:32:33PM -0400, Mike Snitzer wrote:
> > On Fri, Aug 25 2017 at 12:08pm -0400,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > On Fri, Aug 25, 2017 at 11:48:39AM -0400, Mike Snitzer wrote:
> > > > On Fri, Aug 25 2017 at 11:27am -0400,
> > > > Ming Lei <ming.lei@redhat.com> wrote:
> > > > 
> > > > > We don't need to update orignal dm request partially
> > > > > when ending each cloned bio, and this patch just
> > > > > updates orignal dm request once when the whole
> > > > > cloned request is finished.
> > > > > 
> > > > > Partial request update can be a bit expensive, so
> > > > > we should try to avoid it, especially it is run
> > > > > in softirq context.
> > > > > 
> > > > > After this patch is applied, both hard lockup and
> > > > > soft lockup aren't reproduced any more in one hour
> > > > > of running Laurence's test[1] on IB/SRP. Without
> > > > > this patch, the lockup can be reproduced in several
> > > > > minutes.
> > > > > 
> > > > > BTW, after d4acf3650c7c(block: Make blk_mq_delay_kick_requeue_list()
> > > > > rerun the queue at a quiet time), we need to make the
> > > > > test more aggressive for reproducing the lockup:
> > > > > 
> > > > > 	1) run hammer_write.sh 32 or 64 concurrently.
> > > > > 	2) write 8M each time
> > > > > 
> > > > > [1] https://marc.info/?l=linux-block&m=150220185510245&w=2
> > > > 
> > > > Bart said he cannot reproduce the lockups with his patchset applied.
> > > > Have you tested using Bart's patchset?
> > > 
> > > d4acf3650c7c(block: Make blk_mq_delay_kick_requeue_list() rerun the
> > > queue at a quiet time) has been in linus tree.
> > > 
> > > For other patches, I didn't test it yet. Because every time
> > > when the lockup is triggered, it is always in blk_recalc_rq_segments(),
> > > and not see any patch is dealing with that.
> > 
> > Please test with all of Bart's patches applied!
> 
> Just done the test with Bart's patch, still can
> see soft lockup when running the test described

Looks no difference, hard lockup can be observed too 
following soft lockup after a while with Bart's patch.

-- 
Ming
