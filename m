Return-Path: <dm-devel-bounces@redhat.com>
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80597C77B75
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 05:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683609099;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aX4Rp7mJbp85vj1nSskP9AlAyZ2R0htvbeH7uz8Sh60=;
	b=DIPL3f9W+zMOxbBN+KJY/KdUnYj5DUnYUFnDRLH0Kr/E7GWOeaV3i7ujzTX5zkqOCR9krv
	+hRbZ7JclrJumyo8H0YyqsOBw5hwWwXP9JKyO2hIEMdNicer12F7OirleHNi5AdXKlW1pS
	9CeCpOizu0bz3Iu3IteXbtjnE7JNhBs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-m7zX0NwCPvSHHAbMaLrE2A-1; Tue, 09 May 2023 01:11:34 -0400
X-MC-Unique: m7zX0NwCPvSHHAbMaLrE2A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D27582812953;
	Tue,  9 May 2023 05:11:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7298340BC783;
	Tue,  9 May 2023 05:11:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C822A19451C0;
	Tue,  9 May 2023 05:11:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F2FBF19451CC
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 May 2023 01:06:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E1E59492B07; Tue,  9 May 2023 01:06:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.22.11.68])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A0DE0492C13;
 Tue,  9 May 2023 01:06:42 +0000 (UTC)
From: "J. corwin Coburn" <corwin@redhat.com>
To: dm-devel@redhat.com,
	linux-block@vger.kernel.org
Date: Mon,  8 May 2023 21:05:42 -0400
Message-Id: <20230509010545.72448-3-corwin@redhat.com>
In-Reply-To: <20230509010545.72448-1-corwin@redhat.com>
References: <20230509010545.72448-1-corwin@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 09 May 2023 05:11:30 +0000
Subject: [dm-devel] [PATCH 2/5] Add UDS deduplication index.
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
Cc: corwin <corwin@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: corwin <corwin@redhat.com>

This adds the deduplication index used by dm-vdo.

Signed-off-by: corwin <corwin@redhat.com>
---
 drivers/md/dm-vdo/chapter-index.c   |  304 ++++
 drivers/md/dm-vdo/chapter-index.h   |   66 +
 drivers/md/dm-vdo/config.c          |  389 ++++++
 drivers/md/dm-vdo/config.h          |  125 ++
 drivers/md/dm-vdo/cpu.h             |   58 +
 drivers/md/dm-vdo/delta-index.c     | 2018 +++++++++++++++++++++++++++
 drivers/md/dm-vdo/delta-index.h     |  292 ++++
 drivers/md/dm-vdo/errors.c          |  316 +++++
 drivers/md/dm-vdo/errors.h          |   83 ++
 drivers/md/dm-vdo/event-count.c     |  301 ++++
 drivers/md/dm-vdo/event-count.h     |   60 +
 drivers/md/dm-vdo/funnel-queue.c    |  169 +++
 drivers/md/dm-vdo/funnel-queue.h    |  110 ++
 drivers/md/dm-vdo/geometry.c        |  205 +++
 drivers/md/dm-vdo/geometry.h        |  137 ++
 drivers/md/dm-vdo/hash-utils.h      |   66 +
 drivers/md/dm-vdo/index-layout.c    | 1775 +++++++++++++++++++++++
 drivers/md/dm-vdo/index-layout.h    |   42 +
 drivers/md/dm-vdo/index-page-map.c  |  181 +++
 drivers/md/dm-vdo/index-page-map.h  |   54 +
 drivers/md/dm-vdo/index-session.c   |  815 +++++++++++
 drivers/md/dm-vdo/index-session.h   |   84 ++
 drivers/md/dm-vdo/index.c           | 1403 +++++++++++++++++++
 drivers/md/dm-vdo/index.h           |   83 ++
 drivers/md/dm-vdo/io-factory.c      |  458 ++++++
 drivers/md/dm-vdo/io-factory.h      |   66 +
 drivers/md/dm-vdo/logger.c          |  302 ++++
 drivers/md/dm-vdo/logger.h          |  112 ++
 drivers/md/dm-vdo/memory-alloc.c    |  447 ++++++
 drivers/md/dm-vdo/memory-alloc.h    |  181 +++
 drivers/md/dm-vdo/murmurhash3.c     |  175 +++
 drivers/md/dm-vdo/murmurhash3.h     |   15 +
 drivers/md/dm-vdo/numeric.h         |   78 ++
 drivers/md/dm-vdo/open-chapter.c    |  433 ++++++
 drivers/md/dm-vdo/open-chapter.h    |   79 ++
 drivers/md/dm-vdo/permassert.c      |   35 +
 drivers/md/dm-vdo/permassert.h      |   65 +
 drivers/md/dm-vdo/radix-sort.c      |  349 +++++
 drivers/md/dm-vdo/radix-sort.h      |   28 +
 drivers/md/dm-vdo/request-queue.c   |  284 ++++
 drivers/md/dm-vdo/request-queue.h   |   30 +
 drivers/md/dm-vdo/sparse-cache.c    |  595 ++++++++
 drivers/md/dm-vdo/sparse-cache.h    |   49 +
 drivers/md/dm-vdo/string-utils.c    |   28 +
 drivers/md/dm-vdo/string-utils.h    |   23 +
 drivers/md/dm-vdo/thread-cond-var.c |   46 +
 drivers/md/dm-vdo/thread-device.c   |   35 +
 drivers/md/dm-vdo/thread-device.h   |   19 +
 drivers/md/dm-vdo/thread-registry.c |   93 ++
 drivers/md/dm-vdo/thread-registry.h |   33 +
 drivers/md/dm-vdo/time-utils.h      |   28 +
 drivers/md/dm-vdo/uds-sysfs.c       |  185 +++
 drivers/md/dm-vdo/uds-sysfs.h       |   12 +
 drivers/md/dm-vdo/uds-threads.c     |  186 +++
 drivers/md/dm-vdo/uds-threads.h     |  126 ++
 drivers/md/dm-vdo/uds.h             |  334 +++++
 drivers/md/dm-vdo/volume-index.c    | 1272 +++++++++++++++++
 drivers/md/dm-vdo/volume-index.h    |  192 +++
 drivers/md/dm-vdo/volume.c          | 1792 ++++++++++++++++++++++++
 drivers/md/dm-vdo/volume.h          |  174 +++
 60 files changed, 17495 insertions(+)
 create mode 100644 drivers/md/dm-vdo/chapter-index.c
 create mode 100644 drivers/md/dm-vdo/chapter-index.h
 create mode 100644 drivers/md/dm-vdo/config.c
 create mode 100644 drivers/md/dm-vdo/config.h
 create mode 100644 drivers/md/dm-vdo/cpu.h
 create mode 100644 drivers/md/dm-vdo/delta-index.c
 create mode 100644 drivers/md/dm-vdo/delta-index.h
 create mode 100644 drivers/md/dm-vdo/errors.c
 create mode 100644 drivers/md/dm-vdo/errors.h
 create mode 100644 drivers/md/dm-vdo/event-count.c
 create mode 100644 drivers/md/dm-vdo/event-count.h
 create mode 100644 drivers/md/dm-vdo/funnel-queue.c
 create mode 100644 drivers/md/dm-vdo/funnel-queue.h
 create mode 100644 drivers/md/dm-vdo/geometry.c
 create mode 100644 drivers/md/dm-vdo/geometry.h
 create mode 100644 drivers/md/dm-vdo/hash-utils.h
 create mode 100644 drivers/md/dm-vdo/index-layout.c
 create mode 100644 drivers/md/dm-vdo/index-layout.h
 create mode 100644 drivers/md/dm-vdo/index-page-map.c
 create mode 100644 drivers/md/dm-vdo/index-page-map.h
 create mode 100644 drivers/md/dm-vdo/index-session.c
 create mode 100644 drivers/md/dm-vdo/index-session.h
 create mode 100644 drivers/md/dm-vdo/index.c
 create mode 100644 drivers/md/dm-vdo/index.h
 create mode 100644 drivers/md/dm-vdo/io-factory.c
 create mode 100644 drivers/md/dm-vdo/io-factory.h
 create mode 100644 drivers/md/dm-vdo/logger.c
 create mode 100644 drivers/md/dm-vdo/logger.h
 create mode 100644 drivers/md/dm-vdo/memory-alloc.c
 create mode 100644 drivers/md/dm-vdo/memory-alloc.h
 create mode 100644 drivers/md/dm-vdo/murmurhash3.c
 create mode 100644 drivers/md/dm-vdo/murmurhash3.h
 create mode 100644 drivers/md/dm-vdo/numeric.h
 create mode 100644 drivers/md/dm-vdo/open-chapter.c
 create mode 100644 drivers/md/dm-vdo/open-chapter.h
 create mode 100644 drivers/md/dm-vdo/permassert.c
 create mode 100644 drivers/md/dm-vdo/permassert.h
 create mode 100644 drivers/md/dm-vdo/radix-sort.c
 create mode 100644 drivers/md/dm-vdo/radix-sort.h
 create mode 100644 drivers/md/dm-vdo/request-queue.c
 create mode 100644 drivers/md/dm-vdo/request-queue.h
 create mode 100644 drivers/md/dm-vdo/sparse-cache.c
 create mode 100644 drivers/md/dm-vdo/sparse-cache.h
 create mode 100644 drivers/md/dm-vdo/string-utils.c
 create mode 100644 drivers/md/dm-vdo/string-utils.h
 create mode 100644 drivers/md/dm-vdo/thread-cond-var.c
 create mode 100644 drivers/md/dm-vdo/thread-device.c
 create mode 100644 drivers/md/dm-vdo/thread-device.h
 create mode 100644 drivers/md/dm-vdo/thread-registry.c
 create mode 100644 drivers/md/dm-vdo/thread-registry.h
 create mode 100644 drivers/md/dm-vdo/time-utils.h
 create mode 100644 drivers/md/dm-vdo/uds-sysfs.c
 create mode 100644 drivers/md/dm-vdo/uds-sysfs.h
 create mode 100644 drivers/md/dm-vdo/uds-threads.c
 create mode 100644 drivers/md/dm-vdo/uds-threads.h
 create mode 100644 drivers/md/dm-vdo/uds.h
 create mode 100644 drivers/md/dm-vdo/volume-index.c
 create mode 100644 drivers/md/dm-vdo/volume-index.h
 create mode 100644 drivers/md/dm-vdo/volume.c
 create mode 100644 drivers/md/dm-vdo/volume.h

diff --git a/drivers/md/dm-vdo/chapter-index.c b/drivers/md/dm-vdo/chapter-index.c
new file mode 100644
index 00000000000..f122232ce9a
--- /dev/null
+++ b/drivers/md/dm-vdo/chapter-index.c
@@ -0,0 +1,304 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "chapter-index.h"
+
+#include "errors.h"
+#include "hash-utils.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+#include "uds.h"
+
+int uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
+				const struct geometry *geometry,
+				u64 volume_nonce)
+{
+	int result;
+	size_t memory_size;
+	struct open_chapter_index *index;
+
+	result = UDS_ALLOCATE(1, struct open_chapter_index, "open chapter index", &index);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	/*
+	 * The delta index will rebalance delta lists when memory gets tight,
+	 * so give the chapter index one extra page.
+	 */
+	memory_size = ((geometry->index_pages_per_chapter + 1) * geometry->bytes_per_page);
+	index->geometry = geometry;
+	index->volume_nonce = volume_nonce;
+	result = uds_initialize_delta_index(&index->delta_index,
+					    1,
+					    geometry->delta_lists_per_chapter,
+					    geometry->chapter_mean_delta,
+					    geometry->chapter_payload_bits,
+					    memory_size,
+					    'm');
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(index);
+		return result;
+	}
+
+	index->memory_size = index->delta_index.memory_size + sizeof(struct open_chapter_index);
+	*chapter_index = index;
+	return UDS_SUCCESS;
+}
+
+void uds_free_open_chapter_index(struct open_chapter_index *chapter_index)
+{
+	if (chapter_index == NULL)
+		return;
+
+	uds_uninitialize_delta_index(&chapter_index->delta_index);
+	UDS_FREE(chapter_index);
+}
+
+/* Re-initialize an open chapter index for a new chapter. */
+void uds_empty_open_chapter_index(struct open_chapter_index *chapter_index,
+				  u64 virtual_chapter_number)
+{
+	uds_reset_delta_index(&chapter_index->delta_index);
+	chapter_index->virtual_chapter_number = virtual_chapter_number;
+}
+
+static inline bool was_entry_found(const struct delta_index_entry *entry, u32 address)
+{
+	return (!entry->at_end) && (entry->key == address);
+}
+
+/* Associate a record name with the record page containing its metadata. */
+int uds_put_open_chapter_index_record(struct open_chapter_index *chapter_index,
+				      const struct uds_record_name *name,
+				      u32 page_number)
+{
+	int result;
+	struct delta_index_entry entry;
+	u32 address;
+	u32 list_number;
+	const u8 *found_name;
+	bool found;
+	const struct geometry *geometry = chapter_index->geometry;
+	u64 chapter_number = chapter_index->virtual_chapter_number;
+	u32 record_pages = geometry->record_pages_per_chapter;
+
+	result = ASSERT(page_number < record_pages,
+			"Page number within chapter (%u) exceeds the maximum value %u",
+			page_number,
+			record_pages);
+	if (result != UDS_SUCCESS)
+		return UDS_INVALID_ARGUMENT;
+
+	address = uds_hash_to_chapter_delta_address(name, geometry);
+	list_number = uds_hash_to_chapter_delta_list(name, geometry);
+	result = uds_get_delta_index_entry(&chapter_index->delta_index,
+					   list_number,
+					   address,
+					   name->name,
+					   &entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	found = was_entry_found(&entry, address);
+	result = ASSERT(!(found && entry.is_collision),
+			"Chunk appears more than once in chapter %llu",
+			(unsigned long long) chapter_number);
+	if (result != UDS_SUCCESS)
+		return UDS_BAD_STATE;
+
+	found_name = (found ? name->name : NULL);
+	return uds_put_delta_index_entry(&entry, address, page_number, found_name);
+}
+
+/*
+ * Pack a section of an open chapter index into a chapter index page. A range of delta lists
+ * (starting with a specified list index) is copied from the open chapter index into a memory page.
+ * The number of lists copied onto the page is returned to the caller on success.
+ *
+ * @chapter_index: The open chapter index
+ * @memory: The memory page to use
+ * @first_list: The first delta list number to be copied
+ * @last_page: If true, this is the last page of the chapter index and all the remaining lists must
+ *             be packed onto this page
+ * @lists_packed: The number of delta lists that were packed onto this page
+ */
+int uds_pack_open_chapter_index_page(struct open_chapter_index *chapter_index,
+				     u8 *memory,
+				     u32 first_list,
+				     bool last_page,
+				     u32 *lists_packed)
+{
+	int result;
+	struct delta_index *delta_index = &chapter_index->delta_index;
+	struct delta_index_stats stats;
+	u64 nonce = chapter_index->volume_nonce;
+	u64 chapter_number = chapter_index->virtual_chapter_number;
+	const struct geometry *geometry = chapter_index->geometry;
+	u32 list_count = geometry->delta_lists_per_chapter;
+	unsigned int removals = 0;
+	struct delta_index_entry entry;
+	u32 next_list;
+	s32 list_number;
+
+	for (;;) {
+		result = uds_pack_delta_index_page(delta_index,
+						   nonce,
+						   memory,
+						   geometry->bytes_per_page,
+						   chapter_number,
+						   first_list,
+						   lists_packed);
+		if (result != UDS_SUCCESS)
+			return result;
+		if ((first_list + *lists_packed) == list_count)
+			/* All lists are packed. */
+			break;
+		else if (*lists_packed == 0) {
+			/*
+			 * The next delta list does not fit on a page. This delta list will be
+			 * removed.
+			 */
+		} else if (last_page) {
+			/*
+			 * This is the last page and there are lists left unpacked, but all of the
+			 * remaining lists must fit on the page. Find a list that contains entries
+			 * and remove the entire list. Try the first list that does not fit. If it
+			 * is empty, we will select the last list that already fits and has any
+			 * entries.
+			 */
+		} else {
+			/* This page is done. */
+			break;
+		}
+
+		if (removals == 0) {
+			uds_get_delta_index_stats(delta_index, &stats);
+			uds_log_warning("The chapter index for chapter %llu contains %llu entries with %llu collisions",
+					(unsigned long long) chapter_number,
+					(unsigned long long) stats.record_count,
+					(unsigned long long) stats.collision_count);
+		}
+
+		list_number = *lists_packed;
+		do {
+			if (list_number < 0)
+				return UDS_OVERFLOW;
+
+			next_list = first_list + list_number--,
+			result = uds_start_delta_index_search(delta_index, next_list, 0, &entry);
+			if (result != UDS_SUCCESS)
+				return result;
+
+			result = uds_next_delta_index_entry(&entry);
+			if (result != UDS_SUCCESS)
+				return result;
+		} while (entry.at_end);
+
+		do {
+			result = uds_remove_delta_index_entry(&entry);
+			if (result != UDS_SUCCESS)
+				return result;
+			removals++;
+		} while (!entry.at_end);
+	}
+
+	if (removals > 0)
+		uds_log_warning("To avoid chapter index page overflow in chapter %llu, %u entries were removed from the chapter index",
+				(unsigned long long) chapter_number,
+				removals);
+
+	return UDS_SUCCESS;
+}
+
+/* Make a new chapter index page, initializing it with the data from a given index_page buffer. */
+int uds_initialize_chapter_index_page(struct delta_index_page *index_page,
+				      const struct geometry *geometry,
+				      u8 *page_buffer,
+				      u64 volume_nonce)
+{
+	return uds_initialize_delta_index_page(index_page,
+					       volume_nonce,
+					       geometry->chapter_mean_delta,
+					       geometry->chapter_payload_bits,
+					       page_buffer,
+					       geometry->bytes_per_page);
+}
+
+/* Validate a chapter index page read during rebuild. */
+int uds_validate_chapter_index_page(const struct delta_index_page *index_page,
+				    const struct geometry *geometry)
+{
+	int result;
+	const struct delta_index *delta_index = &index_page->delta_index;
+	u32 first = index_page->lowest_list_number;
+	u32 last = index_page->highest_list_number;
+	u32 list_number;
+
+	/* We walk every delta list from start to finish. */
+	for (list_number = first; list_number <= last; list_number++) {
+		struct delta_index_entry entry;
+
+		result = uds_start_delta_index_search(delta_index, list_number - first, 0, &entry);
+		if (result != UDS_SUCCESS)
+			return result;
+
+		for (;;) {
+			result = uds_next_delta_index_entry(&entry);
+			if (result != UDS_SUCCESS)
+				/*
+				 * A random bit stream is highly likely to arrive here when we go
+				 * past the end of the delta list.
+				 */
+				return result;
+
+			if (entry.at_end)
+				break;
+
+			/* Also make sure that the record page field contains a plausible value. */
+			if (uds_get_delta_entry_value(&entry) >=
+			    geometry->record_pages_per_chapter)
+				/*
+				 * Do not log this as an error. It happens in normal operation when
+				 * we are doing a rebuild but haven't written the entire volume
+				 * once.
+				 */
+				return UDS_CORRUPT_DATA;
+		}
+	}
+	return UDS_SUCCESS;
+}
+
+/*
+ * Search a chapter index page for a record name, returning the record page number that may contain
+ * the name.
+ */
+int uds_search_chapter_index_page(struct delta_index_page *index_page,
+				  const struct geometry *geometry,
+				  const struct uds_record_name *name,
+				  u16 *record_page_ptr)
+{
+	int result;
+	struct delta_index *delta_index = &index_page->delta_index;
+	u32 address = uds_hash_to_chapter_delta_address(name, geometry);
+	u32 delta_list_number = uds_hash_to_chapter_delta_list(name, geometry);
+	u32 sub_list_number = delta_list_number - index_page->lowest_list_number;
+	struct delta_index_entry entry;
+
+	result = uds_get_delta_index_entry(delta_index,
+					   sub_list_number,
+					   address,
+					   name->name,
+					   &entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (was_entry_found(&entry, address))
+		*record_page_ptr = uds_get_delta_entry_value(&entry);
+	else
+		*record_page_ptr = NO_CHAPTER_INDEX_ENTRY;
+
+	return UDS_SUCCESS;
+}
diff --git a/drivers/md/dm-vdo/chapter-index.h b/drivers/md/dm-vdo/chapter-index.h
new file mode 100644
index 00000000000..ea3f392c2b1
--- /dev/null
+++ b/drivers/md/dm-vdo/chapter-index.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_CHAPTER_INDEX_H
+#define UDS_CHAPTER_INDEX_H
+
+#include <linux/limits.h>
+
+#include "delta-index.h"
+#include "geometry.h"
+
+/*
+ * A chapter index for an open chapter is a mutable structure that tracks all the records that have
+ * been added to the chapter. A chapter index for a closed chapter is similar except that it is
+ * immutable because the contents of a closed chapter can never change, and the immutable structure
+ * is more efficient. Both types of chapter index are implemented with a delta index.
+ */
+
+enum {
+	/* The value returned when no entry is found in the chapter index. */
+	NO_CHAPTER_INDEX_ENTRY = U16_MAX,
+};
+
+struct open_chapter_index {
+	const struct geometry *geometry;
+	struct delta_index delta_index;
+	u64 virtual_chapter_number;
+	u64 volume_nonce;
+	size_t memory_size;
+};
+
+int __must_check uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
+					     const struct geometry *geometry,
+					     u64 volume_nonce);
+
+void uds_free_open_chapter_index(struct open_chapter_index *chapter_index);
+
+void uds_empty_open_chapter_index(struct open_chapter_index *chapter_index,
+				  u64 virtual_chapter_number);
+
+int __must_check uds_put_open_chapter_index_record(struct open_chapter_index *chapter_index,
+						   const struct uds_record_name *name,
+						   u32 page_number);
+
+int __must_check uds_pack_open_chapter_index_page(struct open_chapter_index *chapter_index,
+						  u8 *memory,
+						  u32 first_list,
+						  bool last_page,
+						  u32 *lists_packed);
+
+int __must_check uds_initialize_chapter_index_page(struct delta_index_page *index_page,
+						   const struct geometry *geometry,
+						   u8 *page_buffer,
+						   u64 volume_nonce);
+
+int __must_check uds_validate_chapter_index_page(const struct delta_index_page *index_page,
+						 const struct geometry *geometry);
+
+int __must_check uds_search_chapter_index_page(struct delta_index_page *index_page,
+					       const struct geometry *geometry,
+					       const struct uds_record_name *name,
+					       u16 *record_page_ptr);
+
+#endif /* UDS_CHAPTER_INDEX_H */
diff --git a/drivers/md/dm-vdo/config.c b/drivers/md/dm-vdo/config.c
new file mode 100644
index 00000000000..d3aa3fc078d
--- /dev/null
+++ b/drivers/md/dm-vdo/config.c
@@ -0,0 +1,389 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "config.h"
+
+#include "logger.h"
+#include "memory-alloc.h"
+#include "numeric.h"
+#include "string-utils.h"
+#include "uds-threads.h"
+
+static const u8 INDEX_CONFIG_MAGIC[] = "ALBIC";
+static const u8 INDEX_CONFIG_VERSION_6_02[] = "06.02";
+static const u8 INDEX_CONFIG_VERSION_8_02[] = "08.02";
+
+enum {
+	DEFAULT_VOLUME_READ_THREADS = 2,
+	MAX_VOLUME_READ_THREADS = 16,
+	INDEX_CONFIG_MAGIC_LENGTH = sizeof(INDEX_CONFIG_MAGIC) - 1,
+	INDEX_CONFIG_VERSION_LENGTH = sizeof(INDEX_CONFIG_VERSION_6_02) - 1,
+};
+
+static bool is_version(const u8 *version, u8 *buffer)
+{
+	return memcmp(version, buffer, INDEX_CONFIG_VERSION_LENGTH) == 0;
+}
+
+static bool are_matching_configurations(struct configuration *saved_config,
+					struct geometry *saved_geometry,
+					struct configuration *user)
+{
+	struct geometry *geometry = user->geometry;
+	bool result = true;
+
+	if (saved_geometry->record_pages_per_chapter != geometry->record_pages_per_chapter) {
+		uds_log_error("Record pages per chapter (%u) does not match (%u)",
+			      saved_geometry->record_pages_per_chapter,
+			      geometry->record_pages_per_chapter);
+		result = false;
+	}
+
+	if (saved_geometry->chapters_per_volume != geometry->chapters_per_volume) {
+		uds_log_error("Chapter count (%u) does not match (%u)",
+			      saved_geometry->chapters_per_volume,
+			      geometry->chapters_per_volume);
+		result = false;
+	}
+
+	if (saved_geometry->sparse_chapters_per_volume != geometry->sparse_chapters_per_volume) {
+		uds_log_error("Sparse chapter count (%u) does not match (%u)",
+			      saved_geometry->sparse_chapters_per_volume,
+			      geometry->sparse_chapters_per_volume);
+		result = false;
+	}
+
+	if (saved_config->cache_chapters != user->cache_chapters) {
+		uds_log_error("Cache size (%u) does not match (%u)",
+			      saved_config->cache_chapters,
+			      user->cache_chapters);
+		result = false;
+	}
+
+	if (saved_config->volume_index_mean_delta != user->volume_index_mean_delta) {
+		uds_log_error("Volume index mean delta (%u) does not match (%u)",
+			      saved_config->volume_index_mean_delta,
+			      user->volume_index_mean_delta);
+		result = false;
+	}
+
+	if (saved_geometry->bytes_per_page != geometry->bytes_per_page) {
+		uds_log_error("Bytes per page value (%zu) does not match (%zu)",
+			      saved_geometry->bytes_per_page,
+			      geometry->bytes_per_page);
+		result = false;
+	}
+
+	if (saved_config->sparse_sample_rate != user->sparse_sample_rate) {
+		uds_log_error("Sparse sample rate (%u) does not match (%u)",
+			      saved_config->sparse_sample_rate,
+			      user->sparse_sample_rate);
+		result = false;
+	}
+
+	if (saved_config->nonce != user->nonce) {
+		uds_log_error("Nonce (%llu) does not match (%llu)",
+			      (unsigned long long) saved_config->nonce,
+			      (unsigned long long) user->nonce);
+		result = false;
+	}
+
+	return result;
+}
+
+/* Read the configuration and validate it against the provided one. */
+int uds_validate_config_contents(struct buffered_reader *reader, struct configuration *user_config)
+{
+	int result;
+	struct configuration config;
+	struct geometry geometry;
+	u8 version_buffer[INDEX_CONFIG_VERSION_LENGTH];
+	u32 bytes_per_page;
+	u8 buffer[sizeof(struct uds_configuration_6_02)];
+	size_t offset = 0;
+
+	result = uds_verify_buffered_data(reader, INDEX_CONFIG_MAGIC, INDEX_CONFIG_MAGIC_LENGTH);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_read_from_buffered_reader(reader,
+					       version_buffer,
+					       INDEX_CONFIG_VERSION_LENGTH);
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result, "cannot read index config version");
+
+	if (!is_version(INDEX_CONFIG_VERSION_6_02, version_buffer) &&
+	    !is_version(INDEX_CONFIG_VERSION_8_02, version_buffer)) {
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "unsupported configuration version: '%.*s'",
+					      INDEX_CONFIG_VERSION_LENGTH,
+					      version_buffer);
+	}
+
+	result = uds_read_from_buffered_reader(reader, buffer, sizeof(buffer));
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result, "cannot read config data");
+
+	decode_u32_le(buffer, &offset, &geometry.record_pages_per_chapter);
+	decode_u32_le(buffer, &offset, &geometry.chapters_per_volume);
+	decode_u32_le(buffer, &offset, &geometry.sparse_chapters_per_volume);
+	decode_u32_le(buffer, &offset, &config.cache_chapters);
+	offset += sizeof(u32);
+	decode_u32_le(buffer, &offset, &config.volume_index_mean_delta);
+	decode_u32_le(buffer, &offset, &bytes_per_page);
+	geometry.bytes_per_page = bytes_per_page;
+	decode_u32_le(buffer, &offset, &config.sparse_sample_rate);
+	decode_u64_le(buffer, &offset, &config.nonce);
+
+	result = ASSERT(offset == sizeof(struct uds_configuration_6_02),
+			"%zu bytes read but not decoded",
+			sizeof(struct uds_configuration_6_02) - offset);
+	if (result != UDS_SUCCESS)
+		return UDS_CORRUPT_DATA;
+
+	if (is_version(INDEX_CONFIG_VERSION_6_02, version_buffer)) {
+		user_config->geometry->remapped_virtual = 0;
+		user_config->geometry->remapped_physical = 0;
+	} else {
+		u8 remapping[sizeof(u64) + sizeof(u64)];
+
+		result = uds_read_from_buffered_reader(reader, remapping, sizeof(remapping));
+		if (result != UDS_SUCCESS)
+			return uds_log_error_strerror(result, "cannot read converted config");
+
+		offset = 0;
+		decode_u64_le(remapping, &offset, &user_config->geometry->remapped_virtual);
+		decode_u64_le(remapping, &offset, &user_config->geometry->remapped_physical);
+	}
+
+	if (!are_matching_configurations(&config, &geometry, user_config)) {
+		uds_log_warning("Supplied configuration does not match save");
+		return UDS_NO_INDEX;
+	}
+
+	return UDS_SUCCESS;
+}
+
+/*
+ * Write the configuration to stable storage. If the superblock version is < 4, write the 6.02
+ * version; otherwise write the 8.02 version, indicating the configuration is for an index that has
+ * been reduced by one chapter.
+ */
+int uds_write_config_contents(struct buffered_writer *writer,
+			      struct configuration *config,
+			      u32 version)
+{
+	int result;
+	struct geometry *geometry = config->geometry;
+	u8 buffer[sizeof(struct uds_configuration_8_02)];
+	size_t offset = 0;
+
+	result = uds_write_to_buffered_writer(writer,
+					      INDEX_CONFIG_MAGIC,
+					      INDEX_CONFIG_MAGIC_LENGTH);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	/*
+	 * If version is < 4, the index has not been reduced by a chapter so it must be written out
+	 * as version 6.02 so that it is still compatible with older versions of UDS.
+	 */
+	if (version >= 4) {
+		result = uds_write_to_buffered_writer(writer,
+						      INDEX_CONFIG_VERSION_8_02,
+						      INDEX_CONFIG_VERSION_LENGTH);
+		if (result != UDS_SUCCESS)
+			return result;
+	} else {
+		result = uds_write_to_buffered_writer(writer,
+						      INDEX_CONFIG_VERSION_6_02,
+						      INDEX_CONFIG_VERSION_LENGTH);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	encode_u32_le(buffer, &offset, geometry->record_pages_per_chapter);
+	encode_u32_le(buffer, &offset, geometry->chapters_per_volume);
+	encode_u32_le(buffer, &offset, geometry->sparse_chapters_per_volume);
+	encode_u32_le(buffer, &offset, config->cache_chapters);
+	encode_u32_le(buffer, &offset, 0);
+	encode_u32_le(buffer, &offset, config->volume_index_mean_delta);
+	encode_u32_le(buffer, &offset, geometry->bytes_per_page);
+	encode_u32_le(buffer, &offset, config->sparse_sample_rate);
+	encode_u64_le(buffer, &offset, config->nonce);
+
+	result = ASSERT(offset == sizeof(struct uds_configuration_6_02),
+			"%zu bytes encoded, of %zu expected",
+			offset,
+			sizeof(struct uds_configuration_6_02));
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (version >= 4) {
+		encode_u64_le(buffer, &offset, geometry->remapped_virtual);
+		encode_u64_le(buffer, &offset, geometry->remapped_physical);
+	}
+
+	return uds_write_to_buffered_writer(writer, buffer, offset);
+}
+
+/* Compute configuration parameters that depend on memory size. */
+static int compute_memory_sizes(uds_memory_config_size_t mem_gb,
+				bool sparse,
+				u32 *chapters_per_volume,
+				u32 *record_pages_per_chapter,
+				u32 *sparse_chapters_per_volume)
+{
+	u32 reduced_chapters = 0;
+	u32 base_chapters;
+
+	if (mem_gb == UDS_MEMORY_CONFIG_256MB) {
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if (mem_gb == UDS_MEMORY_CONFIG_512MB) {
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = 2 * SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if (mem_gb == UDS_MEMORY_CONFIG_768MB) {
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = 3 * SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if ((mem_gb >= 1) && (mem_gb <= UDS_MEMORY_CONFIG_MAX)) {
+		base_chapters = mem_gb * DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = DEFAULT_RECORD_PAGES_PER_CHAPTER;
+	} else if (mem_gb == UDS_MEMORY_CONFIG_REDUCED_256MB) {
+		reduced_chapters = 1;
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if (mem_gb == UDS_MEMORY_CONFIG_REDUCED_512MB) {
+		reduced_chapters = 1;
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = 2 * SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if (mem_gb == UDS_MEMORY_CONFIG_REDUCED_768MB) {
+		reduced_chapters = 1;
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = 3 * SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if ((mem_gb >= 1 + UDS_MEMORY_CONFIG_REDUCED) &&
+		   (mem_gb <= UDS_MEMORY_CONFIG_REDUCED_MAX)) {
+		reduced_chapters = 1;
+		base_chapters = ((mem_gb - UDS_MEMORY_CONFIG_REDUCED) *
+				 DEFAULT_CHAPTERS_PER_VOLUME);
+		*record_pages_per_chapter = DEFAULT_RECORD_PAGES_PER_CHAPTER;
+	} else {
+		uds_log_error("received invalid memory size");
+		return -EINVAL;
+	}
+
+	if (sparse) {
+		/* Make 95% of chapters sparse, allowing 10x more records. */
+		*sparse_chapters_per_volume = (19 * base_chapters) / 2;
+		base_chapters *= 10;
+	} else {
+		*sparse_chapters_per_volume = 0;
+	}
+
+	*chapters_per_volume = base_chapters - reduced_chapters;
+	return UDS_SUCCESS;
+}
+
+static unsigned int __must_check normalize_zone_count(unsigned int requested)
+{
+	unsigned int zone_count = requested;
+
+	if (zone_count == 0)
+		zone_count = num_online_cpus() / 2;
+
+	if (zone_count < 1)
+		zone_count = 1;
+
+	if (zone_count > MAX_ZONES)
+		zone_count = MAX_ZONES;
+
+	uds_log_info("Using %u indexing zone%s for concurrency.",
+		     zone_count,
+		     zone_count == 1 ? "" : "s");
+	return zone_count;
+}
+
+static unsigned int __must_check normalize_read_threads(unsigned int requested)
+{
+	unsigned int read_threads = requested;
+
+	if (read_threads < 1)
+		read_threads = DEFAULT_VOLUME_READ_THREADS;
+
+	if (read_threads > MAX_VOLUME_READ_THREADS)
+		read_threads = MAX_VOLUME_READ_THREADS;
+
+	return read_threads;
+}
+
+int uds_make_configuration(const struct uds_parameters *params, struct configuration **config_ptr)
+{
+	struct configuration *config;
+	u32 chapters_per_volume = 0;
+	u32 record_pages_per_chapter = 0;
+	u32 sparse_chapters_per_volume = 0;
+	int result;
+
+	result = compute_memory_sizes(params->memory_size,
+				      params->sparse,
+				      &chapters_per_volume,
+				      &record_pages_per_chapter,
+				      &sparse_chapters_per_volume);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(1, struct configuration, __func__, &config);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_make_geometry(DEFAULT_BYTES_PER_PAGE,
+				   record_pages_per_chapter,
+				   chapters_per_volume,
+				   sparse_chapters_per_volume,
+				   0,
+				   0,
+				   &config->geometry);
+	if (result != UDS_SUCCESS) {
+		uds_free_configuration(config);
+		return result;
+	}
+
+	config->zone_count = normalize_zone_count(params->zone_count);
+	config->read_threads = normalize_read_threads(params->read_threads);
+
+	config->cache_chapters = DEFAULT_CACHE_CHAPTERS;
+	config->volume_index_mean_delta = DEFAULT_VOLUME_INDEX_MEAN_DELTA;
+	config->sparse_sample_rate = (params->sparse ? DEFAULT_SPARSE_SAMPLE_RATE : 0);
+	config->nonce = params->nonce;
+	config->name = params->name;
+	config->offset = params->offset;
+	config->size = params->size;
+
+	*config_ptr = config;
+	return UDS_SUCCESS;
+}
+
+void uds_free_configuration(struct configuration *config)
+{
+	if (config != NULL) {
+		uds_free_geometry(config->geometry);
+		UDS_FREE(config);
+	}
+}
+
+void uds_log_configuration(struct configuration *config)
+{
+	struct geometry *geometry = config->geometry;
+
+	uds_log_debug("Configuration:");
+	uds_log_debug("  Record pages per chapter:   %10u", geometry->record_pages_per_chapter);
+	uds_log_debug("  Chapters per volume:        %10u", geometry->chapters_per_volume);
+	uds_log_debug("  Sparse chapters per volume: %10u", geometry->sparse_chapters_per_volume);
+	uds_log_debug("  Cache size (chapters):      %10u", config->cache_chapters);
+	uds_log_debug("  Volume index mean delta:    %10u", config->volume_index_mean_delta);
+	uds_log_debug("  Bytes per page:             %10zu", geometry->bytes_per_page);
+	uds_log_debug("  Sparse sample rate:         %10u", config->sparse_sample_rate);
+	uds_log_debug("  Nonce:                      %llu", (unsigned long long) config->nonce);
+}
diff --git a/drivers/md/dm-vdo/config.h b/drivers/md/dm-vdo/config.h
new file mode 100644
index 00000000000..4bbabc963cf
--- /dev/null
+++ b/drivers/md/dm-vdo/config.h
@@ -0,0 +1,125 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_CONFIG_H
+#define UDS_CONFIG_H
+
+#include "geometry.h"
+#include "io-factory.h"
+#include "uds.h"
+
+/*
+ * The configuration records a variety of parameters used to configure a new UDS index. Some
+ * parameters are provided by the client, while others are fixed or derived from user-supplied
+ * values. It is created when an index is created, and it is recorded in the index metadata.
+ */
+
+enum {
+	DEFAULT_VOLUME_INDEX_MEAN_DELTA = 4096,
+	DEFAULT_CACHE_CHAPTERS = 7,
+	DEFAULT_SPARSE_SAMPLE_RATE = 32,
+	MAX_ZONES = 16,
+};
+
+/* A set of configuration parameters for the indexer. */
+struct configuration {
+	/* String describing the storage device */
+	const char *name;
+
+	/* The maximum allowable size of the index */
+	size_t size;
+
+	/* The offset where the index should start */
+	off_t offset;
+
+	/* Parameters for the volume */
+
+	/* The volume layout */
+	struct geometry *geometry;
+
+	/* Index owner's nonce */
+	u64 nonce;
+
+	/* The number of threads used to process index requests */
+	unsigned int zone_count;
+
+	/* The number of threads used to read volume pages */
+	unsigned int read_threads;
+
+	/* Size of the page cache and sparse chapter index cache in chapters */
+	u32 cache_chapters;
+
+	/* Parameters for the volume index */
+
+	/* The mean delta for the volume index */
+	u32 volume_index_mean_delta;
+
+	/* Sampling rate for sparse indexing */
+	u32 sparse_sample_rate;
+};
+
+/* On-disk structure of data for a version 8.02 index. */
+struct uds_configuration_8_02 {
+	/* Smaller (16), Small (64) or large (256) indices */
+	u32 record_pages_per_chapter;
+	/* Total number of chapters per volume */
+	u32 chapters_per_volume;
+	/* Number of sparse chapters per volume */
+	u32 sparse_chapters_per_volume;
+	/* Size of the page cache, in chapters */
+	u32 cache_chapters;
+	/* Unused field */
+	u32 unused;
+	/* The volume index mean delta to use */
+	u32 volume_index_mean_delta;
+	/* Size of a page, used for both record pages and index pages */
+	u32 bytes_per_page;
+	/* Sampling rate for sparse indexing */
+	u32 sparse_sample_rate;
+	/* Index owner's nonce */
+	u64 nonce;
+	/* Virtual chapter remapped from physical chapter 0 */
+	u64 remapped_virtual;
+	/* New physical chapter which remapped chapter was moved to */
+	u64 remapped_physical;
+} __packed;
+
+/* On-disk structure of data for a version 6.02 index. */
+struct uds_configuration_6_02 {
+	/* Smaller (16), Small (64) or large (256) indices */
+	u32 record_pages_per_chapter;
+	/* Total number of chapters per volume */
+	u32 chapters_per_volume;
+	/* Number of sparse chapters per volume */
+	u32 sparse_chapters_per_volume;
+	/* Size of the page cache, in chapters */
+	u32 cache_chapters;
+	/* Unused field */
+	u32 unused;
+	/* The volume index mean delta to use */
+	u32 volume_index_mean_delta;
+	/* Size of a page, used for both record pages and index pages */
+	u32 bytes_per_page;
+	/* Sampling rate for sparse indexing */
+	u32 sparse_sample_rate;
+	/* Index owner's nonce */
+	u64 nonce;
+} __packed;
+
+int __must_check
+uds_make_configuration(const struct uds_parameters *params, struct configuration **config_ptr);
+
+void uds_free_configuration(struct configuration *config);
+
+int __must_check
+uds_validate_config_contents(struct buffered_reader *reader, struct configuration *config);
+
+int __must_check uds_write_config_contents(struct buffered_writer *writer,
+					   struct configuration *config,
+					   u32 version);
+
+void uds_log_configuration(struct configuration *config);
+
+#endif /* UDS_CONFIG_H */
diff --git a/drivers/md/dm-vdo/cpu.h b/drivers/md/dm-vdo/cpu.h
new file mode 100644
index 00000000000..d2da22d9d60
--- /dev/null
+++ b/drivers/md/dm-vdo/cpu.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_CPU_H
+#define UDS_CPU_H
+
+#include <linux/cache.h>
+
+/**
+ * uds_prefetch_address() - Minimize cache-miss latency by attempting to move data into a CPU cache
+ *                          before it is accessed.
+ *
+ * @address: the address to fetch (may be invalid)
+ * @for_write: must be constant at compile time--false if for reading, true if for writing
+ */
+static inline void uds_prefetch_address(const void *address, bool for_write)
+{
+	/*
+	 * for_write won't be a constant if we are compiled with optimization turned off, in which
+	 * case prefetching really doesn't matter. clang can't figure out that if for_write is a
+	 * constant, it can be passed as the second, mandatorily constant argument to prefetch(),
+	 * at least currently on llvm 12.
+	 */
+	if (__builtin_constant_p(for_write)) {
+		if (for_write)
+			__builtin_prefetch(address, true);
+		else
+			__builtin_prefetch(address, false);
+	}
+}
+
+/**
+ * uds_prefetch_range() - Minimize cache-miss latency by attempting to move a range of addresses
+ *                        into a CPU cache before they are accessed.
+ *
+ * @start: the starting address to fetch (may be invalid)
+ * @size: the number of bytes in the address range
+ * @for_write: must be constant at compile time--false if for reading, true if for writing
+ */
+static inline void uds_prefetch_range(const void *start, unsigned int size, bool for_write)
+{
+	/*
+	 * Count the number of cache lines to fetch, allowing for the address range to span an
+	 * extra cache line boundary due to address alignment.
+	 */
+	const char *address = (const char *) start;
+	unsigned int offset = ((uintptr_t) address % L1_CACHE_BYTES);
+	unsigned int cache_lines = (1 + ((size + offset) / L1_CACHE_BYTES));
+
+	while (cache_lines-- > 0) {
+		uds_prefetch_address(address, for_write);
+		address += L1_CACHE_BYTES;
+	}
+}
+
+#endif /* UDS_CPU_H */
diff --git a/drivers/md/dm-vdo/delta-index.c b/drivers/md/dm-vdo/delta-index.c
new file mode 100644
index 00000000000..3bc3f5340b7
--- /dev/null
+++ b/drivers/md/dm-vdo/delta-index.c
@@ -0,0 +1,2018 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+#include "delta-index.h"
+
+#include <linux/bitops.h>
+#include <linux/bits.h>
+#include <linux/compiler.h>
+#include <linux/limits.h>
+#include <linux/log2.h>
+
+#include "config.h"
+#include "cpu.h"
+#include "errors.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "numeric.h"
+#include "permassert.h"
+#include "string-utils.h"
+#include "time-utils.h"
+#include "uds.h"
+
+/*
+ * The entries in a delta index could be stored in a single delta list, but to reduce search times
+ * and update costs it uses multiple delta lists. These lists are stored in a single chunk of
+ * memory managed by the delta_zone structure. The delta_zone can move the data around within its
+ * memory, so the location of each delta list is recorded as a bit offset into the memory. Because
+ * the volume index can contain over a million delta lists, we want to be efficient with the size
+ * of the delta list header information. This information is encoded into 16 bytes per list. The
+ * volume index delta list memory can easily exceed 4 gigabits, so a 64 bit value is needed to
+ * address the memory. The volume index delta lists average around 6 kilobits, so 16 bits are
+ * sufficient to store the size of a delta list.
+ *
+ * Each delta list is stored as a bit stream. Within the delta list encoding, bits and bytes are
+ * numbered in little endian order. Within a byte, bit 0 is the least significant bit (0x1), and
+ * bit 7 is the most significant bit (0x80). Within a bit stream, bit 7 is the most signficant bit
+ * of byte 0, and bit 8 is the least significant bit of byte 1. Within a byte array, a byte's
+ * number corresponds to its index in the array.
+ *
+ * A standard delta list entry is stored as a fixed length payload (the value) followed by a
+ * variable length key (the delta). A collision entry is used when two block names have the same
+ * delta list address. A collision entry always follows a standard entry for the hash with which it
+ * collides, and is encoded with DELTA == 0 with an additional 256 bits field at the end,
+ * containing the full block name. An entry with a delta of 0 at the beginning of a delta list
+ * indicates a normal entry.
+ *
+ * The delta in each entry is encoded with a variable-length Huffman code to minimize the memory
+ * used by small deltas. The Huffman code is specified by three parameters, which can be computed
+ * from the desired mean delta when the index is full. (See compute_coding constants() for
+ * details.)
+ *
+ * The bit field utilities used to read and write delta entries assume that it is possible to read
+ * some bytes beyond the end of the bit field, so a delta_zone memory allocation is guarded by two
+ * invalid delta lists to prevent reading outside the delta_zone memory. The valid delta lists are
+ * numbered 1 to N, and the guard lists are numbered 0 and N+1. The function to decode the bit
+ * stream include a step that skips over bits set to 0 until the first 1 bit is found. A corrupted
+ * delta list could cause this step to run off the end of the delta_zone memory, so as extra
+ * protection against this happening, the tail guard list is set to all ones.
+ *
+ * The delta_index supports two different forms. The mutable form is created by
+ * uds_initialize_delta_index(), and is used for the volume index and for open chapter indexes. The
+ * immutable form is created by uds_initialize_delta_index_page(), and is used for closed (and
+ * cached) chapter index pages. The immutable form does not allocate delta list headers or
+ * temporary offsets, and thus is somewhat more memory efficient.
+ */
+
+/*
+ * This is the largest field size supported by get_field() and set_field(). Any field that is
+ * larger is not guaranteed to fit in a single byte-aligned u32.
+ */
+enum {
+	MAX_FIELD_BITS = (sizeof(u32) - 1) * BITS_PER_BYTE + 1,
+};
+
+/*
+ * This is the largest field size supported by get_big_field() and set_big_field(). Any field that
+ * is larger is not guaranteed to fit in a single byte-aligned u64.
+ */
+enum {
+	MAX_BIG_FIELD_BITS = (sizeof(u64) - 1) * BITS_PER_BYTE + 1,
+};
+
+/*
+ * This is the number of guard bytes needed at the end of the memory byte array when using the bit
+ * utilities. These utilities call get_big_field() and set_big_field(), which can access up to 7
+ * bytes beyond the end of the desired field. The definition is written to make it clear how this
+ * value is derived.
+ */
+enum {
+	POST_FIELD_GUARD_BYTES = sizeof(u64) - 1,
+};
+
+/* The number of guard bits that are needed in the tail guard list */
+enum {
+	GUARD_BITS = POST_FIELD_GUARD_BYTES * BITS_PER_BYTE
+};
+
+/*
+ * The maximum size of a single delta list in bytes. We count guard bytes in this value because a
+ * buffer of this size can be used with move_bits().
+ */
+enum {
+	DELTA_LIST_MAX_BYTE_COUNT =
+		((U16_MAX + BITS_PER_BYTE) / BITS_PER_BYTE + POST_FIELD_GUARD_BYTES)
+};
+
+/* The number of extra bytes and bits needed to store a collision entry */
+enum {
+	COLLISION_BYTES = UDS_RECORD_NAME_SIZE,
+	COLLISION_BITS = COLLISION_BYTES * BITS_PER_BYTE
+};
+
+/*
+ * Immutable delta lists are packed into pages containing a header that encodes the delta list
+ * information into 19 bits per list (64KB bit offset).
+ */
+
+enum { IMMUTABLE_HEADER_SIZE = 19 };
+
+/*
+ * Constants and structures for the saved delta index. "DI" is for delta_index, and -##### is a
+ * number to increment when the format of the data changes.
+ */
+
+enum {
+	MAGIC_SIZE = 8,
+};
+
+static const char DELTA_INDEX_MAGIC[] = "DI-00002";
+
+struct delta_index_header {
+	char magic[MAGIC_SIZE];
+	u32 zone_number;
+	u32 zone_count;
+	u32 first_list;
+	u32 list_count;
+	u64 record_count;
+	u64 collision_count;
+};
+
+/*
+ * Header data used for immutable delta index pages. This data is followed by the delta list offset
+ * table.
+ */
+struct delta_page_header {
+	/* Externally-defined nonce */
+	u64 nonce;
+	/* The virtual chapter number */
+	u64 virtual_chapter_number;
+	/* Index of the first delta list on the page */
+	u16 first_list;
+	/* Number of delta lists on the page */
+	u16 list_count;
+} __packed;
+
+static inline u64 get_delta_list_byte_start(const struct delta_list *delta_list)
+{
+	return delta_list->start / BITS_PER_BYTE;
+}
+
+static inline u16 get_delta_list_byte_size(const struct delta_list *delta_list)
+{
+	unsigned int bit_offset = delta_list->start % BITS_PER_BYTE;
+
+	return BITS_TO_BYTES(bit_offset + delta_list->size);
+}
+
+static void rebalance_delta_zone(const struct delta_zone *delta_zone, u32 first, u32 last)
+{
+	struct delta_list *delta_list;
+	u64 new_start;
+
+	if (first == last) {
+		/* Only one list is moving, and we know there is space. */
+		delta_list = &delta_zone->delta_lists[first];
+		new_start = delta_zone->new_offsets[first];
+		if (delta_list->start != new_start) {
+			u64 source;
+			u64 destination;
+
+			source = get_delta_list_byte_start(delta_list);
+			delta_list->start = new_start;
+			destination = get_delta_list_byte_start(delta_list);
+			memmove(delta_zone->memory + destination,
+				delta_zone->memory + source,
+				get_delta_list_byte_size(delta_list));
+		}
+	} else {
+		/*
+		 * There is more than one list. Divide the problem in half, and use recursive calls
+		 * to process each half. Note that after this computation, first <= middle, and
+		 * middle < last.
+		 */
+		u32 middle = (first + last) / 2;
+
+		delta_list = &delta_zone->delta_lists[middle];
+		new_start = delta_zone->new_offsets[middle];
+
+		/*
+		 * The direction that our middle list is moving determines which half of the
+		 * problem must be processed first.
+		 */
+		if (new_start > delta_list->start) {
+			rebalance_delta_zone(delta_zone, middle + 1, last);
+			rebalance_delta_zone(delta_zone, first, middle);
+		} else {
+			rebalance_delta_zone(delta_zone, first, middle);
+			rebalance_delta_zone(delta_zone, middle + 1, last);
+		}
+	}
+}
+
+static inline size_t get_zone_memory_size(unsigned int zone_count, size_t memory_size)
+{
+	/* Round up so that each zone is a multiple of 64K in size. */
+	enum {
+		ALLOC_BOUNDARY = 64 * 1024,
+	};
+
+	return (memory_size / zone_count + ALLOC_BOUNDARY - 1) & -ALLOC_BOUNDARY;
+}
+
+void uds_reset_delta_index(const struct delta_index *delta_index)
+{
+	unsigned int z;
+
+	/*
+	 * Initialize all delta lists to be empty. We keep 2 extra delta list descriptors, one
+	 * before the first real entry and one after so that we don't need to bounds check the
+	 * array access when calculating preceeding and following gap sizes.
+	 */
+	for (z = 0; z < delta_index->zone_count; z++) {
+		u64 list_bits;
+		u64 spacing;
+		u64 offset;
+		unsigned int i;
+		struct delta_zone *zone = &delta_index->delta_zones[z];
+		struct delta_list *delta_lists = zone->delta_lists;
+
+		/* Zeroing the delta list headers initializes the head guard list correctly. */
+		memset(delta_lists, 0, (zone->list_count + 2) * sizeof(struct delta_list));
+
+		/* Set all the bits in the end guard list. */
+		list_bits = (u64) zone->size * BITS_PER_BYTE - GUARD_BITS;
+		delta_lists[zone->list_count + 1].start = list_bits;
+		delta_lists[zone->list_count + 1].size = GUARD_BITS;
+		memset(zone->memory + (list_bits / BITS_PER_BYTE), ~0, POST_FIELD_GUARD_BYTES);
+
+		/* Evenly space out the real delta lists by setting regular offsets. */
+		spacing = list_bits / zone->list_count;
+		offset = spacing / 2;
+		for (i = 1; i <= zone->list_count; i++) {
+			delta_lists[i].start = offset;
+			offset += spacing;
+		}
+
+		/* Update the statistics. */
+		zone->discard_count += zone->record_count;
+		zone->record_count = 0;
+		zone->collision_count = 0;
+	}
+}
+
+/* Compute the Huffman coding parameters for the given mean delta. The Huffman code is specified by
+ * three parameters:
+ *
+ *  MINBITS   The number of bits in the smallest code
+ *  BASE      The number of values coded using a code of length MINBITS
+ *  INCR      The number of values coded by using one additional bit
+ *
+ * These parameters are related by this equation:
+ *
+ *	BASE + INCR == 1 << MINBITS
+ *
+ * The math for the Huffman code of an exponential distribution says that
+ *
+ *	INCR = log(2) * MEAN_DELTA
+ *
+ * Then use the smallest MINBITS value so that
+ *
+ *	(1 << MINBITS) > INCR
+ *
+ * And then
+ *
+ *	BASE = (1 << MINBITS) - INCR
+ *
+ * Now the index can generate a code such that
+ * - The first BASE values code using MINBITS bits.
+ * - The next INCR values code using MINBITS+1 bits.
+ * - The next INCR values code using MINBITS+2 bits.
+ * - (and so on).
+ */
+static void compute_coding_constants(u32 mean_delta, u16 *min_bits, u32 *min_keys, u32 *incr_keys)
+{
+	/*
+	 * We want to compute the rounded value of log(2) * mean_delta. Since we cannot always use
+	 * floating point, use a really good integer approximation.
+	 */
+	*incr_keys = (836158UL * mean_delta + 603160UL) / 1206321UL;
+	*min_bits = bits_per(*incr_keys + 1);
+	*min_keys = (1 << *min_bits) - *incr_keys;
+}
+
+void uds_uninitialize_delta_index(struct delta_index *delta_index)
+{
+	unsigned int z;
+
+	if (delta_index->delta_zones == NULL)
+		return;
+
+	for (z = 0; z < delta_index->zone_count; z++) {
+		UDS_FREE(UDS_FORGET(delta_index->delta_zones[z].new_offsets));
+		UDS_FREE(UDS_FORGET(delta_index->delta_zones[z].delta_lists));
+		UDS_FREE(UDS_FORGET(delta_index->delta_zones[z].memory));
+	}
+
+	UDS_FREE(delta_index->delta_zones);
+	memset(delta_index, 0, sizeof(struct delta_index));
+}
+
+static int initialize_delta_zone(struct delta_zone *delta_zone,
+				 size_t size,
+				 u32 first_list,
+				 u32 list_count,
+				 u32 mean_delta,
+				 u32 payload_bits,
+				 u8 tag)
+{
+	int result;
+
+	result = UDS_ALLOCATE(size, u8, "delta list", &delta_zone->memory);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(list_count + 2, u64, "delta list temp", &delta_zone->new_offsets);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	/* Allocate the delta lists. */
+	result = UDS_ALLOCATE(list_count + 2,
+			      struct delta_list,
+			      "delta lists",
+			      &delta_zone->delta_lists);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	compute_coding_constants(mean_delta,
+				 &delta_zone->min_bits,
+				 &delta_zone->min_keys,
+				 &delta_zone->incr_keys);
+	delta_zone->value_bits = payload_bits;
+	delta_zone->buffered_writer = NULL;
+	delta_zone->size = size;
+	delta_zone->rebalance_time = 0;
+	delta_zone->rebalance_count = 0;
+	delta_zone->record_count = 0;
+	delta_zone->collision_count = 0;
+	delta_zone->discard_count = 0;
+	delta_zone->overflow_count = 0;
+	delta_zone->first_list = first_list;
+	delta_zone->list_count = list_count;
+	delta_zone->tag = tag;
+
+	return UDS_SUCCESS;
+}
+
+int uds_initialize_delta_index(struct delta_index *delta_index,
+			       unsigned int zone_count,
+			       u32 list_count,
+			       u32 mean_delta,
+			       u32 payload_bits,
+			       size_t memory_size,
+			       u8 tag)
+{
+	int result;
+	unsigned int z;
+	size_t zone_memory;
+
+	result = UDS_ALLOCATE(zone_count,
+			      struct delta_zone,
+			      "Delta Index Zones",
+			      &delta_index->delta_zones);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	delta_index->zone_count = zone_count;
+	delta_index->list_count = list_count;
+	delta_index->lists_per_zone = DIV_ROUND_UP(list_count, zone_count);
+	delta_index->memory_size = 0;
+	delta_index->mutable = true;
+	delta_index->tag = tag;
+
+	for (z = 0; z < zone_count; z++) {
+		u32 lists_in_zone = delta_index->lists_per_zone;
+		u32 first_list_in_zone = z * lists_in_zone;
+
+		if (z == zone_count - 1) {
+			/*
+			 * The last zone gets fewer lists if zone_count doesn't evenly divide
+			 * list_count. We'll have an underflow if the assertion below doesn't hold.
+			 */
+			if (delta_index->list_count <= first_list_in_zone) {
+				uds_uninitialize_delta_index(delta_index);
+				return uds_log_error_strerror(UDS_INVALID_ARGUMENT,
+							      "%u delta lists not enough for %u zones",
+							      list_count,
+							      zone_count);
+			}
+			lists_in_zone = delta_index->list_count - first_list_in_zone;
+		}
+
+		zone_memory = get_zone_memory_size(zone_count, memory_size);
+		result = initialize_delta_zone(&delta_index->delta_zones[z],
+					       zone_memory,
+					       first_list_in_zone,
+					       lists_in_zone,
+					       mean_delta,
+					       payload_bits,
+					       tag);
+		if (result != UDS_SUCCESS) {
+			uds_uninitialize_delta_index(delta_index);
+			return result;
+		}
+
+		delta_index->memory_size +=
+			(sizeof(struct delta_zone) + zone_memory +
+			 (lists_in_zone + 2) * (sizeof(struct delta_list) + sizeof(u64)));
+	}
+
+	uds_reset_delta_index(delta_index);
+	return UDS_SUCCESS;
+}
+
+/* Read a bit field from an arbitrary bit boundary. */
+static inline u32 get_field(const u8 *memory, u64 offset, u8 size)
+{
+	const void *addr = memory + offset / BITS_PER_BYTE;
+
+	return (get_unaligned_le32(addr) >> (offset % BITS_PER_BYTE)) & ((1 << size) - 1);
+}
+
+/* Write a bit field to an arbitrary bit boundary. */
+static inline void set_field(u32 value, u8 *memory, u64 offset, u8 size)
+{
+	void *addr = memory + offset / BITS_PER_BYTE;
+	int shift = offset % BITS_PER_BYTE;
+	u32 data = get_unaligned_le32(addr);
+
+	data &= ~(((1 << size) - 1) << shift);
+	data |= value << shift;
+	put_unaligned_le32(data, addr);
+}
+
+/* Get the bit offset to the immutable delta list header. */
+static inline u32 get_immutable_header_offset(u32 list_number)
+{
+	return sizeof(struct delta_page_header) * BITS_PER_BYTE +
+		list_number * IMMUTABLE_HEADER_SIZE;
+}
+
+/* Get the bit offset to the start of the immutable delta list bit stream. */
+static inline u32 get_immutable_start(const u8 *memory, u32 list_number)
+{
+	return get_field(memory, get_immutable_header_offset(list_number), IMMUTABLE_HEADER_SIZE);
+}
+
+/* Set the bit offset to the start of the immutable delta list bit stream. */
+static inline void set_immutable_start(u8 *memory, u32 list_number, u32 start)
+{
+	set_field(start, memory, get_immutable_header_offset(list_number), IMMUTABLE_HEADER_SIZE);
+}
+
+static bool verify_delta_index_page(u64 nonce,
+				    u16 list_count,
+				    u64 expected_nonce,
+				    u8 *memory,
+				    size_t memory_size)
+{
+	unsigned int i;
+
+	/*
+	 * Verify the nonce. A mismatch can happen here during rebuild if we haven't written the
+	 * entire volume at least once.
+	 */
+	if (nonce != expected_nonce)
+		return false;
+
+	/* Verify that the number of delta lists can fit in the page. */
+	if (list_count > ((memory_size - sizeof(struct delta_page_header)) *
+			  BITS_PER_BYTE / IMMUTABLE_HEADER_SIZE))
+		return false;
+
+	/*
+	 * Verify that the first delta list is immediately after the last delta
+	 * list header.
+	 */
+	if (get_immutable_start(memory, 0) != get_immutable_header_offset(list_count + 1))
+		return false;
+
+	/* Verify that the lists are in the correct order. */
+	for (i = 0; i < list_count; i++)
+		if (get_immutable_start(memory, i) > get_immutable_start(memory, i + 1))
+			return false;
+
+	/*
+	 * Verify that the last list ends on the page, and that there is room
+	 * for the post-field guard bits.
+	 */
+	if (get_immutable_start(memory, list_count) >
+	    (memory_size - POST_FIELD_GUARD_BYTES) * BITS_PER_BYTE)
+		return false;
+
+	/* Verify that the guard bytes are correctly set to all ones. */
+	for (i = 0; i < POST_FIELD_GUARD_BYTES; i++) {
+		if (memory[memory_size - POST_FIELD_GUARD_BYTES + i] != (u8) ~0)
+			return false;
+	}
+
+	/* All verifications passed. */
+	return true;
+}
+
+/* Initialize a delta index page to refer to a supplied page. */
+int uds_initialize_delta_index_page(struct delta_index_page *delta_index_page,
+				    u64 expected_nonce,
+				    u32 mean_delta,
+				    u32 payload_bits,
+				    u8 *memory,
+				    size_t memory_size)
+{
+	u64 nonce;
+	u64 vcn;
+	u64 first_list;
+	u64 list_count;
+	struct delta_page_header *header = (struct delta_page_header *) memory;
+	struct delta_zone *delta_zone = &delta_index_page->delta_zone;
+	const u8 *nonce_addr = (const u8 *) &header->nonce;
+	const u8 *vcn_addr = (const u8 *) &header->virtual_chapter_number;
+	const u8 *first_list_addr = (const u8 *) &header->first_list;
+	const u8 *list_count_addr = (const u8 *) &header->list_count;
+
+	/* First assume that the header is little endian. */
+	nonce = get_unaligned_le64(nonce_addr);
+	vcn = get_unaligned_le64(vcn_addr);
+	first_list = get_unaligned_le16(first_list_addr);
+	list_count = get_unaligned_le16(list_count_addr);
+	if (!verify_delta_index_page(nonce, list_count, expected_nonce, memory, memory_size)) {
+		/* If that fails, try big endian. */
+		nonce = get_unaligned_be64(nonce_addr);
+		vcn = get_unaligned_be64(vcn_addr);
+		first_list = get_unaligned_be16(first_list_addr);
+		list_count = get_unaligned_be16(list_count_addr);
+		if (!verify_delta_index_page(nonce,
+					     list_count,
+					     expected_nonce,
+					     memory,
+					     memory_size))
+			/*
+			 * Both attempts failed. Do not log this as an error, because it can happen
+			 * during a rebuild if we haven't written the entire volume at least once.
+			 */
+			return UDS_CORRUPT_DATA;
+	}
+
+	delta_index_page->delta_index.delta_zones = delta_zone;
+	delta_index_page->delta_index.zone_count = 1;
+	delta_index_page->delta_index.list_count = list_count;
+	delta_index_page->delta_index.lists_per_zone = list_count;
+	delta_index_page->delta_index.mutable = false;
+	delta_index_page->delta_index.tag = 'p';
+	delta_index_page->virtual_chapter_number = vcn;
+	delta_index_page->lowest_list_number = first_list;
+	delta_index_page->highest_list_number = first_list + list_count - 1;
+
+	compute_coding_constants(mean_delta,
+				 &delta_zone->min_bits,
+				 &delta_zone->min_keys,
+				 &delta_zone->incr_keys);
+	delta_zone->value_bits = payload_bits;
+	delta_zone->memory = memory;
+	delta_zone->delta_lists = NULL;
+	delta_zone->new_offsets = NULL;
+	delta_zone->buffered_writer = NULL;
+	delta_zone->size = memory_size;
+	delta_zone->rebalance_time = 0;
+	delta_zone->rebalance_count = 0;
+	delta_zone->record_count = 0;
+	delta_zone->collision_count = 0;
+	delta_zone->discard_count = 0;
+	delta_zone->overflow_count = 0;
+	delta_zone->first_list = 0;
+	delta_zone->list_count = list_count;
+	delta_zone->tag = 'p';
+
+	return UDS_SUCCESS;
+}
+
+/* Read a large bit field from an arbitrary bit boundary. */
+static inline u64 get_big_field(const u8 *memory, u64 offset, u8 size)
+{
+	const void *addr = memory + offset / BITS_PER_BYTE;
+
+	return (get_unaligned_le64(addr) >> (offset % BITS_PER_BYTE)) & ((1UL << size) - 1);
+}
+
+/* Write a large bit field to an arbitrary bit boundary. */
+static inline void set_big_field(u64 value, u8 *memory, u64 offset, u8 size)
+{
+	void *addr = memory + offset / BITS_PER_BYTE;
+	u8 shift = offset % BITS_PER_BYTE;
+	u64 data = get_unaligned_le64(addr);
+
+	data &= ~(((1UL << size) - 1) << shift);
+	data |= value << shift;
+	put_unaligned_le64(data, addr);
+}
+
+/* Set a sequence of bits to all zeros. */
+static inline void set_zero(u8 *memory, u64 offset, u32 size)
+{
+	if (size > 0) {
+		u8 *addr = memory + offset / BITS_PER_BYTE;
+		u8 shift = offset % BITS_PER_BYTE;
+		u32 count = size + shift > BITS_PER_BYTE ? (u32) BITS_PER_BYTE - shift : size;
+
+		*addr++ &= ~(((1 << count) - 1) << shift);
+		for (size -= count; size > BITS_PER_BYTE; size -= BITS_PER_BYTE)
+			*addr++ = 0;
+
+		if (size > 0)
+			*addr &= 0xFF << size;
+	}
+}
+
+/*
+ * Move several bits from a higher to a lower address, moving the lower addressed bits first. The
+ * size and memory offsets are measured in bits.
+ */
+static void move_bits_down(const u8 *from, u64 from_offset, u8 *to, u64 to_offset, u32 size)
+{
+	const u8 *source;
+	u8 *destination;
+	u8 offset;
+	u8 count;
+	u64 field;
+
+	/* Start by moving one field that ends on a to int boundary. */
+	count = (MAX_BIG_FIELD_BITS - ((to_offset + MAX_BIG_FIELD_BITS) % BITS_PER_TYPE(u32)));
+	field = get_big_field(from, from_offset, count);
+	set_big_field(field, to, to_offset, count);
+	from_offset += count;
+	to_offset += count;
+	size -= count;
+
+	/* Now do the main loop to copy 32 bit chunks that are int-aligned at the destination. */
+	offset = from_offset % BITS_PER_TYPE(u32);
+	source = from + (from_offset - offset) / BITS_PER_BYTE;
+	destination = to + to_offset / BITS_PER_BYTE;
+	while (size > MAX_BIG_FIELD_BITS) {
+		put_unaligned_le32(get_unaligned_le64(source) >> offset, destination);
+		source += sizeof(u32);
+		destination += sizeof(u32);
+		from_offset += BITS_PER_TYPE(u32);
+		to_offset += BITS_PER_TYPE(u32);
+		size -= BITS_PER_TYPE(u32);
+	}
+
+	/* Finish up by moving any remaining bits. */
+	if (size > 0) {
+		field = get_big_field(from, from_offset, size);
+		set_big_field(field, to, to_offset, size);
+	}
+}
+
+/*
+ * Move several bits from a lower to a higher address, moving the higher addressed bits first. The
+ * size and memory offsets are measured in bits.
+ */
+static void move_bits_up(const u8 *from, u64 from_offset, u8 *to, u64 to_offset, u32 size)
+{
+	const u8 *source;
+	u8 *destination;
+	u8 offset;
+	u8 count;
+	u64 field;
+
+	/* Start by moving one field that begins on a destination int boundary. */
+	count = (to_offset + size) % BITS_PER_TYPE(u32);
+	if (count > 0) {
+		size -= count;
+		field = get_big_field(from, from_offset + size, count);
+		set_big_field(field, to, to_offset + size, count);
+	}
+
+	/* Now do the main loop to copy 32 bit chunks that are int-aligned at the destination. */
+	offset = (from_offset + size) % BITS_PER_TYPE(u32);
+	source = from + (from_offset + size - offset) / BITS_PER_BYTE;
+	destination = to + (to_offset + size) / BITS_PER_BYTE;
+	while (size > MAX_BIG_FIELD_BITS) {
+		source -= sizeof(u32);
+		destination -= sizeof(u32);
+		size -= BITS_PER_TYPE(u32);
+		put_unaligned_le32(get_unaligned_le64(source) >> offset, destination);
+	}
+
+	/* Finish up by moving any remaining bits. */
+	if (size > 0) {
+		field = get_big_field(from, from_offset, size);
+		set_big_field(field, to, to_offset, size);
+	}
+}
+
+/*
+ * Move bits from one field to another. When the fields overlap, behave as if we first move all the
+ * bits from the source to a temporary value, and then move all the bits from the temporary value
+ * to the destination. The size and memory offsets are measured in bits.
+ */
+static void move_bits(const u8 *from, u64 from_offset, u8 *to, u64 to_offset, u32 size)
+{
+	u64 field;
+
+	/* A small move doesn't require special handling. */
+	if (size <= MAX_BIG_FIELD_BITS) {
+		if (size > 0) {
+			field = get_big_field(from, from_offset, size);
+			set_big_field(field, to, to_offset, size);
+		}
+
+		return;
+	}
+
+	if (from_offset > to_offset)
+		move_bits_down(from, from_offset, to, to_offset, size);
+	else
+		move_bits_up(from, from_offset, to, to_offset, size);
+}
+
+/*
+ * Pack delta lists from a mutable delta index into an immutable delta index page. A range of delta
+ * lists (starting with a specified list index) is copied from the mutable delta index into a
+ * memory page used in the immutable index. The number of lists copied onto the page is returned in
+ * list_count.
+ */
+int uds_pack_delta_index_page(const struct delta_index *delta_index,
+			      u64 header_nonce,
+			      u8 *memory,
+			      size_t memory_size,
+			      u64 virtual_chapter_number,
+			      u32 first_list,
+			      u32 *list_count)
+{
+	const struct delta_zone *delta_zone;
+	struct delta_list *delta_lists;
+	u32 max_lists;
+	u32 n_lists = 0;
+	u32 offset;
+	u32 i;
+	int free_bits;
+	int bits;
+	struct delta_page_header *header;
+
+	delta_zone = &delta_index->delta_zones[0];
+	delta_lists = &delta_zone->delta_lists[first_list + 1];
+	max_lists = delta_index->list_count - first_list;
+
+	/*
+	 * Compute how many lists will fit on the page. Subtract the size of the fixed header, one
+	 * delta list offset, and the guard bytes from the page size to determine how much space is
+	 * available for delta lists.
+	 */
+	free_bits = memory_size * BITS_PER_BYTE;
+	free_bits -= get_immutable_header_offset(1);
+	free_bits -= GUARD_BITS;
+	if (free_bits < IMMUTABLE_HEADER_SIZE)
+		/* This page is too small to store any delta lists. */
+		return uds_log_error_strerror(UDS_OVERFLOW,
+					      "Chapter Index Page of %zu bytes is too small",
+					      memory_size);
+
+	while (n_lists < max_lists) {
+		/* Each list requires a delta list offset and the list data. */
+		bits = IMMUTABLE_HEADER_SIZE + delta_lists[n_lists].size;
+		if (bits > free_bits)
+			break;
+
+		n_lists++;
+		free_bits -= bits;
+	}
+
+	*list_count = n_lists;
+
+	header = (struct delta_page_header *) memory;
+	put_unaligned_le64(header_nonce, (u8 *) &header->nonce);
+	put_unaligned_le64(virtual_chapter_number, (u8 *) &header->virtual_chapter_number);
+	put_unaligned_le16(first_list, (u8 *) &header->first_list);
+	put_unaligned_le16(n_lists, (u8 *) &header->list_count);
+
+	/* Construct the delta list offset table. */
+	offset = get_immutable_header_offset(n_lists + 1);
+	set_immutable_start(memory, 0, offset);
+	for (i = 0; i < n_lists; i++) {
+		offset += delta_lists[i].size;
+		set_immutable_start(memory, i + 1, offset);
+	}
+
+	/* Copy the delta list data onto the memory page. */
+	for (i = 0; i < n_lists; i++)
+		move_bits(delta_zone->memory,
+			  delta_lists[i].start,
+			  memory,
+			  get_immutable_start(memory, i),
+			  delta_lists[i].size);
+
+	/* Set all the bits in the guard bytes. */
+	memset(memory + memory_size - POST_FIELD_GUARD_BYTES, ~0, POST_FIELD_GUARD_BYTES);
+	return UDS_SUCCESS;
+}
+
+/* Compute the new offsets of the delta lists. */
+static void compute_new_list_offsets(struct delta_zone *delta_zone,
+				     u32 growing_index,
+				     size_t growing_size,
+				     size_t used_space)
+{
+	size_t spacing;
+	u32 i;
+	struct delta_list *delta_lists = delta_zone->delta_lists;
+	u32 tail_guard_index = delta_zone->list_count + 1;
+
+	spacing = (delta_zone->size - used_space) / delta_zone->list_count;
+	delta_zone->new_offsets[0] = 0;
+	for (i = 0; i <= delta_zone->list_count; i++) {
+		delta_zone->new_offsets[i + 1] =
+			(delta_zone->new_offsets[i] +
+			 get_delta_list_byte_size(&delta_lists[i]) + spacing);
+		delta_zone->new_offsets[i] *= BITS_PER_BYTE;
+		delta_zone->new_offsets[i] += delta_lists[i].start % BITS_PER_BYTE;
+		if (i == 0)
+			delta_zone->new_offsets[i + 1] -= spacing / 2;
+		if (i + 1 == growing_index)
+			delta_zone->new_offsets[i + 1] += growing_size;
+	}
+
+	delta_zone->new_offsets[tail_guard_index] =
+		(delta_zone->size * BITS_PER_BYTE - delta_lists[tail_guard_index].size);
+}
+
+static void rebalance_lists(struct delta_zone *delta_zone)
+{
+	struct delta_list *delta_lists;
+	u32 i;
+	size_t used_space = 0;
+
+	/* Extend and balance memory to receive the delta lists */
+	delta_lists = delta_zone->delta_lists;
+	for (i = 0; i <= delta_zone->list_count + 1; i++)
+		used_space += get_delta_list_byte_size(&delta_lists[i]);
+
+	compute_new_list_offsets(delta_zone, 0, 0, used_space);
+	for (i = 1; i <= delta_zone->list_count + 1; i++)
+		delta_lists[i].start = delta_zone->new_offsets[i];
+}
+
+/* Start restoring a delta index from multiple input streams. */
+int uds_start_restoring_delta_index(struct delta_index *delta_index,
+				    struct buffered_reader **buffered_readers,
+				    unsigned int reader_count)
+{
+	int result;
+	unsigned int zone_count = reader_count;
+	u64 record_count = 0;
+	u64 collision_count = 0;
+	u32 first_list[MAX_ZONES];
+	u32 list_count[MAX_ZONES];
+	unsigned int z;
+	u32 list_next = 0;
+	const struct delta_zone *delta_zone;
+
+	/* Read and validate each header. */
+	for (z = 0; z < zone_count; z++) {
+		struct delta_index_header header;
+		u8 buffer[sizeof(struct delta_index_header)];
+		size_t offset = 0;
+
+		result = uds_read_from_buffered_reader(buffered_readers[z],
+						       buffer,
+						       sizeof(buffer));
+		if (result != UDS_SUCCESS)
+			return uds_log_warning_strerror(result,
+							"failed to read delta index header");
+
+		memcpy(&header.magic, buffer, MAGIC_SIZE);
+		offset += MAGIC_SIZE;
+		decode_u32_le(buffer, &offset, &header.zone_number);
+		decode_u32_le(buffer, &offset, &header.zone_count);
+		decode_u32_le(buffer, &offset, &header.first_list);
+		decode_u32_le(buffer, &offset, &header.list_count);
+		decode_u64_le(buffer, &offset, &header.record_count);
+		decode_u64_le(buffer, &offset, &header.collision_count);
+
+		result = ASSERT(offset == sizeof(struct delta_index_header),
+				"%zu bytes decoded of %zu expected",
+				offset,
+				sizeof(struct delta_index_header));
+		if (result != UDS_SUCCESS)
+			return uds_log_warning_strerror(result,
+							"failed to read delta index header");
+
+		if (memcmp(header.magic, DELTA_INDEX_MAGIC, MAGIC_SIZE) != 0)
+			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+							"delta index file has bad magic number");
+
+		if (zone_count != header.zone_count)
+			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+							"delta index files contain mismatched zone counts (%u,%u)",
+							zone_count,
+							header.zone_count);
+
+		if (header.zone_number != z)
+			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+							"delta index zone %u found in slot %u",
+							header.zone_number,
+							z);
+
+		first_list[z] = header.first_list;
+		list_count[z] = header.list_count;
+		record_count += header.record_count;
+		collision_count += header.collision_count;
+
+		if (first_list[z] != list_next)
+			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+							"delta index file for zone %u starts with list %u instead of list %u",
+							z,
+							first_list[z],
+							list_next);
+
+		list_next += list_count[z];
+	}
+
+	if (list_next != delta_index->list_count)
+		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+						"delta index files contain %u delta lists instead of %u delta lists",
+						list_next,
+						delta_index->list_count);
+
+	if (collision_count > record_count)
+		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+						"delta index files contain %llu collisions and %llu records",
+						(unsigned long long) collision_count,
+						(unsigned long long) record_count);
+
+	uds_reset_delta_index(delta_index);
+	delta_index->delta_zones[0].record_count = record_count;
+	delta_index->delta_zones[0].collision_count = collision_count;
+
+	/* Read the delta lists and distribute them to the proper zones. */
+	for (z = 0; z < zone_count; z++) {
+		u32 i;
+
+		delta_index->load_lists[z] = 0;
+		for (i = 0; i < list_count[z]; i++) {
+			u16 delta_list_size;
+			u32 list_number;
+			unsigned int zone_number;
+			u8 size_data[sizeof(u16)];
+
+			result = uds_read_from_buffered_reader(buffered_readers[z],
+							       size_data,
+							       sizeof(size_data));
+			if (result != UDS_SUCCESS)
+				return uds_log_warning_strerror(result,
+								"failed to read delta index size");
+
+			delta_list_size = get_unaligned_le16(size_data);
+			if (delta_list_size > 0)
+				delta_index->load_lists[z] += 1;
+
+			list_number = first_list[z] + i;
+			zone_number = list_number / delta_index->lists_per_zone;
+			delta_zone = &delta_index->delta_zones[zone_number];
+			list_number -= delta_zone->first_list;
+			delta_zone->delta_lists[list_number + 1].size = delta_list_size;
+		}
+	}
+
+	/* Prepare each zone to start receiving the delta list data. */
+	for (z = 0; z < delta_index->zone_count; z++)
+		rebalance_lists(&delta_index->delta_zones[z]);
+	return UDS_SUCCESS;
+}
+
+static int restore_delta_list_to_zone(struct delta_zone *delta_zone,
+				      const struct delta_list_save_info *save_info,
+				      const u8 *data)
+{
+	struct delta_list *delta_list;
+	u16 bit_count;
+	u16 byte_count;
+	u32 list_number = save_info->index - delta_zone->first_list;
+
+	if (list_number >= delta_zone->list_count)
+		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+						"invalid delta list number %u not in range [%u,%u)",
+						save_info->index,
+						delta_zone->first_list,
+						delta_zone->first_list +
+						delta_zone->list_count);
+
+	delta_list = &delta_zone->delta_lists[list_number + 1];
+	if (delta_list->size == 0)
+		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+						"unexpected delta list number %u",
+						save_info->index);
+
+	bit_count = delta_list->size + save_info->bit_offset;
+	byte_count = BITS_TO_BYTES(bit_count);
+	if (save_info->byte_count != byte_count)
+		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+						"unexpected delta list size %u != %u",
+						save_info->byte_count,
+						byte_count);
+
+	move_bits(data,
+		  save_info->bit_offset,
+		  delta_zone->memory,
+		  delta_list->start,
+		  delta_list->size);
+	return UDS_SUCCESS;
+}
+
+static int restore_delta_list_data(struct delta_index *delta_index,
+				   unsigned int load_zone,
+				   struct buffered_reader *buffered_reader,
+				   u8 *data)
+{
+	int result;
+	struct delta_list_save_info save_info;
+	u8 buffer[sizeof(struct delta_list_save_info)];
+	unsigned int new_zone;
+
+	result = uds_read_from_buffered_reader(buffered_reader, buffer, sizeof(buffer));
+	if (result != UDS_SUCCESS)
+		return uds_log_warning_strerror(result, "failed to read delta list data");
+
+	save_info = (struct delta_list_save_info) {
+		.tag = buffer[0],
+		.bit_offset = buffer[1],
+		.byte_count = get_unaligned_le16(&buffer[2]),
+		.index = get_unaligned_le32(&buffer[4]),
+	};
+
+	if ((save_info.bit_offset >= BITS_PER_BYTE) ||
+	    (save_info.byte_count > DELTA_LIST_MAX_BYTE_COUNT))
+		return uds_log_warning_strerror(UDS_CORRUPT_DATA, "corrupt delta list data");
+
+	/* Make sure the data is intended for this delta index. */
+	if (save_info.tag != delta_index->tag)
+		return UDS_CORRUPT_DATA;
+
+	if (save_info.index >= delta_index->list_count)
+		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+						"invalid delta list number %u of %u",
+						save_info.index,
+						delta_index->list_count);
+
+	result = uds_read_from_buffered_reader(buffered_reader, data, save_info.byte_count);
+	if (result != UDS_SUCCESS)
+		return uds_log_warning_strerror(result,
+						"failed to read delta list data");
+
+	delta_index->load_lists[load_zone] -= 1;
+	new_zone = save_info.index / delta_index->lists_per_zone;
+	return restore_delta_list_to_zone(&delta_index->delta_zones[new_zone], &save_info, data);
+}
+
+/* Restore delta lists from saved data. */
+int uds_finish_restoring_delta_index(struct delta_index *delta_index,
+				     struct buffered_reader **buffered_readers,
+				     unsigned int reader_count)
+{
+	int result;
+	int saved_result = UDS_SUCCESS;
+	unsigned int z;
+	u8 *data;
+
+	result = UDS_ALLOCATE(DELTA_LIST_MAX_BYTE_COUNT, u8, __func__, &data);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	for (z = 0; z < reader_count; z++) {
+		while (delta_index->load_lists[z] > 0) {
+			result = restore_delta_list_data(delta_index,
+							 z,
+							 buffered_readers[z],
+							 data);
+			if (result != UDS_SUCCESS) {
+				saved_result = result;
+				break;
+			}
+		}
+	}
+
+	UDS_FREE(data);
+	return saved_result;
+}
+
+int uds_check_guard_delta_lists(struct buffered_reader **buffered_readers,
+				unsigned int reader_count)
+{
+	int result;
+	unsigned int z;
+	u8 buffer[sizeof(struct delta_list_save_info)];
+
+	for (z = 0; z < reader_count; z++) {
+		result = uds_read_from_buffered_reader(buffered_readers[z],
+						       buffer,
+						       sizeof(buffer));
+		if (result != UDS_SUCCESS)
+			return result;
+
+		if (buffer[0] != 'z')
+			return UDS_CORRUPT_DATA;
+	}
+
+	return UDS_SUCCESS;
+}
+
+static int flush_delta_list(struct delta_zone *zone, u32 flush_index)
+{
+	struct delta_list *delta_list;
+	u8 buffer[sizeof(struct delta_list_save_info)];
+	int result;
+
+	delta_list = &zone->delta_lists[flush_index + 1];
+
+	buffer[0] = zone->tag;
+	buffer[1] = delta_list->start % BITS_PER_BYTE;
+	put_unaligned_le16(get_delta_list_byte_size(delta_list), &buffer[2]);
+	put_unaligned_le32(zone->first_list + flush_index, &buffer[4]);
+
+	result = uds_write_to_buffered_writer(zone->buffered_writer, buffer, sizeof(buffer));
+	if (result != UDS_SUCCESS) {
+		uds_log_warning_strerror(result, "failed to write delta list memory");
+		return result;
+	}
+
+	result = uds_write_to_buffered_writer(zone->buffered_writer,
+					      zone->memory + get_delta_list_byte_start(delta_list),
+					      get_delta_list_byte_size(delta_list));
+	if (result != UDS_SUCCESS)
+		uds_log_warning_strerror(result, "failed to write delta list memory");
+
+	return result;
+}
+
+/* Start saving a delta index zone to a buffered output stream. */
+int uds_start_saving_delta_index(const struct delta_index *delta_index,
+				 unsigned int zone_number,
+				 struct buffered_writer *buffered_writer)
+{
+	int result;
+	u32 i;
+	struct delta_zone *delta_zone;
+	u8 buffer[sizeof(struct delta_index_header)];
+	size_t offset = 0;
+
+	delta_zone = &delta_index->delta_zones[zone_number];
+	memcpy(buffer, DELTA_INDEX_MAGIC, MAGIC_SIZE);
+	offset += MAGIC_SIZE;
+	encode_u32_le(buffer, &offset, zone_number);
+	encode_u32_le(buffer, &offset, delta_index->zone_count);
+	encode_u32_le(buffer, &offset, delta_zone->first_list);
+	encode_u32_le(buffer, &offset, delta_zone->list_count);
+	encode_u64_le(buffer, &offset, delta_zone->record_count);
+	encode_u64_le(buffer, &offset, delta_zone->collision_count);
+
+	result = ASSERT(offset == sizeof(struct delta_index_header),
+			"%zu bytes encoded of %zu expected",
+			offset,
+			sizeof(struct delta_index_header));
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_write_to_buffered_writer(buffered_writer, buffer, offset);
+	if (result != UDS_SUCCESS)
+		return uds_log_warning_strerror(result, "failed to write delta index header");
+
+	for (i = 0; i < delta_zone->list_count; i++) {
+		u8 data[sizeof(u16)];
+		struct delta_list *delta_list;
+
+		delta_list = &delta_zone->delta_lists[i + 1];
+		put_unaligned_le16(delta_list->size, data);
+		result = uds_write_to_buffered_writer(buffered_writer, data, sizeof(data));
+		if (result != UDS_SUCCESS)
+			return uds_log_warning_strerror(result, "failed to write delta list size");
+	}
+
+	delta_zone->buffered_writer = buffered_writer;
+	return UDS_SUCCESS;
+}
+
+int uds_finish_saving_delta_index(const struct delta_index *delta_index, unsigned int zone_number)
+{
+	int result;
+	int first_error = UDS_SUCCESS;
+	u32 i;
+	struct delta_zone *delta_zone;
+	struct delta_list *delta_list;
+
+	delta_zone = &delta_index->delta_zones[zone_number];
+	for (i = 0; i < delta_zone->list_count; i++) {
+		delta_list = &delta_zone->delta_lists[i + 1];
+		if (delta_list->size > 0) {
+			result = flush_delta_list(delta_zone, i);
+			if ((result != UDS_SUCCESS) && (first_error == UDS_SUCCESS))
+				first_error = result;
+		}
+	}
+
+	delta_zone->buffered_writer = NULL;
+	return first_error;
+}
+
+int uds_write_guard_delta_list(struct buffered_writer *buffered_writer)
+{
+	int result;
+	u8 buffer[sizeof(struct delta_list_save_info)];
+
+	memset(buffer, 0, sizeof(struct delta_list_save_info));
+	buffer[0] = 'z';
+
+	result = uds_write_to_buffered_writer(buffered_writer, buffer, sizeof(buffer));
+	if (result != UDS_SUCCESS)
+		uds_log_warning_strerror(result, "failed to write guard delta list");
+
+	return UDS_SUCCESS;
+}
+
+size_t uds_compute_delta_index_save_bytes(u32 list_count, size_t memory_size)
+{
+	/* One zone will use at least as much memory as other zone counts. */
+	return (sizeof(struct delta_index_header) +
+		list_count * (sizeof(struct delta_list_save_info) + 1) +
+		get_zone_memory_size(1, memory_size));
+}
+
+static int assert_not_at_end(const struct delta_index_entry *delta_entry)
+{
+	int result = ASSERT(!delta_entry->at_end,
+			    "operation is invalid because the list entry is at the end of the delta list");
+	if (result != UDS_SUCCESS)
+		result = UDS_BAD_STATE;
+
+	return result;
+}
+
+/*
+ * Prepare to search for an entry in the specified delta list.
+ *
+ * This is always the first function to be called when dealing with delta index entries. It is
+ * always followed by calls to uds_next_delta_index_entry() to iterate through a delta list. The
+ * fields of the delta_index_entry argument will be set up for iteration, but will not contain an
+ * entry from the list.
+ */
+int uds_start_delta_index_search(const struct delta_index *delta_index,
+				 u32 list_number,
+				 u32 key,
+				 struct delta_index_entry *delta_entry)
+{
+	int result;
+	unsigned int zone_number;
+	struct delta_zone *delta_zone;
+	struct delta_list *delta_list;
+
+	result = ASSERT((list_number < delta_index->list_count),
+			"Delta list number (%u) is out of range (%u)",
+			list_number,
+			delta_index->list_count);
+	if (result != UDS_SUCCESS)
+		return UDS_CORRUPT_DATA;
+
+	zone_number = list_number / delta_index->lists_per_zone;
+	delta_zone = &delta_index->delta_zones[zone_number];
+	list_number -= delta_zone->first_list;
+	result = ASSERT((list_number < delta_zone->list_count),
+			"Delta list number (%u) is out of range (%u) for zone (%u)",
+			list_number,
+			delta_zone->list_count,
+			zone_number);
+	if (result != UDS_SUCCESS)
+		return UDS_CORRUPT_DATA;
+
+	if (delta_index->mutable) {
+		delta_list = &delta_zone->delta_lists[list_number + 1];
+	} else {
+		u32 end_offset;
+
+		/*
+		 * Translate the immutable delta list header into a temporary
+		 * full delta list header.
+		 */
+		delta_list = &delta_entry->temp_delta_list;
+		delta_list->start = get_immutable_start(delta_zone->memory, list_number);
+		end_offset = get_immutable_start(delta_zone->memory, list_number + 1);
+		delta_list->size = end_offset - delta_list->start;
+		delta_list->save_key = 0;
+		delta_list->save_offset = 0;
+	}
+
+	if (key > delta_list->save_key) {
+		delta_entry->key = delta_list->save_key;
+		delta_entry->offset = delta_list->save_offset;
+	} else {
+		delta_entry->key = 0;
+		delta_entry->offset = 0;
+		if (key == 0)
+			/*
+			 * This usually means we're about to walk the entire delta list, so get all
+			 * of it into the CPU cache.
+			 */
+			uds_prefetch_range(&delta_zone->memory[delta_list->start / BITS_PER_BYTE],
+					   delta_list->size / BITS_PER_BYTE,
+					   false);
+	}
+
+	delta_entry->at_end = false;
+	delta_entry->delta_zone = delta_zone;
+	delta_entry->delta_list = delta_list;
+	delta_entry->entry_bits = 0;
+	delta_entry->is_collision = false;
+	delta_entry->list_number = list_number;
+	delta_entry->list_overflow = false;
+	delta_entry->value_bits = delta_zone->value_bits;
+	return UDS_SUCCESS;
+}
+
+static inline u64 get_delta_entry_offset(const struct delta_index_entry *delta_entry)
+{
+	return delta_entry->delta_list->start + delta_entry->offset;
+}
+
+/*
+ * Decode a delta index entry delta value. The delta_index_entry basically describes the previous
+ * list entry, and has had its offset field changed to point to the subsequent entry. We decode the
+ * bit stream and update the delta_list_entry to describe the entry.
+ */
+static inline void decode_delta(struct delta_index_entry *delta_entry)
+{
+	int key_bits;
+	u32 delta;
+	const struct delta_zone *delta_zone = delta_entry->delta_zone;
+	const u8 *memory = delta_zone->memory;
+	u64 delta_offset = get_delta_entry_offset(delta_entry) + delta_entry->value_bits;
+	const u8 *addr = memory + delta_offset / BITS_PER_BYTE;
+	int offset = delta_offset % BITS_PER_BYTE;
+	u32 data = get_unaligned_le32(addr) >> offset;
+
+	addr += sizeof(u32);
+	key_bits = delta_zone->min_bits;
+	delta = data & ((1 << key_bits) - 1);
+	if (delta >= delta_zone->min_keys) {
+		data >>= key_bits;
+		if (data == 0) {
+			key_bits = sizeof(u32) * BITS_PER_BYTE - offset;
+			while ((data = get_unaligned_le32(addr)) == 0) {
+				addr += sizeof(u32);
+				key_bits += sizeof(u32) * BITS_PER_BYTE;
+			}
+		}
+		key_bits += ffs(data);
+		delta += ((key_bits - delta_zone->min_bits - 1) * delta_zone->incr_keys);
+	}
+	delta_entry->delta = delta;
+	delta_entry->key += delta;
+
+	/* Check for a collision, a delta of zero after the start. */
+	if (unlikely((delta == 0) && (delta_entry->offset > 0))) {
+		delta_entry->is_collision = true;
+		delta_entry->entry_bits = delta_entry->value_bits + key_bits + COLLISION_BITS;
+	} else {
+		delta_entry->is_collision = false;
+		delta_entry->entry_bits = delta_entry->value_bits + key_bits;
+	}
+}
+
+noinline int uds_next_delta_index_entry(struct delta_index_entry *delta_entry)
+{
+	int result;
+	const struct delta_list *delta_list;
+	u32 next_offset;
+	u16 size;
+
+	result = assert_not_at_end(delta_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	delta_list = delta_entry->delta_list;
+	delta_entry->offset += delta_entry->entry_bits;
+	size = delta_list->size;
+	if (unlikely(delta_entry->offset >= size)) {
+		delta_entry->at_end = true;
+		delta_entry->delta = 0;
+		delta_entry->is_collision = false;
+		result = ASSERT((delta_entry->offset == size),
+				"next offset past end of delta list");
+		if (result != UDS_SUCCESS)
+			result = UDS_CORRUPT_DATA;
+
+		return result;
+	}
+
+	decode_delta(delta_entry);
+
+	next_offset = delta_entry->offset + delta_entry->entry_bits;
+	if (next_offset > size) {
+		/*
+		 * This is not an assertion because uds_validate_chapter_index_page() wants to
+		 * handle this error.
+		 */
+		uds_log_warning("Decoded past the end of the delta list");
+		return UDS_CORRUPT_DATA;
+	}
+
+	return UDS_SUCCESS;
+}
+
+int uds_remember_delta_index_offset(const struct delta_index_entry *delta_entry)
+{
+	int result;
+	struct delta_list *delta_list = delta_entry->delta_list;
+
+	result = ASSERT(!delta_entry->is_collision, "entry is not a collision");
+	if (result != UDS_SUCCESS)
+		return result;
+
+	delta_list->save_key = delta_entry->key - delta_entry->delta;
+	delta_list->save_offset = delta_entry->offset;
+	return UDS_SUCCESS;
+}
+
+static void set_delta(struct delta_index_entry *delta_entry, u32 delta)
+{
+	const struct delta_zone *delta_zone = delta_entry->delta_zone;
+	u32 key_bits = (delta_zone->min_bits +
+			((delta_zone->incr_keys -
+			  delta_zone->min_keys + delta) /
+			 delta_zone->incr_keys));
+
+	delta_entry->delta = delta;
+	delta_entry->entry_bits = delta_entry->value_bits + key_bits;
+}
+
+static void get_collision_name(const struct delta_index_entry *entry, u8 *name)
+{
+	u64 offset = get_delta_entry_offset(entry) + entry->entry_bits - COLLISION_BITS;
+	const u8 *addr = entry->delta_zone->memory + offset / BITS_PER_BYTE;
+	int size = COLLISION_BYTES;
+	int shift = offset % BITS_PER_BYTE;
+
+	while (--size >= 0)
+		*name++ = get_unaligned_le16(addr++) >> shift;
+}
+
+static void set_collision_name(const struct delta_index_entry *entry, const u8 *name)
+{
+	u64 offset = get_delta_entry_offset(entry) + entry->entry_bits - COLLISION_BITS;
+	u8 *addr = entry->delta_zone->memory + offset / BITS_PER_BYTE;
+	int size = COLLISION_BYTES;
+	int shift = offset % BITS_PER_BYTE;
+	u16 mask = ~((u16) 0xFF << shift);
+	u16 data;
+
+	while (--size >= 0) {
+		data = (get_unaligned_le16(addr) & mask) | (*name++ << shift);
+		put_unaligned_le16(data, addr++);
+	}
+}
+
+int uds_get_delta_index_entry(const struct delta_index *delta_index,
+			      u32 list_number,
+			      u32 key,
+			      const u8 *name,
+			      struct delta_index_entry *delta_entry)
+{
+	int result;
+
+	result = uds_start_delta_index_search(delta_index, list_number, key, delta_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	do {
+		result = uds_next_delta_index_entry(delta_entry);
+		if (result != UDS_SUCCESS)
+			return result;
+	} while (!delta_entry->at_end && (key > delta_entry->key));
+
+	result = uds_remember_delta_index_offset(delta_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (!delta_entry->at_end && (key == delta_entry->key)) {
+		struct delta_index_entry collision_entry = *delta_entry;
+
+		for (;;) {
+			u8 full_name[COLLISION_BYTES];
+
+			result = uds_next_delta_index_entry(&collision_entry);
+			if (result != UDS_SUCCESS)
+				return result;
+
+			if (collision_entry.at_end || !collision_entry.is_collision)
+				break;
+
+			get_collision_name(&collision_entry, full_name);
+			if (memcmp(full_name, name, COLLISION_BYTES) == 0) {
+				*delta_entry = collision_entry;
+				break;
+			}
+		}
+	}
+
+	return UDS_SUCCESS;
+}
+
+int uds_get_delta_entry_collision(const struct delta_index_entry *delta_entry, u8 *name)
+{
+	int result;
+
+	result = assert_not_at_end(delta_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = ASSERT(delta_entry->is_collision,
+			"Cannot get full block name from a non-collision delta index entry");
+	if (result != UDS_SUCCESS)
+		return UDS_BAD_STATE;
+
+	get_collision_name(delta_entry, name);
+	return UDS_SUCCESS;
+}
+
+u32 uds_get_delta_entry_value(const struct delta_index_entry *delta_entry)
+{
+	return get_field(delta_entry->delta_zone->memory,
+			 get_delta_entry_offset(delta_entry),
+			 delta_entry->value_bits);
+}
+
+static int assert_mutable_entry(const struct delta_index_entry *delta_entry)
+{
+	int result = ASSERT((delta_entry->delta_list != &delta_entry->temp_delta_list),
+			    "delta index is mutable");
+	if (result != UDS_SUCCESS)
+		result = UDS_BAD_STATE;
+
+	return result;
+}
+
+int uds_set_delta_entry_value(const struct delta_index_entry *delta_entry, u32 value)
+{
+	int result;
+	u32 value_mask = (1 << delta_entry->value_bits) - 1;
+
+	result = assert_mutable_entry(delta_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = assert_not_at_end(delta_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = ASSERT((value & value_mask) == value,
+			"Value (%u) being set in a delta index is too large (must fit in %u bits)",
+			value,
+			delta_entry->value_bits);
+	if (result != UDS_SUCCESS)
+		return UDS_INVALID_ARGUMENT;
+
+	set_field(value,
+		  delta_entry->delta_zone->memory,
+		  get_delta_entry_offset(delta_entry),
+		  delta_entry->value_bits);
+	return UDS_SUCCESS;
+}
+
+/*
+ * Extend the memory used by the delta lists by adding growing_size bytes before the list indicated
+ * by growing_index, then rebalancing the lists in the new chunk.
+ */
+static int
+extend_delta_zone(struct delta_zone *delta_zone, u32 growing_index, size_t growing_size)
+{
+	ktime_t start_time;
+	ktime_t end_time;
+	struct delta_list *delta_lists;
+	u32 i;
+	size_t used_space;
+
+
+	/* Calculate the amount of space that is or will be in use. */
+	start_time = current_time_ns(CLOCK_MONOTONIC);
+	delta_lists = delta_zone->delta_lists;
+	used_space = growing_size;
+	for (i = 0; i <= delta_zone->list_count + 1; i++)
+		used_space += get_delta_list_byte_size(&delta_lists[i]);
+
+	if (delta_zone->size < used_space)
+		return UDS_OVERFLOW;
+
+	/* Compute the new offsets of the delta lists. */
+	compute_new_list_offsets(delta_zone, growing_index, growing_size, used_space);
+
+	/*
+	 * When we rebalance the delta list, we will include the end guard list in the rebalancing.
+	 * It contains the end guard data, which must be copied.
+	 */
+	rebalance_delta_zone(delta_zone, 1, delta_zone->list_count + 1);
+	end_time = current_time_ns(CLOCK_MONOTONIC);
+	delta_zone->rebalance_count++;
+	delta_zone->rebalance_time += ktime_sub(end_time, start_time);
+	return UDS_SUCCESS;
+}
+
+static int insert_bits(struct delta_index_entry *delta_entry, u16 size)
+{
+	u64 free_before;
+	u64 free_after;
+	u64 source;
+	u64 destination;
+	u32 count;
+	bool before_flag;
+	u8 *memory;
+	struct delta_zone *delta_zone = delta_entry->delta_zone;
+	struct delta_list *delta_list = delta_entry->delta_list;
+	/* Compute bits in use before and after the inserted bits. */
+	u32 total_size = delta_list->size;
+	u32 before_size = delta_entry->offset;
+	u32 after_size = total_size - delta_entry->offset;
+
+	if (total_size + size > U16_MAX) {
+		delta_entry->list_overflow = true;
+		delta_zone->overflow_count++;
+		return UDS_OVERFLOW;
+	}
+
+	/* Compute bits available before and after the delta list. */
+	free_before = (delta_list[0].start - (delta_list[-1].start + delta_list[-1].size));
+	free_after = (delta_list[1].start - (delta_list[0].start + delta_list[0].size));
+
+	if ((size <= free_before) && (size <= free_after)) {
+		/*
+		 * We have enough space to use either before or after the list. Select the smaller
+		 * amount of data. If it is exactly the same, try to take from the larger amount of
+		 * free space.
+		 */
+		if (before_size < after_size)
+			before_flag = true;
+		else if (after_size < before_size)
+			before_flag = false;
+		else
+			before_flag = free_before > free_after;
+	} else if (size <= free_before) {
+		/* There is space before but not after. */
+		before_flag = true;
+	} else if (size <= free_after) {
+		/* There is space after but not before. */
+		before_flag = false;
+	} else {
+		/*
+		 * Neither of the surrounding spaces is large enough for this request. Extend
+		 * and/or rebalance the delta list memory choosing to move the least amount of
+		 * data.
+		 */
+		int result;
+		u32 growing_index = delta_entry->list_number + 1;
+
+		before_flag = before_size < after_size;
+		if (!before_flag)
+			growing_index++;
+		result = extend_delta_zone(delta_zone, growing_index, BITS_TO_BYTES(size));
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	delta_list->size += size;
+	if (before_flag) {
+		source = delta_list->start;
+		destination = source - size;
+		delta_list->start -= size;
+		count = before_size;
+	} else {
+		source = delta_list->start + delta_entry->offset;
+		destination = source + size;
+		count = after_size;
+	}
+
+	memory = delta_zone->memory;
+	move_bits(memory, source, memory, destination, count);
+	return UDS_SUCCESS;
+}
+
+static void encode_delta(const struct delta_index_entry *delta_entry)
+{
+	u32 temp;
+	u32 t1;
+	u32 t2;
+	u64 offset;
+	const struct delta_zone *delta_zone = delta_entry->delta_zone;
+	u8 *memory = delta_zone->memory;
+
+	offset = get_delta_entry_offset(delta_entry) + delta_entry->value_bits;
+	if (delta_entry->delta < delta_zone->min_keys) {
+		set_field(delta_entry->delta, memory, offset, delta_zone->min_bits);
+		return;
+	}
+
+	temp = delta_entry->delta - delta_zone->min_keys;
+	t1 = (temp % delta_zone->incr_keys) + delta_zone->min_keys;
+	t2 = temp / delta_zone->incr_keys;
+	set_field(t1, memory, offset, delta_zone->min_bits);
+	set_zero(memory, offset + delta_zone->min_bits, t2);
+	set_field(1, memory, offset + delta_zone->min_bits + t2, 1);
+}
+
+static void encode_entry(const struct delta_index_entry *delta_entry, u32 value, const u8 *name)
+{
+	u8 *memory = delta_entry->delta_zone->memory;
+	u64 offset = get_delta_entry_offset(delta_entry);
+
+	set_field(value, memory, offset, delta_entry->value_bits);
+	encode_delta(delta_entry);
+	if (name != NULL)
+		set_collision_name(delta_entry, name);
+}
+
+/*
+ * Create a new entry in the delta index. If the entry is a collision, the full 256 bit name must
+ * be provided.
+ */
+int uds_put_delta_index_entry(struct delta_index_entry *delta_entry,
+			      u32 key,
+			      u32 value,
+			      const u8 *name)
+{
+	int result;
+	struct delta_zone *delta_zone;
+
+	result = assert_mutable_entry(delta_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (delta_entry->is_collision)
+		/*
+		 * The caller wants us to insert a collision entry onto a collision entry. This
+		 * happens when we find a collision and attempt to add the name again to the index.
+		 * This is normally a fatal error unless we are replaying a closed chapter while we
+		 * are rebuilding a volume index.
+		 */
+		return UDS_DUPLICATE_NAME;
+
+	if (delta_entry->offset < delta_entry->delta_list->save_offset) {
+		/*
+		 * The saved entry offset is after the new entry and will no longer be valid, so
+		 * replace it with the insertion point.
+		 */
+		result = uds_remember_delta_index_offset(delta_entry);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	if (name != NULL) {
+		/* Insert a collision entry which is placed after this entry. */
+		result = assert_not_at_end(delta_entry);
+		if (result != UDS_SUCCESS)
+			return result;
+
+		result = ASSERT((key == delta_entry->key), "incorrect key for collision entry");
+		if (result != UDS_SUCCESS)
+			return result;
+
+		delta_entry->offset += delta_entry->entry_bits;
+		set_delta(delta_entry, 0);
+		delta_entry->is_collision = true;
+		delta_entry->entry_bits += COLLISION_BITS;
+		result = insert_bits(delta_entry, delta_entry->entry_bits);
+	} else if (delta_entry->at_end) {
+		/* Insert a new entry at the end of the delta list. */
+		result = ASSERT((key >= delta_entry->key), "key past end of list");
+		if (result != UDS_SUCCESS)
+			return result;
+
+		set_delta(delta_entry, key - delta_entry->key);
+		delta_entry->key = key;
+		delta_entry->at_end = false;
+		result = insert_bits(delta_entry, delta_entry->entry_bits);
+	} else {
+		u16 old_entry_size;
+		u16 additional_size;
+		struct delta_index_entry next_entry;
+		u32 next_value;
+
+		/*
+		 * Insert a new entry which requires the delta in the following entry to be
+		 * updated.
+		 */
+		result = ASSERT((key < delta_entry->key), "key precedes following entry");
+		if (result != UDS_SUCCESS)
+			return result;
+
+		result = ASSERT((key >= delta_entry->key - delta_entry->delta),
+				"key effects following entry's delta");
+		if (result != UDS_SUCCESS)
+			return result;
+
+		old_entry_size = delta_entry->entry_bits;
+		next_entry = *delta_entry;
+		next_value = uds_get_delta_entry_value(&next_entry);
+		set_delta(delta_entry, key - (delta_entry->key - delta_entry->delta));
+		delta_entry->key = key;
+		set_delta(&next_entry, next_entry.key - key);
+		next_entry.offset += delta_entry->entry_bits;
+		/* The two new entries are always bigger than the single entry being replaced. */
+		additional_size = (delta_entry->entry_bits +
+				   next_entry.entry_bits - old_entry_size);
+		result = insert_bits(delta_entry, additional_size);
+		if (result != UDS_SUCCESS)
+			return result;
+
+		encode_entry(&next_entry, next_value, NULL);
+	}
+
+	if (result != UDS_SUCCESS)
+		return result;
+
+	encode_entry(delta_entry, value, name);
+	delta_zone = delta_entry->delta_zone;
+	delta_zone->record_count++;
+	delta_zone->collision_count += delta_entry->is_collision ? 1 : 0;
+	return UDS_SUCCESS;
+}
+
+static void delete_bits(const struct delta_index_entry *delta_entry, int size)
+{
+	u64 source;
+	u64 destination;
+	u32 count;
+	bool before_flag;
+	struct delta_list *delta_list = delta_entry->delta_list;
+	u8 *memory = delta_entry->delta_zone->memory;
+	/* Compute bits retained before and after the deleted bits. */
+	u32 total_size = delta_list->size;
+	u32 before_size = delta_entry->offset;
+	u32 after_size = total_size - delta_entry->offset - size;
+
+	/*
+	 * Determine whether to add to the available space either before or after the delta list.
+	 * We prefer to move the least amount of data. If it is exactly the same, try to add to the
+	 * smaller amount of free space.
+	 */
+	if (before_size < after_size) {
+		before_flag = true;
+	} else if (after_size < before_size) {
+		before_flag = false;
+	} else {
+		u64 free_before =
+			(delta_list[0].start - (delta_list[-1].start + delta_list[-1].size));
+		u64 free_after =
+			(delta_list[1].start - (delta_list[0].start + delta_list[0].size));
+
+		before_flag = (free_before < free_after);
+	}
+
+	delta_list->size -= size;
+	if (before_flag) {
+		source = delta_list->start;
+		destination = source + size;
+		delta_list->start += size;
+		count = before_size;
+	} else {
+		destination = delta_list->start + delta_entry->offset;
+		source = destination + size;
+		count = after_size;
+	}
+
+	move_bits(memory, source, memory, destination, count);
+}
+
+int uds_remove_delta_index_entry(struct delta_index_entry *delta_entry)
+{
+	int result;
+	struct delta_index_entry next_entry;
+	struct delta_zone *delta_zone;
+	struct delta_list *delta_list;
+
+	result = assert_mutable_entry(delta_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	next_entry = *delta_entry;
+	result = uds_next_delta_index_entry(&next_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	delta_zone = delta_entry->delta_zone;
+
+	if (delta_entry->is_collision) {
+		/* This is a collision entry, so just remove it. */
+		delete_bits(delta_entry, delta_entry->entry_bits);
+		next_entry.offset = delta_entry->offset;
+		delta_zone->collision_count -= 1;
+	} else if (next_entry.at_end) {
+		/* This entry is at the end of the list, so just remove it. */
+		delete_bits(delta_entry, delta_entry->entry_bits);
+		next_entry.key -= delta_entry->delta;
+		next_entry.offset = delta_entry->offset;
+	} else {
+		/* The delta in the next entry needs to be updated. */
+		u32 next_value = uds_get_delta_entry_value(&next_entry);
+		u16 old_size = delta_entry->entry_bits + next_entry.entry_bits;
+
+		if (next_entry.is_collision) {
+			next_entry.is_collision = false;
+			delta_zone->collision_count -= 1;
+		}
+
+		set_delta(&next_entry, delta_entry->delta + next_entry.delta);
+		next_entry.offset = delta_entry->offset;
+		/* The one new entry is always smaller than the two entries being replaced. */
+		delete_bits(delta_entry, old_size - next_entry.entry_bits);
+		encode_entry(&next_entry, next_value, NULL);
+	}
+
+	delta_zone->record_count--;
+	delta_zone->discard_count++;
+	*delta_entry = next_entry;
+
+	delta_list = delta_entry->delta_list;
+	if (delta_entry->offset < delta_list->save_offset) {
+		/* The saved entry offset is no longer valid. */
+		delta_list->save_key = 0;
+		delta_list->save_offset = 0;
+	}
+
+	return UDS_SUCCESS;
+}
+
+void uds_get_delta_index_stats(const struct delta_index *delta_index,
+			       struct delta_index_stats *stats)
+{
+	unsigned int z;
+	const struct delta_zone *delta_zone;
+
+	memset(stats, 0, sizeof(struct delta_index_stats));
+	for (z = 0; z < delta_index->zone_count; z++) {
+		delta_zone = &delta_index->delta_zones[z];
+		stats->rebalance_time += delta_zone->rebalance_time;
+		stats->rebalance_count += delta_zone->rebalance_count;
+		stats->record_count += delta_zone->record_count;
+		stats->collision_count += delta_zone->collision_count;
+		stats->discard_count += delta_zone->discard_count;
+		stats->overflow_count += delta_zone->overflow_count;
+		stats->list_count += delta_zone->list_count;
+	}
+}
+
+size_t uds_compute_delta_index_size(u32 entry_count, u32 mean_delta, u32 payload_bits)
+{
+	u16 min_bits;
+	u32 incr_keys;
+	u32 min_keys;
+
+	compute_coding_constants(mean_delta, &min_bits, &min_keys, &incr_keys);
+	/* On average, each delta is encoded into about min_bits + 1.5 bits. */
+	return entry_count * (payload_bits + min_bits + 1) + entry_count / 2;
+}
+
+u32 uds_get_delta_index_page_count(u32 entry_count,
+				   u32 list_count,
+				   u32 mean_delta,
+				   u32 payload_bits,
+				   size_t bytes_per_page)
+{
+	unsigned int bits_per_delta_list;
+	unsigned int bits_per_page;
+	size_t bits_per_index;
+
+	/* Compute the expected number of bits needed for all the entries. */
+	bits_per_index = uds_compute_delta_index_size(entry_count, mean_delta, payload_bits);
+	bits_per_delta_list = bits_per_index / list_count;
+
+	/* Add in the immutable delta list headers. */
+	bits_per_index += list_count * IMMUTABLE_HEADER_SIZE;
+	/* Compute the number of usable bits on an immutable index page. */
+	bits_per_page = ((bytes_per_page - sizeof(struct delta_page_header)) * BITS_PER_BYTE);
+	/*
+	 * Reduce the bits per page by one immutable delta list header and one delta list to
+	 * account for internal fragmentation.
+	 */
+	bits_per_page -= IMMUTABLE_HEADER_SIZE + bits_per_delta_list;
+	/* Now compute the number of pages needed. */
+	return DIV_ROUND_UP(bits_per_index, bits_per_page);
+}
+
+void uds_log_delta_index_entry(struct delta_index_entry *delta_entry)
+{
+	uds_log_ratelimit(uds_log_info,
+			  "List 0x%X Key 0x%X Offset 0x%X%s%s List_size 0x%X%s",
+			  delta_entry->list_number,
+			  delta_entry->key,
+			  delta_entry->offset,
+			  delta_entry->at_end ? " end" : "",
+			  delta_entry->is_collision ? " collision" : "",
+			  delta_entry->delta_list->size,
+			  delta_entry->list_overflow ? " overflow" : "");
+	delta_entry->list_overflow = false;
+}
diff --git a/drivers/md/dm-vdo/delta-index.h b/drivers/md/dm-vdo/delta-index.h
new file mode 100644
index 00000000000..ee505d9a6eb
--- /dev/null
+++ b/drivers/md/dm-vdo/delta-index.h
@@ -0,0 +1,292 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_DELTA_INDEX_H
+#define UDS_DELTA_INDEX_H
+
+#include <linux/cache.h>
+
+#include "config.h"
+#include "io-factory.h"
+#include "numeric.h"
+#include "time-utils.h"
+
+/*
+ * A delta index is a key-value store, where each entry maps an address (the key) to a payload (the
+ * value). The entries are sorted by address, and only the delta between successive addresses is
+ * stored in the entry. The addresses are assumed to be uniformly distributed, and the deltas are
+ * therefore exponentially distributed.
+ *
+ * A delta_index can either be mutable or immutable depending on its expected use. The immutable
+ * form of a delta index is used for the indexes of closed chapters committed to the volume. The
+ * mutable form of a delta index is used by the volume index, and also by the chapter index in an
+ * open chapter. Like the index as a whole, each mutable delta index is divided into a number of
+ * independent zones.
+ */
+
+struct delta_list {
+	/* The offset of the delta list start, in bits */
+	u64 start;
+	/* The number of bits in the delta list */
+	u16 size;
+	/* Where the last search "found" the key, in bits */
+	u16 save_offset;
+	/* The key for the record just before save_offset */
+	u32 save_key;
+};
+
+struct delta_zone {
+	/* The delta list memory */
+	u8 *memory;
+	/* The delta list headers */
+	struct delta_list *delta_lists;
+	/* Temporary starts of delta lists */
+	u64 *new_offsets;
+	/* Buffered writer for saving an index */
+	struct buffered_writer *buffered_writer;
+	/* The size of delta list memory */
+	size_t size;
+	/* Nanoseconds spent rebalancing */
+	ktime_t rebalance_time;
+	/* Number of memory rebalances */
+	u32 rebalance_count;
+	/* The number of bits in a stored value */
+	u8 value_bits;
+	/* The number of bits in the minimal key code */
+	u16 min_bits;
+	/* The number of keys used in a minimal code */
+	u32 min_keys;
+	/* The number of keys used for another code bit */
+	u32 incr_keys;
+	/* The number of records in the index */
+	u64 record_count;
+	/* The number of collision records */
+	u64 collision_count;
+	/* The number of records removed */
+	u64 discard_count;
+	/* The number of UDS_OVERFLOW errors detected */
+	u64 overflow_count;
+	/* The index of the first delta list */
+	u32 first_list;
+	/* The number of delta lists */
+	u32 list_count;
+	/* Tag belonging to this delta index */
+	u8 tag;
+} __aligned(L1_CACHE_BYTES);
+
+struct delta_list_save_info {
+	/* Tag identifying which delta index this list is in */
+	u8 tag;
+	/* Bit offset of the start of the list data */
+	u8 bit_offset;
+	/* Number of bytes of list data */
+	u16 byte_count;
+	/* The delta list number within the delta index */
+	u32 index;
+} __packed;
+
+struct delta_index {
+	/* The zones */
+	struct delta_zone *delta_zones;
+	/* The number of zones */
+	unsigned int zone_count;
+	/* The number of delta lists */
+	u32 list_count;
+	/* Maximum lists per zone */
+	u32 lists_per_zone;
+	/* Total memory allocated to this index */
+	size_t memory_size;
+	/* The number of non-empty lists at load time per zone */
+	u32 load_lists[MAX_ZONES];
+	/* True if this index is mutable */
+	bool mutable;
+	/* Tag belonging to this delta index */
+	u8 tag;
+};
+
+/*
+ * A delta_index_page describes a single page of a chapter index. The delta_index field allows the
+ * page to be treated as an immutable delta_index. We use the delta_zone field to treat the chapter
+ * index page as a single zone index, and without the need to do an additional memory allocation.
+ */
+struct delta_index_page {
+	struct delta_index delta_index;
+	/* These values are loaded from the DeltaPageHeader */
+	u32 lowest_list_number;
+	u32 highest_list_number;
+	u64 virtual_chapter_number;
+	/* This structure describes the single zone of a delta index page. */
+	struct delta_zone delta_zone;
+};
+
+/*
+ * Notes on the delta_index_entries:
+ *
+ * The fields documented as "public" can be read by any code that uses a delta_index. The fields
+ * documented as "private" carry information between delta_index method calls and should not be
+ * used outside the delta_index module.
+ *
+ * (1) The delta_index_entry is used like an iterator when searching a delta list.
+ *
+ * (2) It is also the result of a successful search and can be used to refer to the element found
+ *     by the search.
+ *
+ * (3) It is also the result of an unsuccessful search and can be used to refer to the insertion
+ *     point for a new record.
+ *
+ * (4) If at_end is true, the delta_list entry can only be used as the insertion point for a new
+ *     record at the end of the list.
+ *
+ * (5) If at_end is false and is_collision is true, the delta_list entry fields refer to a
+ *     collision entry in the list, and the delta_list entry can be used a a reference to this
+ *     entry.
+ *
+ * (6) If at_end is false and is_collision is false, the delta_list entry fields refer to a
+ *     non-collision entry in the list. Such delta_list entries can be used as a reference to a
+ *     found entry, or an insertion point for a non-collision entry before this entry, or an
+ *     insertion point for a collision entry that collides with this entry.
+ */
+struct delta_index_entry {
+	/* Public fields */
+	/* The key for this entry */
+	u32 key;
+	/* We are after the last list entry */
+	bool at_end;
+	/* This record is a collision */
+	bool is_collision;
+
+	/* Private fields */
+	/* This delta list overflowed */
+	bool list_overflow;
+	/* The number of bits used for the value */
+	u8 value_bits;
+	/* The number of bits used for the entire entry */
+	u16 entry_bits;
+	/* The delta index zone */
+	struct delta_zone *delta_zone;
+	/* The delta list containing the entry */
+	struct delta_list *delta_list;
+	/* The delta list number */
+	u32 list_number;
+	/* Bit offset of this entry within the list */
+	u16 offset;
+	/* The delta between this and previous entry */
+	u32 delta;
+	/* Temporary delta list for immutable indices */
+	struct delta_list temp_delta_list;
+};
+
+struct delta_index_stats {
+	/* Number of bytes allocated */
+	size_t memory_allocated;
+	/* Nanoseconds spent rebalancing */
+	ktime_t rebalance_time;
+	/* Number of memory rebalances */
+	u32 rebalance_count;
+	/* The number of records in the index */
+	u64 record_count;
+	/* The number of collision records */
+	u64 collision_count;
+	/* The number of records removed */
+	u64 discard_count;
+	/* The number of UDS_OVERFLOW errors detected */
+	u64 overflow_count;
+	/* The number of delta lists */
+	u32 list_count;
+};
+
+int __must_check uds_initialize_delta_index(struct delta_index *delta_index,
+					    unsigned int zone_count,
+					    u32 list_count,
+					    u32 mean_delta,
+					    u32 payload_bits,
+					    size_t memory_size,
+					    u8 tag);
+
+int __must_check uds_initialize_delta_index_page(struct delta_index_page *delta_index_page,
+						 u64 expected_nonce,
+						 u32 mean_delta,
+						 u32 payload_bits,
+						 u8 *memory,
+						 size_t memory_size);
+
+void uds_uninitialize_delta_index(struct delta_index *delta_index);
+
+void uds_reset_delta_index(const struct delta_index *delta_index);
+
+int __must_check uds_pack_delta_index_page(const struct delta_index *delta_index,
+					   u64 header_nonce,
+					   u8 *memory,
+					   size_t memory_size,
+					   u64 virtual_chapter_number,
+					   u32 first_list,
+					   u32 *list_count);
+
+int __must_check uds_start_restoring_delta_index(struct delta_index *delta_index,
+						 struct buffered_reader **buffered_readers,
+						 unsigned int reader_count);
+
+int __must_check uds_finish_restoring_delta_index(struct delta_index *delta_index,
+						  struct buffered_reader **buffered_readers,
+						  unsigned int reader_count);
+
+int __must_check
+uds_check_guard_delta_lists(struct buffered_reader **buffered_readers, unsigned int reader_count);
+
+int __must_check uds_start_saving_delta_index(const struct delta_index *delta_index,
+					      unsigned int zone_number,
+					      struct buffered_writer *buffered_writer);
+
+int __must_check
+uds_finish_saving_delta_index(const struct delta_index *delta_index, unsigned int zone_number);
+
+int __must_check uds_write_guard_delta_list(struct buffered_writer *buffered_writer);
+
+size_t __must_check uds_compute_delta_index_save_bytes(u32 list_count, size_t memory_size);
+
+int __must_check uds_start_delta_index_search(const struct delta_index *delta_index,
+					      u32 list_number,
+					      u32 key,
+					      struct delta_index_entry *iterator);
+
+int __must_check uds_next_delta_index_entry(struct delta_index_entry *delta_entry);
+
+int __must_check uds_remember_delta_index_offset(const struct delta_index_entry *delta_entry);
+
+int __must_check uds_get_delta_index_entry(const struct delta_index *delta_index,
+					   u32 list_number,
+					   u32 key,
+					   const u8 *name,
+					   struct delta_index_entry *delta_entry);
+
+int __must_check
+uds_get_delta_entry_collision(const struct delta_index_entry *delta_entry, u8 *name);
+
+u32 __must_check uds_get_delta_entry_value(const struct delta_index_entry *delta_entry);
+
+int __must_check uds_set_delta_entry_value(const struct delta_index_entry *delta_entry, u32 value);
+
+int __must_check uds_put_delta_index_entry(struct delta_index_entry *delta_entry,
+					   u32 key,
+					   u32 value,
+					   const u8 *name);
+
+int __must_check uds_remove_delta_index_entry(struct delta_index_entry *delta_entry);
+
+void uds_get_delta_index_stats(const struct delta_index *delta_index,
+			       struct delta_index_stats *stats);
+
+size_t __must_check
+uds_compute_delta_index_size(u32 entry_count, u32 mean_delta, u32 payload_bits);
+
+u32 uds_get_delta_index_page_count(u32 entry_count,
+				   u32 list_count,
+				   u32 mean_delta,
+				   u32 payload_bits,
+				   size_t bytes_per_page);
+
+void uds_log_delta_index_entry(struct delta_index_entry *delta_entry);
+
+#endif /* UDS_DELTA_INDEX_H */
diff --git a/drivers/md/dm-vdo/errors.c b/drivers/md/dm-vdo/errors.c
new file mode 100644
index 00000000000..7654a1f9f97
--- /dev/null
+++ b/drivers/md/dm-vdo/errors.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "errors.h"
+
+#include <linux/compiler.h>
+#include <linux/errno.h>
+
+#include "logger.h"
+#include "permassert.h"
+#include "string-utils.h"
+
+static const struct error_info successful = { "UDS_SUCCESS", "Success" };
+
+static const char *const message_table[] = {
+	[EPERM] = "Operation not permitted",
+	[ENOENT] = "No such file or directory",
+	[ESRCH] = "No such process",
+	[EINTR] = "Interrupted system call",
+	[EIO] = "Input/output error",
+	[ENXIO] = "No such device or address",
+	[E2BIG] = "Argument list too long",
+	[ENOEXEC] = "Exec format error",
+	[EBADF] = "Bad file descriptor",
+	[ECHILD] = "No child processes",
+	[EAGAIN] = "Resource temporarily unavailable",
+	[ENOMEM] = "Cannot allocate memory",
+	[EACCES] = "Permission denied",
+	[EFAULT] = "Bad address",
+	[ENOTBLK] = "Block device required",
+	[EBUSY] = "Device or resource busy",
+	[EEXIST] = "File exists",
+	[EXDEV] = "Invalid cross-device link",
+	[ENODEV] = "No such device",
+	[ENOTDIR] = "Not a directory",
+	[EISDIR] = "Is a directory",
+	[EINVAL] = "Invalid argument",
+	[ENFILE] = "Too many open files in system",
+	[EMFILE] = "Too many open files",
+	[ENOTTY] = "Inappropriate ioctl for device",
+	[ETXTBSY] = "Text file busy",
+	[EFBIG] = "File too large",
+	[ENOSPC] = "No space left on device",
+	[ESPIPE] = "Illegal seek",
+	[EROFS] = "Read-only file system",
+	[EMLINK] = "Too many links",
+	[EPIPE] = "Broken pipe",
+	[EDOM] = "Numerical argument out of domain",
+	[ERANGE] = "Numerical result out of range"
+};
+
+static const struct error_info error_list[] = {
+	{ "UDS_OVERFLOW", "Index overflow" },
+	{ "UDS_INVALID_ARGUMENT", "Invalid argument passed to internal routine" },
+	{ "UDS_BAD_STATE", "UDS data structures are in an invalid state" },
+	{ "UDS_DUPLICATE_NAME", "Attempt to enter the same name into a delta index twice" },
+	{ "UDS_ASSERTION_FAILED", "Assertion failed" },
+	{ "UDS_QUEUED", "Request queued" },
+	{ "UDS_BUFFER_ERROR", "Buffer error" },
+	{ "UDS_NO_DIRECTORY", "Expected directory is missing" },
+	{ "UDS_ALREADY_REGISTERED", "Error range already registered" },
+	{ "UDS_OUT_OF_RANGE", "Cannot access data outside specified limits" },
+	{ "UDS_EMODULE_LOAD", "Could not load modules" },
+	{ "UDS_DISABLED", "UDS library context is disabled" },
+	{ "UDS_UNKNOWN_ERROR", "Unknown error" },
+	{ "UDS_UNSUPPORTED_VERSION", "Unsupported version" },
+	{ "UDS_CORRUPT_DATA", "Some index structure is corrupt" },
+	{ "UDS_NO_INDEX", "No index found" },
+	{ "UDS_INDEX_NOT_SAVED_CLEANLY", "Index not saved cleanly" },
+};
+
+struct error_block {
+	const char *name;
+	int base;
+	int last;
+	int max;
+	const struct error_info *infos;
+};
+
+enum {
+	MAX_ERROR_BLOCKS = 6,
+};
+
+static struct {
+	int allocated;
+	int count;
+	struct error_block blocks[MAX_ERROR_BLOCKS];
+} registered_errors = {
+	.allocated = MAX_ERROR_BLOCKS,
+	.count = 1,
+	.blocks = { {
+			.name = "UDS Error",
+			.base = UDS_ERROR_CODE_BASE,
+			.last = UDS_ERROR_CODE_LAST,
+			.max = UDS_ERROR_CODE_BLOCK_END,
+			.infos = error_list,
+		  } },
+};
+
+/* Get the error info for an error number. Also returns the name of the error block, if known. */
+static const char *get_error_info(int errnum, const struct error_info **info_ptr)
+{
+	struct error_block *block;
+
+	if (errnum == UDS_SUCCESS) {
+		*info_ptr = &successful;
+		return NULL;
+	}
+
+	for (block = registered_errors.blocks;
+	     block < registered_errors.blocks + registered_errors.count;
+	     ++block) {
+		if ((errnum >= block->base) && (errnum < block->last)) {
+			*info_ptr = block->infos + (errnum - block->base);
+			return block->name;
+		} else if ((errnum >= block->last) && (errnum < block->max)) {
+			*info_ptr = NULL;
+			return block->name;
+		}
+	}
+
+	return NULL;
+}
+
+/* Return a string describing a system error message. */
+static const char *system_string_error(int errnum, char *buf, size_t buflen)
+{
+	size_t len;
+	const char *error_string = NULL;
+
+	if ((errnum > 0) && (errnum < ARRAY_SIZE(message_table)))
+		error_string = message_table[errnum];
+
+	len = ((error_string == NULL) ?
+		 snprintf(buf, buflen, "Unknown error %d", errnum) :
+		 snprintf(buf, buflen, "%s", error_string));
+	if (len < buflen)
+		return buf;
+
+	buf[0] = '\0';
+	return "System error";
+}
+
+/* Convert an error code to a descriptive string. */
+const char *uds_string_error(int errnum, char *buf, size_t buflen)
+{
+	char *buffer = buf;
+	char *buf_end = buf + buflen;
+	const struct error_info *info = NULL;
+	const char *block_name;
+
+	if (buf == NULL)
+		return NULL;
+
+	if (errnum < 0)
+		errnum = -errnum;
+
+	block_name = get_error_info(errnum, &info);
+	if (block_name != NULL) {
+		if (info != NULL)
+			buffer = uds_append_to_buffer(buffer,
+						      buf_end,
+						      "%s: %s",
+						      block_name,
+						      info->message);
+		else
+			buffer = uds_append_to_buffer(buffer,
+						      buf_end,
+						      "Unknown %s %d",
+						      block_name,
+						      errnum);
+	} else if (info != NULL) {
+		buffer = uds_append_to_buffer(buffer, buf_end, "%s", info->message);
+	} else {
+		const char *tmp = system_string_error(errnum, buffer, buf_end - buffer);
+
+		if (tmp != buffer)
+			buffer = uds_append_to_buffer(buffer, buf_end, "%s", tmp);
+		else
+			buffer += strlen(tmp);
+	}
+	return buf;
+}
+
+/* Convert an error code to its name. */
+const char *uds_string_error_name(int errnum, char *buf, size_t buflen)
+{
+	char *buffer = buf;
+	char *buf_end = buf + buflen;
+	const struct error_info *info = NULL;
+	const char *block_name;
+
+	if (errnum < 0)
+		errnum = -errnum;
+
+	block_name = get_error_info(errnum, &info);
+	if (block_name != NULL) {
+		if (info != NULL)
+			buffer = uds_append_to_buffer(buffer, buf_end, "%s", info->name);
+		else
+			buffer = uds_append_to_buffer(buffer,
+						      buf_end,
+						      "%s %d",
+						      block_name,
+						      errnum);
+	} else if (info != NULL) {
+		buffer = uds_append_to_buffer(buffer, buf_end, "%s", info->name);
+	} else {
+		const char *tmp;
+
+		tmp = system_string_error(errnum, buffer, buf_end - buffer);
+		if (tmp != buffer)
+			buffer = uds_append_to_buffer(buffer, buf_end, "%s", tmp);
+		else
+			buffer += strlen(tmp);
+	}
+	return buf;
+}
+
+/*
+ * Translate an error code into a value acceptable to the kernel. The input error code may be a
+ * system-generated value (such as -EIO), or an internal UDS status code. The result will be a
+ * negative errno value.
+ */
+int uds_map_to_system_error(int error)
+{
+	char error_name[UDS_MAX_ERROR_NAME_SIZE];
+	char error_message[UDS_MAX_ERROR_MESSAGE_SIZE];
+
+	/* 0 is success, and negative values are already system error codes. */
+	if (likely(error <= 0))
+		return error;
+
+	if (error < 1024)
+		/* This is probably an errno from userspace. */
+		return -error;
+
+	/* Internal UDS errors */
+	switch (error) {
+	case UDS_NO_INDEX:
+	case UDS_CORRUPT_DATA:
+		/* The index doesn't exist or can't be recovered. */
+		return -ENOENT;
+
+	case UDS_INDEX_NOT_SAVED_CLEANLY:
+	case UDS_UNSUPPORTED_VERSION:
+		/*
+		 * The index exists, but can't be loaded. Tell the client it exists so they don't
+		 * destroy it inadvertently.
+		 */
+		return -EEXIST;
+
+	case UDS_DISABLED:
+		/* The session is unusable; only returned by requests. */
+		return -EIO;
+
+	default:
+		/* Translate an unexpected error into something generic. */
+		uds_log_info("%s: mapping status code %d (%s: %s) to -EIO",
+			     __func__,
+			     error,
+			     uds_string_error_name(error, error_name, sizeof(error_name)),
+			     uds_string_error(error, error_message, sizeof(error_message)));
+		return -EIO;
+	}
+}
+
+/*
+ * Register a block of error codes.
+ *
+ * @block_name: the name of the block of error codes
+ * @first_error: the first error code in the block
+ * @next_free_error: one past the highest possible error in the block
+ * @infos: a pointer to the error info array for the block
+ * @info_size: the size of the error info array
+ */
+int uds_register_error_block(const char *block_name,
+			     int first_error,
+			     int next_free_error,
+			     const struct error_info *infos,
+			     size_t info_size)
+{
+	int result;
+	struct error_block *block;
+	struct error_block new_block = {
+		.name = block_name,
+		.base = first_error,
+		.last = first_error + (info_size / sizeof(struct error_info)),
+		.max = next_free_error,
+		.infos = infos,
+	};
+
+	result = ASSERT(first_error < next_free_error, "well-defined error block range");
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (registered_errors.count == registered_errors.allocated)
+		/* This should never happen. */
+		return UDS_OVERFLOW;
+
+	for (block = registered_errors.blocks;
+	     block < registered_errors.blocks + registered_errors.count;
+	     ++block) {
+		if (strcmp(block_name, block->name) == 0)
+			return UDS_DUPLICATE_NAME;
+
+		/* Ensure error ranges do not overlap. */
+		if ((first_error < block->max) && (next_free_error > block->base))
+			return UDS_ALREADY_REGISTERED;
+	}
+
+	registered_errors.blocks[registered_errors.count++] = new_block;
+	return UDS_SUCCESS;
+}
diff --git a/drivers/md/dm-vdo/errors.h b/drivers/md/dm-vdo/errors.h
new file mode 100644
index 00000000000..f6dbf2c514e
--- /dev/null
+++ b/drivers/md/dm-vdo/errors.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_ERRORS_H
+#define UDS_ERRORS_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/* Custom error codes and error-related utilities for UDS */
+
+/* Valid status codes for internal UDS functions. */
+enum uds_status_codes {
+	/* Successful return */
+	UDS_SUCCESS = 0,
+
+	/* Used as a base value for reporting internal errors */
+	UDS_ERROR_CODE_BASE = 1024,
+	/* Index overflow */
+	UDS_OVERFLOW = UDS_ERROR_CODE_BASE + 0,
+	/* Invalid argument passed to internal routine */
+	UDS_INVALID_ARGUMENT = UDS_ERROR_CODE_BASE + 1,
+	/* UDS data structures are in an invalid state */
+	UDS_BAD_STATE = UDS_ERROR_CODE_BASE + 2,
+	/* Attempt to enter the same name into an internal structure twice */
+	UDS_DUPLICATE_NAME = UDS_ERROR_CODE_BASE + 3,
+	/* An assertion failed */
+	UDS_ASSERTION_FAILED = UDS_ERROR_CODE_BASE + 4,
+	/* A request has been queued for later processing (not an error) */
+	UDS_QUEUED = UDS_ERROR_CODE_BASE + 5,
+	/* A problem has occured with a buffer */
+	UDS_BUFFER_ERROR = UDS_ERROR_CODE_BASE + 6,
+	/* No directory was found where one was expected */
+	UDS_NO_DIRECTORY = UDS_ERROR_CODE_BASE + 7,
+	/* This error range has already been registered */
+	UDS_ALREADY_REGISTERED = UDS_ERROR_CODE_BASE + 8,
+	/* Attempt to read or write data outside the valid range */
+	UDS_OUT_OF_RANGE = UDS_ERROR_CODE_BASE + 9,
+	/* Could not load modules */
+	UDS_EMODULE_LOAD = UDS_ERROR_CODE_BASE + 10,
+	/* The index session is disabled */
+	UDS_DISABLED = UDS_ERROR_CODE_BASE + 11,
+	/* Unknown error */
+	UDS_UNKNOWN_ERROR = UDS_ERROR_CODE_BASE + 12,
+	/* The index configuration or volume format is no longer supported */
+	UDS_UNSUPPORTED_VERSION = UDS_ERROR_CODE_BASE + 13,
+	/* Some index structure is corrupt */
+	UDS_CORRUPT_DATA = UDS_ERROR_CODE_BASE + 14,
+	/* No index state found */
+	UDS_NO_INDEX = UDS_ERROR_CODE_BASE + 15,
+	/* Attempt to access incomplete index save data */
+	UDS_INDEX_NOT_SAVED_CLEANLY = UDS_ERROR_CODE_BASE + 16,
+	/* One more than the last UDS_INTERNAL error code */
+	UDS_ERROR_CODE_LAST,
+	/* One more than the last error this block will ever use */
+	UDS_ERROR_CODE_BLOCK_END = UDS_ERROR_CODE_BASE + 440,
+};
+
+enum {
+	UDS_MAX_ERROR_NAME_SIZE = 80,
+	UDS_MAX_ERROR_MESSAGE_SIZE = 128,
+};
+
+struct error_info {
+	const char *name;
+	const char *message;
+};
+
+const char * __must_check uds_string_error(int errnum, char *buf, size_t buflen);
+
+const char *uds_string_error_name(int errnum, char *buf, size_t buflen);
+
+int uds_map_to_system_error(int error);
+
+int uds_register_error_block(const char *block_name,
+			     int first_error,
+			     int last_reserved_error,
+			     const struct error_info *infos,
+			     size_t info_size);
+
+#endif /* UDS_ERRORS_H */
diff --git a/drivers/md/dm-vdo/event-count.c b/drivers/md/dm-vdo/event-count.c
new file mode 100644
index 00000000000..4978ffc4791
--- /dev/null
+++ b/drivers/md/dm-vdo/event-count.c
@@ -0,0 +1,301 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+/*
+ * This event count implementation uses a posix semaphore for portability, although a futex would
+ * be slightly superior to use and easy to substitute. It is designed to make signalling as cheap
+ * as possible, since that is the code path likely triggered on most updates to a lock-free data
+ * structure. Waiters are likely going to sleep, so optimizing for that case isn't necessary.
+ *
+ * The critical field is the state, which is really two fields that can be atomically updated in
+ * unison: an event counter and a waiter count. Every call to event_count_prepare() issues a wait
+ * token by atomically incrementing the waiter count. The key invariant is a strict accounting of
+ * the number of tokens issued. Every token returned by event_count_prepare() is a contract that
+ * the caller will call uds_acquire_semaphore() and a signaller will call uds_release_semaphore(),
+ * each exactly once. Atomic updates to the state field ensure that each token is counted once and
+ * that tokens are not lost. Cancelling a token attempts to take a fast-path by simply decrementing
+ * the waiters field, but if the token has already been claimed by a signaller, the canceller must
+ * still wait on the semaphore to consume the transferred token.
+ *
+ * The state field is 64 bits, partitioned into a 16-bit waiter field and a 48-bit counter. We are
+ * unlikely to have 2^16 threads, much less 2^16 threads waiting on any single event transition.
+ * 2^48 microseconds is several years, so a token holder would have to wait that long for the
+ * counter to wrap around, and then call event_count_wait() at the exact right time to see the
+ * re-used counter, in order to lose a wakeup due to counter wrap-around. Using a 32-bit state
+ * field would greatly increase that chance, but if forced to do so, the implementation could
+ * likely tolerate it since callers are supposed to hold tokens for miniscule periods of time.
+ * Fortunately, x64 has 64-bit compare-and-swap, and the performance of interlocked 64-bit
+ * operations appears to be about the same as for 32-bit ones, so being paranoid and using 64 bits
+ * costs us nothing.
+ *
+ * Here are some sequences of calls and state transitions:
+ *
+ *    action                    postcondition
+ *                        counter   waiters   semaphore
+ *    initialized           0          0          0
+ *    prepare               0          1          0
+ *    wait (blocks)         0          1          0
+ *    signal                1          0          1
+ *    wait (unblocks)       1          0          0
+ *
+ *    signal (fast-path)    1          0          0
+ *    signal (fast-path)    1          0          0
+ *
+ *    prepare A             1          1          0
+ *    prepare B             1          2          0
+ *    signal                2          0          2
+ *    wait B (fast-path)    2          0          1
+ *    wait A (fast-path)    2          0          0
+ *
+ *    prepare               2          1          0
+ *    cancel (fast-path)    2          0          0
+ *
+ *    prepare               2          1          0
+ *    signal                3          0          1
+ *    cancel (must wait)    3          0          0
+ *
+ * The event count structure is aligned, sized, and allocated to cache line boundaries to avoid any
+ * false sharing between the event count and other shared state. The state field and semaphore
+ * should fit on a single cache line. The instrumentation counters increase the size of the
+ * structure so it rounds up to use two (64-byte x86) cache lines.
+ */
+
+#include "event-count.h"
+
+#include <linux/atomic.h>
+#include <linux/cache.h>
+#include <linux/compiler.h>
+
+#include "logger.h"
+#include "memory-alloc.h"
+#include "uds-threads.h"
+
+enum {
+	/* value used to increment the waiters field */
+	ONE_WAITER = 1,
+	/* value used to increment the event counter */
+	ONE_EVENT = (1 << 16),
+	/* bit mask to access the waiters field */
+	WAITERS_MASK = (ONE_EVENT - 1),
+	/* bit mask to access the event counter */
+	EVENTS_MASK = ~WAITERS_MASK,
+};
+
+struct event_count {
+	/*
+	 * Atomically mutable state:
+	 * low  16 bits: the number of wait tokens not posted to the semaphore
+	 * high 48 bits: current event counter
+	 */
+	atomic64_t state;
+
+	/* Semaphore used to block threads when waiting is required. */
+	struct semaphore semaphore;
+
+	/* Declare alignment so we don't share a cache line. */
+} __aligned(L1_CACHE_BYTES);
+
+static inline bool same_event(event_token_t token1, event_token_t token2)
+{
+	return (token1 & EVENTS_MASK) == (token2 & EVENTS_MASK);
+}
+
+/* Wake all threads that are waiting for the next event. */
+void event_count_broadcast(struct event_count *count)
+{
+	u64 waiters;
+	u64 state;
+	u64 old_state;
+
+	/* Even if there are no waiters (yet), we will need a memory barrier. */
+	smp_mb();
+
+	state = old_state = atomic64_read(&count->state);
+	do {
+		event_token_t new_state;
+
+		/*
+		 * Check if there are any tokens that have not yet been transferred to the
+		 * semaphore. This is the fast no-waiters path.
+		 */
+		waiters = (state & WAITERS_MASK);
+		if (waiters == 0)
+			/*
+			 * Fast path first time through -- no need to signal or post if there are
+			 * no observers.
+			 */
+			return;
+
+		/*
+		 * Attempt to atomically claim all the wait tokens and bump the event count using
+		 * an atomic compare-and-swap. This operation contains a memory barrier.
+		 */
+		new_state = ((state & ~WAITERS_MASK) + ONE_EVENT);
+		old_state = state;
+		state = atomic64_cmpxchg(&count->state, old_state, new_state);
+		/*
+		 * The cmpxchg fails when we lose a race with a new waiter or another signaller, so
+		 * try again.
+		 */
+	} while (unlikely(state != old_state));
+
+	/*
+	 * Wake the waiters by posting to the semaphore. This effectively transfers the wait tokens
+	 * to the semaphore. There's sadly no bulk post for posix semaphores, so we've got to loop
+	 * to do them all.
+	 */
+	while (waiters-- > 0)
+		uds_release_semaphore(&count->semaphore);
+}
+
+/*
+ * Attempt to cancel a prepared wait token by decrementing the number of waiters in the current
+ * state. This can only be done safely if the event count hasn't been incremented. Returns true if
+ * the wait was successfully cancelled.
+ */
+static inline bool fast_cancel(struct event_count *count, event_token_t token)
+{
+	event_token_t current_token = atomic64_read(&count->state);
+	event_token_t new_token;
+
+	while (same_event(current_token, token)) {
+		/*
+		 * Try to decrement the waiter count via compare-and-swap as if we had never
+		 * prepared to wait.
+		 */
+		new_token = atomic64_cmpxchg(&count->state, current_token, current_token - 1);
+		if (new_token == current_token)
+			return true;
+
+		current_token = new_token;
+	}
+
+	return false;
+}
+
+/*
+ * Consume a token from the semaphore, waiting (with an optional timeout) if one is not currently
+ * available. Returns true if a token was consumed.
+ */
+static bool consume_wait_token(struct event_count *count, const ktime_t *timeout)
+{
+	/* Try to grab a token without waiting. */
+	if (uds_attempt_semaphore(&count->semaphore, 0))
+		return true;
+
+	if (timeout == NULL)
+		uds_acquire_semaphore(&count->semaphore);
+	else if (!uds_attempt_semaphore(&count->semaphore, *timeout))
+		return false;
+
+	return true;
+}
+
+int make_event_count(struct event_count **count_ptr)
+{
+	/*
+	 * The event count will be allocated on a cache line boundary so there will not be false
+	 * sharing of the line with any other data structure.
+	 */
+	int result;
+	struct event_count *count = NULL;
+
+	result = UDS_ALLOCATE(1, struct event_count, "event count", &count);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	atomic64_set(&count->state, 0);
+	result = uds_initialize_semaphore(&count->semaphore, 0);
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(count);
+		return result;
+	}
+
+	*count_ptr = count;
+	return UDS_SUCCESS;
+}
+
+/* Free a struct event_count. It must no longer be in use. */
+void free_event_count(struct event_count *count)
+{
+	if (count == NULL)
+		return;
+
+	uds_destroy_semaphore(&count->semaphore);
+	UDS_FREE(count);
+}
+
+/*
+ * Prepare to wait for the event count to change by capturing a token of its current state. The
+ * caller MUST eventually either call event_count_wait() or event_count_cancel() exactly once for
+ * each token obtained.
+ */
+event_token_t event_count_prepare(struct event_count *count)
+{
+	return atomic64_add_return(ONE_WAITER, &count->state);
+}
+
+/*
+ * Cancel a wait token that has been prepared but not waited upon. This must be called after
+ * event_count_prepare() when event_count_wait() is not going to be invoked on the token.
+ */
+void event_count_cancel(struct event_count *count, event_token_t token)
+{
+	/* Decrement the waiter count if the event hasn't been signalled. */
+	if (fast_cancel(count, token))
+		return;
+
+	/*
+	 * A signaller has already transferred (or promised to transfer) our token to the
+	 * semaphore, so we must consume it from the semaphore by waiting.
+	 */
+	event_count_wait(count, token, NULL);
+}
+
+/*
+ * Check if the current event count state corresponds to the provided token, and if it is, wait for
+ * a signal that the state has changed. If a timeout is provided, the wait will terminate after the
+ * timeout has elapsed. Timing out automatically cancels the wait token, so callers must not
+ * attempt to cancel the token in this case. The timeout is measured in nanoseconds. This function
+ * returns true if the state changed, or false if it timed out.
+ */
+bool event_count_wait(struct event_count *count, event_token_t token, const ktime_t *timeout)
+{
+	for (;;) {
+		/* Wait for a signaller to transfer our wait token to the semaphore. */
+		if (!consume_wait_token(count, timeout)) {
+			/*
+			 * The wait timed out, so we must cancel the token instead. Try to
+			 * decrement the waiter count if the event hasn't been signalled.
+			 */
+			if (fast_cancel(count, token))
+				return false;
+			/*
+			 * We timed out, but a signaller came in before we could cancel the wait.
+			 * We have no choice but to wait for the semaphore to be posted. Since the
+			 * signaller has promised to do it, the wait should be short. The timeout
+			 * and the signal happened at about the same time, so either outcome could
+			 * be returned. It's simpler to ignore the timeout.
+			 */
+			timeout = NULL;
+			continue;
+		}
+
+		/* A wait token has now been consumed from the semaphore. */
+
+		/* Stop waiting if the count has changed since the token was acquired. */
+		if (!same_event(token, atomic64_read(&count->state)))
+			return true;
+
+		/*
+		 * We consumed someone else's wait token. Put it back in the semaphore, which will
+		 * wake another waiter, hopefully one who can stop waiting.
+		 */
+		uds_release_semaphore(&count->semaphore);
+
+		/* Attempt to give an earlier waiter a shot at the semaphore. */
+		cond_resched();
+	}
+}
diff --git a/drivers/md/dm-vdo/event-count.h b/drivers/md/dm-vdo/event-count.h
new file mode 100644
index 00000000000..43f7a51a708
--- /dev/null
+++ b/drivers/md/dm-vdo/event-count.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef EVENT_COUNT_H
+#define EVENT_COUNT_H
+
+#include "time-utils.h"
+
+/*
+ * An event count is a lock-free equivalent of a condition variable.
+ *
+ * Using an event count, a lock-free producer/consumer can wait for a state change (adding an item
+ * to an empty queue, for example) without spinning or falling back on the use of mutex-based
+ * locks. Signalling is cheap when there are no waiters (a memory fence), and preparing to wait is
+ * also inexpensive (an atomic add instruction).
+ *
+ * A lock-free producer should call event_count_broadcast() after any mutation to the lock-free
+ * data structure that a consumer might be waiting on. The consumers should poll for work like
+ * this:
+ *
+ *   for (;;) {
+ *       // Fast path--no additional cost to consumer.
+ *       if (lockfree_dequeue(&item))
+ *           return item;
+ *       // Two-step wait: get current token and poll state, either cancelling
+ *       // the wait or waiting for the token to be signalled.
+ *       event_token_t token = event_count_prepare(event_count);
+ *       if (lockfree_dequeue(&item)) {
+ *           event_count_cancel(event_count, token);
+ *           return item;
+ *       }
+ *       event_count_wait(event_count, token, NULL);
+ *       // State has changed, but must check condition again, so loop.
+ *   }
+ *
+ * Once event_count_prepare() is called, the caller should neither sleep nor perform long-running
+ * or blocking actions before passing the token to event_count_cancel() or event_count_wait(). The
+ * implementation is optimized for a short polling window, and will not perform well if there are
+ * outstanding tokens that have been signalled but not waited upon.
+ */
+
+struct event_count;
+
+typedef unsigned int event_token_t;
+
+int __must_check make_event_count(struct event_count **count_ptr);
+
+void free_event_count(struct event_count *count);
+
+void event_count_broadcast(struct event_count *count);
+
+event_token_t __must_check event_count_prepare(struct event_count *count);
+
+void event_count_cancel(struct event_count *count, event_token_t token);
+
+bool event_count_wait(struct event_count *count, event_token_t token, const ktime_t *timeout);
+
+#endif /* EVENT_COUNT_H */
diff --git a/drivers/md/dm-vdo/funnel-queue.c b/drivers/md/dm-vdo/funnel-queue.c
new file mode 100644
index 00000000000..7e36153ec0a
--- /dev/null
+++ b/drivers/md/dm-vdo/funnel-queue.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "funnel-queue.h"
+
+#include "cpu.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+#include "uds.h"
+
+int uds_make_funnel_queue(struct funnel_queue **queue_ptr)
+{
+	int result;
+	struct funnel_queue *queue;
+
+	result = UDS_ALLOCATE(1, struct funnel_queue, "funnel queue", &queue);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	/*
+	 * Initialize the stub entry and put it in the queue, establishing the invariant that
+	 * queue->newest and queue->oldest are never null.
+	 */
+	queue->stub.next = NULL;
+	queue->newest = &queue->stub;
+	queue->oldest = &queue->stub;
+
+	*queue_ptr = queue;
+	return UDS_SUCCESS;
+}
+
+void uds_free_funnel_queue(struct funnel_queue *queue)
+{
+	UDS_FREE(queue);
+}
+
+static struct funnel_queue_entry *get_oldest(struct funnel_queue *queue)
+{
+	/*
+	 * Barrier requirements: We need a read barrier between reading a "next" field pointer
+	 * value and reading anything it points to. There's an accompanying barrier in
+	 * uds_funnel_queue_put() between its caller setting up the entry and making it visible.
+	 */
+	struct funnel_queue_entry *oldest = queue->oldest;
+	struct funnel_queue_entry *next = READ_ONCE(oldest->next);
+
+	if (oldest == &queue->stub) {
+		/*
+		 * When the oldest entry is the stub and it has no successor, the queue is
+		 * logically empty.
+		 */
+		if (next == NULL)
+			return NULL;
+		/*
+		 * The stub entry has a successor, so the stub can be dequeued and ignored without
+		 * breaking the queue invariants.
+		 */
+		oldest = next;
+		queue->oldest = oldest;
+		next = READ_ONCE(oldest->next);
+	}
+
+	/*
+	 * We have a non-stub candidate to dequeue. If it lacks a successor, we'll need to put the
+	 * stub entry back on the queue first.
+	 */
+	if (next == NULL) {
+		struct funnel_queue_entry *newest = READ_ONCE(queue->newest);
+
+		if (oldest != newest)
+			/*
+			 * Another thread has already swung queue->newest atomically, but not yet
+			 * assigned previous->next. The queue is really still empty.
+			 */
+			return NULL;
+
+		/*
+		 * Put the stub entry back on the queue, ensuring a successor will eventually be
+		 * seen.
+		 */
+		uds_funnel_queue_put(queue, &queue->stub);
+
+		/* Check again for a successor. */
+		next = READ_ONCE(oldest->next);
+		if (next == NULL)
+			/*
+			 * We lost a race with a producer who swapped queue->newest before we did,
+			 * but who hasn't yet updated previous->next. Try again later.
+			 */
+			return NULL;
+	}
+
+	return oldest;
+}
+
+/*
+ * Poll a queue, removing the oldest entry if the queue is not empty. This function must only be
+ * called from a single consumer thread.
+ */
+struct funnel_queue_entry *uds_funnel_queue_poll(struct funnel_queue *queue)
+{
+	struct funnel_queue_entry *oldest = get_oldest(queue);
+
+	if (oldest == NULL)
+		return oldest;
+
+	/*
+	 * Dequeue the oldest entry and return it. Only one consumer thread may call this function,
+	 * so no locking, atomic operations, or fences are needed; queue->oldest is owned by the
+	 * consumer and oldest->next is never used by a producer thread after it is swung from NULL
+	 * to non-NULL.
+	 */
+	queue->oldest = READ_ONCE(oldest->next);
+	/*
+	 * Make sure the caller sees the proper stored data for this entry. Since we've already
+	 * fetched the entry pointer we stored in "queue->oldest", this also ensures that on entry
+	 * to the next call we'll properly see the dependent data.
+	 */
+	smp_rmb();
+	/*
+	 * If "oldest" is a very light-weight work item, we'll be looking for the next one very
+	 * soon, so prefetch it now.
+	 */
+	uds_prefetch_address(queue->oldest, true);
+	WRITE_ONCE(oldest->next, NULL);
+	return oldest;
+}
+
+/*
+ * Check whether the funnel queue is empty or not. If the queue is in a transition state with one
+ * or more entries being added such that the list view is incomplete, this function will report the
+ * queue as empty.
+ */
+bool uds_is_funnel_queue_empty(struct funnel_queue *queue)
+{
+	return get_oldest(queue) == NULL;
+}
+
+/*
+ * Check whether the funnel queue is idle or not. If the queue has entries available to be
+ * retrieved, it is not idle. If the queue is in a transition state with one or more entries being
+ * added such that the list view is incomplete, it may not be possible to retrieve an entry with
+ * the uds_funnel_queue_poll() function, but the queue will not be considered idle.
+ */
+bool uds_is_funnel_queue_idle(struct funnel_queue *queue)
+{
+	/*
+	 * Oldest is not the stub, so there's another entry, though if next is NULL we can't
+	 * retrieve it yet.
+	 */
+	if (queue->oldest != &queue->stub)
+		return false;
+
+	/*
+	 * Oldest is the stub, but newest has been updated by _put(); either there's another,
+	 * retrievable entry in the list, or the list is officially empty but in the intermediate
+	 * state of having an entry added.
+	 *
+	 * Whether anything is retrievable depends on whether stub.next has been updated and become
+	 * visible to us, but for idleness we don't care. And due to memory ordering in _put(), the
+	 * update to newest would be visible to us at the same time or sooner.
+	 */
+	if (READ_ONCE(queue->newest) != &queue->stub)
+		return false;
+
+	return true;
+}
diff --git a/drivers/md/dm-vdo/funnel-queue.h b/drivers/md/dm-vdo/funnel-queue.h
new file mode 100644
index 00000000000..332acc579b6
--- /dev/null
+++ b/drivers/md/dm-vdo/funnel-queue.h
@@ -0,0 +1,110 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_FUNNEL_QUEUE_H
+#define UDS_FUNNEL_QUEUE_H
+
+#include <linux/atomic.h>
+#include <linux/cache.h>
+
+/*
+ * A funnel queue is a simple (almost) lock-free queue that accepts entries from multiple threads
+ * (multi-producer) and delivers them to a single thread (single-consumer). "Funnel" is an attempt
+ * to evoke the image of requests from more than one producer being "funneled down" to a single
+ * consumer.
+ *
+ * This is an unsynchronized but thread-safe data structure when used as intended. There is no
+ * mechanism to ensure that only one thread is consuming from the queue. If more than one thread
+ * attempts to consume from the queue, the resulting behavior is undefined. Clients must not
+ * directly access or manipulate the internals of the queue, which are only exposed for the purpose
+ * of allowing the very simple enqueue operation to be inlined.
+ *
+ * The implementation requires that a funnel_queue_entry structure (a link pointer) is embedded in
+ * the queue entries, and pointers to those structures are used exclusively by the queue. No macros
+ * are defined to template the queue, so the offset of the funnel_queue_entry in the records placed
+ * in the queue must all be the same so the client can derive their structure pointer from the
+ * entry pointer returned by uds_funnel_queue_poll().
+ *
+ * Callers are wholly responsible for allocating and freeing the entries. Entries may be freed as
+ * soon as they are returned since this queue is not susceptible to the "ABA problem" present in
+ * many lock-free data structures. The queue is dynamically allocated to ensure cache-line
+ * alignment, but no other dynamic allocation is used.
+ *
+ * The algorithm is not actually 100% lock-free. There is a single point in uds_funnel_queue_put()
+ * at which a preempted producer will prevent the consumers from seeing items added to the queue by
+ * later producers, and only if the queue is short enough or the consumer fast enough for it to
+ * reach what was the end of the queue at the time of the preemption.
+ *
+ * The consumer function, uds_funnel_queue_poll(), will return NULL when the queue is empty. To
+ * wait for data to consume, spin (if safe) or combine the queue with a struct event_count to
+ * signal the presence of new entries.
+ */
+
+/* This queue link structure must be embedded in client entries. */
+struct funnel_queue_entry {
+	/* The next (newer) entry in the queue. */
+	struct funnel_queue_entry *next;
+};
+
+/*
+ * The dynamically allocated queue structure, which is allocated on a cache line boundary so the
+ * producer and consumer fields in the structure will land on separate cache lines. This should be
+ * consider opaque but it is exposed here so uds_funnel_queue_put() can be inlined.
+ */
+struct __aligned(L1_CACHE_BYTES) funnel_queue {
+	/*
+	 * The producers' end of the queue, an atomically exchanged pointer that will never be
+	 * NULL.
+	 */
+	struct funnel_queue_entry *newest;
+
+	/* The consumer's end of the queue, which is owned by the consumer and never NULL. */
+	struct funnel_queue_entry *oldest __aligned(L1_CACHE_BYTES);
+
+	/* A dummy entry used to provide the non-NULL invariants above. */
+	struct funnel_queue_entry stub;
+};
+
+int __must_check uds_make_funnel_queue(struct funnel_queue **queue_ptr);
+
+void uds_free_funnel_queue(struct funnel_queue *queue);
+
+/*
+ * Put an entry on the end of the queue.
+ *
+ * The entry pointer must be to the struct funnel_queue_entry embedded in the caller's data
+ * structure. The caller must be able to derive the address of the start of their data structure
+ * from the pointer that passed in here, so every entry in the queue must have the struct
+ * funnel_queue_entry at the same offset within the client's structure.
+ */
+static inline void
+uds_funnel_queue_put(struct funnel_queue *queue, struct funnel_queue_entry *entry)
+{
+	struct funnel_queue_entry *previous;
+
+	/*
+	 * Barrier requirements: All stores relating to the entry ("next" pointer, containing data
+	 * structure fields) must happen before the previous->next store making it visible to the
+	 * consumer. Also, the entry's "next" field initialization to NULL must happen before any
+	 * other producer threads can see the entry (the xchg) and try to update the "next" field.
+	 *
+	 * xchg implements a full barrier.
+	 */
+	WRITE_ONCE(entry->next, NULL);
+	previous = xchg(&queue->newest, entry);
+	/*
+	 * Preemptions between these two statements hide the rest of the queue from the consumer,
+	 * preventing consumption until the following assignment runs.
+	 */
+	WRITE_ONCE(previous->next, entry);
+}
+
+struct funnel_queue_entry *__must_check uds_funnel_queue_poll(struct funnel_queue *queue);
+
+bool __must_check uds_is_funnel_queue_empty(struct funnel_queue *queue);
+
+bool __must_check uds_is_funnel_queue_idle(struct funnel_queue *queue);
+
+#endif /* UDS_FUNNEL_QUEUE_H */
diff --git a/drivers/md/dm-vdo/geometry.c b/drivers/md/dm-vdo/geometry.c
new file mode 100644
index 00000000000..a625f69e63b
--- /dev/null
+++ b/drivers/md/dm-vdo/geometry.c
@@ -0,0 +1,205 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "geometry.h"
+
+#include <linux/compiler.h>
+#include <linux/log2.h>
+
+#include "delta-index.h"
+#include "errors.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+#include "uds.h"
+
+/*
+ * An index volume is divided into a fixed number of fixed-size chapters, each consisting of a
+ * fixed number of fixed-size pages. The volume layout is defined by two constants and four
+ * parameters. The constants are that index records are 32 bytes long (16-byte block name plus
+ * 16-byte metadata) and that open chapter index hash slots are one byte long. The four parameters
+ * are the number of bytes in a page, the number of record pages in a chapter, the number of
+ * chapters in a volume, and the number of chapters that are sparse. From these parameters, we can
+ * derive the rest of the layout and other index properties.
+ *
+ * The index volume is sized by its maximum memory footprint. For a dense index, the persistent
+ * storage is about 10 times the size of the memory footprint. For a sparse index, the persistent
+ * storage is about 100 times the size of the memory footprint.
+ *
+ * For a small index with a memory footprint less than 1GB, there are three possible memory
+ * configurations: 0.25GB, 0.5GB and 0.75GB. The default geometry for each is 1024 index records
+ * per 32 KB page, 1024 chapters per volume, and either 64, 128, or 192 record pages per chapter
+ * (resulting in 6, 13, or 20 index pages per chapter) depending on the memory configuration. For
+ * the VDO default of a 0.25 GB index, this yields a deduplication window of 256 GB using about 2.5
+ * GB for the persistent storage and 256 MB of RAM.
+ *
+ * For a larger index with a memory footprint that is a multiple of 1 GB, the geometry is 1024
+ * index records per 32 KB page, 256 record pages per chapter, 26 index pages per chapter, and 1024
+ * chapters for every GB of memory footprint. For a 1 GB volume, this yields a deduplication window
+ * of 1 TB using about 9GB of persistent storage and 1 GB of RAM.
+ *
+ * The above numbers hold for volumes which have no sparse chapters. A sparse volume has 10 times
+ * as many chapters as the corresponding non-sparse volume, which provides 10 times the
+ * deduplication window while using 10 times as much persistent storage as the equivalent
+ * non-sparse volume with the same memory footprint.
+ *
+ * If the volume has been converted from a non-lvm format to an lvm volume, the number of chapters
+ * per volume will have been reduced by one by eliminating physical chapter 0, and the virtual
+ * chapter that formerly mapped to physical chapter 0 may be remapped to another physical chapter.
+ * This remapping is expressed by storing which virtual chapter was remapped, and which physical
+ * chapter it was moved to.
+ */
+
+int uds_make_geometry(size_t bytes_per_page,
+		      u32 record_pages_per_chapter,
+		      u32 chapters_per_volume,
+		      u32 sparse_chapters_per_volume,
+		      u64 remapped_virtual,
+		      u64 remapped_physical,
+		      struct geometry **geometry_ptr)
+{
+	int result;
+	struct geometry *geometry;
+
+	result = UDS_ALLOCATE(1, struct geometry, "geometry", &geometry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	geometry->bytes_per_page = bytes_per_page;
+	geometry->record_pages_per_chapter = record_pages_per_chapter;
+	geometry->chapters_per_volume = chapters_per_volume;
+	geometry->sparse_chapters_per_volume = sparse_chapters_per_volume;
+	geometry->dense_chapters_per_volume = chapters_per_volume - sparse_chapters_per_volume;
+	geometry->remapped_virtual = remapped_virtual;
+	geometry->remapped_physical = remapped_physical;
+
+	geometry->records_per_page = bytes_per_page / BYTES_PER_RECORD;
+	geometry->records_per_chapter = geometry->records_per_page * record_pages_per_chapter;
+	geometry->records_per_volume = (u64) geometry->records_per_chapter * chapters_per_volume;
+
+	geometry->chapter_mean_delta = 1 << DEFAULT_CHAPTER_MEAN_DELTA_BITS;
+	geometry->chapter_payload_bits = bits_per(record_pages_per_chapter - 1);
+	/*
+	 * We want 1 delta list for every 64 records in the chapter.
+	 * The "| 077" ensures that the chapter_delta_list_bits computation
+	 * does not underflow.
+	 */
+	geometry->chapter_delta_list_bits =
+		bits_per((geometry->records_per_chapter - 1) | 077) - 6;
+	geometry->delta_lists_per_chapter = 1 << geometry->chapter_delta_list_bits;
+	/* We need enough address bits to achieve the desired mean delta. */
+	geometry->chapter_address_bits =
+		(DEFAULT_CHAPTER_MEAN_DELTA_BITS -
+		 geometry->chapter_delta_list_bits +
+		 bits_per(geometry->records_per_chapter - 1));
+	geometry->index_pages_per_chapter =
+		uds_get_delta_index_page_count(geometry->records_per_chapter,
+					       geometry->delta_lists_per_chapter,
+					       geometry->chapter_mean_delta,
+					       geometry->chapter_payload_bits,
+					       bytes_per_page);
+
+	geometry->pages_per_chapter = geometry->index_pages_per_chapter + record_pages_per_chapter;
+	geometry->pages_per_volume = geometry->pages_per_chapter * chapters_per_volume;
+	geometry->bytes_per_volume =
+		bytes_per_page * (geometry->pages_per_volume + HEADER_PAGES_PER_VOLUME);
+
+	*geometry_ptr = geometry;
+	return UDS_SUCCESS;
+}
+
+int uds_copy_geometry(struct geometry *source, struct geometry **geometry_ptr)
+{
+	return uds_make_geometry(source->bytes_per_page,
+				 source->record_pages_per_chapter,
+				 source->chapters_per_volume,
+				 source->sparse_chapters_per_volume,
+				 source->remapped_virtual,
+				 source->remapped_physical,
+				 geometry_ptr);
+}
+
+void uds_free_geometry(struct geometry *geometry)
+{
+	UDS_FREE(geometry);
+}
+
+u32 __must_check uds_map_to_physical_chapter(const struct geometry *geometry, u64 virtual_chapter)
+{
+	u64 delta;
+
+	if (!uds_is_reduced_geometry(geometry))
+		return virtual_chapter % geometry->chapters_per_volume;
+
+	if (likely(virtual_chapter > geometry->remapped_virtual)) {
+		delta = virtual_chapter - geometry->remapped_virtual;
+		if (likely(delta > geometry->remapped_physical))
+			return delta % geometry->chapters_per_volume;
+		else
+			return delta - 1;
+	}
+
+	if (virtual_chapter == geometry->remapped_virtual)
+		return geometry->remapped_physical;
+
+	delta = geometry->remapped_virtual - virtual_chapter;
+	if (delta < geometry->chapters_per_volume)
+		return geometry->chapters_per_volume - delta;
+
+	/* This chapter is so old the answer doesn't matter. */
+	return 0;
+}
+
+/* Check whether any sparse chapters are in use. */
+bool uds_has_sparse_chapters(const struct geometry *geometry,
+			     u64 oldest_virtual_chapter,
+			     u64 newest_virtual_chapter)
+{
+	return uds_is_sparse_geometry(geometry) &&
+	       ((newest_virtual_chapter - oldest_virtual_chapter + 1) >
+		geometry->dense_chapters_per_volume);
+}
+
+bool uds_is_chapter_sparse(const struct geometry *geometry,
+			   u64 oldest_virtual_chapter,
+			   u64 newest_virtual_chapter,
+			   u64 virtual_chapter_number)
+{
+	return uds_has_sparse_chapters(geometry,
+				       oldest_virtual_chapter,
+				       newest_virtual_chapter) &&
+	       ((virtual_chapter_number + geometry->dense_chapters_per_volume) <=
+		newest_virtual_chapter);
+}
+
+/* Calculate how many chapters to expire after opening the newest chapter. */
+u32 uds_chapters_to_expire(const struct geometry *geometry, u64 newest_chapter)
+{
+	/* If the index isn't full yet, don't expire anything. */
+	if (newest_chapter < geometry->chapters_per_volume)
+		return 0;
+
+	/* If a chapter is out of order... */
+	if (geometry->remapped_physical > 0) {
+		u64 oldest_chapter = newest_chapter - geometry->chapters_per_volume;
+
+		/*
+		 * ... expire an extra chapter when expiring the moved chapter to free physical
+		 * space for the new chapter ...
+		 */
+		if (oldest_chapter == geometry->remapped_virtual)
+			return 2;
+
+		/*
+		 * ... but don't expire anything when the new chapter will use the physical chapter
+		 * freed by expiring the moved chapter.
+		 */
+		if (oldest_chapter == (geometry->remapped_virtual + geometry->remapped_physical))
+			return 0;
+	}
+
+	/* Normally, just expire one. */
+	return 1;
+}
diff --git a/drivers/md/dm-vdo/geometry.h b/drivers/md/dm-vdo/geometry.h
new file mode 100644
index 00000000000..4065e4c63d6
--- /dev/null
+++ b/drivers/md/dm-vdo/geometry.h
@@ -0,0 +1,137 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_GEOMETRY_H
+#define UDS_GEOMETRY_H
+
+#include "uds.h"
+
+/*
+ * The geometry records parameters that define the layout of a UDS index volume, and the size and
+ * shape of various index structures. It is created when the index is created, and is referenced by
+ * many index sub-components.
+ */
+
+struct geometry {
+	/* Size of a chapter page, in bytes */
+	size_t bytes_per_page;
+	/* Number of record pages in a chapter */
+	u32 record_pages_per_chapter;
+	/* Total number of chapters in a volume */
+	u32 chapters_per_volume;
+	/* Number of sparsely-indexed chapters in a volume */
+	u32 sparse_chapters_per_volume;
+	/* Number of bits used to determine delta list numbers */
+	u8 chapter_delta_list_bits;
+	/* Virtual chapter remapped from physical chapter 0 */
+	u64 remapped_virtual;
+	/* New physical chapter where the remapped chapter can be found */
+	u64 remapped_physical;
+
+	/*
+	 * The following properties are derived from the ones above, but they are computed and
+	 * recorded as fields for convenience.
+	 */
+	/* Total number of pages in a volume, excluding the header */
+	u32 pages_per_volume;
+	/* Total number of bytes in a volume, including the header */
+	size_t bytes_per_volume;
+	/* Number of pages in a chapter */
+	u32 pages_per_chapter;
+	/* Number of index pages in a chapter index */
+	u32 index_pages_per_chapter;
+	/* Number of records that fit on a page */
+	u32 records_per_page;
+	/* Number of records that fit in a chapter */
+	u32 records_per_chapter;
+	/* Number of records that fit in a volume */
+	u64 records_per_volume;
+	/* Number of delta lists per chapter index */
+	u32 delta_lists_per_chapter;
+	/* Mean delta for chapter indexes */
+	u32 chapter_mean_delta;
+	/* Number of bits needed for record page numbers */
+	u8 chapter_payload_bits;
+	/* Number of bits used to compute addresses for chapter delta lists */
+	u8 chapter_address_bits;
+	/* Number of densely-indexed chapters in a volume */
+	u32 dense_chapters_per_volume;
+};
+
+enum {
+	/* The number of bytes in a record (name + metadata) */
+	BYTES_PER_RECORD = (UDS_RECORD_NAME_SIZE + UDS_RECORD_DATA_SIZE),
+
+	/* The default length of a page in a chapter, in bytes */
+	DEFAULT_BYTES_PER_PAGE = 1024 * BYTES_PER_RECORD,
+
+	/* The default maximum number of records per page */
+	DEFAULT_RECORDS_PER_PAGE = DEFAULT_BYTES_PER_PAGE / BYTES_PER_RECORD,
+
+	/* The default number of record pages in a chapter */
+	DEFAULT_RECORD_PAGES_PER_CHAPTER = 256,
+
+	/* The default number of record pages in a chapter for a small index */
+	SMALL_RECORD_PAGES_PER_CHAPTER = 64,
+
+	/* The default number of chapters in a volume */
+	DEFAULT_CHAPTERS_PER_VOLUME = 1024,
+
+	/* The default number of sparsely-indexed chapters in a volume */
+	DEFAULT_SPARSE_CHAPTERS_PER_VOLUME = 0,
+
+	/* The log2 of the default mean delta */
+	DEFAULT_CHAPTER_MEAN_DELTA_BITS = 16,
+
+	/* The log2 of the number of delta lists in a large chapter */
+	DEFAULT_CHAPTER_DELTA_LIST_BITS = 12,
+
+	/* The log2 of the number of delta lists in a small chapter */
+	SMALL_CHAPTER_DELTA_LIST_BITS = 10,
+
+	/* The number of header pages per volume */
+	HEADER_PAGES_PER_VOLUME = 1,
+};
+
+int __must_check uds_make_geometry(size_t bytes_per_page,
+				   u32 record_pages_per_chapter,
+				   u32 chapters_per_volume,
+				   u32 sparse_chapters_per_volume,
+				   u64 remapped_virtual,
+				   u64 remapped_physical,
+				   struct geometry **geometry_ptr);
+
+int __must_check uds_copy_geometry(struct geometry *source, struct geometry **geometry_ptr);
+
+void uds_free_geometry(struct geometry *geometry);
+
+u32 __must_check uds_map_to_physical_chapter(const struct geometry *geometry, u64 virtual_chapter);
+
+/*
+ * Check whether this geometry is reduced by a chapter. This will only be true if the volume was
+ * converted from a non-lvm volume to an lvm volume.
+ */
+static inline bool __must_check uds_is_reduced_geometry(const struct geometry *geometry)
+{
+	return !!(geometry->chapters_per_volume & 1);
+}
+
+static inline bool __must_check uds_is_sparse_geometry(const struct geometry *geometry)
+{
+	return geometry->sparse_chapters_per_volume > 0;
+}
+
+bool __must_check uds_has_sparse_chapters(const struct geometry *geometry,
+					  u64 oldest_virtual_chapter,
+					  u64 newest_virtual_chapter);
+
+bool __must_check uds_is_chapter_sparse(const struct geometry *geometry,
+					u64 oldest_virtual_chapter,
+					u64 newest_virtual_chapter,
+					u64 virtual_chapter_number);
+
+u32 __must_check uds_chapters_to_expire(const struct geometry *geometry, u64 newest_chapter);
+
+#endif /* UDS_GEOMETRY_H */
diff --git a/drivers/md/dm-vdo/hash-utils.h b/drivers/md/dm-vdo/hash-utils.h
new file mode 100644
index 00000000000..d67f418aded
--- /dev/null
+++ b/drivers/md/dm-vdo/hash-utils.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_HASH_UTILS_H
+#define UDS_HASH_UTILS_H
+
+#include "geometry.h"
+#include "numeric.h"
+#include "uds.h"
+
+/* Utilities for extracting portions of a request name for various uses. */
+
+/* How various portions of a record name are apportioned. */
+enum {
+	VOLUME_INDEX_BYTES_OFFSET = 0,
+	VOLUME_INDEX_BYTES_COUNT = 8,
+	CHAPTER_INDEX_BYTES_OFFSET = 8,
+	CHAPTER_INDEX_BYTES_COUNT = 6,
+	SAMPLE_BYTES_OFFSET = 14,
+	SAMPLE_BYTES_COUNT = 2,
+};
+
+static inline u64 uds_extract_chapter_index_bytes(const struct  uds_record_name *name)
+{
+	const u8 *chapter_bits = &name->name[CHAPTER_INDEX_BYTES_OFFSET];
+	u64 bytes = (u64) get_unaligned_be16(chapter_bits) << 32;
+
+	bytes |= get_unaligned_be32(chapter_bits + 2);
+	return bytes;
+}
+
+static inline u64 uds_extract_volume_index_bytes(const struct uds_record_name *name)
+{
+	return get_unaligned_be64(&name->name[VOLUME_INDEX_BYTES_OFFSET]);
+}
+
+static inline u32 uds_extract_sampling_bytes(const struct uds_record_name *name)
+{
+	return get_unaligned_be16(&name->name[SAMPLE_BYTES_OFFSET]);
+}
+
+/* Compute the chapter delta list for a given name. */
+static inline u32
+uds_hash_to_chapter_delta_list(const struct uds_record_name *name, const struct geometry *geometry)
+{
+	return ((uds_extract_chapter_index_bytes(name) >> geometry->chapter_address_bits) &
+		((1 << geometry->chapter_delta_list_bits) - 1));
+}
+
+/* Compute the chapter delta address for a given name. */
+static inline u32
+uds_hash_to_chapter_delta_address(const struct uds_record_name *name,
+				  const struct geometry *geometry)
+{
+	return uds_extract_chapter_index_bytes(name) & ((1 << geometry->chapter_address_bits) - 1);
+}
+
+static inline unsigned int
+uds_name_to_hash_slot(const struct uds_record_name *name, unsigned int slot_count)
+{
+	return (unsigned int) (uds_extract_chapter_index_bytes(name) % slot_count);
+}
+
+#endif /* UDS_HASH_UTILS_H */
diff --git a/drivers/md/dm-vdo/index-layout.c b/drivers/md/dm-vdo/index-layout.c
new file mode 100644
index 00000000000..df231c037ed
--- /dev/null
+++ b/drivers/md/dm-vdo/index-layout.c
@@ -0,0 +1,1775 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "index-layout.h"
+
+#include <linux/random.h>
+
+#include "config.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "murmurhash3.h"
+#include "numeric.h"
+#include "open-chapter.h"
+#include "time-utils.h"
+#include "volume-index.h"
+
+/*
+ * The UDS layout on storage media is divided into a number of fixed-size regions, the sizes of
+ * which are computed when the index is created. Every header and region begins on 4K block
+ * boundary. Save regions are further sub-divided into regions of their own.
+ *
+ * Each region has a kind and an instance number. Some kinds only have one instance and therefore
+ * use RL_SOLE_INSTANCE (-1) as the instance number. The RL_KIND_INDEX used to use instances to
+ * represent sub-indices; now, however there is only ever one sub-index and therefore one instance.
+ * The RL_KIND_VOLUME_INDEX uses instances to record which zone is being saved.
+ *
+ * Every region header has a type and version.
+ *
+ *     +-+-+---------+--------+--------+-+
+ *     | | |   I N D E X  0   101, 0   | |
+ *     |H|C+---------+--------+--------+S|
+ *     |D|f| Volume  | Save   | Save   |e|
+ *     |R|g| Region  | Region | Region |a|
+ *     | | | 201, -1 | 202, 0 | 202, 1 |l|
+ *     +-+-+--------+---------+--------+-+
+ *
+ * The header contains the encoded region layout table as well as some index configuration data.
+ * The sub-index region and its subdivisions are maintained in the same table.
+ *
+ * There are two save regions to preserve the old state in case saving the new state is incomplete.
+ * They are used in alternation. Each save region is further divided into sub-regions.
+ *
+ *     +-+-----+------+------+-----+-----+
+ *     |H| IPM | MI   | MI   |     | OC  |
+ *     |D|     | zone | zone | ... |     |
+ *     |R| 301 | 302  | 302  |     | 303 |
+ *     | | -1  |  0   |  1   |     | -1  |
+ *     +-+-----+------+------+-----+-----+
+ *
+ * The header contains the encoded region layout table as well as index state data for that save.
+ * Each save also has a unique nonce.
+ */
+
+enum {
+	MAGIC_SIZE = 32,
+	NONCE_INFO_SIZE = 32,
+	MAX_SAVES = 2,
+};
+
+enum region_kind {
+	RL_KIND_EMPTY = 0,
+	RL_KIND_HEADER = 1,
+	RL_KIND_CONFIG = 100,
+	RL_KIND_INDEX = 101,
+	RL_KIND_SEAL = 102,
+	RL_KIND_VOLUME = 201,
+	RL_KIND_SAVE = 202,
+	RL_KIND_INDEX_PAGE_MAP = 301,
+	RL_KIND_VOLUME_INDEX = 302,
+	RL_KIND_OPEN_CHAPTER = 303,
+};
+
+/* Some region types are historical and are no longer used. */
+enum region_type {
+	RH_TYPE_FREE = 0, /* unused */
+	RH_TYPE_SUPER = 1,
+	RH_TYPE_SAVE = 2,
+	RH_TYPE_CHECKPOINT = 3, /* unused */
+	RH_TYPE_UNSAVED = 4,
+};
+
+enum {
+	RL_SOLE_INSTANCE = 65535,
+};
+
+/*
+ * Super block version 2 is the first released version.
+ *
+ * Super block version 3 is the normal version used from RHEL 8.2 onwards.
+ *
+ * Super block versions 4 through 6 were incremental development versions and
+ * are not supported.
+ *
+ * Super block version 7 is used for volumes which have been reduced in size by one chapter in
+ * order to make room to prepend LVM metadata to a volume originally created without lvm. This
+ * allows the index to retain most its deduplication records.
+ */
+enum {
+	SUPER_VERSION_MINIMUM = 3,
+	SUPER_VERSION_CURRENT = 3,
+	SUPER_VERSION_MAXIMUM = 7,
+};
+
+static const u8 LAYOUT_MAGIC[MAGIC_SIZE] = "*ALBIREO*SINGLE*FILE*LAYOUT*001*";
+static const u64 REGION_MAGIC = 0x416c6252676e3031; /* 'AlbRgn01' */
+
+struct region_header {
+	u64 magic;
+	u64 region_blocks;
+	u16 type;
+	/* Currently always version 1 */
+	u16 version;
+	u16 region_count;
+	u16 payload;
+};
+
+struct layout_region {
+	u64 start_block;
+	u64 block_count;
+	u32 __unused;
+	u16 kind;
+	u16 instance;
+};
+
+struct region_table {
+	size_t encoded_size;
+	struct region_header header;
+	struct layout_region regions[];
+};
+
+struct index_save_data {
+	u64 timestamp;
+	u64 nonce;
+	/* Currently always version 1 */
+	u32 version;
+	u32 unused__;
+};
+
+struct index_state_version {
+	s32 signature;
+	s32 version_id;
+};
+
+static const struct index_state_version INDEX_STATE_VERSION_301 = {
+	.signature  = -1,
+	.version_id = 301,
+};
+
+struct index_state_data301 {
+	struct index_state_version version;
+	u64 newest_chapter;
+	u64 oldest_chapter;
+	u64 last_save;
+	u32 unused;
+	u32 padding;
+};
+
+struct index_save_layout {
+	unsigned int zone_count;
+	struct layout_region index_save;
+	struct layout_region header;
+	struct layout_region index_page_map;
+	struct layout_region free_space;
+	struct layout_region volume_index_zones[MAX_ZONES];
+	struct layout_region open_chapter;
+	struct index_save_data save_data;
+	struct index_state_data301 state_data;
+};
+
+struct sub_index_layout {
+	u64 nonce;
+	struct layout_region sub_index;
+	struct layout_region volume;
+	struct index_save_layout *saves;
+};
+
+struct super_block_data {
+	u8 magic_label[MAGIC_SIZE];
+	u8 nonce_info[NONCE_INFO_SIZE];
+	u64 nonce;
+	u32 version;
+	u32 block_size;
+	u16 index_count;
+	u16 max_saves;
+	/* Padding reflects a blank field on permanent storage */
+	u8 padding[4];
+	u64 open_chapter_blocks;
+	u64 page_map_blocks;
+	u64 volume_offset;
+	u64 start_offset;
+};
+
+struct index_layout {
+	struct io_factory *factory;
+	size_t factory_size;
+	off_t offset;
+	struct super_block_data super;
+	struct layout_region header;
+	struct layout_region config;
+	struct sub_index_layout index;
+	struct layout_region seal;
+	u64 total_blocks;
+};
+
+struct save_layout_sizes {
+	unsigned int save_count;
+	size_t block_size;
+	u64 volume_blocks;
+	u64 volume_index_blocks;
+	u64 page_map_blocks;
+	u64 open_chapter_blocks;
+	u64 save_blocks;
+	u64 sub_index_blocks;
+	u64 total_blocks;
+	size_t total_size;
+};
+
+static inline bool is_converted_super_block(struct super_block_data *super)
+{
+	return super->version == 7;
+}
+
+static int __must_check compute_sizes(const struct configuration *config,
+				      struct save_layout_sizes *sls)
+{
+	int result;
+	struct geometry *geometry = config->geometry;
+
+	memset(sls, 0, sizeof(*sls));
+	sls->save_count = MAX_SAVES;
+	sls->block_size = UDS_BLOCK_SIZE;
+	sls->volume_blocks = geometry->bytes_per_volume / sls->block_size;
+
+	result = uds_compute_volume_index_save_blocks(config,
+						      sls->block_size,
+						      &sls->volume_index_blocks);
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result, "cannot compute index save size");
+
+	sls->page_map_blocks =
+		DIV_ROUND_UP(uds_compute_index_page_map_save_size(geometry), sls->block_size);
+	sls->open_chapter_blocks =
+		DIV_ROUND_UP(uds_compute_saved_open_chapter_size(geometry), sls->block_size);
+	sls->save_blocks =
+		1 + (sls->volume_index_blocks + sls->page_map_blocks + sls->open_chapter_blocks);
+	sls->sub_index_blocks = sls->volume_blocks + (sls->save_count * sls->save_blocks);
+	sls->total_blocks = 3 + sls->sub_index_blocks;
+	sls->total_size = sls->total_blocks * sls->block_size;
+
+	return UDS_SUCCESS;
+}
+
+int uds_compute_index_size(const struct uds_parameters *parameters, u64 *index_size)
+{
+	int result;
+	struct configuration *index_config;
+	struct save_layout_sizes sizes;
+
+	if (index_size == NULL) {
+		uds_log_error("Missing output size pointer");
+		return -EINVAL;
+	}
+
+	result = uds_make_configuration(parameters, &index_config);
+	if (result != UDS_SUCCESS) {
+		uds_log_error_strerror(result, "cannot compute index size");
+		return uds_map_to_system_error(result);
+	}
+
+	result = compute_sizes(index_config, &sizes);
+	uds_free_configuration(index_config);
+	if (result != UDS_SUCCESS)
+		return uds_map_to_system_error(result);
+
+	*index_size = sizes.total_size;
+	return UDS_SUCCESS;
+}
+
+/* Create unique data using the current time and a pseudorandom number. */
+static void create_unique_nonce_data(u8 *buffer)
+{
+	ktime_t now = current_time_ns(CLOCK_REALTIME);
+	u32 rand;
+	size_t offset = 0;
+
+	get_random_bytes(&rand, sizeof(u32));
+	memcpy(buffer + offset, &now, sizeof(now));
+	offset += sizeof(now);
+	memcpy(buffer + offset, &rand, sizeof(rand));
+	offset += sizeof(rand);
+	while (offset < NONCE_INFO_SIZE) {
+		size_t len = min(NONCE_INFO_SIZE - offset, offset);
+
+		memcpy(buffer + offset, buffer, len);
+		offset += len;
+	}
+}
+
+static u64 hash_stuff(u64 start, const void *data, size_t len)
+{
+	u32 seed = start ^ (start >> 27);
+	u8 hash_buffer[16];
+
+	murmurhash3_128(data, len, seed, hash_buffer);
+	return get_unaligned_le64(hash_buffer + 4);
+}
+
+/* Generate a primary nonce from the provided data. */
+static u64 generate_primary_nonce(const void *data, size_t len)
+{
+	return hash_stuff(0xa1b1e0fc, data, len);
+}
+
+/*
+ * Deterministically generate a secondary nonce from an existing nonce and some arbitrary data by
+ * hashing the original nonce and the data to produce a new nonce.
+ */
+static u64 generate_secondary_nonce(u64 nonce, const void *data, size_t len)
+{
+	return hash_stuff(nonce + 1, data, len);
+}
+
+static int __must_check open_layout_reader(struct index_layout *layout,
+					   struct layout_region *lr,
+					   off_t offset,
+					   struct buffered_reader **reader_ptr)
+{
+	return uds_make_buffered_reader(layout->factory,
+					lr->start_block + offset,
+					lr->block_count,
+					reader_ptr);
+}
+
+static int open_region_reader(struct index_layout *layout,
+			      struct layout_region *region,
+			      struct buffered_reader **reader_ptr)
+{
+	return open_layout_reader(layout, region, -layout->super.start_offset, reader_ptr);
+}
+
+static int __must_check open_layout_writer(struct index_layout *layout,
+					   struct layout_region *lr,
+					   off_t offset,
+					   struct buffered_writer **writer_ptr)
+{
+	return uds_make_buffered_writer(layout->factory,
+					lr->start_block + offset,
+					lr->block_count,
+					writer_ptr);
+}
+
+static int open_region_writer(struct index_layout *layout,
+			      struct layout_region *region,
+			      struct buffered_writer **writer_ptr)
+{
+	return open_layout_writer(layout, region, -layout->super.start_offset, writer_ptr);
+}
+
+static void
+generate_super_block_data(struct save_layout_sizes *sls, struct super_block_data *super)
+{
+	memset(super, 0, sizeof(*super));
+	memcpy(super->magic_label, LAYOUT_MAGIC, MAGIC_SIZE);
+	create_unique_nonce_data(super->nonce_info);
+
+	super->nonce = generate_primary_nonce(super->nonce_info, sizeof(super->nonce_info));
+	super->version = SUPER_VERSION_CURRENT;
+	super->block_size = sls->block_size;
+	super->index_count = 1;
+	super->max_saves = sls->save_count;
+	super->open_chapter_blocks = sls->open_chapter_blocks;
+	super->page_map_blocks = sls->page_map_blocks;
+	super->volume_offset = 0;
+	super->start_offset = 0;
+}
+
+static void define_sub_index_nonce(struct index_layout *layout)
+{
+	struct sub_index_nonce_data {
+		u64 offset;
+		u16 index_id;
+	};
+	struct sub_index_layout *sil = &layout->index;
+	u64 primary_nonce = layout->super.nonce;
+	u8 buffer[sizeof(struct sub_index_nonce_data)] = { 0 };
+	size_t offset = 0;
+
+	encode_u64_le(buffer, &offset, sil->sub_index.start_block);
+	encode_u16_le(buffer, &offset, 0);
+	sil->nonce = generate_secondary_nonce(primary_nonce, buffer, sizeof(buffer));
+	if (sil->nonce == 0)
+		sil->nonce = generate_secondary_nonce(~primary_nonce + 1, buffer, sizeof(buffer));
+}
+
+static void
+setup_sub_index(struct index_layout *layout, u64 start_block, struct save_layout_sizes *sls)
+{
+	struct sub_index_layout *sil = &layout->index;
+	u64 next_block = start_block;
+	unsigned int i;
+
+	sil->sub_index = (struct layout_region) {
+		.start_block = start_block,
+		.block_count = sls->sub_index_blocks,
+		.kind = RL_KIND_INDEX,
+		.instance = 0,
+	};
+
+	sil->volume = (struct layout_region) {
+		.start_block = next_block,
+		.block_count = sls->volume_blocks,
+		.kind = RL_KIND_VOLUME,
+		.instance = RL_SOLE_INSTANCE,
+	};
+
+	next_block += sls->volume_blocks;
+
+	for (i = 0; i < sls->save_count; i++) {
+		sil->saves[i].index_save = (struct layout_region) {
+			.start_block = next_block,
+			.block_count = sls->save_blocks,
+			.kind = RL_KIND_SAVE,
+			.instance = i,
+		};
+
+		next_block += sls->save_blocks;
+	}
+
+	define_sub_index_nonce(layout);
+}
+
+static void initialize_layout(struct index_layout *layout, struct save_layout_sizes *sls)
+{
+	u64 next_block = layout->offset / sls->block_size;
+
+	layout->total_blocks = sls->total_blocks;
+	generate_super_block_data(sls, &layout->super);
+	layout->header = (struct layout_region) {
+		.start_block = next_block++,
+		.block_count = 1,
+		.kind = RL_KIND_HEADER,
+		.instance = RL_SOLE_INSTANCE,
+	};
+
+	layout->config = (struct layout_region) {
+		.start_block = next_block++,
+		.block_count = 1,
+		.kind = RL_KIND_CONFIG,
+		.instance = RL_SOLE_INSTANCE,
+	};
+
+	setup_sub_index(layout, next_block, sls);
+	next_block += sls->sub_index_blocks;
+
+	layout->seal = (struct layout_region) {
+		.start_block = next_block,
+		.block_count = 1,
+		.kind = RL_KIND_SEAL,
+		.instance = RL_SOLE_INSTANCE,
+	};
+}
+
+static int __must_check
+make_index_save_region_table(struct index_save_layout *isl, struct region_table **table_ptr)
+{
+	int result;
+	unsigned int z;
+	struct region_table *table;
+	struct layout_region *lr;
+	u16 region_count;
+	size_t payload;
+	size_t type;
+
+	if (isl->zone_count > 0) {
+		/*
+		 * Normal save regions: header, page map, volume index zones,
+		 * open chapter, and possibly free space.
+		 */
+		region_count = 3 + isl->zone_count;
+		if (isl->free_space.block_count > 0)
+			region_count++;
+
+		payload = sizeof(isl->save_data) + sizeof(isl->state_data);
+		type = RH_TYPE_SAVE;
+	} else {
+		/* Empty save regions: header, page map, free space. */
+		region_count = 3;
+		payload = sizeof(isl->save_data);
+		type = RH_TYPE_UNSAVED;
+	}
+
+	result = UDS_ALLOCATE_EXTENDED(struct region_table,
+				       region_count,
+				       struct layout_region,
+				       "layout region table for ISL",
+				       &table);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	lr = &table->regions[0];
+	*lr++ = isl->header;
+	*lr++ = isl->index_page_map;
+	for (z = 0; z < isl->zone_count; z++)
+		*lr++ = isl->volume_index_zones[z];
+
+	if (isl->zone_count > 0)
+		*lr++ = isl->open_chapter;
+
+	if (isl->free_space.block_count > 0)
+		*lr++ = isl->free_space;
+
+	table->header = (struct region_header) {
+		.magic = REGION_MAGIC,
+		.region_blocks = isl->index_save.block_count,
+		.type = type,
+		.version = 1,
+		.region_count = region_count,
+		.payload = payload,
+	};
+
+	table->encoded_size = (sizeof(struct region_header) + payload +
+			       region_count * sizeof(struct layout_region));
+	*table_ptr = table;
+	return UDS_SUCCESS;
+}
+
+static void encode_region_table(u8 *buffer, size_t *offset, struct region_table *table)
+{
+	unsigned int i;
+
+	encode_u64_le(buffer, offset, REGION_MAGIC);
+	encode_u64_le(buffer, offset, table->header.region_blocks);
+	encode_u16_le(buffer, offset, table->header.type);
+	encode_u16_le(buffer, offset, table->header.version);
+	encode_u16_le(buffer, offset, table->header.region_count);
+	encode_u16_le(buffer, offset, table->header.payload);
+
+	for (i = 0; i < table->header.region_count; i++) {
+		encode_u64_le(buffer, offset, table->regions[i].start_block);
+		encode_u64_le(buffer, offset, table->regions[i].block_count);
+		encode_u32_le(buffer, offset, 0);
+		encode_u16_le(buffer, offset, table->regions[i].kind);
+		encode_u16_le(buffer, offset, table->regions[i].instance);
+	}
+}
+
+static int __must_check write_index_save_header(struct index_save_layout *isl,
+						struct region_table *table,
+						struct buffered_writer *writer)
+{
+	int result;
+	u8 *buffer;
+	size_t offset = 0;
+
+	result = UDS_ALLOCATE(table->encoded_size, u8, "index save data", &buffer);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	encode_region_table(buffer, &offset, table);
+	encode_u64_le(buffer, &offset, isl->save_data.timestamp);
+	encode_u64_le(buffer, &offset, isl->save_data.nonce);
+	encode_u32_le(buffer, &offset, isl->save_data.version);
+	encode_u32_le(buffer, &offset, 0);
+	if (isl->zone_count > 0) {
+		encode_u32_le(buffer, &offset, INDEX_STATE_VERSION_301.signature);
+		encode_u32_le(buffer, &offset, INDEX_STATE_VERSION_301.version_id);
+		encode_u64_le(buffer, &offset, isl->state_data.newest_chapter);
+		encode_u64_le(buffer, &offset, isl->state_data.oldest_chapter);
+		encode_u64_le(buffer, &offset, isl->state_data.last_save);
+		encode_u64_le(buffer, &offset, 0);
+	}
+
+	result = uds_write_to_buffered_writer(writer, buffer, offset);
+	UDS_FREE(buffer);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	return uds_flush_buffered_writer(writer);
+}
+
+static int write_index_save_layout(struct index_layout *layout, struct index_save_layout *isl)
+{
+	int result;
+	struct region_table *table;
+	struct buffered_writer *writer;
+
+	result = make_index_save_region_table(isl, &table);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = open_region_writer(layout, &isl->header, &writer);
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(table);
+		return result;
+	}
+
+	result = write_index_save_header(isl, table, writer);
+	UDS_FREE(table);
+	uds_free_buffered_writer(writer);
+
+	return result;
+}
+
+static void reset_index_save_layout(struct index_save_layout *isl, u64 page_map_blocks)
+{
+	u64 free_blocks;
+	u64 next_block = isl->index_save.start_block;
+
+	isl->zone_count = 0;
+	memset(&isl->save_data, 0, sizeof(isl->save_data));
+
+	isl->header = (struct layout_region) {
+		.start_block = next_block++,
+		.block_count = 1,
+		.kind = RL_KIND_HEADER,
+		.instance = RL_SOLE_INSTANCE,
+	};
+
+	isl->index_page_map = (struct layout_region) {
+		.start_block = next_block,
+		.block_count = page_map_blocks,
+		.kind = RL_KIND_INDEX_PAGE_MAP,
+		.instance = RL_SOLE_INSTANCE,
+	};
+
+	next_block += page_map_blocks;
+
+	free_blocks = isl->index_save.block_count - page_map_blocks - 1;
+	isl->free_space = (struct layout_region) {
+		.start_block = next_block,
+		.block_count = free_blocks,
+		.kind = RL_KIND_EMPTY,
+		.instance = RL_SOLE_INSTANCE,
+	};
+}
+
+static int __must_check
+invalidate_old_save(struct index_layout *layout, struct index_save_layout *isl)
+{
+	reset_index_save_layout(isl, layout->super.page_map_blocks);
+	return write_index_save_layout(layout, isl);
+}
+
+static int discard_index_state_data(struct index_layout *layout)
+{
+	int result;
+	int saved_result = UDS_SUCCESS;
+	unsigned int i;
+
+	for (i = 0; i < layout->super.max_saves; i++) {
+		result = invalidate_old_save(layout, &layout->index.saves[i]);
+		if (result != UDS_SUCCESS)
+			saved_result = result;
+	}
+
+	if (saved_result != UDS_SUCCESS)
+		return uds_log_error_strerror(result,
+					      "%s: cannot destroy all index saves",
+					      __func__);
+
+	return UDS_SUCCESS;
+}
+
+static int __must_check
+make_layout_region_table(struct index_layout *layout, struct region_table **table_ptr)
+{
+	int result;
+	unsigned int i;
+	/* Regions: header, config, index, volume, saves, seal */
+	u16 region_count = 5 + layout->super.max_saves;
+	u16 payload;
+	struct region_table *table;
+	struct layout_region *lr;
+
+	result = UDS_ALLOCATE_EXTENDED(struct region_table,
+				       region_count,
+				       struct layout_region,
+				       "layout region table",
+				       &table);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	lr = &table->regions[0];
+	*lr++ = layout->header;
+	*lr++ = layout->config;
+	*lr++ = layout->index.sub_index;
+	*lr++ = layout->index.volume;
+
+	for (i = 0; i < layout->super.max_saves; i++)
+		*lr++ = layout->index.saves[i].index_save;
+
+	*lr++ = layout->seal;
+
+	if (is_converted_super_block(&layout->super))
+		payload = sizeof(struct super_block_data);
+	else
+		payload = (sizeof(struct super_block_data) -
+			   sizeof(layout->super.volume_offset) -
+			   sizeof(layout->super.start_offset));
+
+	table->header = (struct region_header) {
+		.magic = REGION_MAGIC,
+		.region_blocks = layout->total_blocks,
+		.type = RH_TYPE_SUPER,
+		.version = 1,
+		.region_count = region_count,
+		.payload = payload,
+	};
+
+	table->encoded_size = (sizeof(struct region_header) + payload +
+			       region_count * sizeof(struct layout_region));
+	*table_ptr = table;
+	return UDS_SUCCESS;
+}
+
+static int __must_check write_layout_header(struct index_layout *layout,
+					    struct region_table *table,
+					    struct buffered_writer *writer)
+{
+	int result;
+	u8 *buffer;
+	size_t offset = 0;
+
+	result = UDS_ALLOCATE(table->encoded_size, u8, "layout data", &buffer);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	encode_region_table(buffer, &offset, table);
+	memcpy(buffer + offset, &layout->super.magic_label, MAGIC_SIZE);
+	offset += MAGIC_SIZE;
+	memcpy(buffer + offset, &layout->super.nonce_info, NONCE_INFO_SIZE);
+	offset += NONCE_INFO_SIZE;
+	encode_u64_le(buffer, &offset, layout->super.nonce);
+	encode_u32_le(buffer, &offset, layout->super.version);
+	encode_u32_le(buffer, &offset, layout->super.block_size);
+	encode_u16_le(buffer, &offset, layout->super.index_count);
+	encode_u16_le(buffer, &offset, layout->super.max_saves);
+	encode_u32_le(buffer, &offset, 0);
+	encode_u64_le(buffer, &offset, layout->super.open_chapter_blocks);
+	encode_u64_le(buffer, &offset, layout->super.page_map_blocks);
+
+	if (is_converted_super_block(&layout->super)) {
+		encode_u64_le(buffer, &offset, layout->super.volume_offset);
+		encode_u64_le(buffer, &offset, layout->super.start_offset);
+	}
+
+	result = uds_write_to_buffered_writer(writer, buffer, offset);
+	UDS_FREE(buffer);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	return uds_flush_buffered_writer(writer);
+}
+
+static int __must_check write_uds_index_config(struct index_layout *layout,
+					       struct configuration *config,
+					       off_t offset)
+{
+	int result;
+	struct buffered_writer *writer = NULL;
+
+	result = open_layout_writer(layout, &layout->config, offset, &writer);
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result, "failed to open config region");
+
+	result = uds_write_config_contents(writer, config, layout->super.version);
+	if (result != UDS_SUCCESS) {
+		uds_free_buffered_writer(writer);
+		return uds_log_error_strerror(result, "failed to write config region");
+	}
+
+	result = uds_flush_buffered_writer(writer);
+	if (result != UDS_SUCCESS) {
+		uds_free_buffered_writer(writer);
+		return uds_log_error_strerror(result, "cannot flush config writer");
+	}
+
+	uds_free_buffered_writer(writer);
+	return UDS_SUCCESS;
+}
+
+static int __must_check save_layout(struct index_layout *layout, off_t offset)
+{
+	int result;
+	struct buffered_writer *writer = NULL;
+	struct region_table *table;
+
+	result = make_layout_region_table(layout, &table);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = open_layout_writer(layout, &layout->header, offset, &writer);
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(table);
+		return result;
+	}
+
+	result = write_layout_header(layout, table, writer);
+	UDS_FREE(table);
+	uds_free_buffered_writer(writer);
+
+	return result;
+}
+
+static int create_index_layout(struct index_layout *layout, struct configuration *config)
+{
+	int result;
+	struct save_layout_sizes sizes;
+
+	result = compute_sizes(config, &sizes);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(sizes.save_count,
+			      struct index_save_layout,
+			      __func__,
+			      &layout->index.saves);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	initialize_layout(layout, &sizes);
+
+	result = discard_index_state_data(layout);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = write_uds_index_config(layout, config, 0);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	return save_layout(layout, 0);
+}
+
+static u64 generate_index_save_nonce(u64 volume_nonce, struct index_save_layout *isl)
+{
+	struct save_nonce_data {
+		struct index_save_data data;
+		u64 offset;
+	} nonce_data;
+	u8 buffer[sizeof(nonce_data)];
+	size_t offset = 0;
+
+	encode_u64_le(buffer, &offset, isl->save_data.timestamp);
+	encode_u64_le(buffer, &offset, 0);
+	encode_u32_le(buffer, &offset, isl->save_data.version);
+	encode_u32_le(buffer, &offset, 0U);
+	encode_u64_le(buffer, &offset, isl->index_save.start_block);
+	ASSERT_LOG_ONLY(offset == sizeof(nonce_data),
+			"%zu bytes encoded of %zu expected",
+			offset,
+			sizeof(nonce_data));
+	return generate_secondary_nonce(volume_nonce, buffer, sizeof(buffer));
+}
+
+static u64 validate_index_save_layout(struct index_save_layout *isl, u64 volume_nonce)
+{
+	if ((isl->zone_count == 0) || (isl->save_data.timestamp == 0))
+		return 0;
+
+	if (isl->save_data.nonce != generate_index_save_nonce(volume_nonce, isl))
+		return 0;
+
+	return isl->save_data.timestamp;
+}
+
+static int
+find_latest_uds_index_save_slot(struct index_layout *layout, struct index_save_layout **isl_ptr)
+{
+	struct index_save_layout *latest = NULL;
+	struct index_save_layout *isl;
+	unsigned int i;
+	u64 save_time = 0;
+	u64 latest_time = 0;
+
+	for (i = 0; i < layout->super.max_saves; i++) {
+		isl = &layout->index.saves[i];
+		save_time = validate_index_save_layout(isl, layout->index.nonce);
+		if (save_time > latest_time) {
+			latest = isl;
+			latest_time = save_time;
+		}
+	}
+
+	if (latest == NULL) {
+		uds_log_error("No valid index save found");
+		return UDS_INDEX_NOT_SAVED_CLEANLY;
+	}
+
+	*isl_ptr = latest;
+	return UDS_SUCCESS;
+}
+
+int uds_discard_open_chapter(struct index_layout *layout)
+{
+	int result;
+	struct index_save_layout *isl;
+	struct buffered_writer *writer;
+
+	result = find_latest_uds_index_save_slot(layout, &isl);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = open_region_writer(layout, &isl->open_chapter, &writer);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_write_to_buffered_writer(writer, NULL, UDS_BLOCK_SIZE);
+	if (result != UDS_SUCCESS) {
+		uds_free_buffered_writer(writer);
+		return result;
+	}
+
+	result = uds_flush_buffered_writer(writer);
+	uds_free_buffered_writer(writer);
+	return result;
+}
+
+int uds_load_index_state(struct index_layout *layout, struct uds_index *index)
+{
+	int result;
+	unsigned int zone;
+	struct index_save_layout *isl;
+	struct buffered_reader *readers[MAX_ZONES];
+
+	result = find_latest_uds_index_save_slot(layout, &isl);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	index->newest_virtual_chapter = isl->state_data.newest_chapter;
+	index->oldest_virtual_chapter = isl->state_data.oldest_chapter;
+	index->last_save = isl->state_data.last_save;
+
+	result = open_region_reader(layout, &isl->open_chapter, &readers[0]);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_load_open_chapter(index, readers[0]);
+	uds_free_buffered_reader(readers[0]);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	for (zone = 0; zone < isl->zone_count; zone++) {
+		result = open_region_reader(layout,
+					    &isl->volume_index_zones[zone],
+					    &readers[zone]);
+		if (result != UDS_SUCCESS) {
+			for (; zone > 0; zone--)
+				uds_free_buffered_reader(readers[zone - 1]);
+
+			return result;
+		}
+	}
+
+	result = uds_load_volume_index(index->volume_index, readers, isl->zone_count);
+	for (zone = 0; zone < isl->zone_count; zone++)
+		uds_free_buffered_reader(readers[zone]);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = open_region_reader(layout, &isl->index_page_map, &readers[0]);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_read_index_page_map(index->volume->index_page_map, readers[0]);
+	uds_free_buffered_reader(readers[0]);
+
+	return result;
+}
+
+static struct index_save_layout *select_oldest_index_save_layout(struct index_layout *layout)
+{
+	struct index_save_layout *oldest = NULL;
+	struct index_save_layout *isl;
+	unsigned int i;
+	u64 save_time = 0;
+	u64 oldest_time = 0;
+
+	for (i = 0; i < layout->super.max_saves; i++) {
+		isl = &layout->index.saves[i];
+		save_time = validate_index_save_layout(isl, layout->index.nonce);
+		if (oldest == NULL || save_time < oldest_time) {
+			oldest = isl;
+			oldest_time = save_time;
+		}
+	}
+
+	return oldest;
+}
+
+static void instantiate_index_save_layout(struct index_save_layout *isl,
+					  struct super_block_data *super,
+					  u64 volume_nonce,
+					  unsigned int zone_count)
+{
+	unsigned int z;
+	u64 next_block;
+	u64 free_blocks;
+	u64 volume_index_blocks;
+
+	isl->zone_count = zone_count;
+	memset(&isl->save_data, 0, sizeof(isl->save_data));
+	isl->save_data.timestamp = ktime_to_ms(current_time_ns(CLOCK_REALTIME));
+	isl->save_data.version = 1;
+	isl->save_data.nonce = generate_index_save_nonce(volume_nonce, isl);
+
+	next_block = isl->index_save.start_block;
+	isl->header = (struct layout_region) {
+		.start_block = next_block++,
+		.block_count = 1,
+		.kind = RL_KIND_HEADER,
+		.instance = RL_SOLE_INSTANCE,
+	};
+
+	isl->index_page_map = (struct layout_region) {
+		.start_block = next_block,
+		.block_count = super->page_map_blocks,
+		.kind = RL_KIND_INDEX_PAGE_MAP,
+		.instance = RL_SOLE_INSTANCE,
+	};
+	next_block += super->page_map_blocks;
+
+	free_blocks = (isl->index_save.block_count - 1 -
+		       super->page_map_blocks -
+		       super->open_chapter_blocks);
+	volume_index_blocks = free_blocks / isl->zone_count;
+	for (z = 0; z < isl->zone_count; z++) {
+		isl->volume_index_zones[z] = (struct layout_region) {
+			.start_block = next_block,
+			.block_count = volume_index_blocks,
+			.kind = RL_KIND_VOLUME_INDEX,
+			.instance = z,
+		};
+
+		next_block += volume_index_blocks;
+		free_blocks -= volume_index_blocks;
+	}
+
+	isl->open_chapter = (struct layout_region) {
+		.start_block = next_block,
+		.block_count = super->open_chapter_blocks,
+		.kind = RL_KIND_OPEN_CHAPTER,
+		.instance = RL_SOLE_INSTANCE,
+	};
+
+	next_block += super->open_chapter_blocks;
+
+	isl->free_space = (struct layout_region) {
+		.start_block = next_block,
+		.block_count = free_blocks,
+		.kind = RL_KIND_EMPTY,
+		.instance = RL_SOLE_INSTANCE,
+	};
+}
+
+static int setup_uds_index_save_slot(struct index_layout *layout,
+				     unsigned int zone_count,
+				     struct index_save_layout **isl_ptr)
+{
+	int result;
+	struct index_save_layout *isl;
+
+	isl = select_oldest_index_save_layout(layout);
+	result = invalidate_old_save(layout, isl);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	instantiate_index_save_layout(isl, &layout->super, layout->index.nonce, zone_count);
+
+	*isl_ptr = isl;
+	return UDS_SUCCESS;
+}
+
+static void cancel_uds_index_save(struct index_save_layout *isl)
+{
+	memset(&isl->save_data, 0, sizeof(isl->save_data));
+	memset(&isl->state_data, 0, sizeof(isl->state_data));
+	isl->zone_count = 0;
+}
+
+int uds_save_index_state(struct index_layout *layout, struct uds_index *index)
+{
+	int result;
+	unsigned int zone;
+	struct index_save_layout *isl;
+	struct buffered_writer *writers[MAX_ZONES];
+
+	result = setup_uds_index_save_slot(layout, index->zone_count, &isl);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	isl->state_data	= (struct index_state_data301) {
+		.newest_chapter = index->newest_virtual_chapter,
+		.oldest_chapter = index->oldest_virtual_chapter,
+		.last_save = index->last_save,
+	};
+
+	result = open_region_writer(layout, &isl->open_chapter, &writers[0]);
+	if (result != UDS_SUCCESS) {
+		cancel_uds_index_save(isl);
+		return result;
+	}
+
+	result = uds_save_open_chapter(index, writers[0]);
+	uds_free_buffered_writer(writers[0]);
+	if (result != UDS_SUCCESS) {
+		cancel_uds_index_save(isl);
+		return result;
+	}
+
+	for (zone = 0; zone < index->zone_count; zone++) {
+		result = open_region_writer(layout,
+					    &isl->volume_index_zones[zone],
+					    &writers[zone]);
+		if (result != UDS_SUCCESS) {
+			for (; zone > 0; zone--)
+				uds_free_buffered_writer(writers[zone - 1]);
+
+			cancel_uds_index_save(isl);
+			return result;
+		}
+	}
+
+	result = uds_save_volume_index(index->volume_index, writers, index->zone_count);
+	for (zone = 0; zone < index->zone_count; zone++)
+		uds_free_buffered_writer(writers[zone]);
+	if (result != UDS_SUCCESS) {
+		cancel_uds_index_save(isl);
+		return result;
+	}
+
+	result = open_region_writer(layout, &isl->index_page_map, &writers[0]);
+	if (result != UDS_SUCCESS) {
+		cancel_uds_index_save(isl);
+		return result;
+	}
+
+	result = uds_write_index_page_map(index->volume->index_page_map, writers[0]);
+	uds_free_buffered_writer(writers[0]);
+	if (result != UDS_SUCCESS) {
+		cancel_uds_index_save(isl);
+		return result;
+	}
+
+	return write_index_save_layout(layout, isl);
+}
+
+static int __must_check
+load_region_table(struct buffered_reader *reader, struct region_table **table_ptr)
+{
+	int result;
+	unsigned int i;
+	struct region_header header;
+	struct region_table *table;
+	u8 buffer[sizeof(struct region_header)];
+	size_t offset = 0;
+
+	result = uds_read_from_buffered_reader(reader, buffer, sizeof(buffer));
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result, "cannot read region table header");
+
+	decode_u64_le(buffer, &offset, &header.magic);
+	decode_u64_le(buffer, &offset, &header.region_blocks);
+	decode_u16_le(buffer, &offset, &header.type);
+	decode_u16_le(buffer, &offset, &header.version);
+	decode_u16_le(buffer, &offset, &header.region_count);
+	decode_u16_le(buffer, &offset, &header.payload);
+
+	if (header.magic != REGION_MAGIC)
+		return UDS_NO_INDEX;
+
+	if (header.version != 1)
+		return uds_log_error_strerror(UDS_UNSUPPORTED_VERSION,
+					      "unknown region table version %hu",
+					      header.version);
+
+	result = UDS_ALLOCATE_EXTENDED(struct region_table,
+				       header.region_count,
+				       struct layout_region,
+				       "single file layout region table",
+				       &table);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	table->header = header;
+	for (i = 0; i < header.region_count; i++) {
+		u8 region_buffer[sizeof(struct layout_region)];
+
+		offset = 0;
+		result = uds_read_from_buffered_reader(reader,
+						       region_buffer,
+						       sizeof(region_buffer));
+		if (result != UDS_SUCCESS) {
+			UDS_FREE(table);
+			return uds_log_error_strerror(UDS_CORRUPT_DATA,
+						      "cannot read region table layouts");
+		}
+
+		decode_u64_le(region_buffer, &offset, &table->regions[i].start_block);
+		decode_u64_le(region_buffer, &offset, &table->regions[i].block_count);
+		offset += sizeof(u32);
+		decode_u16_le(region_buffer, &offset, &table->regions[i].kind);
+		decode_u16_le(region_buffer, &offset, &table->regions[i].instance);
+	}
+
+	*table_ptr = table;
+	return UDS_SUCCESS;
+}
+
+static int __must_check read_super_block_data(struct buffered_reader *reader,
+					      struct index_layout *layout,
+					      size_t saved_size)
+{
+	int result;
+	struct super_block_data *super = &layout->super;
+	u8 *buffer;
+	size_t offset = 0;
+
+	result = UDS_ALLOCATE(saved_size, u8, "super block data", &buffer);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_read_from_buffered_reader(reader, buffer, saved_size);
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(buffer);
+		return uds_log_error_strerror(result, "cannot read region table header");
+	}
+
+	memcpy(&super->magic_label, buffer, MAGIC_SIZE);
+	offset += MAGIC_SIZE;
+	memcpy(&super->nonce_info, buffer + offset, NONCE_INFO_SIZE);
+	offset += NONCE_INFO_SIZE;
+	decode_u64_le(buffer, &offset, &super->nonce);
+	decode_u32_le(buffer, &offset, &super->version);
+	decode_u32_le(buffer, &offset, &super->block_size);
+	decode_u16_le(buffer, &offset, &super->index_count);
+	decode_u16_le(buffer, &offset, &super->max_saves);
+	offset += sizeof(u32);
+	decode_u64_le(buffer, &offset, &super->open_chapter_blocks);
+	decode_u64_le(buffer, &offset, &super->page_map_blocks);
+
+	if (is_converted_super_block(super)) {
+		decode_u64_le(buffer, &offset, &super->volume_offset);
+		decode_u64_le(buffer, &offset, &super->start_offset);
+	} else {
+		super->volume_offset = 0;
+		super->start_offset = 0;
+	}
+
+	UDS_FREE(buffer);
+
+	if (memcmp(super->magic_label, LAYOUT_MAGIC, MAGIC_SIZE) != 0)
+		return uds_log_error_strerror(UDS_CORRUPT_DATA, "unknown superblock magic label");
+
+	if ((super->version < SUPER_VERSION_MINIMUM) ||
+	    (super->version == 4) ||
+	    (super->version == 5) ||
+	    (super->version == 6) ||
+	    (super->version > SUPER_VERSION_MAXIMUM))
+		return uds_log_error_strerror(UDS_UNSUPPORTED_VERSION,
+					      "unknown superblock version number %u",
+					      super->version);
+
+	if (super->volume_offset < super->start_offset)
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "inconsistent offsets (start %llu, volume %llu)",
+					      (unsigned long long) super->start_offset,
+					      (unsigned long long) super->volume_offset);
+
+	/* Sub-indexes are no longer used but the layout retains this field. */
+	if (super->index_count != 1)
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "invalid subindex count %u",
+					      super->index_count);
+
+	if (generate_primary_nonce(super->nonce_info, sizeof(super->nonce_info)) != super->nonce)
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "inconsistent superblock nonce");
+
+	return UDS_SUCCESS;
+}
+
+static int __must_check verify_region(struct layout_region *lr,
+				      u64 start_block,
+				      enum region_kind kind,
+				      unsigned int instance)
+{
+	if (lr->start_block != start_block)
+		return uds_log_error_strerror(UDS_CORRUPT_DATA, "incorrect layout region offset");
+
+	if (lr->kind != kind)
+		return uds_log_error_strerror(UDS_CORRUPT_DATA, "incorrect layout region kind");
+
+	if (lr->instance != instance)
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "incorrect layout region instance");
+
+	return UDS_SUCCESS;
+}
+
+static int __must_check
+verify_sub_index(struct index_layout *layout, u64 start_block, struct region_table *table)
+{
+	int result;
+	unsigned int i;
+	struct sub_index_layout *sil = &layout->index;
+	u64 next_block = start_block;
+
+	sil->sub_index = table->regions[2];
+	result = verify_region(&sil->sub_index, next_block, RL_KIND_INDEX, 0);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	define_sub_index_nonce(layout);
+
+	sil->volume = table->regions[3];
+	result = verify_region(&sil->volume, next_block, RL_KIND_VOLUME, RL_SOLE_INSTANCE);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	next_block += sil->volume.block_count + layout->super.volume_offset;
+
+	for (i = 0; i < layout->super.max_saves; i++) {
+		sil->saves[i].index_save = table->regions[i + 4];
+		result = verify_region(&sil->saves[i].index_save, next_block, RL_KIND_SAVE, i);
+		if (result != UDS_SUCCESS)
+			return result;
+
+		next_block += sil->saves[i].index_save.block_count;
+	}
+
+	next_block -= layout->super.volume_offset;
+	if (next_block != start_block + sil->sub_index.block_count)
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "sub index region does not span all saves");
+
+	return UDS_SUCCESS;
+}
+
+static int __must_check
+reconstitute_layout(struct index_layout *layout, struct region_table *table, u64 first_block)
+{
+	int result;
+	u64 next_block = first_block;
+
+	result = UDS_ALLOCATE(layout->super.max_saves,
+			      struct index_save_layout,
+			      __func__,
+			      &layout->index.saves);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	layout->total_blocks = table->header.region_blocks;
+
+	layout->header = table->regions[0];
+	result = verify_region(&layout->header, next_block++, RL_KIND_HEADER, RL_SOLE_INSTANCE);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	layout->config = table->regions[1];
+	result = verify_region(&layout->config, next_block++, RL_KIND_CONFIG, RL_SOLE_INSTANCE);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = verify_sub_index(layout, next_block, table);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	next_block += layout->index.sub_index.block_count;
+
+	layout->seal = table->regions[table->header.region_count - 1];
+	result = verify_region(&layout->seal,
+			       next_block + layout->super.volume_offset,
+			       RL_KIND_SEAL,
+			       RL_SOLE_INSTANCE);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (++next_block != (first_block + layout->total_blocks))
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "layout table does not span total blocks");
+
+	return UDS_SUCCESS;
+}
+
+static int __must_check load_super_block(struct index_layout *layout,
+					 size_t block_size,
+					 u64 first_block,
+					 struct buffered_reader *reader)
+{
+	int result;
+	struct region_table *table = NULL;
+	struct super_block_data *super = &layout->super;
+
+	result = load_region_table(reader, &table);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (table->header.type != RH_TYPE_SUPER) {
+		UDS_FREE(table);
+		return uds_log_error_strerror(UDS_CORRUPT_DATA, "not a superblock region table");
+	}
+
+	result = read_super_block_data(reader, layout, table->header.payload);
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(table);
+		return uds_log_error_strerror(result, "unknown superblock format");
+	}
+
+	if (super->block_size != block_size) {
+		UDS_FREE(table);
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "superblock saved block_size %u differs from supplied block_size %zu",
+					      super->block_size,
+					      block_size);
+	}
+
+	first_block -= (super->volume_offset - super->start_offset);
+	result = reconstitute_layout(layout, table, first_block);
+	UDS_FREE(table);
+	return result;
+}
+
+static int __must_check read_index_save_data(struct buffered_reader *reader,
+					     struct index_save_layout *isl,
+					     size_t saved_size)
+{
+	int result;
+	struct index_state_version file_version;
+	u8 buffer[sizeof(struct index_save_data) + sizeof(struct index_state_data301)];
+	size_t offset = 0;
+
+	if (saved_size != sizeof(buffer))
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "unexpected index save data size %zu",
+					      saved_size);
+
+	result = uds_read_from_buffered_reader(reader, buffer, sizeof(buffer));
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result, "cannot read index save data");
+
+	decode_u64_le(buffer, &offset, &isl->save_data.timestamp);
+	decode_u64_le(buffer, &offset, &isl->save_data.nonce);
+	decode_u32_le(buffer, &offset, &isl->save_data.version);
+	offset += sizeof(u32);
+
+	if (isl->save_data.version > 1)
+		return uds_log_error_strerror(UDS_UNSUPPORTED_VERSION,
+					      "unknown index save version number %u",
+					      isl->save_data.version);
+
+	decode_s32_le(buffer, &offset, &file_version.signature);
+	decode_s32_le(buffer, &offset, &file_version.version_id);
+
+	if ((file_version.signature != INDEX_STATE_VERSION_301.signature) ||
+	    (file_version.version_id != INDEX_STATE_VERSION_301.version_id))
+		return uds_log_error_strerror(UDS_UNSUPPORTED_VERSION,
+					      "index state version %d,%d is unsupported",
+					      file_version.signature,
+					      file_version.version_id);
+
+	decode_u64_le(buffer, &offset, &isl->state_data.newest_chapter);
+	decode_u64_le(buffer, &offset, &isl->state_data.oldest_chapter);
+	decode_u64_le(buffer, &offset, &isl->state_data.last_save);
+	/* Skip past some historical fields that are now unused */
+	offset += sizeof(u32) + sizeof(u32);
+	return UDS_SUCCESS;
+}
+
+static int __must_check
+reconstruct_index_save(struct index_save_layout *isl, struct region_table *table)
+{
+	int result;
+	unsigned int z;
+	struct layout_region *last_region;
+	u64 next_block = isl->index_save.start_block;
+	u64 last_block = next_block + isl->index_save.block_count;
+
+	isl->zone_count = table->header.region_count - 3;
+
+	last_region = &table->regions[table->header.region_count - 1];
+	if (last_region->kind == RL_KIND_EMPTY) {
+		isl->free_space = *last_region;
+		isl->zone_count--;
+	} else {
+		isl->free_space = (struct layout_region) {
+			.start_block = last_block,
+			.block_count = 0,
+			.kind = RL_KIND_EMPTY,
+			.instance = RL_SOLE_INSTANCE,
+		};
+	}
+
+	isl->header = table->regions[0];
+	result = verify_region(&isl->header, next_block++, RL_KIND_HEADER, RL_SOLE_INSTANCE);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	isl->index_page_map = table->regions[1];
+	result = verify_region(&isl->index_page_map,
+			       next_block,
+			       RL_KIND_INDEX_PAGE_MAP,
+			       RL_SOLE_INSTANCE);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	next_block += isl->index_page_map.block_count;
+
+	for (z = 0; z < isl->zone_count; z++) {
+		isl->volume_index_zones[z] = table->regions[z + 2];
+		result = verify_region(&isl->volume_index_zones[z],
+				       next_block,
+				       RL_KIND_VOLUME_INDEX,
+				       z);
+		if (result != UDS_SUCCESS)
+			return result;
+
+		next_block += isl->volume_index_zones[z].block_count;
+	}
+
+	isl->open_chapter = table->regions[isl->zone_count + 2];
+	result = verify_region(&isl->open_chapter,
+			       next_block,
+			       RL_KIND_OPEN_CHAPTER,
+			       RL_SOLE_INSTANCE);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	next_block += isl->open_chapter.block_count;
+
+	result = verify_region(&isl->free_space, next_block, RL_KIND_EMPTY, RL_SOLE_INSTANCE);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	next_block += isl->free_space.block_count;
+	if (next_block != last_block)
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "index save layout table incomplete");
+
+	return UDS_SUCCESS;
+}
+
+static int __must_check load_index_save(struct index_save_layout *isl,
+					struct buffered_reader *reader,
+					unsigned int instance)
+{
+	int result;
+	struct region_table *table = NULL;
+
+	result = load_region_table(reader, &table);
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result,
+					      "cannot read index save %u header",
+					      instance);
+
+	if (table->header.region_blocks != isl->index_save.block_count) {
+		u64 region_blocks = table->header.region_blocks;
+
+		UDS_FREE(table);
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "unexpected index save %u region block count %llu",
+					      instance,
+					      (unsigned long long) region_blocks);
+	}
+
+	if (table->header.type == RH_TYPE_UNSAVED) {
+		UDS_FREE(table);
+		reset_index_save_layout(isl, 0);
+		return UDS_SUCCESS;
+	}
+
+
+	if (table->header.type != RH_TYPE_SAVE) {
+		UDS_FREE(table);
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "unexpected index save %u header type %u",
+					      instance,
+					      table->header.type);
+	}
+
+	result = read_index_save_data(reader, isl, table->header.payload);
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(table);
+		return uds_log_error_strerror(result,
+					      "unknown index save %u data format",
+					      instance);
+	}
+
+	result = reconstruct_index_save(isl, table);
+	UDS_FREE(table);
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result,
+					      "cannot reconstruct index save %u",
+					      instance);
+
+	return UDS_SUCCESS;
+}
+
+static int __must_check load_sub_index_regions(struct index_layout *layout)
+{
+	int result;
+	unsigned int j;
+	struct index_save_layout *isl;
+	struct buffered_reader *reader;
+
+	for (j = 0; j < layout->super.max_saves; ++j) {
+		isl = &layout->index.saves[j];
+		result = open_region_reader(layout, &isl->index_save, &reader);
+
+		if (result != UDS_SUCCESS) {
+			uds_log_error_strerror(result, "cannot get reader for index 0 save %u", j);
+			return result;
+		}
+
+		result = load_index_save(isl, reader, j);
+		uds_free_buffered_reader(reader);
+		if (result != UDS_SUCCESS) {
+			/* Another save slot might be valid. */
+			reset_index_save_layout(isl, 0);
+			continue;
+		}
+	}
+
+	return UDS_SUCCESS;
+}
+
+static int __must_check
+verify_uds_index_config(struct index_layout *layout, struct configuration *config)
+{
+	int result;
+	struct buffered_reader *reader = NULL;
+	u64 offset;
+
+	offset = layout->super.volume_offset - layout->super.start_offset;
+	result = open_layout_reader(layout, &layout->config, offset, &reader);
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result, "failed to open config reader");
+
+	result = uds_validate_config_contents(reader, config);
+	if (result != UDS_SUCCESS) {
+		uds_free_buffered_reader(reader);
+		return uds_log_error_strerror(result, "failed to read config region");
+	}
+
+	uds_free_buffered_reader(reader);
+	return UDS_SUCCESS;
+}
+
+static int load_index_layout(struct index_layout *layout, struct configuration *config)
+{
+	int result;
+	struct buffered_reader *reader;
+
+	result = uds_make_buffered_reader(layout->factory,
+					  layout->offset / UDS_BLOCK_SIZE,
+					  1,
+					  &reader);
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result, "unable to read superblock");
+
+	result = load_super_block(layout, UDS_BLOCK_SIZE, layout->offset / UDS_BLOCK_SIZE, reader);
+	uds_free_buffered_reader(reader);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = verify_uds_index_config(layout, config);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	return load_sub_index_regions(layout);
+}
+
+static int create_layout_factory(struct index_layout *layout, const struct configuration *config)
+{
+	int result;
+	size_t writable_size;
+	struct io_factory *factory = NULL;
+
+	result = uds_make_io_factory(config->name, &factory);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	writable_size = uds_get_writable_size(factory) & -UDS_BLOCK_SIZE;
+	if (writable_size < config->size + config->offset) {
+		uds_put_io_factory(factory);
+		uds_log_error("index storage (%zu) is smaller than the requested size %zu",
+			      writable_size,
+			      config->size + config->offset);
+		return -ENOSPC;
+	}
+
+	layout->factory = factory;
+	layout->factory_size = (config->size > 0) ? config->size : writable_size;
+	layout->offset = config->offset;
+	return UDS_SUCCESS;
+}
+
+int uds_make_index_layout(struct configuration *config,
+			  bool new_layout,
+			  struct index_layout **layout_ptr)
+{
+	int result;
+	struct index_layout *layout = NULL;
+	struct save_layout_sizes sizes;
+
+	result = compute_sizes(config, &sizes);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(1, struct index_layout, __func__, &layout);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = create_layout_factory(layout, config);
+	if (result != UDS_SUCCESS) {
+		uds_free_index_layout(layout);
+		return result;
+	}
+
+	if (layout->factory_size < sizes.total_size) {
+		uds_log_error("index storage (%zu) is smaller than the required size %llu",
+			      layout->factory_size,
+			      (unsigned long long) sizes.total_size);
+		uds_free_index_layout(layout);
+		return -ENOSPC;
+	}
+
+	if (new_layout)
+		result = create_index_layout(layout, config);
+	else
+		result = load_index_layout(layout, config);
+	if (result != UDS_SUCCESS) {
+		uds_free_index_layout(layout);
+		return result;
+	}
+
+	*layout_ptr = layout;
+	return UDS_SUCCESS;
+}
+
+void uds_free_index_layout(struct index_layout *layout)
+{
+	if (layout == NULL)
+		return;
+
+	UDS_FREE(layout->index.saves);
+	if (layout->factory != NULL)
+		uds_put_io_factory(layout->factory);
+
+	UDS_FREE(layout);
+}
+
+int uds_replace_index_layout_storage(struct index_layout *layout, const char *name)
+{
+	return uds_replace_storage(layout->factory, name);
+}
+
+/* Obtain a dm_bufio_client for the volume region. */
+int uds_open_volume_bufio(struct index_layout *layout,
+			  size_t block_size,
+			  unsigned int reserved_buffers,
+			  struct dm_bufio_client **client_ptr)
+{
+	off_t offset = (layout->index.volume.start_block +
+			layout->super.volume_offset -
+			layout->super.start_offset);
+
+	return uds_make_bufio(layout->factory, offset, block_size, reserved_buffers, client_ptr);
+}
+
+u64 uds_get_volume_nonce(struct index_layout *layout)
+{
+	return layout->index.nonce;
+}
diff --git a/drivers/md/dm-vdo/index-layout.h b/drivers/md/dm-vdo/index-layout.h
new file mode 100644
index 00000000000..02e368c0331
--- /dev/null
+++ b/drivers/md/dm-vdo/index-layout.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_INDEX_LAYOUT_H
+#define UDS_INDEX_LAYOUT_H
+
+#include "config.h"
+#include "io-factory.h"
+#include "uds.h"
+
+/*
+ * The index layout describes the format of the index on the underlying storage, and is responsible
+ * for creating those structures when the index is first created. It also validates the index data
+ * when loading a saved index, and updates it when saving the index.
+ */
+
+struct index_layout;
+
+int __must_check uds_make_index_layout(struct configuration *config,
+				       bool new_layout,
+				       struct index_layout **layout_ptr);
+
+void uds_free_index_layout(struct index_layout *layout);
+
+int __must_check uds_replace_index_layout_storage(struct index_layout *layout, const char *name);
+
+int __must_check uds_load_index_state(struct index_layout *layout, struct uds_index *index);
+
+int __must_check uds_save_index_state(struct index_layout *layout, struct uds_index *index);
+
+int __must_check uds_discard_open_chapter(struct index_layout *layout);
+
+u64 __must_check uds_get_volume_nonce(struct index_layout *layout);
+
+int __must_check uds_open_volume_bufio(struct index_layout *layout,
+				       size_t block_size,
+				       unsigned int reserved_buffers,
+				       struct dm_bufio_client **client_ptr);
+
+#endif /* UDS_INDEX_LAYOUT_H */
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
diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/index-session.c
new file mode 100644
index 00000000000..de77268fb4d
--- /dev/null
+++ b/drivers/md/dm-vdo/index-session.c
@@ -0,0 +1,815 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "index-session.h"
+
+#include <linux/atomic.h>
+
+#include "index.h"
+#include "index-layout.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "request-queue.h"
+#include "time-utils.h"
+
+/*
+ * The index session contains a lock (the request_mutex) which ensures that only one thread can
+ * change the state of its index at a time. The state field indicates the current state of the
+ * index through a set of descriptive flags. The request_mutex must be notified whenever a
+ * non-transient state flag is cleared. The request_mutex is also used to count the number of
+ * requests currently in progress so that they can be drained when suspending or closing the index.
+ *
+ * If the index session is suspended shortly after opening an index, it may have to suspend during
+ * a rebuild. Depending on the size of the index, a rebuild may take a significant amount of time,
+ * so UDS allows the rebuild to be paused in order to suspend the session in a timely manner. When
+ * the index session is resumed, the rebuild can continue from where it left off. If the index
+ * session is shut down with a suspended rebuild, the rebuild progress is abandoned and the rebuild
+ * will start from the beginning the next time the index is loaded. The mutex and status fields in
+ * the index_load_context are used to record the state of any interrupted rebuild.
+ */
+
+enum index_session_flag_bit {
+	IS_FLAG_BIT_START = 8,
+	/* The session has started loading an index but not completed it. */
+	IS_FLAG_BIT_LOADING = IS_FLAG_BIT_START,
+	/* The session has loaded an index, which can handle requests. */
+	IS_FLAG_BIT_LOADED,
+	/* The session's index has been permanently disabled. */
+	IS_FLAG_BIT_DISABLED,
+	/* The session's index is suspended. */
+	IS_FLAG_BIT_SUSPENDED,
+	/* The session is handling some index state change. */
+	IS_FLAG_BIT_WAITING,
+	/* The session's index is closing and draining requests. */
+	IS_FLAG_BIT_CLOSING,
+	/* The session is being destroyed and is draining requests. */
+	IS_FLAG_BIT_DESTROYING,
+};
+
+enum index_session_flag {
+	IS_FLAG_LOADED = (1 << IS_FLAG_BIT_LOADED),
+	IS_FLAG_LOADING = (1 << IS_FLAG_BIT_LOADING),
+	IS_FLAG_DISABLED = (1 << IS_FLAG_BIT_DISABLED),
+	IS_FLAG_SUSPENDED = (1 << IS_FLAG_BIT_SUSPENDED),
+	IS_FLAG_WAITING = (1 << IS_FLAG_BIT_WAITING),
+	IS_FLAG_CLOSING = (1 << IS_FLAG_BIT_CLOSING),
+	IS_FLAG_DESTROYING = (1 << IS_FLAG_BIT_DESTROYING),
+};
+
+/* Release a reference to an index session. */
+static void release_index_session(struct uds_index_session *index_session)
+{
+	uds_lock_mutex(&index_session->request_mutex);
+	if (--index_session->request_count == 0)
+		uds_broadcast_cond(&index_session->request_cond);
+	uds_unlock_mutex(&index_session->request_mutex);
+}
+
+/*
+ * Acquire a reference to the index session for an asynchronous index request. The reference must
+ * eventually be released with a corresponding call to release_index_session().
+ */
+static int get_index_session(struct uds_index_session *index_session)
+{
+	unsigned int state;
+	int result = UDS_SUCCESS;
+
+	uds_lock_mutex(&index_session->request_mutex);
+	index_session->request_count++;
+	state = index_session->state;
+	uds_unlock_mutex(&index_session->request_mutex);
+
+	if (state == IS_FLAG_LOADED) {
+		return UDS_SUCCESS;
+	} else if (state & IS_FLAG_DISABLED) {
+		result = UDS_DISABLED;
+	} else if ((state & IS_FLAG_LOADING) ||
+		   (state & IS_FLAG_SUSPENDED) ||
+		   (state & IS_FLAG_WAITING)) {
+		result = -EBUSY;
+	} else {
+		result = UDS_NO_INDEX;
+	}
+
+	release_index_session(index_session);
+	return result;
+}
+
+int uds_launch_request(struct uds_request *request)
+{
+	size_t internal_size;
+	int result;
+
+	if (request->callback == NULL) {
+		uds_log_error("missing required callback");
+		return -EINVAL;
+	}
+
+	switch (request->type) {
+	case UDS_DELETE:
+	case UDS_POST:
+	case UDS_QUERY:
+	case UDS_QUERY_NO_UPDATE:
+	case UDS_UPDATE:
+		break;
+	default:
+		uds_log_error("received invalid callback type");
+		return -EINVAL;
+	}
+
+	/* Reset all internal fields before processing. */
+	internal_size = sizeof(struct uds_request) - offsetof(struct uds_request, zone_number);
+	// FIXME should be using struct_group for this instead
+	memset((char *) request + sizeof(*request) - internal_size, 0, internal_size);
+
+	result = get_index_session(request->session);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	request->found = false;
+	request->unbatched = false;
+	request->index = request->session->index;
+
+	uds_enqueue_request(request, STAGE_TRIAGE);
+	return UDS_SUCCESS;
+}
+
+static void enter_callback_stage(struct uds_request *request)
+{
+	if (request->status != UDS_SUCCESS) {
+		/* All request errors are considered unrecoverable */
+		uds_lock_mutex(&request->session->request_mutex);
+		request->session->state |= IS_FLAG_DISABLED;
+		uds_unlock_mutex(&request->session->request_mutex);
+	}
+
+	uds_request_queue_enqueue(request->session->callback_queue, request);
+}
+
+static inline void count_once(u64 *count_ptr)
+{
+	WRITE_ONCE(*count_ptr, READ_ONCE(*count_ptr) + 1);
+}
+
+static void update_session_stats(struct uds_request *request)
+{
+	struct session_stats *session_stats = &request->session->stats;
+
+	count_once(&session_stats->requests);
+
+	switch (request->type) {
+	case UDS_POST:
+		if (request->found)
+			count_once(&session_stats->posts_found);
+		else
+			count_once(&session_stats->posts_not_found);
+
+		if (request->location == UDS_LOCATION_IN_OPEN_CHAPTER)
+			count_once(&session_stats->posts_found_open_chapter);
+		else if (request->location == UDS_LOCATION_IN_DENSE)
+			count_once(&session_stats->posts_found_dense);
+		else if (request->location == UDS_LOCATION_IN_SPARSE)
+			count_once(&session_stats->posts_found_sparse);
+		break;
+
+	case UDS_UPDATE:
+		if (request->found)
+			count_once(&session_stats->updates_found);
+		else
+			count_once(&session_stats->updates_not_found);
+		break;
+
+	case UDS_DELETE:
+		if (request->found)
+			count_once(&session_stats->deletions_found);
+		else
+			count_once(&session_stats->deletions_not_found);
+		break;
+
+	case UDS_QUERY:
+	case UDS_QUERY_NO_UPDATE:
+		if (request->found)
+			count_once(&session_stats->queries_found);
+		else
+			count_once(&session_stats->queries_not_found);
+		break;
+
+	default:
+		request->status = ASSERT(false, "unknown request type: %d", request->type);
+	}
+}
+
+static void handle_callbacks(struct uds_request *request)
+{
+	struct uds_index_session *index_session = request->session;
+
+	if (request->status == UDS_SUCCESS)
+		update_session_stats(request);
+
+	request->status = uds_map_to_system_error(request->status);
+	request->callback(request);
+	release_index_session(index_session);
+}
+
+static int __must_check make_empty_index_session(struct uds_index_session **index_session_ptr)
+{
+	int result;
+	struct uds_index_session *session;
+
+	result = UDS_ALLOCATE(1, struct uds_index_session, __func__, &session);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_init_mutex(&session->request_mutex);
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(session);
+		return result;
+	}
+
+	result = uds_init_cond(&session->request_cond);
+	if (result != UDS_SUCCESS) {
+		uds_destroy_mutex(&session->request_mutex);
+		UDS_FREE(session);
+		return result;
+	}
+
+	result = uds_init_mutex(&session->load_context.mutex);
+	if (result != UDS_SUCCESS) {
+		uds_destroy_cond(&session->request_cond);
+		uds_destroy_mutex(&session->request_mutex);
+		UDS_FREE(session);
+		return result;
+	}
+
+	result = uds_init_cond(&session->load_context.cond);
+	if (result != UDS_SUCCESS) {
+		uds_destroy_mutex(&session->load_context.mutex);
+		uds_destroy_cond(&session->request_cond);
+		uds_destroy_mutex(&session->request_mutex);
+		UDS_FREE(session);
+		return result;
+	}
+
+	result = uds_make_request_queue("callbackW", &handle_callbacks, &session->callback_queue);
+	if (result != UDS_SUCCESS) {
+		uds_destroy_cond(&session->load_context.cond);
+		uds_destroy_mutex(&session->load_context.mutex);
+		uds_destroy_cond(&session->request_cond);
+		uds_destroy_mutex(&session->request_mutex);
+		UDS_FREE(session);
+		return result;
+	}
+
+	*index_session_ptr = session;
+	return UDS_SUCCESS;
+}
+
+int uds_create_index_session(struct uds_index_session **session)
+{
+	if (session == NULL) {
+		uds_log_error("missing session pointer");
+		return -EINVAL;
+	}
+
+	return uds_map_to_system_error(make_empty_index_session(session));
+}
+
+static int __must_check start_loading_index_session(struct uds_index_session *index_session)
+{
+	int result;
+
+	uds_lock_mutex(&index_session->request_mutex);
+	if (index_session->state & IS_FLAG_SUSPENDED) {
+		uds_log_info("Index session is suspended");
+		result = -EBUSY;
+	} else if (index_session->state != 0) {
+		uds_log_info("Index is already loaded");
+		result = -EBUSY;
+	} else {
+		index_session->state |= IS_FLAG_LOADING;
+		result = UDS_SUCCESS;
+	}
+	uds_unlock_mutex(&index_session->request_mutex);
+	return result;
+}
+
+static void finish_loading_index_session(struct uds_index_session *index_session, int result)
+{
+	uds_lock_mutex(&index_session->request_mutex);
+	index_session->state &= ~IS_FLAG_LOADING;
+	if (result == UDS_SUCCESS)
+		index_session->state |= IS_FLAG_LOADED;
+
+	uds_broadcast_cond(&index_session->request_cond);
+	uds_unlock_mutex(&index_session->request_mutex);
+}
+
+static int initialize_index_session(struct uds_index_session *index_session,
+				    enum uds_open_index_type open_type)
+{
+	int result;
+	struct configuration *config;
+
+	result = uds_make_configuration(&index_session->parameters, &config);
+	if (result != UDS_SUCCESS) {
+		uds_log_error_strerror(result, "Failed to allocate config");
+		return result;
+	}
+
+	memset(&index_session->stats, 0, sizeof(index_session->stats));
+	result = uds_make_index(config,
+				open_type,
+				&index_session->load_context,
+				enter_callback_stage,
+				&index_session->index);
+	if (result != UDS_SUCCESS)
+		uds_log_error_strerror(result, "Failed to make index");
+	else
+		uds_log_configuration(config);
+
+	uds_free_configuration(config);
+	return result;
+}
+
+static const char *get_open_type_string(enum uds_open_index_type open_type)
+{
+	switch (open_type) {
+	case UDS_CREATE:
+		return "creating index";
+	case UDS_LOAD:
+		return "loading or rebuilding index";
+	case UDS_NO_REBUILD:
+		return "loading index";
+	default:
+		return "unknown open method";
+	}
+}
+
+/*
+ * Open an index under the given session. This operation will fail if the
+ * index session is suspended, or if there is already an open index.
+ */
+int uds_open_index(enum uds_open_index_type open_type,
+		   const struct uds_parameters *parameters,
+		   struct uds_index_session *session)
+{
+	int result;
+
+	if (parameters == NULL) {
+		uds_log_error("missing required parameters");
+		return -EINVAL;
+	}
+	if (parameters->name == NULL) {
+		uds_log_error("missing required index name");
+		return -EINVAL;
+	}
+	if (session == NULL) {
+		uds_log_error("missing required session pointer");
+		return -EINVAL;
+	}
+
+	result = start_loading_index_session(session);
+	if (result != UDS_SUCCESS)
+		return uds_map_to_system_error(result);
+
+	if ((session->parameters.name == NULL) ||
+	    (strcmp(parameters->name, session->parameters.name) != 0)) {
+		char *new_name;
+
+		result = uds_duplicate_string(parameters->name, "device name", &new_name);
+		if (result != UDS_SUCCESS) {
+			finish_loading_index_session(session, result);
+			return uds_map_to_system_error(result);
+		}
+
+		uds_free_const(session->parameters.name);
+		session->parameters = *parameters;
+		session->parameters.name = new_name;
+	} else {
+		const char *old_name = session->parameters.name;
+
+		session->parameters = *parameters;
+		session->parameters.name = old_name;
+	}
+
+	uds_log_notice("%s: %s", get_open_type_string(open_type), parameters->name);
+	result = initialize_index_session(session, open_type);
+	if (result != UDS_SUCCESS)
+		uds_log_error_strerror(result, "Failed %s", get_open_type_string(open_type));
+
+	finish_loading_index_session(session, result);
+	return uds_map_to_system_error(result);
+}
+
+static void wait_for_no_requests_in_progress(struct uds_index_session *index_session)
+{
+	uds_lock_mutex(&index_session->request_mutex);
+	while (index_session->request_count > 0)
+		uds_wait_cond(&index_session->request_cond, &index_session->request_mutex);
+	uds_unlock_mutex(&index_session->request_mutex);
+}
+
+static int __must_check save_index(struct uds_index_session *index_session)
+{
+	wait_for_no_requests_in_progress(index_session);
+	return uds_save_index(index_session->index);
+}
+
+static void suspend_rebuild(struct uds_index_session *session)
+{
+	uds_lock_mutex(&session->load_context.mutex);
+	switch (session->load_context.status) {
+	case INDEX_OPENING:
+		session->load_context.status = INDEX_SUSPENDING;
+
+		/* Wait until the index indicates that it is not replaying. */
+		while ((session->load_context.status != INDEX_SUSPENDED) &&
+		       (session->load_context.status != INDEX_READY))
+			uds_wait_cond(&session->load_context.cond,
+				      &session->load_context.mutex);
+		break;
+
+	case INDEX_READY:
+		/* Index load does not need to be suspended. */
+		break;
+
+	case INDEX_SUSPENDED:
+	case INDEX_SUSPENDING:
+	case INDEX_FREEING:
+	default:
+		/* These cases should not happen. */
+		ASSERT_LOG_ONLY(false, "Bad load context state %u", session->load_context.status);
+		break;
+	}
+	uds_unlock_mutex(&session->load_context.mutex);
+}
+
+/*
+ * Suspend index operation, draining all current index requests and preventing new index requests
+ * from starting. Optionally saves all index data before returning.
+ */
+int uds_suspend_index_session(struct uds_index_session *session, bool save)
+{
+	int result = UDS_SUCCESS;
+	bool no_work = false;
+	bool rebuilding = false;
+
+	/* Wait for any current index state change to complete. */
+	uds_lock_mutex(&session->request_mutex);
+	while (session->state & IS_FLAG_CLOSING)
+		uds_wait_cond(&session->request_cond, &session->request_mutex);
+
+	if ((session->state & IS_FLAG_WAITING) || (session->state & IS_FLAG_DESTROYING)) {
+		no_work = true;
+		uds_log_info("Index session is already changing state");
+		result = -EBUSY;
+	} else if (session->state & IS_FLAG_SUSPENDED) {
+		no_work = true;
+	} else if (session->state & IS_FLAG_LOADING) {
+		session->state |= IS_FLAG_WAITING;
+		rebuilding = true;
+	} else if (session->state & IS_FLAG_LOADED) {
+		session->state |= IS_FLAG_WAITING;
+	} else {
+		no_work = true;
+		session->state |= IS_FLAG_SUSPENDED;
+		uds_broadcast_cond(&session->request_cond);
+	}
+	uds_unlock_mutex(&session->request_mutex);
+
+	if (no_work)
+		return uds_map_to_system_error(result);
+
+	if (rebuilding)
+		suspend_rebuild(session);
+	else if (save)
+		result = save_index(session);
+	else
+		result = uds_flush_index_session(session);
+
+	uds_lock_mutex(&session->request_mutex);
+	session->state &= ~IS_FLAG_WAITING;
+	session->state |= IS_FLAG_SUSPENDED;
+	uds_broadcast_cond(&session->request_cond);
+	uds_unlock_mutex(&session->request_mutex);
+	return uds_map_to_system_error(result);
+}
+
+static int replace_device(struct uds_index_session *session, const char *name)
+{
+	int result;
+	char *new_name;
+
+	result = uds_duplicate_string(name, "device name", &new_name);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_replace_index_storage(session->index, name);
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(new_name);
+		return result;
+	}
+
+	uds_free_const(session->parameters.name);
+	session->parameters.name = new_name;
+	return UDS_SUCCESS;
+}
+
+/*
+ * Resume index operation after being suspended. If the index is suspended and the supplied name is
+ * different from the current backing store, the index will start using the new backing store.
+ */
+int uds_resume_index_session(struct uds_index_session *session, const char *name)
+{
+	int result = UDS_SUCCESS;
+	bool no_work = false;
+	bool resume_replay = false;
+
+	uds_lock_mutex(&session->request_mutex);
+	if (session->state & IS_FLAG_WAITING) {
+		uds_log_info("Index session is already changing state");
+		no_work = true;
+		result = -EBUSY;
+	} else if (!(session->state & IS_FLAG_SUSPENDED)) {
+		/* If not suspended, just succeed. */
+		no_work = true;
+		result = UDS_SUCCESS;
+	} else {
+		session->state |= IS_FLAG_WAITING;
+		if (session->state & IS_FLAG_LOADING)
+			resume_replay = true;
+	}
+	uds_unlock_mutex(&session->request_mutex);
+
+	if (no_work)
+		return result;
+
+	if ((name != NULL) && (session->index != NULL) &&
+	    (strcmp(name, session->parameters.name) != 0)) {
+		result = replace_device(session, name);
+		if (result != UDS_SUCCESS) {
+			uds_lock_mutex(&session->request_mutex);
+			session->state &= ~IS_FLAG_WAITING;
+			uds_broadcast_cond(&session->request_cond);
+			uds_unlock_mutex(&session->request_mutex);
+			return uds_map_to_system_error(result);
+		}
+	}
+
+	if (resume_replay) {
+		uds_lock_mutex(&session->load_context.mutex);
+		switch (session->load_context.status) {
+		case INDEX_SUSPENDED:
+			session->load_context.status = INDEX_OPENING;
+			/* Notify the index to start replaying again. */
+			uds_broadcast_cond(&session->load_context.cond);
+			break;
+
+		case INDEX_READY:
+			/* There is no index rebuild to resume. */
+			break;
+
+		case INDEX_OPENING:
+		case INDEX_SUSPENDING:
+		case INDEX_FREEING:
+		default:
+			/* These cases should not happen; do nothing. */
+			ASSERT_LOG_ONLY(false,
+					"Bad load context state %u",
+					session->load_context.status);
+			break;
+		}
+		uds_unlock_mutex(&session->load_context.mutex);
+	}
+
+	uds_lock_mutex(&session->request_mutex);
+	session->state &= ~IS_FLAG_WAITING;
+	session->state &= ~IS_FLAG_SUSPENDED;
+	uds_broadcast_cond(&session->request_cond);
+	uds_unlock_mutex(&session->request_mutex);
+	return UDS_SUCCESS;
+}
+
+static int save_and_free_index(struct uds_index_session *index_session)
+{
+	int result = UDS_SUCCESS;
+	bool suspended;
+	struct uds_index *index = index_session->index;
+
+	if (index == NULL)
+		return UDS_SUCCESS;
+
+	uds_lock_mutex(&index_session->request_mutex);
+	suspended = (index_session->state & IS_FLAG_SUSPENDED);
+	uds_unlock_mutex(&index_session->request_mutex);
+
+	if (!suspended) {
+		result = uds_save_index(index);
+		if (result != UDS_SUCCESS)
+			uds_log_warning_strerror(result, "ignoring error from save_index");
+	}
+	uds_free_index(index);
+	index_session->index = NULL;
+
+	/*
+	 * Reset all index state that happens to be in the index
+	 * session, so it doesn't affect any future index.
+	 */
+	uds_lock_mutex(&index_session->load_context.mutex);
+	index_session->load_context.status = INDEX_OPENING;
+	uds_unlock_mutex(&index_session->load_context.mutex);
+
+	uds_lock_mutex(&index_session->request_mutex);
+	/* Only the suspend bit will remain relevant. */
+	index_session->state &= IS_FLAG_SUSPENDED;
+	uds_unlock_mutex(&index_session->request_mutex);
+
+	return result;
+}
+
+/* Save and close the current index. */
+int uds_close_index(struct uds_index_session *index_session)
+{
+	int result = UDS_SUCCESS;
+
+	/* Wait for any current index state change to complete. */
+	uds_lock_mutex(&index_session->request_mutex);
+	while ((index_session->state & IS_FLAG_WAITING) ||
+	       (index_session->state & IS_FLAG_CLOSING))
+		uds_wait_cond(&index_session->request_cond, &index_session->request_mutex);
+
+	if (index_session->state & IS_FLAG_SUSPENDED) {
+		uds_log_info("Index session is suspended");
+		result = -EBUSY;
+	} else if ((index_session->state & IS_FLAG_DESTROYING) ||
+		   !(index_session->state & IS_FLAG_LOADED)) {
+		/* The index doesn't exist, hasn't finished loading, or is being destroyed. */
+		result = UDS_NO_INDEX;
+	} else {
+		index_session->state |= IS_FLAG_CLOSING;
+	}
+	uds_unlock_mutex(&index_session->request_mutex);
+	if (result != UDS_SUCCESS)
+		return uds_map_to_system_error(result);
+
+	uds_log_debug("Closing index");
+	wait_for_no_requests_in_progress(index_session);
+	result = save_and_free_index(index_session);
+	uds_log_debug("Closed index");
+
+	uds_lock_mutex(&index_session->request_mutex);
+	index_session->state &= ~IS_FLAG_CLOSING;
+	uds_broadcast_cond(&index_session->request_cond);
+	uds_unlock_mutex(&index_session->request_mutex);
+	return uds_map_to_system_error(result);
+}
+
+/* This will save and close an open index before destroying the session. */
+int uds_destroy_index_session(struct uds_index_session *index_session)
+{
+	int result;
+	bool load_pending = false;
+
+	uds_log_debug("Destroying index session");
+
+	/* Wait for any current index state change to complete. */
+	uds_lock_mutex(&index_session->request_mutex);
+	while ((index_session->state & IS_FLAG_WAITING) ||
+	       (index_session->state & IS_FLAG_CLOSING))
+		uds_wait_cond(&index_session->request_cond, &index_session->request_mutex);
+
+	if (index_session->state & IS_FLAG_DESTROYING) {
+		uds_unlock_mutex(&index_session->request_mutex);
+		uds_log_info("Index session is already closing");
+		return -EBUSY;
+	}
+
+	index_session->state |= IS_FLAG_DESTROYING;
+	load_pending = ((index_session->state & IS_FLAG_LOADING) &&
+			(index_session->state & IS_FLAG_SUSPENDED));
+	uds_unlock_mutex(&index_session->request_mutex);
+
+	if (load_pending) {
+		/* Tell the index to terminate the rebuild. */
+		uds_lock_mutex(&index_session->load_context.mutex);
+		if (index_session->load_context.status == INDEX_SUSPENDED) {
+			index_session->load_context.status = INDEX_FREEING;
+			uds_broadcast_cond(&index_session->load_context.cond);
+		}
+		uds_unlock_mutex(&index_session->load_context.mutex);
+
+		/* Wait until the load exits before proceeding. */
+		uds_lock_mutex(&index_session->request_mutex);
+		while (index_session->state & IS_FLAG_LOADING)
+			uds_wait_cond(&index_session->request_cond, &index_session->request_mutex);
+		uds_unlock_mutex(&index_session->request_mutex);
+	}
+
+	wait_for_no_requests_in_progress(index_session);
+	result = save_and_free_index(index_session);
+	uds_free_const(index_session->parameters.name);
+	uds_request_queue_finish(index_session->callback_queue);
+	index_session->callback_queue = NULL;
+	uds_destroy_cond(&index_session->load_context.cond);
+	uds_destroy_mutex(&index_session->load_context.mutex);
+	uds_destroy_cond(&index_session->request_cond);
+	uds_destroy_mutex(&index_session->request_mutex);
+	uds_log_debug("Destroyed index session");
+	UDS_FREE(index_session);
+	return uds_map_to_system_error(result);
+}
+
+/* Wait until all callbacks for index operations are complete. */
+int uds_flush_index_session(struct uds_index_session *index_session)
+{
+	wait_for_no_requests_in_progress(index_session);
+	uds_wait_for_idle_index(index_session->index);
+	return UDS_SUCCESS;
+}
+
+/*
+ * Return the most recent parameters used to open an index. The caller is responsible for freeing
+ * the returned structure.
+ */
+int uds_get_index_parameters(struct uds_index_session *index_session,
+			     struct uds_parameters **parameters)
+{
+	int result;
+	const char *name = index_session->parameters.name;
+
+	if (parameters == NULL) {
+		uds_log_error("received a NULL parameters pointer");
+		return -EINVAL;
+	}
+
+	if (name != NULL) {
+		char *name_copy = NULL;
+		size_t name_length = strlen(name) + 1;
+		struct uds_parameters *copy;
+
+		result = UDS_ALLOCATE_EXTENDED(struct uds_parameters,
+					       name_length,
+					       char,
+					       __func__,
+					       &copy);
+		if (result != UDS_SUCCESS)
+			return uds_map_to_system_error(result);
+
+		*copy = index_session->parameters;
+		name_copy = (char *) copy + sizeof(struct uds_parameters);
+		memcpy(name_copy, name, name_length);
+		copy->name = name_copy;
+		*parameters = copy;
+		return UDS_SUCCESS;
+	}
+
+	result = UDS_ALLOCATE(1, struct uds_parameters, __func__, parameters);
+	if (result == UDS_SUCCESS)
+		**parameters = index_session->parameters;
+
+	return uds_map_to_system_error(result);
+}
+
+/* Statistics collection is intended to be thread-safe. */
+static void
+collect_stats(const struct uds_index_session *index_session, struct uds_index_stats *stats)
+{
+	const struct session_stats *session_stats = &index_session->stats;
+
+	stats->current_time = ktime_to_seconds(current_time_ns(CLOCK_REALTIME));
+	stats->posts_found = READ_ONCE(session_stats->posts_found);
+	stats->in_memory_posts_found = READ_ONCE(session_stats->posts_found_open_chapter);
+	stats->dense_posts_found = READ_ONCE(session_stats->posts_found_dense);
+	stats->sparse_posts_found = READ_ONCE(session_stats->posts_found_sparse);
+	stats->posts_not_found = READ_ONCE(session_stats->posts_not_found);
+	stats->updates_found = READ_ONCE(session_stats->updates_found);
+	stats->updates_not_found = READ_ONCE(session_stats->updates_not_found);
+	stats->deletions_found = READ_ONCE(session_stats->deletions_found);
+	stats->deletions_not_found = READ_ONCE(session_stats->deletions_not_found);
+	stats->queries_found = READ_ONCE(session_stats->queries_found);
+	stats->queries_not_found = READ_ONCE(session_stats->queries_not_found);
+	stats->requests = READ_ONCE(session_stats->requests);
+}
+
+int uds_get_index_session_stats(struct uds_index_session *index_session,
+				struct uds_index_stats *stats)
+{
+	if (stats == NULL) {
+		uds_log_error("received a NULL index stats pointer");
+		return -EINVAL;
+	}
+
+	collect_stats(index_session, stats);
+	if (index_session->index != NULL) {
+		uds_get_index_stats(index_session->index, stats);
+	} else {
+		stats->entries_indexed = 0;
+		stats->memory_used = 0;
+		stats->collisions = 0;
+		stats->entries_discarded = 0;
+	}
+
+	return UDS_SUCCESS;
+}
diff --git a/drivers/md/dm-vdo/index-session.h b/drivers/md/dm-vdo/index-session.h
new file mode 100644
index 00000000000..77e91c16f9e
--- /dev/null
+++ b/drivers/md/dm-vdo/index-session.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_INDEX_SESSION_H
+#define UDS_INDEX_SESSION_H
+
+#include <linux/atomic.h>
+#include <linux/cache.h>
+
+#include "config.h"
+#include "uds-threads.h"
+#include "uds.h"
+
+/*
+ * The index session mediates all interactions with a UDS index. Once the index session is created,
+ * it can be used to open, close, suspend, or recreate an index. It implements the majority of the
+ * functions in the top-level UDS API.
+ *
+ * If any deduplication request fails due to an internal error, the index is marked disabled. It
+ * will not accept any further requests and can only be closed. Closing the index will clear the
+ * disabled flag, and the index can then be reopened and recovered using the same index session.
+ */
+
+struct __aligned(L1_CACHE_BYTES) session_stats {
+	/* Post requests that found an entry */
+	u64 posts_found;
+	/* Post requests found in the open chapter */
+	u64 posts_found_open_chapter;
+	/* Post requests found in the dense index */
+	u64 posts_found_dense;
+	/* Post requests found in the sparse index */
+	u64 posts_found_sparse;
+	/* Post requests that did not find an entry */
+	u64 posts_not_found;
+	/* Update requests that found an entry */
+	u64 updates_found;
+	/* Update requests that did not find an entry */
+	u64 updates_not_found;
+	/* Delete requests that found an entry */
+	u64 deletions_found;
+	/* Delete requests that did not find an entry */
+	u64 deletions_not_found;
+	/* Query requests that found an entry */
+	u64 queries_found;
+	/* Query requests that did not find an entry */
+	u64 queries_not_found;
+	/* Total number of requests */
+	u64 requests;
+};
+
+enum index_suspend_status {
+	/* An index load has started but the index is not ready for use. */
+	INDEX_OPENING = 0,
+	/* The index is able to handle requests. */
+	INDEX_READY,
+	/* The index is attempting to suspend a rebuild. */
+	INDEX_SUSPENDING,
+	/* An index rebuild has been suspended. */
+	INDEX_SUSPENDED,
+	/* An index rebuild is being stopped in order to shut down. */
+	INDEX_FREEING,
+};
+
+struct index_load_context {
+	struct mutex mutex;
+	struct cond_var cond;
+	enum index_suspend_status status;
+};
+
+struct uds_index_session {
+	unsigned int state;
+	struct uds_index *index;
+	struct uds_request_queue *callback_queue;
+	struct uds_parameters parameters;
+	struct index_load_context load_context;
+	struct mutex request_mutex;
+	struct cond_var request_cond;
+	int request_count;
+	struct session_stats stats;
+};
+
+#endif /* UDS_INDEX_SESSION_H */
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
new file mode 100644
index 00000000000..64442203d07
--- /dev/null
+++ b/drivers/md/dm-vdo/index.c
@@ -0,0 +1,1403 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+
+#include "index.h"
+
+#include "hash-utils.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "request-queue.h"
+#include "sparse-cache.h"
+
+static const u64 NO_LAST_SAVE = U64_MAX;
+
+/*
+ * When searching for deduplication records, the index first searches the volume index, and then
+ * searches the chapter index for the relevant chapter. If the chapter has been fully committed to
+ * storage, the chapter pages are loaded into the page cache. If the chapter has not yet been
+ * committed (either the open chapter or a recently closed one), the index searches the in-memory
+ * representation of the chapter. Finally, if the volume index does not find a record and the index
+ * is sparse, the index will search the sparse cache.
+ *
+ * The index send two kinds of messages to coordinate between zones: chapter close messages for the
+ * chapter writer, and sparse cache barrier messages for the sparse cache.
+ *
+ * The chapter writer is responsible for committing chapters of records to storage. Since zones can
+ * get different numbers of records, some zones may fall behind others. Each time a zone fills up
+ * its available space in a chapter, it informs the chapter writer that the chapter is complete,
+ * and also informs all other zones that it has closed the chapter. Each other zone will then close
+ * the chapter immediately, regardless of how full it is, in order to minimize skew between zones.
+ * Once every zone has closed the chapter, the chapter writer will commit that chapter to storage.
+ *
+ * The last zone to close the chapter also removes the oldest chapter from the volume index.
+ * Although that chapter is invalid for zones that have moved on, the existence of the open chapter
+ * means that those zones will never ask the volume index about it. No zone is allowed to get more
+ * than one chapter ahead of any other. If a zone is so far ahead that it tries to close another
+ * chapter before the previous one has been closed by all zones, it is forced to wait.
+ *
+ * The sparse cache relies on having the same set of chapter indexes available to all zones. When a
+ * request wants to add a chapter to the sparse cache, it sends a barrier message to each zone
+ * during the triage stage that acts as a rendezvous. Once every zone has reached the barrier and
+ * paused its operations, the cache membership is changed and each zone is then informed that it
+ * can proceed. More details can be found in the sparse cache documentation.
+ *
+ * If a sparse cache has only one zone, it will not create a triage queue, but it still needs the
+ * barrier message to change the sparse cache membership, so the index simulates the message by
+ * invoking the handler directly.
+ */
+
+struct chapter_writer {
+	/* The index to which we belong */
+	struct uds_index *index;
+	/* The thread to do the writing */
+	struct thread *thread;
+	/* The lock protecting the following fields */
+	struct mutex mutex;
+	/* The condition signalled on state changes */
+	struct cond_var cond;
+	/* Set to true to stop the thread */
+	bool stop;
+	/* The result from the most recent write */
+	int result;
+	/* The number of bytes allocated by the chapter writer */
+	size_t memory_size;
+	/* The number of zones which have submitted a chapter for writing */
+	unsigned int zones_to_write;
+	/* Open chapter index used by uds_close_open_chapter() */
+	struct open_chapter_index *open_chapter_index;
+	/* Collated records used by uds_close_open_chapter() */
+	struct uds_volume_record *collated_records;
+	/* The chapters to write (one per zone) */
+	struct open_chapter_zone *chapters[];
+};
+
+static bool is_zone_chapter_sparse(const struct index_zone *zone, u64 virtual_chapter)
+{
+	return uds_is_chapter_sparse(zone->index->volume->geometry,
+				     zone->oldest_virtual_chapter,
+				     zone->newest_virtual_chapter,
+				     virtual_chapter);
+}
+
+static int
+launch_zone_message(struct uds_zone_message message, unsigned int zone, struct uds_index *index)
+{
+	int result;
+	struct uds_request *request;
+
+	result = UDS_ALLOCATE(1, struct uds_request, __func__, &request);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	request->index = index;
+	request->unbatched = true;
+	request->zone_number = zone;
+	request->zone_message = message;
+
+	uds_enqueue_request(request, STAGE_MESSAGE);
+	return UDS_SUCCESS;
+}
+
+static void enqueue_barrier_messages(struct uds_index *index, u64 virtual_chapter)
+{
+	struct uds_zone_message message = {
+		.type = UDS_MESSAGE_SPARSE_CACHE_BARRIER,
+		.virtual_chapter = virtual_chapter,
+	};
+	unsigned int zone;
+
+	for (zone = 0; zone < index->zone_count; zone++) {
+		int result = launch_zone_message(message, zone, index);
+
+		ASSERT_LOG_ONLY((result == UDS_SUCCESS), "barrier message allocation");
+	}
+}
+
+/*
+ * Determine whether this request should trigger a sparse cache barrier message to change the
+ * membership of the sparse cache. If a change in membership is desired, the function returns the
+ * chapter number to add.
+ */
+static u64 triage_index_request(struct uds_index *index, struct uds_request *request)
+{
+	u64 virtual_chapter;
+	struct index_zone *zone;
+
+	virtual_chapter = uds_lookup_volume_index_name(index->volume_index, &request->record_name);
+	if (virtual_chapter == NO_CHAPTER)
+		return NO_CHAPTER;
+
+	zone = index->zones[request->zone_number];
+	if (!is_zone_chapter_sparse(zone, virtual_chapter))
+		return NO_CHAPTER;
+
+	/*
+	 * FIXME: Optimize for a common case by remembering the chapter from the most recent
+	 * barrier message and skipping this chapter if is it the same.
+	 */
+
+	return virtual_chapter;
+}
+
+/*
+ * Simulate a message to change the sparse cache membership for a single-zone sparse index. This
+ * allows us to forgo the complicated locking required by a multi-zone sparse index. Any other kind
+ * of index does nothing here.
+ */
+static int
+simulate_index_zone_barrier_message(struct index_zone *zone, struct uds_request *request)
+{
+	u64 sparse_virtual_chapter;
+
+	if ((zone->index->zone_count > 1) ||
+	    !uds_is_sparse_geometry(zone->index->volume->geometry))
+		return UDS_SUCCESS;
+
+	sparse_virtual_chapter = triage_index_request(zone->index, request);
+	if (sparse_virtual_chapter == NO_CHAPTER)
+		return UDS_SUCCESS;
+
+	return uds_update_sparse_cache(zone, sparse_virtual_chapter);
+}
+
+/* This is the request processing function for the triage queue. */
+static void triage_request(struct uds_request *request)
+{
+	struct uds_index *index = request->index;
+	u64 sparse_virtual_chapter = triage_index_request(index, request);
+
+	if (sparse_virtual_chapter != NO_CHAPTER)
+		enqueue_barrier_messages(index, sparse_virtual_chapter);
+
+	uds_enqueue_request(request, STAGE_INDEX);
+}
+
+static int finish_previous_chapter(struct uds_index *index, u64 current_chapter_number)
+{
+	int result;
+	struct chapter_writer *writer = index->chapter_writer;
+
+	uds_lock_mutex(&writer->mutex);
+	while (index->newest_virtual_chapter < current_chapter_number)
+		uds_wait_cond(&writer->cond, &writer->mutex);
+	result = writer->result;
+	uds_unlock_mutex(&writer->mutex);
+
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result, "Writing of previous open chapter failed");
+
+	return UDS_SUCCESS;
+}
+
+static int swap_open_chapter(struct index_zone *zone)
+{
+	int result;
+	struct open_chapter_zone *temporary_chapter;
+
+	result = finish_previous_chapter(zone->index, zone->newest_virtual_chapter);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	temporary_chapter = zone->open_chapter;
+	zone->open_chapter = zone->writing_chapter;
+	zone->writing_chapter = temporary_chapter;
+	return UDS_SUCCESS;
+}
+
+/*
+ * Inform the chapter writer that this zone is done with this chapter. The chapter won't start
+ * writing until all zones have closed it.
+ */
+static unsigned int start_closing_chapter(struct uds_index *index,
+					  unsigned int zone_number,
+					  struct open_chapter_zone *chapter)
+{
+	unsigned int finished_zones;
+	struct chapter_writer *writer = index->chapter_writer;
+
+	uds_lock_mutex(&writer->mutex);
+	finished_zones = ++writer->zones_to_write;
+	writer->chapters[zone_number] = chapter;
+	uds_broadcast_cond(&writer->cond);
+	uds_unlock_mutex(&writer->mutex);
+
+	return finished_zones;
+}
+
+static int announce_chapter_closed(struct index_zone *zone, u64 closed_chapter)
+{
+	int result;
+	unsigned int i;
+	struct uds_zone_message zone_message = {
+		.type = UDS_MESSAGE_ANNOUNCE_CHAPTER_CLOSED,
+		.virtual_chapter = closed_chapter,
+	};
+
+	for (i = 0; i < zone->index->zone_count; i++) {
+		if (zone->id == i)
+			continue;
+
+		result = launch_zone_message(zone_message, i, zone->index);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	return UDS_SUCCESS;
+}
+
+static int open_next_chapter(struct index_zone *zone)
+{
+	int result;
+	u64 closed_chapter;
+	u64 expiring;
+	unsigned int finished_zones;
+	u32 expire_chapters;
+
+	uds_log_debug("closing chapter %llu of zone %u after %u entries (%u short)",
+		      (unsigned long long) zone->newest_virtual_chapter,
+		      zone->id,
+		      zone->open_chapter->size,
+		      zone->open_chapter->capacity - zone->open_chapter->size);
+
+	result = swap_open_chapter(zone);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	closed_chapter = zone->newest_virtual_chapter++;
+	uds_set_volume_index_zone_open_chapter(zone->index->volume_index,
+					       zone->id,
+					       zone->newest_virtual_chapter);
+	uds_reset_open_chapter(zone->open_chapter);
+
+	finished_zones = start_closing_chapter(zone->index, zone->id, zone->writing_chapter);
+	if ((finished_zones == 1) && (zone->index->zone_count > 1)) {
+		result = announce_chapter_closed(zone, closed_chapter);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	expiring = zone->oldest_virtual_chapter;
+	expire_chapters = uds_chapters_to_expire(zone->index->volume->geometry,
+						 zone->newest_virtual_chapter);
+	zone->oldest_virtual_chapter += expire_chapters;
+
+	if (finished_zones < zone->index->zone_count)
+		return UDS_SUCCESS;
+
+	while (expire_chapters-- > 0)
+		uds_forget_chapter(zone->index->volume, expiring++);
+
+	return UDS_SUCCESS;
+}
+
+static int handle_chapter_closed(struct index_zone *zone, u64 virtual_chapter)
+{
+	if (zone->newest_virtual_chapter == virtual_chapter)
+		return open_next_chapter(zone);
+
+	return UDS_SUCCESS;
+}
+
+static int dispatch_index_zone_control_request(struct uds_request *request)
+{
+	struct uds_zone_message *message = &request->zone_message;
+	struct index_zone *zone = request->index->zones[request->zone_number];
+
+	switch (message->type) {
+	case UDS_MESSAGE_SPARSE_CACHE_BARRIER:
+		return uds_update_sparse_cache(zone, message->virtual_chapter);
+
+	case UDS_MESSAGE_ANNOUNCE_CHAPTER_CLOSED:
+		return handle_chapter_closed(zone, message->virtual_chapter);
+
+	default:
+		uds_log_error("invalid message type: %d", message->type);
+		return UDS_INVALID_ARGUMENT;
+	}
+}
+
+static void set_request_location(struct uds_request *request, enum uds_index_region new_location)
+{
+	request->location = new_location;
+	request->found = ((new_location == UDS_LOCATION_IN_OPEN_CHAPTER) ||
+			  (new_location == UDS_LOCATION_IN_DENSE) ||
+			  (new_location == UDS_LOCATION_IN_SPARSE));
+}
+
+static void set_chapter_location(struct uds_request *request,
+				 const struct index_zone *zone,
+				 u64 virtual_chapter)
+{
+	request->found = true;
+	if (virtual_chapter == zone->newest_virtual_chapter)
+		request->location = UDS_LOCATION_IN_OPEN_CHAPTER;
+	else if (is_zone_chapter_sparse(zone, virtual_chapter))
+		request->location = UDS_LOCATION_IN_SPARSE;
+	else
+		request->location = UDS_LOCATION_IN_DENSE;
+}
+
+static int search_sparse_cache_in_zone(struct index_zone *zone,
+				       struct uds_request *request,
+				       u64 virtual_chapter,
+				       bool *found)
+{
+	int result;
+	struct volume *volume;
+	u16 record_page_number;
+	u32 chapter;
+
+	result = uds_search_sparse_cache(zone,
+					 &request->record_name,
+					 &virtual_chapter,
+					 &record_page_number);
+	if ((result != UDS_SUCCESS) || (virtual_chapter == NO_CHAPTER))
+		return result;
+
+	request->virtual_chapter = virtual_chapter;
+	volume = zone->index->volume;
+	chapter = uds_map_to_physical_chapter(volume->geometry, virtual_chapter);
+	return uds_search_cached_record_page(volume, request, chapter, record_page_number, found);
+}
+
+static int get_record_from_zone(struct index_zone *zone, struct uds_request *request, bool *found)
+{
+	struct volume *volume;
+
+	if (request->location == UDS_LOCATION_RECORD_PAGE_LOOKUP) {
+		*found = true;
+		return UDS_SUCCESS;
+	} else if (request->location == UDS_LOCATION_UNAVAILABLE) {
+		*found = false;
+		return UDS_SUCCESS;
+	}
+
+	if (request->virtual_chapter == zone->newest_virtual_chapter) {
+		uds_search_open_chapter(zone->open_chapter,
+					&request->record_name,
+					&request->old_metadata,
+					found);
+		return UDS_SUCCESS;
+	}
+
+	if ((zone->newest_virtual_chapter > 0) &&
+	    (request->virtual_chapter == (zone->newest_virtual_chapter - 1)) &&
+	    (zone->writing_chapter->size > 0)) {
+		uds_search_open_chapter(zone->writing_chapter,
+					&request->record_name,
+					&request->old_metadata,
+					found);
+		return UDS_SUCCESS;
+	}
+
+	volume = zone->index->volume;
+	if (is_zone_chapter_sparse(zone, request->virtual_chapter) &&
+	    uds_sparse_cache_contains(volume->sparse_cache,
+				      request->virtual_chapter,
+				      request->zone_number))
+		return search_sparse_cache_in_zone(zone, request, request->virtual_chapter, found);
+
+	return uds_search_volume_page_cache(volume, request, found);
+}
+
+static int put_record_in_zone(struct index_zone *zone,
+			      struct uds_request *request,
+			      const struct uds_record_data *metadata)
+{
+	unsigned int remaining;
+
+	remaining = uds_put_open_chapter(zone->open_chapter, &request->record_name, metadata);
+	if (remaining == 0)
+		return open_next_chapter(zone);
+
+	return UDS_SUCCESS;
+}
+
+static int search_index_zone(struct index_zone *zone, struct uds_request *request)
+{
+	int result;
+	struct volume_index_record record;
+	bool overflow_record, found = false;
+	struct uds_record_data *metadata;
+	u64 chapter;
+
+	result = uds_get_volume_index_record(zone->index->volume_index,
+					     &request->record_name,
+					     &record);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (record.is_found) {
+		if (request->requeued && request->virtual_chapter != record.virtual_chapter)
+			set_request_location(request, UDS_LOCATION_UNKNOWN);
+
+		request->virtual_chapter = record.virtual_chapter;
+		result = get_record_from_zone(zone, request, &found);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	if (found)
+		set_chapter_location(request, zone, record.virtual_chapter);
+
+	/*
+	 * If a record has overflowed a chapter index in more than one chapter (or overflowed in
+	 * one chapter and collided with an existing record), it will exist as a collision record
+	 * in the volume index, but we won't find it in the volume. This case needs special
+	 * handling.
+	 */
+	overflow_record = (record.is_found && record.is_collision && !found);
+	chapter = zone->newest_virtual_chapter;
+	if (found || overflow_record) {
+		if ((request->type == UDS_QUERY_NO_UPDATE) ||
+		    ((request->type == UDS_QUERY) && overflow_record))
+			/* There is nothing left to do. */
+			return UDS_SUCCESS;
+
+		if (record.virtual_chapter != chapter)
+			/*
+			 * Update the volume index to reference the new chapter for the block. If
+			 * the record had been deleted or dropped from the chapter index, it will
+			 * be back.
+			 */
+			result = uds_set_volume_index_record_chapter(&record, chapter);
+		else if (request->type != UDS_UPDATE)
+			/* The record is already in the open chapter. */
+			return UDS_SUCCESS;
+	} else {
+		/*
+		 * The record wasn't in the volume index, so check whether the
+		 * name is in a cached sparse chapter. If we found the name on
+		 * a previous search, use that result instead.
+		 */
+		if (request->location == UDS_LOCATION_RECORD_PAGE_LOOKUP) {
+			found = true;
+		} else if (request->location == UDS_LOCATION_UNAVAILABLE) {
+			found = false;
+		} else if (uds_is_sparse_geometry(zone->index->volume->geometry) &&
+			   !uds_is_volume_index_sample(zone->index->volume_index,
+						       &request->record_name)) {
+			result = search_sparse_cache_in_zone(zone, request, NO_CHAPTER, &found);
+			if (result != UDS_SUCCESS)
+				return result;
+		}
+
+		if (found)
+			set_request_location(request, UDS_LOCATION_IN_SPARSE);
+
+		if ((request->type == UDS_QUERY_NO_UPDATE) ||
+		    ((request->type == UDS_QUERY) && !found))
+			/* There is nothing left to do. */
+			return UDS_SUCCESS;
+
+		/*
+		 * Add a new entry to the volume index referencing the open chapter. This needs to
+		 * be done both for new records, and for records from cached sparse chapters.
+		 */
+		result = uds_put_volume_index_record(&record, chapter);
+	}
+
+	if (result == UDS_OVERFLOW)
+		/*
+		 * The volume index encountered a delta list overflow. The condition was already
+		 * logged. We will go on without adding the record to the open chapter.
+		 */
+		return UDS_SUCCESS;
+
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (!found || (request->type == UDS_UPDATE))
+		/* This is a new record or we're updating an existing record. */
+		metadata = &request->new_metadata;
+	else
+		/* Move the existing record to the open chapter. */
+		metadata = &request->old_metadata;
+
+	return put_record_in_zone(zone, request, metadata);
+}
+
+static int remove_from_index_zone(struct index_zone *zone, struct uds_request *request)
+{
+	int result;
+	struct volume_index_record record;
+
+	result = uds_get_volume_index_record(zone->index->volume_index,
+					     &request->record_name,
+					     &record);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (!record.is_found)
+		return UDS_SUCCESS;
+
+	/* If the request was requeued, check whether the saved state is still valid. */
+
+	if (record.is_collision) {
+		set_chapter_location(request, zone, record.virtual_chapter);
+	} else {
+		/* Non-collision records are hints, so resolve the name in the chapter. */
+		bool found;
+
+		if (request->requeued && request->virtual_chapter != record.virtual_chapter)
+			set_request_location(request, UDS_LOCATION_UNKNOWN);
+
+		request->virtual_chapter = record.virtual_chapter;
+		result = get_record_from_zone(zone, request, &found);
+		if (result != UDS_SUCCESS)
+			return result;
+
+		if (!found)
+			/* There is no record to remove. */
+			return UDS_SUCCESS;
+	}
+
+	set_chapter_location(request, zone, record.virtual_chapter);
+
+	/*
+	 * Delete the volume index entry for the named record only. Note that a later search might
+	 * later return stale advice if there is a colliding name in the same chapter, but it's a
+	 * very rare case (1 in 2^21).
+	 */
+	result = uds_remove_volume_index_record(&record);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	/*
+	 * If the record is in the open chapter, we must remove it or mark it deleted to avoid
+	 * trouble if the record is added again later.
+	 */
+	if (request->location == UDS_LOCATION_IN_OPEN_CHAPTER)
+		uds_remove_from_open_chapter(zone->open_chapter, &request->record_name);
+
+	return UDS_SUCCESS;
+}
+
+static int dispatch_index_request(struct uds_index *index, struct uds_request *request)
+{
+	int result;
+	struct index_zone *zone = index->zones[request->zone_number];
+
+	if (!request->requeued) {
+		result = simulate_index_zone_barrier_message(zone, request);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	switch (request->type) {
+	case UDS_POST:
+	case UDS_UPDATE:
+	case UDS_QUERY:
+	case UDS_QUERY_NO_UPDATE:
+		result = search_index_zone(zone, request);
+		break;
+
+	case UDS_DELETE:
+		result = remove_from_index_zone(zone, request);
+		break;
+
+	default:
+		result = uds_log_warning_strerror(UDS_INVALID_ARGUMENT,
+						  "invalid request type: %d",
+						  request->type);
+		break;
+	}
+
+	return result;
+}
+
+/* This is the request processing function invoked by each zone's thread. */
+static void execute_zone_request(struct uds_request *request)
+{
+	int result;
+	struct uds_index *index = request->index;
+
+	if (request->zone_message.type != UDS_MESSAGE_NONE) {
+		result = dispatch_index_zone_control_request(request);
+		if (result != UDS_SUCCESS)
+			uds_log_error_strerror(result,
+					       "error executing message: %d",
+					       request->zone_message.type);
+
+		/* Once the message is processed it can be freed. */
+		UDS_FREE(UDS_FORGET(request));
+		return;
+	}
+
+	index->need_to_save = true;
+	if (request->requeued && (request->status != UDS_SUCCESS)) {
+		set_request_location(request, UDS_LOCATION_UNAVAILABLE);
+		index->callback(request);
+		return;
+	}
+
+	result = dispatch_index_request(index, request);
+	if (result == UDS_QUEUED)
+		/* The request has been requeued so don't let it complete. */
+		return;
+
+	if (!request->found)
+		set_request_location(request, UDS_LOCATION_UNAVAILABLE);
+
+	request->status = result;
+	index->callback(request);
+}
+
+static int initialize_index_queues(struct uds_index *index, const struct geometry *geometry)
+{
+	int result;
+	unsigned int i;
+
+	for (i = 0; i < index->zone_count; i++) {
+		result = uds_make_request_queue("indexW",
+						&execute_zone_request,
+						&index->zone_queues[i]);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	/* The triage queue is only needed for sparse multi-zone indexes. */
+	if ((index->zone_count > 1) && uds_is_sparse_geometry(geometry)) {
+		result = uds_make_request_queue("triageW", &triage_request, &index->triage_queue);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	return UDS_SUCCESS;
+}
+
+/* This is the driver function for the chapter writer thread. */
+static void close_chapters(void *arg)
+{
+	int result;
+	struct chapter_writer *writer = arg;
+	struct uds_index *index = writer->index;
+
+	uds_log_debug("chapter writer starting");
+	uds_lock_mutex(&writer->mutex);
+	for (;;) {
+		while (writer->zones_to_write < index->zone_count) {
+			if (writer->stop && (writer->zones_to_write == 0)) {
+				/*
+				 * We've been told to stop, and all of the zones are in the same
+				 * open chapter, so we can exit now.
+				 */
+				uds_unlock_mutex(&writer->mutex);
+				uds_log_debug("chapter writer stopping");
+				return;
+			}
+			uds_wait_cond(&writer->cond, &writer->mutex);
+		}
+
+		/*
+		 * Release the lock while closing a chapter. We probably don't need to do this, but
+		 * it seems safer in principle. It's OK to access the chapter and chapter_number
+		 * fields without the lock since those aren't allowed to change until we're done.
+		 */
+		uds_unlock_mutex(&writer->mutex);
+
+		if (index->has_saved_open_chapter) {
+			/*
+			 * Remove the saved open chapter the first time we close an open chapter
+			 * after loading from a clean shutdown, or after doing a clean save. The
+			 * lack of the saved open chapter will indicate that a recovery is
+			 * necessary.
+			 */
+			index->has_saved_open_chapter = false;
+			result = uds_discard_open_chapter(index->layout);
+			if (result == UDS_SUCCESS)
+				uds_log_debug("Discarding saved open chapter");
+		}
+
+		result = uds_close_open_chapter(writer->chapters,
+						index->zone_count,
+						index->volume,
+						writer->open_chapter_index,
+						writer->collated_records,
+						index->newest_virtual_chapter);
+
+		uds_lock_mutex(&writer->mutex);
+		index->newest_virtual_chapter++;
+		index->oldest_virtual_chapter +=
+			uds_chapters_to_expire(index->volume->geometry,
+					       index->newest_virtual_chapter);
+		writer->result = result;
+		writer->zones_to_write = 0;
+		uds_broadcast_cond(&writer->cond);
+	}
+}
+
+static void stop_chapter_writer(struct chapter_writer *writer)
+{
+	struct thread *writer_thread = 0;
+
+	uds_lock_mutex(&writer->mutex);
+	if (writer->thread != 0) {
+		writer_thread = writer->thread;
+		writer->thread = 0;
+		writer->stop = true;
+		uds_broadcast_cond(&writer->cond);
+	}
+	uds_unlock_mutex(&writer->mutex);
+
+	if (writer_thread != 0)
+		uds_join_threads(writer_thread);
+}
+
+static void free_chapter_writer(struct chapter_writer *writer)
+{
+	if (writer == NULL)
+		return;
+
+	stop_chapter_writer(writer);
+	uds_destroy_mutex(&writer->mutex);
+	uds_destroy_cond(&writer->cond);
+	uds_free_open_chapter_index(writer->open_chapter_index);
+	UDS_FREE(writer->collated_records);
+	UDS_FREE(writer);
+}
+
+static int make_chapter_writer(struct uds_index *index, struct chapter_writer **writer_ptr)
+{
+	int result;
+	struct chapter_writer *writer;
+	size_t collated_records_size =
+		(sizeof(struct uds_volume_record) * index->volume->geometry->records_per_chapter);
+
+	result = UDS_ALLOCATE_EXTENDED(struct chapter_writer,
+				       index->zone_count,
+				       struct open_chapter_zone *,
+				       "Chapter Writer",
+				       &writer);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	writer->index = index;
+	result = uds_init_mutex(&writer->mutex);
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(writer);
+		return result;
+	}
+
+	result = uds_init_cond(&writer->cond);
+	if (result != UDS_SUCCESS) {
+		uds_destroy_mutex(&writer->mutex);
+		UDS_FREE(writer);
+		return result;
+	}
+
+	result = uds_allocate_cache_aligned(collated_records_size,
+					    "collated records",
+					    &writer->collated_records);
+	if (result != UDS_SUCCESS) {
+		free_chapter_writer(writer);
+		return result;
+	}
+
+	result = uds_make_open_chapter_index(&writer->open_chapter_index,
+					     index->volume->geometry,
+					     index->volume->nonce);
+	if (result != UDS_SUCCESS) {
+		free_chapter_writer(writer);
+		return result;
+	}
+
+	writer->memory_size = (sizeof(struct chapter_writer) +
+			       index->zone_count * sizeof(struct open_chapter_zone *) +
+			       collated_records_size +
+			       writer->open_chapter_index->memory_size);
+
+	result = uds_create_thread(close_chapters, writer, "writer", &writer->thread);
+	if (result != UDS_SUCCESS) {
+		free_chapter_writer(writer);
+		return result;
+	}
+
+	*writer_ptr = writer;
+	return UDS_SUCCESS;
+}
+
+static int load_index(struct uds_index *index)
+{
+	int result;
+	u64 last_save_chapter;
+
+	result = uds_load_index_state(index->layout, index);
+	if (result != UDS_SUCCESS)
+		return UDS_INDEX_NOT_SAVED_CLEANLY;
+
+	last_save_chapter = ((index->last_save != NO_LAST_SAVE) ? index->last_save : 0);
+
+	uds_log_info("loaded index from chapter %llu through chapter %llu",
+		     (unsigned long long) index->oldest_virtual_chapter,
+		     (unsigned long long) last_save_chapter);
+
+	return UDS_SUCCESS;
+}
+
+static int rebuild_index_page_map(struct uds_index *index, u64 vcn)
+{
+	int result;
+	struct delta_index_page *chapter_index_page;
+	struct geometry *geometry = index->volume->geometry;
+	u32 chapter = uds_map_to_physical_chapter(geometry, vcn);
+	u32 expected_list_number = 0;
+	u32 index_page_number;
+	u32 lowest_delta_list;
+	u32 highest_delta_list;
+
+	for (index_page_number = 0;
+	     index_page_number < geometry->index_pages_per_chapter;
+	     index_page_number++) {
+		result = uds_get_volume_index_page(index->volume,
+						   chapter,
+						   index_page_number,
+						   &chapter_index_page);
+		if (result != UDS_SUCCESS)
+			return uds_log_error_strerror(result,
+						      "failed to read index page %u in chapter %u",
+						      index_page_number,
+						      chapter);
+
+		lowest_delta_list = chapter_index_page->lowest_list_number;
+		highest_delta_list = chapter_index_page->highest_list_number;
+		if (lowest_delta_list != expected_list_number)
+			return uds_log_error_strerror(UDS_CORRUPT_DATA,
+						      "chapter %u index page %u is corrupt",
+						      chapter,
+						      index_page_number);
+
+		uds_update_index_page_map(index->volume->index_page_map,
+					  vcn,
+					  chapter,
+					  index_page_number,
+					  highest_delta_list);
+		expected_list_number = highest_delta_list + 1;
+	}
+
+	return UDS_SUCCESS;
+}
+
+static int replay_record(struct uds_index *index,
+			 const struct uds_record_name *name,
+			 u64 virtual_chapter,
+			 bool will_be_sparse_chapter)
+{
+	int result;
+	struct volume_index_record record;
+	bool update_record;
+
+	if (will_be_sparse_chapter && !uds_is_volume_index_sample(index->volume_index, name))
+		/*
+		 * This entry will be in a sparse chapter after the rebuild completes, and it is
+		 * not a sample, so just skip over it.
+		 */
+		return UDS_SUCCESS;
+
+	result = uds_get_volume_index_record(index->volume_index, name, &record);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (record.is_found) {
+		if (record.is_collision) {
+			if (record.virtual_chapter == virtual_chapter)
+				/* The record is already correct. */
+				return UDS_SUCCESS;
+
+			update_record = true;
+		} else if (record.virtual_chapter == virtual_chapter) {
+			/*
+			 * There is a volume index entry pointing to the current chapter, but we
+			 * don't know if it is for the same name as the one we are currently
+			 * working on or not. For now, we're just going to assume that it isn't.
+			 * This will create one extra collision record if there was a deleted
+			 * record in the current chapter.
+			 */
+			update_record = false;
+		} else {
+			/*
+			 * If we're rebuilding, we don't normally want to go to disk to see if the
+			 * record exists, since we will likely have just read the record from disk
+			 * (i.e. we know it's there). The exception to this is when we find an
+			 * entry in the volume index that has a different chapter. In this case, we
+			 * need to search that chapter to determine if the volume index entry was
+			 * for the same record or a different one.
+			 */
+			result = uds_search_volume_page_cache_for_rebuild(index->volume,
+									  name,
+									  record.virtual_chapter,
+									  &update_record);
+			if (result != UDS_SUCCESS)
+				return result;
+			}
+	} else {
+		update_record = false;
+	}
+
+	if (update_record)
+		/*
+		 * Update the volume index to reference the new chapter for the block. If the
+		 * record had been deleted or dropped from the chapter index, it will be back.
+		 */
+		result = uds_set_volume_index_record_chapter(&record, virtual_chapter);
+	else
+		/*
+		 * Add a new entry to the volume index referencing the open chapter. This should be
+		 * done regardless of whether we are a brand new record or a sparse record, i.e.
+		 * one that doesn't exist in the index but does on disk, since for a sparse record,
+		 * we would want to un-sparsify if it did exist.
+		 */
+		result = uds_put_volume_index_record(&record, virtual_chapter);
+
+	if ((result == UDS_DUPLICATE_NAME) || (result == UDS_OVERFLOW))
+		/* The rebuilt index will lose these records. */
+		return UDS_SUCCESS;
+
+	return result;
+}
+
+static bool check_for_suspend(struct uds_index *index)
+{
+	bool closing;
+
+	if (index->load_context == NULL)
+		return false;
+
+	uds_lock_mutex(&index->load_context->mutex);
+	if (index->load_context->status != INDEX_SUSPENDING) {
+		uds_unlock_mutex(&index->load_context->mutex);
+		return false;
+	}
+
+	/* Notify that we are suspended and wait for the resume. */
+	index->load_context->status = INDEX_SUSPENDED;
+	uds_broadcast_cond(&index->load_context->cond);
+
+	while ((index->load_context->status != INDEX_OPENING) &&
+	       (index->load_context->status != INDEX_FREEING))
+		uds_wait_cond(&index->load_context->cond, &index->load_context->mutex);
+
+	closing = (index->load_context->status == INDEX_FREEING);
+	uds_unlock_mutex(&index->load_context->mutex);
+	return closing;
+}
+
+static int replay_chapter(struct uds_index *index, u64 virtual, bool sparse)
+{
+	int result;
+	u32 i;
+	u32 j;
+	const struct geometry *geometry;
+	u32 physical_chapter;
+
+	if (check_for_suspend(index)) {
+		uds_log_info("Replay interrupted by index shutdown at chapter %llu",
+			     (unsigned long long) virtual);
+		return -EBUSY;
+	}
+
+	geometry = index->volume->geometry;
+	physical_chapter = uds_map_to_physical_chapter(geometry, virtual);
+	uds_prefetch_volume_chapter(index->volume, physical_chapter);
+	uds_set_volume_index_open_chapter(index->volume_index, virtual);
+
+	result = rebuild_index_page_map(index, virtual);
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result,
+					      "could not rebuild index page map for chapter %u",
+					      physical_chapter);
+
+	for (i = 0; i < geometry->record_pages_per_chapter; i++) {
+		u8 *record_page;
+		u32 record_page_number;
+
+		record_page_number = geometry->index_pages_per_chapter + i;
+		result = uds_get_volume_record_page(index->volume,
+						    physical_chapter,
+						    record_page_number,
+						    &record_page);
+		if (result != UDS_SUCCESS)
+			return uds_log_error_strerror(result,
+						      "could not get page %d",
+						      record_page_number);
+
+		for (j = 0; j < geometry->records_per_page; j++) {
+			const u8 *name_bytes;
+			struct uds_record_name name;
+
+			name_bytes = record_page + (j * BYTES_PER_RECORD);
+			memcpy(&name.name, name_bytes, UDS_RECORD_NAME_SIZE);
+			result = replay_record(index, &name, virtual, sparse);
+			if (result != UDS_SUCCESS)
+				return result;
+		}
+	}
+
+	return UDS_SUCCESS;
+}
+
+static int replay_volume(struct uds_index *index)
+{
+	int result;
+	u64 old_map_update;
+	u64 new_map_update;
+	u64 virtual;
+	u64 from_virtual = index->oldest_virtual_chapter;
+	u64 upto_virtual = index->newest_virtual_chapter;
+	bool will_be_sparse;
+
+	uds_log_info("Replaying volume from chapter %llu through chapter %llu",
+		     (unsigned long long) from_virtual,
+		     (unsigned long long) upto_virtual);
+
+	/*
+	 * The index failed to load, so the volume index is empty. Add records to the volume index
+	 * in order, skipping non-hooks in chapters which will be sparse to save time.
+	 *
+	 * Go through each record page of each chapter and add the records back to the volume
+	 * index. This should not cause anything to be written to either the open chapter or the
+	 * on-disk volume. Also skip the on-disk chapter corresponding to upto_virtual, as this
+	 * would have already been purged from the volume index when the chapter was opened.
+	 *
+	 * Also, go through each index page for each chapter and rebuild the index page map.
+	 */
+	old_map_update = index->volume->index_page_map->last_update;
+	for (virtual = from_virtual; virtual < upto_virtual; ++virtual) {
+		will_be_sparse = uds_is_chapter_sparse(index->volume->geometry,
+						       from_virtual,
+						       upto_virtual,
+						       virtual);
+		result = replay_chapter(index, virtual, will_be_sparse);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	/* Also reap the chapter being replaced by the open chapter. */
+	uds_set_volume_index_open_chapter(index->volume_index, upto_virtual);
+
+	new_map_update = index->volume->index_page_map->last_update;
+	if (new_map_update != old_map_update)
+		uds_log_info("replay changed index page map update from %llu to %llu",
+			     (unsigned long long) old_map_update,
+			     (unsigned long long) new_map_update);
+
+	return UDS_SUCCESS;
+}
+
+static int rebuild_index(struct uds_index *index)
+{
+	int result;
+	u64 lowest;
+	u64 highest;
+	bool is_empty = false;
+	u32 chapters_per_volume = index->volume->geometry->chapters_per_volume;
+
+	index->volume->lookup_mode = LOOKUP_FOR_REBUILD;
+	result = uds_find_volume_chapter_boundaries(index->volume, &lowest, &highest, &is_empty);
+	if (result != UDS_SUCCESS)
+		return uds_log_fatal_strerror(result,
+					      "cannot rebuild index: unknown volume chapter boundaries");
+
+	if (is_empty) {
+		index->newest_virtual_chapter = 0;
+		index->oldest_virtual_chapter = 0;
+		index->volume->lookup_mode = LOOKUP_NORMAL;
+		return UDS_SUCCESS;
+	}
+
+	index->newest_virtual_chapter = highest + 1;
+	index->oldest_virtual_chapter = lowest;
+	if (index->newest_virtual_chapter == (index->oldest_virtual_chapter + chapters_per_volume))
+		/* Skip the chapter shadowed by the open chapter. */
+		index->oldest_virtual_chapter++;
+
+	result = replay_volume(index);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	index->volume->lookup_mode = LOOKUP_NORMAL;
+	return UDS_SUCCESS;
+}
+
+static void free_index_zone(struct index_zone *zone)
+{
+	if (zone == NULL)
+		return;
+
+	uds_free_open_chapter(zone->open_chapter);
+	uds_free_open_chapter(zone->writing_chapter);
+	UDS_FREE(zone);
+}
+
+static int make_index_zone(struct uds_index *index, unsigned int zone_number)
+{
+	int result;
+	struct index_zone *zone;
+
+	result = UDS_ALLOCATE(1, struct index_zone, "index zone", &zone);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_make_open_chapter(index->volume->geometry,
+				       index->zone_count,
+				       &zone->open_chapter);
+	if (result != UDS_SUCCESS) {
+		free_index_zone(zone);
+		return result;
+	}
+
+	result = uds_make_open_chapter(index->volume->geometry,
+				       index->zone_count,
+				       &zone->writing_chapter);
+	if (result != UDS_SUCCESS) {
+		free_index_zone(zone);
+		return result;
+	}
+
+	zone->index = index;
+	zone->id = zone_number;
+	index->zones[zone_number] = zone;
+
+	return UDS_SUCCESS;
+}
+
+int uds_make_index(struct configuration *config,
+		   enum uds_open_index_type open_type,
+		   struct index_load_context *load_context,
+		   index_callback_t callback,
+		   struct uds_index **new_index)
+{
+	int result;
+	bool loaded = false;
+	bool new = (open_type == UDS_CREATE);
+	struct uds_index *index = NULL;
+	struct index_zone *zone;
+	u64 nonce;
+	unsigned int z;
+
+	result = UDS_ALLOCATE_EXTENDED(struct uds_index,
+				       config->zone_count,
+				       struct uds_request_queue *,
+				       "index",
+				       &index);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	index->zone_count = config->zone_count;
+
+	result = uds_make_index_layout(config, new, &index->layout);
+	if (result != UDS_SUCCESS) {
+		uds_free_index(index);
+		return result;
+	}
+
+	result = UDS_ALLOCATE(index->zone_count, struct index_zone *, "zones", &index->zones);
+	if (result != UDS_SUCCESS) {
+		uds_free_index(index);
+		return result;
+	}
+
+	result = uds_make_volume(config, index->layout, &index->volume);
+	if (result != UDS_SUCCESS) {
+		uds_free_index(index);
+		return result;
+	}
+
+	index->volume->lookup_mode = LOOKUP_NORMAL;
+	for (z = 0; z < index->zone_count; z++) {
+		result = make_index_zone(index, z);
+		if (result != UDS_SUCCESS) {
+			uds_free_index(index);
+			return uds_log_error_strerror(result, "Could not create index zone");
+		}
+	}
+
+	nonce = uds_get_volume_nonce(index->layout);
+	result = uds_make_volume_index(config, nonce, &index->volume_index);
+	if (result != UDS_SUCCESS) {
+		uds_free_index(index);
+		return uds_log_error_strerror(result, "could not make volume index");
+	}
+
+	index->load_context = load_context;
+	index->callback = callback;
+
+	result = initialize_index_queues(index, config->geometry);
+	if (result != UDS_SUCCESS) {
+		uds_free_index(index);
+		return result;
+	}
+
+	result = make_chapter_writer(index, &index->chapter_writer);
+	if (result != UDS_SUCCESS) {
+		uds_free_index(index);
+		return result;
+	}
+
+	if (!new) {
+		result = load_index(index);
+		switch (result) {
+		case UDS_SUCCESS:
+			loaded = true;
+			break;
+		case -ENOMEM:
+			/* We should not try a rebuild for this error. */
+			uds_log_error_strerror(result, "index could not be loaded");
+			break;
+		default:
+			uds_log_error_strerror(result, "index could not be loaded");
+			if (open_type == UDS_LOAD) {
+				result = rebuild_index(index);
+				if (result != UDS_SUCCESS)
+					uds_log_error_strerror(result,
+							       "index could not be rebuilt");
+			}
+			break;
+		}
+	}
+
+	if (result != UDS_SUCCESS) {
+		uds_free_index(index);
+		return uds_log_error_strerror(result, "fatal error in %s()", __func__);
+	}
+
+	for (z = 0; z < index->zone_count; z++) {
+		zone = index->zones[z];
+		zone->oldest_virtual_chapter = index->oldest_virtual_chapter;
+		zone->newest_virtual_chapter = index->newest_virtual_chapter;
+	}
+
+	if (index->load_context != NULL) {
+		uds_lock_mutex(&index->load_context->mutex);
+		index->load_context->status = INDEX_READY;
+		/*
+		 * If we get here, suspend is meaningless, but notify any thread trying to suspend
+		 * us so it doesn't hang.
+		 */
+		uds_broadcast_cond(&index->load_context->cond);
+		uds_unlock_mutex(&index->load_context->mutex);
+	}
+
+	index->has_saved_open_chapter = loaded;
+	index->need_to_save = !loaded;
+	*new_index = index;
+	return UDS_SUCCESS;
+}
+
+void uds_free_index(struct uds_index *index)
+{
+	unsigned int i;
+
+	if (index == NULL)
+		return;
+
+	uds_request_queue_finish(index->triage_queue);
+	for (i = 0; i < index->zone_count; i++)
+		uds_request_queue_finish(index->zone_queues[i]);
+
+	free_chapter_writer(index->chapter_writer);
+
+	uds_free_volume_index(index->volume_index);
+	if (index->zones != NULL) {
+		for (i = 0; i < index->zone_count; i++)
+			free_index_zone(index->zones[i]);
+		UDS_FREE(index->zones);
+	}
+
+	uds_free_volume(index->volume);
+	uds_free_index_layout(UDS_FORGET(index->layout));
+	UDS_FREE(index);
+}
+
+/* Wait for the chapter writer to complete any outstanding writes. */
+void uds_wait_for_idle_index(struct uds_index *index)
+{
+	struct chapter_writer *writer = index->chapter_writer;
+
+	uds_lock_mutex(&writer->mutex);
+	while (writer->zones_to_write > 0)
+		uds_wait_cond(&writer->cond, &writer->mutex);
+	uds_unlock_mutex(&writer->mutex);
+}
+
+/* This function assumes that all requests have been drained. */
+int uds_save_index(struct uds_index *index)
+{
+	int result;
+
+	if (!index->need_to_save)
+		return UDS_SUCCESS;
+
+	uds_wait_for_idle_index(index);
+	index->prev_save = index->last_save;
+	index->last_save = ((index->newest_virtual_chapter == 0) ?
+			    NO_LAST_SAVE :
+			    index->newest_virtual_chapter - 1);
+	uds_log_info("beginning save (vcn %llu)", (unsigned long long) index->last_save);
+
+	result = uds_save_index_state(index->layout, index);
+	if (result != UDS_SUCCESS) {
+		uds_log_info("save index failed");
+		index->last_save = index->prev_save;
+	} else {
+		index->has_saved_open_chapter = true;
+		index->need_to_save = false;
+		uds_log_info("finished save (vcn %llu)", (unsigned long long) index->last_save);
+	}
+
+	return result;
+}
+
+int uds_replace_index_storage(struct uds_index *index, const char *path)
+{
+	return uds_replace_volume_storage(index->volume, index->layout, path);
+}
+
+/* Accessing statistics should be safe from any thread. */
+void uds_get_index_stats(struct uds_index *index, struct uds_index_stats *counters)
+{
+	struct volume_index_stats stats;
+
+	uds_get_volume_index_stats(index->volume_index, &stats);
+	counters->entries_indexed = stats.record_count;
+	counters->collisions = stats.collision_count;
+	counters->entries_discarded = stats.discard_count;
+
+	counters->memory_used = (index->volume_index->memory_size +
+				 index->volume->cache_size +
+				 index->chapter_writer->memory_size);
+}
+
+void uds_enqueue_request(struct uds_request *request, enum request_stage stage)
+{
+	struct uds_index *index = request->index;
+	struct uds_request_queue *queue;
+
+	switch (stage) {
+	case STAGE_TRIAGE:
+		if (index->triage_queue != NULL) {
+			queue = index->triage_queue;
+			break;
+		}
+
+		fallthrough;
+
+	case STAGE_INDEX:
+		request->zone_number =
+			uds_get_volume_index_zone(index->volume_index, &request->record_name);
+		fallthrough;
+
+	case STAGE_MESSAGE:
+		queue = index->zone_queues[request->zone_number];
+		break;
+
+	default:
+		ASSERT_LOG_ONLY(false, "invalid index stage: %d", stage);
+		return;
+	}
+
+	uds_request_queue_enqueue(queue, request);
+}
diff --git a/drivers/md/dm-vdo/index.h b/drivers/md/dm-vdo/index.h
new file mode 100644
index 00000000000..9dfb2e1b85d
--- /dev/null
+++ b/drivers/md/dm-vdo/index.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_INDEX_H
+#define UDS_INDEX_H
+
+#include "index-layout.h"
+#include "index-session.h"
+#include "open-chapter.h"
+#include "volume.h"
+#include "volume-index.h"
+
+/*
+ * The index is a high-level structure which represents the totality of the UDS index. It manages
+ * the queues for incoming requests and dispatches them to the appropriate sub-components like the
+ * volume or the volume index. It also manages administrative tasks such as saving and loading the
+ * index.
+ *
+ * The index is divided into a number of independent zones and assigns each request to a zone based
+ * on its name. Most sub-components are similarly divided into zones as well so that requests in
+ * each zone usually operate without interference or coordination between zones.
+ */
+
+typedef void (*index_callback_t)(struct uds_request *request);
+
+struct index_zone {
+	struct uds_index *index;
+	struct open_chapter_zone *open_chapter;
+	struct open_chapter_zone *writing_chapter;
+	u64 oldest_virtual_chapter;
+	u64 newest_virtual_chapter;
+	unsigned int id;
+};
+
+struct uds_index {
+	bool has_saved_open_chapter;
+	bool need_to_save;
+	struct index_load_context *load_context;
+	struct index_layout *layout;
+	struct volume_index *volume_index;
+	struct volume *volume;
+	unsigned int zone_count;
+	struct index_zone **zones;
+
+	u64 oldest_virtual_chapter;
+	u64 newest_virtual_chapter;
+
+	u64 last_save;
+	u64 prev_save;
+	struct chapter_writer *chapter_writer;
+
+	index_callback_t callback;
+	struct uds_request_queue *triage_queue;
+	struct uds_request_queue *zone_queues[];
+};
+
+enum request_stage {
+	STAGE_TRIAGE,
+	STAGE_INDEX,
+	STAGE_MESSAGE,
+};
+
+int __must_check uds_make_index(struct configuration *config,
+				enum uds_open_index_type open_type,
+				struct index_load_context *load_context,
+				index_callback_t callback,
+				struct uds_index **new_index);
+
+int __must_check uds_save_index(struct uds_index *index);
+
+void uds_free_index(struct uds_index *index);
+
+int __must_check uds_replace_index_storage(struct uds_index *index, const char *path);
+
+void uds_get_index_stats(struct uds_index *index, struct uds_index_stats *counters);
+
+void uds_enqueue_request(struct uds_request *request, enum request_stage stage);
+
+void uds_wait_for_idle_index(struct uds_index *index);
+
+#endif /* UDS_INDEX_H */
diff --git a/drivers/md/dm-vdo/io-factory.c b/drivers/md/dm-vdo/io-factory.c
new file mode 100644
index 00000000000..d8c03e9ab43
--- /dev/null
+++ b/drivers/md/dm-vdo/io-factory.c
@@ -0,0 +1,458 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "io-factory.h"
+
+#include <linux/atomic.h>
+#include <linux/blkdev.h>
+#include <linux/err.h>
+#include <linux/mount.h>
+
+#include "logger.h"
+#include "memory-alloc.h"
+#include "numeric.h"
+
+enum { BLK_FMODE = FMODE_READ | FMODE_WRITE };
+
+/*
+ * The I/O factory object manages access to index storage, which is a contiguous range of blocks on
+ * a block device.
+ *
+ * The factory holds the open device and is responsible for closing it. The factory has methods to
+ * make helper structures that can be used to access sections of the index.
+ */
+struct io_factory {
+	struct block_device *bdev;
+	atomic_t ref_count;
+};
+
+/* The buffered reader allows efficient I/O by reading page-sized segments into a buffer. */
+struct buffered_reader {
+	struct io_factory *factory;
+	struct dm_bufio_client *client;
+	struct dm_buffer *buffer;
+	sector_t limit;
+	sector_t block_number;
+	u8 *start;
+	u8 *end;
+};
+
+enum { MAX_READ_AHEAD_BLOCKS = 4 };
+
+/*
+ * The buffered writer allows efficient I/O by buffering writes and committing page-sized segments
+ * to storage.
+ */
+struct buffered_writer {
+	struct io_factory *factory;
+	struct dm_bufio_client *client;
+	struct dm_buffer *buffer;
+	sector_t limit;
+	sector_t block_number;
+	u8 *start;
+	u8 *end;
+	int error;
+};
+
+static void uds_get_io_factory(struct io_factory *factory)
+{
+	atomic_inc(&factory->ref_count);
+}
+
+static int get_block_device_from_name(const char *name, struct block_device **bdev)
+{
+	dev_t device = name_to_dev_t(name);
+
+	if (device != 0)
+		*bdev = blkdev_get_by_dev(device, BLK_FMODE, NULL);
+	else
+		*bdev = blkdev_get_by_path(name, BLK_FMODE, NULL);
+	if (IS_ERR(*bdev)) {
+		uds_log_error_strerror(-PTR_ERR(*bdev), "%s is not a block device", name);
+		return UDS_INVALID_ARGUMENT;
+	}
+
+	return UDS_SUCCESS;
+}
+
+int uds_make_io_factory(const char *path, struct io_factory **factory_ptr)
+{
+	int result;
+	struct block_device *bdev;
+	struct io_factory *factory;
+
+	result = get_block_device_from_name(path, &bdev);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(1, struct io_factory, __func__, &factory);
+	if (result != UDS_SUCCESS) {
+		blkdev_put(bdev, BLK_FMODE);
+		return result;
+	}
+
+	factory->bdev = bdev;
+	atomic_set_release(&factory->ref_count, 1);
+
+	*factory_ptr = factory;
+	return UDS_SUCCESS;
+}
+
+int uds_replace_storage(struct io_factory *factory, const char *path)
+{
+	int result;
+	struct block_device *bdev;
+
+	result = get_block_device_from_name(path, &bdev);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	blkdev_put(factory->bdev, BLK_FMODE);
+	factory->bdev = bdev;
+	return UDS_SUCCESS;
+}
+
+/* Free an I/O factory once all references have been released. */
+void uds_put_io_factory(struct io_factory *factory)
+{
+	if (atomic_add_return(-1, &factory->ref_count) <= 0) {
+		blkdev_put(factory->bdev, BLK_FMODE);
+		UDS_FREE(factory);
+	}
+}
+
+size_t uds_get_writable_size(struct io_factory *factory)
+{
+	return i_size_read(factory->bdev->bd_inode);
+}
+
+/* Create a struct dm_bufio_client for an index region starting at offset. */
+int uds_make_bufio(struct io_factory *factory,
+		   off_t block_offset,
+		   size_t block_size,
+		   unsigned int reserved_buffers,
+		   struct dm_bufio_client **client_ptr)
+{
+	struct dm_bufio_client *client;
+
+	client = dm_bufio_client_create(factory->bdev,
+					block_size,
+					reserved_buffers,
+					0,
+					NULL,
+					NULL,
+					0);
+	if (IS_ERR(client))
+		return -PTR_ERR(client);
+
+	dm_bufio_set_sector_offset(client, block_offset * SECTORS_PER_BLOCK);
+	*client_ptr = client;
+	return UDS_SUCCESS;
+}
+
+static void read_ahead(struct buffered_reader *reader, sector_t block_number)
+{
+	if (block_number < reader->limit) {
+		sector_t read_ahead =
+			min((sector_t) MAX_READ_AHEAD_BLOCKS, reader->limit - block_number);
+
+		dm_bufio_prefetch(reader->client, block_number, read_ahead);
+	}
+}
+
+void uds_free_buffered_reader(struct buffered_reader *reader)
+{
+	if (reader == NULL)
+		return;
+
+	if (reader->buffer != NULL)
+		dm_bufio_release(reader->buffer);
+
+	dm_bufio_client_destroy(reader->client);
+	uds_put_io_factory(reader->factory);
+	UDS_FREE(reader);
+}
+
+/* Create a buffered reader for an index region starting at offset. */
+int uds_make_buffered_reader(struct io_factory *factory,
+			     off_t offset,
+			     u64 block_count,
+			     struct buffered_reader **reader_ptr)
+{
+	int result;
+	struct dm_bufio_client *client = NULL;
+	struct buffered_reader *reader = NULL;
+
+	result = uds_make_bufio(factory, offset, UDS_BLOCK_SIZE, 1, &client);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(1, struct buffered_reader, "buffered reader", &reader);
+	if (result != UDS_SUCCESS) {
+		dm_bufio_client_destroy(client);
+		return result;
+	}
+
+	*reader = (struct buffered_reader) {
+		.factory = factory,
+		.client = client,
+		.buffer = NULL,
+		.limit = block_count,
+		.block_number = 0,
+		.start = NULL,
+		.end = NULL,
+	};
+
+	read_ahead(reader, 0);
+	uds_get_io_factory(factory);
+	*reader_ptr = reader;
+	return UDS_SUCCESS;
+}
+
+static int position_reader(struct buffered_reader *reader, sector_t block_number, off_t offset)
+{
+	struct dm_buffer *buffer = NULL;
+	void *data;
+
+	if ((reader->end == NULL) || (block_number != reader->block_number)) {
+		if (block_number >= reader->limit)
+			return UDS_OUT_OF_RANGE;
+
+		if (reader->buffer != NULL)
+			dm_bufio_release(UDS_FORGET(reader->buffer));
+
+		data = dm_bufio_read(reader->client, block_number, &buffer);
+		if (IS_ERR(data))
+			return -PTR_ERR(data);
+
+		reader->buffer = buffer;
+		reader->start = data;
+		if (block_number == reader->block_number + 1)
+			read_ahead(reader, block_number + 1);
+	}
+
+	reader->block_number = block_number;
+	reader->end = reader->start + offset;
+	return UDS_SUCCESS;
+}
+
+static size_t bytes_remaining_in_read_buffer(struct buffered_reader *reader)
+{
+	return (reader->end == NULL) ? 0 : reader->start + UDS_BLOCK_SIZE - reader->end;
+}
+
+static int reset_reader(struct buffered_reader *reader)
+{
+	sector_t block_number;
+
+	if (bytes_remaining_in_read_buffer(reader) > 0)
+		return UDS_SUCCESS;
+
+	block_number = reader->block_number;
+	if (reader->end != NULL)
+		++block_number;
+
+	return position_reader(reader, block_number, 0);
+}
+
+int uds_read_from_buffered_reader(struct buffered_reader *reader, u8 *data, size_t length)
+{
+	int result = UDS_SUCCESS;
+	size_t chunk_size;
+
+	while (length > 0) {
+		result = reset_reader(reader);
+		if (result != UDS_SUCCESS)
+			return result;
+
+		chunk_size = min(length, bytes_remaining_in_read_buffer(reader));
+		memcpy(data, reader->end, chunk_size);
+		length -= chunk_size;
+		data += chunk_size;
+		reader->end += chunk_size;
+	}
+
+	return UDS_SUCCESS;
+}
+
+/*
+ * Verify that the next data on the reader matches the required value. If the value matches, the
+ * matching contents are consumed. If the value does not match, the reader state is unchanged.
+ */
+int uds_verify_buffered_data(struct buffered_reader *reader, const u8 *value, size_t length)
+{
+	int result = UDS_SUCCESS;
+	size_t chunk_size;
+	sector_t start_block_number = reader->block_number;
+	int start_offset = reader->end - reader->start;
+
+	while (length > 0) {
+		result = reset_reader(reader);
+		if (result != UDS_SUCCESS) {
+			result = UDS_CORRUPT_DATA;
+			break;
+		}
+
+		chunk_size = min(length, bytes_remaining_in_read_buffer(reader));
+		if (memcmp(value, reader->end, chunk_size) != 0) {
+			result = UDS_CORRUPT_DATA;
+			break;
+		}
+
+		length -= chunk_size;
+		value += chunk_size;
+		reader->end += chunk_size;
+	}
+
+	if (result != UDS_SUCCESS)
+		position_reader(reader, start_block_number, start_offset);
+
+	return result;
+}
+
+/* Create a buffered writer for an index region starting at offset. */
+int uds_make_buffered_writer(struct io_factory *factory,
+			     off_t offset,
+			     u64 block_count,
+			     struct buffered_writer **writer_ptr)
+{
+	int result;
+	struct dm_bufio_client *client = NULL;
+	struct buffered_writer *writer;
+
+	result = uds_make_bufio(factory, offset, UDS_BLOCK_SIZE, 1, &client);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(1, struct buffered_writer, "buffered writer", &writer);
+	if (result != UDS_SUCCESS) {
+		dm_bufio_client_destroy(client);
+		return result;
+	}
+
+	*writer = (struct buffered_writer) {
+		.factory = factory,
+		.client = client,
+		.buffer = NULL,
+		.limit = block_count,
+		.start = NULL,
+		.end = NULL,
+		.block_number = 0,
+		.error = UDS_SUCCESS,
+	};
+
+	uds_get_io_factory(factory);
+	*writer_ptr = writer;
+	return UDS_SUCCESS;
+}
+
+static size_t get_remaining_write_space(struct buffered_writer *writer)
+{
+	return writer->start + UDS_BLOCK_SIZE - writer->end;
+}
+
+static int __must_check prepare_next_buffer(struct buffered_writer *writer)
+{
+	struct dm_buffer *buffer = NULL;
+	void *data;
+
+	if (writer->block_number >= writer->limit) {
+		writer->error = UDS_OUT_OF_RANGE;
+		return UDS_OUT_OF_RANGE;
+	}
+
+	data = dm_bufio_new(writer->client, writer->block_number, &buffer);
+	if (IS_ERR(data)) {
+		writer->error = -PTR_ERR(data);
+		return writer->error;
+	}
+
+	writer->buffer = buffer;
+	writer->start = data;
+	writer->end = data;
+	return UDS_SUCCESS;
+}
+
+static int flush_previous_buffer(struct buffered_writer *writer)
+{
+	size_t available;
+
+	if (writer->buffer == NULL)
+		return writer->error;
+
+	if (writer->error == UDS_SUCCESS) {
+		available = get_remaining_write_space(writer);
+
+		if (available > 0)
+			memset(writer->end, 0, available);
+
+		dm_bufio_mark_buffer_dirty(writer->buffer);
+	}
+
+	dm_bufio_release(writer->buffer);
+	writer->buffer = NULL;
+	writer->start = NULL;
+	writer->end = NULL;
+	writer->block_number++;
+	return writer->error;
+}
+
+void uds_free_buffered_writer(struct buffered_writer *writer)
+{
+	int result;
+
+	if (writer == NULL)
+		return;
+
+	flush_previous_buffer(writer);
+	result = -dm_bufio_write_dirty_buffers(writer->client);
+	if (result != UDS_SUCCESS)
+		uds_log_warning_strerror(result, "%s: failed to sync storage", __func__);
+
+	dm_bufio_client_destroy(writer->client);
+	uds_put_io_factory(writer->factory);
+	UDS_FREE(writer);
+}
+
+/*
+ * Append data to the buffer, writing as needed. If no data is provided, zeros are written instead.
+ * If a write error occurs, it is recorded and returned on every subsequent write attempt.
+ */
+int uds_write_to_buffered_writer(struct buffered_writer *writer, const u8 *data, size_t length)
+{
+	int result = writer->error;
+	size_t chunk_size;
+
+	while ((length > 0) && (result == UDS_SUCCESS)) {
+		if (writer->buffer == NULL) {
+			result = prepare_next_buffer(writer);
+			continue;
+		}
+
+		chunk_size = min(length, get_remaining_write_space(writer));
+		if (data == NULL) {
+			memset(writer->end, 0, chunk_size);
+		} else {
+			memcpy(writer->end, data, chunk_size);
+			data += chunk_size;
+		}
+
+		length -= chunk_size;
+		writer->end += chunk_size;
+
+		if (get_remaining_write_space(writer) == 0)
+			result = uds_flush_buffered_writer(writer);
+	}
+
+	return result;
+}
+
+int uds_flush_buffered_writer(struct buffered_writer *writer)
+{
+	if (writer->error != UDS_SUCCESS)
+		return writer->error;
+
+	return flush_previous_buffer(writer);
+}
diff --git a/drivers/md/dm-vdo/io-factory.h b/drivers/md/dm-vdo/io-factory.h
new file mode 100644
index 00000000000..1aa5ded6204
--- /dev/null
+++ b/drivers/md/dm-vdo/io-factory.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_IO_FACTORY_H
+#define UDS_IO_FACTORY_H
+
+#include <linux/dm-bufio.h>
+
+/*
+ * The I/O factory manages all low-level I/O operations to the underlying storage device. Its main
+ * clients are the index layout and the volume. The buffered reader and buffered writer interfaces
+ * are helpers for accessing data in a contiguous range of storage blocks.
+ */
+
+struct buffered_reader;
+struct buffered_writer;
+
+struct io_factory;
+
+enum {
+	UDS_BLOCK_SIZE = 4096,
+	SECTORS_PER_BLOCK = UDS_BLOCK_SIZE >> SECTOR_SHIFT,
+};
+
+int __must_check uds_make_io_factory(const char *path, struct io_factory **factory_ptr);
+
+int __must_check uds_replace_storage(struct io_factory *factory, const char *path);
+
+void uds_put_io_factory(struct io_factory *factory);
+
+size_t __must_check uds_get_writable_size(struct io_factory *factory);
+
+int __must_check uds_make_bufio(struct io_factory *factory,
+				off_t block_offset,
+				size_t block_size,
+				unsigned int reserved_buffers,
+				struct dm_bufio_client **client_ptr);
+
+int __must_check uds_make_buffered_reader(struct io_factory *factory,
+					  off_t offset,
+					  u64 block_count,
+					  struct buffered_reader **reader_ptr);
+
+void uds_free_buffered_reader(struct buffered_reader *reader);
+
+int __must_check
+uds_read_from_buffered_reader(struct buffered_reader *reader, u8 *data, size_t length);
+
+int __must_check
+uds_verify_buffered_data(struct buffered_reader *reader, const u8 *value, size_t length);
+
+int __must_check uds_make_buffered_writer(struct io_factory *factory,
+					  off_t offset,
+					  u64 block_count,
+					  struct buffered_writer **writer_ptr);
+
+void uds_free_buffered_writer(struct buffered_writer *buffer);
+
+int __must_check
+uds_write_to_buffered_writer(struct buffered_writer *writer, const u8 *data, size_t length);
+
+int __must_check uds_flush_buffered_writer(struct buffered_writer *writer);
+
+#endif /* UDS_IO_FACTORY_H */
diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
new file mode 100644
index 00000000000..1a051cd8003
--- /dev/null
+++ b/drivers/md/dm-vdo/logger.c
@@ -0,0 +1,302 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "logger.h"
+
+#include <linux/delay.h>
+#include <linux/hardirq.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/sched.h>
+
+#include "thread-device.h"
+#include "uds-threads.h"
+
+struct priority_name {
+	const char *name;
+	const int priority;
+};
+
+static const struct priority_name PRIORITIES[] = {
+	{ "ALERT", UDS_LOG_ALERT },
+	{ "CRITICAL", UDS_LOG_CRIT },
+	{ "CRIT", UDS_LOG_CRIT },
+	{ "DEBUG", UDS_LOG_DEBUG },
+	{ "EMERGENCY", UDS_LOG_EMERG },
+	{ "EMERG", UDS_LOG_EMERG },
+	{ "ERROR", UDS_LOG_ERR },
+	{ "ERR", UDS_LOG_ERR },
+	{ "INFO", UDS_LOG_INFO },
+	{ "NOTICE", UDS_LOG_NOTICE },
+	{ "PANIC", UDS_LOG_EMERG },
+	{ "WARN", UDS_LOG_WARNING },
+	{ "WARNING", UDS_LOG_WARNING },
+	{ NULL, -1 },
+};
+
+static const char *const PRIORITY_STRINGS[] = {
+	"EMERGENCY",
+	"ALERT",
+	"CRITICAL",
+	"ERROR",
+	"WARN",
+	"NOTICE",
+	"INFO",
+	"DEBUG",
+};
+
+static int log_level = UDS_LOG_INFO;
+
+int uds_get_log_level(void)
+{
+	return log_level;
+}
+
+void uds_set_log_level(int new_log_level)
+{
+	log_level = new_log_level;
+}
+
+int uds_log_string_to_priority(const char *string)
+{
+	int i;
+
+	for (i = 0; PRIORITIES[i].name != NULL; i++)
+		if (strcasecmp(string, PRIORITIES[i].name) == 0)
+			return PRIORITIES[i].priority;
+	return UDS_LOG_INFO;
+}
+
+const char *uds_log_priority_to_string(int priority)
+{
+	if ((priority < 0) || (priority >= (int) ARRAY_SIZE(PRIORITY_STRINGS)))
+		return "unknown";
+	return PRIORITY_STRINGS[priority];
+}
+
+static const char *get_current_interrupt_type(void)
+{
+	if (in_nmi())
+		return "NMI";
+	if (in_irq())
+		return "HI";
+	if (in_softirq())
+		return "SI";
+	return "INTR";
+}
+
+/*
+ * Emit a log message to the kernel at the specified priority.
+ *
+ * @priority: The priority at which to log the message
+ * @fmt: The format string of the message
+ */
+static void emit_log_message_to_kernel(int priority, const char *fmt, ...)
+{
+	va_list args;
+	struct va_format vaf;
+
+	if (priority > uds_get_log_level())
+		return;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	switch (priority) {
+	case UDS_LOG_EMERG:
+	case UDS_LOG_ALERT:
+	case UDS_LOG_CRIT:
+		printk(KERN_CRIT "%pV", &vaf);
+		break;
+	case UDS_LOG_ERR:
+		printk(KERN_ERR "%pV", &vaf);
+		break;
+	case UDS_LOG_WARNING:
+		printk(KERN_WARNING "%pV", &vaf);
+		break;
+	case UDS_LOG_NOTICE:
+		printk(KERN_NOTICE "%pV", &vaf);
+		break;
+	case UDS_LOG_INFO:
+		printk(KERN_INFO "%pV", &vaf);
+		break;
+	case UDS_LOG_DEBUG:
+		printk(KERN_DEBUG "%pV", &vaf);
+		break;
+	default:
+		printk(KERN_DEFAULT "%pV", &vaf);
+		break;
+	}
+
+	va_end(args);
+}
+
+/*
+ * Emit a log message to the kernel log in a format suited to the current thread context. Context
+ * info formats:
+ *
+ * interrupt:           uds[NMI]: blah
+ * kvdo thread:         kvdo12:foobarQ: blah
+ * thread w/device id:  kvdo12:myprog: blah
+ * other thread:        uds: myprog: blah
+ *
+ * Fields: module name, interrupt level, process name, device ID.
+ *
+ * @priority: the priority at which to log the message
+ * @module: The name of the module doing the logging
+ * @prefix: The prefix of the log message
+ * @vaf1: The first message format descriptor
+ * @vaf2: The second message format descriptor
+ */
+static void emit_log_message(int priority,
+			     const char *module,
+			     const char *prefix,
+			     const struct va_format *vaf1,
+			     const struct va_format *vaf2)
+{
+	int device_instance;
+
+	/*
+	 * In interrupt context, identify the interrupt type and module. Ignore the process/thread
+	 * since it could be anything.
+	 */
+	if (in_interrupt()) {
+		const char *type = get_current_interrupt_type();
+
+		emit_log_message_to_kernel(priority,
+					   "%s[%s]: %s%pV%pV\n",
+					   module, type, prefix, vaf1, vaf2);
+		return;
+	}
+
+	/* Not at interrupt level; we have a process we can look at, and might have a device ID. */
+	device_instance = uds_get_thread_device_id();
+	if (device_instance >= 0) {
+		emit_log_message_to_kernel(priority,
+					   "%s%u:%s: %s%pV%pV\n",
+					   module, device_instance,
+					   current->comm, prefix, vaf1, vaf2);
+		return;
+	}
+
+	/*
+	 * If it's a kernel thread and the module name is a prefix of its name, assume it is ours
+	 * and only identify the thread.
+	 */
+	if (((current->flags & PF_KTHREAD) != 0) &&
+	    (strncmp(module, current->comm, strlen(module)) == 0)) {
+		emit_log_message_to_kernel(priority,
+					   "%s: %s%pV%pV\n",
+					   current->comm, prefix, vaf1, vaf2);
+		return;
+	}
+
+	/* Identify the module and the process. */
+	emit_log_message_to_kernel(priority,
+				   "%s: %s: %s%pV%pV\n",
+				   module, current->comm, prefix, vaf1, vaf2);
+}
+
+/*
+ * uds_log_embedded_message() - Log a message embedded within another message.
+ * @priority: the priority at which to log the message
+ * @module: the name of the module doing the logging
+ * @prefix: optional string prefix to message, may be NULL
+ * @fmt1: format of message first part (required)
+ * @args1: arguments for message first part (required)
+ * @fmt2: format of message second part
+ */
+void uds_log_embedded_message(int priority,
+			      const char *module,
+			      const char *prefix,
+			      const char *fmt1,
+			      va_list args1,
+			      const char *fmt2,
+			      ...)
+{
+	va_list args1_copy;
+	va_list args2;
+	struct va_format vaf1, vaf2;
+
+	va_start(args2, fmt2);
+
+	if (module == NULL)
+		module = UDS_LOGGING_MODULE_NAME;
+	if (prefix == NULL)
+		prefix = "";
+
+	/*
+	 * It is implementation dependent whether va_list is defined as an array type that decays
+	 * to a pointer when passed as an argument. Copy args1 and args2 with va_copy so that vaf1
+	 * and vaf2 get proper va_list pointers irrespective of how va_list is defined.
+	 */
+	va_copy(args1_copy, args1);
+	vaf1.fmt = fmt1;
+	vaf1.va = &args1_copy;
+
+	vaf2.fmt = fmt2;
+	vaf2.va = &args2;
+
+	emit_log_message(priority, module, prefix, &vaf1, &vaf2);
+
+	va_end(args1_copy);
+	va_end(args2);
+}
+
+int uds_vlog_strerror(int priority,
+		      int errnum,
+		      const char *module,
+		      const char *format,
+		      va_list args)
+{
+	char errbuf[UDS_MAX_ERROR_MESSAGE_SIZE];
+	const char *message = uds_string_error(errnum, errbuf, sizeof(errbuf));
+
+	uds_log_embedded_message(priority,
+				 module,
+				 NULL,
+				 format,
+				 args,
+				 ": %s (%d)",
+				 message,
+				 errnum);
+	return errnum;
+}
+
+int __uds_log_strerror(int priority, int errnum, const char *module, const char *format, ...)
+{
+	va_list args;
+
+	va_start(args, format);
+	uds_vlog_strerror(priority, errnum, module, format, args);
+	va_end(args);
+	return errnum;
+}
+
+void uds_log_backtrace(int priority)
+{
+	if (priority > uds_get_log_level())
+		return;
+	dump_stack();
+}
+
+void __uds_log_message(int priority, const char *module, const char *format, ...)
+{
+	va_list args;
+
+	va_start(args, format);
+	uds_log_embedded_message(priority, module, NULL, format, args, "%s", "");
+	va_end(args);
+}
+
+/*
+ * Sleep or delay a few milliseconds in an attempt to allow the log buffers to be flushed lest they
+ * be overrun.
+ */
+void uds_pause_for_logger(void)
+{
+	fsleep(4000);
+}
diff --git a/drivers/md/dm-vdo/logger.h b/drivers/md/dm-vdo/logger.h
new file mode 100644
index 00000000000..4e3ea3f0263
--- /dev/null
+++ b/drivers/md/dm-vdo/logger.h
@@ -0,0 +1,112 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_LOGGER_H
+#define UDS_LOGGER_H
+
+#include <linux/module.h>
+#include <linux/ratelimit.h>
+
+/* Custom logging utilities for UDS */
+
+#define UDS_LOG_EMERG 0
+#define UDS_LOG_ALERT 1
+#define UDS_LOG_CRIT 2
+#define UDS_LOG_ERR 3
+#define UDS_LOG_WARNING 4
+#define UDS_LOG_NOTICE 5
+#define UDS_LOG_INFO 6
+#define UDS_LOG_DEBUG 7
+
+#if defined(MODULE)
+#define UDS_LOGGING_MODULE_NAME THIS_MODULE->name
+#else /* compiled into the kernel */
+#define UDS_LOGGING_MODULE_NAME "vdo"
+#endif
+
+/* Apply a rate limiter to a log method call. */
+#define uds_log_ratelimit(log_fn, ...)                                    \
+	do {                                                              \
+		static DEFINE_RATELIMIT_STATE(_rs,                        \
+					      DEFAULT_RATELIMIT_INTERVAL, \
+					      DEFAULT_RATELIMIT_BURST);   \
+		if (__ratelimit(&_rs)) {                                  \
+			log_fn(__VA_ARGS__);                              \
+		}                                                         \
+	} while (0)
+
+int uds_get_log_level(void);
+
+void uds_set_log_level(int new_log_level);
+
+int uds_log_string_to_priority(const char *string);
+
+const char *uds_log_priority_to_string(int priority);
+
+void uds_log_embedded_message(int priority,
+			      const char *module,
+			      const char *prefix,
+			      const char *fmt1,
+			      va_list args1,
+			      const char *fmt2,
+			      ...)
+	__printf(4, 0) __printf(6, 7);
+
+void uds_log_backtrace(int priority);
+
+/* All log functions will preserve the caller's value of errno. */
+
+#define uds_log_strerror(priority, errnum, ...) \
+	__uds_log_strerror(priority, errnum, UDS_LOGGING_MODULE_NAME, __VA_ARGS__)
+
+int __uds_log_strerror(int priority, int errnum, const char *module, const char *format, ...)
+	__printf(4, 5);
+
+int uds_vlog_strerror(int priority,
+		      int errnum,
+		      const char *module,
+		      const char *format,
+		      va_list args)
+	__printf(4, 0);
+
+/* Log an error prefixed with the string associated with the errnum. */
+#define uds_log_error_strerror(errnum, ...) \
+	uds_log_strerror(UDS_LOG_ERR, errnum, __VA_ARGS__)
+
+#define uds_log_debug_strerror(errnum, ...) \
+	uds_log_strerror(UDS_LOG_DEBUG, errnum, __VA_ARGS__)
+
+#define uds_log_info_strerror(errnum, ...) \
+	uds_log_strerror(UDS_LOG_INFO, errnum, __VA_ARGS__)
+
+#define uds_log_notice_strerror(errnum, ...) \
+	uds_log_strerror(UDS_LOG_NOTICE, errnum, __VA_ARGS__)
+
+#define uds_log_warning_strerror(errnum, ...) \
+	uds_log_strerror(UDS_LOG_WARNING, errnum, __VA_ARGS__)
+
+#define uds_log_fatal_strerror(errnum, ...) \
+	uds_log_strerror(UDS_LOG_CRIT, errnum, __VA_ARGS__)
+
+#define uds_log_message(priority, ...) \
+	__uds_log_message(priority, UDS_LOGGING_MODULE_NAME, __VA_ARGS__)
+
+void __uds_log_message(int priority, const char *module, const char *format, ...)
+	__printf(3, 4);
+
+#define uds_log_debug(...) uds_log_message(UDS_LOG_DEBUG, __VA_ARGS__)
+
+#define uds_log_info(...) uds_log_message(UDS_LOG_INFO, __VA_ARGS__)
+
+#define uds_log_notice(...) uds_log_message(UDS_LOG_NOTICE, __VA_ARGS__)
+
+#define uds_log_warning(...) uds_log_message(UDS_LOG_WARNING, __VA_ARGS__)
+
+#define uds_log_error(...) uds_log_message(UDS_LOG_ERR, __VA_ARGS__)
+
+#define uds_log_fatal(...) uds_log_message(UDS_LOG_CRIT, __VA_ARGS__)
+
+void uds_pause_for_logger(void);
+#endif /* UDS_LOGGER_H */
diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
new file mode 100644
index 00000000000..00b992e96bd
--- /dev/null
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -0,0 +1,447 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/sched/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include "logger.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+
+/*
+ * UDS and VDO keep track of which threads are allowed to allocate memory freely, and which threads
+ * must be careful to not do a memory allocation that does an I/O request. The allocating_threads
+ * threads_registry and its associated methods implement this tracking.
+ */
+static struct thread_registry allocating_threads;
+
+static bool allocations_allowed(void)
+{
+	const bool *pointer = uds_lookup_thread(&allocating_threads);
+
+	return (pointer != NULL) ? *pointer : false;
+}
+
+/*
+ * Register the current thread as an allocating thread.
+ *
+ * An optional flag location can be supplied indicating whether, at any given point in time, the
+ * threads associated with that flag should be allocating storage. If the flag is false, a message
+ * will be logged.
+ *
+ * If no flag is supplied, the thread is always allowed to allocate storage without complaint.
+ *
+ * @new_thread: registered_thread structure to use for the current thread
+ * @flag_ptr: Location of the allocation-allowed flag
+ */
+void uds_register_allocating_thread(struct registered_thread *new_thread, const bool *flag_ptr)
+{
+	if (flag_ptr == NULL) {
+		static const bool allocation_always_allowed = true;
+
+		flag_ptr = &allocation_always_allowed;
+	}
+
+	uds_register_thread(&allocating_threads, new_thread, flag_ptr);
+}
+
+/* Unregister the current thread as an allocating thread. */
+void uds_unregister_allocating_thread(void)
+{
+	uds_unregister_thread(&allocating_threads);
+}
+
+/*
+ * We track how much memory has been allocated and freed. When we unload the module, we log an
+ * error if we have not freed all the memory that we allocated. Nearly all memory allocation and
+ * freeing is done using this module.
+ *
+ * We do not use kernel functions like the kvasprintf() method, which allocate memory indirectly
+ * using kmalloc.
+ *
+ * These data structures and methods are used to track the amount of memory used.
+ */
+
+/*
+ * We allocate very few large objects, and allocation/deallocation isn't done in a
+ * performance-critical stage for us, so a linked list should be fine.
+ */
+struct vmalloc_block_info {
+	void *ptr;
+	size_t size;
+	struct vmalloc_block_info *next;
+};
+
+static struct {
+	spinlock_t lock;
+	size_t kmalloc_blocks;
+	size_t kmalloc_bytes;
+	size_t vmalloc_blocks;
+	size_t vmalloc_bytes;
+	size_t peak_bytes;
+	struct vmalloc_block_info *vmalloc_list;
+} memory_stats __cacheline_aligned;
+
+static void update_peak_usage(void)
+{
+	size_t total_bytes = memory_stats.kmalloc_bytes + memory_stats.vmalloc_bytes;
+
+	if (total_bytes > memory_stats.peak_bytes)
+		memory_stats.peak_bytes = total_bytes;
+}
+
+static void add_kmalloc_block(size_t size)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&memory_stats.lock, flags);
+	memory_stats.kmalloc_blocks++;
+	memory_stats.kmalloc_bytes += size;
+	update_peak_usage();
+	spin_unlock_irqrestore(&memory_stats.lock, flags);
+}
+
+static void remove_kmalloc_block(size_t size)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&memory_stats.lock, flags);
+	memory_stats.kmalloc_blocks--;
+	memory_stats.kmalloc_bytes -= size;
+	spin_unlock_irqrestore(&memory_stats.lock, flags);
+}
+
+static void add_vmalloc_block(struct vmalloc_block_info *block)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&memory_stats.lock, flags);
+	block->next = memory_stats.vmalloc_list;
+	memory_stats.vmalloc_list = block;
+	memory_stats.vmalloc_blocks++;
+	memory_stats.vmalloc_bytes += block->size;
+	update_peak_usage();
+	spin_unlock_irqrestore(&memory_stats.lock, flags);
+}
+
+static void remove_vmalloc_block(void *ptr)
+{
+	struct vmalloc_block_info *block;
+	struct vmalloc_block_info **block_ptr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&memory_stats.lock, flags);
+	for (block_ptr = &memory_stats.vmalloc_list;
+	     (block = *block_ptr) != NULL;
+	     block_ptr = &block->next) {
+		if (block->ptr == ptr) {
+			*block_ptr = block->next;
+			memory_stats.vmalloc_blocks--;
+			memory_stats.vmalloc_bytes -= block->size;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&memory_stats.lock, flags);
+	if (block != NULL)
+		UDS_FREE(block);
+	else
+		uds_log_info("attempting to remove ptr %px not found in vmalloc list", ptr);
+}
+
+/*
+ * Determine whether allocating a memory block should use kmalloc or __vmalloc.
+ *
+ * vmalloc can allocate any integral number of pages.
+ *
+ * kmalloc can allocate any number of bytes up to a configured limit, which defaults to 8 megabytes
+ * on some systems. kmalloc is especially good when memory is being both allocated and freed, and
+ * it does this efficiently in a multi CPU environment.
+ *
+ * kmalloc usually rounds the size of the block up to the next power of two, so when the requested
+ * block is bigger than PAGE_SIZE / 2 bytes, kmalloc will never give you less space than the
+ * corresponding vmalloc allocation. Sometimes vmalloc will use less overhead than kmalloc.
+ *
+ * The advantages of kmalloc do not help out UDS or VDO, because we allocate all our memory up
+ * front and do not free and reallocate it. Sometimes we have problems using kmalloc, because the
+ * Linux memory page map can become so fragmented that kmalloc will not give us a 32KB chunk. We
+ * have used vmalloc as a backup to kmalloc in the past, and a follow-up vmalloc of 32KB will work.
+ * But there is no strong case to be made for using kmalloc over vmalloc for these size chunks.
+ *
+ * The kmalloc/vmalloc boundary is set at 4KB, and kmalloc gets the 4KB requests. There is no
+ * strong reason for favoring either kmalloc or vmalloc for 4KB requests, except that tracking
+ * vmalloc statistics uses a linked list implementation. Using a simple test, this choice of
+ * boundary results in 132 vmalloc calls. Using vmalloc for requests of exactly 4KB results in an
+ * additional 6374 vmalloc calls, which is much less efficient for tracking.
+ *
+ * @size: How many bytes to allocate
+ */
+static inline bool use_kmalloc(size_t size)
+{
+	return size <= PAGE_SIZE;
+}
+
+/*
+ * Allocate storage based on memory size and alignment, logging an error if the allocation fails.
+ * The memory will be zeroed.
+ *
+ * @size: The size of an object
+ * @align: The required alignment
+ * @what: What is being allocated (for error logging)
+ * @ptr: A pointer to hold the allocated memory
+ *
+ * Return: UDS_SUCCESS or an error code
+ */
+int uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
+{
+	/*
+	 * The __GFP_RETRY_MAYFAIL flag means the VM implementation will retry memory reclaim
+	 * procedures that have previously failed if there is some indication that progress has
+	 * been made elsewhere. It can wait for other tasks to attempt high level approaches to
+	 * freeing memory such as compaction (which removes fragmentation) and page-out. There is
+	 * still a definite limit to the number of retries, but it is a larger limit than with
+	 * __GFP_NORETRY. Allocations with this flag may fail, but only when there is genuinely
+	 * little unused memory. While these allocations do not directly trigger the OOM killer,
+	 * their failure indicates that the system is likely to need to use the OOM killer soon.
+	 * The caller must handle failure, but can reasonably do so by failing a higher-level
+	 * request, or completing it only in a much less efficient manner.
+	 */
+	const gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_RETRY_MAYFAIL;
+	unsigned int noio_flags;
+	bool allocations_restricted = !allocations_allowed();
+	unsigned long start_time;
+	void *p = NULL;
+
+	if (ptr == NULL)
+		return UDS_INVALID_ARGUMENT;
+
+	if (size == 0) {
+		*((void **) ptr) = NULL;
+		return UDS_SUCCESS;
+	}
+
+	if (allocations_restricted)
+		noio_flags = memalloc_noio_save();
+
+	start_time = jiffies;
+	if (use_kmalloc(size) && (align < PAGE_SIZE)) {
+		p = kmalloc(size, gfp_flags | __GFP_NOWARN);
+		if (p == NULL) {
+			/*
+			 * It is possible for kmalloc to fail to allocate memory because there is
+			 * no page available (see VDO-3688). A short sleep may allow the page
+			 * reclaimer to free a page.
+			 */
+			fsleep(1000);
+			p = kmalloc(size, gfp_flags);
+		}
+
+		if (p != NULL)
+			add_kmalloc_block(ksize(p));
+	} else {
+		struct vmalloc_block_info *block;
+
+		if (UDS_ALLOCATE(1, struct vmalloc_block_info, __func__, &block) ==
+		    UDS_SUCCESS) {
+			/*
+			 * It is possible for __vmalloc to fail to allocate memory because there
+			 * are no pages available (see VDO-3661). A short sleep may allow the page
+			 * reclaimer to free enough pages for a small allocation.
+			 *
+			 * For larger allocations, the page_alloc code is racing against the page
+			 * reclaimer. If the page reclaimer can stay ahead of page_alloc, the
+			 * __vmalloc will succeed. But if page_alloc overtakes the page reclaimer,
+			 * the allocation fails. It is possible that more retries will succeed.
+			 */
+			for (;;) {
+				p = __vmalloc(size, gfp_flags | __GFP_NOWARN);
+
+				if (p != NULL)
+					break;
+
+				if (jiffies_to_msecs(jiffies - start_time) > 1000) {
+					/* Try one more time, logging a failure for this call. */
+					p = __vmalloc(size, gfp_flags);
+					break;
+				}
+
+				fsleep(1000);
+			}
+
+			if (p == NULL) {
+				UDS_FREE(block);
+			} else {
+				block->ptr = p;
+				block->size = PAGE_ALIGN(size);
+				add_vmalloc_block(block);
+			}
+		}
+	}
+
+	if (allocations_restricted)
+		memalloc_noio_restore(noio_flags);
+
+	if (p == NULL) {
+		unsigned int duration = jiffies_to_msecs(jiffies - start_time);
+
+		uds_log_error("Could not allocate %zu bytes for %s in %u msecs",
+			      size,
+			      what,
+			      duration);
+		return -ENOMEM;
+	}
+
+	*((void **) ptr) = p;
+	return UDS_SUCCESS;
+}
+
+/*
+ * Allocate storage based on memory size, failing immediately if the required memory is not
+ * available. The memory will be zeroed.
+ *
+ * @size: The size of an object.
+ * @what: What is being allocated (for error logging)
+ *
+ * Return: pointer to the allocated memory, or NULL if the required space is not available.
+ */
+void *uds_allocate_memory_nowait(size_t size, const char *what __maybe_unused)
+{
+	void *p = kmalloc(size, GFP_NOWAIT | __GFP_ZERO);
+
+	if (p != NULL)
+		add_kmalloc_block(ksize(p));
+
+	return p;
+}
+
+void uds_free_memory(void *ptr)
+{
+	if (ptr != NULL) {
+		if (is_vmalloc_addr(ptr)) {
+			remove_vmalloc_block(ptr);
+			vfree(ptr);
+		} else {
+			remove_kmalloc_block(ksize(ptr));
+			kfree(ptr);
+		}
+	}
+}
+
+/*
+ * Reallocate dynamically allocated memory. There are no alignment guarantees for the reallocated
+ * memory. If the new memory is larger than the old memory, the new space will be zeroed.
+ *
+ * @ptr: The memory to reallocate.
+ * @old_size: The old size of the memory
+ * @size: The new size to allocate
+ * @what: What is being allocated (for error logging)
+ * @new_ptr: A pointer to hold the reallocated pointer
+ *
+ * Return: UDS_SUCCESS or an error code
+ */
+int uds_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *what, void *new_ptr)
+{
+	int result;
+
+	if (size == 0) {
+		UDS_FREE(ptr);
+		*(void **) new_ptr = NULL;
+		return UDS_SUCCESS;
+	}
+
+	result = UDS_ALLOCATE(size, char, what, new_ptr);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (ptr != NULL) {
+		if (old_size < size)
+			size = old_size;
+
+		memcpy(*((void **) new_ptr), ptr, size);
+		UDS_FREE(ptr);
+	}
+
+	return UDS_SUCCESS;
+}
+
+int uds_duplicate_string(const char *string, const char *what, char **new_string)
+{
+	int result;
+	u8 *dup;
+
+	result = UDS_ALLOCATE(strlen(string) + 1, u8, what, &dup);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	memcpy(dup, string, strlen(string) + 1);
+	*new_string = dup;
+	return UDS_SUCCESS;
+}
+
+void uds_memory_init(void)
+{
+	spin_lock_init(&memory_stats.lock);
+	uds_initialize_thread_registry(&allocating_threads);
+}
+
+void uds_memory_exit(void)
+{
+	ASSERT_LOG_ONLY(memory_stats.kmalloc_bytes == 0,
+			"kmalloc memory used (%zd bytes in %zd blocks) is returned to the kernel",
+			memory_stats.kmalloc_bytes,
+			memory_stats.kmalloc_blocks);
+	ASSERT_LOG_ONLY(memory_stats.vmalloc_bytes == 0,
+			"vmalloc memory used (%zd bytes in %zd blocks) is returned to the kernel",
+			memory_stats.vmalloc_bytes,
+			memory_stats.vmalloc_blocks);
+	uds_log_debug("peak usage %zd bytes", memory_stats.peak_bytes);
+}
+
+void uds_get_memory_stats(u64 *bytes_used, u64 *peak_bytes_used)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&memory_stats.lock, flags);
+	*bytes_used = memory_stats.kmalloc_bytes + memory_stats.vmalloc_bytes;
+	*peak_bytes_used = memory_stats.peak_bytes;
+	spin_unlock_irqrestore(&memory_stats.lock, flags);
+}
+
+/*
+ * Report stats on any allocated memory that we're tracking. Not all allocation types are
+ * guaranteed to be tracked in bytes (e.g., bios).
+ */
+void uds_report_memory_usage(void)
+{
+	unsigned long flags;
+	u64 kmalloc_blocks;
+	u64 kmalloc_bytes;
+	u64 vmalloc_blocks;
+	u64 vmalloc_bytes;
+	u64 peak_usage;
+	u64 total_bytes;
+
+	spin_lock_irqsave(&memory_stats.lock, flags);
+	kmalloc_blocks = memory_stats.kmalloc_blocks;
+	kmalloc_bytes = memory_stats.kmalloc_bytes;
+	vmalloc_blocks = memory_stats.vmalloc_blocks;
+	vmalloc_bytes = memory_stats.vmalloc_bytes;
+	peak_usage = memory_stats.peak_bytes;
+	spin_unlock_irqrestore(&memory_stats.lock, flags);
+	total_bytes = kmalloc_bytes + vmalloc_bytes;
+	uds_log_info("current module memory tracking (actual allocation sizes, not requested):");
+	uds_log_info("  %llu bytes in %llu kmalloc blocks",
+		     (unsigned long long) kmalloc_bytes,
+		     (unsigned long long) kmalloc_blocks);
+	uds_log_info("  %llu bytes in %llu vmalloc blocks",
+		     (unsigned long long) vmalloc_bytes,
+		     (unsigned long long) vmalloc_blocks);
+	uds_log_info("  total %llu bytes, peak usage %llu bytes",
+		     (unsigned long long) total_bytes,
+		     (unsigned long long) peak_usage);
+}
diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
new file mode 100644
index 00000000000..2ea2464326d
--- /dev/null
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -0,0 +1,181 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_MEMORY_ALLOC_H
+#define UDS_MEMORY_ALLOC_H
+
+#include <linux/cache.h>
+#include <linux/io.h> /* for PAGE_SIZE */
+
+#include "permassert.h"
+#include "thread-registry.h"
+
+/* Custom memory allocation functions for UDS that track memory usage */
+
+int __must_check uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr);
+
+void uds_free_memory(void *ptr);
+
+/* Free memory allocated with UDS_ALLOCATE(). */
+#define UDS_FREE(PTR) uds_free_memory(PTR)
+
+static inline void *uds_forget(void **ptr_ptr)
+{
+	void *ptr = *ptr_ptr;
+
+	*ptr_ptr = NULL;
+	return ptr;
+}
+
+/*
+ * Null out a pointer and return a copy to it. This macro should be used when passing a pointer to
+ * a function for which it is not safe to access the pointer once the function returns.
+ */
+#define UDS_FORGET(ptr) uds_forget((void **) &(ptr))
+
+/*
+ * Allocate storage based on element counts, sizes, and alignment.
+ *
+ * This is a generalized form of our allocation use case: It allocates an array of objects,
+ * optionally preceded by one object of another type (i.e., a struct with trailing variable-length
+ * array), with the alignment indicated.
+ *
+ * Why is this inline? The sizes and alignment will always be constant, when invoked through the
+ * macros below, and often the count will be a compile-time constant 1 or the number of extra bytes
+ * will be a compile-time constant 0. So at least some of the arithmetic can usually be optimized
+ * away, and the run-time selection between allocation functions always can. In many cases, it'll
+ * boil down to just a function call with a constant size.
+ *
+ * @count: The number of objects to allocate
+ * @size: The size of an object
+ * @extra: The number of additional bytes to allocate
+ * @align: The required alignment
+ * @what: What is being allocated (for error logging)
+ * @ptr: A pointer to hold the allocated memory
+ *
+ * Return: UDS_SUCCESS or an error code
+ */
+static inline int uds_do_allocation(size_t count,
+				    size_t size,
+				    size_t extra,
+				    size_t align,
+				    const char *what,
+				    void *ptr)
+{
+	size_t total_size = count * size + extra;
+
+	/* Overflow check: */
+	if ((size > 0) && (count > ((SIZE_MAX - extra) / size)))
+		/*
+		 * This is kind of a hack: We rely on the fact that SIZE_MAX would cover the entire
+		 * address space (minus one byte) and thus the system can never allocate that much
+		 * and the call will always fail. So we can report an overflow as "out of memory"
+		 * by asking for "merely" SIZE_MAX bytes.
+		 */
+		total_size = SIZE_MAX;
+
+	return uds_allocate_memory(total_size, align, what, ptr);
+}
+
+int __must_check uds_reallocate_memory(void *ptr,
+				       size_t old_size,
+				       size_t size,
+				       const char *what,
+				       void *new_ptr);
+
+/*
+ * Allocate one or more elements of the indicated type, logging an error if the allocation fails.
+ * The memory will be zeroed.
+ *
+ * @COUNT: The number of objects to allocate
+ * @TYPE: The type of objects to allocate. This type determines the alignment of the allocation.
+ * @WHAT: What is being allocated (for error logging)
+ * @PTR: A pointer to hold the allocated memory
+ *
+ * Return: UDS_SUCCESS or an error code
+ */
+#define UDS_ALLOCATE(COUNT, TYPE, WHAT, PTR) \
+	uds_do_allocation(COUNT, sizeof(TYPE), 0, __alignof__(TYPE), WHAT, PTR)
+
+/*
+ * Allocate one object of an indicated type, followed by one or more elements of a second type,
+ * logging an error if the allocation fails. The memory will be zeroed.
+ *
+ * @TYPE1: The type of the primary object to allocate. This type determines the alignment of the
+ *         allocated memory.
+ * @COUNT: The number of objects to allocate
+ * @TYPE2: The type of array objects to allocate
+ * @WHAT: What is being allocated (for error logging)
+ * @PTR: A pointer to hold the allocated memory
+ *
+ * Return: UDS_SUCCESS or an error code
+ */
+#define UDS_ALLOCATE_EXTENDED(TYPE1, COUNT, TYPE2, WHAT, PTR)            \
+	__extension__({                                                  \
+		int _result;						 \
+		TYPE1 **_ptr = (PTR);                                    \
+		STATIC_ASSERT(__alignof__(TYPE1) >= __alignof__(TYPE2)); \
+		_result = uds_do_allocation(COUNT,                       \
+					    sizeof(TYPE2),               \
+					    sizeof(TYPE1),               \
+					    __alignof__(TYPE1),          \
+					    WHAT,                        \
+					    _ptr);                       \
+		_result;                                                 \
+	})
+
+/*
+ * Allocate memory starting on a cache line boundary, logging an error if the allocation fails. The
+ * memory will be zeroed.
+ *
+ * @size: The number of bytes to allocate
+ * @what: What is being allocated (for error logging)
+ * @ptr: A pointer to hold the allocated memory
+ *
+ * Return: UDS_SUCCESS or an error code
+ */
+static inline int __must_check uds_allocate_cache_aligned(size_t size, const char *what, void *ptr)
+{
+	return uds_allocate_memory(size, L1_CACHE_BYTES, what, ptr);
+}
+
+void *__must_check uds_allocate_memory_nowait(size_t size, const char *what);
+
+/*
+ * Allocate one element of the indicated type immediately, failing if the required memory is not
+ * immediately available.
+ *
+ * @TYPE: The type of objects to allocate
+ * @WHAT: What is being allocated (for error logging)
+ *
+ * Return: pointer to the memory, or NULL if the memory is not available.
+ */
+#define UDS_ALLOCATE_NOWAIT(TYPE, WHAT) uds_allocate_memory_nowait(sizeof(TYPE), WHAT)
+
+int __must_check uds_duplicate_string(const char *string, const char *what, char **new_string);
+
+/* Wrapper which permits freeing a const pointer. */
+static inline void uds_free_const(const void *pointer)
+{
+	union {
+		const void *const_p;
+		void *not_const;
+	} u = { .const_p = pointer };
+	UDS_FREE(u.not_const);
+}
+
+void uds_memory_exit(void);
+
+void uds_memory_init(void);
+
+void uds_register_allocating_thread(struct registered_thread *new_thread, const bool *flag_ptr);
+
+void uds_unregister_allocating_thread(void);
+
+void uds_get_memory_stats(u64 *bytes_used, u64 *peak_bytes_used);
+
+void uds_report_memory_usage(void);
+
+#endif /* UDS_MEMORY_ALLOC_H */
diff --git a/drivers/md/dm-vdo/murmurhash3.c b/drivers/md/dm-vdo/murmurhash3.c
new file mode 100644
index 00000000000..c68d0d15390
--- /dev/null
+++ b/drivers/md/dm-vdo/murmurhash3.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: LGPL-2.1+
+/*
+ * MurmurHash3 was written by Austin Appleby, and is placed in the public
+ * domain. The author hereby disclaims copyright to this source code.
+ *
+ * Adapted by John Wiele (jwiele@redhat.com).
+ */
+
+#include "murmurhash3.h"
+
+static inline u64 rotl64(u64 x, s8 r)
+{
+	return (x << r) | (x >> (64 - r));
+}
+
+#define ROTL64(x, y) rotl64(x, y)
+static __always_inline u64 getblock64(const u64 *p, int i)
+{
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	return p[i];
+#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	return __builtin_bswap64(p[i]);
+#else
+#error "can't figure out byte order"
+#endif
+}
+
+static __always_inline void putblock64(u64 *p, int i, u64 value)
+{
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	p[i] = value;
+#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	p[i] = __builtin_bswap64(value);
+#else
+#error "can't figure out byte order"
+#endif
+}
+
+/* Finalization mix - force all bits of a hash block to avalanche */
+
+static __always_inline u64 fmix64(u64 k)
+{
+	k ^= k >> 33;
+	k *= 0xff51afd7ed558ccdLLU;
+	k ^= k >> 33;
+	k *= 0xc4ceb9fe1a85ec53LLU;
+	k ^= k >> 33;
+
+	return k;
+}
+
+void murmurhash3_128(const void *key, const int len, const u32 seed, void *out)
+{
+	const u8 *data = (const u8 *)key;
+	const int nblocks = len / 16;
+
+	u64 h1 = seed;
+	u64 h2 = seed;
+
+	const u64 c1 = 0x87c37b91114253d5LLU;
+	const u64 c2 = 0x4cf5ad432745937fLLU;
+
+	/* body */
+
+	const u64 *blocks = (const u64 *)(data);
+
+	int i;
+
+	for (i = 0; i < nblocks; i++) {
+		u64 k1 = getblock64(blocks, i * 2 + 0);
+		u64 k2 = getblock64(blocks, i * 2 + 1);
+
+		k1 *= c1;
+		k1 = ROTL64(k1, 31);
+		k1 *= c2;
+		h1 ^= k1;
+
+		h1 = ROTL64(h1, 27);
+		h1 += h2;
+		h1 = h1 * 5 + 0x52dce729;
+
+		k2 *= c2;
+		k2 = ROTL64(k2, 33);
+		k2 *= c1;
+		h2 ^= k2;
+
+		h2 = ROTL64(h2, 31);
+		h2 += h1;
+		h2 = h2 * 5 + 0x38495ab5;
+	}
+
+	/* tail */
+
+	{
+		const u8 *tail = (const u8 *)(data + nblocks * 16);
+
+		u64 k1 = 0;
+		u64 k2 = 0;
+
+		switch (len & 15) {
+		case 15:
+			k2 ^= ((u64)tail[14]) << 48;
+			fallthrough;
+		case 14:
+			k2 ^= ((u64)tail[13]) << 40;
+			fallthrough;
+		case 13:
+			k2 ^= ((u64)tail[12]) << 32;
+			fallthrough;
+		case 12:
+			k2 ^= ((u64)tail[11]) << 24;
+			fallthrough;
+		case 11:
+			k2 ^= ((u64)tail[10]) << 16;
+			fallthrough;
+		case 10:
+			k2 ^= ((u64)tail[9]) << 8;
+			fallthrough;
+		case 9:
+			k2 ^= ((u64)tail[8]) << 0;
+			k2 *= c2;
+			k2 = ROTL64(k2, 33);
+			k2 *= c1;
+			h2 ^= k2;
+			fallthrough;
+
+		case 8:
+			k1 ^= ((u64)tail[7]) << 56;
+			fallthrough;
+		case 7:
+			k1 ^= ((u64)tail[6]) << 48;
+			fallthrough;
+		case 6:
+			k1 ^= ((u64)tail[5]) << 40;
+			fallthrough;
+		case 5:
+			k1 ^= ((u64)tail[4]) << 32;
+			fallthrough;
+		case 4:
+			k1 ^= ((u64)tail[3]) << 24;
+			fallthrough;
+		case 3:
+			k1 ^= ((u64)tail[2]) << 16;
+			fallthrough;
+		case 2:
+			k1 ^= ((u64)tail[1]) << 8;
+			fallthrough;
+		case 1:
+			k1 ^= ((u64)tail[0]) << 0;
+			k1 *= c1;
+			k1 = ROTL64(k1, 31);
+			k1 *= c2;
+			h1 ^= k1;
+			break;
+		default:
+			break;
+		};
+	}
+	/* finalization */
+
+	h1 ^= len;
+	h2 ^= len;
+
+	h1 += h2;
+	h2 += h1;
+
+	h1 = fmix64(h1);
+	h2 = fmix64(h2);
+
+	h1 += h2;
+	h2 += h1;
+
+	putblock64((u64 *)out, 0, h1);
+	putblock64((u64 *)out, 1, h2);
+}
diff --git a/drivers/md/dm-vdo/murmurhash3.h b/drivers/md/dm-vdo/murmurhash3.h
new file mode 100644
index 00000000000..d84711ddb65
--- /dev/null
+++ b/drivers/md/dm-vdo/murmurhash3.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: LGPL-2.1+ */
+/*
+ * MurmurHash3 was written by Austin Appleby, and is placed in the public
+ * domain. The author hereby disclaims copyright to this source code.
+ */
+
+#ifndef _MURMURHASH3_H_
+#define _MURMURHASH3_H_
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+void murmurhash3_128(const void *key, int len, u32 seed, void *out);
+
+#endif /* _MURMURHASH3_H_ */
diff --git a/drivers/md/dm-vdo/numeric.h b/drivers/md/dm-vdo/numeric.h
new file mode 100644
index 00000000000..bd4ca019d1b
--- /dev/null
+++ b/drivers/md/dm-vdo/numeric.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_NUMERIC_H
+#define UDS_NUMERIC_H
+
+#include <asm/unaligned.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+/*
+ * These utilities encode or decode a number from an offset in a larger data buffer and then
+ * advance the offset pointer to the next field in the buffer.
+ */
+
+static inline void decode_s64_le(const u8 *buffer, size_t *offset, s64 *decoded)
+{
+	*decoded = get_unaligned_le64(buffer + *offset);
+	*offset += sizeof(s64);
+}
+
+static inline void encode_s64_le(u8 *data, size_t *offset, s64 to_encode)
+{
+	put_unaligned_le64(to_encode, data + *offset);
+	*offset += sizeof(s64);
+}
+
+static inline void decode_u64_le(const u8 *buffer, size_t *offset, u64 *decoded)
+{
+	*decoded = get_unaligned_le64(buffer + *offset);
+	*offset += sizeof(u64);
+}
+
+static inline void encode_u64_le(u8 *data, size_t *offset, u64 to_encode)
+{
+	put_unaligned_le64(to_encode, data + *offset);
+	*offset += sizeof(u64);
+}
+
+static inline void decode_s32_le(const u8 *buffer, size_t *offset, s32 *decoded)
+{
+	*decoded = get_unaligned_le32(buffer + *offset);
+	*offset += sizeof(s32);
+}
+
+static inline void encode_s32_le(u8 *data, size_t *offset, s32 to_encode)
+{
+	put_unaligned_le32(to_encode, data + *offset);
+	*offset += sizeof(s32);
+}
+
+static inline void decode_u32_le(const u8 *buffer, size_t *offset, u32 *decoded)
+{
+	*decoded = get_unaligned_le32(buffer + *offset);
+	*offset += sizeof(u32);
+}
+
+static inline void encode_u32_le(u8 *data, size_t *offset, u32 to_encode)
+{
+	put_unaligned_le32(to_encode, data + *offset);
+	*offset += sizeof(u32);
+}
+
+static inline void decode_u16_le(const u8 *buffer, size_t *offset, u16 *decoded)
+{
+	*decoded = get_unaligned_le16(buffer + *offset);
+	*offset += sizeof(u16);
+}
+
+static inline void encode_u16_le(u8 *data, size_t *offset, u16 to_encode)
+{
+	put_unaligned_le16(to_encode, data + *offset);
+	*offset += sizeof(u16);
+}
+
+#endif /* UDS_NUMERIC_H */
diff --git a/drivers/md/dm-vdo/open-chapter.c b/drivers/md/dm-vdo/open-chapter.c
new file mode 100644
index 00000000000..44a7c3b7f4f
--- /dev/null
+++ b/drivers/md/dm-vdo/open-chapter.c
@@ -0,0 +1,433 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "open-chapter.h"
+
+#include <linux/log2.h>
+
+#include "config.h"
+#include "hash-utils.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "numeric.h"
+#include "permassert.h"
+
+/*
+ * Each index zone has a dedicated open chapter zone structure which gets an equal share of the
+ * open chapter space. Records are assigned to zones based on their record name. Within each zone,
+ * records are stored in an array in the order they arrive. Additionally, a reference to each
+ * record is stored in a hash table to help determine if a new record duplicates an existing one.
+ * If new metadata for an existing name arrives, the record is altered in place. The array of
+ * records is 1-based so that record number 0 can be used to indicate an unused hash slot.
+ *
+ * Deleted records are marked with a flag rather than actually removed to simplify hash table
+ * management. The array of deleted flags overlays the array of hash slots, but the flags are
+ * indexed by record number instead of by record name. The number of hash slots will always be a
+ * power of two that is greater than the number of records to be indexed, guaranteeing that hash
+ * insertion cannot fail, and that there are sufficient flags for all records.
+ *
+ * Once any open chapter zone fills its available space, the chapter is closed. The records from
+ * each zone are interleaved to attempt to preserve temporal locality and assigned to record pages.
+ * Empty or deleted records are replaced by copies of a valid record so that the record pages only
+ * contain valid records. The chapter then constructs a delta index which maps each record name to
+ * the record page on which that record can be found, which is split into index pages. These
+ * structures are then passed to the volume to be recorded on storage.
+ *
+ * When the index is saved, the open chapter records are saved in a single array, once again
+ * interleaved to attempt to preserve temporal locality. When the index is reloaded, there may be a
+ * different number of zones than previously, so the records must be parcelled out to their new
+ * zones. In addition, depending on the distribution of record names, a new zone may have more
+ * records than it has space. In this case, the latest records for that zone will be discarded.
+ */
+
+static const u8 OPEN_CHAPTER_MAGIC[] = "ALBOC";
+static const u8 OPEN_CHAPTER_VERSION[] = "02.00";
+
+enum {
+	OPEN_CHAPTER_MAGIC_LENGTH = sizeof(OPEN_CHAPTER_MAGIC) - 1,
+	OPEN_CHAPTER_VERSION_LENGTH = sizeof(OPEN_CHAPTER_VERSION) - 1,
+	LOAD_RATIO = 2,
+};
+
+static inline size_t records_size(const struct open_chapter_zone *open_chapter)
+{
+	return sizeof(struct uds_volume_record) * (1 + open_chapter->capacity);
+}
+
+static inline size_t slots_size(size_t slot_count)
+{
+	return sizeof(struct open_chapter_zone_slot) * slot_count;
+}
+
+int uds_make_open_chapter(const struct geometry *geometry,
+			  unsigned int zone_count,
+			  struct open_chapter_zone **open_chapter_ptr)
+{
+	int result;
+	struct open_chapter_zone *open_chapter;
+	size_t capacity = geometry->records_per_chapter / zone_count;
+	size_t slot_count = (1 << bits_per(capacity * LOAD_RATIO));
+
+	result = UDS_ALLOCATE_EXTENDED(struct open_chapter_zone,
+				       slot_count,
+				       struct open_chapter_zone_slot,
+				       "open chapter",
+				       &open_chapter);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	open_chapter->slot_count = slot_count;
+	open_chapter->capacity = capacity;
+	result = uds_allocate_cache_aligned(records_size(open_chapter),
+					    "record pages",
+					    &open_chapter->records);
+	if (result != UDS_SUCCESS) {
+		uds_free_open_chapter(open_chapter);
+		return result;
+	}
+
+	*open_chapter_ptr = open_chapter;
+	return UDS_SUCCESS;
+}
+
+void uds_reset_open_chapter(struct open_chapter_zone *open_chapter)
+{
+	open_chapter->size = 0;
+	open_chapter->deletions = 0;
+
+	memset(open_chapter->records, 0, records_size(open_chapter));
+	memset(open_chapter->slots, 0, slots_size(open_chapter->slot_count));
+}
+
+static unsigned int
+probe_chapter_slots(struct open_chapter_zone *open_chapter, const struct uds_record_name *name)
+{
+	struct uds_volume_record *record;
+	unsigned int slot_count = open_chapter->slot_count;
+	unsigned int slot = uds_name_to_hash_slot(name, slot_count);
+	unsigned int record_number;
+	unsigned int attempts = 1;
+
+	while (true) {
+		record_number = open_chapter->slots[slot].record_number;
+
+		/*
+		 * If the hash slot is empty, we've reached the end of a chain without finding the
+		 * record and should terminate the search.
+		 */
+		if (record_number == 0)
+			return slot;
+
+		/*
+		 * If the name of the record referenced by the slot matches and has not been
+		 * deleted, then we've found the requested name.
+		 */
+		record = &open_chapter->records[record_number];
+		if ((memcmp(&record->name, name, UDS_RECORD_NAME_SIZE) == 0) &&
+		    !open_chapter->slots[record_number].deleted)
+			return slot;
+
+		/*
+		 * Quadratic probing: advance the probe by 1, 2, 3, etc. and try again. This
+		 * performs better than linear probing and works best for 2^N slots.
+		 */
+		slot = (slot + attempts++) % slot_count;
+	}
+}
+
+void uds_search_open_chapter(struct open_chapter_zone *open_chapter,
+			     const struct uds_record_name *name,
+			     struct uds_record_data *metadata,
+			     bool *found)
+{
+	unsigned int slot;
+	unsigned int record_number;
+
+	slot = probe_chapter_slots(open_chapter, name);
+	record_number = open_chapter->slots[slot].record_number;
+	if (record_number == 0) {
+		*found = false;
+	} else {
+		*found = true;
+		*metadata = open_chapter->records[record_number].data;
+	}
+}
+
+/* Add a record to the open chapter zone and return the remaining space. */
+int uds_put_open_chapter(struct open_chapter_zone *open_chapter,
+			 const struct uds_record_name *name,
+			 const struct uds_record_data *metadata)
+{
+	unsigned int slot;
+	unsigned int record_number;
+	struct uds_volume_record *record;
+
+	if (open_chapter->size >= open_chapter->capacity)
+		return 0;
+
+	slot = probe_chapter_slots(open_chapter, name);
+	record_number = open_chapter->slots[slot].record_number;
+
+	if (record_number == 0) {
+		record_number = ++open_chapter->size;
+		open_chapter->slots[slot].record_number = record_number;
+	}
+
+	record = &open_chapter->records[record_number];
+	record->name = *name;
+	record->data = *metadata;
+
+	return open_chapter->capacity - open_chapter->size;
+}
+
+void uds_remove_from_open_chapter(struct open_chapter_zone *open_chapter,
+				  const struct uds_record_name *name)
+{
+	unsigned int slot;
+	unsigned int record_number;
+
+	slot = probe_chapter_slots(open_chapter, name);
+	record_number = open_chapter->slots[slot].record_number;
+
+	if (record_number > 0) {
+		open_chapter->slots[record_number].deleted = true;
+		open_chapter->deletions += 1;
+	}
+}
+
+void uds_free_open_chapter(struct open_chapter_zone *open_chapter)
+{
+	if (open_chapter != NULL) {
+		UDS_FREE(open_chapter->records);
+		UDS_FREE(open_chapter);
+	}
+}
+
+/* Map each record name to its record page number in the delta chapter index. */
+static int fill_delta_chapter_index(struct open_chapter_zone **chapter_zones,
+				    unsigned int zone_count,
+				    struct open_chapter_index *index,
+				    struct uds_volume_record *collated_records)
+{
+	int result;
+	unsigned int records_per_chapter;
+	unsigned int records_per_page;
+	unsigned int record_index;
+	unsigned int records = 0;
+	u32 page_number;
+	unsigned int z;
+	int overflow_count = 0;
+	struct uds_volume_record *fill_record = NULL;
+
+	/*
+	 * The record pages should not have any empty space, so find a record with which to fill
+	 * the chapter zone if it was closed early, and also to replace any deleted records. The
+	 * last record in any filled zone is guaranteed to not have been deleted, so use one of
+	 * those.
+	 */
+	for (z = 0; z < zone_count; z++) {
+		struct open_chapter_zone *zone = chapter_zones[z];
+
+		if (zone->size == zone->capacity) {
+			fill_record = &zone->records[zone->size];
+			break;
+		}
+	}
+
+	records_per_chapter = index->geometry->records_per_chapter;
+	records_per_page = index->geometry->records_per_page;
+
+	for (records = 0; records < records_per_chapter; records++) {
+		struct uds_volume_record *record = &collated_records[records];
+		struct open_chapter_zone *open_chapter;
+
+		/* The record arrays in the zones are 1-based. */
+		record_index = 1 + (records / zone_count);
+		page_number = records / records_per_page;
+		open_chapter = chapter_zones[records % zone_count];
+
+		/* Use the fill record in place of an unused record. */
+		if (record_index > open_chapter->size ||
+		    open_chapter->slots[record_index].deleted) {
+			*record = *fill_record;
+			continue;
+		}
+
+		*record = open_chapter->records[record_index];
+		result = uds_put_open_chapter_index_record(index, &record->name, page_number);
+		switch (result) {
+		case UDS_SUCCESS:
+			break;
+		case UDS_OVERFLOW:
+			overflow_count++;
+			break;
+		default:
+			uds_log_error_strerror(result, "failed to build open chapter index");
+			return result;
+		}
+	}
+
+	if (overflow_count > 0)
+		uds_log_warning("Failed to add %d entries to chapter index", overflow_count);
+
+	return UDS_SUCCESS;
+}
+
+int uds_close_open_chapter(struct open_chapter_zone **chapter_zones,
+			   unsigned int zone_count,
+			   struct volume *volume,
+			   struct open_chapter_index *chapter_index,
+			   struct uds_volume_record *collated_records,
+			   u64 virtual_chapter_number)
+{
+	int result;
+
+	uds_empty_open_chapter_index(chapter_index, virtual_chapter_number);
+	result = fill_delta_chapter_index(chapter_zones,
+					  zone_count,
+					  chapter_index,
+					  collated_records);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	return uds_write_chapter(volume, chapter_index, collated_records);
+}
+
+int uds_save_open_chapter(struct uds_index *index, struct buffered_writer *writer)
+{
+	int result;
+	struct open_chapter_zone *open_chapter;
+	struct uds_volume_record *record;
+	u8 record_count_data[sizeof(u32)];
+	u32 record_count = 0;
+	unsigned int record_index;
+	unsigned int z;
+
+	result = uds_write_to_buffered_writer(writer,
+					      OPEN_CHAPTER_MAGIC,
+					      OPEN_CHAPTER_MAGIC_LENGTH);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_write_to_buffered_writer(writer,
+					      OPEN_CHAPTER_VERSION,
+					      OPEN_CHAPTER_VERSION_LENGTH);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	for (z = 0; z < index->zone_count; z++) {
+		open_chapter = index->zones[z]->open_chapter;
+		record_count += open_chapter->size - open_chapter->deletions;
+	}
+
+	put_unaligned_le32(record_count, record_count_data);
+	result = uds_write_to_buffered_writer(writer,
+					      record_count_data,
+					      sizeof(record_count_data));
+	if (result != UDS_SUCCESS)
+		return result;
+
+	record_index = 1;
+	while (record_count > 0) {
+		for (z = 0; z < index->zone_count; z++) {
+			open_chapter = index->zones[z]->open_chapter;
+			if (record_index > open_chapter->size)
+				continue;
+
+			if (open_chapter->slots[record_index].deleted)
+				continue;
+
+			record = &open_chapter->records[record_index];
+			result = uds_write_to_buffered_writer(writer,
+							      (u8 *) record,
+							      sizeof(*record));
+			if (result != UDS_SUCCESS)
+				return result;
+
+			record_count--;
+		}
+
+		record_index++;
+	}
+
+	return uds_flush_buffered_writer(writer);
+}
+
+u64 uds_compute_saved_open_chapter_size(struct geometry *geometry)
+{
+	unsigned int records_per_chapter = geometry->records_per_chapter;
+
+	return OPEN_CHAPTER_MAGIC_LENGTH + OPEN_CHAPTER_VERSION_LENGTH + sizeof(u32) +
+		records_per_chapter * sizeof(struct uds_volume_record);
+}
+
+static int load_version20(struct uds_index *index, struct buffered_reader *reader)
+{
+	int result;
+	u32 record_count;
+	u8 record_count_data[sizeof(u32)];
+	struct uds_volume_record record;
+
+	/*
+	 * Track which zones cannot accept any more records. If the open chapter had a different
+	 * number of zones previously, some new zones may have more records than they have space
+	 * for. These overflow records will be discarded.
+	 */
+	bool full_flags[MAX_ZONES] = {
+		false,
+	};
+
+	result = uds_read_from_buffered_reader(reader,
+					       (u8 *) &record_count_data,
+					       sizeof(record_count_data));
+	if (result != UDS_SUCCESS)
+		return result;
+
+	record_count = get_unaligned_le32(record_count_data);
+	while (record_count-- > 0) {
+		unsigned int zone = 0;
+
+		result = uds_read_from_buffered_reader(reader, (u8 *) &record, sizeof(record));
+		if (result != UDS_SUCCESS)
+			return result;
+
+		if (index->zone_count > 1)
+			zone = uds_get_volume_index_zone(index->volume_index, &record.name);
+
+		if (!full_flags[zone]) {
+			struct open_chapter_zone *open_chapter;
+			unsigned int remaining;
+
+			open_chapter = index->zones[zone]->open_chapter;
+			remaining = uds_put_open_chapter(open_chapter, &record.name, &record.data);
+			/* Do not allow any zone to fill completely. */
+			full_flags[zone] = (remaining <= 1);
+		}
+	}
+
+	return UDS_SUCCESS;
+}
+
+int uds_load_open_chapter(struct uds_index *index, struct buffered_reader *reader)
+{
+	u8 version[OPEN_CHAPTER_VERSION_LENGTH];
+	int result;
+
+	result = uds_verify_buffered_data(reader, OPEN_CHAPTER_MAGIC, OPEN_CHAPTER_MAGIC_LENGTH);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_read_from_buffered_reader(reader, version, sizeof(version));
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (memcmp(OPEN_CHAPTER_VERSION, version, sizeof(version)) != 0)
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "Invalid open chapter version: %.*s",
+					      (int) sizeof(version),
+					      version);
+
+	return load_version20(index, reader);
+}
diff --git a/drivers/md/dm-vdo/open-chapter.h b/drivers/md/dm-vdo/open-chapter.h
new file mode 100644
index 00000000000..ac27280f9d6
--- /dev/null
+++ b/drivers/md/dm-vdo/open-chapter.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_OPEN_CHAPTER_H
+#define UDS_OPEN_CHAPTER_H
+
+#include "chapter-index.h"
+#include "geometry.h"
+#include "index.h"
+#include "volume.h"
+
+/*
+ * The open chapter tracks the newest records in memory. Like the index as a whole, each open
+ * chapter is divided into a number of independent zones which are interleaved when the chapter is
+ * committed to the volume.
+ */
+
+enum {
+	OPEN_CHAPTER_RECORD_NUMBER_BITS = 23,
+};
+
+struct open_chapter_zone_slot {
+	/* If non-zero, the record number addressed by this hash slot */
+	unsigned int record_number : OPEN_CHAPTER_RECORD_NUMBER_BITS;
+	/* If true, the record at the index of this hash slot was deleted */
+	bool deleted : 1;
+} __packed;
+
+struct open_chapter_zone {
+	/* The maximum number of records that can be stored */
+	unsigned int capacity;
+	/* The number of records stored */
+	unsigned int size;
+	/* The number of deleted records */
+	unsigned int deletions;
+	/* Array of chunk records, 1-based */
+	struct uds_volume_record *records;
+	/* The number of slots in the hash table */
+	unsigned int slot_count;
+	/* The hash table slots, referencing virtual record numbers */
+	struct open_chapter_zone_slot slots[];
+};
+
+int __must_check uds_make_open_chapter(const struct geometry *geometry,
+				       unsigned int zone_count,
+				       struct open_chapter_zone **open_chapter_ptr);
+
+void uds_reset_open_chapter(struct open_chapter_zone *open_chapter);
+
+void uds_search_open_chapter(struct open_chapter_zone *open_chapter,
+			     const struct uds_record_name *name,
+			     struct uds_record_data *metadata,
+			     bool *found);
+
+int __must_check uds_put_open_chapter(struct open_chapter_zone *open_chapter,
+				      const struct uds_record_name *name,
+				      const struct uds_record_data *metadata);
+
+void uds_remove_from_open_chapter(struct open_chapter_zone *open_chapter,
+				  const struct uds_record_name *name);
+
+void uds_free_open_chapter(struct open_chapter_zone *open_chapter);
+
+int __must_check uds_close_open_chapter(struct open_chapter_zone **chapter_zones,
+					unsigned int zone_count,
+					struct volume *volume,
+					struct open_chapter_index *chapter_index,
+					struct uds_volume_record *collated_records,
+					u64 virtual_chapter_number);
+
+int __must_check uds_save_open_chapter(struct uds_index *index, struct buffered_writer *writer);
+
+int __must_check uds_load_open_chapter(struct uds_index *index, struct buffered_reader *reader);
+
+u64 uds_compute_saved_open_chapter_size(struct geometry *geometry);
+
+#endif /* UDS_OPEN_CHAPTER_H */
diff --git a/drivers/md/dm-vdo/permassert.c b/drivers/md/dm-vdo/permassert.c
new file mode 100644
index 00000000000..6c20372eb3a
--- /dev/null
+++ b/drivers/md/dm-vdo/permassert.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "permassert.h"
+
+#include "errors.h"
+#include "logger.h"
+
+int uds_assertion_failed(const char *expression_string,
+			 const char *file_name,
+			 int line_number,
+			 const char *format,
+			 ...)
+{
+	va_list args;
+
+	va_start(args, format);
+
+	uds_log_embedded_message(UDS_LOG_ERR,
+				 UDS_LOGGING_MODULE_NAME,
+				 "assertion \"",
+				 format,
+				 args,
+				 "\" (%s) failed at %s:%d",
+				 expression_string,
+				 file_name,
+				 line_number);
+	uds_log_backtrace(UDS_LOG_ERR);
+
+	va_end(args);
+
+	return UDS_ASSERTION_FAILED;
+}
diff --git a/drivers/md/dm-vdo/permassert.h b/drivers/md/dm-vdo/permassert.h
new file mode 100644
index 00000000000..224652c88de
--- /dev/null
+++ b/drivers/md/dm-vdo/permassert.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef PERMASSERT_H
+#define PERMASSERT_H
+
+#include <linux/compiler.h>
+
+#include "errors.h"
+
+/* Utilities for asserting that certain conditions are met */
+
+#define STRINGIFY(X) #X
+#define STRINGIFY_VALUE(X) STRINGIFY(X)
+
+/*
+ * A hack to apply the "warn if unused" attribute to an integral expression.
+ *
+ * Since GCC doesn't propagate the warn_unused_result attribute to conditional expressions
+ * incorporating calls to functions with that attribute, this function can be used to wrap such an
+ * expression. With optimization enabled, this function contributes no additional instructions, but
+ * the warn_unused_result attribute still applies to the code calling it.
+ */
+static inline int __must_check uds_must_use(int value)
+{
+	return value;
+}
+
+/* Assert that an expression is true and return an error if it is not. */
+#define ASSERT(expr, ...) uds_must_use(__UDS_ASSERT(expr, __VA_ARGS__))
+
+/* Log a message if the expression is not true. */
+#define ASSERT_LOG_ONLY(expr, ...) __UDS_ASSERT(expr, __VA_ARGS__)
+
+#define __UDS_ASSERT(expr, ...)				      \
+	(likely(expr) ? UDS_SUCCESS			      \
+		      : uds_assertion_failed(STRINGIFY(expr), __FILE__, __LINE__, __VA_ARGS__))
+
+/* Log an assertion failure message. */
+int uds_assertion_failed(const char *expression_string,
+			 const char *file_name,
+			 int line_number,
+			 const char *format,
+			 ...)
+	__printf(4, 5);
+
+#define STATIC_ASSERT(expr)	     \
+	do {			     \
+		switch (0) {	     \
+		case 0:		     \
+			;	     \
+			fallthrough; \
+		case expr:	     \
+			;	     \
+			fallthrough; \
+		default:	     \
+			break;	     \
+		}		     \
+	} while (0)
+
+#define STATIC_ASSERT_SIZEOF(type, expected_size) STATIC_ASSERT(sizeof(type) == (expected_size))
+
+#endif /* PERMASSERT_H */
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
diff --git a/drivers/md/dm-vdo/request-queue.c b/drivers/md/dm-vdo/request-queue.c
new file mode 100644
index 00000000000..058422f44d9
--- /dev/null
+++ b/drivers/md/dm-vdo/request-queue.c
@@ -0,0 +1,284 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "request-queue.h"
+
+#include <linux/atomic.h>
+#include <linux/compiler.h>
+#include <linux/wait.h>
+
+#include "funnel-queue.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "uds-threads.h"
+
+/*
+ * This queue will attempt to handle requests in reasonably sized batches instead of reacting
+ * immediately to each new request. The wait time between batches is dynamically adjusted up or
+ * down to try to balance responsiveness against wasted thread run time.
+ *
+ * If the wait time becomes long enough, the queue will become dormant and must be explicitly
+ * awoken when a new request is enqueued. The enqueue operation updates "newest" in the funnel
+ * queue via xchg (which is a memory barrier), and later checks "dormant" to decide whether to do a
+ * wakeup of the worker thread.
+ *
+ * When deciding to go to sleep, the worker thread sets "dormant" and then examines "newest" to
+ * decide if the funnel queue is idle. In dormant mode, the last examination of "newest" before
+ * going to sleep is done inside the wait_event_interruptible() macro, after a point where one or
+ * more memory barriers have been issued. (Preparing to sleep uses spin locks.) Even if the funnel
+ * queue's "next" field update isn't visible yet to make the entry accessible, its existence will
+ * kick the worker thread out of dormant mode and back into timer-based mode.
+ *
+ * Unbatched requests are used to communicate between different zone threads and will also cause
+ * the queue to awaken immediately.
+ */
+
+enum {
+	NANOSECOND = 1,
+	MICROSECOND = 1000 * NANOSECOND,
+	MILLISECOND = 1000 * MICROSECOND,
+	DEFAULT_WAIT_TIME = 20 * MICROSECOND,
+	MINIMUM_WAIT_TIME = DEFAULT_WAIT_TIME / 2,
+	MAXIMUM_WAIT_TIME = MILLISECOND,
+	MINIMUM_BATCH = 32,
+	MAXIMUM_BATCH = 64,
+};
+
+struct uds_request_queue {
+	/* Wait queue for synchronizing producers and consumer */
+	struct wait_queue_head wait_head;
+	/* Function to process a request */
+	uds_request_queue_processor_t *processor;
+	/* Queue of new incoming requests */
+	struct funnel_queue *main_queue;
+	/* Queue of old requests to retry */
+	struct funnel_queue *retry_queue;
+	/* The thread id of the worker thread */
+	struct thread *thread;
+	/* True if the worker was started */
+	bool started;
+	/* When true, requests can be enqueued */
+	bool running;
+	/* A flag set when the worker is waiting without a timeout */
+	atomic_t dormant;
+};
+
+static inline struct uds_request *poll_queues(struct uds_request_queue *queue)
+{
+	struct funnel_queue_entry *entry;
+
+	entry = uds_funnel_queue_poll(queue->retry_queue);
+	if (entry != NULL)
+		return container_of(entry, struct uds_request, queue_link);
+
+	entry = uds_funnel_queue_poll(queue->main_queue);
+	if (entry != NULL)
+		return container_of(entry, struct uds_request, queue_link);
+
+	return NULL;
+}
+
+static inline bool are_queues_idle(struct uds_request_queue *queue)
+{
+	return uds_is_funnel_queue_idle(queue->retry_queue) &&
+	       uds_is_funnel_queue_idle(queue->main_queue);
+}
+
+/*
+ * Determine if there is a next request to process, and return it if there is. Also return flags
+ * indicating whether the worker thread can sleep (for the use of wait_event() macros) and whether
+ * the thread did sleep before returning a new request.
+ */
+static inline bool dequeue_request(struct uds_request_queue *queue,
+				   struct uds_request **request_ptr,
+				   bool *waited_ptr)
+{
+	struct uds_request *request = poll_queues(queue);
+
+	if (request != NULL) {
+		*request_ptr = request;
+		return true;
+	}
+
+	if (!READ_ONCE(queue->running)) {
+		/* Wake the worker thread so it can exit. */
+		*request_ptr = NULL;
+		return true;
+	}
+
+	*request_ptr = NULL;
+	*waited_ptr = true;
+	return false;
+}
+
+static void wait_for_request(struct uds_request_queue *queue,
+			     bool dormant,
+			     unsigned long timeout,
+			     struct uds_request **request,
+			     bool *waited)
+{
+	if (dormant) {
+		wait_event_interruptible(queue->wait_head,
+					 (dequeue_request(queue, request, waited) ||
+					  !are_queues_idle(queue)));
+		return;
+	}
+
+	wait_event_interruptible_hrtimeout(queue->wait_head,
+					   dequeue_request(queue, request, waited),
+					   ns_to_ktime(timeout));
+}
+
+static void request_queue_worker(void *arg)
+{
+	struct uds_request_queue *queue = (struct uds_request_queue *) arg;
+	struct uds_request *request = NULL;
+	unsigned long time_batch = DEFAULT_WAIT_TIME;
+	bool dormant = atomic_read(&queue->dormant);
+	bool waited = false;
+	long current_batch = 0;
+
+	for (;;) {
+		wait_for_request(queue, dormant, time_batch, &request, &waited);
+		if (likely(request != NULL)) {
+			current_batch++;
+			queue->processor(request);
+		} else if (!READ_ONCE(queue->running)) {
+			break;
+		}
+
+		if (dormant) {
+			/*
+			 * The queue has been roused from dormancy. Clear the flag so enqueuers can
+			 * stop broadcasting. No fence is needed for this transition.
+			 */
+			atomic_set(&queue->dormant, false);
+			dormant = false;
+			time_batch = DEFAULT_WAIT_TIME;
+		} else if (waited) {
+			/*
+			 * We waited for this request to show up. Adjust the wait time to smooth
+			 * out the batch size.
+			 */
+			if (current_batch < MINIMUM_BATCH) {
+				/*
+				 * If the last batch of requests was too small, increase the wait
+				 * time.
+				 */
+				time_batch += time_batch / 4;
+				if (time_batch >= MAXIMUM_WAIT_TIME) {
+					atomic_set(&queue->dormant, true);
+					dormant = true;
+				}
+			} else if (current_batch > MAXIMUM_BATCH) {
+				/*
+				 * If the last batch of requests was too large, decrease the wait
+				 * time.
+				 */
+				time_batch -= time_batch / 4;
+				if (time_batch < MINIMUM_WAIT_TIME)
+					time_batch = MINIMUM_WAIT_TIME;
+			}
+			current_batch = 0;
+		}
+	}
+
+	/*
+	 * Ensure that we process any remaining requests that were enqueued before trying to shut
+	 * down. The corresponding write barrier is in uds_request_queue_finish().
+	 */
+	smp_rmb();
+	while ((request = poll_queues(queue)) != NULL)
+		queue->processor(request);
+}
+
+int uds_make_request_queue(const char *queue_name,
+			   uds_request_queue_processor_t *processor,
+			   struct uds_request_queue **queue_ptr)
+{
+	int result;
+	struct uds_request_queue *queue;
+
+	result = UDS_ALLOCATE(1, struct uds_request_queue, __func__, &queue);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	queue->processor = processor;
+	queue->running = true;
+	atomic_set(&queue->dormant, false);
+	init_waitqueue_head(&queue->wait_head);
+
+	result = uds_make_funnel_queue(&queue->main_queue);
+	if (result != UDS_SUCCESS) {
+		uds_request_queue_finish(queue);
+		return result;
+	}
+
+	result = uds_make_funnel_queue(&queue->retry_queue);
+	if (result != UDS_SUCCESS) {
+		uds_request_queue_finish(queue);
+		return result;
+	}
+
+	result = uds_create_thread(request_queue_worker, queue, queue_name, &queue->thread);
+	if (result != UDS_SUCCESS) {
+		uds_request_queue_finish(queue);
+		return result;
+	}
+
+	queue->started = true;
+	*queue_ptr = queue;
+	return UDS_SUCCESS;
+}
+
+static inline void wake_up_worker(struct uds_request_queue *queue)
+{
+	if (wq_has_sleeper(&queue->wait_head))
+		wake_up(&queue->wait_head);
+}
+
+void uds_request_queue_enqueue(struct uds_request_queue *queue, struct uds_request *request)
+{
+	struct funnel_queue *sub_queue;
+	bool unbatched = request->unbatched;
+
+	sub_queue = request->requeued ? queue->retry_queue : queue->main_queue;
+	uds_funnel_queue_put(sub_queue, &request->queue_link);
+
+	/*
+	 * We must wake the worker thread when it is dormant. A read fence isn't needed here since
+	 * we know the queue operation acts as one.
+	 */
+	if (atomic_read(&queue->dormant) || unbatched)
+		wake_up_worker(queue);
+}
+
+void uds_request_queue_finish(struct uds_request_queue *queue)
+{
+	int result;
+
+	if (queue == NULL)
+		return;
+
+	/*
+	 * This memory barrier ensures that any requests we queued will be seen. The point is that
+	 * when dequeue_request() sees the following update to the running flag, it will also be
+	 * able to see any change we made to a next field in the funnel queue entry. The
+	 * corresponding read barrier is in request_queue_worker().
+	 */
+	smp_wmb();
+	WRITE_ONCE(queue->running, false);
+
+	if (queue->started) {
+		wake_up_worker(queue);
+		result = uds_join_threads(queue->thread);
+		if (result != UDS_SUCCESS)
+			uds_log_warning_strerror(result, "Failed to join worker thread");
+	}
+
+	uds_free_funnel_queue(queue->main_queue);
+	uds_free_funnel_queue(queue->retry_queue);
+	UDS_FREE(queue);
+}
diff --git a/drivers/md/dm-vdo/request-queue.h b/drivers/md/dm-vdo/request-queue.h
new file mode 100644
index 00000000000..e736072b35a
--- /dev/null
+++ b/drivers/md/dm-vdo/request-queue.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_REQUEST_QUEUE_H
+#define UDS_REQUEST_QUEUE_H
+
+#include "uds.h"
+
+/*
+ * A simple request queue which will handle new requests in the order in which they are received,
+ * and will attempt to handle requeued requests before new ones. However, the nature of the
+ * implementation means that it cannot guarantee this ordering; the prioritization is merely a
+ * hint.
+ */
+
+struct uds_request_queue;
+
+typedef void uds_request_queue_processor_t(struct uds_request *);
+
+int __must_check uds_make_request_queue(const char *queue_name,
+					uds_request_queue_processor_t *processor,
+					struct uds_request_queue **queue_ptr);
+
+void uds_request_queue_enqueue(struct uds_request_queue *queue, struct uds_request *request);
+
+void uds_request_queue_finish(struct uds_request_queue *queue);
+
+#endif /* UDS_REQUEST_QUEUE_H */
diff --git a/drivers/md/dm-vdo/sparse-cache.c b/drivers/md/dm-vdo/sparse-cache.c
new file mode 100644
index 00000000000..3a88392adca
--- /dev/null
+++ b/drivers/md/dm-vdo/sparse-cache.c
@@ -0,0 +1,595 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "sparse-cache.h"
+
+#include <linux/cache.h>
+#include <linux/dm-bufio.h>
+
+#include "chapter-index.h"
+#include "config.h"
+#include "index.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+#include "uds-threads.h"
+
+/*
+ * Since the cache is small, it is implemented as a simple array of cache entries. Searching for a
+ * specific virtual chapter is implemented as a linear search. The cache replacement policy is
+ * least-recently-used (LRU). Again, the small size of the cache allows the LRU order to be
+ * maintained by shifting entries in an array list.
+ *
+ * Changing the contents of the cache requires the coordinated participation of all zone threads
+ * via the careful use of barrier messages sent to all the index zones by the triage queue worker
+ * thread. The critical invariant for coordination is that the cache membership must not change
+ * between updates, so that all calls to uds_sparse_cache_contains() from the zone threads must all
+ * receive the same results for every virtual chapter number. To ensure that critical invariant,
+ * state changes such as "that virtual chapter is no longer in the volume" and "skip searching that
+ * chapter because it has had too many cache misses" are represented separately from the cache
+ * membership information (the virtual chapter number).
+ *
+ * As a result of this invariant, we have the guarantee that every zone thread will call
+ * uds_update_sparse_cache() once and exactly once to request a chapter that is not in the cache,
+ * and the serialization of the barrier requests from the triage queue ensures they will all
+ * request the same chapter number. This means the only synchronization we need can be provided by
+ * a pair of thread barriers used only in the uds_update_sparse_cache() call, providing a critical
+ * section where a single zone thread can drive the cache update while all the other zone threads
+ * are known to be blocked, waiting in the second barrier. Outside that critical section, all the
+ * zone threads implicitly hold a shared lock. Inside it, the thread for zone zero holds an
+ * exclusive lock. No other threads may access or modify the cache entries.
+ *
+ * Chapter statistics must only be modified by a single thread, which is also the zone zero thread.
+ * All fields that might be frequently updated by that thread are kept in separate cache-aligned
+ * structures so they will not cause cache contention via "false sharing" with the fields that are
+ * frequently accessed by all of the zone threads.
+ *
+ * The LRU order is managed independently by each zone thread, and each zone uses its own list for
+ * searching and cache membership queries. The zone zero list is used to decide which chapter to
+ * evict when the cache is updated, and its search list is copied to the other threads at that
+ * time.
+ *
+ * The virtual chapter number field of the cache entry is the single field indicating whether a
+ * chapter is a member of the cache or not. The value NO_CHAPTER is used to represent a null or
+ * undefined chapter number. When present in the virtual chapter number field of a
+ * cached_chapter_index, it indicates that the cache entry is dead, and all the other fields of
+ * that entry (other than immutable pointers to cache memory) are undefined and irrelevant. Any
+ * cache entry that is not marked as dead is fully defined and a member of the cache, and
+ * uds_sparse_cache_contains() will always return true for any virtual chapter number that appears
+ * in any of the cache entries.
+ *
+ * A chapter index that is a member of the cache may be excluded from searches between calls to
+ * uds_update_sparse_cache() in two different ways. First, when a chapter falls off the end of the
+ * volume, its virtual chapter number will be less that the oldest virtual chapter number. Since
+ * that chapter is no longer part of the volume, there's no point in continuing to search that
+ * chapter index. Once invalidated, that virtual chapter will still be considered a member of the
+ * cache, but it will no longer be searched for matching names.
+ *
+ * The second mechanism is a heuristic based on keeping track of the number of consecutive search
+ * misses in a given chapter index. Once that count exceeds a threshold, the skip_search flag will
+ * be set to true, causing the chapter to be skipped when searching the entire cache, but still
+ * allowing it to be found when searching for a hook in that specific chapter. Finding a hook will
+ * clear the skip_search flag, once again allowing the non-hook searches to use that cache entry.
+ * Again, regardless of the state of the skip_search flag, the virtual chapter must still
+ * considered to be a member of the cache for uds_sparse_cache_contains().
+ */
+
+enum {
+	SKIP_SEARCH_THRESHOLD = 20000,
+	ZONE_ZERO = 0,
+};
+
+/*
+ * These counters are essentially fields of the struct cached_chapter_index, but are segregated
+ * into this structure because they are frequently modified. They are grouped and aligned to keep
+ * them on different cache lines from the chapter fields that are accessed far more often than they
+ * are updated.
+ */
+struct __aligned(L1_CACHE_BYTES) cached_index_counters {
+	u64 consecutive_misses;
+};
+
+struct __aligned(L1_CACHE_BYTES) cached_chapter_index {
+	/*
+	 * The virtual chapter number of the cached chapter index. NO_CHAPTER means this cache
+	 * entry is unused. This field must only be modified in the critical section in
+	 * uds_update_sparse_cache().
+	 */
+	u64 virtual_chapter;
+
+	u32 index_pages_count;
+
+	/*
+	 * These pointers are immutable during the life of the cache. The contents of the arrays
+	 * change when the cache entry is replaced.
+	 */
+	struct delta_index_page *index_pages;
+	struct dm_buffer **page_buffers;
+
+	/*
+	 * If set, skip the chapter when searching the entire cache. This flag is just a
+	 * performance optimization. This flag is mutable between cache updates, but it rarely
+	 * changes and is frequently accessed, so it groups with the immutable fields.
+	 */
+	bool skip_search;
+
+	/*
+	 * The cache-aligned counters change often and are placed at the end of the structure to
+	 * prevent false sharing with the more stable fields above.
+	 */
+	struct cached_index_counters counters;
+};
+
+/*
+ * A search_list represents an ordering of the sparse chapter index cache entry array, from most
+ * recently accessed to least recently accessed, which is the order in which the indexes should be
+ * searched and the reverse order in which they should be evicted from the cache.
+ *
+ * Cache entries that are dead or empty are kept at the end of the list, avoiding the need to even
+ * iterate over them to search, and ensuring that dead entries are replaced before any live entries
+ * are evicted.
+ *
+ * The search list is instantiated for each zone thread, avoiding any need for synchronization. The
+ * structure is allocated on a cache boundary to avoid false sharing of memory cache lines between
+ * zone threads.
+ */
+struct search_list {
+	u8 capacity;
+	u8 first_dead_entry;
+	struct cached_chapter_index *entries[];
+};
+
+struct sparse_cache {
+	const struct geometry *geometry;
+	unsigned int capacity;
+	unsigned int zone_count;
+
+	unsigned int skip_threshold;
+	struct search_list *search_lists[MAX_ZONES];
+	struct cached_chapter_index **scratch_entries;
+
+	struct barrier begin_update_barrier;
+	struct barrier end_update_barrier;
+
+	struct cached_chapter_index chapters[];
+};
+
+static int __must_check
+initialize_cached_chapter_index(struct cached_chapter_index *chapter,
+				const struct geometry *geometry)
+{
+	int result;
+
+	chapter->virtual_chapter = NO_CHAPTER;
+	chapter->index_pages_count = geometry->index_pages_per_chapter;
+
+	result = UDS_ALLOCATE(chapter->index_pages_count,
+			      struct delta_index_page,
+			      __func__,
+			      &chapter->index_pages);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	return UDS_ALLOCATE(chapter->index_pages_count,
+			    struct dm_buffer *,
+			    "sparse index volume pages",
+			    &chapter->page_buffers);
+}
+
+static int __must_check make_search_list(struct sparse_cache *cache, struct search_list **list_ptr)
+{
+	struct search_list *list;
+	unsigned int bytes;
+	u8 i;
+	int result;
+
+	bytes = (sizeof(struct search_list) +
+		 (cache->capacity * sizeof(struct cached_chapter_index *)));
+	result = uds_allocate_cache_aligned(bytes, "search list", &list);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	list->capacity = cache->capacity;
+	list->first_dead_entry = 0;
+
+	for (i = 0; i < list->capacity; i++)
+		list->entries[i] = &cache->chapters[i];
+
+	*list_ptr = list;
+	return UDS_SUCCESS;
+}
+
+int uds_make_sparse_cache(const struct geometry *geometry,
+			  unsigned int capacity,
+			  unsigned int zone_count,
+			  struct sparse_cache **cache_ptr)
+{
+	int result;
+	unsigned int i;
+	struct sparse_cache *cache;
+	unsigned int bytes;
+
+	bytes = (sizeof(struct sparse_cache) + (capacity * sizeof(struct cached_chapter_index)));
+	result = uds_allocate_cache_aligned(bytes, "sparse cache", &cache);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	cache->geometry = geometry;
+	cache->capacity = capacity;
+	cache->zone_count = zone_count;
+
+	/*
+	 * Scale down the skip threshold since the cache only counts cache misses in zone zero, but
+	 * requests are being handled in all zones.
+	 */
+	cache->skip_threshold = (SKIP_SEARCH_THRESHOLD / zone_count);
+
+	result = uds_initialize_barrier(&cache->begin_update_barrier, zone_count);
+	if (result != UDS_SUCCESS) {
+		uds_free_sparse_cache(cache);
+		return result;
+	}
+
+	result = uds_initialize_barrier(&cache->end_update_barrier, zone_count);
+	if (result != UDS_SUCCESS) {
+		uds_free_sparse_cache(cache);
+		return result;
+	}
+
+	for (i = 0; i < capacity; i++) {
+		result = initialize_cached_chapter_index(&cache->chapters[i], geometry);
+		if (result != UDS_SUCCESS) {
+			uds_free_sparse_cache(cache);
+			return result;
+		}
+	}
+
+	for (i = 0; i < zone_count; i++) {
+		result = make_search_list(cache, &cache->search_lists[i]);
+		if (result != UDS_SUCCESS) {
+			uds_free_sparse_cache(cache);
+			return result;
+		}
+	}
+
+	/* purge_search_list() needs some temporary lists for sorting. */
+	result = UDS_ALLOCATE(capacity * 2,
+			      struct cached_chapter_index *,
+			      "scratch entries",
+			      &cache->scratch_entries);
+	if (result != UDS_SUCCESS) {
+		uds_free_sparse_cache(cache);
+		return result;
+	}
+
+	*cache_ptr = cache;
+	return UDS_SUCCESS;
+}
+
+static inline void set_skip_search(struct cached_chapter_index *chapter, bool skip_search)
+{
+	/* Check before setting to reduce cache line contention. */
+	if (READ_ONCE(chapter->skip_search) != skip_search)
+		WRITE_ONCE(chapter->skip_search, skip_search);
+}
+
+static void score_search_hit(struct cached_chapter_index *chapter)
+{
+	chapter->counters.consecutive_misses = 0;
+	set_skip_search(chapter, false);
+}
+
+static void score_search_miss(struct sparse_cache *cache, struct cached_chapter_index *chapter)
+{
+	chapter->counters.consecutive_misses++;
+	if (chapter->counters.consecutive_misses > cache->skip_threshold)
+		set_skip_search(chapter, true);
+}
+
+static void release_cached_chapter_index(struct cached_chapter_index *chapter)
+{
+	unsigned int i;
+
+	chapter->virtual_chapter = NO_CHAPTER;
+	if (chapter->page_buffers == NULL)
+		return;
+
+	for (i = 0; i < chapter->index_pages_count; i++)
+		if (chapter->page_buffers[i] != NULL)
+			dm_bufio_release(UDS_FORGET(chapter->page_buffers[i]));
+}
+
+void uds_free_sparse_cache(struct sparse_cache *cache)
+{
+	unsigned int i;
+
+	if (cache == NULL)
+		return;
+
+	UDS_FREE(cache->scratch_entries);
+
+	for (i = 0; i < cache->zone_count; i++)
+		UDS_FREE(cache->search_lists[i]);
+
+	for (i = 0; i < cache->capacity; i++) {
+		release_cached_chapter_index(&cache->chapters[i]);
+		UDS_FREE(cache->chapters[i].index_pages);
+		UDS_FREE(cache->chapters[i].page_buffers);
+	}
+
+	uds_destroy_barrier(&cache->begin_update_barrier);
+	uds_destroy_barrier(&cache->end_update_barrier);
+	UDS_FREE(cache);
+}
+
+/*
+ * Take the indicated element of the search list and move it to the start, pushing the pointers
+ * previously before it back down the list.
+ */
+static inline void set_newest_entry(struct search_list *search_list, u8 index)
+{
+	struct cached_chapter_index *newest;
+
+	if (index > 0) {
+		newest = search_list->entries[index];
+		memmove(&search_list->entries[1],
+			&search_list->entries[0],
+			index * sizeof(struct cached_chapter_index *));
+		search_list->entries[0] = newest;
+	}
+
+	/*
+	 * This function may have moved a dead chapter to the front of the list for reuse, in which
+	 * case the set of dead chapters becomes smaller.
+	 */
+	if (search_list->first_dead_entry <= index)
+		search_list->first_dead_entry++;
+}
+
+bool uds_sparse_cache_contains(struct sparse_cache *cache,
+			   u64 virtual_chapter,
+			   unsigned int zone_number)
+{
+	struct search_list *search_list;
+	struct cached_chapter_index *chapter;
+	u8 i;
+
+	/*
+	 * The correctness of the barriers depends on the invariant that between calls to
+	 * uds_update_sparse_cache(), the answers this function returns must never vary: the result
+	 * for a given chapter must be identical across zones. That invariant must be maintained
+	 * even if the chapter falls off the end of the volume, or if searching it is disabled
+	 * because of too many search misses.
+	 */
+	search_list = cache->search_lists[zone_number];
+	for (i = 0; i < search_list->first_dead_entry; i++) {
+		chapter = search_list->entries[i];
+
+		if (virtual_chapter == chapter->virtual_chapter) {
+			if (zone_number == ZONE_ZERO)
+				score_search_hit(chapter);
+
+			set_newest_entry(search_list, i);
+			return true;
+		}
+	}
+
+	return false;
+}
+
+/*
+ * Re-sort cache entries into three sets (active, skippable, and dead) while maintaining the LRU
+ * ordering that already existed. This operation must only be called during the critical section in
+ * uds_update_sparse_cache().
+ */
+static void purge_search_list(struct search_list *search_list,
+			      struct sparse_cache *cache,
+			      u64 oldest_virtual_chapter)
+{
+	struct cached_chapter_index **entries;
+	struct cached_chapter_index **skipped;
+	struct cached_chapter_index **dead;
+	struct cached_chapter_index *chapter;
+	unsigned int next_alive = 0;
+	unsigned int next_skipped = 0;
+	unsigned int next_dead = 0;
+	unsigned int i;
+
+	entries = &search_list->entries[0];
+	skipped = &cache->scratch_entries[0];
+	dead = &cache->scratch_entries[search_list->capacity];
+
+	for (i = 0; i < search_list->first_dead_entry; i++) {
+		chapter = search_list->entries[i];
+		if ((chapter->virtual_chapter < oldest_virtual_chapter) ||
+		    (chapter->virtual_chapter == NO_CHAPTER))
+			dead[next_dead++] = chapter;
+		else if (chapter->skip_search)
+			skipped[next_skipped++] = chapter;
+		else
+			entries[next_alive++] = chapter;
+	}
+
+	memcpy(&entries[next_alive],
+	       skipped,
+	       next_skipped * sizeof(struct cached_chapter_index *));
+	memcpy(&entries[next_alive + next_skipped],
+	       dead,
+	       next_dead * sizeof(struct cached_chapter_index *));
+	search_list->first_dead_entry = next_alive + next_skipped;
+}
+
+static int __must_check cache_chapter_index(struct cached_chapter_index *chapter,
+					    u64 virtual_chapter,
+					    const struct volume *volume)
+{
+	int result;
+
+	release_cached_chapter_index(chapter);
+
+	result = uds_read_chapter_index_from_volume(volume,
+						    virtual_chapter,
+						    chapter->page_buffers,
+						    chapter->index_pages);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	chapter->counters.consecutive_misses = 0;
+	chapter->virtual_chapter = virtual_chapter;
+	chapter->skip_search = false;
+
+	return UDS_SUCCESS;
+}
+
+static inline void copy_search_list(const struct search_list *source, struct search_list *target)
+{
+	*target = *source;
+	memcpy(target->entries,
+	       source->entries,
+	       source->capacity * sizeof(struct cached_chapter_index *));
+}
+
+/*
+ * Update the sparse cache to contain a chapter index. This function must be called by all the zone
+ * threads with the same chapter number to correctly enter the thread barriers used to synchronize
+ * the cache updates.
+ */
+int uds_update_sparse_cache(struct index_zone *zone, u64 virtual_chapter)
+{
+	int result = UDS_SUCCESS;
+	const struct uds_index *index = zone->index;
+	struct sparse_cache *cache = index->volume->sparse_cache;
+
+	if (uds_sparse_cache_contains(cache, virtual_chapter, zone->id))
+		return UDS_SUCCESS;
+
+	/*
+	 * Wait for every zone thread to reach its corresponding barrier request and invoke this
+	 * function before starting to modify the cache.
+	 */
+	uds_enter_barrier(&cache->begin_update_barrier);
+
+	/*
+	 * This is the start of the critical section: the zone zero thread is captain, effectively
+	 * holding an exclusive lock on the sparse cache. All the other zone threads must do
+	 * nothing between the two barriers. They will wait at the end_update_barrier again for the
+	 * captain to finish the update.
+	 */
+
+	if (zone->id == ZONE_ZERO) {
+		unsigned int z;
+		struct search_list *list = cache->search_lists[ZONE_ZERO];
+
+		purge_search_list(list, cache, zone->oldest_virtual_chapter);
+
+		if (virtual_chapter >= index->oldest_virtual_chapter) {
+			set_newest_entry(list, list->capacity - 1);
+			result = cache_chapter_index(list->entries[0],
+						     virtual_chapter,
+						     index->volume);
+		}
+
+		for (z = 1; z < cache->zone_count; z++)
+			copy_search_list(list, cache->search_lists[z]);
+	}
+
+	/*
+	 * This is the end of the critical section. All cache invariants must have been restored.
+	 */
+	uds_enter_barrier(&cache->end_update_barrier);
+	return result;
+}
+
+void uds_invalidate_sparse_cache(struct sparse_cache *cache)
+{
+	unsigned int i;
+
+	for (i = 0; i < cache->capacity; i++)
+		release_cached_chapter_index(&cache->chapters[i]);
+}
+
+static inline bool should_skip_chapter(struct cached_chapter_index *chapter,
+				       u64 oldest_chapter,
+				       u64 requested_chapter)
+{
+	if ((chapter->virtual_chapter == NO_CHAPTER) ||
+	    (chapter->virtual_chapter < oldest_chapter))
+		return true;
+
+	if (requested_chapter != NO_CHAPTER)
+		return requested_chapter != chapter->virtual_chapter;
+	else
+		return READ_ONCE(chapter->skip_search);
+}
+
+static int __must_check
+search_cached_chapter_index(struct cached_chapter_index *chapter,
+			    const struct geometry *geometry,
+			    const struct index_page_map *index_page_map,
+			    const struct uds_record_name *name,
+			    u16 *record_page_ptr)
+{
+	u32 physical_chapter = uds_map_to_physical_chapter(geometry, chapter->virtual_chapter);
+	u32 index_page_number = uds_find_index_page_number(index_page_map, name, physical_chapter);
+	struct delta_index_page *index_page = &chapter->index_pages[index_page_number];
+
+	return uds_search_chapter_index_page(index_page, geometry, name, record_page_ptr);
+}
+
+int uds_search_sparse_cache(struct index_zone *zone,
+			    const struct uds_record_name *name,
+			    u64 *virtual_chapter_ptr,
+			    u16 *record_page_ptr)
+{
+	int result;
+	struct volume *volume = zone->index->volume;
+	struct sparse_cache *cache = volume->sparse_cache;
+	struct cached_chapter_index *chapter;
+	struct search_list *search_list;
+	u8 i;
+	/* Search the entire cache unless a specific chapter was requested. */
+	bool search_one = (*virtual_chapter_ptr != NO_CHAPTER);
+
+	*record_page_ptr = NO_CHAPTER_INDEX_ENTRY;
+	search_list = cache->search_lists[zone->id];
+	for (i = 0; i < search_list->first_dead_entry; i++) {
+		chapter = search_list->entries[i];
+
+		if (should_skip_chapter(chapter,
+					zone->oldest_virtual_chapter,
+					*virtual_chapter_ptr))
+			continue;
+
+		result = search_cached_chapter_index(chapter,
+						     cache->geometry,
+						     volume->index_page_map,
+						     name,
+						     record_page_ptr);
+		if (result != UDS_SUCCESS)
+			return result;
+
+		if (*record_page_ptr != NO_CHAPTER_INDEX_ENTRY) {
+			/*
+			 * In theory, this might be a false match while a true match exists in
+			 * another chapter, but that's a very rare case and not worth the extra
+			 * search complexity.
+			 */
+			set_newest_entry(search_list, i);
+			if (zone->id == ZONE_ZERO)
+				score_search_hit(chapter);
+
+			*virtual_chapter_ptr = chapter->virtual_chapter;
+			return UDS_SUCCESS;
+		}
+
+		if (zone->id == ZONE_ZERO)
+			score_search_miss(cache, chapter);
+
+		if (search_one)
+			break;
+	}
+
+	return UDS_SUCCESS;
+}
diff --git a/drivers/md/dm-vdo/sparse-cache.h b/drivers/md/dm-vdo/sparse-cache.h
new file mode 100644
index 00000000000..dd7ad462bb8
--- /dev/null
+++ b/drivers/md/dm-vdo/sparse-cache.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_SPARSE_CACHE_H
+#define UDS_SPARSE_CACHE_H
+
+#include "geometry.h"
+#include "uds.h"
+
+/*
+ * The sparse cache is a cache of entire chapter indexes from sparse chapters used for searching
+ * for names after all other search paths have failed. It contains only complete chapter indexes;
+ * record pages from sparse chapters and single index pages used for resolving hooks are kept in
+ * the regular page cache in the volume.
+ *
+ * The most important property of this cache is the absence of synchronization for read operations.
+ * Safe concurrent access to the cache by the zone threads is controlled by the triage queue and
+ * the barrier requests it issues to the zone queues. The set of cached chapters does not and must
+ * not change between the carefully coordinated calls to uds_update_sparse_cache() from the zone
+ * threads. Outside of updates, every zone will get the same result when calling
+ * uds_sparse_cache_contains() as every other zone.
+ */
+
+struct index_zone;
+struct sparse_cache;
+
+int __must_check uds_make_sparse_cache(const struct geometry *geometry,
+				       unsigned int capacity,
+				       unsigned int zone_count,
+				       struct sparse_cache **cache_ptr);
+
+void uds_free_sparse_cache(struct sparse_cache *cache);
+
+bool uds_sparse_cache_contains(struct sparse_cache *cache,
+			       u64 virtual_chapter,
+			       unsigned int zone_number);
+
+int __must_check uds_update_sparse_cache(struct index_zone *zone, u64 virtual_chapter);
+
+void uds_invalidate_sparse_cache(struct sparse_cache *cache);
+
+int __must_check uds_search_sparse_cache(struct index_zone *zone,
+					 const struct uds_record_name *name,
+					 u64 *virtual_chapter_ptr,
+					 u16 *record_page_ptr);
+
+#endif /* UDS_SPARSE_CACHE_H */
diff --git a/drivers/md/dm-vdo/string-utils.c b/drivers/md/dm-vdo/string-utils.c
new file mode 100644
index 00000000000..ac8cd76a8ff
--- /dev/null
+++ b/drivers/md/dm-vdo/string-utils.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "string-utils.h"
+
+#include "errors.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+#include "uds.h"
+
+char *uds_append_to_buffer(char *buffer, char *buf_end, const char *fmt, ...)
+{
+	va_list args;
+	size_t n;
+
+	va_start(args, fmt);
+	n = vsnprintf(buffer, buf_end - buffer, fmt, args);
+	if (n >= (size_t) (buf_end - buffer))
+		buffer = buf_end;
+	else
+		buffer += n;
+	va_end(args);
+
+	return buffer;
+}
diff --git a/drivers/md/dm-vdo/string-utils.h b/drivers/md/dm-vdo/string-utils.h
new file mode 100644
index 00000000000..4f093184769
--- /dev/null
+++ b/drivers/md/dm-vdo/string-utils.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_STRING_UTILS_H
+#define UDS_STRING_UTILS_H
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+
+/* Utilities related to string manipuation */
+
+static inline const char *uds_bool_to_string(bool value)
+{
+	return value ? "true" : "false";
+}
+
+/* Append a formatted string to the end of a buffer. */
+char *uds_append_to_buffer(char *buffer, char *buf_end, const char *fmt, ...)
+	__printf(3, 4);
+
+#endif /* UDS_STRING_UTILS_H */
diff --git a/drivers/md/dm-vdo/thread-cond-var.c b/drivers/md/dm-vdo/thread-cond-var.c
new file mode 100644
index 00000000000..4a3af5d0618
--- /dev/null
+++ b/drivers/md/dm-vdo/thread-cond-var.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include <linux/jiffies.h>
+#include <linux/minmax.h>
+
+#include "errors.h"
+#include "time-utils.h"
+#include "uds-threads.h"
+
+int uds_init_cond(struct cond_var *cv)
+{
+	init_waitqueue_head(&cv->wait_queue);
+	return UDS_SUCCESS;
+}
+
+int uds_signal_cond(struct cond_var *cv)
+{
+	wake_up(&cv->wait_queue);
+	return UDS_SUCCESS;
+}
+
+int uds_broadcast_cond(struct cond_var *cv)
+{
+	wake_up_all(&cv->wait_queue);
+	return UDS_SUCCESS;
+}
+
+int uds_wait_cond(struct cond_var *cv, struct mutex *mutex)
+{
+	DEFINE_WAIT(__wait);
+
+	prepare_to_wait(&cv->wait_queue, &__wait, TASK_IDLE);
+	uds_unlock_mutex(mutex);
+	schedule();
+	finish_wait(&cv->wait_queue, &__wait);
+	uds_lock_mutex(mutex);
+	return UDS_SUCCESS;
+}
+
+int uds_destroy_cond(struct cond_var *cv)
+{
+	return UDS_SUCCESS;
+}
diff --git a/drivers/md/dm-vdo/thread-device.c b/drivers/md/dm-vdo/thread-device.c
new file mode 100644
index 00000000000..906dfd4f617
--- /dev/null
+++ b/drivers/md/dm-vdo/thread-device.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "thread-device.h"
+
+#include "thread-registry.h"
+
+/* A registry of threads associated with device id numbers. */
+static struct thread_registry device_id_thread_registry;
+
+/* Any registered thread must be unregistered. */
+void uds_register_thread_device_id(struct registered_thread *new_thread, unsigned int *id_ptr)
+{
+	uds_register_thread(&device_id_thread_registry, new_thread, id_ptr);
+}
+
+void uds_unregister_thread_device_id(void)
+{
+	uds_unregister_thread(&device_id_thread_registry);
+}
+
+int uds_get_thread_device_id(void)
+{
+	const unsigned int *pointer;
+
+	pointer = uds_lookup_thread(&device_id_thread_registry);
+	return (pointer != NULL) ? *pointer : -1;
+}
+
+void uds_initialize_thread_device_registry(void)
+{
+	uds_initialize_thread_registry(&device_id_thread_registry);
+}
diff --git a/drivers/md/dm-vdo/thread-device.h b/drivers/md/dm-vdo/thread-device.h
new file mode 100644
index 00000000000..c33a16faa38
--- /dev/null
+++ b/drivers/md/dm-vdo/thread-device.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_THREAD_DEVICE_H
+#define UDS_THREAD_DEVICE_H
+
+#include "thread-registry.h"
+
+void uds_register_thread_device_id(struct registered_thread *new_thread, unsigned int *id_ptr);
+
+void uds_unregister_thread_device_id(void);
+
+int uds_get_thread_device_id(void);
+
+void uds_initialize_thread_device_registry(void);
+
+#endif /* UDS_THREAD_DEVICE_H */
diff --git a/drivers/md/dm-vdo/thread-registry.c b/drivers/md/dm-vdo/thread-registry.c
new file mode 100644
index 00000000000..bdfaf9c2112
--- /dev/null
+++ b/drivers/md/dm-vdo/thread-registry.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "thread-registry.h"
+
+#include <linux/rculist.h>
+
+#include "permassert.h"
+
+/*
+ * We need to be careful when using other facilities that may use thread registry functions in
+ * their normal operation. For example, we do not want to invoke the logger while holding a lock.
+ */
+
+void uds_initialize_thread_registry(struct thread_registry *registry)
+{
+	INIT_LIST_HEAD(&registry->links);
+	spin_lock_init(&registry->lock);
+}
+
+/* Register the current thread and associate it with a data pointer. */
+void uds_register_thread(struct thread_registry *registry,
+			 struct registered_thread *new_thread,
+			 const void *pointer)
+{
+	struct registered_thread *thread;
+	bool found_it = false;
+
+	INIT_LIST_HEAD(&new_thread->links);
+	new_thread->pointer = pointer;
+	new_thread->task = current;
+
+	spin_lock(&registry->lock);
+	list_for_each_entry(thread, &registry->links, links) {
+		if (thread->task == current) {
+			/* There should be no existing entry. */
+			list_del_rcu(&thread->links);
+			found_it = true;
+			break;
+		}
+	}
+	list_add_tail_rcu(&new_thread->links, &registry->links);
+	spin_unlock(&registry->lock);
+
+	ASSERT_LOG_ONLY(!found_it, "new thread not already in registry");
+	if (found_it) {
+		/* Ensure no RCU iterators see it before re-initializing. */
+		synchronize_rcu();
+		INIT_LIST_HEAD(&thread->links);
+	}
+}
+
+void uds_unregister_thread(struct thread_registry *registry)
+{
+	struct registered_thread *thread;
+	bool found_it = false;
+
+	spin_lock(&registry->lock);
+	list_for_each_entry(thread, &registry->links, links) {
+		if (thread->task == current) {
+			list_del_rcu(&thread->links);
+			found_it = true;
+			break;
+		}
+	}
+	spin_unlock(&registry->lock);
+
+	ASSERT_LOG_ONLY(found_it, "thread found in registry");
+	if (found_it) {
+		/* Ensure no RCU iterators see it before re-initializing. */
+		synchronize_rcu();
+		INIT_LIST_HEAD(&thread->links);
+	}
+}
+
+const void *uds_lookup_thread(struct thread_registry *registry)
+{
+	struct registered_thread *thread;
+	const void *result = NULL;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(thread, &registry->links, links) {
+		if (thread->task == current) {
+			result = thread->pointer;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return result;
+}
diff --git a/drivers/md/dm-vdo/thread-registry.h b/drivers/md/dm-vdo/thread-registry.h
new file mode 100644
index 00000000000..b5ba1b86558
--- /dev/null
+++ b/drivers/md/dm-vdo/thread-registry.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_THREAD_REGISTRY_H
+#define UDS_THREAD_REGISTRY_H
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+struct thread_registry {
+	struct list_head links;
+	spinlock_t lock;
+};
+
+struct registered_thread {
+	struct list_head links;
+	const void *pointer;
+	struct task_struct *task;
+};
+
+void uds_initialize_thread_registry(struct thread_registry *registry);
+
+void uds_register_thread(struct thread_registry *registry,
+			 struct registered_thread *new_thread,
+			 const void *pointer);
+
+void uds_unregister_thread(struct thread_registry *registry);
+
+const void *uds_lookup_thread(struct thread_registry *registry);
+
+#endif /* UDS_THREAD_REGISTRY_H */
diff --git a/drivers/md/dm-vdo/time-utils.h b/drivers/md/dm-vdo/time-utils.h
new file mode 100644
index 00000000000..82d89108a85
--- /dev/null
+++ b/drivers/md/dm-vdo/time-utils.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_TIME_UTILS_H
+#define UDS_TIME_UTILS_H
+
+#include <linux/ktime.h>
+#include <linux/time.h>
+#include <linux/types.h>
+
+static inline s64 ktime_to_seconds(ktime_t reltime)
+{
+	return reltime / NSEC_PER_SEC;
+}
+
+static inline ktime_t current_time_ns(clockid_t clock)
+{
+	return clock == CLOCK_MONOTONIC ? ktime_get_ns() : ktime_get_real_ns();
+}
+
+static inline ktime_t current_time_us(void)
+{
+	return current_time_ns(CLOCK_REALTIME) / NSEC_PER_USEC;
+}
+
+#endif /* UDS_TIME_UTILS_H */
diff --git a/drivers/md/dm-vdo/uds-sysfs.c b/drivers/md/dm-vdo/uds-sysfs.c
new file mode 100644
index 00000000000..0f963d99a86
--- /dev/null
+++ b/drivers/md/dm-vdo/uds-sysfs.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "uds-sysfs.h"
+
+#include <linux/kobject.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "logger.h"
+#include "memory-alloc.h"
+#include "string-utils.h"
+#include "uds.h"
+
+#define UDS_SYSFS_NAME "uds"
+
+static struct {
+	/* /sys/uds */
+	struct kobject kobj;
+	/* /sys/uds/parameter */
+	struct kobject parameter_kobj;
+
+	/* These flags are used to ensure a clean shutdown */
+
+	/* /sys/uds flag */
+	bool flag;
+	/* /sys/uds/parameter flag */
+	bool parameter_flag;
+} object_root;
+
+static char *buffer_to_string(const char *buf, size_t length)
+{
+	char *string;
+
+	if (UDS_ALLOCATE(length + 1, char, __func__, &string) != UDS_SUCCESS)
+		return NULL;
+
+	memcpy(string, buf, length);
+	string[length] = '\0';
+	if (string[length - 1] == '\n')
+		string[length - 1] = '\0';
+
+	return string;
+}
+
+/*
+ * This is the code for any directory in the /sys/<module_name> tree that contains no regular files
+ * (only subdirectories).
+ */
+
+static void empty_release(struct kobject *kobj)
+{
+}
+
+static ssize_t empty_show(struct kobject *kobj, struct attribute *attr, char *buf)
+{
+	return 0;
+}
+
+static ssize_t
+empty_store(struct kobject *kobj, struct attribute *attr, const char *buf, size_t length)
+{
+	return length;
+}
+
+static const struct sysfs_ops empty_ops = {
+	.show = empty_show,
+	.store = empty_store,
+};
+
+static struct attribute *empty_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(empty);
+
+static struct kobj_type empty_object_type = {
+	.release = empty_release,
+	.sysfs_ops = &empty_ops,
+	.default_groups = empty_groups,
+};
+
+/*
+ * This is the code for the /sys/<module_name>/parameter directory.
+ * <dir>/log_level                 UDS_LOG_LEVEL
+ */
+
+struct parameter_attribute {
+	struct attribute attr;
+	const char *(*show_string)(void);
+	void (*store_string)(const char *string);
+};
+
+static ssize_t parameter_show(struct kobject *kobj, struct attribute *attr, char *buf)
+{
+	struct parameter_attribute *pa;
+
+	pa = container_of(attr, struct parameter_attribute, attr);
+	if (pa->show_string != NULL)
+		return sprintf(buf, "%s\n", pa->show_string());
+	else
+		return -EINVAL;
+}
+
+static ssize_t
+parameter_store(struct kobject *kobj, struct attribute *attr, const char *buf, size_t length)
+{
+	char *string;
+	struct parameter_attribute *pa;
+
+	pa = container_of(attr, struct parameter_attribute, attr);
+	if (pa->store_string == NULL)
+		return -EINVAL;
+	string = buffer_to_string(buf, length);
+	if (string == NULL)
+		return -ENOMEM;
+
+	pa->store_string(string);
+	UDS_FREE(string);
+	return length;
+}
+
+static const char *parameter_show_log_level(void)
+{
+	return uds_log_priority_to_string(uds_get_log_level());
+}
+
+static void parameter_store_log_level(const char *string)
+{
+	uds_set_log_level(uds_log_string_to_priority(string));
+}
+
+static struct parameter_attribute log_level_attr = {
+	.attr = { .name = "log_level", .mode = 0600 },
+	.show_string = parameter_show_log_level,
+	.store_string = parameter_store_log_level,
+};
+
+static struct attribute *parameter_attrs[] = {
+	&log_level_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(parameter);
+
+static const struct sysfs_ops parameter_ops = {
+	.show = parameter_show,
+	.store = parameter_store,
+};
+
+static struct kobj_type parameter_object_type = {
+	.release = empty_release,
+	.sysfs_ops = &parameter_ops,
+	.default_groups = parameter_groups,
+};
+
+int uds_init_sysfs(void)
+{
+	int result;
+
+	memset(&object_root, 0, sizeof(object_root));
+	kobject_init(&object_root.kobj, &empty_object_type);
+	result = kobject_add(&object_root.kobj, NULL, UDS_SYSFS_NAME);
+	if (result == 0) {
+		object_root.flag = true;
+		kobject_init(&object_root.parameter_kobj, &parameter_object_type);
+		result = kobject_add(&object_root.parameter_kobj, &object_root.kobj, "parameter");
+		if (result == 0)
+			object_root.parameter_flag = true;
+	}
+
+	if (result != 0)
+		uds_put_sysfs();
+
+	return result;
+}
+
+void uds_put_sysfs(void)
+{
+	if (object_root.parameter_flag)
+		kobject_put(&object_root.parameter_kobj);
+
+	if (object_root.flag)
+		kobject_put(&object_root.kobj);
+}
diff --git a/drivers/md/dm-vdo/uds-sysfs.h b/drivers/md/dm-vdo/uds-sysfs.h
new file mode 100644
index 00000000000..172a86baf2d
--- /dev/null
+++ b/drivers/md/dm-vdo/uds-sysfs.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_SYSFS_H
+#define UDS_SYSFS_H
+
+int uds_init_sysfs(void);
+void uds_put_sysfs(void);
+
+#endif  /* UDS_SYSFS_H */
diff --git a/drivers/md/dm-vdo/uds-threads.c b/drivers/md/dm-vdo/uds-threads.c
new file mode 100644
index 00000000000..3ead347d4c7
--- /dev/null
+++ b/drivers/md/dm-vdo/uds-threads.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "uds-threads.h"
+
+#include <linux/completion.h>
+#include <linux/err.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+
+#include "errors.h"
+#include "logger.h"
+#include "memory-alloc.h"
+
+static struct hlist_head thread_list;
+static struct mutex thread_mutex;
+static atomic_t thread_once = ATOMIC_INIT(0);
+
+struct thread {
+	void (*thread_function)(void *thread_data);
+	void *thread_data;
+	struct hlist_node thread_links;
+	struct task_struct *thread_task;
+	struct completion thread_done;
+};
+
+enum {
+	ONCE_NOT_DONE = 0,
+	ONCE_IN_PROGRESS = 1,
+	ONCE_COMPLETE = 2,
+};
+
+/* Run a function once only, and record that fact in the atomic value. */
+void uds_perform_once(atomic_t *once, void (*function)(void))
+{
+	for (;;) {
+		switch (atomic_cmpxchg(once, ONCE_NOT_DONE, ONCE_IN_PROGRESS)) {
+		case ONCE_NOT_DONE:
+			function();
+			atomic_set_release(once, ONCE_COMPLETE);
+			return;
+		case ONCE_IN_PROGRESS:
+			cond_resched();
+			break;
+		case ONCE_COMPLETE:
+			return;
+		default:
+			return;
+		}
+	}
+}
+
+static void thread_init(void)
+{
+	mutex_init(&thread_mutex);
+}
+
+static int thread_starter(void *arg)
+{
+	struct registered_thread allocating_thread;
+	struct thread *thread = arg;
+
+	thread->thread_task = current;
+	uds_perform_once(&thread_once, thread_init);
+	mutex_lock(&thread_mutex);
+	hlist_add_head(&thread->thread_links, &thread_list);
+	mutex_unlock(&thread_mutex);
+	uds_register_allocating_thread(&allocating_thread, NULL);
+	thread->thread_function(thread->thread_data);
+	uds_unregister_allocating_thread();
+	complete(&thread->thread_done);
+	return 0;
+}
+
+int uds_create_thread(void (*thread_function)(void *),
+		      void *thread_data,
+		      const char *name,
+		      struct thread **new_thread)
+{
+	char *name_colon = strchr(name, ':');
+	char *my_name_colon = strchr(current->comm, ':');
+	struct task_struct *task;
+	struct thread *thread;
+	int result;
+
+	result = UDS_ALLOCATE(1, struct thread, __func__, &thread);
+	if (result != UDS_SUCCESS) {
+		uds_log_warning("Error allocating memory for %s", name);
+		return result;
+	}
+
+	thread->thread_function = thread_function;
+	thread->thread_data = thread_data;
+	init_completion(&thread->thread_done);
+	/*
+	 * Start the thread, with an appropriate thread name.
+	 *
+	 * If the name supplied contains a colon character, use that name. This causes uds module
+	 * threads to have names like "uds:callbackW" and the main test runner thread to be named
+	 * "zub:runtest".
+	 *
+	 * Otherwise if the current thread has a name containing a colon character, prefix the name
+	 * supplied with the name of the current thread up to (and including) the colon character.
+	 * Thus when the "kvdo0:dedupeQ" thread opens an index session, all the threads associated
+	 * with that index will have names like "kvdo0:foo".
+	 *
+	 * Otherwise just use the name supplied. This should be a rare occurrence.
+	 */
+	if ((name_colon == NULL) && (my_name_colon != NULL))
+		task = kthread_run(thread_starter,
+				   thread,
+				   "%.*s:%s",
+				   (int) (my_name_colon - current->comm),
+				   current->comm,
+				   name);
+	else
+		task = kthread_run(thread_starter, thread, "%s", name);
+
+	if (IS_ERR(task)) {
+		UDS_FREE(thread);
+		return PTR_ERR(task);
+	}
+
+	*new_thread = thread;
+	return UDS_SUCCESS;
+}
+
+int uds_join_threads(struct thread *thread)
+{
+	while (wait_for_completion_interruptible(&thread->thread_done) != 0)
+		/* empty loop */
+		;
+
+	mutex_lock(&thread_mutex);
+	hlist_del(&thread->thread_links);
+	mutex_unlock(&thread_mutex);
+	UDS_FREE(thread);
+	return UDS_SUCCESS;
+}
+
+int uds_initialize_barrier(struct barrier *barrier, unsigned int thread_count)
+{
+	int result;
+
+	result = uds_initialize_semaphore(&barrier->mutex, 1);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	barrier->arrived = 0;
+	barrier->thread_count = thread_count;
+	return uds_initialize_semaphore(&barrier->wait, 0);
+}
+
+int uds_destroy_barrier(struct barrier *barrier)
+{
+	int result;
+
+	result = uds_destroy_semaphore(&barrier->mutex);
+	if (result != UDS_SUCCESS)
+		return result;
+	return uds_destroy_semaphore(&barrier->wait);
+}
+
+int uds_enter_barrier(struct barrier *barrier)
+{
+	bool last_thread;
+
+	uds_acquire_semaphore(&barrier->mutex);
+	last_thread = (++barrier->arrived == barrier->thread_count);
+	if (last_thread) {
+		int i;
+
+		for (i = 1; i < barrier->thread_count; i++)
+			uds_release_semaphore(&barrier->wait);
+
+		barrier->arrived = 0;
+		uds_release_semaphore(&barrier->mutex);
+	} else {
+		uds_release_semaphore(&barrier->mutex);
+		uds_acquire_semaphore(&barrier->wait);
+	}
+
+	return UDS_SUCCESS;
+}
diff --git a/drivers/md/dm-vdo/uds-threads.h b/drivers/md/dm-vdo/uds-threads.h
new file mode 100644
index 00000000000..e4c968e2930
--- /dev/null
+++ b/drivers/md/dm-vdo/uds-threads.h
@@ -0,0 +1,126 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_THREADS_H
+#define UDS_THREADS_H
+
+#include <linux/atomic.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
+#include <linux/mutex.h>
+#include <linux/semaphore.h>
+#include <linux/wait.h>
+
+#include "errors.h"
+#include "time-utils.h"
+
+/* Thread and synchronization utilities for UDS */
+
+struct cond_var {
+	wait_queue_head_t wait_queue;
+};
+
+struct thread;
+
+struct barrier {
+	/* Mutex for this barrier object */
+	struct semaphore mutex;
+	/* Semaphore for threads waiting at the barrier */
+	struct semaphore wait;
+	/* Number of threads which have arrived */
+	int arrived;
+	/* Total number of threads using this barrier */
+	int thread_count;
+};
+
+int __must_check uds_create_thread(void (*thread_function)(void *),
+				   void *thread_data,
+				   const char *name,
+				   struct thread **new_thread);
+
+void uds_perform_once(atomic_t *once_state, void (*function) (void));
+
+int uds_join_threads(struct thread *thread);
+
+int __must_check uds_initialize_barrier(struct barrier *barrier, unsigned int thread_count);
+int uds_destroy_barrier(struct barrier *barrier);
+int uds_enter_barrier(struct barrier *barrier);
+
+int __must_check uds_init_cond(struct cond_var *cond);
+int uds_signal_cond(struct cond_var *cond);
+int uds_broadcast_cond(struct cond_var *cond);
+int uds_wait_cond(struct cond_var *cond, struct mutex *mutex);
+int uds_destroy_cond(struct cond_var *cond);
+
+static inline int __must_check uds_init_mutex(struct mutex *mutex)
+{
+	mutex_init(mutex);
+	return UDS_SUCCESS;
+}
+
+static inline int uds_destroy_mutex(struct mutex *mutex)
+{
+	return UDS_SUCCESS;
+}
+
+static inline void uds_lock_mutex(struct mutex *mutex)
+{
+	mutex_lock(mutex);
+}
+
+static inline void uds_unlock_mutex(struct mutex *mutex)
+{
+	mutex_unlock(mutex);
+}
+
+static inline int __must_check
+uds_initialize_semaphore(struct semaphore *semaphore, unsigned int value)
+{
+	sema_init(semaphore, value);
+	return UDS_SUCCESS;
+}
+
+static inline int uds_destroy_semaphore(struct semaphore *semaphore)
+{
+	return UDS_SUCCESS;
+}
+
+static inline void uds_acquire_semaphore(struct semaphore *semaphore)
+{
+	/*
+	 * Do not use down(semaphore). Instead use down_interruptible so that
+	 * we do not get 120 second stall messages in kern.log.
+	 */
+	while (down_interruptible(semaphore) != 0)
+		/*
+		 * If we're called from a user-mode process (e.g., "dmsetup
+		 * remove") while waiting for an operation that may take a
+		 * while (e.g., UDS index save), and a signal is sent (SIGINT,
+		 * SIGUSR2), then down_interruptible will not block. If that
+		 * happens, sleep briefly to avoid keeping the CPU locked up in
+		 * this loop. We could just call cond_resched, but then we'd
+		 * still keep consuming CPU time slices and swamp other threads
+		 * trying to do computational work. [VDO-4980]
+		 */
+		fsleep(1000);
+}
+
+static inline bool __must_check uds_attempt_semaphore(struct semaphore *semaphore, ktime_t timeout)
+{
+	unsigned int jiffies;
+
+	if (timeout <= 0)
+		return down_trylock(semaphore) == 0;
+
+	jiffies = nsecs_to_jiffies(timeout);
+	return down_timeout(semaphore, jiffies) == 0;
+}
+
+static inline void uds_release_semaphore(struct semaphore *semaphore)
+{
+	up(semaphore);
+}
+
+#endif /* UDS_THREADS_H */
diff --git a/drivers/md/dm-vdo/uds.h b/drivers/md/dm-vdo/uds.h
new file mode 100644
index 00000000000..257927cd707
--- /dev/null
+++ b/drivers/md/dm-vdo/uds.h
@@ -0,0 +1,334 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_H
+#define UDS_H
+
+#include <linux/types.h>
+
+#include "funnel-queue.h"
+
+/*
+ * UDS public API
+ *
+ * The Universal Deduplication System (UDS) is an efficient name-value store. When used for
+ * deduplicating storage, the names are generally hashes of data blocks and the associated data is
+ * where that block is located on the underlying storage medium. The stored names are expected to
+ * be randomly distributed among the space of possible names. If this assumption is violated, the
+ * UDS index will store fewer names than normal but will otherwise continue to work. The data
+ * associated with each name can be any 16-byte value.
+ *
+ * A client must first create an index session to interact with an index. Once created, the session
+ * can be shared among multiple threads or users. When a session is destroyed, it will also close
+ * and save any associated index.
+ *
+ * To make a request, a client must allocate a uds_request structure and set the required fields
+ * before launching it. UDS will invoke the provided callback to complete the request. After the
+ * callback has been called, the uds_request structure can be freed or reused for a new request.
+ * There are five types of requests:
+ *
+ * A UDS_UPDATE request will associate the provided name with the provided data. Any previous data
+ * associated with that name will be discarded.
+ *
+ * A UDS_QUERY request will return the data associated with the provided name, if any. The entry
+ * for the name will also be marked as most recent, as if the data had been updated.
+ *
+ * A UDS_POST request is a combination of UDS_QUERY and UDS_UPDATE. If there is already data
+ * associated with the provided name, that data is returned. If there is no existing association,
+ * the name is associated with the newly provided data. This request is equivalent to a UDS_QUERY
+ * request followed by a UDS_UPDATE request if no data is found, but it is much more efficient.
+ *
+ * A UDS_QUERY_NO_UPDATE request will return the data associated with the provided name, but will
+ * not change the recency of the entry for the name. This request is primarily useful for testing,
+ * to determine whether an entry exists without changing the internal state of the index.
+ *
+ * A UDS_DELETE request removes any data associated with the provided name. This operation is
+ * generally not necessary, because the index will automatically discard its oldest entries once it
+ * becomes full.
+ */
+
+/* General UDS constants and structures */
+
+enum uds_request_type {
+	/* Create or update the mapping for a name, and make the name most recent. */
+	UDS_UPDATE,
+
+	/* Return any mapped data for a name, and make the name most recent. */
+	UDS_QUERY,
+
+	/*
+	 * Return any mapped data for a name, or map the provided data to the name if there is no
+	 * current data, and make the name most recent.
+	 */
+	UDS_POST,
+
+	/* Return any mapped data for a name without updating its recency. */
+	UDS_QUERY_NO_UPDATE,
+
+	/* Remove any mapping for a name. */
+	UDS_DELETE,
+
+};
+
+enum uds_open_index_type {
+	/* Create a new index. */
+	UDS_CREATE,
+
+	/* Load an existing index and try to recover if necessary. */
+	UDS_LOAD,
+
+	/* Load an existing index, but only if it was saved cleanly. */
+	UDS_NO_REBUILD,
+};
+
+enum {
+	/* The record name size in bytes */
+	UDS_RECORD_NAME_SIZE = 16,
+	/* The maximum record data size in bytes */
+	UDS_RECORD_DATA_SIZE = 16,
+};
+
+/*
+ * A type representing a UDS memory configuration which is either a positive integer number of
+ * gigabytes or one of the six special constants for configurations smaller than one gigabyte.
+ */
+typedef int uds_memory_config_size_t;
+
+enum {
+	/* The maximum configurable amount of memory */
+	UDS_MEMORY_CONFIG_MAX = 1024,
+	/* Flag indicating that the index has one less chapter than usual */
+	UDS_MEMORY_CONFIG_REDUCED = 0x1000,
+	UDS_MEMORY_CONFIG_REDUCED_MAX = 1024 + UDS_MEMORY_CONFIG_REDUCED,
+	/* Special values indicating sizes less than 1 GB */
+	UDS_MEMORY_CONFIG_256MB = -256,
+	UDS_MEMORY_CONFIG_512MB = -512,
+	UDS_MEMORY_CONFIG_768MB = -768,
+	UDS_MEMORY_CONFIG_REDUCED_256MB = -1280,
+	UDS_MEMORY_CONFIG_REDUCED_512MB = -1536,
+	UDS_MEMORY_CONFIG_REDUCED_768MB = -1792,
+};
+
+struct uds_record_name {
+	unsigned char name[UDS_RECORD_NAME_SIZE];
+};
+
+struct uds_record_data {
+	unsigned char data[UDS_RECORD_DATA_SIZE];
+};
+
+struct uds_volume_record {
+	struct uds_record_name name;
+	struct uds_record_data data;
+};
+
+struct uds_parameters {
+	/* A string describing the storage device (a name or path) */
+	const char *name;
+	/* The maximum allowable size of the index on storage */
+	size_t size;
+	/* The offset where the index should start */
+	off_t offset;
+	/* The maximum memory allocation, in GB */
+	uds_memory_config_size_t memory_size;
+	/* Whether the index should include sparse chapters */
+	bool sparse;
+	/* A 64-bit nonce to validate the index */
+	u64 nonce;
+	/* The number of threads used to process index requests */
+	unsigned int zone_count;
+	/* The number of threads used to read volume pages */
+	unsigned int read_threads;
+};
+
+/*
+ * These statistics capture characteristics of the current index, including resource usage and
+ * requests processed since the index was opened.
+ */
+struct uds_index_stats {
+	/* The total number of records stored in the index */
+	u64 entries_indexed;
+	/* An estimate of the index's memory usage, in bytes */
+	u64 memory_used;
+	/* The number of collisions recorded in the volume index */
+	u64 collisions;
+	/* The number of entries discarded from the index since startup */
+	u64 entries_discarded;
+	/* The time at which these statistics were fetched */
+	s64 current_time;
+	/* The number of post calls that found an existing entry */
+	u64 posts_found;
+	/* The number of post calls that added an entry */
+	u64 posts_not_found;
+	/*
+	 * The number of post calls that found an existing entry that is current enough to only
+	 * exist in memory and not have been committed to disk yet
+	 */
+	u64 in_memory_posts_found;
+	/*
+	 * The number of post calls that found an existing entry in the dense portion of the index
+	 */
+	u64 dense_posts_found;
+	/*
+	 * The number of post calls that found an existing entry in the sparse portion of the index
+	 */
+	u64 sparse_posts_found;
+	/* The number of update calls that updated an existing entry */
+	u64 updates_found;
+	/* The number of update calls that added a new entry */
+	u64 updates_not_found;
+	/* The number of delete requests that deleted an existing entry */
+	u64 deletions_found;
+	/* The number of delete requests that did nothing */
+	u64 deletions_not_found;
+	/* The number of query calls that found existing entry */
+	u64 queries_found;
+	/* The number of query calls that did not find an entry */
+	u64 queries_not_found;
+	/* The total number of requests processed */
+	u64 requests;
+};
+
+enum uds_index_region {
+	/* No location information has been determined */
+	UDS_LOCATION_UNKNOWN = 0,
+	/* The index page entry has been found */
+	UDS_LOCATION_INDEX_PAGE_LOOKUP,
+	/* The record page entry has been found */
+	UDS_LOCATION_RECORD_PAGE_LOOKUP,
+	/* The record is not in the index */
+	UDS_LOCATION_UNAVAILABLE,
+	/* The record was found in the open chapter */
+	UDS_LOCATION_IN_OPEN_CHAPTER,
+	/* The record was found in the dense part of the index */
+	UDS_LOCATION_IN_DENSE,
+	/* The record was found in the sparse part of the index */
+	UDS_LOCATION_IN_SPARSE,
+} __packed;
+
+/* Zone message requests are used to communicate between index zones. */
+enum uds_zone_message_type {
+	/* A standard request with no message */
+	UDS_MESSAGE_NONE = 0,
+	/* Add a chapter to the sparse chapter index cache */
+	UDS_MESSAGE_SPARSE_CACHE_BARRIER,
+	/* Close a chapter to keep the zone from falling behind */
+	UDS_MESSAGE_ANNOUNCE_CHAPTER_CLOSED,
+} __packed;
+
+struct uds_zone_message {
+	/* The type of message, determining how it will be processed */
+	enum uds_zone_message_type type;
+	/* The virtual chapter number to which the message applies */
+	u64 virtual_chapter;
+};
+
+struct uds_index_session;
+struct uds_index;
+struct uds_request;
+
+/* Once this callback has been invoked, the uds_request structure can be reused or freed. */
+typedef void uds_request_callback_t(struct uds_request *request);
+
+struct uds_request {
+	/* These input fields must be set before launching a request. */
+
+	/* The name of the record to look up or create */
+	struct uds_record_name record_name;
+	/* New data to associate with the record name, if applicable */
+	struct uds_record_data new_metadata;
+	/* A callback to invoke when the request is complete */
+	uds_request_callback_t *callback;
+	/* The index session that will manage this request */
+	struct uds_index_session *session;
+	/* The type of operation to perform, as describe above */
+	enum uds_request_type type;
+
+	/* These output fields are set when a request is complete. */
+
+	/* The existing data associated with the request name, if any */
+	struct uds_record_data old_metadata;
+	/* Either UDS_SUCCESS or an error code for the request */
+	int status;
+	/* True if the record name had an existing entry in the index */
+	bool found;
+
+	/*
+	 * The remaining fields are used internally and should not be altered by clients. The index
+	 * relies on zone_number being the first field in this section.
+	 */
+
+	/* The number of the zone which will process this request*/
+	unsigned int zone_number;
+	/* A link for adding a request to a lock-free queue */
+	struct funnel_queue_entry queue_link;
+	/* A link for adding a request to a standard linked list */
+	struct uds_request *next_request;
+	/* A pointer to the index processing this request */
+	struct uds_index *index;
+	/* Control message for coordinating between zones */
+	struct uds_zone_message zone_message;
+	/* If true, process request immediately by waking the worker thread */
+	bool unbatched;
+	/* If true, continue this request before processing newer requests */
+	bool requeued;
+	/* The virtual chapter containing the record name, if known */
+	u64 virtual_chapter;
+	/* The region of the index containing the record name */
+	enum uds_index_region location;
+};
+
+/* Compute the number of bytes needed to store an index. */
+int __must_check uds_compute_index_size(const struct uds_parameters *parameters, u64 *index_size);
+
+/* A session is required for most index operations. */
+int __must_check uds_create_index_session(struct uds_index_session **session);
+
+/* Destroying an index session also closes and saves the associated index. */
+int uds_destroy_index_session(struct uds_index_session *session);
+
+/*
+ * Create or open an index with an existing session. This operation fails if the index session is
+ * suspended, or if there is already an open index.
+ */
+int __must_check uds_open_index(enum uds_open_index_type open_type,
+				const struct uds_parameters *parameters,
+				struct uds_index_session *session);
+
+/*
+ * Wait until all callbacks for index operations are complete, and prevent new index operations
+ * from starting. New index operations will fail with EBUSY until the session is resumed. Also
+ * optionally saves the index.
+ */
+int __must_check uds_suspend_index_session(struct uds_index_session *session, bool save);
+
+/*
+ * Allow new index operations for an index, whether it was suspended or not. If the index is
+ * suspended and the supplied name differs from the current backing store, the index will start
+ * using the new backing store instead.
+ */
+int __must_check uds_resume_index_session(struct uds_index_session *session, const char *name);
+
+/* Wait until all outstanding index operations are complete. */
+int __must_check uds_flush_index_session(struct uds_index_session *session);
+
+/* Close an index. This operation fails if the index session is suspended. */
+int __must_check uds_close_index(struct uds_index_session *session);
+
+/*
+ * Return a copy of the parameters used to create the index. The caller is responsible for freeing
+ * the returned structure.
+ */
+int __must_check
+uds_get_index_parameters(struct uds_index_session *session, struct uds_parameters **parameters);
+
+/* Get index statistics since the last time the index was opened. */
+int __must_check
+uds_get_index_session_stats(struct uds_index_session *session, struct uds_index_stats *stats);
+
+/* This function will fail if any required field of the request is not set. */
+int __must_check uds_launch_request(struct uds_request *request);
+
+#endif /* UDS_H */
diff --git a/drivers/md/dm-vdo/volume-index.c b/drivers/md/dm-vdo/volume-index.c
new file mode 100644
index 00000000000..0a5944cfa8e
--- /dev/null
+++ b/drivers/md/dm-vdo/volume-index.c
@@ -0,0 +1,1272 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+#include "volume-index.h"
+
+#include <linux/bitops.h>
+#include <linux/bits.h>
+#include <linux/cache.h>
+#include <linux/compiler.h>
+#include <linux/log2.h>
+
+#include "config.h"
+#include "errors.h"
+#include "geometry.h"
+#include "hash-utils.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "numeric.h"
+#include "permassert.h"
+#include "uds.h"
+#include "uds-threads.h"
+
+/*
+ * The volume index is a combination of two separate subindexes, one containing sparse hook entries
+ * (retained for all chapters), and one containing the remaining entries (retained only for the
+ * dense chapters). If there are no sparse chapters, only the non-hook sub index is used, and it
+ * will contain all records for all chapters.
+ *
+ * The volume index is also divided into zones, with one thread operating on each zone. Each
+ * incoming request is dispatched to the appropriate thread, and then to the appropriate subindex.
+ * Each delta list is handled by a single zone. To ensure that the distribution of delta lists to
+ * zones doesn't underflow (leaving some zone with no delta lists), the minimum number of delta
+ * lists must be the square of the maximum zone count for both subindexes.
+ *
+ * Each subindex zone is a delta index where the payload is a chapter number. The volume index can
+ * compute the delta list number, address, and zone number from the record name in order to
+ * dispatch record handling to the correct structures.
+ *
+ * Most operations that use all the zones take place either before request processing is allowed,
+ * or after all requests have been flushed in order to shut down. The only multi-threaded operation
+ * supported during normal operation is the uds_lookup_volume_index_name() method, used to determine
+ * whether a new chapter should be loaded into the sparse index cache. This operation only uses the
+ * sparse hook subindex, and the zone mutexes are used to make this operation safe.
+ *
+ * There are three ways of expressing chapter numbers in the volume index: virtual, index, and
+ * rolling. The interface to the volume index uses virtual chapter numbers, which are 64 bits long.
+ * Internally the subindex stores only the minimal number of bits necessary by masking away the
+ * high-order bits. When the index needs to deal with ordering of index chapter numbers, as when
+ * flushing entries from older chapters, it rolls the index chapter number around so that the
+ * smallest one in use is mapped to 0. See convert_index_to_virtual() or flush_invalid_entries()
+ * for an example of this technique.
+ *
+ * For efficiency, when older chapter numbers become invalid, the index does not immediately remove
+ * the invalidated entries. Instead it lazily removes them from a given delta list the next time it
+ * walks that list during normal operation. Because of this, the index size must be increased
+ * somewhat to accommodate all the invalid entries that have not yet been removed. For the standard
+ * index sizes, this requires about 4 chapters of old entries per 1024 chapters of valid entries in
+ * the index.
+ */
+
+struct sub_index_parameters {
+	/* The number of bits in address mask */
+	u8 address_bits;
+	/* The number of bits in chapter number */
+	u8 chapter_bits;
+	/* The mean delta */
+	u32 mean_delta;
+	/* The number of delta lists */
+	u64 list_count;
+	/* The number of chapters used */
+	u32 chapter_count;
+	/* The number of bits per chapter */
+	size_t chapter_size_in_bits;
+	/* The number of bytes of delta list memory */
+	size_t memory_size;
+	/* The number of bytes the index should keep free at all times */
+	size_t target_free_bytes;
+};
+
+struct split_config {
+	/* The hook subindex configuration */
+	struct configuration hook_config;
+	struct geometry hook_geometry;
+
+	/* The non-hook subindex configuration */
+	struct configuration non_hook_config;
+	struct geometry non_hook_geometry;
+};
+
+struct chapter_range {
+	u32 chapter_start;
+	u32 chapter_count;
+};
+
+enum { MAGIC_SIZE = 8 };
+static const char MAGIC_START_5[] = "MI5-0005";
+
+struct sub_index_data {
+	char magic[MAGIC_SIZE]; /* MAGIC_START_5 */
+	u64 volume_nonce;
+	u64 virtual_chapter_low;
+	u64 virtual_chapter_high;
+	u32 first_list;
+	u32 list_count;
+};
+
+static const char MAGIC_START_6[] = "MI6-0001";
+
+struct volume_index_data {
+	char magic[MAGIC_SIZE]; /* MAGIC_START_6 */
+	u32 sparse_sample_rate;
+};
+
+static inline u32
+extract_address(const struct volume_sub_index *sub_index, const struct uds_record_name *name)
+{
+	return uds_extract_volume_index_bytes(name) & sub_index->address_mask;
+}
+
+static inline u32
+extract_dlist_num(const struct volume_sub_index *sub_index, const struct uds_record_name *name)
+{
+	u64 bits = uds_extract_volume_index_bytes(name);
+
+	return (bits >> sub_index->address_bits) % sub_index->list_count;
+}
+
+static inline const struct volume_sub_index_zone *
+get_zone_for_record(const struct volume_index_record *record)
+{
+	return &record->sub_index->zones[record->zone_number];
+}
+
+static inline u64
+convert_index_to_virtual(const struct volume_index_record *record, u32 index_chapter)
+{
+	const struct volume_sub_index_zone *volume_index_zone = get_zone_for_record(record);
+	u32 rolling_chapter = ((index_chapter - volume_index_zone->virtual_chapter_low) &
+			       record->sub_index->chapter_mask);
+
+	return volume_index_zone->virtual_chapter_low + rolling_chapter;
+}
+
+static inline u32
+convert_virtual_to_index(const struct volume_sub_index *sub_index, u64 virtual_chapter)
+{
+	return virtual_chapter & sub_index->chapter_mask;
+}
+
+static inline bool
+is_virtual_chapter_indexed(const struct volume_index_record *record, u64 virtual_chapter)
+{
+	const struct volume_sub_index_zone *volume_index_zone = get_zone_for_record(record);
+
+	return ((virtual_chapter >= volume_index_zone->virtual_chapter_low) &&
+		(virtual_chapter <= volume_index_zone->virtual_chapter_high));
+}
+
+static inline bool has_sparse(const struct volume_index *volume_index)
+{
+	return volume_index->sparse_sample_rate > 0;
+}
+
+bool uds_is_volume_index_sample(const struct volume_index *volume_index,
+				const struct uds_record_name *name)
+{
+	if (!has_sparse(volume_index))
+		return false;
+
+	return (uds_extract_sampling_bytes(name) % volume_index->sparse_sample_rate) == 0;
+}
+
+static inline const struct volume_sub_index *
+get_sub_index(const struct volume_index *volume_index, const struct uds_record_name *name)
+{
+	return (uds_is_volume_index_sample(volume_index, name) ?
+		&volume_index->vi_hook :
+		&volume_index->vi_non_hook);
+}
+
+static unsigned int get_volume_sub_index_zone(const struct volume_sub_index *sub_index,
+					      const struct uds_record_name *name)
+{
+	return extract_dlist_num(sub_index, name) / sub_index->delta_index.lists_per_zone;
+}
+
+unsigned int uds_get_volume_index_zone(const struct volume_index *volume_index,
+				       const struct uds_record_name *name)
+{
+	return get_volume_sub_index_zone(get_sub_index(volume_index, name), name);
+}
+
+static int compute_volume_sub_index_parameters(const struct configuration *config,
+					       struct sub_index_parameters *params)
+{
+	enum { DELTA_LIST_SIZE = 256 };
+	u64 entries_in_volume_index, address_span;
+	u32 chapters_in_volume_index, invalid_chapters;
+	u32 rounded_chapters;
+	u64 delta_list_records;
+	u32 address_count;
+	u64 index_size_in_bits;
+	size_t expected_index_size;
+	u64 min_delta_lists = MAX_ZONES * MAX_ZONES;
+	struct geometry *geometry = config->geometry;
+	u64 records_per_chapter = geometry->records_per_chapter;
+
+	params->chapter_count = geometry->chapters_per_volume;
+	/*
+	 * Make sure that the number of delta list records in the volume index does not change when
+	 * the volume is reduced by one chapter. This preserves the mapping from name to volume
+	 * index delta list.
+	 */
+	rounded_chapters = params->chapter_count;
+	if (uds_is_reduced_geometry(geometry))
+		rounded_chapters += 1;
+	delta_list_records = records_per_chapter * rounded_chapters;
+	address_count = config->volume_index_mean_delta * DELTA_LIST_SIZE;
+	params->list_count = max(delta_list_records / DELTA_LIST_SIZE, min_delta_lists);
+	params->address_bits = bits_per(address_count - 1);
+	params->chapter_bits = bits_per(rounded_chapters - 1);
+	if ((u32) params->list_count != params->list_count)
+		return uds_log_warning_strerror(UDS_INVALID_ARGUMENT,
+						"cannot initialize volume index with %llu delta lists",
+						(unsigned long long) params->list_count);
+	if (params->address_bits > 31)
+		return uds_log_warning_strerror(UDS_INVALID_ARGUMENT,
+						"cannot initialize volume index with %u address bits",
+						params->address_bits);
+
+	/*
+	 * The probability that a given delta list is not touched during the writing of an entire
+	 * chapter is:
+	 *
+	 * double p_not_touched = pow((double) (params->list_count - 1) / params->list_count,
+	 *                            records_per_chapter);
+	 *
+	 * For the standard index sizes, about 78% of the delta lists are not touched, and
+	 * therefore contain old index entries that have not been eliminated by the lazy LRU
+	 * processing. Then the number of old index entries that accumulate over the entire index,
+	 * in terms of full chapters worth of entries, is:
+	 *
+	 * double invalid_chapters = p_not_touched / (1.0 - p_not_touched);
+	 *
+	 * For the standard index sizes, the index needs about 3.5 chapters of space for the old
+	 * entries in a 1024 chapter index, so round this up to use 4 chapters per 1024 chapters in
+	 * the index.
+	 */
+	invalid_chapters = max(rounded_chapters / 256, 2U);
+	chapters_in_volume_index = rounded_chapters + invalid_chapters;
+	entries_in_volume_index = records_per_chapter * chapters_in_volume_index;
+
+	address_span = params->list_count << params->address_bits;
+	params->mean_delta = address_span / entries_in_volume_index;
+
+	/*
+	 * Compute the expected size of a full index, then set the total memory to be 6% larger
+	 * than that expected size. This number should be large enough that there are not many
+	 * rebalances when the index is full.
+	 */
+	params->chapter_size_in_bits = uds_compute_delta_index_size(records_per_chapter,
+								    params->mean_delta,
+								    params->chapter_bits);
+	index_size_in_bits = params->chapter_size_in_bits * chapters_in_volume_index;
+	expected_index_size = index_size_in_bits / BITS_PER_BYTE;
+	params->memory_size = expected_index_size * 106 / 100;
+
+	params->target_free_bytes = expected_index_size / 20;
+	return UDS_SUCCESS;
+}
+
+static void uninitialize_volume_sub_index(struct volume_sub_index *sub_index)
+{
+	UDS_FREE(UDS_FORGET(sub_index->flush_chapters));
+	UDS_FREE(UDS_FORGET(sub_index->zones));
+	uds_uninitialize_delta_index(&sub_index->delta_index);
+}
+
+void uds_free_volume_index(struct volume_index *volume_index)
+{
+	if (volume_index == NULL)
+		return;
+
+	if (volume_index->zones != NULL) {
+		unsigned int zone;
+
+		for (zone = 0; zone < volume_index->zone_count; zone++)
+			uds_destroy_mutex(&volume_index->zones[zone].hook_mutex);
+		UDS_FREE(UDS_FORGET(volume_index->zones));
+	}
+
+	uninitialize_volume_sub_index(&volume_index->vi_non_hook);
+	uninitialize_volume_sub_index(&volume_index->vi_hook);
+	UDS_FREE(volume_index);
+}
+
+
+static int
+compute_volume_sub_index_save_bytes(const struct configuration *config, size_t *bytes)
+{
+	struct sub_index_parameters params = { .address_bits = 0 };
+	int result;
+
+	result = compute_volume_sub_index_parameters(config, &params);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	*bytes = (sizeof(struct sub_index_data) + params.list_count * sizeof(u64) +
+		  uds_compute_delta_index_save_bytes(params.list_count, params.memory_size));
+	return UDS_SUCCESS;
+}
+
+/* This function is only useful if the configuration includes sparse chapters. */
+static void split_configuration(const struct configuration *config, struct split_config *split)
+{
+	u64 sample_rate, sample_records;
+	u64 dense_chapters, sparse_chapters;
+
+	/* Start with copies of the base configuration. */
+	split->hook_config = *config;
+	split->hook_geometry = *config->geometry;
+	split->hook_config.geometry = &split->hook_geometry;
+	split->non_hook_config = *config;
+	split->non_hook_geometry = *config->geometry;
+	split->non_hook_config.geometry = &split->non_hook_geometry;
+
+	sample_rate = config->sparse_sample_rate;
+	sparse_chapters = config->geometry->sparse_chapters_per_volume;
+	dense_chapters = config->geometry->chapters_per_volume - sparse_chapters;
+	sample_records = config->geometry->records_per_chapter / sample_rate;
+
+	/* Adjust the number of records indexed for each chapter. */
+	split->hook_geometry.records_per_chapter = sample_records;
+	split->non_hook_geometry.records_per_chapter -= sample_records;
+
+	/* Adjust the number of chapters indexed. */
+	split->hook_geometry.sparse_chapters_per_volume = 0;
+	split->non_hook_geometry.sparse_chapters_per_volume = 0;
+	split->non_hook_geometry.chapters_per_volume = dense_chapters;
+}
+
+static int compute_volume_index_save_bytes(const struct configuration *config, size_t *bytes)
+{
+	size_t hook_bytes, non_hook_bytes;
+	struct split_config split;
+	int result;
+
+	if (!uds_is_sparse_geometry(config->geometry))
+		return compute_volume_sub_index_save_bytes(config, bytes);
+
+	split_configuration(config, &split);
+	result = compute_volume_sub_index_save_bytes(&split.hook_config, &hook_bytes);
+	if (result != UDS_SUCCESS)
+		return result;
+	result = compute_volume_sub_index_save_bytes(&split.non_hook_config, &non_hook_bytes);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	*bytes = sizeof(struct volume_index_data) + hook_bytes + non_hook_bytes;
+	return UDS_SUCCESS;
+}
+
+int uds_compute_volume_index_save_blocks(const struct configuration *config,
+					 size_t block_size,
+					 u64 *block_count)
+{
+	size_t bytes;
+	int result;
+
+	result = compute_volume_index_save_bytes(config, &bytes);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	bytes += sizeof(struct delta_list_save_info);
+	*block_count = DIV_ROUND_UP(bytes, block_size) + MAX_ZONES;
+	return UDS_SUCCESS;
+}
+
+/* Flush invalid entries while walking the delta list. */
+static inline int flush_invalid_entries(struct volume_index_record *record,
+					struct chapter_range *flush_range,
+					u32 *next_chapter_to_invalidate)
+{
+	int result;
+
+	result = uds_next_delta_index_entry(&record->delta_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+	while (!record->delta_entry.at_end) {
+		u32 index_chapter = uds_get_delta_entry_value(&record->delta_entry);
+		u32 relative_chapter = ((index_chapter - flush_range->chapter_start) &
+					record->sub_index->chapter_mask);
+
+		if (likely(relative_chapter >= flush_range->chapter_count)) {
+			if (relative_chapter < *next_chapter_to_invalidate)
+				*next_chapter_to_invalidate = relative_chapter;
+			break;
+		}
+		result = uds_remove_delta_index_entry(&record->delta_entry);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+	return UDS_SUCCESS;
+}
+
+/* Find the matching record, or the list offset where the record would go. */
+static int get_volume_index_entry(struct volume_index_record *record,
+				  u32 list_number,
+				  u32 key,
+				  struct chapter_range *flush_range)
+{
+	struct volume_index_record other_record;
+	const struct volume_sub_index *sub_index = record->sub_index;
+	u32 next_chapter_to_invalidate = sub_index->chapter_mask;
+	int result;
+
+	result = uds_start_delta_index_search(&sub_index->delta_index,
+					      list_number,
+					      0,
+					      &record->delta_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+	do {
+		result = flush_invalid_entries(record, flush_range, &next_chapter_to_invalidate);
+		if (result != UDS_SUCCESS)
+			return result;
+	} while (!record->delta_entry.at_end && (key > record->delta_entry.key));
+
+	result = uds_remember_delta_index_offset(&record->delta_entry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	/* Check any collision records for a more precise match. */
+	other_record = *record;
+	if (!other_record.delta_entry.at_end && (key == other_record.delta_entry.key)) {
+		for (;;) {
+			u8 collision_name[UDS_RECORD_NAME_SIZE];
+
+			result = flush_invalid_entries(&other_record,
+						       flush_range,
+						       &next_chapter_to_invalidate);
+			if (result != UDS_SUCCESS)
+				return result;
+			if (other_record.delta_entry.at_end ||
+			    !other_record.delta_entry.is_collision)
+				break;
+			result = uds_get_delta_entry_collision(&other_record.delta_entry,
+							       collision_name);
+			if (result != UDS_SUCCESS)
+				return result;
+			if (memcmp(collision_name, record->name, UDS_RECORD_NAME_SIZE) == 0) {
+				*record = other_record;
+				break;
+			}
+		}
+	}
+	while (!other_record.delta_entry.at_end) {
+		result = flush_invalid_entries(&other_record,
+					       flush_range,
+					       &next_chapter_to_invalidate);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+	next_chapter_to_invalidate += flush_range->chapter_start;
+	next_chapter_to_invalidate &= sub_index->chapter_mask;
+	flush_range->chapter_start = next_chapter_to_invalidate;
+	flush_range->chapter_count = 0;
+	return UDS_SUCCESS;
+}
+
+static int get_volume_sub_index_record(struct volume_sub_index *sub_index,
+				       const struct uds_record_name *name,
+				       struct volume_index_record *record)
+{
+	int result;
+	const struct volume_sub_index_zone *volume_index_zone;
+	u32 address = extract_address(sub_index, name);
+	u32 delta_list_number = extract_dlist_num(sub_index, name);
+	u64 flush_chapter = sub_index->flush_chapters[delta_list_number];
+
+	record->sub_index = sub_index;
+	record->mutex = NULL;
+	record->name = name;
+	record->zone_number = delta_list_number / sub_index->delta_index.lists_per_zone;
+	volume_index_zone = get_zone_for_record(record);
+
+	if (flush_chapter < volume_index_zone->virtual_chapter_low) {
+		struct chapter_range range;
+		u64 flush_count = volume_index_zone->virtual_chapter_low - flush_chapter;
+
+		range.chapter_start = convert_virtual_to_index(sub_index, flush_chapter);
+		range.chapter_count = (flush_count > sub_index->chapter_mask ?
+				       sub_index->chapter_mask + 1 :
+				       flush_count);
+		result = get_volume_index_entry(record, delta_list_number, address, &range);
+		flush_chapter = convert_index_to_virtual(record, range.chapter_start);
+		if (flush_chapter > volume_index_zone->virtual_chapter_high)
+			flush_chapter = volume_index_zone->virtual_chapter_high;
+		sub_index->flush_chapters[delta_list_number] = flush_chapter;
+	} else {
+		result = uds_get_delta_index_entry(&sub_index->delta_index,
+						   delta_list_number,
+						   address,
+						   name->name,
+						   &record->delta_entry);
+	}
+	if (result != UDS_SUCCESS)
+		return result;
+	record->is_found = (!record->delta_entry.at_end && (record->delta_entry.key == address));
+	if (record->is_found) {
+		u32 index_chapter = uds_get_delta_entry_value(&record->delta_entry);
+
+		record->virtual_chapter = convert_index_to_virtual(record, index_chapter);
+	}
+	record->is_collision = record->delta_entry.is_collision;
+	return UDS_SUCCESS;
+}
+
+int uds_get_volume_index_record(struct volume_index *volume_index,
+				const struct uds_record_name *name,
+				struct volume_index_record *record)
+{
+	int result;
+
+	if (uds_is_volume_index_sample(volume_index, name)) {
+		/*
+		 * Other threads cannot be allowed to call uds_lookup_volume_index_name() while
+		 * this thread is finding the volume index record. Due to the lazy LRU flushing of
+		 * the volume index, uds_get_volume_index_record() is not a read-only operation.
+		 */
+		unsigned int zone = get_volume_sub_index_zone(&volume_index->vi_hook, name);
+		struct mutex *mutex = &volume_index->zones[zone].hook_mutex;
+
+		uds_lock_mutex(mutex);
+		result = get_volume_sub_index_record(&volume_index->vi_hook, name, record);
+		uds_unlock_mutex(mutex);
+		/* Remember the mutex so that other operations on the index record can use it. */
+		record->mutex = mutex;
+	} else {
+		result = get_volume_sub_index_record(&volume_index->vi_non_hook, name, record);
+	}
+	return result;
+}
+
+int uds_put_volume_index_record(struct volume_index_record *record, u64 virtual_chapter)
+{
+	int result;
+	u32 address;
+	const struct volume_sub_index *sub_index = record->sub_index;
+
+	if (!is_virtual_chapter_indexed(record, virtual_chapter)) {
+		const struct volume_sub_index_zone *volume_index_zone =
+			get_zone_for_record(record);
+		return uds_log_warning_strerror(UDS_INVALID_ARGUMENT,
+						"cannot put record into chapter number %llu that is out of the valid range %llu to %llu",
+						(unsigned long long) virtual_chapter,
+						(unsigned long long) volume_index_zone->virtual_chapter_low,
+						(unsigned long long) volume_index_zone->virtual_chapter_high);
+	}
+	address = extract_address(sub_index, record->name);
+	if (unlikely(record->mutex != NULL))
+		uds_lock_mutex(record->mutex);
+	result = uds_put_delta_index_entry(&record->delta_entry,
+					   address,
+					   convert_virtual_to_index(sub_index, virtual_chapter),
+					   record->is_found ? record->name->name : NULL);
+	if (unlikely(record->mutex != NULL))
+		uds_unlock_mutex(record->mutex);
+	switch (result) {
+	case UDS_SUCCESS:
+		record->virtual_chapter = virtual_chapter;
+		record->is_collision = record->delta_entry.is_collision;
+		record->is_found = true;
+		break;
+	case UDS_OVERFLOW:
+		uds_log_ratelimit(uds_log_warning_strerror,
+				  UDS_OVERFLOW,
+				  "Volume index entry dropped due to overflow condition");
+		uds_log_delta_index_entry(&record->delta_entry);
+		break;
+	default:
+		break;
+	}
+	return result;
+}
+
+int uds_remove_volume_index_record(struct volume_index_record *record)
+{
+	int result;
+
+	if (!record->is_found)
+		return uds_log_warning_strerror(UDS_BAD_STATE, "illegal operation on new record");
+	/* Mark the record so that it cannot be used again */
+	record->is_found = false;
+	if (unlikely(record->mutex != NULL))
+		uds_lock_mutex(record->mutex);
+	result = uds_remove_delta_index_entry(&record->delta_entry);
+	if (unlikely(record->mutex != NULL))
+		uds_unlock_mutex(record->mutex);
+	return result;
+}
+
+static void set_volume_sub_index_zone_open_chapter(struct volume_sub_index *sub_index,
+						   unsigned int zone_number,
+						   u64 virtual_chapter)
+{
+	u64 used_bits = 0;
+	struct volume_sub_index_zone *zone = &sub_index->zones[zone_number];
+	struct delta_zone *delta_zone;
+	u32 i;
+
+	zone->virtual_chapter_low = (virtual_chapter >= sub_index->chapter_count ?
+				     virtual_chapter - sub_index->chapter_count + 1 :
+				     0);
+	zone->virtual_chapter_high = virtual_chapter;
+
+	/* Check to see if the new zone data is too large. */
+	delta_zone = &sub_index->delta_index.delta_zones[zone_number];
+	for (i = 1; i <= delta_zone->list_count; i++)
+		used_bits += delta_zone->delta_lists[i].size;
+
+	if (used_bits > sub_index->max_zone_bits) {
+		/* Expire enough chapters to free the desired space. */
+		u64 expire_count =
+			1 + (used_bits - sub_index->max_zone_bits) / sub_index->chapter_zone_bits;
+
+		if (expire_count == 1) {
+			uds_log_ratelimit(uds_log_info,
+					  "zone %u:  At chapter %llu, expiring chapter %llu early",
+					  zone_number,
+					  (unsigned long long) virtual_chapter,
+					  (unsigned long long) zone->virtual_chapter_low);
+			zone->early_flushes++;
+			zone->virtual_chapter_low++;
+		} else {
+			u64 first_expired = zone->virtual_chapter_low;
+
+			if (first_expired + expire_count < zone->virtual_chapter_high) {
+				zone->early_flushes += expire_count;
+				zone->virtual_chapter_low += expire_count;
+			} else {
+				zone->early_flushes +=
+					zone->virtual_chapter_high - zone->virtual_chapter_low;
+				zone->virtual_chapter_low = zone->virtual_chapter_high;
+			}
+			uds_log_ratelimit(uds_log_info,
+					  "zone %u:  At chapter %llu, expiring chapters %llu to %llu early",
+					  zone_number,
+					  (unsigned long long) virtual_chapter,
+					  (unsigned long long) first_expired,
+					  (unsigned long long) zone->virtual_chapter_low - 1);
+		}
+	}
+}
+
+void uds_set_volume_index_zone_open_chapter(struct volume_index *volume_index,
+					    unsigned int zone_number,
+					    u64 virtual_chapter)
+{
+	struct mutex *mutex = &volume_index->zones[zone_number].hook_mutex;
+
+	set_volume_sub_index_zone_open_chapter(&volume_index->vi_non_hook,
+					       zone_number,
+					       virtual_chapter);
+
+	/*
+	 * Other threads cannot be allowed to call uds_lookup_volume_index_name() while the open
+	 * chapter number is changing.
+	 */
+	if (has_sparse(volume_index)) {
+		uds_lock_mutex(mutex);
+		set_volume_sub_index_zone_open_chapter(&volume_index->vi_hook,
+						       zone_number,
+						       virtual_chapter);
+		uds_unlock_mutex(mutex);
+	}
+}
+
+/*
+ * Set the newest open chapter number for the index, while also advancing the oldest valid chapter
+ * number.
+ */
+void uds_set_volume_index_open_chapter(struct volume_index *volume_index, u64 virtual_chapter)
+{
+	unsigned int zone;
+
+	for (zone = 0; zone < volume_index->zone_count; zone++)
+		uds_set_volume_index_zone_open_chapter(volume_index, zone, virtual_chapter);
+}
+
+int uds_set_volume_index_record_chapter(struct volume_index_record *record, u64 virtual_chapter)
+{
+	const struct volume_sub_index *sub_index = record->sub_index;
+	int result;
+
+	if (!record->is_found)
+		return uds_log_warning_strerror(UDS_BAD_STATE, "illegal operation on new record");
+	if (!is_virtual_chapter_indexed(record, virtual_chapter)) {
+		const struct volume_sub_index_zone *sub_index_zone = get_zone_for_record(record);
+
+		return uds_log_warning_strerror(UDS_INVALID_ARGUMENT,
+						"cannot set chapter number %llu that is out of the valid range %llu to %llu",
+						(unsigned long long) virtual_chapter,
+						(unsigned long long) sub_index_zone->virtual_chapter_low,
+						(unsigned long long) sub_index_zone->virtual_chapter_high);
+	}
+	if (unlikely(record->mutex != NULL))
+		uds_lock_mutex(record->mutex);
+	result = uds_set_delta_entry_value(&record->delta_entry,
+					   convert_virtual_to_index(sub_index, virtual_chapter));
+	if (unlikely(record->mutex != NULL))
+		uds_unlock_mutex(record->mutex);
+	if (result != UDS_SUCCESS)
+		return result;
+	record->virtual_chapter = virtual_chapter;
+	return UDS_SUCCESS;
+}
+
+static u64 lookup_volume_sub_index_name(const struct volume_sub_index *sub_index,
+					const struct uds_record_name *name)
+{
+	int result;
+	u32 address = extract_address(sub_index, name);
+	u32 delta_list_number = extract_dlist_num(sub_index, name);
+	unsigned int zone_number = get_volume_sub_index_zone(sub_index, name);
+	const struct volume_sub_index_zone *zone = &sub_index->zones[zone_number];
+	u64 virtual_chapter;
+	u32 index_chapter;
+	u32 rolling_chapter;
+	struct delta_index_entry delta_entry;
+
+	result = uds_get_delta_index_entry(&sub_index->delta_index,
+					   delta_list_number,
+					   address,
+					   name->name,
+					   &delta_entry);
+	if (result != UDS_SUCCESS)
+		return NO_CHAPTER;
+
+	if (delta_entry.at_end || (delta_entry.key != address))
+		return NO_CHAPTER;
+
+	index_chapter = uds_get_delta_entry_value(&delta_entry);
+	rolling_chapter = (index_chapter - zone->virtual_chapter_low) & sub_index->chapter_mask;
+
+	virtual_chapter = zone->virtual_chapter_low + rolling_chapter;
+	if (virtual_chapter > zone->virtual_chapter_high)
+		return NO_CHAPTER;
+
+	return virtual_chapter;
+}
+
+/* Do a read-only lookup of the record name for sparse cache management. */
+u64 uds_lookup_volume_index_name(const struct volume_index *volume_index,
+				 const struct uds_record_name *name)
+{
+	unsigned int zone_number = uds_get_volume_index_zone(volume_index, name);
+	struct mutex *mutex = &volume_index->zones[zone_number].hook_mutex;
+	u64 virtual_chapter;
+
+	if (!uds_is_volume_index_sample(volume_index, name))
+		return NO_CHAPTER;
+
+	uds_lock_mutex(mutex);
+	virtual_chapter = lookup_volume_sub_index_name(&volume_index->vi_hook, name);
+	uds_unlock_mutex(mutex);
+
+	return virtual_chapter;
+}
+
+static void abort_restoring_volume_sub_index(struct volume_sub_index *sub_index)
+{
+	uds_reset_delta_index(&sub_index->delta_index);
+}
+
+static void abort_restoring_volume_index(struct volume_index *volume_index)
+{
+	abort_restoring_volume_sub_index(&volume_index->vi_non_hook);
+	if (has_sparse(volume_index))
+		abort_restoring_volume_sub_index(&volume_index->vi_hook);
+}
+
+static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
+					    struct buffered_reader **readers,
+					    unsigned int reader_count)
+{
+	unsigned int z;
+	int result;
+	u64 virtual_chapter_low = 0, virtual_chapter_high = 0;
+	unsigned int i;
+
+	for (i = 0; i < reader_count; i++) {
+		struct sub_index_data header;
+		u8 buffer[sizeof(struct sub_index_data)];
+		size_t offset = 0;
+		u32 j;
+
+		result = uds_read_from_buffered_reader(readers[i], buffer, sizeof(buffer));
+		if (result != UDS_SUCCESS)
+			return uds_log_warning_strerror(result,
+							"failed to read volume index header");
+
+		memcpy(&header.magic, buffer, MAGIC_SIZE);
+		offset += MAGIC_SIZE;
+		decode_u64_le(buffer, &offset, &header.volume_nonce);
+		decode_u64_le(buffer, &offset, &header.virtual_chapter_low);
+		decode_u64_le(buffer, &offset, &header.virtual_chapter_high);
+		decode_u32_le(buffer, &offset, &header.first_list);
+		decode_u32_le(buffer, &offset, &header.list_count);
+
+		result = ASSERT(offset = sizeof(buffer),
+				"%zu bytes decoded of %zu expected",
+				offset,
+				sizeof(buffer));
+		if (result != UDS_SUCCESS)
+			result = UDS_CORRUPT_DATA;
+
+		if (memcmp(header.magic, MAGIC_START_5, MAGIC_SIZE) != 0)
+			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+							"volume index file had bad magic number");
+
+		if (sub_index->volume_nonce == 0)
+			sub_index->volume_nonce = header.volume_nonce;
+		else if (header.volume_nonce != sub_index->volume_nonce)
+			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+							"volume index volume nonce incorrect");
+
+		if (i == 0) {
+			virtual_chapter_low = header.virtual_chapter_low;
+			virtual_chapter_high = header.virtual_chapter_high;
+		} else if (virtual_chapter_high != header.virtual_chapter_high) {
+			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+							"Inconsistent volume index zone files: Chapter range is [%llu,%llu], chapter range %d is [%llu,%llu]",
+							(unsigned long long) virtual_chapter_low,
+							(unsigned long long) virtual_chapter_high,
+							i,
+							(unsigned long long) header.virtual_chapter_low,
+							(unsigned long long) header.virtual_chapter_high);
+		} else if (virtual_chapter_low < header.virtual_chapter_low) {
+			virtual_chapter_low = header.virtual_chapter_low;
+		}
+
+		for (j = 0; j < header.list_count; j++) {
+			u8 decoded[sizeof(u64)];
+
+			result = uds_read_from_buffered_reader(readers[i], decoded, sizeof(u64));
+			if (result != UDS_SUCCESS)
+				return uds_log_warning_strerror(result,
+								"failed to read volume index flush ranges");
+
+			sub_index->flush_chapters[header.first_list + j] =
+				get_unaligned_le64(decoded);
+		}
+	}
+
+	for (z = 0; z < sub_index->zone_count; z++) {
+		memset(&sub_index->zones[z], 0, sizeof(struct volume_sub_index_zone));
+		sub_index->zones[z].virtual_chapter_low = virtual_chapter_low;
+		sub_index->zones[z].virtual_chapter_high = virtual_chapter_high;
+	}
+
+	result = uds_start_restoring_delta_index(&sub_index->delta_index, readers, reader_count);
+	if (result != UDS_SUCCESS)
+		return uds_log_warning_strerror(result, "restoring delta index failed");
+
+	return UDS_SUCCESS;
+}
+
+static int start_restoring_volume_index(struct volume_index *volume_index,
+					struct buffered_reader **buffered_readers,
+					unsigned int reader_count)
+{
+	unsigned int i;
+	int result;
+
+	if (!has_sparse(volume_index))
+		return start_restoring_volume_sub_index(&volume_index->vi_non_hook,
+							buffered_readers,
+							reader_count);
+
+	for (i = 0; i < reader_count; i++) {
+		struct volume_index_data header;
+		u8 buffer[sizeof(struct volume_index_data)];
+		size_t offset = 0;
+
+		result = uds_read_from_buffered_reader(buffered_readers[i], buffer, sizeof(buffer));
+		if (result != UDS_SUCCESS)
+			return uds_log_warning_strerror(result,
+							"failed to read volume index header");
+
+		memcpy(&header.magic, buffer, MAGIC_SIZE);
+		offset += MAGIC_SIZE;
+		decode_u32_le(buffer, &offset, &header.sparse_sample_rate);
+
+		result = ASSERT(offset == sizeof(buffer),
+				"%zu bytes decoded of %zu expected",
+				offset,
+				sizeof(buffer));
+		if (result != UDS_SUCCESS)
+			result = UDS_CORRUPT_DATA;
+
+		if (memcmp(header.magic, MAGIC_START_6, MAGIC_SIZE) != 0)
+			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+							"volume index file had bad magic number");
+
+		if (i == 0) {
+			volume_index->sparse_sample_rate = header.sparse_sample_rate;
+		} else if (volume_index->sparse_sample_rate != header.sparse_sample_rate) {
+			uds_log_warning_strerror(UDS_CORRUPT_DATA,
+						 "Inconsistent sparse sample rate in delta index zone files: %u vs. %u",
+						 volume_index->sparse_sample_rate,
+						 header.sparse_sample_rate);
+			return UDS_CORRUPT_DATA;
+		}
+	}
+
+	result = start_restoring_volume_sub_index(&volume_index->vi_non_hook,
+						  buffered_readers,
+						  reader_count);
+	if (result != UDS_SUCCESS)
+		return result;
+	return start_restoring_volume_sub_index(&volume_index->vi_hook,
+						buffered_readers,
+						reader_count);
+}
+
+static int finish_restoring_volume_sub_index(struct volume_sub_index *sub_index,
+					     struct buffered_reader **buffered_readers,
+					     unsigned int reader_count)
+{
+	return uds_finish_restoring_delta_index(&sub_index->delta_index,
+						buffered_readers,
+						reader_count);
+}
+
+static int finish_restoring_volume_index(struct volume_index *volume_index,
+					 struct buffered_reader **buffered_readers,
+					 unsigned int reader_count)
+{
+	int result;
+
+	result = finish_restoring_volume_sub_index(&volume_index->vi_non_hook,
+						   buffered_readers,
+						   reader_count);
+	if ((result == UDS_SUCCESS) && has_sparse(volume_index))
+		result = finish_restoring_volume_sub_index(&volume_index->vi_hook,
+							   buffered_readers,
+							   reader_count);
+	return result;
+}
+
+int uds_load_volume_index(struct volume_index *volume_index,
+			  struct buffered_reader **readers,
+			  unsigned int reader_count)
+{
+	int result;
+
+	/* Start by reading the header section of the stream. */
+	result = start_restoring_volume_index(volume_index, readers, reader_count);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = finish_restoring_volume_index(volume_index, readers, reader_count);
+	if (result != UDS_SUCCESS) {
+		abort_restoring_volume_index(volume_index);
+		return result;
+	}
+
+	/* Check the final guard lists to make sure there is no extra data. */
+	result = uds_check_guard_delta_lists(readers, reader_count);
+	if (result != UDS_SUCCESS)
+		abort_restoring_volume_index(volume_index);
+
+	return result;
+}
+
+static int start_saving_volume_sub_index(const struct volume_sub_index *sub_index,
+					 unsigned int zone_number,
+					 struct buffered_writer *buffered_writer)
+{
+	int result;
+	struct volume_sub_index_zone *volume_index_zone = &sub_index->zones[zone_number];
+	u32 first_list = sub_index->delta_index.delta_zones[zone_number].first_list;
+	u32 list_count = sub_index->delta_index.delta_zones[zone_number].list_count;
+	u8 buffer[sizeof(struct sub_index_data)];
+	size_t offset = 0;
+	u32 i;
+
+	memcpy(buffer, MAGIC_START_5, MAGIC_SIZE);
+	offset += MAGIC_SIZE;
+	encode_u64_le(buffer, &offset, sub_index->volume_nonce);
+	encode_u64_le(buffer, &offset, volume_index_zone->virtual_chapter_low);
+	encode_u64_le(buffer, &offset, volume_index_zone->virtual_chapter_high);
+	encode_u32_le(buffer, &offset, first_list);
+	encode_u32_le(buffer, &offset, list_count);
+
+	result =  ASSERT(offset == sizeof(struct sub_index_data),
+			 "%zu bytes of config written, of %zu expected",
+			 offset,
+			 sizeof(struct sub_index_data));
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_write_to_buffered_writer(buffered_writer, buffer, offset);
+	if (result != UDS_SUCCESS)
+		return uds_log_warning_strerror(result, "failed to write volume index header");
+
+	for (i = 0; i < list_count; i++) {
+		u8 encoded[sizeof(u64)];
+
+		put_unaligned_le64(sub_index->flush_chapters[first_list + i], &encoded);
+		result = uds_write_to_buffered_writer(buffered_writer, encoded, sizeof(u64));
+		if (result != UDS_SUCCESS)
+			return uds_log_warning_strerror(result,
+							"failed to write volume index flush ranges");
+	}
+
+	return uds_start_saving_delta_index(&sub_index->delta_index, zone_number, buffered_writer);
+}
+
+static int start_saving_volume_index(const struct volume_index *volume_index,
+				     unsigned int zone_number,
+				     struct buffered_writer *writer)
+{
+	u8 buffer[sizeof(struct volume_index_data)];
+	size_t offset = 0;
+	int result;
+
+	if (!has_sparse(volume_index))
+		return start_saving_volume_sub_index(&volume_index->vi_non_hook,
+						     zone_number,
+						     writer);
+
+	memcpy(buffer, MAGIC_START_6, MAGIC_SIZE);
+	offset += MAGIC_SIZE;
+	encode_u32_le(buffer, &offset, volume_index->sparse_sample_rate);
+	result = ASSERT(offset == sizeof(struct volume_index_data),
+			"%zu bytes of header written, of %zu expected",
+			offset,
+			sizeof(struct volume_index_data));
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_write_to_buffered_writer(writer, buffer, offset);
+	if (result != UDS_SUCCESS) {
+		uds_log_warning_strerror(result, "failed to write volume index header");
+		return result;
+	}
+
+	result = start_saving_volume_sub_index(&volume_index->vi_non_hook, zone_number, writer);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	return start_saving_volume_sub_index(&volume_index->vi_hook, zone_number, writer);
+}
+
+static int
+finish_saving_volume_sub_index(const struct volume_sub_index *sub_index, unsigned int zone_number)
+{
+	return uds_finish_saving_delta_index(&sub_index->delta_index, zone_number);
+}
+
+static int
+finish_saving_volume_index(const struct volume_index *volume_index, unsigned int zone_number)
+{
+	int result;
+
+	result = finish_saving_volume_sub_index(&volume_index->vi_non_hook, zone_number);
+	if ((result == UDS_SUCCESS) && has_sparse(volume_index))
+		result = finish_saving_volume_sub_index(&volume_index->vi_hook, zone_number);
+	return result;
+}
+
+int uds_save_volume_index(struct volume_index *volume_index,
+			  struct buffered_writer **writers,
+			  unsigned int writer_count)
+{
+	int result = UDS_SUCCESS;
+	unsigned int zone;
+
+	for (zone = 0; zone < writer_count; ++zone) {
+		result = start_saving_volume_index(volume_index, zone, writers[zone]);
+		if (result != UDS_SUCCESS)
+			break;
+
+		result = finish_saving_volume_index(volume_index, zone);
+		if (result != UDS_SUCCESS)
+			break;
+
+		result = uds_write_guard_delta_list(writers[zone]);
+		if (result != UDS_SUCCESS)
+			break;
+
+		result = uds_flush_buffered_writer(writers[zone]);
+		if (result != UDS_SUCCESS)
+			break;
+	}
+
+	return result;
+}
+
+static void get_volume_sub_index_stats(const struct volume_sub_index *sub_index,
+				       struct volume_index_stats *stats)
+{
+	struct delta_index_stats dis;
+	unsigned int z;
+
+	uds_get_delta_index_stats(&sub_index->delta_index, &dis);
+	stats->rebalance_time = dis.rebalance_time;
+	stats->rebalance_count = dis.rebalance_count;
+	stats->record_count = dis.record_count;
+	stats->collision_count = dis.collision_count;
+	stats->discard_count = dis.discard_count;
+	stats->overflow_count = dis.overflow_count;
+	stats->delta_lists = dis.list_count;
+	stats->early_flushes = 0;
+	for (z = 0; z < sub_index->zone_count; z++)
+		stats->early_flushes += sub_index->zones[z].early_flushes;
+}
+
+void uds_get_volume_index_stats(const struct volume_index *volume_index,
+				struct volume_index_stats *stats)
+{
+	struct volume_index_stats sparse_stats;
+
+	get_volume_sub_index_stats(&volume_index->vi_non_hook, stats);
+	if (!has_sparse(volume_index))
+		return;
+
+	get_volume_sub_index_stats(&volume_index->vi_hook, &sparse_stats);
+	stats->rebalance_time += sparse_stats.rebalance_time;
+	stats->rebalance_count += sparse_stats.rebalance_count;
+	stats->record_count += sparse_stats.record_count;
+	stats->collision_count += sparse_stats.collision_count;
+	stats->discard_count += sparse_stats.discard_count;
+	stats->overflow_count += sparse_stats.overflow_count;
+	stats->delta_lists += sparse_stats.delta_lists;
+	stats->early_flushes += sparse_stats.early_flushes;
+}
+
+static int initialize_volume_sub_index(const struct configuration *config,
+				       u64 volume_nonce,
+				       u8 tag,
+				       struct volume_sub_index *sub_index)
+{
+	struct sub_index_parameters params = { .address_bits = 0 };
+	unsigned int zone_count = config->zone_count;
+	u64 available_bytes = 0;
+	unsigned int z;
+	int result;
+
+	result = compute_volume_sub_index_parameters(config, &params);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	sub_index->address_bits = params.address_bits;
+	sub_index->address_mask = (1u << params.address_bits) - 1;
+	sub_index->chapter_bits = params.chapter_bits;
+	sub_index->chapter_mask = (1u << params.chapter_bits) - 1;
+	sub_index->chapter_count = params.chapter_count;
+	sub_index->list_count = params.list_count;
+	sub_index->zone_count = zone_count;
+	sub_index->chapter_zone_bits = params.chapter_size_in_bits / zone_count;
+	sub_index->volume_nonce = volume_nonce;
+
+	result = uds_initialize_delta_index(&sub_index->delta_index,
+					    zone_count,
+					    params.list_count,
+					    params.mean_delta,
+					    params.chapter_bits,
+					    params.memory_size,
+					    tag);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	for (z = 0; z < sub_index->delta_index.zone_count; z++)
+		available_bytes += sub_index->delta_index.delta_zones[z].size;
+	available_bytes -= params.target_free_bytes;
+	sub_index->max_zone_bits = (available_bytes * BITS_PER_BYTE) / zone_count;
+	sub_index->memory_size = (sub_index->delta_index.memory_size +
+				  sizeof(struct volume_sub_index) +
+				  (params.list_count * sizeof(u64)) +
+				  (zone_count * sizeof(struct volume_sub_index_zone)));
+
+	/* The following arrays are initialized to all zeros. */
+	result = UDS_ALLOCATE(params.list_count,
+			      u64,
+			      "first chapter to flush",
+			      &sub_index->flush_chapters);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	return UDS_ALLOCATE(zone_count,
+			    struct volume_sub_index_zone,
+			    "volume index zones",
+			    &sub_index->zones);
+}
+
+int uds_make_volume_index(const struct configuration *config,
+			  u64 volume_nonce,
+			  struct volume_index **volume_index_ptr)
+{
+	struct split_config split;
+	unsigned int zone;
+	struct volume_index *volume_index;
+	int result;
+
+	result = UDS_ALLOCATE(1, struct volume_index, "volume index", &volume_index);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	volume_index->zone_count = config->zone_count;
+
+	if (!uds_is_sparse_geometry(config->geometry)) {
+		result = initialize_volume_sub_index(config,
+						     volume_nonce,
+						     'm',
+						     &volume_index->vi_non_hook);
+		if (result != UDS_SUCCESS) {
+			uds_free_volume_index(volume_index);
+			return result;
+		}
+
+		volume_index->memory_size = volume_index->vi_non_hook.memory_size;
+		*volume_index_ptr = volume_index;
+		return UDS_SUCCESS;
+	}
+
+	volume_index->sparse_sample_rate = config->sparse_sample_rate;
+
+	result = UDS_ALLOCATE(config->zone_count,
+			      struct volume_index_zone,
+			      "volume index zones",
+			      &volume_index->zones);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume_index(volume_index);
+		return result;
+	}
+
+	for (zone = 0; zone < config->zone_count; zone++) {
+		result = uds_init_mutex(&volume_index->zones[zone].hook_mutex);
+		if (result != UDS_SUCCESS) {
+			uds_free_volume_index(volume_index);
+			return result;
+		}
+	}
+
+	split_configuration(config, &split);
+	result = initialize_volume_sub_index(&split.non_hook_config,
+					     volume_nonce,
+					     'd',
+					     &volume_index->vi_non_hook);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume_index(volume_index);
+		return uds_log_error_strerror(result, "Error creating non hook volume index");
+	}
+
+	result = initialize_volume_sub_index(&split.hook_config,
+					     volume_nonce,
+					     's',
+					     &volume_index->vi_hook);
+	if (result != UDS_SUCCESS) {
+		uds_free_volume_index(volume_index);
+		return uds_log_error_strerror(result, "Error creating hook volume index");
+	}
+
+	volume_index->memory_size =
+		volume_index->vi_non_hook.memory_size + volume_index->vi_hook.memory_size;
+	*volume_index_ptr = volume_index;
+	return UDS_SUCCESS;
+}
diff --git a/drivers/md/dm-vdo/volume-index.h b/drivers/md/dm-vdo/volume-index.h
new file mode 100644
index 00000000000..c1103e56e2c
--- /dev/null
+++ b/drivers/md/dm-vdo/volume-index.h
@@ -0,0 +1,192 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef UDS_VOLUME_INDEX_H
+#define UDS_VOLUME_INDEX_H
+
+#include <linux/limits.h>
+
+#include "config.h"
+#include "delta-index.h"
+#include "uds.h"
+#include "uds-threads.h"
+
+/*
+ * The volume index is the primary top-level index for UDS. It contains records which map a record
+ * name to the chapter where a record with that name is stored. This mapping can definitively say
+ * when no record exists. However, because we only use a sebset of the name for this index, it
+ * cannot definitively say that a record for the entry does exist. It can only say that if a record
+ * exists, it will be in a particular chapter. The request can then be dispatched to that chapter
+ * for further processing.
+ *
+ * If the volume_index_record does not actually match the record name, the index can store a more
+ * specific collision record to disambiguate the new entry from the existing one. Index entries are
+ * managed with volume_index_record structures.
+ */
+
+static const u64 NO_CHAPTER = U64_MAX;
+
+struct volume_index_stats {
+	/* Nanoseconds spent rebalancing */
+	ktime_t rebalance_time;
+	/* Number of memory rebalances */
+	u32 rebalance_count;
+	/* The number of records in the index */
+	u64 record_count;
+	/* The number of collision records */
+	u64 collision_count;
+	/* The number of records removed */
+	u64 discard_count;
+	/* The number of UDS_OVERFLOWs detected */
+	u64 overflow_count;
+	/* The number of delta lists */
+	u32 delta_lists;
+	/* Number of early flushes */
+	u64 early_flushes;
+};
+
+struct volume_sub_index_zone {
+	u64 virtual_chapter_low;
+	u64 virtual_chapter_high;
+	u64 early_flushes;
+} __aligned(L1_CACHE_BYTES);
+
+struct volume_sub_index {
+	/* The delta index */
+	struct delta_index delta_index;
+	/* The first chapter to be flushed in each zone */
+	u64 *flush_chapters;
+	/* The zones */
+	struct volume_sub_index_zone *zones;
+	/* The volume nonce */
+	u64 volume_nonce;
+	/* Expected size of a chapter (per zone) */
+	u64 chapter_zone_bits;
+	/* Maximum size of the index (per zone) */
+	u64 max_zone_bits;
+	/* The number of bits in address mask */
+	u8 address_bits;
+	/* Mask to get address within delta list */
+	u32 address_mask;
+	/* The number of bits in chapter number */
+	u8 chapter_bits;
+	/* The largest storable chapter number */
+	u32 chapter_mask;
+	/* The number of chapters used */
+	u32 chapter_count;
+	/* The number of delta lists */
+	u32 list_count;
+	/* The number of zones */
+	unsigned int zone_count;
+	/* The amount of memory allocated */
+	u64 memory_size;
+};
+
+struct volume_index_zone {
+	/* Protects the sampled index in this zone */
+	struct mutex hook_mutex;
+} __aligned(L1_CACHE_BYTES);
+
+struct volume_index {
+	u32 sparse_sample_rate;
+	unsigned int zone_count;
+	u64 memory_size;
+	struct volume_sub_index vi_non_hook;
+	struct volume_sub_index vi_hook;
+	struct volume_index_zone *zones;
+};
+
+/*
+ * The volume_index_record structure is used to facilitate processing of a record name. A client
+ * first calls uds_get_volume_index_record() to find the volume index record for a record name. The
+ * fields of the record can then be examined to determine the state of the record.
+ *
+ * If is_found is false, then the index did not find an entry for the record name. Calling
+ * uds_put_volume_index_record() will insert a new entry for that name at the proper place.
+ *
+ * If is_found is true, then we did find an entry for the record name, and the virtual_chapter and
+ * is_collision fields reflect the entry found. Subsequently, a call to
+ * uds_remove_volume_index_record() will remove the entry, a call to
+ * uds_set_volume_index_record_chapter() will update the existing entry, and a call to
+ * uds_put_volume_index_record() will insert a new collision record after the existing entry.
+ */
+struct volume_index_record {
+	/* Public fields */
+
+	/* Chapter where the record info is found */
+	u64 virtual_chapter;
+	/* This record is a collision */
+	bool is_collision;
+	/* This record is the requested record */
+	bool is_found;
+
+	/* Private fields */
+
+	/* Zone that contains this name */
+	unsigned int zone_number;
+	/* The volume index */
+	struct volume_sub_index *sub_index;
+	/* Mutex for accessing this delta index entry in the hook index */
+	struct mutex *mutex;
+	/* The record name to which this record refers */
+	const struct uds_record_name *name;
+	/* The delta index entry for this record */
+	struct delta_index_entry delta_entry;
+};
+
+int __must_check uds_make_volume_index(const struct configuration *config,
+				       u64 volume_nonce,
+				       struct volume_index **volume_index);
+
+void uds_free_volume_index(struct volume_index *volume_index);
+
+int __must_check uds_compute_volume_index_save_blocks(const struct configuration *config,
+						      size_t block_size,
+						      u64 *block_count);
+
+unsigned int __must_check
+uds_get_volume_index_zone(const struct volume_index *volume_index,
+			  const struct uds_record_name *name);
+
+bool __must_check uds_is_volume_index_sample(const struct volume_index *volume_index,
+					     const struct uds_record_name *name);
+
+/*
+ * This function is only used to manage sparse cache membership. Most requests should use
+ * uds_get_volume_index_record() to look up index records instead.
+ */
+u64 __must_check uds_lookup_volume_index_name(const struct volume_index *volume_index,
+					      const struct uds_record_name *name);
+
+int __must_check uds_get_volume_index_record(struct volume_index *volume_index,
+					     const struct uds_record_name *name,
+					     struct volume_index_record *record);
+
+int __must_check
+uds_put_volume_index_record(struct volume_index_record *record, u64 virtual_chapter);
+
+int __must_check uds_remove_volume_index_record(struct volume_index_record *record);
+
+int __must_check
+uds_set_volume_index_record_chapter(struct volume_index_record *record, u64 virtual_chapter);
+
+void uds_set_volume_index_open_chapter(struct volume_index *volume_index, u64 virtual_chapter);
+
+void uds_set_volume_index_zone_open_chapter(struct volume_index *volume_index,
+					    unsigned int zone_number,
+					    u64 virtual_chapter);
+
+int __must_check uds_load_volume_index(struct volume_index *volume_index,
+				       struct buffered_reader **readers,
+				       unsigned int reader_count);
+
+int __must_check uds_save_volume_index(struct volume_index *volume_index,
+				       struct buffered_writer **writers,
+				       unsigned int writer_count);
+
+void uds_get_volume_index_stats(const struct volume_index *volume_index,
+				struct volume_index_stats *stats);
+
+#endif /* UDS_VOLUME_INDEX_H */
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
new file mode 100644
index 00000000000..bc6917b6e14
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
+	 * preceeds the lowest one.
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
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

