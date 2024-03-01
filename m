Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6999B4642B
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267379; cv=none; b=f2UEzUp4UfU2iXjkF9q3nBtdOxw/IbJMA0Lk5Cn6w7fIFQjk54U72pyWQ5Y/Q3EJAZLDEm6+yMfzovvUKnep5zXZENnhY0ZIk9uocAK6H0m44rGAYPxr+KLN3kgiRO5PZZOZdFNhQ90vgppxql05F8R8QN7HWDgG8MN7kYQ6f04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267379; c=relaxed/simple;
	bh=39G/BcaF/hCqFLeqidERKKX9kaUXVofMkTDP5b3lXRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cf1enX6EFrmvgjA19YiI8moB0A5+M1jyGWa1QYpNFEpl1ONl9Tb/HlBGtI4iknwIcuOrze6LVvnyagrvJp95XE21XPz1qlp4UkkPPl/+4fh5mQZY1c1olDVWCC5ZC2HnJ98en53hxO+PZKtlQSqFlb/t/oTyrgaAXpEex+/WMRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UTqIf5k9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UTqIf5k9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=isI6uOq8pMG/Z6OUTk4yvimLmxwSNz1/GSgwlbl/L3Y=;
	b=UTqIf5k9j/dCGKk8X1pGHg/nNYWGeKJ7KaPGuwLlkwcVkfJvKxFAoTexew4cd4cXdFe59o
	FrVhED3wtUtG/SQnsQzLiFmVVjZMl+ZbKp+In/h+lmcCVxmeotNLCUVaRzbmUly26N0ksM
	Cor9oZcHEfdqgAeOIngWGN3tWC7wpUc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-oPNiZuH0OTKfueXlltgSDA-1; Thu,
 29 Feb 2024 23:29:31 -0500
X-MC-Unique: oPNiZuH0OTKfueXlltgSDA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A39A31C05151
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:29:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9AB46C1EA63;
	Fri,  1 Mar 2024 04:29:30 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 7F58CA15E9; Thu, 29 Feb 2024 23:29:30 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm-vdo: change unnamed enums to defines
Date: Thu, 29 Feb 2024 23:29:30 -0500
Message-ID: <624a8be2621943024404560831c26aef38cad62a.1709267307.git.msakai@redhat.com>
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

From: Bruce Johnston <bjohnsto@redhat.com>

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c              |  6 ++--
 drivers/md/dm-vdo/data-vio.c               |  8 ++---
 drivers/md/dm-vdo/dedupe.c                 | 20 ++++-------
 drivers/md/dm-vdo/dm-vdo-target.c          | 28 +++++++--------
 drivers/md/dm-vdo/dump.c                   | 11 +++---
 drivers/md/dm-vdo/encodings.c              |  4 +--
 drivers/md/dm-vdo/errors.c                 |  4 +--
 drivers/md/dm-vdo/indexer/config.c         | 10 +++---
 drivers/md/dm-vdo/indexer/delta-index.c    | 40 ++++++----------------
 drivers/md/dm-vdo/indexer/index-layout.c   | 20 ++++-------
 drivers/md/dm-vdo/indexer/index-page-map.c |  4 +--
 drivers/md/dm-vdo/indexer/io-factory.c     |  2 +-
 drivers/md/dm-vdo/indexer/open-chapter.c   |  8 ++---
 drivers/md/dm-vdo/indexer/radix-sort.c     |  6 ++--
 drivers/md/dm-vdo/indexer/sparse-cache.c   |  6 ++--
 drivers/md/dm-vdo/indexer/volume-index.c   |  6 ++--
 drivers/md/dm-vdo/indexer/volume.c         | 12 +++----
 drivers/md/dm-vdo/int-map.c                | 12 +++----
 drivers/md/dm-vdo/logical-zone.c           |  4 +--
 drivers/md/dm-vdo/packer.c                 |  4 +--
 drivers/md/dm-vdo/physical-zone.c          |  6 ++--
 drivers/md/dm-vdo/priority-table.c         |  4 +--
 drivers/md/dm-vdo/recovery-journal.c       | 16 ++++-----
 drivers/md/dm-vdo/thread-utils.c           |  8 ++---
 drivers/md/dm-vdo/vdo.c                    |  2 +-
 25 files changed, 91 insertions(+), 160 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 5be400743c03..b7274e94b269 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -114,10 +114,8 @@ const struct block_map_entry UNMAPPED_BLOCK_MAP_ENTRY = {
 	.pbn_low_word = __cpu_to_le32(VDO_ZERO_BLOCK & UINT_MAX),
 };
 
