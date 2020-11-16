Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43645C82540
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C8BE222263
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:00:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8BE222263
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-3w8wz_SPNbSd_BX3MtZOOw-1; Mon, 16 Nov 2020 10:00:06 -0500
X-MC-Unique: 3w8wz_SPNbSd_BX3MtZOOw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1636100E443;
	Mon, 16 Nov 2020 14:59:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A351155769;
	Mon, 16 Nov 2020 14:59:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 75A3B183D024;
	Mon, 16 Nov 2020 14:59:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGExU8K015528 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 09:59:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8342C20182A5; Mon, 16 Nov 2020 14:59:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E8882011553
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2043C90E428
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:28 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-304-FmNwdndiMD-x7ap3YTVw0w-1; Mon, 16 Nov 2020 09:59:25 -0500
X-MC-Unique: FmNwdndiMD-x7ap3YTVw0w-1
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kefyR-00041m-OS; Mon, 16 Nov 2020 14:59:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 16 Nov 2020 15:57:40 +0100
Message-Id: <20201116145809.410558-50-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Subject: [dm-devel] [PATCH 49/78] ataflop: use a separate gendisk for each
	media format
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The Atari floppy driver usually autodetects the media when used with the
ormal /dev/fd? devices, which also are the only nodes created by udev.
But it also supports various aliases that force a given media format.
That is currently supported using the blk_register_region framework
which finds the floppy gendisk even for a 'mismatched' dev_t.  The
problem with this (besides the code complexity) is that it creates
multiple struct block_device instances for the whole device of a
single gendisk, which can lead to interesting issues in code not
aware of that fact.

