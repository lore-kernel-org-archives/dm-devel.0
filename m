From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 7/8] [persistent-data] transactional bitset
Date: Thu, 13 Dec 2012 20:19:15 +0000
Message-ID: <1355429956-22785-8-git-send-email-ejt@redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1355429956-22785-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

A wrapper around dm-array.
---
 drivers/md/persistent-data/Makefile    |    1 +
 drivers/md/persistent-data/dm-bitset.c |  163 ++++++++++++++++++++++++++++++++
 drivers/md/persistent-data/dm-bitset.h |   59 ++++++++++++
 3 files changed, 223 insertions(+)
 create mode 100644 drivers/md/persistent-data/dm-bitset.c
 create mode 100644 drivers/md/persistent-data/dm-bitset.h

diff --git a/drivers/md/persistent-data/Makefile b/drivers/md/persistent-data/Makefile
index ebd8d80..ff52879 100644
--- a/drivers/md/persistent-data/Makefile
+++ b/drivers/md/persistent-data/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_DM_PERSISTENT_DATA) += dm-persistent-data.o
 dm-persistent-data-objs := \
 	dm-array.o \
+	dm-bitset.o \
 	dm-block-manager.o \
 	dm-space-map-common.o \
 	dm-space-map-disk.o \
diff --git a/drivers/md/persistent-data/dm-bitset.c b/drivers/md/persistent-data/dm-bitset.c
new file mode 100644
index 0000000..dc67736
--- /dev/null
+++ b/drivers/md/persistent-data/dm-bitset.c
@@ -0,0 +1,163 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-bitset.h"
+#include "dm-transaction-manager.h"
+
+#include <linux/export.h>
+#include <linux/device-mapper.h>
+
+#define DM_MSG_PREFIX "bitset"
+#define BITS_PER_ARRAY_ENTRY 64
+
+/*----------------------------------------------------------------*/
+
+static struct dm_btree_value_type bitset_bvt = {
+	.context = NULL,
+	.size = sizeof(__le64),
+	.inc = NULL,
+	.dec = NULL,
+	.equal = NULL,
+};
+
+/*----------------------------------------------------------------*/
+
+void dm_bitset_info_init(struct dm_transaction_manager *tm,
+			 struct dm_bitset_info *info)
+{
+	dm_setup_array_info(&info->array_info, tm, &bitset_bvt);
+	info->current_index_set = false;
+}
+EXPORT_SYMBOL_GPL(dm_bitset_info_init);
+
+int dm_bitset_empty(struct dm_bitset_info *info, dm_block_t *root)
+{
+	return dm_array_empty(&info->array_info, root);
+}
+EXPORT_SYMBOL_GPL(dm_bitset_empty);
+
+int dm_bitset_resize(struct dm_bitset_info *info, dm_block_t root,
+		     uint32_t old_nr_entries, uint32_t new_nr_entries,
+		     bool default_value, dm_block_t *new_root)
+{
+	uint32_t old_blocks = dm_div_up(old_nr_entries, BITS_PER_ARRAY_ENTRY);
+	uint32_t new_blocks = dm_div_up(new_nr_entries, BITS_PER_ARRAY_ENTRY);
+	__le64 value = default_value ? cpu_to_le64(~0) : cpu_to_le64(0);
+
+	__dm_bless_for_disk(&value);
+	return dm_array_resize(&info->array_info, root, old_blocks, new_blocks,
+			       &value, new_root);
+}
+EXPORT_SYMBOL_GPL(dm_bitset_resize);
+
+int dm_bitset_del(struct dm_bitset_info *info, dm_block_t root)
+{
+	return dm_array_del(&info->array_info, root);
+}
+EXPORT_SYMBOL_GPL(dm_bitset_del);
+
+int dm_bitset_flush(struct dm_bitset_info *info, dm_block_t root,
+		    dm_block_t *new_root)
+{
+	int r;
+	__le64 value;
+
+	if (!info->current_index_set)
+		return 0;
+
+	value = cpu_to_le64(info->current_bits);
+
+	__dm_bless_for_disk(&value);
+	r = dm_array_set(&info->array_info, root, info->current_index,
+			 &value, new_root);
+	if (r)
+		return r;
+
+	info->current_index_set = false;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bitset_flush);
+
+static int read_bits(struct dm_bitset_info *info, dm_block_t root,
+		     uint32_t array_index)
+{
+	int r;
+	__le64 value;
+
+	r = dm_array_get(&info->array_info, root, array_index, &value);
+	if (r)
+		return r;
+
+	info->current_bits = le64_to_cpu(value);
+	info->current_index_set = true;
+	info->current_index = array_index;
+	return 0;
+}
+
+static int get_array_entry(struct dm_bitset_info *info, dm_block_t root,
+			   uint32_t index, dm_block_t *new_root)
+{
+	int r;
+	unsigned array_index = index / BITS_PER_ARRAY_ENTRY;
+
+	if (info->current_index_set) {
+		if (info->current_index == array_index)
+			return 0;
+
+		r = dm_bitset_flush(info, root, new_root);
+		if (r)
+			return r;
+	}
+
+	return read_bits(info, root, array_index);
+}
+
+int dm_bitset_set_bit(struct dm_bitset_info *info, dm_block_t root,
+		      uint32_t index, dm_block_t *new_root)
+{
+	int r;
+	unsigned b = index % BITS_PER_ARRAY_ENTRY;
+
+	r = get_array_entry(info, root, index, new_root);
+	if (r)
+		return r;
+
+	set_bit(b, (unsigned long *) &info->current_bits);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bitset_set_bit);
+
+int dm_bitset_clear_bit(struct dm_bitset_info *info, dm_block_t root,
+			uint32_t index, dm_block_t *new_root)
+{
+	int r;
+	unsigned b = index % BITS_PER_ARRAY_ENTRY;
+
+	r = get_array_entry(info, root, index, new_root);
+	if (r)
+		return r;
+
+	clear_bit(b, (unsigned long *) &info->current_bits);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bitset_clear_bit);
+
+int dm_bitset_test_bit(struct dm_bitset_info *info, dm_block_t root,
+		       uint32_t index, dm_block_t *new_root, bool *result)
+{
+	int r;
+	unsigned b = index % BITS_PER_ARRAY_ENTRY;
+
+	r = get_array_entry(info, root, index, new_root);
+	if (r)
+		return r;
+
+	*result = test_bit(b, (unsigned long *) &info->current_bits);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bitset_test_bit);
+
+/*----------------------------------------------------------------*/
diff --git a/drivers/md/persistent-data/dm-bitset.h b/drivers/md/persistent-data/dm-bitset.h
new file mode 100644
index 0000000..513ab1e
--- /dev/null
+++ b/drivers/md/persistent-data/dm-bitset.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ *
+ * This file is released under the GPL.
+ */
+#ifndef _LINUX_DM_BITSET_H
+#define _LINUX_DM_BITSET_H
+
+#include "dm-array.h"
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Bitsets are a thin wrapper around the dm_array data type.  Rather than
+ * updating the 64bit array entry for each access it batches the updates.
+ * Use the flush method to ensure everything has hit the disk.
+ */
+
+struct dm_bitset_info {
+	struct dm_array_info array_info;
+
+	uint32_t current_index;
+	uint64_t current_bits;
+
+	bool current_index_set:1;
+};
+
+void dm_bitset_info_init(struct dm_transaction_manager *tm,
+			 struct dm_bitset_info *info);
+
+int dm_bitset_empty(struct dm_bitset_info *info, dm_block_t *root);
+
+int dm_bitset_resize(struct dm_bitset_info *info, dm_block_t root,
+		     uint32_t old_nr_entries, uint32_t new_nr_entries,
+		     bool default_value, dm_block_t *new_root);
+
+int dm_bitset_del(struct dm_bitset_info *info, dm_block_t root);
+
+/*
+ * May flush and thus update the root.
+ */
+int dm_bitset_set_bit(struct dm_bitset_info *info, dm_block_t root,
+		      uint32_t index, dm_block_t *new_root);
+
+int dm_bitset_clear_bit(struct dm_bitset_info *info, dm_block_t root,
+			uint32_t index, dm_block_t *new_root);
+
+int dm_bitset_test_bit(struct dm_bitset_info *info, dm_block_t root,
+		       uint32_t index, dm_block_t *new_root, bool *result);
+
+/*
+ * You must call this to flush recent changes to disk.
+ */
+int dm_bitset_flush(struct dm_bitset_info *info, dm_block_t root,
+		    dm_block_t *new_root);
+
+/*----------------------------------------------------------------*/
+
+#endif
-- 
1.7.10.4
