Return-Path: <SRS0=1CEe=NC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA38C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:42:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B27560F46
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7B27560F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-G0USTyeKN7u6ZacJGIjT8w-1; Wed, 11 Aug 2021 11:42:29 -0400
X-MC-Unique: G0USTyeKN7u6ZacJGIjT8w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A11A2196632C;
	Wed, 11 Aug 2021 15:42:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 584025C1B4;
	Wed, 11 Aug 2021 15:42:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EDDE61819AC2;
	Wed, 11 Aug 2021 15:42:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17BFg9Kf010058 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Aug 2021 11:42:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AF67F10340A; Wed, 11 Aug 2021 15:42:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A6A6C103419
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:42:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1B6418A01B1
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:42:08 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-88-HQc1EU78N6ygbiRib2oVJA-1; Wed, 11 Aug 2021 11:42:05 -0400
X-MC-Unique: HQc1EU78N6ygbiRib2oVJA-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E4D8A20189;
	Wed, 11 Aug 2021 15:42:03 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id A925B13969;
	Wed, 11 Aug 2021 15:42:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap1.suse-dmz.suse.de with ESMTPSA id wOF3J8vvE2H/XQAAGKfGzw
	(envelope-from <mwilck@suse.com>); Wed, 11 Aug 2021 15:42:03 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 11 Aug 2021 17:41:45 +0200
Message-Id: <20210811154150.24714-5-mwilck@suse.com>
In-Reply-To: <20210811154150.24714-1-mwilck@suse.com>
References: <20210811154150.24714-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17BFg9Kf010058
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 4/9] libmultipath: use strbuf in dict.c
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Temporary solution for snprint_keyword(), as print.c hasn't been migrated yet.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c    | 314 ++++++++++++++++++-----------------------
 libmultipath/dict.h    |  19 +--
 libmultipath/parser.c  |  47 +++---
 libmultipath/parser.h  |  15 +-
 libmultipath/propsel.c | 147 +++++++++----------
 5 files changed, 254 insertions(+), 288 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index dd08abf..7a72738 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -26,6 +26,7 @@
 #include <mpath_persist.h>
 #include "mpath_cmd.h"
 #include "dict.h"
+#include "strbuf.h"
 
 static int
 set_int(vector strvec, void *ptr)
@@ -143,84 +144,45 @@ set_yes_no_undef(vector strvec, void *ptr)
 	return 0;
 }
 
-static int
-print_int (char *buff, int len, long v)
+static int print_int(struct strbuf *buff, long v)
 {
-	return snprintf(buff, len, "%li", v);
+	return print_strbuf(buff, "%li", v);
 }
 
-static int
-print_nonzero (char *buff, int len, long v)
+static int print_nonzero(struct strbuf *buff, long v)
 {
 	if (!v)
 		return 0;
-	return snprintf(buff, len, "%li", v);
+	return print_strbuf(buff, "%li", v);
 }
 
-static int
-print_str (char *buff, int len, const char *ptr)
+static int print_str(struct strbuf *buff, const char *ptr)
 {
-	char *p;
-	char *last;
-	const char *q;
+	int ret = append_strbuf_quoted(buff, ptr);
 
-	if (!ptr || len <= 0)
-		return 0;
-
-	q = strchr(ptr, '"');
-	if (q == NULL)
-		return snprintf(buff, len, "\"%s\"", ptr);
-
-	last = buff + len - 1;
-	p = buff;
-	if (p >= last)
-		goto out;
-	*p++ = '"';
-	if (p >= last)
-		goto out;
-	for (; q; q = strchr(ptr, '"')) {
-		if (q + 1 - ptr < last - p)
-			p = mempcpy(p, ptr, q + 1 - ptr);
-		else {
-			p = mempcpy(p, ptr, last - p);
-			goto out;
-		}
-		*p++ = '"';
-		if (p >= last)
-			goto out;
-		ptr = q + 1;
-	}
-	p += strlcpy(p, ptr, last - p);
-	if (p >= last)
-		goto out;
-	*p++ = '"';
-	*p = '\0';
-	return p - buff;
-out:
-	*p = '\0';
-	return len;
+	/*
+	 * -EINVAL aka (ptr == NULL) means "not set".
+	 * Returning an error here breaks unit tests
+	 * (logic in snprint_keyword()).
+	 */
+	return ret == -EINVAL ? 0 : ret;
 }
 
-static int
-print_ignored (char *buff, int len)
+static int print_ignored(struct strbuf *buff)
 {
-	return snprintf(buff, len, "ignored");
+	return append_strbuf_quoted(buff, "ignored");
 }
 
-static int
-print_yes_no (char *buff, int len, long v)
+static int print_yes_no(struct strbuf *buff, long v)
 {
-	return snprintf(buff, len, "\"%s\"",
-			(v == YN_NO)? "no" : "yes");
+	return append_strbuf_quoted(buff, v == YN_NO ? "no" : "yes");
 }
 
-static int
-print_yes_no_undef (char *buff, int len, long v)
+static int print_yes_no_undef(struct strbuf *buff, long v)
 {
 	if (!v)
 		return 0;
-	return snprintf(buff, len, "\"%s\"",
-			(v == YNU_NO)? "no" : "yes");
+	return append_strbuf_quoted(buff, v == YNU_NO? "no" : "yes");
 }
 
 #define declare_def_handler(option, function)				\
@@ -232,32 +194,32 @@ def_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_def_snprint(option, function)				\
 static int								\
-snprint_def_ ## option (struct config *conf, char * buff, int len,	\
-			const void * data)				\
+snprint_def_ ## option (struct config *conf, struct strbuf *buff,	\
+			const void *data)				\
 {									\
-	return function (buff, len, conf->option);			\
+	return function(buff, conf->option);				\
 }
 
 #define declare_def_snprint_defint(option, function, value)		\
 static int								\
-snprint_def_ ## option (struct config *conf, char * buff, int len,	\
-			const void * data)				\
+snprint_def_ ## option (struct config *conf, struct strbuf *buff,	\
+			const void *data)				\
 {									\
 	int i = value;							\
 	if (!conf->option)						\
-		return function (buff, len, i);				\
-	return function (buff, len, conf->option);			\
+		return function(buff, i);				\
+	return function (buff, conf->option);				\
 }
 
 #define declare_def_snprint_defstr(option, function, value)		\
 static int								\
