Return-Path: <SRS0=56gb=K4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3985EC47093
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 06:55:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CF17E613AD
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 06:55:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF17E613AD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-mtgRcmE_NcicCpQTg4nejg-1; Wed, 02 Jun 2021 02:55:42 -0400
X-MC-Unique: mtgRcmE_NcicCpQTg4nejg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28ECF501EC;
	Wed,  2 Jun 2021 06:55:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AF0E60C0F;
	Wed,  2 Jun 2021 06:55:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CDFCD180BAB6;
	Wed,  2 Jun 2021 06:55:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1526tW2a016774 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 02:55:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 65D5A208744F; Wed,  2 Jun 2021 06:55:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 614A32084828
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 06:55:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02625857D08
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 06:55:30 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-287-oS4G53liPHip-TijJwe4vA-1; Wed, 02 Jun 2021 02:55:27 -0400
X-MC-Unique: oS4G53liPHip-TijJwe4vA-1
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loKma-0025sw-BW; Wed, 02 Jun 2021 06:55:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Jun 2021 09:53:33 +0300
Message-Id: <20210602065345.355274-19-hch@lst.de>
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
Subject: [dm-devel] [PATCH 18/30] loop: use blk_mq_alloc_disk and
	blk_cleanup_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use blk_mq_alloc_disk and blk_cleanup_disk to simplify the gendisk and
request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 95c570f5923f..3f40e673a101 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2117,12 +2117,12 @@ static int loop_add(struct loop_device **l, int i)
 	if (err)
 		goto out_free_idr;
 
-	lo->lo_queue = blk_mq_init_queue(&lo->tag_set);
-	if (IS_ERR(lo->lo_queue)) {
-		err = PTR_ERR(lo->lo_queue);
+	disk = lo->lo_disk = blk_mq_alloc_disk(&lo->tag_set, lo);
+	if (IS_ERR(disk)) {
+		err = PTR_ERR(disk);
 		goto out_cleanup_tags;
 	}
-	lo->lo_queue->queuedata = lo;
+	lo->lo_queue = lo->lo_disk->queue;
 
 	blk_queue_max_hw_sectors(lo->lo_queue, BLK_DEF_MAX_SECTORS);
 
@@ -2134,11 +2134,6 @@ static int loop_add(struct loop_device **l, int i)
 	 */
 	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, lo->lo_queue);
 
-	err = -ENOMEM;
-	disk = lo->lo_disk = alloc_disk(1 << part_shift);
-	if (!disk)
-		goto out_free_queue;
-
 	/*
 	 * Disable partition scanning by default. The in-kernel partition
 	 * scanning can be requested individually per-device during its
@@ -2166,6 +2161,7 @@ static int loop_add(struct loop_device **l, int i)
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
 	disk->first_minor	= i << part_shift;
+	disk->minors		= 1 << part_shift;
 	disk->fops		= &lo_fops;
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
@@ -2174,8 +2170,6 @@ static int loop_add(struct loop_device **l, int i)
 	*l = lo;
 	return lo->lo_number;
 
-out_free_queue:
-	blk_cleanup_queue(lo->lo_queue);
 out_cleanup_tags:
 	blk_mq_free_tag_set(&lo->tag_set);
 out_free_idr:
@@ -2189,9 +2183,8 @@ static int loop_add(struct loop_device **l, int i)
 static void loop_remove(struct loop_device *lo)
 {
 	del_gendisk(lo->lo_disk);
-	blk_cleanup_queue(lo->lo_queue);
 	blk_mq_free_tag_set(&lo->tag_set);
-	put_disk(lo->lo_disk);
+	blk_cleanup_disk(lo->lo_disk);
 	mutex_destroy(&lo->lo_mutex);
 	kfree(lo);
 }
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

