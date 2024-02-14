Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EBC10A2E
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 04:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707886639; cv=none; b=I3i+Vn7nwqJ0Z8Qk0XnVOMo9kDYYdLAIXWd56NbT4Kj0PHUWJ0qlE0jBidGAQwz9wHn0F2XX0eswl2/WgP80+Cu6hdGpy33aZ19okgARiQrFR7IMAaIwdfOalw6o8uUF9CJKBoZH9IDg1vQvfnkFLK0HMcD6igQ1nzPMIEZxHQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707886639; c=relaxed/simple;
	bh=Zv+eBwx+IfOkK/vAALkJ8jzimlIQYJDLcRHjrPg6Rjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XIknBj5Px0XXUESY/691P1YgwDDXvsi1Kp6AbB+M7iqHCjLSRQtN0d6rn+5ZSbt11H7IaQQZ44O2dKvETrShE0VPbCQH8WQVYQy6A6xQz/qhx7tiTF2ic/KFys84id910dOsWthU0w5Vm1joHatNt/0zFg2gIdHAmcQFOjQfX5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YWpuOBAW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YWpuOBAW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707886636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zGpbNa/QIXaLYS2S3g4zyp7vlaqLOqUwYpfJNDz3Vao=;
	b=YWpuOBAWk0vocNpEPHwlbC5R4GN1aBzX65+bIq4r2vXa7mzdxLLpEcCEXCnEAK+U9nCfJI
	usvokRhm2Q4sd+XCXazdb7NUytHf/GswikS/QowUYpPD1M/lgu+J0C2a4NnLYyYRgPMuxh
	IHs3VrjY+Hd7VzRdEbqRdCVvBZ+wmd0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-I8qEdA9rMBeWrStAty6guw-1; Tue, 13 Feb 2024 23:57:12 -0500
X-MC-Unique: I8qEdA9rMBeWrStAty6guw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 603CE101FA2D;
	Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 544A4C03487;
	Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 51418576BE; Tue, 13 Feb 2024 23:57:12 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/5] dm vdo: cleanup style for comments in structs
Date: Tue, 13 Feb 2024 23:57:10 -0500
Message-ID: <c3ae6a01a2d099867920009bb15d7d3aa98411f0.1707886374.git.msakai@redhat.com>
In-Reply-To: <cover.1707886374.git.msakai@redhat.com>
References: <cover.1707886374.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Use /* ... */ rather than /** ... */ if for no other reason than
syntax highlighting is improved (at least for me, in emacs: comments
are now red, code is yellow. Previously comments were also yellow).

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.h        |  12 +-
 drivers/md/dm-vdo/constants.h        |  38 +++---
 drivers/md/dm-vdo/encodings.h        |   8 +-
 drivers/md/dm-vdo/flush.c            |  28 ++--
 drivers/md/dm-vdo/recovery-journal.h |  22 +--
 drivers/md/dm-vdo/statistics.h       | 194 +++++++++++++--------------
 drivers/md/dm-vdo/vdo.h              |   8 +-
 drivers/md/dm-vdo/vio.c              |  16 +--
 8 files changed, 163 insertions(+), 163 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.h b/drivers/md/dm-vdo/block-map.h
