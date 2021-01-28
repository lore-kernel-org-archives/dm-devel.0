Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BB4C433E6
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:51:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E87364D92
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:51:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E87364D92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-wVHqXVChPDmnwCO5P-ZbNQ-1; Thu, 28 Jan 2021 03:51:48 -0500
X-MC-Unique: wVHqXVChPDmnwCO5P-ZbNQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C38D639390;
	Thu, 28 Jan 2021 08:51:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F5BC19D9D;
	Thu, 28 Jan 2021 08:51:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 735231809CA6;
	Thu, 28 Jan 2021 08:51:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7EEKH007556 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:14:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9669A2166B2A; Thu, 28 Jan 2021 07:14:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 909162166B2B
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:14:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BF7B101A560
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:14:14 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-93-LxJKplmGORu_snR1PiduWA-1; Thu, 28 Jan 2021 02:14:12 -0500
X-MC-Unique: LxJKplmGORu_snR1PiduWA-1
IronPort-SDR: xNWXqKvRnAn096XryPQ8wQJSa38Z+wzu6Klb0WuBfk+z1wMfnyiJF+EpUfGZFcpn7RsOw92J4t
	V2C2v+xUP3rFqEWU6jR/ViUT6DEG/s1b7qbsA8VWhGO4K+3y74v9z7Jz8VCZxaVvC76cQY3ZHE
	dpbVLJpqhc/aykAiqc8MV0zpIK8mqOng4PTpvvHrLl0PFJTX1hSEfh9VEvGmtK1PF43ybkKs87
	hqPLalbZcfcOk897c0BCKCb1aw6oBBy4l0Glf525LIu/7CpsT64x5juxwVr2pkamOiW/m3/Idv
	+iA=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="158517409"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:14:10 +0800
IronPort-SDR: /C5t1KjZmncJlbBEtKi3bxU3JUUgL5D+lZY0G0jQQricJMBSEwmApR1WXSD7DNnW+1Oh31NbF+
	BRenOenuVjurPVnzD7hDAVmFWY+ObaYDB79lfWWp+Pbv9sW/N4oRytNuvBAruDCwdTyNrNZpJX
	lvnWoFTvNiMP3oI2AcgiOuOcvb5cNfvt/1bbwLauLbR4Ox7W0NwEoFqxU6vRuKGb4FxAMpik4v
	PlRMj44r0Ugb3Jx4caY+mVeEzF5rVO4vfASBDjYw4pA9T3XROs0fbiNrW3wQvJdMHicSEJZxI+
	NwLmiGLEdG7lkWztA0qK+Aj8
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:56:28 -0800
IronPort-SDR: lKKhoxaMeyOwXqrT2FSzD4wN8uVJ+mvKyFTUKLm7JjK92Do6Pp8LlRaYGgmaQWgAcNgigcbWq0
	dr8eH/C5m6jarJyZCPupuIjbqQYzS6I98zkdR7vs+3yNowqMQiZeF1CHZrTo/tpym1SjWfvRXs
	6jUItt1/GcDgh349QalPLGcjYuMZ5A1EKw0wTA/1PN33qNlegyypjYwNakr5Qt7Zi77XOTVrdO
	glPMuXb+RS4OnELTigLzoH/k3P2LKO+/yrMNDKd4LQa/txopqXKI4iyznrBVm1YJBPOgSOjnjZ
	uxk=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:14:10 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:16 -0800
Message-Id: <20210128071133.60335-18-chaitanya.kulkarni@wdc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Subject: [dm-devel] [RFC PATCH 17/34] iomap: use bio_new in iomap_dio_zero
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/iomap/direct-io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ea1e8f696076..f6c557a1bd25 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -189,15 +189,13 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 	int flags = REQ_SYNC | REQ_IDLE;
 	struct bio *bio;
 
-	bio = bio_alloc(GFP_KERNEL, 1);
-	bio_set_dev(bio, iomap->bdev);
-	bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
+	bio = bio_new(iomap->bdev, iomap_sector(iomap, pos), REQ_OP_WRITE,
+		      flags, 1, GFP_KERNEL);
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
 	get_page(page);
 	__bio_add_page(bio, page, len, 0);
-	bio_set_op_attrs(bio, REQ_OP_WRITE, flags);
 	iomap_dio_submit_bio(dio, iomap, bio, pos);
 }
 
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

