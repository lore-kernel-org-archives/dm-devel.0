Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48242C3DA7A
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 08:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672994436;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RPUjXoy/I4wmstxi8pEcNi2ISwWmXasYElj7VOoSvcs=;
	b=gb967DLbaPDJ+Oi99zeucAehux+huKHtr2PxVFI3Acw5+mSunP+QH2ItR9FDczeHwQt4eU
	2PLC4Gz3CcwIYQQLn/d108KhvzP8ZqTQN+FuPJ4+yxkVq+3RSgnPtnbA8yOPX3XScngnNs
	GU6SdcPda1rZpKe7Uft7uHLqdbfUJFQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-RQYj5yZWPpeOUS9sN1zNYQ-1; Fri, 06 Jan 2023 03:40:34 -0500
X-MC-Unique: RQYj5yZWPpeOUS9sN1zNYQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D65A1100F905;
	Fri,  6 Jan 2023 08:40:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5111175A2;
	Fri,  6 Jan 2023 08:40:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5D89B1946A6E;
	Fri,  6 Jan 2023 08:40:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 76FED194658D
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 67C3B4014EBE; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F92240C945A
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 358B3381078E
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-CZbhfdr-Ml2NgpjG0LyB4w-1; Fri, 06 Jan 2023 03:40:26 -0500
X-MC-Unique: CZbhfdr-Ml2NgpjG0LyB4w-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20230106083324euoutp013910222dff8eb9e638ad8731c88b1273~3qy7IZXLj2179921799euoutp01m
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:33:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20230106083324euoutp013910222dff8eb9e638ad8731c88b1273~3qy7IZXLj2179921799euoutp01m
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20230106083322eucas1p2971716b1ceb1cf2f5b90a0b696f8ac40~3qy51-6_o2329223292eucas1p2b;
 Fri,  6 Jan 2023 08:33:22 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id E7.43.43884.2DCD7B36; Fri,  6
 Jan 2023 08:33:22 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20230106083322eucas1p2414f1f7f121fbbd7a0e5e1b1b622f5c0~3qy5cK3zL2329223292eucas1p2a;
 Fri,  6 Jan 2023 08:33:22 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230106083322eusmtrp14b2b106c1afd8945ed5347acbbf4cd5e~3qy5bgmoU2166121661eusmtrp1k;
 Fri,  6 Jan 2023 08:33:22 +0000 (GMT)
X-AuditID: cbfec7f5-25bff7000000ab6c-49-63b7dcd2ee91
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 0A.C6.23420.2DCD7B36; Fri,  6
 Jan 2023 08:33:22 +0000 (GMT)
