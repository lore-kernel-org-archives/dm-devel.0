From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: 3.15-rc4: circular locking dependency triggered by
 dm-multipath
Date: Mon, 26 May 2014 13:44:25 +0200
Message-ID: <53832919.8080500@acm.org>
References: <5368ABE8.9050909@acm.org> <536B1CC1.6080709@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <536B1CC1.6080709@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/08/14 07:57, Hannes Reinecke wrote:
> On 05/06/2014 11:31 AM, Bart Van Assche wrote:
>> Hello,
>>
>> Has anyone else perhaps already run into this ?
>>
>> Thanks,
>>
>> Bart.
>>
>> ======================================================
>> [ INFO: possible circular locking dependency detected ]
>> 3.15.0-rc4-debug+ #1 Not tainted
>> -------------------------------------------------------
>> multipathd/10364 is trying to acquire lock:
>>   (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffffa043bff3>]
>> dm_table_run_md_queue_async+0x33/0x60 [dm_mod]
>>
>> but task is already holding lock:
>>   (&(&m->lock)->rlock){..-...}, at: [<ffffffffa077a647>]
>> queue_if_no_path+0x27/0xc0 [dm_multipath]
>>
>> which lock already depends on the new lock.
>>
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #1 (&(&m->lock)->rlock){..-...}:
>>         [<ffffffff810a56c3>] lock_acquire+0x93/0x1c0
>>         [<ffffffff814ae8eb>] _raw_spin_lock+0x3b/0x50
>>         [<ffffffffa043a3e9>] dm_blk_open+0x19/0x80 [dm_mod]
>>         [<ffffffff811cbc41>] __blkdev_get+0xd1/0x4c0
>>         [<ffffffff811cc215>] blkdev_get+0x1e5/0x380
>>         [<ffffffff811cc45b>] blkdev_open+0x5b/0x80
>>         [<ffffffff8118a12e>] do_dentry_open.isra.15+0x1de/0x2a0
>>         [<ffffffff8118a300>] finish_open+0x30/0x40
>>         [<ffffffff8119c44d>] do_last.isra.61+0xa5d/0x1200
>>         [<ffffffff8119cca7>] path_openat+0xb7/0x620
>>         [<ffffffff8119d88a>] do_filp_open+0x3a/0x90
>>         [<ffffffff8118bb4e>] do_sys_open+0x12e/0x210
>>         [<ffffffff8118bc4e>] SyS_open+0x1e/0x20
>>         [<ffffffff814b84e2>] tracesys+0xd0/0xd5
>>
>> -> #0 (&(&q->__queue_lock)->rlock){-.-...}:
>>         [<ffffffff810a4c46>] __lock_acquire+0x1716/0x1a00
>>         [<ffffffff810a56c3>] lock_acquire+0x93/0x1c0
>>         [<ffffffff814aea56>] _raw_spin_lock_irqsave+0x46/0x60
>>         [<ffffffffa043bff3>] dm_table_run_md_queue_async+0x33/0x60
>> [dm_mod]
>>         [<ffffffffa077a692>] queue_if_no_path+0x72/0xc0 [dm_multipath]
>>         [<ffffffffa077a6f9>] multipath_presuspend+0x19/0x20
>> [dm_multipath]
>>         [<ffffffffa043d34a>] dm_table_presuspend_targets+0x4a/0x60
>> [dm_mod]
>>         [<ffffffffa043ad5d>] dm_suspend+0x6d/0x1f0 [dm_mod]
>>         [<ffffffffa043ff63>] dev_suspend+0x1c3/0x220 [dm_mod]
>>         [<ffffffffa0440759>] ctl_ioctl+0x269/0x500 [dm_mod]
>>         [<ffffffffa0440a03>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
>>         [<ffffffff811a04c0>] do_vfs_ioctl+0x300/0x520
>>         [<ffffffff811a0721>] SyS_ioctl+0x41/0x80
>>         [<ffffffff814b84e2>] tracesys+0xd0/0xd5
>>
>> other info that might help us debug this:
>>
>>   Possible unsafe locking scenario:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(&(&m->lock)->rlock);
>>                                 lock(&(&q->__queue_lock)->rlock);
>>                                 lock(&(&m->lock)->rlock);
>>    lock(&(&q->__queue_lock)->rlock);
>>
>>   *** DEADLOCK ***
>>
>> 2 locks held by multipathd/10364:
>>   #0:  (&md->suspend_lock){+.+...}, at: [<ffffffffa043ad28>]
>> dm_suspend+0x38/0x1f0 [dm_mod]
>>   #1:  (&(&m->lock)->rlock){..-...}, at: [<ffffffffa077a647>]
>> queue_if_no_path+0x27/0xc0 [dm_multipath]
>>
>> stack backtrace:
>> CPU: 10 PID: 10364 Comm: multipathd Not tainted 3.15.0-rc4-debug+ #1
>> Hardware name: MSI MS-7737/Big Bang-XPower II (MS-7737), BIOS V1.5
>> 10/16/2012
>>   ffffffff81fea150 ffff8807c194fa98 ffffffff814a6780 ffffffff81fea150
>>   ffff8807c194fad8 ffffffff814a36db ffff8807c194fb30 ffff8807c1954c88
>>   0000000000000001 0000000000000002 ffff8807c1954c88 ffff8807c1954440
>> Call Trace:
>>   [<ffffffff814a6780>] dump_stack+0x4e/0x7a
>>   [<ffffffff814a36db>] print_circular_bug+0x200/0x20f
>>   [<ffffffff810a4c46>] __lock_acquire+0x1716/0x1a00
>>   [<ffffffff810a56c3>] lock_acquire+0x93/0x1c0
>>   [<ffffffffa043bff3>] ? dm_table_run_md_queue_async+0x33/0x60 [dm_mod]
>>   [<ffffffff814aea56>] _raw_spin_lock_irqsave+0x46/0x60
>>   [<ffffffffa043bff3>] ? dm_table_run_md_queue_async+0x33/0x60 [dm_mod]
>>   [<ffffffffa043bff3>] dm_table_run_md_queue_async+0x33/0x60 [dm_mod]
>>   [<ffffffffa077a692>] queue_if_no_path+0x72/0xc0 [dm_multipath]
>>   [<ffffffffa077a6f9>] multipath_presuspend+0x19/0x20 [dm_multipath]
>>   [<ffffffffa043d34a>] dm_table_presuspend_targets+0x4a/0x60 [dm_mod]
>>   [<ffffffffa043ad5d>] dm_suspend+0x6d/0x1f0 [dm_mod]
>>   [<ffffffffa043ff63>] dev_suspend+0x1c3/0x220 [dm_mod]
>>   [<ffffffffa043fda0>] ? table_load+0x350/0x350 [dm_mod]
>>   [<ffffffffa0440759>] ctl_ioctl+0x269/0x500 [dm_mod]
>>   [<ffffffffa0440a03>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
>>   [<ffffffff811a04c0>] do_vfs_ioctl+0x300/0x520
>>   [<ffffffff811ac089>] ? __fget+0x129/0x300
>>   [<ffffffff811abf65>] ? __fget+0x5/0x300
>>   [<ffffffff811ac2d0>] ? __fget_light+0x30/0x160
>>   [<ffffffff811a0721>] SyS_ioctl+0x41/0x80
>>   [<ffffffff814b84e2>] tracesys+0xd0/0xd5
>>
> Hmm. No, I haven't seen it (yet).
> Looking into it.

Hello Hannes,

Not sure if this information helps but apparently the above warning is
not a false positive but indicates a real deadlock. I have been able to
reproduce the above warning with 3.15-rc7. Shortly after the above
message appeared the following was reported:

Watchdog detected hard LOCKUP on cpu 11
Call Trace:
 <NMI>  [<ffffffff814a7bd0>] dump_stack+0x4e/0x7a
 [<ffffffff8104bb8d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8104bbfc>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff810e89b5>] watchdog_overflow_callback+0xd5/0x120
 [<ffffffff8112268c>] __perf_event_overflow+0x9c/0x320
 [<ffffffff81017a50>] ? x86_perf_event_set_period+0xe0/0x150
 [<ffffffff811236b4>] perf_event_overflow+0x14/0x20
 [<ffffffff8101e5de>] intel_pmu_handle_irq+0x1ce/0x3c0
 [<ffffffff814affd1>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff812e6c3f>] ? ghes_copy_tofrom_phys+0x11f/0x210
 [<ffffffff814b28ab>] perf_event_nmi_handler+0x2b/0x50
 [<ffffffff814b1da2>] nmi_handle.isra.5+0xc2/0x380
 [<ffffffff814b1ce5>] ? nmi_handle.isra.5+0x5/0x380
 [<ffffffff814b21e5>] do_nmi+0x185/0x3e0
 [<ffffffff814b1287>] end_repeat_nmi+0x1e/0x2e
 [<ffffffff8126548d>] ? delay_tsc+0x2d/0xc0
 [<ffffffff8126548d>] ? delay_tsc+0x2d/0xc0
 [<ffffffff8126548d>] ? delay_tsc+0x2d/0xc0
 <<EOE>>  [<ffffffff812653bf>] __delay+0xf/0x20
 [<ffffffff810a86b1>] do_raw_spin_lock+0xe1/0x140
 [<ffffffff814afece>] _raw_spin_lock_irqsave+0x4e/0x60
 [<ffffffffa0782500>] ? multipath_busy+0x20/0xf0 [dm_multipath]
 [<ffffffffa0782500>] multipath_busy+0x20/0xf0 [dm_multipath]
 [<ffffffffa024e56c>] dm_request_fn+0xcc/0x320 [dm_mod]
 [<ffffffff8123b013>] __blk_run_queue+0x33/0x40
 [<ffffffff8123b205>] blk_delay_work+0x25/0x40
 [<ffffffff8106d7aa>] process_one_work+0x1ea/0x6c0
 [<ffffffff8106d748>] ? process_one_work+0x188/0x6c0
 [<ffffffff8106dd9b>] worker_thread+0x11b/0x3a0
 [<ffffffff8106dc80>] ? process_one_work+0x6c0/0x6c0
 [<ffffffff810758bd>] kthread+0xed/0x110
 [<ffffffff810757d0>] ? insert_kthread_work+0x80/0x80
 [<ffffffff814b972c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810757d0>] ? insert_kthread_work+0x80/0x80

Bart.
