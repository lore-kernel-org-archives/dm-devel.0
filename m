From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Fri, 19 Dec 2014 10:38:02 -0500
Message-ID: <20141219153801.GA8697@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
	<alpine.LNX.2.00.1412172133240.4026@localhost.lm.intel.com>
	<5491F906.1090004@kernel.dk> <20141217230622.GC15390@redhat.com>
	<54943714.2040704@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54943714.2040704@acm.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, hch@infradead.org, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

On Fri, Dec 19 2014 at  9:32am -0500,
Bart Van Assche <bvanassche@acm.org> wrote:

> On 12/18/14 00:06, Mike Snitzer wrote:
> > So if you know someone with relevant blk-mq hardware who might benefit
> > from blk-mq multipathing please point them at this code and have them
> > report back!
> 
> Hello Mike,
> 
> Great to see that you are working on blk-mq multipathing. Unfortunately
> a test with the SRP initiator and your dm-for-3.20-blk-mq tree merged
> with Linus' latest tree was not successful. This is what was reported
> when I tried to start multipathd (without call trace, followed by a
> hard lockup):
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 3.18.0-debug+ #1 Tainted: G        W     
> ---------------------------------------------------------
> kdmwork-253:0/5347 just changed the state of lock:
>  (&(&m->lock)->rlock){+.....}, at: [<ffffffffa080eb80>] __multipath_map.isra.15+0x40/0x1f0 [dm_multipath]
> but this lock was taken by another, HARDIRQ-safe lock in the past:
>  (&(&q->__queue_lock)->rlock){-.-...}
>  
> and interrupts could create inverse lock ordering between them.
>  
> other info that might help us debug this:
>  Possible interrupt unsafe locking scenario:

This "dm: submit stacked requests in irq enabled context" commit
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20-blk-mq&id=1844ba7e2e013fa38c45d646248c517eb363e26c

changed the locking needed in the multipath target.  I altered
__multipath_map but didn't audit elsewhere.  I'll work through it.

I rebuilt my kernel with lockdep enabled and can easily see this too:

[  181.819735] =========================================================
[  181.820046] [ INFO: possible irq lock inversion dependency detected ]
[  181.820046] 3.18.0+ #12 Tainted: G        W
[  181.820046] ---------------------------------------------------------
[  181.820046] swapper/1/0 just changed the state of lock:
[  181.820046]  (&(&q->__queue_lock)->rlock){..-...}, at: [<ffffffff812fb2c4>] blk_end_bidi_request+0x34/0x60
[  181.820046] but this lock took another, SOFTIRQ-unsafe lock in the past:
[  181.820046]  (&(&m->lock)->rlock){+.+...}

and interrupts could create inverse lock ordering between them.

