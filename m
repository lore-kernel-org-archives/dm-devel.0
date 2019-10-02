From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-snapshot: introduce account_start_copy
 and account_end_copy
Date: Wed, 2 Oct 2019 06:14:17 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1910020613070.973@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Nikos Tsironis <ntsironis@arrikto.com>, Mike Snitzer <msnitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, guru2018@gmail.com
List-Id: dm-devel.ids

This is simple refactoring that moves code for modifying the semaphore
cow_count into separate functions. It is needed by the following patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v5.0+
Fixes: 721b1d98fb51 ("dm snapshot: Fix excessive memory usage and workqueue stalls")

---
 drivers/md/dm-snap.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c	2019-10-01 15:19:20.000000000 +0200
+++ linux-2.6/drivers/md/dm-snap.c	2019-10-01 15:23:10.000000000 +0200
@@ -1512,6 +1512,16 @@ static void snapshot_dtr(struct dm_targe
 	kfree(s);
 }
 
+static void account_start_copy(struct dm_snapshot *s)
+{
+	down(&s->cow_count);
+}
+
+static void account_end_copy(struct dm_snapshot *s)
+{
+	up(&s->cow_count);
+}
+
 /*
  * Flush a list of buffers.
  */
@@ -1732,7 +1742,7 @@ static void copy_callback(int read_err,
 		rb_link_node(&pe->out_of_order_node, parent, p);
 		rb_insert_color(&pe->out_of_order_node, &s->out_of_order_tree);
 	}
-	up(&s->cow_count);
+	account_end_copy(s);
 }
 
 /*
@@ -1756,7 +1766,7 @@ static void start_copy(struct dm_snap_pe
 	dest.count = src.count;
 
 	/* Hand over to kcopyd */
-	down(&s->cow_count);
+	account_start_copy(s);
 	dm_kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0, copy_callback, pe);
 }
 
@@ -1776,7 +1786,7 @@ static void start_full_bio(struct dm_sna
 	pe->full_bio = bio;
 	pe->full_bio_end_io = bio->bi_end_io;
 
-	down(&s->cow_count);
+	account_start_copy(s);
 	callback_data = dm_kcopyd_prepare_callback(s->kcopyd_client,
 						   copy_callback, pe);
 
@@ -1866,7 +1876,7 @@ static void zero_callback(int read_err,
 	struct bio *bio = context;
 	struct dm_snapshot *s = bio->bi_private;
 
-	up(&s->cow_count);
+	account_end_copy(s);
 	bio->bi_status = write_err ? BLK_STS_IOERR : 0;
 	bio_endio(bio);
 }
@@ -1880,7 +1890,7 @@ static void zero_exception(struct dm_sna
 	dest.sector = bio->bi_iter.bi_sector;
 	dest.count = s->store->chunk_size;
 
-	down(&s->cow_count);
+	account_start_copy(s);
 	WARN_ON_ONCE(bio->bi_private);
 	bio->bi_private = s;
 	dm_kcopyd_zero(s->kcopyd_client, 1, &dest, 0, zero_callback, bio);
