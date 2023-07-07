Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D235EB64D9
	for <dm-devel@archiver.kernel.org>; Fri,  7 Jul 2023 12:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688732405;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XWMKVW618XQ7WrXDEMCNnNC8LHo9JMYMYKbvW1hBCWY=;
	b=h0FKV94c7XaD1xeWbdILaw7IEGJAfwyp7hJRce6QbmBw4QrbwjjrpZjvXqJHvT/m/6ERdZ
	3n2mxU+aENeodCoAgSspZnr6ZPMIrLxnHNskU6OUHX0gYlOjhqAtHmb25K+DSmohdRgEzO
	CYbqRNw5FTJzregIE45NU06f1xZRD+o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-9ulcdY2FM423r-XBHLoZPQ-1; Fri, 07 Jul 2023 08:20:03 -0400
X-MC-Unique: 9ulcdY2FM423r-XBHLoZPQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BD25800962;
	Fri,  7 Jul 2023 12:20:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ECE6540C206F;
	Fri,  7 Jul 2023 12:20:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B58A6194658F;
	Fri,  7 Jul 2023 12:20:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 567E31946589
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Jul 2023 12:20:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 25E5640C2070; Fri,  7 Jul 2023 12:20:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E44D40C206F
 for <dm-devel@redhat.com>; Fri,  7 Jul 2023 12:20:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02024101A54E
 for <dm-devel@redhat.com>; Fri,  7 Jul 2023 12:20:00 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-63AB9587NqOfm4BaJjkzhw-1; Fri, 07 Jul 2023 08:19:56 -0400
X-MC-Unique: 63AB9587NqOfm4BaJjkzhw-1
Received: by mail-wr1-f51.google.com with SMTP id
 ffacd0b85a97d-3142860734aso2615886f8f.1; 
 Fri, 07 Jul 2023 05:19:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688732395; x=1691324395;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=L30Ywr3hJtZ8ldCDGIpa0BU1N1uXdO5EgrdqyAqB7C4=;
 b=Kiw4q+uUlOmhW4p6SzYGtHKS6uJhN9rvyh0WtrUEtLCqJUODeF7L0RBjQQBdcJO0j4
 JodhHhc6sebLuHHeYPilThch73k0RcQStyIGvJ5W/qz5P57CMyaI48cV/t6CDwc6ARIC
 CwXPHFYzm0Me4+gng5HC4KMX5EqueqrsMeTo2IEVMk4SJSUQHuWtR7m4WaMpZ+lbOrq0
 J1eI4laO2xyQUTLioyrbVu6A4lxwSFMEsZvWgJCzialGFQHlzLyb9hYYc/AquZYcl2Gt
 Z/T1dNPVej9sN+BWPBBy+wwP+OZIDFhtRmuOjfxWybEVa/Hb1IJo6//5mrZJC0WhPAAK
 TBfQ==
X-Gm-Message-State: ABy/qLamvaMsDfg/WsLm3xir2odR+SAtQ+snOAawhpInRohhRD8jkorO
 NaZMrW71hmj7T+94NtfUZg==
X-Google-Smtp-Source: APBJJlH4Wx1yD24yAfuO8Xc1QXWPlPr2kl3xxJees+L3bzKKk7O9gKwJW/rCkksSbVl5hBUggr0YeA==
X-Received: by 2002:a5d:58c5:0:b0:314:385d:3f32 with SMTP id
 o5-20020a5d58c5000000b00314385d3f32mr8257157wrf.29.1688732394810; 
 Fri, 07 Jul 2023 05:19:54 -0700 (PDT)
Received: from localhost (127.red-88-28-19.dynamicip.rima-tde.net.
 [88.28.19.127]) by smtp.gmail.com with ESMTPSA id
 f3-20020a5d5683000000b0030ae499da59sm4320211wrv.111.2023.07.07.05.19.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 05:19:54 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Fri,  7 Jul 2023 14:19:51 +0200
Message-ID: <20230707121952.9603-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH RFC] multipath-tools: treat disable_changed_wwids
 like other deprecated keywords
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/dict.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 6b3e04a3..f81c84aa 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -278,11 +278,6 @@ static int print_str(struct strbuf *buff, const char *ptr)
 	return ret == -EINVAL ? 0 : ret;
 }
 
-static int print_ignored(struct strbuf *buff)
-{
-	return append_strbuf_quoted(buff, "ignored");
-}
-
 static int print_yes_no(struct strbuf *buff, long v)
 {
 	return append_strbuf_quoted(buff, v == YN_NO ? "no" : "yes");
@@ -548,7 +543,6 @@ declare_def_snprint(verbosity, print_int)
 declare_def_handler(reassign_maps, set_yes_no)
 declare_def_snprint(reassign_maps, print_yes_no)
 
-declare_deprecated_handler(multipath_dir)
 
 static int def_partition_delim_handler(struct config *conf, vector strvec,
 				       const char *file, int line_nr)
@@ -918,17 +912,6 @@ declare_hw_handler(skip_kpartx, set_yes_no_undef)
 declare_hw_snprint(skip_kpartx, print_yes_no_undef)
 declare_mp_handler(skip_kpartx, set_yes_no_undef)
 declare_mp_snprint(skip_kpartx, print_yes_no_undef)
-static int def_disable_changed_wwids_handler(struct config *conf, vector strvec,
-					     const char *file, int line_nr)
-{
-	return 0;
-}
-static int snprint_def_disable_changed_wwids(struct config *conf,
-					     struct strbuf *buff,
-					     const void *data)
-{
-	return print_ignored(buff);
-}
 
 declare_def_range_handler(remove_retries, 0, INT_MAX)
 declare_def_snprint(remove_retries, print_int)
@@ -950,9 +933,6 @@ declare_def_handler(enable_foreign, set_str)
 declare_def_snprint_defstr(enable_foreign, print_str,
 			   DEFAULT_ENABLE_FOREIGN)
 
-declare_deprecated_handler(config_dir)
-declare_deprecated_handler(pg_timeout)
-
 #define declare_def_attr_handler(option, function)			\
 static int								\
 def_ ## option ## _handler (struct config *conf, vector strvec,		\
@@ -2076,7 +2056,12 @@ snprint_deprecated (struct config *conf, struct strbuf *buff, const void * data)
 	return 0;
 }
 
+// Deprecated keywords
+declare_deprecated_handler(config_dir)
+declare_deprecated_handler(disable_changed_wwids)
 declare_deprecated_handler(getuid_callout)
+declare_deprecated_handler(multipath_dir)
+declare_deprecated_handler(pg_timeout)
 
 /*
  * If you add or remove a keyword also update multipath/multipath.conf.5
@@ -2151,7 +2136,7 @@ init_keywords(vector keywords)
 	install_keyword("retrigger_delay", &def_retrigger_delay_handler, &snprint_def_retrigger_delay);
 	install_keyword("missing_uev_wait_timeout", &def_uev_wait_timeout_handler, &snprint_def_uev_wait_timeout);
 	install_keyword("skip_kpartx", &def_skip_kpartx_handler, &snprint_def_skip_kpartx);
-	install_keyword("disable_changed_wwids", &def_disable_changed_wwids_handler, &snprint_def_disable_changed_wwids);
+	install_keyword("disable_changed_wwids", &deprecated_disable_changed_wwids_handler, &snprint_deprecated);
 	install_keyword("remove_retries", &def_remove_retries_handler, &snprint_def_remove_retries);
 	install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, &snprint_def_max_sectors_kb);
 	install_keyword("ghost_delay", &def_ghost_delay_handler, &snprint_def_ghost_delay);
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

