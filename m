From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Tue, 06 Jan 2015 10:31:44 +0100
Message-ID: <54ABAB80.70006@acm.org>
References: <5498389D.6070909@acm.org> <20141222184910.GB8054@redhat.com>
	<54999756.70303@acm.org>
	<1v2g6masssbu88ans1r6lres.1419354811001@email.android.com>
	<CAMM=eLd_A+fRBHDvcDqwF1a9co+G7XZvVhRyBd1AjxOdgjKhbA@mail.gmail.com>
	<549AB979.4050302@acm.org> <20141224182143.GA12922@redhat.com>
	<20141224185529.GA13246@redhat.com>
	<20141224192643.GA30461@redhat.com> <54A6DB1D.4030201@acm.org>
	<20150105213557.GA5030@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150105213557.GA5030@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On 01/05/15 22:35, Mike Snitzer wrote:
> On Fri, Jan 02 2015 at 12:53pm -0500,
> Bart Van Assche <bvanassche@acm.org> wrote:
>> Thanks, my tests confirm that this patch indeed fixes the issue I had
>> reported. Unfortunately this doesn't mean that the blk-mq multipath code
>> is already working perfectly. Most of the time I/O requests are
>> processed within the expected time but sometimes I/O processing takes
>> much more time than what I expected:
>>
>> # /usr/bin/time -f %e mkfs.xfs -f /dev/dm-0 >/dev/null
>> 0.02
>> # /usr/bin/time -f %e mkfs.xfs -f /dev/dm-0 >/dev/null
>> 0.02
>> # /usr/bin/time -f %e mkfs.xfs -f /dev/dm-0 >/dev/null
>> 8.68
>>
>> However, if I run the same command on the underlying device it always
>> completes within the expected time.
> 
> I don't have very large blk-mq devices, but I can work on that.
> How large is the blk-mq device in question?
> 
> Also, how much memory does the system have?  Is memory fragmented at
> all?  With this change the requests are cloned using memory allocated
> from block core's blk_get_request (rather than a dedicated mempool in DM
> core).
> 
> Any chance you could use 'perf record' to try to analyze where the
> kernel is spending its time?

Hello Mike,

The device used in this test was a tmpfs file with a size of 16 MB. That
file had been created as follows: dd if=/dev/zero of=/dev/vdisk bs=1M
count=16. The initiator and target systems did have enough memory to keep
this tmpfs file in RAM all the time (32 GB and 4 GB respectively).

For the runs that took much longer than expected the CPU load was low.
This probably means that the system was waiting for one or another I/O
timer to expire. The output triggered by "echo w > /proc/sysrq-trigger"
during a run that took longer than expected was as follows:

SysRq : Show Blocked State
  task                        PC stack   pid father
kdmwork-253:0   D ffff8807c1fd3b78     0 10396      2 0x00000000
 ffff8807c1fd3b78 ffff88083b6b6cc0 0000000000012ec0 ffff8807c1fd3fd8
 0000000000012ec0 ffff880824225aa0 ffff88083b6b6cc0 ffff88081b0cb2c0
 ffff88085fc537c8 ffff8807c1fd3c98 ffff8807f7a99d70 ffffe8ffffc43bc0
Call Trace:
 [<ffffffff814d5230>] io_schedule+0xa0/0x130
 [<ffffffff8125a3f7>] bt_get+0x117/0x1b0
 [<ffffffff81256580>] ? blk_mq_queue_enter+0x30/0x2a0
 [<ffffffff81094cf0>] ? prepare_to_wait_event+0x110/0x110
 [<ffffffff8125a76f>] blk_mq_get_tag+0x9f/0xd0
 [<ffffffff8125591b>] __blk_mq_alloc_request+0x1b/0x210
 [<ffffffff812571c9>] blk_mq_alloc_request+0x139/0x150
 [<ffffffff8124c16e>] blk_get_request+0x2e/0xe0
 [<ffffffff8109a60d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa07f7d0f>] __multipath_map.isra.15+0x1cf/0x210 [dm_multipath]
 [<ffffffffa07f7d6a>] multipath_clone_and_map+0x1a/0x20 [dm_multipath]
 [<ffffffffa039dbb5>] map_tio_request+0x1d5/0x3a0 [dm_mod]
 [<ffffffff8109a53d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
 [<ffffffff81075cbe>] kthread_worker_fn+0x7e/0x1b0
 [<ffffffff81075c40>] ? __init_kthread_worker+0x60/0x60
 [<ffffffff81075bc8>] kthread+0xf8/0x110
 [<ffffffff81075ad0>] ? kthread_create_on_node+0x210/0x210
 [<ffffffff814dacac>] ret_from_fork+0x7c/0xb0
 [<ffffffff81075ad0>] ? kthread_create_on_node+0x210/0x210
dmraid          D ffff8807f4cafc88     0 25099  25064 0x00000000
 ffff8807f4cafc88 ffff8807c0b52440 0000000000012ec0 ffff8807f4caffd8
 0000000000012ec0 ffffffff81a194e0 ffff8807c0b52440 ffff8807c09ec1c0
 ffff88085fc137c8 ffff88085ff8ce38 ffff8807f4cafd30 0000000000000082
Call Trace:
 [<ffffffff814d5990>] ? bit_wait+0x50/0x50
 [<ffffffff814d5230>] io_schedule+0xa0/0x130
 [<ffffffff814d59bc>] bit_wait_io+0x2c/0x50
 [<ffffffff814d578b>] __wait_on_bit_lock+0x4b/0xb0
 [<ffffffff8113b45a>] __lock_page_killable+0x9a/0xa0
 [<ffffffff81094d30>] ? autoremove_wake_function+0x40/0x40
 [<ffffffff8113da78>] generic_file_read_iter+0x408/0x640
 [<ffffffff8109a60d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811d5f57>] blkdev_read_iter+0x37/0x40
 [<ffffffff8119866e>] new_sync_read+0x7e/0xb0
 [<ffffffff81199858>] __vfs_read+0x18/0x50
 [<ffffffff81199916>] vfs_read+0x86/0x140
 [<ffffffff81199a19>] SyS_read+0x49/0xb0
 [<ffffffff814dad52>] system_call_fastpath+0x12/0x17

Bart.
