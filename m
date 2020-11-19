Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAC4C64E7A
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:49:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F1CD222227
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:49:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1CD222227
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-oSNldpo_MDCGi7oCVDPcwA-1; Thu, 19 Nov 2020 11:49:49 -0500
X-MC-Unique: oSNldpo_MDCGi7oCVDPcwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35373A0CA8;
	Thu, 19 Nov 2020 16:49:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 769925D6A8;
	Thu, 19 Nov 2020 16:49:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 27FFD4A7C6;
	Thu, 19 Nov 2020 16:49:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJGnfI1004034 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 11:49:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 26A6B10F2700; Thu, 19 Nov 2020 16:49:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2303E10F26FF
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 16:49:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAE81103B800
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 16:49:38 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-416-g_MeGXTTOZ2-0WtzEjs-vQ-1;
	Thu, 19 Nov 2020 11:49:32 -0500
X-MC-Unique: g_MeGXTTOZ2-0WtzEjs-vQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 4B9CEAC2D;
	Thu, 19 Nov 2020 16:49:31 +0000 (UTC)
From: Hannes Reinecke <hare@suse.de>
To: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 19 Nov 2020 17:49:24 +0100
Message-Id: <20201119164924.74401-3-hare@suse.de>
In-Reply-To: <20201119164924.74401-1-hare@suse.de>
References: <20201119164924.74401-1-hare@suse.de>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>, Sergei Shtepa <sergei.shtepa@veeam.com>
Subject: [dm-devel] [PATCH 2/2] dm_interposer - blk_interposer for
	device-mapper
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Sergei Shtepa <sergei.shtepa@veeam.com>

Implement a block interposer for device-mapper to
attach to an existing block layer stack.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-table.c |  59 +++++++++++++++++++++
 drivers/md/dm.c       | 140 ++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/md/dm.h       |   4 +-
 3 files changed, 191 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ce543b761be7..56923d0795b2 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1809,6 +1809,65 @@ static bool dm_table_requires_stable_pages(struct dm_table *t)
 	return false;
 }
 
+static char *_dm_interposer_claim_ptr = "device-mapper interposer";
+
+static int device_activate_interposer(struct dm_target *ti,
+				      struct dm_dev *dev, sector_t start,
+				      sector_t len, void *data)
+{
+	struct blk_interposer *blk_ip = dev->bdev->bd_disk->interposer;
+	struct mapped_device *md = data;
+
+	if (!blk_ip)
+		return false;
+	if (md) {
+		struct block_device *bdev;
+
+		bdev = blkdev_get_by_dev(md->bdev->bd_dev,
+					     dev->mode | FMODE_EXCL,
+					     _dm_interposer_claim_ptr);
+		if (!bdev)
+			return false;
+		blk_ip->ip_private = md;
+	} else if (blk_ip->ip_private) {
+		md = blk_ip->ip_private;
+		blkdev_put(md->bdev, dev->mode | FMODE_EXCL);
+		blk_ip->ip_private = NULL;
+	}
+	return true;
+}
+
+bool dm_table_activate_interposer(struct dm_table *t, struct mapped_device *md)
+{
+	struct dm_target *ti;
+
+	if (t->num_targets) {
+		ti = t->targets;
+
+		if (!ti->type->iterate_devices ||
+		    !ti->type->iterate_devices(ti,
+				device_activate_interposer, md))
+			return false;
+		DMINFO("%s: activated interposer", dm_device_name(md));
+	}
+	return true;
+}
+
+bool dm_table_deactivate_interposer(struct dm_table *t)
+{
+	struct dm_target *ti;
+
+	if (t->num_targets) {
+		ti = t->targets;
+
+		if (!ti->type->iterate_devices ||
+		    !ti->type->iterate_devices(ti,
+				device_activate_interposer, NULL))
+			return false;
+	}
+	return true;
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c18fc2548518..ec6df4ad4c85 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -48,6 +48,7 @@ static DEFINE_IDR(_minor_idr);
 static DEFINE_SPINLOCK(_minor_lock);
 
 static void do_deferred_remove(struct work_struct *w);
+static blk_qc_t dm_submit_bio_interposed(struct blk_interposer *ip, struct bio *bio);
 
 static DECLARE_WORK(deferred_remove_work, do_deferred_remove);
 
@@ -730,6 +731,38 @@ static void dm_put_live_table_fast(struct mapped_device *md) __releases(RCU)
 	rcu_read_unlock();
 }
 
