From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 10/24] dm cache policy: variable hints support
Date: Thu, 24 Oct 2013 14:30:23 -0400
Message-ID: <1382639437-27007-11-git-send-email-snitzer@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
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
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Policies can now specify a hint size other than 0 or 4.  The
DM_CACHE_POLICY_MAX_HINT_SIZE is 128.

Upcoming policy stack support will make use of variable hints.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-metadata.c        | 104 +++++++++++++++++++++++++++-------
 drivers/md/dm-cache-metadata.h        |  23 +++++---
 drivers/md/dm-cache-policy-cleaner.c  |   2 +-
 drivers/md/dm-cache-policy-internal.h |   5 +-
 drivers/md/dm-cache-policy-mq.c       |  44 ++++++++------
 drivers/md/dm-cache-policy.c          |  19 ++++++-
 drivers/md/dm-cache-policy.h          |  14 +++--
 drivers/md/dm-cache-target.c          |   8 ++-
 8 files changed, 159 insertions(+), 60 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index c409c1a..822972c 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -119,6 +119,7 @@ struct dm_cache_metadata {
 	char policy_name[CACHE_POLICY_NAME_SIZE];
 	unsigned policy_version[CACHE_POLICY_VERSION_SIZE];
 	size_t policy_hint_size;
+	void *policy_hint_value_buffer;
 	struct dm_cache_statistics stats;
 };
 
@@ -243,7 +244,7 @@ static int __superblock_all_zeroes(struct dm_block_manager *bm, bool *result)
 	return dm_bm_unlock(b);
 }
 
-static void __setup_mapping_info(struct dm_cache_metadata *cmd)
+static int __setup_mapping_info(struct dm_cache_metadata *cmd)
 {
 	struct dm_btree_value_type vt;
 
@@ -255,9 +256,30 @@ static void __setup_mapping_info(struct dm_cache_metadata *cmd)
 	dm_array_info_init(&cmd->info, cmd->tm, &vt);
 
 	if (cmd->policy_hint_size) {
-		vt.size = sizeof(__le32);
+		if (cmd->policy_hint_size > DM_CACHE_POLICY_MAX_HINT_SIZE ||
+		    cmd->policy_hint_size % 4) {
+			DMERR("hint size not divisible by 4 or is larger than %d",
+			      (int) DM_CACHE_POLICY_MAX_HINT_SIZE);
+			return -EINVAL;
+		}
+
+		vt.size = cmd->policy_hint_size;
 		dm_array_info_init(&cmd->hint_info, cmd->tm, &vt);
-	}
+
+		cmd->policy_hint_value_buffer = kmalloc(cmd->policy_hint_size, GFP_KERNEL);
+		if (!cmd->policy_hint_value_buffer) {
+			DMERR("unable to allocate hint value buffer");
+			return -ENOMEM;
+		}
+	} else
+		cmd->policy_hint_value_buffer = NULL;
+
+	return 0;
+}
+
+static void __destroy_mapping_info(struct dm_cache_metadata *cmd)
+{
+	kfree(cmd->policy_hint_value_buffer);
 }
 
 static int __write_initial_superblock(struct dm_cache_metadata *cmd)
@@ -330,7 +352,9 @@ static int __format_metadata(struct dm_cache_metadata *cmd)
 		return r;
 	}
 
-	__setup_mapping_info(cmd);
+	r = __setup_mapping_info(cmd);
+	if (r < 0)
+		goto bad_mapping_info;
 
 	r = dm_array_empty(&cmd->info, &cmd->root);
 	if (r < 0)
@@ -353,6 +377,8 @@ static int __format_metadata(struct dm_cache_metadata *cmd)
 	return 0;
 
 bad:
+	__destroy_mapping_info(cmd);
+bad_mapping_info:
 	dm_tm_destroy(cmd->tm);
 	dm_sm_destroy(cmd->metadata_sm);
 
@@ -387,6 +413,12 @@ static int __check_incompat_features(struct cache_disk_superblock *disk_super,
 	return 0;
 }
 
