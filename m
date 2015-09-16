From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: How do you force-close a dm device after a disk
 failure?
Date: Wed, 16 Sep 2015 15:03:15 +0200
Message-ID: <55F96893.2010201@redhat.com>
References: <20150914102917.3991920c@korath.teln.shikadi.net>
	<55F66C8B.7070603@redhat.com>
	<20150914185943.6d963e0c@korath.teln.shikadi.net>
	<55F6906A.6080404@redhat.com>
	<20150914194552.213afd64@korath.teln.shikadi.net>
	<55F69BA9.30908@redhat.com>
	<20150916105857.69e1cb49@korath.teln.shikadi.net>
	<55F92291.9020808@redhat.com>
	<20150916223512.40687a03@korath.teln.shikadi.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150916223512.40687a03@korath.teln.shikadi.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Adam Nielsen <a.nielsen@shikadi.net>
List-Id: dm-devel.ids

Dne 16.9.2015 v 14:35 Adam Nielsen napsal(a):
>>> It always seems to freeze at DM_DEV_SUSPEND.  This ioctl never
>>> seems to return.
>>
>> As with any other kernel frozen task - try to capture kernel stack
>> trace. If you properly configured sysrq trigger - easiest is to use:
>>
>> 'echo t >/proc/sysrq-trigger'
>>
>> (Just make sure you have large enough kernel log buffer so lines are
>> not lost) Attach compressed trace - this should likely reveal where
>> it blocks. (I'll try to reproduce myself)
>
> Thanks for the advice.  I'm getting a warning that the buffer is
> overflowing.  Is there anything in particular you need?  Here is
> something that seems relevant:
>
> dmsetup         D ffff880394467b98     0 24732  24717 0x00000000
>   ffff880394467b98 ffff88040d7a1e90 ffff88027b738a30 ffff88040ba67458
>   ffff880394468000 ffff8801eaa7b8dc ffff88027b738a30 00000000ffffffff
>   ffff8801eaa7b8e0 ffff880394467bb8 ffffffff81588247 ffff8801eaa7b8d8
> Call Trace:
>   [<ffffffff81588247>] schedule+0x37/0x90
>   [<ffffffff81588615>] schedule_preempt_disabled+0x15/0x20
>   [<ffffffff81589b55>] __mutex_lock_slowpath+0xd5/0x150
>   [<ffffffff81589beb>] mutex_lock+0x1b/0x30
>   [<ffffffffa0857968>] dm_suspend+0x38/0xf0 [dm_mod]
>   [<ffffffffa085d030>] ? table_load+0x370/0x370 [dm_mod]
>   [<ffffffffa085d1c0>] dev_suspend+0x190/0x260 [dm_mod]
>   [<ffffffffa085d030>] ? table_load+0x370/0x370 [dm_mod]
>   [<ffffffffa085da72>] ctl_ioctl+0x232/0x520 [dm_mod]
>   [<ffffffffa085dd73>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
>   [<ffffffff811f4606>] do_vfs_ioctl+0x2c6/0x4d0
>   [<ffffffff811f4891>] SyS_ioctl+0x81/0xa0
>   [<ffffffff8158beae>] system_call_fastpath+0x12/0x71
>
> Assuming 24732 is the PID, that's the "dmsetup suspend --noflush
> --nolockfs" one.  There are heaps like the one above (from all my
> attempts) with only one like the following, from an unknown command
> line:
>
> dmsetup         D ffff88012e2d7a88     0 28744  23911 0x00000004
>   ffff88012e2d7a88 ffff88040d74f010 ffff88040398e5e0 ffff88012e2d7b38
>   ffff88012e2d8000 ffff8800d9df5080 ffff8800d9df5068 ffffffff00000000
>   fffffffe00000001 ffff88012e2d7aa8 ffffffff81588247 0000000000000002
> Call Trace:
>   [<ffffffff81588247>] schedule+0x37/0x90
>   [<ffffffff8158a885>] rwsem_down_write_failed+0x165/0x370
>   [<ffffffff810b2ad6>] ? enqueue_entity+0x266/0xd60
>   [<ffffffff812d7aa3>] call_rwsem_down_write_failed+0x13/0x20
>   [<ffffffff8158a0d4>] ? down_write+0x24/0x40
>   [<ffffffff811e3aee>] grab_super+0x2e/0xb0
>   [<ffffffff811e4a20>] get_active_super+0x70/0x90
>   [<ffffffff8121ab9d>] freeze_bdev+0x6d/0x100
>   [<ffffffffa0854f3b>] __dm_suspend+0xeb/0x230 [dm_mod]
>   [<ffffffffa08579fa>] dm_suspend+0xca/0xf0 [dm_mod]
>   [<ffffffffa085d1db>] dev_suspend+0x1ab/0x260 [dm_mod]
>   [<ffffffffa085d030>] ? table_load+0x370/0x370 [dm_mod]
>   [<ffffffffa085da72>] ctl_ioctl+0x232/0x520 [dm_mod]
>   [<ffffffffa085dd73>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
>   [<ffffffff811f4606>] do_vfs_ioctl+0x2c6/0x4d0
>   [<ffffffff811f4891>] SyS_ioctl+0x81/0xa0
>   [<ffffffff8158beae>] system_call_fastpath+0x12/0x71


Was this the 'ONLY' dmsetup in your listing (i.e. you reproduced case again)?

I mean - your existing reported situation was already hopeless and needed 
reboot - as if  flushing suspend holds some mutexes - no other suspend call 
can fix it ->  you usually have just  1 chance to fix it in right way,
if you go wrong way reboot is unavoidable.

Zdenek
