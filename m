Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A89EC6FA8B
	for <dm-devel@archiver.kernel.org>; Fri, 16 Sep 2022 08:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663317909;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=r3sqFfLnhWGBHCwviv5AnIp0Tiiy75CfUXapn6AIfnw=;
	b=ErIaogouvttoxvGpkxmJSS4sCS3oj4FGKlfr8c9F6ps0f1xe1F3yR5HshYrDPpS3RarEdT
	HvMj0s1/sK8GyFfsROkczHnSpTU/eC2pxPuBYwhrXqweBsHfOfx6I7QifQi+CwDm8VNg0J
	kzJWIqt2ncyUAbdLBYJcX4F2UOCKLLQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-LBvFMZZhP8unLldzWky5yw-1; Fri, 16 Sep 2022 04:45:04 -0400
X-MC-Unique: LBvFMZZhP8unLldzWky5yw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 340E3382F1B9;
	Fri, 16 Sep 2022 08:45:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 206952166B29;
	Fri, 16 Sep 2022 08:45:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A7B911946595;
	Fri, 16 Sep 2022 08:44:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B2541946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Sep 2022 16:48:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5EFD917595; Thu, 15 Sep 2022 16:48:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B22910EB8
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 16:48:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B577185A794
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 16:48:46 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-363-T8QfQyqqMCSw1_YljHHU4g-1; Thu, 15 Sep 2022 12:48:44 -0400
X-MC-Unique: T8QfQyqqMCSw1_YljHHU4g-1
Received: by mail-pj1-f48.google.com with SMTP id
 s14-20020a17090a6e4e00b0020057c70943so22964631pjm.1
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 09:48:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date;
 bh=5ygvmrZPI1WDIMPoH4fryGIYobUzr2vUUota+pvSXgQ=;
 b=2Wo0kVAi3W+OWnDDPYYnDdpe+6P/sKfKFB2NpwaUeG26kkatMTOhjjtR6lZt1nbOWw
 1QCVx4czsSufGHM0OqFLWhwQ57PkPLSeNc61SWaqJ1nTMjnjB4/Taa3FQsJ7c+mq2Ypo
 7m1JfYMGiBZGNbBzJtXuDYZhAx/ZnR3xKmRgcivLiEDPeWKWHn+RXaJc8qTuqhlemHgE
 D2MLJ9IPnum2umcNjH7oMXurVJ6wHx4LWIEfgsWHvTzMcR7os0DJk7YYni8oVaXgWVQx
 SsF4UcuUW1m17mqiA4yr1HJfAPjcl8tw0Sx3+/woFWYRjuv2CqshsQYcRd4GWU+yR/Ab
 foPQ==
X-Gm-Message-State: ACrzQf3c0OwinVa9VL8tNB9RFTZl6fgreJQbVR3NJsA6qWoJ2VGT6ZJT
 6fiaAI+Nm53pPuV5vTWcC70Ze/EiGWFxIQ==
X-Google-Smtp-Source: AMsMyM7uREf6rExESlC9UOz0czMJ3vqna+akFJyuGIrevbbq1rAo01SAxEamvT9aPhybE8cjhGavpQ==
X-Received: by 2002:a17:90b:4f8d:b0:202:dd39:c03a with SMTP id
 qe13-20020a17090b4f8d00b00202dd39c03amr11917187pjb.71.1663260522760; 
 Thu, 15 Sep 2022 09:48:42 -0700 (PDT)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:3af2:34b2:a98a:a652])
 by smtp.gmail.com with ESMTPSA id
 o4-20020a170902bcc400b00177ee563b6dsm13174970pls.33.2022.09.15.09.48.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 15 Sep 2022 09:48:41 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
X-Google-Original-From: Sarthak Kukreti <sarthakkukreti@google.com>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org
Date: Thu, 15 Sep 2022 09:48:20 -0700
Message-Id: <20220915164826.1396245-3-sarthakkukreti@google.com>
In-Reply-To: <20220915164826.1396245-1-sarthakkukreti@google.com>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Fri, 16 Sep 2022 08:44:55 +0000
Subject: [dm-devel] [PATCH RFC 2/8] dm: Add support for block provisioning
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, Sarthak Kukreti <sarthakkukreti@chromium.org>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 Evan Green <evgreen@google.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Sarthak Kukreti <sarthakkukreti@chromium.org>

