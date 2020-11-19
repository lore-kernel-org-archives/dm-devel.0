Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40DFCC56201
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:50:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 457F922227
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:50:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 457F922227
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-9_NovrWQP_O0be8i8MzQZA-1; Thu, 19 Nov 2020 11:50:06 -0500
X-MC-Unique: 9_NovrWQP_O0be8i8MzQZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8249AA0CA0;
	Thu, 19 Nov 2020 16:50:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EC7F5C1D1;
	Thu, 19 Nov 2020 16:50:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 287C54EBC6;
	Thu, 19 Nov 2020 16:50:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJGngkN004039 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 11:49:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E3CA52166B2D; Thu, 19 Nov 2020 16:49:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA25F2166B29
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 16:49:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72A03811E76
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 16:49:39 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-39-sDxyZOmNNgm-LXi0mfZaYQ-1;
	Thu, 19 Nov 2020 11:49:33 -0500
X-MC-Unique: sDxyZOmNNgm-LXi0mfZaYQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 44A50AC65;
	Thu, 19 Nov 2020 16:49:31 +0000 (UTC)
From: Hannes Reinecke <hare@suse.de>
To: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 19 Nov 2020 17:49:23 +0100
Message-Id: <20201119164924.74401-2-hare@suse.de>
In-Reply-To: <20201119164924.74401-1-hare@suse.de>
References: <20201119164924.74401-1-hare@suse.de>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>, Sergei Shtepa <sergei.shtepa@veeam.com>
Subject: [dm-devel] [PATCH 1/2] blk_interposer - Block Layer Interposer
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Sergei Shtepa <sergei.shtepa@veeam.com>

The block layer interposer allows to intercept bio requests.
This allows you to connect device mapper and other kernel
modules to the block device stack on the fly.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c          | 34 +++++++++++++++++++++++++++++
 block/genhd.c             | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk_types.h |  6 ++++--
 include/linux/genhd.h     | 19 ++++++++++++++++
 4 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2db8bda43b6e..130f0124d939 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1030,6 +1030,37 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
 	return ret;
 }
 
