From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 3/4] dm_queue: dm-mpath to enable fastsuspend
Date: Fri, 23 Jun 2006 17:49:20 -0400 (EDT)
Message-ID: <20060623.174920.18307851.k-ueda@ct.jp.nec.com>
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

This patch replaces the retry I/O queue of multipath target
by dm_queue.
Multipath target uses the fastsuspend feature for the queue.
By using the feature, queued bios are handed over to the new table
when table is swapped.

The patch is for 2.6.17-rc6-mm1 + Alasdair's patches which was sent
to this ML (Subject: "Next set of device-mapper patches").

Regards,
Kiyoshi Ueda


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 2.6.17-rc6-mm1.agk/drivers/md/dm-mpath.c 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm-mpath.c
--- 2.6.17-rc6-mm1.agk/drivers/md/dm-mpath.c	2006-06-09 16:50:42.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm-mpath.c	2006-06-23 09:31:20.000000000 -0400
@@ -75,10 +75,6 @@ struct multipath {
 	unsigned queue_if_no_path;	/* Queue I/O if last path fails? */
 	unsigned saved_queue_if_no_path;/* Saved state during suspension */
 
-	struct work_struct process_queued_ios;
-	struct bio_list queued_ios;
-	unsigned queue_size;
-
 	struct work_struct trigger_event;
 
 	/*
@@ -106,6 +102,11 @@ struct workqueue_struct *kmultipathd;
 static void process_queued_ios(void *data);
 static void trigger_event(void *data);
 
+enum {
+	RETRY_QUEUE,
+	NUM_QUEUES
+};
+
 
 /*-----------------------------------------------
  * Allocation routines
@@ -177,7 +178,6 @@ static struct multipath *alloc_multipath
 		INIT_LIST_HEAD(&m->priority_groups);
 		spin_lock_init(&m->lock);
 		m->queue_io = 1;
-		INIT_WORK(&m->process_queued_ios, process_queued_ios, m);
 		INIT_WORK(&m->trigger_event, trigger_event, m);
 		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
 		if (!m->mpio_pool) {
@@ -284,12 +284,12 @@ failed:
 	m->current_pg = NULL;
 }
 
-static int map_io(struct multipath *m, struct bio *bio, struct mpath_io *mpio,
-		  unsigned was_queued)
+static int map_io(struct multipath *m, struct bio *bio, struct mpath_io *mpio)
 {
 	int r = 1;
 	unsigned long flags;
 	struct pgpath *pgpath;
+	struct dm_queue *q;
 
 	spin_lock_irqsave(&m->lock, flags);
 
@@ -300,17 +300,14 @@ static int map_io(struct multipath *m, s
 
 	pgpath = m->current_pgpath;
 
-	if (was_queued)
-		m->queue_size--;
-
 	if ((pgpath && m->queue_io) ||
 	    (!pgpath && m->queue_if_no_path)) {
 		/* Queue for the daemon to resubmit */
-		bio_list_add(&m->queued_ios, bio);
-		m->queue_size++;
+		q = dm_queue_find(m->ti->queues, RETRY_QUEUE);
+		dm_queue_add_bio(q, bio);
 		if ((m->pg_init_required && !m->pg_init_in_progress) ||
 		    !m->queue_io)
-			queue_work(kmultipathd, &m->process_queued_ios);
+			dm_queue_process(q);
 		pgpath = NULL;
 		r = 0;
 	} else if (!pgpath)
