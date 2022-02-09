Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6418C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  9 Feb 2022 08:56:18 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-_k8q0FbYOYqloaz30PhUcA-1; Wed, 09 Feb 2022 03:56:14 -0500
X-MC-Unique: _k8q0FbYOYqloaz30PhUcA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFC8F1091DA4;
	Wed,  9 Feb 2022 08:56:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE1DA73153;
	Wed,  9 Feb 2022 08:56:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 84BF04A7C9;
	Wed,  9 Feb 2022 08:56:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2198u6WI020298 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 03:56:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DE0242026D2F; Wed,  9 Feb 2022 08:56:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D90522026D13
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:56:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C221A801E8D
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:56:03 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-610-YMSQkmeSPO6wgKM-MFRWMA-1; Wed, 09 Feb 2022 03:56:02 -0500
X-MC-Unique: YMSQkmeSPO6wgKM-MFRWMA-1
Received: from [2001:4bb8:188:3efc:ea2:7599:7eeb:4b5a] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nHiLF-00GcDH-Cg; Wed, 09 Feb 2022 08:28:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, target-devel@vger.kernel.org,
	haris.iqbal@ionos.com, jinpu.wang@ionos.com, manoj@linux.ibm.com,
	mrochs@linux.ibm.com, ukrishn@linux.ibm.com
Date: Wed,  9 Feb 2022 09:28:25 +0100
Message-Id: <20220209082828.2629273-5-hch@lst.de>
In-Reply-To: <20220209082828.2629273-1-hch@lst.de>
References: <20220209082828.2629273-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 4/7] sd: remove write same support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There are no more end-users of REQ_OP_WRITE_SAME left, so we can start
deleting it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c     | 75 ++++---------------------------------------
 drivers/scsi/sd_zbc.c |  2 --
 2 files changed, 7 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2d648d27bfd71..fde2857f9bbf5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1034,13 +1034,13 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 		 * Reporting a maximum number of blocks that is not aligned
 		 * on the device physical size would cause a large write same
 		 * request to be split into physically unaligned chunks by
-		 * __blkdev_issue_write_zeroes() and __blkdev_issue_write_same()
-		 * even if the caller of these functions took care to align the
-		 * large request. So make sure the maximum reported is aligned
-		 * to the device physical block size. This is only an optional
-		 * optimization for regular disks, but this is mandatory to
-		 * avoid failure of large write same requests directed at
-		 * sequential write required zones of host-managed ZBC disks.
+		 * __blkdev_issue_write_zeroes() even if the caller of this
+		 * functions took care to align the large request. So make sure
+		 * the maximum reported is aligned to the device physical block
+		 * size. This is only an optional optimization for regular
+		 * disks, but this is mandatory to avoid failure of large write
+		 * same requests directed at sequential write required zones of
+		 * host-managed ZBC disks.
 		 */
 		sdkp->max_ws_blocks =
 			round_down(sdkp->max_ws_blocks,
@@ -1049,68 +1049,10 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 	}
 
 out:
-	blk_queue_max_write_same_sectors(q, sdkp->max_ws_blocks *
-					 (logical_block_size >> 9));
 	blk_queue_max_write_zeroes_sectors(q, sdkp->max_ws_blocks *
 					 (logical_block_size >> 9));
 }
 
-/**
- * sd_setup_write_same_cmnd - write the same data to multiple blocks
- * @cmd: command to prepare
- *
- * Will set up either WRITE SAME(10) or WRITE SAME(16) depending on
- * the preference indicated by the target device.
- **/
-static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
-{
-	struct request *rq = scsi_cmd_to_rq(cmd);
-	struct scsi_device *sdp = cmd->device;
-	struct scsi_disk *sdkp = scsi_disk(rq->q->disk);
-	struct bio *bio = rq->bio;
-	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
-	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
-	blk_status_t ret;
-
-	if (sdkp->device->no_write_same)
-		return BLK_STS_TARGET;
-
-	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len != sdp->sector_size);
-
-	rq->timeout = SD_WRITE_SAME_TIMEOUT;
-
-	if (sdkp->ws16 || lba > 0xffffffff || nr_blocks > 0xffff) {
-		cmd->cmd_len = 16;
-		cmd->cmnd[0] = WRITE_SAME_16;
-		put_unaligned_be64(lba, &cmd->cmnd[2]);
-		put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
-	} else {
-		cmd->cmd_len = 10;
-		cmd->cmnd[0] = WRITE_SAME;
-		put_unaligned_be32(lba, &cmd->cmnd[2]);
-		put_unaligned_be16(nr_blocks, &cmd->cmnd[7]);
-	}
-
-	cmd->transfersize = sdp->sector_size;
-	cmd->allowed = sdkp->max_retries;
-
-	/*
-	 * For WRITE SAME the data transferred via the DATA OUT buffer is
-	 * different from the amount of data actually written to the target.
-	 *
-	 * We set up __data_len to the amount of data transferred via the
-	 * DATA OUT buffer so that blk_rq_map_sg sets up the proper S/G list
-	 * to transfer a single sector of data first, but then reset it to
-	 * the amount of data to be written right after so that the I/O path
-	 * knows how much to actually write.
-	 */
-	rq->__data_len = sdp->sector_size;
-	ret = scsi_alloc_sgtables(cmd);
-	rq->__data_len = blk_rq_bytes(rq);
-
-	return ret;
-}
-
 static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
@@ -1343,8 +1285,6 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 		}
 	case REQ_OP_WRITE_ZEROES:
 		return sd_setup_write_zeroes_cmnd(cmd);
-	case REQ_OP_WRITE_SAME:
-		return sd_setup_write_same_cmnd(cmd);
 	case REQ_OP_FLUSH:
 		return sd_setup_flush_cmnd(cmd);
 	case REQ_OP_READ:
@@ -2039,7 +1979,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	switch (req_op(req)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
-	case REQ_OP_WRITE_SAME:
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 378d071e47cbc..7f466280993bb 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -423,7 +423,6 @@ static bool sd_zbc_need_zone_wp_update(struct request *rq)
 		return true;
 	case REQ_OP_WRITE:
 	case REQ_OP_WRITE_ZEROES:
-	case REQ_OP_WRITE_SAME:
 		return blk_rq_zone_is_seq(rq);
 	default:
 		return false;
@@ -477,7 +476,6 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 		rq->__sector += sdkp->zones_wp_offset[zno];
 		fallthrough;
 	case REQ_OP_WRITE_ZEROES:
-	case REQ_OP_WRITE_SAME:
 	case REQ_OP_WRITE:
 		if (sdkp->zones_wp_offset[zno] < sd_zbc_zone_sectors(sdkp))
 			sdkp->zones_wp_offset[zno] +=
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

