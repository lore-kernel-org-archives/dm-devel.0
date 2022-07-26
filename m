Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22CE7C04A68
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658851816;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=s2K2hXJ6khtU6+vrBRAOEryhpopSEN8X/io5Wd9L9hE=;
	b=dyeG0MdPlqdLwBOhBaKsWN4xPJNuOlhJSL1cYmXeSJXp0t7Wbt7GfKHLD9W+IPHeGOPEJJ
	ylj1eSLX+LIo68hAxy13yosxAY7B/VXiekLzEbncKAXRkNU9iFF7i6CGwi1iNu/nFi+WJ7
	L6YLU89sCYnO/wejz6SmbDdOrRbRraY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-mFP5eGyaMAOTBU9L3KDJ4A-1; Tue, 26 Jul 2022 12:10:12 -0400
X-MC-Unique: mFP5eGyaMAOTBU9L3KDJ4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15430811E75;
	Tue, 26 Jul 2022 16:10:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 012BC1415118;
	Tue, 26 Jul 2022 16:10:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C3C581947050;
	Tue, 26 Jul 2022 16:10:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B79A1945DA0
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 16:10:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 30E812026D07; Tue, 26 Jul 2022 16:10:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C8992026D64
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1090E802D1C
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:08 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-KZItj4lvMqS5NHyAlagaIQ-1; Tue, 26 Jul 2022 12:10:06 -0400
X-MC-Unique: KZItj4lvMqS5NHyAlagaIQ-1
Received: by mail-qt1-f169.google.com with SMTP id c20so10766522qtw.8
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 09:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=cGzlbS1u19Da2+jcGvOt+bCQwf1Psf+FIah3Q2zZYYs=;
 b=i6A5bcGUabnFeI0OA1SohA5qMPQAkZq7a3Im+S/3m8SzFhtbF57tq1zx3Z3yZxWe5y
 6kFXL8rxo1rweCSXBHOpRORZdc6VATwozsN8/KzOXuaU9QJS3UKBohauM+6OkPmqIxk0
 6dNX3FX1dlERiZ87f0jrE9E/WFAihLm3IqURnSrszywHd20i49JJ4K91+v6y12DmJw9n
 uERFWLgy92GkL7ymwtX+hQ763MyX4e/U6bu7XxmBZG8zkMDQUFEc8Ji9REvUM/hFumaI
 tXNQH/dPbmiKTZasSUBw+J6hqnSipb8CfsHSUQ6qHyWEVgDAM/P/Akw5uIV9aR3my3Kd
 d75w==
X-Gm-Message-State: AJIora/Oxk+7BdlMCwMBVtnr+YC4VyKPwQD5SZdt/MAsR0+ZnLEMMbLS
 Gv9tGjcoM5iZnllSstJLYYVoJXc=
X-Google-Smtp-Source: AGRyM1t3fR0wyk7AXT5hYyNsIbSXjBz7nG9O+LYk6RGGpESwf5Z0hCV5A5dpfKPwzZ+GFLIN6bZTqQ==
X-Received: by 2002:ac8:5c06:0:b0:31e:de4b:abb8 with SMTP id
 i6-20020ac85c06000000b0031ede4babb8mr15371388qti.83.1658851805511; 
 Tue, 26 Jul 2022 09:10:05 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 bj26-20020a05620a191a00b006af50b6f10csm11474443qkb.61.2022.07.26.09.10.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jul 2022 09:10:04 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: Nathan Huckleberry <nhuck@google.com>, Eric Biggers <ebiggers@kernel.org>
Date: Tue, 26 Jul 2022 12:09:56 -0400
Message-Id: <20220726160959.89247-4-snitzer@kernel.org>
In-Reply-To: <20220726160959.89247-1-snitzer@kernel.org>
References: <20220726160959.89247-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 3/6] dm verity: Add optional
 "try_verify_in_tasklet" feature
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
Cc: dm-devel@redhat.com, Sami Tolvanen <samitolvanen@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nathan Huckleberry <nhuck@google.com>

Using tasklets for disk verification can reduce IO latency. When there
are accelerated hash instructions it is often better to compute the
hash immediately using a tasklet rather than deferring verification to
a work-queue. This reduces time spent waiting to schedule work-queue
jobs, but requires spending slightly more time in interrupt context.

If the dm-bufio cache does not have the required hashes we fallback to
the work-queue implementation. FEC is only possible using work-queue
because code to support the FEC feature may sleep.