[  181.820046]
[  181.820046] other info that might help us debug this:
[  181.820046]  Possible interrupt unsafe locking scenario:
[  181.820046]
[  181.820046]        CPU0                    CPU1
[  181.820046]        ----                    ----
[  181.820046]   lock(&(&m->lock)->rlock);
[  181.820046]                                local_irq_disable();
[  181.820046]                                lock(&(&q->__queue_lock)->rlock);
[  181.820046]                                lock(&(&m->lock)->rlock);
[  181.820046]   <Interrupt>
[  181.820046]     lock(&(&q->__queue_lock)->rlock);
[  181.820046]
[  181.820046]  *** DEADLOCK ***
[  181.820046]
[  181.820046] no locks held by swapper/1/0.
[  181.820046]
[  181.820046] the shortest dependencies between 2nd lock and 1st lock:
[  181.820046]  -> (&(&m->lock)->rlock){+.+...} ops: 4 {
[  181.820046]     HARDIRQ-ON-W at:
[  181.820046]                       [<ffffffff810c8f46>] __lock_acquire+0x5d6/0x1d40
[  181.820046]                       [<ffffffff810cae37>] lock_acquire+0xb7/0x140
[  181.820046]                       [<ffffffff81694618>] _raw_spin_lock+0x38/0x50
[  181.820046]                       [<ffffffffa00adbd0>] __multipath_map.isra.15+0x40/0x1f0 [dm_multipath]
[  181.820046]                       [<ffffffffa00add9a>] multipath_clone_and_map+0x1a/0x20 [dm_multipath]
[  181.820046]                       [<ffffffffa0206c25>] map_tio_request+0x1d5/0x2b0 [dm_mod]
[  181.820046]                       [<ffffffff8109a4ee>] kthread_worker_fn+0x7e/0x1b0
[  181.820046]                       [<ffffffff8109a3f7>] kthread+0x107/0x120
[  181.820046]                       [<ffffffff8169527c>] ret_from_fork+0x7c/0xb0
[  181.820046]     SOFTIRQ-ON-W at:
[  181.820046]                       [<ffffffff810c8ca0>] __lock_acquire+0x330/0x1d40
[  181.820046]                       [<ffffffff810cae37>] lock_acquire+0xb7/0x140
[  181.820046]                       [<ffffffff81694618>] _raw_spin_lock+0x38/0x50
[  181.820046]                       [<ffffffffa00adbd0>] __multipath_map.isra.15+0x40/0x1f0 [dm_multipath]
[  181.820046]                       [<ffffffffa00add9a>] multipath_clone_and_map+0x1a/0x20 [dm_multipath]
[  181.820046]                       [<ffffffffa0206c25>] map_tio_request+0x1d5/0x2b0 [dm_mod]
[  181.820046]                       [<ffffffff8109a4ee>] kthread_worker_fn+0x7e/0x1b0
[  181.820046]                       [<ffffffff8109a3f7>] kthread+0x107/0x120
[  181.820046]                       [<ffffffff8169527c>] ret_from_fork+0x7c/0xb0
[  181.820046]     INITIAL USE at:
[  181.820046]                      [<ffffffff810c8d2f>] __lock_acquire+0x3bf/0x1d40
[  181.820046]                      [<ffffffff810cae37>] lock_acquire+0xb7/0x140
[  181.820046]                      [<ffffffff81694f50>] _raw_spin_lock_irqsave+0x50/0x70
[  181.820046]                      [<ffffffffa00ac63c>] multipath_resume+0x1c/0x50 [dm_multipath]
[  181.820046]                      [<ffffffffa020bed9>] dm_table_resume_targets+0x99/0xe0 [dm_mod]
[  181.820046]                      [<ffffffffa0209289>] dm_resume+0xd9/0x120 [dm_mod]
[  181.820046]                      [<ffffffffa020e7bb>] dev_suspend+0x12b/0x250 [dm_mod]
[  181.820046]                      [<ffffffffa020f108>] ctl_ioctl+0x278/0x520 [dm_mod]
[  181.820046]                      [<ffffffffa020f3c3>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
[  181.820046]                      [<ffffffff81219488>] do_vfs_ioctl+0x318/0x560
[  181.820046]                      [<ffffffff81219751>] SyS_ioctl+0x81/0xa0
[  181.820046]                      [<ffffffff81695329>] system_call_fastpath+0x12/0x17
[  181.820046]   }
[  181.820046]   ... key      at: [<ffffffffa00b04a0>] __key.33455+0x0/0xffffffffffffeb60 [dm_multipath]
[  181.820046]   ... acquired at:
[  181.820046]    [<ffffffff810cae37>] lock_acquire+0xb7/0x140
[  181.820046]    [<ffffffff81694618>] _raw_spin_lock+0x38/0x50
[  181.820046]    [<ffffffffa020893d>] dm_blk_open+0x1d/0x90 [dm_mod]
[  181.820046]    [<ffffffff812416fe>] __blkdev_get+0xde/0x4e0
[  181.820046]    [<ffffffff81241cf8>] blkdev_get+0x1f8/0x3b0
[  181.820046]    [<ffffffff81241f6f>] blkdev_open+0x5f/0x90
[  181.820046]    [<ffffffff812014cf>] do_dentry_open+0x1ff/0x350
[  181.820046]    [<ffffffff81201789>] vfs_open+0x49/0x50
[  181.820046]    [<ffffffff81211cd2>] do_last+0x682/0x13b0
[  181.820046]    [<ffffffff81214535>] path_openat+0xc5/0x640
[  181.820046]    [<ffffffff81216b69>] do_filp_open+0x49/0xc0
[  181.820046]    [<ffffffff812033a7>] do_sys_open+0x137/0x240
[  181.820046]    [<ffffffff812034ce>] SyS_open+0x1e/0x20
[  181.820046]    [<ffffffff81695329>] system_call_fastpath+0x12/0x17
[  181.820046]
[  181.820046] -> (&(&q->__queue_lock)->rlock){..-...} ops: 71 {
[  181.820046]    IN-SOFTIRQ-W at:
[  181.820046]                     [<ffffffff810c8c25>] __lock_acquire+0x2b5/0x1d40
[  181.820046]                     [<ffffffff810cae37>] lock_acquire+0xb7/0x140
[  181.820046]                     [<ffffffff81694f50>] _raw_spin_lock_irqsave+0x50/0x70
[  181.820046]                     [<ffffffff812fb2c4>] blk_end_bidi_request+0x34/0x60
[  181.820046]                     [<ffffffff812fb3cf>] blk_end_request_all+0x1f/0x30
[  181.820046]                     [<ffffffffa0206359>] dm_softirq_done+0xe9/0x1e0 [dm_mod]
[  181.820046]                     [<ffffffff813023b0>] blk_done_softirq+0xa0/0xd0
[  181.820046]                     [<ffffffff8107e091>] __do_softirq+0x141/0x370
[  181.820046]                     [<ffffffff8107e655>] irq_exit+0x125/0x130
[  181.820046]                     [<ffffffff8104bd05>] smp_call_function_single_interrupt+0x35/0x40
[  181.820046]                     [<ffffffff81696822>] call_function_single_interrupt+0x72/0x80
[  181.820046]                     [<ffffffff810c0084>] cpu_startup_entry+0x194/0x420
[  181.820046]                     [<ffffffff8104c6dd>] start_secondary+0x19d/0x210
[  181.820046]    INITIAL USE at:
[  181.820046]                    [<ffffffff810c8d2f>] __lock_acquire+0x3bf/0x1d40
[  181.820046]                    [<ffffffff810cae37>] lock_acquire+0xb7/0x140
[  181.820046]                    [<ffffffff81694764>] _raw_spin_lock_irq+0x44/0x60
[  181.820046]                    [<ffffffff812f998d>] blk_queue_bypass_start+0x1d/0xb0
[  181.820046]                    [<ffffffff813168c6>] blkcg_activate_policy+0x96/0x340
[  181.820046]                    [<ffffffff8131a04e>] blk_throtl_init+0xee/0x130
[  181.820046]                    [<ffffffff81316c01>] blkcg_init_queue+0x31/0x40
[  181.820046]                    [<ffffffff812f6551>] blk_alloc_queue_node+0x251/0x2c0
[  181.820046]                    [<ffffffff812fa854>] blk_init_queue_node+0x24/0x70
[  181.820046]                    [<ffffffff812fa8b3>] blk_init_queue+0x13/0x20
[  181.820046]                    [<ffffffffa0015364>] virtqueue_get_buf+0x14/0x130 [virtio_ring]
[  181.820046]                    [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[  181.820046]                    [<ffffffff8110b4e2>] load_module+0x17d2/0x1c10
[  181.820046]                    [<ffffffff8110baf6>] SyS_finit_module+0xa6/0xd0
[  181.820046]                    [<ffffffff81695329>] system_call_fastpath+0x12/0x17
[  181.820046]  }
[  181.820046]  ... key      at: [<ffffffff82c21ec0>] __key.42329+0x0/0x8
[  181.820046]  ... acquired at:
[  181.820046]    [<ffffffff810c7909>] check_usage_forwards+0x199/0x1b0
[  181.820046]    [<ffffffff810c81e1>] mark_lock+0x1a1/0x2a0
[  181.820046]    [<ffffffff810c8c25>] __lock_acquire+0x2b5/0x1d40
[  181.820046]    [<ffffffff810cae37>] lock_acquire+0xb7/0x140
[  181.820046]    [<ffffffff81694f50>] _raw_spin_lock_irqsave+0x50/0x70
[  181.820046]    [<ffffffff812fb2c4>] blk_end_bidi_request+0x34/0x60
[  181.820046]    [<ffffffff812fb3cf>] blk_end_request_all+0x1f/0x30
[  181.820046]    [<ffffffffa0206359>] dm_softirq_done+0xe9/0x1e0 [dm_mod]
[  181.820046]    [<ffffffff813023b0>] blk_done_softirq+0xa0/0xd0
[  181.820046]    [<ffffffff8107e091>] __do_softirq+0x141/0x370
[  181.820046]    [<ffffffff8107e655>] irq_exit+0x125/0x130
[  181.820046]    [<ffffffff8104bd05>] smp_call_function_single_interrupt+0x35/0x40
[  181.820046]    [<ffffffff81696822>] call_function_single_interrupt+0x72/0x80
[  181.820046]    [<ffffffff810c0084>] cpu_startup_entry+0x194/0x420
[  181.820046]    [<ffffffff8104c6dd>] start_secondary+0x19d/0x210
[  181.820046]
[  181.820046]
[  181.820046] stack backtrace:
[  181.820046] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W      3.18.0+ #12
[  181.820046] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  181.820046]  0000000000000000 79d40dcd9747394f ffff88011fc83b68 ffffffff8168b840
[  181.820046]  0000000000000000 ffffffff828b2340 ffff88011fc83bb8 ffffffff81685d9f
[  181.820046]  ffff88011fc83be0 ffffffff818d58f4 ffff88011fc83bd4 0000000000000000
[  181.820046] Call Trace:
[  181.820046]  <IRQ>  [<ffffffff8168b840>] dump_stack+0x4c/0x65
[  181.820046]  [<ffffffff81685d9f>] print_irq_inversion_bug.part.37+0x1ae/0x1bd
[  181.820046]  [<ffffffff810c7909>] check_usage_forwards+0x199/0x1b0
[  181.820046]  [<ffffffff810c7770>] ? check_usage_backwards+0x1a0/0x1a0
[  181.820046]  [<ffffffff810c81e1>] mark_lock+0x1a1/0x2a0
[  181.820046]  [<ffffffff810c8c25>] __lock_acquire+0x2b5/0x1d40
[  181.820046]  [<ffffffff81689193>] ? __slab_free+0x11c/0x2b0
[  181.820046]  [<ffffffff810cae37>] lock_acquire+0xb7/0x140
[  181.820046]  [<ffffffff812fb2c4>] ? blk_end_bidi_request+0x34/0x60
[  181.820046]  [<ffffffff81694f50>] _raw_spin_lock_irqsave+0x50/0x70
[  181.820046]  [<ffffffff812fb2c4>] ? blk_end_bidi_request+0x34/0x60
[  181.820046]  [<ffffffff812fb2c4>] blk_end_bidi_request+0x34/0x60
[  181.820046]  [<ffffffff812fb3cf>] blk_end_request_all+0x1f/0x30
[  181.820046]  [<ffffffffa0206359>] dm_softirq_done+0xe9/0x1e0 [dm_mod]
[  181.820046]  [<ffffffff813023b0>] blk_done_softirq+0xa0/0xd0
[  181.820046]  [<ffffffff8107e091>] __do_softirq+0x141/0x370
[  181.820046]  [<ffffffff8107e655>] irq_exit+0x125/0x130
[  181.820046]  [<ffffffff8104bd05>] smp_call_function_single_interrupt+0x35/0x40
[  181.820046]  [<ffffffff81696822>] call_function_single_interrupt+0x72/0x80
[  181.820046]  <EOI>  [<ffffffff810fecc9>] ? tick_nohz_idle_exit+0xc9/0x150
[  181.820046]  [<ffffffff810fecc5>] ? tick_nohz_idle_exit+0xc5/0x150
[  181.820046]  [<ffffffff810c0084>] cpu_startup_entry+0x194/0x420
[  181.820046]  [<ffffffff8104c6dd>] start_secondary+0x19d/0x210
