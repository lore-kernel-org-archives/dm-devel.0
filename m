Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E9D2ECAAA1
	for <dm-devel@archiver.kernel.org>; Sun, 30 Oct 2022 15:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667144655;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fA3aTL6hRognCbnL7kW0kNfL2RSXJAY081lmkFE2O6Y=;
	b=TlJ9bKoQuk06kC4YzxdqEjoIBt7V189kRHV2JL9G0thz+ilYCMX6fiPdPTq7qXu7O+S2ar
	K5IxVY/mQuURnZeSUM4C4iWIQ/eGB6EZQlyoIrUUsBecyMnrJB7lk40pTk8OpevAPrQ4tD
	b96Z3gU0uasxVDE8vksaAodvDAxnEoI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-iB4PiNMmPQu16rs45hSYkg-1; Sun, 30 Oct 2022 11:44:12 -0400
X-MC-Unique: iB4PiNMmPQu16rs45hSYkg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA2CB3C0CD4A;
	Sun, 30 Oct 2022 15:44:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 64606111E3FF;
	Sun, 30 Oct 2022 15:44:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0EA90194658C;
	Sun, 30 Oct 2022 15:44:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0F31D1946589
 for <dm-devel@listman.corp.redhat.com>; Sun, 30 Oct 2022 15:44:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9C3B12028E90; Sun, 30 Oct 2022 15:44:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 949B62028E8F
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 15:44:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75FB2185A79C
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 15:44:08 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-578-giA-MxjiNs222gKDedj0jg-1; Sun, 30 Oct 2022 11:44:06 -0400
X-MC-Unique: giA-MxjiNs222gKDedj0jg-1
Received: from 213-225-37-80.nat.highway.a1.net ([213.225.37.80]
 helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1opAHz-00HW4C-54; Sun, 30 Oct 2022 15:31:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Date: Sun, 30 Oct 2022 16:31:19 +0100
Message-Id: <20221030153120.1045101-8-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 7/7] block: store the holder kobject in
 bd_holder_disk
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

We hold a reference to the holder kobject for each bd_holder_disk,
so to make the code a bit more robust, use a reference to it instead
of the block_device.  As long as no one clears ->bd_holder_dir in
before freeing the disk, this isn't strictly required, but it does
make the code more clear and more robust.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/holder.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/block/holder.c b/block/holder.c
index dd9327b43ce05..a8c355b9d0806 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -4,7 +4,7 @@
 
 struct bd_holder_disk {
 	struct list_head	list;
-	struct block_device	*bdev;
+	struct kobject		*holder_dir;
 	int			refcnt;
 };
 
@@ -14,7 +14,7 @@ static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
 	struct bd_holder_disk *holder;
 
 	list_for_each_entry(holder, &disk->slave_bdevs, list)
-		if (holder->bdev == bdev)
+		if (holder->holder_dir == bdev->bd_holder_dir)
 			return holder;
 	return NULL;
 }
@@ -82,27 +82,24 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	}
 
 	INIT_LIST_HEAD(&holder->list);
-	holder->bdev = bdev;
 	holder->refcnt = 1;
+	holder->holder_dir = kobject_get(bdev->bd_holder_dir);
+
 	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
 	if (ret)
-		goto out_free_holder;
-	ret = add_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
+		goto out_put_holder_dir;
+	ret = add_symlink(holder->holder_dir, &disk_to_dev(disk)->kobj);
 	if (ret)
 		goto out_del_symlink;
 	list_add(&holder->list, &disk->slave_bdevs);
 
-	/*
-	 * del_gendisk drops the initial reference to bd_holder_dir, so we need
-	 * to keep our own here to allow for cleanup past that point.
-	 */
-	kobject_get(bdev->bd_holder_dir);
 	mutex_unlock(&disk->open_mutex);
 	return 0;
 
 out_del_symlink:
 	del_symlink(disk->slave_dir, bdev_kobj(bdev));
-out_free_holder:
+out_put_holder_dir:
+	kobject_put(holder->holder_dir);
 	kfree(holder);
 out_unlock:
 	mutex_unlock(&disk->open_mutex);
@@ -131,8 +128,8 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	holder = bd_find_holder_disk(bdev, disk);
 	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
 		del_symlink(disk->slave_dir, bdev_kobj(bdev));
-		del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
-		kobject_put(bdev->bd_holder_dir);
+		del_symlink(holder->holder_dir, &disk_to_dev(disk)->kobj);
+		kobject_put(holder->holder_dir);
 		list_del_init(&holder->list);
 		kfree(holder);
 	}
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

