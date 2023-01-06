Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48DACC3DA7A
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 08:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672994552;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=h0dygxCHkDWhcyRrEQjivZ77LYSr9O6/je0z1yqqYfQ=;
	b=QxR0gMmSSFkgmWSDmLmipkalhjt8k2okQ56BsRGFbcd40vnFB28G8NgRnG633EK1NKEuXy
	x84g6gxz6wEBU4O33UscjKKvw2U954gH/KVQGzniRjhEcChq7riJ188mutnFJ1oq/NOjlj
	QIyMzRJQxbFpPogf8NXy8WjPlMfr+fk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-HGW3Vyx9MUGmd8x1k1bLAg-1; Fri, 06 Jan 2023 03:42:31 -0500
X-MC-Unique: HGW3Vyx9MUGmd8x1k1bLAg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33F4585A588;
	Fri,  6 Jan 2023 08:42:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 203C253A0;
	Fri,  6 Jan 2023 08:42:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D18AB194658D;
	Fri,  6 Jan 2023 08:42:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7BF6F1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 08:42:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6989C2026D68; Fri,  6 Jan 2023 08:42:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6186F2026D4B
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:42:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 417E51C05EBB
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:42:27 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-vNmSvg5nMpGV9dnPlE7rBg-1; Fri, 06 Jan 2023 03:42:25 -0500
X-MC-Unique: vNmSvg5nMpGV9dnPlE7rBg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20230106083324euoutp02a26ad846e981bc732e0cb6adfd136c54~3qy7uK6mh2146821468euoutp02l
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:33:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20230106083324euoutp02a26ad846e981bc732e0cb6adfd136c54~3qy7uK6mh2146821468euoutp02l
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20230106083323eucas1p1a65f5682e8176e747042a06939916e1c~3qy6Zaafa1079910799eucas1p1N;
 Fri,  6 Jan 2023 08:33:23 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 50.A3.56180.3DCD7B36; Fri,  6
 Jan 2023 08:33:23 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20230106083322eucas1p1ce3ca7b02ca87bb2be8543291e223338~3qy6AgovI1079910799eucas1p1M;
 Fri,  6 Jan 2023 08:33:22 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230106083322eusmtrp2ce6bf037b828e56c769e14ab7c11768d~3qy5-wgci1128211282eusmtrp2E;
 Fri,  6 Jan 2023 08:33:22 +0000 (GMT)
X-AuditID: cbfec7f2-ab5ff7000000db74-a2-63b7dcd32d2f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id FD.AB.52424.2DCD7B36; Fri,  6
 Jan 2023 08:33:22 +0000 (GMT)
