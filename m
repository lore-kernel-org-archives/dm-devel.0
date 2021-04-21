Return-Path: <SRS0=/8Iv=JS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB472C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 21 Apr 2021 16:46:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2662661448
	for <dm-devel@archiver.kernel.org>; Wed, 21 Apr 2021 16:46:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2662661448
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-12pXaamVMN2ncV5kYHxdnA-1; Wed, 21 Apr 2021 12:46:37 -0400
X-MC-Unique: 12pXaamVMN2ncV5kYHxdnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88F0118BA297;
	Wed, 21 Apr 2021 16:46:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDA1A5D747;
	Wed, 21 Apr 2021 16:46:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 09C361806D1A;
	Wed, 21 Apr 2021 16:46:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13LGkAsG013321 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Apr 2021 12:46:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 83CC8219AAC8; Wed, 21 Apr 2021 16:46:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E2A621993E2
	for <dm-devel@redhat.com>; Wed, 21 Apr 2021 16:46:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0191A80D643
	for <dm-devel@redhat.com>; Wed, 21 Apr 2021 16:46:07 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-326-GShat291PUWyJdbgXui8LA-1;
	Wed, 21 Apr 2021 12:46:02 -0400
X-MC-Unique: GShat291PUWyJdbgXui8LA-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id 0FDFA424B9;
	Wed, 21 Apr 2021 12:45:59 -0400 (EDT)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.858.5; Wed, 21 Apr 2021 18:45:56 +0200
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, 
	<dm-devel@redhat.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 21 Apr 2021 19:45:42 +0300
Message-ID: <1619023545-23431-2-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1619023545-23431-1-git-send-email-sergei.shtepa@veeam.com>
References: <1619023545-23431-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B59677566
X-Veeam-MMEX: True
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: pavel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH v9 1/4] Adds blk_interposer
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Additional fields were added in the block_device structure:
bd_interposer and bd_interposer_lock. The bd_interposer field contains
a pointer to an interposer block device. bd_interposer_lock is a lock
which allows to safely attach and detach the interposer device.

New functions bdev_interposer_attach() and bdev_interposer_detach()
allow to attach and detach an interposer device. But first it is
required to lock the processing of bio requests by the block device
with bdev_interposer_lock() function.

The BIO_INTERPOSED flag means that the bio request has been already
interposed. This flag avoids recursive bio request interception.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 block/genhd.c             | 52 +++++++++++++++++++++++++++++++++++++++
 fs/block_dev.c            |  3 +++
 include/linux/blk_types.h |  6 +++++
 include/linux/blkdev.h    | 32 ++++++++++++++++++++++++
 4 files changed, 93 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 8c8f543572e6..3ec77947b3ba 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1938,3 +1938,55 @@ static void disk_release_events(struct gendisk *disk)
 	WARN_ON_ONCE(disk->ev && disk->ev->block != 1);
 	kfree(disk->ev);
 }
+
+/**
+ * bdev_interposer_attach - Attach an interposer block device to original
+ * @original: original block device
+ * @interposer: interposer block device
+ *
+ * Before attaching an interposer, it is necessary to lock the processing
+ * of bio requests of the original device by calling bdev_interposer_lock().
+ *
+ * The bdev_interposer_detach() function allows to detach the interposer
+ * from the original block device.
+ */
+int bdev_interposer_attach(struct block_device *original,
+			   struct block_device *interposer)
+{
+	struct block_device *bdev;
+
+	WARN_ON(!original);
+	if (original->bd_interposer)
+		return -EBUSY;
+
+	bdev = bdgrab(interposer);
+	if (!bdev)
+		return -ENODEV;
+
+	original->bd_interposer = bdev;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bdev_interposer_attach);
+
+/**
+ * bdev_interposer_detach - Detach interposer from block device
+ * @original: original block device
+ *
+ * Before detaching an interposer, it is necessary to lock the processing
+ * of bio requests of the original device by calling bdev_interposer_lock().
+ *
+ * The interposer should be attached using the bdev_interposer_attach()
+ * function.
+ */
+void bdev_interposer_detach(struct block_device *original)
+{
+	if (WARN_ON(!original))
+		return;
+
+	if (!original->bd_interposer)
+		return;
+
+	bdput(original->bd_interposer);
+	original->bd_interposer = NULL;
+}
+EXPORT_SYMBOL_GPL(bdev_interposer_detach);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 09d6f7229db9..a98a56cc634f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -809,6 +809,7 @@ static void bdev_free_inode(struct inode *inode)
 {
 	struct block_device *bdev = I_BDEV(inode);
 
+	percpu_free_rwsem(&bdev->bd_interposer_lock);
 	free_percpu(bdev->bd_stats);
 	kfree(bdev->bd_meta_info);
 
@@ -909,6 +910,8 @@ struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
 		iput(inode);
 		return NULL;
 	}
+	bdev->bd_interposer = NULL;
+	percpu_init_rwsem(&bdev->bd_interposer_lock);
 	return bdev;
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index db026b6ec15a..8e4309eb3b18 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -46,6 +46,11 @@ struct block_device {
 	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
 	struct gendisk *	bd_disk;
 	struct backing_dev_info *bd_bdi;
+	/* The interposer allows to redirect bio to another device */
+	struct block_device	*bd_interposer;
+	/* Lock the queue of block device to attach or detach interposer.
+	 * Allows to safely suspend and flush interposer. */
+	struct percpu_rw_semaphore bd_interposer_lock;
 
 	/* The counter of freeze processes */
 	int			bd_fsfreeze_count;
@@ -304,6 +309,7 @@ enum {
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
 	BIO_REMAPPED,
+	BIO_INTERPOSED,		/* bio was reassigned to another block device */
 	BIO_FLAG_LAST
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 158aefae1030..3e38b0c40b9d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -2029,4 +2029,36 @@ int fsync_bdev(struct block_device *bdev);
 int freeze_bdev(struct block_device *bdev);
 int thaw_bdev(struct block_device *bdev);
 
+/**
+ * bdev_interposer_lock - Lock bio processing
+ * @bdev: locking block device
+ *
+ * Lock the bio processing in submit_bio_noacct() for the new requests in the
+ * original block device. Requests from the interposer will not be locked.
+ *
+ * To unlock, use the bdev_interposer_unlock() function.
+ *
+ * This lock should be used to attach/detach the interposer to the device.
+ */
+static inline void bdev_interposer_lock(struct block_device *bdev)
+{
+	percpu_down_write(&bdev->bd_interposer_lock);
+}
+
+/**
+ * bdev_interposer_unlock - Unlock bio processing
+ * @bdev: locked block device
+ *
+ * Unlock the bio processing that was locked by bdev_interposer_lock() function.
+ *
+ * This lock should be used to attach/detach the interposer to the device.
+ */
+static inline void bdev_interposer_unlock(struct block_device *bdev)
+{
+	percpu_up_write(&bdev->bd_interposer_lock);
+}
+
+int bdev_interposer_attach(struct block_device *original,
+			   struct block_device *interposer);
+void bdev_interposer_detach(struct block_device *original);
 #endif /* _LINUX_BLKDEV_H */
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

