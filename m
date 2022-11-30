Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4672C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669816390;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=F3IuNKHZbBoBVdMkvsx4zGAFmLc5NoiXIN2LWuTJ2+E=;
	b=Gin2kStkxnMiR9xBlCN8ZL1Xk9PYgYQJkHVfejOP8Jo+BTx+vyDAWZLBjuPaSCvguymYLd
	7vFPnlOayLVFQDVTLSjQX4j8gUeLOOq6p0tLoO/mOOEWQKXI6HiCbVQ1cePaUE8EbNk/Vr
	AXul9os6ftIjeDWpmWZ9my6A4ycf7lc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-o6k92gaDO9WYPLH6IJIRmg-1; Wed, 30 Nov 2022 08:53:09 -0500
X-MC-Unique: o6k92gaDO9WYPLH6IJIRmg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CBE3185A7AA;
	Wed, 30 Nov 2022 13:53:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CA35B40C6EC4;
	Wed, 30 Nov 2022 13:53:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A2ED619465A0;
	Wed, 30 Nov 2022 13:53:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5122A19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 12:57:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 097192166B2D; Wed, 30 Nov 2022 12:57:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 020412166B26
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 12:57:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8C6D811E67
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 12:57:48 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-Gf7XuqBmOMukbDLcRGo-ng-1; Wed, 30 Nov 2022 07:57:47 -0500
X-MC-Unique: Gf7XuqBmOMukbDLcRGo-ng-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D6BD1B81B3A;
 Wed, 30 Nov 2022 12:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E12C433C1;
 Wed, 30 Nov 2022 12:57:44 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	kbusch@kernel.org
Date: Wed, 30 Nov 2022 07:57:42 -0500
Message-Id: <20221130125742.28337-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] Patch "dm-integrity: set dma_alignment limit in
 io_hints" has been added to the 6.0-stable tree
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm-integrity: set dma_alignment limit in io_hints

to the 6.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-set-dma_alignment-limit-in-io_hints.patch
and it can be found in the queue-6.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 665238dfe2cde01ae3e047a17b113ab2df0594ec
Author: Keith Busch <kbusch@kernel.org>
Date:   Thu Nov 10 10:45:00 2022 -0800

    dm-integrity: set dma_alignment limit in io_hints
    
    [ Upstream commit 29aa778bb66795e6a78b1c99beadc83887827868 ]
    
    This device mapper needs bio vectors to be sized and memory aligned to
    the logical block size. Set the minimum required queue limit
    accordingly.
    
    Signed-off-by: Keith Busch <kbusch@kernel.org>
    Reviewed-by: Mike Snitzer <snitzer@kernel.org>
    Link: https://lore.kernel.org/r/20221110184501.2451620-5-kbusch@meta.com
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index aaf2472df6e5..e1e7b205573f 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3370,6 +3370,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
+		limits->dma_alignment = limits->logical_block_size - 1;
 	}
 }
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

