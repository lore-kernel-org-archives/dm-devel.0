From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: 4.4-rc1 dm-mpath infinite loop
Date: Fri, 20 Nov 2015 13:16:50 -0800
Message-ID: <564F8DC2.7080805@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

While testing the v4.4-rc1 dm-mpath driver with queue_without_daemon set 
to no in /etc/multipath.conf and after having stopped multipathd I 
noticed the following:
* Multiple kpartx processes were unkillable.
* Several blkid tasks got stuck (see also the blkid call trace below).
* Multiple kworker threads were consuming 100% CPU.

I hadn't seen this behavior with previous kernel versions.

The blkid call trace is as follows:

INFO: task blkid:13768 blocked for more than 120 seconds.
       Tainted: G            E   4.4.0-rc1+ #3
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
blkid           D ffff8803f76b3818     0 13768      1 0x00000006
  ffff8803f76b3818 ffff88045af31f40 ffff880438509f40 0000000000000046
  0000000000000046 000000003b9a0000 ffffffff81602720 0000000000000000
  ffffffffffffc000 ffffffff81d34f68 ffffffff810df4c1 ffffffff00000000
Call Trace:
  [<ffffffff81515d42>] schedule+0x42/0x90
  [<ffffffff81519e7f>] schedule_timeout+0x17f/0x1d0
  [<ffffffff81515290>] io_schedule_timeout+0x70/0xb0
  [<ffffffff81516451>] bit_wait_io+0x31/0x50
  [<ffffffff81516029>] __wait_on_bit_lock+0x69/0xa0
  [<ffffffff81110145>] __lock_page+0xa5/0xb0
  [<ffffffff81121fb8>] truncate_inode_pages_range+0x3d8/0x6b0
  [<ffffffff81122310>] truncate_inode_pages+0x10/0x20
  [<ffffffff811af6c4>] kill_bdev+0x34/0x40
  [<ffffffff811af741>] __blkdev_put+0x71/0x1b0
  [<ffffffff811af8da>] blkdev_put+0x5a/0x170
  [<ffffffff811afa0f>] blkdev_close+0x1f/0x30
  [<ffffffff81178ef3>] __fput+0xc3/0x200
  [<ffffffff811790b9>] ____fput+0x9/0x10
  [<ffffffff81076363>] task_work_run+0x63/0xb0
  [<ffffffff81059a7a>] do_exit+0x13a/0x3f0
  [<ffffffff81059d89>] do_group_exit+0x59/0xd0
  [<ffffffff81067eec>] get_signal+0x1ec/0x400
  [<ffffffff810058b0>] do_signal+0x20/0x110
  [<ffffffff810024ed>] syscall_return_slowpath+0x12d/0x190
  [<ffffffff8151b5b1>] int_ret_from_sys_call+0x25/0x9f
1 lock held by blkid/13768:
  #0:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811af70a>] 
__blkdev_put+0x3a/0x1b0

The perf tool reported the following call stack for the kworker threads:

      multipath_clone_and_map
      map_request
      dm_mq_queue_rq
      __blk_mq_run_hw_queue
      blk_mq_run_work_fn
      process_one_work
      worker_thread
      kthread
      ret_from_fork

Bart.
