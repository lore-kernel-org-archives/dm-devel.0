Return-Path: <SRS0=Go1D=MR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F9AC432BE
	for <dm-devel@archiver.kernel.org>; Sun, 25 Jul 2021 05:57:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB64B60F13
	for <dm-devel@archiver.kernel.org>; Sun, 25 Jul 2021 05:57:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BB64B60F13
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-L3pOKo8KMROhbmutSJH8DA-1; Sun, 25 Jul 2021 01:57:08 -0400
X-MC-Unique: L3pOKo8KMROhbmutSJH8DA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACB0F190A7A1;
	Sun, 25 Jul 2021 05:57:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 399935D6BA;
	Sun, 25 Jul 2021 05:57:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8EA9C180BAB2;
	Sun, 25 Jul 2021 05:56:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16P5utVL010432 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 25 Jul 2021 01:56:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6FDB02166BA3; Sun, 25 Jul 2021 05:56:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B5AE2166B49
	for <dm-devel@redhat.com>; Sun, 25 Jul 2021 05:56:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0DFC802A64
	for <dm-devel@redhat.com>; Sun, 25 Jul 2021 05:56:51 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-378-pY2h1yf7NIeoXGlJh8Ks8w-1; Sun, 25 Jul 2021 01:56:49 -0400
X-MC-Unique: pY2h1yf7NIeoXGlJh8Ks8w-1
Received: from [2001:4bb8:184:87c5:a8b3:bdfd:fc9b:6250] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m7X7b-00CpjX-QE; Sun, 25 Jul 2021 05:56:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Sun, 25 Jul 2021 07:54:54 +0200
Message-Id: <20210725055458.29008-5-hch@lst.de>
In-Reply-To: <20210725055458.29008-1-hch@lst.de>
References: <20210725055458.29008-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

device mapper needs to register holders before it is ready to do I/O.
Currently it does so by registering the disk early, which has all kinds
of bad side effects.  Support registering holders on an initialized but
not registered disk instead by delaying the sysfs registration until the
disk is registered.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c         | 10 +++++++
 block/holder.c        | 68 ++++++++++++++++++++++++++++++++-----------
 include/linux/genhd.h |  5 ++++
 3 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e2708a4a7a47..e3d93b868ec5 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -429,6 +429,16 @@ static void register_disk(struct device *parent, struct gendisk *disk,
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
index 26c8557e2714..dd95d53c75fa 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -321,6 +321,7 @@ long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
 #ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
 void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk);
+int bd_register_pending_holders(struct gendisk *disk);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
 				      struct gendisk *disk)
@@ -331,6 +332,10 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev,
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

