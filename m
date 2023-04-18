Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76FB4C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 19 Apr 2023 03:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681876550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LJ3YGKzly1pcTN2vtlsv2+OI90joPfrROpnVoS8lMEs=;
	b=X23T8YqRvGSjeT+fUMKOa/DU3MdSsuB/GaPjf0oRFuYw7qQ2fkOYjngWBRjg6j2/uIcgJW
	2QvOA21EOrWxs9wqdjbNVeDRhTyB+TKZjEBROfBlBiL6++akJVfpgdMX1d5xgVELmlqxV5
	gYVgOpKRvfw6vQagqUmHP7jxxvq0FdE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-hSB0oNASOQa7Oyd2q-sbVQ-1; Tue, 18 Apr 2023 23:55:47 -0400
X-MC-Unique: hSB0oNASOQa7Oyd2q-sbVQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A4AA8996F9;
	Wed, 19 Apr 2023 03:55:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29B12492B04;
	Wed, 19 Apr 2023 03:55:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9CB231946A54;
	Wed, 19 Apr 2023 03:55:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9ED4A194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Apr 2023 22:12:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 75938492B05; Tue, 18 Apr 2023 22:12:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D6DD492B04
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 22:12:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 525E2885620
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 22:12:33 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-pa8Bev-uPeKzjmnBKn5zrQ-1; Tue, 18 Apr 2023 18:12:31 -0400
X-MC-Unique: pa8Bev-uPeKzjmnBKn5zrQ-1
Received: by mail-pl1-f172.google.com with SMTP id
 d9443c01a7336-1a677dffb37so21370745ad.2
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 15:12:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681855950; x=1684447950;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=zjwbO5gtYbaRUbN/ugVIqmiHFy9zDkcoTLH4vTn0XJc=;
 b=MCZ8BHFxnU1A0bmoBKm68pHcV8wgyV0r/M23FsIvzmFqYRYX0CTPQr655F8FcpEXTq
 WssI2iqM0pChw8TSJWiVy+m6LVaObYcDtHT1NM+TwMztSdHZ1xR2zwWILlOCqXKy0O1T
 Df/ga79x9Cdff7sEk5XAuUtt0K3tpiPwlw1k6GC/evW0OygU7W8MiInS7g6+lZxUtr3x
 wEIDhjw4ZqXTc/msW8ZoATt8Y5wL7+3gj18PUilMS22hqeLADVUSqn4pVB0FYVI9Id6J
 zqpnojMzLIsKZH2MZqjYqSIxKXpUrUgkYMiE6uHfmle4tUiSlyrC+Yagy1zJ3/pEfQbz
 SBUA==
X-Gm-Message-State: AAQBX9fSruOJrj1kE+1ExFnsjni2WeWxSWLODx1Pbkew6THoLCw1y8TF
 qjwibDB30mUFeB4vBNuvqAeTmkYiR6yEy4GnesQ=
X-Google-Smtp-Source: AKy350YThVGxHlyYdVI/SUYlRWdd4gDm9lz+VRPscqwbPPGzAHFw963gsmjUfZCh89hOUl4tj8BnYA==
X-Received: by 2002:a17:902:f309:b0:1a5:29b7:b745 with SMTP id
 c9-20020a170902f30900b001a529b7b745mr3010104ple.32.1681855950194; 
 Tue, 18 Apr 2023 15:12:30 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com
 ([2620:15c:9d:200:e38b:ca5e:3203:48d3])
 by smtp.gmail.com with ESMTPSA id
 x1-20020a1709029a4100b001a687c505e9sm9911892plv.237.2023.04.18.15.12.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Apr 2023 15:12:29 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Tue, 18 Apr 2023 15:12:05 -0700
Message-ID: <20230418221207.244685-3-sarthakkukreti@chromium.org>
In-Reply-To: <20230418221207.244685-1-sarthakkukreti@chromium.org>
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Wed, 19 Apr 2023 03:55:32 +0000
Subject: [dm-devel] [PATCH v4 2/4] dm: Add block provisioning support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add block provisioning support for device-mapper targets.
dm-crypt, dm-snap and dm-linear will, by default, passthrough
REQ_OP_PROVISION requests to the underlying device, if
supported.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 drivers/md/dm-crypt.c         |  5 ++++-
 drivers/md/dm-linear.c        |  2 ++
 drivers/md/dm-snap.c          |  8 ++++++++
 drivers/md/dm-table.c         | 23 +++++++++++++++++++++++
 drivers/md/dm.c               |  6 ++++++
 include/linux/device-mapper.h | 17 +++++++++++++++++
 6 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8b47b913ee83..aa8072d6d7bf 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3336,6 +3336,9 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		cc->tag_pool_max_sectors <<= cc->sector_shift;
 	}
 
