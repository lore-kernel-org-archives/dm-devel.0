Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7790BCCA47A
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 09:50:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-ErYnC5bWOduqjcqvOuigXA-1; Tue, 14 Jun 2022 05:50:04 -0400
X-MC-Unique: ErYnC5bWOduqjcqvOuigXA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3DAA398CA65;
	Tue, 14 Jun 2022 09:50:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A100C404E4C2;
	Tue, 14 Jun 2022 09:50:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F8581947070;
	Tue, 14 Jun 2022 09:50:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A19D1947070
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Jun 2022 09:50:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23A971121319; Tue, 14 Jun 2022 09:50:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F5171121314
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:50:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02ADB811E81
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:50:01 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-aCyjsfl2Nmy4DERtoJ5QBw-1; Tue, 14 Jun 2022 05:49:59 -0400
X-MC-Unique: aCyjsfl2Nmy4DERtoJ5QBw-1
Received: from [2001:4bb8:180:36f6:1fed:6d48:cf16:d13c] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o12Ya-008Ziu-T7; Tue, 14 Jun 2022 09:09:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 14 Jun 2022 11:09:33 +0200
Message-Id: <20220614090934.570632-6-hch@lst.de>
In-Reply-To: <20220614090934.570632-1-hch@lst.de>
References: <20220614090934.570632-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH 5/6] block: fold blk_max_size_offset into
 get_max_io_size
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now that blk_max_size_offset has a single caller left, fold it into that
and clean up the naming convention for the local variables there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c      |  9 +++++++--
 include/linux/blkdev.h | 19 -------------------
 2 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 4da981efddeed..0f5f42ebd0bb0 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -166,9 +166,14 @@ static inline unsigned get_max_io_size(struct request_queue *q,
 {
 	unsigned pbs = queue_physical_block_size(q) >> SECTOR_SHIFT;
 	unsigned lbs = queue_logical_block_size(q) >> SECTOR_SHIFT;
-	unsigned max_sectors, start, end;
+	unsigned max_sectors = queue_max_sectors(q), start, end;
+
+	if (q->limits.chunk_sectors) {
+		max_sectors = min(max_sectors,
+			blk_chunk_sectors_left(bio->bi_iter.bi_sector,
+					       q->limits.chunk_sectors));
+	}
 
-	max_sectors = blk_max_size_offset(q, bio->bi_iter.bi_sector, 0);
 	start = bio->bi_iter.bi_sector & (pbs - 1);
 	end = (start + max_sectors) & ~(pbs - 1);
 	if (end > start)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e66ad451274ec..05e60ee269d91 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -944,25 +944,6 @@ static inline unsigned int blk_chunk_sectors_left(sector_t offset,
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

