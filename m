From: James Robertson <j@mesrobertson.com>
Subject: Re: kpartx mounted vmdk images and bad write performance
Date: Tue, 11 Dec 2012 00:09:19 +1100
Message-ID: <CAMALoy88tkoR7HK7UM5v93Rt6K03a27hYcZC9CJ4okg=ZMDYJA@mail.gmail.com>
References: <CAMALoy_KGkU9TyNeB_HZPK_Nm5xrpmMvVyPGT52mCSGA01kB+Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMALoy_KGkU9TyNeB_HZPK_Nm5xrpmMvVyPGT52mCSGA01kB+Q@mail.gmail.com>
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

It would appear related to USB, although tests to local storage were
not that great. As a test I ran dd to create a file on the mounted
partiton on a USB2 attached disk as follows:

> kpartx -av /mnt/backup/FITZVICVDP01/FITZVICVDP01_2-flat.vmdk
add map loop0p1 (254:4): 0 536860169 linear /dev/loop0 1
> mount /dev/mapper/loop0p1 /mnt/loop0p1
> dd if=/dev/zero of=/mnt/loop0p1/zerofile.tst bs=1k count=1700000

In another terminal I monitored it's progress, it got to 763M and
simply stopped increasing.  dd was still running in the other
terminal.  You can see the date is 10 minutes since the last mod time.

> date
Monday 10 December  23:28:09 EST 2012
> ls -lh /mnt/loop0p1/zerofile.tst
-rw-r--r-- 1 root root 763M Dec 10 23:18 /mnt/loop0p1/zerofile.tst

In dmesg these started being logged every 2 minutes.

[ 1680.648037] INFO: task kworker/3:0:3139 blocked for more than 120 seconds.
[ 1680.648086] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1680.648140] kworker/3:0     D ffff88012fd93780     0  3139      2 0x00000000
[ 1680.648144]  ffff88012706e300 0000000000000046 0000000700000000
ffff88012af5cf60
[ 1680.648149]  0000000000013780 ffff8801275effd8 ffff8801275effd8
ffff88012706e300
[ 1680.648153]  ffff880129f5e000 00000001810709c1 0000000000000202
ffff880129d62e80
[ 1680.648157] Call Trace:
[ 1680.648180]  [<ffffffffa0319a43>] ? xlog_wait+0x51/0x67 [xfs]
[ 1680.648186]  [<ffffffff8103f411>] ? try_to_wake_up+0x197/0x197
[ 1680.648200]  [<ffffffffa031c1e0>] ? _xfs_log_force_lsn+0x1cd/0x205 [xfs]
[ 1680.648215]  [<ffffffffa03194b6>] ? xfs_trans_commit+0x10a/0x205 [xfs]
[ 1680.648227]  [<ffffffffa02e6736>] ? xfs_reclaim_inode+0x22d/0x22d [xfs]
[ 1680.648239]  [<ffffffffa02e6770>] ? xfs_sync_worker+0x3a/0x6a [xfs]
[ 1680.648243]  [<ffffffff8105b04d>] ? process_one_work+0x163/0x284
[ 1680.648246]  [<ffffffff8105c022>] ? worker_thread+0xc2/0x145
[ 1680.648249]  [<ffffffff8105bf60>] ? manage_workers.isra.25+0x15b/0x15b
[ 1680.648253]  [<ffffffff8105f155>] ? kthread+0x76/0x7e
[ 1680.648258]  [<ffffffff81353c34>] ? kernel_thread_helper+0x4/0x10
[ 1680.648261]  [<ffffffff8105f0df>] ? kthread_worker_fn+0x139/0x139
[ 1680.648264]  [<ffffffff81353c30>] ? gs_change+0x13/0x13

---

More info was logged later on before dd finally completed.

