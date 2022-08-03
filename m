Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B240C19F2D
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 09:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659520100;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CBMMmQsQlnn+7ISybUOoYI2oRk2LH6k3AXcEGX2ILpk=;
	b=EwQidYyCeStOJlf53/CJcba4vvkkVVMeVNXY13bPlH1wyeBpqJlHcKCjt65x90FTveLpqs
	EZ8gZlz4SXbrmPmvEthH8osbAsX0LrmFChWgv26uWUPvwOUIFwLNqTYL5X3zPngmUrboBW
	iVP8i+NXJF89iCbDPqn74S5LhLyr5aw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-OG4qMx6mNKehyQ-UmX3t8g-1; Wed, 03 Aug 2022 05:48:17 -0400
X-MC-Unique: OG4qMx6mNKehyQ-UmX3t8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69E03185A794;
	Wed,  3 Aug 2022 09:48:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 587F52026D4C;
	Wed,  3 Aug 2022 09:48:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2480D1946A53;
	Wed,  3 Aug 2022 09:48:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D11511946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 09:48:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B227F2166B2A; Wed,  3 Aug 2022 09:48:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ADCE62166B26
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90D508115B1
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:14 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-j7Ti5HDZNTGFdlr1Cp1cAQ-1; Wed, 03 Aug 2022 05:48:12 -0400
X-MC-Unique: j7Ti5HDZNTGFdlr1Cp1cAQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220803094811euoutp011200a67923ca1731a6aaba67e60cb10c~HzLsFm7Tm3128231282euoutp01E
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220803094811euoutp011200a67923ca1731a6aaba67e60cb10c~HzLsFm7Tm3128231282euoutp01E
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220803094809eucas1p19bd8547e3fcb23e3f951c4f85f06f852~HzLqgfac10754107541eucas1p1_;
 Wed,  3 Aug 2022 09:48:09 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 7D.F5.10067.9544AE26; Wed,  3
 Aug 2022 10:48:09 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220803094809eucas1p1e24ddc3076eaa05db0658b88fd34ffd4~HzLqABfkC1902519025eucas1p1K;
 Wed,  3 Aug 2022 09:48:09 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220803094809eusmtrp261e43580a71933c10a45bfb080762358~HzLp_Bq0z0985609856eusmtrp2w;
 Wed,  3 Aug 2022 09:48:09 +0000 (GMT)
X-AuditID: cbfec7f4-dd7ff70000002753-46-62ea4459ad8a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 7E.DB.09095.8544AE26; Wed,  3
 Aug 2022 10:48:08 +0100 (BST)
Received: from localhost (unknown [106.210.248.112]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220803094808eusmtip11dc1bc750fcb0c384f4ce3c02685227a~HzLppsgZ-2551225512eusmtip1f;
 Wed,  3 Aug 2022 09:48:08 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes.Thumshirn@wdc.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, agk@redhat.com, hch@lst.de
Date: Wed,  3 Aug 2022 11:47:54 +0200
Message-Id: <20220803094801.177490-7-p.raghav@samsung.com>
In-Reply-To: <20220803094801.177490-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsWy7djP87qRLq+SDI4sVLBYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlbFs
 XTt7wWXpit8XPjA2MG4U72Lk5JAQMJG49X0DaxcjF4eQwApGie4v39khnC+MEhv2b2KCcD4z
 SuxetIwNpqX76UmoluWMEi9Ow1S9ZJQ4/mg5UD8HB5uAlkRjJ9goEYFmRom7f3vAOpgFDjBJ
 3NxyiwlklLBAhMS6xzNZQWwWAVWJqcvusYA08wpYSTzqsobYJi8x8xLITZwcnALWElP+/WMG
 sXkFBCVOznzCAmIzA9U0b53NDDJfQmA3p0TDrJNQp7pIbLw+nR3CFpZ4dXwLlC0j8X/nfCYI
 u1ri6Y3fUM0tjBL9O9ezgRwhAbSt70wOiMksoCmxfpc+RLmjxPrHu6Eq+CRuvBWEOIFPYtK2
 6cwQYV6JjjYhiGoliZ0/n0AtlZC43DSHBcL2kFjQ0802gVFxFpJnZiF5ZhbC3gWMzKsYxVNL
 i3PTU4uN8lLL9YoTc4tL89L1kvNzNzECU+Lpf8e/7GBc/uqj3iFGJg7GQ4wSHMxKIrx3XJ4n
 CfGmJFZWpRblxxeV5qQWH2KU5mBREudNztyQKCSQnliSmp2aWpBaBJNl4uCUamCqO3x0b535
 stclDxaHaB9iZd2w3fDN1EVP3ixV2KeRniebXrHrVhvHtR2xzT6PtTf9XLJef16B6dLLPmJb
 D/+IqGXbPN+lL8hX4Ydfljh3a0K+6sffHBd2vA79onjldfI/j53PbFv2im73UzZ7JL8w4/hr
 p7YJlZOfrivetET5l8iZ+E8iT8PmPHA2W+3v8XpbEoNWcmj4j4WrNpwsuGNRcq+TLztPxP+q
 yqOaj7/UJhtvXzn70ZXrC5aban2TO6pwRJi/RXCr/b/2uxV+aRYPp13cc3ERw8cvTnGp3iyt
 qnxLLuu9PbJ9pkNtEs8bkQrZ68vW/p04z1Xv8S3BosD4tGiG5E4Xc676NTM7XVzjlViKMxIN
 tZiLihMBwpB7+fgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xu7oRLq+SDN48srZYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl7FsXTt7wWXpit8XPjA2MG4U72Lk
 5JAQMJHofnqSFcQWEljKKPF3tgdEXELi9sImRghbWOLPtS62LkYuoJrnjBJHZzWydzFycLAJ
 aEk0drKDxEUEuhklLp85xwriMAucY5KY8/QBG0i3sECYRPOv9WA2i4CqxNRl91hAmnkFrCQe
 dVlDLJCXmHnpOzuIzSlgLTHl3z9miIOsJNb9nQV2HK+AoMTJmU9YQGxmoPrmrbOZJzAKzEKS
 moUktYCRaRWjSGppcW56brGhXnFibnFpXrpecn7uJkZg7G479nPzDsZ5rz7qHWJk4mA8xCjB
 wawkwnvH5XmSEG9KYmVValF+fFFpTmrxIUZToLMnMkuJJucDk0deSbyhmYGpoYmZpYGppZmx
 kjivZ0FHopBAemJJanZqakFqEUwfEwenVAOT0eYNAr1HLuSxVIg+7T4eo3fV3NLx1UHrOV57
 bmzkv67jEBZ/ZFHv4n1PSg7qvxbiWO1XvG5ykpndnhMSM0q6lh0tLW5VOv2m9Lu+TvW/HXfy
 dHWy+FKCFy8/Wfdp/mGf4xyNJ08sWX1NkEtG+qOib+QV27+sh02t+LKeGq/ZHP2uRl9+bu0e
 jSuCL7Y89bd5mPNHbVbZG62Ytx/+Kz48Udy2dNW9dhXPMOtS9cRfOyRdZz8IXDRFovxUdeva
 t8sWMzo/fLv+44cqz16WYr519x46vg21q3xi/v4y47bulTacX/JvNO20u6H8Vez0Ep5oQ0cP
 nfaO1q6fjzzEgi+uDecvfHlw7QWVA/V1hgI1SizFGYmGWsxFxYkAB/+Yf2YDAAA=
X-CMS-MailID: 20220803094809eucas1p1e24ddc3076eaa05db0658b88fd34ffd4
X-Msg-Generator: CA
X-RootMTR: 20220803094809eucas1p1e24ddc3076eaa05db0658b88fd34ffd4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094809eucas1p1e24ddc3076eaa05db0658b88fd34ffd4
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094809eucas1p1e24ddc3076eaa05db0658b88fd34ffd4@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH v9 06/13] null_blk: allow zoned devices with non
 power-of-2 zone sizes
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
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the power-of-2(po2) based calculation with zone size to be generic
in null_zone_no with optimization for po2 based zone sizes.

