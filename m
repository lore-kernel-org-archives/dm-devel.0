From: Neil Brown <neilb@suse.de>
Subject: Re: [BUG] kernel 2.6.32.x hangs during boot process
Date: Thu, 28 Jan 2010 13:42:05 +1100
Message-ID: <20100128134205.352044bd@notabene>
References: <d2deb3241001160158r4baed1e1t7e8f6642de018b4c@mail.gmail.com>
	<20100122160740.6c16c22d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756136Ab0A1CmR@vger.kernel.org>
In-Reply-To: <20100122160740.6c16c22d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?B?RnJhbsOnb2lz?= Figarola <francois.figarola@i-consult.fr>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 22 Jan 2010 16:07:40 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> (cc's added)
(another cc added, one that might actually be useful.....)

> 
> On Sat, 16 Jan 2010 10:58:30 +0100
> Fran__ois Figarola  <francois.figarola@i-consult.fr> wrote:
> 
> > Dear all,
> > 
> > First, I apologize por my poor english...
> > 
> > Since I've tried to boot 2.6.32.x kernel, my system hangs during the
> > boot process, and I think it could be related to the problem reported
> > earlier by Megastorage (http://lkml.org/lkml/2010/1/10/92).
> > 
> > The hardware is a Dell PowerEdge 2950 which runs fine with the
> > 2.6.31.x kernel series (actually running with the latest 2.6.31.11),
> > and the system is debian etch.
> > 
> > Here is the trace of the bug I've got (using netconsole) with a
> > 2.6.32.3 kernel :
> > 
> > BUG: Dentry ffff880667690000{i=41a46,n=sleep} still in use (8)
> > [unmount of ext3 dm-4]
> > ------------[ cut here ]------------
> > kernel BUG at fs/dcache.c:670!
> 
> That's
> 
> 			if (atomic_read(&dentry->d_count) != 0) {
> 				printk(KERN_ERR
> 				       "BUG: Dentry %p{i=%lx,n=%s}"
> 				       " still in use (%d)"
> 				       " [unmount of %s %s]\n",
> 				       dentry,
> 				       dentry->d_inode ?
> 				       dentry->d_inode->i_ino : 0UL,
> 				       dentry->d_name.name,
> 				       atomic_read(&dentry->d_count),
> 				       dentry->d_sb->s_type->name,
> 				       dentry->d_sb->s_id);
> 				BUG();
> 			}
> 
> I'm a bit surprised that the system is doing a dm suspemd/resume during
> the boot process.

It could be that a dm_resume if how you activate a dm device once it is
built, but I'm not sure....
Maybe the guys on dm-devel can help.

NeilBrown

> 
> I assume it's a DM bug, dunno.
> 
> > invalid opcode: 0000 [#1] SMP
> > last sysfs file: /sys/block/dm-2/removable
> > CPU 0
> > Modules linked in: i5k_amb hwmon button processor thermal fan [last
> > unloaded: scsi_wait_scan]
> > Pid: 3311, comm: kpartx Not tainted 2.6.32.3 #2 PowerEdge 2950
> > RIP: 0010:[<ffffffff810f95f0>] __[<ffffffff810f95f0>]
> > shrink_dcache_for_umount_subtree+0x280/0x290
> > RSP: 0018:ffff88066670dcf8 __EFLAGS: 00010296
> > RAX: 000000000000005c RBX: ffff8806677696c0 RCX: 0000000000000096
> > RDX: 0000000000006767 RSI: 0000000000000046 RDI: 0000000000000246
> > RBP: ffff880667690000 R08: 0000000000000000 R09: ffff8806670d1628
> > R10: 0000000000000000 R11: 0000000000000000 R12: ffff880667690060
> > R13: 0000000000000007 R14: ffff8806654d1a88 R15: 0000000000dec0b0
> > FS: __00007f176e96b770(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
> > CS: __0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 00007fff0a2e0080 CR3: 0000000666607000 CR4: 00000000000006f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process kpartx (pid: 3311, threadinfo ffff88066670c000, task ffff8806652997d0)
> > Stack:
> > ffff880665b8b178 ffff880665b8af18 ffffffff81619600 0000000000000001
> > <0> ffff880667408e00 ffffffff810f9629 ffff880665b8af18 ffffffff810e8049
> > <0> ffff8806651333f8 ffff880667408e00 ffffffff8185fc00 ffffffff810e8159
> > Call Trace:
> > [<ffffffff810f9629>] ? shrink_dcache_for_umount+0x29/0x50
> > [<ffffffff810e8049>] ? generic_shutdown_super+0x19/0x100
> > [<ffffffff810e8159>] ? kill_block_super+0x29/0x50
> > [<ffffffff810e8238>] ? deactivate_locked_super+0x58/0x80
> > [<ffffffff81112842>] ? thaw_bdev+0xd2/0x110
> > [<ffffffff814b0c67>] ? dm_resume+0xf7/0x160
> > [<ffffffff814b5f00>] ? dev_suspend+0x0/0x220
> > [<ffffffff814b60b1>] ? dev_suspend+0x1b1/0x220
> > [<ffffffff814b6c7b>] ? ctl_ioctl+0x1eb/0x260
> > [<ffffffff810c0b1b>] ? handle_mm_fault+0x63b/0x990
> > [<ffffffff814b6cfe>] ? dm_ctl_ioctl+0xe/0x20
> > [<ffffffff8104991a>] ? finish_task_switch+0x3a/0xc0
> > [<ffffffff810f4e9f>] ? vfs_ioctl+0x2f/0xb0
> > [<ffffffff810f53bb>] ? do_vfs_ioctl+0x3fb/0x580
> > [<ffffffff815fb101>] ? thread_return+0x3e/0x64d
> > [<ffffffff810f55e1>] ? sys_ioctl+0xa1/0xb0
> > [<ffffffff8100bf02>] ? system_call_fastpath+0x16/0x1b
> > Code: 4d 38 48 8b 45 10 48 85 c0 74 04 48 8b 50 40 48 8d 86 60 02 00
> > 00 48 c7 c7 a8 66 76 81 48 89 04 24 48 89 ee 31 c0 e8 a9 11 50 00 <0f>
> > 0b eb fe 0f 0b eb fe 0f 1f 84 00 00 00 00 00 53 48 89 fb 48
> > RIP __[<ffffffff810f95f0>] shrink_dcache_for_umount_subtree+0x280/0x290
> > RSP <ffff88066670dcf8>
> > ---[ end trace 3cc1cb65fcc6a8ca ]---
> > 
> > another trace with same behavior on a new compiled kernel with more
> > debug options;
> > but I can't see any difference :
> > 
> > BUG: Dentry ffff880667556738{i=41a46,n=sleep} still in use (8)
> > [unmount of ext3 dm-4]
> > ------------[ cut here ]------------
> > kernel BUG at fs/dcache.c:670!
> > invalid opcode: 0000 [#1] SMP
> > last sysfs file: /sys/block/dm-3/removable
> > CPU 1
> > Modules linked in: i5k_amb(+) button hwmon processor thermal fan [last
> > unloaded: scsi_wait_scan]
> > Pid: 3315, comm: kpartx Not tainted 2.6.32.3 #3 PowerEdge 2950
> > RIP: 0010:[<ffffffff810f95f0>] __[<ffffffff810f95f0>]
> > shrink_dcache_for_umount_subtree+0x280/0x290
> > RSP: 0018:ffff880667089cf8 __EFLAGS: 00010296
> > RAX: 000000000000005c RBX: ffff880667790a60 RCX: 0000000000000096
> > RDX: 0000000000006767 RSI: 0000000000000046 RDI: 0000000000000246
> > RBP: ffff880667556738 R08: 0000000000000000 R09: ffff88066604b420
> > R10: 0000000000000000 R11: 0000000000000000 R12: ffff880667556798
> > R13: 0000000000000007 R14: ffff880665842360 R15: 0000000000b3c0b0
> > FS: __00007f7b1006c770(0000) GS:ffff880028240000(0000) knlGS:0000000000000000
> > CS: __0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 00007f6e67f1c350 CR3: 0000000664ff1000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process kpartx (pid: 3315, threadinfo ffff880667088000, task ffff880664f55f40)
> > Stack:
> > ffff880667058af0 ffff880667058890 ffffffff81619600 0000000000000001
> > <0> ffff880667408e00 ffffffff810f9629 ffff880667058890 ffffffff810e8049
> > <0> ffff88067f83e758 ffff880667408e00 ffffffff8185fc00 ffffffff810e8159
> > Call Trace:
> > [<ffffffff810f9629>] ? shrink_dcache_for_umount+0x29/0x50
> > [<ffffffff810e8049>] ? generic_shutdown_super+0x19/0x100
> > [<ffffffff810e8159>] ? kill_block_super+0x29/0x50
> > [<ffffffff810e8238>] ? deactivate_locked_super+0x58/0x80
> > [<ffffffff81112842>] ? thaw_bdev+0xd2/0x110
> > [<ffffffff814b0c67>] ? dm_resume+0xf7/0x160
> > [<ffffffff814b5f00>] ? dev_suspend+0x0/0x220
> > [<ffffffff814b60b1>] ? dev_suspend+0x1b1/0x220
> > [<ffffffff814b6c7b>] ? ctl_ioctl+0x1eb/0x260
> > [<ffffffff810c0b1b>] ? handle_mm_fault+0x63b/0x990
> > [<ffffffff814b6cfe>] ? dm_ctl_ioctl+0xe/0x20
> > [<ffffffff8104991a>] ? finish_task_switch+0x3a/0xc0
> > [<ffffffff810f4e9f>] ? vfs_ioctl+0x2f/0xb0
> > [<ffffffff810f53bb>] ? do_vfs_ioctl+0x3fb/0x580
> > [<ffffffff815fb101>] ? thread_return+0x3e/0x64d
> > [<ffffffff810f55e1>] ? sys_ioctl+0xa1/0xb0
> > [<ffffffff8100bf02>] ? system_call_fastpath+0x16/0x1b
> > Code: 4d 38 48 8b 45 10 48 85 c0 74 04 48 8b 50 40 48 8d 86 60 02 00
> > 00 48 c7 c7 a8 66 76 81 48 89 04 24 48 89 ee 31 c0 e8 a9 11 50 00 <0f>
> > 0b eb fe 0f 0b eb fe 0f 1f 84 00 00 00 00 00 53 48 89 fb 48
> > RIP __[<ffffffff810f95f0>] shrink_dcache_for_umount_subtree+0x280/0x290
> > RSP <ffff880667089cf8>
> > ---[ end trace a9fb3c2286e56cbd ]---
> > 
> > 
> > I think the problem should be related with lvm or device mapper because
> > I could start perfectly a 2.6.32.2 kernel on another PowerEdge 2950
> > without any kind of lvm or dm configured...
> > but I'm really not expert with kernel debug.
> > 
> > Here is the fstab of the buggy system :
> > 
> > # /etc/fstab: static file system information.
> > #
> > # <file system> <mount point> __ <type> __<options> __ __ __ <dump> __<pass>
> > proc __ __ __ __ __ __/proc __ __ __ __ __ proc __ __defaults __ __ __ __0 __ __ __ 0
> > /dev/dm-4 __ __ __ / __ __ __ __ __ __ __ ext3 __ __errors=remount-ro 0 __ __ __ 1
> > /dev/dm-1 __ __ __ /boot __ __ __ __ __ ext3 __ __defaults __ __ __ __0 __ __ __ 2
> > /dev/dm-7 __ __ __ /home __ __ __ __ __ ext3 __ __defaults __ __ __ __0 __ __ __ 2
> > /dev/dm-5 __ __ __ /usr __ __ __ __ __ __ext3 __ __defaults __ __ __ __0 __ __ __ 2
> > /dev/dm-6 __ __ __ /var __ __ __ __ __ __ext3 __ __defaults __ __ __ __0 __ __ __ 2
> > /dev/dm-2 __ __ __ none __ __ __ __ __ __swap __ __sw __ __ __ __ __ __ __0 __ __ __ 0
> > /dev/hda __ __ __ __/media/cdrom0 __ udf,iso9660 user,noauto __ __ 0 __ __ __ 0
> > debugfs /sys/kernel/debug debugfs noauto 0 0
> > 
> > I hope it can help, and try to give us more informations if necessary.
> > 
> > Fran__ois.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
