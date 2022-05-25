Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979F1C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 15:51:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-nhU_zET_PjGPxuSE7LUmqg-1; Wed, 25 May 2022 11:51:13 -0400
X-MC-Unique: nhU_zET_PjGPxuSE7LUmqg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 876E9185A79C;
	Wed, 25 May 2022 15:51:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 301B9401199B;
	Wed, 25 May 2022 15:51:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D8769194EB83;
	Wed, 25 May 2022 15:51:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 98555194EB82
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 May 2022 15:50:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 81EA840CFD0A; Wed, 25 May 2022 15:50:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B1B340CF8EF
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 632E31C00130
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:06 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-TBExFKrdN96XooN_CVLzXQ-1; Wed, 25 May 2022 11:50:03 -0400
X-MC-Unique: TBExFKrdN96XooN_CVLzXQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220525155002euoutp01cf649366568a359007678eaa20fa41e0~yY9o5M93d0505805058euoutp01r
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220525155002euoutp01cf649366568a359007678eaa20fa41e0~yY9o5M93d0505805058euoutp01r
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220525155000eucas1p216752d9914ca37a7d223bef39c8fb758~yY9nXTACK0700607006eucas1p2H;
 Wed, 25 May 2022 15:50:00 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id A9.FF.10260.8205E826; Wed, 25
 May 2022 16:50:00 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220525155000eucas1p200ac7e1c844980e728c9e88f51c4590e~yY9m7pDL80700607006eucas1p2G;
 Wed, 25 May 2022 15:50:00 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220525154959eusmtrp232e421c63a06da32f789c1209bc5a763~yY9m62BF90177001770eusmtrp2W;
 Wed, 25 May 2022 15:49:59 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-d0-628e502837bc
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id DC.8E.09404.7205E826; Wed, 25
 May 2022 16:49:59 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220525154959eusmtip1b8cca573c1722645da3df92c140f2a0b~yY9mnZb3k1782817828eusmtip1W;
 Wed, 25 May 2022 15:49:59 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, snitzer@redhat.com,
 Johannes.Thumshirn@wdc.com, hch@lst.de, hare@suse.de
Date: Wed, 25 May 2022 17:49:50 +0200
Message-Id: <20220525154957.393656-2-p.raghav@samsung.com>
In-Reply-To: <20220525154957.393656-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsWy7djP87oaAX1JBhemSlisvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbnFjwlNGi89LW9gt2jZ+ZXQQ8Ph3Yg2bx+WzpR6bVnWyeWxeUu+x+2YDm8fO1vusHu/3
 XWXz6NuyitFj/ZarLB6bT1d7fN4k59F+oJspgCeKyyYlNSezLLVI3y6BK2PaibnsBZNEKl5N
 3sXYwPhQoIuRg0NCwETizJ6MLkYuDiGBFYwSi57sZuxi5ARyvjBK/G1ThUh8ZpRoeTWdFSQB
 0jC59QkzRGI5o0TDil42COcFo0TX7AlMIGPZBLQkGjvZQeIiAo2MElNfnmAEcZgFZjNJzPs2
 GWyHsECiRG/PHTYQm0VAVeLZm7usIM28AlYS+w5LQmyTl5h56Ts7iM0pYC0xf/9nZhCbV0BQ
 4uTMJywgNjNQTfPW2WAXSQis55Q4er+DDaLZRWLpiddQtrDEq+Nb2CFsGYn/O+czQdjVEk9v
 /IZqbmGU6N+5ng0SMNYSfWdyQExmAU2J9bv0IcodJR4//soOUcEnceOtIMQJfBKTtk1nhgjz
 SnS0CUFUK0ns/PkEaqmExOWmOSwQJR4SW29bTGBUnIXkl1lIfpmFsHYBI/MqRvHU0uLc9NRi
 47zUcr3ixNzi0rx0veT83E2MwOR3+t/xrzsYV7z6qHeIkYmD8RCjBAezkgjvhae9SUK8KYmV
 ValF+fFFpTmpxYcYpTlYlMR5kzM3JAoJpCeWpGanphakFsFkmTg4pRqYkm9OKTvtfMh83uqA
 XfP8nF47HhCbJC3U4RZw5MviGLmptnZc7uKBJ9N/5Z41/ykSvmFhi9nT+OjDSRLZLDsEFt1/
 ke/cv3n/08L7ces6JrAdXRp4y6EjTPaTaMNCUw9lj6xLD45sE/5b8nJKlOSF8hNPpilf98s3
 cTgcMyOkPVgkNIt76y+hrIfrHjOdOrVWNb9NmvHnipMBszytPNRNFjfN8zqjINfn9yRcw5tv
 2mGlgCn/1q/iTOtfLr5D+5LCzfu9ggyBpXP4ZJktv6arNk2wkFdYVyOjeG3yiSXHQvpNjdcU
 71nEs/FEokSYwhJOBmalt89Ye5465e868cqZ5/cy9sQL8zqUb364ZjhLiaU4I9FQi7moOBEA
 QhWHGu0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t/xu7rqAX1JBse+WVisvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbnFjwlNGi89LW9gt2jZ+ZXQQ8Ph3Yg2bx+WzpR6bVnWyeWxeUu+x+2YDm8fO1vusHu/3
 XWXz6NuyitFj/ZarLB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/I
 xFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2PaibnsBZNEKl5N3sXYwPhQoIuRk0NCwERicusT
 ZhBbSGApo0TDLy2IuITE7YVNjBC2sMSfa11sXYxcQDXPGCUOzdvF1MXIwcEmoCXR2MkOEhcR
 6GSUmLOvFcxhFljOJPH80yJmkCJhgXiJ9df0QAaxCKhKPHtzlxUkzCtgJbHvsCTEfHmJmZe+
 s4PYnALWEvP3f4a6x0ri652vrCA2r4CgxMmZT1hAbGag+uats5knMArMQpKahSS1gJFpFaNI
 amlxbnpusZFecWJucWleul5yfu4mRmCkbjv2c8sOxpWvPuodYmTiYDzEKMHBrCTCe+Fpb5IQ
 b0piZVVqUX58UWlOavEhRlOgsycyS4km5wNTRV5JvKGZgamhiZmlgamlmbGSOK9nQUeikEB6
 YklqdmpqQWoRTB8TB6dUA1PkhHXz4zKaVu72PXKjsvWD+uuOJKXKq0Z8VmEee9zfvpbiTdKT
 MpIqvyG85oSV4lW163f2z+ee4FHz7dRsnRbeG18DnZZJSm5R4mZ3K5acdUT7qvjyz+ZL4k5f
 Zf2qVMb24bXB7Yum2ryBzec3MD1Y2pN2s+8a44XVl0ymhfLqLJzmudjxdMo51szLq0/3t8xa
 YRTp/Nlgiv65ivc37x1wqZ0rxLyotTIlUDo1yC03XsNRUN9s0orMU3Lzfyq0tVX1r2thvLR6
 WvnUR6XP7jd5fmZ9fWw+5x+b+GsebV8PvChsPrxJ/Xf8Jke76u93K+0/Z4c/n9kePvN/8Zc7
 N/mzTN9EPQy69f/kx0cGYRuUWIozEg21mIuKEwGfZguQXQMAAA==
