Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A40EAC7EE26
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 21:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684878365;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K/WXuJBV9PpOn0tj3MiC+2GqDeIudqRVpWvMSEYyOPY=;
	b=D0vu7IIa85910Hh8c3JSriFJBcERUBj2bppAr8U5ckT7j4KQnDEkAg4hCykdV7aluOlb+f
	KenkKEI/0w5SYqFs6GuoJLTqp/YWUeaersDc+kGbdfWqCUbOUKMyXu/2mLK1bl38nCO/qP
	VeQa1I1zhsdLX1KxHL1nkAUvWrFaPME=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-8_I97BDoNfagm1VAMddDNw-1; Tue, 23 May 2023 17:46:02 -0400
X-MC-Unique: 8_I97BDoNfagm1VAMddDNw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14C7D1019C86;
	Tue, 23 May 2023 21:46:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF195482060;
	Tue, 23 May 2023 21:45:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B976F19465BC;
	Tue, 23 May 2023 21:45:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7351819465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 21:45:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 506D3401024; Tue, 23 May 2023 21:45:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 477EC40140A
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:45:58 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FE7D101A53B
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:45:58 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-0fHBAhv7PS2wWHR2MvxMaQ-1; Tue, 23 May 2023 17:45:56 -0400
X-MC-Unique: 0fHBAhv7PS2wWHR2MvxMaQ-1
Received: by mail-qk1-f198.google.com with SMTP id
 af79cd13be357-75b0c2ee430so32161885a.1
 for <dm-devel@redhat.com>; Tue, 23 May 2023 14:45:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684878356; x=1687470356;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=CzbR298CfdSKUVwKeQL0xNe8nvopcbSbimpumNPumDU=;
 b=XN8wgKnMTTmNbd2q00aaaeEoYBGzOpIYxN2azQtg5ArtIazwhCzCshQjkawURKjN3e
 TX6DMvRuA/HKT0h/g0gtgceYIIidvlEH3E1kV/xcReDIjbKSs6PUlgr2ipiWFk5SMQVr
 layj6cL308Qyt0jaNauv8uhIFLpTPvhh6kGcSGp2FWhTioZXCA7687nEbKXRzE7o/gVQ
 r6llZXdYAlXYLsGxjLOnnou1XVlM/SQB0i+eIiTXsR3wjDmcxPQfP2vRapXh/Q6W8Qhx
 KffSQjZIagTMyzDTPSUgqD13EYRf+R2Z+qwGQMgnhTzhIXJg9numNm293sBqXBjHDcyj
 J5iw==
X-Gm-Message-State: AC+VfDwKOMRms+nOtPgZFJ2vGVZV6MjU7FS+/smFWguRHfHt7WD1M/ro
 DaFmjZmpDAoUKFFVjVsDuTbIvAz+c5ojrzL74d/L9N2Ulx4cuK9M/oHME28U899nVjZc7athtU4
 qxvYssMVfalY3mVBw4N+19D1E/zatobRNsrVXoPyaRQP9x+DdGgtNThzUedbT/I/cAqK40aAJ
X-Received: by 2002:a37:e117:0:b0:75b:23a1:3f7 with SMTP id
 c23-20020a37e117000000b0075b23a103f7mr5456005qkm.13.1684878355012; 
 Tue, 23 May 2023 14:45:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7QPY8xr/38+lg4SOoWNoNxzaC0xUqOLeMkXxzZMK9mM5dqfd4OOP56ZbrxN6T6fDI2dOjQ/A==
X-Received: by 2002:a37:e117:0:b0:75b:23a1:3f7 with SMTP id
 c23-20020a37e117000000b0075b23a103f7mr5455952qkm.13.1684878353547; 
 Tue, 23 May 2023 14:45:53 -0700 (PDT)
Received: from bf36-1.. (173-166-2-198-newengland.hfc.comcastbusiness.net.
 [173.166.2.198]) by smtp.gmail.com with ESMTPSA id
 s24-20020ae9f718000000b0074fafbea974sm2821592qkg.2.2023.05.23.14.45.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 14:45:52 -0700 (PDT)
From: "J. corwin Coburn" <corwin@redhat.com>
To: dm-devel@redhat.com,
	linux-block@vger.kernel.org
Date: Tue, 23 May 2023 17:45:07 -0400
Message-Id: <20230523214539.226387-8-corwin@redhat.com>
In-Reply-To: <20230523214539.226387-1-corwin@redhat.com>
References: <20230523214539.226387-1-corwin@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 07/39] Add specialized request queueing
 functionality.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch adds funnel_queue, a mostly lock-free multi-producer,
single-consumer queue. It also adds the request queue used by the dm-vdo
deduplication index, and the work_queue used by the dm-vdo data store. Both
of these are built on top of funnel queue and are intended to support the
dispatching of many short-running tasks. The work_queue also supports
priorities. Finally, this patch adds vdo_completion, the structure which is
enqueued on work_queues.

