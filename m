Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC2DC6FA92
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954594;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/VXyBC6QdKAq8CiLZOby21Lpqc50en7oFlJzhK18bJg=;
	b=cLafvyffQGCrnuisvq/WVJvW7DMGPkQKT+wIrXkTJ+L++gHDBqoxNjC79IAFfc9JvgG72z
	RNnEx1u0I1kxStiP8V5+SbzAEAEQEUBD0WrpRoVQOOgHOU7aYOveWOi8KxlMGH4P18YJ61
	HDROlRXetQyRHyAE9Vl2IcOut5RiKQ0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-YncS21ZNNj-6E_P87hUSdQ-1; Fri, 23 Sep 2022 13:36:33 -0400
X-MC-Unique: YncS21ZNNj-6E_P87hUSdQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B13552A5955F;
	Fri, 23 Sep 2022 17:36:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9C5D42166B3A;
	Fri, 23 Sep 2022 17:36:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D7DD1946A69;
	Fri, 23 Sep 2022 17:36:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 058E01946A42
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E55C8C2C7E6; Fri, 23 Sep 2022 17:36:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DCA43C1908D
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BFF0101AA66
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:29 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-NYOkqH5cNLqA4KieihX8rQ-1; Fri, 23 Sep 2022 13:36:27 -0400
X-MC-Unique: NYOkqH5cNLqA4KieihX8rQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173626euoutp0140f876711180afd974fd60ccd92b7c87~XjeFb7tn70811408114euoutp01D
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220923173626euoutp0140f876711180afd974fd60ccd92b7c87~XjeFb7tn70811408114euoutp01D
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220923173624eucas1p124d177f51605fdd5ff20a56fdf4a5e6e~XjeED-fJ41388713887eucas1p1H;
 Fri, 23 Sep 2022 17:36:24 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 0E.1F.07817.89EED236; Fri, 23
 Sep 2022 18:36:24 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220923173624eucas1p19e66d02c7f4dfd2da262b783ef440156~XjeDPe51o2513525135eucas1p1m;
 Fri, 23 Sep 2022 17:36:24 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220923173624eusmtrp147e2adcc7be4eb596a31187364ac334d~XjeDOs_pK1032310323eusmtrp1Z;
 Fri, 23 Sep 2022 17:36:24 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-31-632dee98985b
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 4A.78.07473.79EED236; Fri, 23
 Sep 2022 18:36:23 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173623eusmtip12f2393400a2a9a78b1f929849cc53f4c~XjeC49z4q0836708367eusmtip1S;
 Fri, 23 Sep 2022 17:36:23 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:09 +0200
