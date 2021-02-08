Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3364C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:37:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2A4EB64E2F
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:37:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A4EB64E2F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-RuCRvoZ_N_6lrh2byJRkQw-1; Wed, 17 Feb 2021 10:37:27 -0500
X-MC-Unique: RuCRvoZ_N_6lrh2byJRkQw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D101D801984;
	Wed, 17 Feb 2021 15:37:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE5045D74E;
	Wed, 17 Feb 2021 15:37:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7C65858073;
	Wed, 17 Feb 2021 15:37:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 118Atltj011308 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 05:55:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5F9C12166B32; Mon,  8 Feb 2021 10:55:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 593E12166B2C
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 10:55:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5F82800B28
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 10:55:44 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-222-2jFVmccDOVuDySGYNw8Bbg-1;
	Mon, 08 Feb 2021 05:55:42 -0500
X-MC-Unique: 2jFVmccDOVuDySGYNw8Bbg-1
X-IronPort-AV: E=Sophos;i="5.81,161,1610380800"; d="scan'208";a="104328064"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 08 Feb 2021 18:55:40 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 58EDC4CE6F82;
	Mon,  8 Feb 2021 18:55:37 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 8 Feb 2021 18:55:40 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Mon, 8 Feb 2021 18:55:39 +0800
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Mon, 8 Feb 2021 18:55:23 +0800
Message-ID: <20210208105530.3072869-5-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 58EDC4CE6F82.A0C98
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
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
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: qi.fuli@fujitsu.com, snitzer@redhat.com, darrick.wong@oracle.com,
	rgoldwyn@suse.de, david@fromorbit.com, y-goto@fujitsu.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v3 04/11] block_dev: Introduce
	bd_corrupted_range() for block device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

As is show in the call tree:
 ...
 pgmap->ops->memory_failure()
  gendisk->fops->corrupted_range()
   sb->s_ops->currupted_range()
    ...
currupted_range() is called from disk(pmem) to superblock(filesystem).
Thus, we need to introduce a helper function to obtain the superblock
from a given disk.

Normally, a filesystem can be created by mkfs directly on a block device
or a parted disk. We can obtain the superblock by calling get_super().

But get_super() is not suitable for mapped device, such as LVM. To
obtain MD's superblock, we can iterate bd_holder_disks of a block device
to find out the MD that contains it. By this way, MD is able to call
corrupted_range() from its target block device.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/block_dev.c        | 47 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/genhd.h |  2 ++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 3b8963e228a1..755b0d351479 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1079,6 +1079,28 @@ struct bd_holder_disk {
 	int			refcnt;
 };
 
+static int bd_disk_holder_corrupted_range(struct block_device *bdev, loff_t off,
+					  size_t len, void *data)
+{
+	struct bd_holder_disk *holder;
+	struct gendisk *disk;
+	int rc = 0;
+
+	if (list_empty(&(bdev->bd_holder_disks)))
+		return -ENODEV;
+
+	list_for_each_entry(holder, &bdev->bd_holder_disks, list) {
+		disk = holder->disk;
+		if (disk->fops->corrupted_range) {
+			rc = disk->fops->corrupted_range(disk, bdev, off,
+							 len, data);
+			if (rc != -ENODEV)
+				break;
+		}
+	}
+	return rc;
+}
+
 static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
 						  struct gendisk *disk)
 {
@@ -1212,7 +1234,30 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	mutex_unlock(&bdev->bd_mutex);
 }
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
-#endif
+#else
+static inline int bd_disk_holder_corrupted_range(struct block_device *bdev,
+					loff_t off, size_t len, void *data)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_SYSFS */
+
+int bd_corrupted_range(struct block_device *bdev, loff_t disk_off,
+		       loff_t bdev_off, size_t len, void *data)
+{
+	struct super_block *sb = get_super(bdev);
+	int rc = -EOPNOTSUPP;
+
+	if (!sb) {
+		rc = bd_disk_holder_corrupted_range(bdev, disk_off, len, data);
+		return rc;
+	} else if (sb->s_op->corrupted_range)
+		rc = sb->s_op->corrupted_range(sb, bdev, bdev_off, len, data);
+	drop_super(sb);
+
+	return rc;
+}
+EXPORT_SYMBOL(bd_corrupted_range);
 
 static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part);
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 809aaa32d53c..751cbd559bba 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -314,6 +314,8 @@ void unregister_blkdev(unsigned int major, const char *name);
 bool bdev_check_media_change(struct block_device *bdev);
 int __invalidate_device(struct block_device *bdev, bool kill_dirty);
 void set_capacity(struct gendisk *disk, sector_t size);
+int bd_corrupted_range(struct block_device *bdev, loff_t disk_off,
+		       loff_t bdev_off, size_t len, void *data);
 
 /* for drivers/char/raw.c: */
 int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
-- 
2.30.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