-snprint_def_ ## option (struct config *conf, char * buff, int len,	\
-			const void * data)				\
+snprint_def_ ## option (struct config *conf, struct strbuf *buff,	\
+			const void *data)				\
 {									\
 	static const char *s = value;					\
 	if (!conf->option)						\
-		return function (buff, len, s);				\
-	return function (buff, len, conf->option);			\
+		return function(buff, s);				\
+	return function(buff, conf->option);				\
 }
 
 #define declare_hw_handler(option, function)				\
@@ -272,11 +234,11 @@ hw_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_hw_snprint(option, function)				\
 static int								\
-snprint_hw_ ## option (struct config *conf, char * buff, int len,	\
-		       const void * data)				\
+snprint_hw_ ## option (struct config *conf, struct strbuf *buff,	\
+		       const void *data)				\
 {									\
 	const struct hwentry * hwe = (const struct hwentry *)data;	\
-	return function (buff, len, hwe->option);			\
+	return function(buff, hwe->option);				\
 }
 
 #define declare_ovr_handler(option, function)				\
@@ -290,10 +252,10 @@ ovr_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_ovr_snprint(option, function)				\
 static int								\
-snprint_ovr_ ## option (struct config *conf, char * buff, int len,	\
-			const void * data)				\
+snprint_ovr_ ## option (struct config *conf, struct strbuf *buff,	\
+			const void *data)				\
 {									\
-	return function (buff, len, conf->overrides->option);		\
+	return function (buff, conf->overrides->option);		\
 }
 
 #define declare_mp_handler(option, function)				\
@@ -308,11 +270,11 @@ mp_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_mp_snprint(option, function)				\
 static int								\
-snprint_mp_ ## option (struct config *conf, char * buff, int len,	\
-		       const void * data)				\
+snprint_mp_ ## option (struct config *conf, struct strbuf *buff,	\
+		       const void *data)				\
 {									\
 	const struct mpentry * mpe = (const struct mpentry *)data;	\
-	return function (buff, len, mpe->option);			\
+	return function(buff, mpe->option);				\
 }
 
 static int checkint_handler(struct config *conf, vector strvec)
@@ -354,13 +316,13 @@ static int def_partition_delim_handler(struct config *conf, vector strvec)
 	return 0;
 }
 
-static int snprint_def_partition_delim(struct config *conf, char *buff,
-				       int len, const void *data)
+static int snprint_def_partition_delim(struct config *conf, struct strbuf *buff,
+				       const void *data)
 {
 	if (default_partition_delim == NULL || conf->partition_delim != NULL)
-		return print_str(buff, len, conf->partition_delim);
+		return print_str(buff, conf->partition_delim);
 	else
-		return print_str(buff, len, UNSET_PARTITION_DELIM);
+		return print_str(buff, UNSET_PARTITION_DELIM);
 }
 
 static const char * const find_multipaths_optvals[] = {
@@ -403,10 +365,10 @@ def_find_multipaths_handler(struct config *conf, vector strvec)
 }
 
 static int
-snprint_def_find_multipaths(struct config *conf, char *buff, int len,
+snprint_def_find_multipaths(struct config *conf, struct strbuf *buff,
 			    const void *data)
 {
-	return print_str(buff, len,
+	return append_strbuf_quoted(buff,
 			 find_multipaths_optvals[conf->find_multipaths]);
 }
 
@@ -419,21 +381,19 @@ declare_ovr_snprint(selector, print_str)
 declare_mp_handler(selector, set_str)
 declare_mp_snprint(selector, print_str)
 
-static int snprint_uid_attrs(struct config *conf, char *buff, int len,
+static int snprint_uid_attrs(struct config *conf, struct strbuf *buff,
 			     const void *dummy)
 {
-	char *p = buff;
-	int n, j;
+	int j, ret, total = 0;
 	const char *att;
 
 	vector_foreach_slot(&conf->uid_attrs, att, j) {
-		n = snprintf(p, len, "%s%s", j == 0 ? "" : " ", att);
-		if (n >= len)
-			return (p - buff) + n;
-		p += n;
-		len -= n;
+		ret = print_strbuf(buff, "%s%s", j == 0 ? "" : " ", att);
+		if (ret < 0)
+			return ret;
+		total += ret;
 	}
-	return p - buff;
+	return total;
 }
 
 static int uid_attrs_handler(struct config *conf, vector strvec)
@@ -526,18 +486,23 @@ declare_mp_snprint(minio_rq, print_nonzero)
 
 declare_def_handler(queue_without_daemon, set_yes_no)
 static int
-snprint_def_queue_without_daemon (struct config *conf,
-				  char * buff, int len, const void * data)
+snprint_def_queue_without_daemon(struct config *conf, struct strbuf *buff,
+				 const void * data)
 {
+	const char *qwd = "unknown";
+
 	switch (conf->queue_without_daemon) {
 	case QUE_NO_DAEMON_OFF:
-		return snprintf(buff, len, "\"no\"");
+		qwd = "no";
+		break;
 	case QUE_NO_DAEMON_ON:
-		return snprintf(buff, len, "\"yes\"");
+		qwd = "yes";
+		break;
 	case QUE_NO_DAEMON_FORCE:
-		return snprintf(buff, len, "\"forced\"");
+		qwd = "forced";
+		break;
 	}
-	return 0;
+	return append_strbuf_quoted(buff, qwd);
 }
 
 declare_def_handler(checker_timeout, set_int)
@@ -636,10 +601,11 @@ static int def_disable_changed_wwids_handler(struct config *conf, vector strvec)
 {
 	return 0;
 }
-static int snprint_def_disable_changed_wwids(struct config *conf, char *buff,
-					     int len, const void *data)
+static int snprint_def_disable_changed_wwids(struct config *conf,
+					     struct strbuf *buff,
+					     const void *data)
 {
-	return print_ignored(buff, len);
+	return print_ignored(buff);
 }
 
 declare_def_handler(remove_retries, set_int)
@@ -681,11 +647,10 @@ def_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_def_attr_snprint(option, function)			\
 static int								\
-snprint_def_ ## option (struct config *conf, char * buff, int len,	\
-			const void * data)				\
+snprint_def_ ## option (struct config *conf, struct strbuf *buff,	\
+			const void *data)				\
 {									\
-	return function (buff, len, conf->option,			\
-			 conf->attribute_flags);			\
+	return function(buff, conf->option, conf->attribute_flags);	\
 }
 
 #define declare_mp_attr_handler(option, function)			\
@@ -700,12 +665,11 @@ mp_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_mp_attr_snprint(option, function)			\
 static int								\
-snprint_mp_ ## option (struct config *conf, char * buff, int len,	\
+snprint_mp_ ## option (struct config *conf, struct strbuf *buff,	\
 		       const void * data)				\
 {									\
 	const struct mpentry * mpe = (const struct mpentry *)data;	\
-	return function (buff, len, mpe->option,			\
-			 mpe->attribute_flags);				\
+	return function(buff, mpe->option, mpe->attribute_flags);	\
 }
 
 static int
