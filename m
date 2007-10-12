From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 12/25] dm: tidy bio_io_error usage
Date: Fri, 12 Oct 2007 18:18:31 +0100
Message-ID: <20071012171831.GX24157@agk.fab.redhat.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Use bio_io_error() in only two places and tidy the code,
preparing for later patches.

There is no functional change in this patch.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   37 ++++++++++++++++++-------------------
 1 files changed, 18 insertions(+), 19 deletions(-)

Index: linux-2.6.23/drivers/md/dm.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm.c	2007-10-12 13:15:35.000000000 +0100
+++ linux-2.6.23/drivers/md/dm.c	2007-10-12 13:18:04.000000000 +0100
@@ -751,15 +751,13 @@ static void __clone_and_map(struct clone
 /*
  * Split the bio into several clones.
  */
-static void __split_bio(struct mapped_device *md, struct bio *bio)
+static int __split_bio(struct mapped_device *md, struct bio *bio)
 {
 	struct clone_info ci;
 
 	ci.map = dm_get_table(md);
-	if (!ci.map) {
-		bio_io_error(bio);
-		return;
-	}
+	if (unlikely(!ci.map))
+		return -EIO;
 
 	ci.md = md;
 	ci.bio = bio;
@@ -779,6 +777,8 @@ static void __split_bio(struct mapped_de
 	/* drop the extra reference count */
 	dec_pending(ci.io, 0);
 	dm_table_put(ci.map);
+
+	return 0;
 }
 /*-----------------------------------------------------------------
  * CRUD END
@@ -790,7 +790,7 @@ static void __split_bio(struct mapped_de
  */
 static int dm_request(struct request_queue *q, struct bio *bio)
 {
-	int r;
+	int r = -EIO;
 	int rw = bio_data_dir(bio);
 	struct mapped_device *md = q->queuedata;
 
@@ -815,18 +815,11 @@ static int dm_request(struct request_que
 	while (test_bit(DMF_BLOCK_IO, &md->flags)) {
 		up_read(&md->io_lock);
 
-		if (bio_rw(bio) == READA) {
-			bio_io_error(bio);
-			return 0;
-		}
-
-		r = queue_io(md, bio);
-		if (r < 0) {
-			bio_io_error(bio);
-			return 0;
+		if (bio_rw(bio) != READA)
+			r = queue_io(md, bio);
 
-		} else if (r == 0)
-			return 0;	/* deferred successfully */
+		if (r <= 0)
+			goto out_req;
 
 		/*
 		 * We're in a while loop, because someone could suspend
@@ -835,8 +828,13 @@ static int dm_request(struct request_que
 		down_read(&md->io_lock);
 	}
 
-	__split_bio(md, bio);
+	r = __split_bio(md, bio);
 	up_read(&md->io_lock);
+
+out_req:
+	if (r < 0)
+		bio_io_error(bio);
+
 	return 0;
 }
 
@@ -1251,7 +1249,8 @@ static void __flush_deferred_io(struct m
 	while (c) {
 		n = c->bi_next;
 		c->bi_next = NULL;
-		__split_bio(md, c);
+		if (__split_bio(md, c))
+			bio_io_error(c);
 		c = n;
 	}
 }
