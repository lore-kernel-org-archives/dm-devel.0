Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E9C0C19F2A
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jul 2022 06:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659075132;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JjqYSaeGss9VyMxWOCD8EP6TKLQu8YIFZVF3+JfuSvY=;
	b=cccF2ElI7HMFnLUUFOjBkJHRY6iixAa/3zl/NvsYtOU1+7aES8fkXJHjcBnkwiemkcYPJU
	TNfF90bybZPyqgyL/dbzxNzIdmKIiVOqmZg38evQvDxfAUC5YXcR6Fdg8ENzniIyrdsW0a
	X8wMUzPaFY7N1Sgy+5M999dD50+y0EY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-uvczfTtxMFKwH03NKkjQxQ-1; Fri, 29 Jul 2022 02:12:08 -0400
X-MC-Unique: uvczfTtxMFKwH03NKkjQxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2C9B3802BB4;
	Fri, 29 Jul 2022 06:12:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AC46403D0D9;
	Fri, 29 Jul 2022 06:12:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3259E193211F;
	Fri, 29 Jul 2022 06:12:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B18A1932118
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Jul 2022 06:12:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 10B89492CA2; Fri, 29 Jul 2022 06:12:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C99F492C3B
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 06:12:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E907F811E75
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 06:12:02 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-JMcEw-cgOqeGoqtK1OVjkQ-1; Fri, 29 Jul 2022 02:12:00 -0400
X-MC-Unique: JMcEw-cgOqeGoqtK1OVjkQ-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4LvHFR73l0zl0jb;
 Fri, 29 Jul 2022 14:10:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP3 (Coremail) with SMTP id _Ch0CgCnCWkneuNiP6ZGBQ--.22656S6;
 Fri, 29 Jul 2022 14:11:54 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: stable@vger.kernel.org, hch@lst.de, axboe@kernel.dk, snitzer@redhat.com
Date: Fri, 29 Jul 2022 14:23:55 +0800
Message-Id: <20220729062356.1663513-3-yukuai1@huaweicloud.com>
In-Reply-To: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: _Ch0CgCnCWkneuNiP6ZGBQ--.22656S6
X-Coremail-Antispam: 1UD129KBjvJXoW3GF4fJr1xtr1UZrW8XF4fZrb_yoWxZF4fpF
 Z8KFZ5trW8JF47uFsFqa1UXFWYga18J3WxAry3KryIqrZxJrsYyF1fGry7XF93trZ2gFW7
 JF45JrW29F10kaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9m14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
 x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
 Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
 A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
 0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
 IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
 Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCFx2
 IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
 6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
 AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
 s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
 0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUc6pPUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH stable 5.10 2/3] block: support delayed holder
 registration
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
Cc: linux-block@vger.kernel.org, yukuai3@huawei.com, dm-devel@redhat.com,
 yi.zhang@huawei.com, yukuai1@huaweicloud.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

commit d626338735909bc2b2e7cafc332f44ed41cfdeee upstream.

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
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/genhd.c         | 10 ++++++
 fs/block_dev.c        | 74 +++++++++++++++++++++++++++++++++----------
 include/linux/genhd.h |  5 +++
 3 files changed, 72 insertions(+), 17 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 2b11a2735285..da4642182702 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -732,6 +732,16 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
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
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index a202c76fcf7f..8dc894c0f5f3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1210,6 +1210,19 @@ static void del_symlink(struct kobject *from, struct kobject *to)
 	sysfs_remove_link(from, kobject_name(to));
 }
 
+static int __link_disk_holder(struct block_device *bdev, struct gendisk *disk)
+{
+	int ret;
+
+	ret = add_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
+	if (ret)
+		return ret;
+	ret = add_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
+	if (ret)
+		del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
+	return ret;
+}
+
 /**
  * bd_link_disk_holder - create symlinks between holding disk and slave bdev
  * @bdev: the claimed slave bdev
@@ -1252,7 +1265,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	WARN_ON_ONCE(!bdev->bd_holder);
 
 	/* FIXME: remove the following once add_disk() handles errors */
