Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E165C7EE29
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 21:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684878493;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wGXRS4v5qLgLJpZ0aOLqDgT3aB+5nuUwWs/Xb/w1uug=;
	b=grIw/ERsbxrjdTWviuLi0hw7wpPrWMk9VhsNg9nm1lb3OzWiyKaPsjB3Up0oaSZ1Z8n461
	QsEQ3jwScZ/A9QNkd8/fr1HSeXkOHMHMNlaD2db2bxmaG3gURklQtSC1MOgUI2v7+38DdW
	VxnN627RgId8kSTPxBYoT3MOJu64dTo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-i5Pknsj2MkOpvztiLcGfpw-1; Tue, 23 May 2023 17:47:01 -0400
X-MC-Unique: i5Pknsj2MkOpvztiLcGfpw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C4251C0693E;
	Tue, 23 May 2023 21:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5750B9D73;
	Tue, 23 May 2023 21:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 452971946A45;
	Tue, 23 May 2023 21:46:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2899719465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 21:46:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0AAF2401026; Tue, 23 May 2023 21:46:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F3B2240107B
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:46:56 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7DFC1019CAC
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:46:55 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447--KV_FmEePm6SRwOy0JF0xQ-1; Tue, 23 May 2023 17:46:54 -0400
X-MC-Unique: -KV_FmEePm6SRwOy0JF0xQ-1
Received: by mail-qk1-f200.google.com with SMTP id
 af79cd13be357-75b131362e3so33506585a.0
 for <dm-devel@redhat.com>; Tue, 23 May 2023 14:46:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684878413; x=1687470413;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=4PoQn5CJ6lTYrqlWR1RDj23KwauZzAEoi/icFb7ebvU=;
 b=AQcpDmt4w4ze6Lm61G3gC/bL8JgGL4krD37iGNX1GmpXecGb+hVufFOVm8LK20gMeC
 /bTmRTssFjph/PKrRfBxntlTsOr9a5VE/pJBs6tuWxrEK2dEZzSDTz2WcrymI7y0hzwT
 xRIzKhKW9DQQZoPeu2B+HAXBHt0kY67zeMuQP186E8kZKdBLpwLF2UiFIaAXY4fYVXu0
 7KOYr/dQj1mIXTHuxNvbOfh1ZIgXWnZrEZIJXgE8Nk4NGvRa8Ax23jPDXXd3uMd3zuoh
 UFR7/Xbi5Ri58WCpKOKP6TOk+jnnj9wSUsuh5AhQEKwpel+75nbReGfhUzBP0b8TM6NT
 +7Ng==
X-Gm-Message-State: AC+VfDzOkBbR9XJyKjBg2YeLYSVoZa5ekCNYjSR5jd3a9WK7LbDbdFaE
 xi8Uo2ym+QZIg+12gskoUlI77mD9p9Wd8Ylq1hy5cAqhwer66aa4alOUG4Hparn30C8pc6tjR+a
 nW7v0VXG8RTBq57itLl/OQaYKOaQLSz39QwkV3NigwfdYr2iRZd8DpRWkcGzTeu2Zm7W45Tq+
X-Received: by 2002:a05:620a:8894:b0:75b:23a1:429 with SMTP id
 qk20-20020a05620a889400b0075b23a10429mr4348486qkn.63.1684878412592; 
 Tue, 23 May 2023 14:46:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Tk/4jY6rwvlVXVMAKfdsKgfNhIR9OB10RbjXX01rzPNE/Nk2C3edHQtsEfv9/e01lseHn5g==
X-Received: by 2002:a05:620a:8894:b0:75b:23a1:429 with SMTP id
 qk20-20020a05620a889400b0075b23a10429mr4348439qkn.63.1684878411192; 
 Tue, 23 May 2023 14:46:51 -0700 (PDT)
Received: from bf36-1.. (173-166-2-198-newengland.hfc.comcastbusiness.net.
 [173.166.2.198]) by smtp.gmail.com with ESMTPSA id
 f25-20020a05620a15b900b0075b196ae392sm1489722qkk.104.2023.05.23.14.46.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 14:46:50 -0700 (PDT)
From: "J. corwin Coburn" <corwin@redhat.com>
To: dm-devel@redhat.com,
	linux-block@vger.kernel.org
Date: Tue, 23 May 2023 17:45:36 -0400
Message-Id: <20230523214539.226387-37-corwin@redhat.com>
In-Reply-To: <20230523214539.226387-1-corwin@redhat.com>
References: <20230523214539.226387-1-corwin@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 36/39] Add sysfs support for setting vdo
 parameters and fetching statistics.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: J. corwin Coburn <corwin@redhat.com>
---
 drivers/md/dm-vdo/pool-sysfs-stats.c | 2063 ++++++++++++++++++++++++++
 drivers/md/dm-vdo/pool-sysfs.c       |  193 +++
 drivers/md/dm-vdo/pool-sysfs.h       |   19 +
 drivers/md/dm-vdo/sysfs.c            |   84 ++
 4 files changed, 2359 insertions(+)
 create mode 100644 drivers/md/dm-vdo/pool-sysfs-stats.c
 create mode 100644 drivers/md/dm-vdo/pool-sysfs.c
 create mode 100644 drivers/md/dm-vdo/pool-sysfs.h
 create mode 100644 drivers/md/dm-vdo/sysfs.c