Message-Id: <20220923173618.6899-5-p.raghav@samsung.com>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7djP87oz3ukmG9zZaGix/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZPr85isth7S9vi
 8q45bBbzlz1lt5jQ9pXZ4saEp4wWn5e2sFusufmUxeLELWkHYY/LV7w9ds66y+5x+Wypx6ZV
 nWwem5fUe+y+2cDm0dv8js1jZ+t9Vo/3+66yefRtWcXosfl0tcfnTXIe7Qe6mQJ4o7hsUlJz
 MstSi/TtErgyVmy/wVzwh7/i5/sOlgbGi7xdjJwcEgImEpumHWTpYuTiEBJYwShxvGkSK4Tz
 hVFi2rOl7BDOZ0aJmVOmsMK0TOs7AlW1HKjq1UpmCOclo8TeJX+AhnFwsAloSTR2soM0iAik
 SxzfehNsErPANmaJ3d/mMYIkhAUiJeY332UGsVkEVCVe7P8F1sArYCHRfnMqC8Q2eYmZl76z
 g8zkFLCU6G+sgSgRlDg58wlYCTNQSfPW2WA3SAjs55R4t2IhE0Svi0Tr/rmMELawxKvjW9gh
 bBmJ05N7oOZXSzy98RuquYVRon/nejaQZRIC1hJ9Z3JATGYBTYn1u/Qhoo4S66/KQZh8Ejfe
 CkJcwCcxadt0Zogwr0RHmxDEbCWJnT+fQO2UkLjcNAdqp4fExwXHWCcwKs5C8sssJL/MQli7
 gJF5FaN4amlxbnpqsVFearlecWJucWleul5yfu4mRmCKPP3v+JcdjMtffdQ7xMjEwXiIUYKD
 WUmEN+WibrIQb0piZVVqUX58UWlOavEhRmkOFiVxXrYZWslCAumJJanZqakFqUUwWSYOTqkG
 ps3iR9sLtp9epjQvb2+cRX7rrQ3r+PNq++JDu3qemhYo8R9d8rh40sys57Nfbla3kt7u/61O
 RDBIrcZu9gSuGRtW7Mk67bn8W4+b+D6zV4sYJdzNWt6smGO7RSlJSGvtmZ7zd15NYpQSyjMO
 fy94YmsU2+rKzcbuxQtr629WbhXbYClQ3nBm8YaJP7smLXwnJ3TP/H5u9YRgcVml3Gkz618s
 a/eba/DhN4/l8wfnAzqjN9W93xh+hMONPX29+gTB85tcdEM9jjClf5/Ve+ytw79Hyz2VNlf3
 56uGxnq46b12Zr6naeHpJ+UVcVj7iovuhYo3L+Mnf23Tszun+FbssdvRueUTAtc1tqUWP7a4
 ocRSnJFoqMVcVJwIADTSLSgABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t/xu7rT3+kmG8ydY2Gx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZPr85isth7S9vi
 8q45bBbzlz1lt5jQ9pXZ4saEp4wWn5e2sFusufmUxeLELWkHYY/LV7w9ds66y+5x+Wypx6ZV
 nWwem5fUe+y+2cDm0dv8js1jZ+t9Vo/3+66yefRtWcXosfl0tcfnTXIe7Qe6mQJ4o/RsivJL
 S1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQyVmy/wVzwh7/i
 5/sOlgbGi7xdjJwcEgImEtP6jrB2MXJxCAksZZQ4sfc2I0RCQuL2wiYoW1jiz7UuNoii54wS
 R25uAHI4ONgEtCQaO9lBakQEciWOrb0HNohZ4BizxNRJV1lAEsIC4RKX/p4BK2IRUJV4sf8X
 mM0rYCHRfnMqC8QCeYmZl76zg8zkFLCU6G+sAQkLAZWcX/wIqlxQ4uTMJ2DlzEDlzVtnM09g
 FJiFJDULSWoBI9MqRpHU0uLc9NxiQ73ixNzi0rx0veT83E2MwHjeduzn5h2M81591DvEyMTB
 eIhRgoNZSYQ35aJushBvSmJlVWpRfnxRaU5q8SFGU6CzJzJLiSbnAxNKXkm8oZmBqaGJmaWB
 qaWZsZI4r2dBR6KQQHpiSWp2ampBahFMHxMHp1QDU3VZT9aq8zd7Ms7WJ3guyvi4cb6d6Iac
 1PjXPAk7fiR/6XtUf9lMunbDiV8pfRvkJAzPZ0+KsXt6xffMzMWhd+QnnfhYzMfysibzuUTX
 DCW5e42XBc7wLFu3UDAgPrpGzpZbfe+i1My5FzmEdj3evrGkTu3JXuWD3I9PvJjX4xo2f57S
 Tt4u7015BXOPCGslHIpwfpvpaXNRO+SFhmvHzj12XxWfsAg4Mgu3v5/13Oiuo+UnnTvsX7I/
 5bItcdr6b+emJ/FVkmulojlDzF3mfOA85/D9UnF/wxzLoxUznzzt/995Q0hZ29OR/8a33oXV
 pu/Yt294lqg8O3h39WcXZ/MLWV3BC8zTXK9OXv38pBJLcUaioRZzUXEiAKzNENtwAwAA
X-CMS-MailID: 20220923173624eucas1p19e66d02c7f4dfd2da262b783ef440156
X-Msg-Generator: CA
X-RootMTR: 20220923173624eucas1p19e66d02c7f4dfd2da262b783ef440156
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173624eucas1p19e66d02c7f4dfd2da262b783ef440156
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173624eucas1p19e66d02c7f4dfd2da262b783ef440156@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v15 04/13] nvmet: Allow ZNS target to support
 non-power_of_2 zone sizes
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
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A generic bdev_zone_no() helper is added to calculate zone number for a
given sector in a block device. This helper internally uses disk_zone_no()
to find the zone number.

Use the helper bdev_zone_no() to calculate nr of zones. This let's us
make modifications to the math if needed in one place and adds now
support for zoned devices with non po2 zone size.

Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/target/zns.c | 3 +--
 include/linux/blkdev.h    | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 835bfda86fcf..1c5352295db1 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -254,8 +254,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
 {
 	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
 
-	return bdev_nr_zones(req->ns->bdev) -
-		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
+	return bdev_nr_zones(req->ns->bdev) - bdev_zone_no(req->ns->bdev, sect);
 }
 
 static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e29799076298..5cf34ccd3e12 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1340,6 +1340,11 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
 	return BLK_ZONED_NONE;
 }
 
+static inline unsigned int bdev_zone_no(struct block_device *bdev, sector_t sec)
+{
+	return disk_zone_no(bdev->bd_disk, sec);
+}
+
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

