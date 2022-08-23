Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B63C38145
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 12:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661257158;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A9ybbc75mj5syVK4oqgfdZdkbSngo8V8cmFaVsyjmjM=;
	b=ADnv0RE49u4cuNx8koEtXUztTC1/mNV0+BcVJIUknyMtm1esGZToAXzP22ykYC5IXjsLnV
	DRyHksuGFWh95zWkMSYs2Yzo989OtTH8ncFbUMAXaMKs31XNgq55M2d28W+4aanWa0ljoE
	MGVc6KbrNGNb+V4oTAqsYelmK2h0+fw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-6PAAJ9s0PG2w8soiVJUAbw-1; Tue, 23 Aug 2022 08:19:14 -0400
X-MC-Unique: 6PAAJ9s0PG2w8soiVJUAbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 234931C004F6;
	Tue, 23 Aug 2022 12:19:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EAB832026D4C;
	Tue, 23 Aug 2022 12:19:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4A3131946A64;
	Tue, 23 Aug 2022 12:19:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 000D71946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 12:19:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D90711121319; Tue, 23 Aug 2022 12:19:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D52051121315
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF4CD1C004E5
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:08 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-N_7ch9HyP1qFiOiSLLsVTw-1; Tue, 23 Aug 2022 08:19:06 -0400
X-MC-Unique: N_7ch9HyP1qFiOiSLLsVTw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220823121905euoutp02938d2696019df7c2a2330b8d23d13120~N_JKKUJrK1887718877euoutp02j
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220823121905euoutp02938d2696019df7c2a2330b8d23d13120~N_JKKUJrK1887718877euoutp02j
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220823121904eucas1p21882ea32eaa14c1822e3cc091f51cfe0~N_JIrXXlB1780717807eucas1p2i;
 Tue, 23 Aug 2022 12:19:04 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 46.82.29727.8B5C4036; Tue, 23
 Aug 2022 13:19:04 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220823121903eucas1p230518b312d5260d28e356ba911a27469~N_JIAX5Sx2020620206eucas1p2N;
 Tue, 23 Aug 2022 12:19:03 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220823121903eusmtrp14bf9acadd2de37d63b4d534af5195731~N_JH-ndbR1042010420eusmtrp11;
 Tue, 23 Aug 2022 12:19:03 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-75-6304c5b86dd9
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 4E.71.10862.7B5C4036; Tue, 23
 Aug 2022 13:19:03 +0100 (BST)
