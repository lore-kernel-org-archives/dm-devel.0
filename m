Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFAB0ECAAD8
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=d971tQL1JyuTpbcPM1hJsol/Cf8AHYxwk5SLUPbduKI=;
	b=TxaPNrWl6anfyF6GT1TuS7a6kEaOTtO9VSIL3BV85jypRBr9yxF3jNzEwOPp74LPE+gncG
	CyUa8bXCxnVKf6AKUkXWbnU/9AHOvvaHZPpDRfBdvD//G8UcVPzxg49sJZhqwrmzVkzyf2
	YXHmHwFtAFuLuxvOIVvC5vc4eAga+Vw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-6N8_1sd2PP6_y8uU_BId7Q-1; Tue, 20 Sep 2022 05:11:29 -0400
X-MC-Unique: 6N8_1sd2PP6_y8uU_BId7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9AE4101CC62;
	Tue, 20 Sep 2022 09:11:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6FCB940C2064;
	Tue, 20 Sep 2022 09:11:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4749919465A3;
	Tue, 20 Sep 2022 09:11:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C49A719465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B7D1A207B358; Tue, 20 Sep 2022 09:11:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC886207B352
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BBF9811731
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:26 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-oKFW2UrKNXytv29TO9pEqw-1; Tue, 20 Sep 2022 05:11:24 -0400
X-MC-Unique: oKFW2UrKNXytv29TO9pEqw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091123euoutp021e6868138a9c8b5537485dcbcd004dd1~WhpRCZvWR2728427284euoutp02z
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220920091123euoutp021e6868138a9c8b5537485dcbcd004dd1~WhpRCZvWR2728427284euoutp02z
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220920091121eucas1p103009200aafc074a4cce236c7c679199~WhpPPo5Zi2943429434eucas1p1i;
 Tue, 20 Sep 2022 09:11:21 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id B5.7E.07817.9B389236; Tue, 20
 Sep 2022 10:11:21 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220920091121eucas1p26eed14714ff34e2489bc9adb40fd1250~WhpO06NM21326413264eucas1p2F;
 Tue, 20 Sep 2022 09:11:21 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220920091121eusmtrp1c83228127090016395d1eae78540352c~WhpOz-7Oe0149701497eusmtrp1b;
 Tue, 20 Sep 2022 09:11:21 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-0c-632983b91a15
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 6D.43.10862.9B389236; Tue, 20
 Sep 2022 10:11:21 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091120eusmtip15e511ee5d7f407eefa560381f7bf2446~WhpOe4QOy1211712117eusmtip1i;
 Tue, 20 Sep 2022 09:11:20 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:07 +0200
Message-Id: <20220920091119.115879-2-p.raghav@samsung.com>
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01SYUwTZxj2u7ter93KzgLxi25s1BgDc9Uxf3xBFAxuHvJj08XF+KPsKDfE
 Aboenc7+GNCKUCaiLFYKDsSNQt0Gax2zFkxTUlGrIbOyUCpjk9apyboRWqAyzWyPZf573/d5
 nvd5ny8fhctnRCupssoqTlPJlitIKTFwNTb6hkOfod5gs2ci03A66rtxFUcXJk+Q6PTfMRwt
 3hrF0VC4TYT8LgeGBrtOYaj3ggdDwT4zjp4Yf8VQaMyMoaGJ15HvcjuJOrpDYtRcF8XReHMI
 oNlvDGL0rT9EoGsTq/JSGN+dQsZhnhQzvltaxmZtIBn7158zTn81yRzXh0nGcXRKxPx1ZYxk
 mi5aAWP36phZWxpzzNWIvSfbK80p4crLPuU067d8KN3n9c8QBz2ph89N94iqQbXcCCgK0huh
 zfiSEUgpOd0D4N0nEZHQRACs+aWGFJpZAO1zXxJGIEkoOkZ8mABYANQvLOBxQE4/BHB4bF18
 LUlnwpoGcXycQpfCaLQfxPk4HcThlGUSiwPJdDE843QmlhL0GtjyszUhkNHZ8MGdY0AwexW2
 3p5PzCX0JtjuNJACZzm83hpMaPFnHP2PbXjcANI3JHC6RzgI0tvgoieACXUyfDRyUSzUL0Nv
 yxdLaXQwNL64JDYAeMLRRwoPswk23SyPlzidAfsurxfoW2Fosh4TGElw/M/lwglJ8NSACRfG
 MlhfJxfYCuiIBZdMIfTVti+ZMvDB3ad4M0g3PxfG/FwY8/++nQC3ghWclq8o5fisSu6Qkmcr
 eG1lqVJ9oMIGnv1K79ORyCVgeTSjdAOMAm4AKVyRIjO8m6GWy0rYz45wmgNFGm05x7vBKopQ
 rJCpy/pZOV3KVnEfc9xBTvMfilGSldXYnvHWjXmD6Mz+wVRy2dtop9y01qB7XBjklWztjvm3
 VH5Lka7GfX9XgaTTMmrd0Jt/iFX+4ArMa/v3Zw9Zknaz6rPfnaSzi7MKXlut2kFEU9OYV5bt
 eqFLceToJ3UerXMheD/3n47+rN9U3+f/7ry3d862oMxZezpX5MSlbtb3jukjhabQNdMytT06
 cDuneXW3ize2ndvWEDNNv3i4YS57dI02efuegisqSZVJZf9DEbgeILXhSF5j5+N1bn1aVyi/
 fWDzxGbeEbiWYizOOZ6u+qC+tzZ8D4R/KtSdt9APv9LzkeLGrbk3i2Ld7xMn80tiW0LTw7ub
 itTeSwadR0Hw+9g3M3ENz/4Li2TSMQQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t/xu7o7mzWTDXZ+57GYfljRYv2pY8wW
 q+/2s1lM+/CT2eL32fPMFnvfzWa1uHlgJ5PFnkWTmCxWrj7KZPFk/Sxmi79d95gsnl6dxWSx
 95a2xeVdc9gs5i97ym4xoe0rs8WNCU8ZLT4vbWG3WHPzKYvFiVvSDiIel694e+ycdZfd4/LZ
 Uo9NqzrZPDYvqffYfbOBzaO3+R2bx87W+6we7/ddZfPo27KK0WPz6WqPz5vkPNoPdDMF8Ebp
 2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXoZZy++ZGl
 4KhoxcLHK1gbGBuEuhg5OSQETCTmH7/M1MXIxSEksJRRom3fbiaIhITE7YVNjBC2sMSfa11s
 EEXPGSXuPvoKVMTBwSagJdHYyQ5SIyKQK3F48wSwXmaBL8wSL9sDQWxhgQSJd8ebWEFsFgFV
 ickXV4HV8wpYSby40g41X15i5qXvYHFOAWuJObtb2EBsIaCajlmb2SDqBSVOznzCAjFfXqJ5
 62zmCYwCs5CkZiFJLWBkWsUoklpanJueW2ykV5yYW1yal66XnJ+7iREY19uO/dyyg3Hlq496
 hxiZOBgPMUpwMCuJ8Lb4ayYL8aYkVlalFuXHF5XmpBYfYjQFunsis5Rocj4wseSVxBuaGZga
 mphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTAZnhBZHDivft6hY/Irq5n7+G2m
 uaZUah6YbJcg9tvfdtnUdTI+Ci091YZsz/YfYLvhuSvw0lPth/stcveY6uySni50Ny7h3rnX
 syeYPDy/3tzOU7jl8KmiynT9H4mOPRx2NzjCUgo/r8sV76xfpWw381dqQcYNI0dHOYfgqf+7
 2LdVNwjM/Ll7z52KtocXUnRsN/7YW/DRaeb/9l8as/gsHpycvHGWtLCgxKyLNmdYHMM6Bbd9
 Of3M+NwureerS89dsDyx55zw5fdLWr27ZK8VGqw+ceCzsfGPA/w2vxjv8ofrVjJo7lbT1GRq
 8F8w3/TL2q3H1/zYI2LgK6A32f7DZ6uZJ7+GyuQHct2+8n63EktxRqKhFnNRcSIAXeSXOHQD
 AAA=
