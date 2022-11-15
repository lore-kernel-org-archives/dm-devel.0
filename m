Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D5FC43217
	for <dm-devel@archiver.kernel.org>; Tue, 15 Nov 2022 15:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668525404;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aAJ6PwAlQHJmN8kpmrtSp3QZwQiKMCeHQ9dgXVWgV/k=;
	b=bBQRgAB8ZkP3bfmRfZME76TL430FS/oU7t1WBpHRFO5MR1ZMduABgO1sB0+sqVnAbRwPHd
	/VaM9Rpbli6X7q6vQInQYifnXqqzce5uWz95lTxtkW5CbUvWGRVsnPTqpJpGO4+rjSgkYu
	zIo6GvmoR59Ks9yxGVgj1r3F8OhL2gg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-vookcyvkPd-0OGu-rgCuZA-1; Tue, 15 Nov 2022 10:16:05 -0500
X-MC-Unique: vookcyvkPd-0OGu-rgCuZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D102803FEB;
	Tue, 15 Nov 2022 15:15:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 33F4B2166B41;
	Tue, 15 Nov 2022 15:15:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 90B261946A66;
	Tue, 15 Nov 2022 15:15:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DAD7119465B7
 for <dm-devel@listman.corp.redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C074B2028E8F; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B92D02024CCA
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88E2B1C09B6D
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-299-FQwDH9bmMCSPFdB51g2MSg-1; Tue, 15 Nov 2022 08:49:36 -0500
X-MC-Unique: FQwDH9bmMCSPFdB51g2MSg-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NBSGK2bQyz4f3vdr;
 Tue, 15 Nov 2022 21:49:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP4 (Coremail) with SMTP id gCh0CgBni9jnmHNjrPFIAg--.61645S12;
 Tue, 15 Nov 2022 21:49:32 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com
Date: Tue, 15 Nov 2022 22:10:52 +0800
Message-Id: <20221115141054.1051801-9-yukuai1@huaweicloud.com>
In-Reply-To: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgBni9jnmHNjrPFIAg--.61645S12
X-Coremail-Antispam: 1UD129KBjvJXoW7tr1rGFyxAFWxAFy3Ar1DKFg_yoW8KFWUpF
 Z0gFyrKry8GrsrZrsrt347XFWjg3W8W3W8AFW29F4I9rZxArsI9r1xAFy7WF1xKrWIvF4q
 qF1UX3yFvF10kFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 15 Nov 2022 15:15:46 +0000
Subject: [dm-devel] [PATCH v3 08/10] block: fix use after free for
 bd_holder_dir
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

From: Yu Kuai <yukuai3@huawei.com>

Currently, the caller of bd_link_disk_holer() get 'bdev' by
blkdev_get_by_dev(), which will look up 'bdev' by inode number 'dev'.
Howerver, it's possible that del_gendisk() can be called currently, and
'bd_holder_dir' can be freed before bd_link_disk_holer() access it, thus
use after free is triggered.

t1:				t2:
bdev = blkdev_get_by_dev
				del_gendisk
				 kobject_put(bd_holder_dir)
				  kobject_free()
bd_link_disk_holder

Fix the problem by checking disk is still live and grabbing a reference
to 'bd_holder_dir' first in bd_link_disk_holder().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/holder.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/block/holder.c b/block/holder.c
index dd9327b43ce0..c8e462053f49 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -65,12 +65,24 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	if (WARN_ON_ONCE(!disk->slave_dir))
 		return -EINVAL;
 
-	mutex_lock(&disk->open_mutex);
+	/*
+	 * del_gendisk drops the initial reference to bd_holder_dir, so we
+	 * need to keep our own here to allow for cleanup past that point.
+	 */
+	mutex_lock(&bdev->bd_disk->open_mutex);
+	if (!disk_live(bdev->bd_disk)) {
+		mutex_unlock(&bdev->bd_disk->open_mutex);
+		return -ENODEV;
+	}
+	kobject_get(bdev->bd_holder_dir);
+	mutex_unlock(&bdev->bd_disk->open_mutex);
 
+	mutex_lock(&disk->open_mutex);
 	WARN_ON_ONCE(!bdev->bd_holder);
 
 	holder = bd_find_holder_disk(bdev, disk);
 	if (holder) {
+		kobject_put(bdev->bd_holder_dir);
 		holder->refcnt++;
 		goto out_unlock;
 	}
@@ -92,11 +104,6 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 		goto out_del_symlink;
 	list_add(&holder->list, &disk->slave_bdevs);
 
-	/*
-	 * del_gendisk drops the initial reference to bd_holder_dir, so we need
-	 * to keep our own here to allow for cleanup past that point.
-	 */
-	kobject_get(bdev->bd_holder_dir);
 	mutex_unlock(&disk->open_mutex);
 	return 0;
 
@@ -106,6 +113,8 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	kfree(holder);
 out_unlock:
 	mutex_unlock(&disk->open_mutex);
+	if (ret)
+		kobject_put(bdev->bd_holder_dir);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(bd_link_disk_holder);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