+static bool using_variable_size_hints(struct cache_disk_superblock *disk_super)
+{
+	unsigned long iflags = le32_to_cpu(disk_super->incompat_flags);
+	return test_bit(DM_CACHE_VARIABLE_HINT_SIZE, &iflags);
+}
+
 static int __open_metadata(struct dm_cache_metadata *cmd)
 {
 	int r;
@@ -415,7 +447,18 @@ static int __open_metadata(struct dm_cache_metadata *cmd)
 		goto bad;
 	}
 
-	__setup_mapping_info(cmd);
+	/*
+	 * We need to set the hint size before calling __setup_mapping_info()
+	 */
+	if (using_variable_size_hints(disk_super))
+		cmd->policy_hint_size = le32_to_cpu(disk_super->policy_hint_size);
+	else
+		cmd->policy_hint_size = DM_CACHE_POLICY_DEF_HINT_SIZE;
+
+	r = __setup_mapping_info(cmd);
+	if (r < 0)
+		goto bad;
+
 	dm_disk_bitset_init(cmd->tm, &cmd->discard_info);
 	sb_flags = le32_to_cpu(disk_super->flags);
 	cmd->clean_when_opened = test_bit(CLEAN_SHUTDOWN, &sb_flags);
@@ -503,7 +546,16 @@ static void read_superblock_fields(struct dm_cache_metadata *cmd,
 	cmd->policy_version[0] = le32_to_cpu(disk_super->policy_version[0]);
 	cmd->policy_version[1] = le32_to_cpu(disk_super->policy_version[1]);
 	cmd->policy_version[2] = le32_to_cpu(disk_super->policy_version[2]);
-	cmd->policy_hint_size = le32_to_cpu(disk_super->policy_hint_size);
+
+	if (using_variable_size_hints(disk_super))
+		cmd->policy_hint_size = le32_to_cpu(disk_super->policy_hint_size);
+	else {
+		/*
+		 * Must establish policy_hint_size because older superblock
+		 * wouldn't have it.
+		 */
+		cmd->policy_hint_size = DM_CACHE_POLICY_DEF_HINT_SIZE;
+	}
 
 	cmd->stats.read_hits = le32_to_cpu(disk_super->read_hits);
 	cmd->stats.read_misses = le32_to_cpu(disk_super->read_misses);
@@ -601,6 +653,15 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
 	disk_super->policy_version[1] = cpu_to_le32(cmd->policy_version[1]);
 	disk_super->policy_version[2] = cpu_to_le32(cmd->policy_version[2]);
 
+	if (cmd->policy_hint_size != DM_CACHE_POLICY_DEF_HINT_SIZE) {
+		unsigned long iflags = 0;
+		set_bit(DM_CACHE_VARIABLE_HINT_SIZE, &iflags);
+		disk_super->incompat_flags = cpu_to_le32(iflags);
+	} else
+		disk_super->incompat_flags = cpu_to_le32(0u);
+
+	disk_super->policy_hint_size =  cpu_to_le32(cmd->policy_hint_size);
+
 	disk_super->read_hits = cpu_to_le32(cmd->stats.read_hits);
 	disk_super->read_misses = cpu_to_le32(cmd->stats.read_misses);
 	disk_super->write_hits = cpu_to_le32(cmd->stats.write_hits);
@@ -666,6 +727,7 @@ struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
 
 	r = __create_persistent_data_objects(cmd, may_format_device);
 	if (r) {
+		__destroy_mapping_info(cmd);
 		kfree(cmd);
 		return ERR_PTR(r);
 	}
@@ -682,6 +744,7 @@ struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
 void dm_cache_metadata_close(struct dm_cache_metadata *cmd)
 {
 	__destroy_persistent_data_objects(cmd);
+	__destroy_mapping_info(cmd);
 	kfree(cmd);
 }
 
@@ -927,7 +990,6 @@ static int __load_mapping(void *context, uint64_t cblock, void *leaf)
 	int r = 0;
 	bool dirty;
 	__le64 value;
-	__le32 hint_value = 0;
 	dm_oblock_t oblock;
 	unsigned flags;
 	struct thunk *thunk = context;
@@ -939,14 +1001,14 @@ static int __load_mapping(void *context, uint64_t cblock, void *leaf)
 	if (flags & M_VALID) {
 		if (thunk->hints_valid) {
 			r = dm_array_get_value(&cmd->hint_info, cmd->hint_root,
-					       cblock, &hint_value);
+					       cblock, cmd->policy_hint_value_buffer);
 			if (r && r != -ENODATA)
 				return r;
 		}
 
 		dirty = thunk->respect_dirty_flags ? (flags & M_DIRTY) : true;
 		r = thunk->fn(thunk->context, oblock, to_cblock(cblock),
-			      dirty, le32_to_cpu(hint_value), thunk->hints_valid);
+			      dirty, cmd->policy_hint_value_buffer, thunk->hints_valid);
 	}
 
 	return r;
