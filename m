Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14D76C77B78
	for <dm-devel@archiver.kernel.org>; Fri, 14 Apr 2023 06:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681455131;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ng3Y9rXvL+/ZYlupqTJlGtrNpj/GR30eC/4eARk/6rw=;
	b=h2miSMFlCOADzQji39aAbNdVbCtThbfuNEqBeGxX/o9i1LiS9RiJ6NvpfYsdAun14FV7uo
	R+6lDLNNNEZrdCHnAle7Hy/tNZiu1ehtx9Eh87N4/OYHd7k3j84CdkAigMUlA1k2Ev8t6o
	t1333UdaQEk0YOMOuyJu4UTecVfBHyQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-zeruLonFNiSMaKrO_1ZZjg-1; Fri, 14 Apr 2023 02:52:07 -0400
X-MC-Unique: zeruLonFNiSMaKrO_1ZZjg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EF2D28055B1;
	Fri, 14 Apr 2023 06:52:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8C47409AFC6;
	Fri, 14 Apr 2023 06:52:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 10F8319472CF;
	Fri, 14 Apr 2023 06:52:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B4A8F19465B7
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Apr 2023 00:02:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A46992027044; Fri, 14 Apr 2023 00:02:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C35C2027043
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 00:02:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E35F85A5A3
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 00:02:44 +0000 (UTC)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-T2PWShewN2aEw2EDUTQiNA-1; Thu, 13 Apr 2023 20:02:42 -0400
X-MC-Unique: T2PWShewN2aEw2EDUTQiNA-1
Received: by mail-pj1-f42.google.com with SMTP id
 c10-20020a17090abf0a00b0023d1bbd9f9eso20081914pjs.0
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 17:02:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681430561; x=1684022561;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=1v27frhDXboIukcqHIRkhbLm0yBxlDAQEyM68TRxYVI=;
 b=RRgYx5lhUBv/ySQLv2WqvOYOAwkdd11ORWdacTwa7twHWAgkDCwHiHC1/nS2r68ifp
 1crdykbpnlGutxinZewKcYQq33Xl+NhRJXDXl7kt2DnBKA5KnbfNRSCTt0chlieuBHvH
 LguFetsYf0mYxukeQGuN9qUnOhqKbeYkak9mpu7rQLd4BVwzliPCArCjWQS+i56JXYxT
 +zWHGGBMyliCgSlbnKQZOqYb50J7+u+oBTQdqLxaLUOR9qyhei4E6PK7tBVr1SyQnKWX
 up2k3Sw85Jk8SUl8UniT/puAE+wY4DPliz0jmnF5+otucenJBw6MOkYZYtZh1BnKqc9/
 2slg==
X-Gm-Message-State: AAQBX9eJfYvuBCO8NRiwrvu/Tdzq2RCkJkFWX1fxXRMdXaIvDLfYzYvu
 /zn8g7CQ0BdJGVDCkNzTHSldIQ==
X-Google-Smtp-Source: AKy350bsCzhCErOgvyUWg+gFxIVn0gvgfymer0DPSV09zh4cR+UNuAgmRiHK1Mydt0y0aacyGPzsYg==
X-Received: by 2002:a17:90b:1e49:b0:246:b2aa:c08 with SMTP id
 pi9-20020a17090b1e4900b00246b2aa0c08mr3842591pjb.22.1681430561466; 
 Thu, 13 Apr 2023 17:02:41 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com
 ([2620:15c:9d:200:72cc:7fa5:adcb:7c02])
 by smtp.gmail.com with ESMTPSA id
 u18-20020a17090a891200b002470f179b92sm2212939pjn.43.2023.04.13.17.02.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 13 Apr 2023 17:02:40 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: sarthakkukreti@google.com, dm-devel@redhat.com,
 linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 13 Apr 2023 17:02:17 -0700
Message-ID: <20230414000219.92640-2-sarthakkukreti@chromium.org>
In-Reply-To: <20230414000219.92640-1-sarthakkukreti@chromium.org>
References: <20221229071647.437095-1-sarthakkukreti@chromium.org>
 <20230414000219.92640-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Fri, 14 Apr 2023 06:52:02 +0000
