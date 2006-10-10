From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 7/7] dm: add the pushback feature to the
	multipath target
Date: Tue, 10 Oct 2006 17:32:38 -0400 (EDT)
Message-ID: <20061010.173238.88469778.k-ueda@ct.jp.nec.com>
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

This patch implements the feature which the multipath target returns
the pushback request if needed.

The pushback request can be accepted by the dm core only when:
  1). The suspend is being issued with 'DMF_NOFLUSH_SUSPENDING' flag.
      (Otherwise, the bio is returned to applications with EIO.)
From the practical multipath usage, the pushback request should be
needed only when:
  2). No valid paths.
  3). queue_if_no_path is specified.

To check whether queue_if_no_path is specified or not, you need to
check both queue_if_no_path and saved_queue_if_no_path, because
presuspend saves original queue_if_no_path value to
saved_queue_if_no_path.

So multipath target must check the conditions above to request pushback.
The check for 2) already exists in both of map_io() and do_end_io().
So this patch adds the '__PUSHBACK()' macro to check 1) and 3), and
use it after the check for 2).


Test results:
See the test results of the patch 6.


The patch is for:
    2.6.18-mm2 + patch 1-6

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 6-core-pushback/drivers/md/dm-mpath.c 7-mpath-pushback/drivers/md/dm-mpath.c
--- 6-core-pushback/drivers/md/dm-mpath.c	2006-10-06 13:42:29.000000000 -0400
+++ 7-mpath-pushback/drivers/md/dm-mpath.c	2006-10-06 13:49:10.000000000 -0400
@@ -282,6 +282,23 @@ failed:
 	m->current_pg = NULL;
 }
 
+/*
+ * Check if multipath target needs to push back bios to device-mapper core.
+ * This macro checks if:
+ *   o The device is in the process of being suspended with 'noflush' flag,
+ *     because the dm core accepts pushback request only in that case.
+ *     (dm_noflush_suspending() returns true only in that case.)
+ *   o queue_if_no_path had been set before the suspend process has begun.
+ *     (In the suspend process, the presuspend hook will have run and
+ *      moved the real queue_if_no_path state into saved_queue_if_no_path.
+ *      So in that case, queue_if_no_path should be 0 and
+ *      saved_queue_if_no_path should be 1.)
+ *
+ * (m)->lock must be held before using this macro.
+ */
+#define __PUSHBACK(m) (!(m)->queue_if_no_path && (m)->saved_queue_if_no_path && \
+		       dm_noflush_suspending((m)->ti))
+
 static int map_io(struct multipath *m, struct bio *bio, struct mpath_io *mpio,
 		  unsigned was_queued)
 {
@@ -311,9 +328,12 @@ static int map_io(struct multipath *m, s
 			queue_work(kmultipathd, &m->process_queued_ios);
 		pgpath = NULL;
 		r = DM_MAPIO_SUBMITTED;
-	} else if (!pgpath)
+	} else if (!pgpath) {
 		r = -EIO;		/* Failed */
-	else
+
+		if (__PUSHBACK(m))
+			r = DM_MAPIO_REQUEUE;
+	} else
 		bio->bi_bdev = pgpath->path.dev->bdev;
 
 	mpio->pgpath = pgpath;
@@ -374,6 +394,14 @@ static void dispatch_queued_ios(struct m
 			bio_endio(bio, bio->bi_size, r);
 		else if (r == DM_MAPIO_REMAPPED)
 			generic_make_request(bio);
+		else if (r == DM_MAPIO_REQUEUE)
+			/*
+			 * end_io handles the requeue request by
+			 * returning the bio with error status.
+			 * We don't return the r value to end_io,
+			 * since it is probably not needed.
+			 */
+			bio_endio(bio, bio->bi_size, -EIO);
 
 		bio = next;
 	}
@@ -781,7 +809,7 @@ static int multipath_map(struct dm_targe
 	map_context->ptr = mpio;
 	bio->bi_rw |= (1 << BIO_RW_FAILFAST);
 	r = map_io(m, bio, mpio, 0);
-	if (r < 0)
+	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		mempool_free(mpio, m->mpio_pool);
 
 	return r;
@@ -1005,7 +1033,10 @@ static int do_end_io(struct multipath *m
 
 	spin_lock_irqsave(&m->lock, flags);
 	if (!m->nr_valid_paths) {
-		if (!m->queue_if_no_path) {
+		if (__PUSHBACK(m)) {
+			spin_unlock_irqrestore(&m->lock, flags);
+			return DM_ENDIO_REQUEUE;
+		} else if (!m->queue_if_no_path) {
 			spin_unlock_irqrestore(&m->lock, flags);
 			return -EIO;
 		} else {
