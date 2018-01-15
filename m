From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [for-4.16 PATCH v5 0/4] block/dm: allow DM to defer
 blk_register_queue() until ready
Date: Mon, 15 Jan 2018 17:16:53 +0000
Message-ID: <1516036612.10386.2.camel@wdc.com>
References: <20180112150606.6037-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180112150606.6037-1-snitzer@redhat.com>
Content-Language: en-US
Content-ID: <84E4D8BC4E29CE448593B4C6EC646A2D@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "djeffery@redhat.com" <djeffery@redhat.com>
List-Id: dm-devel.ids

On Fri, 2018-01-12 at 10:06 -0500, Mike Snitzer wrote:
> I'm submitting this v5 with more feeling now ;)

Hello Mike,

Have these patches been tested with lockdep enabled? The following appeared in
the kernel log when after I started testing Jens' for-next tree of this morning:

======================================================
WARNING: possible circular locking dependency detected
4.15.0-rc7-dbg+ #1 Not tainted
------------------------------------------------------
02-mq/1211 is trying to acquire lock:
 (&q->sysfs_lock){+.+.}, at: [<000000008b65bdad>] queue_attr_store+0x35/0x80

but task is already holding lock:
 (kn->count#213){++++}, at: [<000000007a18ad18>] kernfs_fop_write+0xe5/0x190

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (kn->count#213){++++}:
       kernfs_remove+0x1a/0x30
       kobject_del.part.3+0xe/0x40
       blk_unregister_queue+0xa7/0xe0
       del_gendisk+0x12f/0x260
       sd_remove+0x58/0xc0 [sd_mod]
       device_release_driver_internal+0x15a/0x220
       bus_remove_device+0xf4/0x170
       device_del+0x12f/0x330
       __scsi_remove_device+0xef/0x120 [scsi_mod]
       scsi_forget_host+0x1b/0x60 [scsi_mod]
       scsi_remove_host+0x6f/0x110 [scsi_mod]
       0xffffffffc09ed6e4
       process_one_work+0x21c/0x6d0
       worker_thread+0x35/0x380
       kthread+0x117/0x130
       ret_from_fork+0x24/0x30

-> #0 (&q->sysfs_lock){+.+.}:
       __mutex_lock+0x6c/0x9e0
       queue_attr_store+0x35/0x80
       kernfs_fop_write+0x109/0x190
       __vfs_write+0x1e/0x130
       vfs_write+0xb9/0x1b0
       SyS_write+0x40/0xa0
       entry_SYSCALL_64_fastpath+0x23/0x9a

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(kn->count#213);
                               lock(&q->sysfs_lock);
                               lock(kn->count#213);
  lock(&q->sysfs_lock);

 *** DEADLOCK ***

3 locks held by 02-mq/1211:
 #0:  (sb_writers#6){.+.+}, at: [<00000000afdb61d3>] vfs_write+0x17f/0x1b0
 #1:  (&of->mutex){+.+.}, at: [<00000000b291cabb>] kernfs_fop_write+0xdd/0x190
 #2:  (kn->count#213){++++}, at: [<000000007a18ad18>] kernfs_fop_write+0xe5/0x190

stack backtrace:
CPU: 2 PID: 1211 Comm: 02-mq Not tainted 4.15.0-rc7-dbg+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
Call Trace:
 dump_stack+0x85/0xbf
 print_circular_bug.isra.35+0x1d7/0x1e4
 __lock_acquire+0x12af/0x1370
 ? lock_acquire+0xa8/0x230
 lock_acquire+0xa8/0x230
 ? queue_attr_store+0x35/0x80
 ? queue_attr_store+0x35/0x80
 __mutex_lock+0x6c/0x9e0
 ? queue_attr_store+0x35/0x80
 ? kernfs_fop_write+0xdd/0x190
 ? __mutex_lock+0x6c/0x9e0
 ? __mutex_lock+0x3d0/0x9e0
 ? lock_acquire+0xa8/0x230
 ? __lock_is_held+0x55/0x90
 ? queue_attr_store+0x35/0x80
 queue_attr_store+0x35/0x80
 kernfs_fop_write+0x109/0x190
 __vfs_write+0x1e/0x130
 ? rcu_read_lock_sched_held+0x66/0x70
 ? rcu_sync_lockdep_assert+0x23/0x50
 ? __sb_start_write+0x152/0x1f0
 ? __sb_start_write+0x168/0x1f0
 vfs_write+0xb9/0x1b0
 SyS_write+0x40/0xa0
 entry_SYSCALL_64_fastpath+0x23/0x9a
RIP: 0033:0x7fab8be8d054
RSP: 002b:00007ffd39f0def8 EFLAGS: 00000246

Thanks,

Bart.
