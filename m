Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25359C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-0-9q3yAmPkWmcWz15lNW4A-1; Fri, 29 Apr 2022 04:23:46 -0400
X-MC-Unique: 0-9q3yAmPkWmcWz15lNW4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E20E51014A75;
	Fri, 29 Apr 2022 08:23:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CB81540869CE;
	Fri, 29 Apr 2022 08:23:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9E9561947B83;
	Fri, 29 Apr 2022 08:23:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD3711947042
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:12:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B83F1463E02; Wed, 27 Apr 2022 16:12:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B3D36416146
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:12:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CA9A801E80
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:12:23 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-nqEHND0QMkyt3ecwPvnySA-1; Wed, 27 Apr 2022 12:12:21 -0400
X-MC-Unique: nqEHND0QMkyt3ecwPvnySA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160313euoutp01a7fbabe047b436550296c38ed8959b62~pzFKLw2hZ0898208982euoutp01E
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:03:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220427160313euoutp01a7fbabe047b436550296c38ed8959b62~pzFKLw2hZ0898208982euoutp01E
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160311eucas1p292a05a97a5799178d307b83156d7614c~pzFInhDTQ0627806278eucas1p2B;
 Wed, 27 Apr 2022 16:03:11 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 46.14.09887.F3969626; Wed, 27
 Apr 2022 17:03:11 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220427160311eucas1p151141fc73adc590b40ad6f935b1ac214~pzFIDq05j2685026850eucas1p1l;
 Wed, 27 Apr 2022 16:03:11 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220427160311eusmtrp19ad138dbf7fe61a8204739883754e403~pzFICnC7Y2142221422eusmtrp1I;
 Wed, 27 Apr 2022 16:03:11 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-66-6269693f394f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id F9.A7.09404.E3969626; Wed, 27
 Apr 2022 17:03:10 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160310eusmtip1f0d4275814b6fa6855728a90524835ba~pzFHtPgBm1783517835eusmtip1O;
 Wed, 27 Apr 2022 16:03:10 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:53 +0200
Message-Id: <20220427160255.300418-15-p.raghav@samsung.com>
In-Reply-To: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0xTVxzOuef2tnSrXKqZZ8iyUbYs8hIfM2dCxtgjXjcz56Jm0S1Q4QKd
 BVkLc5vJVsZjwoA+HKhtNx3hJTBbaWGWVwhDqmCl4yEgAeRRHciACXsQpq7drZn/fd/3+77f
 d37JEUDxBcpfIEtNZxWpUrmEEpINnSvXw6JlssMRhrsB2NTVCXHNqJrCJYsrEHcXOwisU5/m
 41VHD8Qt8wYedv6dSeDhNhuBz9dcJvC0SQ9xQdsiie/nj7m17AmI/5nYjHXtNwB2DegJ3HIz
 BPdOVfFxb+lO3NxylcR9jUYKn61w8bEm9w+IhzQugLV2Cw8vlWfz8YW7CyS+cnPDq88wff1v
 Mw+u1FKMNmuez/SMXSSZPkcGU1edRzE/qIohYyn7kmk6t0QwTcMqiinMmqcYW844j1loHaCY
 Ims1YEzWAZLRWC7y3hUfFEYlsHLZJ6xi0ytxwmR9jgGmTT/5af7iHhW4JcwHPgJEb0P25hGQ
 D4QCMV0F0NySy0uWAbpudvI4sgRQ22A/9SgyMvo9xQ0qAWpwLXrJDECFtTX8fCAQUHQwyszj
 e/R19BBAWrOZ8BBIz0LktA4SnlVr6f1IvWDkezBJv4AmS8ZJT1hER6LVzBiu7Vl0pvev/3b6
 uGXNvfc9soj2Q1fPTJMeDN2WrHoD9KxHdLkQdU1e5nHZN5C6fgxyeC2atVv5HA5A3ScLSA4f
 R66hVW84GyC1zUR5ypC7rOia3AMhvRGZGjdx9hg0XjAIOccaNPSbH/eENUjXcMori9CJXDHn
 liDbyrS3FKG+r4zeUgYNnzAQGhCof+wY/WPH6P/vPQdgNVjPZihTkljlllT2WLhSmqLMSE0K
 jz+aUgfcX7r7gX35Eqic/T28HRAC0A6QAErWiZabkg+LRQnSzz5nFUdjFRlyVtkONghIyXpR
 vMwsFdNJ0nT2CMumsYpHU0Lg468ishfnfCMqYk5Flh3acYw4GMvL2Tb28M3nf/w1pEQVNzzX
 fMeQbh8N3eV8qZc3c+DQvedeL9+nfahzRvPf2R4+aiwITe7v8A0+re/YutvRa90SPev6uWhi
 pz12qmdk5sWQRPOB2+aBRPvGnBu7nBOWJ1oDS32PNObWyW//cqd//uOG4qDK9rDIn3I+CMr1
 N1effe/+7FP74lt9dLjRFhVhvKayde6teuu77KEEXn1YkJ9oIr4UEfDb2K3irCILO3Up7tYX
 Fefj7DVpNsq4P/Q1eeBHe3oKd3fUlk1KC4dt30BHRGJASODTsj8TurZH7/gQxxRrm7XHv9Ys
 kFEv750LrqzPM1ESUpks3RwMFUrpv+/LY11BBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t/xu7p2mZlJBv1PLC3WnzrGbLH6bj+b
 xbQPP5ktTk89y2QxqX8Gu8Xvs+eZLfa+m81qceFHI5PFzQM7mSxWrj7KZPFk/Sxmi54DH1gs
 /nbdA4q1PGS2+PPQ0GLSoWuMFk+vzmKy2HtL2+LS4xXsFpcWuVvs2XuSxeLyrjlsFvOXPWW3
 mND2ldnixoSnjBYTj29mtfi8tIXdYt3r9ywWJ25JO8h6XL7i7fHvxBo2j4nN79g9zt/byOJx
 +Wypx6ZVnWweCxumMntsXlLvsXvBZyaP3Tcb2Dx6m9+xeexsvc/q8X7fVTaPvi2rGD3Wb7nK
 4jFh80bWAKEoPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQi
 fbsEvYxZrbOZC57wVHR98G9gfMDVxcjJISFgInH77jy2LkYuDiGBpYwSJ7tmM0EkJCRuL2xi
 hLCFJf5c64Iqes4osb/5KVARBwebgJZEYyc7SFxE4AmjxP2fj1lAHGaBBhaJWxN3gU0SFgiW
 +LPzKBuIzSKgKvFo2n0WkGZeAWuJ342OEAvkJWZe+s4OEuYECk/4FAESFhKwkuhedIsVxOYV
 EJQ4OfMJC4jNDFTevHU28wRGgVlIUrOQpBYwMq1iFEktLc5Nzy020itOzC0uzUvXS87P3cQI
 TCfbjv3csoNx5auPeocYmTgYDzFKcDArifB+2Z2RJMSbklhZlVqUH19UmpNafIjRFOjqicxS
 osn5wISWVxJvaGZgamhiZmlgamlmrCTO61nQkSgkkJ5YkpqdmlqQWgTTx8TBKdXAtKfn//y8
 /uJTqw+fsrirF7fqvdE3B42bVc5X82SyOFT4M+SP8m91/mrY9/Op6sbdO7sm9t4Qil4s5l64
 UmnjntXTbM+9vnze5eQnkfKyjZe3WIQ6uu6W7n5zuWRW6Zk/0yY1/dzU4c2w3CHMiE9swo5M
 qbDrLy683XZWfZnuqSkfFjPfbdsX9UdRRcGIX0/0BluZX/cZH44VwilTVV/8XL2uMrruopIx
 n5SOldf0VV4NNxPT5N8uMLtUGvdAZV7Q5CXmL5tqtI4FxFZkXdozjeHW1Ec9ezUOf5y1xlgn
 oszwi7JpXoxPnErd79RHPCqd9y6Ub47n91vsUL9gT9S9tpsMUVwXt6vuE+jTrzslqcRSnJFo
 qMVcVJwIAAeEaE6wAwAA
