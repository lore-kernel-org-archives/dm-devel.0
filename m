Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29BB7C43217
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 16:16:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-AxdmSS_eMUitugs1xV0k2Q-1; Mon, 23 May 2022 12:16:17 -0400
X-MC-Unique: AxdmSS_eMUitugs1xV0k2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26E2A1C0CE68;
	Mon, 23 May 2022 16:16:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC1552166B25;
	Mon, 23 May 2022 16:16:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 528851947070;
	Mon, 23 May 2022 16:16:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D9A84194706F
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 16:16:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9F972166B25; Mon, 23 May 2022 16:16:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B44832166B2D
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B8F6185A79C
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:11 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-bb3N3PKuMrWs4l9RotDlLQ-1; Mon, 23 May 2022 12:16:09 -0400
X-MC-Unique: bb3N3PKuMrWs4l9RotDlLQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220523161608euoutp01530ad6e7ac4eceef07087dfc8921f53f~xyB24iGnB2142721427euoutp01F
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220523161608euoutp01530ad6e7ac4eceef07087dfc8921f53f~xyB24iGnB2142721427euoutp01F
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220523161606eucas1p2fb8987aab7d30ce848152c893d2bc01e~xyB1dqTQe1825618256eucas1p23;
 Mon, 23 May 2022 16:16:06 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 5E.A9.10260.643BB826; Mon, 23
 May 2022 17:16:06 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220523161606eucas1p2676c4d47f9fcb145f69b29db1f04fe6e~xyB1A6R7V1186311863eucas1p2_;
 Mon, 23 May 2022 16:16:06 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220523161606eusmtrp299b69a721770b4ead0f2f5bd2f4f3d8f~xyB1ACxcW0219002190eusmtrp2M;
 Mon, 23 May 2022 16:16:06 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-00-628bb346e666
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 6C.19.09404.643BB826; Mon, 23
 May 2022 17:16:06 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220523161605eusmtip29f8a9bdce98d621272bad00cf15f9614~xyB0s3W620632306323eusmtip2D;
 Mon, 23 May 2022 16:16:05 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, hch@lst.de, snitzer@redhat.com,
 damien.lemoal@opensource.wdc.com, hare@suse.de, Johannes.Thumshirn@wdc.com
