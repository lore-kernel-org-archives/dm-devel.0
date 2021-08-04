Return-Path: <SRS0=Qr9I=M3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B6FC4338F
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 09:45:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 44B9E60F58
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 09:45:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 44B9E60F58
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-fS14o9MENlax49nbabu55Q-1; Wed, 04 Aug 2021 05:45:30 -0400
X-MC-Unique: fS14o9MENlax49nbabu55Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7F7F87D543;
	Wed,  4 Aug 2021 09:45:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9513719C44;
	Wed,  4 Aug 2021 09:45:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6CF0A4BB7C;
	Wed,  4 Aug 2021 09:45:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1749jO5C006179 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Aug 2021 05:45:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6BE98207AC4E; Wed,  4 Aug 2021 09:45:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6781C207AC4F
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 09:45:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B73FF866DF4
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 09:45:20 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-4-phvjN-3hOvmDbVNy_BnchA-1; Wed, 04 Aug 2021 05:45:18 -0400
X-MC-Unique: phvjN-3hOvmDbVNy_BnchA-1
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mBDRt-005e5C-5v; Wed, 04 Aug 2021 09:44:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Wed,  4 Aug 2021 11:41:43 +0200
Message-Id: <20210804094147.459763-5-hch@lst.de>
In-Reply-To: <20210804094147.459763-1-hch@lst.de>
References: <20210804094147.459763-1-hch@lst.de>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 4/8] block: support delayed holder registration
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

device mapper needs to register holders before it is ready to do I/O.
Currently it does so by registering the disk early, which can leave
the disk and queue in a weird half state where the queue is registered
with the disk, except for sysfs and the elevator.  And this state has
been a bit promlematic before, and will get more so when sorting out
the responsibilities between the queue and the disk.

Support registering holders on an initialized but not registered disk
instead by delaying the sysfs registration until the disk is registered.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 block/genhd.c         | 10 +++++++
 block/holder.c        | 68 ++++++++++++++++++++++++++++++++-----------
 include/linux/genhd.h |  5 ++++
 3 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index cd4eab744667..db916f779077 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -447,6 +447,16 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 		kobject_create_and_add("holders", &ddev->kobj);
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 
+	/*
+	 * XXX: this is a mess, can't wait for real error handling in add_disk.
+	 * Make sure ->slave_dir is NULL if we failed some of the registration
+	 * so that the cleanup in bd_unlink_disk_holder works properly.
+	 */
+	if (bd_register_pending_holders(disk) < 0) {
+		kobject_put(disk->slave_dir);
+		disk->slave_dir = NULL;
+	}
+
 	if (disk->flags & GENHD_FL_HIDDEN)
 		return;
 
diff --git a/block/holder.c b/block/holder.c
index 11e65d99a9fb..4568cc4f6827 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -28,6 +28,19 @@ static void del_symlink(struct kobject *from, struct kobject *to)
 	sysfs_remove_link(from, kobject_name(to));
 }
 
+static int __link_disk_holder(struct block_device *bdev, struct gendisk *disk)
+{
+	int ret;
+
+	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
+	if (ret)
+		return ret;
+	ret = add_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
+	if (ret)
+		del_symlink(disk->slave_dir, bdev_kobj(bdev));
+	return ret;
+}
+
 /**
  * bd_link_disk_holder - create symlinks between holding disk and slave bdev
  * @bdev: the claimed slave bdev
@@ -66,7 +79,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	WARN_ON_ONCE(!bdev->bd_holder);
 
 	/* FIXME: remove the following once add_disk() handles errors */
-	if (WARN_ON(!disk->slave_dir || !bdev->bd_holder_dir))
+	if (WARN_ON(!bdev->bd_holder_dir))
 		goto out_unlock;
 
 	holder = bd_find_holder_disk(bdev, disk);
@@ -84,28 +97,28 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	INIT_LIST_HEAD(&holder->list);
 	holder->bdev = bdev;
 	holder->refcnt = 1;
-
-	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
-	if (ret)
-		goto out_free;
-
-	ret = add_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
-	if (ret)
-		goto out_del;
+	if (disk->slave_dir) {
+		ret = __link_disk_holder(bdev, disk);
+		if (ret) {
+			kfree(holder);
+			goto out_unlock;
+		}
+	}
 
 	list_add(&holder->list, &disk->slave_bdevs);
-	goto out_unlock;
-
-out_del:
-	del_symlink(disk->slave_dir, bdev_kobj(bdev));
-out_free:
-	kfree(holder);
 out_unlock:
 	mutex_unlock(&disk->open_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(bd_link_disk_holder);
 
+static void __unlink_disk_holder(struct block_device *bdev,
+		struct gendisk *disk)
+{
+	del_symlink(disk->slave_dir, bdev_kobj(bdev));
+	del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
+}
+
 /**
  * bd_unlink_disk_holder - destroy symlinks created by bd_link_disk_holder()
  * @bdev: the calimed slave bdev
@@ -123,11 +136,32 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	mutex_lock(&disk->open_mutex);
 	holder = bd_find_holder_disk(bdev, disk);
 	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
-		del_symlink(disk->slave_dir, bdev_kobj(bdev));
-		del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
+		if (disk->slave_dir)
+			__unlink_disk_holder(bdev, disk);
 		list_del_init(&holder->list);
 		kfree(holder);
 	}
 	mutex_unlock(&disk->open_mutex);
 }
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
+
+int bd_register_pending_holders(struct gendisk *disk)
+{
+	struct bd_holder_disk *holder;
+	int ret;
+
+	mutex_lock(&disk->open_mutex);
+	list_for_each_entry(holder, &disk->slave_bdevs, list) {
+		ret = __link_disk_holder(holder->bdev, disk);
+		if (ret)
+			goto out_undo;
+	}
+	mutex_unlock(&disk->open_mutex);
+	return 0;
+
+out_undo:
+	list_for_each_entry_continue_reverse(holder, &disk->slave_bdevs, list)
+		__unlink_disk_holder(holder->bdev, disk);
+	mutex_unlock(&disk->open_mutex);
+	return ret;
+}
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 0721807d76ee..80952f038d79 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -323,6 +323,7 @@ long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
 #ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
 void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk);
+int bd_register_pending_holders(struct gendisk *disk);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
 				      struct gendisk *disk)
@@ -333,6 +334,10 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev,
 					 struct gendisk *disk)
 {
 }
+static inline int bd_register_pending_holders(struct gendisk *disk)
+{
+	return 0;
+}
 #endif /* CONFIG_BLOCK_HOLDER_DEPRECATED */
 
 dev_t part_devt(struct gendisk *disk, u8 partno);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

