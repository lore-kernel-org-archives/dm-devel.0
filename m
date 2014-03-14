From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/6] dm: introduce dm_ask_for_duplicate_bios
Date: Fri, 14 Mar 2014 18:44:25 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1403141843520.31047@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141841290.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141842170.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141843120.31047@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1403141843120.31047@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This function can be used if the target needs to receive another duplicate
of the current bio.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c               |   24 +++++++++++++++++++-----
 include/linux/device-mapper.h |    2 ++
 2 files changed, 21 insertions(+), 5 deletions(-)

Index: linux-3.14-rc6/drivers/md/dm.c
===================================================================
--- linux-3.14-rc6.orig/drivers/md/dm.c	2014-03-14 23:25:27.000000000 +0100
+++ linux-3.14-rc6/drivers/md/dm.c	2014-03-14 23:33:09.000000000 +0100
@@ -1129,9 +1129,9 @@ EXPORT_SYMBOL_GPL(dm_set_target_max_io_l
  *	 to make it empty)
  * The target requires that region 3 is to be sent in the next bio.
  *
- * If the target wants to receive multiple copies of the bio with num_write_bios
- * or num_write_same_bios, the partially processed part (the sum of regions 1+2)
- * must be the same for all copies of the bio.
+ * If the target wants to receive multiple copies of the bio with num_*_bios or
+ * dm_ask_for_duplicate_bio, the partially processed part (the sum of regions
+ * 1+2) must be the same for all copies of the bio.
  */
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 {
@@ -1144,6 +1144,17 @@ void dm_accept_partial_bio(struct bio *b
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
+/*
+ * The target driver can call this function only from the map routine. The
+ * target driver requests that the dm sends more duplicates of the current bio.
+ */
+void dm_ask_for_duplicate_bios(struct bio *bio, unsigned n_duplicates)
+{
+	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
+	(*tio->num_bios) += n_duplicates;
+}
+EXPORT_SYMBOL_GPL(dm_ask_for_duplicate_bios);
+
 static void __map_bio(struct dm_target_io *tio)
 {
 	int r;
@@ -1234,12 +1245,14 @@ static struct dm_target_io *alloc_tio(st
 
 static void __clone_and_map_simple_bio(struct clone_info *ci,
 				       struct dm_target *ti,
-				       unsigned target_bio_nr, unsigned *len)
+				       unsigned target_bio_nr, unsigned *len,
+				       unsigned *num_bios)
 {
 	struct dm_target_io *tio = alloc_tio(ci, ti, ci->bio->bi_max_vecs, target_bio_nr);
 	struct bio *clone = &tio->clone;
 
 	tio->len_ptr = len;
+	tio->num_bios = num_bios;
 
 	/*
 	 * Discard requests require the bio's inline iovecs be initialized.
@@ -1259,7 +1272,7 @@ static void __send_duplicate_bios(struct
 	unsigned target_bio_nr;
 
 	for (target_bio_nr = 0; target_bio_nr < num_bios; target_bio_nr++)
-		__clone_and_map_simple_bio(ci, ti, target_bio_nr, len);
+		__clone_and_map_simple_bio(ci, ti, target_bio_nr, len, &num_bios);
 }
 
 static int __send_empty_flush(struct clone_info *ci)
@@ -1285,6 +1298,7 @@ static void __clone_and_map_data_bio(str
 	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
 		tio = alloc_tio(ci, ti, 0, target_bio_nr);
 		tio->len_ptr = len;
+		tio->num_bios = &num_target_bios;
 		clone_bio(tio, bio, sector, *len);
 		__map_bio(tio);
 	}
Index: linux-3.14-rc6/include/linux/device-mapper.h
===================================================================
--- linux-3.14-rc6.orig/include/linux/device-mapper.h	2014-03-14 23:25:27.000000000 +0100
+++ linux-3.14-rc6/include/linux/device-mapper.h	2014-03-14 23:25:27.000000000 +0100
@@ -277,6 +277,7 @@ struct dm_target_io {
 	struct dm_target *ti;
 	unsigned target_bio_nr;
 	unsigned *len_ptr;
+	unsigned *num_bios;
 	struct bio clone;
 };
 
@@ -388,6 +389,7 @@ struct gendisk *dm_disk(struct mapped_de
 int dm_suspended(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors);
+void dm_ask_for_duplicate_bios(struct bio *bio, unsigned n_duplicates);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
