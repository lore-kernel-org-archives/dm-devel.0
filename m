Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A53D7C43219
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 16:16:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-5yCoa_fYPe6Lz_e6tSWb1w-1; Mon, 23 May 2022 12:16:17 -0400
X-MC-Unique: 5yCoa_fYPe6Lz_e6tSWb1w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26DC338349A6;
	Mon, 23 May 2022 16:16:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BE527C2A;
	Mon, 23 May 2022 16:16:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 05F86194705B;
	Mon, 23 May 2022 16:16:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CDDA91947059
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 16:16:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B145D492CA2; Mon, 23 May 2022 16:16:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACEFF492C3B
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95A593C1E321
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:10 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-wTjZyZnCM_eCmdWs4Vf9sw-1; Mon, 23 May 2022 12:16:08 -0400
X-MC-Unique: wTjZyZnCM_eCmdWs4Vf9sw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220523161606euoutp025d596a5e33bf71c429f769267b684436~xyB1n0egj1865718657euoutp02I
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220523161606euoutp025d596a5e33bf71c429f769267b684436~xyB1n0egj1865718657euoutp02I
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220523161605eucas1p255aa2158f858eacd6ec421d41a1f2849~xyB0MFXqD2258022580eucas1p2u;
 Mon, 23 May 2022 16:16:05 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id FC.A9.10260.543BB826; Mon, 23
 May 2022 17:16:05 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220523161604eucas1p2927e20dbd0602c08b6df4fc41e62dfbe~xyBz1_CQs1186311863eucas1p29;
 Mon, 23 May 2022 16:16:04 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220523161604eusmtrp21f0d4014a48df01085abb009a150ac3b~xyBz1Gxts0219002190eusmtrp2I;
 Mon, 23 May 2022 16:16:04 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-fc-628bb345b402
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id C8.92.09522.443BB826; Mon, 23
 May 2022 17:16:04 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220523161604eusmtip262af8805d5f532401444730d338bcc3f~xyBzeftlD0812708127eusmtip2K;
 Mon, 23 May 2022 16:16:04 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, hch@lst.de, snitzer@redhat.com,
 damien.lemoal@opensource.wdc.com, hare@suse.de, Johannes.Thumshirn@wdc.com
