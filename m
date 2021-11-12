Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F3CC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 01:24:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8CB6C6103D
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 01:24:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8CB6C6103D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636680291;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9ItdJ5XBv198XPg35rmbW7And/buY91QBzDWm/WRldc=;
	b=Cb1ARS+6zrpmlb2Qj7DJadD5EmGHcAnIVBtdHIK4LkKTfcYzJdIPd/0nCOk/2BMug6Ls8y
	u/wipuurzChC4wSdg+Iv8MjbwFzc0T+iGaNLWACoSX2upRcKsjaLU6BAPUk7rVoXN4pNfA
	4WUn5cYCK3hAoVRLcCFA/TmwRenhJtg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-LZmtmloFMzyFgY-241bU4Q-1; Thu, 11 Nov 2021 20:24:49 -0500
X-MC-Unique: LZmtmloFMzyFgY-241bU4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 968681006AA0;
	Fri, 12 Nov 2021 01:24:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 435BD60C05;
	Fri, 12 Nov 2021 01:24:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1FD911819AC1;
	Fri, 12 Nov 2021 01:24:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AC1OcLU002895 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 20:24:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 89C195F4EA; Fri, 12 Nov 2021 01:24:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BEF595D6D7;
	Fri, 12 Nov 2021 01:24:35 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AC1OWaw027946; 
	Thu, 11 Nov 2021 19:24:33 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AC1OWna027945;
	Thu, 11 Nov 2021 19:24:32 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 11 Nov 2021 19:24:31 -0600
Message-Id: <1636680271-27908-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH] libmultipath: don't return error on invalid
	values
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

do_set_int and set_uint return 1 for invalid values. This can cause
multipath to fail completely, while reading the config. The config
handlers should only return a non-zero value if there is an internal
error, not if there is just an invalid value.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Notes:
    This is meant to apply on top of my "improving config parsing warnings"
    patchset. I can fold these changes into those patches, if you'd rather.

 libmultipath/dict.c | 64 ++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 39 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index c534d703..1b75be47 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -30,7 +30,7 @@
 #include "dict.h"
 #include "strbuf.h"
 
-static int
+static void
 do_set_int(vector strvec, void *ptr, int min, int max, const char *file,
 	int line_nr, char *buff)
 {
@@ -45,7 +45,7 @@ do_set_int(vector strvec, void *ptr, int min, int max, const char *file,
 	if (*buff == '\0' || *eptr != '\0') {
 		condlog(1, "%s line %d, invalid value for %s: \"%s\"",
 			file, line_nr, (char*)VECTOR_SLOT(strvec, 0), buff);
-		return 1;
+		return;
 	}
 	if (res > max || res < min) {
 		res = (res > max) ? max : min;
@@ -54,7 +54,7 @@ do_set_int(vector strvec, void *ptr, int min, int max, const char *file,
 		(res == max)? "large" : "small", res);
 	}
 	*int_ptr = res;
-	return 0;
+	return;
 }
 
 static int
@@ -62,16 +62,15 @@ set_int(vector strvec, void *ptr, int min, int max, const char *file,
 	int line_nr)
 {
 	char *buff;
-	int rc;
 
 	buff = set_value(strvec);
 	if (!buff)
 		return 1;
 
-	rc = do_set_int(strvec, ptr, min, max, file, line_nr, buff);
+	do_set_int(strvec, ptr, min, max, file, line_nr, buff);
 
 	FREE(buff);
-	return rc;
+	return 0;
 }
 
 static int
@@ -80,7 +79,6 @@ set_uint(vector strvec, void *ptr, const char *file, int line_nr)
 	unsigned int *uint_ptr = (unsigned int *)ptr;
 	char *buff, *eptr, *p;
 	unsigned long res;
-	int rc;
 
 	buff = set_value(strvec);
 	if (!buff)
@@ -93,17 +91,14 @@ set_uint(vector strvec, void *ptr, const char *file, int line_nr)
 	if (eptr > buff)
 		while (isspace(*eptr))
 			eptr++;
-	if (*buff == '\0' || *eptr != '\0' || !isdigit(*p) || res > UINT_MAX) {
+	if (*buff == '\0' || *eptr != '\0' || !isdigit(*p) || res > UINT_MAX)
 		condlog(1, "%s line %d, invalid value for %s: \"%s\"",
 			file, line_nr, (char*)VECTOR_SLOT(strvec, 0), buff);
-		rc = 1;
-	} else {
-		rc = 0;
+	else
 		*uint_ptr = res;
-	}
 
 	FREE(buff);
-	return rc;
+	return 0;
 }
 
 static int
