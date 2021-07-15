Return-Path: <SRS0=U3zJ=MH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HELLOMYDEAR,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31DEC1B08C
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jul 2021 10:54:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 44EDF61380
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jul 2021 10:54:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44EDF61380
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-oVQo94yWMhCKrLS20MlDMw-1; Thu, 15 Jul 2021 06:54:55 -0400
X-MC-Unique: oVQo94yWMhCKrLS20MlDMw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B58E101C8CF;
	Thu, 15 Jul 2021 10:54:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D03A175B9;
	Thu, 15 Jul 2021 10:54:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D65591809CB4;
	Thu, 15 Jul 2021 10:54:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16FAqjvA015581 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Jul 2021 06:52:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DD4962087455; Thu, 15 Jul 2021 10:52:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4843208BDF1
	for <dm-devel@redhat.com>; Thu, 15 Jul 2021 10:52:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB1EE1078464
	for <dm-devel@redhat.com>; Thu, 15 Jul 2021 10:52:41 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-510-S3S7S0k5OASlguxYXKe_BQ-1; Thu, 15 Jul 2021 06:52:39 -0400
X-MC-Unique: S3S7S0k5OASlguxYXKe_BQ-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB10F22919;
	Thu, 15 Jul 2021 10:52:37 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 9281E13AB7;
	Thu, 15 Jul 2021 10:52:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap1.suse-dmz.suse.de with ESMTPSA id AJspInUT8GDQIAAAGKfGzw
	(envelope-from <mwilck@suse.com>); Thu, 15 Jul 2021 10:52:37 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 15 Jul 2021 12:52:16 +0200
Message-Id: <20210715105223.30463-3-mwilck@suse.com>
In-Reply-To: <20210715105223.30463-1-mwilck@suse.com>
References: <20210715105223.30463-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16FAqjvA015581
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/9] libmultipath: strbuf: simple api for growing
	string buffers
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Add an API for string buffers that grow in size as text is added.
This API will be useful in several places of the multipath-tools code
base. Add unit tests for these helpers, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile |   2 +-
 libmultipath/strbuf.c | 207 +++++++++++++++++++++
 libmultipath/strbuf.h | 168 +++++++++++++++++
 tests/Makefile        |   3 +-
 tests/strbuf.c        | 412 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 790 insertions(+), 2 deletions(-)
 create mode 100644 libmultipath/strbuf.c
 create mode 100644 libmultipath/strbuf.h
 create mode 100644 tests/strbuf.c

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index e7254f3..7f3921c 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -53,7 +53,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
 	lock.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
 	io_err_stat.o dm-generic.o generic.o foreign.o nvme-lib.o \
-	libsg.o valid.o
+	libsg.o valid.o strbuf.o
 
 all:	$(DEVLIB)
 
