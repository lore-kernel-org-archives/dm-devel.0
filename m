From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH] dm: fix excessive dm-mq context switching
Date: Fri, 5 Feb 2016 10:13:35 -0500
Message-ID: <20160205151334.GA82754@redhat.com>
References: <20160127174828.GA31802@redhat.com>
	<56A904B6.50407@dev.mellanox.co.il>
	<20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
	<20160203180406.GA11591@redhat.com>
	<20160203182423.GA12913@redhat.com> <56B2F5BC.1010700@suse.de>
	<20160204135420.GA18227@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160204135420.GA18227@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@infradead.org>
Cc: "keith.busch@intel.com" <keith.busch@intel.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Thu, Feb 04 2016 at  8:54P -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Feb 04 2016 at  1:54am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
> 
> > On 02/03/2016 07:24 PM, Mike Snitzer wrote:
> > > On Wed, Feb 03 2016 at  1:04pm -0500,
> > > Mike Snitzer <snitzer@redhat.com> wrote:
> > >  
> > >> I'm still not clear on where the considerable performance loss is coming
> > >> from (on null_blk device I see ~1900K read IOPs but I'm still only
> > >> seeing ~1000K read IOPs when blk-mq DM-multipath is layered ontop).
> > >> What is very much apparent is: layering dm-mq multipath ontop of null_blk
> > >> results in a HUGE amount of additional context switches.  I can only
> > >> infer that the request completion for this stacked device (blk-mq queue
> > >> ontop of blk-mq queue, with 2 completions: 1 for clone completing on
> > >> underlying device and 1 for original request completing) is the reason
> > >> for all the extra context switches.
> > > 
> > > Starts to explain, certainly not the "reason"; that is still very much
> > > TBD...
> > > 
> > >> Here are pictures of 'perf report' for perf datat collected using
> > >> 'perf record -ag -e cs'.
> > >>
> > >> Against null_blk:
> > >> http://people.redhat.com/msnitzer/perf-report-cs-null_blk.png
> > > 
> > > if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=1
> > >   cpu          : usr=25.53%, sys=74.40%, ctx=1970, majf=0, minf=474
> > > if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=4
> > >   cpu          : usr=26.79%, sys=73.15%, ctx=2067, majf=0, minf=479
> > > 
> > >> Against dm-mpath ontop of the same null_blk:
> > >> http://people.redhat.com/msnitzer/perf-report-cs-dm_mq.png
> > > 
> > > if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=1
> > >   cpu          : usr=11.07%, sys=33.90%, ctx=667784, majf=0, minf=466
> > > if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=4
> > >   cpu          : usr=15.22%, sys=48.44%, ctx=2314901, majf=0, minf=466
> > > 
> > > So yeah, the percentages reflected in these respective images didn't do
> > > the huge increase in context switches justice... we _must_ figure out
> > > why we're seeing so many context switches with dm-mq.
> > > 
> > Well, the most obvious one being that you're using 1 dm-mq queue vs
> > 4 null_blk queues.
> > So you will have have to do an additional context switch for 75% of
> > the total I/Os submitted.
> 
> Right, that case is certainly prone to more context switches.  But I'm
> initially most concerned about the case where both only have 1 queue.
> 
> > Have you tested with 4 dm-mq hw queues?
> 
> Yes, it makes performance worse.  This is likely rooted in dm-mpath IO
> path not being lockless.  But I also have concern about whether the
> clone, sent to the underlying path, is completing on a different cpu
> than dm-mq's original request.
> 
> I'll be using ftrace to try to dig into the various aspects of this
> (perf, as I know how to use it, isn't giving me enough precision in its
> reporting).
> 
> > To avoid context switches we would have to align the dm-mq queues to
> > the underlying blk-mq layout for the paths.
> 
> Right, we need to take more care (how remains TBD).  But for now I'm
> just going to focus on the case where both dm-mq and null_blk have 1 for
> nr_hw_queues.  As you can see even in that config the number of context
> switches goes from 1970 to 667784 (and there is a huge loss of system
> cpu utilization) once dm-mq w/ 1 hw_queue is stacked ontop on the
> null_blk device.
> 
> Once we understand the source of all the additional context switching
> for this more simplistic stacked configuration we can look closer at
> scaling as we add more underlying paths.

