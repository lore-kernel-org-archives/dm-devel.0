Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B08E2C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 16:00:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-mIrjDKK8PM6h7e03lkihGQ-1; Wed, 25 May 2022 11:59:58 -0400
X-MC-Unique: mIrjDKK8PM6h7e03lkihGQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 364A33C0D194;
	Wed, 25 May 2022 15:59:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DB10340CFD0B;
	Wed, 25 May 2022 15:59:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 95F01194EB8F;
	Wed, 25 May 2022 15:59:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 208A8194EB82
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 May 2022 15:50:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 158722026D07; Wed, 25 May 2022 15:50:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 10FCC2026D64
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9FC429DD99F
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:07 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-lLAfn105OwOQ2Vep0RYTLg-1; Wed, 25 May 2022 11:50:06 -0400
X-MC-Unique: lLAfn105OwOQ2Vep0RYTLg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220525155004euoutp01ee2e25ab1bfaf3d16ee35dcc584c4c6f~yY9rgaCG30414604146euoutp01C
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220525155004euoutp01ee2e25ab1bfaf3d16ee35dcc584c4c6f~yY9rgaCG30414604146euoutp01C
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220525155003eucas1p2a7c20e3afb1e439dfd265ea1aa7fa777~yY9p0V1-R0965609656eucas1p2D;
 Wed, 25 May 2022 15:50:03 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id BC.5B.10009.B205E826; Wed, 25
 May 2022 16:50:03 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220525155002eucas1p140ca05edf5219f38e8f1a45801c2ed62~yY9pVc3d-1064210642eucas1p1p;
 Wed, 25 May 2022 15:50:02 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220525155002eusmtrp1ec4acfdd9bb2e4d1110f65446f4f7953~yY9pUNjfc1510315103eusmtrp17;
 Wed, 25 May 2022 15:50:02 +0000 (GMT)
X-AuditID: cbfec7f2-e95ff70000002719-3b-628e502babe3
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id BA.17.09522.A205E826; Wed, 25
 May 2022 16:50:02 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220525155002eusmtip1994e3f4509e63f9dac1bc8358a0fcfad~yY9o4AQn_1835018350eusmtip1B;
 Wed, 25 May 2022 15:50:01 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, snitzer@redhat.com,
 Johannes.Thumshirn@wdc.com, hch@lst.de, hare@suse.de
Date: Wed, 25 May 2022 17:49:52 +0200
Message-Id: <20220525154957.393656-4-p.raghav@samsung.com>
In-Reply-To: <20220525154957.393656-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsWy7djP87raAX1JBuf6WSxW3+1ns/h99jyz
 xd53s1ktLvxoZLK4eWAnk8WeRZOYLFauPspk8WT9LGaLngMfWCz+dt1jsth7S9vi8q45bBbz
 lz1lt7gx4SmjxeelLewWbRu/MjoIePw7sYbN4/LZUo9NqzrZPDYvqffYfbOBzWNn631Wj/f7
 rrJ59G1ZxeixfstVFo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlbF5dz9rQaNYxa+z
 j5gaGPuEuhg5OSQETCT+PJjG1MXIxSEksIJRYknfanYI5wujxJmb3xlBqoQEPjNKXDsV3cXI
 Adbx/ZUXRM1yoJoFsxkhnBeMEls+r2YFKWIT0JJo7AQbJCLQyCgx9eUJsCJmgdlMEvO+TQab
 KiwQIdE3ZQEziM0ioCrxdtsjsDivgJXE1qUrWSHuk5eYeek7O4jNKWAtMX//Z2aIGkGJkzOf
 sIDYzEA1zVtnM4MskBBYzSnx8vRMZohmF4lTL2ZBDRKWeHV8CzuELSNxenIPC4RdLfH0xm+o
 5hZGif6d69kg/rSW6DuTA2IyC2hKrN+lD1HuKHHqai8rRAWfxI23ghAn8ElM2jadGSLMK9HR
 Bg1dJYmdP59ALZWQuNw0B2qph8TRE22MExgVZyF5ZhaSZ2Yh7F3AyLyKUTy1tDg3PbXYMC+1
 XK84Mbe4NC9dLzk/dxMjMAGe/nf80w7Gua8+6h1iZOJgPMQowcGsJMJ74WlvkhBvSmJlVWpR
 fnxRaU5q8SFGaQ4WJXHe5MwNiUIC6YklqdmpqQWpRTBZJg5OqQamKcs2nVJPuqtzfNPehYFW
 CYcPTvrd1Vvzbc+UqLb8fcej+ze7sh1YcU/wmrpA/a3tM1fW7lWdWOLnnZe/SfFD1lrZx6dm
 bTk8+dmc/o+PuRhWrC5b+cB269T+t8mCLhrbFR4+K7Q9qz9/g8tB/2tchaERjWks/b7m2r8N
 Nxy587nn/40XN67FS6qKKDGHLfVz8jp366HH9ZXm11oDzlq9nnaxZLXX6iMPb7LXmofGvzZv
 Zeqsuf6FVVX9kVWui+KyPcK+FuXLijsvO59J37/hRrNBdlrfkfiDs88LZN7/rC3TnnbaZ/Fn
 697bh4od92xa9fNDYtb61RtKT9x9abZaxXfenXObfLb/vMDzYU5h4E0lluKMREMt5qLiRACR
 SfxG7wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t/xu7paAX1JBk/2yVusvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbnFjwlNGi89LW9gt2jZ+ZXQQ8Ph3Yg2bx+WzpR6bVnWyeWxeUu+x+2YDm8fO1vusHu/3
 XWXz6NuyitFj/ZarLB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/I
 xFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2Pz7n7Wgkaxil9nHzE1MPYJdTFycEgImEh8f+XV
 xcjFISSwlFHi1LfFzF2MnEBxCYnbC5sYIWxhiT/XuthAbCGBZ4wSqw+kgfSyCWhJNHayg/SK
 CHQySszZ1wrmMAssZ5J4/mkR2CBhgTCJuyd62UFsFgFVibfbHoEN5RWwkti6dCUrxAJ5iZmX
 voPVcApYS8zf/5kZYpmVxNc7X1kh6gUlTs58wgJiMwPVN2+dzTyBUWAWktQsJKkFjEyrGEVS
 S4tz03OLDfWKE3OLS/PS9ZLzczcxAmN127Gfm3cwznv1Ue8QIxMH4yFGCQ5mJRHeC097k4R4
 UxIrq1KL8uOLSnNSiw8xmgLdPZFZSjQ5H5gs8kriDc0MTA1NzCwNTC3NjJXEeT0LOhKFBNIT
 S1KzU1MLUotg+pg4OKUamPY3hSXcU3l/KfBNS/5Tfqc3E0WnLD0WOCnhsKBQ0zEJkcuHp6WE
 dlZGJf+XLtZziaixF/7uuYw5evnUPYcn5UjsO5G0LEAmVFjfqIUp/nuI7Z19OsZH7Ga/4uXP
 acmsOCi+ZlvrsdV7z3LM8Z9YsHhCnrRuaW60kIivt1b6gcMuNR1eYeebTouZHJqiUSli/Zvj
 eovW++2nfi1OWHlupWsFr6RZtcj6g4WdsfwdD5SNzXNOzjQ3WGUaZKyT+O7P7aCtj6caVG5K
 UqspOiwzV+2yRhHjlCmrvZ99s5VPyd/stGvl2idbZrftdHR8yxI1qSueIXTJOy6f5Xfel+88
 HpJy/MbG05Mutz9Y88xmhxJLcUaioRZzUXEiACNXaLVeAwAA
