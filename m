From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 20/24] dm cache: add era policy shim
Date: Thu, 24 Oct 2013 14:30:33 -0400
Message-ID: <1382639437-27007-21-git-send-email-snitzer@redhat.com>
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

From: Morgan Mears <morgan.mears@netapp.com>

This commit includes a non-terminal policy (aka "shim") called era that
may be stacked ontop of a terminal policy (e.g. mq).

The era policy adds:
- an era number to every cache block that gets updated on write hits
- an interface that allows an application to read and increment the
  current era value
- an interface to invalidate cache blocks that have been written to
  before or after a given era

This functionality can be used to partially invalidate the cache
contents to restore cache coherency after a snapshot rollback.

Signed-off-by: Morgan Mears <morgan.mears@netapp.com>
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/Kconfig               |  17 ++
 drivers/md/Makefile              |   2 +
 drivers/md/dm-cache-policy-era.c | 428 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 447 insertions(+)
 create mode 100644 drivers/md/dm-cache-policy-era.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 816e023..ad32101 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -282,6 +282,23 @@ config DM_CACHE_MQ
          This is meant to be a general purpose policy.  It prioritises
          reads over writes.
 
+config DM_CACHE_ERA
+       tristate "ERA Cache Policy shim (EXPERIMENTAL)"
+       depends on DM_CACHE
+       ---help---
+	 A cache policy shim that adds an "era" property to the
+	 per-cache-block metadata, to facilitate the implementation of
+	 cache coherency validation and recovery tools.	 This mechanism
+	 works as follows.  There is a monotonically increasing 32-bit
+	 era counter associated with each cache instance.  Each cache
+	 block is tagged with the era during which it was last written.
+	 A device mapper message interface is provided to obtain the
+	 current era, advance to the next era, and invalidate blocks
+	 from before or after a given era.  Note that you can use this
+	 policy shim to add the era functionality to any cache policy
+	 via name concatenation -- specify era+mq instead of just mq to
+	 add the era mechanism to the mq policy, for example.
+
 config DM_CACHE_CLEANER
        tristate "Cleaner Cache Policy (EXPERIMENTAL)"
        depends on DM_CACHE
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 5f6dfc3..0ae00bd 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -15,6 +15,7 @@ dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o \
 		   dm-cache-shim-utils.o dm-cache-stack-utils.o
 dm-cache-mq-y   += dm-cache-policy-mq.o
 dm-cache-cleaner-y += dm-cache-policy-cleaner.o
+dm-cache-era-y	+= dm-cache-policy-era.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o
 
@@ -53,6 +54,7 @@ obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
 obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
 obj-$(CONFIG_DM_CACHE_MQ)	+= dm-cache-mq.o
 obj-$(CONFIG_DM_CACHE_CLEANER)	+= dm-cache-cleaner.o
