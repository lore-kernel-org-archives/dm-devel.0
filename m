Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B7BCC19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 09:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659520097;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tOYrkVcNTwBdNlHWghogxzn0jZrNdoF2DeGKd0a6sBg=;
	b=Hn2x7VMf76OxLMrmt5Ykjt1g3XQPWYtfBhqsderBhLCnlmh93p5uluMIpMFbLx2i9iVeQh
	tL+OK9eovV+8HjyD68foCnDfbxRUz91rVKbLAbh3iFNr6cM87ZvKazMcxuAVFEJyqvbMim
	GuyulF5DWtkUuheAySJmArc84TUhA/k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-ZOr3QY5iPY62_owNungf7w-1; Wed, 03 Aug 2022 05:48:14 -0400
X-MC-Unique: ZOr3QY5iPY62_owNungf7w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CD1E38217EF;
	Wed,  3 Aug 2022 09:48:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C6601141510F;
	Wed,  3 Aug 2022 09:48:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8025E1946A52;
	Wed,  3 Aug 2022 09:48:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1B861946A52
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 09:48:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D2B012026D64; Wed,  3 Aug 2022 09:48:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CEB8D2026D4C
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B933F801755
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:09 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-pTVYY7i3Npa8QeVfxL2o7Q-1; Wed, 03 Aug 2022 05:48:08 -0400
X-MC-Unique: pTVYY7i3Npa8QeVfxL2o7Q-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220803094807euoutp013b87cf2ba22dbee478d815d819fc9a3f~HzLoGdkH83128231282euoutp01_
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220803094807euoutp013b87cf2ba22dbee478d815d819fc9a3f~HzLoGdkH83128231282euoutp01_
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220803094805eucas1p2fb2e6683b85d89ad1c79c6978055ad18~HzLmlH4_X1615116151eucas1p2u;
 Wed,  3 Aug 2022 09:48:05 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id A0.FF.09664.5544AE26; Wed,  3
 Aug 2022 10:48:05 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220803094804eucas1p1feea4b1bdae819f4c8750994ddd94803~HzLmH9IqN1902519025eucas1p1H;
 Wed,  3 Aug 2022 09:48:04 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220803094804eusmtrp28c08a2adda8796fdf9c233c636159095~HzLmHClmQ0972009720eusmtrp2Y;
 Wed,  3 Aug 2022 09:48:04 +0000 (GMT)
X-AuditID: cbfec7f2-d97ff700000025c0-79-62ea44553828
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 40.9B.09038.4544AE26; Wed,  3
 Aug 2022 10:48:04 +0100 (BST)