To fix this just create a separate gendisk for each of the aliases
if they are accessed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/ataflop.c | 135 +++++++++++++++++++++++++---------------
 1 file changed, 86 insertions(+), 49 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 3e881fdb06e0ad..104b713f4055af 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -297,7 +297,7 @@ static struct atari_floppy_struct {
 	unsigned int wpstat;	/* current state of WP signal (for
 				   disk change detection) */
 	int flags;		/* flags */
-	struct gendisk *disk;
+	struct gendisk *disk[NUM_DISK_MINORS];
 	int ref;
 	int type;
 	struct blk_mq_tag_set tag_set;
@@ -723,12 +723,16 @@ static void fd_error( void )
 
 static int do_format(int drive, int type, struct atari_format_descr *desc)
 {
-	struct request_queue *q = unit[drive].disk->queue;
+	struct request_queue *q;
 	unsigned char	*p;
 	int sect, nsect;
 	unsigned long	flags;
 	int ret;
 
+	if (type)
+		type--;
+
+	q = unit[drive].disk[type]->queue;
 	blk_mq_freeze_queue(q);
 	blk_mq_quiesce_queue(q);
 
@@ -738,7 +742,7 @@ static int do_format(int drive, int type, struct atari_format_descr *desc)
 	local_irq_restore(flags);
 
 	if (type) {
-		if (--type >= NUM_DISK_MINORS ||
+		if (type >= NUM_DISK_MINORS ||
 		    minor2disktype[type].drive_types > DriveType) {
 			ret = -EINVAL;
 			goto out;
@@ -1154,7 +1158,7 @@ static void fd_rwsec_done1(int status)
 			    if (SUDT[-1].blocks > ReqBlock) {
 				/* try another disk type */
 				SUDT--;
-				set_capacity(unit[SelectedDrive].disk,
+				set_capacity(unit[SelectedDrive].disk[0],
 							SUDT->blocks);
 			    } else
 				Probing = 0;
@@ -1169,7 +1173,7 @@ static void fd_rwsec_done1(int status)
 /* record not found, but not probing. Maybe stretch wrong ? Restart probing */
 			if (SUD.autoprobe) {
 				SUDT = atari_disk_type + StartDiskType[DriveType];
-				set_capacity(unit[SelectedDrive].disk,
+				set_capacity(unit[SelectedDrive].disk[0],
 							SUDT->blocks);
 				Probing = 1;
 			}
@@ -1515,7 +1519,7 @@ static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		if (!UDT) {
 			Probing = 1;
 			UDT = atari_disk_type + StartDiskType[DriveType];
-			set_capacity(floppy->disk, UDT->blocks);
+			set_capacity(bd->rq->rq_disk, UDT->blocks);
 			UD.autoprobe = 1;
 		}
 	} 
@@ -1533,7 +1537,7 @@ static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		}
 		type = minor2disktype[type].index;
 		UDT = &atari_disk_type[type];
-		set_capacity(floppy->disk, UDT->blocks);
+		set_capacity(bd->rq->rq_disk, UDT->blocks);
 		UD.autoprobe = 0;
 	}
 
@@ -1658,7 +1662,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 				    printk (KERN_INFO "floppy%d: setting %s %p!\n",
 				        drive, dtp->name, dtp);
 				UDT = dtp;
-				set_capacity(floppy->disk, UDT->blocks);
+				set_capacity(disk, UDT->blocks);
 
 				if (cmd == FDDEFPRM) {
 				  /* save settings as permanent default type */
@@ -1702,7 +1706,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 			return -EINVAL;
 
 		UDT = dtp;
-		set_capacity(floppy->disk, UDT->blocks);
+		set_capacity(disk, UDT->blocks);
 
 		return 0;
 	case FDMSGON:
@@ -1725,7 +1729,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 		UDT = NULL;
 		/* MSch: invalidate default_params */
 		default_params[drive].blocks  = 0;
-		set_capacity(floppy->disk, MAX_DISK_SIZE * 2);
+		set_capacity(disk, MAX_DISK_SIZE * 2);
 		fallthrough;
 	case FDFMTEND:
 	case FDFLUSH:
@@ -1962,14 +1966,50 @@ static const struct blk_mq_ops ataflop_mq_ops = {
 	.commit_rqs = ataflop_commit_rqs,
 };
 
-static struct kobject *floppy_find(dev_t dev, int *part, void *data)
+static int ataflop_alloc_disk(unsigned int drive, unsigned int type)
 {
-	int drive = *part & 3;
-	int type  = *part >> 2;
+	struct gendisk *disk;
+	int ret;
+
+	disk = alloc_disk(1);
+	if (!disk)
+		return -ENOMEM;
+
+	disk->queue = blk_mq_init_queue(&unit[drive].tag_set);
+	if (IS_ERR(disk->queue)) {
+		ret = PTR_ERR(disk->queue);
+		disk->queue = NULL;
+		put_disk(disk);
+		return ret;
+	}
+
+	disk->major = FLOPPY_MAJOR;
+	disk->first_minor = drive + (type << 2);
+	sprintf(disk->disk_name, "fd%d", drive);
+	disk->fops = &floppy_fops;
+	disk->events = DISK_EVENT_MEDIA_CHANGE;
+	disk->private_data = &unit[drive];
+	set_capacity(disk, MAX_DISK_SIZE * 2);
+
+	unit[drive].disk[type] = disk;
+	return 0;
+}
+
+static DEFINE_MUTEX(ataflop_probe_lock);
+
+static void ataflop_probe(dev_t dev)
+{
+	int drive = MINOR(dev) & 3;
+	int type  = MINOR(dev) >> 2;
+
 	if (drive >= FD_MAX_UNITS || type > NUM_DISK_MINORS)
-		return NULL;
-	*part = 0;
-	return get_disk_and_module(unit[drive].disk);
+		return;
+	mutex_lock(&ataflop_probe_lock);
+	if (!unit[drive].disk[type]) {
+		if (ataflop_alloc_disk(drive, type) == 0)
+			add_disk(unit[drive].disk[type]);
+	}
+	mutex_unlock(&ataflop_probe_lock);
 }
 
 static int __init atari_floppy_init (void)
@@ -1981,23 +2021,26 @@ static int __init atari_floppy_init (void)
 		/* Amiga, Mac, ... don't have Atari-compatible floppy :-) */
 		return -ENODEV;
 
-	if (register_blkdev(FLOPPY_MAJOR,"fd"))
-		return -EBUSY;
+	mutex_lock(&ataflop_probe_lock);
+	ret = __register_blkdev(FLOPPY_MAJOR, "fd", ataflop_probe);
+	if (ret)
+		goto out_unlock;
 
 	for (i = 0; i < FD_MAX_UNITS; i++) {
-		unit[i].disk = alloc_disk(1);
-		if (!unit[i].disk) {
-			ret = -ENOMEM;
+		memset(&unit[i].tag_set, 0, sizeof(unit[i].tag_set));
+		unit[i].tag_set.ops = &ataflop_mq_ops;
+		unit[i].tag_set.nr_hw_queues = 1;
+		unit[i].tag_set.nr_maps = 1;
+		unit[i].tag_set.queue_depth = 2;
+		unit[i].tag_set.numa_node = NUMA_NO_NODE;
+		unit[i].tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+		ret = blk_mq_alloc_tag_set(&unit[i].tag_set);
+		if (ret)
 			goto err;
-		}
 
-		unit[i].disk->queue = blk_mq_init_sq_queue(&unit[i].tag_set,
-							   &ataflop_mq_ops, 2,
-							   BLK_MQ_F_SHOULD_MERGE);
-		if (IS_ERR(unit[i].disk->queue)) {
-			put_disk(unit[i].disk);
-			ret = PTR_ERR(unit[i].disk->queue);
-			unit[i].disk->queue = NULL;
+		ret = ataflop_alloc_disk(i, 0);
+		if (ret) {
+			blk_mq_free_tag_set(&unit[i].tag_set);
 			goto err;
 		}
 	}
@@ -2027,19 +2070,9 @@ static int __init atari_floppy_init (void)
 	for (i = 0; i < FD_MAX_UNITS; i++) {
 		unit[i].track = -1;
 		unit[i].flags = 0;
-		unit[i].disk->major = FLOPPY_MAJOR;
-		unit[i].disk->first_minor = i;
-		sprintf(unit[i].disk->disk_name, "fd%d", i);
-		unit[i].disk->fops = &floppy_fops;
-		unit[i].disk->events = DISK_EVENT_MEDIA_CHANGE;
-		unit[i].disk->private_data = &unit[i];
-		set_capacity(unit[i].disk, MAX_DISK_SIZE * 2);
-		add_disk(unit[i].disk);
+		add_disk(unit[i].disk[0]);
 	}
 
-	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
-				floppy_find, NULL, NULL);
-
 	printk(KERN_INFO "Atari floppy driver: max. %cD, %strack buffering\n",
 	       DriveType == 0 ? 'D' : DriveType == 1 ? 'H' : 'E',
 	       UseTrackbuffer ? "" : "no ");
@@ -2049,14 +2082,14 @@ static int __init atari_floppy_init (void)
 
 err:
 	while (--i >= 0) {
-		struct gendisk *disk = unit[i].disk;
-
-		blk_cleanup_queue(disk->queue);
+		blk_cleanup_queue(unit[i].disk[0]->queue);
+		put_disk(unit[i].disk[0]);
 		blk_mq_free_tag_set(&unit[i].tag_set);
-		put_disk(unit[i].disk);
 	}
 
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
+out_unlock:
+	mutex_unlock(&ataflop_probe_lock);
 	return ret;
 }
 
@@ -2101,13 +2134,17 @@ __setup("floppy=", atari_floppy_setup);
 
 static void __exit atari_floppy_exit(void)
 {
-	int i;
-	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
+	int i, type;
+
 	for (i = 0; i < FD_MAX_UNITS; i++) {
-		del_gendisk(unit[i].disk);
-		blk_cleanup_queue(unit[i].disk->queue);
+		for (type = 0; type < NUM_DISK_MINORS; type++) {
+			if (!unit[i].disk[type])
+				continue;
+			del_gendisk(unit[i].disk[type]);
+			blk_cleanup_queue(unit[i].disk[type]->queue);
+			put_disk(unit[i].disk[type]);
+		}
 		blk_mq_free_tag_set(&unit[i].tag_set);
-		put_disk(unit[i].disk);
 	}
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

