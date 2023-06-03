Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27772C7EE24
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 20:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685823406;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=srYWc2uqbffqne4vU+u7WGiQhuXR5Ihk4HiU1ut6kS8=;
	b=F8N56rkuSdKhI5ta19onzv23ydM0CcW9iiRwcVu1bnRu2HFqEZSSmJ1ZcZCGgL2NMKbTlL
	Hqub+p2QiPjCAsVgl/kTIz7QWw16O543GTuFREPiED2IXCAWN3cCoS4GOheB8EmnCq1mxO
	eq7Zq1v5KjRu6dK6CE/BrnmJdg7zHwQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-SXvkA1UdMSyj7Lqh-eqeiA-1; Sat, 03 Jun 2023 16:16:35 -0400
X-MC-Unique: SXvkA1UdMSyj7Lqh-eqeiA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC50B3806703;
	Sat,  3 Jun 2023 20:16:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C849C40CFD16;
	Sat,  3 Jun 2023 20:16:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 849D019465A0;
	Sat,  3 Jun 2023 20:16:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E93841946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 20:16:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D7CD140CFD17; Sat,  3 Jun 2023 20:16:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D020740CFD16
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 20:16:31 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B57BE101A531
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 20:16:31 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-ilyrYTpnNHa6E1P3ygTakA-1; Sat, 03 Jun 2023 16:16:30 -0400
X-MC-Unique: ilyrYTpnNHa6E1P3ygTakA-1
Received: by mail-pj1-f54.google.com with SMTP id
 98e67ed59e1d1-2563a4b6285so1582363a91.2; 
 Sat, 03 Jun 2023 13:16:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685823388; x=1688415388;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=JV27aquw/ZAgJlQRmYYQBIObAUSulk0jluLIU1m6Gg4=;
 b=W4lX9afjDTu801/DDzPOITWN/NBkhNu8S5Jo/grWOUu/RLUxcr7C5MLNH/NJEA/tl+
 A62tRzIaBo4wHPwtOfy7cx+Fo6/kOhbRJiCop6eTj0K2FsYJ5fDMnCgd4Sn8DOeRvtSo
 SrthxwkbbUuKwCYu/MnTvwmlmo1E3JxJispZMfSnWxdOUMDKWqdO2yBtPv2Qt6gGCh1O
 dUaS4tC/CYURzZKwL/pIJ8tabxoPBFYtSaI8V3b9gEAjfsgYp5f10XPcc4TPJiDcdfpf
 u9h86d/aA4wxpBsK4PpvcaFVUaKgj8HdD0h0S9pwdsKljfeD0lE79AiR1NiiNEUeToRu
 nloA==
X-Gm-Message-State: AC+VfDy28663PcfBRuifrBNNezZe3LVen6QWwBP86lVOKfAdSKKETA+k
 sPLDP3a3qe9q9KYrSaPz54w=
X-Google-Smtp-Source: ACHHUZ41mu44z+deph4NvL04rLUcVW4YDy9nmQXE5DlaMO6uQEDuzbgKGhztQCtokHlr1aeOyG/Mpg==
X-Received: by 2002:a17:90a:fb52:b0:255:54ce:c3a9 with SMTP id
 iq18-20020a17090afb5200b0025554cec3a9mr1882850pjb.24.1685823388153; 
 Sat, 03 Jun 2023 13:16:28 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 u7-20020a17090a1d4700b00250bf8495b3sm5001691pju.39.2023.06.03.13.16.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 03 Jun 2023 13:16:27 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sat,  3 Jun 2023 13:15:24 -0700
Message-Id: <20230603201525.9409-4-eatnumber1@gmail.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 3/4] Document dm-integrity default values.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

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

