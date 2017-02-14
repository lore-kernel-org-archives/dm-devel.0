From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] v4.9, 4.4-final: 28 bioset threads on small notebook,
 36 threads on cellphone
Date: Tue, 14 Feb 2017 11:34:42 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1702141124150.24722@file01.intranet.prod.int.rdu2.redhat.com>
References: <20160220174035.GA16459@amd> <20160220184258.GA3753@amd> <20160220195136.GA27149@redhat.com> <20160220200432.GB22120@amd> <20170206125309.GA29395@amd> <20170207014724.74tb37jj7u66lww3@moria.home.lan> <20170207024906.4oswyuvxfnqkvbhr@moria.home.lan>
 <20170207203911.GA16980@amd> <20170207204510.qr2l2rg42ez2hobh@moria.home.lan> <20170208163407.GA3646@redhat.com> <20170209212523.lgrgvk2squoo6x6f@moria.home.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170209212523.lgrgvk2squoo6x6f@moria.home.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, oleg.drokin@intel.com, ming.l@ssi.samsung.com, andreas.dilger@intel.com, martin.petersen@oracle.com, minchan@kernel.org, jkosina@suse.cz, ming.lei@canonical.com, kernel list <linux-kernel@vger.kernel.org>, jim@jtan.com, pjk1939@linux.vnet.ibm.com, axboe@fb.com, geoff@infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, dpark@posteo.net, Pavel Machek <pavel@ucw.cz>, ngupta@vflare.org, hch@lst.de, agk@redhat.com
List-Id: dm-devel.ids



On Thu, 9 Feb 2017, Kent Overstreet wrote:

> On Wed, Feb 08, 2017 at 11:34:07AM -0500, Mike Snitzer wrote:
> > On Tue, Feb 07 2017 at 11:58pm -0500,
> > Kent Overstreet <kent.overstreet@gmail.com> wrote:
> > 
> > > On Tue, Feb 07, 2017 at 09:39:11PM +0100, Pavel Machek wrote:
> > > > On Mon 2017-02-06 17:49:06, Kent Overstreet wrote:
> > > > > On Mon, Feb 06, 2017 at 04:47:24PM -0900, Kent Overstreet wrote:
> > > > > > On Mon, Feb 06, 2017 at 01:53:09PM +0100, Pavel Machek wrote:
> > > > > > > Still there on v4.9, 36 threads on nokia n900 cellphone.
> > > > > > > 
> > > > > > > So.. what needs to be done there?
> > > > > 
> > > > > > But, I just got an idea for how to handle this that might be halfway sane, maybe
> > > > > > I'll try and come up with a patch...
> > > > > 
> > > > > Ok, here's such a patch, only lightly tested:
> > > > 
> > > > I guess it would be nice for me to test it... but what it is against?
> > > > I tried after v4.10-rc5 and linux-next, but got rejects in both cases.
> > > 
> > > Sorry, I forgot I had a few other patches in my branch that touch
> > > mempool/biosets code.
> > > 
> > > Also, after thinking about it more and looking at the relevant code, I'm pretty
> > > sure we don't need rescuer threads for block devices that just split bios - i.e.
> > > most of them, so I changed my patch to do that.
> > > 
> > > Tested it by ripping out the current->bio_list checks/workarounds from the
> > > bcache code, appears to work:
> > 
> > Feedback on this patch below, but first:
> > 
> > There are deeper issues with the current->bio_list and rescue workqueues
> > than thread counts.
> > 
> > I cannot help but feel like you (and Jens) are repeatedly ignoring the
> > issue that has been raised numerous times, most recently:
> > https://www.redhat.com/archives/dm-devel/2017-February/msg00059.html
> > 
> > FYI, this test (albeit ugly) can be used to check if the dm-snapshot
> > deadlock is fixed:
> > https://www.redhat.com/archives/dm-devel/2017-January/msg00064.html
> > 
> > This situation is the unfortunate pathological worst case for what
> > happens when changes are merged and nobody wants to own fixing the
> > unforseen implications/regressions.   Like everyone else in a position
> > of Linux maintenance I've tried to stay away from owning the
> > responsibility of a fix -- it isn't working.  Ok, I'll stop bitching
> > now.. I do bear responsibility for not digging in myself.  We're all
> > busy and this issue is "hard".
> 
> Mike, it's not my job to debug DM code for you or sift through your bug reports.
> I don't read dm-devel, and I don't know why you think I that's my job.
> 
> If there's something you think the block layer should be doing differently, post
> patches - or at the very least, explain what you'd like to be done, with words.
> Don't get pissy because I'm not sifting through your bug reports.

