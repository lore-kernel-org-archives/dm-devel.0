Return-Path: <SRS0=/TsO=HF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC60C433DB
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 15:55:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 88A1264F8C
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 15:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88A1264F8C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-rmCjm4gFNsW4MqQfC3dWWg-1; Wed, 03 Feb 2021 10:55:02 -0500
X-MC-Unique: rmCjm4gFNsW4MqQfC3dWWg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98473CC624;
	Wed,  3 Feb 2021 15:54:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 743445B692;
	Wed,  3 Feb 2021 15:54:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 46FF558077;
	Wed,  3 Feb 2021 15:54:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 113FstEi006245 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 10:54:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 19B9C114B9A0; Wed,  3 Feb 2021 15:54:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15AE6114B9A1
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 15:54:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B00F3858F0E
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 15:54:53 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-143-MTReT46IOJKanbg4TSJyrA-1;
	Wed, 03 Feb 2021 10:54:49 -0500
X-MC-Unique: MTReT46IOJKanbg4TSJyrA-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id 3C632414CE;
	Wed,  3 Feb 2021 10:54:44 -0500 (EST)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Wed, 3 Feb 2021 16:54:24 +0100
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: <Damien.LeMoal@wdc.com>, <snitzer@redhat.com>, <hare@suse.de>,
	<ming.lei@redhat.com>, <agk@redhat.com>, <corbet@lwn.net>,
	<axboe@kernel.dk>, <jack@suse.cz>, <johannes.thumshirn@wdc.com>,
	<gregkh@linuxfoundation.org>, <koct9i@gmail.com>, <steve@sk2.org>,
	<dm-devel@redhat.com>, <linux-block@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 3 Feb 2021 18:53:56 +0300
Message-ID: <1612367638-3794-5-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1612367638-3794-1-git-send-email-sergei.shtepa@veeam.com>
References: <1612367638-3794-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D265667062
X-Veeam-MMEX: True
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
Cc: pavgel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH v4 4/6] dm: new ioctl DM_DEV_REMAP_CMD
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

New ioctl DM_DEV_REMAP_CMD allow to remap bio requests
from regular block device to dm device.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 drivers/md/dm-core.h          |  20 ++
 drivers/md/dm-ioctl.c         |  39 ++++
 drivers/md/dm.c               | 376 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/dm-ioctl.h |  15 +-
 4 files changed, 438 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 086d293c2b03..7ef4c44609dc 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -13,6 +13,7 @@
 #include <linux/ktime.h>
 #include <linux/genhd.h>
 #include <linux/blk-mq.h>
+#include <linux/rbtree.h>
 
 #include <trace/events/block.h>
 
@@ -109,6 +110,9 @@ struct mapped_device {
 	bool init_tio_pdu:1;
 
 	struct srcu_struct io_barrier;
+
+	/* interposer device for remap */
+	struct dm_interposed_dev *ip_dev;
 };
 
 void disable_discard(struct mapped_device *md);
@@ -164,6 +168,22 @@ struct dm_table {
 	struct dm_md_mempools *mempools;
 };
 
