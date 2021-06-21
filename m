Return-Path: <SRS0=G5ov=LP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C87FC4743C
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 18:10:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E402561026
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 18:10:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E402561026
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1624299015;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=RiVfJVt4LBu6lOoAvvLcf8W90S4T265hMuqosPos7Es=;
	b=Po1D/cF7yFp7+IJGQAmm2PDocNxuKN/dSKLKHLe6PUEuwIvJhu07UZ8duaJLjvH5rAIT2H
	NsvZyjhEfhy5ZAKcbOjfTTC0IGI2oYuooqY5SABRrmjChZRUTEGsFdkydXhB25y+fVeBm2
	2s7I4JY5bsRqXC8yttnIwY+a9QCDbXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-819TgU9tM-q8341J1LD-OQ-1; Mon, 21 Jun 2021 14:10:13 -0400
X-MC-Unique: 819TgU9tM-q8341J1LD-OQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83FF547BE4;
	Mon, 21 Jun 2021 18:10:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6392D1ABE6;
	Mon, 21 Jun 2021 18:10:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D7FD64EA2A;
	Mon, 21 Jun 2021 18:09:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15LI9wiA011549 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Jun 2021 14:09:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3BDC11899A; Mon, 21 Jun 2021 18:09:58 +0000 (UTC)
Received: from leontynka.twibright.com (unknown [10.40.192.122])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 012A01893C;
	Mon, 21 Jun 2021 18:09:56 +0000 (UTC)
Received: from debian3.vm ([192.168.216.2])
	by leontynka.twibright.com with smtp (Exim 4.92)
	(envelope-from <mpatocka@redhat.com>)
	id 1lvOMr-0002wQ-As; Mon, 21 Jun 2021 20:09:54 +0200
Received: by debian3.vm (sSMTP sendmail emulation);
	Mon, 21 Jun 2021 20:09:52 +0200
Message-ID: <20210621180952.629801486@debian3.vm>
User-Agent: quilt/0.66
Date: Mon, 21 Jun 2021 20:09:02 +0200
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	msnitzer@redhat.com
References: <20210621180901.669593725@debian3.vm>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH 1/1] dm writecache: commit just one block,
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

Some architectures have pages larger than 4k and committing a full page
causes needless overhead.

Fix this by writing a single block when committing the superblock.

Writes smaller than 4k are slow on most SSDs (because the SSD performs
read-modify-write internally), so make sure that we write at least 4k.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -532,7 +532,7 @@ static void ssd_commit_superblock(struct
 
 	region.bdev = wc->ssd_dev->bdev;
 	region.sector = 0;
-	region.count = PAGE_SIZE >> SECTOR_SHIFT;
+	region.count = max(4096U, wc->block_size) >> SECTOR_SHIFT;
 
 	if (unlikely(region.sector + region.count > wc->metadata_sectors))
 		region.count = wc->metadata_sectors - region.sector;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

