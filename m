Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C198CC49EA7
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5987B61C5D
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5987B61C5D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-6YpEfnSUOy6A1miH7Rtx-g-1; Mon, 28 Jun 2021 05:52:59 -0400
X-MC-Unique: 6YpEfnSUOy6A1miH7Rtx-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEDFD8030D6;
	Mon, 28 Jun 2021 09:52:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91A2F5C225;
	Mon, 28 Jun 2021 09:52:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6417E4EA3A;
	Mon, 28 Jun 2021 09:52:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15S03QTJ027073 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 27 Jun 2021 20:03:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1AA6121623A3; Mon, 28 Jun 2021 00:03:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 157D021623A6
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75743800B34
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:22 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-88-gLJcZbwgOVS5CrglmTwt6g-1; 
	Sun, 27 Jun 2021 20:03:17 -0400
X-MC-Unique: gLJcZbwgOVS5CrglmTwt6g-1
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AwNdcXaFyDuleE1rBpLqEDseALOsnbusQ8zAX?=
	=?us-ascii?q?P0AYc31om6uj5rmTdZUgpGfJYVkqKRIdcLy7V5VoBEmskaKdgrNhW4tKPjOW2l?=
	=?us-ascii?q?dARbsKheCJrlHd8m/Fh4lgPMxbE5SWZuefMbEDt7ee3OCnKadd/PC3tLCvmfzF?=
	=?us-ascii?q?z2pgCSVja6Rb5Q9/DQqBe3cGPjVuNN4oEoaG/Mpbq36FcXQTVM6yAX4IRKztvN?=
	=?us-ascii?q?vO/aiWHCIuNlo27hWUlzO05PrfGxic5B0XVDRC2vMD3AH+4nfE2pk=3D?=
X-IronPort-AV: E=Sophos;i="5.83,304,1616428800"; d="scan'208";a="110256365"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 28 Jun 2021 08:03:15 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 862014C36A09;
	Mon, 28 Jun 2021 08:03:11 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 28 Jun 2021 08:03:12 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Mon, 28 Jun 2021 08:03:12 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Mon, 28 Jun 2021 08:02:16 +0800
Message-ID: <20210628000218.387833-8-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 862014C36A09.AF525
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
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
X-Mailman-Approved-At: Mon, 28 Jun 2021 05:52:34 -0400
Cc: snitzer@redhat.com, darrick.wong@oracle.com, rgoldwyn@suse.de,
	david@fromorbit.com, dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v5 7/9] dm: Introduce ->rmap() to find bdev offset
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

Pmem device could be a target of mapped device.  In order to find out
the global location on a mapped device, we introduce this to translate
offset from target device to mapped device.

Currently, we implement it on linear target, which is easy to do the
translation.  Other targets will be supported in the future.  However,
some targets may not support it because of the non-linear mapping.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 block/genhd.c                 | 30 ++++++++++++++++++++++++++++++
 drivers/md/dm-linear.c        | 20 ++++++++++++++++++++
 include/linux/device-mapper.h |  5 +++++
 include/linux/genhd.h         |  1 +
 4 files changed, 56 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 9f8cb7beaad1..75834bd057df 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -718,6 +718,36 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
 	return bdev;
 }

+/**
+ * bdget_disk_sector - get block device by given sector number
+ * @disk: gendisk of interest
+ * @sector: sector number
+ *
+ * RETURNS: the found block device where sector locates in
+ */
+struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector)
+{
+	struct block_device *part = NULL, *p;
+	unsigned long idx;
+
+	rcu_read_lock();
+	xa_for_each(&disk->part_tbl, idx, p) {
+		if (p->bd_partno == 0)
+			continue;
+		if (p->bd_start_sect <= sector &&
+			sector < p->bd_start_sect + bdev_nr_sectors(p)) {
+			part = p;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	if (!part)
+		part = disk->part0;
+
+	return bdget_disk(disk, part->bd_partno);
+}
+EXPORT_SYMBOL(bdget_disk_sector);
+
 /*
  * print a full list of all partitions - intended for places where the root
  * filesystem can't be mounted and thus to give the victim some idea of what
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 92db0f5e7f28..f9f9bc765ba7 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -5,6 +5,7 @@
  */

 #include "dm.h"
+#include "dm-core.h"
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
@@ -119,6 +120,24 @@ static void linear_status(struct dm_target *ti, status_type_t type,
 	}
 }

+static int linear_rmap(struct dm_target *ti, sector_t offset,
+		       rmap_callout_fn fn, void *data)
+{
+	struct linear_c *lc = (struct linear_c *) ti->private;
+	struct mapped_device *md = ti->table->md;
+	struct block_device *bdev;
+	sector_t disk_sect = offset - dm_target_offset(ti, lc->start);
+	int rc = -ENODEV;
+
+	bdev = bdget_disk_sector(md->disk, offset);
+	if (!bdev)
+		return rc;
+
+	rc = fn(ti, bdev, disk_sect, data);
+	bdput(bdev);
+	return rc;
+}
+
 static int linear_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
 {
 	struct linear_c *lc = (struct linear_c *) ti->private;
@@ -236,6 +255,7 @@ static struct target_type linear_target = {
 	.ctr    = linear_ctr,
 	.dtr    = linear_dtr,
 	.map    = linear_map,
+	.rmap   = linear_rmap,
 	.status = linear_status,
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ff700fb6ce1d..89a893565407 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -58,6 +58,10 @@ typedef void (*dm_dtr_fn) (struct dm_target *ti);
  * = 2: The target wants to push back the io
  */
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio);
+typedef int (*rmap_callout_fn) (struct dm_target *ti, struct block_device *bdev,
+				sector_t sect, void *data);
+typedef int (*dm_rmap_fn) (struct dm_target *ti, sector_t offset,
+			   rmap_callout_fn fn, void *data);
 typedef int (*dm_clone_and_map_request_fn) (struct dm_target *ti,
 					    struct request *rq,
 					    union map_info *map_context,
@@ -184,6 +188,7 @@ struct target_type {
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
 	dm_map_fn map;
+	dm_rmap_fn rmap;
 	dm_clone_and_map_request_fn clone_and_map_rq;
 	dm_release_clone_request_fn release_clone_rq;
 	dm_endio_fn end_io;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6fc26f7bdf71..2ad70c02c343 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -219,6 +219,7 @@ static inline void add_disk_no_queue_reg(struct gendisk *disk)

 extern void del_gendisk(struct gendisk *gp);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
+extern struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector);

 void set_disk_ro(struct gendisk *disk, bool read_only);

--
2.32.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