The nr_zones calculation in null_init_zoned_dev has been replaced with a
division without special handling for po2 based zone sizes as
this function is called only during the initialization and will not be
invoked in the hot path.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/block/null_blk/main.c     |  5 ++---
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/block/null_blk/zoned.c    | 18 +++++++++++-------
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index c451c477978f..f1e0605dee94 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1976,9 +1976,8 @@ static int null_validate_conf(struct nullb_device *dev)
 	if (dev->queue_mode == NULL_Q_BIO)
 		dev->mbps = 0;
 
-	if (dev->zoned &&
-	    (!dev->zone_size || !is_power_of_2(dev->zone_size))) {
-		pr_err("zone_size must be power-of-two\n");
+	if (dev->zoned && !dev->zone_size) {
+		pr_err("Invalid zero zone size\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 94ff68052b1e..f63b6bed1bb3 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -83,6 +83,7 @@ struct nullb_device {
 	unsigned int imp_close_zone_no;
 	struct nullb_zone *zones;
 	sector_t zone_size_sects;
+	unsigned int zone_size_sects_shift;
 	bool need_zone_res_mgmt;
 	spinlock_t zone_res_lock;
 
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 55a69e48ef8b..015f6823706c 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -16,7 +16,10 @@ static inline sector_t mb_to_sects(unsigned long mb)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
-	return sect >> ilog2(dev->zone_size_sects);
+	if (dev->zone_size_sects_shift)
+		return sect >> dev->zone_size_sects_shift;
+
+	return div64_u64(sect, dev->zone_size_sects);
 }
 
 static inline void null_lock_zone_res(struct nullb_device *dev)
@@ -65,10 +68,6 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	sector_t sector = 0;
 	unsigned int i;
 
-	if (!is_power_of_2(dev->zone_size)) {
-		pr_err("zone_size must be power-of-two\n");
-		return -EINVAL;
-	}
 	if (dev->zone_size > dev->size) {
 		pr_err("Zone size larger than device capacity\n");
 		return -EINVAL;
@@ -86,9 +85,14 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
 	dev_capacity_sects = mb_to_sects(dev->size);
 	dev->zone_size_sects = mb_to_sects(dev->zone_size);
-	dev->nr_zones = round_up(dev_capacity_sects, dev->zone_size_sects)
-		>> ilog2(dev->zone_size_sects);
 
+	if (is_power_of_2(dev->zone_size_sects))
+		dev->zone_size_sects_shift = ilog2(dev->zone_size_sects);
+	else
+		dev->zone_size_sects_shift = 0;
+
+	dev->nr_zones =	DIV_ROUND_UP_SECTOR_T(dev_capacity_sects,
+					      dev->zone_size_sects);
 	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct nullb_zone),
 				    GFP_KERNEL | __GFP_ZERO);
 	if (!dev->zones)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