index b662c318c2ea..39a13039e4a3 100644
--- a/drivers/md/dm-vdo/block-map.h
+++ b/drivers/md/dm-vdo/block-map.h
@@ -216,17 +216,17 @@ enum block_map_page_type {
 typedef struct list_head dirty_era_t[2];
 
 struct dirty_lists {
-	/** The number of periods after which an element will be expired */
+	/* The number of periods after which an element will be expired */
 	block_count_t maximum_age;
-	/** The oldest period which has unexpired elements */
+	/* The oldest period which has unexpired elements */
 	sequence_number_t oldest_period;
-	/** One more than the current period */
+	/* One more than the current period */
 	sequence_number_t next_period;
-	/** The offset in the array of lists of the oldest period */
+	/* The offset in the array of lists of the oldest period */
 	block_count_t offset;
-	/** Expired pages */
+	/* Expired pages */
 	dirty_era_t expired;
-	/** The lists of dirty pages */
+	/* The lists of dirty pages */
 	dirty_era_t eras[];
 };
 
diff --git a/drivers/md/dm-vdo/constants.h b/drivers/md/dm-vdo/constants.h
index 24237bc29f87..a8c4d6e24b38 100644
--- a/drivers/md/dm-vdo/constants.h
+++ b/drivers/md/dm-vdo/constants.h
@@ -17,10 +17,10 @@ enum {
 	 */
 	VDO_BIO_ROTATION_INTERVAL_LIMIT = 1024,
 
-	/** The number of entries on a block map page */
+	/* The number of entries on a block map page */
 	VDO_BLOCK_MAP_ENTRIES_PER_PAGE = 812,
 
-	/** The origin of the flat portion of the block map */
+	/* The origin of the flat portion of the block map */
 	VDO_BLOCK_MAP_FLAT_PAGE_ORIGIN = 1,
 
 	/*
@@ -29,22 +29,22 @@ enum {
 	 */
 	VDO_BLOCK_MAP_TREE_HEIGHT = 5,
 
-	/** The default number of bio submission queues. */
+	/* The default number of bio submission queues. */
 	DEFAULT_VDO_BIO_SUBMIT_QUEUE_COUNT = 4,
 
-	/** The number of contiguous PBNs to be submitted to a single bio queue. */
+	/* The number of contiguous PBNs to be submitted to a single bio queue. */
 	DEFAULT_VDO_BIO_SUBMIT_QUEUE_ROTATE_INTERVAL = 64,
 
-	/** The number of trees in the arboreal block map */
+	/* The number of trees in the arboreal block map */
 	DEFAULT_VDO_BLOCK_MAP_TREE_ROOT_COUNT = 60,
 
-	/** The default size of the recovery journal, in blocks */
+	/* The default size of the recovery journal, in blocks */
 	DEFAULT_VDO_RECOVERY_JOURNAL_SIZE = 32 * 1024,
 
-	/** The default size of each slab journal, in blocks */
+	/* The default size of each slab journal, in blocks */
 	DEFAULT_VDO_SLAB_JOURNAL_SIZE = 224,
 
-	/** Unit test minimum */
+	/* Unit test minimum */
 	MINIMUM_VDO_SLAB_JOURNAL_BLOCKS = 2,
 
 	/*
@@ -54,16 +54,16 @@ enum {
 	 */
 	VDO_LOCK_MAP_CAPACITY = 10000,
 
-	/** The maximum number of logical zones */
+	/* The maximum number of logical zones */
 	MAX_VDO_LOGICAL_ZONES = 60,
 
-	/** The maximum number of physical zones */
+	/* The maximum number of physical zones */
 	MAX_VDO_PHYSICAL_ZONES = 16,
 
-	/** The base-2 logarithm of the maximum blocks in one slab */
+	/* The base-2 logarithm of the maximum blocks in one slab */
 	MAX_VDO_SLAB_BITS = 23,
 
-	/** The maximum number of slabs the slab depot supports */
+	/* The maximum number of slabs the slab depot supports */
 	MAX_VDO_SLABS = 8192,
 
 	/*
@@ -71,25 +71,25 @@ enum {
 	 */
 	MAXIMUM_SIMULTANEOUS_VDO_BLOCK_MAP_RESTORATION_READS = 1024,
 
-	/** The maximum number of entries in the slab summary */
+	/* The maximum number of entries in the slab summary */
 	MAXIMUM_VDO_SLAB_SUMMARY_ENTRIES = MAX_VDO_SLABS * MAX_VDO_PHYSICAL_ZONES,
 
-	/** The maximum number of total threads in a VDO thread configuration. */
+	/* The maximum number of total threads in a VDO thread configuration. */
 	MAXIMUM_VDO_THREADS = 100,
 
-	/** The maximum number of VIOs in the system at once */
+	/* The maximum number of VIOs in the system at once */
 	MAXIMUM_VDO_USER_VIOS = 2048,
 
-	/** The only physical block size supported by VDO */
+	/* The only physical block size supported by VDO */
 	VDO_BLOCK_SIZE = 4096,
 
-	/** The number of sectors per block */
+	/* The number of sectors per block */
 	VDO_SECTORS_PER_BLOCK = (VDO_BLOCK_SIZE >> SECTOR_SHIFT),
 
-	/** The size of a sector that will not be torn */
+	/* The size of a sector that will not be torn */
 	VDO_SECTOR_SIZE = 512,
 
-	/** The physical block number reserved for storing the zero block */
+	/* The physical block number reserved for storing the zero block */
 	VDO_ZERO_BLOCK = 0,
 };
 
diff --git a/drivers/md/dm-vdo/encodings.h b/drivers/md/dm-vdo/encodings.h
index 260822a3958a..ba3db9867f4a 100644
--- a/drivers/md/dm-vdo/encodings.h
+++ b/drivers/md/dm-vdo/encodings.h
@@ -155,7 +155,7 @@ struct block_map_page_header {
 	__le64 nonce;
 	__le64 pbn;
 
-	/** May be non-zero on disk */
+	/* May be non-zero on disk */
 	u8 unused_long_word[8];
 
 	/* Whether this page has been written twice to disk */
@@ -197,11 +197,11 @@ extern const struct header VDO_BLOCK_MAP_HEADER_2_0;
 
 /* The state of the recovery journal as encoded in the VDO super block. */
 struct recovery_journal_state_7_0 {
-	/** Sequence number to start the journal */
+	/* Sequence number to start the journal */
 	sequence_number_t journal_start;
-	/** Number of logical blocks used by VDO */
+	/* Number of logical blocks used by VDO */
 	block_count_t logical_blocks_used;
-	/** Number of block map pages allocated */
+	/* Number of block map pages allocated */
 	block_count_t block_map_data_blocks;
 } __packed;
 
diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index a6eeb425d721..330b18715027 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -22,33 +22,33 @@
 
 struct flusher {
 	struct vdo_completion completion;
-	/** The vdo to which this flusher belongs */
+	/* The vdo to which this flusher belongs */
 	struct vdo *vdo;
-	/** The administrative state of the flusher */
+	/* The administrative state of the flusher */
 	struct admin_state state;
-	/** The current flush generation of the vdo */
+	/* The current flush generation of the vdo */
 	sequence_number_t flush_generation;
-	/** The first unacknowledged flush generation */
+	/* The first unacknowledged flush generation */
 	sequence_number_t first_unacknowledged_generation;
-	/** The queue of flush requests waiting to notify other threads */
+	/* The queue of flush requests waiting to notify other threads */
 	struct vdo_wait_queue notifiers;
-	/** The queue of flush requests waiting for VIOs to complete */
+	/* The queue of flush requests waiting for VIOs to complete */
 	struct vdo_wait_queue pending_flushes;
-	/** The flush generation for which notifications are being sent */
+	/* The flush generation for which notifications are being sent */
 	sequence_number_t notify_generation;
-	/** The logical zone to notify next */
+	/* The logical zone to notify next */
 	struct logical_zone *logical_zone_to_notify;
-	/** The ID of the thread on which flush requests should be made */
+	/* The ID of the thread on which flush requests should be made */
 	thread_id_t thread_id;
-	/** The pool of flush requests */
+	/* The pool of flush requests */
 	mempool_t *flush_pool;
-	/** Bios waiting for a flush request to become available */
+	/* Bios waiting for a flush request to become available */
 	struct bio_list waiting_flush_bios;
-	/** The lock to protect the previous fields */
+	/* The lock to protect the previous fields */
 	spinlock_t lock;
-	/** The rotor for selecting the bio queue for submitting flush bios */
+	/* The rotor for selecting the bio queue for submitting flush bios */
 	zone_count_t bio_queue_rotor;
-	/** The number of flushes submitted to the current bio queue */
+	/* The number of flushes submitted to the current bio queue */
 	int flush_count;
 };
 
diff --git a/drivers/md/dm-vdo/recovery-journal.h b/drivers/md/dm-vdo/recovery-journal.h
index d78c6c7da4ea..899071173015 100644
--- a/drivers/md/dm-vdo/recovery-journal.h
+++ b/drivers/md/dm-vdo/recovery-journal.h
@@ -89,27 +89,27 @@ enum vdo_zone_type {
 };
 
 struct lock_counter {
-	/** The completion for notifying the owner of a lock release */
+	/* The completion for notifying the owner of a lock release */
 	struct vdo_completion completion;
-	/** The number of logical zones which may hold locks */
+	/* The number of logical zones which may hold locks */
 	zone_count_t logical_zones;
-	/** The number of physical zones which may hold locks */
+	/* The number of physical zones which may hold locks */
 	zone_count_t physical_zones;
-	/** The number of locks */
+	/* The number of locks */
 	block_count_t locks;
-	/** Whether the lock release notification is in flight */
+	/* Whether the lock release notification is in flight */
 	atomic_t state;
-	/** The number of logical zones which hold each lock */
+	/* The number of logical zones which hold each lock */
 	atomic_t *logical_zone_counts;
-	/** The number of physical zones which hold each lock */
+	/* The number of physical zones which hold each lock */
 	atomic_t *physical_zone_counts;
-	/** The per-lock counts for the journal zone */
+	/* The per-lock counts for the journal zone */
 	u16 *journal_counters;
-	/** The per-lock decrement counts for the journal zone */
+	/* The per-lock decrement counts for the journal zone */
 	atomic_t *journal_decrement_counts;
-	/** The per-zone, per-lock reference counts for logical zones */
+	/* The per-zone, per-lock reference counts for logical zones */
 	u16 *logical_counters;
-	/** The per-zone, per-lock reference counts for physical zones */
+	/* The per-zone, per-lock reference counts for physical zones */
 	u16 *physical_counters;
 };
 
diff --git a/drivers/md/dm-vdo/statistics.h b/drivers/md/dm-vdo/statistics.h
index da8b6a7fe24f..c88a75dffba3 100644
--- a/drivers/md/dm-vdo/statistics.h
+++ b/drivers/md/dm-vdo/statistics.h
@@ -13,11 +13,11 @@ enum {
 };
 
 struct block_allocator_statistics {
-	/** The total number of slabs from which blocks may be allocated */
+	/* The total number of slabs from which blocks may be allocated */
 	u64 slab_count;
-	/** The total number of slabs from which blocks have ever been allocated */
+	/* The total number of slabs from which blocks have ever been allocated */
 	u64 slabs_opened;
-	/** The number of times since loading that a slab has been re-opened */
+	/* The number of times since loading that a slab has been re-opened */
 	u64 slabs_reopened;
 };
 
@@ -29,235 +29,235 @@ struct block_allocator_statistics {
  * reporting purposes
  */
 struct commit_statistics {
-	/** The total number of items on which processing has started */
+	/* The total number of items on which processing has started */
 	u64 started;
-	/** The total number of items for which a write operation has been issued */
+	/* The total number of items for which a write operation has been issued */
 	u64 written;
-	/** The total number of items for which a write operation has completed */
+	/* The total number of items for which a write operation has completed */
 	u64 committed;
 };
 
 /** Counters for events in the recovery journal */
 struct recovery_journal_statistics {
-	/** Number of times the on-disk journal was full */
+	/* Number of times the on-disk journal was full */
 	u64 disk_full;
-	/** Number of times the recovery journal requested slab journal commits. */
+	/* Number of times the recovery journal requested slab journal commits. */
 	u64 slab_journal_commits_requested;
-	/** Write/Commit totals for individual journal entries */
+	/* Write/Commit totals for individual journal entries */
 	struct commit_statistics entries;
-	/** Write/Commit totals for journal blocks */
+	/* Write/Commit totals for journal blocks */
 	struct commit_statistics blocks;
 };
 
 /** The statistics for the compressed block packer. */
 struct packer_statistics {
-	/** Number of compressed data items written since startup */
+	/* Number of compressed data items written since startup */
 	u64 compressed_fragments_written;
-	/** Number of blocks containing compressed items written since startup */
+	/* Number of blocks containing compressed items written since startup */
 	u64 compressed_blocks_written;
-	/** Number of VIOs that are pending in the packer */
+	/* Number of VIOs that are pending in the packer */
 	u64 compressed_fragments_in_packer;
 };
 
 /** The statistics for the slab journals. */
 struct slab_journal_statistics {
-	/** Number of times the on-disk journal was full */
+	/* Number of times the on-disk journal was full */
 	u64 disk_full_count;
-	/** Number of times an entry was added over the flush threshold */
+	/* Number of times an entry was added over the flush threshold */
 	u64 flush_count;
-	/** Number of times an entry was added over the block threshold */
+	/* Number of times an entry was added over the block threshold */
 	u64 blocked_count;
-	/** Number of times a tail block was written */
+	/* Number of times a tail block was written */
 	u64 blocks_written;
-	/** Number of times we had to wait for the tail to write */
+	/* Number of times we had to wait for the tail to write */
 	u64 tail_busy_count;
 };
 
 /** The statistics for the slab summary. */
 struct slab_summary_statistics {
-	/** Number of blocks written */
+	/* Number of blocks written */
 	u64 blocks_written;
 };
 
 /** The statistics for the reference counts. */
 struct ref_counts_statistics {
-	/** Number of reference blocks written */
+	/* Number of reference blocks written */
 	u64 blocks_written;
 };
 
 /** The statistics for the block map. */
 struct block_map_statistics {
-	/** number of dirty (resident) pages */
+	/* number of dirty (resident) pages */
 	u32 dirty_pages;
-	/** number of clean (resident) pages */
+	/* number of clean (resident) pages */
 	u32 clean_pages;
-	/** number of free pages */
+	/* number of free pages */
 	u32 free_pages;
-	/** number of pages in failed state */
+	/* number of pages in failed state */
 	u32 failed_pages;
-	/** number of pages incoming */
+	/* number of pages incoming */
 	u32 incoming_pages;
-	/** number of pages outgoing */
+	/* number of pages outgoing */
 	u32 outgoing_pages;
-	/** how many times free page not avail */
+	/* how many times free page not avail */
 	u32 cache_pressure;
-	/** number of get_vdo_page() calls for read */
+	/* number of get_vdo_page() calls for read */
 	u64 read_count;
-	/** number of get_vdo_page() calls for write */
+	/* number of get_vdo_page() calls for write */
 	u64 write_count;
-	/** number of times pages failed to read */
+	/* number of times pages failed to read */
 	u64 failed_reads;
-	/** number of times pages failed to write */
+	/* number of times pages failed to write */
 	u64 failed_writes;
-	/** number of gets that are reclaimed */
+	/* number of gets that are reclaimed */
 	u64 reclaimed;
-	/** number of gets for outgoing pages */
+	/* number of gets for outgoing pages */
 	u64 read_outgoing;
-	/** number of gets that were already there */
+	/* number of gets that were already there */
 	u64 found_in_cache;
-	/** number of gets requiring discard */
+	/* number of gets requiring discard */
 	u64 discard_required;
-	/** number of gets enqueued for their page */
+	/* number of gets enqueued for their page */
 	u64 wait_for_page;
-	/** number of gets that have to fetch */
+	/* number of gets that have to fetch */
 	u64 fetch_required;
-	/** number of page fetches */
+	/* number of page fetches */
 	u64 pages_loaded;
-	/** number of page saves */
+	/* number of page saves */
 	u64 pages_saved;
-	/** the number of flushes issued */
+	/* the number of flushes issued */
 	u64 flush_count;
 };
 
 /** The dedupe statistics from hash locks */
 struct hash_lock_statistics {
-	/** Number of times the UDS advice proved correct */
+	/* Number of times the UDS advice proved correct */
 	u64 dedupe_advice_valid;
-	/** Number of times the UDS advice proved incorrect */
+	/* Number of times the UDS advice proved incorrect */
 	u64 dedupe_advice_stale;
-	/** Number of writes with the same data as another in-flight write */
+	/* Number of writes with the same data as another in-flight write */
 	u64 concurrent_data_matches;
-	/** Number of writes whose hash collided with an in-flight write */
+	/* Number of writes whose hash collided with an in-flight write */
 	u64 concurrent_hash_collisions;
-	/** Current number of dedupe queries that are in flight */
+	/* Current number of dedupe queries that are in flight */
 	u32 curr_dedupe_queries;
 };
 
 /** Counts of error conditions in VDO. */
 struct error_statistics {
-	/** number of times VDO got an invalid dedupe advice PBN from UDS */
+	/* number of times VDO got an invalid dedupe advice PBN from UDS */
 	u64 invalid_advice_pbn_count;
-	/** number of times a VIO completed with a VDO_NO_SPACE error */
+	/* number of times a VIO completed with a VDO_NO_SPACE error */
 	u64 no_space_error_count;
-	/** number of times a VIO completed with a VDO_READ_ONLY error */
+	/* number of times a VIO completed with a VDO_READ_ONLY error */
 	u64 read_only_error_count;
 };
 
 struct bio_stats {
-	/** Number of REQ_OP_READ bios */
+	/* Number of REQ_OP_READ bios */
 	u64 read;
-	/** Number of REQ_OP_WRITE bios with data */
+	/* Number of REQ_OP_WRITE bios with data */
 	u64 write;
-	/** Number of bios tagged with REQ_PREFLUSH and containing no data */
+	/* Number of bios tagged with REQ_PREFLUSH and containing no data */
 	u64 empty_flush;
-	/** Number of REQ_OP_DISCARD bios */
+	/* Number of REQ_OP_DISCARD bios */
 	u64 discard;
-	/** Number of bios tagged with REQ_PREFLUSH */
+	/* Number of bios tagged with REQ_PREFLUSH */
 	u64 flush;
-	/** Number of bios tagged with REQ_FUA */
+	/* Number of bios tagged with REQ_FUA */
 	u64 fua;
 };
 
 struct memory_usage {
-	/** Tracked bytes currently allocated. */
+	/* Tracked bytes currently allocated. */
 	u64 bytes_used;
-	/** Maximum tracked bytes allocated. */
+	/* Maximum tracked bytes allocated. */
 	u64 peak_bytes_used;
 };
 
 /** UDS index statistics */
 struct index_statistics {
-	/** Number of records stored in the index */
+	/* Number of records stored in the index */
 	u64 entries_indexed;
-	/** Number of post calls that found an existing entry */
+	/* Number of post calls that found an existing entry */
 	u64 posts_found;
-	/** Number of post calls that added a new entry */
+	/* Number of post calls that added a new entry */
 	u64 posts_not_found;
-	/** Number of query calls that found an existing entry */
+	/* Number of query calls that found an existing entry */
 	u64 queries_found;
-	/** Number of query calls that added a new entry */
+	/* Number of query calls that added a new entry */
 	u64 queries_not_found;
-	/** Number of update calls that found an existing entry */
+	/* Number of update calls that found an existing entry */
 	u64 updates_found;
-	/** Number of update calls that added a new entry */
+	/* Number of update calls that added a new entry */
 	u64 updates_not_found;
-	/** Number of entries discarded */
+	/* Number of entries discarded */
 	u64 entries_discarded;
 };
 
 /** The statistics of the vdo service. */
 struct vdo_statistics {
 	u32 version;
-	/** Number of blocks used for data */
+	/* Number of blocks used for data */
 	u64 data_blocks_used;
-	/** Number of blocks used for VDO metadata */
+	/* Number of blocks used for VDO metadata */
 	u64 overhead_blocks_used;
-	/** Number of logical blocks that are currently mapped to physical blocks */
+	/* Number of logical blocks that are currently mapped to physical blocks */
 	u64 logical_blocks_used;
-	/** number of physical blocks */
+	/* number of physical blocks */
 	block_count_t physical_blocks;
-	/** number of logical blocks */
+	/* number of logical blocks */
 	block_count_t logical_blocks;
-	/** Size of the block map page cache, in bytes */
+	/* Size of the block map page cache, in bytes */
 	u64 block_map_cache_size;
-	/** The physical block size */
+	/* The physical block size */
 	u64 block_size;
-	/** Number of times the VDO has successfully recovered */
+	/* Number of times the VDO has successfully recovered */
 	u64 complete_recoveries;
-	/** Number of times the VDO has recovered from read-only mode */
+	/* Number of times the VDO has recovered from read-only mode */
 	u64 read_only_recoveries;
-	/** String describing the operating mode of the VDO */
+	/* String describing the operating mode of the VDO */
 	char mode[15];
-	/** Whether the VDO is in recovery mode */
+	/* Whether the VDO is in recovery mode */
 	bool in_recovery_mode;
-	/** What percentage of recovery mode work has been completed */
+	/* What percentage of recovery mode work has been completed */
 	u8 recovery_percentage;
-	/** The statistics for the compressed block packer */
+	/* The statistics for the compressed block packer */
 	struct packer_statistics packer;
-	/** Counters for events in the block allocator */
+	/* Counters for events in the block allocator */
 	struct block_allocator_statistics allocator;
-	/** Counters for events in the recovery journal */
+	/* Counters for events in the recovery journal */
 	struct recovery_journal_statistics journal;
-	/** The statistics for the slab journals */
+	/* The statistics for the slab journals */
 	struct slab_journal_statistics slab_journal;
-	/** The statistics for the slab summary */
+	/* The statistics for the slab summary */
 	struct slab_summary_statistics slab_summary;
-	/** The statistics for the reference counts */
+	/* The statistics for the reference counts */
 	struct ref_counts_statistics ref_counts;
-	/** The statistics for the block map */
+	/* The statistics for the block map */
 	struct block_map_statistics block_map;
-	/** The dedupe statistics from hash locks */
+	/* The dedupe statistics from hash locks */
 	struct hash_lock_statistics hash_lock;
-	/** Counts of error conditions */
+	/* Counts of error conditions */
 	struct error_statistics errors;
-	/** The VDO instance */
+	/* The VDO instance */
 	u32 instance;
-	/** Current number of active VIOs */
+	/* Current number of active VIOs */
 	u32 current_vios_in_progress;
-	/** Maximum number of active VIOs */
+	/* Maximum number of active VIOs */
 	u32 max_vios;
-	/** Number of times the UDS index was too slow in responding */
+	/* Number of times the UDS index was too slow in responding */
 	u64 dedupe_advice_timeouts;
-	/** Number of flush requests submitted to the storage device */
+	/* Number of flush requests submitted to the storage device */
 	u64 flush_out;
-	/** Logical block size */
+	/* Logical block size */
 	u64 logical_block_size;
-	/** Bios submitted into VDO from above */
+	/* Bios submitted into VDO from above */
 	struct bio_stats bios_in;
 	struct bio_stats bios_in_partial;
-	/** Bios submitted onward for user data */
+	/* Bios submitted onward for user data */
 	struct bio_stats bios_out;
-	/** Bios submitted onward for metadata */
+	/* Bios submitted onward for metadata */
 	struct bio_stats bios_meta;
 	struct bio_stats bios_journal;
 	struct bio_stats bios_page_cache;
@@ -267,11 +267,11 @@ struct vdo_statistics {
 	struct bio_stats bios_page_cache_completed;
 	struct bio_stats bios_acknowledged;
 	struct bio_stats bios_acknowledged_partial;
-	/** Current number of bios in progress */
+	/* Current number of bios in progress */
 	struct bio_stats bios_in_progress;
-	/** Memory usage stats. */
+	/* Memory usage stats. */
 	struct memory_usage memory_usage;
-	/** The statistics for the UDS index */
+	/* The statistics for the UDS index */
 	struct index_statistics index;
 };
 
diff --git a/drivers/md/dm-vdo/vdo.h b/drivers/md/dm-vdo/vdo.h
index 35d603066529..772317e6db52 100644
--- a/drivers/md/dm-vdo/vdo.h
+++ b/drivers/md/dm-vdo/vdo.h
@@ -25,13 +25,13 @@
 #include "uds.h"
 
 enum notifier_state {
-	/** Notifications are allowed but not in progress */
+	/* Notifications are allowed but not in progress */
 	MAY_NOTIFY,
-	/** A notification is in progress */
+	/* A notification is in progress */
 	NOTIFYING,
-	/** Notifications are not allowed */
+	/* Notifications are not allowed */
 	MAY_NOT_NOTIFY,
-	/** A notification has completed */
+	/* A notification has completed */
 	NOTIFIED,
 };
 
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index f9c54ec56176..eb6838ddabbb 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -20,21 +20,21 @@
 
 /* A vio_pool is a collection of preallocated vios. */
 struct vio_pool {
-	/** The number of objects managed by the pool */
+	/* The number of objects managed by the pool */
 	size_t size;
-	/** The list of objects which are available */
+	/* The list of objects which are available */
 	struct list_head available;
-	/** The queue of requestors waiting for objects from the pool */
+	/* The queue of requestors waiting for objects from the pool */
 	struct vdo_wait_queue waiting;
-	/** The number of objects currently in use */
+	/* The number of objects currently in use */
 	size_t busy_count;
-	/** The list of objects which are in use */
+	/* The list of objects which are in use */
 	struct list_head busy;
-	/** The ID of the thread on which this pool may be used */
+	/* The ID of the thread on which this pool may be used */
 	thread_id_t thread_id;
-	/** The buffer backing the pool's vios */
+	/* The buffer backing the pool's vios */
 	char *buffer;
-	/** The pool entries */
+	/* The pool entries */
 	struct pooled_vio vios[];
 };
 
-- 
2.42.0

