Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38CE9C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:54:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E5C1960F9E
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:54:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E5C1960F9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636656882;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cxfS14L+YOC2fUzh+Xvg3ln28gWVr2upHGHYamg2RhY=;
	b=YrBg53hKxECkBxs2o16nkYs0c/H+5PufL3K1o8sVOJoAhFC6+c3hfSCQO86j9y/igIdtTU
	T7HMSnqctI9U+uSL4fMNCxmCzGUdAFz+TNM3SHjp5ROnuyT2XOeXH+VfxoVs+Qs6xudEdC
	gjCq99kdJ3go5SLYSAfv56ZSvh2DSRA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-Wo7Mps18PR2x4Rn7hjPhdg-1; Thu, 11 Nov 2021 13:54:38 -0500
X-MC-Unique: Wo7Mps18PR2x4Rn7hjPhdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FE9F8799F1;
	Thu, 11 Nov 2021 18:54:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0960110016F4;
	Thu, 11 Nov 2021 18:54:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CE9B24EA30;
	Thu, 11 Nov 2021 18:54:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABIsHCv027819 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 13:54:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 68FA16784A; Thu, 11 Nov 2021 18:54:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1BA7197FC;
	Thu, 11 Nov 2021 18:54:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1ABIs5b9026121; 
	Thu, 11 Nov 2021 12:54:05 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1ABIs4MQ026120;
	Thu, 11 Nov 2021 12:54:04 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 11 Nov 2021 12:53:48 -0600
Message-Id: <1636656832-26062-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636656832-26062-1-git-send-email-bmarzins@redhat.com>
References: <1636656832-26062-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 5/9] libmultipath: make set_int take a range
	for valid values
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If a value outside of the valid range is passed to set_int, it caps the
value at appropriate limit, and issues a warning.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 121 +++++++++++++++++++++++++++-----------------
 1 file changed, 75 insertions(+), 46 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index eb2c44c0..57b6a7b6 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -29,7 +29,8 @@
 #include "strbuf.h"
 
 static int
-set_int(vector strvec, void *ptr, const char *file, int line_nr)
+set_int(vector strvec, void *ptr, int min, int max, const char *file,
+	int line_nr)
 {
 	int *int_ptr = (int *)ptr;
 	char *buff, *eptr;
@@ -44,11 +45,17 @@ set_int(vector strvec, void *ptr, const char *file, int line_nr)
 	if (eptr > buff)
 		while (isspace(*eptr))
 			eptr++;
-	if (*buff == '\0' || *eptr != '\0' || res > INT_MAX || res < INT_MIN) {
-		condlog(1, "%s: invalid value for %s: \"%s\"",
-			__func__, (char*)VECTOR_SLOT(strvec, 0), buff);
+	if (*buff == '\0' || *eptr != '\0') {
+		condlog(1, "%s line %d, invalid value for %s: \"%s\"",
+			file, line_nr, (char*)VECTOR_SLOT(strvec, 0), buff);
 		rc = 1;
 	} else {
+		if (res > max || res < min) {
+			res = (res > max) ? max : min;
+			condlog(1, "%s line %d, value for %s too %s, capping at %ld",
+			file, line_nr, (char*)VECTOR_SLOT(strvec, 0),
+			(res == max)? "large" : "small", res);
+		}
 		rc = 0;
 		*int_ptr = res;
 	}
@@ -77,8 +84,8 @@ set_uint(vector strvec, void *ptr, const char *file, int line_nr)
 		while (isspace(*eptr))
 			eptr++;
 	if (*buff == '\0' || *eptr != '\0' || !isdigit(*p) || res > UINT_MAX) {
-		condlog(1, "%s: invalid value for %s: \"%s\"",
-			__func__, (char*)VECTOR_SLOT(strvec, 0), buff);
+		condlog(1, "%s line %d, invalid value for %s: \"%s\"",
+			file, line_nr, (char*)VECTOR_SLOT(strvec, 0), buff);
 		rc = 1;
 	} else {
 		rc = 0;
@@ -193,6 +200,14 @@ def_ ## option ## _handler (struct config *conf, vector strvec,		\
 	return function (strvec, &conf->option, file, line_nr);		\
 }
 
+#define declare_def_range_handler(option, minval, maxval)			\
+static int								\
+def_ ## option ## _handler (struct config *conf, vector strvec,         \
+			    const char *file, int line_nr)		\
+{									\
+	return set_int(strvec, &conf->option, minval, maxval, file, line_nr); \
+}
+
 #define declare_def_snprint(option, function)				\
 static int								\
 snprint_def_ ## option (struct config *conf, struct strbuf *buff,	\
@@ -234,6 +249,18 @@ hw_ ## option ## _handler (struct config *conf, vector strvec,		\
 	return function (strvec, &hwe->option, file, line_nr);		\
 }
 
