Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F5A130499
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 02:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376293; cv=none; b=QtbO63T6MmiRVTZkf1Z0GF2mrnddzMO+x5vYMST7tveARl7PtssETWvp16z/h2fHvde78NXfPjEy0dXUcElaInHFl+wXnjAZY1Mw82FX7OL3OAWY6WDJg4pXJdYuntrkmPczFx1zxFG1GOnGWdOczxDPsSSth6GaH06AancLIcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376293; c=relaxed/simple;
	bh=objr1SWYbwmvYEo4DbNajXeZIjkxdYANayL7lq0gR5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=pS284OsvSYBtTK2CmJ6AKwTWOiK9h1hJoZteEsb8UAkAH5bOyALjPaA7EooB8RjoM/71G/W72izEzMBtkdED8RBGozIArTlwp5sz2JkBKz9gOOUJwHkeN3+VgvJUWaoFvBFj1zl6BMFR+fbr65x9+78fnUB9VWQTVgzdzuMA8/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eFcjX3jv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eFcjX3jv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738376289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U2Y29+E4DaGH/nHacVckDxTHDTY1AOQo4krgfgCbs30=;
	b=eFcjX3jvACqSFHmZE57IyeLY+49eD6nM2pXPiuMXus3lQSjieWycV79pjsnqFUxDffBYrz
	LiZne8FWXRFPf2l8rwJkmQP20BLwV5fUJ7TT7XTp/6wWUI+ordKdSxw/vxwOyCl4d4Kh48
	wmaviUNvZIt5AnY1ZvI7ouyXsEdEUaI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-327-gXwQh8aRPZGU9E4ASazwCA-1; Fri,
 31 Jan 2025 21:18:08 -0500
X-MC-Unique: gXwQh8aRPZGU9E4ASazwCA-1
X-Mimecast-MFC-AGG-ID: gXwQh8aRPZGU9E4ASazwCA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76E921800370
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 02:18:07 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 34D2D180143E;
	Sat,  1 Feb 2025 02:18:07 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 8F2175F2A4; Fri, 31 Jan 2025 21:18:06 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 4/4] dm vdo slab-depot: read refcount blocks in large chunks at load time
Date: Fri, 31 Jan 2025 21:18:06 -0500
Message-ID: <61141d1827a183f396ed3d72dac7e09938d783eb.1738375023.git.msakai@redhat.com>
In-Reply-To: <cover.1738375023.git.msakai@redhat.com>
References: <cover.1738375023.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6V_hoFumHlCicLzzzBQ4miA8RrW3vwJ2BE_mn_TG_e4_1738376287
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

At startup, vdo loads all the reference count data before the device
reports that it is ready. Using a pool of large metadata vios can
improve the startup speed of vdo. The pool of large vios is released
after the device is ready.

During normal operation, reference counts are updated 4kB at a time,
as before.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/slab-depot.c | 63 +++++++++++++++++++++++++---------
 drivers/md/dm-vdo/slab-depot.h | 13 ++++++-
 2 files changed, 59 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 92d1d827800f..9da457c9cc42 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -1170,7 +1170,7 @@ static void handle_io_error(struct vdo_completion *completion)
 
 	vio_record_metadata_io_error(vio);
 	return_vio_to_pool(vio_as_pooled_vio(vio));
-	slab->active_count--;
+	slab->active_count -= vio->io_size / VDO_BLOCK_SIZE;
 	vdo_enter_read_only_mode(slab->allocator->depot->vdo, result);
 	check_if_slab_drained(slab);
 }
@@ -2239,13 +2239,20 @@ static void finish_reference_block_load(struct vdo_completion *completion)
 	struct pooled_vio *pooled = vio_as_pooled_vio(vio);
 	struct reference_block *block = completion->parent;
 	struct vdo_slab *slab = block->slab;
