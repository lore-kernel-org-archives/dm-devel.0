From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v3 11/26] block: Add submit_bio_wait(),
	remove from md
Date: Mon, 24 Sep 2012 15:34:51 -0700
Message-ID: <1348526106-17074-12-git-send-email-koverstreet@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1348526106-17074-1-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: tj@kernel.org, axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>, vgoyal@redhat.com
List-Id: dm-devel.ids

Random cleanup - this code was duplicated and it's not really specific
to md.

Also added the ability to return the actual error code.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/md/raid1.c  | 19 -------------------
 drivers/md/raid10.c | 19 -------------------
 fs/bio.c            | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |  1 +
 4 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index deff0cd..28f506a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2048,25 +2048,6 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 	}
 }
 
-static void bi_complete(struct bio *bio, int error)
-{
-	complete((struct completion *)bio->bi_private);
-}
-
-static int submit_bio_wait(int rw, struct bio *bio)
-{
-	struct completion event;
-	rw |= REQ_SYNC;
-
-	init_completion(&event);
-	bio->bi_private = &event;
-	bio->bi_end_io = bi_complete;
-	submit_bio(rw, bio);
-	wait_for_completion(&event);
-
-	return test_bit(BIO_UPTODATE, &bio->bi_flags);
-}
-
 static int narrow_write_error(struct r1bio *r1_bio, int i)
 {
 	struct mddev *mddev = r1_bio->mddev;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6d06d83..f001c1b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2410,25 +2410,6 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	}
 }
 
-static void bi_complete(struct bio *bio, int error)
-{
-	complete((struct completion *)bio->bi_private);
-}
-
-static int submit_bio_wait(int rw, struct bio *bio)
-{
-	struct completion event;
-	rw |= REQ_SYNC;
-
-	init_completion(&event);
-	bio->bi_private = &event;
-	bio->bi_end_io = bi_complete;
-	submit_bio(rw, bio);
-	wait_for_completion(&event);
-
-	return test_bit(BIO_UPTODATE, &bio->bi_flags);
-}
-
 static int narrow_write_error(struct r10bio *r10_bio, int i)
 {
 	struct bio *bio = r10_bio->master_bio;
diff --git a/fs/bio.c b/fs/bio.c
index 062ba8f..9a30dcf 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -750,6 +750,42 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 }
 EXPORT_SYMBOL(bio_add_page);
 
+struct submit_bio_ret {
+	struct completion event;
+	int error;
+};
+
+static void submit_bio_wait_endio(struct bio *bio, int error)
+{
+	struct submit_bio_ret *ret = bio->bi_private;
+
+	ret->error = error;
+	complete(&ret->event);
+}
+
+/**
+ * submit_bio_wait - submit a bio, and wait until it completes
+ * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
+ * @bio: The &struct bio which describes the I/O
+ *
+ * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
+ * bio_endio() on failure.
+ */
+int submit_bio_wait(int rw, struct bio *bio)
+{
+	struct submit_bio_ret ret;
+
+	rw |= REQ_SYNC;
+	init_completion(&ret.event);
+	bio->bi_private = &ret;
+	bio->bi_end_io = submit_bio_wait_endio;
+	submit_bio(rw, bio);
+	wait_for_completion(&ret.event);
+
+	return ret.error;
+}
+EXPORT_SYMBOL(submit_bio_wait);
+
 /**
  * bio_advance - increment/complete a bio by some number of bytes
  * @bio:	bio to advance
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d985e90..3bf696b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -252,6 +252,7 @@ extern void bio_endio(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
+extern int submit_bio_wait(int rw, struct bio *bio);
 extern void bio_advance(struct bio *, unsigned);
 
 extern void bio_init(struct bio *);
-- 
1.7.12
