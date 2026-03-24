Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C1337BE6F
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375618; cv=none; b=p6SqMTbWrBbK4UD0ipnjSHa2BRFQeuWnCByhlao8GnsKbKvkHlR002rX4eQ6AXGoFYD3+bRRCYlqTKCGCyrNGTC4dj9RkTs4YCkIqOY8ZZP6py68ufuHEmlIgY3TnuMun3S+Yo9GXTIt7QJeApOVECcBTOOGckya35My+R5x2qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375618; c=relaxed/simple;
	bh=RxLqyRyv4Y5ofCiCQ+DJoHJwdVRcYqehxmzqFnY2aoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=OY6f3WBAd5c+ds38QqB0BMwo9kN8yIFSNX63kjc+3Q8M6WwtZs2dz2JdkrFApP/wt3BlrCTNoXfqYkH7iRhxuQyGhbmifPRp3UqMaPTRR3uvscGzRiVq0dq+DDsaz3bTdOVjOciGCPlmhQUAjznaXwkRSsQJI9mwE7rkpm2KsGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UOhDlLVP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UOhDlLVP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774375615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sIoLKUhXo1XJYR7F90IEswdkAWRK3s6N+xMpSgDiiZ4=;
	b=UOhDlLVP8ZzUrUc/dyntDrS5HX8KiqEN/KWupHLVv7aw8WpdtWYe90Q8htnFkSV9B0bpfC
	cEvm5JtqJzriMi9A2Wi4AIhO/YkFFo4amShWsaaPhpHKF7tUBLk3bcct9Pn9fG47qlg6Uj
	zeEKXR2Kdl/TW3RFzntkFIlNsO6d8Xw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-e-rn8yDDOPamlBwUuLp0zg-1; Tue,
 24 Mar 2026 14:06:54 -0400
X-MC-Unique: e-rn8yDDOPamlBwUuLp0zg-1
X-Mimecast-MFC-AGG-ID: e-rn8yDDOPamlBwUuLp0zg_1774375613
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77353195608B
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: from vdo-builder-bjohnston.permabit.com (unknown [10.0.101.86])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 597D01955D71;
	Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: by vdo-builder-bjohnston.permabit.com (Postfix, from userid 1142)
	id 6C32F1D643; Tue, 24 Mar 2026 14:06:52 -0400 (EDT)
From: Bruce Johnston <bjohnsto@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>
Subject: [PATCH 6/9] dm vdo: add geometry block structure
Date: Tue, 24 Mar 2026 14:06:49 -0400
Message-ID: <20260324180652.69439-7-bjohnsto@redhat.com>
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
X-Mimecast-MFC-PROC-ID: GT8snC6SfDXJriL8NLqBUoVdGMETNbAnVMXCBMWa7Lg_1774375613
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce a vdo_geometry_block structure, containing a vio and buffer,
mirroring the existing vdo_super_block structure. Both are now
initialized at VDO startup and freed at shutdown, establishing the
infrastructure needed to read and write the geometry block using the
same mechanisms as the super block.

Refactor read_geometry_block() to use the new structure.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
---
 drivers/md/dm-vdo/vdo.c | 101 ++++++++++++++++++++++------------------
 drivers/md/dm-vdo/vdo.h |  10 ++++
 2 files changed, 66 insertions(+), 45 deletions(-)

diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 167cf93a284a..09a1a97b5c31 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -255,6 +255,37 @@ static int __must_check initialize_thread_config(struct thread_count_config coun
 	return VDO_SUCCESS;
 }
 
