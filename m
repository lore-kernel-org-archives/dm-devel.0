From: Bart Van Assche <bvanassche@acm.org>
Subject: v3.15 dm-mpath regression: cable pull test causes I/O
	hang
Date: Fri, 27 Jun 2014 15:02:26 +0200
Message-ID: <53AD6B62.2020407@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

While running a cable pull simulation test with dm_multipath on top of
the SRP initiator driver I noticed that after a few iterations I/O locks
up instead of dm_multipath processing the path failure properly (see also
below for a call trace). At least kernel versions 3.15 and 3.16-rc2 are
vulnerable. This issue does not occur with kernel 3.14. I have tried to
bisect this but gave up when I noticed that I/O locked up completely with
a kernel built from git commit ID e809917735ebf1b9a56c24e877ce0d320baee2ec
(dm mpath: push back requests instead of queueing). But with the bisect I
have been able to narrow down this issue to one of the patches in "Merge
tag 'dm-3.15-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/
device-mapper/linux-dm". Does anyone have a suggestion how to analyze this
further or how to fix this ?

Thanks,

Bart.

systemd-udevd   D ffff880831b58000     0  9926    356 0x00000006
 ffff8807f8bb79b8 0000000000000002 ffff880831b58000 ffff8807f8bb7fd8
 00000000000131c0 00000000000131c0 ffff88083b490000 ffff88085fc53ad0
 ffff88085ff6bf38 ffff8807f8bb7a40 0000000000000002 ffffffff81135bd0
Call Trace:
 [<ffffffff814bba8d>] io_schedule+0x9d/0x130
 [<ffffffff81135bde>] sleep_on_page+0xe/0x20
 [<ffffffff814bc0d8>] __wait_on_bit_lock+0x48/0xb0
 [<ffffffff81135cea>] __lock_page+0x6a/0x70
 [<ffffffff811471df>] truncate_inode_pages_range+0x3ff/0x690
 [<ffffffff81147485>] truncate_inode_pages+0x15/0x20
 [<ffffffff811d2f85>] kill_bdev+0x35/0x40
 [<ffffffff811d4509>] __blkdev_put+0x69/0x1b0
 [<ffffffff811d4fb0>] blkdev_put+0x50/0x160
 [<ffffffff811d5175>] blkdev_close+0x25/0x30
 [<ffffffff81199eda>] __fput+0xea/0x1f0
 [<ffffffff8119a02e>] ____fput+0xe/0x10
 [<ffffffff81074d9c>] task_work_run+0xac/0xe0
 [<ffffffff8104ff37>] do_exit+0x2c7/0xc60
 [<ffffffff81051c7c>] do_group_exit+0x4c/0xc0
 [<ffffffff81064261>] get_signal_to_deliver+0x2e1/0x940
 [<ffffffff81002528>] do_signal+0x48/0x630
 [<ffffffff81002b81>] do_notify_resume+0x71/0xc0
 [<ffffffff814c1918>] int_signal+0x12/0x17
