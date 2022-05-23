Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CAF3C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 16:16:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-KXUmmvxiMJuYuAEYYa43fw-1; Mon, 23 May 2022 12:16:24 -0400
X-MC-Unique: KXUmmvxiMJuYuAEYYa43fw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 874A580418E;
	Mon, 23 May 2022 16:16:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6D11140D1B98;
	Mon, 23 May 2022 16:16:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 23F15194705A;
	Mon, 23 May 2022 16:16:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D4F62194705A
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 16:16:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C63E82166B2F; Mon, 23 May 2022 16:16:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C21C72166B25
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAC5080B718
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:19 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247--R89xKQ5M7KBj435FDsubQ-1; Mon, 23 May 2022 12:16:17 -0400
X-MC-Unique: -R89xKQ5M7KBj435FDsubQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220523161615euoutp02ca7b306e007313260c0bb73f15bedb04~xyB9vDulD1844818448euoutp02h
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220523161615euoutp02ca7b306e007313260c0bb73f15bedb04~xyB9vDulD1844818448euoutp02h
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220523161613eucas1p14eb4dfeeca85d1b74be3a853a80b3897~xyB8L9OR_1546315463eucas1p1V;
 Mon, 23 May 2022 16:16:13 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 5E.7E.09887.D43BB826; Mon, 23
 May 2022 17:16:13 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220523161613eucas1p256b21b1a631324b4814465decf3958ce~xyB7qut2W0957009570eucas1p2d;
 Mon, 23 May 2022 16:16:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220523161613eusmtrp2c000f1ed1707206c2a22768a34db555b~xyB7p7UDg0219002190eusmtrp2W;
 Mon, 23 May 2022 16:16:13 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-28-628bb34de617
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 71.29.09404.D43BB826; Mon, 23
 May 2022 17:16:13 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220523161612eusmtip1e2e71268148d672b0c1860ca258f8832~xyB7VIab71408314083eusmtip1g;
 Mon, 23 May 2022 16:16:12 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, hch@lst.de, snitzer@redhat.com,
 damien.lemoal@opensource.wdc.com, hare@suse.de, Johannes.Thumshirn@wdc.com
