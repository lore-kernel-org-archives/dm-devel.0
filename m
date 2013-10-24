From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 21/24] dm cache: add trc policy shim
Date: Thu, 24 Oct 2013 14:30:34 -0400
Message-ID: <1382639437-27007-22-git-send-email-snitzer@redhat.com>
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

This commit includes a non-terminal policy (aka "shim") called trc that
may be stacked ontop of a terminal policy (e.g. mq).

The second shim, trc, adds function-call-level tracing to the policy
stack.  By default, an INFO-level log message including function name
and parameter(s) will be generated whenever most of the cache policy
interface functions are called.  An interface to increase or decrease
the verbosity of the trace output is also provided.

Signed-off-by: Morgan Mears <morgan.mears@netapp.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/Kconfig               |   8 ++
 drivers/md/Makefile              |   2 +
 drivers/md/dm-cache-policy-trc.c | 255 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 265 insertions(+)
 create mode 100644 drivers/md/dm-cache-policy-trc.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index ad32101..d63539c 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -449,4 +449,12 @@ config DM_DELAY
 
 	If unsure, say N.
 
+config DM_CACHE_TRC
+       tristate "Tracing Cache Policy shim (EXPERIMENTAL)"
+       depends on DM_CACHE
+       depends on DM_TEST_TARGETS
+       ---help---
+         A cache policy shim that adds debug tracing for all cache policy
+	 interface function calls, along with a configurable trace level.
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 0ae00bd..d68fdf7 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -16,6 +16,7 @@ dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o \
 dm-cache-mq-y   += dm-cache-policy-mq.o
 dm-cache-cleaner-y += dm-cache-policy-cleaner.o
 dm-cache-era-y	+= dm-cache-policy-era.o
+dm-cache-trc-y	+= dm-cache-policy-trc.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o
 
@@ -55,6 +56,7 @@ obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
 obj-$(CONFIG_DM_CACHE_MQ)	+= dm-cache-mq.o
 obj-$(CONFIG_DM_CACHE_CLEANER)	+= dm-cache-cleaner.o
 obj-$(CONFIG_DM_CACHE_ERA)	+= dm-cache-era.o
