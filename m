Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D11FDC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-gR5ZCNA-MlObUQ6L5-xJXw-1; Fri, 29 Apr 2022 04:23:46 -0400
X-MC-Unique: gR5ZCNA-MlObUQ6L5-xJXw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DE47185A79C;
	Fri, 29 Apr 2022 08:23:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 267E340D2821;
	Fri, 29 Apr 2022 08:23:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4DDAC1947077;
	Fri, 29 Apr 2022 08:23:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C1AE51947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:12:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8C3CA404E4A2; Wed, 27 Apr 2022 16:12:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 880D440C128B
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:12:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F050811E78
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:12:23 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-AqTJVg8wPtuJpoTAFwka4g-1; Wed, 27 Apr 2022 12:12:21 -0400
X-MC-Unique: AqTJVg8wPtuJpoTAFwka4g-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160302euoutp01846ad20a43c87c5b8b22593f1c6e8d27~pzFAjGrE80745007450euoutp01X
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:03:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220427160302euoutp01846ad20a43c87c5b8b22593f1c6e8d27~pzFAjGrE80745007450euoutp01X
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160300eucas1p2820b4ac90e9eb0636191f5d6b6009ac5~pzE_szwrg2336123361eucas1p2k;
 Wed, 27 Apr 2022 16:03:00 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id D4.0A.10260.43969626; Wed, 27
 Apr 2022 17:03:00 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220427160300eucas1p1470fe30535849de6204bb78d7083cb3a~pzE_QB5uM0602706027eucas1p1M;
 Wed, 27 Apr 2022 16:03:00 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220427160300eusmtrp11a05ef21462b132cd88f3aeacf09747f~pzE_N2fo72077420774eusmtrp1H;
 Wed, 27 Apr 2022 16:03:00 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-85-626969340c0e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id CC.97.09404.43969626; Wed, 27
 Apr 2022 17:03:00 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160300eusmtip201f34f7356e5fa50793f41df667dbd86~pzE93FBDa0262002620eusmtip2N;
 Wed, 27 Apr 2022 16:03:00 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:43 +0200
Message-Id: <20220427160255.300418-5-p.raghav@samsung.com>
In-Reply-To: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTVxjGOffc3luq1duKcoZDA3GZ6AA/WHYG09Fs2a66LOr8w5EsrsAN
 EFsgLR0CWyjCXGGMQpkyCjJQRD62tUgVscUwIl8ilBUrYBiECcvEUBigjoFs7Voz/3ve9/ze
 5znvyeFDsZHy4yckpnCKRKkskBKQ1zqXrMFhCQnRuzpb92LD7U6IG37VUvjc3BLEvWf7CKzT
 fkfj5T4rxK2OMh4e+CuLwCNtLQSua+gg8KRBD3F+2xyJn+WNOXs5ExCvTOzGuvZ7AE/Z9QRu
 vb8T2x7U0th24X1sae0h8eCNcgp/XzNF48IzjyEeLpwCuKiriYcXLuXQ+KdHsyTuvr850p8d
 vHuIXe3+gWKLsh00ax1rJNnBPhV7pT6XYqvUZyHbVJ3JmisXCNY8oqbYb7IdFNvy5TiPnb1p
 p9gCUz1gDSY7yRY2NfIOi6MEb8VysoTPOEXo/k8F8Y1VD+jk3o2nzFoLrQa3RXnAm4+YMPR1
 7yWQBwR8MVMLkLZ5zlMsAnTBbCPcxQJA/6ibqecj7W0mD3UZoDvTpR7qIUCdZQPOgs+nmB0o
 K5d29X2YYYCKjMb/IMhMQzRgGiJcVhuY4+jb0XHo0iTzCsr/e4jn0kImHFXUnOe547aiUttT
 2mXqzUSgwvnjbkSEekonSZeGTiT7ahl0+SOmToB0agdwz76Lhn6f8fhsQNNdJtqtX0a9xfmk
 W2egqeFlz3CO8wVaDJQrDDnDCu7IXBIyQchwI9SNS9Dq5RwPsQ4Nz4jcV1iHdNdKoLstRJoz
 YjcdiFqWJj2hCA2eLveEsiinoo0uBAH6F5bRv7CM/v/cSgDrgS+nUsrjOOXeRC41RCmVK1WJ
 cSExSfIrwPmpe1e7Hl8HtdN/hrQDgg/aAeLDQB/hojk+WiyMlaalc4qkEwqVjFO2g818MtBX
 GJNglIqZOGkKd5LjkjnF81OC7+2nJjIWnn08sk3U9V7cB4pHofbqXVlfjRO6AEPW3U82pd5q
 YJPD7dvfWGO9KB+lFHHF8TMy66g6WHAycmv6kST52E6tRXJs7b4hWlG+/ORNSVpfz/XuCT/J
 bMpyR2rUO7+t2ZS+RTN+9ZfKe9qCqvhtPlBy86gl4+fXS95e9Boit1N7cmUzH22xcRsLin6E
 1ijB06bGksOOiy+l+b52LJJ3KrdWmKc63TNazjR1HInwPuB/6/ND4cUHeOv7g/YsZOp8+873
 9wOvCvMKnH015ol1Ler8IrvGWHzUcOLhfs2HB5k/kg9aYvdF+4u85jW1mSt1460RzfqgxID1
 loBzydXB80v5YZpAUhkv3b0DKpTSfwG1UqsyQwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t/xe7ommZlJBjO3iFmsP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlmsXH2UyeLJ+lnMFj0HPrBY
 /O26BxRrechs8eehocWkQ9cYLZ5encVksfeWtsWlxyvYLS4tcrfYs/cki8XlXXPYLOYve8pu
 MaHtK7PFjQlPGS0mHt/MavF5aQu7xbrX71ksTtySdpD1uHzF2+PfiTVsHhOb37F7nL+3kcXj
 8tlSj02rOtk8FjZMZfbYvKTeY/eCz0weu282sHn0Nr9j89jZep/V4/2+q2wefVtWMXqs33KV
 xWPC5o2sAUJRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF
 +nYJehkbFz5mLzgtWrG7fw97A+MpwS5GTg4JAROJQwe2MHYxcnEICSxllFi/fj8rREJC4vbC
 JkYIW1jiz7UuNoii54wS9w7uB3I4ONgEtCQaO9lB4iICTxgl7v98zALiMAs0sEjcmriLCaRb
 WCBMYtGrScwgNouAqkTPr+tgG3gFrCTmLZsLtU1eYual7+wgQzkFrCUmfIoACQsBlXQvugVV
 LihxcuYTFhCbGai8eets5gmMArOQpGYhSS1gZFrFKJJaWpybnltspFecmFtcmpeul5yfu4kR
 mFK2Hfu5ZQfjylcf9Q4xMnEwHmKU4GBWEuH9sjsjSYg3JbGyKrUoP76oNCe1+BCjKdDZE5ml
 RJPzgUktryTe0MzA1NDEzNLA1NLMWEmc17OgI1FIID2xJDU7NbUgtQimj4mDU6qBKU0o8r2c
 c0vGDb+Q+80WSYcz9VMqFQJXmlr3rDjkvSuF6+j/Llk+9atRm7jPldSJbjlj8zXssc7Li6rc
 zI9Zfz2vemEqe/lL4M4V8y7O3sGeVlD3c1/SyWMh+6fv2iavcjNQTPpmROjh7Nq1T65JWh64
 qcdQ77JNV/DM6hn3pzQs0lDmEHL2vX3280kOownb3x/vnDRjVva6xaqyTzdHfqy/s+6Ktk9T
 pO/R7x3+PVfOqG2Z+jdbbTLnprD3AQ1q7wXMvc9POl6rMJFZ+XCW2ffljOKruvI1Us5+Zn63
 zvts5/bb59ledTZtEoxalqum/V0s+hVb8CG2swu3K/ZoXVwlVmcjEfzgz4t/O1c+P6zEUpyR
 aKjFXFScCAAgq28nsgMAAA==
