Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BCFC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:54:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B771C60F9E
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:54:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B771C60F9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636656877;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ILyQmJOBXflNlo1ko487u1WPGMMf0K6/b+C3u2C4oV4=;
	b=bp3wo2RYWjHnbEPk8W5imFEYeQdNzxr5b59F5FUyjG97gQRDg0+S+KHVp8aDon423GOrQx
	EexYUX9dj2nuU5B5ywR30Idmdx6WdihP2J37UdzDbhbDm6XCpYbpzD7BUnWq5+nPQhl4Gt
	GJN3oVg/WlDEWPQvB3LH6iQIjv5H/98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-masG8vUJOPyvZZvERNO__w-1; Thu, 11 Nov 2021 13:54:34 -0500
X-MC-Unique: masG8vUJOPyvZZvERNO__w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 369D38799EB;
	Thu, 11 Nov 2021 18:54:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 17DBD19C59;
	Thu, 11 Nov 2021 18:54:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E97141819AC1;
	Thu, 11 Nov 2021 18:54:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABIsS26027854 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 13:54:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0B2A610495BA; Thu, 11 Nov 2021 18:54:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBC951042B7E;
	Thu, 11 Nov 2021 18:54:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1ABIsFSl026138; 
	Thu, 11 Nov 2021 12:54:15 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1ABIsDhJ026137;
	Thu, 11 Nov 2021 12:54:13 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 11 Nov 2021 12:53:52 -0600
Message-Id: <1636656832-26062-10-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636656832-26062-1-git-send-email-bmarzins@redhat.com>
References: <1636656832-26062-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 9/9] libmultipath: cleanup invalid config
	handling
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add error reporting to the remaining config handlers. If the value is
invalid, do not change the existing config option's value. Also print
an error whenever 0 is returned for an invalid value. When the handler
returns 1, config processing already fails with an error message.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 73 +++++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 22 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 68647061..c534d703 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -199,8 +199,11 @@ set_yes_no(vector strvec, void *ptr, const char *file, int line_nr)
 
 	if (strcmp(buff, "yes") == 0 || strcmp(buff, "1") == 0)
 		*int_ptr = YN_YES;
-	else
+	else if (strcmp(buff, "no") == 0 || strcmp(buff, "0") == 0)
 		*int_ptr = YN_NO;
+	else
+		condlog(1, "%s line %d, invalid value for %s: \"%s\"",
+			file, line_nr, (char*)VECTOR_SLOT(strvec, 0), buff);
 
 	FREE(buff);
 	return 0;
@@ -221,7 +224,8 @@ set_yes_no_undef(vector strvec, void *ptr, const char *file, int line_nr)
 	else if (strcmp(buff, "yes") == 0 || strcmp(buff, "1") == 0)
 		*int_ptr = YNU_YES;
 	else
-		*int_ptr = YNU_UNDEF;
+		condlog(1, "%s line %d, invalid value for %s: \"%s\"",
+			file, line_nr, (char*)VECTOR_SLOT(strvec, 0), buff);
 
 	FREE(buff);
 	return 0;
@@ -480,9 +484,6 @@ def_find_multipaths_handler(struct config *conf, vector strvec,
 	char *buff;
 	int i;
 
-	if (set_yes_no_undef(strvec, &conf->find_multipaths, file, line_nr) == 0 && conf->find_multipaths != FIND_MULTIPATHS_UNDEF)
-		return 0;
-
 	buff = set_value(strvec);
 	if (!buff)
 		return 1;
@@ -495,9 +496,14 @@ def_find_multipaths_handler(struct config *conf, vector strvec,
 		}
 	}
 
