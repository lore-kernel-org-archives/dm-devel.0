Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64979C82555
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:01:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E882C24248
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E882C24248
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-k4S1ADzXPzOASfvCQCMDUA-1; Mon, 16 Nov 2020 10:00:13 -0500
X-MC-Unique: k4S1ADzXPzOASfvCQCMDUA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0A3D804B82;
	Mon, 16 Nov 2020 14:59:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2A806EF46;
	Mon, 16 Nov 2020 14:59:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A7EC458122;
	Mon, 16 Nov 2020 14:59:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGExVQA015534 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 09:59:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C0E1E2156A37; Mon, 16 Nov 2020 14:59:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB2022156A34
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A255790E42F
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:31 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-341--CpRA5KJOtuUtWinYnOMnA-1; Mon, 16 Nov 2020 09:59:24 -0500
X-MC-Unique: -CpRA5KJOtuUtWinYnOMnA-1
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kefyQ-000416-5g; Mon, 16 Nov 2020 14:59:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 16 Nov 2020 15:57:39 +0100
Message-Id: <20201116145809.410558-49-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Subject: [dm-devel] [PATCH 48/78] amiflop: use separate gendisks for Amiga
	vs MS-DOS mode
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

Use separate gendisks (which share a tag_set) for the native Amgiga vs
the MS-DOS mode instead of redirecting the gendisk lookup using a probe
callback.  This avoids potential problems with aliased block_device
instances and will eventually allow for removing the blk_register_region
framework.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/amiflop.c | 98 +++++++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 43 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 71c2b156455860..9e2d0c6a387721 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -201,7 +201,7 @@ struct amiga_floppy_struct {
 	int busy;			/* true when drive is active */
 	int dirty;			/* true when trackbuf is not on disk */
 	int status;			/* current error code for unit */
-	struct gendisk *gendisk;
+	struct gendisk *gendisk[2];
 	struct blk_mq_tag_set tag_set;
 };
 
@@ -1669,6 +1669,11 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		return -EBUSY;
 	}
 
