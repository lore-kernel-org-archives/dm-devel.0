Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEDA9C07E9D
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954601;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jTjR+ZlQuiBEGgIyW0rFhICJ/hWgFHAdhiF4+pPITf8=;
	b=Tvea29mjWfFs/pVwQcBBJaSv0CqzwPU0R90R2PddBdyOU8YEjQsSzArPSk6VhT+SO2rC3M
	cXvpfXBTQW4IKPzZd/RPUnpUkYnv7R39z69Mct1ysWtzG7xS9jGTwZB3dUe8XSryG3hhng
	8oBoX4R30X9ouqCWu+ikrn6vbafS5vk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-H7Ady7slOHCF_9REL3iVCg-1; Fri, 23 Sep 2022 13:36:38 -0400
X-MC-Unique: H7Ady7slOHCF_9REL3iVCg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78559862FDC;
	Fri, 23 Sep 2022 17:36:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6511C40C6EC5;
	Fri, 23 Sep 2022 17:36:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5377719465A4;
	Fri, 23 Sep 2022 17:36:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB1B419465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DEBE617595; Fri, 23 Sep 2022 17:36:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D717817593
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B715F3817A86
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:34 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-maCODSBVNE-Onr4tK3prQQ-1; Fri, 23 Sep 2022 13:36:33 -0400
X-MC-Unique: maCODSBVNE-Onr4tK3prQQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173632euoutp02e6c7fe10bfaa66c6c8129fd34bef3d5f~XjeKvYjIx2660626606euoutp02R
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220923173632euoutp02e6c7fe10bfaa66c6c8129fd34bef3d5f~XjeKvYjIx2660626606euoutp02R
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220923173630eucas1p1a489121322cbc8d3112fd1dc005e72be~XjeJZVNTw2512925129eucas1p1p;
 Fri, 23 Sep 2022 17:36:30 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 2D.6E.29727.E9EED236; Fri, 23
 Sep 2022 18:36:30 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220923173629eucas1p27c1ebffb55c2f1a52fad913840b16d02~XjeIYpAeJ3127531275eucas1p2C;
 Fri, 23 Sep 2022 17:36:29 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220923173629eusmtrp2589da37c46d342f75699d90733786591~XjeIX5tQg1023410234eusmtrp29;
 Fri, 23 Sep 2022 17:36:29 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-34-632dee9e21e2
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 9A.5F.10862.D9EED236; Fri, 23
 Sep 2022 18:36:29 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173629eusmtip2de3703de13204c51bab5ebfcae6c9dff~XjeIEVREQ1628216282eusmtip2a;
 Fri, 23 Sep 2022 17:36:29 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:14 +0200
Message-Id: <20220923173618.6899-10-p.raghav@samsung.com>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsWy7djP87rz3ukmG7x4oWSx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCeKyyYlNSezLLVI3y6BK2Pd
 kSWsBSt5KnpXvWVuYJzH1cXIySEhYCLxbvJvli5GLg4hgRWMEo9/LGWFcL4wSsxY/4AZwvnM
 KPF+5ik2mJbnk64xQSSWM0rM6rsJ5bxklJjX9ACoioODTUBLorGTHaRBRCBd4vjWm2A2s0A/
 s8TtfbkgJcICsRIHX+eAhFkEVCU+LloPNp9XwFKiceoSVohd8hIzL31nBynnBIr3N9ZAlAhK
 nJz5hAViorxE89bZYHdKCGznlPj++DnUnS4SHVuuMkPYwhKvjm9hh7BlJP7vnM8EYVdLPL3x
 G6q5hVGif+d6sPMlBKwl+s7kgJjMApoS63fpQ5Q7SqyZNYUFooJP4sZbQYgT+CQmbZvODBHm
 lehoE4KoVpLY+fMJ1FIJictNc1ggbA+JKctfMU5gVJyF5JlZSJ6ZhbB3ASPzKkbx1NLi3PTU
 YsO81HK94sTc4tK8dL3k/NxNjMBkePrf8U87GOe++qh3iJGJg/EQowQHs5IIb8pF3WQh3pTE
 yqrUovz4otKc1OJDjNIcLErivGwztJKFBNITS1KzU1MLUotgskwcnFINTM072iOcoxY1+NgF
 L/F/IrX62BnHhvO7k0Ob7giX1kj9+yulk9l8YS5Lw0p93j9rt0TLbun2brpzT+H5gn1OG6T7
 1HWunxXasUG38HvU5YJG29yWudmVNcFK0rbrV4bye4d9EHLdW1I1yVJHJm7xccdYtemVWqEM
 oWbC01fPUdgqeUO9R/vSqwLNLdLTNnyr+XH3uIJymd2bKgZ23dSfybyZv56yu2krnkg31IhQ
 cc1RevPs2bQbwnpH1Wuyc+NOxK95F+8n4Pp35cZHVoULQgWZglqlky4c610go5TE+1Jkxdfk
 VlbX0t2h7BsqDLrYlc5P5RA6usbtUoK/UGP0ceZSB+Frup7NFddV2ZVYijMSDbWYi4oTAfG1
 05b1AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xe7pz3+kmGzx7J2ux/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina
 0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2PdkSWsBSt5KnpXvWVuYJzH1cXI
 ySEhYCLxfNI1pi5GLg4hgaWMEov3HGSCSEhI3F7YxAhhC0v8udbFBlH0nFHi3+N+1i5GDg42
 AS2Jxk52kBoRgVyJY2vvsYLUMAvMZ5b4OvkQG0hCWCBaYv2lmWCDWARUJT4uWg8W5xWwlGic
 uoQVYoG8xMxL39lBZnICxfsba0DCQgIWEucXP2KHKBeUODnzCQuIzQxU3rx1NvMERoFZSFKz
 kKQWMDKtYhRJLS3OTc8tNtIrTswtLs1L10vOz93ECIzdbcd+btnBuPLVR71DjEwcjIcYJTiY
 lUR4Uy7qJgvxpiRWVqUW5ccXleakFh9iNAU6eyKzlGhyPjB55JXEG5oZmBqamFkamFqaGSuJ
 83oWdCQKCaQnlqRmp6YWpBbB9DFxcEo1MDEk7ytmVecxkAk9ueicifybpGXH9xqtverd+qln
 i4Vn5pvFr2+pbS1vqVQp/mtzaLNMj+G8r28u+i5MbWXPUW9znTlpnYj4fTZfNTHtNI+kKQFz
 Cp5NN87xWX7UqiFPSK+nMVzI/7bqVkZ1kWVZnR/czr7Uf/dzYqdfyeXnH/OUxbPC3hYvz+Hy
 LTNaF3qhRsbGbjNT2surO6YuKPqc8+TRJLZlv5f1Nt7Tfycur7s2o8TJtfTK7xu7Tsf9vffH
 UPaq4puU54/ES7sOn2rnT14nw20698qrnxV3NyhwVQtv8+pyPcRV2FK2LPxEieHeg4fbTaR/
 aT3aOttyBqdU125pQ+1wrq/NUjFTi7ymKLEUZyQaajEXFScCAP6WLIpmAwAA
X-CMS-MailID: 20220923173629eucas1p27c1ebffb55c2f1a52fad913840b16d02
X-Msg-Generator: CA
X-RootMTR: 20220923173629eucas1p27c1ebffb55c2f1a52fad913840b16d02
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173629eucas1p27c1ebffb55c2f1a52fad913840b16d02
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173629eucas1p27c1ebffb55c2f1a52fad913840b16d02@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v15 09/13] dm-zone: use generic helpers to
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
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

