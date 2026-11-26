Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795729335;
	b=GJpzZV+I7bHGuJ7UbNXAaBAQNjhjg0Wox9ZnksTZUgLc5yCLdC2IIXnnGFc0ymSWvpCn
	 7vwj16pf6FNbjKru7G6LXhn0sQ5BjTdBM1NQGWZm8Buzms2xB/uQp8+BW67KTmGHn2RWJ
	 RF/DHUdyQJnJputoFJHGIOO3L+CbuFr4xyRi9DbhlbFW+bO4DSkalbb7V9yyabE9zIkq5
	 wZESfsDOM3OXaPtbCmqTozTj7iSExfhCgWZGr4FRpz2Y8hjDl3VfpmssX+P3kMGZ9spb9
	 N4kW+5ox/S/Q+bz+VfKKiFR9c5XRjWZfWk8p9n0fyVkXnWsaEVzmxOW8IaBGOyDCTQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795729335;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=DtFZiTybFNfPs/zHeahOgiU5IcSjjtdD2yTEOLxOC54=;
	b=NHuoXHtxJYJlymbG59g4ipBwYLIBuxs7+xqktGoXaC4uCPnb6o1Tyd0KbEP7TjVxrxhY
	 bcNnizreD2qoowaAZrmNwZ1fxGwxhGDcO2mq+fRN8SKbJW3I9gKDEgpBGcc/pqvmW4zQm
	 QU4Cl3OzLKkAY86GofEsUiZKan7y/CtLdPBW0jvuN0N7e3duP8rcj/2u+aY2PfOz183bM
	 /Gtse73OSu3FazkkY5i+197wPP8P+zQQEE6yudh0XX1o5OOJCcqPCsSwnHqRJ6YgEXeJ/
	 JaurJdAgciaSp6hupgkM68+DUXVHRXQZzw6N8xXvAt6hebiWtZlvWpNzGUldk8//QKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MYAU5auH;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662D5606A31C
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 21:42:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 662D5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MYAU5auH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795729332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=DtFZiTybFNfPs/zHeahOgiU5IcSjjtdD2yTEOLxOC54=;
	b=MYAU5auHXpqQwbRbPbuuNJhHW9ovfAn2jGTszCJCfxp1JOvCAxkYRnVSxhl5toMiSF4h3A
	rYZDHubrGezPF6G6ydwACZv8ZQKZPoKbD7te2Aa3pbAOsjHJbhxdFDw2gFLuuusDD0ErA1
	b73Vt6BeVDLZZBI/c+C+WYnepHO1FuA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-636-hlFi7CWNMwSwPdURF-Uh8Q-1; Thu,
 26 Nov 2026 21:42:08 +0000
X-MC-Unique: hlFi7CWNMwSwPdURF-Uh8Q-1
X-Mimecast-MFC-AGG-ID: hlFi7CWNMwSwPdURF-Uh8Q_1795729327
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7A94195607A;
	Thu, 26 Nov 2026 21:42:06 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBEA51956041;
	Thu, 26 Nov 2026 21:42:03 +0000 (UTC)
Date: Thu, 26 Nov 2026 22:42:01 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Eric Biggers <ebiggers@kernel.org>, Ming-Hung Tsai <mtsai@redhat.com>, 
    Zdenek Kabelac <zkabelac@redhat.com>, Filip Suba <fsuba@redhat.com>, 
    dm-devel@lists.linux.dev
Subject: [PATCH v2] dm-compress: introduce the dm-compress target
Message-ID: <275c8a42-b281-8e68-eaef-05a1ea3eba16@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a7cLSvIySwAn4idd2-6_Huzwg4BaNRBbgkyjYbHt5DE_1795729327
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

dm-compress: introduce the dm-compress target

This commit introduces a new target dm-compress that provides transparent
compression and decompression of block devices.

Changes since version 1:
- fix bugs found by Sashiko
- use the compression libraries directly as suggested by Eric Biggers

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/admin-guide/device-mapper/dm-compress.rst |   61 +
 Documentation/admin-guide/device-mapper/index.rst       |    1 
 drivers/md/Kconfig                                      |    2 
 drivers/md/Makefile                                     |    1 
 drivers/md/dm-bufio.c                                   |   16 
 drivers/md/dm-compress/Kconfig                          |   16 
 drivers/md/dm-compress/Makefile                         |   11 
 drivers/md/dm-compress/algorithms.c                     |  130 ++
 drivers/md/dm-compress/alloc.c                          |  505 ++++++++
 drivers/md/dm-compress/cc.c                             |  214 +++
 drivers/md/dm-compress/chunk.c                          |  440 +++++++
 drivers/md/dm-compress/dm-compress.h                    |  215 +++
 drivers/md/dm-compress/io.c                             |  640 ++++++++++
 drivers/md/dm-compress/struct.h                         |  128 ++
 drivers/md/dm-compress/target.c                         |  934 ++++++++++++++++
 include/linux/dm-bufio.h                                |   14 
 16 files changed, 3328 insertions(+)

Index: linux-2.6/drivers/md/Kconfig
===================================================================
--- linux-2.6.orig/drivers/md/Kconfig
+++ linux-2.6/drivers/md/Kconfig
@@ -719,4 +719,6 @@ source "drivers/md/dm-vdo/Kconfig"
 
 source "drivers/md/dm-pcache/Kconfig"
 
+source "drivers/md/dm-compress/Kconfig"
+
 endif # MD
