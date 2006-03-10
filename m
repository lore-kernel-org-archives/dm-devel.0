From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] dm: avoid I/O error during suspension in no path
	situation
Date: Fri, 10 Mar 2006 15:35:50 -0500 (EST)
Message-ID: <20060310.153550.71084124.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I'm working on moving queued I/Os in targets into dm core during
suspension so that the table can swap/suspend without the queue
flushing.
Attached patch is made for 2.6.16-rc2 but it should work with
2.6.16-rc5 as there are few changes in dm code.
To implementing this feature, I have some issues I'd like to hear
your opinion about.

1). When the multipath map is going to suspend, must I end the I/O
    if hw handler returns MP_ERROR_IO for it?

2). The current patch implements multipath target only.
    Does other target use this queueing feature?
    In what situations does the push back be needed?

3). As the pending I/Os are just queued and don't complete,
    lock_fs() might not finish.
    I think that we can skip lock_fs() if this feature is enabled.
    e.g. Use nolockfs option or let the presuspend() function
    to tell whether lock_fs() can be done or not.

Comments?
Please see below in details.

Regards and thanks for your time,
Kiyoshi Ueda


===================================================================
BACKGROUND
=-=-=-=-=-=

Currently, all pending I/Os are flushed and returned to upper layers
during suspension.  And the suspention is necesary for swapping table.
So if targets don't have valid devices when swapping table, flushed
I/Os are returnd to applications as errors.

For example, when you use a multipath device (/dev/mapper/mpath0)
mapped to a local device (/dev/sda) with queue_if_no_path setting,
if the /dev/sda is unpluged and re-pluged, the name will be renamed
in current upstream kernel and multipath-tools will issue table reload.
So all queued I/Os in the multipath target will be returned as error.


===================================================================
Explanation of the patch
=-=-=-=-=-=-=-=-=-=-=-=-=

The patch adds a mechanism that each target can request queueing
the I/O in dm core.
Target can request it in the following ways:
    - map() returns 2
    - end_io() returns 2

If requested, dm core queues the I/O temporarily in md->pushbacked
(newly added by this patch).  After waiting for pending I/Os being
either done or queued, md->pushbacked will be merged to md->deferred.

I/Os in md->deferred will be re-issued in resume.

Currently multipath target only.
No implementation for other targets yet.
 

===================================================================
Discussion needed issues
=-=-=-=-=-=-=-=-=-=-=-=-=

1). MP_ERROR_IO return value from hardware handler in multipath.

    hardware handlers can return MP_ERROR_IO in do_end_io().
    The error flag seems to mean that the I/O isn't wanted to be
    requeued.
    So my patch don't push back I/Os with MP_ERROR_IO.
    Is this correct?

2). As for other targets, in what situations does the push back
    be needed?

3). Deadlock problem between errored I/O queuing and lock_fs().

    If swapping table in no path/device situation, I/Os for lock_fs()
    are queued and never return in dm_suspend().
    We already have a workaround: dm_suspend() can take 'nolockfs'
    option and userspace tools can use it.
    So this problem can be solved by changing userspace tools.

    But I think that kernel should taken care of it too.
    My current idea is that targets can tell dm core not to do
    lock_fs() by return value of presuspend() function like below.
    Comments?

	int dm_suspend(struct mapped_device *md, int do_lockfs)
	{
		int dont_lock = 0;
		.....
		dont_lock = dm_target_presuspend_targets(map);
		.....
		if (do_lockfs && !dont_lock) {
			r = lock_fs(md);
			if (r)
				goto out;
		}
		.....
	}


===================================================================
The patch
=-=-=-=-=-=

Currently, all pending I/Os are flushed and returned to upper layers
during suspension.  And the suspention is necesary for swapping table.
So if targets don't have valid devices when swapping table, flushed
I/Os are returnd to applications as errors.

This patch moves queued I/Os in targets into dm core during
suspension so that the table can swap/suspend without the queue
flushing.