Add support to dm devices for REQ_OP_PROVISION. The default mode
is to pass through the request and dm-thin will utilize it to provision
blocks.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 drivers/md/dm-crypt.c         |  4 +-
 drivers/md/dm-linear.c        |  1 +
 drivers/md/dm-table.c         | 17 +++++++
 drivers/md/dm-thin.c          | 86 +++++++++++++++++++++++++++++++++--
 drivers/md/dm.c               |  4 ++
 include/linux/device-mapper.h |  6 +++
 6 files changed, 113 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 159c6806c19b..357f0899cfb6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3081,6 +3081,8 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 	if (ret)
 		return ret;
 
+	ti->num_provision_bios = 1;
+
 	while (opt_params--) {
 		opt_string = dm_shift_arg(&as);
 		if (!opt_string) {
@@ -3384,7 +3386,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	 * - for REQ_OP_DISCARD caller must use flush if IO ordering matters
 	 */
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH ||
-	    bio_op(bio) == REQ_OP_DISCARD)) {
+	    bio_op(bio) == REQ_OP_DISCARD || bio_op(bio) == REQ_OP_PROVISION)) {
 		bio_set_dev(bio, cc->dev->bdev);
 		if (bio_sectors(bio))
 			bio->bi_iter.bi_sector = cc->start +
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 3212ef6aa81b..1aa782149428 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -61,6 +61,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->num_provision_bios = 1;
 	ti->private = lc;
 	return 0;
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 332f96b58252..b7f9cb66b7ba 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1853,6 +1853,18 @@ static bool dm_table_supports_write_zeroes(struct dm_table *t)
 	return true;
 }
 
