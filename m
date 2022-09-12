Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2F2C6FA86
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970977;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UGDcJtclrmHUIQxGUxp5+r/IKUsPPsAZ+52XmyACDnw=;
	b=cR6+6q92zTOzV8BZA8WWyXsUu3q5z8yz32ZLO/sBK3tYjq0kB73f9DRa6we4u6Frmv4bUG
	mdYuR23Yd/mUmQy/F35g7r9vqYfLV6/SBW72nPeHSNp+txnaqcgcC5E7DumrMA3u2g7tGy
	hxmDk0W3b/z6gQp3oCFVhYRop5VEgu8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-h9UtGnoGMPa6hEdRW_8tPA-1; Mon, 12 Sep 2022 04:22:54 -0400
X-MC-Unique: h9UtGnoGMPa6hEdRW_8tPA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9C821C0515E;
	Mon, 12 Sep 2022 08:22:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A6315C15BA5;
	Mon, 12 Sep 2022 08:22:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 889D81946A43;
	Mon, 12 Sep 2022 08:22:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7143E1946A48
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4721B17582; Mon, 12 Sep 2022 08:22:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 434BE10EB8
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29DC5101E98C
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:50 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-GeSA5uBlPrCuDHYId130yQ-1; Mon, 12 Sep 2022 04:22:48 -0400
X-MC-Unique: GeSA5uBlPrCuDHYId130yQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082228euoutp0285ac948b55d50927f5ef63e67f27dbdb~UD0RREkuA2332523325euoutp02V
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220912082228euoutp0285ac948b55d50927f5ef63e67f27dbdb~UD0RREkuA2332523325euoutp02V
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220912082216eucas1p217f198775cbabf54dbb8af06c3a07c73~UD0Gdw1oP2081220812eucas1p2V;
 Mon, 12 Sep 2022 08:22:16 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 7D.98.29727.83CEE136; Mon, 12
 Sep 2022 09:22:16 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220912082216eucas1p1d3068e7578a88007515c2f4f5ebcc2a8~UD0FqyqF71768417684eucas1p1V;
 Mon, 12 Sep 2022 08:22:16 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220912082216eusmtrp278adcdd0eae8192ad23f86c36bcfd1d7~UD0Fp6fEE3116631166eusmtrp2H;
 Mon, 12 Sep 2022 08:22:16 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-0d-631eec381941
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id CE.33.10862.73CEE136; Mon, 12
 Sep 2022 09:22:15 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082215eusmtip1f09a8a5eff3926ebd36906443d538437~UD0FVcuxy1289112891eusmtip1d;
 Mon, 12 Sep 2022 08:22:15 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:22:00 +0200
