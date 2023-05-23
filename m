Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A599EC7EE26
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 21:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684878490;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JLPMFfJp+QJ4LK1un3CcU+znQfLKB4iGlUWO7zbVH94=;
	b=PlEOXHv/LbNQDsk+pmRlGSJgUXMOQ2mby88B/eLcXB2hP4YVFB66yTVnblYGE/o9YAOIs8
	W91binasUOKObMVW59x/yRY4tlh2iGdQWOD9i49rFfzbb5J8LoLZ/UjFlNbw/AWAgS9QiX
	OMt+psPcUbjuAJg54NwRTcShmor5HzQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-Xpbz_7mXOGOw2BarSSbbYA-1; Tue, 23 May 2023 17:46:17 -0400
X-MC-Unique: Xpbz_7mXOGOw2BarSSbbYA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06CFC8039B3;
	Tue, 23 May 2023 21:46:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E6AB7140E962;
	Tue, 23 May 2023 21:46:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D14C619465B3;
	Tue, 23 May 2023 21:46:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5139819465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 21:46:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 334D8482060; Tue, 23 May 2023 21:46:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B027401024
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:46:12 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04E0E3828883
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:46:12 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-Nxv4i2sWMnauMSn2I_DKkw-1; Tue, 23 May 2023 17:46:10 -0400
X-MC-Unique: Nxv4i2sWMnauMSn2I_DKkw-1
Received: by mail-qk1-f199.google.com with SMTP id
 af79cd13be357-75b08091369so56517985a.3
 for <dm-devel@redhat.com>; Tue, 23 May 2023 14:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684878370; x=1687470370;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=qT+mYRPE1L0YFBCmLLFeTAqDDWWhgxTKKZmh1R8ZPbI=;
 b=L9/CYIxcnbqRBZZOCcKd1JvEkIJGu6isrZXbdfLgn1gtQxFNkYSHbp1Hmy4U6t5Txo
 Xflh1zNLvmrbKzzDsqp/0Mnf1cB6TEzZ2slS+aKxgs/TNtDVqub6RBCNpWQjiQN3GDQF
 OYRXWlyvlgf5N4BrYKRcsO5DDiEl4PsL9TY0W5oZxuEPnsMq9UdBD39bSkOJOQv6aJEQ
 u5E0Fpdf+fkwhXa2KtlvdBpEkIsYhOMEKqqQrZQxOsjid23M9Hwc6yTwmbpJ3X91OLlY
 +uYicISGkuGdWOuhtJ4LWee/ogwqlt9MLzcIqB3eeke5j5MaC3et/ApqQfr88oswK9Dc
 UrDw==
X-Gm-Message-State: AC+VfDw9+JPRdQQWq/UoMIyw8utmfnOwLdT1FlNcK+hABJi4Tckc2zXO
 01457x4vSkAH1tzr5aylzj+uYQN0xp2gHMExYp2/fP3+OZVa5trD7SM0bDnaWcocQkTKvlReRsB
 y7TymKP2GPhRpW1g6F0gytC5Voqz1kilNYf02tFZ9A9/AnQKThW7rjmlteNgJpWluyqNFbkKC
X-Received: by 2002:a37:64cd:0:b0:75b:23a0:dea7 with SMTP id
 y196-20020a3764cd000000b0075b23a0dea7mr5447627qkb.37.1684878369672; 
 Tue, 23 May 2023 14:46:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ62HUwXEB/d3StGj4JjEghukUJyfUQbZZxcOoNLuI56aY+XZLWTyMJri8wSftYdvX70fV29jQ==
X-Received: by 2002:a37:64cd:0:b0:75b:23a0:dea7 with SMTP id
 y196-20020a3764cd000000b0075b23a0dea7mr5447595qkb.37.1684878368961; 
 Tue, 23 May 2023 14:46:08 -0700 (PDT)
Received: from bf36-1.. (173-166-2-198-newengland.hfc.comcastbusiness.net.
 [173.166.2.198]) by smtp.gmail.com with ESMTPSA id
 x3-20020ae9e903000000b007592af6fce6sm2234465qkf.43.2023.05.23.14.46.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 14:46:08 -0700 (PDT)
From: "J. corwin Coburn" <corwin@redhat.com>
To: dm-devel@redhat.com,
	linux-block@vger.kernel.org
Date: Tue, 23 May 2023 17:45:13 -0400
Message-Id: <20230523214539.226387-14-corwin@redhat.com>
In-Reply-To: <20230523214539.226387-1-corwin@redhat.com>
References: <20230523214539.226387-1-corwin@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 13/39] Implement the open chapter and chapter
 indexes.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Deduplication records are stored in groups called chapters. New records are
collected in a structure called the open chapter, which is optimized for
adding, removing, and sorting records.

When a chapter fills, it is packed into a read-only structure called a
closed chapter, which is optimized for searching and reading. The closed
chapter includes a delta index, called the chapter index, which maps each
record name to the record page containing the record and allows the index
to read at most one record page when looking up a record.

Signed-off-by: J. corwin Coburn <corwin@redhat.com>
---
 drivers/md/dm-vdo/chapter-index.c | 304 +++++++++++++++++++++
 drivers/md/dm-vdo/chapter-index.h |  66 +++++
 drivers/md/dm-vdo/open-chapter.c  | 433 ++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/open-chapter.h  |  79 ++++++
 4 files changed, 882 insertions(+)
 create mode 100644 drivers/md/dm-vdo/chapter-index.c
 create mode 100644 drivers/md/dm-vdo/chapter-index.h
 create mode 100644 drivers/md/dm-vdo/open-chapter.c
 create mode 100644 drivers/md/dm-vdo/open-chapter.h

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
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

