Return-Path: <SRS0=IV6L=OF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D686C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 22:51:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B240960FC0
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 22:51:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B240960FC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-sIzYR8VrMsSteEylF5klNA-1; Wed, 15 Sep 2021 18:51:08 -0400
X-MC-Unique: sIzYR8VrMsSteEylF5klNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0BE179EDF;
	Wed, 15 Sep 2021 22:51:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6AAF5C1C5;
	Wed, 15 Sep 2021 22:51:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1B1294E590;
	Wed, 15 Sep 2021 22:51:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18FMj1w3010493 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 18:45:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8FAF5112131F; Wed, 15 Sep 2021 22:45:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A4E21155894
	for <dm-devel@redhat.com>; Wed, 15 Sep 2021 22:44:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4B6E91C7CD
	for <dm-devel@redhat.com>; Wed, 15 Sep 2021 22:44:54 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
	[209.85.128.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-559-2H-r9DHdN9el5yl8Lma9qg-1; Wed, 15 Sep 2021 18:44:53 -0400
X-MC-Unique: 2H-r9DHdN9el5yl8Lma9qg-1
Received: by mail-wm1-f53.google.com with SMTP id
	b21-20020a1c8015000000b003049690d882so5934842wmd.5; 
	Wed, 15 Sep 2021 15:44:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=0FW51YHlrX8DUNqlzMWabHWJpMOJM9BMo0lsEj1LsVk=;
	b=flp6mDGwXFMKHvV8RfWinltD31RCKk0O7Cs6I1duEodafdY5CAtAKhUhdUOHwLFOu2
	TY1+dfbmvbKknMdnPN/T879IJZH1TT0jQydU+z4eH4LuKCfew4Hs1VQH64zWym9rAXiw
	XEFW8MkZW2Ib9YCBC3cgvMeqWDsEzwXJzW344EXj7xVDL5joHeOaNEbi22olikh9KzcT
	n1TZ6t/uNOOBVhLoj99avi3lQRk8IWqKrVo9FCDABn38bd5QEu5d4U4DMWOiegUP45ha
	Sqw8ORBy1Xd6+QBidMXurrjU/OfCQh8saUjrCwr1yvlX2a1rvR1wMSOPfuyQ0OKU/7hn
	zLEg==
X-Gm-Message-State: AOAM531CLxRZqYSiHpb5Hr/qUGEXgp2UxfJiIdDOzIRzE2ueYzEtBAOg
	lLrES85jBZJD+mevNEY/sA==
X-Google-Smtp-Source: ABdhPJy22jDTIcLZMp/NPgT19vsFNsi+TfaxvQn8Oz/KTOBkvMLIly6yhPKhaw+4SFX+NjtZPaGWXw==
X-Received: by 2002:a05:600c:1c0f:: with SMTP id
	j15mr1973043wms.3.1631745891536; 
	Wed, 15 Sep 2021 15:44:51 -0700 (PDT)
Received: from localhost (227.red-83-37-137.dynamicip.rima-tde.net.
	[83.37.137.227])
	by smtp.gmail.com with ESMTPSA id d8sm1378555wrv.20.2021.09.15.15.44.50
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 15 Sep 2021 15:44:50 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 16 Sep 2021 00:44:49 +0200
Message-Id: <20210915224449.16365-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: minor fixes to multipath.conf.5
	man page
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

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 42a15ffd..c74129bd 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1,9 +1,9 @@
 .\" ----------------------------------------------------------------------------
-.\" Update the date below if you make any significant change.
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t multipath/multipath.conf.5
 .\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.conf.5 >/dev/null
 .\"
+.\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
 .TH MULTIPATH.CONF 5 2021-09-08 Linux
@@ -189,7 +189,7 @@ The default is: \fB<system dependent>\fR
 .TP
 .B path_selector
 The default path selector algorithm to use; they are offered by the
-kernel multipath target. There are three selector algorithms:
+kernel multipath target:
 .RS
 .TP 12
 .I "round-robin 0"
@@ -206,7 +206,7 @@ of outstanding I/O to the path.
 of outstanding I/O to the path and its relative throughput.
 .TP
 .I "historical-service-time 0"
-(Since 5.8 kernel) Choose the path for the next bunch of IOs based on the
+(Since 5.8 kernel) Choose the path for the next bunch of I/O based on the
 estimation of future service time based on the history of previous I/O submitted
 to each path.
 .TP
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

