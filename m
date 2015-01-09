From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Fri, 9 Jan 2015 14:49:56 -0500
Message-ID: <20150109194955.GA32641@redhat.com>
References: <20141224182143.GA12922@redhat.com>
	<20141224185529.GA13246@redhat.com>
	<20141224192643.GA30461@redhat.com> <54A6DB1D.4030201@acm.org>
	<20150105213557.GA5030@redhat.com> <54ABAB80.70006@acm.org>
	<20150106160553.GB10224@redhat.com> <54AC0A39.90801@kernel.dk>
	<54AD0B63.3010505@acm.org>
	<alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>, Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 07 2015 at  3:40pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Wed, 7 Jan 2015, Bart Van Assche wrote:
> >On 01/06/15 17:15, Jens Axboe wrote:
> >>blk-mq request allocation is pretty much as optimized/fast as it can be.
> >>The slowdown must be due to one of two reasons:
> >>
> >>- A bug related to running out of requests, perhaps a missing queue run
> >>or something like that.
> >>- A smaller number of available requests, due to the requested queue depth.
> >>
> >>Looking at Barts results, it looks like it's usually fast, but sometimes
> >>very slow. That would seem to indicate it's option #1 above that is the
> >>issue. Bart, since this seems to wait for quite a bit, would it be
> >>possible to cat the 'tags' file for that queue when it is stuck like that?
> >
> >Hello Jens,
> >
> >Thanks for the assistance. Is this the output you were looking for
> 
> I'm a little confused by the later comments given the below data. It says
> multipath_clone_and_map() is stuck at bt_get, but that doesn't block
> unless there are no tags available. The tags should be coming from one
> of dm-1's path queues, and I'm assuming these queues are provided by sdc
> and sdd. All their tags are free, so that looks like a missing wake_up
> when the queue idles.

Like I said in an earlier email, I cannot reproduce Bart's hangs running
mkfs.xfs against a multipath device that is built ontop of a virtio
device in a KVM guest.

