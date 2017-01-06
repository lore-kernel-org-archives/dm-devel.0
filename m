From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 1/1] block: fix blk_queue_split() resource
 exhaustion
Date: Fri, 6 Jan 2017 12:34:34 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1701061151010.13944@file01.intranet.prod.int.rdu2.redhat.com>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com> <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com> <20160711141042.GY13335@soda.linbit> <76d9bf14-d848-4405-8358-3771c0a93d39@profitbricks.com> <20161223114553.GP4138@soda.linbit>
 <CA+res+SjL6FrYWMroB-xjBO5gyz9pca6FQCy-arr7+4RQHeJGw@mail.gmail.com> <878tqrmmqx.fsf@notabene.neil.brown.name> <20170104185046.GA982@redhat.com> <alpine.LRH.2.02.1701061139160.13944@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1701061139160.13944@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: NeilBrown <neilb@suse.com>, Jack Wang <jack.wang.usish@gmail.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>, Michael Wang <yun.wang@profitbricks.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, Kent
List-Id: dm-devel.ids



On Fri, 6 Jan 2017, Mikulas Patocka wrote:

> 
> 
> On Wed, 4 Jan 2017, Mike Snitzer wrote:
> 
> > On Wed, Jan 04 2017 at 12:12am -0500,
> > NeilBrown <neilb@suse.com> wrote:
> > 
> > > > Suggested-by: NeilBrown <neilb@suse.com>
> > > > Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> > > > ---
> > > >  block/blk-core.c | 20 ++++++++++++++++++++
> > > >  1 file changed, 20 insertions(+)
> > > >
> > > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > > index 9e3ac56..47ef373 100644
> > > > --- a/block/blk-core.c
> > > > +++ b/block/blk-core.c
> > > > @@ -2138,10 +2138,30 @@ blk_qc_t generic_make_request(struct bio *bio)
> > > >  		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> > > >  
> > > >  		if (likely(blk_queue_enter(q, __GFP_DIRECT_RECLAIM) == 0)) {
> > > > +			struct bio_list lower, same, hold;
> > > > +
> > > > +			/* Create a fresh bio_list for all subordinate requests */
> > > > +			bio_list_init(&hold);
> > > > +			bio_list_merge(&hold, &bio_list_on_stack);
> > > > +			bio_list_init(&bio_list_on_stack);
> > > >  
> > > >  			ret = q->make_request_fn(q, bio);
> > > >  
> > > >  			blk_queue_exit(q);
> > > > +			/* sort new bios into those for a lower level
> > > > +			 * and those for the same level
> > > > +			 */
> > > > +			bio_list_init(&lower);
> > > > +			bio_list_init(&same);
> > > > +			while ((bio = bio_list_pop(&bio_list_on_stack)) != NULL)
> > > > +				if (q == bdev_get_queue(bio->bi_bdev))
> > > > +					bio_list_add(&same, bio);
> > > > +				else
> > > > +					bio_list_add(&lower, bio);
> > > > +			/* now assemble so we handle the lowest level first */
> > > > +			bio_list_merge(&bio_list_on_stack, &lower);
> > > > +			bio_list_merge(&bio_list_on_stack, &same);
> > > > +			bio_list_merge(&bio_list_on_stack, &hold);
> > > >  
> > > >  			bio = bio_list_pop(current->bio_list);
> > > >  		} else {
> > > > -- 
> > > > 2.7.4
> > 
> > Mikulas, would you be willing to try the below patch with the
> > dm-snapshot deadlock scenario and report back on whether it fixes that?
> > 
> > Patch below looks to be the same as here:
> > https://marc.info/?l=linux-raid&m=148232453107685&q=p3
> > 
> > Neil and/or others if that isn't the patch that should be tested please
> > provide a pointer to the latest.
> > 
> > Thanks,
> > Mike
> 
> The bad news is that this doesn't fix the snapshot deadlock.
> 
> I created a test program for the snapshot deadlock bug (it was originally 
> created years ago to test for a different bug, so it contains some cruft). 
> You also need to insert "if (ci->sector_count) msleep(100);" to the end of 
> __split_and_process_non_flush to make the kernel sleep when splitting the 
> bio.
> 
> And with the above above patch, the snapshot deadlock bug still happens.
> 
> Mikulas
> 
> 
> #define _XOPEN_SOURCE 500
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <string.h>
> #include <errno.h>
> #include <malloc.h>
> #include <pthread.h>
> #include <asm/unistd.h>
> 
> /*
>  * Change "VG" symbol to a volume group name that you are using.
>  *
>  * You must apply this patch to the kernel to trigger the bug:
>  * Index: linux-4.10-rc2/drivers/md/dm.c
>  * ===================================================================
>  * --- linux-4.10-rc2.orig/drivers/md/dm.c
>  * +++ linux-4.10-rc2/drivers/md/dm.c
>  * @@ -1223,6 +1223,9 @@ static int __split_and_process_non_flush
>  *         ci->sector += len;
>  *         ci->sector_count -= len;
>  * 
>  * +       if (ci->sector_count)
>  * +               msleep(100);
>  * +
>  *         return 0;
>  *  }
>  * 
>  */
> 
> #define VG		"vg1"
> #define LV		"test_lv"
> #define LV_SNAP		"test_snap"
> #define MEGABYTES	"12"
> #define SNAP_MEGABYTES	"16"
> #define THREADS		1
> #define BS		4096
> #define SKEW		512
> #define ORIG_PATTERN	'p'
> #define NEW_PATTERN	'n'
> 
> enum {
> 	IOPRIO_CLASS_NONE,
> 	IOPRIO_CLASS_RT,
> 	IOPRIO_CLASS_BE,
> 	IOPRIO_CLASS_IDLE,
> };
> 
> enum {
> 	IOPRIO_WHO_PROCESS = 1,
> 	IOPRIO_WHO_PGRP,
> 	IOPRIO_WHO_USER,
> };
> 
> #define IOPRIO_CLASS_SHIFT	13
> 
> static inline int ioprio_set(int which, int who, int ioprio)
> {
> 	return syscall(__NR_ioprio_set, which, who, ioprio);
> }
> 
> static inline int ioprio_get(int which, int who)
> {
> 	return syscall(__NR_ioprio_get, which, who);
> }
> 
> #define PRIO_READER	((IOPRIO_CLASS_IDLE << IOPRIO_CLASS_SHIFT) | 0xff)
> #define PRIO_WRITER	(IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT)
> 
> static void do_cmd(char *cmd, int ign_err)
> {
> 	int r;
> 	fprintf(stderr, "* %s\n", cmd);
> 	r = system(cmd);
> 	if (r) {
> 		if (r == -1) {
> 			perror("system");
> 		} else {
> 			if (ign_err) return;
> 			fprintf(stderr, "return code %x\n", r);
> 		}
> 		exit(1);
> 	}
> }
> 
> static char pattern[BS];
> 
> static int h_orig, h_snap;
> static int n;
> static long long test_of;
> static pthread_rwlock_t rw_lock_1;
> static pthread_rwlock_t rw_lock_2;
> static pthread_rwlock_t rw_lock_3;
> static volatile int started = 0;
> 
> static void pthread_error(int r)
> {
> 	fprintf(stderr, "pthread_error: %s\n", strerror(r));
> 	exit(1);
> }
> 
> static void *test_read(long long of)
> {
> 	int r;
> 	char *t = memalign(BS, BS);
> 	if (!t) perror("memalign"), exit(1);
> 	if ((r = pread(h_snap, t, BS, of)) != BS) {
> 		fprintf(stderr, "can't read (%d): %s\n", r, strerror(errno));
> 		exit(1);
> 	}
> 	if (memcmp(pattern, t, BS)) {
> 		int i;
> 		for (i = 0; i < BS; i++) if (t[i] != pattern[i]) break;
> 		fprintf(stderr, "!!!! SNAPSHOT VOLUME DAMAGE AT BLOCK OFFSET %llX, BYTE OFFSET %X: %02x != %02x\n", of, i, (unsigned char)t[i], (unsigned char)pattern[i]);
> 		exit(2);
> 	}
> 	free(t);
> 	return NULL;
> }
> 
> static void *test_thread(void *_)
> {
> 	int r;
> 	_ = _;
> 	//fprintf(stderr, "start\n");
> 	if ((r = ioprio_set(IOPRIO_WHO_PROCESS, 0, PRIO_READER))) perror("ioprio_set"), exit(1);
> 	if ((r = pthread_rwlock_rdlock(&rw_lock_2))) pthread_error(r);
> 	started = 1;
> 	if ((r = ioprio_get(IOPRIO_WHO_PROCESS, 0)) != PRIO_READER) {
> 		if (r == -1) perror("ioprio_get");
> 		else fprintf(stderr, "reader priority not set: %x\n", r);
> 		exit(1);
> 	}
> 	again:
> 	if ((r = pthread_rwlock_rdlock(&rw_lock_1))) pthread_error(r);
> 	if ((r = pthread_rwlock_unlock(&rw_lock_2))) pthread_error(r);
> 	if (test_of == -1) {
> 		if ((r = pthread_rwlock_unlock(&rw_lock_1))) pthread_error(r);
> 		//fprintf(stderr, "return\n");
> 		return NULL;
> 	}
> 	//fprintf(stderr, "test(%lld)\n", test_of);
> 	test_read(test_of);
> 	if ((r = pthread_rwlock_rdlock(&rw_lock_3))) pthread_error(r);
> 	if ((r = pthread_rwlock_unlock(&rw_lock_1))) pthread_error(r);
> 	if ((r = pthread_rwlock_rdlock(&rw_lock_2))) pthread_error(r);
> 	if ((r = pthread_rwlock_unlock(&rw_lock_3))) pthread_error(r);
> 	goto again;
> }
> 
> int main(void)
> {
> 	int i, j, r;
> 	char *np;
> 	pthread_t thr[THREADS];
> 
> 	memset(pattern, ORIG_PATTERN, sizeof pattern);
> 
> 	do_cmd("lvremove -f "VG"/"LV_SNAP"", 1);
> 	do_cmd("lvremove -f "VG"/"LV"", 1);
> 	do_cmd("lvcreate -L "MEGABYTES" -n "LV" "VG"", 0);
> 
> 	h_orig = open("/dev/mapper/"VG"-"LV"", O_RDWR);
> 	if (h_orig < 0) perror("open orig"), exit(1);
> 	if (lseek(h_orig, SKEW, SEEK_SET) == -1) perror("lseek"), exit(1);
> 	n = 0;
> 	while (write(h_orig, pattern, BS) == BS) {
> 		n++;
> 		fprintf(stderr, "creating %llx...\r", (long long)n * BS + SKEW);
> 	}
> 	if (fsync(h_orig)) perror("fsync"), exit(1);
> 	fprintf(stderr,"\n");
> 	lseek(h_orig, 0, SEEK_SET);
> 	close(h_orig);
> 
> 	do_cmd("lvcreate -L "SNAP_MEGABYTES" -n "LV_SNAP" -s "VG"/"LV"", 0);
> 
> 	h_orig = open("/dev/mapper/"VG"-"LV"", O_RDWR | O_DIRECT);
> 	if (h_orig < 0) perror("open orig"), exit(1);
> 
> 	h_snap = open("/dev/mapper/"VG"-"LV_SNAP"", O_RDONLY | O_DIRECT);
> 	if (h_snap < 0) perror("open snap"), exit(1);
> 
> 	if ((r = pthread_rwlock_init(&rw_lock_1, NULL))) pthread_error(r);
> 	if ((r = pthread_rwlock_init(&rw_lock_2, NULL))) pthread_error(r);
> 	if ((r = pthread_rwlock_init(&rw_lock_3, NULL))) pthread_error(r);
> 	if ((r = pthread_rwlock_wrlock(&rw_lock_1))) pthread_error(r);
> 	if ((r = pthread_rwlock_wrlock(&rw_lock_3))) pthread_error(r);
> 
> 	if ((r = ioprio_set(IOPRIO_WHO_PROCESS, 0, PRIO_WRITER))) perror("ioprio_set"), exit(1);
> 
> 	for (j = 0; j < THREADS; j++) {
> 		if ((r = pthread_create(&thr[j], NULL, test_thread, NULL))) pthread_error(r);
> 	}
> 	while (!started) usleep(1000);
> 
> 	if ((r = ioprio_get(IOPRIO_WHO_PROCESS, 0)) != PRIO_WRITER) {
> 		if (r == -1) perror("ioprio_get");
> 		else fprintf(stderr, "writer priority not set: %x\n", r);
> 		exit(1);
> 	}
> 
> 	np = memalign(BS, BS);
> 	if (!np) perror("memalign"), exit(1);
> 	memset(np, NEW_PATTERN, BS);
> 	for (i = 0; i < n; i++) {
> 		test_of = (off_t)i * BS + SKEW;
> 		fprintf(stderr, "testing %llx...\r", test_of);
> 		if ((r = pthread_rwlock_unlock(&rw_lock_1))) pthread_error(r);
> 		sched_yield();
> 		if (pwrite(h_orig, np, BS, test_of) != BS) {
> 			fprintf(stderr, "can't write (%d): %s\n", r, strerror(errno));
> 			exit(1);
> 		}
> 		if ((r = pthread_rwlock_wrlock(&rw_lock_2))) pthread_error(r);
> 		if ((r = pthread_rwlock_unlock(&rw_lock_3))) pthread_error(r);
> 		if ((r = pthread_rwlock_wrlock(&rw_lock_1))) pthread_error(r);
> 		if ((r = pthread_rwlock_unlock(&rw_lock_2))) pthread_error(r);
> 		if ((r = pthread_rwlock_wrlock(&rw_lock_3))) pthread_error(r);
> 	}
> 	fprintf(stderr,"\n");
> 
> 	test_of = -1;
> 	if ((r = pthread_rwlock_unlock(&rw_lock_1))) pthread_error(r);
> 
> 	for (j = 0; j < THREADS; j++) {
> 		if ((r = pthread_join(thr[j], NULL))) pthread_error(r);
> 	}
> 
> 	fprintf(stderr, "TEST PASSED OK.\n");
> 
> 	return 0;
> }
> 
> 

Here I post a patch that fixes the snapshot deadlock. On schedule(), it 
redirects bios on current->bio_list to helper workqueues.

Mikulas


From f126e182a053ef2e44a3e70b86df84d2b003530b Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 27 May 2014 11:03:36 -0400
Subject: block: flush queued bios when process blocks to avoid deadlock

The block layer uses per-process bio list to avoid recursion in
generic_make_request.  When generic_make_request is called recursively,
the bio is added to current->bio_list and generic_make_request returns
immediately.  The top-level instance of generic_make_request takes bios
from current->bio_list and processes them.

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

Index: linux-4.9-rc3/block/bio.c
===================================================================
--- linux-4.9-rc3.orig/block/bio.c	2016-11-02 23:05:03.000000000 +0100
+++ linux-4.9-rc3/block/bio.c	2016-11-02 23:05:21.000000000 +0100
@@ -353,35 +353,37 @@ static void bio_alloc_rescue(struct work
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
@@ -421,7 +423,6 @@ static void punt_bios_to_rescuer(struct 
  */
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
-	gfp_t saved_gfp = gfp_mask;
 	unsigned front_pad;
 	unsigned inline_vecs;
 	struct bio_vec *bvl = NULL;
@@ -455,23 +456,11 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
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
@@ -486,12 +475,6 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
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
 
Index: linux-4.9-rc3/include/linux/blkdev.h
===================================================================
--- linux-4.9-rc3.orig/include/linux/blkdev.h	2016-11-02 23:05:03.000000000 +0100
+++ linux-4.9-rc3/include/linux/blkdev.h	2016-11-02 23:05:21.000000000 +0100
@@ -1118,6 +1118,22 @@ static inline bool blk_needs_flush_plug(
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
@@ -1729,16 +1745,10 @@ static inline void blk_flush_plug(struct
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
Index: linux-4.9-rc3/kernel/sched/core.c
===================================================================
--- linux-4.9-rc3.orig/kernel/sched/core.c	2016-11-02 23:05:03.000000000 +0100
+++ linux-4.9-rc3/kernel/sched/core.c	2016-11-02 23:05:21.000000000 +0100
@@ -3440,11 +3440,10 @@ static inline void sched_submit_work(str
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
@@ -5067,7 +5066,7 @@ long __sched io_schedule_timeout(long ti
 	long ret;
 
 	current->in_iowait = 1;
-	blk_schedule_flush_plug(current);
+	blk_flush_queued_io(current);
 
 	delayacct_blkio_start();
 	rq = raw_rq();