Index: linux-2.6/drivers/md/dm-compress/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-compress/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# dm-compress configuration
+#
+
+config DM_COMPRESS
+	tristate "Compression target"
+	depends on BLK_DEV_DM
+	select DM_BUFIO
+	select LZ4_COMPRESS
+	select LZ4HC_COMPRESS
+	select LZ4_DECOMPRESS
+	select ZSTD_COMPRESS
+	select ZSTD_DECOMPRESS
+	help
+	  This target stores compressed data.
Index: linux-2.6/drivers/md/dm-compress/dm-compress.h
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-compress/dm-compress.h
@@ -0,0 +1,215 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2026 Mikulas Patocka
+ *
+ * This file is released under the GPL.
+ */
+
+#include <linux/device-mapper.h>
+#include <linux/dm-io.h>
+#include <linux/dm-bufio.h>
+#include <linux/vmalloc.h>
+
+//#define TEST_SPLIT_CHUNKS
+//#define TEST_SPLIT_CHUNK_CHAINS
+//#define TEST_UNCOMPRESSED_DATA
+//#define TEST_FUA
+//#define TEST_MALFORMED_CONTENT
+
+#define DM_MSG_PREFIX "compress"
+
+#define METADATA_WORKQUEUE_MAX_ACTIVE	128
+#define N_CACHED_CHUNKS			128
+#define DEFAULT_AUTOCOMMIT_MSEC		60000
+
+#include "struct.h"
+
+struct algorithm {
+	const char *name;
+	void *(*allocate_context)(gfp_t gfp);
+	void (*free_context)(void *context);
+	int (*compress)(void *context, void *in, size_t in_len, void *out, size_t out_len);
+	int (*decompress)(void *context, void *in, size_t in_len, void *out, size_t out_len);
+};
+
+#define DM_COMPRESS_N_ALGORITHMS	3
+
+struct block_group_descriptor {
+	struct mutex mutex;
+} ____cacheline_aligned_in_smp;
+
+#define TAG_VALID		1
+#define TAG_WRITTEN		2
+
+struct cached_chunk {
+	struct rb_node node;
+	struct list_head lru_entry;
+	sector_t chunk;
+	struct dm_compress *c;
+	bool in_tree;
+	bool dirty;
+#define INTENT_IDLE		0
+#define INTENT_READ		1
+#define INTENT_WRITE		2
+#define INTENT_FREE		3
+	uint8_t intent;
+	uint8_t algorithm;
+	unsigned compressed_size;
+	int failed;
+	void *uncompressed_data;
+	void *compressed_data;
+	void *merging_data;
+	struct work_struct work;
+	unsigned short bio_vectors;
+	struct completion completion;
+	struct bio *bio;
+	void *contexts[DM_COMPRESS_N_ALGORITHMS];
+	uint8_t sector_tags[];
+};
+
+struct dm_compress {
+	struct dm_target *ti;
+	sector_t start;
+	struct dm_dev *dev;
+	struct dm_dev *meta_dev;
+	unsigned char log2_sectors_per_block;
+	unsigned char log2_sectors_per_chunk;
+	unsigned char algorithm;
+	sector_t n_blocks;
+	sector_t n_chunks;
+	struct superblock *sb;
+	struct crash_count_table *cct;
+	__u64 cc_txc;
+
+	int failed;
+
+	struct workqueue_struct *wq;
+	struct workqueue_struct *compress_wq;
+	struct workqueue_struct *flush_wq;
+
+	struct dm_bufio_client *bufio;
+	struct dm_io_client *io;
+
+	sector_t *block_directories;
+	sector_t *chunk_directories;
+	struct block_group_descriptor *groups;
+	size_t n_groups;
+	sector_t last_allocated;
+
+	atomic64_t free_blocks;
+
+	unsigned long autocommit_jiffies;
+	unsigned autocommit_msec;
+	bool autocommit_set;
+	bool autocommit_active;
+	struct delayed_work autocommit_work;
+	wait_queue_head_t wait_idle;
+
+	struct list_head free_chunks;
+	struct list_head lru;
+	struct rb_root chunks;
+	struct mutex mutex;
+
+	struct list_head waiting_bio_lru;
+	struct rb_root waiting_bio_tree;
+
+	unsigned n_cached_chunks;
+
+	mempool_t block_io_buffers;
+	struct dm_bufio_client *split_bufio;
+	int split_bufio_dirty;
+};
+
+struct dm_compress_io {
+	struct dm_compress *c;
+	struct work_struct work;
+	sector_t chunk;
+	unsigned offset_in_chunk;
+	bool is_flush;
+
+	struct list_head waiting_list_entry;
+	struct rb_node tree_entry;
+};
+
+static inline bool CC_VALID(struct dm_compress *c, __le64 *cc_txc)
+{
+	__u64 ct = le64_to_cpup(cc_txc);
+	__u16 cc = ct;
+	return (__s64)(le64_to_cpu(c->cct->entries[cc]) - ct) >= 0;
+}
+
+static inline bool CC_CURRENT(struct dm_compress *c, __le64 *cc_txc)
+{
+	__u64 ct = le64_to_cpup(cc_txc);
+	return ((c->cc_txc ^ ct) & ~(1ULL << 63)) == 0;
+}
+
+static inline void CC_SET_CURRENT(struct dm_compress *c, __le64 *cc_txc)
+{
+	__u64 ct = le64_to_cpup(cc_txc);
+	__u16 cc = ct;
+	__u64 top_bit = ~(le64_to_cpu(c->cct->entries[cc]) - ct) & (1ULL << 63);
+	*cc_txc = cpu_to_le64(c->cc_txc | top_bit);
+}
+
+static inline void block_location(struct dm_compress *c, sector_t block, size_t *group_ptr, size_t *dir_ptr, unsigned *dir_offset, unsigned *bmp_offset)
+{
+	*bmp_offset = do_div(block, BITS_PER_BITMAP);
+	*group_ptr = block;
+	*dir_offset = do_div(block, DIRECTORY_ENTRIES);
+	*dir_ptr = block;
+}
+
+static inline void chunk_location(struct dm_compress *c, sector_t chunk, size_t *dir_ptr, unsigned *dir_offset, unsigned *chunk_offset)
+{
+	*chunk_offset = do_div(chunk, CHUNKS_PER_BUFFER);
+	*dir_offset = do_div(chunk, DIRECTORY_ENTRIES);
+	*dir_ptr = chunk;
+}
+
+/* target.c */
+
+extern struct algorithm dm_compress_algorithms[DM_COMPRESS_N_ALGORITHMS];
+
+void dm_compress_error(struct dm_compress *c, const char *msg, int err);
+void dm_compress_error_chunk(struct cached_chunk *cc, const char *msg, int err);
+int dm_compress_sync_rw_metadata(struct dm_compress *c, blk_opf_t opf, enum dm_io_mem_type type, sector_t sector, void *ptr, sector_t sectors);
+void dm_compress_sync(struct dm_compress *c);
+
+/* cc.c */
+
+struct cached_chunk *dm_compress_alloc_cached_chunk(struct dm_compress *c);
+void dm_compress_free_cached_chunk(struct cached_chunk *cc);
+struct cached_chunk *dm_compress_find_cached_chunk(struct dm_compress *c, sector_t chunk, struct cached_chunk *for_insert);
+struct cached_chunk *dm_compress_new_cached_chunk(struct dm_compress_io *dio);
+void dm_compress_release_cached_chunk(struct cached_chunk *cc);
+void dm_compress_wait_for_cached_chunk(struct dm_compress_io *dio);
+struct dm_compress_io *dm_compress_pick_dio_for_chunk(struct dm_compress *c, sector_t chunk);
+struct dm_compress_io *dm_compress_pick_oldest_dio(struct dm_compress *c);
+void dm_compress_unlink_dio(struct dm_compress_io *dio);
+bool dm_compress_is_something_in_progress(struct dm_compress *c);
+
+/* alloc.c */
+
+#define ALLOCATE_NO_SPACE	((sector_t)-1)
+#define ALLOCATE_ERROR		((sector_t)-2)
+
+sector_t dm_compress_allocate_space(struct dm_compress *c, sector_t preferred_block, unsigned n_blocks);
+void dm_compress_free_space(struct dm_compress *c, sector_t block, unsigned n_blocks);
+int dm_compress_get_free_space(struct dm_compress *c);
+struct chunk_ptr *dm_compress_prepare_chunk(struct dm_compress *c, sector_t chunk, struct dm_buffer **bp);
+int dm_compress_resize_bitmaps(struct dm_compress *c, sector_t current_size, sector_t new_size, bool *need_sync);
+
+/* chunk.c */
+
+bool dm_compress_read_chunk(struct cached_chunk *cc, struct chunk_ptr *cp);
+bool dm_compress_allocate_chunk(struct cached_chunk *cc, sector_t preferred_block, struct chunk_ptr *cp);
+void dm_compress_release_chunk(struct dm_compress *c, struct chunk_ptr *ptr);
+
+/* io.c */
+
+void dm_compress_enqueue_chunk(struct cached_chunk *cc, unsigned intent);
+int dm_compress_map(struct dm_target *ti, struct bio *bio);
+void dm_compress_work(struct work_struct *w);
+void dm_compress_autocommit(struct work_struct *w);
Index: linux-2.6/drivers/md/dm-compress/target.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-compress/target.c
@@ -0,0 +1,934 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2026 Mikulas Patocka
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-compress.h"
+
+void dm_compress_error(struct dm_compress *c, const char *msg, int err)
+{
+	if (!cmpxchg(&c->failed, 0, err)) {
+		DMERR("%s: %d", msg, err);
+		DMERR("Disabling the device");
+	}
+}
+
+void dm_compress_error_chunk(struct cached_chunk *cc, const char *msg, int err)
+{
+	if (!cmpxchg(&cc->failed, 0, err)) {
+		DMERR("%s: %d", msg, err);
+	}
+}
+
+int dm_compress_sync_rw_metadata(struct dm_compress *c, blk_opf_t opf, enum dm_io_mem_type type, sector_t sector, void *ptr, sector_t sectors)
+{
+	struct dm_io_request io_req;
+	struct dm_io_region io_loc;
+	int r;
+
+	io_req.bi_opf = opf;
+	io_req.mem.type = type;
+	io_req.mem.ptr.addr = ptr;
+	io_req.notify.fn = NULL;
+	io_req.client = c->io;
+	io_loc.bdev = c->meta_dev ? c->meta_dev->bdev : c->dev->bdev;
+	io_loc.sector = c->start + sector;
+	io_loc.count = sectors;
+
+	r = dm_io(&io_req, 1, &io_loc, NULL, NULL, IOPRIO_DEFAULT);
+	if (unlikely(r))
+		return r;
+
+	return 0;
+}
+
+void dm_compress_sync(struct dm_compress *c)
+{
+	struct block_device *bdev = c->meta_dev ? c->meta_dev->bdev : c->dev->bdev;
+	__u16 cc;
+	unsigned granularity;
+	unsigned offset;
+	int r;
+
+	r = dm_bufio_write_dirty_buffers(c->bufio);
+	if (unlikely(r)) {
+		dm_compress_error(c, "Error flushing buffers", r);
+		goto skip_commit;
+	}
+
+	if (unlikely(c->split_bufio_dirty)) {
+		c->split_bufio_dirty = false;
+		r = dm_bufio_write_dirty_buffers(c->split_bufio);
+		if (unlikely(r)) {
+			dm_compress_error(c, "Error flushing split chunk buffers", r);
+			goto skip_commit;
+		}
+		goto skip_flush_dev;
+	}
+
+	if (c->meta_dev) {
+		r = blkdev_issue_flush(c->dev->bdev);
+		if (unlikely(r)) {
+			dm_compress_error(c, "Error flushing the data device", r);
+			goto skip_commit;
+		}
+	}
+skip_flush_dev:
+
+	if (unlikely(c->failed))
+		goto skip_commit;
+
+	granularity = __fls(bdev_logical_block_size(bdev));
+	if (granularity < 12)
+		granularity = 12;
+
+	cc = c->cc_txc;
+	offset = (cc * 8) >> granularity;
+
+	r = dm_compress_sync_rw_metadata(c, REQ_OP_WRITE | REQ_SYNC | REQ_FUA, DM_IO_VMA, le64_to_cpu(c->sb->cct) * (BUFFER_SIZE >> SECTOR_SHIFT) + (offset << granularity >> SECTOR_SHIFT), (__u8 *)c->cct + (offset << granularity), 1U << granularity >> SECTOR_SHIFT);
+	if (unlikely(r)) {
+		dm_compress_error(c, "Error updating crash count table", r);
+		goto skip_commit;
+	}
+
+	c->cct->entries[c->cc_txc & 0xffff] = cpu_to_le64(le64_to_cpup(&c->cct->entries[c->cc_txc & 0xffff]) + 0x10000);
+	c->cc_txc += 0x10000;
+
+skip_commit:
+	cancel_delayed_work(&c->autocommit_work);
+}
+
+static int initialize_device(struct dm_compress *c)
+{
+	int r;
+	struct superblock *sb = c->sb;
+	sector_t position;
+	sector_t meta_size;
+	sector_t data_blocks;
+	sector_t n_bitmap_blocks;
+	sector_t n_bitmap_directories;
+	sector_t n_chunk_blocks;
+	sector_t n_chunk_directories;
+	sector_t used_meta_size;
+	unsigned i;
+	sector_t s, dp;
+	struct dm_buffer *bp;
+	const unsigned log2_buffer_sectors = __ffs(BUFFER_SECTORS);
+
+	memcpy(sb->magic, SB_MAGIC, 8);
+	sb->version = SB_VERSION_1;
+	sb->log2_buffer_size = __ffs(BUFFER_SIZE);
+	sb->log2_sectors_per_block = c->log2_sectors_per_block;
+	sb->log2_sectors_per_chunk = c->log2_sectors_per_chunk;
+	position = 1;
+	sb->cct = cpu_to_le64(position);
+	sb->n_blocks[0] = cpu_to_le64(c->n_blocks);
+	sb->n_chunks[0] = cpu_to_le64(c->n_chunks);
+	position += dm_div_up(CCT_SIZE, BUFFER_SIZE);
+
+	data_blocks = c->n_blocks;
+	n_bitmap_blocks = dm_sector_div_up(data_blocks, BITS_PER_BITMAP);
+	n_bitmap_directories = dm_sector_div_up(n_bitmap_blocks, DIRECTORY_ENTRIES);
+
+	n_chunk_blocks = dm_sector_div_up(c->n_chunks, CHUNKS_PER_BUFFER);
+	n_chunk_directories = dm_sector_div_up(n_chunk_blocks, DIRECTORY_ENTRIES);
+
+	meta_size = bdev_nr_sectors(c->meta_dev ? c->meta_dev->bdev : c->dev->bdev);
+	meta_size = meta_size >= c->start ? meta_size - c->start : 0;
+	meta_size >>= log2_buffer_sectors;
+
+	used_meta_size = position + n_bitmap_blocks + n_bitmap_directories + n_chunk_blocks + n_chunk_directories;
+	if (used_meta_size > 1ULL << 48) {
+		c->ti->error = "The device is too big";
+		return -ENOSPC;
+	}
+	if (c->meta_dev) {
+		sb->n_used_metadata_blocks[0] = cpu_to_le64(used_meta_size);
+	} else {
+		if (used_meta_size * (BUFFER_SIZE >> SECTOR_SHIFT) >= data_blocks << c->log2_sectors_per_block)
+			goto small_dev;
+	}
+	if (used_meta_size > meta_size) {
+small_dev:
+		if (c->meta_dev)
+			c->ti->error = "The metadata device is too small";
+		else
+			c->ti->error = "The device is too small";
+		return -ENOSPC;
+	}
+
+	/*printk("pos: %llx\n", position);
+	printk("pos: %llx\n", n_bitmap_blocks);
+	printk("pos: %llx\n", n_bitmap_directories);
+	printk("pos: %llx\n", n_chunk_blocks);
+	printk("pos: %llx\n", n_chunk_directories);
+	printk("pos: %llx\n", used_meta_size);*/
+	sb->bitmap_directory = cpu_to_le64(position + n_bitmap_blocks);
+	sb->chunk_directory = cpu_to_le64(position + n_bitmap_blocks + n_bitmap_directories + n_chunk_blocks);
+
+	if (c->log2_sectors_per_block < log2_buffer_sectors)
+		used_meta_size <<= log2_buffer_sectors - c->log2_sectors_per_block;
+	else if (c->log2_sectors_per_block > log2_buffer_sectors)
+		used_meta_size = dm_sector_div_up(used_meta_size, 1U << (c->log2_sectors_per_block - log2_buffer_sectors));
+
+	dp = 0;
+	for (s = 0; s < n_bitmap_blocks; s++) {
+		struct bitmap *bmp = dm_bufio_new(c->bufio, position + s, &bp);
+		if (unlikely(IS_ERR(bmp))) {
+			c->ti->error = "Error allocating buffer";
+			return PTR_ERR(bmp);
+		}
+		memset(bmp, 0, BUFFER_SIZE);
+		bmp->magic = BITMAP_MAGIC;
+		for (i = 0; i < BITS_PER_BITMAP; i++, dp++) {
+			if (!c->meta_dev && dp < used_meta_size)
+				__set_bit_le(i, bmp->bmp2);
+			if (dp >= data_blocks)
+				__set_bit_le(i, bmp->bmp2);
+		}
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+	}
+
+	dp = 0;
+	for (s = 0; s < n_bitmap_directories; s++) {
+		struct directory *dir = dm_bufio_new(c->bufio, position + n_bitmap_blocks + s, &bp);
+		if (unlikely(IS_ERR(dir))) {
+			c->ti->error = "Error allocating buffer";
+			return PTR_ERR(dir);
+		}
+		memset(dir, 0, BUFFER_SIZE);
+		dir->magic = BMP_DIR_MAGIC;
+		dir->index = cpu_to_le64(s);
+		for (i = 0; i < DIRECTORY_ENTRIES; i++, dp++) {
+			if (dp < n_bitmap_blocks) {
+				WRITE_PTR(&dir->ptr[i], position + dp);
+			}
+		}
+		if (s + 1 < n_bitmap_directories) {
+			WRITE_PTR(&dir->next, position + n_bitmap_blocks + s + 1);
+		}
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+	}
+	position += n_bitmap_blocks + n_bitmap_directories;
+	for (s = 0; s < n_chunk_blocks; s++) {
+		struct chunk_entries *ch = dm_bufio_new(c->bufio, position + s, &bp);
+		if (unlikely(IS_ERR(ch))) {
+			c->ti->error = "Error allocating buffer";
+			return PTR_ERR(ch);
+		}
+		memset(ch, 0, BUFFER_SIZE);
+		ch->magic = CHUNKS_MAGIC;
+		for (i = 0; i < CHUNKS_PER_BUFFER; i++)
+			ch->chunk[i].ptr[1].algorithm = ALGORITHM_ZERO;
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+	}
+	dp = 0;
+	for (s = 0; s < n_chunk_directories; s++) {
+		struct directory *dir = dm_bufio_new(c->bufio, position + n_chunk_blocks + s, &bp);
+		if (unlikely(IS_ERR(dir))) {
+			c->ti->error = "Error allocating buffer";
+			return PTR_ERR(dir);
+		}
+		memset(dir, 0, BUFFER_SIZE);
+		dir->magic = CHUNK_DIR_MAGIC;
+		dir->index = cpu_to_le64(s);
+		for (i = 0; i < DIRECTORY_ENTRIES; i++, dp++) {
+			if (dp < n_chunk_blocks) {
+				WRITE_PTR(&dir->ptr[i], position + dp);
+			}
+		}
+		if (s + 1 < n_chunk_directories) {
+			WRITE_PTR(&dir->next, position + n_chunk_blocks + s + 1);
+		}
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+	}
+
+	r = dm_bufio_write_dirty_buffers(c->bufio);
+	if (unlikely(r)) {
+		c->ti->error = "Error writing buffers";
+		return r;
+	}
+
+	for (i = 0; i < CCT_ENTRIES; i++)
+		c->cct->entries[i] = cpu_to_le64(0xffff);
+
+	r = dm_compress_sync_rw_metadata(c, REQ_OP_WRITE, DM_IO_VMA, le64_to_cpu(sb->cct) * (BUFFER_SIZE >> SECTOR_SHIFT), c->cct, CCT_SIZE >> SECTOR_SHIFT);
+	if (unlikely(r)) {
+		c->ti->error = "Error writing crash count table";
+		return r;
+	}
+
+	r = dm_compress_sync_rw_metadata(c, REQ_OP_WRITE | REQ_PREFLUSH, DM_IO_KMEM, 0, c->sb, SB_SECTORS);
+	if (unlikely(r)) {
+		c->ti->error = "Error writing superblock";
+		return r;
+	}
+
+	return 0;
+}
+
+static int verify_device(struct dm_compress *c, char **error)
+{
+	struct superblock *sb = c->sb;
+
+	if (memcmp(sb->magic, SB_MAGIC, 8)) {
+		*error = "The device is not initialized";
+		return -EINVAL;
+	}
+	if (sb->version != SB_VERSION_1) {
+		*error = "Version mismatch";
+		return -EINVAL;
+	}
+	if (sb->log2_buffer_size != __ffs(BUFFER_SIZE)) {
+		*error = "Buffer size mismatch";
+		return -EINVAL;
+	}
+	if (sb->log2_sectors_per_block != c->log2_sectors_per_block) {
+		*error = "Block size mismatch";
+		return -EINVAL;
+	}
+	if (sb->log2_sectors_per_chunk != c->log2_sectors_per_chunk) {
+		*error = "Chunk size mismatch";
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void dm_compress_dtr(struct dm_target *ti);
+
+/*
+ * Arguments:
+ *	underlying device
+ *	offset from the start of the device
+ *	block size
+ *	chunk size
+ *	number of chunks
+ *	algorithm
+ *	number of optional arguments
+ */
+
+static int dm_compress_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct dm_compress *c;
+	int r;
+	char dummy;
+	unsigned long long param;
+	unsigned i;
+	unsigned extra_args;
+	size_t dir_ptr;
+	unsigned dir_offset, offset;
+	struct dm_arg_set as;
+	static const struct dm_arg _args[] = {
+		{0, 3, "Invalid number of feature args"},
+	};
+
+	c = kzalloc(sizeof(struct dm_compress), GFP_KERNEL);
+	if (!c) {
+		ti->error = "Cannot allocate compress structure";
+		r = -ENOMEM;
+		goto bad;
+	}
+	ti->private = c;
+	c->ti = ti;
+	ti->per_io_data_size = sizeof(struct dm_compress_io);
+	ti->num_flush_bios = 1;
+	ti->flush_supported = true;
+
+	INIT_LIST_HEAD(&c->free_chunks);
+	INIT_LIST_HEAD(&c->lru);
+	c->chunks = RB_ROOT;
+	mutex_init(&c->mutex);
+	INIT_LIST_HEAD(&c->waiting_bio_lru);
+	c->waiting_bio_tree = RB_ROOT;
+	c->n_cached_chunks = N_CACHED_CHUNKS;
+	c->autocommit_msec = DEFAULT_AUTOCOMMIT_MSEC;
+	INIT_DELAYED_WORK(&c->autocommit_work, dm_compress_autocommit);
+	init_waitqueue_head(&c->wait_idle);
+
+#define DIRECT_ARGUMENTS 6
+
+	if (argc <= DIRECT_ARGUMENTS) {
+		ti->error = "Invalid argument count";
+		r = -EINVAL;
+		goto bad;
+	}
+
+	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &c->dev);
+	if (r) {
+		ti->error = "Device lookup failed";
+		goto bad;
+	}
+
+	if (sscanf(argv[1], "%llu%c", &param, &dummy) != 1 || param != (sector_t)param) {
+		ti->error = "Invalid starting offset";
+		r = -EINVAL;
+		goto bad;
+	}
+	c->start = param;
+
+	if (sscanf(argv[2], "%llu%c", &param, &dummy) != 1 || param < 512 || param > MAX_BLOCK_SIZE || (param & (param - 1))) {
+		ti->error = "Invalid block size";
+		r = -EINVAL;
+		goto bad;
+	}
+	if (param < bdev_logical_block_size(c->dev->bdev)) {
+		ti->error = "Block size is smaller than logical block size";
+		r = -EINVAL;
+		goto bad;
+	}
+	c->log2_sectors_per_block = __ffs(param >> 9);
+
+	if (sscanf(argv[3], "%llu%c", &param, &dummy) != 1 || param < 512 || param > MAX_CHUNK_SIZE || (param & (param - 1))) {
+		ti->error = "Invalid chunk size";
+		r = -EINVAL;
+		goto bad;
+	}
+	c->log2_sectors_per_chunk = __ffs(param >> 9);
+
+	if (c->log2_sectors_per_block >= c->log2_sectors_per_chunk) {
+		ti->error = "Block size is not less than chunk size";
+		r = -EINVAL;
+		goto bad;
+	}
+	if (c->log2_sectors_per_block + 8 < c->log2_sectors_per_chunk) {
+		ti->error = "Block size must be greater or equal than chunk size divied by 256";
+		r = -EINVAL;
+		goto bad;
+	}
+
+	if (sscanf(argv[4], "%llu%c", &param, &dummy) != 1 || !param || param != (sector_t)param) {
+		ti->error = "Invalid number of chunks";
+		r = -EINVAL;
+		goto bad;
+	}
+	c->n_chunks = param;
+
+	for (i = 0; i < DM_COMPRESS_N_ALGORITHMS; i++) {
+		if (!strcmp(dm_compress_algorithms[i].name, argv[5])) {
+			c->algorithm = i;
+			goto found_alg;
+		}
+	}
+	ti->error = "Invalid compression algorithm";
+	r = -EINVAL;
+	goto bad;
+found_alg:
+
+	as.argc = argc - DIRECT_ARGUMENTS;
+	as.argv = argv + DIRECT_ARGUMENTS;
+	r = dm_read_arg_group(_args, &as, &extra_args, &ti->error);
+	if (r)
+		goto bad;
+	while (extra_args--) {
+		const char *opt_string = dm_shift_arg(&as);
+		if (!opt_string) {
+			ti->error = "Not enough feature arguments";
+			r = -EINVAL;
+			goto bad;
+		}
+		if (!strncmp(opt_string, "meta_device:", strlen("meta_device:"))) {
+			if (c->meta_dev) {
+				ti->error = "Metadata device specified more than once";
+				r = -EINVAL;
+				goto bad;
+			}
+			r = dm_get_device(ti, strchr(opt_string, ':') + 1, dm_table_get_mode(ti->table), &c->meta_dev);
+			if (r) {
+				ti->error = "Device lookup failed";
+				goto bad;
+			}
+		} else if (sscanf(opt_string, "n_cached_chunks:%llu%c", &param, &dummy) == 1 && param >= 1 && param < 1048576) {
+			c->n_cached_chunks = param;
+		} else if (sscanf(opt_string, "commit_time:%llu%c", &param, &dummy) == 1 && param == (unsigned)param) {
+			c->autocommit_msec = param;
+			c->autocommit_set = true;
+		} else {
+			ti->error = "Invalid argument";
+			r = -EINVAL;
+			goto bad;
+		}
+	}
+	c->autocommit_jiffies = msecs_to_jiffies(c->autocommit_msec);
+
+	c->wq = alloc_workqueue("dm-compress", WQ_PERCPU | WQ_MEM_RECLAIM, METADATA_WORKQUEUE_MAX_ACTIVE);
+	if (unlikely(!c->wq)) {
+		ti->error = "Cannot allocate workqueue";
+		r = -ENOMEM;
+		goto bad;
+	}
+
+	c->compress_wq = alloc_workqueue("dm-compress-compress", WQ_PERCPU | WQ_MEM_RECLAIM, METADATA_WORKQUEUE_MAX_ACTIVE);
+	if (unlikely(!c->compress_wq)) {
+		ti->error = "Cannot allocate workqueue";
+		r = -ENOMEM;
+		goto bad;
+	}
+
+	c->flush_wq = alloc_workqueue("dm-compress-flush", WQ_PERCPU | WQ_MEM_RECLAIM, 1);
+	if (unlikely(!c->flush_wq)) {
+		ti->error = "Cannot allocate workqueue";
+		r = -ENOMEM;
+		goto bad;
+	}
+
+	c->bufio = dm_bufio_client_create(c->meta_dev ? c->meta_dev->bdev : c->dev->bdev, BUFFER_SIZE, 1, 0, NULL, NULL, 0);
+	if (IS_ERR(c->bufio)) {
+		ti->error = "Cannot initialize dm-bufio";
+		r = PTR_ERR(c->bufio);
+		c->bufio = NULL;
+		goto bad;
+	}
+	dm_bufio_set_sector_offset(c->bufio, c->start);
+
+	c->io = dm_io_client_create();
+	if (IS_ERR(c->io)) {
+		ti->error = "Cannot allocate dm io";
+		r = PTR_ERR(c->io);
+		c->io = NULL;
+		goto bad;
+	}
+
+	c->sb = kmalloc(SB_SECTORS << SECTOR_SHIFT, GFP_KERNEL);
+	if (!c->sb) {
+		ti->error = "Cannot allocate superblock";
+		r = -ENOMEM;
+		goto bad;
+	}
+
+	c->cct = vmalloc(sizeof(struct crash_count_table));
+	if (!c->cct) {
+		ti->error = "Cannot allocate crash count table";
+		r = -ENOMEM;
+		goto bad;
+	}
+
+	r = mempool_init_kmalloc_pool(&c->block_io_buffers, 1, 512U << c->log2_sectors_per_block);
+	if (r) {
+		ti->error = "Cannot allocate io buffers";
+		goto bad;
+	}
+
+	c->split_bufio = dm_bufio_client_create(c->dev->bdev, 512U << c->log2_sectors_per_block, 1, 0, NULL, NULL, 0);
+	if (IS_ERR(c->split_bufio)) {
+		ti->error = "Cannot initialize dm-bufio";
+		r = PTR_ERR(c->split_bufio);
+		c->split_bufio = NULL;
+		goto bad;
+	}
+	if (!c->meta_dev)
+		dm_bufio_set_sector_offset(c->split_bufio, c->start);
+
+	c->n_blocks = bdev_nr_sectors(c->dev->bdev);
+	if (!c->meta_dev) {
+		if (c->n_blocks <= c->start) {
+			ti->error = "The device is too small";
+			r = -ENOSPC;
+			goto bad;
+		}
+		c->n_blocks -= c->start;
+	}
+	c->n_blocks >>= c->log2_sectors_per_block;
+	if (!c->n_blocks) {
+		ti->error = "The device is too small";
+		r = -ENOSPC;
+		goto bad;
+	}
+	if (c->n_blocks > 1ULL << 48) {
+		ti->error = "The device is too big";
+		r = -ENOSPC;
+		goto bad;
+	}
+
+	for (i = 0; i < c->n_cached_chunks; i++) {
+		struct cached_chunk *cc = dm_compress_alloc_cached_chunk(c);
+		if (!cc) {
+			ti->error = "Error allocating cached chunk";
+			r = -ENOMEM;
+			goto bad;
+		}
+		list_add(&cc->lru_entry, &c->free_chunks);
+	}
+
+	r = dm_compress_sync_rw_metadata(c, REQ_OP_READ, DM_IO_KMEM, 0, c->sb, SB_SECTORS);
+	if (r) {
+		ti->error = "Error reading superblock";
+		goto bad;
+	}
+
+	if (mem_is_zero(c->sb, SB_SECTORS << SECTOR_SHIFT)) {
+		r = initialize_device(c);
+		if (r)
+			goto bad;
+	}
+
+	r = verify_device(c, &ti->error);
+	if (r)
+		goto bad;
+
+	block_location(c, c->n_blocks - 1, &c->n_groups, &dir_ptr, &dir_offset, &offset);
+	c->n_groups++;
+	dir_ptr++;
+	c->block_directories = vmalloc_array(dir_ptr, sizeof(sector_t));
+	if (!c->block_directories) {
+		r = -ENOMEM;
+		goto bad;
+	}
+	c->groups = vmalloc_array(c->n_groups, sizeof(struct block_group_descriptor));
+	if (!c->groups) {
+		r = -ENOMEM;
+		goto bad;
+	}
+	for (i = 0; i < c->n_groups; i++) {
+		mutex_init(&c->groups[i].mutex);
+	}
+
+	chunk_location(c, c->n_chunks - 1, &dir_ptr, &dir_offset, &offset);
+	dir_ptr++;
+	c->chunk_directories = vmalloc_array(dir_ptr, sizeof(sector_t));
+	if (!c->chunk_directories) {
+		r = -ENOMEM;
+		goto bad;
+	}
+
+	r = dm_set_target_max_io_len(ti, (sector_t)1 << c->log2_sectors_per_chunk);
+	if (r)
+		goto bad;
+	ti->discards_supported = true;
+	ti->num_discard_bios = 1;
+	ti->max_discard_granularity = true;
+
+	return 0;
+
+bad:
+	dm_compress_dtr(ti);
+	return r;
+}
+
+static void dm_compress_dtr(struct dm_target *ti)
+{
+	struct dm_compress *c = ti->private;
+
+	if (!c)
+		return;
+
+	if (c->wq)
+		destroy_workqueue(c->wq);
+	if (c->compress_wq)
+		destroy_workqueue(c->compress_wq);
+	if (c->flush_wq)
+		destroy_workqueue(c->flush_wq);
+	mempool_exit(&c->block_io_buffers);
+	if (c->bufio)
+		dm_bufio_client_destroy(c->bufio);
+	if (c->split_bufio)
+		dm_bufio_client_destroy(c->split_bufio);
+	if (c->io)
+		dm_io_client_destroy(c->io);
+
+	if (c->dev)
+		dm_put_device(ti, c->dev);
+	if (c->meta_dev)
+		dm_put_device(ti, c->meta_dev);
+
+	while (!list_empty(&c->free_chunks)) {
+		struct cached_chunk *cc = list_entry(c->free_chunks.next, struct cached_chunk, lru_entry);
+		list_del(&cc->lru_entry);
+		dm_compress_free_cached_chunk(cc);
+	}
+	while (!RB_EMPTY_ROOT(&c->chunks)) {
+		struct cached_chunk *cc = rb_entry(rb_first(&c->chunks), struct cached_chunk, node);
+		list_del(&cc->lru_entry);
+		rb_erase(&cc->node, &c->chunks);
+		dm_compress_free_cached_chunk(cc);
+	}
+
+	kfree(c->sb);
+	vfree(c->cct);
+	vfree(c->block_directories);
+	vfree(c->chunk_directories);
+	if (c->groups) {
+		size_t i;
+		for (i = 0; i < c->n_groups; i++)
+			mutex_destroy(&c->groups[i].mutex);
+		vfree(c->groups);
+	}
+
+	mutex_destroy(&c->mutex);
+
+	kfree(c);
+}
+
+
+static int load_directories(struct dm_compress *c, sector_t block, sector_t *directory, size_t n, __be64 magic)
+{
+	size_t i = 0;
+read_next:
+	directory[i++] = block;
+	if (i < n) {
+		struct dm_buffer *bp;
+		struct directory *dir = dm_bufio_read(c->bufio, block, &bp);
+		if (IS_ERR(dir))
+			return PTR_ERR(dir);
+		if (unlikely(dir->magic != magic)) {
+			dm_compress_error(c, "Directory magic doesn't match", -EUCLEAN);
+			dm_bufio_release(bp);
+			return -EUCLEAN;
+		}
+		if (unlikely(le64_to_cpu(dir->index) != i - 1)) {
+			dm_compress_error(c, "Directory index doesn't match", -EUCLEAN);
+			dm_bufio_release(bp);
+			return -EUCLEAN;
+		}
+		block = READ_PTR(&dir->next);
+		dm_bufio_release(bp);
+		goto read_next;
+	}
+	return 0;
+}
+
+static int load_bitmap_directories(struct dm_compress *c, sector_t block)
+{
+	size_t group_ptr, dir_ptr;
+	unsigned dir_offset, offset;
+	int r;
+
+	if (!block) {
+		dm_compress_error(c, "The superblock is corrupted - zero blocks", -EINVAL);
+		return -EINVAL;
+	}
+
+	block_location(c, block - 1, &group_ptr, &dir_ptr, &dir_offset, &offset);
+	dir_ptr++;
+	r = load_directories(c, le64_to_cpu(c->sb->bitmap_directory), c->block_directories, dir_ptr, BMP_DIR_MAGIC);
+	if (r) {
+		dm_compress_error(c, "Unable to read bitmap directories", r);
+		return r;
+	}
+	return 0;
+}
+
+static int load_chunk_directories(struct dm_compress *c, sector_t chunk)
+{
+	size_t dir_ptr;
+	unsigned dir_offset, offset;
+	int r;
+
+	if (!chunk) {
+		dm_compress_error(c, "The superblock is corrupted - zero chunks", -EINVAL);
+		return -EINVAL;
+	}
+
+	chunk_location(c, chunk - 1, &dir_ptr, &dir_offset, &offset);
+	dir_ptr++;
+	r = load_directories(c, le64_to_cpu(c->sb->chunk_directory), c->chunk_directories, dir_ptr, CHUNK_DIR_MAGIC);
+	if (r) {
+		dm_compress_error(c, "Unable to read chunk directories", r);
+		return r;
+	}
+	return 0;
+}
+
+static int dm_compress_preresume(struct dm_target *ti)
+{
+	struct dm_compress *c = ti->private;
+	struct superblock *sb = c->sb;
+	bool need_sync = false;
+	bool b;
+	int r;
+	char *error;
+
+	r = dm_compress_sync_rw_metadata(c, REQ_OP_READ, DM_IO_KMEM, 0, c->sb, SB_SECTORS);
+	if (r) {
+		dm_compress_error(c, "Error reading superblock", r);
+		return r;
+	}
+
+	r = verify_device(c, &error);
+	if (r) {
+		dm_compress_error(c, error, r);
+		return r;
+	}
+
+	r = dm_compress_sync_rw_metadata(c, REQ_OP_READ, DM_IO_VMA, le64_to_cpu(sb->cct) * (BUFFER_SIZE >> SECTOR_SHIFT), c->cct, CCT_SIZE >> SECTOR_SHIFT);
+	if (r) {
+		dm_compress_error(c, "Error reading crash count table", r);
+		return r;
+	}
+
+	c->cc_txc = le16_to_cpup(&c->sb->cc);
+	c->cc_txc |= le64_to_cpup(&c->cct->entries[c->cc_txc & 0xffff]) & ~0xffffULL;
+
+	c->sb->cc = cpu_to_le16(le16_to_cpup(&c->sb->cc) + 1);
+	c->cc_txc += 0x10000;
+	c->cct->entries[c->cc_txc & 0xffff] = cpu_to_le64(le64_to_cpup(&c->cct->entries[c->cc_txc & 0xffff]) + 0x10000);
+
+	r = dm_compress_sync_rw_metadata(c, REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA, DM_IO_KMEM, 0, c->sb, SB_SECTORS);
+	if (unlikely(r)) {
+		dm_compress_error(c, "Error writing superblock", r);
+		return r;
+	}
+
+	b = !CC_VALID(c, &sb->n_cc_txc);
+	if (le64_to_cpu(sb->n_blocks[b]) != c->n_blocks) {
+		if (le64_to_cpu(sb->n_blocks[b]) > c->n_blocks) {
+			DMERR("Shrinking is not yet supported");
+			return -EOPNOTSUPP;
+		}
+		r = load_bitmap_directories(c, le64_to_cpu(sb->n_blocks[b]));
+		if (unlikely(r))
+			return r;
+		r = dm_compress_resize_bitmaps(c, le64_to_cpu(sb->n_blocks[b]), c->n_blocks, &need_sync);
+		if (unlikely(r))
+			return r;
+	}
+	b = !CC_VALID(c, &sb->n_cc_txc);
+	if (le64_to_cpu(sb->n_chunks[b]) != c->n_chunks) {
+		DMERR("Resizing is not yet supported");
+		return -EOPNOTSUPP;
+	}
+
+	r = load_bitmap_directories(c, c->n_blocks);
+	if (r)
+		return r;
+
+	r = load_chunk_directories(c, c->n_chunks);
+	if (r)
+		return r;
+
+	r = dm_compress_get_free_space(c);
+	if (r)
+		return r;
+
+	if (need_sync)
+		dm_compress_sync(c);
+
+	return 0;
+}
+
+static void dm_compress_postsuspend(struct dm_target *ti)
+{
+	struct dm_compress *c = ti->private;
+	int r;
+
+check_again:
+	mutex_lock(&c->mutex);
+	if (dm_compress_is_something_in_progress(c)) {
+		mutex_unlock(&c->mutex);
+		schedule_timeout_uninterruptible(1);
+		goto check_again;
+	}
+	dm_compress_sync(c);
+	mutex_unlock(&c->mutex);
+
+	cancel_delayed_work_sync(&c->autocommit_work);
+
+	if (!c->failed) {
+		c->cct->entries[c->cc_txc & 0xffff] = cpu_to_le64(le64_to_cpup(&c->cct->entries[c->cc_txc & 0xffff]) - 0x10000);
+		c->sb->cc = cpu_to_le16(le16_to_cpup(&c->sb->cc) - 1);
+		c->cc_txc -= 0x10000;
+
+		r = dm_compress_sync_rw_metadata(c, REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA, DM_IO_KMEM, 0, c->sb, SB_SECTORS);
+		if (unlikely(r)) {
+			dm_compress_error(c, "Error writing superblock", r);
+			return;
+		}
+	}
+}
+
+static void dm_compress_status(struct dm_target *ti, status_type_t type,
+			       unsigned int status_flags, char *result, unsigned int maxlen)
+{
+	struct dm_compress *c = ti->private;
+	size_t sz = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO: {
+		DMEMIT("%llu %llu",
+			(unsigned long long)c->n_blocks,
+			(unsigned long long)atomic64_read(&c->free_blocks));
+		break;
+	}
+
+	case STATUSTYPE_TABLE: {
+		unsigned arg_count;
+		DMEMIT("%s", c->dev->name);
+		DMEMIT(" %llu", (unsigned long long)c->start);
+		DMEMIT(" %u", 512U << c->log2_sectors_per_block);
+		DMEMIT(" %u", 512U << c->log2_sectors_per_chunk);
+		DMEMIT(" %llu", (unsigned long long)c->n_chunks);
+		DMEMIT(" %s", dm_compress_algorithms[c->algorithm].name);
+		arg_count = 0;
+		arg_count += !!c->meta_dev;
+		arg_count += c->n_cached_chunks != N_CACHED_CHUNKS;
+		arg_count += c->autocommit_set;
+		DMEMIT(" %u", arg_count);
+		if (c->meta_dev)
+			DMEMIT(" meta_device:%s", c->meta_dev->name);
+		if (c->n_cached_chunks != N_CACHED_CHUNKS)
+			DMEMIT(" n_cached_chunks:%u", c->n_cached_chunks);
+		if (c->autocommit_set)
+			DMEMIT(" commit_time:%u", c->autocommit_msec);
+		break;
+	}
+
+	case STATUSTYPE_IMA:
+		break;
+	}
+}
+
+static void dm_compress_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	struct dm_compress *c = ti->private;
+	limits->io_min = 512U << c->log2_sectors_per_chunk;
+	limits->io_opt = 512U << c->log2_sectors_per_chunk;
+	limits->discard_granularity = 512U << c->log2_sectors_per_chunk;
+	limits->max_hw_discard_sectors = limits->discard_granularity >> SECTOR_SHIFT;
+}
+
+static struct target_type compress_target = {
+	.name			= "compress",
+	.version		= {1, 0, 0},
+	.module			= THIS_MODULE,
+	.features		= 0,
+	.ctr			= dm_compress_ctr,
+	.dtr			= dm_compress_dtr,
+	.map			= dm_compress_map,
+	.preresume		= dm_compress_preresume,
+	.postsuspend		= dm_compress_postsuspend,
+	.status			= dm_compress_status,
+	.io_hints		= dm_compress_io_hints,
+};
+
+static int __init dm_compress_init(void)
+{
+	int r;
+
+	r = dm_register_target(&compress_target);
+	if (r < 0)
+		goto bad;
+
+	return 0;
+
+bad:
+	return r;
+}
+
+static void __exit dm_compress_exit(void)
+{
+	dm_unregister_target(&compress_target);
+}
+
+module_init(dm_compress_init);
+module_exit(dm_compress_exit);
+
+MODULE_AUTHOR("Mikulas Patocka");
+MODULE_DESCRIPTION(DM_NAME " target for transparent data compression");
+MODULE_LICENSE("GPL");
Index: linux-2.6/drivers/md/Makefile
===================================================================
--- linux-2.6.orig/drivers/md/Makefile
+++ linux-2.6/drivers/md/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_DM_INTEGRITY)	+= dm-integri
 obj-$(CONFIG_DM_ZONED)		+= dm-zoned.o
 obj-$(CONFIG_DM_WRITECACHE)	+= dm-writecache.o
 obj-$(CONFIG_SECURITY_LOADPIN_VERITY)	+= dm-verity-loadpin.o
