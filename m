Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA2EC4332F
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-9XA6003jP_6-ftExA2CBGw-1; Fri, 29 Apr 2022 04:23:49 -0400
X-MC-Unique: 9XA6003jP_6-ftExA2CBGw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC72380418E;
	Fri, 29 Apr 2022 08:23:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D74DE1468945;
	Fri, 29 Apr 2022 08:23:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4FF6B1947079;
	Fri, 29 Apr 2022 08:23:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0358F1947042
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:11:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E7FFA40314B; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3925416146
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAAC21815CF7
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-KizMd0i8O7-9MF51Esaflg-1; Wed, 27 Apr 2022 12:11:48 -0400
X-MC-Unique: KizMd0i8O7-9MF51Esaflg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160308euoutp02ddf57de57af0bcf22f8ef5e9cd3f67f5~pzFFZcA4n1618616186euoutp02F
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:03:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220427160308euoutp02ddf57de57af0bcf22f8ef5e9cd3f67f5~pzFFZcA4n1618616186euoutp02F
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160306eucas1p2e570e1b4e34a5067bb507ed05d2d73a6~pzFDvZ7kA0627806278eucas1p29;
 Wed, 27 Apr 2022 16:03:06 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 5A.0A.10260.A3969626; Wed, 27
 Apr 2022 17:03:06 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220427160305eucas1p26831c19df0b2097e42209edcf73526b7~pzFDM2UI22337723377eucas1p2c;
 Wed, 27 Apr 2022 16:03:05 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220427160305eusmtrp1235314abc78e18282c5dc2e5777199f2~pzFDL4Ere2077420774eusmtrp1T;
 Wed, 27 Apr 2022 16:03:05 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-92-6269693aae9b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 13.A7.09404.93969626; Wed, 27
 Apr 2022 17:03:05 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160305eusmtip22f05675131d051368efed5b5a469ebf6~pzFC4wzQ40262002620eusmtip2Q;
 Wed, 27 Apr 2022 16:03:05 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:48 +0200
