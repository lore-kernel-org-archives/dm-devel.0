Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4220CAD39
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 00:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730766318; cv=none; b=bktG9lZqGyNj+PXSAarcot+FvuHWatup5yFR92qgsWoDsk6yVtjnFvglDVlTc9tJF/NzhYEcf8nwXS47boQRghSIxv65n66FvvwV7g8WUqoPZtadQnN/YSfXU8qqkruxP/XtsMv97LuI60M/QtxRZVYlxStMBWR6nYWJFqiA7XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730766318; c=relaxed/simple;
	bh=FqM32doXIXu2kHUtEcgWLEYz8iAVkK397L9sM5TrC/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dODXgbPpb0DOrlmvEzFo+8IUvZt/roxrm52O7mcU7PSmff00SLldiHhoHDWM0u+ENdhyS6QQclJNYRWBuH394cWmAn/W73+4mU3em2w/9jwHTr+TeEgtixApQrFXI/cSDZzhO5VkIcc4im4S/nIWVrxC03mxVq2kgUrFcpKXyLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nyoz23T6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nyoz23T6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730766315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dU2psqV/sGhbo8UnzIpZ6Z+JgidAQT+sbTfqAxAmCno=;
	b=Nyoz23T6hcmQ81hEJoKc3ztimAeo89VLW071flbSkcumKzec50o8yg0ngAmMDsWIgykRw0
	3Zoe5XPau/QPqtp32fNqN9Kvp05LdDDd5wOrt08SKBkx0vRRRw5C8BDFSldBNkufejvmMN
	oa++1qVTfgKrErKvd3JxN1jgywFZkwQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-284-ZSeLiJZ7N4-TOimy7ZiN3Q-1; Mon,
 04 Nov 2024 19:25:13 -0500
X-MC-Unique: ZSeLiJZ7N4-TOimy7ZiN3Q-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B78B19560A3
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 00:25:11 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC0FC3000198;
	Tue,  5 Nov 2024 00:25:10 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 547AD59E6C; Mon,  4 Nov 2024 19:25:10 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/2] dm vdo: fix function doc comment formatting
Date: Mon,  4 Nov 2024 19:25:10 -0500
Message-ID: <2b42665e31119af8120b9a94f7a2d384f57b545a.1730766085.git.msakai@redhat.com>
In-Reply-To: <cover.1730766085.git.msakai@redhat.com>
References: <cover.1730766085.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c        | 2 --
 drivers/md/dm-vdo/data-vio.c         | 7 ++++---
 drivers/md/dm-vdo/dedupe.c           | 9 +++++----
 drivers/md/dm-vdo/encodings.c        | 2 +-
 drivers/md/dm-vdo/io-submitter.c     | 2 +-
 drivers/md/dm-vdo/packer.c           | 3 +--
 drivers/md/dm-vdo/physical-zone.c    | 2 +-
 drivers/md/dm-vdo/recovery-journal.c | 2 +-
 drivers/md/dm-vdo/slab-depot.c       | 9 +++------
 drivers/md/dm-vdo/vdo.c              | 4 ++--
 10 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index a0a7c1bd634e..89cb7942ec5c 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -209,8 +209,6 @@ static int initialize_info(struct vdo_page_cache *cache)
 /**
  * allocate_cache_components() - Allocate components of the cache which require their own
  *                               allocation.
- * @maximum_age: The number of journal blocks before a dirtied page is considered old and must be
- *               written out.
  *
  * The caller is responsible for all clean up on errors.
  *
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 0d502f6a86ad..a2e03a064c11 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -327,8 +327,9 @@ static u32 __must_check pack_status(struct data_vio_compression_status status)
 
 /**
  * set_data_vio_compression_status() - Set the compression status of a data_vio.
- * @state: The expected current status of the data_vio.
- * @new_state: The status to set.
+ * @data_vio: The data_vio to change.
+ * @status: The expected current status of the data_vio.
+ * @new_status: The status to set.
  *
  * Return: true if the new status was set, false if the data_vio's compression status did not
  *         match the expected state, and so was left unchanged.
@@ -836,7 +837,7 @@ static void destroy_data_vio(struct data_vio *data_vio)
  * @vdo: The vdo to which the pool will belong.
  * @pool_size: The number of data_vios in the pool.
  * @discard_limit: The maximum number of data_vios which may be used for discards.
- * @pool: A pointer to hold the newly allocated pool.
+ * @pool_ptr: A pointer to hold the newly allocated pool.
  */
 int make_data_vio_pool(struct vdo *vdo, data_vio_count_t pool_size,
 		       data_vio_count_t discard_limit, struct data_vio_pool **pool_ptr)
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 80628ae93fba..b6f8e2dc7729 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -565,7 +565,7 @@ static void wait_on_hash_lock(struct hash_lock *lock, struct data_vio *data_vio)
  * @waiter: The data_vio's waiter link.
  * @context: Not used.
  */
