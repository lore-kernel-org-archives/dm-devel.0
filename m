Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6531FC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DD04522CA2
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD04522CA2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-rnjuoGoGNbKumsPkKybAZQ-1; Tue, 19 Jan 2021 00:08:07 -0500
X-MC-Unique: rnjuoGoGNbKumsPkKybAZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D3ECAFA86;
	Tue, 19 Jan 2021 05:08:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40FD4620D7;
	Tue, 19 Jan 2021 05:08:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 128454EBC6;
	Tue, 19 Jan 2021 05:08:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J57xTB020389 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:07:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 46FA56D9D9; Tue, 19 Jan 2021 05:07:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 416A563AFA
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:07:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B649D805B01
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:07:56 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-556-2n1dhlALOTSOl2xJb0hZdw-1; Tue, 19 Jan 2021 00:07:50 -0500
X-MC-Unique: 2n1dhlALOTSOl2xJb0hZdw-1
IronPort-SDR: v9o5Fzhj6UpiP5kkrf/eQObuGLa719Jimv0KJHi1QiWVWUxYIrAWdESQQYcEdNJfWvi3j9b213
	6nNBon7vY//4hgtMLAAzFtGKip65KDx6PZV2icxwe7k4lyBEWEV8p1RylMDRR5sW4WQ39thstS
	cvC6wJn4ozBwO5371CKGeFSs43ZdXEpX5jXlZvhbpEatxEzYQMO5oK3oo7BtocIimK7b6HOLJv
	USrSnRGiUyNzPrO8hOWkFce8gaesqJmdSkrulHNGusAJFF6coi1DTHogdIdhonJi5iWf+8ez1q
	sTk=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="157763741"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:06:42 +0800
IronPort-SDR: iOpo1an9vt6X7losdlk3SN3h1Hh2OQQu0MPdy5BF5Uw/9Zy+MbMI/krwATEw5UQCvwEz8dGFmT
	bU1c6+sVfz8Qa8EL59Q7g8Gyv7Dk/5eLA8UrKlSjMhgy7wlhvIZFUUF0lmwviDt+g6gcwPIUIL
	FGT0HmD4DyexMXqsCUR06XNsSBY+D4yhxrn21OrS2XkfQf+SPm1F07huUhtswqAwgYFGe+gnCq
	CBu5RaldIMuEH5uorfIk4Yx5vqMuz+QnZBKHovS6ZGRjT5t9ZwUBN5xDytGUzkLKUHFSfxs7J4
	0vkyMMpN0/Lm4/zGWJgESPo1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:51:19 -0800
IronPort-SDR: +NpnU1qF6QR8N8XBneIu3ZiZvasLVseQjYJJ1MMaKJ+OglnqkmtIQug/+7v1w/r2fkDf84edQB
	DjafWMcc4nOfiH+Mk03qupgTmYSJWzjHG319wMnHdznvAZeqQCPvdsGd5DhsBkszoippTGcVSA
	HK0sa0ldtVZMuvow8gFchGX7RsHVWH4qFN2Kntl3WSC7I2G5w7F3PvWz0KvKk1ACpfqrdG9xEj
	nchAe07v2IYGlvMXlxEBOdpBs6EbbN/Fyy3RtZL7kH3VABJ8RZFvQM1pZVPOuoiP0DweMhWYKY
	mtU=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:06:42 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:05:55 -0800
Message-Id: <20210119050631.57073-2-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 01/37] block: introduce bio_init_fields()
	helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There are several places in the file-system, block layer, device drivers
where struct bio members such as bdev, sector, private, end io callback,
io priority, write hints are initialized where we can use a helper
function.

This pach introduces a helper function which we use in the block lyaer
code. Subsequent patches use this function to reduce repeated code.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-lib.c     | 13 +++++--------
 include/linux/bio.h | 13 +++++++++++++
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 752f9c722062..5ee488c1bcc6 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -95,8 +95,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		WARN_ON_ONCE((req_sects << 9) > UINT_MAX);
 
 		bio = blk_next_bio(bio, 0, gfp_mask);
-		bio->bi_iter.bi_sector = sector;
-		bio_set_dev(bio, bdev);
+		bio_init_fields(bio, bdev, sector, NULL, NULL, 0, 0);
 		bio_set_op_attrs(bio, op, 0);
 
 		bio->bi_iter.bi_size = req_sects << 9;
@@ -189,8 +188,7 @@ static int __blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 
 	while (nr_sects) {
 		bio = blk_next_bio(bio, 1, gfp_mask);
-		bio->bi_iter.bi_sector = sector;
-		bio_set_dev(bio, bdev);
+		bio_init_fields(bio, bdev, sector, NULL, NULL, 0, 0);
 		bio->bi_vcnt = 1;
 		bio->bi_io_vec->bv_page = page;
 		bio->bi_io_vec->bv_offset = 0;
@@ -265,8 +263,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 
 	while (nr_sects) {
 		bio = blk_next_bio(bio, 0, gfp_mask);
-		bio->bi_iter.bi_sector = sector;
-		bio_set_dev(bio, bdev);
+		bio_init_fields(bio, bdev, sector, NULL, NULL, 0, 0);
 		bio->bi_opf = REQ_OP_WRITE_ZEROES;
 		if (flags & BLKDEV_ZERO_NOUNMAP)
 			bio->bi_opf |= REQ_NOUNMAP;
@@ -317,8 +314,8 @@ static int __blkdev_issue_zero_pages(struct block_device *bdev,
 	while (nr_sects != 0) {
 		bio = blk_next_bio(bio, __blkdev_sectors_to_bio_pages(nr_sects),
 				   gfp_mask);
-		bio->bi_iter.bi_sector = sector;
-		bio_set_dev(bio, bdev);
+		bio_init_fields(bio, bdev, sector, NULL, NULL, 0, 0);
+
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 		while (nr_sects != 0) {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1edda614f7ce..fbeaa5e42a5d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -820,4 +820,17 @@ static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
 		bio->bi_opf |= REQ_NOWAIT;
 }
 
+static inline void bio_init_fields(struct bio *bio, struct block_device *bdev,
+				   sector_t sect, void *priv,
+				   bio_end_io_t *end_io,
+				   unsigned short prio, unsigned short whint)
+{
+	bio_set_dev(bio, bdev);
+	bio->bi_iter.bi_sector = sect;
+	bio->bi_private = priv;
+	bio->bi_end_io = end_io;
+	bio->bi_ioprio = prio;
+	bio->bi_write_hint = whint;
+}
+
 #endif /* __LINUX_BIO_H */
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

