Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B27ECAAA1
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970976;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PB9p5+DxIq5q2Mh/efgF6pardFkHAHqcNCk3am0NlWw=;
	b=Tp7NYtiz6Jh+LS0cCxBWqB58sRIpb60oAlmvgt338ZD/2ZMFiBC/1cS01SSKeykJVBaraq
	Gdp4kYFHgDUzB26XvWIWHZDoa6ap+m4E63/NSEerz/+jAMJDba1+fGC+GPa4NCVkIOzgPD
	WTGlp/iTDPRnW0N0XtHE9f5WOwg2sjo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-WsCXnbAzNpGDtuSgh5KWfw-1; Mon, 12 Sep 2022 04:22:53 -0400
X-MC-Unique: WsCXnbAzNpGDtuSgh5KWfw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87F33185A7BA;
	Mon, 12 Sep 2022 08:22:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7568A40C6EC3;
	Mon, 12 Sep 2022 08:22:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 57C931946A48;
	Mon, 12 Sep 2022 08:22:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E0F801946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C53D22027062; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C12702027061
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB8CB8032FB
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-djteZj1oMtShqd4Ki4QG4Q-1; Mon, 12 Sep 2022 04:22:48 -0400
X-MC-Unique: djteZj1oMtShqd4Ki4QG4Q-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082217euoutp02f6dfd82feb6c000859b64e22744dba78~UD0HObkNU2265222652euoutp02P
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220912082217euoutp02f6dfd82feb6c000859b64e22744dba78~UD0HObkNU2265222652euoutp02P
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220912082215eucas1p20d6aa1ec8ff1a6e145de06afcb2fd104~UD0FXe4LO0125901259eucas1p2K;
 Mon, 12 Sep 2022 08:22:15 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 05.A3.19378.73CEE136; Mon, 12
 Sep 2022 09:22:15 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220912082214eucas1p1a5796db60e6972eace43c3ab6976248c~UD0EsLnG_0912009120eucas1p1x;
 Mon, 12 Sep 2022 08:22:14 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220912082214eusmtrp1977e05345de0d80a215460772cec7d12~UD0ErJayw1362513625eusmtrp1I;
 Mon, 12 Sep 2022 08:22:14 +0000 (GMT)
X-AuditID: cbfec7f5-a4dff70000014bb2-60-631eec372945
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id F1.3F.07473.63CEE136; Mon, 12
 Sep 2022 09:22:14 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082214eusmtip21c2b4c578bcbcb433092971e84d434eb~UD0ESMPO52680426804eusmtip2P;
 Mon, 12 Sep 2022 08:22:14 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:21:59 +0200