+obj-$(CONFIG_DM_COMPRESS)	+= dm-compress/
 
 ifeq ($(CONFIG_DM_INIT),y)
 dm-mod-objs			+= dm-init.o
Index: linux-2.6/drivers/md/dm-compress/Makefile
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-compress/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_DM_COMPRESS) += dm-compress.o
+
+dm-compress-objs := \
+	algorithms.o \
+	alloc.o \
+	cc.o \
+	chunk.o \
+	io.o \
+	target.o
Index: linux-2.6/drivers/md/dm-compress/alloc.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-compress/alloc.c
@@ -0,0 +1,505 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2026 Mikulas Patocka
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-compress.h"
+
+static int prepare_bitmap(struct dm_compress *c, sector_t bmp_block, __u64 **working_copy, __u64 **stable_copy, struct dm_buffer **bp)
+{
+	struct bitmap *bmp;
+	bool idx;
+
+	bmp = dm_bufio_read(c->bufio, bmp_block, bp);
+	if (IS_ERR(bmp)) {
+		dm_compress_error(c, "Error reading bitmap", PTR_ERR(bmp));
+		return PTR_ERR(bmp);
+	}
+	if (unlikely(bmp->magic != BITMAP_MAGIC)) {
+		dm_bufio_release(*bp);
+		dm_compress_error(c, "Bitmap magic doesn't match", -EUCLEAN);
+		return -EUCLEAN;
+	}
+	idx = !CC_VALID(c, &bmp->cc_txc);
+	if (CC_CURRENT(c, &bmp->cc_txc)) {
+		if (idx)
+			*working_copy = bmp->bmp1, *stable_copy = bmp->bmp2;
+		else
+			*working_copy = bmp->bmp2, *stable_copy = bmp->bmp1;
+	} else {
+		if (idx)
+			*working_copy = *stable_copy = bmp->bmp1;
+		else
+			*working_copy = *stable_copy = bmp->bmp2;
+	}
+	return 0;
+}
+
+static void modify_bitmap(struct dm_compress *c, __u64 **working_copy, struct dm_buffer *bp)
+{
+	struct bitmap *bmp = dm_bufio_get_block_data(bp);
+	bool idx;
+	idx = !CC_VALID(c, &bmp->cc_txc);
+	if (unlikely(!CC_CURRENT(c, &bmp->cc_txc))) {
+		CC_SET_CURRENT(c, &bmp->cc_txc);
+		//WARN_ON(idx != CC_VALID(c, &bmp->cc_txc));
+		if (!idx)
+			memcpy(bmp->bmp1, bmp->bmp2, BITS_PER_BITMAP / 8);
+		else
+			memcpy(bmp->bmp2, bmp->bmp1, BITS_PER_BITMAP / 8);
+		idx = !idx;
+		dm_bufio_mark_buffer_dirty(bp);
+	}
+	if (idx)
+		*working_copy = bmp->bmp1;
+	else
+		*working_copy = bmp->bmp2;
+}
+
+static bool verify_bmp_dir_magic(struct dm_compress *c, struct directory *dir, sector_t index)
+{
+	if (unlikely(dir->magic != BMP_DIR_MAGIC)) {
+		dm_compress_error(c, "Bitmap directory magic doesn't match", -EUCLEAN);
+		return false;
+	}
+	if (unlikely(le64_to_cpu(dir->index) != index)) {
+		dm_compress_error(c, "Bitmap directory index doesn't match", -EUCLEAN);
+		return false;
+	}
+	return true;
+}
+
+sector_t dm_compress_allocate_space(struct dm_compress *c, sector_t preferred_block, unsigned n_blocks)
+{
+	struct dm_buffer *bp;
+	size_t group_ptr, dir_ptr;
+	unsigned dir_offset, bmp_offset;
+	sector_t dir_block, bmp_block;
+	struct block_group_descriptor *group;
+	struct directory *dir;
+	__u64 *working_copy, *stable_copy;
+	unsigned bit;
+	size_t n_retries = 0;
+
+	if (unlikely(n_blocks > BITS_PER_BITMAP)) {
+		dm_compress_error(c, "Attempting to allocate too much space", -EUCLEAN);
+		return ALLOCATE_ERROR;
+	}
+
+try_next_bitmap:
+	if (unlikely(preferred_block >= c->n_blocks))
+		preferred_block = 0;
+
+	block_location(c, preferred_block, &group_ptr, &dir_ptr, &dir_offset, &bmp_offset);
+	group = &c->groups[group_ptr];
+	dir_block = c->block_directories[dir_ptr];
+	preferred_block -= bmp_offset;
+
+	dir = dm_bufio_read(c->bufio, dir_block, &bp);
+	if (IS_ERR(dir)) {
+		dm_compress_error(c, "Error reading bitmap directory", PTR_ERR(dir));
+		return ALLOCATE_ERROR;
+	}
+	if (unlikely(!verify_bmp_dir_magic(c, dir, dir_ptr))) {
+		dm_bufio_release(bp);
+		return ALLOCATE_ERROR;
+	}
+	bmp_block = READ_PTR(&dir->ptr[dir_offset]);
+	dm_bufio_release(bp);
+
+	mutex_lock(&group->mutex);
+	if (unlikely(prepare_bitmap(c, bmp_block, &working_copy, &stable_copy, &bp))) {
+		mutex_unlock(&group->mutex);
+		return ALLOCATE_ERROR;
+	}
+
+find_again:
+	bit = find_next_zero_bit_le(working_copy, BITS_PER_BITMAP, bmp_offset);
+	if (bit <= BITS_PER_BITMAP - n_blocks) {
+		unsigned i;
+		for (i = n_blocks; i--; ) {
+			if (test_bit_le(bit + i, working_copy) || test_bit_le(bit + i, stable_copy)) {
+				bmp_offset = bit + i + 1;
+				goto find_again;
+			}
+		}
+		modify_bitmap(c, &working_copy, bp);
+		for (i = 0; i < n_blocks; i++) {
+			__set_bit_le(bit + i, working_copy);
+		}
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+		mutex_unlock(&group->mutex);
+
+		atomic64_sub(n_blocks, &c->free_blocks);
+
+		return preferred_block + bit;
+	}
+
+	dm_bufio_release(bp);
+	mutex_unlock(&group->mutex);
+
+	if (++n_retries <= c->n_groups) {
+		preferred_block += BITS_PER_BITMAP;
+		goto try_next_bitmap;
+	}
+
+	return ALLOCATE_NO_SPACE;
+}
+
+void dm_compress_free_space(struct dm_compress *c, sector_t block, unsigned n_blocks)
+{
+	struct dm_buffer *bp;
+	size_t group_ptr, dir_ptr;
+	unsigned dir_offset, bmp_offset;
+	sector_t dir_block, bmp_block;
+	struct block_group_descriptor *group;
+	struct directory *dir;
+	__u64 *working_copy, *stable_copy;
+	sector_t start_block = block;
+
+	if (unlikely(block + n_blocks < block) ||
+	    unlikely(block + n_blocks > c->n_blocks)) {
+		dm_compress_error(c, "Freeing invalid range", -EUCLEAN);
+		return;
+	}
+
+	while (n_blocks) {
+		block_location(c, block, &group_ptr, &dir_ptr, &dir_offset, &bmp_offset);
+		group = &c->groups[group_ptr];
+		dir_block = c->block_directories[dir_ptr];
+
+		dir = dm_bufio_read(c->bufio, dir_block, &bp);
+		if (IS_ERR(dir)) {
+			dm_compress_error(c, "Error reading bitmap directory", PTR_ERR(dir));
+			goto ret;
+		}
+		if (unlikely(!verify_bmp_dir_magic(c, dir, dir_ptr))) {
+			dm_bufio_release(bp);
+			goto ret;
+		}
+		bmp_block = READ_PTR(&dir->ptr[dir_offset]);
+		dm_bufio_release(bp);
+
+		mutex_lock(&group->mutex);
+		if (unlikely(prepare_bitmap(c, bmp_block, &working_copy, &stable_copy, &bp))) {
+			mutex_unlock(&group->mutex);
+			goto ret;
+		}
+		modify_bitmap(c, &working_copy, bp);
+		while (n_blocks && bmp_offset < BITS_PER_BITMAP) {
+			if (!__test_and_clear_bit_le(bmp_offset, working_copy)) {
+				dm_compress_error(c, "Bitmap bit is already cleared", -EUCLEAN);
+				dm_bufio_mark_buffer_dirty(bp);
+				dm_bufio_release(bp);
+				mutex_unlock(&group->mutex);
+				goto ret;
+			}
+			bmp_offset++;
+			block++;
+			n_blocks--;
+		}
+
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+		mutex_unlock(&group->mutex);
+	}
+ret:
+	atomic64_add(block - start_block, &c->free_blocks);
+}
+
+int dm_compress_get_free_space(struct dm_compress *c)
+{
+	sector_t block = 0;
+	sector_t free_blocks = 0;
+	while (block < c->n_blocks) {
+		size_t group_ptr, dir_ptr;
+		unsigned dir_offset, bmp_offset;
+		sector_t dir_block, bmp_block;
+		struct dm_buffer *bp;
+		struct directory *dir;
+		struct bitmap *bmp;
+		bool idx;
+		__u64 *bmp_data;
+
+		block_location(c, block, &group_ptr, &dir_ptr, &dir_offset, &bmp_offset);
+		dir_block = c->block_directories[dir_ptr];
+
+		dir = dm_bufio_read(c->bufio, dir_block, &bp);
+		if (IS_ERR(dir)) {
+			dm_compress_error(c, "Error reading bitmap directory", PTR_ERR(dir));
+			return PTR_ERR(dir);
+		}
+		if (unlikely(!verify_bmp_dir_magic(c, dir, dir_ptr))) {
+			dm_bufio_release(bp);
+			return -EUCLEAN;
+		}
+		bmp_block = READ_PTR(&dir->ptr[dir_offset]);
+		dm_bufio_release(bp);
+
+		bmp = dm_bufio_read(c->bufio, bmp_block, &bp);
+		if (IS_ERR(bmp)) {
+			dm_compress_error(c, "Error reading bitmap", PTR_ERR(bmp));
+			return PTR_ERR(bmp);
+		}
+		if (unlikely(bmp->magic != BITMAP_MAGIC)) {
+			dm_bufio_release(bp);
+			dm_compress_error(c, "Bitmap magic doesn't match when calculating free space", -EUCLEAN);
+			return -EUCLEAN;
+		}
+		idx = !CC_VALID(c, &bmp->cc_txc);
+		if (idx)
+			bmp_data = bmp->bmp1;
+		else
+			bmp_data = bmp->bmp2;
+		free_blocks += BITS_PER_BITMAP - bitmap_weight((void *)bmp_data, BITS_PER_BITMAP);
+		dm_bufio_release(bp);
+
+		block += BITS_PER_BITMAP;
+	}
+
+	atomic64_set(&c->free_blocks, free_blocks);
+
+	return 0;
+}
+
+struct chunk_ptr *dm_compress_prepare_chunk(struct dm_compress *c, sector_t chunk, struct dm_buffer **bp)
+{
+	struct dm_buffer *dbp;
+	size_t dir_ptr;
+	unsigned dir_offset, chunk_offset;
+	sector_t dir_block, chunk_block;
+	struct directory *dir;
+	struct chunk_entries *chunks;
+	struct chunk_entry *ce;
+	bool idx;
+
+	chunk_location(c, chunk, &dir_ptr, &dir_offset, &chunk_offset);
+
+	dir_block = c->chunk_directories[dir_ptr];
+
+	dir = dm_bufio_read(c->bufio, dir_block, &dbp);
+	if (IS_ERR(dir)) {
+		dm_compress_error(c, "Error reading chunk directory", PTR_ERR(dir));
+		return NULL;
+	}
+	if (unlikely(dir->magic != CHUNK_DIR_MAGIC)) {
+		dm_bufio_release(dbp);
+		dm_compress_error(c, "Chunk directory magic doesn't match", -EUCLEAN);
+		return NULL;
+	}
+	chunk_block = READ_PTR(&dir->ptr[dir_offset]);
+	dm_bufio_release(dbp);
+
+	chunks = dm_bufio_read(c->bufio, chunk_block, bp);
+	if (IS_ERR(chunks)) {
+		dm_compress_error(c, "Error reading chunk block", PTR_ERR(chunks));
+		return NULL;
+	}
+	if (unlikely(chunks->magic != CHUNKS_MAGIC)) {
+		dm_bufio_release(*bp);
+		dm_compress_error(c, "Chunks magic doesn't match", -EUCLEAN);
+		return NULL;
+	}
+	ce = &chunks->chunk[chunk_offset];
+
+	idx = !CC_VALID(c, &ce->cc_txc);
+	if (unlikely(!CC_CURRENT(c, &ce->cc_txc))) {
+		CC_SET_CURRENT(c, &ce->cc_txc);
+		WARN_ON(idx != CC_VALID(c, &ce->cc_txc));
+		ce->ptr[idx] = ce->ptr[!idx];
+		idx = !idx;
+		dm_bufio_mark_buffer_dirty(*bp);
+	}
+	return &ce->ptr[!idx];
+}
+
+int dm_compress_resize_bitmaps(struct dm_compress *c, sector_t current_size, sector_t new_size, bool *need_sync)
+{
+	struct superblock *sb = c->sb;
+	int r;
+	sector_t allocated_sector = 0;
+	sector_t n_allocated_sectors = 0;
+	bool did_something = false;
+	if (c->meta_dev) {
+		sector_t meta_size;
+		bool b;
+		b = !CC_VALID(c, &sb->n_cc_txc);
+		allocated_sector = le64_to_cpu(sb->n_used_metadata_blocks[b]) * BUFFER_SECTORS;
+		meta_size = bdev_nr_sectors(c->meta_dev->bdev);
+		if (meta_size < c->start) {
+			dm_compress_error(c, "The metadata device is too small", -ENOSPC);
+			return -ENOSPC;
+		}
+		meta_size -= c->start;
+		if (meta_size < allocated_sector) {
+			dm_compress_error(c, "The metadata device is too small", -ENOSPC);
+			return -ENOSPC;
+		}
+		n_allocated_sectors = meta_size - allocated_sector;
+	}
+	while (current_size < new_size) {
+		struct dm_buffer *bp;
+		size_t group_ptr, dir_ptr;
+		unsigned dir_offset, bmp_offset;
+		sector_t dir_block, bmp_block;
+		struct directory *dir;
+		__u64 *working_copy, *stable_copy;
+		unsigned need_sectors;
+
+		block_location(c, current_size, &group_ptr, &dir_ptr, &dir_offset, &bmp_offset);
+
+		need_sectors = 0;
+		if (!bmp_offset && !dir_offset)
+			need_sectors = BUFFER_SECTORS * 2;
+		else if (!bmp_offset)
+			need_sectors = BUFFER_SECTORS;
+		if (n_allocated_sectors < need_sectors) {
+			sector_t existing_size;
+			if (c->meta_dev) {
+				dm_compress_error(c, "The metadata device is too small", -ENOSPC);
+				return -ENOSPC;
+			}
+			existing_size = current_size;
+align_allocated:
+			allocated_sector = current_size << c->log2_sectors_per_block;
+			n_allocated_sectors = 0;
+			if (allocated_sector & (BUFFER_SECTORS - 1)) {
+				if (current_size >= new_size) {
+					current_size = existing_size;
+					goto finish;
+				}
+				current_size++;
+				goto align_allocated;
+			}
+			while (n_allocated_sectors < need_sectors) {
+				if (current_size >= new_size) {
+					current_size = existing_size;
+					goto finish;
+				}
+				current_size++;
+				n_allocated_sectors += 1 << c->log2_sectors_per_block;
+			}
+		}
+
+		did_something = true;
+		if (!bmp_offset && !dir_offset) {
+			dir = dm_bufio_new(c->bufio, allocated_sector / BUFFER_SECTORS, &bp);
+			if (IS_ERR(dir)) {
+				dm_compress_error(c, "Unable to create a bitmap directory", PTR_ERR(dir));
+				return PTR_ERR(dir);
+			}
+			memset(dir, 0, BUFFER_SIZE);
+			dir->magic = BMP_DIR_MAGIC;
+			dir->index = cpu_to_le64(dir_ptr);
+			dm_bufio_mark_buffer_dirty(bp);
+			dm_bufio_release(bp);
+			c->block_directories[dir_ptr] = allocated_sector / BUFFER_SECTORS;
+			dir = dm_bufio_read(c->bufio, c->block_directories[dir_ptr - 1], &bp);
+			if (IS_ERR(dir)) {
+				dm_compress_error(c, "Error reading bitmap directory", PTR_ERR(dir));
+				return PTR_ERR(dir);
+			}
+			if (unlikely(!verify_bmp_dir_magic(c, dir, dir_ptr - 1))) {
+				dm_bufio_release(bp);
+				return -EUCLEAN;
+			}
+			WRITE_PTR(&dir->next, allocated_sector / BUFFER_SECTORS);
+			dm_bufio_mark_buffer_dirty(bp);
+			dm_bufio_release(bp);
+			allocated_sector += BUFFER_SECTORS;
+			n_allocated_sectors -= BUFFER_SECTORS;
+		}
+		if (!bmp_offset) {
+			struct bitmap *bmp;
+			bmp = dm_bufio_new(c->bufio, allocated_sector / BUFFER_SECTORS, &bp);
+			if (IS_ERR(bmp)) {
+				dm_compress_error(c, "Unable to create a bitmap", PTR_ERR(bmp));
+				return PTR_ERR(bmp);
+			}
+			memset(bmp, 0xff, BUFFER_SIZE);
+			bmp->magic = BITMAP_MAGIC;
+			bmp->cc_txc = cpu_to_le64(0);
+			CC_SET_CURRENT(c, &bmp->cc_txc);
+			dm_bufio_mark_buffer_dirty(bp);
+			dm_bufio_release(bp);
+
+			dir_block = c->block_directories[dir_ptr];
+			dir = dm_bufio_read(c->bufio, dir_block, &bp);
+			if (IS_ERR(dir)) {
+				dm_compress_error(c, "Error reading bitmap directory", PTR_ERR(dir));
+				return PTR_ERR(dir);
+			}
+			if (unlikely(!verify_bmp_dir_magic(c, dir, dir_ptr))) {
+				dm_bufio_release(bp);
+				return -EUCLEAN;
+			}
+			WRITE_PTR(&dir->ptr[dir_offset], allocated_sector / BUFFER_SECTORS);
+			dm_bufio_mark_buffer_dirty(bp);
+			dm_bufio_release(bp);
+			allocated_sector += BUFFER_SECTORS;
+			n_allocated_sectors -= BUFFER_SECTORS;
+		}
+
+		block_location(c, current_size, &group_ptr, &dir_ptr, &dir_offset, &bmp_offset);
+
+		dir_block = c->block_directories[dir_ptr];
+		dir = dm_bufio_read(c->bufio, dir_block, &bp);
+		if (IS_ERR(dir)) {
+			dm_compress_error(c, "Error reading bitmap directory", PTR_ERR(dir));
+			return PTR_ERR(dir);
+		}
+		if (unlikely(!verify_bmp_dir_magic(c, dir, dir_ptr))) {
+			dm_bufio_release(bp);
+			return -EUCLEAN;
+		}
+		bmp_block = READ_PTR(&dir->ptr[dir_offset]);
+		dm_bufio_release(bp);
+
+		r = prepare_bitmap(c, bmp_block, &working_copy, &stable_copy, &bp);
+		if (r)
+			return r;
+		modify_bitmap(c, &working_copy, bp);
+
+		while (current_size < new_size && bmp_offset < BITS_PER_BITMAP) {
+			if (!__test_and_clear_bit_le(bmp_offset, working_copy)) {
+				dm_compress_error(c, "Bitmap bit is already cleared", -EUCLEAN);
+				dm_bufio_mark_buffer_dirty(bp);
+				dm_bufio_release(bp);
+				return -EUCLEAN;
+			}
+			bmp_offset++;
+			current_size++;
+		}
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+	}
+
+finish:
+	if (did_something) {
+		bool b;
+		*need_sync = true;
+		b = !CC_VALID(c, &sb->n_cc_txc);
+		if (unlikely(!CC_CURRENT(c, &sb->n_cc_txc))) {
+			CC_SET_CURRENT(c, &sb->n_cc_txc);
+			WARN_ON(b != CC_VALID(c, &sb->n_cc_txc));
+			sb->n_blocks[!b] = sb->n_blocks[b];
+			sb->n_chunks[!b] = sb->n_chunks[b];
+			sb->n_used_metadata_blocks[!b] = sb->n_used_metadata_blocks[b];
+			b = !b;
+		}
+		sb->n_blocks[b] = cpu_to_le64(current_size);
+		if (c->meta_dev)
+			sb->n_used_metadata_blocks[b] = cpu_to_le64(allocated_sector / BUFFER_SECTORS);
+		r = dm_compress_sync_rw_metadata(c, REQ_OP_WRITE, DM_IO_KMEM, 0, c->sb, SB_SECTORS);
+		if (r) {
+			dm_compress_error(c, "Error writing superblock", r);
+			return r;
+		}
+		c->n_blocks = current_size;
+	}
+	return 0;
+}
Index: linux-2.6/drivers/md/dm-compress/cc.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-compress/cc.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2026 Mikulas Patocka
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-compress.h"
+
+struct cached_chunk *dm_compress_alloc_cached_chunk(struct dm_compress *c)
+{
+	struct cached_chunk *cc;
+	unsigned short v;
+	struct bio_vec *bv;
+	unsigned i;
+
+	cc = kzalloc(sizeof(struct cached_chunk) + (1U << c->log2_sectors_per_chunk), GFP_KERNEL);
+	if (!cc)
+		return NULL;
+
+	cc->c = c;
+
+	cc->uncompressed_data = __vmalloc(512UL << c->log2_sectors_per_chunk, GFP_KERNEL);
+	if (!cc->uncompressed_data)
+		goto free_fail;
+
+	cc->compressed_data = __vmalloc(512UL << c->log2_sectors_per_chunk, GFP_KERNEL);
+	if (!cc->compressed_data)
+		goto free_fail;
+
+	cc->merging_data = __vmalloc(512UL << c->log2_sectors_per_chunk, GFP_KERNEL);
+	if (!cc->merging_data)
+		goto free_fail;
+
+	if (is_vmalloc_addr(cc->compressed_data)) {
+		cc->bio_vectors = DIV_ROUND_UP(512UL << c->log2_sectors_per_chunk, PAGE_SIZE);
+		cc->bio = bio_kmalloc(cc->bio_vectors, GFP_KERNEL);
+		if (!cc->bio)
+			goto free_fail;
+		bv = bio_inline_vecs(cc->bio);
+		for (v = 0; v < cc->bio_vectors; v++) {
+			bv[v].bv_page = vmalloc_to_page(cc->compressed_data + (size_t)v * PAGE_SIZE);
+			bv[v].bv_len = PAGE_SIZE;
+			bv[v].bv_offset = 0;
+		}
+	} else {
+		cc->bio_vectors = 1;
+		cc->bio = bio_kmalloc(cc->bio_vectors, GFP_KERNEL);
+		if (!cc->bio)
+			goto free_fail;
+		bv = bio_inline_vecs(cc->bio);
+		bv[0].bv_page = virt_to_page(cc->compressed_data);
+		bv[0].bv_len = 512UL << c->log2_sectors_per_chunk;
+		bv[0].bv_offset = 0;
+	}
+
+	for (i = 0; i < DM_COMPRESS_N_ALGORITHMS; i++) {
+		cc->contexts[i] = dm_compress_algorithms[i].allocate_context(GFP_KERNEL);
+		if (!cc->contexts[i])
+			goto free_fail;
+	}
+
+	return cc;
+
+free_fail:
+	dm_compress_free_cached_chunk(cc);
+	return NULL;
+}
+
+void dm_compress_free_cached_chunk(struct cached_chunk *cc)
+{
+	unsigned i;
+	for (i = 0; i < DM_COMPRESS_N_ALGORITHMS; i++)
+		if (cc->contexts[i])
+			dm_compress_algorithms[i].free_context(cc->contexts[i]);
+	kvfree(cc->uncompressed_data);
+	kvfree(cc->compressed_data);
+	kvfree(cc->merging_data);
+	kfree(cc->bio);
+	kfree(cc);
+}
+
+struct cached_chunk *dm_compress_find_cached_chunk(struct dm_compress *c, sector_t chunk, struct cached_chunk *for_insert)
+{
+	struct rb_node *parent = NULL;
+	struct rb_node **node = &c->chunks.rb_node;
+
+	while (*node) {
+		struct cached_chunk *cc = container_of(*node, struct cached_chunk, node);
+		if (cc->chunk == chunk) {
+			list_del(&cc->lru_entry);
+			list_add(&cc->lru_entry, &c->lru);
+			return cc;
+		}
+		parent = &cc->node;
+		if (cc->chunk > chunk)
+			node = &parent->rb_left;
+		else
+			node = &parent->rb_right;
+	}
+
+	if (for_insert) {
+		rb_link_node(&for_insert->node, parent, node);
+		rb_insert_color(&for_insert->node, &c->chunks);
+		list_add(&for_insert->lru_entry, &c->lru);
+		for_insert->in_tree = true;
+	}
+
+	return NULL;
+}
+
+struct cached_chunk *dm_compress_new_cached_chunk(struct dm_compress_io *dio)
+{
+	struct dm_compress *c = dio->c;
+	struct cached_chunk *cc;
+	if (!list_empty(&c->free_chunks)) {
+		cc = list_entry(c->free_chunks.next, struct cached_chunk, lru_entry);
+		list_del(&cc->lru_entry);
+		cc->chunk = dio->chunk;
+		cc->in_tree = false;
+		cc->dirty = false;
+		cc->intent = INTENT_IDLE;
+		cc->failed = 0;
+		memset(cc->sector_tags, 0, 1U << c->log2_sectors_per_chunk);
+		return cc;
+	}
+	return NULL;
+}
+
+void dm_compress_release_cached_chunk(struct cached_chunk *cc)
+{
+	struct dm_compress *c = cc->c;
+	if (cc->in_tree) {
+		rb_erase(&cc->node, &c->chunks);
+		list_del(&cc->lru_entry);
+		cc->in_tree = false;
+	}
+	list_add(&cc->lru_entry, &c->free_chunks);
+}
+
+void dm_compress_wait_for_cached_chunk(struct dm_compress_io *dio)
+{
+	struct dm_compress *c = dio->c;
+	struct rb_node *parent, **node;
+
+	list_add(&dio->waiting_list_entry, &c->waiting_bio_lru);
+
+	parent = NULL;
+	node = &c->waiting_bio_tree.rb_node;
+
+	while (*node) {
+		struct dm_compress_io *tdio = container_of(*node, struct dm_compress_io, tree_entry);
+		parent = &tdio->tree_entry;
+		if (tdio->chunk > dio->chunk) {
+			node = &parent->rb_left;
+		} else {
+			node = &parent->rb_right;
+		}
+	}
+
+	rb_link_node(&dio->tree_entry, parent, node);
+	rb_insert_color(&dio->tree_entry, &c->waiting_bio_tree);
+}
+
+struct dm_compress_io *dm_compress_pick_dio_for_chunk(struct dm_compress *c, sector_t chunk)
+{
+	struct rb_node *node = c->waiting_bio_tree.rb_node;
+
+	while (node) {
+		struct dm_compress_io *tdio = container_of(node, struct dm_compress_io, tree_entry);
+		if (tdio->chunk == chunk) {
+			return tdio;
+		}
+		if (tdio->chunk > chunk)
+			node = tdio->tree_entry.rb_left;
+		else
+			node = tdio->tree_entry.rb_right;
+	}
+
+	return NULL;
+}
+
+struct dm_compress_io *dm_compress_pick_oldest_dio(struct dm_compress *c)
+{
+	struct dm_compress_io *dio;
+
+	if (list_empty(&c->waiting_bio_lru))
+		return NULL;
+
+	dio = list_entry(c->waiting_bio_lru.prev, struct dm_compress_io, waiting_list_entry);
+
+	return dio;
+}
+
+void dm_compress_unlink_dio(struct dm_compress_io *dio)
+{
+	struct dm_compress *c = dio->c;
+	list_del(&dio->waiting_list_entry);
+	rb_erase(&dio->tree_entry, &c->waiting_bio_tree);
+}
+
+bool dm_compress_is_something_in_progress(struct dm_compress *c)
+{
+	bool ret = false;
+	struct cached_chunk *cc;
+	list_for_each_entry(cc, &c->lru, lru_entry) {
+		if (cc->dirty && !c->failed && !cc->failed)
+			dm_compress_enqueue_chunk(cc, INTENT_WRITE);
+		if (cc->intent > INTENT_IDLE)
+			ret = true;
+	}
+	return ret;
+}
Index: linux-2.6/drivers/md/dm-compress/io.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-compress/io.c
@@ -0,0 +1,640 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2026 Mikulas Patocka
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-compress.h"
+
+static bool dm_compress_process_chunk(struct dm_compress_io *dio);
+
+static void dm_compress_chunk_work(struct work_struct *w);
+static void dm_compress_chunk_work_2(struct work_struct *w);
+static void dm_compress_process_pending_ios(struct dm_compress *c);
+
+static void dm_compress_read_and_decompress(struct cached_chunk *cc);
+static void dm_compress_chunk_decompress(struct work_struct *w);
+
+static void dm_compress_process_bios_on_chunk(struct dm_compress *c, sector_t chunk, blk_status_t status);
+
+static void dm_compress_kick_autocommit(struct dm_compress *c);
+
+static struct chunk_entry *map_chunk(struct dm_compress *c, sector_t chunk, struct dm_buffer **bp)
+{
+	size_t dir_ptr;
+	unsigned dir_offset, chunk_offset;
+	struct directory *dir;
+	sector_t ptr;
+	struct chunk_entries *chunks;
+
+	chunk_location(c, chunk, &dir_ptr, &dir_offset, &chunk_offset);
+
+	dir = dm_bufio_read(c->bufio, c->chunk_directories[dir_ptr], bp);
+	if (unlikely(IS_ERR(dir)))
+		return (void *)dir;
+	if (unlikely(dir->magic != CHUNK_DIR_MAGIC)) {
+		dm_bufio_release(*bp);
+		dm_compress_error(c, "Chunk directory magic doesn't match", -EUCLEAN);
+		return ERR_PTR(-EUCLEAN);
+	}
+	if (unlikely(le64_to_cpu(dir->index) != dir_ptr)) {
+		dm_bufio_release(*bp);
+		dm_compress_error(c, "Chunk directory index doesn't match", -EUCLEAN);
+		return ERR_PTR(-EUCLEAN);
+	}
+	ptr = READ_PTR(&dir->ptr[dir_offset]);
+	dm_bufio_release(*bp);
+
+	chunks = dm_bufio_read(c->bufio, ptr, bp);
+	if (unlikely(IS_ERR(chunks)))
+		return (void *)chunks;
+	if (unlikely(chunks->magic != CHUNKS_MAGIC)) {
+		dm_bufio_release(*bp);
+		dm_compress_error(c, "Chunks magic doesn't match", -EUCLEAN);
+		return ERR_PTR(-EUCLEAN);
+	}
+
+	return &chunks->chunk[chunk_offset];
+}
+
+void dm_compress_enqueue_chunk(struct cached_chunk *cc, unsigned intent)
+{
+	unsigned old_intent = cc->intent;
+	cc->intent = max(cc->intent, intent);
+	if (old_intent == INTENT_IDLE) {
+		INIT_WORK(&cc->work, dm_compress_chunk_work);
+		queue_work(cc->c->compress_wq, &cc->work);
+	}
+}
+
+static void dm_compress_setup_flush(struct dm_compress_io *dio)
+{
+	dio->is_flush = true;
+	dio->chunk = 0;
+	dio->offset_in_chunk = 0;
+}
+
+static void dm_compress_endio(struct bio *bio)
+{
+	blk_opf_t opf = bio->bi_opf;
+#ifdef TEST_FUA
+	if (get_random_u8() & 1)
+		opf |= REQ_FUA;
+#endif
+	if (unlikely(opf & REQ_FUA) &&
+	    likely(bio->bi_status == BLK_STS_OK)) {
+		struct dm_compress_io *dio = dm_per_bio_data(bio, sizeof(struct dm_compress_io));
+		if (!dio->is_flush) {
+			dm_compress_setup_flush(dio);
+			INIT_WORK(&dio->work, dm_compress_work);
+			queue_work(dio->c->wq, &dio->work);
+			return;
+		}
+	}
+	bio_endio(bio);
+}
+
+int dm_compress_map(struct dm_target *ti, struct bio *bio)
+{
+	struct dm_compress *c = ti->private;
+	struct dm_compress_io *dio = dm_per_bio_data(bio, sizeof(struct dm_compress_io));
+	sector_t logical_sector;
+	dio->c = c;
+
+	if (unlikely(c->failed)) {
+		bio->bi_status = errno_to_blk_status(c->failed);
+		bio_endio(bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
+		dm_compress_setup_flush(dio);
+	} else {
+		dio->is_flush = false;
+		logical_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
+		dio->chunk = logical_sector >> c->log2_sectors_per_chunk;
+		dio->offset_in_chunk = logical_sector & ((1U << c->log2_sectors_per_chunk) - 1);
+
+		if (dio->chunk >= c->n_chunks)
+			return DM_MAPIO_KILL;
+	}
+
+	if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
+		if (unlikely(WARN_ON(dio->offset_in_chunk + bio_sectors(bio) > 1U << c->log2_sectors_per_chunk))) {
+			return DM_MAPIO_KILL;
+		}
+	}
+
+	INIT_WORK(&dio->work, dm_compress_work);
+	queue_work(c->wq, &dio->work);
+	return DM_MAPIO_SUBMITTED;
+}
+
+void dm_compress_work(struct work_struct *w)
+{
+	struct dm_compress_io *dio = container_of(w, struct dm_compress_io, work);
+	struct dm_compress *c = dio->c;
+	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_compress_io));
+	bool ret;
+
+	mutex_lock(&c->mutex);
+	ret = dm_compress_process_chunk(dio);
+	if (!ret)
+		dm_compress_wait_for_cached_chunk(dio);
+	mutex_unlock(&c->mutex);
+
+	if (ret)
+		dm_compress_endio(bio);
+}
+
+static bool dm_compress_process_chunk(struct dm_compress_io *dio)
+{
+	struct dm_compress *c = dio->c;
+	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_compress_io));
+	struct cached_chunk *cc;
+	struct chunk_entry *ce;
+	struct dm_buffer *bp;
+	struct chunk_ptr *cp;
+
+	if (unlikely(c->failed)) {
+		bio->bi_status = errno_to_blk_status(c->failed);
+		return true;
+	}
+
+	if (unlikely(dio->is_flush)) {
+		if (dm_compress_is_something_in_progress(c))
+			return false;
+		dm_compress_sync(c);
+		if (unlikely(c->failed))
+			bio->bi_status = errno_to_blk_status(c->failed);
+		return true;
+	}
+
+	if (bio_op(bio) == REQ_OP_WRITE || bio_op(bio) == REQ_OP_DISCARD) {
+		struct dm_compress_io *oldest_dio;
+		if (c->autocommit_active)
+			return false;
+		/*
+		 * Flush waits for all writes to complete. In order to avoid
+		 * starvation of the flush bio, we must not issue new writes if
+		 * a flush is enqueued.
+		 */
+		oldest_dio = dm_compress_pick_oldest_dio(c);
+		if (oldest_dio) {
+			if (unlikely(oldest_dio->is_flush))
+				return false;
+		}
+	}
+
+	cc = dm_compress_find_cached_chunk(c, dio->chunk, NULL);
+	if (cc) {
+		char *data_ptr;
+		unsigned offset;
+		struct bvec_iter iter;
+		struct bio_vec bv;
+have_cached_chunk:
+		if (bio_op(bio) == REQ_OP_READ) {
+			if (unlikely(cc->failed)) {
+				bio->bi_status = errno_to_blk_status(cc->failed);
+				return true;
+			}
+		} else {
+			if (cc->intent > INTENT_IDLE)
+				return false;
+			if (unlikely(cc->failed)) {
+				cc->dirty = false;
+				cc->failed = 0;
+				memset(cc->sector_tags, 0, 1U << c->log2_sectors_per_chunk);
+			}
+		}
+
+		if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
+			data_ptr = cc->uncompressed_data + (dio->offset_in_chunk << SECTOR_SHIFT);
+			if (!memchr(cc->sector_tags + dio->offset_in_chunk, 0, bio_sectors(bio)) &&
+			    mem_is_zero(data_ptr, bio->bi_iter.bi_size))
+				return true;
+			memset(data_ptr, 0, bio->bi_iter.bi_size);
+			memset(cc->sector_tags + dio->offset_in_chunk, TAG_WRITTEN, bio_sectors(bio));
+			cc->dirty = true;
+			goto enqueue_if_full;
+		}
+
+		data_ptr = cc->uncompressed_data + (dio->offset_in_chunk << SECTOR_SHIFT);
+		offset = dio->offset_in_chunk;
+		bio_for_each_segment(bv, bio, iter) {
+			char *mem = bvec_kmap_local(&bv);
+			if (bio_op(bio) == REQ_OP_READ) {
+				if (memchr(cc->sector_tags + offset, 0, bv.bv_len >> SECTOR_SHIFT)) {
+					kunmap_local(mem);
+					dm_compress_enqueue_chunk(cc, INTENT_READ);
+					return false;
+				}
+				memcpy(mem, data_ptr, bv.bv_len);
+				flush_dcache_page(bv.bv_page);
+			} else {
+				flush_dcache_page(bv.bv_page);
+				memcpy(data_ptr, mem, bv.bv_len);
+				memset(cc->sector_tags + offset, TAG_WRITTEN, bv.bv_len >> SECTOR_SHIFT);
+				cc->dirty = true;
+			}
+			kunmap_local(mem);
+			data_ptr += bv.bv_len;
+			offset += bv.bv_len >> SECTOR_SHIFT;
+		}
+		if (bio_op(bio) == REQ_OP_WRITE) {
+enqueue_if_full:
+			if (!memchr_inv(cc->sector_tags, TAG_WRITTEN, 1U << c->log2_sectors_per_chunk)) {
+				dm_compress_enqueue_chunk(cc, INTENT_FREE);
+			}
+			dm_compress_kick_autocommit(c);
+		}
+		return true;
+	}
+
+	ce = map_chunk(c, dio->chunk, &bp);
+	if (unlikely(IS_ERR(ce))) {
+		bio->bi_status = errno_to_blk_status(PTR_ERR(ce));
+		return true;
+	}
+	cp = &ce->ptr[CC_VALID(c, &ce->cc_txc)];
+	if (cp->algorithm == ALGORITHM_ZERO) {
+		if (bio_op(bio) == REQ_OP_READ) {
+			dm_bufio_release(bp);
+			zero_fill_bio(bio);
+			return true;
+		}
+		if (bio_op(bio) == REQ_OP_DISCARD) {
+			dm_bufio_release(bp);
+			return true;
+		}
+	}
+	dm_bufio_release(bp);
+
+	cc = dm_compress_new_cached_chunk(dio);
+	if (cc) {
+		struct cached_chunk *qc = dm_compress_find_cached_chunk(c, dio->chunk, cc);
+		if (unlikely(qc != NULL)) {
+			dm_compress_release_cached_chunk(cc);
+			cc = qc;
+			goto have_cached_chunk;
+		}
+		goto have_cached_chunk;
+	}
+
+	cc = list_entry(c->lru.prev, struct cached_chunk, lru_entry);
+	dm_compress_enqueue_chunk(cc, INTENT_FREE);
+	return false;
+}
+
+static void dm_compress_chunk_work(struct work_struct *w)
+{
+	struct cached_chunk *cc = container_of(w, struct cached_chunk, work);
+	struct dm_compress *c = cc->c;
+	unsigned len_in, len_out, len_compressed, trailing_space;
+	int ret;
+	sector_t preferred_block;
+	struct dm_buffer *bp;
+	struct chunk_ptr *cp;
+	struct chunk_ptr old_cp, new_cp;
+
+	init_completion(&cc->completion);
+
+	if (memchr(cc->sector_tags, 0, 1U << c->log2_sectors_per_chunk)) {
+		dm_compress_read_and_decompress(cc);
+		return;
+	}
+
+	mutex_lock(&c->mutex);
+	if (cc->intent == INTENT_READ) {
+		cc->intent = INTENT_IDLE;
+		dm_compress_process_bios_on_chunk(c, cc->chunk, BLK_STS_OK);
+		return;
+	}
+	if (!cc->dirty) {
+		mutex_unlock(&c->mutex);
+		complete(&cc->completion);
+		dm_compress_chunk_work_2(&cc->work);
+		return;
+	}
+	cc->dirty = false;
+	if (unlikely(cc->failed)) {
+		dm_compress_error(c, "Could not write failed chunk", cc->failed);
+		mutex_unlock(&c->mutex);
+		complete(&cc->completion);
+		dm_compress_chunk_work_2(&cc->work);
+		return;
+	}
+	mutex_unlock(&c->mutex);
+
+	len_in = 512U << c->log2_sectors_per_chunk;
+	len_out = (512U << c->log2_sectors_per_chunk) - (512U << c->log2_sectors_per_block) - 4;
+
+	if (mem_is_zero(cc->uncompressed_data, len_in)) {
+		cc->algorithm = ALGORITHM_ZERO;
+		len_compressed = 0;
+		*(uint32_t *)cc->compressed_data = cpu_to_le32(0);
+		goto skip_compression;
+	}
+
+	cc->algorithm = c->algorithm;
+
+	ret = dm_compress_algorithms[cc->algorithm].compress(cc->contexts[cc->algorithm], cc->uncompressed_data, len_in, cc->compressed_data + 4, len_out);
+
+	/*printk("compressed: %x -> %x\n", len_in, ret);*/
+#ifdef TEST_UNCOMPRESSED_DATA
+	if (get_random_u8() & 1)
+		ret = -EOPNOTSUPP;
+#endif
+	if (unlikely(ret < 0)) {
+		memcpy(cc->compressed_data, cc->uncompressed_data, len_in);
+		cc->algorithm = ALGORITHM_UNCOMPRESSED;
+		len_compressed = len_in;
+	} else {
+		len_compressed = ret;
+		*(uint32_t *)cc->compressed_data = cpu_to_le32(len_compressed);
+		len_compressed += 4;
+#ifdef TEST_MALFORMED_CONTENT
+		((uint8_t *)cc->compressed_data)[4]++;
+#endif
+	}
+
+skip_compression:
+	mutex_lock(&c->mutex);
+
+	trailing_space = -len_compressed & ((512U << c->log2_sectors_per_block) - 1);
+	memset(cc->compressed_data + len_compressed, 0, trailing_space);
+
+	preferred_block = READ_ONCE(c->last_allocated);
+	mutex_unlock(&c->mutex);
+
+	INIT_WORK(&cc->work, dm_compress_chunk_work_2);
+	if (unlikely(!dm_compress_allocate_chunk(cc, preferred_block, &new_cp))) {
+		complete(&cc->completion);
+		dm_compress_chunk_work_2(&cc->work);
+		return;
+	}
+
+	cp = dm_compress_prepare_chunk(c, cc->chunk, &bp);
+	if (unlikely(!cp))
+		goto cont;
+
+	old_cp = *cp;
+	*cp = new_cp;
+
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+
+	dm_compress_release_chunk(c, &old_cp);
+
+cont:
+	complete(&cc->completion);
+}
+
+static void dm_compress_chunk_work_2(struct work_struct *w)
+{
+	struct cached_chunk *cc = container_of(w, struct cached_chunk, work);
+	struct dm_compress *c = cc->c;
+
+	wait_for_completion(&cc->completion);
+
+	mutex_lock(&c->mutex);
+	if (cc->intent >= INTENT_FREE) {
+		dm_compress_release_cached_chunk(cc);
+	} else {
+		cc->intent = INTENT_IDLE;
+	}
+	dm_compress_process_pending_ios(c);
+}
+
+static void dm_compress_process_pending_ios(struct dm_compress *c)
+{
+	struct bio *bio;
+	struct bio_list bio_list;
+	bio_list_init(&bio_list);
+
+	while (true) {
+		sector_t chunk;
+		struct dm_compress_io *dio = dm_compress_pick_oldest_dio(c);
+		if (!dio)
+			break;
+		chunk = dio->chunk;
+		if (!dm_compress_process_chunk(dio)) {
+			break;
+		}
+		dm_compress_unlink_dio(dio);
+		bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_compress_io));
+		bio_list_add(&bio_list, bio);
+		while ((dio = dm_compress_pick_dio_for_chunk(c, chunk))) {
+			/*printk("picked another dio for chunk %llx\n", chunk);*/
+			if (!dm_compress_process_chunk(dio)) {
+				break;
+			}
+			dm_compress_unlink_dio(dio);
+			bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_compress_io));
+			bio_list_add(&bio_list, bio);
+		}
+	}
+	wake_up(&c->wait_idle);
+	mutex_unlock(&c->mutex);
+
+	while ((bio = bio_list_pop(&bio_list)))
+		dm_compress_endio(bio);
+}
+
+static void dm_compress_read_failed(struct cached_chunk *cc)
+{
+	struct dm_compress *c = cc->c;
+	sector_t chunk = cc->chunk;
+	blk_status_t status = errno_to_blk_status(cc->failed);
+	mutex_lock(&c->mutex);
+	if (unlikely(cc->dirty)) {
+		cc->dirty = false;
+		dm_compress_error(c, "Could not read a chunk with pending writes", -EIO);
+	}
+	if (cc->intent >= INTENT_FREE) {
+		dm_compress_release_cached_chunk(cc);
+	} else {
+		cc->intent = INTENT_IDLE;
+	}
+	dm_compress_process_bios_on_chunk(c, chunk, status);
+}
+
+static void dm_compress_read_and_decompress(struct cached_chunk *cc)
+{
+	struct dm_compress *c = cc->c;
+	struct dm_buffer *bp;
+	struct chunk_entry *ce;
+	struct chunk_ptr *cp;
+	struct chunk_ptr cp_copy;
+
+	if (unlikely(cc->failed)) {
+		dm_compress_read_failed(cc);
+		return;
+	}
+
+	ce = map_chunk(c, cc->chunk, &bp);
+	if (unlikely(IS_ERR(ce))) {
+		dm_compress_error_chunk(cc, "Unable to load chunk descriptor", PTR_ERR(ce));
+		dm_compress_read_failed(cc);
+		return;
+	}
+
+	cp = &ce->ptr[CC_VALID(c, &ce->cc_txc)];
+	cp_copy = *cp;
+	dm_bufio_release(bp);
+
+	INIT_WORK(&cc->work, dm_compress_chunk_decompress);
+	if (unlikely(!dm_compress_read_chunk(cc, &cp_copy))) {
+		dm_compress_read_failed(cc);
+		return;
+	}
+}
+
+static void dm_compress_chunk_decompress(struct work_struct *w)
+{
+	struct cached_chunk *cc = container_of(w, struct cached_chunk, work);
+	struct dm_compress *c = cc->c;
+	unsigned i;
+	unsigned intent;
+
+	if (unlikely(cc->failed)) {
+		dm_compress_read_failed(cc);
+		return;
+	}
+
+	if (cc->algorithm == ALGORITHM_ZERO) {
+		mutex_lock(&c->mutex);
+		for (i = 0; i < 1 << c->log2_sectors_per_chunk; i++) {
+			if (!cc->sector_tags[i]) {
+				unsigned offset = i << 9;
+				memset(cc->uncompressed_data + offset, 0, 512);
+			}
+		}
+	} else if (cc->algorithm == ALGORITHM_UNCOMPRESSED) {
+		if (unlikely(cc->compressed_size != 512U << c->log2_sectors_per_chunk)) {
+			dm_compress_error_chunk(cc, "Decompressed less data than requested", -EUCLEAN);
+			dm_compress_read_failed(cc);
+			return;
+		}
+		mutex_lock(&c->mutex);
+		for (i = 0; i < 1 << c->log2_sectors_per_chunk; i++) {
+			if (!cc->sector_tags[i]) {
+				unsigned offset = i << 9;
+				memcpy(cc->uncompressed_data + offset, cc->compressed_data + offset, 512);
+			}
+		}
+	} else if (cc->algorithm < DM_COMPRESS_N_ALGORITHMS) {
+		int ret;
+		unsigned len_in, len_out;
+
+		len_out = 512U << c->log2_sectors_per_chunk;
+		len_in = le32_to_cpu(*(__le32 *)cc->compressed_data);
+		if (unlikely(len_in > cc->compressed_size - 4)) {
+			dm_compress_error_chunk(cc, "Invalid length", -EUCLEAN);
+			dm_compress_read_failed(cc);
+			return;
+		}
+
+		ret = dm_compress_algorithms[cc->algorithm].decompress(cc->contexts[cc->algorithm], cc->compressed_data + 4, len_in, cc->merging_data, len_out);
+
+		if (unlikely(ret < 0)) {
+			dm_compress_error_chunk(cc, "Decompression failed", ret);
+			dm_compress_read_failed(cc);
+			return;
+		}
+		if (unlikely(ret != len_out)) {
+			dm_compress_error_chunk(cc, "Decompressed less data than requested", -EUCLEAN);
+			dm_compress_read_failed(cc);
+			return;
+		}
+
+		mutex_lock(&c->mutex);
+		for (i = 0; i < 1 << c->log2_sectors_per_chunk; i++) {
+			if (!cc->sector_tags[i]) {
+				unsigned offset = i << 9;
+				memcpy(cc->uncompressed_data + offset, cc->merging_data + offset, 512);
+			}
+		}
+	} else {
+		dm_compress_error_chunk(cc, "Unsupported algorithm", -EOPNOTSUPP);
+		dm_compress_read_failed(cc);
+		return;
+	}
+
+	memset(cc->sector_tags, TAG_VALID, 1U << c->log2_sectors_per_chunk);
+
+	intent = cc->intent;
+	if (intent == INTENT_READ) {
+		cc->intent = INTENT_IDLE;
+	}
+
+	dm_compress_process_bios_on_chunk(c, cc->chunk, BLK_STS_OK);
+
+	if (intent >= INTENT_WRITE) {
+		dm_compress_chunk_work(&cc->work);
+	}
+}
+
+static void dm_compress_process_bios_on_chunk(struct dm_compress *c, sector_t chunk, blk_status_t status)
+{
+	struct bio_list bio_list;
+	struct dm_compress_io *dio;
+	struct bio *bio;
+
+	bio_list_init(&bio_list);
+
+	while ((dio = dm_compress_pick_dio_for_chunk(c, chunk))) {
+		bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_compress_io));
+		if (likely(status == BLK_STS_OK)) {
+			if (!dm_compress_process_chunk(dio)) {
+				break;
+			}
+		} else {
+			bio->bi_status = status;
+		}
+		dm_compress_unlink_dio(dio);
+		bio_list_add(&bio_list, bio);
+	}
+	while ((dio = dm_compress_pick_oldest_dio(c))) {
+		if (!dm_compress_process_chunk(dio)) {
+			break;
+		}
+		dm_compress_unlink_dio(dio);
+		bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_compress_io));
+		bio_list_add(&bio_list, bio);
+	}
+
+	wake_up(&c->wait_idle);
+	mutex_unlock(&c->mutex);
+
+	while ((bio = bio_list_pop(&bio_list)))
+		dm_compress_endio(bio);
+}
+
+static void dm_compress_kick_autocommit(struct dm_compress *c)
+{
+	queue_delayed_work(c->flush_wq, &c->autocommit_work, c->autocommit_jiffies);
+}
+
+void dm_compress_autocommit(struct work_struct *w)
+{
+	struct dm_compress *c = container_of(w, struct dm_compress, autocommit_work.work);
+	mutex_lock(&c->mutex);
+	c->autocommit_active = true;
+	while (dm_compress_is_something_in_progress(c)) {
+		DECLARE_WAITQUEUE(wait, current);
+		add_wait_queue(&c->wait_idle, &wait);
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		mutex_unlock(&c->mutex);
+		io_schedule();
+		mutex_lock(&c->mutex);
+		remove_wait_queue(&c->wait_idle, &wait);
+	}
+
+	dm_compress_sync(c);
+
+	c->autocommit_active = false;
+	dm_compress_process_pending_ios(c);
+}
Index: linux-2.6/Documentation/admin-guide/device-mapper/dm-compress.rst
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/admin-guide/device-mapper/dm-compress.rst
@@ -0,0 +1,61 @@
+===========
+dm-compress
+===========
+
+The dm-compress target provides transparent compression of data on a block
+device.
+
+The device is divided into blocks, a block is the basic allocation unit. Block
+size must be a power of two and it must be greater or equal than the logical
+block size of the underlying device. A smaller block size improves
+space-efficiency. SSDs and some hard disks perform read-modify-write cycle when
+writing data that is not aligned on 4k boundary, so a block size smaller than 4k
+may degrade performance.
+
+The device is managed in the units of chunks. Chunk size must be a power of two
+and it must be greater than block size. Every chunk is fully compressed using
+the selected algorithm and it is stored in one or more blocks (or no blocks, if
+it contains only zeros). Greater chunk size improves the compression ratio, but
+it also degrades performance because the full chunk must be decompressed when
+accessing any part of the chunk.
+
+When loading the target for the first time, the kernel driver will format
+the device. The 4k superblock (after the reserved area) must contain zeros. If
+the superblock is not zeroed, the device can't be formatted and the target
+constructor will report an error.
+
+
+Target arguments:
+
+1. the underlying block device
+
+2. the number of reserved sectors at the beginning of the device - dm-compress
+   won't read or write these sectors
+
+3. block size (a power of two in the range 512 - 524288)
+
+4. chunk size (a power of two in the range 1024 - 1048576)
+   the chunk size divided by the block size must be less or equal than 256
+
+5. the total number of chunks
+
+6. the compression algorithm - the supported algorithms are:
+   deflate, lzo, 842, lz4, lz4hc, zstd
+
+7. the number of additional arguments
+
+Additional arguments:
+
+meta_device:device
+	Store metadata on a separate device
+
+n_cached_chunks:number (default 128)
+	The number of cached decompressed chunks that is kept in memory. The
+	cached chunks are preallocated when the target is loaded. The memory
+	consumption of the target is n_cached_chunks*chunk_size*3.
+
+
+Status line:
+
+1. The total number of blocks
+2. The number of free blocks
Index: linux-2.6/drivers/md/dm-compress/chunk.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-compress/chunk.c
@@ -0,0 +1,440 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2026 Mikulas Patocka
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-compress.h"
+
+static void dm_compress_read_endio(struct bio *bio);
+static void dm_compress_write_endio(struct bio *bio);
+
+static struct split_chunk *map_split_block(struct dm_compress *c, struct cached_chunk *cc, sector_t block)
+{
+	struct dm_buffer *bp;
+	struct split_chunk *split, *split_copy;
+
+	split = dm_bufio_read(c->split_bufio, block, &bp);
+	if (IS_ERR(split)) {
+		if (cc)
+			dm_compress_error_chunk(cc, "Error reading split block", PTR_ERR(split));
+		else
+			dm_compress_error(c, "Error reading split block", PTR_ERR(split));
+		return split;
+	}
+
+	split_copy = mempool_alloc(&c->block_io_buffers, GFP_NOIO);
+	memcpy(split_copy, split, 512U << c->log2_sectors_per_block);
+	dm_bufio_release(bp);
+
+	if (unlikely(split_copy->magic != SPLIT_BLOCK_MAGIC)) {
+		if (cc)
+			dm_compress_error_chunk(cc, "Split block magic doesn't match", -EUCLEAN);
+		else
+			dm_compress_error(c, "Split block magic doesn't match", -EUCLEAN);
+		mempool_free(split_copy, &c->block_io_buffers);
+		return ERR_PTR(-EUCLEAN);
+	}
+
+	if (unlikely(offsetof(struct split_chunk, extents[le16_to_cpu(split_copy->n_extents)]) > 512U << c->log2_sectors_per_block)) {
+		if (cc)
+			dm_compress_error_chunk(cc, "Split block has corrupted n_extents", -EUCLEAN);
+		else
+			dm_compress_error(c, "Split block has corrupted n_extents", -EUCLEAN);
+		mempool_free(split_copy, &c->block_io_buffers);
+		return ERR_PTR(-EUCLEAN);
+	}
+
+	return split_copy;
+}
+
+bool dm_compress_read_chunk(struct cached_chunk *cc, struct chunk_ptr *cp)
+{
+	struct dm_compress *c = cc->c;
+	sector_t blk;
+	struct bio *bio;
+	struct split_chunk *split;
+	char *chunk_ptr;
+	size_t chunk_remaining;
+	unsigned loops;
+	const unsigned block_size = 512U << c->log2_sectors_per_block;
+	const unsigned chunk_size = 512U << c->log2_sectors_per_chunk;
+
+	blk = READ_PTR(cp);
+	if (likely(cp->algorithm != ALGORITHM_SPLIT)) {
+		unsigned n_blocks;
+		cc->algorithm = cp->algorithm;
+		n_blocks = cc->algorithm == ALGORITHM_ZERO ? 0 : cp->length + 1;
+		cc->compressed_size = n_blocks << (9 + c->log2_sectors_per_block);
+
+		if (unlikely(n_blocks > 1 << (c->log2_sectors_per_chunk - c->log2_sectors_per_block))) {
+			dm_compress_error_chunk(cc, "The block counter is corrupted", -EUCLEAN);
+			return false;
+		}
+
+		if (cp->algorithm == ALGORITHM_ZERO) {
+			queue_work(c->compress_wq, &cc->work);
+			return true;
+		}
+
+		bio = cc->bio;
+		bio_init_inline(bio, c->dev->bdev, cc->bio_vectors, REQ_OP_READ);
+		bio->bi_iter.bi_sector = blk << c->log2_sectors_per_block;
+		if (!c->meta_dev)
+			bio->bi_iter.bi_sector += c->start;
+		bio->bi_iter.bi_size = cc->compressed_size;
+		bio->bi_vcnt = cc->bio_vectors;
+		bio->bi_end_io = dm_compress_read_endio;
+		bio->bi_private = cc;
+		submit_bio(bio);
+
+		return true;
+	}
+
+	split = map_split_block(c, cc, blk);
+	if (IS_ERR(split))
+		return false;
+
+	cc->algorithm = split->algorithm;
+
+	if (cc->algorithm != ALGORITHM_UNCOMPRESSED) {
+		chunk_ptr = cc->compressed_data + 4;
+		*(int32_t *)cc->compressed_data = split->compressed_size;
+		chunk_remaining = le32_to_cpu(split->compressed_size);
+		if (unlikely(chunk_remaining > chunk_size - 4)) {
+			mempool_free(split, &c->block_io_buffers);
+			dm_compress_error_chunk(cc, "Invalid compressed size", -EUCLEAN);
+			return false;
+		}
+		cc->compressed_size = chunk_remaining + 4;
+	} else {
+		chunk_ptr = cc->compressed_data;
+		chunk_remaining = chunk_size;
+		cc->compressed_size = chunk_remaining;
+	}
+	loops = 0;
+	while (true) {
+		size_t i;
+		unsigned end, size, this_step;
+		bool next_valid;
+		sector_t next_blk;
+		if (unlikely(loops++ >= MAX_SPLIT_CHUNK_CHAIN)) {
+			dm_compress_error_chunk(cc, "Too long split chunk chain", -EUCLEAN);
+			mempool_free(split, &c->block_io_buffers);
+			return false;
+		}
+		for (i = 0; i < le16_to_cpu(split->n_extents); i++) {
+			struct split_extent *sx = &split->extents[i];
+			sector_t ptr = READ_PTR(sx);
+			unsigned len = le16_to_cpu(sx->len);
+			dm_bufio_prefetch(c->split_bufio, ptr, len);
+		}
+		if (split->next_valid)
+			dm_bufio_prefetch(c->split_bufio, READ_PTR(split), 1);
+
+		for (i = 0; i < le16_to_cpu(split->n_extents); i++) {
+			struct split_extent *sx = &split->extents[i];
+			sector_t ptr = READ_PTR(sx);
+			unsigned len = le16_to_cpu(sx->len);
+			unsigned j;
+			for (j = 0; j < len; j++, ptr++) {
+				struct dm_buffer *bp;
+				char *data = dm_bufio_read(c->split_bufio, ptr, &bp);
+				if (IS_ERR(data)) {
+					dm_compress_error_chunk(cc, "Error reading split block data", PTR_ERR(data));
+					mempool_free(split, &c->block_io_buffers);
+					return false;
+				}
+				this_step = min(block_size, chunk_remaining);
+				memcpy(chunk_ptr, data, this_step);
+				chunk_ptr += this_step;
+				chunk_remaining -= this_step;
+				dm_bufio_release(bp);
+			}
+		}
+
+		end = offsetof(struct split_chunk, extents[le16_to_cpu(split->n_extents)]);
+		size = block_size - end;
+		this_step = min(size, chunk_remaining);
+		memcpy(chunk_ptr, &split->extents[le16_to_cpu(split->n_extents)], this_step);
+		chunk_ptr += this_step;
+		chunk_remaining -= this_step;
+
+		next_valid = split->next_valid;
+		next_blk = READ_PTR(split);
+		mempool_free(split, &c->block_io_buffers);
+
+		if (!next_valid)
+			break;
+		if (unlikely(!chunk_remaining)) {
+			dm_compress_error_chunk(cc, "Split chunk is too big", -EUCLEAN);
+			return false;
+		}
+
+		split = map_split_block(c, cc, next_blk);
+		if (IS_ERR(split))
+			return false;
+	}
+	if (unlikely(chunk_remaining != 0)) {
+		dm_compress_error_chunk(cc, "Split chunk is too small", -EUCLEAN);
+		return false;
+	}
+
+	queue_work(c->compress_wq, &cc->work);
+	return true;
+}
+
+static void dm_compress_read_endio(struct bio *bio)
+{
+	struct cached_chunk *cc = bio->bi_private;
+	struct dm_compress *c = cc->c;
+	if (unlikely(bio->bi_status != BLK_STS_OK))
+		dm_compress_error_chunk(cc, "Error reading compressed data", blk_status_to_errno(bio->bi_status));
+	bio_uninit(bio);
+	queue_work(c->compress_wq, &cc->work);
+}
+
+bool dm_compress_allocate_chunk(struct cached_chunk *cc, sector_t preferred_block, struct chunk_ptr *cp)
+{
+	struct dm_compress *c = cc->c;
+	const unsigned block_size = 512U << c->log2_sectors_per_block;
+	const unsigned chunk_size = 512U << c->log2_sectors_per_chunk;
+	unsigned len_compressed;
+	unsigned n_blocks;
+	char *src_ptr;
+	sector_t blk;
+	sector_t next_blk;
+	struct bio *bio;
+	struct split_chunk *split;
+	struct split_chunk *split_buf;
+	unsigned n_extents;
+	unsigned split_space;
+	unsigned this_step;
+	struct dm_buffer *bp;
+
+	if (cc->algorithm == ALGORITHM_ZERO) {
+		WRITE_PTR(cp, 0);
+		cp->length = 0;
+		cp->algorithm = ALGORITHM_ZERO;
+		queue_work(c->compress_wq, &cc->work);
+		return true;
+	} else if (cc->algorithm == ALGORITHM_UNCOMPRESSED) {
+		len_compressed = chunk_size;
+		src_ptr = cc->compressed_data;
+		n_blocks = chunk_size >> (9 + c->log2_sectors_per_block);
+	} else {
+		len_compressed = le32_to_cpu(*(uint32_t *)cc->compressed_data);
+		src_ptr = cc->compressed_data + 4;
+		n_blocks = (len_compressed + 4 + block_size - 1) >> (9 + c->log2_sectors_per_block);
+	}
+#ifdef TEST_SPLIT_CHUNKS
+	if (get_random_u8() & 1)
+		blk = ALLOCATE_NO_SPACE;
+	else
+#endif
+		blk = dm_compress_allocate_space(c, preferred_block, n_blocks);
+	if (unlikely(blk == ALLOCATE_ERROR))
+		return false;
+
+	if (likely(blk != ALLOCATE_NO_SPACE)) {
+		WRITE_ONCE(c->last_allocated, blk + n_blocks);
+
+		bio = cc->bio;
+		bio_init_inline(bio, c->dev->bdev, cc->bio_vectors, REQ_OP_WRITE);
+		bio->bi_iter.bi_sector = blk << c->log2_sectors_per_block;
+		if (!c->meta_dev)
+			bio->bi_iter.bi_sector += c->start;
+		bio->bi_iter.bi_size = n_blocks << (9 + c->log2_sectors_per_block);
+		bio->bi_vcnt = cc->bio_vectors;
+		bio->bi_end_io = dm_compress_write_endio;
+		bio->bi_private = cc;
+		submit_bio(bio);
+
+		WRITE_PTR(cp, blk);
+		cp->length = n_blocks - 1;
+		cp->algorithm = cc->algorithm;
+		return true;
+	}
+
+	blk = dm_compress_allocate_space(c, preferred_block, 1);
+	if (unlikely(blk == ALLOCATE_ERROR))
+		return false;
+	if (unlikely(blk == ALLOCATE_NO_SPACE)) {
+		dm_compress_error(c, "The device is out of space", -ENOSPC);
+		return false;
+	}
+	preferred_block = blk + 1;
+	WRITE_ONCE(c->last_allocated, preferred_block);
+	WRITE_PTR(cp, blk);
+	cp->length = 0;
+	cp->algorithm = ALGORITHM_SPLIT;
+
+	split = mempool_alloc(&c->block_io_buffers, GFP_NOIO);
+
+	memset(split, 0, block_size);
+	split->magic = SPLIT_BLOCK_MAGIC;
+	split->algorithm = cc->algorithm;
+	split->compressed_size = cpu_to_le32(len_compressed);
+	split->n_extents = cpu_to_le16(0);
+
+new_sub_block:
+	n_extents = le16_to_cpu(split->n_extents);
+	split_space = block_size - offsetof(struct split_chunk, extents[n_extents]);
+
+	if (len_compressed > split_space) {
+		if (split_space >= sizeof(struct split_extent)) {
+			void *sub;
+			sector_t subblk = dm_compress_allocate_space(c, preferred_block, 1);
+			if (unlikely(subblk == ALLOCATE_ERROR))
+				goto free_ret;
+			if (unlikely(subblk == ALLOCATE_NO_SPACE)) {
+				dm_compress_error(c, "The device is out of space", -ENOSPC);
+				goto free_ret;
+			}
+			preferred_block = subblk + 1;
+			WRITE_ONCE(c->last_allocated, preferred_block);
+#ifdef TEST_SPLIT_CHUNK_CHAINS
+			if (!get_random_u8())
+#endif
+			if (n_extents) {
+				sector_t last_run = le16_to_cpu(split->extents[n_extents - 1].len);
+				sector_t last = READ_PTR(&split->extents[n_extents - 1]);
+				if (subblk == last + last_run && last_run < 0xffff) {
+					last_run++;
+					split->extents[n_extents - 1].len = cpu_to_le16(last_run);
+					goto appended;
+				}
+			}
+			WRITE_PTR(&split->extents[n_extents], subblk);
+			split->extents[n_extents].len = cpu_to_le16(1);
+			n_extents++;
+			split->n_extents = cpu_to_le16(n_extents);
+			goto appended;
+appended:
+			sub = dm_bufio_new(c->split_bufio, subblk, &bp);
+			if (IS_ERR(sub)) {
+				dm_compress_error(c, "Unable to create a new buffer", PTR_ERR(sub));
+				goto free_ret;
+			}
+			this_step = min(block_size, len_compressed);
+			memcpy(sub, src_ptr, this_step);
+			src_ptr += this_step;
+			len_compressed -= this_step;
+			dm_bufio_mark_buffer_dirty(bp);
+			dm_bufio_release(bp);
+			c->split_bufio_dirty = true;
+			goto new_sub_block;
+		}
+	}
+	this_step = min(split_space, len_compressed);
+	memcpy(&split->extents[n_extents], src_ptr, this_step);
+	src_ptr += this_step;
+	len_compressed -= this_step;
+
+	if (unlikely(len_compressed != 0)) {
+		next_blk = dm_compress_allocate_space(c, preferred_block, 1);
+		if (unlikely(next_blk == ALLOCATE_ERROR))
+			goto free_ret;
+		if (unlikely(next_blk == ALLOCATE_NO_SPACE)) {
+			dm_compress_error(c, "The device is out of space", -ENOSPC);
+			goto free_ret;
+		}
+		preferred_block = next_blk + 1;
+		WRITE_ONCE(c->last_allocated, preferred_block);
+
+		split->next_valid = 1;
+		WRITE_PTR(split, next_blk);
+	}
+
+	split_buf = dm_bufio_new(c->split_bufio, blk, &bp);
+	if (IS_ERR(split_buf)) {
+		dm_compress_error(c, "Unable to create a new buffer", PTR_ERR(split_buf));
+		goto free_ret;
+	}
+	memcpy(split_buf, split, block_size);
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+	c->split_bufio_dirty = true;
+
+	if (likely(!len_compressed)) {
+		mempool_free(split, &c->block_io_buffers);
+		queue_work(c->compress_wq, &cc->work);
+		return true;
+	}
+
+	blk = next_blk;
+
+	memset(split, 0, block_size);
+	split->magic = SPLIT_BLOCK_MAGIC;
+	split->n_extents = cpu_to_le16(0);
+	goto new_sub_block;
+
+free_ret:
+	mempool_free(split, &c->block_io_buffers);
+	return false;
+}
+
+static void dm_compress_write_endio(struct bio *bio)
+{
+	struct cached_chunk *cc = bio->bi_private;
+	struct dm_compress *c = cc->c;
+	if (unlikely(bio->bi_status != BLK_STS_OK))
+		dm_compress_error(c, "Error writing compressed data", blk_status_to_errno(bio->bi_status));
+	bio_uninit(bio);
+
+	queue_work(c->compress_wq, &cc->work);
+}
+
+void dm_compress_release_chunk(struct dm_compress *c, struct chunk_ptr *cp)
+{
+	sector_t existing_block;
+	unsigned existing_length;
+	struct split_chunk *split;
+	size_t i;
+	sector_t next;
+	unsigned loops;
+
+	existing_block = ((__u64)le16_to_cpu(cp->hi) << 32) | le32_to_cpu(cp->lo);
+
+	if (likely(cp->algorithm != ALGORITHM_SPLIT)) {
+		existing_length = cp->algorithm != ALGORITHM_ZERO ? cp->length + 1 : 0;
+
+		if (existing_length)
+			dm_compress_free_space(c, existing_block, existing_length);
+
+		return;
+	}
+
+	loops = 0;
+	do {
+		if (unlikely(loops++ >= MAX_SPLIT_CHUNK_CHAIN)) {
+			dm_compress_error(c, "Too long split chunk chain", -EUCLEAN);
+			return;
+		}
+
+		split = map_split_block(c, NULL, existing_block);
+		if (IS_ERR(split))
+			return;
+
+		for (i = 0; i < le16_to_cpu(split->n_extents); i++) {
+			struct split_extent *sx = &split->extents[i];
+			sector_t ptr = READ_PTR(sx);
+			sector_t len = le16_to_cpu(sx->len);
+			dm_bufio_forget_buffers_forced(c->split_bufio, ptr, len);
+			dm_compress_free_space(c, ptr, len);
+		}
+
+		next = (sector_t)-1;
+		if (split->next_valid)
+			next = READ_PTR(split);
+
+		mempool_free(split, &c->block_io_buffers);
+
+		dm_bufio_forget_buffers_forced(c->split_bufio, existing_block, 1);
+		dm_compress_free_space(c, existing_block, 1);
+
+		existing_block = next;
+	} while (existing_block != (sector_t)-1);
+}
Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -2278,6 +2278,22 @@ void dm_bufio_forget_buffers(struct dm_b
 }
 EXPORT_SYMBOL_GPL(dm_bufio_forget_buffers);
 
