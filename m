Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058AAC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C13A64DE4
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C13A64DE4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-wnde9zl_O4q_FGYqNk7nqQ-1; Thu, 28 Jan 2021 03:39:31 -0500
X-MC-Unique: wnde9zl_O4q_FGYqNk7nqQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A45A81CBE9;
	Thu, 28 Jan 2021 08:39:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF1E760C69;
	Thu, 28 Jan 2021 08:39:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B1AB850031;
	Thu, 28 Jan 2021 08:39:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7FOIK007683 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:15:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 520FCEC4AA; Thu, 28 Jan 2021 07:15:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46E02EE37C
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:15:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58F1E101A566
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:15:19 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-451-3uPk0sVVOFuch7-ftNgJAg-1; Thu, 28 Jan 2021 02:15:14 -0500
X-MC-Unique: 3uPk0sVVOFuch7-ftNgJAg-1
IronPort-SDR: PRb7Tk34ZhBnV631OrWg7/r5FalGKKGSdj/DAT0xb47EFSRl/8pUBs8m8gGj4speRiQkwnYcTP
	2vfmGk7J81dMphm9XIAyz0j3L24vEMJhlKF/qJmfyrnKhQUYdgQZ7mBhcfp8uyEKNzptLMLOnI
	J0VQLfxNNyy71sGkg3eUsc8gsyI3q008rBCfpDTwWzDozb8naERWxwLoI/teXohR+Q3F+ktpYp
	/JBZf/BtMWpdQGV6uV+alHIYD9MQujaAkmzMwSRiUHl6M/DPLfK2RKO4bJy9V/xOdgC1GLaX/o
	ciw=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="162963397"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:14:54 +0800
IronPort-SDR: LcucobSF2C0V9lbf2+fdDkggoMDkF8RzZ1QDcQw33uf/v/+V9o48ivttXlxCPgxA6iHFlOAvtR
	R3VpZ2xrGAJkusgVCz5daJaOExCCh4rq+Ne4aweaWh4UICx4awWvjj2QeKc/Q+Rr3R+I6hjmJJ
	VjX6t3S5fKXO8R7hBPXHk5MAAnD+tbEi8AQ0lXZTXeQYGI+yK2Z4NfaS/uIL1Kv6CqPNVwMTAQ
	LMViHZWWdWST5joniPODDNoZoNdQhn2YoccTWLPB0zBlxtsCn4iwH67OAgHFktRrs2ASS1MHDf
	VLFPKjYakylVJ33eq0S40JzG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:59:14 -0800
IronPort-SDR: m1TZ+g0HqYnNuuEaVgIMmloDXGiOQeWVkBatefSwdP931h6/Qc9uK8rnz+JHWAn0f3QBmOsUC2
	fXJ41UlgQQnfdBQndrwCq+hQtl7mr6AQW85+ZjLVP2rPUrLfDej915AJE+NjNtCGI740sa3D8g
	UGQ9bx3fpoJbY98zSPHF13CT5IYtiyfyvVxvvVA5VfTuNLKWU4ZEgYs5jdqkUbRYa6sajX3DSU
	E+nFYRIRokBPoO+x05JGw6lqTR47HYfSK6LYXKwXfQUKv6zaLN0igntqoauBJYDwbicxGnznwF
	roE=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:14:54 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:22 -0800
Message-Id: <20210128071133.60335-24-chaitanya.kulkarni@wdc.com>
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 28 Jan 2021 03:38:55 -0500
Cc: shaggy@kernel.org, sergey.senozhatsky.work@gmail.com, snitzer@redhat.com,
	tiwai@suse.de, djwong@kernel.org, gustavoars@kernel.org,
	joseph.qi@linux.alibaba.com, pavel@ucw.cz,
	alex.shi@linux.alibaba.com, hch@lst.de, agk@redhat.com,
	naohiro.aota@wdc.com, sagi@grimberg.me, mark@fasheh.com,
	osandov@fb.com, ebiggers@kernel.org, ngupta@vflare.org,
	len.brown@intel.com, chaitanya.kulkarni@wdc.com,
	konrad.wilk@oracle.com, ming.lei@redhat.com,
	viro@zeniv.linux.org.uk, jefflexu@linux.alibaba.com,
	jaegeuk@kernel.org, konishi.ryusuke@gmail.com,
	bvanassche@acm.org, axboe@kernel.dk, damien.lemoal@wdc.com,
	tytso@mit.edu, akpm@linux-foundation.org,
	martin.petersen@oracle.com, rjw@rjwysocki.net,
	philipp.reisner@linbit.com, minchan@kernel.org, tj@kernel.org,
	lars.ellenberg@linbit.com, jth@kernel.org,
	asml.silence@gmail.com, jlbec@evilplan.org, roger.pau@citrix.com
Subject: [dm-devel] [RFC PATCH 23/34] fs/mpage.c: use bio_new mpage_alloc
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/mpage.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index 830e6cc2a9e7..01725126e81f 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -68,25 +68,21 @@ static struct bio *mpage_bio_submit(int op, int op_flags, struct bio *bio)
 }
 
 static struct bio *
-mpage_alloc(struct block_device *bdev,
-		sector_t first_sector, int nr_vecs,
-		gfp_t gfp_flags)
+mpage_alloc(struct block_device *bdev, sector_t first_sector, int nr_vecs,
+	    gfp_t gfp_flags)
 {
 	struct bio *bio;
 
 	/* Restrict the given (page cache) mask for slab allocations */
 	gfp_flags &= GFP_KERNEL;
-	bio = bio_alloc(gfp_flags, nr_vecs);
+	bio = bio_new(bdev, first_sector, 0, 0, nr_vecs, gfp_flags);
 
 	if (bio == NULL && (current->flags & PF_MEMALLOC)) {
 		while (!bio && (nr_vecs /= 2))
-			bio = bio_alloc(gfp_flags, nr_vecs);
+			bio = bio_new(bdev, first_sector, 0, 0, nr_vecs,
+					gfp_flags);
 	}
 
-	if (bio) {
-		bio_set_dev(bio, bdev);
-		bio->bi_iter.bi_sector = first_sector;
-	}
 	return bio;
 }
 
@@ -304,9 +300,7 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 				goto out;
 		}
 		args->bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
-					min_t(int, args->nr_pages,
-					      BIO_MAX_PAGES),
-					gfp);
+					args->nr_pages, gfp);
 		if (args->bio == NULL)
 			goto confused;
 	}
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