Subject: [dm-devel] [PATCH v3 1/3] block: Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce block request REQ_OP_PROVISION. The intent of this request
is to request underlying storage to preallocate disk space for the given
block range. Block devices that support this capability will export
a provision limit within their request queues.

This patch also adds the capability to call fallocate() in mode 0
on block devices, which will send REQ_OP_PROVISION to the block
device for the specified range,

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 block/blk-core.c          |  5 ++++
 block/blk-lib.c           | 53 +++++++++++++++++++++++++++++++++++++++
 block/blk-merge.c         | 18 +++++++++++++
 block/blk-settings.c      | 19 ++++++++++++++
 block/blk-sysfs.c         |  8 ++++++
 block/bounce.c            |  1 +
 block/fops.c              | 14 ++++++++---
 include/linux/bio.h       |  6 +++--
 include/linux/blk_types.h |  5 +++-
 include/linux/blkdev.h    | 16 ++++++++++++
 10 files changed, 138 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 42926e6cb83c..4a2342ba3a8b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -123,6 +123,7 @@ static const char *const blk_op_name[] = {
 	REQ_OP_NAME(WRITE_ZEROES),
 	REQ_OP_NAME(DRV_IN),
 	REQ_OP_NAME(DRV_OUT),
+	REQ_OP_NAME(PROVISION)
 };
 #undef REQ_OP_NAME
 
@@ -798,6 +799,10 @@ void submit_bio_noacct(struct bio *bio)
 		if (!q->limits.max_write_zeroes_sectors)
 			goto not_supported;
 		break;
+	case REQ_OP_PROVISION:
+		if (!q->limits.max_provision_sectors)
+			goto not_supported;
+		break;
 	default:
 		break;
 	}
diff --git a/block/blk-lib.c b/block/blk-lib.c
index e59c3069e835..647b6451660b 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -343,3 +343,56 @@ int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_secure_erase);
+
+/**
+ * blkdev_issue_provision - provision a block range
+ * @bdev:	blockdev to write
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to provision
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *  Issues a provision request to the block device for the range of sectors.
+ *  For thinly provisioned block devices, this acts as a signal for the
+ *  underlying storage pool to allocate space for this block range.
+ */
+int blkdev_issue_provision(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp)
+{
+	sector_t bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	unsigned int max_sectors = bdev_max_provision_sectors(bdev);
+	struct bio *bio = NULL;
+	struct blk_plug plug;
+	int ret = 0;
+
+	if (max_sectors == 0)
+		return -EOPNOTSUPP;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	blk_start_plug(&plug);
+	for (;;) {
+		unsigned int req_sects = min_t(sector_t, nr_sects, max_sectors);
+
+		bio = blk_next_bio(bio, bdev, 0, REQ_OP_PROVISION, gfp);
+		bio->bi_iter.bi_sector = sector;
+		bio->bi_iter.bi_size = req_sects << SECTOR_SHIFT;
+
+		sector += req_sects;
+		nr_sects -= req_sects;
+		if (!nr_sects) {
+			ret = submit_bio_wait(bio);
+			if (ret == -EOPNOTSUPP)
+				ret = 0;
+			bio_put(bio);
+			break;
+		}
+		cond_resched();
+	}
+	blk_finish_plug(&plug);
+
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_provision);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 6460abdb2426..a3ffebb97a1d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -158,6 +158,21 @@ static struct bio *bio_split_write_zeroes(struct bio *bio,
 	return bio_split(bio, lim->max_write_zeroes_sectors, GFP_NOIO, bs);
 }
 