Date: Mon, 23 May 2022 18:15:55 +0200
Message-Id: <20220523161601.58078-2-p.raghav@samsung.com>
In-Reply-To: <20220523161601.58078-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsWy7djP87qum7uTDDr+8lmsvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbnFjwlNGi89LW9gt2jZ+ZXQQ8Ph3Yg2bx+WzpR6bVnWyeWxeUu+x+2YDm8fO1vusHu/3
 XWXz6NuyitFj/ZarLB6bT1d7fN4k59F+oJspgCeKyyYlNSezLLVI3y6BK+NS1zOWgpkiFd8a
 77A2MD4R6GLk5JAQMJHYueomexcjF4eQwApGiSuf7jNBOF8YJXY/uQeV+cwoMX/ZDWaYlqUb
 LjBCJJYzSmyesQPKecEosW/1IiCHg4NNQEuisROsW0SgkVHi/dF5rCAOs8BsJolzD66xgowS
 FkiUaGy/zArSwCKgKrFgnRBImFfAUuLozI9sENvkJWZe+s4OYnMKWElcv3qVDaJGUOLkzCcs
 IDYzUE3z1tnMIPMlBNZzSsyb0cMCMlNCwEXi7XQ/iDnCEq+Ob2GHsGUk/u+czwRhV0s8vfEb
 qreFUaJ/53o2iF5rib4zOSAms4CmxPpd+hDljhI3Xi1lh6jgk7jxVhDiAj6JSdumM0OEeSU6
 2oQgqpUkdv58ArVUQuJy0xwWCNtD4tyBu0wTGBVnIfllFpJfZiHsXcDIvIpRPLW0ODc9tdg4
 L7Vcrzgxt7g0L10vOT93EyMwAZ7+d/zrDsYVrz7qHWJk4mA8xCjBwawkwrs9sSNJiDclsbIq
 tSg/vqg0J7X4EKM0B4uSOG9y5oZEIYH0xJLU7NTUgtQimCwTB6dUAxP/O6Npf9jtY2ak+87c
 /ejZ/R0ZP1t9OQuiv8Qe3fPZT5/7FP99pTTNi3l9SkUvA7hFU48JbN30cVu+tcnrcBFe/fhu
 jSlczYsfSO2ctqm1/FXQI5Z5K4XPvpd/J91lcPrpzt7Zs0pYmH7Hd2j/ZjGb1VT2wSrzzIXz
 metn/b2/LkvRc1blicefN0Xz16Y95PK9edvkV716t5PRvi+e65W561ZveX7/X/VD+29O3X/f
 rj4wRcK5forkhatPJ3XZ8hc3W1Qu7wu+56izJzZN5IT9kauHfx9+49dfcU3w+i+2BQYSkgtb
 vPVV57L8qLhvb8w9ld3wzq3WBWf7lvDJufk8/lGc+I7n3/kVp/+/Va1UYinOSDTUYi4qTgQA
 g4h1Pe8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t/xe7oum7uTDJZdMLBYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBZ7Fk1isli5+iiTxZP1s5gteg58YLH423WPyWLvLW2Ly7vmsFnM
 X/aU3eLGhKeMFp+XtrBbtG38yugg4PHvxBo2j8tnSz02repk89i8pN5j980GNo+drfdZPd7v
 u8rm0bdlFaPH+i1XWTw2n672+LxJzqP9QDdTAE+Unk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6R
 iaWeobF5rJWRqZK+nU1Kak5mWWqRvl2CXsalrmcsBTNFKr413mFtYHwi0MXIySEhYCKxdMMF
 xi5GLg4hgaWMEieaNzNDJCQkbi9sYoSwhSX+XOtigyh6xihxZsoEpi5GDg42AS2Jxk52kLiI
 QCejxNEVp1hAHGaB5UwSL9csZgQpEhaIl7g2KRvEZBFQlViwTghkJq+ApcTRmR/ZIObLS8y8
 9J0dxOYUsJK4fvUqWFwIqObU+gnsEPWCEidnPmEBsZmB6pu3zmaewCgwC0lqFpLUAkamVYwi
 qaXFuem5xYZ6xYm5xaV56XrJ+bmbGIGxuu3Yz807GOe9+qh3iJGJg/EQowQHs5II7/bEjiQh
 3pTEyqrUovz4otKc1OJDjKZAZ09klhJNzgcmi7ySeEMzA1NDEzNLA1NLM2MlcV7Pgo5EIYH0
 xJLU7NTUgtQimD4mDk6pBiaJLZmvjI9JfihXXDh53eKXwa8q5TJfST2wD56aWPr9jUt/tPtD
 oa2Cqx2XZeu7WGXEfzl85TVT1vFFlg8/vxE5L/qRqdL45OmQH8e/3dZTCStestx4yztTzT1H
 OWf9fqEhYH5zxU/tNyURhyUZeDmYd7uvmXPuiKTG7RxzJtH/trsnifj+C4uLbas2Oays0fFx
 6qQfSxoP/Vjb9JDpRtGdcJGHlwWMv2YdttkqduDngcWxH2Q+r9QxC9g2b7PXFb8l+TbSBuw/
 v5/Zrdruwio6ZZ/3WYULKcKq4RkxyTqvEqV6FH+YHBIq5vXz5e9e437lllZ49TNnb30r2/mK
 HA9frtGeWp5kybHd1SSsfZUSS3FGoqEWc1FxIgB2oD+lXgMAAA==
X-CMS-MailID: 20220523161604eucas1p2927e20dbd0602c08b6df4fc41e62dfbe
X-Msg-Generator: CA
X-RootMTR: 20220523161604eucas1p2927e20dbd0602c08b6df4fc41e62dfbe
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220523161604eucas1p2927e20dbd0602c08b6df4fc41e62dfbe
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161604eucas1p2927e20dbd0602c08b6df4fc41e62dfbe@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v5 1/7] block: make blkdev_nr_zones and
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
index 38cd840d8838..e7eec513dd42 100644
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
+	return div64_u64(capacity + zone_sectors - 1, zone_sectors);
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

