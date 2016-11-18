From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 12/14] dm-mpath: Micro-optimize the hot path
Date: Fri, 18 Nov 2016 14:29:41 -0800
Message-ID: <67385207-63cf-02e3-c794-9fa1146562aa@sandisk.com>
References: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Instead of checking MPATHF_QUEUE_IF_NO_PATH,
MPATHF_SAVED_QUEUE_IF_NO_PATH and the no_flush flag to decide whether
or not to push back a request if there are no paths available, only
clear MPATHF_QUEUE_IF_NO_PATH in queue_if_no_path() if no_flush has
not been set. The result is that only a single bit has to be tested
in the hot path to decide whether or not a request must be pushed
back and also that m->lock does not have to be taken in the hot path.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-mpath.c | 70 ++++++++-------------------------------------------
 1 file changed, 11 insertions(+), 59 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5c73818..fff5d12 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -489,47 +489,6 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
 }
 
 /*
- * Check whether bios must be queued in the device-mapper core rather
- * than here in the target.
- *
- * If m->queue_if_no_path and m->saved_queue_if_no_path hold the
- * same value then we are not between multipath_presuspend()
- * and multipath_resume() calls and we have no need to check
- * for the DMF_NOFLUSH_SUSPENDING flag.
- */
-static bool __must_push_back(struct multipath *m)
-{
-	return ((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=
-		 test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) &&
-		dm_noflush_suspending(m->ti));
-}
-
-static bool must_push_back_rq(struct multipath *m)
-{
-	bool r;
-	unsigned long flags;
-
-	spin_lock_irqsave(&m->lock, flags);
-	r = (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
-	     __must_push_back(m));
-	spin_unlock_irqrestore(&m->lock, flags);
-
-	return r;
-}
-
-static bool must_push_back_bio(struct multipath *m)
-{
-	bool r;
-	unsigned long flags;
-
-	spin_lock_irqsave(&m->lock, flags);
-	r = __must_push_back(m);
-	spin_unlock_irqrestore(&m->lock, flags);
-
-	return r;
-}
-
-/*
  * Map cloned requests (request-based multipath)
  */
 static int __multipath_map(struct dm_target *ti, struct request *clone,
@@ -549,7 +508,7 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		pgpath = choose_pgpath(m, nr_bytes);
 
 	if (!pgpath) {
-		if (must_push_back_rq(m))
+		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
 			return DM_MAPIO_DELAY_REQUEUE;
 		return -EIO;	/* Failed */
 	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
@@ -651,9 +610,9 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio, struct dm_m
 	}
 
 	if (!pgpath) {
-		if (!must_push_back_bio(m))
-			return -EIO;
-		return DM_MAPIO_REQUEUE;
+		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
+			return DM_MAPIO_REQUEUE;
+		return -EIO;
 	}
 
 	mpio->pgpath = pgpath;
@@ -745,7 +704,7 @@ static int queue_if_no_path(struct multipath *m, bool queue_if_no_path,
 		else
 			clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
 	}
-	if (queue_if_no_path)
+	if (queue_if_no_path || dm_noflush_suspending(m->ti))
 		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
 	else
 		clear_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
@@ -1578,12 +1537,9 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);
 
-	if (!atomic_read(&m->nr_valid_paths)) {
-		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
-			if (!must_push_back_rq(m))
-				r = -EIO;
-		}
-	}
+	if (atomic_read(&m->nr_valid_paths) == 0 &&
+	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
+		r = -EIO;
 
 	return r;
 }
@@ -1625,13 +1581,9 @@ static int do_end_io_bio(struct multipath *m, struct bio *clone,
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);
 
-	if (!atomic_read(&m->nr_valid_paths)) {
-		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
-			if (!must_push_back_bio(m))
-				return -EIO;
-			return DM_ENDIO_REQUEUE;
-		}
-	}
+	if (atomic_read(&m->nr_valid_paths) == 0 &&
+	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
+		return -EIO;
 
 	/* Queue for the daemon to resubmit */
 	dm_bio_restore(get_bio_details_from_bio(clone), clone);
-- 
2.10.1