The following shows a speed comparison of random reads on a dm-verity
device. The dm-verity device uses a 1G ramdisk for data and a 1G
ramdisk for hashes. One test was run using tasklets and one test was
run using the existing work-queue solution. Both tests were run when
the dm-bufio cache was hot. The tasklet implementation performs
significantly better since there is no time spent waiting for
work-queue jobs to be scheduled.

   READ: bw=181MiB/s (190MB/s), 181MiB/s-181MiB/s (190MB/s-190MB/s), io=512MiB
   (537MB), run=2827-2827msec
   READ: bw=23.6MiB/s (24.8MB/s), 23.6MiB/s-23.6MiB/s (24.8MB/s-24.8MB/s),
   io=512MiB (537MB), run=21688-21688msec

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-verity-target.c | 90 ++++++++++++++++++++++++++++++-----
 drivers/md/dm-verity.h        |  7 ++-
 2 files changed, 83 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 95db3a7ee3c7..3b566077a74e 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -34,6 +34,7 @@
 #define DM_VERITY_OPT_PANIC		"panic_on_corruption"
 #define DM_VERITY_OPT_IGN_ZEROES	"ignore_zero_blocks"
 #define DM_VERITY_OPT_AT_MOST_ONCE	"check_at_most_once"
+#define DM_VERITY_OPT_TASKLET_VERIFY	"try_verify_in_tasklet"
 
 #define DM_VERITY_OPTS_MAX		(3 + DM_VERITY_OPTS_FEC + \
 					 DM_VERITY_ROOT_HASH_VERIFICATION_OPTS)
@@ -220,7 +221,7 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
 	struct mapped_device *md = dm_table_get_md(v->ti->table);
 
 	/* Corruption should be visible in device status in all modes */
-	v->hash_failed = 1;
+	v->hash_failed = true;
 
 	if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS)
 		goto out;
@@ -286,7 +287,19 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 
 	verity_hash_at_level(v, block, level, &hash_block, &offset);
 
-	data = dm_bufio_read(v->bufio, hash_block, &buf);
+	if (io->in_tasklet) {
+		data = dm_bufio_get(v->bufio, hash_block, &buf);
+		if (data == NULL) {
+			/*
+			 * In tasklet and the hash was not in the bufio cache.
+			 * Return early and resume execution from a work-queue
+			 * to read the hash from disk.
+			 */
+			return -EAGAIN;
+		}
+	} else
+		data = dm_bufio_read(v->bufio, hash_block, &buf);
+
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
@@ -307,6 +320,14 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
 				  v->digest_size) == 0))
 			aux->hash_verified = 1;
+		else if (io->in_tasklet) {
+			/*
+			 * FEC code cannot be run in a tasklet since it may
+			 * sleep, so fallback to using a work-queue.
+			 */
+			r = -EAGAIN;
+			goto release_ret_r;
+		}
 		else if (verity_fec_decode(v, io,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
 					   hash_block, data, NULL) == 0)
@@ -474,13 +495,12 @@ static int verity_verify_io(struct dm_verity_io *io)
 	bool is_zero;
 	struct dm_verity *v = io->v;
 	struct bvec_iter start;
-	unsigned b;
 	struct crypto_wait wait;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
-	for (b = 0; b < io->n_blocks; b++) {
+	for (; io->block_idx < io->n_blocks; io->block_idx++) {
 		int r;
-		sector_t cur_block = io->block + b;
+		sector_t cur_block = io->block + io->block_idx;
 		struct ahash_request *req = verity_io_hash_req(v, io);
 
 		if (v->validated_blocks &&
@@ -527,8 +547,14 @@ static int verity_verify_io(struct dm_verity_io *io)
 			if (v->validated_blocks)
 				set_bit(cur_block, v->validated_blocks);
 			continue;
+		} else if (io->in_tasklet) {
+			/*
+			 * FEC code cannot be run in a tasklet since it may
+			 * sleep, so fallback to using a work-queue.
+			 */
+			return -EAGAIN;
 		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
-					   cur_block, NULL, &start) == 0) {
+					     cur_block, NULL, &start) == 0) {
 			continue;
 		} else {
 			if (bio->bi_status) {
@@ -566,7 +592,8 @@ static void verity_finish_io(struct dm_verity_io *io, blk_status_t status)
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_status = status;
 
-	verity_fec_finish_io(io);
+	if (!io->in_tasklet)
+		verity_fec_finish_io(io);
 
 	bio_endio(bio);
 }
@@ -578,6 +605,24 @@ static void verity_work(struct work_struct *w)
 	verity_finish_io(io, errno_to_blk_status(verity_verify_io(io)));
 }
 
+static void verity_tasklet(unsigned long data)
+{
+	struct dm_verity_io *io = (struct dm_verity_io *)data;
+	int err;
+
+	io->in_tasklet = true;
+	err = verity_verify_io(io);
+	if (err == -EAGAIN) {
+		/* fallback to retrying with work-queue */
+		io->in_tasklet = false;
+		INIT_WORK(&io->work, verity_work);
+		queue_work(io->v->verify_wq, &io->work);
+		return;
+	}
+
+	verity_finish_io(io, errno_to_blk_status(err));
+}
+
 static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;
