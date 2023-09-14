Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04CFEEAA66
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719198;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BpVtwFn49e6XoDoFVHRQZ/QECzpbr+zdaZPQusOCF7g=;
	b=K2dIWWxoOf71Wx9/D9oWSIz+1XIbtjciNmRbf8YesKBat2O1ZBj8yjMOjDs6IsBT4wErZM
	9Sp1OkuoFF9ku9phK5jNzl3fk0KQxtSZikVFLSaRF4Rz6i85mTYtXyWLmiIgGRhyuWF/ya
	eGIe+i4eOcw20E4wVhW3DoLSdcwAPgo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-WY_y2Y_eMwisNWd8nFBWjQ-1; Thu, 14 Sep 2023 15:19:57 -0400
X-MC-Unique: WY_y2Y_eMwisNWd8nFBWjQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFBF4185A78E;
	Thu, 14 Sep 2023 19:19:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CB488406AA66;
	Thu, 14 Sep 2023 19:19:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4569F1946A78;
	Thu, 14 Sep 2023 19:19:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB0DC19452C8
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:17:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DBA75406AA67; Thu, 14 Sep 2023 19:17:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D23B3406AA6D
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:53 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9754D1875052
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:53 +0000 (UTC)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com
 [209.85.219.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-fK_qCGbQNQKfXrqYcptt0g-1; Thu, 14 Sep 2023 15:17:51 -0400
X-MC-Unique: fK_qCGbQNQKfXrqYcptt0g-1
Received: by mail-qv1-f41.google.com with SMTP id
 6a1803df08f44-6516a8e2167so7828696d6.2
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:17:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719070; x=1695323870;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=kvIFhdeQ9aNG3yoHWc+VwURQQmLOjJw0YYXOG91GM4Q=;
 b=URbAW8jeBJ0pNxlrZnuIkhc6FMgx8OklTEiD3pWrw1HS+svH+nPvK0v/Rui3oeL7oR
 bMP0KpxcDDWQnTXnR9+ZwoUqVX7uFMHOgeeHPRiXTI4RSx5jngoE8V0Su6yoX4zqJ6Nv
 cigyyl0yTfWISbqmHywrbD7jXatppAPTU6ZL2hpzePafvmstS1y9o1s0VzjtCeiXVQW8
 AMDPOE8Q5uI36ygWnEnQudtFazfPpHHiMBXJGJFU3X9nWZCVmV1EfMu3QouRQSYKATkV
 0aPO2SgpelL8cRxxQmIAT/aCWhvwPf3TWbh5M16U42ho/uPCBRledhcCnDa/wkP8fCSg
 kwJg==
X-Gm-Message-State: AOJu0YyFEoad/OR23V/FWWGGmxOgUcLycw5r39vcr6ufmLHS6s6os3B9
 iDfqJHi9j4T8FXUqFo+lKyOCWAxKedUYtR1hOZ5/0etoOAnzcfQww20ol3/Tqj2I7iZWHtRh/nY
 wJ5z77PuwT29J1ySgAiFrmPwTeLwmxIWZAUr2iDdUCQ+hq1OLG1PCW4Eos5d/G6EsxI3r7ksc
X-Google-Smtp-Source: AGHT+IGvDmIJnXNdO8byCj7rsYBqOiGunjEkCBZzbGrhwC/0bLJS3oXkP82WHexahBXiZeI+gX4FFQ==
X-Received: by 2002:a0c:eecc:0:b0:647:3083:4575 with SMTP id
 h12-20020a0ceecc000000b0064730834575mr7428034qvs.57.1694719070391; 
 Thu, 14 Sep 2023 12:17:50 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 g23-20020a0caad7000000b0064f4749e1a9sm678398qvb.92.2023.09.14.12.17.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:17:49 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:16:33 -0400
Message-Id: <20230914191635.39805-38-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v3 37/39] dm vdo: add debugging support
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

Add support for dumping detailed vdo state to the kernel log via a
dmsetup message. The dump code is not thread-safe and is generally
intended for use only when a vdo is hung.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: Michael Sclafani <vdo-devel@redhat.com>
Signed-off-by: Michael Sclafani <vdo-devel@redhat.com>
Co-developed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Co-developed-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Co-developed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-vdo/dump.c | 288 +++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/dump.h |  17 +++
 2 files changed, 305 insertions(+)
 create mode 100644 drivers/md/dm-vdo/dump.c
 create mode 100644 drivers/md/dm-vdo/dump.h