X-CMS-MailID: 20220525155002eucas1p140ca05edf5219f38e8f1a45801c2ed62
X-Msg-Generator: CA
X-RootMTR: 20220525155002eucas1p140ca05edf5219f38e8f1a45801c2ed62
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220525155002eucas1p140ca05edf5219f38e8f1a45801c2ed62
References: <20220525154957.393656-1-p.raghav@samsung.com>
 <CGME20220525155002eucas1p140ca05edf5219f38e8f1a45801c2ed62@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v6 3/8] nvme: zns: Allow ZNS drives that have
 non-power_of_2 zone size
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove the condition which disallows non-power_of_2 zone size ZNS drive
to be updated and use generic method to calculate number of zones
instead of relying on log and shift based calculation on zone size.

The power_of_2 calculation has been replaced directly with generic
calculation without special handling. Both modified functions are not
used in hot paths, they are only used during initialization &
revalidation of the ZNS device.

As rounddown macro from math.h does not work for 32 bit architectures,
round down operation is open coded.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/host/zns.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 9f81beb4df4e..d92f937d5cb9 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -101,13 +101,6 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
 	}
 
 	ns->zsze = nvme_lba_to_sect(ns, le64_to_cpu(id->lbafe[lbaf].zsze));
-	if (!is_power_of_2(ns->zsze)) {
-		dev_warn(ns->ctrl->device,
-			"invalid zone size:%llu for namespace:%u\n",
-			ns->zsze, ns->head->ns_id);
-		status = -ENODEV;
-		goto free_data;
-	}
 
 	blk_queue_set_zoned(ns->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
@@ -128,8 +121,13 @@ static void *nvme_zns_alloc_report_buffer(struct nvme_ns *ns,
 	const size_t min_bufsize = sizeof(struct nvme_zone_report) +
 				   sizeof(struct nvme_zone_descriptor);
 
+	/*
+	 * Division is used to calculate nr_zones with no special handling
+	 * for power of 2 zone sizes as this function is not invoked in a
+	 * hot path
+	 */
 	nr_zones = min_t(unsigned int, nr_zones,
-			 get_capacity(ns->disk) >> ilog2(ns->zsze));
+			 div64_u64(get_capacity(ns->disk), ns->zsze));
 
 	bufsize = sizeof(struct nvme_zone_report) +
 		nr_zones * sizeof(struct nvme_zone_descriptor);
@@ -182,6 +180,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	int ret, zone_idx = 0;
 	unsigned int nz, i;
 	size_t buflen;
+	u64 remainder = 0;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
 		return -EINVAL;
@@ -197,7 +196,11 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	c.zmr.zrasf = NVME_ZRASF_ZONE_REPORT_ALL;
 	c.zmr.pr = NVME_REPORT_ZONE_PARTIAL;
 
-	sector &= ~(ns->zsze - 1);
+	/*
+	 * Round down the sector value to the nearest zone start
+	 */
+	div64_u64_rem(sector, ns->zsze, &remainder);
+	sector -= remainder;
 	while (zone_idx < nr_zones && sector < get_capacity(ns->disk)) {
 		memset(report, 0, buflen);
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

