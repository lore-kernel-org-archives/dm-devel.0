Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D2DC4321E
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-N5nIoigBMOyglHm6MzQInw-1; Fri, 29 Apr 2022 04:23:48 -0400
X-MC-Unique: N5nIoigBMOyglHm6MzQInw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DDB11E1AE56;
	Fri, 29 Apr 2022 08:23:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 896E140D1B9D;
	Fri, 29 Apr 2022 08:23:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C283B194704D;
	Fri, 29 Apr 2022 08:23:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 522341947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:11:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1333C200C0E3; Wed, 27 Apr 2022 16:11:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EAC82024CB6
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A830A3C21F86
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:48 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-vbp3X5lnM1qtGVSW7g5RGQ-1; Wed, 27 Apr 2022 12:11:46 -0400
X-MC-Unique: vbp3X5lnM1qtGVSW7g5RGQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160300euoutp0255416b90669cd65b042460d19a03ec7a~pzE_RjaHy1479314793euoutp02b
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:03:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220427160300euoutp0255416b90669cd65b042460d19a03ec7a~pzE_RjaHy1479314793euoutp02b
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160258eucas1p252cb6872c7cc20eea327c199f8e2aec9~pzE8vLb-p1589415894eucas1p2E;
 Wed, 27 Apr 2022 16:02:58 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id C2.0A.10260.23969626; Wed, 27
 Apr 2022 17:02:58 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220427160258eucas1p19548a7094f67b4c9f340add776f60082~pzE8W8LWT0330603306eucas1p1Q;
 Wed, 27 Apr 2022 16:02:58 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220427160258eusmtrp2f76aadf93653911fc7f556ba6f0a2efb~pzE8ULUY32598325983eusmtrp2d;
 Wed, 27 Apr 2022 16:02:58 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-81-6269693261bd
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 7D.71.09522.23969626; Wed, 27
 Apr 2022 17:02:58 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160258eusmtip2b1f69ceee95e1cec081198bf82161f87~pzE79CnAQ2569125691eusmtip2E;
 Wed, 27 Apr 2022 16:02:58 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:41 +0200
Message-Id: <20220427160255.300418-3-p.raghav@samsung.com>
In-Reply-To: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0xTVxTHd999fX1tUvYoBO8E3Og0UwZYQLcbWHQGM1/CFlmyxGW6YYEn
 MMuPtLJN3GYdSJQILThwVBg/FShCEUoBkUWbDWTalBYYKBNHhDHAAQoyQCejPMz873vu+Xy/
 55zk0lBaR62n4xOPcKpEhVJGiUlzx6LNPyg+PkpemBeIjb92QFxzV0vh/JlFiG/mWQmcq/1B
 iJ9YbRC3T50X4O6FEwS+fa2VwNU1vxB4xKiH+My1GRL/mzm08pY+DPHT4UCca/kN4NE+PYHb
 77yJHferhNhRtgdfbe8icc+VQgoXXxwVYl3GY4gHdKMA53Q2CvDshXQhrpucJvGNO57verM9
 veHssxuXKDYnbUrI2oYuk2yPNYVtMJym2FJNHmQbK46zbSWzBNt2W0OxWWlTFNt68p6Anf6p
 j2KzTQbAGk19JKtrvCyIkH4ifieGU8Z/wam27jgojrNVmsnkEulXjuVpoAFnXs4EIhox29DC
 /VlhJhDTUqYKIGvjFMkXcwAtGnsJvpgFaOnBkuC5ZUwzTPGNSoAKhhogX4wD1DzWvuKnaYrx
 RSdOr+a6MwMA5dTXr0ZBZgKiblM/4YxyY/ah/KzhVU0ym1D2vB06tYQJQWbbAuTHvYoKHP8I
 naEiJhTpHn3MI66oq2CEdGq4gqQ1nV9dAjEXxOj3divl5BGzG/U0rW3thiY6TUJee6Hl1mKC
 18fQ6MCTNW86QNpW45o3FGXfUjolZLYg45WtPL4LWSc7BDzhggb+duU3cEG55nOQf5agUxlS
 npah1sWRtaEI9XxXSPIIi67/eEAHfPQvnKJ/4RT9/2NLADSAdVyKOiGWUwcncl8GqBUJ6pTE
 2IDopIQGsPKlbz7rfNwCqiYeBlgAQQMLQDSUuUvm2uKipJIYxdFUTpUUqUpRcmoL8KRJ2TpJ
 dHy9QsrEKo5whzkumVM97xK0aL2G+IyNsMqaP4DBzfaw7Ut7w0wexR+dnJ4fl2/LChz8eURe
 62JSbio6uCM8ZLvo3uTSK+WG5b4yw6dZ55SftxRJIoNr1WnabOOg0VF8V17+eoyorFr4QFDu
 My8fPJ6Bandz3wxoizaUpu08hKI3w1t/hpedTRa3aI5Vjft5b6F2hVY2PUq42v92R1dzaZh/
 6vh+j/f8K3LPfj/ZrzCM2fNP5aW+ocX2uo1uMzvldJRrUdvXF72qZYzF093i5/mtPelwr+Sh
 d9D+A5ubNnzon/N0cDDiJb89Xr5EV+ShipC/zCxF+dRcN+97a1IbQTPdfziCkpIvddZPH907
 95pRutGj+n1WRqrjFIG+UKVW/AcO+wgYQQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t/xe7pGmZlJBot2CFisP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlmsXH2UyeLJ+lnMFj0HPrBY
 /O26BxRrechs8eehocWkQ9cYLZ5encVksfeWtsWlxyvYLS4tcrfYs/cki8XlXXPYLOYve8pu
 MaHtK7PFjQlPGS0mHt/MavF5aQu7xbrX71ksTtySdpD1uHzF2+PfiTVsHhOb37F7nL+3kcXj
 8tlSj02rOtk8FjZMZfbYvKTeY/eCz0weu282sHn0Nr9j89jZep/V4/2+q2wefVtWMXqs33KV
 xWPC5o2sAUJRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF
 +nYJehnnl29jKVggVHHp/3vGBsYe/i5GTg4JAROJ5w0P2boYuTiEBJYySjxqn8MEkZCQuL2w
 iRHCFpb4c60Lqug5o8Sx2SuBHA4ONgEticZOdpC4iMATRon7Px+zgDjMAg0sErcm7gKbJCwQ
 KjHnQifYJBYBVYm+bxeZQWxeASuJbed/MENskJeYeek7O8hQTgFriQmfIkDCQkAl3YtusUKU
 C0qcnPmEBcRmBipv3jqbeQKjwCwkqVlIUgsYmVYxiqSWFuem5xYb6hUn5haX5qXrJefnbmIE
 ppRtx35u3sE479VHvUOMTByMhxglOJiVRHi/7M5IEuJNSaysSi3Kjy8qzUktPsRoCnT2RGYp
 0eR8YFLLK4k3NDMwNTQxszQwtTQzVhLn9SzoSBQSSE8sSc1OTS1ILYLpY+LglGpgOlYt+uyP
 4MbKiz+3vmr4/3fGp3QrZr5382afuudfWSes+vTWB1udzvjH7B7xZldmL8nd8vXH6t3bpkzk
 jOJZy6q6b85K4R3Z6y3MYgzN7s3U8P36YoXTl9ftK/V3bEqZHNiVfDThzzHJKKmZ1Sbek9Yu
 XRu3wH9d0IfkyN40szSRDvdpXO6XWZOSDB1WxutY72yt6W2cckMh53nK7lwL14RZ07NFvIK8
 vgfXXWRak3djU/u3XzHd92x3Ft6/eFryj13xUm3hPcv+b35cr8MdvWf/C5u5IRu47kS3Bt04
 s6bPutrs8zTerU/r74v0/5qlbj3ppecVi6aYLXWfRTyVtPcf4vPZVsmwQ2DTJCcRVyWW4oxE
 Qy3mouJEAGOYaxeyAwAA