So I post this patch for that bug.

Will any of the block device maintainers respond to it?



From: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 27 May 2014 11:03:36 -0400
Subject: block: flush queued bios when process blocks to avoid deadlock

The block layer uses per-process bio list to avoid recursion in
generic_make_request.  When generic_make_request is called recursively,
the bio is added to current->bio_list and generic_make_request returns
immediately.  The top-level instance of generic_make_request takes bios
from current->bio_list and processes them.

The problem is that this bio queuing on current->bio_list creates an 
artifical locking dependency - a bio further on current->bio_list depends 
on any locks that preceding bios could take.  This could result in a 
deadlock.

Commit df2cb6daa4 ("block: Avoid deadlocks with bio allocation by
stacking drivers") created a workqueue for every bio set and code
in bio_alloc_bioset() that tries to resolve some low-memory deadlocks by
redirecting bios queued on current->bio_list to the workqueue if the
system is low on memory.  However another deadlock (see below **) may
happen, without any low memory condition, because generic_make_request
is queuing bios to current->bio_list (rather than submitting them).

Fix this deadlock by redirecting any bios on current->bio_list to the
bio_set's rescue workqueue on every schedule call.  Consequently, when
the process blocks on a mutex, the bios queued on current->bio_list are
dispatched to independent workqueus and they can complete without
waiting for the mutex to be available.

Also, now we can remove punt_bios_to_rescuer() and bio_alloc_bioset()'s
calls to it because bio_alloc_bioset() will implicitly punt all bios on
current->bio_list if it performs a blocking allocation.

** Here is the dm-snapshot deadlock that was observed:

1) Process A sends one-page read bio to the dm-snapshot target. The bio
spans snapshot chunk boundary and so it is split to two bios by device
mapper.

2) Device mapper creates the first sub-bio and sends it to the snapshot
driver.

3) The function snapshot_map calls track_chunk (that allocates a structure
dm_snap_tracked_chunk and adds it to tracked_chunk_hash) and then remaps
the bio to the underlying device and exits with DM_MAPIO_REMAPPED.

4) The remapped bio is submitted with generic_make_request, but it isn't
issued - it is added to current->bio_list instead.

5) Meanwhile, process B (dm's kcopyd) executes pending_complete for the
chunk affected be the first remapped bio, it takes down_write(&s->lock)
and then loops in __check_for_conflicting_io, waiting for
dm_snap_tracked_chunk created in step 3) to be released.

6) Process A continues, it creates a second sub-bio for the rest of the
original bio.

7) snapshot_map is called for this new bio, it waits on
down_write(&s->lock) that is held by Process B (in step 5).

Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1267650
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Depends-on: df2cb6daa4 ("block: Avoid deadlocks with bio allocation by stacking drivers")
Cc: stable@vger.kernel.org

---
 block/bio.c            |   77 +++++++++++++++++++------------------------------
 include/linux/blkdev.h |   24 ++++++++++-----
 kernel/sched/core.c    |    7 +---
 3 files changed, 50 insertions(+), 58 deletions(-)

Index: linux-4.10-rc2/block/bio.c
===================================================================
--- linux-4.10-rc2.orig/block/bio.c
+++ linux-4.10-rc2/block/bio.c
@@ -357,35 +357,37 @@ static void bio_alloc_rescue(struct work
 	}
 }
 
