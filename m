Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337922EAB9A
	for <dm-devel@lists.linux.dev>; Tue, 15 Jul 2025 13:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586486; cv=none; b=GjIyPpbebS8j3AIGnMOoIvBm4fFNpju8xwxvoD/R9fARPprOf7swYxT6ojdYWwHCizH0/gYNUPCmcCbyaDTzoN0qwd3XjN5f67yHpCtwPlbWSKR1btkdf9xs97a8YAFdNG4vSCt6H6PRHAejNWSj0pKX4q7DqQaHrVvdpHt5Gmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586486; c=relaxed/simple;
	bh=SCZ3jSEYbVzkRrbIR5yv6xnTCa6ZaSYkZn1A5S0aqc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gTy0jporwd5v7q7/F+GkutiATEhLuTRGa72Xye6XNgQQXegTfDoD44HwEftgg9RK11nOxpXcIxoxix7F8zaUFIS1a6GzGiHH7LxspT5YwjXcPCYDBDdaXCjP8FE/STOF+5sXttxkUNr8GF4bMsVMi0jpmEI3WZP96L6N6R0qFJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ajj+HRQ2; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ajj+HRQ2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752586481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eP66BoGF/1w1rDVzTlWL9BFlJmdiY2Jn3GUOyXvZrj8=;
	b=Ajj+HRQ2tw+L388jvvDZ/BOGeWRxIPyOkf1F4AQT/dJYDTzuBTbjJY0F+2UDkiw+QV8gzM
	Oci8vYsakpWxaRp00UnH6X2xK7yvtP5t+W3A5J3fa3l2tPgJFtuw/WYeZAf/Gg9sARvkLr
	Mwa6EkkHQ/I4oKxvuCf5nlwuY17WPfY=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	cengku@gmail.com,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH v4 04/11] dm-pcache: add segment layer
Date: Tue, 15 Jul 2025 13:33:24 +0000
Message-ID: <20250715133332.1764715-5-dongsheng.yang@linux.dev>
In-Reply-To: <20250715133332.1764715-1-dongsheng.yang@linux.dev>
References: <20250715133332.1764715-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Introduce segment.{c,h}, an internal abstraction that encapsulates
everything related to a single pcache *segment* (the fixed-size
allocation unit stored on the cache-device).

* On-disk metadata (`struct pcache_segment_info`)
  - Embedded `struct pcache_meta_header` for CRC/sequence handling.
  - `flags` field encodes a “has-next” bit and a 4-bit *type* class
    (`CACHE_DATA` added as the first type).

* Initialisation
  - `pcache_segment_init()` populates the in-memory
    `struct pcache_segment` from a given segment id, data offset and
    metadata pointer, computing the usable `data_size` and virtual
    address within the DAX mapping.

* IO helpers
  - `segment_copy_to_bio()` / `segment_copy_from_bio()` move data
    between pmem and a bio, using `_copy_mc_to_iter()` and
    `_copy_from_iter_flushcache()` to tolerate hw memory errors and
    ensure durability.
  - `segment_pos_advance()` advances an internal offset while staying
    inside the segment’s data area.

These helpers allow upper layers (cache key management, write-back
logic, GC, etc.) to treat a segment as a contiguous byte array without
knowing about DAX mappings or persistence details.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/segment.c | 61 ++++++++++++++++++++++++++++
 drivers/md/dm-pcache/segment.h | 74 ++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+)
 create mode 100644 drivers/md/dm-pcache/segment.c
 create mode 100644 drivers/md/dm-pcache/segment.h