@@ -954,7 +949,6 @@ declare_mp_attr_snprint(gid, print_gid)
 static int
 set_undef_off_zero(vector strvec, void *ptr, const char *file, int line_nr)
 {
-	int rc = 0;
 	char * buff;
 	int *int_ptr = (int *)ptr;
 
@@ -964,11 +958,10 @@ set_undef_off_zero(vector strvec, void *ptr, const char *file, int line_nr)
 
 	if (strcmp(buff, "off") == 0)
 		*int_ptr = UOZ_OFF;
-	else
-		rc = do_set_int(strvec, int_ptr, 0, INT_MAX, file, line_nr,
-				buff);
-	if (rc == 0 && *int_ptr == 0)
+	else if (strcmp(buff, "0") == 0)
 		*int_ptr = UOZ_ZERO;
+	else
+		do_set_int(strvec, int_ptr, 1, INT_MAX, file, line_nr, buff);
 
 	FREE(buff);
 	return 0;
@@ -1114,28 +1107,24 @@ max_fds_handler(struct config *conf, vector strvec, const char *file,
 		int line_nr)
 {
 	char * buff;
-	int r = 0, max_fds;
+	int max_fds;
 
 	buff = set_value(strvec);
 
 	if (!buff)
 		return 1;
 
-	r = get_sys_max_fds(&max_fds);
-	if (r) {
-		/* Assume safe limit */
-		max_fds = 4096;
-	}
-	if (!strcmp(buff, "max")) {
+	if (get_sys_max_fds(&max_fds) != 0)
+		max_fds = 4096;  /* Assume safe limit */
+	if (!strcmp(buff, "max"))
 		conf->max_fds = max_fds;
-		r = 0;
-	} else
-		r = do_set_int(strvec, &conf->max_fds, 0, max_fds, file,
-			       line_nr, buff);
+	else
+		do_set_int(strvec, &conf->max_fds, 0, max_fds, file, line_nr,
+			   buff);
 
 	FREE(buff);
 
-	return r;
+	return 0;
 }
 
 static int
@@ -1201,7 +1190,6 @@ declare_mp_snprint(rr_weight, print_rr_weight)
 static int
 set_pgfailback(vector strvec, void *ptr, const char *file, int line_nr)
 {
-	int rc = 0;
 	int *int_ptr = (int *)ptr;
 	char * buff;
 
@@ -1216,11 +1204,11 @@ set_pgfailback(vector strvec, void *ptr, const char *file, int line_nr)
 	else if (strlen(buff) == 10 && !strcmp(buff, "followover"))
 		*int_ptr = -FAILBACK_FOLLOWOVER;
 	else
-		rc = do_set_int(strvec, ptr, 0, INT_MAX, file, line_nr, buff);
+		do_set_int(strvec, ptr, 0, INT_MAX, file, line_nr, buff);
 
 	FREE(buff);
 
-	return rc;
+	return 0;
 }
 
 int
@@ -1252,7 +1240,6 @@ declare_mp_snprint(pgfailback, print_pgfailback)
 static int
 no_path_retry_helper(vector strvec, void *ptr, const char *file, int line_nr)
 {
-	int rc = 0;
 	int *int_ptr = (int *)ptr;
 	char * buff;
 
@@ -1265,10 +1252,10 @@ no_path_retry_helper(vector strvec, void *ptr, const char *file, int line_nr)
 	else if (!strcmp(buff, "queue"))
 		*int_ptr = NO_PATH_RETRY_QUEUE;
 	else
-		rc = do_set_int(strvec, ptr, 1, INT_MAX, file, line_nr, buff);
+		do_set_int(strvec, ptr, 1, INT_MAX, file, line_nr, buff);
 
 	FREE(buff);
-	return rc;
+	return 0;
 }
 
 int
@@ -1413,7 +1400,6 @@ snprint_mp_reservation_key (struct config *conf, struct strbuf *buff,
 static int
 set_off_int_undef(vector strvec, void *ptr, const char *file, int line_nr)
 {
-	int rc =0;
 	int *int_ptr = (int *)ptr;
 	char * buff;
 
@@ -1424,10 +1410,10 @@ set_off_int_undef(vector strvec, void *ptr, const char *file, int line_nr)
 	if (!strcmp(buff, "no") || !strcmp(buff, "0"))
 		*int_ptr = NU_NO;
 	else
-		rc = do_set_int(strvec, ptr, 1, INT_MAX, file, line_nr, buff);
+		do_set_int(strvec, ptr, 1, INT_MAX, file, line_nr, buff);
 
 	FREE(buff);
-	return rc;
+	return 0;
 }
 
 int
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

