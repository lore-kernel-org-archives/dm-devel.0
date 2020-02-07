From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: remove sector type casts
Date: Fri, 7 Feb 2020 11:43:04 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2002071142310.32552@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Since the commit 72deb455b5ec619ff043c30bc90025aa3de3cdda, sector_t is
always defined as unsigned long long. This patch deletes the type casts in
printk and avoids some warnings if DEBUG_PRINT is defined.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-02-07 17:39:56.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2020-02-07 17:39:56.000000000 +0100
@@ -510,8 +510,8 @@ static bool block_bitmap_op(struct dm_in
 
 	if (unlikely(((sector | n_sectors) & ((1 << ic->sb->log2_sectors_per_block) - 1)) != 0)) {
 		DMCRIT("invalid bitmap access (%llx,%llx,%d,%d,%d)",
-			(unsigned long long)sector,
-			(unsigned long long)n_sectors,
+			sector,
+			n_sectors,
 			ic->sb->log2_sectors_per_block,
 			ic->log2_blocks_per_bitmap_bit,
 			mode);
@@ -1564,7 +1564,7 @@ again:
 			if (unlikely(r)) {
 				if (r > 0) {
 					DMERR_LIMIT("Checksum failed at sector 0x%llx",
-						    (unsigned long long)(sector - ((r + ic->tag_size - 1) / ic->tag_size)));
+						    (sector - ((r + ic->tag_size - 1) / ic->tag_size)));
 					r = -EILSEQ;
 					atomic64_inc(&ic->number_of_mismatches);
 				}
@@ -1648,14 +1648,14 @@ static int dm_integrity_map(struct dm_ta
 	}
 	if (unlikely(dio->range.logical_sector + bio_sectors(bio) > ic->provided_data_sectors)) {
 		DMERR("Too big sector number: 0x%llx + 0x%x > 0x%llx",
-		      (unsigned long long)dio->range.logical_sector, bio_sectors(bio),
-		      (unsigned long long)ic->provided_data_sectors);
+		      dio->range.logical_sector, bio_sectors(bio),
+		      ic->provided_data_sectors);
 		return DM_MAPIO_KILL;
 	}
 	if (unlikely((dio->range.logical_sector | bio_sectors(bio)) & (unsigned)(ic->sectors_per_block - 1))) {
 		DMERR("Bio not aligned on %u sectors: 0x%llx, 0x%x",
 		      ic->sectors_per_block,
-		      (unsigned long long)dio->range.logical_sector, bio_sectors(bio));
+		      dio->range.logical_sector, bio_sectors(bio));
 		return DM_MAPIO_KILL;
 	}
 
@@ -1758,7 +1758,7 @@ retry_kmap:
 					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
 					if (unlikely(memcmp(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
 						DMERR_LIMIT("Checksum failed when reading from journal, at sector 0x%llx",
-							    (unsigned long long)logical_sector);
+							    logical_sector);
 					}
 				}
 #endif
@@ -2420,7 +2420,7 @@ next_chunk:
 		get_area_and_offset(ic, logical_sector, &area, &offset);
 	}
 
-	DEBUG_print("recalculating: %lx, %lx\n", logical_sector, n_sectors);
+	DEBUG_print("recalculating: %llx, %llx\n", logical_sector, n_sectors);
 
 	if (unlikely(++super_counter == RECALC_WRITE_SUPER)) {
 		recalc_write_super(ic);
@@ -2921,7 +2921,7 @@ static void dm_integrity_resume(struct d
 	DEBUG_print("testing recalc: %x\n", ic->sb->flags);
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
 		__u64 recalc_pos = le64_to_cpu(ic->sb->recalc_sector);
-		DEBUG_print("recalc pos: %lx / %lx\n", (long)recalc_pos, ic->provided_data_sectors);
+		DEBUG_print("recalc pos: %llx / %llx\n", recalc_pos, ic->provided_data_sectors);
 		if (recalc_pos < ic->provided_data_sectors) {
 			queue_work(ic->recalc_wq, &ic->recalc_work);
 		} else if (recalc_pos > ic->provided_data_sectors) {
@@ -2951,10 +2951,10 @@ static void dm_integrity_status(struct d
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%llu %llu",
-			(unsigned long long)atomic64_read(&ic->number_of_mismatches),
-			(unsigned long long)ic->provided_data_sectors);
+			atomic64_read(&ic->number_of_mismatches),
+			ic->provided_data_sectors);
 		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
-			DMEMIT(" %llu", (unsigned long long)le64_to_cpu(ic->sb->recalc_sector));
+			DMEMIT(" %llu", le64_to_cpu(ic->sb->recalc_sector));
 		else
 			DMEMIT(" -");
 		break;
@@ -2975,7 +2975,7 @@ static void dm_integrity_status(struct d
 		arg_count += !!ic->journal_crypt_alg.alg_string;
 		arg_count += !!ic->journal_mac_alg.alg_string;
 		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0;
-		DMEMIT("%s %llu %u %c %u", ic->dev->name, (unsigned long long)ic->start,
+		DMEMIT("%s %llu %u %c %u", ic->dev->name, ic->start,
 		       ic->tag_size, ic->mode, arg_count);
 		if (ic->meta_dev)
 			DMEMIT(" meta_device:%s", ic->meta_dev->name);
@@ -2991,7 +2991,7 @@ static void dm_integrity_status(struct d
 			DMEMIT(" commit_time:%u", ic->autocommit_msec);
 		}
 		if (ic->mode == 'B') {
-			DMEMIT(" sectors_per_bit:%llu", (unsigned long long)ic->sectors_per_block << ic->log2_blocks_per_bitmap_bit);
+			DMEMIT(" sectors_per_bit:%llu", (sector_t)ic->sectors_per_block << ic->log2_blocks_per_bitmap_bit);
 			DMEMIT(" bitmap_flush_interval:%u", jiffies_to_msecs(ic->bitmap_flush_interval));
 		}
 		if ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0)
@@ -4021,10 +4021,9 @@ try_smaller_buffer:
 	DEBUG_print("	initial_sectors 0x%x\n", ic->initial_sectors);
 	DEBUG_print("	metadata_run 0x%x\n", ic->metadata_run);
 	DEBUG_print("	log2_metadata_run %d\n", ic->log2_metadata_run);
-	DEBUG_print("	provided_data_sectors 0x%llx (%llu)\n", (unsigned long long)ic->provided_data_sectors,
-		    (unsigned long long)ic->provided_data_sectors);
+	DEBUG_print("	provided_data_sectors 0x%llx (%llu)\n", ic->provided_data_sectors, ic->provided_data_sectors);
 	DEBUG_print("	log2_buffer_sectors %u\n", ic->log2_buffer_sectors);
-	DEBUG_print("	bits_in_journal %llu\n", (unsigned long long)bits_in_journal);
+	DEBUG_print("	bits_in_journal %llu\n", bits_in_journal);
 
 	if (ic->recalculate_flag && !(ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))) {
 		ic->sb->flags |= cpu_to_le32(SB_FLAG_RECALCULATING);
