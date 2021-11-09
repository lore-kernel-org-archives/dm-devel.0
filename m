Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A67C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:01:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2078961186
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 09:01:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2078961186
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-6-IsysKqOJ2fttkGhNVemQ-1; Tue, 09 Nov 2021 04:01:38 -0500
X-MC-Unique: 6-IsysKqOJ2fttkGhNVemQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 025F71014E1E;
	Tue,  9 Nov 2021 09:01:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FBB978B45;
	Tue,  9 Nov 2021 09:01:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 50B6F181A1D0;
	Tue,  9 Nov 2021 09:01:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A9904mv017648 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 04:00:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9BFCC51E2; Tue,  9 Nov 2021 09:00:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9729451E1
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 09:00:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 803F2106655C
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 09:00:04 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-482-b6ZsbXdwN1CuBmsKTWDbfg-1; Tue, 09 Nov 2021 04:00:03 -0500
X-MC-Unique: b6ZsbXdwN1CuBmsKTWDbfg-1
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mkMZ5-000ry5-Fk; Tue, 09 Nov 2021 08:33:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Tue,  9 Nov 2021 09:32:41 +0100
Message-Id: <20211109083309.584081-2-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 01/29] nvdimm/pmem: move dax_attribute_group from
	dax to pmem
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dax_attribute_group is only used by the pmem driver, and can avoid the
completely pointless lookup by the disk name if moved there.  This
leaves just a single caller of dax_get_by_host, so move dax_get_by_host
into the same ifdef block as that caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/20210922173431.2454024-3-hch@lst.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c   | 100 ++++++++----------------------------------
 drivers/nvdimm/pmem.c |  43 ++++++++++++++++++
 include/linux/dax.h   |   2 -
 3 files changed, 61 insertions(+), 84 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index fc89e91beea7c..b882cf8106ea3 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -63,6 +63,24 @@ static int dax_host_hash(const char *host)
 	return hashlen_hash(hashlen_string("DAX", host)) % DAX_HASH_SIZE;
 }
 
+#ifdef CONFIG_BLOCK
+#include <linux/blkdev.h>
+
+int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
+		pgoff_t *pgoff)
+{
+	sector_t start_sect = bdev ? get_start_sect(bdev) : 0;
+	phys_addr_t phys_off = (start_sect + sector) * 512;
+
+	if (pgoff)
+		*pgoff = PHYS_PFN(phys_off);
+	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
+		return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL(bdev_dax_pgoff);
+
+#if IS_ENABLED(CONFIG_FS_DAX)
 /**
  * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
  * @host: alternate name for the device registered by a dax driver
@@ -94,24 +112,6 @@ static struct dax_device *dax_get_by_host(const char *host)
 	return found;
 }
 
-#ifdef CONFIG_BLOCK
-#include <linux/blkdev.h>
-
-int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
-		pgoff_t *pgoff)
-{
-	sector_t start_sect = bdev ? get_start_sect(bdev) : 0;
-	phys_addr_t phys_off = (start_sect + sector) * 512;
-
-	if (pgoff)
-		*pgoff = PHYS_PFN(phys_off);
-	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
-		return -EINVAL;
-	return 0;
-}
-EXPORT_SYMBOL(bdev_dax_pgoff);
-
-#if IS_ENABLED(CONFIG_FS_DAX)
 struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
 {
 	if (!blk_queue_dax(bdev->bd_disk->queue))
@@ -231,70 +231,6 @@ enum dax_device_flags {
 	DAXDEV_SYNC,
 };
 
-static ssize_t write_cache_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
-	ssize_t rc;
-
-	WARN_ON_ONCE(!dax_dev);
-	if (!dax_dev)
-		return -ENXIO;
-
-	rc = sprintf(buf, "%d\n", !!dax_write_cache_enabled(dax_dev));
-	put_dax(dax_dev);
-	return rc;
-}
-
-static ssize_t write_cache_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
-{
-	bool write_cache;
-	int rc = strtobool(buf, &write_cache);
-	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
-
-	WARN_ON_ONCE(!dax_dev);
-	if (!dax_dev)
-		return -ENXIO;
-
-	if (rc)
-		len = rc;
-	else
-		dax_write_cache(dax_dev, write_cache);
-
-	put_dax(dax_dev);
-	return len;
-}
-static DEVICE_ATTR_RW(write_cache);
-
-static umode_t dax_visible(struct kobject *kobj, struct attribute *a, int n)
-{
-	struct device *dev = container_of(kobj, typeof(*dev), kobj);
-	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
-
-	WARN_ON_ONCE(!dax_dev);
-	if (!dax_dev)
-		return 0;
-
-#ifndef CONFIG_ARCH_HAS_PMEM_API
-	if (a == &dev_attr_write_cache.attr)
-		return 0;
-#endif
-	return a->mode;
-}
-
-static struct attribute *dax_attributes[] = {
-	&dev_attr_write_cache.attr,
-	NULL,
-};
-
-struct attribute_group dax_attribute_group = {
-	.name = "dax",
-	.attrs = dax_attributes,
-	.is_visible = dax_visible,
-};
-EXPORT_SYMBOL_GPL(dax_attribute_group);
-
 /**
  * dax_direct_access() - translate a device pgoff to an absolute pfn
  * @dax_dev: a dax_device instance representing the logical memory range
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index c74d7bceb2224..9cc0d0ebfad16 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -327,6 +327,49 @@ static const struct dax_operations pmem_dax_ops = {
 	.zero_page_range = pmem_dax_zero_page_range,
 };
 
+static ssize_t write_cache_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct pmem_device *pmem = dev_to_disk(dev)->private_data;
+
+	return sprintf(buf, "%d\n", !!dax_write_cache_enabled(pmem->dax_dev));
+}
+
+static ssize_t write_cache_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct pmem_device *pmem = dev_to_disk(dev)->private_data;
+	bool write_cache;
+	int rc;
+
+	rc = strtobool(buf, &write_cache);
+	if (rc)
+		return rc;
+	dax_write_cache(pmem->dax_dev, write_cache);
+	return len;
+}
+static DEVICE_ATTR_RW(write_cache);
+
+static umode_t dax_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+#ifndef CONFIG_ARCH_HAS_PMEM_API
+	if (a == &dev_attr_write_cache.attr)
+		return 0;
+#endif
+	return a->mode;
+}
+
+static struct attribute *dax_attributes[] = {
+	&dev_attr_write_cache.attr,
+	NULL,
+};
+
+static const struct attribute_group dax_attribute_group = {
+	.name		= "dax",
+	.attrs		= dax_attributes,
+	.is_visible	= dax_visible,
+};
+
 static const struct attribute_group *pmem_attribute_groups[] = {
 	&dax_attribute_group,
 	NULL,
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 2619d94c308d4..8623caa673889 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -38,8 +38,6 @@ struct dax_operations {
 	int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
 };
 
-extern struct attribute_group dax_attribute_group;
-
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *alloc_dax(void *private, const char *host,
 		const struct dax_operations *ops, unsigned long flags);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

