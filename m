Return-Path: <SRS0=/efG=IB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51066C433E6
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 12:31:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BED3B64ECF
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 12:31:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BED3B64ECF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-p6Y9RPFWMB2MqDtT-5Uknw-1; Wed, 03 Mar 2021 07:31:00 -0500
X-MC-Unique: p6Y9RPFWMB2MqDtT-5Uknw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B799251F7;
	Wed,  3 Mar 2021 12:30:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24C2010016FA;
	Wed,  3 Mar 2021 12:30:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C01EA18089CC;
	Wed,  3 Mar 2021 12:30:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 123CUp0A011533 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Mar 2021 07:30:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EA6991302A9A; Wed,  3 Mar 2021 12:30:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A861B1302A71
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 12:30:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 857DE805F27
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 12:30:50 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-383-f2V8cH79N_qld5rp58SQpA-1;
	Wed, 03 Mar 2021 07:30:45 -0500
X-MC-Unique: f2V8cH79N_qld5rp58SQpA-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id 488D8114A96;
	Wed,  3 Mar 2021 15:30:43 +0300 (MSK)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Wed, 3 Mar 2021 13:30:41 +0100
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: <snitzer@redhat.com>, <agk@redhat.com>, <hare@suse.de>, <song@kernel.org>, 
	<axboe@kernel.dk>, <dm-devel@redhat.com>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <linux-api@vger.kernel.org>
Date: Wed, 3 Mar 2021 15:30:16 +0300
Message-ID: <1614774618-22410-3-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1614774618-22410-1-git-send-email-sergei.shtepa@veeam.com>
References: <1614774618-22410-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D265637363
X-Veeam-MMEX: True
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: pavel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH v6 2/4] block: add blk_interposer
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

blk_interposer allows to intercept bio requests, remap bio
to another devices or add new bios.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 block/bio.c               |  2 +
 block/blk-core.c          | 36 +++++++++++++++
 block/genhd.c             | 93 +++++++++++++++++++++++++++++++++++++++
 include/linux/blk_types.h |  4 ++
 include/linux/blkdev.h    | 17 +++++++
 5 files changed, 152 insertions(+)

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
index fc60ff208497..e749507cadd3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1018,6 +1018,34 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
 	return ret;
 }
 
+static blk_qc_t __submit_bio_interposed(struct bio *bio)
+{
+	struct bio_list bio_list[2] = { };
+	blk_qc_t ret = BLK_QC_T_NONE;
+
+	current->bio_list = bio_list;
+	if (likely(bio_queue_enter(bio) == 0)) {
+		struct block_device *bdev = bio->bi_bdev;
+
+		if (likely(bdev_has_interposer(bdev))) {
+			bio_set_flag(bio, BIO_INTERPOSED);
+			bdev->bd_interposer->ip_submit_bio(bio);
+		} else {
+			/* interposer was removed */
+			bio_list_add(&current->bio_list[0], bio);
+		}
+
+		blk_queue_exit(bdev->bd_disk->queue);
+	}
+	current->bio_list = NULL;
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
@@ -1043,6 +1071,14 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
+	/*
+	 * Checking the BIO_INTERPOSED flag is necessary so that the bio
+	 * created by the bdev_interposer do not get to it for processing.
+	 */
+	if (bdev_has_interposer(bio->bi_bdev) &&
+	    !bio_flagged(bio, BIO_INTERPOSED))
+		return __submit_bio_interposed(bio);
+
 	if (!bio->bi_bdev->bd_disk->fops->submit_bio)
 		return __submit_bio_noacct_mq(bio);
 	return __submit_bio_noacct(bio);
diff --git a/block/genhd.c b/block/genhd.c
index fcc530164b5a..1ae8516643c8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -30,6 +30,11 @@
 static struct kobject *block_depr;
 
 DECLARE_RWSEM(bdev_lookup_sem);
+/*
+ * Prevents different block-layer interposers from attaching or detaching
+ * to the block device at the same time.
+ */
+DEFINE_MUTEX(bdev_interposer_attach_lock);
 
 /* for extended dynamic devt allocation, currently only one major is used */
 #define NR_EXT_DEVT		(1 << MINORBITS)
@@ -1941,3 +1946,91 @@ static void disk_release_events(struct gendisk *disk)
 	WARN_ON_ONCE(disk->ev && disk->ev->block != 1);
 	kfree(disk->ev);
 }
