Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21094C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 08:59:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA3A8610A6
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 08:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BA3A8610A6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-f-P43_7oPuO47tICTkUz5A-1; Tue, 09 Nov 2021 03:59:26 -0500
X-MC-Unique: f-P43_7oPuO47tICTkUz5A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 205BC804143;
	Tue,  9 Nov 2021 08:59:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBA0D19733;
	Tue,  9 Nov 2021 08:59:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E39E84A703;
	Tue,  9 Nov 2021 08:59:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A98xCPk017327 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 03:59:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D49514047279; Tue,  9 Nov 2021 08:59:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D0D884047272
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 08:59:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B51B4811E80
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 08:59:12 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-190-jcvnLFeONXe8H3GA40sKwA-1; Tue, 09 Nov 2021 03:59:11 -0500
X-MC-Unique: jcvnLFeONXe8H3GA40sKwA-1
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZF-000ryO-3U; Tue, 09 Nov 2021 08:33:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Tue,  9 Nov 2021 09:32:44 +0100
Message-Id: <20211109083309.584081-5-hch@lst.de>
In-Reply-To: <20211109083309.584081-1-hch@lst.de>
References: <20211109083309.584081-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 04/29] dax: simplify the dax_device <-> gendisk
	association
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

Replace the dax_host_hash with an xarray indexed by the pointer value
of the gendisk, and require explicitly calls from the block drivers that
want to associate their gendisk with a dax_device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/dax/bus.c            |   6 +-
 drivers/dax/super.c          | 106 +++++++++--------------------------
 drivers/md/dm.c              |   6 +-
 drivers/nvdimm/pmem.c        |   8 ++-
 drivers/s390/block/dcssblk.c |  11 +++-
 fs/fuse/virtio_fs.c          |   2 +-
 include/linux/dax.h          |  19 +++++--
 7 files changed, 62 insertions(+), 96 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 6cc4da4c713d9..bd7af2f7c5b0a 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1323,10 +1323,10 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 	}
 
 	/*
-	 * No 'host' or dax_operations since there is no access to this
-	 * device outside of mmap of the resulting character device.
+	 * No dax_operations since there is no access to this device outside of
+	 * mmap of the resulting character device.
 	 */
-	dax_dev = alloc_dax(dev_dax, NULL, NULL, DAXDEV_F_SYNC);
+	dax_dev = alloc_dax(dev_dax, NULL, DAXDEV_F_SYNC);
 	if (IS_ERR(dax_dev)) {
 		rc = PTR_ERR(dax_dev);
 		goto err_alloc_dax;
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e20d0cef10a18..9383c11b21853 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -7,10 +7,8 @@
 #include <linux/mount.h>
 #include <linux/pseudo_fs.h>
 #include <linux/magic.h>
-#include <linux/genhd.h>
 #include <linux/pfn_t.h>
 #include <linux/cdev.h>
-#include <linux/hash.h>
 #include <linux/slab.h>
 #include <linux/uio.h>
 #include <linux/dax.h>
@@ -26,10 +24,8 @@
  * @flags: state and boolean properties
  */
 struct dax_device {
-	struct hlist_node list;
 	struct inode inode;
 	struct cdev cdev;
-	const char *host;
 	void *private;
 	unsigned long flags;
 	const struct dax_operations *ops;
@@ -42,10 +38,6 @@ static DEFINE_IDA(dax_minor_ida);
 static struct kmem_cache *dax_cache __read_mostly;
 static struct super_block *dax_superblock __read_mostly;
 
-#define DAX_HASH_SIZE (PAGE_SIZE / sizeof(struct hlist_head))
-static struct hlist_head dax_host_list[DAX_HASH_SIZE];
-static DEFINE_SPINLOCK(dax_host_lock);
-
 int dax_read_lock(void)
 {
 	return srcu_read_lock(&dax_srcu);
@@ -58,13 +50,22 @@ void dax_read_unlock(int id)
 }
 EXPORT_SYMBOL_GPL(dax_read_unlock);
 
-static int dax_host_hash(const char *host)
+#if defined(CONFIG_BLOCK) && defined(CONFIG_FS_DAX)
+#include <linux/blkdev.h>
+
+static DEFINE_XARRAY(dax_hosts);
+
+int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk)
 {
-	return hashlen_hash(hashlen_string("DAX", host)) % DAX_HASH_SIZE;
+	return xa_insert(&dax_hosts, (unsigned long)disk, dax_dev, GFP_KERNEL);
 }
+EXPORT_SYMBOL_GPL(dax_add_host);
 
-#if defined(CONFIG_BLOCK) && defined(CONFIG_FS_DAX)
-#include <linux/blkdev.h>
+void dax_remove_host(struct gendisk *disk)
+{
+	xa_erase(&dax_hosts, (unsigned long)disk);
+}
+EXPORT_SYMBOL_GPL(dax_remove_host);
 
 int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
 		pgoff_t *pgoff)
@@ -82,40 +83,23 @@ EXPORT_SYMBOL(bdev_dax_pgoff);
 
 /**
  * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
- * @host: alternate name for the device registered by a dax driver
+ * @bdev: block device to find a dax_device for
  */
