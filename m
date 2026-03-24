Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37053377ECA
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375617; cv=none; b=RWRwRAUVr96Nfdd1zKxHouysvsHW8gR/XDFDK7qLNMYoJhFzZuorv7R7YqiNb1V191nRv0y6QK3BZCHpCI/esaSemaOT+Oa9XUAFSOmsAZJda7aY1cnLfM8WGyqFdOhRY34vpqIdcNN4zXszs5zoFebgzLrVf3XBZpz1vmEq1NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375617; c=relaxed/simple;
	bh=6nMS5brPVgpeeRFZgwWrAlHGkn+dzgk+mSJZBW0ji3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=rzYfA+Op31LDXYFhJA3YH1iktibRsHSCxr/qusrjW7+7Dq08dqrRh6AF231TGcyetIr3BDkm3xhBXNmjOYhjrU8xP4ufOjMHy4d97pSvbZP001VudgLk4sg9EfmVPhbtNtD3+hPYFRxsfCkhmKKsTr4fWug7O0qgXemWADgVPW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GWOTl5eJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GWOTl5eJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774375615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8goXWtytSPxmj1NLLNL82/wr/0FbdIQRjiws8Vn4ryc=;
	b=GWOTl5eJleDCnJkaLbq1SF0xBZ1UsiXpAqqVHCFa9J2BpVrj7l+llELy4EKOSqDg6CFldB
	iVpCtjPmg4scCuRZ68KfNw15qARhMMpPAYv1eTLg2KLvEpWkXW+PL+tWBg2LI1e4193uFd
	56lP6yx6Eq4YlHu1m426BWNu+XWTRD8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-XZNOuyW5MGyEM4yTrtESbQ-1; Tue,
 24 Mar 2026 14:06:53 -0400
X-MC-Unique: XZNOuyW5MGyEM4yTrtESbQ-1
X-Mimecast-MFC-AGG-ID: XZNOuyW5MGyEM4yTrtESbQ_1774375613
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F04CB19560A6
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:52 +0000 (UTC)
Received: from vdo-builder-bjohnston.permabit.com (unknown [10.0.101.86])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D36101800107;
	Tue, 24 Mar 2026 18:06:52 +0000 (UTC)
Received: by vdo-builder-bjohnston.permabit.com (Postfix, from userid 1142)
	id 52C151D638; Tue, 24 Mar 2026 14:06:52 -0400 (EDT)
From: Bruce Johnston <bjohnsto@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>
Subject: [PATCH 1/9] dm vdo: add geometry block initialization to encodings.c
Date: Tue, 24 Mar 2026 14:06:44 -0400
Message-ID: <20260324180652.69439-2-bjohnsto@redhat.com>
In-Reply-To: <20260324180652.69439-1-bjohnsto@redhat.com>
References: <20260324180652.69439-1-bjohnsto@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X8lk3KHl7EcK2SvBQ-Wz_edtBSrNT2wXaijP3zPrLgM_1774375613
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add vdo_initialize_volume_geometry() to populate the geometry block,
computing the space required for the two main regions on disk.

Add uds_compute_index_size() to calculate the space required for the
UDS indexer from the UDS configuration.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
---
 drivers/md/dm-vdo/encodings.c            | 69 ++++++++++++++++++++++++
 drivers/md/dm-vdo/encodings.h            |  4 ++
 drivers/md/dm-vdo/indexer/index-layout.c | 26 +++++++++
 drivers/md/dm-vdo/indexer/indexer.h      |  4 ++
 4 files changed, 103 insertions(+)

diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index ec98c539701e..9961cb40f890 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -12,6 +12,7 @@
 #include "permassert.h"
 
 #include "constants.h"
+#include "indexer.h"
 #include "status-codes.h"
 #include "types.h"
 
@@ -1486,3 +1487,71 @@ int vdo_decode_super_block(u8 *buffer)
 
 	return ((checksum != saved_checksum) ? VDO_CHECKSUM_MISMATCH : VDO_SUCCESS);
 }
