Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8D0346E6D
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375617; cv=none; b=um5z2tNNkDzvEBtj3lOwsZtjPS7o0y+S5QrulnM7+hN+MZQscyc/GrHIXEX3s1ZAKt6EmkZ1BlIV4Us4KYLZDLSsVdTr+rIt95CAzXyBbtHoe/BLvroU16rYLjjXChhRdeabE3qihMCQifRen51azSR1ymGiwG2YA0rKV7HF+bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375617; c=relaxed/simple;
	bh=jH7NeMoXWWGfMZTWUuw58vtNFsvm0WRTtIRjTybRGwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=i2n61IeSw3pfrdmYrHdcNgMi2zQc0TiIoMVaWeUgFsxT9IIq5q7Uh/Le2jzobQI5uACsfMviE0ddjlkHpM5AqSb7hHlu91bsSxtrh7Dy8filkjUOuy2ieelqLos5dRUyx8JMzi6ZCD+M9vny+zl9eSj0dWtufvBUmVuAs7qD8PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ol+bt+x4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ol+bt+x4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774375615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bHhWgLl+gwUvGadme0/5sdDbuokf+8Lia00A2xOSixE=;
	b=Ol+bt+x4Io2x2L4fAdUc1W2Jm/qNBy6DtuIIh84DirBkZXs4WEfFnX03bhVBSMzAKaXbbM
	6EtBAHfgWS4qGLwUo0/Y98SxmBui5jkfVxxonxM3cUcsh6JnZnTwz/wq7KpbOODT5Ebl17
	S796NmcC3ZD2qzhApEeKoT9OMq4vO8c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-478-8I1qnPfrOiu12ctsOBR33Q-1; Tue,
 24 Mar 2026 14:06:53 -0400
X-MC-Unique: 8I1qnPfrOiu12ctsOBR33Q-1
X-Mimecast-MFC-AGG-ID: 8I1qnPfrOiu12ctsOBR33Q_1774375613
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1910F18002C7
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: from vdo-builder-bjohnston.permabit.com (unknown [10.0.101.86])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C353E1955F2E;
	Tue, 24 Mar 2026 18:06:52 +0000 (UTC)
Received: by vdo-builder-bjohnston.permabit.com (Postfix, from userid 1142)
	id 58BFE1D63A; Tue, 24 Mar 2026 14:06:52 -0400 (EDT)
From: Bruce Johnston <bjohnsto@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>
Subject: [PATCH 2/9] dm vdo: add super block initialization to encodings.c
Date: Tue, 24 Mar 2026 14:06:45 -0400
Message-ID: <20260324180652.69439-3-bjohnsto@redhat.com>
In-Reply-To: <20260324180652.69439-1-bjohnsto@redhat.com>
References: <20260324180652.69439-1-bjohnsto@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: suUNMxh-4LhN7qjsLmbHiEbXD_JpDc2sYV4sA1_eEcw_1774375613
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add vdo_initialize_component_states() to populate the super block,
computing the space required for the main VDO components on disk.
Those include the slab depot, block map, and recovery journal.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
---
 drivers/md/dm-vdo/constants.h |  3 ++
 drivers/md/dm-vdo/encodings.c | 82 +++++++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/encodings.h |  5 +++
 3 files changed, 90 insertions(+)