Received: from localhost (unknown [106.210.248.112]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220803094804eusmtip23b70977da7da3b653211630caa4bac3a~HzLlvVUMC1623516235eusmtip2k;
 Wed,  3 Aug 2022 09:48:04 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes.Thumshirn@wdc.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, agk@redhat.com, hch@lst.de
Date: Wed,  3 Aug 2022 11:47:50 +0200
Message-Id: <20220803094801.177490-3-p.raghav@samsung.com>
In-Reply-To: <20220803094801.177490-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djPc7qhLq+SDBr2iVqsP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFp+XtrBbrLn5lMXixC1pB0GPy1e8PXbOusvucflsqcemVZ1sHpuX1HvsvtnA
 5rGz9T6rx/t9V9k8+rasYvTYfLra4/MmOY/2A91MATxRXDYpqTmZZalF+nYJXBnHH95nL9gu
 WnHgyGb2Bsbngl2MnBwSAiYS+9ZdZASxhQRWMEps2B/VxcgFZH9hlJjdsIwdwvkM5PStZYHp
 mLnsNhNEx3JGic4ZRRBFLxklVu1YATSKg4NNQEuisROsWUSgmVHi7t8eVhCHWWAGk0THxz6w
 ScICaRLre16C2SwCqhKT9/0Es3kFrCRuvnnCDLFNXmLmpe/sIDangLXElH//mCFqBCVOznwC
 Vs8MVNO8dTYzyAIJgc2cEj+XLYJqdpE49GwTE4QtLPHq+BZ2CFtG4v/O+VDxaomnN35DNbcw
 SvTvXM8G8oIE0La+MzkgJrOApsT6XfoQ5Y4SH6ecZYao4JO48VYQ4gQ+iUnbpkOFeSU62oQg
 qpUkdv58ArVUQuJy0xxoGHpInH0/i20Co+IsJM/MQvLMLIS9CxiZVzGKp5YW56anFhvmpZbr
 FSfmFpfmpesl5+duYgSmwdP/jn/awTj31Ue9Q4xMHIyHGCU4mJVEeO+4PE8S4k1JrKxKLcqP
 LyrNSS0+xCjNwaIkzpucuSFRSCA9sSQ1OzW1ILUIJsvEwSnVwNTqxjenYN1Uqe6S4rNuM0SK
 mERDM5fs6nq4lGnlJ5bCFJHwXawOX8Uetbu8NxVJ3Tcn75fF+hfm7j+Spzm6nZ26UuR0/MJ+
 yarYvd0WT1fY/bG44Pju8cJ658muKbc+O/evvPfia5LymY/Caekph0Wqpy7uU12RvUw4SntO
 ddvnk1ueN81QND7w8q9z6TKR8j2/U5IY9Y0P2m/qr7MLulWzwex/n8Kq8InREko1e8IVuQyr
 Ay1UObtEF/pkxl3bxXdNZNKevyY/Oa+Z/X56RVHqxVKhh1vVeKN6GZWUpIp6Q8773tYNkFlR
 tkHUjSPTfXGQS8iX88pSDenpRxpqVjDc/b1S8BD/pPKORTliSizFGYmGWsxFxYkAkFdT+fID
 AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t/xe7ohLq+SDG536lusP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFp+XtrBbrLn5lMXixC1pB0GPy1e8PXbOusvucflsqcemVZ1sHpuX1HvsvtnA
 5rGz9T6rx/t9V9k8+rasYvTYfLra4/MmOY/2A91MATxRejZF+aUlqQoZ+cUltkrRhhZGeoaW
 FnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehnHH95nL9guWnHgyGb2Bsbngl2MnBwSAiYS
 M5fdZupi5OIQEljKKLH63DZmiISExO2FTYwQtrDEn2tdbBBFzxklLmxewtrFyMHBJqAl0djJ
 DhIXEehmlLh85hwriMMssIxJounLdTaQbmGBFInV59uYQGwWAVWJyft+soDYvAJWEjffPIHa
 Ji8x89J3dhCbU8BaYsq/f2BxIaCadX9nsULUC0qcnPkErJcZqL5562zmCYwCs5CkZiFJLWBk
 WsUoklpanJueW2ykV5yYW1yal66XnJ+7iREYtduO/dyyg3Hlq496hxiZOBgPMUpwMCuJ8N5x
 eZ4kxJuSWFmVWpQfX1Sak1p8iNEU6O6JzFKiyfnAtJFXEm9oZmBqaGJmaWBqaWasJM7rWdCR
 KCSQnliSmp2aWpBaBNPHxMEp1cAU9UA7NLPHUNj3zRotSYUTWikPxE2tTd78eldqJ3RFc8e2
 RQ63rENfR5xZe+XOudUPameql7pHP90qq+UYJr4i46Da69k5xz5l/2t5G3jO/oOsvfiHjskL
 Kv7qJ03g29z69pKkg439pgP7+ioybDdNW9Cp/bfMSFfRd8MidbbyNdOrqk+cUQlwzDB8d4vb
 lS39gfrBJl9JtofnlO51TPkY8nOW4ME+fd3i1Nerij9KVb+08dnheOVym0veT467svpMvWx5
 XlvuL9oc/Tb1lWen36Rdm7nmz9UqcNmkwLip88kPvcsR84siHvH2/WZjemm/bomEVmCFYGKv
 lXfTXdFa9ZKLSgb/VCYaT2/d5avEUpyRaKjFXFScCAAG7hpFYwMAAA==
X-CMS-MailID: 20220803094804eucas1p1feea4b1bdae819f4c8750994ddd94803
X-Msg-Generator: CA
X-RootMTR: 20220803094804eucas1p1feea4b1bdae819f4c8750994ddd94803
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094804eucas1p1feea4b1bdae819f4c8750994ddd94803
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094804eucas1p1feea4b1bdae819f4c8750994ddd94803@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v9 02/13] block:rearrange bdev_{is_zoned,
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
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Define bdev_is_zoned(), bdev_zone_sectors() and bdev_get_queue() earlier
in the blkdev.h include file.

This commit has no functional change, and it is a prep patch for allowing
zoned devices with non-power-of-2 zone sizes in the block layer.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Suggested-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/blkdev.h | 48 +++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ab82d1ff0cce..22f97427b60b 100644
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
@@ -666,6 +671,25 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
 	}
 }
 
+static inline bool bdev_is_zoned(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (q)
+		return blk_queue_is_zoned(q);
+
+	return false;
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
@@ -892,11 +916,6 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags);
 int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
 			unsigned int flags);
 
-static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
-{
-	return bdev->bd_queue;	/* this is never NULL */
-}
-
 /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
 const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
 
@@ -1296,25 +1315,6 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
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

