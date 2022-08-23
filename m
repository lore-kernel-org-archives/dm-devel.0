Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 935E3C32774
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 12:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661257157;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xVIEQyNNtvbnAvZ0ZrgBTJaj8CfMSKgsh/Eaq5/74ac=;
	b=C9nHP1uRDXnOSWWX2JAgDSHbGJ2MG1OaPQdMhzPArOrHGcR4AerxG4gc+inKrAcxevBDMQ
	7Xh9gXDK7hcx3IUnQn2FxNZzyBn5R5qs5qX7duYp4i6LiNmOLlsmrzQPYYhcrq2ScwwmnE
	gxq07eSGj3D3CA7lPWhL8yaoHvVqAS4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-E3F89YwjPdKgiVncO1W1Sw-1; Tue, 23 Aug 2022 08:19:14 -0400
X-MC-Unique: E3F89YwjPdKgiVncO1W1Sw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27455181822D;
	Tue, 23 Aug 2022 12:19:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC54F492CA4;
	Tue, 23 Aug 2022 12:19:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9044B1946A72;
	Tue, 23 Aug 2022 12:19:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E096F1946A47
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 12:19:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D434BC15BBD; Tue, 23 Aug 2022 12:19:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF522C15BBA
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B30458037AF
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:09 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-WIC-JMDjN0yWmzd74NcscA-1; Tue, 23 Aug 2022 08:19:07 -0400
X-MC-Unique: WIC-JMDjN0yWmzd74NcscA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220823121906euoutp0217408dcfaaa1f18d8f2f47ce4d0eeb6b~N_JLCGPFL1976219762euoutp02W
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220823121906euoutp0217408dcfaaa1f18d8f2f47ce4d0eeb6b~N_JLCGPFL1976219762euoutp02W
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220823121905eucas1p1f39bd50fe067f690862adf43d7bbc254~N_JJeRDYX1882118821eucas1p1S;
 Tue, 23 Aug 2022 12:19:05 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 8D.50.19378.8B5C4036; Tue, 23
 Aug 2022 13:19:05 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220823121904eucas1p1cdedb3e9af928e25564f46e70765d39b~N_JI5c1oD1882018820eucas1p1N;
 Tue, 23 Aug 2022 12:19:04 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220823121904eusmtrp29a25bb59733b2fac1c4ddd5df01d658f~N_JI4imLd2697126971eusmtrp2c;
 Tue, 23 Aug 2022 12:19:04 +0000 (GMT)
X-AuditID: cbfec7f5-a4dff70000014bb2-f7-6304c5b8e42f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id A1.12.07473.8B5C4036; Tue, 23
 Aug 2022 13:19:04 +0100 (BST)
