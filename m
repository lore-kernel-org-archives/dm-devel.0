Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F3512FF69
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 02:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376292; cv=none; b=Y6sM/zpokZdn5W661Sa5HReLrgbr348Y5qdSDLhcX1iZHA7H4fDEXI8IxTeaqpOBr5Rd8WKnpqo6rb5WZ6oq7LzqVztPv1ySJpg7bM5HK3D6OyG855S6LYTNzLvHyeRyWgc1MBHfaBgWJ7eHcH8tGI9SxglX2TxyPdqk3XkTV6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376292; c=relaxed/simple;
	bh=shArbHG/q4r5yzF9nmncaMrQLZqgQGD/n0rOhAfB0PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=DvUUFOblbKDXgpZVvq2RplYoXJt/ks0sPrLdyEXLQaoPG3WgNK0qFcoC9esUU2hywyuBYUNH5nwmmEcG9p3QQfM68txauKC7718DJYJ+NQAmb1Mgr0DgfJ2MZtiqjZaXNTYj9PjBW2+Cj6pCtYjFYuUh2y27MUzVLG5KXd6LKSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hx8o7ONr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hx8o7ONr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738376289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMzjx42T3DpWE2waPvfCLMmM1F8x7iOnfhx5kLEEYJA=;
	b=hx8o7ONr3gSwHL4iz5JToHHVm/nANTX+0Z04i3FzZCThcEGJQ9EdoVUoliCuEMoU3X8C+2
	p5f4R/K+2uMP0WqoErSNUUwSt4Q4n77T2sPeN6di3YpvkFF4t5eHRqvL+xsUSlEw/73bVP
	ayctu2TJQhBKYpmKhNJU06k7XXWXaRU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-4ArgLBn3MlCGNx0ONY6mdg-1; Fri,
 31 Jan 2025 21:18:08 -0500
X-MC-Unique: 4ArgLBn3MlCGNx0ONY6mdg-1
X-Mimecast-MFC-AGG-ID: 4ArgLBn3MlCGNx0ONY6mdg
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A16619560B8
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 02:18:07 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 360E91801480;
	Sat,  1 Feb 2025 02:18:07 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 744755F29E; Fri, 31 Jan 2025 21:18:06 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/4] dm vdo vio-pool: add a pool pointer to pooled_vio
Date: Fri, 31 Jan 2025 21:18:03 -0500
Message-ID: <2eecd996045e8ad6274dedddcfcd7c79c57223ad.1738375023.git.msakai@redhat.com>
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
X-Mimecast-MFC-PROC-ID: -BXVjP_DP0Gi_2qGeotofmf1_xVPNIjSAUEfC3psGwg_1738376287
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

This allows us to simplify the return_vio_to_pool interface.

Also, we don't need to use vdo_forget on local variables or arguments
that are about to go out of scope anyway.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c  |  9 ++++-----
 drivers/md/dm-vdo/slab-depot.c | 15 +++++++--------
 drivers/md/dm-vdo/vio.c        |  8 +++++---
 drivers/md/dm-vdo/vio.h        |  4 +++-
 4 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 89cb7942ec5c..bc836f95f8b5 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -1544,7 +1544,7 @@ static void write_page_if_not_dirtied(struct vdo_waiter *waiter, void *context)
 
 static void return_to_pool(struct block_map_zone *zone, struct pooled_vio *vio)
 {
-	return_vio_to_pool(zone->vio_pool, vio);
+	return_vio_to_pool(vio);
 	check_for_drain_complete(zone);
 }
 
@@ -1837,7 +1837,7 @@ static void finish_block_map_page_load(struct vdo_completion *completion)
 
 	if (!vdo_copy_valid_page(vio->data, nonce, pbn, page))
 		vdo_format_block_map_page(page, nonce, pbn, false);
-	return_vio_to_pool(zone->vio_pool, pooled);
+	return_vio_to_pool(pooled);
 
 	/* Release our claim to the load and wake any waiters */
 	release_page_lock(data_vio, "load");
@@ -1851,10 +1851,9 @@ static void handle_io_error(struct vdo_completion *completion)
 	struct vio *vio = as_vio(completion);
 	struct pooled_vio *pooled = container_of(vio, struct pooled_vio, vio);
 	struct data_vio *data_vio = completion->parent;
-	struct block_map_zone *zone = pooled->context;
 
 	vio_record_metadata_io_error(vio);
-	return_vio_to_pool(zone->vio_pool, pooled);
+	return_vio_to_pool(pooled);
 	abort_load(data_vio, result);
 }
 
@@ -2499,7 +2498,7 @@ static void finish_cursor(struct cursor *cursor)
 	struct cursors *cursors = cursor->parent;
 	struct vdo_completion *completion = cursors->completion;
 
-	return_vio_to_pool(cursors->pool, vdo_forget(cursor->vio));
+	return_vio_to_pool(vdo_forget(cursor->vio));
 	if (--cursors->active_roots > 0)
 		return;
 
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 625d7fd702ab..a556cd5831c1 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -414,8 +414,7 @@ static void complete_reaping(struct vdo_completion *completion)
 {
 	struct slab_journal *journal = completion->parent;
 
-	return_vio_to_pool(journal->slab->allocator->vio_pool,
-			   vio_as_pooled_vio(as_vio(vdo_forget(completion))));
+	return_vio_to_pool(vio_as_pooled_vio(as_vio(completion)));
 	finish_reaping(journal);
 	reap_slab_journal(journal);
 }