@@ -332,6 +329,7 @@ static int queue_if_no_path(struct multi
 			    unsigned save_old_value)
 {
 	unsigned long flags;
+	struct dm_queue *q;
 
 	spin_lock_irqsave(&m->lock, flags);
 
@@ -340,8 +338,10 @@ static int queue_if_no_path(struct multi
 	else
 		m->saved_queue_if_no_path = queue_if_no_path;
 	m->queue_if_no_path = queue_if_no_path;
-	if (!m->queue_if_no_path && m->queue_size)
-		queue_work(kmultipathd, &m->process_queued_ios);
+	if (!m->queue_if_no_path) {
+		q = dm_queue_find(m->ti->queues, RETRY_QUEUE);
+		dm_queue_process(q);
+	}
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
@@ -352,38 +352,32 @@ static int queue_if_no_path(struct multi
  * The multipath daemon is responsible for resubmitting queued ios.
  *---------------------------------------------------------------*/
 
-static void dispatch_queued_ios(struct multipath *m)
+static void dispatch_queued_ios(struct dm_queue *q)
 {
+	struct dm_target *ti = dm_queue_get_target(q);
+	struct multipath *m = (struct multipath *) ti->private;
 	int r;
-	unsigned long flags;
-	struct bio *bio = NULL, *next;
+	struct bio *bio;
 	struct mpath_io *mpio;
 	union map_info *info;
 
-	spin_lock_irqsave(&m->lock, flags);
-	bio = bio_list_get(&m->queued_ios);
-	spin_unlock_irqrestore(&m->lock, flags);
-
-	while (bio) {
-		next = bio->bi_next;
-		bio->bi_next = NULL;
-
+	while ((bio = dm_queue_pop_bio(q))) {
 		info = dm_get_mapinfo(bio);
 		mpio = info->ptr;
 
-		r = map_io(m, bio, mpio, 1);
+		r = map_io(m, bio, mpio);
 		if (r < 0)
 			bio_endio(bio, bio->bi_size, r);
 		else if (r == 1)
 			generic_make_request(bio);
-
-		bio = next;
 	}
 }
 
 static void process_queued_ios(void *data)
 {
-	struct multipath *m = (struct multipath *) data;
+	struct dm_queue *q = (struct dm_queue *) data;
+	struct dm_target *ti = dm_queue_get_target(q);
+	struct multipath *m = (struct multipath *) ti->private;
 	struct hw_handler *hwh = &m->hw_handler;
 	struct pgpath *pgpath = NULL;
 	unsigned init_required = 0, must_queue = 1;
@@ -391,7 +385,7 @@ static void process_queued_ios(void *dat
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (!m->queue_size)
+	if (!dm_queue_size(q) || dm_queue_freezing(q))
 		goto out;
 
 	if (!m->current_pgpath)
@@ -416,7 +410,7 @@ out:
 		hwh->type->pg_init(hwh, pgpath->pg->bypassed, &pgpath->path);
 
 	if (!must_queue)
-		dispatch_queued_ios(m);
+		dispatch_queued_ios(q);
 }
 
 /*
@@ -698,6 +692,7 @@ static int multipath_ctr(struct dm_targe
 
 	int r;
 	struct multipath *m;
+	struct dm_queue *q;
 	struct arg_set as;
 	unsigned pg_count = 0;
 	unsigned next_pg_num;
@@ -751,6 +746,18 @@ static int multipath_ctr(struct dm_targe
 		goto bad;
 	}
 
+	/* allocate and initiarize queue for retry io */
+	ti->queues = dm_queue_alloc(NUM_QUEUES);
+	if (!ti->queues) {
+		ti->error = ESTR("can't allocate queues");
+		r = -ENOMEM;
+		goto bad;
+	}
+	ti->num_queues = NUM_QUEUES;
+	q = dm_queue_find(ti->queues, RETRY_QUEUE);
+	dm_queue_setup(q, process_queued_ios, ti);
+	dm_queue_enable_fastsuspend(q);
+
 	ti->private = m;
 	m->ti = ti;
 
@@ -764,6 +771,13 @@ static int multipath_ctr(struct dm_targe
 static void multipath_dtr(struct dm_target *ti)
 {
 	struct multipath *m = (struct multipath *) ti->private;
+	int i;
+
+	for (i = 0; i < ti->num_queues; i++) {
+		struct dm_queue *q = dm_queue_find(ti->queues, i);
+		dm_queue_flush(q);
+	}
+	dm_queue_free(ti->queues);
 
 	flush_workqueue(kmultipathd);
 	free_multipath(m);
@@ -787,7 +801,7 @@ static int multipath_map(struct dm_targe
 
 	map_context->ptr = mpio;
 	bio->bi_rw |= (1 << BIO_RW_FAILFAST);
-	r = map_io(m, bio, mpio, 0);
+	r = map_io(m, bio, mpio);
 	if (r < 0)
 		mempool_free(mpio, m->mpio_pool);
 
@@ -834,6 +848,7 @@ static int reinstate_path(struct pgpath 
 	int r = 0;
 	unsigned long flags;
 	struct multipath *m = pgpath->pg->m;
+	struct dm_queue *q;
 
 	spin_lock_irqsave(&m->lock, flags);
 
@@ -854,8 +869,10 @@ static int reinstate_path(struct pgpath 
 	pgpath->path.is_active = 1;
 
 	m->current_pgpath = NULL;
-	if (!m->nr_valid_paths++ && m->queue_size)
-		queue_work(kmultipathd, &m->process_queued_ios);
+	if (!m->nr_valid_paths++) {
+		q = dm_queue_find(m->ti->queues, RETRY_QUEUE);
+		dm_queue_process(q);
+	}
 
 	queue_work(kmultipathd, &m->trigger_event);
 
@@ -967,6 +984,7 @@ void dm_pg_init_complete(struct path *pa
 	struct pgpath *pgpath = path_to_pgpath(path);
 	struct priority_group *pg = pgpath->pg;
 	struct multipath *m = pg->m;
+	struct dm_queue *q;
 	unsigned long flags;
 
 	/* We insist on failing the path if the PG is already bypassed. */
@@ -987,7 +1005,8 @@ void dm_pg_init_complete(struct path *pa
 		m->queue_io = 0;
 
 	m->pg_init_in_progress = 0;
-	queue_work(kmultipathd, &m->process_queued_ios);
+	q = dm_queue_find(m->ti->queues, RETRY_QUEUE);
+	dm_queue_process(q);
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
@@ -1000,6 +1019,7 @@ static int do_end_io(struct multipath *m
 	struct hw_handler *hwh = &m->hw_handler;
 	unsigned err_flags = MP_FAIL_PATH;	/* Default behavior */
 	unsigned long flags;
+	struct dm_queue *q;
 
 	if (!error)
 		return 0;	/* I/O complete */
@@ -1041,10 +1061,10 @@ static int do_end_io(struct multipath *m
 
 	/* queue for the daemon to resubmit or fail */
 	spin_lock_irqsave(&m->lock, flags);
-	bio_list_add(&m->queued_ios, bio);
-	m->queue_size++;
+	q = dm_queue_find(m->ti->queues, RETRY_QUEUE);
+	dm_queue_add_bio(q, bio);
 	if (!m->queue_io)
-		queue_work(kmultipathd, &m->process_queued_ios);
+		dm_queue_process(q);
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	return 1;	/* io not complete */
@@ -1071,6 +1091,17 @@ static int multipath_end_io(struct dm_ta
 	return r;
 }
 
+static int multipath_unmap(struct dm_target *ti, struct bio *bio,
+			   union map_info *map_context)
+{
+	struct multipath *m = (struct multipath *) ti->private;
+	struct mpath_io *mpio = (struct mpath_io *) map_context->ptr;
+
+	mempool_free(mpio, m->mpio_pool);
+
+	return 0;
+}
+
 /*
  * Suspend can't complete until all the I/O is processed so if
  * the last path fails we must error any remaining I/O.
@@ -1091,10 +1122,14 @@ static void multipath_resume(struct dm_t
 {
 	struct multipath *m = (struct multipath *) ti->private;
 	unsigned long flags;
+	struct dm_queue *q;
 
 	spin_lock_irqsave(&m->lock, flags);
 	m->queue_if_no_path = m->saved_queue_if_no_path;
 	spin_unlock_irqrestore(&m->lock, flags);
+
+	q = dm_queue_find(ti->queues, RETRY_QUEUE);
+	dm_queue_process(q);
 }
 
 /*
@@ -1120,6 +1155,7 @@ static int multipath_status(struct dm_ta
 	unsigned long flags;
 	struct multipath *m = (struct multipath *) ti->private;
 	struct hw_handler *hwh = &m->hw_handler;
+	struct dm_queue *q = dm_queue_find(ti->queues, RETRY_QUEUE);
 	struct priority_group *pg;
 	struct pgpath *p;
 	unsigned pg_num;
@@ -1129,7 +1165,7 @@ static int multipath_status(struct dm_ta
 
 	/* Features */
 	if (type == STATUSTYPE_INFO)
-		DMEMIT("1 %u ", m->queue_size);
+		DMEMIT("1 %u ", dm_queue_size(q));
 	else if (m->queue_if_no_path)
 		DMEMIT("1 queue_if_no_path ");
 	else
@@ -1297,6 +1333,7 @@ static struct target_type multipath_targ
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
 	.map = multipath_map,
+	.unmap = multipath_unmap,
 	.end_io = multipath_end_io,
 	.presuspend = multipath_presuspend,
 	.resume = multipath_resume,