-static struct dax_device *dax_get_by_host(const char *host)
+struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
 {
-	struct dax_device *dax_dev, *found = NULL;
-	int hash, id;
+	struct dax_device *dax_dev;
+	int id;
 
-	if (!host)
+	if (!blk_queue_dax(bdev->bd_disk->queue))
 		return NULL;
 
-	hash = dax_host_hash(host);
-
 	id = dax_read_lock();
-	spin_lock(&dax_host_lock);
-	hlist_for_each_entry(dax_dev, &dax_host_list[hash], list) {
-		if (!dax_alive(dax_dev)
-				|| strcmp(host, dax_dev->host) != 0)
-			continue;
-
-		if (igrab(&dax_dev->inode))
-			found = dax_dev;
-		break;
-	}
-	spin_unlock(&dax_host_lock);
+	dax_dev = xa_load(&dax_hosts, (unsigned long)bdev->bd_disk);
+	if (!dax_dev || !dax_alive(dax_dev) || !igrab(&dax_dev->inode))
+		dax_dev = NULL;
 	dax_read_unlock(id);
 
-	return found;
-}
-
-struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
-{
-	if (!blk_queue_dax(bdev->bd_disk->queue))
-		return NULL;
-	return dax_get_by_host(bdev->bd_disk->disk_name);
+	return dax_dev;
 }
 EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
 
@@ -361,12 +345,7 @@ void kill_dax(struct dax_device *dax_dev)
 		return;
 
 	clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
-
 	synchronize_srcu(&dax_srcu);
-
-	spin_lock(&dax_host_lock);
-	hlist_del_init(&dax_dev->list);
-	spin_unlock(&dax_host_lock);
 }
 EXPORT_SYMBOL_GPL(kill_dax);
 
@@ -398,8 +377,6 @@ static struct dax_device *to_dax_dev(struct inode *inode)
 static void dax_free_inode(struct inode *inode)
 {
 	struct dax_device *dax_dev = to_dax_dev(inode);
-	kfree(dax_dev->host);
-	dax_dev->host = NULL;
 	if (inode->i_rdev)
 		ida_simple_remove(&dax_minor_ida, iminor(inode));
 	kmem_cache_free(dax_cache, dax_dev);
@@ -474,54 +451,25 @@ static struct dax_device *dax_dev_get(dev_t devt)
 	return dax_dev;
 }
 
