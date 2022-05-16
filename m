Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B94DBC4332F
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 13:39:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-y3KmMBrAPrSPxXjWAj7L1A-1; Mon, 16 May 2022 09:39:33 -0400
X-MC-Unique: y3KmMBrAPrSPxXjWAj7L1A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78CBD100B8C9;
	Mon, 16 May 2022 13:39:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 27DA14411DB;
	Mon, 16 May 2022 13:39:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BC12C1947055;
	Mon, 16 May 2022 13:39:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0D75A1947074
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 13:39:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3C82C15D5C; Mon, 16 May 2022 13:39:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF346C15D67
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:39:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A561429ABA09
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:39:29 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-Tu4Y19aAN_mpQR7U6Dj6Ww-1; Mon, 16 May 2022 09:39:27 -0400
X-MC-Unique: Tu4Y19aAN_mpQR7U6Dj6Ww-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220516133926euoutp01fb0ffd5b77a40176406d441de531f296~vmYDOiXP-1727217272euoutp01H
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:39:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220516133926euoutp01fb0ffd5b77a40176406d441de531f296~vmYDOiXP-1727217272euoutp01H
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220516133925eucas1p1420eaae564513c721731fd2576c15897~vmYCc9e2d1351113511eucas1p1O;
 Mon, 16 May 2022 13:39:25 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 7B.8D.09887.D0452826; Mon, 16
 May 2022 14:39:25 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220516133925eucas1p1414fab2cfa7da1d6258315cbd33e1685~vmYB8l_5Y1348813488eucas1p1Z;
 Mon, 16 May 2022 13:39:25 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220516133925eusmtrp13fdd91aa67297264273541394fda3a28~vmYB7c2a10312203122eusmtrp1b;
 Mon, 16 May 2022 13:39:25 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-5e-6282540d840f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 2E.02.09522.D0452826; Mon, 16
 May 2022 14:39:25 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220516133925eusmtip1fea492112f4c915b97ebeaa172d419bc~vmYBs5nFp0855508555eusmtip1Z;
 Mon, 16 May 2022 13:39:25 +0000 (GMT)
Received: from localhost (106.110.32.130) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Mon, 16 May 2022 14:39:24 +0100
From: Pankaj Raghav <p.raghav@samsung.com>
To: <axboe@kernel.dk>, <naohiro.aota@wdc.com>,
 <damien.lemoal@opensource.wdc.com>, <Johannes.Thumshirn@wdc.com>,
 <snitzer@kernel.org>, <dsterba@suse.com>, <jaegeuk@kernel.org>, <hch@lst.de>