Message-Id: <20220912082204.51189-10-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7djPc7oWb+SSDebc1LNYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlfFq
 9nS2gtfcFVNWTGZtYHzK2cXIySEhYCJx5dgJ5i5GLg4hgRWMEn9fTmCEcL4wShw4+ZcdwvnM
 KHFrTTszTMvEO5OgEssZJRbeOM4G4bxklJh44CJrFyMHB5uAlkRjJztIg4hAusT36e+YQGqY
 Be4wSTQdesEIkhAWiJWYdfUTG4jNIqAqsfvENbAGXgErieazzUwQ2+QlZl76DhbnBIq/XtXK
 CFEjKHFy5hMWEJsZqKZ562yo6zZzSuzYXwdhu0h83XMZao6wxKvjW9ghbBmJ/zvnQ8WrJZ7e
 +A0OAAmBFkaJ/p3r2UAekBCwlug7kwNiMgtoSqzfpQ9R7iixoKWBGaKCT+LGW0GIC/gkJm2b
 DhXmlehoE4KoVpLY+fMJ1FIJictNc1ggbA+JJT8nME9gVJyF5JdZSH6ZhbB3ASPzKkbx1NLi
 3PTUYsO81HK94sTc4tK8dL3k/NxNjMCEePrf8U87GOe++qh3iJGJg/EQowQHs5IIL4uhdLIQ
 b0piZVVqUX58UWlOavEhRmkOFiVx3uTMDYlCAumJJanZqakFqUUwWSYOTqkGJg21Ne6Z8d+X
 GayQ9GpbeHIt97kNosvvbGU9eeT2G5NWp66uA4z3jH5IR155n7W65SH3zBP9FrMObc6/W1nU
 /rCkcx7bo+Yvmbnzizrmf3xoqX6ToSr664W/E3e0V4s6hu/X9T4yl2GeX9Fq2fNTdFNbwpqa
 6t2OLhXrfb9xykfJlbvK9kRn7Wrb8ehz995L/2yvLZ6jseJrQEt3g2mPq8vdL0bOx999+MDg
 KZdcUB/acOh+/16rYx3LO16mTAubtKDDo8z2kqJzzWfhddd0ja78KpPNPm+z/EREdMRjLt2T
 ++6+Tjrru1R9Uvb2MHbrs8nHEw/fP3F7pqqfW93ewCWND2btiTHqnjZb8bxA2iQlluKMREMt
 5qLiRABUnFax9wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xu7rmb+SSDVZMsrFYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl/Fq9nS2gtfcFVNWTGZtYHzK2cXI
 ySEhYCIx8c4k9i5GLg4hgaWMEh0rn7FCJCQkbi9sYoSwhSX+XOtigyh6zijRsOMoUBEHB5uA
 lkRjJztIjYhArsTnlT/AapgF3jBJfFkyiQkkISwQLdG//zGYzSKgKrH7xDWwBl4BK4nms81M
 EAvkJWZe+g4W5wSKv17VCrZYSMBS4uy3G1D1ghInZz5hAbGZgeqbt85mnsAoMAtJahaS1AJG
 plWMIqmlxbnpucVGesWJucWleel6yfm5mxiB0bvt2M8tOxhXvvqod4iRiYPxEKMEB7OSCC+L
 oXSyEG9KYmVValF+fFFpTmrxIUZToLsnMkuJJucD00deSbyhmYGpoYmZpYGppZmxkjivZ0FH
 opBAemJJanZqakFqEUwfEwenVAOTbcVLziRN27crviYpx0vqvRLgnqgxp1ly0YR3HTvkPm4W
 7lWZka+1tuXTj7VX/YrXOoa+TY00P5hRqs6vYblgDWty5cuuMG2pL29K71/JOflZJmSf0Q9B
 xmIT/QJ/vi2dc1Nfli1dKhK8vbq779LUw7/nLrNaXlL8XHjf5s2bw8T29S6YkqUrbG3H8CnD
 /bz0XemOjZkScz76RbAqFTx6ekJzqcSVv3LC53uc9N+bdr79Wjjrz4e+C273Z70987WmtyDp
 2HOL9n+7A4Qk99z/pXK3cAfno/orvzXvMZS4RDee1o89snN98JtZWTaT9h2b+5ahpfKFk2vJ
 g/cnua7wqfP+vpPx4V3cu4sXzrczKrEUZyQaajEXFScCALp6AFFnAwAA
X-CMS-MailID: 20220912082216eucas1p1d3068e7578a88007515c2f4f5ebcc2a8
X-Msg-Generator: CA
X-RootMTR: 20220912082216eucas1p1d3068e7578a88007515c2f4f5ebcc2a8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082216eucas1p1d3068e7578a88007515c2f4f5ebcc2a8
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082216eucas1p1d3068e7578a88007515c2f4f5ebcc2a8@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v13 09/13] dm-zone: use generic helpers to
 calculate offset from zone start
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use the bdev_offset_from_zone_start() helper function to calculate
the offset from zone start instead of using power of 2 based
calculation.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-zone.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 3dafc0e8b7a9..ac6fc1293d41 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -390,7 +390,8 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE:
 		/* Writes must be aligned to the zone write pointer */
-		if ((clone->bi_iter.bi_sector & (zsectors - 1)) != zwp_offset)
+		if (bdev_offset_from_zone_start(md->disk->part0,
+						clone->bi_iter.bi_sector) != zwp_offset)
 			return false;
 		break;
 	case REQ_OP_ZONE_APPEND:
@@ -602,11 +603,8 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
 		 */
 		if (clone->bi_status == BLK_STS_OK &&
 		    bio_op(clone) == REQ_OP_ZONE_APPEND) {
-			sector_t mask =
-				(sector_t)bdev_zone_sectors(disk->part0) - 1;
-
 			orig_bio->bi_iter.bi_sector +=
-				clone->bi_iter.bi_sector & mask;
+				bdev_offset_from_zone_start(disk->part0, clone->bi_iter.bi_sector);
 		}
 
 		return;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