Signed-off-by: J. corwin Coburn <corwin@redhat.com>
---
 drivers/md/dm-vdo/completion.c    | 141 +++++++
 drivers/md/dm-vdo/completion.h    | 155 +++++++
 drivers/md/dm-vdo/cpu.h           |  58 +++
 drivers/md/dm-vdo/funnel-queue.c  | 169 ++++++++
 drivers/md/dm-vdo/funnel-queue.h  | 110 +++++
 drivers/md/dm-vdo/request-queue.c | 284 +++++++++++++
 drivers/md/dm-vdo/request-queue.h |  30 ++
 drivers/md/dm-vdo/work-queue.c    | 659 ++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/work-queue.h    |  53 +++
 9 files changed, 1659 insertions(+)
 create mode 100644 drivers/md/dm-vdo/completion.c
 create mode 100644 drivers/md/dm-vdo/completion.h
 create mode 100644 drivers/md/dm-vdo/cpu.h
 create mode 100644 drivers/md/dm-vdo/funnel-queue.c
 create mode 100644 drivers/md/dm-vdo/funnel-queue.h
 create mode 100644 drivers/md/dm-vdo/request-queue.c
 create mode 100644 drivers/md/dm-vdo/request-queue.h
 create mode 100644 drivers/md/dm-vdo/work-queue.c
 create mode 100644 drivers/md/dm-vdo/work-queue.h

