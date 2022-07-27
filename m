Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F232C04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 16:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658939881;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=udbC8GGrZugMuSSbG93fk6gwo7+KDEJJVaPNFpbT5pc=;
	b=MR1HAWK7KyfOVlIsXZ2bFM6s9GP7A+HnXdPGb2HD0BRC1KIlRiqUp9CH5POPfk5KiFK2OW
	epWF57U098qMCniQSDHkZV5mZhhKSPGwl6B6R8W1lb9J2Xg5mGZO+CIxw4gkF9XxTN7wgq
	LhyC69DZ6GnIpX0Su2xFOL5lUTgJd7s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-IqPde678OoelVXYoOXgh0w-1; Wed, 27 Jul 2022 12:37:55 -0400
X-MC-Unique: IqPde678OoelVXYoOXgh0w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A08EF8039B7;
	Wed, 27 Jul 2022 16:37:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F2812166B26;
	Wed, 27 Jul 2022 16:37:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8E3C81947050;
	Wed, 27 Jul 2022 16:37:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2AED61945DA2
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1F1DFC15D67; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AFBAC28100
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03CF83C1069B
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-dNpeOfrhMrephy1JQK06tA-1; Wed, 27 Jul 2022 12:31:23 -0400
X-MC-Unique: dNpeOfrhMrephy1JQK06tA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220727162250euoutp01ed0de98ea11b59a9670076272c1bd1ab~FvDQuSgf12487524875euoutp01k
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:22:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220727162250euoutp01ed0de98ea11b59a9670076272c1bd1ab~FvDQuSgf12487524875euoutp01k
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220727162248eucas1p2754b09a52a4cc967eb7028ff301c7878~FvDPAZvNB0838408384eucas1p2_;
 Wed, 27 Jul 2022 16:22:48 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 84.E8.09580.85661E26; Wed, 27
 Jul 2022 17:22:48 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220727162247eucas1p203fc14aa17ecbcb3e6215d5304bb0c85~FvDOOXpfQ2171521715eucas1p2h;
 Wed, 27 Jul 2022 16:22:47 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220727162247eusmtrp1e5b1271244a6333800cd425899ce71ee~FvDOH-yMw0298902989eusmtrp1G;
 Wed, 27 Jul 2022 16:22:47 +0000 (GMT)
X-AuditID: cbfec7f5-9adff7000000256c-d9-62e166583e6d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 05.8D.09038.75661E26; Wed, 27
 Jul 2022 17:22:47 +0100 (BST)
