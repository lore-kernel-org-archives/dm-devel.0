From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 08/11] dm: mpath: use noflush suspending
Date: Wed, 22 Nov 2006 19:04:18 +0000
Message-ID: <20061122190418.GY6993@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

This patch implements the pushback feature for the multipath target.

The pushback request is used when:
  1) there are no valid paths;
  2) queue_if_no_path was set;
  3) a suspend is being issued with the DMF_NOFLUSH_SUSPENDING flag.
     Otherwise bios are returned to applications with -EIO.

To check whether queue_if_no_path is specified or not, you need to check
both queue_if_no_path and saved_queue_if_no_path, because presuspend saves
the original queue_if_no_path value to saved_queue_if_no_path.

The check for 1 already exists in both map_io() and do_end_io().
So this patch adds __must_push_back() to check 2 and 3.


Test results:
See the test results in the preceding patch.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com

Index: linux-2.6.19-rc6/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.19-rc6.orig/drivers/md/dm-mpath.c	2006-11-22 17:26:58.000000000 +0000
+++ linux-2.6.19-rc6/drivers/md/dm-mpath.c	2006-11-22 17:27:00.000000000 +0000
@@ -282,6 +282,23 @@ failed:
 	m->current_pg = NULL;
 }
 
+/*
+ * Check whether bios must be queued in the device-mapper core rather
+ * than here in the target.
+ *
+ * m->lock must be held on entry.
+ *
+ * If m->queue_if_no_path and m->saved_queue_if_no_path hold the
+ * same value then we are not between multipath_presuspend()
+ * and multipath_resume() calls and we have no need to check
+ * for the DMF_NOFLUSH_SUSPENDING flag.
+ */
+static int __must_push_back(struct multipath *m)
+{
+	return (m->queue_if_no_path != m->saved_queue_if_no_path &&
+		dm_noflush_suspending(m->ti));
+}
+
 static int map_io(struct multipath *m, struct bio *bio, struct mpath_io *mpio,
 		  unsigned was_queued)
 {
@@ -311,10 +328,12 @@ static int map_io(struct multipath *m, s
 			queue_work(kmultipathd, &m->process_queued_ios);
 		pgpath = NULL;
 		r = DM_MAPIO_SUBMITTED;
-	} else if (!pgpath)
-		r = -EIO;		/* Failed */
-	else
+	} else if (pgpath)
 		bio->bi_bdev = pgpath->path.dev->bdev;
+	else if (__must_push_back(m))
+		r = DM_MAPIO_REQUEUE;
+	else
+		r = -EIO;	/* Failed */
 
 	mpio->pgpath = pgpath;
 
@@ -374,6 +393,8 @@ static void dispatch_queued_ios(struct m
 			bio_endio(bio, bio->bi_size, r);
 		else if (r == DM_MAPIO_REMAPPED)
 			generic_make_request(bio);
+		else if (r == DM_MAPIO_REQUEUE)
+			bio_endio(bio, bio->bi_size, -EIO);
 
 		bio = next;
 	}
@@ -781,7 +802,7 @@ static int multipath_map(struct dm_targe
 	map_context->ptr = mpio;
 	bio->bi_rw |= (1 << BIO_RW_FAILFAST);
 	r = map_io(m, bio, mpio, 0);
-	if (r < 0)
+	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		mempool_free(mpio, m->mpio_pool);
 
 	return r;
@@ -1005,7 +1026,10 @@ static int do_end_io(struct multipath *m
 
 	spin_lock_irqsave(&m->lock, flags);
 	if (!m->nr_valid_paths) {
-		if (!m->queue_if_no_path) {
+		if (__must_push_back(m)) {
+			spin_unlock_irqrestore(&m->lock, flags);
+			return DM_ENDIO_REQUEUE;
+		} else if (!m->queue_if_no_path) {
 			spin_unlock_irqrestore(&m->lock, flags);
 			return -EIO;
 		} else {
