Return-Path: <SRS0=+RIL=GM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58898C433E0
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jan 2021 10:46:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DADA923A1E
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jan 2021 10:46:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DADA923A1E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-0qo_qqt9MYu_PaLl8QZRcQ-1; Sat, 09 Jan 2021 05:46:51 -0500
X-MC-Unique: 0qo_qqt9MYu_PaLl8QZRcQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A352801817;
	Sat,  9 Jan 2021 10:46:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F0805D9C2;
	Sat,  9 Jan 2021 10:46:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 15D634A7C7;
	Sat,  9 Jan 2021 10:46:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 109AkjGG025992 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 9 Jan 2021 05:46:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B01DA2166B28; Sat,  9 Jan 2021 10:46:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB3772166B27
	for <dm-devel@redhat.com>; Sat,  9 Jan 2021 10:46:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D7FB101A53F
	for <dm-devel@redhat.com>; Sat,  9 Jan 2021 10:46:43 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-441-u2L1aB7NOuqEq2SffLGVQg-1; Sat, 09 Jan 2021 05:46:41 -0500
X-MC-Unique: u2L1aB7NOuqEq2SffLGVQg-1
Received: from [2001:4bb8:19b:e528:4197:a20:99de:e7b0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1kyBkd-000TAI-LX; Sat, 09 Jan 2021 10:45:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Jan 2021 11:42:51 +0100
Message-Id: <20210109104254.1077093-4-hch@lst.de>
In-Reply-To: <20210109104254.1077093-1-hch@lst.de>
References: <20210109104254.1077093-1-hch@lst.de>
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
Cc: Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>,
	Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-nvme@lists.infradead.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: [dm-devel] [PATCH 3/6] block: add a hard-readonly flag to struct
	gendisk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading
partition") addressed a long-standing problem with user read-only
policy being overridden as a result of a device-initiated revalidate.
The commit has since been reverted due to a regression that left some
USB devices read-only indefinitely.

To fix the underlying problems with revalidate we need to keep track
of hardware state and user policy separately.

The gendisk has been updated to reflect the current hardware state set
by the device driver. This is done to allow returning the device to
the hardware state once the user clears the BLKROSET flag.

The resulting semantics are as follows:

 - If BLKROSET sets a given partition read-only, that partition will
   remain read-only even if the underlying storage stack initiates a
   revalidate. However, the BLKRRPART ioctl will cause the partition
   table to be dropped and any user policy on partitions will be lost.

 - If BLKROSET has not been set, both the whole disk device and any
   partitions will reflect the current write-protect state of the
   underlying device.

Based on a patch from Martin K. Petersen <martin.petersen@oracle.com>.

Reported-by: Oleksii Kurochko <olkuroch@cisco.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201221
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c        |  4 +---
 block/genhd.c           | 33 +++++++++++++++++++--------------
 block/partitions/core.c |  3 +--
 include/linux/genhd.h   |  6 ++++--
 4 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7663a9b94b8002..08ff8ca325296e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -694,9 +694,7 @@ static inline bool should_fail_request(struct block_device *part,
 
 static inline bool bio_check_ro(struct bio *bio, struct block_device *part)
 {
-	const int op = bio_op(bio);
-
-	if (part->bd_read_only && op_is_write(op)) {
+	if (op_is_write(bio_op(bio)) && bdev_read_only(part)) {
 		char b[BDEVNAME_SIZE];
 
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
diff --git a/block/genhd.c b/block/genhd.c
index 4f90f80d7aa76d..e70bdc9b0893c1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1634,27 +1634,32 @@ static void set_disk_ro_uevent(struct gendisk *gd, int ro)
 	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
 }
 
-void set_disk_ro(struct gendisk *disk, int flag)
+/**
+ * set_disk_ro - set a gendisk read-only
+ * @disk:	gendisk to operate on
+ * @ready_only:	%true to set the disk read-only, %false set the disk read/write
+ *
+ * This function is used to indicate whether a given disk device should have its
+ * read-only flag set. set_disk_ro() is typically used by device drivers to
+ * indicate whether the underlying physical device is write-protected.
+ */
+void set_disk_ro(struct gendisk *disk, bool read_only)
 {
-	struct disk_part_iter piter;
-	struct block_device *part;
-
-	if (disk->part0->bd_read_only != flag) {
-		set_disk_ro_uevent(disk, flag);
-		disk->part0->bd_read_only = flag;
+	if (read_only) {
+		if (test_and_set_bit(GD_READ_ONLY, &disk->state))
+			return;
+	} else {
+		if (!test_and_clear_bit(GD_READ_ONLY, &disk->state))
+			return;
 	}
-
-	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
-	while ((part = disk_part_iter_next(&piter)))
-		part->bd_read_only = flag;
-	disk_part_iter_exit(&piter);
+	set_disk_ro_uevent(disk, read_only);
 }
-
 EXPORT_SYMBOL(set_disk_ro);
 
 int bdev_read_only(struct block_device *bdev)
 {
-	return bdev->bd_read_only;
+	return bdev->bd_read_only ||
+		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
 }
 EXPORT_SYMBOL(bdev_read_only);
 
diff --git a/block/partitions/core.c b/block/partitions/core.c
index e7d776db803b12..168d5906077cfd 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -195,7 +195,7 @@ static ssize_t part_start_show(struct device *dev,
 static ssize_t part_ro_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", dev_to_bdev(dev)->bd_read_only);
+	return sprintf(buf, "%d\n", bdev_read_only(dev_to_bdev(dev)));
 }
 
 static ssize_t part_alignment_offset_show(struct device *dev,
@@ -361,7 +361,6 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 
 	bdev->bd_start_sect = start;
 	bdev_set_nr_sectors(bdev, len);
-	bdev->bd_read_only = get_disk_ro(disk);
 
 	if (info) {
 		err = -ENOMEM;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 809aaa32d53cba..a62ccbfac54b48 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -163,6 +163,7 @@ struct gendisk {
 	int flags;
 	unsigned long state;
 #define GD_NEED_PART_SCAN		0
+#define GD_READ_ONLY			1
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
@@ -249,11 +250,12 @@ static inline void add_disk_no_queue_reg(struct gendisk *disk)
 extern void del_gendisk(struct gendisk *gp);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
 
-extern void set_disk_ro(struct gendisk *disk, int flag);
+void set_disk_ro(struct gendisk *disk, bool read_only);
 
 static inline int get_disk_ro(struct gendisk *disk)
 {
-	return disk->part0->bd_read_only;
+	return disk->part0->bd_read_only ||
+		test_bit(GD_READ_ONLY, &disk->state);
 }
 
 extern void disk_block_events(struct gendisk *disk);
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

