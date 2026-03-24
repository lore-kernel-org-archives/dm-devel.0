Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9543630A2
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375619; cv=none; b=RTRsPwMT4FW4eVveLUcvRV0rTMB75GtcHGDhs5HhrDbzSyTAvsA+YdIRQVK/Ir0IgrqwOzk1QGuMZ9CYQ6HcewboezKozvk0jyqRmSmSLjEOH7DJk+RcG0ftbFpcRlmV6DvdbgnemdoGxS8Qvz9VhlvvEmoo2LXDpSDiuixI9BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375619; c=relaxed/simple;
	bh=tJnvpvt296vF3QP1F1CnxFhnLfU5Rv3U42rqY7qd1rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=DD+pYKdFXpqVYzS5UM4ymahPTqk2Ui59BZfhVjNNc/RNPsghZmMx3a6LBlIO/tWAvayMGu5sTcSfJO2859Nf+CmqHDLhbQyb8ITU58wKfBDe9piP8EaeqM78WQ7cgIlsGNNNqZoW4llVlveE488A+PpwUS0Q8bXkQb7PYTViDVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GUBMM1tr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GUBMM1tr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774375615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V32BoNCV6AZdPc5rM9bQnd8bC4VhHO5gkFcVOoF98fI=;
	b=GUBMM1trdbmtY5KyJ4FuR0kU4U7bYqcVITzM+aSeDpabSFYGNl7ZASx03LzenkzhtzfUyi
	w3icZBG1zPZF8Sy78stp3o59IKQzt2OapNDK7E1m1qEh9p6Zz8ONNZhZrXi0xKjmTQTCWg
	ApN8jUYErxlPg7AJ1+4lyaDV+sBjhpA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-478-9k9V3T8nMn-Sh471Ei5psA-1; Tue,
 24 Mar 2026 14:06:54 -0400
X-MC-Unique: 9k9V3T8nMn-Sh471Ei5psA-1
X-Mimecast-MFC-AGG-ID: 9k9V3T8nMn-Sh471Ei5psA_1774375613
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E66719560BB
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: from vdo-builder-bjohnston.permabit.com (unknown [10.0.101.86])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1EFDC300019F;
	Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: by vdo-builder-bjohnston.permabit.com (Postfix, from userid 1142)
	id 5DE131D63D; Tue, 24 Mar 2026 14:06:52 -0400 (EDT)
From: Bruce Johnston <bjohnsto@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>
Subject: [PATCH 3/9] dm vdo: add formatting parameters to table line
Date: Tue, 24 Mar 2026 14:06:46 -0400
Message-ID: <20260324180652.69439-4-bjohnsto@redhat.com>
In-Reply-To: <20260324180652.69439-1-bjohnsto@redhat.com>
References: <20260324180652.69439-1-bjohnsto@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F2ZPTgCPz74pO_RKtWiMoz4LAvC2lWYp88Ik0x4sn0E_1774375613
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Extend the dm table line with three new optional parameters:
indexMemory (UDS index memory size), indexSparse (dense vs sparse
index), and slabSize (blocks per allocation slab). These values are
parsed, validated, and stored in the device configuration for use
during formatting.

Rework the slab size constants from the single MAX_VDO_SLAB_BITS into
explicit MIN_VDO_SLAB_BLOCKS, MAX_VDO_SLAB_BLOCKS, and
DEFAULT_VDO_SLAB_BLOCKS values.

Bump the target version from 9.1.0 to 9.2.0 to reflect this table
line change.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
---
 drivers/md/dm-vdo/constants.h     | 10 +++-
 drivers/md/dm-vdo/dm-vdo-target.c | 97 +++++++++++++++++++++++++++++--
 drivers/md/dm-vdo/encodings.c     | 12 +---
 drivers/md/dm-vdo/encodings.h     |  6 ++
 drivers/md/dm-vdo/types.h         |  3 +
 5 files changed, 111 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-vdo/constants.h b/drivers/md/dm-vdo/constants.h
index cc7bc3571ba1..b84e7edeb22e 100644
--- a/drivers/md/dm-vdo/constants.h
+++ b/drivers/md/dm-vdo/constants.h
@@ -60,8 +60,14 @@ enum {
 	/* The maximum number of physical zones */
 	MAX_VDO_PHYSICAL_ZONES = 16,
 
-	/* The base-2 logarithm of the maximum blocks in one slab */
-	MAX_VDO_SLAB_BITS = 23,
+	/* The default blocks in one slab */
+	DEFAULT_VDO_SLAB_BLOCKS = 1U << 19,
+
+	/* The minimum blocks in one slab */
+	MIN_VDO_SLAB_BLOCKS = 1U << 13,
+
+	/* The maximum blocks in one slab */
+	MAX_VDO_SLAB_BLOCKS = 1U << 23,
 
 	/* The maximum number of slabs the slab depot supports */
 	MAX_VDO_SLABS = 8192,
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 7eb676e58ed5..1065c88a761c 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -9,6 +9,7 @@
 #include <linux/delay.h>
 #include <linux/device-mapper.h>
 #include <linux/err.h>
+#include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -377,6 +378,75 @@ static inline int __must_check parse_bool(const char *bool_str, const char *true
 	return VDO_SUCCESS;
 }
 
