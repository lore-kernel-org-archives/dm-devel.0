Return-Path: <SRS0=byOr=FF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04737C64E7A
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:02:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1FB96206B7
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:02:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FB96206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-A3tfa7sMMtyyPh-v4cIucg-1; Tue, 01 Dec 2020 12:02:13 -0500
X-MC-Unique: A3tfa7sMMtyyPh-v4cIucg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA1A1185E48A;
	Tue,  1 Dec 2020 17:02:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CCF65D9CA;
	Tue,  1 Dec 2020 17:02:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 606E21809CA8;
	Tue,  1 Dec 2020 17:02:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B1H1s62032187 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 12:01:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 97DE92026D15; Tue,  1 Dec 2020 17:01:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 928DB2026D46
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:01:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63377800969
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:01:52 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-384--E1CMoNiPEOP9tOKiIReoA-1; Tue, 01 Dec 2020 12:01:49 -0500
X-MC-Unique: -E1CMoNiPEOP9tOKiIReoA-1
Received: from [2001:4bb8:184:6389:bbd8:a1c2:99e0:f58a] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kk8vF-0005aE-JP; Tue, 01 Dec 2020 16:54:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  1 Dec 2020 17:54:24 +0100
Message-Id: <20201201165424.2030647-10-hch@lst.de>
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
References: <20201201165424.2030647-1-hch@lst.de>
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
Cc: linux-s390@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 9/9] block: use an xarray for disk->part_tbl
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

Now that no fast path lookups in the partition table are left, there is
no point in micro-optimizing the data structure for it.  Just use a bog
standard xarray.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c    |   2 +-
 block/blk.h             |   1 -
 block/genhd.c           | 156 +++-------------------------------------
 block/partitions/core.c |  31 ++------
 include/linux/genhd.h   |  18 +----
 5 files changed, 21 insertions(+), 187 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9741d1d83e989c..969031faa88f1c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -849,7 +849,7 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 		 * we do nothing special as far as the block layer is concerned.
 		 */
 		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||
-		    disk_has_partitions(disk))
+		    !xa_empty(&disk->part_tbl))
 			model = BLK_ZONED_NONE;
 		break;
 	case BLK_ZONED_NONE:
diff --git a/block/blk.h b/block/blk.h
index f93a6af04adbd1..8d08b921bce585 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -358,7 +358,6 @@ int bdev_add_partition(struct block_device *bdev, int partno,
 int bdev_del_partition(struct block_device *bdev, int partno);
 int bdev_resize_partition(struct block_device *bdev, int partno,
 		sector_t start, sector_t length);
-int disk_expand_part_tbl(struct gendisk *disk, int target);
 
 int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 		struct page *page, unsigned int len, unsigned int offset,
diff --git a/block/genhd.c b/block/genhd.c
index 7730ddabebba92..09ff6cef028729 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -159,15 +159,6 @@ static void part_in_flight_rw(struct block_device *part,
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
@@ -202,35 +193,25 @@ void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
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
+	xa_for_each_start(&piter->disk->part_tbl, idx, part, piter->idx) {
 		if (!bdev_nr_sectors(part) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
 		      piter->idx == 0))
 			continue;
-
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
@@ -252,42 +233,6 @@ void disk_part_iter_exit(struct disk_part_iter *piter)
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
@@ -850,7 +795,7 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
 	struct block_device *bdev = NULL;
 
 	rcu_read_lock();
-	bdev = __disk_get_part(disk, partno);
+	bdev = xa_load(&disk->part_tbl, partno);
 	if (bdev && !bdgrab(bdev))
 		bdev = NULL;
 	rcu_read_unlock();
@@ -1240,83 +1185,6 @@ static const struct attribute_group *disk_attr_groups[] = {
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
@@ -1340,7 +1208,7 @@ static void disk_release(struct device *dev)
 	blk_free_devt(dev->devt);
 	disk_release_events(disk);
 	kfree(disk->random);
-	disk_replace_part_tbl(disk, NULL);
+	xa_destroy(&disk->part_tbl);
 	bdput(disk->part0);
 	if (disk->queue)
 		blk_put_queue(disk->queue);
@@ -1493,7 +1361,6 @@ dev_t blk_lookup_devt(const char *name, int partno)
 struct gendisk *__alloc_disk_node(int minors, int node_id)
 {
 	struct gendisk *disk;
-	struct disk_part_tbl *ptbl;
 
 	if (minors > DISK_MAX_PARTS) {
 		printk(KERN_ERR
@@ -1511,11 +1378,9 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
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
@@ -1524,7 +1389,8 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 	device_initialize(disk_to_dev(disk));
 	return disk;
 
-out_bdput:
+out_destroy_part_tbl:
+	xa_destroy(&disk->part_tbl);
 	bdput(disk->part0);
 out_free_disk:
 	kfree(disk);
diff --git a/block/partitions/core.c b/block/partitions/core.c
index deca253583bd3f..c88f03ddaefe29 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -286,13 +286,7 @@ struct device_type part_type = {
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
 
@@ -324,7 +318,6 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 	struct device *ddev = disk_to_dev(disk);
 	struct device *pdev;
 	struct block_device *bdev;
-	struct disk_part_tbl *ptbl;
 	const char *dname;
 	int err;
 
@@ -346,12 +339,7 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
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
index 425956ac9315fa..e8821bfe07b955 100644
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
@@ -224,7 +213,7 @@ void disk_uevent(struct gendisk *disk, enum kobject_action action);
 struct disk_part_iter {
 	struct gendisk		*disk;
 	struct block_device	*part;
-	int			idx;
+	unsigned long		idx;
 	unsigned int		flags;
 };
 
@@ -232,7 +221,6 @@ extern void disk_part_iter_init(struct disk_part_iter *piter,
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

