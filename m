Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B3EC77B7A
	for <dm-devel@archiver.kernel.org>; Thu, 18 May 2023 22:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684449254;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Q3nfazRzXf6RsrcGdiHILvuqyBEosR3ns/GbWcQD1dY=;
	b=UlQELurqQbUynCuuBrswqUy6DQKQoPz81jmGTgdceXdKimooBhEQ0XG2qUmqNqE60wv/oP
	rd4hKbXKKgJopPyk0SMauZSX0BRFId1IYosZKHNKbfiMkEZ+CjaZ4Dqf3/DdjCjCX7qGrV
	BO6OXqvs2Mbcm0k1xv5TDRf2k2ef+nQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-mfCUoTdBOMifm551gqowbg-1; Thu, 18 May 2023 18:34:11 -0400
X-MC-Unique: mfCUoTdBOMifm551gqowbg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9E9638154F0;
	Thu, 18 May 2023 22:34:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 97D082026D16;
	Thu, 18 May 2023 22:34:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 823BE19465B2;
	Thu, 18 May 2023 22:34:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D290819465A4
 for <dm-devel@listman.corp.redhat.com>; Thu, 18 May 2023 22:34:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C42C5492C3F; Thu, 18 May 2023 22:34:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BCF12492C13
 for <dm-devel@redhat.com>; Thu, 18 May 2023 22:34:08 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A36C01C05EB8
 for <dm-devel@redhat.com>; Thu, 18 May 2023 22:34:08 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-Tb0SjNaDNKijfGbNo4MEgw-1; Thu, 18 May 2023 18:33:59 -0400
X-MC-Unique: Tb0SjNaDNKijfGbNo4MEgw-1
Received: by mail-pl1-f171.google.com with SMTP id
 d9443c01a7336-1ae7033f4e5so1475695ad.1
 for <dm-devel@redhat.com>; Thu, 18 May 2023 15:33:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684449238; x=1687041238;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=o0RjYl/m1xYKkWDD1lX4N49WRpVnJJ8wbKxnpktlyn8=;
 b=VXfDI+LxCRMMcctEHucqcSgO2Ae1oBr48JdabS4wMktDSXW/c0W/Bz0+IzTg0Gf5Y2
 pAoEBCWZEczrqQstyO+9x6c5rR9orDTXX/nAlnokL64mM4PfYqmko38Lx22RvPBnCeCr
 sbHVFjQu6i6RuCH6pMfVWPpLZ3HWMJh6zlmew/Zg+vYnos6iV5jbv8J0vpPzgTJM3auc
 HI81cdToIy2dDW6gOe+V8CK2liCw1s+CaJUpGVNvOTP4035oGc3cy2ABjOoMpZIYi3Yh
 u06nA4kRSVIFw4mcPb+0BilOm6b+35yDnr+DeUW+D4Wy7QnyWg9DX/+cx4DyWKU1ZePO
 +WfQ==
X-Gm-Message-State: AC+VfDwThNTbGJOnvZbN8XTACX4R7+awIuFWfxbcUQ6yloNWwChOzg8K
 BdesJvaKzsICr7q3Y0FMTk44KE6a6lUXVcho7x9XjA==
X-Google-Smtp-Source: ACHHUZ41Mt0LdJYehtesv6pKDnJiDtvVDpBOIv2PtermPkwVmgzJ8wQgFh4PWlilf6vPStsuMKVTig==
X-Received: by 2002:a17:903:2287:b0:1ad:ea13:1914 with SMTP id
 b7-20020a170903228700b001adea131914mr4578158plh.30.1684449237781; 
 Thu, 18 May 2023 15:33:57 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com ([100.107.238.113])
 by smtp.gmail.com with ESMTPSA id
 q4-20020a170902b10400b001aafb802efbsm1996502plr.12.2023.05.18.15.33.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 May 2023 15:33:57 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Thu, 18 May 2023 15:33:25 -0700
