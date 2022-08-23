Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13F98C32772
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 12:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661257155;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6RZsm9Z0aI+d2x0ZJCGqfSlNbphX3h1kHVaRONg2a4E=;
	b=EY3m3OQQe8ndtUBz1g5RJaUTIYoeI6qjNHq0UK4zMrF79ku8IM/8TVfdomufOYN+hL0mz5
	FteVef2ayazo2qaMqnDXS9hMmA9w4nELWFvXv+gPbozai9ktqx3BmpvcgenbIwXeKeT+ad
	RFuklzrsh0T8akHnoDXvrlhHMEmKVoo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-7dUjRHQhMV-Y7Xe2xpI6oA-1; Tue, 23 Aug 2022 08:19:14 -0400
X-MC-Unique: 7dUjRHQhMV-Y7Xe2xpI6oA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23FF71019E1D;
	Tue, 23 Aug 2022 12:19:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BC2342166B29;
	Tue, 23 Aug 2022 12:19:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3D8161946A60;
	Tue, 23 Aug 2022 12:19:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 67CF11946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 12:19:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B82B492CA4; Tue, 23 Aug 2022 12:19:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 474D3492C3B
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 302248032F1
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:08 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-GxY3m7N7OC6VIQFyEzh2bw-1; Tue, 23 Aug 2022 08:19:06 -0400
X-MC-Unique: GxY3m7N7OC6VIQFyEzh2bw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220823121905euoutp016b02498a888db79f8e45e95ca53c13ab~N_JJtksKa1598215982euoutp01b
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220823121905euoutp016b02498a888db79f8e45e95ca53c13ab~N_JJtksKa1598215982euoutp01b
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220823121903eucas1p22311fd0c7e7894838285e8fa895ecb24~N_JHw-kQW2413924139eucas1p2h;
 Tue, 23 Aug 2022 12:19:03 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 54.82.29727.7B5C4036; Tue, 23
 Aug 2022 13:19:03 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220823121902eucas1p21176f8fff1a4f928bee6e03141cdf69a~N_JGxAtzq2017520175eucas1p2c;
 Tue, 23 Aug 2022 12:19:02 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220823121902eusmtrp15e4721a9aee4988894600e9acf4800ba~N_JGu9gxN1042010420eusmtrp1x;
 Tue, 23 Aug 2022 12:19:02 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-6e-6304c5b763dd
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id FB.71.10862.6B5C4036; Tue, 23
 Aug 2022 13:19:02 +0100 (BST)