Received: from localhost (unknown [106.210.248.52]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220823121904eusmtip1f6a95092ae470224621432dce1eb00fe~N_JIlEPTa0460904609eusmtip1R;
 Tue, 23 Aug 2022 12:19:04 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 23 Aug 2022 14:18:49 +0200
Message-Id: <20220823121859.163903-4-p.raghav@samsung.com>
In-Reply-To: <20220823121859.163903-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7djPc7o7j7IkG+zQt1h/6hizxeq7/WwW
 0z78ZLb4ffY8s8Xed7NZLW4e2MlksWfRJCaLlauPMlk8WT+L2eJv1z0mi723tC0u75rDZjF/
 2VN2iwltX5ktbkx4ymjxeWkLu8Wam09ZLE7cknYQ8rh8xdtj56y77B6Xz5Z6bFrVyeaxeUm9
 x+6bDWweO1vvs3q833eVzaNvyypGj82nqz0+b5LzaD/QzRTAE8Vlk5Kak1mWWqRvl8CVMeHO
 D+aC1+oVh6c/Z2pg3KHQxcjJISFgItFz+BVbFyMXh5DACkaJ6af7GCGcL4wSEy/1sUM4nxkl
 tjTcYoRpmXuiFyqxnFFi3rLLUP0vGCWaV00HynBwsAloSTR2soM0iAikS3z9ugGsmVngDpPE
 t+u5ILawQIzE7ic3mUFsFgFVicff17KB2LwCVhLbrq1lglgmLzHz0newOZwC1hLzlp5ihKgR
 lDg58wkLxEx5ieats5lBbpAQ2M4p8WPDV1aIZheJ3ZNXM0PYwhKvjm9hh7BlJP7vnA+1oFri
 6Y3fUM0tjBL9O9ezgTwgAbSt70wOiMksoCmxfpc+RLmjxP9jsxghKvgkbrwVhDiBT2LStunM
 EGFeiY42IYhqJYmdP59ALZWQuNw0hwXC9pDYOGMrywRGxVlInpmF5JlZCHsXMDKvYhRPLS3O
 TU8tNs5LLdcrTswtLs1L10vOz93ECEyHp/8d/7qDccWrj3qHGJk4GA8xSnAwK4nwVl9kSBbi
 TUmsrEotyo8vKs1JLT7EKM3BoiTOm5y5IVFIID2xJDU7NbUgtQgmy8TBKdXAtKlf+ojP5h4D
 pXVOwn/ZEzlaOpSP8dxxa3nuYfh4WXuYzgk56YzrnCIvphqWWTJNWPptq4HNQZUPWt/b52nb
 OVo8mDH3b3iP2pfXFpHJFcxTTaKP3Vo+S0Gz/LxV2a3NomWh+jdrPxycsIPp3Z3Lp8LEdswU
 K7XJDZ5weTbX26VGFVuuTUs4orMrNO7GpvatKz9pqMbVh6v5cTyIyK+91Kaz77KU9Zn8JWes
 /0x+x/+4fbaTkcWBu/VB5xViVwpOfNszW/Gt36Xnv8/8uDXdpNZdyr2qc79Y7NuD39JfhB6K
 v7Uwkv3BNob5Oe9u53yVzvnt2WXM8OH622/TnAtWaU5i4Wtfu+HSoynB/PIbGJVYijMSDbWY
 i4oTARUJtkr2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xu7o7jrIkG/w6LGGx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina
 0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2PCnR/MBa/VKw5Pf87UwLhDoYuR
 k0NCwERi7ole9i5GLg4hgaWMEs8XTWKBSEhI3F7YxAhhC0v8udbFBlH0jFHi9r1HzF2MHBxs
 AloSjZ3sIDUiArkShzdPYAKpYRZ4wyRx9F8LK0hCWCBK4uSbZrBBLAKqEo+/r2UDsXkFrCS2
 XVvLBLFAXmLmpe9ggzgFrCXmLT0FVi8EVDP/1ieoekGJkzOfgB3HDFTfvHU28wRGgVlIUrOQ
 pBYwMq1iFEktLc5Nzy021CtOzC0uzUvXS87P3cQIjN5tx35u3sE479VHvUOMTByMhxglOJiV
 RHirLzIkC/GmJFZWpRblxxeV5qQWH2I0Bbp7IrOUaHI+MH3klcQbmhmYGpqYWRqYWpoZK4nz
 ehZ0JAoJpCeWpGanphakFsH0MXFwSjUwrT2y9M/rT2+aHpsmCV+Yo7bqfE14UfW735LVvreX
 nz6fta/u5sV6++br0W8jiqZapiyffWU+O+deo7ttt6KMP6v7/r4Rxb3wmJ6I5rId9jzWK5Yt
 +bugftsTq4LfKmbrT7zn/lodwjfPpXXhJePnbOv0ZQoYfG/JxPkrJOYmd3NHXLGYsfeA5xHb
 dzPtp52qf2/76IawnuTaPz7Brx1CF2te/qOx2GKd9jYthpxCsbplCdaLZ1tuflHyzD01qjdM
 4M0uYd1GActzSjrp85pY7qVtkM1v592rcs3IcLsvk4rv2+on2hX7uBImrnzlFevQUzDLXaZ3
 6v9lP7bdEqsVfyb4YI0fy/wVx68pTu47oMRSnJFoqMVcVJwIAGskqoBnAwAA
X-CMS-MailID: 20220823121904eucas1p1cdedb3e9af928e25564f46e70765d39b
X-Msg-Generator: CA
X-RootMTR: 20220823121904eucas1p1cdedb3e9af928e25564f46e70765d39b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121904eucas1p1cdedb3e9af928e25564f46e70765d39b
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121904eucas1p1cdedb3e9af928e25564f46e70765d39b@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v12 03/13] block: allow blk-zoned devices to have
 non-power-of-2 zone size
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

Checking if a given sector is aligned to a zone is a common
operation that is performed for zoned devices. Add
bdev_is_zone_start helper to check for this instead of opencoding it
everywhere.