X-CMS-MailID: 20220427160300eucas1p1470fe30535849de6204bb78d7083cb3a
X-Msg-Generator: CA
X-RootMTR: 20220427160300eucas1p1470fe30535849de6204bb78d7083cb3a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160300eucas1p1470fe30535849de6204bb78d7083cb3a
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160300eucas1p1470fe30535849de6204bb78d7083cb3a@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 04/16] block: allow blk-zoned devices to have
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

Convert the calculations on zone size to be generic instead of relying on
power_of_2 based logic in the block layer using the helpers wherever
possible.

The only hot path affected by this change for power_of_2 zoned devices
is in blk_check_zone_append() but the effects should be negligible as the
helper blk_queue_zone_aligned() optimizes the calculation for those
devices. Note that the append path cannot be accessed by direct raw access
to the block device but only through a filesystem abstraction.

Finally, remove the check for power_of_2 zone size requirement in
blk-zoned.c

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-core.c  |  3 +--
 block/blk-zoned.c | 12 ++++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 937bb6b86331..850caf311064 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -634,8 +634,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
-	if (pos & (blk_queue_zone_sectors(q) - 1) ||
-	    !blk_queue_zone_is_seq(q, pos))
+	if (!blk_queue_zone_aligned(q, pos) || !blk_queue_zone_is_seq(q, pos))
 		return BLK_STS_IOERR;
 
 	/*
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 1dff4a8bd51d..f7c7c3bd148d 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -288,10 +288,10 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 		return -EINVAL;
 
 	/* Check alignment (handle eventual smaller last zone) */
-	if (sector & (zone_sectors - 1))
+	if (!blk_queue_zone_aligned(q, sector))
 		return -EINVAL;
 
-	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
+	if (!blk_queue_zone_aligned(q, nr_sectors) && end_sector != capacity)
 		return -EINVAL;
 
 	/*
@@ -489,14 +489,14 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	 * smaller last zone.
 	 */
 	if (zone->start == 0) {
-		if (zone->len == 0 || !is_power_of_2(zone->len)) {
-			pr_warn("%s: Invalid zoned device with non power of two zone size (%llu)\n",
-				disk->disk_name, zone->len);
+		if (zone->len == 0) {
+			pr_warn("%s: Invalid zoned device size",
+				disk->disk_name);
 			return -ENODEV;
 		}
 
 		args->zone_sectors = zone->len;
-		args->nr_zones = (capacity + zone->len - 1) >> ilog2(zone->len);
+		args->nr_zones = div64_u64(capacity + zone->len - 1, zone->len);
 	} else if (zone->start + args->zone_sectors < capacity) {
 		if (zone->len != args->zone_sectors) {
 			pr_warn("%s: Invalid zoned device with non constant zone size\n",
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

