Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD918C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  6 May 2022 08:11:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-RW0uRTQ-MVWB8Ujlnh9mXQ-1; Fri, 06 May 2022 04:11:31 -0400
X-MC-Unique: RW0uRTQ-MVWB8Ujlnh9mXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53A6786B8AC;
	Fri,  6 May 2022 08:11:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F66F40D2820;
	Fri,  6 May 2022 08:11:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C6691947057;
	Fri,  6 May 2022 08:11:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2AE991947057
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 May 2022 08:11:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1DC61111DCF9; Fri,  6 May 2022 08:11:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1914B111DCF2
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90F4C1875068
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:17 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-X_cDvRX8P1CerW6zeSEoxA-1; Fri, 06 May 2022 04:11:16 -0400
X-MC-Unique: X_cDvRX8P1CerW6zeSEoxA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220506081115euoutp02729cfa0cfc73b8ab9802d7f11bafd3c4~sdcpLR44T2333723337euoutp024
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220506081115euoutp02729cfa0cfc73b8ab9802d7f11bafd3c4~sdcpLR44T2333723337euoutp024
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220506081113eucas1p2f26a6d8f18f7cbb7ff59652198904281~sdcneF8rQ1186311863eucas1p2N;
 Fri,  6 May 2022 08:11:13 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id C3.17.10009.128D4726; Fri,  6
 May 2022 09:11:13 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220506081112eucas1p2f6116cb713749c259a6da533df9c2505~sdcm-zlTq0616806168eucas1p2r;
 Fri,  6 May 2022 08:11:12 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220506081112eusmtrp1cb2b5b25d973a47abc875150c38a6a35~sdcm_v8_A3089330893eusmtrp1R;
 Fri,  6 May 2022 08:11:12 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-96-6274d8216386
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id F4.F9.09404.028D4726; Fri,  6
 May 2022 09:11:12 +0100 (BST)
