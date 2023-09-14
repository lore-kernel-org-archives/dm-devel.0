Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA58EEAA66
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719142;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oLyQStahsbAJzQ8pb5st8pVY33FDzTT9XlePzyGmHOQ=;
	b=c5wEvd4o0YGKuuV6HRRPoKy3zP4F3hV1EnwoD22xD6TFXZl+wVIgA2Mt7K5TqVFTUP7kg7
	Qi0OQ8uD3co1z0aWQvceXDsvkjZy8ofxOithTkU5EdkokLWYb4YzGvq65iA2AbXYbu5DcO
	gZFYr42IL0SEP2CjyG3/u4B8gFXi8vw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-RYy6rcWyP-aGzLfDaQJPTQ-1; Thu, 14 Sep 2023 15:18:59 -0400
X-MC-Unique: RYy6rcWyP-aGzLfDaQJPTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92B72806519;
	Thu, 14 Sep 2023 19:18:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7CE139A;
	Thu, 14 Sep 2023 19:18:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2F2371946A7E;
	Thu, 14 Sep 2023 19:17:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 762C019452FF
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:17:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 66B9A1686D; Thu, 14 Sep 2023 19:17:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EE6F9A
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:36 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37B03185A78E
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:36 +0000 (UTC)
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com
 [209.85.160.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-tVVyMTfVPV2JRASIMHRxvw-1; Thu, 14 Sep 2023 15:17:34 -0400
X-MC-Unique: tVVyMTfVPV2JRASIMHRxvw-1
Received: by mail-oa1-f41.google.com with SMTP id
 586e51a60fabf-1c8e9d75ce1so683841fac.3
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719052; x=1695323852;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=oLr7yNAqwAuODo3rDZoyrSkFEh0okfruJmw+71Rpczc=;
 b=IDul1tt6Qk2JK4PnlFTc5zt26M5Z8OM0u4OPe2xVa7eKbz6Qqu8NXO4m16YttIx1AK
 TIQ10w8gb4jINYifVP2v/nhW9YZiGPZNsMd2rfp4l5j8UGHBpPppzrbaXm6PZyzxxKGV
 HeYGKgnlNIk4UfKKhkGHGm+gOzkJE0PC9u72FEEFJ9t9mG3RlITJhfNb8XfesV0KapbF
 zpLDsvVmdE+FJNB1BrOX2vOo8L+y5jDhqlyb/jl7+RP/w1kqEV/NXJT8+Tqw9PfCWuEA
 kYqq6R4fT35DU0Rs4yWHnLQbnQwIfnaL52LkwnQmVDC6DxPSCJOcyKoh7as5x+UVscvO
 m+QA==
X-Gm-Message-State: AOJu0Yxw/0RV8Umcdr9jodMr9lYpPzxsUxTTUvcP3yiuvWRL24Ng7YR5
 IzB+Ci6fvZ5YgVNrY2KhR9JgxIEbLGrG4GaisfFD0Gac8mo5ifwVEecw/zINlUOegoG8EdjJ6aE
 7ZCZDVaMWDKYAYITpZzEVc1tAHg2g+/ds2Hll0tkZN3X9aSPEC1cDL2ZXhMEed8NdDegYxscr
X-Google-Smtp-Source: AGHT+IFVDijZKaSppULLruJZlVtJbVd6l6y7Nfo/tfPc7KPbLEhheBeBsujoWHG/L3fxGe8sATGwKw==
X-Received: by 2002:a05:6870:2d1:b0:1bf:54b9:800 with SMTP id
 r17-20020a05687002d100b001bf54b90800mr6201713oaf.59.1694719051769; 
 Thu, 14 Sep 2023 12:17:31 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 jx14-20020a05622a810e00b00401f7f23ab6sm640619qtb.85.2023.09.14.12.17.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:17:31 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:16:24 -0400
Message-Id: <20230914191635.39805-29-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v3 28/39] dm vdo: add the slab depot
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Matthew Sakai <msakai@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Matthew Sakai <msakai@redhat.com>

Add the data and methods that implement the slab_depot that manages
the allocation of slabs of blocks added by the preceding commits.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: Michael Sclafani <vdo-devel@redhat.com>
Signed-off-by: Michael Sclafani <vdo-devel@redhat.com>
Co-developed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-vdo/slab-depot.c | 965 +++++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/slab-depot.h | 121 +++++
 2 files changed, 1086 insertions(+)

diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index dbed9c3c8a62..ba9cdb720506 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -3070,6 +3070,32 @@ static void register_slab_with_allocator(struct block_allocator *allocator, stru
 	allocator->last_slab = slab->slab_number;
 }
 