X-CMS-MailID: 20220525155000eucas1p200ac7e1c844980e728c9e88f51c4590e
X-Msg-Generator: CA
X-RootMTR: 20220525155000eucas1p200ac7e1c844980e728c9e88f51c4590e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220525155000eucas1p200ac7e1c844980e728c9e88f51c4590e
References: <20220525154957.393656-1-p.raghav@samsung.com>
 <CGME20220525155000eucas1p200ac7e1c844980e728c9e88f51c4590e@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v6 1/8] block: make blkdev_nr_zones and
 blk_queue_zone_no generic for npo2 zsze
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Adapt blkdev_nr_zones and blk_queue_zone_no function so that it can
also work for non-power-of-2 zone sizes.

As the existing deployments of zoned devices had power-of-2
assumption, power-of-2 optimized calculation is kept for those devices.

There are no direct hot paths modified and the changes just
introduce one new branch per call.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-zoned.c      | 12 +++++++++---
 include/linux/blkdev.h |  8 +++++++-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 38cd840d8838..8b0615287cd3 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -111,16 +111,22 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
  * blkdev_nr_zones - Get number of zones
  * @disk:	Target gendisk
  *
- * Return the total number of zones of a zoned block device.  For a block
- * device without zone capabilities, the number of zones is always 0.
+ * Return the total number of zones of a zoned block device, including the
+ * eventual small last zone if present. For a block device without zone
+ * capabilities, the number of zones is always 0.
  */
 unsigned int blkdev_nr_zones(struct gendisk *disk)
 {
 	sector_t zone_sectors = blk_queue_zone_sectors(disk->queue);
+	sector_t capacity = get_capacity(disk);
 
 	if (!blk_queue_is_zoned(disk->queue))
 		return 0;
-	return (get_capacity(disk) + zone_sectors - 1) >> ilog2(zone_sectors);
+
+	if (is_power_of_2(zone_sectors))
+		return (capacity + zone_sectors - 1) >> ilog2(zone_sectors);
+
+	return DIV_ROUND_UP_SECTOR_T(capacity, zone_sectors);
 }
 EXPORT_SYMBOL_GPL(blkdev_nr_zones);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 60d016138997..c4e4c7071b7b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -665,9 +665,15 @@ static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
 static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 					     sector_t sector)
 {
+	sector_t zone_sectors = blk_queue_zone_sectors(q);
+
 	if (!blk_queue_is_zoned(q))
 		return 0;
-	return sector >> ilog2(q->limits.chunk_sectors);
+
+	if (is_power_of_2(zone_sectors))
+		return sector >> ilog2(zone_sectors);
+
+	return div64_u64(sector, zone_sectors);
 }
 
 static inline bool blk_queue_zone_is_seq(struct request_queue *q,
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

