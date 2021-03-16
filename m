Return-Path: <SRS0=mox9=IO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DB2C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 15:25:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DDED2650E1
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 15:25:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDED2650E1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-7EsXHHSQP_uETCnkkfM5tA-1; Tue, 16 Mar 2021 11:25:47 -0400
X-MC-Unique: 7EsXHHSQP_uETCnkkfM5tA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC90780006E;
	Tue, 16 Mar 2021 15:25:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E70019D61;
	Tue, 16 Mar 2021 15:25:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CBFBB1800657;
	Tue, 16 Mar 2021 15:25:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12GFPD9H027817 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Mar 2021 11:25:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 85D171008B77; Tue, 16 Mar 2021 15:25:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79BAD1008E9E
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 15:25:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0150E800140
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 15:25:11 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-181-qGuuWPUKPNm8AAU2JHbMKA-1; Tue, 16 Mar 2021 11:25:07 -0400
X-MC-Unique: qGuuWPUKPNm8AAU2JHbMKA-1
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1lMBZ6-000EY4-Kn; Tue, 16 Mar 2021 15:25:00 +0000
Date: Tue, 16 Mar 2021 15:25:00 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Sergei Shtepa <sergei.shtepa@veeam.com>
Message-ID: <20210316152500.GA55711@infradead.org>
References: <1615563895-28565-1-git-send-email-sergei.shtepa@veeam.com>
	<1615563895-28565-4-git-send-email-sergei.shtepa@veeam.com>
	<20210314093038.GC3773360@infradead.org>
	<20210315132509.GD30489@veeam.com>
	<20210316152314.GA55391@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20210316152314.GA55391@infradead.org>
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
Cc: Jens Axboe <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mike Snitzer <snitzer@redhat.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v7 3/3] dm: add DM_INTERPOSED_FLAG
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 16, 2021 at 03:23:14PM +0000, Christoph Hellwig wrote:
> On Mon, Mar 15, 2021 at 04:25:09PM +0300, Sergei Shtepa wrote:
> > The 03/14/2021 12:30, Christoph Hellwig wrote:
> > > On Fri, Mar 12, 2021 at 06:44:55PM +0300, Sergei Shtepa wrote:
> > > > DM_INTERPOSED_FLAG allow to create DM targets on "the fly".
> > > > Underlying block device opens without a flag FMODE_EXCL.
> > > > DM target receives bio from the original device via
> > > > bdev_interposer.
> > > 
> > > This is more of a philopical comment, but the idea of just letting the
> > > interposed reopen the device by itself seems like a bad idea.  I think
> > > that is probably better hidden in the block layer interposer attachment
> > > function, which could do the extra blkdev_get_by_dev for the caller.
> > 
> > I suppose this cannot be implemented, since we need to change the behavior
> > for block devices that already have been opened.
> 
> That's not what I mean.  Take a look at the patch relative to your
> series to let me know what you think.  The new blkdev_interposer_attach
> now takes a dev_t + mode for the original device and opens it on
> behalf of the interposer.  It also moves the queue freezing into the
> API, which should address the concerns about the helper and adds a few
> more sanity checks.

And now actually with the diff:


diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2f188a865024ac..d4d7c1caa43966 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -161,19 +161,6 @@ int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait_timeout);
 
-bool blk_mq_is_queue_frozen(struct request_queue *q)
-{
-	bool frozen;
-
-	mutex_lock(&q->mq_freeze_lock);
-	frozen = percpu_ref_is_dying(&q->q_usage_counter) &&
-		 percpu_ref_is_zero(&q->q_usage_counter);
-	mutex_unlock(&q->mq_freeze_lock);
-
-	return frozen;
-}
-EXPORT_SYMBOL_GPL(blk_mq_is_queue_frozen);
-
 /*
  * Guarantee no request is in use, so we can change any data structure of
  * the queue afterward.
diff --git a/block/genhd.c b/block/genhd.c
index fa406b972371ae..64d6338b08cc87 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1944,51 +1944,70 @@ static void disk_release_events(struct gendisk *disk)
 	kfree(disk->ev);
 }
 
-int bdev_interposer_attach(struct block_device *original,
+struct block_device *blkdev_interposer_attach(dev_t dev, fmode_t mode,
 			   struct block_device *interposer)
 {
+	struct block_device *bdev;
 	int ret = 0;
 
-	if (WARN_ON(((!original) || (!interposer))))
-		return -EINVAL;
-	/*
-	 * interposer should be simple, no a multi-queue device
-	 */
-	if (!interposer->bd_disk->fops->submit_bio)
-		return -EINVAL;
+	if (WARN_ON_ONCE(!bdev_is_partition(interposer)))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(!queue_is_mq(interposer->bd_disk->queue)))
+		return ERR_PTR(-EINVAL);
 