Convert the calculations on zone size to be generic instead of relying on
power-of-2(po2) based arithmetic in the block layer using the helpers
wherever possible.

The only hot path affected by this change for zoned devices with po2
zone size is in blk_check_zone_append() but bdev_is_zone_start() helper is
used to optimize the calculation for po2 zone sizes.

Finally, allow zoned devices with non po2 zone sizes provided that their
zone capacity and zone size are equal. The main motivation to allow zoned
devices with non po2 zone size is to remove the unmapped LBA between
zone capcity and zone size for devices that cannot have a po2 zone
capacity.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-core.c       |  2 +-
 block/blk-zoned.c      | 24 ++++++++++++++++++------
 include/linux/blkdev.h | 30 ++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a0d1104c5590..1cb519220ffb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -563,7 +563,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
-	if (bio->bi_iter.bi_sector & (bdev_zone_sectors(bio->bi_bdev) - 1) ||
+	if (!bdev_is_zone_start(bio->bi_bdev, bio->bi_iter.bi_sector) ||
 	    !bio_zone_is_seq(bio))
 		return BLK_STS_IOERR;
 
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index dce9c95b4bcd..6806c69c81dc 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -285,10 +285,10 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_op op,
 		return -EINVAL;
 
 	/* Check alignment (handle eventual smaller last zone) */
-	if (sector & (zone_sectors - 1))
+	if (!bdev_is_zone_start(bdev, sector))
 		return -EINVAL;
 
-	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
+	if (!bdev_is_zone_start(bdev, nr_sectors) && end_sector != capacity)
 		return -EINVAL;
 
 	/*
@@ -486,14 +486,26 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	 * smaller last zone.
 	 */
 	if (zone->start == 0) {
-		if (zone->len == 0 || !is_power_of_2(zone->len)) {
-			pr_warn("%s: Invalid zoned device with non power of two zone size (%llu)\n",
-				disk->disk_name, zone->len);
+		if (zone->len == 0) {
+			pr_warn("%s: Invalid zero zone size", disk->disk_name);
+			return -ENODEV;
+		}
+
+		/*
+		 * Non power-of-2 zone size support was added to remove the
+		 * gap between zone capacity and zone size. Though it is technically
+		 * possible to have gaps in a non power-of-2 device, Linux requires
+		 * the zone size to be equal to zone capacity for non power-of-2
+		 * zoned devices.
+		 */
+		if (!is_power_of_2(zone->len) && zone->capacity < zone->len) {
+			pr_err("%s: Invalid zone capacity %lld with non power-of-2 zone size %lld",
+			       disk->disk_name, zone->capacity, zone->len);
 			return -ENODEV;
 		}
 
 		args->zone_sectors = zone->len;
-		args->nr_zones = (capacity + zone->len - 1) >> ilog2(zone->len);
+		args->nr_zones = div64_u64(capacity + zone->len - 1, zone->len);
 	} else if (zone->start + args->zone_sectors < capacity) {
 		if (zone->len != args->zone_sectors) {
 			pr_warn("%s: Invalid zoned device with non constant zone size\n",
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84e7881262e3..d0d66a0db224 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -704,6 +704,30 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
 	return div64_u64(sector, zone_sectors);
 }
 
+static inline sector_t bdev_offset_from_zone_start(struct block_device *bdev,
+						   sector_t sec)
+{
+	sector_t zone_sectors = bdev_zone_sectors(bdev);
+	u64 remainder = 0;
+
+	if (!bdev_is_zoned(bdev))
+		return 0;
+
+	if (is_power_of_2(zone_sectors))
+		return sec & (zone_sectors - 1);
+
+	div64_u64_rem(sec, zone_sectors, &remainder);
+	return remainder;
+}
+
+static inline bool bdev_is_zone_start(struct block_device *bdev, sector_t sec)
+{
+	if (!bdev_is_zoned(bdev))
+		return false;
+
+	return bdev_offset_from_zone_start(bdev, sec) == 0;
+}
+
 static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
 {
 	if (!blk_queue_is_zoned(disk->queue))
@@ -748,6 +772,12 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
 {
 	return 0;
 }
+
+static inline bool bdev_is_zone_start(struct block_device *bdev, sector_t sec)
+{
+	return false;
+}
+
 static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
 {
 	return 0;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