Following is RFC because it really speaks to dm-mq _needing_ a variant
of blk_mq_complete_request() that supports partial completions.  Not
supporting partial completions really isn't an option for DM multipath.

From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 5 Feb 2016 08:49:01 -0500
Subject: [RFC PATCH] dm: fix excessive dm-mq context switching

Request-based DM's blk-mq support (dm-mq) was reported to be 50% slower
than if an underlying null_blk device were used directly.  This biggest
reason for this drop in performance is that blk_insert_clone_request()
was calling blk_mq_insert_request() with @async=true.  This forced the
use of kblockd_schedule_delayed_work_on() to run the queues which
ushered in ping-ponging between process context (fio in this case) and
kblockd's kworker to submit the cloned request.  The ftrace
function_graph tracer showed:

  kworker-2013  =>   fio-12190
  fio-12190    =>  kworker-2013
  ...
  kworker-2013  =>   fio-12190
  fio-12190    =>  kworker-2013
  ...

Fixing blk_mq_insert_request() to _not_ use kblockd to submit the cloned
requests isn't enough to fix eliminated the oberved context switches.

In addition to this dm-mq specific blk-core fix, there were 2 DM core
fixes to dm-mq that (when paired with the blk-core fix) completely
eliminate the observed context switching:

1)  don't blk_mq_run_hw_queues in blk-mq request completion

    Motivated by desire to reduce overhead of dm-mq, punting to kblockd
    just increases context switches.

    In my testing against a really fast null_blk device there was no benefit
    to running blk_mq_run_hw_queues() on completion (and no other blk-mq
    driver does this).  So hopefully this change doesn't induce the need for
    yet another revert like commit 621739b00e16ca2d !

2)  use blk_mq_complete_request() in dm_complete_request()

    blk_complete_request() doesn't offer the traditional q->mq_ops vs
    .request_fn branching pattern that other historic block interfaces
    do (e.g. blk_get_request).  Using blk_mq_complete_request() for
    blk-mq requests is important for performance but it doesn't handle
    partial completions -- which is a pretty big problem given the
    potential for partial completions with DM multipath due to path
    failure(s).  As such this makes this entire patch only RFC-worthy.

dm-mq "fix" #2 is _much_ more important than #1 for eliminating the
excessive context switches.
Before: cpu          : usr=15.10%, sys=59.39%, ctx=7905181, majf=0, minf=475
After:  cpu          : usr=20.60%, sys=79.35%, ctx=2008, majf=0, minf=472

With these changes the multithreaded async read IOPs improved from ~950K
to ~1350K for this dm-mq stacked on null_blk test-case.  The raw read
IOPs of the underlying null_blk device for the same workload is ~1950K.

Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |  2 +-
 drivers/md/dm.c  | 13 ++++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ab51685..c60e233 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2198,7 +2198,7 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	if (q->mq_ops) {
 		if (blk_queue_io_stat(q))
 			blk_account_io_start(rq, true);
-		blk_mq_insert_request(rq, false, true, true);
+		blk_mq_insert_request(rq, false, true, false);
 		return 0;
 	}
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c683f6d..a618477 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1119,12 +1119,8 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 	 * back into ->request_fn() could deadlock attempting to grab the
 	 * queue lock again.
 	 */
-	if (run_queue) {
-		if (md->queue->mq_ops)
-			blk_mq_run_hw_queues(md->queue, true);
-		else
-			blk_run_queue_async(md->queue);
-	}
+	if (!md->queue->mq_ops && run_queue)
+		blk_mq_run_hw_queues(md->queue, true);
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
@@ -1344,7 +1340,10 @@ static void dm_complete_request(struct request *rq, int error)
 	struct dm_rq_target_io *tio = tio_from_request(rq);
 
 	tio->error = error;
-	blk_complete_request(rq);
+	if (!rq->q->mq_ops)
+		blk_complete_request(rq);
+	else
+		blk_mq_complete_request(rq, rq->errors);
 }
 
 /*
-- 
2.5.4 (Apple Git-61)
