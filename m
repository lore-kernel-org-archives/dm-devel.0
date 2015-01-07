From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Wed, 07 Jan 2015 11:33:07 +0100
Message-ID: <54AD0B63.3010505@acm.org>
References: <54999756.70303@acm.org>
	<1v2g6masssbu88ans1r6lres.1419354811001@email.android.com>
	<CAMM=eLd_A+fRBHDvcDqwF1a9co+G7XZvVhRyBd1AjxOdgjKhbA@mail.gmail.com>
	<549AB979.4050302@acm.org> <20141224182143.GA12922@redhat.com>
	<20141224185529.GA13246@redhat.com>
	<20141224192643.GA30461@redhat.com> <54A6DB1D.4030201@acm.org>
	<20150105213557.GA5030@redhat.com> <54ABAB80.70006@acm.org>
	<20150106160553.GB10224@redhat.com> <54AC0A39.90801@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54AC0A39.90801@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On 01/06/15 17:15, Jens Axboe wrote:
> blk-mq request allocation is pretty much as optimized/fast as it can be.
> The slowdown must be due to one of two reasons:
>
> - A bug related to running out of requests, perhaps a missing queue run
> or something like that.
> - A smaller number of available requests, due to the requested queue depth.
>
> Looking at Barts results, it looks like it's usually fast, but sometimes
> very slow. That would seem to indicate it's option #1 above that is the
> issue. Bart, since this seems to wait for quite a bit, would it be
> possible to cat the 'tags' file for that queue when it is stuck like that?

Hello Jens,

Thanks for the assistance. Is this the output you were looking for ?

# dmsetup table /dev/dm-1
0 256000 multipath 0 0 2 1 service-time 0 1 2 8:32 1 1 service-time 0 1 
2 8:48 1 1

# ls -ld /dev/sd[cd]
brw-rw---- 1 root disk 8, 32 Jan  7 11:16 /dev/sdc
brw-rw---- 1 root disk 8, 48 Jan  7 11:16 /dev/sdd

# time mkfs.xfs -f /dev/dm-1 &
[ ... ]
real    4m12.101s

# for d in sdc sdd; do echo ==== $d; (cd /sys/block/$d/mq &&
   find|cut -c3-|grep tag|xargs grep -aH ''); done
==== sdc
0/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
0/tags:nr_free=62, nr_reserved=0
0/tags:active_queues=0
1/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
1/tags:nr_free=62, nr_reserved=0
1/tags:active_queues=1
2/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
2/tags:nr_free=62, nr_reserved=0
2/tags:active_queues=0
3/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
3/tags:nr_free=62, nr_reserved=0
3/tags:active_queues=0
4/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
4/tags:nr_free=62, nr_reserved=0
4/tags:active_queues=0
5/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
5/tags:nr_free=62, nr_reserved=0
5/tags:active_queues=0
==== sdd
0/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
0/tags:nr_free=62, nr_reserved=0
0/tags:active_queues=0
1/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
1/tags:nr_free=62, nr_reserved=0
1/tags:active_queues=0
2/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
2/tags:nr_free=62, nr_reserved=0
2/tags:active_queues=0
3/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
3/tags:nr_free=62, nr_reserved=0
3/tags:active_queues=0
4/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
4/tags:nr_free=62, nr_reserved=0
4/tags:active_queues=0
5/tags:nr_tags=62, reserved_tags=0, bits_per_word=3
5/tags:nr_free=62, nr_reserved=0
5/tags:active_queues=0

# dmesg -c >/dev/null; echo w >/proc/sysrq-trigger; dmesg -c
SysRq : Show Blocked State
   task                        PC stack   pid father
kdmwork-253:1   D ffff8807f3aafb78     0  3819      2 0x00000000
  ffff8807f3aafb78 ffff880832d9c880 0000000000013080 ffff8807f3aaffd8
  0000000000013080 ffff8807fdfac880 ffff880832d9c880 ffff88080066ea00
  ffff88085fd13988 ffff8807f3aafc98 ffff8807fd553ca0 ffffe8ffffd02f00
