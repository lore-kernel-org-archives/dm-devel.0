Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DE2C433E6
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6EF5464DBD
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EF5464DBD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-nsHh9B9oP2yrWXEbCSqfWA-1; Thu, 28 Jan 2021 03:39:11 -0500
X-MC-Unique: nsHh9B9oP2yrWXEbCSqfWA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D22F910082F1;
	Thu, 28 Jan 2021 08:39:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AFE0519719;
	Thu, 28 Jan 2021 08:39:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 822741809CA2;
	Thu, 28 Jan 2021 08:39:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7CqoI007416 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:12:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1CEBD2166B2A; Thu, 28 Jan 2021 07:12:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 176332166B2B
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:12:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A352800883
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:12:49 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-350-vhaEU4Y8Mkqk7_ii-_74Uw-1; Thu, 28 Jan 2021 02:12:46 -0500
X-MC-Unique: vhaEU4Y8Mkqk7_ii-_74Uw-1
IronPort-SDR: wDKMcJs1e8M3YAlIK+Rh6PU8vGQqw0KVRQyoQjFThHq0eJZDh1KZCVUv+Os/p6f+wF0+JFqdeh
	fYjkEu1aTlaqJUQG3/VG0cB5aK+t15bDJwh4/GZKp6SnNKyXY6y2GK8BGWHDlCoHgxUSpP8GJ6
	0c2efxhrUk6YiTXzsRVM9cswHAfQz1s3CMRFmGBJCOyvILE/a845QnpHRrtepdaqO6mPvWSqVD
	ZNDwp7a6hHxnKlaeFgU7Quo0uQH9hEEvBCRQ09kFGk6SCELmxghrXKvu2S8pQaUbmgqLIdX2LR
	vQ8=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="268892406"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:12:45 +0800
IronPort-SDR: G3TPb1zm5etH7+Qm9YB86t1nKSU2wJ0ywR7MaG25vt/vItFyxmIrF5V+3CHYC3criePjjZVAsK
	lBLvFbDmACtXwvm0N5+KIzR/ICOfzNvjoGvBUJ3rZtQDDaC7/hs0ZhrWlYOMeNRLQcoKd6BZK0
	JrUiGn0QSXmUm8x3ZZpyW2zWn09J+6XSnMMsZKChqsv1C5OJhAy4eiGmb++iksAl0C+mJLKZxL
	jlG8tJxH2ARKAvTVSx/gbREQRslLjXuHA5dgZU5AmvkyobRaA3IxTN5/KIGxqo8PotffqANM41
	QTTV15PwJDCGrDszsvjYNvbL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:55:03 -0800
IronPort-SDR: iX0HhBu+61xFa7EtRWB17G0RFoDdFxtABLHP5yHe733z1qMOeQszsqPYXIq64MFQkReY48/RWk
	FOClHc2dhNxuRM1QyLpF0KtQrhnCpVvcpPgq0B9OecXrJpCL8UYdCuDWFTL9LdxFS6qWHXh51B
	DNrP6xQEwjJPm/GL/W/Mv5XtvThzXYCRCRRzvICfBStun4/LN576oOtiFYHwzWMShhTX3BjqKf
	c8icNJold/1bdh3xf4xqkQcFwP0TJ4M2AqZVo41MRst8Lsv9bfR6qeue7iMnlhLF3vJJuSRBwu
	WXg=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:12:45 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:06 -0800
