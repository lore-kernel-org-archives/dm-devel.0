Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23A6355F5C
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375618; cv=none; b=RZxK+6x7/K0UObrjWMCBgAsPP0o9mNh06VeM5wigjGAgbM6jLbwtoWyZh/IqSPmRTmkWnAF2967ePycLtxPfuZpbpQLxWEVGe7ld+8+DYQmTENxAoSs5oY4H963f1HwAnaeM9wgkmhcqXFkKntObmAENlR0e8ksrVq8y5a/52Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375618; c=relaxed/simple;
	bh=rV4sk6/jZsnzE+8M3dJKvAPUABbFi1ystzWwug+CVE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Vsycg5zweQB8xXPe8Q4DYkvDudtAo6NQRkDcPLFNbBzAew8MPDzBNXvMyyBvy0argLT8IkMT3sz9awd002AO4b0EZ6FRn22ktZ8xUDdlhgEIcrmt9FvaGr0FofEZj8ZKbcxFqkeA9BcSdt6bX3vqtq0bTwfyb9+O3ezkjvri4QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H5aAMX93; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H5aAMX93"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774375615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YinZ9CnGKV+27f9ce8hHEdMgOy4js2Oye1jkfZRWBLQ=;
	b=H5aAMX93K7SUcXGPILAcBcbBmSY4CbWZnXghQkKXC4QSUBvh/wpgXzQSZyBuRQ7uLLYHf7
	RT+BcddRMG5A+KPWHw2tiNR+Lwv8U/arAd5FBRz4z9ayx3ZZLKGQdhVoY/4835pKPb1Boy
	9I1BeUKm+r1Hego5Hm5p9NxSjsNdThc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-209-jM3_L2bBNQmO6s75RnxObQ-1; Tue,
 24 Mar 2026 14:06:54 -0400
X-MC-Unique: jM3_L2bBNQmO6s75RnxObQ-1
X-Mimecast-MFC-AGG-ID: jM3_L2bBNQmO6s75RnxObQ_1774375613
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A15FE19560AA
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: from vdo-builder-bjohnston.permabit.com (unknown [10.0.101.86])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 82A251955D71;
	Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: by vdo-builder-bjohnston.permabit.com (Postfix, from userid 1142)
	id 674E71D641; Tue, 24 Mar 2026 14:06:52 -0400 (EDT)
From: Bruce Johnston <bjohnsto@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>
Subject: [PATCH 5/9] dm vdo: add geometry block encoding
Date: Tue, 24 Mar 2026 14:06:48 -0400
Message-ID: <20260324180652.69439-6-bjohnsto@redhat.com>
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
X-Mimecast-MFC-PROC-ID: xtl9Ji-Unfbow_rsGLsdknfRop4Psdab05hEW--wI8A_1774375613
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add vdo_encode_volume_geometry() to write the geometry block into a
buffer so that it can be written to disk. The corresponding decode
path already exists.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
---
 drivers/md/dm-vdo/encodings.c | 56 +++++++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/encodings.h |  2 ++
 2 files changed, 58 insertions(+)

diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 3ceba010f4e6..d75e023df637 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -287,6 +287,62 @@ static void decode_volume_geometry(u8 *buffer, size_t *offset,
 	};
 }
 
+/**
+ * vdo_encode_volume_geometry() - Encode the on-disk representation of a volume geometry into a buffer.
+ * @buffer: A buffer to store the encoding.
+ * @geometry: The geometry to encode.
+ * @version: The geometry block version to encode.
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+int vdo_encode_volume_geometry(u8 *buffer, const struct volume_geometry *geometry,
+			       u32 version)
+{
+	int result;
+	enum volume_region_id id;
+	u32 checksum;
+	size_t offset = 0;
+	const struct header *header;
+
+	memcpy(buffer, VDO_GEOMETRY_MAGIC_NUMBER, VDO_GEOMETRY_MAGIC_NUMBER_SIZE);
+	offset += VDO_GEOMETRY_MAGIC_NUMBER_SIZE;
+
+	header = (version > 4) ? &GEOMETRY_BLOCK_HEADER_5_0 : &GEOMETRY_BLOCK_HEADER_4_0;
+	vdo_encode_header(buffer, &offset, header);
+
+	/* This is for backwards compatibility */
+	encode_u32_le(buffer, &offset, geometry->unused);
+	encode_u64_le(buffer, &offset, geometry->nonce);
+	memcpy(buffer + offset, (unsigned char *) &geometry->uuid, sizeof(uuid_t));
+	offset += sizeof(uuid_t);
+
+	if (version > 4)
+		encode_u64_le(buffer, &offset, geometry->bio_offset);
+
+	for (id = 0; id < VDO_VOLUME_REGION_COUNT; id++) {
+		encode_u32_le(buffer, &offset, geometry->regions[id].id);
+		encode_u64_le(buffer, &offset, geometry->regions[id].start_block);
+	}
+
+	encode_u32_le(buffer, &offset, geometry->index_config.mem);
+	encode_u32_le(buffer, &offset, 0);
+
+	if (geometry->index_config.sparse)
+		buffer[offset++] = 1;
+	else
+		buffer[offset++] = 0;
+
+	result = VDO_ASSERT(header->size == offset + sizeof(u32),
+			    "should have encoded up to the geometry checksum");
+	if (result != VDO_SUCCESS)
+		return result;
+
+	checksum = vdo_crc32(buffer, offset);
+	encode_u32_le(buffer, &offset, checksum);
+
+	return VDO_SUCCESS;
+}
+
 /**
  * vdo_parse_geometry_block() - Decode and validate an encoded geometry block.
  * @block: The encoded geometry block.
diff --git a/drivers/md/dm-vdo/encodings.h b/drivers/md/dm-vdo/encodings.h
index 0393936c8aeb..67ff0ff2ffda 100644
--- a/drivers/md/dm-vdo/encodings.h
+++ b/drivers/md/dm-vdo/encodings.h
@@ -813,6 +813,8 @@ int vdo_initialize_volume_geometry(nonce_t nonce, uuid_t *uuid,
 				   const struct index_config *index_config,
 				   struct volume_geometry *geometry);
 
+int vdo_encode_volume_geometry(u8 *buffer, const struct volume_geometry *geometry,
+			       u32 version);
 int __must_check vdo_parse_geometry_block(unsigned char *block,
 					  struct volume_geometry *geometry);
 
-- 
2.52.0