diff --git a/drivers/md/dm-vdo/pool-sysfs-stats.c b/drivers/md/dm-vdo/pool-sysfs-stats.c
new file mode 100644
index 00000000000..411ea5c143a
--- /dev/null
+++ b/drivers/md/dm-vdo/pool-sysfs-stats.c
@@ -0,0 +1,2063 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include <linux/mutex.h>
+
+#include "logger.h"
+#include "string-utils.h"
+
+#include "dedupe.h"
+#include "pool-sysfs.h"
+#include "statistics.h"
+#include "vdo.h"
+
+struct pool_stats_attribute {
+	struct attribute attr;
+	ssize_t (*print)(struct vdo_statistics *stats, char *buf);
+};
+
+static ssize_t pool_stats_attr_show(struct kobject *directory,
+				    struct attribute *attr,
+				    char *buf)
+{
+	ssize_t size;
+	struct pool_stats_attribute *pool_stats_attr =
+		container_of(attr, struct pool_stats_attribute, attr);
+	struct vdo *vdo = container_of(directory, struct vdo, stats_directory);
+
+	if (pool_stats_attr->print == NULL)
+		return -EINVAL;
+
+	mutex_lock(&vdo->stats_mutex);
+	vdo_fetch_statistics(vdo, &vdo->stats_buffer);
+	size = pool_stats_attr->print(&vdo->stats_buffer, buf);
+	mutex_unlock(&vdo->stats_mutex);
+
+	return size;
+}
+
+const struct sysfs_ops vdo_pool_stats_sysfs_ops = {
+	.show = pool_stats_attr_show,
+	.store = NULL,
+};
+
+/* Number of blocks used for data */
+static ssize_t
+pool_stats_print_data_blocks_used(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->data_blocks_used);
+}
+
+static struct pool_stats_attribute pool_stats_attr_data_blocks_used = {
+	.attr = { .name = "data_blocks_used", .mode = 0444, },
+	.print = pool_stats_print_data_blocks_used,
+};
+
+/* Number of blocks used for VDO metadata */
+static ssize_t
+pool_stats_print_overhead_blocks_used(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->overhead_blocks_used);
+}
+
+static struct pool_stats_attribute pool_stats_attr_overhead_blocks_used = {
+	.attr = { .name = "overhead_blocks_used", .mode = 0444, },
+	.print = pool_stats_print_overhead_blocks_used,
+};
+
+/* Number of logical blocks that are currently mapped to physical blocks */
+static ssize_t
+pool_stats_print_logical_blocks_used(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->logical_blocks_used);
+}
+
+static struct pool_stats_attribute pool_stats_attr_logical_blocks_used = {
+	.attr = { .name = "logical_blocks_used", .mode = 0444, },
+	.print = pool_stats_print_logical_blocks_used,
+};
+
+/* number of physical blocks */
+static ssize_t
+pool_stats_print_physical_blocks(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->physical_blocks);
+}
+
+static struct pool_stats_attribute pool_stats_attr_physical_blocks = {
+	.attr = { .name = "physical_blocks", .mode = 0444, },
+	.print = pool_stats_print_physical_blocks,
+};
+
+/* number of logical blocks */
+static ssize_t
+pool_stats_print_logical_blocks(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->logical_blocks);
+}
+
+static struct pool_stats_attribute pool_stats_attr_logical_blocks = {
+	.attr = { .name = "logical_blocks", .mode = 0444, },
+	.print = pool_stats_print_logical_blocks,
+};
+
+/* Size of the block map page cache, in bytes */
+static ssize_t
+pool_stats_print_block_map_cache_size(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map_cache_size);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_cache_size = {
+	.attr = { .name = "block_map_cache_size", .mode = 0444, },
+	.print = pool_stats_print_block_map_cache_size,
+};
+
+/* The physical block size */
+static ssize_t
+pool_stats_print_block_size(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_size);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_size = {
+	.attr = { .name = "block_size", .mode = 0444, },
+	.print = pool_stats_print_block_size,
+};
+
+/* Number of times the VDO has successfully recovered */
+static ssize_t
+pool_stats_print_complete_recoveries(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->complete_recoveries);
+}
+
+static struct pool_stats_attribute pool_stats_attr_complete_recoveries = {
+	.attr = { .name = "complete_recoveries", .mode = 0444, },
+	.print = pool_stats_print_complete_recoveries,
+};
+
+/* Number of times the VDO has recovered from read-only mode */
+static ssize_t
+pool_stats_print_read_only_recoveries(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->read_only_recoveries);
+}
+
+static struct pool_stats_attribute pool_stats_attr_read_only_recoveries = {
+	.attr = { .name = "read_only_recoveries", .mode = 0444, },
+	.print = pool_stats_print_read_only_recoveries,
+};
+
+/* String describing the operating mode of the VDO */
+static ssize_t
+pool_stats_print_mode(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%s\n", stats->mode);
+}
+
+static struct pool_stats_attribute pool_stats_attr_mode = {
+	.attr = { .name = "mode", .mode = 0444, },
+	.print = pool_stats_print_mode,
+};
+
+/* Whether the VDO is in recovery mode */
+static ssize_t
+pool_stats_print_in_recovery_mode(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%d\n", stats->in_recovery_mode);
+}
+
+static struct pool_stats_attribute pool_stats_attr_in_recovery_mode = {
+	.attr = { .name = "in_recovery_mode", .mode = 0444, },
+	.print = pool_stats_print_in_recovery_mode,
+};
+
+/* What percentage of recovery mode work has been completed */
+static ssize_t
+pool_stats_print_recovery_percentage(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->recovery_percentage);
+}
+
+static struct pool_stats_attribute pool_stats_attr_recovery_percentage = {
+	.attr = { .name = "recovery_percentage", .mode = 0444, },
+	.print = pool_stats_print_recovery_percentage,
+};
+
+/* Number of compressed data items written since startup */
+static ssize_t
+pool_stats_print_packer_compressed_fragments_written(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->packer.compressed_fragments_written);
+}
+
+static struct pool_stats_attribute pool_stats_attr_packer_compressed_fragments_written = {
+	.attr = { .name = "packer_compressed_fragments_written", .mode = 0444, },
+	.print = pool_stats_print_packer_compressed_fragments_written,
+};
+
+/* Number of blocks containing compressed items written since startup */
+static ssize_t
+pool_stats_print_packer_compressed_blocks_written(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->packer.compressed_blocks_written);
+}
+
+static struct pool_stats_attribute pool_stats_attr_packer_compressed_blocks_written = {
+	.attr = { .name = "packer_compressed_blocks_written", .mode = 0444, },
+	.print = pool_stats_print_packer_compressed_blocks_written,
+};
+
+/* Number of VIOs that are pending in the packer */
+static ssize_t
+pool_stats_print_packer_compressed_fragments_in_packer(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->packer.compressed_fragments_in_packer);
+}
+
+static struct pool_stats_attribute pool_stats_attr_packer_compressed_fragments_in_packer = {
+	.attr = { .name = "packer_compressed_fragments_in_packer", .mode = 0444, },
+	.print = pool_stats_print_packer_compressed_fragments_in_packer,
+};
+
+/* The total number of slabs from which blocks may be allocated */
+static ssize_t
+pool_stats_print_allocator_slab_count(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->allocator.slab_count);
+}
+
+static struct pool_stats_attribute pool_stats_attr_allocator_slab_count = {
+	.attr = { .name = "allocator_slab_count", .mode = 0444, },
+	.print = pool_stats_print_allocator_slab_count,
+};
+
+/* The total number of slabs from which blocks have ever been allocated */
+static ssize_t
+pool_stats_print_allocator_slabs_opened(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->allocator.slabs_opened);
+}
+
+static struct pool_stats_attribute pool_stats_attr_allocator_slabs_opened = {
+	.attr = { .name = "allocator_slabs_opened", .mode = 0444, },
+	.print = pool_stats_print_allocator_slabs_opened,
+};
+
+/* The number of times since loading that a slab has been re-opened */
+static ssize_t
+pool_stats_print_allocator_slabs_reopened(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->allocator.slabs_reopened);
+}
+
+static struct pool_stats_attribute pool_stats_attr_allocator_slabs_reopened = {
+	.attr = { .name = "allocator_slabs_reopened", .mode = 0444, },
+	.print = pool_stats_print_allocator_slabs_reopened,
+};
+
+/* Number of times the on-disk journal was full */
+static ssize_t
+pool_stats_print_journal_disk_full(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->journal.disk_full);
+}
+
+static struct pool_stats_attribute pool_stats_attr_journal_disk_full = {
+	.attr = { .name = "journal_disk_full", .mode = 0444, },
+	.print = pool_stats_print_journal_disk_full,
+};
+
+/* Number of times the recovery journal requested slab journal commits. */
+static ssize_t
+pool_stats_print_journal_slab_journal_commits_requested(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->journal.slab_journal_commits_requested);
+}
+
+static struct pool_stats_attribute pool_stats_attr_journal_slab_journal_commits_requested = {
+	.attr = { .name = "journal_slab_journal_commits_requested", .mode = 0444, },
+	.print = pool_stats_print_journal_slab_journal_commits_requested,
+};
+
+/* The total number of items on which processing has started */
+static ssize_t
+pool_stats_print_journal_entries_started(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->journal.entries.started);
+}
+
+static struct pool_stats_attribute pool_stats_attr_journal_entries_started = {
+	.attr = { .name = "journal_entries_started", .mode = 0444, },
+	.print = pool_stats_print_journal_entries_started,
+};
+
+/* The total number of items for which a write operation has been issued */
+static ssize_t
+pool_stats_print_journal_entries_written(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->journal.entries.written);
+}
+
+static struct pool_stats_attribute pool_stats_attr_journal_entries_written = {
+	.attr = { .name = "journal_entries_written", .mode = 0444, },
+	.print = pool_stats_print_journal_entries_written,
+};
+
+/* The total number of items for which a write operation has completed */
+static ssize_t
+pool_stats_print_journal_entries_committed(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->journal.entries.committed);
+}
+
+static struct pool_stats_attribute pool_stats_attr_journal_entries_committed = {
+	.attr = { .name = "journal_entries_committed", .mode = 0444, },
+	.print = pool_stats_print_journal_entries_committed,
+};
+
+/* The total number of items on which processing has started */
+static ssize_t
+pool_stats_print_journal_blocks_started(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->journal.blocks.started);
+}
+
+static struct pool_stats_attribute pool_stats_attr_journal_blocks_started = {
+	.attr = { .name = "journal_blocks_started", .mode = 0444, },
+	.print = pool_stats_print_journal_blocks_started,
+};
+
+/* The total number of items for which a write operation has been issued */
+static ssize_t
+pool_stats_print_journal_blocks_written(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->journal.blocks.written);
+}
+
+static struct pool_stats_attribute pool_stats_attr_journal_blocks_written = {
+	.attr = { .name = "journal_blocks_written", .mode = 0444, },
+	.print = pool_stats_print_journal_blocks_written,
+};
+
+/* The total number of items for which a write operation has completed */
+static ssize_t
+pool_stats_print_journal_blocks_committed(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->journal.blocks.committed);
+}
+
+static struct pool_stats_attribute pool_stats_attr_journal_blocks_committed = {
+	.attr = { .name = "journal_blocks_committed", .mode = 0444, },
+	.print = pool_stats_print_journal_blocks_committed,
+};
+
+/* Number of times the on-disk journal was full */
+static ssize_t
+pool_stats_print_slab_journal_disk_full_count(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->slab_journal.disk_full_count);
+}
+
+static struct pool_stats_attribute pool_stats_attr_slab_journal_disk_full_count = {
+	.attr = { .name = "slab_journal_disk_full_count", .mode = 0444, },
+	.print = pool_stats_print_slab_journal_disk_full_count,
+};
+
+/* Number of times an entry was added over the flush threshold */
+static ssize_t
+pool_stats_print_slab_journal_flush_count(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->slab_journal.flush_count);
+}
+
+static struct pool_stats_attribute pool_stats_attr_slab_journal_flush_count = {
+	.attr = { .name = "slab_journal_flush_count", .mode = 0444, },
+	.print = pool_stats_print_slab_journal_flush_count,
+};
+
+/* Number of times an entry was added over the block threshold */
+static ssize_t
+pool_stats_print_slab_journal_blocked_count(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->slab_journal.blocked_count);
+}
+
+static struct pool_stats_attribute pool_stats_attr_slab_journal_blocked_count = {
+	.attr = { .name = "slab_journal_blocked_count", .mode = 0444, },
+	.print = pool_stats_print_slab_journal_blocked_count,
+};
+
+/* Number of times a tail block was written */
+static ssize_t
+pool_stats_print_slab_journal_blocks_written(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->slab_journal.blocks_written);
+}
+
+static struct pool_stats_attribute pool_stats_attr_slab_journal_blocks_written = {
+	.attr = { .name = "slab_journal_blocks_written", .mode = 0444, },
+	.print = pool_stats_print_slab_journal_blocks_written,
+};
+
+/* Number of times we had to wait for the tail to write */
+static ssize_t
+pool_stats_print_slab_journal_tail_busy_count(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->slab_journal.tail_busy_count);
+}
+
+static struct pool_stats_attribute pool_stats_attr_slab_journal_tail_busy_count = {
+	.attr = { .name = "slab_journal_tail_busy_count", .mode = 0444, },
+	.print = pool_stats_print_slab_journal_tail_busy_count,
+};
+
+/* Number of blocks written */
+static ssize_t
+pool_stats_print_slab_summary_blocks_written(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->slab_summary.blocks_written);
+}
+
+static struct pool_stats_attribute pool_stats_attr_slab_summary_blocks_written = {
+	.attr = { .name = "slab_summary_blocks_written", .mode = 0444, },
+	.print = pool_stats_print_slab_summary_blocks_written,
+};
+
+/* Number of reference blocks written */
+static ssize_t
+pool_stats_print_ref_counts_blocks_written(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->ref_counts.blocks_written);
+}
+
+static struct pool_stats_attribute pool_stats_attr_ref_counts_blocks_written = {
+	.attr = { .name = "ref_counts_blocks_written", .mode = 0444, },
+	.print = pool_stats_print_ref_counts_blocks_written,
+};
+
+/* number of dirty (resident) pages */
+static ssize_t
+pool_stats_print_block_map_dirty_pages(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->block_map.dirty_pages);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_dirty_pages = {
+	.attr = { .name = "block_map_dirty_pages", .mode = 0444, },
+	.print = pool_stats_print_block_map_dirty_pages,
+};
+
+/* number of clean (resident) pages */
+static ssize_t
+pool_stats_print_block_map_clean_pages(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->block_map.clean_pages);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_clean_pages = {
+	.attr = { .name = "block_map_clean_pages", .mode = 0444, },
+	.print = pool_stats_print_block_map_clean_pages,
+};
+
+/* number of free pages */
+static ssize_t
+pool_stats_print_block_map_free_pages(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->block_map.free_pages);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_free_pages = {
+	.attr = { .name = "block_map_free_pages", .mode = 0444, },
+	.print = pool_stats_print_block_map_free_pages,
+};
+
+/* number of pages in failed state */
+static ssize_t
+pool_stats_print_block_map_failed_pages(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->block_map.failed_pages);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_failed_pages = {
+	.attr = { .name = "block_map_failed_pages", .mode = 0444, },
+	.print = pool_stats_print_block_map_failed_pages,
+};
+
+/* number of pages incoming */
+static ssize_t
+pool_stats_print_block_map_incoming_pages(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->block_map.incoming_pages);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_incoming_pages = {
+	.attr = { .name = "block_map_incoming_pages", .mode = 0444, },
+	.print = pool_stats_print_block_map_incoming_pages,
+};
+
+/* number of pages outgoing */
+static ssize_t
+pool_stats_print_block_map_outgoing_pages(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->block_map.outgoing_pages);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_outgoing_pages = {
+	.attr = { .name = "block_map_outgoing_pages", .mode = 0444, },
+	.print = pool_stats_print_block_map_outgoing_pages,
+};
+
+/* how many times free page not avail */
+static ssize_t
+pool_stats_print_block_map_cache_pressure(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->block_map.cache_pressure);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_cache_pressure = {
+	.attr = { .name = "block_map_cache_pressure", .mode = 0444, },
+	.print = pool_stats_print_block_map_cache_pressure,
+};
+
+/* number of get_vdo_page() calls for read */
+static ssize_t
+pool_stats_print_block_map_read_count(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.read_count);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_read_count = {
+	.attr = { .name = "block_map_read_count", .mode = 0444, },
+	.print = pool_stats_print_block_map_read_count,
+};
+
+/* number of get_vdo_page() calls for write */
+static ssize_t
+pool_stats_print_block_map_write_count(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.write_count);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_write_count = {
+	.attr = { .name = "block_map_write_count", .mode = 0444, },
+	.print = pool_stats_print_block_map_write_count,
+};
+
+/* number of times pages failed to read */
+static ssize_t
+pool_stats_print_block_map_failed_reads(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.failed_reads);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_failed_reads = {
+	.attr = { .name = "block_map_failed_reads", .mode = 0444, },
+	.print = pool_stats_print_block_map_failed_reads,
+};
+
+/* number of times pages failed to write */
+static ssize_t
+pool_stats_print_block_map_failed_writes(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.failed_writes);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_failed_writes = {
+	.attr = { .name = "block_map_failed_writes", .mode = 0444, },
+	.print = pool_stats_print_block_map_failed_writes,
+};
+
+/* number of gets that are reclaimed */
+static ssize_t
+pool_stats_print_block_map_reclaimed(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.reclaimed);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_reclaimed = {
+	.attr = { .name = "block_map_reclaimed", .mode = 0444, },
+	.print = pool_stats_print_block_map_reclaimed,
+};
+
+/* number of gets for outgoing pages */
+static ssize_t
+pool_stats_print_block_map_read_outgoing(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.read_outgoing);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_read_outgoing = {
+	.attr = { .name = "block_map_read_outgoing", .mode = 0444, },
+	.print = pool_stats_print_block_map_read_outgoing,
+};
+
+/* number of gets that were already there */
+static ssize_t
+pool_stats_print_block_map_found_in_cache(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.found_in_cache);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_found_in_cache = {
+	.attr = { .name = "block_map_found_in_cache", .mode = 0444, },
+	.print = pool_stats_print_block_map_found_in_cache,
+};
+
+/* number of gets requiring discard */
+static ssize_t
+pool_stats_print_block_map_discard_required(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.discard_required);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_discard_required = {
+	.attr = { .name = "block_map_discard_required", .mode = 0444, },
+	.print = pool_stats_print_block_map_discard_required,
+};
+
+/* number of gets enqueued for their page */
+static ssize_t
+pool_stats_print_block_map_wait_for_page(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.wait_for_page);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_wait_for_page = {
+	.attr = { .name = "block_map_wait_for_page", .mode = 0444, },
+	.print = pool_stats_print_block_map_wait_for_page,
+};
+
+/* number of gets that have to fetch */
+static ssize_t
+pool_stats_print_block_map_fetch_required(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.fetch_required);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_fetch_required = {
+	.attr = { .name = "block_map_fetch_required", .mode = 0444, },
+	.print = pool_stats_print_block_map_fetch_required,
+};
+
+/* number of page fetches */
+static ssize_t
+pool_stats_print_block_map_pages_loaded(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.pages_loaded);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_pages_loaded = {
+	.attr = { .name = "block_map_pages_loaded", .mode = 0444, },
+	.print = pool_stats_print_block_map_pages_loaded,
+};
+
+/* number of page saves */
+static ssize_t
+pool_stats_print_block_map_pages_saved(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.pages_saved);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_pages_saved = {
+	.attr = { .name = "block_map_pages_saved", .mode = 0444, },
+	.print = pool_stats_print_block_map_pages_saved,
+};
+
+/* the number of flushes issued */
+static ssize_t
+pool_stats_print_block_map_flush_count(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->block_map.flush_count);
+}
+
+static struct pool_stats_attribute pool_stats_attr_block_map_flush_count = {
+	.attr = { .name = "block_map_flush_count", .mode = 0444, },
+	.print = pool_stats_print_block_map_flush_count,
+};
+
+/* Number of times the UDS advice proved correct */
+static ssize_t
+pool_stats_print_hash_lock_dedupe_advice_valid(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->hash_lock.dedupe_advice_valid);
+}
+
+static struct pool_stats_attribute pool_stats_attr_hash_lock_dedupe_advice_valid = {
+	.attr = { .name = "hash_lock_dedupe_advice_valid", .mode = 0444, },
+	.print = pool_stats_print_hash_lock_dedupe_advice_valid,
+};
+
+/* Number of times the UDS advice proved incorrect */
+static ssize_t
+pool_stats_print_hash_lock_dedupe_advice_stale(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->hash_lock.dedupe_advice_stale);
+}
+
+static struct pool_stats_attribute pool_stats_attr_hash_lock_dedupe_advice_stale = {
+	.attr = { .name = "hash_lock_dedupe_advice_stale", .mode = 0444, },
+	.print = pool_stats_print_hash_lock_dedupe_advice_stale,
+};
+
+/* Number of writes with the same data as another in-flight write */
+static ssize_t
+pool_stats_print_hash_lock_concurrent_data_matches(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->hash_lock.concurrent_data_matches);
+}
+
+static struct pool_stats_attribute pool_stats_attr_hash_lock_concurrent_data_matches = {
+	.attr = { .name = "hash_lock_concurrent_data_matches", .mode = 0444, },
+	.print = pool_stats_print_hash_lock_concurrent_data_matches,
+};
+
+/* Number of writes whose hash collided with an in-flight write */
+static ssize_t
+pool_stats_print_hash_lock_concurrent_hash_collisions(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->hash_lock.concurrent_hash_collisions);
+}
+
+static struct pool_stats_attribute pool_stats_attr_hash_lock_concurrent_hash_collisions = {
+	.attr = { .name = "hash_lock_concurrent_hash_collisions", .mode = 0444, },
+	.print = pool_stats_print_hash_lock_concurrent_hash_collisions,
+};
+
+/* Current number of dedupe queries that are in flight */
+static ssize_t
+pool_stats_print_hash_lock_curr_dedupe_queries(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->hash_lock.curr_dedupe_queries);
+}
+
+static struct pool_stats_attribute pool_stats_attr_hash_lock_curr_dedupe_queries = {
+	.attr = { .name = "hash_lock_curr_dedupe_queries", .mode = 0444, },
+	.print = pool_stats_print_hash_lock_curr_dedupe_queries,
+};
+
+/* number of times VDO got an invalid dedupe advice PBN from UDS */
+static ssize_t
+pool_stats_print_errors_invalid_advice_pbn_count(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->errors.invalid_advice_pbn_count);
+}
+
+static struct pool_stats_attribute pool_stats_attr_errors_invalid_advice_pbn_count = {
+	.attr = { .name = "errors_invalid_advice_pbn_count", .mode = 0444, },
+	.print = pool_stats_print_errors_invalid_advice_pbn_count,
+};
+
+/* number of times a VIO completed with a VDO_NO_SPACE error */
+static ssize_t
+pool_stats_print_errors_no_space_error_count(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->errors.no_space_error_count);
+}
+
+static struct pool_stats_attribute pool_stats_attr_errors_no_space_error_count = {
+	.attr = { .name = "errors_no_space_error_count", .mode = 0444, },
+	.print = pool_stats_print_errors_no_space_error_count,
+};
+
+/* number of times a VIO completed with a VDO_READ_ONLY error */
+static ssize_t
+pool_stats_print_errors_read_only_error_count(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->errors.read_only_error_count);
+}
+
+static struct pool_stats_attribute pool_stats_attr_errors_read_only_error_count = {
+	.attr = { .name = "errors_read_only_error_count", .mode = 0444, },
+	.print = pool_stats_print_errors_read_only_error_count,
+};
+
+/* The VDO instance */
+static ssize_t
+pool_stats_print_instance(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->instance);
+}
+
+static struct pool_stats_attribute pool_stats_attr_instance = {
+	.attr = { .name = "instance", .mode = 0444, },
+	.print = pool_stats_print_instance,
+};
+
+/* Current number of active VIOs */
+static ssize_t
+pool_stats_print_current_vios_in_progress(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->current_vios_in_progress);
+}
+
+static struct pool_stats_attribute pool_stats_attr_current_vios_in_progress = {
+	.attr = { .name = "current_vios_in_progress", .mode = 0444, },
+	.print = pool_stats_print_current_vios_in_progress,
+};
+
+/* Maximum number of active VIOs */
+static ssize_t
+pool_stats_print_max_vios(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%u\n", stats->max_vios);
+}
+
+static struct pool_stats_attribute pool_stats_attr_max_vios = {
+	.attr = { .name = "max_vios", .mode = 0444, },
+	.print = pool_stats_print_max_vios,
+};
+
+/* Number of times the UDS index was too slow in responding */
+static ssize_t
+pool_stats_print_dedupe_advice_timeouts(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->dedupe_advice_timeouts);
+}
+
+static struct pool_stats_attribute pool_stats_attr_dedupe_advice_timeouts = {
+	.attr = { .name = "dedupe_advice_timeouts", .mode = 0444, },
+	.print = pool_stats_print_dedupe_advice_timeouts,
+};
+
+/* Number of flush requests submitted to the storage device */
+static ssize_t
+pool_stats_print_flush_out(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->flush_out);
+}
+
+static struct pool_stats_attribute pool_stats_attr_flush_out = {
+	.attr = { .name = "flush_out", .mode = 0444, },
+	.print = pool_stats_print_flush_out,
+};
+
+/* Logical block size */
+static ssize_t
+pool_stats_print_logical_block_size(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->logical_block_size);
+}
+
+static struct pool_stats_attribute pool_stats_attr_logical_block_size = {
+	.attr = { .name = "logical_block_size", .mode = 0444, },
+	.print = pool_stats_print_logical_block_size,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_in_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_read = {
+	.attr = { .name = "bios_in_read", .mode = 0444, },
+	.print = pool_stats_print_bios_in_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_in_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_write = {
+	.attr = { .name = "bios_in_write", .mode = 0444, },
+	.print = pool_stats_print_bios_in_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_in_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_empty_flush = {
+	.attr = { .name = "bios_in_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_in_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_in_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_discard = {
+	.attr = { .name = "bios_in_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_in_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_in_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_flush = {
+	.attr = { .name = "bios_in_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_in_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_in_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_fua = {
+	.attr = { .name = "bios_in_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_in_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_in_partial_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_partial.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_partial_read = {
+	.attr = { .name = "bios_in_partial_read", .mode = 0444, },
+	.print = pool_stats_print_bios_in_partial_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_in_partial_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_partial.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_partial_write = {
+	.attr = { .name = "bios_in_partial_write", .mode = 0444, },
+	.print = pool_stats_print_bios_in_partial_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_in_partial_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_partial.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_partial_empty_flush = {
+	.attr = { .name = "bios_in_partial_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_in_partial_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_in_partial_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_partial.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_partial_discard = {
+	.attr = { .name = "bios_in_partial_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_in_partial_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_in_partial_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_partial.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_partial_flush = {
+	.attr = { .name = "bios_in_partial_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_in_partial_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_in_partial_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_partial.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_partial_fua = {
+	.attr = { .name = "bios_in_partial_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_in_partial_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_out_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_read = {
+	.attr = { .name = "bios_out_read", .mode = 0444, },
+	.print = pool_stats_print_bios_out_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_out_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_write = {
+	.attr = { .name = "bios_out_write", .mode = 0444, },
+	.print = pool_stats_print_bios_out_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_out_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_empty_flush = {
+	.attr = { .name = "bios_out_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_out_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_out_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_discard = {
+	.attr = { .name = "bios_out_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_out_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_out_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_flush = {
+	.attr = { .name = "bios_out_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_out_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_out_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_fua = {
+	.attr = { .name = "bios_out_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_out_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_meta_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_read = {
+	.attr = { .name = "bios_meta_read", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_meta_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_write = {
+	.attr = { .name = "bios_meta_write", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_meta_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_empty_flush = {
+	.attr = { .name = "bios_meta_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_meta_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_discard = {
+	.attr = { .name = "bios_meta_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_meta_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_flush = {
+	.attr = { .name = "bios_meta_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_meta_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_fua = {
+	.attr = { .name = "bios_meta_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_journal_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_read = {
+	.attr = { .name = "bios_journal_read", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_journal_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_write = {
+	.attr = { .name = "bios_journal_write", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_journal_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_empty_flush = {
+	.attr = { .name = "bios_journal_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_journal_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_discard = {
+	.attr = { .name = "bios_journal_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_journal_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_flush = {
+	.attr = { .name = "bios_journal_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_journal_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_fua = {
+	.attr = { .name = "bios_journal_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_page_cache_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_read = {
+	.attr = { .name = "bios_page_cache_read", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_page_cache_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_write = {
+	.attr = { .name = "bios_page_cache_write", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_page_cache_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_empty_flush = {
+	.attr = { .name = "bios_page_cache_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_page_cache_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_discard = {
+	.attr = { .name = "bios_page_cache_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_page_cache_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_flush = {
+	.attr = { .name = "bios_page_cache_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_page_cache_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_fua = {
+	.attr = { .name = "bios_page_cache_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_out_completed_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out_completed.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_completed_read = {
+	.attr = { .name = "bios_out_completed_read", .mode = 0444, },
+	.print = pool_stats_print_bios_out_completed_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_out_completed_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out_completed.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_completed_write = {
+	.attr = { .name = "bios_out_completed_write", .mode = 0444, },
+	.print = pool_stats_print_bios_out_completed_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_out_completed_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out_completed.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_completed_empty_flush = {
+	.attr = { .name = "bios_out_completed_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_out_completed_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_out_completed_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out_completed.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_completed_discard = {
+	.attr = { .name = "bios_out_completed_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_out_completed_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_out_completed_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out_completed.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_completed_flush = {
+	.attr = { .name = "bios_out_completed_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_out_completed_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_out_completed_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_out_completed.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_out_completed_fua = {
+	.attr = { .name = "bios_out_completed_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_out_completed_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_meta_completed_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta_completed.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_read = {
+	.attr = { .name = "bios_meta_completed_read", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_completed_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_meta_completed_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta_completed.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_write = {
+	.attr = { .name = "bios_meta_completed_write", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_completed_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_meta_completed_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta_completed.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_empty_flush = {
+	.attr = { .name = "bios_meta_completed_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_completed_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_meta_completed_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta_completed.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_discard = {
+	.attr = { .name = "bios_meta_completed_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_completed_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_meta_completed_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta_completed.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_flush = {
+	.attr = { .name = "bios_meta_completed_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_completed_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_meta_completed_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_meta_completed.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_meta_completed_fua = {
+	.attr = { .name = "bios_meta_completed_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_meta_completed_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_journal_completed_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal_completed.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_read = {
+	.attr = { .name = "bios_journal_completed_read", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_completed_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_journal_completed_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal_completed.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_write = {
+	.attr = { .name = "bios_journal_completed_write", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_completed_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_journal_completed_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal_completed.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_empty_flush = {
+	.attr = { .name = "bios_journal_completed_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_completed_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_journal_completed_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal_completed.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_discard = {
+	.attr = { .name = "bios_journal_completed_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_completed_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_journal_completed_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal_completed.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_flush = {
+	.attr = { .name = "bios_journal_completed_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_completed_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_journal_completed_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_journal_completed.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_journal_completed_fua = {
+	.attr = { .name = "bios_journal_completed_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_journal_completed_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_page_cache_completed_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_read = {
+	.attr = { .name = "bios_page_cache_completed_read", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_completed_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_page_cache_completed_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_write = {
+	.attr = { .name = "bios_page_cache_completed_write", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_completed_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_page_cache_completed_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_empty_flush = {
+	.attr = { .name = "bios_page_cache_completed_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_completed_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_page_cache_completed_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_discard = {
+	.attr = { .name = "bios_page_cache_completed_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_completed_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_page_cache_completed_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_flush = {
+	.attr = { .name = "bios_page_cache_completed_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_completed_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_page_cache_completed_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_page_cache_completed.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_page_cache_completed_fua = {
+	.attr = { .name = "bios_page_cache_completed_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_page_cache_completed_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_acknowledged_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_read = {
+	.attr = { .name = "bios_acknowledged_read", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_acknowledged_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_write = {
+	.attr = { .name = "bios_acknowledged_write", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_acknowledged_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_empty_flush = {
+	.attr = { .name = "bios_acknowledged_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_acknowledged_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_discard = {
+	.attr = { .name = "bios_acknowledged_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_acknowledged_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_flush = {
+	.attr = { .name = "bios_acknowledged_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_acknowledged_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_fua = {
+	.attr = { .name = "bios_acknowledged_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_acknowledged_partial_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_read = {
+	.attr = { .name = "bios_acknowledged_partial_read", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_partial_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_acknowledged_partial_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_write = {
+	.attr = { .name = "bios_acknowledged_partial_write", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_partial_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_acknowledged_partial_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_empty_flush = {
+	.attr = { .name = "bios_acknowledged_partial_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_partial_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_acknowledged_partial_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_discard = {
+	.attr = { .name = "bios_acknowledged_partial_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_partial_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_acknowledged_partial_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_flush = {
+	.attr = { .name = "bios_acknowledged_partial_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_partial_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_acknowledged_partial_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_acknowledged_partial.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_acknowledged_partial_fua = {
+	.attr = { .name = "bios_acknowledged_partial_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_acknowledged_partial_fua,
+};
+
+/* Number of REQ_OP_READ bios */
+static ssize_t
+pool_stats_print_bios_in_progress_read(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_progress.read);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_progress_read = {
+	.attr = { .name = "bios_in_progress_read", .mode = 0444, },
+	.print = pool_stats_print_bios_in_progress_read,
+};
+
+/* Number of REQ_OP_WRITE bios with data */
+static ssize_t
+pool_stats_print_bios_in_progress_write(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_progress.write);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_progress_write = {
+	.attr = { .name = "bios_in_progress_write", .mode = 0444, },
+	.print = pool_stats_print_bios_in_progress_write,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH and containing no data */
+static ssize_t
+pool_stats_print_bios_in_progress_empty_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_progress.empty_flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_progress_empty_flush = {
+	.attr = { .name = "bios_in_progress_empty_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_in_progress_empty_flush,
+};
+
+/* Number of REQ_OP_DISCARD bios */
+static ssize_t
+pool_stats_print_bios_in_progress_discard(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_progress.discard);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_progress_discard = {
+	.attr = { .name = "bios_in_progress_discard", .mode = 0444, },
+	.print = pool_stats_print_bios_in_progress_discard,
+};
+
+/* Number of bios tagged with REQ_PREFLUSH */
+static ssize_t
+pool_stats_print_bios_in_progress_flush(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_progress.flush);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_progress_flush = {
+	.attr = { .name = "bios_in_progress_flush", .mode = 0444, },
+	.print = pool_stats_print_bios_in_progress_flush,
+};
+
+/* Number of bios tagged with REQ_FUA */
+static ssize_t
+pool_stats_print_bios_in_progress_fua(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->bios_in_progress.fua);
+}
+
+static struct pool_stats_attribute pool_stats_attr_bios_in_progress_fua = {
+	.attr = { .name = "bios_in_progress_fua", .mode = 0444, },
+	.print = pool_stats_print_bios_in_progress_fua,
+};
+
+/* Tracked bytes currently allocated. */
+static ssize_t
+pool_stats_print_memory_usage_bytes_used(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->memory_usage.bytes_used);
+}
+
+static struct pool_stats_attribute pool_stats_attr_memory_usage_bytes_used = {
+	.attr = { .name = "memory_usage_bytes_used", .mode = 0444, },
+	.print = pool_stats_print_memory_usage_bytes_used,
+};
+
+/* Maximum tracked bytes allocated. */
+static ssize_t
+pool_stats_print_memory_usage_peak_bytes_used(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->memory_usage.peak_bytes_used);
+}
+
+static struct pool_stats_attribute pool_stats_attr_memory_usage_peak_bytes_used = {
+	.attr = { .name = "memory_usage_peak_bytes_used", .mode = 0444, },
+	.print = pool_stats_print_memory_usage_peak_bytes_used,
+};
+
+/* Number of records stored in the index */
+static ssize_t
+pool_stats_print_index_entries_indexed(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->index.entries_indexed);
+}
+
+static struct pool_stats_attribute pool_stats_attr_index_entries_indexed = {
+	.attr = { .name = "index_entries_indexed", .mode = 0444, },
+	.print = pool_stats_print_index_entries_indexed,
+};
+
+/* Number of post calls that found an existing entry */
+static ssize_t
+pool_stats_print_index_posts_found(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->index.posts_found);
+}
+
+static struct pool_stats_attribute pool_stats_attr_index_posts_found = {
+	.attr = { .name = "index_posts_found", .mode = 0444, },
+	.print = pool_stats_print_index_posts_found,
+};
+
+/* Number of post calls that added a new entry */
+static ssize_t
+pool_stats_print_index_posts_not_found(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->index.posts_not_found);
+}
+
+static struct pool_stats_attribute pool_stats_attr_index_posts_not_found = {
+	.attr = { .name = "index_posts_not_found", .mode = 0444, },
+	.print = pool_stats_print_index_posts_not_found,
+};
+
+/* Number of query calls that found an existing entry */
+static ssize_t
+pool_stats_print_index_queries_found(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->index.queries_found);
+}
+
+static struct pool_stats_attribute pool_stats_attr_index_queries_found = {
+	.attr = { .name = "index_queries_found", .mode = 0444, },
+	.print = pool_stats_print_index_queries_found,
+};
+
+/* Number of query calls that added a new entry */
+static ssize_t
+pool_stats_print_index_queries_not_found(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->index.queries_not_found);
+}
+
+static struct pool_stats_attribute pool_stats_attr_index_queries_not_found = {
+	.attr = { .name = "index_queries_not_found", .mode = 0444, },
+	.print = pool_stats_print_index_queries_not_found,
+};
+
+/* Number of update calls that found an existing entry */
+static ssize_t
+pool_stats_print_index_updates_found(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->index.updates_found);
+}
+
+static struct pool_stats_attribute pool_stats_attr_index_updates_found = {
+	.attr = { .name = "index_updates_found", .mode = 0444, },
+	.print = pool_stats_print_index_updates_found,
+};
+
+/* Number of update calls that added a new entry */
+static ssize_t
+pool_stats_print_index_updates_not_found(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->index.updates_not_found);
+}
+
+static struct pool_stats_attribute pool_stats_attr_index_updates_not_found = {
+	.attr = { .name = "index_updates_not_found", .mode = 0444, },
+	.print = pool_stats_print_index_updates_not_found,
+};
+
+/* Number of entries discarded */
+static ssize_t
+pool_stats_print_index_entries_discarded(struct vdo_statistics *stats, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->index.entries_discarded);
+}
+
+static struct pool_stats_attribute pool_stats_attr_index_entries_discarded = {
+	.attr = { .name = "index_entries_discarded", .mode = 0444, },
+	.print = pool_stats_print_index_entries_discarded,
+};
+
+struct attribute *vdo_pool_stats_attrs[] = {
+	&pool_stats_attr_data_blocks_used.attr,
+	&pool_stats_attr_overhead_blocks_used.attr,
+	&pool_stats_attr_logical_blocks_used.attr,
+	&pool_stats_attr_physical_blocks.attr,
+	&pool_stats_attr_logical_blocks.attr,
+	&pool_stats_attr_block_map_cache_size.attr,
+	&pool_stats_attr_block_size.attr,
+	&pool_stats_attr_complete_recoveries.attr,
+	&pool_stats_attr_read_only_recoveries.attr,
+	&pool_stats_attr_mode.attr,
+	&pool_stats_attr_in_recovery_mode.attr,
+	&pool_stats_attr_recovery_percentage.attr,
+	&pool_stats_attr_packer_compressed_fragments_written.attr,
+	&pool_stats_attr_packer_compressed_blocks_written.attr,
+	&pool_stats_attr_packer_compressed_fragments_in_packer.attr,
+	&pool_stats_attr_allocator_slab_count.attr,
+	&pool_stats_attr_allocator_slabs_opened.attr,
+	&pool_stats_attr_allocator_slabs_reopened.attr,
+	&pool_stats_attr_journal_disk_full.attr,
+	&pool_stats_attr_journal_slab_journal_commits_requested.attr,
+	&pool_stats_attr_journal_entries_started.attr,
+	&pool_stats_attr_journal_entries_written.attr,
+	&pool_stats_attr_journal_entries_committed.attr,
+	&pool_stats_attr_journal_blocks_started.attr,
+	&pool_stats_attr_journal_blocks_written.attr,
+	&pool_stats_attr_journal_blocks_committed.attr,
+	&pool_stats_attr_slab_journal_disk_full_count.attr,
+	&pool_stats_attr_slab_journal_flush_count.attr,
+	&pool_stats_attr_slab_journal_blocked_count.attr,
+	&pool_stats_attr_slab_journal_blocks_written.attr,
+	&pool_stats_attr_slab_journal_tail_busy_count.attr,
+	&pool_stats_attr_slab_summary_blocks_written.attr,
+	&pool_stats_attr_ref_counts_blocks_written.attr,
+	&pool_stats_attr_block_map_dirty_pages.attr,
+	&pool_stats_attr_block_map_clean_pages.attr,
+	&pool_stats_attr_block_map_free_pages.attr,
+	&pool_stats_attr_block_map_failed_pages.attr,
+	&pool_stats_attr_block_map_incoming_pages.attr,
+	&pool_stats_attr_block_map_outgoing_pages.attr,
+	&pool_stats_attr_block_map_cache_pressure.attr,
+	&pool_stats_attr_block_map_read_count.attr,
+	&pool_stats_attr_block_map_write_count.attr,
+	&pool_stats_attr_block_map_failed_reads.attr,
+	&pool_stats_attr_block_map_failed_writes.attr,
+	&pool_stats_attr_block_map_reclaimed.attr,
+	&pool_stats_attr_block_map_read_outgoing.attr,
+	&pool_stats_attr_block_map_found_in_cache.attr,
+	&pool_stats_attr_block_map_discard_required.attr,
+	&pool_stats_attr_block_map_wait_for_page.attr,
+	&pool_stats_attr_block_map_fetch_required.attr,
+	&pool_stats_attr_block_map_pages_loaded.attr,
+	&pool_stats_attr_block_map_pages_saved.attr,
+	&pool_stats_attr_block_map_flush_count.attr,
+	&pool_stats_attr_hash_lock_dedupe_advice_valid.attr,
+	&pool_stats_attr_hash_lock_dedupe_advice_stale.attr,
+	&pool_stats_attr_hash_lock_concurrent_data_matches.attr,
+	&pool_stats_attr_hash_lock_concurrent_hash_collisions.attr,
+	&pool_stats_attr_hash_lock_curr_dedupe_queries.attr,
+	&pool_stats_attr_errors_invalid_advice_pbn_count.attr,
+	&pool_stats_attr_errors_no_space_error_count.attr,
+	&pool_stats_attr_errors_read_only_error_count.attr,
+	&pool_stats_attr_instance.attr,
+	&pool_stats_attr_current_vios_in_progress.attr,
+	&pool_stats_attr_max_vios.attr,
+	&pool_stats_attr_dedupe_advice_timeouts.attr,
+	&pool_stats_attr_flush_out.attr,
+	&pool_stats_attr_logical_block_size.attr,
+	&pool_stats_attr_bios_in_read.attr,
+	&pool_stats_attr_bios_in_write.attr,
+	&pool_stats_attr_bios_in_empty_flush.attr,
+	&pool_stats_attr_bios_in_discard.attr,
+	&pool_stats_attr_bios_in_flush.attr,
+	&pool_stats_attr_bios_in_fua.attr,
+	&pool_stats_attr_bios_in_partial_read.attr,
+	&pool_stats_attr_bios_in_partial_write.attr,
+	&pool_stats_attr_bios_in_partial_empty_flush.attr,
+	&pool_stats_attr_bios_in_partial_discard.attr,
+	&pool_stats_attr_bios_in_partial_flush.attr,
+	&pool_stats_attr_bios_in_partial_fua.attr,
+	&pool_stats_attr_bios_out_read.attr,
+	&pool_stats_attr_bios_out_write.attr,
+	&pool_stats_attr_bios_out_empty_flush.attr,
+	&pool_stats_attr_bios_out_discard.attr,
+	&pool_stats_attr_bios_out_flush.attr,
+	&pool_stats_attr_bios_out_fua.attr,
+	&pool_stats_attr_bios_meta_read.attr,
+	&pool_stats_attr_bios_meta_write.attr,
+	&pool_stats_attr_bios_meta_empty_flush.attr,
+	&pool_stats_attr_bios_meta_discard.attr,
+	&pool_stats_attr_bios_meta_flush.attr,
+	&pool_stats_attr_bios_meta_fua.attr,
+	&pool_stats_attr_bios_journal_read.attr,
+	&pool_stats_attr_bios_journal_write.attr,
+	&pool_stats_attr_bios_journal_empty_flush.attr,
+	&pool_stats_attr_bios_journal_discard.attr,
+	&pool_stats_attr_bios_journal_flush.attr,
+	&pool_stats_attr_bios_journal_fua.attr,
+	&pool_stats_attr_bios_page_cache_read.attr,
+	&pool_stats_attr_bios_page_cache_write.attr,
+	&pool_stats_attr_bios_page_cache_empty_flush.attr,
+	&pool_stats_attr_bios_page_cache_discard.attr,
+	&pool_stats_attr_bios_page_cache_flush.attr,
+	&pool_stats_attr_bios_page_cache_fua.attr,
+	&pool_stats_attr_bios_out_completed_read.attr,
+	&pool_stats_attr_bios_out_completed_write.attr,
+	&pool_stats_attr_bios_out_completed_empty_flush.attr,
+	&pool_stats_attr_bios_out_completed_discard.attr,
+	&pool_stats_attr_bios_out_completed_flush.attr,
+	&pool_stats_attr_bios_out_completed_fua.attr,
+	&pool_stats_attr_bios_meta_completed_read.attr,
+	&pool_stats_attr_bios_meta_completed_write.attr,
+	&pool_stats_attr_bios_meta_completed_empty_flush.attr,
+	&pool_stats_attr_bios_meta_completed_discard.attr,
+	&pool_stats_attr_bios_meta_completed_flush.attr,
+	&pool_stats_attr_bios_meta_completed_fua.attr,
+	&pool_stats_attr_bios_journal_completed_read.attr,
+	&pool_stats_attr_bios_journal_completed_write.attr,
+	&pool_stats_attr_bios_journal_completed_empty_flush.attr,
+	&pool_stats_attr_bios_journal_completed_discard.attr,
+	&pool_stats_attr_bios_journal_completed_flush.attr,
+	&pool_stats_attr_bios_journal_completed_fua.attr,
+	&pool_stats_attr_bios_page_cache_completed_read.attr,
+	&pool_stats_attr_bios_page_cache_completed_write.attr,
+	&pool_stats_attr_bios_page_cache_completed_empty_flush.attr,
+	&pool_stats_attr_bios_page_cache_completed_discard.attr,
+	&pool_stats_attr_bios_page_cache_completed_flush.attr,
+	&pool_stats_attr_bios_page_cache_completed_fua.attr,
+	&pool_stats_attr_bios_acknowledged_read.attr,
+	&pool_stats_attr_bios_acknowledged_write.attr,
+	&pool_stats_attr_bios_acknowledged_empty_flush.attr,
+	&pool_stats_attr_bios_acknowledged_discard.attr,
+	&pool_stats_attr_bios_acknowledged_flush.attr,
+	&pool_stats_attr_bios_acknowledged_fua.attr,
+	&pool_stats_attr_bios_acknowledged_partial_read.attr,
+	&pool_stats_attr_bios_acknowledged_partial_write.attr,
+	&pool_stats_attr_bios_acknowledged_partial_empty_flush.attr,
+	&pool_stats_attr_bios_acknowledged_partial_discard.attr,
+	&pool_stats_attr_bios_acknowledged_partial_flush.attr,
+	&pool_stats_attr_bios_acknowledged_partial_fua.attr,
+	&pool_stats_attr_bios_in_progress_read.attr,
+	&pool_stats_attr_bios_in_progress_write.attr,
+	&pool_stats_attr_bios_in_progress_empty_flush.attr,
+	&pool_stats_attr_bios_in_progress_discard.attr,
+	&pool_stats_attr_bios_in_progress_flush.attr,
+	&pool_stats_attr_bios_in_progress_fua.attr,
+	&pool_stats_attr_memory_usage_bytes_used.attr,
+	&pool_stats_attr_memory_usage_peak_bytes_used.attr,
+	&pool_stats_attr_index_entries_indexed.attr,
+	&pool_stats_attr_index_posts_found.attr,
+	&pool_stats_attr_index_posts_not_found.attr,
+	&pool_stats_attr_index_queries_found.attr,
+	&pool_stats_attr_index_queries_not_found.attr,
+	&pool_stats_attr_index_updates_found.attr,
+	&pool_stats_attr_index_updates_not_found.attr,
+	&pool_stats_attr_index_entries_discarded.attr,
+	NULL,
+};
diff --git a/drivers/md/dm-vdo/pool-sysfs.c b/drivers/md/dm-vdo/pool-sysfs.c
new file mode 100644
index 00000000000..73006e5859d
--- /dev/null
+++ b/drivers/md/dm-vdo/pool-sysfs.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include "pool-sysfs.h"
+
+#include <linux/kstrtox.h>
+
+#include "memory-alloc.h"
+#include "string-utils.h"
+
+#include "data-vio.h"
+#include "dedupe.h"
+#include "vdo.h"
+
+struct pool_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct vdo *vdo, char *buf);
+	ssize_t (*store)(struct vdo *vdo, const char *value, size_t count);
+};
+
+static ssize_t vdo_pool_attr_show(struct kobject *directory, struct attribute *attr, char *buf)
+{
+	struct pool_attribute *pool_attr = container_of(attr, struct pool_attribute, attr);
+	struct vdo *vdo = container_of(directory, struct vdo, vdo_directory);
+
+	if (pool_attr->show == NULL)
+		return -EINVAL;
+	return pool_attr->show(vdo, buf);
+}
+
+static ssize_t vdo_pool_attr_store(struct kobject *directory,
+				   struct attribute *attr,
+				   const char *buf,
+				   size_t length)
+{
+	struct pool_attribute *pool_attr = container_of(attr, struct pool_attribute, attr);
+	struct vdo *vdo = container_of(directory, struct vdo, vdo_directory);
+
+	if (pool_attr->store == NULL)
+		return -EINVAL;
+	return pool_attr->store(vdo, buf, length);
+}
+
+static const struct sysfs_ops vdo_pool_sysfs_ops = {
+	.show = vdo_pool_attr_show,
+	.store = vdo_pool_attr_store,
+};
+
+static ssize_t pool_compressing_show(struct vdo *vdo, char *buf)
+{
+	return sprintf(buf, "%s\n", (vdo_get_compressing(vdo) ? "1" : "0"));
+}
+
+static ssize_t pool_discards_active_show(struct vdo *vdo, char *buf)
+{
+	return sprintf(buf, "%u\n", get_data_vio_pool_active_discards(vdo->data_vio_pool));
+}
+
+static ssize_t pool_discards_limit_show(struct vdo *vdo, char *buf)
+{
+	return sprintf(buf, "%u\n", get_data_vio_pool_discard_limit(vdo->data_vio_pool));
+}
+
+static ssize_t pool_discards_limit_store(struct vdo *vdo, const char *buf, size_t length)
+{
+	unsigned int value;
+	int result;
+
+	if ((length > 12) || (kstrtouint(buf, 10, &value) < 0) || (value < 1))
+		return -EINVAL;
+
+	result = set_data_vio_pool_discard_limit(vdo->data_vio_pool, value);
+	if (result != VDO_SUCCESS)
+		return -EINVAL;
+
+	return length;
+}
+
+static ssize_t pool_discards_maximum_show(struct vdo *vdo, char *buf)
+{
+	return sprintf(buf, "%u\n", get_data_vio_pool_maximum_discards(vdo->data_vio_pool));
+}
+
+static ssize_t pool_instance_show(struct vdo *vdo, char *buf)
+{
+	return sprintf(buf, "%u\n", vdo->instance);
+}
+
+static ssize_t pool_requests_active_show(struct vdo *vdo, char *buf)
+{
+	return sprintf(buf, "%u\n", get_data_vio_pool_active_requests(vdo->data_vio_pool));
+}
+
+static ssize_t pool_requests_limit_show(struct vdo *vdo, char *buf)
+{
+	return sprintf(buf, "%u\n", get_data_vio_pool_request_limit(vdo->data_vio_pool));
+}
+
+static ssize_t pool_requests_maximum_show(struct vdo *vdo, char *buf)
+{
+	return sprintf(buf, "%u\n", get_data_vio_pool_maximum_requests(vdo->data_vio_pool));
+}
+
+static void vdo_pool_release(struct kobject *directory)
+{
+	UDS_FREE(container_of(directory, struct vdo, vdo_directory));
+}
+
+static struct pool_attribute vdo_pool_compressing_attr = {
+	.attr = {
+			.name = "compressing",
+			.mode = 0444,
+		},
+	.show = pool_compressing_show,
+};
+
+static struct pool_attribute vdo_pool_discards_active_attr = {
+	.attr = {
+			.name = "discards_active",
+			.mode = 0444,
+		},
+	.show = pool_discards_active_show,
+};
+
+static struct pool_attribute vdo_pool_discards_limit_attr = {
+	.attr = {
+			.name = "discards_limit",
+			.mode = 0644,
+		},
+	.show = pool_discards_limit_show,
+	.store = pool_discards_limit_store,
+};
+
+static struct pool_attribute vdo_pool_discards_maximum_attr = {
+	.attr = {
+			.name = "discards_maximum",
+			.mode = 0444,
+		},
+	.show = pool_discards_maximum_show,
+};
+
+static struct pool_attribute vdo_pool_instance_attr = {
+	.attr = {
+			.name = "instance",
+			.mode = 0444,
+		},
+	.show = pool_instance_show,
+};
+
+static struct pool_attribute vdo_pool_requests_active_attr = {
+	.attr = {
+			.name = "requests_active",
+			.mode = 0444,
+		},
+	.show = pool_requests_active_show,
+};
+
+static struct pool_attribute vdo_pool_requests_limit_attr = {
+	.attr = {
+			.name = "requests_limit",
+			.mode = 0444,
+		},
+	.show = pool_requests_limit_show,
+};
+
+static struct pool_attribute vdo_pool_requests_maximum_attr = {
+	.attr = {
+			.name = "requests_maximum",
+			.mode = 0444,
+		},
+	.show = pool_requests_maximum_show,
+};
+
+static struct attribute *pool_attrs[] = {
+	&vdo_pool_compressing_attr.attr,
+	&vdo_pool_discards_active_attr.attr,
+	&vdo_pool_discards_limit_attr.attr,
+	&vdo_pool_discards_maximum_attr.attr,
+	&vdo_pool_instance_attr.attr,
+	&vdo_pool_requests_active_attr.attr,
+	&vdo_pool_requests_limit_attr.attr,
+	&vdo_pool_requests_maximum_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(pool);
+
+struct kobj_type vdo_directory_type = {
+	.release = vdo_pool_release,
+	.sysfs_ops = &vdo_pool_sysfs_ops,
+	.default_groups = pool_groups,
+};
diff --git a/drivers/md/dm-vdo/pool-sysfs.h b/drivers/md/dm-vdo/pool-sysfs.h
new file mode 100644
index 00000000000..1e8a172c367
--- /dev/null
+++ b/drivers/md/dm-vdo/pool-sysfs.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Red Hat
+ */
+
+#ifndef VDO_POOL_SYSFS_H
+#define VDO_POOL_SYSFS_H
+
+#include <linux/kobject.h>
+
+/* The kobj_type used for setting up the kernel layer kobject. */
+extern struct kobj_type vdo_directory_type;
+
+/* The sysfs_ops used for the "statistics" subdirectory. */
+extern const struct sysfs_ops vdo_pool_stats_sysfs_ops;
+/* The attribute used for the "statistics" subdirectory. */
+extern struct attribute *vdo_pool_stats_attrs[];
+
+#endif /* VDO_POOL_SYSFS_H */
diff --git a/drivers/md/dm-vdo/sysfs.c b/drivers/md/dm-vdo/sysfs.c
new file mode 100644
index 00000000000..a091933a0a5
--- /dev/null
+++ b/drivers/md/dm-vdo/sysfs.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Red Hat
+ */
+
+#include <linux/module.h>
+
+#include "logger.h"
+
+#include "constants.h"
+#include "dedupe.h"
+#include "vdo.h"
+
+static int vdo_log_level_show(char *buf, const struct kernel_param *kp)
+{
+	return sprintf(buf, "%s\n", uds_log_priority_to_string(uds_get_log_level()));
+}
+
+static int vdo_log_level_store(const char *buf, const struct kernel_param *kp)
+{
+	static char internal_buf[11];
+
+	int n = strlen(buf);
+
+	if (n > 10)
+		return -EINVAL;
+
+	memset(internal_buf, '\000', sizeof(internal_buf));
+	memcpy(internal_buf, buf, n);
+	if (internal_buf[n - 1] == '\n')
+		internal_buf[n - 1] = '\000';
+	uds_set_log_level(uds_log_string_to_priority(internal_buf));
+	return 0;
+}
+
+
+static int vdo_dedupe_timeout_interval_store(const char *buf, const struct kernel_param *kp)
+{
+	int result = param_set_uint(buf, kp);
+
+	if (result != 0)
+		return result;
+	vdo_set_dedupe_index_timeout_interval(*(uint *)kp->arg);
+	return 0;
+}
+
+static int vdo_min_dedupe_timer_interval_store(const char *buf, const struct kernel_param *kp)
+{
+	int result = param_set_uint(buf, kp);
+
+	if (result != 0)
+		return result;
+	vdo_set_dedupe_index_min_timer_interval(*(uint *)kp->arg);
+	return 0;
+}
+
+static const struct kernel_param_ops log_level_ops = {
+	.set = vdo_log_level_store,
+	.get = vdo_log_level_show,
+};
+
+
+static const struct kernel_param_ops dedupe_timeout_ops = {
+	.set = vdo_dedupe_timeout_interval_store,
+	.get = param_get_uint,
+};
+
+static const struct kernel_param_ops dedupe_timer_ops = {
+	.set = vdo_min_dedupe_timer_interval_store,
+	.get = param_get_uint,
+};
+
+module_param_cb(log_level, &log_level_ops, NULL, 0644);
+
+
+module_param_cb(deduplication_timeout_interval,
+		&dedupe_timeout_ops,
+		&vdo_dedupe_index_timeout_interval,
+		0644);
+
+module_param_cb(min_deduplication_timer_interval,
+		&dedupe_timer_ops,
+		&vdo_dedupe_index_min_timer_interval,
+		0644);
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