X-CMS-MailID: 20220920091121eucas1p26eed14714ff34e2489bc9adb40fd1250
X-Msg-Generator: CA
X-RootMTR: 20220920091121eucas1p26eed14714ff34e2489bc9adb40fd1250
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091121eucas1p26eed14714ff34e2489bc9adb40fd1250
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091121eucas1p26eed14714ff34e2489bc9adb40fd1250@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v14 01/13] block: make bdev_nr_zones and
 disk_zone_no generic for npo2 zone size
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
 Adam Manzanares <a.manzanares@samsung.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Adapt bdev_nr_zones and disk_zone_no functions so that they can
also work for non-power-of-2 zone sizes.

As the existing deployments assume that a device zone size is a power of
2 number of sectors, power-of-2 optimized calculation is used for those
devices.

There are no direct hot paths modified and the changes just
introduce one new branch per call.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-zoned.c      | 13 +++++++++----
 include/linux/blkdev.h |  8 +++++++-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a264621d4905..dce9c95b4bcd 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -111,17 +111,22 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
  * bdev_nr_zones - Get number of zones
  * @bdev:	Target device
  *
- * Return the total number of zones of a zoned block device.  For a block
- * device without zone capabilities, the number of zones is always 0.
+ * Return the total number of zones of a zoned block device, including the
+ * eventual small last zone if present. For a block device without zone
+ * capabilities, the number of zones is always 0.
  */
 unsigned int bdev_nr_zones(struct block_device *bdev)
 {
 	sector_t zone_sectors = bdev_zone_sectors(bdev);
+	sector_t capacity = bdev_nr_sectors(bdev);
 
 	if (!bdev_is_zoned(bdev))
 		return 0;
-	return (bdev_nr_sectors(bdev) + zone_sectors - 1) >>
-		ilog2(zone_sectors);
+
+	if (is_power_of_2(zone_sectors))
+		return (capacity + zone_sectors - 1) >> ilog2(zone_sectors);
+
+	return DIV_ROUND_UP_SECTOR_T(capacity, zone_sectors);
 }
 EXPORT_SYMBOL_GPL(bdev_nr_zones);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8038c5fbde40..6c6bf4dd5709 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -674,9 +674,15 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
 
 static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
 {
+	sector_t zone_sectors = disk->queue->limits.chunk_sectors;
+
 	if (!blk_queue_is_zoned(disk->queue))
 		return 0;
-	return sector >> ilog2(disk->queue->limits.chunk_sectors);
+
+	if (is_power_of_2(zone_sectors))
+		return sector >> ilog2(zone_sectors);
+
+	return div64_u64(sector, zone_sectors);
 }
 
 static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

