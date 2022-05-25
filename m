Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B34C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 15:53:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-5GFfZUMQP0SCQob8YmQq5g-1; Wed, 25 May 2022 11:53:13 -0400
X-MC-Unique: 5GFfZUMQP0SCQob8YmQq5g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B90218A075A;
	Wed, 25 May 2022 15:53:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 010462026985;
	Wed, 25 May 2022 15:53:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D0E33194EB8F;
	Wed, 25 May 2022 15:53:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8BE52194EB82
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 May 2022 15:50:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 819631410DDB; Wed, 25 May 2022 15:50:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D5CB1410DD7
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60D74101AA45
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:11 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-4MVvaLXrP46AVEZUofrOsg-1; Wed, 25 May 2022 11:50:09 -0400
X-MC-Unique: 4MVvaLXrP46AVEZUofrOsg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220525155008euoutp02f8a8d7433af5ccf73e2e9f6d7e58317f~yY9uecatP0354103541euoutp02I
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220525155008euoutp02f8a8d7433af5ccf73e2e9f6d7e58317f~yY9uecatP0354103541euoutp02I
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220525155006eucas1p25e379a605989f2868fe409b6d38b5770~yY9sn03cL0972109721eucas1p2D;
 Wed, 25 May 2022 15:50:06 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 1E.FF.10260.D205E826; Wed, 25
 May 2022 16:50:05 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220525155005eucas1p13b6204e84c2dbb1eeefc2645f69b45b0~yY9sEOdl30753307533eucas1p1B;
 Wed, 25 May 2022 15:50:05 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220525155005eusmtrp26fe67e51229f9b2089d16589ed66dcba~yY9r8yWtC0177001770eusmtrp2a;
 Wed, 25 May 2022 15:50:05 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-df-628e502d8a2e
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 02.9E.09404.D205E826; Wed, 25
 May 2022 16:50:05 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220525155005eusmtip1df0cbeb827b7d66b92087133b328f4fd~yY9rmhWrY1837618376eusmtip1C;
 Wed, 25 May 2022 15:50:05 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, snitzer@redhat.com,
 Johannes.Thumshirn@wdc.com, hch@lst.de, hare@suse.de
