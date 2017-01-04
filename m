From: Milan Broz <gmazyland@gmail.com>
Subject: [RFC PATCH 1/4] dm-table: Add flag to allow own target
	handling of integrity metadata.
Date: Wed,  4 Jan 2017 20:23:51 +0100
Message-ID: <d4759eabd8e02d0cd10f213b3345be872ade67e9.1483551181.git.gmazyland@gmail.com>
References: <cover.1483551181.git.gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1483551181.git.gmazyland@gmail.com>
In-Reply-To: <cover.1483551181.git.gmazyland@gmail.com>
References: <cover.1483551181.git.gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

This patch adds DM_TARGET_INTEGRITY flag that specifies that
bio integrity metadata is not inherited but implemented in target itself.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-table.c         | 11 +++++++++++
 include/linux/device-mapper.h |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0a427de23ed2..95094c133d6c 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -47,6 +47,7 @@ struct dm_table {
 	bool integrity_supported:1;
 	bool singleton:1;
 	bool all_blk_mq:1;
+	unsigned integrity_added:1;
 
 	/*
 	 * Indicates the rw permissions for the new logical
@@ -725,6 +726,9 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		t->immutable_target_type = tgt->type;
 	}
 
+	if (dm_target_has_integrity(tgt->type))
+		t->integrity_added = 1;
+
 	tgt->table = t;
 	tgt->begin = start;
 	tgt->len = len;
@@ -1168,6 +1172,10 @@ static int dm_table_register_integrity(struct dm_table *t)
 	struct mapped_device *md = t->md;
 	struct gendisk *template_disk = NULL;
 
+	/* If target handles integrity itself do not register it here. */
+	if (t->integrity_added)
+		return 0;
+
 	template_disk = dm_table_get_integrity_disk(t);
 	if (!template_disk)
 		return 0;
@@ -1394,6 +1402,9 @@ static void dm_table_verify_integrity(struct dm_table *t)
 {
 	struct gendisk *template_disk = NULL;
 
+	if (t->integrity_added)
+		return;
+
 	if (t->integrity_supported) {
 		/*
 		 * Verify that the original integrity profile
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ef7962e84444..b508e8169133 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -224,6 +224,12 @@ struct target_type {
  */
 typedef unsigned (*dm_num_write_bios_fn) (struct dm_target *ti, struct bio *bio);
 
+/*
+ * A target implements own bio data integrity.
+ */
+#define DM_TARGET_INTEGRITY		0x00000010
+#define dm_target_has_integrity(type)	((type)->features & DM_TARGET_INTEGRITY)
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
-- 
2.11.0
