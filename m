Return-Path: <SRS0=XTDI=IK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B892CC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 16:21:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2DA7D64EC0
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 16:21:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DA7D64EC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-_-8luUwVNfy3y7WMuT15eQ-1; Fri, 12 Mar 2021 11:21:13 -0500
X-MC-Unique: _-8luUwVNfy3y7WMuT15eQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72931802B7F;
	Fri, 12 Mar 2021 16:21:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4869A163F4;
	Fri, 12 Mar 2021 16:21:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CD6AA57DC4;
	Fri, 12 Mar 2021 16:21:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12CFjUDB017716 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Mar 2021 10:45:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4254F1134CB8; Fri, 12 Mar 2021 15:45:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AF831134CBE
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 15:45:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A84E108BDC9
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 15:45:26 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-532--Ho6l87aMy6-rtkb91-Feg-1;
	Fri, 12 Mar 2021 10:45:23 -0500
X-MC-Unique: -Ho6l87aMy6-rtkb91-Feg-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id F1A3B88818;
	Fri, 12 Mar 2021 18:45:21 +0300 (MSK)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Fri, 12 Mar 2021 16:45:19 +0100
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, 
	Alasdair Kergon <agk@redhat.com>, Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>, <dm-devel@redhat.com>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-api@vger.kernel.org>
Date: Fri, 12 Mar 2021 18:44:55 +0300
Message-ID: <1615563895-28565-4-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1615563895-28565-1-git-send-email-sergei.shtepa@veeam.com>
References: <1615563895-28565-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B58627366
X-Veeam-MMEX: True
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: pavel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH v7 3/3] dm: add DM_INTERPOSED_FLAG
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

DM_INTERPOSED_FLAG allow to create DM targets on "the fly".
Underlying block device opens without a flag FMODE_EXCL.
DM target receives bio from the original device via
bdev_interposer.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 drivers/md/dm-core.h          |  3 ++
 drivers/md/dm-ioctl.c         | 13 ++++++++
 drivers/md/dm-table.c         | 61 +++++++++++++++++++++++++++++------
 drivers/md/dm.c               | 38 +++++++++++++++-------
 include/linux/device-mapper.h |  1 +
 include/uapi/linux/dm-ioctl.h |  6 ++++
 6 files changed, 101 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 5953ff2bd260..9eae419c7b18 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -114,6 +114,9 @@ struct mapped_device {
 	bool init_tio_pdu:1;
 
 	struct srcu_struct io_barrier;
+
+	/* attach target via block-layer interposer */
+	bool is_interposed;
 };
 
 void disable_discard(struct mapped_device *md);
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 5e306bba4375..2b4c9557c283 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1267,6 +1267,11 @@ static inline fmode_t get_mode(struct dm_ioctl *param)
 	return mode;
 }
 