Date: Wed, 25 May 2022 17:49:54 +0200
Message-Id: <20220525154957.393656-6-p.raghav@samsung.com>
In-Reply-To: <20220525154957.393656-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7djPc7q6AX1JBt2nbSxW3+1ns/h99jyz
 xd53s1ktLvxoZLK4eWAnk8WeRZOYLFauPspk8WT9LGaLngMfWCz+dt1jsth7S9vi8q45bBbz
 lz1lt7gx4SmjxeelLewWbRu/MjoIePw7sYbN4/LZUo9NqzrZPDYvqffYfbOBzWNn631Wj/f7
 rrJ59G1ZxeixfstVFo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlbH4yWfWgpu6FbvW
 zWduYFyi0sXIySEhYCLxa8561i5GLg4hgRWMEl0v1jNCOF8YJY63z2ODcD4zStxtf84O0/Jx
 +i1miMRyRonte/9B9b9glDj0bxpQPwcHm4CWRGMnO0hcRKCRUWLqyxNgc5kFZjNJzPs2mRFk
 lLCAi8TB73dZQGwWAVWJw7eXsYHYvAJWEksfvmGEWCcvMfPSd7DVnALWEvP3f2aGqBGUODnz
 CVgvM1BN89bZYCdJCKzmlLh5cx4TRLOLxPH+r6wQtrDEq+NboH6Qkfi/cz5UTbXE0xu/oZpb
 GCX6d65nA3lBAmhb35kcEJNZQFNi/S59iHJHic0bb7BAVPBJ3HgrCHECn8SkbdOZIcK8Eh1t
 QhDVShI7fz6BWiohcblpDlSnh8Tfn4YTGBVnIfllFpJfZiGsXcDIvIpRPLW0ODc9tdg4L7Vc
 rzgxt7g0L10vOT93EyMwBZ7+d/zrDsYVrz7qHWJk4mA8xCjBwawkwnvhaW+SEG9KYmVValF+
 fFFpTmrxIUZpDhYlcd7kzA2JQgLpiSWp2ampBalFMFkmDk6pBqYFpttLLbu1367kuf+98Y+C
 W8/v1dEiRmbe99PW9n6X6LRg3zf5wsSJRb3ej+48r/YROn808Ly0zs8bt08IqnOEN92aZxab
 HtgjWDH32eVDT2vEg+5nTWluK407r1zBn6ITIGz0Ni7rYbydFne96K0tEcInWFZ9+W6pKKjU
 0/VueQHf/clG8qlrj5pr7tV2DGPcd1XrCre6t1if/hr91ZeetFW8q1q9MP1CkJLMw1PX5pwU
 LzrmJKJ8xIt99/qlTguLChS/Cp969ehj1cG39QfjJaxWCDuxN87dutKhYpFmXd785VtX20jy
 t8WeX5jfzxX//o9q/gIjiWkPanmENGa8Kdz/e67UlTM/Thxxv63EUpyRaKjFXFScCACcfwXO
 8AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xu7q6AX1JBjvfClisvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbnFjwlNGi89LW9gt2jZ+ZXQQ8Ph3Yg2bx+WzpR6bVnWyeWxeUu+x+2YDm8fO1vusHu/3
 XWXz6NuyitFj/ZarLB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina0MJIz9DSQs/I
 xFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2Pxk8+sBTd1K3atm8/cwLhEpYuRk0NCwETi4/Rb
 zF2MXBxCAksZJTp3z2aFSEhI3F7YxAhhC0v8udbFBlH0jFHixaKn7F2MHBxsAloSjZ3sIHER
 gU5GiTn7WsEcZoHlTBLPPy1iBukWFnCROPj9LguIzSKgKnH49jI2EJtXwEpi6cM3UBvkJWZe
 +s4OYnMKWEvM3/8ZrFcIqObrna+sEPWCEidnPgGbwwxU37x1NvMERoFZSFKzkKQWMDKtYhRJ
 LS3OTc8tNtIrTswtLs1L10vOz93ECIzXbcd+btnBuPLVR71DjEwcjIcYJTiYlUR4LzztTRLi
 TUmsrEotyo8vKs1JLT7EaAp090RmKdHkfGDCyCuJNzQzMDU0MbM0MLU0M1YS5/Us6EgUEkhP
 LEnNTk0tSC2C6WPi4JRqYMrqDJt4y4nrcNWM63aH2twFNm6fy6suI+OZVezLrfz3yGMG7oYn
 vEUBTZmNa7a7H1Wa1uKx5vDGr7kfj6y+Gu/FbvhGJrT86A+Ft28mPpsuKb/1p8W/xq1zvCbx
 zXaxW7qAca7mtuXfU9xnHJ5s+md/4vfJmwyunZ0SNbXzUH1LREr4Se+b9oluzerckt5LnLel
 zrrw3CLRqm1hFOfOlwK1UzeVtmw3q6lQZnD91N6Zupb/zNOejPyD9XfdFk+1vVkhPfXcp45v
 dfyf9mmkzZE/EJF8i6W/bAOHcZaOpe9vI56UQOXkqElz34owb9ZNWcKWdyOE8UTBv+lmDKuN
 kpL42hLiHYs4tfg6nQX2KrEUZyQaajEXFScCAOAQ9QRgAwAA
X-CMS-MailID: 20220525155005eucas1p13b6204e84c2dbb1eeefc2645f69b45b0
X-Msg-Generator: CA
X-RootMTR: 20220525155005eucas1p13b6204e84c2dbb1eeefc2645f69b45b0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220525155005eucas1p13b6204e84c2dbb1eeefc2645f69b45b0
References: <20220525154957.393656-1-p.raghav@samsung.com>
 <CGME20220525155005eucas1p13b6204e84c2dbb1eeefc2645f69b45b0@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v6 5/8] null_blk: allow non power of 2 zoned
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
 drivers/block/null_blk/zoned.c | 13 ++++++-------
 2 files changed, 8 insertions(+), 10 deletions(-)

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
index dae54dd1aeac..b79091b5e4b1 100644
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
@@ -83,8 +82,8 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
 	dev_capacity_sects = mb_to_sects(dev->size);
 	dev->zone_size_sects = mb_to_sects(dev->zone_size);
-	dev->nr_zones = round_up(dev_capacity_sects, dev->zone_size_sects)
-		>> ilog2(dev->zone_size_sects);
+	dev->nr_zones =	DIV_ROUND_UP_SECTOR_T(dev_capacity_sects,
+					      dev->zone_size_sects);
 
 	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct nullb_zone),
 				    GFP_KERNEL | __GFP_ZERO);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

