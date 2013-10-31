From: Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH] Btrfs: update bi_remaining to relfect our bio endio chaining
Date: Thu, 31 Oct 2013 15:38:20 -0400
Message-ID: <20131031193820.10239.79827@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

Btrfs is sometimes calling bio_endio twice on the same bio while
we chain things.  This makes sure we don't trip over new assertions in
fs/bio.c

Signed-off-by: Chris Mason <chris.mason@fusionio.com>

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 7fcac70..5b30360 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2289,6 +2289,10 @@ static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
 		block = next_block;
 	} while (NULL != block);
 
+	/*
+	 * since we're not using bio_endio here, we don't need to worry about
+	 * the remaining count
+	 */
 	bp->bi_end_io(bp, bio_error_status);
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62176ad..786ddac 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1684,7 +1684,7 @@ static void end_workqueue_fn(struct btrfs_work *work)
 	bio->bi_private = end_io_wq->private;
 	bio->bi_end_io = end_io_wq->end_io;
 	kfree(end_io_wq);
-	bio_endio(bio, error);
+	bio_endio_nodec(bio, error);
 }
 
 static int cleaner_kthread(void *arg)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ef48947..a31448f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5284,9 +5284,17 @@ static void btrfs_end_bio(struct bio *bio, int err)
 		}
 	}
 
-	if (bio == bbio->orig_bio)
+	if (bio == bbio->orig_bio) {
 		is_orig_bio = 1;
 
+		/*
+		 * eventually we will call the bi_endio for the original bio,
+		 * make sure that we've properly bumped bi_remaining to reflect
+		 * our chain of endios here
+		 */
+		atomic_inc(&bio->bi_remaining);
+	}
+
 	if (atomic_dec_and_test(&bbio->stripes_pending)) {
 		if (!is_orig_bio) {
 			bio_put(bio);
