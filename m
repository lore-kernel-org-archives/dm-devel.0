Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B7FCC25B07
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 09:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659520097;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6NlSrfVWjMn+L1jniD80iNTDZEvnLnuOkbSgbpAogEU=;
	b=Yo3JXcoq1X3cSol/Xii/E3waIEAcNAi1GVSTYuJ+xElcSjHhEfNaYsFfnh6SVUvoLR/zZb
	9FgDj8B/ZnTRgVwHMTU0k1x5EdwKllYtoh9h+OaZOOkegCIXG4FoFHwrI+SVKMBw9NWIFo
	zDKCTqeo74za7e4c5QLH2YejG8N1ef0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-D8XwpdK9Ne62pMTfKXCq1A-1; Wed, 03 Aug 2022 05:48:14 -0400
X-MC-Unique: D8XwpdK9Ne62pMTfKXCq1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E78A85A58D;
	Wed,  3 Aug 2022 09:48:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C725DC15D62;
	Wed,  3 Aug 2022 09:48:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 94C821946A60;
	Wed,  3 Aug 2022 09:48:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 124E41946A56
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 09:48:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 07E0940CFD0A; Wed,  3 Aug 2022 09:48:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 029D440CF8F0
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC2C2280F2B6
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:10 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-ngWSX8KsPsKKAnin3pO4-g-1; Wed, 03 Aug 2022 05:48:09 -0400
X-MC-Unique: ngWSX8KsPsKKAnin3pO4-g-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220803094808euoutp01e5b9313977df2198552e52de8608f7dc~HzLpHqD5n3207932079euoutp01g
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220803094808euoutp01e5b9313977df2198552e52de8608f7dc~HzLpHqD5n3207932079euoutp01g
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220803094806eucas1p28e4acaa00f0bcede2828c6f7798de3ea~HzLnfy-8w3120331203eucas1p2s;
 Wed,  3 Aug 2022 09:48:06 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 42.FF.09664.6544AE26; Wed,  3
 Aug 2022 10:48:06 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220803094805eucas1p1c68ba40d319331c2c34059f966ba2d83~HzLnD0WR_0754607546eucas1p16;
 Wed,  3 Aug 2022 09:48:05 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220803094805eusmtrp25e56a76f66728139fcf1a55fd7baa169~HzLnC2gES0985609856eusmtrp2u;
 Wed,  3 Aug 2022 09:48:05 +0000 (GMT)
X-AuditID: cbfec7f2-d97ff700000025c0-7f-62ea44563ea2
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id A1.9B.09038.5544AE26; Wed,  3
 Aug 2022 10:48:05 +0100 (BST)