Message-Id: <20220912082204.51189-9-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsWy7djP87rmb+SSDd4sVbdYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlXFj
 0VqWgkbeildTlrM0MN7h6mLk4JAQMJH41BPdxcjJISSwglFiTad3FyMXkP2FUeJ/w2ZGCOcz
 o8SspotMIFUgDY//d7BBJJYzSvQ/WAlV9ZJR4sCkFywgY9kEtCQaO9lBGkQE0iW+T3/HBFLD
 LHCHSWL7xfdgk4QFQiQuLpnCCGKzCKhK3Hp3HSzOK2Ap0bq8E2qbvMTMS9/BBnEKWEm8XtXK
 CFEjKHFy5hMWEJsZqKZ562xmkAUSAps5JbpetjJDNLtIvPgxix3CFpZ4dXwLlC0jcXpyDwuE
 XS3x9MZvqOYWoHd2rmeDBIy1RN+ZHBCTWUBTYv0ufYhyR4mNC1ZDVfBJ3HgrCHECn8SkbdOZ
 IcK8Eh1tQhDVShI7fz6BWiohcblpDgtEiYfEtBO2ExgVZyH5ZRaSX2YhrF3AyLyKUTy1tDg3
 PbXYOC+1XK84Mbe4NC9dLzk/dxMjMBme/nf86w7GFa8+6h1iZOJgPMQowcGsJMLLYiidLMSb
 klhZlVqUH19UmpNafIhRmoNFSZw3OXNDopBAemJJanZqakFqEUyWiYNTqoHJYIWPvcye3yXW
 LAvFjs/YKWrNLlRdEVeQ9OW25pbvFlF1nlsaJtRHfvKNYk89vvN3ehL7lJcx9gFqU34uf7DI
 79C3TOfPNxTDFspwvTXKlJaXVDBf7rCWeeWW7Rov++K9XZuuZMotagkR1Mz0blujmqXnvP1n
 sEvCbKVy1UzmkM6NWb9+cp888eZSyP3o18ufcp6zOTarpe99ecSL1oPpfGHbbJT/bzo7MVvV
 edXLn9Pi//8pOsJo0l320Hbq/YBF82cvu3fz3xNx1apj4o1f2h/b+d1J69M9or4m5s/17O2v
 vMSPtZx+F/PriLvvvfCSmPAluYf8lb5Ut0Xle2rzh/5iO8HI6qAUdf6ORIwSS3FGoqEWc1Fx
 IgB38w+l9QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xe7pmb+SSDfpfGlmsP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFjcmPGW0+Ly0hd1izc2nLBYnbkk7CHlcvuLtsXPWXXaPy2dLPTat6mTz2Lyk
 3mP3zQY2j52t91k93u+7yubRt2UVo8fm09UenzfJebQf6GYK4InSsynKLy1JVcjILy6xVYo2
 tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy7ixaC1LQSNvxaspy1kaGO9wdTFy
 ckgImEg8/t/B1sXIxSEksJRR4svT7cwQCQmJ2wubGCFsYYk/17qgip4zSvT17AQq4uBgE9CS
 aOxkB6kREciV+LzyB1gNs8AbJokNd9YzgSSEBYIknm1cDDaURUBV4ta762BxXgFLidblnUwQ
 C+QlZl76DjaIU8BK4vWqVrDFQkA1Z7/dYIeoF5Q4OfMJC4jNDFTfvHU28wRGgVlIUrOQpBYw
 Mq1iFEktLc5Nzy021CtOzC0uzUvXS87P3cQIjN5tx35u3sE479VHvUOMTByMhxglOJiVRHhZ
 DKWThXhTEiurUovy44tKc1KLDzGaAt09kVlKNDkfmD7ySuINzQxMDU3MLA1MLc2MlcR5PQs6
 EoUE0hNLUrNTUwtSi2D6mDg4pRqYJs8wmWZTeigx2T3f1URF+4rwl3kpM/i5JZe0T14j5PVc
 mLsufnpzR/HrRO6r7Qu/KB0/x35xw4V9HzdLn7pfXTcj8+8x9efeb9cFMrZ9TUziY/brdIya
 8qDXdHpY8oEZKov73Gb/evz6D9/6DxNjM9XPNM07MvtIceyNXc/z+loWl5fzfu++feLZgoid
 Cm+ZrEUNa/ieRhlsjn35NPRxzLfb0yMsJe6lxiYsrlUudHOVn3PdpVTcIdRHyL1Dz+fPS+Xk
 /OW/Z1yarH9Y9NEdacO/WROiLda2L+7k5mgILJje0CI4QX12xpwe88PWwQlPrBla2P+lZ37R
 e/137fvgfpXadTs/+e7TfSK65c4hJZbijERDLeai4kQAGQ1PmGcDAAA=
X-CMS-MailID: 20220912082214eucas1p1a5796db60e6972eace43c3ab6976248c
X-Msg-Generator: CA
X-RootMTR: 20220912082214eucas1p1a5796db60e6972eace43c3ab6976248c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082214eucas1p1a5796db60e6972eace43c3ab6976248c
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082214eucas1p1a5796db60e6972eace43c3ab6976248c@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v13 08/13] dm-zoned: ensure only power of 2 zone
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Luis Chamberlain <mcgrof@kernel.org>

dm-zoned relies on the assumption that the zone size is a
power-of-2(po2) and the zone capacity is same as the zone size.

Ensure only po2 devices can be used as dm-zoned target until a native
support for zoned devices with non-po2 zone size is added.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-zoned-target.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 95b132b52f33..9325bf5dee81 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -792,6 +792,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
 				return -EINVAL;
 			}
 			zone_nr_sectors = bdev_zone_sectors(bdev);
+			if (!is_power_of_2(zone_nr_sectors)) {
+				ti->error = "Zone size is not a power-of-2 number of sectors";
+				return -EINVAL;
+			}
 			zoned_dev->zone_nr_sectors = zone_nr_sectors;
 			zoned_dev->nr_zones = bdev_nr_zones(bdev);
 		}
@@ -804,6 +808,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
 			return -EINVAL;
 		}
 		zoned_dev->zone_nr_sectors = bdev_zone_sectors(bdev);
+		if (!is_power_of_2(zoned_dev->zone_nr_sectors)) {
+			ti->error = "Zone size is not a power-of-2 number of sectors";
+			return -EINVAL;
+		}
 		zoned_dev->nr_zones = bdev_nr_zones(bdev);
 	}
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

