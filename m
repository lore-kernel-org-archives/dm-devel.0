From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/16] bottom-layer barrier support
Date: Mon, 20 Apr 2009 03:49:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200349181.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904100107160.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200348180.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200348180.6097@hs20-bc2-1.build.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

dm-dm_flush-returns-void.patch

Make dm_flush return void. Errors will be signalled in a different way ---
the first error during barrier flush will be stored in md->barrier_error.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm.c	2009-04-15 16:24:25.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm.c	2009-04-15 16:29:51.000000000 +0200
@@ -1442,34 +1442,25 @@ static int dm_wait_for_completion(struct
 	return r;
 }
 
-static int dm_flush(struct mapped_device *md)
+static void dm_flush(struct mapped_device *md)
 {
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
-	return 0;
 }
 
 static void process_barrier(struct mapped_device *md, struct bio *bio)
 {
-	int error = dm_flush(md);
+	dm_flush(md);
 
-	if (unlikely(error)) {
-		bio_endio(bio, error);
-		return;
-	}
 	if (bio_empty_barrier(bio)) {
 		bio_endio(bio, 0);
 		return;
 	}
 
 	__split_and_process_bio(md, bio);
-
-	error = dm_flush(md);
-
-	if (!error && md->barrier_error)
-		error = md->barrier_error;
+	dm_flush(md);
 
 	if (md->barrier_error != DM_ENDIO_REQUEUE)
-		bio_endio(bio, error);
+		bio_endio(bio, md->barrier_error);
 }
 
 /*