Received: from localhost (unknown [106.210.248.112]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220803094805eusmtip19192ed3b0cdfd5c11a6f449fcf12697b~HzLmtXW9L2551225512eusmtip1e;
 Wed,  3 Aug 2022 09:48:05 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes.Thumshirn@wdc.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, agk@redhat.com, hch@lst.de
Date: Wed,  3 Aug 2022 11:47:51 +0200
Message-Id: <20220803094801.177490-4-p.raghav@samsung.com>
In-Reply-To: <20220803094801.177490-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7djPc7phLq+SDE7MErVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAldG/
 7yt7wS71ioOnPjI2MPYqdDFyckgImEg09v9l72Lk4hASWMEoMXniOSjnC6PEv+5mJgjnM6PE
 zNuzGWFaVnSvYwWxhQSWM0qs+1QOUfSSUeLP0QssXYwcHGwCWhKNnWCTRASaGSXu/u1hBXGY
 BQ4wSdzccosJpFtYIFri96LnYJNYBFQlZn37BdbMK2Al8fBIFsQyeYmZl76zg9icAtYSU/79
 YwaxeQUEJU7OfMICYjMD1TRvnc0MMl9CYDenxN99vcwQzS4S3283QtnCEq+Ob2GHsGUk/u+c
 zwRhV0s8vfEbqrmFUaJ/53o2kCMkgLb1nckBMZkFNCXW79KHKHeUOHjiAytEBZ/EjbeCECfw
 SUzaNp0ZIswr0dEmBFGtJLHz5xOopRISl5vmsEDYHhL7d/1hmcCoOAvJM7OQPDMLYe8CRuZV
 jOKppcW56anFhnmp5XrFibnFpXnpesn5uZsYgQnx9L/jn3Ywzn31Ue8QIxMH4yFGCQ5mJRHe
 Oy7Pk4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzJmduSBQSSE8sSc1OTS1ILYLJMnFwSjUwlSbc
 fXjX6ZZQ3bUktrLczbFCwreePzaNllv4cureksicdeaP7z+a6tZ3KCc9bKN0T8JsprTnPT9O
 lj5r6/qpY6B0b94c6SXTNn7rtvOcWnGTaVUhl5mD7rv5J4MXVf/x1luanzl1NsN5pavrrOU+
 +SjrzQ/3mq3ztV7j6yrrrNzDO+0Kipx3Zq7gXWB3fHFyz1qDEqfZUv6/2P4r/J674Cl7vJG1
 69z09gfT9uwIzvyy+Xe4QILW1d+Nh1JC7q9/o/bHbp3efvX3eyttgkQ/fLPcsu+AzwHuc6wG
 h4q2vpLh4F07z0v/Vuf09c4PK8399edtuT9TpU/hEof327XZHt9szq78n+t49d1cJu2ZTkos
 xRmJhlrMRcWJAAutTGH3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xu7qhLq+SDPb8NLZYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl9G/7yt7wS71ioOnPjI2MPYqdDFy
 ckgImEis6F7HCmILCSxllGg+XwgRl5C4vbCJEcIWlvhzrYuti5ELqOY5o0R/80WgBg4ONgEt
 icZOdpC4iEA3o8TlM+dYQRxmgXNMEnOePmAD6RYWiJSYfLyJGcRmEVCVmPXtFwtIM6+AlcTD
 I1kQC+QlZl76zg5icwpYS0z5948Z4iAriXV/Z4EdxysgKHFy5hMWEJsZqL5562zmCYwCs5Ck
 ZiFJLWBkWsUoklpanJueW2ykV5yYW1yal66XnJ+7iREYu9uO/dyyg3Hlq496hxiZOBgPMUpw
 MCuJ8N5xeZ4kxJuSWFmVWpQfX1Sak1p8iNEU6OyJzFKiyfnA5JFXEm9oZmBqaGJmaWBqaWas
 JM7rWdCRKCSQnliSmp2aWpBaBNPHxMEp1cDkcG06p8ZbJ7nSSP0Z4S/XKAjzljiH8Xx2K7ZQ
 Wq05a9LeO6dOrJJV3yMp770h8dPX7H8KfO0buCcyVdvnHLggqnQ++pPggsS1e6taec/eWbTn
 8QyzzmIV15cJM8rMjoYd1bJozdFY+G1z4rdrgQxC07ZMvajx+9nh905tjRd15+pa6iumKqi8
 mMR9+N78qUtUBE5IqPpnzOStmTx76T/39JU6gne/J2t6sX5MXm3+zvf5I11D5Y3f5zbZrZXd
 uMhbZMqfSV8yqwoMeSZkHerXdtgsut3+n5f+4T82959ELAmavFLpF9dpvf+RHnvPTKt5xfuc
 1fiBU9QjWav6Fx9Vmnm8/TvP1Aqfrf3IpmGpxFKckWioxVxUnAgAqxFEeGYDAAA=
X-CMS-MailID: 20220803094805eucas1p1c68ba40d319331c2c34059f966ba2d83
X-Msg-Generator: CA
X-RootMTR: 20220803094805eucas1p1c68ba40d319331c2c34059f966ba2d83
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094805eucas1p1c68ba40d319331c2c34059f966ba2d83
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094805eucas1p1c68ba40d319331c2c34059f966ba2d83@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v9 03/13] block: allow blk-zoned devices to have
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
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
index dce9c95b4bcd..665b822d13f9 100644
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
+			pr_err("%s: Invalid zone capacity: %lld with non power-of-2 zone size: %lld",
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
index 22f97427b60b..5aa15172299d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -709,6 +709,30 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
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
@@ -753,6 +777,12 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
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