Date: Mon, 16 May 2022 15:39:10 +0200
Message-ID: <20220516133921.126925-3-p.raghav@samsung.com>
In-Reply-To: <20220516133921.126925-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Originating-IP: [106.110.32.130]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTG9957e1tI6i6FwTu6ydLIH3NYwczlHZpNs0VvYlxmMicDt1Hl
 Doh8pQXp5nTlGwoKIuhsYepcBIS1o7SG8jFoE8q3ZXyFdSLrAFEYINAyGmcd9eLCf895z++c
 8zzJy8MFVWQgLz4plZEmSRJEpDdxx+K6u4P/SeaJ0PK6XUjbY8HRsxYLiWrHi0l0+bELR6XF
 33PRk34rjloX1Bw0sJaBoZraDgxNaVU4Kmp/TKCnyvvrb9l2HP1rD0N2h41ApeZRgKZHVBhq
 tb2FBieruailtZtAQ00VJLp2a5qLSnKdOBormQboYmcDB2nmFgnUZRPuE9JDw4dod1cdSV/M
 WuDS1vv1BD3Un0brbheQ9A1FOU43/PQd3fy7gqTPZy2QtDFngkMv/jpC0lr9CEGXNNRz6BXd
 VjqvvRD7mIr03hvDJMSfZqQ734v2jhupmeKmOIPlk1dGgAIMblUCLx6k3oYVPT8CJfDmCahq
 AHWF9zYKB4A/mPJJtlgB8IbZyX0x0qF+tNGoAnDm7nnif2pc7QIeSkDpASwyBysBj0dS22FG
 AdfD+FEmAF0D1ZinwKlqDmxyrxGeAV8qCuaNduMeTVDBsDGzCfNoPhUOZ4qdBHs6CF4d/Ifr
 WepF7YHLF95nER/YfXXqOYKvI1kGNc5qCE0PH+IeHFIiqB4Ss1vOwp8tfc/9QKrDGzq7awDb
 +BBOFK2SrPaFs536jcSvwd5LRRsWzsDpsSc4O5wNYLFRS7IH9sALfQkssx/mtfVg7PMWODbv
 w9rZAkvvXNmww4f5uYISsE21KYBqUwDVpgDXAX4bBDBpssRYRrYriUkXyySJsrSkWPHJ5EQd
 WP/Lve5ORyOoml0SmwHGA2YAebjIjx8qV5wQ8GMkX3/DSJO/lKYlMDIzEPIIUQD/ZPwvEgEV
 K0llTjFMCiN90cV4XoEKrLLVVPHnb+/OPSqLK9htqHBEhNwTC6POyemvhueFiy1W9RpmDcoM
 OWUkyAPHTK9G2CbLonNtGn+DX/S8IUiT2tQsbUt2bxMqjxZaGs4OV3dFTM7w33l91cY1RXMq
 NDuXsqIUkW3pz8Z8NMdGz+zTO+zWwP0fZLuP+/YFiv2+rdE+PbijQ/rXS8vte0uWT6OP+t9o
 Tg3oHpip7J0IPcD17xg8mj+rXPLZHT5er6du2vuP5/heltf6Z7zy5jw6l/p5+CFD/KdzxuIj
 8r7FuqVbX5Sn/F31cqPAMn5TW3TQP/IPL1PZ1OrC/Bh+OOPIA/+wnHw1KPwstzLd9eBwVEyI
 cUUnImRxkrDtuFQm+Q+YXt6WOgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t/xu7q8IU1JBjNu81msP3WM2eL/nmNs
 Fqvv9rNZTPvwk9liUv8MdovfZ88zW+x9N5vV4sKPRiaLlauPMlk8WT+L2aLnwAcWi79d94Bi
 LQ+ZLf48NLR4+OUWi8WkQ9cYLZ5encVksfeWtsWlxyvYLfbsPclicXnXHDaL+cuesltMaPvK
 bHFjwlNGi4nHN7NarHv9nsXixC1pB2mPy1e8Pf6dWMPmMbH5HbvH+XsbWTwuny312LSqk81j
 YcNUZo/NS+o9dt9sYPPobX7H5rGz9T6rx/t9V9k81m+5yuIxYfNGVo/Pm+Q82g90MwUIROnZ
 FOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJalFunbJehlXF35hL3g
 q2rF4+lXGRsYL8l1MXJySAiYSByd/ZKti5GLQ0hgKaPE7nvX2SASMhKfrnxkh7CFJf5c64Iq
 +sgo8WDVe0YIZwujxP+pJ5i7GDk42AS0JBo72UHiIgIHGSV+XljBBNLNLLCCVeLPnloQW1gg
 UqK9+wnYBhYBVYkdTbvAangFrCSe939lgdgmLzHz0nd2kJmcAtYSn/rsQUwhoJL1b4ogqgUl
 Ts58wgIxXV6ieetsZghbQuLgixdg10gIKEnMvqwHMbBW4tX93YwTGEVmIemehaR7FpLuBYzM
 qxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQJT1rZjPzfvYJz36qPeIUYmDsZDjBIczEoivAYV
 DUlCvCmJlVWpRfnxRaU5qcWHGE2BnpzILCWanA9Mmnkl8YZmBqaGJmaWBqaWZsZK4ryeBR2J
 QgLpiSWp2ampBalFMH1MHJxSDUxN+iGxUjvt+Vf/sP2k2T/lwS32rKTtJSw1+28oWN9/XvV6
 9qzq7csEZwWFTyruVtjNYdS5PqhS9lJEPv/mhDW2PtkmsuZyZ1Tast9YyKd3nprxZ1nVNLMv
 LHJHf7+SP6o36Xdz7o/m/aWBFVv7Cw7cjthb/pVr83mjr/zNTt92T763p/jdlKqPN7q5Fb4c
 1uS+IZB+JLuzf566r5nLq79pF+R3iR9KOrBwX9IL9Rb3+54X2MT4zR0tHJoSjiy9ttxbKIP5
 np+k9Lfth7wvRKf2NYsUHmG6ax4c/6or9sYZ03O8T38+0JuZdnyxwuyjlkyzlBzXd+uUeK7b
 yjP7YZigdTz/5f3ezf2xLZx5f5VYijMSDbWYi4oTAc0L/zniAwAA