@@ -780,30 +744,30 @@ set_gid(vector strvec, void *ptr, int *flags)
 }
 
 static int
-print_mode(char * buff, int len, long v, int flags)
+print_mode(struct strbuf *buff, long v, int flags)
 {
 	mode_t mode = (mode_t)v;
 	if ((flags & (1 << ATTR_MODE)) == 0)
 		return 0;
-	return snprintf(buff, len, "0%o", mode);
+	return print_strbuf(buff, "0%o", mode);
 }
 
 static int
-print_uid(char * buff, int len, long v, int flags)
+print_uid(struct strbuf *buff, long v, int flags)
 {
 	uid_t uid = (uid_t)v;
 	if ((flags & (1 << ATTR_UID)) == 0)
 		return 0;
-	return snprintf(buff, len, "0%o", uid);
+	return print_strbuf(buff, "0%o", uid);
 }
 
 static int
-print_gid(char * buff, int len, long v, int flags)
+print_gid(struct strbuf *buff, long v, int flags)
 {
 	gid_t gid = (gid_t)v;
 	if ((flags & (1 << ATTR_GID)) == 0)
 		return 0;
-	return snprintf(buff, len, "0%o", gid);
+	return print_strbuf(buff, "0%o", gid);
 }
 
 declare_def_attr_handler(mode, set_mode)
@@ -843,16 +807,15 @@ set_undef_off_zero(vector strvec, void *ptr)
 	return 0;
 }
 
-int
-print_undef_off_zero(char * buff, int len, long v)
+int print_undef_off_zero(struct strbuf *buff, long v)
 {
 	if (v == UOZ_UNDEF)
 		return 0;
 	if (v == UOZ_OFF)
-		return snprintf(buff, len, "\"off\"");
+		return append_strbuf_str(buff, "off");
 	if (v == UOZ_ZERO)
-		return snprintf(buff, len, "0");
-	return snprintf(buff, len, "%ld", v);
+		return append_strbuf_str(buff, "0");
+	return print_int(buff, v);
 }
 
 declare_def_handler(fast_io_fail, set_undef_off_zero)
@@ -883,13 +846,13 @@ set_dev_loss(vector strvec, void *ptr)
 }
 
 int
-print_dev_loss(char * buff, int len, unsigned long v)
+print_dev_loss(struct strbuf *buff, unsigned long v)
 {
 	if (v == DEV_LOSS_TMO_UNSET)
 		return 0;
 	if (v >= MAX_DEV_LOSS_TMO)
-		return snprintf(buff, len, "\"infinity\"");
-	return snprintf(buff, len, "%lu", v);
+		return append_strbuf_quoted(buff, "infinity");
+	return print_strbuf(buff, "%lu", v);
 }
 
 declare_def_handler(dev_loss, set_dev_loss)
@@ -923,7 +886,7 @@ set_pgpolicy(vector strvec, void *ptr)
 }
 
 int
-print_pgpolicy(char * buff, int len, long pgpolicy)
+print_pgpolicy(struct strbuf *buff, long pgpolicy)
 {
 	char str[POLICY_NAME_SIZE];
 
@@ -932,7 +895,7 @@ print_pgpolicy(char * buff, int len, long pgpolicy)
 
 	get_pgpolicy_name(str, POLICY_NAME_SIZE, pgpolicy);
 
-	return snprintf(buff, len, "\"%s\"", str);
+	return append_strbuf_quoted(buff, str);
 }
 
 declare_def_handler(pgpolicy, set_pgpolicy)
@@ -1003,7 +966,7 @@ max_fds_handler(struct config *conf, vector strvec)
 }
 
 static int
-snprint_max_fds (struct config *conf, char * buff, int len, const void * data)
+snprint_max_fds (struct config *conf, struct strbuf *buff, const void *data)
 {
 	int r = 0, max_fds;
 
@@ -1012,9 +975,9 @@ snprint_max_fds (struct config *conf, char * buff, int len, const void * data)
 
 	r = get_sys_max_fds(&max_fds);
 	if (!r && conf->max_fds >= max_fds)
-		return snprintf(buff, len, "\"max\"");
+		return append_strbuf_quoted(buff, "max");
 	else
-		return snprintf(buff, len, "%d", conf->max_fds);
+		return print_int(buff, conf->max_fds);
 }
 
 static int
@@ -1040,14 +1003,14 @@ set_rr_weight(vector strvec, void *ptr)
 }
 
 int
-print_rr_weight (char * buff, int len, long v)
+print_rr_weight (struct strbuf *buff, long v)
 {
 	if (!v)
 		return 0;
 	if (v == RR_WEIGHT_PRIO)
-		return snprintf(buff, len, "\"priorities\"");
+		return append_strbuf_quoted(buff, "priorities");
 	if (v == RR_WEIGHT_NONE)
-		return snprintf(buff, len, "\"uniform\"");
+		return append_strbuf_quoted(buff, "uniform");
 
 	return 0;
 }
@@ -1086,19 +1049,19 @@ set_pgfailback(vector strvec, void *ptr)
 }
 
 int
