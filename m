Return-Path: <SRS0=56gb=K4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E7D3C4708F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 07:40:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E388D60E0B
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 07:40:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E388D60E0B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-9kv3sYACMBqlkjGY8ciw-A-1; Wed, 02 Jun 2021 03:40:52 -0400
X-MC-Unique: 9kv3sYACMBqlkjGY8ciw-A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7A238049CC;
	Wed,  2 Jun 2021 07:40:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF9CC5C230;
	Wed,  2 Jun 2021 07:40:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 22F621801264;
	Wed,  2 Jun 2021 07:40:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1527ejSC021633 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 03:40:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3AA2C2087475; Wed,  2 Jun 2021 07:40:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 35AEE2087472
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 07:40:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 593A380D0E0
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 07:40:42 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-62-bQZr7NOKNoS6D4fJiT3n3A-1; Wed, 02 Jun 2021 03:40:38 -0400
X-MC-Unique: bQZr7NOKNoS6D4fJiT3n3A-1
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loKm6-0025Ys-7i; Wed, 02 Jun 2021 06:54:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Jun 2021 09:53:26 +0300
Message-Id: <20210602065345.355274-12-hch@lst.de>
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
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: yes
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
Subject: [dm-devel] [PATCH 11/30] swim3: use blk_mq_alloc_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 drivers/block/swim3.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index a515d0c1d2cb..965af0a3e95b 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1202,30 +1202,27 @@ static int swim3_attach(struct macio_dev *mdev,
 			return rc;
 	}
 
-	disk = alloc_disk(1);
-	if (disk == NULL) {
-		rc = -ENOMEM;
-		goto out_unregister;
-	}
-
 	fs = &floppy_states[floppy_count];
 	memset(fs, 0, sizeof(*fs));
 
-	disk->queue = blk_mq_init_sq_queue(&fs->tag_set, &swim3_mq_ops, 2,
-						BLK_MQ_F_SHOULD_MERGE);
-	if (IS_ERR(disk->queue)) {
-		rc = PTR_ERR(disk->queue);
-		disk->queue = NULL;
-		goto out_put_disk;
+	rc = blk_mq_alloc_sq_tag_set(&fs->tag_set, &swim3_mq_ops, 2,
+			BLK_MQ_F_SHOULD_MERGE);
+	if (rc)
+		goto out_unregister;
+
+	disk = blk_mq_alloc_disk(&fs->tag_set, fs);
+	if (IS_ERR(disk)) {
+		rc = PTR_ERR(disk);
+		goto out_free_tag_set;
 	}
-	disk->queue->queuedata = fs;
 
 	rc = swim3_add_device(mdev, floppy_count);
 	if (rc)
-		goto out_cleanup_queue;
+		goto out_cleanup_disk;
 
 	disk->major = FLOPPY_MAJOR;
 	disk->first_minor = floppy_count;
+	disk->minors = 1;
 	disk->fops = &floppy_fops;
 	disk->private_data = fs;
 	disk->events = DISK_EVENT_MEDIA_CHANGE;
@@ -1237,12 +1234,10 @@ static int swim3_attach(struct macio_dev *mdev,
 	disks[floppy_count++] = disk;
 	return 0;
 
-out_cleanup_queue:
-	blk_cleanup_queue(disk->queue);
-	disk->queue = NULL;
+out_cleanup_disk:
+	blk_cleanup_disk(disk);
+out_free_tag_set:
 	blk_mq_free_tag_set(&fs->tag_set);
-out_put_disk:
-	put_disk(disk);
 out_unregister:
 	if (floppy_count == 0)
 		unregister_blkdev(FLOPPY_MAJOR, "fd");
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

