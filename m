Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A0CC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9B25222C9D
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B25222C9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-ivoj3AgQNsKeoDgfoj18sQ-1; Tue, 19 Jan 2021 00:08:08 -0500
X-MC-Unique: ivoj3AgQNsKeoDgfoj18sQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F327F190A7A1;
	Tue, 19 Jan 2021 05:08:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D193071CA7;
	Tue, 19 Jan 2021 05:08:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A5FDB1809CA1;
	Tue, 19 Jan 2021 05:08:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J582Jo020415 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:08:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3A1C96D9D9; Tue, 19 Jan 2021 05:08:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 34AAE4411D
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21A4F80120A
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:02 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-496-SKZwG28jMYG2Iy3g2Q2hwA-1; Tue, 19 Jan 2021 00:07:55 -0500
X-MC-Unique: SKZwG28jMYG2Iy3g2Q2hwA-1
IronPort-SDR: KbdSdfGju78UnXl9NLAtxUPKANEwGZhfy5WY7e5KjPX3/5ZEofkXShoGKQKQzs7Rx6F9lVOoDW
	4Y0X+tGUyHkzgOdbAV4Di+1S/Qd4165DxKALX7+xbiNeSw25SoxQCArV2Y7GuxwkuFSxI7hGwh
	2OlDWWh6WJWk+Yd7ZjEiAyDrIpBcL5X073lHfqvYamrgo28zZIzIUG5Y6IL26+Itet6HbSZfVf
	w+4lpbuB4GoLmbpGyuNRztipsYtbfssBg3PxtUS3kVI9RuaM1w9J8vBaJ0GkKLrabwBQeuowvJ
	Fn4=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="268080866"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:06:50 +0800
IronPort-SDR: nJ3vAwGGe1/ZDr4AgvjfgFg4oQPFu77QtxW+FVAs5XqHzcL75/zM2529vlqn5VF3Wl4YmXQPiZ
	TYMWx1YziHzWknj9DpQfeuoEAc3+DjDgbgXKaXCI+ra9/Uv+npskdzb5Epev77OX5qgC9SbU1r
	0XBQyTqXtcv75bIwmB0ewfzseD7LKLKSHwJ9TRfVnnchLUwEoSI+u+PuswX4vUPfZjGHi3WIXB
	RimH/xO1/vjfSRWGRO9Kicn4oE9q+l+PAeln6M1SWKwUCoD/lCVQIvZosyD5BwYHxt0mzPi7/8
	ypdfsUKZbPhihfONakhchIeC
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:49:25 -0800
IronPort-SDR: XoCPpBnEyAS0C26NACpPNr6hc2mgCkBhR/slXc8vz6d3NBxAPkngsmR+924mOBWvaQi6WZHAP1
	e4hIrlRuqs07ngks51wLmgnhqz6gvPVZzt6c/xtYGHpktVNv4G+tlyQwdXjSld+DKB31WM3e0X
	o4xJZXi1ZVzEGxYUOHxoYuaGW27b5AhyEnbnJEWPqSGnvSmb4YAK4r55aDWz+qouFqxTNJ1Ve4
	MmaSi236cQpo5ubtxkwfTjN+hUw7qXvWgQEEinw8kPT9rlOQYeg6qJM9v7qJDF5MBv1NXcWrD2
	OOA=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:06:49 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:05:56 -0800
Message-Id: <20210119050631.57073-3-chaitanya.kulkarni@wdc.com>
In-Reply-To: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
References: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, snitzer@redhat.com,
	gustavo@embeddedor.com, clm@fb.com, dm-devel@redhat.com,
	adilger.kernel@dilger.ca, hch@lst.de, agk@redhat.com,
	naohiro.aota@wdc.com, sagi@grimberg.me, darrick.wong@oracle.com,
	osandov@fb.com, kent.overstreet@gmail.com,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	josef@toxicpanda.com, efremov@linux.com, colyli@suse.de,
	tj@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com,
	bvanassche@acm.org, agruenba@redhat.com, axboe@kernel.dk,
	damien.lemoal@wdc.com, tytso@mit.edu, martin.petersen@oracle.com,
	song@kernel.org, philipp.reisner@linbit.com,
	jefflexu@linux.alibaba.com, rpeterso@redhat.com,
	lars.ellenberg@linbit.com, jth@kernel.org, asml.silence@gmail.com
Subject: [dm-devel] [RFC PATCH 02/37] fs: use bio_init_fields in block_dev
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/block_dev.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 3e5b02f6606c..44b992976ee5 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -239,12 +239,9 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 	}
 
 	bio_init(&bio, vecs, nr_pages);
-	bio_set_dev(&bio, bdev);
-	bio.bi_iter.bi_sector = pos >> 9;
-	bio.bi_write_hint = iocb->ki_hint;
-	bio.bi_private = current;
-	bio.bi_end_io = blkdev_bio_end_io_simple;
-	bio.bi_ioprio = iocb->ki_ioprio;
+	bio_init_fields(&bio, bdev, pos >> 9, current, blkdev_bio_end_io_simple,
+			iocb->ki_ioprio, iocb->ki_hint);
+
 
 	ret = bio_iov_iter_get_pages(&bio, iter);
 	if (unlikely(ret))
@@ -390,12 +387,8 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		blk_start_plug(&plug);
 
 	for (;;) {
-		bio_set_dev(bio, bdev);
-		bio->bi_iter.bi_sector = pos >> 9;
-		bio->bi_write_hint = iocb->ki_hint;
-		bio->bi_private = dio;
-		bio->bi_end_io = blkdev_bio_end_io;
-		bio->bi_ioprio = iocb->ki_ioprio;
+		bio_init_fields(bio, bdev, pos >> 9, dio, blkdev_bio_end_io,
+				iocb->ki_ioprio, iocb->ki_hint);
 
 		ret = bio_iov_iter_get_pages(bio, iter);
 		if (unlikely(ret)) {
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

