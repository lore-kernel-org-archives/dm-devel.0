Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A10352921
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375618; cv=none; b=nB8utSWSsVi46puQP+OPIYlCQaujORHAA0UqxXQZkXmGLtj9dMEswQV5IyvKXXM/OKXIGWIG9nskytqsIUHHBzOSouJvDIhcl+ZXWfwr+fZJUzJQJ1k07KGY3Uxce2Xp+jsW91wO3lMricGEM0D0oITQ+vI909i+LUqf9DBwO0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375618; c=relaxed/simple;
	bh=J/r15+/NYB9Ktnsp3ktgXe7AJUGaNV0MS+ROeXp4DJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=NavLTzWxXDAa48BrvYiMRPN6751HMTC4lhdnBCS3UOK8ewJ43vghhjZv4iWM67fL5KifclKgbfAYB3gf/F19k2e81YKM4NUPuT3+1sQJ9NqYH9b/Q2VwNUeFBgPjTb3ID2G9fKTqPw3ahlof8N/blmPO2ihUG7HXM+hVpZbP9uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chH7g6JA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chH7g6JA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774375615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TsJxAxpaXAzYKSPwOFO13Nd6KVDSzfePZhd7I5p7PEI=;
	b=chH7g6JAxjKj53Cl4kIXcEq1tj308jb7XFOQnLURs9u4eB2Go/eaTOLzRmk86ujtMMG7wW
	aTgayOgCvyfUMfcWylw6qOqZUVTgDBIyYvB+7JZKl6rDoUv/gc22ZzIIq4Bxo6Agm3rZqO
	GXrQMC31J6RUsZX2wGQ/Q0lyDZCMplg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-GL_ZP7_5NryyeHxfSgZJFA-1; Tue,
 24 Mar 2026 14:06:54 -0400
X-MC-Unique: GL_ZP7_5NryyeHxfSgZJFA-1
X-Mimecast-MFC-AGG-ID: GL_ZP7_5NryyeHxfSgZJFA_1774375613
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C026919560B9
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: from vdo-builder-bjohnston.permabit.com (unknown [10.0.101.86])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A1AA91953944;
	Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: by vdo-builder-bjohnston.permabit.com (Postfix, from userid 1142)
	id 763171D647; Tue, 24 Mar 2026 14:06:52 -0400 (EDT)
From: Bruce Johnston <bjohnsto@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>
Subject: [PATCH 8/9] dm vdo: add formatting logic and initialization
Date: Tue, 24 Mar 2026 14:06:51 -0400
Message-ID: <20260324180652.69439-9-bjohnsto@redhat.com>
In-Reply-To: <20260324180652.69439-1-bjohnsto@redhat.com>
References: <20260324180652.69439-1-bjohnsto@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aiVc5E0M2dhmUATu1oszLXKHoNLzBcGvumsCeREUzYg_1774375613
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add the core formatting logic. The initialization path is updated to
read the geometry block (block 0 on the storage device). If the block
is entirely zeroed, the device is treated as unformatted and
vdo_format() is called. Otherwise, the existing geometry is parsed
and the VDO is loaded as before.

The vdo_format() function initializes the volume geometry and super
block, and marks the VDO as needing it's layout saved to disk.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
---
 drivers/md/dm-vdo/status-codes.c |   2 +
 drivers/md/dm-vdo/vdo.c          | 104 +++++++++++++++++++++++--------
 2 files changed, 81 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-vdo/status-codes.c b/drivers/md/dm-vdo/status-codes.c
index dd252d660b6d..9df5e4d7f884 100644
--- a/drivers/md/dm-vdo/status-codes.c
+++ b/drivers/md/dm-vdo/status-codes.c
@@ -80,6 +80,8 @@ int vdo_status_to_errno(int error)
 
 	/* VDO or UDS error */
 	switch (error) {
+	case VDO_BAD_CONFIGURATION:
+		return -EINVAL;
 	case VDO_NO_SPACE:
 		return -ENOSPC;
 	case VDO_READ_ONLY:
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index bc7afbca035d..b5e64af13437 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -34,7 +34,9 @@
 #include <linux/lz4.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/types.h>
+#include <linux/uuid.h>
 
 #include "logger.h"
 #include "memory-alloc.h"
@@ -55,6 +57,7 @@
 #include "slab-depot.h"
 #include "statistics.h"
 #include "status-codes.h"
+#include "time-utils.h"
 #include "vio.h"
 
 #define PARANOID_THREAD_CONSISTENCY_CHECKS 0
@@ -286,30 +289,6 @@ static int initialize_super_block(struct vdo *vdo, struct vdo_super_block *super
 				       &vdo->super_block.vio);
 }
 
