Return-Path: <SRS0=t7n3=MW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D842DC4338F
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:54:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5D05660F12
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:54:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5D05660F12
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-sI8sCgaIM8umdPHX8LFd4A-1; Fri, 30 Jul 2021 09:54:39 -0400
X-MC-Unique: sI8sCgaIM8umdPHX8LFd4A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D4DE100E420;
	Fri, 30 Jul 2021 13:54:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E89F55D9D5;
	Fri, 30 Jul 2021 13:54:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0255F4A7C9;
	Fri, 30 Jul 2021 13:54:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16U8rBQk013557 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Jul 2021 04:53:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6281F1054E49; Fri, 30 Jul 2021 08:53:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EC52105482F
	for <dm-devel@redhat.com>; Fri, 30 Jul 2021 08:53:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48604101A52C
	for <dm-devel@redhat.com>; Fri, 30 Jul 2021 08:53:11 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-564-YDgJbSSbNLylR_eIqT43gw-3;
	Fri, 30 Jul 2021 04:53:06 -0400
X-MC-Unique: YDgJbSSbNLylR_eIqT43gw-3
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Ahx651qFTb6ttFbSwpLqEDMeALOsnbusQ8zAX?=
	=?us-ascii?q?P0AYc3Jom6uj5qaTdZUgpGbJYVkqOE3I9ertBEDEewK4yXcX2/h3AV7BZniEhI?=
	=?us-ascii?q?LAFugLhuGO/9SjIVybygc378ZdmsZFZ+EYdWIK7/oS/jPIbuoI8Z2W9ryyn+fC?=
	=?us-ascii?q?wzNIRQFuUatp6AB0EW+gYzZLbTgDFZwkD4Cd+8YCgzKhfE4cZsO9CmJAcPPEo7?=
	=?us-ascii?q?Tw5ejbSC9DFxg68xOPkD/tzLb7FiKT1hAYXygK4ZpKyxm8rzDE?=
X-IronPort-AV: E=Sophos;i="5.84,281,1620662400"; d="scan'208";a="112070581"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 30 Jul 2021 16:53:05 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 43B434D0D4A3;
	Fri, 30 Jul 2021 16:53:01 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP
	Server (TLS) id 15.0.1497.23; Fri, 30 Jul 2021 16:52:52 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.23 via Frontend Transport; Fri, 30 Jul 2021 16:52:49 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Fri, 30 Jul 2021 16:52:38 +0800
Message-ID: <20210730085245.3069812-3-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730085245.3069812-1-ruansy.fnst@fujitsu.com>
References: <20210730085245.3069812-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 43B434D0D4A3.A0FA0
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 30 Jul 2021 09:53:42 -0400
Cc: snitzer@redhat.com, david@fromorbit.com, djwong@kernel.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v6 2/9] dax: Introduce holder for dax_device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

To easily track filesystem from a pmem device, we introduce a holder for
dax_device structure, and also its operation.  This holder is used to
remember who is using this dax_device:
 - When it is the backend of a filesystem, the holder will be the
   superblock of this filesystem.
 - When this pmem device is one of the targets in a mapped device, the
   holder will be this mapped device.  In this case, the mapped device
   has its own dax_device and it will follow the first rule.  So that we
   can finally track to the filesystem we needed.

