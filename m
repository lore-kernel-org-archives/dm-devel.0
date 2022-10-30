Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E3DC38A02
	for <dm-devel@archiver.kernel.org>; Sun, 30 Oct 2022 17:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667150890;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+F67CEyj9C1rnmwHFVlBrbp0ZNMVBCAWHZmYldxgPUI=;
	b=DtAZ1c1jyz8eQxsqA99/7eiCxYRUMV8sns3AykOUrY6ePHP/foUI0wJvxwJOMfVMmJZjU0
	4I8pF09CvxDKd6OKg3cFOiNl0e82clz4SvjCMBDCttdvhteGC6yvQ+e6MY1LO/mobBuZ49
	FlWUYfIMLJjZFHbTlH20/uC6/4kKK3k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-yBT28DVXPkO8fJrME_JPVA-1; Sun, 30 Oct 2022 13:28:07 -0400
X-MC-Unique: yBT28DVXPkO8fJrME_JPVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BC903C0ED56;
	Sun, 30 Oct 2022 17:28:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A44E2C15BB3;
	Sun, 30 Oct 2022 17:28:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 65750194658C;
	Sun, 30 Oct 2022 17:28:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 318391946589
 for <dm-devel@listman.corp.redhat.com>; Sun, 30 Oct 2022 17:28:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8036AC15BB3; Sun, 30 Oct 2022 17:28:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7889CC15BA8
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 17:28:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E7EA8027EA
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 17:28:02 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-204-BAm31yeyPduD0MoaoMhUuQ-1; Sun, 30 Oct 2022 13:28:00 -0400
X-MC-Unique: BAm31yeyPduD0MoaoMhUuQ-1
Received: from 213-225-37-80.nat.highway.a1.net ([213.225.37.80]
 helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1opAHn-00HVrM-58; Sun, 30 Oct 2022 15:31:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Date: Sun, 30 Oct 2022 16:31:15 +0100
Message-Id: <20221030153120.1045101-4-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 3/7] dm: cleanup open_table_device
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move all the logic for allocation the table_device and linking it into
the list into the open_table_device.  This keeps the code tidy and
ensures that the table_devices only exist in fully initialized state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 56 ++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 19d25bf997be4..28d7581b6a826 100644
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
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

