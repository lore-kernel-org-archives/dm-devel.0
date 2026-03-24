Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26C03803F5
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375618; cv=none; b=apyK/W07YMrGEhcgZpvTl6PmzFpVEWBdc3PS6VJQ4ZdHkxS7hlTr7PtMTw0IZKIlLOOwNIZnW2aLZLxA5s29lmBsnsS9wKEbIjwoo/VZYFRXrrmHxB/TX+1ZIfwczMzeFQAJvqqvmJQzwujkbXGoEncU4KaG7y3AGV8VGQHBHhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375618; c=relaxed/simple;
	bh=7ZmPu5RkVZ/UiA2YGezEVAVaQbljMyc+e1DoKcGXVVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=gEvp6ydxgo4AHX67yNDE1ZJdLozJE7exOxM+l6g4xwUDCNDRI5af798FeAB3bPKuo8i0DDF2C+EvPXqnKCSVHLNzAZQhBNJOZN/hU3jYLlaadelKR46ZILCEOBw6tHtjdJNxakEtMat7ZiDmcgpPHbhqFUToM7VDwddN4yHHKcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aPAA5WMX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aPAA5WMX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774375615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iogiQ/bLodN0zyV6Gr/sCcXsebvzsWn3nGamjhdoKgs=;
	b=aPAA5WMX3om7DF7x+UGXJc5vnPBZI7qSpL4f4UR9+lkeTJ+iG/ety/rclKn+LsDU0CwaO5
	/mQze6NqqeKEKfD5/PDxMGt4wCoQUm93/nfpjAJaJGLJrzQfjkidvIc2n7oBF4U/j05ig9
	csb5a8lzLJ81KHrkqt7KQRqXgaxNTCU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-rU5zT7pANqiEZtJwh98nlA-1; Tue,
 24 Mar 2026 14:06:54 -0400
X-MC-Unique: rU5zT7pANqiEZtJwh98nlA-1
X-Mimecast-MFC-AGG-ID: rU5zT7pANqiEZtJwh98nlA_1774375613
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7D401955EAC
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: from vdo-builder-bjohnston.permabit.com (unknown [10.0.101.86])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 89A6B300019F;
	Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: by vdo-builder-bjohnston.permabit.com (Postfix, from userid 1142)
	id 711E21D645; Tue, 24 Mar 2026 14:06:52 -0400 (EDT)
From: Bruce Johnston <bjohnsto@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>
Subject: [PATCH 7/9] dm vdo: add synchronous metadata I/O submission helper
Date: Tue, 24 Mar 2026 14:06:50 -0400
Message-ID: <20260324180652.69439-8-bjohnsto@redhat.com>
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
X-Mimecast-MFC-PROC-ID: AJIo3BU8nlwDPwBg5VqqsDBr7D5ryTS4CPSsEpLZEh4_1774375613
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add vdo_submit_metadata_vio_wait(), a synchronous I/O submission
helper that blocks until completion. This is needed for I/O during
early initialization before work queues are available.

Refactor read_geometry_block() to use it.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
---
 drivers/md/dm-vdo/io-submitter.c | 27 +++++++++++++++++++++++++++
 drivers/md/dm-vdo/io-submitter.h |  4 ++++
 drivers/md/dm-vdo/vdo.c          | 16 +++-------------
 3 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 0e9932929fee..0916c8609543 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -364,6 +364,33 @@ void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 	vdo_launch_completion_with_priority(completion, get_metadata_priority(vio));
 }
 
+/**
+ * vdo_submit_metadata_vio_wait() - Submit I/O for a metadata vio and wait for completion.
+ * @vio: the vio for which to issue I/O
+ * @physical: the physical block number to read or write
+ * @operation: the type of I/O to perform
+ *
+ * The function operates similarly to __submit_metadata_vio except that it will
+ * block until the work is done. It can be used to do i/o before work queues
+ * and thread completions are set up.
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+int vdo_submit_metadata_vio_wait(struct vio *vio,
+				 physical_block_number_t physical,
+				 blk_opf_t operation)
+{
+	int result;
+
+	result = vio_reset_bio(vio, vio->data, NULL, operation | REQ_META, physical);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	bio_set_dev(vio->bio, vdo_get_backing_device(vio->completion.vdo));
+	submit_bio_wait(vio->bio);
+	return blk_status_to_errno(vio->bio->bi_status);
+}
+
 /**
  * vdo_make_io_submitter() - Create an io_submitter structure.
  * @thread_count: Number of bio-submission threads to set up.
diff --git a/drivers/md/dm-vdo/io-submitter.h b/drivers/md/dm-vdo/io-submitter.h
index 3088f11055fd..0f320a60e9e8 100644
--- a/drivers/md/dm-vdo/io-submitter.h
+++ b/drivers/md/dm-vdo/io-submitter.h
@@ -56,4 +56,8 @@ static inline void vdo_submit_flush_vio(struct vio *vio, bio_end_io_t callback,
 			      REQ_OP_WRITE | REQ_PREFLUSH, NULL, 0);
 }
 
+int vdo_submit_metadata_vio_wait(struct vio *vio,
+				 physical_block_number_t physical,
+				 blk_opf_t operation);
+
 #endif /* VDO_IO_SUBMITTER_H */
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 09a1a97b5c31..bc7afbca035d 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -295,8 +295,6 @@ static int initialize_super_block(struct vdo *vdo, struct vdo_super_block *super
  */
 static int __must_check read_geometry_block(struct vdo *vdo)
 {
-	struct vio *vio = &vdo->geometry_block.vio;
-	u8 *block = vdo->geometry_block.buffer;
 	int result;
 
 	/*
@@ -304,20 +302,12 @@ static int __must_check read_geometry_block(struct vdo *vdo)
 	 * bio_offset field is 0, so the fact that vio_reset_bio() will subtract that offset from
 	 * the supplied pbn is not a problem.
 	 */
-	result = vio_reset_bio(vio, (char *)block, NULL, REQ_OP_READ,
-			       VDO_GEOMETRY_BLOCK_LOCATION);
+	result = vdo_submit_metadata_vio_wait(&vdo->geometry_block.vio,
+					      VDO_GEOMETRY_BLOCK_LOCATION, REQ_OP_READ);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	bio_set_dev(vio->bio, vdo_get_backing_device(vdo));
-	submit_bio_wait(vio->bio);
-	result = blk_status_to_errno(vio->bio->bi_status);
-	if (result != 0) {
-		vdo_log_error_strerror(result, "synchronous read failed");
-		return -EIO;
-	}
-
-	return vdo_parse_geometry_block(block, &vdo->geometry);
+	return vdo_parse_geometry_block(vdo->geometry_block.buffer, &vdo->geometry);
 }
 
 static bool get_zone_thread_name(const thread_id_t thread_ids[], zone_count_t count,
-- 
2.52.0