diff --git a/drivers/md/dm-vdo/completion.c b/drivers/md/dm-vdo/completion.c
new file mode 100644
index 00000000000..8feb9c05c19
--- /dev/null
+++ b/drivers/md/dm-vdo/completion.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "completion.h"
+
+#include <linux/kernel.h>
+
+#include "logger.h"
+#include "permassert.h"
+
+#include "status-codes.h"
+#include "types.h"
+#include "vio.h"
+#include "vdo.h"
+
+/**
+ * DOC: vdo completions.
+ *
+ * Most of vdo's data structures are lock free, each either belonging to a single "zone," or
+ * divided into a number of zones whose accesses to the structure do not overlap. During normal
+ * operation, at most one thread will be operating in any given zone. Each zone has a
+ * vdo_work_queue which holds vdo_completions that are to be run in that zone. A completion may
+ * only be enqueued on one queue or operating in a single zone at a time.
+ *
+ * At each step of a multi-threaded operation, the completion performing the operation is given a
+ * callback, error handler, and thread id for the next step. A completion is "run" when it is
+ * operating on the correct thread (as specified by its callback_thread_id). If the value of its
+ * "result" field is an error (i.e. not VDO_SUCCESS), the function in its "error_handler" will be
+ * invoked. If the error_handler is NULL, or there is no error, the function set as its "callback"
+ * will be invoked. Generally, a completion will not be run directly, but rather will be
+ * "launched." In this case, it will check whether it is operating on the correct thread. If it is,
+ * it will run immediately. Otherwise, it will be enqueue on the vdo_work_queue associated with the
+ * completion's "callback_thread_id". When it is dequeued, it will be on the correct thread, and
+ * will get run. In some cases, the completion should get queued instead of running immediately,
+ * even if it is being launched from the correct thread. This is usually in cases where there is a
+ * long chain of callbacks, all on the same thread, which could overflow the stack. In such cases,
+ * the completion's "requeue" field should be set to true. Doing so will skip the current thread
+ * check and simply enqueue the completion.
+ *
+ * A completion may be "finished," in which case its "complete" field will be set to true before it
+ * is next run. It is a bug to attempt to set the result or re-finish a finished completion.
+ * Because a completion's fields are not safe to examine from any thread other than the one on
+ * which the completion is currently operating, this field is used only to aid in detecting
+ * programming errors. It can not be used for cross-thread checking on the status of an operation.
+ * A completion must be "reset" before it can be reused after it has been finished. Resetting will
+ * also clear any error from the result field.
+ **/
+
+void vdo_initialize_completion(struct vdo_completion *completion,
+			       struct vdo *vdo,
+			       enum vdo_completion_type type)
+{
+	memset(completion, 0, sizeof(*completion));
+	completion->vdo = vdo;
+	completion->type = type;
+	vdo_reset_completion(completion);
+}
+
+static inline void assert_incomplete(struct vdo_completion *completion)
+{
+	ASSERT_LOG_ONLY(!completion->complete, "completion is not complete");
+}
+
+/**
+ * vdo_set_completion_result() - Set the result of a completion.
+ *
+ * Older errors will not be masked.
+ */
+void vdo_set_completion_result(struct vdo_completion *completion, int result)
+{
+	assert_incomplete(completion);
+	if (completion->result == VDO_SUCCESS)
+		completion->result = result;
+}
+
+/**
+ * vdo_launch_completion_with_priority() - Run or enqueue a completion.
+ * @priority: The priority at which to enqueue the completion.
+ *
+ * If called on the correct thread (i.e. the one specified in the completion's callback_thread_id
+ * field) and not marked for requeue, the completion will be run immediately. Otherwise, the
+ * completion will be enqueued on the specified thread.
+ */
+void vdo_launch_completion_with_priority(struct vdo_completion *completion,
+					 enum vdo_completion_priority priority)
+{
+	thread_id_t callback_thread = completion->callback_thread_id;
+
+	if (completion->requeue || (callback_thread != vdo_get_callback_thread_id())) {
+		vdo_enqueue_completion(completion, priority);
+		return;
+	}
+
+	vdo_run_completion(completion);
+}
+
+/** vdo_finish_completion() - Mark a completion as complete and then launch it. */
+void vdo_finish_completion(struct vdo_completion *completion)
+{
+	assert_incomplete(completion);
+	completion->complete = true;
+	if (completion->callback != NULL)
+		vdo_launch_completion(completion);
+}
+
+void vdo_enqueue_completion(struct vdo_completion *completion,
+			    enum vdo_completion_priority priority)
+{
+	struct vdo *vdo = completion->vdo;
+	thread_id_t thread_id = completion->callback_thread_id;
+
+	if (ASSERT(thread_id < vdo->thread_config.thread_count,
+		   "thread_id %u (completion type %d) is less than thread count %u",
+		   thread_id,
+		   completion->type,
+		   vdo->thread_config.thread_count) != UDS_SUCCESS)
+		BUG();
+
+	completion->requeue = false;
+	completion->priority = priority;
+	completion->my_queue = NULL;
+	vdo_enqueue_work_queue(vdo->threads[thread_id].queue, completion);
+}
+
+/**
+ * vdo_requeue_completion_if_needed() - Requeue a completion if not called on the specified thread.
+ *
+ * Return: True if the completion was requeued; callers may not access the completion in this case.
+ */
+bool vdo_requeue_completion_if_needed(struct vdo_completion *completion,
+				      thread_id_t callback_thread_id)
+{
+	if (vdo_get_callback_thread_id() == callback_thread_id)
+		return false;
+
+	completion->callback_thread_id = callback_thread_id;
+	vdo_enqueue_completion(completion, VDO_WORK_Q_DEFAULT_PRIORITY);
+	return true;
+}
diff --git a/drivers/md/dm-vdo/completion.h b/drivers/md/dm-vdo/completion.h
new file mode 100644
index 00000000000..03b2daa6546
--- /dev/null
+++ b/drivers/md/dm-vdo/completion.h
@@ -0,0 +1,155 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef VDO_COMPLETION_H
+#define VDO_COMPLETION_H
+
+#include "permassert.h"
+
+#include "status-codes.h"
+#include "types.h"
+
+/**
+ * vdo_run_completion() - Run a completion's callback or error handler on the current thread.
+ *
+ * Context: This function must be called from the correct callback thread.
+ */
+static inline void vdo_run_completion(struct vdo_completion *completion)
+{
+	if ((completion->result != VDO_SUCCESS) && (completion->error_handler != NULL)) {
+		completion->error_handler(completion);
+		return;
+	}
+
+	completion->callback(completion);
+}
+
+void vdo_set_completion_result(struct vdo_completion *completion, int result);
+
+void vdo_initialize_completion(struct vdo_completion *completion,
+			       struct vdo *vdo,
+			       enum vdo_completion_type type);
+
+/**
+ * vdo_reset_completion() - Reset a completion to a clean state, while keeping the type, vdo and
+ *                          parent information.
+ */
+static inline void vdo_reset_completion(struct vdo_completion *completion)
+{
+	completion->result = VDO_SUCCESS;
+	completion->complete = false;
+}
+
+void vdo_launch_completion_with_priority(struct vdo_completion *completion,
+					 enum vdo_completion_priority priority);
+
+/**
+ * vdo_launch_completion() - Launch a completion with default priority.
+ */
+static inline void vdo_launch_completion(struct vdo_completion *completion)
+{
+	vdo_launch_completion_with_priority(completion, VDO_WORK_Q_DEFAULT_PRIORITY);
+}
+
+/**
+ * vdo_continue_completion() - Continue processing a completion.
+ * @result: The current result (will not mask older errors).
+ *
+ * Continue processing a completion by setting the current result and calling
+ * vdo_launch_completion().
+ */
+static inline void vdo_continue_completion(struct vdo_completion *completion, int result)
+{
+	vdo_set_completion_result(completion, result);
+	vdo_launch_completion(completion);
+}
+
+void vdo_finish_completion(struct vdo_completion *completion);
+
+/**
+ * vdo_fail_completion() - Set the result of a completion if it does not already have an error,
+ *                         then finish it.
+ */
+static inline void vdo_fail_completion(struct vdo_completion *completion, int result)
+{
+	vdo_set_completion_result(completion, result);
+	vdo_finish_completion(completion);
+}
+
+/**
+ * vdo_assert_completion_type() - Assert that a completion is of the correct type.
+ *
+ * Return: VDO_SUCCESS or an error
+ */
+static inline int
+vdo_assert_completion_type(struct vdo_completion *completion, enum vdo_completion_type expected)
+{
+	return ASSERT(expected == completion->type,
+		      "completion type should be %u, not %u",
+		      expected,
+		      completion->type);
+}
+
+static inline void vdo_set_completion_callback(struct vdo_completion *completion,
+					       vdo_action *callback,
+					       thread_id_t callback_thread_id)
+{
+	completion->callback = callback;
+	completion->callback_thread_id = callback_thread_id;
+}
+
+/**
+ * vdo_launch_completion_callback() - Set the callback for a completion and launch it immediately.
+ */
+static inline void vdo_launch_completion_callback(struct vdo_completion *completion,
+						  vdo_action *callback,
+						  thread_id_t callback_thread_id)
+{
+	vdo_set_completion_callback(completion, callback, callback_thread_id);
+	vdo_launch_completion(completion);
+}
+
+/**
+ * vdo_prepare_completion() - Prepare a completion for launch.
+ *
+ * Resets the completion, and then sets its callback, error handler, callback thread, and parent.
+ */
+static inline void vdo_prepare_completion(struct vdo_completion *completion,
+					  vdo_action *callback,
+					  vdo_action *error_handler,
+					  thread_id_t callback_thread_id,
+					  void *parent)
+{
+	vdo_reset_completion(completion);
+	vdo_set_completion_callback(completion, callback, callback_thread_id);
+	completion->error_handler = error_handler;
+	completion->parent = parent;
+}
+
+/**
+ * vdo_prepare_completion_for_requeue() - Prepare a completion for launch ensuring that it will
+ *                                        always be requeued.
+ *
+ * Resets the completion, and then sets its callback, error handler, callback thread, and parent.
+ */
+static inline void
+vdo_prepare_completion_for_requeue(struct vdo_completion *completion,
+				   vdo_action *callback,
+				   vdo_action *error_handler,
+				   thread_id_t callback_thread_id,
+				   void *parent)
+{
+	vdo_prepare_completion(completion, callback, error_handler, callback_thread_id, parent);
+	completion->requeue = true;
+}
+
+void vdo_enqueue_completion(struct vdo_completion *completion,
+			    enum vdo_completion_priority priority);
+
+
+bool vdo_requeue_completion_if_needed(struct vdo_completion *completion,
+				      thread_id_t callback_thread_id);
+
+#endif /* VDO_COMPLETION_H */
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
diff --git a/drivers/md/dm-vdo/work-queue.c b/drivers/md/dm-vdo/work-queue.c
new file mode 100644
index 00000000000..ecb0c345d4f
--- /dev/null
+++ b/drivers/md/dm-vdo/work-queue.c
@@ -0,0 +1,659 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "work-queue.h"
+
+#include <linux/atomic.h>
+#include <linux/cache.h>
+#include <linux/completion.h>
+#include <linux/err.h>
+#include <linux/kthread.h>
+#include <linux/percpu.h>
+
+#include "funnel-queue.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "numeric.h"
+#include "permassert.h"
+#include "string-utils.h"
+
+#include "completion.h"
+#include "status-codes.h"
+
+static DEFINE_PER_CPU(unsigned int, service_queue_rotor);
+
+/**
+ * DOC: Work queue definition.
+ *
+ * There are two types of work queues: simple, with one worker thread, and round-robin, which uses
+ * a group of the former to do the work, and assigns work to them in round-robin fashion (roughly).
+ * Externally, both are represented via the same common sub-structure, though there's actually not
+ * a great deal of overlap between the two types internally.
+ */
+struct vdo_work_queue {
+	/* Name of just the work queue (e.g., "cpuQ12") */
+	char *name;
+	bool round_robin_mode;
+	struct vdo_thread *owner;
+	/* Life cycle functions, etc */
+	const struct vdo_work_queue_type *type;
+};
+
+struct simple_work_queue {
+	struct vdo_work_queue common;
+	struct funnel_queue *priority_lists[VDO_WORK_Q_MAX_PRIORITY + 1];
+	void *private;
+
+	/*
+	 * The fields above are unchanged after setup but often read, and are good candidates for
+	 * caching -- and if the max priority is 2, just fit in one x86-64 cache line if aligned.
+	 * The fields below are often modified as we sleep and wake, so we want a separate cache
+	 * line for performance.
+	 */
+
+	/* Any (0 or 1) worker threads waiting for new work to do */
+	wait_queue_head_t waiting_worker_threads ____cacheline_aligned;
+	/* Hack to reduce wakeup calls if the worker thread is running */
+	atomic_t idle;
+
+	/* These are infrequently used so in terms of performance we don't care where they land. */
+	struct task_struct *thread;
+	/* Notify creator once worker has initialized */
+	struct completion *started;
+};
+
+struct round_robin_work_queue {
+	struct vdo_work_queue common;
+	struct simple_work_queue **service_queues;
+	unsigned int num_service_queues;
+};
+
+static inline struct simple_work_queue *as_simple_work_queue(struct vdo_work_queue *queue)
+{
+	return ((queue == NULL) ? NULL : container_of(queue, struct simple_work_queue, common));
+}
+
+static inline struct round_robin_work_queue *
+as_round_robin_work_queue(struct vdo_work_queue *queue)
+{
+	return ((queue == NULL) ?
+		 NULL :
+		 container_of(queue, struct round_robin_work_queue, common));
+}
+
+/* Processing normal completions. */
+
+/*
+ * Dequeue and return the next waiting completion, if any.
+ *
+ * We scan the funnel queues from highest priority to lowest, once; there is therefore a race
+ * condition where a high-priority completion can be enqueued followed by a lower-priority one, and
+ * we'll grab the latter (but we'll catch the high-priority item on the next call). If strict
+ * enforcement of priorities becomes necessary, this function will need fixing.
+ */
+static struct vdo_completion *poll_for_completion(struct simple_work_queue *queue)
+{
+	int i;
+
+	for (i = queue->common.type->max_priority; i >= 0; i--) {
+		struct funnel_queue_entry *link = uds_funnel_queue_poll(queue->priority_lists[i]);
+
+		if (link != NULL)
+			return container_of(link, struct vdo_completion, work_queue_entry_link);
+	}
+
+	return NULL;
+}
+
+static void
+enqueue_work_queue_completion(struct simple_work_queue *queue, struct vdo_completion *completion)
+{
+	ASSERT_LOG_ONLY(completion->my_queue == NULL,
+			"completion %px (fn %px) to enqueue (%px) is not already queued (%px)",
+			completion,
+			completion->callback,
+			queue,
+			completion->my_queue);
+	if (completion->priority == VDO_WORK_Q_DEFAULT_PRIORITY)
+		completion->priority = queue->common.type->default_priority;
+
+	if (ASSERT(completion->priority <= queue->common.type->max_priority,
+		   "priority is in range for queue") != VDO_SUCCESS)
+		completion->priority = 0;
+
+	completion->my_queue = &queue->common;
+
+	/* Funnel queue handles the synchronization for the put. */
+	uds_funnel_queue_put(queue->priority_lists[completion->priority],
+			     &completion->work_queue_entry_link);
+
+	/*
+	 * Due to how funnel queue synchronization is handled (just atomic operations), the
+	 * simplest safe implementation here would be to wake-up any waiting threads after
+	 * enqueueing each item. Even if the funnel queue is not empty at the time of adding an
+	 * item to the queue, the consumer thread may not see this since it is not guaranteed to
+	 * have the same view of the queue as a producer thread.
+	 *
+	 * However, the above is wasteful so instead we attempt to minimize the number of thread
+	 * wakeups. Using an idle flag, and careful ordering using memory barriers, we should be
+	 * able to determine when the worker thread might be asleep or going to sleep. We use
+	 * cmpxchg to try to take ownership (vs other producer threads) of the responsibility for
+	 * waking the worker thread, so multiple wakeups aren't tried at once.
+	 *
+	 * This was tuned for some x86 boxes that were handy; it's untested whether doing the read
+	 * first is any better or worse for other platforms, even other x86 configurations.
+	 */
+	smp_mb();
+	if ((atomic_read(&queue->idle) != 1) || (atomic_cmpxchg(&queue->idle, 1, 0) != 1))
+		return;
+
+	/* There's a maximum of one thread in this list. */
+	wake_up(&queue->waiting_worker_threads);
+}
+
+static void run_start_hook(struct simple_work_queue *queue)
+{
+	if (queue->common.type->start != NULL)
+		queue->common.type->start(queue->private);
+}
+
+static void run_finish_hook(struct simple_work_queue *queue)
+{
+	if (queue->common.type->finish != NULL)
+		queue->common.type->finish(queue->private);
+}
+
+/*
+ * Wait for the next completion to process, or until kthread_should_stop indicates that it's time
+ * for us to shut down.
+ *
+ * If kthread_should_stop says it's time to stop but we have pending completions return a
+ * completion.
+ *
+ * Also update statistics relating to scheduler interactions.
+ */
+static struct vdo_completion *wait_for_next_completion(struct simple_work_queue *queue)
+{
+	struct vdo_completion *completion;
+	DEFINE_WAIT(wait);
+
+	while (true) {
+		prepare_to_wait(&queue->waiting_worker_threads, &wait, TASK_INTERRUPTIBLE);
+		/*
+		 * Don't set the idle flag until a wakeup will not be lost.
+		 *
+		 * Force synchronization between setting the idle flag and checking the funnel
+		 * queue; the producer side will do them in the reverse order. (There's still a
+		 * race condition we've chosen to allow, because we've got a timeout below that
+		 * unwedges us if we hit it, but this may narrow the window a little.)
+		 */
+		atomic_set(&queue->idle, 1);
+		smp_mb(); /* store-load barrier between "idle" and funnel queue */
+
+		completion = poll_for_completion(queue);
+		if (completion != NULL)
+			break;
+
+		/*
+		 * We need to check for thread-stop after setting TASK_INTERRUPTIBLE state up
+		 * above. Otherwise, schedule() will put the thread to sleep and might miss a
+		 * wakeup from kthread_stop() call in vdo_finish_work_queue().
+		 */
+		if (kthread_should_stop())
+			break;
+
+		schedule();
+
+		/*
+		 * Most of the time when we wake, it should be because there's work to do. If it
+		 * was a spurious wakeup, continue looping.
+		 */
+		completion = poll_for_completion(queue);
+		if (completion != NULL)
+			break;
+	}
+
+	finish_wait(&queue->waiting_worker_threads, &wait);
+	atomic_set(&queue->idle, 0);
+
+	return completion;
+}
+
+static void process_completion(struct simple_work_queue *queue, struct vdo_completion *completion)
+{
+	if (ASSERT(completion->my_queue == &queue->common,
+		   "completion %px from queue %px marked as being in this queue (%px)",
+		   completion,
+		   queue,
+		   completion->my_queue) == UDS_SUCCESS)
+		completion->my_queue = NULL;
+
+	vdo_run_completion(completion);
+}
+
+static void service_work_queue(struct simple_work_queue *queue)
+{
+	run_start_hook(queue);
+
+	while (true) {
+		struct vdo_completion *completion = poll_for_completion(queue);
+
+		if (completion == NULL)
+			completion = wait_for_next_completion(queue);
+
+		if (completion == NULL)
+			/* No completions but kthread_should_stop() was triggered. */
+			break;
+
+		process_completion(queue, completion);
+
+		/*
+		 * Be friendly to a CPU that has other work to do, if the kernel has told us to.
+		 * This speeds up some performance tests; that "other work" might include other VDO
+		 * threads.
+		 */
+		if (need_resched())
+			cond_resched();
+	}
+
+	run_finish_hook(queue);
+}
+
+static int work_queue_runner(void *ptr)
+{
+	struct simple_work_queue *queue = ptr;
+
+	complete(queue->started);
+	service_work_queue(queue);
+	return 0;
+}
+
+/* Creation & teardown */
+
+static void free_simple_work_queue(struct simple_work_queue *queue)
+{
+	unsigned int i;
+
+	for (i = 0; i <= VDO_WORK_Q_MAX_PRIORITY; i++)
+		uds_free_funnel_queue(queue->priority_lists[i]);
+	UDS_FREE(queue->common.name);
+	UDS_FREE(queue);
+}
+
+static void free_round_robin_work_queue(struct round_robin_work_queue *queue)
+{
+	struct simple_work_queue **queue_table = queue->service_queues;
+	unsigned int count = queue->num_service_queues;
+	unsigned int i;
+
+	queue->service_queues = NULL;
+
+	for (i = 0; i < count; i++)
+		free_simple_work_queue(queue_table[i]);
+	UDS_FREE(queue_table);
+	UDS_FREE(queue->common.name);
+	UDS_FREE(queue);
+}
+
+void vdo_free_work_queue(struct vdo_work_queue *queue)
+{
+	if (queue == NULL)
+		return;
+
+	vdo_finish_work_queue(queue);
+
+	if (queue->round_robin_mode)
+		free_round_robin_work_queue(as_round_robin_work_queue(queue));
+	else
+		free_simple_work_queue(as_simple_work_queue(queue));
+}
+
+static int make_simple_work_queue(const char *thread_name_prefix,
+				  const char *name,
+				  struct vdo_thread *owner,
+				  void *private,
+				  const struct vdo_work_queue_type *type,
+				  struct simple_work_queue **queue_ptr)
+{
+	DECLARE_COMPLETION_ONSTACK(started);
+	struct simple_work_queue *queue;
+	int i;
+	struct task_struct *thread = NULL;
+	int result;
+
+	ASSERT_LOG_ONLY((type->max_priority <= VDO_WORK_Q_MAX_PRIORITY),
+			"queue priority count %u within limit %u",
+			type->max_priority,
+			VDO_WORK_Q_MAX_PRIORITY);
+
+	result = UDS_ALLOCATE(1, struct simple_work_queue, "simple work queue", &queue);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	queue->private = private;
+	queue->started = &started;
+	queue->common.type = type;
+	queue->common.owner = owner;
+	init_waitqueue_head(&queue->waiting_worker_threads);
+
+	result = uds_duplicate_string(name, "queue name", &queue->common.name);
+	if (result != VDO_SUCCESS) {
+		UDS_FREE(queue);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i <= type->max_priority; i++) {
+		result = uds_make_funnel_queue(&queue->priority_lists[i]);
+		if (result != UDS_SUCCESS) {
+			free_simple_work_queue(queue);
+			return result;
+		}
+	}
+
+	thread = kthread_run(work_queue_runner,
+			     queue,
+			     "%s:%s",
+			     thread_name_prefix,
+			     queue->common.name);
+	if (IS_ERR(thread)) {
+		free_simple_work_queue(queue);
+		return (int) PTR_ERR(thread);
+	}
+
+	queue->thread = thread;
+
+	/*
+	 * If we don't wait to ensure the thread is running VDO code, a quick kthread_stop (due to
+	 * errors elsewhere) could cause it to never get as far as running VDO, skipping the
+	 * cleanup code.
+	 *
+	 * Eventually we should just make that path safe too, and then we won't need this
+	 * synchronization.
+	 */
+	wait_for_completion(&started);
+
+	*queue_ptr = queue;
+	return UDS_SUCCESS;
+}
+
+/**
+ * vdo_make_work_queue() - Create a work queue; if multiple threads are requested, completions will
+ *                         be distributed to them in round-robin fashion.
+ *
+ * Each queue is associated with a struct vdo_thread which has a single vdo thread id. Regardless
+ * of the actual number of queues and threads allocated here, code outside of the queue
+ * implementation will treat this as a single zone.
+ */
+int vdo_make_work_queue(const char *thread_name_prefix,
+			const char *name,
+			struct vdo_thread *owner,
+			const struct vdo_work_queue_type *type,
+			unsigned int thread_count,
+			void *thread_privates[],
+			struct vdo_work_queue **queue_ptr)
+{
+	struct round_robin_work_queue *queue;
+	int result;
+	char thread_name[TASK_COMM_LEN];
+	unsigned int i;
+
+	if (thread_count == 1) {
+		struct simple_work_queue *simple_queue;
+		void *context = ((thread_privates != NULL) ? thread_privates[0] : NULL);
+
+		result = make_simple_work_queue(thread_name_prefix,
+						name,
+						owner,
+						context,
+						type,
+						&simple_queue);
+		if (result == VDO_SUCCESS)
+			*queue_ptr = &simple_queue->common;
+		return result;
+	}
+
+	result = UDS_ALLOCATE(1, struct round_robin_work_queue, "round-robin work queue", &queue);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(thread_count,
+			      struct simple_work_queue *,
+			      "subordinate work queues",
+			      &queue->service_queues);
+	if (result != UDS_SUCCESS) {
+		UDS_FREE(queue);
+		return result;
+	}
+
+	queue->num_service_queues = thread_count;
+	queue->common.round_robin_mode = true;
+	queue->common.owner = owner;
+
+	result = uds_duplicate_string(name, "queue name", &queue->common.name);
+	if (result != VDO_SUCCESS) {
+		UDS_FREE(queue->service_queues);
+		UDS_FREE(queue);
+		return -ENOMEM;
+	}
+
+	*queue_ptr = &queue->common;
+
+	for (i = 0; i < thread_count; i++) {
+		void *context = ((thread_privates != NULL) ? thread_privates[i] : NULL);
+
+		snprintf(thread_name, sizeof(thread_name), "%s%u", name, i);
+		result = make_simple_work_queue(thread_name_prefix,
+						thread_name,
+						owner,
+						context,
+						type,
+						&queue->service_queues[i]);
+		if (result != VDO_SUCCESS) {
+			queue->num_service_queues = i;
+			/* Destroy previously created subordinates. */
+			vdo_free_work_queue(UDS_FORGET(*queue_ptr));
+			return result;
+		}
+	}
+
+	return VDO_SUCCESS;
+}
+
+static void finish_simple_work_queue(struct simple_work_queue *queue)
+{
+	if (queue->thread == NULL)
+		return;
+
+	/* Tells the worker thread to shut down and waits for it to exit. */
+	kthread_stop(queue->thread);
+	queue->thread = NULL;
+}
+
+static void finish_round_robin_work_queue(struct round_robin_work_queue *queue)
+{
+	struct simple_work_queue **queue_table = queue->service_queues;
+	unsigned int count = queue->num_service_queues;
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		finish_simple_work_queue(queue_table[i]);
+}
+
+/* No enqueueing of completions should be done once this function is called. */
+void vdo_finish_work_queue(struct vdo_work_queue *queue)
+{
+	if (queue == NULL)
+		return;
+
+	if (queue->round_robin_mode)
+		finish_round_robin_work_queue(as_round_robin_work_queue(queue));
+	else
+		finish_simple_work_queue(as_simple_work_queue(queue));
+}
+
+/* Debugging dumps */
+
+static void dump_simple_work_queue(struct simple_work_queue *queue)
+{
+	const char *thread_status = "no threads";
+	char task_state_report = '-';
+
+	if (queue->thread != NULL) {
+		task_state_report = task_state_to_char(queue->thread);
+		thread_status = atomic_read(&queue->idle) ? "idle" : "running";
+	}
+
+	uds_log_info("workQ %px (%s) %s (%c)",
+		     &queue->common,
+		     queue->common.name,
+		     thread_status,
+		     task_state_report);
+
+	/* ->waiting_worker_threads wait queue status? anyone waiting? */
+}
+
+/*
+ * Write to the buffer some info about the completion, for logging. Since the common use case is
+ * dumping info about a lot of completions to syslog all at once, the format favors brevity over
+ * readability.
+ */
+void vdo_dump_work_queue(struct vdo_work_queue *queue)
+{
+	if (queue->round_robin_mode) {
+		struct round_robin_work_queue *round_robin = as_round_robin_work_queue(queue);
+		unsigned int i;
+
+		for (i = 0; i < round_robin->num_service_queues; i++)
+			dump_simple_work_queue(round_robin->service_queues[i]);
+	} else {
+		dump_simple_work_queue(as_simple_work_queue(queue));
+	}
+}
+
+static void get_function_name(void *pointer, char *buffer, size_t buffer_length)
+{
+	if (pointer == NULL) {
+		/*
+		 * Format "%ps" logs a null pointer as "(null)" with a bunch of leading spaces. We
+		 * sometimes use this when logging lots of data; don't be so verbose.
+		 */
+		strncpy(buffer, "-", buffer_length);
+	} else {
+		/*
+		 * Use a pragma to defeat gcc's format checking, which doesn't understand that
+		 * "%ps" actually does support a precision spec in Linux kernel code.
+		 */
+		char *space;
+
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wformat"
+		snprintf(buffer, buffer_length, "%.*ps", buffer_length - 1, pointer);
+#pragma GCC diagnostic pop
+
+		space = strchr(buffer, ' ');
+		if (space != NULL)
+			*space = '\0';
+	}
+}
+
+void vdo_dump_completion_to_buffer(struct vdo_completion *completion, char *buffer, size_t length)
+{
+	size_t current_length =
+		scnprintf(buffer,
+			  length,
+			  "%.*s/",
+			  TASK_COMM_LEN,
+			  (completion->my_queue == NULL ? "-" : completion->my_queue->name));
+
+	if (current_length < length)
+		get_function_name((void *) completion->callback,
+				  buffer + current_length,
+				  length - current_length);
+}
+
+/* Completion submission */
+/*
+ * If the completion has a timeout that has already passed, the timeout handler function may be
+ * invoked by this function.
+ */
+void vdo_enqueue_work_queue(struct vdo_work_queue *queue, struct vdo_completion *completion)
+{
+	/*
+	 * Convert the provided generic vdo_work_queue to the simple_work_queue to actually queue
+	 * on.
+	 */
+	struct simple_work_queue *simple_queue = NULL;
+
+	if (!queue->round_robin_mode) {
+		simple_queue = as_simple_work_queue(queue);
+	} else {
+		struct round_robin_work_queue *round_robin = as_round_robin_work_queue(queue);
+
+		/*
+		 * It shouldn't be a big deal if the same rotor gets used for multiple work queues.
+		 * Any patterns that might develop are likely to be disrupted by random ordering of
+		 * multiple completions and migration between cores, unless the load is so light as
+		 * to be regular in ordering of tasks and the threads are confined to individual
+		 * cores; with a load that light we won't care.
+		 */
+		unsigned int rotor = this_cpu_inc_return(service_queue_rotor);
+		unsigned int index = rotor % round_robin->num_service_queues;
+
+		simple_queue = round_robin->service_queues[index];
+	}
+
+	enqueue_work_queue_completion(simple_queue, completion);
+}
+
+/* Misc */
+
+/*
+ * Return the work queue pointer recorded at initialization time in the work-queue stack handle
+ * initialized on the stack of the current thread, if any.
+ */
+static struct simple_work_queue *get_current_thread_work_queue(void)
+{
+	/*
+	 * In interrupt context, if a vdo thread is what got interrupted, the calls below will find
+	 * the queue for the thread which was interrupted. However, the interrupted thread may have
+	 * been processing a completion, in which case starting to process another would violate
+	 * our concurrency assumptions.
+	 */
+	if (in_interrupt())
+		return NULL;
+	if (kthread_func(current) != work_queue_runner)
+		/* Not a VDO work queue thread. */
+		return NULL;
+	return kthread_data(current);
+}
+
+struct vdo_work_queue *vdo_get_current_work_queue(void)
+{
+	struct simple_work_queue *queue = get_current_thread_work_queue();
+
+	return (queue == NULL) ? NULL : &queue->common;
+}
+
+struct vdo_thread *vdo_get_work_queue_owner(struct vdo_work_queue *queue)
+{
+	return queue->owner;
+}
+
+/**
+ * vdo_get_work_queue_private_data() - Returns the private data for the current thread's work
+ *                                     queue, or NULL if none or if the current thread is not a
+ *                                     work queue thread.
+ */
+void *vdo_get_work_queue_private_data(void)
+{
+	struct simple_work_queue *queue = get_current_thread_work_queue();
+
+	return (queue != NULL) ? queue->private : NULL;
+}
+
+bool vdo_work_queue_type_is(struct vdo_work_queue *queue, const struct vdo_work_queue_type *type)
+{
+	return (queue->type == type);
+}
diff --git a/drivers/md/dm-vdo/work-queue.h b/drivers/md/dm-vdo/work-queue.h
new file mode 100644
index 00000000000..d1e05f8901d
--- /dev/null
+++ b/drivers/md/dm-vdo/work-queue.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef VDO_WORK_QUEUE_H
+#define VDO_WORK_QUEUE_H
+
+#include <linux/sched.h> /* for TASK_COMM_LEN */
+
+#include "types.h"
+
+enum {
+	MAX_VDO_WORK_QUEUE_NAME_LEN = TASK_COMM_LEN,
+};
+
+struct vdo_work_queue_type {
+	void (*start)(void *context);
+	void (*finish)(void *context);
+	enum vdo_completion_priority max_priority;
+	enum vdo_completion_priority default_priority;
+};
+
+struct vdo_completion;
+struct vdo_thread;
+struct vdo_work_queue;
+
+int vdo_make_work_queue(const char *thread_name_prefix,
+			const char *name,
+			struct vdo_thread *owner,
+			const struct vdo_work_queue_type *type,
+			unsigned int thread_count,
+			void *thread_privates[],
+			struct vdo_work_queue **queue_ptr);
+
+void vdo_enqueue_work_queue(struct vdo_work_queue *queue, struct vdo_completion *completion);
+
+void vdo_finish_work_queue(struct vdo_work_queue *queue);
+
+void vdo_free_work_queue(struct vdo_work_queue *queue);
+
+void vdo_dump_work_queue(struct vdo_work_queue *queue);
+
+void vdo_dump_completion_to_buffer(struct vdo_completion *completion, char *buffer, size_t length);
+
+void *vdo_get_work_queue_private_data(void);
+struct vdo_work_queue *vdo_get_current_work_queue(void);
+struct vdo_thread *vdo_get_work_queue_owner(struct vdo_work_queue *queue);
+
+bool __must_check
+vdo_work_queue_type_is(struct vdo_work_queue *queue, const struct vdo_work_queue_type *type);
+
+#endif /* VDO_WORK_QUEUE_H */
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

