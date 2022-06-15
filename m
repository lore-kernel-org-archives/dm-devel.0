Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B818C43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:19:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-JO8bQc8NOLSeeKDflPWM-w-1; Wed, 15 Jun 2022 06:19:40 -0400
X-MC-Unique: JO8bQc8NOLSeeKDflPWM-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63EE81C1CB89;
	Wed, 15 Jun 2022 10:19:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F3C340C1288;
	Wed, 15 Jun 2022 10:19:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EEFDC1947B84;
	Wed, 15 Jun 2022 10:19:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1C0AA1947B84
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:19:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E409740CFD0A; Wed, 15 Jun 2022 10:19:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DFA1B40CF8E7
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4DC0101E985
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:36 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-xSiW5XqGOCqDqcRk8u8Lbg-1; Wed, 15 Jun 2022 06:19:35 -0400
X-MC-Unique: xSiW5XqGOCqDqcRk8u8Lbg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220615101933euoutp021bd97be9aa6b64d22407ac4ec5234d5b~4xAGJZ0ts2915629156euoutp02E
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220615101933euoutp021bd97be9aa6b64d22407ac4ec5234d5b~4xAGJZ0ts2915629156euoutp02E
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220615101932eucas1p2660b95125dabbb1744287f9d299c6460~4xAEayiPp0710307103eucas1p24;
 Wed, 15 Jun 2022 10:19:32 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 1D.2B.09664.332B9A26; Wed, 15
 Jun 2022 11:19:32 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220615101931eucas1p15ed09ae433a2c378b599e9086130d8eb~4xAD9YEc10100501005eucas1p1N;
 Wed, 15 Jun 2022 10:19:31 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615101931eusmtrp2b70e8cbdfb93fd8f578e936104ade6c6~4xAD8lqBD0308003080eusmtrp2f;
 Wed, 15 Jun 2022 10:19:31 +0000 (GMT)
X-AuditID: cbfec7f2-d97ff700000025c0-cd-62a9b233f413
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 5B.45.09095.332B9A26; Wed, 15
 Jun 2022 11:19:31 +0100 (BST)