+	if (unit[drive].type->code == FD_NODRIVE) {
+		mutex_unlock(&amiflop_mutex);
+		return -ENXIO;
+	}
+
 	if (mode & (FMODE_READ|FMODE_WRITE)) {
 		bdev_check_media_change(bdev);
 		if (mode & FMODE_WRITE) {
@@ -1695,7 +1700,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	unit[drive].dtype=&data_types[system];
 	unit[drive].blocks=unit[drive].type->heads*unit[drive].type->tracks*
 		data_types[system].sects*unit[drive].type->sect_mult;
-	set_capacity(unit[drive].gendisk, unit[drive].blocks);
+	set_capacity(unit[drive].gendisk[system], unit[drive].blocks);
 
 	printk(KERN_INFO "fd%d: accessing %s-disk with %s-layout\n",drive,
 	       unit[drive].type->name, data_types[system].name);
@@ -1772,36 +1777,68 @@ static const struct blk_mq_ops amiflop_mq_ops = {
 	.queue_rq = amiflop_queue_rq,
 };
 
-static struct gendisk *fd_alloc_disk(int drive)
+static int fd_alloc_disk(int drive, int system)
 {
 	struct gendisk *disk;
 
 	disk = alloc_disk(1);
 	if (!disk)
 		goto out;
-
-	disk->queue = blk_mq_init_sq_queue(&unit[drive].tag_set, &amiflop_mq_ops,
-						2, BLK_MQ_F_SHOULD_MERGE);
-	if (IS_ERR(disk->queue)) {
-		disk->queue = NULL;
+	disk->queue = blk_mq_init_queue(&unit[drive].tag_set);
+	if (IS_ERR(disk->queue))
 		goto out_put_disk;
-	}
 
+	disk->major = FLOPPY_MAJOR;
+	disk->first_minor = drive + system;
+	disk->fops = &floppy_fops;
+	disk->events = DISK_EVENT_MEDIA_CHANGE;
+	if (system)
+		sprintf(disk->disk_name, "fd%d_msdos", drive);
+	else
+		sprintf(disk->disk_name, "fd%d", drive);
+	disk->private_data = &unit[drive];
+	set_capacity(disk, 880 * 2);
+
+	unit[drive].gendisk[system] = disk;
+	add_disk(disk);
+	return 0;
+
+out_put_disk:
+	disk->queue = NULL;
+	put_disk(disk);
+out:
+	return -ENOMEM;
+}
+
+static int fd_alloc_drive(int drive)
+{
 	unit[drive].trackbuf = kmalloc(FLOPPY_MAX_SECTORS * 512, GFP_KERNEL);
 	if (!unit[drive].trackbuf)
-		goto out_cleanup_queue;
+		goto out;
 
-	return disk;
+	memset(&unit[drive].tag_set, 0, sizeof(unit[drive].tag_set));
+	unit[drive].tag_set.ops = &amiflop_mq_ops;
+	unit[drive].tag_set.nr_hw_queues = 1;
+	unit[drive].tag_set.nr_maps = 1;
+	unit[drive].tag_set.queue_depth = 2;
+	unit[drive].tag_set.numa_node = NUMA_NO_NODE;
+	unit[drive].tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+	if (blk_mq_alloc_tag_set(&unit[drive].tag_set))
+		goto out_cleanup_trackbuf;
 
-out_cleanup_queue:
-	blk_cleanup_queue(disk->queue);
-	disk->queue = NULL;
+	pr_cont(" fd%d", drive);
+
+	if (fd_alloc_disk(drive, 0) || fd_alloc_disk(drive, 1))
+		goto out_cleanup_tagset;
+	return 0;
+
+out_cleanup_tagset:
 	blk_mq_free_tag_set(&unit[drive].tag_set);
-out_put_disk:
-	put_disk(disk);
+out_cleanup_trackbuf:
+	kfree(unit[drive].trackbuf);
 out:
 	unit[drive].type->code = FD_NODRIVE;
-	return NULL;
+	return -ENOMEM;
 }
 
 static int __init fd_probe_drives(void)
@@ -1812,29 +1849,16 @@ static int __init fd_probe_drives(void)
 	drives=0;
 	nomem=0;
 	for(drive=0;drive<FD_MAX_UNITS;drive++) {
-		struct gendisk *disk;
 		fd_probe(drive);
 		if (unit[drive].type->code == FD_NODRIVE)
 			continue;
 
-		disk = fd_alloc_disk(drive);
-		if (!disk) {
+		if (fd_alloc_drive(drive) < 0) {
 			pr_cont(" no mem for fd%d", drive);
 			nomem = 1;
 			continue;
 		}
-		unit[drive].gendisk = disk;
 		drives++;
-
-		pr_cont(" fd%d",drive);
-		disk->major = FLOPPY_MAJOR;
-		disk->first_minor = drive;
-		disk->fops = &floppy_fops;
-		disk->events = DISK_EVENT_MEDIA_CHANGE;
-		sprintf(disk->disk_name, "fd%d", drive);
-		disk->private_data = &unit[drive];
-		set_capacity(disk, 880*2);
-		add_disk(disk);
 	}
 	if ((drives > 0) || (nomem == 0)) {
 		if (drives == 0)
@@ -1846,15 +1870,6 @@ static int __init fd_probe_drives(void)
 	return -ENOMEM;
 }
  
-static struct kobject *floppy_find(dev_t dev, int *part, void *data)
-{
-	int drive = *part & 3;
-	if (unit[drive].type->code == FD_NODRIVE)
-		return NULL;
-	*part = 0;
-	return get_disk_and_module(unit[drive].gendisk);
-}
-
 static int __init amiga_floppy_probe(struct platform_device *pdev)
 {
 	int i, ret;
@@ -1884,9 +1899,6 @@ static int __init amiga_floppy_probe(struct platform_device *pdev)
 	if (fd_probe_drives() < 1) /* No usable drives */
 		goto out_probe;
 
-	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
-				floppy_find, NULL, NULL);
-
 	/* initialize variables */
 	timer_setup(&motor_on_timer, motor_on_callback, 0);
 	motor_on_timer.expires = 0;
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

