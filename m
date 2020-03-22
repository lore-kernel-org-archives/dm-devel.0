From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/7] dm-integrity: introduce
	get_provided_data_sectors
Date: Sun, 22 Mar 2020 20:42:24 +0100
Message-ID: <20200322194423.875742040@debian-a64.vm>
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
Content-Disposition: inline;
	filename=dm-integrity-get_provided_data_sectors.patch
To: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Refactoring: move code to a new function get_provided_data_sectors.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-03-09 15:45:34.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2020-03-09 15:45:34.000000000 +0100
@@ -3077,6 +3077,24 @@ static int calculate_device_limits(struc
 	return 0;
 }
 
+static void get_provided_data_sectors(struct dm_integrity_c *ic)
+{
+	if (!ic->meta_dev) {
+		int test_bit;
+		ic->provided_data_sectors = 0;
+		for (test_bit = fls64(ic->meta_device_sectors) - 1; test_bit >= 3; test_bit--) {
+			__u64 prev_data_sectors = ic->provided_data_sectors;
+
+			ic->provided_data_sectors |= (sector_t)1 << test_bit;
+			if (calculate_device_limits(ic))
+				ic->provided_data_sectors = prev_data_sectors;
+		}
+	} else {
+		ic->provided_data_sectors = ic->data_device_sectors;
+		ic->provided_data_sectors &= ~(sector_t)(ic->sectors_per_block - 1);
+	}
+}
+
 static int initialize_superblock(struct dm_integrity_c *ic, unsigned journal_sectors, unsigned interleave_sectors)
 {
 	unsigned journal_sections;
@@ -3104,20 +3122,15 @@ static int initialize_superblock(struct
 		ic->sb->log2_interleave_sectors = max((__u8)MIN_LOG2_INTERLEAVE_SECTORS, ic->sb->log2_interleave_sectors);
 		ic->sb->log2_interleave_sectors = min((__u8)MAX_LOG2_INTERLEAVE_SECTORS, ic->sb->log2_interleave_sectors);
 
-		ic->provided_data_sectors = 0;
-		for (test_bit = fls64(ic->meta_device_sectors) - 1; test_bit >= 3; test_bit--) {
-			__u64 prev_data_sectors = ic->provided_data_sectors;
-
-			ic->provided_data_sectors |= (sector_t)1 << test_bit;
-			if (calculate_device_limits(ic))
-				ic->provided_data_sectors = prev_data_sectors;
-		}
+		get_provided_data_sectors(ic);
 		if (!ic->provided_data_sectors)
 			return -EINVAL;
 	} else {
 		ic->sb->log2_interleave_sectors = 0;
-		ic->provided_data_sectors = ic->data_device_sectors;
-		ic->provided_data_sectors &= ~(sector_t)(ic->sectors_per_block - 1);
+
+		get_provided_data_sectors(ic);
+		if (!ic->provided_data_sectors)
+			return -EINVAL;
 
 try_smaller_buffer:
 		ic->sb->journal_sections = cpu_to_le32(0);