-	if (WARN_ON(!blk_mq_is_queue_frozen(original->bd_disk->queue)))
-		return -EPERM;
+	bdev = blkdev_get_by_dev(dev, mode, NULL);
+	if (IS_ERR(bdev))
+		return bdev;
 
-	mutex_lock(&bdev_interposer_attach_lock);
+	ret = -EINVAL;
+	if (WARN_ON_ONCE(bdev_nr_sectors(bdev) != bdev_nr_sectors(interposer)))
+		goto out;
 
-	if (bdev_has_interposer(original))
-		ret = -EBUSY;
-	else {
-		original->bd_interposer = bdgrab(interposer);
-		if (!original->bd_interposer)
-			ret = -ENODEV;
-	}
+	blk_mq_freeze_queue(bdev->bd_disk->queue);
+	blk_mq_quiesce_queue(bdev->bd_disk->queue);
 
+	mutex_lock(&bdev_interposer_attach_lock);
+	ret = -EBUSY;
+	if (bdev_has_interposer(bdev))
+		goto out_unlock;
+	ret = -ENODEV;
+	bdev->bd_interposer = bdgrab(interposer);
+	if (!bdev->bd_interposer)
+		goto out_unlock;
+	ret = 0;
+out_unlock:
 	mutex_unlock(&bdev_interposer_attach_lock);
 
-	return ret;
+	blk_mq_unquiesce_queue(bdev->bd_disk->queue);
+	blk_mq_unfreeze_queue(bdev->bd_disk->queue);
+out:
+	if (ret) {
+		blkdev_put(bdev, mode);
+		bdev = ERR_PTR(ret);
+	}
+
+	return bdev;
 }
-EXPORT_SYMBOL_GPL(bdev_interposer_attach);
+EXPORT_SYMBOL_GPL(blkdev_interposer_attach);
 
-void bdev_interposer_detach(struct block_device *original)
+void blkdev_interposer_detach(struct block_device *bdev, fmode_t mode)
 {
-	if (WARN_ON(!original))
-		return;
+	struct block_device *interposer;
 
-	if (WARN_ON(!blk_mq_is_queue_frozen(original->bd_disk->queue)))
+	if (WARN_ON_ONCE(!bdev_has_interposer(bdev)))
 		return;
 
+	blk_mq_freeze_queue(bdev->bd_disk->queue);
+	blk_mq_quiesce_queue(bdev->bd_disk->queue);
+
 	mutex_lock(&bdev_interposer_attach_lock);
-	if (bdev_has_interposer(original)) {
-		bdput(original->bd_interposer);
-		original->bd_interposer = NULL;
-	}
+	interposer = bdev->bd_interposer;
+	bdev->bd_interposer = NULL;
 	mutex_unlock(&bdev_interposer_attach_lock);
+
+	blk_mq_unquiesce_queue(bdev->bd_disk->queue);
+	blk_mq_unfreeze_queue(bdev->bd_disk->queue);
+
+	blkdev_put(interposer, mode);
 }
-EXPORT_SYMBOL_GPL(bdev_interposer_detach);
+EXPORT_SYMBOL_GPL(blkdev_interposer_detach);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f6e2eb3f894940..fde57bb5105025 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -359,18 +359,6 @@ dev_t dm_get_dev_t(const char *path)
 }
 EXPORT_SYMBOL_GPL(dm_get_dev_t);
 