-print_pgfailback (char * buff, int len, long v)
+print_pgfailback (struct strbuf *buff, long v)
 {
 	switch(v) {
 	case  FAILBACK_UNDEF:
 		return 0;
 	case -FAILBACK_MANUAL:
-		return snprintf(buff, len, "\"manual\"");
+		return append_strbuf_quoted(buff, "manual");
 	case -FAILBACK_IMMEDIATE:
-		return snprintf(buff, len, "\"immediate\"");
+		return append_strbuf_quoted(buff, "immediate");
 	case -FAILBACK_FOLLOWOVER:
-		return snprintf(buff, len, "\"followover\"");
+		return append_strbuf_quoted(buff, "followover");
 	default:
-		return snprintf(buff, len, "%li", v);
+		return print_int(buff, v);
 	}
 }
 
@@ -1133,17 +1096,17 @@ no_path_retry_helper(vector strvec, void *ptr)
 }
 
 int
-print_no_path_retry(char * buff, int len, long v)
+print_no_path_retry(struct strbuf *buff, long v)
 {
 	switch(v) {
 	case NO_PATH_RETRY_UNDEF:
 		return 0;
 	case NO_PATH_RETRY_FAIL:
-		return snprintf(buff, len, "\"fail\"");
+		return append_strbuf_quoted(buff, "fail");
 	case NO_PATH_RETRY_QUEUE:
-		return snprintf(buff, len, "\"queue\"");
+		return append_strbuf_quoted(buff, "queue");
 	default:
-		return snprintf(buff, len, "%li", v);
+		return print_int(buff, v);
 	}
 }
 
@@ -1176,12 +1139,12 @@ def_log_checker_err_handler(struct config *conf, vector strvec)
 }
 
 static int
-snprint_def_log_checker_err (struct config *conf, char * buff, int len,
-			     const void * data)
+snprint_def_log_checker_err(struct config *conf, struct strbuf *buff,
+			    const void * data)
 {
 	if (conf->log_checker_err == LOG_CHKR_ERR_ONCE)
-		return snprintf(buff, len, "once");
-	return snprintf(buff, len, "always");
+		return append_strbuf_quoted(buff, "once");
+	return append_strbuf_quoted(buff, "always");
 }
 
 static int
@@ -1216,18 +1179,17 @@ set_reservation_key(vector strvec, struct be64 *be64_ptr, uint8_t *flags_ptr,
 }
 
 int
-print_reservation_key(char * buff, int len, struct be64 key, uint8_t flags,
-		      int source)
+print_reservation_key(struct strbuf *buff,
+		      struct be64 key, uint8_t flags, int source)
 {
 	char *flagstr = "";
 	if (source == PRKEY_SOURCE_NONE)
 		return 0;
 	if (source == PRKEY_SOURCE_FILE)
-		return snprintf(buff, len, "file");
+		return append_strbuf_quoted(buff, "file");
 	if (flags & MPATH_F_APTPL_MASK)
 		flagstr = ":aptpl";
-	return snprintf(buff, len, "0x%" PRIx64 "%s", get_be64(key),
-			flagstr);
+	return print_strbuf(buff, "0x%" PRIx64 "%s", get_be64(key), flagstr);
 }
 
 static int
@@ -1239,12 +1201,11 @@ def_reservation_key_handler(struct config *conf, vector strvec)
 }
 
 static int
-snprint_def_reservation_key (struct config *conf, char * buff, int len,
+snprint_def_reservation_key (struct config *conf, struct strbuf *buff,
 			     const void * data)
 {
-	return print_reservation_key(buff, len, conf->reservation_key,
-				     conf->sa_flags,
-				     conf->prkey_source);
+	return print_reservation_key(buff, conf->reservation_key,
+				     conf->sa_flags, conf->prkey_source);
 }
 
 static int
@@ -1259,13 +1220,12 @@ mp_reservation_key_handler(struct config *conf, vector strvec)
 }
 
 static int
-snprint_mp_reservation_key (struct config *conf, char * buff, int len,
-			    const void * data)
+snprint_mp_reservation_key (struct config *conf, struct strbuf *buff,
+			    const void *data)
 {
 	const struct mpentry * mpe = (const struct mpentry *)data;
-	return print_reservation_key(buff, len, mpe->reservation_key,
-				     mpe->sa_flags,
-				     mpe->prkey_source);
+	return print_reservation_key(buff, mpe->reservation_key,
+				     mpe->sa_flags, mpe->prkey_source);
 }
 
 static int
@@ -1288,15 +1248,15 @@ set_off_int_undef(vector strvec, void *ptr)
 }
 
 int
-print_off_int_undef(char * buff, int len, long v)
+print_off_int_undef(struct strbuf *buff, long v)
 {
 	switch(v) {
 	case NU_UNDEF:
 		return 0;
 	case NU_NO:
-		return snprintf(buff, len, "\"no\"");
+		return append_strbuf_quoted(buff, "no");
 	default:
-		return snprintf(buff, len, "%li", v);
+		return print_int(buff, v);
 	}
 }
 
@@ -1455,13 +1415,13 @@ out:
 }
 
 static int
