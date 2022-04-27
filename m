Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA3DC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-t5pS7rZSOU63nF331PUBLg-1; Fri, 29 Apr 2022 04:23:54 -0400
X-MC-Unique: t5pS7rZSOU63nF331PUBLg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFF2B2811766;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BDE7854B08B;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DC4F3194705F;
	Fri, 29 Apr 2022 08:23:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7D1461947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:11:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 66A2D2166B1A; Wed, 27 Apr 2022 16:11:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 60E7B2166B4D
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 646D880352D
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-dKKlltiMPCCgfnjdeKaRTg-1; Wed, 27 Apr 2022 12:11:48 -0400
X-MC-Unique: dKKlltiMPCCgfnjdeKaRTg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160306euoutp02fc8417cc3913a0df293086d79bbaabdb~pzFDbrqjJ1441914419euoutp021
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:03:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220427160306euoutp02fc8417cc3913a0df293086d79bbaabdb~pzFDbrqjJ1441914419euoutp021
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160304eucas1p2132f5d8996bb4be8c720545503199880~pzFBzwJqs2337723377eucas1p2a;
 Wed, 27 Apr 2022 16:03:04 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 90.14.09887.83969626; Wed, 27
 Apr 2022 17:03:04 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220427160303eucas1p1c7d1b743e9ecf77b4f203bdeccbe382e~pzFBSE8tz0330203302eucas1p1Q;
 Wed, 27 Apr 2022 16:03:03 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220427160303eusmtrp242409ff9824954bbde9684e0ce2d4e12~pzFBRNRlD2598325983eusmtrp2l;
 Wed, 27 Apr 2022 16:03:03 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-55-62696938c9ff
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 74.81.09522.73969626; Wed, 27
 Apr 2022 17:03:03 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160303eusmtip204431c6f8fcfa88dcd1d0a173a580914~pzFA_seRx2538025380eusmtip2M;
 Wed, 27 Apr 2022 16:03:03 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:46 +0200
Message-Id: <20220427160255.300418-8-p.raghav@samsung.com>
In-Reply-To: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxbVRjGc+65vS1EyKVUOYxNZ6NOZujEoDk6JSxMvdEEv5Y5HX4UdqUN
 tGBLZWNL5NuBEwoKa8ukbHED2Ur5GrR06KwyYMDWUHAFEYdShOooCA6xgtJdFvff733f53mf
 8yZHAIVmapNArsxkVUppmpgKJNsvrVyJwnJ50qO6c3dh8+VLEJ/9sYzCVfMrEPdXDhK4okzH
 x77BqxB3zVXzsOOvXAKPXrQS+Muz3QSeMhsgPnZxnsSrJRPrvYJJiP+ZjMYV9u8Bdo8YCNw1
 9gge+qWej4dOPY8vdPWR2Nl5gsLGM24+1hb9CbFL6wa4vKeVhxdPF/Bx429eEveORcRtYZzD
 LzJrvecopjx/js9cnWgmGeeghmlpKKaYkzmVkGn94kPGVrtIMLbRHIr5JH+OYqyFP/EY71cj
 FFPa1gAYc9sIyWhbm3kvC98MfPoAmyb/gFXtiH03UNb5rQ5mDIQdNOm/JnOAObQEBAgQHYMs
 Cw5eCQgUCOl6gJqMrYR/IKSXALrRLOEGiwDNnO/l3XZ4b9ZuOOoA+qHQQXHFLEBzM3p+CRAI
 KHo7yi3m+/si2gVQeVMT4S8g7YHI0XbtVkYovR9NdPdTfibpB5F++XPo5yD6KTRW5duIuw/p
 h5ZvLQ2gdyLtH/s4SQjq00+Rfobrkvzz1dC/H9GmQKSz2iDn3Y0Kbn4HOA5Fnp42Pseb0b9W
 I8HxYeR2+TbMBQCVWc2UPwyth5UOpPkR0pHI3LmDk+9Cx49dAJwiGLluhHBPCEYV7cch1w5C
 R4uEnFqMrCtTG6EIOfNOkBwzqONML9CC+w13HGO44xjD/7m1ADaAMFajVqSw6seUbJZELVWo
 NcoUSXK6ogWs/+n+tZ4lC6jzLEjsgBAAO0ACKBYFLdlkScKgA9JD2awq/R2VJo1V20GEgBSH
 BSXLm6RCOkWayaaybAaruj0lBAGbcohPx8ZHpp1vhD6ghVubs0d3i73BoiNru55b/vXhRbVr
 9MrwNMlrd5finyNdmydmi5M1e0v3R01ujT/0Kq+x6FlL3fLdiUdXedfjB4Ymx98z/l0o9loi
 Tpnz7DHxyy2vPHk5deoh054Od2rF/OEExTd7a8L7VL59r8WK5j0s3xG+kGVajBwm1+ZsSTtL
 LZ81sks1byWmZM7uiX9d88I9NZK4GGP5R9syomWNuduy02MCFvLSm18SiY+Q091xJ2N8Sk9W
 HBk1beRnmRrefmamfy0l0pac4DlYWX3t+pYeT7bSEmJLuDf3tEyY+H5VkunjJ1ZTnbG5Csfj
 7vq68Cjz+NjvHToxqZZJo7dDlVr6H6cw1YdCBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t/xe7rmmZlJBpeuq1usP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlmsXH2UyeLJ+lnMFj0HPrBY
 /O26BxRrechs8eehocWkQ9cYLZ5encVksfeWtsWlxyvYLS4tcrfYs/cki8XlXXPYLOYve8pu
 MaHtK7PFjQlPGS0mHt/MavF5aQu7xbrX71ksTtySdpD1uHzF2+PfiTVsHhOb37F7nL+3kcXj
 8tlSj02rOtk8FjZMZfbYvKTeY/eCz0weu282sHn0Nr9j89jZep/V4/2+q2wefVtWMXqs33KV
 xWPC5o2sAUJRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF
 +nYJehm7Ds9gLjgjXrF25n6WBsb1wl2MnBwSAiYS778tYO1i5OIQEljKKLGg5QEzREJC4vbC
 JkYIW1jiz7UuNhBbSOA5o8Tpc1xdjBwcbAJaEo2d7CC9IgJPGCXu/3zMAuIwCzSwSNyauIsJ
 pEFYIFKi++dWdhCbRUBVYub3uWALeAWsJG5N+80KsUBeYual7+wgQzkFrCUmfIqA2GUl0b3o
 FitEuaDEyZlPWEBsZqDy5q2zmScwCsxCkpqFJLWAkWkVo0hqaXFuem6xoV5xYm5xaV66XnJ+
 7iZGYELZduzn5h2M81591DvEyMTBeIhRgoNZSYT3y+6MJCHelMTKqtSi/Pii0pzU4kOMpkBn
 T2SWEk3OB6a0vJJ4QzMDU0MTM0sDU0szYyVxXs+CjkQhgfTEktTs1NSC1CKYPiYOTqkGJs6X
 V9cdyO1yCFG+ufLA+h/ijtW79e3tag/yHDpgLaCcMU9d69uH/PudEdIv469UB/ed6N1bdeIm
 c+6MBbWvNWqtusRMGFQ25H+/n3tG2Lhto+SU3bP3e72SfiHhvfDc27TJhrVfZjVKLczw++LA
 WSG1NfPitQXOu/v5q6Z3dvuHeh5569pebMrAX3qbWcuprrVqef4PS3/T/r9ZjT8jpWcuYVo+
 y/b07V/Pfk+IFTtwv69g9z6r3tepy0+U6dhX/lreVzvB1e6Vz9KJLKKzqq5POs121tKvrPyF
 dMXtBz8fXYuas0ZMX3Vi8MXr0z+m8NjfCDo752qoienP+wyPOk1urNkzu3nzqUUf9i21MlBi
 Kc5INNRiLipOBABGrugrsQMAAA==
