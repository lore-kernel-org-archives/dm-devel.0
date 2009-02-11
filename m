From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: 2.6.28.2 & dm-snapshot or kcopyd Oops
Date: Wed, 11 Feb 2009 05:54:02 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902110552550.20020@hs20-bc2-1.build.redhat.com>
References: <200901231836184950432@163.com>,
	<Pine.LNX.4.64.0901231514590.9877@hs20-bc2-1.build.redhat.com>,
	<200901301800149019891@163.com>,
	<Pine.LNX.4.64.0901301533390.5744@hs20-bc2-1.build.redhat.com>,
	<200901311416111648168@163.com>,
	<Pine.LNX.4.64.0902031505180.28433@hs20-bc2-1.build.redhat.com>,
	<200902051113011850587@163.com>,
	<Pine.LNX.4.64.0902051749150.5515@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902052218040.5380@hs20-bc2-1.build.redhat.com>,
	<200902061924107769776@163.com>,
	<Pine.LNX.4.64.0902061815440.11986@hs20-bc2-1.build.redhat.com>,
	<200902072041046488539@163.com>,
	<Pine.LNX.4.64.0902090311340.28754@hs20-bc2-1.build.redhat.com>
	<200902101305353713189@163.com>
	<Pine.LNX.4.64.0902101832050.386@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0902101832050.386@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jacky Kim <jcy_2008@163.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

> Hi
> 
> I have found another bug in dm-snapshots, I think it won't fix your crash 
> but it is a bug anyway, so it should be fixed. Apply the below patch.
> 
> I'll send you some more debug patches to pinpoint the crash you are 
> seeing.
> 
> Mikulas

Hi

Here is another patch to pinpoint your crashes, so apply it and run the 
same workload. Thanks for testing it.

Mikulas

---
 drivers/md/dm-exception-store.c |   63 +++++++++++++++++++++++++++++++++++-----
 drivers/md/dm-snap.c            |   51 +++++++++++++++++++++++++++++---
 drivers/md/dm-snap.h            |    3 +
 3 files changed, 106 insertions(+), 11 deletions(-)

Index: linux-2.6.28-clean/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.28-clean.orig/drivers/md/dm-exception-store.c	2009-02-11 00:39:23.000000000 +0100
+++ linux-2.6.28-clean/drivers/md/dm-exception-store.c	2009-02-11 10:33:11.000000000 +0100
@@ -619,14 +619,18 @@ struct dm_snap_pending_exception {
 	 * kcopyd.
 	 */
 	int started;
+
+	struct list_head list_all;
 };
 
