Return-Path: <SRS0=/efG=IB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2512C433E6
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 12:31:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 137D264EBD
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 12:31:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 137D264EBD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-hUTW6MglMteGLbI9pVDM5A-1; Wed, 03 Mar 2021 07:31:17 -0500
X-MC-Unique: hUTW6MglMteGLbI9pVDM5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 028D6100CCC4;
	Wed,  3 Mar 2021 12:31:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D889D5D9C2;
	Wed,  3 Mar 2021 12:31:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9FBB95002F;
	Wed,  3 Mar 2021 12:31:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 123CUvNO011586 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Mar 2021 07:30:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3873921121A3; Wed,  3 Mar 2021 12:30:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32BE221121A1
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 12:30:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14ABE858F13
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 12:30:57 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-37-2s328oH9NSiu22V-EpPNDw-1;
	Wed, 03 Mar 2021 07:30:52 -0500
X-MC-Unique: 2s328oH9NSiu22V-EpPNDw-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id 0622741352;
	Wed,  3 Mar 2021 07:30:49 -0500 (EST)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Wed, 3 Mar 2021 13:30:46 +0100
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: <snitzer@redhat.com>, <agk@redhat.com>, <hare@suse.de>, <song@kernel.org>, 
	<axboe@kernel.dk>, <dm-devel@redhat.com>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <linux-api@vger.kernel.org>
Date: Wed, 3 Mar 2021 15:30:17 +0300
Message-ID: <1614774618-22410-4-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1614774618-22410-1-git-send-email-sergei.shtepa@veeam.com>
References: <1614774618-22410-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D265637363
X-Veeam-MMEX: True
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
Cc: pavel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH v6 3/4] dm: introduce dm-interposer
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

dm-interposer.c/. h contains code for working with blk_interposer
and provides an API for interposer in device-mapper.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 drivers/md/Makefile        |   2 +-
 drivers/md/dm-interposer.c | 258 +++++++++++++++++++++++++++++++++++++
 drivers/md/dm-interposer.h |  40 ++++++
 3 files changed, 299 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/dm-interposer.c
 create mode 100644 drivers/md/dm-interposer.h

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index ef7ddc27685c..bd5b38bee82e 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -5,7 +5,7 @@
 
 dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o dm-stats.o \
-		   dm-rq.o
+		   dm-rq.o dm-interposer.o
 dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-historical-service-time-y += dm-ps-historical-service-time.o
 dm-io-affinity-y += dm-ps-io-affinity.o