+
+/**
+ * bdev_interposer_attach - Attach interposer to block device
+ * @bdev: target block device
+ * @interposer: block device interposer
+ * @ip_submit_bio: hook for submit_bio()
+ *
+ * Returns:
+ *     -EINVAL if @interposer is NULL.
+ *     -EPERM if queue is not frozen.
+ *     -EBUSY if the block device already has @interposer.
+ *     -EALREADY if the block device already has @interposer with same callback.
+ *     -ENODEV if the block device cannot be referenced.
+ *
+ * Disk must be frozen by blk_mq_freeze_queue().
+ */
+int bdev_interposer_attach(struct block_device *bdev, struct bdev_interposer *interposer,
+			  const ip_submit_bio_t ip_submit_bio)
+{
+	int ret = 0;
+
+	if (WARN_ON(!interposer))
+		return -EINVAL;
+
+	if (!blk_mq_is_queue_frozen(bdev->bd_disk->queue))
+		return -EPERM;
+
+	mutex_lock(&bdev_interposer_attach_lock);
+	if (bdev_has_interposer(bdev)) {
+		if (bdev->bd_interposer->ip_submit_bio == ip_submit_bio)
+			ret = -EALREADY;
+		else
+			ret = -EBUSY;
+		goto out;
+	}
+
+	interposer->ip_submit_bio = ip_submit_bio;
+
+	interposer->bdev = bdgrab(bdev);
+	if (!interposer->bdev) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	bdev->bd_interposer = interposer;
+out:
+	mutex_unlock(&bdev_interposer_attach_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bdev_interposer_attach);
+
+/**
+ * bdev_interposer_detach - Detach interposer from block device
+ * @interposer: block device interposer
+ * @ip_submit_bio: hook for submit_bio()
+ *
+ * Disk must be frozen by blk_mq_freeze_queue().
+ */
+void bdev_interposer_detach(struct bdev_interposer *interposer,
+			  const ip_submit_bio_t ip_submit_bio)
+{
+	struct block_device *bdev;
+
+	if (WARN_ON(!interposer))
+		return;
+
+	mutex_lock(&bdev_interposer_attach_lock);
+
+	/* Check if the interposer is still active. */
+	bdev = interposer->bdev;
+	if (WARN_ON(!bdev))
+		goto out;
+
+	if (WARN_ON(!blk_mq_is_queue_frozen(bdev->bd_disk->queue)))
+		goto out;
+
+	/* Check if it is really our interposer. */
+	if (WARN_ON(bdev->bd_interposer->ip_submit_bio != ip_submit_bio))
+		goto out;
+
+	bdev->bd_interposer = NULL;
+	interposer->bdev = NULL;
+	bdput(bdev);
+out:
+	mutex_unlock(&bdev_interposer_attach_lock);
+}
+EXPORT_SYMBOL_GPL(bdev_interposer_detach);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index db026b6ec15a..2b43f65bb356 100644
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
+	struct bdev_interposer * bd_interposer;
 
 	/* The counter of freeze processes */
 	int			bd_fsfreeze_count;
@@ -304,6 +306,8 @@ enum {
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
 	BIO_REMAPPED,
+	BIO_INTERPOSED,		/* bio has been interposed and can be moved to
+				 * a different block device */
 	BIO_FLAG_LAST
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c032cfe133c7..82f8515fa3c8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -2033,4 +2033,21 @@ int fsync_bdev(struct block_device *bdev);
 int freeze_bdev(struct block_device *bdev);
 int thaw_bdev(struct block_device *bdev);
 
+/*
+ * block layer interposers structure and functions
+ */
+typedef void (*ip_submit_bio_t) (struct bio *bio);
+
+struct bdev_interposer {
+	ip_submit_bio_t ip_submit_bio;
+	struct block_device *bdev;
+};
+
+#define bdev_has_interposer(bd) ((bd)->bd_interposer != NULL)
+
+int bdev_interposer_attach(struct block_device *bdev, struct bdev_interposer *interposer,
+			   const ip_submit_bio_t ip_submit_bio);
+void bdev_interposer_detach(struct bdev_interposer *interposer,
+			    const ip_submit_bio_t ip_submit_bio);
+
 #endif /* _LINUX_BLKDEV_H */
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

