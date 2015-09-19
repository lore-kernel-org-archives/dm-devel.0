From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: How do you force-close a dm device after a disk
 failure?
Date: Sat, 19 Sep 2015 19:47:52 +1000
Message-ID: <20150919194752.753cdc44@korath.teln.shikadi.net>
References: <20150914102917.3991920c@korath.teln.shikadi.net>
	<55F66C8B.7070603@redhat.com>
	<20150914185943.6d963e0c@korath.teln.shikadi.net>
	<55F6906A.6080404@redhat.com>
	<20150914194552.213afd64@korath.teln.shikadi.net>
	<55F69BA9.30908@redhat.com>
	<20150916105857.69e1cb49@korath.teln.shikadi.net>
	<55F92291.9020808@redhat.com>
	<20150916223512.40687a03@korath.teln.shikadi.net>
	<55F96893.2010201@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <55F96893.2010201@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> Was this the 'ONLY' dmsetup in your listing (i.e. you reproduced case
> again)?

This was the original instance of the problem.  Today I have rebooted
and reproduced the problem on a fresh kernel.

> I mean - your existing reported situation was already hopeless and
> needed reboot - as if  flushing suspend holds some mutexes - no other
> suspend call can fix it ->  you usually have just  1 chance to fix it
> in right way, if you go wrong way reboot is unavoidable.

That sounds like a very unforgiving buggy kernel, if you only have one
chance to fix the problem ;-)

Here is my attempt on the fresh kernel.  I received some write errors
in dmesg, so tried to umount the dm device to confirm I had reproduced
the problem, and when umount failed to exit I tried this:

  $ dmsetup reload backup --table "0 11720531968 error"
  $ dmsetup suspend --noflush --nolockfs backup

These two worked fine now.  "dmsetup suspend" was locking up before,
this time it worked.

  $ umount /mnt/backup
  umount: /mnt/backup: not mounted

The dm instance is no longer mounted.

  $ mdadm --manage --stop /dev/md10
  mdadm: Cannot get exclusive access to /dev/md10:Perhaps a running
    process, mounted filesystem or active volume group?

I can't restart the underlying RAID array though, as the dm instance is
still holding onto the devices.

  $ dmsetup remove --force backup
  device-mapper: remove ioctl on backup failed: Device or resource busy
  Command failed

