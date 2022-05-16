Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B984C4321E
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 16:54:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-qdY9fEoLOrGMYSXNUBg4cQ-1; Mon, 16 May 2022 12:54:35 -0400
X-MC-Unique: qdY9fEoLOrGMYSXNUBg4cQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06EC986B8AE;
	Mon, 16 May 2022 16:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E61FC2166B25;
	Mon, 16 May 2022 16:54:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A7AF41947071;
	Mon, 16 May 2022 16:54:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E1194194704E
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 16:54:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C458340147D; Mon, 16 May 2022 16:54:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BFE87401E87
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8201101A52C
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:31 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-OiI2m-i2NkGqLqeSomEeFw-1; Mon, 16 May 2022 12:54:28 -0400
X-MC-Unique: OiI2m-i2NkGqLqeSomEeFw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220516165427euoutp01cb16ada0cdd6a3816e00b9459ff199dc~vpCUkR4HN2835728357euoutp01M
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220516165427euoutp01cb16ada0cdd6a3816e00b9459ff199dc~vpCUkR4HN2835728357euoutp01M
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220516165426eucas1p22e48539c1842dfe465d51988e5d8d7c3~vpCTS2WST2458324583eucas1p2b;
 Mon, 16 May 2022 16:54:26 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 1F.3A.09887.2C182826; Mon, 16
 May 2022 17:54:26 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220516165425eucas1p29fcd11d7051d9d3a9a9efc17cd3b6999~vpCSuPtbz2457724577eucas1p2W;
 Mon, 16 May 2022 16:54:25 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220516165425eusmtrp1a1b2c812009ed084ac50bf44b3ff450d~vpCSrm8wt2961829618eusmtrp1J;
 Mon, 16 May 2022 16:54:25 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-35-628281c24bd2
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 3D.89.09522.1C182826; Mon, 16
 May 2022 17:54:25 +0100 (BST)
