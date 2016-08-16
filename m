From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: v4.8 dm-mpath
Date: Tue, 16 Aug 2016 15:12:42 -0400
Message-ID: <20160816191241.GA16948@redhat.com>
References: <afa6895b-7301-2856-a68e-eaf81bde311b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <afa6895b-7301-2856-a68e-eaf81bde311b@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 16 2016 at  1:32pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Hello Mike,
> 
> If I trigger failover and failback with kernel v4.8-rc2 and ib_srp then I
> see the following:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
> IP: [<ffffffff8130d03b>] blk_mq_insert_request+0x3b/0xc0
> CPU: 4 PID: 12606 Comm: kdmwork-254:1 Not tainted 4.8.0-rc2-dbg+ #1
> Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
> task: ffff880363d3e240 task.stack: ffff8803618ac000
> RIP: 0010:[<ffffffff8130d03b>]  [<ffffffff8130d03b>] blk_mq_insert_request+0x3b/0xc0
> Call Trace:
>  [<ffffffff81300da9>] blk_insert_cloned_request+0xa9/0x1e0
>  [<ffffffffa04302f0>] map_request+0x190/0x2d0 [dm_mod]
>  [<ffffffffa043044d>] map_tio_request+0x1d/0x40 [dm_mod]
>  [<ffffffff81087101>] kthread_worker_fn+0xd1/0x1b0
>  [<ffffffff81086fba>] kthread+0xea/0x100
>  [<ffffffff8162d53f>] ret_from_fork+0x1f/0x40
> 
> (gdb) list *(blk_mq_insert_request+0x3b)
> 0xffffffff8130d03b is in blk_mq_insert_request (block/blk-mq.c:1078).
> 1073            struct request_queue *q = rq->q;
> 1074            struct blk_mq_hw_ctx *hctx;
> 1075            struct blk_mq_ctx *ctx = rq->mq_ctx, *current_ctx;
> 1076
> 1077            current_ctx = blk_mq_get_ctx(q);
> 1078            if (!cpu_online(ctx->cpu))
> 1079                    rq->mq_ctx = ctx = current_ctx;
> 1080
> 1081            hctx = q->mq_ops->map_queue(q, ctx->cpu);
> 1082
> (gdb) print &((struct blk_mq_ctx*)0)->cpu
> $1 = (unsigned int *) 0x80
> 
> I think this means that ctx->cpu == NULL was hit.
> 
> This was observed with the same test software and configuration I
> used for my kernel v4.7 tests (CONFIG_SCSI_MQ_DEFAULT=y and
> CONFIG_DM_MQ_DEFAULT=n).
> 
> The above callstack was not observed while testing kernel v4.7.

I only applied the 3 patches that I asked you to include in your v4.7
kernel(s), which I made available with this branch:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.7-mpath-fixes

Could be that something changed in v4.8 block core's blk-mq code that
needs to be taken into account, we'll see.

> Can you have a look at this?

I'll get linux-dm.git's 'dm-4.8' branch (v4.8-rc2) loaded on one of my
testbed systems to run the mptest testsuite.  It should provide coverage
for simple failover and failback.
