From: Dongsu Park <dongsu.park@profitbricks.com>
Subject: blk-mq crash with dm-multipath in for-3.20/core
Date: Mon, 9 Feb 2015 17:38:56 +0100
Message-ID: <20150209163856.GA12781@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

during testing with the linux-block for-3.20/core branch, I hit a BUG
like below. It's reproducible by running xfstests/xfs/279.

Bisecting showed that the first bad commit is 6d6285c45f5a ("block:
require blk_rq_prep_clone() be given an initialized clone request").
With reverting this commit, the crash disappears.
The linux-dm's branch dm-for-3.20 works fine without crash too.

As pointed out already by Keith Busch in a thread, [1] that commit should
not be there in the first place. Commit 102e38b1030e ("dm: split
request structure out from dm_rq_target_io structure") from linux-dm tree
[2] is going to move the blk_rq_init() call again to __clone_rq().

So that commit 6d6285c45f5a should be either reverted, or moved to
linux-dm tree, doesn't it?

Cheers,
Dongsu

[1] https://www.redhat.com/archives/dm-devel/2015-January/msg00171.html
[2] https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=102e38b1030e883efc022dfdc7b7e7a3de70d1c5

------------[ cut here ]------------
kernel BUG at block/blk-core.c:2333!
RIP: 0010: [<ffffffff814c6858>] blk_dequeue_request+0x78/0x90
Call Trace:
 [<ffffffff814c6886>] blk_start_request+0x16/0x70
 [<ffffffff8169f9fa>] dm_start_request+0x1a/0x50
 [<ffffffff8169fce6>] dm_request_fn+0x2b6/0x3e0
 [<ffffffff814c0087>] __blk_run_queue+0x37/0x50
 [<ffffffff814c31ed>] queue_unplugged+0x5d/0x230
 [<ffffffff814c710c>] blk_flush_plug_list+0x1ac/0x230
 [<ffffffff814c7708>] blk_finish_plug+0x18/0x60
 [<ffffffff811baea1>] __do_page_cache_readahead+0x2b1/0x320
 [<ffffffff811bad55>] ? __do_page_cache_readahead+0x165/0x320
 [<ffffffff811baff2>] ondemand_readahead+0xe2/0x480
 [<ffffffff811ac3ff>] ? pagecache_get_page+0x2f/0x200
 [<ffffffff811bb4c1>] page_cache_sync_readahead+0x31/0x50
 [<ffffffff811ad5bc>] generic_file_read_iter+0x51c/0x630
 [<ffffffff811dd00e>] ? might_fault+0x5e/0xc0
 [<ffffffff81261e37>] blkdev_read_iter+0x37/0x40
 [<ffffffff8121fa4e>] new_sync_read+0x7e/0xb0
 [<ffffffff81220ce8>] __vfs_read+0x18/0x50
 [<ffffffff81220dad>] vfs_read+0x8d/0x150
 [<ffffffff81220eb9>] SyS_read+0x49/0xb0
 [<ffffffff817dce52>] system_call_fastpath+0x12/0x17
RIP  [<ffffffff814c6858>] blk_dequeue_request+0x78/0x90
 RSP <ffff88006e1eba68>
---[ end trace dcfc3d438518b1aa ]---
