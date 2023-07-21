Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EBBFEB64DC
	for <dm-devel@archiver.kernel.org>; Fri, 21 Jul 2023 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689947440;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DWabTIE3w1Ea1Pmqq0dUIQ5VCmLsZcj8LUtIK6LH1lQ=;
	b=KSW8FN9GYHrlEnzcbTzgeSjgPZ8aJvZn2yDX+IZ0MNq+fZXFpijxNVe37mxK378gZnfqfc
	uTJgE/fiFyInuOJLTjfpE5nbB30dn48d3UircL8VRCdIfY4AGZ4n9OpOISSNb2wiYBZcT8
	N8+jn/d3TcRMYLVMrzde3DEketA+k9s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-FbFIbKaAO7G0IJmiymKjrw-1; Fri, 21 Jul 2023 09:50:38 -0400
X-MC-Unique: FbFIbKaAO7G0IJmiymKjrw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E656880C4FF;
	Fri, 21 Jul 2023 13:50:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D39B71121314;
	Fri, 21 Jul 2023 13:50:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC5AF1946A43;
	Fri, 21 Jul 2023 13:50:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF44A1946A43
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Jul 2023 13:50:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AF938492B03; Fri, 21 Jul 2023 13:50:35 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A158F492B02;
 Fri, 21 Jul 2023 13:50:35 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id D2BD730C0458; Fri, 21 Jul 2023 13:50:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 D1D5C3FB76; Fri, 21 Jul 2023 15:50:29 +0200 (CEST)
Date: Fri, 21 Jul 2023 15:50:29 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <3bcf643-5eef-9537-6def-17de279f1e4e@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 3/3] brd: implement write zeroes
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
Cc: linux-block@vger.kernel.org, Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 Christoph Hellwig <hch@infradead.org>, Li Nan <linan666@huaweicloud.com>,
 dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch implements REQ_OP_WRITE_ZEROES on brd. Write zeroes will free
the pages just like discard, but the difference is that it writes zeroes
to the preceding and following page if the range is not aligned on page
boundary.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/block/brd.c |   78 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 28 deletions(-)

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -301,7 +301,8 @@ out:
 void brd_do_discard(struct brd_device *brd, struct bio *bio)
 {
 	struct free_page_batch *batch = NULL;
-	sector_t sector, len, front_pad;
+	bool zero_padding = bio_op(bio) == REQ_OP_WRITE_ZEROES;
+	sector_t sector, len, front_pad, end_pad;
 
 	if (unlikely(!discard)) {
 		bio->bi_status = BLK_STS_NOTSUPP;
@@ -311,11 +312,22 @@ void brd_do_discard(struct brd_device *b
 	sector = bio->bi_iter.bi_sector;
 	len = bio_sectors(bio);
 	front_pad = -sector & (PAGE_SECTORS - 1);
+
+	if (zero_padding && unlikely(front_pad != 0))
+		copy_to_brd(brd, page_address(ZERO_PAGE(0)),
+			    sector, min(len, front_pad) << SECTOR_SHIFT);
+
 	sector += front_pad;
 	if (unlikely(len <= front_pad))
 		return;
 	len -= front_pad;
-	len = round_down(len, PAGE_SECTORS);
+
+	end_pad = len & (PAGE_SECTORS - 1);
+	if (zero_padding && unlikely(end_pad != 0))
+		copy_to_brd(brd, page_address(ZERO_PAGE(0)),
+			    sector + len - end_pad, end_pad << SECTOR_SHIFT);
+	len -= end_pad;
+
 	while (len) {
 		brd_free_page(brd, sector, &batch);
 		sector += PAGE_SECTORS;
@@ -333,34 +345,42 @@ static void brd_submit_bio(struct bio *b
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 
-	if (bio_op(bio) == REQ_OP_DISCARD) {
-		brd_do_discard(brd, bio);
-		goto endio;
-	}
-
-	sector = bio->bi_iter.bi_sector;
-	bio_for_each_segment(bvec, bio, iter) {
-		unsigned int len = bvec.bv_len;
-		int err;
-
-		/* Don't support un-aligned buffer */
-		WARN_ON_ONCE((bvec.bv_offset & (SECTOR_SIZE - 1)) ||
-				(len & (SECTOR_SIZE - 1)));
-
-		err = brd_do_bvec(brd, bvec.bv_page, len, bvec.bv_offset,
-				  bio->bi_opf, sector);
-		if (err) {
-			if (err == -ENOMEM && bio->bi_opf & REQ_NOWAIT) {
-				bio_wouldblock_error(bio);
-				return;
+	switch (bio_op(bio)) {
+		case REQ_OP_DISCARD:
+		case REQ_OP_WRITE_ZEROES:
+			brd_do_discard(brd, bio);
+			break;
+
+		case REQ_OP_READ:
+		case REQ_OP_WRITE:
+			sector = bio->bi_iter.bi_sector;
+			bio_for_each_segment(bvec, bio, iter) {
+				unsigned int len = bvec.bv_len;
+				int err;
+
+				/* Don't support un-aligned buffer */
+				WARN_ON_ONCE((bvec.bv_offset & (SECTOR_SIZE - 1)) ||
+						(len & (SECTOR_SIZE - 1)));
+
+				err = brd_do_bvec(brd, bvec.bv_page, len, bvec.bv_offset,
+						  bio->bi_opf, sector);
+				if (err) {
+					if (err == -ENOMEM && bio->bi_opf & REQ_NOWAIT) {
+						bio_wouldblock_error(bio);
+						return;
+					}
+					bio_io_error(bio);
+					return;
+				}
+				sector += len >> SECTOR_SHIFT;
 			}
-			bio_io_error(bio);
-			return;
-		}
-		sector += len >> SECTOR_SHIFT;
+			break;
+
+		default:
+			bio->bi_status = BLK_STS_NOTSUPP;
+			break;
 	}
 
-endio:
 	bio_endio(bio);
 }
 
@@ -378,9 +398,11 @@ static void brd_set_discard_limits(struc
 	if (discard) {
 		queue->limits.discard_granularity = PAGE_SIZE;
 		blk_queue_max_discard_sectors(queue, round_down(UINT_MAX, PAGE_SECTORS));
+		blk_queue_max_write_zeroes_sectors(queue, round_down(UINT_MAX, PAGE_SECTORS));
 	} else {
 		queue->limits.discard_granularity = 0;
 		blk_queue_max_discard_sectors(queue, 0);
+		blk_queue_max_write_zeroes_sectors(queue, 0);
 	}
 }
 
@@ -420,7 +442,7 @@ MODULE_PARM_DESC(max_part, "Num Minors t
 
 static bool discard = false;
 module_param_cb(discard, &discard_ops, &discard, 0644);
-MODULE_PARM_DESC(discard, "Support discard");
+MODULE_PARM_DESC(discard, "Support discard and write zeroes");
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

