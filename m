Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6603CC04A95
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954593;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=d971tQL1JyuTpbcPM1hJsol/Cf8AHYxwk5SLUPbduKI=;
	b=bFN4KIO7o5BkoM5FEYZbJQnuHNJ+2pMcgK+zBZOdKCeMbYVPUdQYh+ojf2hE/MR1be0V9k
	PDcBVQusHlRmvI3mxGXAzTCacTGDj78+5Vn18NiwGb7KDAROXuYRh6y/ztxZad4BaPZOfC
	+Ir8xqg50iVW6gfoV3qu8Ao5xBBFamE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96--VfxEpcRPo-Dekt3TjjuUg-1; Fri, 23 Sep 2022 13:36:31 -0400
X-MC-Unique: -VfxEpcRPo-Dekt3TjjuUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D82A885A583;
	Fri, 23 Sep 2022 17:36:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C4DA840C2086;
	Fri, 23 Sep 2022 17:36:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ABD1819465B7;
	Fri, 23 Sep 2022 17:36:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8901C19465B7
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E44840C206B; Fri, 23 Sep 2022 17:36:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 56D1240C2066
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37F5C3C0ED51
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:28 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-meKiLuzcOd6sdb-Z9xm0yQ-1; Fri, 23 Sep 2022 13:36:25 -0400
X-MC-Unique: meKiLuzcOd6sdb-Z9xm0yQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173623euoutp028879c8d9f4006353449a0f2d5a808d7c~XjeC5pQt53253832538euoutp02D
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220923173623euoutp028879c8d9f4006353449a0f2d5a808d7c~XjeC5pQt53253832538euoutp02D
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220923173621eucas1p17d30e53271c0a8d1a6f8cd3aef28ecc2~XjeA48gU12513525135eucas1p1k;
 Fri, 23 Sep 2022 17:36:21 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id DB.1F.07817.59EED236; Fri, 23
 Sep 2022 18:36:21 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220923173620eucas1p2ba21805261fe5ad86c38c0f52daeaa3a~XjeAXaocG2090220902eucas1p2f;
 Fri, 23 Sep 2022 17:36:20 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220923173620eusmtrp2d1dfa588e7f09e828991d9b888e7353a~XjeAWS-Vr1023410234eusmtrp23;
 Fri, 23 Sep 2022 17:36:20 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-29-632dee952942
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id E1.5F.10862.49EED236; Fri, 23
 Sep 2022 18:36:20 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173620eusmtip23695d8acf12f1f42b8f948364ae14283~Xjd-_-sLF2221022210eusmtip2b;
 Fri, 23 Sep 2022 17:36:20 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:06 +0200
