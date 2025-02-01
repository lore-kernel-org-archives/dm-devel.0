Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F16D136671
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 02:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376295; cv=none; b=deKfnRamLUPP/w8X+LvympvUJktqBCyI5NcGEiow0ajbc+/vRKlKKGLXNuBRspMYAOqSR56zhls93yO4L4wCCLyI/g4OsOAtfF5m0EVrQ0LMNDiTQzELjeWbIoZK4dbaAX7PCY/GnPTrcL9VrApBI4jm9iuIT1djbWQpjMhyp0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376295; c=relaxed/simple;
	bh=mxI0QZgejHmUX0W+5ek/OYMm8+2pW4cSHiRfmzhwrwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=LfFr/NxTqR9umcRIA0/9qarT4SP6cwS7kzfRBoprIy/9U9MMzxZ2Nuc9Y+CrwDcenk5thT4BustGUCXXq4Ebh513PwVwLqqmcfm/mLXL3Hd6jshwIiko/wIf5l6KESAtTPqsXVD2pwUpa6Gr13m4s5WB5br5cBCKskzKcdXL+58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lwe5bI/G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lwe5bI/G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738376292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Qp8cyXexfiOX2ZM5p+eCBZEabfmIDGsF8B9R4n08a4=;
	b=Lwe5bI/G+wXH+4MOMFYc15aCIBwg+0pL2iEPT0PSRNQO9JfB6wNxGQd6dPIM8xC5GPf4qN
	Rx5UtbBfZ2AcHohqPhyveWsuZfVIX9q3SrbY1WhjGNr1vRvaCLff0oBwdjf7DBFLgidCYg
	ZOEn262jgJjkoUvIgM9zLiBPwdEvq8A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-v-q4jLNvMnOe2VyzZsD9bg-1; Fri,
 31 Jan 2025 21:18:08 -0500
X-MC-Unique: v-q4jLNvMnOe2VyzZsD9bg-1
X-Mimecast-MFC-AGG-ID: v-q4jLNvMnOe2VyzZsD9bg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A592E1801F13
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 02:18:07 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 48AE73003FFF;
	Sat,  1 Feb 2025 02:18:07 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 88B8B5F2A2; Fri, 31 Jan 2025 21:18:06 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/4] dm vdo vio-pool: allow variable-sized metadata vios
Date: Fri, 31 Jan 2025 21:18:05 -0500
Message-ID: <0f0f2ea23524a2178666b6dfe51a66051a92a903.1738375023.git.msakai@redhat.com>
In-Reply-To: <cover.1738375023.git.msakai@redhat.com>
References: <cover.1738375023.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qh5PEz8t_NGs0y6Qy5lpNi1fjsyJoluVrEpdbNq2i2A_1738376288
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

With larger-sized metadata vio pools, vdo will sometimes need to
issue I/O with a smaller size than the allocated size. Since
vio_reset_bio is where the bvec array and I/O size are initialized,
this reset interface must now specify what I/O size to use.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/io-submitter.c |  6 ++++--
 drivers/md/dm-vdo/io-submitter.h | 18 +++++++++++++---
 drivers/md/dm-vdo/types.h        |  3 +++
 drivers/md/dm-vdo/vio.c          | 36 +++++++++++++++++++-------------
 drivers/md/dm-vdo/vio.h          |  2 ++
 5 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 421e5436c32c..11d47770b54d 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -327,6 +327,7 @@ void vdo_submit_data_vio(struct data_vio *data_vio)
  * @error_handler: the handler for submission or I/O errors (may be NULL)
  * @operation: the type of I/O to perform
  * @data: the buffer to read or write (may be NULL)
+ * @size: the I/O amount in bytes
  *
  * The vio is enqueued on a vdo bio queue so that bio submission (which may block) does not block
  * other vdo threads.
@@ -338,7 +339,7 @@ void vdo_submit_data_vio(struct data_vio *data_vio)
  */
 void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 			   bio_end_io_t callback, vdo_action_fn error_handler,
