Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3262CC6FA86
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970959;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JaWYRO+wBl92lETMgFe/niaE2HtBRCpxPnKkyTVc6iw=;
	b=OijemwoT/vaIK6WHjUa6H7SjmANFpuP+xy6iDG0Qi+svzIxdSBFEIZHq8cZSn5m2CEylhd
	G+u+zPs7rhY/suwtCJSeU6bVqBjaijmqnngSYYhr+H+dKr7TBEcA+fdiRbFRrPgVmSwAx3
	EDUNI+38MtRzl003YEJTgZfH9+96Mus=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-DUCfgvDAO4e5SP5LKpjtnQ-1; Mon, 12 Sep 2022 04:22:36 -0400
X-MC-Unique: DUCfgvDAO4e5SP5LKpjtnQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79D223810780;
	Mon, 12 Sep 2022 08:22:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5BB424B3FC6;
	Mon, 12 Sep 2022 08:22:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18E801946A43;
	Mon, 12 Sep 2022 08:22:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D939A1946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 937C0140EBF4; Mon, 12 Sep 2022 08:22:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F5C2140EBF3
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 710C0185A7BA
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:30 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-ZrpDNQTkNsWWzJfGFMz2NA-1; Mon, 12 Sep 2022 04:22:28 -0400
X-MC-Unique: ZrpDNQTkNsWWzJfGFMz2NA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082212euoutp013b960d013e4cbef3ddc69c2b0edcf4d6~UD0CbLbZT1510715107euoutp012
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220912082212euoutp013b960d013e4cbef3ddc69c2b0edcf4d6~UD0CbLbZT1510715107euoutp012
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220912082209eucas1p2069cce282a374a5a253ecba71b2b97d9~UDz-xGiYK3082430824eucas1p2D;
 Mon, 12 Sep 2022 08:22:09 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 0C.46.07817.13CEE136; Mon, 12
 Sep 2022 09:22:09 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220912082209eucas1p2747fa09635df54a6c76821585776672f~UDz-Rgzrq2521325213eucas1p2J;
 Mon, 12 Sep 2022 08:22:09 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220912082209eusmtrp115ccb9dbe793be17fad981d513ee7bf9~UDz-QtHke1301813018eusmtrp1X;
 Mon, 12 Sep 2022 08:22:09 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-ab-631eec31ac18
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id A6.2F.07473.13CEE136; Mon, 12
 Sep 2022 09:22:09 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082208eusmtip2a0feeb2bf2cebe4277077635b3fe4c0e~UDz_6zPMg2614326143eusmtip22;
 Mon, 12 Sep 2022 08:22:08 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:21:54 +0200
Message-Id: <20220912082204.51189-4-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7djPc7qGb+SSDaZsUrVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlfGs
 fwF7wWv1iv5LG9gbGHcodDFyckgImEgsubaRqYuRi0NIYAWjxObVrVDOF0aJe9v/M0M4nxkl
 /n34ywzTsubTWajEckaJk5vmMkI4LxklLj1/DdTPwcEmoCXR2MkO0iAikC7xffo7sLHMAneY
 JJoOvWAESQgLxEgs23SDBcRmEVCVWLXlN1icV8BS4sj540wQ2+QlZl76DjaIU8BK4vWqVqga
 QYmTM5+A9TID1TRvnQ12kYTAdk6JzWu/sYAcISHgInFpiiLEHGGJV8e3sEPYMhKnJ/ewQNjV
 Ek9v/IbqbWGU6N+5ng2i11qi70wOiMksoCmxfpc+RLmjxJkv+5ghKvgkbrwVhLiAT2LStulQ
 YV6JjjYhiGoliZ0/n0AtlZC43DQHaqmHxONju9kmMCrOQvLLLCS/zELYu4CReRWjeGppcW56
 arFRXmq5XnFibnFpXrpecn7uJkZgQjz97/iXHYzLX33UO8TIxMF4iFGCg1lJhJfFUDpZiDcl
 sbIqtSg/vqg0J7X4EKM0B4uSOG9y5oZEIYH0xJLU7NTUgtQimCwTB6dUA1P3G5OTwZMTeDUs
 Y/yvZSgp/1vQ+olr5ryUl1FfK06+vZrvE7hr/X67zsDdq8UWPrU8vdNH8MZGlrAniv0Sl1TT
 MjN7pFYoBeRNPz1Bd1f5pVSxo80tRv/O1UybfPt0ZN81ncOrNcQCtobkL5go+mllvuK5w7cM
 9p157Pfw71erTS/Eus++vLWeedKVSZsY3plmz3DVCnFVFZoarvDh7SrT/Xei3mx8JV9z5+i7
 itglp/f6GJqvLbU+NPvW18ceNZdtii563u4r1Dr5e5nHveJVxx4wf740bXnRv0d/rz7sX7fo
 vdm5nNJ/YXGM/hY5WlscLOpXX9dbqJHM99jQv8f/oS7zpfQlRzUVvwk472r7rcRSnJFoqMVc
 VJwIAGXly8j3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xe7qGb+SSDU7/ZbNYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl/GsfwF7wWv1iv5LG9gbGHcodDFy
 ckgImEis+XSWuYuRi0NIYCmjxPk5R1khEhIStxc2MULYwhJ/rnWxQRQ9Z5TY/O8XUIKDg01A
 S6Kxkx2kRkQgV+Lzyh9gNcwCb5gkviyZxASSEBaIkni27iDYUBYBVYlVW36DDeUVsJQ4cv44
 E8QCeYmZl76DDeIUsJJ4vaoVrEYIqObstxvsEPWCEidnPmEBsZmB6pu3zmaewCgwC0lqFpLU
 AkamVYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIHRu+3Yz807GOe9+qh3iJGJg/EQowQHs5II
 L4uhdLIQb0piZVVqUX58UWlOavEhRlOguycyS4km5wPTR15JvKGZgamhiZmlgamlmbGSOK9n
 QUeikEB6YklqdmpqQWoRTB8TB6dUA5PpzKily17tcr02zW7huo2hi2Z3hEevuBZrM61z98yf
 yzh+6Df+uWITOrHos/X7LU/reo0e3av8Nr9l12vezXflvvh8PBGWaru/IIBj8cZFCvs3V9/d
 kPflDn9aY3aSD4/lpNVH3dQfJk8Nvq7msqjazfpN/O/sOVHVxTPF3vJ4tbC7sMraJYru6LrW
 G9bKGr02xfi9XLJJ7E2vKSabX7VodqgeYvP9Irh3K0sha7Re+GfTTS9rL9SfO6Fxon5flMat
 Uw1aO29MzyiyYNldqHFBLyhM9PfaqNYwzgqtH0ITtpn5PGxacccvmf3NHP6PTFZfWqxqtMRv
 vJv28qDy83VLSpsevbO9wfJrzf//j3SUWIozEg21mIuKEwHIh7jNZwMAAA==
X-CMS-MailID: 20220912082209eucas1p2747fa09635df54a6c76821585776672f
X-Msg-Generator: CA
X-RootMTR: 20220912082209eucas1p2747fa09635df54a6c76821585776672f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082209eucas1p2747fa09635df54a6c76821585776672f
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082209eucas1p2747fa09635df54a6c76821585776672f@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v13 03/13] block: allow blk-zoned devices to have
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
index fe6b27e3a513..291149289178 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -560,7 +560,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
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

