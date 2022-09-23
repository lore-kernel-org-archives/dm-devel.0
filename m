Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 736E5C04A95
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954604;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4lMGY7l0ydKW54nfZUaveVqR3g2fMMGLOcmcFwBtR9k=;
	b=epGzSixca5FlsjDe1Eq2dFYHS8NHeLtemQLVyAdsx6gl+rHzu/8J6qWrWUybm3J4qbAxSb
	ljGovtIm7wmShfkWNvGJ+wRtdFOWF4KkjYetdD/KGlb3G46qWnpXB02og9XQIre05+wCHY
	y/namyx47SxB8MralsGQdzZ7jY5dQQA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-eEj6IrWNOsS1uxWN7qAA7w-1; Fri, 23 Sep 2022 13:36:41 -0400
X-MC-Unique: eEj6IrWNOsS1uxWN7qAA7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BDB985A5A6;
	Fri, 23 Sep 2022 17:36:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7AB0140C6EC6;
	Fri, 23 Sep 2022 17:36:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5386819465B9;
	Fri, 23 Sep 2022 17:36:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AAEAF19465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9B263C15BA8; Fri, 23 Sep 2022 17:36:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 92EC2C15E76
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79BCA858F17
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:38 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-ww2Lqp9QNQeRWHNyDL2FeA-1; Fri, 23 Sep 2022 13:36:36 -0400
X-MC-Unique: ww2Lqp9QNQeRWHNyDL2FeA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173635euoutp01991c31a60675dbd55ba6752d5008b65f~XjeOIzo-u1804318043euoutp01U
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220923173635euoutp01991c31a60675dbd55ba6752d5008b65f~XjeOIzo-u1804318043euoutp01U
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220923173634eucas1p15d0c1608b4c0efd95f989e325a915af0~XjeM1-aSI2513525135eucas1p1r;
 Fri, 23 Sep 2022 17:36:34 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 5E.6E.29727.2AEED236; Fri, 23
 Sep 2022 18:36:34 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220923173632eucas1p1a4b8cba427f5caf649009073233f8c76~XjeLimBqq2513525135eucas1p1q;
 Fri, 23 Sep 2022 17:36:32 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220923173632eusmtrp13854486833f22d618200f13baf4c2cd5~XjeLh37De1032310323eusmtrp1d;
 Fri, 23 Sep 2022 17:36:32 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-39-632deea2fe1a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 9E.78.07473.0AEED236; Fri, 23
 Sep 2022 18:36:32 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173632eusmtip211f1590d2e57e40d00dcceafdff445f6~XjeLM6tMh2300023000eusmtip2m;
 Fri, 23 Sep 2022 17:36:32 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:17 +0200
Message-Id: <20220923173618.6899-13-p.raghav@samsung.com>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf0xTVxjNfbf0Pao1rwXlBjZ1zZbNGlDTLXtmzK0bi88tmbC4P6aL0rQv
 gGuLebUTdHPoGJudCgFFWnUah8WWkSatAkWrTY1tAdFoLaHyu5ZAWURn1yzMAePxWOZ/5zvf
 Od/5vptLQGl/SiZRot/LsHqVViYUCVr903eyL0xlq9ebL5KUo8sPqebBaiFV/3QaUs977kLK
 M3U6hYp43Rh17UItRtmab2FUzGGB1IxpCKM8D9dSoY4zQuqcdQynaqqSkEpcrMSp3yJjAir4
 MOt9CR168AnttgzidKjHSDvtR4S0q/E7+mqkQki7fxhOoZ9cDwvp45ftgHZ1H6ATzpX0j96f
 sfyl20W5GkZb8jXDrttUKCr+OzwC93StKJtzVMEKMCM1AYJA5JtoqGa3CYgIKXkJIH98AvLF
 nwD1VB8GJpA6XyQAehaUcJgzjEejGC9qAujJIwvkRXGABp6u4qYKSTk6dATn6HSyCAWuRHBO
 D8lWDFWZ3QKukUbmozrfwEKAgHwN3bDehZxXTG5Eo64lfNYqZL7/F87RqfN09aFvOFpMSlCn
 ObYwBc5Lvr9yemFnRDpS0U2PE+O9eciXOAF4nIYmA5dxHr+EuuuOCnh8AI31PV80VwJU7XYI
 +Vd5Bx2/reUgJNcgR8c6Xq5E8X+CGK9YhvoeS/gVlqHa1lOQp8Xopyopr5Yh93RsMRSh0OEz
 i6E06h3tBzXgFcsLx1heOMbyf+55AO0ggzEadEWMYYOe2ZdjUOkMRn1RjrpU5wTz/697NvCs
 HZyd/CPHBzAC+AAioCxdrLmXrZaKNary/Qxbuos1ahmDD2QRAlmGWNggV0vJItVe5iuG2cOw
 /3UxIjWzArPoT1kVO77tvX2j5zOb7eTnU72e8daymY/v7wisVuV88G5By+tJrE3rqls/NNK8
 NNkuz2//dVL5yC/PDA5Hx28yJWz67i/f2rxP1jWRa49GZkuHjykGO+dqP5w56FzeONd0KaMt
 t+OLJdvrt06fAyA9YcPPV86qw9YHmvhI24nCky97P5ImC6+ZjNtqvE3Drk/LJeHHZZpdv3sV
 oq2s5mD5yuz9TPJVZZqCCDesWbuFMd3bpsP63IG8+omjWXlvl29WVL7XMNBfXMZODCk7PcrR
 RF80ris4Zl/xS1bLxvydDdY3mr1Xg2rflgJX7GzIJsfCLY2xO2ZU4V+9aQRnZQJDsWqDHLIG
 1b/TLN9G7gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xe7oL3ukmGyzeb2Kx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW3xe2sJusebmUxaLE7ekHQQ9Ll/x9tg56y67x+WzpR6bVnWyeWxeUu+x+2YD
 m8fO1vusHu/3XWXz6NuyitFj8+lqj8+b5DzaD3QzBfBE6dkU5ZeWpCpk5BeX2CpFG1oY6Rla
 WugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GX8uvqAueCUWMX/9W3MDYx/hboYOTkkBEwk
 nj96xNTFyMUhJLCUUeL9la+sEAkJidsLmxghbGGJP9e62CCKnjNKHDp1n7mLkYODTUBLorGT
 HaRGRCBX4tjae6wgNcwCR5gk2nbfB0sIC/hJLGq9AWazCKhK7F92HqyXV8BS4uFmboj58hIz
 L31nBwlzAoX7G2tAwkICFhLnFz8C6+QVEJQ4OfMJC4jNDFTevHU28wRGgVlIUrOQpBYwMq1i
 FEktLc5Nzy021CtOzC0uzUvXS87P3cQIjNdtx35u3sE479VHvUOMTByMhxglOJiVRHhTLuom
 C/GmJFZWpRblxxeV5qQWH2I0Bbp6IrOUaHI+MGHklcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJ
 pCeWpGanphakFsH0MXFwSjUw8Zutv11bxcCZvtZkrdK8HZuvz+lo+uhzbbpmYJ2At8dfngtB
 SatnHd3rkTX7RXxnu1Dah8m+su7LLOomfVhScsBrVWZbsPt7ZzvutoJVE7ee3mBbGr7baGuk
 7nPec2mhGYu3qSdJXOUp6s7o47eP+OR8k1v1OnNNfVC+e6nwfaVH74rKOJWE1i8Rzqtwui9t
 cnHuEps1E/eWqbgJWu07ftC3dP1/fb5Jhb9O3dlouGT1ik8Fx44umftlkUTecYGFXK1ezucy
 reQebymqObJkgvT6G/+y5iwUen6V/eQ6d5EmZ51r/wMjhS1vro3Wu785QNVL1HvXYl3Db9zz
 Lvy8p/P9fJrhvwOevvMMZ/9oVmIpzkg01GIuKk4EAHsGhVBgAwAA
