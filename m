From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/3] dm-integrity: change the size of the device
Date: Thu, 30 Jan 2020 18:25:42 +0100
Message-ID: <20200130173419.055035960@debian-a64.vm>
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
 drivers/md/dm-integrity.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-01-30 17:33:30.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2020-01-30 17:33:30.000000000 +0100
@@ -2851,6 +2851,13 @@ static void dm_integrity_resume(struct d
 	int r;
 	DEBUG_print("resume\n");
 
+	if (ic->provided_data_sectors != le64_to_cpu(ic->sb->provided_data_sectors)) {
+		ic->sb->provided_data_sectors = cpu_to_le64(ic->provided_data_sectors);
+		r = sync_rw_sb(ic, REQ_OP_WRITE, REQ_FUA);
+		if (unlikely(r))
+			dm_integrity_io_error(ic, "writing superblock", r);
+	}
+
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP)) {
 		DEBUG_print("resume dirty_bitmap\n");
 		rw_journal_sectors(ic, REQ_OP_READ, 0, 0,
@@ -3937,16 +3944,16 @@ static int dm_integrity_ctr(struct dm_ta
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
 
@@ -4217,7 +4224,7 @@ static void dm_integrity_dtr(struct dm_t
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 4, 0},
+	.version		= {1, 5, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,