diff --git a/libmultipath/strbuf.c b/libmultipath/strbuf.c
new file mode 100644
index 0000000..8422a50
--- /dev/null
+++ b/libmultipath/strbuf.c
@@ -0,0 +1,207 @@
+/*
+ * Copyright (c) 2021 SUSE LLC
+ * SPDX-License-Identifier: GPL-2.0-only
+ */
+#include <inttypes.h>
+#include <stdint.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <assert.h>
+#include "strbuf.h"
+
+static const char empty_str[] = "";
+
+const char *get_strbuf_str(const struct strbuf *buf)
+{
+	return buf->buf ? buf->buf : empty_str;
+}
+
+char *steal_strbuf_str(struct strbuf *buf)
+{
+	char *p = buf->buf;
+
+	buf->buf = NULL;
+	buf->size = buf->offs = 0;
+	return p;
+}
+
+size_t get_strbuf_len(const struct strbuf *buf)
+{
+	return buf->offs;
+}
+
+static bool strbuf_is_sane(const struct strbuf *buf)
+{
+	return buf && ((!buf->buf && !buf->size && !buf->offs) ||
+		       (buf->buf && buf->size && buf->size > buf->offs));
+}
+
+void reset_strbuf(struct strbuf *buf)
+{
+	free(buf->buf);
+	buf->buf = NULL;
+	buf->size = buf->offs = 0;
+}
+
+void free_strbuf(struct strbuf *buf)
+{
+	if (!buf)
+		return;
+	reset_strbuf(buf);
+	free(buf);
+}
+
+struct strbuf *new_strbuf(void)
+{
+	return calloc(1, sizeof(struct strbuf));
+}
+
+int truncate_strbuf(struct strbuf *buf, size_t offs)
+{
+	if (!buf->buf)
+		return -EFAULT;
+	if (offs > buf->offs)
+		return -ERANGE;
+
+	buf->offs = offs;
+	buf->buf[offs] = '\0';
+	return 0;
+}
+
+#define BUF_CHUNK 64
+
+static int expand_strbuf(struct strbuf *buf, int addsz)
+{
+	size_t add;
+	char *tmp;
+
+	assert(strbuf_is_sane(buf));
+	if (addsz < 0)
+		return -EINVAL;
+	if (buf->size - buf->offs >= (size_t)addsz + 1)
+		return 0;
+
+	add = ((addsz + 1 - (buf->size - buf->offs)) / BUF_CHUNK + 1)
+		* BUF_CHUNK;
+
+	if (buf->size >= SIZE_MAX - add) {
+		add = SIZE_MAX - buf->size;
+		if (add < (size_t)addsz + 1)
+			return -EOVERFLOW;
+	}
+
+	tmp = realloc(buf->buf, buf->size + add);
+	if (!tmp)
+		return -ENOMEM;
+
+	buf->buf = tmp;
+	buf->size += add;
+	buf->buf[buf->offs] = '\0';
+
+	return 0;
+}
+
+int __append_strbuf_str(struct strbuf *buf, const char *str, int slen)
+{
+	int ret;
+
+	if ((ret = expand_strbuf(buf, slen)) < 0)
+		return ret;
+
+	buf->offs = (char *)mempcpy(buf->buf + buf->offs, str, slen)
+		- buf->buf;
+	buf->buf[buf->offs] = '\0';
+
+	return slen;
+}
+
+int append_strbuf_str(struct strbuf *buf, const char *str)
+{
+	size_t slen;
+
+	if (!str)
+		return -EINVAL;
+
+	slen = strlen(str);
+	if (slen > INT_MAX)
+		return -ERANGE;
+
+	return __append_strbuf_str(buf, str, slen);
+}
+
+int fill_strbuf(struct strbuf *buf, char c, int slen)
+{
+	int ret;
+
+	if ((ret = expand_strbuf(buf, slen)) < 0)
+		return ret;
+
+	memset(buf->buf + buf->offs, c, slen);
+	buf->offs += slen;
+	buf->buf[buf->offs] = '\0';
+
+	return slen;
+}
+
+int append_strbuf_quoted(struct strbuf *buff, const char *ptr)
+{
+	char *quoted, *q;
+	const char *p;
+	unsigned n_quotes, i;
+	size_t qlen;
+	int ret;
+
+	if (!ptr)
+		return -EINVAL;
+
+	for (n_quotes = 0, p = strchr(ptr, '"'); p; p = strchr(++p, '"'))
+		n_quotes++;
+
+	/* leading + trailing quote, 1 extra quote for every quote in ptr */
+	qlen = strlen(ptr) + 2 + n_quotes;
+	if (qlen > INT_MAX)
+		return -ERANGE;
+	if ((ret = expand_strbuf(buff, qlen)) < 0)
+		return ret;
+
+	quoted = &(buff->buf[buff->offs]);
+	*quoted++ = '"';
+	for (p = ptr, q = quoted, i = 0; i < n_quotes; i++) {
+		char *q1 = memccpy(q, p, '"', qlen - 2 - (q - quoted));
+
+		assert(q1 != NULL);
+		p += q1 - q;
+		*q1++ = '"';
+		q = q1;
+	}
+	q = mempcpy(q, p, qlen - 2 - (q - quoted));
+	*q++ = '"';
+	*q = '\0';
+	ret = q - &(buff->buf[buff->offs]);
+	buff->offs += ret;
+	return ret;
+}
+
+__attribute__((format(printf, 2, 3)))
+int print_strbuf(struct strbuf *buf, const char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+	char *tail;
+
+	va_start(ap, fmt);
+	ret = vasprintf(&tail, fmt, ap);
+	va_end(ap);
+
+	if (ret < 0)
+		return -ENOMEM;
+
+	ret = __append_strbuf_str(buf, tail, ret);
+
+	free(tail);
+	return ret;
+}
diff --git a/libmultipath/strbuf.h b/libmultipath/strbuf.h
new file mode 100644
index 0000000..5903572
--- /dev/null
+++ b/libmultipath/strbuf.h
@@ -0,0 +1,168 @@
+/*
+ * Copyright (c) 2021 SUSE LLC
+ * SPDX-License-Identifier: GPL-2.0-only
+ */
+#ifndef _STRBUF_H
+#define _STRBUF_H
+#include <errno.h>
+#include <string.h>
+
+struct strbuf {
+	char *buf;
+	size_t size;
+	size_t offs;
+};
+
+/**
+ * reset_strbuf(): prepare strbuf for new content
+ * @param strbuf: string buffer to reset
+ *
+ * Frees internal buffer and resets size and offset to 0.
+ * Can be used to cleanup a struct strbuf on stack.
+ */
+void reset_strbuf(struct strbuf *buf);
+
+/**
+ * free_strbuf(): free resources
+ * @param strbuf: string buffer to discard
+ *
+ * Frees all memory occupied by a struct strbuf.
+ */
+void free_strbuf(struct strbuf *buf);
+
+/**
+ * macro: STRBUF_INIT
+ *
+ * Use this to initialize a local struct strbuf on the stack,
+ * or in a global/static variable.
+ */
+#define STRBUF_INIT { .buf = NULL, }
+
+/**
+ * macro: STRBUF_ON_STACK
+ *
+ * Define and initialize a local struct @strbuf to be cleaned up when
+ * the current scope is left
+ */
+#define STRBUF_ON_STACK(__x)						\
+	struct strbuf __attribute__((cleanup(reset_strbuf))) (__x) = STRBUF_INIT;
+
+/**
+ * new_strbuf(): allocate a struct strbuf on the heap
+ *
+ * @returns: pointer to allocated struct, or NULL in case of error.
+ */
+struct strbuf *new_strbuf(void);
+
+/**
+ * get_strbuf_str(): retrieve string from strbuf
+ * @param buf: a struct strbuf
+ * @returns: pointer to the string written to the strbuf so far.
+ *
+ * If @strbuf was never written to, the function returns a zero-
+ * length string. The return value of this function must not be
+ * free()d.
+ */
+const char *get_strbuf_str(const struct strbuf *buf);
+
+/**
+ * steal_strbuf_str(): retrieve string from strbuf and reset
+ * @param buf: a struct strbuf
+ * @returns: pointer to the string written to @strbuf, or NULL
+ *
+ * After calling this function, the @strbuf is empty as if freshly
+ * initialized. The caller is responsible to free() the returned pointer.
+ * If @strbuf was never written to (not even an empty string was appended),
+ * the function returns NULL.
+ */
+char *steal_strbuf_str(struct strbuf *buf);
+
+/**
+ * get_strbuf_len(): retrieve string length from strbuf
+ * @param buf: a struct strbuf
+ * @returns: the length of the string written to @strbuf so far.
+ */
+size_t get_strbuf_len(const struct strbuf *buf);
+
+/**
+ * truncate_strbuf(): shorten the buffer
+ * @param buf: struct strbuf to truncate
+ * @param offs: new buffer position / offset
+ * @returns: 0 on success, negative error code otherwise.
+ *
+ * If @strbuf is freshly allocated/reset (never written to), -EFAULT
+ * is returned. if @offs must be higher than the current offset as returned
+ * by get_strbuf_len(), -ERANGE is returned. The allocated size of the @strbuf
+ * remains unchanged.
+ */
+int truncate_strbuf(struct strbuf *buf, size_t offs);
+
+/**
+ * __append_strbuf_str(): append string of known length
+ * @param buf: the struct strbuf to write to
+ * @param str: the string to append, not necessarily 0-terminated
+ * @param slen: max number of characters to append, must be non-negative
+ * @returns: @slen = number of appended characters if successful (excluding
+ * terminating '\0'); negative error code otherwise.
+ *
+ * Notes: a 0-byte is always appended to the output buffer after @slen characters.
+ * 0-bytes possibly contained in the first @slen characters are copied into
+ * the output. If the function returns an error, @strbuf is unchanged.
+ */
+int __append_strbuf_str(struct strbuf *buf, const char *str, int slen);
+
+/**
+ * append_strbuf_str(): append string
+ * @param buf: the struct strbuf to write to
+ * @param str: the string to append, 0-terminated
+ * @returns: number of appended characters if successful (excluding
+ * terminating '\0'); negative error code otherwise
+ *
+ * Appends the given 0-terminated string to @strbuf, expanding @strbuf's size
+ * as necessary. If the function returns an error, @strbuf is unchanged.
+ */
+int append_strbuf_str(struct strbuf *buf, const char *str);
+
+/**
+ * fill_strbuf_str(): pad strbuf with a character
+ * @param buf: the struct strbuf to write to
+ * @param c: the character used for filling
+ * @param slen: max number of characters to append, must be non-negative
+ * @returns: number of appended characters if successful (excluding
+ * terminating '\0'); negative error code otherwise
+ *
+ * Appends the given character @slen times to @strbuf, expanding @strbuf's size
+ * as necessary. If the function returns an error, @strbuf is unchanged.
+ */
+int fill_strbuf(struct strbuf *buf, char c, int slen);
+
+/**
+ * append_strbuf_quoted(): append string in double quotes, escaping quotes in string
+ * @param buf: the struct strbuf to write to
+ * @param str: the string to append, 0-terminated
+ * @returns: number of appended characters if successful (excluding
+ * terminating '\0'); negative error code otherwise
+ *
+ * Appends the given string to @strbuf, with leading and trailing double
+ * quotes (") added, expanding @strbuf's size as necessary. Any double quote
+ * characters (") in the string are transformed to double double quotes ("").
+ * If the function returns an error, @strbuf is unchanged.
+ */
+int append_strbuf_quoted(struct strbuf *buf, const char *str);
+
+/**
+ * print_strbuf(): print to strbuf, formatted
+ * @param buf: the struct strbuf to print to
+ * @param fmt: printf()-like format string
+ * @returns: number of appended characters if successful, (excluding
+ * terminating '\0'); negative error code otherwise
+ *
+ * Appends the the arguments following @fmt, formatted as in printf(), to
+ * @strbuf, expanding @strbuf's size as necessary. The function makes sure that
+ * the output @strbuf is always 0-terminated.
+ * If the function returns an error, @strbuf is unchanged.
+ */
+__attribute__((format(printf, 2, 3)))
+int print_strbuf(struct strbuf *buf, const char *fmt, ...);
+
+#endif
diff --git a/tests/Makefile b/tests/Makefile
index e70c8ed..8cbc4b7 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -13,7 +13,7 @@ CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) \
 LIBDEPS += -L. -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