-/**
- * read_geometry_block() - Synchronously read the geometry block from a vdo's underlying block
- *                         device.
- * @vdo: The vdo whose geometry is to be read.
- *
- * Return: VDO_SUCCESS or an error code.
- */
-static int __must_check read_geometry_block(struct vdo *vdo)
-{
-	int result;
-
-	/*
-	 * This is only safe because, having not already loaded the geometry, the vdo's geometry's
-	 * bio_offset field is 0, so the fact that vio_reset_bio() will subtract that offset from
-	 * the supplied pbn is not a problem.
-	 */
-	result = vdo_submit_metadata_vio_wait(&vdo->geometry_block.vio,
-					      VDO_GEOMETRY_BLOCK_LOCATION, REQ_OP_READ);
-	if (result != VDO_SUCCESS)
-		return result;
-
-	return vdo_parse_geometry_block(vdo->geometry_block.buffer, &vdo->geometry);
-}
-
 static bool get_zone_thread_name(const thread_id_t thread_ids[], zone_count_t count,
 				 thread_id_t id, const char *prefix,
 				 char *buffer, size_t buffer_length)
@@ -454,6 +433,67 @@ static int register_vdo(struct vdo *vdo)
 	return result;
 }
 
+/**
+ * vdo_format() - Format a block device to function as a new VDO.
+ * @vdo:       The vdo to format.
+ * @error_ptr: The reason for any failure during this call.
+ *
+ * This function must be called on a device before a VDO can be loaded for the first time.
+ * Once a device has been formatted, the VDO can be loaded and shut down repeatedly.
+ * If a new VDO is desired, this function should be called again.
+ *
+ * Return: VDO_SUCCESS or an error
+ **/
+static int __must_check vdo_format(struct vdo *vdo, char **error_ptr)
+{
+	int result;
+	uuid_t uuid;
+	nonce_t nonce = current_time_us();
+	struct device_config *config = vdo->device_config;
+
+	struct index_config index_config = {
+		.mem    = config->index_memory,
+		.sparse = config->index_sparse,
+	};
+
+	struct vdo_config vdo_config = {
+		.logical_blocks        = config->logical_blocks,
+		.physical_blocks       = config->physical_blocks,
+		.slab_size             = config->slab_blocks,
+		.slab_journal_blocks   = DEFAULT_VDO_SLAB_JOURNAL_SIZE,
+		.recovery_journal_size = DEFAULT_VDO_RECOVERY_JOURNAL_SIZE,
+	};
+
+	uuid_gen(&uuid);
+	result = vdo_initialize_volume_geometry(nonce, &uuid, &index_config, &vdo->geometry);
+	if (result != VDO_SUCCESS) {
+		*error_ptr = "Could not initialize volume geometry during format";
+		return result;
+	}
+
+	result = vdo_initialize_component_states(&vdo_config, &vdo->geometry, nonce, &vdo->states);
+	if (result == VDO_NO_SPACE) {
+		block_count_t slab_blocks = config->slab_blocks;
+		/* 1 is counting geometry block */
+		block_count_t fixed_layout_size = 1 +
+			vdo->geometry.regions[VDO_DATA_REGION].start_block +
+			DEFAULT_VDO_BLOCK_MAP_TREE_ROOT_COUNT +
+			DEFAULT_VDO_RECOVERY_JOURNAL_SIZE + VDO_SLAB_SUMMARY_BLOCKS;
+		block_count_t necessary_size = fixed_layout_size + slab_blocks;
+
+		vdo_log_error("Minimum required size for VDO volume: %llu bytes",
+			      (unsigned long long) necessary_size * VDO_BLOCK_SIZE);
+		*error_ptr = "Could not allocate enough space for VDO during format";
+		return result;
+	}
+	if (result != VDO_SUCCESS) {
+		*error_ptr = "Could not initialize data layout during format";
+		return result;
+	}
+
+	return VDO_SUCCESS;
+}
+
 /**
  * initialize_vdo() - Do the portion of initializing a vdo which will clean up after itself on
  *                    error.
@@ -490,12 +530,26 @@ static int initialize_vdo(struct vdo *vdo, struct device_config *config,
 		return result;
 	}
 
-	result = read_geometry_block(vdo);
+	result = vdo_submit_metadata_vio_wait(&vdo->geometry_block.vio,
+					      VDO_GEOMETRY_BLOCK_LOCATION, REQ_OP_READ);
 	if (result != VDO_SUCCESS) {
 		*reason = "Could not load geometry block";
 		return result;
 	}
 
+	if (mem_is_zero(vdo->geometry_block.vio.data, VDO_BLOCK_SIZE)) {
+		result = vdo_format(vdo, reason);
+		if (result != VDO_SUCCESS)
+			return result;
+	} else {
+		result = vdo_parse_geometry_block(vdo->geometry_block.buffer,
+						  &vdo->geometry);
+		if (result != VDO_SUCCESS) {
+			*reason = "Could not parse geometry block";
+			return result;
+		}
+	}
+
 	result = initialize_thread_config(config->thread_counts, &vdo->thread_config);
 	if (result != VDO_SUCCESS) {
 		*reason = "Cannot create thread configuration";
-- 
2.52.0

