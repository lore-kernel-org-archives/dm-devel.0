Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2C8FC07E9D
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954597;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IoskFOWEGXS/LC/7NJqutlW0Vr82wetlu9llxQXLYXg=;
	b=hdGNvM/sNhzrZ0+ow6TFq8gyYWAUd3xkqBrOErKHu6n0QIYZsfxdYexXQwPO53uOEOkNVg
	kL+fczHVeJHurkSsyA6efIpZKWGrr2yx/OkJMlwehBTKY2oAYPzYxwyGaFnNl/VxPPSGw6
	LFGMVRurSWYKkZsIbn7j3S6kp1EB8l4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-xLUW0shDOAGO9u4Fte5s5w-1; Fri, 23 Sep 2022 13:36:36 -0400
X-MC-Unique: xLUW0shDOAGO9u4Fte5s5w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2931C3C0F68D;
	Fri, 23 Sep 2022 17:36:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12CA7492B0A;
	Fri, 23 Sep 2022 17:36:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C12D819465B6;
	Fri, 23 Sep 2022 17:36:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5813319465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 498312028E94; Fri, 23 Sep 2022 17:36:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 41C862028E90
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 255FD3817A81
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:32 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-CUk1aU12P1GswJWOVwOV4w-1; Fri, 23 Sep 2022 13:36:28 -0400
X-MC-Unique: CUk1aU12P1GswJWOVwOV4w-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173627euoutp02e83b02255a8c9707af8373126acf4d29~XjeGpFytc3258632586euoutp02I
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220923173627euoutp02e83b02255a8c9707af8373126acf4d29~XjeGpFytc3258632586euoutp02I
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220923173626eucas1p14a42d378271d1f1b20c63d4e2ece95b7~XjeFX6r6v1387913879eucas1p1L;
 Fri, 23 Sep 2022 17:36:26 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 39.6E.29727.A9EED236; Fri, 23
 Sep 2022 18:36:26 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220923173625eucas1p147864849427469a90bf5c3ce547105c2~XjeESGm361387913879eucas1p1K;
 Fri, 23 Sep 2022 17:36:25 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220923173625eusmtrp2b90ea0b27e590d2a373b5b9888695cfb~XjeERTqeE1023410234eusmtrp27;
 Fri, 23 Sep 2022 17:36:25 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-2b-632dee9aaf7e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 28.5F.10862.99EED236; Fri, 23
 Sep 2022 18:36:25 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173624eusmtip20ec0a09d4506f5564a27ca09f4792c01~XjeD8LZje2337923379eusmtip2c;
 Fri, 23 Sep 2022 17:36:24 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:10 +0200
Message-Id: <20220923173618.6899-6-p.raghav@samsung.com>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsWy7djP87qz3ukmG+x5wWex/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZPr85isth7S9vi
 8q45bBbzlz1lt5jQ9pXZ4saEp4wWn5e2sFusufmUxeLELWkHYY/LV7w9ds66y+5x+Wypx6ZV
 nWwem5fUe+y+2cDm0dv8js1jZ+t9Vo/3+66yefRtWcXosfl0tcfnTXIe7Qe6mQJ4o7hsUlJz
 MstSi/TtErgyFj77wVrwTKTiyJxpTA2MywS7GDk5JARMJG4/ecHYxcjFISSwglGic/cqZgjn
 C6NE84HJrBDOZ0aJvlPrWGBadv/4yApiCwksZ5T4fikYouglo8Tfxl62LkYODjYBLYnGTnaQ
 GhGBdInjW2+yg9QwCzQzSyyft4gdpEZYIFri4xZ3kBoWAVWJhYtugs3nFbCQmP98GhPELnmJ
 mZe+g5VzClhK9DfWQJQISpyc+QSsnBmopHnrbLCjJQROcUpsbt3FBtHrIjGr+yk7hC0s8er4
 FihbRuL/zvlQ86slnt74DdXcwijRv3M92P0SAtYSfWdyQExmAU2J9bv0IcodJR6svsEMUcEn
 ceOtIMQJfBKTtk2HCvNKdLQJQVQrSez8+QRqqYTE5aY50AD0kJiy4xz7BEbFWUiemYXkmVkI
 excwMq9iFE8tLc5NTy02zEst1ytOzC0uzUvXS87P3cQITJCn/x3/tINx7quPeocYmTgYDzFK
 cDArifCmXNRNFuJNSaysSi3Kjy8qzUktPsQozcGiJM7LNkMrWUggPbEkNTs1tSC1CCbLxMEp
 1cCkNGuZE/OiPLabH+p3H3ol1HIguT2PZWnLlAVWH3qazm119DRJShHhlu5InPs6em/cNMvf
 Ny+vU9Fen8OT7FwtxB4stLvj3mcjObu8VSbbViwyjSyqtZnssu9Dv/hfBx/LzRP2pi5+8/lA
 KHfIwfgJT69VbnwjtnKj8ZMmjirpM4ejkm7rq1gxPSx6p76sfJPfydYNX3LbPh8Q33FD59up
 2C8CxhPdp07YV7GK/53ThvjO+66HXbrMjlTsP87+7dYBWflr8Qt9P+f88nh/zUM53vGHyTxG
 46bJGdzicrO/8Z58GsQ4wVnTQut19dRF95MMb+2p0lggHyd8aOG1psM9uttYeH8rvZu0mDeM
 z+elEktxRqKhFnNRcSIA0BbMk/8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t/xe7oz3+kmG3xuYbFYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9JounV2cxWey9pW1x
 edccNov5y56yW0xo+8pscWPCU0aLz0tb2C3W3HzKYnHilrSDsMflK94eO2fdZfe4fLbUY9Oq
 TjaPzUvqPXbfbGDz6G1+x+axs/U+q8f7fVfZPPq2rGL02Hy62uPzJjmP9gPdTAG8UXo2Rfml
 JakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZC5/9YC14JlJx
 ZM40pgbGZYJdjJwcEgImErt/fGTtYuTiEBJYyiixaMpbVoiEhMTthU2MELawxJ9rXWwQRc8Z
 JWa++8LcxcjBwSagJdHYyQ5SIyKQK3Fs7T2wQcwCk5klmu7/YAZJCAtESmxsWgFmswioSixc
 dJMFxOYVsJCY/3waE8QCeYmZl76zg8zkFLCU6G+sAQkLAZWcX/yIHaJcUOLkzCdgrcxA5c1b
 ZzNPYBSYhSQ1C0lqASPTKkaR1NLi3PTcYiO94sTc4tK8dL3k/NxNjMB43nbs55YdjCtffdQ7
 xMjEwXiIUYKDWUmEN+WibrIQb0piZVVqUX58UWlOavEhRlOgsycyS4km5wMTSl5JvKGZgamh
 iZmlgamlmbGSOK9nQUeikEB6YklqdmpqQWoRTB8TB6dUAxPD6+0Cf+5PZb+in/46+hTvCYO+
 NHfvFxLl1ovXSs3POc65Yr2y3MGds/6syyor4Nvu1bxvfpfSZmGzCJlTbT+2F0ZP2Ptsy79c
 w/VKq/JeOL5UErpSd8jz9CL3td6b+PcsPuX89UCUNmOEbUTQ1stLUy+9a/q36PjVi/b7Nx4q
 +PDn7qqGR79jlMTuzNFf+CRO01r4zCLdC103vCVTrxxdGGbGa5BiPvP9rVu7OvKiS545Lbmd
 mcBlcPlR3M4/U166Jxv3MibZtTjInoiZ1iNfuqUg4GaCz8wVLNcPMrMWN/I2yscusLqz+jTv
 5YkLufY/f+kSNPFnqnv846DvMy/d4z4/t+zEOo+6a8a35c+qKrEUZyQaajEXFScCAB5US4Jw
 AwAA
