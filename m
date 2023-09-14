Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B502FEEAA69
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dVmJyMWth6wHK+7Ny/0stJbNeopIhb5F1uI0FkegcU8=;
	b=hNPQUpQO2/Jja2eLWwdFoGO3zI0QCfgJOV9b+xM8RkRGgzRMUin4N2skezxFUc8Fu8yTXG
	LYiJCwdZ3CIXiq4OCl82tCiwDtjZ1IZM6ynRSSCyU3GpOwVavUG9wuGbKOs7ZqHcQCacHl
	uY+3rfvtoUzjBrvKekohNvNpoiRY1Lk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-gnskmyK2PVCu48ri83xv2A-1; Thu, 14 Sep 2023 15:18:09 -0400
X-MC-Unique: gnskmyK2PVCu48ri83xv2A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36AB981B08C;
	Thu, 14 Sep 2023 19:18:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2164B40C2070;
	Thu, 14 Sep 2023 19:18:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5AEFA19452E2;
	Thu, 14 Sep 2023 19:17:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 48DC519465BA
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:17:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 368042026D76; Thu, 14 Sep 2023 19:17:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E7122026D68
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:13 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 072F7101FAA5
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:13 +0000 (UTC)
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com
 [209.85.221.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-fYEa49F1OYGEP4ZckBOA6w-1; Thu, 14 Sep 2023 15:17:11 -0400
X-MC-Unique: fYEa49F1OYGEP4ZckBOA6w-1
Received: by mail-vk1-f177.google.com with SMTP id
 71dfb90a1353d-495bcd861ccso603583e0c.3
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719030; x=1695323830;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=QqeUGc+0uOnpFgfJT7RbXSYXsK/fIXtCabInz5AW2lg=;
 b=ASgdkERMEPgPwJ9CEf02W4KnyBoeaHfY6quiLDbdDjeRkPgYPmubsWWMhcqoeLzHEe
 ULrKVx1V4kpG0hqsGs/ufR1RWmy9QMp2xE5cPNrMhPCinqwV/PgakodplNjWNAIJZxiD
 r3WRASspO20uAb7Nhm70y4X9N7CWEbkudvOVjxPkZYsPjADKUizvFaIbYdQ6j2u6vQao
 DbCQa95u6nc8nGhuyy7Q9OVv6nD/CzepSA/WXHs+UuTumSwkTUy7xYFgZdgyzkn0qmC1
 BuSBq/ZpxtQsnTWHbiE8WaB0wA1J4YRP+TPx+uTtFZcMiC4DysFtAKsy94RE2SbZ7tnj
 IDrA==
X-Gm-Message-State: AOJu0YzgwRkrLeHxIWUSqjqda/OSQwEBbETmYPoCz2LkIgmoGDN30OcD
 gmcw+DysrOKm80JY4jyuP4pnMVT1u/fa5F+pAzRCoZQOpQSxG0SXeAb4Y2JtqLUQtrz/SnzurT5
 qA64v9+sdYGHlh24YHUacUn0gN9VRr3nOjc9HbNleH0UrW8aMH+d9LFtl33v03jWv55FLmikK
X-Google-Smtp-Source: AGHT+IFKQgMq2J93RE4JFiFKYckaHGavL6A81iOpVYS4JtLHDXcS1a6bVxsYtTixx/wOyb9cg8PK1w==
X-Received: by 2002:a1f:4807:0:b0:48f:f57e:6e3f with SMTP id
 v7-20020a1f4807000000b0048ff57e6e3fmr6273813vka.12.1694719029538; 
 Thu, 14 Sep 2023 12:17:09 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 n21-20020ac86755000000b004035843ec96sm639343qtp.89.2023.09.14.12.17.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:17:08 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:16:12 -0400
Message-Id: <20230914191635.39805-17-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v3 16/39] dm vdo: implement external
 deduplication index interface
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Matthew Sakai <msakai@redhat.com>

The deduplication index interface for index clients includes the
deduplication request and index session structures. This is the
interface that the rest of the vdo target uses to make requests,
receive responses, and collect statistics.

Also adds sysfs nodes for inspecting various index properties at
runtime.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: Michael Sclafani <vdo-devel@redhat.com>
Signed-off-by: Michael Sclafani <vdo-devel@redhat.com>
Co-developed-by: Thomas Jaskiewicz <tom@jaskiewicz.us>
Signed-off-by: Thomas Jaskiewicz <tom@jaskiewicz.us>
Co-developed-by: John Wiele <jwiele@redhat.com>
Signed-off-by: John Wiele <jwiele@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-vdo/index-session.c | 815 ++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/index-session.h |  84 +++
 drivers/md/dm-vdo/uds-sysfs.c     | 185 +++++++
 drivers/md/dm-vdo/uds-sysfs.h     |  12 +
 drivers/md/dm-vdo/uds.h           | 334 ++++++++++++
 5 files changed, 1430 insertions(+)
 create mode 100644 drivers/md/dm-vdo/index-session.c
 create mode 100644 drivers/md/dm-vdo/index-session.h
 create mode 100644 drivers/md/dm-vdo/uds-sysfs.c
 create mode 100644 drivers/md/dm-vdo/uds-sysfs.h
 create mode 100644 drivers/md/dm-vdo/uds.h

diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/index-session.c
new file mode 100644
index 000000000000..333de13d1599
--- /dev/null
+++ b/drivers/md/dm-vdo/index-session.c
@@ -0,0 +1,815 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
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
index 000000000000..c77ee021d510
--- /dev/null
+++ b/drivers/md/dm-vdo/index-session.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
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
diff --git a/drivers/md/dm-vdo/uds-sysfs.c b/drivers/md/dm-vdo/uds-sysfs.c
new file mode 100644
index 000000000000..8700a028a11c
--- /dev/null
+++ b/drivers/md/dm-vdo/uds-sysfs.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
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
+static const struct kobj_type empty_object_type = {
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
+static const struct kobj_type parameter_object_type = {
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
index 000000000000..c3d00a7187bd
--- /dev/null
+++ b/drivers/md/dm-vdo/uds-sysfs.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#ifndef UDS_SYSFS_H
+#define UDS_SYSFS_H
+
+int uds_init_sysfs(void);
+void uds_put_sysfs(void);
+
+#endif  /* UDS_SYSFS_H */
diff --git a/drivers/md/dm-vdo/uds.h b/drivers/md/dm-vdo/uds.h
new file mode 100644
index 000000000000..71580c4098ce
--- /dev/null
+++ b/drivers/md/dm-vdo/uds.h
@@ -0,0 +1,334 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
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
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

