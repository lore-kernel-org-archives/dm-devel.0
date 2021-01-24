Return-Path: <SRS0=PWLs=G3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F660C433DB
	for <dm-devel@archiver.kernel.org>; Sun, 24 Jan 2021 10:06:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 797DC225A9
	for <dm-devel@archiver.kernel.org>; Sun, 24 Jan 2021 10:06:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 797DC225A9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-2liYO0vPOSCUgJS7fWreqA-1; Sun, 24 Jan 2021 05:06:38 -0500
X-MC-Unique: 2liYO0vPOSCUgJS7fWreqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A158F806663;
	Sun, 24 Jan 2021 10:06:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7295F60C66;
	Sun, 24 Jan 2021 10:06:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9861F4A7C6;
	Sun, 24 Jan 2021 10:06:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10OA6PKb004981 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 24 Jan 2021 05:06:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 470881111C81; Sun, 24 Jan 2021 10:06:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 431431004057
	for <dm-devel@redhat.com>; Sun, 24 Jan 2021 10:06:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5EE2811E78
	for <dm-devel@redhat.com>; Sun, 24 Jan 2021 10:06:22 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-457-5WjMKkouOTWpjXA7RBhpQQ-1; Sun, 24 Jan 2021 05:06:20 -0500
X-MC-Unique: 5WjMKkouOTWpjXA7RBhpQQ-1
Received: from [2001:4bb8:188:1954:a3b3:627f:702b:2136] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1l3cHQ-002qAo-TX; Sun, 24 Jan 2021 10:06:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sun, 24 Jan 2021 11:02:41 +0100
Message-Id: <20210124100241.1167849-11-hch@lst.de>
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-s390@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 10/10] block: use an xarray for disk->part_tbl
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now that no fast path lookups in the partition table are left, there is
no point in micro-optimizing the data structure for it.  Just use a bog
standard xarray.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-settings.c    |   2 +-
 block/blk.h             |   1 -
 block/genhd.c           | 163 +++-------------------------------------
 block/partitions/core.c |  31 ++------
 include/linux/genhd.h   |  18 +----
 5 files changed, 22 insertions(+), 193 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 43990b1d148b87..4c974340f1a992 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -865,7 +865,7 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 		 * we do nothing special as far as the block layer is concerned.
 		 */
 		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||
-		    disk_has_partitions(disk))
+		    !xa_empty(&disk->part_tbl))
 			model = BLK_ZONED_NONE;
 		break;
 	case BLK_ZONED_NONE:
diff --git a/block/blk.h b/block/blk.h
index d965cacc5bdaa1..ab0aaf958553bc 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -345,7 +345,6 @@ int bdev_add_partition(struct block_device *bdev, int partno,
 int bdev_del_partition(struct block_device *bdev, int partno);
 int bdev_resize_partition(struct block_device *bdev, int partno,
 		sector_t start, sector_t length);
-int disk_expand_part_tbl(struct gendisk *disk, int target);
 
 int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 		struct page *page, unsigned int len, unsigned int offset,
diff --git a/block/genhd.c b/block/genhd.c
index 1832add5c73849..d3ef29fbc53639 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -161,15 +161,6 @@ static void part_in_flight_rw(struct block_device *part,
 		inflight[1] = 0;
 }
 
-static struct block_device *__disk_get_part(struct gendisk *disk, int partno)
-{
-	struct disk_part_tbl *ptbl = rcu_dereference(disk->part_tbl);
-
-	if (unlikely(partno < 0 || partno >= ptbl->len))
-		return NULL;
-	return rcu_dereference(ptbl->part[partno]);
-}
-
 /**
  * disk_part_iter_init - initialize partition iterator
  * @piter: iterator to initialize
@@ -204,41 +195,26 @@ void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
  */
 struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 {
-	struct disk_part_tbl *ptbl;
+	struct block_device *part;
+	unsigned long idx;
 
 	/* put the last partition */
 	disk_part_iter_exit(piter);
 
-	/* get part_tbl */
 	rcu_read_lock();
-	ptbl = rcu_dereference(piter->disk->part_tbl);
-
-	/* iterate to the next partition */
-	for (; piter->idx != ptbl->len; piter->idx += 1) {
-		struct block_device *part;
-
-		part = rcu_dereference(ptbl->part[piter->idx]);
-		if (!part)
-			continue;
-		piter->part = bdgrab(part);
-		if (!piter->part)
-			continue;
+	xa_for_each_start(&piter->disk->part_tbl, idx, part, piter->idx) {
 		if (!bdev_nr_sectors(part) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
-		      piter->idx == 0)) {
-			bdput(piter->part);
-			piter->part = NULL;
+		      piter->idx == 0))
 			continue;
-		}
 
 		piter->part = bdgrab(part);
 		if (!piter->part)
 			continue;
-		piter->idx += 1;
+		piter->idx = idx + 1;
 		break;
 	}
