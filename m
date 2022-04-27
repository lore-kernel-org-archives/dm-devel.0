Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE075C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-KAWdkHmAMD2RhmI3WSq70Q-1; Fri, 29 Apr 2022 04:23:54 -0400
X-MC-Unique: KAWdkHmAMD2RhmI3WSq70Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 771C880419B;
	Fri, 29 Apr 2022 08:23:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5CD6B40869DB;
	Fri, 29 Apr 2022 08:23:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE4B71947BA3;
	Fri, 29 Apr 2022 08:23:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E94D51947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:12:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C708C2166B16; Wed, 27 Apr 2022 16:12:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C19C92166B4D
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:12:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3CBC101AA42
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:12:23 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-oJ29iCMvMeSDp_B1CaKABw-1; Wed, 27 Apr 2022 12:12:21 -0400
X-MC-Unique: oJ29iCMvMeSDp_B1CaKABw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160306euoutp019d67a46960492979e6e7195d4863a849~pzFEKeZz80318203182euoutp01V
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:03:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220427160306euoutp019d67a46960492979e6e7195d4863a849~pzFEKeZz80318203182euoutp01V
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160305eucas1p23f1ca6b3cc5d07b7197b62455d839133~pzFCtQUuI1589415894eucas1p2K;
 Wed, 27 Apr 2022 16:03:05 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 7B.D7.10009.93969626; Wed, 27
 Apr 2022 17:03:05 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220427160304eucas1p1a0080df82f76c39882c4298c3c3d99fd~pzFCRIwGd2685626856eucas1p1p;
 Wed, 27 Apr 2022 16:03:04 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220427160304eusmtrp21dbea116401f4753609014b6527a5210~pzFCQGpO42598325983eusmtrp2o;
 Wed, 27 Apr 2022 16:03:04 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-7f-626969390a70
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id C6.81.09522.83969626; Wed, 27
 Apr 2022 17:03:04 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160304eusmtip21ef5128fdd0e92e860a902eb43177b8d~pzFB5d6OL3126231262eusmtip26;
 Wed, 27 Apr 2022 16:03:04 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:47 +0200
Message-Id: <20220427160255.300418-9-p.raghav@samsung.com>
In-Reply-To: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0xbZRzNd+/t7aWx7K7F8A3Ehep04AZDTfzcpvEx3I37Y4sYNS4qZbtA
 I3TYgrAxBYSx8dha0DFaqi0vRRgWRiHreDhZgAF2LDxGYWM8Rp3WrO0oOAjIpNwu7r9zft85
 v3N+yUfhIiMZQMnkyaxCLk2QkAKipXvp2vZXZbKYHdYyChn7unFUN6EiUYlrCUf9Zy0YKlaV
 8tGyZQBH7Y4yHrq+mIWhsctmDP1c14WhWaMWR4WXXQT6N//22ixnGkcr0xGouPMGQLYRLYba
 x19Ag3dq+GiwYi9qa+8l0NAlHYn0P9r4SJ27gCOr2gZQUU8TD7mrc/jol7+dBLo6HvhGEDM0
 vI9ZvXqeZIqyHXxm4HYjwQxZUpgLtXkkU555FmeaqjKYVoMbY1rHMknmdLaDZMwnJnmMs2OE
 ZM6YagFjNI0QjLqpkXdA9LFg92E2QfYlqwh/PVoQX5Bv4CWZNqSNn2jiZQL7E/nAh4L0y7Cq
 cZbIBwJKRNcAuNTmwDkyD2CPapXPETeAV+p+IB9ZuusrvZafACzLXcQ48heA+pu2NQtFkXQo
 zMpbd/vRVgCLGhrWRThtx+F10yjmWSWm34OTE2PAYyDoLVDX9pFnLKR3wqy7TpxL2ww1gw/W
 d/rQu6B6zivZCHs1nt4+ays3w+zmsvXakK4WwKK+YW/TPbD0j28JDouhvcfE5/BT8KFZj3E4
 Hdqsy15zDoAqs5H0hMG1sDO/J3ggTodA46VwTv4mrNQXAE7hC633NnIVfGFxyzmcGwvhqVwR
 p5ZA89KsNxTCoW903jIMLLbOAzUI1j52jPaxY7T/5xoAXgv82RRlYhyrjJCzqWFKaaIyRR4X
 duhI4gWw9qf7V3vmLoLv7ffDOgFGgU4AKVziJ5xvjY8RCQ9Ljx5jFUc+U6QksMpOEEgREn/h
 IVmDVETHSZPZz1k2iVU8esUon4BM7JS48mv01UJFfd9BccVc6zWNZk+Qz0zH7NsLB90nFU/7
 jx7f71gEYuVrhegT4jlyy9FnBjLuB0X6js5pot4NiS8djq7fMBBmz/jQyvTz/omtLh+1jIHT
 +yMr7jiadz5b7zIV3x3ZWvWFurXr/aTaiKkdLvd557YbQ1EvDdtUK8mv6N85FrL1txeXHyhT
 B7ZTneYPQvMyxu5NH8dmfp28We5y1tLiysDUk5NTt9LzR9NmaqymzL3mmNilgpje6mW/wk2W
 ksipqJYr6QErzc8bHnbpahKEBkOaLmX61p+NF5NMu0qC8e/8ztErruBN4W99KpFvC5JF6/Mq
 Yyc0SbuNgic7SiSEMl4aEYorlNL/AHjkNBtCBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t/xe7oWmZlJBleeaFmsP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlmsXH2UyeLJ+lnMFj0HPrBY
 /O26BxRrechs8eehocWkQ9cYLZ5encVksfeWtsWlxyvYLS4tcrfYs/cki8XlXXPYLOYve8pu
 MaHtK7PFjQlPGS0mHt/MavF5aQu7xbrX71ksTtySdpD1uHzF2+PfiTVsHhOb37F7nL+3kcXj
 8tlSj02rOtk8FjZMZfbYvKTeY/eCz0weu282sHn0Nr9j89jZep/V4/2+q2wefVtWMXqs33KV
 xWPC5o2sAUJRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF
 +nYJehndXQtYC7bwV9xq3czawPiKp4uRk0NCwETi2NrFLF2MXBxCAksZJd6dbGWDSEhI3F7Y
 xAhhC0v8udbFBlH0nFHiyf01QA4HB5uAlkRjJztIXETgCaPE/Z+PwSYxCzSwSNyauIsJpFtY
 IEBiZUsXK0gDi4CqxJw9ESBhXgEricbn75khFshLzLz0nR2khFPAWmLCJ7ASIaCS7kW3WCHK
 BSVOznzCAmIzA5U3b53NPIFRYBaS1CwkqQWMTKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzEC
 E8q2Yz8372Cc9+qj3iFGJg7GQ4wSHMxKIrxfdmckCfGmJFZWpRblxxeV5qQWH2I0Bbp6IrOU
 aHI+MKXllcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJpCeWpGanphakFsH0MXFwSjUwbXh0sFYx
 ffez0B6x6u98avHVshcbxYx9PuuKqC2oyAzgu+CwtoUpebr1lrPqWgqLljxszKicc6BGQ13I
 6evUJ+ebNSwcVrf4uN4X2H9p0b79p9z1jxvH3u/mepvZFyL1epHRTbW0Za4/4t5/vhSaYfbe
 Nv/OIaHcQy/5yxZ8X/bHpEG2/YBd47UCT6FTu35+ccguYrMy7AvSi0xYfvGwTtrMxss3rzr+
 fb/IzDvo9PeqkBVWQo8tRKNua6l/rP7w3DF31qFTMVd5171Zv+Y374rm8BKVtJ2Xjq9u9Yj8
 yrfkL4+Dq8uUw98/2STONzv8qsZ57wfTRxHFkjMF416p3f6VVTG7S19jdfC2JWpySizFGYmG
 WsxFxYkABPmx3bEDAAA=