-static inline void dm_disk_freeze(struct gendisk *disk)
-{
-	blk_mq_freeze_queue(disk->queue);
-	blk_mq_quiesce_queue(disk->queue);
-}
-
-static inline void dm_disk_unfreeze(struct gendisk *disk)
-{
-	blk_mq_unquiesce_queue(disk->queue);
-	blk_mq_unfreeze_queue(disk->queue);
-}
-
 /*
  * Add a device to the list, or just increment the usage count if
  * it's already present.
@@ -418,29 +406,11 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		refcount_inc(&dd->count);
 	}
 
-	if (t->md->is_interposed) {
-		struct block_device *original = dd->dm_dev->bdev;
-		struct block_device *interposer = t->md->disk->part0;
-
-		if ((ti->begin != 0) || (ti->len < bdev_nr_sectors(original))) {
-			dm_put_device(ti, dd->dm_dev);
-			DMERR("The interposer device should not be less than the original.");
-			return -EINVAL;
-		}
-
-		/*
-		 * Attach mapped interposer device to original.
-		 * It is quite convenient that device mapper creates
-		 * one disk for one block device.
-		 */
-		dm_disk_freeze(original->bd_disk);
-		r = bdev_interposer_attach(original, interposer);
-		dm_disk_unfreeze(original->bd_disk);
-		if (r) {
-			dm_put_device(ti, dd->dm_dev);
-			DMERR("Failed to attach dm interposer.");
-			return r;
-		}
+	if (t->md->is_interposed &&
+	    (ti->begin != 0 || ti->len < bdev_nr_sectors(dd->dm_dev->bdev))) {
+		dm_put_device(ti, dd->dm_dev);
+		DMERR("The interposer device should not be less than the original.");
+		return -EINVAL;
 	}
 
 	*result = dd->dm_dev;
@@ -496,11 +466,6 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 		       dm_device_name(md), d->name);
 		return;
 	}
-	if (md->is_interposed) {
-		dm_disk_freeze(d->bdev->bd_disk);
-		bdev_interposer_detach(d->bdev);
-		dm_disk_unfreeze(d->bdev->bd_disk);
-	}
 
 	if (refcount_dec_and_test(&dd->count)) {
 		dm_put_table_device(md, d);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c488e9554aa000..532ce17064b1c1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -763,10 +763,12 @@ static int open_table_device(struct table_device *td, dev_t dev,
 	BUG_ON(td->dm_dev.bdev);
 
 	if (md->is_interposed) {
-
-		bdev = blkdev_get_by_dev(dev, td->dm_dev.mode, NULL);
-		if (IS_ERR(bdev))
+		bdev = blkdev_interposer_attach(dev, td->dm_dev.mode,
+						md->disk->part0);
+		if (IS_ERR(bdev)) {
+			DMERR("Failed to attach dm interposer.");
 			return PTR_ERR(bdev);
+		}
 	} else {
 		bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
 		if (IS_ERR(bdev))
@@ -793,9 +795,9 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
 	if (!td->dm_dev.bdev)
 		return;
 
-	if (td->dm_dev.is_interposed)
-		blkdev_put(td->dm_dev.bdev, td->dm_dev.mode);
-	else {
+	if (td->dm_dev.is_interposed) {
+		blkdev_interposer_detach(td->dm_dev.bdev, td->dm_dev.mode);
+	} else {
 		bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
 		blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
 	}
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 6f01971abf7b9b..2c473c9b899089 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -533,7 +533,6 @@ void blk_freeze_queue_start(struct request_queue *q);
 void blk_mq_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout);
-bool blk_mq_is_queue_frozen(struct request_queue *q);
 
 int blk_mq_map_queues(struct blk_mq_queue_map *qmap);
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 90f62b4197da91..fbc510162c3827 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -2036,8 +2036,8 @@ static inline bool bdev_has_interposer(struct block_device *bdev)
 	return (bdev->bd_interposer != NULL);
 };
 
-int bdev_interposer_attach(struct block_device *original,
+struct block_device *blkdev_interposer_attach(dev_t dev, fmode_t mode,
 			   struct block_device *interposer);
-void bdev_interposer_detach(struct block_device *original);
+void blkdev_interposer_detach(struct block_device *bdev, fmode_t mode);
 
 #endif /* _LINUX_BLKDEV_H */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

