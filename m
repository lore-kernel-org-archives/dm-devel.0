Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F47C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 15:55:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-1LqjdWBNMkan3HfRqwEupg-1; Wed, 25 May 2022 11:55:50 -0400
X-MC-Unique: 1LqjdWBNMkan3HfRqwEupg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 640FE1066560;
	Wed, 25 May 2022 15:55:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 517187AD8;
	Wed, 25 May 2022 15:55:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2E213194EB83;
	Wed, 25 May 2022 15:55:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B3B90194EB82
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 May 2022 15:50:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 96C8B400F3E7; Wed, 25 May 2022 15:50:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 921B140C1240
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7901839F9CAA
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:12 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-bD75Of_SMTeF0W2LKYsEDQ-1; Wed, 25 May 2022 11:50:10 -0400
X-MC-Unique: bD75Of_SMTeF0W2LKYsEDQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220525155009euoutp01cb522b65e3bc81f7097a549515df687a~yY9vg9vV00414604146euoutp01H
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220525155009euoutp01cb522b65e3bc81f7097a549515df687a~yY9vg9vV00414604146euoutp01H
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220525155007eucas1p2185abd17ca07eb32c8ea94cfdafaacdd~yY9trtP3W2563825638eucas1p2j;
 Wed, 25 May 2022 15:50:07 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 2A.43.09887.F205E826; Wed, 25
 May 2022 16:50:07 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220525155006eucas1p13888214b1d9e23a26d04a75fbc5bf72b~yY9tDdGgB0654006540eucas1p1F;
 Wed, 25 May 2022 15:50:06 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220525155006eusmtrp1449a627ca162306b71ed53844a557768~yY9tCXqfN1510315103eusmtrp1H;
 Wed, 25 May 2022 15:50:06 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-70-628e502ff18c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 2E.17.09522.E205E826; Wed, 25
 May 2022 16:50:06 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220525155006eusmtip1be55a7f5deec1bf03df36d46d1ca929d~yY9suny0c1835018350eusmtip1E;
 Wed, 25 May 2022 15:50:06 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, snitzer@redhat.com,
 Johannes.Thumshirn@wdc.com, hch@lst.de, hare@suse.de
Date: Wed, 25 May 2022 17:49:55 +0200
Message-Id: <20220525154957.393656-7-p.raghav@samsung.com>
In-Reply-To: <20220525154957.393656-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djP87r6AX1JBr9mc1isvtvPZvH77Hlm
 i9b2b0wWe9/NZrW48KORyeLmgZ1MFnsWTWKyWLn6KJPFk/WzmC16DnxgsfjbdQ+o7pa2xeVd
 c9gs5i97ym5xY8JTRovPS1vYLdo2fmV0EPT4d2INm8fls6Uem1Z1snlsXlLvsftmA5vHztb7
 rB7v911l8+jbsorRY/2Wqywem09Xe3zeJOfRfqCbKYAnissmJTUnsyy1SN8ugSvj4ddDbAXN
 whXNC7rZGhhbBLoYOTgkBEwk7uyx6WLk5BASWMEo8eNpXBcjF5D9hVHiy+atLBDOZ0aJJdMn
 MoNUgTTcON/FDpFYziixf/tXNgjnBaPE2bal7CBj2QS0JBo7wYpEBBoZJaa+PMEI4jALHGWS
 uHZuChPIKGGBKImDR+aANbAIqErsmmgFEuYVsJJY2PuXEWKbvMTMS9/ZQWxOAWuJ+fs/M0PU
 CEqcnPmEBcRmBqpp3job6rr1nBJXTwVA2C4Sc3/dYIGwhSVeHd/CDmHLSJye3AMVr5Z4euM3
 M8htEgItjBL9O9ezQcLFWqLvTA6IySygKbF+lz5EuaPEkx+vmCAq+CRuvBWEuIBPYtK26cwQ
 YV6JjjYhiGoliZ0/n0AtlZC43DQHaqmHREfTH6YJjIqzkPwyC8kvsxD2LmBkXsUonlpanJue
 WmyUl1quV5yYW1yal66XnJ+7iRGYBk//O/5lB+PyVx/1DjEycTAeYpTgYFYS4b3wtDdJiDcl
 sbIqtSg/vqg0J7X4EKM0B4uSOG9y5oZEIYH0xJLU7NTUgtQimCwTB6dUA1Nwv3dG+RMzf6Vz
 q7e/93jZo/9+eV4LQxVTt8OPC1En/H+x/mA9sbgu6/zEKvlfry2+mm5RWtDCIOzx0U1F7XTh
 tA+8K7UWLo+Orjquc/bJnaNvDrQcOxa3VIXf5sTFcJa1Pj9faZTsklmam+xUEGT+YNX0jjxF
 H/v9Dyas38k4Xy30/M7vLx7XMzJZLGO5w3i1s9ko5MxvDs6nW052ed/waAz62Gz9mFvaXVJE
 aMtaYVFFrjWfSk5XBYpXrzjydIqMpGz/Gk8mlrSPUbtrez6Fr1XlyTujemBTyP37NWuDfiux
 /J+wpMf/VoHMqy1Hjj5vy7buie3P/C+UMfFn8Sn/OwZPPLXtP1lPOnNW7osSS3FGoqEWc1Fx
 IgAbKyd+8gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t/xu7p6AX1JBoc/yFmsvtvPZvH77Hlm
 i9b2b0wWe9/NZrW48KORyeLmgZ1MFnsWTWKyWLn6KJPFk/WzmC16DnxgsfjbdQ+o7pa2xeVd
 c9gs5i97ym5xY8JTRovPS1vYLdo2fmV0EPT4d2INm8fls6Uem1Z1snlsXlLvsftmA5vHztb7
 rB7v911l8+jbsorRY/2Wqywem09Xe3zeJOfRfqCbKYAnSs+mKL+0JFUhI7+4xFYp2tDCSM/Q
 0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1SN8uQS/j4ddDbAXNwhXNC7rZGhhbBLoYOTkkBEwk
 bpzvYu9i5OIQEljKKPF62VRWiISExO2FTYwQtrDEn2tdbBBFzxgl+t9uBCri4GAT0JJo7ARr
 FhHoZJSYs6+VHaSBWeAik8T5LgsQW1ggQmL7/A52kHoWAVWJXROtQMK8AlYSC3v/Qs2Xl5h5
 6TtYK6eAtcT8/Z+ZQWwhoJqvd76yQtQLSpyc+YQFYry8RPPW2cwTGAVmIUnNQpJawMi0ilEk
 tbQ4Nz232FCvODG3uDQvXS85P3cTIzBqtx37uXkH47xXH/UOMTJxMB5ilOBgVhLhvfC0N0mI
 NyWxsiq1KD++qDQntfgQoynQ2ROZpUST84FpI68k3tDMwNTQxMzSwNTSzFhJnNezoCNRSCA9
 sSQ1OzW1ILUIpo+Jg1OqgSmgQ6B37l+jWu67jxNaOkq3yPxweiFh1KG9dnvbrUoTtv8Kd31+
 Gen+ji/SLDx1/87f4Me6nQyNt17MZph9zPnQzc9RzFa8kzdKznR+cC7XceVn2wzt5R8armnO
 eHxHpSz2n+Cvup0z9+q5iizeNS9UYJcg9zdlhTT/etaEr/YJ26/7TItnXH3xW7kco7CMTL3m
 83vc4hzcm6eueSS6d/GFbpZFO/Kelax+sHBVfZ/arjBWntSOa81bt+rNEWtj+MG36dLirQVb
 0xtO/BKdHGuU9vfJzoYEx/PORn/eigi9eJPf3jb7doTcoQsrNvntdvs9RyFAK/zVRL7Pd2o2
 zDp3R5X34NoXX69/dL2rxlGsxFKckWioxVxUnAgA+pWRW2MDAAA=
