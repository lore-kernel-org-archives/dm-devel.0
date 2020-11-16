Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B24C82546
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:01:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 545782462E
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:01:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 545782462E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-a8qQBWFiPqSBhVRKf58wdg-1; Mon, 16 Nov 2020 10:00:28 -0500
X-MC-Unique: a8qQBWFiPqSBhVRKf58wdg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C8E11075655;
	Mon, 16 Nov 2020 14:59:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FF5D5D9CC;
	Mon, 16 Nov 2020 14:59:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 064035812B;
	Mon, 16 Nov 2020 14:59:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGExZkM015570 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 09:59:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2A7E32011553; Mon, 16 Nov 2020 14:59:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 259E1205F3B0
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08FC690E426
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 14:59:35 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-293-7gkVXo1yP8OgkGYc0vAwAQ-1; Mon, 16 Nov 2020 09:59:29 -0500
X-MC-Unique: 7gkVXo1yP8OgkGYc0vAwAQ-1
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kefyW-00043h-2j; Mon, 16 Nov 2020 14:59:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 16 Nov 2020 15:57:43 +0100
Message-Id: <20201116145809.410558-53-hch@lst.de>
In-Reply-To: <20201116145809.410558-1-hch@lst.de>
References: <20201116145809.410558-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [dm-devel] [PATCH 52/78] block: switch gendisk lookup to a simple
	xarray
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now that bdev_map is only used for finding gendisks, we can use
a simple xarray instead of the regions tracking structure for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c         | 208 ++++++++----------------------------------
 include/linux/genhd.h |   7 --
 2 files changed, 37 insertions(+), 178 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index dc8690bc281c16..4a224a3c8e1071 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -27,15 +27,7 @@
 
 static struct kobject *block_depr;
 
-struct bdev_map {
-	struct bdev_map *next;
-	dev_t dev;
-	unsigned long range;
-	struct module *owner;
-	struct kobject *(*probe)(dev_t, int *, void *);
-	int (*lock)(dev_t, void *);
-	void *data;
-} *bdev_map[255];
+static DEFINE_XARRAY(bdev_map);
 static DEFINE_MUTEX(bdev_map_lock);
 
 /* for extended dynamic devt allocation, currently only one major is used */
@@ -646,85 +638,26 @@ static char *bdevt_str(dev_t devt, char *buf)
 	return buf;
 }
 