+static DEFINE_SPINLOCK(callback_spinlock);
+
 static void persistent_commit(struct exception_store *store,
 			      struct dm_snap_exception *e,
 			      void (*callback) (void *, int success),
 			      void *callback_context)
 {
-	unsigned int i;
+	unsigned int i, n;
 	struct pstore *ps = get_info(store);
 	struct disk_exception de;
 	struct commit_callback *cb;
@@ -641,32 +645,41 @@ static void persistent_commit(struct exc
 	BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 	BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 
-	de.old_chunk = e->old_chunk;
-	de.new_chunk = e->new_chunk;
-	write_exception(ps, ps->current_committed++, &de);
-
 	for (i = 0; i < ps->callback_count; i++) {
 		cb = ps->callbacks + i;
 		pe = cb->context;
 		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 		BUG_ON(pe == callback_context);
+		BUG_ON(pe->started != 2);
+	}
+	for (i = 0; i < ps->current_committed; i++) {
+		read_exception(ps, i, &de);
+		BUG_ON(de.old_chunk == e->old_chunk);
+		BUG_ON(de.new_chunk == e->new_chunk);
 	}
+	de.old_chunk = e->old_chunk;
+	de.new_chunk = e->new_chunk;
+	write_exception(ps, ps->current_committed++, &de);
+
 	/*
 	 * Add the callback to the back of the array.  This code
 	 * is the only place where the callback array is
 	 * manipulated, and we know that it will never be called
 	 * multiple times concurrently.
 	 */
+	spin_lock_irq(&callback_spinlock);
 	cb = ps->callbacks + ps->callback_count++;
 	cb->callback = callback;
 	cb->context = callback_context;
+	spin_unlock_irq(&callback_spinlock);
 
 	for (i = 0; i < ps->callback_count; i++) {
 		cb = ps->callbacks + i;
 		pe = cb->context;
 		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
+		BUG_ON(pe->started != 2);
 	}
 	/*
 	 * If there are exceptions in flight and we have not yet
@@ -677,6 +690,7 @@ static void persistent_commit(struct exc
 		pe = callback_context;
 		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
+		BUG_ON(pe->started != 2);
 		return;
 	}
 	for (i = 0; i < ps->callback_count; i++) {
@@ -684,6 +698,7 @@ static void persistent_commit(struct exc
 		pe = cb->context;
 		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
+		BUG_ON(pe->started != 2);
 	}
 
 
@@ -714,17 +729,45 @@ static void persistent_commit(struct exc
 		pe = cb->context;
 		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
+		BUG_ON(pe->started != 2);
 	}
 
-	for (i = 0; i < ps->callback_count; i++) {
+	spin_lock_irq(&callback_spinlock);
+	n = ps->callback_count;
+	ps->callback_count = 0;
+	spin_unlock_irq(&callback_spinlock);
+	for (i = 0; i < n; i++) {
 		cb = ps->callbacks + i;
 		pe = cb->context;
+		BUG_ON(pe->started != 2);
 		BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 		BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 		cb->callback(cb->context, ps->valid);
 	}
+}
 
-	ps->callback_count = 0;
+static void persistent_check(struct exception_store *store, void *context, int line)
+{
+	struct pstore *ps = get_info(store);
+	unsigned long flags;
+	unsigned i;
+	struct commit_callback *cb;
+	struct dm_snap_pending_exception *pe;
+
+	spin_lock_irqsave(&callback_spinlock, flags);
+	for (i = 0; i < ps->callback_count; i++) {
+		cb = ps->callbacks + i;
+		pe = cb->context;
+		if (pe == context) {
+			printk("CALLED FROM LINE %d\n", line);
+			BUG();
+		}
+		if (pe->started != 2) {
+			printk("CALLED FROM LINE %d\n", line);
+			BUG();
+		}
+	}
+	spin_unlock_irqrestore(&callback_spinlock, flags);
 }
 
 static void persistent_drop(struct exception_store *store)
@@ -769,6 +812,7 @@ int dm_create_persistent(struct exceptio
 	store->read_metadata = persistent_read_metadata;
 	store->prepare_exception = persistent_prepare;
 	store->commit_exception = persistent_commit;
+	store->check_pending_exception = persistent_check;
 	store->drop_snapshot = persistent_drop;
 	store->fraction_full = persistent_fraction_full;
 	store->context = ps;
@@ -824,6 +868,10 @@ static void transient_fraction_full(stru
 	*denominator = get_dev_size(store->snap->cow->bdev);
 }
 
+static void transient_check(struct exception_store *store, void *context, int line)
+{
+}
+
 int dm_create_transient(struct exception_store *store)
 {
 	struct transient_c *tc;
@@ -832,6 +880,7 @@ int dm_create_transient(struct exception
 	store->read_metadata = transient_read_metadata;
 	store->prepare_exception = transient_prepare;
 	store->commit_exception = transient_commit;
+	store->check_pending_exception = transient_check;
 	store->drop_snapshot = NULL;
 	store->fraction_full = transient_fraction_full;
 
Index: linux-2.6.28-clean/drivers/md/dm-snap.h
===================================================================
--- linux-2.6.28-clean.orig/drivers/md/dm-snap.h	2009-02-11 00:39:36.000000000 +0100
+++ linux-2.6.28-clean/drivers/md/dm-snap.h	2009-02-11 09:54:45.000000000 +0100
@@ -114,6 +114,9 @@ struct exception_store {
 				  void (*callback) (void *, int success),
 				  void *callback_context);
 
+	void (*check_pending_exception)(struct exception_store *store,
+				void *callback_context, int line);
+
 	/*
 	 * The snapshot is invalid, note this in the metadata.
 	 */
Index: linux-2.6.28-clean/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28-clean.orig/drivers/md/dm-snap.c	2009-02-11 03:15:26.000000000 +0100
+++ linux-2.6.28-clean/drivers/md/dm-snap.c	2009-02-11 10:20:55.000000000 +0100
@@ -88,6 +88,8 @@ struct dm_snap_pending_exception {
 	 * kcopyd.
 	 */
 	int started;
+
+	struct list_head list_all;
 };
 
 /*
@@ -365,20 +367,45 @@ static void free_exception(struct dm_sna
 	kmem_cache_free(exception_cache, e);
 }
 
+static DEFINE_SPINLOCK(pending_spinlock);
+static LIST_HEAD(pending_all);
+
 static struct dm_snap_pending_exception *alloc_pending_exception(struct dm_snapshot *s)
 {
 	struct dm_snap_pending_exception *pe = mempool_alloc(s->pending_pool,
 							     GFP_NOIO);
+	struct dm_snap_pending_exception *pe2;
 
 	atomic_inc(&s->pending_exceptions_count);
 	pe->snap = s;
 
+	spin_lock(&pending_spinlock);
+	list_for_each_entry(pe2, &pending_all, list_all) {
+		BUG_ON(pe2 == pe);
+	}
+	list_add(&pe->list_all, &pending_all);
+	spin_unlock(&pending_spinlock);
+
+	s->store.check_pending_exception(&s->store, pe, __LINE__);
+
 	return pe;
 }
 
 static void free_pending_exception(struct dm_snap_pending_exception *pe)
 {
 	struct dm_snapshot *s = pe->snap;
+	struct dm_snap_pending_exception *pe2;
+
+	s->store.check_pending_exception(&s->store, pe, __LINE__);
+
+	spin_lock(&pending_spinlock);
+	list_for_each_entry(pe2, &pending_all, list_all) {
+		if (pe2 == pe) goto found;
+	}
+	BUG();
+	found:
+	list_del(&pe->list_all);
+	spin_unlock(&pending_spinlock);
 
 	mempool_free(pe, s->pending_pool);
 	smp_mb__before_atomic_dec();
@@ -831,6 +858,8 @@ static struct bio *put_pending_exception
 	struct dm_snap_pending_exception *primary_pe;
 	struct bio *origin_bios = NULL;
 
+	pe->snap->store.check_pending_exception(&pe->snap->store, pe, __LINE__);
+
 	primary_pe = pe->primary_pe;
 
 	/*
@@ -862,12 +891,15 @@ static void pending_complete(struct dm_s
 	struct bio *snapshot_bios = NULL;
 	int error = 0;
 
+	s->store.check_pending_exception(&s->store, pe, __LINE__);
+
 	BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 	BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 
 	if (!success) {
 		/* Read/write error - snapshot is unusable */
 		down_write(&s->lock);
+		s->store.check_pending_exception(&s->store, pe, __LINE__);
 		__invalidate_snapshot(s, -EIO);
 	BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 	BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
@@ -885,6 +917,7 @@ static void pending_complete(struct dm_s
 
 	if (!e) {
 		down_write(&s->lock);
+		s->store.check_pending_exception(&s->store, pe, __LINE__);
 		__invalidate_snapshot(s, -ENOMEM);
 		error = 1;
 		goto out;
@@ -892,6 +925,7 @@ static void pending_complete(struct dm_s
 	*e = pe->e;
 
 	down_write(&s->lock);
+	s->store.check_pending_exception(&s->store, pe, __LINE__);
 	BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 	BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 
@@ -943,6 +977,7 @@ static void commit_callback(void *contex
 {
 	struct dm_snap_pending_exception *pe = context;
 
+	pe->snap->store.check_pending_exception(&pe->snap->store, pe, __LINE__);
 	BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 	BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 
@@ -961,13 +996,15 @@ static void copy_callback(int read_err, 
 	BUG_ON(pe->e.hash_list.next == LIST_POISON1);
 	BUG_ON(pe->e.hash_list.prev == LIST_POISON2);
 
-	if (read_err || write_err)
+	if (read_err || write_err) {
+		s->store.check_pending_exception(&s->store, pe, __LINE__);
 		pending_complete(pe, 0);
-
-	else
+	} else {
+		s->store.check_pending_exception(&s->store, pe, __LINE__);
 		/* Update the metadata if we are persistent */
 		s->store.commit_exception(&s->store, &pe->e, commit_callback,
 					  pe);
+	}
 }
 
 /*
@@ -979,6 +1016,7 @@ static void start_copy(struct dm_snap_pe
 	struct dm_io_region src, dest;
 	struct block_device *bdev = s->origin->bdev;
 	sector_t dev_size;
+	s->store.check_pending_exception(&s->store, pe, __LINE__);
 	BUG_ON(!pe->started);
 	BUG_ON(pe->started == 2);
 	BUG_ON(pe->started != 1);
@@ -1038,6 +1076,7 @@ __find_pending_exception(struct dm_snaps
 	up_write(&s->lock);
 	pe = alloc_pending_exception(s);
 	down_write(&s->lock);
+	s->store.check_pending_exception(&s->store, pe, __LINE__);
 
 	if (!s->valid) {
 		free_pending_exception(pe);
@@ -1071,6 +1110,7 @@ __find_pending_exception(struct dm_snaps
 
 	get_pending_exception(pe);
 	insert_exception(&s->pending, &pe->e);
+	s->store.check_pending_exception(&s->store, pe, __LINE__);
 
  out:
 	return pe;
@@ -1291,6 +1331,7 @@ static int __origin_write(struct list_he
 		}
 
 		if (!pe->started) {
+			snap->store.check_pending_exception(&snap->store, pe, __LINE__);
 			pe->started = 1;
 			list_add_tail(&pe->list, &pe_queue);
 		}
@@ -1319,8 +1360,10 @@ static int __origin_write(struct list_he
 	/*
 	 * Now that we have a complete pe list we can start the copying.
 	 */
-	list_for_each_entry_safe(pe, next_pe, &pe_queue, list)
+	list_for_each_entry_safe(pe, next_pe, &pe_queue, list) {
+		pe->snap->store.check_pending_exception(&pe->snap->store, pe, __LINE__);
 		start_copy(pe);
+	}
 
 	return r;
 }