+struct dm_rb_range {
+	struct rb_node node;
+	sector_t start;		/* start sector of rb node */
+	sector_t last;		/* end sector of rb node */
+	sector_t _subtree_last; /* highest sector in subtree of rb node */
+};
+
+void dm_rb_insert(struct dm_rb_range *node, struct rb_root_cached *root);
+void dm_rb_remove(struct dm_rb_range *node, struct rb_root_cached *root);
+
+struct dm_rb_range *dm_rb_iter_first(struct rb_root_cached *root, sector_t start, sector_t last);
+struct dm_rb_range *dm_rb_iter_next(struct dm_rb_range *node, sector_t start, sector_t last);
+
+int dm_remap_install(struct mapped_device *md, const char *donor_device_name);
+int dm_remap_uninstall(struct mapped_device *md);
+
 static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
 {
 	return &container_of(kobj, struct dm_kobject_holder, kobj)->completion;
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 5e306bba4375..2944d442c256 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1649,6 +1649,44 @@ static int target_message(struct file *filp, struct dm_ioctl *param, size_t para
 	return r;
 }
 
+static inline int dev_remap_start(struct mapped_device *md, uint8_t *params)
+{
+	char *donor_device_name = (char *)params;
+
+	return dm_remap_install(md, donor_device_name);
+}
+static int dev_remap_finish(struct mapped_device *md)
+{
+	return dm_remap_uninstall(md);
+}
+
+static int dev_remap(struct file *filp, struct dm_ioctl *param, size_t param_size)
+{
+	int ret = 0;
+	struct mapped_device *md;
+	void *bin_data;
+	struct dm_remap_param *remap_param;
+
+	md = find_device(param);
+	if (!md)
+		return -ENXIO;
+
+	bin_data = (void *)(param) + param->data_start;
+	remap_param = bin_data;
+
+	if (remap_param->cmd == REMAP_START_CMD)
+		ret = dev_remap_start(md, remap_param->params);
+	else if (remap_param->cmd == REMAP_FINISH_CMD)
+		ret = dev_remap_finish(md);
+	else {
+		DMWARN("Invalid remap command, %d", remap_param->cmd);
+		ret = -EINVAL;
+	}
+
+	dm_put(md);
+	return ret;
+}
+
 /*
  * The ioctl parameter block consists of two parts, a dm_ioctl struct
  * followed by a data buffer.  This flag is set if the second part,
@@ -1691,6 +1729,7 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 		{DM_DEV_SET_GEOMETRY_CMD, 0, dev_set_geometry},
 		{DM_DEV_ARM_POLL, IOCTL_FLAGS_NO_PARAMS, dev_arm_poll},
 		{DM_GET_TARGET_VERSION, 0, get_target_version},
+		{DM_DEV_REMAP_CMD, 0, dev_remap},
 	};
 
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7bac564f3faa..0b184dfec233 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -28,6 +28,7 @@
 #include <linux/refcount.h>
 #include <linux/part_stat.h>
 #include <linux/blk-crypto.h>
+#include <linux/interval_tree_generic.h>
 
 #define DM_MSG_PREFIX "core"
 
@@ -56,6 +57,8 @@ static struct workqueue_struct *deferred_remove_workqueue;
 atomic_t dm_global_event_nr = ATOMIC_INIT(0);
 DECLARE_WAIT_QUEUE_HEAD(dm_global_eventq);
 
+static DEFINE_MUTEX(dm_interposer_attach_lock);
+
 void dm_issue_global_event(void)
 {
 	atomic_inc(&dm_global_event_nr);
@@ -162,6 +165,37 @@ struct table_device {
 	struct dm_dev dm_dev;
 };
 
+/*
+ * Device mapper's interposer.
+ */
+struct dm_interposer {
+	struct blk_interposer blk_ip;
+	struct mapped_device *md;
+
+	struct kref kref;
+	struct rw_semaphore ip_devs_lock;
+	struct rb_root_cached ip_devs_root; /* dm_interposed_dev tree */
+};
+
+typedef void (*dm_interpose_bio_t) (void *context, struct dm_rb_range *node,  struct bio *bio);
+
+struct dm_interposed_dev {
+	struct gendisk *disk;
+	struct dm_rb_range node;
+	void *context;
+	dm_interpose_bio_t dm_interpose_bio;
+
+	atomic64_t ip_cnt; /*for debug purpose*/
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
 /*
  * Bio-based DM's mempools' reserved IOs set by the user.
  */
@@ -733,28 +767,342 @@ static void dm_put_live_table_fast(struct mapped_device *md) __releases(RCU)
 	rcu_read_unlock();
 }
 
+static void dm_submit_bio_interposer_fn(struct bio *bio)
+{
+	struct dm_interposer *ip;
+	unsigned int noio_flag = 0;
+	sector_t start;
+	sector_t last;
+	struct dm_rb_range *node;
+
+	ip = container_of(bio->bi_disk->interposer, struct dm_interposer, blk_ip);
+	start = bio->bi_iter.bi_sector;
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
+		ip_dev->dm_interpose_bio(ip_dev->context, node, bio);
+
+		node = dm_rb_iter_next(node, start, last);
+	}
+	up_read(&ip->ip_devs_lock);
+	memalloc_noio_restore(noio_flag);
+}
+
+static void dm_interposer_free(struct kref *kref)
+{
+	struct dm_interposer *ip = container_of(kref, struct dm_interposer, kref);
+
+	blk_interposer_detach(&ip->blk_ip, dm_submit_bio_interposer_fn);
+
+	kfree(ip);
+}
+
+static struct dm_interposer *dm_interposer_new(struct gendisk *disk)
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
+	ret = blk_interposer_attach(disk, &ip->blk_ip, dm_submit_bio_interposer_fn);
+	if (ret) {
+		DMERR("Failed to attack blk_interposer");
+		kref_put(&ip->kref, dm_interposer_free);
+		return ERR_PTR(ret);
+	}
+
+	return ip;
+}
+
+static struct dm_interposer *dm_interposer_get(struct gendisk *disk)
+{
+	struct dm_interposer *ip;
+
+	if (!blk_has_interposer(disk))
+		return NULL;
+
+	if (disk->interposer->ip_submit_bio != dm_submit_bio_interposer_fn) {
+		DMERR("Disks interposer slot already occupied.");
+		return ERR_PTR(-EBUSY);
+	}
+
+	ip = container_of(disk->interposer, struct dm_interposer, blk_ip);
+
+	kref_get(&ip->kref);
+	return ip;
+}
+
+static struct dm_interposed_dev *dm_interposer_new_dev(struct gendisk *disk,
+						       sector_t ofs, sector_t len,
+						       void *context,
+						       dm_interpose_bio_t dm_interpose_bio)
+{
+	sector_t start = ofs;
+	sector_t last =  ofs + len - 1;
+	struct dm_interposed_dev *ip_dev = NULL;
+
+	/* Allocate new ip_dev */
+	ip_dev = kzalloc(sizeof(struct dm_interposed_dev), GFP_KERNEL);
+	if (!ip_dev)
+		return NULL;
+
+	ip_dev->disk = disk;
+	ip_dev->node.start = start;
+	ip_dev->node.last = last;
+
+	ip_dev->context = context;
+	ip_dev->dm_interpose_bio = dm_interpose_bio;
+
+	atomic64_set(&ip_dev->ip_cnt, 0);
+
+	return ip_dev;
+}
+
+static inline void dm_interposer_free_dev(struct dm_interposed_dev *ip_dev)
+{
+	kfree(ip_dev);
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
+static int dm_interposer_attach_dev(struct dm_interposed_dev *ip_dev)
+{
+	int ret = 0;
+	struct dm_interposer *ip = NULL;
+	unsigned int noio_flag = 0;
+
+	if (!ip_dev)
+		return -EINVAL;
+
+	dm_disk_freeze(ip_dev->disk);
+	mutex_lock(&dm_interposer_attach_lock);
+	noio_flag = memalloc_noio_save();
+
+	ip = dm_interposer_get(ip_dev->disk);
+	if (ip == NULL)
+		ip = dm_interposer_new(ip_dev->disk);
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
+			DMERR("Disk part form [%llu] to [%llu] already have interposer",
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
+	dm_disk_unfreeze(ip_dev->disk);
+
+	return ret;
+}
+
+static int dm_interposer_detach_dev(struct dm_interposed_dev *ip_dev)
+{
+	int ret = 0;
+	struct dm_interposer *ip = NULL;
+	unsigned int noio_flag = 0;
+
+	if (!ip_dev)
+		return -EINVAL;
+
+	dm_disk_freeze(ip_dev->disk);
+	mutex_lock(&dm_interposer_attach_lock);
+	noio_flag = memalloc_noio_save();
+
+	ip = dm_interposer_get(ip_dev->disk);
+	if (IS_ERR(ip)) {
+		ret = PTR_ERR(ip);
+		DMERR("Interposer not found");
+		goto out;
+	}
+	if (unlikely(ip == NULL)) {
+		ret = -ENXIO;
+		DMERR("Interposer not found");
+		goto out;
+	}
+
+	down_write(&ip->ip_devs_lock);
+	do {
+		dm_rb_remove(&ip_dev->node, &ip->ip_devs_root);
+		/* the reference counter here cannot be zero */
+		kref_put(&ip->kref, dm_interposer_free);
+
+	} while (false);
+	up_write(&ip->ip_devs_lock);
+
+	/* detach and free interposer if it's not needed */
+	kref_put(&ip->kref, dm_interposer_free);
+out:
+	memalloc_noio_restore(noio_flag);
+	mutex_unlock(&dm_interposer_attach_lock);
+	dm_disk_unfreeze(ip_dev->disk);
+
+	return ret;
+}
+
+static void dm_remap_fn(void *context, struct dm_rb_range *node, struct bio *bio)
+{
+	struct mapped_device *md = context;
+
+	/* Set acceptor device. */
+	bio->bi_disk = md->disk;
+
+	/* Remap disks offset */
+	bio->bi_iter.bi_sector -= node->start;
+
+	/*
+	 * bio should be resubmitted.
+	 * We can just add bio to bio_list of the current process.
+	 * current->bio_list must be initialized when this function is called.
+	 * If call submit_bio_noacct(), the bio will be checked twice.
+	 */
+	BUG_ON(!current->bio_list);
+	bio_list_add(&current->bio_list[0], bio);
+}
+
+int dm_remap_install(struct mapped_device *md, const char *donor_device_name)
+{
+	int ret = 0;
+	struct block_device *donor_bdev;
+	fmode_t mode = FMODE_READ | FMODE_WRITE;
+
+	DMDEBUG("Dm remap install for mapped device %s and donor device %s",
+		md->name, donor_device_name);
+
+	donor_bdev = blkdev_get_by_path(donor_device_name, mode, "device-mapper remap");
+	if (IS_ERR(donor_bdev)) {
+		DMERR("Cannot open device [%s]", donor_device_name);
+		return PTR_ERR(donor_bdev);
+	}
+
+	do {
+		sector_t ofs = get_start_sect(donor_bdev);
+		sector_t len = bdev_nr_sectors(donor_bdev);
+
+		md->ip_dev = dm_interposer_new_dev(donor_bdev->bd_disk, ofs, len, md, dm_remap_fn);
+		if (!md->ip_dev) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		DMDEBUG("New interposed device 0x%p", md->ip_dev);
+		ret = dm_interposer_attach_dev(md->ip_dev);
+		if (ret) {
+			dm_interposer_free_dev(md->ip_dev);
+
+			md->ip_dev = NULL;
+			DMERR("Failed to attach dm interposer");
+			break;
+		}
+
+		DMDEBUG("Attached successfully.");
+	} while (false);
+
+	blkdev_put(donor_bdev, mode);
+
+	return ret;
+}
+
+int dm_remap_uninstall(struct mapped_device *md)
+{
+	int ret = 0;
+
+	DMDEBUG("Dm remap uninstall for mapped device %s ip_dev=0x%p", md->name, md->ip_dev);
+
+	if (!md->ip_dev) {
+		DMERR("Cannot detach dm interposer");
+		return -EINVAL;
+	}
+
+	ret = dm_interposer_detach_dev(md->ip_dev);
+	if (ret) {
+		DMERR("Failed to detach dm interposer");
+		return ret;
+	}
+
+	DMDEBUG("Detached successfully. %llu bios was interposed",
+		atomic64_read(&md->ip_dev->ip_cnt));
+	dm_interposer_free_dev(md->ip_dev);
+	md->ip_dev = NULL;
+
+	return 0;
+}
+
 static char *_dm_claim_ptr = "I belong to device-mapper";
 
 /*
  * Open a table device so we can use it as a map destination.
  */
 static int open_table_device(struct table_device *td, dev_t dev,
-			     struct mapped_device *md)
+			     struct mapped_device *md, bool non_exclusive)
 {
 	struct block_device *bdev;
-
-	int r;
+	int ret;
 
 	BUG_ON(td->dm_dev.bdev);
 
-	bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
-	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
+	if (non_exclusive)
+		bdev = blkdev_get_by_dev(dev, td->dm_dev.mode, NULL);
+	else
+		bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
 
-	r = bd_link_disk_holder(bdev, dm_disk(md));
-	if (r) {
-		blkdev_put(bdev, td->dm_dev.mode | FMODE_EXCL);
-		return r;
+	if (IS_ERR(bdev)) {
+		ret = PTR_ERR(bdev);
+		if (ret != -EBUSY)
+			return ret;
+	}
+
+	if (!non_exclusive) {
+		ret = bd_link_disk_holder(bdev, dm_disk(md));
+		if (ret) {
+			blkdev_put(bdev, td->dm_dev.mode);
+			return ret;
+		}
 	}
 
 	td->dm_dev.bdev = bdev;
@@ -2182,6 +2530,14 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 
 	might_sleep();
 
+	if (md->ip_dev) {
+		if (dm_interposer_detach_dev(md->ip_dev))
+			DMERR("Failed to detach dm interposer");
+
+		dm_interposer_free_dev(md->ip_dev);
+		md->ip_dev = NULL;
+	}
+
 	spin_lock(&_minor_lock);
 	idr_replace(&_minor_idr, MINOR_ALLOCED, MINOR(disk_devt(dm_disk(md))));
 	set_bit(DMF_FREEING, &md->flags);
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 4933b6b67b85..08d7dbff80f4 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -214,6 +214,15 @@ struct dm_target_msg {
 	char message[0];
 };
 
+enum {
+	REMAP_START_CMD = 1,
+	REMAP_FINISH_CMD,
+};
+
+struct dm_remap_param {
+	uint8_t cmd;
+	uint8_t params[0];
+};
 /*
  * If you change this make sure you make the corresponding change
  * to dm-ioctl.c:lookup_ioctl()
@@ -244,6 +253,7 @@ enum {
 	DM_DEV_SET_GEOMETRY_CMD,
 	DM_DEV_ARM_POLL_CMD,
 	DM_GET_TARGET_VERSION_CMD,
+	DM_DEV_REMAP_CMD
 };
 
 #define DM_IOCTL 0xfd
@@ -259,6 +269,7 @@ enum {
 #define DM_DEV_STATUS    _IOWR(DM_IOCTL, DM_DEV_STATUS_CMD, struct dm_ioctl)
 #define DM_DEV_WAIT      _IOWR(DM_IOCTL, DM_DEV_WAIT_CMD, struct dm_ioctl)
 #define DM_DEV_ARM_POLL  _IOWR(DM_IOCTL, DM_DEV_ARM_POLL_CMD, struct dm_ioctl)
+#define DM_DEV_REMAP     _IOWR(DM_IOCTL, DM_DEV_REMAP_CMD, struct dm_ioctl)
 
 #define DM_TABLE_LOAD    _IOWR(DM_IOCTL, DM_TABLE_LOAD_CMD, struct dm_ioctl)
 #define DM_TABLE_CLEAR   _IOWR(DM_IOCTL, DM_TABLE_CLEAR_CMD, struct dm_ioctl)
@@ -272,9 +283,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	43
+#define DM_VERSION_MINOR	44
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2020-10-01)"
+#define DM_VERSION_EXTRA	"-ioctl (2020-12-25)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

