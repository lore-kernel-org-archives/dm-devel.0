Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C19A804
	for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 00:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Id9udPn3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700267648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4H3aKGDA8Mx2g5AZpWxfYp0n7YMhm3NHmqyWbuhcEV0=;
	b=Id9udPn3eFbURijoN7DZJHrXM8pU2Ez+1ChqFV6maqyNY+UNW4deG53qq/r1ewE1nHgiW7
	YjRh4PPm33NFWqkawAo7JnJz/kyl4BwARRiPMJMqmtmnG1OJwWEWEW36rvew3gSIa9lLqI
	ECM+UY+Zug0WnI67uULT5D+IXKAAuWM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-rFCAoXXoMFSkMEFhqjlX_w-1; Fri, 17 Nov 2023 19:34:06 -0500
X-MC-Unique: rFCAoXXoMFSkMEFhqjlX_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CB1A8007B3;
	Sat, 18 Nov 2023 00:34:06 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 095CE40C6EB9;
	Sat, 18 Nov 2023 00:34:06 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id B178E3003D; Fri, 17 Nov 2023 19:34:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/5] dm vdo io-submitter: rename to vdo_submit_metadata_vio
Date: Fri, 17 Nov 2023 19:34:02 -0500
Message-Id: <1b6dc8c2237a941ad72b21b0631f98be6f9b220d.1700266895.git.msakai@redhat.com>
In-Reply-To: <cover.1700266895.git.msakai@redhat.com>
References: <cover.1700266895.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Rename submit_metadata_vio() to vdo_submit_metadata_vio().

Reviewed-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c        | 38 +++++++++++++-------------
 drivers/md/dm-vdo/io-submitter.c     | 10 +++----
 drivers/md/dm-vdo/io-submitter.h     | 20 +++++++-------
 drivers/md/dm-vdo/recovery-journal.c |  4 +--
 drivers/md/dm-vdo/repair.c           |  7 +++--
 drivers/md/dm-vdo/slab-depot.c       | 40 ++++++++++++++--------------
 drivers/md/dm-vdo/vdo.c              | 18 ++++++-------
 7 files changed, 68 insertions(+), 69 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index e703cb9eafc6..0df1517294e1 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -786,8 +786,8 @@ static int __must_check launch_page_load(struct page_info *info,
 	cache->outstanding_reads++;
 	ADD_ONCE(cache->stats.pages_loaded, 1);
 	callback = (cache->rebuilding ? handle_rebuild_read_error : handle_load_error);
-	submit_metadata_vio(info->vio, pbn, load_cache_page_endio,
-			    callback, REQ_OP_READ | REQ_PRIO);
+	vdo_submit_metadata_vio(info->vio, pbn, load_cache_page_endio,
+				callback, REQ_OP_READ | REQ_PRIO);
 	return VDO_SUCCESS;
 }
 
@@ -1055,10 +1055,10 @@ static void page_is_written_out(struct vdo_completion *completion)
 
 	if (!page->header.initialized) {
 		page->header.initialized = true;
-		submit_metadata_vio(info->vio, info->pbn,
-				    write_cache_page_endio,
-				    handle_page_write_error,
-				    (REQ_OP_WRITE | REQ_PRIO | REQ_PREFLUSH));
+		vdo_submit_metadata_vio(info->vio, info->pbn,
+					write_cache_page_endio,
+					handle_page_write_error,
+					REQ_OP_WRITE | REQ_PRIO | REQ_PREFLUSH);
 		return;
 	}
 
@@ -1123,8 +1123,8 @@ static void write_pages(struct vdo_completion *flush_completion)
 			continue;
 		}
 		ADD_ONCE(info->cache->stats.pages_saved, 1);
-		submit_metadata_vio(info->vio, info->pbn, write_cache_page_endio,
-				    handle_page_write_error, REQ_OP_WRITE | REQ_PRIO);
+		vdo_submit_metadata_vio(info->vio, info->pbn, write_cache_page_endio,
+					handle_page_write_error, REQ_OP_WRITE | REQ_PRIO);
 	}
 
 	if (has_unflushed_pages) {
@@ -1632,9 +1632,9 @@ static void write_initialized_page(struct vdo_completion *completion)
 	if (zone->flusher == tree_page)
 		operation |= REQ_PREFLUSH;
 
-	submit_metadata_vio(vio, vdo_get_block_map_page_pbn(page),
-			    write_page_endio, handle_write_error,
-			    operation);
+	vdo_submit_metadata_vio(vio, vdo_get_block_map_page_pbn(page),
+				write_page_endio, handle_write_error,
+				operation);
 }
 
 static void write_page_endio(struct bio *bio)