Call Trace:
  [<ffffffff814d5330>] io_schedule+0xa0/0x130
  [<ffffffff81259a47>] bt_get+0x117/0x1b0
  [<ffffffff810949f0>] ? prepare_to_wait_event+0x110/0x110
  [<ffffffff81259dbf>] blk_mq_get_tag+0x9f/0xd0
  [<ffffffff81254f7b>] __blk_mq_alloc_request+0x1b/0x210
  [<ffffffff81256819>] blk_mq_alloc_request+0x139/0x150
  [<ffffffff8124b7ee>] blk_get_request+0x2e/0xe0
  [<ffffffff8109a28d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffffa0671d0f>] __multipath_map.isra.15+0x1cf/0x210 [dm_multipath]
  [<ffffffffa0671d6a>] multipath_clone_and_map+0x1a/0x20 [dm_multipath]
  [<ffffffffa0354bb5>] map_tio_request+0x1d5/0x3a0 [dm_mod]
  [<ffffffff8109a1bd>] ? trace_hardirqs_on_caller+0xfd/0x1c0
  [<ffffffff81075b76>] kthread_worker_fn+0x86/0x1b0
  [<ffffffff81075af0>] ? __init_kthread_worker+0x60/0x60
  [<ffffffff81075a6f>] kthread+0xef/0x110
  [<ffffffff81075980>] ? kthread_create_on_node+0x210/0x210
  [<ffffffff814dad6c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81075980>] ? kthread_create_on_node+0x210/0x210
systemd-udevd   D ffff880835e13c88     0  5352    449 0x00000000
  ffff880835e13c88 ffff880832d9a440 0000000000013080 ffff880835e13fd8
  0000000000013080 ffff8808331bdaa0 ffff880832d9a440 ffff8807fc921dc0
  ffff88085fc13988 ffff88085ffd8438 ffff880835e13d30 0000000000000082
Call Trace:
  [<ffffffff814d5a90>] ? bit_wait+0x50/0x50
  [<ffffffff814d5330>] io_schedule+0xa0/0x130
  [<ffffffff814d5abc>] bit_wait_io+0x2c/0x50
  [<ffffffff814d588b>] __wait_on_bit_lock+0x4b/0xb0
  [<ffffffff8113ae0a>] __lock_page_killable+0x9a/0xa0
  [<ffffffff81094a30>] ? autoremove_wake_function+0x40/0x40
  [<ffffffff8113d428>] generic_file_read_iter+0x408/0x640
  [<ffffffff811d56c7>] blkdev_read_iter+0x37/0x40
  [<ffffffff81197e6e>] new_sync_read+0x7e/0xb0
  [<ffffffff81199058>] __vfs_read+0x18/0x50
  [<ffffffff81199116>] vfs_read+0x86/0x140
  [<ffffffff81199219>] SyS_read+0x49/0xb0
  [<ffffffff814dae12>] system_call_fastpath+0x12/0x17
mkfs.xfs        D ffff8807fd6c3a48     0  5355   2301 0x00000000
  ffff8807fd6c3a48 ffff8808351ddaa0 0000000000013080 ffff8807fd6c3fd8
  0000000000013080 ffffffff81a194e0 ffff8808351ddaa0 ffff8807fc921c00
  ffff88085fc13988 0000000000000000 0000000000000000 ffff88081aebfb40
Call Trace:
  [<ffffffff814d5330>] io_schedule+0xa0/0x130
  [<ffffffff811d9a12>] do_blockdev_direct_IO+0x1982/0x26d0
  [<ffffffff811d4b50>] ? I_BDEV+0x10/0x10
  [<ffffffff811da7ac>] __blockdev_direct_IO+0x4c/0x50
  [<ffffffff811d4b50>] ? I_BDEV+0x10/0x10
  [<ffffffff811d519e>] blkdev_direct_IO+0x4e/0x50
  [<ffffffff811d4b50>] ? I_BDEV+0x10/0x10
  [<ffffffff8113d709>] generic_file_direct_write+0xa9/0x170
  [<ffffffff8113da76>] __generic_file_write_iter+0x2a6/0x350
  [<ffffffff811d561f>] blkdev_write_iter+0x2f/0xa0
  [<ffffffff81197f21>] new_sync_write+0x81/0xb0
  [<ffffffff811986a7>] vfs_write+0xb7/0x1f0
  [<ffffffff811b857e>] ? __fget_light+0xbe/0xe0
  [<ffffffff81199452>] SyS_pwrite64+0x72/0xb0
  [<ffffffff814dae12>] system_call_fastpath+0x12/0x17

Bart.