@@ -588,8 +633,14 @@ static void verity_end_io(struct bio *bio)
 		return;
 	}
 
-	INIT_WORK(&io->work, verity_work);
-	queue_work(io->v->verify_wq, &io->work);
+	io->block_idx = 0;
+	if (io->v->use_tasklet) {
+		tasklet_init(&io->tasklet, verity_tasklet, (unsigned long)io);
+		tasklet_schedule(&io->tasklet);
+	} else {
+		INIT_WORK(&io->work, verity_work);
+		queue_work(io->v->verify_wq, &io->work);
+	}
 }
 
 /*
@@ -751,6 +802,8 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 			args++;
 		if (v->validated_blocks)
 			args++;
+		if (v->use_tasklet)
+			args++;
 		if (v->signature_key_desc)
 			args += DM_VERITY_ROOT_HASH_VERIFICATION_OPTS;
 		if (!args)
@@ -776,6 +829,8 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" " DM_VERITY_OPT_IGN_ZEROES);
 		if (v->validated_blocks)
 			DMEMIT(" " DM_VERITY_OPT_AT_MOST_ONCE);
+		if (v->use_tasklet)
+			DMEMIT(" " DM_VERITY_OPT_TASKLET_VERIFY);
 		sz = verity_fec_status_table(v, sz, result, maxlen);
 		if (v->signature_key_desc)
 			DMEMIT(" " DM_VERITY_ROOT_HASH_VERIFICATION_OPT_SIG_KEY
@@ -1011,11 +1066,16 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 				return r;
 			continue;
 
+		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
+			v->use_tasklet = true;
+			continue;
+
 		} else if (verity_is_fec_opt_arg(arg_name)) {
 			r = verity_fec_parse_opt_args(as, v, &argc, arg_name);
 			if (r)
 				return r;
 			continue;
+
 		} else if (verity_verify_is_sig_opt_arg(arg_name)) {
 			r = verity_verify_sig_parse_opt_args(as, v,
 							     verify_args,
@@ -1023,7 +1083,6 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 			if (r)
 				return r;
 			continue;
-
 		}
 
 		ti->error = "Unrecognized verity feature request";
@@ -1155,7 +1214,11 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
-	v->tfm = crypto_alloc_ahash(v->alg_name, 0, 0);
+	/*
+	 * FIXME: CRYPTO_ALG_ASYNC should be conditional on v->use_tasklet
+	 * but verity_parse_opt_args() happens below and has data dep on tfm.
+	 */
+	v->tfm = crypto_alloc_ahash(v->alg_name, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(v->tfm)) {
 		ti->error = "Cannot initialize hash function";
 		r = PTR_ERR(v->tfm);
@@ -1265,7 +1328,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
 		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
-		dm_bufio_alloc_callback, NULL, 0);
+		dm_bufio_alloc_callback, NULL,
+		v->use_tasklet ? DM_BUFIO_CLIENT_NO_SLEEP : 0);
 	if (IS_ERR(v->bufio)) {
 		ti->error = "Cannot initialize dm-bufio";
 		r = PTR_ERR(v->bufio);
@@ -1312,7 +1376,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 static struct target_type verity_target = {
 	.name		= "verity",
 	.features	= DM_TARGET_IMMUTABLE,
-	.version	= {1, 8, 0},
+	.version	= {1, 9, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 4e769d13473a..e73a7972c3e9 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -13,6 +13,7 @@
 
 #include <linux/dm-bufio.h>
 #include <linux/device-mapper.h>
+#include <linux/interrupt.h>
 #include <crypto/hash.h>
 
 #define DM_VERITY_MAX_LEVELS		63
@@ -51,9 +52,10 @@ struct dm_verity {
 	unsigned char hash_per_block_bits;	/* log2(hashes in hash block) */
 	unsigned char levels;	/* the number of tree levels */
 	unsigned char version;
+	bool hash_failed:1;	/* set if hash of any block failed */
+	bool use_tasklet:1;	/* try to verify in tasklet before work-queue */
 	unsigned digest_size;	/* digest size for the current hash algorithm */
 	unsigned int ahash_reqsize;/* the size of temporary space for crypto */
-	int hash_failed;	/* set to 1 if hash of any block failed */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	unsigned corrupted_errs;/* Number of errors for corrupted blocks */
 
@@ -76,10 +78,13 @@ struct dm_verity_io {
 
 	sector_t block;
 	unsigned n_blocks;
+	unsigned int block_idx;
+	bool in_tasklet;
 
 	struct bvec_iter iter;
 
 	struct work_struct work;
+	struct tasklet_struct tasklet;
 
 	/*
 	 * Three variably-size fields follow this struct:
-- 
2.32.1 (Apple Git-133)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

