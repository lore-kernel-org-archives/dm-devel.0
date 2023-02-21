Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686CEC636D7
	for <dm-devel@archiver.kernel.org>; Tue, 21 Feb 2023 20:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677013042;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2sZCLK7FqELd4FQIvHbNVxFv8PpCBImCC70hbr9GY5M=;
	b=Kdd7W+7UJNcxuRpKnK27VUr0FYWq3zM+V/E1J4pjIghl4jAcgYiRKsUSBGjMdJe0VNw0HW
	k4L7Vs22q9TnAatRaUyzgQo6N6Yy0Qn8pV82pGeTio/Pi9HZLPZlDYa2CR4eaxWnpFp9Jf
	NcljhJDN1469g5LnRDb0hl1REgGuJ+I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-hY06rtBtPkq8WEQYHzrdBw-1; Tue, 21 Feb 2023 15:57:20 -0500
X-MC-Unique: hY06rtBtPkq8WEQYHzrdBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8644C1C0878F;
	Tue, 21 Feb 2023 20:57:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BE4B82026D4B;
	Tue, 21 Feb 2023 20:57:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7D2341946588;
	Tue, 21 Feb 2023 20:57:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF53F1946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 21 Feb 2023 20:56:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 898E92166B29; Tue, 21 Feb 2023 20:56:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82B462166B26
 for <dm-devel@redhat.com>; Tue, 21 Feb 2023 20:56:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6463A87A9E1
 for <dm-devel@redhat.com>; Tue, 21 Feb 2023 20:56:59 +0000 (UTC)
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com
 [209.85.160.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-103-9IVlA_nFMZupI5ZNFGWQww-1; Tue, 21 Feb 2023 15:56:57 -0500
X-MC-Unique: 9IVlA_nFMZupI5ZNFGWQww-1
Received: by mail-oa1-f49.google.com with SMTP id
 586e51a60fabf-17235c8dab9so3246050fac.7
 for <dm-devel@redhat.com>; Tue, 21 Feb 2023 12:56:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1677013015;
 h=to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=wZzrwWC6/7MA2la8DG0lRRIdl0fD6P/20ad8tGdAfcs=;
 b=IyFU1+QaFKf3tHt5pRjbf23qTKMpEvdN2BDPpGv69wcK38oTdKsNJ52vOgMFoiWvWo
 mXdYLhXu/8JqLCgqSeffFtvgiJXpPFPi+mN2wdYngEO5dvC1la8xqoChFedaZHXcYUQC
 oRFxq0ZsTOEKoPUR54LEcyQmlHq8TZIL1I85MSFU+ezyR/owtC/mE29HoXqviIq3qVMj
 7ny6aLyycqtcJdIpe9GXx8sXo7Qzp5JciUo7jPl+B0+FQm2YSzoI+CX0NbMvi9i7vFlI
 +Y+++ldq/Zm5ioOMhbPH5BmSjJAGfxhBLdk1jJ5c9PXsx4Qckihn/tlHehBwaOq9/ITr
 1rDQ==
X-Gm-Message-State: AO0yUKU3+vOnzykPxCPdM5hvpf8CkGWDVbXaySuPH5VKyus5hYvIodBw
 XnAt19VTSjpgwKVbLRxwHvBv+xSfbExtG9KV5FMeHeBRto4Oo1zP
X-Google-Smtp-Source: AK7set84za1PtPOT5N6fYc1F4gATPWyimzexBYqPnrbUeYZzN3qmBwj/yJuJapBC4gfJLajaRGZJkA4AHr6LZ0kFdsY=
X-Received: by 2002:a05:6870:b28c:b0:163:6714:e724 with SMTP id
 c12-20020a056870b28c00b001636714e724mr968329oao.290.1677013015526; Tue, 21
 Feb 2023 12:56:55 -0800 (PST)
MIME-Version: 1.0
From: Brian Bunker <brian@purestorage.com>
Date: Tue, 21 Feb 2023 12:56:43 -0800
Message-ID: <CAHZQxyJH1etLR5gHuWk4c6-ieioqA4GrJ173B60bnTppke58dw@mail.gmail.com>
To: device-mapper development <dm-devel@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH] [PATCH] libmultipath: return 'ghost' state when
 port is in transition
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A test unit ready command sent on a path in standby state will not result
in a failed path. The same should be true for a path in the
transitioning state.

Signed-off-by: Brian Bunker brian@purestorage.com
---
 libmultipath/checkers/tur.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 551dc4f0..fff7987b 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -179,10 +179,11 @@ retry:
                else if (key == 0x2) {
                        /* Not Ready */
                        /* Note: Other ALUA states are either UP or DOWN */
-                       if( asc == 0x04 && ascq == 0x0b){
+                       if (asc == 0x04 &&
+                           (ascq == 0x0b || ascq == 0x0a)) {
                                /*
                                 * LOGICAL UNIT NOT ACCESSIBLE,
-                                * TARGET PORT IN STANDBY STATE
+                                * TARGET PORT IN STANDBY OR TRANSITION STATE
                                 */
                                *msgid = CHECKER_MSGID_GHOST;
                                return PATH_GHOST;
--

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