-
 	rcu_read_unlock();
 
 	return piter->part;
@@ -260,42 +236,6 @@ void disk_part_iter_exit(struct disk_part_iter *piter)
 	piter->part = NULL;
 }
 
-/**
- * disk_has_partitions
- * @disk: gendisk of interest
- *
- * Walk through the partition table and check if valid partition exists.
- *
- * CONTEXT:
- * Don't care.
- *
- * RETURNS:
- * True if the gendisk has at least one valid non-zero size partition.
- * Otherwise false.
- */
-bool disk_has_partitions(struct gendisk *disk)
-{
-	struct disk_part_tbl *ptbl;
-	int i;
-	bool ret = false;
-
-	rcu_read_lock();
-	ptbl = rcu_dereference(disk->part_tbl);
-
-	/* Iterate partitions skipping the whole device at index 0 */
-	for (i = 1; i < ptbl->len; i++) {
-		if (rcu_dereference(ptbl->part[i])) {
-			ret = true;
-			break;
-		}
-	}
-
-	rcu_read_unlock();
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(disk_has_partitions);
-
 /*
  * Can be deleted altogether. Later.
  *
@@ -858,7 +798,7 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
 	struct block_device *bdev = NULL;
 
 	rcu_read_lock();
-	bdev = __disk_get_part(disk, partno);
+	bdev = xa_load(&disk->part_tbl, partno);
 	if (bdev && !bdgrab(bdev))
 		bdev = NULL;
 	rcu_read_unlock();
@@ -1248,83 +1188,6 @@ static const struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
-/**
- * disk_replace_part_tbl - replace disk->part_tbl in RCU-safe way
- * @disk: disk to replace part_tbl for
- * @new_ptbl: new part_tbl to install
- *
- * Replace disk->part_tbl with @new_ptbl in RCU-safe way.  The
- * original ptbl is freed using RCU callback.
- *
- * LOCKING:
- * Matching bd_mutex locked or the caller is the only user of @disk.
- */
-static void disk_replace_part_tbl(struct gendisk *disk,
-				  struct disk_part_tbl *new_ptbl)
-{
-	struct disk_part_tbl *old_ptbl =
-		rcu_dereference_protected(disk->part_tbl, 1);
-
-	rcu_assign_pointer(disk->part_tbl, new_ptbl);
-
-	if (old_ptbl) {
-		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
-		kfree_rcu(old_ptbl, rcu_head);
-	}
-}
-
-/**
- * disk_expand_part_tbl - expand disk->part_tbl
- * @disk: disk to expand part_tbl for
- * @partno: expand such that this partno can fit in
- *
- * Expand disk->part_tbl such that @partno can fit in.  disk->part_tbl
- * uses RCU to allow unlocked dereferencing for stats and other stuff.
- *
- * LOCKING:
- * Matching bd_mutex locked or the caller is the only user of @disk.
- * Might sleep.
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int disk_expand_part_tbl(struct gendisk *disk, int partno)
-{
-	struct disk_part_tbl *old_ptbl =
-		rcu_dereference_protected(disk->part_tbl, 1);
-	struct disk_part_tbl *new_ptbl;
-	int len = old_ptbl ? old_ptbl->len : 0;
-	int i, target;
-
-	/*
-	 * check for int overflow, since we can get here from blkpg_ioctl()
-	 * with a user passed 'partno'.
-	 */
-	target = partno + 1;
-	if (target < 0)
-		return -EINVAL;
-
-	/* disk_max_parts() is zero during initialization, ignore if so */
-	if (disk_max_parts(disk) && target > disk_max_parts(disk))
-		return -EINVAL;
-
-	if (target <= len)
-		return 0;
-
-	new_ptbl = kzalloc_node(struct_size(new_ptbl, part, target), GFP_KERNEL,
-				disk->node_id);
-	if (!new_ptbl)
-		return -ENOMEM;
-
-	new_ptbl->len = target;
-
-	for (i = 0; i < len; i++)
-		rcu_assign_pointer(new_ptbl->part[i], old_ptbl->part[i]);
-
-	disk_replace_part_tbl(disk, new_ptbl);
-	return 0;
-}
-
 /**
  * disk_release - releases all allocated resources of the gendisk
  * @dev: the device representing this disk
@@ -1348,7 +1211,7 @@ static void disk_release(struct device *dev)
 	blk_free_devt(dev->devt);
 	disk_release_events(disk);
 	kfree(disk->random);
-	disk_replace_part_tbl(disk, NULL);
+	xa_destroy(&disk->part_tbl);
 	bdput(disk->part0);
 	if (disk->queue)
 		blk_put_queue(disk->queue);
@@ -1501,7 +1364,6 @@ dev_t blk_lookup_devt(const char *name, int partno)
 struct gendisk *__alloc_disk_node(int minors, int node_id)
 {
 	struct gendisk *disk;
-	struct disk_part_tbl *ptbl;
 
 	if (minors > DISK_MAX_PARTS) {
 		printk(KERN_ERR
@@ -1519,11 +1381,9 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 		goto out_free_disk;
 
 	disk->node_id = node_id;
-	if (disk_expand_part_tbl(disk, 0))
-		goto out_bdput;
-
-	ptbl = rcu_dereference_protected(disk->part_tbl, 1);
-	rcu_assign_pointer(ptbl->part[0], disk->part0);
+	xa_init(&disk->part_tbl);
+	if (xa_insert(&disk->part_tbl, 0, disk->part0, GFP_KERNEL))
+		goto out_destroy_part_tbl;
 
 	disk->minors = minors;
 	rand_initialize_disk(disk);
@@ -1532,7 +1392,8 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 	device_initialize(disk_to_dev(disk));
 	return disk;
 
-out_bdput:
+out_destroy_part_tbl:
+	xa_destroy(&disk->part_tbl);
 	bdput(disk->part0);
 out_free_disk:
 	kfree(disk);
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 168d5906077cfd..b1cdf88f96e236 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -287,13 +287,7 @@ struct device_type part_type = {
  */
 void delete_partition(struct block_device *part)
 {
-	struct gendisk *disk = part->bd_disk;
-	struct disk_part_tbl *ptbl =
-		rcu_dereference_protected(disk->part_tbl, 1);
-
-	rcu_assign_pointer(ptbl->part[part->bd_partno], NULL);
-	rcu_assign_pointer(ptbl->last_lookup, NULL);
-
+	xa_erase(&part->bd_disk->part_tbl, part->bd_partno);
 	kobject_put(part->bd_holder_dir);
 	device_del(&part->bd_device);
 
@@ -325,7 +319,6 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	struct device *ddev = disk_to_dev(disk);
 	struct device *pdev;
 	struct block_device *bdev;
-	struct disk_part_tbl *ptbl;
 	const char *dname;
 	int err;
 
@@ -347,12 +340,7 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 		break;
 	}
 