X-CMS-MailID: 20220923173625eucas1p147864849427469a90bf5c3ce547105c2
X-Msg-Generator: CA
X-RootMTR: 20220923173625eucas1p147864849427469a90bf5c3ce547105c2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173625eucas1p147864849427469a90bf5c3ce547105c2
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173625eucas1p147864849427469a90bf5c3ce547105c2@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v15 05/13] nvme: zns: Allow ZNS drives that have
 non-power_of_2 zone size
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, Johannes.Thumshirn@wdc.com,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove the condition which disallows non-power_of_2 zone size ZNS drive
to be updated and use generic method to calculate number of zones
instead of relying on log and shift based calculation on zone size.

The power_of_2 calculation has been replaced directly with generic
calculation without special handling. Both modified functions are not
used in hot paths, they are only used during initialization &
revalidation of the ZNS device.

As rounddown macro from math.h does not work for 32 bit architectures,
round down operation is open coded.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/host/zns.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 12316ab51bda..fe1d715d61cc 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -101,13 +101,6 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
 	}
 
 	ns->zsze = nvme_lba_to_sect(ns, le64_to_cpu(id->lbafe[lbaf].zsze));
-	if (!is_power_of_2(ns->zsze)) {
-		dev_warn(ns->ctrl->device,
-			"invalid zone size:%llu for namespace:%u\n",
-			ns->zsze, ns->head->ns_id);
-		status = -ENODEV;
-		goto free_data;
-	}
 
 	disk_set_zoned(ns->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
@@ -129,7 +122,7 @@ static void *nvme_zns_alloc_report_buffer(struct nvme_ns *ns,
 				   sizeof(struct nvme_zone_descriptor);
 
 	nr_zones = min_t(unsigned int, nr_zones,
-			 get_capacity(ns->disk) >> ilog2(ns->zsze));
+			 div64_u64(get_capacity(ns->disk), ns->zsze));
 
 	bufsize = sizeof(struct nvme_zone_report) +
 		nr_zones * sizeof(struct nvme_zone_descriptor);
@@ -182,6 +175,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	int ret, zone_idx = 0;
 	unsigned int nz, i;
 	size_t buflen;
+	u64 remainder = 0;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
 		return -EINVAL;
@@ -197,7 +191,9 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	c.zmr.zrasf = NVME_ZRASF_ZONE_REPORT_ALL;
 	c.zmr.pr = NVME_REPORT_ZONE_PARTIAL;
 
-	sector &= ~(ns->zsze - 1);
+	/* Round down the sector value to the nearest zone start */
+	div64_u64_rem(sector, ns->zsze, &remainder);
+	sector -= remainder;
 	while (zone_idx < nr_zones && sector < get_capacity(ns->disk)) {
 		memset(report, 0, buflen);
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

