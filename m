Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75679C54EE9
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665107;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CL+UTUHs2Lku8hAG+Qg2OBsO4FL77zNJDoyaFKPUGwY=;
	b=XECkY+ewxo+PAmX+Hq/xCMnNQ0BEpOK3jWq9ORqqdkclWln1C+tlgL898Z/nFaevu0ueMb
	bz/9/R57zX2vvKCMvC+c3a4Tn3Y4KxNWPqAk4Wm4gxi9+clkgMU8f93cTIIUJdutGEsgCt
	kAJVXzMQxcXeIpq5SFOM/mA0LOR+eoE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-o7vehtCvP7ugmI3rN6v4cg-1; Tue, 20 Sep 2022 05:11:44 -0400
X-MC-Unique: o7vehtCvP7ugmI3rN6v4cg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D739118E5341;
	Tue, 20 Sep 2022 09:11:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C4B36207B358;
	Tue, 20 Sep 2022 09:11:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7B2C91946A42;
	Tue, 20 Sep 2022 09:11:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 277AA1946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1617F140EBF6; Tue, 20 Sep 2022 09:11:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DFBC140EBF5
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E54E280280C
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:38 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-szWeeXCkO9WL8biKPinKMg-1; Tue, 20 Sep 2022 05:11:29 -0400
X-MC-Unique: szWeeXCkO9WL8biKPinKMg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091124euoutp011077aae20e270dffdabc0f85158b936e~WhpSIxLjI1236212362euoutp01j
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220920091124euoutp011077aae20e270dffdabc0f85158b936e~WhpSIxLjI1236212362euoutp01j
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220920091123eucas1p2a0be40c803297d993359aa6b51e00fd0~WhpQdv2QH1342313423eucas1p2_;
 Tue, 20 Sep 2022 09:11:23 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id BD.88.19378.AB389236; Tue, 20
 Sep 2022 10:11:23 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220920091122eucas1p2934bc26b6c11bdbafa7ebd3004ce72ee~WhpP2euaV1297012970eucas1p2W;
 Tue, 20 Sep 2022 09:11:22 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220920091122eusmtrp1e875e9e33691aec42275dfaf50368b78~WhpP1lQ1n0212802128eusmtrp1K;
 Tue, 20 Sep 2022 09:11:22 +0000 (GMT)
X-AuditID: cbfec7f5-a4dff70000014bb2-a1-632983ba3a49
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id CB.FD.07473.AB389236; Tue, 20
 Sep 2022 10:11:22 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091122eusmtip1734e9e77c6ca9e0bfb601744df466a73~WhpPgui_61211712117eusmtip1j;
 Tue, 20 Sep 2022 09:11:22 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:08 +0200