+obj-$(CONFIG_DM_CACHE_TRC)	+= dm-cache-trc.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
diff --git a/drivers/md/dm-cache-policy-trc.c b/drivers/md/dm-cache-policy-trc.c
new file mode 100644
index 0000000..8b16061
--- /dev/null
+++ b/drivers/md/dm-cache-policy-trc.c
@@ -0,0 +1,255 @@
+/*
+ * Copyright 2013 NetApp, Inc. All Rights Reserved, contribution by
+ * Morgan Mears.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Gentrcl Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Gentrcl Public License
+ * for more details
+ *
+ */
+
+/* FIXME: use from_[oc]block() */
+
+#include "dm-cache-policy.h"
+#include "dm-cache-policy-internal.h"
+#include "dm-cache-shim-utils.h"
+#include "dm.h"
+
+#include <linux/module.h>
+
+#define DM_MSG_PREFIX "cache-policy-trc"
+#define DM_TRC_OUT(lev, p, f, arg...) \
+	do { \
+		if (to_trc_policy(p)->trace_level >= lev) \
+			DMINFO("%s: " f, __func__, ## arg); \
+	} while (0)
+
+enum dm_trace_lev_e {
+	DM_TRC_LEV_OFF		= 0,
+	DM_TRC_LEV_NORMAL	= 1,
+	DM_TRC_LEV_VERBOSE	= 2
+};
+
+struct trc_policy {
+	struct dm_cache_policy policy;
+	int trace_level;
+};
+
+/*----------------------------------------------------------------*/
+
+static struct trc_policy *to_trc_policy(struct dm_cache_policy *p)
+{
+	return container_of(p, struct trc_policy, policy);
+}
+
+static int set_trace_level(struct dm_cache_policy *p, const char *str)
+{
+	uint32_t val;
+
+	if (kstrtou32(str, 10, &val))
+		return -EINVAL;
+	to_trc_policy(p)->trace_level = val;
+	return 0;
+}
+
+/*
+ * Public interface, via the policy struct.  See dm-cache-policy.h for a
+ * description of these.
+ */
+
+static void trc_destroy(struct dm_cache_policy *p)
+{
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p", p);
+	kfree(p);
+}
+
+static int trc_map(struct dm_cache_policy *p, dm_oblock_t oblock,
+		   bool can_block, bool can_migrate, bool discarded_oblock,
+		   struct bio *bio, struct policy_result *result)
+{
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %llu %u %u %u %p %p", p,
+		   oblock, can_block, can_migrate, discarded_oblock,
+		   bio, result);
+	return policy_map(p->child, oblock, can_block, can_migrate,
+			  discarded_oblock, bio, result);
+}
+
+static int trc_lookup(struct dm_cache_policy *p, dm_oblock_t oblock,
+		      dm_cblock_t *cblock)
+{
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %llu %p", p, oblock, cblock);
+	return policy_lookup(p->child, oblock, cblock);
+}
+
+static void trc_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %llu", p, oblock);
+	policy_set_dirty(p->child, oblock);
+}
+
+static void trc_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %llu", p, oblock);
+	policy_clear_dirty(p->child, oblock);
+}
+
+static int trc_load_mapping(struct dm_cache_policy *p,
+			    dm_oblock_t oblock, dm_cblock_t cblock,
+			    void *hint, bool hint_valid)
+{
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %llu %u %p %u", p, oblock,
+		   cblock, hint, hint_valid);
+	return policy_load_mapping(p->child, oblock, cblock, hint, hint_valid);
+}
+
+static int trc_walk_mappings(struct dm_cache_policy *p, policy_walk_fn fn,
+			     void *context)
+{
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %p %p", p, fn, context);
+	return dm_cache_shim_utils_walk_map(p, fn, context, NULL);
+}
+
+static void trc_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %llu", p, oblock);
+	policy_remove_mapping(p->child, oblock);
+}
+
+static int trc_writeback_work(struct dm_cache_policy *p, dm_oblock_t *oblock,
+			      dm_cblock_t *cblock)
+{
+	DM_TRC_OUT(DM_TRC_LEV_VERBOSE, p, "%p %p %p", p, oblock, cblock);
+	return policy_writeback_work(p->child, oblock, cblock);
+}
+
+static void trc_force_mapping(struct dm_cache_policy *p,
+			       dm_oblock_t old_oblock,
+			       dm_oblock_t new_oblock)
+{
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %llu %llu",
+		   p, old_oblock, new_oblock);
+	policy_force_mapping(p->child, old_oblock, new_oblock);
+}
+
+static dm_cblock_t trc_residency(struct dm_cache_policy *p)
+{
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p", p);
+	return policy_residency(p->child);
+}
+
+static void trc_tick(struct dm_cache_policy *p)
+{
+	DM_TRC_OUT(DM_TRC_LEV_VERBOSE, p, "%p", p);
+	policy_tick(p->child);
+}
+
+static int trc_set_config_value(struct dm_cache_policy *p,
+				const char *key,
+				const char *value)
+{
+	int r;
+
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %s %s", p, key, value);
+
+	if (!strcasecmp(key, "set_trace_level"))
+		r = set_trace_level(p, value);
+	else
+		r = policy_set_config_value(p->child, key, value);
+
+	return r;
+}
+
+static int trc_emit_config_values(struct dm_cache_policy *p, char *result,
+				  unsigned maxlen)
+{
+	struct trc_policy *trc = to_trc_policy(p);
+	ssize_t sz = 0;
+
+	DM_TRC_OUT(DM_TRC_LEV_NORMAL, p, "%p %p %u", p, result, maxlen);
+
+	DMEMIT("trace_level %u ", trc->trace_level);
+	return policy_emit_config_values(p->child, result + sz, maxlen - sz);
+}
+
+/* Init the policy plugin interface function pointers. */
+static void init_policy_functions(struct trc_policy *trc)
+{
+	dm_cache_shim_utils_init_shim_policy(&trc->policy);
+	trc->policy.destroy = trc_destroy;
+	trc->policy.map = trc_map;
+	trc->policy.lookup = trc_lookup;
+	trc->policy.set_dirty = trc_set_dirty;
+	trc->policy.clear_dirty = trc_clear_dirty;
+	trc->policy.load_mapping = trc_load_mapping;
+	trc->policy.walk_mappings = trc_walk_mappings;
+	trc->policy.remove_mapping = trc_remove_mapping;
+	trc->policy.writeback_work = trc_writeback_work;
+	trc->policy.force_mapping = trc_force_mapping;
+	trc->policy.residency = trc_residency;
+	trc->policy.tick = trc_tick;
+	trc->policy.emit_config_values = trc_emit_config_values;
+	trc->policy.set_config_value = trc_set_config_value;
+}
+
+static struct dm_cache_policy *trc_create(dm_cblock_t cache_size,
+					  sector_t origin_size,
+					  sector_t cache_block_size)
+{
+	struct trc_policy *trc = kzalloc(sizeof(*trc), GFP_KERNEL);
+
+	if (!trc)
+		return NULL;
+
+	init_policy_functions(trc);
+	trc->trace_level = DM_TRC_LEV_NORMAL;
+
+	return &trc->policy;
+}
+
+/*----------------------------------------------------------------*/
+
+static struct dm_cache_policy_type trc_policy_type = {
+	.name = "trc",
+	.version = {1, 0, 0},
+	.hint_size = 0,
+	.owner = THIS_MODULE,
+	.create = trc_create,
+	.features = DM_CACHE_POLICY_SHIM
+};
+
+static int __init trc_init(void)
+{
+	int r;
+
+	r = dm_cache_policy_register(&trc_policy_type);
+	if (!r) {
+		DMINFO("version %u.%u.%u loaded",
+		       trc_policy_type.version[0],
+		       trc_policy_type.version[1],
+		       trc_policy_type.version[2]);
+		return 0;
+	}
+
+	DMERR("register failed %d", r);
+
+	dm_cache_policy_unregister(&trc_policy_type);
+	return -ENOMEM;
+}
+
+static void __exit trc_exit(void)
+{
+	dm_cache_policy_unregister(&trc_policy_type);
+}
+
+module_init(trc_init);
+module_exit(trc_exit);
+
+MODULE_AUTHOR("Morgan Mears <dm-devel@redhat.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("trc cache policy shim");
-- 
1.8.1.4