+	unsigned int block_count = vio->io_size / VDO_BLOCK_SIZE;
+	unsigned int i;
+	char *data = vio->data;
+
+	for (i = 0; i < block_count; i++, block++, data += VDO_BLOCK_SIZE) {
+		struct packed_reference_block *packed = (struct packed_reference_block *) data;
 
-	unpack_reference_block((struct packed_reference_block *) vio->data, block);
+		unpack_reference_block(packed, block);
+		clear_provisional_references(block);
+		slab->free_blocks -= block->allocated_count;
+	}
 	return_vio_to_pool(pooled);
-	slab->active_count--;
-	clear_provisional_references(block);
+	slab->active_count -= block_count;
 
-	slab->free_blocks -= block->allocated_count;
 	check_if_slab_drained(slab);
 }
 
@@ -2259,23 +2266,25 @@ static void load_reference_block_endio(struct bio *bio)
 }
 
 /**
- * load_reference_block() - After a block waiter has gotten a VIO from the VIO pool, load the
- *                          block.
- * @waiter: The waiter of the block to load.
+ * load_reference_block_group() - After a block waiter has gotten a VIO from the VIO pool, load
+ *                                a set of blocks.
+ * @waiter: The waiter of the first block to load.
  * @context: The VIO returned by the pool.
  */
-static void load_reference_block(struct vdo_waiter *waiter, void *context)
+static void load_reference_block_group(struct vdo_waiter *waiter, void *context)
 {
 	struct pooled_vio *pooled = context;
 	struct vio *vio = &pooled->vio;
 	struct reference_block *block =
 		container_of(waiter, struct reference_block, waiter);
-	size_t block_offset = (block - block->slab->reference_blocks);
+	u32 block_offset = block - block->slab->reference_blocks;
+	u32 max_block_count = block->slab->reference_block_count - block_offset;
+	u32 block_count = min_t(int, vio->block_count, max_block_count);
 
 	vio->completion.parent = block;
-	vdo_submit_metadata_vio(vio, block->slab->ref_counts_origin + block_offset,
-				load_reference_block_endio, handle_io_error,
-				REQ_OP_READ);
+	vdo_submit_metadata_vio_with_size(vio, block->slab->ref_counts_origin + block_offset,
+					  load_reference_block_endio, handle_io_error,
+					  REQ_OP_READ, block_count * VDO_BLOCK_SIZE);
 }
 
 /**
@@ -2285,14 +2294,21 @@ static void load_reference_block(struct vdo_waiter *waiter, void *context)
 static void load_reference_blocks(struct vdo_slab *slab)
 {
 	block_count_t i;
+	u64 blocks_per_vio = slab->allocator->refcount_blocks_per_big_vio;
+	struct vio_pool *pool = slab->allocator->refcount_big_vio_pool;
+
+	if (!pool) {
+		pool = slab->allocator->vio_pool;
+		blocks_per_vio = 1;
+	}
 
 	slab->free_blocks = slab->block_count;
 	slab->active_count = slab->reference_block_count;
-	for (i = 0; i < slab->reference_block_count; i++) {
+	for (i = 0; i < slab->reference_block_count; i += blocks_per_vio) {
 		struct vdo_waiter *waiter = &slab->reference_blocks[i].waiter;
 
-		waiter->callback = load_reference_block;
-		acquire_vio_from_pool(slab->allocator->vio_pool, waiter);
+		waiter->callback = load_reference_block_group;
+		acquire_vio_from_pool(pool, waiter);
 	}
 }
 
@@ -2699,6 +2715,7 @@ static void finish_scrubbing(struct slab_scrubber *scrubber, int result)
 			vdo_log_info("VDO commencing normal operation");
 		else if (prior_state == VDO_RECOVERING)
 			vdo_log_info("Exiting recovery mode");
+		free_vio_pool(vdo_forget(allocator->refcount_big_vio_pool));
 	}
 
 	/*
@@ -3990,6 +4007,7 @@ static int __must_check initialize_block_allocator(struct slab_depot *depot,
 	struct vdo *vdo = depot->vdo;
 	block_count_t max_free_blocks = depot->slab_config.data_blocks;
 	unsigned int max_priority = (2 + ilog2(max_free_blocks));
+	u32 reference_block_count, refcount_reads_needed, refcount_blocks_per_vio;
 
 	*allocator = (struct block_allocator) {
 		.depot = depot,
@@ -4013,6 +4031,18 @@ static int __must_check initialize_block_allocator(struct slab_depot *depot,
 	if (result != VDO_SUCCESS)
 		return result;
 
+	/* Initialize the refcount-reading vio pool. */
+	reference_block_count = vdo_get_saved_reference_count_size(depot->slab_config.slab_blocks);
+	refcount_reads_needed = DIV_ROUND_UP(reference_block_count, MAX_BLOCKS_PER_VIO);
+	refcount_blocks_per_vio = DIV_ROUND_UP(reference_block_count, refcount_reads_needed);
+	allocator->refcount_blocks_per_big_vio = refcount_blocks_per_vio;
+	result = make_vio_pool(vdo, BLOCK_ALLOCATOR_REFCOUNT_VIO_POOL_SIZE,
+			       allocator->refcount_blocks_per_big_vio, allocator->thread_id,
+			       VIO_TYPE_SLAB_JOURNAL, VIO_PRIORITY_METADATA,
+			       NULL, &allocator->refcount_big_vio_pool);
+	if (result != VDO_SUCCESS)
+		return result;
+
 	result = initialize_slab_scrubber(allocator);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -4230,6 +4260,7 @@ void vdo_free_slab_depot(struct slab_depot *depot)
 		uninitialize_allocator_summary(allocator);
 		uninitialize_scrubber_vio(&allocator->scrubber);
 		free_vio_pool(vdo_forget(allocator->vio_pool));