diff --git a/drivers/md/dm-pcache/segment.c b/drivers/md/dm-pcache/segment.c
new file mode 100644
index 000000000000..7e9818701445
--- /dev/null
+++ b/drivers/md/dm-pcache/segment.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/dax.h>
+
+#include "pcache_internal.h"
+#include "cache_dev.h"
+#include "segment.h"
+
+int segment_copy_to_bio(struct pcache_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	struct iov_iter iter;
+	size_t copied;
+	void *src;
+
+	iov_iter_bvec(&iter, ITER_DEST, &bio->bi_io_vec[bio->bi_iter.bi_idx],
+			bio_segments(bio), bio->bi_iter.bi_size);
+	iter.iov_offset = bio->bi_iter.bi_bvec_done;
+	if (bio_off)
+		iov_iter_advance(&iter, bio_off);
+
+	src = segment->data + data_off;
+	copied = _copy_mc_to_iter(src, data_len, &iter);
+	if (copied != data_len)
+		return -EIO;
+
+	return 0;
+}
+
+int segment_copy_from_bio(struct pcache_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	struct iov_iter iter;
+	size_t copied;
+	void *dst;
+
+	iov_iter_bvec(&iter, ITER_SOURCE, &bio->bi_io_vec[bio->bi_iter.bi_idx],
+			bio_segments(bio), bio->bi_iter.bi_size);
+	iter.iov_offset = bio->bi_iter.bi_bvec_done;
+	if (bio_off)
+		iov_iter_advance(&iter, bio_off);
+
+	dst = segment->data + data_off;
+	copied = _copy_from_iter_flushcache(dst, data_len, &iter);
+	if (copied != data_len)
+		return -EIO;
+	pmem_wmb();
+
+	return 0;
+}
+
+void pcache_segment_init(struct pcache_cache_dev *cache_dev, struct pcache_segment *segment,
+		      struct pcache_segment_init_options *options)
+{
+	segment->seg_info = options->seg_info;
+	segment_info_set_type(segment->seg_info, options->type);
+
+	segment->cache_dev = cache_dev;
+	segment->seg_id = options->seg_id;
+	segment->data_size = PCACHE_SEG_SIZE - options->data_off;
+	segment->data = CACHE_DEV_SEGMENT(cache_dev, options->seg_id) + options->data_off;
+}
diff --git a/drivers/md/dm-pcache/segment.h b/drivers/md/dm-pcache/segment.h
new file mode 100644
index 000000000000..deca1ddcb02b
--- /dev/null
+++ b/drivers/md/dm-pcache/segment.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_SEGMENT_H
+#define _PCACHE_SEGMENT_H
+
+#include <linux/bio.h>
+#include <linux/bitfield.h>
+
+#include "pcache_internal.h"
+
+struct pcache_segment_info {
+	struct pcache_meta_header	header;
+	__u32			flags;
+	__u32			next_seg;
+};
+
+#define PCACHE_SEG_INFO_FLAGS_HAS_NEXT		BIT(0)
+
+#define PCACHE_SEG_INFO_FLAGS_TYPE_MASK         GENMASK(4, 1)
+#define PCACHE_SEGMENT_TYPE_CACHE_DATA		1
+
+static inline bool segment_info_has_next(struct pcache_segment_info *seg_info)
+{
+	return (seg_info->flags & PCACHE_SEG_INFO_FLAGS_HAS_NEXT);
+}
+
+static inline void segment_info_set_type(struct pcache_segment_info *seg_info, u8 type)
+{
+	seg_info->flags &= ~PCACHE_SEG_INFO_FLAGS_TYPE_MASK;
+	seg_info->flags |= FIELD_PREP(PCACHE_SEG_INFO_FLAGS_TYPE_MASK, type);
+}
+
+static inline u8 segment_info_get_type(struct pcache_segment_info *seg_info)
+{
+	return FIELD_GET(PCACHE_SEG_INFO_FLAGS_TYPE_MASK, seg_info->flags);
+}
+
+struct pcache_segment_pos {
+	struct pcache_segment	*segment;	/* Segment associated with the position */
+	u32			off;		/* Offset within the segment */
+};
+
+struct pcache_segment_init_options {
+	u8			type;
+	u32			seg_id;
+	u32			data_off;
+
+	struct pcache_segment_info	*seg_info;
+};
+
+struct pcache_segment {
+	struct pcache_cache_dev	*cache_dev;
+
+	void			*data;
+	u32			data_size;
+	u32			seg_id;
+
+	struct pcache_segment_info	*seg_info;
+};
+
+int segment_copy_to_bio(struct pcache_segment *segment,
+		      u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+int segment_copy_from_bio(struct pcache_segment *segment,
+			u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+
+static inline void segment_pos_advance(struct pcache_segment_pos *seg_pos, u32 len)
+{
+	BUG_ON(seg_pos->off + len > seg_pos->segment->data_size);
+
+	seg_pos->off += len;
+}
+
+void pcache_segment_init(struct pcache_cache_dev *cache_dev, struct pcache_segment *segment,
+		      struct pcache_segment_init_options *options);
+#endif /* _PCACHE_SEGMENT_H */
-- 
2.43.0

