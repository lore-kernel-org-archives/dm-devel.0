Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D31C6FA83
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954597;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CL+UTUHs2Lku8hAG+Qg2OBsO4FL77zNJDoyaFKPUGwY=;
	b=JYqFEaSNKKgBAH3jEd/BbrMYInqM0j9IvsV/Rmz3WLQwFpxXybcUCABPexpkaViMj7ji6P
	aq2xTH6tLplH1+Ck9cmbRix0XJJ8+hsrXW4grdNjU/eCvi3J7hQOtGWhdWOu0iAT0b/9s4
	VIqTopNp19ydoJliqmZvcZr0SeJtDsY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-URdPyD5lNT6c0r-Sj0DyAg-1; Fri, 23 Sep 2022 13:36:32 -0400
X-MC-Unique: URdPyD5lNT6c0r-Sj0DyAg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 364D2858F17;
	Fri, 23 Sep 2022 17:36:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 22E86201F402;
	Fri, 23 Sep 2022 17:36:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 15C5619465B7;
	Fri, 23 Sep 2022 17:36:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E8BF019465B7
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D9D0A2166B29; Fri, 23 Sep 2022 17:36:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C8F12166B35
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A75B3817A6E
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:28 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-7vEZMW8COR6ouEUE8_gYUg-1; Fri, 23 Sep 2022 13:36:26 -0400
X-MC-Unique: 7vEZMW8COR6ouEUE8_gYUg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173624euoutp0192f7269ef78f7a4e3068e23a22918731~XjeDOMn4V1804318043euoutp01B
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220923173624euoutp0192f7269ef78f7a4e3068e23a22918731~XjeDOMn4V1804318043euoutp01B
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220923173622eucas1p1d96fc1f990457c2fd3fd8e231d0ffb76~XjeBpFMp31388713887eucas1p1F;
 Fri, 23 Sep 2022 17:36:22 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 06.6E.29727.69EED236; Fri, 23
 Sep 2022 18:36:22 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220923173621eucas1p11d1d89e187b39e057c7dfb58756c6a2e~XjeBSC4EX1390013900eucas1p1I;
 Fri, 23 Sep 2022 17:36:21 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220923173621eusmtrp1f5b93b7d8eaca219fcdc8f43c35efb2b~XjeBRSN9m1032310323eusmtrp1X;
 Fri, 23 Sep 2022 17:36:21 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-22-632dee96e2aa
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id C8.78.07473.59EED236; Fri, 23
 Sep 2022 18:36:21 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173621eusmtip2c91479edee2586777c201e311a9b54b5~XjeA-3gwy2337923379eusmtip2a;
 Fri, 23 Sep 2022 17:36:21 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:07 +0200
