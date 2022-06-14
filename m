Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43965C43334
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 09:29:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-Rdef01iEMIaHe2NgaglfnA-1; Tue, 14 Jun 2022 05:29:37 -0400
X-MC-Unique: Rdef01iEMIaHe2NgaglfnA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34FBB3800C23;
	Tue, 14 Jun 2022 09:29:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D50B0492CA2;
	Tue, 14 Jun 2022 09:29:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B01C1947070;
	Tue, 14 Jun 2022 09:29:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E7671947067
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Jun 2022 09:29:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4BB8D4010E32; Tue, 14 Jun 2022 09:29:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4762240D282F
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:29:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DF251C0513E
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:29:33 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-cypDc1QdPtqXysh90-xX3w-1; Tue, 14 Jun 2022 05:29:31 -0400
X-MC-Unique: cypDc1QdPtqXysh90-xX3w-1
Received: from [2001:4bb8:180:36f6:1fed:6d48:cf16:d13c] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o12Yd-008Zl3-In; Tue, 14 Jun 2022 09:09:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 14 Jun 2022 11:09:34 +0200
Message-Id: <20220614090934.570632-7-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 6/6] block: move blk_queue_get_max_sectors to
 blk.h
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

blk_queue_get_max_sectors is private to the block layer, so move it out
of blkdev.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk.h            | 13 +++++++++++++
 include/linux/blkdev.h | 13 -------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 434017701403f..8e79296ee97a2 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -159,6 +159,19 @@ static inline bool blk_discard_mergable(struct request *req)
 	return false;
 }
 
+static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
+						     int op)
+{
+	if (unlikely(op == REQ_OP_DISCARD || op == REQ_OP_SECURE_ERASE))
+		return min(q->limits.max_discard_sectors,
+			   UINT_MAX >> SECTOR_SHIFT);
+
+	if (unlikely(op == REQ_OP_WRITE_ZEROES))
+		return q->limits.max_write_zeroes_sectors;
+
+	return q->limits.max_sectors;
+}
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 void blk_flush_integrity(void);
 bool __bio_integrity_endio(struct bio *);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 05e60ee269d91..5ef2f061feb08 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -920,19 +920,6 @@ static inline unsigned int bio_zone_is_seq(struct bio *bio)
 }
 #endif /* CONFIG_BLK_DEV_ZONED */
 
-static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
-						     int op)
-{
-	if (unlikely(op == REQ_OP_DISCARD || op == REQ_OP_SECURE_ERASE))
-		return min(q->limits.max_discard_sectors,
-			   UINT_MAX >> SECTOR_SHIFT);
-
-	if (unlikely(op == REQ_OP_WRITE_ZEROES))
-		return q->limits.max_write_zeroes_sectors;
-
-	return q->limits.max_sectors;
-}
-
 /*
  * Return how much of the chunk is left to be used for I/O at a given offset.
  */
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

