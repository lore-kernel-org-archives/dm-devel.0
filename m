From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] dm rq: change ->rq_end_io calling conventions
Date: Wed, 26 Apr 2017 09:40:37 +0200
Message-ID: <20170426074039.14602-3-hch@lst.de>
References: <20170426074039.14602-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170426074039.14602-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Instead of returning either a DM_ENDIO_* constant or an error code, add
a new DM_ENDIO_DONE value that means keep errno as is.  This allows us
to easily keep the existing error code in case where we can't push back,
and it also preparares for the new block level status codes with strict
type checking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c         |  8 +++++---
 drivers/md/dm-rq.c            | 17 ++++++++++-------
 include/linux/device-mapper.h |  1 +
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 1973670ea102..9e971be254f4 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1478,6 +1478,7 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 {
 	struct dm_mpath_io *mpio = get_mpio(map_context);
 	struct pgpath *pgpath = mpio->pgpath;
+	int r = DM_ENDIO_DONE;
 
 	/*
 	 * We don't queue any clone request inside the multipath target
@@ -1493,15 +1494,16 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	if (error && !noretry_error(error)) {
 		struct multipath *m = ti->private;
 
-		error = DM_ENDIO_REQUEUE;
+		r = DM_ENDIO_REQUEUE;
 
 		if (pgpath)
 			fail_path(pgpath);
 
 		if (!atomic_read(&m->nr_valid_paths)) {
 			if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
+				/* complete with the original error */
 				if (!must_push_back_rq(m))
-					error = -EIO;
+					r = DM_ENDIO_DONE;
 			}
 		}
 	}
@@ -1513,7 +1515,7 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
 
-	return error;
+	return r;
 }
 
 static int do_end_io_bio(struct multipath *m, struct bio *clone,
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index bff7e3bdb4ed..769f04f83ca2 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -287,7 +287,7 @@ static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_
 
 static void dm_done(struct request *clone, int error, bool mapped)
 {
-	int r = error;
+	int r = DM_ENDIO_DONE;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	dm_request_endio_fn rq_end_io = NULL;
 
@@ -298,7 +298,7 @@ static void dm_done(struct request *clone, int error, bool mapped)
 			r = rq_end_io(tio->ti, clone, error, &tio->info);
 	}
 
-	if (unlikely(r == -EREMOTEIO)) {
+	if (unlikely(error == -EREMOTEIO)) {
 		if (req_op(clone) == REQ_OP_WRITE_SAME &&
 		    !clone->q->limits.max_write_same_sectors)
 			disable_write_same(tio->md);
@@ -307,16 +307,19 @@ static void dm_done(struct request *clone, int error, bool mapped)
 			disable_write_zeroes(tio->md);
 	}
 
-	if (r <= 0)
+	switch (r) {
+	case DM_ENDIO_DONE:
 		/* The target wants to complete the I/O */
-		dm_end_request(clone, r);
-	else if (r == DM_ENDIO_INCOMPLETE)
+		dm_end_request(clone, error);
+		break;
+	case DM_ENDIO_INCOMPLETE:
 		/* The target will handle the I/O */
 		return;
-	else if (r == DM_ENDIO_REQUEUE)
+	case DM_ENDIO_REQUEUE:
 		/* The target wants to requeue the I/O */
 		dm_requeue_original_request(tio, false);
-	else {
+		break;
+	default:
 		DMWARN("unimplemented target endio return value: %d", r);
 		BUG();
 	}
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index c7ea33e38fb9..5bafe3af27cc 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -579,6 +579,7 @@ extern struct ratelimit_state dm_ratelimit_state;
 /*
  * Definitions of return values from target end_io function.
  */
+#define DM_ENDIO_DONE		0
 #define DM_ENDIO_INCOMPLETE	1
 #define DM_ENDIO_REQUEUE	2
 
-- 
2.11.0
