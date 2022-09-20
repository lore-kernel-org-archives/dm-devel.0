Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E9BC6FA93
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665096;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jYzdiaMygmDNXhxHCjJztMa6r2vdfG4mCD2mtL8gMg4=;
	b=JHhwJ5HxxZ9OfyCnRtJ2P3H6t5GBwJtpXNrAcK5b25zgJuwhdma/ymE+5c7yO9BwiLSUsK
	nsKG9qF6h3afd/mcEC0qEIh8vTSU8N77jH17Ok/YbEu96q6TMgneugv5T1H6TjkIMoXtN4
	yTBPkPrdRZA8fkIg1LU7q77c545TS4c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-JsFurcPPM4yWHGcL_tMjXg-1; Tue, 20 Sep 2022 05:11:32 -0400
X-MC-Unique: JsFurcPPM4yWHGcL_tMjXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4B9D3C0D845;
	Tue, 20 Sep 2022 09:11:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BDD2B40C2064;
	Tue, 20 Sep 2022 09:11:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AF3DB19465A3;
	Tue, 20 Sep 2022 09:11:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A45219465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4EB26492CA5; Tue, 20 Sep 2022 09:11:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 46B4B492CA2
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 279B11C09C97
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:29 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-ykcBmDY5O3OHAWHJ9w7Dqg-1; Tue, 20 Sep 2022 05:11:27 -0400
X-MC-Unique: ykcBmDY5O3OHAWHJ9w7Dqg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091126euoutp02f74979bfe6f0e063e06e3e4cb1765913~WhpTXCmoa2726527265euoutp028
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220920091126euoutp02f74979bfe6f0e063e06e3e4cb1765913~WhpTXCmoa2726527265euoutp028
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220920091124eucas1p102ad33837cae27d699ac953192547133~WhpRVTGFa0663106631eucas1p15;
 Tue, 20 Sep 2022 09:11:24 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 89.7E.07817.BB389236; Tue, 20
 Sep 2022 10:11:23 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220920091123eucas1p26623d067c9a2d36d4f3b29b77c6d937a~WhpQ0a95g1342313423eucas1p2A;
 Tue, 20 Sep 2022 09:11:23 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220920091123eusmtrp26710eecbd8e562a5cb4a9ac136b8583e~WhpQzVwYj2413024130eusmtrp2H;
 Tue, 20 Sep 2022 09:11:23 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-15-632983bb847f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 1E.FD.07473.BB389236; Tue, 20
 Sep 2022 10:11:23 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091123eusmtip22af2dafe4828f945165c1b6928bc58bd~WhpQjceU22352523525eusmtip2-;
 Tue, 20 Sep 2022 09:11:23 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:09 +0200
