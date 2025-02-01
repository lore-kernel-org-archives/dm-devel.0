Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F42F13212A
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 02:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376295; cv=none; b=Ti+weOXXAfLDDN8wiiaCROauGgt9CSvTwjH4vqDkkEKW+YPfwlaB/1q9VS3zvseGsXjbsIIGA3/j8r7UZ7DYXqbAgGHsMIp7BSDU0A7ldZ14pxdRRF6nR/lPCGR89+q9PX1H/vVKhVNiwleoOidgYjpGzZ6drNiWufrzZhPW1Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376295; c=relaxed/simple;
	bh=aeNtNnGqyk3Hz2rcxUvulZOdAVfylugQFpS40aLVEDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=PLJwKjjlG+tY9qqLRG5obnodiW6on5GiPNQVx8myDEQmIJx62T8wCgeCxOWklrKvDHaDowVBxTr+aAIXqwioVS9yMfxALLZqGtt0aSrqPITcGRgv6g8flUH52YHpAY7vVVgNKFKWJvHgY4NKMaGRt56nObopp01LWGa78iisIzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CJyYyJL9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CJyYyJL9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738376292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FS06WH41Qhs9XJ8BXRnleFKE7zTd5g30qNvqWdSXYb4=;
	b=CJyYyJL94kTp8NCI0Cw3DYxIdk+nGC+JzghMtloRRyZmQ8nLTJ8wAyV7jUkqxQTFrYjYaZ
	jWmYths5loKl81NqjkUu7fSiSmgE2Nboq1O9k0MD85MIz3D0NHoD1EbXh/zPf2LkgnSI+7
	5SPWTz1v9l+mOv2CvKQH6a9ocqckI/g=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-l258auTnMGOjuPomL-D30Q-1; Fri,
 31 Jan 2025 21:18:08 -0500
X-MC-Unique: l258auTnMGOjuPomL-D30Q-1
X-Mimecast-MFC-AGG-ID: l258auTnMGOjuPomL-D30Q
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4EA91800361
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 02:18:07 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 415BA30001BE;
	Sat,  1 Feb 2025 02:18:07 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 7CF5A5F2A0; Fri, 31 Jan 2025 21:18:06 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/4] dm vdo vio-pool: support pools with multiple data blocks per vio