@@ -1689,9 +1689,9 @@ static void write_page(struct tree_page *tree_page, struct pooled_vio *vio)
 	}
 
 	page->header.initialized = true;
-	submit_metadata_vio(&vio->vio, vdo_get_block_map_page_pbn(page),
-			    write_page_endio, handle_write_error,
-			    REQ_OP_WRITE | REQ_PRIO);
+	vdo_submit_metadata_vio(&vio->vio, vdo_get_block_map_page_pbn(page),
+				write_page_endio, handle_write_error,
+				REQ_OP_WRITE | REQ_PRIO);
 }
 
 /* Release a lock on a page which was being loaded or allocated. */
@@ -1879,8 +1879,8 @@ static void load_page(struct waiter *waiter, void *context)
 	physical_block_number_t pbn = lock->tree_slots[lock->height - 1].block_map_slot.pbn;
 
 	pooled->vio.completion.parent = data_vio;
-	submit_metadata_vio(&pooled->vio, pbn, load_page_endio,
-			    handle_io_error, REQ_OP_READ | REQ_PRIO);
+	vdo_submit_metadata_vio(&pooled->vio, pbn, load_page_endio,
+				handle_io_error, REQ_OP_READ | REQ_PRIO);
 }
 
 /*
@@ -2613,9 +2613,9 @@ static void traverse(struct cursor *cursor)
 			next_level->page_index = entry_index;
 			next_level->slot = 0;
 			level->slot++;
-			submit_metadata_vio(&cursor->vio->vio, location.pbn,
-					    traversal_endio, continue_traversal,
-					    REQ_OP_READ | REQ_PRIO);
+			vdo_submit_metadata_vio(&cursor->vio->vio, location.pbn,
+						traversal_endio, continue_traversal,
+						REQ_OP_READ | REQ_PRIO);
 			return;
 		}
 	}
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 6952ee572a7b..8ca9825357e6 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -320,7 +320,7 @@ void submit_data_vio_io(struct data_vio *data_vio)
 }
 
 /**
- * vdo_submit_metadata_io() - Submit I/O for a metadata vio.
+ * __submit_metadata_vio() - Submit I/O for a metadata vio.
  * @vio: the vio for which to issue I/O
  * @physical: the physical block number to read or write
  * @callback: the bio endio function which will be called after the I/O completes
@@ -336,12 +336,12 @@ void submit_data_vio_io(struct data_vio *data_vio)
  * no error can occur on the bio queue. Currently this is true for all callers, but additional care
  * will be needed if this ever changes.
  */
-void vdo_submit_metadata_io(struct vio *vio, physical_block_number_t physical,
-			    bio_end_io_t callback, vdo_action_fn error_handler,
-			    unsigned int operation, char *data)
+void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
+			   bio_end_io_t callback, vdo_action_fn error_handler,
+			   unsigned int operation, char *data)
 {
-	struct vdo_completion *completion = &vio->completion;
 	int result;
+	struct vdo_completion *completion = &vio->completion;
 	const struct admin_state_code *code = vdo_get_admin_state(completion->vdo);
 
 
diff --git a/drivers/md/dm-vdo/io-submitter.h b/drivers/md/dm-vdo/io-submitter.h
index 96befb3739e9..9e97cfc91bee 100644
--- a/drivers/md/dm-vdo/io-submitter.h
+++ b/drivers/md/dm-vdo/io-submitter.h
@@ -24,24 +24,24 @@ void process_vio_io(struct vdo_completion *completion);
 
 void submit_data_vio_io(struct data_vio *data_vio);
 
-void vdo_submit_metadata_io(struct vio *vio, physical_block_number_t physical,
-			    bio_end_io_t callback, vdo_action_fn error_handler,
-			    unsigned int operation, char *data);
+void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
+			   bio_end_io_t callback, vdo_action_fn error_handler,
+			   unsigned int operation, char *data);
 
