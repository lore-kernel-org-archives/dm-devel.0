Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D62FBC32792
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 12:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661257164;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rgvopmXBEvYht7XblqKfbSgfG+on1UaJYKgqMzl/HuY=;
	b=in/FjlPPRZRF4v0DmvEL0jqr5Gvw2pQTv3LvMUikBH/d6T7gRhIMqY24X/Afzm56CPBUau
	MKMLRKU13LzSipSDYs3VWrpp1tuJIdK8S20Rf3INSiFy1qS8zU3m21RXkITL/VYTagEz68
	z71olHyxV5kuAv1jYBkfqOhY0o9WKyM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-tF_rh7sNOym0v6j6YEg29w-1; Tue, 23 Aug 2022 08:19:22 -0400
X-MC-Unique: tF_rh7sNOym0v6j6YEg29w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30AD6802533;
	Tue, 23 Aug 2022 12:19:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1C40F40D2831;
	Tue, 23 Aug 2022 12:19:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 03F161946A5B;
	Tue, 23 Aug 2022 12:19:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D387B1946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 12:19:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C69FE1121319; Tue, 23 Aug 2022 12:19:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C350B1121315
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD76080231E
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:18 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-j3LhfnEkNiWSv3XvGZGkWA-1; Tue, 23 Aug 2022 08:19:15 -0400
X-MC-Unique: j3LhfnEkNiWSv3XvGZGkWA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220823121913euoutp028fcbbcce6b7497f0c9476c1963d8a9c3~N_JRoVCvy2228922289euoutp02G
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220823121913euoutp028fcbbcce6b7497f0c9476c1963d8a9c3~N_JRoVCvy2228922289euoutp02G
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220823121911eucas1p26e219dbed47a96dc011f86fd44abc605~N_JPm1vMJ2020620206eucas1p2X;
 Tue, 23 Aug 2022 12:19:11 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 00.81.07817.FB5C4036; Tue, 23
 Aug 2022 13:19:11 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220823121911eucas1p2a55dec72a6d780123e6c7655aee72457~N_JPEV8ZX2414724147eucas1p2S;
 Tue, 23 Aug 2022 12:19:11 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220823121911eusmtrp2afea96fe5b8dcf30d79ea00d23578530~N_JPDk_xU2723427234eusmtrp2i;
 Tue, 23 Aug 2022 12:19:11 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-6c-6304c5bfed2e
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id B8.12.07473.EB5C4036; Tue, 23
 Aug 2022 13:19:10 +0100 (BST)