Message-Id: <20220920091119.115879-4-p.raghav@samsung.com>
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsWy7djP87q7mzWTDa4ut7RYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlXF+
 9x6mgpUaFXcnf2JvYPyo0MXIySEhYCKx8vU91i5GLg4hgRWMEl+O/mWEcL4wSrw8uZEJwvnM
 KHHqySFWmJZ1l6YzQySWM0ocuPIdynnJKNF74wpbFyMHB5uAlkRjJztIg4hAusTXrxvAxjIL
 TGSWeDj7EwtIQlggRuLz839MIDaLgKrE15nNYHFeASuJ568XQG2Tl5h56TvYIE4Ba4k5u1vY
 IGoEJU7OfAJWzwxU07x1NtgREgLbOSU2tHexQTS7SLz48w9qkLDEq+Nb2CFsGYn/O+czQdjV
 Ek9v/IZqbmGU6N+5HuwDCaBtfWdyQExmAU2J9bv0IcodJY6cuAtVwSdx460gxAl8EpO2gQIF
 JMwr0dEmBFGtJLHz5xOopRISl5vmsEDYHhJzzm9jnsCoOAvJM7OQPDMLYe8CRuZVjOKppcW5
 6anFRnmp5XrFibnFpXnpesn5uZsYgSnx9L/jX3YwLn/1Ue8QIxMH4yFGCQ5mJRHeFn/NZCHe
 lMTKqtSi/Pii0pzU4kOM0hwsSuK8yZkbEoUE0hNLUrNTUwtSi2CyTBycUg1MAuXPX8bcddXf
 esT3TlFBTHt5Vq3fLbunF21CvuWv8Qn6NTH3lZJLy8QH9y5sraqs3za3UZ6fv8AqdI3jrpZ/
 cx/duyOV9mGXc+2z02WNOm5PK997zrWbuWOV2Ym1eZfyP/zWb62bUtleYzfbecLsc2ITv3hG
 fbphOfO12WWVzbJ7EhPZTr3ZEWPyb/GysvX5nM4VIr9ydwotv7n142/L+g8zrm2cLdg65wHf
 +Rm/Jxn5rRS/s0XqXvHe7G0CJrdnek+f6sf47OkBu/2XkxdP1Vv884Du/29plXrLjwduPjbh
 y3YWP7XrKVfuP+/Rb9He5/WbxbTnyALF3p+yYiF33rz2VfGutmZYs+RjuIii/QUlluKMREMt
 5qLiRACFxZWi+AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xe7q7mzWTDZ5eELNYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl3F+9x6mgpUaFXcnf2JvYPyo0MXI
 ySEhYCKx7tJ05i5GLg4hgaWMEm9//WWESEhI3F7YBGULS/y51sUGUfScUeL56g1ADgcHm4CW
 RGMnO0iNiECuxOHNE5hAapgF5jNL7Pr3FiwhLBAlMfndBFYQm0VAVeLrzGYWEJtXwEri+esF
 rBAL5CVmXvoOVs8pYC0xZ3cLG4gtBFTTMWszG0S9oMTJmU/AepmB6pu3zmaewCgwC0lqFpLU
 AkamVYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIHRu+3Yz807GOe9+qh3iJGJg/EQowQHs5II
 b4u/ZrIQb0piZVVqUX58UWlOavEhRlOguycyS4km5wPTR15JvKGZgamhiZmlgamlmbGSOK9n
 QUeikEB6YklqdmpqQWoRTB8TB6dUA9MkrhR+r+Sm47+2Nf3aaeNpr7XXfWfPetnNLVEtPILz
 XjCmzjDQY9+yqvJp34wN4QcNn68UEPmoJyl5Sfr6wdvz5rREpOf47qmLuVrS3OutO2fu8Qtp
 Hh9nKSWoPHNj8/4mbbyvOeZDSHr5l1r7+xZu+s9NRJdYGr39/v7zmpeq1jXZrCe+SJd93HM5
 c+9rpVN1WaHr0s6HHU8zfBRV917F9sZimel+V9adzZuyOjMywcRZynD5BA2e5fd+Liixa3j7
 Yb72O/8yOf3Aq6YKGTEpXuFzjrwJWtJ23ED8SlXlWwm3nxeFty91P70uc5XY5m+K/wLkJURK
 NuXwW7zLeWi9PMRgWTZj7OaPWtenJCmxFGckGmoxFxUnAgC96tQqZwMAAA==
X-CMS-MailID: 20220920091123eucas1p26623d067c9a2d36d4f3b29b77c6d937a
X-Msg-Generator: CA
X-RootMTR: 20220920091123eucas1p26623d067c9a2d36d4f3b29b77c6d937a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091123eucas1p26623d067c9a2d36d4f3b29b77c6d937a
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091123eucas1p26623d067c9a2d36d4f3b29b77c6d937a@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v14 03/13] block: allow blk-zoned devices to have
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
 dm-devel@redhat.com, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-core.c       |  2 +-
 block/blk-zoned.c      | 24 ++++++++++++++++++------
 include/linux/blkdev.h | 30 ++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4d0dd0e9e46d..735f63b6159a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -559,7 +559,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
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
index 6cf43f9384cc..e29799076298 100644
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

