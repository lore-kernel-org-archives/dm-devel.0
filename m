Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FDBBC7EE2A
	for <dm-devel@archiver.kernel.org>; Sun,  4 Jun 2023 19:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685905618;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dpQp8ehsea7FAw2fd+cmvDFhjFCOpx8Xw0M3uM4Q3FY=;
	b=FFZeSkZVASu0UlqUHJ96y6NZu8R9EagvLPQEBPinKBK/vErrg0u9Krpbkgyr2RBorm0qRi
	yHUrpQ57ak6drdrjf5+QzjqJjgaxZJmuTHztmKO2XgCRvIOTJTCxnUk2WaZ1LvaTZg0+RX
	A2oN6FGB05G48jvUM+D2sLOvhgky5SY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-6hR1Cc_iMAClrbI2-c40Zw-1; Sun, 04 Jun 2023 15:06:55 -0400
X-MC-Unique: 6hR1Cc_iMAClrbI2-c40Zw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B85D185A78B;
	Sun,  4 Jun 2023 19:06:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2AB4E2026D49;
	Sun,  4 Jun 2023 19:06:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F2E1F19465A0;
	Sun,  4 Jun 2023 19:06:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D60801946595
 for <dm-devel@listman.corp.redhat.com>; Sun,  4 Jun 2023 19:06:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B7E6240102C; Sun,  4 Jun 2023 19:06:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF59E400F16
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 19:06:51 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FDB62A59550
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 19:06:51 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-158-g-WMzOIsONahM6Mffj0XuQ-1; Sun, 04 Jun 2023 15:06:49 -0400
X-MC-Unique: g-WMzOIsONahM6Mffj0XuQ-1
Received: by mail-pf1-f181.google.com with SMTP id
 d2e1a72fcca58-6537d2a8c20so1380863b3a.2; 
 Sun, 04 Jun 2023 12:06:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685905608; x=1688497608;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=iKFRG4sLddr5jyH4jgTyfJ4yjF3tqwuDIQl2XFzUyrU=;
 b=jTgA50a/astaEzzEx4i2hMiZ+1Vx5/tIpaRNl/GGRfDU9Sui4OEop6F/cEH9rYm6aX
 wD8BPcfrOP6qbQZPPt4zwjl8t3TYPcyFOnh87iQoNdYz50mrKhYivqbSHxV3UU87yj+6
 RL2ZXaNQ/9y3kIOGjSKnFKucn4Xm2ZlQxLsxBGFkX23tb7g8FXmFS9AsRAwiT95EWEPs
 w8z2dM3fVySK4bW5EmiV7DG/12/SYpxNR5NUydcaoeCLhP3i8AgvjGtj6RyRJAFaq686
 tOFyCZdMLHb/WgxZZvo/6smm2IfCMa7yW0VJ2PT/JNBsgorSlULdDLzFcyEdMU0p6+VL
 luOw==
X-Gm-Message-State: AC+VfDwmxCud2Udy1AihEq7YP4kK6RBn7CYZmkDfYUxQS5waSyGiVPBt
 Riz6EyVw1Q79N0rUL8Q71cn0FyoM9js/5Q==
X-Google-Smtp-Source: ACHHUZ7cDgIjV0oILt0pZVD+r4aDxwUFJD0QMvse+QGJquJ/eroO8Pk1b3XFDfgRAeWKntRV/xdXLA==
X-Received: by 2002:a05:6a20:1450:b0:110:9b0b:71ab with SMTP id
 a16-20020a056a20145000b001109b0b71abmr2574568pzi.40.1685905607854; 
 Sun, 04 Jun 2023 12:06:47 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 m8-20020a170902db0800b001a6ed2d0ef8sm4979072plx.273.2023.06.04.12.06.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 12:06:47 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sun,  4 Jun 2023 12:06:04 -0700
Message-Id: <20230604190604.4800-5-eatnumber1@gmail.com>
In-Reply-To: <20230604190604.4800-1-eatnumber1@gmail.com>
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v3 4/4] Document an example of how the tunables
 relate in dm-integrity.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For example, on a device using the default interleave_sectors of 32768, a
block_size of 512, and an internal_hash of crc32c with a tag size of 4
bytes, it will take 128 KiB of tags to track a full data area, requiring
256 sectors of metadata per data area. With the default buffer_sectors of
128, that means there will be 2 buffers per metadata area, or 2 buffers
per 16 MiB of data.

Signed-off-by: Russell Harmon <eatnumber1@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-integrity.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index 0241457c0027..d8a5f14d0e3c 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -213,6 +213,12 @@ table and swap the tables with suspend and resume). The other arguments
 should not be changed when reloading the target because the layout of disk
 data depend on them and the reloaded target would be non-functional.
 
+For example, on a device using the default interleave_sectors of 32768, a
+block_size of 512, and an internal_hash of crc32c with a tag size of 4
+bytes, it will take 128 KiB of tags to track a full data area, requiring
+256 sectors of metadata per data area. With the default buffer_sectors of
+128, that means there will be 2 buffers per metadata area, or 2 buffers
+per 16 MiB of data.
 
 Status line:
 
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

