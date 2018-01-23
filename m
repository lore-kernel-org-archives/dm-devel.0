From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] block: neutralize blk_insert_cloned_request IO stall
 regression (was: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes
 idle)
Date: Tue, 23 Jan 2018 18:53:58 +0800
Message-ID: <20180123105357.GA3344@ming.t460p>
References: <20180118183039.GA20121@redhat.com>
 <1516301278.2676.35.camel@wdc.com>
 <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
 <20180118204856.GA31679@redhat.com>
 <1516309128.2676.38.camel@wdc.com>
 <20180118212327.GB31679@redhat.com>
 <1516311554.2676.50.camel@wdc.com>
 <20180118220132.GA20860@redhat.com>
 <1516314012.2676.76.camel@wdc.com>
 <20180123092204.GA39002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180123092204.GA39002@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, axboe@kernel.dk, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

Hi Mike,

On Tue, Jan 23, 2018 at 10:22:04AM +0100, Mike Snitzer wrote:
> On Thu, Jan 18 2018 at  5:20pm -0500,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
> > On Thu, 2018-01-18 at 17:01 -0500, Mike Snitzer wrote:
> > > And yet Laurence cannot reproduce any such lockups with your test...
> > 
> > Hmm ... maybe I misunderstood Laurence but I don't think that Laurence has
> > already succeeded at running an unmodified version of my tests. In one of the
> > e-mails Laurence sent me this morning I read that he modified these scripts
> > to get past a kernel module unload failure that was reported while starting
> > these tests. So the next step is to check which changes were made to the test
> > scripts and also whether the test results are still valid.
> > 
> > > Are you absolutely certain this patch doesn't help you?
> > > https://patchwork.kernel.org/patch/10174037/
> > > 
> > > If it doesn't then that is actually very useful to know.
> > 
> > The first I tried this morning is to run the srp-test software against a merge
> > of Jens' for-next branch and your dm-4.16 branch. Since I noticed that the dm
> > queue locked up I reinserted a blk_mq_delay_run_hw_queue() call in the dm code.
> > Since even that was not sufficient I tried to kick the queues via debugfs (for
> > s in /sys/kernel/debug/block/*/state; do echo kick >$s; done). Since that was
> > not sufficient to resolve the queue stall I reverted the following tree patches
> > that are in Jens' tree:
> > * "blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback"
> > * "blk-mq-sched: remove unused 'can_block' arg from blk_mq_sched_insert_request"
> > * "blk-mq: don't dispatch request in blk_mq_request_direct_issue if queue is busy"
> > 
> > Only after I had done this the srp-test software ran again without triggering
> > dm queue lockups.
> 
> Given that Ming's notifier-based patchset needs more development time I
> think we're unfortunately past the point where we can comfortably wait
> for that to be ready.
> 
> So we need to explore alternatives to fixing this IO stall regression.

The fix for IO stall doesn't need the notifier-based patchset, and only
the 1st patch is enough for fixing the IO stall. And it is a generic
issue, which need generic solution, that is the conclusion made by
Jens and me.

	https://marc.info/?l=linux-kernel&m=151638176727612&w=2

And the notifier-based patchset is for solving the performance issue
reported by Jens:

	- run IO on dm-mpath
	- run background IO on low depth underlying queue
	- then IO performance on dm-mpath is extremely slow

I will send out the 1st patch of 'blk-mq: introduce BLK_STS_DEV_RESOURCE'
soon, but the notifier-based patchset shouldn't be very urgent, since
the above test case isn't usual in reality.

> Rather than attempt the above block reverts (which is an incomplete
> listing given newer changes): might we develop a more targeted code
> change to neutralize commit 396eaf21ee ("blk-mq: improve DM's blk-mq IO
> merging via blk_insert_cloned_request feedback")? -- which, given Bart's
> findings above, seems to be the most problematic block commit.

The stall isn't related with commit 396eaf21ee too.

> 
> To that end, assuming I drop this commit from dm-4.16:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=316a795ad388e0c3ca613454851a28079d917a92
> 
> Here is my proposal for putting this regression behind us for 4.16
> (Ming's line of development would continue and hopefully be included in
> 4.17):

Actually notifier based approach is ready, even cache for clone is ready
too, but the test result isn't good enough on random IO on Jens's above
case, and sequential IO is much better with both cache clone and
notifier based allocation(much better than non-mq). And follows the tree
if anyone is interested:

https://github.com/ming1/linux/commits/v4.15-rc-block-dm-mpath

Now looks there is still one issue: the notifier can come early, just
before the request is added to hctx->dispatch_list, and performance
still gets hurt, especially on random IO in Jens's case. But queue
won't stall, :-)

> 
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Tue, 23 Jan 2018 09:40:22 +0100
> Subject: [PATCH] block: neutralize blk_insert_cloned_request IO stall regression
> 
> The series of blk-mq changes intended to improve sequential IO
> performace (through improved merging with dm-mapth blk-mq stacked on
> underlying blk-mq device).  Unfortunately these changes have caused
> dm-mpath blk-mq IO stalls when blk_mq_request_issue_directly()'s call to
> q->mq_ops->queue_rq() fails (due to device-specific resource
> unavailability).
> 
> Fix this by reverting back to how blk_insert_cloned_request() functioned
> prior to commit 396eaf21ee -- by using blk_mq_request_bypass_insert()
> instead of blk_mq_request_issue_directly().
> 
> In the future, this commit should be reverted as the first change in a
> followup series of changes that implements a comprehensive solution to
> allowing an underlying blk-mq queue's resource limitation to trigger the
> upper blk-mq queue to run once that underlying limited resource is
> replenished.
> 
> Fixes: 396eaf21ee ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index cdae69be68e9..a224f282b4a6 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2520,7 +2520,8 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
>  		 * bypass a potential scheduler on the bottom device for
>  		 * insert.
>  		 */
> -		return blk_mq_request_issue_directly(rq);
> +		blk_mq_request_bypass_insert(rq, true);
> +		return BLK_STS_OK;
>  	}

If this patch is for fixing IO stall on DM, it isn't needed, and actually
it can't fix the IO stall issue.

-- 
Ming