+static inline int dm_install_interposer(struct gendisk *disk,
+					struct mapped_device *md)
+{
+	struct blk_interposer *blk_ip;
+	int ret;
+
+	blk_ip = kzalloc(sizeof(struct blk_interposer), GFP_KERNEL);
+	if (!blk_ip)
+		return -ENOMEM;
+
+	blk_ip->ip_submit_bio = dm_submit_bio_interposed;
+	blk_ip->ip_disk = disk;
+	blk_ip->ip_private = md;
+
+	ret = blk_interposer_attach(disk, blk_ip);
+	if (ret) {
+		kfree(blk_ip);
+		return ret;
+	}
+
+	return 0;
+}
+
+static inline void dm_uninstall_interposer(struct gendisk *disk)
+{
+	struct blk_interposer *blk_ip;
+
+	blk_ip = blk_interposer_detach(disk);
+	if (blk_ip)
+		kfree(blk_ip);
+}
+
 static char *_dm_claim_ptr = "I belong to device-mapper";
 
 /*
@@ -739,19 +772,38 @@ static int open_table_device(struct table_device *td, dev_t dev,
 			     struct mapped_device *md)
 {
 	struct block_device *bdev;
-
-	int r;
+	fmode_t fmode = td->dm_dev.mode | FMODE_EXCL;
+	int ret;
 
 	BUG_ON(td->dm_dev.bdev);
 
-	bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
-	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
+	bdev = blkdev_get_by_dev(dev, fmode, _dm_claim_ptr);
+	if (IS_ERR(bdev)) {
+		ret = PTR_ERR(bdev);
+		if (ret != -EBUSY)
+			return ret;
 
-	r = bd_link_disk_holder(bdev, dm_disk(md));
-	if (r) {
-		blkdev_put(bdev, td->dm_dev.mode | FMODE_EXCL);
-		return r;
+		/*
+		 * If device cannot be opened in exclusive mode,
+		 * then try to use blk_interpose.
+		 */
+		fmode = td->dm_dev.mode;
+		bdev = blkdev_get_by_dev(dev, fmode, NULL);
+		if (IS_ERR(bdev))
+			return PTR_ERR(bdev);
+
+		ret = dm_install_interposer(bdev->bd_disk, md);
+		if (ret) {
+			blkdev_put(bdev, fmode);
+			return ret;
+		}
+	}
+
+	ret = bd_link_disk_holder(bdev, dm_disk(md));
+	if (ret) {
+		dm_uninstall_interposer(bdev->bd_disk);
+		blkdev_put(bdev, fmode);
+		return ret;
 	}
 
 	td->dm_dev.bdev = bdev;
@@ -764,11 +816,18 @@ static int open_table_device(struct table_device *td, dev_t dev,
  */
 static void close_table_device(struct table_device *td, struct mapped_device *md)
 {
+	fmode_t fmode = td->dm_dev.mode | FMODE_EXCL;
+
 	if (!td->dm_dev.bdev)
 		return;
 
 	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
-	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
+	if (blk_has_interposer(td->dm_dev.bdev->bd_disk)) {
+		dm_uninstall_interposer(td->dm_dev.bdev->bd_disk);
+		fmode = td->dm_dev.mode;
+	}
+	blkdev_put(td->dm_dev.bdev, fmode);
+
 	put_dax(td->dm_dev.dax_dev);
 	td->dm_dev.bdev = NULL;
 	td->dm_dev.dax_dev = NULL;
@@ -1666,6 +1725,62 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	return ret;
 }
 
+static void dm_interposed_endio(struct bio *clone)
+{
+	struct bio *bio = clone->bi_private;
+
+	bio->bi_status = clone->bi_status;
+	bio_endio(bio);
+	bio_put(bio);
+
+	bio_put(clone);
+}
+
+static blk_qc_t dm_submit_bio_interposed(struct blk_interposer *interposer,
+					 struct bio *bio)
+{
+	struct mapped_device *md = interposer->ip_private;
+	blk_qc_t ret = BLK_QC_T_NONE;
+	int srcu_idx;
+	struct dm_table *map;
+	struct bio *clone;
+
+	if (unlikely(!md))
+		return submit_bio_noacct(bio);
+
+	map = dm_get_live_table(md, &srcu_idx);
+	if (unlikely(!map)) {
+		DMERR_LIMIT("%s: mapping table unavailable, erroring io",
+			    dm_device_name(md));
+		goto out;
+	}
+
+	clone = bio_clone_fast(bio, GFP_NOIO, NULL);
+	if (unlikely(!clone)) {
+		DMERR_LIMIT("%s: failed to clone bio",
+			    dm_device_name(md));
+		goto out;
+	}
+
+	bio_get(bio);
+	bio_set_flag(clone, BIO_INTERPOSED);
+	clone->bi_private = bio;
+	clone->bi_disk = dm_disk(md);
+	clone->bi_end_io = dm_interposed_endio;
+
+	trace_block_bio_remap(clone->bi_disk->queue, bio, bio_dev(bio),
+			      bio->bi_iter.bi_sector);
+
+	ret = submit_bio_noacct(clone);
+	dm_put_live_table(md, srcu_idx);
+	return  ret;
+
+out:
+	bio_io_error(bio);
+	dm_put_live_table(md, srcu_idx);
+	return ret;
+}
+
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
@@ -2005,8 +2120,11 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);
 
 	dm_table_set_restrictions(t, q, limits);
-	if (old_map)
+	if (old_map) {
+		dm_table_deactivate_interposer(old_map);
 		dm_sync_table(md);
+	}
+	dm_table_activate_interposer(t, md);
 
 out:
 	return old_map;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index fffe1e289c53..51b98e10e9bb 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -75,7 +75,9 @@ bool dm_table_supports_dax(struct dm_table *t, iterate_devices_callout_fn fn,
 			   int *blocksize);
 int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
 			   sector_t start, sector_t len, void *data);
-
+bool dm_table_activate_interposer(struct dm_table *t,
+				  struct mapped_device *md);
+bool dm_table_deactivate_interposer(struct dm_table *t);
 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
 void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
-- 
2.16.4

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