-	err = disk_expand_part_tbl(disk, partno);
-	if (err)
-		return ERR_PTR(err);
-	ptbl = rcu_dereference_protected(disk->part_tbl, 1);
-
-	if (ptbl->part[partno])
+	if (xa_load(&disk->part_tbl, partno))
 		return ERR_PTR(-EBUSY);
 
 	bdev = bdev_alloc(disk, partno);
@@ -405,8 +393,10 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	}
 
 	/* everything is up and running, commence */
+	err = xa_insert(&disk->part_tbl, partno, bdev, GFP_KERNEL);
+	if (err)
+		goto out_del;
 	bdev_add(bdev, devt);
-	rcu_assign_pointer(ptbl->part[partno], bdev);
 
 	/* suppress uevent if the disk suppresses it */
 	if (!dev_get_uevent_suppress(ddev))
@@ -612,7 +602,7 @@ static bool blk_add_partition(struct gendisk *disk, struct block_device *bdev,
 int blk_add_partitions(struct gendisk *disk, struct block_device *bdev)
 {
 	struct parsed_partitions *state;
-	int ret = -EAGAIN, p, highest;
+	int ret = -EAGAIN, p;
 
 	if (!disk_part_scan_enabled(disk))
 		return 0;
@@ -660,15 +650,6 @@ int blk_add_partitions(struct gendisk *disk, struct block_device *bdev)
 	/* tell userspace that the media / partition table may have changed */
 	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
 
-	/*
-	 * Detect the highest partition number and preallocate disk->part_tbl.
-	 * This is an optimization and not strictly necessary.
-	 */
-	for (p = 1, highest = 0; p < state->limit; p++)
-		if (state->parts[p].size)
-			highest = p;
-	disk_expand_part_tbl(disk, highest);
-
 	for (p = 1; p < state->limit; p++)
 		if (!blk_add_partition(disk, bdev, state, p))
 			goto out_free_state;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 51609133c9a347..f364619092cca0 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -32,6 +32,7 @@ extern struct class block_class;
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/workqueue.h>
+#include <linux/xarray.h>
 
 #define PARTITION_META_INFO_VOLNAMELTH	64
 /*
@@ -116,13 +117,6 @@ enum {
 	DISK_EVENT_FLAG_UEVENT			= 1 << 1,
 };
 
-struct disk_part_tbl {
-	struct rcu_head rcu_head;
-	int len;
-	struct block_device __rcu *last_lookup;
-	struct block_device __rcu *part[];
-};
-
 struct disk_events;
 struct badblocks;
 
@@ -148,12 +142,7 @@ struct gendisk {
 	unsigned short events;		/* supported events */
 	unsigned short event_flags;	/* flags related to event processing */
 
-	/* Array of pointers to partitions indexed by partno.
-	 * Protected with matching bdev lock but stat and other
-	 * non-critical accesses use RCU.  Always access through
-	 * helpers.
-	 */
-	struct disk_part_tbl __rcu *part_tbl;
+	struct xarray part_tbl;
 	struct block_device *part0;
 
 	const struct block_device_operations *fops;
@@ -225,7 +214,7 @@ void disk_uevent(struct gendisk *disk, enum kobject_action action);
 struct disk_part_iter {
 	struct gendisk		*disk;
 	struct block_device	*part;
-	int			idx;
+	unsigned long		idx;
 	unsigned int		flags;
 };
 
@@ -233,7 +222,6 @@ extern void disk_part_iter_init(struct disk_part_iter *piter,
 				 struct gendisk *disk, unsigned int flags);
 struct block_device *disk_part_iter_next(struct disk_part_iter *piter);
 extern void disk_part_iter_exit(struct disk_part_iter *piter);
-extern bool disk_has_partitions(struct gendisk *disk);
 
 /* block/genhd.c */
 extern void device_add_disk(struct device *parent, struct gendisk *disk,
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