But I can hit __bt_get() failures on the virtio-blk device that I'm
using for the root device on this guest.  Bart I'd be interested to see
what you get when running the attached debug patch (likely will just
echo the same type of info you've already provided).

There does appear to be something weird going on with bt_get().  With
the debug patch I'm seeing the following when I simply run "make install" 
of the kernel (it'll run dracut to build the initramfs, etc):

You'll note that in all instances where __bt_get() returns -1 nr_free isn't 0.

[  441.332886] bt_get: __bt_get() returned -1
[  441.336246] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
[  441.338368] nr_free=128, nr_reserved=0
[  441.340076] active_queues=0
[  441.341636] CPU: 2 PID: 190 Comm: jbd2/vda3-8 Tainted: G        W      3.18.0+ #18
[  441.343897] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  441.345904]  0000000000000000 0000000012f1ab3d ffff8801198cb938 ffffffff8168b8fb
[  441.348283]  0000000000000000 00000000ffffffff ffff8801198cb9b8 ffffffff81307f53
[  441.350645]  0000000000000000 ffffffff81304bd8 0000000000000000 ffff8800358e43b0
[  441.352996] Call Trace:
[  441.354544]  [<ffffffff8168b8fb>] dump_stack+0x4c/0x65
[  441.356472]  [<ffffffff81307f53>] bt_get+0xc3/0x210
[  441.358346]  [<ffffffff81304bd8>] ? blk_mq_queue_enter+0x38/0x220
[  441.360409]  [<ffffffff810bfc20>] ? prepare_to_wait_event+0x110/0x110
[  441.362524]  [<ffffffff813083af>] blk_mq_get_tag+0xbf/0xf0
[  441.364480]  [<ffffffff81303a4b>] __blk_mq_alloc_request+0x1b/0x210
[  441.366536]  [<ffffffff813054f0>] blk_mq_map_request+0xd0/0x240
[  441.368542]  [<ffffffff81306b2a>] blk_sq_make_request+0x9a/0x3b0
[  441.370564]  [<ffffffff812f6f44>] ? generic_make_request_checks+0x2a4/0x410
[  441.372719]  [<ffffffff8118bb95>] ? mempool_alloc_slab+0x15/0x20
[  441.374725]  [<ffffffff812f7190>] generic_make_request+0xe0/0x130
[  441.376746]  [<ffffffff812f7257>] submit_bio+0x77/0x150
[  441.378642]  [<ffffffff812f1e96>] ? bio_alloc_bioset+0x1d6/0x330
[  441.380648]  [<ffffffff8123d6e9>] _submit_bh+0x119/0x170
[  441.382552]  [<ffffffff8123d750>] submit_bh+0x10/0x20
[  441.384460]  [<ffffffffa015ab34>] jbd2_journal_commit_transaction+0x774/0x1b90 [jbd2]
[  441.386763]  [<ffffffff816948f6>] ? _raw_spin_unlock_irqrestore+0x36/0x70
[  441.388903]  [<ffffffff810eccd5>] ? del_timer_sync+0x5/0xf0
[  441.390864]  [<ffffffffa015fa24>] kjournald2+0xd4/0x2a0 [jbd2]
[  441.392860]  [<ffffffff810bfc20>] ? prepare_to_wait_event+0x110/0x110
[  441.394952]  [<ffffffffa015f950>] ? commit_timeout+0x10/0x10 [jbd2]
[  441.397054]  [<ffffffff8109a3f7>] kthread+0x107/0x120
[  441.398948]  [<ffffffff8109a2f0>] ? kthread_create_on_node+0x240/0x240
[  441.401053]  [<ffffffff8169533c>] ret_from_fork+0x7c/0xb0
[  441.403003]  [<ffffffff8109a2f0>] ? kthread_create_on_node+0x240/0x240
[  446.719847]
[  446.719847] bt_get: __bt_get() returned -1
[  446.724288] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
[  446.727624] nr_free=128, nr_reserved=0
[  446.730070] active_queues=0
[  446.732347] CPU: 2 PID: 190 Comm: jbd2/vda3-8 Tainted: G        W      3.18.0+ #18
[  446.735856] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  446.738912]  0000000000000000 0000000012f1ab3d ffff8801198cb938 ffffffff8168b8fb
[  446.742712]  0000000000000000 00000000ffffffff ffff8801198cb9b8 ffffffff81307f53
[  446.746464]  0000000000000000 ffffffff81304bd8 0000000000000000 ffff8800358e43b0
[  446.750217] Call Trace:
[  446.752287]  [<ffffffff8168b8fb>] dump_stack+0x4c/0x65
[  446.755089]  [<ffffffff81307f53>] bt_get+0xc3/0x210
[  446.757844]  [<ffffffff81304bd8>] ? blk_mq_queue_enter+0x38/0x220
[  446.760964]  [<ffffffff810bfc20>] ? prepare_to_wait_event+0x110/0x110
[  446.764105]  [<ffffffff813083af>] blk_mq_get_tag+0xbf/0xf0
[  446.766956]  [<ffffffff81303a4b>] __blk_mq_alloc_request+0x1b/0x210
[  446.770087]  [<ffffffff813054f0>] blk_mq_map_request+0xd0/0x240
[  446.773151]  [<ffffffff81306b2a>] blk_sq_make_request+0x9a/0x3b0
[  446.776208]  [<ffffffff812f6f44>] ? generic_make_request_checks+0x2a4/0x410
[  446.779576]  [<ffffffff8118bb95>] ? mempool_alloc_slab+0x15/0x20
[  446.782655]  [<ffffffff812f7190>] generic_make_request+0xe0/0x130
[  446.785727]  [<ffffffff812f7257>] submit_bio+0x77/0x150
[  446.788477]  [<ffffffff812f1e96>] ? bio_alloc_bioset+0x1d6/0x330
[  446.791533]  [<ffffffff8123d6e9>] _submit_bh+0x119/0x170
[  446.794317]  [<ffffffff8123d750>] submit_bh+0x10/0x20
[  446.797051]  [<ffffffffa015ab34>] jbd2_journal_commit_transaction+0x774/0x1b90 [jbd2]
[  446.800564]  [<ffffffff816948f6>] ? _raw_spin_unlock_irqrestore+0x36/0x70
[  446.803908]  [<ffffffff810eccd5>] ? del_timer_sync+0x5/0xf0
[  446.806922]  [<ffffffffa015fa24>] kjournald2+0xd4/0x2a0 [jbd2]
[  446.810019]  [<ffffffff810bfc20>] ? prepare_to_wait_event+0x110/0x110
[  446.813177]  [<ffffffffa015f950>] ? commit_timeout+0x10/0x10 [jbd2]
[  446.816362]  [<ffffffff8109a3f7>] kthread+0x107/0x120
[  446.819165]  [<ffffffff8109a2f0>] ? kthread_create_on_node+0x240/0x240
[  446.822359]  [<ffffffff8169533c>] ret_from_fork+0x7c/0xb0
[  446.825195]  [<ffffffff8109a2f0>] ? kthread_create_on_node+0x240/0x240
[  471.843384]
[  471.843384] bt_get: __bt_get() returned -1
[  471.847400] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
[  471.849502] nr_free=127, nr_reserved=0
[  471.851226] active_queues=0
[  471.852765] CPU: 3 PID: 6 Comm: kworker/u8:0 Tainted: G        W      3.18.0+ #18
[  471.855007] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  471.857018] Workqueue: writeback bdi_writeback_workfn (flush-253:0)
[  471.859133]  0000000000000000 00000000bbb0d8f3 ffff88011ab8b6c8 ffffffff8168b8fb
[  471.861481]  0000000000000000 00000000ffffffff ffff88011ab8b748 ffffffff81307f53
[  471.863826]  0000000000000000 ffffffff81304bd8 0000000000000000 ffff88011ab80000
[  471.866181] Call Trace:
[  471.867703]  [<ffffffff8168b8fb>] dump_stack+0x4c/0x65
[  471.869628]  [<ffffffff81307f53>] bt_get+0xc3/0x210
[  471.871494]  [<ffffffff81304bd8>] ? blk_mq_queue_enter+0x38/0x220
[  471.873539]  [<ffffffff810bfc20>] ? prepare_to_wait_event+0x110/0x110
[  471.875640]  [<ffffffff813083af>] blk_mq_get_tag+0xbf/0xf0
[  471.877598]  [<ffffffff81303a4b>] __blk_mq_alloc_request+0x1b/0x210
[  471.879653]  [<ffffffff813054f0>] blk_mq_map_request+0xd0/0x240
[  471.881645]  [<ffffffff81306b2a>] blk_sq_make_request+0x9a/0x3b0
[  471.883653]  [<ffffffff812f6f44>] ? generic_make_request_checks+0x2a4/0x410
[  471.885798]  [<ffffffff812f7190>] generic_make_request+0xe0/0x130
[  471.887807]  [<ffffffff812f7257>] submit_bio+0x77/0x150
[  471.889699]  [<ffffffffa017ebb5>] ? ext4_writepages+0xa75/0xde0 [ext4]
[  471.891792]  [<ffffffffa01824c9>] ext4_io_submit+0x29/0x50 [ext4]
[  471.893819]  [<ffffffffa017eaab>] ext4_writepages+0x96b/0xde0 [ext4]
[  471.895879]  [<ffffffff81195251>] do_writepages+0x21/0x50
[  471.897795]  [<ffffffff81230b75>] __writeback_single_inode+0x55/0x2c0
[  471.899866]  [<ffffffff81231b36>] writeback_sb_inodes+0x2a6/0x4a0
[  471.901887]  [<ffffffff81207ed4>] ? grab_super_passive+0x44/0x90
[  471.903898]  [<ffffffff81231dcf>] __writeback_inodes_wb+0x9f/0xd0
[  471.905919]  [<ffffffff81232733>] wb_writeback+0x323/0x350
[  471.907845]  [<ffffffff81234b3d>] bdi_writeback_workfn+0x32d/0x4f0
[  471.909878]  [<ffffffff81094471>] process_one_work+0x1d1/0x520
[  471.911858]  [<ffffffff810943fa>] ? process_one_work+0x15a/0x520
[  471.913867]  [<ffffffff810948db>] worker_thread+0x11b/0x4a0
[  471.915809]  [<ffffffff810947c0>] ? process_one_work+0x520/0x520
[  471.917820]  [<ffffffff8109a3f7>] kthread+0x107/0x120
[  471.919677]  [<ffffffff8109a2f0>] ? kthread_create_on_node+0x240/0x240
[  471.921740]  [<ffffffff8169533c>] ret_from_fork+0x7c/0xb0
[  471.923630]  [<ffffffff8109a2f0>] ? kthread_create_on_node+0x240/0x240

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="blk-mq-debug-bt_get.patch"

 block/blk-mq-tag.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 32e8dbb..8d4b4f0 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -232,6 +232,27 @@ static struct bt_wait_state *bt_wait_ptr(struct blk_mq_bitmap_tags *bt,
 	return bs;
 }
 