+/**
+ * parse_memory() - Parse a string into an index memory value.
+ * @memory_str: The string value to convert to a memory value.
+ * @memory_ptr: A pointer to return the memory value in.
+ *
+ * Return: VDO_SUCCESS or an error
+ */
+static int __must_check parse_memory(const char *memory_str,
+				     uds_memory_config_size_t *memory_ptr)
+{
+	uds_memory_config_size_t memory;
+
+	if (strcmp(memory_str, "0.25") == 0) {
+		memory = UDS_MEMORY_CONFIG_256MB;
+	} else if ((strcmp(memory_str, "0.5") == 0) || (strcmp(memory_str, "0.50") == 0)) {
+		memory = UDS_MEMORY_CONFIG_512MB;
+	} else if (strcmp(memory_str, "0.75") == 0) {
+		memory = UDS_MEMORY_CONFIG_768MB;
+	} else {
+		unsigned int value;
+		int result;
+
+		result = kstrtouint(memory_str, 10, &value);
+		if (result) {
+			vdo_log_error("optional parameter error: invalid memory size, must be a postive integer");
+			return -EINVAL;
+		}
+
+		if (value > UDS_MEMORY_CONFIG_MAX) {
+			vdo_log_error("optional parameter error: invalid memory size, must not be greater than %d",
+				      UDS_MEMORY_CONFIG_MAX);
+			return -EINVAL;
+		}
+
+		memory = value;
+	}
+
+	*memory_ptr = memory;
+	return VDO_SUCCESS;
+}
+
+/**
+ * parse_slab_size() - Parse a string option into a slab size value.
+ * @slab_str: The string value representing slab size.
+ * @slab_size_ptr: A pointer to return the slab size in.
+ *
+ * Return: VDO_SUCCESS or an error
+ */
+static int __must_check parse_slab_size(const char *slab_str, block_count_t *slab_size_ptr)
+{
+	block_count_t value;
+	int result;
+
+	result = kstrtoull(slab_str, 10, &value);
+	if (result) {
+		vdo_log_error("optional parameter error: invalid slab size, must be a postive integer");
+		return -EINVAL;
+	}
+
+	if (value < MIN_VDO_SLAB_BLOCKS || value > MAX_VDO_SLAB_BLOCKS || (!is_power_of_2(value))) {
+		vdo_log_error("optional parameter error: invalid slab size, must be a power of two between %u and %u",
+			      MIN_VDO_SLAB_BLOCKS, MAX_VDO_SLAB_BLOCKS);
+		return -EINVAL;
+	}
+
+	*slab_size_ptr = value;
+	return VDO_SUCCESS;
+}
+
 /**
  * process_one_thread_config_spec() - Process one component of a thread parameter configuration
  *				      string and update the configuration data structure.
@@ -566,7 +636,7 @@ static int process_one_key_value_pair(const char *key, unsigned int value,
 		}
 		/* Max discard sectors in blkdev_issue_discard is UINT_MAX >> 9 */
 		if (value > (UINT_MAX / VDO_BLOCK_SIZE)) {
-			vdo_log_error("optional parameter error: at most %d max discard	 blocks are allowed",
+			vdo_log_error("optional parameter error: at most %d max discard blocks are allowed",
 				      UINT_MAX / VDO_BLOCK_SIZE);
 			return -EINVAL;
 		}
@@ -598,7 +668,16 @@ static int parse_one_key_value_pair(const char *key, const char *value,
 	if (strcmp(key, "compression") == 0)
 		return parse_bool(value, "on", "off", &config->compression);
 
-	/* The remaining arguments must have integral values. */
+	if (strcmp(key, "indexSparse") == 0)
+		return parse_bool(value, "on", "off", &config->index_sparse);
+
+	if (strcmp(key, "indexMemory") == 0)
+		return parse_memory(value, &config->index_memory);
+
+	if (strcmp(key, "slabSize") == 0)
+		return parse_slab_size(value, &config->slab_blocks);
+
+	/* The remaining arguments must have non-negative integral values. */
 	result = kstrtouint(value, 10, &count);
 	if (result) {
 		vdo_log_error("optional config string error: integer value needed, found \"%s\"",
@@ -756,6 +835,9 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
 	config->max_discard_blocks = 1;
 	config->deduplication = true;
 	config->compression = false;
+	config->index_memory = UDS_MEMORY_CONFIG_256MB;
+	config->index_sparse = false;
+	config->slab_blocks = DEFAULT_VDO_SLAB_BLOCKS;
 
 	arg_set.argc = argc;
 	arg_set.argv = argv;
@@ -781,7 +863,7 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
 	/* Get the physical blocks, if known. */
 	if (config->version >= 1) {
 		result = kstrtoull(dm_shift_arg(&arg_set), 10, &config->physical_blocks);
-		if (result != VDO_SUCCESS) {
+		if (result) {
 			handle_parse_error(config, error_ptr,
 					   "Invalid physical block count");
 			return VDO_BAD_CONFIGURATION;
@@ -802,7 +884,7 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
 
 	/* Get the page cache size. */
 	result = kstrtouint(dm_shift_arg(&arg_set), 10, &config->cache_size);
-	if (result != VDO_SUCCESS) {
+	if (result) {
 		handle_parse_error(config, error_ptr,
 				   "Invalid block map page cache size");
 		return VDO_BAD_CONFIGURATION;
@@ -810,7 +892,7 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
 
 	/* Get the block map era length. */
 	result = kstrtouint(dm_shift_arg(&arg_set), 10, &config->block_map_maximum_age);
-	if (result != VDO_SUCCESS) {
+	if (result) {
 		handle_parse_error(config, error_ptr, "Invalid block map maximum age");
 		return VDO_BAD_CONFIGURATION;
 	}
@@ -1457,10 +1539,13 @@ static int vdo_initialize(struct dm_target *ti, unsigned int instance,
 	vdo_log_debug("Logical blocks         = %llu", logical_blocks);
 	vdo_log_debug("Physical block size    = %llu", (u64) block_size);
 	vdo_log_debug("Physical blocks        = %llu", config->physical_blocks);
+	vdo_log_debug("Slab size              = %llu", config->slab_blocks);
 	vdo_log_debug("Block map cache blocks = %u", config->cache_size);
 	vdo_log_debug("Block map maximum age  = %u", config->block_map_maximum_age);
 	vdo_log_debug("Deduplication          = %s", (config->deduplication ? "on" : "off"));
 	vdo_log_debug("Compression            = %s", (config->compression ? "on" : "off"));
+	vdo_log_debug("Index memory           = %u", config->index_memory);
+	vdo_log_debug("Index sparse           = %s", (config->index_sparse ? "on" : "off"));
 
 	vdo = vdo_find_matching(vdo_uses_device, config);
 	if (vdo != NULL) {
@@ -2856,7 +2941,7 @@ static void vdo_resume(struct dm_target *ti)
 static struct target_type vdo_target_bio = {
 	.features = DM_TARGET_SINGLETON,
 	.name = "vdo",
-	.version = { 9, 1, 0 },
+	.version = { 9, 2, 0 },
 	.module = THIS_MODULE,
 	.ctr = vdo_ctr,
 	.dtr = vdo_dtr,
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 441c9aee1749..3ceba010f4e6 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -16,12 +16,6 @@
 #include "status-codes.h"
 #include "types.h"
 
-/** The maximum logical space is 4 petabytes, which is 1 terablock. */
-static const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS = 1024ULL * 1024 * 1024 * 1024;
-
-/** The maximum physical space is 256 terabytes, which is 64 gigablocks. */
-static const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS = 1024ULL * 1024 * 1024 * 64;
-
 struct geometry_block {
 	char magic_number[VDO_GEOMETRY_MAGIC_NUMBER_SIZE];
 	struct packed_header header;
@@ -1220,9 +1214,9 @@ int vdo_validate_config(const struct vdo_config *config,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = VDO_ASSERT(config->slab_size <= (1 << MAX_VDO_SLAB_BITS),
-			    "slab size must be less than or equal to 2^%d",
-			    MAX_VDO_SLAB_BITS);
+	result = VDO_ASSERT(config->slab_size <= MAX_VDO_SLAB_BLOCKS,
+			    "slab size must be a power of two less than or equal to %d",
+			    MAX_VDO_SLAB_BLOCKS);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/encodings.h b/drivers/md/dm-vdo/encodings.h
index 3cfbe4771a1c..0393936c8aeb 100644
--- a/drivers/md/dm-vdo/encodings.h
+++ b/drivers/md/dm-vdo/encodings.h
@@ -608,6 +608,12 @@ struct vdo_config {
 	block_count_t slab_journal_blocks; /* number of slab journal blocks */
 };
 
+/** The maximum logical space is 4 petabytes, which is 1 terablock. */
+#define MAXIMUM_VDO_LOGICAL_BLOCKS ((block_count_t)(1024ULL * 1024 * 1024 * 1024))
+
+/** The maximum physical space is 256 terabytes, which is 64 gigablocks. */
+#define MAXIMUM_VDO_PHYSICAL_BLOCKS ((block_count_t)(1024ULL * 1024 * 1024 * 64))
+
 /* This is the structure that captures the vdo fields saved as a super block component. */
 struct vdo_component {
 	enum vdo_state state;
diff --git a/drivers/md/dm-vdo/types.h b/drivers/md/dm-vdo/types.h
index cdf36e7d7702..0d60a88aa086 100644
--- a/drivers/md/dm-vdo/types.h
+++ b/drivers/md/dm-vdo/types.h
@@ -227,6 +227,9 @@ struct device_config {
 	bool compression;
 	struct thread_count_config thread_counts;
 	block_count_t max_discard_blocks;
+	block_count_t slab_blocks;
+	int index_memory;
+	bool index_sparse;
 };
 
 enum vdo_completion_type {
-- 
2.52.0

