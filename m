Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72165C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 15 Nov 2022 15:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668525392;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WpQEAkuhYqLpO+lUb+P8iph8E1RPLEhja/SwWd7DJAQ=;
	b=AT0T3ERZMN8QPeKhUY7c7YaqFCXG3dIZqUR1RdWaB4QvPLkniCkWUj3w3UtNLNEJU1FM4p
	Woj9K0t6thklwiSwtQuwe3SCusbZLnsY21F2V4JHDs/NvLWokjNxEVLiRrXcXp6kFwzatd
	wiyftSNbhmie5YYVafq8Eqfno0lHBp0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-W6FSHwGMNeaT1-6Wi93n7g-1; Tue, 15 Nov 2022 10:15:57 -0500
X-MC-Unique: W6FSHwGMNeaT1-6Wi93n7g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD8EA857FAC;
	Tue, 15 Nov 2022 15:15:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 977E5C15E76;
	Tue, 15 Nov 2022 15:15:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CFBF719465A4;
	Tue, 15 Nov 2022 15:15:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E92219465B7
 for <dm-devel@listman.corp.redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7000E40E978C; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6849940C6EC3
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D5EB382C965
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:39 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-201-qIVKrMKmNFuq94K3vCeLWw-1; Tue, 15 Nov 2022 08:49:36 -0500
X-MC-Unique: qIVKrMKmNFuq94K3vCeLWw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4NBSGJ4Kn8z4f41hn;
 Tue, 15 Nov 2022 21:49:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP4 (Coremail) with SMTP id gCh0CgBni9jnmHNjrPFIAg--.61645S10;
 Tue, 15 Nov 2022 21:49:31 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com
Date: Tue, 15 Nov 2022 22:10:50 +0800
Message-Id: <20221115141054.1051801-7-yukuai1@huaweicloud.com>
In-Reply-To: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgBni9jnmHNjrPFIAg--.61645S10
X-Coremail-Antispam: 1UD129KBjvJXoWxAw1fWrW5Kw4fKr4fJryxXwb_yoWrJFyUpF
 ZxWayaqrWrGFsFvw47Xw4Uury5trs5ta4rZry7Gw1I9w15Ar909FW8GFy3XFyDJ397KFy5
 XFWUtr4rua18KrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
Subject: [dm-devel] [PATCH v3 06/10] dm: track per-add_disk holder relations
 in DM
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

dm is a bit special in that it opens the underlying devices.  Commit
89f871af1b26 ("dm: delay registering the gendisk") tried to accommodate
that by allowing to add the holder to the list before add_gendisk and
then just add them to sysfs once add_disk is called.  But that leads to
really odd lifetime problems and error handling problems as we can't
know the state of the kobjects and don't unwind properly.  To fix this
switch to just registering all existing table_devices with the holder
code right after add_disk, and remove them before calling del_gendisk.

Fixes: 89f871af1b26 ("dm: delay registering the gendisk")
Reported-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm.c | 49 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3728b56b364b..e1ea3a7bd9d9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -751,9 +751,16 @@ static struct table_device *open_table_device(struct mapped_device *md,
 		goto out_free_td;
 	}
 
-	r = bd_link_disk_holder(bdev, dm_disk(md));
-	if (r)
-		goto out_blkdev_put;
+	/*
+	 * We can be called before the dm disk is added.  In that case we can't
+	 * register the holder relation here.  It will be done once add_disk was
+	 * called.
+	 */
+	if (md->disk->slave_dir) {
+		r = bd_link_disk_holder(bdev, md->disk);
+		if (r)
+			goto out_blkdev_put;
+	}
 
 	td->dm_dev.mode = mode;
 	td->dm_dev.bdev = bdev;
@@ -774,7 +781,8 @@ static struct table_device *open_table_device(struct mapped_device *md,
  */
 static void close_table_device(struct table_device *td, struct mapped_device *md)
 {
-	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
+	if (md->disk->slave_dir)
+		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
 	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
 	put_dax(td->dm_dev.dax_dev);
 	list_del(&td->list);
@@ -1951,7 +1959,13 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		md->disk->private_data = NULL;
 		spin_unlock(&_minor_lock);
 		if (dm_get_md_type(md) != DM_TYPE_NONE) {
+			struct table_device *td;
+
 			dm_sysfs_exit(md);
+			list_for_each_entry(td, &md->table_devices, list) {
+				bd_unlink_disk_holder(td->dm_dev.bdev,
+						      md->disk);
+			}
 
 			/*
 			 * Hold lock to make sure del_gendisk() won't concurrent
@@ -2291,6 +2305,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
 	enum dm_queue_mode type = dm_table_get_type(t);
 	struct queue_limits limits;
+	struct table_device *td;
 	int r;
 
 	switch (type) {
@@ -2329,16 +2344,30 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	if (r)
 		return r;
 
-	r = dm_sysfs_init(md);
-	if (r) {
-		mutex_lock(&md->table_devices_lock);
-		del_gendisk(md->disk);
-		mutex_unlock(&md->table_devices_lock);
-		return r;
+	/*
+	 * Register the holder relationship for devices added before the disk
+	 * was live.
+	 */
+	list_for_each_entry(td, &md->table_devices, list) {
+		r = bd_link_disk_holder(td->dm_dev.bdev, md->disk);
+		if (r)
+			goto out_undo_holders;
 	}
 
+	r = dm_sysfs_init(md);
+	if (r)
+		goto out_undo_holders;
+
 	md->type = type;
 	return 0;
+
+out_undo_holders:
+	list_for_each_entry_continue_reverse(td, &md->table_devices, list)
+		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
+	mutex_lock(&md->table_devices_lock);
+	del_gendisk(md->disk);
+	mutex_unlock(&md->table_devices_lock);
+	return r;
 }
 
 struct mapped_device *dm_get_md(dev_t dev)
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

