Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE4CEC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 17 Jan 2022 17:10:59 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-fqCeVR9GP8m0p-9sslygYg-1; Mon, 17 Jan 2022 12:10:55 -0500
X-MC-Unique: fqCeVR9GP8m0p-9sslygYg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBFF818C9F44;
	Mon, 17 Jan 2022 17:10:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A1A87BB6A;
	Mon, 17 Jan 2022 17:10:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17A8E1806D1D;
	Mon, 17 Jan 2022 17:10:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20HH8lbW013591 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 Jan 2022 12:08:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6811A2166B25; Mon, 17 Jan 2022 17:08:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61CB32166B47
	for <dm-devel@redhat.com>; Mon, 17 Jan 2022 17:08:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A2DB101A52D
	for <dm-devel@redhat.com>; Mon, 17 Jan 2022 17:08:44 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
	[139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-212-M6hP-rAdN0aVsFu7z1XUlw-1; Mon, 17 Jan 2022 12:08:42 -0500
X-MC-Unique: M6hP-rAdN0aVsFu7z1XUlw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id AE7C6611E1;
	Mon, 17 Jan 2022 16:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F59C36AE7;
	Mon, 17 Jan 2022 16:59:36 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 17 Jan 2022 11:58:20 -0500
Message-Id: <20220117165853.1470420-19-sashal@kernel.org>
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20HH8lbW013591
X-loop: dm-devel@redhat.com
Cc: Sasha Levin <sashal@kernel.org>, nvdimm@lists.linux.dev,
	dave.jiang@intel.com, Mike Snitzer <snitzer@redhat.com>,
	vishal.l.verma@intel.com, dm-devel@redhat.com,
	Dan Williams <dan.j.williams@intel.com>,
	Christoph Hellwig <hch@lst.de>, agk@redhat.com
Subject: [dm-devel] [PATCH AUTOSEL 5.16 19/52] dm: make the DAX support
	depend on CONFIG_FS_DAX
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 5d2a228b9e1319ff188f9ea89006fbe575561921 ]

The device mapper DAX support is all hanging off a block device and thus
can't be used with device dax.  Make it depend on CONFIG_FS_DAX instead
of CONFIG_DAX_DRIVER.  This also means that bdev_dax_pgoff only needs to
be built under CONFIG_FS_DAX now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Link: https://lore.kernel.org/r/20211129102203.2243509-3-hch@lst.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

