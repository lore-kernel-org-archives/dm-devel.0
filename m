From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 19/24] dm cache: support for stackable caching
	policies
Date: Thu, 24 Oct 2013 14:30:32 -0400
Message-ID: <1382639437-27007-20-git-send-email-snitzer@redhat.com>
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

This commit implements support for stacking caching policies by
concatenating policy names.

A policy stack includes zero or more non-terminal policies, or shims,
followed by exactly one terminal policy which actually maintains the
cache-to-origin block mappings.

Non-terminal policy shims will be added in later patches.  Each policy
shim must set the DM_CACHE_POLICY_SHIM feature flag in the "features"
member of the dm_cache_policy_type structure.

Signed-off-by: Morgan Mears <morgan.mears@netapp.com>
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/Makefile                   |   3 +-
 drivers/md/dm-cache-policy-internal.h |   6 +
 drivers/md/dm-cache-policy.c          |  47 ++++++-
 drivers/md/dm-cache-policy.h          |  17 +++
 drivers/md/dm-cache-shim-utils.c      | 210 +++++++++++++++++++++++++++++
 drivers/md/dm-cache-shim-utils.h      |  73 +++++++++++
 drivers/md/dm-cache-stack-utils.c     | 239 ++++++++++++++++++++++++++++++++++
 drivers/md/dm-cache-stack-utils.h     |  34 +++++
 8 files changed, 626 insertions(+), 3 deletions(-)
 create mode 100644 drivers/md/dm-cache-shim-utils.c
 create mode 100644 drivers/md/dm-cache-shim-utils.h
 create mode 100644 drivers/md/dm-cache-stack-utils.c
 create mode 100644 drivers/md/dm-cache-stack-utils.h

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 2acc43f..5f6dfc3 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -11,7 +11,8 @@ dm-mirror-y	+= dm-raid1.o
 dm-log-userspace-y \
 		+= dm-log-userspace-base.o dm-log-userspace-transfer.o
 dm-thin-pool-y	+= dm-thin.o dm-thin-metadata.o
-dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o
+dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o \
+		   dm-cache-shim-utils.o dm-cache-stack-utils.o
 dm-cache-mq-y   += dm-cache-policy-mq.o
 dm-cache-cleaner-y += dm-cache-policy-cleaner.o
 md-mod-y	+= md.o bitmap.o
diff --git a/drivers/md/dm-cache-policy-internal.h b/drivers/md/dm-cache-policy-internal.h
index 9b1473b..996b2b5 100644
--- a/drivers/md/dm-cache-policy-internal.h
+++ b/drivers/md/dm-cache-policy-internal.h
@@ -124,6 +124,12 @@ const unsigned *dm_cache_policy_get_version(struct dm_cache_policy *p);
 int    dm_cache_policy_set_hint_size(struct dm_cache_policy *p, unsigned hint_size);
 size_t dm_cache_policy_get_hint_size(struct dm_cache_policy *p);
 
+/*
+ * Return bool that reflects whether or not policy is only a shim
+ * layer in a policy stack.
+ */
+bool dm_cache_policy_is_shim(struct dm_cache_policy *p);
+
 /*----------------------------------------------------------------*/
 
 #endif /* DM_CACHE_POLICY_INTERNAL_H */
diff --git a/drivers/md/dm-cache-policy.c b/drivers/md/dm-cache-policy.c
index 8e84d08..f2d8d33 100644
--- a/drivers/md/dm-cache-policy.c
+++ b/drivers/md/dm-cache-policy.c
@@ -5,6 +5,7 @@
  */
 
 #include "dm-cache-policy-internal.h"
+#include "dm-cache-stack-utils.h"
 #include "dm.h"
 
 #include <linux/module.h>
@@ -54,6 +55,9 @@ static struct dm_cache_policy_type *get_policy_once(const char *name)
 static struct dm_cache_policy_type *get_policy(const char *name)
 {
 	struct dm_cache_policy_type *t;
+	char name_wo_delim[CACHE_POLICY_NAME_SIZE];
+	char *p_delim;
+	int n;
 
 	t = get_policy_once(name);
 	if (IS_ERR(t))
@@ -68,6 +72,28 @@ static struct dm_cache_policy_type *get_policy(const char *name)
 	if (IS_ERR(t))
 		return NULL;
 
+	if (t)
+		return t;
+
+	/*
+	 * We also need to check for dm-cache-<@name> with no trailing
+	 * DM_CACHE_POLICY_STACK_DELIM if @name has one, in order to
+	 * support loadable policy shims.
+	 */
+	n = strlcpy(name_wo_delim, name, sizeof(name_wo_delim));
+	if (n >= sizeof(name_wo_delim))
+		return NULL;
+	p_delim = strchr(name_wo_delim, DM_CACHE_POLICY_STACK_DELIM);
+	if (!p_delim || (p_delim[1] != '\0'))
+		return NULL;
+	p_delim[0] = '\0';
+
+	request_module("dm-cache-%s", name_wo_delim);
+
+	t = get_policy_once(name);
+	if (IS_ERR(t))
+		return NULL;
+
 	return t;
 }
 
