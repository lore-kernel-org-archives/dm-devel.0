Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F24C9C636CC
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 08:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675152214;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QkFRzErIb4Mchx6NTcJLa1Ez5LOhFisD4fjCi3p7dYA=;
	b=PBfmty4IOYGGTNn1w1oW1ZpK2QY4l80qG111lPksLiS8ROUMx0M2OfveAJBAcN89CmpOkc
	Bh9AwmCYMlQ3dYN+O2qe03QJXeSyEG1YUXgaLT+4tenPQ0r2dTbAqVHBcCPlKp5+s3IhdI
	Nm4vm09rRHUymJ6pNde4Cre77PE9bkU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-dfjUzECUPumMvn0kObM6yQ-1; Tue, 31 Jan 2023 03:03:30 -0500
X-MC-Unique: dfjUzECUPumMvn0kObM6yQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63C61885626;
	Tue, 31 Jan 2023 08:03:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16050422FE;
	Tue, 31 Jan 2023 08:03:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7BFEF1946589;
	Tue, 31 Jan 2023 08:03:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7BFE01946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 06:15:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5BF2CC15BAE; Tue, 31 Jan 2023 06:15:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5488BC15BAD
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 06:15:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3834129AA385
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 06:15:56 +0000 (UTC)
Received: from out30-124.freemail.mail.aliyun.com
 (out30-124.freemail.mail.aliyun.com [115.124.30.124]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256)
 id us-mta-321-zfnBvqV-NWGn-f857Alwjw-1; Tue, 31 Jan 2023 01:15:51 -0500
X-MC-Unique: zfnBvqV-NWGn-f857Alwjw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R211e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045170;
 MF=jiapeng.chong@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0VaVVaz._1675145432
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com
 fp:SMTPD_---0VaVVaz._1675145432) by smtp.aliyun-inc.com;
 Tue, 31 Jan 2023 14:10:44 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: agk@redhat.com
Date: Tue, 31 Jan 2023 14:09:41 +0800
Message-Id: <20230131060941.36690-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Tue, 31 Jan 2023 07:47:17 +0000
Subject: [dm-devel] [PATCH] dm integrity: Remove the unused variable
 bi_sector
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
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, dm-devel@redhat.com,
 Abaci Robot <abaci@linux.alibaba.com>, snitzer@kernel.org,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Variable bi_sector is not effectively used, so delete it.

drivers/md/dm-integrity.c:1738:13: warning: variable 'bi_sector' set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3895
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/md/dm-integrity.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 1388ee35571e..c62c21aadf32 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1735,7 +1735,6 @@ static void integrity_metadata(struct work_struct *w)
 		}
 
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
-			sector_t bi_sector = dio->bio_details.bi_iter.bi_sector;
 			unsigned bi_size = dio->bio_details.bi_iter.bi_size;
 			unsigned max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
 			unsigned max_blocks = max_size / ic->tag_size;
@@ -1752,13 +1751,7 @@ static void integrity_metadata(struct work_struct *w)
 					goto error;
 				}
 
-				/*if (bi_size < this_step_blocks << (SECTOR_SHIFT + ic->sb->log2_sectors_per_block)) {
-					printk("BUGG: bi_sector: %llx, bi_size: %u\n", bi_sector, bi_size);
-					printk("BUGG: this_step_blocks: %u\n", this_step_blocks);
-					BUG();
-				}*/
 				bi_size -= this_step_blocks << (SECTOR_SHIFT + ic->sb->log2_sectors_per_block);
-				bi_sector += this_step_blocks << ic->sb->log2_sectors_per_block;
 			}
 
 			if (likely(checksums != checksums_onstack))
-- 
2.20.1.7.g153144c

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

