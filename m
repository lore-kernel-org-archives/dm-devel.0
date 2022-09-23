Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C918C04A95
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954601;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FeXsgVSaKTlZ8GW+gCZFeY2z0WmxRw8Xh22VzpvV2Mo=;
	b=enU6wPvVl16g5QRHh/BNhdGjv8bnvipvwatNoQIL/1PsS+nZWkgxbPAjb+ju8Qf7BYAL5/
	hp07JKsgWa6xE7Trc87UBJxRTURUp0PS/p7VB+yCoUoWTrtr7z1EGDDIZ8yLVCpzY7N/dW
	jmMaByIsGMAgvtjyE5iLO6SybIU4d3M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-8aAV0LBPN36voaIWRH0e6g-1; Fri, 23 Sep 2022 13:36:37 -0400
X-MC-Unique: 8aAV0LBPN36voaIWRH0e6g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BE6F85A5A6;
	Fri, 23 Sep 2022 17:36:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 169AEC15BAB;
	Fri, 23 Sep 2022 17:36:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F2B7819465B7;
	Fri, 23 Sep 2022 17:36:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D008A1946A42
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C11D9492B09; Fri, 23 Sep 2022 17:36:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B9522492B05
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CA192A5954A
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:33 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-C9Wbn6yYNXiFZsYksN4cSw-1; Fri, 23 Sep 2022 13:36:31 -0400
X-MC-Unique: C9Wbn6yYNXiFZsYksN4cSw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173629euoutp011634e06c7e74938f6327489e4fecd08e~XjeIETMte1804318043euoutp01J
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220923173629euoutp011634e06c7e74938f6327489e4fecd08e~XjeIETMte1804318043euoutp01J
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220923173627eucas1p1ff1805506d496509b0b02acd06fb440c~XjeGBXmV61386913869eucas1p1L;
 Fri, 23 Sep 2022 17:36:27 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id BF.1F.07817.A9EED236; Fri, 23
 Sep 2022 18:36:26 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220923173626eucas1p2e06c400ad3c18fe8f33c0b4ab1a25bf0~XjeFYwQ4O2090620906eucas1p2p;
 Fri, 23 Sep 2022 17:36:26 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220923173626eusmtrp187736ea990ce7390114c40622ac154b9~XjeFX9u8c1032310323eusmtrp1a;
 Fri, 23 Sep 2022 17:36:26 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-35-632dee9ad0cd
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 8B.78.07473.A9EED236; Fri, 23
 Sep 2022 18:36:26 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173625eusmtip190df0be3e8ba67115133d440c9dc35fd~XjeE-W8SQ0836708367eusmtip1T;
 Fri, 23 Sep 2022 17:36:25 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:11 +0200