Date: Fri, 31 Jan 2025 21:18:04 -0500
Message-ID: <0ea2b9389d0e35c840d59a35cade71b8a91dfc3f.1738375023.git.msakai@redhat.com>
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
X-Mimecast-MFC-PROC-ID: gYCru0sqOJpKoSGtxts9pFUZdncqc_NcTtzeC_qXj6Y_1738376287
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c  |  2 +-
 drivers/md/dm-vdo/slab-depot.c |  2 +-
 drivers/md/dm-vdo/vio.c        | 10 ++++++----
 drivers/md/dm-vdo/vio.h        |  7 ++++---
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index bc836f95f8b5..1f7cdd837ff9 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -2745,7 +2745,7 @@ static int __must_check initialize_block_map_zone(struct block_map *map,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = make_vio_pool(vdo, BLOCK_MAP_VIO_POOL_SIZE,
+	result = make_vio_pool(vdo, BLOCK_MAP_VIO_POOL_SIZE, 1,
 			       zone->thread_id, VIO_TYPE_BLOCK_MAP_INTERIOR,
 			       VIO_PRIORITY_METADATA, zone, &zone->vio_pool);
 	if (result != VDO_SUCCESS)
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index a556cd5831c1..92d1d827800f 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -4007,7 +4007,7 @@ static int __must_check initialize_block_allocator(struct slab_depot *depot,
 		return result;
 
 	vdo_initialize_completion(&allocator->completion, vdo, VDO_BLOCK_ALLOCATOR_COMPLETION);
-	result = make_vio_pool(vdo, BLOCK_ALLOCATOR_VIO_POOL_SIZE, allocator->thread_id,
+	result = make_vio_pool(vdo, BLOCK_ALLOCATOR_VIO_POOL_SIZE, 1, allocator->thread_id,
 			       VIO_TYPE_SLAB_JOURNAL, VIO_PRIORITY_METADATA,
 			       allocator, &allocator->vio_pool);
 	if (result != VDO_SUCCESS)
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index 4d96989a716d..f69fb74a238c 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -301,6 +301,7 @@ void vio_record_metadata_io_error(struct vio *vio)
  * make_vio_pool() - Create a new vio pool.
  * @vdo: The vdo.
  * @pool_size: The number of vios in the pool.
+ * @block_count: The number of 4k blocks per vio.
  * @thread_id: The ID of the thread using this pool.
  * @vio_type: The type of vios in the pool.
  * @priority: The priority with which vios from the pool should be enqueued.
@@ -309,13 +310,14 @@ void vio_record_metadata_io_error(struct vio *vio)
  *
  * Return: A success or error code.
  */
-int make_vio_pool(struct vdo *vdo, size_t pool_size, thread_id_t thread_id,
+int make_vio_pool(struct vdo *vdo, size_t pool_size, size_t block_count, thread_id_t thread_id,
 		  enum vio_type vio_type, enum vio_priority priority, void *context,
 		  struct vio_pool **pool_ptr)
 {
 	struct vio_pool *pool;
 	char *ptr;
 	int result;
+	size_t per_vio_size = VDO_BLOCK_SIZE * block_count;
 
 	result = vdo_allocate_extended(struct vio_pool, pool_size, struct pooled_vio,
 				       __func__, &pool);
@@ -326,7 +328,7 @@ int make_vio_pool(struct vdo *vdo, size_t pool_size, thread_id_t thread_id,
 	INIT_LIST_HEAD(&pool->available);
 	INIT_LIST_HEAD(&pool->busy);
 
-	result = vdo_allocate(pool_size * VDO_BLOCK_SIZE, char,
+	result = vdo_allocate(pool_size * per_vio_size, char,
 			      "VIO pool buffer", &pool->buffer);
 	if (result != VDO_SUCCESS) {
 		free_vio_pool(pool);
@@ -334,10 +336,10 @@ int make_vio_pool(struct vdo *vdo, size_t pool_size, thread_id_t thread_id,
 	}
 
 	ptr = pool->buffer;
-	for (pool->size = 0; pool->size < pool_size; pool->size++, ptr += VDO_BLOCK_SIZE) {
+	for (pool->size = 0; pool->size < pool_size; pool->size++, ptr += per_vio_size) {
 		struct pooled_vio *pooled = &pool->vios[pool->size];
 
-		result = allocate_vio_components(vdo, vio_type, priority, NULL, 1, ptr,
+		result = allocate_vio_components(vdo, vio_type, priority, NULL, block_count, ptr,
 						 &pooled->vio);
 		if (result != VDO_SUCCESS) {
 			free_vio_pool(pool);
diff --git a/drivers/md/dm-vdo/vio.h b/drivers/md/dm-vdo/vio.h
index 2e3f878e2074..8a7e3f72e80b 100644
--- a/drivers/md/dm-vdo/vio.h
+++ b/drivers/md/dm-vdo/vio.h
@@ -190,9 +190,10 @@ static inline struct pooled_vio *vio_as_pooled_vio(struct vio *vio)
 
 struct vio_pool;
 
-int __must_check make_vio_pool(struct vdo *vdo, size_t pool_size, thread_id_t thread_id,
-			       enum vio_type vio_type, enum vio_priority priority,
-			       void *context, struct vio_pool **pool_ptr);
+int __must_check make_vio_pool(struct vdo *vdo, size_t pool_size, size_t block_count,
+			       thread_id_t thread_id, enum vio_type vio_type,
+			       enum vio_priority priority, void *context,
+			       struct vio_pool **pool_ptr);
 void free_vio_pool(struct vio_pool *pool);
 bool __must_check is_vio_pool_busy(struct vio_pool *pool);
 void acquire_vio_from_pool(struct vio_pool *pool, struct vdo_waiter *waiter);
-- 
2.45.2