Patch for 2.6.16-rc2:
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rup linux-2.6.16-rc2/drivers/md/dm.c linux-2.6.16-rc2.queue/drivers/md/dm.c
--- linux-2.6.16-rc2/drivers/md/dm.c	2006-02-03 01:03:08.000000000 -0500
+++ linux-2.6.16-rc2.queue/drivers/md/dm.c	2006-03-10 12:15:54.000000000 -0500
@@ -61,6 +61,7 @@ union map_info *dm_get_mapinfo(struct bi
 struct mapped_device {
 	struct rw_semaphore io_lock;
 	struct semaphore suspend_lock;
+	spinlock_t pushback_lock;
 	rwlock_t map_lock;
 	atomic_t holders;
 
@@ -77,6 +78,7 @@ struct mapped_device {
 	atomic_t pending;
 	wait_queue_head_t wait;
  	struct bio_list deferred;
+	struct bio_list pushbacked;
 
 	/*
 	 * The current mapping.
@@ -326,7 +328,10 @@ struct dm_table *dm_get_table(struct map
  */
 static void dec_pending(struct dm_io *io, int error)
 {
-	if (error)
+	unsigned long flags;
+
+	/* Push-back supersedes any I/O errors */
+	if (error && io->error <= 0)
 		io->error = error;
 
 	if (atomic_dec_and_test(&io->io_count)) {
@@ -334,7 +339,14 @@ static void dec_pending(struct dm_io *io
 			/* nudge anyone waiting on suspend queue */
 			wake_up(&io->md->wait);
 
-		bio_endio(io->bio, io->bio->bi_size, io->error);
+		if (io->error == DM_EIO_PUSHBACK_NEEDED) {
+			/* target requested to push back the io */
+			spin_lock_irqsave(&io->md->pushback_lock, flags);
+			bio_list_add(&io->md->pushbacked, io->bio);
+			spin_unlock_irqrestore(&io->md->pushback_lock, flags);
+		} else
+			bio_endio(io->bio, io->bio->bi_size, io->error);
+
 		free_io(io->md, io);
 	}
 }
@@ -354,10 +366,10 @@ static int clone_endio(struct bio *bio, 
 
 	if (endio) {
 		r = endio(tio->ti, bio, error, &tio->info);
-		if (r < 0)
+		if (r < 0 || r == DM_EIO_PUSHBACK_NEEDED) {
 			error = r;
 
-		else if (r > 0)
+		} else if (r == DM_EIO_NOT_COMPLETED)
 			/* the target wants another shot at the io */
 			return 1;
 	}
@@ -408,12 +420,12 @@ static void __map_bio(struct dm_target *
 	 */
 	atomic_inc(&tio->io->io_count);
 	r = ti->type->map(ti, clone, &tio->info);
-	if (r > 0)
+	if (r == DM_IO_REMAPPED)
 		/* the bio has been remapped so dispatch it */
 		generic_make_request(clone);
 
-	else if (r < 0) {
-		/* error the io and bail out */
+	else if (r < 0 || r == DM_IO_PUSHBACK_NEEDED) {
+		/* error the io and bail out, or push it back if needed */
 		struct dm_io *io = tio->io;
 		free_tio(tio->io->md, tio);
 		dec_pending(io, r);
@@ -791,6 +803,7 @@ static struct mapped_device *alloc_dev(u
 	memset(md, 0, sizeof(*md));
 	init_rwsem(&md->io_lock);
 	init_MUTEX(&md->suspend_lock);
+	spin_lock_init(&md->pushback_lock);
 	rwlock_init(&md->map_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->event_nr, 0);
@@ -1086,6 +1099,7 @@ static void unlock_fs(struct mapped_devi
 int dm_suspend(struct mapped_device *md, int do_lockfs)
 {
 	struct dm_table *map = NULL;
+	unsigned long flags;
 	DECLARE_WAITQUEUE(wait, current);
 	int r = -EINVAL;
 
@@ -1143,6 +1157,11 @@ int dm_suspend(struct mapped_device *md,
 	down_write(&md->io_lock);
 	remove_wait_queue(&md->wait, &wait);
 
+	spin_lock_irqsave(&md->pushback_lock, flags);
+	bio_list_merge_head(&md->deferred, &md->pushbacked);
+	bio_list_init(&md->pushbacked);
+	spin_unlock_irqrestore(&md->pushback_lock, flags);
+
 	/* were we interrupted ? */
 	r = -EINTR;
 	if (atomic_read(&md->pending)) {
diff -rup linux-2.6.16-rc2/include/linux/device-mapper.h linux-2.6.16-rc2.queue/include/linux/device-mapper.h
--- linux-2.6.16-rc2/include/linux/device-mapper.h	2006-02-03 01:03:08.000000000 -0500
+++ linux-2.6.16-rc2.queue/include/linux/device-mapper.h	2006-03-08 19:06:12.000000000 -0500
@@ -36,7 +36,8 @@ typedef void (*dm_dtr_fn) (struct dm_tar
  * The map function must return:
  * < 0: error
  * = 0: The target will handle the io by resubmitting it later
- * > 0: simple remap complete
+ * = 1: simple remap complete
+ * = 2: The target wants to push back the io
  */
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
 			  union map_info *map_context);
@@ -47,6 +48,7 @@ typedef int (*dm_map_fn) (struct dm_targ
  * 0   : ended successfully
  * 1   : for some reason the io has still not completed (eg,
  *       multipath target might want to requeue a failed io).
+ * 2   : The target wants to push back the io
  */
 typedef int (*dm_endio_fn) (struct dm_target *ti,
 			    struct bio *bio, int error,
diff -rup linux-2.6.16-rc2/drivers/md/dm.h linux-2.6.16-rc2.queue/drivers/md/dm.h
--- linux-2.6.16-rc2/drivers/md/dm.h	2006-02-03 01:03:08.000000000 -0500
+++ linux-2.6.16-rc2.queue/drivers/md/dm.h	2006-03-09 09:39:17.000000000 -0500
@@ -36,6 +36,19 @@
 #define SECTOR_SHIFT 9
 
 /*
+ * Definitions of return values from target map function.
+ */
+#define DM_IO_SUBMITTED		0
+#define DM_IO_REMAPPED		1
+#define DM_IO_PUSHBACK_NEEDED	2
+
+/*
+ * Definitions of return values from target end_io function.
+ */
+#define DM_EIO_NOT_COMPLETED	1
+#define DM_EIO_PUSHBACK_NEEDED	2
+
+/*
  * List of devices that a metadevice uses and should open/close.
  */
 struct dm_dev {
diff -rup linux-2.6.16-rc2/drivers/md/dm-bio-list.h linux-2.6.16-rc2.queue/drivers/md/dm-bio-list.h
--- linux-2.6.16-rc2/drivers/md/dm-bio-list.h	2006-02-03 01:03:08.000000000 -0500
+++ linux-2.6.16-rc2.queue/drivers/md/dm-bio-list.h	2006-03-07 14:28:33.000000000 -0500
@@ -44,6 +44,19 @@ static inline void bio_list_merge(struct
 	bl->tail = bl2->tail;
 }
 
+static inline void bio_list_merge_head(struct bio_list *bl, struct bio_list *bl2)
+{
+	if (!bl2->head)
+		return;
+
+	if (bl->head)
+		bl2->tail->bi_next = bl->head;
+	else
+		bl->tail = bl2->tail;
+
+	bl->head = bl2->head;
+}
+
 static inline struct bio *bio_list_pop(struct bio_list *bl)
 {
 	struct bio *bio = bl->head;
diff -rup linux-2.6.16-rc2/drivers/md/dm-mpath.c linux-2.6.16-rc2.queue/drivers/md/dm-mpath.c
--- linux-2.6.16-rc2/drivers/md/dm-mpath.c	2006-02-03 01:03:08.000000000 -0500
+++ linux-2.6.16-rc2.queue/drivers/md/dm-mpath.c	2006-03-10 12:13:59.000000000 -0500
@@ -285,10 +285,13 @@ failed:
 	m->current_pg = NULL;
 }
 
+#define PUSHBACK_NEEDED(m) (!(m)->queue_if_no_path \
+				 && (m)->saved_queue_if_no_path)
+
 static int map_io(struct multipath *m, struct bio *bio, struct mpath_io *mpio,
 		  unsigned was_queued)
 {
-	int r = 1;
+	int r = DM_IO_REMAPPED;
 	unsigned long flags;
 	struct pgpath *pgpath;
 
@@ -313,10 +316,13 @@ static int map_io(struct multipath *m, s
 		    !m->queue_io)
 			queue_work(kmultipathd, &m->process_queued_ios);
 		pgpath = NULL;
-		r = 0;
-	} else if (!pgpath)
+		r = DM_IO_SUBMITTED;
+	} else if (!pgpath) {
 		r = -EIO;		/* Failed */
-	else
+
+		if (PUSHBACK_NEEDED(m))
+			r = DM_IO_PUSHBACK_NEEDED;
+	} else
 		bio->bi_bdev = pgpath->path.dev->bdev;
 
 	mpio->pgpath = pgpath;
@@ -375,8 +381,12 @@ static void dispatch_queued_ios(struct m
 		r = map_io(m, bio, mpio, 1);
 		if (r < 0)
 			bio_endio(bio, bio->bi_size, r);
-		else if (r == 1)
+		else if (r == DM_IO_REMAPPED)
 			generic_make_request(bio);
+		else if (r == DM_IO_PUSHBACK_NEEDED) {
+			/* Shouldn't pass the r value to bio_endio() ? */
+			bio_endio(bio, bio->bi_size, -EIO);
+		}
 
 		bio = next;
 	}
@@ -789,7 +799,7 @@ static int multipath_map(struct dm_targe
 	map_context->ptr = mpio;
 	bio->bi_rw |= (1 << BIO_RW_FAILFAST);
 	r = map_io(m, bio, mpio, 0);
-	if (r < 0)
+	if (r < 0 || r == DM_IO_PUSHBACK_NEEDED)
 		mempool_free(mpio, m->mpio_pool);
 
 	return r;
@@ -1013,7 +1023,10 @@ static int do_end_io(struct multipath *m
 
 	spin_lock_irqsave(&m->lock, flags);
 	if (!m->nr_valid_paths) {
-		if (!m->queue_if_no_path) {
+		if (PUSHBACK_NEEDED(m)) {
+			spin_unlock_irqrestore(&m->lock, flags);
+			return DM_EIO_PUSHBACK_NEEDED;
+		} else if (!m->queue_if_no_path) {
 			spin_unlock_irqrestore(&m->lock, flags);
 			return -EIO;
 		} else {
@@ -1037,6 +1050,14 @@ static int do_end_io(struct multipath *m
 	if (err_flags & MP_ERROR_IO)
 		return -EIO;
 
+	spin_lock_irqsave(&m->lock, flags);
+	if (PUSHBACK_NEEDED(m)) {
+		/* valid paths may remain, but push back for fast suspention */
+		spin_unlock_irqrestore(&m->lock, flags);
+		return DM_EIO_PUSHBACK_NEEDED;
+	}
+	spin_unlock_irqrestore(&m->lock, flags);
+
       requeue:
 	dm_bio_restore(&mpio->details, bio);
 
@@ -1048,7 +1069,7 @@ static int do_end_io(struct multipath *m
 		queue_work(kmultipathd, &m->process_queued_ios);
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	return 1;	/* io not complete */
+	return DM_EIO_NOT_COMPLETED;	/* io not complete */
 }
 
 static int multipath_end_io(struct dm_target *ti, struct bio *bio,
@@ -1066,7 +1087,7 @@ static int multipath_end_io(struct dm_ta
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path);
 	}
-	if (r <= 0)
+	if (r != DM_EIO_NOT_COMPLETED)
 		mempool_free(mpio, m->mpio_pool);
 
 	return r;
