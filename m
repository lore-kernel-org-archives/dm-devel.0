From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] block: neutralize blk_insert_cloned_request IO stall
 regression (was: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes
 idle)
Date: Tue, 23 Jan 2018 10:22:04 +0100
Message-ID: <20180123092204.GA39002@redhat.com>
References: <1516296056.2676.23.camel@wdc.com>
 <20180118183039.GA20121@redhat.com>
 <1516301278.2676.35.camel@wdc.com>
 <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
 <20180118204856.GA31679@redhat.com>
 <1516309128.2676.38.camel@wdc.com>
 <20180118212327.GB31679@redhat.com>
 <1516311554.2676.50.camel@wdc.com>
 <20180118220132.GA20860@redhat.com>
 <1516314012.2676.76.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516314012.2676.76.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, axboe@kernel.dk, ming.lei@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

On Thu, Jan 18 2018 at  5:20pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Thu, 2018-01-18 at 17:01 -0500, Mike Snitzer wrote:
> > And yet Laurence cannot reproduce any such lockups with your test...
> 
> Hmm ... maybe I misunderstood Laurence but I don't think that Laurence has
> already succeeded at running an unmodified version of my tests. In one of the
> e-mails Laurence sent me this morning I read that he modified these scripts
> to get past a kernel module unload failure that was reported while starting
> these tests. So the next step is to check which changes were made to the test
> scripts and also whether the test results are still valid.
> 
> > Are you absolutely certain this patch doesn't help you?
> > https://patchwork.kernel.org/patch/10174037/
> > 
> > If it doesn't then that is actually very useful to know.
> 
> The first I tried this morning is to run the srp-test software against a merge
> of Jens' for-next branch and your dm-4.16 branch. Since I noticed that the dm
> queue locked up I reinserted a blk_mq_delay_run_hw_queue() call in the dm code.
> Since even that was not sufficient I tried to kick the queues via debugfs (for
> s in /sys/kernel/debug/block/*/state; do echo kick >$s; done). Since that was
> not sufficient to resolve the queue stall I reverted the following tree patches
> that are in Jens' tree:
> * "blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback"
> * "blk-mq-sched: remove unused 'can_block' arg from blk_mq_sched_insert_request"
> * "blk-mq: don't dispatch request in blk_mq_request_direct_issue if queue is busy"
> 
> Only after I had done this the srp-test software ran again without triggering
> dm queue lockups.

Given that Ming's notifier-based patchset needs more development time I
think we're unfortunately past the point where we can comfortably wait
for that to be ready.

So we need to explore alternatives to fixing this IO stall regression.
Rather than attempt the above block reverts (which is an incomplete
listing given newer changes): might we develop a more targeted code
change to neutralize commit 396eaf21ee ("blk-mq: improve DM's blk-mq IO
merging via blk_insert_cloned_request feedback")? -- which, given Bart's
findings above, seems to be the most problematic block commit.

To that end, assuming I drop this commit from dm-4.16:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=316a795ad388e0c3ca613454851a28079d917a92

Here is my proposal for putting this regression behind us for 4.16
(Ming's line of development would continue and hopefully be included in
4.17):

From: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 23 Jan 2018 09:40:22 +0100
Subject: [PATCH] block: neutralize blk_insert_cloned_request IO stall regression

The series of blk-mq changes intended to improve sequential IO
performace (through improved merging with dm-mapth blk-mq stacked on
underlying blk-mq device).  Unfortunately these changes have caused
dm-mpath blk-mq IO stalls when blk_mq_request_issue_directly()'s call to
q->mq_ops->queue_rq() fails (due to device-specific resource
unavailability).

Fix this by reverting back to how blk_insert_cloned_request() functioned
prior to commit 396eaf21ee -- by using blk_mq_request_bypass_insert()
instead of blk_mq_request_issue_directly().

In the future, this commit should be reverted as the first change in a
followup series of changes that implements a comprehensive solution to
allowing an underlying blk-mq queue's resource limitation to trigger the
upper blk-mq queue to run once that underlying limited resource is
replenished.

Fixes: 396eaf21ee ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index cdae69be68e9..a224f282b4a6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2520,7 +2520,8 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
 		 * bypass a potential scheduler on the bottom device for
 		 * insert.
 		 */
-		return blk_mq_request_issue_directly(rq);
+		blk_mq_request_bypass_insert(rq, true);
+		return BLK_STS_OK;
 	}
 
 	spin_lock_irqsave(q->queue_lock, flags);
-- 
2.15.0