@@ -1122,8 +1184,6 @@ int dm_cache_get_metadata_dev_size(struct dm_cache_metadata *cmd,
 static int begin_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *policy)
 {
 	int r;
-	__le32 value;
-	size_t hint_size;
 	const char *policy_name = dm_cache_policy_get_name(policy);
 	const unsigned *policy_version = dm_cache_policy_get_version(policy);
 
@@ -1132,6 +1192,8 @@ static int begin_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *po
 		return -EINVAL;
 
 	if (!policy_unchanged(cmd, policy)) {
+		size_t hint_size;
+
 		strncpy(cmd->policy_name, policy_name, sizeof(cmd->policy_name));
 		memcpy(cmd->policy_version, policy_version, sizeof(cmd->policy_version));
 
@@ -1150,11 +1212,11 @@ static int begin_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *po
 		if (r)
 			return r;
 
-		value = cpu_to_le32(0);
+		memset(cmd->policy_hint_value_buffer, 0, hint_size);
 		__dm_bless_for_disk(&value);
 		r = dm_array_resize(&cmd->hint_info, cmd->hint_root, 0,
 				    from_cblock(cmd->cache_blocks),
-				    &value, &cmd->hint_root);
+				    cmd->policy_hint_value_buffer, &cmd->hint_root);
 		if (r)
 			return r;
 	}
@@ -1173,27 +1235,27 @@ int dm_cache_begin_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *
 	return r;
 }
 
-static int save_hint(struct dm_cache_metadata *cmd, dm_cblock_t cblock,
-		     uint32_t hint)
+static int save_hint(struct dm_cache_metadata *cmd, dm_cblock_t cblock, void *hint)
+	__dm_written_to_disk(hint)
 {
 	int r;
-	__le32 value = cpu_to_le32(hint);
-	__dm_bless_for_disk(&value);
 
 	r = dm_array_set_value(&cmd->hint_info, cmd->hint_root,
-			       from_cblock(cblock), &value, &cmd->hint_root);
+			       from_cblock(cblock), hint, &cmd->hint_root);
 	cmd->changed = true;
 
 	return r;
 }
 
