Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0743C636D6
	for <dm-devel@archiver.kernel.org>; Wed, 22 Feb 2023 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677092020;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2CoZ7XUJVUw5f2zl5y6NGtt/Knwc1yz4OZBTBCaTsfc=;
	b=IgJFOn31GZt2ntEkt+E7a9AyqGeFtHnE6vCyOvHhSeSjHNcqT0/CpJa4V71GcEY1rCBMLO
	FXDIf0VFpzItDTw0j0IQqbWYWUkzISdf7wqOnjKTRcQr0csaNmSn1eDEA95NXJvqMmruSC
	6o3BtunIq4Va6/WfwVDSYg5i9BNrpQU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-1mJp6dzhNlymB1p3wxhy5w-1; Wed, 22 Feb 2023 13:53:36 -0500
X-MC-Unique: 1mJp6dzhNlymB1p3wxhy5w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2804C3C02184;
	Wed, 22 Feb 2023 18:53:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DC8A9C15BA0;
	Wed, 22 Feb 2023 18:53:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BBCCB19465A0;
	Wed, 22 Feb 2023 18:53:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF9AE194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Feb 2023 18:53:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 99307492B01; Wed, 22 Feb 2023 18:53:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 920CB492B00
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 18:53:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78209803462
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 18:53:19 +0000 (UTC)
Received: from mail-il1-f225.google.com (mail-il1-f225.google.com
 [209.85.166.225]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-463-gyuXkqsAMASXbX_N45b1wg-1; Wed, 22 Feb 2023 13:53:17 -0500
X-MC-Unique: gyuXkqsAMASXbX_N45b1wg-1
Received: by mail-il1-f225.google.com with SMTP id i4so2336173ils.1
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 10:53:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=3XQJnDEONaQxroBOwHQuKkK6NHLqVHt0xLQJjGikbCg=;
 b=H1fMBxVLkpc7h7FyWHqFTzvz3R/53AGdUx+s7/2xOfpPd3uDHY/01kW/WLlhyNFzt/
 O3l5O4aTOzHLoo8/lZCul5j8s7xMXyU6kd1PV6LNZNwALIwfhWs4eEfwRBJXbKMu2oXG
 NDy+V0SG6e/vBZQ+Wt46cO7EHL7tLhbqIilXbuZZ3nGXqPqoDGgvHI2rkN4i7qpjeoFq
 TuK1h/iTVTYCvS/pEKfr7pLtYyoqkUuJ12Dx+8JR4KlrOyp8WaUBRkO0rG15ePEFdpoI
 wESA8+4ouICCBrJ+CNEE52Pe8WPds1Ow6ulcl584K9jO7cTXIQBPCmv5T7L9BYZSkb/k
 XaNg==
X-Gm-Message-State: AO0yUKXJRnRE/qRM7vhP2N/NlR7nu7i/B0BiGX3eoO8TV9OAYlb6RNK7
 WxFnepcTWmaMRottgtgC+QKNmyOsyTm2D2CmTm7dGEfhI2X5TA==
X-Google-Smtp-Source: AK7set+y8N+kEI1uXvjpEcsNFNqman9u8t5ylXlm7hQchLag6GPppv3lVzivdlSoUDopDWc7gcrL8+XVN3g4
X-Received: by 2002:a05:6e02:221d:b0:315:69ef:345d with SMTP id
 j29-20020a056e02221d00b0031569ef345dmr5366501ilf.16.1677091996562; 
 Wed, 22 Feb 2023 10:53:16 -0800 (PST)
Received: from c7-smtp.dev.purestorage.com ([208.88.159.128])
 by smtp-relay.gmail.com with ESMTPS id
 bw10-20020a056638460a00b003de5c87c093sm567444jab.45.2023.02.22.10.53.16
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 22 Feb 2023 10:53:16 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com
 (dev-ushankar.dev.purestorage.com [10.7.70.36])
 by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id BC04721141;
 Wed, 22 Feb 2023 11:53:15 -0700 (MST)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
 id B7C4DE4332F; Wed, 22 Feb 2023 11:53:15 -0700 (MST)
From: Uday Shankar <ushankar@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>
Date: Wed, 22 Feb 2023 11:52:25 -0700
Message-Id: <20230222185224.2484590-1-ushankar@purestorage.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v2] blk-mq: enforce op-specific segment limits in
 blk_insert_cloned_request
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
 Uday Shankar <ushankar@purestorage.com>, kernel test robot <lkp@intel.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The block layer might merge together discard requests up until the
max_discard_segments limit is hit, but blk_insert_cloned_request checks
the segment count against max_segments regardless of the req op. This
can result in errors like the following when discards are issued through
a DM device and max_discard_segments exceeds max_segments for the queue
of the chosen underlying device.

blk_insert_cloned_request: over max segments limit. (256 > 129)

Fix this by looking at the req_op and enforcing the appropriate segment
limit - max_discard_segments for REQ_OP_DISCARDs and max_segments for
everything else.

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
---
Changes since v1:
- Fixed format specifier type mismatch
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202302162040.FaI25ul2-lkp@intel.com/

 block/blk-merge.c | 4 +---
 block/blk-mq.c    | 7 ++++---
 block/blk.h       | 8 ++++++++
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index b7c193d67..7f663c2d3 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -588,9 +588,7 @@ EXPORT_SYMBOL(__blk_rq_map_sg);
 
 static inline unsigned int blk_rq_get_max_segments(struct request *rq)
 {
-	if (req_op(rq) == REQ_OP_DISCARD)
-		return queue_max_discard_segments(rq->q);
-	return queue_max_segments(rq->q);
+	return blk_queue_get_max_segments(rq->q, req_op(rq));
 }
 
 static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index d3494a796..b053a9255 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3000,6 +3000,7 @@ blk_status_t blk_insert_cloned_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 	unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+	unsigned int max_segments = blk_queue_get_max_segments(q, req_op(rq));
 	blk_status_t ret;
 
 	if (blk_rq_sectors(rq) > max_sectors) {
@@ -3026,9 +3027,9 @@ blk_status_t blk_insert_cloned_request(struct request *rq)
 	 * original queue.
 	 */
 	rq->nr_phys_segments = blk_recalc_rq_segments(rq);
-	if (rq->nr_phys_segments > queue_max_segments(q)) {
-		printk(KERN_ERR "%s: over max segments limit. (%hu > %hu)\n",
-			__func__, rq->nr_phys_segments, queue_max_segments(q));
+	if (rq->nr_phys_segments > max_segments) {
+		printk(KERN_ERR "%s: over max segments limit. (%u > %u)\n",
+			__func__, rq->nr_phys_segments, max_segments);
 		return BLK_STS_IOERR;
 	}
 
diff --git a/block/blk.h b/block/blk.h
index f02381405..8d705c13a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -169,6 +169,14 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
 	return q->limits.max_sectors;
 }
 
+static inline unsigned int blk_queue_get_max_segments(struct request_queue *q,
+						      enum req_op op)
+{
+	if (op == REQ_OP_DISCARD)
+		return queue_max_discard_segments(q);
+	return queue_max_segments(q);
+}
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 void blk_flush_integrity(void);
 bool __bio_integrity_endio(struct bio *);

base-commit: 6bea9ac7c6481c09eb2b61d7cd844fc64a526e3e
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