X-CMS-MailID: 20220525155006eucas1p13888214b1d9e23a26d04a75fbc5bf72b
X-Msg-Generator: CA
X-RootMTR: 20220525155006eucas1p13888214b1d9e23a26d04a75fbc5bf72b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220525155006eucas1p13888214b1d9e23a26d04a75fbc5bf72b
References: <20220525154957.393656-1-p.raghav@samsung.com>
 <CGME20220525155006eucas1p13888214b1d9e23a26d04a75fbc5bf72b@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v6 6/8] null_blk: use zone_size_sects_shift for
 power of 2 zoned devices
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
Cc: Pankaj Raghav <p.raghav@samsung.com>,
 Damien Le Moal <damien.lemoal@wdc.com>, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Instead of doing is_power_of_2 and ilog2 operation for every IO, cache
the zone_size_sects_shift variable and use it for power of 2 zoned
devices.

This variable will be set to zero for non power of 2 zoned devices.

Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/block/null_blk/null_blk.h |  6 ++++++
 drivers/block/null_blk/zoned.c    | 11 ++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 78eb56b0ca55..3d6e41a9491f 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -74,6 +74,12 @@ struct nullb_device {
 	unsigned int imp_close_zone_no;
 	struct nullb_zone *zones;
 	sector_t zone_size_sects;
+	/*
+	 * zone_size_sects_shift is only useful when the zone size is
+	 * power of 2. This variable is set to zero when zone size is non
+	 * power of 2.
+	 */
+	unsigned int zone_size_sects_shift;
 	bool need_zone_res_mgmt;
 	spinlock_t zone_res_lock;
 
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index b79091b5e4b1..a8be1011def5 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -13,8 +13,8 @@ static inline sector_t mb_to_sects(unsigned long mb)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
-	if (is_power_of_2(dev->zone_size_sects))
-		return sect >> ilog2(dev->zone_size_sects);
+	if (dev->zone_size_sects_shift)
+		return sect >> dev->zone_size_sects_shift;
 
 	return div64_u64(sect, dev->zone_size_sects);
 }
@@ -82,9 +82,14 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
 	dev_capacity_sects = mb_to_sects(dev->size);
 	dev->zone_size_sects = mb_to_sects(dev->zone_size);
+
+	if (is_power_of_2(dev->zone_size_sects))
+		dev->zone_size_sects_shift = ilog2(dev->zone_size_sects);
+	else
+		dev->zone_size_sects_shift = 0;
+
 	dev->nr_zones =	DIV_ROUND_UP_SECTOR_T(dev_capacity_sects,
 					      dev->zone_size_sects);
-
 	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct nullb_zone),
 				    GFP_KERNEL | __GFP_ZERO);
 	if (!dev->zones)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

