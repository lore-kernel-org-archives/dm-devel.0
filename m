Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E80FEC19F2A
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 09:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659520100;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3qAieJW0OvX3BUM0nPw8CY0v1N/qAe5zs+EVgcZ4McM=;
	b=NzAizFALAGH7hcFoh7Bbg4AQSHjec3fnomDWQuYTMxaFFQU+YJ0DrgaCGtCRrAZEOO7eK6
	XWV1G+7X5gGhnjrcYZ6gXQH0PTjCxHd3IrMSriQSOzsCnuscWqbUaPi+4J2yAeOtn/swau
	434v0/LwLx3Gv4aFwunzYgRtYoCaUKo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-MjedjiPJM_2AH396FBr9SA-1; Wed, 03 Aug 2022 05:48:15 -0400
X-MC-Unique: MjedjiPJM_2AH396FBr9SA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BC9F3C0D852;
	Wed,  3 Aug 2022 09:48:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF744141510F;
	Wed,  3 Aug 2022 09:48:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D3C0C1946A5D;
	Wed,  3 Aug 2022 09:48:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F5671946A50
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 09:48:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 53DE340C1288; Wed,  3 Aug 2022 09:48:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5013B4010E37
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3736F185A794
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:12 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-XcexsLpvMXuZdph3oydNKQ-1; Wed, 03 Aug 2022 05:48:10 -0400
X-MC-Unique: XcexsLpvMXuZdph3oydNKQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220803094809euoutp02c30e1dff47ecae288585b7588bb447cb~HzLqGHtsn1892618926euoutp02h
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220803094809euoutp02c30e1dff47ecae288585b7588bb447cb~HzLqGHtsn1892618926euoutp02h
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220803094807eucas1p224884eb226c7b424aed2ee5802687c73~HzLonXeKL2470524705eucas1p2m;
 Wed,  3 Aug 2022 09:48:07 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id B3.FF.09664.7544AE26; Wed,  3
 Aug 2022 10:48:07 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220803094806eucas1p24e1fd0f3a595e050d79c4315559d97ae~HzLn-ja4E1528815288eucas1p2h;
 Wed,  3 Aug 2022 09:48:06 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220803094806eusmtrp1f74e4c3e6a78656816aba9457baeed04~HzLn_o3YC2000320003eusmtrp1Q;
 Wed,  3 Aug 2022 09:48:06 +0000 (GMT)
X-AuditID: cbfec7f2-d97ff700000025c0-81-62ea44573f19
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 53.9B.09038.6544AE26; Wed,  3
 Aug 2022 10:48:06 +0100 (BST)
