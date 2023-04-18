Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE1BFC77B78
	for <dm-devel@archiver.kernel.org>; Wed, 19 Apr 2023 03:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681876550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8dguhifIm7Hq0LnmrOd8zKVizeuscqOGTHMu1+9vM94=;
	b=Dv4ly//Smli7i6//MAuquV28LSjkuJGCgc5BfL8oMoNDbxqL1O7vnt1JT2ZJ5CJQDEo1Np
	qNOT+F9BOZYwtwjxvUkHJlCkofuB8dfMz/1BaZlzYKI7wghL0UNbVg4dy2IKLoPRNGlWRd
	O3CWHwrS9wf1O0Dr5mV6c6S3t4L68ts=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-AOd1-FEYMPSFJJ9By7YnJQ-1; Tue, 18 Apr 2023 23:55:47 -0400
X-MC-Unique: AOd1-FEYMPSFJJ9By7YnJQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A81E1C0690F;
	Wed, 19 Apr 2023 03:55:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 369E5C15BAD;
	Wed, 19 Apr 2023 03:55:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6DD081946A48;
	Wed, 19 Apr 2023 03:55:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 77AC5194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Apr 2023 22:12:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5CE74C15BAE; Tue, 18 Apr 2023 22:12:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 55D10C15BAD
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 22:12:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37875185A790
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 22:12:35 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-c5LEb6KpOO2k18qI4hm8lg-2; Tue, 18 Apr 2023 18:12:33 -0400
X-MC-Unique: c5LEb6KpOO2k18qI4hm8lg-2
Received: by mail-pl1-f173.google.com with SMTP id
 d9443c01a7336-1a6670671e3so22857305ad.0
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 15:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681855952; x=1684447952;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=TaRkZLFdq6iB8YT++07ypsMh1Ei2+nMtmkI0wjjAr+E=;
 b=MnJCSAcUrbsOUxdfztUEpb3abnf0IODC48LeKsnsdRRITWeff+BSc8jINvIwb5F0Xm
 VsU4IxiWfZCJFrReR6yYOXkdC86LikVAmlNp9WdxfRWFnRm53FqHMIlyuv630ZCHZESG
 7DIpwQmrC6qEk6feO7SAKVjlDMzRjZycwxvG/fc/ZYQio/ILl893XWKW0EYDBTsT2kS5
 PYSw/yvKclSSLakeTj8cTghwfYp8qadF+gnuj4YsErBuPWnLUmUGY0YtDV9DK72Mg7h4
 1BQARLQihdWkOvkw6rSY69oc8SViV+jO0Tmh6XGFLXS3OIzy+9doQoNAFKx0CQ4nvu6w
 S3aA==
X-Gm-Message-State: AAQBX9ffO+mLCXt7VREsU3LXtkxBoBRPhQKPvj4LMOS2qu4CibCRat39
 qcScFUhq9fonCBb8eJOe0jBGbpjIo1jqkrPpX0I=
X-Google-Smtp-Source: AKy350ZNl1P6gh+h3LisQBWkv2V6BS3Dybx8F/XFSOU7jDsCn71Yzyg3gK6TDeF5J2qCV9WWeruX4A==
X-Received: by 2002:a17:903:230c:b0:1a8:d7a:9248 with SMTP id
 d12-20020a170903230c00b001a80d7a9248mr2391802plh.41.1681855952618; 
 Tue, 18 Apr 2023 15:12:32 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com
 ([2620:15c:9d:200:e38b:ca5e:3203:48d3])
 by smtp.gmail.com with ESMTPSA id
 x1-20020a1709029a4100b001a687c505e9sm9911892plv.237.2023.04.18.15.12.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Apr 2023 15:12:32 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Tue, 18 Apr 2023 15:12:06 -0700
Message-ID: <20230418221207.244685-4-sarthakkukreti@chromium.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 19 Apr 2023 03:55:32 +0000
Subject: [dm-devel] [PATCH v4 3/4] dm-thin: Add REQ_OP_PROVISION support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm-thinpool uses the provision request to provision
blocks for a dm-thin device. dm-thinpool currently does not
pass through REQ_OP_PROVISION to underlying devices.