X-CMS-MailID: 20220923173632eucas1p1a4b8cba427f5caf649009073233f8c76
X-Msg-Generator: CA
X-RootMTR: 20220923173632eucas1p1a4b8cba427f5caf649009073233f8c76
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173632eucas1p1a4b8cba427f5caf649009073233f8c76
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173632eucas1p1a4b8cba427f5caf649009073233f8c76@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v15 12/13] dm: introduce DM_EMULATED_ZONES target
 feature flag
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
 dm-devel@redhat.com, Johannes.Thumshirn@wdc.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce a new target feature flag: DM_EMULATED_ZONES for targets with
a different number of sectors per zone (aka zone size) than the underlying
device zone size.

This target feature flag is introduced as the existing zoned targets assume
that the target and the underlying device have the same zone size.
The new target: dm-po2zoned will use this new target feature flag
as it emulates the zone boundary that is different from the underlying
zoned device.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-table.c         | 13 ++++++++++---
 include/linux/device-mapper.h |  9 +++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 38b83c383e8f..8324bd660f09 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1619,13 +1619,20 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
 	return true;
 }
 
-static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
+/*
+ * Callback function to check for device zone sector across devices. If the
+ * DM_TARGET_EMULATED_ZONES target feature flag is not set, then the target
+ * should have the same zone sector as the underlying devices.
+ */
+static int check_valid_device_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
 					   sector_t start, sector_t len, void *data)
 {
 	unsigned int *zone_sectors = data;
 
-	if (!bdev_is_zoned(dev->bdev))
+	if (!bdev_is_zoned(dev->bdev) ||
+	    dm_target_supports_emulated_zones(ti->type))
 		return 0;
+
 	return bdev_zone_sectors(dev->bdev) != *zone_sectors;
 }
 
@@ -1650,7 +1657,7 @@ static int validate_hardware_zoned_model(struct dm_table *t,
 	if (!zone_sectors)
 		return -EINVAL;
 
-	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
+	if (dm_table_any_dev_attr(t, check_valid_device_zone_sectors, &zone_sectors)) {
 		DMERR("%s: zone sectors is not consistent across all zoned devices",
 		      dm_device_name(t->md));
 		return -EINVAL;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index f8e3a96b97b0..8504da98e829 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -294,6 +294,15 @@ struct target_type {
 #define dm_target_supports_mixed_zoned_model(type) (false)
 #endif
 
+#ifdef CONFIG_BLK_DEV_ZONED
+#define DM_TARGET_EMULATED_ZONES	0x00000400
+#define dm_target_supports_emulated_zones(type) \
+	((type)->features & DM_TARGET_EMULATED_ZONES)
+#else
+#define DM_TARGET_EMULATED_ZONES	0x00000000
+#define dm_target_supports_emulated_zones(type) (false)
+#endif
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

