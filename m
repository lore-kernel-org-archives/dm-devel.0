Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B041C7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 21:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684878662;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mdnqtx9CZUCzuZYR2ClRVqTXPdiR1DkVeVYfEzV/quU=;
	b=ViFnyuDldIy5YDEuAiocIPPv998VBYdCOscijXbynCXgO1vikq6a1fuaoIpX0s9Hvka5Ti
	52+RztvYno/pF82z/QgK9ClyuDXCZItK4t3mRjzK80AzMwrn+gh7rzGQqYqdfZgzDHbeJd
	WJZoGvyCABPpw055Fpmrjy7okyNDKz0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-eruiWgd7MVqjN1PUFIj0UQ-1; Tue, 23 May 2023 17:46:19 -0400
X-MC-Unique: eruiWgd7MVqjN1PUFIj0UQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 565BB85A5B5;
	Tue, 23 May 2023 21:46:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3E54D40CFD46;
	Tue, 23 May 2023 21:46:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2F36E19465B1;
	Tue, 23 May 2023 21:46:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 314D919466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 21:46:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24A5440CFD46; Tue, 23 May 2023 21:46:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BB6540CFD45
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:46:16 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFBC78032EF
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:46:15 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523--fu1zab7P3qEuM2fJibgNg-1; Tue, 23 May 2023 17:46:14 -0400
X-MC-Unique: -fu1zab7P3qEuM2fJibgNg-1
Received: by mail-qk1-f199.google.com with SMTP id
 af79cd13be357-7576f01e6e1so34580085a.1
 for <dm-devel@redhat.com>; Tue, 23 May 2023 14:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684878373; x=1687470373;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=vXsEhJRnCwQ18lRWdM5O2bRakCVKFbp/K3CQObmjT2I=;
 b=Va75gDnx0BFedVxH2ZjLQgiD1LrqXOwDbp2wMP5iLFFgxtVnEL3L9whungzf5A0wfh
 Ia9Ql6TDYFeMiduUg7p3gyXfVCGr7yXX75rVs0pP3vuB0i/YCJ72cLVQVFtc8wsPragK
 5ljtS3jnca/3Ig8rzC0SY8vlybfSZ2UBXZ+ias4tlFi8TrbhBp5EQGFzIoP6PpK6V9y7
 j1p3YMabTBgXu4HV9iMKhTCllFvwRKYPgzGTBej7RK0nuv1TRgFValwF8Q+HJ6FJXZD/
 KzVtt7CiPXPz/U+pbeKbYgsobhsldBnjNk67Kx3d40io9s7X+/JohVVAQJgepIjVH1mp
 9hrA==
X-Gm-Message-State: AC+VfDw5l//jniSHUwovJGFyHhcvnP44s/sh5c0hgTw1BeT1sTmrKDY9
 mNJEOAv9Q4fbRIIpxBCxMg+7sG5BtEXv3fb32l5yQUTH62n7bhEbq2kCnp6FSlNfv44HDpKwXV2
 XjuNc28+QNE+zbts61vUcl8C3/a1YVeEnmvh4YgqfFFO6Kssw8kpfsuuHGRTDKNhbCrxDuYRJ
X-Received: by 2002:a05:620a:1993:b0:75b:23a1:3664 with SMTP id
 bm19-20020a05620a199300b0075b23a13664mr6924616qkb.37.1684878372054; 
 Tue, 23 May 2023 14:46:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5/uykzKEnapseqaPz3aOGDOIbq+GaV3Pue3EmACt5BqxxQ51F0xIyM1Ouv98awuHJTqviIYg==
X-Received: by 2002:a05:620a:1993:b0:75b:23a1:3664 with SMTP id
 bm19-20020a05620a199300b0075b23a13664mr6924518qkb.37.1684878370255; 
 Tue, 23 May 2023 14:46:10 -0700 (PDT)
Received: from bf36-1.. (173-166-2-198-newengland.hfc.comcastbusiness.net.
 [173.166.2.198]) by smtp.gmail.com with ESMTPSA id
 x3-20020ae9e903000000b007592af6fce6sm2234465qkf.43.2023.05.23.14.46.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 14:46:09 -0700 (PDT)
From: "J. corwin Coburn" <corwin@redhat.com>
To: dm-devel@redhat.com,
	linux-block@vger.kernel.org
Date: Tue, 23 May 2023 17:45:14 -0400
Message-Id: <20230523214539.226387-15-corwin@redhat.com>
In-Reply-To: <20230523214539.226387-1-corwin@redhat.com>
References: <20230523214539.226387-1-corwin@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v2 14/39] Implement the chapter volume store.
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
Cc: vdo-devel@redhat.com, "J. corwin Coburn" <corwin@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The volume store structures manage the reading and writing of chapter
pages. When a chapter is closed, it is packed into a read-only structure,
split across several pages, and written to storage.

The volume store also contains a cache and specialized queues that sort and
batch requests by the page they need, in order to minimize latency and I/O
requests when records have to be read from storage. The cache and queues
also coordinate with the volume index to ensure that the volume does not
waste resources reading pages that are no longer valid.

Signed-off-by: J. corwin Coburn <corwin@redhat.com>
---
 drivers/md/dm-vdo/index-page-map.c |  181 +++
 drivers/md/dm-vdo/index-page-map.h |   54 +
 drivers/md/dm-vdo/radix-sort.c     |  349 ++++++
 drivers/md/dm-vdo/radix-sort.h     |   28 +
 drivers/md/dm-vdo/volume.c         | 1792 ++++++++++++++++++++++++++++
 drivers/md/dm-vdo/volume.h         |  174 +++
 6 files changed, 2578 insertions(+)
 create mode 100644 drivers/md/dm-vdo/index-page-map.c
 create mode 100644 drivers/md/dm-vdo/index-page-map.h
 create mode 100644 drivers/md/dm-vdo/radix-sort.c
 create mode 100644 drivers/md/dm-vdo/radix-sort.h
 create mode 100644 drivers/md/dm-vdo/volume.c
 create mode 100644 drivers/md/dm-vdo/volume.h