For shared blocks, provision requests will break sharing and copy the
contents of the entire block. Additionally, if 'skip_block_zeroing'
is not set, dm-thin will opt to zero out the entire range as a part
of provisioning.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 drivers/md/dm-thin.c | 73 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 2b13c949bd72..58d633f5c928 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -274,6 +274,7 @@ struct pool {
 
 	process_bio_fn process_bio;
 	process_bio_fn process_discard;
+	process_bio_fn process_provision;
 
 	process_cell_fn process_cell;
 	process_cell_fn process_discard_cell;
@@ -913,7 +914,8 @@ static void __inc_remap_and_issue_cell(void *context,
 	struct bio *bio;
 
 	while ((bio = bio_list_pop(&cell->bios))) {
-		if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD)
+		if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD ||
+		    bio_op(bio) == REQ_OP_PROVISION)
 			bio_list_add(&info->defer_bios, bio);
 		else {
 			inc_all_io_entry(info->tc->pool, bio);
@@ -1245,8 +1247,8 @@ static int io_overlaps_block(struct pool *pool, struct bio *bio)
 
 static int io_overwrites_block(struct pool *pool, struct bio *bio)
 {
-	return (bio_data_dir(bio) == WRITE) &&
-		io_overlaps_block(pool, bio);
+	return (bio_data_dir(bio) == WRITE) && io_overlaps_block(pool, bio) &&
+	       bio_op(bio) != REQ_OP_PROVISION;
 }
 
 static void save_and_set_endio(struct bio *bio, bio_end_io_t **save,
@@ -1891,7 +1893,8 @@ static void process_shared_bio(struct thin_c *tc, struct bio *bio,
 
 	if (bio_data_dir(bio) == WRITE && bio->bi_iter.bi_size) {
 		break_sharing(tc, bio, block, &key, lookup_result, data_cell);
-		cell_defer_no_holder(tc, virt_cell);
+		if (bio_op(bio) != REQ_OP_PROVISION)
+			cell_defer_no_holder(tc, virt_cell);
 	} else {
 		struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
 
@@ -1953,6 +1956,51 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	}
 }
 
+static void process_provision_bio(struct thin_c *tc, struct bio *bio)
+{
+	int r;
+	struct pool *pool = tc->pool;
+	dm_block_t block = get_bio_block(tc, bio);
+	struct dm_bio_prison_cell *cell;
+	struct dm_cell_key key;
+	struct dm_thin_lookup_result lookup_result;
+
+	/*
+	 * If cell is already occupied, then the block is already
+	 * being provisioned so we have nothing further to do here.
+	 */
+	build_virtual_key(tc->td, block, &key);
+	if (bio_detain(pool, &key, bio, &cell))
+		return;
+
+	if (tc->requeue_mode) {
+		cell_requeue(pool, cell);
+		return;
+	}
+
+	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
+	switch (r) {
+	case 0:
+		if (lookup_result.shared) {
+			process_shared_bio(tc, bio, block, &lookup_result, cell);
+		} else {
+			bio_endio(bio);
+			cell_defer_no_holder(tc, cell);
+		}
+		break;
+	case -ENODATA:
+		provision_block(tc, bio, block, cell);
+		break;
+
+	default:
+		DMERR_LIMIT("%s: dm_thin_find_block() failed: error = %d",
+			    __func__, r);
+		cell_defer_no_holder(tc, cell);
+		bio_io_error(bio);
+		break;
+	}
+}
+
 static void process_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
 {
 	int r;
@@ -2228,6 +2276,8 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 
 		if (bio_op(bio) == REQ_OP_DISCARD)
 			pool->process_discard(tc, bio);
+		else if (bio_op(bio) == REQ_OP_PROVISION)
+			pool->process_provision(tc, bio);
 		else
 			pool->process_bio(tc, bio);
 
@@ -2579,6 +2629,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		dm_pool_metadata_read_only(pool->pmd);
 		pool->process_bio = process_bio_fail;
 		pool->process_discard = process_bio_fail;
+		pool->process_provision = process_bio_fail;
 		pool->process_cell = process_cell_fail;
 		pool->process_discard_cell = process_cell_fail;
 		pool->process_prepared_mapping = process_prepared_mapping_fail;
@@ -2592,6 +2643,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		dm_pool_metadata_read_only(pool->pmd);
 		pool->process_bio = process_bio_read_only;
 		pool->process_discard = process_bio_success;
+		pool->process_provision = process_bio_fail;
 		pool->process_cell = process_cell_read_only;
 		pool->process_discard_cell = process_cell_success;
 		pool->process_prepared_mapping = process_prepared_mapping_fail;
@@ -2612,6 +2664,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		pool->out_of_data_space = true;
 		pool->process_bio = process_bio_read_only;
 		pool->process_discard = process_discard_bio;
+		pool->process_provision = process_bio_fail;
 		pool->process_cell = process_cell_read_only;
 		pool->process_prepared_mapping = process_prepared_mapping;
 		set_discard_callbacks(pool);
@@ -2628,6 +2681,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		dm_pool_metadata_read_write(pool->pmd);
 		pool->process_bio = process_bio;
 		pool->process_discard = process_discard_bio;
+		pool->process_provision = process_provision_bio;
 		pool->process_cell = process_cell;
 		pool->process_prepared_mapping = process_prepared_mapping;
 		set_discard_callbacks(pool);
@@ -2749,7 +2803,8 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_SUBMITTED;
 	}
 
-	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD) {
+	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD ||
+	    bio_op(bio) == REQ_OP_PROVISION) {
 		thin_defer_bio_with_throttle(tc, bio);
 		return DM_MAPIO_SUBMITTED;
 	}
@@ -3396,6 +3451,9 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	pt->adjusted_pf = pt->requested_pf = pf;
 	ti->num_flush_bios = 1;
 	ti->limit_swap_bios = true;
+	ti->num_provision_bios = 1;
+	ti->provision_supported = true;
+	ti->max_provision_granularity = true;
 
 	/*
 	 * Only need to enable discards if the pool should pass
@@ -4288,6 +4346,9 @@ static int thin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->max_discard_granularity = true;
 	}
 
+	ti->num_provision_bios = 1;
+	ti->provision_supported = true;
+
 	mutex_unlock(&dm_thin_pool_table.mutex);
 
 	spin_lock_irq(&tc->pool->lock);
@@ -4502,6 +4563,8 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
 	limits->max_discard_sectors = pool->sectors_per_block * BIO_PRISON_MAX_RANGE;
+
+	limits->max_provision_sectors = pool->sectors_per_block;
 }
 
 static struct target_type thin_target = {
-- 
2.40.0.634.g4ca3ef3211-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

