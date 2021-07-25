Return-Path: <SRS0=Go1D=MR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045EDC4320A
	for <dm-devel@archiver.kernel.org>; Sun, 25 Jul 2021 06:00:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7DD7660F11
	for <dm-devel@archiver.kernel.org>; Sun, 25 Jul 2021 06:00:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7DD7660F11
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-8vy_x98WNZ2dtkhds4QfQA-1; Sun, 25 Jul 2021 02:00:07 -0400
X-MC-Unique: 8vy_x98WNZ2dtkhds4QfQA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FEFA190A7AB;
	Sun, 25 Jul 2021 05:59:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1759B6E6E1;
	Sun, 25 Jul 2021 05:59:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D84D5180BAB3;
	Sun, 25 Jul 2021 05:59:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16P5vKAB010463 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 25 Jul 2021 01:57:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3A6FF2166BA3; Sun, 25 Jul 2021 05:57:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 350C12166B49
	for <dm-devel@redhat.com>; Sun, 25 Jul 2021 05:57:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18AA5800883
	for <dm-devel@redhat.com>; Sun, 25 Jul 2021 05:57:20 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-587-psR3qwIMOqqU6A-Hq4i_hg-1; Sun, 25 Jul 2021 01:57:16 -0400
X-MC-Unique: psR3qwIMOqqU6A-Hq4i_hg-1
Received: from [2001:4bb8:184:87c5:a8b3:bdfd:fc9b:6250] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m7X6d-00Cpgb-CZ; Sun, 25 Jul 2021 05:55:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Sun, 25 Jul 2021 07:54:51 +0200
Message-Id: <20210725055458.29008-2-hch@lst.de>
In-Reply-To: <20210725055458.29008-1-hch@lst.de>
References: <20210725055458.29008-1-hch@lst.de>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 1/8] block: make the block holder code optional
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move the block holder code into a separate file as it is not in any way
related to the other block_dev.c code, and add a new selectable config
option for it so that we don't have to build it without any remapped
drivers selected.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/Kconfig             |   4 ++
 block/Makefile            |   1 +
 block/holder.c            | 139 ++++++++++++++++++++++++++++++++++++
 drivers/md/Kconfig        |   2 +
 drivers/md/bcache/Kconfig |   1 +
 fs/block_dev.c            | 144 +-------------------------------------
 include/linux/blk_types.h |   2 +-
 include/linux/genhd.h     |   4 +-
 8 files changed, 151 insertions(+), 146 deletions(-)
 create mode 100644 block/holder.c

diff --git a/block/Kconfig b/block/Kconfig
index fd732aede922..a24d7263d1fc 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -251,4 +251,8 @@ config BLK_MQ_RDMA
 config BLK_PM
 	def_bool BLOCK && PM
 
+# do not use in new code
+config BLOCK_HOLDER_DEPRECATED
+	bool
+
 source "block/Kconfig.iosched"
diff --git a/block/Makefile b/block/Makefile
index bfbe4e13ca1e..6fc6216634ed 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_BLK_SED_OPAL)	+= sed-opal.o
 obj-$(CONFIG_BLK_PM)		+= blk-pm.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= keyslot-manager.o blk-crypto.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
+obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
diff --git a/block/holder.c b/block/holder.c
new file mode 100644
index 000000000000..904a1dcd5c12
--- /dev/null
+++ b/block/holder.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/genhd.h>
+
+struct bd_holder_disk {
+	struct list_head	list;
+	struct gendisk		*disk;
+	int			refcnt;
+};
+
+static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
+						  struct gendisk *disk)
+{
+	struct bd_holder_disk *holder;
+
+	list_for_each_entry(holder, &bdev->bd_holder_disks, list)
+		if (holder->disk == disk)
+			return holder;
+	return NULL;
+}
+
+static int add_symlink(struct kobject *from, struct kobject *to)
+{
+	return sysfs_create_link(from, to, kobject_name(to));
+}
+
+static void del_symlink(struct kobject *from, struct kobject *to)
+{
+	sysfs_remove_link(from, kobject_name(to));
+}
+
+/**
+ * bd_link_disk_holder - create symlinks between holding disk and slave bdev
+ * @bdev: the claimed slave bdev
+ * @disk: the holding disk
+ *
+ * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
+ *
+ * This functions creates the following sysfs symlinks.
+ *
+ * - from "slaves" directory of the holder @disk to the claimed @bdev
+ * - from "holders" directory of the @bdev to the holder @disk
+ *
+ * For example, if /dev/dm-0 maps to /dev/sda and disk for dm-0 is
+ * passed to bd_link_disk_holder(), then:
+ *
+ *   /sys/block/dm-0/slaves/sda --> /sys/block/sda
+ *   /sys/block/sda/holders/dm-0 --> /sys/block/dm-0
+ *
+ * The caller must have claimed @bdev before calling this function and
+ * ensure that both @bdev and @disk are valid during the creation and
+ * lifetime of these symlinks.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
+{
+	struct bd_holder_disk *holder;
+	int ret = 0;
+
+	mutex_lock(&bdev->bd_disk->open_mutex);
+
+	WARN_ON_ONCE(!bdev->bd_holder);
+
+	/* FIXME: remove the following once add_disk() handles errors */
+	if (WARN_ON(!disk->slave_dir || !bdev->bd_holder_dir))
+		goto out_unlock;
+
+	holder = bd_find_holder_disk(bdev, disk);
+	if (holder) {
+		holder->refcnt++;
+		goto out_unlock;
+	}
+
+	holder = kzalloc(sizeof(*holder), GFP_KERNEL);
+	if (!holder) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	INIT_LIST_HEAD(&holder->list);
+	holder->disk = disk;
+	holder->refcnt = 1;
+
+	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
+	if (ret)
+		goto out_free;
+
+	ret = add_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
+	if (ret)
+		goto out_del;
+	/*
+	 * bdev could be deleted beneath us which would implicitly destroy
+	 * the holder directory.  Hold on to it.
+	 */
+	kobject_get(bdev->bd_holder_dir);
+
+	list_add(&holder->list, &bdev->bd_holder_disks);
+	goto out_unlock;
+
+out_del:
+	del_symlink(disk->slave_dir, bdev_kobj(bdev));
+out_free:
+	kfree(holder);
+out_unlock:
+	mutex_unlock(&bdev->bd_disk->open_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bd_link_disk_holder);
+
+/**
+ * bd_unlink_disk_holder - destroy symlinks created by bd_link_disk_holder()
+ * @bdev: the calimed slave bdev
+ * @disk: the holding disk
+ *
+ * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
+ *
+ * CONTEXT:
+ * Might sleep.
+ */
+void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
+{
+	struct bd_holder_disk *holder;
+
+	mutex_lock(&bdev->bd_disk->open_mutex);
+	holder = bd_find_holder_disk(bdev, disk);
+	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
+		del_symlink(disk->slave_dir, bdev_kobj(bdev));
+		del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
+		kobject_put(bdev->bd_holder_dir);
+		list_del_init(&holder->list);
+		kfree(holder);
+	}
+	mutex_unlock(&bdev->bd_disk->open_mutex);
+}
+EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 0602e82a9516..f821dae101a9 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -15,6 +15,7 @@ if MD
 
 config BLK_DEV_MD
 	tristate "RAID support"
+	select BLOCK_HOLDER_DEPRECATED if SYSFS
 	help
 	  This driver lets you combine several hard disk partitions into one
 	  logical block device. This can be used to simply append one
@@ -201,6 +202,7 @@ config BLK_DEV_DM_BUILTIN
 
 config BLK_DEV_DM
 	tristate "Device mapper support"
+	select BLOCK_HOLDER_DEPRECATED if SYSFS
 	select BLK_DEV_DM_BUILTIN
 	depends on DAX || DAX=n
 	help
diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index d1ca4d059c20..cf3e8096942a 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -2,6 +2,7 @@
 
 config BCACHE
 	tristate "Block device as cache"
+	select BLOCK_HOLDER_DEPRECATED if SYSFS
 	select CRC64
 	help
 	Allows a block device to be used as cache for other devices; uses
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 0c424a0cadaa..7825d152634e 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -900,7 +900,7 @@ struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
 	bdev->bd_disk = disk;
 	bdev->bd_partno = partno;
 	bdev->bd_inode = inode;
-#ifdef CONFIG_SYSFS
+#ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
 	INIT_LIST_HEAD(&bdev->bd_holder_disks);
 #endif
 	bdev->bd_stats = alloc_percpu(struct disk_stats);
@@ -1092,148 +1092,6 @@ void bd_abort_claiming(struct block_device *bdev, void *holder)
 }
 EXPORT_SYMBOL(bd_abort_claiming);
 