Date: Mon, 23 May 2022 18:15:56 +0200
Message-Id: <20220523161601.58078-3-p.raghav@samsung.com>
In-Reply-To: <20220523161601.58078-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsWy7djPc7pum7uTDA5NUbVYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBZ7Fk1isli5+iiTxZP1s5gteg58YLH423WPyWLvLW2Ly7vmsFnM
 X/aU3eLGhKeMFp+XtrBbtG38yugg4PHvxBo2j8tnSz02repk89i8pN5j980GNo+drfdZPd7v
 u8rm0bdlFaPH+i1XWTw2n672+LxJzqP9QDdTAE8Ul01Kak5mWWqRvl0CV8bR239YCxapVmxa
 uJy9gXGmXBcjJ4eEgInEpRXn2boYuTiEBFYwSmxt/cYK4XxhlNjy+AxjFyMHkPOZUWK6B4gJ
 0vC+WQOiZDmjxNq7NxkhnBeMEp97nrCDFLEJaEk0drKDxEUEGhkl3h+dBzaUWWA2k8S5B9dY
 QVYLC0RK7Pu7hBnEZhFQlVi67BE7iM0rYCmx/9Mvdojz5CVmXvoOZnMKWElcv3qVDaJGUOLk
 zCcsIDYzUE3z1tnMIAskBFZzSlxuaoFqdpGYtGYNG4QtLPHq+BaouIzE/53zmSDsaomnN35D
 NbcwSvTvXM8G8ae1RN+ZHBCTWUBTYv0ufYhyR4mfG99BVfBJ3HgrCHECn8SkbdOZIcK8Eh1t
 QhDVShI7fz6BWioBdNgcFgjbQ2LazL+MExgVZyF5ZhaSZ2Yh7F3AyLyKUTy1tDg3PbXYOC+1
 XK84Mbe4NC9dLzk/dxMjMP2d/nf86w7GFa8+6h1iZOJgPMQowcGsJMK7PbEjSYg3JbGyKrUo
 P76oNCe1+BCjNAeLkjhvcuaGRCGB9MSS1OzU1ILUIpgsEwenVAOTZfNilWK/o6873fpyVpsF
 7NIvXyMSfbHoien2v/cLjIKlZ6kxhq3R2lZ/9T6vdIcio3hMj5HB+5Wxt08pnDneL+eSZ8O3
 3lNjW/DnTa+1dqtpnL3a2iu983PnJ2lOxTwt1hWrt6zfk/3Py2rhB1lhAZG27Ai+rVJro8u0
 L/2xmrE5a8Nrbg0eA6M0RkmPNW7y3N9eGyefjfhRKSApcU9i+Y+Z8hZre/tuVdSubH/GJHx2
 40/eVTf9jwVPfaK5RsSTp+XwhVYXV65f644If+Z8lPYodrrj1cwpUrN2n2+o6LH+4bUr4117
 1rsk7zO+2szLHnD9i1Zh8/O5xWP12nmJwbW8c7G3XJKW5X63s1FiKc5INNRiLipOBACA46dS
 7gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t/xe7pum7uTDBrXsFmsvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbnFjwlNGi89LW9gt2jZ+ZXQQ8Ph3Yg2bx+WzpR6bVnWyeWxeUu+x+2YDm8fO1vusHu/3
 XWXz6NuyitFj/ZarLB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/I
 xFLP0Ng81srIVEnfziYlNSezLLVI3y5BL+Po7T+sBYtUKzYtXM7ewDhTrouRg0NCwETifbNG
 FyMXh5DAUkaJM/86mLsYOYHiEhK3FzYxQtjCEn+udbFBFD1jlHjf/58RpJlNQEuisZMdJC4i
 0MkocXTFKRYQh1lgOZPEyzWLwbqFBcIltp57DzaVRUBVYumyR+wgNq+ApcT+T7/YITbIS8y8
 9B3M5hSwkrh+9SobiC0EVHNq/QSoekGJkzOfsIDYzED1zVtnM09gFJiFJDULSWoBI9MqRpHU
 0uLc9NxiI73ixNzi0rx0veT83E2MwGjdduznlh2MK1991DvEyMTBeIhRgoNZSYR3e2JHkhBv
 SmJlVWpRfnxRaU5q8SFGU6C7JzJLiSbnA9NFXkm8oZmBqaGJmaWBqaWZsZI4r2dBR6KQQHpi
 SWp2ampBahFMHxMHp1QDkxRnsKRC4s0libu3PeI+vkdA7t3MvFUxTC7prhnm69j0Jhib/5ji
 dvFz/fSceUv2XTpwVEtyqcOGFR4ZO8X0Hv0u5JHpYzt8smjRFKavJ7XPJQf7d377N/0vc8SB
 5qCJgbVSldZ9G8+fzf7uEPny0DL2w2wKD3zcCxSmO7gdnOv/y3VC+voyu6wPNd1n68Orp7g6
 yT/fpL5A8Otuh/aqSUHrDyyd0L3QcjW3OV+6rL2x5zXlXLbvLKffXJ2smdvPIpO6eLtu7qv2
 1ay2H6Mrf55LWOzvIP2h51jau4zqxIRFB+3Y4/ZU77usovdXTe15tmP3ciexvybf7q4qt/jW
 9/7OrhXMoVuXNMYLnPnzUImlOCPRUIu5qDgRAEPzyrtfAwAA
X-CMS-MailID: 20220523161606eucas1p2676c4d47f9fcb145f69b29db1f04fe6e
X-Msg-Generator: CA
X-RootMTR: 20220523161606eucas1p2676c4d47f9fcb145f69b29db1f04fe6e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220523161606eucas1p2676c4d47f9fcb145f69b29db1f04fe6e
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161606eucas1p2676c4d47f9fcb145f69b29db1f04fe6e@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH v5 2/7] block: allow blk-zoned devices to have
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Checking if a given sector is aligned to a zone is a common
operation that is performed for zoned devices. Add
blk_queue_is_zone_start helper to check for this instead of opencoding it
everywhere.

