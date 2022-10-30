Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6702ECAAA1
	for <dm-devel@archiver.kernel.org>; Sun, 30 Oct 2022 16:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667148148;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=s7vEud2Givo8V7cVfbT9b2wrN2AV9WPe3SIBosAsQKk=;
	b=FnhwyTiea1rU9t+clbm5EOPN73ur5+X7D/r6htk544dp/snvWpYpDRmYKhjjhkQPue4mIz
	aeuO2rRSC+TjJkTtu0ALRScbdZMZMePbTgLZmu4un6eiAa6DKf4kb4bbvL6U2XeErWMUyX
	wWufy4ZuZuBFnJp8wh/2Y0ZDEPWdhCQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-byXO-MzdNeKB_a3i-r7ukw-1; Sun, 30 Oct 2022 12:42:27 -0400
X-MC-Unique: byXO-MzdNeKB_a3i-r7ukw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D75BD833AEF;
	Sun, 30 Oct 2022 16:42:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1207140EBF3;
	Sun, 30 Oct 2022 16:42:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1FF3F194658C;
	Sun, 30 Oct 2022 16:42:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C48B11946589
 for <dm-devel@listman.corp.redhat.com>; Sun, 30 Oct 2022 16:42:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 71194207B34A; Sun, 30 Oct 2022 16:42:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 69CEC207B344
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 16:42:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A0D8811E67
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 16:42:22 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-410-ogXJUUb1M0WJArfbmwXSpA-1; Sun, 30 Oct 2022 12:42:20 -0400
X-MC-Unique: ogXJUUb1M0WJArfbmwXSpA-1
Received: from 213-225-37-80.nat.highway.a1.net ([213.225.37.80]
 helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1opAHt-00HVxu-9m; Sun, 30 Oct 2022 15:31:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Date: Sun, 30 Oct 2022 16:31:17 +0100
Message-Id: <20221030153120.1045101-6-hch@lst.de>
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
Subject: [dm-devel] [PATCH 5/7] dm: track per-add_disk holder relations in DM
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm is a bit special in that it opens the underlying devices.  Commit
89f871af1b26 ("dm: delay registering the gendisk") tried to accomodate
that by allowing to add the holder to the list before add_gendisk and
then just add them to sysfs once add_disk is called.  But that leads to
really odd lifetime problems and error handling problems as we can't
know the state of the kobjects and don't unwind properly.  To fix this
switch to just registering all existing table_devices with the holder
code right after add_disk, and remove them before calling del_gendisk.

Fixes: 89f871af1b26 ("dm: delay registering the gendisk")
Reported-by: Yu Kuai <yukuai1@huaweicloud.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 45 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2917700b1e15c..7b0d6dc957549 100644
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
 			del_gendisk(md->disk);
 		}
 		dm_queue_destroy_crypto_profile(md->queue);
@@ -2284,6 +2298,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
 	enum dm_queue_mode type = dm_table_get_type(t);
 	struct queue_limits limits;
+	struct table_device *td;
 	int r;
 
 	switch (type) {
@@ -2316,13 +2331,27 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	if (r)
 		return r;
 
-	r = dm_sysfs_init(md);
-	if (r) {
-		del_gendisk(md->disk);
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
+
+	r = dm_sysfs_init(md);
+	if (r)
+		goto out_undo_holders;
 	md->type = type;
 	return 0;
+
+out_undo_holders:
+	list_for_each_entry_continue_reverse(td, &md->table_devices, list)
+		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
+	del_gendisk(md->disk);
+	return r;
 }
 
 struct mapped_device *dm_get_md(dev_t dev)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