-			   blk_opf_t operation, char *data)
+			   blk_opf_t operation, char *data, int size)
 {
 	int result;
 	struct vdo_completion *completion = &vio->completion;
@@ -349,7 +350,8 @@ void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 
 	vdo_reset_completion(completion);
 	completion->error_handler = error_handler;
-	result = vio_reset_bio(vio, data, callback, operation | REQ_META, physical);
+	result = vio_reset_bio_with_size(vio, data, size, callback, operation | REQ_META,
+					 physical);
 	if (result != VDO_SUCCESS) {
 		continue_vio(vio, result);
 		return;
diff --git a/drivers/md/dm-vdo/io-submitter.h b/drivers/md/dm-vdo/io-submitter.h
index 80748699496f..3088f11055fd 100644
--- a/drivers/md/dm-vdo/io-submitter.h
+++ b/drivers/md/dm-vdo/io-submitter.h
@@ -8,6 +8,7 @@
 
 #include <linux/bio.h>
 
+#include "constants.h"
 #include "types.h"
 
 struct io_submitter;
@@ -26,14 +27,25 @@ void vdo_submit_data_vio(struct data_vio *data_vio);
 
 void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 			   bio_end_io_t callback, vdo_action_fn error_handler,
-			   blk_opf_t operation, char *data);
+			   blk_opf_t operation, char *data, int size);
 
 static inline void vdo_submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 					   bio_end_io_t callback, vdo_action_fn error_handler,
 					   blk_opf_t operation)
 {
 	__submit_metadata_vio(vio, physical, callback, error_handler,
-			      operation, vio->data);
+			      operation, vio->data, vio->block_count * VDO_BLOCK_SIZE);
+}
+
+static inline void vdo_submit_metadata_vio_with_size(struct vio *vio,
+						     physical_block_number_t physical,
+						     bio_end_io_t callback,
+						     vdo_action_fn error_handler,
+						     blk_opf_t operation,
+						     int size)
+{
+	__submit_metadata_vio(vio, physical, callback, error_handler,
+			      operation, vio->data, size);
 }
 
 static inline void vdo_submit_flush_vio(struct vio *vio, bio_end_io_t callback,
@@ -41,7 +53,7 @@ static inline void vdo_submit_flush_vio(struct vio *vio, bio_end_io_t callback,
 {
 	/* FIXME: Can we just use REQ_OP_FLUSH? */
 	__submit_metadata_vio(vio, 0, callback, error_handler,
-			      REQ_OP_WRITE | REQ_PREFLUSH, NULL);
+			      REQ_OP_WRITE | REQ_PREFLUSH, NULL, 0);
 }
 
 #endif /* VDO_IO_SUBMITTER_H */
diff --git a/drivers/md/dm-vdo/types.h b/drivers/md/dm-vdo/types.h
index dbe892b10f26..cdf36e7d7702 100644
--- a/drivers/md/dm-vdo/types.h
+++ b/drivers/md/dm-vdo/types.h
@@ -376,6 +376,9 @@ struct vio {
 	/* The size of this vio in blocks */
 	unsigned int block_count;
 
+	/* The amount of data to be read or written, in bytes */
+	unsigned int io_size;
+
 	/* The data being read or written. */
 	char *data;
 
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index f69fb74a238c..e7f4153e55e3 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -188,14 +188,23 @@ void vdo_set_bio_properties(struct bio *bio, struct vio *vio, bio_end_io_t callb
 
 /*
  * Prepares the bio to perform IO with the specified buffer. May only be used on a VDO-allocated
- * bio, as it assumes the bio wraps a 4k buffer that is 4k aligned, but there does not have to be a
- * vio associated with the bio.
+ * bio, as it assumes the bio wraps a 4k-multiple buffer that is 4k aligned, but there does not
+ * have to be a vio associated with the bio.
  */
 int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
 		  blk_opf_t bi_opf, physical_block_number_t pbn)
 {
-	int bvec_count, offset, len, i;
+	return vio_reset_bio_with_size(vio, data, vio->block_count * VDO_BLOCK_SIZE,
+				       callback, bi_opf, pbn);
+}
+
+int vio_reset_bio_with_size(struct vio *vio, char *data, int size, bio_end_io_t callback,
+			    blk_opf_t bi_opf, physical_block_number_t pbn)
+{
+	int bvec_count, offset, i;
 	struct bio *bio = vio->bio;
+	int vio_size = vio->block_count * VDO_BLOCK_SIZE;
+	int remaining;
 
 	bio_reset(bio, bio->bi_bdev, bi_opf);
 	vdo_set_bio_properties(bio, vio, callback, bi_opf, pbn);
@@ -205,22 +214,21 @@ int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
 	bio->bi_ioprio = 0;
 	bio->bi_io_vec = bio->bi_inline_vecs;
 	bio->bi_max_vecs = vio->block_count + 1;
-	len = VDO_BLOCK_SIZE * vio->block_count;
+	if (VDO_ASSERT(size <= vio_size, "specified size %d is not greater than allocated %d",
+		       size, vio_size) != VDO_SUCCESS)
+		size = vio_size;
+	vio->io_size = size;
 	offset = offset_in_page(data);
-	bvec_count = DIV_ROUND_UP(offset + len, PAGE_SIZE);
+	bvec_count = DIV_ROUND_UP(offset + size, PAGE_SIZE);
+	remaining = size;
 
-	/*
-	 * If we knew that data was always on one page, or contiguous pages, we wouldn't need the
-	 * loop. But if we're using vmalloc, it's not impossible that the data is in different
-	 * pages that can't be merged in bio_add_page...
-	 */
-	for (i = 0; (i < bvec_count) && (len > 0); i++) {
+	for (i = 0; (i < bvec_count) && (remaining > 0); i++) {
 		struct page *page;
 		int bytes_added;
 		int bytes = PAGE_SIZE - offset;
 
-		if (bytes > len)
-			bytes = len;
+		if (bytes > remaining)
+			bytes = remaining;
 
 		page = is_vmalloc_addr(data) ? vmalloc_to_page(data) : virt_to_page(data);
 		bytes_added = bio_add_page(bio, page, bytes, offset);
@@ -232,7 +240,7 @@ int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
 		}
 
 		data += bytes;
-		len -= bytes;
+		remaining -= bytes;
 		offset = 0;
 	}
 
diff --git a/drivers/md/dm-vdo/vio.h b/drivers/md/dm-vdo/vio.h
index 8a7e3f72e80b..4bfcb21901f1 100644
--- a/drivers/md/dm-vdo/vio.h
+++ b/drivers/md/dm-vdo/vio.h
@@ -125,6 +125,8 @@ void vdo_set_bio_properties(struct bio *bio, struct vio *vio, bio_end_io_t callb
 
 int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
 		  blk_opf_t bi_opf, physical_block_number_t pbn);
+int vio_reset_bio_with_size(struct vio *vio, char *data, int size, bio_end_io_t callback,
+			    blk_opf_t bi_opf, physical_block_number_t pbn);
 
 void update_vio_error_stats(struct vio *vio, const char *format, ...)
 	__printf(2, 3);
-- 
2.45.2