Message-Id: <20210128071133.60335-8-chaitanya.kulkarni@wdc.com>
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
X-Mailman-Approved-At: Thu, 28 Jan 2021 03:38:54 -0500
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
Subject: [dm-devel] [RFC PATCH 07/34] dm: use bio_new in dm-log-writes
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
 drivers/md/dm-log-writes.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index e3d35c6c9f71..7ca9af407647 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -217,18 +217,15 @@ static int write_metadata(struct log_writes_c *lc, void *entry,
 	void *ptr;
 	size_t ret;
 
-	bio = bio_alloc(GFP_KERNEL, 1);
+	bio = bio_new(lc->logdev->bdev, sector, REQ_OP_WRITE, 0, 1, GFP_KERNEL);
 	if (!bio) {
 		DMERR("Couldn't alloc log bio");
 		goto error;
 	}
 	bio->bi_iter.bi_size = 0;
-	bio->bi_iter.bi_sector = sector;
-	bio_set_dev(bio, lc->logdev->bdev);
 	bio->bi_end_io = (sector == WRITE_LOG_SUPER_SECTOR) ?
 			  log_end_super : log_end_io;
 	bio->bi_private = lc;
-	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
@@ -264,7 +261,7 @@ static int write_inline_data(struct log_writes_c *lc, void *entry,
 			     size_t entrylen, void *data, size_t datalen,
 			     sector_t sector)
 {
-	int num_pages, bio_pages, pg_datalen, pg_sectorlen, i;
+	int num_pages, pg_datalen, pg_sectorlen, i;
 	struct page *page;
 	struct bio *bio;
 	size_t ret;
@@ -272,24 +269,21 @@ static int write_inline_data(struct log_writes_c *lc, void *entry,
 
 	while (datalen) {
 		num_pages = ALIGN(datalen, PAGE_SIZE) >> PAGE_SHIFT;
-		bio_pages = min(num_pages, BIO_MAX_PAGES);
 
 		atomic_inc(&lc->io_blocks);
 
-		bio = bio_alloc(GFP_KERNEL, bio_pages);
+		bio = bio_new(lc->logdev->bdev, sector, REQ_OP_WRITE, 0,
+			      num_pages, GFP_KERNEL);
 		if (!bio) {
 			DMERR("Couldn't alloc inline data bio");
 			goto error;
 		}
 
 		bio->bi_iter.bi_size = 0;
-		bio->bi_iter.bi_sector = sector;
-		bio_set_dev(bio, lc->logdev->bdev);
 		bio->bi_end_io = log_end_io;
 		bio->bi_private = lc;
-		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
-		for (i = 0; i < bio_pages; i++) {
+		for (i = 0; i < bio->bi_max_vecs; i++) {
 			pg_datalen = min_t(int, datalen, PAGE_SIZE);
 			pg_sectorlen = ALIGN(pg_datalen, lc->sectorsize);
 
@@ -317,7 +311,7 @@ static int write_inline_data(struct log_writes_c *lc, void *entry,
 		}
 		submit_bio(bio);
 
-		sector += bio_pages * PAGE_SECTORS;
+		sector += bio->bi_max_vecs * PAGE_SECTORS;
 	}
 	return 0;
 error_bio:
@@ -364,17 +358,15 @@ static int log_one_block(struct log_writes_c *lc,
 		goto out;
 
 	atomic_inc(&lc->io_blocks);
-	bio = bio_alloc(GFP_KERNEL, min(block->vec_cnt, BIO_MAX_PAGES));
+	bio = bio_new(lc->logdev->bdev, sector, REQ_OP_WRITE, 0,
+			block->vec_cnt, GFP_KERNEL);
 	if (!bio) {
 		DMERR("Couldn't alloc log bio");
 		goto error;
 	}
 	bio->bi_iter.bi_size = 0;
-	bio->bi_iter.bi_sector = sector;
-	bio_set_dev(bio, lc->logdev->bdev);
 	bio->bi_end_io = log_end_io;
 	bio->bi_private = lc;
-	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 	for (i = 0; i < block->vec_cnt; i++) {
 		/*
@@ -386,17 +378,15 @@ static int log_one_block(struct log_writes_c *lc,
 		if (ret != block->vecs[i].bv_len) {
 			atomic_inc(&lc->io_blocks);
 			submit_bio(bio);
-			bio = bio_alloc(GFP_KERNEL, min(block->vec_cnt - i, BIO_MAX_PAGES));
+			bio = bio_new(lc->logdev->bdev, sector, REQ_OP_WRITE,
+					0, block->vec_cnt - i, GFP_KERNEL);
 			if (!bio) {
 				DMERR("Couldn't alloc log bio");
 				goto error;
 			}
 			bio->bi_iter.bi_size = 0;
-			bio->bi_iter.bi_sector = sector;
-			bio_set_dev(bio, lc->logdev->bdev);
 			bio->bi_end_io = log_end_io;
 			bio->bi_private = lc;
-			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 			ret = bio_add_page(bio, block->vecs[i].bv_page,
 					   block->vecs[i].bv_len, 0);
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