Message-ID: <20230518223326.18744-5-sarthakkukreti@chromium.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v7 4/5] dm-thin: Add REQ_OP_PROVISION support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
 drivers/md/dm-thin.c | 74 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 2b13c949bd72..f1b68b558cf0 100644
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
@@ -1394,6 +1396,9 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	m->data_block = data_block;
 	m->cell = cell;
 
+	if (bio && bio_op(bio) == REQ_OP_PROVISION)
+		m->bio = bio;
+
 	/*
 	 * If the whole block of data is being overwritten or we are not
 	 * zeroing pre-existing data, we can issue the bio immediately.
@@ -1953,6 +1958,51 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
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
@@ -2228,6 +2278,8 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 
 		if (bio_op(bio) == REQ_OP_DISCARD)
 			pool->process_discard(tc, bio);
+		else if (bio_op(bio) == REQ_OP_PROVISION)
+			pool->process_provision(tc, bio);
 		else
 			pool->process_bio(tc, bio);
 
@@ -2579,6 +2631,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		dm_pool_metadata_read_only(pool->pmd);
 		pool->process_bio = process_bio_fail;
 		pool->process_discard = process_bio_fail;
+		pool->process_provision = process_bio_fail;
 		pool->process_cell = process_cell_fail;
 		pool->process_discard_cell = process_cell_fail;
 		pool->process_prepared_mapping = process_prepared_mapping_fail;
@@ -2592,6 +2645,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		dm_pool_metadata_read_only(pool->pmd);
 		pool->process_bio = process_bio_read_only;
 		pool->process_discard = process_bio_success;
+		pool->process_provision = process_bio_fail;
 		pool->process_cell = process_cell_read_only;
 		pool->process_discard_cell = process_cell_success;
 		pool->process_prepared_mapping = process_prepared_mapping_fail;
@@ -2612,6 +2666,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		pool->out_of_data_space = true;
 		pool->process_bio = process_bio_read_only;
 		pool->process_discard = process_discard_bio;
+		pool->process_provision = process_bio_fail;
 		pool->process_cell = process_cell_read_only;
 		pool->process_prepared_mapping = process_prepared_mapping;
 		set_discard_callbacks(pool);
@@ -2628,6 +2683,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		dm_pool_metadata_read_write(pool->pmd);
 		pool->process_bio = process_bio;
 		pool->process_discard = process_discard_bio;
+		pool->process_provision = process_provision_bio;
 		pool->process_cell = process_cell;
 		pool->process_prepared_mapping = process_prepared_mapping;
 		set_discard_callbacks(pool);
@@ -2749,7 +2805,8 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_SUBMITTED;
 	}
 
-	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD) {
+	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD ||
+	    bio_op(bio) == REQ_OP_PROVISION) {
 		thin_defer_bio_with_throttle(tc, bio);
 		return DM_MAPIO_SUBMITTED;
 	}
@@ -3396,6 +3453,9 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	pt->adjusted_pf = pt->requested_pf = pf;
 	ti->num_flush_bios = 1;
 	ti->limit_swap_bios = true;
+	ti->num_provision_bios = 1;
+	ti->provision_supported = true;
+	ti->max_provision_granularity = true;
 
 	/*
 	 * Only need to enable discards if the pool should pass
@@ -4094,6 +4154,8 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 		blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
 	}
 
+	limits->max_provision_sectors = pool->sectors_per_block;
+
 	/*
 	 * pt->adjusted_pf is a staging area for the actual features to use.
 	 * They get transferred to the live pool in bind_control_target()
@@ -4288,6 +4350,10 @@ static int thin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->max_discard_granularity = true;
 	}
 
+	ti->num_provision_bios = 1;
+	ti->provision_supported = true;
+	ti->max_provision_granularity = true;
+
 	mutex_unlock(&dm_thin_pool_table.mutex);
 
 	spin_lock_irq(&tc->pool->lock);
-- 
2.40.1.698.g37aff9b760-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

