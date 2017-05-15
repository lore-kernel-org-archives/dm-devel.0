From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] dm mpath: don't return -EIO from dm_report_EIO
Date: Mon, 15 May 2017 17:28:37 +0200
Message-ID: <20170515152839.23375-3-hch@lst.de>
References: <20170515152839.23375-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170515152839.23375-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Instead just turn the macro into a helper for the warning message.
This removes an unessecary assignment in this patch, and will allow
to fix a place where -EIO is the wrong error value in th next.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 926a6bcb32c8..d55454f98b59 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -447,7 +447,7 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
  * it has been invoked.
  */
 #define dm_report_EIO(m)						\
-({									\
+do {									\
 	struct mapped_device *md = dm_table_get_md((m)->ti->table);	\
 									\
 	pr_debug("%s: returning EIO; QIFNP = %d; SQIFNP = %d; DNFS = %d\n", \
@@ -455,8 +455,7 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
 		 test_bit(MPATHF_QUEUE_IF_NO_PATH, &(m)->flags),	\
 		 test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &(m)->flags),	\
 		 dm_noflush_suspending((m)->ti));			\
-	-EIO;								\
-})
+} while (0)
 
 /*
  * Map cloned requests (request-based multipath)
@@ -481,7 +480,8 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	if (!pgpath) {
 		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
 			return DM_MAPIO_DELAY_REQUEUE;
-		return dm_report_EIO(m);	/* Failed */
+		dm_report_EIO(m);	/* Failed */
+		return -EIO;
 	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
 		   test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
 		if (pg_init_all_paths(m))
@@ -558,7 +558,8 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio, struct dm_m
 	if (!pgpath) {
 		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
 			return DM_MAPIO_REQUEUE;
-		return dm_report_EIO(m);
+		dm_report_EIO(m);
+		return -EIO;
 	}
 
 	mpio->pgpath = pgpath;
@@ -1493,7 +1494,7 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 		if (atomic_read(&m->nr_valid_paths) == 0 &&
 		    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
 			if (error == -EIO)
-				error = dm_report_EIO(m);
+				dm_report_EIO(m);
 			/* complete with the original error */
 			r = DM_ENDIO_DONE;
 		}
@@ -1524,8 +1525,10 @@ static int do_end_io_bio(struct multipath *m, struct bio *clone,
 		fail_path(mpio->pgpath);
 
 	if (atomic_read(&m->nr_valid_paths) == 0 &&
-	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
-		return dm_report_EIO(m);
+	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
+		dm_report_EIO(m);
+		return -EIO;
+	}
 
 	/* Queue for the daemon to resubmit */
 	dm_bio_restore(get_bio_details_from_bio(clone), clone);
-- 
2.11.0