-enum {
-	LOG_INTERVAL = 4000,
-	DISPLAY_INTERVAL = 100000,
-};
+#define LOG_INTERVAL 4000
+#define DISPLAY_INTERVAL 100000
 
 /*
  * For adjusting VDO page cache statistic fields which are only mutated on the logical zone thread.
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index f6c32dc9a822..1630993e536f 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -114,9 +114,7 @@ static blk_opf_t PASSTHROUGH_FLAGS = (REQ_PRIO | REQ_META | REQ_SYNC | REQ_RAHEA
  * them are awakened.
  */
 
-enum {
-	DATA_VIO_RELEASE_BATCH_SIZE = 128,
-};
+#define DATA_VIO_RELEASE_BATCH_SIZE 128
 
 static const unsigned int VDO_SECTORS_PER_BLOCK_MASK = VDO_SECTORS_PER_BLOCK - 1;
 static const u32 COMPRESSION_STATUS_MASK = 0xff;
@@ -1044,8 +1042,8 @@ void dump_data_vio_pool(struct data_vio_pool *pool, bool dump_vios)
 	 * In order that syslog can empty its buffer, sleep after 35 elements for 4ms (till the
 	 * second clock tick).  These numbers were picked based on experiments with lab machines.
 	 */
-	enum { ELEMENTS_PER_BATCH = 35 };
-	enum { SLEEP_FOR_SYSLOG = 4000 };
+	static const int ELEMENTS_PER_BATCH = 35;
+	static const int SLEEP_FOR_SYSLOG = 4000;
 
 	if (pool == NULL)
 		return;
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index c8018c5799bd..b453a204239a 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -154,11 +154,9 @@ struct uds_attribute {
 	const char *(*show_string)(struct hash_zones *hash_zones);
 };
 
