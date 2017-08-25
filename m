From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-rq: do not update rq partially in each ending bio
Date: Fri, 25 Aug 2017 13:57:22 -0400
Message-ID: <20170825175722.GA2298@redhat.com>
References: <20170825152749.14435-1-ming.lei@redhat.com>
	<20170825154839.GA1695@redhat.com>
	<20170825160850.GA13937@ming.t460p>
	<20170825163233.GB1900@redhat.com>
	<20170825170752.GB13937@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170825170752.GB13937@ming.t460p>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 25 2017 at  1:07pm -0400,
Ming Lei <ming.lei@redhat.com> wrote:

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
> in commit log for a couple of minutes. BTW, my
> test is much more aggressive than Laurence's, I
> write 8M each time, and run 64 hammer_write.sh
> concurrently.

OK, thanks for verifying as much.
 
> I don't think the two are contradictory. Anyway,
> this patch will decrease CPU utilization of SOFTIRQ, and
> it is a improvement.

OK, looking closer I can see you accomplish the same (retaining partial
completion) in a more optimal way.

I'll include this in my review/staging of dm-multipath patches for 4.14.

Thanks,
Mike