+static struct bio *bio_split_provision(struct bio *bio,
+					const struct queue_limits *lim,
+					unsigned int *nsegs, struct bio_set *bs)
+{
+	*nsegs = 0;
+
+	if (!lim->max_provision_sectors)
+		return NULL;
+
+	if (bio_sectors(bio) <= lim->max_provision_sectors)
+		return NULL;
+
+	return bio_split(bio, lim->max_provision_sectors, GFP_NOIO, bs);
+}
+
 /*
  * Return the maximum number of sectors from the start of a bio that may be
  * submitted as a single request to a block device. If enough sectors remain,
@@ -366,6 +381,9 @@ struct bio *__bio_split_to_limits(struct bio *bio,
 	case REQ_OP_WRITE_ZEROES:
 		split = bio_split_write_zeroes(bio, lim, nr_segs, bs);
 		break;
+	case REQ_OP_PROVISION:
+		split = bio_split_provision(bio, lim, nr_segs, bs);
+		break;
 	default:
 		split = bio_split_rw(bio, lim, nr_segs, bs,
 				get_max_io_size(bio, lim) << SECTOR_SHIFT);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 896b4654ab00..d303e6614c36 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -59,6 +59,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->zoned = BLK_ZONED_NONE;
 	lim->zone_write_granularity = 0;
 	lim->dma_alignment = 511;
+	lim->max_provision_sectors = 0;
 }
 
 /**
@@ -82,6 +83,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_dev_sectors = UINT_MAX;
 	lim->max_write_zeroes_sectors = UINT_MAX;
 	lim->max_zone_append_sectors = UINT_MAX;
+	lim->max_provision_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -208,6 +210,20 @@ void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
 }
 EXPORT_SYMBOL(blk_queue_max_write_zeroes_sectors);
 
+/**
+ * blk_queue_max_provision_sectors - set max sectors for a single provision
+ *
+ * @q:  the request queue for the device
+ * @max_provision_sectors: maximum number of sectors to provision per command
+ **/
+
+void blk_queue_max_provision_sectors(struct request_queue *q,
+		unsigned int max_provision_sectors)
+{
+	q->limits.max_provision_sectors = max_provision_sectors;
+}
+EXPORT_SYMBOL(blk_queue_max_provision_sectors);
+
 /**
  * blk_queue_max_zone_append_sectors - set max sectors for a single zone append
  * @q:  the request queue for the device
@@ -578,6 +594,9 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_segment_size = min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
 
+	t->max_provision_sectors = min_not_zero(t->max_provision_sectors,
+						b->max_provision_sectors);
+
 	t->misaligned |= b->misaligned;
 
 	alignment = queue_limit_alignment_offset(b, start);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index f1fce1c7fa44..202aa78f933e 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -132,6 +132,12 @@ static ssize_t queue_max_discard_segments_show(struct request_queue *q,
 	return queue_var_show(queue_max_discard_segments(q), page);
 }
 
+static ssize_t queue_max_provision_sectors_show(struct request_queue *q,
+		char *page)
+{
+	return queue_var_show(queue_max_provision_sectors(q), (page));
+}
+
 static ssize_t queue_max_integrity_segments_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(q->limits.max_integrity_segments, page);
@@ -599,6 +605,7 @@ QUEUE_RO_ENTRY(queue_io_min, "minimum_io_size");
 QUEUE_RO_ENTRY(queue_io_opt, "optimal_io_size");
 
 QUEUE_RO_ENTRY(queue_max_discard_segments, "max_discard_segments");
+QUEUE_RO_ENTRY(queue_max_provision_sectors, "max_provision_sectors");
 QUEUE_RO_ENTRY(queue_discard_granularity, "discard_granularity");
 QUEUE_RO_ENTRY(queue_discard_max_hw, "discard_max_hw_bytes");
 QUEUE_RW_ENTRY(queue_discard_max, "discard_max_bytes");
@@ -648,6 +655,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_max_sectors_entry.attr,
 	&queue_max_segments_entry.attr,
 	&queue_max_discard_segments_entry.attr,
+	&queue_max_provision_sectors_entry.attr,
 	&queue_max_integrity_segments_entry.attr,
 	&queue_max_segment_size_entry.attr,
 	&elv_iosched_entry.attr,
diff --git a/block/bounce.c b/block/bounce.c
index 7cfcb242f9a1..ab9d8723ae64 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -176,6 +176,7 @@ static struct bio *bounce_clone_bio(struct bio *bio_src)
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
 	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_PROVISION:
 		break;
 	default:
 		bio_for_each_segment(bv, bio_src, iter)
diff --git a/block/fops.c b/block/fops.c
index d2e6be4e3d1c..f82da2fb8af0 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -625,7 +625,7 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 	int error;
 
 	/* Fail if we don't recognize the flags. */
