Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF5EC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:18:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9715860F21
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:18:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9715860F21
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-qIRJN85kMla-7fvQsnbWaA-1; Wed, 13 Oct 2021 13:18:01 -0400
X-MC-Unique: qIRJN85kMla-7fvQsnbWaA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53246801ADA;
	Wed, 13 Oct 2021 17:17:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 06E575C1CF;
	Wed, 13 Oct 2021 17:17:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C3B0C180598A;
	Wed, 13 Oct 2021 17:17:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DHHqMo009018 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 13:17:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4B621118637C; Wed, 13 Oct 2021 17:17:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46E9011457FB
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 17:17:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FFC3811E76
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 17:17:49 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-186-m203ODLyMqOn9XpFN8N2AQ-1; Wed, 13 Oct 2021 13:17:41 -0400
X-MC-Unique: m203ODLyMqOn9XpFN8N2AQ-1
Received: from [2001:4bb8:199:73c5:265:8549:750e:c7f7] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mahrv-007eYI-B3; Wed, 13 Oct 2021 17:17:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 13 Oct 2021 19:12:13 +0200
Message-Id: <20211013171215.1177671-5-hch@lst.de>
In-Reply-To: <20211013171215.1177671-1-hch@lst.de>
References: <20211013171215.1177671-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>
Subject: [dm-devel] [PATCH 4/6] block: open code blk_max_size_offset in
	blk_rq_get_max_sectors
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

blk_rq_get_max_sectors always uses q->limits.chunk_sectors as the
chunk_sectors argument, and already checks for max_sectors through the
call to blk_queue_get_max_sectors.  That means much of
blk_max_size_offset is not needed and open coding it simplifies the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8ed50952e93ad..3e9dde152fdcd 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -605,8 +605,8 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 	    req_op(rq) == REQ_OP_DISCARD ||
 	    req_op(rq) == REQ_OP_SECURE_ERASE)
 		return max_sectors;
-
-	return min(max_sectors, blk_max_size_offset(q, offset, 0));
+	return min(max_sectors,
+		   blk_chunk_sectors_left(offset, q->limits.chunk_sectors));
 }
 
 static inline int ll_new_hw_segment(struct request *req, struct bio *bio,
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

