From: Bharata B Rao <bharata.rao@gmail.com>
Subject: Max length limitation with BLKZEROOUT on dm device ?
Date: Mon, 1 Jul 2013 14:34:10 +0530
Message-ID: <CAGZKiBoyAZcCyMKT1yjwR+79JCfWj2cJ4TWkXojORS44Baz_Bw@mail.gmail.com>
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
To: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi,

While experimenting on zeroing out a dm device from a storage that
supports WRITE SAME, I see the below warnings from kernel (3.10.0):

******************
INFO: task a.out:21365 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
a.out           D ffffffff8182d620     0 21365  19945 0x00000080
ffff882079321bf8 0000000000000086 ffff882079321fd8 0000000000013fc0
ffff882079320010 0000000000013fc0 0000000000013fc0 0000000000013fc0
ffff882079321fd8 0000000000013fc0 ffff882032a6eb10 ffff8810795ea0c0
Call Trace:
[<ffffffff816426f9>] schedule+0x29/0x70
[<ffffffff81640945>] schedule_timeout+0x195/0x220
[<ffffffff812ad777>] ? __blk_run_queue+0x37/0x50
[<ffffffff812af53f>] ? blk_queue_bio+0x2ff/0x3b0
[<ffffffff81064859>] ? read_tsc+0x9/0x20
[<ffffffff810f5ebc>] ? ktime_get_ts+0x4c/0xf0
[<ffffffff81641c4f>] io_schedule_timeout+0x9f/0x100
[<ffffffff812ae44a>] ? generic_make_request+0xca/0x100
[<ffffffff81642aec>] wait_for_completion_io+0xdc/0x110
[<ffffffff810d8fb0>] ? try_to_wake_up+0x2b0/0x2b0
[<ffffffff812b5c3c>] blkdev_issue_write_same+0x1bc/0x1d0
[<ffffffff812b5cfd>] blkdev_issue_zeroout+0xad/0x120
[<ffffffff812b6c68>] blkdev_ioctl+0x728/0x7b0
[<ffffffff8120296c>] block_ioctl+0x3c/0x40
[<ffffffff811ddb89>] do_vfs_ioctl+0x89/0x350
[<ffffffff811ddef1>] SyS_ioctl+0xa1/0xb0
[<ffffffff8164ca99>] system_call_fastpath+0x16/0x1b
******************

My test program looks like this:

{
unsigned long arg[2] = {0, 21474836480}; /* len = 20G */
fd = open("/dev/mapper/ws_vg-lvol0", O_RDWR);
ioctl(fd, BLKZEROOUT, &arg);
}

# ls -l /dev/mapper/ws_vg-lvol0
lrwxrwxrwx. 1 root root 8 Jul  1 12:25 /dev/mapper/ws_vg-lvol0 -> ../dm-17

# cat /sys/block/dm-17/queue/write_same_max_bytes
268435456

I don't see such messages when len is 512M, 1G, 10G or 15G, but with
20G, such messages are seen.

Though I don't see any limitation on the number of bytes that could be
zeroed out from a single BLKZEROOUT ioctl call, could this be the
result of using a len as large as 20G in a single ioctl ?

Regards,
Bharata.
-- 
http://raobharata.wordpress.com/