X-CMS-MailID: 20220427160258eucas1p19548a7094f67b4c9f340add776f60082
X-Msg-Generator: CA
X-RootMTR: 20220427160258eucas1p19548a7094f67b4c9f340add776f60082
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160258eucas1p19548a7094f67b4c9f340add776f60082
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160258eucas1p19548a7094f67b4c9f340add776f60082@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 02/16] block: add blk_queue_zone_aligned and
 bdev_zone_aligned helper
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
Cc: jiangbo.365@bytedance.com, Pankaj Raghav <p.raghav@samsung.com>,
 kch@nvidia.com, bvanassche@acm.org, matias.bjorling@wdc.com,
 gost.dev@samsung.com, chao@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, clm@fb.com, dm-devel@redhat.com, agk@redhat.com,
 jonathan.derrick@linux.dev, kbusch@kernel.org, linux-fsdevel@vger.kernel.org,
 josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Checking if a given sector is aligned to a zone is a very common
operation that is performed for zoned devices. Add
blk_queue_zone_aligned helper to check for this instead of opencoding it
everywhere.

The helper is made to be generic so that it can also check for alignment
for non non-power-of-2 zone size devices.

As the existing deployments of zoned devices had power-of-2
assumption, power-of-2 optimized calculation is done for devices with
power-of-2 zone size

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/blkdev.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c4e4c7071b7b..f8f2d2998afb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -676,6 +676,22 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 	return div64_u64(sector, zone_sectors);
 }
 
+static inline bool blk_queue_zone_aligned(struct request_queue *q, sector_t sec)
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
@@ -722,6 +738,12 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 {
 	return 0;
 }
+
+static inline bool blk_queue_zone_aligned(struct request_queue *q, sector_t sec)
+{
+	return false;
+}
+
 static inline unsigned int queue_max_open_zones(const struct request_queue *q)
 {
 	return 0;
@@ -1361,6 +1383,15 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 	return 0;
 }
 
+static inline bool bdev_zone_aligned(struct block_device *bdev, sector_t sec)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (q)
+		return blk_queue_zone_aligned(q, sec);
+	return false;
+}
+
 static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

