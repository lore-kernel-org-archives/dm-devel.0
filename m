From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [dm-devel] [PATCH V15 00/18] block: support
	multi-page bvec
Date: Sun, 17 Feb 2019 21:11:29 +0800
Message-ID: <20190217131128.GB7296@ming.t460p>
References: <20190215111324.30129-1-ming.lei@redhat.com>
	<c52b6a8b-d1d4-67ff-f81c-371d09cc6d5b@kernel.dk>
	<1550250855.31902.102.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1550250855.31902.102.camel@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 15, 2019 at 09:14:15AM -0800, Bart Van Assche wrote:
> On Fri, 2019-02-15 at 08:49 -0700, Jens Axboe wrote:
> > On 2/15/19 4:13 AM, Ming Lei wrote:
> > > This patchset brings multi-page bvec into block layer:
> > 
> > Applied, thanks Ming. Let's hope it sticks!
> 
> Hi Jens and Ming,
> 
> Test nvmeof-mp/002 fails with Jens' for-next branch from this morning.
> I have not yet tried to figure out which patch introduced the failure.
> Anyway, this is what I see in the kernel log for test nvmeof-mp/002:
> 
> [  475.611363] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> [  475.621188] #PF error: [normal kernel read fault]
> [  475.623148] PGD 0 P4D 0  
> [  475.624737] Oops: 0000 [#1] PREEMPT SMP KASAN
> [  475.626628] CPU: 1 PID: 277 Comm: kworker/1:1H Tainted: G    B             5.0.0-rc6-dbg+ #1
> [  475.630232] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> [  475.633855] Workqueue: kblockd blk_mq_requeue_work
> [  475.635777] RIP: 0010:__blk_recalc_rq_segments+0xbe/0x590
> [  475.670948] Call Trace:
> [  475.693515]  blk_recalc_rq_segments+0x2f/0x50
> [  475.695081]  blk_insert_cloned_request+0xbb/0x1c0
> [  475.701142]  dm_mq_queue_rq+0x3d1/0x770
> [  475.707225]  blk_mq_dispatch_rq_list+0x5fc/0xb10
> [  475.717137]  blk_mq_sched_dispatch_requests+0x256/0x300
> [  475.721767]  __blk_mq_run_hw_queue+0xd6/0x180
> [  475.725920]  __blk_mq_delay_run_hw_queue+0x25c/0x290
> [  475.727480]  blk_mq_run_hw_queue+0x119/0x1b0
> [  475.732019]  blk_mq_run_hw_queues+0x7b/0xa0
> [  475.733468]  blk_mq_requeue_work+0x2cb/0x300
> [  475.736473]  process_one_work+0x4f1/0xa40
> [  475.739424]  worker_thread+0x67/0x5b0
> [  475.741751]  kthread+0x1cf/0x1f0
> [  475.746034]  ret_from_fork+0x24/0x30
> 
> (gdb) list *(__blk_recalc_rq_segments+0xbe)
> 0xffffffff816a152e is in __blk_recalc_rq_segments (block/blk-merge.c:366).
> 361                                                  struct bio *bio)
> 362     {
> 363             struct bio_vec bv, bvprv = { NULL };
> 364             int prev = 0;
> 365             unsigned int seg_size, nr_phys_segs;
> 366             unsigned front_seg_size = bio->bi_seg_front_size;
> 367             struct bio *fbio, *bbio;
> 368             struct bvec_iter iter;
> 369
> 370             if (!bio)
> 
> Bart.

Thanks for your test!

The following patch should fix this issue:


diff --git a/block/blk-merge.c b/block/blk-merge.c
index bed065904677..066b66430523 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -363,13 +363,15 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	struct bio_vec bv, bvprv = { NULL };
 	int prev = 0;
 	unsigned int seg_size, nr_phys_segs;
-	unsigned front_seg_size = bio->bi_seg_front_size;
+	unsigned front_seg_size;
 	struct bio *fbio, *bbio;
 	struct bvec_iter iter;
 
 	if (!bio)
 		return 0;
 
+	front_seg_size = bio->bi_seg_front_size;
+
 	switch (bio_op(bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:

Thanks,
Ming
