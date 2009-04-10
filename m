From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/11] bottom-layer barrier support
Date: Fri, 10 Apr 2009 01:10:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904100110010.1117@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904100107160.1117@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904100107160.1117@hs20-bc2-1.build.redhat.com>
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

Make dm_flush return void. Errors will be signalled in a different way.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

Index: linux-2.6.30-rc1-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm.c	2009-04-10 06:33:14.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm.c	2009-04-10 06:33:17.000000000 +0200
@@ -1427,10 +1427,9 @@ static int dm_wait_for_completion(struct
 	return r;
 }
 
-static int dm_flush(struct mapped_device *md)
+static void dm_flush(struct mapped_device *md)
 {
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
-	return 0;
 }
 
 /*
@@ -1459,24 +1458,18 @@ static void dm_wq_work(struct work_struc
 		if (!bio_barrier(c))
 			__split_and_process_bio(md, c);
 		else {
-			int error = dm_flush(md);
-			if (unlikely(error)) {
-				bio_endio(c, error);
-				goto next_bio;
-			}
+			dm_flush(md);
+
 			if (bio_empty_barrier(c)) {
 				bio_endio(c, 0);
 				goto next_bio;
 			}
 
 			__split_and_process_bio(md, c);
-
-			error = dm_flush(md);
-			if (!error && md->barrier_error)
-				error = md->barrier_error;
+			dm_flush(md);
 
 			if (md->barrier_error != DM_ENDIO_REQUEUE)
-				bio_endio(c, error);
+				bio_endio(c, md->barrier_error);
 		}
 
 next_bio:
