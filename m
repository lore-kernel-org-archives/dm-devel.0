Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 290BDC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 15:51:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-Drcqu74UNeq-39VVNmbNFA-1; Wed, 25 May 2022 11:51:38 -0400
X-MC-Unique: Drcqu74UNeq-39VVNmbNFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D1301C0CE66;
	Wed, 25 May 2022 15:51:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2AFF740CFD0A;
	Wed, 25 May 2022 15:51:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D2609194EB83;
	Wed, 25 May 2022 15:51:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 597EB194EB82
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 May 2022 15:50:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4900040E6A57; Wed, 25 May 2022 15:50:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 43E7140CFD0B
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DF011857F08
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:13 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-TlvUfPEUPh-kN6mUiKYzng-1; Wed, 25 May 2022 11:50:11 -0400
X-MC-Unique: TlvUfPEUPh-kN6mUiKYzng-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220525155009euoutp01eb0e680b68f91d054b283c03a9faee96~yY9wI7Sku0835508355euoutp01I
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220525155009euoutp01eb0e680b68f91d054b283c03a9faee96~yY9wI7Sku0835508355euoutp01I
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220525155008eucas1p21392109a809e41d5bb99c4abd0256de8~yY9uxB_mn0700707007eucas1p2J;
 Wed, 25 May 2022 15:50:08 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id EF.FF.10260.0305E826; Wed, 25
 May 2022 16:50:08 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220525155007eucas1p1b7fc82f9e42be028e8f00109d55e6a62~yY9uK4vp20770307703eucas1p1D;
 Wed, 25 May 2022 15:50:07 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220525155007eusmtrp18bb3a95ccc378c2b11588ec51e84a10d~yY9uKGJTE1510315103eusmtrp1K;
 Wed, 25 May 2022 15:50:07 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-e4-628e503011b6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id AF.17.09522.F205E826; Wed, 25
 May 2022 16:50:07 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220525155007eusmtip1f0d8c7ef887e2d198cd3b081ecc69235~yY9t1swVE1835018350eusmtip1F;
 Wed, 25 May 2022 15:50:07 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, snitzer@redhat.com,
 Johannes.Thumshirn@wdc.com, hch@lst.de, hare@suse.de
Date: Wed, 25 May 2022 17:49:56 +0200
Message-Id: <20220525154957.393656-8-p.raghav@samsung.com>
In-Reply-To: <20220525154957.393656-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7djPc7oGAX1JBk92C1qsvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbnFjwlNGi89LW9gt2jZ+ZXQQ8Ph3Yg2bx+WzpR6bVnWyeWxeUu+x+2YDm8fO1vusHu/3
 XWXz6NuyitFj/ZarLB6bT1d7fN4k59F+oJspgCeKyyYlNSezLLVI3y6BK2NJ1wuWgkeCFVfe
 r2JqYDzO18XIySEhYCKxY+k0ti5GLg4hgRWMEs+v74JyvjBK7Pq3iAnC+cwocXHia6AMB1jL
 /Y28EPHljBKLX+5ghXBeMEqs6gTp4OBgE9CSaOxkB4mLCDQySkx9eYIRxGEWmM0ksXfWXEaQ
 5cICgRJ3zq1iBbFZBFQlzqx8zAZi8wpYSdxfsIUR4kB5iZmXvrOD2JwC1hLz939mhqgRlDg5
 8wkLiM0MVNO8dTYzyAIJgfWcEk9mrIRqdpGYuH46M4QtLPHq+BZ2CFtG4vTkHhYIu1ri6Y3f
 UM0tjBL9O9dD/Wkt0XcmB8RkFtCUWL9LH6LcUeL/4V+MEBV8EjfeCkKcwCcxaRvIJpAwr0RH
 mxBEtZLEzp9PoJZKSFxumgO11EPi7aJPrBMYFWcheWYWkmdmIexdwMi8ilE8tbQ4Nz212Dgv
 tVyvODG3uDQvXS85P3cTIzAFnv53/OsOxhWvPuodYmTiYDzEKMHBrCTCe+Fpb5IQb0piZVVq
 UX58UWlOavEhRmkOFiVx3uTMDYlCAumJJanZqakFqUUwWSYOTqkGpmTbzsULTs6Xe//zsDCb
 WXZLpVZbhd4OoUxnE28VZzuLW3tuCD2M9j9b+bPrdcgnj0DfbLtN3ftE+RlcG4MnrdyjaHzf
 aMuRi2Inf+2beDd0q8R3oz+KzSJsk2M3Z/1grpZu9WNNqI/O+3Zgini30JnpLw3cNee/y90w
 bf02Xh2NNyev3644Okk4TWzJxDaFoBMzj8jG/XHxtoiTmyC8/kb23tKVTVoLfi7yuuu46dj+
 z7s60z5leq9eJZWvzRq5X63IyPbFJfZb/S8KH2bY2x7pb7pWHLH+Yu4Jw51f8jXkK1xy/h0+
 9ObWynreGzO5g27tcFrW/GdnscpRPwbrl/0V9Zzu4Qel1reypr88oMRSnJFoqMVcVJwIAIn8
 33HwAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t/xu7r6AX1JBovmalmsvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbnFjwlNGi89LW9gt2jZ+ZXQQ8Ph3Yg2bx+WzpR6bVnWyeWxeUu+x+2YDm8fO1vusHu/3
 XWXz6NuyitFj/ZarLB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/I
 xFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2NJ1wuWgkeCFVfer2JqYDzO18XIwSEhYCJxfyNv
 FyMnh5DAUkaJtrUiILaEgITE7YVNjBC2sMSfa11sXYxcQDXPGCW6l/9kB+llE9CSaOxkB4mL
 CHQySszZ1wrmMAssZ5LYfLKPGaRbWMBfouXMMSYQm0VAVeLMysdsIDavgJXE/QVboDbIS8y8
 9J0dxOYUsJaYv/8zM8RFVhJf73xlhagXlDg58wkLiM0MVN+8dTbzBEaBWUhSs5CkFjAyrWIU
 SS0tzk3PLTbUK07MLS7NS9dLzs/dxAiM1W3Hfm7ewTjv1Ue9Q4xMHIyHGCU4mJVEeC887U0S
 4k1JrKxKLcqPLyrNSS0+xGgKdPdEZinR5HxgssgriTc0MzA1NDGzNDC1NDNWEuf1LOhIFBJI
 TyxJzU5NLUgtgulj4uCUamDSKX5zfkJJl16syLXyyb5/dPxP9WltURf8sFly00HtcE/huJbe
 +p/1j1fVuOs8k3WafuvG7TuGXxUs79W8vOuoGrqVifenyTqNRwu7btx8Xh3ja/h5dkpDSu2T
 2xkhFcH/rN8xbds98+J0M+n8zGsnDQXD48L8+f/N6bnQ9VTx1t6VYqU1Hak/M/W53vB1/knf
 sfSlWNOz6OM9BySlegOf3/Ge8Dv5e3XRzvz8V5VS99/fC/ZbnPP7G69a1oeUVJ9+xhVi/ZVq
 iudvPGN59DQitSioIVqy/WTo9/71GiGvNdoy4jaKLn/m8tJvInvFmrWi6eeuZB1Z/T5dJ2VB
 ycp/anOknO4lL7gnsNlzSrcSS3FGoqEWc1FxIgBTZtA4XgMAAA==
X-CMS-MailID: 20220525155007eucas1p1b7fc82f9e42be028e8f00109d55e6a62
X-Msg-Generator: CA
X-RootMTR: 20220525155007eucas1p1b7fc82f9e42be028e8f00109d55e6a62
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220525155007eucas1p1b7fc82f9e42be028e8f00109d55e6a62
References: <20220525154957.393656-1-p.raghav@samsung.com>
 <CGME20220525155007eucas1p1b7fc82f9e42be028e8f00109d55e6a62@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v6 7/8] dm-zoned: ensure only power of 2 zone
 sizes are allowed
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

From: Luis Chamberlain <mcgrof@kernel.org>

Today dm-zoned relies on the assumption that you have a zone size
with a power of 2. Even though the block layer today enforces this
requirement, these devices do exist and so provide a stop-gap measure
to ensure these devices cannot be used by mistake

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-zone.c         | 10 ++++++++++
 drivers/md/dm-zoned-target.c |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 57daa86c19cf..41188091fe6b 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -231,6 +231,16 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
 	struct request_queue *q = md->queue;
 	unsigned int noio_flag;
 	int ret;
+	struct block_device *bdev = md->disk->part0;
+	sector_t zone_sectors;
+
+	zone_sectors = bdev_zone_sectors(bdev);
+
+	if (!is_power_of_2(zone_sectors)) {
+		DMWARN("%s: %pg only power of two zone size supported",
+		       dm_device_name(md), bdev);
+		return -EINVAL;
+	}
 
 	/*
 	 * Check if something changed. If yes, cleanup the current resources
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index cac295cc8840..e4cef1b1b46c 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -792,6 +792,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
 				return -EINVAL;
 			}
 			zone_nr_sectors = blk_queue_zone_sectors(q);
+			if (!is_power_of_2(zone_nr_sectors)) {
+				ti->error = "Zone size not power of 2";
+				return -EINVAL;
+			}
 			zoned_dev->zone_nr_sectors = zone_nr_sectors;
 			zoned_dev->nr_zones =
 				blkdev_nr_zones(zoned_dev->bdev->bd_disk);
@@ -806,6 +810,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
 		q = bdev_get_queue(zoned_dev->bdev);
 		zoned_dev->zone_nr_sectors = blk_queue_zone_sectors(q);
 		zoned_dev->nr_zones = blkdev_nr_zones(zoned_dev->bdev->bd_disk);
+		if (!is_power_of_2(zone_nr_sectors)) {
+			ti->error = "Zone size not power of 2";
+			return -EINVAL;
+		}
 	}
 
 	if (reg_dev) {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