@@ -698,7 +697,7 @@ static void complete_write(struct vdo_completion *completion)
 	sequence_number_t committed = get_committing_sequence_number(pooled);
 
 	list_del_init(&pooled->list_entry);
-	return_vio_to_pool(journal->slab->allocator->vio_pool, vdo_forget(pooled));
+	return_vio_to_pool(pooled);
 
 	if (result != VDO_SUCCESS) {
 		vio_record_metadata_io_error(as_vio(completion));
@@ -1076,7 +1075,7 @@ static void finish_reference_block_write(struct vdo_completion *completion)
 	/* Release the slab journal lock. */
 	adjust_slab_journal_block_reference(&slab->journal,
 					    block->slab_journal_lock_to_release, -1);
-	return_vio_to_pool(slab->allocator->vio_pool, pooled);
+	return_vio_to_pool(pooled);
 
 	/*
 	 * We can't clear the is_writing flag earlier as releasing the slab journal lock may cause
@@ -1170,7 +1169,7 @@ static void handle_io_error(struct vdo_completion *completion)
 	struct vdo_slab *slab = ((struct reference_block *) completion->parent)->slab;
 
 	vio_record_metadata_io_error(vio);
-	return_vio_to_pool(slab->allocator->vio_pool, vio_as_pooled_vio(vio));
+	return_vio_to_pool(vio_as_pooled_vio(vio));
 	slab->active_count--;
 	vdo_enter_read_only_mode(slab->allocator->depot->vdo, result);
 	check_if_slab_drained(slab);
@@ -2242,7 +2241,7 @@ static void finish_reference_block_load(struct vdo_completion *completion)
 	struct vdo_slab *slab = block->slab;
 
 	unpack_reference_block((struct packed_reference_block *) vio->data, block);
-	return_vio_to_pool(slab->allocator->vio_pool, pooled);
+	return_vio_to_pool(pooled);
 	slab->active_count--;
 	clear_provisional_references(block);
 
@@ -2429,7 +2428,7 @@ static void finish_loading_journal(struct vdo_completion *completion)
 		initialize_journal_state(journal);
 	}
 
-	return_vio_to_pool(slab->allocator->vio_pool, vio_as_pooled_vio(vio));
+	return_vio_to_pool(vio_as_pooled_vio(vio));
 	vdo_finish_loading_with_result(&slab->state, allocate_counters_if_clean(slab));
 }
 
@@ -2449,7 +2448,7 @@ static void handle_load_error(struct vdo_completion *completion)
 	struct vio *vio = as_vio(completion);
 
 	vio_record_metadata_io_error(vio);
-	return_vio_to_pool(journal->slab->allocator->vio_pool, vio_as_pooled_vio(vio));
+	return_vio_to_pool(vio_as_pooled_vio(vio));
 	vdo_finish_loading_with_result(&journal->slab->state, result);
 }
 
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index e710f3c5a972..4d96989a716d 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -345,6 +345,7 @@ int make_vio_pool(struct vdo *vdo, size_t pool_size, thread_id_t thread_id,
 		}
 
 		pooled->context = context;
+		pooled->pool = pool;
 		list_add_tail(&pooled->pool_entry, &pool->available);
 	}
 
@@ -419,12 +420,13 @@ void acquire_vio_from_pool(struct vio_pool *pool, struct vdo_waiter *waiter)
 }
 
 /**
- * return_vio_to_pool() - Return a vio to the pool
- * @pool: The vio pool.
+ * return_vio_to_pool() - Return a vio to its pool
  * @vio: The pooled vio to return.
  */
-void return_vio_to_pool(struct vio_pool *pool, struct pooled_vio *vio)
+void return_vio_to_pool(struct pooled_vio *vio)
 {
+	struct vio_pool *pool = vio->pool;
+
 	VDO_ASSERT_LOG_ONLY((pool->thread_id == vdo_get_callback_thread_id()),
 			    "vio pool entry returned on same thread as it was acquired");
 
diff --git a/drivers/md/dm-vdo/vio.h b/drivers/md/dm-vdo/vio.h
index 3490e9f59b04..2e3f878e2074 100644
--- a/drivers/md/dm-vdo/vio.h
+++ b/drivers/md/dm-vdo/vio.h
@@ -30,6 +30,8 @@ struct pooled_vio {
 	void *context;
 	/* The list entry used by the pool */
 	struct list_head pool_entry;
+	/* The pool this vio is allocated from */
+	struct vio_pool *pool;
 };
 
 /**
@@ -194,6 +196,6 @@ int __must_check make_vio_pool(struct vdo *vdo, size_t pool_size, thread_id_t th
 void free_vio_pool(struct vio_pool *pool);
 bool __must_check is_vio_pool_busy(struct vio_pool *pool);
 void acquire_vio_from_pool(struct vio_pool *pool, struct vdo_waiter *waiter);
-void return_vio_to_pool(struct vio_pool *pool, struct pooled_vio *vio);
+void return_vio_to_pool(struct pooled_vio *vio);
 
 #endif /* VIO_H */
-- 
2.45.2

