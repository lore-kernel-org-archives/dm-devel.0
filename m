Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA828C43334
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 16:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656953782;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FSBOkTTw1kCHvCWPJkzWJgh2NXPlubecopSSpZIf42s=;
	b=aTFfFWQmYbZY3n5F0twQj9ab6igt5ACNo3rarq71sYnceWJnjT/H2HC+k3X+dNcuakd3oo
	Mnz/x1va+OKF2mFRHbL0rH8HSRbahsaSse47T+ofCaEQAFeVfAgBhpnPSAzMB5n0EBO/QO
	OsepiH1unK0TTbzTqE+lA8/9l1I5hWk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-alRxCfuQNR-Yf8DPjzlHTg-1; Mon, 04 Jul 2022 12:56:21 -0400
X-MC-Unique: alRxCfuQNR-Yf8DPjzlHTg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 437F9801755;
	Mon,  4 Jul 2022 16:56:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4AE12401E54;
	Mon,  4 Jul 2022 16:56:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 03498194704A;
	Mon,  4 Jul 2022 16:56:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D69419466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 16:56:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5C99E40334D; Mon,  4 Jul 2022 16:56:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 56DFF401E54
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 16:56:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4058B3C0D841
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 16:56:15 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-gutI0SNjNVmbVz6J5LYKzg-1; Mon, 04 Jul 2022 12:56:13 -0400
X-MC-Unique: gutI0SNjNVmbVz6J5LYKzg-1
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8LS2-008sGf-C7; Mon, 04 Jul 2022 12:45:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Mon,  4 Jul 2022 14:44:49 +0200
Message-Id: <20220704124500.155247-7-hch@lst.de>
In-Reply-To: <20220704124500.155247-1-hch@lst.de>
References: <20220704124500.155247-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 06/17] nvmet: use blkdev_zone_mgmt_all
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use blkdev_zone_mgmt_all instead of a copy and pasted version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/target/zns.c | 104 ++------------------------------------
 1 file changed, 3 insertions(+), 101 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 82b61acf7a72b..c6f0a775efdee 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -337,110 +337,12 @@ static u16 blkdev_zone_mgmt_errno_to_nvme_status(int ret)
 	}
 }
 
-struct nvmet_zone_mgmt_send_all_data {
-	unsigned long *zbitmap;
-	struct nvmet_req *req;
-};
-
-static int zmgmt_send_scan_cb(struct blk_zone *z, unsigned i, void *d)
-{
-	struct nvmet_zone_mgmt_send_all_data *data = d;
-
-	switch (zsa_req_op(data->req->cmd->zms.zsa)) {
-	case REQ_OP_ZONE_OPEN:
-		switch (z->cond) {
-		case BLK_ZONE_COND_CLOSED:
-			break;
-		default:
-			return 0;
-		}
-		break;
-	case REQ_OP_ZONE_CLOSE:
-		switch (z->cond) {
-		case BLK_ZONE_COND_IMP_OPEN:
-		case BLK_ZONE_COND_EXP_OPEN:
-			break;
-		default:
-			return 0;
-		}
-		break;
-	case REQ_OP_ZONE_FINISH:
-		switch (z->cond) {
-		case BLK_ZONE_COND_IMP_OPEN:
-		case BLK_ZONE_COND_EXP_OPEN:
-		case BLK_ZONE_COND_CLOSED:
-			break;
-		default:
-			return 0;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	set_bit(i, data->zbitmap);
-
-	return 0;
-}
-
-static u16 nvmet_bdev_zone_mgmt_emulate_all(struct nvmet_req *req)
-{
-	struct block_device *bdev = req->ns->bdev;
-	unsigned int nr_zones = blkdev_nr_zones(bdev->bd_disk);
-	struct request_queue *q = bdev_get_queue(bdev);
-	struct bio *bio = NULL;
-	sector_t sector = 0;
-	int ret;
-	struct nvmet_zone_mgmt_send_all_data d = {
-		.req = req,
-	};
-
-	d.zbitmap = kcalloc_node(BITS_TO_LONGS(nr_zones), sizeof(*(d.zbitmap)),
-				 GFP_NOIO, q->node);
-	if (!d.zbitmap) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* Scan and build bitmap of the eligible zones */
-	ret = blkdev_report_zones(bdev, 0, nr_zones, zmgmt_send_scan_cb, &d);
-	if (ret != nr_zones) {
-		if (ret > 0)
-			ret = -EIO;
-		goto out;
-	} else {
-		/* We scanned all the zones */
-		ret = 0;
-	}
-
-	while (sector < get_capacity(bdev->bd_disk)) {
-		if (test_bit(blk_queue_zone_no(q, sector), d.zbitmap)) {
-			bio = blk_next_bio(bio, bdev, 0,
-				zsa_req_op(req->cmd->zms.zsa) | REQ_SYNC,
-				GFP_KERNEL);
-			bio->bi_iter.bi_sector = sector;
-			/* This may take a while, so be nice to others */
-			cond_resched();
-		}
-		sector += blk_queue_zone_sectors(q);
-	}
-
-	if (bio) {
-		ret = submit_bio_wait(bio);
-		bio_put(bio);
-	}
-
-out:
-	kfree(d.zbitmap);
-
-	return blkdev_zone_mgmt_errno_to_nvme_status(ret);
-}
-
 static u16 nvmet_bdev_execute_zmgmt_send_all(struct nvmet_req *req)
 {
+	unsigned int op = zsa_req_op(req->cmd->zms.zsa);
 	int ret;
 
-	switch (zsa_req_op(req->cmd->zms.zsa)) {
+	switch (op) {
 	case REQ_OP_ZONE_RESET:
 		ret = blkdev_zone_mgmt(req->ns->bdev, REQ_OP_ZONE_RESET, 0,
 				       get_capacity(req->ns->bdev->bd_disk),
@@ -451,7 +353,7 @@ static u16 nvmet_bdev_execute_zmgmt_send_all(struct nvmet_req *req)
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:
-		return nvmet_bdev_zone_mgmt_emulate_all(req);
+		return blkdev_zone_mgmt_all(req->ns->bdev, op, GFP_KERNEL);
 	default:
 		/* this is needed to quiet compiler warning */
 		req->error_loc = offsetof(struct nvme_zone_mgmt_send_cmd, zsa);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

