Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D73C8254A
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F4B32463F
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F4B32463F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-lAMYIbDLNlWvPaZJqWm-tg-1; Mon, 16 Nov 2020 10:00:05 -0500
X-MC-Unique: lAMYIbDLNlWvPaZJqWm-tg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C602CAE5E6;
	Mon, 16 Nov 2020 14:59:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A88BB6EF5C;
	Mon, 16 Nov 2020 14:59:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 784B4183D025;
	Mon, 16 Nov 2020 14:59:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGExPNf015463 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 09:59:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 640946FA6F; Mon, 16 Nov 2020 14:59:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CCBC6FA7A
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09B8B185A78B
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:25 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-490-CYgOELsNPwyxq9_rk9Frsg-1; Mon, 16 Nov 2020 09:59:20 -0500
X-MC-Unique: CYgOELsNPwyxq9_rk9Frsg-1
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kefyN-000402-5y; Mon, 16 Nov 2020 14:59:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 16 Nov 2020 15:57:37 +0100
Message-Id: <20201116145809.410558-47-hch@lst.de>
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
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
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
Subject: [dm-devel] [PATCH 46/78] ide: switch to __register_blkdev for
	command set probing
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

ide is the last user of the blk_register_region framework except for the
tracking of allocated gendisk.  Switch to __register_blkdev, even if that
doesn't allow us to trivially find out which command set to probe for.
That means we now always request all modules when a user tries to access
an unclaimed ide device node, but except for a few potentially loaded
modules for a fringe use case of a deprecated and soon to be removed
driver that doesn't make a difference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ide/ide-probe.c | 34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 076d34b381720f..1c1567bb519429 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -902,31 +902,12 @@ static int init_irq (ide_hwif_t *hwif)
 	return 1;
 }
 
-static int ata_lock(dev_t dev, void *data)
+static void ata_probe(dev_t dev)
 {
-	/* FIXME: we want to pin hwif down */
-	return 0;
-}
-
-static struct kobject *ata_probe(dev_t dev, int *part, void *data)
-{
-	ide_hwif_t *hwif = data;
-	int unit = *part >> PARTN_BITS;
-	ide_drive_t *drive = hwif->devices[unit];
-
-	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-		return NULL;
-
-	if (drive->media == ide_disk)
-		request_module("ide-disk");
-	if (drive->media == ide_cdrom || drive->media == ide_optical)
-		request_module("ide-cd");
-	if (drive->media == ide_tape)
-		request_module("ide-tape");
-	if (drive->media == ide_floppy)
-		request_module("ide-floppy");
-
-	return NULL;
+	request_module("ide-disk");
+	request_module("ide-cd");
+	request_module("ide-tape");
+	request_module("ide-floppy");
 }
 
 void ide_init_disk(struct gendisk *disk, ide_drive_t *drive)
@@ -967,7 +948,7 @@ static int hwif_init(ide_hwif_t *hwif)
 		return 0;
 	}
 
-	if (register_blkdev(hwif->major, hwif->name))
+	if (__register_blkdev(hwif->major, hwif->name, ata_probe))
 		return 0;
 
 	if (!hwif->sg_max_nents)
@@ -989,8 +970,6 @@ static int hwif_init(ide_hwif_t *hwif)
 		goto out;
 	}
 
-	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
-			    THIS_MODULE, ata_probe, ata_lock, hwif);
 	return 1;
 
 out:
@@ -1582,7 +1561,6 @@ static void ide_unregister(ide_hwif_t *hwif)
 	/*
 	 * Remove us from the kernel's knowledge
 	 */
-	blk_unregister_region(MKDEV(hwif->major, 0), MAX_DRIVES<<PARTN_BITS);
 	kfree(hwif->sg_table);
 	unregister_blkdev(hwif->major, hwif->name);
 
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