-snprint_hw_vpd_vendor(struct config *conf, char * buff, int len,
+snprint_hw_vpd_vendor(struct config *conf, struct strbuf *buff,
 		      const void * data)
 {
 	const struct hwentry * hwe = (const struct hwentry *)data;
 
 	if (hwe->vpd_vendor_id > 0 && hwe->vpd_vendor_id < VPD_VP_ARRAY_SIZE)
-		return snprintf(buff, len, "%s",
+		return append_strbuf_quoted(buff,
 				vpd_vendor_pages[hwe->vpd_vendor_id].name);
 	return 0;
 }
@@ -1561,19 +1521,18 @@ declare_ble_handler(blist_protocol)
 declare_ble_handler(elist_protocol)
 
 static int
-snprint_def_uxsock_timeout(struct config *conf, char * buff, int len,
-			   const void * data)
+snprint_def_uxsock_timeout(struct config *conf, struct strbuf *buff,
+			   const void *data)
 {
-	return snprintf(buff, len, "%u", conf->uxsock_timeout);
+	return print_strbuf(buff, "%u", conf->uxsock_timeout);
 }
 
 static int
-snprint_ble_simple (struct config *conf, char * buff, int len,
-		    const void * data)
+snprint_ble_simple (struct config *conf, struct strbuf *buff, const void *data)
 {
-	const struct blentry * ble = (const struct blentry *)data;
+	const struct blentry *ble = (const struct blentry *)data;
 
-	return snprintf(buff, len, "\"%s\"", ble->str);
+	return print_str(buff, ble->str);
 }
 
 static int
@@ -1593,24 +1552,22 @@ declare_ble_device_handler(vendor, elist_device, buff, NULL)
 declare_ble_device_handler(product, blist_device, NULL, buff)
 declare_ble_device_handler(product, elist_device, NULL, buff)
 
-static int
-snprint_bled_vendor (struct config *conf, char * buff, int len,
-		     const void * data)
+static int snprint_bled_vendor(struct config *conf, struct strbuf *buff,
+			       const void * data)
 {
 	const struct blentry_device * bled =
 		(const struct blentry_device *)data;
 
-	return snprintf(buff, len, "\"%s\"", bled->vendor);
+	return print_str(buff, bled->vendor);
 }
 
-static int
-snprint_bled_product (struct config *conf, char * buff, int len,
-		      const void * data)
+static int snprint_bled_product(struct config *conf, struct strbuf *buff,
+				const void *data)
 {
 	const struct blentry_device * bled =
 		(const struct blentry_device *)data;
 
-	return snprintf(buff, len, "\"%s\"", bled->product);
+	return print_str(buff, bled->product);
 }
 
 /*
@@ -1738,8 +1695,7 @@ deprecated_handler(struct config *conf, vector strvec)
 }
 
 static int
-snprint_deprecated (struct config *conf, char * buff, int len,
-		    const void * data)
+snprint_deprecated (struct config *conf, struct strbuf *buff, const void * data)
 {
 	return 0;
 }
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index a917e1c..d80f990 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -6,16 +6,17 @@
 #endif
 
 #include "byteorder.h"
+struct strbuf;
 
 void init_keywords(vector keywords);
 int get_sys_max_fds(int *);
-int print_rr_weight(char *buff, int len, long v);
-int print_pgfailback(char *buff, int len, long v);
-int print_pgpolicy(char *buff, int len, long v);
-int print_no_path_retry(char *buff, int len, long v);
-int print_undef_off_zero(char *buff, int len, long v);
-int print_dev_loss(char *buff, int len, unsigned long v);
-int print_reservation_key(char * buff, int len, struct be64 key, uint8_t
-			  flags, int source);
-int print_off_int_undef(char *buff, int len, long v);
+int print_rr_weight(struct strbuf *buff, long v);
+int print_pgfailback(struct strbuf *buff, long v);
+int print_pgpolicy(struct strbuf *buff, long v);
+int print_no_path_retry(struct strbuf *buff, long v);
+int print_undef_off_zero(struct strbuf *buff, long v);
+int print_dev_loss(struct strbuf *buff, unsigned long v);
+int print_reservation_key(struct strbuf *buff,
+			  struct be64 key, uint8_t flags, int source);
+int print_off_int_undef(struct strbuf *buff, long v);
 #endif /* _DICT_H */
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index c70243c..88c7b59 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -25,6 +25,7 @@
 #include "parser.h"
 #include "memory.h"
 #include "debug.h"
+#include "strbuf.h"
 
 /* local vars */
 static int sublevel = 0;
@@ -33,7 +34,7 @@ static int line_nr;
 int
 keyword_alloc(vector keywords, char *string,
 	      int (*handler) (struct config *, vector),
-	      int (*print) (struct config *, char *, int, const void*),
+	      print_fn *print,
 	      int unique)
 {
 	struct keyword *keyword;
@@ -72,7 +73,7 @@ install_sublevel_end(void)
 int
 _install_keyword(vector keywords, char *string,
 		 int (*handler) (struct config *, vector),
-		 int (*print) (struct config *, char *, int, const void*),
+		 print_fn *print,
 		 int unique)
 {
 	int i = 0;
@@ -153,42 +154,44 @@ snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
 		const void *data)
 {
 	int r;
-	int fwd = 0;
-	char *f = fmt;
+	char *f;
 	struct config *conf;
+	STRBUF_ON_STACK(sbuf);
 
 	if (!kw || !kw->print)
 		return 0;
 
 	do {
-		if (fwd == len || *f == '\0')
-			break;
-		if (*f != '%') {
-			*(buff + fwd) = *f;
-			fwd++;
-			continue;
+		f = strchr(fmt, '%');
+		if (f == NULL) {
+			r = append_strbuf_str(&sbuf, fmt);
+			goto out;
 		}
-		f++;
-		switch(*f) {
+		if (f != fmt &&
+		    (r = __append_strbuf_str(&sbuf, fmt, f - fmt)) < 0)
+			goto out;
+		fmt = f + 1;
+		switch(*fmt) {
 		case 'k':
-			fwd += snprintf(buff + fwd, len - fwd, "%s", kw->string);
+			if ((r = append_strbuf_str(&sbuf, kw->string)) < 0)
+				goto out;
 			break;
 		case 'v':
 			conf = get_multipath_config();
 			pthread_cleanup_push(put_multipath_config, conf);
-			r = kw->print(conf, buff + fwd, len - fwd, data);
+			r = kw->print(conf, &sbuf, data);
 			pthread_cleanup_pop(1);
-			if (!r) { /* no output if no value */
-				buff[0] = '\0';
-				return 0;
+			if (r < 0)
+				goto out;
+			else if (r == 0) {/* no output if no value */
+				reset_strbuf(&sbuf);
+				goto out;
 			}
-			fwd += r;
 			break;
 		}
-		if (fwd > len)
-			fwd = len;
-	} while (*f++);
-	return fwd;
+	} while (*fmt++);
+out:
+	return snprintf(buff, len, "%s", get_strbuf_str(&sbuf));
 }
 
 static const char quote_marker[] = { '\0', '"', '\0' };
diff --git a/libmultipath/parser.h b/libmultipath/parser.h
index 06666cc..e8b6eb2 100644
--- a/libmultipath/parser.h
+++ b/libmultipath/parser.h
@@ -34,16 +34,20 @@
 /* local includes */
 #include "vector.h"
 #include "config.h"
+struct strbuf;
 
 /* Global definitions */
 #define EOB  "}"
 #define MAXBUF	1024
 
-/* ketword definition */
+
+/* keyword definition */
+typedef int print_fn(struct config *, struct strbuf *, const void *);
+
 struct keyword {
 	char *string;
 	int (*handler) (struct config *, vector);
-	int (*print) (struct config *, char *, int, const void *);
+	print_fn *print;
 	vector sub;
 	int unique;
 };
@@ -60,16 +64,15 @@ struct keyword {
 /* Prototypes */
 extern int keyword_alloc(vector keywords, char *string,
 			 int (*handler) (struct config *, vector),
-			 int (*print) (struct config *, char *, int,
-				       const void *),
+			 print_fn *print,
 			 int unique);
 #define install_keyword_root(str, h) keyword_alloc(keywords, str, h, NULL, 1)
 extern void install_sublevel(void);
 extern void install_sublevel_end(void);
+
 extern int _install_keyword(vector keywords, char *string,
 			    int (*handler) (struct config *, vector),
-			    int (*print) (struct config *, char *, int,
-					  const void *),
+			    print_fn *print,
 			    int unique);
 #define install_keyword(str, vec, pri) _install_keyword(keywords, str, vec, pri, 1)
 #define install_keyword_multi(str, vec, pri) _install_keyword(keywords, str, vec, pri, 0)
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index b7b3379..b287667 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -24,6 +24,7 @@
 #include "prioritizers/alua_rtpg.h"
 #include "prkey.h"
 #include "propsel.h"
+#include "strbuf.h"
 #include <inttypes.h>
 #include <libudev.h>
 
@@ -191,7 +192,7 @@ out:
 int select_rr_weight(struct config *conf, struct multipath * mp)
 {
 	const char *origin;
-	char buff[13];
+	STRBUF_ON_STACK(buff);
 
 	mp_set_mpe(rr_weight);
 	mp_set_ovr(rr_weight);
@@ -199,15 +200,16 @@ int select_rr_weight(struct config *conf, struct multipath * mp)
 	mp_set_conf(rr_weight);
 	mp_set_default(rr_weight, DEFAULT_RR_WEIGHT);
 out:
-	print_rr_weight(buff, 13, mp->rr_weight);
-	condlog(3, "%s: rr_weight = %s %s", mp->alias, buff, origin);
+	print_rr_weight(&buff, mp->rr_weight);
+	condlog(3, "%s: rr_weight = %s %s", mp->alias,
+		get_strbuf_str(&buff), origin);
 	return 0;
 }
 
 int select_pgfailback(struct config *conf, struct multipath * mp)
 {
 	const char *origin;
-	char buff[13];
+	STRBUF_ON_STACK(buff);
 
 	mp_set_mpe(pgfailback);
 	mp_set_ovr(pgfailback);
@@ -215,8 +217,9 @@ int select_pgfailback(struct config *conf, struct multipath * mp)
 	mp_set_conf(pgfailback);
 	mp_set_default(pgfailback, DEFAULT_FAILBACK);
 out:
-	print_pgfailback(buff, 13, mp->pgfailback);
-	condlog(3, "%s: failback = %s %s", mp->alias, buff, origin);
+	print_pgfailback(&buff, mp->pgfailback);
+	condlog(3, "%s: failback = %s %s", mp->alias,
+		get_strbuf_str(&buff), origin);
 	return 0;
 }
 
@@ -339,7 +342,7 @@ void reconcile_features_with_options(const char *id, char **features, int* no_pa
 {
 	static const char q_i_n_p[] = "queue_if_no_path";
 	static const char r_a_h_h[] = "retain_attached_hw_handler";
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	if (*features == NULL)
 		return;
@@ -360,17 +363,15 @@ void reconcile_features_with_options(const char *id, char **features, int* no_pa
 			id, q_i_n_p);
 		if (*no_path_retry == NO_PATH_RETRY_UNDEF) {
 			*no_path_retry = NO_PATH_RETRY_QUEUE;
-			print_no_path_retry(buff, sizeof(buff),
-					    *no_path_retry);
+			print_no_path_retry(&buff, *no_path_retry);
 			condlog(3, "%s: no_path_retry = %s (inherited setting from feature '%s')",
-				id, buff, q_i_n_p);
+				id, get_strbuf_str(&buff), q_i_n_p);
 		};
 		/* Warn only if features string is overridden */
 		if (*no_path_retry != NO_PATH_RETRY_QUEUE) {
-			print_no_path_retry(buff, sizeof(buff),
-					    *no_path_retry);
+			print_no_path_retry(&buff, *no_path_retry);
 			condlog(2, "%s: ignoring feature '%s' because no_path_retry is set to '%s'",
-				id, q_i_n_p, buff);
+				id, q_i_n_p, get_strbuf_str(&buff));
 		}
 		remove_feature(features, q_i_n_p);
 	}
@@ -704,7 +705,7 @@ out:
 int select_no_path_retry(struct config *conf, struct multipath *mp)
 {
 	const char *origin = NULL;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	if (mp->disable_queueing) {
 		condlog(0, "%s: queueing disabled", mp->alias);
@@ -716,10 +717,10 @@ int select_no_path_retry(struct config *conf, struct multipath *mp)
 	mp_set_hwe(no_path_retry);
 	mp_set_conf(no_path_retry);
 out:
-	print_no_path_retry(buff, 12, mp->no_path_retry);
+	print_no_path_retry(&buff, mp->no_path_retry);
 	if (origin)
-		condlog(3, "%s: no_path_retry = %s %s", mp->alias, buff,
-			origin);
+		condlog(3, "%s: no_path_retry = %s %s", mp->alias,
+			get_strbuf_str(&buff), origin);
 	else
 		condlog(3, "%s: no_path_retry = undef %s",
 			mp->alias, default_origin);
@@ -770,22 +771,23 @@ int select_minio(struct config *conf, struct multipath *mp)
 int select_fast_io_fail(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	mp_set_ovr(fast_io_fail);
 	mp_set_hwe(fast_io_fail);
 	mp_set_conf(fast_io_fail);
 	mp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
 out:
-	print_undef_off_zero(buff, 12, mp->fast_io_fail);
-	condlog(3, "%s: fast_io_fail_tmo = %s %s", mp->alias, buff, origin);
+	print_undef_off_zero(&buff, mp->fast_io_fail);
+	condlog(3, "%s: fast_io_fail_tmo = %s %s", mp->alias,
+		get_strbuf_str(&buff), origin);
 	return 0;
 }
 
 int select_dev_loss(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	mp_set_ovr(dev_loss);
 	mp_set_hwe(dev_loss);
@@ -793,15 +795,16 @@ int select_dev_loss(struct config *conf, struct multipath *mp)
 	mp->dev_loss = DEV_LOSS_TMO_UNSET;
 	return 0;
 out:
-	print_dev_loss(buff, 12, mp->dev_loss);
-	condlog(3, "%s: dev_loss_tmo = %s %s", mp->alias, buff, origin);
+	print_dev_loss(&buff, mp->dev_loss);
+	condlog(3, "%s: dev_loss_tmo = %s %s", mp->alias,
+		get_strbuf_str(&buff), origin);
 	return 0;
 }
 
 int select_eh_deadline(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	mp_set_ovr(eh_deadline);
 	mp_set_hwe(eh_deadline);
@@ -810,8 +813,9 @@ int select_eh_deadline(struct config *conf, struct multipath *mp)
 	/* not changing sysfs in default cause, so don't print anything */
 	return 0;
 out:
-	print_undef_off_zero(buff, 12, mp->eh_deadline);
-	condlog(3, "%s: eh_deadline = %s %s", mp->alias, buff, origin);
+	print_undef_off_zero(&buff, mp->eh_deadline);
+	condlog(3, "%s: eh_deadline = %s %s", mp->alias,
+		get_strbuf_str(&buff), origin);
 	return 0;
 }
 
@@ -833,7 +837,7 @@ out:
 int select_reservation_key(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	char buff[PRKEY_SIZE];
+	STRBUF_ON_STACK(buff);
 	char *from_file = "";
 	uint64_t prkey = 0;
 
@@ -851,10 +855,10 @@ out:
 		else
 			put_be64(mp->reservation_key, prkey);
 	}
-	print_reservation_key(buff, PRKEY_SIZE, mp->reservation_key,
+	print_reservation_key(&buff, mp->reservation_key,
 			      mp->sa_flags, mp->prkey_source);
-	condlog(3, "%s: reservation_key = %s %s%s", mp->alias, buff, origin,
-		from_file);
+	condlog(3, "%s: reservation_key = %s %s%s", mp->alias,
+		get_strbuf_str(&buff), origin, from_file);
 	return 0;
 }
 
@@ -951,16 +955,16 @@ use_delay_watch_checks(struct config *conf, struct multipath *mp)
 {
 	int value = NU_UNDEF;
 	const char *origin = default_origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	do_set(delay_watch_checks, mp->mpe, value, multipaths_origin);
 	do_set(delay_watch_checks, conf->overrides, value, overrides_origin);
 	do_set_from_hwe(delay_watch_checks, mp, value, hwe_origin);
 	do_set(delay_watch_checks, conf, value, conf_origin);
 out:
-	if (print_off_int_undef(buff, 12, value) != 0)
-		condlog(3, "%s: delay_watch_checks = %s %s", mp->alias, buff,
-			origin);
+	if (print_off_int_undef(&buff, value) > 0)
+		condlog(3, "%s: delay_watch_checks = %s %s", mp->alias,
+			get_strbuf_str(&buff), origin);
 	return value;
 }
 
@@ -969,23 +973,23 @@ use_delay_wait_checks(struct config *conf, struct multipath *mp)
 {
 	int value = NU_UNDEF;
 	const char *origin = default_origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	do_set(delay_wait_checks, mp->mpe, value, multipaths_origin);
 	do_set(delay_wait_checks, conf->overrides, value, overrides_origin);
 	do_set_from_hwe(delay_wait_checks, mp, value, hwe_origin);
 	do_set(delay_wait_checks, conf, value, conf_origin);
 out:
-	if (print_off_int_undef(buff, 12, value) != 0)
-		condlog(3, "%s: delay_wait_checks = %s %s", mp->alias, buff,
-			origin);
+	if (print_off_int_undef(&buff, value) > 0)
+		condlog(3, "%s: delay_wait_checks = %s %s", mp->alias,
+			get_strbuf_str(&buff), origin);
 	return value;
 }
 
 int select_delay_checks(struct config *conf, struct multipath *mp)
 {
 	int watch_checks, wait_checks;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	watch_checks = use_delay_watch_checks(conf, mp);
 	wait_checks = use_delay_wait_checks(conf, mp);
@@ -1001,16 +1005,17 @@ int select_delay_checks(struct config *conf, struct multipath *mp)
 		(watch_checks > 0)? delay_watch_origin : delay_wait_origin);
 	if (watch_checks > 0) {
 		mp->san_path_err_forget_rate = watch_checks;
-		print_off_int_undef(buff, 12, mp->san_path_err_forget_rate);
+		print_off_int_undef(&buff, mp->san_path_err_forget_rate);
 		condlog(3, "%s: san_path_err_forget_rate = %s %s", mp->alias,
-			buff, delay_watch_origin);
+			get_strbuf_str(&buff), delay_watch_origin);
+		reset_strbuf(&buff);
 	}
 	if (wait_checks > 0) {
 		mp->san_path_err_recovery_time = wait_checks *
 						 conf->max_checkint;
-		print_off_int_undef(buff, 12, mp->san_path_err_recovery_time);
+		print_off_int_undef(&buff, mp->san_path_err_recovery_time);
 		condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias,
-			buff, delay_wait_origin);
+			get_strbuf_str(&buff), delay_wait_origin);
 	}
 	return 0;
 }
@@ -1029,7 +1034,7 @@ static int san_path_deprecated_warned;
 int select_san_path_err_threshold(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	if (marginal_path_check_enabled(mp)) {
 		mp->san_path_err_threshold = NU_NO;
@@ -1042,9 +1047,9 @@ int select_san_path_err_threshold(struct config *conf, struct multipath *mp)
 	mp_set_conf(san_path_err_threshold);
 	mp_set_default(san_path_err_threshold, DEFAULT_ERR_CHECKS);
 out:
-	if (print_off_int_undef(buff, 12, mp->san_path_err_threshold) != 0)
+	if (print_off_int_undef(&buff, mp->san_path_err_threshold) > 0)
 		condlog(3, "%s: san_path_err_threshold = %s %s",
-			mp->alias, buff, origin);
+			mp->alias, get_strbuf_str(&buff), origin);
 	warn_san_path_deprecated(mp, san_path_err_threshold);
 	return 0;
 }
@@ -1052,7 +1057,7 @@ out:
 int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	if (marginal_path_check_enabled(mp)) {
 		mp->san_path_err_forget_rate = NU_NO;
@@ -1065,9 +1070,9 @@ int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp)
 	mp_set_conf(san_path_err_forget_rate);
 	mp_set_default(san_path_err_forget_rate, DEFAULT_ERR_CHECKS);
 out:
-	if (print_off_int_undef(buff, 12, mp->san_path_err_forget_rate) != 0)
-		condlog(3, "%s: san_path_err_forget_rate = %s %s", mp->alias,
-			buff, origin);
+	if (print_off_int_undef(&buff, mp->san_path_err_forget_rate) > 0)
+		condlog(3, "%s: san_path_err_forget_rate = %s %s",
+			mp->alias, get_strbuf_str(&buff), origin);
 	warn_san_path_deprecated(mp, san_path_err_forget_rate);
 	return 0;
 
@@ -1076,7 +1081,7 @@ out:
 int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	if (marginal_path_check_enabled(mp)) {
 		mp->san_path_err_recovery_time = NU_NO;
@@ -1089,9 +1094,9 @@ int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
 	mp_set_conf(san_path_err_recovery_time);
 	mp_set_default(san_path_err_recovery_time, DEFAULT_ERR_CHECKS);
 out:
-	if (print_off_int_undef(buff, 12, mp->san_path_err_recovery_time) != 0)
+	if (print_off_int_undef(&buff, mp->san_path_err_recovery_time) != 0)
 		condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias,
-			buff, origin);
+			get_strbuf_str(&buff), origin);
 	warn_san_path_deprecated(mp, san_path_err_recovery_time);
 	return 0;
 
@@ -1100,7 +1105,7 @@ out:
 int select_marginal_path_err_sample_time(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	mp_set_mpe(marginal_path_err_sample_time);
 	mp_set_ovr(marginal_path_err_sample_time);
@@ -1114,17 +1119,16 @@ out:
 			mp->alias, 2 * IOTIMEOUT_SEC);
 			mp->marginal_path_err_sample_time = 2 * IOTIMEOUT_SEC;
 	}
-	if (print_off_int_undef(buff, 12, mp->marginal_path_err_sample_time)
-	    != 0)
+	if (print_off_int_undef(&buff, mp->marginal_path_err_sample_time) > 0)
 		condlog(3, "%s: marginal_path_err_sample_time = %s %s",
-			mp->alias, buff, origin);
+			mp->alias, get_strbuf_str(&buff), origin);
 	return 0;
 }
 
 int select_marginal_path_err_rate_threshold(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	mp_set_mpe(marginal_path_err_rate_threshold);
 	mp_set_ovr(marginal_path_err_rate_threshold);
@@ -1132,17 +1136,16 @@ int select_marginal_path_err_rate_threshold(struct config *conf, struct multipat
 	mp_set_conf(marginal_path_err_rate_threshold);
 	mp_set_default(marginal_path_err_rate_threshold, DEFAULT_ERR_CHECKS);
 out:
-	if (print_off_int_undef(buff, 12, mp->marginal_path_err_rate_threshold)
-	    != 0)
+	if (print_off_int_undef(&buff, mp->marginal_path_err_rate_threshold) > 0)
 		condlog(3, "%s: marginal_path_err_rate_threshold = %s %s",
-			mp->alias, buff, origin);
+			mp->alias, get_strbuf_str(&buff), origin);
 	return 0;
 }
 
 int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	mp_set_mpe(marginal_path_err_recheck_gap_time);
 	mp_set_ovr(marginal_path_err_recheck_gap_time);