+static inline bool get_interposer_flag(struct dm_ioctl *param)
+{
+	return (param->flags & DM_INTERPOSED_FLAG);
+}
+
 static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
 		       struct dm_target_spec **spec, char **target_params)
 {
@@ -1293,6 +1298,10 @@ static int populate_table(struct dm_table *table,
 		DMWARN("populate_table: no targets specified");
 		return -EINVAL;
 	}
+	if (table->md->is_interposed && (param->target_count != 1)) {
+		DMWARN("%s: with interposer should be specified only one target", __func__);
+		return -EINVAL;
+	}
 
 	for (i = 0; i < param->target_count; i++) {
 
@@ -1338,6 +1347,8 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
 	if (!md)
 		return -ENXIO;
 
+	md->is_interposed = get_interposer_flag(param);
+
 	r = dm_table_create(&t, get_mode(param), param->target_count, md);
 	if (r)
 		goto err;
@@ -2098,6 +2109,8 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 	if (r)
 		goto err_hash_remove;
 
+	md->is_interposed = get_interposer_flag(dmi);
+
 	/* add targets */
 	for (i = 0; i < dmi->target_count; i++) {
 		r = dm_table_add_target(t, spec_array[i]->target_type,
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 95391f78b8d5..f6e2eb3f8949 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -225,12 +225,13 @@ void dm_table_destroy(struct dm_table *t)
 /*
  * See if we've already got a device in the list.
  */
-static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
+static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev, bool is_interposed)
 {
 	struct dm_dev_internal *dd;
 
 	list_for_each_entry (dd, l, list)
-		if (dd->dm_dev->bdev->bd_dev == dev)
+		if ((dd->dm_dev->bdev->bd_dev == dev) &&
+		    (dd->dm_dev->is_interposed == is_interposed))
 			return dd;
 
 	return NULL;
@@ -358,6 +359,18 @@ dev_t dm_get_dev_t(const char *path)
 }
 EXPORT_SYMBOL_GPL(dm_get_dev_t);
 
+static inline void dm_disk_freeze(struct gendisk *disk)
+{
+	blk_mq_freeze_queue(disk->queue);
+	blk_mq_quiesce_queue(disk->queue);
+}
+
+static inline void dm_disk_unfreeze(struct gendisk *disk)
+{
+	blk_mq_unquiesce_queue(disk->queue);
+	blk_mq_unfreeze_queue(disk->queue);
+}
+
 /*
  * Add a device to the list, or just increment the usage count if
  * it's already present.
@@ -385,7 +398,7 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 			return -ENODEV;
 	}
 
-	dd = find_device(&t->devices, dev);
+	dd = find_device(&t->devices, dev, t->md->is_interposed);
 	if (!dd) {
 		dd = kmalloc(sizeof(*dd), GFP_KERNEL);
 		if (!dd)
@@ -398,15 +411,38 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 
 		refcount_set(&dd->count, 1);
 		list_add(&dd->list, &t->devices);
-		goto out;
-
 	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
 		r = upgrade_mode(dd, mode, t->md);
 		if (r)
 			return r;
+		refcount_inc(&dd->count);
 	}
-	refcount_inc(&dd->count);
-out:
+
+	if (t->md->is_interposed) {
+		struct block_device *original = dd->dm_dev->bdev;
+		struct block_device *interposer = t->md->disk->part0;
+
+		if ((ti->begin != 0) || (ti->len < bdev_nr_sectors(original))) {
+			dm_put_device(ti, dd->dm_dev);
+			DMERR("The interposer device should not be less than the original.");
+			return -EINVAL;
+		}
+
+		/*
+		 * Attach mapped interposer device to original.
+		 * It is quite convenient that device mapper creates
+		 * one disk for one block device.
+		 */
+		dm_disk_freeze(original->bd_disk);
+		r = bdev_interposer_attach(original, interposer);
+		dm_disk_unfreeze(original->bd_disk);
+		if (r) {
+			dm_put_device(ti, dd->dm_dev);
+			DMERR("Failed to attach dm interposer.");
+			return r;
+		}
+	}
+
 	*result = dd->dm_dev;
 	return 0;
 }
@@ -446,6 +482,7 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 {
 	int found = 0;
 	struct list_head *devices = &ti->table->devices;
+	struct mapped_device *md = ti->table->md;
 	struct dm_dev_internal *dd;
 
 	list_for_each_entry(dd, devices, list) {
@@ -456,11 +493,17 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 	}
 	if (!found) {
 		DMWARN("%s: device %s not in table devices list",
-		       dm_device_name(ti->table->md), d->name);
+		       dm_device_name(md), d->name);
 		return;
 	}
+	if (md->is_interposed) {
+		dm_disk_freeze(d->bdev->bd_disk);
+		bdev_interposer_detach(d->bdev);
+		dm_disk_unfreeze(d->bdev->bd_disk);
+	}
+
 	if (refcount_dec_and_test(&dd->count)) {
-		dm_put_table_device(ti->table->md, d);
+		dm_put_table_device(md, d);
 		list_del(&dd->list);
 		kfree(dd);
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 50b693d776d6..466bf70a66b0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -762,16 +762,24 @@ static int open_table_device(struct table_device *td, dev_t dev,
 
 	BUG_ON(td->dm_dev.bdev);
 
-	bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
-	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
+	if (md->is_interposed) {
 
-	r = bd_link_disk_holder(bdev, dm_disk(md));
-	if (r) {
-		blkdev_put(bdev, td->dm_dev.mode | FMODE_EXCL);
-		return r;
+		bdev = blkdev_get_by_dev(dev, td->dm_dev.mode, NULL);
+		if (IS_ERR(bdev))
+			return PTR_ERR(bdev);
+	} else {
+		bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
+		if (IS_ERR(bdev))
+			return PTR_ERR(bdev);
+
+		r = bd_link_disk_holder(bdev, dm_disk(md));
+		if (r) {
+			blkdev_put(bdev, td->dm_dev.mode | FMODE_EXCL);
+			return r;
+		}
 	}
 
+	td->dm_dev.is_interposed = md->is_interposed;
 	td->dm_dev.bdev = bdev;
 	td->dm_dev.dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
 	return 0;
@@ -785,20 +793,26 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
 	if (!td->dm_dev.bdev)
 		return;
 
-	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
-	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
+	if (td->dm_dev.is_interposed)
+		blkdev_put(td->dm_dev.bdev, td->dm_dev.mode);
+	else {
+		bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
+		blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
+	}
 	put_dax(td->dm_dev.dax_dev);
 	td->dm_dev.bdev = NULL;
 	td->dm_dev.dax_dev = NULL;
 }
 
 static struct table_device *find_table_device(struct list_head *l, dev_t dev,
-					      fmode_t mode)
+					      fmode_t mode, bool is_interposed)
 {
 	struct table_device *td;
 
 	list_for_each_entry(td, l, list)
-		if (td->dm_dev.bdev->bd_dev == dev && td->dm_dev.mode == mode)
+		if (td->dm_dev.bdev->bd_dev == dev &&
+		    td->dm_dev.mode == mode &&
+		    td->dm_dev.is_interposed == is_interposed)
 			return td;
 
 	return NULL;
@@ -811,7 +825,7 @@ int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
 	struct table_device *td;
 
 	mutex_lock(&md->table_devices_lock);
-	td = find_table_device(&md->table_devices, dev, mode);
+	td = find_table_device(&md->table_devices, dev, mode, md->is_interposed);
 	if (!td) {
 		td = kmalloc_node(sizeof(*td), GFP_KERNEL, md->numa_node_id);
 		if (!td) {
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 7f4ac87c0b32..76a6dfb1cb29 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -159,6 +159,7 @@ struct dm_dev {
 	struct block_device *bdev;
 	struct dax_device *dax_dev;
 	fmode_t mode;
+	bool is_interposed;
 	char name[16];
 };
 
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index fcff6669137b..fc4d06bb3dbb 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -362,4 +362,10 @@ enum {
  */
 #define DM_INTERNAL_SUSPEND_FLAG	(1 << 18) /* Out */
 
+/*
+ * If set, the underlying device should open without FMODE_EXCL
+ * and attach mapped device via bdev_interposer.
+ */
+#define DM_INTERPOSED_FLAG		(1 << 19) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