diff --git a/drivers/md/dm-vdo/constants.h b/drivers/md/dm-vdo/constants.h
index 2a8b03779f87..cc7bc3571ba1 100644
--- a/drivers/md/dm-vdo/constants.h
+++ b/drivers/md/dm-vdo/constants.h
@@ -44,6 +44,9 @@ enum {
 	/* The default size of each slab journal, in blocks */
 	DEFAULT_VDO_SLAB_JOURNAL_SIZE = 224,
 
+	/* The recovery journal starting sequence number set at format time */
+	RECOVERY_JOURNAL_STARTING_SEQUENCE_NUMBER = 1,
+
 	/*
 	 * The initial size of lbn_operations and pbn_operations, which is based upon the expected
 	 * maximum number of outstanding VIOs. This value was chosen to make it highly unlikely
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 9961cb40f890..441c9aee1749 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -1488,6 +1488,88 @@ int vdo_decode_super_block(u8 *buffer)
 	return ((checksum != saved_checksum) ? VDO_CHECKSUM_MISMATCH : VDO_SUCCESS);
 }
 
+/**
+ * vdo_initialize_component_states() - Initialize the components so they can be written out.
+ * @vdo_config: The config used for component state initialization.
+ * @geometry: The volume geometry used to calculate the data region offset.
+ * @nonce: The nonce to use to identify the vdo.
+ * @states: The component states to initialize.
+ *
+ * Return: VDO_SUCCESS or an error code.
+ */
+int vdo_initialize_component_states(const struct vdo_config *vdo_config,
+				    const struct volume_geometry *geometry,
+				    nonce_t nonce,
+				    struct vdo_component_states *states)
+{
+	int result;
+	struct slab_config slab_config;
+	struct partition *partition;
+
+	states->vdo.config = *vdo_config;
+	states->vdo.nonce = nonce;
+	states->volume_version = VDO_VOLUME_VERSION_67_0;
+
+	states->recovery_journal = (struct recovery_journal_state_7_0) {
+		.journal_start = RECOVERY_JOURNAL_STARTING_SEQUENCE_NUMBER,
+		.logical_blocks_used = 0,
+		.block_map_data_blocks = 0,
+	};
+
+	/*
+	 * The layout starts 1 block past the beginning of the data region, as the
+	 * data region contains the super block but the layout does not.
+	 */
+	result = vdo_initialize_layout(vdo_config->physical_blocks,
+				       vdo_get_data_region_start(*geometry) + 1,
+				       DEFAULT_VDO_BLOCK_MAP_TREE_ROOT_COUNT,
+				       vdo_config->recovery_journal_size,
+				       VDO_SLAB_SUMMARY_BLOCKS,
+				       &states->layout);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = vdo_configure_slab(vdo_config->slab_size,
+				    vdo_config->slab_journal_blocks,
+				    &slab_config);
+	if (result != VDO_SUCCESS) {
+		vdo_uninitialize_layout(&states->layout);
+		return result;
+	}
+
+	result = vdo_get_partition(&states->layout, VDO_SLAB_DEPOT_PARTITION,
+				   &partition);
+	if (result != VDO_SUCCESS) {
+		vdo_uninitialize_layout(&states->layout);
+		return result;
+	}
+
+	result = vdo_configure_slab_depot(partition, slab_config, 0,
+					  &states->slab_depot);
+	if (result != VDO_SUCCESS) {
+		vdo_uninitialize_layout(&states->layout);
+		return result;
+	}
+
+	result = vdo_get_partition(&states->layout, VDO_BLOCK_MAP_PARTITION,
+				   &partition);
+	if (result != VDO_SUCCESS) {
+		vdo_uninitialize_layout(&states->layout);
+		return result;
+	}
+
+	states->block_map = (struct block_map_state_2_0) {
+		.flat_page_origin = VDO_BLOCK_MAP_FLAT_PAGE_ORIGIN,
+		.flat_page_count = 0,
+		.root_origin = partition->offset,
+		.root_count = DEFAULT_VDO_BLOCK_MAP_TREE_ROOT_COUNT,
+	};
+
+	states->vdo.state = VDO_NEW;
+
+	return VDO_SUCCESS;
+}
+
 /**
  * vdo_compute_index_blocks() - Compute the number of blocks that the indexer will use.
  * @config: The index config from which the blocks are calculated.
diff --git a/drivers/md/dm-vdo/encodings.h b/drivers/md/dm-vdo/encodings.h
index 0bc5ae696a6a..3cfbe4771a1c 100644
--- a/drivers/md/dm-vdo/encodings.h
+++ b/drivers/md/dm-vdo/encodings.h
@@ -1268,6 +1268,11 @@ int __must_check vdo_validate_component_states(struct vdo_component_states *stat
 void vdo_encode_super_block(u8 *buffer, struct vdo_component_states *states);
 int __must_check vdo_decode_super_block(u8 *buffer);
 
+int vdo_initialize_component_states(const struct vdo_config *vdo_config,
+				    const struct volume_geometry *geometry,
+				    nonce_t nonce,
+				    struct vdo_component_states *states);
+
 /* We start with 0L and postcondition with ~0L to match our historical usage in userspace. */
 static inline u32 vdo_crc32(const void *buf, unsigned long len)
 {
-- 
2.52.0

