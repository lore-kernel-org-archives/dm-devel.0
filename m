Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3492C43219
	for <dm-devel@archiver.kernel.org>; Tue, 15 Nov 2022 15:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668525361;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DQxP6aLXFgpk4/oLvjvDeO0mwJXKPsA8Ez14qKdbT24=;
	b=Z1xGVypDH/kj6H+XKVsJ1LqeAG8cjMq9Ofqobc74MM2eL9+gnqO7sre6D+ULU2w3rhoDKo
	UDHZkPs8MC7PgDnhdN6rrzMvW+o2X16fG3cRCyBfXIgtfAQ69cTMrTuFqT5g/ampEcMTBs
	U560jM9OAQjqgM27hoq2U8JuVYzqpHo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-aYP-XwdiNOSSDrUHXQDpFQ-1; Tue, 15 Nov 2022 10:15:57 -0500
X-MC-Unique: aYP-XwdiNOSSDrUHXQDpFQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F1772833B0A;
	Tue, 15 Nov 2022 15:15:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B225E2166B2C;
	Tue, 15 Nov 2022 15:15:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5E8431946A62;
	Tue, 15 Nov 2022 15:15:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8557A19465B9
 for <dm-devel@listman.corp.redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 769AC40C6EC3; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ECA840E978A
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54C0C833A06
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-LAjnDCYDP4uRkWdLA32Rgw-1; Tue, 15 Nov 2022 08:49:36 -0500
X-MC-Unique: LAjnDCYDP4uRkWdLA32Rgw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4NBSGK0Jt0z4f3v7Y;
 Tue, 15 Nov 2022 21:49:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP4 (Coremail) with SMTP id gCh0CgBni9jnmHNjrPFIAg--.61645S11;
 Tue, 15 Nov 2022 21:49:32 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com
Date: Tue, 15 Nov 2022 22:10:51 +0800
Message-Id: <20221115141054.1051801-8-yukuai1@huaweicloud.com>
In-Reply-To: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgBni9jnmHNjrPFIAg--.61645S11
X-Coremail-Antispam: 1UD129KBjvJXoW3GF1DZFyUur4fZr4rGryfZwb_yoW7Zr13pF
 W5GFWxtrW8JF4DuF4qqw47XF1Ygw1jg3WxCFWfKryI9rZxAr4v9F13Jry7XFyrtr92gF43
 tF45XrWY9F10krJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
 4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
 3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
 IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
 M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
 kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
 14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
 kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAF
 wI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
 W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOBTY
 UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 15 Nov 2022 15:15:46 +0000
Subject: [dm-devel] [PATCH v3 07/10] block: remove delayed holder
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
Cc: linux-block@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Now that dm has been fixed to track of holder registrations before
add_disk, the somewhat buggy block layer code can be safely removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/genhd.c          |  4 ---
 block/holder.c         | 72 ++++++++++++------------------------------
 include/linux/blkdev.h |  5 ---
 3 files changed, 21 insertions(+), 60 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e9501c66ba4d..dcf200bcbd3e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -479,10 +479,6 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
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
index 5283bc804cc1..dd9327b43ce0 100644
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
index 9188aa3f6259..516e45246868 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -833,7 +833,6 @@ void set_capacity(struct gendisk *disk, sector_t size);
 #ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
 void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk);
-int bd_register_pending_holders(struct gendisk *disk);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
 				      struct gendisk *disk)
@@ -844,10 +843,6 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev,
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
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

