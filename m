From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH] dm thin metadata: Remove unused local variable when create thin and snap
Date: Tue, 15 Sep 2020 16:56:08 +0800
Message-ID: <20200915085608.13776-1-yehs2007@zoho.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: snitzer@redhat.com, agk@redhat.com
Cc: tyu1@lenovo.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

From: Huaisheng Ye <yehs1@lenovo.com>

The local variable disk details is not used during the creating of thin & snap
devices. Remove them from dm-thin-metadata, and add pointer validity check for
pointer value in btree_lookup_raw. Skip memory copy when the caller doesn't need
the value.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-thin-metadata.c         | 6 ++----
 drivers/md/persistent-data/dm-btree.c | 3 ++-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index b461836..6ebb212 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1051,12 +1051,11 @@ static int __create_thin(struct dm_pool_metadata *pmd,
 	int r;
 	dm_block_t dev_root;
 	uint64_t key = dev;
-	struct disk_device_details details_le;
 	struct dm_thin_device *td;
 	__le64 value;
 
 	r = dm_btree_lookup(&pmd->details_info, pmd->details_root,
-			    &key, &details_le);
+			    &key, NULL);
 	if (!r)
 		return -EEXIST;
 
@@ -1129,12 +1128,11 @@ static int __create_snap(struct dm_pool_metadata *pmd,
 	dm_block_t origin_root;
 	uint64_t key = origin, dev_key = dev;
 	struct dm_thin_device *td;
-	struct disk_device_details details_le;
 	__le64 value;
 
 	/* check this device is unused */
 	r = dm_btree_lookup(&pmd->details_info, pmd->details_root,
-			    &dev_key, &details_le);
+			    &dev_key, NULL);
 	if (!r)
 		return -EEXIST;
 
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 8aae062..ef6e78d 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -366,7 +366,8 @@ static int btree_lookup_raw(struct ro_spine *s, dm_block_t block, uint64_t key,
 	} while (!(flags & LEAF_NODE));
 
 	*result_key = le64_to_cpu(ro_node(s)->keys[i]);
-	memcpy(v, value_ptr(ro_node(s), i), value_size);
+	if (v)
+		memcpy(v, value_ptr(ro_node(s), i), value_size);
 
 	return 0;
 }
-- 
1.8.3.1
