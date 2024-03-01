Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EDC55E59
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 20:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709326048; cv=none; b=efhp/1/xIjGaVqeillDoZqJk6zcUDvtuDDWlPb2kp8VgxMJRfbSmRd2Lrg6bkup2Nfyr7aMIzBvY2WxanFPrFxhiSGEOZUmFQFPIHJW1Yznmj73ToCaOIKtiMaXRH9oGhERt2LwUxZh9PuOo9VQB+lodmVul+YAEtUnkNS4jfKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709326048; c=relaxed/simple;
	bh=dqfySqOFHcwZmbfwJt/0zDHmWfZa2Xtn1mXRW4YJT9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ipOqZKN+/eJNu9xEQQnL4cHOx0IiC8YLwhSA6WZNuRkstTdRVEIO2TSKg9e8Gb9pL5dntudXtCOwRmoOJq98HndrNE+SeLSTOg1Ixe7vFMI8ZHMAIZtOpctUQ1NH6Uc9PcrJ32Xse7oPw4pxaHp8p3mWcaawI8+iAuff2SpHzCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KuIC9UkW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KuIC9UkW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709326042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2BIZs8ppixQ0axXvmdc//aSOLEEnoQKqJuceQTOvyk=;
	b=KuIC9UkWe1TyJFcfIaXZtJR2tfyUn1V1s4aruZwuUvTstzqIiYWZog7ApbpLB6uuXbBgJY
	O9MBagJMe7wi/L+MvwXsweePBM1G8b9UlhoNnCnsNxx3niyxQnI+moa2jf7wCy/dY/PU8Z
	fP/H3WFH5PE9GyKxj/eKkRbg0POMWhM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-axspvaUBNjyivfpYfVIfaw-1; Fri, 01 Mar 2024 15:47:20 -0500
X-MC-Unique: axspvaUBNjyivfpYfVIfaw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09C7B10230E0;
	Fri,  1 Mar 2024 20:47:20 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 02D9842236;
	Fri,  1 Mar 2024 20:47:20 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id F1649A1B7E; Fri,  1 Mar 2024 15:47:19 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/4] dm vdo: remove all sysfs interfaces
Date: Fri,  1 Mar 2024 15:47:16 -0500
Message-ID: <646b2628524bd5e759768051e34b5f421906168d.1709325896.git.msakai@redhat.com>
In-Reply-To: <cover.1709325895.git.msakai@redhat.com>
References: <cover.1709325895.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Also update target major version number.

All info is (or will be) accessible through alternative interfaces
(e.g. "dmsetup message", module params, etc).

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/Makefile           |    4 -
 drivers/md/dm-vdo/dedupe.c           |   70 +-
 drivers/md/dm-vdo/dedupe.h           |    2 +-
 drivers/md/dm-vdo/dm-vdo-target.c    |   44 +-
 drivers/md/dm-vdo/logger.c           |    5 -
 drivers/md/dm-vdo/logger.h           |    2 -
 drivers/md/dm-vdo/pool-sysfs-stats.c | 2063 --------------------------
 drivers/md/dm-vdo/pool-sysfs.c       |  198 ---
 drivers/md/dm-vdo/pool-sysfs.h       |   19 -
 drivers/md/dm-vdo/status-codes.c     |    1 -
 drivers/md/dm-vdo/status-codes.h     |    2 -
 drivers/md/dm-vdo/sysfs.c            |   82 -
 drivers/md/dm-vdo/uds-sysfs.c        |  187 ---
 drivers/md/dm-vdo/uds-sysfs.h        |   12 -
 drivers/md/dm-vdo/vdo.c              |   54 +-
 drivers/md/dm-vdo/vdo.h              |   13 -
 16 files changed, 9 insertions(+), 2749 deletions(-)
 delete mode 100644 drivers/md/dm-vdo/pool-sysfs-stats.c
 delete mode 100644 drivers/md/dm-vdo/pool-sysfs.c
 delete mode 100644 drivers/md/dm-vdo/pool-sysfs.h
 delete mode 100644 drivers/md/dm-vdo/sysfs.c
 delete mode 100644 drivers/md/dm-vdo/uds-sysfs.c
 delete mode 100644 drivers/md/dm-vdo/uds-sysfs.h

diff --git a/drivers/md/dm-vdo/Makefile b/drivers/md/dm-vdo/Makefile
index 502a7a0acbdb..33e09abc6acd 100644
--- a/drivers/md/dm-vdo/Makefile
+++ b/drivers/md/dm-vdo/Makefile
@@ -28,19 +28,15 @@ dm-vdo-objs := \
 	packer.o \
 	permassert.o \
 	physical-zone.o \
-	pool-sysfs.o \
-	pool-sysfs-stats.o \
 	priority-table.o \
 	recovery-journal.o \
 	repair.o \
 	slab-depot.o \
 	status-codes.o \
 	string-utils.o \
-	sysfs.o \
 	thread-device.o \
 	thread-registry.o \
 	thread-utils.o \
-	uds-sysfs.o \
 	vdo.o \
 	vio.o \
 	wait-queue.o \
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 52bdf657db64..8550a9a7958b 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -120,7 +120,6 @@
 #include <linux/atomic.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
-#include <linux/kobject.h>
 #include <linux/list.h>
 #include <linux/ratelimit.h>
 #include <linux/spinlock.h>
