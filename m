Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2953CC7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 21:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684878366;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fnYEUPjaFQVZXCsHGbulvDofKONgX6CYz1ucnE08q1U=;
	b=dV0YhPbsLMNDNPOXP8XlmabDHZrKdxBMzFXYuBXdWZ6XX6/8Uif9Ui+1q6U7pp9pAnRKYe
	KViDT+80IWmVzkY8N8BrpiCPPVReiirBW9hlf5PUUm5ylPdQN8ESY/F1J/2oHg1Qi7NwtS
	futEq9UsU04jNt1Qn25ORh1B0Ul9MN8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-8CVTh9W0NCGpQ4tdxUv3Rg-1; Tue, 23 May 2023 17:45:57 -0400
X-MC-Unique: 8CVTh9W0NCGpQ4tdxUv3Rg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A8EE185A78B;
	Tue, 23 May 2023 21:45:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DCFA8482060;
	Tue, 23 May 2023 21:45:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CAA3019465B7;
	Tue, 23 May 2023 21:45:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AC0F619466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 21:45:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 90900140E962; Tue, 23 May 2023 21:45:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 88108140E95D
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:45:53 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5ACDA3C14AA5
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:45:53 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-FJlYwdNJNN6c7TKkL_kWFQ-1; Tue, 23 May 2023 17:45:52 -0400
X-MC-Unique: FJlYwdNJNN6c7TKkL_kWFQ-1
Received: by mail-qk1-f198.google.com with SMTP id
 af79cd13be357-75b2f94940bso54359185a.2
 for <dm-devel@redhat.com>; Tue, 23 May 2023 14:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684878351; x=1687470351;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=BXVHYJI4o65v3yWmtJqqd5Md+0xUsboI9mynlQtwVCQ=;
 b=IfvvCRwopxHLYuMl8Hvm06nK0ndubdBipCdQrnPYx1ba3f/uxJC4FM8JgIB3G5U2bK
 zjxUjk235fR/so984A62nJU4lnJTmtkV3iQUVcxT2Htkok9qsbYoicpgLE1iRGkqcDz9
 dWPxSVuiZkM87VosQUT9JP/FkrjXvg2mkvGUyrCQm2H0Cq8QwHUxLUK8nH4QM8NnBvcT
 U0Dzxyk/r6CwQOfQv8rWRO7mlGU9tlyrRpRCKGDM2QucnZwS1seFy6Ypij7Ed384uumZ
 OYZ4+NDcR+CmeaNZ+eVbz7jOcjqXURYGjbUhcp4MQHD7oFItdVCBEJ1DcGy4EJlB7dme
 CH6A==
X-Gm-Message-State: AC+VfDyi51QmXbTbzb5+ilJWV5IL6hi71eCwoH9XFk8pjMfkhK+F4hg4
 CQIRI80fvancCp1bvYW8x9pCQE9yYqIkrnQsPdKSErn0NIF6/hx8iWzLypS9GGgSlubxE+Pl6Y3
 ZwjqEADaF30jJbKvjaHZBJbtBXooS+y2H1QRJ7iGcra5uX/jT3TVJvWvmvqPphb6kUtFGHbBp
X-Received: by 2002:a05:620a:1a1f:b0:75b:23a1:45f with SMTP id
 bk31-20020a05620a1a1f00b0075b23a1045fmr6833601qkb.37.1684878350829; 
 Tue, 23 May 2023 14:45:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7HXk9kHw0f/SefZKzFY77LK9R6InSBb50RjDoveKLrWQ9VfLxogn8LEHfLNX3eMxMg8Zam4g==
X-Received: by 2002:a05:620a:1a1f:b0:75b:23a1:45f with SMTP id
 bk31-20020a05620a1a1f00b0075b23a1045fmr6833526qkb.37.1684878349843; 
 Tue, 23 May 2023 14:45:49 -0700 (PDT)
Received: from bf36-1.. (173-166-2-198-newengland.hfc.comcastbusiness.net.
 [173.166.2.198]) by smtp.gmail.com with ESMTPSA id
 s24-20020ae9f718000000b0074fafbea974sm2821592qkg.2.2023.05.23.14.45.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 14:45:49 -0700 (PDT)
From: "J. corwin Coburn" <corwin@redhat.com>
To: dm-devel@redhat.com,
	linux-block@vger.kernel.org
Date: Tue, 23 May 2023 17:45:04 -0400
Message-Id: <20230523214539.226387-5-corwin@redhat.com>
In-Reply-To: <20230523214539.226387-1-corwin@redhat.com>
References: <20230523214539.226387-1-corwin@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v2 04/39] Add basic logging and support utilities.
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

Add various support utilities for the vdo target and deduplication index,
including logging utilities, string and time management, and index-specific
error codes.

Signed-off-by: J. corwin Coburn <corwin@redhat.com>
---
 drivers/md/dm-vdo/errors.c       | 316 +++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/errors.h       |  83 ++++++++
 drivers/md/dm-vdo/logger.c       | 304 +++++++++++++++++++++++++++++
 drivers/md/dm-vdo/logger.h       | 112 +++++++++++
 drivers/md/dm-vdo/permassert.c   |  35 ++++
 drivers/md/dm-vdo/permassert.h   |  65 +++++++
 drivers/md/dm-vdo/string-utils.c |  28 +++
 drivers/md/dm-vdo/string-utils.h |  23 +++
 drivers/md/dm-vdo/time-utils.h   |  28 +++
 9 files changed, 994 insertions(+)
 create mode 100644 drivers/md/dm-vdo/errors.c
 create mode 100644 drivers/md/dm-vdo/errors.h
 create mode 100644 drivers/md/dm-vdo/logger.c
 create mode 100644 drivers/md/dm-vdo/logger.h
 create mode 100644 drivers/md/dm-vdo/permassert.c
 create mode 100644 drivers/md/dm-vdo/permassert.h
 create mode 100644 drivers/md/dm-vdo/string-utils.c
 create mode 100644 drivers/md/dm-vdo/string-utils.h
 create mode 100644 drivers/md/dm-vdo/time-utils.h

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
index 00000000000..1740bac8936
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
+	/* A problem has occurred with a buffer */
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
diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
new file mode 100644
index 00000000000..45a9d8b3936
--- /dev/null
+++ b/drivers/md/dm-vdo/logger.c
@@ -0,0 +1,304 @@
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
+/**
+ * emit_log_message_to_kernel() - Emit a log message to the kernel at the specified priority.
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
+/**
+ * emit_log_message() - Emit a log message to the kernel log in a format suited to the current
+ *                      thread context.
+ *
+ * Context info formats:
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
index 00000000000..a27cf84a953
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
+/* Utilities related to string manipulation */
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
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

