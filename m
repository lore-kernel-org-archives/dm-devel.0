From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5/14] barriers
Date: Mon, 23 Feb 2009 14:20:50 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231420360.23293@hs20-bc2-1.build.redhat.com>
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

Rename __split_bio to __process_bio because it not only splits the bio to
serveral parts, but also submits them to target drivers.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.29-rc3-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm.c	2009-02-05 05:38:36.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm.c	2009-02-05 05:39:45.000000000 +0100
@@ -820,9 +820,9 @@ static int __clone_and_map(struct clone_
 }
 
 /*
- * Split the bio into several clones.
+ * Split the bio into several clones and submit it to targets.
  */
-static int __split_bio(struct mapped_device *md, struct bio *bio)
+static int __process_bio(struct mapped_device *md, struct bio *bio)
 {
 	struct clone_info ci;
 	int error = 0;
@@ -945,7 +945,7 @@ static int dm_request(struct request_que
 		down_read(&md->io_lock);
 	}
 
-	r = __split_bio(md, bio);
+	r = __process_bio(md, bio);
 	up_read(&md->io_lock);
 
 out_req:
@@ -1402,7 +1402,7 @@ static void __flush_deferred_io(struct m
 	struct bio *c;
 
 	while ((c = bio_list_pop(&md->deferred))) {
-		if (__split_bio(md, c))
+		if (__process_bio(md, c))
 			bio_io_error(c);
 	}
 
