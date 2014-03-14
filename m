From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/6] dm: change sector_t len to unsigned
Date: Fri, 14 Mar 2014 18:40:39 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

It is impossible to create bios with 2^23 or more sectors (the size is
stored as a 32-bit byte count in the bio). So we convert some sector_t
values to unsigned integers.

It is needed for the next patch that replaces the values with pointers, so
the size of the integer must match.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-3.14-rc5/drivers/md/dm.c
===================================================================
--- linux-3.14-rc5.orig/drivers/md/dm.c	2014-03-14 01:55:24.000000000 +0100
+++ linux-3.14-rc5/drivers/md/dm.c	2014-03-14 04:31:41.000000000 +0100
@@ -1147,10 +1147,10 @@ struct clone_info {
 	struct bio *bio;
 	struct dm_io *io;
 	sector_t sector;
-	sector_t sector_count;
+	unsigned sector_count;
 };
 
-static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
+static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned len)
 {
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_iter.bi_size = to_bytes(len);
@@ -1195,7 +1195,7 @@ static struct dm_target_io *alloc_tio(st
 
 static void __clone_and_map_simple_bio(struct clone_info *ci,
 				       struct dm_target *ti,
-				       unsigned target_bio_nr, sector_t len)
+				       unsigned target_bio_nr, unsigned len)
 {
 	struct dm_target_io *tio = alloc_tio(ci, ti, ci->bio->bi_max_vecs, target_bio_nr);
 	struct bio *clone = &tio->clone;
@@ -1213,7 +1213,7 @@ static void __clone_and_map_simple_bio(s
 }
 
 static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
-				  unsigned num_bios, sector_t len)
+				  unsigned num_bios, unsigned len)
 {
 	unsigned target_bio_nr;
 
@@ -1278,7 +1278,7 @@ static int __send_changing_extent_only(s
 				       is_split_required_fn is_split_required)
 {
 	struct dm_target *ti;
-	sector_t len;
+	unsigned len;
 	unsigned num_bios;
 
 	do {
@@ -1297,9 +1297,9 @@ static int __send_changing_extent_only(s
 			return -EOPNOTSUPP;
 
 		if (is_split_required && !is_split_required(ti))
-			len = min(ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
+			len = min((sector_t)ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
 		else
-			len = min(ci->sector_count, max_io_len(ci->sector, ti));
+			len = min((sector_t)ci->sector_count, max_io_len(ci->sector, ti));
 
 		__send_duplicate_bios(ci, ti, num_bios, len);
 
