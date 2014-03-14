From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/6] dm: introduce dm_accept_partial_bio
Date: Fri, 14 Mar 2014 18:41:24 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
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

The function dm_accept_partial_bio allows the target to specify how many
sectors does it want to process. If the target wants to accept only a part
of the bio, it calls dm_accept_partial_bio and the dm core sends the rest
of the data in next bio.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c               |   58 ++++++++++++++++++++++++++++++++++++------
 include/linux/device-mapper.h |    2 +
 2 files changed, 52 insertions(+), 8 deletions(-)

Index: linux-3.14-rc5/drivers/md/dm.c
===================================================================
--- linux-3.14-rc5.orig/drivers/md/dm.c	2014-03-14 04:31:41.000000000 +0100
+++ linux-3.14-rc5/drivers/md/dm.c	2014-03-14 04:32:08.000000000 +0100
@@ -1105,6 +1105,45 @@ int dm_set_target_max_io_len(struct dm_t
 }
 EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
 
+/*
+ * A target may call dm_accept_partial_bio only from the map routine. It is
+ * allowed for all bio types except REQ_FLUSH.
+ *
+ * dm_accept_partial_bio informs the dm that the target only wants to process
+ * additional n_sectors sectors of the bio and the rest of the data should be
+ * sent in a next bio.
+ *
+ * A diagram that explains the arithmetics:
+ * +--------------------+---------------+-------+
+ * |         1          |       2       |   3   |
+ * +--------------------+---------------+-------+
+ *
+ * <-------------- *tio->len_ptr --------------->
+ *                      <------- bi_size ------->
+ *                      <-- n_sectors -->
+ *
+ * Region 1 was already iterated over with bio_advance or similar function.
+ *	(it may be empty if the target doesn't use bio_advance)
+ * Region 2 is the remaining bio size that the target wants to process.
+ *	(it may be empty if region 1 is non-empty, although there is no reason
+ *	 to make it empty)
+ * The target requires that region 3 is to be sent in the next bio.
+ *
+ * If the target wants to receive multiple copies of the bio with num_write_bios
+ * or num_write_same_bios, the partially processed part (the sum of regions 1+2)
+ * must be the same for all copies of the bio.
+ */
+void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
+{
+	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
+	unsigned bi_size = bio->bi_iter.bi_size >> SECTOR_SHIFT;
+	BUG_ON(bi_size > *tio->len_ptr);
+	BUG_ON(n_sectors > bi_size);
+	*tio->len_ptr -= bi_size - n_sectors;
+	bio->bi_iter.bi_size = n_sectors << SECTOR_SHIFT;
+}
+EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
+
 static void __map_bio(struct dm_target_io *tio)
 {
 	int r;
@@ -1195,11 +1234,13 @@ static struct dm_target_io *alloc_tio(st
 
 static void __clone_and_map_simple_bio(struct clone_info *ci,
 				       struct dm_target *ti,
-				       unsigned target_bio_nr, unsigned len)
+				       unsigned target_bio_nr, unsigned *len)
 {
 	struct dm_target_io *tio = alloc_tio(ci, ti, ci->bio->bi_max_vecs, target_bio_nr);
 	struct bio *clone = &tio->clone;
 
+	tio->len_ptr = len;
+
 	/*
 	 * Discard requests require the bio's inline iovecs be initialized.
 	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
@@ -1207,13 +1248,13 @@ static void __clone_and_map_simple_bio(s
 	 */
 	 __bio_clone_fast(clone, ci->bio);
 	if (len)
-		bio_setup_sector(clone, ci->sector, len);
+		bio_setup_sector(clone, ci->sector, *len);
 
 	__map_bio(tio);
 }
 
 static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
-				  unsigned num_bios, unsigned len)
+				  unsigned num_bios, unsigned *len)
 {
 	unsigned target_bio_nr;
 
@@ -1228,13 +1269,13 @@ static int __send_empty_flush(struct clo
 
 	BUG_ON(bio_has_data(ci->bio));
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
-		__send_duplicate_bios(ci, ti, ti->num_flush_bios, 0);
+		__send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
 
 	return 0;
 }
 
 static void __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
-				     sector_t sector, unsigned len)
+				     sector_t sector, unsigned *len)
 {
 	struct bio *bio = ci->bio;
 	struct dm_target_io *tio;
@@ -1249,7 +1290,8 @@ static void __clone_and_map_data_bio(str
 
 	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
 		tio = alloc_tio(ci, ti, 0, target_bio_nr);
-		clone_bio(tio, bio, sector, len);
+		tio->len_ptr = len;
+		clone_bio(tio, bio, sector, *len);
 		__map_bio(tio);
 	}
 }
@@ -1301,7 +1343,7 @@ static int __send_changing_extent_only(s
 		else
 			len = min((sector_t)ci->sector_count, max_io_len(ci->sector, ti));
 
-		__send_duplicate_bios(ci, ti, num_bios, len);
+		__send_duplicate_bios(ci, ti, num_bios, &len);
 
 		ci->sector += len;
 	} while (ci->sector_count -= len);
@@ -1340,7 +1382,7 @@ static int __split_and_process_non_flush
 
 	len = min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count);
 
-	__clone_and_map_data_bio(ci, ti, ci->sector, len);
+	__clone_and_map_data_bio(ci, ti, ci->sector, &len);
 
 	ci->sector += len;
 	ci->sector_count -= len;
Index: linux-3.14-rc5/include/linux/device-mapper.h
===================================================================
--- linux-3.14-rc5.orig/include/linux/device-mapper.h	2014-03-14 04:30:51.000000000 +0100
+++ linux-3.14-rc5/include/linux/device-mapper.h	2014-03-14 04:32:08.000000000 +0100
@@ -291,6 +291,7 @@ struct dm_target_io {
 	struct dm_io *io;
 	struct dm_target *ti;
 	unsigned target_bio_nr;
+	unsigned *len_ptr;
 	struct bio clone;
 };
 
@@ -401,6 +402,7 @@ int dm_copy_name_and_uuid(struct mapped_
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
+void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