Received: from localhost (unknown [106.210.248.66]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230106083321eusmtip292f5234c8251a10cc76fbb993a2024c1~3qy5MIvO82941329413eusmtip2E;
 Fri,  6 Jan 2023 08:33:21 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk
Date: Fri,  6 Jan 2023 09:33:15 +0100
Message-Id: <20230106083317.93938-6-p.raghav@samsung.com>
In-Reply-To: <20230106083317.93938-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7djP87qX7mxPNjj1U9Zi9d1+NotpH34y
 W/w+e57ZYu+72awWNw/sZLLYs2gSk8XK1UeZLP523WOyOPPyM4vF3lvaFpd3zWGzmL/sKbvF
 jQlPGS0+L21htzhxS9qB3+PyFW+Py2dLPTat6mTz2Lyk3mP3zQY2j52t91k9zq509Hi/7yqb
 R9+WVYwem09Xe3zeJOfRfqCbKYAnissmJTUnsyy1SN8ugSvjQutMloL9vBXrby5namCcyt3F
 yMkhIWAicWzBSZYuRi4OIYEVjBKLTq5lgnC+MEqsP3oWKvOZUeLA1O3MMC0diw5AJZYzShw7
 28kM4bxglDj5/T5jFyMHB5uAlkRjJztIg4iAsMT+jlawBmaBHmaJ3Xc+M4EkhAV8JLp/bWQE
 sVkEVCXm3LzPAmLzClhK3L2+BmqbvMTMS9/BBnEKWEk8n76GCaJGUOLkzCdg9cxANc1bZ4Md
 ISEwm1PiwJrT7BDNLhJtU9sZIWxhiVfHt0DFZSROT+5hgbCrJZ7e+A3V3MIo0b9zPRvIBxIC
 1hJ9Z3JATGYBTYn1u/Qhyh0l1ixexQJRwSdx460gxAl8EpO2TWeGCPNKdLQJQVQrSez8+QRq
 qYTE5aY5UEs9JP53LWGawKg4C8kzs5A8Mwth7wJG5lWM4qmlxbnpqcXGeanlesWJucWleel6
 yfm5mxiBKe/0v+NfdzCuePVR7xAjEwfjIUYJDmYlEd6y/m3JQrwpiZVVqUX58UWlOanFhxil
 OViUxHlnbJ2fLCSQnliSmp2aWpBaBJNl4uCUamDS6Smd2XLy7OXvL+bWmtp7z1Pc0L4pauuH
 P1cnRE5vPH9qQvCDQ7FXMwy0dk+e9sfsCpvp0vpNe9rqlA9GC7D7tVuV7fTbefCRTvyLtwxL
 p9j9NinRWxX0OOZOn8+a6KB+DeZfRw+tX3CyXf/Rsj2fJz/dOiMk7Ef9VON7z0I3cK790fU9
 nDWVs8khzVbr5dXlrj+marLcnH9vD699j4pbS1lU952is2d97DbXzLQvPFTnOddZ6WPBUdtX
 9Q+3x6r8U9oRF8xSl3ZP2kXr6GHTlOaKCfXJT8JYTGT80ny/5W9Z+PiAUPELrozPxyvySi/3
 NCxyvHX1Sc3d1/UzZbZcfrzy5bPzDGvyfmX+2MTyW4mlOCPRUIu5qDgRAG4MpdjoAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t/xe7qX7mxPNmg9xmKx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLmwd2MlnsWTSJyWLl6qNMFn+77jFZnHn5mcVi7y1ti8u75rBZzF/2lN3i
 xoSnjBafl7awW5y4Je3A73H5irfH5bOlHptWdbJ5bF5S77H7ZgObx87W+6weZ1c6erzfd5XN
 o2/LKkaPzaerPT5vkvNoP9DNFMATpWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtl
 ZKqkb2eTkpqTWZZapG+XoJdxoXUmS8F+3or1N5czNTBO5e5i5OSQEDCR6Fh0gKWLkYtDSGAp
 o0T3rzvMEAkJidsLmxghbGGJP9e62CCKnjFKvN79GyjBwcEmoCXR2MkOUiMCVLO/oxVsELPA
 HGaJk5tngg0SFvABGroRbBCLgKrEnJv3WUBsXgFLibvX10Atk5eYeek72CBOASuJ59PXMIHY
 QkA1HR972SDqBSVOznwC1ssMVN+8dTbzBEaBWUhSs5CkFjAyrWIUSS0tzk3PLTbUK07MLS7N
 S9dLzs/dxAiMzm3Hfm7ewTjv1Ue9Q4xMHIyHGCU4mJVEeMv6tyUL8aYkVlalFuXHF5XmpBYf
 YjQFunsis5Rocj4wPeSVxBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBK
 NTB1mdzP3lr/US1n1otJEhdWGUZsWTqFyz/m0BmZjxMenuqex//nC1tAN1PP9Xr2dVWXbz7S
 VZzopTgtz/1qxfTl6dOeadce77H4JDY78roph1LTG4GMGVb3jJTeMwmGrH99t/70/MUW95xs
 0i6aMqrE8245FJiT0rPER3dn7T/33UteHbp24FeGQMj/V59UwljNEjZ0quzPuDy3+or6jkf7
 fBfHunfdNN9SceIP76Nd9788i81Xq1hs4G4437Rix/rHVypKmRkSLrJc90qPv7ja69XLrDxx
 yUlX7tu2G0Vb3TOpj+qpmrUjXDYmRerm+ozQs7dPfeVeWKuYOev3Nq/paV6PO/7UN5aUuB49
 Ny9DiaU4I9FQi7moOBEAFX/yu1cDAAA=
X-CMS-MailID: 20230106083322eucas1p2414f1f7f121fbbd7a0e5e1b1b622f5c0
X-Msg-Generator: CA
X-RootMTR: 20230106083322eucas1p2414f1f7f121fbbd7a0e5e1b1b622f5c0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230106083322eucas1p2414f1f7f121fbbd7a0e5e1b1b622f5c0
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083322eucas1p2414f1f7f121fbbd7a0e5e1b1b622f5c0@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 5/7] dm-zoned: ensure only power of 2 zone sizes
 are allowed
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
 gost.dev@samsung.com, damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, hch@lst.de,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

