Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3871AC433FE
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 16:16:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-ReNSS353M1-U9vJDP3OvLQ-1; Mon, 23 May 2022 12:16:19 -0400
X-MC-Unique: ReNSS353M1-U9vJDP3OvLQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A96FB85A5BF;
	Mon, 23 May 2022 16:16:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 944F32166B25;
	Mon, 23 May 2022 16:16:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 851B7194705A;
	Mon, 23 May 2022 16:16:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C6E261947059
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 16:16:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A741A492C3B; Mon, 23 May 2022 16:16:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A367C492CA2
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86C7138349A3
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:15 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-6UeqaZh3PDCvvpmSTU__hQ-1; Mon, 23 May 2022 12:16:13 -0400
X-MC-Unique: 6UeqaZh3PDCvvpmSTU__hQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220523161612euoutp022869f40921de70df2a4a517eb6df1343~xyB6_j0Ci1880118801euoutp02O
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220523161612euoutp022869f40921de70df2a4a517eb6df1343~xyB6_j0Ci1880118801euoutp02O
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220523161611eucas1p1cb228cf2f9f73b3efa1d9b2c0fb0f3ea~xyB5gEiiO2464724647eucas1p1t;
 Mon, 23 May 2022 16:16:11 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 78.7E.09887.A43BB826; Mon, 23
 May 2022 17:16:10 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220523161610eucas1p212e81eda6b03a2d1ce8b763c9ec933ca~xyB5FGQZM1825618256eucas1p26;
 Mon, 23 May 2022 16:16:10 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220523161610eusmtrp2991c48c105296293b567a7e3bdadb98e~xyB5EUZl_0219002190eusmtrp2P;
 Mon, 23 May 2022 16:16:10 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-1b-628bb34aa273
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 9C.92.09522.A43BB826; Mon, 23
 May 2022 17:16:10 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220523161610eusmtip108e35c0ea0f8fe117da6b4fe20402e3b~xyB4ukA2_2143421434eusmtip1h;
 Mon, 23 May 2022 16:16:10 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, hch@lst.de, snitzer@redhat.com,
 damien.lemoal@opensource.wdc.com, hare@suse.de, Johannes.Thumshirn@wdc.com
