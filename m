Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA55C7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480335;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hLoiCuaOU3slso+vdQHo1FjcqOEre+Qmndpvm132UL4=;
	b=OoNB/jSyNG4ifwSIsPzHapLLaJ2P0vra3C3vZkSt7ERaZcjufTuz4aREPBjrIvnIc4QVmr
	5Xk3SsgOKiSicV7r5rBqTgrlZ5SX5Bbtl7ZY8Dbo36nYNbXnWxqHpzc+ddPN4ThfW9Plvh
	NZHCIqI140t2gUeBCxKPQLkFZVsXiIY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-I3m95H7WO3GxVqW4zplQ3Q-1; Tue, 30 May 2023 16:58:51 -0400
X-MC-Unique: I3m95H7WO3GxVqW4zplQ3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07AE485A5AA;
	Tue, 30 May 2023 20:58:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B2473C0448F;
	Tue, 30 May 2023 20:58:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9148719465A0;
	Tue, 30 May 2023 20:58:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 95AE0194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 00:20:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E8F420296C8; Tue, 30 May 2023 00:20:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 55BE520296C6
 for <dm-devel@redhat.com>; Tue, 30 May 2023 00:20:57 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36E4B811E78
 for <dm-devel@redhat.com>; Tue, 30 May 2023 00:20:57 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-5MO5U6WeOHKmSxdDvZLkkg-1; Mon, 29 May 2023 20:20:51 -0400
X-MC-Unique: 5MO5U6WeOHKmSxdDvZLkkg-1
Received: by mail-pl1-f182.google.com with SMTP id
 d9443c01a7336-1b034ca1195so12714445ad.2; 
 Mon, 29 May 2023 17:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685406049; x=1687998049;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=/NF2aPP0D8BvSL9lGQzSeSkCmVZlO98Ug44UgsXpd+0=;
 b=TF6onFL+D0aZuWqnGumiF6leZBMVu5lIRIOZfzbD5J+L2LhjqxLdFwSIYL9VjzDMsw
 /T/MNFRmSsV0XAZOyjv/1ba0hjMlCtEw9Sh8FIyT1BM0mPUBWXoN0hEoCohyAGyESLCe
 YauWPwP1fQBuJWSBtBuKNpR5M8U++K1NmqHxITJGTQzyoLTOEb1G93+WWow4gffyh+ra
 pinQt41p7qfqACntQ8nd4uByIU66+BdGfAOBkTw0KnMoxDHusx6v3Na3SUeQDyZSbJCX
 sup1yzfJ0+QUPVx2HtlWdi2W9IJNsnITf7E1jBedFcBC4kjpY/LoeJLQjXiM4FsgqGUh
 K41A==
X-Gm-Message-State: AC+VfDwu2ml1I26UYacSpoXVmThrpvUWAoDDJkkXCpudfVBUOuk7S1wQ
 D3xrNDRhKfFCquCpn4TW2T/rje4iuhaQjA==
X-Google-Smtp-Source: ACHHUZ61cyoiq1wUcZ3LyKk4WhTEeI7/kAsUjcfYvbfIuWeqQuFs6skkg/Ui+1GOWKCpizXfaGWUoA==
X-Received: by 2002:a17:902:c44b:b0:1af:b681:5313 with SMTP id
 m11-20020a170902c44b00b001afb6815313mr611964plm.33.1685406049120; 
 Mon, 29 May 2023 17:20:49 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 w22-20020a170902a71600b001b024ee5f6esm5337280plq.81.2023.05.29.17.20.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 29 May 2023 17:20:48 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: mpatocka@redhat.com,
	snitzer@redhat.com,
	dm-devel@redhat.com
Date: Mon, 29 May 2023 17:20:32 -0700
Message-Id: <20230530002032.15227-1-eatnumber1@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 30 May 2023 20:58:47 +0000
Subject: [dm-devel] [PATCH] Improve the dm-integrity documentation.
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
Cc: Russell Harmon <eatnumber1@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Documents the meaning of the "buffer", adds documentation of the current
defaults, and provides an example of how the tunables relate to each
other.

Signed-off-by: Russell Harmon <eatnumber1@gmail.com>
---
 .../device-mapper/dm-integrity.rst            | 44 ++++++++++++-------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index 8db172efa272..634a780d7c51 100644
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
@@ -38,6 +38,15 @@ the device. But it will only format the device if the superblock contains
 zeroes. If the superblock is neither valid nor zeroed, the dm-integrity
 target can't be loaded.
 
+Accesses to the on-disk metadata area containing checksums (aka tags) is
+buffered using dm-bufio. When an access to any given metadata area
+occurs, each unique metadata area gets its own buffer(s). The buffer size
+is capped at the size of the metadata area, but may be smaller, thereby
+requiring multiple buffers to represent the full metadata area. A smaller
+buffer size will produce a smaller resulting read/write operation to the
+metadata area for small reads/writes. A full write to the data covered by
+a single buffer does *not* skip the read of the metadata.
+
 To use the target for the first time:
 
 1. overwrite the superblock with zeroes
@@ -93,7 +102,7 @@ journal_sectors:number
 	device. If the device is already formatted, the value from the
 	superblock is used.
 
-interleave_sectors:number
+interleave_sectors:number (default 32768)
 	The number of interleaved sectors. This values is rounded down to
 	a power of two. If the device is already formatted, the value from
 	the superblock is used.
@@ -102,20 +111,16 @@ meta_device:device
 	Don't interleave the data and metadata on the device. Use a
 	separate device for metadata.
 
-buffer_sectors:number
-	The number of sectors in one buffer. The value is rounded down to
-	a power of two.
+buffer_sectors:number (default 128)
+	The number of sectors in one metadata buffer. The value is rounded
+	down to a power of two.
 
-	The tag area is accessed using buffers, the buffer size is
-	configurable. The large buffer size means that the I/O size will
-	be larger, but there could be less I/Os issued.
-
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
@@ -163,11 +168,10 @@ journal_mac:algorithm(:key)	(the key is optional)
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
@@ -209,6 +213,12 @@ table and swap the tables with suspend and resume). The other arguments
 should not be changed when reloading the target because the layout of disk
 data depend on them and the reloaded target would be non-functional.
 
+For example, on a device using the default interleave_sectors of 32768, a
+block_size of 512, and an internal_hash of crc32c with a tag size of 4
+bytes, it will take 128 KiB of tags to track a full data area, requiring
+256 sectors of metadata per data area. With the default buffer_sectors of
+128, that means there will be 2 buffers per metadata area, or 2 buffers
+per 16 MiB of data.
 
 Status line:
 
@@ -285,8 +295,8 @@ The layout of the formatted block device:
 * one or more runs of interleaved tags and data.
     Each run contains:
 
-	* tag area - it contains integrity tags. There is one tag for each
-	  sector in the data area
+	* tag area - it contains integrity tags. There is one tag for each sector in
+	  the data area. The size of this area is always 4KiB or greater.
 	* data area - it contains data sectors. The number of data sectors
 	  in one run must be a power of two. log2 of this value is stored
 	  in the superblock.
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

