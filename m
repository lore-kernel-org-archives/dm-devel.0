Return-Path: <SRS0=56gb=K4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491BAC47098
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 06:55:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D77E5613B1
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 06:55:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D77E5613B1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-CmorW2wJM26ffIOC-bR_Uw-1; Wed, 02 Jun 2021 02:55:23 -0400
X-MC-Unique: CmorW2wJM26ffIOC-bR_Uw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 995E21009460;
	Wed,  2 Jun 2021 06:55:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22FE910013D6;
	Wed,  2 Jun 2021 06:55:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE12A1801266;
	Wed,  2 Jun 2021 06:55:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1526tCme016702 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 02:55:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EF717208744D; Wed,  2 Jun 2021 06:55:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EAE73208747A
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 06:55:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 235AB1825066
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 06:55:08 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-61-NAVWI2nHPGSJyNnRRUxyzw-1; Wed, 02 Jun 2021 02:55:05 -0400
X-MC-Unique: NAVWI2nHPGSJyNnRRUxyzw-1
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loKmA-0025cC-BJ; Wed, 02 Jun 2021 06:54:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Jun 2021 09:53:27 +0300
Message-Id: <20210602065345.355274-13-hch@lst.de>
In-Reply-To: <20210602065345.355274-1-hch@lst.de>
References: <20210602065345.355274-1-hch@lst.de>
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
Cc: Justin Sanders <justin@coraid.com>, Vignesh Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Tim Waugh <tim@cyberelk.net>,
	linux-s390@vger.kernel.org, Alex Dubov <oakad@yahoo.com>,
	Richard Weinberger <richard@nod.at>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	xen-devel@lists.xenproject.org, Ilya Dryomov <idryomov@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Denis Efremov <efremov@linux.com>, nbd@other.debian.org,
	linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Geoff Levand <geoff@infradead.org>, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [dm-devel] [PATCH 12/30] swim: use blk_mq_alloc_disk
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use the blk_mq_alloc_disk API to simplify the gendisk and request_queue
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/swim.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 2917b21f48ff..7ccc8d2a41bc 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -800,23 +800,20 @@ static int swim_floppy_init(struct swim_priv *swd)
 	spin_lock_init(&swd->lock);
 
 	for (drive = 0; drive < swd->floppy_count; drive++) {
-		struct request_queue *q;
-
-		swd->unit[drive].disk = alloc_disk(1);
-		if (swd->unit[drive].disk == NULL) {
-			err = -ENOMEM;
+		err = blk_mq_alloc_sq_tag_set(&swd->unit[drive].tag_set,
+				&swim_mq_ops, 2, BLK_MQ_F_SHOULD_MERGE);
+		if (err)
 			goto exit_put_disks;
-		}
 
-		q = blk_mq_init_sq_queue(&swd->unit[drive].tag_set, &swim_mq_ops,
-						2, BLK_MQ_F_SHOULD_MERGE);
-		if (IS_ERR(q)) {
-			err = PTR_ERR(q);
+		swd->unit[drive].disk =
+			blk_mq_alloc_disk(&swd->unit[drive].tag_set,
+					  &swd->unit[drive]);
+		if (IS_ERR(swd->unit[drive].disk)) {
+			blk_mq_free_tag_set(&swd->unit[drive].tag_set);
+			err = PTR_ERR(swd->unit[drive].disk);
 			goto exit_put_disks;
 		}
 
-		swd->unit[drive].disk->queue = q;
-		swd->unit[drive].disk->queue->queuedata = &swd->unit[drive];
 		swd->unit[drive].swd = swd;
 	}
 
@@ -824,6 +821,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 		swd->unit[drive].disk->flags = GENHD_FL_REMOVABLE;
 		swd->unit[drive].disk->major = FLOPPY_MAJOR;
 		swd->unit[drive].disk->first_minor = drive;
+		swd->unit[drive].disk->minors = 1;
 		sprintf(swd->unit[drive].disk->disk_name, "fd%d", drive);
 		swd->unit[drive].disk->fops = &floppy_fops;
 		swd->unit[drive].disk->events = DISK_EVENT_MEDIA_CHANGE;
@@ -839,14 +837,10 @@ static int swim_floppy_init(struct swim_priv *swd)
 	do {
 		struct gendisk *disk = swd->unit[drive].disk;
 
-		if (disk) {
-			if (disk->queue) {
-				blk_cleanup_queue(disk->queue);
-				disk->queue = NULL;
-			}
-			blk_mq_free_tag_set(&swd->unit[drive].tag_set);
-			put_disk(disk);
-		}
+		if (!disk)
+			continue;
+		blk_cleanup_disk(disk);
+		blk_mq_free_tag_set(&swd->unit[drive].tag_set);
 	} while (drive--);
 	return err;
 }
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