+static int initialize_geometry_block(struct vdo *vdo,
+				     struct vdo_geometry_block *geometry_block)
+{
+	int result;
+
+	result = vdo_allocate(VDO_BLOCK_SIZE, "encoded geometry block",
+			      (char **) &vdo->geometry_block.buffer);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	return allocate_vio_components(vdo, VIO_TYPE_GEOMETRY,
+				       VIO_PRIORITY_METADATA, NULL, 1,
+				       (char *) geometry_block->buffer,
+				       &vdo->geometry_block.vio);
+}
+
+static int initialize_super_block(struct vdo *vdo, struct vdo_super_block *super_block)
+{
+	int result;
+
+	result = vdo_allocate(VDO_BLOCK_SIZE, "encoded super block",
+			      (char **) &vdo->super_block.buffer);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	return allocate_vio_components(vdo, VIO_TYPE_SUPER_BLOCK,
+				       VIO_PRIORITY_METADATA, NULL, 1,
+				       (char *) super_block->buffer,
+				       &vdo->super_block.vio);
+}
+
 /**
  * read_geometry_block() - Synchronously read the geometry block from a vdo's underlying block
  *                         device.
@@ -264,47 +295,29 @@ static int __must_check initialize_thread_config(struct thread_count_config coun
  */
 static int __must_check read_geometry_block(struct vdo *vdo)
 {
-	struct vio *vio;
-	char *block;
+	struct vio *vio = &vdo->geometry_block.vio;
+	u8 *block = vdo->geometry_block.buffer;
 	int result;
 
-	result = vdo_allocate(VDO_BLOCK_SIZE, __func__, &block);
-	if (result != VDO_SUCCESS)
-		return result;
-
-	result = create_metadata_vio(vdo, VIO_TYPE_GEOMETRY, VIO_PRIORITY_HIGH, NULL,
-				     block, &vio);
-	if (result != VDO_SUCCESS) {
-		vdo_free(block);
-		return result;
-	}
-
 	/*
 	 * This is only safe because, having not already loaded the geometry, the vdo's geometry's
 	 * bio_offset field is 0, so the fact that vio_reset_bio() will subtract that offset from
 	 * the supplied pbn is not a problem.
 	 */
-	result = vio_reset_bio(vio, block, NULL, REQ_OP_READ,
+	result = vio_reset_bio(vio, (char *)block, NULL, REQ_OP_READ,
 			       VDO_GEOMETRY_BLOCK_LOCATION);
-	if (result != VDO_SUCCESS) {
-		free_vio(vdo_forget(vio));
-		vdo_free(block);
+	if (result != VDO_SUCCESS)
 		return result;
-	}
 
 	bio_set_dev(vio->bio, vdo_get_backing_device(vdo));
 	submit_bio_wait(vio->bio);
 	result = blk_status_to_errno(vio->bio->bi_status);
-	free_vio(vdo_forget(vio));
 	if (result != 0) {
 		vdo_log_error_strerror(result, "synchronous read failed");
-		vdo_free(block);
 		return -EIO;
 	}
 
-	result = vdo_parse_geometry_block((u8 *) block, &vdo->geometry);
-	vdo_free(block);
-	return result;
+	return vdo_parse_geometry_block(block, &vdo->geometry);
 }
 
 static bool get_zone_thread_name(const thread_id_t thread_ids[], zone_count_t count,
@@ -474,6 +487,19 @@ static int initialize_vdo(struct vdo *vdo, struct device_config *config,
 	vdo_initialize_completion(&vdo->admin.completion, vdo, VDO_ADMIN_COMPLETION);
 	init_completion(&vdo->admin.callback_sync);
 	mutex_init(&vdo->stats_mutex);
+
+	result = initialize_geometry_block(vdo, &vdo->geometry_block);
+	if (result != VDO_SUCCESS) {
+		*reason = "Could not initialize geometry block";
+		return result;
+	}
+
+	result = initialize_super_block(vdo, &vdo->super_block);
+	if (result != VDO_SUCCESS) {
+		*reason = "Could not initialize super block";
+		return result;
+	}
+
 	result = read_geometry_block(vdo);
 	if (result != VDO_SUCCESS) {
 		*reason = "Could not load geometry block";
@@ -646,6 +672,12 @@ static void free_listeners(struct vdo_thread *thread)
 	}
 }
 
+static void uninitialize_geometry_block(struct vdo_geometry_block *geometry_block)
+{
+	free_vio_components(&geometry_block->vio);
+	vdo_free(geometry_block->buffer);
+}
+
 static void uninitialize_super_block(struct vdo_super_block *super_block)
 {
 	free_vio_components(&super_block->vio);
@@ -693,6 +725,7 @@ void vdo_destroy(struct vdo *vdo)
 	vdo_uninitialize_layout(&vdo->next_layout);
 	if (vdo->partition_copier)
 		dm_kcopyd_client_destroy(vdo_forget(vdo->partition_copier));
+	uninitialize_geometry_block(&vdo->geometry_block);
 	uninitialize_super_block(&vdo->super_block);
 	vdo_free_block_map(vdo_forget(vdo->block_map));
 	vdo_free_hash_zones(vdo_forget(vdo->hash_zones));
@@ -718,20 +751,6 @@ void vdo_destroy(struct vdo *vdo)
 	vdo_free(vdo);
 }
 
-static int initialize_super_block(struct vdo *vdo, struct vdo_super_block *super_block)
-{
-	int result;
-
-	result = vdo_allocate(VDO_BLOCK_SIZE, "encoded super block", &vdo->super_block.buffer);
-	if (result != VDO_SUCCESS)
-		return result;
-
-	return allocate_vio_components(vdo, VIO_TYPE_SUPER_BLOCK,
-				       VIO_PRIORITY_METADATA, NULL, 1,
-				       (char *) super_block->buffer,
-				       &vdo->super_block.vio);
-}
-
 /**
  * finish_reading_super_block() - Continue after loading the super block.
  * @completion: The super block vio.
@@ -775,14 +794,6 @@ static void read_super_block_endio(struct bio *bio)
  */
 void vdo_load_super_block(struct vdo *vdo, struct vdo_completion *parent)
 {
-	int result;
-
-	result = initialize_super_block(vdo, &vdo->super_block);
-	if (result != VDO_SUCCESS) {
-		vdo_continue_completion(parent, result);
-		return;
-	}
-
 	vdo->super_block.vio.completion.parent = parent;
 	vdo_submit_metadata_vio(&vdo->super_block.vio,
 				vdo_get_data_region_start(vdo->geometry),
diff --git a/drivers/md/dm-vdo/vdo.h b/drivers/md/dm-vdo/vdo.h
index 1aaba73997b7..21f6ac999e9d 100644
--- a/drivers/md/dm-vdo/vdo.h
+++ b/drivers/md/dm-vdo/vdo.h
@@ -144,6 +144,13 @@ struct thread_config {
 
 struct thread_count_config;
 
+struct vdo_geometry_block {
+	/* The vio for reading and writing the geometry block to disk */
+	struct vio vio;
+	/* A buffer to hold the geometry block */
+	u8 *buffer;
+};
+
 struct vdo_super_block {
 	/* The vio for reading and writing the super block to disk */
 	struct vio vio;
@@ -186,6 +193,9 @@ struct vdo {
 	/* The thread mapping */
 	struct thread_config thread_config;
 
+	/* The geometry block */
+	struct vdo_geometry_block geometry_block;
+
 	/* The super block */
 	struct vdo_super_block super_block;
 
-- 
2.52.0