Date: Mon, 23 May 2022 18:16:01 +0200
Message-Id: <20220523161601.58078-8-p.raghav@samsung.com>
In-Reply-To: <20220523161601.58078-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0wTZxzG895dr0dD2VkdfCPTbV2EUGfLnISTkQUiSy5biNPELJQYqXjD
 BqikBxsbcYPxU1z40f1sYWIYagGxlVal7dywCXaMMQhNJ2Vxm9puRFEghWFHhFFOM/97vu/z
 ed/n+yQvhct+E22mtLpSTq/TFMlJCXH5enhsR7bt5OHk1XEV03uzmWSWR8dw5uqDNhEz/rAK
 Y/yDDoz5rtOAMd29QxgTsJhw5tPBOYJ51Pg7xlyd2s54ne0k03E2KGYmW4KICZ2pETN1FxdR
 Bs2u/HieZL2jZWx/zwmStXV9zLr8lSTrqP1DxM5+7yPZJnsPYi12H8HaRirYUP9Wtn7wJPZ2
 tFqSfoQr0r7H6VWv50mOfj6sLjklKfff7yMqkZVqRFEU0LvggudvshFJKBltRtDg6UcRQ0Yv
 ILA/ekcwQgjC4yfET278YO1AgnEOgdvaKxKGaQRBc+vaQFEkrYCqyAUJtYmuQjA7dGodwuk2
 DPzLD0WRpzbS+2DVZVzPI+htYO+xExEtpXeDddxFCnHPg3FiaT06ik6DGz4fKTAbYNgYWOfx
 Nab6Uhsu8JYomP6pXNBZYKu+gQS9Ee567I8rPAerjg5M0BUQnFzGI8sBXYOg2WEhIw2Afg2a
 fi6KSJxOAotTJeCZ4HpQLRKIGJi8v0HYIAYMl7/ChWMpNNTJBFoOjnDgcSiA95N2QtAsmG6H
 xC3oRdNTXUxPdTH9n3sa4T0ojivjiws4fqeOe1/Ja4r5Ml2BMv9YcT9a+38jK56FAXTu7rzS
 jTAKuRFQuHyT9Iqm4bBMekTzwYec/tghfVkRx7tRPEXI46T5WqtGRhdoSrlCjivh9E9cjIra
 XIm9/KYiZfuvxtzW9B3/fnRgbvrL3IWKGpeXz7zzbsLSrYREtVuRZ+ja9kt+VyDTILXO8wOp
 Ru0/U4rjKYmS+j1xX8c7n51p6VZmJF/oMIYrC9Wcrzc7/G2TNnY4Y4Ev2TI298bwmUuhP70x
 5i9yEoN468061lnarTZnfTaAv1U/4Uu7PhqdoBqRFiPbxOR8knio0xx7b2tSVdZZi6TPc1sV
 2O1ul88V5i7vzJzNcXwTP5PdGchZ2vPM4L3UWdysO1S7K+/41C2V8wVzmu8vQ8506uJL3TV3
 9jtWF2ObiS0Ho/devOZPkXfWNV57dX9f+XllbWKh7eCV7AxxKHnvzMqBdDnBH9W8osD1vOY/
 s4Y9Ge4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t/xu7q+m7uTDN4cE7BYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBZ7Fk1isli5+iiTxZP1s5gteg58YLH423WPyWLvLW2Ly7vmsFnM
 X/aU3eLGhKeMFp+XtrBbtG38yugg4PHvxBo2j8tnSz02repk89i8pN5j980GNo+drfdZPd7v
 u8rm0bdlFaPH+i1XWTw2n672+LxJzqP9QDdTAE+Unk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6R
 iaWeobF5rJWRqZK+nU1Kak5mWWqRvl2CXsaUk1EF87gqbr5dy9LAuIGji5GTQ0LARGL/hvmM
 XYxcHEICSxklPv1qYINISEjcXtjECGELS/y51sUGUfSMUWLNi0PMXYwcHGwCWhKNnewgcRGB
 TkaJoytOsYA4zALLmSRuPGlhAukWFvCX2LfwPCuIzSKgKrFl1RYWEJtXwFJiw4XdUNvkJWZe
 +s4OYnMKWElcv3oVLC4EVHNq/QR2iHpBiZMzn4D1MgPVN2+dzTyBUWAWktQsJKkFjEyrGEVS
 S4tz03OLjfSKE3OLS/PS9ZLzczcxAqN127GfW3Ywrnz1Ue8QIxMH4yFGCQ5mJRHe7YkdSUK8
 KYmVValF+fFFpTmpxYcYTYHunsgsJZqcD0wXeSXxhmYGpoYmZpYGppZmxkrivJ4FHYlCAumJ
 JanZqakFqUUwfUwcnFINTFMFpirMu1Une2/b55riPXOYGMrcpn+/Jf/G+op0mtjfZ6dV3N+n
 7F8bfGnhuX8pizmN1907Erz5/MKnC6//t1ji9OeMMdOhmCsr7h0VOHK+ccGErH9GT4vMF62d
 +XLya47cG+YnGlQtOQ9t9ViguKlU/aPGGo+pfaKx0TVH2f+Hvm7j+/zE5s9KsW6h5W5fJta/
 uC0cvVu7+k6t7XuD8FtuuifKNm48cGDatomeRxIub2PSmLGZlydD/01kQOv6xObfZVZz+y9K
 1mkcs6/uDM9v8Bb0nFkTaLhZbK3p1u8matyTt2sf2rHtkp7X69tuXf9uzd+Z+P+zoijTyuM7
 JzVfEmYMk+FTuMX09dneX6nHlFiKMxINtZiLihMBy1qFi18DAAA=
X-CMS-MailID: 20220523161613eucas1p256b21b1a631324b4814465decf3958ce
X-Msg-Generator: CA
X-RootMTR: 20220523161613eucas1p256b21b1a631324b4814465decf3958ce
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220523161613eucas1p256b21b1a631324b4814465decf3958ce
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161613eucas1p256b21b1a631324b4814465decf3958ce@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH v5 7/7] dm-zoned: ensure only power of 2 zone
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
 drivers/md/dm-zone.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 57daa86c19cf..f87a1eda8252 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -231,6 +231,18 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
 	struct request_queue *q = md->queue;
 	unsigned int noio_flag;
 	int ret;
+	struct block_device *bdev = md->disk->part0;
+	sector_t zone_sectors;
+	char bname[BDEVNAME_SIZE];
+
+	zone_sectors = bdev_zone_sectors(bdev);
+
+	if (!is_power_of_2(zone_sectors)) {
+		DMWARN("%s: %s only power of two zone size supported",
+		       dm_device_name(md),
+		       bdevname(bdev, bname));
+		return -EINVAL;
+	}
 
 	/*
 	 * Check if something changed. If yes, cleanup the current resources
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

