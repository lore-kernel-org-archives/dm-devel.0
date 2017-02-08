From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: v4.9, 4.4-final: 28 bioset threads on small notebook, 36 threads
 on cellphone
Date: Tue, 7 Feb 2017 19:58:33 -0900
Message-ID: <20170207204510.qr2l2rg42ez2hobh@moria.home.lan>
References: <20151211104937.GA23165@amd>
 <20151211140841.GA22873@redhat.com>
 <20160220174035.GA16459@amd>
 <20160220184258.GA3753@amd>
 <20160220195136.GA27149@redhat.com>
 <20160220200432.GB22120@amd>
 <20170206125309.GA29395@amd>
 <20170207014724.74tb37jj7u66lww3@moria.home.lan>
 <20170207024906.4oswyuvxfnqkvbhr@moria.home.lan>
 <20170207203911.GA16980@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170207203911.GA16980@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Mike Snitzer <snitzer@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, axboe@fb.com, hch@lst.de, neilb@suse.de, martin.petersen@oracle.com, dpark@posteo.net, ming.l@ssi.samsung.com, dm-devel@redhat.com, ming.lei@canonical.com, agk@redhat.com, jkosina@suse.cz, geoff@infradead.org, jim@jtan.com, pjk1939@linux.vnet.ibm.com, minchan@kernel.org, ngupta@vflare.org, oleg.drokin@intel.com, andreas.dilger@intel.com
List-Id: dm-devel.ids

On Tue, Feb 07, 2017 at 09:39:11PM +0100, Pavel Machek wrote:
> On Mon 2017-02-06 17:49:06, Kent Overstreet wrote:
> > On Mon, Feb 06, 2017 at 04:47:24PM -0900, Kent Overstreet wrote:
> > > On Mon, Feb 06, 2017 at 01:53:09PM +0100, Pavel Machek wrote:
> > > > Still there on v4.9, 36 threads on nokia n900 cellphone.
> > > > 
> > > > So.. what needs to be done there?
> > 
> > > But, I just got an idea for how to handle this that might be halfway sane, maybe
> > > I'll try and come up with a patch...
> > 
> > Ok, here's such a patch, only lightly tested:
> 
> I guess it would be nice for me to test it... but what it is against?
> I tried after v4.10-rc5 and linux-next, but got rejects in both cases.

Sorry, I forgot I had a few other patches in my branch that touch
mempool/biosets code.

Also, after thinking about it more and looking at the relevant code, I'm pretty
sure we don't need rescuer threads for block devices that just split bios - i.e.
most of them, so I changed my patch to do that.

Tested it by ripping out the current->bio_list checks/workarounds from the
bcache code, appears to work:

-- >8 --
Subject: [PATCH] block: Make rescuer threads per request_queue, not per bioset

Also, trigger rescuing whenever with bios on current->bio_list, instead
of only when we block in bio_alloc_bioset(). This is more correct, and
should result in fewer rescuer threads.

XXX: The current->bio_list plugging needs to be unified with the
blk_plug mechanism.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 block/bio.c                    | 105 +++--------------------------------------
 block/blk-core.c               |  69 +++++++++++++++++++++++----
 block/blk-mq.c                 |   3 +-
 block/blk-sysfs.c              |   2 +
 drivers/block/brd.c            |   2 +-
 drivers/block/drbd/drbd_main.c |   2 +-
 drivers/block/null_blk.c       |   3 +-
 drivers/block/pktcdvd.c        |   2 +-
 drivers/block/ps3vram.c        |   2 +-
 drivers/block/rsxx/dev.c       |   2 +-
 drivers/block/umem.c           |   2 +-
 drivers/block/zram/zram_drv.c  |   2 +-
 drivers/lightnvm/gennvm.c      |   2 +-
 drivers/md/bcache/super.c      |   2 +-
 drivers/md/dm.c                |   2 +-
 drivers/md/md.c                |   2 +-
 drivers/nvdimm/blk.c           |   2 +-
 drivers/nvdimm/btt.c           |   2 +-
 drivers/nvdimm/pmem.c          |   3 +-
 drivers/s390/block/dcssblk.c   |   2 +-
 drivers/s390/block/xpram.c     |   2 +-
 include/linux/bio.h            |  16 +++----
 include/linux/blkdev.h         |  16 ++++++-
 include/linux/sched.h          |   2 +-
 kernel/sched/core.c            |   6 +++
 25 files changed, 117 insertions(+), 138 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2b375020fc..9b89be1719 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -340,54 +340,6 @@ void bio_chain(struct bio *bio, struct bio *parent)
 }
 EXPORT_SYMBOL(bio_chain);
 