Date: Mon, 23 May 2022 18:15:59 +0200
Message-Id: <20220523161601.58078-6-p.raghav@samsung.com>
In-Reply-To: <20220523161601.58078-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsWy7djP87pem7uTDJ7ts7JYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBZ7Fk1isli5+iiTxZP1s5gteg58YLH423WPyWLvLW2Ly7vmsFnM
 X/aU3eLGhKeMFp+XtrBbtG38yugg4PHvxBo2j8tnSz02repk89i8pN5j980GNo+drfdZPd7v
 u8rm0bdlFaPH+i1XWTw2n672+LxJzqP9QDdTAE8Ul01Kak5mWWqRvl0CV8bEF0vZC17rVsy8
 e4u9gXGHShcjJ4eEgInEnhudrCC2kMAKRolJS/S7GLmA7C+MEi0/mhghnM+MEp0XJ7HCdGze
 9YYRomM5o8S7C8IQRS8YJZ4ee8nexcjBwSagJdHYyQ4SFxFoZJR4f3QeK4jDLDCbSeLcg2tg
 k4QFXCQWXJ0BZrMIqEr8Ov2BCcTmFbCUaNn/nwlim7zEzEvf2UFsTgErietXr7JB1AhKnJz5
 hAXEZgaqad46mxlkgYTAek6JJe272CGaXSTWfNkIdbawxKvjW6DiMhL/d86HWlAt8fTGb6jm
 FkaJ/p3r2UBekBCwlug7kwNiMgtoSqzfpQ9R7ihxbncfK0QFn8SNt4IQJ/BJTNo2nRkizCvR
 0SYEUa0ksfPnE6ilEhKXm+awQNgeEr2/l7JNYFScheSZWUiemYWwdwEj8ypG8dTS4tz01GKj
 vNRyveLE3OLSvHS95PzcTYzABHj63/EvOxiXv/qod4iRiYPxEKMEB7OSCO/2xI4kId6UxMqq
 1KL8+KLSnNTiQ4zSHCxK4rzJmRsShQTSE0tSs1NTC1KLYLJMHJxSDUy2rHtuWVeeTW/dvun6
 ryCziMY7S368fx2yz/3XdN3F5hzCL8JmnTrl2CHSsyLj3ovZP15+qjuu9bA7TWfeYaEb+T9v
 qoisObVmc9iyX3GV54RE+6N1Vzz88v526CXnNQt57oUbiuTsKrS/GqYS5C9bJ+TVa58cYzvh
 iVjY3gO8t0//LclP+eQlUh5/riH7bskB5WU1rk1Zsyr4fgpL+T43Xibm5GXx4oBhu63n/1LW
 6kWzmzctTzsVYnJ159GtjC9K4k4Gzu014WI9vC9h8oLc95P/FuhcOn4xca1i1Xzf3g1SWTGR
 6/7aa+fL2kit8Vgf65RjwLvQYku16+aW+TeT9OS37tyvdytrroL9nGVKLMUZiYZazEXFiQDs
 I4Y07wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t/xu7pem7uTDHrnSVisvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbnFjwlNGi89LW9gt2jZ+ZXQQ8Ph3Yg2bx+WzpR6bVnWyeWxeUu+x+2YDm8fO1vusHu/3
 XWXz6NuyitFj/ZarLB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/I
 xFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2Pii6XsBa91K2bevcXewLhDpYuRk0NCwERi8643
 jF2MXBxCAksZJZr+r2WHSEhI3F7YxAhhC0v8udbFBmILCTxjlPg6V6aLkYODTUBLorGTHaRX
 RKCTUeLoilMsIA6zwHImiZdrFoM1Cwu4SCy4OoMVxGYRUJX4dfoDE4jNK2Ap0bL/PxPEAnmJ
 mZe+gy3mFLCSuH71KtQyS4lT6yewQ9QLSpyc+YQFxGYGqm/eOpt5AqPALCSpWUhSCxiZVjGK
 pJYW56bnFhvqFSfmFpfmpesl5+duYgRG67ZjPzfvYJz36qPeIUYmDsZDjBIczEoivNsTO5KE
 eFMSK6tSi/Lji0pzUosPMZoC3T2RWUo0OR+YLvJK4g3NDEwNTcwsDUwtzYyVxHk9CzoShQTS
 E0tSs1NTC1KLYPqYODilGphyevRc4pPzeKtCjVy9y1c28J3q+WhsuPoxy7Z8AZkTjE+tWi1c
 vC92vNtyYjVfb/S3B253G8MbJis+ODRpbk2qx+MTs+/xCrPEbZi2TWD7+tuO6ZcMCneKvjnl
 3te+rFZi9vETU38VaZR1VmdsLZt5aLeYTlD2tgK7wiNaJy1WtK3468EbMVt8u+8howybBbb6
 skLf/j/5sP921OpH/s2SfSo3Ppz4/ivymKvH5JOXLohpTrSc87ZHQoVJ7FoMw8u6OLs7mYar
 lGb/jc9j2WvQ9T79jnhL59ZM8b5jiqwml3QXfn/9dKHvGbuTEvv7r0h6PZmw9c+3dOc8+Sf6
 GQ3cWtcesx8MmPy8KdaBRVaJpTgj0VCLuag4EQAQOx/4XwMAAA==
X-CMS-MailID: 20220523161610eucas1p212e81eda6b03a2d1ce8b763c9ec933ca
X-Msg-Generator: CA
X-RootMTR: 20220523161610eucas1p212e81eda6b03a2d1ce8b763c9ec933ca
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220523161610eucas1p212e81eda6b03a2d1ce8b763c9ec933ca
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161610eucas1p212e81eda6b03a2d1ce8b763c9ec933ca@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v5 5/7] null_blk: allow non power of 2 zoned
 devices
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the power of 2 based calculation with zone size to be generic in
null_zone_no with optimization for power of 2 based zone sizes.

The nr_zones calculation in null_init_zoned_dev has been replaced with a
division without special handling for power of 2 based zone sizes as
this function is called only during the initialization and will not
invoked in the hot path.

Performance Measurement:

