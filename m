Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F84AC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 16:54:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-MPJt--bwN3SuJVGlw0QdQg-1; Mon, 16 May 2022 12:54:39 -0400
X-MC-Unique: MPJt--bwN3SuJVGlw0QdQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 588CC803D47;
	Mon, 16 May 2022 16:54:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47AAF400E114;
	Mon, 16 May 2022 16:54:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 26E161947054;
	Mon, 16 May 2022 16:54:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6DAE4194704E
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 16:54:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5FD05400E114; Mon, 16 May 2022 16:54:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A39C40D1B9A
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E51F3C0D18B
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:36 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-mVKCf7UyPoaDK89KatcddQ-1; Mon, 16 May 2022 12:54:34 -0400
X-MC-Unique: mVKCf7UyPoaDK89KatcddQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220516165433euoutp01eaa1b7bf35847e2f59fa7869781db64b~vpCZmOmQO2835728357euoutp01Q
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220516165433euoutp01eaa1b7bf35847e2f59fa7869781db64b~vpCZmOmQO2835728357euoutp01Q
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220516165431eucas1p2517dac253453b1c09e2970df07cb1f97~vpCX9VyfF2458324583eucas1p2f;
 Mon, 16 May 2022 16:54:31 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id A1.4A.09887.7C182826; Mon, 16
 May 2022 17:54:31 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220516165430eucas1p214cca8eaba1db2c98d947444cad4f18f~vpCXitI0O1887918879eucas1p2m;
 Mon, 16 May 2022 16:54:30 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220516165430eusmtrp168eccddedb796e98be32574b8f4eaee0~vpCXh9pjv2961829618eusmtrp1P;
 Mon, 16 May 2022 16:54:30 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-40-628281c75ba4
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 01.99.09522.6C182826; Mon, 16
 May 2022 17:54:30 +0100 (BST)
Received: from localhost (unknown [106.210.248.7]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220516165430eusmtip1d0239fefcd561e73f10f2837d4e5e5f2~vpCXRAz320975309753eusmtip1e;
 Mon, 16 May 2022 16:54:30 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, pankydev8@gmail.com,
 dsterba@suse.com, hch@lst.de
Date: Mon, 16 May 2022 18:54:12 +0200
Message-Id: <20220516165416.171196-10-p.raghav@samsung.com>
In-Reply-To: <20220516165416.171196-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsWy7djPc7rHG5uSDGZf4bNYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBYrVx9lsug58IHFYu8tbYtLj1ewW+zZe5LF4vKuOWwW85c9Zbe4
 MeEpo8XnpS3sFmtuPmVx4Pf4d2INm8fOWXfZPS6fLfXYtKqTzWPzknqP3TcbgMKt91k93u+7
 yubRt2UVo8f6LVdZPD5vkgvgjuKySUnNySxLLdK3S+DKuLPnInvBY4GKC32/WBoY7/J2MXJy
 SAiYSNw4v4a5i5GLQ0hgBaNEw7zfjBDOF0aJuQ/fQDmfGSV2LbzGDtOyb+0edojEckaJv/9X
 sUA4zxkl3i45BNTCwcEmoCXR2AnWICKQJTHtxEOwScwCi5kkVu6ZzAKSEBaIkpg1s58ZxGYR
 UJWYdXknG4jNK2Atcb73KBPENnmJmZe+s4PM5ASKr+7ihigRlDg58wnYGGagkuats8F+kBCY
 zynx49QSNoheF4mDxw6wQtjCEq+Ob4H6QEbi9OQeFgi7WuLpjd9QzS2MEv0717OBLJMAWtZ3
 JgfEZBbQlFi/Sx+i3FGiZ8t7VogKPokbbwUhTuCTmLRtOjNEmFeio00IolpJYufPJ1BLJSQu
 N82BWuohsfDUP+YJjIqzkDwzC8kzsxD2LmBkXsUonlpanJueWmyUl1quV5yYW1yal66XnJ+7
 iRGY7k7/O/5lB+PyVx/1DjEycTAeYpTgYFYS4TWoaEgS4k1JrKxKLcqPLyrNSS0+xCjNwaIk
 zpucuSFRSCA9sSQ1OzW1ILUIJsvEwSnVwNSwdW2MVKS27+HevLDZRqslEn9HXo+eaDLtxZ3l
 uQ+WzClesv7Zv0Y2juKmep0r2tmxZYteHtS+Nl9MhZvFL0Ysf8KclQ+dnyxbdo51xYMGFTY7
 iZ29Lkwf1JoqQxKqFrwt3H/+7nfFi8c1Ge4YSccLWr6Tir8ot9FtX82UlKa6bqPwrRvn6L3b
 mP7nzW03mV/z9V1Na5Y/L+zaMiHRJPJIu84V04hOSe6Nake5pv/eelLi/qQ0jz+Szt+iJgr9
 +3+Tx/+VnPiZxTNNljw/71p//4rTX6913qVq4r/edBa5ZT3K5Um15nXTSL379d+VqhrH0zZX
 0hY6urcvzTnRER/2oMIz/eMao2M/a5+kqSqxFGckGmoxFxUnAgDkmIpt5gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t/xu7rHGpuSDE69M7BYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBYrVx9lsug58IHFYu8tbYtLj1ewW+zZe5LF4vKuOWwW85c9Zbe4
 MeEpo8XnpS3sFmtuPmVx4Pf4d2INm8fOWXfZPS6fLfXYtKqTzWPzknqP3TcbgMKt91k93u+7
 yubRt2UVo8f6LVdZPD5vkgvgjtKzKcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV
 0rezSUnNySxLLdK3S9DLuLPnInvBY4GKC32/WBoY7/J2MXJySAiYSOxbu4e9i5GLQ0hgKaPE
 rCk32SASEhK3FzYxQtjCEn+udbFBFD1llGjsnc7axcjBwSagJdHYyQ5SIyJQIDGnfwsLSA2z
 wFomidc/3oM1CwtESEz/OpcZxGYRUJWYdXkn2AJeAWuJ871HmSAWyEvMvPSdHWQmJ1B8dRc3
 SFhIwEri65Nb7BDlghInZz5hAbGZgcqbt85mnsAoMAtJahaS1AJGplWMIqmlxbnpucWGesWJ
 ucWleel6yfm5mxiBkbnt2M/NOxjnvfqod4iRiYPxEKMEB7OSCK9BRUOSEG9KYmVValF+fFFp
 TmrxIUZToLMnMkuJJucDU0NeSbyhmYGpoYmZpYGppZmxkjivZ0FHopBAemJJanZqakFqEUwf
 EwenVAOT+P41L+S6Jhg/7b44pXbOrBwPv7Kunmd856cuaz+X8PhRoVm/pfhTh+s6tS8iXif0
 3yhtC3vkOMdd7KXEN6bYI44XfIuZK1but7x3chffVQ6WwM/pXGtX/SxPWt5fUmguPs3TZfGP
 la+MGHc22c3c1PzT2m59zczwTdsmKEVX6z9meHvwgnDrntpLDRcXCsWaciht2uC4ltvJW7Ze
 YuGcQE1+9v47W79InqucNs9NLtFa0oPj3Psp/9wvBP/k2s6lnrvg+ZmdPxfsWFnp8lv5ho72
 qhCNpwy5s2avDYm/XhjAMY9537urKyQbLNbK6vK+XpDjpuc/XUZj88NJuVbqLHeYr757yrBc
 6SKzsLWbEktxRqKhFnNRcSIACnOWkVUDAAA=
X-CMS-MailID: 20220516165430eucas1p214cca8eaba1db2c98d947444cad4f18f
X-Msg-Generator: CA
X-RootMTR: 20220516165430eucas1p214cca8eaba1db2c98d947444cad4f18f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165430eucas1p214cca8eaba1db2c98d947444cad4f18f
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165430eucas1p214cca8eaba1db2c98d947444cad4f18f@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v4 09/13] btrfs: zoned: relax the alignment
 constraint for zoned devices
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Checks were in place to return error when a non power-of-2 zoned devices
is detected. Remove those checks as non power-of-2 zoned devices are
now supported.