Received: from localhost (unknown [106.210.248.52]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220823121903eusmtip21130b9482eb3022901311def411bb039~N_JHsahh32346623466eusmtip2C;
 Tue, 23 Aug 2022 12:19:03 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 23 Aug 2022 14:18:48 +0200
Message-Id: <20220823121859.163903-3-p.raghav@samsung.com>
In-Reply-To: <20220823121859.163903-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsWy7djP87o7jrIkG3ybzm2x/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW3xe2sJusebmUxaLE7ekHQQ9Ll/x9tg56y67x+WzpR6bVnWyeWxeUu+x+2YD
 m8fO1vusHu/3XWXz6NuyitFj8+lqj8+b5DzaD3QzBfBEcdmkpOZklqUW6dslcGWsPHKJpeCF
 aMWT05fYGhhnC3UxcnJICJhIPH35mRnEFhJYwSix6F8JhP2FUeJqh34XIxeQ/ZlRorN9NjtM
 w/amo0wQieWMEl1P1jNDOC8YJWbO3M3SxcjBwSagJdHYCdYgIpAu8fXrBkaQGmaBbUwSv+5e
 YgFJCIMkLrwCK2IRUJU4OOkrK4jNK2AlsejeHxaIbfISMy99B6vhFLCWmLf0FCNEjaDEyZlP
 wGqYgWqat84GO0JCYD2nxJEPi5ggml0k5rx+DnW2sMSr41ugbBmJ05N7oBZUSzy98RuquYVR
 on/nejaQDySAtvWdyQExmQU0Jdbv0ocod5T4c+cxVAWfxI23ghAn8ElM2jadGSLMK9HRBg1c
 JYmdP59ALZWQuNw0B2qph8TbHa0sExgVZyF5ZhaSZ2Yh7F3AyLyKUTy1tDg3PbXYMC+1XK84
 Mbe4NC9dLzk/dxMjMAme/nf80w7Gua8+6h1iZOJgPMQowcGsJMJbfZEhWYg3JbGyKrUoP76o
 NCe1+BCjNAeLkjhvcuaGRCGB9MSS1OzU1ILUIpgsEwenVANTq7b98nNvOK0qYmLfBVTX9tSf
 nbTy9rTNmVdfWvG8su39c2hNTN+tHuGM2J0V/1a08yw113E8nHzuc1qS2gmVePEv51b0b+6Q
 urlXwuSbx4zXMy58V9hoqBl18d7pBVrdk38flw3oSpLMORzx4o9awOog5hqRd/eud25IVhba
 FTl5VVjQ56PmWtFbshf4iClI5EdMnsMnac1yg2HVUqmHcs9dtle/PqeYcPLKVrZMOy/B3MKP
 j+d/W26z5ajg/rDdfMFMll2Zh8UU2qccq0p+LO6eXXb43/WTn3gSHufIHv7w+t05+ZiplbP0
 npy/+VFrfvbGQyZOijkTN7EuEf3hdML8j/3jrVM211y6tnxxkBJLcUaioRZzUXEiAJ9hjJ3x
 AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t/xe7rbj7IkG6xfJGGx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW3xe2sJusebmUxaLE7ekHQQ9Ll/x9tg56y67x+WzpR6bVnWyeWxeUu+x+2YD
 m8fO1vusHu/3XWXz6NuyitFj8+lqj8+b5DzaD3QzBfBE6dkU5ZeWpCpk5BeX2CpFG1oY6Rla
 WugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GWsPHKJpeCFaMWT05fYGhhnC3UxcnJICJhI
 bG86ytTFyMUhJLCUUeL9hfXsEAkJidsLmxghbGGJP9e62CCKnjFKbN/+kqWLkYODTUBLorET
 rF5EIFfi8OYJYIOYBY4wSaxuXMsKkhAWSJXYefsY2CAWAVWJg5O+gsV5BawkFt37wwKxQF5i
 5qXvYIM4Bawl5i09BVYvBFQz/9YnNoh6QYmTM5+A1TMD1Tdvnc08gVFgFpLULCSpBYxMqxhF
 UkuLc9Nzi430ihNzi0vz0vWS83M3MQJjdtuxn1t2MK589VHvECMTB+MhRgkOZiUR3uqLDMlC
 vCmJlVWpRfnxRaU5qcWHGE2B7p7ILCWanA9MGnkl8YZmBqaGJmaWBqaWZsZK4ryeBR2JQgLp
 iSWp2ampBalFMH1MHJxSDUyL67UEN+tPbficdih617b1IrnJfHY5Jx9JsPY9u6LgnjAtUdjq
 1lyBniNPdulOmzbHzUxJTn1W1DrBLFOVcE9X1utJKid+GM09k8kz85fWxt6P3fMEVv1pZwzd
 7R1jt7cuhEWd8dIxdb1H6b8W+ObomnYYdp9ak+Znlnbo2c/vIckffHccYHH/6eBSl8SbOMXU
 c9JbnrX2KjfWJ79irEl+f0llouiBLRv/PDTtUROap+op/mta+/Egp4I3rJyCPyT3t+7MVOm+
 qne6dk3+7087H8l8ePHJ9urCxkXCp/3b1pdV9P1UORE6k3u+n4FwVYGb5iE1+/8Xtp5J5L78
 uC3iwpuP2y/sN2ZafLrsRKoSS3FGoqEWc1FxIgCJP07aYgMAAA==
X-CMS-MailID: 20220823121903eucas1p230518b312d5260d28e356ba911a27469
X-Msg-Generator: CA
X-RootMTR: 20220823121903eucas1p230518b312d5260d28e356ba911a27469
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121903eucas1p230518b312d5260d28e356ba911a27469
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121903eucas1p230518b312d5260d28e356ba911a27469@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v12 02/13] block:rearrange bdev_{is_zoned,
 zone_sectors, get_queue} helpers in blkdev.h
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Define bdev_is_zoned(), bdev_zone_sectors() and bdev_get_queue() earlier
in the blkdev.h include file. Simplify bdev_is_zoned() by removing the
superfluous NULL check for request queue while we are at it.

This commit has no functional change, and it is a prep patch for allowing
zoned devices with non-power-of-2 zone sizes in the block layer.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 include/linux/blkdev.h | 43 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ab82d1ff0cce..84e7881262e3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -635,6 +635,11 @@ static inline bool queue_is_mq(struct request_queue *q)
 	return q->mq_ops;
 }
 
+static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
+{
+	return bdev->bd_queue;	/* this is never NULL */
+}
+
 #ifdef CONFIG_PM
 static inline enum rpm_status queue_rpm_status(struct request_queue *q)
 {
@@ -666,6 +671,20 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
 	}
 }
 
+static inline bool bdev_is_zoned(struct block_device *bdev)
+{
+	return blk_queue_is_zoned(bdev_get_queue(bdev));
+}
+
+static inline sector_t bdev_zone_sectors(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (!blk_queue_is_zoned(q))
+		return 0;
+	return q->limits.chunk_sectors;
+}
+
 #ifdef CONFIG_BLK_DEV_ZONED
 static inline unsigned int disk_nr_zones(struct gendisk *disk)
 {
@@ -892,11 +911,6 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags);
 int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
 			unsigned int flags);
 
-static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
-{
-	return bdev->bd_queue;	/* this is never NULL */
-}
-
 /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
 const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
 
@@ -1296,25 +1310,6 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
 	return BLK_ZONED_NONE;
 }
 
-static inline bool bdev_is_zoned(struct block_device *bdev)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (q)
-		return blk_queue_is_zoned(q);
-
-	return false;
-}
-
-static inline sector_t bdev_zone_sectors(struct block_device *bdev)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (!blk_queue_is_zoned(q))
-		return 0;
-	return q->limits.chunk_sectors;
-}
-
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