Device:
zone size = 128M, blocksize=4k

FIO cmd:

fio --name=zbc --filename=/dev/nullb0 --direct=1 --zonemode=zbd  --size=23G
--io_size=<iosize> --ioengine=io_uring --iodepth=<iod> --rw=<mode> --bs=4k
--loops=4

The following results are an average of 4 runs on AMD Ryzen 5 5600X with
32GB of RAM:

Sequential Write:

x-----------------x---------------------------------x---------------------------------x
|     IOdepth     |            8                    |            16                   |
x-----------------x---------------------------------x---------------------------------x
|                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
x-----------------x---------------------------------x---------------------------------x
| Without patch   |  578     |  2257    |   12.80   |  576     |  2248    |   25.78   |
x-----------------x---------------------------------x---------------------------------x
|  With patch     |  581     |  2268    |   12.74   |  576     |  2248    |   25.85   |
x-----------------x---------------------------------x---------------------------------x

Sequential read:

x-----------------x---------------------------------x---------------------------------x
| IOdepth         |            8                    |            16                   |
x-----------------x---------------------------------x---------------------------------x
|                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
x-----------------x---------------------------------x---------------------------------x
| Without patch   |  667     |  2605    |   11.79   |  675     |  2637    |   23.49   |
x-----------------x---------------------------------x---------------------------------x
|  With patch     |  667     |  2605    |   11.79   |  675     |  2638    |   23.48   |
x-----------------x---------------------------------x---------------------------------x

Random read:

x-----------------x---------------------------------x---------------------------------x
| IOdepth         |            8                    |            16                   |
x-----------------x---------------------------------x---------------------------------x
|                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
x-----------------x---------------------------------x---------------------------------x
| Without patch   |  522     |  2038    |   15.05   |  514     |  2006    |   30.87   |
x-----------------x---------------------------------x---------------------------------x
|  With patch     |  522     |  2039    |   15.04   |  523     |  2042    |   30.33   |
x-----------------x---------------------------------x---------------------------------x

Minor variations are noticed in Sequential write with io depth 8 and
in random read with io depth 16. But overall no noticeable differences
were noticed

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/block/null_blk/main.c  |  5 ++---
 drivers/block/null_blk/zoned.c | 14 +++++++-------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index c441a4972064..1dec51d69674 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1930,9 +1930,8 @@ static int null_validate_conf(struct nullb_device *dev)
 	if (dev->queue_mode == NULL_Q_BIO)
 		dev->mbps = 0;
 
-	if (dev->zoned &&
-	    (!dev->zone_size || !is_power_of_2(dev->zone_size))) {
-		pr_err("zone_size must be power-of-two\n");
+	if (dev->zoned && !dev->zone_size) {
+		pr_err("Invalid zero zone size\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index dae54dd1aeac..00c34e65ef0a 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -13,7 +13,10 @@ static inline sector_t mb_to_sects(unsigned long mb)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
-	return sect >> ilog2(dev->zone_size_sects);
+	if (is_power_of_2(dev->zone_size_sects))
+		return sect >> ilog2(dev->zone_size_sects);
+
+	return div64_u64(sect, dev->zone_size_sects);
 }
 
 static inline void null_lock_zone_res(struct nullb_device *dev)
@@ -62,10 +65,6 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	sector_t sector = 0;
 	unsigned int i;
 
-	if (!is_power_of_2(dev->zone_size)) {
-		pr_err("zone_size must be power-of-two\n");
-		return -EINVAL;
-	}
 	if (dev->zone_size > dev->size) {
 		pr_err("Zone size larger than device capacity\n");
 		return -EINVAL;
@@ -83,8 +82,9 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
 	dev_capacity_sects = mb_to_sects(dev->size);
 	dev->zone_size_sects = mb_to_sects(dev->zone_size);
-	dev->nr_zones = round_up(dev_capacity_sects, dev->zone_size_sects)
-		>> ilog2(dev->zone_size_sects);
+	dev->nr_zones =
+		div64_u64(roundup(dev_capacity_sects, dev->zone_size_sects),
+			  dev->zone_size_sects);
 
 	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct nullb_zone),
 				    GFP_KERNEL | __GFP_ZERO);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