-/*
- * Register device numbers dev..(dev+range-1)
- * range must be nonzero
- * The hash chain is sorted on range, so that subranges can override.
- */
-void blk_register_region(dev_t devt, unsigned long range, struct module *module,
-			 struct kobject *(*probe)(dev_t, int *, void *),
-			 int (*lock)(dev_t, void *), void *data)
-{
-	unsigned n = MAJOR(devt + range - 1) - MAJOR(devt) + 1;
-	unsigned index = MAJOR(devt);
-	unsigned i;
-	struct bdev_map *p;
-
-	n = min(n, 255u);
-	p = kmalloc_array(n, sizeof(struct bdev_map), GFP_KERNEL);
-	if (p == NULL)
-		return;
-
-	for (i = 0; i < n; i++, p++) {
-		p->owner = module;
-		p->probe = probe;
-		p->lock = lock;
-		p->dev = devt;
-		p->range = range;
-		p->data = data;
-	}
+static void blk_register_region(struct gendisk *disk)
+{
+	int i;
 
 	mutex_lock(&bdev_map_lock);
-	for (i = 0, p -= n; i < n; i++, p++, index++) {
-		struct bdev_map **s = &bdev_map[index % 255];
-		while (*s && (*s)->range < range)
-			s = &(*s)->next;
-		p->next = *s;
-		*s = p;
+	for (i = 0; i < disk->minors; i++) {
+		if (xa_insert(&bdev_map, disk_devt(disk) + i, disk, GFP_KERNEL))
+			WARN_ON_ONCE(1);
 	}
 	mutex_unlock(&bdev_map_lock);
 }
-EXPORT_SYMBOL(blk_register_region);
 
-void blk_unregister_region(dev_t devt, unsigned long range)
+static void blk_unregister_region(struct gendisk *disk)
 {
-	unsigned n = MAJOR(devt + range - 1) - MAJOR(devt) + 1;
-	unsigned index = MAJOR(devt);
-	unsigned i;
-	struct bdev_map *found = NULL;
+	int i;
 
 	mutex_lock(&bdev_map_lock);
-	for (i = 0; i < min(n, 255u); i++, index++) {
-		struct bdev_map **s;
-		for (s = &bdev_map[index % 255]; *s; s = &(*s)->next) {
-			struct bdev_map *p = *s;
-			if (p->dev == devt && p->range == range) {
-				*s = p->next;
-				if (!found)
-					found = p;
-				break;
-			}
-		}
-	}
+	for (i = 0; i < disk->minors; i++)
+		xa_erase(&bdev_map, disk_devt(disk) + i);
 	mutex_unlock(&bdev_map_lock);
-	kfree(found);
-}
-EXPORT_SYMBOL(blk_unregister_region);
-
-static struct kobject *exact_match(dev_t devt, int *partno, void *data)
-{
-	struct gendisk *p = data;
-
-	return &disk_to_dev(p)->kobj;
-}
-
-static int exact_lock(dev_t devt, void *data)
-{
-	struct gendisk *p = data;
-
-	if (!get_disk_and_module(p))
-		return -1;
-	return 0;
 }
 
 static void disk_scan_partitions(struct gendisk *disk)
@@ -870,8 +803,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 		ret = bdi_register(bdi, "%u:%u", MAJOR(devt), MINOR(devt));
 		WARN_ON(ret);
 		bdi_set_owner(bdi, dev);
-		blk_register_region(disk_devt(disk), disk->minors, NULL,
-				    exact_match, exact_lock, disk);
+		blk_register_region(disk);
 	}
 	register_disk(parent, disk, groups);
 	if (register_queue)
@@ -984,7 +916,7 @@ void del_gendisk(struct gendisk *disk)
 	blk_unregister_queue(disk);
 	
 	if (!(disk->flags & GENHD_FL_HIDDEN))
-		blk_unregister_region(disk_devt(disk), disk->minors);
+		blk_unregister_region(disk);
 	/*
 	 * Remove gendisk pointer from idr so that it cannot be looked up
 	 * while RCU period before freeing gendisk is running to prevent
@@ -1050,54 +982,22 @@ static void request_gendisk_module(dev_t devt)
 		request_module("block-major-%d", MAJOR(devt));
 }
 
-static struct gendisk *lookup_gendisk(dev_t dev, int *partno)
+static bool get_disk_and_module(struct gendisk *disk)
 {
-	struct kobject *kobj;
-	struct bdev_map *p;
-	unsigned long best = ~0UL;
-
-retry:
-	mutex_lock(&bdev_map_lock);
-	for (p = bdev_map[MAJOR(dev) % 255]; p; p = p->next) {
-		struct kobject *(*probe)(dev_t, int *, void *);
-		struct module *owner;
-		void *data;
-
-		if (p->dev > dev || p->dev + p->range - 1 < dev)
-			continue;
-		if (p->range - 1 >= best)
-			break;
-		if (!try_module_get(p->owner))
-			continue;
-		owner = p->owner;
-		data = p->data;
-		probe = p->probe;
-		best = p->range - 1;
-		*partno = dev - p->dev;
-
-		if (!probe) {
-			mutex_unlock(&bdev_map_lock);
-			module_put(owner);
-			request_gendisk_module(dev);
-			goto retry;
-		}
+	struct module *owner;
 
-		if (p->lock && p->lock(dev, data) < 0) {
-			module_put(owner);
-			continue;
-		}
-		mutex_unlock(&bdev_map_lock);
-		kobj = probe(dev, partno, data);
-		/* Currently ->owner protects _only_ ->probe() itself. */
+	if (!disk->fops)
+		return false;
+	owner = disk->fops->owner;
+	if (owner && !try_module_get(owner))
+		return false;
+	if (!kobject_get_unless_zero(&disk_to_dev(disk)->kobj)) {
 		module_put(owner);
-		if (kobj)
-			return dev_to_disk(kobj_to_dev(kobj));
-		goto retry;
+		return false;
 	}
-	mutex_unlock(&bdev_map_lock);
-	return NULL;
-}
+	return true;
 
