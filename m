Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 980AAC7EE2E
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 21:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684878559;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+7voFe+9X3wqDDsu4OMKeYmKfDhQSjvsjlsjSFeMKZY=;
	b=dR2lF0HHoua+pCPyFyh0jlDsYjDfI2f6u8GibuvOkMDXTE6EGEoxEQhl/J3iFWfm0cFRkM
	v3mJLqJUTcntgdcQUkn2fl+22HiOLqdlO6f5Z8R+OcwAx5VDU+UlkWdRkwCNEHtLWEK/IB
	1hS9ZepEirez7NNuxWsvVKTkiyMPlvA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-nnu8LJYsOk2rDm0zeJQh_g-1; Tue, 23 May 2023 17:46:19 -0400
X-MC-Unique: nnu8LJYsOk2rDm0zeJQh_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 807C985A5BA;
	Tue, 23 May 2023 21:46:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 67FE140CFD47;
	Tue, 23 May 2023 21:46:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3790319465B9;
	Tue, 23 May 2023 21:46:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1EC9319465B7
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 21:46:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0014C1121315; Tue, 23 May 2023 21:46:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB8CC1121314
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:46:15 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C11913828886
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:46:15 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-PSq7bMwTOxOu9VztzlSkKw-1; Tue, 23 May 2023 17:46:14 -0400
X-MC-Unique: PSq7bMwTOxOu9VztzlSkKw-1
Received: by mail-qk1-f197.google.com with SMTP id
 af79cd13be357-75b07b420a5so59404585a.3
 for <dm-devel@redhat.com>; Tue, 23 May 2023 14:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684878374; x=1687470374;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=D0vmuzRoMzE2NGqd4llx2/H/Zo9s5C7yYyJ92B+xiRo=;
 b=CfC44y2RO8eBPfuc7msOjFB3KK5fXxO9m41Ky9YYql8440cmNbfe3uUYIvC05Vz6hU
 5Yc+Zto42LSYCZzPKogmehiRplouYsaXH8LEbaAyNZCYiiICcZcsfpKY11vZrNGFshxJ
 ivsgonkQJVLGTfZQopsibSuhilhJ6vm0eMfDzLx0zMWmOiPq9eO0tkqbWU9/2wlOTHzK
 U5wTKUWYHysyc4lULIRzS2jq5L8wM2lXCLrrnMt11N4HruuENQEDGn/QRHW4KurWOWfv
 4gr0job4fGqngxGTjrW03Z0yWic+Ps0d9wAUE9eJUrs9yaNBhsv6iYWz8M7iAGLcby8K
 bkvQ==
X-Gm-Message-State: AC+VfDzBtBOyQTxm/EZhiZ64O88U8xHmndgOuWD9YODuTjY6RuHIYTLG
 oNOcINIvQfdo0qLqJbQA+mP/GT11FmCRHTUV02Cz1tSRdPPTW0oinGoehN5QiRp+xXYFcW5l44f
 FesmzqfoeJe7C3Zs93u9BYL1upIAy7pDIIX8nGkjDs4tXxAfzVWmA41N86RX/cAQywiNASRVF
X-Received: by 2002:a05:620a:8193:b0:75b:23a1:3637 with SMTP id
 ot19-20020a05620a819300b0075b23a13637mr5093135qkn.72.1684878372750; 
 Tue, 23 May 2023 14:46:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ63PIcPp3bOz2kb4uH3cCywnCVdtTMeYd6H0d+QtgnrPk7lOAH8fiXbYY6ugWQSVUxPGs7LwQ==
X-Received: by 2002:a05:620a:8193:b0:75b:23a1:3637 with SMTP id
 ot19-20020a05620a819300b0075b23a13637mr5093071qkn.72.1684878371309; 
 Tue, 23 May 2023 14:46:11 -0700 (PDT)
Received: from bf36-1.. (173-166-2-198-newengland.hfc.comcastbusiness.net.
 [173.166.2.198]) by smtp.gmail.com with ESMTPSA id
 x3-20020ae9e903000000b007592af6fce6sm2234465qkf.43.2023.05.23.14.46.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 14:46:10 -0700 (PDT)
From: "J. corwin Coburn" <corwin@redhat.com>
To: dm-devel@redhat.com,
	linux-block@vger.kernel.org
Date: Tue, 23 May 2023 17:45:15 -0400
Message-Id: <20230523214539.226387-16-corwin@redhat.com>
In-Reply-To: <20230523214539.226387-1-corwin@redhat.com>
References: <20230523214539.226387-1-corwin@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH v2 15/39] Implement top-level deduplication index.
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

The top-level deduplication index brings all the earlier components
together. The top-level index creates the separate zone structures that
enable the index to handle several requests in parallel, handles
dispatching requests to the right zones and components, and coordinates
metadata to ensure that it remain consistent. It also coordinates recovery
in the event of an unexpected index failure.

If sparse caching is enabled, the top-level index also handles the
coordination required by the sparse chapter index cache, which (unlike most
index structures) is shared among all zones.

Signed-off-by: J. corwin Coburn <corwin@redhat.com>
---
 drivers/md/dm-vdo/index.c        | 1403 ++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/index.h        |   83 ++
 drivers/md/dm-vdo/sparse-cache.c |  595 +++++++++++++
 drivers/md/dm-vdo/sparse-cache.h |   49 ++
 4 files changed, 2130 insertions(+)
 create mode 100644 drivers/md/dm-vdo/index.c
 create mode 100644 drivers/md/dm-vdo/index.h
 create mode 100644 drivers/md/dm-vdo/sparse-cache.c
 create mode 100644 drivers/md/dm-vdo/sparse-cache.h

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
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

