Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FEEDC77B7A
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 20:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685823394;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=z98uEeM63GWLrGzY1JeoyY/85DExrEBbTNxRGcvAgxs=;
	b=V6PagnRa5Ss8bmsc8Cl6VvuE9uL5XfHsN0YziDJ8gn7wHjc2pQgkAjW+fIJ86pCeOoPoNb
	3yI+AXi+ziqxxNt6wecpTH6Voxdyhxh3/2nM9q86lgL4/lr3ed/SLt9Twya4mIxXFDVzQ+
	4qfGi+ROV/LB0zgQbtLr+GviH9tZMOo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-UT4yWriIMxCkmghvlePGUg-1; Sat, 03 Jun 2023 16:16:31 -0400
X-MC-Unique: UT4yWriIMxCkmghvlePGUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DED73806703;
	Sat,  3 Jun 2023 20:16:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7B3721410F25;
	Sat,  3 Jun 2023 20:16:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 570D619465A0;
	Sat,  3 Jun 2023 20:16:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9F23E1946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 20:16:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 566C41410F26; Sat,  3 Jun 2023 20:16:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F3031410F25
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 20:16:28 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33B5B800159
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 20:16:28 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-pMAHV1uLPKSWN4TlO3__vw-2; Sat, 03 Jun 2023 16:16:24 -0400
X-MC-Unique: pMAHV1uLPKSWN4TlO3__vw-2
Received: by mail-pj1-f46.google.com with SMTP id
 98e67ed59e1d1-256e1d87998so2830357a91.3; 
 Sat, 03 Jun 2023 13:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685823383; x=1688415383;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=USecArDqAdgBTvEoQjoT64yfDEDUCJbu7LC23aKiJj4=;
 b=Lli8ADHTdEjHrsmRIwugbwCQ8GmQsNyc6hg2omn/7Tuu5/LR+YGUpkG6M9iT5Ykh/K
 9b10E7kV4LYfpZIdLwfiUpt82h86EFSft3o7QZ5eCrMaUGxK7D6BiBJrRknD8HeGPGKG
 QGMeoHwFfOYWTOLyfe+kqhq4CNUrrtqQgTP2OQUFPJIHiI0smxwvH30cTmjNEyEF3smh
 5LUqzbHj21W8H5Vldx0IOxxpHyhPesLJFQ+EsZo7JvedrMkdA5w1foP2Iu7lvcIDZY11
 h4CasYIJ1Pi1zA22Grd7D/Q1TaZLCuFAmKt0eC3cbdSlgORUSmxtjo2lEK7zVkkoGc99
 qGvQ==
X-Gm-Message-State: AC+VfDw98yWSk18rZ0lDBgcHVRLEAY0oXGYOlsx6is2LsRQyRrBzucLI
 1utx1YrufUyf7gRj6gmSN78=
X-Google-Smtp-Source: ACHHUZ6TB/FMxnHhq46t8yOEkGpuFky25L3vxC/WKvEbcC5vwYhyE+Il+sbHyIxtJdJ2z0yw6fe50A==
X-Received: by 2002:a17:90a:5410:b0:259:17ba:e89a with SMTP id
 z16-20020a17090a541000b0025917bae89amr1598284pjh.34.1685823382623; 
 Sat, 03 Jun 2023 13:16:22 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 u7-20020a17090a1d4700b00250bf8495b3sm5001691pju.39.2023.06.03.13.16.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 03 Jun 2023 13:16:22 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sat,  3 Jun 2023 13:15:23 -0700
Message-Id: <20230603201525.9409-3-eatnumber1@gmail.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 2/4] Documents the meaning of "buffer" in
 dm-integrity.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Russell Harmon <eatnumber1@gmail.com>
---
 .../admin-guide/device-mapper/dm-integrity.rst      | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index b2a698e955a3..31f514675809 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -38,6 +38,15 @@ the device. But it will only format the device if the superblock contains
 zeroes. If the superblock is neither valid nor zeroed, the dm-integrity
 target can't be loaded.
 
+Accesses to the on-disk metadata area containing checksums (aka tags) are
+buffered using dm-bufio. When an access to any given metadata area
+occurs, each unique metadata area gets its own buffer(s). The buffer size
+is capped at the size of the metadata area, but may be smaller, thereby
+requiring multiple buffers to represent the full metadata area. A smaller
+buffer size will produce a smaller resulting read/write operation to the
+metadata area for small reads/writes. The metadata is still read even in
+a full write to the data covered by a single buffer.
+
 To use the target for the first time:
 
 1. overwrite the superblock with zeroes
@@ -106,10 +115,6 @@ buffer_sectors:number
 	The number of sectors in one buffer. The value is rounded down to
 	a power of two.
 
-	The tag area is accessed using buffers, the buffer size is
-	configurable. The large buffer size means that the I/O size will
-	be larger, but there could be less I/Os issued.
-
 journal_watermark:number
 	The journal watermark in percents. When the size of the journal
 	exceeds this watermark, the thread that flushes the journal will
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