-static void bio_alloc_rescue(struct work_struct *work)
-{
-	struct bio_set *bs = container_of(work, struct bio_set, rescue_work);
-	struct bio *bio;
-
-	while (1) {
-		spin_lock(&bs->rescue_lock);
-		bio = bio_list_pop(&bs->rescue_list);
-		spin_unlock(&bs->rescue_lock);
-
-		if (!bio)
-			break;
-
-		generic_make_request(bio);
-	}
-}
-
-static void punt_bios_to_rescuer(struct bio_set *bs)
-{
-	struct bio_list punt, nopunt;
-	struct bio *bio;
-
-	/*
-	 * In order to guarantee forward progress we must punt only bios that
-	 * were allocated from this bio_set; otherwise, if there was a bio on
-	 * there for a stacking driver higher up in the stack, processing it
-	 * could require allocating bios from this bio_set, and doing that from
-	 * our own rescuer would be bad.
-	 *
-	 * Since bio lists are singly linked, pop them all instead of trying to
-	 * remove from the middle of the list:
-	 */
-
-	bio_list_init(&punt);
-	bio_list_init(&nopunt);
-
-	while ((bio = bio_list_pop(current->bio_list)))
-		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
-
-	*current->bio_list = nopunt;
-
-	spin_lock(&bs->rescue_lock);
-	bio_list_merge(&bs->rescue_list, &punt);
-	spin_unlock(&bs->rescue_lock);
-
-	queue_work(bs->rescue_workqueue, &bs->rescue_work);
-}
-
 /**
  * bio_alloc_bioset - allocate a bio for I/O
  * @gfp_mask:   the GFP_ mask given to the slab allocator
@@ -425,17 +377,20 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
  */
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
-	gfp_t saved_gfp = gfp_mask;
 	unsigned front_pad;
 	unsigned inline_vecs;
 	struct bio_vec *bvl = NULL;
 	struct bio *bio;
 	void *p;
 
-	if (!bs) {
-		if (nr_iovecs > UIO_MAXIOV)
-			return NULL;
+	WARN(current->bio_list &&
+	     !current->bio_list->q->rescue_workqueue,
+	     "allocating bio beneath generic_make_request() without rescuer");
 
+	if (nr_iovecs > UIO_MAXIOV)
+		return NULL;
+
+	if (!bs) {
 		p = kmalloc(sizeof(struct bio) +
 			    nr_iovecs * sizeof(struct bio_vec),
 			    gfp_mask);
@@ -445,37 +400,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		/* should not use nobvec bioset for nr_iovecs > 0 */
 		if (WARN_ON_ONCE(!bs->bvec_pool && nr_iovecs > 0))
 			return NULL;
-		/*
-		 * generic_make_request() converts recursion to iteration; this
-		 * means if we're running beneath it, any bios we allocate and
-		 * submit will not be submitted (and thus freed) until after we
-		 * return.
-		 *
-		 * This exposes us to a potential deadlock if we allocate
-		 * multiple bios from the same bio_set() while running
-		 * underneath generic_make_request(). If we were to allocate
-		 * multiple bios (say a stacking block driver that was splitting
-		 * bios), we would deadlock if we exhausted the mempool's
-		 * reserve.
-		 *
-		 * We solve this, and guarantee forward progress, with a rescuer
-		 * workqueue per bio_set. If we go to allocate and there are
-		 * bios on current->bio_list, we first try the allocation
-		 * without __GFP_DIRECT_RECLAIM; if that fails, we punt those
-		 * bios we would be blocking to the rescuer workqueue before
-		 * we retry with the original gfp_flags.
-		 */
-
-		if (current->bio_list && !bio_list_empty(current->bio_list))
-			gfp_mask &= ~__GFP_DIRECT_RECLAIM;
 
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
-		if (!p && gfp_mask != saved_gfp) {
-			punt_bios_to_rescuer(bs);
-			gfp_mask = saved_gfp;
-			p = mempool_alloc(bs->bio_pool, gfp_mask);
-		}
-
 		front_pad = bs->front_pad;
 		inline_vecs = BIO_INLINE_VECS;
 	}
@@ -490,12 +416,6 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		unsigned long idx = 0;
 
 		bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, bs->bvec_pool);
