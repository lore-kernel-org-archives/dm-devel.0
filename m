Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53BF0C77B73
	for <dm-devel@archiver.kernel.org>; Sun,  4 Jun 2023 19:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685905616;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j//2OkyZMgk8noe2A5sbTl1AyItOb+00ukembn5mQro=;
	b=a45zY2goHpG+5gzKkvVswQB5yxi9Tu3wc2x9Yqw1nRL4QTEn/ok6dI8BchaUk6G+tbEsp8
	fj7Ge9YYt3X+nKacpWthJEWtaBGtC2m53WQmHxpTwFYYin//8GE/3F8CBDy9QTy9J22tlp
	uZCCURhJs43JBNflaYorc8//rZfao8A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-PRCV_ZLmM0-FgmzEqqewsw-1; Sun, 04 Jun 2023 15:06:53 -0400
X-MC-Unique: PRCV_ZLmM0-FgmzEqqewsw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A7CA2A5954D;
	Sun,  4 Jun 2023 19:06:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 763E4400F5F;
	Sun,  4 Jun 2023 19:06:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 457DD19465A8;
	Sun,  4 Jun 2023 19:06:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0DFF119465B1
 for <dm-devel@listman.corp.redhat.com>; Sun,  4 Jun 2023 19:06:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E58C240C6CD7; Sun,  4 Jun 2023 19:06:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DD7F840C6EC4
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 19:06:49 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C146B8007D9
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 19:06:49 +0000 (UTC)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-s9Rxz0-cOgOwyna0KG12bQ-1; Sun, 04 Jun 2023 15:06:48 -0400
X-MC-Unique: s9Rxz0-cOgOwyna0KG12bQ-1
Received: by mail-pl1-f174.google.com with SMTP id
 d9443c01a7336-1b00ecabdf2so37938615ad.2; 
 Sun, 04 Jun 2023 12:06:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685905607; x=1688497607;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=v181M03vb06+Rh0AY4HYkr+GW7+0CiOJfqvRtVjcRHc=;
 b=FuWPdqapdz57L+YmJQTHSLV53XAKTaksqhELCodjM+hp10VHEuL8KsmvHWPiCTvQ8M
 UaM65z+r9DDjcdpcU/EXt7k9WgRZ1pAJC5IzBLvrnB9lyBn8ws5kMFOsZnzJzC1P8Zmn
 9rkp3wKLu8xCXQnoV7/wtm6t4YEpI+ewIliQ0Y3Q28jmAvDyuxibS9/xeWu/5HB2evr5
 9qtEKXc+LLucunUcGbGKXEzxi15HigN1j7AIAPTXhCTF9DiX6PZ5uWYcqSIEGC1gPqQZ
 3leD58+rkDgXfh9qJ330wBW2Y8z/XmgvvzFyz/sIU01yrWZDA8IYFhzetSPRfYI6lFFg
 FdKA==
X-Gm-Message-State: AC+VfDzYsejegkIS6kDxPfEp8oYTJfb89yr09WE91xZi282zA0QuIJ7A
 SutQE8ojro5oOKcxRdi+kxI=
X-Google-Smtp-Source: ACHHUZ5PaUHC2vpAgmMHxRGyYeYhLLkOMZR+zE4hr51QE2B05P+PbgCO49FoubrAf77Mk/I0L7tBSQ==
X-Received: by 2002:a17:903:24e:b0:1af:e8cf:7004 with SMTP id
 j14-20020a170903024e00b001afe8cf7004mr6534147plh.15.1685905606456; 
 Sun, 04 Jun 2023 12:06:46 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 m8-20020a170902db0800b001a6ed2d0ef8sm4979072plx.273.2023.06.04.12.06.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 12:06:46 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sun,  4 Jun 2023 12:06:03 -0700
Message-Id: <20230604190604.4800-4-eatnumber1@gmail.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v3 3/4] Document dm-integrity default values.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Specifically:
  interleave_sectors = 32768
  buffer_sectors = 128
  block_size = 512
  journal_watermark = 50
  commit_time = 10000

Signed-off-by: Russell Harmon <eatnumber1@gmail.com>
---
 .../device-mapper/dm-integrity.rst            | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index 31f514675809..0241457c0027 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -102,7 +102,7 @@ journal_sectors:number
 	device. If the device is already formatted, the value from the
 	superblock is used.
 
-interleave_sectors:number
+interleave_sectors:number (default 32768)
 	The number of interleaved sectors. This values is rounded down to
 	a power of two. If the device is already formatted, the value from
 	the superblock is used.
@@ -111,16 +111,16 @@ meta_device:device
 	Don't interleave the data and metadata on the device. Use a
 	separate device for metadata.
 
-buffer_sectors:number
-	The number of sectors in one buffer. The value is rounded down to
-	a power of two.
+buffer_sectors:number (default 128)
+	The number of sectors in one metadata buffer. The value is rounded
+	down to a power of two.
 
-journal_watermark:number
+journal_watermark:number (default 50)
 	The journal watermark in percents. When the size of the journal
 	exceeds this watermark, the thread that flushes the journal will
 	be started.
 
-commit_time:number
+commit_time:number (default 10000)
 	Commit time in milliseconds. When this time passes, the journal is
 	written. The journal is also written immediately if the FLUSH
 	request is received.
@@ -168,11 +168,10 @@ journal_mac:algorithm(:key)	(the key is optional)
 	the journal. Thus, modified sector number would be detected at
 	this stage.
 
-block_size:number
-	The size of a data block in bytes.  The larger the block size the
+block_size:number (default 512)
+	The size of a data block in bytes. The larger the block size the
 	less overhead there is for per-block integrity metadata.
-	Supported values are 512, 1024, 2048 and 4096 bytes.  If not
-	specified the default block size is 512 bytes.
+	Supported values are 512, 1024, 2048 and 4096 bytes.
 
 sectors_per_bit:number
 	In the bitmap mode, this parameter specifies the number of
@@ -291,7 +290,8 @@ The layout of the formatted block device:
     Each run contains:
 
 	* tag area - it contains integrity tags. There is one tag for each
-	  sector in the data area
+	  sector in the data area. The size of this area is always 4KiB or
+	  greater.
 	* data area - it contains data sectors. The number of data sectors
 	  in one run must be a power of two. log2 of this value is stored
 	  in the superblock.
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

