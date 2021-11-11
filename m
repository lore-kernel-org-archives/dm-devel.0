Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FE6C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 01:08:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 767FE611C9
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 01:08:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 767FE611C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636592890;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ch2SxOumIvKWp92EMNz7wYQtiSUlXCdj9ZStG713zvk=;
	b=F+sjkQb11iSpA3cWHy3dtvmgjI69bgSCBWnZDEkvTw8AzQkob/jjY1O4XY384YdHNCG9Wt
	+5qoYuqa+Lc9Nozs4apyLYHP6F+AbCDNz6gSqDkKbf4u13xqZikY2JbJ3+umDEe6GIgBUe
	zkhMwM1Km6jzA20FWaeTb8y/oHjwog8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-hmoUM7XtOLS-_ALu09Y3sA-1; Wed, 10 Nov 2021 20:07:17 -0500
X-MC-Unique: hmoUM7XtOLS-_ALu09Y3sA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E43CC1030C25;
	Thu, 11 Nov 2021 01:07:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CDEE8104A9C1;
	Thu, 11 Nov 2021 01:07:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A7C144EA31;
	Thu, 11 Nov 2021 01:07:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AB16gwW013191 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Nov 2021 20:06:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2D771794A4; Thu, 11 Nov 2021 01:06:42 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A40C794A3;
	Thu, 11 Nov 2021 01:06:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AB16drJ020465; 
	Wed, 10 Nov 2021 19:06:40 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AB16dVl020464;
	Wed, 10 Nov 2021 19:06:39 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 10 Nov 2021 19:06:20 -0600
Message-Id: <1636592780-20391-10-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636592780-20391-1-git-send-email-bmarzins@redhat.com>
References: <1636592780-20391-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 9/9] libmultipath: cleanup invalid config
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
---
 libmultipath/dict.c | 73 +++++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 22 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 3212d14c..37347482 100644
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
@@ -491,9 +495,6 @@ def_find_multipaths_handler(struct config *conf, vector strvec,
 	char *buff;
 	int i;
 
-	if (set_yes_no_undef(strvec, &conf->find_multipaths, file, line_nr) == 0 && conf->find_multipaths != FIND_MULTIPATHS_UNDEF)
-		return 0;
-
 	buff = set_value(strvec);
 	if (!buff)
 		return 1;
@@ -506,9 +507,14 @@ def_find_multipaths_handler(struct config *conf, vector strvec,
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
@@ -557,8 +563,10 @@ static int uid_attrs_handler(struct config *conf, vector strvec,
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
@@ -786,8 +794,11 @@ def_config_dir_handler(struct config *conf, vector strvec, const char *file,
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
@@ -847,7 +858,9 @@ set_mode(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
 	if (sscanf(buff, "%o", &mode) == 1 && mode <= 0777) {
 		*flags |= (1 << ATTR_MODE);
 		*mode_ptr = mode;
-	}
+	} else
+		condlog(1, "%s line %d, invalid value for mode: \"%s\"",
+			file, line_nr, buff);
 
 	FREE(buff);
 	return 0;
@@ -872,7 +885,9 @@ set_uid(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
 	else if (sscanf(buff, "%u", &uid) == 1){
 		*flags |= (1 << ATTR_UID);
 		*uid_ptr = uid;
-	}
+	} else
+		condlog(1, "%s line %d, invalid value for uid: \"%s\"",
+			file, line_nr, buff);
 
 	FREE(buff);
 	return 0;
@@ -898,7 +913,9 @@ set_gid(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
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
@@ -1000,7 +1017,8 @@ set_dev_loss(vector strvec, void *ptr, const char *file, int line_nr)
 	if (!strcmp(buff, "infinity"))
 		*uint_ptr = MAX_DEV_LOSS_TMO;
 	else if (sscanf(buff, "%u", uint_ptr) != 1)
-		*uint_ptr = DEV_LOSS_TMO_UNSET;
+		condlog(1, "%s line %d, invalid value for dev_loss_tmo: \"%s\"",
+			file, line_nr, buff);
 
 	FREE(buff);
 	return 0;
@@ -1034,13 +1052,19 @@ static int
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
@@ -1153,10 +1177,11 @@ set_rr_weight(vector strvec, void *ptr, const char *file, int line_nr)
 
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
@@ -1295,10 +1320,13 @@ def_log_checker_err_handler(struct config *conf, vector strvec,
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
@@ -1562,7 +1590,8 @@ hw_vpd_vendor_handler(struct config *conf, vector strvec, const char *file,
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

