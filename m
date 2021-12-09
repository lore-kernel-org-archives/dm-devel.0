Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 008CFC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  9 Dec 2021 07:03:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187--4hdpE7bOE2G0R_bVIuugg-1; Thu, 09 Dec 2021 02:03:12 -0500
X-MC-Unique: -4hdpE7bOE2G0R_bVIuugg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE969102CB2A;
	Thu,  9 Dec 2021 07:03:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE37A60BF1;
	Thu,  9 Dec 2021 07:03:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 828531809CB9;
	Thu,  9 Dec 2021 07:03:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B96xDa5015151 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 9 Dec 2021 01:59:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0FC57C23DC3; Thu,  9 Dec 2021 06:59:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B62AC23DB4
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 06:59:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5FCF802802
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 06:59:12 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-363-PQj9JczzO9Wa_JgKcQORiQ-1; Thu, 09 Dec 2021 01:59:11 -0500
X-MC-Unique: PQj9JczzO9Wa_JgKcQORiQ-1
Received: from [2001:4bb8:180:a1c8:2d0e:135:af53:41f8] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mvD4d-0096hv-8z; Thu, 09 Dec 2021 06:38:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Date: Thu,  9 Dec 2021 07:38:28 +0100
Message-Id: <20211209063828.18944-6-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
Subject: [dm-devel] [PATCH 5/5] dax: always use _copy_mc_to_iter in
	dax_copy_to_iter
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

While using the MC-safe copy routines is rather pointless on a virtual device
like virtiofs, it also isn't harmful at all.  So just use _copy_mc_to_iter
unconditionally to simplify the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/dax/super.c | 10 ----------
 fs/fuse/virtio_fs.c |  1 -
 include/linux/dax.h |  1 -
 3 files changed, 12 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index ff676a07480c8..fe783234ca669 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -107,8 +107,6 @@ enum dax_device_flags {
 	DAXDEV_SYNC,
 	/* do not use uncached operations to write data */
 	DAXDEV_CACHED,
-	/* do not use mcsafe operations to read data */
-	DAXDEV_NOMCSAFE,
 };
 
 /**
@@ -171,8 +169,6 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 	 * via access_ok() in vfs_red, so use the 'no check' version to bypass
 	 * the HARDENED_USERCOPY overhead.
 	 */
-	if (test_bit(DAXDEV_NOMCSAFE, &dax_dev->flags))
-		return _copy_to_iter(addr, bytes, i);
 	return _copy_mc_to_iter(addr, bytes, i);
 }
 
@@ -242,12 +238,6 @@ void set_dax_cached(struct dax_device *dax_dev)
 }
 EXPORT_SYMBOL_GPL(set_dax_cached);
 
-void set_dax_nomcsafe(struct dax_device *dax_dev)
-{
-	set_bit(DAXDEV_NOMCSAFE, &dax_dev->flags);
-}
-EXPORT_SYMBOL_GPL(set_dax_nomcsafe);
-
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 754319ce2a29b..d9c20b148ac19 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -838,7 +838,6 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
 	if (IS_ERR(fs->dax_dev))
 		return PTR_ERR(fs->dax_dev);
 	set_dax_cached(fs->dax_dev);
-	set_dax_nomcsafe(fs->dax_dev);
 	return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax,
 					fs->dax_dev);
 }
diff --git a/include/linux/dax.h b/include/linux/dax.h
index d22cbf03d37d2..d267331bc37e7 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -90,7 +90,6 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
 #endif
 
 void set_dax_cached(struct dax_device *dax_dev);
-void set_dax_nomcsafe(struct dax_device *dax_dev);
 
 struct writeback_control;
 #if defined(CONFIG_BLOCK) && defined(CONFIG_FS_DAX)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