Received: from localhost (unknown [106.210.248.66]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230106083322eusmtip1c280cca29120352af56f70ae80405570~3qy50uWRv0965409654eusmtip1b;
 Fri,  6 Jan 2023 08:33:22 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk
Date: Fri,  6 Jan 2023 09:33:16 +0100
Message-Id: <20230106083317.93938-7-p.raghav@samsung.com>
In-Reply-To: <20230106083317.93938-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsWy7djPc7qX72xPNvjwidNi9d1+NotpH34y
 W/w+e57ZYu+72awWNw/sZLLYs2gSk8XK1UeZLP523WOyOPPyM4vF3lvaFpd3zWGzmL/sKbvF
 jQlPGS0+L21htzhxS9qB3+PyFW+Py2dLPTat6mTz2Lyk3mP3zQY2j52t91k9zq509Hi/7yqb
 R9+WVYwem09Xe3zeJOfRfqCbKYAnissmJTUnsyy1SN8ugSvj+ZFnTAUTeSquzl7H2sDYzdXF
 yMkhIWAicf9FO1sXIxeHkMAKRoln656zQzhfGCX6ll1ihHA+M0o03ZvIBNPyqfs4E0RiOaNE
 Q89CKOcFo8Sjf5OB+jk42AS0JBo72UEaRASEJfZ3tLKA1DAL9DBLvF/wgxkkISwQLnF7xxYW
 EJtFQFVixsyTrCA2r4ClxK1pk5ghtslLzLz0HWwQp4CVxPPpa5ggagQlTs58AtbLDFTTvHU2
 VP1iTolJTZ4QtovE092PWSBsYYlXx7ewQ9gyEv93zof6plri6Y3fzCDHSQi0MEr071zPBvKA
 hIC1RN+ZHBCTWUBTYv0ufYioo8SSbeUQJp/EjbeCEAfwSUzaNp0ZIswr0dEmBDFbSWLnzydQ
 OyUkLjfNgbrFQ2Lb1FfsExgVZyF5ZRaSV2YhrF3AyLyKUTy1tDg3PbXYMC+1XK84Mbe4NC9d
 Lzk/dxMjMN2d/nf80w7Gua8+6h1iZOJgPMQowcGsJMJb1r8tWYg3JbGyKrUoP76oNCe1+BCj
 NAeLkjjvjK3zk4UE0hNLUrNTUwtSi2CyTBycUg1MCtdCDr/O2nvFKniZUEbj/aKtKUV99Te2
 xrydHFDNGtVtOqvroCZrYzmP9xl+m/xV0zaKnt8ZJKZUqtb+UDwuV0frSSb755N2Jd/sr2cy
 ya/+YGC3JnLv/dNr3z36XPEqO+3frlfZixY+2HrDYm1n4fEHdzf8f+fwIIuTY+eOWpYIu8uH
 QuRbjh6qf75sRunk/bapsY8abuz4+OXtP7+I0OcvTs58s+34LKZCpWdsb6P+vzq1qlkm0siy
 +8LRORyzN2+o+XfHqPvvk8JQD1f97U+Wfldiy/Py2yj7+tsf+4Wqtvsf8uc6RglGnrowMfzs
 k5Xb1TS8RO7/+FnT/0Lz+mINwfdp3GrMOrGZu/38OpVYijMSDbWYi4oTAV+xnYXmAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t/xu7qX7mxPNrixWtdi9d1+NotpH34y
 W/w+e57ZYu+72awWNw/sZLLYs2gSk8XK1UeZLP523WOyOPPyM4vF3lvaFpd3zWGzmL/sKbvF
 jQlPGS0+L21htzhxS9qB3+PyFW+Py2dLPTat6mTz2Lyk3mP3zQY2j52t91k9zq509Hi/7yqb
 R9+WVYwem09Xe3zeJOfRfqCbKYAnSs+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbK
 yFRJ384mJTUnsyy1SN8uQS/j+ZFnTAUTeSquzl7H2sDYzdXFyMkhIWAi8an7OFMXIxeHkMBS
 RomLd2azQyQkJG4vbGKEsIUl/lzrYgOxhQSeMUos2ZPWxcjBwSagJdHYCVYuAlSyv6OVBWQO
 s8AcZomp66axgCSEBUIlDrz9DTaHRUBVYsbMk6wgNq+ApcStaZOYIebLS8y89B1sEKeAlcTz
 6WuYIHZZSnR87GWDqBeUODnzCdhMZqD65q2zmScwCsxCkpqFJLWAkWkVo0hqaXFuem6xkV5x
 Ym5xaV66XnJ+7iZGYGxuO/Zzyw7Gla8+6h1iZOJgPMQowcGsJMJb1r8tWYg3JbGyKrUoP76o
 NCe1+BCjKdDdE5mlRJPzgckhryTe0MzA1NDEzNLA1NLMWEmc17OgI1FIID2xJDU7NbUgtQim
 j4mDU6qBSXBea9OfVXM/ll56GbnRkEfp2+Vqr6VvhGQmTnwxN0e91m5x5mK5xbcFbD4uOmfH
 dX3OW182RuHV8ZPu8iTIbLE8ztXyVayoW+7Jnw8/HnEnC686cTq09r1G9dLY/rqHNhu1u1TW
 Ve+P5lF6sPL5kuuPA0vK1z2aukTymn3mw/gbuvfbeXZxv4/QtTpifefdK91IcYPAaduW9vp9
 EuFY4eLdL7z7SNieFfMNuaTfP9nyyjjI7cyee+f5btRE2ul9cT0qeolb/J8716tzbmvvB680
 /HhlWwxzfuAOsf+9at+uzWaTcPMR+X9yi5rV5ccrr4b0shRd+MagoGX5psXj64PEyF6e25Wl
 yxpmf/j25ZISS3FGoqEWc1FxIgBd2zqqVgMAAA==
X-CMS-MailID: 20230106083322eucas1p1ce3ca7b02ca87bb2be8543291e223338
X-Msg-Generator: CA
X-RootMTR: 20230106083322eucas1p1ce3ca7b02ca87bb2be8543291e223338
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230106083322eucas1p1ce3ca7b02ca87bb2be8543291e223338
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083322eucas1p1ce3ca7b02ca87bb2be8543291e223338@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 6/7] dm-zone: use generic helpers to calculate
 offset from zone start
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

Use the bdev_offset_from_zone_start() helper function to calculate
the offset from zone start instead of open coding.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