+static bool dm_table_supports_provision(struct dm_table *t)
+{
+	for (unsigned int i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = dm_table_get_target(t, i);
+
+		if (ti->num_provision_bios)
+			return true;
+	}
+
+	return false;
+}
+
 static int device_not_nowait_capable(struct dm_target *ti, struct dm_dev *dev,
 				     sector_t start, sector_t len, void *data)
 {
@@ -1989,6 +2001,11 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (!dm_table_supports_write_zeroes(t))
 		q->limits.max_write_zeroes_sectors = 0;
 
+	if (dm_table_supports_provision(t))
+		blk_queue_max_provision_sectors(q, UINT_MAX >> 9);
+	else
+		q->limits.max_provision_sectors = 0;
+
 	dm_table_verify_integrity(t);
 
 	/*
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e76c96c760a9..fd3eb306c823 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -908,7 +908,8 @@ static void __inc_remap_and_issue_cell(void *context,
 	struct bio *bio;
 
 	while ((bio = bio_list_pop(&cell->bios))) {
-		if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD)
+		if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD ||
+		    bio_op(bio) == REQ_OP_PROVISION)
 			bio_list_add(&info->defer_bios, bio);
 		else {
 			inc_all_io_entry(info->tc->pool, bio);
@@ -1012,6 +1013,9 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 		goto out;
 	}
 
+	if (bio && bio_op(bio) == REQ_OP_PROVISION)
+		return;
+
 	/*
 	 * Release any bios held while the block was being provisioned.
 	 * If we are processing a write bio that completely covers the block,
@@ -1388,6 +1392,9 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	m->data_block = data_block;
 	m->cell = cell;
 
+	if (bio && bio_op(bio) == REQ_OP_PROVISION)
+		m->bio = bio;
+
 	/*
 	 * If the whole block of data is being overwritten or we are not
 	 * zeroing pre-existing data, we can issue the bio immediately.
@@ -1897,7 +1904,7 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	/*
 	 * Fill read bios with zeroes and complete them immediately.
 	 */
-	if (bio_data_dir(bio) == READ) {
+	if (bio_data_dir(bio) == READ && bio_op(bio) != REQ_OP_PROVISION) {
 		zero_fill_bio(bio);
 		cell_defer_no_holder(tc, cell);
 		bio_endio(bio);
@@ -1980,6 +1987,69 @@ static void process_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
 	}
 }
 
+static void process_provision_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
+{
+	int r;
+	struct pool *pool = tc->pool;
+	struct bio *bio = cell->holder;
+	dm_block_t begin, end;
+	struct dm_thin_lookup_result lookup_result;
+
+	if (tc->requeue_mode) {
+		cell_requeue(pool, cell);
+		return;
+	}
+
+	get_bio_block_range(tc, bio, &begin, &end);
+
+	while (begin != end) {
+		r = ensure_next_mapping(pool);
+		if (r)
+			/* we did our best */
+			return;
+
+		r = dm_thin_find_block(tc->td, begin, 1, &lookup_result);
+		switch (r) {
+		case 0:
+			begin++;
+			break;
+		case -ENODATA:
+			provision_block(tc, bio, begin, cell);
+			begin++;
+			break;
+		default:
+			DMERR_LIMIT(
+				"%s: dm_thin_find_block() failed: error = %d",
+				__func__, r);
+			cell_defer_no_holder(tc, cell);
+			bio_io_error(bio);
+			begin++;
+			break;
+		}
+	}
+	bio_endio(bio);
+	cell_defer_no_holder(tc, cell);
+}
+
+static void process_provision_bio(struct thin_c *tc, struct bio *bio)
+{
+	dm_block_t begin, end;
+	struct dm_cell_key virt_key;
+	struct dm_bio_prison_cell *virt_cell;
+
+	get_bio_block_range(tc, bio, &begin, &end);
+	if (begin == end) {
+		bio_endio(bio);
+		return;
+	}
+
+	build_key(tc->td, VIRTUAL, begin, end, &virt_key);
+	if (bio_detain(tc->pool, &virt_key, bio, &virt_cell))
+		return;
+
+	process_provision_cell(tc, virt_cell);
+}
+
 static void process_bio(struct thin_c *tc, struct bio *bio)
 {
 	struct pool *pool = tc->pool;
@@ -2024,7 +2094,7 @@ static void __process_bio_read_only(struct thin_c *tc, struct bio *bio,
 	case -ENODATA:
 		if (cell)
 			cell_defer_no_holder(tc, cell);
-		if (rw != READ) {
+		if (rw != READ || bio_op(bio) == REQ_OP_PROVISION) {
 			handle_unserviceable_bio(tc->pool, bio);
 			break;
 		}
@@ -2200,6 +2270,8 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 
 		if (bio_op(bio) == REQ_OP_DISCARD)
 			pool->process_discard(tc, bio);
+		else if (bio_op(bio) == REQ_OP_PROVISION)
+			process_provision_bio(tc, bio);
 		else
 			pool->process_bio(tc, bio);
 
@@ -2716,7 +2788,8 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_SUBMITTED;
 	}
 
-	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD) {
+	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD ||
+	    bio_op(bio) == REQ_OP_PROVISION) {
 		thin_defer_bio_with_throttle(tc, bio);
 		return DM_MAPIO_SUBMITTED;
 	}
@@ -3353,6 +3426,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	pt->low_water_blocks = low_water_blocks;
 	pt->adjusted_pf = pt->requested_pf = pf;
 	ti->num_flush_bios = 1;
+	ti->num_provision_bios = 1;
 
 	/*
 	 * Only need to enable discards if the pool should pass
@@ -4043,6 +4117,7 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 		blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
 	}
 
+
 	/*
 	 * pt->adjusted_pf is a staging area for the actual features to use.
 	 * They get transferred to the live pool in bind_control_target()
@@ -4233,6 +4308,8 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		ti->num_discard_bios = 1;
 	}
 
+	ti->num_provision_bios = 1;
+
 	mutex_unlock(&dm_thin_pool_table.mutex);
 
 	spin_lock_irq(&tc->pool->lock);
@@ -4447,6 +4524,7 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
 	limits->max_discard_sectors = 2048 * 1024 * 16; /* 16G */
+	limits->max_provision_sectors = 2048 * 1024 * 16; /* 16G */
 }
 
 static struct target_type thin_target = {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 60549b65c799..3fe524800f5a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1600,6 +1600,7 @@ static bool is_abnormal_io(struct bio *bio)
 		case REQ_OP_DISCARD:
 		case REQ_OP_SECURE_ERASE:
 		case REQ_OP_WRITE_ZEROES:
+		case REQ_OP_PROVISION:
 			return true;
 		default:
 			break;
@@ -1624,6 +1625,9 @@ static blk_status_t __process_abnormal_io(struct clone_info *ci,
 	case REQ_OP_WRITE_ZEROES:
 		num_bios = ti->num_write_zeroes_bios;
 		break;
+	case REQ_OP_PROVISION:
+		num_bios = ti->num_provision_bios;
+		break;
 	default:
 		break;
 	}
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 04c6acf7faaa..edeb47195b6f 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -333,6 +333,12 @@ struct dm_target {
 	 */
 	unsigned num_write_zeroes_bios;
 
+	/*
+	 * The number of PROVISION bios that will be submitted to the target.
+	 * The bio number can be accessed with dm_bio_get_target_bio_nr.
+	 */
+	unsigned num_provision_bios;
+
 	/*
 	 * The minimum number of extra bytes allocated in each io for the
 	 * target to use.
-- 
2.31.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

