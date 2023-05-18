Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95829C77B7A
	for <dm-devel@archiver.kernel.org>; Thu, 18 May 2023 22:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684449245;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hPveWhmrD+s23f31o8l7XR18GKKWi677JDbRA2GH0P4=;
	b=Nvhe2zi5okTNa5os5moD0H2cMjo3fgyRHid+WxAAgM6MqhFZHXizigSW0UB2EaPYOAf9pu
	6UPD/CJKtMTd9a46564IzXQUm7J4MaWkcB6zEXceo1Hyo41mjOeowK8dL/ysroAMtdXWGr
	VzN+sAeQ9C93h8qOsHEI6elkcImBLJk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-32R0U9PZN5-ZRy2J0OsyKQ-1; Thu, 18 May 2023 18:34:02 -0400
X-MC-Unique: 32R0U9PZN5-ZRy2J0OsyKQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81417299E765;
	Thu, 18 May 2023 22:34:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E02040C6EC4;
	Thu, 18 May 2023 22:34:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5430319465B2;
	Thu, 18 May 2023 22:34:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 923C319465A4
 for <dm-devel@listman.corp.redhat.com>; Thu, 18 May 2023 22:33:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 851BB63F9A; Thu, 18 May 2023 22:33:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D35263F5F
 for <dm-devel@redhat.com>; Thu, 18 May 2023 22:33:59 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E563870833
 for <dm-devel@redhat.com>; Thu, 18 May 2023 22:33:59 +0000 (UTC)
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com
 [209.85.210.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-sW7ew3FJNJipvt7B81CEFA-1; Thu, 18 May 2023 18:33:57 -0400
X-MC-Unique: sW7ew3FJNJipvt7B81CEFA-1
Received: by mail-pf1-f174.google.com with SMTP id
 d2e1a72fcca58-643990c5319so1898254b3a.2
 for <dm-devel@redhat.com>; Thu, 18 May 2023 15:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684449236; x=1687041236;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=zm9KFPuB6bZdPEt5ywklKgC04Y1roJ5KGT6m6yDSM9c=;
 b=Xzgdf04ioHr+36m2H9rhf8hekwR6VgrLCCAQ9VyiK7rz8hI98+QtExuOZZo7Ib3keV
 jlG6u7MY6M0OfndTFvsRXIal0EFyar7/+fAQQzJvMzndye8PoF4/T61jq4J7T205EqpC
 utRajr1d2SqRWnfUi+vr03ASbMkJC0mFxHxPCmQAK8YjU2JCPgYnCwVpMmdCx2K0gmOz
 wE9+lhAGCVlkK/bhPCDYT9yy7y3XP7qTLYwZxHJ3U69BUO8IlzhUcnFBDpbpsw5ZKdSm
 ct00hG1P3POO+yWWmBtZnhyzEc1VfE7cCfpZbn6gV2yeniy9niYYhaAz6jGGT2CGyln7
 dUZA==
X-Gm-Message-State: AC+VfDx3M9OBhEANp5UVlO0NebzeZyrhHxCO6VXqI0FbjZFN2W1lllIb
 aCaMDYXFCKeYK7qwvQ0vmMjpt3/CbbGnwSRaMzcmsQ==
X-Google-Smtp-Source: ACHHUZ7VpBcD+VQBtKXGBQBwb8EinggyxyYEJ7xx416fDkKt0EPx4x5EXrHM8kavrKqdYKO41ivKAw==
X-Received: by 2002:a17:903:26d3:b0:1ac:6e1f:d19c with SMTP id
 jg19-20020a17090326d300b001ac6e1fd19cmr578638plb.41.1684449236202; 
 Thu, 18 May 2023 15:33:56 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com ([100.107.238.113])
 by smtp.gmail.com with ESMTPSA id
 q4-20020a170902b10400b001aafb802efbsm1996502plr.12.2023.05.18.15.33.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 May 2023 15:33:55 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Thu, 18 May 2023 15:33:24 -0700
Message-ID: <20230518223326.18744-4-sarthakkukreti@chromium.org>
In-Reply-To: <20230518223326.18744-1-sarthakkukreti@chromium.org>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v7 3/5] dm: Add block provisioning support
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
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
 drivers/md/dm-crypt.c         |  4 +++-
 drivers/md/dm-linear.c        |  1 +
 drivers/md/dm-snap.c          |  7 +++++++
 drivers/md/dm-table.c         | 23 +++++++++++++++++++++++
 drivers/md/dm.c               |  6 ++++++
 include/linux/device-mapper.h | 17 +++++++++++++++++
 6 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8b47b913ee83..5a7c475ce6fc 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3336,6 +3336,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		cc->tag_pool_max_sectors <<= cc->sector_shift;
 	}
 
+	ti->num_provision_bios = 1;
+
 	ret = -ENOMEM;
 	cc->io_queue = alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM, 1, devname);
 	if (!cc->io_queue) {
@@ -3390,7 +3392,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	 * - for REQ_OP_DISCARD caller must use flush if IO ordering matters
 	 */
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH ||
-	    bio_op(bio) == REQ_OP_DISCARD)) {
+	    bio_op(bio) == REQ_OP_DISCARD || bio_op(bio) == REQ_OP_PROVISION)) {
 		bio_set_dev(bio, cc->dev->bdev);
 		if (bio_sectors(bio))
 			bio->bi_iter.bi_sector = cc->start +
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index f4448d520ee9..74ee27ca551a 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->num_provision_bios = 1;
 	ti->private = lc;
 	return 0;
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 9c49f53760d0..0dfda50ac4e0 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1358,6 +1358,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (s->discard_zeroes_cow)
 		ti->num_discard_bios = (s->discard_passdown_origin ? 2 : 1);
 	ti->per_io_data_size = sizeof(struct dm_snap_tracked_chunk);
+	ti->num_provision_bios = 1;
 
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
@@ -2003,6 +2004,11 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
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
@@ -2413,6 +2419,7 @@ static void snapshot_io_hints(struct dm_target *ti, struct queue_limits *limits)
 		/* All discards are split on chunk_size boundary */
 		limits->discard_granularity = snap->store->chunk_size;
 		limits->max_discard_sectors = snap->store->chunk_size;
+		limits->max_provision_sectors = snap->store->chunk_size;
 
 		up_read(&_origins_lock);
 	}
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 1398f1d6e83e..4b2998c1e1dc 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1845,6 +1845,26 @@ static bool dm_table_supports_write_zeroes(struct dm_table *t)
 	return true;
 }
 
+static int device_provision_capable(struct dm_target *ti, struct dm_dev *dev,
+				    sector_t start, sector_t len, void *data)
+{
+	return bdev_max_provision_sectors(dev->bdev);
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
@@ -1978,6 +1998,9 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
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
2.40.1.698.g37aff9b760-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

