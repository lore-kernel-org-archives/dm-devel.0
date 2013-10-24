From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 24/24] dm cache policy era: add cache block
	invalidation support
Date: Thu, 24 Oct 2013 14:30:37 -0400
Message-ID: <1382639437-27007-25-git-send-email-snitzer@redhat.com>
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

This commit adds support for the cache block invalidation API to the
"era" policy shim.

It provides:
- a temporary store containing selected cache blocks filtered based on a
  message requesting eras equal to, less than, less equal, greater than
  or greater equal to an era number
- provisioning of the entries, to be invalidated in that temporary
  store, to the cache core target

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-policy-era.c | 194 +++++++++++++++++++++++++++++++--------
 1 file changed, 154 insertions(+), 40 deletions(-)

diff --git a/drivers/md/dm-cache-policy-era.c b/drivers/md/dm-cache-policy-era.c
index 427514c..486717a 100644
--- a/drivers/md/dm-cache-policy-era.c
+++ b/drivers/md/dm-cache-policy-era.c
@@ -2,6 +2,8 @@
  * Copyright 2013 NetApp, Inc. All Rights Reserved, contribution by
  * Morgan Mears.
  *
+ * Copyright 2013 Red Hat, Inc. All Rights Reserved.
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2 of the License, or (at your
@@ -44,6 +46,13 @@ struct era_policy {
 	era_t *cb_to_era;
 
 	era_t era_counter;
+
+	/* Temporary store for unmap information during invalidation. */
+	struct {
+		unsigned long *bitset;
+		dm_oblock_t *oblocks;
+		unsigned long last_cblock;
+	} invalidate;
 };
 
 /*----------------------------------------------------------------*/
@@ -53,7 +62,69 @@ static struct era_policy *to_era_policy(struct dm_cache_policy *p)
 	return container_of(p, struct era_policy, policy);
 }
 
-static int incr_era_counter(struct era_policy *era, const char *curr_era_str)
+static unsigned long *alloc_bitset(unsigned nr_entries)
+{
+	size_t s = sizeof(unsigned long) * dm_div_up(nr_entries, BITS_PER_LONG);
+	return vzalloc(s);
+}
+
+static void free_bitset(unsigned long *bits)
+{
+	vfree(bits);
+}
+
+static dm_oblock_t *alloc_oblocks(unsigned nr_entries)
+{
+	size_t s = sizeof(dm_oblock_t) * nr_entries;
+	return vmalloc(s);
+}
+
+static void free_oblocks(dm_oblock_t *blocks)
+{
+	vfree(blocks);
+}
+
+static void free_invalidate(struct era_policy *era)
+{
+	if (era->invalidate.oblocks) {
+		free_oblocks(era->invalidate.oblocks);
+		era->invalidate.oblocks = NULL;
+	}
+
+	if (era->invalidate.bitset) {
+		free_bitset(era->invalidate.bitset);
+		era->invalidate.bitset = NULL; /* Being checked for! */
+	}
+}
+
+static int alloc_invalidate(struct era_policy *era)
+{
+	/* FIXME: memory consumption! */
+	era->invalidate.oblocks = alloc_oblocks(from_cblock(era->cache_size));
+	if (!era->invalidate.oblocks) {
+		DMERR("failed to allocate original blocks unmap array");
+		goto err;
+	}
+
+	era->invalidate.bitset = alloc_bitset(from_cblock(era->cache_size));
+	if (!era->invalidate.bitset) {
+		DMERR("failed to allocate cache blocks unmap bitset");
+		goto err;
+	}
+
+	era->invalidate.last_cblock = 0;
+	return 0;
+
+err:
+	free_invalidate(era);
+	return -ENOMEM;
+}
+
+
+typedef int (*era_match_fn_t)(era_t, era_t);
+
+static int incr_era_counter(struct era_policy *era, const char *curr_era_str,
+			    era_match_fn_t dummy)
 {
 	era_t curr_era_counter;
 	int r;
@@ -119,8 +190,6 @@ static int era_is_lt_value(era_t era, era_t value)
 	return era < value;
 }
 