X-CMS-MailID: 20220427160304eucas1p1a0080df82f76c39882c4298c3c3d99fd
X-Msg-Generator: CA
X-RootMTR: 20220427160304eucas1p1a0080df82f76c39882c4298c3c3d99fd
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160304eucas1p1a0080df82f76c39882c4298c3c3d99fd
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160304eucas1p1a0080df82f76c39882c4298c3c3d99fd@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 08/16] btrfs: zoned: add generic btrfs helpers
 for zoned devices
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add helpers to calculate alignment, round up and round down
for zoned devices. These helpers encapsulates the necessary handling for
power_of_2 and non-power_of_2 zone sizes. Optimized calculations are
performed for zone sizes that are power_of_2 with log and shifts.

btrfs_zoned_is_aligned() is added instead of reusing bdev_zone_aligned()
helper is due to some use cases in btrfs where zone alignment is checked
before having access to the underlying block device such as in this
function: btrfs_load_block_group_zone_info().

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/btrfs/zoned.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 49317524e9a6..b9c435961361 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -9,6 +9,7 @@
 #include "disk-io.h"
 #include "block-group.h"
 #include "btrfs_inode.h"
+#include "misc.h"
 
 /*
  * Block groups with more than this value (percents) of unusable space will be
@@ -34,6 +35,33 @@ struct btrfs_zoned_device_info {
 	u32 sb_zone_location[BTRFS_SUPER_MIRROR_MAX];
 };
 
+static inline bool btrfs_zoned_is_aligned(u64 pos, u64 zone_size)
+{
+	u64 remainder = 0;
+
+	if (is_power_of_two_u64(zone_size))
+		return IS_ALIGNED(pos, zone_size);
+
+	div64_u64_rem(pos, zone_size, &remainder);
+	return remainder == 0;
+}
+
+static inline u64 btrfs_zoned_roundup(u64 pos, u64 zone_size)
+{
+	if (is_power_of_two_u64(zone_size))
+		return ALIGN(pos, zone_size);
+
+	return roundup(pos, zone_size);
+}
+
+static inline u64 btrfs_zoned_rounddown(u64 pos, u64 zone_size)
+{
+	if (is_power_of_two_u64(zone_size))
+		return round_down(pos, zone_size);
+
+	return rounddown(pos, zone_size);
+}
+
 #ifdef CONFIG_BLK_DEV_ZONED
 int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 		       struct blk_zone *zone);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

