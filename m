Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5776C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 16:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666284452;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PbwbO65+Skv5FGHaZf3MdYkI4N2hlrA3ZW3qC2KWVzg=;
	b=BCFnL2ps7CygZy+d9N82erAn1Ao8BJ/1uWugmDrXt7a6RSOVOA+zL9pgOnC2el47PawE1U
	r3RBrf0/6jP23q5mdjFiKZV+anw6PmR1JBp0SzdkbtebcULEhkc3YCuiPDjyewW2IkR28T
	qVAI+ta0yCvV4reaw0ThTzvZ9Yty5hQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-ZKNqB23sNCWduxyVVTys0Q-1; Thu, 20 Oct 2022 12:47:29 -0400
X-MC-Unique: ZKNqB23sNCWduxyVVTys0Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D1C487B2AF;
	Thu, 20 Oct 2022 16:47:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 11E372024CC6;
	Thu, 20 Oct 2022 16:47:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B12D71946595;
	Thu, 20 Oct 2022 16:47:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D84F19465A2
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 16:46:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3058B40A367F; Thu, 20 Oct 2022 16:46:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 286BE40A367B
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 16:46:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B69B3101CC6E
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 16:46:53 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-65-_rnzvTGEMzySj8r9Y_H-OA-1; Thu, 20 Oct 2022 12:46:51 -0400
X-MC-Unique: _rnzvTGEMzySj8r9Y_H-OA-1
Received: from [205.220.129.26] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1olYgu-000WUB-Dr; Thu, 20 Oct 2022 16:46:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Date: Thu, 20 Oct 2022 09:46:02 -0700
Message-Id: <20221020164605.1764830-4-hch@lst.de>
In-Reply-To: <20221020164605.1764830-1-hch@lst.de>
References: <20221020164605.1764830-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 3/6] dm: cleanup open_table_device
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
index 36189a32329aa..f60d9e8fc3abf 100644
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