@@ -279,7 +278,6 @@ struct hash_lock {
 
 struct hash_zones {
 	struct action_manager *manager;
-	struct kobject dedupe_directory;
 	struct uds_parameters parameters;
 	struct uds_index_session *index_session;
 	struct ratelimit_state ratelimiter;
@@ -2022,56 +2020,6 @@ void vdo_share_compressed_write_lock(struct data_vio *data_vio,
 	VDO_ASSERT_LOG_ONLY(claimed, "impossible to fail to claim an initial increment");
 }
 
-static void dedupe_kobj_release(struct kobject *directory)
-{
-	vdo_free(container_of(directory, struct hash_zones, dedupe_directory));
-}
-
-static ssize_t dedupe_status_show(struct kobject *directory, struct attribute *attr,
-				  char *buf)
-{
-	struct uds_attribute *ua = container_of(attr, struct uds_attribute, attr);
-	struct hash_zones *zones = container_of(directory, struct hash_zones,
-						dedupe_directory);
-
-	if (ua->show_string != NULL)
-		return sprintf(buf, "%s\n", ua->show_string(zones));
-	else
-		return -EINVAL;
-}
-
-static ssize_t dedupe_status_store(struct kobject *kobj __always_unused,
-				   struct attribute *attr __always_unused,
-				   const char *buf __always_unused,
-				   size_t length __always_unused)
-{
-	return -EINVAL;
-}
-
-/*----------------------------------------------------------------------*/
-
-static const struct sysfs_ops dedupe_sysfs_ops = {
-	.show = dedupe_status_show,
-	.store = dedupe_status_store,
-};
-
-static struct uds_attribute dedupe_status_attribute = {
-	.attr = {.name = "status", .mode = 0444, },
-	.show_string = vdo_get_dedupe_index_state_name,
-};
-
-static struct attribute *dedupe_attrs[] = {
-	&dedupe_status_attribute.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(dedupe);
-
-static const struct kobj_type dedupe_directory_type = {
-	.release = dedupe_kobj_release,
-	.sysfs_ops = &dedupe_sysfs_ops,
-	.default_groups = dedupe_groups,
-};
-
 static void start_uds_queue(void *ptr)
 {
 	/*
@@ -2266,7 +2214,6 @@ static int initialize_index(struct vdo *vdo, struct hash_zones *zones)
 	vdo_initialize_completion(&zones->completion, vdo, VDO_HASH_ZONES_COMPLETION);
 	vdo_set_completion_callback(&zones->completion, change_dedupe_state,
 				    vdo->thread_config.dedupe_thread);
-	kobject_init(&zones->dedupe_directory, &dedupe_directory_type);
 	return VDO_SUCCESS;
 }
 
@@ -2537,10 +2484,7 @@ void vdo_free_hash_zones(struct hash_zones *zones)
 		vdo_finish_dedupe_index(zones);
 
 	ratelimit_state_exit(&zones->ratelimiter);
-	if (vdo_get_admin_state_code(&zones->state) == VDO_ADMIN_STATE_NEW)
-		vdo_free(zones);
-	else
-		kobject_put(&zones->dedupe_directory);
+	vdo_free(zones);
 }
 
 static void initiate_suspend_index(struct admin_state *state)
@@ -3047,17 +2991,9 @@ int vdo_message_dedupe_index(struct hash_zones *zones, const char *name)
 	return -EINVAL;
 }
 
-int vdo_add_dedupe_index_sysfs(struct hash_zones *zones)
+void vdo_set_dedupe_state_normal(struct hash_zones *zones)
 {
-	int result = kobject_add(&zones->dedupe_directory,
-				 &zones->completion.vdo->vdo_directory, "dedupe");
-
-	if (result == 0) {
-		vdo_set_admin_state_code(&zones->state,
-					 VDO_ADMIN_STATE_NORMAL_OPERATION);
-	}
-
-	return result;
+	vdo_set_admin_state_code(&zones->state, VDO_ADMIN_STATE_NORMAL_OPERATION);
 }
 
 /* If create_flag, create a new index without first attempting to load an existing index. */
diff --git a/drivers/md/dm-vdo/dedupe.h b/drivers/md/dm-vdo/dedupe.h
index 1566fc972ea7..9000d6f3eece 100644
--- a/drivers/md/dm-vdo/dedupe.h
+++ b/drivers/md/dm-vdo/dedupe.h
@@ -97,7 +97,7 @@ u64 vdo_get_dedupe_index_timeout_count(struct hash_zones *zones);
 
 int vdo_message_dedupe_index(struct hash_zones *zones, const char *name);
 
-int vdo_add_dedupe_index_sysfs(struct hash_zones *zones);
+void vdo_set_dedupe_state_normal(struct hash_zones *zones);
 
 void vdo_start_dedupe_index(struct hash_zones *zones, bool create_flag);
 
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 5f607dbb16e9..c6ee8161ba62 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -27,7 +27,6 @@
 #include "logger.h"
 #include "memory-alloc.h"
 #include "message-stats.h"
-#include "pool-sysfs.h"
 #include "recovery-journal.h"
 #include "repair.h"
 #include "slab-depot.h"
@@ -36,7 +35,6 @@
 #include "thread-device.h"
 #include "thread-registry.h"
 #include "types.h"
-#include "uds-sysfs.h"
 #include "vdo.h"
 #include "vio.h"
 
@@ -54,7 +52,6 @@ enum admin_phases {
 	GROW_PHYSICAL_PHASE_END,
 	GROW_PHYSICAL_PHASE_ERROR,
 	LOAD_PHASE_START,
-	LOAD_PHASE_STATS,
 	LOAD_PHASE_LOAD_DEPOT,
 	LOAD_PHASE_MAKE_DIRTY,
 	LOAD_PHASE_PREPARE_TO_ALLOCATE,
@@ -104,7 +101,6 @@ static const char * const ADMIN_PHASE_NAMES[] = {
 	"GROW_PHYSICAL_PHASE_END",
 	"GROW_PHYSICAL_PHASE_ERROR",
 	"LOAD_PHASE_START",
-	"LOAD_PHASE_STATS",
 	"LOAD_PHASE_LOAD_DEPOT",
 	"LOAD_PHASE_MAKE_DIRTY",
 	"LOAD_PHASE_PREPARE_TO_ALLOCATE",
@@ -947,8 +943,8 @@ static void vdo_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 * blocked task warnings in kernel logs. In order to avoid these warnings, we choose to
 	 * use the smallest reasonable value.
 	 *
-	 * The value is displayed in sysfs, and also used by dm-thin to determine whether to pass
-	 * down discards. The block layer splits large discards on this boundary when this is set.
+	 * The value is used by dm-thin to determine whether to pass down discards. The block layer
+	 * splits large discards on this boundary when this is set.
 	 */
 	limits->max_discard_sectors =
 		(vdo->device_config->max_discard_blocks * VDO_SECTORS_PER_BLOCK);
@@ -2174,32 +2170,6 @@ static enum slab_depot_load_type get_load_type(struct vdo *vdo)
 	return VDO_SLAB_DEPOT_NORMAL_LOAD;
 }
 
-/**
- * vdo_initialize_kobjects() - Initialize the vdo sysfs directory.
- * @vdo: The vdo being initialized.
- *
- * Return: VDO_SUCCESS or an error code.
- */
-static int vdo_initialize_kobjects(struct vdo *vdo)
-{
-	int result;
-	struct dm_target *target = vdo->device_config->owning_target;
-	struct mapped_device *md = dm_table_get_md(target->table);
-
-	kobject_init(&vdo->vdo_directory, &vdo_directory_type);
-	vdo->sysfs_added = true;
-	result = kobject_add(&vdo->vdo_directory, &disk_to_dev(dm_disk(md))->kobj,
-			     "vdo");
-	if (result != 0)
-		return VDO_CANT_ADD_SYSFS_NODE;
-
-	result = vdo_add_dedupe_index_sysfs(vdo->hash_zones);
-	if (result != 0)
-		return VDO_CANT_ADD_SYSFS_NODE;
-
-	return vdo_add_sysfs_stats_dir(vdo);
-}
-
 /**
  * load_callback() - Callback to do the destructive parts of loading a VDO.
  * @completion: The sub-task completion.
@@ -2225,11 +2195,8 @@ static void load_callback(struct vdo_completion *completion)
 		vdo_allow_read_only_mode_entry(completion);
 		return;
 
-	case LOAD_PHASE_STATS:
-		vdo_continue_completion(completion, vdo_initialize_kobjects(vdo));
-		return;
-
 	case LOAD_PHASE_LOAD_DEPOT:
+		vdo_set_dedupe_state_normal(vdo->hash_zones);
 		if (vdo_is_read_only(vdo)) {
 			/*
 			 * In read-only mode we don't use the allocator and it may not even be
@@ -2866,7 +2833,7 @@ static void vdo_resume(struct dm_target *ti)
 static struct target_type vdo_target_bio = {
 	.features = DM_TARGET_SINGLETON,
 	.name = "vdo",
-	.version = { 8, 2, 0 },
+	.version = { 9, 0, 0 },
 	.module = THIS_MODULE,
 	.ctr = vdo_ctr,
 	.dtr = vdo_dtr,
@@ -2905,8 +2872,6 @@ static int __init vdo_init(void)
 
 	/* Memory tracking must be initialized first for accurate accounting. */
 	vdo_memory_init();
-	uds_init_sysfs();
-
 	vdo_initialize_thread_device_registry();
 	vdo_initialize_device_registry_once();
 	uds_log_info("loaded version %s", CURRENT_VERSION);
@@ -2933,7 +2898,6 @@ static int __init vdo_init(void)
 static void __exit vdo_exit(void)
 {
 	vdo_module_destroy();
-	uds_put_sysfs();
 	/* Memory tracking cleanup must be done last. */
 	vdo_memory_exit();
 }
diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
index a50edb0331fc..bac28fff622d 100644
--- a/drivers/md/dm-vdo/logger.c
+++ b/drivers/md/dm-vdo/logger.c
@@ -56,11 +56,6 @@ int uds_get_log_level(void)
 	return log_level;
 }
 
-void uds_set_log_level(int new_log_level)
-{
-	log_level = new_log_level;
-}
-
 int uds_log_string_to_priority(const char *string)
 {
 	int i;
diff --git a/drivers/md/dm-vdo/logger.h b/drivers/md/dm-vdo/logger.h
index 4e2f18042ba7..ceb07aa3231f 100644
--- a/drivers/md/dm-vdo/logger.h
+++ b/drivers/md/dm-vdo/logger.h
@@ -37,8 +37,6 @@
 
 int uds_get_log_level(void);
 
-void uds_set_log_level(int new_log_level);
-
 int uds_log_string_to_priority(const char *string);
 
 const char *uds_log_priority_to_string(int priority);
diff --git a/drivers/md/dm-vdo/pool-sysfs-stats.c b/drivers/md/dm-vdo/pool-sysfs-stats.c
deleted file mode 100644
index ae3838894a1c..000000000000
--- a/drivers/md/dm-vdo/pool-sysfs-stats.c
+++ /dev/null
@@ -1,2063 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2023 Red Hat
- */
-
-#include <linux/mutex.h>
-
-#include "logger.h"
-#include "string-utils.h"
-
-#include "dedupe.h"
-#include "pool-sysfs.h"
-#include "statistics.h"
-#include "vdo.h"
-
-struct pool_stats_attribute {
-	struct attribute attr;
-	ssize_t (*print)(struct vdo_statistics *stats, char *buf);
-};
-
-static ssize_t pool_stats_attr_show(struct kobject *directory,
-				    struct attribute *attr,
-				    char *buf)
-{
-	ssize_t size;
-	struct pool_stats_attribute *pool_stats_attr =
-		container_of(attr, struct pool_stats_attribute, attr);
-	struct vdo *vdo = container_of(directory, struct vdo, stats_directory);
-
-	if (pool_stats_attr->print == NULL)
-		return -EINVAL;
-
-	mutex_lock(&vdo->stats_mutex);
-	vdo_fetch_statistics(vdo, &vdo->stats_buffer);
-	size = pool_stats_attr->print(&vdo->stats_buffer, buf);
-	mutex_unlock(&vdo->stats_mutex);
-
-	return size;
-}
-
-const struct sysfs_ops vdo_pool_stats_sysfs_ops = {
-	.show = pool_stats_attr_show,
-	.store = NULL,
-};
-
-/* Number of blocks used for data */
-static ssize_t
-pool_stats_print_data_blocks_used(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->data_blocks_used);
-}
-
-static struct pool_stats_attribute pool_stats_attr_data_blocks_used = {
-	.attr = { .name = "data_blocks_used", .mode = 0444, },
-	.print = pool_stats_print_data_blocks_used,
-};
-
-/* Number of blocks used for VDO metadata */
-static ssize_t
-pool_stats_print_overhead_blocks_used(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->overhead_blocks_used);
-}
-
-static struct pool_stats_attribute pool_stats_attr_overhead_blocks_used = {
-	.attr = { .name = "overhead_blocks_used", .mode = 0444, },
-	.print = pool_stats_print_overhead_blocks_used,
-};
-
-/* Number of logical blocks that are currently mapped to physical blocks */
-static ssize_t
-pool_stats_print_logical_blocks_used(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->logical_blocks_used);
-}
-
-static struct pool_stats_attribute pool_stats_attr_logical_blocks_used = {
-	.attr = { .name = "logical_blocks_used", .mode = 0444, },
-	.print = pool_stats_print_logical_blocks_used,
-};
-
-/* number of physical blocks */
-static ssize_t
-pool_stats_print_physical_blocks(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->physical_blocks);
-}
-
-static struct pool_stats_attribute pool_stats_attr_physical_blocks = {
-	.attr = { .name = "physical_blocks", .mode = 0444, },
-	.print = pool_stats_print_physical_blocks,
-};
-
-/* number of logical blocks */
-static ssize_t
-pool_stats_print_logical_blocks(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->logical_blocks);
-}
-
-static struct pool_stats_attribute pool_stats_attr_logical_blocks = {
-	.attr = { .name = "logical_blocks", .mode = 0444, },
-	.print = pool_stats_print_logical_blocks,
-};
-
-/* Size of the block map page cache, in bytes */
-static ssize_t
-pool_stats_print_block_map_cache_size(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map_cache_size);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_cache_size = {
-	.attr = { .name = "block_map_cache_size", .mode = 0444, },
-	.print = pool_stats_print_block_map_cache_size,
-};
-
-/* The physical block size */
-static ssize_t
-pool_stats_print_block_size(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_size);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_size = {
-	.attr = { .name = "block_size", .mode = 0444, },
-	.print = pool_stats_print_block_size,
-};
-
-/* Number of times the VDO has successfully recovered */
-static ssize_t
-pool_stats_print_complete_recoveries(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->complete_recoveries);
-}
-
-static struct pool_stats_attribute pool_stats_attr_complete_recoveries = {
-	.attr = { .name = "complete_recoveries", .mode = 0444, },
-	.print = pool_stats_print_complete_recoveries,
-};
-
-/* Number of times the VDO has recovered from read-only mode */
-static ssize_t
-pool_stats_print_read_only_recoveries(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->read_only_recoveries);
-}
-
-static struct pool_stats_attribute pool_stats_attr_read_only_recoveries = {
-	.attr = { .name = "read_only_recoveries", .mode = 0444, },
-	.print = pool_stats_print_read_only_recoveries,
-};
-
-/* String describing the operating mode of the VDO */
-static ssize_t
-pool_stats_print_mode(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%s\n", stats->mode);
-}
-
-static struct pool_stats_attribute pool_stats_attr_mode = {
-	.attr = { .name = "mode", .mode = 0444, },
-	.print = pool_stats_print_mode,
-};
-
-/* Whether the VDO is in recovery mode */
-static ssize_t
-pool_stats_print_in_recovery_mode(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%d\n", stats->in_recovery_mode);
-}
-
-static struct pool_stats_attribute pool_stats_attr_in_recovery_mode = {
-	.attr = { .name = "in_recovery_mode", .mode = 0444, },
-	.print = pool_stats_print_in_recovery_mode,
-};
-
-/* What percentage of recovery mode work has been completed */
-static ssize_t
-pool_stats_print_recovery_percentage(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->recovery_percentage);
-}
-
-static struct pool_stats_attribute pool_stats_attr_recovery_percentage = {
-	.attr = { .name = "recovery_percentage", .mode = 0444, },
-	.print = pool_stats_print_recovery_percentage,
-};
-
-/* Number of compressed data items written since startup */
-static ssize_t
-pool_stats_print_packer_compressed_fragments_written(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->packer.compressed_fragments_written);
-}
-
-static struct pool_stats_attribute pool_stats_attr_packer_compressed_fragments_written = {
-	.attr = { .name = "packer_compressed_fragments_written", .mode = 0444, },
-	.print = pool_stats_print_packer_compressed_fragments_written,
-};
-
-/* Number of blocks containing compressed items written since startup */
-static ssize_t
-pool_stats_print_packer_compressed_blocks_written(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->packer.compressed_blocks_written);
-}
-
-static struct pool_stats_attribute pool_stats_attr_packer_compressed_blocks_written = {
-	.attr = { .name = "packer_compressed_blocks_written", .mode = 0444, },
-	.print = pool_stats_print_packer_compressed_blocks_written,
-};
-
-/* Number of VIOs that are pending in the packer */
-static ssize_t
-pool_stats_print_packer_compressed_fragments_in_packer(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->packer.compressed_fragments_in_packer);
-}
-
-static struct pool_stats_attribute pool_stats_attr_packer_compressed_fragments_in_packer = {
-	.attr = { .name = "packer_compressed_fragments_in_packer", .mode = 0444, },
-	.print = pool_stats_print_packer_compressed_fragments_in_packer,
-};
-
-/* The total number of slabs from which blocks may be allocated */
-static ssize_t
-pool_stats_print_allocator_slab_count(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->allocator.slab_count);
-}
-
-static struct pool_stats_attribute pool_stats_attr_allocator_slab_count = {
-	.attr = { .name = "allocator_slab_count", .mode = 0444, },
-	.print = pool_stats_print_allocator_slab_count,
-};
-
-/* The total number of slabs from which blocks have ever been allocated */
-static ssize_t
-pool_stats_print_allocator_slabs_opened(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->allocator.slabs_opened);
-}
-
-static struct pool_stats_attribute pool_stats_attr_allocator_slabs_opened = {
-	.attr = { .name = "allocator_slabs_opened", .mode = 0444, },
-	.print = pool_stats_print_allocator_slabs_opened,
-};
-
-/* The number of times since loading that a slab has been re-opened */
-static ssize_t
-pool_stats_print_allocator_slabs_reopened(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->allocator.slabs_reopened);
-}
-
-static struct pool_stats_attribute pool_stats_attr_allocator_slabs_reopened = {
-	.attr = { .name = "allocator_slabs_reopened", .mode = 0444, },
-	.print = pool_stats_print_allocator_slabs_reopened,
-};
-
-/* Number of times the on-disk journal was full */
-static ssize_t
-pool_stats_print_journal_disk_full(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->journal.disk_full);
-}
-
-static struct pool_stats_attribute pool_stats_attr_journal_disk_full = {
-	.attr = { .name = "journal_disk_full", .mode = 0444, },
-	.print = pool_stats_print_journal_disk_full,
-};
-
-/* Number of times the recovery journal requested slab journal commits. */
-static ssize_t
-pool_stats_print_journal_slab_journal_commits_requested(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->journal.slab_journal_commits_requested);
-}
-
-static struct pool_stats_attribute pool_stats_attr_journal_slab_journal_commits_requested = {
-	.attr = { .name = "journal_slab_journal_commits_requested", .mode = 0444, },
-	.print = pool_stats_print_journal_slab_journal_commits_requested,
-};
-
-/* The total number of items on which processing has started */
-static ssize_t
-pool_stats_print_journal_entries_started(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->journal.entries.started);
-}
-
-static struct pool_stats_attribute pool_stats_attr_journal_entries_started = {
-	.attr = { .name = "journal_entries_started", .mode = 0444, },
-	.print = pool_stats_print_journal_entries_started,
-};
-
-/* The total number of items for which a write operation has been issued */
-static ssize_t
-pool_stats_print_journal_entries_written(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->journal.entries.written);
-}
-
-static struct pool_stats_attribute pool_stats_attr_journal_entries_written = {
-	.attr = { .name = "journal_entries_written", .mode = 0444, },
-	.print = pool_stats_print_journal_entries_written,
-};
-
-/* The total number of items for which a write operation has completed */
-static ssize_t
-pool_stats_print_journal_entries_committed(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->journal.entries.committed);
-}
-
-static struct pool_stats_attribute pool_stats_attr_journal_entries_committed = {
-	.attr = { .name = "journal_entries_committed", .mode = 0444, },
-	.print = pool_stats_print_journal_entries_committed,
-};
-
-/* The total number of items on which processing has started */
-static ssize_t
-pool_stats_print_journal_blocks_started(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->journal.blocks.started);
-}
-
-static struct pool_stats_attribute pool_stats_attr_journal_blocks_started = {
-	.attr = { .name = "journal_blocks_started", .mode = 0444, },
-	.print = pool_stats_print_journal_blocks_started,
-};
-
-/* The total number of items for which a write operation has been issued */
-static ssize_t
-pool_stats_print_journal_blocks_written(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->journal.blocks.written);
-}
-
-static struct pool_stats_attribute pool_stats_attr_journal_blocks_written = {
-	.attr = { .name = "journal_blocks_written", .mode = 0444, },
-	.print = pool_stats_print_journal_blocks_written,
-};
-
-/* The total number of items for which a write operation has completed */
-static ssize_t
-pool_stats_print_journal_blocks_committed(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->journal.blocks.committed);
-}
-
-static struct pool_stats_attribute pool_stats_attr_journal_blocks_committed = {
-	.attr = { .name = "journal_blocks_committed", .mode = 0444, },
-	.print = pool_stats_print_journal_blocks_committed,
-};
-
-/* Number of times the on-disk journal was full */
-static ssize_t
-pool_stats_print_slab_journal_disk_full_count(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->slab_journal.disk_full_count);
-}
-
-static struct pool_stats_attribute pool_stats_attr_slab_journal_disk_full_count = {
-	.attr = { .name = "slab_journal_disk_full_count", .mode = 0444, },
-	.print = pool_stats_print_slab_journal_disk_full_count,
-};
-
-/* Number of times an entry was added over the flush threshold */
-static ssize_t
-pool_stats_print_slab_journal_flush_count(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->slab_journal.flush_count);
-}
-
-static struct pool_stats_attribute pool_stats_attr_slab_journal_flush_count = {
-	.attr = { .name = "slab_journal_flush_count", .mode = 0444, },
-	.print = pool_stats_print_slab_journal_flush_count,
-};
-
-/* Number of times an entry was added over the block threshold */
-static ssize_t
-pool_stats_print_slab_journal_blocked_count(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->slab_journal.blocked_count);
-}
-
-static struct pool_stats_attribute pool_stats_attr_slab_journal_blocked_count = {
-	.attr = { .name = "slab_journal_blocked_count", .mode = 0444, },
-	.print = pool_stats_print_slab_journal_blocked_count,
-};
-
-/* Number of times a tail block was written */
-static ssize_t
-pool_stats_print_slab_journal_blocks_written(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->slab_journal.blocks_written);
-}
-
-static struct pool_stats_attribute pool_stats_attr_slab_journal_blocks_written = {
-	.attr = { .name = "slab_journal_blocks_written", .mode = 0444, },
-	.print = pool_stats_print_slab_journal_blocks_written,
-};
-
-/* Number of times we had to wait for the tail to write */
-static ssize_t
-pool_stats_print_slab_journal_tail_busy_count(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->slab_journal.tail_busy_count);
-}
-
-static struct pool_stats_attribute pool_stats_attr_slab_journal_tail_busy_count = {
-	.attr = { .name = "slab_journal_tail_busy_count", .mode = 0444, },
-	.print = pool_stats_print_slab_journal_tail_busy_count,
-};
-
-/* Number of blocks written */
-static ssize_t
-pool_stats_print_slab_summary_blocks_written(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->slab_summary.blocks_written);
-}
-
-static struct pool_stats_attribute pool_stats_attr_slab_summary_blocks_written = {
-	.attr = { .name = "slab_summary_blocks_written", .mode = 0444, },
-	.print = pool_stats_print_slab_summary_blocks_written,
-};
-
-/* Number of reference blocks written */
-static ssize_t
-pool_stats_print_ref_counts_blocks_written(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->ref_counts.blocks_written);
-}
-
-static struct pool_stats_attribute pool_stats_attr_ref_counts_blocks_written = {
-	.attr = { .name = "ref_counts_blocks_written", .mode = 0444, },
-	.print = pool_stats_print_ref_counts_blocks_written,
-};
-
-/* number of dirty (resident) pages */
-static ssize_t
-pool_stats_print_block_map_dirty_pages(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->block_map.dirty_pages);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_dirty_pages = {
-	.attr = { .name = "block_map_dirty_pages", .mode = 0444, },
-	.print = pool_stats_print_block_map_dirty_pages,
-};
-
-/* number of clean (resident) pages */
-static ssize_t
-pool_stats_print_block_map_clean_pages(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->block_map.clean_pages);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_clean_pages = {
-	.attr = { .name = "block_map_clean_pages", .mode = 0444, },
-	.print = pool_stats_print_block_map_clean_pages,
-};
-
-/* number of free pages */
-static ssize_t
-pool_stats_print_block_map_free_pages(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->block_map.free_pages);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_free_pages = {
-	.attr = { .name = "block_map_free_pages", .mode = 0444, },
-	.print = pool_stats_print_block_map_free_pages,
-};
-
-/* number of pages in failed state */
-static ssize_t
-pool_stats_print_block_map_failed_pages(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->block_map.failed_pages);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_failed_pages = {
-	.attr = { .name = "block_map_failed_pages", .mode = 0444, },
-	.print = pool_stats_print_block_map_failed_pages,
-};
-
-/* number of pages incoming */
-static ssize_t
-pool_stats_print_block_map_incoming_pages(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->block_map.incoming_pages);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_incoming_pages = {
-	.attr = { .name = "block_map_incoming_pages", .mode = 0444, },
-	.print = pool_stats_print_block_map_incoming_pages,
-};
-
-/* number of pages outgoing */
-static ssize_t
-pool_stats_print_block_map_outgoing_pages(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->block_map.outgoing_pages);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_outgoing_pages = {
-	.attr = { .name = "block_map_outgoing_pages", .mode = 0444, },
-	.print = pool_stats_print_block_map_outgoing_pages,
-};
-
-/* how many times free page not avail */
-static ssize_t
-pool_stats_print_block_map_cache_pressure(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->block_map.cache_pressure);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_cache_pressure = {
-	.attr = { .name = "block_map_cache_pressure", .mode = 0444, },
-	.print = pool_stats_print_block_map_cache_pressure,
-};
-
-/* number of get_vdo_page() calls for read */
-static ssize_t
-pool_stats_print_block_map_read_count(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.read_count);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_read_count = {
-	.attr = { .name = "block_map_read_count", .mode = 0444, },
-	.print = pool_stats_print_block_map_read_count,
-};
-
-/* number of get_vdo_page() calls for write */
-static ssize_t
-pool_stats_print_block_map_write_count(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.write_count);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_write_count = {
-	.attr = { .name = "block_map_write_count", .mode = 0444, },
-	.print = pool_stats_print_block_map_write_count,
-};
-
-/* number of times pages failed to read */
-static ssize_t
-pool_stats_print_block_map_failed_reads(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.failed_reads);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_failed_reads = {
-	.attr = { .name = "block_map_failed_reads", .mode = 0444, },
-	.print = pool_stats_print_block_map_failed_reads,
-};
-
-/* number of times pages failed to write */
-static ssize_t
-pool_stats_print_block_map_failed_writes(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.failed_writes);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_failed_writes = {
-	.attr = { .name = "block_map_failed_writes", .mode = 0444, },
-	.print = pool_stats_print_block_map_failed_writes,
-};
-
-/* number of gets that are reclaimed */
-static ssize_t
-pool_stats_print_block_map_reclaimed(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.reclaimed);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_reclaimed = {
-	.attr = { .name = "block_map_reclaimed", .mode = 0444, },
-	.print = pool_stats_print_block_map_reclaimed,
-};
-
-/* number of gets for outgoing pages */
-static ssize_t
-pool_stats_print_block_map_read_outgoing(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.read_outgoing);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_read_outgoing = {
-	.attr = { .name = "block_map_read_outgoing", .mode = 0444, },
-	.print = pool_stats_print_block_map_read_outgoing,
-};
-
-/* number of gets that were already there */
-static ssize_t
-pool_stats_print_block_map_found_in_cache(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.found_in_cache);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_found_in_cache = {
-	.attr = { .name = "block_map_found_in_cache", .mode = 0444, },
-	.print = pool_stats_print_block_map_found_in_cache,
-};
-
-/* number of gets requiring discard */
-static ssize_t
-pool_stats_print_block_map_discard_required(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.discard_required);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_discard_required = {
-	.attr = { .name = "block_map_discard_required", .mode = 0444, },
-	.print = pool_stats_print_block_map_discard_required,
-};
-
-/* number of gets enqueued for their page */
-static ssize_t
-pool_stats_print_block_map_wait_for_page(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.wait_for_page);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_wait_for_page = {
-	.attr = { .name = "block_map_wait_for_page", .mode = 0444, },
-	.print = pool_stats_print_block_map_wait_for_page,
-};
-
-/* number of gets that have to fetch */
-static ssize_t
-pool_stats_print_block_map_fetch_required(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.fetch_required);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_fetch_required = {
-	.attr = { .name = "block_map_fetch_required", .mode = 0444, },
-	.print = pool_stats_print_block_map_fetch_required,
-};
-
-/* number of page fetches */
-static ssize_t
-pool_stats_print_block_map_pages_loaded(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.pages_loaded);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_pages_loaded = {
-	.attr = { .name = "block_map_pages_loaded", .mode = 0444, },
-	.print = pool_stats_print_block_map_pages_loaded,
-};
-
-/* number of page saves */
-static ssize_t
-pool_stats_print_block_map_pages_saved(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.pages_saved);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_pages_saved = {
-	.attr = { .name = "block_map_pages_saved", .mode = 0444, },
-	.print = pool_stats_print_block_map_pages_saved,
-};
-
-/* the number of flushes issued */
-static ssize_t
-pool_stats_print_block_map_flush_count(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->block_map.flush_count);
-}
-
-static struct pool_stats_attribute pool_stats_attr_block_map_flush_count = {
-	.attr = { .name = "block_map_flush_count", .mode = 0444, },
-	.print = pool_stats_print_block_map_flush_count,
-};
-
-/* Number of times the UDS advice proved correct */
-static ssize_t
-pool_stats_print_hash_lock_dedupe_advice_valid(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->hash_lock.dedupe_advice_valid);
-}
-
-static struct pool_stats_attribute pool_stats_attr_hash_lock_dedupe_advice_valid = {
-	.attr = { .name = "hash_lock_dedupe_advice_valid", .mode = 0444, },
-	.print = pool_stats_print_hash_lock_dedupe_advice_valid,
-};
-
-/* Number of times the UDS advice proved incorrect */
-static ssize_t
-pool_stats_print_hash_lock_dedupe_advice_stale(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->hash_lock.dedupe_advice_stale);
-}
-
-static struct pool_stats_attribute pool_stats_attr_hash_lock_dedupe_advice_stale = {
-	.attr = { .name = "hash_lock_dedupe_advice_stale", .mode = 0444, },
-	.print = pool_stats_print_hash_lock_dedupe_advice_stale,
-};
-
-/* Number of writes with the same data as another in-flight write */
-static ssize_t
-pool_stats_print_hash_lock_concurrent_data_matches(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->hash_lock.concurrent_data_matches);
-}
-
-static struct pool_stats_attribute pool_stats_attr_hash_lock_concurrent_data_matches = {
-	.attr = { .name = "hash_lock_concurrent_data_matches", .mode = 0444, },
-	.print = pool_stats_print_hash_lock_concurrent_data_matches,
-};
-
-/* Number of writes whose hash collided with an in-flight write */
-static ssize_t
-pool_stats_print_hash_lock_concurrent_hash_collisions(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->hash_lock.concurrent_hash_collisions);
-}
-
-static struct pool_stats_attribute pool_stats_attr_hash_lock_concurrent_hash_collisions = {
-	.attr = { .name = "hash_lock_concurrent_hash_collisions", .mode = 0444, },
-	.print = pool_stats_print_hash_lock_concurrent_hash_collisions,
-};
-
-/* Current number of dedupe queries that are in flight */
-static ssize_t
-pool_stats_print_hash_lock_curr_dedupe_queries(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->hash_lock.curr_dedupe_queries);
-}
-
-static struct pool_stats_attribute pool_stats_attr_hash_lock_curr_dedupe_queries = {
-	.attr = { .name = "hash_lock_curr_dedupe_queries", .mode = 0444, },
-	.print = pool_stats_print_hash_lock_curr_dedupe_queries,
-};
-
-/* number of times VDO got an invalid dedupe advice PBN from UDS */
-static ssize_t
-pool_stats_print_errors_invalid_advice_pbn_count(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->errors.invalid_advice_pbn_count);
-}
-
-static struct pool_stats_attribute pool_stats_attr_errors_invalid_advice_pbn_count = {
-	.attr = { .name = "errors_invalid_advice_pbn_count", .mode = 0444, },
-	.print = pool_stats_print_errors_invalid_advice_pbn_count,
-};
-
-/* number of times a VIO completed with a VDO_NO_SPACE error */
-static ssize_t
-pool_stats_print_errors_no_space_error_count(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->errors.no_space_error_count);
-}
-
-static struct pool_stats_attribute pool_stats_attr_errors_no_space_error_count = {
-	.attr = { .name = "errors_no_space_error_count", .mode = 0444, },
-	.print = pool_stats_print_errors_no_space_error_count,
-};
-
-/* number of times a VIO completed with a VDO_READ_ONLY error */
-static ssize_t
-pool_stats_print_errors_read_only_error_count(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->errors.read_only_error_count);
-}
-
-static struct pool_stats_attribute pool_stats_attr_errors_read_only_error_count = {
-	.attr = { .name = "errors_read_only_error_count", .mode = 0444, },
-	.print = pool_stats_print_errors_read_only_error_count,
-};
-
-/* The VDO instance */
-static ssize_t
-pool_stats_print_instance(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->instance);
-}
-
-static struct pool_stats_attribute pool_stats_attr_instance = {
-	.attr = { .name = "instance", .mode = 0444, },
-	.print = pool_stats_print_instance,
-};
-
-/* Current number of active VIOs */
-static ssize_t
-pool_stats_print_current_vios_in_progress(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->current_vios_in_progress);
-}
-
-static struct pool_stats_attribute pool_stats_attr_current_vios_in_progress = {
-	.attr = { .name = "current_vios_in_progress", .mode = 0444, },
-	.print = pool_stats_print_current_vios_in_progress,
-};
-
-/* Maximum number of active VIOs */
-static ssize_t
-pool_stats_print_max_vios(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%u\n", stats->max_vios);
-}
-
-static struct pool_stats_attribute pool_stats_attr_max_vios = {
-	.attr = { .name = "max_vios", .mode = 0444, },
-	.print = pool_stats_print_max_vios,
-};
-
-/* Number of times the UDS index was too slow in responding */
-static ssize_t
-pool_stats_print_dedupe_advice_timeouts(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->dedupe_advice_timeouts);
-}
-
-static struct pool_stats_attribute pool_stats_attr_dedupe_advice_timeouts = {
-	.attr = { .name = "dedupe_advice_timeouts", .mode = 0444, },
-	.print = pool_stats_print_dedupe_advice_timeouts,
-};
-
-/* Number of flush requests submitted to the storage device */
-static ssize_t
-pool_stats_print_flush_out(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->flush_out);
-}
-
-static struct pool_stats_attribute pool_stats_attr_flush_out = {
-	.attr = { .name = "flush_out", .mode = 0444, },
-	.print = pool_stats_print_flush_out,
-};
-
-/* Logical block size */
-static ssize_t
-pool_stats_print_logical_block_size(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->logical_block_size);
-}
-
-static struct pool_stats_attribute pool_stats_attr_logical_block_size = {
-	.attr = { .name = "logical_block_size", .mode = 0444, },
-	.print = pool_stats_print_logical_block_size,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_in_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_read = {
-	.attr = { .name = "bios_in_read", .mode = 0444, },
-	.print = pool_stats_print_bios_in_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_in_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_write = {
-	.attr = { .name = "bios_in_write", .mode = 0444, },
-	.print = pool_stats_print_bios_in_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_in_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_empty_flush = {
-	.attr = { .name = "bios_in_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_in_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_in_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_discard = {
-	.attr = { .name = "bios_in_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_in_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_in_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_flush = {
-	.attr = { .name = "bios_in_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_in_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_in_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_fua = {
-	.attr = { .name = "bios_in_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_in_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_in_partial_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_partial.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_partial_read = {
-	.attr = { .name = "bios_in_partial_read", .mode = 0444, },
-	.print = pool_stats_print_bios_in_partial_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_in_partial_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_partial.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_partial_write = {
-	.attr = { .name = "bios_in_partial_write", .mode = 0444, },
-	.print = pool_stats_print_bios_in_partial_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_in_partial_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_partial.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_partial_empty_flush = {
-	.attr = { .name = "bios_in_partial_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_in_partial_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_in_partial_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_partial.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_partial_discard = {
-	.attr = { .name = "bios_in_partial_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_in_partial_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_in_partial_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_partial.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_partial_flush = {
-	.attr = { .name = "bios_in_partial_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_in_partial_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_in_partial_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_partial.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_partial_fua = {
-	.attr = { .name = "bios_in_partial_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_in_partial_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_out_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_read = {
-	.attr = { .name = "bios_out_read", .mode = 0444, },
-	.print = pool_stats_print_bios_out_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_out_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_write = {
-	.attr = { .name = "bios_out_write", .mode = 0444, },
-	.print = pool_stats_print_bios_out_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_out_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_empty_flush = {
-	.attr = { .name = "bios_out_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_out_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_out_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_discard = {
-	.attr = { .name = "bios_out_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_out_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_out_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_flush = {
-	.attr = { .name = "bios_out_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_out_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_out_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_fua = {
-	.attr = { .name = "bios_out_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_out_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_meta_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_read = {
-	.attr = { .name = "bios_meta_read", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_meta_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_write = {
-	.attr = { .name = "bios_meta_write", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_meta_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_empty_flush = {
-	.attr = { .name = "bios_meta_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_meta_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_discard = {
-	.attr = { .name = "bios_meta_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_meta_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_flush = {
-	.attr = { .name = "bios_meta_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_meta_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_fua = {
-	.attr = { .name = "bios_meta_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_journal_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_read = {
-	.attr = { .name = "bios_journal_read", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_journal_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_write = {
-	.attr = { .name = "bios_journal_write", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_journal_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_empty_flush = {
-	.attr = { .name = "bios_journal_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_journal_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_discard = {
-	.attr = { .name = "bios_journal_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_journal_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_flush = {
-	.attr = { .name = "bios_journal_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_journal_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_fua = {
-	.attr = { .name = "bios_journal_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_page_cache_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_read = {
-	.attr = { .name = "bios_page_cache_read", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_page_cache_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_write = {
-	.attr = { .name = "bios_page_cache_write", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_page_cache_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_empty_flush = {
-	.attr = { .name = "bios_page_cache_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_page_cache_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_discard = {
-	.attr = { .name = "bios_page_cache_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_page_cache_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_flush = {
-	.attr = { .name = "bios_page_cache_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_page_cache_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_fua = {
-	.attr = { .name = "bios_page_cache_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_out_completed_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out_completed.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_completed_read = {
-	.attr = { .name = "bios_out_completed_read", .mode = 0444, },
-	.print = pool_stats_print_bios_out_completed_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_out_completed_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out_completed.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_completed_write = {
-	.attr = { .name = "bios_out_completed_write", .mode = 0444, },
-	.print = pool_stats_print_bios_out_completed_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_out_completed_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out_completed.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_completed_empty_flush = {
-	.attr = { .name = "bios_out_completed_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_out_completed_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_out_completed_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out_completed.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_completed_discard = {
-	.attr = { .name = "bios_out_completed_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_out_completed_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_out_completed_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out_completed.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_completed_flush = {
-	.attr = { .name = "bios_out_completed_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_out_completed_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_out_completed_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_out_completed.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_out_completed_fua = {
-	.attr = { .name = "bios_out_completed_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_out_completed_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_meta_completed_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta_completed.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_read = {
-	.attr = { .name = "bios_meta_completed_read", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_completed_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_meta_completed_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta_completed.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_write = {
-	.attr = { .name = "bios_meta_completed_write", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_completed_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_meta_completed_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta_completed.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_empty_flush = {
-	.attr = { .name = "bios_meta_completed_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_completed_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_meta_completed_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta_completed.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_discard = {
-	.attr = { .name = "bios_meta_completed_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_completed_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_meta_completed_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta_completed.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_flush = {
-	.attr = { .name = "bios_meta_completed_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_completed_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_meta_completed_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_meta_completed.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_fua = {
-	.attr = { .name = "bios_meta_completed_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_meta_completed_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_journal_completed_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal_completed.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_read = {
-	.attr = { .name = "bios_journal_completed_read", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_completed_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_journal_completed_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal_completed.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_write = {
-	.attr = { .name = "bios_journal_completed_write", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_completed_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_journal_completed_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal_completed.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_empty_flush = {
-	.attr = { .name = "bios_journal_completed_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_completed_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_journal_completed_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal_completed.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_discard = {
-	.attr = { .name = "bios_journal_completed_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_completed_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_journal_completed_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal_completed.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_flush = {
-	.attr = { .name = "bios_journal_completed_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_completed_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_journal_completed_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_journal_completed.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_fua = {
-	.attr = { .name = "bios_journal_completed_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_journal_completed_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_page_cache_completed_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_read = {
-	.attr = { .name = "bios_page_cache_completed_read", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_completed_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_page_cache_completed_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_write = {
-	.attr = { .name = "bios_page_cache_completed_write", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_completed_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_page_cache_completed_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_empty_flush = {
-	.attr = { .name = "bios_page_cache_completed_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_completed_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_page_cache_completed_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_discard = {
-	.attr = { .name = "bios_page_cache_completed_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_completed_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_page_cache_completed_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_flush = {
-	.attr = { .name = "bios_page_cache_completed_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_completed_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_page_cache_completed_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_fua = {
-	.attr = { .name = "bios_page_cache_completed_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_page_cache_completed_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_acknowledged_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_read = {
-	.attr = { .name = "bios_acknowledged_read", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_acknowledged_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_write = {
-	.attr = { .name = "bios_acknowledged_write", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_acknowledged_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_empty_flush = {
-	.attr = { .name = "bios_acknowledged_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_acknowledged_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_discard = {
-	.attr = { .name = "bios_acknowledged_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_acknowledged_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_flush = {
-	.attr = { .name = "bios_acknowledged_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_acknowledged_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_fua = {
-	.attr = { .name = "bios_acknowledged_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_acknowledged_partial_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_read = {
-	.attr = { .name = "bios_acknowledged_partial_read", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_partial_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_acknowledged_partial_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_write = {
-	.attr = { .name = "bios_acknowledged_partial_write", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_partial_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_acknowledged_partial_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_empty_flush = {
-	.attr = { .name = "bios_acknowledged_partial_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_partial_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_acknowledged_partial_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_discard = {
-	.attr = { .name = "bios_acknowledged_partial_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_partial_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_acknowledged_partial_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_flush = {
-	.attr = { .name = "bios_acknowledged_partial_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_partial_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_acknowledged_partial_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_fua = {
-	.attr = { .name = "bios_acknowledged_partial_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_acknowledged_partial_fua,
-};
-
-/* Number of REQ_OP_READ bios */
-static ssize_t
-pool_stats_print_bios_in_progress_read(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_progress.read);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_progress_read = {
-	.attr = { .name = "bios_in_progress_read", .mode = 0444, },
-	.print = pool_stats_print_bios_in_progress_read,
-};
-
-/* Number of REQ_OP_WRITE bios with data */
-static ssize_t
-pool_stats_print_bios_in_progress_write(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_progress.write);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_progress_write = {
-	.attr = { .name = "bios_in_progress_write", .mode = 0444, },
-	.print = pool_stats_print_bios_in_progress_write,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH and containing no data */
-static ssize_t
-pool_stats_print_bios_in_progress_empty_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_progress.empty_flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_progress_empty_flush = {
-	.attr = { .name = "bios_in_progress_empty_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_in_progress_empty_flush,
-};
-
-/* Number of REQ_OP_DISCARD bios */
-static ssize_t
-pool_stats_print_bios_in_progress_discard(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_progress.discard);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_progress_discard = {
-	.attr = { .name = "bios_in_progress_discard", .mode = 0444, },
-	.print = pool_stats_print_bios_in_progress_discard,
-};
-
-/* Number of bios tagged with REQ_PREFLUSH */
-static ssize_t
-pool_stats_print_bios_in_progress_flush(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_progress.flush);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_progress_flush = {
-	.attr = { .name = "bios_in_progress_flush", .mode = 0444, },
-	.print = pool_stats_print_bios_in_progress_flush,
-};
-
-/* Number of bios tagged with REQ_FUA */
-static ssize_t
-pool_stats_print_bios_in_progress_fua(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->bios_in_progress.fua);
-}
-
-static struct pool_stats_attribute pool_stats_attr_bios_in_progress_fua = {
-	.attr = { .name = "bios_in_progress_fua", .mode = 0444, },
-	.print = pool_stats_print_bios_in_progress_fua,
-};
-
-/* Tracked bytes currently allocated. */
-static ssize_t
-pool_stats_print_memory_usage_bytes_used(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->memory_usage.bytes_used);
-}
-
-static struct pool_stats_attribute pool_stats_attr_memory_usage_bytes_used = {
-	.attr = { .name = "memory_usage_bytes_used", .mode = 0444, },
-	.print = pool_stats_print_memory_usage_bytes_used,
-};
-
-/* Maximum tracked bytes allocated. */
-static ssize_t
-pool_stats_print_memory_usage_peak_bytes_used(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->memory_usage.peak_bytes_used);
-}
-
-static struct pool_stats_attribute pool_stats_attr_memory_usage_peak_bytes_used = {
-	.attr = { .name = "memory_usage_peak_bytes_used", .mode = 0444, },
-	.print = pool_stats_print_memory_usage_peak_bytes_used,
-};
-
-/* Number of records stored in the index */
-static ssize_t
-pool_stats_print_index_entries_indexed(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->index.entries_indexed);
-}
-
-static struct pool_stats_attribute pool_stats_attr_index_entries_indexed = {
-	.attr = { .name = "index_entries_indexed", .mode = 0444, },
-	.print = pool_stats_print_index_entries_indexed,
-};
-
-/* Number of post calls that found an existing entry */
-static ssize_t
-pool_stats_print_index_posts_found(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->index.posts_found);
-}
-
-static struct pool_stats_attribute pool_stats_attr_index_posts_found = {
-	.attr = { .name = "index_posts_found", .mode = 0444, },
-	.print = pool_stats_print_index_posts_found,
-};
-
-/* Number of post calls that added a new entry */
-static ssize_t
-pool_stats_print_index_posts_not_found(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->index.posts_not_found);
-}
-
-static struct pool_stats_attribute pool_stats_attr_index_posts_not_found = {
-	.attr = { .name = "index_posts_not_found", .mode = 0444, },
-	.print = pool_stats_print_index_posts_not_found,
-};
-
-/* Number of query calls that found an existing entry */
-static ssize_t
-pool_stats_print_index_queries_found(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->index.queries_found);
-}
-
-static struct pool_stats_attribute pool_stats_attr_index_queries_found = {
-	.attr = { .name = "index_queries_found", .mode = 0444, },
-	.print = pool_stats_print_index_queries_found,
-};
-
-/* Number of query calls that added a new entry */
-static ssize_t
-pool_stats_print_index_queries_not_found(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->index.queries_not_found);
-}
-
-static struct pool_stats_attribute pool_stats_attr_index_queries_not_found = {
-	.attr = { .name = "index_queries_not_found", .mode = 0444, },
-	.print = pool_stats_print_index_queries_not_found,
-};
-
-/* Number of update calls that found an existing entry */
-static ssize_t
-pool_stats_print_index_updates_found(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->index.updates_found);
-}
-
-static struct pool_stats_attribute pool_stats_attr_index_updates_found = {
-	.attr = { .name = "index_updates_found", .mode = 0444, },
-	.print = pool_stats_print_index_updates_found,
-};
-
-/* Number of update calls that added a new entry */
-static ssize_t
-pool_stats_print_index_updates_not_found(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->index.updates_not_found);
-}
-
-static struct pool_stats_attribute pool_stats_attr_index_updates_not_found = {
-	.attr = { .name = "index_updates_not_found", .mode = 0444, },
-	.print = pool_stats_print_index_updates_not_found,
-};
-
-/* Number of entries discarded */
-static ssize_t
-pool_stats_print_index_entries_discarded(struct vdo_statistics *stats, char *buf)
-{
-	return sprintf(buf, "%llu\n", stats->index.entries_discarded);
-}
-
-static struct pool_stats_attribute pool_stats_attr_index_entries_discarded = {
-	.attr = { .name = "index_entries_discarded", .mode = 0444, },
-	.print = pool_stats_print_index_entries_discarded,
-};
-
-struct attribute *vdo_pool_stats_attrs[] = {
-	&pool_stats_attr_data_blocks_used.attr,
-	&pool_stats_attr_overhead_blocks_used.attr,
-	&pool_stats_attr_logical_blocks_used.attr,
-	&pool_stats_attr_physical_blocks.attr,
-	&pool_stats_attr_logical_blocks.attr,
-	&pool_stats_attr_block_map_cache_size.attr,
-	&pool_stats_attr_block_size.attr,
-	&pool_stats_attr_complete_recoveries.attr,
-	&pool_stats_attr_read_only_recoveries.attr,
-	&pool_stats_attr_mode.attr,
-	&pool_stats_attr_in_recovery_mode.attr,
-	&pool_stats_attr_recovery_percentage.attr,
-	&pool_stats_attr_packer_compressed_fragments_written.attr,
-	&pool_stats_attr_packer_compressed_blocks_written.attr,
-	&pool_stats_attr_packer_compressed_fragments_in_packer.attr,
-	&pool_stats_attr_allocator_slab_count.attr,
-	&pool_stats_attr_allocator_slabs_opened.attr,
-	&pool_stats_attr_allocator_slabs_reopened.attr,
-	&pool_stats_attr_journal_disk_full.attr,
-	&pool_stats_attr_journal_slab_journal_commits_requested.attr,
-	&pool_stats_attr_journal_entries_started.attr,
-	&pool_stats_attr_journal_entries_written.attr,
-	&pool_stats_attr_journal_entries_committed.attr,
-	&pool_stats_attr_journal_blocks_started.attr,
-	&pool_stats_attr_journal_blocks_written.attr,
-	&pool_stats_attr_journal_blocks_committed.attr,
-	&pool_stats_attr_slab_journal_disk_full_count.attr,
-	&pool_stats_attr_slab_journal_flush_count.attr,
-	&pool_stats_attr_slab_journal_blocked_count.attr,
-	&pool_stats_attr_slab_journal_blocks_written.attr,
-	&pool_stats_attr_slab_journal_tail_busy_count.attr,
-	&pool_stats_attr_slab_summary_blocks_written.attr,
-	&pool_stats_attr_ref_counts_blocks_written.attr,
-	&pool_stats_attr_block_map_dirty_pages.attr,
-	&pool_stats_attr_block_map_clean_pages.attr,
-	&pool_stats_attr_block_map_free_pages.attr,
-	&pool_stats_attr_block_map_failed_pages.attr,
-	&pool_stats_attr_block_map_incoming_pages.attr,
-	&pool_stats_attr_block_map_outgoing_pages.attr,
-	&pool_stats_attr_block_map_cache_pressure.attr,
-	&pool_stats_attr_block_map_read_count.attr,
-	&pool_stats_attr_block_map_write_count.attr,
-	&pool_stats_attr_block_map_failed_reads.attr,
-	&pool_stats_attr_block_map_failed_writes.attr,
-	&pool_stats_attr_block_map_reclaimed.attr,
-	&pool_stats_attr_block_map_read_outgoing.attr,
-	&pool_stats_attr_block_map_found_in_cache.attr,
-	&pool_stats_attr_block_map_discard_required.attr,
-	&pool_stats_attr_block_map_wait_for_page.attr,
-	&pool_stats_attr_block_map_fetch_required.attr,
-	&pool_stats_attr_block_map_pages_loaded.attr,
-	&pool_stats_attr_block_map_pages_saved.attr,
-	&pool_stats_attr_block_map_flush_count.attr,
-	&pool_stats_attr_hash_lock_dedupe_advice_valid.attr,
-	&pool_stats_attr_hash_lock_dedupe_advice_stale.attr,
-	&pool_stats_attr_hash_lock_concurrent_data_matches.attr,
-	&pool_stats_attr_hash_lock_concurrent_hash_collisions.attr,
-	&pool_stats_attr_hash_lock_curr_dedupe_queries.attr,
-	&pool_stats_attr_errors_invalid_advice_pbn_count.attr,
-	&pool_stats_attr_errors_no_space_error_count.attr,
-	&pool_stats_attr_errors_read_only_error_count.attr,
-	&pool_stats_attr_instance.attr,
-	&pool_stats_attr_current_vios_in_progress.attr,
-	&pool_stats_attr_max_vios.attr,
-	&pool_stats_attr_dedupe_advice_timeouts.attr,
-	&pool_stats_attr_flush_out.attr,
-	&pool_stats_attr_logical_block_size.attr,
-	&pool_stats_attr_bios_in_read.attr,
-	&pool_stats_attr_bios_in_write.attr,
-	&pool_stats_attr_bios_in_empty_flush.attr,
-	&pool_stats_attr_bios_in_discard.attr,
-	&pool_stats_attr_bios_in_flush.attr,
-	&pool_stats_attr_bios_in_fua.attr,
-	&pool_stats_attr_bios_in_partial_read.attr,
-	&pool_stats_attr_bios_in_partial_write.attr,
-	&pool_stats_attr_bios_in_partial_empty_flush.attr,
-	&pool_stats_attr_bios_in_partial_discard.attr,
-	&pool_stats_attr_bios_in_partial_flush.attr,
-	&pool_stats_attr_bios_in_partial_fua.attr,
-	&pool_stats_attr_bios_out_read.attr,
-	&pool_stats_attr_bios_out_write.attr,
-	&pool_stats_attr_bios_out_empty_flush.attr,
-	&pool_stats_attr_bios_out_discard.attr,
-	&pool_stats_attr_bios_out_flush.attr,
-	&pool_stats_attr_bios_out_fua.attr,
-	&pool_stats_attr_bios_meta_read.attr,
-	&pool_stats_attr_bios_meta_write.attr,
-	&pool_stats_attr_bios_meta_empty_flush.attr,
-	&pool_stats_attr_bios_meta_discard.attr,
-	&pool_stats_attr_bios_meta_flush.attr,
-	&pool_stats_attr_bios_meta_fua.attr,
-	&pool_stats_attr_bios_journal_read.attr,
-	&pool_stats_attr_bios_journal_write.attr,
-	&pool_stats_attr_bios_journal_empty_flush.attr,
-	&pool_stats_attr_bios_journal_discard.attr,
-	&pool_stats_attr_bios_journal_flush.attr,
-	&pool_stats_attr_bios_journal_fua.attr,
-	&pool_stats_attr_bios_page_cache_read.attr,
-	&pool_stats_attr_bios_page_cache_write.attr,
-	&pool_stats_attr_bios_page_cache_empty_flush.attr,
-	&pool_stats_attr_bios_page_cache_discard.attr,
-	&pool_stats_attr_bios_page_cache_flush.attr,
-	&pool_stats_attr_bios_page_cache_fua.attr,
-	&pool_stats_attr_bios_out_completed_read.attr,
-	&pool_stats_attr_bios_out_completed_write.attr,
-	&pool_stats_attr_bios_out_completed_empty_flush.attr,
-	&pool_stats_attr_bios_out_completed_discard.attr,
-	&pool_stats_attr_bios_out_completed_flush.attr,
-	&pool_stats_attr_bios_out_completed_fua.attr,
-	&pool_stats_attr_bios_meta_completed_read.attr,
-	&pool_stats_attr_bios_meta_completed_write.attr,
-	&pool_stats_attr_bios_meta_completed_empty_flush.attr,
-	&pool_stats_attr_bios_meta_completed_discard.attr,
-	&pool_stats_attr_bios_meta_completed_flush.attr,
-	&pool_stats_attr_bios_meta_completed_fua.attr,
-	&pool_stats_attr_bios_journal_completed_read.attr,
-	&pool_stats_attr_bios_journal_completed_write.attr,
-	&pool_stats_attr_bios_journal_completed_empty_flush.attr,
-	&pool_stats_attr_bios_journal_completed_discard.attr,
-	&pool_stats_attr_bios_journal_completed_flush.attr,
-	&pool_stats_attr_bios_journal_completed_fua.attr,
-	&pool_stats_attr_bios_page_cache_completed_read.attr,
-	&pool_stats_attr_bios_page_cache_completed_write.attr,
-	&pool_stats_attr_bios_page_cache_completed_empty_flush.attr,
-	&pool_stats_attr_bios_page_cache_completed_discard.attr,
-	&pool_stats_attr_bios_page_cache_completed_flush.attr,
-	&pool_stats_attr_bios_page_cache_completed_fua.attr,
-	&pool_stats_attr_bios_acknowledged_read.attr,
-	&pool_stats_attr_bios_acknowledged_write.attr,
-	&pool_stats_attr_bios_acknowledged_empty_flush.attr,
-	&pool_stats_attr_bios_acknowledged_discard.attr,
-	&pool_stats_attr_bios_acknowledged_flush.attr,
-	&pool_stats_attr_bios_acknowledged_fua.attr,
-	&pool_stats_attr_bios_acknowledged_partial_read.attr,
-	&pool_stats_attr_bios_acknowledged_partial_write.attr,
-	&pool_stats_attr_bios_acknowledged_partial_empty_flush.attr,
-	&pool_stats_attr_bios_acknowledged_partial_discard.attr,
-	&pool_stats_attr_bios_acknowledged_partial_flush.attr,
-	&pool_stats_attr_bios_acknowledged_partial_fua.attr,
-	&pool_stats_attr_bios_in_progress_read.attr,
-	&pool_stats_attr_bios_in_progress_write.attr,
-	&pool_stats_attr_bios_in_progress_empty_flush.attr,
-	&pool_stats_attr_bios_in_progress_discard.attr,
-	&pool_stats_attr_bios_in_progress_flush.attr,
-	&pool_stats_attr_bios_in_progress_fua.attr,
-	&pool_stats_attr_memory_usage_bytes_used.attr,
-	&pool_stats_attr_memory_usage_peak_bytes_used.attr,
-	&pool_stats_attr_index_entries_indexed.attr,
-	&pool_stats_attr_index_posts_found.attr,
-	&pool_stats_attr_index_posts_not_found.attr,
-	&pool_stats_attr_index_queries_found.attr,
-	&pool_stats_attr_index_queries_not_found.attr,
-	&pool_stats_attr_index_updates_found.attr,
-	&pool_stats_attr_index_updates_not_found.attr,
-	&pool_stats_attr_index_entries_discarded.attr,
-	NULL,
-};
diff --git a/drivers/md/dm-vdo/pool-sysfs.c b/drivers/md/dm-vdo/pool-sysfs.c
deleted file mode 100644
index 6769c5711cbc..000000000000
--- a/drivers/md/dm-vdo/pool-sysfs.c
+++ /dev/null
@@ -1,198 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2023 Red Hat
- */
-
-#include "pool-sysfs.h"
-
-#include <linux/kstrtox.h>
-
-#include "memory-alloc.h"
-#include "string-utils.h"
-
-#include "data-vio.h"
-#include "dedupe.h"
-#include "vdo.h"
-
-struct pool_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct vdo *vdo, char *buf);
-	ssize_t (*store)(struct vdo *vdo, const char *value, size_t count);
-};
-
-static ssize_t vdo_pool_attr_show(struct kobject *directory, struct attribute *attr,
-				  char *buf)
-{
-	struct pool_attribute *pool_attr = container_of(attr, struct pool_attribute,
-							attr);
-	struct vdo *vdo = container_of(directory, struct vdo, vdo_directory);
-
-	if (pool_attr->show == NULL)
-		return -EINVAL;
-	return pool_attr->show(vdo, buf);
-}
-
-static ssize_t vdo_pool_attr_store(struct kobject *directory, struct attribute *attr,
-				   const char *buf, size_t length)
-{
-	struct pool_attribute *pool_attr = container_of(attr, struct pool_attribute,
-							attr);
-	struct vdo *vdo = container_of(directory, struct vdo, vdo_directory);
-
-	if (pool_attr->store == NULL)
-		return -EINVAL;
-	return pool_attr->store(vdo, buf, length);
-}
-
-static const struct sysfs_ops vdo_pool_sysfs_ops = {
-	.show = vdo_pool_attr_show,
-	.store = vdo_pool_attr_store,
-};
-
-static ssize_t pool_compressing_show(struct vdo *vdo, char *buf)
-{
-	return sprintf(buf, "%s\n", (vdo_get_compressing(vdo) ? "1" : "0"));
-}
-
-static ssize_t pool_discards_active_show(struct vdo *vdo, char *buf)
-{
-	return sprintf(buf, "%u\n",
-		       get_data_vio_pool_active_discards(vdo->data_vio_pool));
-}
-
-static ssize_t pool_discards_limit_show(struct vdo *vdo, char *buf)
-{
-	return sprintf(buf, "%u\n", get_data_vio_pool_discard_limit(vdo->data_vio_pool));
-}
-
-static ssize_t pool_discards_limit_store(struct vdo *vdo, const char *buf, size_t length)
-{
-	unsigned int value;
-	int result;
-
-	if ((length > 12) || (kstrtouint(buf, 10, &value) < 0) || (value < 1))
-		return -EINVAL;
-
-	result = set_data_vio_pool_discard_limit(vdo->data_vio_pool, value);
-	if (result != VDO_SUCCESS)
-		return -EINVAL;
-
-	return length;
-}
-
-static ssize_t pool_discards_maximum_show(struct vdo *vdo, char *buf)
-{
-	return sprintf(buf, "%u\n",
-		       get_data_vio_pool_maximum_discards(vdo->data_vio_pool));
-}
-
-static ssize_t pool_instance_show(struct vdo *vdo, char *buf)
-{
-	return sprintf(buf, "%u\n", vdo->instance);
-}
-
-static ssize_t pool_requests_active_show(struct vdo *vdo, char *buf)
-{
-	return sprintf(buf, "%u\n",
-		       get_data_vio_pool_active_requests(vdo->data_vio_pool));
-}
-
-static ssize_t pool_requests_limit_show(struct vdo *vdo, char *buf)
-{
-	return sprintf(buf, "%u\n", get_data_vio_pool_request_limit(vdo->data_vio_pool));
-}
-
-static ssize_t pool_requests_maximum_show(struct vdo *vdo, char *buf)
-{
-	return sprintf(buf, "%u\n",
-		       get_data_vio_pool_maximum_requests(vdo->data_vio_pool));
-}
-
-static void vdo_pool_release(struct kobject *directory)
-{
-	vdo_free(container_of(directory, struct vdo, vdo_directory));
-}
-
-static struct pool_attribute vdo_pool_compressing_attr = {
-	.attr = {
-			.name = "compressing",
-			.mode = 0444,
-		},
-	.show = pool_compressing_show,
-};
-
-static struct pool_attribute vdo_pool_discards_active_attr = {
-	.attr = {
-			.name = "discards_active",
-			.mode = 0444,
-		},
-	.show = pool_discards_active_show,
-};
-
-static struct pool_attribute vdo_pool_discards_limit_attr = {
-	.attr = {
-			.name = "discards_limit",
-			.mode = 0644,
-		},
-	.show = pool_discards_limit_show,
-	.store = pool_discards_limit_store,
-};
-
-static struct pool_attribute vdo_pool_discards_maximum_attr = {
-	.attr = {
-			.name = "discards_maximum",
-			.mode = 0444,
-		},
-	.show = pool_discards_maximum_show,
-};
-
-static struct pool_attribute vdo_pool_instance_attr = {
-	.attr = {
-			.name = "instance",
-			.mode = 0444,
-		},
-	.show = pool_instance_show,
-};
-
-static struct pool_attribute vdo_pool_requests_active_attr = {
-	.attr = {
-			.name = "requests_active",
-			.mode = 0444,
-		},
-	.show = pool_requests_active_show,
-};
-
-static struct pool_attribute vdo_pool_requests_limit_attr = {
-	.attr = {
-			.name = "requests_limit",
-			.mode = 0444,
-		},
-	.show = pool_requests_limit_show,
-};
-
-static struct pool_attribute vdo_pool_requests_maximum_attr = {
-	.attr = {
-			.name = "requests_maximum",
-			.mode = 0444,
-		},
-	.show = pool_requests_maximum_show,
-};
-
-static struct attribute *pool_attrs[] = {
-	&vdo_pool_compressing_attr.attr,
-	&vdo_pool_discards_active_attr.attr,
-	&vdo_pool_discards_limit_attr.attr,
-	&vdo_pool_discards_maximum_attr.attr,
-	&vdo_pool_instance_attr.attr,
-	&vdo_pool_requests_active_attr.attr,
-	&vdo_pool_requests_limit_attr.attr,
-	&vdo_pool_requests_maximum_attr.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(pool);
-
-const struct kobj_type vdo_directory_type = {
-	.release = vdo_pool_release,
-	.sysfs_ops = &vdo_pool_sysfs_ops,
-	.default_groups = pool_groups,
-};
diff --git a/drivers/md/dm-vdo/pool-sysfs.h b/drivers/md/dm-vdo/pool-sysfs.h
deleted file mode 100644
index 00e680924dc1..000000000000
--- a/drivers/md/dm-vdo/pool-sysfs.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright 2023 Red Hat
- */
-
-#ifndef VDO_POOL_SYSFS_H
-#define VDO_POOL_SYSFS_H
-
-#include <linux/kobject.h>
-
-/* The kobj_type used for setting up the kernel layer kobject. */
-extern const struct kobj_type vdo_directory_type;
-
-/* The sysfs_ops used for the "statistics" subdirectory. */
-extern const struct sysfs_ops vdo_pool_stats_sysfs_ops;
-/* The attribute used for the "statistics" subdirectory. */
-extern struct attribute *vdo_pool_stats_attrs[];
-
-#endif /* VDO_POOL_SYSFS_H */
diff --git a/drivers/md/dm-vdo/status-codes.c b/drivers/md/dm-vdo/status-codes.c
index 92c42b8bbb8b..42e87b2344bc 100644
--- a/drivers/md/dm-vdo/status-codes.c
+++ b/drivers/md/dm-vdo/status-codes.c
@@ -38,7 +38,6 @@ const struct error_info vdo_status_list[] = {
 	{ "VDO_BAD_NONCE", "Bad nonce" },
 	{ "VDO_JOURNAL_OVERFLOW", "Journal sequence number overflow" },
 	{ "VDO_INVALID_ADMIN_STATE", "Invalid operation for current state" },
-	{ "VDO_CANT_ADD_SYSFS_NODE", "Failed to add sysfs node" },
 };
 
 static atomic_t vdo_status_codes_registered = ATOMIC_INIT(0);
diff --git a/drivers/md/dm-vdo/status-codes.h b/drivers/md/dm-vdo/status-codes.h
index eb847def8eb4..72da04159f88 100644
--- a/drivers/md/dm-vdo/status-codes.h
+++ b/drivers/md/dm-vdo/status-codes.h
@@ -72,8 +72,6 @@ enum vdo_status_codes {
 	VDO_JOURNAL_OVERFLOW,
 	/* the VDO is not in a state to perform an admin operation */
 	VDO_INVALID_ADMIN_STATE,
-	/* failure adding a sysfs node */
-	VDO_CANT_ADD_SYSFS_NODE,
 	/* one more than last error code */
 	VDO_STATUS_CODE_LAST,
 	VDO_STATUS_CODE_BLOCK_END = VDO_ERRORS_BLOCK_END
diff --git a/drivers/md/dm-vdo/sysfs.c b/drivers/md/dm-vdo/sysfs.c
deleted file mode 100644
index 70feffe9d4c4..000000000000
--- a/drivers/md/dm-vdo/sysfs.c
+++ /dev/null
@@ -1,82 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2023 Red Hat
- */
-
-#include <linux/module.h>
-
-#include "logger.h"
-
-#include "constants.h"
-#include "dedupe.h"
-#include "vdo.h"
-
-static int vdo_log_level_show(char *buf, const struct kernel_param *kp)
-{
-	return sprintf(buf, "%s\n", uds_log_priority_to_string(uds_get_log_level()));
-}
-
-static int vdo_log_level_store(const char *buf, const struct kernel_param *kp)
-{
-	static char internal_buf[11];
-
-	int n = strlen(buf);
-
-	if (n > 10)
-		return -EINVAL;
-
-	memset(internal_buf, '\000', sizeof(internal_buf));
-	memcpy(internal_buf, buf, n);
-	if (internal_buf[n - 1] == '\n')
-		internal_buf[n - 1] = '\000';
-	uds_set_log_level(uds_log_string_to_priority(internal_buf));
-	return 0;
-}
-
-
-static int vdo_dedupe_timeout_interval_store(const char *buf,
-					     const struct kernel_param *kp)
-{
-	int result = param_set_uint(buf, kp);
-
-	if (result != 0)
-		return result;
-	vdo_set_dedupe_index_timeout_interval(*(uint *)kp->arg);
-	return 0;
-}
-
-static int vdo_min_dedupe_timer_interval_store(const char *buf,
-					       const struct kernel_param *kp)
-{
-	int result = param_set_uint(buf, kp);
-
-	if (result != 0)
-		return result;
-	vdo_set_dedupe_index_min_timer_interval(*(uint *)kp->arg);
-	return 0;
-}
-
-static const struct kernel_param_ops log_level_ops = {
-	.set = vdo_log_level_store,
-	.get = vdo_log_level_show,
-};
-
-
-static const struct kernel_param_ops dedupe_timeout_ops = {
-	.set = vdo_dedupe_timeout_interval_store,
-	.get = param_get_uint,
-};
-
-static const struct kernel_param_ops dedupe_timer_ops = {
-	.set = vdo_min_dedupe_timer_interval_store,
-	.get = param_get_uint,
-};
-
-module_param_cb(log_level, &log_level_ops, NULL, 0644);
-
-
-module_param_cb(deduplication_timeout_interval, &dedupe_timeout_ops,
-		&vdo_dedupe_index_timeout_interval, 0644);
-
-module_param_cb(min_deduplication_timer_interval, &dedupe_timer_ops,
-		&vdo_dedupe_index_min_timer_interval, 0644);
diff --git a/drivers/md/dm-vdo/uds-sysfs.c b/drivers/md/dm-vdo/uds-sysfs.c
deleted file mode 100644
index 753d81d6f207..000000000000
--- a/drivers/md/dm-vdo/uds-sysfs.c
+++ /dev/null
@@ -1,187 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2023 Red Hat
- */
-
-#include "uds-sysfs.h"
-
-#include <linux/kobject.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-
-#include "logger.h"
-#include "memory-alloc.h"
-#include "string-utils.h"
-
-#include "indexer.h"
-
-#define UDS_SYSFS_NAME "uds"
-
-static struct {
-	/* /sys/uds */
-	struct kobject kobj;
-	/* /sys/uds/parameter */
-	struct kobject parameter_kobj;
-
-	/* These flags are used to ensure a clean shutdown */
-
-	/* /sys/uds flag */
-	bool flag;
-	/* /sys/uds/parameter flag */
-	bool parameter_flag;
-} object_root;
-
-static char *buffer_to_string(const char *buf, size_t length)
-{
-	char *string;
-
-	if (vdo_allocate(length + 1, char, __func__, &string) != VDO_SUCCESS)
-		return NULL;
-
-	memcpy(string, buf, length);
-	string[length] = '\0';
-	if (string[length - 1] == '\n')
-		string[length - 1] = '\0';
-
-	return string;
-}
-
-/*
- * This is the code for any directory in the /sys/<module_name> tree that contains no regular files
- * (only subdirectories).
- */
-
-static void empty_release(struct kobject *kobj)
-{
-}
-
-static ssize_t empty_show(struct kobject *kobj, struct attribute *attr, char *buf)
-{
-	return 0;
-}
-
-static ssize_t empty_store(struct kobject *kobj, struct attribute *attr, const char *buf,
-			   size_t length)
-{
-	return length;
-}
-
-static const struct sysfs_ops empty_ops = {
-	.show = empty_show,
-	.store = empty_store,
-};
-
-static struct attribute *empty_attrs[] = {
-	NULL,
-};
-ATTRIBUTE_GROUPS(empty);
-
-static const struct kobj_type empty_object_type = {
-	.release = empty_release,
-	.sysfs_ops = &empty_ops,
-	.default_groups = empty_groups,
-};
-
-/*
- * This is the code for the /sys/<module_name>/parameter directory.
- * <dir>/log_level                 UDS_LOG_LEVEL
- */
-
-struct parameter_attribute {
-	struct attribute attr;
-	const char *(*show_string)(void);
-	void (*store_string)(const char *string);
-};
-
-static ssize_t parameter_show(struct kobject *kobj, struct attribute *attr, char *buf)
-{
-	struct parameter_attribute *pa;
-
-	pa = container_of(attr, struct parameter_attribute, attr);
-	if (pa->show_string != NULL)
-		return sprintf(buf, "%s\n", pa->show_string());
-	else
-		return -EINVAL;
-}
-
-static ssize_t parameter_store(struct kobject *kobj, struct attribute *attr,
-			       const char *buf, size_t length)
-{
-	char *string;
-	struct parameter_attribute *pa;
-
-	pa = container_of(attr, struct parameter_attribute, attr);
-	if (pa->store_string == NULL)
-		return -EINVAL;
-	string = buffer_to_string(buf, length);
-	if (string == NULL)
-		return -ENOMEM;
-
-	pa->store_string(string);
-	vdo_free(string);
-	return length;
-}
-
-static const char *parameter_show_log_level(void)
-{
-	return uds_log_priority_to_string(uds_get_log_level());
-}
-
-static void parameter_store_log_level(const char *string)
-{
-	uds_set_log_level(uds_log_string_to_priority(string));
-}
-
-static struct parameter_attribute log_level_attr = {
-	.attr = { .name = "log_level", .mode = 0600 },
-	.show_string = parameter_show_log_level,
-	.store_string = parameter_store_log_level,
-};
-
-static struct attribute *parameter_attrs[] = {
-	&log_level_attr.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(parameter);
-
-static const struct sysfs_ops parameter_ops = {
-	.show = parameter_show,
-	.store = parameter_store,
-};
-
-static const struct kobj_type parameter_object_type = {
-	.release = empty_release,
-	.sysfs_ops = &parameter_ops,
-	.default_groups = parameter_groups,
-};
-
-int uds_init_sysfs(void)
-{
-	int result;
-
-	memset(&object_root, 0, sizeof(object_root));
-	kobject_init(&object_root.kobj, &empty_object_type);
-	result = kobject_add(&object_root.kobj, NULL, UDS_SYSFS_NAME);
-	if (result == 0) {
-		object_root.flag = true;
-		kobject_init(&object_root.parameter_kobj, &parameter_object_type);
-		result = kobject_add(&object_root.parameter_kobj, &object_root.kobj,
-				     "parameter");
-		if (result == 0)
-			object_root.parameter_flag = true;
-	}
-
-	if (result != 0)
-		uds_put_sysfs();
-
-	return result;
-}
-
-void uds_put_sysfs(void)
-{
-	if (object_root.parameter_flag)
-		kobject_put(&object_root.parameter_kobj);
-
-	if (object_root.flag)
-		kobject_put(&object_root.kobj);
-}
diff --git a/drivers/md/dm-vdo/uds-sysfs.h b/drivers/md/dm-vdo/uds-sysfs.h
deleted file mode 100644
index c3d00a7187bd..000000000000
--- a/drivers/md/dm-vdo/uds-sysfs.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright 2023 Red Hat
- */
-
-#ifndef UDS_SYSFS_H
-#define UDS_SYSFS_H
-
-int uds_init_sysfs(void);
-void uds_put_sysfs(void);
-
-#endif  /* UDS_SYSFS_H */
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 11be2ab17e29..28e6352c758e 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -53,7 +53,6 @@
 #include "logical-zone.h"
 #include "packer.h"
 #include "physical-zone.h"
-#include "pool-sysfs.h"
 #include "recovery-journal.h"
 #include "slab-depot.h"
 #include "statistics.h"
@@ -691,13 +690,6 @@ void vdo_destroy(struct vdo *vdo)
 
 	vdo->allocations_allowed = true;
 
-	/* Stop services that need to gather VDO statistics from the worker threads. */
-	if (vdo->sysfs_added) {
-		init_completion(&vdo->stats_shutdown);
-		kobject_put(&vdo->stats_directory);
-		wait_for_completion(&vdo->stats_shutdown);
-	}
-
 	finish_vdo(vdo);
 	unregister_vdo(vdo);
 	free_data_vio_pool(vdo->data_vio_pool);
@@ -732,15 +724,7 @@ void vdo_destroy(struct vdo *vdo)
 
 		vdo_free(vdo_forget(vdo->compression_context));
 	}
-
-	/*
-	 * The call to kobject_put on the kobj sysfs node will decrement its reference count; when
-	 * the count goes to zero the VDO object will be freed as a side effect.
-	 */
-	if (!vdo->sysfs_added)
-		vdo_free(vdo);
-	else
-		kobject_put(&vdo->vdo_directory);
+	vdo_free(vdo);
 }
 
 static int initialize_super_block(struct vdo *vdo, struct vdo_super_block *super_block)
@@ -817,42 +801,6 @@ void vdo_load_super_block(struct vdo *vdo, struct vdo_completion *parent)
 				REQ_OP_READ);
 }
 
-/**
- * pool_stats_release() - Signal that sysfs stats have been shut down.
- * @directory: The vdo stats directory.
- */
-static void pool_stats_release(struct kobject *directory)
-{
-	struct vdo *vdo = container_of(directory, struct vdo, stats_directory);
-
-	complete(&vdo->stats_shutdown);
-}
-
-ATTRIBUTE_GROUPS(vdo_pool_stats);
-static const struct kobj_type stats_directory_type = {
-	.release = pool_stats_release,
-	.sysfs_ops = &vdo_pool_stats_sysfs_ops,
-	.default_groups = vdo_pool_stats_groups,
-};
-
-/**
- * vdo_add_sysfs_stats_dir() - Add the stats directory to the vdo sysfs directory.
- * @vdo: The vdo.
- *
- * Return: VDO_SUCCESS or an error.
- */
-int vdo_add_sysfs_stats_dir(struct vdo *vdo)
-{
-	int result;
-
-	kobject_init(&vdo->stats_directory, &stats_directory_type);
-	result = kobject_add(&vdo->stats_directory, &vdo->vdo_directory, "statistics");
-	if (result != 0)
-		return VDO_CANT_ADD_SYSFS_NODE;
-
-	return VDO_SUCCESS;
-}
-
 /**
  * vdo_get_backing_device() - Get the block device object underlying a vdo.
  * @vdo: The vdo.
diff --git a/drivers/md/dm-vdo/vdo.h b/drivers/md/dm-vdo/vdo.h
index 01558fc67f24..483ae873e002 100644
--- a/drivers/md/dm-vdo/vdo.h
+++ b/drivers/md/dm-vdo/vdo.h
@@ -10,7 +10,6 @@
 #include <linux/blk_types.h>
 #include <linux/completion.h>
 #include <linux/dm-kcopyd.h>
-#include <linux/kobject.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
@@ -248,11 +247,6 @@ struct vdo {
 	struct vdo_statistics stats_buffer;
 	/* Protects the stats_buffer */
 	struct mutex stats_mutex;
-	/* true if sysfs directory is set up */
-	bool sysfs_added;
-	/* Used when shutting down the sysfs statistics */
-	struct completion stats_shutdown;
-
 
 	/* A list of all device_configs referencing this vdo */
 	struct list_head device_config_list;
@@ -264,15 +258,10 @@ struct vdo {
 	u64 starting_sector_offset;
 	struct volume_geometry geometry;
 
-	/* For sysfs */
-	struct kobject vdo_directory;
-	struct kobject stats_directory;
-
 	/* N blobs of context data for LZ4 code, one per CPU thread. */
 	char **compression_context;
 };
 
-
 /**
  * vdo_uses_bio_ack_queue() - Indicate whether the vdo is configured to use a separate work queue
  *                            for acknowledging received and processed bios.
@@ -315,8 +304,6 @@ void vdo_destroy(struct vdo *vdo);
 
 void vdo_load_super_block(struct vdo *vdo, struct vdo_completion *parent);
 
-int __must_check vdo_add_sysfs_stats_dir(struct vdo *vdo);
-
 struct block_device * __must_check vdo_get_backing_device(const struct vdo *vdo);
 
 const char * __must_check vdo_get_device_name(const struct dm_target *target);
-- 
2.42.0

