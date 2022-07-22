Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A2BC43334
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jul 2022 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658514436;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QuoRs38N+GZhKGJViSDLkzvzsBtRdar6CjdgE8YLGiE=;
	b=EJoF+Y9Mw278jGE3ertKOeQPJ5HsOAGU7oqjk9gXrN8Z8BKr28WQwnuYuE2fkXHRCgfrQt
	8XA42up+VerkC7MwZ5J4jf2y20LadY54/Wv8jnOM4JJMOkVe3ErFEAz8FwcHZwNNURTqza
	mQvaTKdBL35/eFebvUB4iDd0jdoccKk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-er6wYSF9OSeG1VbWRTtg9g-1; Fri, 22 Jul 2022 14:27:07 -0400
X-MC-Unique: er6wYSF9OSeG1VbWRTtg9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD37D1019C9B;
	Fri, 22 Jul 2022 18:27:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 582FB1121314;
	Fri, 22 Jul 2022 18:27:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 20E7D194704D;
	Fri, 22 Jul 2022 18:27:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9B2C11947050
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Jul 2022 09:38:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8DF011121319; Fri, 22 Jul 2022 09:38:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 89D601121314
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 09:38:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D16D1035341
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 09:38:56 +0000 (UTC)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-Vd3VBPwSNPquZMreDIcmlg-1; Fri, 22 Jul 2022 05:38:54 -0400
X-MC-Unique: Vd3VBPwSNPquZMreDIcmlg-1
Received: by mail-yb1-f202.google.com with SMTP id
 m11-20020a5b040b000000b0066fcc60d1a0so3324568ybp.19
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 02:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+nB20Wi810hrWlIP5pvDiRZ1VMjjX1lRuMuiUP0CtOE=;
 b=FaimOI+/jDV2CqlSu3oabSA9sZHsH9wPbkasjVvzKX6WOnH1O7h0PftiWAgvLRSAF2
 6Bhfw6h9+XVlHtyIteNtqJp8NUy8mkW240R6orGxAXeCA9RjqYvbA9rNdEn/xgoJVup2
 QM5obM8h6CKCLe8fOKtyPdKPXfU1IFRsE6YkDeQBc3NbUc/m+K/5mwYvYC4uPpQ4avIp
 G4ASQjt2lXQie/xUupLDcG6eIbY2AlvGx3kWC0HdePKNGNLCbs82g1fEV8omOYpc6d0E
 RENTc3fUxJK6JHtKoBRh3626lDfHoKpauwt/CIkVvq9yH4Rq3yJ5pXPFUXkubXc2HAvQ
 TMlw==
X-Gm-Message-State: AJIora8Y2zZjR2qCIVpzvBWKyaSmiG7iJJykU7z5N9BsST7Cl3yUczlz
 V4+kqths/PrIJf7hjmWJDpnvXnAEVQ==
X-Google-Smtp-Source: AGRyM1s26ZXo/6tQtihIsdDRm6L/HqasYPcozEjSaAtHWxveiAl9+jglTQqnpl6VN9mDS39c1CYZVGIwyg==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:258:0:b0:670:a3b3:b941 with
 SMTP id
 85-20020a250258000000b00670a3b3b941mr2140164ybc.533.1658482733913; Fri, 22
 Jul 2022 02:38:53 -0700 (PDT)
Date: Fri, 22 Jul 2022 09:38:23 +0000
In-Reply-To: <20220722093823.4158756-1-nhuck@google.com>
Message-Id: <20220722093823.4158756-4-nhuck@google.com>
Mime-Version: 1.0
References: <20220722093823.4158756-1-nhuck@google.com>
From: Nathan Huckleberry <nhuck@google.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Fri, 22 Jul 2022 18:27:03 +0000
Subject: [dm-devel] [PATCH 3/3] dm-verity: Add try_verify_in_tasklet
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
Cc: Eric Biggers <ebiggers@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Nathan Huckleberry <nhuck@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Using tasklets for disk verification can reduce IO latency.  When there are
accelerated hash instructions it is often better to compute the hash immediately
using a tasklet rather than deferring verification to a work-queue.  This
reduces time spent waiting to schedule work-queue jobs, but requires spending
slightly more time in interrupt context.

If the dm-bufio cache does not have the required hashes we fallback to
the work-queue implementation.

The following shows a speed comparison of random reads on a dm-verity device.
The dm-verity device uses a 1G ramdisk for data and a 1G ramdisk for hashes.
One test was run using tasklets and one test was run using the existing
work-queue solution.  Both tests were run when the dm-bufio cache was hot.  The
tasklet implementation performs significantly better since there is no time
waiting for work-queue jobs to be scheduled.

