From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 4/7] dm: reflect new defined return value symbols
	to targets
Date: Tue, 10 Oct 2006 17:30:54 -0400 (EDT)
Message-ID: <20061010.173054.21933652.k-ueda@ct.jp.nec.com>
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

This patch reflects the symbol definition for target map/end_io
function to targets.
Should have no effect on the behavior.


Test results:
Done build test without errors.


The patch is for:
    2.6.18-mm2 + patch 1-3

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 3-core-rval-iface-change/drivers/md/dm-crypt.c 4-target-rval-iface-change/drivers/md/dm-crypt.c
--- 3-core-rval-iface-change/drivers/md/dm-crypt.c	2006-10-05 10:23:59.000000000 -0400
+++ 4-target-rval-iface-change/drivers/md/dm-crypt.c	2006-10-06 13:03:55.000000000 -0400
@@ -907,7 +907,7 @@ static int crypt_map(struct dm_target *t
 	atomic_set(&io->pending, 0);
 	kcryptd_queue_io(io);
 
-	return 0;
+	return DM_MAPIO_SUBMITTED;
 }
 
 static int crypt_status(struct dm_target *ti, status_type_t type,
diff -rupN 3-core-rval-iface-change/drivers/md/dm-linear.c 4-target-rval-iface-change/drivers/md/dm-linear.c
--- 3-core-rval-iface-change/drivers/md/dm-linear.c	2006-10-05 10:23:59.000000000 -0400
+++ 4-target-rval-iface-change/drivers/md/dm-linear.c	2006-10-06 13:05:02.000000000 -0400
@@ -77,7 +77,7 @@ static int linear_map(struct dm_target *
 	bio->bi_bdev = lc->dev->bdev;
 	bio->bi_sector = lc->start + (bio->bi_sector - ti->begin);
 
-	return 1;
+	return DM_MAPIO_REMAPPED;
 }
 
 static int linear_status(struct dm_target *ti, status_type_t type,
diff -rupN 3-core-rval-iface-change/drivers/md/dm-mpath.c 4-target-rval-iface-change/drivers/md/dm-mpath.c
--- 3-core-rval-iface-change/drivers/md/dm-mpath.c	2006-10-05 10:23:59.000000000 -0400
+++ 4-target-rval-iface-change/drivers/md/dm-mpath.c	2006-10-06 13:02:32.000000000 -0400
@@ -285,7 +285,7 @@ failed:
 static int map_io(struct multipath *m, struct bio *bio, struct mpath_io *mpio,
 		  unsigned was_queued)
 {
-	int r = 1;
+	int r = DM_MAPIO_REMAPPED;
 	unsigned long flags;
 	struct pgpath *pgpath;
 
@@ -310,7 +310,7 @@ static int map_io(struct multipath *m, s
 		    !m->queue_io)
 			queue_work(kmultipathd, &m->process_queued_ios);
 		pgpath = NULL;
-		r = 0;
+		r = DM_MAPIO_SUBMITTED;
 	} else if (!pgpath)
 		r = -EIO;		/* Failed */
 	else
@@ -372,7 +372,7 @@ static void dispatch_queued_ios(struct m
 		r = map_io(m, bio, mpio, 1);
 		if (r < 0)
 			bio_endio(bio, bio->bi_size, r);
-		else if (r == 1)
+		else if (r == DM_MAPIO_REMAPPED)
 			generic_make_request(bio);
 
 		bio = next;
@@ -1040,7 +1040,7 @@ static int do_end_io(struct multipath *m
 		queue_work(kmultipathd, &m->process_queued_ios);
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	return 1;	/* io not complete */
+	return DM_ENDIO_INCOMPLETE;	/* io not complete */
 }
 
 static int multipath_end_io(struct dm_target *ti, struct bio *bio,
@@ -1058,7 +1058,7 @@ static int multipath_end_io(struct dm_ta
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path);
 	}
-	if (r <= 0)
+	if (r != DM_ENDIO_INCOMPLETE)
 		mempool_free(mpio, m->mpio_pool);
 
 	return r;
diff -rupN 3-core-rval-iface-change/drivers/md/dm-raid1.c 4-target-rval-iface-change/drivers/md/dm-raid1.c
--- 3-core-rval-iface-change/drivers/md/dm-raid1.c	2006-10-05 10:23:59.000000000 -0400
+++ 4-target-rval-iface-change/drivers/md/dm-raid1.c	2006-10-06 13:12:56.000000000 -0400
@@ -1122,7 +1122,7 @@ static int mirror_map(struct dm_target *
 
 	if (rw == WRITE) {
 		queue_bio(ms, bio, rw);
-		return 0;
+		return DM_MAPIO_SUBMITTED;
 	}
 
 	r = ms->rh.log->type->in_sync(ms->rh.log,
@@ -1131,7 +1131,7 @@ static int mirror_map(struct dm_target *
 		return r;
 
 	if (r == -EWOULDBLOCK)	/* FIXME: ugly */
-		r = 0;
+		r = DM_MAPIO_SUBMITTED;
 
 	/*
 	 * We don't want to fast track a recovery just for a read
@@ -1144,7 +1144,7 @@ static int mirror_map(struct dm_target *
 	if (!r) {
 		/* Pass this io over to the daemon */
 		queue_bio(ms, bio, rw);
-		return 0;
+		return DM_MAPIO_SUBMITTED;
 	}
 
 	m = choose_mirror(ms, bio->bi_sector);
@@ -1152,7 +1152,7 @@ static int mirror_map(struct dm_target *
 		return -EIO;
 
 	map_bio(ms, m, bio);
-	return 1;
+	return DM_MAPIO_REMAPPED;
 }
 
 static int mirror_end_io(struct dm_target *ti, struct bio *bio,
diff -rupN 3-core-rval-iface-change/drivers/md/dm-snap.c 4-target-rval-iface-change/drivers/md/dm-snap.c
--- 3-core-rval-iface-change/drivers/md/dm-snap.c	2006-10-05 10:23:59.000000000 -0400
+++ 4-target-rval-iface-change/drivers/md/dm-snap.c	2006-10-06 13:21:02.000000000 -0400
@@ -867,7 +867,7 @@ static int snapshot_map(struct dm_target
 {
 	struct exception *e;
 	struct dm_snapshot *s = (struct dm_snapshot *) ti->private;
-	int r = 1;
+	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
 	struct pending_exception *pe = NULL;
 
@@ -913,7 +913,7 @@ static int snapshot_map(struct dm_target
 		remap_exception(s, &pe->e, bio);
 		bio_list_add(&pe->snapshot_bios, bio);
 
-		r = 0;
+		r = DM_MAPIO_SUBMITTED;
 
 		if (!pe->started) {
 			/* this is protected by snap->lock */
@@ -991,7 +991,7 @@ static int snapshot_status(struct dm_tar
  *---------------------------------------------------------------*/
 static int __origin_write(struct list_head *snapshots, struct bio *bio)
 {
-	int r = 1, first = 0;
+	int r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
 	struct exception *e;
 	struct pending_exception *pe, *next_pe, *primary_pe = NULL;
@@ -1049,7 +1049,7 @@ static int __origin_write(struct list_he
 
 			bio_list_add(&primary_pe->origin_bios, bio);
 
-			r = 0;
+			r = DM_MAPIO_SUBMITTED;
 		}
 
 		if (!pe->primary_pe) {
@@ -1098,7 +1098,7 @@ static int __origin_write(struct list_he
 static int do_origin(struct dm_dev *origin, struct bio *bio)
 {
 	struct origin *o;
-	int r = 1;
+	int r = DM_MAPIO_REMAPPED;
 
 	down_read(&_origins_lock);
 	o = __lookup_origin(origin->bdev);
@@ -1155,7 +1155,7 @@ static int origin_map(struct dm_target *
 		return -EOPNOTSUPP;
 
 	/* Only tell snapshots if this is a write */
-	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : 1;
+	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : DM_MAPIO_REMAPPED;
 }
 
 #define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
diff -rupN 3-core-rval-iface-change/drivers/md/dm-stripe.c 4-target-rval-iface-change/drivers/md/dm-stripe.c
--- 3-core-rval-iface-change/drivers/md/dm-stripe.c	2006-09-19 23:42:06.000000000 -0400
+++ 4-target-rval-iface-change/drivers/md/dm-stripe.c	2006-10-06 13:21:35.000000000 -0400
@@ -186,7 +186,7 @@ static int stripe_map(struct dm_target *
 	bio->bi_bdev = sc->stripe[stripe].dev->bdev;
 	bio->bi_sector = sc->stripe[stripe].physical_start +
 	    (chunk << sc->chunk_shift) + (offset & sc->chunk_mask);
-	return 1;
+	return DM_MAPIO_REMAPPED;
 }
 
 static int stripe_status(struct dm_target *ti,
diff -rupN 3-core-rval-iface-change/drivers/md/dm-zero.c 4-target-rval-iface-change/drivers/md/dm-zero.c
--- 3-core-rval-iface-change/drivers/md/dm-zero.c	2006-09-19 23:42:06.000000000 -0400
+++ 4-target-rval-iface-change/drivers/md/dm-zero.c	2006-10-06 13:21:51.000000000 -0400
@@ -46,7 +46,7 @@ static int zero_map(struct dm_target *ti
 	bio_endio(bio, bio->bi_size, 0);
 
 	/* accepted bio, don't make new request */
-	return 0;
+	return DM_MAPIO_SUBMITTED;
 }
 
 static struct target_type zero_target = {
