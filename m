From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5/7] dm-integrity: change the size of the device
Date: Sun, 22 Mar 2020 20:42:25 +0100
Message-ID: <20200322194425.177041480@debian-a64.vm>
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
Content-Disposition: inline; filename=dm-integrity-change-size.patch
To: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

If the size of the underlying device changes, we want to change the size
of the integrity device too.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-03-20 17:39:47.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2020-03-20 17:39:47.000000000 +0100
@@ -2833,8 +2833,26 @@ static void dm_integrity_resume(struct d
 {
 	struct dm_integrity_c *ic = (struct dm_integrity_c *)ti->private;
 	int r;
+	__u64 old_provided_data_sectors = le64_to_cpu(ic->sb->provided_data_sectors);
 	DEBUG_print("resume\n");
 
+	if (ic->provided_data_sectors != old_provided_data_sectors) {
+		if (ic->provided_data_sectors > old_provided_data_sectors &&
+		    ic->mode == 'B' &&
+		    ic->sb->log2_blocks_per_bitmap_bit == ic->log2_blocks_per_bitmap_bit) {
+			rw_journal_sectors(ic, REQ_OP_READ, 0, 0,
+					   ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
+			block_bitmap_op(ic, ic->journal, old_provided_data_sectors, ic->provided_data_sectors - old_provided_data_sectors, BITMAP_OP_SET);
+			rw_journal_sectors(ic, REQ_OP_WRITE, REQ_FUA | REQ_SYNC, 0,
+					   ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
+		}
+
+		ic->sb->provided_data_sectors = cpu_to_le64(ic->provided_data_sectors);
+		r = sync_rw_sb(ic, REQ_OP_WRITE, REQ_FUA);
+		if (unlikely(r))
+			dm_integrity_io_error(ic, "writing superblock", r);
+	}
+
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP)) {
 		DEBUG_print("resume dirty_bitmap\n");
 		rw_journal_sectors(ic, REQ_OP_READ, 0, 0,
@@ -3937,16 +3955,16 @@ static int dm_integrity_ctr(struct dm_ta
 			goto bad;
 		}
 	}
-	ic->provided_data_sectors = le64_to_cpu(ic->sb->provided_data_sectors);
-	if (ic->provided_data_sectors != le64_to_cpu(ic->sb->provided_data_sectors)) {
-		/* test for overflow */
+	if (!!(ic->sb->flags & cpu_to_le32(SB_FLAG_HAVE_JOURNAL_MAC)) != !!ic->journal_mac_alg.alg_string) {
 		r = -EINVAL;
-		ti->error = "The superblock has 64-bit device size, but the kernel was compiled with 32-bit sectors";
+		ti->error = "Journal mac mismatch";
 		goto bad;
 	}
-	if (!!(ic->sb->flags & cpu_to_le32(SB_FLAG_HAVE_JOURNAL_MAC)) != !!ic->journal_mac_alg.alg_string) {
+
+	get_provided_data_sectors(ic);
+	if (!ic->provided_data_sectors) {
 		r = -EINVAL;
-		ti->error = "Journal mac mismatch";
+		ti->error = "The device is too small";
 		goto bad;
 	}
 
@@ -4218,7 +4236,7 @@ static void dm_integrity_dtr(struct dm_t
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 5, 0},
+	.version		= {1, 6, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,
