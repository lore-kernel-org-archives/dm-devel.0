Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110B1C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:18:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 63489610A0
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:18:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 63489610A0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-67vY9STBNyCKWbJE38GXjw-1; Wed, 13 Oct 2021 13:18:46 -0400
X-MC-Unique: 67vY9STBNyCKWbJE38GXjw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 147B31922961;
	Wed, 13 Oct 2021 17:18:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAB2410016F7;
	Wed, 13 Oct 2021 17:18:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7C476180598A;
	Wed, 13 Oct 2021 17:18:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DHIe9c009109 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 13:18:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 25EF340CFD11; Wed, 13 Oct 2021 17:18:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20A9340CFD10
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 17:18:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08A7B899EC3
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 17:18:40 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-92-doB_cPczNnK4YElIG8lDFg-1; Wed, 13 Oct 2021 13:18:35 -0400
X-MC-Unique: doB_cPczNnK4YElIG8lDFg-1
Received: from [2001:4bb8:199:73c5:265:8549:750e:c7f7] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mahsq-007ebV-KS; Wed, 13 Oct 2021 17:17:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 13 Oct 2021 19:12:14 +0200
Message-Id: <20211013171215.1177671-6-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>
Subject: [dm-devel] [PATCH 5/6] block: fold blk_max_size_offset into
	get_max_io_size
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fold blk_max_size_offset into the only remaining user.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c      | 15 ++++++++++-----
 include/linux/blkdev.h | 19 -------------------
 2 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 3e9dde152fdcd..87ea3e7b8ad28 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -177,14 +177,19 @@ static struct bio *blk_bio_write_same_split(struct request_queue *q,
 static inline unsigned get_max_io_size(struct request_queue *q,
 				       struct bio *bio)
 {
-	unsigned sectors = blk_max_size_offset(q, bio->bi_iter.bi_sector, 0);
-	unsigned max_sectors = sectors;
 	unsigned pbs = queue_physical_block_size(q) >> SECTOR_SHIFT;
 	unsigned lbs = queue_logical_block_size(q) >> SECTOR_SHIFT;
-	unsigned start_offset = bio->bi_iter.bi_sector & (pbs - 1);
+	sector_t sector = bio->bi_iter.bi_sector;
+	unsigned start_offset = sector & (pbs - 1);
+	unsigned sectors = q->limits.max_sectors;
+	unsigned max_sectors;
+
+	if (q->limits.chunk_sectors) {
+		sectors = min(sectors, blk_chunk_sectors_left(sector,
+						q->limits.chunk_sectors));
+	}
 
-	max_sectors += start_offset;
-	max_sectors &= ~(pbs - 1);
+	max_sectors = (sectors + start_offset) & ~(pbs - 1);
 	if (max_sectors > start_offset)
 		return max_sectors - start_offset;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c6ecd996c2d46..7e6b68969cec0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -634,25 +634,6 @@ static inline unsigned int blk_chunk_sectors_left(sector_t offset,
 	return chunk_sectors - (offset & (chunk_sectors - 1));
 }
 
-/*
- * Return maximum size of a request at given offset. Only valid for
- * file system requests.
- */
-static inline unsigned int blk_max_size_offset(struct request_queue *q,
-					       sector_t offset,
-					       unsigned int chunk_sectors)
-{
-	if (!chunk_sectors) {
-		if (q->limits.chunk_sectors)
-			chunk_sectors = q->limits.chunk_sectors;
-		else
-			return q->limits.max_sectors;
-	}
-
-	return min(q->limits.max_sectors,
-			blk_chunk_sectors_left(offset, chunk_sectors));
-}
-
 /*
  * Access functions for manipulating queue properties
  */
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