Received: from localhost (unknown [106.210.248.7]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220516165425eusmtip23750993d6d829aa7eb563f0768582ffe~vpCSVIM863184631846eusmtip2C;
 Mon, 16 May 2022 16:54:25 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, pankydev8@gmail.com,
 dsterba@suse.com, hch@lst.de
Date: Mon, 16 May 2022 18:54:08 +0200
Message-Id: <20220516165416.171196-6-p.raghav@samsung.com>
In-Reply-To: <20220516165416.171196-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7djP87qHGpuSDKZu5LNYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBYrVx9lsug58IHFYu8tbYtLj1ewW+zZe5LF4vKuOWwW85c9Zbe4
 MeEpo8XnpS3sFmtuPmVx4Pf4d2INm8fOWXfZPS6fLfXYtKqTzWPzknqP3TcbgMKt91k93u+7
 yubRt2UVo8f6LVdZPD5vkgvgjuKySUnNySxLLdK3S+DK+HHvPEvBAfGK9e+62BoYFwt3MXJy
 SAiYSFz+uIyxi5GLQ0hgBaPEzUNbGUESQgJfGCVan5dDJD4zShyYMIURpqNrWyMTRGI5o8Tj
 rm8sEM5zRol35/uAMhwcbAJaEo2d7CANIgJZEtNOPARbwSywmEli5Z7JLCA1wgJxEpd7PEBq
 WARUJW5u62cDsXkFrCSuXm+DWiYvMfPSd3aQck4Ba4nVXdwQJYISJ2c+YQGxmYFKmrfOZgYZ
 LyEwm1Pi6dqNYPUSAi4SH797Q4wRlnh1fAs7hC0jcXpyDwuEXS3x9MZvqN4WRon+nevZIHqt
 JfrO5ICYzAKaEut36UOUO0o09X2AquCTuPFWEOICPolJ26YzQ4R5JTrahCCqlSR2/nwCtVRC
 4nLTHKilHhLPbi5gm8CoOAvJL7OQ/DILYe8CRuZVjOKppcW56anFRnmp5XrFibnFpXnpesn5
 uZsYgYnu9L/jX3YwLn/1Ue8QIxMH4yFGCQ5mJRFeg4qGJCHelMTKqtSi/Pii0pzU4kOM0hws
 SuK8yZkbEoUE0hNLUrNTUwtSi2CyTBycUg1MPfNv3fbcs7447qZBgXTHRu/9u7+6HxDN19R6
 XH5ZZe7Ldp+9mUKqW/1jPu1oytsovF4/svvuXgXz38vyt6xtZdx7I6ahSnKdSFOMw/qNOtvC
 vX038X2+sXLrgZqLdxv+C1aoCDk2bhC7F6UobGXZtUfP4and5Ovhmnvb9X+tnv/yo1fnYqvg
 6CKuIh+WzVanWI9qupik32M7ffnGHZOvN7Z9KeE5EvDvjPim8L31kQrKqtt0HZ0U3yR5HP2Z
 pByz+5ZE6wbrkzt9Phc+5w+SO8C37vOqUOP3Df535f7zKS7c8tFF8bOoR/ma1pRUsbA7+7PM
 Zp/v236R7YDd7achv/SrXwoJ/7W2MJ2x86mWEktxRqKhFnNRcSIAfHa3XOMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t/xe7oHG5uSDA5NUbJYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBYrVx9lsug58IHFYu8tbYtLj1ewW+zZe5LF4vKuOWwW85c9Zbe4
 MeEpo8XnpS3sFmtuPmVx4Pf4d2INm8fOWXfZPS6fLfXYtKqTzWPzknqP3TcbgMKt91k93u+7
 yubRt2UVo8f6LVdZPD5vkgvgjtKzKcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV
 0rezSUnNySxLLdK3S9DL+HHvPEvBAfGK9e+62BoYFwt3MXJySAiYSHRta2TqYuTiEBJYyihx
 dvFZJoiEhMTthU2MELawxJ9rXWwQRU8ZJZZtOABUxMHBJqAl0djJDlIjIlAgMad/CwtIDbPA
 WiaJ1z/egzULC8RI3P5wiQXEZhFQlbi5rZ8NxOYVsJK4er0NaoG8xMxL39lBZnIKWEus7uIG
 CQsBlXx9cosdolxQ4uTMJ2BjmIHKm7fOZp7AKDALSWoWktQCRqZVjCKppcW56bnFhnrFibnF
 pXnpesn5uZsYgZG57djPzTsY5736qHeIkYmD8RCjBAezkgivQUVDkhBvSmJlVWpRfnxRaU5q
 8SFGU6CzJzJLiSbnA1NDXkm8oZmBqaGJmaWBqaWZsZI4r2dBR6KQQHpiSWp2ampBahFMHxMH
 p1QDE4dS2nTrJXalG46+jG/5FDyhZlJP/rS/s55ZMvlZSHItkd/Pwyz+/+TOvQVG092vrtjs
 P1Vf8cktuymbeXoK01bZpR/ZMNFpaoqvhVzA4yNxXwJZORd5hN4/8dd1tU/kpmhdvgomz+9b
 eMsmZW+Rfsm/w2+J9eFnotm+HyTt2ZXefSlm61I53P/hXoLggmXJ1/8ft5HXuXqYa+KeWkM1
 jsIN/amxpTbF4a/VjjW6TH/zWvFOyoLVnH99DguzxjyZrHjz3ZFtHkc3XH/49MWUtsIJy+18
 ua85vC6N7ZzE8niu4vfwi/M/L5LObVnext2ubGvAdVmbxZvx3NnmbLn51YptvLNvdtmobi7c
 1VZUosRSnJFoqMVcVJwIADq56hhVAwAA
X-CMS-MailID: 20220516165425eucas1p29fcd11d7051d9d3a9a9efc17cd3b6999
X-Msg-Generator: CA
X-RootMTR: 20220516165425eucas1p29fcd11d7051d9d3a9a9efc17cd3b6999
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165425eucas1p29fcd11d7051d9d3a9a9efc17cd3b6999
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165425eucas1p29fcd11d7051d9d3a9a9efc17cd3b6999@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v4 05/13] btrfs: zoned: Cache superblock location
 in btrfs_zoned_device_info
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
index 06f22c021..e8c7cebb2 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -511,6 +511,11 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
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
@@ -518,7 +523,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		u64 sb_wp;
 		int sb_pos = BTRFS_NR_SB_LOG_ZONES * i;
 
-		sb_zone = sb_zone_number(zone_info->zone_size_shift, i);
+		sb_zone = zone_info->sb_zone_location[i];
 		if (sb_zone + 1 >= zone_info->nr_zones)
 			continue;
 
@@ -866,7 +871,7 @@ int btrfs_sb_log_location(struct btrfs_device *device, int mirror, int rw,
 		return 0;
 	}
 
-	zone_num = sb_zone_number(zinfo->zone_size_shift, mirror);
+	zone_num = zinfo->sb_zone_location[mirror];
 	if (zone_num + 1 >= zinfo->nr_zones)
 		return -ENOENT;
 
@@ -883,7 +888,7 @@ static inline bool is_sb_log_zone(struct btrfs_zoned_device_info *zinfo,
 	if (!zinfo)
 		return false;
 
-	zone_num = sb_zone_number(zinfo->zone_size_shift, mirror);
+	zone_num = zinfo->sb_zone_location[mirror];
 	if (zone_num + 1 >= zinfo->nr_zones)
 		return false;
 
@@ -1011,7 +1016,7 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 			u32 sb_zone;
 			u64 sb_pos;
 
-			sb_zone = sb_zone_number(shift, i);
+			sb_zone = zinfo->sb_zone_location[i];
 			if (!(end <= sb_zone ||
 			      sb_zone + BTRFS_NR_SB_LOG_ZONES <= begin)) {
 				have_sb = true;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 10f31d1c8..694ab6d1e 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -27,6 +27,7 @@ struct btrfs_zoned_device_info {
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