[ 2400.648039] INFO: task kworker/3:0:3139 blocked for more than 120 seconds.
[ 2400.648063] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2400.648100] kworker/3:0     D ffff88012fd93780     0  3139      2 0x00000000
[ 2400.648105]  ffff88012706e300 0000000000000046 0000000700000000
ffff88012af5cf60
[ 2400.648111]  0000000000013780 ffff8801275effd8 ffff8801275effd8
ffff88012706e300
[ 2400.648115]  ffff880129f5e000 00000001810709c1 0000000000000202
ffff880129d62e80
[ 2400.648120] Call Trace:
[ 2400.648145]  [<ffffffffa0319a43>] ? xlog_wait+0x51/0x67 [xfs]
[ 2400.648151]  [<ffffffff8103f411>] ? try_to_wake_up+0x197/0x197
[ 2400.648168]  [<ffffffffa031c1e0>] ? _xfs_log_force_lsn+0x1cd/0x205 [xfs]
[ 2400.648185]  [<ffffffffa03194b6>] ? xfs_trans_commit+0x10a/0x205 [xfs]
[ 2400.648199]  [<ffffffffa02e6736>] ? xfs_reclaim_inode+0x22d/0x22d [xfs]
[ 2400.648213]  [<ffffffffa02e6770>] ? xfs_sync_worker+0x3a/0x6a [xfs]
[ 2400.648218]  [<ffffffff8105b04d>] ? process_one_work+0x163/0x284
[ 2400.648221]  [<ffffffff8105c022>] ? worker_thread+0xc2/0x145
[ 2400.648225]  [<ffffffff8105bf60>] ? manage_workers.isra.25+0x15b/0x15b
[ 2400.648229]  [<ffffffff8105f155>] ? kthread+0x76/0x7e
[ 2400.648234]  [<ffffffff81353c34>] ? kernel_thread_helper+0x4/0x10
[ 2400.648238]  [<ffffffff8105f0df>] ? kthread_worker_fn+0x139/0x139
[ 2400.648241]  [<ffffffff81353c30>] ? gs_change+0x13/0x13
[ 2400.648250] INFO: task dd:3376 blocked for more than 120 seconds.
[ 2400.648282] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2400.648334] dd              D ffff88012fd93780     0  3376   2715 0x00000000
[ 2400.648337]  ffff88012755aa70 0000000000000082 ffff880100000000
ffff88012af5cf60
[ 2400.648342]  0000000000013780 ffff8801290dffd8 ffff8801290dffd8
ffff88012755aa70
[ 2400.648346]  ffffffff8101361a 0000000181065d11 ffff8801294d5c90
ffff88012fd93fd0
[ 2400.648349] Call Trace:
[ 2400.648353]  [<ffffffff8101361a>] ? read_tsc+0x5/0x14
[ 2400.648357]  [<ffffffff810b41eb>] ? lock_page+0x20/0x20
[ 2400.648362]  [<ffffffff8134ba54>] ? io_schedule+0x59/0x71
[ 2400.648365]  [<ffffffff810b41f1>] ? sleep_on_page+0x6/0xa
[ 2400.648368]  [<ffffffff8134be97>] ? __wait_on_bit+0x3e/0x71
[ 2400.648371]  [<ffffffff810b432d>] ? wait_on_page_bit+0x6e/0x73
[ 2400.648374]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[ 2400.648377]  [<ffffffff8105f7d1>] ? autoremove_wake_function+0x2a/0x2a
[ 2400.648381]  [<ffffffff810b4ba6>] ? grab_cache_page_write_begin+0x9c/0xae
[ 2400.648385]  [<ffffffff8111dc1f>] ? block_write_end+0x57/0x62
[ 2400.648388]  [<ffffffff8111e22c>] ? block_write_begin+0x22/0x72
[ 2400.648397]  [<ffffffffa02d79d9>] ? xfs_get_blocks_direct+0xb/0xb [xfs]
[ 2400.648406]  [<ffffffffa02d8398>] ? xfs_vm_write_begin+0x30/0x51 [xfs]
[ 2400.648410]  [<ffffffff810b467b>] ? generic_file_buffered_write+0x10f/0x259
[ 2400.648421]  [<ffffffffa02dcb67>] ?
xfs_file_buffered_aio_write+0x10b/0x15c [xfs]
[ 2400.648431]  [<ffffffffa02dcd28>] ? xfs_file_aio_write+0x170/0x20c [xfs]
[ 2400.648435]  [<ffffffff810f9450>] ? do_sync_write+0xb4/0xec
[ 2400.648438]  [<ffffffff810363d8>] ? should_resched+0x5/0x23
[ 2400.648442]  [<ffffffff8134b7ff>] ? _cond_resched+0x7/0x1c
[ 2400.648446]  [<ffffffff81163719>] ? security_file_permission+0x16/0x2d
[ 2400.648449]  [<ffffffff810f9b41>] ? vfs_write+0xa2/0xe9
[ 2400.648452]  [<ffffffff810f9d1e>] ? sys_write+0x45/0x6b
[ 2400.648456]  [<ffffffff81351ad2>] ? system_call_fastpath+0x16/0x1b
[ 2520.648039] INFO: task kworker/3:0:3139 blocked for more than 120 seconds.
[ 2520.648076] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2520.648128] kworker/3:0     D ffff88012fd93780     0  3139      2 0x00000000
[ 2520.648134]  ffff88012706e300 0000000000000046 0000000700000000
ffff88012af5cf60
[ 2520.648139]  0000000000013780 ffff8801275effd8 ffff8801275effd8
ffff88012706e300
[ 2520.648144]  ffff880129f5e000 00000001810709c1 0000000000000202
ffff880129d62e80
[ 2520.648149] Call Trace:
[ 2520.648173]  [<ffffffffa0319a43>] ? xlog_wait+0x51/0x67 [xfs]
[ 2520.648179]  [<ffffffff8103f411>] ? try_to_wake_up+0x197/0x197
[ 2520.648196]  [<ffffffffa031c1e0>] ? _xfs_log_force_lsn+0x1cd/0x205 [xfs]
[ 2520.648216]  [<ffffffffa03194b6>] ? xfs_trans_commit+0x10a/0x205 [xfs]
[ 2520.648226]  [<ffffffffa02e6736>] ? xfs_reclaim_inode+0x22d/0x22d [xfs]
[ 2520.648236]  [<ffffffffa02e6770>] ? xfs_sync_worker+0x3a/0x6a [xfs]
[ 2520.648240]  [<ffffffff8105b04d>] ? process_one_work+0x163/0x284
[ 2520.648243]  [<ffffffff8105c022>] ? worker_thread+0xc2/0x145
[ 2520.648245]  [<ffffffff8105bf60>] ? manage_workers.isra.25+0x15b/0x15b
[ 2520.648248]  [<ffffffff8105f155>] ? kthread+0x76/0x7e
[ 2520.648253]  [<ffffffff81353c34>] ? kernel_thread_helper+0x4/0x10
[ 2520.648256]  [<ffffffff8105f0df>] ? kthread_worker_fn+0x139/0x139
[ 2520.648258]  [<ffffffff81353c30>] ? gs_change+0x13/0x13