+#define declare_hw_range_handler(option, minval, maxval)		\
+static int								\
+hw_ ## option ## _handler (struct config *conf, vector strvec,		\
+			   const char *file, int line_nr)		\
+{									\
+	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);		\
+	if (!hwe)							\
+		return 1;						\
+	return set_int(strvec, &hwe->option, minval, maxval, file, line_nr); \
+}
+
+
 #define declare_hw_snprint(option, function)				\
 static int								\
 snprint_hw_ ## option (struct config *conf, struct strbuf *buff,	\
@@ -253,6 +280,17 @@ ovr_ ## option ## _handler (struct config *conf, vector strvec,		\
 	return function (strvec, &conf->overrides->option, file, line_nr); \
 }
 
+#define declare_ovr_range_handler(option, minval, maxval)		\
+static int								\
+ovr_ ## option ## _handler (struct config *conf, vector strvec,		\
+			    const char *file, int line_nr)		\
+{									\
+	if (!conf->overrides)						\
+		return 1;						\
+	return set_int(strvec, &conf->overrides->option, minval, maxval, \
+		       file, line_nr); \
+}
+
 #define declare_ovr_snprint(option, function)				\
 static int								\
 snprint_ovr_ ## option (struct config *conf, struct strbuf *buff,	\
@@ -272,6 +310,17 @@ mp_ ## option ## _handler (struct config *conf, vector strvec,		\
 	return function (strvec, &mpe->option, file, line_nr);		\
 }
 
+#define declare_mp_range_handler(option, minval, maxval)		\
+static int								\
+mp_ ## option ## _handler (struct config *conf, vector strvec,		\
+			   const char *file, int line_nr)		\
+{									\
+	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);		\
+	if (!mpe)							\
+		return 1;						\
+	return set_int(strvec, &mpe->option, minval, maxval, file, line_nr); \
+}
+
 #define declare_mp_snprint(option, function)				\
 static int								\
 snprint_mp_ ## option (struct config *conf, struct strbuf *buff,	\
@@ -298,7 +347,7 @@ declare_def_snprint(checkint, print_int)
 declare_def_handler(max_checkint, set_uint)
 declare_def_snprint(max_checkint, print_int)
 
-declare_def_handler(verbosity, set_int)
+declare_def_range_handler(verbosity, 0, MAX_VERBOSITY)
 declare_def_snprint(verbosity, print_int)
 
 declare_def_handler(reassign_maps, set_yes_no)
@@ -473,22 +522,22 @@ declare_ovr_snprint(checker_name, print_str)
 declare_hw_handler(checker_name, set_str)
 declare_hw_snprint(checker_name, print_str)
 
-declare_def_handler(minio, set_int)
+declare_def_range_handler(minio, 0, INT_MAX)
 declare_def_snprint_defint(minio, print_int, DEFAULT_MINIO)
-declare_ovr_handler(minio, set_int)
+declare_ovr_range_handler(minio, 0, INT_MAX)
 declare_ovr_snprint(minio, print_nonzero)
-declare_hw_handler(minio, set_int)
+declare_hw_range_handler(minio, 0, INT_MAX)
 declare_hw_snprint(minio, print_nonzero)
-declare_mp_handler(minio, set_int)
+declare_mp_range_handler(minio, 0, INT_MAX)
 declare_mp_snprint(minio, print_nonzero)
 
-declare_def_handler(minio_rq, set_int)
+declare_def_range_handler(minio_rq, 0, INT_MAX)
 declare_def_snprint_defint(minio_rq, print_int, DEFAULT_MINIO_RQ)
-declare_ovr_handler(minio_rq, set_int)
+declare_ovr_range_handler(minio_rq, 0, INT_MAX)
 declare_ovr_snprint(minio_rq, print_nonzero)
-declare_hw_handler(minio_rq, set_int)
+declare_hw_range_handler(minio_rq, 0, INT_MAX)
 declare_hw_snprint(minio_rq, print_nonzero)
