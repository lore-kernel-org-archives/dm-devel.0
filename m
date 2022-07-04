Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B283C43334
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 14:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656944639;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n6TD77FIF2hjmyor1mUZJeEZXh9YQ55POzv/LW+PP9Q=;
	b=WlVoSJAMv/DEqhJSf4m/bKDK6EOXjyoPnGWLxnRSRGRwfnjTnwnQGY8ZhjdQp0VTvjL18u
	3g/lovxwoR6/qM5NpWNEQTHWlxxW7yx917tHXt+g0A69Up4rwK/oZJU2pF5ukF45hjhTU9
	93NvaWF3kUiSTddZz8zgOPWl20pAA10=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-iv73oUlvMVap8f3JrX5QmA-1; Mon, 04 Jul 2022 10:23:55 -0400
X-MC-Unique: iv73oUlvMVap8f3JrX5QmA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05C971C05EB5;
	Mon,  4 Jul 2022 14:23:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB69D1121315;
	Mon,  4 Jul 2022 14:23:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 79FBA1947041;
	Mon,  4 Jul 2022 14:23:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C2BA19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 14:23:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1A37340E7F29; Mon,  4 Jul 2022 14:23:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1639D40E7F28
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 14:23:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1DC585A582
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 14:23:51 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-gi99AlBKN8i_Yf6SsO1E-w-1; Mon, 04 Jul 2022 10:23:50 -0400
X-MC-Unique: gi99AlBKN8i_Yf6SsO1E-w-1
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o8LRz-008sFG-MP; Mon, 04 Jul 2022 12:45:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Mon,  4 Jul 2022 14:44:48 +0200
Message-Id: <20220704124500.155247-6-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH 05/17] block: export blkdev_zone_mgmt_all
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Export blkdev_zone_mgmt_all so that the nvme target can use it instead
of duplicating the functionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-zoned.c      | 10 +++++-----
 include/linux/blkdev.h |  2 ++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 90a5c9cc80ab3..7fbe395fa51fc 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -185,8 +185,8 @@ static int blk_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
 	}
 }
 
-static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
-					  gfp_t gfp_mask)
+int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
+			 gfp_t gfp_mask)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 	sector_t capacity = get_capacity(bdev->bd_disk);
@@ -213,8 +213,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
 			continue;
 		}
 
-		bio = blk_next_bio(bio, bdev, 0, REQ_OP_ZONE_RESET | REQ_SYNC,
-				   gfp_mask);
+		bio = blk_next_bio(bio, bdev, 0, op | REQ_SYNC, gfp_mask);
 		bio->bi_iter.bi_sector = sector;
 		sector += zone_sectors;
 
@@ -231,6 +230,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
 	kfree(need_reset);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(blkdev_zone_mgmt_all);
 
 static int blkdev_zone_reset_all(struct block_device *bdev, gfp_t gfp_mask)
 {
@@ -295,7 +295,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	 */
 	if (op == REQ_OP_ZONE_RESET && sector == 0 && nr_sectors == capacity) {
 		if (!blk_queue_zone_resetall(q))
-			return blkdev_zone_reset_all_emulated(bdev, gfp_mask);
+			return blkdev_zone_mgmt_all(bdev, op, gfp_mask);
 		return blkdev_zone_reset_all(bdev, gfp_mask);
 	}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 270cd0c552924..b9baee910b825 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -302,6 +302,8 @@ unsigned int blkdev_nr_zones(struct gendisk *disk);
 extern int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 			    sector_t sectors, sector_t nr_sectors,
 			    gfp_t gfp_mask);
+int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
+			 gfp_t gfp_mask);
 int blk_revalidate_disk_zones(struct gendisk *disk,
 			      void (*update_driver_data)(struct gendisk *disk));
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