Received: from localhost (unknown [106.210.248.8]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220727162246eusmtip1a0c727e66078316c43a69fc09227168e~FvDN32e690064100641eusmtip1P;
 Wed, 27 Jul 2022 16:22:46 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: damien.lemoal@opensource.wdc.com, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
Date: Wed, 27 Jul 2022 18:22:35 +0200
Message-Id: <20220727162245.209794-2-p.raghav@samsung.com>
In-Reply-To: <20220727162245.209794-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsWy7djPc7oRaQ+TDKavZrOYfljRYvXdfjaL
 aR9+Mlv8Pnue2WLvu9msFjcP7GSy2LNoEpPFytVHmSyerJ/FbPG36x6Txd5b2haXd81hs5i/
 7Cm7xYS2r8wWNyY8ZbT4vLSF3WLNzacsFiduSTsIeVy+4u2xc9Zddo/LZ0s9Nq3qZPPYvKTe
 Y/fNBjaPna33WT3e77vK5tG3ZRWjx+bT1R6fN8l5tB/oZgrgieKySUnNySxLLdK3S+DKaDjw
 nrFgt0jFhcf32RsYOwW7GDk5JARMJP7N7GUCsYUEVjBKLPjK2sXIBWR/YZS49PIcO4TzmVHi
 5+c5jDAd72Z3QFUtZ5Q4vHkKK0T7c0aJq5uBxnJwsAloSTR2soOERQSKJR6+a2UBqWcWeMck
 8WXhdbCEsECMxK97m8CGsgioShy9v5YNxOYVsJJoaP3LDLFMXmLmpe9g9ZwC1hKbp8xjgqgR
 lDg58wkLiM0MVNO8dTYzyAIJgc2cEguOX2SCaHaR6Dl2gB3CFpZ4dXwLlC0jcXpyDwuEXS3x
 9MZvqOYWRon+nevZQD6QANrWdyYHxGQW0JRYv0sfotxRYtf0P+wQFXwSN94KQpzAJzFp23Rm
 iDCvREebEES1ksTOn0+glkpIXG6aA7XUQ2JO50+WCYyKs5A8MwvJM7MQ9i5gZF7FKJ5aWpyb
 nlpsnJdarlecmFtcmpeul5yfu4kRmAxP/zv+dQfjilcf9Q4xMnEwHmKU4GBWEuFNiL6fJMSb
 klhZlVqUH19UmpNafIhRmoNFSZw3OXNDopBAemJJanZqakFqEUyWiYNTqoFpw5/MgKpDnfoM
 DJcvnbXcfn2n45ldfl84ix81vmkMTUjYKnQssSSDt7D9aMPhnws3d04rMvoX6PRbmWleRmje
 n+JH52z+ChlKJOtZzPJy/L3a8fPkRevML35+4vmwzPuIzKmnbatthXzmTpybUvvisML5qMIT
 SntmlXQfvxAlmWKQsvD/R37tOJXFjPFzxMs82dW9N9oJJ2l5xv0/vdil97KU5/H4FzsUa7/5
 PZuXmqMp+XNSEOMSvrMWPl1x/He+Py097RcRN6Hk1jRZj/PpjzufHNzuJ+kc1HjMzHPT/P/X
 InYHmN1n79BZ8fJBytoZe618j/eYJKQvkv/dndnOxPzqxcKX58Q2GXqcOeKkxFKckWioxVxU
 nAgAkGZkTfUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t/xu7rhaQ+TDFY38FhMP6xosfpuP5vF
 tA8/mS1+nz3PbLH33WxWi5sHdjJZ7Fk0icli5eqjTBZP1s9itvjbdY/JYu8tbYvLu+awWcxf
 9pTdYkLbV2aLGxOeMlp8XtrCbrHm5lMWixO3pB2EPC5f8fbYOesuu8fls6Uem1Z1snlsXlLv
 sftmA5vHztb7rB7v911l8+jbsorRY/Ppao/Pm+Q82g90MwXwROnZFOWXlqQqZOQXl9gqRRta
 GOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJalFunbJehlNBx4z1iwW6TiwuP77A2MnYJdjJwc
 EgImEu9md7B2MXJxCAksZZQ48fMaC0RCQuL2wiZGCFtY4s+1LjaIoqeMEvNOv2XuYuTgYBPQ
 kmjsZAcxRQQqJc5+kQUpZxb4wySxdwGYLSwQJTHn6gMmEJtFQFXi6P21bCA2r4CVREPrX2aI
 8fISMy99ZwexOQWsJTZPmQdWLwRU8+zBR6h6QYmTM5+wQMyXl2jeOpt5AqPALCSpWUhSCxiZ
 VjGKpJYW56bnFhvpFSfmFpfmpesl5+duYgTG7bZjP7fsYFz56qPeIUYmDsZDjBIczEoivAnR
 95OEeFMSK6tSi/Lji0pzUosPMZoC3T2RWUo0OR+YOPJK4g3NDEwNTcwsDUwtzYyVxHk9CzoS
 hQTSE0tSs1NTC1KLYPqYODilGpimx7zbf4bR4JLesn0axrX7nh7J+dC0afd8OWbG7C77c3HC
 669NU9l9Qlxm399FG39FvavcekrEvPSeyOZVOY+4fn7jdH+zyci6NHXOsW1N1pcXf1J6Jvpi
 35S+S1mRT4VPRbZ+tN+1xHWKm+oSs8C3lV2vzs2bvO3fyV86DcKSH9wSA4+H2p8Rqtv9Omg2
 q/yKYuP8es1nCjmBLcXGf4yjLm8WKfP1UDikp2/+81TCvZYf7XsTNtmuvCmSOk+3y+Zqq/3J
 y1982SaXN9wP0VT9ZFM5Q8P5o6NTUONVvXUW7xZo1b654+2VNCWfiSX9UO9GkY0Lp1cbm208
 1ePXv0hl2a0nO2RvyFxhr8ztXdWjxFKckWioxVxUnAgAwdXUPmQDAAA=
X-CMS-MailID: 20220727162247eucas1p203fc14aa17ecbcb3e6215d5304bb0c85
X-Msg-Generator: CA
X-RootMTR: 20220727162247eucas1p203fc14aa17ecbcb3e6215d5304bb0c85
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162247eucas1p203fc14aa17ecbcb3e6215d5304bb0c85
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162247eucas1p203fc14aa17ecbcb3e6215d5304bb0c85@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v8 01/11] block: make bdev_nr_zones and
 disk_zone_no generic for npo2 zsze
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Adam Manzanares <a.manzanares@samsung.com>,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Adapt bdev_nr_zones and disk_zone_no function so that it can
also work for non-power-of-2 zone sizes.

As the existing deployments of zoned devices had power-of-2
assumption, power-of-2 optimized calculation is kept for those devices.

There are no direct hot paths modified and the changes just
introduce one new branch per call.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c      | 13 +++++++++----
 include/linux/blkdev.h |  8 +++++++-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a264621d4905..dce9c95b4bcd 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -111,17 +111,22 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
  * bdev_nr_zones - Get number of zones
  * @bdev:	Target device
  *
- * Return the total number of zones of a zoned block device.  For a block
- * device without zone capabilities, the number of zones is always 0.
+ * Return the total number of zones of a zoned block device, including the
+ * eventual small last zone if present. For a block device without zone
+ * capabilities, the number of zones is always 0.
  */
 unsigned int bdev_nr_zones(struct block_device *bdev)
 {
 	sector_t zone_sectors = bdev_zone_sectors(bdev);
+	sector_t capacity = bdev_nr_sectors(bdev);
 
 	if (!bdev_is_zoned(bdev))
 		return 0;
-	return (bdev_nr_sectors(bdev) + zone_sectors - 1) >>
-		ilog2(zone_sectors);
+
+	if (is_power_of_2(zone_sectors))
+		return (capacity + zone_sectors - 1) >> ilog2(zone_sectors);
+
+	return DIV_ROUND_UP_SECTOR_T(capacity, zone_sectors);
 }
 EXPORT_SYMBOL_GPL(bdev_nr_zones);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index dccdf1551c62..85b832908f28 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -673,9 +673,15 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
 
 static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
 {
+	sector_t zone_sectors = disk->queue->limits.chunk_sectors;
+
 	if (!blk_queue_is_zoned(disk->queue))
 		return 0;
-	return sector >> ilog2(disk->queue->limits.chunk_sectors);
+
+	if (is_power_of_2(zone_sectors))
+		return sector >> ilog2(zone_sectors);
+
+	return div64_u64(sector, zone_sectors);
 }
 
 static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