X-CMS-MailID: 20220427160311eucas1p151141fc73adc590b40ad6f935b1ac214
X-Msg-Generator: CA
X-RootMTR: 20220427160311eucas1p151141fc73adc590b40ad6f935b1ac214
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160311eucas1p151141fc73adc590b40ad6f935b1ac214
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160311eucas1p151141fc73adc590b40ad6f935b1ac214@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 14/16] f2fs: call bdev_zone_sectors() only once
 on init_blkz_info()
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
Cc: jiangbo.365@bytedance.com, Pankaj Raghav <p.raghav@samsung.com>,
 kch@nvidia.com, bvanassche@acm.org, matias.bjorling@wdc.com,
 gost.dev@samsung.com, chao@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, clm@fb.com, dm-devel@redhat.com, agk@redhat.com,
 jonathan.derrick@linux.dev, kbusch@kernel.org, linux-fsdevel@vger.kernel.org,
 josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Luis Chamberlain <mcgrof@kernel.org>

Instead of calling bdev_zone_sectors() multiple times, call
it once and cache the value locally. This will make the
subsequent change easier to read.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/f2fs/super.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ea939db18f88..f64761a15df7 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3678,22 +3678,25 @@ static int init_blkz_info(struct f2fs_sb_info *sbi, int devi)
 	struct block_device *bdev = FDEV(devi).bdev;
 	sector_t nr_sectors = bdev_nr_sectors(bdev);
 	struct f2fs_report_zones_args rep_zone_arg;
+	u64 zone_sectors;
 	int ret;
 
 	if (!f2fs_sb_has_blkzoned(sbi))
 		return 0;
 
+	zone_sectors = bdev_zone_sectors(bdev);
+
 	if (sbi->blocks_per_blkz && sbi->blocks_per_blkz !=
-				SECTOR_TO_BLOCK(bdev_zone_sectors(bdev)))
+				SECTOR_TO_BLOCK(zone_sectors))
 		return -EINVAL;
-	sbi->blocks_per_blkz = SECTOR_TO_BLOCK(bdev_zone_sectors(bdev));
+	sbi->blocks_per_blkz = SECTOR_TO_BLOCK(zone_sectors);
 	if (sbi->log_blocks_per_blkz && sbi->log_blocks_per_blkz !=
 				__ilog2_u32(sbi->blocks_per_blkz))
 		return -EINVAL;
 	sbi->log_blocks_per_blkz = __ilog2_u32(sbi->blocks_per_blkz);
 	FDEV(devi).nr_blkz = SECTOR_TO_BLOCK(nr_sectors) >>
 					sbi->log_blocks_per_blkz;
-	if (nr_sectors & (bdev_zone_sectors(bdev) - 1))
+	if (nr_sectors & (zone_sectors - 1))
 		FDEV(devi).nr_blkz++;
 
 	FDEV(devi).blkz_seq = f2fs_kvzalloc(sbi,
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