-static inline void submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
-				       bio_end_io_t callback, vdo_action_fn error_handler,
-				       unsigned int operation)
+static inline void vdo_submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
+					   bio_end_io_t callback, vdo_action_fn error_handler,
+					   unsigned int operation)
 {
-	vdo_submit_metadata_io(vio, physical, callback, error_handler,
-			       operation, vio->data);
+	__submit_metadata_vio(vio, physical, callback, error_handler,
+			      operation, vio->data);
 }
 
 static inline void submit_flush_vio(struct vio *vio, bio_end_io_t callback,
 				    vdo_action_fn error_handler)
 {
 	/* FIXME: Can we just use REQ_OP_FLUSH? */
-	vdo_submit_metadata_io(vio, 0, callback, error_handler,
-			       REQ_OP_WRITE | REQ_PREFLUSH, NULL);
+	__submit_metadata_vio(vio, 0, callback, error_handler,
+			      REQ_OP_WRITE | REQ_PREFLUSH, NULL);
 }
 
 #endif /* VDO_IO_SUBMITTER_H */
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 463f35ae1430..55411eff5bd7 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -1394,8 +1394,8 @@ static void write_block(struct waiter *waiter, void *context __always_unused)
 	 * the data being referenced is stable. The FUA is necessary to ensure that the journal
 	 * block itself is stable before allowing overwrites of the lbn's previous data.
 	 */
-	submit_metadata_vio(&block->vio, journal->origin + block->block_number,
-			    complete_write_endio, handle_write_error, WRITE_FLAGS);
+	vdo_submit_metadata_vio(&block->vio, journal->origin + block->block_number,
+				complete_write_endio, handle_write_error, WRITE_FLAGS);
 }
 
 
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index 2cf99a7ce958..a75278eb8aa4 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -1748,10 +1748,9 @@ void vdo_repair(struct vdo_completion *parent)
 		remaining -= blocks;
 	}
 
-	for (vio_count = 0;
-	     vio_count < repair->vio_count;
+	for (vio_count = 0; vio_count < repair->vio_count;
 	     vio_count++, pbn += MAX_BLOCKS_PER_VIO) {
-		submit_metadata_vio(&repair->vios[vio_count], pbn, read_journal_endio,
-				    handle_journal_load_error, REQ_OP_READ);
+		vdo_submit_metadata_vio(&repair->vios[vio_count], pbn, read_journal_endio,
+					handle_journal_load_error, REQ_OP_READ);
 	}
 }
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 1ad97d2bf80b..5fc4a1cdfafc 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -338,8 +338,8 @@ static void launch_write(struct slab_summary_block *block)
 	pbn = (depot->summary_origin +
 	       (VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE * allocator->zone_number) +
 	       block->index);
-	submit_metadata_vio(&block->vio, pbn, write_slab_summary_endio,
-			    handle_write_error, REQ_OP_WRITE | REQ_PREFLUSH);
+	vdo_submit_metadata_vio(&block->vio, pbn, write_slab_summary_endio,
+				handle_write_error, REQ_OP_WRITE | REQ_PREFLUSH);
 }
 
 /**
@@ -771,8 +771,8 @@ static void write_slab_journal_block(struct waiter *waiter, void *context)
 	 * This block won't be read in recovery until the slab summary is updated to refer to it.
 	 * The slab summary update does a flush which is sufficient to protect us from VDO-2331.
 	 */
-	submit_metadata_vio(uds_forget(vio), block_number, write_slab_journal_endio,
-			    complete_write, REQ_OP_WRITE);
+	vdo_submit_metadata_vio(uds_forget(vio), block_number, write_slab_journal_endio,
+				complete_write, REQ_OP_WRITE);
 
 	/* Since the write is submitted, the tail block structure can be reused. */
 	journal->tail++;
@@ -1205,8 +1205,8 @@ static void write_reference_block(struct waiter *waiter, void *context)
 		   block->slab->allocator->ref_counts_statistics.blocks_written + 1);
 
 	completion->callback_thread_id = ((struct block_allocator *) pooled->context)->thread_id;
-	submit_metadata_vio(&pooled->vio, pbn, write_reference_block_endio,
-			    handle_io_error, REQ_OP_WRITE | REQ_PREFLUSH);
+	vdo_submit_metadata_vio(&pooled->vio, pbn, write_reference_block_endio,
+				handle_io_error, REQ_OP_WRITE | REQ_PREFLUSH);
 }
 
 static void reclaim_journal_space(struct slab_journal *journal)