Received: from localhost (unknown [106.210.248.52]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220823121901eusmtip1435b20acbbbd983cb29e65ca921d4ca3~N_JGYtfun0901809018eusmtip1D;
 Tue, 23 Aug 2022 12:19:01 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 23 Aug 2022 14:18:47 +0200
Message-Id: <20220823121859.163903-2-p.raghav@samsung.com>
In-Reply-To: <20220823121859.163903-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsWy7djPc7rbj7IkG8x/zm0x/bCixfpTx5gt
 Vt/tZ7OY9uEns8Xvs+eZLfa+m81qcfPATiaLPYsmMVmsXH2UyeLJ+lnMFn+77jFZ7L2lbXF5
 1xw2i/nLnrJbTGj7ymxxY8JTRovPS1vYLdbcfMpiceKWtIOwx+Ur3h47Z91l97h8ttRj06pO
 No/NS+o9dt9sYPPY2Xqf1eP9vqtsHn1bVjF6bD5d7fF5k5xH+4FupgCeKC6blNSczLLUIn27
 BK6Mv1PbmQquilQ8m/CKrYFxlmAXIyeHhICJRNPO2axdjFwcQgIrGCUe/d7PBuF8YZRYt6wN
 yvnMKLFo5RRWmJbFK88ygdhCAssZJS5OcYUoesEo8aflB1CCg4NNQEuisZMdpEZEIF3i69cN
 jCA1zAJdzBJL/x5hA6kRFkiSWL5GHaSGRUBV4tHy18wgYV4BK4mn8x0hVslLzLz0HWwMp4C1
 xLylpxhBbF4BQYmTM5+wgNjMQDXNW2czg4yXENjPKbFy2wk2iGYXiZedvSwQtrDEq+Nb2CFs
 GYnTk3ug4tUST2/8hmpuYZTo37ke7DYJoG19Z3JATGYBTYn1u/Qhyh0lVv88BlXBJ3HjrSDE
 CXwSk7ZNZ4YI80p0tAlBVCtJ7Pz5BGqphMTlpjlQSz0kjly/yjKBUXEWkmdmIXlmFsLeBYzM
 qxjFU0uLc9NTiw3zUsv1ihNzi0vz0vWS83M3MQKT4ul/xz/tYJz76qPeIUYmDsZDjBIczEoi
 vNUXGZKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8yZnbkgUEkhPLEnNTk0tSC2CyTJxcEo1MKXk
 cJ3ljt0bU8EheuWUl/l7p+PnHv2c8mTbkUntr8wZtxtP1llsLrGfIzJ/59+Td15zTgrQeX15
 3uPoo1dNps+rjuEXeKekEZN4avEN+c2H3wQFXXSZEtpw0GdN3fv3wTOji15N/7fSJNCtisOg
 /bXU9Ts3fkzl+LeQ40f/ZTHG4++CNp/3uDA/JenGy59dK3d+jQ8zdvx2/avpiSusdsI+xVNP
 rF1efGLHG+n8z7GG3pN6TJR7LkVM2H1M4+zq1u1tvMdavs2c6dz57NWKNTf2CKwyvD/xjdrl
 uLvelTkpGnq9qdW7Qzyvnwk+Mmd1SsOXnRuri4NezHtskytncW1C82zW1ZYn93a0Np9xUjHQ
 U2Ipzkg01GIuKk4EAPS5l9/5AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t/xu7rbjrIkG+x7yWox/bCixfpTx5gt
 Vt/tZ7OY9uEns8Xvs+eZLfa+m81qcfPATiaLPYsmMVmsXH2UyeLJ+lnMFn+77jFZ7L2lbXF5
 1xw2i/nLnrJbTGj7ymxxY8JTRovPS1vYLdbcfMpiceKWtIOwx+Ur3h47Z91l97h8ttRj06pO
 No/NS+o9dt9sYPPY2Xqf1eP9vqtsHn1bVjF6bD5d7fF5k5xH+4FupgCeKD2bovzSklSFjPzi
 ElulaEMLIz1DSws9IxNLPUNj81grI1MlfTublNSczLLUIn27BL2Mv1PbmQquilQ8m/CKrYFx
 lmAXIyeHhICJxOKVZ5lAbCGBpYwSl746QcQlJG4vbGKEsIUl/lzrYuti5AKqecYo0dZwlrmL
 kYODTUBLorGTHaRGRCBX4vDmCUwgNcwCs5gl/tyZygySEBZIkFjct5AFxGYRUJV4tPw1WC+v
 gJXE0/mOEPPlJWZe+g42h1PAWmLe0lOMEPdYScy/9YkNxOYVEJQ4OfMJ2BhmoPrmrbOZJzAK
 zEKSmoUktYCRaRWjSGppcW56brGRXnFibnFpXrpecn7uJkZgBG879nPLDsaVrz7qHWJk4mA8
 xCjBwawkwlt9kSFZiDclsbIqtSg/vqg0J7X4EKMp0NkTmaVEk/OBKSSvJN7QzMDU0MTM0sDU
 0sxYSZzXs6AjUUggPbEkNTs1tSC1CKaPiYNTqoGpr3+KmXJ7r9eDpV8PyPPueCe7QcPpMmPv
 4qzs60yhAtItjrYzoxbtNG0qOKwQt9Qm8rLN6dsHwha9FrbQcJqc/kY0gm87J+8u9R+Jxw1+
 fn4iPTOs3WE2/9PGivf9cppVHjk2q89/edesquqxseTtzk/Ts8573v13Z9LGCt5jpw9ltOpk
 OiqVit55c3r2I8NE3ez2MyvS1mekhbQ1rPyZwlh589InVb3Whfp3ffYZHyssFZsp8PWi3i+Z
 HS+e2iepTNyowLp2b/vRszoP41hWy3VdmDHbklH6/u9be87G/F/49PzZF9kip40dJpyJtpnT
 LMZaXRPySj3+KIf9OubNwRuUu5YGvnxeufnUm8kOSizFGYmGWsxFxYkAahUkaWkDAAA=
X-CMS-MailID: 20220823121902eucas1p21176f8fff1a4f928bee6e03141cdf69a
X-Msg-Generator: CA
X-RootMTR: 20220823121902eucas1p21176f8fff1a4f928bee6e03141cdf69a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121902eucas1p21176f8fff1a4f928bee6e03141cdf69a
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121902eucas1p21176f8fff1a4f928bee6e03141cdf69a@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v12 01/13] block: make bdev_nr_zones and
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Adam Manzanares <a.manzanares@samsung.com>,
 gost.dev@samsung.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
index 84b13fdd34a7..ab82d1ff0cce 100644
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

