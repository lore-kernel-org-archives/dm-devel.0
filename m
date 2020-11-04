Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE7FC2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 06:59:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 10F522225B
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 06:59:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gEF1hhJq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10F522225B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604473178;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IXjInUDfIDkWL9SBl6Dhpncoj7xXmqnZ37b8RKQLo2U=;
	b=gEF1hhJq7ubz4x6MWmndyCfAKl98dDBJqAVHFFCWe3o+ubNyKilBfqf7dTRwvdD5mpGwvp
	5H1QPv81sFmDe0WY3FnJV9NVpGcUcby6d3i/WKPgHxHfBOfGyo7PFiTi8E/MhaBmUIRypx
	le0lpbWE3woX+AqNtoJ/RhqWyaLdZ8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-d1MFJnqPOfG1-t-S1TGk4A-1; Wed, 04 Nov 2020 01:59:36 -0500
X-MC-Unique: d1MFJnqPOfG1-t-S1TGk4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C4CA10866A2;
	Wed,  4 Nov 2020 06:59:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C05E10027AA;
	Wed,  4 Nov 2020 06:59:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0AE8B5811B;
	Wed,  4 Nov 2020 06:59:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A46sFME017287 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 01:54:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AFD265C26C; Wed,  4 Nov 2020 06:54:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEAF95C22E;
	Wed,  4 Nov 2020 06:54:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A46sCZ5022464; 
	Wed, 4 Nov 2020 00:54:12 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A46sB4O022463;
	Wed, 4 Nov 2020 00:54:11 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  4 Nov 2020 00:54:04 -0600
Message-Id: <1604472849-22422-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
References: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 1/6] libmultipath: move fast_io_fail defines
	to structs.h
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Since fast_io_fail is part of the multipath struct, its symbolic values
belong in structs.h. Also, make it an instance of a general enum, which
will be used again in future patches, and change the set/print functions
which use it to use the general enum instead.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h  |  8 --------
 libmultipath/dict.c    | 30 +++++++++++++++---------------
 libmultipath/dict.h    |  2 +-
 libmultipath/propsel.c |  2 +-
 libmultipath/structs.h | 17 +++++++++++++++++
 5 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 5d460359..661dd586 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -10,14 +10,6 @@
 #define ORIGIN_DEFAULT 0
 #define ORIGIN_CONFIG  1
 
-/*
- * In kernel, fast_io_fail == 0 means immediate failure on rport delete.
- * OTOH '0' means not-configured in various places in multipath-tools.
- */
-#define MP_FAST_IO_FAIL_UNSET (0)
-#define MP_FAST_IO_FAIL_OFF (-1)
-#define MP_FAST_IO_FAIL_ZERO (-2)
-
 enum devtypes {
 	DEV_NONE,
 	DEV_DEVT,
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index f12c2e5c..f4357da1 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -822,7 +822,7 @@ declare_mp_attr_handler(gid, set_gid)
 declare_mp_attr_snprint(gid, print_gid)
 
 static int
-set_fast_io_fail(vector strvec, void *ptr)
+set_undef_off_zero(vector strvec, void *ptr)
 {
 	char * buff;
 	int *int_ptr = (int *)ptr;
@@ -832,36 +832,36 @@ set_fast_io_fail(vector strvec, void *ptr)
 		return 1;
 
 	if (strcmp(buff, "off") == 0)
-		*int_ptr = MP_FAST_IO_FAIL_OFF;
+		*int_ptr = UOZ_OFF;
 	else if (sscanf(buff, "%d", int_ptr) != 1 ||
-		 *int_ptr < MP_FAST_IO_FAIL_ZERO)
-		*int_ptr = MP_FAST_IO_FAIL_UNSET;
+		 *int_ptr < UOZ_ZERO)
+		*int_ptr = UOZ_UNDEF;
 	else if (*int_ptr == 0)
-		*int_ptr = MP_FAST_IO_FAIL_ZERO;
+		*int_ptr = UOZ_ZERO;
 
 	FREE(buff);
 	return 0;
 }
 
 int
-print_fast_io_fail(char * buff, int len, long v)
+print_undef_off_zero(char * buff, int len, long v)
 {
-	if (v == MP_FAST_IO_FAIL_UNSET)
+	if (v == UOZ_UNDEF)
 		return 0;
-	if (v == MP_FAST_IO_FAIL_OFF)
+	if (v == UOZ_OFF)
 		return snprintf(buff, len, "\"off\"");
-	if (v == MP_FAST_IO_FAIL_ZERO)
+	if (v == UOZ_ZERO)
 		return snprintf(buff, len, "0");
 	return snprintf(buff, len, "%ld", v);
 }
 
-declare_def_handler(fast_io_fail, set_fast_io_fail)
-declare_def_snprint_defint(fast_io_fail, print_fast_io_fail,
+declare_def_handler(fast_io_fail, set_undef_off_zero)
+declare_def_snprint_defint(fast_io_fail, print_undef_off_zero,
 			   DEFAULT_FAST_IO_FAIL)
-declare_ovr_handler(fast_io_fail, set_fast_io_fail)
-declare_ovr_snprint(fast_io_fail, print_fast_io_fail)
-declare_hw_handler(fast_io_fail, set_fast_io_fail)
-declare_hw_snprint(fast_io_fail, print_fast_io_fail)
+declare_ovr_handler(fast_io_fail, set_undef_off_zero)
+declare_ovr_snprint(fast_io_fail, print_undef_off_zero)
+declare_hw_handler(fast_io_fail, set_undef_off_zero)
+declare_hw_snprint(fast_io_fail, print_undef_off_zero)
 
 static int
 set_dev_loss(vector strvec, void *ptr)
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index a40ac66f..a917e1ca 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -13,7 +13,7 @@ int print_rr_weight(char *buff, int len, long v);
 int print_pgfailback(char *buff, int len, long v);
 int print_pgpolicy(char *buff, int len, long v);
 int print_no_path_retry(char *buff, int len, long v);
-int print_fast_io_fail(char *buff, int len, long v);
+int print_undef_off_zero(char *buff, int len, long v);
 int print_dev_loss(char *buff, int len, unsigned long v);
 int print_reservation_key(char * buff, int len, struct be64 key, uint8_t
 			  flags, int source);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 3f2c2cfa..67d025cf 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -754,7 +754,7 @@ int select_fast_io_fail(struct config *conf, struct multipath *mp)
 	mp_set_conf(fast_io_fail);
 	mp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
 out:
-	print_fast_io_fail(buff, 12, mp->fast_io_fail);
+	print_undef_off_zero(buff, 12, mp->fast_io_fail);
 	condlog(3, "%s: fast_io_fail_tmo = %s %s", mp->alias, buff, origin);
 	return 0;
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 4ce30551..cfa7b649 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -219,6 +219,23 @@ enum vpd_vendor_ids {
 	VPD_VP_ARRAY_SIZE, /* This must remain the last entry */
 };
 
+/*
+ * Multipath treats 0 as undefined for optional config parameters.
+ * Use this for cases where 0 is a valid option for systems multipath
+ * is communicating with
+ */
+enum undefined_off_zero {
+	UOZ_UNDEF = 0,
+	UOZ_OFF = -1,
+	UOZ_ZERO = -2,
+};
+
+enum fast_io_fail_states {
+	MP_FAST_IO_FAIL_UNSET = UOZ_UNDEF,
+	MP_FAST_IO_FAIL_OFF = UOZ_OFF,
+	MP_FAST_IO_FAIL_ZERO = UOZ_ZERO,
+};
+
 struct vpd_vendor_page {
 	int pg;
 	const char *name;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