Message-Id: <20220427160255.300418-10-p.raghav@samsung.com>
In-Reply-To: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0xTVxzOuef29tKs7lIqHsW5rQvZxgaKmnAyl4VtZrsJxgc+ZmZ8FLyB
 ulJIK5ubSywPmRCgBdRZHhOq2FKQ8pIIDAY1vGSAo2MD3BCEymQTxBaB4Mgot2b+9/2+8z1+
 v+TQUGKl1tEK1UlOrZIrZZSIrG1b6Al8T6GI2NSSJ8HW220Ql/6po/DFxwsQd13oJnC27pIQ
 L3b3Qtw4lSfAd+YTCDzYXEfgktJWAo9bcyFOb35M4n/Thpe55FGIn40G42zbbwA7+nMJ3Dj0
 Du4bMwtxn/FT/GNjJ4nt9fkUvnzNIcT6lFmIB/QOgLPaqwXYWZwsxOV/T5O4Y8gv9BXW/msY
 u9RRRrFZSVNCtne4kmTt3fFslSWVYou0FyBbffUM21DoJNiGQS3FZiRNUWzd2XsCdrqpn2Iz
 ayyAtdb0k6y+ulKwW/K56P3jnFLxJafe+MExUbQx2yCM61h7ajjfQGrBvDQNeNGI2Yp+aUkU
 pAERLWHMAJmKejyDC6C7nW2AH5wA3fzuLPXc4iobhm4sYUwA1bd686KHACWZ7cI0QNMUE4AS
 UoVuXsoMAJRVUUG4B8hMQnSn5nfC7fZhDiNTbzvpxiTjj7pnL62kipltKMVsI/m2V5Ghb24l
 1GuZ1z85yEu8UadhfEUClyVJN/KgOx8xxSKUqFsS8t7taGLMJuCxD5psr/Hw61FXTron/zRy
 DCx6zMkA6eqslLsMLZdl/qx0Q8i8jaz1G3n5h2g287KAV6xCA4+8+RVWoeza7yFPi9G5FAmv
 lqG6hXFPKUL2xHxPKYtGbpgoPXg994Vjcl84Jvf/3kIALWANF6+JieI0W1TcV0EaeYwmXhUV
 FBkbUwWW/3TXUvvsTWCenAmyAYIGNoBoKJOKXQ3RERLxcfnX33Dq2KPqeCWnsQE/mpStEUcq
 KuQSJkp+kvuC4+I49fNXgvZapyVU5fGBIuX0oRhd3ga69eJqcdq3m8/cmgxITwh5su+NQ+oh
 rVHzWVHJjvICYWJTM5MR5COaeaAr236/+lyzc1Np+N2/8lLX5ty6vot2ZvpuVspUhccmiuWa
 bfOOj0IfFl45+klbP/Hmbik+YHatLhjNIrhrfyTfNnjtcPpfV0zO5VSFGg/Gfpzdu7VEdl/v
 mIl7FBOmM0sGIwq2CGqDZXMTu06E//PynpCxFlm+cXDvS75HAsubfIM39LwlbQYW7ZLpQOqR
 pxHP6rmFFL+Cd21XmMU9O8sy/cJdA/bwn4Z3jozAH+DT84cr66szHogTwvxPnDKtX7SEJO7b
 z/jvlUW+dvqejNREy4MDoFoj/w824O1PQgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t/xe7qWmZlJBsfP61isP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlmsXH2UyeLJ+lnMFj0HPrBY
 /O26BxRrechs8eehocWkQ9cYLZ5encVksfeWtsWlxyvYLS4tcrfYs/cki8XlXXPYLOYve8pu
 MaHtK7PFjQlPGS0mHt/MavF5aQu7xbrX71ksTtySdpD1uHzF2+PfiTVsHhOb37F7nL+3kcXj
 8tlSj02rOtk8FjZMZfbYvKTeY/eCz0weu282sHn0Nr9j89jZep/V4/2+q2wefVtWMXqs33KV
 xWPC5o2sAUJRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF
 +nYJehmLJs1kLzghWXFvzkyWBsYfIl2MnBwSAiYSX9bcY+5i5OIQEljKKPF+xwoWiISExO2F
 TYwQtrDEn2tdbBBFzxklbs8AcTg42AS0JBo72UHiIgJPGCXu/3zMAuIwCzSwSNyauIsJpFtY
 IFqib9czdhCbRUBV4uzXGcwgNq+AtUTbikNQ2+QlZl76zg4ylBMoPuFTBEhYSMBKonvRLVaI
 ckGJkzOfgJUzA5U3b53NPIFRYBaS1CwkqQWMTKsYRVJLi3PTc4uN9IoTc4tL89L1kvNzNzEC
 U8q2Yz+37GBc+eqj3iFGJg7GQ4wSHMxKIrxfdmckCfGmJFZWpRblxxeV5qQWH2I0BTp7IrOU
 aHI+MKnllcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJpCeWpGanphakFsH0MXFwSjUwSeoz9Aau
 c5v8yPPef/mGLUcSK5P+ZIqqOZWK3bvHsspW/llBw4I/NU99v5rwSnCbvDs9UV4ibv1S1RY+
 0QuzAmcu+rxcbfJKpbAjr1dFPnF0/e/3KGt67q6Lh6ed1o7PbfBsu6UcGCr/57r8tDk9ftfU
 05LtZqixcLE8ZeAx5p3ztszaP27ijf3Ce701NbNVH+WcnCBwumHJvebD5cd7Za+rRe94yyZ5
 Jef8T+F0+2rR3Kkq/y6fPnlZe5OMUd6yB3t5up4mFNhO6l9Zp2K3iFmj+qXcFRVdZom5qrf0
 FWX3MEgtv/4j1/cEv/n5Q6mMd8w7T7CyH+XpuzUpTcxTtWwlx8xUEZ6pk6r3rZyhxFKckWio
 xVxUnAgAjuFRN7IDAAA=