+		free_vio_pool(vdo_forget(allocator->refcount_big_vio_pool));
 		vdo_free_priority_table(vdo_forget(allocator->prioritized_slabs));
 	}
 
diff --git a/drivers/md/dm-vdo/slab-depot.h b/drivers/md/dm-vdo/slab-depot.h
index f234853501ca..fadc0c9d4dc4 100644
--- a/drivers/md/dm-vdo/slab-depot.h
+++ b/drivers/md/dm-vdo/slab-depot.h
@@ -45,6 +45,13 @@
 enum {
 	/* The number of vios in the vio pool is proportional to the throughput of the VDO. */
 	BLOCK_ALLOCATOR_VIO_POOL_SIZE = 128,
+
+	/*
+	 * The number of vios in the vio pool used for loading reference count data. A slab's
+	 * refcounts is capped at ~8MB, and we process one at a time in a zone, so 9 should be
+	 * plenty.
+	 */
+	BLOCK_ALLOCATOR_REFCOUNT_VIO_POOL_SIZE = 9,
 };
 
 /*
@@ -248,7 +255,7 @@ struct vdo_slab {
 
 	/* A list of the dirty blocks waiting to be written out */
 	struct vdo_wait_queue dirty_blocks;
-	/* The number of blocks which are currently writing */
+	/* The number of blocks which are currently reading or writing */
 	size_t active_count;
 
 	/* A waiter object for updating the slab summary */
@@ -425,6 +432,10 @@ struct block_allocator {
 
 	/* The vio pool for reading and writing block allocator metadata */
 	struct vio_pool *vio_pool;
+	/* The vio pool for large initial reads of ref count areas */
+	struct vio_pool *refcount_big_vio_pool;
+	/* How many ref count blocks are read per vio at initial load */
+	u32 refcount_blocks_per_big_vio;
 	/* The dm_kcopyd client for erasing slab journals */
 	struct dm_kcopyd_client *eraser;
 	/* Iterator over the slabs to be erased */
-- 
2.45.2