+/**
+ * get_depot_slab_iterator() - Return a slab_iterator over the slabs in a slab_depot.
+ * @depot: The depot over which to iterate.
+ * @start: The number of the slab to start iterating from.
+ * @end: The number of the last slab which may be returned.
+ * @stride: The difference in slab number between successive slabs.
+ *
+ * Iteration always occurs from higher to lower numbered slabs.
+ *
+ * Return: An initialized iterator structure.
+ */
+static struct slab_iterator get_depot_slab_iterator(struct slab_depot *depot,
+						    slab_count_t start,
+						    slab_count_t end,
+						    slab_count_t stride)
+{
+	struct vdo_slab **slabs = depot->slabs;
+
+	return (struct slab_iterator) {
+		.slabs = slabs,
+		.next = (((slabs == NULL) || (start < end)) ? NULL : slabs[start]),
+		.end = end,
+		.stride = stride,
+	};
+}
+
 static struct slab_iterator get_slab_iterator(const struct block_allocator *allocator)
 {
 	return get_depot_slab_iterator(allocator->depot,
@@ -3806,6 +3832,171 @@ make_slab(physical_block_number_t slab_origin,
 	return VDO_SUCCESS;
 }
 
+/**
+ * allocate_slabs() - Allocate a new slab pointer array.
+ * @depot: The depot.
+ * @slab_count: The number of slabs the depot should have in the new array.
+ *
+ * Any existing slab pointers will be copied into the new array, and slabs will be allocated as
+ * needed. The newly allocated slabs will not be distributed for use by the block allocators.
+ *
+ * Return: VDO_SUCCESS or an error code.
+ */
+static int allocate_slabs(struct slab_depot *depot, slab_count_t slab_count)
+{
+	block_count_t slab_size;
+	bool resizing = false;
+	physical_block_number_t slab_origin;
+	int result;
+
+	result = UDS_ALLOCATE(slab_count,
+			      struct vdo_slab *,
+			      "slab pointer array",
+			      &depot->new_slabs);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	if (depot->slabs != NULL) {
+		memcpy(depot->new_slabs,
+		       depot->slabs,
+		       depot->slab_count * sizeof(struct vdo_slab *));
+		resizing = true;
+	}
+
+	slab_size = depot->slab_config.slab_blocks;
+	slab_origin = depot->first_block + (depot->slab_count * slab_size);
+
+	for (depot->new_slab_count = depot->slab_count;
+	     depot->new_slab_count < slab_count;
+	     depot->new_slab_count++, slab_origin += slab_size) {
+		struct block_allocator *allocator =
+			&depot->allocators[depot->new_slab_count % depot->zone_count];
+		struct vdo_slab **slab_ptr = &depot->new_slabs[depot->new_slab_count];
+
+		result = make_slab(slab_origin,
+				   allocator,
+				   depot->new_slab_count,
+				   resizing,
+				   slab_ptr);
+		if (result != VDO_SUCCESS)
+			return result;
+	}
+
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_abandon_new_slabs() - Abandon any new slabs in this depot, freeing them as needed.
+ * @depot: The depot.
+ */
+void vdo_abandon_new_slabs(struct slab_depot *depot)
+{
+	slab_count_t i;
+
+	if (depot->new_slabs == NULL)
+		return;
+
+	for (i = depot->slab_count; i < depot->new_slab_count; i++)
+		free_slab(UDS_FORGET(depot->new_slabs[i]));
+	depot->new_slab_count = 0;
+	depot->new_size = 0;
+	UDS_FREE(UDS_FORGET(depot->new_slabs));
+}
+
+/**
+ * get_allocator_thread_id() - Get the ID of the thread on which a given allocator operates.
+ *
+ * Implements vdo_zone_thread_getter.
+ */
+static thread_id_t get_allocator_thread_id(void *context, zone_count_t zone_number)
+{
+	return ((struct slab_depot *) context)->allocators[zone_number].thread_id;
+}
+
+/**
+ * release_recovery_journal_lock() - Request the slab journal to release the recovery journal lock
+ *                                   it may hold on a specified recovery journal block.
+ * @journal: The slab journal.
+ * @recovery_lock: The sequence number of the recovery journal block whose locks should be
+ *                 released.
+ *
+ * Return: true if the journal does hold a lock on the specified block (which it will release).
+ */
+static bool __must_check
+release_recovery_journal_lock(struct slab_journal *journal, sequence_number_t recovery_lock)
+{
+	if (recovery_lock > journal->recovery_lock) {
+		ASSERT_LOG_ONLY((recovery_lock < journal->recovery_lock),
+				"slab journal recovery lock is not older than the recovery journal head");
+		return false;
+	}
+
+	if ((recovery_lock < journal->recovery_lock) ||
+	    vdo_is_read_only(journal->slab->allocator->depot->vdo))
+		return false;
+
+	/* All locks are held by the block which is in progress; write it. */
+	commit_tail(journal);
+	return true;
+}
+
+/*
+ * Request a commit of all dirty tail blocks which are locking the recovery journal block the depot
+ * is seeking to release.
+ *
+ * Implements vdo_zone_action.
+ */
+static void release_tail_block_locks(void *context,
+				     zone_count_t zone_number,
+				     struct vdo_completion *parent)
+{
+	struct slab_journal *journal, *tmp;
+	struct slab_depot *depot = context;
+	struct list_head *list = &depot->allocators[zone_number].dirty_slab_journals;
+
+	list_for_each_entry_safe(journal, tmp, list, dirty_entry) {
+		if (!release_recovery_journal_lock(journal, depot->active_release_request))
+			break;
+	}
+
+	vdo_finish_completion(parent);
+}
+
+/**
+ * prepare_for_tail_block_commit() - Prepare to commit oldest tail blocks.
+ *
+ * Implements vdo_action_preamble.
+ */
+static void prepare_for_tail_block_commit(void *context, struct vdo_completion *parent)
+{
+	struct slab_depot *depot = context;
+
+	depot->active_release_request = depot->new_release_request;
+	vdo_finish_completion(parent);
+}
+
+/**
+ * schedule_tail_block_commit() - Schedule a tail block commit if necessary.
+ *
+ * This method should not be called directly. Rather, call vdo_schedule_default_action() on the
+ * depot's action manager.
+ *
+ * Implements vdo_action_scheduler.
+ */
+static bool schedule_tail_block_commit(void *context)
+{
+	struct slab_depot *depot = context;
+
+	if (depot->new_release_request == depot->active_release_request)
+		return false;
+
+	return vdo_schedule_action(depot->action_manager,
+				   prepare_for_tail_block_commit,
+				   release_tail_block_locks,
+				   NULL,
+				   NULL);
+}
+
 /**
  * initialize_slab_scrubber() - Initialize an allocator's slab scrubber.
  * @allocator: The allocator being initialized
@@ -3954,6 +4145,151 @@ static int __must_check initialize_block_allocator(struct slab_depot *depot, zon
 	return VDO_SUCCESS;
 }
 
+static int allocate_components(struct slab_depot *depot,
+			       struct partition *summary_partition)
+{
+	int result;
+	zone_count_t zone;
+	slab_count_t slab_count;
+	u8 hint;
+	u32 i;
+	const struct thread_config *thread_config = &depot->vdo->thread_config;
+
+	result = vdo_make_action_manager(depot->zone_count,
+					 get_allocator_thread_id,
+					 thread_config->journal_thread,
+					 depot,
+					 schedule_tail_block_commit,
+					 depot->vdo,
+					 &depot->action_manager);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	depot->origin = depot->first_block;
+
+	/* block size must be a multiple of entry size */
+	STATIC_ASSERT((VDO_BLOCK_SIZE % sizeof(struct slab_summary_entry)) == 0);
+
+	depot->summary_origin = summary_partition->offset;
+	depot->hint_shift = vdo_get_slab_summary_hint_shift(depot->slab_size_shift);
+	result = UDS_ALLOCATE(MAXIMUM_VDO_SLAB_SUMMARY_ENTRIES,
+			      struct slab_summary_entry,
+			      __func__,
+			      &depot->summary_entries);
+	if (result != VDO_SUCCESS)
+		return result;
+
+
+	/* Initialize all the entries. */
+	hint = compute_fullness_hint(depot, depot->slab_config.data_blocks);
+	for (i = 0; i < MAXIMUM_VDO_SLAB_SUMMARY_ENTRIES; i++) {
+		/*
+		 * This default tail block offset must be reflected in
+		 * slabJournal.c::read_slab_journal_tail().
+		 */
+		depot->summary_entries[i] = (struct slab_summary_entry) {
+			.tail_block_offset = 0,
+			.fullness_hint = hint,
+			.load_ref_counts = false,
+			.is_dirty = false,
+		};
+	}
+
+	if (result != VDO_SUCCESS)
+		return result;
+
+	slab_count = vdo_compute_slab_count(depot->first_block,
+					    depot->last_block,
+					    depot->slab_size_shift);
+	if (thread_config->physical_zone_count > slab_count)
+		return uds_log_error_strerror(VDO_BAD_CONFIGURATION,
+					      "%u physical zones exceeds slab count %u",
+					      thread_config->physical_zone_count,
+					      slab_count);
+
+	/* Initialize the block allocators. */
+	for (zone = 0; zone < depot->zone_count; zone++) {
+		result = initialize_block_allocator(depot, zone);
+		if (result != VDO_SUCCESS)
+			return result;
+	}
+
+	/* Allocate slabs. */
+	result = allocate_slabs(depot, slab_count);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	/* Use the new slabs. */
+	for (i = depot->slab_count; i < depot->new_slab_count; i++) {
+		struct vdo_slab *slab = depot->new_slabs[i];
+
+		register_slab_with_allocator(slab->allocator, slab);
+		WRITE_ONCE(depot->slab_count, depot->slab_count + 1);
+	}
+
+	depot->slabs = depot->new_slabs;
+	depot->new_slabs = NULL;
+	depot->new_slab_count = 0;
+
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_decode_slab_depot() - Make a slab depot and configure it with the state read from the super
+ *                           block.
+ * @state: The slab depot state from the super block.
+ * @vdo: The VDO which will own the depot.
+ * @summary_partition: The partition which holds the slab summary.
+ * @depot_ptr: A pointer to hold the depot.
+ *
+ * Return: A success or error code.
+ */
+int vdo_decode_slab_depot(struct slab_depot_state_2_0 state,
+			  struct vdo *vdo,
+			  struct partition *summary_partition,
+			  struct slab_depot **depot_ptr)
+{
+	unsigned int slab_size_shift;
+	struct slab_depot *depot;
+	int result;
+
+	/*
+	 * Calculate the bit shift for efficiently mapping block numbers to slabs. Using a shift
+	 * requires that the slab size be a power of two.
+	 */
+	block_count_t slab_size = state.slab_config.slab_blocks;
+
+	if (!is_power_of_2(slab_size))
+		return uds_log_error_strerror(UDS_INVALID_ARGUMENT,
+					      "slab size must be a power of two");
+	slab_size_shift = ilog2(slab_size);
+
+	result = UDS_ALLOCATE_EXTENDED(struct slab_depot,
+				       vdo->thread_config.physical_zone_count,
+				       struct block_allocator,
+				       __func__,
+				       &depot);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	depot->vdo = vdo;
+	depot->old_zone_count = state.zone_count;
+	depot->zone_count = vdo->thread_config.physical_zone_count;
+	depot->slab_config = state.slab_config;
+	depot->first_block = state.first_block;
+	depot->last_block = state.last_block;
+	depot->slab_size_shift = slab_size_shift;
+
+	result = allocate_components(depot, summary_partition);
+	if (result != VDO_SUCCESS) {
+		vdo_free_slab_depot(depot);
+		return result;
+	}
+
+	*depot_ptr = depot;
+	return VDO_SUCCESS;
+}
+
 static void uninitialize_allocator_summary(struct block_allocator *allocator)
 {
 	block_count_t i;
@@ -3969,6 +4305,229 @@ static void uninitialize_allocator_summary(struct block_allocator *allocator)
 	UDS_FREE(UDS_FORGET(allocator->summary_blocks));
 }
 
+/**
+ * vdo_free_slab_depot() - Destroy a slab depot.
+ * @depot: The depot to destroy.
+ */
+void vdo_free_slab_depot(struct slab_depot *depot)
+{
+	zone_count_t zone = 0;
+
+	if (depot == NULL)
+		return;
+
+	vdo_abandon_new_slabs(depot);
+
+	for (zone = 0; zone < depot->zone_count; zone++) {
+		struct block_allocator *allocator = &depot->allocators[zone];
+
+		if (allocator->eraser != NULL)
+			dm_kcopyd_client_destroy(UDS_FORGET(allocator->eraser));
+
+		uninitialize_allocator_summary(allocator);
+		uninitialize_scrubber_vio(&allocator->scrubber);
+		free_vio_pool(UDS_FORGET(allocator->vio_pool));
+		vdo_free_priority_table(UDS_FORGET(allocator->prioritized_slabs));
+	}
+
+	if (depot->slabs != NULL) {
+		slab_count_t i;
+
+		for (i = 0; i < depot->slab_count; i++)
+			free_slab(UDS_FORGET(depot->slabs[i]));
+	}
+
+	UDS_FREE(UDS_FORGET(depot->slabs));
+	UDS_FREE(UDS_FORGET(depot->action_manager));
+	UDS_FREE(UDS_FORGET(depot->summary_entries));
+	UDS_FREE(depot);
+}
+
+/**
+ * vdo_record_slab_depot() - Record the state of a slab depot for encoding into the super block.
+ * @depot: The depot to encode.
+ *
+ * Return: The depot state.
+ */
+struct slab_depot_state_2_0 vdo_record_slab_depot(const struct slab_depot *depot)
+{
+	/*
+	 * If this depot is currently using 0 zones, it must have been synchronously loaded by a
+	 * tool and is now being saved. We did not load and combine the slab summary, so we still
+	 * need to do that next time we load with the old zone count rather than 0.
+	 */
+	struct slab_depot_state_2_0 state;
+	zone_count_t zones_to_record = depot->zone_count;
+
+	if (depot->zone_count == 0)
+		zones_to_record = depot->old_zone_count;
+
+	state = (struct slab_depot_state_2_0) {
+		.slab_config = depot->slab_config,
+		.first_block = depot->first_block,
+		.last_block = depot->last_block,
+		.zone_count = zones_to_record,
+	};
+
+	return state;
+}
+
+/**
+ * vdo_allocate_reference_counters() - Allocate the reference counters for all slabs in the depot.
+ *
+ * Context: This method may be called only before entering normal operation from the load thread.
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+int vdo_allocate_reference_counters(struct slab_depot *depot)
+{
+	struct slab_iterator iterator =
+		get_depot_slab_iterator(depot, depot->slab_count - 1, 0, 1);
+
+	while (iterator.next != NULL) {
+		int result = allocate_slab_counters(next_slab(&iterator));
+
+		if (result != VDO_SUCCESS)
+			return result;
+	}
+
+	return VDO_SUCCESS;
+}
+
+/**
+ * get_slab_number() - Get the number of the slab that contains a specified block.
+ * @depot: The slab depot.
+ * @pbn: The physical block number.
+ * @slab_number_ptr: A pointer to hold the slab number.
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+static int __must_check get_slab_number(const struct slab_depot *depot,
+					physical_block_number_t pbn,
+					slab_count_t *slab_number_ptr)
+{
+	slab_count_t slab_number;
+
+	if (pbn < depot->first_block)
+		return VDO_OUT_OF_RANGE;
+
+	slab_number = (pbn - depot->first_block) >> depot->slab_size_shift;
+	if (slab_number >= depot->slab_count)
+		return VDO_OUT_OF_RANGE;
+
+	*slab_number_ptr = slab_number;
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_get_slab() - Get the slab object for the slab that contains a specified block.
+ * @depot: The slab depot.
+ * @pbn: The physical block number.
+ *
+ * Will put the VDO in read-only mode if the PBN is not a valid data block nor the zero block.
+ *
+ * Return: The slab containing the block, or NULL if the block number is the zero block or
+ * otherwise out of range.
+ */
+struct vdo_slab *vdo_get_slab(const struct slab_depot *depot, physical_block_number_t pbn)
+{
+	slab_count_t slab_number;
+	int result;
+
+	if (pbn == VDO_ZERO_BLOCK)
+		return NULL;
+
+	result = get_slab_number(depot, pbn, &slab_number);
+	if (result != VDO_SUCCESS) {
+		vdo_enter_read_only_mode(depot->vdo, result);
+		return NULL;
+	}
+
+	return depot->slabs[slab_number];
+}
+
+/**
+ * vdo_get_increment_limit() - Determine how many new references a block can acquire.
+ * @depot: The slab depot.
+ * @pbn: The physical block number that is being queried.
+ *
+ * Context: This method must be called from the physical zone thread of the PBN.
+ *
+ * Return: The number of available references.
+ */
+u8 vdo_get_increment_limit(struct slab_depot *depot, physical_block_number_t pbn)
+{
+	struct vdo_slab *slab = vdo_get_slab(depot, pbn);
+	vdo_refcount_t *counter_ptr = NULL;
+	int result;
+
+	if ((slab == NULL) || (slab->status != VDO_SLAB_REBUILT))
+		return 0;
+
+	result = get_reference_counter(slab, pbn, &counter_ptr);
+	if (result != VDO_SUCCESS)
+		return 0;
+
+	if (*counter_ptr == PROVISIONAL_REFERENCE_COUNT)
+		return (MAXIMUM_REFERENCE_COUNT - 1);
+
+	return (MAXIMUM_REFERENCE_COUNT - *counter_ptr);
+}
+
+/**
+ * vdo_is_physical_data_block() - Determine whether the given PBN refers to a data block.
+ * @depot: The depot.
+ * @pbn: The physical block number to ask about.
+ *
+ * Return: True if the PBN corresponds to a data block.
+ */
+bool vdo_is_physical_data_block(const struct slab_depot *depot, physical_block_number_t pbn)
+{
+	slab_count_t slab_number;
+	slab_block_number sbn;
+
+	return ((pbn == VDO_ZERO_BLOCK) ||
+		((get_slab_number(depot, pbn, &slab_number) == VDO_SUCCESS) &&
+		 (slab_block_number_from_pbn(depot->slabs[slab_number], pbn, &sbn) ==
+		  VDO_SUCCESS)));
+}
+
+/**
+ * vdo_get_slab_depot_allocated_blocks() - Get the total number of data blocks allocated across all
+ * the slabs in the depot.
+ * @depot: The slab depot.
+ *
+ * This is the total number of blocks with a non-zero reference count.
+ *
+ * Context: This may be called from any thread.
+ *
+ * Return: The total number of blocks with a non-zero reference count.
+ */
+block_count_t vdo_get_slab_depot_allocated_blocks(const struct slab_depot *depot)
+{
+	block_count_t total = 0;
+	zone_count_t zone;
+
+	for (zone = 0; zone < depot->zone_count; zone++)
+		/* The allocators are responsible for thread safety. */
+		total += READ_ONCE(depot->allocators[zone].allocated_blocks);
+	return total;
+}
+
+/**
+ * vdo_get_slab_depot_data_blocks() - Get the total number of data blocks in all the slabs in the
+ *                                    depot.
+ * @depot: The slab depot.
+ *
+ * Context: This may be called from any thread.
+ *
+ * Return: The total number of data blocks in all slabs.
+ */
+block_count_t vdo_get_slab_depot_data_blocks(const struct slab_depot *depot)
+{
+	return (READ_ONCE(depot->slab_count) * depot->slab_config.data_blocks);
+}
+
 /**
  * finish_combining_zones() - Clean up after saving out the combined slab summary.
  * @completion: The vio which was used to write the summary data.
@@ -4100,6 +4659,193 @@ static void load_slab_summary(void *context, struct vdo_completion *parent)
 			    REQ_OP_READ);
 }
 
+/* Implements vdo_zone_action. */
+static void load_allocator(void *context, zone_count_t zone_number, struct vdo_completion *parent)
+{
+	struct slab_depot *depot = context;
+
+	vdo_start_loading(&depot->allocators[zone_number].state,
+			  vdo_get_current_manager_operation(depot->action_manager),
+			  parent,
+			  initiate_load);
+}
+
+/**
+ * vdo_load_slab_depot() - Asynchronously load any slab depot state that isn't included in the
+ *                         super_block component.
+ * @depot: The depot to load.
+ * @operation: The type of load to perform.
+ * @parent: The completion to notify when the load is complete.
+ * @context: Additional context for the load operation; may be NULL.
+ *
+ * This method may be called only before entering normal operation from the load thread.
+ */
+void vdo_load_slab_depot(struct slab_depot *depot,
+			 const struct admin_state_code *operation,
+			 struct vdo_completion *parent,
+			 void *context)
+{
+	if (vdo_assert_load_operation(operation, parent))
+		vdo_schedule_operation_with_context(depot->action_manager,
+						    operation,
+						    load_slab_summary,
+						    load_allocator,
+						    NULL,
+						    context,
+						    parent);
+}
+
+/* Implements vdo_zone_action. */
+static void prepare_to_allocate(void *context,
+				zone_count_t zone_number,
+				struct vdo_completion *parent)
+{
+	struct slab_depot *depot = context;
+	struct block_allocator *allocator = &depot->allocators[zone_number];
+	int result;
+
+	result = vdo_prepare_slabs_for_allocation(allocator);
+	if (result != VDO_SUCCESS) {
+		vdo_fail_completion(parent, result);
+		return;
+	}
+
+	scrub_slabs(allocator, parent);
+}
+
+/**
+ * vdo_prepare_slab_depot_to_allocate() - Prepare the slab depot to come online and start
+ *                                        allocating blocks.
+ * @depot: The depot to prepare.
+ * @load_type: The load type.
+ * @parent: The completion to notify when the operation is complete.
+ *
+ * This method may be called only before entering normal operation from the load thread. It must be
+ * called before allocation may proceed.
+ */
+void vdo_prepare_slab_depot_to_allocate(struct slab_depot *depot,
+					enum slab_depot_load_type load_type,
+					struct vdo_completion *parent)
+{
+	depot->load_type = load_type;
+	atomic_set(&depot->zones_to_scrub, depot->zone_count);
+	vdo_schedule_action(depot->action_manager, NULL, prepare_to_allocate, NULL, parent);
+}
+
+/**
+ * vdo_update_slab_depot_size() - Update the slab depot to reflect its new size in memory.
+ * @depot: The depot to update.
+ *
+ * This size is saved to disk as part of the super block.
+ */
+void vdo_update_slab_depot_size(struct slab_depot *depot)
+{
+	depot->last_block = depot->new_last_block;
+}
+
+/**
+ * vdo_prepare_to_grow_slab_depot() - Allocate new memory needed for a resize of a slab depot to
+ *                                    the given size.
+ * @depot: The depot to prepare to resize.
+ * @partition: The new depot partition
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+int vdo_prepare_to_grow_slab_depot(struct slab_depot *depot, const struct partition *partition)
+{
+	struct slab_depot_state_2_0 new_state;
+	int result;
+	slab_count_t new_slab_count;
+
+	if ((partition->count >> depot->slab_size_shift) <= depot->slab_count)
+		return VDO_INCREMENT_TOO_SMALL;
+
+	/* Generate the depot configuration for the new block count. */
+	ASSERT_LOG_ONLY(depot->first_block == partition->offset,
+			"New slab depot partition doesn't change origin");
+	result = vdo_configure_slab_depot(partition,
+					  depot->slab_config,
+					  depot->zone_count,
+					  &new_state);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	new_slab_count = vdo_compute_slab_count(depot->first_block,
+						new_state.last_block,
+						depot->slab_size_shift);
+	if (new_slab_count <= depot->slab_count)
+		return uds_log_error_strerror(VDO_INCREMENT_TOO_SMALL, "Depot can only grow");
+	if (new_slab_count == depot->new_slab_count)
+		/* Check it out, we've already got all the new slabs allocated! */
+		return VDO_SUCCESS;
+
+	vdo_abandon_new_slabs(depot);
+	result = allocate_slabs(depot, new_slab_count);
+	if (result != VDO_SUCCESS) {
+		vdo_abandon_new_slabs(depot);
+		return result;
+	}
+
+	depot->new_size = partition->count;
+	depot->old_last_block = depot->last_block;
+	depot->new_last_block = new_state.last_block;
+
+	return VDO_SUCCESS;
+}
+
+/**
+ * finish_registration() - Finish registering new slabs now that all of the allocators have
+ *                         received their new slabs.
+ *
+ * Implements vdo_action_conclusion.
+ */
+static int finish_registration(void *context)
+{
+	struct slab_depot *depot = context;
+
+	WRITE_ONCE(depot->slab_count, depot->new_slab_count);
+	UDS_FREE(depot->slabs);
+	depot->slabs = depot->new_slabs;
+	depot->new_slabs = NULL;
+	depot->new_slab_count = 0;
+	return VDO_SUCCESS;
+}
+
+/* Implements vdo_zone_action. */
+static void register_new_slabs(void *context,
+			       zone_count_t zone_number,
+			       struct vdo_completion *parent)
+{
+	struct slab_depot *depot = context;
+	struct block_allocator *allocator = &depot->allocators[zone_number];
+	slab_count_t i;
+
+	for (i = depot->slab_count; i < depot->new_slab_count; i++) {
+		struct vdo_slab *slab = depot->new_slabs[i];
+
+		if (slab->allocator == allocator)
+			register_slab_with_allocator(allocator, slab);
+	}
+
+	vdo_finish_completion(parent);
+}
+
+/**
+ * vdo_use_new_slabs() - Use the new slabs allocated for resize.
+ * @depot: The depot.
+ * @parent: The object to notify when complete.
+ */
+void vdo_use_new_slabs(struct slab_depot *depot, struct vdo_completion *parent)
+{
+	ASSERT_LOG_ONLY(depot->new_slabs != NULL, "Must have new slabs to use");
+	vdo_schedule_operation(depot->action_manager,
+			       VDO_ADMIN_STATE_SUSPENDED_OPERATION,
+			       NULL,
+			       register_new_slabs,
+			       finish_registration,
+			       parent);
+}
+
 /**
  * stop_scrubbing() - Tell the scrubber to stop scrubbing after it finishes the slab it is
  *                    currently working on.
@@ -4169,6 +4915,43 @@ static void initiate_drain(struct admin_state *state)
 	do_drain_step(&allocator->completion);
 }
 
+/*
+ * Drain all allocator I/O. Depending upon the type of drain, some or all dirty metadata may be
+ * written to disk. The type of drain will be determined from the state of the allocator's depot.
+ *
+ * Implements vdo_zone_action.
+ */
+static void drain_allocator(void *context, zone_count_t zone_number, struct vdo_completion *parent)
+{
+	struct slab_depot *depot = context;
+
+	vdo_start_draining(&depot->allocators[zone_number].state,
+			   vdo_get_current_manager_operation(depot->action_manager),
+			   parent,
+			   initiate_drain);
+}
+
+/**
+ * vdo_drain_slab_depot() - Drain all slab depot I/O.
+ * @depot: The depot to drain.
+ * @operation: The drain operation (flush, rebuild, suspend, or save).
+ * @parent: The completion to finish when the drain is complete.
+ *
+ * If saving, or flushing, all dirty depot metadata will be written out. If saving or suspending,
+ * the depot will be left in a suspended state.
+ */
+void vdo_drain_slab_depot(struct slab_depot *depot,
+			  const struct admin_state_code *operation,
+			  struct vdo_completion *parent)
+{
+	vdo_schedule_operation(depot->action_manager,
+			       operation,
+			       NULL,
+			       drain_allocator,
+			       NULL,
+			       parent);
+}
+
 /**
  * resume_scrubbing() - Tell the scrubber to resume scrubbing if it has been stopped.
  * @allocator: The allocator being resumed.
@@ -4246,3 +5029,185 @@ static void resume_allocator(void *context,
 			   parent,
 			   initiate_resume);
 }
+
+/**
+ * vdo_resume_slab_depot() - Resume a suspended slab depot.
+ * @depot: The depot to resume.
+ * @parent: The completion to finish when the depot has resumed.
+ */
+void vdo_resume_slab_depot(struct slab_depot *depot, struct vdo_completion *parent)
+{
+	if (vdo_is_read_only(depot->vdo)) {
+		vdo_continue_completion(parent, VDO_READ_ONLY);
+		return;
+	}
+
+	vdo_schedule_operation(depot->action_manager,
+			       VDO_ADMIN_STATE_RESUMING,
+			       NULL,
+			       resume_allocator,
+			       NULL,
+			       parent);
+}
+
+/**
+ * vdo_commit_oldest_slab_journal_tail_blocks() - Commit all dirty tail blocks which are locking a
+ *                                                given recovery journal block.
+ * @depot: The depot.
+ * @recovery_block_number: The sequence number of the recovery journal block whose locks should be
+ *                         released.
+ *
+ * Context: This method must be called from the journal zone thread.
+ */
+void vdo_commit_oldest_slab_journal_tail_blocks(struct slab_depot *depot,
+						sequence_number_t recovery_block_number)
+{
+	if (depot == NULL)
+		return;
+
+	depot->new_release_request = recovery_block_number;
+	vdo_schedule_default_action(depot->action_manager);
+}
+
+/* Implements vdo_zone_action. */
+static void scrub_all_unrecovered_slabs(void *context,
+					zone_count_t zone_number,
+					struct vdo_completion *parent)
+{
+	struct slab_depot *depot = context;
+
+	scrub_slabs(&depot->allocators[zone_number], NULL);
+	vdo_launch_completion(parent);
+}
+
+/**
+ * vdo_scrub_all_unrecovered_slabs() - Scrub all unrecovered slabs.
+ * @depot: The depot to scrub.
+ * @parent: The object to notify when scrubbing has been launched for all zones.
+ */
+void vdo_scrub_all_unrecovered_slabs(struct slab_depot *depot, struct vdo_completion *parent)
+{
+	vdo_schedule_action(depot->action_manager,
+			    NULL,
+			    scrub_all_unrecovered_slabs,
+			    NULL,
+			    parent);
+}
+
+/**
+ * get_block_allocator_statistics() - Get the total of the statistics from all the block allocators
+ *                                    in the depot.
+ * @depot: The slab depot.
+ *
+ * Return: The statistics from all block allocators in the depot.
+ */
+static struct block_allocator_statistics __must_check
+get_block_allocator_statistics(const struct slab_depot *depot)
+{
+	struct block_allocator_statistics totals;
+	zone_count_t zone;
+
+	memset(&totals, 0, sizeof(totals));
+
+	for (zone = 0; zone < depot->zone_count; zone++) {
+		const struct block_allocator *allocator = &depot->allocators[zone];
+		const struct block_allocator_statistics *stats = &allocator->statistics;
+
+		totals.slab_count += allocator->slab_count;
+		totals.slabs_opened += READ_ONCE(stats->slabs_opened);
+		totals.slabs_reopened += READ_ONCE(stats->slabs_reopened);
+	}
+
+	return totals;
+}
+
+/**
+ * get_ref_counts_statistics() - Get the cumulative ref_counts statistics for the depot.
+ * @depot: The slab depot.
+ *
+ * Return: The cumulative statistics for all ref_counts in the depot.
+ */
+static struct ref_counts_statistics __must_check
+get_ref_counts_statistics(const struct slab_depot *depot)
+{
+	struct ref_counts_statistics totals;
+	zone_count_t zone;
+
+	memset(&totals, 0, sizeof(totals));
+
+	for (zone = 0; zone < depot->zone_count; zone++) {
+		totals.blocks_written +=
+			READ_ONCE(depot->allocators[zone].ref_counts_statistics.blocks_written);
+	}
+
+	return totals;
+}
+
+/**
+ * get_depot_slab_journal_statistics() - Get the aggregated slab journal statistics for the depot.
+ * @depot: The slab depot.
+ *
+ * Return: The aggregated statistics for all slab journals in the depot.
+ */
+static struct slab_journal_statistics __must_check
+get_slab_journal_statistics(const struct slab_depot *depot)
+{
+	struct slab_journal_statistics totals;
+	zone_count_t zone;
+
+	memset(&totals, 0, sizeof(totals));
+
+	for (zone = 0; zone < depot->zone_count; zone++) {
+		const struct slab_journal_statistics *stats =
+			&depot->allocators[zone].slab_journal_statistics;
+
+		totals.disk_full_count += READ_ONCE(stats->disk_full_count);
+		totals.flush_count += READ_ONCE(stats->flush_count);
+		totals.blocked_count += READ_ONCE(stats->blocked_count);
+		totals.blocks_written += READ_ONCE(stats->blocks_written);
+		totals.tail_busy_count += READ_ONCE(stats->tail_busy_count);
+	}
+
+	return totals;
+}
+
+/**
+ * vdo_get_slab_depot_statistics() - Get all the vdo_statistics fields that are properties of the
+ *                                   slab depot.
+ * @depot: The slab depot.
+ * @stats: The vdo statistics structure to partially fill.
+ */
+void vdo_get_slab_depot_statistics(const struct slab_depot *depot, struct vdo_statistics *stats)
+{
+	slab_count_t slab_count = READ_ONCE(depot->slab_count);
+	slab_count_t unrecovered = 0;
+	zone_count_t zone;
+
+	for (zone = 0; zone < depot->zone_count; zone++) {
+		/* The allocators are responsible for thread safety. */
+		unrecovered += READ_ONCE(depot->allocators[zone].scrubber.slab_count);
+	}
+
+	stats->recovery_percentage = (slab_count - unrecovered) * 100 / slab_count;
+	stats->allocator = get_block_allocator_statistics(depot);
+	stats->ref_counts = get_ref_counts_statistics(depot);
+	stats->slab_journal = get_slab_journal_statistics(depot);
+	stats->slab_summary = (struct slab_summary_statistics) {
+		.blocks_written = atomic64_read(&depot->summary_statistics.blocks_written),
+	};
+}
+
+/**
+ * vdo_dump_slab_depot() - Dump the slab depot, in a thread-unsafe fashion.
+ * @depot: The slab depot.
+ */
+void vdo_dump_slab_depot(const struct slab_depot *depot)
+{
+	uds_log_info("vdo slab depot");
+	uds_log_info("  zone_count=%u old_zone_count=%u slabCount=%u active_release_request=%llu new_release_request=%llu",
+		     (unsigned int) depot->zone_count,
+		     (unsigned int) depot->old_zone_count,
+		     READ_ONCE(depot->slab_count),
+		     (unsigned long long) depot->active_release_request,
+		     (unsigned long long) depot->new_release_request);
+}
diff --git a/drivers/md/dm-vdo/slab-depot.h b/drivers/md/dm-vdo/slab-depot.h
index 6ec4be7b5822..44655d697fa0 100644
--- a/drivers/md/dm-vdo/slab-depot.h
+++ b/drivers/md/dm-vdo/slab-depot.h
@@ -435,6 +435,66 @@ struct block_allocator {
 	struct slab_summary_block *summary_blocks;
 };
 
+enum slab_depot_load_type {
+	VDO_SLAB_DEPOT_NORMAL_LOAD,
+	VDO_SLAB_DEPOT_RECOVERY_LOAD,
+	VDO_SLAB_DEPOT_REBUILD_LOAD
+};
+
+struct slab_depot {
+	zone_count_t zone_count;
+	zone_count_t old_zone_count;
+	struct vdo *vdo;
+	struct slab_config slab_config;
+	struct action_manager *action_manager;
+
+	physical_block_number_t first_block;
+	physical_block_number_t last_block;
+	physical_block_number_t origin;
+
+	/* slab_size == (1 << slab_size_shift) */
+	unsigned int slab_size_shift;
+
+	/* Determines how slabs should be queued during load */
+	enum slab_depot_load_type load_type;
+
+	/* The state for notifying slab journals to release recovery journal */
+	sequence_number_t active_release_request;
+	sequence_number_t new_release_request;
+
+	/* State variables for scrubbing complete handling */
+	atomic_t zones_to_scrub;
+
+	/* Array of pointers to individually allocated slabs */
+	struct vdo_slab **slabs;
+	/* The number of slabs currently allocated and stored in 'slabs' */
+	slab_count_t slab_count;
+
+	/* Array of pointers to a larger set of slabs (used during resize) */
+	struct vdo_slab **new_slabs;
+	/* The number of slabs currently allocated and stored in 'new_slabs' */
+	slab_count_t new_slab_count;
+	/* The size that 'new_slabs' was allocated for */
+	block_count_t new_size;
+
+	/* The last block before resize, for rollback */
+	physical_block_number_t old_last_block;
+	/* The last block after resize, for resize */
+	physical_block_number_t new_last_block;
+
+	/* The statistics for the slab summary */
+	struct atomic_slab_summary_statistics summary_statistics;
+	/* The start of the slab summary partition */
+	physical_block_number_t summary_origin;
+	/* The number of bits to shift to get a 7-bit fullness hint */
+	unsigned int hint_shift;
+	/* The slab summary entries for all of the zones the partition can hold */
+	struct slab_summary_entry *summary_entries;
+
+	/* The block allocators for this depot */
+	struct block_allocator allocators[];
+};
+
 struct reference_updater;
 
 bool __must_check
@@ -445,6 +505,11 @@ vdo_attempt_replay_into_slab(struct vdo_slab *slab,
 			     struct journal_point *recovery_point,
 			     struct vdo_completion *parent);
 
+int __must_check
+vdo_adjust_reference_count_for_rebuild(struct slab_depot *depot,
+				       physical_block_number_t pbn,
+				       enum journal_operation operation);
+
 static inline struct block_allocator *vdo_as_block_allocator(struct vdo_completion *completion)
 {
 	vdo_assert_completion_type(completion, VDO_BLOCK_ALLOCATOR_COMPLETION);
@@ -470,4 +535,60 @@ void vdo_notify_slab_journals_are_recovered(struct vdo_completion *completion);
 
 void vdo_dump_block_allocator(const struct block_allocator *allocator);
 
+int __must_check vdo_decode_slab_depot(struct slab_depot_state_2_0 state,
+				       struct vdo *vdo,
+				       struct partition *summary_partition,
+				       struct slab_depot **depot_ptr);
+
+void vdo_free_slab_depot(struct slab_depot *depot);
+
+struct slab_depot_state_2_0 __must_check vdo_record_slab_depot(const struct slab_depot *depot);
+
+int __must_check vdo_allocate_reference_counters(struct slab_depot *depot);
+
+struct vdo_slab * __must_check
+vdo_get_slab(const struct slab_depot *depot, physical_block_number_t pbn);
+
+u8 __must_check vdo_get_increment_limit(struct slab_depot *depot, physical_block_number_t pbn);
+
+bool __must_check
+vdo_is_physical_data_block(const struct slab_depot *depot, physical_block_number_t pbn);
+
+block_count_t __must_check vdo_get_slab_depot_allocated_blocks(const struct slab_depot *depot);
+
+block_count_t __must_check vdo_get_slab_depot_data_blocks(const struct slab_depot *depot);
+
+void vdo_get_slab_depot_statistics(const struct slab_depot *depot, struct vdo_statistics *stats);
+
+void vdo_load_slab_depot(struct slab_depot *depot,
+			 const struct admin_state_code *operation,
+			 struct vdo_completion *parent,
+			 void *context);
+
+void vdo_prepare_slab_depot_to_allocate(struct slab_depot *depot,
+					enum slab_depot_load_type load_type,
+					struct vdo_completion *parent);
+
+void vdo_update_slab_depot_size(struct slab_depot *depot);
+
+int __must_check
+vdo_prepare_to_grow_slab_depot(struct slab_depot *depot, const struct partition *partition);
+
+void vdo_use_new_slabs(struct slab_depot *depot, struct vdo_completion *parent);
+
+void vdo_abandon_new_slabs(struct slab_depot *depot);
+
+void vdo_drain_slab_depot(struct slab_depot *depot,
+			  const struct admin_state_code *operation,
+			  struct vdo_completion *parent);
+
+void vdo_resume_slab_depot(struct slab_depot *depot, struct vdo_completion *parent);
+
+void vdo_commit_oldest_slab_journal_tail_blocks(struct slab_depot *depot,
+						sequence_number_t recovery_block_number);
+
+void vdo_scrub_all_unrecovered_slabs(struct slab_depot *depot, struct vdo_completion *parent);
+
+void vdo_dump_slab_depot(const struct slab_depot *depot);
+
 #endif /* VDO_SLAB_DEPOT_H */
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

