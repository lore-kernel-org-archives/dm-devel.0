Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8F75C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 16:54:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-E7QlLI8jONCJDKN18gu4ig-1; Mon, 16 May 2022 12:54:42 -0400
X-MC-Unique: E7QlLI8jONCJDKN18gu4ig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1298811E76;
	Mon, 16 May 2022 16:54:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BD42FC44B0A;
	Mon, 16 May 2022 16:54:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9859E1947060;
	Mon, 16 May 2022 16:54:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0ED54194704E
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 16:54:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 00A2440147D; Mon, 16 May 2022 16:54:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F0CEA492C14
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7AB23C1023F
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:39 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-uZgvznDdPjmsTph96maoEQ-1; Mon, 16 May 2022 12:54:30 -0400
X-MC-Unique: uZgvznDdPjmsTph96maoEQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220516165429euoutp0184db0d4135a3d3533a21accfe7234c21~vpCWI8FUD2241322413euoutp011
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220516165429euoutp0184db0d4135a3d3533a21accfe7234c21~vpCWI8FUD2241322413euoutp011
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220516165427eucas1p1b7937c8e93a50f9ab55b194314c0ebb2~vpCUkQ-KR3100231002eucas1p1I;
 Mon, 16 May 2022 16:54:27 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id D6.40.10009.3C182826; Mon, 16
 May 2022 17:54:27 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220516165427eucas1p1cfd87ca44ec314ea1d2ddc8ece7259f9~vpCT-y5rM1659616596eucas1p1t;
 Mon, 16 May 2022 16:54:27 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220516165427eusmtrp19cc052b58b95fdd70c470b667b9eaf31~vpCT-DoC-2961829618eusmtrp1K;
 Mon, 16 May 2022 16:54:27 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-4e-628281c36dfb
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 3E.89.09522.2C182826; Mon, 16
 May 2022 17:54:26 +0100 (BST)
