Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC67C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:36:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2000C64DA1
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:36:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2000C64DA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-LwRWuCxNMEiMHEKjMbmGMw-1; Wed, 17 Feb 2021 10:36:09 -0500
X-MC-Unique: LwRWuCxNMEiMHEKjMbmGMw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 761BC79EC2;
	Wed, 17 Feb 2021 15:36:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 547A36E403;
	Wed, 17 Feb 2021 15:36:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1E6D81809C8F;
	Wed, 17 Feb 2021 15:36:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1188r4lY030097 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 03:53:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CFF901730C; Mon,  8 Feb 2021 08:53:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAAA910EB1
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 08:53:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA393185A78E
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 08:53:01 +0000 (UTC)
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-151-EhhxP1SkPsWbdLBLGIQ5KA-1;
	Mon, 08 Feb 2021 03:52:58 -0500
X-MC-Unique: EhhxP1SkPsWbdLBLGIQ5KA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R521e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UO9kQj0_1612774374
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UO9kQj0_1612774374) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 08 Feb 2021 16:52:55 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com, axboe@kernel.dk
Date: Mon,  8 Feb 2021 16:52:42 +0800
Message-Id: <20210208085243.82367-11-jefflexu@linux.alibaba.com>
In-Reply-To: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: caspar@linux.alibaba.com, hch@lst.de, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: [dm-devel] [PATCH v3 10/11] nvme/pci: don't wait for locked polling
	queue
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There's no sense waiting for the hw queue when it currently has been
locked by another polling instance. The polling instance currently
occupying the hw queue will help reap the completion events.

It shall be safe to surrender the hw queue, as long as we could reapply
for polling later. For Synchronous polling, blk_poll() will reapply for
polling, since @spin is always True in this case. While For asynchronous
polling, i.e. io_uring itself will reapply for polling when the previous
polling returns 0.

Besides, it shall do no harm to the polling performance of mq devices.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/nvme/host/pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 81e6389b2042..db164fcd04e2 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1106,7 +1106,9 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx)
 	if (!nvme_cqe_pending(nvmeq))
 		return 0;
 
-	spin_lock(&nvmeq->cq_poll_lock);
+	if (!spin_trylock(&nvmeq->cq_poll_lock))
+		return 0;
+
 	found = nvme_process_cq(nvmeq);
 	spin_unlock(&nvmeq->cq_poll_lock);
 
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