+}
 
 /**
  * get_gendisk - get partitioning information for a given device
@@ -1116,7 +1016,19 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
 	might_sleep();
 
 	if (MAJOR(devt) != BLOCK_EXT_MAJOR) {
-		disk = lookup_gendisk(devt, partno);
+		mutex_lock(&bdev_map_lock);
+		disk = xa_load(&bdev_map, devt);
+		if (!disk) {
+			mutex_unlock(&bdev_map_lock);
+			request_gendisk_module(devt);
+			mutex_lock(&bdev_map_lock);
+			disk = xa_load(&bdev_map, devt);
+		}
+		if (disk && !get_disk_and_module(disk))
+			disk = NULL;
+		if (disk)
+			*partno = devt - disk_devt(disk);
+		mutex_unlock(&bdev_map_lock);
 	} else {
 		struct hd_struct *part;
 
@@ -1320,21 +1232,6 @@ static const struct seq_operations partitions_op = {
 };
 #endif
 
-static void bdev_map_init(void)
-{
-	struct bdev_map *base;
-	int i;
-
-	base = kzalloc(sizeof(*base), GFP_KERNEL);
-	if (!base)
-		panic("cannot allocate bdev_map");
-
-	base->dev = 1;
-	base->range = ~0 ;
-	for (i = 0; i < 255; i++)
-		bdev_map[i] = base;
-}
-
 static int __init genhd_device_init(void)
 {
 	int error;
@@ -1343,7 +1240,6 @@ static int __init genhd_device_init(void)
 	error = class_register(&block_class);
 	if (unlikely(error))
 		return error;
-	bdev_map_init();
 	blk_dev_init();
 
 	register_blkdev(BLOCK_EXT_MAJOR, "blkext");
@@ -1892,35 +1788,6 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 }
 EXPORT_SYMBOL(__alloc_disk_node);
 
-/**
- * get_disk_and_module - increments the gendisk and gendisk fops module refcount
- * @disk: the struct gendisk to increment the refcount for
- *
- * This increments the refcount for the struct gendisk, and the gendisk's
- * fops module owner.
- *
- * Context: Any context.
- */
-struct kobject *get_disk_and_module(struct gendisk *disk)
-{
-	struct module *owner;
-	struct kobject *kobj;
-
-	if (!disk->fops)
-		return NULL;
-	owner = disk->fops->owner;
-	if (owner && !try_module_get(owner))
-		return NULL;
-	kobj = kobject_get_unless_zero(&disk_to_dev(disk)->kobj);
-	if (kobj == NULL) {
-		module_put(owner);
-		return NULL;
-	}
-	return kobj;
-
-}
-EXPORT_SYMBOL(get_disk_and_module);
-
 /**
  * put_disk - decrements the gendisk refcount
  * @disk: the struct gendisk to decrement the refcount for
@@ -1957,7 +1824,6 @@ void put_disk_and_module(struct gendisk *disk)
 		module_put(owner);
 	}
 }
-EXPORT_SYMBOL(put_disk_and_module);
 
 static void set_disk_ro_uevent(struct gendisk *gd, int ro)
 {
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 04f6a6bf577a90..46553d6d602563 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -338,15 +338,8 @@ int blk_add_partitions(struct gendisk *disk, struct block_device *bdev);
 int blk_drop_partitions(struct block_device *bdev);
 
 extern struct gendisk *__alloc_disk_node(int minors, int node_id);
-extern struct kobject *get_disk_and_module(struct gendisk *disk);
 extern void put_disk(struct gendisk *disk);
 extern void put_disk_and_module(struct gendisk *disk);
-extern void blk_register_region(dev_t devt, unsigned long range,
-			struct module *module,
-			struct kobject *(*probe)(dev_t, int *, void *),
-			int (*lock)(dev_t, void *),
-			void *data);
-extern void blk_unregister_region(dev_t devt, unsigned long range);
 
 #define alloc_disk_node(minors, node_id)				\
 ({									\
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

