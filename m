Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A49CC43217
	for <dm-devel@archiver.kernel.org>; Fri,  6 May 2022 08:11:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-w9Q4ILXWMFKOEv5rwMrc1w-1; Fri, 06 May 2022 04:11:21 -0400
X-MC-Unique: w9Q4ILXWMFKOEv5rwMrc1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6D613C01C00;
	Fri,  6 May 2022 08:11:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95638C27E8E;
	Fri,  6 May 2022 08:11:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 49BDD1947057;
	Fri,  6 May 2022 08:11:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 969601947056
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 May 2022 08:11:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 774615D4CE7; Fri,  6 May 2022 08:11:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 72EC15D4CE5
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BF681D3236E
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:16 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-lutt3vWdMEWCdO9RDCbI5Q-1; Fri, 06 May 2022 04:11:14 -0400
X-MC-Unique: lutt3vWdMEWCdO9RDCbI5Q-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220506081113euoutp025d0adb7b1e11a62c5d9c06dbeb47480d~sdcoArLlk2349823498euoutp02x
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220506081113euoutp025d0adb7b1e11a62c5d9c06dbeb47480d~sdcoArLlk2349823498euoutp02x
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220506081112eucas1p1ccb815812e215df7e24c0a5b2fcb0ef2~sdcmW62-Z2880428804eucas1p1w;
 Fri,  6 May 2022 08:11:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id D7.3C.10260.F18D4726; Fri,  6
 May 2022 09:11:11 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220506081111eucas1p11e4dd5a89ce49939bbea57433cea046f~sdcl8BE8U1786517865eucas1p1-;
 Fri,  6 May 2022 08:11:11 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220506081111eusmtrp23682ed30504d4143db35d09c66da86b3~sdcl60V3e2793127931eusmtrp2I;
 Fri,  6 May 2022 08:11:11 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-dd-6274d81f318e
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id A4.F2.09522.F18D4726; Fri,  6
 May 2022 09:11:11 +0100 (BST)