Received: from localhost (unknown [106.210.248.112]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220803094806eusmtip10b1dba597f608a76d1a515ca1f44a551~HzLnqIBVq2267222672eusmtip1h;
 Wed,  3 Aug 2022 09:48:06 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes.Thumshirn@wdc.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, agk@redhat.com, hch@lst.de
Date: Wed,  3 Aug 2022 11:47:52 +0200
Message-Id: <20220803094801.177490-5-p.raghav@samsung.com>
In-Reply-To: <20220803094801.177490-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7djPc7rhLq+SDLr3K1qsP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFjcmPGW0+Ly0hd1izc2nLBYnbkk7CHlcvuLtsXPWXXaPy2dLPTat6mTz2Lyk
 3mP3zQY2j52t91k93u+7yubRt2UVo8fm09UenzfJebQf6GYK4InisklJzcksSy3St0vgyvg7
 +zxzwSn+iobHF5kbGJfwdjFyckgImEh8XbeOrYuRi0NIYAWjRNvPqcwQzhdGiQXrJ7GCVAkJ
 fGaUmPE3AKZjzaKpUB3LGSUuz//EDlH0klHiaaN9FyMHB5uAlkRjJztIjYhAM6PE3b89rCAO
 s8BHJolH2zcygRQJC0RIfDkhBNLLIqAqsXHrbSYQm1fASuLKpW9sEMvkJWZe+g42n1PAWmLK
 v3/MEDWCEidnPmEBsZmBapq3zga7WkJgO6fE3b2/WSCaXSTmL7/GCGELS7w6voUdwpaROD25
 B6qmWuLpjd9QzS2MEv0717OBHCcBtK3vTA6IySygKbF+lz5EuaPE9YPHWSAq+CRuvBWEOIFP
 YtK26cwQYV6JjjYhiGoliZ0/n0AtlZC43DQHaqmHxONJ7UwTGBVnIXlmFpJnZiHsXcDIvIpR
 PLW0ODc9tdgwL7Vcrzgxt7g0L10vOT93EyMwHZ7+d/zTDsa5rz7qHWJk4mA8xCjBwawkwnvH
 5XmSEG9KYmVValF+fFFpTmrxIUZpDhYlcd7kzA2JQgLpiSWp2ampBalFMFkmDk6pBqZpkjYM
 wUe6FRQNVgln/fraVflylbxolYW4RGfeJP7Ne+PnTwkRWdT85N+v9fXhsorO2XO/hnZW5F34
 drrq0d93Ae9fVMe79vD/zA1XOVhdrH1TTZ2nTlTS2OLRb1aOvosx636c/RizuWzBS9cJQiYh
 j13eJCrJ7tARsO3dLOQY9XLpp4niNk1/1jw53DC33pxh40eeXan/rRQ2Jdfq5QsGuPKI8H7w
 0BMQF7u7UPBD3ab1eZ908q3XH3EVP/eiUnErQ+vpxrs694+7vOY9vv6KlWv08o8CgibM62Oa
 p9+34gnuT76p7Pe/56po/WvObV0eV2dXPrVLMPXgNLXsq+K/67HWqu/j89uP49cyKrEUZyQa
 ajEXFScCAM/6kkf2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xu7phLq+SDFq2mlisP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFjcmPGW0+Ly0hd1izc2nLBYnbkk7CHlcvuLtsXPWXXaPy2dLPTat6mTz2Lyk
 3mP3zQY2j52t91k93u+7yubRt2UVo8fm09UenzfJebQf6GYK4InSsynKLy1JVcjILy6xVYo2
 tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy/g7+zxzwSn+iobHF5kbGJfwdjFy
 ckgImEisWTSVrYuRi0NIYCmjxNwlDcwQCQmJ2wubGCFsYYk/17qgip4zSkxdfwWoiIODTUBL
 orGTHSQuItDNKHH5zDlWkAZmgUZmiW+bSkFsYYEwic1bjoENZRFQldi49TYTiM0rYCVx5dI3
 NogF8hIzL31nB7E5Bawlpvz7B1YvBFSz7u8sVoh6QYmTM5+wQMyXl2jeOpt5AqPALCSpWUhS
 CxiZVjGKpJYW56bnFhvpFSfmFpfmpesl5+duYgRG77ZjP7fsYFz56qPeIUYmDsZDjBIczEoi
 vHdcnicJ8aYkVlalFuXHF5XmpBYfYjQFunsis5Rocj4wfeSVxBuaGZgamphZGphamhkrifN6
 FnQkCgmkJ5akZqemFqQWwfQxcXBKNTB53yqW52b7XGnK/jvFpjH79KblU49NqFkrd3sr/6fs
 I3nbd3PGp8V59zFMscixCfrynydv+oHqqtfyS4/pPrrct2uOSM8Gh2f+vX8ui802nPl+XXt0
 nxuT54/eW+xvGZ8l7Thm6lD2Sf4oW+Tn1en528QtKixj+tbn/OmZLRU3a+OBayE8i3ddinsr
 envCyZrKF0LeDfarU3hbps472vJJX563vX9CiN+vdeHKDu+uGGi/ntapZVjiYNdVnt920PPb
 BoGoXF3bRlbRX0mPBC3fH1y6xFvomPEEP+4NYnfXHzYrtjXoPvIh91/dFK8fYpVsjsWbfj48
 f/DIzUVq6w07ihXK7dbVPtghfXS7IZMSS3FGoqEWc1FxIgAwwu7wZwMAAA==
X-CMS-MailID: 20220803094806eucas1p24e1fd0f3a595e050d79c4315559d97ae
X-Msg-Generator: CA
X-RootMTR: 20220803094806eucas1p24e1fd0f3a595e050d79c4315559d97ae
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094806eucas1p24e1fd0f3a595e050d79c4315559d97ae
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094806eucas1p24e1fd0f3a595e050d79c4315559d97ae@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v9 04/13] nvmet: Allow ZNS target to support
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/target/zns.c | 3 +--
 include/linux/blkdev.h    | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index c7ef69f29fe4..662f1a92f39b 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -241,8 +241,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
 {
 	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
 
-	return bdev_nr_zones(req->ns->bdev) -
-		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
+	return bdev_nr_zones(req->ns->bdev) - bdev_zone_no(req->ns->bdev, sect);
 }
 
 static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5aa15172299d..ead848a15946 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1345,6 +1345,11 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
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

