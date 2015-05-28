From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix false alarm in free_rq_clone() for non
	blk-mq target
Date: Thu, 28 May 2015 15:14:57 -0400
Message-ID: <20150528191457.GA26218@redhat.com>
References: <5566CAE8.4070404@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5566CAE8.4070404@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, May 28 2015 at  3:59am -0400,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> When stacking request-based dm device on non blk-mq device
> and device-mapper target could not map the request
> (error target is used, multipath target with all paths down, etc),
> following warning will show up once:
> 
>   WARNING: CPU: 7 PID: 0 at drivers/md/dm.c:1090 free_rq_clone+0x7a/0xf0
>   CPU: 7 PID: 0 Comm: swapper/7 Not tainted 4.1.0-rc5+ #1
>   ..
>   Call Trace:
>    <IRQ>  [<ffffffff81558095>] dump_stack+0x45/0x57
>    [<ffffffff8105ef3a>] warn_slowpath_common+0x8a/0xc0
>    [<ffffffff8105f02a>] warn_slowpath_null+0x1a/0x20
>    [<ffffffffa020bf3a>] free_rq_clone+0x7a/0xf0 [dm_mod]
>    [<ffffffffa020c7cc>] dm_softirq_done+0x13c/0x250 [dm_mod]
>    [<ffffffff812b87a0>] blk_done_softirq+0x80/0xa0
>    [<ffffffff81062f44>] __do_softirq+0xf4/0x2d0
>    [<ffffffff81063425>] irq_exit+0x125/0x130
>    [<ffffffff81037f05>] smp_call_function_single_interrupt+0x35/0x40
>    [<ffffffff8156027e>] call_function_single_interrupt+0x6e/0x80
>    <EOI>  [<ffffffff8104b576>] ? native_safe_halt+0x6/0x10
>    [<ffffffff810b6348>] ? rcu_eqs_enter+0x68/0x90
>    [<ffffffff8100d6fe>] default_idle+0x1e/0xc0
>    [<ffffffff8100e1df>] arch_cpu_idle+0xf/0x20
>    [<ffffffff810a269c>] cpu_startup_entry+0x2fc/0x3a0
>    [<ffffffff81038892>] start_secondary+0x182/0x1b0
> 
> The warning was added by commit aa6df8dd28c0 ("dm: fix free_rq_clone()
> NULL pointer when requeueing unmapped request").
> 
> But free_rq_clone() with clone->q == NULL is valid usage for non blk-mq
> underlying device. Such a call can happen via dm_kill_unmapped_request().

dm_kill_unmapped_request() is called from the blk-mq error path too
(e.g. if clone_and_map_rq fails with an error).  So this isn't non
blk-mq specific.

dm_kill_unmapped_request() sets REQ_FAILED, which dm_softirq_done()
checks for and will set 'mapped' to false.  I think a proper fix is to
pass 'mapped' into dm_end_request() and then pass it to free_rq_clone().
Like so, what do you think?

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1badfb2..17f1d0e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1112,7 +1112,7 @@ static void free_rq_clone(struct request *clone, bool must_be_mapped)
  * Must be called without clone's queue lock held,
  * see end_clone_request() for more details.
  */
-static void dm_end_request(struct request *clone, int error)
+static void dm_end_request(struct request *clone, int error, bool mapped)
 {
 	int rw = rq_data_dir(clone);
 	struct dm_rq_target_io *tio = clone->end_io_data;
@@ -1132,7 +1132,7 @@ static void dm_end_request(struct request *clone, int error)
 			rq->sense_len = clone->sense_len;
 	}
 
-	free_rq_clone(clone, true);
+	free_rq_clone(clone, mapped);
 	if (!rq->q->mq_ops)
 		blk_end_request_all(rq, error);
 	else
@@ -1249,7 +1249,7 @@ static void dm_done(struct request *clone, int error, bool mapped)
 
 	if (r <= 0)
 		/* The target wants to complete the I/O */
-		dm_end_request(clone, r);
+		dm_end_request(clone, r, mapped);
 	else if (r == DM_ENDIO_INCOMPLETE)
 		/* The target will handle the I/O */
 		return;