Received: from localhost (unknown [106.210.248.174]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220506081111eusmtip1db96962bcd6db0befbdd9570f5dd4da6~sdcllH23g2776127761eusmtip1Q;
 Fri,  6 May 2022 08:11:11 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, hare@suse.de, dsterba@suse.com, axboe@kernel.dk,
 hch@lst.de, damien.lemoal@opensource.wdc.com, snitzer@kernel.org
Date: Fri,  6 May 2022 10:10:59 +0200
Message-Id: <20220506081105.29134-6-p.raghav@samsung.com>
In-Reply-To: <20220506081105.29134-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH99x7e1u6lV1aSZ+gjlgz3NikYy7xUZdlGD/cDLZgFj4MCK7A
 FdhKwZbOF5ZJoTrlnS4yKIjiUF5a6aQoFighdVAUGYQXV9kKEmhEDMVN2CywMsvFzG+/c57/
 /5z/SR4eLmwmg3hpiixGqZDJJSSfuNHrGdwZ7MhKfO+Bdg8y3enF0VpnL4kMzhISlT/x4EhX
 UsFFKwODOLK6qzho6JkGQ/e7LRjqvKTDUKOhB0MzJj2OCrufEKhRO4Wj1alwNLU4TiCd7R5A
 rjE9hqzj76Dh6QYu6rTeJtBIezWJLlxxcVHp6SUcOUpdAJXZzRz09LKWi5ofLxCob3zzx1vp
 kdFI2ttnJOmyPDeXHpy4RtAjA2q6peksSdfmnMNpc91JuuN+DkkX5blJ2nJqkkMvdI2RdHFr
 E6BNrWMEbe7PpkvN1zjRwlj+h8mMPO0bRin96Et+6rOJQSKzW3zM5M4nc8BPonzgx4PUB9BQ
 YiDzAZ8npBoAnDqVy2GLRQCHrhThbPEUQK33IfeFZdptwHwspOoBXBjazYoeATi/WgjyAY9H
 UqFQc5br62+iCgAsmfx+3YxTZg4cunrYxyIqAY7+bSd8TFBvwpWiCeBjAbUH/tbq5LDLgmHl
 8D/rXj9qL8z94RHJagLg7coZgp0ZDPOuV60nhVQjH2or8ji+EJA6AJtao9k5Ijhnb904YAtc
 s1zAWM6GLsfKhlf7PKjFRLLefbD4rtyHOPU2NLVLWXkEnKvvAKzCHzrmA9gE/lB340ecbQvg
 mdNCVi2BFs/MxlIIR3KrCZZp+LhlCSsF2/Qv3aJ/6Rb9/3svArwJiBm1Kj2FUe1SMEfDVLJ0
 lVqREpaUkd4Cnn/pfq996SZomPszzAYwHrAByMMlmwQifVaiUJAsO36CUWYcUqrljMoGNvMI
 iViQlPazTEilyLKYrxkmk1G+eMV4fkE52JGuOyHLywk7CseSP409aJQaRKtxDbeC/4h8V+ya
 HE0sr4mxfVEp3+dpyO5Ij7NXnJzXBX4yPbsWav624nhNW++awjAaeSumnqpN3fp6VJTxSJRD
 D2J7RCfiFYct+0N+n/38/XDbq0n9O5bf8upjvqu8aS2oE6OAxdyjZSHOr0BP4ytvxKmli/cu
 GV8LTT4W/2BvfGx0RjXM3bZwtVnzr/F8ZvtFXWBgfaY1qE+95UDE7K+a5eHzzv0W2oUPbvco
 yrCD5vjyy8V/FUS0BTsfKrePtR0id0mU2YJar7m3/66+pzw9p22nJiWh7pcBf8K1uOaFzR2x
 NVJN1e7Pzp253kVLCFWqLDwUV6pk/wFAJRJ9QQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t/xu7ryN0qSDJ7tlLVYf+oYs8X/PcfY
 LFbf7WezmPbhJ7PFpP4Z7Ba/z55nttj7bjarxYUfjUwWNw/sZLLYs2gSk8XK1UeZLJ6sn8Vs
 0XPgA4vFypaHzBZ/HhpaPPxyi8Vi0qFrjBZPr85isth7S9vi0uMV7BZ79p5ksbi8aw6bxfxl
 T9ktJrR9Zba4MeEpo8XE45tZLT4vbWG3WPf6PYvFiVvSDrIel694e/w7sYbNY2LzO3aP8/c2
 snhcPlvqsWlVJ5vHwoapzB6bl9R77L7ZwObR2/yOzWNn631Wj/f7rrJ59G1ZxeixfstVFo/N
 p6s9JmzeyBogFKVnU5RfWpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9nk5Kak1mW
 WqRvl6CX8ePeeZaCA+IV6991sTUwLhbuYuTkkBAwkXj8bjUTiC0ksJRR4sjnWIi4hMTthU2M
 ELawxJ9rXWwQNc8ZJTZs5u1i5OBgE9CSaOxk72Lk4hARmMoocWndSRYQh1ngNKvE1k0HmECK
 hAViJDYdZwXpZRFQlfjdew9sJq+ApcT1LXdZIebLS8y89J0dxOYUsJJomvwSapelxPwle1gh
 6gUlTs58wgJiMwPVN2+dzTyBUWAWktQsJKkFjEyrGEVSS4tz03OLDfWKE3OLS/PS9ZLzczcx
 AtPJtmM/N+9gnPfqo94hRiYOxkOMEhzMSiK8wrNKkoR4UxIrq1KL8uOLSnNSiw8xmgLdPZFZ
 SjQ5H5jQ8kriDc0MTA1NzCwNTC3NjJXEeT0LOhKFBNITS1KzU1MLUotg+pg4OKUamJrPzjrD
 FFT/8+gU9aIZ6txHRGM2zHqwhm1HxBTeSy0GZ2ekV/pobNBeIvSRRVS/KHjvgW0qnD+m/PGd
 ++v+qcwQIfcuEd9ID85ZGnbiu+YoLmyKdvs6eW1znN1juX/X5xY0FIiKL95dKa24Um9q+K7f
 qnurmE8/OyZaaK+xnU3+08HX3UK2U28qrV++zWVaywq9QrGtrzp85zvcee+w4quzz997NtEp
 evsWhT+R22g38W2tteWqG6Jrn6UIK94xn8v1n/tDclpf67JpO8sDi3Zu/Pj6za/np3c2uzu6
 KvxsznKdHLBFcRkvp6vV3J0Lnzztvqzz8dehv9ob/c0zw7P22lw6xjbjZnGkcqmdv4sSS3FG
 oqEWc1FxIgCrcDo1sAMAAA==
X-CMS-MailID: 20220506081111eucas1p11e4dd5a89ce49939bbea57433cea046f
X-Msg-Generator: CA
X-RootMTR: 20220506081111eucas1p11e4dd5a89ce49939bbea57433cea046f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220506081111eucas1p11e4dd5a89ce49939bbea57433cea046f
References: <20220506081105.29134-1-p.raghav@samsung.com>
 <CGME20220506081111eucas1p11e4dd5a89ce49939bbea57433cea046f@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v3 05/11] btrfs: zoned: Cache superblock location
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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

