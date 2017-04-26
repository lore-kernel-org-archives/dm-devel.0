From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] dm mpath: merge do_end_io into multipath_end_io
Date: Wed, 26 Apr 2017 09:40:36 +0200
Message-ID: <20170426074039.14602-2-hch@lst.de>
References: <20170426074039.14602-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170426074039.14602-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

This simplifies the I/O completion path a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c | 53 +++++++++++++++++----------------------------------
 1 file changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 2950b145443d..1973670ea102 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1473,12 +1473,12 @@ static int noretry_error(int error)
 	return 0;
 }
 
-/*
- * end_io handling
- */
-static int do_end_io(struct multipath *m, struct request *clone,
-		     int error, struct dm_mpath_io *mpio)
+static int multipath_end_io(struct dm_target *ti, struct request *clone,
+			    int error, union map_info *map_context)
 {
+	struct dm_mpath_io *mpio = get_mpio(map_context);
+	struct pgpath *pgpath = mpio->pgpath;
+
 	/*
 	 * We don't queue any clone request inside the multipath target
 	 * during end I/O handling, since those clone requests don't have
@@ -1490,47 +1490,30 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	 * request into dm core, which will remake a clone request and
 	 * clone bios for it and resubmit it later.
 	 */
-	int r = DM_ENDIO_REQUEUE;
-
-	if (!error)
-		return 0;	/* I/O complete */
+	if (error && !noretry_error(error)) {
+		struct multipath *m = ti->private;
 
-	if (noretry_error(error))
-		return error;
+		error = DM_ENDIO_REQUEUE;
 
-	if (mpio->pgpath)
-		fail_path(mpio->pgpath);
+		if (pgpath)
+			fail_path(pgpath);
 
-	if (!atomic_read(&m->nr_valid_paths)) {
-		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
-			if (!must_push_back_rq(m))
-				r = -EIO;
+		if (!atomic_read(&m->nr_valid_paths)) {
+			if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
+				if (!must_push_back_rq(m))
+					error = -EIO;
+			}
 		}
 	}
 
-	return r;
-}
-
-static int multipath_end_io(struct dm_target *ti, struct request *clone,
-			    int error, union map_info *map_context)
-{
-	struct multipath *m = ti->private;
-	struct dm_mpath_io *mpio = get_mpio(map_context);
-	struct pgpath *pgpath;
-	struct path_selector *ps;
-	int r;
-
-	BUG_ON(!mpio);
-
-	r = do_end_io(m, clone, error, mpio);
-	pgpath = mpio->pgpath;
 	if (pgpath) {
-		ps = &pgpath->pg->ps;
+		struct path_selector *ps = &pgpath->pg->ps;
+
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
 
-	return r;
+	return error;
 }
 
 static int do_end_io_bio(struct multipath *m, struct bio *clone,
-- 
2.11.0
