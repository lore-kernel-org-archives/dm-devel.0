From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/14] barriers
Date: Mon, 23 Feb 2009 14:21:06 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231420510.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

Move bio_io_error directly to __process_bio, from its caller.

This saves some code duplication in further patches.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

Index: linux-2.6.29-rc3-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm.c	2009-02-05 05:39:45.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm.c	2009-02-05 05:40:54.000000000 +0100
@@ -822,18 +822,20 @@ static int __clone_and_map(struct clone_
 /*
  * Split the bio into several clones and submit it to targets.
  */
-static int __process_bio(struct mapped_device *md, struct bio *bio)
+static void __process_bio(struct mapped_device *md, struct bio *bio)
 {
 	struct clone_info ci;
 	int error = 0;
 
 	ci.map = dm_get_table(md);
-	if (unlikely(!ci.map))
-		return -EIO;
+	if (unlikely(!ci.map)) {
+		bio_io_error(bio);
+		return;
+	}
 	if (unlikely(bio_barrier(bio) && !dm_table_barrier_ok(ci.map))) {
 		dm_table_put(ci.map);
 		bio_endio(bio, -EOPNOTSUPP);
-		return 0;
+		return;
 	}
 	ci.md = md;
 	ci.bio = bio;
@@ -853,8 +855,6 @@ static int __process_bio(struct mapped_d
 	/* drop the extra reference count */
 	dec_pending(ci.io, error);
 	dm_table_put(ci.map);
-
-	return 0;
 }
 /*-----------------------------------------------------------------
  * CRUD END
@@ -945,8 +945,9 @@ static int dm_request(struct request_que
 		down_read(&md->io_lock);
 	}
 
-	r = __process_bio(md, bio);
+	__process_bio(md, bio);
 	up_read(&md->io_lock);
+	return 0;
 
 out_req:
 	if (r < 0)
@@ -1401,10 +1402,8 @@ static void __flush_deferred_io(struct m
 {
 	struct bio *c;
 
-	while ((c = bio_list_pop(&md->deferred))) {
-		if (__process_bio(md, c))
-			bio_io_error(c);
-	}
+	while ((c = bio_list_pop(&md->deferred)))
+		__process_bio(md, c);
 
 	clear_bit(DMF_BLOCK_IO, &md->flags);
 }