+static unsigned int bt_unused_tags(struct blk_mq_bitmap_tags *bt);
+
+static void print_hctx_tags_usage(struct blk_mq_hw_ctx *hctx)
+{
+	unsigned int free, res;
+	struct blk_mq_tags *tags = hctx->tags;
+
+	if (!tags)
+		return;
+
+	printk("queue_num=%d, nr_tags=%u, reserved_tags=%u, bits_per_word=%u\n",
+	       hctx->queue_num, tags->nr_tags, tags->nr_reserved_tags,
+	       tags->bitmap_tags.bits_per_word);
+
+	free = bt_unused_tags(&tags->bitmap_tags);
+	res = bt_unused_tags(&tags->breserved_tags);
+
+	printk("nr_free=%u, nr_reserved=%u\n", free, res);
+	printk("active_queues=%u\n", atomic_read(&tags->active_queues));
+}
+
 static int bt_get(struct blk_mq_alloc_data *data,
 		struct blk_mq_bitmap_tags *bt,
 		struct blk_mq_hw_ctx *hctx,
@@ -245,6 +266,10 @@ static int bt_get(struct blk_mq_alloc_data *data,
 	if (tag != -1)
 		return tag;
 
+	printk("\n%s: __bt_get() returned -1\n", __func__);
+	print_hctx_tags_usage(hctx);
+	dump_stack();
+
 	if (!(data->gfp & __GFP_WAIT))
 		return -1;
 
@@ -256,6 +281,9 @@ static int bt_get(struct blk_mq_alloc_data *data,
 		if (tag != -1)
 			break;
 
+		printk("%s: __bt_get() _still_ returned -1\n", __func__);
+		print_hctx_tags_usage(hctx);
+
 		/*
 		 * We're out of tags on this hardware queue, kick any
 		 * pending IO submits before going to sleep waiting for

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--0F1p//8PRICkK4MW--