Message-Id: <20220923173618.6899-2-p.raghav@samsung.com>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7djP87pT3+kmG0z8K2Ex/bCixfpTx5gt
 Vt/tZ7OY9uEns8Xvs+eZLfa+m81qcfPATiaLPYsmMVmsXH2UyeLJ+lnMFn+77jFZPL06i8li
 7y1ti8u75rBZzF/2lN1iQttXZosbE54yWnxe2sJusebmUxaLE7ekHUQ8Ll/x9tg56y67x+Wz
 pR6bVnWyeWxeUu+x+2YDm0dv8zs2j52t91k93u+7yubRt2UVo8fm09UenzfJebQf6GYK4I3i
 sklJzcksSy3St0vgyjh98yNLwVHRioWPV7A2MDYIdTFyckgImEjseH6drYuRi0NIYAWjxK2P
 c1khnC+MEt/Xb2WEcD4zSsw9uY0NpmXp7X0sEInljBLv/11lgnBeMkr8nbgYqJ+Dg01AS6Kx
 kx2kQUQgXeL41pvsIDXMAo+YJbbd+c0EkhAWSJJY+76NEcRmEVCVWPaljRnE5hWwkHj06iPU
 NnmJmZe+s4PM5BSwlOhvrIEoEZQ4OfMJC4jNDFTSvHU2M8h8CYFznBJzpzUwg9RLCLhIXO4o
 gxgjLPHq+BZ2CFtG4v/O+UwQdrXE0xu/oXpbGCX6d65ng+i1lug7kwNiMgtoSqzfpQ9R7iix
 Yns3I0QFn8SNt4IQF/BJTNo2HWopr0RHGzRwlSR2/nwCtVRC4nLTHBaIEg+JnWsDJzAqzkLy
 yiwkr8xCWLuAkXkVo3hqaXFuemqxUV5quV5xYm5xaV66XnJ+7iZGYKI8/e/4lx2My1991DvE
 yMTBeIhRgoNZSYQ35aJushBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFethlayUIC6YklqdmpqQWp
 RTBZJg5OqQamous8yazrJ6gnb2xx3RDm6bbPxzaiqEjqLcuG9sP2da52K04t/rjBsaKj+cHU
 ELXiJ1GODCbz7c8dfJrdVWbj++riN4V5ZtNj7F884Xr3V/j1/5K850m7w66IPm7+s6S3fKu0
 LWdxnWfUg64lHc+sH/+eqct8Y7qTCv/Rb6JbM5Ub51r/keQRSNhlqr/O2Dw2odY14PCiV6su
 XD41Qch566WZEkrOMdbvJOODXvlzXe78max2jz+Dc8HMk5M27y9e7OGxumnDws0v5B8Uvb7G
 nDCxNp7n899/O+9tLrunE7RjoZSI5c2LJddnc3FslNNLrdjBxXjQMHde9m2lGJmUXD09q909
 i1TX3Xe9+bBaiaU4I9FQi7moOBEAcv0nEQMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t/xe7pT3ukmG2z7b2gx/bCixfpTx5gt
 Vt/tZ7OY9uEns8Xvs+eZLfa+m81qcfPATiaLPYsmMVmsXH2UyeLJ+lnMFn+77jFZPL06i8li
 7y1ti8u75rBZzF/2lN1iQttXZosbE54yWnxe2sJusebmUxaLE7ekHUQ8Ll/x9tg56y67x+Wz
 pR6bVnWyeWxeUu+x+2YDm0dv8zs2j52t91k93u+7yubRt2UVo8fm09UenzfJebQf6GYK4I3S
 synKLy1JVcjILy6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQyzh98yNL
 wVHRioWPV7A2MDYIdTFyckgImEgsvb2PpYuRi0NIYCmjRPOqFjaIhITE7YVNjBC2sMSfa11s
 EEXPGSX2HPrF2sXIwcEmoCXR2MkOUiMikCtxbO09VpAaZoEvzBK7L21hBUkICyRI3Pi7lxnE
 ZhFQlVj2pQ3M5hWwkHj06iPUMnmJmZe+s4PM5BSwlOhvrAEJCwGVnF/8iB2iXFDi5MwnLCA2
 M1B589bZzBMYBWYhSc1CklrAyLSKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMK63Hfu5ZQfj
 ylcf9Q4xMnEwHmKU4GBWEuFNuaibLMSbklhZlVqUH19UmpNafIjRFOjsicxSosn5wMSSVxJv
 aGZgamhiZmlgamlmrCTO61nQkSgkkJ5YkpqdmlqQWgTTx8TBKdXApGBVE9AbM7VIKufo1csf
 Lp6JE9ZflLIvyOGewGoJKXuZWy+uJ//t1MhwW+zUwnZ4oW573X2v76fTZJ8YzVv4e1vCjWh/
 p9NBD6TPLHZ1v6Gxi71wd9kMJ4NI1pZGv8npDoIx34uSGIv0vvj+1MpmU72lnPFVuFLt7Z/8
 R3N1v6btjfJba7Iwv3S1l+Lcn5FrxVLk93hnmDgVa/w5ZZaQNyf6IvfE4LufdNVfss8veKHW
 NsnkW3rNW+mejMmrLwSe3H1d8D+bxJ+J3bet1bdvjNkhNEGns/6QQ4d8ZfmB2ao256aVF+d4
 JF88I274TqBiz3KTuoOS4ifYq7bxvWB85iDx89uyhI3HGfNmCgcosRRnJBpqMRcVJwIAhzAU
 vXQDAAA=
X-CMS-MailID: 20220923173620eucas1p2ba21805261fe5ad86c38c0f52daeaa3a
X-Msg-Generator: CA
X-RootMTR: 20220923173620eucas1p2ba21805261fe5ad86c38c0f52daeaa3a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173620eucas1p2ba21805261fe5ad86c38c0f52daeaa3a
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173620eucas1p2ba21805261fe5ad86c38c0f52daeaa3a@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v15 01/13] block: make bdev_nr_zones and
 disk_zone_no generic for npo2 zone size
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
 Adam Manzanares <a.manzanares@samsung.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Adapt bdev_nr_zones and disk_zone_no functions so that they can
also work for non-power-of-2 zone sizes.

As the existing deployments assume that a device zone size is a power of
2 number of sectors, power-of-2 optimized calculation is used for those
devices.

There are no direct hot paths modified and the changes just
introduce one new branch per call.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
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
index 8038c5fbde40..6c6bf4dd5709 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -674,9 +674,15 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
 
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