Convert the calculations on zone size to be generic instead of relying on
power_of_2 based logic in the block layer using the helpers wherever
possible.

The only hot path affected by this change for power_of_2 zoned devices
is in blk_check_zone_append() but blk_queue_is_zone_start() helper is
used to optimize the calculation for po2 zone sizes. Note that the append
path cannot be accessed by direct raw access to the block device but only
through a filesystem abstraction.

Finally, allow non power of 2 zoned devices provided that their zone
capacity and zone size are equal. The main motivation to allow non
power_of_2 zoned device is to remove the unmapped LBA between zcap and
zsze for devices that cannot have a power_of_2 zcap.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-core.c       |  3 +--
 block/blk-zoned.c      | 26 ++++++++++++++++++++------
 include/linux/blkdev.h | 21 +++++++++++++++++++++
 3 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bc0506772152..bf1eae142118 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -630,8 +630,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
-	if (pos & (blk_queue_zone_sectors(q) - 1) ||
-	    !blk_queue_zone_is_seq(q, pos))
+	if (!blk_queue_is_zone_start(q, pos) || !blk_queue_zone_is_seq(q, pos))
 		return BLK_STS_IOERR;
 
 	/*
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index e7eec513dd42..665993b13668 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -288,10 +288,10 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 		return -EINVAL;
 
 	/* Check alignment (handle eventual smaller last zone) */
-	if (sector & (zone_sectors - 1))
+	if (!blk_queue_is_zone_start(q, sector))
 		return -EINVAL;
 
-	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
+	if (!blk_queue_is_zone_start(q, nr_sectors) && end_sector != capacity)
 		return -EINVAL;
 
 	/*
@@ -489,14 +489,28 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	 * smaller last zone.
 	 */
 	if (zone->start == 0) {
-		if (zone->len == 0 || !is_power_of_2(zone->len)) {
-			pr_warn("%s: Invalid zoned device with non power of two zone size (%llu)\n",
-				disk->disk_name, zone->len);
+		if (zone->len == 0) {
+			pr_warn("%s: Invalid zone size", disk->disk_name);
+			return -ENODEV;
+		}
+
+		/*
+		 * Don't allow zoned device with non power_of_2 zone size with
+		 * zone capacity less than zone size.
+		 */
+		if (!is_power_of_2(zone->len) &&
+		    zone->capacity < zone->len) {
+			pr_warn("%s: Invalid zone capacity for non power of 2 zone size",
+				disk->disk_name);
 			return -ENODEV;
 		}
 
 		args->zone_sectors = zone->len;
-		args->nr_zones = (capacity + zone->len - 1) >> ilog2(zone->len);
+		/*
+		 * Division is used to calculate nr_zones for both power_of_2
+		 * and non power_of_2 zone sizes as it is not in the hot path.
+		 */
+		args->nr_zones = div64_u64(capacity + zone->len - 1, zone->len);
 	} else if (zone->start + args->zone_sectors < capacity) {
 		if (zone->len != args->zone_sectors) {
 			pr_warn("%s: Invalid zoned device with non constant zone size\n",
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c4e4c7071b7b..f5c7a41032ba 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -676,6 +676,21 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 	return div64_u64(sector, zone_sectors);
 }
 
+static inline bool blk_queue_is_zone_start(struct request_queue *q, sector_t sec)
+{
+	sector_t zone_sectors = blk_queue_zone_sectors(q);
+	u64 remainder = 0;
+
+	if (!blk_queue_is_zoned(q))
+		return false;
+
+	if (is_power_of_2(zone_sectors))
+		return IS_ALIGNED(sec, zone_sectors);
+
+	div64_u64_rem(sec, zone_sectors, &remainder);
+	return remainder == 0;
+}
+
 static inline bool blk_queue_zone_is_seq(struct request_queue *q,
 					 sector_t sector)
 {
@@ -722,6 +737,12 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 {
 	return 0;
 }
+
+static inline bool blk_queue_is_zone_start(struct request_queue *q, sector_t sec)
+{
+	return false;
+}
+
 static inline unsigned int queue_max_open_zones(const struct request_queue *q)
 {
 	return 0;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