X-CMS-MailID: 20220516133925eucas1p1414fab2cfa7da1d6258315cbd33e1685
X-Msg-Generator: CA
X-RootMTR: 20220516133925eucas1p1414fab2cfa7da1d6258315cbd33e1685
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516133925eucas1p1414fab2cfa7da1d6258315cbd33e1685
References: <20220516133921.126925-1-p.raghav@samsung.com>
 <CGME20220516133925eucas1p1414fab2cfa7da1d6258315cbd33e1685@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v4 02/13] block: allow blk-zoned devices to have
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
Cc: jiangbo.365@bytedance.com, Jens Axboe <axboe@fb.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, bvanassche@acm.org,
 Chris Mason <clm@fb.com>, matias.bjorling@wdc.com, gost.dev@samsung.com,
 Pankaj Raghav <p.raghav@samsung.com>, Luis Chamberlain <mcgrof@kernel.org>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, jonathan.derrick@linux.dev,
 Keith Busch <kbusch@kernel.org>, Johannes Thumshirn <jth@kernel.org>,
 linux-btrfs@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
 block/blk-zoned.c      | 27 +++++++++++++++++++++------
 include/linux/blkdev.h | 22 ++++++++++++++++++++++
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f305cb66c..b7051b7ea 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -634,8 +634,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
-	if (pos & (blk_queue_zone_sectors(q) - 1) ||
-	    !blk_queue_zone_is_seq(q, pos))
+	if (!blk_queue_is_zone_start(q, pos) || !blk_queue_zone_is_seq(q, pos))
 		return BLK_STS_IOERR;
 
 	/*
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 140230134..cfc2fb804 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -289,10 +289,10 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 		return -EINVAL;
 
 	/* Check alignment (handle eventual smaller last zone) */
-	if (sector & (zone_sectors - 1))
+	if (!blk_queue_is_zone_start(q, sector))
 		return -EINVAL;
 
-	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
+	if (!blk_queue_is_zone_start(q, nr_sectors) && end_sector != capacity)
 		return -EINVAL;
 
 	/*
@@ -490,14 +490,29 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	 * smaller last zone.
 	 */
 	if (zone->start == 0) {
-		if (zone->len == 0 || !is_power_of_2(zone->len)) {
-			pr_warn("%s: Invalid zoned device with non power of two zone size (%llu)\n",
-				disk->disk_name, zone->len);
+		if (zone->len == 0) {
+			pr_warn("%s: Invalid zone size",
+				disk->disk_name);
+			return -ENODEV;
+		}
+
+		/*
+		 * Don't allow zoned device with non power_of_2 zone size with
+		 * zone capacity less than zone size.
+		 */
+		if (!is_power_of_2(zone->len) &&
+		    zone->capacity < zone->len) {
+			pr_warn("%s: Invalid zoned size with non power of 2 zone size and zone capacity < zone size",
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
index 22fe512ee..32d7bd7b1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -686,6 +686,22 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
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
+	/* if there is a remainder, then the sector is not aligned */
+	return remainder == 0;
+}
+
 static inline bool blk_queue_zone_is_seq(struct request_queue *q,
 					 sector_t sector)
 {
@@ -732,6 +748,12 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
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

