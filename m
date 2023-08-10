Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36335C04A94
	for <dm-devel@archiver.kernel.org>; Thu, 10 Aug 2023 10:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691662221;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bOlqUQWv4DDqj2/H5WWOohjwiv4M1DnYFt2rgrpvJuI=;
	b=KVclP+pU2w8nSRqc6rjRTKADhl99vdXIoErhJ8rXYS6KIURaK93q47L2QrQ+gWBQu77lTc
	0i42Kt0VC6F0QF+u8wjp0lsOgbRRBGVRNNm+JB2s/slHEH+pYoVnFZD7/FyWIo+aVTsw4e
	nQbCZctZWBQkWPmHCEHecuhIsB5zYcs=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-vZlkM4xAN-G8pC_nfbmrNw-1; Thu, 10 Aug 2023 06:10:18 -0400
X-MC-Unique: vZlkM4xAN-G8pC_nfbmrNw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0B453C025C6;
	Thu, 10 Aug 2023 10:10:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E7BF40C6F4E;
	Thu, 10 Aug 2023 10:10:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5A2D31946589;
	Thu, 10 Aug 2023 10:10:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A2DF81946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 10 Aug 2023 10:10:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BC3D6400D700; Thu, 10 Aug 2023 10:10:11 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A92C940C6F4E;
 Thu, 10 Aug 2023 10:10:11 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id F0E7930B9C07; Thu, 10 Aug 2023 10:10:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 AD8B53F7CF; Thu, 10 Aug 2023 12:10:10 +0200 (CEST)
Date: Thu, 10 Aug 2023 12:10:09 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2dacc73-854-e71c-1746-99b017401c9a@redhat.com>
Message-ID: <19a1a124-cc21-9123-1ba1-2d7cadb9cdbe@redhat.com>
References: <2dacc73-854-e71c-1746-99b017401c9a@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v3 4/4] brd: implement write zeroes
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
 drivers/block/brd.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

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
@@ -359,6 +371,7 @@ static void brd_submit_bio(struct bio *b
 			}
 			break;
 		case REQ_OP_DISCARD:
+		case REQ_OP_WRITE_ZEROES:
 			brd_do_discard(brd, bio);
 			break;
 		default:
@@ -383,9 +396,11 @@ static void brd_set_discard_limits(struc
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
 
@@ -425,7 +440,7 @@ MODULE_PARM_DESC(max_part, "Num Minors t
 
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

