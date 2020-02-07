From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: fix recalculation when moving from
 journal mode to bitmap mode
Date: Fri, 7 Feb 2020 11:42:30 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2002071141140.32552@file01.intranet.prod.int.rdu2.redhat.com>
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

If we resume a device in bitmap mode and the on-disk format is in journal
mode, we must recalculate anything above ic->sb->recalc_sector. Otherwise,
there would be non-recalculated blocks causing I/O errors.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v5.2+
Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")

---
 drivers/md/dm-integrity.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-01-30 18:16:55.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2020-02-07 17:40:09.000000000 +0100
@@ -2899,17 +2899,20 @@ static void dm_integrity_resume(struct d
 	} else {
 		replay_journal(ic);
 		if (ic->mode == 'B') {
-			int mode;
 			ic->sb->flags |= cpu_to_le32(SB_FLAG_DIRTY_BITMAP);
 			ic->sb->log2_blocks_per_bitmap_bit = ic->log2_blocks_per_bitmap_bit;
 			r = sync_rw_sb(ic, REQ_OP_WRITE, REQ_FUA);
 			if (unlikely(r))
 				dm_integrity_io_error(ic, "writing superblock", r);
 
-			mode = ic->recalculate_flag ? BITMAP_OP_SET : BITMAP_OP_CLEAR;
-			block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors, mode);
-			block_bitmap_op(ic, ic->recalc_bitmap, 0, ic->provided_data_sectors, mode);
-			block_bitmap_op(ic, ic->may_write_bitmap, 0, ic->provided_data_sectors, mode);
+			block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors, BITMAP_OP_CLEAR);
+			block_bitmap_op(ic, ic->recalc_bitmap, 0, ic->provided_data_sectors, BITMAP_OP_CLEAR);
+			block_bitmap_op(ic, ic->may_write_bitmap, 0, ic->provided_data_sectors, BITMAP_OP_CLEAR);
+			if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) && le64_to_cpu(ic->sb->recalc_sector) < ic->provided_data_sectors) {
+				block_bitmap_op(ic, ic->journal, le64_to_cpu(ic->sb->recalc_sector), ic->provided_data_sectors - le64_to_cpu(ic->sb->recalc_sector), BITMAP_OP_SET);
+				block_bitmap_op(ic, ic->recalc_bitmap, le64_to_cpu(ic->sb->recalc_sector), ic->provided_data_sectors - le64_to_cpu(ic->sb->recalc_sector), BITMAP_OP_SET);
+				block_bitmap_op(ic, ic->may_write_bitmap, le64_to_cpu(ic->sb->recalc_sector), ic->provided_data_sectors - le64_to_cpu(ic->sb->recalc_sector), BITMAP_OP_SET);
+			}
 			rw_journal_sectors(ic, REQ_OP_WRITE, REQ_FUA | REQ_SYNC, 0,
 					   ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
 		}