-enum timer_state {
-	DEDUPE_QUERY_TIMER_IDLE,
-	DEDUPE_QUERY_TIMER_RUNNING,
-	DEDUPE_QUERY_TIMER_FIRED,
-};
+#define DEDUPE_QUERY_TIMER_IDLE 0
+#define DEDUPE_QUERY_TIMER_RUNNING 1
+#define DEDUPE_QUERY_TIMER_FIRED 2
 
 enum dedupe_context_state {
 	DEDUPE_CONTEXT_IDLE,
@@ -185,11 +183,9 @@ static const char *SUSPENDED = "suspended";
 static const char *UNKNOWN = "unknown";
 
 /* Version 2 uses the kernel space UDS index and is limited to 16 bytes */
-enum {
-	UDS_ADVICE_VERSION = 2,
-	/* version byte + state byte + 64-bit little-endian PBN */
-	UDS_ADVICE_SIZE = 1 + 1 + sizeof(u64),
-};
+#define UDS_ADVICE_VERSION 2
+/* version byte + state byte + 64-bit little-endian PBN */
+#define UDS_ADVICE_SIZE (1 + 1 + sizeof(u64))
 
 enum hash_lock_state {
 	/* State for locks that are not in use or are being initialized. */
@@ -279,9 +275,7 @@ struct hash_lock {
 	struct vdo_wait_queue waiters;
 };
 
-enum {
-	LOCK_POOL_CAPACITY = MAXIMUM_VDO_USER_VIOS,
-};
+#define LOCK_POOL_CAPACITY MAXIMUM_VDO_USER_VIOS
 
 struct hash_zones {
 	struct action_manager *manager;
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 429a285cbc4a..175ee56a89e1 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -42,7 +42,7 @@
 
 #define	CURRENT_VERSION "8.3.0.65"
 
-enum {
+enum admin_phases {
 	GROW_LOGICAL_PHASE_START,
 	GROW_LOGICAL_PHASE_GROW_BLOCK_MAP,
 	GROW_LOGICAL_PHASE_END,
@@ -142,10 +142,8 @@ static const char * const ADMIN_PHASE_NAMES[] = {
 	"SUSPEND_PHASE_END",
 };
 
-enum {
-	/* If we bump this, update the arrays below */
-	TABLE_VERSION = 4,
-};
+/* If we bump this, update the arrays below */
+#define TABLE_VERSION 4
 
 /* arrays for handling different table versions */
 static const u8 REQUIRED_ARGC[] = { 10, 12, 9, 7, 6 };
@@ -159,17 +157,15 @@ static const u8 POOL_NAME_ARG_INDEX[] = { 8, 10, 8 };
  * need to scan 16 words, so it's not likely to be a big deal compared to other resource usage.
  */
 
-enum {
-	/*
-	 * This minimum size for the bit array creates a numbering space of 0-999, which allows
-	 * successive starts of the same volume to have different instance numbers in any
-	 * reasonably-sized test. Changing instances on restart allows vdoMonReport to detect that
-	 * the ephemeral stats have reset to zero.
-	 */
-	BIT_COUNT_MINIMUM = 1000,
-	/** Grow the bit array by this many bits when needed */
-	BIT_COUNT_INCREMENT = 100,
-};
+/*
+ * This minimum size for the bit array creates a numbering space of 0-999, which allows
+ * successive starts of the same volume to have different instance numbers in any
+ * reasonably-sized test. Changing instances on restart allows vdoMonReport to detect that
+ * the ephemeral stats have reset to zero.
+ */
+#define BIT_COUNT_MINIMUM 1000
+/* Grow the bit array by this many bits when needed */
+#define BIT_COUNT_INCREMENT 100
 
 struct instance_tracker {
 	unsigned int bit_count;
diff --git a/drivers/md/dm-vdo/dump.c b/drivers/md/dm-vdo/dump.c
index 91bc8ed36aa7..2a0890b54186 100644
--- a/drivers/md/dm-vdo/dump.c
+++ b/drivers/md/dm-vdo/dump.c
@@ -41,10 +41,10 @@ enum dump_option_flags {
 	FLAG_SKIP_DEFAULT = (1 << SKIP_DEFAULT)
 };
 
-enum {
-	FLAGS_ALL_POOLS = (FLAG_SHOW_VIO_POOL),
-	DEFAULT_DUMP_FLAGS = (FLAG_SHOW_QUEUES | FLAG_SHOW_VDO_STATUS)
-};
+#define FLAGS_ALL_POOLS (FLAG_SHOW_VIO_POOL)
+#define DEFAULT_DUMP_FLAGS (FLAG_SHOW_QUEUES | FLAG_SHOW_VDO_STATUS)
+/* Another static buffer... log10(256) = 2.408+, round up: */
+#define DIGITS_PER_U64 (1 + sizeof(u64) * 2409 / 1000)
 
 static inline bool is_arg_string(const char *arg, const char *this_option)
 {
@@ -222,9 +222,6 @@ void dump_data_vio(void *data)
 	 * one does run, the log output will be garbled anyway.
 	 */
 	static char vio_completion_dump_buffer[100 + MAX_VDO_WORK_QUEUE_NAME_LEN];
-	/* Another static buffer... log10(256) = 2.408+, round up: */
-	enum { DIGITS_PER_U64 = 1 + sizeof(u64) * 2409 / 1000 };
-
 	static char vio_block_number_dump_buffer[sizeof("P L D") + 3 * DIGITS_PER_U64];
 	static char vio_flush_generation_buffer[sizeof(" FG") + DIGITS_PER_U64];
 	static char flags_dump_buffer[8];
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 5012042b26af..4a0a6afea670 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -55,9 +55,7 @@ static const struct header GEOMETRY_BLOCK_HEADER_4_0 = {
 
 const u8 VDO_GEOMETRY_MAGIC_NUMBER[VDO_GEOMETRY_MAGIC_NUMBER_SIZE + 1] = "dmvdo001";
 
-enum {
-	PAGE_HEADER_4_1_SIZE = 8 + 8 + 8 + 1 + 1 + 1 + 1,
-};
+#define PAGE_HEADER_4_1_SIZE (8 + 8 + 8 + 1 + 1 + 1 + 1)
 
 static const struct version_number BLOCK_MAP_4_1 = {
 	.major_version = 4,
diff --git a/drivers/md/dm-vdo/errors.c b/drivers/md/dm-vdo/errors.c
index e8599599a377..dc1f0533bd7a 100644
--- a/drivers/md/dm-vdo/errors.c
+++ b/drivers/md/dm-vdo/errors.c
@@ -79,9 +79,7 @@ struct error_block {
 	const struct error_info *infos;
 };
 
-enum {
-	MAX_ERROR_BLOCKS = 6,
-};
+#define MAX_ERROR_BLOCKS 6
 
 static struct {
 	int allocated;
diff --git a/drivers/md/dm-vdo/indexer/config.c b/drivers/md/dm-vdo/indexer/config.c
index 0bf315e7b5d1..b572350a3d5f 100644
--- a/drivers/md/dm-vdo/indexer/config.c
+++ b/drivers/md/dm-vdo/indexer/config.c
@@ -15,12 +15,10 @@ static const u8 INDEX_CONFIG_MAGIC[] = "ALBIC";
 static const u8 INDEX_CONFIG_VERSION_6_02[] = "06.02";
 static const u8 INDEX_CONFIG_VERSION_8_02[] = "08.02";
 
-enum {
-	DEFAULT_VOLUME_READ_THREADS = 2,
-	MAX_VOLUME_READ_THREADS = 16,
-	INDEX_CONFIG_MAGIC_LENGTH = sizeof(INDEX_CONFIG_MAGIC) - 1,
-	INDEX_CONFIG_VERSION_LENGTH = sizeof(INDEX_CONFIG_VERSION_6_02) - 1,
-};
+#define DEFAULT_VOLUME_READ_THREADS 2
+#define MAX_VOLUME_READ_THREADS 16
+#define INDEX_CONFIG_MAGIC_LENGTH (sizeof(INDEX_CONFIG_MAGIC) - 1)
+#define INDEX_CONFIG_VERSION_LENGTH ((int)(sizeof(INDEX_CONFIG_VERSION_6_02) - 1))
 
 static bool is_version(const u8 *version, u8 *buffer)
 {
diff --git a/drivers/md/dm-vdo/indexer/delta-index.c b/drivers/md/dm-vdo/indexer/delta-index.c
index 6a85f93bbcb1..8eece0ba6d93 100644
--- a/drivers/md/dm-vdo/indexer/delta-index.c
+++ b/drivers/md/dm-vdo/indexer/delta-index.c
@@ -70,17 +70,13 @@
  * This is the largest field size supported by get_field() and set_field(). Any field that is
  * larger is not guaranteed to fit in a single byte-aligned u32.
  */
-enum {
-	MAX_FIELD_BITS = (sizeof(u32) - 1) * BITS_PER_BYTE + 1,
-};
+#define MAX_FIELD_BITS ((sizeof(u32) - 1) * BITS_PER_BYTE + 1)
 
 /*
  * This is the largest field size supported by get_big_field() and set_big_field(). Any field that
  * is larger is not guaranteed to fit in a single byte-aligned u64.
  */
-enum {
-	MAX_BIG_FIELD_BITS = (sizeof(u64) - 1) * BITS_PER_BYTE + 1,
-};
+#define MAX_BIG_FIELD_BITS ((sizeof(u64) - 1) * BITS_PER_BYTE + 1)
 
 /*
  * This is the number of guard bytes needed at the end of the memory byte array when using the bit
@@ -88,45 +84,33 @@ enum {
  * bytes beyond the end of the desired field. The definition is written to make it clear how this
  * value is derived.
  */
-enum {
-	POST_FIELD_GUARD_BYTES = sizeof(u64) - 1,
-};
+#define POST_FIELD_GUARD_BYTES (sizeof(u64) - 1)
 
 /* The number of guard bits that are needed in the tail guard list */
-enum {
-	GUARD_BITS = POST_FIELD_GUARD_BYTES * BITS_PER_BYTE
-};
+#define GUARD_BITS (POST_FIELD_GUARD_BYTES * BITS_PER_BYTE)
 
 /*
  * The maximum size of a single delta list in bytes. We count guard bytes in this value because a
  * buffer of this size can be used with move_bits().
  */
-enum {
-	DELTA_LIST_MAX_BYTE_COUNT =
-		((U16_MAX + BITS_PER_BYTE) / BITS_PER_BYTE + POST_FIELD_GUARD_BYTES)
-};
+#define DELTA_LIST_MAX_BYTE_COUNT					\
+	((U16_MAX + BITS_PER_BYTE) / BITS_PER_BYTE + POST_FIELD_GUARD_BYTES)
 
 /* The number of extra bytes and bits needed to store a collision entry */
-enum {
-	COLLISION_BYTES = UDS_RECORD_NAME_SIZE,
-	COLLISION_BITS = COLLISION_BYTES * BITS_PER_BYTE
-};
+#define COLLISION_BYTES UDS_RECORD_NAME_SIZE
+#define COLLISION_BITS (COLLISION_BYTES * BITS_PER_BYTE)
 
 /*
  * Immutable delta lists are packed into pages containing a header that encodes the delta list
  * information into 19 bits per list (64KB bit offset).
  */
-
-enum { IMMUTABLE_HEADER_SIZE = 19 };
+#define IMMUTABLE_HEADER_SIZE 19
 
 /*
  * Constants and structures for the saved delta index. "DI" is for delta_index, and -##### is a
  * number to increment when the format of the data changes.
  */
-
-enum {
-	MAGIC_SIZE = 8,
-};
+#define MAGIC_SIZE 8
 
 static const char DELTA_INDEX_MAGIC[] = "DI-00002";
 
@@ -216,9 +200,7 @@ static void rebalance_delta_zone(const struct delta_zone *delta_zone, u32 first,
 static inline size_t get_zone_memory_size(unsigned int zone_count, size_t memory_size)
 {
 	/* Round up so that each zone is a multiple of 64K in size. */
-	enum {
-		ALLOC_BOUNDARY = 64 * 1024,
-	};
+	size_t ALLOC_BOUNDARY = 64 * 1024;
 
 	return (memory_size / zone_count + ALLOC_BOUNDARY - 1) & -ALLOC_BOUNDARY;
 }
diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index af533aa270a8..a0227a75814b 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -54,11 +54,9 @@
  * Each save also has a unique nonce.
  */
 
-enum {
-	MAGIC_SIZE = 32,
-	NONCE_INFO_SIZE = 32,
-	MAX_SAVES = 2,
-};
+#define MAGIC_SIZE 32
+#define NONCE_INFO_SIZE 32
+#define MAX_SAVES 2
 
 enum region_kind {
 	RL_KIND_EMPTY = 0,
@@ -82,9 +80,7 @@ enum region_type {
 	RH_TYPE_UNSAVED = 4,
 };
 
-enum {
-	RL_SOLE_INSTANCE = 65535,
-};
+#define RL_SOLE_INSTANCE 65535
 
 /*
  * Super block version 2 is the first released version.
@@ -98,11 +94,9 @@ enum {
  * order to make room to prepend LVM metadata to a volume originally created without lvm. This
  * allows the index to retain most its deduplication records.
  */
-enum {
-	SUPER_VERSION_MINIMUM = 3,
-	SUPER_VERSION_CURRENT = 3,
-	SUPER_VERSION_MAXIMUM = 7,
-};
+#define SUPER_VERSION_MINIMUM 3
+#define SUPER_VERSION_CURRENT 3
+#define SUPER_VERSION_MAXIMUM 7
 
 static const u8 LAYOUT_MAGIC[MAGIC_SIZE] = "*ALBIREO*SINGLE*FILE*LAYOUT*001*";
 static const u64 REGION_MAGIC = 0x416c6252676e3031; /* 'AlbRgn01' */
diff --git a/drivers/md/dm-vdo/indexer/index-page-map.c b/drivers/md/dm-vdo/indexer/index-page-map.c
index 90d97c33a9c3..37037ac8eee9 100644
--- a/drivers/md/dm-vdo/indexer/index-page-map.c
+++ b/drivers/md/dm-vdo/indexer/index-page-map.c
@@ -25,9 +25,7 @@
 
 static const u8 PAGE_MAP_MAGIC[] = "ALBIPM02";
 
-enum {
-	PAGE_MAP_MAGIC_LENGTH = sizeof(PAGE_MAP_MAGIC) - 1,
-};
+#define PAGE_MAP_MAGIC_LENGTH (sizeof(PAGE_MAP_MAGIC) - 1)
 
 static inline u32 get_entry_count(const struct index_geometry *geometry)
 {
diff --git a/drivers/md/dm-vdo/indexer/io-factory.c b/drivers/md/dm-vdo/indexer/io-factory.c
index 02242df94e37..fecd436986ae 100644
--- a/drivers/md/dm-vdo/indexer/io-factory.c
+++ b/drivers/md/dm-vdo/indexer/io-factory.c
@@ -37,7 +37,7 @@ struct buffered_reader {
 	u8 *end;
 };
 
-enum { MAX_READ_AHEAD_BLOCKS = 4 };
+#define MAX_READ_AHEAD_BLOCKS 4
 
 /*
  * The buffered writer allows efficient I/O by buffering writes and committing page-sized segments
diff --git a/drivers/md/dm-vdo/indexer/open-chapter.c b/drivers/md/dm-vdo/indexer/open-chapter.c
index da16afaec07f..cd2d35e39c20 100644
--- a/drivers/md/dm-vdo/indexer/open-chapter.c
+++ b/drivers/md/dm-vdo/indexer/open-chapter.c
@@ -46,11 +46,9 @@
 static const u8 OPEN_CHAPTER_MAGIC[] = "ALBOC";
 static const u8 OPEN_CHAPTER_VERSION[] = "02.00";
 
-enum {
-	OPEN_CHAPTER_MAGIC_LENGTH = sizeof(OPEN_CHAPTER_MAGIC) - 1,
-	OPEN_CHAPTER_VERSION_LENGTH = sizeof(OPEN_CHAPTER_VERSION) - 1,
-	LOAD_RATIO = 2,
-};
+#define OPEN_CHAPTER_MAGIC_LENGTH (sizeof(OPEN_CHAPTER_MAGIC) - 1)
+#define OPEN_CHAPTER_VERSION_LENGTH (sizeof(OPEN_CHAPTER_VERSION) - 1)
+#define LOAD_RATIO 2
 
 static inline size_t records_size(const struct open_chapter_zone *open_chapter)
 {
diff --git a/drivers/md/dm-vdo/indexer/radix-sort.c b/drivers/md/dm-vdo/indexer/radix-sort.c
index 1f17c708a652..b86d55f0827e 100644
--- a/drivers/md/dm-vdo/indexer/radix-sort.c
+++ b/drivers/md/dm-vdo/indexer/radix-sort.c
@@ -17,10 +17,8 @@
  * keys to be sorted.
  */
 
-enum {
-	/* Piles smaller than this are handled with a simple insertion sort. */
-	INSERTION_SORT_THRESHOLD = 12,
-};
+/* Piles smaller than this are handled with a simple insertion sort. */
+#define INSERTION_SORT_THRESHOLD 12
 
 /* Sort keys are pointers to immutable fixed-length arrays of bytes. */
 typedef const u8 *sort_key_t;
diff --git a/drivers/md/dm-vdo/indexer/sparse-cache.c b/drivers/md/dm-vdo/indexer/sparse-cache.c
index f2141de6ed00..9e8672cba3fa 100644
--- a/drivers/md/dm-vdo/indexer/sparse-cache.c
+++ b/drivers/md/dm-vdo/indexer/sparse-cache.c
@@ -77,10 +77,8 @@
  * considered to be a member of the cache for uds_sparse_cache_contains().
  */
 
-enum {
-	SKIP_SEARCH_THRESHOLD = 20000,
-	ZONE_ZERO = 0,
-};
+#define SKIP_SEARCH_THRESHOLD 20000
+#define ZONE_ZERO 0
 
 /*
  * These counters are essentially fields of the struct cached_chapter_index, but are segregated
diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
index 8cbd9280c4bd..a88e515ceef6 100644
--- a/drivers/md/dm-vdo/indexer/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -94,7 +94,8 @@ struct chapter_range {
 	u32 chapter_count;
 };
 
-enum { MAGIC_SIZE = 8 };
+#define MAGIC_SIZE 8
+
 static const char MAGIC_START_5[] = "MI5-0005";
 
 struct sub_index_data {
@@ -193,10 +194,11 @@ unsigned int uds_get_volume_index_zone(const struct volume_index *volume_index,
 	return get_volume_sub_index_zone(get_volume_sub_index(volume_index, name), name);
 }
 
+#define DELTA_LIST_SIZE 256
+
 static int compute_volume_sub_index_parameters(const struct uds_configuration *config,
 					       struct sub_index_parameters *params)
 {
-	enum { DELTA_LIST_SIZE = 256 };
 	u64 entries_in_volume_index, address_span;
 	u32 chapters_in_volume_index, invalid_chapters;
 	u32 rounded_chapters;
diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index eca83b6cab35..002a4264a163 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -60,13 +60,11 @@
  * in-memory volume index.
  */
 
-enum {
-	/* The maximum allowable number of contiguous bad chapters */
-	MAX_BAD_CHAPTERS = 100,
-	VOLUME_CACHE_MAX_ENTRIES = (U16_MAX >> 1),
-	VOLUME_CACHE_QUEUED_FLAG = (1 << 15),
-	VOLUME_CACHE_MAX_QUEUED_READS = 4096,
-};
+/* The maximum allowable number of contiguous bad chapters */
+#define MAX_BAD_CHAPTERS 100
+#define VOLUME_CACHE_MAX_ENTRIES (U16_MAX >> 1)
+#define VOLUME_CACHE_QUEUED_FLAG (1 << 15)
+#define VOLUME_CACHE_MAX_QUEUED_READS 4096
 
 static const u64 BAD_CHAPTER = U64_MAX;
 
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index 99ccbb1339c6..e0953e013f15 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -56,13 +56,11 @@
 #include "numeric.h"
 #include "permassert.h"
 
-enum {
-	DEFAULT_CAPACITY = 16, /* the number of neighborhoods in a new table */
-	NEIGHBORHOOD = 255,    /* the number of buckets in each neighborhood */
-	MAX_PROBES = 1024,     /* limit on the number of probes for a free bucket */
-	NULL_HOP_OFFSET = 0,   /* the hop offset value terminating the hop list */
-	DEFAULT_LOAD = 75      /* a compromise between memory use and performance */
-};
+#define DEFAULT_CAPACITY 16 /* the number of neighborhoods in a new table */
+#define NEIGHBORHOOD 255    /* the number of buckets in each neighborhood */
+#define MAX_PROBES 1024     /* limit on the number of probes for a free bucket */
+#define NULL_HOP_OFFSET 0   /* the hop offset value terminating the hop list */
+#define DEFAULT_LOAD 75     /* a compromise between memory use and performance */
 
 /**
  * struct bucket - hash bucket
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index e11f9c859349..c5b3b1c111e3 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -21,9 +21,7 @@
 #include "physical-zone.h"
 #include "vdo.h"
 
-enum {
-	ALLOCATIONS_PER_ZONE = 128,
-};
+#define ALLOCATIONS_PER_ZONE 128
 
 /**
  * as_logical_zone() - Convert a generic vdo_completion to a logical_zone.
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index b0ffb21ec436..3283c8d56c59 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -30,9 +30,7 @@ static const struct version_number COMPRESSED_BLOCK_1_0 = {
 	.minor_version = 0,
 };
 
-enum {
-	COMPRESSED_BLOCK_1_0_SIZE = 4 + 4 + (2 * VDO_MAX_COMPRESSION_SLOTS),
-};
+#define COMPRESSED_BLOCK_1_0_SIZE (4 + 4 + (2 * VDO_MAX_COMPRESSION_SLOTS))
 
 /**
  * vdo_get_compressed_block_fragment() - Get a reference to a compressed fragment from a compressed
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index a9380966b56f..62d142b28282 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -23,10 +23,8 @@
 #include "status-codes.h"
 #include "vdo.h"
 
-enum {
-	/* Each user data_vio needs a PBN read lock and write lock. */
-	LOCK_POOL_CAPACITY = 2 * MAXIMUM_VDO_USER_VIOS,
-};
+/* Each user data_vio needs a PBN read lock and write lock. */
+#define LOCK_POOL_CAPACITY (2 * MAXIMUM_VDO_USER_VIOS)
 
 struct pbn_lock_implementation {
 	enum pbn_lock_type type;
diff --git a/drivers/md/dm-vdo/priority-table.c b/drivers/md/dm-vdo/priority-table.c
index 9408219b5700..a59e9d40ca90 100644
--- a/drivers/md/dm-vdo/priority-table.c
+++ b/drivers/md/dm-vdo/priority-table.c
@@ -14,9 +14,7 @@
 #include "status-codes.h"
 
 /* We use a single 64-bit search vector, so the maximum priority is 63 */
-enum {
-	MAX_PRIORITY = 63
-};
+#define MAX_PRIORITY 63
 
 /*
  * All the entries with the same priority are queued in a circular list in a bucket for that
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 1e15bfe42cfc..c1d355346bcf 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -26,15 +26,13 @@
 
 static const u64 RECOVERY_COUNT_MASK = 0xff;
 
-enum {
-	/*
-	 * The number of reserved blocks must be large enough to prevent a new recovery journal
-	 * block write from overwriting a block which appears to still be a valid head block of the
-	 * journal. Currently, that means reserving enough space for all 2048 data_vios.
-	 */
-	RECOVERY_JOURNAL_RESERVED_BLOCKS =
-		(MAXIMUM_VDO_USER_VIOS / RECOVERY_JOURNAL_ENTRIES_PER_BLOCK) + 2,
-};
+/*
+ * The number of reserved blocks must be large enough to prevent a new recovery journal
+ * block write from overwriting a block which appears to still be a valid head block of the
+ * journal. Currently, that means reserving enough space for all 2048 data_vios.
+ */
+#define RECOVERY_JOURNAL_RESERVED_BLOCKS				\
+	((MAXIMUM_VDO_USER_VIOS / RECOVERY_JOURNAL_ENTRIES_PER_BLOCK) + 2)
 
 /**
  * DOC: Lock Counters.
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index aeca14bba852..244abc6ad848 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -27,11 +27,9 @@ struct thread {
 	struct completion thread_done;
 };
 
-enum {
-	ONCE_NOT_DONE = 0,
-	ONCE_IN_PROGRESS = 1,
-	ONCE_COMPLETE = 2,
-};
+#define ONCE_NOT_DONE 0
+#define ONCE_IN_PROGRESS 1
+#define ONCE_COMPLETE 2
 
 /* Run a function once only, and record that fact in the atomic value. */
 void vdo_perform_once(atomic_t *once, void (*function)(void))
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index d16404588881..6baf319d79c6 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -60,7 +60,7 @@
 #include "status-codes.h"
 #include "vio.h"
 
-enum { PARANOID_THREAD_CONSISTENCY_CHECKS = 0 };
+#define PARANOID_THREAD_CONSISTENCY_CHECKS 0
 
 struct sync_completion {
 	struct vdo_completion vdo_completion;
-- 
2.42.0