diff --git a/drivers/md/dm-vdo/index-page-map.c b/drivers/md/dm-vdo/index-page-map.c
new file mode 100644
index 00000000000..4ac90c84eba
--- /dev/null
+++ b/drivers/md/dm-vdo/index-page-map.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "index-page-map.h"
+
+#include "errors.h"
+#include "hash-utils.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "numeric.h"
+#include "permassert.h"
+#include "string-utils.h"
+#include "uds-threads.h"
+#include "uds.h"
+
+/*
+ * The index page map is conceptually a two-dimensional array indexed by chapter number and index
+ * page number within the chapter. Each entry contains the number of the last delta list on that
+ * index page. In order to save memory, the information for the last page in each chapter is not
+ * recorded, as it is known from the geometry.
+ */
+
+static const u8 PAGE_MAP_MAGIC[] = "ALBIPM02";
+
+enum {
+	PAGE_MAP_MAGIC_LENGTH = sizeof(PAGE_MAP_MAGIC) - 1,
+};
+
+static inline u32 get_entry_count(const struct geometry *geometry)
+{
+	return geometry->chapters_per_volume * (geometry->index_pages_per_chapter - 1);
+}
+
+int uds_make_index_page_map(const struct geometry *geometry, struct index_page_map **map_ptr)
+{
+	int result;
+	struct index_page_map *map;
+
+	result = UDS_ALLOCATE(1, struct index_page_map, "page map", &map);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	map->geometry = geometry;
+	map->entries_per_chapter = geometry->index_pages_per_chapter - 1;
+	result = UDS_ALLOCATE(get_entry_count(geometry),
+			      u16,
+			      "Index Page Map Entries",
+			      &map->entries);
+	if (result != UDS_SUCCESS) {
+		uds_free_index_page_map(map);
+		return result;
+	}
+
+	*map_ptr = map;
+	return UDS_SUCCESS;
+}
+
+void uds_free_index_page_map(struct index_page_map *map)
+{
+	if (map != NULL) {
+		UDS_FREE(map->entries);
+		UDS_FREE(map);
+	}
+}
+
+void uds_update_index_page_map(struct index_page_map *map,
+			       u64 virtual_chapter_number,
+			       u32 chapter_number,
+			       u32 index_page_number,
+			       u32 delta_list_number)
+{
+	size_t slot;
+
+	map->last_update = virtual_chapter_number;
+	if (index_page_number == map->entries_per_chapter)
+		return;
+
+	slot = (chapter_number * map->entries_per_chapter) + index_page_number;
+	map->entries[slot] = delta_list_number;
+}
+
+u32 uds_find_index_page_number(const struct index_page_map *map,
+			       const struct uds_record_name *name,
+			       u32 chapter_number)
+{
+	u32 delta_list_number = uds_hash_to_chapter_delta_list(name, map->geometry);
+	u32 slot = chapter_number * map->entries_per_chapter;
+	u32 page;
+
+	for (page = 0; page < map->entries_per_chapter; page++) {
+		if (delta_list_number <= map->entries[slot + page])
+			break;
+	}
+
+	return page;
+}
+
+void uds_get_list_number_bounds(const struct index_page_map *map,
+				u32 chapter_number,
+				u32 index_page_number,
+				u32 *lowest_list,
+				u32 *highest_list)
+{
+	u32 slot = chapter_number * map->entries_per_chapter;
+
+	*lowest_list = ((index_page_number == 0) ?
+			0 :
+			map->entries[slot + index_page_number - 1] + 1);
+	*highest_list = ((index_page_number < map->entries_per_chapter) ?
+			 map->entries[slot + index_page_number] :
+			 map->geometry->delta_lists_per_chapter - 1);
+}
+
+u64 uds_compute_index_page_map_save_size(const struct geometry *geometry)
+{
+	return PAGE_MAP_MAGIC_LENGTH + sizeof(u64) + sizeof(u16) * get_entry_count(geometry);
+}
+
+int uds_write_index_page_map(struct index_page_map *map, struct buffered_writer *writer)
+{
+	int result;
+	u8 *buffer;
+	size_t offset = 0;
+	u64 saved_size = uds_compute_index_page_map_save_size(map->geometry);
+	u32 i;
+
+	result = UDS_ALLOCATE(saved_size, u8, "page map data", &buffer);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	memcpy(buffer, PAGE_MAP_MAGIC, PAGE_MAP_MAGIC_LENGTH);
+	offset += PAGE_MAP_MAGIC_LENGTH;
+	encode_u64_le(buffer, &offset, map->last_update);
+	for (i = 0; i < get_entry_count(map->geometry); i++)
+		encode_u16_le(buffer, &offset, map->entries[i]);
+
+	result = uds_write_to_buffered_writer(writer, buffer, offset);
+	UDS_FREE(buffer);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	return uds_flush_buffered_writer(writer);
+}
+
+int uds_read_index_page_map(struct index_page_map *map, struct buffered_reader *reader)
+{
+	int result;
+	u8 magic[PAGE_MAP_MAGIC_LENGTH];
+	u8 *buffer;
+	size_t offset = 0;
+	u64 saved_size = uds_compute_index_page_map_save_size(map->geometry);
+	u32 i;
+
+	result = UDS_ALLOCATE(saved_size, u8, "page map data", &buffer);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_read_from_buffered_reader(reader, buffer, saved_size);
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(buffer);
+		return result;
+	}
+
+	memcpy(&magic, buffer, PAGE_MAP_MAGIC_LENGTH);
+	offset += PAGE_MAP_MAGIC_LENGTH;
+	if (memcmp(magic, PAGE_MAP_MAGIC, PAGE_MAP_MAGIC_LENGTH) != 0) {
+		UDS_FREE(buffer);
+		return UDS_CORRUPT_DATA;
+	}
+
+	decode_u64_le(buffer, &offset, &map->last_update);
+	for (i = 0; i < get_entry_count(map->geometry); i++)
+		decode_u16_le(buffer, &offset, &map->entries[i]);
+
+	UDS_FREE(buffer);
+	uds_log_debug("read index page map, last update %llu",
+		      (unsigned long long) map->last_update);
+	return UDS_SUCCESS;
+}
diff --git a/drivers/md/dm-vdo/index-page-map.h b/drivers/md/dm-vdo/index-page-map.h
new file mode 100644
index 00000000000..89d4a31f3fd
--- /dev/null
+++ b/drivers/md/dm-vdo/index-page-map.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_INDEX_PAGE_MAP_H
+#define UDS_INDEX_PAGE_MAP_H
+
+#include "geometry.h"
+#include "io-factory.h"
+
+/*
+ * The index maintains a page map which records how the chapter delta lists are distributed among
+ * the index pages for each chapter, allowing the volume to be efficient about reading only pages
+ * that it knows it will need.
+ */
+
+struct index_page_map {
+	const struct geometry *geometry;
+	u64 last_update;
+	u32 entries_per_chapter;
+	u16 *entries;
+};
+
+int __must_check
+uds_make_index_page_map(const struct geometry *geometry, struct index_page_map **map_ptr);
+
+void uds_free_index_page_map(struct index_page_map *map);
+
+int __must_check
+uds_read_index_page_map(struct index_page_map *map, struct buffered_reader *reader);
+
+int __must_check
+uds_write_index_page_map(struct index_page_map *map, struct buffered_writer *writer);
+
+void uds_update_index_page_map(struct index_page_map *map,
+			       u64 virtual_chapter_number,
+			       u32 chapter_number,
+			       u32 index_page_number,
+			       u32 delta_list_number);
+
+u32 __must_check uds_find_index_page_number(const struct index_page_map *map,
+					    const struct uds_record_name *name,
+					    u32 chapter_number);
+
+void uds_get_list_number_bounds(const struct index_page_map *map,
+				u32 chapter_number,
+				u32 index_page_number,
+				u32 *lowest_list,
+				u32 *highest_list);
+
+u64 uds_compute_index_page_map_save_size(const struct geometry *geometry);
+
+#endif /* UDS_INDEX_PAGE_MAP_H */
diff --git a/drivers/md/dm-vdo/radix-sort.c b/drivers/md/dm-vdo/radix-sort.c
new file mode 100644
index 00000000000..0770db65bca
--- /dev/null
+++ b/drivers/md/dm-vdo/radix-sort.c
@@ -0,0 +1,349 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "radix-sort.h"
+
+#include <linux/limits.h>
+#include <linux/types.h>
+
+#include "memory-alloc.h"
+#include "string-utils.h"
+
+/*
+ * This implementation allocates one large object to do the sorting, which can be reused as many
+ * times as desired. The amount of memory required is logarithmically proportional to the number of
+ * keys to be sorted.
+ */
+
+enum {
+	/* Piles smaller than this are handled with a simple insertion sort. */
+	INSERTION_SORT_THRESHOLD = 12,
+};
+
+/* Sort keys are pointers to immutable fixed-length arrays of bytes. */
+typedef const u8 *sort_key_t;
+
+/*
+ * The keys are separated into piles based on the byte in each keys at the current offset, so the
+ * number of keys with each byte must be counted.
+ */
+struct histogram {
+	/* The number of non-empty bins */
+	u16 used;
+	/* The index (key byte) of the first non-empty bin */
+	u16 first;
+	/* The index (key byte) of the last non-empty bin */
+	u16 last;
+	/* The number of occurrences of each specific byte */
+	u32 size[256];
+};
+
+/*
+ * Sub-tasks are manually managed on a stack, both for performance and to put a logarithmic bound
+ * on the stack space needed.
+ */
+struct task {
+	/* Pointer to the first key to sort. */
+	sort_key_t *first_key;
+	/* Pointer to the last key to sort. */
+	sort_key_t *last_key;
+	/* The offset into the key at which to continue sorting. */
+	u16 offset;
+	/* The number of bytes remaining in the sort keys. */
+	u16 length;
+};
+
+struct radix_sorter {
+	unsigned int count;
+	struct histogram bins;
+	sort_key_t *pile[256];
+	struct task *end_of_stack;
+	struct task insertion_list[256];
+	struct task stack[];
+};
+
+/* Compare a segment of two fixed-length keys starting at an offset. */
+static inline int compare(sort_key_t key1, sort_key_t key2, u16 offset, u16 length)
+{
+	return memcmp(&key1[offset], &key2[offset], length);
+}
+
+/* Insert the next unsorted key into an array of sorted keys. */
+static inline void insert_key(const struct task task, sort_key_t *next)
+{
+	/* Pull the unsorted key out, freeing up the array slot. */
+	sort_key_t unsorted = *next;
+
+	/* Compare the key to the preceding sorted entries, shifting down ones that are larger. */
+	while ((--next >= task.first_key) &&
+	       (compare(unsorted, next[0], task.offset, task.length) < 0))
+		next[1] = next[0];
+
+	/* Insert the key into the last slot that was cleared, sorting it. */
+	next[1] = unsorted;
+}
+
+/*
+ * Sort a range of key segments using an insertion sort. This simple sort is faster than the
+ * 256-way radix sort when the number of keys to sort is small.
+ */
+static inline void insertion_sort(const struct task task)
+{
+	sort_key_t *next;
+
+	for (next = task.first_key + 1; next <= task.last_key; next++)
+		insert_key(task, next);
+}
+
+/* Push a sorting task onto a task stack. */
+static inline void push_task(struct task **stack_pointer,
+			     sort_key_t *first_key,
+			     u32 count,
+			     u16 offset,
+			     u16 length)
+{
+	struct task *task = (*stack_pointer)++;
+
+	task->first_key = first_key;
+	task->last_key = &first_key[count - 1];
+	task->offset = offset;
+	task->length = length;
+}
+
+static inline void swap_keys(sort_key_t *a, sort_key_t *b)
+{
+	sort_key_t c = *a;
+	*a = *b;
+	*b = c;
+}
+
+/*
+ * Count the number of times each byte value appears in the arrays of keys to sort at the current
+ * offset, keeping track of the number of non-empty bins, and the index of the first and last
+ * non-empty bin.
+ */
+static inline void measure_bins(const struct task task, struct histogram *bins)
+{
+	sort_key_t *key_ptr;
+
+	/*
+	 * Subtle invariant: bins->used and bins->size[] are zero because the sorting code clears
+	 * it all out as it goes. Even though this structure is re-used, we don't need to pay to
+	 * zero it before starting a new tally.
+	 */
+	bins->first = U8_MAX;
+	bins->last = 0;
+
+	for (key_ptr = task.first_key; key_ptr <= task.last_key; key_ptr++) {
+		/* Increment the count for the byte in the key at the current offset. */
+		u8 bin = (*key_ptr)[task.offset];
+		u32 size = ++bins->size[bin];
+
+		/* Track non-empty bins. */
+		if (size == 1) {
+			bins->used += 1;
+			if (bin < bins->first)
+				bins->first = bin;
+
+			if (bin > bins->last)
+				bins->last = bin;
+		}
+	}
+}
+
+/*
+ * Convert the bin sizes to pointers to where each pile goes.
+ *
+ *   pile[0] = first_key + bin->size[0],
+ *   pile[1] = pile[0]  + bin->size[1], etc.
+ *
+ * After the keys are moved to the appropriate pile, we'll need to sort each of the piles by the
+ * next radix position. A new task is put on the stack for each pile containing lots of keys, or a
+ * new task is put on the list for each pile containing few keys.
+ *
+ * @stack: pointer the top of the stack
+ * @end_of_stack: the end of the stack
+ * @list: pointer the head of the list
+ * @pile: array for pointers to the end of each pile
+ * @bins: the histogram of the sizes of each pile
+ * @first_key: the first key of the stack
+ * @offset: the next radix position to sort by
+ * @length: the number of bytes remaining in the sort keys
+ *
+ * Return: UDS_SUCCESS or an error code
+ */
+static inline int push_bins(struct task **stack,
+			    struct task *end_of_stack,
+			    struct task **list,
+			    sort_key_t *pile[],
+			    struct histogram *bins,
+			    sort_key_t *first_key,
+			    u16 offset,
+			    u16 length)
+{
+	sort_key_t *pile_start = first_key;
+	int bin;
+
+	for (bin = bins->first; ; bin++) {
+		u32 size = bins->size[bin];
+
+		/* Skip empty piles. */
+		if (size == 0)
+			continue;
+
+		/* There's no need to sort empty keys. */
+		if (length > 0) {
+			if (size > INSERTION_SORT_THRESHOLD) {
+				if (*stack >= end_of_stack)
+					return UDS_BAD_STATE;
+
+				push_task(stack, pile_start, size, offset, length);
+			} else if (size > 1) {
+				push_task(list, pile_start, size, offset, length);
+			}
+		}
+
+		pile_start += size;
+		pile[bin] = pile_start;
+		if (--bins->used == 0)
+			break;
+	}
+
+	return UDS_SUCCESS;
+}
+
+int uds_make_radix_sorter(unsigned int count, struct radix_sorter **sorter)
+{
+	int result;
+	unsigned int stack_size = count / INSERTION_SORT_THRESHOLD;
+	struct radix_sorter *radix_sorter;
+
+	result = UDS_ALLOCATE_EXTENDED(struct radix_sorter,
+				       stack_size,
+				       struct task,
+				       __func__,
+				       &radix_sorter);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	radix_sorter->count = count;
+	radix_sorter->end_of_stack = radix_sorter->stack + stack_size;
+	*sorter = radix_sorter;
+	return UDS_SUCCESS;
+}
+
+void uds_free_radix_sorter(struct radix_sorter *sorter)
+{
+	UDS_FREE(sorter);
+}
+
+/*
+ * Sort pointers to fixed-length keys (arrays of bytes) using a radix sort. The sort implementation
+ * is unstable, so the relative ordering of equal keys is not preserved.
+ */
+int uds_radix_sort(struct radix_sorter *sorter,
+		   const unsigned char *keys[],
+		   unsigned int count,
+		   unsigned short length)
+{
+	struct task start;
+	struct histogram *bins = &sorter->bins;
+	sort_key_t **pile = sorter->pile;
+	struct task *task_stack = sorter->stack;
+
+	/* All zero-length keys are identical and therefore already sorted. */
+	if ((count == 0) || (length == 0))
+		return UDS_SUCCESS;
+
+	/* The initial task is to sort the entire length of all the keys. */
+	start = (struct task) {
+		.first_key = keys,
+		.last_key = &keys[count - 1],
+		.offset = 0,
+		.length = length,
+	};
+
+	if (count <= INSERTION_SORT_THRESHOLD) {
+		insertion_sort(start);
+		return UDS_SUCCESS;
+	}
+
+	if (count > sorter->count)
+		return UDS_INVALID_ARGUMENT;
+
+	/*
+	 * Repeatedly consume a sorting task from the stack and process it, pushing new sub-tasks
+	 * onto the stack for each radix-sorted pile. When all tasks and sub-tasks have been
+	 * processed, the stack will be empty and all the keys in the starting task will be fully
+	 * sorted.
+	 */
+	for (*task_stack = start; task_stack >= sorter->stack; task_stack--) {
+		const struct task task = *task_stack;
+		struct task *insertion_task_list;
+		int result;
+		sort_key_t *fence;
+		sort_key_t *end;
+
+		measure_bins(task, bins);
+
+		/*
+		 * Now that we know how large each bin is, generate pointers for each of the piles
+		 * and push a new task to sort each pile by the next radix byte.
+		 */
+		insertion_task_list = sorter->insertion_list;
+		result = push_bins(&task_stack,
+				   sorter->end_of_stack,
+				   &insertion_task_list,
+				   pile,
+				   bins,
+				   task.first_key,
+				   task.offset + 1,
+				   task.length - 1);
+		if (result != UDS_SUCCESS) {
+			memset(bins, 0, sizeof(*bins));
+			return result;
+		}
+
+		/* Now bins->used is zero again. */
+
+		/*
+		 * Don't bother processing the last pile: when piles 0..N-1 are all in place, then
+		 * pile N must also be in place.
+		 */
+		end = task.last_key - bins->size[bins->last];
+		bins->size[bins->last] = 0;
+
+		for (fence = task.first_key; fence <= end; ) {
+			u8 bin;
+			sort_key_t key = *fence;
+
+			/*
+			 * The radix byte of the key tells us which pile it belongs in. Swap it for
+			 * an unprocessed item just below that pile, and repeat.
+			 */
+			while (--pile[bin = key[task.offset]] > fence)
+				swap_keys(pile[bin], &key);
+
+			/*
+			 * The pile reached the fence. Put the key at the bottom of that pile,
+			 * completing it, and advance the fence to the next pile.
+			 */
+			*fence = key;
+			fence += bins->size[bin];
+			bins->size[bin] = 0;
+		}
+
+		/* Now bins->size[] is all zero again. */
+
+		/*
+		 * When the number of keys in a task gets small enough, it is faster to use an
+		 * insertion sort than to keep subdividing into tiny piles.
+		 */
+		while (--insertion_task_list >= sorter->insertion_list)
+			insertion_sort(*insertion_task_list);
+	}
+
+	return UDS_SUCCESS;
+}
diff --git a/drivers/md/dm-vdo/radix-sort.h b/drivers/md/dm-vdo/radix-sort.h
new file mode 100644
index 00000000000..36f3efa9324
--- /dev/null
+++ b/drivers/md/dm-vdo/radix-sort.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_RADIX_SORT_H
+#define UDS_RADIX_SORT_H
+
+/*
+ * Radix sort is implemented using an American Flag sort, an unstable, in-place 8-bit radix
+ * exchange sort. This is adapted from the algorithm in the paper by Peter M. McIlroy, Keith
+ * Bostic, and M. Douglas McIlroy, "Engineering Radix Sort".
+ *
+ * http://www.usenix.org/publications/compsystems/1993/win_mcilroy.pdf
+ */
+
+struct radix_sorter;
+
+int __must_check uds_make_radix_sorter(unsigned int count, struct radix_sorter **sorter);
+
+void uds_free_radix_sorter(struct radix_sorter *sorter);
+
+int __must_check uds_radix_sort(struct radix_sorter *sorter,
+				const unsigned char *keys[],
+				unsigned int count,
+				unsigned short length);
+
+#endif /* UDS_RADIX_SORT_H */
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
new file mode 100644
index 00000000000..a05df5483aa
--- /dev/null
+++ b/drivers/md/dm-vdo/volume.c
@@ -0,0 +1,1792 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "volume.h"
+
+#include <linux/atomic.h>
+#include <linux/dm-bufio.h>
+#include <linux/err.h>
+
+#include "chapter-index.h"
+#include "config.h"
+#include "errors.h"
+#include "geometry.h"
+#include "hash-utils.h"
+#include "index.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+#include "sparse-cache.h"
+#include "string-utils.h"
+#include "uds-threads.h"
+
+/*
+ * The first block of the volume layout is reserved for the volume header, which is no longer used.
+ * The remainder of the volume is divided into chapters consisting of several pages of records, and
+ * several pages of static index to use to find those records. The index pages are recorded first,
+ * followed by the record pages. The chapters are written in order as they are filled, so the
+ * volume storage acts as a circular log of the most recent chapters, with each new chapter
+ * overwriting the oldest saved one.
+ *
+ * When a new chapter is filled and closed, the records from that chapter are sorted and
+ * interleaved in approximate temporal order, and assigned to record pages. Then a static delta
+ * index is generated to store which record page contains each record. The in-memory index page map
+ * is also updated to indicate which delta lists fall on each chapter index page. This means that
+ * when a record is read, the volume only has to load a single index page and a single record page,
+ * rather than search the entire chapter. These index and record pages are written to storage, and
+ * the index pages are transferred to the page cache under the theory that the most recently
+ * written chapter is likely to be accessed again soon.
+ *
+ * When reading a record, the volume index will indicate which chapter should contain it. The
+ * volume uses the index page map to determine which chapter index page needs to be loaded, and
+ * then reads the relevant record page number from the chapter index. Both index and record pages
+ * are stored in a page cache when read for the common case that subsequent records need the same
+ * pages. The page cache evicts the least recently accessed entries when caching new pages. In
+ * addition, the volume uses dm-bufio to manage access to the storage, which may allow for
+ * additional caching depending on available system resources.
+ *
+ * Record requests are handled from cached pages when possible. If a page needs to be read, it is
+ * placed on a queue along with the request that wants to read it. Any requests for the same page
+ * that arrive while the read is pending are added to the queue entry. A separate reader thread
+ * handles the queued reads, adding the page to the cache and updating any requests queued with it
+ * so they can continue processing. This allows the index zone threads to continue processing new
+ * requests rather than wait for the storage reads.
+ *
+ * When an index rebuild is necessary, the volume reads each stored chapter to determine which
+ * range of chapters contain valid records, so that those records can be used to reconstruct the
+ * in-memory volume index.
+ */
+
+enum {
+	/* The maximum allowable number of contiguous bad chapters */
+	MAX_BAD_CHAPTERS = 100,
+	VOLUME_CACHE_MAX_ENTRIES = (U16_MAX >> 1),
+	VOLUME_CACHE_QUEUED_FLAG = (1 << 15),
+	VOLUME_CACHE_MAX_QUEUED_READS = 4096,
+};
+
+static const u64 BAD_CHAPTER = U64_MAX;
+
+/*
+ * The invalidate counter is two 32 bits fields stored together atomically. The low order 32 bits
+ * are the physical page number of the cached page being read. The high order 32 bits are a
+ * sequence number. This value is written when the zone that owns it begins or completes a cache
+ * search. Any other thread will only read the counter in wait_for_pending_searches() while waiting
+ * to update the cache contents.
+ */
+union invalidate_counter {
+	u64 value;
+	struct {
+		u32 page;
+		u32 counter;
+	};
+};
+
+static inline u32 map_to_page_number(struct geometry *geometry, u32 physical_page)
+{
+	return (physical_page - HEADER_PAGES_PER_VOLUME) % geometry->pages_per_chapter;
+}
+
+static inline u32 map_to_chapter_number(struct geometry *geometry, u32 physical_page)
+{
+	return (physical_page - HEADER_PAGES_PER_VOLUME) / geometry->pages_per_chapter;
+}
+
+static inline bool is_record_page(struct geometry *geometry, u32 physical_page)
+{
+	return map_to_page_number(geometry, physical_page) >= geometry->index_pages_per_chapter;
+}
+
+static u32 map_to_physical_page(const struct geometry *geometry, u32 chapter, u32 page)
+{
+	/* Page zero is the header page, so the first chapter index page is page one. */
+	return HEADER_PAGES_PER_VOLUME + (geometry->pages_per_chapter * chapter) + page;
+}
+
+static inline union invalidate_counter
+get_invalidate_counter(struct page_cache *cache, unsigned int zone_number)
+{
+	return (union invalidate_counter) {
+		.value = READ_ONCE(cache->search_pending_counters[zone_number].atomic_value),
+	};
+}
+
+static inline void set_invalidate_counter(struct page_cache *cache,
+					  unsigned int zone_number,
+					  union invalidate_counter invalidate_counter)
+{
+	WRITE_ONCE(cache->search_pending_counters[zone_number].atomic_value,
+		   invalidate_counter.value);
+}
+
+static inline bool search_pending(union invalidate_counter invalidate_counter)
+{
+	return (invalidate_counter.counter & 1) != 0;
+}
+
+/* Lock the cache for a zone in order to search for a page. */
+static void
+begin_pending_search(struct page_cache *cache, u32 physical_page, unsigned int zone_number)
+{
+	union invalidate_counter invalidate_counter = get_invalidate_counter(cache, zone_number);
+
+	invalidate_counter.page = physical_page;
+	invalidate_counter.counter++;
+	set_invalidate_counter(cache, zone_number, invalidate_counter);
+	ASSERT_LOG_ONLY(search_pending(invalidate_counter),
+			"Search is pending for zone %u",
+			zone_number);
+	/*
+	 * This memory barrier ensures that the write to the invalidate counter is seen by other
+	 * threads before this thread accesses the cached page. The corresponding read memory
+	 * barrier is in wait_for_pending_searches().
+	 */
+	smp_mb();
+}
+
+/* Unlock the cache for a zone by clearing its invalidate counter. */
+static void end_pending_search(struct page_cache *cache, unsigned int zone_number)
+{
+	union invalidate_counter invalidate_counter;
+
+	/*
+	 * This memory barrier ensures that this thread completes reads of the
+	 * cached page before other threads see the write to the invalidate
+	 * counter.
+	 */
+	smp_mb();
+
+	invalidate_counter = get_invalidate_counter(cache, zone_number);
+	ASSERT_LOG_ONLY(search_pending(invalidate_counter),
+			"Search is pending for zone %u",
+			zone_number);
+	invalidate_counter.counter++;
+	set_invalidate_counter(cache, zone_number, invalidate_counter);
+}
+
+static void wait_for_pending_searches(struct page_cache *cache, u32 physical_page)
+{
+	union invalidate_counter initial_counters[MAX_ZONES];
+	unsigned int i;
+
+	/*
+	 * We hold the read_threads_mutex. We are waiting for threads that do not hold the
+	 * read_threads_mutex. Those threads have "locked" their targeted page by setting the
+	 * search_pending_counter. The corresponding write memory barrier is in
+	 * begin_pending_search().
+	 */
+	smp_mb();
+
+	for (i = 0; i < cache->zone_count; i++)
+		initial_counters[i] = get_invalidate_counter(cache, i);
+	for (i = 0; i < cache->zone_count; i++)
+		if (search_pending(initial_counters[i]) &&
+		    (initial_counters[i].page == physical_page))
+			/*
+			 * There is an active search using the physical page. We need to wait for
+			 * the search to finish.
+			 *
+			 * FIXME: Investigate using wait_event() to wait for the search to finish.
+			 */
+			while (initial_counters[i].value == get_invalidate_counter(cache, i).value)
+				cond_resched();
+}
+
+static void release_page_buffer(struct cached_page *page)
+{
+	if (page->buffer != NULL)
+		dm_bufio_release(UDS_FORGET(page->buffer));
+}
+
+static void clear_cache_page(struct page_cache *cache, struct cached_page *page)
+{
+	/* Do not clear read_pending because the read queue relies on it. */
+	release_page_buffer(page);
+	page->physical_page = cache->indexable_pages;
+	WRITE_ONCE(page->last_used, 0);
+}
+
+static void make_page_most_recent(struct page_cache *cache, struct cached_page *page)
+{
+	/*
+	 * ASSERTION: We are either a zone thread holding a search_pending_counter, or we are any
+	 * thread holding the read_threads_mutex.
+	 */
+	if (atomic64_read(&cache->clock) != READ_ONCE(page->last_used))
+		WRITE_ONCE(page->last_used, atomic64_inc_return(&cache->clock));
+}
+
+/* Select a page to remove from the cache to make space for a new entry. */
+static struct cached_page *select_victim_in_cache(struct page_cache *cache)
+{
+	struct cached_page *page;
+	int oldest_index = 0;
+	s64 oldest_time = S64_MAX;
+	s64 last_used;
+	u16 i;
+
+	/* Find the oldest unclaimed page. We hold the read_threads_mutex. */
+	for (i = 0; i < cache->cache_slots; i++) {
+		/* A page with a pending read must not be replaced. */
+		if (cache->cache[i].read_pending)
+			continue;
+
+		last_used = READ_ONCE(cache->cache[i].last_used);
+		if (last_used <= oldest_time) {
+			oldest_time = last_used;
+			oldest_index = i;
+		}
+	}
+
+	page = &cache->cache[oldest_index];
+	if (page->physical_page != cache->indexable_pages) {
+		WRITE_ONCE(cache->index[page->physical_page], cache->cache_slots);
+		wait_for_pending_searches(cache, page->physical_page);
+	}
+
+	page->read_pending = true;
+	clear_cache_page(cache, page);
+	return page;
+}
+
+/* Make a newly filled cache entry available to other threads. */
+static int
+put_page_in_cache(struct page_cache *cache, u32 physical_page, struct cached_page *page)
+{
+	int result;
+
+	/* We hold the read_threads_mutex. */
+	result = ASSERT((page->read_pending), "page to install has a pending read");
+	if (result != UDS_SUCCESS)
+		return result;
+
+	page->physical_page = physical_page;
+	make_page_most_recent(cache, page);
+	page->read_pending = false;
+
+	/*
+	 * We hold the read_threads_mutex, but we must have a write memory barrier before making
+	 * the cached_page available to the readers that do not hold the mutex. The corresponding
+	 * read memory barrier is in get_page_and_index().
+	 */
+	smp_wmb();
+
+	/* This assignment also clears the queued flag. */
+	WRITE_ONCE(cache->index[physical_page], page - cache->cache);
+	return UDS_SUCCESS;
+}
+
+static void cancel_page_in_cache(struct page_cache *cache,
+				 u32 physical_page,
+				 struct cached_page *page)
+{
+	int result;
+
+	/* We hold the read_threads_mutex. */
+	result = ASSERT((page->read_pending), "page to install has a pending read");
+	if (result != UDS_SUCCESS)
+		return;
+
+	clear_cache_page(cache, page);
+	page->read_pending = false;
+
+	/* Clear the mapping and the queued flag for the new page. */
+	WRITE_ONCE(cache->index[physical_page], cache->cache_slots);
+}
+
+static inline u16 next_queue_position(u16 position)
+{
+	return (position + 1) % VOLUME_CACHE_MAX_QUEUED_READS;
+}
+
+static inline void advance_queue_position(u16 *position)
+{
+	*position = next_queue_position(*position);
+}
+
+static inline bool read_queue_is_full(struct page_cache *cache)
+{
+	return cache->read_queue_first == next_queue_position(cache->read_queue_last);
+}
+
+static bool
+enqueue_read(struct page_cache *cache, struct uds_request *request, u32 physical_page)
+{
+	struct queued_read *queue_entry;
+	u16 last = cache->read_queue_last;
+	u16 read_queue_index;
+
+	/* We hold the read_threads_mutex. */
+	if ((cache->index[physical_page] & VOLUME_CACHE_QUEUED_FLAG) == 0) {
+		/* This page has no existing entry in the queue. */
+		if (read_queue_is_full(cache))
+			return false;
+
+		/* Fill in the read queue entry. */
+		cache->read_queue[last].physical_page = physical_page;
+		cache->read_queue[last].invalid = false;
+		cache->read_queue[last].first_request = NULL;
+		cache->read_queue[last].last_request = NULL;
+
+		/* Point the cache index to the read queue entry. */
+		read_queue_index = last;
+		WRITE_ONCE(cache->index[physical_page],
+			   read_queue_index | VOLUME_CACHE_QUEUED_FLAG);
+
+		advance_queue_position(&cache->read_queue_last);
+	} else {
+		/* It's already queued, so add this request to the existing entry. */
+		read_queue_index = cache->index[physical_page] & ~VOLUME_CACHE_QUEUED_FLAG;
+	}
+
+	request->next_request = NULL;
+	queue_entry = &cache->read_queue[read_queue_index];
+	if (queue_entry->first_request == NULL)
+		queue_entry->first_request = request;
+	else
+		queue_entry->last_request->next_request = request;
+	queue_entry->last_request = request;
+
+	return true;
+}
+
+static void
+enqueue_page_read(struct volume *volume, struct uds_request *request, u32 physical_page)
+{
+	/* Mark the page as queued, so that chapter invalidation knows to cancel a read. */
+	while (!enqueue_read(&volume->page_cache, request, physical_page)) {
+		uds_log_debug("Read queue full, waiting for reads to finish");
+		uds_wait_cond(&volume->read_threads_read_done_cond, &volume->read_threads_mutex);
+	}
+
+	uds_signal_cond(&volume->read_threads_cond);
+}
+
+/*
+ * Reserve the next read queue entry for processing, but do not actually remove it from the queue.
+ * Must be followed by release_queued_requests().
+ */
+static struct queued_read *reserve_read_queue_entry(struct page_cache *cache)
+{
+	/* We hold the read_threads_mutex. */
+	struct queued_read *entry;
+	u16 index_value;
+	bool queued;
+
+	/* No items to dequeue */
+	if (cache->read_queue_next_read == cache->read_queue_last)
+		return NULL;
+
+	entry = &cache->read_queue[cache->read_queue_next_read];
+	index_value = cache->index[entry->physical_page];
+	queued = (index_value & VOLUME_CACHE_QUEUED_FLAG) != 0;
+	/* Check to see if it's still queued before resetting. */
+	if (entry->invalid && queued)
+		WRITE_ONCE(cache->index[entry->physical_page], cache->cache_slots);
+
+	/*
+	 * If a synchronous read has taken this page, set invalid to true so it doesn't get
+	 * overwritten. Requests will just be requeued.
+	 */
+	if (!queued)
+		entry->invalid = true;
+
+	entry->reserved = true;
+	advance_queue_position(&cache->read_queue_next_read);
+	return entry;
+}
+
+static inline struct queued_read *wait_to_reserve_read_queue_entry(struct volume *volume)
+{
+	struct queued_read *queue_entry = NULL;
+
+	while (!volume->read_threads_exiting) {
+		queue_entry = reserve_read_queue_entry(&volume->page_cache);
+		if (queue_entry != NULL)
+			break;
+
+		uds_wait_cond(&volume->read_threads_cond, &volume->read_threads_mutex);
+	}
+
+	return queue_entry;
+}
+
+static int init_chapter_index_page(const struct volume *volume,
+				   u8 *index_page,
+				   u32 chapter,
+				   u32 index_page_number,
+				   struct delta_index_page *chapter_index_page)
+{
+	u64 ci_virtual;
+	u32 ci_chapter;
+	u32 lowest_list;
+	u32 highest_list;
+	struct geometry *geometry = volume->geometry;
+	int result;
+
+	result = uds_initialize_chapter_index_page(chapter_index_page,
+						   geometry,
+						   index_page,
+						   volume->nonce);
+	if (volume->lookup_mode == LOOKUP_FOR_REBUILD)
+		return result;
+
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result,
+					      "Reading chapter index page for chapter %u page %u",
+					      chapter,
+					      index_page_number);
+
+	uds_get_list_number_bounds(volume->index_page_map,
+				   chapter,
+				   index_page_number,
+				   &lowest_list,
+				   &highest_list);
+	ci_virtual = chapter_index_page->virtual_chapter_number;
+	ci_chapter = uds_map_to_physical_chapter(geometry, ci_virtual);
+	if ((chapter == ci_chapter) &&
+	    (lowest_list == chapter_index_page->lowest_list_number) &&
+	    (highest_list == chapter_index_page->highest_list_number))
+		return UDS_SUCCESS;
+
+	uds_log_warning("Index page map updated to %llu",
+			(unsigned long long) volume->index_page_map->last_update);
+	uds_log_warning("Page map expects that chapter %u page %u has range %u to %u, but chapter index page has chapter %llu with range %u to %u",
+			chapter,
+			index_page_number,
+			lowest_list,
+			highest_list,
+			(unsigned long long) ci_virtual,
+			chapter_index_page->lowest_list_number,
+			chapter_index_page->highest_list_number);
+	return uds_log_error_strerror(UDS_CORRUPT_DATA,
+				      "index page map mismatch with chapter index");
+}
+
+static int initialize_index_page(const struct volume *volume,
+				 u32 physical_page,
+				 struct cached_page *page)
+{
+	u32 chapter = map_to_chapter_number(volume->geometry, physical_page);
+	u32 index_page_number = map_to_page_number(volume->geometry, physical_page);
+
+	return init_chapter_index_page(volume,
+				       dm_bufio_get_block_data(page->buffer),
+				       chapter,
+				       index_page_number,
+				       &page->index_page);
+}
+
+static bool
+search_record_page(const u8 record_page[],
+		   const struct uds_record_name *name,
+		   const struct geometry *geometry,
+		   struct uds_record_data *metadata)
+{
+	/*
+	 * The array of records is sorted by name and stored as a binary tree in heap order, so the
+	 * root of the tree is the first array element.
+	 */
+	u32 node = 0;
+	const struct uds_volume_record *records = (const struct uds_volume_record *) record_page;
+
+	while (node < geometry->records_per_page) {
+		int result;
+		const struct uds_volume_record *record = &records[node];
+
+		result = memcmp(name, &record->name, UDS_RECORD_NAME_SIZE);
+		if (result == 0) {
+			if (metadata != NULL)
+				*metadata = record->data;
+			return true;
+		}
+
+		/* The children of node N are at indexes 2N+1 and 2N+2. */
+		node = ((2 * node) + ((result < 0) ? 1 : 2));
+	}
+
+	return false;
+}
+
+/*
+ * If we've read in a record page, we're going to do an immediate search, to speed up processing by
+ * avoiding get_record_from_zone(), and to ensure that requests make progress even when queued. If
+ * we've read in an index page, we save the record page number so we don't have to resolve the
+ * index page again. We use the location, virtual_chapter, and old_metadata fields in the request
+ * to allow the index code to know where to begin processing the request again.
+ */
+static int search_page(struct cached_page *page,
+		       const struct volume *volume,
+		       struct uds_request *request,
+		       u32 physical_page)
+{
+	int result;
+	enum uds_index_region location;
+	u16 record_page_number;
+
+	if (is_record_page(volume->geometry, physical_page)) {
+		if (search_record_page(dm_bufio_get_block_data(page->buffer),
+				       &request->record_name,
+				       volume->geometry,
+				       &request->old_metadata))
+			location = UDS_LOCATION_RECORD_PAGE_LOOKUP;
+		else
+			location = UDS_LOCATION_UNAVAILABLE;
+	} else {
+		result = uds_search_chapter_index_page(&page->index_page,
+						       volume->geometry,
+						       &request->record_name,
+						       &record_page_number);
+		if (result != UDS_SUCCESS)
+			return result;
+
+		if (record_page_number == NO_CHAPTER_INDEX_ENTRY) {
+			location = UDS_LOCATION_UNAVAILABLE;
+		} else {
+			location = UDS_LOCATION_INDEX_PAGE_LOOKUP;
+			*((u16 *) &request->old_metadata) = record_page_number;
+		}
+	}
+
+	request->location = location;
+	request->found = false;
+	return UDS_SUCCESS;
+}
+
+static int process_entry(struct volume *volume, struct queued_read *entry)
+{
+	u32 page_number = entry->physical_page;
+	struct uds_request *request;
+	struct cached_page *page = NULL;
+	u8 *page_data;
+	int result;
+
+	if (entry->invalid) {
+		uds_log_debug("Requeuing requests for invalid page");
+		return UDS_SUCCESS;
+	}
+
+	page = select_victim_in_cache(&volume->page_cache);
+
+	uds_unlock_mutex(&volume->read_threads_mutex);
+	page_data = dm_bufio_read(volume->client, page_number, &page->buffer);
+	if (IS_ERR(page_data)) {
+		result = -PTR_ERR(page_data);
+		uds_log_warning_strerror(result,
+					 "error reading physical page %u from volume",
+					 page_number);
+		cancel_page_in_cache(&volume->page_cache, page_number, page);
+		return result;
+	}
+	uds_lock_mutex(&volume->read_threads_mutex);
+
+	if (entry->invalid) {
+		uds_log_warning("Page %u invalidated after read", page_number);
+		cancel_page_in_cache(&volume->page_cache, page_number, page);
+		return UDS_SUCCESS;
+	}
+
+	if (!is_record_page(volume->geometry, page_number)) {
+		result = initialize_index_page(volume, page_number, page);
+		if (result != UDS_SUCCESS) {
+			uds_log_warning("Error initializing chapter index page");
+			cancel_page_in_cache(&volume->page_cache, page_number, page);
+			return result;
+		}
+	}
+
+	result = put_page_in_cache(&volume->page_cache, page_number, page);
+	if (result != UDS_SUCCESS) {
+		uds_log_warning("Error putting page %u in cache", page_number);
+		cancel_page_in_cache(&volume->page_cache, page_number, page);
+		return result;
+	}
+
+	request = entry->first_request;
+	while ((request != NULL) && (result == UDS_SUCCESS)) {
+		result = search_page(page, volume, request, page_number);
+		request = request->next_request;
+	}
+
+	return result;
+}
+
+static void release_queued_requests(struct volume *volume, struct queued_read *entry, int result)
+{
+	struct page_cache *cache = &volume->page_cache;
+	u16 next_read = cache->read_queue_next_read;
+	struct uds_request *request;
+	struct uds_request *next;
+
+	for (request = entry->first_request; request != NULL; request = next) {
+		next = request->next_request;
+		request->status = result;
+		request->requeued = true;
+		uds_enqueue_request(request, STAGE_INDEX);
+	}
+
+	entry->reserved = false;
+
+	/* Move the read_queue_first pointer as far as we can. */
+	while ((cache->read_queue_first != next_read) &&
+	       (!cache->read_queue[cache->read_queue_first].reserved))
+		advance_queue_position(&cache->read_queue_first);
+	uds_broadcast_cond(&volume->read_threads_read_done_cond);
+}
+
+static void read_thread_function(void *arg)
+{
+	struct volume *volume = arg;
+
+	uds_log_debug("reader starting");
+	uds_lock_mutex(&volume->read_threads_mutex);
+	while (true) {
+		struct queued_read *queue_entry;
+		int result;
+
+		queue_entry = wait_to_reserve_read_queue_entry(volume);
+		if (volume->read_threads_exiting)
+			break;
+
+		result = process_entry(volume, queue_entry);
+		release_queued_requests(volume, queue_entry, result);
+	}
+	uds_unlock_mutex(&volume->read_threads_mutex);
+	uds_log_debug("reader done");
+}
+
+static void get_page_and_index(struct page_cache *cache,
+			       u32 physical_page,
+			       int *queue_index,
+			       struct cached_page **page_ptr)
+{
+	u16 index_value;
+	u16 index;
+	bool queued;
+
+	/*
+	 * ASSERTION: We are either a zone thread holding a search_pending_counter, or we are any
+	 * thread holding the read_threads_mutex.
+	 *
+	 * Holding only a search_pending_counter is the most frequent case.
+	 */
+	/*
+	 * It would be unlikely for the compiler to turn the usage of index_value into two reads of
+	 * cache->index, but it would be possible and very bad if those reads did not return the
+	 * same bits.
+	 */
+	index_value = READ_ONCE(cache->index[physical_page]);
+	queued = (index_value & VOLUME_CACHE_QUEUED_FLAG) != 0;
+	index = index_value & ~VOLUME_CACHE_QUEUED_FLAG;
+
+	if (!queued && (index < cache->cache_slots)) {
+		*page_ptr = &cache->cache[index];
+		/*
+		 * We have acquired access to the cached page, but unless we hold the
+		 * read_threads_mutex, we need a read memory barrier now. The corresponding write
+		 * memory barrier is in put_page_in_cache().
+		 */
+		smp_rmb();
+	} else {
+		*page_ptr = NULL;
+	}
+
+	*queue_index = queued ? index : -1;
+}
+
+static void
+get_page_from_cache(struct page_cache *cache, u32 physical_page, struct cached_page **page)
+{
+	/*
+	 * ASSERTION: We are in a zone thread.
+	 * ASSERTION: We holding a search_pending_counter or the read_threads_mutex.
+	 */
+	int queue_index = -1;
+
+	get_page_and_index(cache, physical_page, &queue_index, page);
+}
+
+static int read_page_locked(struct volume *volume,
+			    u32 physical_page,
+			    struct cached_page **page_ptr)
+{
+	int result = UDS_SUCCESS;
+	struct cached_page *page = NULL;
+	u8 *page_data;
+
+	page = select_victim_in_cache(&volume->page_cache);
+	page_data = dm_bufio_read(volume->client, physical_page, &page->buffer);
+	if (IS_ERR(page_data)) {
+		result = -PTR_ERR(page_data);
+		uds_log_warning_strerror(result,
+					 "error reading physical page %u from volume",
+					 physical_page);
+		cancel_page_in_cache(&volume->page_cache, physical_page, page);
+		return result;
+	}
+
+	if (!is_record_page(volume->geometry, physical_page)) {
+		result = initialize_index_page(volume, physical_page, page);
+		if (result != UDS_SUCCESS) {
+			if (volume->lookup_mode != LOOKUP_FOR_REBUILD)
+				uds_log_warning("Corrupt index page %u", physical_page);
+			cancel_page_in_cache(&volume->page_cache, physical_page, page);
+			return result;
+		}
+	}
+
+	result = put_page_in_cache(&volume->page_cache, physical_page, page);
+	if (result != UDS_SUCCESS) {
+		uds_log_warning("Error putting page %u in cache", physical_page);
+		cancel_page_in_cache(&volume->page_cache, physical_page, page);
+		return result;
+	}
+
+	*page_ptr = page;
+	return UDS_SUCCESS;
+}
+
+/* Retrieve a page from the cache while holding the read threads mutex. */
+static int
+get_volume_page_locked(struct volume *volume, u32 physical_page, struct cached_page **page_ptr)
+{
+	int result;
+	struct cached_page *page = NULL;
+
+	get_page_from_cache(&volume->page_cache, physical_page, &page);
+	if (page == NULL) {
+		result = read_page_locked(volume, physical_page, &page);
+		if (result != UDS_SUCCESS)
+			return result;
+	} else {
+		make_page_most_recent(&volume->page_cache, page);
+	}
+
+	*page_ptr = page;
+	return UDS_SUCCESS;
+}
+
+/* Retrieve a page from the cache while holding a search_pending lock. */
+static int
+get_volume_page_protected(struct volume *volume,
+			  struct uds_request *request,
+			  u32 physical_page,
+			  struct cached_page **page_ptr)
+{
+	struct cached_page *page;
+
+	get_page_from_cache(&volume->page_cache, physical_page, &page);
+	if (page != NULL) {
+		if (request->zone_number == 0)
+			/* Only one zone is allowed to update the LRU. */
+			make_page_most_recent(&volume->page_cache, page);
+
+		*page_ptr = page;
+		return UDS_SUCCESS;
+	}
+
+	/* Prepare to enqueue a read for the page. */
+	end_pending_search(&volume->page_cache, request->zone_number);
+	uds_lock_mutex(&volume->read_threads_mutex);
+
+	/*
+	 * Do the lookup again while holding the read mutex (no longer the fast case so this should
+	 * be fine to repeat). We need to do this because a page may have been added to the cache
+	 * by a reader thread between the time we searched above and the time we went to actually
+	 * try to enqueue it below. This could result in us enqueuing another read for a page which
+	 * is already in the cache, which would mean we end up with two entries in the cache for
+	 * the same page.
+	 */
+	get_page_from_cache(&volume->page_cache, physical_page, &page);
+	if (page == NULL) {
+		enqueue_page_read(volume, request, physical_page);
+		/*
+		 * The performance gain from unlocking first, while "search pending" mode is off,
+		 * turns out to be significant in some cases. The page is not available yet so
+		 * the order does not matter for correctness as it does below.
+		 */
+		uds_unlock_mutex(&volume->read_threads_mutex);
+		begin_pending_search(&volume->page_cache, physical_page, request->zone_number);
+		return UDS_QUEUED;
+	}
+
+	/*
+	 * Now that the page is loaded, the volume needs to switch to "reader thread unlocked" and
+	 * "search pending" state in careful order so no other thread can mess with the data before
+	 * the caller gets to look at it.
+	 */
+	begin_pending_search(&volume->page_cache, physical_page, request->zone_number);
+	uds_unlock_mutex(&volume->read_threads_mutex);
+	*page_ptr = page;
+	return UDS_SUCCESS;
+}
+
+static int get_volume_page(struct volume *volume,
+			   u32 chapter,
+			   u32 page_number,
+			   struct cached_page **page_ptr)
+{
+	int result;
+	u32 physical_page = map_to_physical_page(volume->geometry, chapter, page_number);
+
+	uds_lock_mutex(&volume->read_threads_mutex);
+	result = get_volume_page_locked(volume, physical_page, page_ptr);
+	uds_unlock_mutex(&volume->read_threads_mutex);
+	return result;
+}
+
+int uds_get_volume_record_page(struct volume *volume, u32 chapter, u32 page_number, u8 **data_ptr)
+{
+	int result;
+	struct cached_page *page = NULL;
+
+	result = get_volume_page(volume, chapter, page_number, &page);
+	if (result == UDS_SUCCESS)
+		*data_ptr = dm_bufio_get_block_data(page->buffer);
+	return result;
+}
+
+int uds_get_volume_index_page(struct volume *volume,
+			      u32 chapter,
+			      u32 page_number,
+			      struct delta_index_page **index_page_ptr)
+{
+	int result;
+	struct cached_page *page = NULL;
+
+	result = get_volume_page(volume, chapter, page_number, &page);
+	if (result == UDS_SUCCESS)
+		*index_page_ptr = &page->index_page;
+	return result;
+}
+
+/*
+ * Find the record page associated with a name in a given index page. This will return UDS_QUEUED
+ * if the page in question must be read from storage.
+ */
+static int search_cached_index_page(struct volume *volume,
+				    struct uds_request *request,
+				    u32 chapter,
+				    u32 index_page_number,
+				    u16 *record_page_number)
+{
+	int result;
+	struct cached_page *page = NULL;
+	u32 physical_page = map_to_physical_page(volume->geometry, chapter, index_page_number);
+
+	/*
+	 * Make sure the invalidate counter is updated before we try and read the mapping. This
+	 * prevents this thread from reading a page in the cache which has already been marked for
+	 * invalidation by the reader thread, before the reader thread has noticed that the
+	 * invalidate_counter has been incremented.
+	 */
+	begin_pending_search(&volume->page_cache, physical_page, request->zone_number);
+
+	result = get_volume_page_protected(volume, request, physical_page, &page);
+	if (result != UDS_SUCCESS) {
+		end_pending_search(&volume->page_cache, request->zone_number);
+		return result;
+	}
+
+	result = uds_search_chapter_index_page(&page->index_page,
+					       volume->geometry,
+					       &request->record_name,
+					       record_page_number);
+	end_pending_search(&volume->page_cache, request->zone_number);
+	return result;
+}
+
+/*
+ * Find the metadata associated with a name in a given record page. This will return UDS_QUEUED if
+ * the page in question must be read from storage.
+ */
+int uds_search_cached_record_page(struct volume *volume,
+				  struct uds_request *request,
+				  u32 chapter,
+				  u16 record_page_number,
+				  bool *found)
+{
+	struct cached_page *record_page;
+	struct geometry *geometry = volume->geometry;
+	int result;
+	u32 physical_page, page_number;
+
+	*found = false;
+	if (record_page_number == NO_CHAPTER_INDEX_ENTRY)
+		return UDS_SUCCESS;
+
+	result = ASSERT(record_page_number < geometry->record_pages_per_chapter,
+			"0 <= %d < %u",
+			record_page_number,
+			geometry->record_pages_per_chapter);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	page_number = geometry->index_pages_per_chapter + record_page_number;
+
+	physical_page = map_to_physical_page(volume->geometry, chapter, page_number);
+
+	/*
+	 * Make sure the invalidate counter is updated before we try and read the mapping. This
+	 * prevents this thread from reading a page in the cache which has already been marked for
+	 * invalidation by the reader thread, before the reader thread has noticed that the
+	 * invalidate_counter has been incremented.
+	 */
+	begin_pending_search(&volume->page_cache, physical_page, request->zone_number);
+
+	result = get_volume_page_protected(volume, request, physical_page, &record_page);
+	if (result != UDS_SUCCESS) {
+		end_pending_search(&volume->page_cache, request->zone_number);
+		return result;
+	}
+
+	if (search_record_page(dm_bufio_get_block_data(record_page->buffer),
+			       &request->record_name,
+			       geometry,
+			       &request->old_metadata))
+		*found = true;
+
+	end_pending_search(&volume->page_cache, request->zone_number);
+	return UDS_SUCCESS;
+}
+
+void uds_prefetch_volume_chapter(const struct volume *volume, u32 chapter)
+{
+	const struct geometry *geometry = volume->geometry;
+	u32 physical_page = map_to_physical_page(geometry, chapter, 0);
+
+	dm_bufio_prefetch(volume->client, physical_page, geometry->pages_per_chapter);
+}
+
+int uds_read_chapter_index_from_volume(const struct volume *volume,
+				       u64 virtual_chapter,
+				       struct dm_buffer *volume_buffers[],
+				       struct delta_index_page index_pages[])
+{
+	int result;
+	u32 i;
+	const struct geometry *geometry = volume->geometry;
+	u32 physical_chapter = uds_map_to_physical_chapter(geometry, virtual_chapter);
+	u32 physical_page = map_to_physical_page(geometry, physical_chapter, 0);
+
+	dm_bufio_prefetch(volume->client, physical_page, geometry->index_pages_per_chapter);
+	for (i = 0; i < geometry->index_pages_per_chapter; i++) {
+		u8 *index_page;
+
+		index_page = dm_bufio_read(volume->client, physical_page + i, &volume_buffers[i]);
+		if (IS_ERR(index_page)) {
+			result = -PTR_ERR(index_page);
+			uds_log_warning_strerror(result,
+						 "error reading physical page %u",
+						 physical_page);
+			return result;
+		}
+
+		result = init_chapter_index_page(volume,
+						 index_page,
+						 physical_chapter,
+						 i,
+						 &index_pages[i]);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	return UDS_SUCCESS;
+}
+
+int uds_search_volume_page_cache(struct volume *volume, struct uds_request *request, bool *found)
+{
+	int result;
+	u32 physical_chapter =
+		uds_map_to_physical_chapter(volume->geometry, request->virtual_chapter);
+	u32 index_page_number;
+	u16 record_page_number;
+
+	index_page_number = uds_find_index_page_number(volume->index_page_map,
+						       &request->record_name,
+						       physical_chapter);
+
+	if (request->location == UDS_LOCATION_INDEX_PAGE_LOOKUP) {
+		record_page_number = *((u16 *) &request->old_metadata);
+	} else {
+		result = search_cached_index_page(volume,
+						  request,
+						  physical_chapter,
+						  index_page_number,
+						  &record_page_number);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	return uds_search_cached_record_page(volume,
+					     request,
+					     physical_chapter,
+					     record_page_number,
+					     found);
+}
+
+int uds_search_volume_page_cache_for_rebuild(struct volume *volume,
+					     const struct uds_record_name *name,
+					     u64 virtual_chapter,
+					     bool *found)
+{
+	int result;
+	struct geometry *geometry = volume->geometry;
+	struct cached_page *page;
+	u32 physical_chapter = uds_map_to_physical_chapter(geometry, virtual_chapter);
+	u32 index_page_number;
+	u16 record_page_number;
+	u32 page_number;
+
+	*found = false;
+	index_page_number =
+		uds_find_index_page_number(volume->index_page_map, name, physical_chapter);
+	result = get_volume_page(volume, physical_chapter, index_page_number, &page);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_search_chapter_index_page(&page->index_page,
+					       geometry,
+					       name,
+					       &record_page_number);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (record_page_number == NO_CHAPTER_INDEX_ENTRY)
+		return UDS_SUCCESS;
+
+	page_number = geometry->index_pages_per_chapter + record_page_number;
+	result = get_volume_page(volume, physical_chapter, page_number, &page);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	*found = search_record_page(dm_bufio_get_block_data(page->buffer), name, geometry, NULL);
+	return UDS_SUCCESS;
+}
+
+static void invalidate_page(struct page_cache *cache, u32 physical_page)
+{
+	struct cached_page *page;
+	int queue_index = -1;
+
+	/* We hold the read_threads_mutex. */
+	get_page_and_index(cache, physical_page, &queue_index, &page);
+	if (page != NULL) {
+		WRITE_ONCE(cache->index[page->physical_page], cache->cache_slots);
+		wait_for_pending_searches(cache, page->physical_page);
+		clear_cache_page(cache, page);
+	} else if (queue_index > -1) {
+		uds_log_debug("setting pending read to invalid");
+		cache->read_queue[queue_index].invalid = true;
+	}
+}
+
+void uds_forget_chapter(struct volume *volume, u64 virtual_chapter)
+{
+	u32 physical_chapter = uds_map_to_physical_chapter(volume->geometry, virtual_chapter);
+	u32 first_page = map_to_physical_page(volume->geometry, physical_chapter, 0);
+	u32 i;
+
+	uds_log_debug("forgetting chapter %llu", (unsigned long long) virtual_chapter);
+	uds_lock_mutex(&volume->read_threads_mutex);
+	for (i = 0; i < volume->geometry->pages_per_chapter; i++)
+		invalidate_page(&volume->page_cache, first_page + i);
+	uds_unlock_mutex(&volume->read_threads_mutex);
+}
+
+/*
+ * Donate an index pages from a newly written chapter to the page cache since it is likely to be
+ * used again soon. The caller must already hold the reader thread mutex.
+ */
+static int donate_index_page_locked(struct volume *volume,
+				    u32 physical_chapter,
+				    u32 index_page_number,
+				    struct dm_buffer *page_buffer)
+{
+	int result;
+	struct cached_page *page = NULL;
+	u32 physical_page =
+		map_to_physical_page(volume->geometry, physical_chapter, index_page_number);
+
+	page = select_victim_in_cache(&volume->page_cache);
+	page->buffer = page_buffer;
+	result = init_chapter_index_page(volume,
+					 dm_bufio_get_block_data(page_buffer),
+					 physical_chapter,
+					 index_page_number,
+					 &page->index_page);
+	if (result != UDS_SUCCESS) {
+		uds_log_warning("Error initialize chapter index page");
+		cancel_page_in_cache(&volume->page_cache, physical_page, page);
+		return result;
+	}
+
+	result = put_page_in_cache(&volume->page_cache, physical_page, page);
+	if (result != UDS_SUCCESS) {
+		uds_log_warning("Error putting page %u in cache", physical_page);
+		cancel_page_in_cache(&volume->page_cache, physical_page, page);
+		return result;
+	}
+
+	return UDS_SUCCESS;
+}
+
+static int write_index_pages(struct volume *volume,
+			     u32 physical_chapter_number,
+			     struct open_chapter_index *chapter_index)
+{
+	struct geometry *geometry = volume->geometry;
+	struct dm_buffer *page_buffer;
+	u32 first_index_page = map_to_physical_page(geometry, physical_chapter_number, 0);
+	u32 delta_list_number = 0;
+	u32 index_page_number;
+
+	for (index_page_number = 0;
+	     index_page_number < geometry->index_pages_per_chapter;
+	     index_page_number++) {
+		u8 *page_data;
+		u32 physical_page = first_index_page + index_page_number;
+		u32 lists_packed;
+		bool last_page;
+		int result;
+
+		page_data = dm_bufio_new(volume->client, physical_page, &page_buffer);
+		if (IS_ERR(page_data))
+			return uds_log_warning_strerror(-PTR_ERR(page_data),
+							"failed to prepare index page");
+
+		last_page = ((index_page_number + 1) == geometry->index_pages_per_chapter);
+		result = uds_pack_open_chapter_index_page(chapter_index,
+							  page_data,
+							  delta_list_number,
+							  last_page,
+							  &lists_packed);
+		if (result != UDS_SUCCESS) {
+			dm_bufio_release(page_buffer);
+			return uds_log_warning_strerror(result, "failed to pack index page");
+		}
+
+		dm_bufio_mark_buffer_dirty(page_buffer);
+
+		if (lists_packed == 0)
+			uds_log_debug("no delta lists packed on chapter %u page %u",
+				      physical_chapter_number,
+				      index_page_number);
+		else
+			delta_list_number += lists_packed;
+
+		uds_update_index_page_map(volume->index_page_map,
+					  chapter_index->virtual_chapter_number,
+					  physical_chapter_number,
+					  index_page_number,
+					  delta_list_number - 1);
+
+		uds_lock_mutex(&volume->read_threads_mutex);
+		result = donate_index_page_locked(volume,
+						  physical_chapter_number,
+						  index_page_number,
+						  page_buffer);
+		uds_unlock_mutex(&volume->read_threads_mutex);
+		if (result != UDS_SUCCESS) {
+			dm_bufio_release(page_buffer);
+			return result;
+		}
+	}
+
+	return UDS_SUCCESS;
+}
+
+static u32 encode_tree(u8 record_page[],
+		       const struct uds_volume_record *sorted_pointers[],
+		       u32 next_record,
+		       u32 node,
+		       u32 node_count)
+{
+	if (node < node_count) {
+		u32 child = (2 * node) + 1;
+
+		next_record = encode_tree(record_page,
+					  sorted_pointers,
+					  next_record,
+					  child,
+					  node_count);
+
+		/*
+		 * In-order traversal: copy the contents of the next record into the page at the
+		 * node offset.
+		 */
+		memcpy(&record_page[node * BYTES_PER_RECORD],
+		       sorted_pointers[next_record++],
+		       BYTES_PER_RECORD);
+
+		next_record = encode_tree(record_page,
+					  sorted_pointers,
+					  next_record,
+					  child + 1,
+					  node_count);
+	}
+
+	return next_record;
+}
+
+static int
+encode_record_page(const struct volume *volume,
+		   const struct uds_volume_record records[],
+		   u8 record_page[])
+{
+	int result;
+	u32 i;
+	u32 records_per_page = volume->geometry->records_per_page;
+	const struct uds_volume_record **record_pointers = volume->record_pointers;
+
+	for (i = 0; i < records_per_page; i++)
+		record_pointers[i] = &records[i];
+
+	/*
+	 * Sort the record pointers by using just the names in the records, which is less work than
+	 * sorting the entire record values.
+	 */
+	STATIC_ASSERT(offsetof(struct uds_volume_record, name) == 0);
+	result = uds_radix_sort(volume->radix_sorter,
+				(const u8 **) record_pointers,
+				records_per_page,
+				UDS_RECORD_NAME_SIZE);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	encode_tree(record_page, record_pointers, 0, 0, records_per_page);
+	return UDS_SUCCESS;
+}
+
+static int write_record_pages(struct volume *volume,
+			      u32 physical_chapter_number,
+			      const struct uds_volume_record *records)
+{
+	u32 record_page_number;
+	struct geometry *geometry = volume->geometry;
+	struct dm_buffer *page_buffer;
+	const struct uds_volume_record *next_record = records;
+	u32 first_record_page = map_to_physical_page(geometry,
+						     physical_chapter_number,
+						     geometry->index_pages_per_chapter);
+
+	for (record_page_number = 0;
+	     record_page_number < geometry->record_pages_per_chapter;
+	     record_page_number++) {
+		u8 *page_data;
+		u32 physical_page = first_record_page + record_page_number;
+		int result;
+
+		page_data = dm_bufio_new(volume->client, physical_page, &page_buffer);
+		if (IS_ERR(page_data))
+			return uds_log_warning_strerror(-PTR_ERR(page_data),
+							"failed to prepare record page");
+
+		result = encode_record_page(volume, next_record, page_data);
+		if (result != UDS_SUCCESS) {
+			dm_bufio_release(page_buffer);
+			return uds_log_warning_strerror(result,
+							"failed to encode record page %u",
+							record_page_number);
+		}
+
+		next_record += geometry->records_per_page;
+		dm_bufio_mark_buffer_dirty(page_buffer);
+		dm_bufio_release(page_buffer);
+	}
+
+	return UDS_SUCCESS;
+}
+
+int uds_write_chapter(struct volume *volume,
+		      struct open_chapter_index *chapter_index,
+		      const struct uds_volume_record *records)
+{
+	int result;
+	u32 physical_chapter_number =
+		uds_map_to_physical_chapter(volume->geometry,
+					    chapter_index->virtual_chapter_number);
+
+	result = write_index_pages(volume, physical_chapter_number, chapter_index);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = write_record_pages(volume, physical_chapter_number, records);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = -dm_bufio_write_dirty_buffers(volume->client);
+	if (result != UDS_SUCCESS)
+		uds_log_error_strerror(result, "cannot sync chapter to volume");
+
+	return result;
+}
+
+static void probe_chapter(struct volume *volume, u32 chapter_number, u64 *virtual_chapter_number)
+{
+	const struct geometry *geometry = volume->geometry;
+	u32 expected_list_number = 0;
+	u32 i;
+	u64 vcn = BAD_CHAPTER;
+
+	*virtual_chapter_number = BAD_CHAPTER;
+	dm_bufio_prefetch(volume->client,
+			  map_to_physical_page(geometry, chapter_number, 0),
+			  geometry->index_pages_per_chapter);
+
+	for (i = 0; i < geometry->index_pages_per_chapter; ++i) {
+		struct delta_index_page *page;
+		int result;
+
+		result = uds_get_volume_index_page(volume, chapter_number, i, &page);
+		if (result != UDS_SUCCESS)
+			return;
+
+		if (page->virtual_chapter_number == BAD_CHAPTER) {
+			uds_log_error("corrupt index page in chapter %u", chapter_number);
+			return;
+		}
+
+		if (vcn == BAD_CHAPTER) {
+			vcn = page->virtual_chapter_number;
+		} else if (page->virtual_chapter_number != vcn) {
+			uds_log_error("inconsistent chapter %u index page %u: expected vcn %llu, got vcn %llu",
+				      chapter_number,
+				      i,
+				      (unsigned long long) vcn,
+				      (unsigned long long) page->virtual_chapter_number);
+			return;
+		}
+
+		if (expected_list_number != page->lowest_list_number) {
+			uds_log_error("inconsistent chapter %u index page %u: expected list number %u, got list number %u",
+				      chapter_number,
+				      i,
+				      expected_list_number,
+				      page->lowest_list_number);
+			return;
+		}
+		expected_list_number = page->highest_list_number + 1;
+
+		result = uds_validate_chapter_index_page(page, geometry);
+		if (result != UDS_SUCCESS)
+			return;
+	}
+
+	if (chapter_number != uds_map_to_physical_chapter(geometry, vcn)) {
+		uds_log_error("chapter %u vcn %llu is out of phase (%u)",
+			      chapter_number,
+			      (unsigned long long) vcn,
+			      geometry->chapters_per_volume);
+		return;
+	}
+
+	*virtual_chapter_number = vcn;
+}
+
+/* Find the last valid physical chapter in the volume. */
+static void find_real_end_of_volume(struct volume *volume, u32 limit, u32 *limit_ptr)
+{
+	u32 span = 1;
+	u32 tries = 0;
+
+	while (limit > 0) {
+		u32 chapter = (span > limit) ? 0 : limit - span;
+		u64 vcn = 0;
+
+		probe_chapter(volume, chapter, &vcn);
+		if (vcn == BAD_CHAPTER) {
+			limit = chapter;
+			if (++tries > 1)
+				span *= 2;
+		} else {
+			if (span == 1)
+				break;
+			span /= 2;
+			tries = 0;
+		}
+	}
+
+	*limit_ptr = limit;
+}
+
+static int
+find_chapter_limits(struct volume *volume, u32 chapter_limit, u64 *lowest_vcn, u64 *highest_vcn)
+{
+	struct geometry *geometry = volume->geometry;
+	u64 zero_vcn;
+	u64 lowest = BAD_CHAPTER;
+	u64 highest = BAD_CHAPTER;
+	u64 moved_chapter = BAD_CHAPTER;
+	u32 left_chapter = 0;
+	u32 right_chapter = 0;
+	u32 bad_chapters = 0;
+
+	/*
+	 * This method assumes there is at most one run of contiguous bad chapters caused by
+	 * unflushed writes. Either the bad spot is at the beginning and end, or somewhere in the
+	 * middle. Wherever it is, the highest and lowest VCNs are adjacent to it. Otherwise the
+	 * volume is cleanly saved and somewhere in the middle of it the highest VCN immediately
+	 * precedes the lowest one.
+	 */
+
+	/* It doesn't matter if this results in a bad spot (BAD_CHAPTER). */
+	probe_chapter(volume, 0, &zero_vcn);
+
+	/*
+	 * Binary search for end of the discontinuity in the monotonically increasing virtual
+	 * chapter numbers; bad spots are treated as a span of BAD_CHAPTER values. In effect we're
+	 * searching for the index of the smallest value less than zero_vcn. In the case we go off
+	 * the end it means that chapter 0 has the lowest vcn.
+	 *
+	 * If a virtual chapter is out-of-order, it will be the one moved by conversion. Always
+	 * skip over the moved chapter when searching, adding it to the range at the end if
+	 * necessary.
+	 */
+	if (geometry->remapped_physical > 0) {
+		u64 remapped_vcn;
+
+		probe_chapter(volume, geometry->remapped_physical, &remapped_vcn);
+		if (remapped_vcn == geometry->remapped_virtual)
+			moved_chapter = geometry->remapped_physical;
+	}
+
+	left_chapter = 0;
+	right_chapter = chapter_limit;
+
+	while (left_chapter < right_chapter) {
+		u64 probe_vcn;
+		u32 chapter = (left_chapter + right_chapter) / 2;
+
+		if (chapter == moved_chapter)
+			chapter--;
+
+		probe_chapter(volume, chapter, &probe_vcn);
+		if (zero_vcn <= probe_vcn) {
+			left_chapter = chapter + 1;
+			if (left_chapter == moved_chapter)
+				left_chapter++;
+		} else {
+			right_chapter = chapter;
+		}
+	}
+
+	/* If left_chapter goes off the end, chapter 0 has the lowest virtual chapter number.*/
+	if (left_chapter >= chapter_limit)
+		left_chapter = 0;
+
+	/* At this point, left_chapter is the chapter with the lowest virtual chapter number. */
+	probe_chapter(volume, left_chapter, &lowest);
+
+	/* The moved chapter might be the lowest in the range. */
+	if ((moved_chapter != BAD_CHAPTER) && (lowest == geometry->remapped_virtual + 1))
+		lowest = geometry->remapped_virtual;
+
+	/*
+	 * Circularly scan backwards, moving over any bad chapters until encountering a good one,
+	 * which is the chapter with the highest vcn.
+	 */
+	while (highest == BAD_CHAPTER) {
+		right_chapter = (right_chapter + chapter_limit - 1) % chapter_limit;
+		if (right_chapter == moved_chapter)
+			continue;
+
+		probe_chapter(volume, right_chapter, &highest);
+		if (bad_chapters++ >= MAX_BAD_CHAPTERS) {
+			uds_log_error("too many bad chapters in volume: %u", bad_chapters);
+			return UDS_CORRUPT_DATA;
+		}
+	}
+
+	*lowest_vcn = lowest;
+	*highest_vcn = highest;
+	return UDS_SUCCESS;
+}
+
+/*
+ * Find the highest and lowest contiguous chapters present in the volume and determine their
+ * virtual chapter numbers. This is used by rebuild.
+ */
+int uds_find_volume_chapter_boundaries(struct volume *volume,
+				       u64 *lowest_vcn,
+				       u64 *highest_vcn,
+				       bool *is_empty)
+{
+	u32 chapter_limit = volume->geometry->chapters_per_volume;
+
+	find_real_end_of_volume(volume, chapter_limit, &chapter_limit);
+	if (chapter_limit == 0) {
+		*lowest_vcn = 0;
+		*highest_vcn = 0;
+		*is_empty = true;
+		return UDS_SUCCESS;
+	}
+
+	*is_empty = false;
+	return find_chapter_limits(volume, chapter_limit, lowest_vcn, highest_vcn);
+}
+
+int __must_check
+uds_replace_volume_storage(struct volume *volume, struct index_layout *layout, const char *name)
+{
+	int result;
+	u32 i;
+
+	result = uds_replace_index_layout_storage(layout, name);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	/* Release all outstanding dm_bufio objects */
+	for (i = 0; i < volume->page_cache.indexable_pages; i++)
+		volume->page_cache.index[i] = volume->page_cache.cache_slots;
+	for (i = 0; i < volume->page_cache.cache_slots; i++)
+		clear_cache_page(&volume->page_cache, &volume->page_cache.cache[i]);
+	if (volume->sparse_cache != NULL)
+		uds_invalidate_sparse_cache(volume->sparse_cache);
+	if (volume->client != NULL)
+		dm_bufio_client_destroy(UDS_FORGET(volume->client));
+
+	return uds_open_volume_bufio(layout,
+				     volume->geometry->bytes_per_page,
+				     volume->reserved_buffers,
+				     &volume->client);
+}
+
+static int __must_check
+initialize_page_cache(struct page_cache *cache,
+		      const struct geometry *geometry,
+		      u32 chapters_in_cache,
+		      unsigned int zone_count)
+{
+	int result;
+	u32 i;
+
+	cache->indexable_pages = geometry->pages_per_volume + 1;
+	cache->cache_slots = chapters_in_cache * geometry->record_pages_per_chapter;
+	cache->zone_count = zone_count;
+	atomic64_set(&cache->clock, 1);
+
+	result = ASSERT((cache->cache_slots <= VOLUME_CACHE_MAX_ENTRIES),
+			"requested cache size, %u, within limit %u",
+			cache->cache_slots,
+			VOLUME_CACHE_MAX_ENTRIES);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(VOLUME_CACHE_MAX_QUEUED_READS,
+			      struct queued_read,
+			      "volume read queue",
+			      &cache->read_queue);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(cache->zone_count,
+			      struct search_pending_counter,
+			      "Volume Cache Zones",
+			      &cache->search_pending_counters);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(cache->indexable_pages, u16, "page cache index", &cache->index);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(cache->cache_slots,
+			      struct cached_page,
+			      "page cache cache",
+			      &cache->cache);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	/* Initialize index values to invalid values. */
+	for (i = 0; i < cache->indexable_pages; i++)
+		cache->index[i] = cache->cache_slots;
+
+	for (i = 0; i < cache->cache_slots; i++)
+		clear_cache_page(cache, &cache->cache[i]);
+
+	return UDS_SUCCESS;
+}
+
+int uds_make_volume(const struct configuration *config,
+		    struct index_layout *layout,
+		    struct volume **new_volume)
+{
+	unsigned int i;
+	struct volume *volume = NULL;
+	struct geometry *geometry;
+	unsigned int reserved_buffers;
+	int result;
+
+	result = UDS_ALLOCATE(1, struct volume, "volume", &volume);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	volume->nonce = uds_get_volume_nonce(layout);
+
+	result = uds_copy_geometry(config->geometry, &volume->geometry);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume(volume);
+		return uds_log_warning_strerror(result, "failed to allocate geometry: error");
+	}
+	geometry = volume->geometry;
+
+	/*
+	 * Reserve a buffer for each entry in the page cache, one for the chapter writer, and one
+	 * for each entry in the sparse cache.
+	 */
+	reserved_buffers = config->cache_chapters * geometry->record_pages_per_chapter;
+	reserved_buffers += 1;
+	if (uds_is_sparse_geometry(geometry))
+		reserved_buffers += (config->cache_chapters * geometry->index_pages_per_chapter);
+	volume->reserved_buffers = reserved_buffers;
+	result = uds_open_volume_bufio(layout,
+				       geometry->bytes_per_page,
+				       volume->reserved_buffers,
+				       &volume->client);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume(volume);
+		return result;
+	}
+
+	result = uds_make_radix_sorter(geometry->records_per_page, &volume->radix_sorter);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume(volume);
+		return result;
+	}
+
+	result = UDS_ALLOCATE(geometry->records_per_page,
+			      const struct uds_volume_record *,
+			      "record pointers",
+			      &volume->record_pointers);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume(volume);
+		return result;
+	}
+
+	if (uds_is_sparse_geometry(geometry)) {
+		size_t page_size = sizeof(struct delta_index_page) + geometry->bytes_per_page;
+
+		result = uds_make_sparse_cache(geometry,
+					       config->cache_chapters,
+					       config->zone_count,
+					       &volume->sparse_cache);
+		if (result != UDS_SUCCESS) {
+			uds_free_volume(volume);
+			return result;
+		}
+
+		volume->cache_size =
+			page_size * geometry->index_pages_per_chapter * config->cache_chapters;
+	}
+
+	result = initialize_page_cache(&volume->page_cache,
+				       geometry,
+				       config->cache_chapters,
+				       config->zone_count);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume(volume);
+		return result;
+	}
+
+	volume->cache_size += volume->page_cache.cache_slots * sizeof(struct delta_index_page);
+	result = uds_make_index_page_map(geometry, &volume->index_page_map);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume(volume);
+		return result;
+	}
+
+	result = uds_init_mutex(&volume->read_threads_mutex);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume(volume);
+		return result;
+	}
+
+	result = uds_init_cond(&volume->read_threads_read_done_cond);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume(volume);
+		return result;
+	}
+
+	result = uds_init_cond(&volume->read_threads_cond);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume(volume);
+		return result;
+	}
+
+	result = UDS_ALLOCATE(config->read_threads,
+			      struct thread *,
+			      "reader threads",
+			      &volume->reader_threads);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume(volume);
+		return result;
+	}
+
+	for (i = 0; i < config->read_threads; i++) {
+		result = uds_create_thread(read_thread_function,
+					   (void *) volume,
+					   "reader",
+					   &volume->reader_threads[i]);
+		if (result != UDS_SUCCESS) {
+			uds_free_volume(volume);
+			return result;
+		}
+
+		volume->read_thread_count = i + 1;
+	}
+
+	*new_volume = volume;
+	return UDS_SUCCESS;
+}
+
+static void uninitialize_page_cache(struct page_cache *cache)
+{
+	u16 i;
+
+	if (cache->cache != NULL) {
+		for (i = 0; i < cache->cache_slots; i++)
+			release_page_buffer(&cache->cache[i]);
+	}
+	UDS_FREE(cache->index);
+	UDS_FREE(cache->cache);
+	UDS_FREE(cache->search_pending_counters);
+	UDS_FREE(cache->read_queue);
+}
+
+void uds_free_volume(struct volume *volume)
+{
+	if (volume == NULL)
+		return;
+
+	if (volume->reader_threads != NULL) {
+		unsigned int i;
+
+		/* This works even if some threads weren't started. */
+		uds_lock_mutex(&volume->read_threads_mutex);
+		volume->read_threads_exiting = true;
+		uds_broadcast_cond(&volume->read_threads_cond);
+		uds_unlock_mutex(&volume->read_threads_mutex);
+		for (i = 0; i < volume->read_thread_count; i++)
+			uds_join_threads(volume->reader_threads[i]);
+		UDS_FREE(volume->reader_threads);
+		volume->reader_threads = NULL;
+	}
+
+	/* Must destroy the client AFTER freeing the cached pages. */
+	uninitialize_page_cache(&volume->page_cache);
+	uds_free_sparse_cache(volume->sparse_cache);
+	if (volume->client != NULL)
+		dm_bufio_client_destroy(UDS_FORGET(volume->client));
+
+	uds_destroy_cond(&volume->read_threads_cond);
+	uds_destroy_cond(&volume->read_threads_read_done_cond);
+	uds_destroy_mutex(&volume->read_threads_mutex);
+	uds_free_index_page_map(volume->index_page_map);
+	uds_free_radix_sorter(volume->radix_sorter);
+	UDS_FREE(volume->geometry);
+	UDS_FREE(volume->record_pointers);
+	UDS_FREE(volume);
+}
diff --git a/drivers/md/dm-vdo/volume.h b/drivers/md/dm-vdo/volume.h
new file mode 100644
index 00000000000..53d789cc64b
--- /dev/null
+++ b/drivers/md/dm-vdo/volume.h
@@ -0,0 +1,174 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_VOLUME_H
+#define UDS_VOLUME_H
+
+#include <linux/atomic.h>
+#include <linux/cache.h>
+#include <linux/dm-bufio.h>
+#include <linux/limits.h>
+
+#include "chapter-index.h"
+#include "config.h"
+#include "geometry.h"
+#include "index-layout.h"
+#include "index-page-map.h"
+#include "permassert.h"
+#include "radix-sort.h"
+#include "sparse-cache.h"
+#include "uds.h"
+#include "uds-threads.h"
+
+/*
+ * The volume manages deduplication records on permanent storage. The term "volume" can also refer
+ * to the region of permanent storage where the records (and the chapters containing them) are
+ * stored. The volume handles all I/O to this region by reading, caching, and writing chapter pages
+ * as necessary.
+ */
+
+enum index_lookup_mode {
+	/* Always do lookups in all chapters normally */
+	LOOKUP_NORMAL,
+	/* Only do a subset of lookups needed when rebuilding an index */
+	LOOKUP_FOR_REBUILD,
+};
+
+struct queued_read {
+	bool invalid;
+	bool reserved;
+	u32 physical_page;
+	struct uds_request *first_request;
+	struct uds_request *last_request;
+};
+
+struct __aligned(L1_CACHE_BYTES) search_pending_counter {
+	u64 atomic_value;
+};
+
+struct cached_page {
+	/* Whether this page is currently being read asynchronously */
+	bool read_pending;
+	/* The physical page stored in this cache entry */
+	u32 physical_page;
+	/* The value of the volume clock when this page was last used */
+	s64 last_used;
+	/* The cached page buffer */
+	struct dm_buffer *buffer;
+	/* The chapter index page, meaningless for record pages */
+	struct delta_index_page index_page;
+};
+
+struct page_cache {
+	/* The number of zones */
+	unsigned int zone_count;
+	/* The number of volume pages that can be cached */
+	u32 indexable_pages;
+	/* The maximum number of simultaneously cached pages */
+	u16 cache_slots;
+	/* An index for each physical page noting where it is in the cache */
+	u16 *index;
+	/* The array of cached pages */
+	struct cached_page *cache;
+	/* A counter for each zone tracking if a search is occurring there */
+	struct search_pending_counter *search_pending_counters;
+	/* The read queue entries as a circular array */
+	struct queued_read *read_queue;
+
+	/* All entries above this point are constant after initialization. */
+
+	/*
+	 * These values are all indexes into the array of read queue entries. New entries in the
+	 * read queue are enqueued at read_queue_last. To dequeue entries, a reader thread gets the
+	 * lock and then claims the entry pointed to by read_queue_next_read and increments that
+	 * value. After the read is completed, the reader thread calls release_read_queue_entry(),
+	 * which increments read_queue_first until it points to a pending read, or is equal to
+	 * read_queue_next_read. This means that if multiple reads are outstanding,
+	 * read_queue_first might not advance until the last of the reads finishes.
+	 */
+	u16 read_queue_first;
+	u16 read_queue_next_read;
+	u16 read_queue_last;
+
+	atomic64_t clock;
+};
+
+struct volume {
+	struct geometry *geometry;
+	struct dm_bufio_client *client;
+	u64 nonce;
+	size_t cache_size;
+
+	/* A single page worth of records, for sorting */
+	const struct uds_volume_record **record_pointers;
+	/* Sorter for sorting records within each page */
+	struct radix_sorter *radix_sorter;
+
+	struct sparse_cache *sparse_cache;
+	struct page_cache page_cache;
+	struct index_page_map *index_page_map;
+
+	struct mutex read_threads_mutex;
+	struct cond_var read_threads_cond;
+	struct cond_var read_threads_read_done_cond;
+	struct thread **reader_threads;
+	unsigned int read_thread_count;
+	bool read_threads_exiting;
+
+	enum index_lookup_mode lookup_mode;
+	unsigned int reserved_buffers;
+};
+
+int __must_check uds_make_volume(const struct configuration *config,
+				 struct index_layout *layout,
+				 struct volume **new_volume);
+
+void uds_free_volume(struct volume *volume);
+
+int __must_check
+uds_replace_volume_storage(struct volume *volume, struct index_layout *layout, const char *path);
+
+int __must_check uds_find_volume_chapter_boundaries(struct volume *volume,
+						    u64 *lowest_vcn,
+						    u64 *highest_vcn,
+						    bool *is_empty);
+
+int __must_check
+uds_search_volume_page_cache(struct volume *volume, struct uds_request *request, bool *found);
+
+int __must_check uds_search_volume_page_cache_for_rebuild(struct volume *volume,
+							  const struct uds_record_name *name,
+							  u64 virtual_chapter,
+							  bool *found);
+
+int __must_check uds_search_cached_record_page(struct volume *volume,
+					       struct uds_request *request,
+					       u32 chapter,
+					       u16 record_page_number,
+					       bool *found);
+
+void uds_forget_chapter(struct volume *volume, u64 chapter);
+
+int __must_check uds_write_chapter(struct volume *volume,
+				   struct open_chapter_index *chapter_index,
+				   const struct uds_volume_record records[]);
+
+void uds_prefetch_volume_chapter(const struct volume *volume, u32 chapter);
+
+int __must_check
+uds_read_chapter_index_from_volume(const struct volume *volume,
+				   u64 virtual_chapter,
+				   struct dm_buffer *volume_buffers[],
+				   struct delta_index_page index_pages[]);
+
+int __must_check
+uds_get_volume_record_page(struct volume *volume, u32 chapter, u32 page_number, u8 **data_ptr);
+
+int __must_check uds_get_volume_index_page(struct volume *volume,
+					   u32 chapter,
+					   u32 page_number,
+					   struct delta_index_page **page_ptr);
+
+#endif /* UDS_VOLUME_H */
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

