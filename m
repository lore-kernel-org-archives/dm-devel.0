Return-Path: <SRS0=XTDI=IK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78788C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 16:21:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 089EC64F9E
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 16:21:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 089EC64F9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-mye-twu2NVSzBy9RvXvFmg-1; Fri, 12 Mar 2021 11:20:58 -0500
X-MC-Unique: mye-twu2NVSzBy9RvXvFmg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E42B193F560;
	Fri, 12 Mar 2021 16:20:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 690D71C92F;
	Fri, 12 Mar 2021 16:20:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A51E61800848;
	Fri, 12 Mar 2021 16:20:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12CFjSPB017710 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Mar 2021 10:45:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 499F12026D60; Fri, 12 Mar 2021 15:45:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 447322026D6A
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 15:45:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 554A780C8DC
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 15:45:26 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-416-zk7LRHQiNE-YQRDp4Hngag-1;
	Fri, 12 Mar 2021 10:45:22 -0500
X-MC-Unique: zk7LRHQiNE-YQRDp4Hngag-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id 741A9874F3;
	Fri, 12 Mar 2021 18:45:19 +0300 (MSK)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Fri, 12 Mar 2021 16:45:17 +0100
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, 
	Alasdair Kergon <agk@redhat.com>, Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>, <dm-devel@redhat.com>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-api@vger.kernel.org>
Date: Fri, 12 Mar 2021 18:44:54 +0300
Message-ID: <1615563895-28565-3-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1615563895-28565-1-git-send-email-sergei.shtepa@veeam.com>
References: <1615563895-28565-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B58627366
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
Subject: [dm-devel] [PATCH v7 2/3] block: add bdev_interposer
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

bdev_interposer allows to redirect bio requests to another devices.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 block/bio.c               |  2 ++
 block/blk-core.c          | 57 +++++++++++++++++++++++++++++++++++++++
 block/genhd.c             | 54 +++++++++++++++++++++++++++++++++++++
 include/linux/blk_types.h |  3 +++
 include/linux/blkdev.h    |  9 +++++++
 5 files changed, 125 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index a1c4d2900c7a..0bfbf06475ee 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -640,6 +640,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 		bio_set_flag(bio, BIO_THROTTLED);
 	if (bio_flagged(bio_src, BIO_REMAPPED))
 		bio_set_flag(bio, BIO_REMAPPED);
+	if (bio_flagged(bio_src, BIO_INTERPOSED))
+		bio_set_flag(bio, BIO_INTERPOSED);
 	bio->bi_opf = bio_src->bi_opf;
 	bio->bi_ioprio = bio_src->bi_ioprio;
 	bio->bi_write_hint = bio_src->bi_write_hint;
diff --git a/block/blk-core.c b/block/blk-core.c
index fc60ff208497..da1abc4c27a9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1018,6 +1018,55 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
 	return ret;
 }
 
+static noinline blk_qc_t submit_bio_interposed(struct bio *bio)
+{
+	blk_qc_t ret = BLK_QC_T_NONE;
+	struct bio_list bio_list[2] = { };
+	struct gendisk *orig_disk;
+
+	if (current->bio_list) {
+		bio_list_add(&current->bio_list[0], bio);
+		return BLK_QC_T_NONE;
+	}
+
+	orig_disk = bio->bi_bdev->bd_disk;
+	if (unlikely(bio_queue_enter(bio)))
+		return BLK_QC_T_NONE;
+
+	current->bio_list = bio_list;
+
+	do {
+		struct block_device *interposer = bio->bi_bdev->bd_interposer;
+
+		if (unlikely(!interposer)) {
+			/* interposer was removed */
+			bio_list_add(&current->bio_list[0], bio);
+			break;
+		}
+		/* assign bio to interposer device */
+		bio_set_dev(bio, interposer);
+		bio_set_flag(bio, BIO_INTERPOSED);
+
+		if (!submit_bio_checks(bio))
+			break;
+		/*
+		 * Because the current->bio_list is initialized,
+		 * the submit_bio callback will always return BLK_QC_T_NONE.
+		 */
+		interposer->bd_disk->fops->submit_bio(bio);
+	} while (false);
+
+	current->bio_list = NULL;
+
+	blk_queue_exit(orig_disk->queue);
+
+	/* Resubmit remaining bios */
+	while ((bio = bio_list_pop(&bio_list[0])))
+		ret = submit_bio_noacct(bio);
+
+	return ret;
+}
+
 /**
  * submit_bio_noacct - re-submit a bio to the block device layer for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -1029,6 +1078,14 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
  */
 blk_qc_t submit_bio_noacct(struct bio *bio)
 {
+	/*
+	 * Checking the BIO_INTERPOSED flag is necessary so that the bio
+	 * created by the bdev_interposer do not get to it for processing.
+	 */
+	if (bdev_has_interposer(bio->bi_bdev) &&
+	    !bio_flagged(bio, BIO_INTERPOSED))
+		return submit_bio_interposed(bio);
+
 	if (!submit_bio_checks(bio))
 		return BLK_QC_T_NONE;
 
diff --git a/block/genhd.c b/block/genhd.c
index c55e8f0fced1..c840ecffea68 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -30,6 +30,11 @@
 static struct kobject *block_depr;
 
 DECLARE_RWSEM(bdev_lookup_sem);
+/*
+ * Prevents different block-layer interposers from attaching or detaching
+ * to the block device at the same time.
+ */
+static DEFINE_MUTEX(bdev_interposer_attach_lock);
 
 /* for extended dynamic devt allocation, currently only one major is used */
 #define NR_EXT_DEVT		(1 << MINORBITS)
@@ -1940,3 +1945,52 @@ static void disk_release_events(struct gendisk *disk)
 	WARN_ON_ONCE(disk->ev && disk->ev->block != 1);
 	kfree(disk->ev);
 }
