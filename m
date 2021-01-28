Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99984C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:51:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E0BFA64DCE
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:51:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0BFA64DCE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-ZNOY2fTWO_i6GQF_6_4pBA-1; Thu, 28 Jan 2021 03:51:44 -0500
X-MC-Unique: ZNOY2fTWO_i6GQF_6_4pBA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A97A5180A09E;
	Thu, 28 Jan 2021 08:51:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E32B5D9F1;
	Thu, 28 Jan 2021 08:51:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 338821809CA3;
	Thu, 28 Jan 2021 08:51:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7Dm9n007514 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:13:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 44BBB2026D48; Thu, 28 Jan 2021 07:13:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FE242026D76
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:13:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB332811E76
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:13:45 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-181-3CNg4-lrN9Wn4FrcZEF0IQ-1; Thu, 28 Jan 2021 02:13:41 -0500
X-MC-Unique: 3CNg4-lrN9Wn4FrcZEF0IQ-1
IronPort-SDR: RywZRW6Sr/sFyfNs1rKiFbXnbASLuqB8nPjd36cFV9eWUts0QtNp/UdrZWzyqeqh0LpbdFIiIO
	qPbC904yxZcAqx6qiWx6sjQGtFDVs2Ua0S82gOrkHloWaFoV0R57JVrij98HZ24/DoZfUBtZ8l
	GdPVQrBShLNGTI8mGNFPd8y4XVKChKRERbVXeYexIGTBjbgMhZFBlNWRlo7ONNmpgdXLCB3mlo
	3g5j0HFfreFI8k5eVbexOwW8nv0miTyUpWw/wGqjQ+WKQi1VBtcSSCF5zu8lfyeuweSUkD2koL
	4Tw=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="158518216"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:13:39 +0800
IronPort-SDR: vLErHg2gZpUOiO8xIu3j8WGhFYqo5j1EDPoKaOfY0rSNdRc/muJMpH+HNt6RSiipS9Uq/Nh6hD
	v2NXJfg9BzoQQcZzbd0e304AzyVeW2WSHukQU+xMwdKK+DuXrezRkz1n2gqQELnIz805WWgxXz
	bH3IRlCYlr3yiQS3qCR1stSsNS9dKnV5q+dXA5E8d6ZnxJ6poV5N2ued+oT0AAKt6/3hmAXhju
	vJ0khYjnRFIt5Svf6qUqZQwH76h54C7aBrsyCqchqz07EEms3hd6zO+6i//XETq+jBfZ7qIgFo
	0If4lZeQ4TpJRBOaE9w8tqPp
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:55:56 -0800
IronPort-SDR: Soam0z/hZs1yuoqW7i6jx5roOoHAapZwcG8+RboeMSicIzBmOYiX0n71yThGE0I1AnlhuM1di0
	VAe/ab59Zj3d54HqeQwwCvYowNBZyfmch3v7Oy4azaqst0BpJQIg4rXG9R5IU/X7180i4BamQI
	Pdm6cEOWuqZT053sZGwqRvhtwriLsaGVJTX83nQ+r2PwZZdfIXxXkXEJoScfk1suUPevohY8gp
	ghp78Zzi9GkjGDnNvz6HqiAkBvVb/9awaEDn2T+13/9ul6gQjwyqb4x2IkJNU2l4rR1clxPnay
	0k0=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:13:38 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:12 -0800
Message-Id: <20210128071133.60335-14-chaitanya.kulkarni@wdc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Subject: [dm-devel] [RFC PATCH 13/34] block: use bio_new in
	__blkdev_direct_IO
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/block_dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9d4b1a884d76..f3e3247894d7 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -367,6 +367,8 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		return -EINVAL;
 
 	bio = bio_alloc_bioset(GFP_KERNEL, nr_pages, &blkdev_dio_pool);
+	bio_set_dev(bio, bdev);
+	bio->bi_iter.bi_sector = pos >> 9;
 
 	dio = container_of(bio, struct blkdev_dio, bio);
 	dio->is_sync = is_sync = is_sync_kiocb(iocb);
@@ -389,8 +391,6 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		blk_start_plug(&plug);
 
 	for (;;) {
-		bio_set_dev(bio, bdev);
-		bio->bi_iter.bi_sector = pos >> 9;
 		bio->bi_write_hint = iocb->ki_hint;
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
@@ -446,7 +446,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		}
 
 		submit_bio(bio);
-		bio = bio_alloc(GFP_KERNEL, nr_pages);
+		bio = bio_new(bdev, pos >> 9, 0, 0, nr_pages, GFP_KERNEL);
 	}
 
 	if (!is_poll)
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