-	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
+	if (mode != 0 && mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
 		return -EOPNOTSUPP;
 
 	/* Don't go off the end of the device. */
@@ -649,11 +649,17 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 	filemap_invalidate_lock(inode->i_mapping);
 
 	/* Invalidate the page cache, including dirty pages. */
-	error = truncate_bdev_range(bdev, file->f_mode, start, end);
-	if (error)
-		goto fail;
+	if (mode != 0) {
+		error = truncate_bdev_range(bdev, file->f_mode, start, end);
+		if (error)
+			goto fail;
+	}
 
 	switch (mode) {
+	case 0:
+		error = blkdev_issue_provision(bdev, start >> SECTOR_SHIFT,
+					       len >> SECTOR_SHIFT, GFP_KERNEL);
+		break;
 	case FALLOC_FL_ZERO_RANGE:
 	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
 		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d766be7152e1..9820b3b039f2 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -57,7 +57,8 @@ static inline bool bio_has_data(struct bio *bio)
 	    bio->bi_iter.bi_size &&
 	    bio_op(bio) != REQ_OP_DISCARD &&
 	    bio_op(bio) != REQ_OP_SECURE_ERASE &&
-	    bio_op(bio) != REQ_OP_WRITE_ZEROES)
+	    bio_op(bio) != REQ_OP_WRITE_ZEROES &&
+	    bio_op(bio) != REQ_OP_PROVISION)
 		return true;
 
 	return false;
@@ -67,7 +68,8 @@ static inline bool bio_no_advance_iter(const struct bio *bio)
 {
 	return bio_op(bio) == REQ_OP_DISCARD ||
 	       bio_op(bio) == REQ_OP_SECURE_ERASE ||
-	       bio_op(bio) == REQ_OP_WRITE_ZEROES;
+	       bio_op(bio) == REQ_OP_WRITE_ZEROES ||
+	       bio_op(bio) == REQ_OP_PROVISION;
 }
 
 static inline void *bio_data(struct bio *bio)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 99be590f952f..27bdf88f541c 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -385,7 +385,10 @@ enum req_op {
 	REQ_OP_DRV_IN		= (__force blk_opf_t)34,
 	REQ_OP_DRV_OUT		= (__force blk_opf_t)35,
 
-	REQ_OP_LAST		= (__force blk_opf_t)36,
+	/* request device to provision block */
+	REQ_OP_PROVISION        = (__force blk_opf_t)37,
+
+	REQ_OP_LAST		= (__force blk_opf_t)38,
 };
 
 enum req_flag_bits {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 941304f17492..239e2f418b6e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -303,6 +303,7 @@ struct queue_limits {
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 	unsigned int		zone_write_granularity;
+	unsigned int		max_provision_sectors;
 
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
@@ -921,6 +922,8 @@ extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
 extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
 		unsigned int max_write_same_sectors);
+extern void blk_queue_max_provision_sectors(struct request_queue *q,
+		unsigned int max_provision_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_zone_append_sectors(struct request_queue *q,
 		unsigned int max_zone_append_sectors);
@@ -1060,6 +1063,9 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp);
 
+extern int blkdev_issue_provision(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp_mask);
+
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
 
@@ -1139,6 +1145,11 @@ static inline unsigned short queue_max_discard_segments(const struct request_que
 	return q->limits.max_discard_segments;
 }
 
+static inline unsigned short queue_max_provision_sectors(const struct request_queue *q)
+{
+	return q->limits.max_provision_sectors;
+}
+
 static inline unsigned int queue_max_segment_size(const struct request_queue *q)
 {
 	return q->limits.max_segment_size;
@@ -1281,6 +1292,11 @@ static inline bool bdev_nowait(struct block_device *bdev)
 	return test_bit(QUEUE_FLAG_NOWAIT, &bdev_get_queue(bdev)->queue_flags);
 }
 
+static inline unsigned int bdev_max_provision_sectors(struct block_device *bdev)
+{
+	return bdev_get_queue(bdev)->limits.max_provision_sectors;
+}
+
 static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
 {
 	return blk_queue_zoned_model(bdev_get_queue(bdev));
-- 
2.40.0.634.g4ca3ef3211-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

