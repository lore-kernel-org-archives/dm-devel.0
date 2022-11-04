Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA85C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 23:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667603568;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=y927sojO747R9imp9QOQi3I1Abt/t2Fjdwxc6Wl0j1w=;
	b=RYzsey5LDn9QAUGldhwrNceqKZxW9RQYDz7sIx+Diu2KaH3oj1LxZ8N1ddU2S9bn9dtqBD
	8Z2o/pZvpKv6+UiL4zB29o+G8ATkEywXcMGtxGmEYRthFC+A92F528drwC137meajMmZFx
	F31lxvKpXuFliMHsXWfdClKvHUX44Q4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-LluPB450N6aTg3bwMRIQHw-1; Fri, 04 Nov 2022 19:12:45 -0400
X-MC-Unique: LluPB450N6aTg3bwMRIQHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 600242815200;
	Fri,  4 Nov 2022 23:12:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 00F3C20182B2;
	Fri,  4 Nov 2022 23:12:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D39D61946587;
	Fri,  4 Nov 2022 23:12:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D6FA1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 23:12:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 606D91402BDD; Fri,  4 Nov 2022 23:12:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 58004140EBF5
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 23:12:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CA6D811E67
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 23:12:39 +0000 (UTC)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-235-XbN7yLVXMEiWrTmquwkPXg-1; Fri, 04 Nov 2022 19:12:37 -0400
X-MC-Unique: XbN7yLVXMEiWrTmquwkPXg-1
Received: by mail-wm1-f54.google.com with SMTP id
 ay14-20020a05600c1e0e00b003cf6ab34b61so6283290wmb.2; 
 Fri, 04 Nov 2022 16:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=fQ1zfiV/1tg8/e1mq1OKKJipagZtKQyaOHthYv0TOFM=;
 b=cvyLV5kkunxJsxURPrFnIc72ieDFDOfwNMRxXYShHXJrPe7J56RBLXOQqsUG1Ax6xE
 0Lobg7rfTfKCOjOlo2O5FbIFMr/mbM2gGBPsdKqv4cFKaYjsDHgBIpjkf7OgTCMymnD7
 DHyR+Zw0U8co4qIhUe7CfSO6ZFIOzP2dmbxX0k1Fnhub9joV7phLFdZ7UQed/JtsJKOx
 Oyveffz2kepX+fMSHtObSXBjWmTfF/bjKaU75lf78u88mSVK5HQCF7Eq3gJxPEPUsYy5
 DeFUI4/FRVUayL5Nw0nCCJJlTgvD5UHaZU0f8weRKDpbbhQpMAubbcmv0sSsRxJuVF3z
 voig==
X-Gm-Message-State: ACrzQf31SGFCqHMEwum3zJF15XBRdR58OfipGpNwvlQVfjij7Hr1IuuX
 0CX7b/F7UMXVsMxXIPNGYW4Kd3yM2g==
X-Google-Smtp-Source: AMsMyM54KCEGEcPoEfpHdHwKyKAOvUO9mOXotfHy2FzvEsMXmDCr79+dFF8CtQDfHQjFlS1xPYrwJw==
X-Received: by 2002:a05:600c:1c88:b0:3c6:d9a5:a083 with SMTP id
 k8-20020a05600c1c8800b003c6d9a5a083mr35472231wms.54.1667603556059; 
 Fri, 04 Nov 2022 16:12:36 -0700 (PDT)
Received: from localhost (230.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.230]) by smtp.gmail.com with ESMTPSA id
 f66-20020a1c3845000000b003c6b70a4d69sm561898wma.42.2022.11.04.16.12.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 16:12:35 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat,  5 Nov 2022 00:12:34 +0100
Message-Id: <20221104231234.111216-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH] multipath-tools: fix c&p error in
 install_keyword for deprecated pg_timeout
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/dict.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 6fc77315..97f43387 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -2103,7 +2103,7 @@ init_keywords(vector keywords)
 	install_keyword("no_path_retry", &hw_no_path_retry_handler, &snprint_hw_no_path_retry);
 	install_keyword("rr_min_io", &hw_minio_handler, &snprint_hw_minio);
 	install_keyword("rr_min_io_rq", &hw_minio_rq_handler, &snprint_hw_minio_rq);
-	install_keyword("pg_timeout", &deprecated_handler, &snprint_deprecated);
+	install_keyword("pg_timeout", &deprecated_pg_timeout_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &hw_flush_on_last_del_handler, &snprint_hw_flush_on_last_del);
 	install_keyword("fast_io_fail_tmo", &hw_fast_io_fail_handler, &snprint_hw_fast_io_fail);
 	install_keyword("dev_loss_tmo", &hw_dev_loss_handler, &snprint_hw_dev_loss);
@@ -2192,7 +2192,7 @@ init_keywords(vector keywords)
 	install_keyword("no_path_retry", &mp_no_path_retry_handler, &snprint_mp_no_path_retry);
 	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_minio);
 	install_keyword("rr_min_io_rq", &mp_minio_rq_handler, &snprint_mp_minio_rq);
-	install_keyword("pg_timeout", &deprecated_handler, &snprint_deprecated);
+	install_keyword("pg_timeout", &deprecated_pg_timeout_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &mp_flush_on_last_del_handler, &snprint_mp_flush_on_last_del);
 	install_keyword("features", &mp_features_handler, &snprint_mp_features);
 	install_keyword("mode", &mp_mode_handler, &snprint_mp_mode);
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

