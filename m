Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99ACBEEAA65
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719148;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GBlT040xiBO8MEs98tyei7GCbNcG1ooMMI9gMNoDUPk=;
	b=bGcESQF9FL1Rk2aVPdQbx7qlvbF6rZ3F7ogXnj4S4Ih71gEngW8LddRLVlmcMSwb+52wTJ
	Wn3fY8YVLE01apIpICUxXPxB0PgoEgruQBbtFs1aBbLqAP8cDq9yul5nsdchjNgrfJos9b
	+wdWDm739Fq6z+hvslSNgGV/xdN92rU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-qTWaHLQUPGq9ol3l5YE2bg-1; Thu, 14 Sep 2023 15:19:05 -0400
X-MC-Unique: qTWaHLQUPGq9ol3l5YE2bg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36AA288B7AF;
	Thu, 14 Sep 2023 19:19:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1F8AE2026D76;
	Thu, 14 Sep 2023 19:19:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F1A519452C6;
	Thu, 14 Sep 2023 19:17:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6C7B619452FE
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:17:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 599C310EA0; Thu, 14 Sep 2023 19:17:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 511A07B62
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25028100F7FB
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:36 +0000 (UTC)
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com
 [209.85.222.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-Pr1BCF_hOnawoyyEsqgnmA-1; Thu, 14 Sep 2023 15:17:32 -0400
X-MC-Unique: Pr1BCF_hOnawoyyEsqgnmA-1
Received: by mail-qk1-f178.google.com with SMTP id
 af79cd13be357-76dc77fd01fso86417585a.3
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:17:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719051; x=1695323851;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=OY3kp6IT0Vnyvy/Uc5/+SDkex4hMA27vSxwsv40A6AE=;
 b=EmKwnW/+6sQTx0zldA0Sdg3WdIggsONeSWcES2GKQ6sRuPXlLXOjMiCz6KHIGeomw0
 ntGzDpBKpORPfevtT95Xf8zrMik+DZlgFccdH+YvcVfQ0lBGuEgw3LF7s91xGgQpwOj1
 K1xYAZqrGnqhRvjSYGqjcTS6Tm8A0LPwdRQl6fDlYkmNOd5VB7BptsL5AVmhcI22nbRs
 a6oBUOcHN0WO4uP5ZZMzTBDxZYT+elgA6ko3go0yoN3fDYDzFIlr/3R0W2jQqyB9Zh0A
 Zx9ORe6NonbnYKdBSyJeL61yd4/pgrBgY+BJAT/M+vDjkj26yHvyjdRIGzEHkPtopksi
 iyGg==
X-Gm-Message-State: AOJu0YwxlpKeOBxjqK6xjQhPlDdMpWyOHkOlHtMHJn/oS/1lQLerHrIJ
 eV5G2gV8mGLhCHEGa0Mr5KfnxlC+Gfn7bJWSHJ3InleGkiYaJF2V8tdEz5H//XOD3lzAKDwv8WL
 xIoR0bMKPwSA/kJgmFVzN70FOM5JbzKYAVqpv2M64Rj7VJy13ZdjW9rRApQDcFzBtW/jNYWyq
X-Google-Smtp-Source: AGHT+IHiYljuzj71z9fMWTOrgnMWEyA6VRE0X5AmXJ62xqJCAhrI85SkR0ihJsquNj/SyhloVYediA==
X-Received: by 2002:a05:620a:44cd:b0:773:ad1b:2e10 with SMTP id
 y13-20020a05620a44cd00b00773ad1b2e10mr631477qkp.48.1694719050018; 
 Thu, 14 Sep 2023 12:17:30 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 a24-20020a05620a125800b0076f039d87c6sm674915qkl.82.2023.09.14.12.17.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:17:29 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:16:23 -0400
Message-Id: <20230914191635.39805-28-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v3 27/39] dm vdo: add the block allocators and
 physical zones
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

Each slab is independent of every other. They are assigned to
"physical zones" in round-robin fashion. If there are P physical
zones, then slab n is assigned to zone n mod P. The set of slabs in
each physical zone is managed by a block allocator.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: Michael Sclafani <vdo-devel@redhat.com>
Signed-off-by: Michael Sclafani <vdo-devel@redhat.com>
Co-developed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-vdo/physical-zone.c |  650 +++++++++++++
 drivers/md/dm-vdo/physical-zone.h |  115 +++
 drivers/md/dm-vdo/slab-depot.c    | 1462 +++++++++++++++++++++++++++++
 drivers/md/dm-vdo/slab-depot.h    |  146 +++
 4 files changed, 2373 insertions(+)
 create mode 100644 drivers/md/dm-vdo/physical-zone.c
 create mode 100644 drivers/md/dm-vdo/physical-zone.h

diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
new file mode 100644
index 000000000000..822da4e8f579
--- /dev/null
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -0,0 +1,650 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#include "physical-zone.h"
+
+#include <linux/list.h>
+
+#include "logger.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+
+#include "block-map.h"
+#include "completion.h"
+#include "constants.h"
+#include "data-vio.h"
+#include "dedupe.h"
+#include "encodings.h"
+#include "flush.h"
+#include "int-map.h"
+#include "slab-depot.h"
+#include "status-codes.h"
+#include "vdo.h"
+
+enum {
+	/* Each user data_vio needs a PBN read lock and write lock. */
+	LOCK_POOL_CAPACITY = 2 * MAXIMUM_VDO_USER_VIOS,
+};
+
+struct pbn_lock_implementation {
+	enum pbn_lock_type type;
+	const char *name;
+	const char *release_reason;
+};
+
+/* This array must have an entry for every pbn_lock_type value. */
+static const struct pbn_lock_implementation LOCK_IMPLEMENTATIONS[] = {
+	[VIO_READ_LOCK] = {
+		.type = VIO_READ_LOCK,
+		.name = "read",
+		.release_reason = "candidate duplicate",
+	},
+	[VIO_WRITE_LOCK] = {
+		.type = VIO_WRITE_LOCK,
+		.name = "write",
+		.release_reason = "newly allocated",
+	},
+	[VIO_BLOCK_MAP_WRITE_LOCK] = {
+		.type = VIO_BLOCK_MAP_WRITE_LOCK,
+		.name = "block map write",
+		.release_reason = "block map write",
+	},
+};
+
+static inline bool has_lock_type(const struct pbn_lock *lock, enum pbn_lock_type type)
+{
+	return (lock->implementation == &LOCK_IMPLEMENTATIONS[type]);
+}
+
+/**
+ * vdo_is_pbn_read_lock() - Check whether a pbn_lock is a read lock.
+ * @lock: The lock to check.
+ *
+ * Return: true if the lock is a read lock.
+ */
+bool vdo_is_pbn_read_lock(const struct pbn_lock *lock)
+{
+	return has_lock_type(lock, VIO_READ_LOCK);
+}
+
+static inline void set_pbn_lock_type(struct pbn_lock *lock, enum pbn_lock_type type)
+{
+	lock->implementation = &LOCK_IMPLEMENTATIONS[type];
+}
+
+/**
+ * vdo_downgrade_pbn_write_lock() - Downgrade a PBN write lock to a PBN read lock.
+ * @lock: The PBN write lock to downgrade.
+ *
+ * The lock holder count is cleared and the caller is responsible for setting the new count.
+ */
+void vdo_downgrade_pbn_write_lock(struct pbn_lock *lock, bool compressed_write)
+{
+	ASSERT_LOG_ONLY(!vdo_is_pbn_read_lock(lock),
+			"PBN lock must not already have been downgraded");
+	ASSERT_LOG_ONLY(!has_lock_type(lock, VIO_BLOCK_MAP_WRITE_LOCK),
+			"must not downgrade block map write locks");
+	ASSERT_LOG_ONLY(lock->holder_count == 1,
+			"PBN write lock should have one holder but has %u",
+			lock->holder_count);
+	/*
+	 * data_vio write locks are downgraded in place--the writer retains the hold on the lock.
+	 * If this was a compressed write, the holder has not yet journaled its own inc ref,
+	 * otherwise, it has.
+	 */
+	lock->increment_limit =
+		(compressed_write ? MAXIMUM_REFERENCE_COUNT : MAXIMUM_REFERENCE_COUNT - 1);
+	set_pbn_lock_type(lock, VIO_READ_LOCK);
+}
+
+/**
+ * vdo_claim_pbn_lock_increment() - Try to claim one of the available reference count increments on
+ *				    a read lock.
+ * @lock: The PBN read lock from which to claim an increment.
+ *
+ * Claims may be attempted from any thread. A claim is only valid until the PBN lock is released.
+ *
+ * Return: true if the claim succeeded, guaranteeing one increment can be made without overflowing
+ *	   the PBN's reference count.
+ */
+bool vdo_claim_pbn_lock_increment(struct pbn_lock *lock)
+{
+	/*
+	 * Claim the next free reference atomically since hash locks from multiple hash zone
+	 * threads might be concurrently deduplicating against a single PBN lock on compressed
+	 * block. As long as hitting the increment limit will lead to the PBN lock being released
+	 * in a sane time-frame, we won't overflow a 32-bit claim counter, allowing a simple add
+	 * instead of a compare-and-swap.
+	 */
+	u32 claim_number = (u32) atomic_add_return(1, &lock->increments_claimed);
+
+	return (claim_number <= lock->increment_limit);
+}
+
+/**
+ * vdo_assign_pbn_lock_provisional_reference() - Inform a PBN lock that it is responsible for a
+ *						 provisional reference.
+ * @lock: The PBN lock.
+ */
+void vdo_assign_pbn_lock_provisional_reference(struct pbn_lock *lock)
+{
+	ASSERT_LOG_ONLY(!lock->has_provisional_reference,
+			"lock does not have a provisional reference");
+	lock->has_provisional_reference = true;
+}
+
+/**
+ * vdo_unassign_pbn_lock_provisional_reference() - Inform a PBN lock that it is no longer
+ *						   responsible for a provisional reference.
+ * @lock: The PBN lock.
+ */
+void vdo_unassign_pbn_lock_provisional_reference(struct pbn_lock *lock)
+{
+	lock->has_provisional_reference = false;
+}
+
+/**
+ * release_pbn_lock_provisional_reference() - If the lock is responsible for a provisional
+ *					      reference, release that reference.
+ * @lock: The lock.
+ * @locked_pbn: The PBN covered by the lock.
+ * @allocator: The block allocator from which to release the reference.
+ *
+ * This method is called when the lock is released.
+ */
+static void
+release_pbn_lock_provisional_reference(struct pbn_lock *lock,
+				       physical_block_number_t locked_pbn,
+				       struct block_allocator *allocator)
+{
+	int result;
+
+	if (!vdo_pbn_lock_has_provisional_reference(lock))
+		return;
+
+	result = vdo_release_block_reference(allocator, locked_pbn);
+	if (result != VDO_SUCCESS)
+		uds_log_error_strerror(result,
+				       "Failed to release reference to %s physical block %llu",
+				       lock->implementation->release_reason,
+				       (unsigned long long) locked_pbn);
+
+	vdo_unassign_pbn_lock_provisional_reference(lock);
+}
+
+/**
+ * union idle_pbn_lock - PBN lock list entries.
+ *
+ * Unused (idle) PBN locks are kept in a list. Just like in a malloc implementation, the lock
+ * structure is unused memory, so we can save a bit of space (and not pollute the lock structure
+ * proper) by using a union to overlay the lock structure with the free list.
+ */
+typedef union {
+	/** @entry: Only used while locks are in the pool. */
+	struct list_head entry;
+	/** @lock: Only used while locks are not in the pool. */
+	struct pbn_lock lock;
+} idle_pbn_lock;
+
+/**
+ * struct pbn_lock_pool - list of PBN locks.
+ *
+ * The lock pool is little more than the memory allocated for the locks.
+ */
+struct pbn_lock_pool {
+	/** @capacity: The number of locks allocated for the pool. */
+	size_t capacity;
+	/** @borrowed: The number of locks currently borrowed from the pool. */
+	size_t borrowed;
+	/** @idle_list: A list containing all idle PBN lock instances. */
+	struct list_head idle_list;
+	/** @locks: The memory for all the locks allocated by this pool. */
+	idle_pbn_lock locks[];
+};
+
+/**
+ * return_pbn_lock_to_pool() - Return a pbn lock to its pool.
+ * @pool: The pool from which the lock was borrowed.
+ * @lock: The last reference to the lock being returned.
+ *
+ * It must be the last live reference, as if the memory were being freed (the lock memory will
+ * re-initialized or zeroed).
+ */
+static void return_pbn_lock_to_pool(struct pbn_lock_pool *pool, struct pbn_lock *lock)
+{
+	idle_pbn_lock *idle;
+
+	/* A bit expensive, but will promptly catch some use-after-free errors. */
+	memset(lock, 0, sizeof(*lock));
+
+	idle = container_of(lock, idle_pbn_lock, lock);
+	INIT_LIST_HEAD(&idle->entry);
+	list_add_tail(&idle->entry, &pool->idle_list);
+
+	ASSERT_LOG_ONLY(pool->borrowed > 0, "shouldn't return more than borrowed");
+	pool->borrowed -= 1;
+}
+
+/**
+ * make_pbn_lock_pool() - Create a new PBN lock pool and all the lock instances it can loan out.
+ *
+ * @capacity: The number of PBN locks to allocate for the pool.
+ * @pool_ptr: A pointer to receive the new pool.
+ *
+ * Return: VDO_SUCCESS or an error code.
+ */
+static int make_pbn_lock_pool(size_t capacity, struct pbn_lock_pool **pool_ptr)
+{
+	size_t i;
+	struct pbn_lock_pool *pool;
+	int result;
+
+	result = UDS_ALLOCATE_EXTENDED(struct pbn_lock_pool,
+				       capacity,
+				       idle_pbn_lock,
+				       __func__,
+				       &pool);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	pool->capacity = capacity;
+	pool->borrowed = capacity;
+	INIT_LIST_HEAD(&pool->idle_list);
+
+	for (i = 0; i < capacity; i++)
+		return_pbn_lock_to_pool(pool, &pool->locks[i].lock);
+
+	*pool_ptr = pool;
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_free_pbn_lock_pool() - Free a PBN lock pool.
+ * @pool: The lock pool to free.
+ *
+ * This also frees all the PBN locks it allocated, so the caller must ensure that all locks have
+ * been returned to the pool.
+ */
+static void free_pbn_lock_pool(struct pbn_lock_pool *pool)
+{
+	if (pool == NULL)
+		return;
+
+	ASSERT_LOG_ONLY(pool->borrowed == 0,
+			"All PBN locks must be returned to the pool before it is freed, but %zu locks are still on loan",
+			pool->borrowed);
+	UDS_FREE(pool);
+}
+
+/**
+ * borrow_pbn_lock_from_pool() - Borrow a PBN lock from the pool and initialize it with the
+ *				 provided type.
+ * @pool: The pool from which to borrow.
+ * @type: The type with which to initialize the lock.
+ * @lock_ptr:  A pointer to receive the borrowed lock.
+ *
+ * Pools do not grow on demand or allocate memory, so this will fail if the pool is empty. Borrowed
+ * locks are still associated with this pool and must be returned to only this pool.
+ *
+ * Return: VDO_SUCCESS, or VDO_LOCK_ERROR if the pool is empty.
+ */
+static int __must_check
+borrow_pbn_lock_from_pool(struct pbn_lock_pool *pool,
+			  enum pbn_lock_type type,
+			  struct pbn_lock **lock_ptr)
+{
+	int result;
+	struct list_head *idle_entry;
+	idle_pbn_lock *idle;
+
+	if (pool->borrowed >= pool->capacity)
+		return uds_log_error_strerror(VDO_LOCK_ERROR, "no free PBN locks left to borrow");
+	pool->borrowed += 1;
+
+	result = ASSERT(!list_empty(&pool->idle_list),
+			"idle list should not be empty if pool not at capacity");
+	if (result != VDO_SUCCESS)
+		return result;
+
+	idle_entry = pool->idle_list.prev;
+	list_del(idle_entry);
+	memset(idle_entry, 0, sizeof(*idle_entry));
+
+	idle = list_entry(idle_entry, idle_pbn_lock, entry);
+	idle->lock.holder_count = 0;
+	set_pbn_lock_type(&idle->lock, type);
+
+	*lock_ptr = &idle->lock;
+	return VDO_SUCCESS;
+}
+
+/**
+ * initialize_zone() - Initialize a physical zone.
+ * @vdo: The vdo to which the zone will belong.
+ * @zones: The physical_zones to which the zone being initialized belongs
+ *
+ * Return: VDO_SUCCESS or an error code.
+ */
+static int initialize_zone(struct vdo *vdo, struct physical_zones *zones)
+{
+	int result;
+	zone_count_t zone_number = zones->zone_count;
+	struct physical_zone *zone = &zones->zones[zone_number];
+
+	result = vdo_make_int_map(VDO_LOCK_MAP_CAPACITY, 0, &zone->pbn_operations);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = make_pbn_lock_pool(LOCK_POOL_CAPACITY, &zone->lock_pool);
+	if (result != VDO_SUCCESS) {
+		vdo_free_int_map(zone->pbn_operations);
+		return result;
+	}
+
+	zone->zone_number = zone_number;
+	zone->thread_id = vdo->thread_config.physical_threads[zone_number];
+	zone->allocator = &vdo->depot->allocators[zone_number];
+	zone->next = &zones->zones[(zone_number + 1) % vdo->thread_config.physical_zone_count];
+	result = vdo_make_default_thread(vdo, zone->thread_id);
+	if (result != VDO_SUCCESS) {
+		free_pbn_lock_pool(UDS_FORGET(zone->lock_pool));
+		vdo_free_int_map(zone->pbn_operations);
+		return result;
+	}
+	return result;
+}
+
+/**
+ * vdo_make_physical_zones() - Make the physical zones for a vdo.
+ * @vdo: The vdo being constructed
+ * @zones_ptr: A pointer to hold the zones
+ *
+ * Return: VDO_SUCCESS or an error code.
+ */
+int vdo_make_physical_zones(struct vdo *vdo, struct physical_zones **zones_ptr)
+{
+	struct physical_zones *zones;
+	int result;
+	zone_count_t zone_count = vdo->thread_config.physical_zone_count;
+
+	if (zone_count == 0)
+		return VDO_SUCCESS;
+
+	result = UDS_ALLOCATE_EXTENDED(struct physical_zones,
+				       zone_count,
+				       struct physical_zone,
+				       __func__,
+				       &zones);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	for (zones->zone_count = 0; zones->zone_count < zone_count; zones->zone_count++) {
+		result = initialize_zone(vdo, zones);
+		if (result != VDO_SUCCESS) {
+			vdo_free_physical_zones(zones);
+			return result;
+		}
+	}
+
+	*zones_ptr = zones;
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_free_physical_zones() - Destroy the physical zones.
+ * @zones: The zones to free.
+ */
+void vdo_free_physical_zones(struct physical_zones *zones)
+{
+	zone_count_t index;
+
+	if (zones == NULL)
+		return;
+
+	for (index = 0; index < zones->zone_count; index++) {
+		struct physical_zone *zone = &zones->zones[index];
+
+		free_pbn_lock_pool(UDS_FORGET(zone->lock_pool));
+		vdo_free_int_map(UDS_FORGET(zone->pbn_operations));
+	}
+
+	UDS_FREE(zones);
+}
+
+/**
+ * vdo_get_physical_zone_pbn_lock() - Get the lock on a PBN if one exists.
+ * @zone: The physical zone responsible for the PBN.
+ * @pbn: The physical block number whose lock is desired.
+ *
+ * Return: The lock or NULL if the PBN is not locked.
+ */
+struct pbn_lock *
+vdo_get_physical_zone_pbn_lock(struct physical_zone *zone, physical_block_number_t pbn)
+{
+	return ((zone == NULL) ? NULL : vdo_int_map_get(zone->pbn_operations, pbn));
+}
+
+/**
+ * vdo_attempt_physical_zone_pbn_lock() - Attempt to lock a physical block in the zone responsible
+ *					  for it.
+ * @zone: The physical zone responsible for the PBN.
+ * @pbn: The physical block number to lock.
+ * @type: The type with which to initialize a new lock.
+ * @lock_ptr:  A pointer to receive the lock, existing or new.
+ *
+ * If the PBN is already locked, the existing lock will be returned. Otherwise, a new lock instance
+ * will be borrowed from the pool, initialized, and returned. The lock owner will be NULL for a new
+ * lock acquired by the caller, who is responsible for setting that field promptly. The lock owner
+ * will be non-NULL when there is already an existing lock on the PBN.
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+int vdo_attempt_physical_zone_pbn_lock(struct physical_zone *zone,
+				       physical_block_number_t pbn,
+				       enum pbn_lock_type type,
+				       struct pbn_lock **lock_ptr)
+{
+	/*
+	 * Borrow and prepare a lock from the pool so we don't have to do two int_map accesses in
+	 * the common case of no lock contention.
+	 */
+	struct pbn_lock *lock, *new_lock = NULL;
+	int result;
+
+	result = borrow_pbn_lock_from_pool(zone->lock_pool, type, &new_lock);
+	if (result != VDO_SUCCESS) {
+		ASSERT_LOG_ONLY(false, "must always be able to borrow a PBN lock");
+		return result;
+	}
+
+	result = vdo_int_map_put(zone->pbn_operations, pbn, new_lock, false, (void **) &lock);
+	if (result != VDO_SUCCESS) {
+		return_pbn_lock_to_pool(zone->lock_pool, new_lock);
+		return result;
+	}
+
+	if (lock != NULL) {
+		/* The lock is already held, so we don't need the borrowed one. */
+		return_pbn_lock_to_pool(zone->lock_pool, UDS_FORGET(new_lock));
+		result = ASSERT(lock->holder_count > 0,
+				"physical block %llu lock held",
+				(unsigned long long) pbn);
+		if (result != VDO_SUCCESS)
+			return result;
+		*lock_ptr = lock;
+	} else {
+		*lock_ptr = new_lock;
+	}
+	return VDO_SUCCESS;
+}
+
+/**
+ * allocate_and_lock_block() - Attempt to allocate a block from this zone.
+ * @allocation: The struct allocation of the data_vio attempting to allocate.
+ *
+ * If a block is allocated, the recipient will also hold a lock on it.
+ *
+ * Return: VDO_SUCCESS if a block was allocated, or an error code.
+ */
+static int allocate_and_lock_block(struct allocation *allocation)
+{
+	int result;
+	struct pbn_lock *lock;
+
+	ASSERT_LOG_ONLY(allocation->lock == NULL,
+			"must not allocate a block while already holding a lock on one");
+
+	result = vdo_allocate_block(allocation->zone->allocator, &allocation->pbn);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = vdo_attempt_physical_zone_pbn_lock(allocation->zone,
+						    allocation->pbn,
+						    allocation->write_lock_type,
+						    &lock);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	if (lock->holder_count > 0)
+		/* This block is already locked, which should be impossible. */
+		return uds_log_error_strerror(VDO_LOCK_ERROR,
+					      "Newly allocated block %llu was spuriously locked (holder_count=%u)",
+					      (unsigned long long) allocation->pbn,
+					      lock->holder_count);
+
+	/* We've successfully acquired a new lock, so mark it as ours. */
+	lock->holder_count += 1;
+	allocation->lock = lock;
+	vdo_assign_pbn_lock_provisional_reference(lock);
+	return VDO_SUCCESS;
+}
+
+/**
+ * retry_allocation() - Retry allocating a block now that we're done waiting for scrubbing.
+ * @waiter: The allocating_vio that was waiting to allocate.
+ * @context: The context (unused).
+ */
+static void retry_allocation(struct waiter *waiter, void *context __always_unused)
+{
+	struct data_vio *data_vio = waiter_as_data_vio(waiter);
+
+	/* Now that some slab has scrubbed, restart the allocation process. */
+	data_vio->allocation.wait_for_clean_slab = false;
+	data_vio->allocation.first_allocation_zone = data_vio->allocation.zone->zone_number;
+	continue_data_vio(data_vio);
+}
+
+/**
+ * continue_allocating() - Continue searching for an allocation by enqueuing to wait for scrubbing
+ *			   or switching to the next zone.
+ * @data_vio: The data_vio attempting to get an allocation.
+ *
+ * This method should only be called from the error handler set in data_vio_allocate_data_block.
+ *
+ * Return: true if the allocation process has continued in another zone.
+ */
+static bool continue_allocating(struct data_vio *data_vio)
+{
+	struct allocation *allocation = &data_vio->allocation;
+	struct physical_zone *zone = allocation->zone;
+	struct vdo_completion *completion = &data_vio->vio.completion;
+	int result = VDO_SUCCESS;
+	bool was_waiting = allocation->wait_for_clean_slab;
+	bool tried_all = (allocation->first_allocation_zone == zone->next->zone_number);
+
+	vdo_reset_completion(completion);
+
+	if (tried_all && !was_waiting) {
+		/*
+		 * We've already looked in all the zones, and found nothing. So go through the
+		 * zones again, and wait for each to scrub before trying to allocate.
+		 */
+		allocation->wait_for_clean_slab = true;
+		allocation->first_allocation_zone = zone->zone_number;
+	}
+
+	if (allocation->wait_for_clean_slab) {
+		data_vio->waiter.callback = retry_allocation;
+		result = vdo_enqueue_clean_slab_waiter(zone->allocator, &data_vio->waiter);
+		if (result == VDO_SUCCESS)
+			/* We've enqueued to wait for a slab to be scrubbed. */
+			return true;
+
+		if ((result != VDO_NO_SPACE) || (was_waiting && tried_all)) {
+			vdo_set_completion_result(completion, result);
+			return false;
+		}
+	}
+
+	allocation->zone = zone->next;
+	completion->callback_thread_id = allocation->zone->thread_id;
+	vdo_launch_completion(completion);
+	return true;
+}
+
+/**
+ * vdo_allocate_block_in_zone() - Attempt to allocate a block in the current physical zone, and if
+ *				  that fails try the next if possible.
+ * @data_vio: The data_vio needing an allocation.
+ *
+ * Return: true if a block was allocated, if not the data_vio will have been dispatched so the
+ *         caller must not touch it.
+ */
+bool vdo_allocate_block_in_zone(struct data_vio *data_vio)
+{
+	int result = allocate_and_lock_block(&data_vio->allocation);
+
+	if (result == VDO_SUCCESS)
+		return true;
+
+	if ((result != VDO_NO_SPACE) || !continue_allocating(data_vio))
+		continue_data_vio_with_error(data_vio, result);
+
+	return false;
+}
+
+/**
+ * vdo_release_physical_zone_pbn_lock() - Release a physical block lock if it is held and return it
+ *                                        to the lock pool.
+ * @zone: The physical zone in which the lock was obtained.
+ * @locked_pbn: The physical block number to unlock.
+ * @lock: The lock being released.
+ *
+ * It must be the last live reference, as if the memory were being freed (the
+ * lock memory will re-initialized or zeroed).
+ */
+void vdo_release_physical_zone_pbn_lock(struct physical_zone *zone,
+					physical_block_number_t locked_pbn,
+					struct pbn_lock *lock)
+{
+	struct pbn_lock *holder;
+
+	if (lock == NULL)
+		return;
+
+	ASSERT_LOG_ONLY(lock->holder_count > 0, "should not be releasing a lock that is not held");
+
+	lock->holder_count -= 1;
+	if (lock->holder_count > 0)
+		/* The lock was shared and is still referenced, so don't release it yet. */
+		return;
+
+	holder = vdo_int_map_remove(zone->pbn_operations, locked_pbn);
+	ASSERT_LOG_ONLY((lock == holder),
+			"physical block lock mismatch for block %llu",
+			(unsigned long long) locked_pbn);
+
+	release_pbn_lock_provisional_reference(lock, locked_pbn, zone->allocator);
+	return_pbn_lock_to_pool(zone->lock_pool, lock);
+}
+
+/**
+ * vdo_dump_physical_zone() - Dump information about a physical zone to the log for debugging.
+ * @zone: The zone to dump.
+ */
+void vdo_dump_physical_zone(const struct physical_zone *zone)
+{
+	vdo_dump_block_allocator(zone->allocator);
+}
diff --git a/drivers/md/dm-vdo/physical-zone.h b/drivers/md/dm-vdo/physical-zone.h
new file mode 100644
index 000000000000..ec693d54b488
--- /dev/null
+++ b/drivers/md/dm-vdo/physical-zone.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#ifndef VDO_PHYSICAL_ZONE_H
+#define VDO_PHYSICAL_ZONE_H
+
+#include <linux/atomic.h>
+
+#include "types.h"
+
+/*
+ * The type of a PBN lock.
+ */
+enum pbn_lock_type {
+	VIO_READ_LOCK,
+	VIO_WRITE_LOCK,
+	VIO_BLOCK_MAP_WRITE_LOCK,
+};
+
+struct pbn_lock_implementation;
+
+/*
+ * A PBN lock.
+ */
+struct pbn_lock {
+	/* The implementation of the lock */
+	const struct pbn_lock_implementation *implementation;
+
+	/* The number of VIOs holding or sharing this lock */
+	data_vio_count_t holder_count;
+	/*
+	 * The number of compressed block writers holding a share of this lock while they are
+	 * acquiring a reference to the PBN.
+	 */
+	u8 fragment_locks;
+
+	/* Whether the locked PBN has been provisionally referenced on behalf of the lock holder. */
+	bool has_provisional_reference;
+
+	/*
+	 * For read locks, the number of references that were known to be available on the locked
+	 * block at the time the lock was acquired.
+	 */
+	u8 increment_limit;
+
+	/*
+	 * For read locks, the number of data_vios that have tried to claim one of the available
+	 * increments during the lifetime of the lock. Each claim will first increment this
+	 * counter, so it can exceed the increment limit.
+	 */
+	atomic_t increments_claimed;
+};
+
+struct physical_zone {
+	/* Which physical zone this is */
+	zone_count_t zone_number;
+	/* The thread ID for this zone */
+	thread_id_t thread_id;
+	/* In progress operations keyed by PBN */
+	struct int_map *pbn_operations;
+	/* Pool of unused pbn_lock instances */
+	struct pbn_lock_pool *lock_pool;
+	/* The block allocator for this zone */
+	struct block_allocator *allocator;
+	/* The next zone from which to attempt an allocation */
+	struct physical_zone *next;
+};
+
+struct physical_zones {
+	/* The number of zones */
+	zone_count_t zone_count;
+	/* The physical zones themselves */
+	struct physical_zone zones[];
+};
+
+bool __must_check vdo_is_pbn_read_lock(const struct pbn_lock *lock);
+void vdo_downgrade_pbn_write_lock(struct pbn_lock *lock, bool compressed_write);
+bool __must_check vdo_claim_pbn_lock_increment(struct pbn_lock *lock);
+
+/**
+ * vdo_pbn_lock_has_provisional_reference() - Check whether a PBN lock has a provisional reference.
+ * @lock: The PBN lock.
+ */
+static inline bool vdo_pbn_lock_has_provisional_reference(struct pbn_lock *lock)
+{
+	return ((lock != NULL) && lock->has_provisional_reference);
+}
+
+void vdo_assign_pbn_lock_provisional_reference(struct pbn_lock *lock);
+void vdo_unassign_pbn_lock_provisional_reference(struct pbn_lock *lock);
+
+int __must_check vdo_make_physical_zones(struct vdo *vdo, struct physical_zones **zones_ptr);
+
+void vdo_free_physical_zones(struct physical_zones *zones);
+
+struct pbn_lock * __must_check
+vdo_get_physical_zone_pbn_lock(struct physical_zone *zone, physical_block_number_t pbn);
+
+int __must_check
+vdo_attempt_physical_zone_pbn_lock(struct physical_zone *zone,
+				   physical_block_number_t pbn,
+				   enum pbn_lock_type type,
+				   struct pbn_lock **lock_ptr);
+
+bool __must_check vdo_allocate_block_in_zone(struct data_vio *data_vio);
+
+void vdo_release_physical_zone_pbn_lock(struct physical_zone *zone,
+					physical_block_number_t locked_pbn,
+					struct pbn_lock *lock);
+
+void vdo_dump_physical_zone(const struct physical_zone *zone);
+
+#endif /* VDO_PHYSICAL_ZONE_H */
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index e2270319513a..dbed9c3c8a62 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -37,6 +37,13 @@
 static const u64 BYTES_PER_WORD = sizeof(u64);
 static const bool NORMAL_OPERATION = true;
 
+struct slab_journal_eraser {
+	struct vdo_completion *parent;
+	struct dm_kcopyd_client *client;
+	block_count_t blocks;
+	struct slab_iterator slabs;
+};
+
 /**
  * get_lock() - Get the lock object for a slab journal block by sequence number.
  * @journal: vdo_slab journal to retrieve from.
@@ -1972,6 +1979,44 @@ static bool advance_search_cursor(struct vdo_slab *slab)
 	return true;
 }
 
+/**
+ * vdo_adjust_reference_count_for_rebuild() - Adjust the reference count of a block during rebuild.
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+int vdo_adjust_reference_count_for_rebuild(struct slab_depot *depot,
+					   physical_block_number_t pbn,
+					   enum journal_operation operation)
+{
+	int result;
+	slab_block_number block_number;
+	struct reference_block *block;
+	struct vdo_slab *slab = vdo_get_slab(depot, pbn);
+	struct reference_updater updater = {
+		.operation = operation,
+		.increment = true,
+	};
+
+	result = slab_block_number_from_pbn(slab, pbn, &block_number);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	block = get_reference_block(slab, block_number);
+	result = update_reference_count(slab,
+					block,
+					block_number,
+					NULL,
+					&updater,
+					!NORMAL_OPERATION,
+					false,
+					NULL);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	dirty_block(block);
+	return VDO_SUCCESS;
+}
+
 /**
  * replay_reference_count_change() - Replay the reference count adjustment from a slab journal
  *                                   entry into the reference count for a block.
@@ -2529,6 +2574,1113 @@ static void load_slab_journal(struct vdo_slab *slab)
 	acquire_vio_from_pool(slab->allocator->vio_pool, &journal->resource_waiter);
 }
 
+static void register_slab_for_scrubbing(struct vdo_slab *slab, bool high_priority)
+{
+	struct slab_scrubber *scrubber = &slab->allocator->scrubber;
+
+	ASSERT_LOG_ONLY((slab->status != VDO_SLAB_REBUILT), "slab to be scrubbed is unrecovered");
+
+	if (slab->status != VDO_SLAB_REQUIRES_SCRUBBING)
+		return;
+
+	list_del_init(&slab->allocq_entry);
+	if (!slab->was_queued_for_scrubbing) {
+		WRITE_ONCE(scrubber->slab_count, scrubber->slab_count + 1);
+		slab->was_queued_for_scrubbing = true;
+	}
+
+	if (high_priority) {
+		slab->status = VDO_SLAB_REQUIRES_HIGH_PRIORITY_SCRUBBING;
+		list_add_tail(&slab->allocq_entry, &scrubber->high_priority_slabs);
+		return;
+	}
+
+	list_add_tail(&slab->allocq_entry, &scrubber->slabs);
+}
+
+/* Queue a slab for allocation or scrubbing. */
+static void queue_slab(struct vdo_slab *slab)
+{
+	struct block_allocator *allocator = slab->allocator;
+	block_count_t free_blocks;
+	int result;
+
+	ASSERT_LOG_ONLY(list_empty(&slab->allocq_entry),
+			"a requeued slab must not already be on a ring");
+
+	if (vdo_is_read_only(allocator->depot->vdo))
+		return;
+
+	free_blocks = slab->free_blocks;
+	result = ASSERT((free_blocks <= allocator->depot->slab_config.data_blocks),
+			"rebuilt slab %u must have a valid free block count (has %llu, expected maximum %llu)",
+			slab->slab_number,
+			(unsigned long long) free_blocks,
+			(unsigned long long) allocator->depot->slab_config.data_blocks);
+	if (result != VDO_SUCCESS) {
+		vdo_enter_read_only_mode(allocator->depot->vdo, result);
+		return;
+	}
+
+	if (slab->status != VDO_SLAB_REBUILT) {
+		register_slab_for_scrubbing(slab, false);
+		return;
+	}
+
+	if (!vdo_is_state_resuming(&slab->state)) {
+		/*
+		 * If the slab is resuming, we've already accounted for it here, so don't do it
+		 * again.
+		 * FIXME: under what situation would the slab be resuming here?
+		 */
+		WRITE_ONCE(allocator->allocated_blocks, allocator->allocated_blocks - free_blocks);
+		if (!is_slab_journal_blank(slab))
+			WRITE_ONCE(allocator->statistics.slabs_opened,
+				   allocator->statistics.slabs_opened + 1);
+	}
+
+	if (allocator->depot->vdo->suspend_type == VDO_ADMIN_STATE_SAVING)
+		reopen_slab_journal(slab);
+
+	prioritize_slab(slab);
+}
+
+/**
+ * initiate_slab_action() - Initiate a slab action.
+ *
+ * Implements vdo_admin_initiator.
+ */
+static void initiate_slab_action(struct admin_state *state)
+{
+	struct vdo_slab *slab = container_of(state, struct vdo_slab, state);
+
+	if (vdo_is_state_draining(state)) {
+		const struct admin_state_code *operation = vdo_get_admin_state_code(state);
+
+		if (operation == VDO_ADMIN_STATE_SCRUBBING)
+			slab->status = VDO_SLAB_REBUILDING;
+
+		drain_slab(slab);
+		check_if_slab_drained(slab);
+		return;
+	}
+
+	if (vdo_is_state_loading(state)) {
+		load_slab_journal(slab);
+		return;
+	}
+
+	if (vdo_is_state_resuming(state)) {
+		queue_slab(slab);
+		vdo_finish_resuming(state);
+		return;
+	}
+
+	vdo_finish_operation(state, VDO_INVALID_ADMIN_STATE);
+}
+
+/**
+ * get_next_slab() - Get the next slab to scrub.
+ * @scrubber: The slab scrubber.
+ *
+ * Return: The next slab to scrub or NULL if there are none.
+ */
+static struct vdo_slab *get_next_slab(struct slab_scrubber *scrubber)
+{
+	struct vdo_slab *slab;
+
+	slab = list_first_entry_or_null(&scrubber->high_priority_slabs,
+					struct vdo_slab,
+					allocq_entry);
+	if (slab != NULL)
+		return slab;
+
+	return list_first_entry_or_null(&scrubber->slabs, struct vdo_slab, allocq_entry);
+}
+
+/**
+ * has_slabs_to_scrub() - Check whether a scrubber has slabs to scrub.
+ * @scrubber: The scrubber to check.
+ *
+ * Return: true if the scrubber has slabs to scrub.
+ */
+static bool __must_check has_slabs_to_scrub(struct slab_scrubber *scrubber)
+{
+	return (get_next_slab(scrubber) != NULL);
+}
+
+/**
+ * uninitialize_scrubber_vio() - Clean up the slab_scrubber's vio.
+ * @scrubber: The scrubber.
+ */
+static void uninitialize_scrubber_vio(struct slab_scrubber *scrubber)
+{
+	UDS_FREE(UDS_FORGET(scrubber->vio.data));
+	free_vio_components(&scrubber->vio);
+}
+
+/**
+ * finish_scrubbing() - Stop scrubbing, either because there are no more slabs to scrub or because
+ *                      there's been an error.
+ * @scrubber: The scrubber.
+ */
+static void finish_scrubbing(struct slab_scrubber *scrubber, int result)
+{
+	bool notify = vdo_has_waiters(&scrubber->waiters);
+	bool done = !has_slabs_to_scrub(scrubber);
+	struct block_allocator *allocator =
+		container_of(scrubber, struct block_allocator, scrubber);
+
+	if (done)
+		uninitialize_scrubber_vio(scrubber);
+
+	if (scrubber->high_priority_only) {
+		scrubber->high_priority_only = false;
+		vdo_fail_completion(UDS_FORGET(scrubber->vio.completion.parent), result);
+	} else if (done && (atomic_add_return(-1, &allocator->depot->zones_to_scrub) == 0)) {
+		/* All of our slabs were scrubbed, and we're the last allocator to finish. */
+		enum vdo_state prior_state =
+			atomic_cmpxchg(&allocator->depot->vdo->state, VDO_RECOVERING, VDO_DIRTY);
+
+		/*
+		 * To be safe, even if the CAS failed, ensure anything that follows is ordered with
+		 * respect to whatever state change did happen.
+		 */
+		smp_mb__after_atomic();
+
+		/*
+		 * We must check the VDO state here and not the depot's read_only_notifier since
+		 * the compare-swap-above could have failed due to a read-only entry which our own
+		 * thread does not yet know about.
+		 */
+		if (prior_state == VDO_DIRTY)
+			uds_log_info("VDO commencing normal operation");
+		else if (prior_state == VDO_RECOVERING)
+			uds_log_info("Exiting recovery mode");
+	}
+
+	/*
+	 * Note that the scrubber has stopped, and inform anyone who might be waiting for that to
+	 * happen.
+	 */
+	if (!vdo_finish_draining(&scrubber->admin_state))
+		WRITE_ONCE(scrubber->admin_state.current_state, VDO_ADMIN_STATE_SUSPENDED);
+
+	/*
+	 * We can't notify waiters until after we've finished draining or they'll just requeue.
+	 * Fortunately if there were waiters, we can't have been freed yet.
+	 */
+	if (notify)
+		vdo_notify_all_waiters(&scrubber->waiters, NULL, NULL);
+}
+
+static void scrub_next_slab(struct slab_scrubber *scrubber);
+
+/**
+ * slab_scrubbed() - Notify the scrubber that a slab has been scrubbed.
+ * @completion: The slab rebuild completion.
+ *
+ * This callback is registered in apply_journal_entries().
+ */
+static void slab_scrubbed(struct vdo_completion *completion)
+{
+	struct slab_scrubber *scrubber =
+		container_of(as_vio(completion), struct slab_scrubber, vio);
+	struct vdo_slab *slab = scrubber->slab;
+
+	slab->status = VDO_SLAB_REBUILT;
+	queue_slab(slab);
+	reopen_slab_journal(slab);
+	WRITE_ONCE(scrubber->slab_count, scrubber->slab_count - 1);
+	scrub_next_slab(scrubber);
+}
+
+/**
+ * abort_scrubbing() - Abort scrubbing due to an error.
+ * @scrubber: The slab scrubber.
+ * @result: The error.
+ */
+static void abort_scrubbing(struct slab_scrubber *scrubber, int result)
+{
+	vdo_enter_read_only_mode(scrubber->vio.completion.vdo, result);
+	finish_scrubbing(scrubber, result);
+}
+
+/**
+ * handle_scrubber_error() - Handle errors while rebuilding a slab.
+ * @completion: The slab rebuild completion.
+ */
+static void handle_scrubber_error(struct vdo_completion *completion)
+{
+	struct vio *vio = as_vio(completion);
+
+	vio_record_metadata_io_error(vio);
+	abort_scrubbing(container_of(vio, struct slab_scrubber, vio), completion->result);
+}
+
+/**
+ * apply_block_entries() - Apply all the entries in a block to the reference counts.
+ * @block: A block with entries to apply.
+ * @entry_count: The number of entries to apply.
+ * @block_number: The sequence number of the block.
+ * @slab: The slab to apply the entries to.
+ *
+ * Return: VDO_SUCCESS or an error code.
+ */
+static int apply_block_entries(struct packed_slab_journal_block *block,
+			       journal_entry_count_t entry_count,
+			       sequence_number_t block_number,
+			       struct vdo_slab *slab)
+{
+	struct journal_point entry_point = {
+		.sequence_number = block_number,
+		.entry_count = 0,
+	};
+	int result;
+	slab_block_number max_sbn = slab->end - slab->start;
+
+	while (entry_point.entry_count < entry_count) {
+		struct slab_journal_entry entry =
+			vdo_decode_slab_journal_entry(block, entry_point.entry_count);
+
+		if (entry.sbn > max_sbn)
+			/* This entry is out of bounds. */
+			return uds_log_error_strerror(VDO_CORRUPT_JOURNAL,
+						      "vdo_slab journal entry (%llu, %u) had invalid offset %u in slab (size %u blocks)",
+						      (unsigned long long) block_number,
+						      entry_point.entry_count,
+						      entry.sbn,
+						      max_sbn);
+
+		result = replay_reference_count_change(slab, &entry_point, entry);
+		if (result != VDO_SUCCESS) {
+			uds_log_error_strerror(result,
+					       "vdo_slab journal entry (%llu, %u) (%s of offset %u) could not be applied in slab %u",
+					       (unsigned long long) block_number,
+					       entry_point.entry_count,
+					       vdo_get_journal_operation_name(entry.operation),
+					       entry.sbn,
+					       slab->slab_number);
+			return result;
+		}
+		entry_point.entry_count++;
+	}
+
+	return VDO_SUCCESS;
+}
+
+/**
+ * apply_journal_entries() - Find the relevant vio of the slab journal and apply all valid entries.
+ * @completion: The metadata read vio completion.
+ *
+ * This is a callback registered in start_scrubbing().
+ */
+static void apply_journal_entries(struct vdo_completion *completion)
+{
+	int result;
+	struct slab_scrubber *scrubber
+		= container_of(as_vio(completion), struct slab_scrubber, vio);
+	struct vdo_slab *slab = scrubber->slab;
+	struct slab_journal *journal = &slab->journal;
+
+	/* Find the boundaries of the useful part of the journal. */
+	sequence_number_t tail = journal->tail;
+	tail_block_offset_t end_index = (tail - 1) % journal->size;
+	char *end_data = scrubber->vio.data + (end_index * VDO_BLOCK_SIZE);
+	struct packed_slab_journal_block *end_block =
+		(struct packed_slab_journal_block *) end_data;
+
+	sequence_number_t head = __le64_to_cpu(end_block->header.head);
+	tail_block_offset_t head_index = head % journal->size;
+	block_count_t index = head_index;
+
+	struct journal_point ref_counts_point = slab->slab_journal_point;
+	struct journal_point last_entry_applied = ref_counts_point;
+	sequence_number_t sequence;
+
+	for (sequence = head; sequence < tail; sequence++) {
+		char *block_data = scrubber->vio.data + (index * VDO_BLOCK_SIZE);
+		struct packed_slab_journal_block *block =
+			(struct packed_slab_journal_block *) block_data;
+		struct slab_journal_block_header header;
+
+		vdo_unpack_slab_journal_block_header(&block->header, &header);
+
+		if ((header.nonce != slab->allocator->nonce) ||
+		    (header.metadata_type != VDO_METADATA_SLAB_JOURNAL) ||
+		    (header.sequence_number != sequence) ||
+		    (header.entry_count > journal->entries_per_block) ||
+		    (header.has_block_map_increments &&
+		     (header.entry_count > journal->full_entries_per_block))) {
+			/* The block is not what we expect it to be. */
+			uds_log_error("vdo_slab journal block for slab %u was invalid",
+				      slab->slab_number);
+			abort_scrubbing(scrubber, VDO_CORRUPT_JOURNAL);
+			return;
+		}
+
+		result = apply_block_entries(block, header.entry_count, sequence, slab);
+		if (result != VDO_SUCCESS) {
+			abort_scrubbing(scrubber, result);
+			return;
+		}
+
+		last_entry_applied.sequence_number = sequence;
+		last_entry_applied.entry_count = header.entry_count - 1;
+		index++;
+		if (index == journal->size)
+			index = 0;
+	}
+
+	/*
+	 * At the end of rebuild, the reference counters should be accurate to the end of the
+	 * journal we just applied.
+	 */
+	result = ASSERT(!vdo_before_journal_point(&last_entry_applied, &ref_counts_point),
+			"Refcounts are not more accurate than the slab journal");
+	if (result != VDO_SUCCESS) {
+		abort_scrubbing(scrubber, result);
+		return;
+	}
+
+	/* Save out the rebuilt reference blocks. */
+	vdo_prepare_completion(completion,
+			       slab_scrubbed,
+			       handle_scrubber_error,
+			       slab->allocator->thread_id,
+			       completion->parent);
+	vdo_start_operation_with_waiter(&slab->state,
+					VDO_ADMIN_STATE_SAVE_FOR_SCRUBBING,
+					completion,
+					initiate_slab_action);
+}
+
+static void read_slab_journal_endio(struct bio *bio)
+{
+	struct vio *vio = bio->bi_private;
+	struct slab_scrubber *scrubber = container_of(vio, struct slab_scrubber, vio);
+
+	continue_vio_after_io(bio->bi_private,
+			      apply_journal_entries,
+			      scrubber->slab->allocator->thread_id);
+}
+
+/**
+ * start_scrubbing() - Read the current slab's journal from disk now that it has been flushed.
+ * @completion: The scrubber's vio completion.
+ *
+ * This callback is registered in scrub_next_slab().
+ */
+static void start_scrubbing(struct vdo_completion *completion)
+{
+	struct slab_scrubber *scrubber =
+		container_of(as_vio(completion), struct slab_scrubber, vio);
+	struct vdo_slab *slab = scrubber->slab;
+
+	if (!slab->allocator->summary_entries[slab->slab_number].is_dirty) {
+		slab_scrubbed(completion);
+		return;
+	}
+
+	submit_metadata_vio(&scrubber->vio,
+			    slab->journal_origin,
+			    read_slab_journal_endio,
+			    handle_scrubber_error,
+			    REQ_OP_READ);
+}
+
+/**
+ * scrub_next_slab() - Scrub the next slab if there is one.
+ * @scrubber: The scrubber.
+ */
+static void scrub_next_slab(struct slab_scrubber *scrubber)
+{
+	struct vdo_completion *completion = &scrubber->vio.completion;
+	struct vdo_slab *slab;
+
+	/*
+	 * Note: this notify call is always safe only because scrubbing can only be started when
+	 * the VDO is quiescent.
+	 */
+	vdo_notify_all_waiters(&scrubber->waiters, NULL, NULL);
+
+	if (vdo_is_read_only(completion->vdo)) {
+		finish_scrubbing(scrubber, VDO_READ_ONLY);
+		return;
+	}
+
+	slab = get_next_slab(scrubber);
+	if ((slab == NULL) ||
+	    (scrubber->high_priority_only && list_empty(&scrubber->high_priority_slabs))) {
+		finish_scrubbing(scrubber, VDO_SUCCESS);
+		return;
+	}
+
+	if (vdo_finish_draining(&scrubber->admin_state))
+		return;
+
+	list_del_init(&slab->allocq_entry);
+	scrubber->slab = slab;
+	vdo_prepare_completion(completion,
+			       start_scrubbing,
+			       handle_scrubber_error,
+			       slab->allocator->thread_id,
+			       completion->parent);
+	vdo_start_operation_with_waiter(&slab->state,
+					VDO_ADMIN_STATE_SCRUBBING,
+					completion,
+					initiate_slab_action);
+}
+
+/**
+ * scrub_slabs() - Scrub all of an allocator's slabs that are eligible for scrubbing.
+ * @allocator: The block_allocator to scrub.
+ * @parent: The completion to notify when scrubbing is done, implies high_priority, may be NULL.
+ */
+static void scrub_slabs(struct block_allocator *allocator, struct vdo_completion *parent)
+{
+	struct slab_scrubber *scrubber = &allocator->scrubber;
+
+	scrubber->vio.completion.parent = parent;
+	scrubber->high_priority_only = (parent != NULL);
+	if (!has_slabs_to_scrub(scrubber)) {
+		finish_scrubbing(scrubber, VDO_SUCCESS);
+		return;
+	}
+
+	if (scrubber->high_priority_only &&
+	    vdo_is_priority_table_empty(allocator->prioritized_slabs) &&
+	    list_empty(&scrubber->high_priority_slabs))
+		register_slab_for_scrubbing(get_next_slab(scrubber), true);
+
+	vdo_resume_if_quiescent(&scrubber->admin_state);
+	scrub_next_slab(scrubber);
+}
+
+static inline void assert_on_allocator_thread(thread_id_t thread_id, const char *function_name)
+{
+	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == thread_id),
+			"%s called on correct thread",
+			function_name);
+}
+
+static void register_slab_with_allocator(struct block_allocator *allocator, struct vdo_slab *slab)
+{
+	allocator->slab_count++;
+	allocator->last_slab = slab->slab_number;
+}
+
+static struct slab_iterator get_slab_iterator(const struct block_allocator *allocator)
+{
+	return get_depot_slab_iterator(allocator->depot,
+				       allocator->last_slab,
+				       allocator->zone_number,
+				       allocator->depot->zone_count);
+}
+
+/**
+ * next_slab() - Get the next slab from a slab_iterator and advance the iterator
+ * @iterator: The slab_iterator.
+ *
+ * Return: The next slab or NULL if the iterator is exhausted.
+ */
+static struct vdo_slab *next_slab(struct slab_iterator *iterator)
+{
+	struct vdo_slab *slab = iterator->next;
+
+	if ((slab == NULL) || (slab->slab_number < iterator->end + iterator->stride))
+		iterator->next = NULL;
+	else
+		iterator->next = iterator->slabs[slab->slab_number - iterator->stride];
+
+	return slab;
+}
+
+/**
+ * abort_waiter() - Abort vios waiting to make journal entries when read-only.
+ *
+ * This callback is invoked on all vios waiting to make slab journal entries after the VDO has gone
+ * into read-only mode. Implements waiter_callback.
+ */
+static void abort_waiter(struct waiter *waiter, void *context __always_unused)
+{
+	struct reference_updater *updater = container_of(waiter, struct reference_updater, waiter);
+	struct data_vio *data_vio = data_vio_from_reference_updater(updater);
+
+	if (updater->increment) {
+		continue_data_vio_with_error(data_vio, VDO_READ_ONLY);
+		return;
+	}
+
+	vdo_continue_completion(&data_vio->decrement_completion, VDO_READ_ONLY);
+}
+
+/* Implements vdo_read_only_notification. */
+static void notify_block_allocator_of_read_only_mode(void *listener, struct vdo_completion *parent)
+{
+	struct block_allocator *allocator = listener;
+	struct slab_iterator iterator;
+
+	assert_on_allocator_thread(allocator->thread_id, __func__);
+	iterator = get_slab_iterator(allocator);
+	while (iterator.next != NULL) {
+		struct vdo_slab *slab = next_slab(&iterator);
+
+		vdo_notify_all_waiters(&slab->journal.entry_waiters, abort_waiter, &slab->journal);
+		check_if_slab_drained(slab);
+	}
+
+	vdo_finish_completion(parent);
+}
+
+/**
+ * vdo_acquire_provisional_reference() - Acquire a provisional reference on behalf of a PBN lock if
+ *                                       the block it locks is unreferenced.
+ * @slab: The slab which contains the block.
+ * @pbn: The physical block to reference.
+ * @lock: The lock.
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+int vdo_acquire_provisional_reference(struct vdo_slab *slab,
+				      physical_block_number_t pbn,
+				      struct pbn_lock *lock)
+{
+	slab_block_number block_number;
+	int result;
+
+	if (vdo_pbn_lock_has_provisional_reference(lock))
+		return VDO_SUCCESS;
+
+	if (!is_slab_open(slab))
+		return VDO_INVALID_ADMIN_STATE;
+
+	result = slab_block_number_from_pbn(slab, pbn, &block_number);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	if (slab->counters[block_number] == EMPTY_REFERENCE_COUNT) {
+		make_provisional_reference(slab, block_number);
+		if (lock != NULL)
+			vdo_assign_pbn_lock_provisional_reference(lock);
+	}
+
+	if (vdo_pbn_lock_has_provisional_reference(lock))
+		adjust_free_block_count(slab, false);
+
+	return VDO_SUCCESS;
+}
+
+static int __must_check
+allocate_slab_block(struct vdo_slab *slab, physical_block_number_t *block_number_ptr)
+{
+	slab_block_number free_index;
+
+	if (!is_slab_open(slab))
+		return VDO_INVALID_ADMIN_STATE;
+
+	if (!search_reference_blocks(slab, &free_index))
+		return VDO_NO_SPACE;
+
+	ASSERT_LOG_ONLY((slab->counters[free_index] == EMPTY_REFERENCE_COUNT),
+			"free block must have ref count of zero");
+	make_provisional_reference(slab, free_index);
+	adjust_free_block_count(slab, false);
+
+	/*
+	 * Update the search hint so the next search will start at the array index just past the
+	 * free block we just found.
+	 */
+	slab->search_cursor.index = (free_index + 1);
+
+	*block_number_ptr = slab->start + free_index;
+	return VDO_SUCCESS;
+}
+
+/**
+ * open_slab() - Prepare a slab to be allocated from.
+ * @slab: The slab.
+ */
+static void open_slab(struct vdo_slab *slab)
+{
+	reset_search_cursor(slab);
+	if (is_slab_journal_blank(slab)) {
+		WRITE_ONCE(slab->allocator->statistics.slabs_opened,
+			   slab->allocator->statistics.slabs_opened + 1);
+		dirty_all_reference_blocks(slab);
+	} else {
+		WRITE_ONCE(slab->allocator->statistics.slabs_reopened,
+			   slab->allocator->statistics.slabs_reopened + 1);
+	}
+
+	slab->allocator->open_slab = slab;
+}
+
+
+/*
+ * The block allocated will have a provisional reference and the reference must be either confirmed
+ * with a subsequent increment or vacated with a subsequent decrement via
+ * vdo_release_block_reference().
+ */
+int vdo_allocate_block(struct block_allocator *allocator,
+		       physical_block_number_t *block_number_ptr)
+{
+	int result;
+
+	if (allocator->open_slab != NULL) {
+		/* Try to allocate the next block in the currently open slab. */
+		result = allocate_slab_block(allocator->open_slab, block_number_ptr);
+		if ((result == VDO_SUCCESS) || (result != VDO_NO_SPACE))
+			return result;
+
+		/* Put the exhausted open slab back into the priority table. */
+		prioritize_slab(allocator->open_slab);
+	}
+
+	/* Remove the highest priority slab from the priority table and make it the open slab. */
+	open_slab(list_entry(vdo_priority_table_dequeue(allocator->prioritized_slabs),
+			     struct vdo_slab,
+			     allocq_entry));
+
+	/*
+	 * Try allocating again. If we're out of space immediately after opening a slab, then every
+	 * slab must be fully allocated.
+	 */
+	return allocate_slab_block(allocator->open_slab, block_number_ptr);
+}
+
+/**
+ * vdo_enqueue_clean_slab_waiter() - Wait for a clean slab.
+ * @allocator: The block_allocator on which to wait.
+ * @waiter: The waiter.
+ *
+ * Return: VDO_SUCCESS if the waiter was queued, VDO_NO_SPACE if there are no slabs to scrub, and
+ *         some other error otherwise.
+ */
+int vdo_enqueue_clean_slab_waiter(struct block_allocator *allocator, struct waiter *waiter)
+{
+	if (vdo_is_read_only(allocator->depot->vdo))
+		return VDO_READ_ONLY;
+
+	if (vdo_is_state_quiescent(&allocator->scrubber.admin_state))
+		return VDO_NO_SPACE;
+
+	vdo_enqueue_waiter(&allocator->scrubber.waiters, waiter);
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_modify_reference_count() - Modify the reference count of a block by first making a slab
+ *                                journal entry and then updating the reference counter.
+ *
+ * @data_vio: The data_vio for which to add the entry.
+ * @updater: Which of the data_vio's reference updaters is being submitted.
+ */
+void vdo_modify_reference_count(struct vdo_completion *completion,
+				struct reference_updater *updater)
+{
+	struct vdo_slab *slab = vdo_get_slab(completion->vdo->depot, updater->zpbn.pbn);
+
+	if (!is_slab_open(slab)) {
+		vdo_continue_completion(completion, VDO_INVALID_ADMIN_STATE);
+		return;
+	}
+
+	if (vdo_is_read_only(completion->vdo)) {
+		vdo_continue_completion(completion, VDO_READ_ONLY);
+		return;
+	}
+
+	vdo_enqueue_waiter(&slab->journal.entry_waiters, &updater->waiter);
+	if ((slab->status != VDO_SLAB_REBUILT) && requires_reaping(&slab->journal))
+		register_slab_for_scrubbing(slab, true);
+
+	add_entries(&slab->journal);
+}
+
+/* Release an unused provisional reference. */
+int vdo_release_block_reference(struct block_allocator *allocator, physical_block_number_t pbn)
+{
+	struct reference_updater updater;
+
+	if (pbn == VDO_ZERO_BLOCK)
+		return VDO_SUCCESS;
+
+	updater = (struct reference_updater) {
+		.operation = VDO_JOURNAL_DATA_REMAPPING,
+		.increment = false,
+		.zpbn = {
+			.pbn = pbn,
+		},
+	};
+
+	return adjust_reference_count(vdo_get_slab(allocator->depot, pbn), &updater, NULL);
+}
+
+/*
+ * This is a min_heap callback function orders slab_status structures using the 'is_clean' field as
+ * the primary key and the 'emptiness' field as the secondary key.
+ *
+ * Slabs need to be pushed onto the rings in the same order they are to be popped off. Popping
+ * should always get the most empty first, so pushing should be from most empty to least empty.
+ * Thus, the ordering is reversed from the usual sense since min_heap returns smaller elements
+ * before larger ones.
+ */
+static bool slab_status_is_less_than(const void *item1, const void *item2)
+{
+	const struct slab_status *info1 = (const struct slab_status *) item1;
+	const struct slab_status *info2 = (const struct slab_status *) item2;
+
+	if (info1->is_clean != info2->is_clean)
+		return info1->is_clean;
+	if (info1->emptiness != info2->emptiness)
+		return info1->emptiness > info2->emptiness;
+	return info1->slab_number < info2->slab_number;
+}
+
+static void swap_slab_statuses(void *item1, void *item2)
+{
+	struct slab_status *info1 = item1;
+	struct slab_status *info2 = item2;
+
+	swap(*info1, *info2);
+}
+
+static const struct min_heap_callbacks slab_status_min_heap = {
+	.elem_size = sizeof(struct slab_status),
+	.less = slab_status_is_less_than,
+	.swp = swap_slab_statuses,
+};
+
+/* Inform the slab actor that a action has finished on some slab; used by apply_to_slabs(). */
+static void slab_action_callback(struct vdo_completion *completion)
+{
+	struct block_allocator *allocator = vdo_as_block_allocator(completion);
+	struct slab_actor *actor = &allocator->slab_actor;
+
+	if (--actor->slab_action_count == 0) {
+		actor->callback(completion);
+		return;
+	}
+
+	vdo_reset_completion(completion);
+}
+
+/* Preserve the error from part of an action and continue. */
+static void handle_operation_error(struct vdo_completion *completion)
+{
+	struct block_allocator *allocator = vdo_as_block_allocator(completion);
+
+	if (allocator->state.waiter != NULL)
+		vdo_set_completion_result(allocator->state.waiter, completion->result);
+	completion->callback(completion);
+}
+
+/* Perform an action on each of an allocator's slabs in parallel. */
+static void apply_to_slabs(struct block_allocator *allocator, vdo_action *callback)
+{
+	struct slab_iterator iterator;
+
+	vdo_prepare_completion(&allocator->completion,
+			       slab_action_callback,
+			       handle_operation_error,
+			       allocator->thread_id,
+			       NULL);
+	allocator->completion.requeue = false;
+
+	/*
+	 * Since we are going to dequeue all of the slabs, the open slab will become invalid, so
+	 * clear it.
+	 */
+	allocator->open_slab = NULL;
+
+	/* Ensure that we don't finish before we're done starting. */
+	allocator->slab_actor = (struct slab_actor) {
+		.slab_action_count = 1,
+		.callback = callback,
+	};
+
+	iterator = get_slab_iterator(allocator);
+	while (iterator.next != NULL) {
+		const struct admin_state_code *operation =
+			vdo_get_admin_state_code(&allocator->state);
+		struct vdo_slab *slab = next_slab(&iterator);
+
+		list_del_init(&slab->allocq_entry);
+		allocator->slab_actor.slab_action_count++;
+		vdo_start_operation_with_waiter(&slab->state,
+						operation,
+						&allocator->completion,
+						initiate_slab_action);
+	}
+
+	slab_action_callback(&allocator->completion);
+}
+
+static void finish_loading_allocator(struct vdo_completion *completion)
+{
+	struct block_allocator *allocator = vdo_as_block_allocator(completion);
+	const struct admin_state_code *operation = vdo_get_admin_state_code(&allocator->state);
+
+	if (allocator->eraser != NULL)
+		dm_kcopyd_client_destroy(UDS_FORGET(allocator->eraser));
+
+	if (operation == VDO_ADMIN_STATE_LOADING_FOR_RECOVERY) {
+		void *context = vdo_get_current_action_context(allocator->depot->action_manager);
+
+		vdo_replay_into_slab_journals(allocator, context);
+		return;
+	}
+
+	vdo_finish_loading(&allocator->state);
+}
+
+static void erase_next_slab_journal(struct block_allocator *allocator);
+
+static void copy_callback(int read_err, unsigned long write_err, void *context)
+{
+	struct block_allocator *allocator = context;
+	int result = (((read_err == 0) && (write_err == 0)) ? VDO_SUCCESS : -EIO);
+
+	if (result != VDO_SUCCESS) {
+		vdo_fail_completion(&allocator->completion, result);
+		return;
+	}
+
+	erase_next_slab_journal(allocator);
+}
+
+/* erase_next_slab_journal() - Erase the next slab journal. */
+static void erase_next_slab_journal(struct block_allocator *allocator)
+{
+	struct vdo_slab *slab;
+	physical_block_number_t pbn;
+	struct dm_io_region regions[1];
+	struct slab_depot *depot = allocator->depot;
+	block_count_t blocks = depot->slab_config.slab_journal_blocks;
+
+	if (allocator->slabs_to_erase.next == NULL) {
+		vdo_finish_completion(&allocator->completion);
+		return;
+	}
+
+	slab = next_slab(&allocator->slabs_to_erase);
+	pbn = slab->journal_origin - depot->vdo->geometry.bio_offset;
+	regions[0] = (struct dm_io_region) {
+		.bdev = vdo_get_backing_device(depot->vdo),
+		.sector = pbn * VDO_SECTORS_PER_BLOCK,
+		.count = blocks * VDO_SECTORS_PER_BLOCK,
+	};
+	dm_kcopyd_zero(allocator->eraser, 1, regions, 0, copy_callback, allocator);
+}
+
+/* Implements vdo_admin_initiator. */
+static void initiate_load(struct admin_state *state)
+{
+	struct block_allocator *allocator = container_of(state, struct block_allocator, state);
+	const struct admin_state_code *operation = vdo_get_admin_state_code(state);
+
+	if (operation == VDO_ADMIN_STATE_LOADING_FOR_REBUILD) {
+		/*
+		 * Must requeue because the kcopyd client cannot be freed in the same stack frame
+		 * as the kcopyd callback, lest it deadlock.
+		 */
+		vdo_prepare_completion_for_requeue(&allocator->completion,
+						   finish_loading_allocator,
+						   handle_operation_error,
+						   allocator->thread_id,
+						   NULL);
+		allocator->eraser = dm_kcopyd_client_create(NULL);
+		if (allocator->eraser == NULL) {
+			vdo_fail_completion(&allocator->completion, -ENOMEM);
+			return;
+		}
+		allocator->slabs_to_erase = get_slab_iterator(allocator);
+
+		erase_next_slab_journal(allocator);
+		return;
+	}
+
+	apply_to_slabs(allocator, finish_loading_allocator);
+}
+
+/**
+ * vdo_notify_slab_journals_are_recovered() - Inform a block allocator that its slab journals have
+ *                                            been recovered from the recovery journal.
+ * @completion The allocator completion
+ */
+void vdo_notify_slab_journals_are_recovered(struct vdo_completion *completion)
+{
+	struct block_allocator *allocator = vdo_as_block_allocator(completion);
+
+	vdo_finish_loading_with_result(&allocator->state, completion->result);
+}
+
+static int
+get_slab_statuses(struct block_allocator *allocator, struct slab_status **statuses_ptr)
+{
+	int result;
+	struct slab_status *statuses;
+	struct slab_iterator iterator = get_slab_iterator(allocator);
+
+	result = UDS_ALLOCATE(allocator->slab_count, struct slab_status, __func__, &statuses);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	*statuses_ptr = statuses;
+
+	while (iterator.next != NULL)  {
+		slab_count_t slab_number = next_slab(&iterator)->slab_number;
+
+		*statuses++ = (struct slab_status) {
+			.slab_number = slab_number,
+			.is_clean = !allocator->summary_entries[slab_number].is_dirty,
+			.emptiness = allocator->summary_entries[slab_number].fullness_hint,
+		};
+	}
+
+	return VDO_SUCCESS;
+}
+
+/* Prepare slabs for allocation or scrubbing. */
+static int __must_check
+vdo_prepare_slabs_for_allocation(struct block_allocator *allocator)
+{
+	struct slab_status current_slab_status;
+	struct min_heap heap;
+	int result;
+	struct slab_status *slab_statuses;
+	struct slab_depot *depot = allocator->depot;
+
+	WRITE_ONCE(allocator->allocated_blocks,
+		   allocator->slab_count * depot->slab_config.data_blocks);
+	result = get_slab_statuses(allocator, &slab_statuses);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	/* Sort the slabs by cleanliness, then by emptiness hint. */
+	heap = (struct min_heap) {
+		.data = slab_statuses,
+		.nr = allocator->slab_count,
+		.size = allocator->slab_count,
+	};
+	min_heapify_all(&heap, &slab_status_min_heap);
+
+	while (heap.nr > 0) {
+		bool high_priority;
+		struct vdo_slab *slab;
+		struct slab_journal *journal;
+
+		current_slab_status = slab_statuses[0];
+		min_heap_pop(&heap, &slab_status_min_heap);
+		slab = depot->slabs[current_slab_status.slab_number];
+
+		if ((depot->load_type == VDO_SLAB_DEPOT_REBUILD_LOAD) ||
+		    (!allocator->summary_entries[slab->slab_number].load_ref_counts &&
+		     current_slab_status.is_clean)) {
+			queue_slab(slab);
+			continue;
+		}
+
+		slab->status = VDO_SLAB_REQUIRES_SCRUBBING;
+		journal = &slab->journal;
+		high_priority = ((current_slab_status.is_clean &&
+				 (depot->load_type == VDO_SLAB_DEPOT_NORMAL_LOAD)) ||
+				 (journal_length(journal) >= journal->scrubbing_threshold));
+		register_slab_for_scrubbing(slab, high_priority);
+	}
+
+	UDS_FREE(slab_statuses);
+	return VDO_SUCCESS;
+}
+
+static const char *status_to_string(enum slab_rebuild_status status)
+{
+	switch (status) {
+	case VDO_SLAB_REBUILT:
+		return "REBUILT";
+	case VDO_SLAB_REQUIRES_SCRUBBING:
+		return "SCRUBBING";
+	case VDO_SLAB_REQUIRES_HIGH_PRIORITY_SCRUBBING:
+		return "PRIORITY_SCRUBBING";
+	case VDO_SLAB_REBUILDING:
+		return "REBUILDING";
+	case VDO_SLAB_REPLAYING:
+		return "REPLAYING";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+void vdo_dump_block_allocator(const struct block_allocator *allocator)
+{
+	unsigned int pause_counter = 0;
+	struct slab_iterator iterator = get_slab_iterator(allocator);
+	const struct slab_scrubber *scrubber = &allocator->scrubber;
+
+	uds_log_info("block_allocator zone %u", allocator->zone_number);
+	while (iterator.next != NULL) {
+		struct vdo_slab *slab = next_slab(&iterator);
+		struct slab_journal *journal = &slab->journal;
+
+		if (slab->reference_blocks != NULL)
+			/* Terse because there are a lot of slabs to dump and syslog is lossy. */
+			uds_log_info("slab %u: P%u, %llu free",
+				     slab->slab_number,
+				     slab->priority,
+				     (unsigned long long) slab->free_blocks);
+		else
+			uds_log_info("slab %u: status %s",
+				     slab->slab_number,
+				     status_to_string(slab->status));
+
+		uds_log_info("  slab journal: entry_waiters=%zu waiting_to_commit=%s updating_slab_summary=%s head=%llu unreapable=%llu tail=%llu next_commit=%llu summarized=%llu last_summarized=%llu recovery_lock=%llu dirty=%s",
+			     vdo_count_waiters(&journal->entry_waiters),
+			     uds_bool_to_string(journal->waiting_to_commit),
+			     uds_bool_to_string(journal->updating_slab_summary),
+			     (unsigned long long) journal->head,
+			     (unsigned long long) journal->unreapable,
+			     (unsigned long long) journal->tail,
+			     (unsigned long long) journal->next_commit,
+			     (unsigned long long) journal->summarized,
+			     (unsigned long long) journal->last_summarized,
+			     (unsigned long long) journal->recovery_lock,
+			     uds_bool_to_string(journal->recovery_lock != 0));
+		/*
+		 * Given the frequency with which the locks are just a tiny bit off, it might be
+		 * worth dumping all the locks, but that might be too much logging.
+		 */
+
+		if (slab->counters != NULL)
+			/* Terse because there are a lot of slabs to dump and syslog is lossy. */
+			uds_log_info("  slab: free=%u/%u blocks=%u dirty=%zu active=%zu journal@(%llu,%u)",
+				     slab->free_blocks,
+				     slab->block_count,
+				     slab->reference_block_count,
+				     vdo_count_waiters(&slab->dirty_blocks),
+				     slab->active_count,
+				     (unsigned long long) slab->slab_journal_point.sequence_number,
+				     slab->slab_journal_point.entry_count);
+		else
+			uds_log_info("  no counters");
+
+		/*
+		 * Wait for a while after each batch of 32 slabs dumped, an arbitrary number,
+		 * allowing the kernel log a chance to be flushed instead of being overrun.
+		 */
+		if (pause_counter++ == 31) {
+			pause_counter = 0;
+			uds_pause_for_logger();
+		}
+	}
+
+	uds_log_info("slab_scrubber slab_count %u waiters %zu %s%s",
+		     READ_ONCE(scrubber->slab_count),
+		     vdo_count_waiters(&scrubber->waiters),
+		     vdo_get_admin_state_code(&scrubber->admin_state)->name,
+		     scrubber->high_priority_only ? ", high_priority_only " : "");
+}
+
 static void free_slab(struct vdo_slab *slab)
 {
 	if (slab == NULL)
@@ -2654,6 +3806,169 @@ make_slab(physical_block_number_t slab_origin,
 	return VDO_SUCCESS;
 }
 
+/**
+ * initialize_slab_scrubber() - Initialize an allocator's slab scrubber.
+ * @allocator: The allocator being initialized
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+static int initialize_slab_scrubber(struct block_allocator *allocator)
+{
+	struct slab_scrubber *scrubber = &allocator->scrubber;
+	block_count_t slab_journal_size = allocator->depot->slab_config.slab_journal_blocks;
+	char *journal_data;
+	int result;
+
+	result = UDS_ALLOCATE(VDO_BLOCK_SIZE * slab_journal_size, char, __func__, &journal_data);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = allocate_vio_components(allocator->completion.vdo,
+					 VIO_TYPE_SLAB_JOURNAL,
+					 VIO_PRIORITY_METADATA,
+					 allocator,
+					 slab_journal_size,
+					 journal_data,
+					 &scrubber->vio);
+	if (result != VDO_SUCCESS) {
+		UDS_FREE(journal_data);
+		return result;
+	}
+
+	INIT_LIST_HEAD(&scrubber->high_priority_slabs);
+	INIT_LIST_HEAD(&scrubber->slabs);
+	vdo_set_admin_state_code(&scrubber->admin_state, VDO_ADMIN_STATE_SUSPENDED);
+	return VDO_SUCCESS;
+}
+
+/**
+ * initialize_slab_summary_block() - Initialize a slab_summary_block.
+ * @allocator: The allocator which owns the block.
+ * @index: The index of this block in its zone's summary.
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+static int __must_check
+initialize_slab_summary_block(struct block_allocator *allocator, block_count_t index)
+{
+	struct slab_summary_block *block = &allocator->summary_blocks[index];
+	int result;
+
+	result = UDS_ALLOCATE(VDO_BLOCK_SIZE, char, __func__, &block->outgoing_entries);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = allocate_vio_components(allocator->depot->vdo,
+					 VIO_TYPE_SLAB_SUMMARY,
+					 VIO_PRIORITY_METADATA,
+					 NULL,
+					 1,
+					 block->outgoing_entries,
+					 &block->vio);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	block->allocator = allocator;
+	block->entries = &allocator->summary_entries[VDO_SLAB_SUMMARY_ENTRIES_PER_BLOCK * index];
+	block->index = index;
+	return VDO_SUCCESS;
+}
+
+static int __must_check initialize_block_allocator(struct slab_depot *depot, zone_count_t zone)
+{
+	int result;
+	block_count_t i;
+	struct block_allocator *allocator = &depot->allocators[zone];
+	struct vdo *vdo = depot->vdo;
+	block_count_t max_free_blocks = depot->slab_config.data_blocks;
+	unsigned int max_priority = (2 + ilog2(max_free_blocks));
+
+	*allocator = (struct block_allocator) {
+		.depot = depot,
+		.zone_number = zone,
+		.thread_id = vdo->thread_config.physical_threads[zone],
+		.nonce = vdo->states.vdo.nonce,
+	};
+
+	INIT_LIST_HEAD(&allocator->dirty_slab_journals);
+	vdo_set_admin_state_code(&allocator->state, VDO_ADMIN_STATE_NORMAL_OPERATION);
+	result = vdo_register_read_only_listener(vdo,
+						 allocator,
+						 notify_block_allocator_of_read_only_mode,
+						 allocator->thread_id);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	vdo_initialize_completion(&allocator->completion, vdo, VDO_BLOCK_ALLOCATOR_COMPLETION);
+	result = make_vio_pool(vdo,
+			       BLOCK_ALLOCATOR_VIO_POOL_SIZE,
+			       allocator->thread_id,
+			       VIO_TYPE_SLAB_JOURNAL,
+			       VIO_PRIORITY_METADATA,
+			       allocator,
+			       &allocator->vio_pool);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = initialize_slab_scrubber(allocator);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = vdo_make_priority_table(max_priority, &allocator->prioritized_slabs);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE,
+			      struct slab_summary_block,
+			      __func__,
+			      &allocator->summary_blocks);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	vdo_set_admin_state_code(&allocator->summary_state, VDO_ADMIN_STATE_NORMAL_OPERATION);
+	allocator->summary_entries = depot->summary_entries + (MAX_VDO_SLABS * zone);
+
+	/* Initialize each summary block. */
+	for (i = 0; i < VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE; i++) {
+		result = initialize_slab_summary_block(allocator, i);
+		if (result != VDO_SUCCESS)
+			return result;
+	}
+
+	/*
+	 * Performing well atop thin provisioned storage requires either that VDO discards freed
+	 * blocks, or that the block allocator try to use slabs that already have allocated blocks
+	 * in preference to slabs that have never been opened. For reasons we have not been able to
+	 * fully understand, some SSD machines have been have been very sensitive (50% reduction in
+	 * test throughput) to very slight differences in the timing and locality of block
+	 * allocation. Assigning a low priority to unopened slabs (max_priority/2, say) would be
+	 * ideal for the story, but anything less than a very high threshold (max_priority - 1)
+	 * hurts on these machines.
+	 *
+	 * This sets the free block threshold for preferring to open an unopened slab to the binary
+	 * floor of 3/4ths the total number of data blocks in a slab, which will generally evaluate
+	 * to about half the slab size.
+	 */
+	allocator->unopened_slab_priority = (1 + ilog2((max_free_blocks * 3) / 4));
+
+	return VDO_SUCCESS;
+}
+
+static void uninitialize_allocator_summary(struct block_allocator *allocator)
+{
+	block_count_t i;
+
+	if (allocator->summary_blocks == NULL)
+		return;
+
+	for (i = 0; i < VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE; i++) {
+		free_vio_components(&allocator->summary_blocks[i].vio);
+		UDS_FREE(UDS_FORGET(allocator->summary_blocks[i].outgoing_entries));
+	}
+
+	UDS_FREE(UDS_FORGET(allocator->summary_blocks));
+}
+
 /**
  * finish_combining_zones() - Clean up after saving out the combined slab summary.
  * @completion: The vio which was used to write the summary data.
@@ -2784,3 +4099,150 @@ static void load_slab_summary(void *context, struct vdo_completion *parent)
 			    handle_combining_error,
 			    REQ_OP_READ);
 }
+
+/**
+ * stop_scrubbing() - Tell the scrubber to stop scrubbing after it finishes the slab it is
+ *                    currently working on.
+ * @scrubber: The scrubber to stop.
+ * @parent: The completion to notify when scrubbing has stopped.
+ */
+static void stop_scrubbing(struct block_allocator *allocator)
+{
+	struct slab_scrubber *scrubber = &allocator->scrubber;
+
+	if (vdo_is_state_quiescent(&scrubber->admin_state))
+		vdo_finish_completion(&allocator->completion);
+	else
+		vdo_start_draining(&scrubber->admin_state,
+				   VDO_ADMIN_STATE_SUSPENDING,
+				   &allocator->completion,
+				   NULL);
+}
+
+/* Implements vdo_admin_initiator. */
+static void initiate_summary_drain(struct admin_state *state)
+{
+	check_summary_drain_complete(container_of(state, struct block_allocator, summary_state));
+}
+
+static void do_drain_step(struct vdo_completion *completion)
+{
+	struct block_allocator *allocator = vdo_as_block_allocator(completion);
+
+	vdo_prepare_completion_for_requeue(&allocator->completion,
+					   do_drain_step,
+					   handle_operation_error,
+					   allocator->thread_id,
+					   NULL);
+	switch (++allocator->drain_step) {
+	case VDO_DRAIN_ALLOCATOR_STEP_SCRUBBER:
+		stop_scrubbing(allocator);
+		return;
+
+	case VDO_DRAIN_ALLOCATOR_STEP_SLABS:
+		apply_to_slabs(allocator, do_drain_step);
+		return;
+
+	case VDO_DRAIN_ALLOCATOR_STEP_SUMMARY:
+		vdo_start_draining(&allocator->summary_state,
+				   vdo_get_admin_state_code(&allocator->state),
+				   completion,
+				   initiate_summary_drain);
+		return;
+
+	case VDO_DRAIN_ALLOCATOR_STEP_FINISHED:
+		ASSERT_LOG_ONLY(!is_vio_pool_busy(allocator->vio_pool), "vio pool not busy");
+		vdo_finish_draining_with_result(&allocator->state, completion->result);
+		return;
+
+	default:
+		vdo_finish_draining_with_result(&allocator->state, UDS_BAD_STATE);
+	}
+}
+
+/* Implements vdo_admin_initiator. */
+static void initiate_drain(struct admin_state *state)
+{
+	struct block_allocator *allocator = container_of(state, struct block_allocator, state);
+
+	allocator->drain_step = VDO_DRAIN_ALLOCATOR_START;
+	do_drain_step(&allocator->completion);
+}
+
+/**
+ * resume_scrubbing() - Tell the scrubber to resume scrubbing if it has been stopped.
+ * @allocator: The allocator being resumed.
+ */
+static void resume_scrubbing(struct block_allocator *allocator)
+{
+	int result;
+	struct slab_scrubber *scrubber = &allocator->scrubber;
+
+	if (!has_slabs_to_scrub(scrubber)) {
+		vdo_finish_completion(&allocator->completion);
+		return;
+	}
+
+	result = vdo_resume_if_quiescent(&scrubber->admin_state);
+	if (result != VDO_SUCCESS) {
+		vdo_fail_completion(&allocator->completion, result);
+		return;
+	}
+
+	scrub_next_slab(scrubber);
+	vdo_finish_completion(&allocator->completion);
+}
+
+static void do_resume_step(struct vdo_completion *completion)
+{
+	struct block_allocator *allocator = vdo_as_block_allocator(completion);
+
+	vdo_prepare_completion_for_requeue(&allocator->completion,
+					   do_resume_step,
+					   handle_operation_error,
+					   allocator->thread_id,
+					   NULL);
+	switch (--allocator->drain_step) {
+	case VDO_DRAIN_ALLOCATOR_STEP_SUMMARY:
+		vdo_fail_completion(completion,
+				    vdo_resume_if_quiescent(&allocator->summary_state));
+		return;
+
+	case VDO_DRAIN_ALLOCATOR_STEP_SLABS:
+		apply_to_slabs(allocator, do_resume_step);
+		return;
+
+	case VDO_DRAIN_ALLOCATOR_STEP_SCRUBBER:
+		resume_scrubbing(allocator);
+		return;
+
+	case VDO_DRAIN_ALLOCATOR_START:
+		vdo_finish_resuming_with_result(&allocator->state, completion->result);
+		return;
+
+	default:
+		vdo_finish_resuming_with_result(&allocator->state, UDS_BAD_STATE);
+	}
+}
+
+/* Implements vdo_admin_initiator. */
+static void initiate_resume(struct admin_state *state)
+{
+	struct block_allocator *allocator = container_of(state, struct block_allocator, state);
+
+	allocator->drain_step = VDO_DRAIN_ALLOCATOR_STEP_FINISHED;
+	do_resume_step(&allocator->completion);
+}
+
+/* Implements vdo_zone_action. */
+static void resume_allocator(void *context,
+			     zone_count_t zone_number,
+			     struct vdo_completion *parent)
+{
+	struct slab_depot *depot = context;
+
+	vdo_start_resuming(&depot->allocators[zone_number].state,
+			   vdo_get_current_manager_operation(depot->action_manager),
+			   parent,
+			   initiate_resume);
+}
diff --git a/drivers/md/dm-vdo/slab-depot.h b/drivers/md/dm-vdo/slab-depot.h
index 5e06746c7e71..6ec4be7b5822 100644
--- a/drivers/md/dm-vdo/slab-depot.h
+++ b/drivers/md/dm-vdo/slab-depot.h
@@ -257,6 +257,54 @@ struct vdo_slab {
 	struct reference_block *reference_blocks;
 };
 
+enum block_allocator_drain_step {
+	VDO_DRAIN_ALLOCATOR_START,
+	VDO_DRAIN_ALLOCATOR_STEP_SCRUBBER,
+	VDO_DRAIN_ALLOCATOR_STEP_SLABS,
+	VDO_DRAIN_ALLOCATOR_STEP_SUMMARY,
+	VDO_DRAIN_ALLOCATOR_STEP_FINISHED,
+};
+
+struct slab_scrubber {
+	/* The queue of slabs to scrub first */
+	struct list_head high_priority_slabs;
+	/* The queue of slabs to scrub once there are no high_priority_slabs */
+	struct list_head slabs;
+	/* The queue of VIOs waiting for a slab to be scrubbed */
+	struct wait_queue waiters;
+
+	/*
+	 * The number of slabs that are unrecovered or being scrubbed. This field is modified by
+	 * the physical zone thread, but is queried by other threads.
+	 */
+	slab_count_t slab_count;
+
+	/* The administrative state of the scrubber */
+	struct admin_state admin_state;
+	/* Whether to only scrub high-priority slabs */
+	bool high_priority_only;
+	/* The slab currently being scrubbed */
+	struct vdo_slab *slab;
+	/* The vio for loading slab journal blocks */
+	struct vio vio;
+};
+
+/* A sub-structure for applying actions in parallel to all an allocator's slabs. */
+struct slab_actor {
+	/* The number of slabs performing a slab action */
+	slab_count_t slab_action_count;
+	/* The method to call when a slab action has been completed by all slabs */
+	vdo_action *callback;
+};
+
+/* A slab_iterator is a structure for iterating over a set of slabs. */
+struct slab_iterator {
+	struct vdo_slab **slabs;
+	struct vdo_slab *next;
+	slab_count_t end;
+	slab_count_t stride;
+};
+
 /*
  * The slab_summary provides hints during load and recovery about the state of the slabs in order
  * to avoid the need to read the slab journals in their entirety before a VDO can come online.
@@ -314,6 +362,81 @@ struct atomic_slab_summary_statistics {
 	atomic64_t blocks_written;
 };
 
+struct block_allocator {
+	struct vdo_completion completion;
+	/* The slab depot for this allocator */
+	struct slab_depot *depot;
+	/* The nonce of the VDO */
+	nonce_t nonce;
+	/* The physical zone number of this allocator */
+	zone_count_t zone_number;
+	/* The thread ID for this allocator's physical zone */
+	thread_id_t thread_id;
+	/* The number of slabs in this allocator */
+	slab_count_t slab_count;
+	/* The number of the last slab owned by this allocator */
+	slab_count_t last_slab;
+	/* The reduced priority level used to preserve unopened slabs */
+	unsigned int unopened_slab_priority;
+	/* The state of this allocator */
+	struct admin_state state;
+	/* The actor for applying an action to all slabs */
+	struct slab_actor slab_actor;
+
+	/* The slab from which blocks are currently being allocated */
+	struct vdo_slab *open_slab;
+	/* A priority queue containing all slabs available for allocation */
+	struct priority_table *prioritized_slabs;
+	/* The slab scrubber */
+	struct slab_scrubber scrubber;
+	/* What phase of the close operation the allocator is to perform */
+	enum block_allocator_drain_step drain_step;
+
+	/*
+	 * These statistics are all mutated only by the physical zone thread, but are read by other
+	 * threads when gathering statistics for the entire depot.
+	 */
+	/*
+	 * The count of allocated blocks in this zone. Not in block_allocator_statistics for
+	 * historical reasons.
+	 */
+	u64 allocated_blocks;
+	/* Statistics for this block allocator */
+	struct block_allocator_statistics statistics;
+	/* Cumulative statistics for the slab journals in this zone */
+	struct slab_journal_statistics slab_journal_statistics;
+	/* Cumulative statistics for the reference counters in this zone */
+	struct ref_counts_statistics ref_counts_statistics;
+
+	/*
+	 * This is the head of a queue of slab journals which have entries in their tail blocks
+	 * which have not yet started to commit. When the recovery journal is under space pressure,
+	 * slab journals which have uncommitted entries holding a lock on the recovery journal head
+	 * are forced to commit their blocks early. This list is kept in order, with the tail
+	 * containing the slab journal holding the most recent recovery journal lock.
+	 */
+	struct list_head dirty_slab_journals;
+
+	/* The vio pool for reading and writing block allocator metadata */
+	struct vio_pool *vio_pool;
+	/* The dm_kcopyd client for erasing slab journals */
+	struct dm_kcopyd_client *eraser;
+	/* Iterator over the slabs to be erased */
+	struct slab_iterator slabs_to_erase;
+
+	/* The portion of the slab summary managed by this allocator */
+	/* The state of the slab summary */
+	struct admin_state summary_state;
+	/* The number of outstanding summary writes */
+	block_count_t summary_write_count;
+	/* The array (owned by the blocks) of all entries */
+	struct slab_summary_entry *summary_entries;
+	/* The array of slab_summary_blocks */
+	struct slab_summary_block *summary_blocks;
+};
+
+struct reference_updater;
+
 bool __must_check
 vdo_attempt_replay_into_slab(struct vdo_slab *slab,
 			     physical_block_number_t pbn,
@@ -322,6 +445,29 @@ vdo_attempt_replay_into_slab(struct vdo_slab *slab,
 			     struct journal_point *recovery_point,
 			     struct vdo_completion *parent);
 
+static inline struct block_allocator *vdo_as_block_allocator(struct vdo_completion *completion)
+{
+	vdo_assert_completion_type(completion, VDO_BLOCK_ALLOCATOR_COMPLETION);
+	return container_of(completion, struct block_allocator, completion);
+}
+
+int __must_check vdo_acquire_provisional_reference(struct vdo_slab *slab,
+						   physical_block_number_t pbn,
+						   struct pbn_lock *lock);
+
+int __must_check
+vdo_allocate_block(struct block_allocator *allocator, physical_block_number_t *block_number_ptr);
+
+int vdo_enqueue_clean_slab_waiter(struct block_allocator *allocator, struct waiter *waiter);
+
+void vdo_modify_reference_count(struct vdo_completion *completion,
+				struct reference_updater *updater);
+
+int __must_check vdo_release_block_reference(struct block_allocator *allocator,
+					     physical_block_number_t pbn);
+
 void vdo_notify_slab_journals_are_recovered(struct vdo_completion *completion);
 
+void vdo_dump_block_allocator(const struct block_allocator *allocator);
+
 #endif /* VDO_SLAB_DEPOT_H */
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

