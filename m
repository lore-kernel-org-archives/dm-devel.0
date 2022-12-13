Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A211EC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 13 Dec 2022 23:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670974586;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YBBsydTQsElHmqOulJBLLiFEubpnJsvhm/Tib+stcpg=;
	b=ZaMzTxmRTHB6nlhDM51ABYQV5cPOPRXwrF0yQluWF8/aTWvon3PiQsw/CVPTonyIkv7LWc
	p41+iGaWxXG+kOyB6UtYD8KKL4uKH8i3L23bwnQ65R2i6LMMf//xmi08elMVsO9VX8RdN6
	Md5ezQgbh2lCxTkcWSGM2Y7fqOcVNeE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-hSRfcdmXM2Kq33iSSFEmzg-1; Tue, 13 Dec 2022 18:36:25 -0500
X-MC-Unique: hSRfcdmXM2Kq33iSSFEmzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0A15381494A;
	Tue, 13 Dec 2022 23:36:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DFAE82026D76;
	Tue, 13 Dec 2022 23:36:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1DBAC1946A6C;
	Tue, 13 Dec 2022 23:36:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8F4131946A46
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Dec 2022 23:36:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6622F4085720; Tue, 13 Dec 2022 23:36:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4817B4085722;
 Tue, 13 Dec 2022 23:36:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BDNaCVx008056;
 Tue, 13 Dec 2022 17:36:13 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BDNaC2O008055;
 Tue, 13 Dec 2022 17:36:12 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 13 Dec 2022 17:36:07 -0600
Message-Id: <1670974567-8005-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1670974567-8005-1-git-send-email-bmarzins@redhat.com>
References: <1670974567-8005-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 3/3] libmutipath: validate the argument count of
 config strings
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The features, path_selector, and hardware_handler config options pass
their strings directly into the kernel.  If users omit the argument
counts from these strings, or use the wrong value, the kernel's table
parsing gets completely messed up, and the error messages it prints
don't reflect what actully went wrong. To avoid messing up the
kernel table parsing, verify that these strings correctly set the
argument count to the number of arguments they have.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c | 110 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 101 insertions(+), 9 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index f4233882..6645de49 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -116,6 +116,58 @@ set_str(vector strvec, void *ptr, const char *file, int line_nr)
 	return 0;
 }
 
+static int
+set_arg_str(vector strvec, void *ptr, int count_idx, const char *file,
+	    int line_nr)
+{
+	char **str_ptr = (char **)ptr;
+	char *old_str = *str_ptr;
+	const char *spaces = " \f\n\r\t\v";
+	char *p, *end;
+	int idx = -1;
+	long int count = -1;
+
+	*str_ptr = set_value(strvec);
+	if (!*str_ptr) {
+		free(old_str);
+		return 1;
+	}
+	p = *str_ptr;
+	while (*p != '\0') {
+		p += strspn(p, spaces);
+		if (*p == '\0')
+			break;
+		idx += 1;
+		if (idx == count_idx) {
+			errno = 0;
+			count = strtol(p, &end, 10);
+			if (errno == ERANGE || end == p ||
+			    !(isspace(*end) || *end == '\0')) {
+				count = -1;
+				break;
+			}
+		}
+		p += strcspn(p, spaces);
+	}
+	if (count < 0) {
+		condlog(1, "%s line %d, missing argument count for %s",
+			file, line_nr, (char*)VECTOR_SLOT(strvec, 0));
+		goto fail;
+	}
+	if (count != idx - count_idx) {
+		condlog(1, "%s line %d, invalid argument count for %s:, got '%ld' expected '%d'",
+			file, line_nr, (char*)VECTOR_SLOT(strvec, 0), count,
+			idx - count_idx);
+		goto fail;
+	}
+	free(old_str);
+	return 0;
+fail:
+	free(*str_ptr);
+	*str_ptr = old_str;
+	return 0;
+}
+
 static int
 set_path(vector strvec, void *ptr, const char *file, int line_nr)
 {
@@ -288,6 +340,14 @@ def_ ## option ## _handler (struct config *conf, vector strvec,         \
 	return set_int(strvec, &conf->option, minval, maxval, file, line_nr); \
 }
 