-	if (WARN_ON(!disk->slave_dir || !bdev->bd_part->holder_dir))
+	if (WARN_ON(!bdev->bd_part->holder_dir))
 		goto out_unlock;
 
 	holder = bd_find_holder_disk(bdev, disk);
@@ -1271,13 +1284,13 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	holder->bdev = bdev;
 	holder->refcnt = 1;
 
-	ret = add_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
-	if (ret)
-		goto out_free;
-
-	ret = add_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
-	if (ret)
-		goto out_del;
+	if (disk->slave_dir) {
+		ret = __link_disk_holder(bdev, disk);
+		if (ret) {
+			kfree(holder);
+			goto out_unlock;
+		}
+	}
 	/*
 	 * bdev could be deleted beneath us which would implicitly destroy
 	 * the holder directory.  Hold on to it.
@@ -1285,12 +1298,6 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	kobject_get(bdev->bd_part->holder_dir);
 
 	list_add(&holder->list, &disk->slave_bdevs);
-	goto out_unlock;
-
-out_del:
-	del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
-out_free:
-	kfree(holder);
 out_unlock:
 	mutex_unlock(&bdev_holder->bd_mutex);
 	bdput(bdev_holder);
@@ -1298,6 +1305,13 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 }
 EXPORT_SYMBOL_GPL(bd_link_disk_holder);
 
+static void __unlink_disk_holder(struct block_device *bdev,
+		struct gendisk *disk)
+{
+	del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
+	del_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
+}
+
 /**
  * bd_unlink_disk_holder - destroy symlinks created by bd_link_disk_holder()
  * @bdev: the calimed slave bdev
@@ -1321,9 +1335,8 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	holder = bd_find_holder_disk(bdev, disk);
 
 	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
-		del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
-		del_symlink(bdev->bd_part->holder_dir,
-			    &disk_to_dev(disk)->kobj);
+		if (disk->slave_dir)
+			__unlink_disk_holder(bdev, disk);
 		kobject_put(bdev->bd_part->holder_dir);
 		list_del_init(&holder->list);
 		kfree(holder);
@@ -1335,6 +1348,33 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
 
+int bd_register_pending_holders(struct gendisk *disk)
+{
+	struct bd_holder_disk *holder;
+	struct block_device *bdev = bdget_disk(disk, 0);
+	int ret;
+
+	if (WARN_ON_ONCE(!bdev))
+		return -ENOENT;
+
+	mutex_lock(&bdev->bd_mutex);
+	list_for_each_entry(holder, &disk->slave_bdevs, list) {
+		ret = __link_disk_holder(holder->bdev, disk);
+		if (ret)
+			goto out_undo;
+	}
+	mutex_unlock(&bdev->bd_mutex);
+	bdput(bdev);
+	return 0;
+
+out_undo:
+	list_for_each_entry_continue_reverse(holder, &disk->slave_bdevs, list)
+		__unlink_disk_holder(holder->bdev, disk);
+	mutex_unlock(&bdev->bd_mutex);
+	bdput(bdev);
+	return ret;
+}
+
 /**
  * check_disk_size_change - checks for disk size change and adjusts bdev size.
  * @disk: struct gendisk to check
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 3e5049a527e6..3249f4b46700 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -385,6 +385,7 @@ long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
 #ifdef CONFIG_SYSFS
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
 void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk);
+int bd_register_pending_holders(struct gendisk *disk);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
 				      struct gendisk *disk)
@@ -395,6 +396,10 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev,
 					 struct gendisk *disk)
 {
 }
+static inline int bd_register_pending_holders(struct gendisk *disk)
+{
+	return 0;
+}
 #endif /* CONFIG_SYSFS */
 
 #ifdef CONFIG_BLOCK
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

