Return-Path: <SRS0=WBCP=JG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B6FC433ED
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 11:48:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 52B37610CC
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 11:48:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52B37610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-usw7sfWKMROIfDioxyh0wQ-1; Fri, 09 Apr 2021 07:48:38 -0400
X-MC-Unique: usw7sfWKMROIfDioxyh0wQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 548A510866AD;
	Fri,  9 Apr 2021 11:48:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DFBA1045D01;
	Fri,  9 Apr 2021 11:48:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EEA721806D10;
	Fri,  9 Apr 2021 11:48:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 139BmVIA000940 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 9 Apr 2021 07:48:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 797D621602A6; Fri,  9 Apr 2021 11:48:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 736AB21602A3
	for <dm-devel@redhat.com>; Fri,  9 Apr 2021 11:48:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9ABA805F47
	for <dm-devel@redhat.com>; Fri,  9 Apr 2021 11:48:26 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-191-4xHyzz76Nq-ljWUrIlYjgg-1;
	Fri, 09 Apr 2021 07:48:22 -0400
X-MC-Unique: 4xHyzz76Nq-ljWUrIlYjgg-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id EA95F4031D;
	Fri,  9 Apr 2021 07:48:18 -0400 (EDT)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Fri, 9 Apr 2021 13:48:17 +0200
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, 
	<dm-devel@redhat.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 9 Apr 2021 14:48:01 +0300
Message-ID: <1617968884-15149-2-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1617968884-15149-1-git-send-email-sergei.shtepa@veeam.com>
References: <1617968884-15149-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B59657262
X-Veeam-MMEX: True
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
Cc: pavel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH v8 1/4] Adds blk_interposer. It allows to
	redirect bio requests to another block device.
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 block/genhd.c             | 51 +++++++++++++++++++++++++++++++++++++++
 fs/block_dev.c            |  3 +++
 include/linux/blk_types.h |  6 +++++
 include/linux/blkdev.h    | 32 ++++++++++++++++++++++++
 4 files changed, 92 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 8c8f543572e6..533b33897187 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1938,3 +1938,54 @@ static void disk_release_events(struct gendisk *disk)
 	WARN_ON_ONCE(disk->ev && disk->ev->block != 1);
 	kfree(disk->ev);
 }
+
+/**
+ * bdev_interposer_attach - Attach interposer block device to original
+ * @original: original block device
+ * @interposer: interposer block device
+ *
+ * Before attaching the interposer, it is necessary to lock the processing
+ * of bio requests of the original device by calling the bdev_interposer_lock().
+ *
+ * The bdev_interposer_detach() function allows to detach the interposer
+ * from original block device.
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
+ * Before detaching the interposer, it is necessary to lock the processing
+ * of bio requests of the original device by calling the bdev_interposer_lock().
+ *
+ * The interposer should be attached using function bdev_interposer_attach().
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
index 158aefae1030..9e376ee34e19 100644
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
+ * original block device. Requests from interposer will not be locked.
+ *
+ * To unlock, use the function bdev_interposer_unlock().
+ *
+ * This lock should be used to attach/detach interposer to the device.
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
+ * Unlock the bio processing that was locked by function bdev_interposer_lock().
+ *
+ * This lock should be used to attach/detach interposer to the device.
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