Message-Id: <20220920091119.115879-3-p.raghav@samsung.com>
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsWy7djPc7q7mzWTDS54WKw/dYzZYvXdfjaL
 aR9+Mlv8Pnue2WLvu9msFjcP7GSy2LNoEpPFytVHmSyerJ/FbPG36x6TxdOrs5gs9t7Stri8
 aw6bxfxlT9ktJrR9Zbb4vLSF3WLNzacsFiduSTsIeVy+4u2xc9Zddo/LZ0s9Nq3qZPPYvKTe
 Y/fNBjaP3uZ3bB47W++zerzfd5XNo2/LKkaPzaerPT5vkvNoP9DNFMAbxWWTkpqTWZZapG+X
 wJVxpje2oFu8ov31d8YGxnXCXYycHBICJhJvX/9h7GLk4hASWMEosfTMNyYI5wujxPYXXcwQ
 zmdGic8TpzPCtPx6uxSqajmjxKdTvSwQzktGidU737N3MXJwsAloSTR2soM0iAikS3z9ugFs
 B7NAH7PEstUz2UASwkCJtzuPgBWxCKhK/J83kRGkl1fASuJyfzrEMnmJmZe+g5VwClhLzNnd
 AtbKKyAocXLmExYQmxmopnnrbLBLJQR2c0rM3tjBBNHsItHQMZcFwhaWeHV8CzuELSNxenIP
 VLxa4umN31DNLYwS/TvXs4EcIQG0re9MDojJLKApsX6XPkS5o8Sh66cYISr4JG68FYQ4gU9i
 0rbpzBBhXomONiGIaiWJnT+fQC2VkLjcNAdqqYfE5sv/WScwKs5C8swsJM/MQti7gJF5FaN4
 amlxbnpqsXFearlecWJucWleul5yfu4mRmBaPP3v+NcdjCtefdQ7xMjEwXiIUYKDWUmEt8Vf
 M1mINyWxsiq1KD++qDQntfgQozQHi5I4b3LmhkQhgfTEktTs1NSC1CKYLBMHp1QDUxx7vfeJ
 8OmL329LORy07LXImmtv/bN5ubwOvm6SsBOMTxI5Pfle8PFvy9dFa3XEp9rWZacXzrE/K8Vc
 2eRd9SV24tz3oUtaZkrsEP23OTVQ60Reoe+sotqGe6v39TDvMCpZ+Tzp/CJdW/Mg73SG542C
 0u9lMypC7jl65K6fO2GqUtplxxcRM1rZjq7R/it4+Fz8+qsS3hfjfKezn5j1+ee6Cs49Ds7c
 087c286b5pgUek1vRrOrY0fmtF3+ohWNAjbrQs7LlZ1+XBI6bdLk7S7LZ1cckXE9qLJmWsMp
 wctPPvGaX7qwdblUPvensIAsNq2gt6JcN2et2ijgJsP1MJfZevcrhmMNnyoF2X8GKLEUZyQa
 ajEXFScCADjoY4L6AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t/xu7q7mjWTDeY8E7ZYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9JounV2cxWey9pW1x
 edccNov5y56yW0xo+8ps8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHr3N79g8drbeZ/V4v+8qm0ffllWMHptPV3t83iTn0X6gmymAN0rPpii/tCRVISO/
 uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1J7MstUjfLkEv40xvbEG3eEX76++MDYzr
 hLsYOTkkBEwkfr1dytTFyMUhJLCUUaJ7wmNmiISExO2FTYwQtrDEn2tdbBBFzxkl7m26D9TB
 wcEmoCXR2MkOUiMikCtxePMEsEHMAvOYJc59W8QGUiMskCpx6T0HSA2LgKrE/3kTGUHCvAJW
 Epf70yHGy0vMvPQdbAyngLXEnN0tbCC2EFBJx6zNYDavgKDEyZlPWEBsZqD65q2zmScwCsxC
 kpqFJLWAkWkVo0hqaXFuem6xoV5xYm5xaV66XnJ+7iZGYARvO/Zz8w7Gea8+6h1iZOJgPMQo
 wcGsJMLb4q+ZLMSbklhZlVqUH19UmpNafIjRFOjsicxSosn5wBSSVxJvaGZgamhiZmlgamlm
 rCTO61nQkSgkkJ5YkpqdmlqQWgTTx8TBKdXAdDIoOpL5nHzIOYG9sSal38Q6Fs3iuqLuOlel
 U61h8rLZ7bo7z0fdubQ1VypWrM2q7592q5Jogaq0vd9n9jKbz7NW3N9mKnNswlrWtRt1U06c
 qkjwVnfr41010/pUzwXjXv+7wYsX7JASfZXK9n6PTI2A3LncHpEndS8eWNoFL1i7wum5bfqZ
 XMW9Vzaftmk7cXL9xE/z88QjN9R7JfssnHMxIuK31e9zk+KTvSd93Nnp1NB2PjO+5S6ne3FI
 duLKU7q/Hh0KOPkgy+Hn9OJlx7j/t0dvz1+9oCr2j+2GBd+8j6q+f+t2+ZVBQ/muHelhIXM2
 c3I++OWsr7ZeOnrF6br3cnd+9O3b/iT8ZZmWihJLcUaioRZzUXEiAIS4kK5pAwAA
X-CMS-MailID: 20220920091122eucas1p2934bc26b6c11bdbafa7ebd3004ce72ee
X-Msg-Generator: CA
X-RootMTR: 20220920091122eucas1p2934bc26b6c11bdbafa7ebd3004ce72ee
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091122eucas1p2934bc26b6c11bdbafa7ebd3004ce72ee
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091122eucas1p2934bc26b6c11bdbafa7ebd3004ce72ee@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v14 02/13] block: rearrange bdev_{is_zoned,
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

