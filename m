From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Revert "dm mpath: remove unnecessary NVMe branching
 in favor of scsi_dh checks"
Date: Mon, 12 Mar 2018 17:23:14 -0400
Message-ID: <20180312212314.GA30763@redhat.com>
References: <20180312202808.3556-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180312202808.3556-1-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


On Mon, Mar 12 2018 at  4:28pm -0400,
Bart Van Assche <bart.vanassche@wdc.com> wrote:

> This patch fixes the following kernel crash:
> 
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> CPU: 1 PID: 155 Comm: kworker/1:1H Not tainted 4.16.0-rc5-dbg+ #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> Workqueue: kblockd blk_mq_run_work_fn
> Call Trace:
>  dump_stack+0x85/0xc7
>  register_lock_class+0x82a/0x830
>  __lock_acquire+0x141/0x1b10
>  lock_acquire+0xc9/0x260
>  _raw_spin_lock_irqsave+0x41/0x50
>  __wake_up_common_lock+0x9e/0x100
>  pg_init_done+0x100/0x240 [dm_multipath]
>  multipath_clone_and_map+0x32c/0x340 [dm_multipath]
>  map_request+0xc1/0x550 [dm_mod]
>  dm_mq_queue_rq+0xf9/0x1a0 [dm_mod]
>  blk_mq_dispatch_rq_list+0x143/0xac0
>  blk_mq_sched_dispatch_requests+0x23d/0x2f0
>  __blk_mq_run_hw_queue+0xdb/0x160
>  process_one_work+0x441/0xa50
>  worker_thread+0x76/0x6c0
>  kthread+0x1b2/0x1d0
>  ret_from_fork+0x24/0x30
> ==================================================================
> BUG: KASAN: null-ptr-deref in __wake_up_common+0x60/0x230
> Read of size 8 at addr 0000000000000000 by task kworker/1:1H/155
> 
> CPU: 1 PID: 155 Comm: kworker/1:1H Not tainted 4.16.0-rc5-dbg+ #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> Workqueue: kblockd blk_mq_run_work_fn
> Call Trace:
>  dump_stack+0x85/0xc7
>  kasan_report+0x139/0x350
>  __wake_up_common+0x60/0x230
>  __wake_up_common_lock+0xb9/0x100
>  pg_init_done+0x100/0x240 [dm_multipath]
>  multipath_clone_and_map+0x32c/0x340 [dm_multipath]
>  map_request+0xc1/0x550 [dm_mod]
>  dm_mq_queue_rq+0xf9/0x1a0 [dm_mod]
>  blk_mq_dispatch_rq_list+0x143/0xac0
>  blk_mq_sched_dispatch_requests+0x23d/0x2f0
>  __blk_mq_run_hw_queue+0xdb/0x160
>  process_one_work+0x441/0xa50
>  worker_thread+0x76/0x6c0
>  kthread+0x1b2/0x1d0
>  ret_from_fork+0x24/0x30
> ==================================================================
> 
> Fixes: 8d47e65948dd ("dm mpath: remove unnecessary NVMe branching in favor of scsi_dh checks")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>

Sorry for your troubles but reverting isn't the proper way to handle
this (yet).

Could you provide more details on your setup?

Obviously you're using "queue_mode mq", what are your underlying paths?

Given the trace it would seem you're hitting multipath_clone_and_map()'s
blk_queue_dying(q) error path that calls activate_or_offline_path().

Would be useful to know the crash utility's output for:
dis -l pg_init_done+0x100

But I'd imagine it isn't happy here:
 wake_up(&m->pg_init_wait);

Given the commit in question, I am assuming there is something about
this setup_scsi_dh() code that is causing m->pg_init_wait to not be
initialized:

                        /*
                         * Init fields that are only used when a scsi_dh is attached
                         */
                        if (!test_and_set_bit(MPATHF_QUEUE_IO, &m->flags)) {
                                atomic_set(&m->pg_init_in_progress, 0);
                                atomic_set(&m->pg_init_count, 0);
                                m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
                                init_waitqueue_head(&m->pg_init_wait);
                        }

Wonder if having made that initialization conditional is the
culprit... that was needed because setup_scsi_dh() is called multiple
times now.  Whereas before this commit it was only done once as part of
the initial multipath table load (in alloc_multipath_stage2).

I'll keep looking at this.

Mike
