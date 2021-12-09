Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD23C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  9 Dec 2021 07:03:19 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-GGNxSEkeMtSYuyo_lzDYCg-1; Thu, 09 Dec 2021 02:03:15 -0500
X-MC-Unique: GGNxSEkeMtSYuyo_lzDYCg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72778801B35;
	Thu,  9 Dec 2021 07:03:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 566ED19D9D;
	Thu,  9 Dec 2021 07:03:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 249C84CA93;
	Thu,  9 Dec 2021 07:03:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B96xHYI015164 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 9 Dec 2021 01:59:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1E2EE40CFD11; Thu,  9 Dec 2021 06:59:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18F6840CFD07
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 06:59:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3A1E802802
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 06:59:16 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-384-IXPZnJAXOs2sAb5H3L7VvQ-1; Thu, 09 Dec 2021 01:59:13 -0500
X-MC-Unique: IXPZnJAXOs2sAb5H3L7VvQ-1
Received: from [2001:4bb8:180:a1c8:2d0e:135:af53:41f8] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mvD4a-0096hg-92; Thu, 09 Dec 2021 06:38:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Date: Thu,  9 Dec 2021 07:38:26 +0100
Message-Id: <20211209063828.18944-4-hch@lst.de>
In-Reply-To: <20211209063828.18944-1-hch@lst.de>
References: <20211209063828.18944-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	linux-fsdevel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH 3/5] dax: remove the DAXDEV_F_SYNC flag
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

Remove the DAXDEV_F_SYNC flag and thus the flags argument to alloc_dax and
just let the drivers call set_dax_synchronous directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/dax/bus.c            | 3 ++-
 drivers/dax/super.c          | 6 +-----
 drivers/md/dm.c              | 2 +-
 drivers/nvdimm/pmem.c        | 7 +++----
 drivers/s390/block/dcssblk.c | 4 ++--
 fs/fuse/virtio_fs.c          | 2 +-
 include/linux/dax.h          | 8 ++------
 7 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 6683d42c32c56..da2a14d096d29 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1324,11 +1324,12 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 	 * No dax_operations since there is no access to this device outside of
 	 * mmap of the resulting character device.
 	 */
-	dax_dev = alloc_dax(dev_dax, NULL, DAXDEV_F_SYNC);
+	dax_dev = alloc_dax(dev_dax, NULL);
 	if (IS_ERR(dax_dev)) {
 		rc = PTR_ERR(dax_dev);
 		goto err_alloc_dax;
 	}
+	set_dax_synchronous(dax_dev);
 
 	/* a device_dax instance is dead while the driver is not attached */
 	kill_dax(dax_dev);
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e18155f43a635..e81d5ee57390f 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -345,8 +345,7 @@ static struct dax_device *dax_dev_get(dev_t devt)
 	return dax_dev;
 }
 
-struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
-		unsigned long flags)
+struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
 {
 	struct dax_device *dax_dev;
 	dev_t devt;
@@ -366,9 +365,6 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
 
 	dax_dev->ops = ops;
 	dax_dev->private = private;
-	if (flags & DAXDEV_F_SYNC)
-		set_dax_synchronous(dax_dev);
-
 	return dax_dev;
 
  err_dev:
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4e997c02bb0a0..f4b972af10928 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1765,7 +1765,7 @@ static struct mapped_device *alloc_dev(int minor)
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
 	if (IS_ENABLED(CONFIG_FS_DAX)) {
-		md->dax_dev = alloc_dax(md, &dm_dax_ops, 0);
+		md->dax_dev = alloc_dax(md, &dm_dax_ops);
 		if (IS_ERR(md->dax_dev)) {
 			md->dax_dev = NULL;
 			goto bad;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 8294f1c701baa..85b3339286bd8 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -402,7 +402,6 @@ static int pmem_attach_disk(struct device *dev,
 	struct gendisk *disk;
 	void *addr;
 	int rc;
-	unsigned long flags = 0UL;
 
 	pmem = devm_kzalloc(dev, sizeof(*pmem), GFP_KERNEL);
 	if (!pmem)
@@ -495,13 +494,13 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
-	if (is_nvdimm_sync(nd_region))
-		flags = DAXDEV_F_SYNC;
-	dax_dev = alloc_dax(pmem, &pmem_dax_ops, flags);
+	dax_dev = alloc_dax(pmem, &pmem_dax_ops);
 	if (IS_ERR(dax_dev)) {
 		rc = PTR_ERR(dax_dev);
 		goto out;
 	}
+	if (is_nvdimm_sync(nd_region))
+		set_dax_synchronous(dax_dev);
 	rc = dax_add_host(dax_dev, disk);
 	if (rc)
 		goto out_cleanup_dax;
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index e65e83764d1ce..10823debc09bd 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -686,13 +686,13 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	if (rc)
 		goto put_dev;
 
-	dev_info->dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops,
-			DAXDEV_F_SYNC);
+	dev_info->dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops);
 	if (IS_ERR(dev_info->dax_dev)) {
 		rc = PTR_ERR(dev_info->dax_dev);
 		dev_info->dax_dev = NULL;
 		goto put_dev;
 	}
+	set_dax_synchronous(dev_info->dax_dev);
 	rc = dax_add_host(dev_info->dax_dev, dev_info->gd);
 	if (rc)
 		goto out_dax;
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 242cc1c0d7ed7..5c03a0364a9bb 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -850,7 +850,7 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
 	dev_dbg(&vdev->dev, "%s: window kaddr 0x%px phys_addr 0x%llx len 0x%llx\n",
 		__func__, fs->window_kaddr, cache_reg.addr, cache_reg.len);
 
-	fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops, 0);
+	fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
 	if (IS_ERR(fs->dax_dev))
 		return PTR_ERR(fs->dax_dev);
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 3bd1fdb5d5f4b..c04f46478e3b5 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -6,9 +6,6 @@
 #include <linux/mm.h>
 #include <linux/radix-tree.h>
 
-/* Flag for synchronous flush */
-#define DAXDEV_F_SYNC (1UL << 0)
-
 typedef unsigned long dax_entry_t;
 
 struct dax_device;
@@ -42,8 +39,7 @@ struct dax_operations {
 };
 
 #if IS_ENABLED(CONFIG_DAX)
-struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
-		unsigned long flags);
+struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
@@ -64,7 +60,7 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
 }
 #else
 static inline struct dax_device *alloc_dax(void *private,
-		const struct dax_operations *ops, unsigned long flags)
+		const struct dax_operations *ops)
 {
 	/*
 	 * Callers should check IS_ENABLED(CONFIG_DAX) to know if this
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

