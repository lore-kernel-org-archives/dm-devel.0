From: Hannes Reinecke <hare@suse.de>
Subject: Re: 3.15-rc4: circular locking dependency triggered by
 dm-multipath
Date: Thu, 08 May 2014 07:57:21 +0200
Message-ID: <536B1CC1.6080709@suse.de>
References: <5368ABE8.9050909@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5368ABE8.9050909@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/06/2014 11:31 AM, Bart Van Assche wrote:
> Hello,
>
> Has anyone else perhaps already run into this ?
>
> Thanks,
>
> Bart.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> [ INFO: possible circular locking dependency detected ]
> 3.15.0-rc4-debug+ #1 Not tainted
> -------------------------------------------------------
> multipathd/10364 is trying to acquire lock:
>   (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffffa043bff3>] dm_table=
_run_md_queue_async+0x33/0x60 [dm_mod]
>
> but task is already holding lock:
>   (&(&m->lock)->rlock){..-...}, at: [<ffffffffa077a647>] queue_if_no_path=
+0x27/0xc0 [dm_multipath]
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&(&m->lock)->rlock){..-...}:
>         [<ffffffff810a56c3>] lock_acquire+0x93/0x1c0
>         [<ffffffff814ae8eb>] _raw_spin_lock+0x3b/0x50
>         [<ffffffffa043a3e9>] dm_blk_open+0x19/0x80 [dm_mod]
>         [<ffffffff811cbc41>] __blkdev_get+0xd1/0x4c0
>         [<ffffffff811cc215>] blkdev_get+0x1e5/0x380
>         [<ffffffff811cc45b>] blkdev_open+0x5b/0x80
>         [<ffffffff8118a12e>] do_dentry_open.isra.15+0x1de/0x2a0
>         [<ffffffff8118a300>] finish_open+0x30/0x40
>         [<ffffffff8119c44d>] do_last.isra.61+0xa5d/0x1200
>         [<ffffffff8119cca7>] path_openat+0xb7/0x620
>         [<ffffffff8119d88a>] do_filp_open+0x3a/0x90
>         [<ffffffff8118bb4e>] do_sys_open+0x12e/0x210
>         [<ffffffff8118bc4e>] SyS_open+0x1e/0x20
>         [<ffffffff814b84e2>] tracesys+0xd0/0xd5
>
> -> #0 (&(&q->__queue_lock)->rlock){-.-...}:
>         [<ffffffff810a4c46>] __lock_acquire+0x1716/0x1a00
>         [<ffffffff810a56c3>] lock_acquire+0x93/0x1c0
>         [<ffffffff814aea56>] _raw_spin_lock_irqsave+0x46/0x60
>         [<ffffffffa043bff3>] dm_table_run_md_queue_async+0x33/0x60 [dm_mo=
d]
>         [<ffffffffa077a692>] queue_if_no_path+0x72/0xc0 [dm_multipath]
>         [<ffffffffa077a6f9>] multipath_presuspend+0x19/0x20 [dm_multipath]
>         [<ffffffffa043d34a>] dm_table_presuspend_targets+0x4a/0x60 [dm_mo=
d]
>         [<ffffffffa043ad5d>] dm_suspend+0x6d/0x1f0 [dm_mod]
>         [<ffffffffa043ff63>] dev_suspend+0x1c3/0x220 [dm_mod]
>         [<ffffffffa0440759>] ctl_ioctl+0x269/0x500 [dm_mod]
>         [<ffffffffa0440a03>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
>         [<ffffffff811a04c0>] do_vfs_ioctl+0x300/0x520
>         [<ffffffff811a0721>] SyS_ioctl+0x41/0x80
>         [<ffffffff814b84e2>] tracesys+0xd0/0xd5
>
> other info that might help us debug this:
>
>   Possible unsafe locking scenario:
>
>         CPU0                    CPU1
>         ----                    ----
>    lock(&(&m->lock)->rlock);
>                                 lock(&(&q->__queue_lock)->rlock);
>                                 lock(&(&m->lock)->rlock);
>    lock(&(&q->__queue_lock)->rlock);
>
>   *** DEADLOCK ***
>
> 2 locks held by multipathd/10364:
>   #0:  (&md->suspend_lock){+.+...}, at: [<ffffffffa043ad28>] dm_suspend+0=
x38/0x1f0 [dm_mod]
>   #1:  (&(&m->lock)->rlock){..-...}, at: [<ffffffffa077a647>] queue_if_no=
_path+0x27/0xc0 [dm_multipath]
>
> stack backtrace:
> CPU: 10 PID: 10364 Comm: multipathd Not tainted 3.15.0-rc4-debug+ #1
> Hardware name: MSI MS-7737/Big Bang-XPower II (MS-7737), BIOS V1.5 10/16/=
2012
>   ffffffff81fea150 ffff8807c194fa98 ffffffff814a6780 ffffffff81fea150
>   ffff8807c194fad8 ffffffff814a36db ffff8807c194fb30 ffff8807c1954c88
>   0000000000000001 0000000000000002 ffff8807c1954c88 ffff8807c1954440
> Call Trace:
>   [<ffffffff814a6780>] dump_stack+0x4e/0x7a
>   [<ffffffff814a36db>] print_circular_bug+0x200/0x20f
>   [<ffffffff810a4c46>] __lock_acquire+0x1716/0x1a00
>   [<ffffffff810a56c3>] lock_acquire+0x93/0x1c0
>   [<ffffffffa043bff3>] ? dm_table_run_md_queue_async+0x33/0x60 [dm_mod]
>   [<ffffffff814aea56>] _raw_spin_lock_irqsave+0x46/0x60
>   [<ffffffffa043bff3>] ? dm_table_run_md_queue_async+0x33/0x60 [dm_mod]
>   [<ffffffffa043bff3>] dm_table_run_md_queue_async+0x33/0x60 [dm_mod]
>   [<ffffffffa077a692>] queue_if_no_path+0x72/0xc0 [dm_multipath]
>   [<ffffffffa077a6f9>] multipath_presuspend+0x19/0x20 [dm_multipath]
>   [<ffffffffa043d34a>] dm_table_presuspend_targets+0x4a/0x60 [dm_mod]
>   [<ffffffffa043ad5d>] dm_suspend+0x6d/0x1f0 [dm_mod]
>   [<ffffffffa043ff63>] dev_suspend+0x1c3/0x220 [dm_mod]
>   [<ffffffffa043fda0>] ? table_load+0x350/0x350 [dm_mod]
>   [<ffffffffa0440759>] ctl_ioctl+0x269/0x500 [dm_mod]
>   [<ffffffffa0440a03>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
>   [<ffffffff811a04c0>] do_vfs_ioctl+0x300/0x520
>   [<ffffffff811ac089>] ? __fget+0x129/0x300
>   [<ffffffff811abf65>] ? __fget+0x5/0x300
>   [<ffffffff811ac2d0>] ? __fget_light+0x30/0x160
>   [<ffffffff811a0721>] SyS_ioctl+0x41/0x80
>   [<ffffffff814b84e2>] tracesys+0xd0/0xd5
>
Hmm. No, I haven't seen it (yet).
Looking into it.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
