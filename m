From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: reinstate bio-based dm-multipath? (Was: dm-mpath:
	convert to request-based)
Date: Thu, 12 Nov 2009 19:08:41 +0900
Message-ID: <4AFBDEA9.704@ct.jp.nec.com>
References: <4A24CD74.80708@ct.jp.nec.com>
	<4A24CEBD.8010807@ct.jp.nec.com>	<20090827175419.GQ643@agk-dp.fab.redhat.com>
	<4A97646D.1000201@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A97646D.1000201@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

Sorry for the late reply.

On 08/28/2009 02:00 PM +0900, Kiyoshi Ueda wrote:
> Hi Alasdair,
> 
> On 08/28/2009 02:54 AM +0900, Alasdair G Kergon wrote:
>> On Tue, Jun 02, 2009 at 04:03:25PM +0900, Kiyoshi Ueda wrote:
>>> This patch converts dm-multipath target to request-based from bio-based.
>>  
>> How much effort would it be to retain the old mpath implementation
>> in parallel?
>>
>> I'm rather concerned that we're losing some useful functionality in
>> 2.6.31 with this patch - stacking over bio-based devices (test beds use
>> this and it's helpful for debugging), barrier support - and supporting
>> both would make it easier for people to compare the two implementations
>> and stick to the old one if in their particular circumstances it worked
>> better.
>>
>> Perhaps, dm-mpath could just register two targets (like snapshot does),
>> one bio-based, and one rq-based, sharing most of the functions with
>> wrappers to indicate which is which where necessary?
> 
> Such wrappers need to be made very well to share codes as much as
> possible.  Otherwise, we won't be able to maintain the non-default
> (bio-based?) code, then people won't be able to use it even for
> testing/debugging.
> Also we need to consider the user interface so that user-space tools
> won't be confused.
> 
> I'll look into this when I finish the barrier implementation of
> request-based dm. (hopefully 2.6.32 timeframe, maybe 2.6.33)

Error handling of ->end_io() in bio-based dm-mpath is different from
the one in rq-based dm-mpath:
    bio-based uses the target internal queue for retrying clone.
    On the other hand, rq-based uses dm-core's queue.

This difference makes code sharing difficult.
So, to make such good wrappers, we need to change the end_io/retry
handling of bio-based dm-mpath and dm-core:
    bio-based dm-core applies DM_ENDIO_REQUEUE anytime targets want,
    not only during noflush_suspending.  (Then, bio-based dm-mpath
    pushes the clone needed retry back to bio-based dm-core.)
    It means that "deferred" list can be kicked anytime, resulting in
    changing suspend and barrier processing logic of bio-based dm-core.
    (By the way, by doing this, bio-based dm-mpath doesn't need
     dm_bio_details in dm_mpath_io.  It means rq-based and bio-based
     can use the same type of structure for private data per I/O.
     This also makes code sharing easy.)

That will take a time, since we must be very careful not to break
the existing bio-based dm-core's suspend/barrier code.
I don't come up with any needs for it other than testing purpose.
And for testing purpose, using scsi_debug or adding rq-based
linear/error targets are better approaches, I think.
So I don't think this feature should be proceeded until any strong
requirement is found.

By the way, if we reinstate bio-based dm-multipath without any wrapper,
the patch is like below. (Don't apply this since we won't be able to
maintain well.)

Note: Its target name is "bio_multipath", so the multipath-tools
      doesn't work for it and people must use dmsetup manually.

Thanks,
Kiyoshi Ueda
---
 drivers/md/dm-mpath.c |  223 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 220 insertions(+), 3 deletions(-)

Index: 2.6.32-rc6/drivers/md/dm-mpath.c
===================================================================
--- 2.6.32-rc6.orig/drivers/md/dm-mpath.c
+++ 2.6.32-rc6/drivers/md/dm-mpath.c
@@ -8,6 +8,7 @@
 #include <linux/device-mapper.h>
 
 #include "dm-path-selector.h"
+#include "dm-bio-record.h"
 #include "dm-uevent.h"
 
 #include <linux/ctype.h>
@@ -84,6 +85,7 @@ struct multipath {
 
 	struct work_struct process_queued_ios;
 	struct list_head queued_ios;
+	struct bio_list queued_bios;
 	unsigned queue_size;
 
 	struct work_struct trigger_event;
@@ -103,11 +105,17 @@ struct dm_mpath_io {
 	size_t nr_bytes;
 };
 
+struct dm_bio_mpath_io {
+	struct pgpath *pgpath;
+	size_t nr_bytes;
+	struct dm_bio_details details;
+};
+
 typedef int (*action_fn) (struct pgpath *pgpath);
 
 #define MIN_IOS 256	/* Mempool size */
 
-static struct kmem_cache *_mpio_cache;
+static struct kmem_cache *_mpio_cache, *_bio_mpio_cache;
 
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
 static void process_queued_ios(struct work_struct *work);
@@ -189,6 +197,7 @@ static void free_priority_group(struct p
 static struct multipath *alloc_multipath(struct dm_target *ti)
 {
 	struct multipath *m;
+	struct kmem_cache *mpio_cache;
 
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
 	if (m) {
@@ -198,7 +207,8 @@ static struct multipath *alloc_multipath
 		m->queue_io = 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
-		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
+		mpio_cache = ti->type->map_rq ? _mpio_cache : _bio_mpio_cache;
+		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, mpio_cache);
 		if (!m->mpio_pool) {
 			kfree(m);
 			return NULL;
@@ -371,6 +381,54 @@ static int map_io(struct multipath *m, s
 	return r;
 }
 
+static int map_bio(struct multipath *m, struct bio *clone,
+		   struct dm_bio_mpath_io *mpio, unsigned was_queued)
+{
+	int r = DM_MAPIO_REMAPPED;
+	size_t nr_bytes = clone->bi_size;
+	unsigned long flags;
+	struct pgpath *pgpath;
+
+	spin_lock_irqsave(&m->lock, flags);
+
+	/* Do we need to select a new pgpath? */
+	if (!m->current_pgpath ||
+	    (!m->queue_io && (m->repeat_count && --m->repeat_count == 0)))
+		__choose_pgpath(m, nr_bytes);
+
+	pgpath = m->current_pgpath;
+
+	if (was_queued)
+		m->queue_size--;
+
+	if ((pgpath && m->queue_io) || (!pgpath && m->queue_if_no_path)) {
+		/* Queue for the daemon to resubmit */
+		bio_list_add(&m->queued_bios, clone);
+		m->queue_size++;
+		if ((m->pg_init_required && !m->pg_init_in_progress) ||
+		    !m->queue_io)
+			queue_work(kmultipathd, &m->process_queued_ios);
+		pgpath = NULL;
+		r = DM_MAPIO_SUBMITTED;
+	} else if (pgpath)
+		clone->bi_bdev = pgpath->path.dev->bdev;
+	else if (__must_push_back(m))
+		r = DM_MAPIO_REQUEUE;
+	else
+		r = -EIO;	/* Failed */
+
+	mpio->pgpath = pgpath;
+	mpio->nr_bytes = nr_bytes;
+
+	if (r == DM_MAPIO_REMAPPED && pgpath->pg->ps.type->start_io)
+		pgpath->pg->ps.type->start_io(&pgpath->pg->ps, &pgpath->path,
+					      nr_bytes);
+
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	return r;
+}
+
 /*
  * If we run out of usable paths, should we queue I/O or error it?
  */
@@ -430,6 +488,37 @@ static void dispatch_queued_ios(struct m
 	}
 }
 
+static void dispatch_queued_bios(struct multipath *m)
+{
+	int r;
+	unsigned long flags;
+	struct bio *clone = NULL, *next;
+	struct dm_bio_mpath_io *mpio;
+	union map_info *info;
+
+	spin_lock_irqsave(&m->lock, flags);
+	clone = bio_list_get(&m->queued_bios);
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	while (clone) {
+		next = clone->bi_next;
+		clone->bi_next = NULL;
+
+		info = dm_get_mapinfo(clone);
+		mpio = info->ptr;
+
+		r = map_bio(m, clone, mpio, 1);
+		if (r < 0)
+			bio_endio(clone, r);
+		else if (r == DM_MAPIO_REMAPPED)
+			generic_make_request(clone);
+		else if (r == DM_MAPIO_REQUEUE)
+			bio_endio(clone, -EIO);
+
+		clone = next;
+	}
+}
+
 static void process_queued_ios(struct work_struct *work)
 {
 	struct multipath *m =
@@ -462,8 +551,10 @@ static void process_queued_ios(struct wo
 	}
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
-	if (!must_queue)
+	if (!must_queue) {
 		dispatch_queued_ios(m);
+		dispatch_queued_bios(m);
+	}
 }
 
 /*
@@ -921,6 +1012,28 @@ static int multipath_map(struct dm_targe
 }
 
 /*
+ * Map bios, recording original fields for later in case we have to resubmit
+ */
+static int multipath_map_bio(struct dm_target *ti, struct bio *clone,
+			     union map_info *map_context)
+{
+	int r;
+	struct dm_bio_mpath_io *mpio;
+	struct multipath *m = ti->private;
+
+	mpio = mempool_alloc(m->mpio_pool, GFP_NOIO);
+	dm_bio_record(&mpio->details, clone);
+
+	map_context->ptr = mpio;
+	clone->bi_rw |= (1 << BIO_RW_FAILFAST_TRANSPORT);
+	r = map_bio(m, clone, mpio, 0);
+	if (r < 0 || r == DM_MAPIO_REQUEUE)
+		mempool_free(mpio, m->mpio_pool);
+
+	return r;
+}
+
+/*
  * Take a path out of use.
  */
 static int fail_path(struct pgpath *pgpath)
@@ -1228,6 +1341,52 @@ static int do_end_io(struct multipath *m
 	return r;
 }
 
+static int do_end_bio(struct multipath *m, struct bio *clone,
+		      int error, struct dm_bio_mpath_io *mpio)
+{
+	unsigned long flags;
+
+	if (!error)
+		return 0;	/* I/O complete */
+
+	if ((error == -EWOULDBLOCK) && bio_rw_flagged(clone, BIO_RW_AHEAD))
+		return error;
+
+	if (error == -EOPNOTSUPP)
+		return error;
+
+	spin_lock_irqsave(&m->lock, flags);
+	if (!m->nr_valid_paths) {
+		if (__must_push_back(m)) {
+			spin_unlock_irqrestore(&m->lock, flags);
+			return DM_ENDIO_REQUEUE;
+		} else if (!m->queue_if_no_path) {
+			spin_unlock_irqrestore(&m->lock, flags);
+			return -EIO;
+		} else {
+			spin_unlock_irqrestore(&m->lock, flags);
+			goto requeue;
+		}
+	}
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	if (mpio->pgpath)
+		fail_path(mpio->pgpath);
+
+requeue:
+	dm_bio_restore(&mpio->details, clone);
+
+	/* queue for the daemon to resubmit or fail */
+	spin_lock_irqsave(&m->lock, flags);
+	bio_list_add(&m->queued_bios, clone);
+	m->queue_size++;
+	if (!m->queue_io)
+		queue_work(kmultipathd, &m->process_queued_ios);
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	return DM_ENDIO_INCOMPLETE;	/* io not complete */
+}
+
 static int multipath_end_io(struct dm_target *ti, struct request *clone,
 			    int error, union map_info *map_context)
 {
@@ -1248,6 +1407,27 @@ static int multipath_end_io(struct dm_ta
 	return r;
 }
 
+static int multipath_end_bio(struct dm_target *ti, struct bio *clone,
+			     int error, union map_info *map_context)
+{
+	struct multipath *m = ti->private;
+	struct dm_bio_mpath_io *mpio = map_context->ptr;
+	struct pgpath *pgpath = mpio->pgpath;
+	struct path_selector *ps;
+	int r;
+
+	r  = do_end_bio(m, clone, error, mpio);
+	if (pgpath) {
+		ps = &pgpath->pg->ps;
+		if (ps->type->end_io)
+			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+	}
+	if (r != DM_ENDIO_INCOMPLETE)
+		mempool_free(mpio, m->mpio_pool);
+
+	return r;
+}
+
 /*
  * Suspend can't complete until all the I/O is processed so if
  * the last path fails we must error any remaining I/O.
@@ -1582,6 +1762,22 @@ static struct target_type multipath_targ
 	.busy = multipath_busy,
 };
 
+static struct target_type bio_multipath_target = {
+	.name = "bio_multipath",
+	.version = {1, 1, 0},
+	.module = THIS_MODULE,
+	.ctr = multipath_ctr,
+	.dtr = multipath_dtr,
+	.map = multipath_map_bio,
+	.end_io = multipath_end_bio,
+	.presuspend = multipath_presuspend,
+	.resume = multipath_resume,
+	.status = multipath_status,
+	.message = multipath_message,
+	.ioctl  = multipath_ioctl,
+	.iterate_devices = multipath_iterate_devices,
+};
+
 static int __init dm_multipath_init(void)
 {
 	int r;
@@ -1591,9 +1787,25 @@ static int __init dm_multipath_init(void
 	if (!_mpio_cache)
 		return -ENOMEM;
 
+	_bio_mpio_cache = KMEM_CACHE(dm_bio_mpath_io, 0);
+	if (!_bio_mpio_cache) {
+		kmem_cache_destroy(_mpio_cache);
+		return -ENOMEM;
+	}
+
 	r = dm_register_target(&multipath_target);
 	if (r < 0) {
 		DMERR("register failed %d", r);
+		kmem_cache_destroy(_bio_mpio_cache);
+		kmem_cache_destroy(_mpio_cache);
+		return -EINVAL;
+	}
+
+	r = dm_register_target(&bio_multipath_target);
+	if (r < 0) {
+		DMERR("register failed %d", r);
+		dm_unregister_target(&multipath_target);
+		kmem_cache_destroy(_bio_mpio_cache);
 		kmem_cache_destroy(_mpio_cache);
 		return -EINVAL;
 	}
@@ -1601,7 +1813,9 @@ static int __init dm_multipath_init(void
 	kmultipathd = create_workqueue("kmpathd");
 	if (!kmultipathd) {
 		DMERR("failed to create workqueue kmpathd");
+		dm_unregister_target(&bio_multipath_target);
 		dm_unregister_target(&multipath_target);
+		kmem_cache_destroy(_bio_mpio_cache);
 		kmem_cache_destroy(_mpio_cache);
 		return -ENOMEM;
 	}
@@ -1616,7 +1830,9 @@ static int __init dm_multipath_init(void
 	if (!kmpath_handlerd) {
 		DMERR("failed to create workqueue kmpath_handlerd");
 		destroy_workqueue(kmultipathd);
+		dm_unregister_target(&bio_multipath_target);
 		dm_unregister_target(&multipath_target);
+		kmem_cache_destroy(_bio_mpio_cache);
 		kmem_cache_destroy(_mpio_cache);
 		return -ENOMEM;
 	}
@@ -1633,6 +1849,7 @@ static void __exit dm_multipath_exit(voi
 	destroy_workqueue(kmpath_handlerd);
 	destroy_workqueue(kmultipathd);
 
+	dm_unregister_target(&bio_multipath_target);
 	dm_unregister_target(&multipath_target);
 	kmem_cache_destroy(_mpio_cache);
 }
