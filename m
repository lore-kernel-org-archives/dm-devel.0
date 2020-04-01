From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 7/6] dax: Move mandatory ->zero_page_range() check in
 alloc_dax()
Date: Wed, 1 Apr 2020 12:11:25 -0400
Message-ID: <20200401161125.GB9398@redhat.com>
References: <20200228163456.1587-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200228163456.1587-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: david@fromorbit.com, jmoyer@redhat.com, dm-devel@redhat.com, gerald.schaefer@de.ibm.com
List-Id: dm-devel.ids

zero_page_range() dax operation is mandatory for dax devices. Right now
that check happens in dax_zero_page_range() function. Dan thinks that's
too late and its better to do the check earlier in alloc_dax().

I also modified alloc_dax() to return pointer with error code in it in
case of failure. Right now it returns NULL and caller assumes failure
happened due to -ENOMEM. But with this ->zero_page_range() check, I
need to return -EINVAL instead.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/dax/bus.c            |    4 +++-
 drivers/dax/super.c          |   14 +++++++++-----
 drivers/md/dm.c              |    2 +-
 drivers/nvdimm/pmem.c        |    4 ++--
 drivers/s390/block/dcssblk.c |    5 +++--
 5 files changed, 18 insertions(+), 11 deletions(-)

Index: redhat-linux/drivers/dax/super.c
===================================================================
--- redhat-linux.orig/drivers/dax/super.c	2020-04-01 12:03:39.911439769 -0400
+++ redhat-linux/drivers/dax/super.c	2020-04-01 12:05:31.727439769 -0400
@@ -349,9 +349,6 @@ int dax_zero_page_range(struct dax_devic
 {
 	if (!dax_alive(dax_dev))
 		return -ENXIO;
-
-	if (!dax_dev->ops->zero_page_range)
-		return -EOPNOTSUPP;
 	/*
 	 * There are no callers that want to zero more than one page as of now.
 	 * Once users are there, this check can be removed after the
@@ -571,9 +568,16 @@ struct dax_device *alloc_dax(void *priva
 	dev_t devt;
 	int minor;
 
+	if (ops && !ops->zero_page_range) {
+		pr_debug("%s: error: device does not provide dax"
+			 " operation zero_page_range()\n",
+			 __host ? __host : "Unknown");
+		return ERR_PTR(-EINVAL);
+	}
+
 	host = kstrdup(__host, GFP_KERNEL);
 	if (__host && !host)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	minor = ida_simple_get(&dax_minor_ida, 0, MINORMASK+1, GFP_KERNEL);
 	if (minor < 0)
@@ -596,7 +600,7 @@ struct dax_device *alloc_dax(void *priva
 	ida_simple_remove(&dax_minor_ida, minor);
  err_minor:
 	kfree(host);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(alloc_dax);
 
Index: redhat-linux/drivers/nvdimm/pmem.c
===================================================================
--- redhat-linux.orig/drivers/nvdimm/pmem.c	2020-04-01 12:03:39.911439769 -0400
+++ redhat-linux/drivers/nvdimm/pmem.c	2020-04-01 12:05:31.729439769 -0400
@@ -487,9 +487,9 @@ static int pmem_attach_disk(struct devic
 	if (is_nvdimm_sync(nd_region))
 		flags = DAXDEV_F_SYNC;
 	dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops, flags);
-	if (!dax_dev) {
+	if (IS_ERR(dax_dev)) {
 		put_disk(disk);
-		return -ENOMEM;
+		return PTR_ERR(dax_dev);
 	}
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	pmem->dax_dev = dax_dev;
Index: redhat-linux/drivers/dax/bus.c
===================================================================
--- redhat-linux.orig/drivers/dax/bus.c	2020-04-01 12:03:39.911439769 -0400
+++ redhat-linux/drivers/dax/bus.c	2020-04-01 12:05:31.729439769 -0400
@@ -421,8 +421,10 @@ struct dev_dax *__devm_create_dev_dax(st
 	 * device outside of mmap of the resulting character device.
 	 */
 	dax_dev = alloc_dax(dev_dax, NULL, NULL, DAXDEV_F_SYNC);
-	if (!dax_dev)
+	if (IS_ERR(dax_dev)) {
+		rc = PTR_ERR(dax_dev);
 		goto err;
+	}
 
 	/* a device_dax instance is dead while the driver is not attached */
 	kill_dax(dax_dev);
Index: redhat-linux/drivers/s390/block/dcssblk.c
===================================================================
--- redhat-linux.orig/drivers/s390/block/dcssblk.c	2020-04-01 12:03:39.911439769 -0400
+++ redhat-linux/drivers/s390/block/dcssblk.c	2020-04-01 12:05:31.730439769 -0400
@@ -695,8 +695,9 @@ dcssblk_add_store(struct device *dev, st
 
 	dev_info->dax_dev = alloc_dax(dev_info, dev_info->gd->disk_name,
 			&dcssblk_dax_ops, DAXDEV_F_SYNC);
-	if (!dev_info->dax_dev) {
-		rc = -ENOMEM;
+	if (IS_ERR(dev_info->dax_dev)) {
+		rc = PTR_ERR(dev_info->dax_dev);
+		dev_info->dax_dev = NULL;
 		goto put_dev;
 	}
 
Index: redhat-linux/drivers/md/dm.c
===================================================================
--- redhat-linux.orig/drivers/md/dm.c	2020-04-01 12:03:39.911439769 -0400
+++ redhat-linux/drivers/md/dm.c	2020-04-01 12:05:31.732439769 -0400
@@ -2005,7 +2005,7 @@ static struct mapped_device *alloc_dev(i
 	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
 		md->dax_dev = alloc_dax(md, md->disk->disk_name,
 					&dm_dax_ops, 0);
-		if (!md->dax_dev)
+		if (IS_ERR(md->dax_dev))
 			goto bad;
 	}
 