+static blk_qc_t __submit_bio_interposed(struct bio *bio)
+{
+	struct bio_list bio_list[2] = { };
+	blk_qc_t ret = BLK_QC_T_NONE;
+
+	current->bio_list = bio_list;
+	if (likely(bio_queue_enter(bio) == 0)) {
+		struct gendisk *disk = bio->bi_disk;
+
+		bio_set_flag(bio, BIO_INTERPOSED);
+		if (likely(blk_has_interposer(disk))) {
+			struct blk_interposer *ip = disk->interposer;
+			ret = ip->ip_submit_bio(ip, bio);
+
+			if (ret == BLK_QC_T_NONE)
+				blk_queue_exit(disk->queue);
+		} else {
+			/* interposer was removed */
+			bio_list_add(&current->bio_list[0], bio);
+			blk_queue_exit(bio->bi_disk->queue);
+		}
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
@@ -1055,6 +1086,9 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
+	if (blk_has_interposer(bio->bi_disk) &&
+	    !bio_flagged(bio, BIO_INTERPOSED))
+		return __submit_bio_interposed(bio);
 	if (!bio->bi_disk->fops->submit_bio)
 		return __submit_bio_noacct_mq(bio);
 	return __submit_bio_noacct(bio);
diff --git a/block/genhd.c b/block/genhd.c
index 9387f050c248..17b43e2ed06a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -2364,3 +2364,58 @@ static void disk_release_events(struct gendisk *disk)
 	WARN_ON_ONCE(disk->ev && disk->ev->block != 1);
 	kfree(disk->ev);
 }
+
+/**
+ * blk_interposer_attach - Attach interposer to disk
+ * @disk: target disk
+ * @interposer: block device interposer
+ *
+ * Returns:
+ *     -EINVAL if @interposer is NULL.
+ *     -ENODEV if interposer is not initialized,
+ *     -EBUSY if the block device already has interposer.
+ */
+int blk_interposer_attach(struct gendisk *disk,
+			  struct blk_interposer *interposer)
+{
+	int ret = 0;
+
+	if (!interposer)
+		return -EINVAL;
+
+	blk_mq_freeze_queue(disk->queue);
+	blk_mq_quiesce_queue(disk->queue);
+	if (blk_has_interposer(disk))
+		ret = -EBUSY;
+	else
+		disk->interposer = interposer;
+	blk_mq_unquiesce_queue(disk->queue);
+	blk_mq_unfreeze_queue(disk->queue);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(blk_interposer_attach);
+
+/**
+ * blk_interposer_detach - Detach interposer from disk
+ * @disk: target disk
+ *
+ * Returns the attached interposer or NULL if none was attached.
+ */
+struct blk_interposer *blk_interposer_detach(struct gendisk *disk)
+{
+	struct blk_interposer *interposer;
+
+	if (WARN_ON(!disk))
+		return NULL;
+
+	blk_mq_freeze_queue(disk->queue);
+	blk_mq_quiesce_queue(disk->queue);
+	interposer = disk->interposer;
+	disk->interposer = NULL;
+	blk_mq_unquiesce_queue(disk->queue);
+	blk_mq_unfreeze_queue(disk->queue);
+
+	return interposer;
+}
+EXPORT_SYMBOL_GPL(blk_interposer_detach);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d9b69bbde5cc..996b803e5aa1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -207,7 +207,7 @@ struct bio {
 						 * top bits REQ_OP. Use
 						 * accessors.
 						 */
-	unsigned short		bi_flags;	/* status, etc and bvec pool number */
+	unsigned int		bi_flags;	/* status, etc and bvec pool number */
 	unsigned short		bi_ioprio;
 	unsigned short		bi_write_hint;
 	blk_status_t		bi_status;
@@ -284,6 +284,8 @@ enum {
 				 * of this bio. */
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
+	BIO_INTERPOSED,		/* bio has been interposed and can be moved to
+				 * a different disk */
 	BIO_FLAG_LAST
 };
 
@@ -302,7 +304,7 @@ enum {
  * freed.
  */
 #define BVEC_POOL_BITS		(3)
-#define BVEC_POOL_OFFSET	(16 - BVEC_POOL_BITS)
+#define BVEC_POOL_OFFSET	(32 - BVEC_POOL_BITS)
 #define BVEC_POOL_IDX(bio)	((bio)->bi_flags >> BVEC_POOL_OFFSET)
 #if (1<< BVEC_POOL_BITS) < (BVEC_POOL_NR+1)
 # error "BVEC_POOL_BITS is too small"
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 03da3f603d30..f58ab391deda 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -164,6 +164,15 @@ struct blk_integrity {
 	unsigned char				tag_size;
 };
 
+struct blk_interposer;
+typedef blk_qc_t (*ip_submit_bio_t) (struct blk_interposer *ip, struct bio *bio);
+
+struct blk_interposer {
+	struct gendisk *ip_disk;
+	ip_submit_bio_t ip_submit_bio;
+	void *ip_private;
+};
+
 struct gendisk {
 	/* major, first_minor and minors are input parameters only,
 	 * don't use directly.  Use disk_devt() and disk_max_parts().
@@ -188,6 +197,7 @@ struct gendisk {
 
 	const struct block_device_operations *fops;
 	struct request_queue *queue;
+	struct blk_interposer *interposer;
 	void *private_data;
 
 	int flags;
@@ -409,4 +419,13 @@ static inline dev_t blk_lookup_devt(const char *name, int partno)
 }
 #endif /* CONFIG_BLOCK */
 
+/*
+ * Block device interposing
+ */
+#define blk_has_interposer(d) ((d)->interposer != NULL)
+#define blk_interposer_active(ip) ((ip)->ip_disk != NULL)
+
+int blk_interposer_attach(struct gendisk *, struct blk_interposer *);
+struct blk_interposer * blk_interposer_detach(struct gendisk *);
+
 #endif /* _LINUX_GENHD_H */
-- 
2.16.4

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