Message-Id: <20220923173618.6899-3-p.raghav@samsung.com>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsWy7djP87rT3ukmGyxo47NYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9JounV2cxWey9pW1x
 edccNov5y56yW0xo+8ps8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHr3N79g8drbeZ/V4v+8qm0ffllWMHptPV3t83iTn0X6gmymAN4rLJiU1J7MstUjf
 LoEr40xvbEG3eEX76++MDYzrhLsYOTkkBEwk3va3MXUxcnEICaxglNjcs50RwvnCKPHk8F92
 COczo8TE22eAyjjAWn4czAPpFhJYzihx4ogehP2SUWJtpx1ICZuAlkRjJztIWEQgXeL41ptg
 NrNAH7PEw9fxICXCQPGtz+xBwiwCqhKfP7xhBbF5BSwkrt2+wAJxm7zEzEvf2UHKOQUsJfob
 ayBKBCVOznzCAjFRXqJ562xmiPLdnBLHP2lC2C4SxxYeYoKwhSVeHd/CDmHLSJye3AM1vlri
 6Y3fzCAPSgi0MEr071zPBvGgtUTfmRwQk1lAU2L9Ln2IckeJ7SsusUJU8EnceCsIcQGfxKRt
 05khwrwSHW1CENVKEjt/PoFaKiFxuWkO1FIPifkd85gmMCrOQvLLLCS/zELYu4CReRWjeGpp
 cW56arFhXmq5XnFibnFpXrpecn7uJkZgMjz97/inHYxzX33UO8TIxMF4iFGCg1lJhDflom6y
 EG9KYmVValF+fFFpTmrxIUZpDhYlcV62GVrJQgLpiSWp2ampBalFMFkmDk6pBqZoJp9DrnZa
 Z57tsSvqvZziULNi/9SQ3Cu1l+avKJkRNG33avasmV1cmVe3ue5cGLDyemtlaFflkz3mftME
 Y3+snDUtW8iI0/DC3fkKwafYp6l/fGX3pjQ42Vr9+MtXC0O+qavl/9kau67rU9k5XVObot1i
 EzO4fO60cz2/qRFzsYFLSOZyRLGU34tLk80rQ/ID9GwO6L/ePf/Ai8ePrfPDLzvttDxbYBb6
 8s6i3qsMLw9oz//5beoWx/VHN2rKflVpujvx/bUnrDezTMVuWKw1Mlray7Sf91SkyL/1uxij
 92bVreJ/OmPfvvNbZRU5HHX8l80++uPkKzP/+j/Xzu5YPKfl9WuHdZOCrt04N1taX4mlOCPR
 UIu5qDgRAH/LXx71AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xe7pT3+kmG2zZZ2yx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZPr85isth7S9vi
 8q45bBbzlz1lt5jQ9pXZ4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHqb37F57Gy9z+rxft9VNo++LasYPTafrvb4vEnOo/1AN1MAb5SeTVF+aUmqQkZ+
 cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZapG+XYJexpne2IJu8Yr2198ZGxjX
 CXcxcnBICJhI/DiY18XIySEksJRRYusjFRBbQkBC4vbCJkYIW1jiz7Uuti5GLqCa54wSZ3cf
 YgfpZRPQkmjsZAepERHIlTi29h4rSA2zwDxmiSlnt7CB1AgLpEq0X6gAqWERUJX4/OENK4jN
 K2Ahce32BRaI+fISMy99BxvJKWAp0d9YA3GOhcT5xY/YIcoFJU7OfAJWzgxU3rx1NvMERoFZ
 SFKzkKQWMDKtYhRJLS3OTc8tNtQrTswtLs1L10vOz93ECIzebcd+bt7BOO/VR71DjEwcjIcY
 JTiYlUR4Uy7qJgvxpiRWVqUW5ccXleakFh9iNAU6eyKzlGhyPjB95JXEG5oZmBqamFkamFqa
 GSuJ83oWdCQKCaQnlqRmp6YWpBbB9DFxcEo1MKldKn1zmEfstYPD6aTP8zVlZ9aciWFeZ2xx
 NWt/0A1pHuspggkrNxgzyFd3sEb2HP6mdcl9miZL5Ls5itG3VcUnzN93+HCKnJxn9vygYxdu
 J1b3S3guKTvWdMYms6Ndv0S3WNByQuxvmxVb3rNNPZbKtE1rRoKJ6WbJt1pBc8yM3t5wPyzv
 2lF0R2H6GteDP+Zd6lrJbSJ0TFuKKVpGydkpb96Nic+4f3v9V5YzDD5rdSlSW6tE4P1e/TMv
 ltWzRHbal2vMW1kvct/27pm/h1yOMX3dGRNr5PKbK/EslxbPy0sHK4pWJm99vNXp4ekrbdeU
 2zfq7GL/80k4eIH50d4JfZyf49afveL4cNNmLiWW4oxEQy3mouJEAIcSILNnAwAA
X-CMS-MailID: 20220923173621eucas1p11d1d89e187b39e057c7dfb58756c6a2e
X-Msg-Generator: CA
X-RootMTR: 20220923173621eucas1p11d1d89e187b39e057c7dfb58756c6a2e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173621eucas1p11d1d89e187b39e057c7dfb58756c6a2e
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173621eucas1p11d1d89e187b39e057c7dfb58756c6a2e@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v15 02/13] block: rearrange bdev_{is_zoned,
 zone_sectors, get_queue} helper in blkdev.h
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Define bdev_is_zoned(), bdev_zone_sectors() and bdev_get_queue() earlier
in the blkdev.h include file. Simplify bdev_is_zoned() by removing the
superfluous NULL check for request queue while we are at it.

This commit has no functional change, and it is a prep patch for allowing
zoned devices with non-power-of-2 zone sizes in the block layer.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/blkdev.h | 43 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6c6bf4dd5709..6cf43f9384cc 100644
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