X-CMS-MailID: 20220427160303eucas1p1c7d1b743e9ecf77b4f203bdeccbe382e
X-Msg-Generator: CA
X-RootMTR: 20220427160303eucas1p1c7d1b743e9ecf77b4f203bdeccbe382e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160303eucas1p1c7d1b743e9ecf77b4f203bdeccbe382e
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160303eucas1p1c7d1b743e9ecf77b4f203bdeccbe382e@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 07/16] btrfs: zoned: Cache superblock location in
 btrfs_zoned_device_info
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Instead of calculating the superblock location every time, cache the
superblock zone location in btrfs_zoned_device_info struct and use it to
locate the zone index.

The functions such as btrfs_sb_log_location_bdev() and
btrfs_reset_sb_log_zones() which work directly on block_device shall
continue to use the sb_zone_number because btrfs_zoned_device_info
struct might not have been initialized at that point.

This patch will enable non power-of-2 zoned devices to not perform
division to lookup superblock and its mirror location.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/btrfs/zoned.c | 13 +++++++++----
 fs/btrfs/zoned.h |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1b1b310c3c51..6f76942d0ea5 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -512,6 +512,11 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 			   max_active_zones - nactive);
 	}
 
+	/* Cache the sb zone number */
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; ++i) {
+		zone_info->sb_zone_location[i] =
+			sb_zone_number(zone_info->zone_size_shift, i);
+	}
 	/* Validate superblock log */
 	nr_zones = BTRFS_NR_SB_LOG_ZONES;
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
@@ -519,7 +524,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		u64 sb_wp;
 		int sb_pos = BTRFS_NR_SB_LOG_ZONES * i;
 
-		sb_zone = sb_zone_number(zone_info->zone_size_shift, i);
+		sb_zone = zone_info->sb_zone_location[i];
 		if (sb_zone + 1 >= zone_info->nr_zones)
 			continue;
 
@@ -867,7 +872,7 @@ int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 		return 0;
 	}
 
-	zone_num = sb_zone_number(zinfo->zone_size_shift, mirror);
+	zone_num = zinfo->sb_zone_location[mirror];
 	if (zone_num + 1 >= zinfo->nr_zones)
 		return -ENOENT;
 
@@ -884,7 +889,7 @@ static inline bool is_sb_log_zone(struct btrfs_zoned_device_info *zinfo,
 	if (!zinfo)
 		return false;
 
-	zone_num = sb_zone_number(zinfo->zone_size_shift, mirror);
+	zone_num = zinfo->sb_zone_location[mirror];
 	if (zone_num + 1 >= zinfo->nr_zones)
 		return false;
 
@@ -1012,7 +1017,7 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 			u32 sb_zone;
 			u64 sb_pos;
 
-			sb_zone = sb_zone_number(shift, i);
+			sb_zone = zinfo->sb_zone_location[i];
 			if (!(end <= sb_zone ||
 			      sb_zone + BTRFS_NR_SB_LOG_ZONES <= begin)) {
 				have_sb = true;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index cbf016a7bb5d..49317524e9a6 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -31,6 +31,7 @@ struct btrfs_zoned_device_info {
 	unsigned long *active_zones;
 	struct blk_zone *zone_cache;
 	struct blk_zone sb_zones[2 * BTRFS_SUPER_MIRROR_MAX];
+	u32 sb_zone_location[BTRFS_SUPER_MIRROR_MAX];
 };
 
 #ifdef CONFIG_BLK_DEV_ZONED
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