-static void punt_bios_to_rescuer(struct bio_set *bs)
+/**
+ * blk_flush_bio_list
+ * @tsk: task_struct whose bio_list must be flushed
+ *
+ * Pop bios queued on @tsk->bio_list and submit each of them to
+ * their rescue workqueue.
+ *
+ * If the bio doesn't have a bio_set, we leave it on @tsk->bio_list.
+ * If the bio is allocated from fs_bio_set, we must leave it to avoid
+ * deadlock on loopback block device.
+ * Stacking bio drivers should use bio_set, so this shouldn't be
+ * an issue.
+ */
+void blk_flush_bio_list(struct task_struct *tsk)
 {
-	struct bio_list punt, nopunt;
 	struct bio *bio;
+	struct bio_list list = *tsk->bio_list;
+	bio_list_init(tsk->bio_list);
 
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
+	while ((bio = bio_list_pop(&list))) {
+		struct bio_set *bs = bio->bi_pool;
+		if (unlikely(!bs) || bs == fs_bio_set) {
+			bio_list_add(tsk->bio_list, bio);
+			continue;
+		}
 
-	queue_work(bs->rescue_workqueue, &bs->rescue_work);
+		spin_lock(&bs->rescue_lock);
+		bio_list_add(&bs->rescue_list, bio);
+		queue_work(bs->rescue_workqueue, &bs->rescue_work);
+		spin_unlock(&bs->rescue_lock);
+	}
 }
 
 /**
@@ -425,7 +427,6 @@ static void punt_bios_to_rescuer(struct
  */
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
-	gfp_t saved_gfp = gfp_mask;
 	unsigned front_pad;
 	unsigned inline_vecs;
 	struct bio_vec *bvl = NULL;
@@ -459,23 +460,11 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
 		 * reserve.
 		 *
 		 * We solve this, and guarantee forward progress, with a rescuer
-		 * workqueue per bio_set. If we go to allocate and there are
-		 * bios on current->bio_list, we first try the allocation
-		 * without __GFP_DIRECT_RECLAIM; if that fails, we punt those
-		 * bios we would be blocking to the rescuer workqueue before
-		 * we retry with the original gfp_flags.
+		 * workqueue per bio_set. If an allocation would block (due to
+		 * __GFP_DIRECT_RECLAIM) the scheduler will first punt all bios
+		 * on current->bio_list to the rescuer workqueue.
 		 */
-
-		if (current->bio_list && !bio_list_empty(current->bio_list))
-			gfp_mask &= ~__GFP_DIRECT_RECLAIM;
-
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
@@ -490,12 +479,6 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
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
 
Index: linux-4.10-rc2/include/linux/blkdev.h
===================================================================
--- linux-4.10-rc2.orig/include/linux/blkdev.h
+++ linux-4.10-rc2/include/linux/blkdev.h
@@ -1267,6 +1267,22 @@ static inline bool blk_needs_flush_plug(
 		 !list_empty(&plug->cb_list));
 }
 
+extern void blk_flush_bio_list(struct task_struct *tsk);
+
+static inline void blk_flush_queued_io(struct task_struct *tsk)
+{
+	/*
+	 * Flush any queued bios to corresponding rescue threads.
+	 */
+	if (tsk->bio_list && !bio_list_empty(tsk->bio_list))
+		blk_flush_bio_list(tsk);
+	/*
+	 * Flush any plugged IO that is queued.
+	 */
+	if (blk_needs_flush_plug(tsk))
+		blk_schedule_flush_plug(tsk);
+}
+
 /*
  * tag stuff
  */
@@ -1921,16 +1937,10 @@ static inline void blk_flush_plug(struct
 {
 }
 
-static inline void blk_schedule_flush_plug(struct task_struct *task)
+static inline void blk_flush_queued_io(struct task_struct *tsk)
 {
 }
 
-
-static inline bool blk_needs_flush_plug(struct task_struct *tsk)
-{
-	return false;
-}
-
 static inline int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 				     sector_t *error_sector)
 {
Index: linux-4.10-rc2/kernel/sched/core.c
===================================================================
--- linux-4.10-rc2.orig/kernel/sched/core.c
+++ linux-4.10-rc2/kernel/sched/core.c
@@ -3441,11 +3441,10 @@ static inline void sched_submit_work(str
 	if (!tsk->state || tsk_is_pi_blocked(tsk))
 		return;
 	/*
-	 * If we are going to sleep and we have plugged IO queued,
+	 * If we are going to sleep and we have queued IO,
 	 * make sure to submit it to avoid deadlocks.
 	 */
-	if (blk_needs_flush_plug(tsk))
-		blk_schedule_flush_plug(tsk);
+	blk_flush_queued_io(tsk);
 }
 
 asmlinkage __visible void __sched schedule(void)
@@ -5068,7 +5067,7 @@ long __sched io_schedule_timeout(long ti
 	long ret;
 
 	current->in_iowait = 1;
-	blk_schedule_flush_plug(current);
+	blk_flush_queued_io(current);
 
 	delayacct_blkio_start();
 	rq = raw_rq();
