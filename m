Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14533C3814E
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 12:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661257160;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WUE7dgwVJ9T/s0VaXCy1hFziKF51mI6O9pUY7zXPIKg=;
	b=TlszPiOQyMYauVumfUD/KQ++wt3+skbVi32bGjkfDeAIHSVlpn9HVsO94SkqcobwhFz7eH
	KPuk2UVYkFACjS4W0ieZ0gHK9Y8awnQRa8MOxcvgEab8k4KZ0XPFJ680lFqIJfFjXx8r3p
	kpd1ecSaIiTaWo8Mk8uqF/Aa+ZNOo+I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-y4OWG8UgNnGg1pWQu-F69Q-1; Tue, 23 Aug 2022 08:19:16 -0400
X-MC-Unique: y4OWG8UgNnGg1pWQu-F69Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3222229DD991;
	Tue, 23 Aug 2022 12:19:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1F566492C3B;
	Tue, 23 Aug 2022 12:19:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0547A1946A47;
	Tue, 23 Aug 2022 12:19:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 02C911946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 12:19:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC0502166B2A; Tue, 23 Aug 2022 12:19:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E78192166B26
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBD3B382ECD7
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:13 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-tGeIEzBvMniFczy5JG38oQ-1; Tue, 23 Aug 2022 08:19:11 -0400
X-MC-Unique: tGeIEzBvMniFczy5JG38oQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220823121910euoutp01b746d92f587cf3c25e2578052f1cec7d~N_JOq7I441946919469euoutp01V
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220823121910euoutp01b746d92f587cf3c25e2578052f1cec7d~N_JOq7I441946919469euoutp01V
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220823121908eucas1p27f2127263e2af4e2b8857a3cfc1b7969~N_JMm3e2P2413924139eucas1p2o;
 Tue, 23 Aug 2022 12:19:08 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id DB.82.29727.CB5C4036; Tue, 23
 Aug 2022 13:19:08 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220823121907eucas1p27664a441113cb557af8fce3ef2800e34~N_JMGP0hN2415624156eucas1p2F;
 Tue, 23 Aug 2022 12:19:07 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220823121907eusmtrp21f6442a1b3bae68f057c358297d87160~N_JMFKWjZ2697126971eusmtrp2i;
 Tue, 23 Aug 2022 12:19:07 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-89-6304c5bcb881
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id C5.12.07473.BB5C4036; Tue, 23
 Aug 2022 13:19:07 +0100 (BST)