# /data/fio /data/tasklet.fio | grep READ
   READ: bw=181MiB/s (190MB/s), 181MiB/s-181MiB/s (190MB/s-190MB/s), io=512MiB
   (537MB), run=2827-2827msec
# /data/fio /data/workqueue.fio | grep READ
   READ: bw=23.6MiB/s (24.8MB/s), 23.6MiB/s-23.6MiB/s (24.8MB/s-24.8MB/s),
   io=512MiB (537MB), run=21688-21688msec

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 drivers/md/dm-bufio.c         | 14 +++---
 drivers/md/dm-verity-target.c | 87 ++++++++++++++++++++++++++++++-----
 drivers/md/dm-verity.h        |  5 ++
 3 files changed, 87 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 3edeca7cfca6..039f39c29594 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -92,7 +92,7 @@ struct dm_bufio_client {
 	s8 sectors_per_block_bits;
 	void (*alloc_callback)(struct dm_buffer *);
 	void (*write_callback)(struct dm_buffer *);
-	bool may_sleep;
+	bool get_may_sleep;
 
 	struct kmem_cache *slab_buffer;
 	struct kmem_cache *slab_cache;
@@ -170,7 +170,7 @@ struct dm_buffer {
 
 static void dm_bufio_lock(struct dm_bufio_client *c)
 {
-	if (c->may_sleep)
+	if (c->get_may_sleep)
 		mutex_lock_nested(&c->lock, dm_bufio_in_request());
 	else
 		spin_lock_irqsave_nested(&c->spinlock, c->spinlock_flags, dm_bufio_in_request());
@@ -178,7 +178,7 @@ static void dm_bufio_lock(struct dm_bufio_client *c)
 
 static int dm_bufio_trylock(struct dm_bufio_client *c)
 {
-	if (c->may_sleep)
+	if (c->get_may_sleep)
 		return mutex_trylock(&c->lock);
 	else
 		return spin_trylock_irqsave(&c->spinlock, c->spinlock_flags);
@@ -186,7 +186,7 @@ static int dm_bufio_trylock(struct dm_bufio_client *c)
 
 static void dm_bufio_unlock(struct dm_bufio_client *c)
 {
-	if (c->may_sleep)
+	if (c->get_may_sleep)
 		mutex_unlock(&c->lock);
 	else
 		spin_unlock_irqrestore(&c->spinlock, c->spinlock_flags);
@@ -890,7 +890,7 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
 	 * be allocated.
 	 */
 	while (1) {
-		if (dm_bufio_cache_size_latch != 1 && c->may_sleep) {
+		if (dm_bufio_cache_size_latch != 1 && c->get_may_sleep) {
 			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 			if (b)
 				return b;
@@ -1761,9 +1761,9 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	c->alloc_callback = alloc_callback;
 	c->write_callback = write_callback;
 
-	c->may_sleep = true;
+	c->get_may_sleep = true;
 	if (flags & DM_BUFIO_GET_CANT_SLEEP)
-		c->may_sleep = false;
+		c->get_may_sleep = false;
 
 	for (i = 0; i < LIST_SIZE; i++) {
 		INIT_LIST_HEAD(&c->lru[i]);
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 5d3fc58a3c34..e4d1b674a278 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -34,6 +34,7 @@
 #define DM_VERITY_OPT_PANIC		"panic_on_corruption"
 #define DM_VERITY_OPT_IGN_ZEROES	"ignore_zero_blocks"
 #define DM_VERITY_OPT_AT_MOST_ONCE	"check_at_most_once"
+#define DM_VERITY_OPT_TASKLET_VERIFY	"try_verify_in_tasklet"
 
 #define DM_VERITY_OPTS_MAX		(3 + DM_VERITY_OPTS_FEC + \
 					 DM_VERITY_ROOT_HASH_VERIFICATION_OPTS)
@@ -286,7 +287,20 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 
 	verity_hash_at_level(v, block, level, &hash_block, &offset);
 
-	data = dm_bufio_read(v->bufio, hash_block, &buf);
+	if (io->in_tasklet)
+		data = dm_bufio_get(v->bufio, hash_block, &buf);
+	else
+		data = dm_bufio_read(v->bufio, hash_block, &buf);
+
+	if (data == NULL) {
+		/*
+		 * We're running as a tasklet and the hash was not in the bufio
+		 * cache.  Return early and resume execution from a work-queue
+		 * so that we can read the hash from disk.
+		 */
+		return -EAGAIN;
+	}
+
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
@@ -307,6 +321,14 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
 				  v->digest_size) == 0))
 			aux->hash_verified = 1;
+		else if (io->in_tasklet) {
+			/*
+			 * FEC code cannot be run in a tasklet since it may
+			 * sleep.  We need to resume execution in a work-queue
+			 * to handle FEC.
+			 */
+			return -EAGAIN;
+		}
 		else if (verity_fec_decode(v, io,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
 					   hash_block, data, NULL) == 0)
@@ -474,13 +496,12 @@ static int verity_verify_io(struct dm_verity_io *io)
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
@@ -527,6 +548,13 @@ static int verity_verify_io(struct dm_verity_io *io)
 			if (v->validated_blocks)
 				set_bit(cur_block, v->validated_blocks);
 			continue;
+		} else if (io->in_tasklet) {
+			/*
+			 * FEC code cannot be run in a tasklet since it may
+			 * sleep.  We need to resume execution in a work-queue
+			 * to handle FEC.
+			 */
+			return -EAGAIN;
 		}
 		else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
 					   cur_block, NULL, &start) == 0)
@@ -567,7 +595,8 @@ static void verity_finish_io(struct dm_verity_io *io, blk_status_t status)
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_status = status;
 
-	verity_fec_finish_io(io);
+	if (!io->in_tasklet)
+		verity_fec_finish_io(io);
 
 	bio_endio(bio);
 }
@@ -575,8 +604,28 @@ static void verity_finish_io(struct dm_verity_io *io, blk_status_t status)
 static void verity_work(struct work_struct *w)
 {
 	struct dm_verity_io *io = container_of(w, struct dm_verity_io, work);
+	int err;
+
+	io->in_tasklet = false;
+	err = verity_verify_io(io);
 
-	verity_finish_io(io, errno_to_blk_status(verity_verify_io(io)));
+	verity_finish_io(io, errno_to_blk_status(err));
+}
+
+static void verity_tasklet(unsigned long data)
+{
+	struct dm_verity_io *io = (struct dm_verity_io *) data;
+	int err;
+
+	io->in_tasklet = true;
+	err = verity_verify_io(io);
+	if (err) {
+		INIT_WORK(&io->work, verity_work);
+		queue_work(io->v->verify_wq, &io->work);
+		return;
+	}
+
+	verity_finish_io(io, errno_to_blk_status(err));
 }
 
 static void verity_end_io(struct bio *bio)
@@ -589,8 +638,14 @@ static void verity_end_io(struct bio *bio)
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
@@ -1012,7 +1067,12 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 				return r;
 			continue;
 
-		} else if (verity_is_fec_opt_arg(arg_name)) {
+		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
+			v->use_tasklet = true;
+			continue;
+		}
+
+		else if (verity_is_fec_opt_arg(arg_name)) {
 			r = verity_fec_parse_opt_args(as, v, &argc, arg_name);
 			if (r)
 				return r;
@@ -1068,6 +1128,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 	ti->private = v;
 	v->ti = ti;
+	v->use_tasklet = false;
 
 	r = verity_fec_ctr_alloc(v);
 	if (r)
@@ -1156,7 +1217,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
-	v->tfm = crypto_alloc_ahash(v->alg_name, 0, 0);
+	v->tfm = crypto_alloc_ahash(v->alg_name, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(v->tfm)) {
 		ti->error = "Cannot initialize hash function";
 		r = PTR_ERR(v->tfm);
@@ -1266,7 +1327,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
 		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
-		dm_bufio_alloc_callback, NULL, 0);
+		dm_bufio_alloc_callback, NULL, v->use_tasklet ?
+		DM_BUFIO_GET_CANT_SLEEP : 0);
 	if (IS_ERR(v->bufio)) {
 		ti->error = "Cannot initialize dm-bufio";
 		r = PTR_ERR(v->bufio);
@@ -1281,7 +1343,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	/* WQ_UNBOUND greatly improves performance when running on ramdisk */
-	v->verify_wq = alloc_workqueue("kverityd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
+	v->verify_wq = alloc_workqueue("kverityd", WQ_HIGHPRI | WQ_MEM_RECLAIM |
+						   WQ_UNBOUND, num_online_cpus());
 	if (!v->verify_wq) {
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 4e769d13473a..4e65f93bd8d6 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -13,6 +13,7 @@
 
 #include <linux/dm-bufio.h>
 #include <linux/device-mapper.h>
+#include <linux/interrupt.h>
 #include <crypto/hash.h>
 
 #define DM_VERITY_MAX_LEVELS		63
@@ -50,6 +51,7 @@ struct dm_verity {
 	unsigned char hash_dev_block_bits;	/* log2(hash blocksize) */
 	unsigned char hash_per_block_bits;	/* log2(hashes in hash block) */
 	unsigned char levels;	/* the number of tree levels */
+	bool use_tasklet;	/* try to verify in tasklet before work-queue */
 	unsigned char version;
 	unsigned digest_size;	/* digest size for the current hash algorithm */
 	unsigned int ahash_reqsize;/* the size of temporary space for crypto */
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
2.37.1.359.gd136c6c3e2-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

