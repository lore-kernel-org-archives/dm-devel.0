Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA98EEAA65
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719063;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MzLIRKIbGX9pGAy+j4SMKnZFjEG27pONRdOhi5ngOXo=;
	b=K5V3S3EYR0xjC+ENHvJ0i0FMD6ZXniHWLvkcEnLtGX8Kfv6qywW2fo0tuZC8LUqyZeEHfE
	VscYmjxhaoyboV5AGzJ2nr0FEsGu/4kaSHBO3A937HspHrBAT3xkOwVyLzhuLUUYUX+ieD
	3Ams+hwR56e/P79ufbPdqb0A97yXw+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-cgp1JNA3P-6mqWWadGIGWQ-1; Thu, 14 Sep 2023 15:17:41 -0400
X-MC-Unique: cgp1JNA3P-6mqWWadGIGWQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C46BB88B7A8;
	Thu, 14 Sep 2023 19:17:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AE2AA2026D4B;
	Thu, 14 Sep 2023 19:17:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF7281946A67;
	Thu, 14 Sep 2023 19:16:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2D82D19466ED
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:16:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 02A4A40C6EBF; Thu, 14 Sep 2023 19:16:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EE89140C6EA8
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:16:46 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEED5185A79B
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:16:46 +0000 (UTC)
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com
 [209.85.222.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-eRHt0bMAOQWW7hLyt1_dLA-1; Thu, 14 Sep 2023 15:16:44 -0400
X-MC-Unique: eRHt0bMAOQWW7hLyt1_dLA-1
Received: by mail-qk1-f178.google.com with SMTP id
 af79cd13be357-76ef80a503fso87954485a.1
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:16:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719004; x=1695323804;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=dGbAHgWskUv+qGtUxqzSNJHZhIYUG5afMlMQqTNURFs=;
 b=WNfM1iQY6phY78ULDIrhfv0QtI5RWTNTDFCg+jRXqld2gRyOdWzO4q8DoCTcxp5Nlg
 2MK4qU8g7QQRv3UqWBKzCflbE2MQ0kgBnVkubGRZZ1vYte1i1y5gBpR05ln42dXA5yZm
 jCDLY+Cz+PN7HiTT+PEU2sc0wQw5mhvrZ2HbUg2c8moyK6Uwc40PtF6LXmUy4tA6MoKL
 azpcXEpAVPAjVcuHaFxGk7Lpk1Pj6H1Ogqw8xdDMgIgcUjmbM9WnKgjQzF36oEbnbG82
 LR7GAxo5jUI+NJck+kc3AjRFotgshED6mbBDNXdYR1MgnAjPglPyXskOu3Z4REB0NAyK
 yX+g==
X-Gm-Message-State: AOJu0YzbJ4fk6EWpnMaTAyAsMcpyhN9FsgI+wfQb3J+ZkDfpPkCTOKfh
 zBOkyfWaFPJopYNYc2AdOIUe7IPCOvasnhZPc4+piodIDgFQzqFWkQL0LT84MwoJ9rnyyjNKdl8
 oTxEkYQlASzdILLC80ccjFX1TGgU8afq7dpCNj1+imKaQm76Sh7BFVa7cYqASV0pUgLLPEaSZ
X-Google-Smtp-Source: AGHT+IFen3eFpHWbSdTGqocLUgxbxQtRHz7DoSiKdzoSGinlk8w53ajVHe0nZzOMtIajpwO5wE4blQ==
X-Received: by 2002:a0c:ca03:0:b0:655:de6d:f0b2 with SMTP id
 c3-20020a0cca03000000b00655de6df0b2mr6509066qvk.61.1694719003529; 
 Thu, 14 Sep 2023 12:16:43 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 a5-20020a0ce385000000b0064f46918737sm663678qvl.91.2023.09.14.12.16.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:16:42 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:15:59 -0400
Message-Id: <20230914191635.39805-4-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v3 03/39] dm vdo: add memory allocation utilities
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Matthew Sakai <msakai@redhat.com>

Add standardized allocation macros and memory tracking tools to track
and report any allocated memory that is not freed. This makes it
easier to ensure that the vdo target does not leak memory.

Also adds utilities for controlling whether certain threads are
allowed to allocate memory, since memory allocation during certain
critical code sections can cause the vdo target to deadlock.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: Michael Sclafani <vdo-devel@redhat.com>
Signed-off-by: Michael Sclafani <vdo-devel@redhat.com>
Co-developed-by: Thomas Jaskiewicz <tom@jaskiewicz.us>
Signed-off-by: Thomas Jaskiewicz <tom@jaskiewicz.us>
Co-developed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-vdo/memory-alloc.c | 447 +++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/memory-alloc.h | 181 +++++++++++++
 2 files changed, 628 insertions(+)
 create mode 100644 drivers/md/dm-vdo/memory-alloc.c
 create mode 100644 drivers/md/dm-vdo/memory-alloc.h

diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
new file mode 100644
index 000000000000..41b15f7a7ba6
--- /dev/null
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -0,0 +1,447 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
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
index 000000000000..3fc495afdaea
--- /dev/null
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -0,0 +1,181 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
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
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

