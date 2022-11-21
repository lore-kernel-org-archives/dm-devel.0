Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D233C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 21 Nov 2022 05:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669007364;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GnSrwM4qFvrWndyKwusLRPYqkrvqTOUMe9iK1wS9fhc=;
	b=VzvJYCMapj+g/v5JZAt7y8MUbWnYW9BPEyoAPkjTVtM5CF9zKW3zVsi64CRKpIlpVVSGHM
	bee1iy6SPeEgRn6ZGrcAznd5y9PWfhrzr5Xo9deOac0HkIINCa3rCFjpFWEsx0A2ev1nUD
	oI2J4U/t10w9YFiiy12CSnsD9OJCMbY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-TqWZzM3SNgqCmqunWc_ukA-1; Mon, 21 Nov 2022 00:09:20 -0500
X-MC-Unique: TqWZzM3SNgqCmqunWc_ukA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62B49811E67;
	Mon, 21 Nov 2022 05:09:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C0CF8140EBF5;
	Mon, 21 Nov 2022 05:09:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9518E1946588;
	Mon, 21 Nov 2022 05:09:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 01F051946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 21 Nov 2022 05:09:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BBE61111E41D; Mon, 21 Nov 2022 05:09:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B444C111E403
 for <dm-devel@redhat.com>; Mon, 21 Nov 2022 05:09:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92E80811E67
 for <dm-devel@redhat.com>; Mon, 21 Nov 2022 05:09:11 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-fIxbah90P6GFGaec8f_fGg-1; Mon, 21 Nov 2022 00:09:07 -0500
X-MC-Unique: fIxbah90P6GFGaec8f_fGg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 21BFBB80D3C;
 Mon, 21 Nov 2022 05:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87804C433D6;
 Mon, 21 Nov 2022 05:09:03 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	kbusch@kernel.org
Date: Mon, 21 Nov 2022 00:09:01 -0500
Message-Id: <20221121050901.2600600-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] Patch "dm-crypt: provide dma_alignment limit in
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm-crypt: provide dma_alignment limit in io_hints

to the 6.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-crypt-provide-dma_alignment-limit-in-io_hints.patch
and it can be found in the queue-6.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit e6bb09b02e87cbde45c6d2692fb710579a08c366
Author: Keith Busch <kbusch@kernel.org>
Date:   Thu Nov 10 10:44:58 2022 -0800

    dm-crypt: provide dma_alignment limit in io_hints
    
    [ Upstream commit 86e4d3e8d1838ca88fb9267e669c36f6c8f7c6cd ]
    
    This device mapper needs bio vectors to be sized and memory aligned to
    the logical block size. Set the minimum required queue limit
    accordingly.
    
    Link: https://lore.kernel.org/linux-block/20221101001558.648ee024@xps.demsh.org/
    Fixes: b1a000d3b8ec5 ("block: relax direct io memory alignment")
    Reportred-by: Eric Biggers <ebiggers@kernel.org>
    Reported-by: Dmitrii Tcvetkov <me@demsh.org>
    Signed-off-by: Keith Busch <kbusch@kernel.org>
    Reviewed-by: Mike Snitzer <snitzer@kernel.org>
    Link: https://lore.kernel.org/r/20221110184501.2451620-3-kbusch@meta.com
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 159c6806c19b..2653516bcdef 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3630,6 +3630,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->physical_block_size =
 		max_t(unsigned, limits->physical_block_size, cc->sector_size);
 	limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 static struct target_type crypt_target = {

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