diff --git a/drivers/md/dm-vdo/dump.c b/drivers/md/dm-vdo/dump.c
new file mode 100644
index 000000000000..d50db3f7a14d
--- /dev/null
+++ b/drivers/md/dm-vdo/dump.c
@@ -0,0 +1,288 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#include "dump.h"
+
+#include <linux/module.h>
+
+#include "memory-alloc.h"
+#include "string-utils.h"
+
+#include "constants.h"
+#include "data-vio.h"
+#include "dedupe.h"
+#include "io-submitter.h"
+#include "logger.h"
+#include "types.h"
+#include "vdo.h"
+#include "work-queue.h"
+
+enum dump_options {
+	/* Work queues */
+	SHOW_QUEUES,
+	/* Memory pools */
+	SHOW_VIO_POOL,
+	/* Others */
+	SHOW_VDO_STATUS,
+	/* This one means an option overrides the "default" choices, instead of altering them. */
+	SKIP_DEFAULT
+};
+
+enum dump_option_flags {
+	/* Work queues */
+	FLAG_SHOW_QUEUES = (1 << SHOW_QUEUES),
+	/* Memory pools */
+	FLAG_SHOW_VIO_POOL = (1 << SHOW_VIO_POOL),
+	/* Others */
+	FLAG_SHOW_VDO_STATUS = (1 << SHOW_VDO_STATUS),
+	/* Special */
+	FLAG_SKIP_DEFAULT = (1 << SKIP_DEFAULT)
+};
+
+enum {
+	FLAGS_ALL_POOLS = (FLAG_SHOW_VIO_POOL),
+	DEFAULT_DUMP_FLAGS = (FLAG_SHOW_QUEUES | FLAG_SHOW_VDO_STATUS)
+};
+
+static inline bool is_arg_string(const char *arg, const char *this_option)
+{
+	/* convention seems to be case-independent options */
+	return strncasecmp(arg, this_option, strlen(this_option)) == 0;
+}
+
+static void do_dump(struct vdo *vdo, unsigned int dump_options_requested, const char *why)
+{
+	u32 active, maximum;
+	s64 outstanding;
+
+	uds_log_info("%s dump triggered via %s", UDS_LOGGING_MODULE_NAME, why);
+	active = get_data_vio_pool_active_requests(vdo->data_vio_pool);
+	maximum = get_data_vio_pool_maximum_requests(vdo->data_vio_pool);
+	outstanding = (atomic64_read(&vdo->stats.bios_submitted) -
+		       atomic64_read(&vdo->stats.bios_completed));
+	uds_log_info("%u device requests outstanding (max %u), %lld bio requests outstanding, device '%s'",
+		     active,
+		     maximum,
+		     outstanding,
+		     vdo_get_device_name(vdo->device_config->owning_target));
+	if (((dump_options_requested & FLAG_SHOW_QUEUES) != 0) && (vdo->threads != NULL)) {
+		thread_id_t id;
+
+		for (id = 0; id < vdo->thread_config.thread_count; id++)
+			vdo_dump_work_queue(vdo->threads[id].queue);
+	}
+
+	vdo_dump_hash_zones(vdo->hash_zones);
+	dump_data_vio_pool(vdo->data_vio_pool, (dump_options_requested & FLAG_SHOW_VIO_POOL) != 0);
+	if ((dump_options_requested & FLAG_SHOW_VDO_STATUS) != 0)
+		vdo_dump_status(vdo);
+
+	uds_report_memory_usage();
+	uds_log_info("end of %s dump", UDS_LOGGING_MODULE_NAME);
+}
+
+static int
+parse_dump_options(unsigned int argc, char *const *argv, unsigned int *dump_options_requested_ptr)
+{
+	unsigned int dump_options_requested = 0;
+
+	static const struct {
+		const char *name;
+		unsigned int flags;
+	} option_names[] = {
+		{ "viopool", FLAG_SKIP_DEFAULT | FLAG_SHOW_VIO_POOL },
+		{ "vdo", FLAG_SKIP_DEFAULT | FLAG_SHOW_VDO_STATUS },
+		{ "pools", FLAG_SKIP_DEFAULT | FLAGS_ALL_POOLS },
+		{ "queues", FLAG_SKIP_DEFAULT | FLAG_SHOW_QUEUES },
+		{ "threads", FLAG_SKIP_DEFAULT | FLAG_SHOW_QUEUES },
+		{ "default", FLAG_SKIP_DEFAULT | DEFAULT_DUMP_FLAGS },
+		{ "all", ~0 },
+	};
+
+	bool options_okay = true;
+	unsigned int i;
+
+	for (i = 1; i < argc; i++) {
+		unsigned int j;
+
+		for (j = 0; j < ARRAY_SIZE(option_names); j++) {
+			if (is_arg_string(argv[i], option_names[j].name)) {
+				dump_options_requested |= option_names[j].flags;
+				break;
+			}
+		}
+		if (j == ARRAY_SIZE(option_names)) {
+			uds_log_warning("dump option name '%s' unknown", argv[i]);
+			options_okay = false;
+		}
+	}
+	if (!options_okay)
+		return -EINVAL;
+	if ((dump_options_requested & FLAG_SKIP_DEFAULT) == 0)
+		dump_options_requested |= DEFAULT_DUMP_FLAGS;
+	*dump_options_requested_ptr = dump_options_requested;
+	return 0;
+}
+
+/* Dump as specified by zero or more string arguments. */
+int vdo_dump(struct vdo *vdo, unsigned int argc, char *const *argv, const char *why)
+{
+	unsigned int dump_options_requested = 0;
+	int result = parse_dump_options(argc, argv, &dump_options_requested);
+
+	if (result != 0)
+		return result;
+
+	do_dump(vdo, dump_options_requested, why);
+	return 0;
+}
+
+/* Dump everything we know how to dump */
+void vdo_dump_all(struct vdo *vdo, const char *why)
+{
+	do_dump(vdo, ~0, why);
+}
+
+/*
+ * Dump out the data_vio waiters on a wait queue.
+ * wait_on should be the label to print for queue (e.g. logical or physical)
+ */
+static void dump_vio_waiters(struct wait_queue *queue, char *wait_on)
+{
+	struct waiter *waiter, *first = vdo_get_first_waiter(queue);
+	struct data_vio *data_vio;
+
+	if (first == NULL)
+		return;
+
+	data_vio = waiter_as_data_vio(first);
+
+	uds_log_info("      %s is locked. Waited on by: vio %px pbn %llu lbn %llu d-pbn %llu lastOp %s",
+		     wait_on,
+		     data_vio,
+		     data_vio->allocation.pbn,
+		     data_vio->logical.lbn,
+		     data_vio->duplicate.pbn,
+		     get_data_vio_operation_name(data_vio));
+
+	for (waiter = first->next_waiter; waiter != first; waiter = waiter->next_waiter) {
+		data_vio = waiter_as_data_vio(waiter);
+		uds_log_info("     ... and : vio %px pbn %llu lbn %llu d-pbn %llu lastOp %s",
+			     data_vio,
+			     data_vio->allocation.pbn,
+			     data_vio->logical.lbn,
+			     data_vio->duplicate.pbn,
+			     get_data_vio_operation_name(data_vio));
+	}
+}
+
+/*
+ * Encode various attributes of a data_vio as a string of one-character flags. This encoding is for
+ * logging brevity:
+ *
+ * R => vio completion result not VDO_SUCCESS
+ * W => vio is on a wait queue
+ * D => vio is a duplicate
+ * p => vio is a partial block operation
+ * z => vio is a zero block
+ * d => vio is a discard
+ *
+ * The common case of no flags set will result in an empty, null-terminated buffer. If any flags
+ * are encoded, the first character in the string will be a space character.
+ */
+static void encode_vio_dump_flags(struct data_vio *data_vio, char buffer[8])
+{
+	char *p_flag = buffer;
+	*p_flag++ = ' ';
+	if (data_vio->vio.completion.result != VDO_SUCCESS)
+		*p_flag++ = 'R';
+	if (data_vio->waiter.next_waiter != NULL)
+		*p_flag++ = 'W';
+	if (data_vio->is_duplicate)
+		*p_flag++ = 'D';
+	if (data_vio->is_partial)
+		*p_flag++ = 'p';
+	if (data_vio->is_zero)
+		*p_flag++ = 'z';
+	if (data_vio->remaining_discard > 0)
+		*p_flag++ = 'd';
+	if (p_flag == &buffer[1])
+		/* No flags, so remove the blank space. */
+		p_flag = buffer;
+	*p_flag = '\0';
+}
+
+/* Implements buffer_dump_function. */
+void dump_data_vio(void *data)
+{
+	struct data_vio *data_vio = (struct data_vio *) data;
+
+	/*
+	 * This just needs to be big enough to hold a queue (thread) name and a function name (plus
+	 * a separator character and NUL). The latter is limited only by taste.
+	 *
+	 * In making this static, we're assuming only one "dump" will run at a time. If more than
+	 * one does run, the log output will be garbled anyway.
+	 */
+	static char vio_completion_dump_buffer[100 + MAX_VDO_WORK_QUEUE_NAME_LEN];
+	/* Another static buffer... log10(256) = 2.408+, round up: */
+	enum { DIGITS_PER_U64 = 1 + sizeof(u64) * 2409 / 1000 };
+
+	static char vio_block_number_dump_buffer[sizeof("P L D") + 3 * DIGITS_PER_U64];
+	static char vio_flush_generation_buffer[sizeof(" FG") + DIGITS_PER_U64];
+	static char flags_dump_buffer[8];
+
+	/*
+	 * We're likely to be logging a couple thousand of these lines, and in some circumstances
+	 * syslogd may have trouble keeping up, so keep it BRIEF rather than user-friendly.
+	 */
+	vdo_dump_completion_to_buffer(&data_vio->vio.completion,
+				      vio_completion_dump_buffer,
+				      sizeof(vio_completion_dump_buffer));
+	if (data_vio->is_duplicate)
+		snprintf(vio_block_number_dump_buffer,
+			 sizeof(vio_block_number_dump_buffer),
+			 "P%llu L%llu D%llu",
+			 data_vio->allocation.pbn,
+			 data_vio->logical.lbn,
+			 data_vio->duplicate.pbn);
+	else if (data_vio_has_allocation(data_vio))
+		snprintf(vio_block_number_dump_buffer,
+			 sizeof(vio_block_number_dump_buffer),
+			 "P%llu L%llu",
+			 data_vio->allocation.pbn,
+			 data_vio->logical.lbn);
+	else
+		snprintf(vio_block_number_dump_buffer,
+			 sizeof(vio_block_number_dump_buffer),
+			 "L%llu",
+			 data_vio->logical.lbn);
+
+	if (data_vio->flush_generation != 0)
+		snprintf(vio_flush_generation_buffer,
+			 sizeof(vio_flush_generation_buffer),
+			 " FG%llu",
+			 data_vio->flush_generation);
+	else
+		vio_flush_generation_buffer[0] = 0;
+
+	encode_vio_dump_flags(data_vio, flags_dump_buffer);
+
+	uds_log_info("	vio %px %s%s %s %s%s",
+		     data_vio,
+		     vio_block_number_dump_buffer,
+		     vio_flush_generation_buffer,
+		     get_data_vio_operation_name(data_vio),
+		     vio_completion_dump_buffer,
+		     flags_dump_buffer);
+	/*
+	 * might want info on: wantUDSAnswer / operation / status
+	 * might want info on: bio / bios_merged
+	 */
+
+	dump_vio_waiters(&data_vio->logical.waiters, "lbn");
+
+	/* might want to dump more info from vio here */
+}
diff --git a/drivers/md/dm-vdo/dump.h b/drivers/md/dm-vdo/dump.h
new file mode 100644
index 000000000000..ad47c70cca78
--- /dev/null
+++ b/drivers/md/dm-vdo/dump.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#ifndef VDO_DUMP_H
+#define VDO_DUMP_H
+
+#include "types.h"
+
+int vdo_dump(struct vdo *vdo, unsigned int argc, char *const *argv, const char *why);
+
+void vdo_dump_all(struct vdo *vdo, const char *why);
+
+void dump_data_vio(void *data);
+
+#endif /* VDO_DUMP_H */
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