-		if (!bvl && gfp_mask != saved_gfp) {
-			punt_bios_to_rescuer(bs);
-			gfp_mask = saved_gfp;
-			bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, bs->bvec_pool);
-		}
-
 		if (unlikely(!bvl))
 			goto err_free;
 
@@ -1892,9 +1812,6 @@ mempool_t *biovec_create_pool(int pool_entries)
 
 void bioset_free(struct bio_set *bs)
 {
-	if (bs->rescue_workqueue)
-		destroy_workqueue(bs->rescue_workqueue);
-
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
@@ -1921,10 +1838,6 @@ static struct bio_set *__bioset_create(unsigned int pool_size,
 
 	bs->front_pad = front_pad;
 
-	spin_lock_init(&bs->rescue_lock);
-	bio_list_init(&bs->rescue_list);
-	INIT_WORK(&bs->rescue_work, bio_alloc_rescue);
-
 	bs->bio_slab = bio_find_or_create_slab(front_pad + back_pad);
 	if (!bs->bio_slab) {
 		kfree(bs);
@@ -1941,10 +1854,6 @@ static struct bio_set *__bioset_create(unsigned int pool_size,
 			goto bad;
 	}
 
-	bs->rescue_workqueue = alloc_workqueue("bioset", WQ_MEM_RECLAIM, 0);
-	if (!bs->rescue_workqueue)
-		goto bad;
-
 	return bs;
 bad:
 	bioset_free(bs);
diff --git a/block/blk-core.c b/block/blk-core.c
index 61ba08c58b..2222fd40e2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -49,6 +49,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(block_unplug);
 
 DEFINE_IDA(blk_queue_ida);
 
+static void bio_rescue_work(struct work_struct *);
+
 /*
  * For the allocated request tables
  */
@@ -643,9 +645,9 @@ void blk_exit_rl(struct request_list *rl)
 		mempool_destroy(rl->rq_pool);
 }
 
-struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
+struct request_queue *blk_alloc_queue(gfp_t gfp_mask, int flags)
 {
-	return blk_alloc_queue_node(gfp_mask, NUMA_NO_NODE);
+	return blk_alloc_queue_node(gfp_mask, NUMA_NO_NODE, flags);
 }
 EXPORT_SYMBOL(blk_alloc_queue);
 
@@ -690,7 +692,7 @@ static void blk_rq_timed_out_timer(unsigned long data)
 	kblockd_schedule_work(&q->timeout_work);
 }
 
-struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
+struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id, int flags)
 {
 	struct request_queue *q;
 	int err;
@@ -760,11 +762,23 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 				PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
 		goto fail_bdi;
 
+	spin_lock_init(&q->rescue_lock);
+	bio_list_init(&q->rescue_list);
+	INIT_WORK(&q->rescue_work, bio_rescue_work);
+
+	if (!(flags & BLK_QUEUE_NO_RESCUER)) {
+		q->rescue_workqueue = alloc_workqueue("rescue", WQ_MEM_RECLAIM, 0);
+		if (!q->rescue_workqueue)
+			goto fail_ref;
+	}
+
 	if (blkcg_init_queue(q))
-		goto fail_ref;
+		goto fail_rescue;
 
 	return q;
 
+fail_rescue:
+	destroy_workqueue(q->rescue_workqueue);
 fail_ref:
 	percpu_ref_exit(&q->q_usage_counter);
 fail_bdi:
@@ -823,7 +837,8 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 {
 	struct request_queue *uninit_q, *q;
 
-	uninit_q = blk_alloc_queue_node(GFP_KERNEL, node_id);
+	uninit_q = blk_alloc_queue_node(GFP_KERNEL, node_id,
+					BLK_QUEUE_NO_RESCUER);
 	if (!uninit_q)
 		return NULL;
 
@@ -1977,7 +1992,7 @@ generic_make_request_checks(struct bio *bio)
  */
 blk_qc_t generic_make_request(struct bio *bio)
 {
-	struct bio_list bio_list_on_stack;
+	struct bio_plug_list bio_list_on_stack;
 	blk_qc_t ret = BLK_QC_T_NONE;
 
 	if (!generic_make_request_checks(bio))
@@ -1994,7 +2009,9 @@ blk_qc_t generic_make_request(struct bio *bio)
 	 * should be added at the tail
 	 */
 	if (current->bio_list) {
-		bio_list_add(current->bio_list, bio);
+		WARN(!current->bio_list->q->rescue_workqueue,
+		     "submitting bio beneath generic_make_request() without rescuer");
+		bio_list_add(&current->bio_list->bios, bio);
 		goto out;
 	}
 
@@ -2013,19 +2030,23 @@ blk_qc_t generic_make_request(struct bio *bio)
 	 * bio_list, and call into ->make_request() again.
 	 */
 	BUG_ON(bio->bi_next);
-	bio_list_init(&bio_list_on_stack);
+	bio_list_init(&bio_list_on_stack.bios);
 	current->bio_list = &bio_list_on_stack;
+
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
+		current->bio_list->q = q;
+
 		if (likely(blk_queue_enter(q, false) == 0)) {
 			ret = q->make_request_fn(q, bio);
 
 			blk_queue_exit(q);
 
-			bio = bio_list_pop(current->bio_list);
+			bio = bio_list_pop(&current->bio_list->bios);
 		} else {
-			struct bio *bio_next = bio_list_pop(current->bio_list);
+			struct bio *bio_next =
+				bio_list_pop(&current->bio_list->bios);
 
 			bio_io_error(bio);
 			bio = bio_next;
@@ -2038,6 +2059,34 @@ blk_qc_t generic_make_request(struct bio *bio)
 }
 EXPORT_SYMBOL(generic_make_request);
 
+static void bio_rescue_work(struct work_struct *work)
+{
+	struct request_queue *q =
+		container_of(work, struct request_queue, rescue_work);
+	struct bio *bio;
+
+	while (1) {
+		spin_lock(&q->rescue_lock);
+		bio = bio_list_pop(&q->rescue_list);
+		spin_unlock(&q->rescue_lock);
+
+		if (!bio)
+			break;
+
+		generic_make_request(bio);
+	}
+}
+
+void blk_punt_blocked_bios(struct bio_plug_list *list)
+{
+	spin_lock(&list->q->rescue_lock);
+	bio_list_merge(&list->q->rescue_list, &list->bios);
+	bio_list_init(&list->bios);
+	spin_unlock(&list->q->rescue_lock);
+
+	queue_work(list->q->rescue_workqueue, &list->q->rescue_work);
+}
+
 /**
  * submit_bio - submit a bio to the block device layer for I/O
  * @bio: The &struct bio which describes the I/O
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c3400b5444..5e7f67c108 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2043,7 +2043,8 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 {
 	struct request_queue *uninit_q, *q;
 
-	uninit_q = blk_alloc_queue_node(GFP_KERNEL, set->numa_node);
+	uninit_q = blk_alloc_queue_node(GFP_KERNEL, set->numa_node,
+					BLK_QUEUE_NO_RESCUER);
 	if (!uninit_q)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 1dbce05759..1ab82c342b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -821,6 +821,8 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_trace_shutdown(q);
 
+	if (q->rescue_workqueue)
+		destroy_workqueue(q->rescue_workqueue);
 	if (q->bio_split)
 		bioset_free(q->bio_split);
 
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 3adc32a315..43ff4b23e4 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -449,7 +449,7 @@ static struct brd_device *brd_alloc(int i)
 	spin_lock_init(&brd->brd_lock);
 	INIT_RADIX_TREE(&brd->brd_pages, GFP_ATOMIC);
 
-	brd->brd_queue = blk_alloc_queue(GFP_KERNEL);
+	brd->brd_queue = blk_alloc_queue(GFP_KERNEL, BLK_QUEUE_NO_RESCUER);
 	if (!brd->brd_queue)
 		goto out_free_dev;
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 83482721bc..e46821ebc6 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2810,7 +2810,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	drbd_init_set_defaults(device);
 
-	q = blk_alloc_queue(GFP_KERNEL);
+	q = blk_alloc_queue(GFP_KERNEL, 0);
 	if (!q)
 		goto out_no_q;
 	device->rq_queue = q;
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index c0e14e5490..0ce25ce95f 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -734,7 +734,8 @@ static int null_add_dev(void)
 			goto out_cleanup_tags;
 		}
 	} else if (queue_mode == NULL_Q_BIO) {
-		nullb->q = blk_alloc_queue_node(GFP_KERNEL, home_node);
+		nullb->q = blk_alloc_queue_node(GFP_KERNEL, home_node,
+						BLK_QUEUE_NO_RESCUER);
 		if (!nullb->q) {
 			rv = -ENOMEM;
 			goto out_cleanup_queues;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 1b94c1ca5c..3ab1629475 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2737,7 +2737,7 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 	strcpy(disk->disk_name, pd->name);
 	disk->devnode = pktcdvd_devnode;
 	disk->private_data = pd;
-	disk->queue = blk_alloc_queue(GFP_KERNEL);
+	disk->queue = blk_alloc_queue(GFP_KERNEL, BLK_QUEUE_NO_RESCUER);
 	if (!disk->queue)
 		goto out_mem2;
 
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 456b4fe215..167e17058c 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -746,7 +746,7 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 	ps3vram_cache_init(dev);
 	ps3vram_proc_init(dev);
 
-	queue = blk_alloc_queue(GFP_KERNEL);
+	queue = blk_alloc_queue(GFP_KERNEL, BLK_QUEUE_NO_RESCUER);
 	if (!queue) {
 		dev_err(&dev->core, "blk_alloc_queue failed\n");
 		error = -ENOMEM;
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index f81d70b39d..e53cea595f 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -266,7 +266,7 @@ int rsxx_setup_dev(struct rsxx_cardinfo *card)
 		return -ENOMEM;
 	}
 
-	card->queue = blk_alloc_queue(GFP_KERNEL);
+	card->queue = blk_alloc_queue(GFP_KERNEL, BLK_QUEUE_NO_RESCUER);
 	if (!card->queue) {
 		dev_err(CARD_TO_DEV(card), "Failed queue alloc\n");
 		unregister_blkdev(card->major, DRIVER_NAME);
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index c141cc3be2..7d496364c4 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -890,7 +890,7 @@ static int mm_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	card->bio = NULL;
 	card->biotail = &card->bio;
 
-	card->queue = blk_alloc_queue(GFP_KERNEL);
+	card->queue = blk_alloc_queue(GFP_KERNEL, BLK_QUEUE_NO_RESCUER);
 	if (!card->queue)
 		goto failed_alloc;
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e5ab7d9e8c..85ab96f15f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1245,7 +1245,7 @@ static int zram_add(void)
 
 	init_rwsem(&zram->init_lock);
 
-	queue = blk_alloc_queue(GFP_KERNEL);
+	queue = blk_alloc_queue(GFP_KERNEL, BLK_QUEUE_NO_RESCUER);
 	if (!queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
diff --git a/drivers/lightnvm/gennvm.c b/drivers/lightnvm/gennvm.c
index ca7880082d..d36a155b42 100644
--- a/drivers/lightnvm/gennvm.c
+++ b/drivers/lightnvm/gennvm.c
@@ -233,7 +233,7 @@ static int gen_create_tgt(struct nvm_dev *dev, struct nvm_ioctl_create *create)
 		goto err_reserve;
 	}
 
-	tqueue = blk_alloc_queue_node(GFP_KERNEL, dev->q->node);
+	tqueue = blk_alloc_queue_node(GFP_KERNEL, dev->q->node, 0);
 	if (!tqueue)
 		goto err_dev;
 	blk_queue_make_request(tqueue, tt->make_rq);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3a19cbc8b2..9cdbeb54f6 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -800,7 +800,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 	d->disk->fops		= &bcache_ops;
 	d->disk->private_data	= d;
 
-	q = blk_alloc_queue(GFP_KERNEL);
+	q = blk_alloc_queue(GFP_KERNEL, 0);
 	if (!q)
 		return -ENOMEM;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3086da5664..e1b22a68d9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1490,7 +1490,7 @@ static struct mapped_device *alloc_dev(int minor)
 	INIT_LIST_HEAD(&md->table_devices);
 	spin_lock_init(&md->uevent_lock);
 
-	md->queue = blk_alloc_queue_node(GFP_KERNEL, numa_node_id);
+	md->queue = blk_alloc_queue_node(GFP_KERNEL, numa_node_id, 0);
 	if (!md->queue)
 		goto bad;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 01175dac0d..0038d241d7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5061,7 +5061,7 @@ static int md_alloc(dev_t dev, char *name)
 	}
 
 	error = -ENOMEM;
-	mddev->queue = blk_alloc_queue(GFP_KERNEL);
+	mddev->queue = blk_alloc_queue(GFP_KERNEL, 0);
 	if (!mddev->queue)
 		goto abort;
 	mddev->queue->queuedata = mddev;
diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 9faaa9694d..a1d2e7a6ab 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -264,7 +264,7 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	internal_nlba = div_u64(nsblk->size, nsblk_internal_lbasize(nsblk));
 	available_disk_size = internal_nlba * nsblk_sector_size(nsblk);
 
-	q = blk_alloc_queue(GFP_KERNEL);
+	q = blk_alloc_queue(GFP_KERNEL, BLK_QUEUE_NO_RESCUER);
 	if (!q)
 		return -ENOMEM;
 	if (devm_add_action_or_reset(dev, nd_blk_release_queue, q))
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 368795aad5..7bd6135b77 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1232,7 +1232,7 @@ static int btt_blk_init(struct btt *btt)
 	struct nd_namespace_common *ndns = nd_btt->ndns;
 
 	/* create a new disk and request queue for btt */
-	btt->btt_queue = blk_alloc_queue(GFP_KERNEL);
+	btt->btt_queue = blk_alloc_queue(GFP_KERNEL, BLK_QUEUE_NO_RESCUER);
 	if (!btt->btt_queue)
 		return -ENOMEM;
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 5b536be5a1..314ac480bf 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -280,7 +280,8 @@ static int pmem_attach_disk(struct device *dev,
 		return -EBUSY;
 	}
 
-	q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
+	q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev),
+				 BLK_QUEUE_NO_RESCUER);
 	if (!q)
 		return -ENOMEM;
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 9d66b4fb17..101e0ae2f7 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -612,7 +612,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	}
 	dev_info->gd->major = dcssblk_major;
 	dev_info->gd->fops = &dcssblk_devops;