+
+int bdev_interposer_attach(struct block_device *original,
+			   struct block_device *interposer)
+{
+	int ret = 0;
+
+	if (WARN_ON(((!original) || (!interposer))))
+		return -EINVAL;
+	/*
+	 * interposer should be simple, no a multi-queue device
+	 */
+	if (!interposer->bd_disk->fops->submit_bio)
+		return -EINVAL;
+
+	if (WARN_ON(!blk_mq_is_queue_frozen(original->bd_disk->queue)))
+		return -EPERM;
+
+	mutex_lock(&bdev_interposer_attach_lock);
+
+	if (bdev_has_interposer(original))
+		ret = -EBUSY;
+	else {
+		original->bd_interposer = bdgrab(interposer);
+		if (!original->bd_interposer)
+			ret = -ENODEV;
+	}
+
+	mutex_unlock(&bdev_interposer_attach_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bdev_interposer_attach);
+
+void bdev_interposer_detach(struct block_device *original)
+{
+	if (WARN_ON(!original))
+		return;
+
+	if (WARN_ON(!blk_mq_is_queue_frozen(original->bd_disk->queue)))
+		return;
+
+	mutex_lock(&bdev_interposer_attach_lock);
+	if (bdev_has_interposer(original)) {
+		bdput(original->bd_interposer);
+		original->bd_interposer = NULL;
+	}
+	mutex_unlock(&bdev_interposer_attach_lock);
+}
+EXPORT_SYMBOL_GPL(bdev_interposer_detach);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index db026b6ec15a..13bda4732cf5 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -19,6 +19,7 @@ struct io_context;
 struct cgroup_subsys_state;
 typedef void (bio_end_io_t) (struct bio *);
 struct bio_crypt_ctx;
+struct bdev_interposer;
 
 struct block_device {
 	sector_t		bd_start_sect;
@@ -46,6 +47,7 @@ struct block_device {
 	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
 	struct gendisk *	bd_disk;
 	struct backing_dev_info *bd_bdi;
+	struct block_device     *bd_interposer;
 
 	/* The counter of freeze processes */
 	int			bd_fsfreeze_count;
@@ -304,6 +306,7 @@ enum {
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
 	BIO_REMAPPED,
+	BIO_INTERPOSED,		/* bio was reassigned to another block device */
 	BIO_FLAG_LAST
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bc6bc8383b43..90f62b4197da 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -2031,4 +2031,13 @@ int fsync_bdev(struct block_device *bdev);
 int freeze_bdev(struct block_device *bdev);
 int thaw_bdev(struct block_device *bdev);
 
+static inline bool bdev_has_interposer(struct block_device *bdev)
+{
+	return (bdev->bd_interposer != NULL);
+};
+
+int bdev_interposer_attach(struct block_device *original,
+			   struct block_device *interposer);
+void bdev_interposer_detach(struct block_device *original);
+
 #endif /* _LINUX_BLKDEV_H */
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

