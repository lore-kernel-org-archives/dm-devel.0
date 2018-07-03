From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/9] dm-integrity: use version 2 for separate
	metadata
Date: Tue, 03 Jul 2018 20:13:31 +0200
Message-ID: <20180703181401.882783800@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-sb-version.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Use version "2" in the superblock when data and metadata devices are
separate, so that the device is no accidentally read by older kernel
version.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-06-29 23:14:05.190000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-06-29 23:14:05.180000000 +0200
@@ -44,7 +44,8 @@
  */
 
 #define SB_MAGIC			"integrt"
-#define SB_VERSION			1
+#define SB_VERSION_1			1
+#define SB_VERSION_2			2
 #define SB_SECTORS			8
 #define MAX_SECTORS_PER_BLOCK		8
 
@@ -414,6 +415,14 @@ static void wraparound_section(struct dm
 		*sec_ptr -= ic->journal_sections;
 }
 
+static void sb_set_version(struct dm_integrity_c *ic)
+{
+	if (ic->meta_dev)
+		ic->sb->version = SB_VERSION_2;
+	else
+		ic->sb->version = SB_VERSION_1;
+}
+
 static int sync_rw_sb(struct dm_integrity_c *ic, int op, int op_flags)
 {
 	struct dm_io_request io_req;
@@ -2435,7 +2444,6 @@ static int initialize_superblock(struct
 
 	memset(ic->sb, 0, SB_SECTORS << SECTOR_SHIFT);
 	memcpy(ic->sb->magic, SB_MAGIC, 8);
-	ic->sb->version = SB_VERSION;
 	ic->sb->integrity_tag_size = cpu_to_le16(ic->tag_size);
 	ic->sb->log2_sectors_per_block = __ffs(ic->sectors_per_block);
 	if (ic->journal_mac_alg.alg_string)
@@ -2492,6 +2500,8 @@ try_smaller_buffer:
 
 	ic->sb->provided_data_sectors = cpu_to_le64(ic->provided_data_sectors);
 
+	sb_set_version(ic);
+
 	return 0;
 }
 
@@ -3196,7 +3206,7 @@ static int dm_integrity_ctr(struct dm_ta
 			should_write_sb = true;
 	}
 
-	if (ic->sb->version != SB_VERSION) {
+	if (!ic->sb->version || ic->sb->version > SB_VERSION_2) {
 		r = -EINVAL;
 		ti->error = "Unknown version";
 		goto bad;