+
+/**
+ * vdo_compute_index_blocks() - Compute the number of blocks that the indexer will use.
+ * @config: The index config from which the blocks are calculated.
+ * @index_blocks_ptr: The number of blocks the index will use.
+ *
+ * Return: VDO_SUCCESS or an error code.
+ */
+static int vdo_compute_index_blocks(const struct index_config *config,
+				    block_count_t *index_blocks_ptr)
+{
+	int result;
+	u64 index_bytes;
+	struct uds_parameters uds_parameters = {
+		.memory_size = config->mem,
+		.sparse = config->sparse,
+	};
+
+	result = uds_compute_index_size(&uds_parameters, &index_bytes);
+	if (result != UDS_SUCCESS)
+		return vdo_log_error_strerror(result, "error computing index size");
+
+	*index_blocks_ptr = index_bytes / VDO_BLOCK_SIZE;
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_initialize_volume_geometry() - Initialize the volume geometry so it can be written out.
+ * @nonce: The nonce to use to identify the vdo.
+ * @uuid: The uuid to use to identify the vdo.
+ * @index_config: The config used for structure initialization.
+ * @geometry: The volume geometry to initialize.
+ *
+ * Return: VDO_SUCCESS or an error code.
+ */
+int vdo_initialize_volume_geometry(nonce_t nonce, uuid_t *uuid,
+				   const struct index_config *index_config,
+				   struct volume_geometry *geometry)
+{
+	int result;
+	block_count_t index_blocks = 0;
+
+	result = vdo_compute_index_blocks(index_config, &index_blocks);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	*geometry = (struct volume_geometry) {
+		/* This is for backwards compatibility. */
+		.unused = 0,
+		.nonce = nonce,
+		.bio_offset = 0,
+		.regions = {
+			[VDO_INDEX_REGION] = {
+				.id = VDO_INDEX_REGION,
+				.start_block = 1,
+			},
+			[VDO_DATA_REGION] = {
+				.id = VDO_DATA_REGION,
+				.start_block = 1 + index_blocks,
+			}
+		}
+	};
+
+	memcpy(&(geometry->uuid), uuid, sizeof(uuid_t));
+	memcpy(&geometry->index_config, index_config, sizeof(struct index_config));
+
+	return VDO_SUCCESS;
+}
diff --git a/drivers/md/dm-vdo/encodings.h b/drivers/md/dm-vdo/encodings.h
index 87b7d2f3b545..0bc5ae696a6a 100644
--- a/drivers/md/dm-vdo/encodings.h
+++ b/drivers/md/dm-vdo/encodings.h
@@ -803,6 +803,10 @@ vdo_get_index_region_size(struct volume_geometry geometry)
 		vdo_get_index_region_start(geometry);
 }
 
+int vdo_initialize_volume_geometry(nonce_t nonce, uuid_t *uuid,
+				   const struct index_config *index_config,
+				   struct volume_geometry *geometry);
+
 int __must_check vdo_parse_geometry_block(unsigned char *block,
 					  struct volume_geometry *geometry);
 
diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 798badcf80ea..74b7774b4be4 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -249,6 +249,32 @@ static int __must_check compute_sizes(const struct uds_configuration *config,
 	return UDS_SUCCESS;
 }
 
+int uds_compute_index_size(const struct uds_parameters *parameters, u64 *index_size)
+{
+	int result;
+	struct uds_configuration *index_config;
+	struct save_layout_sizes sizes;
+
+	if (index_size == NULL) {
+		vdo_log_error("Missing output size pointer");
+		return -EINVAL;
+	}
+
+	result = uds_make_configuration(parameters, &index_config);
+	if (result != UDS_SUCCESS) {
+		vdo_log_error_strerror(result, "cannot compute index size");
+		return result;
+	}
+
+	result = compute_sizes(index_config, &sizes);
+	uds_free_configuration(index_config);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	*index_size = sizes.total_size;
+	return UDS_SUCCESS;
+}
+
 /* Create unique data using the current time and a pseudorandom number. */
 static void create_unique_nonce_data(u8 *buffer)
 {
diff --git a/drivers/md/dm-vdo/indexer/indexer.h b/drivers/md/dm-vdo/indexer/indexer.h
index 7c1fc4577f5b..d765f24328eb 100644
--- a/drivers/md/dm-vdo/indexer/indexer.h
+++ b/drivers/md/dm-vdo/indexer/indexer.h
@@ -282,6 +282,10 @@ struct uds_request {
 		     );
 };
 
+/* Compute the number of bytes needed to store an index. */
+int __must_check uds_compute_index_size(const struct uds_parameters *parameters,
+					u64 *index_size);
+
 /* A session is required for most index operations. */
 int __must_check uds_create_index_session(struct uds_index_session **session);
 
-- 
2.52.0

