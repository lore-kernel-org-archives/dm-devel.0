Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A84A4C77B7A
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 20:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685823380;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V7WToZ3UA5/qDKaRYv9qGu+PctgbENb26/5c6WTQNho=;
	b=XNDKtkhtFcbF2OeMwaEUZc3imJGi+rkLstTkK1MZtw9cAJ+MhDpjwQzzHW2Ljgkrt2GaMH
	mFLLfhsssgvl0tjw7F77tT4QKuI9tk2fpZGqzyIsgTYKpMrfrm6unvBO+2ayBaTQNdN88W
	Y23ON8tt6vvSmyY9n7JrUVy1uFL9isE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-dmc0gEJdOPip0DNAjiO2hA-1; Sat, 03 Jun 2023 16:16:17 -0400
X-MC-Unique: dmc0gEJdOPip0DNAjiO2hA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CA8C2A59548;
	Sat,  3 Jun 2023 20:16:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB0287AE4;
	Sat,  3 Jun 2023 20:16:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EF0CA19465A4;
	Sat,  3 Jun 2023 20:16:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F99919465A4
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 20:16:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1F89C1121315; Sat,  3 Jun 2023 20:16:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 187721121314
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 20:16:11 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEEFD2A59548
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 20:16:11 +0000 (UTC)
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com
 [209.85.161.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-woi_NOJLMOCCm2GMjW5ueQ-1; Sat, 03 Jun 2023 16:16:10 -0400
X-MC-Unique: woi_NOJLMOCCm2GMjW5ueQ-1
Received: by mail-oo1-f47.google.com with SMTP id
 006d021491bc7-55858c0c18fso1820510eaf.0; 
 Sat, 03 Jun 2023 13:16:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685823369; x=1688415369;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=1zT3cco/xuh2kfzadCMum+FKu8VOuTo02eN7uD0vF0k=;
 b=I+lhkWFS/H/WkpuEKe4RsWRaV4l/vKr95kQhP/ZfHOmHGij0MoOi26jVyFHq2VlQ2E
 aetGERwuLI9mIKbe6zsedGv32DHwJUYRb+T3ncAqLkQ64av/vXLeX2CjmMB7AxCKLThY
 kJxqWdvFLlB/49L1dlVGGk1Wuavae83BZOBR3YejNxjeIUcXDz2oDKClMW+bO3gS2k8W
 TRiwzIaqN2KnFVcMHjzvxKpsxFnDqFerg6XqQA90QRRKhSllrLu1OPfm9Jgyjr8XbBOj
 /4dZqMhmKzSOzUI+WmXkX9vVa9pqjQhBT4ycJ+3JRiG3okc6h5k+hA3uMOTOFktdZYDZ
 CiKA==
X-Gm-Message-State: AC+VfDwonu6vBMUmOay7og7MospdySzd6+srpSFedz5w8pTSgIW1Se9/
 8k05mg8KGgvdC8qhbs5MoO8=
X-Google-Smtp-Source: ACHHUZ6Pqa71m3t7xFZPAUuizgy240P2zusZA0nPOJq/koYCRoQYj8JEvJJPbFohV/upOzKZoDfrzQ==
X-Received: by 2002:a05:6358:cc07:b0:129:bde5:24de with SMTP id
 gx7-20020a056358cc0700b00129bde524demr82787rwb.0.1685823368750; 
 Sat, 03 Jun 2023 13:16:08 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 u7-20020a17090a1d4700b00250bf8495b3sm5001691pju.39.2023.06.03.13.16.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 03 Jun 2023 13:16:08 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sat,  3 Jun 2023 13:15:22 -0700
Message-Id: <20230603201525.9409-2-eatnumber1@gmail.com>
In-Reply-To: <20230603201525.9409-1-eatnumber1@gmail.com>
References: <ZHs2BHGBrJ-YGd-v@debian.me>
 <20230603201525.9409-1-eatnumber1@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 1/4] Fix minor grammatical error in
 dm-integrity.rst.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

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

