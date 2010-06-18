From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: 2.6.35 causes deadlock when snapshotting root lv
Date: Fri, 18 Jun 2010 14:23:25 -0500
Message-ID: <4C1BC7AD.1060900@sandeen.net>
References: <4C1A2839.5010407@cfl.rr.com> <20100617142731.GA10071@redhat.com> <4C1A4A74.9070105@cfl.rr.com> <20100617162747.GA21336@redhat.com> <4C1ACBF1.3050603@cfl.rr.com> <4C1BC125.4090902@sandeen.net> <4C1BC6D0.2030203@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C1BC6D0.2030203@sandeen.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
List-Id: dm-devel.ids

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> Phillip Susi wrote:
>>> On 06/17/2010 12:27 PM, Mike Snitzer wrote:
>>>>>> http://git.kernel.org/linus/18e9e5104fcd9a9
>>>>>> http://git.kernel.org/linus/6b0310fbf087ad6
>>>>> Yes, these do look suspicious.  I'll test reverting them tonight.
>>>> OK, I'd suggest reverting the VFS change (18e9e5104fcd9a9) first.
>>> Turns out it was 6b0310fbf087ad6 that did it.  CCing Eric Sandeen since
>>> he wrote it.  Eric, this patch seems to cause a deadlock when taking an
>>> lvm snapshot of the root lv.  Any idea why?
>> I'll look.  A sysrq-w when it hangs up would probably be enlightening...
>>
>> -Eric
> 
> FWIW simple freeze/unfreeze works for me, and lvm snap on a non-root ext4
> partition seems to as well.  I'm out for a few days and probably won't
> get a root lv set up to test anytime soon.  If you can provide sysrq-w
> output that probably will be a big help if it doesn't end up being obvious
> by inspection.  :)

Spoke too soon.  A little active IO at time of snap did the trick.

SysRq : Show Blocked State
  task                        PC stack   pid father
jbd2/dm-2-8   D 0000000000000003     0  1297      2 0x00000080
 ffff88013bae8800 0000000000000046 0000000000000000 ffffffff81128046
 ffff8800ad876800 ffff8800ad876bb0 00000001007af71d 0000000000000000
 0000000000000000 ffff8800ad871024 ffff8800baea1d70 ffff8800ae01ec70
Call Trace:
 [<ffffffff81128046>] ? sync_dirty_buffer+0x7b/0x96
 [<ffffffffa01924af>] ? jbd2_journal_commit_transaction+0x249/0x13e2 [jbd2]
 [<ffffffff8106f420>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8100fd47>] ? __switch_to+0xc3/0x1ec
 [<ffffffff81049489>] ? finish_task_switch+0x4c/0x72
 [<ffffffff81042135>] ? need_resched+0x1a/0x23
 [<ffffffff810605d4>] ? lock_timer_base+0x26/0x4b
 [<ffffffff81060661>] ? try_to_del_timer_sync+0x68/0x74
 [<ffffffffa0199194>] ? kjournald2+0x110/0x33b [jbd2]
 [<ffffffff8106f420>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffffa0199084>] ? kjournald2+0x0/0x33b [jbd2]
 [<ffffffff8106f0d4>] ? kthread+0x65/0x6d
 [<ffffffff81011b0a>] ? child_rip+0xa/0x20
 [<ffffffff8106f06f>] ? kthread+0x0/0x6d
 [<ffffffff81011b00>] ? child_rip+0x0/0x20
dd            D 0000000000000001     0  2548  17647 0x00000080
 ffff88013ba5c800 0000000000000086 0000000000000000 ffff8800bd889af8
 ffff8800be8df000 ffff8800be8df3b0 00000001007af709 0000000000000000
 0000000000000000 ffff88010fbf3400 ffff88010fbf3658 ffff88003e9f4c28
Call Trace:
 [<ffffffffa034ec97>] ? ext4_journal_start_sb+0x84/0x105 [ext4]
 [<ffffffff8106f420>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81125ccb>] ? __block_commit_write+0xa4/0xb3
 [<ffffffffa033ddc1>] ? ext4_dirty_inode+0x13/0x3f [ext4]
 [<ffffffff811208dd>] ? __mark_inode_dirty+0x25/0x11e
 [<ffffffff81125e57>] ? generic_write_end+0x4d/0x6a
 [<ffffffffa033eee3>] ? ext4_da_write_end+0x224/0x28c [ext4]
 [<ffffffffa033d82a>] ? ext4_da_get_block_prep+0x0/0x2ee [ext4]
 [<ffffffff810bfe86>] ? generic_file_buffered_write+0x164/0x226
 [<ffffffff8111ceda>] ? generic_getxattr+0x4c/0x59
 [<ffffffff810c02cf>] ? __generic_file_aio_write+0x25d/0x2b1
 [<ffffffff81042143>] ? should_resched+0x5/0x25
 [<ffffffff810c037c>] ? generic_file_aio_write+0x59/0xa1
 [<ffffffff8110391f>] ? do_sync_write+0xc9/0x10c
 [<ffffffff8106f420>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81104026>] ? vfs_write+0xa9/0x101
 [<ffffffff81104b4d>] ? sys_write+0x45/0x6b
 [<ffffffff81010a82>] ? system_call_fastpath+0x16/0x1b
lvcreate      D 0000000000000002     0  2550  17647 0x00000080
 ffff88013ba5e800 0000000000000086 0000000000000000 ffff8800ad8710c8
 ffff8800be8df800 ffff8800be8dfbb0 00000001007af718 0000000000000000
 0000000000000000 ffff8800ad871024 ffff8800ad871000 ffff8800ad871098
Call Trace:
 [<ffffffffa00a409f>] ? dev_suspend+0x0/0x1c5 [dm_mod]
 [<ffffffffa01981da>] ? jbd2_log_wait_commit+0x112/0x163 [jbd2]
 [<ffffffff8106f420>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffffa0198fb0>] ? jbd2_journal_start_commit+0x34/0x6b [jbd2]
 [<ffffffffa034e349>] ? ext4_sync_fs+0x74/0x81 [ext4]
 [<ffffffff8114a78c>] ? sync_quota_sb+0x45/0xe1
 [<ffffffff8112392d>] ? __sync_filesystem+0x3d/0x70
 [<ffffffff8112ae48>] ? freeze_bdev+0x8a/0x111
 [<ffffffffa00a0898>] ? dm_suspend+0x8a/0x175 [dm_mod]
 [<ffffffffa00a40fa>] ? dev_suspend+0x5b/0x1c5 [dm_mod]
 [<ffffffffa00a4b71>] ? dm_ctl_ioctl+0x22f/0x293 [dm_mod]
 [<ffffffff8103ed00>] ? place_entity+0x6e/0x95
 [<ffffffff810435ce>] ? __dequeue_entity+0x1b/0x2f
 [<ffffffff811115f9>] ? vfs_ioctl+0x21/0x6b
 [<ffffffff81111b3d>] ? do_vfs_ioctl+0x487/0x4da
 [<ffffffff8103e55a>] ? pick_next_task+0x1b/0x3c
 [<ffffffff81042135>] ? need_resched+0x1a/0x23
 [<ffffffff813b24c8>] ? thread_return+0x9b/0xb2
 [<ffffffff81111be1>] ? sys_ioctl+0x51/0x70
 [<ffffffff81010a82>] ? system_call_fastpath+0x16/0x1b