-declare_mp_handler(minio_rq, set_int)
+declare_mp_range_handler(minio_rq, 0, INT_MAX)
 declare_mp_snprint(minio_rq, print_nonzero)
 
 declare_def_handler(queue_without_daemon, set_yes_no)
@@ -512,7 +561,7 @@ snprint_def_queue_without_daemon(struct config *conf, struct strbuf *buff,
 	return append_strbuf_quoted(buff, qwd);
 }
 
-declare_def_handler(checker_timeout, set_int)
+declare_def_range_handler(checker_timeout, 0, INT_MAX)
 declare_def_snprint(checker_timeout, print_nonzero)
 
 declare_def_handler(allow_usb_devices, set_yes_no)
@@ -583,13 +632,13 @@ declare_hw_snprint(deferred_remove, print_yes_no_undef)
 declare_mp_handler(deferred_remove, set_yes_no_undef)
 declare_mp_snprint(deferred_remove, print_yes_no_undef)
 
-declare_def_handler(retrigger_tries, set_int)
+declare_def_range_handler(retrigger_tries, 0, INT_MAX)
 declare_def_snprint(retrigger_tries, print_int)
 
-declare_def_handler(retrigger_delay, set_int)
+declare_def_range_handler(retrigger_delay, 0, INT_MAX)
 declare_def_snprint(retrigger_delay, print_int)
 
-declare_def_handler(uev_wait_timeout, set_int)
+declare_def_range_handler(uev_wait_timeout, 0, INT_MAX)
 declare_def_snprint(uev_wait_timeout, print_int)
 
 declare_def_handler(strict_timing, set_yes_no)
@@ -616,19 +665,19 @@ static int snprint_def_disable_changed_wwids(struct config *conf,
 	return print_ignored(buff);
 }
 
-declare_def_handler(remove_retries, set_int)
+declare_def_range_handler(remove_retries, 0, INT_MAX)
 declare_def_snprint(remove_retries, print_int)
 
-declare_def_handler(max_sectors_kb, set_int)
+declare_def_range_handler(max_sectors_kb, 0, INT_MAX)
 declare_def_snprint(max_sectors_kb, print_nonzero)
-declare_ovr_handler(max_sectors_kb, set_int)
+declare_ovr_range_handler(max_sectors_kb, 0, INT_MAX)
 declare_ovr_snprint(max_sectors_kb, print_nonzero)
-declare_hw_handler(max_sectors_kb, set_int)
+declare_hw_range_handler(max_sectors_kb, 0, INT_MAX)
 declare_hw_snprint(max_sectors_kb, print_nonzero)
-declare_mp_handler(max_sectors_kb, set_int)
+declare_mp_range_handler(max_sectors_kb, 0, INT_MAX)
 declare_mp_snprint(max_sectors_kb, print_nonzero)
 
-declare_def_handler(find_multipaths_timeout, set_int)
+declare_def_range_handler(find_multipaths_timeout, INT_MIN, INT_MAX)
 declare_def_snprint_defint(find_multipaths_timeout, print_int,
 			   DEFAULT_FIND_MULTIPATHS_TIMEOUT)
 
@@ -1385,27 +1434,7 @@ declare_ovr_snprint(recheck_wwid, print_yes_no_undef)
 declare_hw_handler(recheck_wwid, set_yes_no_undef)
 declare_hw_snprint(recheck_wwid, print_yes_no_undef)
 
-
-static int
-def_uxsock_timeout_handler(struct config *conf, vector strvec, const char *file,
-			   int line_nr)
-{
-	unsigned int uxsock_timeout;
-	char *buff;
-
-	buff = set_value(strvec);
-	if (!buff)
-		return 1;
-
-	if (sscanf(buff, "%u", &uxsock_timeout) == 1 &&
-	    uxsock_timeout > DEFAULT_REPLY_TIMEOUT)
-		conf->uxsock_timeout = uxsock_timeout;
-	else
-		conf->uxsock_timeout = DEFAULT_REPLY_TIMEOUT;
-
-	free(buff);
-	return 0;
-}
+declare_def_range_handler(uxsock_timeout, DEFAULT_REPLY_TIMEOUT, INT_MAX)
 
 static int
 hw_vpd_vendor_handler(struct config *conf, vector strvec, const char *file,
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