-int dm_cache_save_hint(struct dm_cache_metadata *cmd, dm_cblock_t cblock,
-		       uint32_t hint)
+int dm_cache_save_hint(struct dm_cache_metadata *cmd, dm_cblock_t cblock, void *hint)
+	__dm_written_to_disk(hint)
 {
 	int r;
 
-	if (!hints_array_initialized(cmd))
+	if (!hints_array_initialized(cmd)) {
+		__dm_unbless_for_disk(hint);
 		return 0;
+	}
 
 	down_write(&cmd->root_lock);
 	r = save_hint(cmd, cblock, hint);
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index f45cef2..44fd4bf 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -49,7 +49,12 @@
  */
 #define DM_CACHE_FEATURE_COMPAT_SUPP	  0UL
 #define DM_CACHE_FEATURE_COMPAT_RO_SUPP	  0UL
-#define DM_CACHE_FEATURE_INCOMPAT_SUPP	  0UL
+
+enum dm_cache_incompat_bits {
+	DM_CACHE_VARIABLE_HINT_SIZE = 0
+};
+
+#define DM_CACHE_FEATURE_INCOMPAT_SUPP	  (1 << DM_CACHE_VARIABLE_HINT_SIZE)
 
 /*
  * Reopens or creates a new, empty metadata volume.
@@ -87,7 +92,7 @@ int dm_cache_changed_this_transaction(struct dm_cache_metadata *cmd);
 
 typedef int (*load_mapping_fn)(void *context, dm_oblock_t oblock,
 			       dm_cblock_t cblock, bool dirty,
-			       uint32_t hint, bool hint_valid);
+			       void *hint, bool hint_valid);
 int dm_cache_load_mappings(struct dm_cache_metadata *cmd,
 			   struct dm_cache_policy *policy,
 			   load_mapping_fn fn,
@@ -118,9 +123,10 @@ int dm_cache_get_metadata_dev_size(struct dm_cache_metadata *cmd,
 void dm_cache_dump(struct dm_cache_metadata *cmd);
 
 /*
- * The policy is invited to save a 32bit hint value for every cblock (eg,
- * for a hit count).  These are stored against the policy name.  If
- * policies are changed, then hints will be lost.  If the machine crashes,
+ * The policy is invited to save a hint (void* sequence of bytes) for every
+ * cblock (eg, for a hit count) and is reponsible to do endianess conversions.
+ * These are stored against the policy name.
+ * If policies are changed, then hints will be lost.  If the machine crashes,
  * hints will be lost.
  *
  * The hints are indexed by the cblock, but many policies will not
@@ -132,10 +138,13 @@ void dm_cache_dump(struct dm_cache_metadata *cmd);
 int dm_cache_begin_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *p);
 
 /*
- * requests hints for every cblock and stores in the metadata device.
+ * Saves the hint for a given cblock in the metadata device.  Policy
+ * modules must perform any endian conversions needed and bless the hints
+ * for disk.
  */
 int dm_cache_save_hint(struct dm_cache_metadata *cmd,
-		       dm_cblock_t cblock, uint32_t hint);
+		       dm_cblock_t cblock, void *hint)
+	__dm_written_to_disk(hint);
 
 /*----------------------------------------------------------------*/
 