diff --git a/drivers/md/dm-interposer.c b/drivers/md/dm-interposer.c
new file mode 100644
index 000000000000..e5346db81def
--- /dev/null
+++ b/drivers/md/dm-interposer.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bio.h>
+#include <linux/rwsem.h>
+#include <linux/refcount.h>
+#include <linux/device-mapper.h>
+#include <linux/interval_tree_generic.h>
+
+#include "dm-core.h"
+#include "dm-interposer.h"
+
+#define DM_MSG_PREFIX "interposer"
+
+struct dm_interposer {
+	struct bdev_interposer blk_ip;
+
+	struct kref kref;
+	struct rw_semaphore ip_devs_lock;
+	struct rb_root_cached ip_devs_root; /* dm_interposed_dev tree, since there can be multiple
+					     * interceptors for different ranges for a single
+					     * block device. */
+};
+
+/*
+ * Interval tree for device mapper
+ */
+#define START(node) ((node)->start)
+#define LAST(node) ((node)->last)
+INTERVAL_TREE_DEFINE(struct dm_rb_range, node, sector_t, _subtree_last,
+		     START, LAST,, dm_rb);
+
+static DEFINE_MUTEX(dm_interposer_attach_lock);
+
+static void dm_submit_bio_interposer_fn(struct bio *bio)
+{
+	struct dm_interposer *ip;
+	unsigned int noio_flag = 0;
+	sector_t start;
+	sector_t last;
+	struct dm_rb_range *node;
+
+	ip = container_of(bio->bi_bdev->bd_interposer, struct dm_interposer, blk_ip);
+
+	start = bio->bi_iter.bi_sector;
+	if (bio_flagged(bio, BIO_REMAPPED))
+		start -= get_start_sect(bio->bi_bdev);
+	last = start + dm_sector_div_up(bio->bi_iter.bi_size, SECTOR_SIZE);
+
+	noio_flag = memalloc_noio_save();
+	down_read(&ip->ip_devs_lock);
+	node = dm_rb_iter_first(&ip->ip_devs_root, start, last);
+	while (node) {
+		struct dm_interposed_dev *ip_dev =
+			container_of(node, struct dm_interposed_dev, node);
+
+		atomic64_inc(&ip_dev->ip_cnt);
+		ip_dev->dm_interpose_bio(ip_dev, bio);
+
+		node = dm_rb_iter_next(node, start, last);
+	}
+	up_read(&ip->ip_devs_lock);
+	memalloc_noio_restore(noio_flag);
+}
+
+void dm_interposer_free(struct kref *kref)
+{
+	struct dm_interposer *ip = container_of(kref, struct dm_interposer, kref);
+
+	bdev_interposer_detach(&ip->blk_ip, dm_submit_bio_interposer_fn);
+
+	kfree(ip);
+}
+
+struct dm_interposer *dm_interposer_new(struct block_device *bdev)
+{
+	int ret = 0;
+	struct dm_interposer *ip;
+
+	ip = kzalloc(sizeof(struct dm_interposer), GFP_NOIO);
+	if (!ip)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&ip->kref);
+	init_rwsem(&ip->ip_devs_lock);
+	ip->ip_devs_root = RB_ROOT_CACHED;
+
+	ret = bdev_interposer_attach(bdev, &ip->blk_ip, dm_submit_bio_interposer_fn);
+	if (ret) {
+		DMERR("Failed to attach bdev_interposer.");
+		kref_put(&ip->kref, dm_interposer_free);
+		return ERR_PTR(ret);
+	}
+
+	return ip;
+}
+
+static struct dm_interposer *dm_interposer_get(struct block_device *bdev)
+{
+	struct dm_interposer *ip;
+
+	if (!bdev_has_interposer(bdev))
+		return NULL;
+
+	if (bdev->bd_interposer->ip_submit_bio != dm_submit_bio_interposer_fn) {
+		DMERR("Block devices interposer slot already occupied.");
+		return ERR_PTR(-EBUSY);
+	}
+
+	ip = container_of(bdev->bd_interposer, struct dm_interposer, blk_ip);
+
+	kref_get(&ip->kref);
+	return ip;
+}
+
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
+/**
+ * dm_interposer_dev_init - initialize interposed device
+ * @ip_dev: interposed device
+ * @ofs: offset from the beginning of the block device
+ * @len: the length of the part of the block device to which requests will be interposed
+ * @private: user purpose parameter
+ * @interpose_fn: interposing callback
+ *
+ * Initialize structure dm_interposed_dev.
+ * For interposing part of block device set ofs and len.
+ * For interposing whole device set ofs=0 and len=0.
+ */
+void dm_interposer_dev_init(struct dm_interposed_dev *ip_dev,
+			    sector_t ofs, sector_t len,
+			    void *private, dm_interpose_bio_t interpose_fn)
+{
+	ip_dev->node.start = ofs;
+	ip_dev->node.last = ofs + len - 1;
+	ip_dev->dm_interpose_bio = interpose_fn;
+	ip_dev->private = private;
+
+	atomic64_set(&ip_dev->ip_cnt, 0);
+}
+
+/**
+ * dm_interposer_dev_attach - attach interposed device to his block device
+ * @bdev: block device
+ * @ip_dev: interposed device
+ *
+ * Return error code.
+ */
+int dm_interposer_dev_attach(struct block_device *bdev, struct dm_interposed_dev *ip_dev)
+{
+	int ret = 0;
+	struct dm_interposer *ip = NULL;
+	unsigned int noio_flag = 0;
+
+	if (!ip_dev)
+		return -EINVAL;
+
+	dm_disk_freeze(bdev->bd_disk);
+	mutex_lock(&dm_interposer_attach_lock);
+	noio_flag = memalloc_noio_save();
+
+	ip = dm_interposer_get(bdev);
+	if (ip == NULL)
+		ip = dm_interposer_new(bdev);
+	if (IS_ERR(ip)) {
+		ret = PTR_ERR(ip);
+		goto out;
+	}
+
+	/* Attach dm_interposed_dev to dm_interposer */
+	down_write(&ip->ip_devs_lock);
+	do {
+		struct dm_rb_range *node;
+
+		/* checking that ip_dev already exists for this region */
+		node = dm_rb_iter_first(&ip->ip_devs_root, ip_dev->node.start, ip_dev->node.last);
+		if (node) {
+			DMERR("Block device in region [%llu,%llu] already have interposer.",
+			      node->start, node->last);
+
+			ret = -EBUSY;
+			break;
+		}
+
+		/* insert ip_dev to ip tree */
+		dm_rb_insert(&ip_dev->node, &ip->ip_devs_root);
+		/* increment ip reference counter */
+		kref_get(&ip->kref);
+	} while (false);
+	up_write(&ip->ip_devs_lock);
+
+	kref_put(&ip->kref, dm_interposer_free);
+
+out:
+	memalloc_noio_restore(noio_flag);
+	mutex_unlock(&dm_interposer_attach_lock);
+	dm_disk_unfreeze(bdev->bd_disk);
+
+	return ret;
+}
+
+/**
+ * dm_interposer_detach_dev - detach interposed device from his block device
+ * @bdev: block device
+ * @ip_dev: interposed device
+ *
+ * Return error code.
+ */
+int dm_interposer_detach_dev(struct block_device *bdev, struct dm_interposed_dev *ip_dev)
+{
+	int ret = 0;
+	struct dm_interposer *ip = NULL;
+	unsigned int noio_flag = 0;
+
+	if (!ip_dev)
+		return -EINVAL;
+
+	dm_disk_freeze(bdev->bd_disk);
+	mutex_lock(&dm_interposer_attach_lock);
+	noio_flag = memalloc_noio_save();
+
+	ip = dm_interposer_get(bdev);
+	if (IS_ERR(ip)) {
+		ret = PTR_ERR(ip);
+		DMERR("Interposer not found.");
+		goto out;
+	}
+	if (unlikely(ip == NULL)) {
+		ret = -ENXIO;
+		DMERR("Interposer not found.");
+		goto out;
+	}
+
+	down_write(&ip->ip_devs_lock);
+	{
+		dm_rb_remove(&ip_dev->node, &ip->ip_devs_root);
+		/* the reference counter here cannot be zero */
+		kref_put(&ip->kref, dm_interposer_free);
+	}
+	up_write(&ip->ip_devs_lock);
+
+	/* detach and free interposer if it's not needed */
+	kref_put(&ip->kref, dm_interposer_free);
+out:
+	memalloc_noio_restore(noio_flag);
+	mutex_unlock(&dm_interposer_attach_lock);
+	dm_disk_unfreeze(bdev->bd_disk);
+
+	return ret;
+}
diff --git a/drivers/md/dm-interposer.h b/drivers/md/dm-interposer.h
new file mode 100644
index 000000000000..17a5411f6f00
--- /dev/null
+++ b/drivers/md/dm-interposer.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Device mapper's interposer.
+ */
+
+#include <linux/rbtree.h>
+
+struct dm_rb_range {
+	struct rb_node node;
+	sector_t start;		/* start sector of rb node */
+	sector_t last;		/* end sector of rb node */
+	sector_t _subtree_last; /* highest sector in subtree of rb node */
+};
+
+typedef void (*dm_interpose_bio_t) (struct dm_interposed_dev *ip_dev, struct bio *bio);
+
+struct dm_interposed_dev {
+	struct dm_rb_range node;
+	void *private;
+	dm_interpose_bio_t dm_interpose_bio;
+
+	atomic64_t ip_cnt; /* for debug purpose only */
+};
+
+/*
+ * Initialize structure dm_interposed_dev.
+ * For interposing part of block device set ofs and len.
+ * For interposing whole device set ofs=0 and len=0.
+ */
+void dm_interposer_dev_init(struct dm_interposed_dev *ip_dev,
+			    sector_t ofs, sector_t len,
+			    void *private, dm_interpose_bio_t interpose_fn);
+/*
+ * Attach interposer to his block device.
+ */
+int dm_interposer_dev_attach(struct block_device *bdev, struct dm_interposed_dev *ip_dev);
+/*
+ * Detach interposer from his block device.
+ */
+int dm_interposer_detach_dev(struct block_device *bdev, struct dm_interposed_dev *ip_dev);
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