-#ifdef CONFIG_SYSFS
-struct bd_holder_disk {
-	struct list_head	list;
-	struct gendisk		*disk;
-	int			refcnt;
-};
-
-static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
-						  struct gendisk *disk)
-{
-	struct bd_holder_disk *holder;
-
-	list_for_each_entry(holder, &bdev->bd_holder_disks, list)
-		if (holder->disk == disk)
-			return holder;
-	return NULL;
-}
-
-static int add_symlink(struct kobject *from, struct kobject *to)
-{
-	return sysfs_create_link(from, to, kobject_name(to));
-}
-
-static void del_symlink(struct kobject *from, struct kobject *to)
-{
-	sysfs_remove_link(from, kobject_name(to));
-}
-
-/**
- * bd_link_disk_holder - create symlinks between holding disk and slave bdev
- * @bdev: the claimed slave bdev
- * @disk: the holding disk
- *
- * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
- *
- * This functions creates the following sysfs symlinks.
- *
- * - from "slaves" directory of the holder @disk to the claimed @bdev
- * - from "holders" directory of the @bdev to the holder @disk
- *
- * For example, if /dev/dm-0 maps to /dev/sda and disk for dm-0 is
- * passed to bd_link_disk_holder(), then:
- *
- *   /sys/block/dm-0/slaves/sda --> /sys/block/sda
- *   /sys/block/sda/holders/dm-0 --> /sys/block/dm-0
- *
- * The caller must have claimed @bdev before calling this function and
- * ensure that both @bdev and @disk are valid during the creation and
- * lifetime of these symlinks.
- *
- * CONTEXT:
- * Might sleep.
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
-{
-	struct bd_holder_disk *holder;
-	int ret = 0;
-
-	mutex_lock(&bdev->bd_disk->open_mutex);
-
-	WARN_ON_ONCE(!bdev->bd_holder);
-
-	/* FIXME: remove the following once add_disk() handles errors */
-	if (WARN_ON(!disk->slave_dir || !bdev->bd_holder_dir))
-		goto out_unlock;
-
-	holder = bd_find_holder_disk(bdev, disk);
-	if (holder) {
-		holder->refcnt++;
-		goto out_unlock;
-	}
-
-	holder = kzalloc(sizeof(*holder), GFP_KERNEL);
-	if (!holder) {
-		ret = -ENOMEM;
-		goto out_unlock;
-	}
-
-	INIT_LIST_HEAD(&holder->list);
-	holder->disk = disk;
-	holder->refcnt = 1;
-
-	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
-	if (ret)
-		goto out_free;
-
-	ret = add_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
-	if (ret)
-		goto out_del;
-	/*
-	 * bdev could be deleted beneath us which would implicitly destroy
-	 * the holder directory.  Hold on to it.
-	 */
-	kobject_get(bdev->bd_holder_dir);
-
-	list_add(&holder->list, &bdev->bd_holder_disks);
-	goto out_unlock;
-
-out_del:
-	del_symlink(disk->slave_dir, bdev_kobj(bdev));
-out_free:
-	kfree(holder);
-out_unlock:
-	mutex_unlock(&bdev->bd_disk->open_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(bd_link_disk_holder);
-
-/**
- * bd_unlink_disk_holder - destroy symlinks created by bd_link_disk_holder()
- * @bdev: the calimed slave bdev
- * @disk: the holding disk
- *
- * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
- *
- * CONTEXT:
- * Might sleep.
- */
-void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
-{
-	struct bd_holder_disk *holder;
-
-	mutex_lock(&bdev->bd_disk->open_mutex);
-
-	holder = bd_find_holder_disk(bdev, disk);
-
-	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
-		del_symlink(disk->slave_dir, bdev_kobj(bdev));
-		del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
-		kobject_put(bdev->bd_holder_dir);
-		list_del_init(&holder->list);
-		kfree(holder);
-	}
-
-	mutex_unlock(&bdev->bd_disk->open_mutex);
-}
-EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
-#endif
-
 static void blkdev_flush_mapping(struct block_device *bdev)
 {
 	WARN_ON_ONCE(bdev->bd_holders);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 290f9061b29a..7a4e139d24ef 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -34,7 +34,7 @@ struct block_device {
 	void *			bd_holder;
 	int			bd_holders;
 	bool			bd_write_holder;
-#ifdef CONFIG_SYSFS
+#ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
 	struct list_head	bd_holder_disks;
 #endif
 	struct kobject		*bd_holder_dir;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 13b34177cc85..6831d74f2002 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -316,7 +316,7 @@ void set_capacity(struct gendisk *disk, sector_t size);
 int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
 long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
 
-#ifdef CONFIG_SYSFS
+#ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
 void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk);
 #else
@@ -329,7 +329,7 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev,
 					 struct gendisk *disk)
 {
 }
-#endif /* CONFIG_SYSFS */
+#endif /* CONFIG_BLOCK_HOLDER_DEPRECATED */
 
 dev_t part_devt(struct gendisk *disk, u8 partno);
 dev_t blk_lookup_devt(const char *name, int partno);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