Received: from localhost (unknown [106.210.248.174]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220506081112eusmtip29939a1aabce6a042ae1abb239d666502~sdcmlVHIw2136621366eusmtip2V;
 Fri,  6 May 2022 08:11:12 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, hare@suse.de, dsterba@suse.com, axboe@kernel.dk,
 hch@lst.de, damien.lemoal@opensource.wdc.com, snitzer@kernel.org
Date: Fri,  6 May 2022 10:11:00 +0200
Message-Id: <20220506081105.29134-7-p.raghav@samsung.com>
In-Reply-To: <20220506081105.29134-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTZxjG9/Wcnh6aQQ4twjdhMTbIImQgbMm+ObeBmuwElylLlmW6TSuc
 IVlB08u8sMReWGlBoJSAUl2mjiHgpEiBcGkZKwpiQSulWyE47KDbcIqKUGQ4meXUzP9+7+15
 3jd5SUzQSKwmc/LkjDRPLBERfLytb/Haq2s98r0b9BUkMl/tw9CytY9A52+WEajq/iKGjGUn
 eGhp6DqGbDMnucj5SMVBoz0dHGQ9a+Sg+vOXOWjKbMLQsZ77OKov8GLosTcZeefGcGS0/wKQ
 z23iINtYAhqerOMhq20AR67OUwT6rtbHQwbtPIY8Bh9A5f0WLnr4QwEPNf59D0dXxqJTX6Zd
 I9voJ1d+JOhyzQyPvv7bRZx2DSno5gY9QZ9RVmK0peYo3TWqJOgSzQxBd3wzwaXvdbsJurSl
 AdDmFjdOWxz5tMFykbtDsJO/KYuR5HzFSJPe2cPfN7PUCg7YXzrUenMUKMFsRBEIISH1Oqxq
 rOAVAT4poOoAdJbrABvMAejytHPY4CGAvd/7eM9GJooHuWzhHIDqc3aCDaYBbPOPYUWAJAkq
 Hqr0K7oRVDGAZROFK9MYZeFC54UvAiyk9sB/3Fo8wDi1Dv40cnaFQ6k34Z3ukqDbGlg9vLDC
 IdRGqK6YJtiecDhQPYWzmmugpvUkxvbX86F/HGd5K6yu0wXzQni7vyWoGQMdFceCPfnQ51nC
 AotCquDpoh1mInAApN6CpYOSAGLUemjuTGKzabC18GsWw6Dnbji7QBg0th3H2HQo1GkFrLYI
 dixOBT0hdKlPBT1pOK40cg1grem5U0zPnWL63/Y0wBpAFKOQ5WYzsuQ85mCiTJwrU+RlJ2bu
 z20GT1/a8aR/th18e/tBoh1wSGAHkMREEaFCk3yvIDRLfPgII92/W6qQMDI7iCZxUVRoZk6T
 WEBli+XMlwxzgJE+q3LIkNVKTrr1jRTgOOG9lLZ7046MgQXDrXWa8k9+p0oPpaesv5xyxwJi
 lelY1nZL7yuVn5kblMYe20HJR7u6fk4dipVxtL2Pm5t0xB9Nat1cmtD97qe6NsGk9bXa/lj1
 Tntc3zTz4jXVUrb/harDKLxN/oHw3/yluUp9zaMw/9XOuMHCGkGf01ksjKheuJGV0b41NXGL
 1XirSxvt3LBL+Xl0jezItqJVMfOKxrSE7Znz8ZHz6JLzQ29nyds2LNIljxl3Li4ftSa1v//n
 cpSmf2E2UaeP0KtqHQXvDfnL2sM/xm2bRXDjFi6Kw4dVdy/8lZEeOdJFOFZ1T/Y+sPETNntv
 WH+lRbhsnzg5HpPKxP8BwsRvkUEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t/xe7oKN0qSDD43KFqsP3WM2eL/nmNs
 Fqvv9rNZTPvwk9liUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlnsWTSJyWLl6qNMFk/Wz2K2
 6DnwgcViZctDZos/Dw0tHn65xWIx6dA1RounV2cxWey9pW1x6fEKdos9e0+yWFzeNYfNYv6y
 p+wWE9q+MlvcmPCU0WLi8c2sFp+XtrBbrHv9nsXixC1pB1mPy1e8Pf6dWMPmMbH5HbvH+Xsb
 WTwuny312LSqk81jYcNUZo/NS+o9dt9sYPPobX7H5rGz9T6rx/t9V9k8+rasYvRYv+Uqi8fm
 09UeEzZvZA0QitKzKcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxL
 LdK3S9DLePd7K2PBIcmKrXdvMjYwfhLpYuTkkBAwkbjffYa1i5GLQ0hgKaPEgTtNzBAJCYnb
 C5sYIWxhiT/Xutggip4zStxZ0wOU4OBgE9CSaOxkB4mLCExllLi07iQLiMMscJpVYuumA0wg
 3cICcRL7rswEm8oioCqx/8oiFhCbV8BS4s2+XnaIDfISMy99B7M5Bawkmia/ZAOxhYBq5i/Z
 wwpRLyhxcuYTsF5moPrmrbOZJzAKzEKSmoUktYCRaRWjSGppcW56brGRXnFibnFpXrpecn7u
 JkZgUtl27OeWHYwrX33UO8TIxMF4iFGCg1lJhFd4VkmSEG9KYmVValF+fFFpTmrxIUZToLsn
 MkuJJucD01peSbyhmYGpoYmZpYGppZmxkjivZ0FHopBAemJJanZqakFqEUwfEwenVAPTaru7
 fqkiB7Z/3z5HteR47P51U/ZdY+n3yMv8+8JY4PdZ72Ml8am+T+b/nthqoLU87bHUqT1OtSxc
 wufWGRsUy33KY4g/UZZeqNU1wS7I0rx99mHnz9KyF1r2VG/o+uJ/JNvn1rkyj+TEQ3uYns7O
 e3TwjEJKdsVMz9RnIZOt5vWWBzVfWi50Sq0mOvRtndrlmTziddzvw31l/n4LuVMR/PvaLfFr
 AV0vnB9NK2Oa6r908aLU8/H7Eq8meIuwXbt+s8nG7GrTm5LrPAH3f3WXHGZWm5XZdmrKhOlF
 k5aa5O+YFCNZIPzSYrsUw+ovj9y5HXRWuZ7j3X1la5bOjbf3fjfG9Sf67unRFTx9obReiaU4
 I9FQi7moOBEAETYNDLMDAAA=
X-CMS-MailID: 20220506081112eucas1p2f6116cb713749c259a6da533df9c2505
X-Msg-Generator: CA
X-RootMTR: 20220506081112eucas1p2f6116cb713749c259a6da533df9c2505
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220506081112eucas1p2f6116cb713749c259a6da533df9c2505
References: <20220506081105.29134-1-p.raghav@samsung.com>
 <CGME20220506081112eucas1p2f6116cb713749c259a6da533df9c2505@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v3 06/11] btrfs: zoned: Make sb_zone_number
 function non power of 2 compatible
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
Cc: jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 Chris Mason <clm@fb.com>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 bvanassche@acm.org, gost.dev@samsung.com, jonathan.derrick@linux.dev,
 Pankaj Raghav <p.raghav@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org,
 Keith Busch <kbusch@kernel.org>, matias.bjorling@wdc.com,
 Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>,
 linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
 linux-fsdevel@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
index e8c7cebb2..5be2ef7bb 100644
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
@@ -514,7 +519,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	/* Cache the sb zone number */
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; ++i) {
 		zone_info->sb_zone_location[i] =
-			sb_zone_number(zone_info->zone_size_shift, i);
+			sb_zone_number(bdev, i);
 	}
 	/* Validate superblock log */
 	nr_zones = BTRFS_NR_SB_LOG_ZONES;
@@ -839,7 +844,7 @@ int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
 	nr_sectors = bdev_nr_sectors(bdev);
 	nr_zones = nr_sectors >> zone_sectors_shift;
 
-	sb_zone = sb_zone_number(zone_sectors_shift + SECTOR_SHIFT, mirror);
+	sb_zone = sb_zone_number(bdev, mirror);
 	if (sb_zone + 1 >= nr_zones)
 		return -ENOENT;
 
@@ -963,7 +968,7 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
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