-static void abort_waiter(struct vdo_waiter *waiter, void *context __always_unused)
+static void abort_waiter(struct vdo_waiter *waiter, void __always_unused *context)
 {
 	write_data_vio(vdo_waiter_as_data_vio(waiter));
 }
@@ -1727,7 +1727,7 @@ static void report_bogus_lock_state(struct hash_lock *lock, struct data_vio *dat
 /**
  * vdo_continue_hash_lock() - Continue the processing state after writing, compressing, or
  *                            deduplicating.
- * @data_vio: The data_vio to continue processing in its hash lock.
+ * @completion: The data_vio completion to continue processing in its hash lock.
  *
  * Asynchronously continue processing a data_vio in its hash lock after it has finished writing,
  * compressing, or deduplicating, so it can share the result with any data_vios waiting in the hash
@@ -1825,7 +1825,7 @@ static inline int assert_hash_lock_preconditions(const struct data_vio *data_vio
 
 /**
  * vdo_acquire_hash_lock() - Acquire or share a lock on a record name.
- * @data_vio: The data_vio acquiring a lock on its record name.
+ * @completion: The data_vio completion acquiring a lock on its record name.
  *
  * Acquire or share a lock on the hash (record name) of the data in a data_vio, updating the
  * data_vio to reference the lock. This must only be called in the correct thread for the zone. In
@@ -2679,7 +2679,8 @@ static void get_index_statistics(struct hash_zones *zones,
 
 /**
  * vdo_get_dedupe_statistics() - Tally the statistics from all the hash zones and the UDS index.
- * @hash_zones: The hash zones to query
+ * @zones: The hash zones to query
+ * @stats: A structure to store the statistics
  *
  * Return: The sum of the hash lock statistics from all hash zones plus the statistics from the UDS
  *         index
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index a34ea0229d53..100e92f8f866 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -858,7 +858,7 @@ static int __must_check make_partition(struct layout *layout, enum partition_id
 /**
  * vdo_initialize_layout() - Lay out the partitions of a vdo.
  * @size: The entire size of the vdo.
- * @origin: The start of the layout on the underlying storage in blocks.
+ * @offset: The start of the layout on the underlying storage in blocks.
  * @block_map_blocks: The size of the block map partition.
  * @journal_blocks: The size of the journal partition.
  * @summary_blocks: The size of the slab summary partition.
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index ab62abe18827..421e5436c32c 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -367,7 +367,7 @@ void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
  *                     completions.
  * @max_requests_active: Number of bios for merge tracking.
  * @vdo: The vdo which will use this submitter.
- * @io_submitter: pointer to the new data structure.
+ * @io_submitter_ptr: pointer to the new data structure.
  *
  * Return: VDO_SUCCESS or an error.
  */
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index 16cf29b4c90a..f70f5edabc10 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -250,7 +250,6 @@ static void abort_packing(struct data_vio *data_vio)
 /**
  * release_compressed_write_waiter() - Update a data_vio for which a successful compressed write
  *                                     has completed and send it on its way.
-
  * @data_vio: The data_vio to release.
  * @allocation: The allocation to which the compressed block was written.
  */
@@ -383,7 +382,7 @@ static void initialize_compressed_block(struct compressed_block *block, u16 size
  * @compression: The agent's compression_state to pack in to.
  * @data_vio: The data_vio to pack.
  * @offset: The offset into the compressed block at which to pack the fragment.
- * @compressed_block: The compressed block which will be written out when batch is fully packed.
+ * @block: The compressed block which will be written out when batch is fully packed.
  *
  * Return: The new amount of space used.
  */
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index 2fee3a7c1191..a43b5c45fab7 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -517,7 +517,7 @@ static int allocate_and_lock_block(struct allocation *allocation)
  * @waiter: The allocating_vio that was waiting to allocate.
  * @context: The context (unused).
  */
-static void retry_allocation(struct vdo_waiter *waiter, void *context __always_unused)
+static void retry_allocation(struct vdo_waiter *waiter, void __always_unused *context)
 {
 	struct data_vio *data_vio = vdo_waiter_as_data_vio(waiter);
 
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index ee6321a3e523..de58184f538f 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -1365,7 +1365,7 @@ static void add_queued_recovery_entries(struct recovery_journal_block *block)
  *
  * Implements waiter_callback_fn.
  */
-static void write_block(struct vdo_waiter *waiter, void *context __always_unused)
+static void write_block(struct vdo_waiter *waiter, void __always_unused *context)
 {
 	struct recovery_journal_block *block =
 		container_of(waiter, struct recovery_journal_block, write_waiter);
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 274f9ccd072f..625d7fd702ab 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -1287,7 +1287,7 @@ static struct reference_block * __must_check get_reference_block(struct vdo_slab
  * slab_block_number_from_pbn() - Determine the index within the slab of a particular physical
  *                                block number.
  * @slab: The slab.
- * @physical_block_number: The physical block number.
+ * @pbn: The physical block number.
  * @slab_block_number_ptr: A pointer to the slab block number.
  *
  * Return: VDO_SUCCESS or an error code.
@@ -1459,7 +1459,6 @@ static int increment_for_data(struct vdo_slab *slab, struct reference_block *blo
  * @block_number: The block to update.
  * @old_status: The reference status of the data block before this decrement.
  * @updater: The reference updater doing this operation in case we need to look up the pbn lock.
- * @lock: The pbn_lock associated with the block being decremented (may be NULL).
  * @counter_ptr: A pointer to the count for the data block (in, out).
  * @adjust_block_count: Whether to update the allocator's free block count.
  *
@@ -3232,8 +3231,7 @@ int vdo_enqueue_clean_slab_waiter(struct block_allocator *allocator,
 /**
  * vdo_modify_reference_count() - Modify the reference count of a block by first making a slab
  *                                journal entry and then updating the reference counter.
- *
- * @data_vio: The data_vio for which to add the entry.
+ * @completion: The data_vio completion for which to add the entry.
  * @updater: Which of the data_vio's reference updaters is being submitted.
  */
 void vdo_modify_reference_count(struct vdo_completion *completion,
@@ -4750,8 +4748,7 @@ void vdo_use_new_slabs(struct slab_depot *depot, struct vdo_completion *parent)
 /**
  * stop_scrubbing() - Tell the scrubber to stop scrubbing after it finishes the slab it is
  *                    currently working on.
- * @scrubber: The scrubber to stop.
- * @parent: The completion to notify when scrubbing has stopped.
+ * @allocator: The block allocator owning the scrubber to stop.
  */
 static void stop_scrubbing(struct block_allocator *allocator)
 {
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index fff847767755..a7e32baab4af 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -643,7 +643,7 @@ static void finish_vdo(struct vdo *vdo)
 
 /**
  * free_listeners() - Free the list of read-only listeners associated with a thread.
- * @thread_data: The thread holding the list to free.
+ * @thread: The thread holding the list to free.
  */
 static void free_listeners(struct vdo_thread *thread)
 {
@@ -852,7 +852,7 @@ int vdo_synchronous_flush(struct vdo *vdo)
 /**
  * vdo_get_state() - Get the current state of the vdo.
  * @vdo: The vdo.
-
+ *
  * Context: This method may be called from any thread.
  *
  * Return: The current state of the vdo.
-- 
2.45.2

