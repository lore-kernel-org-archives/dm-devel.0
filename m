Return-Path: <SRS0=6M1r=LA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027DFC4743E
	for <dm-devel@archiver.kernel.org>; Sun,  6 Jun 2021 20:13:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF47E613C7
	for <dm-devel@archiver.kernel.org>; Sun,  6 Jun 2021 20:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF47E613C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623010407;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZmCo/I1yjQOVtBTQPey4IFivDm04LUr4Ouz7Xrh5gHs=;
	b=KhQizD1/SCAMl2g/sd2pymegiAEn6pXafpb2HBVgcmh7L9XzvBLe4h7AgzQ8nfIeKK8HRG
	aFoZgZmoRZfWcfBuh1eW9PpkJh6mI/d6urgLy4vE4SI9CNj8k6KehjODM0wsugORMxMEOx
	5eI4nbavGqbXE6eYoCHRNmxtvlOzkJY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-_xOHI3AzPyOWu2Uj3gqBlg-1; Sun, 06 Jun 2021 16:13:26 -0400
X-MC-Unique: _xOHI3AzPyOWu2Uj3gqBlg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2063A18766D2;
	Sun,  6 Jun 2021 20:13:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC4C15D736;
	Sun,  6 Jun 2021 20:13:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 464EE4ED79;
	Sun,  6 Jun 2021 20:13:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 156KDKL1031554 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 6 Jun 2021 16:13:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 47FA7610D0; Sun,  6 Jun 2021 20:13:20 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D01B460C04;
	Sun,  6 Jun 2021 20:13:16 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 156KDGRO028400; Sun, 6 Jun 2021 16:13:16 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 156KDGpo028396; Sun, 6 Jun 2021 16:13:16 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Sun, 6 Jun 2021 16:13:16 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2106061610240.27406@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm-writecache: commit just one block,
	not a full page
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When comitting superblock, we need to write just one block, we don't need
to write full page. Some architectures have pages larger than 4k and
committing full page is needless overhead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -532,11 +532,7 @@ static void ssd_commit_superblock(struct
 
 	region.bdev = wc->ssd_dev->bdev;
 	region.sector = 0;
-	region.count = PAGE_SIZE >> SECTOR_SHIFT;
-
-	if (unlikely(region.sector + region.count > wc->metadata_sectors))
-		region.count = wc->metadata_sectors - region.sector;
-
+	region.count = wc->block_size >> SECTOR_SHIFT;
 	region.sector += wc->start_sector;
 
 	req.bi_op = REQ_OP_WRITE;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