+#define declare_def_arg_str_handler(option, count_idx)			\
+static int								\
+def_ ## option ## _handler (struct config *conf, vector strvec,		\
+			    const char *file, int line_nr)		\
+{									\
+	return set_arg_str(strvec, &conf->option, count_idx, file, line_nr); \
+}
+
 #define declare_def_snprint(option, function)				\
 static int								\
 snprint_def_ ## option (struct config *conf, struct strbuf *buff,	\
@@ -340,6 +400,17 @@ hw_ ## option ## _handler (struct config *conf, vector strvec,		\
 	return set_int(strvec, &hwe->option, minval, maxval, file, line_nr); \
 }
 
+#define declare_hw_arg_str_handler(option, count_idx)			\
+static int								\
+hw_ ## option ## _handler (struct config *conf, vector strvec,		\
+			    const char *file, int line_nr)		\
+{									\
+	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);		\
+	if (!hwe)							\
+		return 1;						\
+	return set_arg_str(strvec, &hwe->option, count_idx, file, line_nr); \
+}
+
 
 #define declare_hw_snprint(option, function)				\
 static int								\
@@ -371,6 +442,16 @@ ovr_ ## option ## _handler (struct config *conf, vector strvec,		\
 		       file, line_nr); \
 }
 
+#define declare_ovr_arg_str_handler(option, count_idx)			\
+static int								\
+ovr_ ## option ## _handler (struct config *conf, vector strvec,		\
+			    const char *file, int line_nr)		\
+{									\
+	if (!conf->overrides)						\
+		return 1;						\
+	return set_arg_str(strvec, &conf->overrides->option, count_idx, file, line_nr); \
+}
+
 #define declare_ovr_snprint(option, function)				\
 static int								\
 snprint_ovr_ ## option (struct config *conf, struct strbuf *buff,	\
@@ -401,6 +482,17 @@ mp_ ## option ## _handler (struct config *conf, vector strvec,		\
 	return set_int(strvec, &mpe->option, minval, maxval, file, line_nr); \
 }
 
+#define declare_mp_arg_str_handler(option, count_idx)			\
+static int								\
+mp_ ## option ## _handler (struct config *conf, vector strvec,		\
+			    const char *file, int line_nr)		\
+{									\
+	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);		\
+	if (!mpe)							\
+		return 1;						\
+	return set_arg_str(strvec, &mpe->option, count_idx, file, line_nr); \
+}
+
 #define declare_mp_snprint(option, function)				\
 static int								\
 snprint_mp_ ## option (struct config *conf, struct strbuf *buff,	\
@@ -584,13 +676,13 @@ snprint_def_marginal_pathgroups(struct config *conf, struct strbuf *buff,
 }
 
 
-declare_def_handler(selector, set_str)
+declare_def_arg_str_handler(selector, 1)
 declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
-declare_hw_handler(selector, set_str)
+declare_hw_arg_str_handler(selector, 1)
 declare_hw_snprint(selector, print_str)
-declare_ovr_handler(selector, set_str)
+declare_ovr_arg_str_handler(selector, 1)
 declare_ovr_snprint(selector, print_str)
-declare_mp_handler(selector, set_str)
+declare_mp_arg_str_handler(selector, 1)
 declare_mp_snprint(selector, print_str)
 
 static int snprint_uid_attrs(struct config *conf, struct strbuf *buff,
@@ -663,13 +755,13 @@ declare_hw_snprint(prio_args, print_str)
 declare_mp_handler(prio_args, set_str)
 declare_mp_snprint(prio_args, print_str)
 
-declare_def_handler(features, set_str)
+declare_def_arg_str_handler(features, 0)
 declare_def_snprint_defstr(features, print_str, DEFAULT_FEATURES)
-declare_ovr_handler(features, set_str)
+declare_ovr_arg_str_handler(features, 0)
 declare_ovr_snprint(features, print_str)
-declare_hw_handler(features, set_str)
+declare_hw_arg_str_handler(features, 0)
 declare_hw_snprint(features, print_str)
-declare_mp_handler(features, set_str)
+declare_mp_arg_str_handler(features, 0)
 declare_mp_snprint(features, print_str)
 
 declare_def_handler(checker_name, set_str)
@@ -1821,7 +1913,7 @@ declare_hw_snprint(revision, print_str)
 declare_hw_handler(bl_product, set_str)
 declare_hw_snprint(bl_product, print_str)
 
-declare_hw_handler(hwhandler, set_str)
+declare_hw_arg_str_handler(hwhandler, 0)
 declare_hw_snprint(hwhandler, print_str)
 
 /*
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