+	ti->num_provision_bios = 1;
+	ti->provision_supported = true;
+
 	ret = -ENOMEM;
 	cc->io_queue = alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM, 1, devname);
 	if (!cc->io_queue) {
@@ -3390,7 +3393,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	 * - for REQ_OP_DISCARD caller must use flush if IO ordering matters
 	 */
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH ||
-	    bio_op(bio) == REQ_OP_DISCARD)) {
+	    bio_op(bio) == REQ_OP_DISCARD || bio_op(bio) == REQ_OP_PROVISION)) {
 		bio_set_dev(bio, cc->dev->bdev);
 		if (bio_sectors(bio))
 			bio->bi_iter.bi_sector = cc->start +
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index f4448d520ee9..66e50f5b0665 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -62,6 +62,8 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->num_provision_bios = 1;
+	ti->provision_supported = true;
 	ti->private = lc;
 	return 0;
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 9c49f53760d0..07927bb1e711 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1358,6 +1358,8 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (s->discard_zeroes_cow)
 		ti->num_discard_bios = (s->discard_passdown_origin ? 2 : 1);
 	ti->per_io_data_size = sizeof(struct dm_snap_tracked_chunk);
+	ti->num_provision_bios = 1;
+	ti->provision_supported = true;
 
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
@@ -2003,6 +2005,11 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	/* If the block is already remapped - use that, else remap it */
 	e = dm_lookup_exception(&s->complete, chunk);
 	if (e) {
+		if (unlikely(bio_op(bio) == REQ_OP_PROVISION)) {
+			bio_endio(bio);
+			r = DM_MAPIO_SUBMITTED;
+			goto out_unlock;
+		}
 		remap_exception(s, e, bio, chunk);
 		if (unlikely(bio_op(bio) == REQ_OP_DISCARD) &&
 		    io_overlaps_chunk(s, bio)) {
@@ -2413,6 +2420,7 @@ static void snapshot_io_hints(struct dm_target *ti, struct queue_limits *limits)
 		/* All discards are split on chunk_size boundary */
 		limits->discard_granularity = snap->store->chunk_size;
 		limits->max_discard_sectors = snap->store->chunk_size;
+		limits->max_provision_sectors = snap->store->chunk_size;
 
 		up_read(&_origins_lock);
 	}
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 119db5e01080..9301f050529f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1854,6 +1854,26 @@ static bool dm_table_supports_write_zeroes(struct dm_table *t)
 	return true;
 }
 
+static int device_provision_capable(struct dm_target *ti, struct dm_dev *dev,
+				    sector_t start, sector_t len, void *data)
+{
+	return !bdev_max_provision_sectors(dev->bdev);
+}
+
+static bool dm_table_supports_provision(struct dm_table *t)
+{
+	for (unsigned int i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = dm_table_get_target(t, i);
+
+		if (ti->provision_supported ||
+		    (ti->type->iterate_devices &&
+		    ti->type->iterate_devices(ti, device_provision_capable, NULL)))
+			return true;
+	}
+
+	return false;
+}
+
 static int device_not_nowait_capable(struct dm_target *ti, struct dm_dev *dev,
 				     sector_t start, sector_t len, void *data)
 {
@@ -1987,6 +2007,9 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (!dm_table_supports_write_zeroes(t))
 		q->limits.max_write_zeroes_sectors = 0;
 
+	if (!dm_table_supports_provision(t))
+		q->limits.max_provision_sectors = 0;
+
 	dm_table_verify_integrity(t);
 
 	/*
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3b694ba3a106..9b94121b8d38 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1609,6 +1609,7 @@ static bool is_abnormal_io(struct bio *bio)
 		case REQ_OP_DISCARD:
 		case REQ_OP_SECURE_ERASE:
 		case REQ_OP_WRITE_ZEROES:
+		case REQ_OP_PROVISION:
 			return true;
 		default:
 			break;
@@ -1641,6 +1642,11 @@ static blk_status_t __process_abnormal_io(struct clone_info *ci,
 		if (ti->max_write_zeroes_granularity)
 			max_granularity = limits->max_write_zeroes_sectors;
 		break;
+	case REQ_OP_PROVISION:
+		num_bios = ti->num_provision_bios;
+		if (ti->max_provision_granularity)
+			max_granularity = limits->max_provision_sectors;
+		break;
 	default:
 		break;
 	}
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a52d2b9a6846..9981378457d2 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -334,6 +334,12 @@ struct dm_target {
 	 */
 	unsigned int num_write_zeroes_bios;
 
+	/*
+	 * The number of PROVISION bios that will be submitted to the target.
+	 * The bio number can be accessed with dm_bio_get_target_bio_nr.
+	 */
+	unsigned int num_provision_bios;
+
 	/*
 	 * The minimum number of extra bytes allocated in each io for the
 	 * target to use.
@@ -358,6 +364,11 @@ struct dm_target {
 	 */
 	bool discards_supported:1;
 
+	/* Set if this target needs to receive provision requests regardless of
+	 * whether or not its underlying devices have support.
+	 */
+	bool provision_supported:1;
+
 	/*
 	 * Set if this target requires that discards be split on
 	 * 'max_discard_sectors' boundaries.
@@ -376,6 +387,12 @@ struct dm_target {
 	 */
 	bool max_write_zeroes_granularity:1;
 
+	/*
+	 * Set if this target requires that provisions be split on
+	 * 'max_provision_sectors' boundaries.
+	 */
+	bool max_provision_granularity:1;
+
 	/*
 	 * Set if we need to limit the number of in-flight bios when swapping.
 	 */
-- 
2.40.0.634.g4ca3ef3211-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