-typedef int (*era_match_fn_t)(era_t, era_t);
-
 struct inval_oblocks_ctx {
 	struct era_policy *era;
 	era_match_fn_t era_match_fn;
@@ -131,26 +200,16 @@ static int era_inval_oblocks(void *context, dm_cblock_t cblock,
 			     dm_oblock_t oblock, void *unused)
 {
 	struct inval_oblocks_ctx *ctx = (struct inval_oblocks_ctx *)context;
-	struct dm_cache_policy *child;
-	era_t act_era;
+	era_t act_era = ctx->era->cb_to_era[from_cblock(cblock)];
 
-	act_era = ctx->era->cb_to_era[from_cblock(cblock)];
 	if (ctx->era_match_fn(act_era, ctx->test_era)) {
 #if DEBUG_ERA
 		DMDEBUG("cblock %u has era %u matching test_era %u; "
 			"marking mapping to be removed for oblock %llu.",
 			from_cblock(cblock), act_era, ctx->test_era, oblock);
 #endif
-		child = ctx->era->policy.child;
-
-		/*
-		 * This deadlocks (lock against self) because child is calling
-		 * us via the walk_mappings context callback, child's
-		 * walk_mappings holds child's lock, and child's remove_mappings
-		 * tries to get it again.  Not fixing because I believe the
-		 * invalidate API is going to change.
-		 */
-		/* child->remove_mapping(child, oblock); */
+		set_bit(from_cblock(cblock), ctx->era->invalidate.bitset);
+		ctx->era->invalidate.oblocks[from_cblock(cblock)] = oblock;
 	}
 
 	return 0;
@@ -164,6 +223,11 @@ static int cond_unmap_by_era(struct era_policy *era, const char *test_era_str,
 	era_t test_era;
 	int r;
 
+	if (era->invalidate.bitset) {
+		DMERR("previous unmap request exists");
+		return -EPERM;
+	}
+
 	/*
 	 * Unmap blocks with eras matching the given era, according to the
 	 * given matching function.
@@ -172,6 +236,10 @@ static int cond_unmap_by_era(struct era_policy *era, const char *test_era_str,
 	if (kstrtou32(test_era_str, 10, &test_era))
 		return -EINVAL;
 
+	r = alloc_invalidate(era);
+	if (r)
+		return r;
+
 	io_ctx.era = era;
 	io_ctx.era_match_fn = era_match_fn;
 	io_ctx.test_era = test_era;
@@ -197,10 +265,12 @@ static int cond_unmap_by_era(struct era_policy *era, const char *test_era_str,
 static void era_destroy(struct dm_cache_policy *p)
 {
 	struct era_policy *era = to_era_policy(p);
+
 #if DEBUG_ERA
-	DMDEBUG("destroyed era %p", era);
+	DMDEBUG("destroying era %p", era);
 #endif
-	kfree(era->cb_to_era);
+	free_invalidate(era);
+	vfree(era->cb_to_era);
 	kfree(era);
 }
 
@@ -216,6 +286,7 @@ static int era_map(struct dm_cache_policy *p, dm_oblock_t oblock,
 
 	if (can_block)
 		mutex_lock(&era->lock);
+
 	else if (!mutex_trylock(&era->lock))
 		return -EWOULDBLOCK;
 
@@ -257,6 +328,7 @@ static int era_load_mapping(struct dm_cache_policy *p,
 
 	r = policy_load_mapping(child, oblock, cblock, hint, hint_valid);
 
+	/* FIXME: recovered area valid on reload called from cache core invalidate mapping error path? */
 	if (!r && hint_valid &&
 	    (from_cblock(cblock) < from_cblock(era->cache_size))) {
 		recovered_era = le32_to_cpu(*le32_hint);
@@ -313,28 +385,71 @@ static void era_force_mapping(struct dm_cache_policy *p, dm_oblock_t old_oblock,
 	mutex_unlock(&era->lock);
 }
 
-static int era_set_config_value(struct dm_cache_policy *p, const char *key,
-				const char *value)
+/* Find next block to invalidate. */
+static int __find_invalidate_block(struct era_policy *era, dm_cblock_t *cblock)
+{
+	int bit = find_next_bit(era->invalidate.bitset, from_cblock(era->cache_size),
+				era->invalidate.last_cblock);
+
+	*cblock = to_cblock(bit);
+	era->invalidate.last_cblock = bit;
+	return bit < from_cblock(era->cache_size) ? 0 : -ENODATA;
+}
+
+static int era_invalidate_mapping(struct dm_cache_policy *p,
+				  dm_oblock_t *oblock, dm_cblock_t *cblock)
 {
 	struct era_policy *era = to_era_policy(p);
 	int r;
 
-	if (!strcasecmp(key, "increment_era_counter"))
-		r = incr_era_counter(era, value);
-	else if (!strcasecmp(key, "unmap_blocks_from_later_eras"))
-		r = cond_unmap_by_era(era, value, era_is_gt_value);
-	else if (!strcasecmp(key, "unmap_blocks_from_this_era_and_later"))
-		r = cond_unmap_by_era(era, value, era_is_gte_value);
-	else if (!strcasecmp(key, "unmap_blocks_from_this_era_and_earlier"))
-		r = cond_unmap_by_era(era, value, era_is_lte_value);
-	else if (!strcasecmp(key, "unmap_blocks_from_earlier_eras"))
-		r = cond_unmap_by_era(era, value, era_is_lt_value);
-	else
-		r = policy_set_config_value(p->child, key, value);
+	if (!era->invalidate.bitset)
+		return -ENODATA;
+
+	r = __find_invalidate_block(era, cblock);
+	if (r < 0)
+		free_invalidate(era);
+	else {
+		BUG_ON(from_cblock(*cblock) >= from_cblock(era->cache_size));
+		BUG_ON(!test_bit(from_cblock(*cblock), era->invalidate.bitset));
+		clear_bit(from_cblock(*cblock), era->invalidate.bitset);
+		*oblock = era->invalidate.oblocks[from_cblock(*cblock)];
+		r = policy_invalidate_mapping(p->child, oblock, cblock);
+#if DEBUG_ERA
+		DMDEBUG("unmapped cblock=%u oblock=%llu", from_cblock(*cblock), from_oblock(*oblock));
+#endif
+	}
 
 	return r;
 }
 
+struct config_value_handler {
+	const char *cmd;
+	int (*handler_fn)(struct era_policy *, const char *, era_match_fn_t);
+	era_match_fn_t match_fn;
+};
+
+/* FIXME: is a delete unmap request needed or is reloading the mapping sufficient to achieve it? */
+static int era_set_config_value(struct dm_cache_policy *p, const char *key,
+				const char *value)
+{
+	struct era_policy *era = to_era_policy(p);
+	struct config_value_handler *vh, value_handlers[] = {
+		{ "increment_era_counter",                  incr_era_counter,  NULL },
+		{ "unmap_blocks_from_later_eras",           cond_unmap_by_era, era_is_gt_value },
+		{ "unmap_blocks_from_this_era_and_later",   cond_unmap_by_era, era_is_gte_value },
+		{ "unmap_blocks_from_this_era_and_earlier", cond_unmap_by_era, era_is_lte_value },
+		{ "unmap_blocks_from_earlier_eras",         cond_unmap_by_era, era_is_lt_value },
+		{ NULL }
+	};
+
+	for (vh = value_handlers; vh->cmd; vh++) {
+		if (!strcasecmp(key, vh->cmd))
+			return vh->handler_fn(era, value, vh->match_fn);
+	}
+
+	return policy_set_config_value(p->child, key, value);
+}
+
 static int era_emit_config_values(struct dm_cache_policy *p, char *result,
 				  unsigned maxlen)
 {
@@ -355,6 +470,7 @@ static void init_policy_functions(struct era_policy *era)
 	era->policy.load_mapping = era_load_mapping;
 	era->policy.walk_mappings = era_walk_mappings;
 	era->policy.force_mapping = era_force_mapping;
+	era->policy.invalidate_mapping = era_invalidate_mapping;
 	era->policy.emit_config_values = era_emit_config_values;
 	era->policy.set_config_value = era_set_config_value;
 }
@@ -372,15 +488,13 @@ static struct dm_cache_policy *era_create(dm_cblock_t cache_size,
 	era->cache_size = cache_size;
 	mutex_init(&era->lock);
 
-	era->cb_to_era = kzalloc(from_cblock(era->cache_size) *
-				 sizeof(*(era->cb_to_era)), GFP_KERNEL);
-	if (!era->cb_to_era)
-		goto bad_alloc_cb_to_era;
-	era->era_counter = 1;
-
-	return &era->policy;
+	era->cb_to_era = vzalloc(from_cblock(era->cache_size) *
+				 sizeof(*era->cb_to_era));
+	if (era->cb_to_era) {
+		era->era_counter = 1;
+		return &era->policy;
+	}
 
-bad_alloc_cb_to_era:
 	kfree(era);
 	return NULL;
 }
-- 
1.8.1.4