Received: from localhost (unknown [106.210.248.244]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220615101930eusmtip20501ba33701d46b01bdb1087349cb48e~4xAC0W5x_0785907859eusmtip2G;
 Wed, 15 Jun 2022 10:19:30 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk
Date: Wed, 15 Jun 2022 12:19:09 +0200
Message-Id: <20220615101920.329421-3-p.raghav@samsung.com>
In-Reply-To: <20220615101920.329421-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7djP87omm1YmGZxdxmix+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFjcmPGW0+Ly0hd1izc2nLBZtG78yOgh7XL7i7fHvxBo2j52z7rJ7XD5b
 6rFpVSebx8KGqcwem5fUe+y+2QCUa73P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZ
 AvijuGxSUnMyy1KL9O0SuDJm3HnPVPBMvWLehqOMDYxLFboYOTkkBEwk7l36zNzFyMUhJLCC
 UWLJ/6WMEM4XRolll1azQjifGSUWfOpgh2npanzHDpFYzihxfk8HlPOSUWLfzV9ALRwcbAJa
 Eo2dYA0iAuESR/fcYwKxmQX6mCWevKwDKREWiJZ411AIYrIIqEo8euwMUsErYCUx78dqRohV
 8hIzL30Hm8IpYC2xY3YPK0SNoMTJmU9YICbKSzRvnQ32gYTAOU6Jp89fs0A0u0i86b4LdbOw
 xKvjW6BsGYn/O+czQdjVEk9v/IZqbmGU6N+5ng3kIAmgbX1nckBMZgFNifW79CHKHSWeXOiE
 quCTuPFWEOIEPolJ26YzQ4R5JTrahCCqlSR2/nwCtVRC4nLTHKjDPCTebTnGMoFRcRaSZ2Yh
 eWYWwt4FjMyrGMVTS4tz01OLDfNSy/WKE3OLS/PS9ZLzczcxAtPm6X/HP+1gnPvqo94hRiYO
 xkOMEhzMSiK8ZsErk4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzJmduSBQSSE8sSc1OTS1ILYLJ
 MnFwSjUw2Ru1copLV95dEN2/ZHOkg4BxvmZE88Gui4kpz6sF9Tc0Jgi9K84NChJyDfn58ZqX
 nBr39L4/5/sucpu8cU/uPt36LfOZL3+TpHX3xCdpcxzrFDSO+axz32b8SHhLjazPAxvz05Ne
 zLCf/ik3/mL6kVXnDaWv/LtbMeHsj83q4Xd4rj88+9D9KaPkwqSAiIxXAnyGn/bnfeCLfB3s
 NoVl9o6n9w8q+zz+arDBp6zryN6T5iyRS9tDmL8t+1psttkyRupXkdLv7drZ9md0N6w9firl
 57IHjq7+C3TkdLc9KxfRWB+6KnxWaN68ssURq10jbZKzWjn2P7kqsp6DvXrRylyHoIKyFt9f
 p/8e33BBiaU4I9FQi7moOBEAU0uR3AoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xe7rGm1YmGWx/JGux+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFjcmPGW0+Ly0hd1izc2nLBZtG78yOgh7XL7i7fHvxBo2j52z7rJ7XD5b
 6rFpVSebx8KGqcwem5fUe+y+2QCUa73P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZ
 Avij9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DJm
 3HnPVPBMvWLehqOMDYxLFboYOTkkBEwkuhrfsXcxcnEICSxllJjd2cwKkZCQuL2wiRHCFpb4
 c62LDaLoOaPExqULWLoYOTjYBLQkGjvZQWpEBKIlOm++B6thFljALHH6zgSwhLBApETPtaXs
 IPUsAqoSjx47g4R5Bawk5v1YDTVfXmLmpe9g5ZwC1hI7ZvewgpQLAdXsehcPUS4ocXLmExYQ
 mxmovHnrbOYJjAKzkKRmIUktYGRaxSiSWlqcm55bbKhXnJhbXJqXrpecn7uJERjj24793LyD
 cd6rj3qHGJk4GA8xSnAwK4nwmgWvTBLiTUmsrEotyo8vKs1JLT7EaAp09URmKdHkfGCSySuJ
 NzQzMDU0MbM0MLU0M1YS5/Us6EgUEkhPLEnNTk0tSC2C6WPi4JRqYIrTuLHU7OzP6zauH8+Y
 r7918HKB56r3L9gnaX2W4w+Yu8OW49feqsgNs7yvKn1XbQ6d7OIVsWODU9MczlzbuM7EsCtm
 TxewH3XM9XlaumzxbeEt+1fXVvdP6hBa7l1x5LrqOVsBv0/2T+tS+JuMbus/Dqw1L9X/kZqV
 tOZk3vV9in+0DCxz+pNull5iq/sh/9+IS7h9k/PpW4mLdjuYLf5/49uPXjZFxXcWCSeCy3fK
 v0zYwrWka3mQr9HLEoXll07d/vVVw/61bKl4A9fPhwkxmvNkZzs+b5VTkjTp46qLON075V26
 3d3vD1bNsrMNeirsfnGm5Cp9/xSGOa8Kc2ZcCFC/v7uklOHe6u0nXZVYijMSDbWYi4oTAXP6
 75x6AwAA
X-CMS-MailID: 20220615101931eucas1p15ed09ae433a2c378b599e9086130d8eb
X-Msg-Generator: CA
X-RootMTR: 20220615101931eucas1p15ed09ae433a2c378b599e9086130d8eb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615101931eucas1p15ed09ae433a2c378b599e9086130d8eb
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101931eucas1p15ed09ae433a2c378b599e9086130d8eb@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v7 02/13] block: allow blk-zoned devices to have
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
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-core.c       |  3 +--
 block/blk-zoned.c      | 25 +++++++++++++++++++------
 include/linux/blkdev.h | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 06ff5bbfe..248b947e5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -629,8 +629,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
-	if (pos & (blk_queue_zone_sectors(q) - 1) ||
-	    !blk_queue_zone_is_seq(q, pos))
+	if (!blk_queue_is_zone_start(q, pos) || !blk_queue_zone_is_seq(q, pos))
 		return BLK_STS_IOERR;
 
 	/*
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 8b0615287..7957eec04 100644
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
@@ -489,14 +489,27 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
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
+		if (!is_power_of_2(zone->len) && zone->capacity < zone->len) {
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
index 39017ae9d..3c106dba1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -692,6 +692,27 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 	return div64_u64(sector, zone_sectors);
 }
 
+static inline sector_t blk_queue_offset_from_zone_start(struct request_queue *q,
+							sector_t sec)
+{
+	sector_t zone_sectors = blk_queue_zone_sectors(q);
+	u64 remainder = 0;
+
+	if (!blk_queue_is_zoned(q))
+		return false;
+
+	if (is_power_of_2(zone_sectors))
+		return sec & (zone_sectors - 1);
+
+	div64_u64_rem(sec, zone_sectors, &remainder);
+	return remainder;
+}
+
+static inline bool blk_queue_is_zone_start(struct request_queue *q, sector_t sec)
+{
+	return blk_queue_offset_from_zone_start(q, sec) == 0;
+}
+
 static inline bool blk_queue_zone_is_seq(struct request_queue *q,
 					 sector_t sector)
 {
@@ -738,6 +759,18 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 {
 	return 0;
 }
+
+static inline sector_t blk_queue_offset_from_zone_start(struct request_queue *q,
+							sector_t sec)
+{
+	return 0;
+}
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