-	dev_info->dcssblk_queue = blk_alloc_queue(GFP_KERNEL);
+	dev_info->dcssblk_queue = blk_alloc_queue(GFP_KERNEL, BLK_QUEUE_NO_RESCUER);
 	dev_info->gd->queue = dev_info->dcssblk_queue;
 	dev_info->gd->private_data = dev_info;
 	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index b9d7e755c8..72f52de17b 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -342,7 +342,7 @@ static int __init xpram_setup_blkdev(void)
 		xpram_disks[i] = alloc_disk(1);
 		if (!xpram_disks[i])
 			goto out;
-		xpram_queues[i] = blk_alloc_queue(GFP_KERNEL);
+		xpram_queues[i] = blk_alloc_queue(GFP_KERNEL, BLK_QUEUE_NO_RESCUER);
 		if (!xpram_queues[i]) {
 			put_disk(xpram_disks[i]);
 			goto out;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7cf8a6c70a..ac333e9528 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -656,6 +656,13 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 	return bio;
 }
 
+struct bio_plug_list {
+	struct bio_list		bios;
+	struct request_queue	*q;
+};
+
+void blk_punt_blocked_bios(struct bio_plug_list *);
+
 /*
  * Increment chain count for the bio. Make sure the CHAIN flag update
  * is visible before the raised count.
@@ -685,15 +692,6 @@ struct bio_set {
 	mempool_t *bio_integrity_pool;
 	mempool_t *bvec_integrity_pool;
 #endif
-
-	/*
-	 * Deadlock avoidance for stacking block drivers: see comments in
-	 * bio_alloc_bioset() for details
-	 */
-	spinlock_t		rescue_lock;
-	struct bio_list		rescue_list;
-	struct work_struct	rescue_work;
-	struct workqueue_struct	*rescue_workqueue;
 };
 
 struct biovec_slab {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1ca8e8fd10..01acaf9bf9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -570,6 +570,16 @@ struct request_queue {
 	struct bio_set		*bio_split;
 
 	bool			mq_sysfs_init_done;
+
+	/*
+	 * Deadlock avoidance, to deal with the plugging in
+	 * generic_make_request() that converts recursion to iteration to avoid
+	 * stack overflow:
+	 */
+	spinlock_t		rescue_lock;
+	struct bio_list		rescue_list;
+	struct work_struct	rescue_work;
+	struct workqueue_struct	*rescue_workqueue;
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
@@ -1192,9 +1202,11 @@ extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatte
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
+#define BLK_QUEUE_NO_RESCUER		1
+
 bool __must_check blk_get_queue(struct request_queue *);
-struct request_queue *blk_alloc_queue(gfp_t);
-struct request_queue *blk_alloc_queue_node(gfp_t, int);
+struct request_queue *blk_alloc_queue(gfp_t, int);
+struct request_queue *blk_alloc_queue_node(gfp_t, int, int);
 extern void blk_put_queue(struct request_queue *);
 extern void blk_set_queue_dying(struct request_queue *);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ad3ec9ec61..574ddc4f13 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1797,7 +1797,7 @@ struct task_struct {
 	void *journal_info;
 
 /* stacked block device info */
-	struct bio_list *bio_list;
+	struct bio_plug_list *bio_list;
 
 #ifdef CONFIG_BLOCK
 /* stack plugging */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c56fb57f29..07309d9610 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3440,6 +3440,12 @@ static inline void sched_submit_work(struct task_struct *tsk)
 {
 	if (!tsk->state || tsk_is_pi_blocked(tsk))
 		return;
+
+	if (tsk->bio_list &&
+	    !bio_list_empty(&tsk->bio_list->bios) &&
+	    tsk->bio_list->q->rescue_workqueue)
+		blk_punt_blocked_bios(tsk->bio_list);
+
 	/*
 	 * If we are going to sleep and we have plugged IO queued,
 	 * make sure to submit it to avoid deadlocks.
-- 
2.11.0