@@ -1150,17 +1153,17 @@ int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multip
 	mp_set_conf(marginal_path_err_recheck_gap_time);
 	mp_set_default(marginal_path_err_recheck_gap_time, DEFAULT_ERR_CHECKS);
 out:
-	if (print_off_int_undef(buff, 12,
-				mp->marginal_path_err_recheck_gap_time) != 0)
+	if (print_off_int_undef(&buff,
+				mp->marginal_path_err_recheck_gap_time) > 0)
 		condlog(3, "%s: marginal_path_err_recheck_gap_time = %s %s",
-			mp->alias, buff, origin);
+			mp->alias, get_strbuf_str(&buff), origin);
 	return 0;
 }
 
 int select_marginal_path_double_failed_time(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	mp_set_mpe(marginal_path_double_failed_time);
 	mp_set_ovr(marginal_path_double_failed_time);
@@ -1168,10 +1171,9 @@ int select_marginal_path_double_failed_time(struct config *conf, struct multipat
 	mp_set_conf(marginal_path_double_failed_time);
 	mp_set_default(marginal_path_double_failed_time, DEFAULT_ERR_CHECKS);
 out:
-	if (print_off_int_undef(buff, 12, mp->marginal_path_double_failed_time)
-	    != 0)
+	if (print_off_int_undef(&buff, mp->marginal_path_double_failed_time) > 0)
 		condlog(3, "%s: marginal_path_double_failed_time = %s %s",
-			mp->alias, buff, origin);
+			mp->alias, get_strbuf_str(&buff), origin);
 	return 0;
 }
 
@@ -1215,7 +1217,7 @@ out:
 int select_ghost_delay (struct config *conf, struct multipath * mp)
 {
 	const char *origin;
-	char buff[12];
+	STRBUF_ON_STACK(buff);
 
 	mp_set_mpe(ghost_delay);
 	mp_set_ovr(ghost_delay);
@@ -1223,8 +1225,9 @@ int select_ghost_delay (struct config *conf, struct multipath * mp)
 	mp_set_conf(ghost_delay);
 	mp_set_default(ghost_delay, DEFAULT_GHOST_DELAY);
 out:
-	if (print_off_int_undef(buff, 12, mp->ghost_delay) != 0)
-		condlog(3, "%s: ghost_delay = %s %s", mp->alias, buff, origin);
+	if (print_off_int_undef(&buff, mp->ghost_delay) != 0)
+		condlog(3, "%s: ghost_delay = %s %s", mp->alias,
+			get_strbuf_str(&buff), origin);
 	return 0;
 }
 
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