Received: from localhost (unknown [106.210.248.52]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220823121907eusmtip216d80b6051329442a5bf0ffbaa5d553e~N_JLz4EDR1999619996eusmtip2N;
 Tue, 23 Aug 2022 12:19:07 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 23 Aug 2022 14:18:52 +0200
Message-Id: <20220823121859.163903-7-p.raghav@samsung.com>
In-Reply-To: <20220823121859.163903-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsWy7djPc7p7jrIkGyw7KGax/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCeKyyYlNSezLLVI3y6BK6Oz
 ia3guHTFjdZzrA2My8W7GDk5JARMJF4dXsfexcjFISSwglHia/d3JgjnC6PEvasXWCGcz4wS
 D45sYYJpuXRhL1TVckaJ4zuuQjkvGCVWbfzB2MXIwcEmoCXR2MkO0iAikC7x9esGRhCbWeAO
 k8S367kgtrBApMSz6cuZQWwWAVWJp99fsIHYvAJWEueOLWSFWCYvMfPSd7A5nALWEvOWnmKE
 qBGUODnzCQvETHmJ5q2zmUFukBDYzCkx5dYUdpAbJARcJO62mEDMEZZ4dXwLO4QtI/F/53yo
 Z6olnt74DdXbwijRv3M9G0SvtUTfmRwQk1lAU2L9Ln2IckeJwy8vsUBU8EnceCsIcQGfxKRt
 05khwrwSHW1CENVKEjt/PoFaKiFxuWkOC4TtIbHk5iPmCYyKs5D8MgvJL7MQ9i5gZF7FKJ5a
 WpybnlpsmJdarlecmFtcmpeul5yfu4kRmAxP/zv+aQfj3Fcf9Q4xMnEwHmKU4GBWEuGtvsiQ
 LMSbklhZlVqUH19UmpNafIhRmoNFSZw3OXNDopBAemJJanZqakFqEUyWiYNTqoGJdeXf69a8
 /ZVTl6Xw9M3TmCR8lofRsPfO9rZf3baNOyT109WdQsX8T+6N2cW67mL93g0JTPurBH/f3b21
 9v7zDTv2zL7t//+K70b9DO2q99d7LtmdmxVnNmP6EbvvHq90djbZ7wnjTflzYFKCiqgtR3l6
 +45Hj3cosLuasBRzLzgwTTtcROR0mvVkU2U3JSEb/7h/IqfvL3ymo3aroT58ws3vK1xS0+eL
 vr75JePo6RZ/Dvbte/seT/T7fmK1u3iv8vGmzD/i68/b7rCLmrj0FsdTaSWFZwG/f2WHH7c4
 1f+7x2JZ1jddn+ptz7dLGeYeuXX8bUf+/tape/7/KPm07qO2r2aXfVh/ncf1JH8dJZbijERD
 Leai4kQAJfWo2PUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t/xe7q7j7IkG2zZZWSx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina
 0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL6Ozia3guHTFjdZzrA2My8W7GDk5
 JARMJC5d2MvUxcjFISSwlFHiz8e7jBAJCYnbC5ugbGGJP9e62CCKnjFK/J76HCjBwcEmoCXR
 2MkOUiMikCtxePMEsEHMAm+YJI7+a2EFqREWCJd4eLQEpIZFQFXi6fcXbCA2r4CVxLljC1kh
 5stLzLz0HWwOp4C1xLylp8D2CgHVzL/1CapeUOLkzCcsIDYzUH3z1tnMExgFZiFJzUKSWsDI
 tIpRJLW0ODc9t9hQrzgxt7g0L10vOT93EyMwcrcd+7l5B+O8Vx/1DjEycTAeYpTgYFYS4a2+
 yJAsxJuSWFmVWpQfX1Sak1p8iNEU6O6JzFKiyfnA1JFXEm9oZmBqaGJmaWBqaWasJM7rWdCR
 KCSQnliSmp2aWpBaBNPHxMEp1cC0RHle1ZyoV9wSMYzpkYvuxm7KrW75Kb3gac7PzIlTjTlW
 p1yKnMp37F1AaaBd08X/7d8VK+o+1Wtebiq2nnJn1hThXZ/nnHl7+53i2XvPf60LTb40Rc/5
 0rfAg4ulYp/fSed9LBm2Z3WGQfmDe+cLnT99WPwy8Yhg6KX3mc0/t2scEp2sH/twm4rwLVWF
 tuNmj+q61y8SOuble6JPaN/PCh33zfX/N92U7FsWlxzz2KB6S1vLiZgYA7fWzC1Bek9yZnVc
 tNQ/q39HpeiZHle4WrW1xEn1h1zBk34cNT7w6cyqkyUhbusU/E/V8+puXOPeF2z++JRx3vGZ
 /7onrF8hGPy2du0O3oPrF2hGdvyRUWIpzkg01GIuKk4EAIOFNLhlAwAA
X-CMS-MailID: 20220823121907eucas1p27664a441113cb557af8fce3ef2800e34
X-Msg-Generator: CA
X-RootMTR: 20220823121907eucas1p27664a441113cb557af8fce3ef2800e34
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121907eucas1p27664a441113cb557af8fce3ef2800e34
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121907eucas1p27664a441113cb557af8fce3ef2800e34@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH v12 06/13] null_blk: allow zoned devices with non
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
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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

