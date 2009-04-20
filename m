From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/16] bottom-layer barrier support
Date: Mon, 20 Apr 2009 03:50:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200350370.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904100107160.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200348180.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200349181.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200349560.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200349560.6097@hs20-bc2-1.build.redhat.com>
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

dm-accumulate-barrier_error.patch

Change md->barrier_error so that it can accumulate more errors
(the first one is reported).

With the following patches, more errors could happen.
Return the first error to the caller.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm.c	2009-04-15 16:32:10.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm.c	2009-04-15 16:35:23.000000000 +0200
@@ -565,7 +565,8 @@ static void dec_pending(struct dm_io *io
 			 * a per-device variable for error reporting.
 			 * Note that you can't touch the bio after end_io_acct
 			 */
-			md->barrier_error = io_error;
+			if (!md->barrier_error)
+				md->barrier_error = io_error;
 			end_io_acct(io);
 		} else {
 			end_io_acct(io);
@@ -878,7 +879,8 @@ static void __split_and_process_bio(stru
 		if (!bio_barrier(bio))
 			bio_io_error(bio);
 		else
-			md->barrier_error = -EIO;
+			if (!md->barrier_error)
+				md->barrier_error = -EIO;
 		return;
 	}
 
@@ -1450,16 +1452,15 @@ static void dm_flush(struct mapped_devic
 
 static void process_barrier(struct mapped_device *md, struct bio *bio)
 {
+	md->barrier_error = 0;
+
 	dm_flush(md);
 
-	if (bio_empty_barrier(bio)) {
-		bio_endio(bio, 0);
-		return;
+	if (!bio_empty_barrier(bio)) {
+		__split_and_process_bio(md, bio);
+		dm_flush(md);
 	}
 
-	__split_and_process_bio(md, bio);
-	dm_flush(md);
-
 	if (md->barrier_error != DM_ENDIO_REQUEUE)
 		bio_endio(bio, md->barrier_error);
 	else {
