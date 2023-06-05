Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6490AC7EE24
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 05:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685941789;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=o4SND51TKg/OiBln1BaygatkoslApX+ISwTlTOqyarM=;
	b=ADaUXLZNoLCoY7uLNeZj2lGNlqKU74eRO73n0bsNanzB8dmn2X/WlTTNMfxSfriAeh6OTH
	AOeVHvkJk2OcdZHDOV9STju4XCbQziuZ91WFIsRY0d1PzJbR0kiBNSkMnvKjeNXNuwYiQ9
	HPdp4uiNssuI+xRWg6XG+dzBrEVOO1s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-8rtww7WeNTqtGaFqnnjFvw-1; Mon, 05 Jun 2023 01:09:48 -0400
X-MC-Unique: 8rtww7WeNTqtGaFqnnjFvw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 512923C0011E;
	Mon,  5 Jun 2023 05:09:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F22740C6EC4;
	Mon,  5 Jun 2023 05:09:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2B8EA19465A0;
	Mon,  5 Jun 2023 05:09:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A1DF1946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 05:09:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 241741410F26; Mon,  5 Jun 2023 05:09:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C6CB1410F25
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:09:32 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40BB73C00126
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:09:32 +0000 (UTC)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com
 [209.85.210.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-5CJ0oV3nOK6iOVGRoZkWUw-1; Mon, 05 Jun 2023 01:09:21 -0400
X-MC-Unique: 5CJ0oV3nOK6iOVGRoZkWUw-1
Received: by mail-ot1-f44.google.com with SMTP id
 46e09a7af769-6b1576c2f6eso1299634a34.3; 
 Sun, 04 Jun 2023 22:09:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685941760; x=1688533760;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=GG3Hy7n4oCrePrc6XsNght2qZ/b76zbKsk6sMW+iZsQ=;
 b=QS5zX22nCtCGdxhMdRmUW39ecNDDnu4FCXZKvswa4nUnvATeqBS7HPkzce4gxR5+y6
 57I0G0IJxjiM3836B4VPDeNEmDet9axsu2492C63BQrUSKfoglrX6l8nQXuUeKsBPPdk
 pUBDfn7VkRk74l1biRpTVSIUxD/L1LA1dVrtRrLaVyM1932ONvx0cQNHYrOnc+7Ps88f
 pq9n11/F0vQM98k8Udwo1sGwjIISVDodouFP/KkJMghqOwE8Dzd6iihXmxrRiFVRH+5+
 JtdoVVx/bdnCIjQ/jb3LWdNNGm7/OwY2dxrqiXfSZW05Kfx1J+E64627uwO3I7T0nbIK
 d7Sw==
X-Gm-Message-State: AC+VfDzmBF+qUC307ZDfS6Q3bzaxU1Aj9vlWHgH2MH57XmG53aRpfvqW
 ocnHFIUWSJ+P2Wr2D0V2Gc8=
X-Google-Smtp-Source: ACHHUZ5IksPmLdXJYPvgF7U10QpfFiuI+Z8wHDNCgr5a5dvTWdfTByxfpZXQsZ1UjGiyjEm9wfzJOw==
X-Received: by 2002:a9d:6d0a:0:b0:6aa:d278:24e5 with SMTP id
 o10-20020a9d6d0a000000b006aad27824e5mr9331828otp.14.1685941760359; 
 Sun, 04 Jun 2023 22:09:20 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 fe16-20020a056a002f1000b0064d48d98260sm4329175pfb.156.2023.06.04.22.09.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 22:09:20 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sun,  4 Jun 2023 22:08:50 -0700
Message-Id: <20230605050853.6240-2-eatnumber1@gmail.com>
In-Reply-To: <20230605050853.6240-1-eatnumber1@gmail.com>
References: <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230605050853.6240-1-eatnumber1@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v4 1/4] Documentation: dm-integrity: Fix minor
 grammatical error.
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
Cc: Russell Harmon <eatnumber1@gmail.com>, dm-devel@redhat.com,
 mpatocka@redhat.com, snitzer@redhat.com, linux-doc@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

"where dm-integrity uses bitmap" becomes "where dm-integrity uses a
bitmap"

Signed-off-by: Russell Harmon <eatnumber1@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-integrity.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index 8db172efa272..b2a698e955a3 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -25,7 +25,7 @@ mode it calculates and verifies the integrity tag internally. In this
 mode, the dm-integrity target can be used to detect silent data
 corruption on the disk or in the I/O path.
 
-There's an alternate mode of operation where dm-integrity uses bitmap
+There's an alternate mode of operation where dm-integrity uses a bitmap
 instead of a journal. If a bit in the bitmap is 1, the corresponding
 region's data and integrity tags are not synchronized - if the machine
 crashes, the unsynchronized regions will be recalculated. The bitmap mode
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

