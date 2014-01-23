From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [LVM PATCH 3/4] cache:  New 'cache' segment type
Date: Thu, 23 Jan 2014 09:05:47 -0600
Message-ID: <1390489548-18076-4-git-send-email-jbrassow@redhat.com>
References: <1390489548-18076-1-git-send-email-jbrassow@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1390489548-18076-1-git-send-email-jbrassow@redhat.com>
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
Cc: agk@redhat.com, zkabelac@redhat.com
List-Id: dm-devel.ids

This patch adds the cache segment type - the second of two necessary
to create cache logical volumes.  This segment type references the
cachepool (the small fast device) and the origin (the large slow device);
linking them to create the cache device.  The cache device is the
hierarchical device-mapper device that the user ulitmately makes use
of.

The cache segment sources the information necessary to construct the
device-mapper cache target from the origin and cachepool segments to
which it links.
---
 libdm/libdevmapper.h  |   22 ++++++++
 libdm/libdm-deptree.c |  137 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 153 insertions(+), 6 deletions(-)

diff --git a/libdm/libdevmapper.h b/libdm/libdevmapper.h
index 3074500..ae9a91a 100644
--- a/libdm/libdevmapper.h
+++ b/libdm/libdevmapper.h
@@ -715,6 +715,28 @@ int dm_tree_node_add_raid_target_with_params(struct dm_tree_node *node,
 /* Cache feature_flags */
 #define DM_CACHE_FEATURE_WRITEBACK    0x00000001
 #define DM_CACHE_FEATURE_WRITETHROUGH 0x00000002
+struct dm_tree_node_cache_params {
+	uint32_t version;
+
+	uint32_t chunk_size;
+	uint32_t feature_flags; /* DM_CACHE_FEATURE_* */
+
+	int core_argc;
+	char **core_argv;
+
+	char *policy_name;
+	int   policy_argc;
+	char **policy_argv;
+
+	const char *data_uuid;
+	const char *metadata_uuid;
+	const char *origin_uuid;
+	/* 'version == 0' end */
+};
+
+int dm_tree_node_add_cache_target(struct dm_tree_node *node,
+				  uint64_t size,
+				  struct dm_tree_node_cache_params *p);
 
 /*
  * Replicator operation mode
diff --git a/libdm/libdm-deptree.c b/libdm/libdm-deptree.c
index 42bb9e7..d3f6640 100644
--- a/libdm/libdm-deptree.c
+++ b/libdm/libdm-deptree.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2005-2013 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005-2014 Red Hat, Inc. All rights reserved.
  *
  * This file is part of the device-mapper userspace tools.
  *
@@ -27,6 +27,7 @@
 
 /* Supported segment types */
 enum {
+	SEG_CACHE,
 	SEG_CRYPT,
 	SEG_ERROR,
 	SEG_LINEAR,
@@ -59,6 +60,7 @@ struct {
 	unsigned type;
 	const char *target;
 } dm_segtypes[] = {
+	{ SEG_CACHE, "cache" },
 	{ SEG_CRYPT, "crypt" },
 	{ SEG_ERROR, "error" },
 	{ SEG_LINEAR, "linear" },
@@ -158,18 +160,24 @@ struct load_segment {
 	uint32_t stripe_size;		/* Striped + raid */
 
 	int persistent;			/* Snapshot */
-	uint32_t chunk_size;		/* Snapshot */
+	uint32_t chunk_size;		/* Snapshot + cache */
 	struct dm_tree_node *cow;	/* Snapshot */
-	struct dm_tree_node *origin;	/* Snapshot + Snapshot origin */
+	struct dm_tree_node *origin;	/* Snapshot + Snapshot origin + Cache */
 	struct dm_tree_node *merge;	/* Snapshot */
 
 	struct dm_tree_node *log;	/* Mirror + Replicator */
 	uint32_t region_size;		/* Mirror + raid */
 	unsigned clustered;		/* Mirror */
 	unsigned mirror_area_count;	/* Mirror */
-	uint32_t flags;			/* Mirror log */
+	uint32_t flags;			/* Mirror + raid + Cache */
 	char *uuid;			/* Clustered mirror log */
 
+	int   core_argc;		/* Cache */
+	char **core_argv;		/* Cache */
+	char *policy_name;		/* Cache */
+	int   policy_argc;		/* Cache */
+	char **policy_argv;		/* Cache */
+
 	const char *cipher;		/* Crypt */
 	const char *chainmode;		/* Crypt */
 	const char *iv;			/* Crypt */
@@ -189,7 +197,7 @@ struct load_segment {
 	uint32_t max_recovery_rate;	/* raid kB/sec/disk */
 	uint32_t min_recovery_rate;	/* raid kB/sec/disk */
 
-	struct dm_tree_node *metadata;	/* Thin_pool */
+	struct dm_tree_node *metadata;	/* Thin_pool + Cache */
 	struct dm_tree_node *pool;	/* Thin_pool, Thin */
 	struct dm_tree_node *external;	/* Thin */
 	struct dm_list thin_messages;	/* Thin_pool */
@@ -2262,6 +2270,70 @@ static int _raid_emit_segment_line(struct dm_task *dmt, uint32_t major,
 	return 1;
 }
 
+static int _cache_emit_segment_line(struct dm_task *dmt,
+				    struct load_segment *seg,
+				    char *params, size_t paramsize)
+{
+	int i, pos = 0;
+	unsigned feature_count;
+	struct seg_area *area;
+	char data[DM_FORMAT_DEV_BUFSIZE];
+	char metadata[DM_FORMAT_DEV_BUFSIZE];
+	char origin[DM_FORMAT_DEV_BUFSIZE];
+
+	/* Metadata Dev */
+	if (!_build_dev_string(metadata, sizeof(metadata), seg->metadata))
+		return_0;
+	EMIT_PARAMS(pos, " %s", metadata);
+
+	/* Cache Dev */
+	if (!_build_dev_string(data, sizeof(origin), seg->pool))
+		return_0;
+	EMIT_PARAMS(pos, " %s", data);
+
+	/* Origin Dev */
+	dm_list_iterate_items(area, &seg->areas)
+		break; /* There is only ever 1 area */
+	if (!_build_dev_string(origin, sizeof(data), area->dev_node))
+		return_0;
+	EMIT_PARAMS(pos, " %s", origin);
+
+	/* Chunk size */
+	EMIT_PARAMS(pos, " %u", seg->chunk_size);
+
+	/* Features */
+	feature_count = hweight32(seg->flags);
+	EMIT_PARAMS(pos, " %d", feature_count);
+	if (seg->flags & DM_CACHE_FEATURE_WRITETHROUGH)
+		EMIT_PARAMS(pos, " writethrough");
+	else if (seg->flags & DM_CACHE_FEATURE_WRITEBACK)
+		EMIT_PARAMS(pos, " writeback");
+
+	/* Core Arguments (like 'migration_threshold') */
+	if (seg->core_argc) {
+		EMIT_PARAMS(pos, " %d", seg->core_argc);
+		for (i = 0; i < seg->core_argc; i++)
+			EMIT_PARAMS(pos, " %s", seg->core_argv[i]);
+	}
+
+	/* Cache Policy */
+	if (!seg->policy_name)
+		EMIT_PARAMS(pos, " default 0");
+	else {
+		EMIT_PARAMS(pos, " %s %d", seg->policy_name, seg->policy_argc);
+		if (seg->policy_argc % 2) {
+			log_error(INTERNAL_ERROR
+				  "Cache policy arguments must be in "
+				  "<key> <value> pairs");
+			return 0;
+		}
+		for (i = 0; i < seg->policy_argc; i++)
+			EMIT_PARAMS(pos, " %s", seg->policy_argv[i]);
+	}
+
+	return 1;
+}
+
 static int _thin_pool_emit_segment_line(struct dm_task *dmt,
 					struct load_segment *seg,
 					char *params, size_t paramsize)
@@ -2398,6 +2470,10 @@ static int _emit_segment_line(struct dm_task *dmt, uint32_t major,
 		if (!_thin_emit_segment_line(dmt, seg, params, paramsize))
 			return_0;
 		break;
+	case SEG_CACHE:
+		if (!_cache_emit_segment_line(dmt, seg, params, paramsize))
+			return_0;
+		break;
 	}
 
 	switch(seg->type) {
@@ -2409,6 +2485,7 @@ static int _emit_segment_line(struct dm_task *dmt, uint32_t major,
 	case SEG_ZERO:
 	case SEG_THIN_POOL:
 	case SEG_THIN:
+	case SEG_CACHE:
 		break;
 	case SEG_CRYPT:
 	case SEG_LINEAR:
@@ -3045,7 +3122,6 @@ int dm_tree_node_add_raid_target(struct dm_tree_node *node,
 	return dm_tree_node_add_raid_target_with_params(node, size, &params);
 }
 
-
 /*
  * Various RAID status versions include:
  * Versions < 1.5.0 (4 fields):
@@ -3124,6 +3200,55 @@ bad:
 	return 0;
 }
 
+int dm_tree_node_add_cache_target(struct dm_tree_node *node,
+				  uint64_t size,
+				  struct dm_tree_node_cache_params *p)
+{
+	int i;
+	struct load_segment *seg = NULL;
+
+	for (i = 0; dm_segtypes[i].target && !seg; i++) {
+		if (strcmp("cache", dm_segtypes[i].target))
+			continue;
+		if (!(seg = _add_segment(node, dm_segtypes[i].type, size)))
+			return_0;
+	}
+
+	if (!seg)
+		return_0;
+
+	if (!(seg->pool = dm_tree_find_node_by_uuid(node->dtree,
+						    p->data_uuid))) {
+		log_error("Missing cache's data uuid, %s",
+			  p->data_uuid);
+		return 0;
+	}
+	if (!_link_tree_nodes(node, seg->pool))
+		return_0;
+
+	if (!(seg->metadata = dm_tree_find_node_by_uuid(node->dtree,
+							p->metadata_uuid))) {
+		log_error("Missing cache's metadata uuid, %s",
+			  p->metadata_uuid);
+		return 0;
+	}
+	if (!_link_tree_nodes(node, seg->metadata))
+		return_0;
+
+	seg->chunk_size = p->chunk_size;
+
+	seg->flags = p->feature_flags;
+
+	seg->core_argc = p->core_argc;
+	seg->core_argv = p->core_argv;
+
+	seg->policy_name = p->policy_name;
+	seg->policy_argc = p->policy_argc;
+	seg->policy_argv = p->policy_argv;
+
+	return 1;
+}
+
 int dm_tree_node_add_replicator_target(struct dm_tree_node *node,
 				       uint64_t size,
 				       const char *rlog_uuid,
-- 
1.7.7.6
