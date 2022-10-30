Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DABE0ECAAA1
	for <dm-devel@archiver.kernel.org>; Sun, 30 Oct 2022 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667146030;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=klBFEUtkZvqwh4zcC+GYTh6pxQIMgC2YlROIvmHGX4M=;
	b=GFWpbH5HGd9anm0v4joDEdi5Yau9EtAc+eilIuo7kid55vayP9rYOmUJYD4Lw4KuVao6PJ
	iI9CxHa40MLf4VLllLzfsPnyiLKTZk3E+ce7y5gdU819loiajEwwJHPPBXAzdBDoBkMw2O
	DHOGWUN5Z/DhBE/dpDguyFg9cR2Y3JE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-cNhBJXdYNYSDthKjxpUB8w-1; Sun, 30 Oct 2022 12:07:06 -0400
X-MC-Unique: cNhBJXdYNYSDthKjxpUB8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACAE0800B30;
	Sun, 30 Oct 2022 16:07:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 568C0111E3FF;
	Sun, 30 Oct 2022 16:07:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1EA0B194658C;
	Sun, 30 Oct 2022 16:07:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7A5951946589
 for <dm-devel@listman.corp.redhat.com>; Sun, 30 Oct 2022 16:07:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2BDEB2166B2F; Sun, 30 Oct 2022 16:07:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 24BC82166B29
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 16:07:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFFC1101A528
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 16:07:01 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-436-0bsjzwtOO4aN92FFKh9jnA-1; Sun, 30 Oct 2022 12:06:59 -0400
X-MC-Unique: 0bsjzwtOO4aN92FFKh9jnA-1
Received: from 213-225-37-80.nat.highway.a1.net ([213.225.37.80]
 helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1opAHw-00HW0v-8r; Sun, 30 Oct 2022 15:31:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Date: Sun, 30 Oct 2022 16:31:18 +0100
Message-Id: <20221030153120.1045101-7-hch@lst.de>
In-Reply-To: <20221030153120.1045101-1-hch@lst.de>
References: <20221030153120.1045101-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 6/7] block: remove delayed holder registration
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-block@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now that dm has been fixed to track of holder registrations before
add_disk, the somewhat buggy block layer code can be safely removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c          |  4 ---
 block/holder.c         | 72 ++++++++++++------------------------------
 include/linux/blkdev.h |  5 ---
 3 files changed, 21 insertions(+), 60 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index aa0e2f5684543..97d2243f07827 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -478,10 +478,6 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 		goto out_put_holder_dir;
 	}
 
-	ret = bd_register_pending_holders(disk);
-	if (ret < 0)
-		goto out_put_slave_dir;
-
 	ret = blk_register_queue(disk);
 	if (ret)
 		goto out_put_slave_dir;
diff --git a/block/holder.c b/block/holder.c
index 5283bc804cc14..dd9327b43ce05 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -29,19 +29,6 @@ static void del_symlink(struct kobject *from, struct kobject *to)
 	sysfs_remove_link(from, kobject_name(to));
 }
 
-static int __link_disk_holder(struct block_device *bdev, struct gendisk *disk)
-{
-	int ret;
-
-	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
-	if (ret)
-		return ret;
-	ret = add_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
-	if (ret)
-		del_symlink(disk->slave_dir, bdev_kobj(bdev));
-	return ret;
-}
-
 /**
  * bd_link_disk_holder - create symlinks between holding disk and slave bdev
  * @bdev: the claimed slave bdev
@@ -75,6 +62,9 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	struct bd_holder_disk *holder;
 	int ret = 0;
 
+	if (WARN_ON_ONCE(!disk->slave_dir))
+		return -EINVAL;
+
 	mutex_lock(&disk->open_mutex);
 
 	WARN_ON_ONCE(!bdev->bd_holder);
@@ -94,34 +84,32 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	INIT_LIST_HEAD(&holder->list);
 	holder->bdev = bdev;
 	holder->refcnt = 1;
-	if (disk->slave_dir) {
-		ret = __link_disk_holder(bdev, disk);
-		if (ret) {
-			kfree(holder);
-			goto out_unlock;
-		}
-	}
-
+	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
+	if (ret)
+		goto out_free_holder;
+	ret = add_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
+	if (ret)
+		goto out_del_symlink;
 	list_add(&holder->list, &disk->slave_bdevs);
+
 	/*
 	 * del_gendisk drops the initial reference to bd_holder_dir, so we need
 	 * to keep our own here to allow for cleanup past that point.
 	 */
 	kobject_get(bdev->bd_holder_dir);
+	mutex_unlock(&disk->open_mutex);
+	return 0;
 
+out_del_symlink:
+	del_symlink(disk->slave_dir, bdev_kobj(bdev));
+out_free_holder:
+	kfree(holder);
 out_unlock:
 	mutex_unlock(&disk->open_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(bd_link_disk_holder);
 
-static void __unlink_disk_holder(struct block_device *bdev,
-		struct gendisk *disk)
-{
-	del_symlink(disk->slave_dir, bdev_kobj(bdev));
-	del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
-}
-
 /**
  * bd_unlink_disk_holder - destroy symlinks created by bd_link_disk_holder()
  * @bdev: the calimed slave bdev
@@ -136,11 +124,14 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 {
 	struct bd_holder_disk *holder;
 
+	if (WARN_ON_ONCE(!disk->slave_dir))
+		return;
+
 	mutex_lock(&disk->open_mutex);
 	holder = bd_find_holder_disk(bdev, disk);
 	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
-		if (disk->slave_dir)
-			__unlink_disk_holder(bdev, disk);
+		del_symlink(disk->slave_dir, bdev_kobj(bdev));
+		del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
 		kobject_put(bdev->bd_holder_dir);
 		list_del_init(&holder->list);
 		kfree(holder);
@@ -148,24 +139,3 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	mutex_unlock(&disk->open_mutex);
 }
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
-
-int bd_register_pending_holders(struct gendisk *disk)
-{
-	struct bd_holder_disk *holder;
-	int ret;
-
-	mutex_lock(&disk->open_mutex);
-	list_for_each_entry(holder, &disk->slave_bdevs, list) {
-		ret = __link_disk_holder(holder->bdev, disk);
-		if (ret)
-			goto out_undo;
-	}
-	mutex_unlock(&disk->open_mutex);
-	return 0;
-
-out_undo:
-	list_for_each_entry_continue_reverse(holder, &disk->slave_bdevs, list)
-		__unlink_disk_holder(holder->bdev, disk);
-	mutex_unlock(&disk->open_mutex);
-	return ret;
-}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 57ed49f20d2eb..df45037815527 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -839,7 +839,6 @@ void set_capacity(struct gendisk *disk, sector_t size);
 #ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
 void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk);
-int bd_register_pending_holders(struct gendisk *disk);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
 				      struct gendisk *disk)
@@ -850,10 +849,6 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev,
 					 struct gendisk *disk)
 {
 }
-static inline int bd_register_pending_holders(struct gendisk *disk)
-{
-	return 0;
-}
 #endif /* CONFIG_BLOCK_HOLDER_DEPRECATED */
 
 dev_t part_devt(struct gendisk *disk, u8 partno);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

