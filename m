Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B394C636CC
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 20:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676492210;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TpCQ3jYbRj2DgiLDDhPwM5bFtM0VGK7ZkMv+foQUSXI=;
	b=B1AxKAmfWufXKw9xjoZvC2LhdCAhnHtwJg7+ucnsFyK21rVecouvKrS7oQh1D6haFPhm3+
	El6FE9RphfPa1uoNa5mbFeCdWOuTkvR+hgF9nSCehyiI7aSym8RxYBEPFzGVwgfd0qOC05
	MlKL52sKKPtfVJ3Ytrh7hlfjXS0ASAc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-Q5RCcOxFP1mb0nuSbPYOTw-1; Wed, 15 Feb 2023 15:16:46 -0500
X-MC-Unique: Q5RCcOxFP1mb0nuSbPYOTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F26C80D0EF;
	Wed, 15 Feb 2023 20:16:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C703B1121314;
	Wed, 15 Feb 2023 20:16:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 94DC21946589;
	Wed, 15 Feb 2023 20:16:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2C4B01946589
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Feb 2023 20:16:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A41E82026D68; Wed, 15 Feb 2023 20:16:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B9B92026D4B
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 20:16:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CB03101AA5F
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 20:16:36 +0000 (UTC)
Received: from mail-vk1-f228.google.com (mail-vk1-f228.google.com
 [209.85.221.228]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-6WqI3ZpVOpae6-Bw1GiVWw-1; Wed, 15 Feb 2023 15:16:34 -0500
X-MC-Unique: 6WqI3ZpVOpae6-Bw1GiVWw-1
Received: by mail-vk1-f228.google.com with SMTP id n22so33474vkm.11
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 12:16:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=M98UXpjVEYt3NGAko84ajoRVrAGXqIjcE9iQT0L9hMg=;
 b=rEvGN0v0T479UqTrlpB2iVz3APUMi3Sq8Rstj1khnaqeYmdqdccXejOOmsoVHKvf3I
 9XM3FKhGKE4RN4zkVGpOk3nJa6YT/Mu1wmSkS2Miq+cxpBNDp0QCNJ31MeydrawanYiy
 AL4fc1u+vnyaQrbEQIwDxvneNde+do60/+mmSvyJG15WQ0r2vofIMYEtiVhH74pkQ9G5
 bKhwCL4EBbFc3Nl36DPfFN8ufrT714FL7eePNi1AUYE371Y+8k6hZIK2pI4GEyYuHbbk
 KWiiuv30i1Ie0A1jG6lemFmIUljZ37U7D9lHRxjshdtwSvrJdl0LlVRyQAsNkMEw/Nhb
 24mw==
X-Gm-Message-State: AO0yUKVEzp2R18tort5voGsGw/9uySb35QDZnKlNF6wUhb1Nc1xGCsXy
 Phf8pTPavh3YoNXRYnr00JghMuNEY7JKtev746jL7wtLtgJZLLTpb2hzhDq847ByBw==
X-Google-Smtp-Source: AK7set+L2VaJ+F9yYULVy/1uMoVkccBGgHj5CvDuYddgZqqFytg8xjmZz8Ekq53o6SMFFkOa//ziVXXyNRL+
X-Received: by 2002:a1f:1689:0:b0:401:41ff:4052 with SMTP id
 131-20020a1f1689000000b0040141ff4052mr2767209vkw.16.1676492193979; 
 Wed, 15 Feb 2023 12:16:33 -0800 (PST)
Received: from c7-smtp.dev.purestorage.com ([2620:125:9007:320:7:32:106:0])
 by smtp-relay.gmail.com with ESMTPS id
 v15-20020ab07c8f000000b006863f81db24sm1296969uaw.17.2023.02.15.12.16.33
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 15 Feb 2023 12:16:33 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev5.dev.purestorage.com
 [IPv6:2620:125:9007:640:7:70:36:0])
 by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id 493C020951;
 Wed, 15 Feb 2023 13:16:33 -0700 (MST)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
 id 44FA4E406AB; Wed, 15 Feb 2023 13:16:33 -0700 (MST)
From: Uday Shankar <ushankar@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Date: Wed, 15 Feb 2023 13:15:08 -0700
Message-Id: <20230215201507.494152-1-ushankar@purestorage.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH] blk-mq: enforce op-specific segment limits in
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
 Uday Shankar <ushankar@purestorage.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
 block/blk-merge.c | 4 +---
 block/blk-mq.c    | 5 +++--
 block/blk.h       | 8 ++++++++
 3 files changed, 12 insertions(+), 5 deletions(-)

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
index d3494a796..121b20230 100644
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
+	if (rq->nr_phys_segments > max_segments) {
 		printk(KERN_ERR "%s: over max segments limit. (%hu > %hu)\n",
-			__func__, rq->nr_phys_segments, queue_max_segments(q));
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