+static enum evict_result forced_evict(struct dm_buffer *b, void *context)
+{
+	wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
+	wait_on_bit_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
+
+	return ER_EVICT;
+}
+
+void dm_bufio_forget_buffers_forced(struct dm_bufio_client *c, sector_t block, sector_t n_blocks)
+{
+	dm_bufio_lock(c);
+	cache_remove_range(&c->cache, block, block + n_blocks, forced_evict, __free_buffer_wake);
+	dm_bufio_unlock(c);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_forget_buffers_forced);
+
 void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n)
 {
 	c->minimum_buffers = n;
Index: linux-2.6/include/linux/dm-bufio.h
===================================================================
--- linux-2.6.orig/include/linux/dm-bufio.h
+++ linux-2.6/include/linux/dm-bufio.h
@@ -154,6 +154,20 @@ void dm_bufio_forget(struct dm_bufio_cli
 void dm_bufio_forget_buffers(struct dm_bufio_client *c, sector_t block, sector_t n_blocks);
 
 /*
+ * Free the given range of buffers, discarding any dirty data that they hold
+ * without writing it back - the caller is expected to be releasing the
+ * underlying blocks.
+ *
+ * The caller must guarantee that nobody else uses the blocks in the range.
+ * When this function returns the buffers are gone and any i/o on them has
+ * completed.
+ *
+ * This function sleeps, so it must not be used on a client that was created
+ * with no_sleep set.
+ */
+void dm_bufio_forget_buffers_forced(struct dm_bufio_client *c, sector_t block, sector_t n_blocks);
+
+/*
  * Set the minimum number of buffers before cleanup happens.
  */
 void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n);
Index: linux-2.6/drivers/md/dm-compress/struct.h
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-compress/struct.h
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2026 Mikulas Patocka
+ *
+ * This file is released under the GPL.
+ */
+
+#define BUFFER_SIZE			4096
+
+#define MAX_BLOCK_SIZE			1048576
+#define MAX_CHUNK_SIZE			1048576
+
+#define SB_MAGIC	"dm-comp"
+
+#define SB_VERSION_1	1
+
+#define BUFFER_SECTORS	(BUFFER_SIZE >> SECTOR_SHIFT)
+#define SB_SECTORS	BUFFER_SECTORS
+
+struct superblock {
+	__u8 magic[8];
+	__u8 version;
+	__u8 log2_buffer_size;		/* log2 of BUFFER_SIZE */
+	__u8 log2_sectors_per_block;
+	__u8 log2_sectors_per_chunk;
+	__le16 cc;
+	__le16 pad;
+	__le64 cct;			/* ptr to struct crash_count_table */
+	__le64 n_cc_txc;
+	__le64 n_blocks[2];
+	__le64 n_chunks[2];
+	__le64 n_used_metadata_blocks[2];
+	__le64 bitmap_directory;	/* ptr to struct directory */
+	__le64 chunk_directory;		/* ptr to struct directory */
+};
+
+#define CCT_ENTRIES	65536
+
+struct crash_count_table {
+	__le64 entries[CCT_ENTRIES];
+};
+
+#define CCT_SIZE	sizeof(struct crash_count_table)
+
+#define ALGORITHM_ZERO		0xff
+#define ALGORITHM_UNCOMPRESSED	0xfe
+#define ALGORITHM_SPLIT		0xfd
+
+struct chunk_ptr {
+	__le32 lo;
+	__le16 hi;
+	__u8 length;
+	__u8 algorithm;
+};
+
+struct chunk_entry {
+	__le64 cc_txc;
+	struct chunk_ptr ptr[2];
+};
+
+#define CHUNKS_PER_BUFFER	(BUFFER_SIZE / sizeof(struct chunk_entry))
+
+#define CHUNKS_MAGIC		(cpu_to_be64(0x4348554E4B53ULL))
+
+struct chunk_entries {
+	__be64 magic;
+	struct chunk_entry chunk[CHUNKS_PER_BUFFER];
+} __attribute__((__aligned__(BUFFER_SIZE)));
+
+#define BITS_PER_BITMAP		((BUFFER_SIZE / 2 - 8) * 8)
+
+#define BITMAP_MAGIC		(cpu_to_be64(0x4249544D4150ULL))
+
+struct bitmap {
+	__be64 magic;
+	__u64 bmp1[BITS_PER_BITMAP / 64];
+	__le64 cc_txc;
+	__u64 bmp2[BITS_PER_BITMAP / 64];
+} __attribute__((__aligned__(BUFFER_SIZE)));
+
+struct ptr {
+	__le32 lo;
+	__le16 hi;
+} __attribute__((__packed__));
+
+#define READ_PTR(ptr)	(le32_to_cpup(&(ptr)->lo) | ((__u64)le16_to_cpup(&(ptr)->hi) << 32))
+
+#define WRITE_PTR(ptr, value)				\
+do {							\
+	(ptr)->lo = cpu_to_le32(value);			\
+	(ptr)->hi = cpu_to_le16((value) >> 31 >> 1);	\
+} while (0)
+
+#define DIRECTORY_ENTRIES	((BUFFER_SIZE - 16 - sizeof(struct ptr)) / sizeof(struct ptr))
+
+#define BMP_DIR_MAGIC		(cpu_to_be64(0x424D505F444952ULL))
+#define CHUNK_DIR_MAGIC		(cpu_to_be64(0x4348554E4B444952ULL))
+
+struct directory {
+	__be64 magic;
+	__le64 index;
+	struct ptr ptr[DIRECTORY_ENTRIES];	/* ptr to struct chunk_entries or struct bitmap */
+	struct ptr next;			/* ptr to next struct directory */
+} __attribute__((__aligned__(BUFFER_SIZE)));
+
+#define SPLIT_BLOCK_MAGIC	(cpu_to_be32(0x53504C49U))
+
+struct split_extent {
+	__le32 lo;
+	__le16 hi;
+	__le16 len;
+};
+
+#define MAX_SPLIT_CHUNK_CHAIN	8
+
+struct split_chunk {
+	__be32 magic;
+	__le16 pad;
+	__u8 algorithm;
+	__u8 next_valid;
+	__le32 lo;				/* ptr to next split_chunk */
+	__le16 hi;
+	__le16 n_extents;
+	__le32 compressed_size;
+	__le32 pad2;
+	struct split_extent extents[];
+};
Index: linux-2.6/Documentation/admin-guide/device-mapper/index.rst
===================================================================
--- linux-2.6.orig/Documentation/admin-guide/device-mapper/index.rst
+++ linux-2.6/Documentation/admin-guide/device-mapper/index.rst
@@ -9,6 +9,7 @@ Device Mapper
     cache
     delay
     dm-clone
+    dm-compress
     dm-crypt
     dm-dust
     dm-ebs
Index: linux-2.6/drivers/md/dm-compress/algorithms.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-compress/algorithms.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2026 Mikulas Patocka
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-compress.h"
+
+#include <linux/lz4.h>
+#include <linux/zstd.h>
+
+#define ZSTD_DEF_LEVEL		3
+#define ZSTD_MAX_WINDOWLOG	18
+#define ZSTD_MAX_SIZE		BIT(ZSTD_MAX_WINDOWLOG)
+
+static void kvfree_context(void *context)
+{
+	kvfree(context);
+}
+
+/* ===== LZ4/LZ4HC ===== */
+
+static void *lz4_allocate_context(gfp_t gfp)
+{
+	return kvmalloc(LZ4_MEM_COMPRESS, gfp);
+}
+
+static void *lz4hc_allocate_context(gfp_t gfp)
+{
+	return kvmalloc(LZ4HC_MEM_COMPRESS, gfp);
+}
+
+static int lz4_compress(void *context, void *in, size_t in_len, void *out, size_t out_len)
+{
+	int len = LZ4_compress_default(in, out, in_len, out_len, context);
+	if (!len)
+		return -EINVAL;
+	return len;
+}
+
+static int lz4hc_compress(void *context, void *in, size_t in_len, void *out, size_t out_len)
+{
+	int len = LZ4_compress_HC(in, out, in_len, out_len, LZ4HC_DEFAULT_CLEVEL, context);
+	if (!len)
+		return -EINVAL;
+	return len;
+}
+
+static int lz4_decompress(void *context, void *in, size_t in_len, void *out, size_t out_len)
+{
+	int len = LZ4_decompress_safe(in, out, in_len, out_len);
+	if (len < 0)
+		return -EINVAL;
+	return len;
+}
+
+/* ===== ZSTD ===== */
+
+struct zstd_ctx {
+	size_t wksp_size;
+	zstd_parameters params;
+	u8 wksp[] __aligned(8) __counted_by(wksp_size);
+};
+
+static void *zstd_allocate_context(gfp_t gfp)
+{
+	zstd_parameters params;
+	size_t wksp_size;
+	struct zstd_ctx *ctx;
+
+	params = zstd_get_params(ZSTD_DEF_LEVEL, ZSTD_MAX_SIZE);
+	wksp_size = max(zstd_cstream_workspace_bound(&params.cParams),
+			zstd_dstream_workspace_bound(ZSTD_MAX_SIZE));
+
+	if (!wksp_size)
+		return NULL;
+
+	ctx = kvmalloc_flex(*ctx, wksp, wksp_size, gfp);
+	if (!ctx)
+		return NULL;
+
+	ctx->params = params;
+	ctx->wksp_size = wksp_size;
+
+	return ctx;
+}
+
+static int zstd_compress(void *context, void *in, size_t in_len, void *out, size_t out_len)
+{
+	struct zstd_ctx *ctx = context;
+	zstd_cctx *cctx;
+	size_t len;
+
+	cctx = zstd_init_cctx(ctx->wksp, ctx->wksp_size);
+	if (unlikely(!cctx))
+		return -EINVAL;
+
+	len = zstd_compress_cctx(cctx, out, out_len, in, in_len, &ctx->params);
+
+	if (unlikely(zstd_is_error(len)))
+		return -EINVAL;
+
+	return len;
+}
+
+static int zstd_decompress(void *context, void *in, size_t in_len, void *out, size_t out_len)
+{
+	struct zstd_ctx *ctx = context;
+	zstd_dctx *dctx;
+	size_t len;
+
+	dctx = zstd_init_dctx(ctx->wksp, ctx->wksp_size);
+	if (unlikely(!dctx))
+		return -EINVAL;
+
+	len = zstd_decompress_dctx(dctx, out, out_len, in, in_len);
+
+	if (unlikely(zstd_is_error(len)))
+		return -EINVAL;
+
+	return len;
+}
+
+struct algorithm dm_compress_algorithms[DM_COMPRESS_N_ALGORITHMS] = {
+	{ "lz4", lz4_allocate_context, kvfree_context, lz4_compress, lz4_decompress },
+	{ "lz4hc", lz4hc_allocate_context, kvfree_context, lz4hc_compress, lz4_decompress },
+	{ "zstd", zstd_allocate_context, kvfree_context, zstd_compress, zstd_decompress },
+};

