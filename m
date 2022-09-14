Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE967C6FA82
	for <dm-devel@archiver.kernel.org>; Wed, 14 Sep 2022 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663188960;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6qUO5bOGvuXECs8G84bfhNntkNeIvd7SdqU6h42NW9Q=;
	b=bEReRuyMv2GTaUhExuVsPGayxClrW+Rh7AWhTXLoe2fWFPN+MmPm9il8ZDAgZusjlS+MKj
	T/t1aBb1jPIw8p52dfZ1twSimtYnrgdCJpMp39F1usfWCDtW87ZzlDdh8PYeWwdJaVGF4J
	NY+SCSuRWt8bhPxgcBu0zfVKAroHuWg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-3OvqPs-yNian8jPcw-WuvA-1; Wed, 14 Sep 2022 16:55:57 -0400
X-MC-Unique: 3OvqPs-yNian8jPcw-WuvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E26E73C025D0;
	Wed, 14 Sep 2022 20:55:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A2952027062;
	Wed, 14 Sep 2022 20:55:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ECE161946A55;
	Wed, 14 Sep 2022 20:55:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 299081946A53
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Sep 2022 20:55:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0BCDE1121314; Wed, 14 Sep 2022 20:55:52 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D1FAE1121315;
 Wed, 14 Sep 2022 20:55:51 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 28EKtpgb014908; Wed, 14 Sep 2022 16:55:51 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 28EKtpFd014904; Wed, 14 Sep 2022 16:55:51 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Wed, 14 Sep 2022 16:55:51 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 linux-block@vger.kernel.org, dm-devel@redhat.com
Message-ID: <alpine.LRH.2.02.2209141549480.28100@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH] blk-lib: fix blkdev_issue_secure_erase
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, Chao Yu <chao@kernel.org>,
 Coly Li <colyli@suse.de>,
 =?ISO-8859-15?Q?Christoph_B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
 David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There's a bug in blkdev_issue_secure_erase. The statement
"unsigned int len = min_t(sector_t, nr_sects, max_sectors);"
sets the variable "len" to the length in sectors, but the statement
"bio->bi_iter.bi_size = len" treats it as if it were in bytes.
The statements "sector += len << SECTOR_SHIFT" and "nr_sects -= len <<
SECTOR_SHIFT" are thinko.

This patch fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v5.19
Fixes: 44abff2c0b97 ("block: decouple REQ_OP_SECURE_ERASE from REQ_OP_DISCARD")

---
 block/blk-lib.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6/block/blk-lib.c
===================================================================
--- linux-2.6.orig/block/blk-lib.c
+++ linux-2.6/block/blk-lib.c
@@ -309,6 +309,11 @@ int blkdev_issue_secure_erase(struct blo
 	struct blk_plug plug;
 	int ret = 0;
 
+	/* make sure that "len << SECTOR_SHIFT" doesn't overflow */
+	if (max_sectors > UINT_MAX >> SECTOR_SHIFT)
+		max_sectors = UINT_MAX >> SECTOR_SHIFT;
+	max_sectors &= ~bs_mask;
+
 	if (max_sectors == 0)
 		return -EOPNOTSUPP;
 	if ((sector | nr_sects) & bs_mask)
@@ -322,10 +327,10 @@ int blkdev_issue_secure_erase(struct blo
 
 		bio = blk_next_bio(bio, bdev, 0, REQ_OP_SECURE_ERASE, gfp);
 		bio->bi_iter.bi_sector = sector;
-		bio->bi_iter.bi_size = len;
+		bio->bi_iter.bi_size = len << SECTOR_SHIFT;
 
-		sector += len << SECTOR_SHIFT;
-		nr_sects -= len << SECTOR_SHIFT;
+		sector += len;
+		nr_sects -= len;
 		if (!nr_sects) {
 			ret = submit_bio_wait(bio);
 			bio_put(bio);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