I don't appear to be able to shut down the dm device either.  I tried
to umount the device before any of this, and the umount process has
frozen (despite it seeming to have unmounted successfully), so this is
probably what the kernel thinks is using the device.  Although the table
has been replace by the "error" target, the umount process is not
returning and appears to be frozen inside the kernel (because killall
-9 doesn't work.)

Strangely I can still read and write to the underlying device
(/dev/md10), it is only processes accessing /dev/mapper/backup that
freeze.

Any suggestions?  I imagine "dmsetup remove --deferred" won't help if
the umount process is holding the device open and never terminates.  It
still looks like once you get an I/O error, the dm device locks up and
a reboot is the only way to get it to let go of the storage device
underlying the dm device.

Not sure if this helps, but this is where 'sync' and 'umount' lock up
when the system is in this state:

sync            D ffff880121ff7e00     0 23685  23671 0x00000004
 ffff880121ff7e00 ffff88040d7a28c0 ffff88040b498a30 dead000000100100
 ffff880121ff8000 ffff8800d96ff068 ffff8800d96ff080 ffffffff81213800
 ffff8800d96ff068 ffff880121ff7e20 ffffffff81588377 ffff880037bbc068
Call Trace:
 [<ffffffff81213800>] ? SyS_tee+0x400/0x400
 [<ffffffff81588377>] schedule+0x37/0x90
 [<ffffffff8158a805>] rwsem_down_read_failed+0xd5/0x120
 [<ffffffff8120cf64>] ? sync_inodes_sb+0x184/0x1e0
 [<ffffffff812d7b24>] call_rwsem_down_read_failed+0x14/0x30
 [<ffffffff8158a1d7>] ? down_read+0x17/0x20
 [<ffffffff811e49d4>] iterate_supers+0xa4/0x120
 [<ffffffff81213b94>] sys_sync+0x44/0xb0
 [<ffffffff8158bfae>] system_call_fastpath+0x12/0x71

umount          R  running task        0 23669  18676 0x00000004
 00000000000000cb ffff880108607d78 0000000000000000 000000000000020e
 0000000000000000 0000000000000000 ffff880108604000 ffff88040b49dbb0
 00000000000000e4 00000000000000ff 0000000000000000 ffff8800d972b800
Call Trace:
 [<ffffffffa00d13a9>] ? jbd2_log_do_checkpoint+0x19/0x4b0 [jbd2]
 [<ffffffffa00d13bd>] ? jbd2_log_do_checkpoint+0x2d/0x4b0 [jbd2]
 [<ffffffffa00d6520>] ? jbd2_journal_destroy+0x140/0x240 [jbd2]
 [<ffffffff810bc720>] ? wake_atomic_t_function+0x60/0x60
 [<ffffffffa019f6d7>] ? ext4_put_super+0x67/0x360 [ext4]
 [<ffffffff811e3216>] ? generic_shutdown_super+0x76/0x100
 [<ffffffff811e35d7>] ? kill_block_super+0x27/0x80
 [<ffffffff811e3949>] ? deactivate_locked_super+0x49/0x80
 [<ffffffff811e3dbc>] ? deactivate_super+0x6c/0x80
 [<ffffffff81201863>] ? cleanup_mnt+0x43/0xa0
 [<ffffffff81201912>] ? __cleanup_mnt+0x12/0x20
 [<ffffffff81095c54>] ? task_work_run+0xd4/0xf0
 [<ffffffff81015d25>] ? do_notify_resume+0x75/0x80
 [<ffffffff8158c17c>] ? int_signal+0x12/0x17

Looks like umount might be stuck in an infinite loop, when I run
another trace, it's slightly different:

umount          R  running task        0 23669  18676 0x00000004
 ffffffffffffff02 ffffffffa00d0f2e 0000000000000010 0000000000000292
 ffff880108607c98 0000000000000018 0000000000000000 ffff8800d972b800
 ffffffffffffff02 ffffffffa00d13c0 00000000f8eef941 0000000000000296
Call Trace:
 [<ffffffffa00d0f2e>] ? jbd2_cleanup_journal_tail+0xe/0xb0 [jbd2]
 [<ffffffffa00d13c0>] ? jbd2_log_do_checkpoint+0x30/0x4b0 [jbd2]
 [<ffffffffa00d13bd>] ? jbd2_log_do_checkpoint+0x2d/0x4b0 [jbd2]
 [<ffffffffa00d6518>] ? jbd2_journal_destroy+0x138/0x240 [jbd2]
 [<ffffffff810bc720>] ? wake_atomic_t_function+0x60/0x60
 [<ffffffffa019f6d7>] ? ext4_put_super+0x67/0x360 [ext4]
 [<ffffffff811e3216>] ? generic_shutdown_super+0x76/0x100
 [<ffffffff811e35d7>] ? kill_block_super+0x27/0x80
 [<ffffffff811e3949>] ? deactivate_locked_super+0x49/0x80
 [<ffffffff811e3dbc>] ? deactivate_super+0x6c/0x80
 [<ffffffff81201863>] ? cleanup_mnt+0x43/0xa0
 [<ffffffff81201912>] ? __cleanup_mnt+0x12/0x20
 [<ffffffff81095c54>] ? task_work_run+0xd4/0xf0
 [<ffffffff81015d25>] ? do_notify_resume+0x75/0x80
 [<ffffffff8158c17c>] ? int_signal+0x12/0x17

Thanks,
Adam.