X-CMS-MailID: 20220427160305eucas1p26831c19df0b2097e42209edcf73526b7
X-Msg-Generator: CA
X-RootMTR: 20220427160305eucas1p26831c19df0b2097e42209edcf73526b7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160305eucas1p26831c19df0b2097e42209edcf73526b7
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160305eucas1p26831c19df0b2097e42209edcf73526b7@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 09/16] btrfs: zoned: Make sb_zone_number function
 non power of 2 compatible
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Make the calculation in sb_zone_number function to be generic and work
for both power-of-2 and non power-of-2 zone sizes.

The function signature has been modified to take block device and mirror
as input as this function is only invoked from callers that have access
to the block device. This enables to use the generic bdev_zone_no
function provided by the block layer to calculate the zone number.

Even though division is used to calculate the zone index for non
power-of-2 zone sizes, this function will not be used in the fast path as
the sb_zone_location cache is used for the superblock zone location.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/btrfs/zoned.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 6f76942d0ea5..8f574a474420 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -34,9 +34,6 @@
 #define BTRFS_SB_LOG_FIRST_OFFSET	(512ULL * SZ_1G)
 #define BTRFS_SB_LOG_SECOND_OFFSET	(4096ULL * SZ_1G)
 
-#define BTRFS_SB_LOG_FIRST_SHIFT	const_ilog2(BTRFS_SB_LOG_FIRST_OFFSET)
-#define BTRFS_SB_LOG_SECOND_SHIFT	const_ilog2(BTRFS_SB_LOG_SECOND_OFFSET)
-
 /* Number of superblock log zones */
 #define BTRFS_NR_SB_LOG_ZONES 2
 
@@ -153,15 +150,23 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 /*
  * Get the first zone number of the superblock mirror
  */
-static inline u32 sb_zone_number(int shift, int mirror)
+static inline u32 sb_zone_number(struct block_device *bdev, int mirror)
 {
 	u64 zone;
 
 	ASSERT(mirror < BTRFS_SUPER_MIRROR_MAX);
 	switch (mirror) {
-	case 0: zone = 0; break;
-	case 1: zone = 1ULL << (BTRFS_SB_LOG_FIRST_SHIFT - shift); break;
-	case 2: zone = 1ULL << (BTRFS_SB_LOG_SECOND_SHIFT - shift); break;
+	case 0:
+		zone = 0;
+		break;
+	case 1:
+		zone = bdev_zone_no(bdev,
+				    BTRFS_SB_LOG_FIRST_OFFSET >> SECTOR_SHIFT);
+		break;
+	case 2:
+		zone = bdev_zone_no(bdev,
+				    BTRFS_SB_LOG_SECOND_OFFSET >> SECTOR_SHIFT);
+		break;
 	}
 
 	ASSERT(zone <= U32_MAX);
@@ -515,7 +520,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	/* Cache the sb zone number */
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; ++i) {
 		zone_info->sb_zone_location[i] =
-			sb_zone_number(zone_info->zone_size_shift, i);
+			sb_zone_number(bdev, i);
 	}
 	/* Validate superblock log */
 	nr_zones = BTRFS_NR_SB_LOG_ZONES;
@@ -840,7 +845,7 @@ int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
 	nr_sectors = bdev_nr_sectors(bdev);
 	nr_zones = nr_sectors >> zone_sectors_shift;
 
-	sb_zone = sb_zone_number(zone_sectors_shift + SECTOR_SHIFT, mirror);
+	sb_zone = sb_zone_number(bdev, mirror);
 	if (sb_zone + 1 >= nr_zones)
 		return -ENOENT;
 
@@ -964,7 +969,7 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 	nr_sectors = bdev_nr_sectors(bdev);
 	nr_zones = nr_sectors >> zone_sectors_shift;
 
-	sb_zone = sb_zone_number(zone_sectors_shift + SECTOR_SHIFT, mirror);
+	sb_zone = sb_zone_number(bdev, mirror);
 	if (sb_zone + 1 >= nr_zones)
 		return -ENOENT;
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