Message-Id: <20220923173618.6899-7-p.raghav@samsung.com>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsWy7djPc7qz3ukmGzR9NbdYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9JounV2cxWey9pW1x
 edccNov5y56yW0xo+8pscWPCU0aLz0tb2C3W3HzKYnHilrSDsMflK94eO2fdZfe4fLbUY9Oq
 TjaPzUvqPXbfbGDz6G1+x+axs/U+q8f7fVfZPPq2rGL02Hy62uPzJjmP9gPdTAG8UVw2Kak5
 mWWpRfp2CVwZjRP+MBe8kqk4sfU3UwPjLokuRk4OCQETiRfrJjJ1MXJxCAmsYJT49fk2G4Tz
 hVGi5e0NdgjnM6PExwf3GGFaDixYANWynFFixtwnjBDOS6CqeddZuxg5ONgEtCQaO9lBGkQE
 0iWOb70JNolZYBuzxJ/j68BqhAUiJT6384LUsAioSsy/2sUMYvMKWEhs/jWPGWKZvMTMS9/Z
 Qco5BSwl+htrIEoEJU7OfMICYjMDlTRvnc0MMl5C4BSnxPIzT5lB6iUEXCROdddBjBGWeHV8
 CzuELSNxenIPC4RdLfH0xm+o3hZGif6d69kgeq0l+s7kgJjMApoS63fpQ5Q7SsyZeR2qgk/i
 xltBiAv4JCZtmw61lFeio00IolpJYufPJ1BLJSQuN82BWuohcWTPdcYJjIqzkPwyC8kvsxD2
 LmBkXsUonlpanJueWmyUl1quV5yYW1yal66XnJ+7iRGYIE//O/5lB+PyVx/1DjEycTAeYpTg
 YFYS4U25qJssxJuSWFmVWpQfX1Sak1p8iFGag0VJnJdthlaykEB6YklqdmpqQWoRTJaJg1Oq
 gak81kZxla/l0sy4PYWPufnLHLar9N+LzhbeqXGbw9v4wRLdhhUac+Zpm3e3Lf/wyKOtr3T/
 Iceb2kvfuaz2SHspHdr07FLtQbdXnw/cqO0rePT1vYnCs0OpxQ9yHrft/Ry+n/fjo6ZXRs7u
 C81z9L0f7fwltO4Kj/aTL3+LZvpOdtvTdEl3+q/KS6xL9G6s2cn85odBwsd/GySLDJWm2hzL
 0p1e9fKdx9X2ORz2Tw4J/NoZ5K7LcF5L1uBr0L7VuSeatu0smj375cb+a7nfDR/oX9JdGlvN
 uzh9i3yasL5K0hPzV6v+fcxLXC/iGjQtyZBD7PUNqYz9pz3Ta/con5/wuCH4cbST57YNRQKd
 kiVKLMUZiYZazEXFiQCDgrhs/wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t/xu7qz3ukmG5xr4rFYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9JounV2cxWey9pW1x
 edccNov5y56yW0xo+8pscWPCU0aLz0tb2C3W3HzKYnHilrSDsMflK94eO2fdZfe4fLbUY9Oq
 TjaPzUvqPXbfbGDz6G1+x+axs/U+q8f7fVfZPPq2rGL02Hy62uPzJjmP9gPdTAG8UXo2Rfml
 JakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZjRP+MBe8kqk4
 sfU3UwPjLokuRk4OCQETiQMLFjB1MXJxCAksZZT4cOQHG0RCQuL2wiZGCFtY4s+1LjaIoueM
 Et+mdwF1cHCwCWhJNHayg9SICORKHFt7jxWkhlngGLPEtK/rmEASwgLhEleuXgIrYhFQlZh/
 tYsZxOYVsJDY/GseM8QCeYmZl76zg8zkFLCU6G+sAQkLAZWcX/yIHaJcUOLkzCcsIDYzUHnz
 1tnMExgFZiFJzUKSWsDItIpRJLW0ODc9t9hQrzgxt7g0L10vOT93EyMwnrcd+7l5B+O8Vx/1
 DjEycTAeYpTgYFYS4U25qJssxJuSWFmVWpQfX1Sak1p8iNEU6OyJzFKiyfnAhJJXEm9oZmBq
 aGJmaWBqaWasJM7rWdCRKCSQnliSmp2aWpBaBNPHxMEp1cAkpnLk5469v1Q0JgYd6irdV8Ni
 NVVyroO6wxVrpvr0Q9sdAxgvz9C6uddj7qNzX96LblOz3lPeHmTuV1bbW/bz4pU65gdW5neq
 8xil2H1Ezhme5M00deCWztTmlPlaIjsr/8rCe8p8oYdms8/IOeT//JyIsjLnDlOJsMnNp56E
 3jpW/2KS1MtKKS3W/5Uff+7b4n235rjXxRKfz7/f1Ts9Lr+3J/mNiPNC4f7NB5Zp7WQLvptR
 dkh+uk3GXyuX8zprTE7O3J1Y7rgs6NbFUxO2/XdZtPU439ykf/z7qs9MnswtfGaSa0mL+IKt
 m5WWOK0o6khu3Kdf3dZSLHiS68a66gd3t230u8Dg9DfGb4mfEktxRqKhFnNRcSIAqv51w3AD
 AAA=
X-CMS-MailID: 20220923173626eucas1p2e06c400ad3c18fe8f33c0b4ab1a25bf0
X-Msg-Generator: CA
X-RootMTR: 20220923173626eucas1p2e06c400ad3c18fe8f33c0b4ab1a25bf0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173626eucas1p2e06c400ad3c18fe8f33c0b4ab1a25bf0
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173626eucas1p2e06c400ad3c18fe8f33c0b4ab1a25bf0@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v15 06/13] null_blk: allow zoned devices with non
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the power-of-2(po2) based calculation with zone size to be generic
in null_zone_no with optimization for po2 zone sizes.

The nr_zones calculation in null_init_zoned_dev has been replaced with a
division without special handling for po2 zone sizes as this function is
called only during the initialization and will not be invoked in the hot
path.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/block/null_blk/main.c     |  5 ++---
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/block/null_blk/zoned.c    | 18 +++++++++++-------
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 1f154f92f4c2..3b24125d8594 100644
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