-	 alias directio valid devt mpathvalid
+	 alias directio valid devt mpathvalid strbuf
 HELPERS := test-lib.o test-log.o
 
 .SILENT: $(TESTS:%=%.o)
@@ -63,6 +63,7 @@ mpathvalid-test_OBJDEPS := ../libmpathvalid/mpath_valid.o
 ifneq ($(DIO_TEST_DEV),)
 directio-test_LIBDEPS := -laio
 endif
+strbuf-test_OBJDEPS := ../libmultipath/strbuf.o
 
 %.o: %.c
 	$(CC) $(CFLAGS) $($*-test_FLAGS) -c -o $@ $<
diff --git a/tests/strbuf.c b/tests/strbuf.c
new file mode 100644
index 0000000..43a477d
--- /dev/null
+++ b/tests/strbuf.c
@@ -0,0 +1,412 @@
+/*
+ * Copyright (c) 2021 SUSE LLC
+ * SPDX-License-Identifier: GPL-2.0-only
+ */
+
+#define _GNU_SOURCE
+#include <stdbool.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <cmocka.h>
+#include <errno.h>
+#include "strbuf.h"
+#include "debug.h"
+#include "globals.c"
+
+void *__real_realloc(void *ptr, size_t size);
+
+static bool mock_realloc = false;
+void *__wrap_realloc(void *ptr, size_t size)
+{
+	void *p;
+	if (!mock_realloc)
+		return __real_realloc(ptr, size);
+
+	p = mock_ptr_type(void *);
+	condlog(4, "%s: %p, %zu -> %p", __func__, ptr, size, p);
+	return p;
+}
+
+static void test_strbuf_00(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	char *p;
+
+	assert_ptr_equal(buf.buf, NULL);
+	assert_int_equal(buf.size, 0);
+	assert_int_equal(buf.offs, 0);
+	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_string_equal(get_strbuf_str(&buf), "");
+	p = steal_strbuf_str(&buf);
+	assert_ptr_equal(p, NULL);
+
+	assert_ptr_equal(buf.buf, NULL);
+	assert_int_equal(buf.size, 0);
+	assert_int_equal(buf.offs, 0);
+	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_string_equal(get_strbuf_str(&buf), "");
+
+	assert_int_equal(append_strbuf_str(&buf, "moin"), 4);
+	assert_int_equal(get_strbuf_len(&buf), 4);
+	assert_in_range(buf.size, 5, SIZE_MAX);
+	assert_string_equal(get_strbuf_str(&buf), "moin");
+	p = steal_strbuf_str(&buf);
+	assert_string_equal(p, "moin");
+	free(p);
+
+	assert_ptr_equal(buf.buf, NULL);
+	assert_int_equal(buf.size, 0);
+	assert_int_equal(buf.offs, 0);
+	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_string_equal(get_strbuf_str(&buf), "");
+
+	assert_int_equal(append_strbuf_str(&buf, NULL), -EINVAL);
+	assert_int_equal(buf.size, 0);
+	assert_int_equal(buf.offs, 0);
+	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_string_equal(get_strbuf_str(&buf), "");
+
+	assert_int_equal(append_strbuf_str(&buf, ""), 0);
+	/* appending a 0-length string allocates memory */
+	assert_in_range(buf.size, 1, SIZE_MAX);
+	assert_int_equal(buf.offs, 0);
+	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_string_equal(get_strbuf_str(&buf), "");
+	p = steal_strbuf_str(&buf);
+	assert_string_equal(p, "");
+	free(p);
+
+	assert_int_equal(__append_strbuf_str(&buf, "x", 0), 0);
+	/* appending a 0-length string allocates memory */
+	assert_in_range(buf.size, 1, SIZE_MAX);
+	assert_int_equal(buf.offs, 0);
+	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_string_equal(get_strbuf_str(&buf), "");
+}
+
+static void test_strbuf_alloc_err(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	size_t sz, ofs;
+	int rc;
+
+	mock_realloc = true;
+	will_return(__wrap_realloc, NULL);
+	assert_int_equal(append_strbuf_str(&buf, "moin"), -ENOMEM);
+	assert_int_equal(buf.size, 0);
+	assert_int_equal(buf.offs, 0);
+	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_string_equal(get_strbuf_str(&buf), "");
+
+	mock_realloc = false;
+	assert_int_equal(append_strbuf_str(&buf, "moin"), 4);
+	sz = buf.size;
+	assert_in_range(sz, 5, SIZE_MAX);
+	assert_int_equal(buf.offs, 4);
+	assert_int_equal(get_strbuf_len(&buf), 4);
+	assert_string_equal(get_strbuf_str(&buf), "moin");
+
+	mock_realloc = true;
+	will_return(__wrap_realloc, NULL);
+	ofs = get_strbuf_len(&buf);
+	while ((rc = append_strbuf_str(&buf, " hello")) >= 0) {
+		condlog(3, "%s", get_strbuf_str(&buf));
+		assert_int_equal(rc, 6);
+		assert_int_equal(get_strbuf_len(&buf), ofs + 6);
+		assert_memory_equal(get_strbuf_str(&buf), "moin", 4);
+		assert_string_equal(get_strbuf_str(&buf) + ofs, " hello");
+		ofs = get_strbuf_len(&buf);
+	}
+	assert_int_equal(rc, -ENOMEM);
+	assert_int_equal(buf.size, sz);
+	assert_int_equal(get_strbuf_len(&buf), ofs);
+	assert_memory_equal(get_strbuf_str(&buf), "moin", 4);
+	assert_string_equal(get_strbuf_str(&buf) + ofs - 6, " hello");
+
+	reset_strbuf(&buf);
+	assert_ptr_equal(buf.buf, NULL);
+	assert_int_equal(buf.size, 0);
+	assert_int_equal(buf.offs, 0);
+	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_string_equal(get_strbuf_str(&buf), "");
+
+	mock_realloc = false;
+}
+
+static void test_strbuf_overflow(void **state)
+{
+	STRBUF_ON_STACK(buf);
+
+	assert_int_equal(append_strbuf_str(&buf, "x"), 1);
+	/* fake huge buffer */
+	buf.size = SIZE_MAX - 1;
+	buf.offs = buf.size - 1;
+	assert_int_equal(append_strbuf_str(&buf, "x"), -EOVERFLOW);
+}
+
+static void test_strbuf_big(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	const char big[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\n";
+	char *bbig;
+	int i;
+
+	/* Under valgrind, 30000 iterations need ca. 30s on my laptop */
+	for (i = 0; i < 30000; i++) {
+		if (i % 1000 == 0)
+			condlog(4, "%d", i);
+		assert_int_equal(append_strbuf_str(&buf, big), sizeof(big) - 1);
+		assert_int_equal(get_strbuf_len(&buf), (sizeof(big) - 1) * (i + 1));
+		assert_memory_equal(get_strbuf_str(&buf), big, sizeof(big) - 1);
+		assert_string_equal(get_strbuf_str(&buf) + get_strbuf_len(&buf)
+				    - (sizeof(big) - 1), big);
+	};
+	bbig = steal_strbuf_str(&buf);
+
+	assert_ptr_equal(buf.buf, NULL);
+	assert_int_equal(buf.size, 0);
+	assert_int_equal(buf.offs, 0);
+	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_string_equal(get_strbuf_str(&buf), "");
+
+	assert_int_equal(strlen(bbig), i * (sizeof(big) - 1));
+	assert_memory_equal(bbig, big, sizeof(big) - 1);
+	free(bbig);
+}
+
+static void test_strbuf_nul(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	char greet[] = "hello, sir!";
+
+	assert_int_equal(__append_strbuf_str(&buf, greet, 6), 6);
+	assert_string_equal(get_strbuf_str(&buf), "hello,");
+	assert_int_equal(__append_strbuf_str(&buf, greet, 6), 6);
+	assert_string_equal(get_strbuf_str(&buf), "hello,hello,");
+
+	/* overwrite comma with NUL; append_strbuf_str() stops at NUL byte */
+	greet[5] = '\0';
+	reset_strbuf(&buf);
+	assert_int_equal(append_strbuf_str(&buf, greet), 5);
+	assert_int_equal(get_strbuf_len(&buf), 5);
+	assert_string_equal(get_strbuf_str(&buf), "hello");
+	assert_int_equal(append_strbuf_str(&buf, greet), 5);
+	assert_int_equal(get_strbuf_len(&buf), 10);
+	assert_string_equal(get_strbuf_str(&buf), "hellohello");
+
+	/* __append_strbuf_str() appends full memory, including NUL bytes */
+	reset_strbuf(&buf);
+	assert_int_equal(__append_strbuf_str(&buf, greet, sizeof(greet) - 1),
+			 sizeof(greet) - 1);
+	assert_int_equal(get_strbuf_len(&buf), sizeof(greet) - 1);
+	assert_string_equal(get_strbuf_str(&buf), "hello");
+	assert_string_equal(get_strbuf_str(&buf) + get_strbuf_len(&buf) - 5, " sir!");
+	assert_int_equal(__append_strbuf_str(&buf, greet, sizeof(greet) - 1),
+			 sizeof(greet) - 1);
+	assert_string_equal(get_strbuf_str(&buf), "hello");
+	assert_int_equal(get_strbuf_len(&buf), 2 * (sizeof(greet) - 1));
+	assert_string_equal(get_strbuf_str(&buf) + get_strbuf_len(&buf) - 5, " sir!");
+}
+
+static void test_strbuf_quoted(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	const char said[] = "She said ";
+	const char greet[] = "hi, man!";
+	char *p;
+	size_t n;
+
+	assert_int_equal(append_strbuf_str(&buf, said), sizeof(said) - 1);
+	assert_int_equal(append_strbuf_quoted(&buf, greet), sizeof(greet) + 1);
+	assert_string_equal(get_strbuf_str(&buf), "She said \"hi, man!\"");
+	n = get_strbuf_len(&buf);
+	p = steal_strbuf_str(&buf);
+	assert_int_equal(append_strbuf_str(&buf, said), sizeof(said) - 1);
+	assert_int_equal(append_strbuf_quoted(&buf, p), n + 4);
+	assert_string_equal(get_strbuf_str(&buf),
+			    "She said \"She said \"\"hi, man!\"\"\"");
+	free(p);
+	n = get_strbuf_len(&buf);
+	p = steal_strbuf_str(&buf);
+	assert_int_equal(append_strbuf_str(&buf, said), sizeof(said) - 1);
+	assert_int_equal(append_strbuf_quoted(&buf, p), n + 8);
+	assert_string_equal(get_strbuf_str(&buf),
+			    "She said \"She said \"\"She said \"\"\"\"hi, man!\"\"\"\"\"\"\"");
+	free(p);
+}
+
+static void test_strbuf_escaped(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	const char said[] = "She said \"hi, man\"";
+
+	assert_int_equal(append_strbuf_quoted(&buf, said), sizeof(said) + 3);
+	assert_string_equal(get_strbuf_str(&buf),
+			    "\"She said \"\"hi, man\"\"\"");
+
+	reset_strbuf(&buf);
+	assert_int_equal(append_strbuf_quoted(&buf, "\""), 4);
+	assert_string_equal(get_strbuf_str(&buf), "\"\"\"\"");
+
+	reset_strbuf(&buf);
+	assert_int_equal(append_strbuf_quoted(&buf, "\"\""), 6);
+	assert_string_equal(get_strbuf_str(&buf), "\"\"\"\"\"\"");
+
+	reset_strbuf(&buf);
+	assert_int_equal(append_strbuf_quoted(&buf, "\"Hi\""), 8);
+	assert_string_equal(get_strbuf_str(&buf), "\"\"\"Hi\"\"\"");
+}
+
+#define SENTENCE "yields, preceded by itself, falsehood"
+static void test_print_strbuf(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	char sentence[] = SENTENCE;
+
+	assert_int_equal(print_strbuf(&buf, "\"%s\" %s.", sentence, sentence),
+			 2 * (sizeof(sentence) - 1) + 4);
+	assert_string_equal(get_strbuf_str(&buf),
+			    "\"" SENTENCE "\" " SENTENCE ".");
+	condlog(3, "%s", get_strbuf_str(&buf));
+
+	reset_strbuf(&buf);
+	assert_int_equal(print_strbuf(&buf, "0x%08x", 0xdeadbeef), 10);
+	assert_string_equal(get_strbuf_str(&buf), "0xdeadbeef");
+
+	reset_strbuf(&buf);
+	assert_int_equal(print_strbuf(&buf, "%d%% of %d is %0.2f",
+				      5, 100, 0.05), 17);
+	assert_string_equal(get_strbuf_str(&buf), "5% of 100 is 0.05");
+}
+
+static void test_truncate_strbuf(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	const char str[] = "hello my dear!\n";
+	size_t sz, sz1;
+
+	assert_int_equal(truncate_strbuf(&buf, 1), -EFAULT);
+	assert_int_equal(truncate_strbuf(&buf, 0), -EFAULT);
+
+	assert_int_equal(append_strbuf_str(&buf, str), sizeof(str) - 1);
+	assert_int_equal(get_strbuf_len(&buf), sizeof(str) - 1);
+	assert_string_equal(get_strbuf_str(&buf), str);
+
+	assert_int_equal(truncate_strbuf(&buf, sizeof(str)), -ERANGE);
+	assert_int_equal(get_strbuf_len(&buf), sizeof(str) - 1);
+	assert_string_equal(get_strbuf_str(&buf), str);
+
+	assert_int_equal(truncate_strbuf(&buf, sizeof(str) - 1), 0);
+	assert_int_equal(get_strbuf_len(&buf), sizeof(str) - 1);
+	assert_string_equal(get_strbuf_str(&buf), str);
+
+	assert_int_equal(truncate_strbuf(&buf, sizeof(str) - 2), 0);
+	assert_int_equal(get_strbuf_len(&buf), sizeof(str) - 2);
+	assert_string_not_equal(get_strbuf_str(&buf), str);
+	assert_memory_equal(get_strbuf_str(&buf), str, sizeof(str) - 2);
+
+	assert_int_equal(truncate_strbuf(&buf, 5), 0);
+	assert_int_equal(get_strbuf_len(&buf), 5);
+	assert_string_not_equal(get_strbuf_str(&buf), str);
+	assert_string_equal(get_strbuf_str(&buf), "hello");
+
+	reset_strbuf(&buf);
+	assert_int_equal(append_strbuf_str(&buf, str), sizeof(str) - 1);
+
+	sz = buf.size;
+	while (buf.size == sz)
+		assert_int_equal(append_strbuf_str(&buf, str), sizeof(str) - 1);
+
+	sz1  = buf.size;
+	assert_in_range(get_strbuf_len(&buf), sz + 1, SIZE_MAX);
+	assert_string_equal(get_strbuf_str(&buf) +
+			    get_strbuf_len(&buf) - (sizeof(str) - 1), str);
+	assert_int_equal(truncate_strbuf(&buf, get_strbuf_len(&buf) + 1),
+			 -ERANGE);
+	assert_int_equal(truncate_strbuf(&buf, get_strbuf_len(&buf)), 0);
+	assert_int_equal(truncate_strbuf(&buf, get_strbuf_len(&buf)
+					 - (sizeof(str) - 1)), 0);
+	assert_in_range(get_strbuf_len(&buf), 1, sz);
+	assert_string_equal(get_strbuf_str(&buf) +
+			    get_strbuf_len(&buf) - (sizeof(str) - 1), str);
+	assert_int_equal(buf.size, sz1);
+
+	assert_int_equal(truncate_strbuf(&buf, 5), 0);
+	assert_int_equal(get_strbuf_len(&buf), 5);
+	assert_string_equal(get_strbuf_str(&buf), "hello");
+	assert_int_equal(buf.size, sz1);
+
+	assert_int_equal(truncate_strbuf(&buf, 0), 0);
+	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_string_equal(get_strbuf_str(&buf), "");
+	assert_int_equal(buf.size, sz1);
+}
+
+static void test_fill_strbuf(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	int i;
+	char *p;
+
+	assert_int_equal(fill_strbuf(&buf, '+', -5), -EINVAL);
+
+	assert_int_equal(fill_strbuf(&buf, '+', 0), 0);
+	assert_int_equal(get_strbuf_len(&buf), 0);
+	assert_string_equal(get_strbuf_str(&buf), "");
+
+	assert_int_equal(fill_strbuf(&buf, '+', 1), 1);
+	assert_int_equal(get_strbuf_len(&buf), 1);
+	assert_string_equal(get_strbuf_str(&buf), "+");
+
+	assert_int_equal(fill_strbuf(&buf, '-', 3), 3);
+	assert_int_equal(get_strbuf_len(&buf), 4);
+	assert_string_equal(get_strbuf_str(&buf), "+---");
+
+	assert_int_equal(fill_strbuf(&buf, '\0', 3), 3);
+	assert_int_equal(get_strbuf_len(&buf), 7);
+	assert_string_equal(get_strbuf_str(&buf), "+---");
+
+	truncate_strbuf(&buf, 4);
+	assert_int_equal(fill_strbuf(&buf, '+', 4), 4);
+	assert_int_equal(get_strbuf_len(&buf), 8);
+	assert_string_equal(get_strbuf_str(&buf), "+---++++");
+
+	reset_strbuf(&buf);
+	assert_int_equal(fill_strbuf(&buf, 'x', 30000), 30000);
+	assert_int_equal(get_strbuf_len(&buf), 30000);
+	p = steal_strbuf_str(&buf);
+	assert_int_equal(strlen(p), 30000);
+	for (i = 0; i < 30000; i++)
+		assert_int_equal(p[i], 'x');
+	free(p);
+}
+
+static int test_strbuf(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_strbuf_00),
+		cmocka_unit_test(test_strbuf_alloc_err),
+		cmocka_unit_test(test_strbuf_overflow),
+		cmocka_unit_test(test_strbuf_big),
+		cmocka_unit_test(test_strbuf_nul),
+		cmocka_unit_test(test_strbuf_quoted),
+		cmocka_unit_test(test_strbuf_escaped),
+		cmocka_unit_test(test_print_strbuf),
+		cmocka_unit_test(test_truncate_strbuf),
+		cmocka_unit_test(test_fill_strbuf),
+	};
+
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
+int main(void)
+{
+	int ret = 0;
+
+	init_test_verbosity(-1);
+	ret += test_strbuf();
+	return ret;
+}
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