+obj-$(CONFIG_DM_CACHE_ERA)	+= dm-cache-era.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
diff --git a/drivers/md/dm-cache-policy-era.c b/drivers/md/dm-cache-policy-era.c
new file mode 100644
index 0000000..427514c
--- /dev/null
+++ b/drivers/md/dm-cache-policy-era.c
@@ -0,0 +1,428 @@
+/*
+ * Copyright 2013 NetApp, Inc. All Rights Reserved, contribution by
+ * Morgan Mears.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
+ * for more details
+ *
+ */
+
+#include "dm-cache-policy.h"
+#include "dm-cache-policy-internal.h"
+#include "dm-cache-shim-utils.h"
+#include "dm.h"
+
+#include <linux/hash.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include <linux/delay.h>
+
+#define DEBUG_ERA 0
+
+#define DM_MSG_PREFIX "cache-policy-era"
+
+typedef uint32_t era_t;
+#define ERA_MAX_ERA UINT_MAX
+
+struct era_policy {
+	struct dm_cache_policy policy;
+
+	struct mutex lock;	/* FIXME: spinlock? */
+
+	dm_cblock_t cache_size;
+
+	era_t *cb_to_era;
+
+	era_t era_counter;
+};
+
+/*----------------------------------------------------------------*/
+
+static struct era_policy *to_era_policy(struct dm_cache_policy *p)
+{
+	return container_of(p, struct era_policy, policy);
+}
+
+static int incr_era_counter(struct era_policy *era, const char *curr_era_str)
+{
+	era_t curr_era_counter;
+	int r;
+
+	/*
+	 * If the era counter value provided by the user matches the current
+	 * counter value while under lock, increment the counter (intention
+	 * is to prevent races).  Rollover problems are avoided by locking
+	 * the counter at a maximum value.  The application must take
+	 * appropriate action on this error to preserve correction, but
+	 * a properly behaved set of applications will never trigger it;
+	 * the era counter is meant to increment less than once a second
+	 * and is 32 bits.
+	 */
+
+	if (kstrtou32(curr_era_str, 10, &curr_era_counter))
+		return -EINVAL;
+
+	smp_rmb();
+	if (era->era_counter != curr_era_counter)
+		r = -ECANCELED;
+	else if (era->era_counter >= ERA_MAX_ERA)
+		r = -EOVERFLOW;
+	else {
+		era->era_counter++;
+		smp_wmb();
+		r = 0;
+	}
+
+	return r;
+}
+
+static void *era_cblock_to_hint(struct shim_walk_map_ctx *ctx,
+				dm_cblock_t cblock, dm_oblock_t oblock)
+{
+	struct era_policy *era = to_era_policy(ctx->my_policy);
+	era_t era_val;
+	era_val = era->cb_to_era[from_cblock(cblock)];
+#if DEBUG_ERA
+	DMDEBUG("storing era %u for cblock %u.", era_val, cblock);
+#endif
+	ctx->le32_buf = cpu_to_le32(era_val);
+	return &ctx->le32_buf;
+}
+
+static int era_is_gt_value(era_t era, era_t value)
+{
+	return era > value;
+}
+
+static int era_is_gte_value(era_t era, era_t value)
+{
+	return era >= value;
+}
+
+static int era_is_lte_value(era_t era, era_t value)
+{
+	return era <= value;
+}
+
+static int era_is_lt_value(era_t era, era_t value)
+{
+	return era < value;
+}
+
+typedef int (*era_match_fn_t)(era_t, era_t);
+
+struct inval_oblocks_ctx {
+	struct era_policy *era;
+	era_match_fn_t era_match_fn;
+	era_t test_era;
+};
+
+static int era_inval_oblocks(void *context, dm_cblock_t cblock,
+			     dm_oblock_t oblock, void *unused)
+{
+	struct inval_oblocks_ctx *ctx = (struct inval_oblocks_ctx *)context;
+	struct dm_cache_policy *child;
+	era_t act_era;
+
+	act_era = ctx->era->cb_to_era[from_cblock(cblock)];
+	if (ctx->era_match_fn(act_era, ctx->test_era)) {
+#if DEBUG_ERA
+		DMDEBUG("cblock %u has era %u matching test_era %u; "
+			"marking mapping to be removed for oblock %llu.",
+			from_cblock(cblock), act_era, ctx->test_era, oblock);
+#endif
+		child = ctx->era->policy.child;
+
+		/*
+		 * This deadlocks (lock against self) because child is calling
+		 * us via the walk_mappings context callback, child's
+		 * walk_mappings holds child's lock, and child's remove_mappings
+		 * tries to get it again.  Not fixing because I believe the
+		 * invalidate API is going to change.
+		 */
+		/* child->remove_mapping(child, oblock); */
+	}
+
+	return 0;
+}
+
+static int cond_unmap_by_era(struct era_policy *era, const char *test_era_str,
+			     era_match_fn_t era_match_fn)
+{
+	struct shim_walk_map_ctx ctx;
+	struct inval_oblocks_ctx io_ctx;
+	era_t test_era;
+	int r;
+
+	/*
+	 * Unmap blocks with eras matching the given era, according to the
+	 * given matching function.
+	 */
+
+	if (kstrtou32(test_era_str, 10, &test_era))
+		return -EINVAL;
+
+	io_ctx.era = era;
+	io_ctx.era_match_fn = era_match_fn;
+	io_ctx.test_era = test_era;
+
+	ctx.parent_ctx = &io_ctx;
+	ctx.parent_fn = era_inval_oblocks;
+	ctx.my_policy = &era->policy;
+	ctx.child_hint_buf = NULL;
+	ctx.cblock_to_hint_fn = NULL;
+
+	mutex_lock(&era->lock);
+	r = dm_cache_shim_utils_walk_map_with_ctx(&ctx);
+	mutex_unlock(&era->lock);
+
+	return r;
+}
+
+/*
+ * Public interface, via the policy struct.  See dm-cache-policy.h for a
+ * description of these.
+ */
+
+static void era_destroy(struct dm_cache_policy *p)
+{
+	struct era_policy *era = to_era_policy(p);
+#if DEBUG_ERA
+	DMDEBUG("destroyed era %p", era);
+#endif
+	kfree(era->cb_to_era);
+	kfree(era);
+}
+
+static int era_map(struct dm_cache_policy *p, dm_oblock_t oblock,
+		      bool can_block, bool can_migrate, bool discarded_oblock,
+		      struct bio *bio, struct policy_result *result)
+{
+	struct era_policy *era = to_era_policy(p);
+	uint32_t cb_idx;
+	int r;
+
+	result->op = POLICY_MISS;
+
+	if (can_block)
+		mutex_lock(&era->lock);
+	else if (!mutex_trylock(&era->lock))
+		return -EWOULDBLOCK;
+
+	/* Check for a mapping */
+	r = policy_map(p->child, oblock, can_block, can_migrate,
+		       discarded_oblock, bio, result);
+
+	/* If we got a hit and this is a write, update the era for the block */
+	if (!r && (bio_data_dir(bio) == WRITE) && (result->op == POLICY_HIT)) {
+		cb_idx = from_cblock(result->cblock);
+		BUG_ON(cb_idx >= from_cblock(era->cache_size));
+		smp_rmb();
+		era->cb_to_era[cb_idx] = era->era_counter;
+#if DEBUG_ERA
+		DMDEBUG("assigned era %u to cblock %u, oblock %llu due to write hit.",
+			era->era_counter, result->cblock, oblock);
+#endif
+	}
+
+	mutex_unlock(&era->lock);
+
+	return r;
+}
+
+static int era_load_mapping(struct dm_cache_policy *p,
+			    dm_oblock_t oblock, dm_cblock_t cblock,
+			    void *hint, bool hint_valid)
+{
+	struct era_policy *era = to_era_policy(p);
+	struct dm_cache_policy *child;
+	__le32 *le32_hint;
+	era_t recovered_era;
+	int r;
+
+	child = era->policy.child;
+
+	le32_hint = (__le32 *)hint;
+	hint = &le32_hint[1];
+
+	r = policy_load_mapping(child, oblock, cblock, hint, hint_valid);
+
+	if (!r && hint_valid &&
+	    (from_cblock(cblock) < from_cblock(era->cache_size))) {
+		recovered_era = le32_to_cpu(*le32_hint);
+#if DEBUG_ERA
+		DMDEBUG("recovered era %u for cblock %u.", recovered_era, cblock);
+#endif
+		era->cb_to_era[from_cblock(cblock)] = recovered_era;
+
+		/*
+		 * Make sure the era counter starts higher than the highest
+		 * persisted era.
+		 */
+		smp_rmb();
+		if (recovered_era >= era->era_counter) {
+			era->era_counter = recovered_era;
+			if (era->era_counter < ERA_MAX_ERA)
+				era->era_counter++;
+			smp_wmb();
+#if DEBUG_ERA
+			DMDEBUG("set era_counter to %u.", era->era_counter);
+#endif
+		}
+	}
+
+	return r;
+}
+
+static int era_walk_mappings(struct dm_cache_policy *p, policy_walk_fn fn,
+			     void *context)
+{
+	return dm_cache_shim_utils_walk_map(p, fn, context, era_cblock_to_hint);
+}
+
+static void era_force_mapping(struct dm_cache_policy *p, dm_oblock_t old_oblock,
+			      dm_oblock_t new_oblock)
+{
+	struct era_policy *era = to_era_policy(p);
+	dm_cblock_t cblock;
+
+	mutex_lock(&era->lock);
+
+	if (!policy_lookup(p->child, old_oblock, &cblock)) {
+		smp_rmb();
+		era->cb_to_era[from_cblock(cblock)] = era->era_counter;
+#if DEBUG_ERA
+		DMDEBUG("assigned era %u to cblock %u, oblock %llu "
+			"(old_oblock %llu) due to force_mapping.",
+			era->era_counter, cblock, new_oblock, old_oblock);
+#endif
+	}
+
+	policy_force_mapping(p->child, old_oblock, new_oblock);
+
+	mutex_unlock(&era->lock);
+}
+
+static int era_set_config_value(struct dm_cache_policy *p, const char *key,
+				const char *value)
+{
+	struct era_policy *era = to_era_policy(p);
+	int r;
+
+	if (!strcasecmp(key, "increment_era_counter"))
+		r = incr_era_counter(era, value);
+	else if (!strcasecmp(key, "unmap_blocks_from_later_eras"))
+		r = cond_unmap_by_era(era, value, era_is_gt_value);
+	else if (!strcasecmp(key, "unmap_blocks_from_this_era_and_later"))
+		r = cond_unmap_by_era(era, value, era_is_gte_value);
+	else if (!strcasecmp(key, "unmap_blocks_from_this_era_and_earlier"))
+		r = cond_unmap_by_era(era, value, era_is_lte_value);
+	else if (!strcasecmp(key, "unmap_blocks_from_earlier_eras"))
+		r = cond_unmap_by_era(era, value, era_is_lt_value);
+	else
+		r = policy_set_config_value(p->child, key, value);
+
+	return r;
+}
+
+static int era_emit_config_values(struct dm_cache_policy *p, char *result,
+				  unsigned maxlen)
+{
+	struct era_policy *era = to_era_policy(p);
+	ssize_t sz = 0;
+
+	smp_rmb();
+	DMEMIT("era_counter %u ", era->era_counter);
+	return policy_emit_config_values(p->child, result + sz, maxlen - sz);
+}
+
+/* Init the policy plugin interface function pointers. */
+static void init_policy_functions(struct era_policy *era)
+{
+	dm_cache_shim_utils_init_shim_policy(&era->policy);
+	era->policy.destroy = era_destroy;
+	era->policy.map = era_map;
+	era->policy.load_mapping = era_load_mapping;
+	era->policy.walk_mappings = era_walk_mappings;
+	era->policy.force_mapping = era_force_mapping;
+	era->policy.emit_config_values = era_emit_config_values;
+	era->policy.set_config_value = era_set_config_value;
+}
+
+static struct dm_cache_policy *era_create(dm_cblock_t cache_size,
+					  sector_t origin_size,
+					  sector_t cache_block_size)
+{
+	struct era_policy *era = kzalloc(sizeof(*era), GFP_KERNEL);
+
+	if (!era)
+		return NULL;
+
+	init_policy_functions(era);
+	era->cache_size = cache_size;
+	mutex_init(&era->lock);
+
+	era->cb_to_era = kzalloc(from_cblock(era->cache_size) *
+				 sizeof(*(era->cb_to_era)), GFP_KERNEL);
+	if (!era->cb_to_era)
+		goto bad_alloc_cb_to_era;
+	era->era_counter = 1;
+
+	return &era->policy;
+
+bad_alloc_cb_to_era:
+	kfree(era);
+	return NULL;
+}
+
+/*----------------------------------------------------------------*/
+
+static struct dm_cache_policy_type era_policy_type = {
+	.name = "era",
+	.version = {1, 0, 0},
+	.hint_size = 4,
+	.owner = THIS_MODULE,
+	.create = era_create,
+	.features = DM_CACHE_POLICY_SHIM
+};
+
+static int __init era_init(void)
+{
+	int r;
+
+	r = dm_cache_policy_register(&era_policy_type);
+	if (!r) {
+		DMINFO("version %u.%u.%u loaded",
+		       era_policy_type.version[0],
+		       era_policy_type.version[1],
+		       era_policy_type.version[2]);
+		return 0;
+	}
+
+	DMERR("register failed %d", r);
+
+	dm_cache_policy_unregister(&era_policy_type);
+	return -ENOMEM;
+}
+
+static void __exit era_exit(void)
+{
+	dm_cache_policy_unregister(&era_policy_type);
+}
+
+module_init(era_init);
+module_exit(era_exit);
+
+MODULE_AUTHOR("Morgan Mears <dm-devel@redhat.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("era cache policy shim");
-- 
1.8.1.4
