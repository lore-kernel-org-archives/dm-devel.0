Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25D49EEAA62
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719177;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FHEijjNFjlm2hH3OFBcfPnFuMvlYrlpKALVQeo98vGQ=;
	b=Bbg5y/GYe0aLyS1oIRz1jxaTjmyZONcXor1XplqZajlMG2YXA7wvDnl8YwOI4OgRGh5S93
	+xu5XjcRUiLnZ8XS6HAH4p7tZ2OT/EoMM0IxkFw5gffmURaRkBujioi8pwDCm0kyWHZAKG
	D4uKet9itRMtUs4lMPMhptde95Ue3XY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-2mV7yqwdMmuELLwj2AGqlA-1; Thu, 14 Sep 2023 15:19:33 -0400
X-MC-Unique: 2mV7yqwdMmuELLwj2AGqlA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42C60187507E;
	Thu, 14 Sep 2023 19:19:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1FD942026D76;
	Thu, 14 Sep 2023 19:19:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B5A161946A6E;
	Thu, 14 Sep 2023 19:18:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B0C221946A6A
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:17:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A032340C2070; Thu, 14 Sep 2023 19:17:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 99120406AA67
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DFBC185A79B
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:42 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-6S8oA-6LN0azDmvD7xsUMg-2; Thu, 14 Sep 2023 15:17:40 -0400
X-MC-Unique: 6S8oA-6LN0azDmvD7xsUMg-2
Received: by mail-qt1-f181.google.com with SMTP id
 d75a77b69052e-4179632293bso1523341cf.3
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719059; x=1695323859;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=MojXSuquJxf1uAisQpvdQkYl93YweyykrEddLeHkSWM=;
 b=FBdS7nF5sN3V/+n1ZQY/pcu3G9mbb5S9wrv3k4E8LTXCnv9pTda2WvdRkT7kJHHtmg
 fWrnuOXn6d6tqazU3c6ABVcXuVDfnBHCp5R0RbQ5vcZ3BFmsCyojovSo3P3zVIVaeXp3
 dKvQWnLj91oHsRhGyjdVaj1spzhOVJRZFi9B+7NWH4foP+VgidzENwhUEQJt781Rjuxs
 3K/4hdKQjFhRt8dVbhy6dcP5a+UUdeqoTED9kfsjpNJAAE6JpD91PYkL5kh7wC/790Go
 yE7mbBuPdsXnopSQqlesnQrtbHrBnH6GB+9JrJhveDXybocdyJJ7R+LSUURgzNNgI7nr
 Dn/w==
X-Gm-Message-State: AOJu0YyPOA07wWd2fGlU0tfBROR4kSMnsDhqKhyH4W9CoD5KmeDHF9cH
 DAGK6wEh9hNhf52qqB/CAQ4iG/6npEzFmS6BKZ/+01f3nSNY8QrcOw0BWyC3wi2i7Q/peHq4zQ0
 ptelg905DvTWQxp35/gk8//t3SJM30C7X0BJsr1qAHkF6TDq8/09sMeDXkxQzlvirWt3z7ne9
X-Google-Smtp-Source: AGHT+IHBdWDqYFZEEq2tv86iXzjZyEDG3wdaZkY2rQKn53xOkbS81rp2Bp9LhkrvOeSp45T/9jRZtA==
X-Received: by 2002:a05:622a:1b89:b0:412:6e6:b45b with SMTP id
 bp9-20020a05622a1b8900b0041206e6b45bmr5737785qtb.38.1694719058400; 
 Thu, 14 Sep 2023 12:17:38 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 g16-20020ac870d0000000b0041061a16791sm633345qtp.67.2023.09.14.12.17.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:17:37 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:16:27 -0400
Message-Id: <20230914191635.39805-32-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v3 31/39] dm vdo: add the vdo recovery journal
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

The recovery journal is used to amortize updates across the block map
and slab depot. Each write request causes an entry to be made in the
journal. Entries are either "data remappings" or "block map
remappings." For a data remapping, the journal records the logical
address affected and its old and new physical mappings. For a block
map remapping, the journal records the block map page number and the
physical block allocated for it (block map pages are never reclaimed,
so the old mapping is always 0). Each journal entry and the data write
it represents must be stable on disk before the other metadata
structures may be updated to reflect the operation.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: Michael Sclafani <vdo-devel@redhat.com>
Signed-off-by: Michael Sclafani <vdo-devel@redhat.com>
Co-developed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-vdo/recovery-journal.c | 1772 ++++++++++++++++++++++++++
 drivers/md/dm-vdo/recovery-journal.h |  313 +++++
 2 files changed, 2085 insertions(+)
 create mode 100644 drivers/md/dm-vdo/recovery-journal.c
 create mode 100644 drivers/md/dm-vdo/recovery-journal.h

diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
new file mode 100644
index 000000000000..6abf43e99a48
--- /dev/null
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -0,0 +1,1772 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#include "recovery-journal.h"
+
+#include <linux/atomic.h>
+#include <linux/bio.h>
+
+#include "logger.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+
+#include "block-map.h"
+#include "completion.h"
+#include "constants.h"
+#include "data-vio.h"
+#include "encodings.h"
+#include "io-submitter.h"
+#include "slab-depot.h"
+#include "types.h"
+#include "vdo.h"
+#include "vio.h"
+#include "wait-queue.h"
+
+static const u64 RECOVERY_COUNT_MASK = 0xff;
+
+enum {
+	/*
+	 * The number of reserved blocks must be large enough to prevent a new recovery journal
+	 * block write from overwriting a block which appears to still be a valid head block of the
+	 * journal. Currently, that means reserving enough space for all 2048 data_vios.
+	 */
+	RECOVERY_JOURNAL_RESERVED_BLOCKS =
+		(MAXIMUM_VDO_USER_VIOS / RECOVERY_JOURNAL_ENTRIES_PER_BLOCK) + 2,
+	WRITE_FLAGS = REQ_OP_WRITE | REQ_PRIO | REQ_PREFLUSH | REQ_SYNC | REQ_FUA,
+};
+
+/**
+ * DOC: Lock Counters.
+ *
+ * A lock_counter is intended to keep all of the locks for the blocks in the recovery journal. The
+ * per-zone counters are all kept in a single array which is arranged by zone (i.e. zone 0's lock 0
+ * is at index 0, zone 0's lock 1 is at index 1, and zone 1's lock 0 is at index 'locks'. This
+ * arrangement is intended to minimize cache-line contention for counters from different zones.
+ *
+ * The locks are implemented as a single object instead of as a lock counter per lock both to
+ * afford this opportunity to reduce cache line contention and also to eliminate the need to have a
+ * completion per lock.
+ *
+ * Lock sets are laid out with the set for recovery journal first, followed by the logical zones,
+ * and then the physical zones.
+ */
+
+enum lock_counter_state {
+	LOCK_COUNTER_STATE_NOT_NOTIFYING,
+	LOCK_COUNTER_STATE_NOTIFYING,
+	LOCK_COUNTER_STATE_SUSPENDED,
+};
+
+/**
+ * get_zone_count_ptr() - Get a pointer to the zone count for a given lock on a given zone.
+ * @journal: The recovery journal.
+ * @lock_number: The lock to get.
+ * @zone_type: The zone type whose count is desired.
+ *
+ * Return: A pointer to the zone count for the given lock and zone.
+ */
+static inline atomic_t *get_zone_count_ptr(struct recovery_journal *journal,
+					   block_count_t lock_number,
+					   enum vdo_zone_type zone_type)
+{
+	return ((zone_type == VDO_ZONE_TYPE_LOGICAL)
+		? &journal->lock_counter.logical_zone_counts[lock_number]
+		: &journal->lock_counter.physical_zone_counts[lock_number]);
+}
+
+/**
+ * get_counter() - Get the zone counter for a given lock on a given zone.
+ * @journal: The recovery journal.
+ * @lock_number: The lock to get.
+ * @zone_type: The zone type whose count is desired.
+ * @zone_id: The zone index whose count is desired.
+ *
+ * Return: The counter for the given lock and zone.
+ */
+static inline u16 *get_counter(struct recovery_journal *journal,
+			       block_count_t lock_number,
+			       enum vdo_zone_type zone_type,
+			       zone_count_t zone_id)
+{
+	struct lock_counter *counter = &journal->lock_counter;
+	block_count_t zone_counter = (counter->locks * zone_id) + lock_number;
+
+	if (zone_type == VDO_ZONE_TYPE_JOURNAL)
+		return &counter->journal_counters[zone_counter];
+
+	if (zone_type == VDO_ZONE_TYPE_LOGICAL)
+		return &counter->logical_counters[zone_counter];
+
+	return &counter->physical_counters[zone_counter];
+}
+
+static atomic_t *get_decrement_counter(struct recovery_journal *journal, block_count_t lock_number)
+{
+	return &journal->lock_counter.journal_decrement_counts[lock_number];
+}
+
+/**
+ * is_journal_zone_locked() - Check whether the journal zone is locked for a given lock.
+ * @journal: The recovery journal.
+ * @lock_number: The lock to check.
+ *
+ * Return: true if the journal zone is locked.
+ */
+static bool is_journal_zone_locked(struct recovery_journal *journal, block_count_t lock_number)
+{
+	u16 journal_value = *(get_counter(journal, lock_number, VDO_ZONE_TYPE_JOURNAL, 0));
+	u32 decrements = atomic_read(get_decrement_counter(journal, lock_number));
+
+	/* Pairs with barrier in vdo_release_journal_entry_lock() */
+	smp_rmb();
+	ASSERT_LOG_ONLY((decrements <= journal_value),
+			"journal zone lock counter must not underflow");
+	return (journal_value != decrements);
+}
+
+/**
+ * vdo_release_recovery_journal_block_reference() - Release a reference to a recovery journal
+ *                                                  block.
+ * @journal: The recovery journal.
+ * @sequence_number: The journal sequence number of the referenced block.
+ * @zone_type: The type of the zone making the adjustment.
+ * @zone_id: The ID of the zone making the adjustment.
+ *
+ * If this is the last reference for a given zone type, an attempt will be made to reap the
+ * journal.
+ */
+void vdo_release_recovery_journal_block_reference(struct recovery_journal *journal,
+						  sequence_number_t sequence_number,
+						  enum vdo_zone_type zone_type,
+						  zone_count_t zone_id)
+{
+	u16 *current_value;
+	block_count_t lock_number;
+	int prior_state;
+
+	if (sequence_number == 0)
+		return;
+
+	lock_number = vdo_get_recovery_journal_block_number(journal, sequence_number);
+	current_value = get_counter(journal, lock_number, zone_type, zone_id);
+
+	ASSERT_LOG_ONLY((*current_value >= 1), "decrement of lock counter must not underflow");
+	*current_value -= 1;
+
+	if (zone_type == VDO_ZONE_TYPE_JOURNAL) {
+		if (is_journal_zone_locked(journal, lock_number))
+			return;
+	} else {
+		atomic_t *zone_count;
+
+		if (*current_value != 0)
+			return;
+
+		zone_count = get_zone_count_ptr(journal, lock_number, zone_type);
+
+		if (atomic_add_return(-1, zone_count) > 0)
+			return;
+	}
+
+	/*
+	 * Extra barriers because this was original developed using a CAS operation that implicitly
+	 * had them.
+	 */
+	smp_mb__before_atomic();
+	prior_state = atomic_cmpxchg(&journal->lock_counter.state,
+				     LOCK_COUNTER_STATE_NOT_NOTIFYING,
+				     LOCK_COUNTER_STATE_NOTIFYING);
+	/* same as before_atomic */
+	smp_mb__after_atomic();
+
+	if (prior_state != LOCK_COUNTER_STATE_NOT_NOTIFYING)
+		return;
+
+	vdo_launch_completion(&journal->lock_counter.completion);
+}
+
+static inline struct recovery_journal_block * __must_check
+get_journal_block(struct list_head *list)
+{
+	return list_first_entry_or_null(list, struct recovery_journal_block, list_node);
+}
+
+/**
+ * pop_free_list() - Get a block from the end of the free list.
+ * @journal: The journal.
+ *
+ * Return: The block or NULL if the list is empty.
+ */
+static struct recovery_journal_block * __must_check
+pop_free_list(struct recovery_journal *journal)
+{
+	struct recovery_journal_block *block;
+
+	if (list_empty(&journal->free_tail_blocks))
+		return NULL;
+
+	block = list_last_entry(&journal->free_tail_blocks,
+				struct recovery_journal_block,
+				list_node);
+	list_del_init(&block->list_node);
+	return block;
+}
+
+/**
+ * is_block_dirty() - Check whether a recovery block is dirty.
+ * @block: The block to check.
+ *
+ * Indicates it has any uncommitted entries, which includes both entries not written and entries
+ * written but not yet acknowledged.
+ *
+ * Return: true if the block has any uncommitted entries.
+ */
+static inline bool __must_check is_block_dirty(const struct recovery_journal_block *block)
+{
+	return (block->uncommitted_entry_count > 0);
+}
+
+/**
+ * is_block_empty() - Check whether a journal block is empty.
+ * @block: The block to check.
+ *
+ * Return: true if the block has no entries.
+ */
+static inline bool __must_check is_block_empty(const struct recovery_journal_block *block)
+{
+	return (block->entry_count == 0);
+}
+
+/**
+ * is_block_full() - Check whether a journal block is full.
+ * @block: The block to check.
+ *
+ * Return: true if the block is full.
+ */
+static inline bool __must_check is_block_full(const struct recovery_journal_block *block)
+{
+	return ((block == NULL) || (block->journal->entries_per_block == block->entry_count));
+}
+
+/**
+ * assert_on_journal_thread() - Assert that we are running on the journal thread.
+ * @journal: The journal.
+ * @function_name: The function doing the check (for logging).
+ */
+static void assert_on_journal_thread(struct recovery_journal *journal, const char *function_name)
+{
+	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == journal->thread_id),
+			"%s() called on journal thread", function_name);
+}
+
+/**
+ * continue_waiter() - Release a data_vio from the journal.
+ *
+ * Invoked whenever a data_vio is to be released from the journal, either because its entry was
+ * committed to disk, or because there was an error. Implements waiter_callback.
+ */
+static void continue_waiter(struct waiter *waiter, void *context)
+{
+	continue_data_vio_with_error(waiter_as_data_vio(waiter), *((int *) context));
+}
+
+/**
+ * has_block_waiters() - Check whether the journal has any waiters on any blocks.
+ * @journal: The journal in question.
+ *
+ * Return: true if any block has a waiter.
+ */
+static inline bool has_block_waiters(struct recovery_journal *journal)
+{
+	struct recovery_journal_block *block = get_journal_block(&journal->active_tail_blocks);
+
+	/*
+	 * Either the first active tail block (if it exists) has waiters, or no active tail block
+	 * has waiters.
+	 */
+	return ((block != NULL) &&
+		(vdo_has_waiters(&block->entry_waiters) ||
+		 vdo_has_waiters(&block->commit_waiters)));
+}
+
+static void recycle_journal_blocks(struct recovery_journal *journal);
+static void recycle_journal_block(struct recovery_journal_block *block);
+static void notify_commit_waiters(struct recovery_journal *journal);
+
+/**
+ * suspend_lock_counter() - Prevent the lock counter from notifying.
+ * @counter: The counter.
+ *
+ * Return: true if the lock counter was not notifying and hence the suspend was efficacious.
+ */
+static bool suspend_lock_counter(struct lock_counter *counter)
+{
+	int prior_state;
+
+	/*
+	 * Extra barriers because this was originally developed using a CAS operation that
+	 * implicitly had them.
+	 */
+	smp_mb__before_atomic();
+	prior_state = atomic_cmpxchg(&counter->state,
+				     LOCK_COUNTER_STATE_NOT_NOTIFYING,
+				     LOCK_COUNTER_STATE_SUSPENDED);
+	/* same as before_atomic */
+	smp_mb__after_atomic();
+
+	return ((prior_state == LOCK_COUNTER_STATE_SUSPENDED) ||
+		(prior_state == LOCK_COUNTER_STATE_NOT_NOTIFYING));
+}
+
+static inline bool is_read_only(struct recovery_journal *journal)
+{
+	return vdo_is_read_only(journal->flush_vio->completion.vdo);
+}
+
+/**
+ * check_for_drain_complete() - Check whether the journal has drained.
+ * @journal: The journal which may have just drained.
+ */
+static void check_for_drain_complete(struct recovery_journal *journal)
+{
+	int result = VDO_SUCCESS;
+
+	if (is_read_only(journal)) {
+		result = VDO_READ_ONLY;
+		/*
+		 * Clean up any full active blocks which were not written due to read-only mode.
+		 *
+		 * FIXME: This would probably be better as a short-circuit in write_block().
+		 */
+		notify_commit_waiters(journal);
+		recycle_journal_blocks(journal);
+
+		/* Release any data_vios waiting to be assigned entries. */
+		vdo_notify_all_waiters(&journal->entry_waiters, continue_waiter, &result);
+	}
+
+	if (!vdo_is_state_draining(&journal->state) ||
+	    journal->reaping ||
+	    has_block_waiters(journal) ||
+	    vdo_has_waiters(&journal->entry_waiters) ||
+	    !suspend_lock_counter(&journal->lock_counter))
+		return;
+
+	if (vdo_is_state_saving(&journal->state)) {
+		if (journal->active_block != NULL) {
+			ASSERT_LOG_ONLY(((result == VDO_READ_ONLY) ||
+					 !is_block_dirty(journal->active_block)),
+					"journal being saved has clean active block");
+			recycle_journal_block(journal->active_block);
+		}
+
+		ASSERT_LOG_ONLY(list_empty(&journal->active_tail_blocks),
+				"all blocks in a journal being saved must be inactive");
+	}
+
+	vdo_finish_draining_with_result(&journal->state, result);
+}
+
+/**
+ * notify_recovery_journal_of_read_only_mode() - Notify a recovery journal that the VDO has gone
+ *                                               read-only.
+ * @listener: The journal.
+ * @parent: The completion to notify in order to acknowledge the notification.
+ *
+ * Implements vdo_read_only_notification.
+ */
+static void
+notify_recovery_journal_of_read_only_mode(void *listener, struct vdo_completion *parent)
+{
+	check_for_drain_complete(listener);
+	vdo_finish_completion(parent);
+}
+
+/**
+ * enter_journal_read_only_mode() - Put the journal in read-only mode.
+ * @journal: The journal which has failed.
+ * @error_code: The error result triggering this call.
+ *
+ * All attempts to add entries after this function is called will fail. All VIOs waiting for
+ * commits will be awakened with an error.
+ */
+static void enter_journal_read_only_mode(struct recovery_journal *journal, int error_code)
+{
+	vdo_enter_read_only_mode(journal->flush_vio->completion.vdo, error_code);
+	check_for_drain_complete(journal);
+}
+
+/**
+ * vdo_get_recovery_journal_current_sequence_number() - Obtain the recovery journal's current
+ *                                                      sequence number.
+ * @journal: The journal in question.
+ *
+ * Exposed only so the block map can be initialized therefrom.
+ *
+ * Return: The sequence number of the tail block.
+ */
+sequence_number_t
+vdo_get_recovery_journal_current_sequence_number(struct recovery_journal *journal)
+{
+	return journal->tail;
+}
+
+/**
+ * get_recovery_journal_head() - Get the head of the recovery journal.
+ * @journal: The journal.
+ *
+ * The head is the lowest sequence number of the block map head and the slab journal head.
+ *
+ * Return: the head of the journal.
+ */
+static inline sequence_number_t get_recovery_journal_head(const struct recovery_journal *journal)
+{
+	return min(journal->block_map_head, journal->slab_journal_head);
+}
+
+/**
+ * compute_recovery_count_byte() - Compute the recovery count byte for a given recovery count.
+ * @recovery_count: The recovery count.
+ *
+ * Return: The byte corresponding to the recovery count.
+ */
+static inline u8 __must_check compute_recovery_count_byte(u64 recovery_count)
+{
+	return (u8)(recovery_count & RECOVERY_COUNT_MASK);
+}
+
+/**
+ * check_slab_journal_commit_threshold() - Check whether the journal is over the threshold, and if
+ *                                         so, force the oldest slab journal tail block to commit.
+ * @journal: The journal.
+ */
+static void check_slab_journal_commit_threshold(struct recovery_journal *journal)
+{
+	block_count_t current_length = journal->tail - journal->slab_journal_head;
+
+	if (current_length > journal->slab_journal_commit_threshold) {
+		journal->events.slab_journal_commits_requested++;
+		vdo_commit_oldest_slab_journal_tail_blocks(journal->depot,
+							   journal->slab_journal_head);
+	}
+}
+
+static void reap_recovery_journal(struct recovery_journal *journal);
+static void assign_entries(struct recovery_journal *journal);
+
+/**
+ * finish_reaping() - Finish reaping the journal.
+ * @journal: The journal being reaped.
+ */
+static void finish_reaping(struct recovery_journal *journal)
+{
+	block_count_t blocks_reaped;
+	sequence_number_t old_head = get_recovery_journal_head(journal);
+
+	journal->block_map_head = journal->block_map_reap_head;
+	journal->slab_journal_head = journal->slab_journal_reap_head;
+	blocks_reaped = get_recovery_journal_head(journal) - old_head;
+	journal->available_space += blocks_reaped * journal->entries_per_block;
+	journal->reaping = false;
+	check_slab_journal_commit_threshold(journal);
+	assign_entries(journal);
+	check_for_drain_complete(journal);
+}
+
+/**
+ * complete_reaping() - Finish reaping the journal after flushing the lower layer.
+ * @completion: The journal's flush VIO.
+ *
+ * This is the callback registered in reap_recovery_journal().
+ */
+static void complete_reaping(struct vdo_completion *completion)
+{
+	struct recovery_journal *journal = completion->parent;
+
+	finish_reaping(journal);
+
+	/* Try reaping again in case more locks were released while flush was out. */
+	reap_recovery_journal(journal);
+}
+
+/**
+ * handle_flush_error() - Handle an error when flushing the lower layer due to reaping.
+ * @completion: The journal's flush VIO.
+ */
+static void handle_flush_error(struct vdo_completion *completion)
+{
+	struct recovery_journal *journal = completion->parent;
+
+	vio_record_metadata_io_error(as_vio(completion));
+	journal->reaping = false;
+	enter_journal_read_only_mode(journal, completion->result);
+}
+
+static void flush_endio(struct bio *bio)
+{
+	struct vio *vio = bio->bi_private;
+	struct recovery_journal *journal = vio->completion.parent;
+
+	continue_vio_after_io(vio, complete_reaping, journal->thread_id);
+}
+
+/**
+ * initialize_journal_state() - Set all journal fields appropriately to start journaling from the
+ *                              current active block.
+ * @journal: The journal to be reset based on its active block.
+ */
+static void initialize_journal_state(struct recovery_journal *journal)
+{
+	journal->append_point.sequence_number = journal->tail;
+	journal->last_write_acknowledged = journal->tail;
+	journal->block_map_head = journal->tail;
+	journal->slab_journal_head = journal->tail;
+	journal->block_map_reap_head = journal->tail;
+	journal->slab_journal_reap_head = journal->tail;
+	journal->block_map_head_block_number =
+		vdo_get_recovery_journal_block_number(journal, journal->block_map_head);
+	journal->slab_journal_head_block_number =
+		vdo_get_recovery_journal_block_number(journal, journal->slab_journal_head);
+	journal->available_space =
+		(journal->entries_per_block * vdo_get_recovery_journal_length(journal->size));
+}
+
+/**
+ * vdo_get_recovery_journal_length() - Get the number of usable recovery journal blocks.
+ * @journal_size: The size of the recovery journal in blocks.
+ *
+ * Return: the number of recovery journal blocks usable for entries.
+ */
+block_count_t vdo_get_recovery_journal_length(block_count_t journal_size)
+{
+	block_count_t reserved_blocks = journal_size / 4;
+
+	if (reserved_blocks > RECOVERY_JOURNAL_RESERVED_BLOCKS)
+		reserved_blocks = RECOVERY_JOURNAL_RESERVED_BLOCKS;
+	return (journal_size - reserved_blocks);
+}
+
+/**
+ * reap_recovery_journal_callback() - Attempt to reap the journal.
+ * @completion: The lock counter completion.
+ *
+ * Attempts to reap the journal now that all the locks on some journal block have been released.
+ * This is the callback registered with the lock counter.
+ */
+static void reap_recovery_journal_callback(struct vdo_completion *completion)
+{
+	struct recovery_journal *journal = (struct recovery_journal *) completion->parent;
+	/*
+	 * The acknowledgment must be done before reaping so that there is no race between
+	 * acknowledging the notification and unlocks wishing to notify.
+	 */
+	smp_wmb();
+	atomic_set(&journal->lock_counter.state, LOCK_COUNTER_STATE_NOT_NOTIFYING);
+
+	if (vdo_is_state_quiescing(&journal->state)) {
+		/*
+		 * Don't start reaping when the journal is trying to quiesce. Do check if this
+		 * notification is the last thing the is waiting on.
+		 */
+		check_for_drain_complete(journal);
+		return;
+	}
+
+	reap_recovery_journal(journal);
+	check_slab_journal_commit_threshold(journal);
+}
+
+/**
+ * initialize_lock_counter() - Initialize a lock counter.
+ *
+ * @journal: The recovery journal.
+ * @vdo: The vdo.
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+static int __must_check initialize_lock_counter(struct recovery_journal *journal, struct vdo *vdo)
+{
+	int result;
+	struct thread_config *config = &vdo->thread_config;
+	struct lock_counter *counter = &journal->lock_counter;
+
+	result = UDS_ALLOCATE(journal->size, u16, __func__, &counter->journal_counters);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(journal->size,
+			      atomic_t,
+			      __func__,
+			      &counter->journal_decrement_counts);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(journal->size * config->logical_zone_count,
+			      u16,
+			      __func__,
+			      &counter->logical_counters);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(journal->size, atomic_t, __func__, &counter->logical_zone_counts);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(journal->size * config->physical_zone_count,
+			      u16,
+			      __func__,
+			      &counter->physical_counters);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(journal->size, atomic_t, __func__, &counter->physical_zone_counts);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	vdo_initialize_completion(&counter->completion, vdo, VDO_LOCK_COUNTER_COMPLETION);
+	vdo_prepare_completion(&counter->completion,
+			       reap_recovery_journal_callback,
+			       reap_recovery_journal_callback,
+			       config->journal_thread,
+			       journal);
+	counter->logical_zones = config->logical_zone_count;
+	counter->physical_zones = config->physical_zone_count;
+	counter->locks = journal->size;
+	return VDO_SUCCESS;
+}
+
+/**
+ * set_journal_tail() - Set the journal's tail sequence number.
+ * @journal: The journal whose tail is to be set.
+ * @tail: The new tail value.
+ */
+static void set_journal_tail(struct recovery_journal *journal, sequence_number_t tail)
+{
+	/* VDO does not support sequence numbers above 1 << 48 in the slab journal. */
+	if (tail >= (1ULL << 48))
+		enter_journal_read_only_mode(journal, VDO_JOURNAL_OVERFLOW);
+
+	journal->tail = tail;
+}
+
+/**
+ * initialize_recovery_block() - Initialize a journal block.
+ * @vdo: The vdo from which to construct vios.
+ * @journal: The journal to which the block will belong.
+ * @block: The block to initialize.
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+static int initialize_recovery_block(struct vdo *vdo,
+				     struct recovery_journal *journal,
+				     struct recovery_journal_block *block)
+{
+	char *data;
+	int result;
+
+	/*
+	 * Ensure that a block is large enough to store RECOVERY_JOURNAL_ENTRIES_PER_BLOCK entries.
+	 */
+	STATIC_ASSERT(RECOVERY_JOURNAL_ENTRIES_PER_BLOCK
+		      <= ((VDO_BLOCK_SIZE - sizeof(struct packed_journal_header)) /
+			  sizeof(struct packed_recovery_journal_entry)));
+
+	/*
+	 * Allocate a full block for the journal block even though not all of the space is used
+	 * since the VIO needs to write a full disk block.
+	 */
+	result = UDS_ALLOCATE(VDO_BLOCK_SIZE, char, __func__, &data);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = allocate_vio_components(vdo,
+					 VIO_TYPE_RECOVERY_JOURNAL,
+					 VIO_PRIORITY_HIGH,
+					 block,
+					 1,
+					 data,
+					 &block->vio);
+	if (result != VDO_SUCCESS) {
+		UDS_FREE(data);
+		return result;
+	}
+
+	list_add_tail(&block->list_node, &journal->free_tail_blocks);
+	block->journal = journal;
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_decode_recovery_journal() - Make a recovery journal and initialize it with the state that
+ *                                 was decoded from the super block.
+ *
+ * @state: The decoded state of the journal.
+ * @nonce: The nonce of the VDO.
+ * @vdo: The VDO.
+ * @partition: The partition for the journal.
+ * @recovery_count: The VDO's number of completed recoveries.
+ * @journal_size: The number of blocks in the journal on disk.
+ * @journal_ptr: The pointer to hold the new recovery journal.
+ *
+ * Return: A success or error code.
+ */
+int vdo_decode_recovery_journal(struct recovery_journal_state_7_0 state,
+				nonce_t nonce,
+				struct vdo *vdo,
+				struct partition *partition,
+				u64 recovery_count,
+				block_count_t journal_size,
+				struct recovery_journal **journal_ptr)
+{
+	block_count_t i;
+	struct recovery_journal *journal;
+	int result;
+
+	result = UDS_ALLOCATE_EXTENDED(struct recovery_journal,
+				       RECOVERY_JOURNAL_RESERVED_BLOCKS,
+				       struct recovery_journal_block,
+				       __func__,
+				       &journal);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	INIT_LIST_HEAD(&journal->free_tail_blocks);
+	INIT_LIST_HEAD(&journal->active_tail_blocks);
+	vdo_initialize_wait_queue(&journal->pending_writes);
+
+	journal->thread_id = vdo->thread_config.journal_thread;
+	journal->origin = partition->offset;
+	journal->nonce = nonce;
+	journal->recovery_count = compute_recovery_count_byte(recovery_count);
+	journal->size = journal_size;
+	journal->slab_journal_commit_threshold = (journal_size * 2) / 3;
+	journal->logical_blocks_used = state.logical_blocks_used;
+	journal->block_map_data_blocks = state.block_map_data_blocks;
+	journal->entries_per_block = RECOVERY_JOURNAL_ENTRIES_PER_BLOCK;
+	set_journal_tail(journal, state.journal_start);
+	initialize_journal_state(journal);
+	/* TODO: this will have to change if we make initial resume of a VDO a real resume */
+	vdo_set_admin_state_code(&journal->state, VDO_ADMIN_STATE_SUSPENDED);
+
+	for (i = 0; i < RECOVERY_JOURNAL_RESERVED_BLOCKS; i++) {
+		struct recovery_journal_block *block = &journal->blocks[i];
+
+		result = initialize_recovery_block(vdo, journal, block);
+		if (result != VDO_SUCCESS) {
+			vdo_free_recovery_journal(journal);
+			return result;
+		}
+	}
+
+	result = initialize_lock_counter(journal, vdo);
+	if (result != VDO_SUCCESS) {
+		vdo_free_recovery_journal(journal);
+		return result;
+	}
+
+	result = create_metadata_vio(vdo,
+				     VIO_TYPE_RECOVERY_JOURNAL,
+				     VIO_PRIORITY_HIGH,
+				     journal,
+				     NULL,
+				     &journal->flush_vio);
+	if (result != VDO_SUCCESS) {
+		vdo_free_recovery_journal(journal);
+		return result;
+	}
+
+	result = vdo_register_read_only_listener(vdo,
+						 journal,
+						 notify_recovery_journal_of_read_only_mode,
+						 journal->thread_id);
+	if (result != VDO_SUCCESS) {
+		vdo_free_recovery_journal(journal);
+		return result;
+	}
+
+	result = vdo_make_default_thread(vdo, journal->thread_id);
+	if (result != VDO_SUCCESS) {
+		vdo_free_recovery_journal(journal);
+		return result;
+	}
+
+	journal->flush_vio->completion.callback_thread_id = journal->thread_id;
+	*journal_ptr = journal;
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_free_recovery_journal() - Free a recovery journal.
+ * @journal: The recovery journal to free.
+ */
+void vdo_free_recovery_journal(struct recovery_journal *journal)
+{
+	block_count_t i;
+
+	if (journal == NULL)
+		return;
+
+	UDS_FREE(UDS_FORGET(journal->lock_counter.logical_zone_counts));
+	UDS_FREE(UDS_FORGET(journal->lock_counter.physical_zone_counts));
+	UDS_FREE(UDS_FORGET(journal->lock_counter.journal_counters));
+	UDS_FREE(UDS_FORGET(journal->lock_counter.journal_decrement_counts));
+	UDS_FREE(UDS_FORGET(journal->lock_counter.logical_counters));
+	UDS_FREE(UDS_FORGET(journal->lock_counter.physical_counters));
+	free_vio(UDS_FORGET(journal->flush_vio));
+
+	/*
+	 * FIXME: eventually, the journal should be constructed in a quiescent state which
+	 *        requires opening before use.
+	 */
+	if (!vdo_is_state_quiescent(&journal->state))
+		ASSERT_LOG_ONLY(list_empty(&journal->active_tail_blocks),
+				"journal being freed has no active tail blocks");
+	else if (!vdo_is_state_saved(&journal->state) && !list_empty(&journal->active_tail_blocks))
+		uds_log_warning("journal being freed has uncommitted entries");
+
+	for (i = 0; i < RECOVERY_JOURNAL_RESERVED_BLOCKS; i++) {
+		struct recovery_journal_block *block = &journal->blocks[i];
+
+		UDS_FREE(UDS_FORGET(block->vio.data));
+		free_vio_components(&block->vio);
+	}
+
+	UDS_FREE(journal);
+}
+
+/**
+ * vdo_initialize_recovery_journal_post_repair() - Initialize the journal after a repair.
+ * @journal: The journal in question.
+ * @recovery_count: The number of completed recoveries.
+ * @tail: The new tail block sequence number.
+ * @logical_blocks_used: The new number of logical blocks used.
+ * @block_map_data_blocks: The new number of block map data blocks.
+ */
+void vdo_initialize_recovery_journal_post_repair(struct recovery_journal *journal,
+						  u64 recovery_count,
+						  sequence_number_t tail,
+						  block_count_t logical_blocks_used,
+						  block_count_t block_map_data_blocks)
+{
+	set_journal_tail(journal, tail + 1);
+	journal->recovery_count = compute_recovery_count_byte(recovery_count);
+	initialize_journal_state(journal);
+	journal->logical_blocks_used = logical_blocks_used;
+	journal->block_map_data_blocks = block_map_data_blocks;
+}
+
+/**
+ * vdo_get_journal_block_map_data_blocks_used() - Get the number of block map pages, allocated from
+ *                                                data blocks, currently in use.
+ * @journal: The journal in question.
+ *
+ * Return: The number of block map pages allocated from slabs.
+ */
+block_count_t vdo_get_journal_block_map_data_blocks_used(struct recovery_journal *journal)
+{
+	return journal->block_map_data_blocks;
+}
+
+/**
+ * vdo_get_recovery_journal_thread_id() - Get the ID of a recovery journal's thread.
+ * @journal: The journal to query.
+ *
+ * Return: The ID of the journal's thread.
+ */
+thread_id_t vdo_get_recovery_journal_thread_id(struct recovery_journal *journal)
+{
+	return journal->thread_id;
+}
+
+/**
+ * vdo_open_recovery_journal() - Prepare the journal for new entries.
+ * @journal: The journal in question.
+ * @depot: The slab depot for this VDO.
+ * @block_map: The block map for this VDO.
+ */
+void vdo_open_recovery_journal(struct recovery_journal *journal,
+			       struct slab_depot *depot,
+			       struct block_map *block_map)
+{
+	journal->depot = depot;
+	journal->block_map = block_map;
+	WRITE_ONCE(journal->state.current_state,
+		   VDO_ADMIN_STATE_NORMAL_OPERATION);
+}
+
+/**
+ * vdo_record_recovery_journal() - Record the state of a recovery journal for encoding in the super
+ *                                 block.
+ * @journal: the recovery journal.
+ *
+ * Return: the state of the journal.
+ */
+struct recovery_journal_state_7_0
+vdo_record_recovery_journal(const struct recovery_journal *journal)
+{
+	struct recovery_journal_state_7_0 state = {
+		.logical_blocks_used = journal->logical_blocks_used,
+		.block_map_data_blocks = journal->block_map_data_blocks,
+	};
+
+	if (vdo_is_state_saved(&journal->state))
+		/*
+		 * If the journal is saved, we should start one past the active block (since the
+		 * active block is not guaranteed to be empty).
+		 */
+		state.journal_start = journal->tail;
+	else
+		/*
+		 * When we're merely suspended or have gone read-only, we must record the first
+		 * block that might have entries that need to be applied.
+		 */
+		state.journal_start = get_recovery_journal_head(journal);
+
+	return state;
+}
+
+/**
+ * get_block_header() - Get a pointer to the packed journal block header in the block buffer.
+ * @block: The recovery block.
+ *
+ * Return: The block's header.
+ */
+static inline struct packed_journal_header *
+get_block_header(const struct recovery_journal_block *block)
+{
+	return (struct packed_journal_header *) block->vio.data;
+}
+
+/**
+ * set_active_sector() - Set the current sector of the current block and initialize it.
+ * @block: The block to update.
+ * @sector: A pointer to the first byte of the new sector.
+ */
+static void set_active_sector(struct recovery_journal_block *block, void *sector)
+{
+	block->sector = (struct packed_journal_sector *) sector;
+	block->sector->check_byte = get_block_header(block)->check_byte;
+	block->sector->recovery_count = block->journal->recovery_count;
+	block->sector->entry_count = 0;
+}
+
+/**
+ * advance_tail() - Advance the tail of the journal.
+ * @journal: The journal whose tail should be advanced.
+ *
+ * Return: true if the tail was advanced.
+ */
+static bool advance_tail(struct recovery_journal *journal)
+{
+	struct recovery_block_header unpacked;
+	struct packed_journal_header *header;
+	struct recovery_journal_block *block;
+
+	block = journal->active_block = pop_free_list(journal);
+	if (block == NULL)
+		return false;
+
+	list_move_tail(&block->list_node, &journal->active_tail_blocks);
+
+	unpacked = (struct recovery_block_header) {
+		.metadata_type = VDO_METADATA_RECOVERY_JOURNAL_2,
+		.block_map_data_blocks = journal->block_map_data_blocks,
+		.logical_blocks_used = journal->logical_blocks_used,
+		.nonce = journal->nonce,
+		.recovery_count = journal->recovery_count,
+		.sequence_number = journal->tail,
+		.check_byte = vdo_compute_recovery_journal_check_byte(journal, journal->tail),
+	};
+
+	header = get_block_header(block);
+	memset(block->vio.data, 0x0, VDO_BLOCK_SIZE);
+	block->sequence_number = journal->tail;
+	block->entry_count = 0;
+	block->uncommitted_entry_count = 0;
+	block->block_number = vdo_get_recovery_journal_block_number(journal, journal->tail);
+
+	vdo_pack_recovery_block_header(&unpacked, header);
+	set_active_sector(block, vdo_get_journal_block_sector(header, 1));
+	set_journal_tail(journal, journal->tail + 1);
+	vdo_advance_block_map_era(journal->block_map, journal->tail);
+	return true;
+}
+
+/**
+ * initialize_lock_count() - Initialize the value of the journal zone's counter for a given lock.
+ * @journal: The recovery journal.
+ *
+ * Context: This must be called from the journal zone.
+ */
+static void initialize_lock_count(struct recovery_journal *journal)
+{
+	u16 *journal_value;
+	block_count_t lock_number = journal->active_block->block_number;
+	atomic_t *decrement_counter = get_decrement_counter(journal, lock_number);
+
+	journal_value = get_counter(journal, lock_number, VDO_ZONE_TYPE_JOURNAL, 0);
+	ASSERT_LOG_ONLY((*journal_value == atomic_read(decrement_counter)),
+			"count to be initialized not in use");
+	*journal_value = journal->entries_per_block + 1;
+	atomic_set(decrement_counter, 0);
+}
+
+/**
+ * prepare_to_assign_entry() - Prepare the currently active block to receive an entry and check
+ *			       whether an entry of the given type may be assigned at this time.
+ * @journal: The journal receiving an entry.
+ *
+ * Return: true if there is space in the journal to store an entry of the specified type.
+ */
+static bool prepare_to_assign_entry(struct recovery_journal *journal)
+{
+	if (journal->available_space == 0)
+		return false;
+
+	if (is_block_full(journal->active_block) && !advance_tail(journal))
+		return false;
+
+	if (!is_block_empty(journal->active_block))
+		return true;
+
+	if ((journal->tail - get_recovery_journal_head(journal)) > journal->size) {
+		/* Cannot use this block since the journal is full. */
+		journal->events.disk_full++;
+		return false;
+	}
+
+	/*
+	 * Don't allow the new block to be reaped until all of its entries have been committed to
+	 * the block map and until the journal block has been fully committed as well. Because the
+	 * block map update is done only after any slab journal entries have been made, the
+	 * per-entry lock for the block map entry serves to protect those as well.
+	 */
+	initialize_lock_count(journal);
+	return true;
+}
+
+static void write_blocks(struct recovery_journal *journal);
+
+/**
+ * schedule_block_write() - Queue a block for writing.
+ * @journal: The journal in question.
+ * @block: The block which is now ready to write.
+ *
+ * The block is expected to be full. If the block is currently writing, this is a noop as the block
+ * will be queued for writing when the write finishes. The block must not currently be queued for
+ * writing.
+ */
+static void
+schedule_block_write(struct recovery_journal *journal, struct recovery_journal_block *block)
+{
+	if (!block->committing)
+		vdo_enqueue_waiter(&journal->pending_writes, &block->write_waiter);
+	/*
+	 * At the end of adding entries, or discovering this partial block is now full and ready to
+	 * rewrite, we will call write_blocks() and write a whole batch.
+	 */
+}
+
+/**
+ * release_journal_block_reference() - Release a reference to a journal block.
+ * @block: The journal block from which to release a reference.
+ */
+static void release_journal_block_reference(struct recovery_journal_block *block)
+{
+	vdo_release_recovery_journal_block_reference(block->journal,
+						     block->sequence_number,
+						     VDO_ZONE_TYPE_JOURNAL,
+						     0);
+}
+
+static void update_usages(struct recovery_journal *journal, struct data_vio *data_vio)
+{
+	if (data_vio->increment_updater.operation == VDO_JOURNAL_BLOCK_MAP_REMAPPING) {
+		journal->block_map_data_blocks++;
+		return;
+	}
+
+	if (data_vio->new_mapped.state != VDO_MAPPING_STATE_UNMAPPED)
+		journal->logical_blocks_used++;
+
+	if (data_vio->mapped.state != VDO_MAPPING_STATE_UNMAPPED)
+		journal->logical_blocks_used--;
+}
+
+/**
+ * assign_entry() - Assign an entry waiter to the active block.
+ *
+ * Implements waiter_callback.
+ */
+static void assign_entry(struct waiter *waiter, void *context)
+{
+	struct data_vio *data_vio = waiter_as_data_vio(waiter);
+	struct recovery_journal_block *block = (struct recovery_journal_block *) context;
+	struct recovery_journal *journal = block->journal;
+
+	/* Record the point at which we will make the journal entry. */
+	data_vio->recovery_journal_point = (struct journal_point) {
+		.sequence_number = block->sequence_number,
+		.entry_count = block->entry_count,
+	};
+
+	update_usages(journal, data_vio);
+	journal->available_space--;
+
+	if (!vdo_has_waiters(&block->entry_waiters))
+		journal->events.blocks.started++;
+
+	vdo_enqueue_waiter(&block->entry_waiters, &data_vio->waiter);
+	block->entry_count++;
+	block->uncommitted_entry_count++;
+	journal->events.entries.started++;
+
+	if (is_block_full(block))
+		/*
+		 * The block is full, so we can write it anytime henceforth. If it is already
+		 * committing, we'll queue it for writing when it comes back.
+		 */
+		schedule_block_write(journal, block);
+
+	/* Force out slab journal tail blocks when threshold is reached. */
+	check_slab_journal_commit_threshold(journal);
+}
+
+static void assign_entries(struct recovery_journal *journal)
+{
+	if (journal->adding_entries)
+		/* Protect against re-entrancy. */
+		return;
+
+	journal->adding_entries = true;
+	while (vdo_has_waiters(&journal->entry_waiters) && prepare_to_assign_entry(journal))
+		vdo_notify_next_waiter(&journal->entry_waiters,
+				       assign_entry,
+				       journal->active_block);
+
+	/* Now that we've finished with entries, see if we have a batch of blocks to write. */
+	write_blocks(journal);
+	journal->adding_entries = false;
+}
+
+/**
+ * recycle_journal_block() - Prepare an in-memory journal block to be reused now that it has been
+ *                           fully committed.
+ * @block: The block to be recycled.
+ */
+static void recycle_journal_block(struct recovery_journal_block *block)
+{
+	struct recovery_journal *journal = block->journal;
+	block_count_t i;
+
+	list_move_tail(&block->list_node, &journal->free_tail_blocks);
+
+	/* Release any unused entry locks. */
+	for (i = block->entry_count; i < journal->entries_per_block; i++)
+		release_journal_block_reference(block);
+
+	/*
+	 * Release our own lock against reaping now that the block is completely committed, or
+	 * we're giving up because we're in read-only mode.
+	 */
+	if (block->entry_count > 0)
+		release_journal_block_reference(block);
+
+	if (block == journal->active_block)
+		journal->active_block = NULL;
+}
+
+/**
+ * continue_committed_waiter() - invoked whenever a VIO is to be released from the journal because
+ *                               its entry was committed to disk.
+ *
+ * Implements waiter_callback.
+ */
+static void continue_committed_waiter(struct waiter *waiter, void *context)
+{
+	struct data_vio *data_vio = waiter_as_data_vio(waiter);
+	struct recovery_journal *journal = (struct recovery_journal *)context;
+	int result = (is_read_only(journal) ? VDO_READ_ONLY : VDO_SUCCESS);
+	bool has_decrement;
+
+	ASSERT_LOG_ONLY(vdo_before_journal_point(&journal->commit_point,
+						 &data_vio->recovery_journal_point),
+			"DataVIOs released from recovery journal in order. Recovery journal point is (%llu, %u), but commit waiter point is (%llu, %u)",
+			(unsigned long long) journal->commit_point.sequence_number,
+			journal->commit_point.entry_count,
+			(unsigned long long) data_vio->recovery_journal_point.sequence_number,
+			data_vio->recovery_journal_point.entry_count);
+
+	journal->commit_point = data_vio->recovery_journal_point;
+	data_vio->last_async_operation = VIO_ASYNC_OP_UPDATE_REFERENCE_COUNTS;
+	if (result != VDO_SUCCESS) {
+		continue_data_vio_with_error(data_vio, result);
+		return;
+	}
+
+	/*
+	 * The increment must be launched first since it must come before the
+	 * decrement if they are in the same slab.
+	 */
+	has_decrement = (data_vio->decrement_updater.zpbn.pbn != VDO_ZERO_BLOCK);
+	if ((data_vio->increment_updater.zpbn.pbn != VDO_ZERO_BLOCK) || !has_decrement)
+		continue_data_vio(data_vio);
+
+	if (has_decrement)
+		vdo_launch_completion(&data_vio->decrement_completion);
+}
+
+/**
+ * notify_commit_waiters() - Notify any VIOs whose entries have now committed.
+ * @journal: The recovery journal to update.
+ */
+static void notify_commit_waiters(struct recovery_journal *journal)
+{
+	struct recovery_journal_block *block;
+
+	list_for_each_entry(block, &journal->active_tail_blocks, list_node) {
+		if (block->committing)
+			return;
+
+		vdo_notify_all_waiters(&block->commit_waiters, continue_committed_waiter, journal);
+		if (is_read_only(journal))
+			vdo_notify_all_waiters(&block->entry_waiters,
+					       continue_committed_waiter,
+					       journal);
+		else if (is_block_dirty(block) || !is_block_full(block))
+			/* Stop at partially-committed or partially-filled blocks. */
+			return;
+	}
+}
+
+/**
+ * recycle_journal_blocks() - Recycle any journal blocks which have been fully committed.
+ * @journal: The recovery journal to update.
+ */
+static void recycle_journal_blocks(struct recovery_journal *journal)
+{
+	struct recovery_journal_block *block, *tmp;
+
+	list_for_each_entry_safe(block, tmp, &journal->active_tail_blocks, list_node) {
+		if (block->committing)
+			/* Don't recycle committing blocks. */
+			return;
+
+		if (!is_read_only(journal) && (is_block_dirty(block) || !is_block_full(block)))
+			/*
+			 * Don't recycle partially written or partially full blocks, except in
+			 * read-only mode.
+			 */
+			return;
+
+		recycle_journal_block(block);
+	}
+}
+
+/**
+ * complete_write() - Handle post-commit processing.
+ * @completion: The completion of the VIO writing this block.
+ *
+ * This is the callback registered by write_block(). If more entries accumulated in the block being
+ * committed while the commit was in progress, another commit will be initiated.
+ */
+static void complete_write(struct vdo_completion *completion)
+{
+	struct recovery_journal_block *block = completion->parent;
+	struct recovery_journal *journal = block->journal;
+	struct recovery_journal_block *last_active_block;
+
+	assert_on_journal_thread(journal, __func__);
+
+	journal->pending_write_count -= 1;
+	journal->events.blocks.committed += 1;
+	journal->events.entries.committed += block->entries_in_commit;
+	block->uncommitted_entry_count -= block->entries_in_commit;
+	block->entries_in_commit = 0;
+	block->committing = false;
+
+	/* If this block is the latest block to be acknowledged, record that fact. */
+	if (block->sequence_number > journal->last_write_acknowledged)
+		journal->last_write_acknowledged = block->sequence_number;
+
+	last_active_block = get_journal_block(&journal->active_tail_blocks);
+	ASSERT_LOG_ONLY((block->sequence_number >= last_active_block->sequence_number),
+			"completed journal write is still active");
+
+	notify_commit_waiters(journal);
+
+	/*
+	 * Is this block now full? Reaping, and adding entries, might have already sent it off for
+	 * rewriting; else, queue it for rewrite.
+	 */
+	if (is_block_dirty(block) && is_block_full(block))
+		schedule_block_write(journal, block);
+
+	recycle_journal_blocks(journal);
+	write_blocks(journal);
+
+	check_for_drain_complete(journal);
+}
+
+static void handle_write_error(struct vdo_completion *completion)
+{
+	struct recovery_journal_block *block = completion->parent;
+	struct recovery_journal *journal = block->journal;
+
+	vio_record_metadata_io_error(as_vio(completion));
+	uds_log_error_strerror(completion->result,
+			       "cannot write recovery journal block %llu",
+			       (unsigned long long) block->sequence_number);
+	enter_journal_read_only_mode(journal, completion->result);
+	complete_write(completion);
+}
+
+static void complete_write_endio(struct bio *bio)
+{
+	struct vio *vio = bio->bi_private;
+	struct recovery_journal_block *block = vio->completion.parent;
+	struct recovery_journal *journal = block->journal;
+
+	continue_vio_after_io(vio, complete_write, journal->thread_id);
+}
+
+/**
+ * add_queued_recovery_entries() - Actually add entries from the queue to the given block.
+ * @block: The journal block.
+ */
+static void add_queued_recovery_entries(struct recovery_journal_block *block)
+{
+	while (vdo_has_waiters(&block->entry_waiters)) {
+		struct data_vio *data_vio =
+			waiter_as_data_vio(vdo_dequeue_next_waiter(&block->entry_waiters));
+		struct tree_lock *lock = &data_vio->tree_lock;
+		struct packed_recovery_journal_entry *packed_entry;
+		struct recovery_journal_entry new_entry;
+
+		if (block->sector->entry_count == RECOVERY_JOURNAL_ENTRIES_PER_SECTOR)
+			set_active_sector(block, (char *) block->sector + VDO_SECTOR_SIZE);
+
+		/* Compose and encode the entry. */
+		packed_entry = &block->sector->entries[block->sector->entry_count++];
+		new_entry = (struct recovery_journal_entry) {
+			.mapping = {
+				.pbn = data_vio->increment_updater.zpbn.pbn,
+				.state = data_vio->increment_updater.zpbn.state,
+			},
+			.unmapping = {
+				.pbn = data_vio->decrement_updater.zpbn.pbn,
+				.state = data_vio->decrement_updater.zpbn.state,
+			},
+			.operation = data_vio->increment_updater.operation,
+			.slot = lock->tree_slots[lock->height].block_map_slot,
+		};
+		*packed_entry = vdo_pack_recovery_journal_entry(&new_entry);
+		data_vio->recovery_sequence_number = block->sequence_number;
+
+		/* Enqueue the data_vio to wait for its entry to commit. */
+		vdo_enqueue_waiter(&block->commit_waiters, &data_vio->waiter);
+	}
+}
+
+/**
+ * write_block() - Issue a block for writing.
+ *
+ * Implements waiter_callback.
+ */
+static void write_block(struct waiter *waiter, void *context __always_unused)
+{
+	struct recovery_journal_block *block =
+		container_of(waiter, struct recovery_journal_block, write_waiter);
+	struct recovery_journal *journal = block->journal;
+	struct packed_journal_header *header = get_block_header(block);
+
+	if (block->committing || !vdo_has_waiters(&block->entry_waiters) || is_read_only(journal))
+		return;
+
+	block->entries_in_commit = vdo_count_waiters(&block->entry_waiters);
+	add_queued_recovery_entries(block);
+
+	journal->pending_write_count += 1;
+	journal->events.blocks.written += 1;
+	journal->events.entries.written += block->entries_in_commit;
+
+	header->block_map_head = __cpu_to_le64(journal->block_map_head);
+	header->slab_journal_head = __cpu_to_le64(journal->slab_journal_head);
+	header->entry_count = __cpu_to_le16(block->entry_count);
+
+	block->committing = true;
+
+	/*
+	 * We must issue a flush and a FUA for every commit. The flush is necessary to ensure that
+	 * the data being referenced is stable. The FUA is necessary to ensure that the journal
+	 * block itself is stable before allowing overwrites of the lbn's previous data.
+	 */
+	submit_metadata_vio(&block->vio,
+			    journal->origin + block->block_number,
+			    complete_write_endio,
+			    handle_write_error,
+			    WRITE_FLAGS);
+}
+
+
+/**
+ * write_blocks() - Attempt to commit blocks, according to write policy.
+ * @journal: The recovery journal.
+ */
+static void write_blocks(struct recovery_journal *journal)
+{
+	assert_on_journal_thread(journal, __func__);
+	/*
+	 * We call this function after adding entries to the journal and after finishing a block
+	 * write. Thus, when this function terminates we must either have no VIOs waiting in the
+	 * journal or have some outstanding IO to provide a future wakeup.
+	 *
+	 * We want to only issue full blocks if there are no pending writes. However, if there are
+	 * no outstanding writes and some unwritten entries, we must issue a block, even if it's
+	 * the active block and it isn't full.
+	 */
+	if (journal->pending_write_count > 0)
+		return;
+
+	/* Write all the full blocks. */
+	vdo_notify_all_waiters(&journal->pending_writes, write_block, NULL);
+
+	/*
+	 * Do we need to write the active block? Only if we have no outstanding writes, even after
+	 * issuing all of the full writes.
+	 */
+	if ((journal->pending_write_count == 0) && (journal->active_block != NULL))
+		write_block(&journal->active_block->write_waiter, NULL);
+}
+
+/**
+ * vdo_add_recovery_journal_entry() - Add an entry to a recovery journal.
+ * @journal: The journal in which to make an entry.
+ * @data_vio: The data_vio for which to add the entry. The entry will be taken
+ *	      from the logical and new_mapped fields of the data_vio. The
+ *	      data_vio's recovery_sequence_number field will be set to the
+ *	      sequence number of the journal block in which the entry was
+ *	      made.
+ *
+ * This method is asynchronous. The data_vio will not be called back until the entry is committed
+ * to the on-disk journal.
+ */
+void vdo_add_recovery_journal_entry(struct recovery_journal *journal, struct data_vio *data_vio)
+{
+	assert_on_journal_thread(journal, __func__);
+	if (!vdo_is_state_normal(&journal->state)) {
+		continue_data_vio_with_error(data_vio, VDO_INVALID_ADMIN_STATE);
+		return;
+	}
+
+	if (is_read_only(journal)) {
+		continue_data_vio_with_error(data_vio, VDO_READ_ONLY);
+		return;
+	}
+
+	ASSERT_LOG_ONLY(data_vio->recovery_sequence_number == 0,
+			"journal lock not held for new entry");
+
+	vdo_advance_journal_point(&journal->append_point, journal->entries_per_block);
+	vdo_enqueue_waiter(&journal->entry_waiters, &data_vio->waiter);
+	assign_entries(journal);
+}
+
+/**
+ * is_lock_locked() - Check whether a lock is locked for a zone type.
+ * @journal: The recovery journal.
+ * @lock_number: The lock to check.
+ * @zone_type: The type of the zone.
+ *
+ * If the recovery journal has a lock on the lock number, both logical and physical zones are
+ * considered locked.
+ *
+ * Return: true if the specified lock has references (is locked).
+ */
+static bool
+is_lock_locked(struct recovery_journal *journal,
+	       block_count_t lock_number,
+	       enum vdo_zone_type zone_type)
+{
+	atomic_t *zone_count;
+	bool locked;
+
+	if (is_journal_zone_locked(journal, lock_number))
+		return true;
+
+	zone_count = get_zone_count_ptr(journal, lock_number, zone_type);
+	locked = (atomic_read(zone_count) != 0);
+	/* Pairs with implicit barrier in vdo_release_recovery_journal_block_reference() */
+	smp_rmb();
+	return locked;
+}
+
+/**
+ * reap_recovery_journal() - Conduct a sweep on a recovery journal to reclaim unreferenced blocks.
+ * @journal: The recovery journal.
+ */
+static void reap_recovery_journal(struct recovery_journal *journal)
+{
+	if (journal->reaping)
+		/*
+		 * We already have an outstanding reap in progress. We need to wait for it to
+		 * finish.
+		 */
+		return;
+
+	if (vdo_is_state_quiescent(&journal->state))
+		/* We are supposed to not do IO. Don't botch it by reaping. */
+		return;
+
+	/*
+	 * Start reclaiming blocks only when the journal head has no references. Then stop when a
+	 * block is referenced.
+	 */
+	while ((journal->block_map_reap_head < journal->last_write_acknowledged) &&
+		!is_lock_locked(journal,
+				journal->block_map_head_block_number,
+				VDO_ZONE_TYPE_LOGICAL)) {
+		journal->block_map_reap_head++;
+		if (++journal->block_map_head_block_number == journal->size)
+			journal->block_map_head_block_number = 0;
+	}
+
+	while ((journal->slab_journal_reap_head < journal->last_write_acknowledged) &&
+		!is_lock_locked(journal,
+				journal->slab_journal_head_block_number,
+				VDO_ZONE_TYPE_PHYSICAL)) {
+		journal->slab_journal_reap_head++;
+		if (++journal->slab_journal_head_block_number == journal->size)
+			journal->slab_journal_head_block_number = 0;
+	}
+
+	if ((journal->block_map_reap_head == journal->block_map_head) &&
+	    (journal->slab_journal_reap_head == journal->slab_journal_head))
+		/* Nothing happened. */
+		return;
+
+	/*
+	 * If the block map head will advance, we must flush any block map page modified by the
+	 * entries we are reaping. If the slab journal head will advance, we must flush the slab
+	 * summary update covering the slab journal that just released some lock.
+	 */
+	journal->reaping = true;
+	submit_flush_vio(journal->flush_vio, flush_endio, handle_flush_error);
+}
+
+/**
+ * vdo_acquire_recovery_journal_block_reference() - Acquire a reference to a recovery journal block
+ *                                                  from somewhere other than the journal itself.
+ * @journal: The recovery journal.
+ * @sequence_number: The journal sequence number of the referenced block.
+ * @zone_type: The type of the zone making the adjustment.
+ * @zone_id: The ID of the zone making the adjustment.
+ */
+void vdo_acquire_recovery_journal_block_reference(struct recovery_journal *journal,
+						  sequence_number_t sequence_number,
+						  enum vdo_zone_type zone_type,
+						  zone_count_t zone_id)
+{
+	block_count_t lock_number;
+	u16 *current_value;
+
+	if (sequence_number == 0)
+		return;
+
+	ASSERT_LOG_ONLY((zone_type != VDO_ZONE_TYPE_JOURNAL),
+			"invalid lock count increment from journal zone");
+
+	lock_number = vdo_get_recovery_journal_block_number(journal, sequence_number);
+	current_value = get_counter(journal, lock_number, zone_type, zone_id);
+	ASSERT_LOG_ONLY(*current_value < U16_MAX,
+			"increment of lock counter must not overflow");
+
+	if (*current_value == 0) {
+		/*
+		 * This zone is acquiring this lock for the first time. Extra barriers because this
+		 * was original developed using an atomic add operation that implicitly had them.
+		 */
+		smp_mb__before_atomic();
+		atomic_inc(get_zone_count_ptr(journal, lock_number, zone_type));
+		/* same as before_atomic */
+		smp_mb__after_atomic();
+	}
+	*current_value += 1;
+}
+
+/**
+ * vdo_release_journal_entry_lock() - Release a single per-entry reference count for a recovery
+ *                                    journal block.
+ * @journal: The recovery journal.
+ * @sequence_number: The journal sequence number of the referenced block.
+ */
+void vdo_release_journal_entry_lock(struct recovery_journal *journal,
+				    sequence_number_t sequence_number)
+{
+	block_count_t lock_number;
+
+	if (sequence_number == 0)
+		return;
+
+	lock_number = vdo_get_recovery_journal_block_number(journal, sequence_number);
+	/*
+	 * Extra barriers because this was originally developed using an atomic add operation that
+	 * implicitly had them.
+	 */
+	smp_mb__before_atomic();
+	atomic_inc(get_decrement_counter(journal, lock_number));
+	/* same as before_atomic */
+	smp_mb__after_atomic();
+}
+
+/**
+ * initiate_drain() - Initiate a drain.
+ *
+ * Implements vdo_admin_initiator.
+ */
+static void initiate_drain(struct admin_state *state)
+{
+	check_for_drain_complete(container_of(state, struct recovery_journal, state));
+}
+
+/**
+ * vdo_drain_recovery_journal() - Drain recovery journal I/O.
+ * @journal: The journal to drain.
+ * @operation: The drain operation (suspend or save).
+ * @parent: The completion to notify once the journal is drained.
+ *
+ * All uncommitted entries will be written out.
+ */
+void vdo_drain_recovery_journal(struct recovery_journal *journal,
+				const struct admin_state_code *operation,
+				struct vdo_completion *parent)
+{
+	assert_on_journal_thread(journal, __func__);
+	vdo_start_draining(&journal->state, operation, parent, initiate_drain);
+}
+
+/**
+ * resume_lock_counter() - Re-allow notifications from a suspended lock counter.
+ * @counter: The counter.
+ *
+ * Return: true if the lock counter was suspended.
+ */
+static bool resume_lock_counter(struct lock_counter *counter)
+{
+	int prior_state;
+
+	/*
+	 * Extra barriers because this was original developed using a CAS operation that implicitly
+	 * had them.
+	 */
+	smp_mb__before_atomic();
+	prior_state = atomic_cmpxchg(&counter->state,
+				     LOCK_COUNTER_STATE_SUSPENDED,
+				     LOCK_COUNTER_STATE_NOT_NOTIFYING);
+	/* same as before_atomic */
+	smp_mb__after_atomic();
+
+	return (prior_state == LOCK_COUNTER_STATE_SUSPENDED);
+}
+
+/**
+ * vdo_resume_recovery_journal() - Resume a recovery journal which has been drained.
+ * @journal: The journal to resume.
+ * @parent: The completion to finish once the journal is resumed.
+ */
+void vdo_resume_recovery_journal(struct recovery_journal *journal, struct vdo_completion *parent)
+{
+	bool saved;
+
+	assert_on_journal_thread(journal, __func__);
+	saved = vdo_is_state_saved(&journal->state);
+	vdo_set_completion_result(parent, vdo_resume_if_quiescent(&journal->state));
+	if (is_read_only(journal)) {
+		vdo_continue_completion(parent, VDO_READ_ONLY);
+		return;
+	}
+
+	if (saved)
+		initialize_journal_state(journal);
+
+	if (resume_lock_counter(&journal->lock_counter))
+		/* We might have missed a notification. */
+		reap_recovery_journal(journal);
+
+	vdo_launch_completion(parent);
+}
+
+/**
+ * vdo_get_recovery_journal_logical_blocks_used() - Get the number of logical blocks in use by the
+ *                                                  VDO.
+ * @journal: The journal.
+ *
+ * Return: The number of logical blocks in use by the VDO.
+ */
+block_count_t vdo_get_recovery_journal_logical_blocks_used(const struct recovery_journal *journal)
+{
+	return journal->logical_blocks_used;
+}
+
+/**
+ * vdo_get_recovery_journal_statistics() - Get the current statistics from the recovery journal.
+ * @journal: The recovery journal to query.
+ *
+ * Return: A copy of the current statistics for the journal.
+ */
+struct recovery_journal_statistics
+vdo_get_recovery_journal_statistics(const struct recovery_journal *journal)
+{
+	return journal->events;
+}
+
+/**
+ * dump_recovery_block() - Dump the contents of the recovery block to the log.
+ * @block: The block to dump.
+ */
+static void dump_recovery_block(const struct recovery_journal_block *block)
+{
+	uds_log_info("    sequence number %llu; entries %u; %s; %zu entry waiters; %zu commit waiters",
+		     (unsigned long long) block->sequence_number,
+		     block->entry_count,
+		     (block->committing ? "committing" : "waiting"),
+		     vdo_count_waiters(&block->entry_waiters),
+		     vdo_count_waiters(&block->commit_waiters));
+}
+
+/**
+ * vdo_dump_recovery_journal_statistics() - Dump some current statistics and other debug info from
+ *                                          the recovery journal.
+ * @journal: The recovery journal to dump.
+ */
+void vdo_dump_recovery_journal_statistics(const struct recovery_journal *journal)
+{
+	const struct recovery_journal_block *block;
+	struct recovery_journal_statistics stats = vdo_get_recovery_journal_statistics(journal);
+
+	uds_log_info("Recovery Journal");
+	uds_log_info("	block_map_head=%llu slab_journal_head=%llu last_write_acknowledged=%llu tail=%llu block_map_reap_head=%llu slab_journal_reap_head=%llu disk_full=%llu slab_journal_commits_requested=%llu entry_waiters=%zu",
+		     (unsigned long long) journal->block_map_head,
+		     (unsigned long long) journal->slab_journal_head,
+		     (unsigned long long) journal->last_write_acknowledged,
+		     (unsigned long long) journal->tail,
+		     (unsigned long long) journal->block_map_reap_head,
+		     (unsigned long long) journal->slab_journal_reap_head,
+		     (unsigned long long) stats.disk_full,
+		     (unsigned long long) stats.slab_journal_commits_requested,
+		     vdo_count_waiters(&journal->entry_waiters));
+	uds_log_info("	entries: started=%llu written=%llu committed=%llu",
+		     (unsigned long long) stats.entries.started,
+		     (unsigned long long) stats.entries.written,
+		     (unsigned long long) stats.entries.committed);
+	uds_log_info("	blocks: started=%llu written=%llu committed=%llu",
+		     (unsigned long long) stats.blocks.started,
+		     (unsigned long long) stats.blocks.written,
+		     (unsigned long long) stats.blocks.committed);
+
+	uds_log_info("	active blocks:");
+	list_for_each_entry(block, &journal->active_tail_blocks, list_node)
+		dump_recovery_block(block);
+}
diff --git a/drivers/md/dm-vdo/recovery-journal.h b/drivers/md/dm-vdo/recovery-journal.h
new file mode 100644
index 000000000000..8c22493e4f21
--- /dev/null
+++ b/drivers/md/dm-vdo/recovery-journal.h
@@ -0,0 +1,313 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#ifndef VDO_RECOVERY_JOURNAL_H
+#define VDO_RECOVERY_JOURNAL_H
+
+#include <linux/list.h>
+
+#include "numeric.h"
+
+#include "admin-state.h"
+#include "constants.h"
+#include "encodings.h"
+#include "flush.h"
+#include "statistics.h"
+#include "types.h"
+#include "wait-queue.h"
+
+/**
+ * DOC: recovery journal.
+ *
+ * The recovery_journal provides a log of all block mapping and reference count changes which have
+ * not yet been stably written to the block map or slab journals. This log helps to reduce the
+ * write amplification of writes by providing amortization of slab journal and block map page
+ * updates.
+ *
+ * The journal consists of a set of on-disk blocks arranged as a circular log with monotonically
+ * increasing sequence numbers. Three sequence numbers serve to define the active extent of the
+ * journal. The 'head' is the oldest active block in the journal. The 'tail' is the end of the
+ * half-open interval containing the active blocks. 'active' is the number of the block actively
+ * receiving entries. In an empty journal, head == active == tail. Once any entries are added, tail
+ * = active + 1, and head may be any value in the interval [tail - size, active].
+ *
+ * The journal also contains a set of in-memory blocks which are used to buffer up entries until
+ * they can be committed. In general the number of in-memory blocks ('tail_buffer_count') will be
+ * less than the on-disk size. Each in-memory block is also a vdo_completion. Each in-memory block
+ * has a vio which is used to commit that block to disk. The vio's data is the on-disk
+ * representation of the journal block. In addition each in-memory block has a buffer which is used
+ * to accumulate entries while a partial commit of the block is in progress. In-memory blocks are
+ * kept on two rings. Free blocks live on the 'free_tail_blocks' ring. When a block becomes active
+ * (see below) it is moved to the 'active_tail_blocks' ring. When a block is fully committed, it is
+ * moved back to the 'free_tail_blocks' ring.
+ *
+ * When entries are added to the journal, they are added to the active in-memory block, as
+ * indicated by the 'active_block' field. If the caller wishes to wait for the entry to be
+ * committed, the requesting VIO will be attached to the in-memory block to which the caller's
+ * entry was added. If the caller does wish to wait, or if the entry filled the active block, an
+ * attempt will be made to commit that block to disk. If there is already another commit in
+ * progress, the attempt will be ignored and then automatically retried when the in-progress commit
+ * completes. If there is no commit in progress, any data_vios waiting on the block are transferred
+ * to the block's vio which is then written, automatically waking all of the waiters when it
+ * completes. When the write completes, any entries which accumulated in the block are copied to
+ * the vio's data buffer.
+ *
+ * Finally, the journal maintains a set of counters, one for each on disk journal block. These
+ * counters are used as locks to prevent premature reaping of journal blocks. Each time a new
+ * sequence number is used, the counter for the corresponding block is incremented. The counter is
+ * subsequently decremented when that block is filled and then committed for the last time. This
+ * prevents blocks from being reaped while they are still being updated. The counter is also
+ * incremented once for each entry added to a block, and decremented once each time the block map
+ * is updated in memory for that request. This prevents blocks from being reaped while their VIOs
+ * are still active. Finally, each in-memory block map page tracks the oldest journal block that
+ * contains entries corresponding to uncommitted updates to that block map page. Each time an
+ * in-memory block map page is updated, it checks if the journal block for the VIO is earlier than
+ * the one it references, in which case it increments the count on the earlier journal block and
+ * decrements the count on the later journal block, maintaining a lock on the oldest journal block
+ * containing entries for that page. When a block map page has been flushed from the cache, the
+ * counter for the journal block it references is decremented. Whenever the counter for the head
+ * block goes to 0, the head is advanced until it comes to a block whose counter is not 0 or until
+ * it reaches the active block. This is the mechanism for reclaiming journal space on disk.
+ *
+ * If there is no in-memory space when a VIO attempts to add an entry, the VIO will be attached to
+ * the 'commit_completion' and will be woken the next time a full block has committed. If there is
+ * no on-disk space when a VIO attempts to add an entry, the VIO will be attached to the
+ * 'reap_completion', and will be woken the next time a journal block is reaped.
+ */
+
+enum vdo_zone_type {
+	VDO_ZONE_TYPE_ADMIN,
+	VDO_ZONE_TYPE_JOURNAL,
+	VDO_ZONE_TYPE_LOGICAL,
+	VDO_ZONE_TYPE_PHYSICAL,
+};
+
+struct lock_counter {
+	/** The completion for notifying the owner of a lock release */
+	struct vdo_completion completion;
+	/** The number of logical zones which may hold locks */
+	zone_count_t logical_zones;
+	/** The number of physical zones which may hold locks */
+	zone_count_t physical_zones;
+	/** The number of locks */
+	block_count_t locks;
+	/** Whether the lock release notification is in flight */
+	atomic_t state;
+	/** The number of logical zones which hold each lock */
+	atomic_t *logical_zone_counts;
+	/** The number of physical zones which hold each lock */
+	atomic_t *physical_zone_counts;
+	/** The per-lock counts for the journal zone */
+	u16 *journal_counters;
+	/** The per-lock decrement counts for the journal zone */
+	atomic_t *journal_decrement_counts;
+	/** The per-zone, per-lock reference counts for logical zones */
+	u16 *logical_counters;
+	/** The per-zone, per-lock reference counts for physical zones */
+	u16 *physical_counters;
+};
+
+struct recovery_journal_block {
+	/* The doubly linked pointers for the free or active lists */
+	struct list_head list_node;
+	/* The waiter for the pending full block list */
+	struct waiter write_waiter;
+	/* The journal to which this block belongs */
+	struct recovery_journal *journal;
+	/* A pointer to the current sector in the packed block buffer */
+	struct packed_journal_sector *sector;
+	/* The vio for writing this block */
+	struct vio vio;
+	/* The sequence number for this block */
+	sequence_number_t sequence_number;
+	/* The location of this block in the on-disk journal */
+	physical_block_number_t block_number;
+	/* Whether this block is being committed */
+	bool committing;
+	/* The total number of entries in this block */
+	journal_entry_count_t entry_count;
+	/* The total number of uncommitted entries (queued or committing) */
+	journal_entry_count_t uncommitted_entry_count;
+	/* The number of new entries in the current commit */
+	journal_entry_count_t entries_in_commit;
+	/* The queue of vios which will make entries for the next commit */
+	struct wait_queue entry_waiters;
+	/* The queue of vios waiting for the current commit */
+	struct wait_queue commit_waiters;
+};
+
+struct recovery_journal {
+	/* The thread ID of the journal zone */
+	thread_id_t thread_id;
+	/* The slab depot which can hold locks on this journal */
+	struct slab_depot *depot;
+	/* The block map which can hold locks on this journal */
+	struct block_map *block_map;
+	/* The queue of vios waiting to make entries */
+	struct wait_queue entry_waiters;
+	/* The number of free entries in the journal */
+	u64 available_space;
+	/* The number of decrement entries which need to be made */
+	data_vio_count_t pending_decrement_count;
+	/* Whether the journal is adding entries from the increment or decrement waiters queues */
+	bool adding_entries;
+	/* The administrative state of the journal */
+	struct admin_state state;
+	/* Whether a reap is in progress */
+	bool reaping;
+	/* The location of the first journal block */
+	physical_block_number_t origin;
+	/* The oldest active block in the journal on disk for block map rebuild */
+	sequence_number_t block_map_head;
+	/* The oldest active block in the journal on disk for slab journal replay */
+	sequence_number_t slab_journal_head;
+	/* The newest block in the journal on disk to which a write has finished */
+	sequence_number_t last_write_acknowledged;
+	/* The end of the half-open interval of the active journal */
+	sequence_number_t tail;
+	/* The point at which the last entry will have been added */
+	struct journal_point append_point;
+	/* The journal point of the vio most recently released from the journal */
+	struct journal_point commit_point;
+	/* The nonce of the VDO */
+	nonce_t nonce;
+	/* The number of recoveries completed by the VDO */
+	u8 recovery_count;
+	/* The number of entries which fit in a single block */
+	journal_entry_count_t entries_per_block;
+	/* Unused in-memory journal blocks */
+	struct list_head free_tail_blocks;
+	/* In-memory journal blocks with records */
+	struct list_head active_tail_blocks;
+	/* A pointer to the active block (the one we are adding entries to now) */
+	struct recovery_journal_block *active_block;
+	/* Journal blocks that need writing */
+	struct wait_queue pending_writes;
+	/* The new block map reap head after reaping */
+	sequence_number_t block_map_reap_head;
+	/* The head block number for the block map rebuild range */
+	block_count_t block_map_head_block_number;
+	/* The new slab journal reap head after reaping */
+	sequence_number_t slab_journal_reap_head;
+	/* The head block number for the slab journal replay range */
+	block_count_t slab_journal_head_block_number;
+	/* The data-less vio, usable only for flushing */
+	struct vio *flush_vio;
+	/* The number of blocks in the on-disk journal */
+	block_count_t size;
+	/* The number of logical blocks that are in-use */
+	block_count_t logical_blocks_used;
+	/* The number of block map pages that are allocated */
+	block_count_t block_map_data_blocks;
+	/* The number of journal blocks written but not yet acknowledged */
+	block_count_t pending_write_count;
+	/* The threshold at which slab journal tail blocks will be written out */
+	block_count_t slab_journal_commit_threshold;
+	/* Counters for events in the journal that are reported as statistics */
+	struct recovery_journal_statistics events;
+	/* The locks for each on-disk block */
+	struct lock_counter lock_counter;
+	/* The tail blocks */
+	struct recovery_journal_block blocks[];
+};
+
+/**
+ * vdo_get_recovery_journal_block_number() - Get the physical block number for a given sequence
+ *                                           number.
+ * @journal: The journal.
+ * @sequence: The sequence number of the desired block.
+ *
+ * Return: The block number corresponding to the sequence number.
+ */
+static inline physical_block_number_t __must_check
+vdo_get_recovery_journal_block_number(const struct recovery_journal *journal,
+				      sequence_number_t sequence)
+{
+	/*
+	 * Since journal size is a power of two, the block number modulus can just be extracted
+	 * from the low-order bits of the sequence.
+	 */
+	return vdo_compute_recovery_journal_block_number(journal->size, sequence);
+}
+
+/**
+ * vdo_compute_recovery_journal_check_byte() - Compute the check byte for a given sequence number.
+ * @journal: The journal.
+ * @sequence: The sequence number.
+ *
+ * Return: The check byte corresponding to the sequence number.
+ */
+static inline u8 __must_check
+vdo_compute_recovery_journal_check_byte(const struct recovery_journal *journal,
+					sequence_number_t sequence)
+{
+	/* The check byte must change with each trip around the journal. */
+	return (((sequence / journal->size) & 0x7F) | 0x80);
+}
+
+int __must_check vdo_decode_recovery_journal(struct recovery_journal_state_7_0 state,
+					     nonce_t nonce,
+					     struct vdo *vdo,
+					     struct partition *partition,
+					     u64 recovery_count,
+					     block_count_t journal_size,
+					     struct recovery_journal **journal_ptr);
+
+void vdo_free_recovery_journal(struct recovery_journal *journal);
+
+void vdo_initialize_recovery_journal_post_repair(struct recovery_journal *journal,
+						 u64 recovery_count,
+						 sequence_number_t tail,
+						 block_count_t logical_blocks_used,
+						 block_count_t block_map_data_blocks);
+
+block_count_t __must_check
+vdo_get_journal_block_map_data_blocks_used(struct recovery_journal *journal);
+
+thread_id_t __must_check vdo_get_recovery_journal_thread_id(struct recovery_journal *journal);
+
+void vdo_open_recovery_journal(struct recovery_journal *journal,
+			       struct slab_depot *depot,
+			       struct block_map *block_map);
+
+sequence_number_t
+vdo_get_recovery_journal_current_sequence_number(struct recovery_journal *journal);
+
+block_count_t __must_check vdo_get_recovery_journal_length(block_count_t journal_size);
+
+struct recovery_journal_state_7_0 __must_check
+vdo_record_recovery_journal(const struct recovery_journal *journal);
+
+void vdo_add_recovery_journal_entry(struct recovery_journal *journal, struct data_vio *data_vio);
+
+void vdo_acquire_recovery_journal_block_reference(struct recovery_journal *journal,
+						  sequence_number_t sequence_number,
+						  enum vdo_zone_type zone_type,
+						  zone_count_t zone_id);
+
+void vdo_release_recovery_journal_block_reference(struct recovery_journal *journal,
+						  sequence_number_t sequence_number,
+						  enum vdo_zone_type zone_type,
+						  zone_count_t zone_id);
+
+void vdo_release_journal_entry_lock(struct recovery_journal *journal,
+				    sequence_number_t sequence_number);
+
+void vdo_drain_recovery_journal(struct recovery_journal *journal,
+				const struct admin_state_code *operation,
+				struct vdo_completion *parent);
+
+void vdo_resume_recovery_journal(struct recovery_journal *journal,
+				 struct vdo_completion *parent);
+
+block_count_t __must_check
+vdo_get_recovery_journal_logical_blocks_used(const struct recovery_journal *journal);
+
+struct recovery_journal_statistics __must_check
+vdo_get_recovery_journal_statistics(const struct recovery_journal *journal);
+
+void vdo_dump_recovery_journal_statistics(const struct recovery_journal *journal);
+
+#endif /* VDO_RECOVERY_JOURNAL_H */
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