@@ -117,6 +143,11 @@ struct dm_cache_policy *dm_cache_policy_create(const char *name,
 	struct dm_cache_policy *p = NULL;
 	struct dm_cache_policy_type *type;
 
+	if (dm_cache_stack_utils_string_is_policy_stack(name))
+		return dm_cache_stack_utils_policy_stack_create(name, cache_size,
+								origin_size,
+								cache_block_size);
+
 	type = get_policy(name);
 	if (!type) {
 		DMWARN("unknown policy type");
@@ -138,8 +169,12 @@ void dm_cache_policy_destroy(struct dm_cache_policy *p)
 {
 	struct dm_cache_policy_type *t = p->private;
 
-	p->destroy(p);
-	put_policy(t);
+	if (dm_cache_stack_utils_string_is_policy_stack(t->name))
+		dm_cache_stack_utils_policy_stack_destroy(p);
+	else {
+		p->destroy(p);
+		put_policy(t);
+	}
 }
 EXPORT_SYMBOL_GPL(dm_cache_policy_destroy);
 
@@ -179,4 +214,12 @@ int dm_cache_policy_set_hint_size(struct dm_cache_policy *p, unsigned hint_size)
 }
 EXPORT_SYMBOL_GPL(dm_cache_policy_set_hint_size);
 
+bool dm_cache_policy_is_shim(struct dm_cache_policy *p)
+{
+	struct dm_cache_policy_type *t = p->private;
+
+	return (t->features & DM_CACHE_POLICY_SHIM) ? true : false;
+}
+EXPORT_SYMBOL_GPL(dm_cache_policy_is_shim);
+
 /*----------------------------------------------------------------*/
diff --git a/drivers/md/dm-cache-policy.h b/drivers/md/dm-cache-policy.h
index 6779ea7..83ec775 100644
--- a/drivers/md/dm-cache-policy.h
+++ b/drivers/md/dm-cache-policy.h
@@ -190,11 +190,26 @@ struct dm_cache_policy {
 	 * Book keeping ptr for the policy register, not for general use.
 	 */
 	void *private;
+
+	/*
+	 * Support for stackable policies. A policy stack consists of 0 or more
+	 * "non-terminal" policies (which can intercept requests to provide
+	 * additional functionality, but ultimately hand them down the stack)
+	 * followed by one "terminal" policy which actually runs a caching
+	 * algorithm.  This is the pointer to the "next" policy in a
+	 * non-terminal policy.  It will always be NULL in a terminal policy.
+	 */
+	struct dm_cache_policy *child;
 };
 
 /*----------------------------------------------------------------*/
 
 /*
+ * Indicates that a policy is only a shim layer in a policy stack.
+ */
+#define	DM_CACHE_POLICY_SHIM	 (1 << 0)
+
+/*
  * We maintain a little register of the different policy types.
  */
 #define CACHE_POLICY_NAME_SIZE 16
@@ -222,6 +237,8 @@ struct dm_cache_policy_type {
 	struct dm_cache_policy *(*create)(dm_cblock_t cache_size,
 					  sector_t origin_size,
 					  sector_t block_size);
+
+	unsigned long features;
 };
 
 int dm_cache_policy_register(struct dm_cache_policy_type *type);
diff --git a/drivers/md/dm-cache-shim-utils.c b/drivers/md/dm-cache-shim-utils.c
new file mode 100644
index 0000000..4151883
--- /dev/null
+++ b/drivers/md/dm-cache-shim-utils.c
@@ -0,0 +1,210 @@
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
+#include <linux/module.h>
+
+#define DM_MSG_PREFIX "cache-shim-utils"
+
+/*----------------------------------------------------------------*/
+
+static int shim_nested_walk_apply(void *context, dm_cblock_t cblock,
+				  dm_oblock_t oblock, void *hint)
+{
+	struct shim_walk_map_ctx *ctx = context;
+	struct dm_cache_policy *p;
+	int child_hint_size;
+	void *my_hint;
+
+	/* Save off our child's hint */
+	if (ctx->child_hint_buf) {
+		p = ctx->my_policy;
+		child_hint_size = dm_cache_policy_get_hint_size(p->child);
+		if (child_hint_size && hint)
+			memcpy(&ctx->child_hint_buf[0], hint, child_hint_size);
+	}
+
+	/* Provide my hint or NULL up the stack */
+	my_hint = ctx->cblock_to_hint_fn ?
+		ctx->cblock_to_hint_fn(ctx, cblock, oblock) : NULL;
+
+	/* Reverse recurse, unless short-circuted */
+	return (ctx->parent_fn) ?
+		(*ctx->parent_fn)(ctx->parent_ctx, cblock, oblock, my_hint) : 0;
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Public interface, via the policy struct.  See dm-cache-policy.h for a
+ * description of these.
+ */
+
+static void shim_destroy(struct dm_cache_policy *p)
+{
+	kfree(p);
+}
+
+static int shim_map(struct dm_cache_policy *p, dm_oblock_t oblock,
+		    bool can_block, bool can_migrate, bool discarded_oblock,
+		    struct bio *bio, struct policy_result *result)
+{
+	return policy_map(p->child, oblock, can_block, can_migrate,
+			  discarded_oblock, bio, result);
+}
+
+static int shim_lookup(struct dm_cache_policy *p, dm_oblock_t oblock,
+		       dm_cblock_t *cblock)
+{
+	return policy_lookup(p->child, oblock, cblock);
+}
+
+static void shim_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	policy_set_dirty(p->child, oblock);
+}
+
+static void shim_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	policy_clear_dirty(p->child, oblock);
+}
+
+static int shim_load_mapping(struct dm_cache_policy *p,
+			     dm_oblock_t oblock, dm_cblock_t cblock,
+			     void *hint, bool hint_valid)
+{
+	return policy_load_mapping(p->child, oblock, cblock, hint, hint_valid);
+}
+
+static int shim_walk_mappings(struct dm_cache_policy *p, policy_walk_fn fn,
+			      void *context)
+{
+	struct shim_walk_map_ctx my_ctx, *parent_ctx;
+	int my_hint_size;
+
+	parent_ctx = (struct shim_walk_map_ctx *)context;
+	my_hint_size = dm_cache_policy_get_hint_size(p);
+
+	my_ctx.parent_ctx = parent_ctx;
+	my_ctx.parent_fn = fn;
+	my_ctx.my_policy = p;
+	my_ctx.child_hint_buf = (parent_ctx->child_hint_buf) ?
+		&parent_ctx->child_hint_buf[my_hint_size] : NULL;
+	my_ctx.cblock_to_hint_fn = NULL;
+
+	return policy_walk_mappings(p->child, shim_nested_walk_apply, &my_ctx);
+}
+
+static void shim_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	policy_remove_mapping(p->child, oblock);
+}
+
+static int shim_writeback_work(struct dm_cache_policy *p, dm_oblock_t *oblock,
+			       dm_cblock_t *cblock)
+{
+	return policy_writeback_work(p->child, oblock, cblock);
+}
+
+static void shim_force_mapping(struct dm_cache_policy *p,
+			       dm_oblock_t current_oblock,
+			       dm_oblock_t new_oblock)
+{
+	policy_force_mapping(p->child, current_oblock, new_oblock);
+}
+
+static dm_cblock_t shim_residency(struct dm_cache_policy *p)
+{
+	return policy_residency(p->child);
+}
+
+static void shim_tick(struct dm_cache_policy *p)
+{
+	policy_tick(p->child);
+}
+
+static int shim_set_config_value(struct dm_cache_policy *p,
+				 const char *key, const char *value)
+{
+	return policy_set_config_value(p->child, key, value);
+}
+
+static int shim_emit_config_values(struct dm_cache_policy *p, char *result,
+				   unsigned maxlen)
+{
+	return policy_emit_config_values(p->child, result, maxlen);
+}
+
+void dm_cache_shim_utils_init_shim_policy(struct dm_cache_policy *p)
+{
+	p->destroy = shim_destroy;
+	p->map = shim_map;
+	p->lookup = shim_lookup;
+	p->set_dirty = shim_set_dirty;
+	p->clear_dirty = shim_clear_dirty;
+	p->load_mapping = shim_load_mapping;
+	p->walk_mappings = shim_walk_mappings;
+	p->remove_mapping = shim_remove_mapping;
+	p->writeback_work = shim_writeback_work;
+	p->force_mapping = shim_force_mapping;
+	p->residency = shim_residency;
+	p->tick = shim_tick;
+	p->emit_config_values = shim_emit_config_values;
+	p->set_config_value = shim_set_config_value;
+}
+EXPORT_SYMBOL_GPL(dm_cache_shim_utils_init_shim_policy);
+
+int dm_cache_shim_utils_walk_map_with_ctx(struct shim_walk_map_ctx *ctx)
+{
+	struct dm_cache_policy *p = ctx->my_policy;
+
+	/*
+	 * Used by the stack root policy in its walk_mappings implementation,
+	 * to provide the top-level context that contains the buffer used to
+	 * consolidate hint data from all of the shims and the terminal policy.
+	 */
+	return policy_walk_mappings(p->child, shim_nested_walk_apply, ctx);
+}
+EXPORT_SYMBOL_GPL(dm_cache_shim_utils_walk_map_with_ctx);
+
+int dm_cache_shim_utils_walk_map(struct dm_cache_policy *p, policy_walk_fn fn,
+				 void *context, cblock_to_hint_fn_t hint_fn)
+{
+	struct shim_walk_map_ctx my_ctx, *parent_ctx;
+	int my_hint_size;
+
+	/*
+	 * Used by shim policies for their walk_mappings implementations.
+	 * Handles packing up the hint data, in conjunction with
+	 * shim_nested_walk_apply.
+	 */
+	parent_ctx = (struct shim_walk_map_ctx *)context;
+	my_hint_size = dm_cache_policy_get_hint_size(p);
+
+	my_ctx.parent_ctx = parent_ctx;
+	my_ctx.parent_fn = fn;
+	my_ctx.my_policy = p;
+	my_ctx.child_hint_buf = (parent_ctx && parent_ctx->child_hint_buf) ?
+		&parent_ctx->child_hint_buf[my_hint_size] : NULL;
+	my_ctx.cblock_to_hint_fn = hint_fn;
+
+	return policy_walk_mappings(p->child, shim_nested_walk_apply, &my_ctx);
+}
+EXPORT_SYMBOL_GPL(dm_cache_shim_utils_walk_map);
diff --git a/drivers/md/dm-cache-shim-utils.h b/drivers/md/dm-cache-shim-utils.h
new file mode 100644
index 0000000..92f2f21
--- /dev/null
+++ b/drivers/md/dm-cache-shim-utils.h
@@ -0,0 +1,73 @@
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
+#ifndef DM_CACHE_SHIM_UTILS_H
+#define DM_CACHE_SHIM_UTILS_H
+
+#include "dm-cache-policy.h"
+
+struct shim_walk_map_ctx;
+
+typedef void* (*cblock_to_hint_fn_t)(struct shim_walk_map_ctx *,
+				     dm_cblock_t,
+				     dm_oblock_t);
+
+/*
+ * For walk_mappings to work with a policy stack, every non-terminal policy
+ * has to start its context with one of these.  There are no requirements for
+ * the context used by the terminal policy.
+ */
+struct shim_walk_map_ctx {
+	void *parent_ctx;
+	policy_walk_fn parent_fn;
+	struct dm_cache_policy *my_policy;
+	char *child_hint_buf;
+	cblock_to_hint_fn_t cblock_to_hint_fn;
+	union {
+		__le64 le64_buf;
+		__le32 le32_buf;
+		__le16 le16_buf;
+	};
+};
+
+/*
+ * Populate a shim (non-terminal) policy structure with functions that just
+ * hand off to the child policy.  Caller can then override just those
+ * functions of interest.
+ */
+void dm_cache_shim_utils_init_shim_policy(struct dm_cache_policy *p);
+
+/*
+ * Launch a "walk_mappings" leg using the context provided by our caller.
+ * Typically used at the bottom of a policy stack, so caller can provide
+ * the hint buffer.
+ */
+int dm_cache_shim_utils_walk_map_with_ctx(struct shim_walk_map_ctx *ctx);
+
+/*
+ * Initialize a context appropriately and Launch a "walk_mappings" leg.
+ * Typically used to implement walk_mappings in shim policies. The
+ * framework will call hint_fn at the appropriate point, and it should
+ * return a pointer to the disk-ready hint for the given cblock.  The
+ * leXX_bufs in the shim_walk_map_ctx structure can be used to store the
+ * disk-ready hint if it will fit.
+ */
+int dm_cache_shim_utils_walk_map(struct dm_cache_policy *p,
+				 policy_walk_fn fn,
+				 void *context,
+				 cblock_to_hint_fn_t hint_fn);
+
+#endif /* DM_CACHE_SHIM_UTILS_H */
diff --git a/drivers/md/dm-cache-stack-utils.c b/drivers/md/dm-cache-stack-utils.c
new file mode 100644
index 0000000..82cc3af
--- /dev/null
+++ b/drivers/md/dm-cache-stack-utils.c
@@ -0,0 +1,239 @@
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
+#include "dm-cache-policy-internal.h"
+#include "dm-cache-shim-utils.h"
+#include "dm-cache-stack-utils.h"
+#include "dm-cache-policy.h"
+#include "dm.h"
+
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#define DM_MSG_PREFIX "cache-stack-utils"
+
+struct stack_root_policy {
+	struct dm_cache_policy policy;
+	struct dm_cache_policy_type type;
+};
+
+/*----------------------------------------------------------------*/
+
+static void *stack_root_cblock_to_hint(struct shim_walk_map_ctx *ctx,
+				       dm_cblock_t cblock, dm_oblock_t oblock)
+{
+	return ctx->child_hint_buf;
+}
+
+static int stack_root_walk_mappings(struct dm_cache_policy *p,
+				    policy_walk_fn fn, void *context)
+{
+	struct shim_walk_map_ctx ctx;
+	size_t hint_size;
+	int r;
+
+	ctx.parent_ctx = context;
+	ctx.parent_fn = fn;
+	ctx.my_policy = p;
+	ctx.child_hint_buf = NULL;
+	ctx.cblock_to_hint_fn = stack_root_cblock_to_hint;
+
+	hint_size = dm_cache_policy_get_hint_size(p);
+	if (hint_size) {
+		ctx.child_hint_buf = kzalloc(hint_size, GFP_KERNEL);
+		if (!ctx.child_hint_buf)
+			return -ENOMEM;
+	}
+
+	r = dm_cache_shim_utils_walk_map_with_ctx(&ctx);
+
+	kfree(ctx.child_hint_buf);
+
+	return r;
+}
+
+static struct dm_cache_policy *stack_root_create(const char *policy_stack_str,
+						 struct dm_cache_policy *head)
+{
+	struct stack_root_policy *p = kzalloc(sizeof(*p), GFP_KERNEL);
+	struct dm_cache_policy *child;
+	struct dm_cache_policy_type *t;
+	const unsigned *version;
+	const char *seg_name;
+	size_t canonical_name_len, hint_size;
+	int i;
+
+	if (!p)
+		return NULL;
+
+	t = &p->type;
+	dm_cache_shim_utils_init_shim_policy(&p->policy);
+	p->policy.walk_mappings = stack_root_walk_mappings;
+	p->policy.child = head;
+
+	/*
+	 * We compose the canonical name for this policy stack by removing
+	 * any shim policies that do not have hint data.  This is intended
+	 * to allow for a class of shim policies that can be inserted into,
+	 * or removed from, the policy stack without causing the in-flash
+	 * metadata to be invalidated.  The thought is to allow debug or
+	 * tracing shims to be inserted or removed without dropping the cache.
+	 * The composite version numbers of a policy stack do not include the
+	 * versions of the hintless policies for the same reason.
+	 */
+	canonical_name_len = 0;
+	for (child = head; child; child = child->child) {
+		hint_size = dm_cache_policy_get_hint_size(child);
+
+#if 0
+		/* FIXME: avoids policy name in t->name, thus leaving an non-destroyable stack. */
+		if (!hint_size && child->child)
+			continue;
+#endif
+
+		t->hint_size += hint_size;
+
+		seg_name = dm_cache_policy_get_name(child);
+		canonical_name_len += strlen(seg_name) + (dm_cache_policy_is_shim(child) ? 1 : 0);
+
+		if (canonical_name_len >= sizeof(t->name)) {
+			DMWARN("policy stack string '%s' is too long",
+			       policy_stack_str);
+			kfree(p);
+			return NULL;
+		}
+
+		strcat(t->name, seg_name);
+
+		if (dm_cache_policy_is_shim(child)) {
+			t->name[canonical_name_len - 1] = DM_CACHE_POLICY_STACK_DELIM;
+			t->name[canonical_name_len] = '\0';
+		}
+
+		version = dm_cache_policy_get_version(child);
+
+		for (i = 0; i < CACHE_POLICY_VERSION_SIZE; i++)
+			t->version[i] += version[i];
+	}
+
+	p->policy.private = t;
+	return &p->policy;
+}
+
+static void stack_root_destroy(struct dm_cache_policy *p)
+{
+	kfree(p);
+}
+
+/*----------------------------------------------------------------*/
+
+int dm_cache_stack_utils_string_is_policy_stack(const char *string)
+{
+	const char *delim;
+
+	/*
+	 * A string specifies a policy stack instead of a policy if it
+	 * contains a policy delimiter (+) anywhere but at the end.  The
+	 * latter is needed to properly distinguish between policy stacks and
+	 * individual shim policies, since this function is called on them
+	 * when the policy stack is constructed from the specified string.
+	 */
+	delim = strchr(string, DM_CACHE_POLICY_STACK_DELIM);
+	if (!delim || (delim[1] == '\0'))
+		return false;
+
+	return true;
+}
+
+static void __policy_destroy_stack(struct dm_cache_policy *head_p)
+{
+	struct dm_cache_policy *cur_p, *next_p;
+
+	for (cur_p = head_p; cur_p; cur_p = next_p) {
+		next_p = cur_p->child;
+		dm_cache_policy_destroy(cur_p);
+	}
+}
+
+struct dm_cache_policy *
+dm_cache_stack_utils_policy_stack_create(const char *policy_stack_str,
+					 dm_cblock_t cache_size,
+					 sector_t origin_size,
+					 sector_t cache_block_size)
+{
+	char policy_name_buf[CACHE_POLICY_NAME_SIZE];
+	struct dm_cache_policy *p, *head_p, *next_p;
+	char *policy_name, *delim, uninitialized_var(saved_char);
+	int n;
+
+	n = strlcpy(policy_name_buf, policy_stack_str, sizeof(policy_name_buf));
+	if (n >= sizeof(policy_name_buf)) {
+		DMWARN("policy stack string is too long");
+		return NULL;
+	}
+
+	policy_name = policy_name_buf;
+	p = head_p = next_p = NULL;
+
+	do {
+		delim = strchr(policy_name, DM_CACHE_POLICY_STACK_DELIM);
+		if (delim)
+			*delim = '\0';
+
+		next_p = dm_cache_policy_create(policy_name, cache_size,
+						origin_size, cache_block_size);
+		if (!next_p)
+			goto cleanup;
+
+		next_p->child = NULL;
+		if (p)
+			p->child = next_p;
+		else
+			head_p = next_p;
+		p = next_p;
+
+		if (delim) {
+			if (!dm_cache_policy_is_shim(next_p)) {
+				DMERR("%s is no shim policy", policy_name);
+				goto cleanup;
+			}
+
+			*delim = DM_CACHE_POLICY_STACK_DELIM;
+			policy_name = delim + 1;
+		}
+	} while (delim);
+
+	if (head_p->child) {
+		next_p = stack_root_create(policy_stack_str, head_p);
+		if (!next_p)
+			goto cleanup;
+
+		head_p = next_p;
+	}
+
+	return head_p;
+
+cleanup:
+	__policy_destroy_stack(head_p);
+	return NULL;
+}
+
+void dm_cache_stack_utils_policy_stack_destroy(struct dm_cache_policy *p)
+{
+	__policy_destroy_stack(p->child);
+	stack_root_destroy(p);
+}
diff --git a/drivers/md/dm-cache-stack-utils.h b/drivers/md/dm-cache-stack-utils.h
new file mode 100644
index 0000000..54c767e
--- /dev/null
+++ b/drivers/md/dm-cache-stack-utils.h
@@ -0,0 +1,34 @@
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
+#ifndef DM_CACHE_STACK_UTILS_H
+#define DM_CACHE_STACK_UTILS_H
+
+#include "dm-cache-policy.h"
+
+#define DM_CACHE_POLICY_STACK_DELIM '+'
+
+int dm_cache_stack_utils_string_is_policy_stack(const char *string);
+
+struct dm_cache_policy *dm_cache_stack_utils_policy_stack_create(
+				const char *policy_stack_string,
+				dm_cblock_t cache_size,
+				sector_t origin_size,
+				sector_t cache_block_size);
+
+void dm_cache_stack_utils_policy_stack_destroy(struct dm_cache_policy *p);
+
+#endif /* DM_CACHE_STACK_UTILS_H */
-- 
1.8.1.4
