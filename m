From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHv2 0/4] blk-mq support for dm multipath
Date: Fri, 12 Dec 2014 21:08:33 -0500
Message-ID: <20141213020833.GA21426@redhat.com>
References: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
	<alpine.LNX.2.00.1410281808390.4225@localhost.lm.intel.com>
	<20141028182627.GA28537@redhat.com>
	<20141205232542.GA1274@redhat.com>
	<20141206055351.GA2110@redhat.com>
	<20141206060939.GB2110@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141206060939.GB2110@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Dec 06 2014 at  1:09am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Sat, Dec 06 2014 at 12:53am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
>  
> > But in general this code needs _a lot_ more testing/review.
> > Sadly I cannot stage it for 3.19 inclusion.
> 
> FYI, even though the mpath device is created without crashing it hangs
> when IO is issued to it (mkfs.xfs /dev/mapper/mpathi):
> 
>  kernel: mkfs.xfs        D ffff88033fc34740     0  2792   2457 0x00000080
>  kernel: ffff880319057cb8 0000000000000082 ffff880327e84c80 0000000000014740
>  kernel: ffff880319057fd8 0000000000014740 ffff88032e644c80 ffff880327e84c80
>  kernel: ffff88033fc35058 ffff88033ff940e8 ffff880319057d48 0000000000000082
>  kernel: Call Trace:
>  kernel: [<ffffffff81633a50>] ? bit_wait+0x50/0x50
>  kernel: [<ffffffff8163325d>] io_schedule+0x9d/0x120
>  kernel: [<ffffffff81633a7c>] bit_wait_io+0x2c/0x50
>  kernel: [<ffffffff816337eb>] __wait_on_bit_lock+0x4b/0xb0
>  kernel: [<ffffffff81166da9>] __lock_page_killable+0xb9/0xe0
>  kernel: [<ffffffff810b1c20>] ? autoremove_wake_function+0x40/0x40
>  kernel: [<ffffffff81168e48>] generic_file_read_iter+0x3e8/0x610
>  kernel: [<ffffffff81213bf7>] blkdev_read_iter+0x37/0x40
>  kernel: [<ffffffff811dba1b>] new_sync_read+0x8b/0xd0
>  kernel: [<ffffffff811dc188>] vfs_read+0x98/0x170
>  kernel: [<ffffffff811dce65>] SyS_read+0x55/0xd0
>  kernel: [<ffffffff81637769>] system_call_fastpath+0x16/0x1b
> 
>  kernel: kdmwork-253:15  D ffff88033fc54740     0  2745      2 0x00000080
>  kernel: ffff88031910bce8 0000000000000046 ffff88032cedb960 0000000000014740
>  kernel: ffff88031910bfd8 0000000000014740 ffff88032e645610 ffff88032cedb960
>  kernel: ffff88033fc55058 ffff880329565420 ffff880327c4f870 ffff880327c4f800
>  kernel: Call Trace:
>  kernel: [<ffffffff8163325d>] io_schedule+0x9d/0x120
>  kernel: [<ffffffff812c47e8>] get_request+0x218/0x770
>  kernel: [<ffffffff810b1be0>] ? prepare_to_wait_event+0xf0/0xf0
>  kernel: [<ffffffff812c4dc7>] blk_get_request+0x87/0xe0
>  kernel: [<ffffffffa0195bb1>] multipath_map+0x121/0x1b0 [dm_multipath]
>  kernel: [<ffffffffa0001032>] map_tio_request+0x52/0x250 [dm_mod]
>  kernel: [<ffffffff81090be2>] kthread_worker_fn+0x82/0x1d0
>  kernel: [<ffffffff81090b60>] ? kthread_stop+0xe0/0xe0
>  kernel: [<ffffffff81090818>] kthread+0xd8/0xf0
>  kernel: [<ffffffff81090740>] ? kthread_create_on_node+0x1a0/0x1a0
>  kernel: [<ffffffff816376bc>] ret_from_fork+0x7c/0xb0
>  kernel: [<ffffffff81090740>] ? kthread_create_on_node+0x1a0/0x1a0

Pretty sure requests weren't completing due to deadlock because with non
blk-mq use-case special care _must_ be taken not to acquire the clone
request's queue lock in the completion path.  See the comment in
drivers/md/dm.c:end_clone_request()

I couldn't come up with a way of salvaging having the old request-based
path use blk_get_request() in .map_mq and blk_put_request() in .unmap_rq

Instead I've gone the different direction of training DM core to
conditionally use either:
1) old-style request cloning in terms of a DM mempool
or
2) new-style blk_get_request+blk_put_request in dm-mpath target

2 is obviously used if the backing device is using blk-mq.

I've published a rebased patchset here (BUT I haven't tested the blk-mq
support yet.. I _think_ it should work but it could easily crash due to
some silly oversight.  I'll test using virtio-blk in a guest on Monday):

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19-blk-mq