Received: from localhost (unknown [106.210.248.52]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220823121910eusmtip123314f6a15e89198c1d6e2955b763163~N_JOvE2mn0871108711eusmtip1s;
 Tue, 23 Aug 2022 12:19:10 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 23 Aug 2022 14:18:55 +0200
Message-Id: <20220823121859.163903-10-p.raghav@samsung.com>
In-Reply-To: <20220823121859.163903-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsWy7djPc7r7j7IkG0yepmax/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCeKyyYlNSezLLVI3y6BK2PZ
 4W/MBR3cFVffKzUw9nJ2MXJwSAiYSOxeyNXFyMUhJLCCUaJ740o2COcLo0Tj4x9MEM5nRok3
 1/4CZTjBOnreHGSFSCxnlHi2cxszhPOCUWLGlr2sIHPZBLQkGjvZQRpEBNIlvn7dwAhiMwvc
 YZL4dj0XxBYWiJVY8KGTFcRmEVCVuHLmDhtIK6+AtcSvezIQu+QlZl76DjaGEyg8b+kpsDG8
 AoISJ2c+YYEYKS/RvHU2M0T9dk6J5X+zIGwXiZ6+ZVBxYYlXx7ewQ9gyEv93zmeCsKslnt74
 DXa+hEALo0T/zvVskGCxlug7kwNiMgtoSqzfpQ9R7iixv386I0QFn8SNt4IQF/BJTNo2nRki
 zCvR0SYEUa0ksfPnE6ilEhKXm+awQNgeEjNXbmGfwKg4C8kvs5D8Mgth7wJG5lWM4qmlxbnp
 qcVGeanlesWJucWleel6yfm5mxiBifD0v+NfdjAuf/VR7xAjEwfjIUYJDmYlEd7qiwzJQrwp
 iZVVqUX58UWlOanFhxilOViUxHmTMzckCgmkJ5akZqemFqQWwWSZODilGph4MqSuWOZE1qh/
 Ej6qp1DAarq32jjx0+dMib5/FrGvL91M8cn+8zP/5VHjaVP6hZbsPH9qvkzFl/o/3ev6J9VO
 uiW4cOJtV6Edy6awdC8ymq4Q1W94+n5FUdHE/vPGv2LO2h8/lujg8F+IPf3pn7gXfIsYttxb
 vjTq3w72tQf+lrCnCuXXHmR+Yqf1YPZDz6CatAnWqmHcm+3nFwmurzVmq+g8ab985da3XH+t
 lm761Xva9LvOpnOHemaqqxiF7ug9cHyO08T4Gwz9G6QUXltKHK2xrVBv+B24d5Fkp4hRsGFU
 w119h1VnLs4LtiqvPmlmyqDvcW9Zgabs+aUtc09/+srZZvPAaWXj57Kcj6ZKLMUZiYZazEXF
 iQCVl+tz8wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t/xu7r7jrIkG6xrsbVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl7Hs8Dfmgg7uiqvvlRoYezm7GDk5
 JARMJHreHGTtYuTiEBJYyijx+HIHI0RCQuL2wiYoW1jiz7UuNoiiZ4wS+w7sYepi5OBgE9CS
 aOxkB6kREciVOLx5AhNIDbPAGyaJo/9aWEESwgLREl9fX2UBsVkEVCWunLnDBtLLK2At8eue
 DMR8eYmZl76DzeEECs9begpsr5CAlcT8W5/YQGxeAUGJkzOfgI1hBqpv3jqbeQKjwCwkqVlI
 UgsYmVYxiqSWFuem5xYb6hUn5haX5qXrJefnbmIERu62Yz8372Cc9+qj3iFGJg7GQ4wSHMxK
 IrzVFxmShXhTEiurUovy44tKc1KLDzGaAp09kVlKNDkfmDrySuINzQxMDU3MLA1MLc2MlcR5
 PQs6EoUE0hNLUrNTUwtSi2D6mDg4pRqY1BvPSf2NmpW9buOHB/tX9Wg9tTbf8Wsx16SOjJiX
 LRdOK3P8KHX+7/9gIdtVxxBuV/1Q/oI7DzeGxgTfWK6t90nTgFuomzPeZEGUzYMjFx+GuYqt
 clpYW+mmtE6SZZuIQFppzkuVqRVXWYp+v7/KlHeyT4lt35Y1AR82Fq1jc/+3IvvY7+nLnp1u
 fpDI2cWtPXX16vAjcw8lXstQKXi8/Lze18h/7qXpHBn3HT1rloU8/HTc3+1+O8PSfWXnLi1J
 46yqSzt3lv3i5p7nndNL5ja9ljCrWR060yZx35a2XafXG4j9vFM/P1TuUPTyt2eU6xfaLw++
 1Gs4ZcsOTY339vvWdHpPnfihVUfXv3p1mxJLcUaioRZzUXEiADrLlrllAwAA
X-CMS-MailID: 20220823121911eucas1p2a55dec72a6d780123e6c7655aee72457
X-Msg-Generator: CA
X-RootMTR: 20220823121911eucas1p2a55dec72a6d780123e6c7655aee72457
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121911eucas1p2a55dec72a6d780123e6c7655aee72457
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121911eucas1p2a55dec72a6d780123e6c7655aee72457@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v12 09/13] dm-zone: use generic helpers to
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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

