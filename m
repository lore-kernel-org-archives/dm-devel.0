Return-Path: <SRS0=Go1D=MR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9299CC4338F
	for <dm-devel@archiver.kernel.org>; Sun, 25 Jul 2021 05:57:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CCC1660F13
	for <dm-devel@archiver.kernel.org>; Sun, 25 Jul 2021 05:57:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CCC1660F13
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-lnuUhJ5UNB2PfqISj_6TfQ-1; Sun, 25 Jul 2021 01:57:07 -0400
X-MC-Unique: lnuUhJ5UNB2PfqISj_6TfQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59B888042E2;
	Sun, 25 Jul 2021 05:57:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09E3D60C0F;
	Sun, 25 Jul 2021 05:57:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8F7CE180BAB3;
	Sun, 25 Jul 2021 05:56:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16P5uWiN010413 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 25 Jul 2021 01:56:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E60282166BA3; Sun, 25 Jul 2021 05:56:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E16EB2166B49
	for <dm-devel@redhat.com>; Sun, 25 Jul 2021 05:56:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6577B80B71D
	for <dm-devel@redhat.com>; Sun, 25 Jul 2021 05:56:28 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-523-nch5GYn-O2ucCNuB766DzQ-1; Sun, 25 Jul 2021 01:56:26 -0400
X-MC-Unique: nch5GYn-O2ucCNuB766DzQ-1
Received: from [2001:4bb8:184:87c5:a8b3:bdfd:fc9b:6250] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m7X7A-00Cphh-1i; Sun, 25 Jul 2021 05:56:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Sun, 25 Jul 2021 07:54:53 +0200
Message-Id: <20210725055458.29008-4-hch@lst.de>
In-Reply-To: <20210725055458.29008-1-hch@lst.de>
References: <20210725055458.29008-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 3/8] block: look up holders by bdev
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Invert they way the holder relations are tracked.  This very
slightly reduces the memory overhead for partitioned devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c             |  3 +++
 block/holder.c            | 18 +++++++++---------
 fs/block_dev.c            |  3 ---
 include/linux/blk_types.h |  3 ---
 include/linux/genhd.h     |  4 +++-
 5 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index af4d2ab4a633..e2708a4a7a47 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1263,6 +1263,9 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 	disk_to_dev(disk)->class = &block_class;
 	disk_to_dev(disk)->type = &disk_type;
 	device_initialize(disk_to_dev(disk));
+#ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
+	INIT_LIST_HEAD(&disk->slave_bdevs);
+#endif
 	return disk;
 
 out_destroy_part_tbl:
diff --git a/block/holder.c b/block/holder.c
index 960654a71342..11e65d99a9fb 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -3,7 +3,7 @@
 
 struct bd_holder_disk {
 	struct list_head	list;
-	struct gendisk		*disk;
+	struct block_device	*bdev;
 	int			refcnt;
 };
 
@@ -12,8 +12,8 @@ static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
 {
 	struct bd_holder_disk *holder;
 
-	list_for_each_entry(holder, &bdev->bd_holder_disks, list)
-		if (holder->disk == disk)
+	list_for_each_entry(holder, &disk->slave_bdevs, list)
+		if (holder->bdev == bdev)
 			return holder;
 	return NULL;
 }
@@ -61,7 +61,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	struct bd_holder_disk *holder;
 	int ret = 0;
 
-	mutex_lock(&bdev->bd_disk->open_mutex);
+	mutex_lock(&disk->open_mutex);
 
 	WARN_ON_ONCE(!bdev->bd_holder);
 
@@ -82,7 +82,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	}
 
 	INIT_LIST_HEAD(&holder->list);
-	holder->disk = disk;
+	holder->bdev = bdev;
 	holder->refcnt = 1;
 
 	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
@@ -93,7 +93,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	if (ret)
 		goto out_del;
 
-	list_add(&holder->list, &bdev->bd_holder_disks);
+	list_add(&holder->list, &disk->slave_bdevs);
 	goto out_unlock;
 
 out_del:
@@ -101,7 +101,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 out_free:
 	kfree(holder);
 out_unlock:
-	mutex_unlock(&bdev->bd_disk->open_mutex);
+	mutex_unlock(&disk->open_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(bd_link_disk_holder);
@@ -120,7 +120,7 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 {
 	struct bd_holder_disk *holder;
 
-	mutex_lock(&bdev->bd_disk->open_mutex);
+	mutex_lock(&disk->open_mutex);
 	holder = bd_find_holder_disk(bdev, disk);
 	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
 		del_symlink(disk->slave_dir, bdev_kobj(bdev));
@@ -128,6 +128,6 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 		list_del_init(&holder->list);
 		kfree(holder);
 	}
-	mutex_unlock(&bdev->bd_disk->open_mutex);
+	mutex_unlock(&disk->open_mutex);
 }
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7825d152634e..22646906ddaa 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -900,9 +900,6 @@ struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
 	bdev->bd_disk = disk;
 	bdev->bd_partno = partno;
 	bdev->bd_inode = inode;
-#ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
-	INIT_LIST_HEAD(&bdev->bd_holder_disks);
-#endif
 	bdev->bd_stats = alloc_percpu(struct disk_stats);
 	if (!bdev->bd_stats) {
 		iput(inode);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 7a4e139d24ef..e92735655684 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -34,9 +34,6 @@ struct block_device {
 	void *			bd_holder;
 	int			bd_holders;
 	bool			bd_write_holder;
-#ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
-	struct list_head	bd_holder_disks;
-#endif
 	struct kobject		*bd_holder_dir;
 	u8			bd_partno;
 	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6831d74f2002..26c8557e2714 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -159,7 +159,9 @@ struct gendisk {
 	unsigned open_partitions;	/* number of open partitions */
 
 	struct kobject *slave_dir;
-
+#ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
+	struct list_head slave_bdevs;
+#endif
 	struct timer_rand_state *random;
 	atomic_t sync_io;		/* RAID */
 	struct disk_events *ev;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