@@ -2268,9 +2268,9 @@ static void load_reference_block(struct waiter *waiter, void *context)
 	size_t block_offset = (block - block->slab->reference_blocks);
 
 	vio->completion.parent = block;
-	submit_metadata_vio(vio, block->slab->ref_counts_origin + block_offset,
-			    load_reference_block_endio, handle_io_error,
-			    REQ_OP_READ);
+	vdo_submit_metadata_vio(vio, block->slab->ref_counts_origin + block_offset,
+				load_reference_block_endio, handle_io_error,
+				REQ_OP_READ);
 }
 
 /**
@@ -2475,9 +2475,9 @@ static void read_slab_journal_tail(struct waiter *waiter, void *context)
 
 	vio->completion.parent = journal;
 	vio->completion.callback_thread_id = slab->allocator->thread_id;
-	submit_metadata_vio(vio, slab->journal_origin + tail_block,
-			    read_slab_journal_tail_endio, handle_load_error,
-			    REQ_OP_READ);
+	vdo_submit_metadata_vio(vio, slab->journal_origin + tail_block,
+				read_slab_journal_tail_endio, handle_load_error,
+				REQ_OP_READ);
 }
 
 /**
@@ -2915,9 +2915,9 @@ static void start_scrubbing(struct vdo_completion *completion)
 		return;
 	}
 
-	submit_metadata_vio(&scrubber->vio, slab->journal_origin,
-			    read_slab_journal_endio, handle_scrubber_error,
-			    REQ_OP_READ);
+	vdo_submit_metadata_vio(&scrubber->vio, slab->journal_origin,
+				read_slab_journal_endio, handle_scrubber_error,
+				REQ_OP_READ);
 }
 
 /**
@@ -4513,9 +4513,9 @@ static void finish_loading_summary(struct vdo_completion *completion)
 	combine_summaries(depot);
 
 	/* Write the combined summary back out. */
-	submit_metadata_vio(as_vio(completion), depot->summary_origin,
-			    write_summary_endio, handle_combining_error,
-			    REQ_OP_WRITE);
+	vdo_submit_metadata_vio(as_vio(completion), depot->summary_origin,
+				write_summary_endio, handle_combining_error,
+				REQ_OP_WRITE);
 }
 
 static void load_summary_endio(struct bio *bio)
@@ -4555,8 +4555,8 @@ static void load_slab_summary(void *context, struct vdo_completion *parent)
 		return;
 	}
 
-	submit_metadata_vio(vio, depot->summary_origin, load_summary_endio,
-			    handle_combining_error, REQ_OP_READ);
+	vdo_submit_metadata_vio(vio, depot->summary_origin, load_summary_endio,
+				handle_combining_error, REQ_OP_READ);
 }
 
 /* Implements vdo_zone_action_fn. */
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index b494c11e1d64..1ead769f0150 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -813,11 +813,11 @@ void vdo_load_super_block(struct vdo *vdo, struct vdo_completion *parent)
 	}
 
 	vdo->super_block.vio.completion.parent = parent;
-	submit_metadata_vio(&vdo->super_block.vio,
-			    vdo_get_data_region_start(vdo->geometry),
-			    read_super_block_endio,
-			    handle_super_block_read_error,
-			    REQ_OP_READ);
+	vdo_submit_metadata_vio(&vdo->super_block.vio,
+				vdo_get_data_region_start(vdo->geometry),
+				read_super_block_endio,
+				handle_super_block_read_error,
+				REQ_OP_READ);
 }
 
 /**
@@ -1028,10 +1028,10 @@ void vdo_save_components(struct vdo *vdo, struct vdo_completion *parent)
 	vdo_encode_super_block(super_block->buffer, &vdo->states);
 	super_block->vio.completion.parent = parent;
 	super_block->vio.completion.callback_thread_id = parent->callback_thread_id;
-	submit_metadata_vio(&super_block->vio,
-			    vdo_get_data_region_start(vdo->geometry),
-			    super_block_write_endio, handle_save_error,
-			    REQ_OP_WRITE | REQ_PREFLUSH | REQ_FUA);
+	vdo_submit_metadata_vio(&super_block->vio,
+				vdo_get_data_region_start(vdo->geometry),
+				super_block_write_endio, handle_save_error,
+				REQ_OP_WRITE | REQ_PREFLUSH | REQ_FUA);
 }
 
 /**
-- 
2.40.0

