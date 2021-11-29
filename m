Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C5AAC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 10:40:01 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-TxQZCpVyN466g4ZqbILJqA-1; Mon, 29 Nov 2021 05:39:57 -0500
X-MC-Unique: TxQZCpVyN466g4ZqbILJqA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EE491006AB7;
	Mon, 29 Nov 2021 10:39:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6635F79C53;
	Mon, 29 Nov 2021 10:39:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3F47218048A7;
	Mon, 29 Nov 2021 10:39:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATAdnqx014395 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 05:39:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A3D8F40CFD13; Mon, 29 Nov 2021 10:39:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EF1A40CFD05
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 10:39:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 832D485A5A8
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 10:39:49 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-442-N81noJgRPr2W7gBR9rmthw-1; Mon, 29 Nov 2021 05:39:45 -0500
X-MC-Unique: N81noJgRPr2W7gBR9rmthw-1
Received: from [2001:4bb8:184:4a23:724a:c057:c7bf:4643] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mrdnS-0073J2-IG; Mon, 29 Nov 2021 10:22:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Nov 2021 11:21:36 +0100
Message-Id: <20211129102203.2243509-3-hch@lst.de>
In-Reply-To: <20211129102203.2243509-1-hch@lst.de>
References: <20211129102203.2243509-1-hch@lst.de>
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
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 02/29] dm: make the DAX support depend on
	CONFIG_FS_DAX
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

The device mapper DAX support is all hanging off a block device and thus
can't be used with device dax.  Make it depend on CONFIG_FS_DAX instead
of CONFIG_DAX_DRIVER.  This also means that bdev_dax_pgoff only needs to
be built under CONFIG_FS_DAX now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/dax/super.c        | 6 ++----
 drivers/md/dm-linear.c     | 2 +-
 drivers/md/dm-log-writes.c | 2 +-
 drivers/md/dm-stripe.c     | 2 +-
 drivers/md/dm-writecache.c | 2 +-
 drivers/md/dm.c            | 2 +-
 6 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index b882cf8106ea3..e20d0cef10a18 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -63,7 +63,7 @@ static int dax_host_hash(const char *host)
 	return hashlen_hash(hashlen_string("DAX", host)) % DAX_HASH_SIZE;
 }
 
-#ifdef CONFIG_BLOCK
+#if defined(CONFIG_BLOCK) && defined(CONFIG_FS_DAX)
 #include <linux/blkdev.h>
 
 int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
@@ -80,7 +80,6 @@ int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
 }
 EXPORT_SYMBOL(bdev_dax_pgoff);
 
-#if IS_ENABLED(CONFIG_FS_DAX)
 /**
  * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
  * @host: alternate name for the device registered by a dax driver
@@ -219,8 +218,7 @@ bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dax_supported);
-#endif /* CONFIG_FS_DAX */
-#endif /* CONFIG_BLOCK */
+#endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
 
 enum dax_device_flags {
 	/* !alive + rcu grace period == no new operations / mappings */
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 66ba16713f696..0a260c35aeeed 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -162,7 +162,7 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
-#if IS_ENABLED(CONFIG_DAX_DRIVER)
+#if IS_ENABLED(CONFIG_FS_DAX)
 static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 0b3ef977ceeba..3155875d4e5b0 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -901,7 +901,7 @@ static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limit
 	limits->io_min = limits->physical_block_size;
 }
 
-#if IS_ENABLED(CONFIG_DAX_DRIVER)
+#if IS_ENABLED(CONFIG_FS_DAX)
 static int log_dax(struct log_writes_c *lc, sector_t sector, size_t bytes,
 		   struct iov_iter *i)
 {
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 6660b6b53d5bf..f084607220293 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -300,7 +300,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
-#if IS_ENABLED(CONFIG_DAX_DRIVER)
+#if IS_ENABLED(CONFIG_FS_DAX)
 static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 4b8991cde223d..4f31591d2d25e 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -38,7 +38,7 @@
 #define BITMAP_GRANULARITY	PAGE_SIZE
 #endif
 
-#if IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API) && IS_ENABLED(CONFIG_DAX_DRIVER)
+#if IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API) && IS_ENABLED(CONFIG_FS_DAX)
 #define DM_WRITECACHE_HAS_PMEM
 #endif
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index acc84dc1bded5..b93fcc91176e5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1783,7 +1783,7 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
-	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
+	if (IS_ENABLED(CONFIG_FS_DAX)) {
 		md->dax_dev = alloc_dax(md, md->disk->disk_name,
 					&dm_dax_ops, 0);
 		if (IS_ERR(md->dax_dev)) {
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

