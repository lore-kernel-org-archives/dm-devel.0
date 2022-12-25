Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB333C4332F
	for <dm-devel@archiver.kernel.org>; Sun, 25 Dec 2022 13:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671974393;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tOHzRYUAeiTJofDwzQ/AIdm1FfiQZwKuR8U6KpId4as=;
	b=iTR1SFhulttLndcg2l3Y+aLj2FZ8ICDvhjZMwA3rY9awDvFEcNIQJEW+8J34eA3XAX79r/
	thnMCPJkr1JkEnSDeI9kOt1ZR8hPhhyWZop0zE1pI79cG8kTKr2XrNdVD1pfYpiVLuJwF8
	QKfypmQ/VNVn2qUGALmybJM3bK4/8rE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-0y0k2Zd3NBigWFXt5neZRw-1; Sun, 25 Dec 2022 08:19:50 -0500
X-MC-Unique: 0y0k2Zd3NBigWFXt5neZRw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C2338533E8;
	Sun, 25 Dec 2022 13:19:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F34EB492C14;
	Sun, 25 Dec 2022 13:19:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ADA461946588;
	Sun, 25 Dec 2022 13:19:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C1FC41946586
 for <dm-devel@listman.corp.redhat.com>; Sun, 25 Dec 2022 13:19:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 544C4C15BAD; Sun, 25 Dec 2022 13:19:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CB2FC15BA0
 for <dm-devel@redhat.com>; Sun, 25 Dec 2022 13:19:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32C4C29AA2C0
 for <dm-devel@redhat.com>; Sun, 25 Dec 2022 13:19:45 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-71aynrrWOtuI2X5_1cFYbw-1; Sun, 25 Dec 2022 08:19:43 -0500
X-MC-Unique: 71aynrrWOtuI2X5_1cFYbw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 03511B80735;
 Sun, 25 Dec 2022 13:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AAAC433D2;
 Sun, 25 Dec 2022 13:19:40 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	hch@lst.de
Date: Sun, 25 Dec 2022 08:19:38 -0500
Message-Id: <20221225131938.601770-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] Patch "dm: cleanup open_table_device" has been added to
 the 6.1-stable tree
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm: cleanup open_table_device

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-cleanup-open_table_device.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 37398ed8ff6e602292156443ae5d536f95c79d3a
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Nov 15 22:10:47 2022 +0800

    dm: cleanup open_table_device
    
    [ Upstream commit b9a785d2dc6567b2fd9fc60057a6a945a276927a ]
    
    Move all the logic for allocation the table_device and linking it into
    the list into the open_table_device.  This keeps the code tidy and
    ensures that the table_devices only exist in fully initialized state.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Reviewed-by: Mike Snitzer <snitzer@kernel.org>
    Link: https://lore.kernel.org/r/20221115141054.1051801-4-yukuai1@huaweicloud.com
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    Stable-dep-of: 1a581b721699 ("dm: track per-add_disk holder relations in DM")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 95a1ee3d314e..739996499f4d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -732,28 +732,41 @@ static char *_dm_claim_ptr = "I belong to device-mapper";
 /*
  * Open a table device so we can use it as a map destination.
  */
-static int open_table_device(struct table_device *td, dev_t dev,
-			     struct mapped_device *md)
+static struct table_device *open_table_device(struct mapped_device *md,
+		dev_t dev, fmode_t mode)
 {
+	struct table_device *td;
 	struct block_device *bdev;
 	u64 part_off;
 	int r;
 
-	BUG_ON(td->dm_dev.bdev);
+	td = kmalloc_node(sizeof(*td), GFP_KERNEL, md->numa_node_id);
+	if (!td)
+		return ERR_PTR(-ENOMEM);
+	refcount_set(&td->count, 1);
 
-	bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
-	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
+	bdev = blkdev_get_by_dev(dev, mode | FMODE_EXCL, _dm_claim_ptr);
+	if (IS_ERR(bdev)) {
+		r = PTR_ERR(bdev);
+		goto out_free_td;
+	}
 
 	r = bd_link_disk_holder(bdev, dm_disk(md));
-	if (r) {
-		blkdev_put(bdev, td->dm_dev.mode | FMODE_EXCL);
-		return r;
-	}
+	if (r)
+		goto out_blkdev_put;
 
+	td->dm_dev.mode = mode;
 	td->dm_dev.bdev = bdev;
 	td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev, &part_off, NULL, NULL);
-	return 0;
+	format_dev_t(td->dm_dev.name, dev);
+	list_add(&td->list, &md->table_devices);
+	return td;
+
+out_blkdev_put:
+	blkdev_put(bdev, mode | FMODE_EXCL);
+out_free_td:
+	kfree(td);
+	return ERR_PTR(r);
 }
 
 /*
@@ -786,31 +799,16 @@ static struct table_device *find_table_device(struct list_head *l, dev_t dev,
 int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
 			struct dm_dev **result)
 {
-	int r;
 	struct table_device *td;
 
 	mutex_lock(&md->table_devices_lock);
 	td = find_table_device(&md->table_devices, dev, mode);
 	if (!td) {
-		td = kmalloc_node(sizeof(*td), GFP_KERNEL, md->numa_node_id);
-		if (!td) {
-			mutex_unlock(&md->table_devices_lock);
-			return -ENOMEM;
-		}
-
-		td->dm_dev.mode = mode;
-		td->dm_dev.bdev = NULL;
-
-		if ((r = open_table_device(td, dev, md))) {
+		td = open_table_device(md, dev, mode);
+		if (IS_ERR(td)) {
 			mutex_unlock(&md->table_devices_lock);
-			kfree(td);
-			return r;
+			return PTR_ERR(td);
 		}
-
-		format_dev_t(td->dm_dev.name, dev);
-
-		refcount_set(&td->count, 1);
-		list_add(&td->list, &md->table_devices);
 	} else {
 		refcount_inc(&td->count);
 	}

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

