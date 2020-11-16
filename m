Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3F4C82541
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5919424199
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5919424199
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-SDNPsz9eM8eB_esAScwjzA-1; Mon, 16 Nov 2020 10:00:02 -0500
X-MC-Unique: SDNPsz9eM8eB_esAScwjzA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5910A8BF892;
	Mon, 16 Nov 2020 14:59:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31DCD51512;
	Mon, 16 Nov 2020 14:59:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD64958118;
	Mon, 16 Nov 2020 14:59:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGExP6e015460 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 09:59:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5F8B16FA7E; Mon, 16 Nov 2020 14:59:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5654D6FA76
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0189490E42D
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:20 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-544-WBSR37IHNPaD_Qby_gJFzw-1; Mon, 16 Nov 2020 09:59:17 -0500
X-MC-Unique: WBSR37IHNPaD_Qby_gJFzw-1
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kefyE-0003y0-K9; Mon, 16 Nov 2020 14:59:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 16 Nov 2020 15:57:31 +0100
Message-Id: <20201116145809.410558-41-hch@lst.de>
In-Reply-To: <20201116145809.410558-1-hch@lst.de>
References: <20201116145809.410558-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [dm-devel] [PATCH 40/78] ide: remove ide_{,un}register_region
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

There is no need to ever register the fake gendisk used for ide-tape.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ide/ide-probe.c | 32 --------------------------------
 drivers/ide/ide-tape.c  |  2 --
 include/linux/ide.h     |  3 ---
 3 files changed, 37 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 1ddc45a04418cd..076d34b381720f 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -929,38 +929,6 @@ static struct kobject *ata_probe(dev_t dev, int *part, void *data)
 	return NULL;
 }
 
-static struct kobject *exact_match(dev_t dev, int *part, void *data)
-{
-	struct gendisk *p = data;
-	*part &= (1 << PARTN_BITS) - 1;
-	return &disk_to_dev(p)->kobj;
-}
-
-static int exact_lock(dev_t dev, void *data)
-{
-	struct gendisk *p = data;
-
-	if (!get_disk_and_module(p))
-		return -1;
-	return 0;
-}
-
-void ide_register_region(struct gendisk *disk)
-{
-	blk_register_region(MKDEV(disk->major, disk->first_minor),
-			    disk->minors, NULL, exact_match, exact_lock, disk);
-}
-
-EXPORT_SYMBOL_GPL(ide_register_region);
-
-void ide_unregister_region(struct gendisk *disk)
-{
-	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
-			      disk->minors);
-}
-
-EXPORT_SYMBOL_GPL(ide_unregister_region);
-
 void ide_init_disk(struct gendisk *disk, ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 6f26634b22bbec..88b96437b22e62 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1822,7 +1822,6 @@ static void ide_tape_remove(ide_drive_t *drive)
 
 	ide_proc_unregister_driver(drive, tape->driver);
 	device_del(&tape->dev);
-	ide_unregister_region(tape->disk);
 
 	mutex_lock(&idetape_ref_mutex);
 	put_device(&tape->dev);
@@ -2026,7 +2025,6 @@ static int ide_tape_probe(ide_drive_t *drive)
 		      "n%s", tape->name);
 
 	g->fops = &idetape_block_ops;
-	ide_register_region(g);
 
 	return 0;
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 62653769509f89..2c300689a51a5c 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1493,9 +1493,6 @@ static inline void ide_acpi_port_init_devices(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
 
-void ide_register_region(struct gendisk *);
-void ide_unregister_region(struct gendisk *);
-
 void ide_check_nien_quirk_list(ide_drive_t *);
 void ide_undecoded_slave(ide_drive_t *);
 
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

