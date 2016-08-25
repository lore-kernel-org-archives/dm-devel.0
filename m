From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH RFC] dm: Fix a bio leak in dec_pending()
Date: Thu, 25 Aug 2016 13:57:31 -0700
Message-ID: <1e64fe53-ed57-ef97-a077-19a153506e63@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Ensure that bio_endio() is called if io->error == DM_ENDIO_REQUEUE and
__noflush_suspending(md) returns false. Posting this as an RFC since I'm
not really familiar with the dm code.

Fixes: commit 2e93ccc1933d ("dm: suspend: add noflush pushback")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
---
 drivers/md/dm.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fa9b1cb..6e04357 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -767,6 +767,7 @@ static void dec_pending(struct dm_io *io, int error)
 	int io_error;
 	struct bio *bio;
 	struct mapped_device *md = io->md;
+	int noflush_suspending;
 
 	/* Push-back supersedes any I/O errors */
 	if (unlikely(error)) {
@@ -782,12 +783,16 @@ static void dec_pending(struct dm_io *io, int error)
 			 * Target requested pushing back the I/O.
 			 */
 			spin_lock_irqsave(&md->deferred_lock, flags);
-			if (__noflush_suspending(md))
+			noflush_suspending = __noflush_suspending(md);
+			if (noflush_suspending)
 				bio_list_add_head(&md->deferred, io->bio);
-			else
-				/* noflush suspend was interrupted. */
-				io->error = -EIO;
 			spin_unlock_irqrestore(&md->deferred_lock, flags);
+
+			if (noflush_suspending)
+				return;
+
+			/* noflush suspend was interrupted. */
+			io->error = -EIO;
 		}
 
 		io_error = io->error;
@@ -795,9 +800,6 @@ static void dec_pending(struct dm_io *io, int error)
 		end_io_acct(io);
 		free_io(md, io);
 
-		if (io_error == DM_ENDIO_REQUEUE)
-			return;
-
 		if ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size) {
 			/*
 			 * Preflush done for flush with data, reissue
-- 
2.9.3