Relax the zone size constraint to align with a sane default of 1MB.
This 1M default has been chosen as the minimum alignment requirement
for zone sizes to make sure zones align with sectorsize in different
architectures.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/btrfs/zoned.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 805aeaa76..4f3687c54 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -54,6 +54,13 @@
  */
 #define BTRFS_MAX_ZONE_SIZE		SZ_8G
 
+/*
+ * A minimum alignment of 1MB is chosen for zoned devices as their zone sizes
+ * can be non power of 2. This is to make sure the zones correctly align to the
+ * sectorsize.
+ */
+#define BTRFS_ZONED_MIN_ALIGN_SECTORS       ((u64)SZ_1M >> SECTOR_SHIFT)
+
 #define SUPER_INFO_SECTORS	((u64)BTRFS_SUPER_INFO_SIZE >> SECTOR_SHIFT)
 
 static inline bool sb_zone_is_full(const struct blk_zone *zone)
@@ -394,8 +401,8 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		zone_sectors = bdev_zone_sectors(bdev);
 	}
 
-	/* Check if it's power of 2 (see is_power_of_2) */
-	ASSERT(zone_sectors != 0 && (zone_sectors & (zone_sectors - 1)) == 0);
+	ASSERT(zone_sectors != 0 &&
+	       IS_ALIGNED(zone_sectors, BTRFS_ZONED_MIN_ALIGN_SECTORS));
 	zone_info->zone_size = zone_sectors << SECTOR_SHIFT;
 
 	/* We reject devices with a zone size larger than 8GB */
@@ -892,9 +899,11 @@ int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
 
 	ASSERT(rw == READ || rw == WRITE);
 
-	if (!is_power_of_2(bdev_zone_sectors(bdev)))
-		return -EINVAL;
 	nr_sectors = bdev_nr_sectors(bdev);
+
+	if (!IS_ALIGNED(nr_sectors, BTRFS_ZONED_MIN_ALIGN_SECTORS))
+		return -EINVAL;
+
 	nr_zones = bdev_zone_no(bdev, nr_sectors);
 
 	sb_zone = sb_zone_number(bdev, mirror);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