-	if (conf->find_multipaths == YNU_UNDEF) {
-		condlog(0, "illegal value for find_multipaths: %s", buff);
-		conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
+	if (i >= __FIND_MULTIPATHS_LAST) {
+		if (strcmp(buff, "no") == 0 || strcmp(buff, "0") == 0)
+			conf->find_multipaths = FIND_MULTIPATHS_OFF;
+		else if (strcmp(buff, "yes") == 0 || strcmp(buff, "1") == 0)
+			conf->find_multipaths = FIND_MULTIPATHS_ON;
+		else
+			condlog(1, "%s line %d, invalid value for find_multipaths: \"%s\"",
+				file, line_nr, buff);
 	}
 
 	FREE(buff);
@@ -546,8 +552,10 @@ static int uid_attrs_handler(struct config *conf, vector strvec,
 	if (!val)
 		return 1;
 	if (parse_uid_attrs(val, conf))
-		condlog(1, "error parsing uid_attrs: \"%s\"", val);
-	condlog(3, "parsed %d uid_attrs", VECTOR_SIZE(&conf->uid_attrs));
+		condlog(1, "%s line %d,error parsing uid_attrs: \"%s\"", file,
+			line_nr, val);
+	else
+		condlog(4, "parsed %d uid_attrs", VECTOR_SIZE(&conf->uid_attrs));
 	FREE(val);
 	return 0;
 }
@@ -775,8 +783,11 @@ def_config_dir_handler(struct config *conf, vector strvec, const char *file,
 		       int line_nr)
 {
 	/* this is only valid in the main config file */
-	if (conf->processed_main_config)
+	if (conf->processed_main_config) {
+		condlog(1, "%s line %d, config_dir option only valid in /etc/multipath.conf",
+			file, line_nr);
 		return 0;
+	}
 	condlog(2, "%s line %d, \"config_dir\" is deprecated and will be disabled in a future release",
 		file, line_nr);
 	return set_path(strvec, &conf->config_dir, file, line_nr);
@@ -836,7 +847,9 @@ set_mode(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
 	if (sscanf(buff, "%o", &mode) == 1 && mode <= 0777) {
 		*flags |= (1 << ATTR_MODE);
 		*mode_ptr = mode;
-	}
+	} else
+		condlog(1, "%s line %d, invalid value for mode: \"%s\"",
+			file, line_nr, buff);
 
 	FREE(buff);
 	return 0;
@@ -861,7 +874,9 @@ set_uid(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
 	else if (sscanf(buff, "%u", &uid) == 1){
 		*flags |= (1 << ATTR_UID);
 		*uid_ptr = uid;
-	}
+	} else
+		condlog(1, "%s line %d, invalid value for uid: \"%s\"",
+			file, line_nr, buff);
 
 	FREE(buff);
 	return 0;
@@ -887,7 +902,9 @@ set_gid(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
 	else if (sscanf(buff, "%u", &gid) == 1){
 		*flags |= (1 << ATTR_GID);
 		*gid_ptr = gid;
-	}
+	} else
+		condlog(1, "%s line %d, invalid value for gid: \"%s\"",
+			file, line_nr, buff);
 	FREE(buff);
 	return 0;
 }
@@ -989,7 +1006,8 @@ set_dev_loss(vector strvec, void *ptr, const char *file, int line_nr)
 	if (!strcmp(buff, "infinity"))
 		*uint_ptr = MAX_DEV_LOSS_TMO;
 	else if (sscanf(buff, "%u", uint_ptr) != 1)
-		*uint_ptr = DEV_LOSS_TMO_UNSET;
+		condlog(1, "%s line %d, invalid value for dev_loss_tmo: \"%s\"",
+			file, line_nr, buff);
 
 	FREE(buff);
 	return 0;
@@ -1023,13 +1041,19 @@ static int
 set_pgpolicy(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	char * buff;
+	int policy;
 	int *int_ptr = (int *)ptr;
 
 	buff = set_value(strvec);
 	if (!buff)
 		return 1;
 
-	*int_ptr = get_pgpolicy_id(buff);
+	policy = get_pgpolicy_id(buff);
+	if (policy != IOPOLICY_UNDEF)
+		*int_ptr = policy;
+	else
+		condlog(1, "%s line %d, invalid value for path_grouping_policy: \"%s\"",
+			file, line_nr, buff);
 	FREE(buff);
 
 	return 0;
@@ -1142,10 +1166,11 @@ set_rr_weight(vector strvec, void *ptr, const char *file, int line_nr)
 
 	if (!strcmp(buff, "priorities"))
 		*int_ptr = RR_WEIGHT_PRIO;
-
-	if (!strcmp(buff, "uniform"))
+	else if (!strcmp(buff, "uniform"))
 		*int_ptr = RR_WEIGHT_NONE;
-
+	else
+		condlog(1, "%s line %d, invalid value for rr_weight: \"%s\"",
+			file, line_nr, buff);
 	FREE(buff);
 
 	return 0;
@@ -1281,10 +1306,13 @@ def_log_checker_err_handler(struct config *conf, vector strvec,
 	if (!buff)
 		return 1;
 
-	if (strlen(buff) == 4 && !strcmp(buff, "once"))
+	if (!strcmp(buff, "once"))
 		conf->log_checker_err = LOG_CHKR_ERR_ONCE;
-	else if (strlen(buff) == 6 && !strcmp(buff, "always"))
+	else if (!strcmp(buff, "always"))
 		conf->log_checker_err = LOG_CHKR_ERR_ALWAYS;
+	else
+		condlog(1, "%s line %d, invalid value for log_checker_err: \"%s\"",
+			file, line_nr, buff);
 
 	free(buff);
 	return 0;
@@ -1545,7 +1573,8 @@ hw_vpd_vendor_handler(struct config *conf, vector strvec, const char *file,
 			goto out;
 		}
 	}
-	hwe->vpd_vendor_id = 0;
+	condlog(1, "%s line %d, invalid value for vpd_vendor: \"%s\"",
+		file, line_nr, buff);
 out:
 	FREE(buff);
 	return 0;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