I let dd continue to run and eventually it finished with abysmal
results (this is the output of the command at the top):

> dd if=/dev/zero of=/mnt/loop0p1/zerofile.tst bs=1k count=1700000
1700000+0 records in
1700000+0 records out
1740800000 bytes (1.7 GB) copied, 1362.68 s, 1.3 MB/s

> ls -lh /mnt/loop0p1/zerofile.tst
-rw-r--r-- 1 root root 1.7G Dec 10 23:41 /mnt/loop0p1/zerofile.tst

I had already copied the same vmdk to the local server file system and
repeated the tests.  No errors were logged to dmesg.

> kpartx -av /var/data/FITZVICVDP01_2-flat.vmdk
add map loop0p1 (254:4): 0 536860169 linear /dev/loop0 1
> mount /dev/mapper/loop0p1 /mnt/loop0p1
> dd if=/dev/zero of=/mnt/loop0p1/zerofile.tst bs=1k count=1700000
1700000+0 records in
1700000+0 records out
1740800000 bytes (1.7 GB) copied, 31.867 s, 54.6 MB/s

As a comparison...

Writing direct to the USB disk is about right for USB2.

> dd if=/dev/zero of=/mnt/backup/zerofile.tst bs=1k count=1700000
1700000+0 records in
1700000+0 records out
1740800000 bytes (1.7 GB) copied, 67.1975 s, 25.9 MB/s

And to the servers disk - I should note that this is alot faster than
the test to the mounted vmdk on the servers disk above - not sure what
to make of that.

> dd if=/dev/zero of=/var/data/zerofile.tst bs=1k count=1700000
1700000+0 records in
1700000+0 records out
1740800000 bytes (1.7 GB) copied, 5.61148 s, 310 MB/s

Thanks