Received: from localhost (unknown [106.210.248.7]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220516165426eusmtip112dc0f7e69af738ccc790922191cbea1~vpCTmyPXE2383423834eusmtip1p;
 Mon, 16 May 2022 16:54:26 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, pankydev8@gmail.com,
 dsterba@suse.com, hch@lst.de
Date: Mon, 16 May 2022 18:54:09 +0200
Message-Id: <20220516165416.171196-7-p.raghav@samsung.com>
In-Reply-To: <20220516165416.171196-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7djPc7qHG5uSDN7OVrFYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBYrVx9lsug58IHFYu8tbYtLj1ewW+zZe5LF4vKuOWwW85c9Zbe4
 MeEpo8XnpS3sFmtuPmVx4Pf4d2INm8fOWXfZPS6fLfXYtKqTzWPzknqP3TcbgMKt91k93u+7
 yubRt2UVo8f6LVdZPD5vkgvgjuKySUnNySxLLdK3S+DKePd7K2PBIcmKrXdvMjYwfhLpYuTk
 kBAwkVg9byNbFyMXh5DACkaJS/dPsEA4XxglZkyYAZX5zCjx58dTdpiWl6e+sIDYQgLLGSU6
 topBFD1nlFh78iZrFyMHB5uAlkRjJ1i9iECWxLQTDxlBapgFFjNJrNwzGaxZWCBBYs/ec2wg
 NouAqsTv1cvA4rwCVhLXXlxjhVgmLzHz0nd2kJmcAtYSq7u4IUoEJU7OfAJWzgxU0rx1NjPI
 fAmB2ZwSV/o/MUP0ukgsab/LCGELS7w6vgXqARmJ05N7WCDsaomnN35DNbcwSvTvXM8GskwC
 aFnfmRwQk1lAU2L9Ln2IckeJjS19zBAVfBI33gpCnMAnMWnbdKgwr0RHmxBEtZLEzp9PoJZK
 SFxumgO11ENi1+lDjBMYFWcheWYWkmdmIexdwMi8ilE8tbQ4Nz212DAvtVyvODG3uDQvXS85
 P3cTIzDZnf53/NMOxrmvPuodYmTiYDzEKMHBrCTCa1DRkCTEm5JYWZValB9fVJqTWnyIUZqD
 RUmcNzlzQ6KQQHpiSWp2ampBahFMlomDU6qBqVhL7+LHimNKfa2/GNM0u17wTGx8XHj5qqDc
 ozWJSvUhCnmcp98p393KXzrf9+ehuftOdWu9Uy56voUx4byaoTOL676iZNboOMeVm7a+dH33
 7u6pJRfrZkyYkj5nV+lLiacnXm1b1bvmXuiDyNSZS9OWWE84U1j74LPsiU+1HV5Ln0RNsJtS
 kDQzpv388ncM5lFqB2dVTH6hxiS48Yd8se3Wy9mfQ1r38BtdSnjM+OparpD1pj2axpYBbkdS
 dY0fzdJ4qZlooHPlxuHJKZOEw5eIHcpVVe4tW32y5Etrcd2tJTcjuWLnZX1abnVI6zZnD8sW
 pgM3645Vf8gws38nH3Hz4YyKqQ3XJHR+3Kq/6qbEUpyRaKjFXFScCADVPX7M5QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t/xu7qHGpuSDPaus7RYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBYrVx9lsug58IHFYu8tbYtLj1ewW+zZe5LF4vKuOWwW85c9Zbe4
 MeEpo8XnpS3sFmtuPmVx4Pf4d2INm8fOWXfZPS6fLfXYtKqTzWPzknqP3TcbgMKt91k93u+7
 yubRt2UVo8f6LVdZPD5vkgvgjtKzKcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV
 0rezSUnNySxLLdK3S9DLePd7K2PBIcmKrXdvMjYwfhLpYuTkkBAwkXh56gtLFyMXh5DAUkaJ
 JU3rGCESEhK3FzZB2cISf651sUEUPWWUuN+9DqiDg4NNQEuisZMdpEZEoEBiTv8WsEHMAmuZ
 JF7/eM8IUiMsECfR+1wZpIZFQFXi9+plLCA2r4CVxLUX11gh5stLzLz0nR2knFPAWmJ1FzdI
 WAio5OuTW+wQ5YISJ2c+AWtlBipv3jqbeQKjwCwkqVlIUgsYmVYxiqSWFuem5xYb6hUn5haX
 5qXrJefnbmIExuW2Yz8372Cc9+qj3iFGJg7GQ4wSHMxKIrwGFQ1JQrwpiZVVqUX58UWlOanF
 hxhNgc6eyCwlmpwPTAx5JfGGZgamhiZmlgamlmbGSuK8ngUdiUIC6YklqdmpqQWpRTB9TByc
 Ug1MLoEdnFe0ths1swlvms4q/mmL4Fujvn8HLxz4ppOS/UZs1rLfpiZqAtu6777Stf8oMWfe
 Jr9qP7ukzYH/VhlYTxNlc55/9Hz+zQ5JhapXG79t2Jpg2/NtdbDXq4R3Rmxdj6I2c0e9lvmy
 58ArG2YH6+zEHffCn9V5Xfh0ZLq4GePRjlBX4T1/TctMsr6tqbc+WBl71HEVm0+Ub/77c4si
 pbUvBIb220m4uL8ouhv9csmM82Hy88JzeFJVpNTsamccO7naQ+PLmiyF+LKz2bfvebE0e7Kd
 /LTwvUje9Rv1VuXml/R/J8X/uxD+7MmGlXUJrL32e+3UUzYvFPp/u+Xh3mSWZimeEEsGHYeV
 cQJKLMUZiYZazEXFiQCKFWZPVAMAAA==
X-CMS-MailID: 20220516165427eucas1p1cfd87ca44ec314ea1d2ddc8ece7259f9
X-Msg-Generator: CA
X-RootMTR: 20220516165427eucas1p1cfd87ca44ec314ea1d2ddc8ece7259f9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165427eucas1p1cfd87ca44ec314ea1d2ddc8ece7259f9
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165427eucas1p1cfd87ca44ec314ea1d2ddc8ece7259f9@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v4 06/13] btrfs: zoned: Make sb_zone_number
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
Cc: p.raghav@samsung.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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