The holder and holder_ops will be set when filesystem is being mounted,
or an target device is being activated.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 drivers/dax/super.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h | 17 +++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 5fa6ae9dbc8b..00c32dfa5665 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -214,6 +214,8 @@ enum dax_device_flags {
  * @cdev: optional character interface for "device dax"
  * @host: optional name for lookups where the device path is not available
  * @private: dax driver private data
+ * @holder_rwsem: prevent unregistration while holder_ops is in progress
+ * @holder_data: holder of a dax_device: could be filesystem or mapped device
  * @flags: state and boolean properties
  */
 struct dax_device {
@@ -222,8 +224,11 @@ struct dax_device {
 	struct cdev cdev;
 	const char *host;
 	void *private;
+	struct rw_semaphore holder_rwsem;
+	void *holder_data;
 	unsigned long flags;
 	const struct dax_operations *ops;
+	const struct dax_holder_operations *holder_ops;
 };
 
 static ssize_t write_cache_show(struct device *dev,
@@ -373,6 +378,25 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 }
 EXPORT_SYMBOL_GPL(dax_zero_page_range);
 
+int dax_holder_notify_failure(struct dax_device *dax_dev, loff_t offset,
+			      size_t size, void *data)
+{
+	int rc;
+
+	if (!dax_dev)
+		return -ENXIO;
+
+	if (!dax_dev->holder_data)
+		return -EOPNOTSUPP;
+
+	down_read(&dax_dev->holder_rwsem);
+	rc = dax_dev->holder_ops->notify_failure(dax_dev, offset,
+							 size, data);
+	up_read(&dax_dev->holder_rwsem);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(dax_holder_notify_failure);
+
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 void arch_wb_cache_pmem(void *addr, size_t size);
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
@@ -603,6 +627,7 @@ struct dax_device *alloc_dax(void *private, const char *__host,
 	dax_add_host(dax_dev, host);
 	dax_dev->ops = ops;
 	dax_dev->private = private;
+	init_rwsem(&dax_dev->holder_rwsem);
 	if (flags & DAXDEV_F_SYNC)
 		set_dax_synchronous(dax_dev);
 
@@ -624,6 +649,27 @@ void put_dax(struct dax_device *dax_dev)
 }
 EXPORT_SYMBOL_GPL(put_dax);
 
+void dax_set_holder(struct dax_device *dax_dev, void *holder,
+		const struct dax_holder_operations *ops)
+{
+	if (!dax_dev)
+		return;
+	down_write(&dax_dev->holder_rwsem);
+	dax_dev->holder_data = holder;
+	dax_dev->holder_ops = ops;
+	up_write(&dax_dev->holder_rwsem);
+}
+EXPORT_SYMBOL_GPL(dax_set_holder);
+
+void *dax_get_holder(struct dax_device *dax_dev)
+{
+	if (!dax_dev)
+		return NULL;
+
+	return dax_dev->holder_data;
+}
+EXPORT_SYMBOL_GPL(dax_get_holder);
+
 /**
  * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
  * @host: alternate name for the device registered by a dax driver
diff --git a/include/linux/dax.h b/include/linux/dax.h
index b52f084aa643..6f4b5c97ceb0 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -38,10 +38,17 @@ struct dax_operations {
 	int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
 };
 
+struct dax_holder_operations {
+	int (*notify_failure)(struct dax_device *, loff_t, size_t, void *);
+};
+
 extern struct attribute_group dax_attribute_group;
 
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *dax_get_by_host(const char *host);
+void dax_set_holder(struct dax_device *dax_dev, void *holder,
+		const struct dax_holder_operations *ops);
+void *dax_get_holder(struct dax_device *dax_dev);
 struct dax_device *alloc_dax(void *private, const char *host,
 		const struct dax_operations *ops, unsigned long flags);
 void put_dax(struct dax_device *dax_dev);
@@ -77,6 +84,14 @@ static inline struct dax_device *dax_get_by_host(const char *host)
 {
 	return NULL;
 }
+static inline void dax_set_holder(struct dax_device *dax_dev, void *holder,
+		const struct dax_holder_operations *ops)
+{
+}
+static inline void *dax_get_holder(struct dax_device *dax_dev)
+{
+	return NULL;
+}
 static inline struct dax_device *alloc_dax(void *private, const char *host,
 		const struct dax_operations *ops, unsigned long flags)
 {
@@ -226,6 +241,8 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i);
 int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 			size_t nr_pages);
+int dax_holder_notify_failure(struct dax_device *dax_dev, loff_t offset,
+		size_t size, void *data);
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
 
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
-- 
2.32.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