-static void dax_add_host(struct dax_device *dax_dev, const char *host)
-{
-	int hash;
-
-	/*
-	 * Unconditionally init dax_dev since it's coming from a
-	 * non-zeroed slab cache
-	 */
-	INIT_HLIST_NODE(&dax_dev->list);
-	dax_dev->host = host;
-	if (!host)
-		return;
-
-	hash = dax_host_hash(host);
-	spin_lock(&dax_host_lock);
-	hlist_add_head(&dax_dev->list, &dax_host_list[hash]);
-	spin_unlock(&dax_host_lock);
-}
-
-struct dax_device *alloc_dax(void *private, const char *__host,
-		const struct dax_operations *ops, unsigned long flags)
+struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
+		unsigned long flags)
 {
 	struct dax_device *dax_dev;
-	const char *host;
 	dev_t devt;
 	int minor;
 
-	if (ops && !ops->zero_page_range) {
-		pr_debug("%s: error: device does not provide dax"
-			 " operation zero_page_range()\n",
-			 __host ? __host : "Unknown");
+	if (WARN_ON_ONCE(ops && !ops->zero_page_range))
 		return ERR_PTR(-EINVAL);
-	}
-
-	host = kstrdup(__host, GFP_KERNEL);
-	if (__host && !host)
-		return ERR_PTR(-ENOMEM);
 
 	minor = ida_simple_get(&dax_minor_ida, 0, MINORMASK+1, GFP_KERNEL);
 	if (minor < 0)
-		goto err_minor;
+		return ERR_PTR(-ENOMEM);
 
 	devt = MKDEV(MAJOR(dax_devt), minor);
 	dax_dev = dax_dev_get(devt);
 	if (!dax_dev)
 		goto err_dev;
 
-	dax_add_host(dax_dev, host);
 	dax_dev->ops = ops;
 	dax_dev->private = private;
 	if (flags & DAXDEV_F_SYNC)
@@ -531,8 +479,6 @@ struct dax_device *alloc_dax(void *private, const char *__host,
 
  err_dev:
 	ida_simple_remove(&dax_minor_ida, minor);
- err_minor:
-	kfree(host);
 	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(alloc_dax);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 893fca738a3d8..782a076f61f81 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1683,6 +1683,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
 	bioset_exit(&md->io_bs);
 
 	if (md->dax_dev) {
+		dax_remove_host(md->disk);
 		kill_dax(md->dax_dev);
 		put_dax(md->dax_dev);
 		md->dax_dev = NULL;
@@ -1784,10 +1785,11 @@ static struct mapped_device *alloc_dev(int minor)
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
 	if (IS_ENABLED(CONFIG_FS_DAX)) {
-		md->dax_dev = alloc_dax(md, md->disk->disk_name,
-					&dm_dax_ops, 0);
+		md->dax_dev = alloc_dax(md, &dm_dax_ops, 0);
 		if (IS_ERR(md->dax_dev))
 			goto bad;
+		if (dax_add_host(md->dax_dev, md->disk))
+			goto bad;
 	}
 
 	format_dev_t(md->name, MKDEV(_major, minor));
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 9cc0d0ebfad16..8783ad7370856 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -379,6 +379,7 @@ static void pmem_release_disk(void *__pmem)
 {
 	struct pmem_device *pmem = __pmem;
 
+	dax_remove_host(pmem->disk);
 	kill_dax(pmem->dax_dev);
 	put_dax(pmem->dax_dev);
 	del_gendisk(pmem->disk);
@@ -495,10 +496,11 @@ static int pmem_attach_disk(struct device *dev,
 
 	if (is_nvdimm_sync(nd_region))
 		flags = DAXDEV_F_SYNC;
-	dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops, flags);
-	if (IS_ERR(dax_dev)) {
+	dax_dev = alloc_dax(pmem, &pmem_dax_ops, flags);
+	if (IS_ERR(dax_dev))
 		return PTR_ERR(dax_dev);
-	}
+	if (dax_add_host(dax_dev, disk))
+		return -ENOMEM;
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	pmem->dax_dev = dax_dev;
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 27ab888b44d0a..657e492f2bc26 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -687,18 +687,21 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	if (rc)
 		goto put_dev;
 
-	dev_info->dax_dev = alloc_dax(dev_info, dev_info->gd->disk_name,
-			&dcssblk_dax_ops, DAXDEV_F_SYNC);
+	dev_info->dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops,
+			DAXDEV_F_SYNC);
 	if (IS_ERR(dev_info->dax_dev)) {
 		rc = PTR_ERR(dev_info->dax_dev);
 		dev_info->dax_dev = NULL;
 		goto put_dev;
 	}
+	rc = dax_add_host(dev_info->dax_dev, dev_info->gd);
+	if (rc)
+		goto out_dax;
 
 	get_device(&dev_info->dev);
 	rc = device_add_disk(&dev_info->dev, dev_info->gd, NULL);
 	if (rc)
-		goto out_dax;
+		goto out_dax_host;
 
 	switch (dev_info->segment_type) {
 		case SEG_TYPE_SR:
@@ -714,6 +717,8 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	rc = count;
 	goto out;
 
+out_dax_host:
+	dax_remove_host(dev_info->gd);
 out_dax:
 	put_device(&dev_info->dev);
 	kill_dax(dev_info->dax_dev);
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 94fc874f5de7f..b4c7c7fa987f8 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -850,7 +850,7 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
 	dev_dbg(&vdev->dev, "%s: window kaddr 0x%px phys_addr 0x%llx len 0x%llx\n",
 		__func__, fs->window_kaddr, cache_reg.addr, cache_reg.len);
 
-	fs->dax_dev = alloc_dax(fs, NULL, &virtio_fs_dax_ops, 0);
+	fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops, 0);
 	if (IS_ERR(fs->dax_dev))
 		return PTR_ERR(fs->dax_dev);
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 8623caa673889..e2e9a67004cbd 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -11,9 +11,11 @@
 
 typedef unsigned long dax_entry_t;
 
+struct dax_device;
+struct gendisk;
 struct iomap_ops;
 struct iomap;
-struct dax_device;
+
 struct dax_operations {
 	/*
 	 * direct_access: translate a device-relative
@@ -39,8 +41,8 @@ struct dax_operations {
 };
 
 #if IS_ENABLED(CONFIG_DAX)
-struct dax_device *alloc_dax(void *private, const char *host,
-		const struct dax_operations *ops, unsigned long flags);
+struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
+		unsigned long flags);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
@@ -68,7 +70,7 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
 	return dax_synchronous(dax_dev);
 }
 #else
-static inline struct dax_device *alloc_dax(void *private, const char *host,
+static inline struct dax_device *alloc_dax(void *private,
 		const struct dax_operations *ops, unsigned long flags)
 {
 	/*
@@ -107,6 +109,8 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
 struct writeback_control;
 int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
 #if IS_ENABLED(CONFIG_FS_DAX)
+int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk);
+void dax_remove_host(struct gendisk *disk);
 bool generic_fsdax_supported(struct dax_device *dax_dev,
 		struct block_device *bdev, int blocksize, sector_t start,
 		sector_t sectors);
@@ -128,6 +132,13 @@ struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t st
 dax_entry_t dax_lock_page(struct page *page);
 void dax_unlock_page(struct page *page, dax_entry_t cookie);
 #else
+static inline int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk)
+{
+	return 0;
+}
+static inline void dax_remove_host(struct gendisk *disk)
+{
+}
 #define generic_fsdax_supported		NULL
 
 static inline bool dax_supported(struct dax_device *dax_dev,
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