diff --git a/drivers/md/dm-cache-policy-cleaner.c b/drivers/md/dm-cache-policy-cleaner.c
index b04d1f9..7e5983c 100644
--- a/drivers/md/dm-cache-policy-cleaner.c
+++ b/drivers/md/dm-cache-policy-cleaner.c
@@ -274,7 +274,7 @@ static void add_cache_entry(struct policy *p, struct wb_cache_entry *e)
 
 static int wb_load_mapping(struct dm_cache_policy *pe,
 			   dm_oblock_t oblock, dm_cblock_t cblock,
-			   uint32_t hint, bool hint_valid)
+			   void *hint, bool hint_valid)
 {
 	int r;
 	struct policy *p = to_policy(pe);
diff --git a/drivers/md/dm-cache-policy-internal.h b/drivers/md/dm-cache-policy-internal.h
index a75f7e7..0f749e8 100644
--- a/drivers/md/dm-cache-policy-internal.h
+++ b/drivers/md/dm-cache-policy-internal.h
@@ -41,7 +41,7 @@ static inline void policy_clear_dirty(struct dm_cache_policy *p, dm_oblock_t obl
 
 static inline int policy_load_mapping(struct dm_cache_policy *p,
 				      dm_oblock_t oblock, dm_cblock_t cblock,
-				      uint32_t hint, bool hint_valid)
+				      void *hint, bool hint_valid)
 {
 	return p->load_mapping(p, oblock, cblock, hint, hint_valid);
 }
@@ -119,6 +119,9 @@ const char *dm_cache_policy_get_name(struct dm_cache_policy *p);
 
 const unsigned *dm_cache_policy_get_version(struct dm_cache_policy *p);
 
+#define DM_CACHE_POLICY_DEF_HINT_SIZE 4U
+#define DM_CACHE_POLICY_MAX_HINT_SIZE 128U
+int    dm_cache_policy_set_hint_size(struct dm_cache_policy *p, unsigned hint_size);
 size_t dm_cache_policy_get_hint_size(struct dm_cache_policy *p);
 
 /*----------------------------------------------------------------*/
diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 152e979..9f2589e 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -6,6 +6,7 @@
 
 #include "dm-cache-policy.h"
 #include "dm.h"
+#include "persistent-data/dm-btree.h"
 
 #include <linux/hash.h>
 #include <linux/module.h>
@@ -1024,7 +1025,7 @@ static void mq_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
 
 static int mq_load_mapping(struct dm_cache_policy *p,
 			   dm_oblock_t oblock, dm_cblock_t cblock,
-			   uint32_t hint, bool hint_valid)
+			   void *hint, bool hint_valid)
 {
 	struct mq_policy *mq = to_mq_policy(p);
 	struct entry *e;
@@ -1037,38 +1038,45 @@ static int mq_load_mapping(struct dm_cache_policy *p,
 	e->oblock = oblock;
 	e->in_cache = true;
 	e->dirty = true;	/* this gets corrected in a minute */
-	e->hit_count = hint_valid ? hint : 1;
+	e->hit_count = hint_valid ? le32_to_cpu(*((__le32 *) hint)) : 1;
 	e->generation = mq->generation;
 	push(mq, e);
 
 	return 0;
 }
 
+static int mq_save_hints(struct mq_policy *mq, struct queue *q,
+			 policy_walk_fn fn, void *context)
+{
+	int r;
+	unsigned level;
+	struct entry *e;
+
+	for (level = 0; level < NR_QUEUE_LEVELS; level++)
+		list_for_each_entry(e, q->qs + level, list) {
+			__le32 value = cpu_to_le32(e->hit_count);
+			__dm_bless_for_disk(&value);
+
+			r = fn(context, e->cblock, e->oblock, &value);
+			if (r)
+				return r;
+		}
+
+	return 0;
+}
+
 static int mq_walk_mappings(struct dm_cache_policy *p, policy_walk_fn fn,
 			    void *context)
 {
 	struct mq_policy *mq = to_mq_policy(p);
 	int r = 0;
-	struct entry *e;
-	unsigned level;
 
 	mutex_lock(&mq->lock);
 
-	for (level = 0; level < NR_QUEUE_LEVELS; level++)
-		list_for_each_entry(e, &mq->cache_clean.qs[level], list) {
-			r = fn(context, e->cblock, e->oblock, e->hit_count);
-			if (r)
-				goto out;
-		}
-
-	for (level = 0; level < NR_QUEUE_LEVELS; level++)
-		list_for_each_entry(e, &mq->cache_dirty.qs[level], list) {
-			r = fn(context, e->cblock, e->oblock, e->hit_count);
-			if (r)
-				goto out;
-		}
+	r = mq_save_hints(mq, &mq->cache_clean, fn, context);
+	if (!r)
+		r = mq_save_hints(mq, &mq->cache_dirty, fn, context);
 
-out:
 	mutex_unlock(&mq->lock);
 
 	return r;
diff --git a/drivers/md/dm-cache-policy.c b/drivers/md/dm-cache-policy.c
index 21c03c5..8e84d08 100644
--- a/drivers/md/dm-cache-policy.c
+++ b/drivers/md/dm-cache-policy.c
@@ -80,9 +80,10 @@ int dm_cache_policy_register(struct dm_cache_policy_type *type)
 {
 	int r;
 
-	/* One size fits all for now */
-	if (type->hint_size != 0 && type->hint_size != 4) {
-		DMWARN("hint size must be 0 or 4 but %llu supplied.", (unsigned long long) type->hint_size);
+	if (type->hint_size > DM_CACHE_POLICY_MAX_HINT_SIZE) {
+		DMWARN("hint size must be <= %llu but %llu was supplied.",
+		       (unsigned long long) DM_CACHE_POLICY_MAX_HINT_SIZE,
+		       (unsigned long long) type->hint_size);
 		return -EINVAL;
 	}
 
@@ -166,4 +167,16 @@ size_t dm_cache_policy_get_hint_size(struct dm_cache_policy *p)
 }
 EXPORT_SYMBOL_GPL(dm_cache_policy_get_hint_size);
 
+int dm_cache_policy_set_hint_size(struct dm_cache_policy *p, unsigned hint_size)
+{
+	struct dm_cache_policy_type *t = p->private;
+
+	if (hint_size > DM_CACHE_POLICY_MAX_HINT_SIZE)
+		return -EPERM;
+
+	t->hint_size = hint_size;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_cache_policy_set_hint_size);
+
 /*----------------------------------------------------------------*/
diff --git a/drivers/md/dm-cache-policy.h b/drivers/md/dm-cache-policy.h
index 33369ca..6779ea7 100644
--- a/drivers/md/dm-cache-policy.h
+++ b/drivers/md/dm-cache-policy.h
@@ -8,6 +8,7 @@
 #define DM_CACHE_POLICY_H
 
 #include "dm-cache-block-types.h"
+#include "persistent-data/dm-btree.h"
 
 #include <linux/device-mapper.h>
 
@@ -79,7 +80,8 @@ struct policy_result {
 };
 
 typedef int (*policy_walk_fn)(void *context, dm_cblock_t cblock,
-			      dm_oblock_t oblock, uint32_t hint);
+			      dm_oblock_t oblock, void *hint)
+	__dm_written_to_disk(hint);
 
 /*
  * The cache policy object.  Just a bunch of methods.  It is envisaged that
@@ -146,7 +148,7 @@ struct dm_cache_policy {
 	 * mapping from the metadata device into the policy.
 	 */
 	int (*load_mapping)(struct dm_cache_policy *p, dm_oblock_t oblock,
-			    dm_cblock_t cblock, uint32_t hint, bool hint_valid);
+			    dm_cblock_t cblock, void *hint, bool hint_valid);
 
 	int (*walk_mappings)(struct dm_cache_policy *p, policy_walk_fn fn,
 			     void *context);
@@ -210,9 +212,9 @@ struct dm_cache_policy_type {
 	unsigned version[CACHE_POLICY_VERSION_SIZE];
 
 	/*
-	 * Policies may store a hint for each each cache block.
-	 * Currently the size of this hint must be 0 or 4 bytes but we
-	 * expect to relax this in future.
+	 * Policies may store a hint for each cache block.
+	 * Currently the size of this hint must be <=
+	 * DM_CACHE_POLICY_MAX_HINT_SIZE bytes.
 	 */
 	size_t hint_size;
 
@@ -227,4 +229,4 @@ void dm_cache_policy_unregister(struct dm_cache_policy_type *type);
 
 /*----------------------------------------------------------------*/
 
-#endif	/* DM_CACHE_POLICY_H */
+#endif /* DM_CACHE_POLICY_H */
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 2956976..6fa45a8 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2304,9 +2304,11 @@ static int write_discard_bitset(struct cache *cache)
 }
 
 static int save_hint(void *context, dm_cblock_t cblock, dm_oblock_t oblock,
-		     uint32_t hint)
+		     void *hint)
 {
 	struct cache *cache = context;
+
+	__dm_bless_for_disk(hint);
 	return dm_cache_save_hint(cache->cmd, cblock, hint);
 }
 
@@ -2374,7 +2376,7 @@ static void cache_postsuspend(struct dm_target *ti)
 }
 
 static int load_mapping(void *context, dm_oblock_t oblock, dm_cblock_t cblock,
-			bool dirty, uint32_t hint, bool hint_valid)
+			bool dirty, void *hint, bool hint_valid)
 {
 	int r;
 	struct cache *cache = context;
@@ -2630,7 +2632,7 @@ static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type cache_target = {
 	.name = "cache",
-	.version = {1, 1, 1},
+	.version = {1, 2, 0},
 	.module = THIS_MODULE,
 	.ctr = cache_ctr,
 	.dtr = cache_dtr,
-- 
1.8.1.4
