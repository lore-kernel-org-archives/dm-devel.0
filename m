Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D5FC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 01:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658800735;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=i6QiEkyq5ga3ngvejqnfCPMfLWm2REi1H7aQzh0hv/Y=;
	b=h2e8fQWY6tQCjR1fgi5eNeuw03TXo8eN/DTs3/P0m2sqscxu/6lZsf1NGp+rMjpqZtJO71
	izKKiF8kh1dCRKJhRdjo6+L7feU5z6VZ7RC/N1y+N0p5N7+FkKOsBsVeqc7/+xM75c8noZ
	SP9Wf/M6biln/IwsG5et88zZLEJFB6o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-QfyqxflGMtmMuf6dY9CFxA-1; Mon, 25 Jul 2022 21:58:50 -0400
X-MC-Unique: QfyqxflGMtmMuf6dY9CFxA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAD88101A586;
	Tue, 26 Jul 2022 01:58:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CFBAD90A11;
	Tue, 26 Jul 2022 01:58:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 758411945D99;
	Tue, 26 Jul 2022 01:58:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3802D1945D86
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 01:58:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1EDBD492CA4; Tue, 26 Jul 2022 01:58:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B437492CA2
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 01:58:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F135A85A584
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 01:58:42 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-R3uoQQYMMrWrgORvmiXXcw-1; Mon, 25 Jul 2022 21:58:41 -0400
X-MC-Unique: R3uoQQYMMrWrgORvmiXXcw-1
Received: by mail-qk1-f198.google.com with SMTP id
 x22-20020a05620a259600b006b552a69231so11086088qko.18
 for <dm-devel@redhat.com>; Mon, 25 Jul 2022 18:58:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=zCUpOoOkHK4Qe7+MOCKP8H0h6UySF4kprz0bzSi+4/o=;
 b=thbo1i9SIFmUg2gRScieijb5acfXIW0uMnjN0AfTq4rwYMgjg1irUAxFmlEQ/RXxic
 pD//SfqIpkYcLAcImfypRM9wPlVJbPbLbDFE5Mh6T5ge4D2XmCos0c93OwZ+Izu1GUOF
 WrdM9xxPSPJ4XL5zIazZ0BVcyy7PG7ZpJbKHtsFIjATEYYmE7ABnwdRArUk/phfC3UcY
 zIIuhnbY2UcBb8sYde7CvumLqVkTXyKkHPc17pX49nsJcsa67K1VuEHcIx2BHBS/oXXM
 nBqA6hl3koGggOU+zNwYZ6PPNeeydCMPXsn7gar3OSXghD9mC+mK20PPE5HDq7TB4N/N
 8LrA==
X-Gm-Message-State: AJIora9O+kdB5Kef7bM2iqT1LgiG4+tXlEWDBTpyKffKG+hWbFckJgBl
 oCMiLjSAbWrMu85ji+GSk7m4CMNq+NK5JRF1zlTscpzQ+f6lARxXHjk/Mi8xy3bvvG9Y23Rzkzg
 ChUZR+KlXbZSpiQ==
X-Received: by 2002:a05:620a:d82:b0:6a9:9102:3948 with SMTP id
 q2-20020a05620a0d8200b006a991023948mr11282368qkl.56.1658800721116; 
 Mon, 25 Jul 2022 18:58:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vijl4P35Am0oiyyAfThVl94hZ38U1lqIf7jHZE+5jy7gGqYp+/8q5if2lc6ROMyQVWO3N4nw==
X-Received: by 2002:a05:620a:d82:b0:6a9:9102:3948 with SMTP id
 q2-20020a05620a0d8200b006a991023948mr11282365qkl.56.1658800720750; 
 Mon, 25 Jul 2022 18:58:40 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 n4-20020a05622a11c400b0031ef366c9b5sm9068927qtk.34.2022.07.25.18.58.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Jul 2022 18:58:40 -0700 (PDT)
Date: Mon, 25 Jul 2022 21:58:39 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Nathan Huckleberry <nhuck@google.com>
Message-ID: <Yt9KTzXUeA8xAiGv@redhat.com>
References: <20220722093823.4158756-1-nhuck@google.com>
 <20220722093823.4158756-4-nhuck@google.com>
MIME-Version: 1.0
In-Reply-To: <20220722093823.4158756-4-nhuck@google.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 3/3] dm-verity: Add try_verify_in_tasklet
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
Cc: Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 22 2022 at  5:38P -0400,
Nathan Huckleberry <nhuck@google.com> wrote:

> Using tasklets for disk verification can reduce IO latency.  When there are
> accelerated hash instructions it is often better to compute the hash immediately
> using a tasklet rather than deferring verification to a work-queue.  This
> reduces time spent waiting to schedule work-queue jobs, but requires spending
> slightly more time in interrupt context.
> 
> If the dm-bufio cache does not have the required hashes we fallback to
> the work-queue implementation.
> 
> The following shows a speed comparison of random reads on a dm-verity device.
> The dm-verity device uses a 1G ramdisk for data and a 1G ramdisk for hashes.
> One test was run using tasklets and one test was run using the existing
> work-queue solution.  Both tests were run when the dm-bufio cache was hot.  The
> tasklet implementation performs significantly better since there is no time
> waiting for work-queue jobs to be scheduled.
> 
> # /data/fio /data/tasklet.fio | grep READ
>    READ: bw=181MiB/s (190MB/s), 181MiB/s-181MiB/s (190MB/s-190MB/s), io=512MiB
>    (537MB), run=2827-2827msec
> # /data/fio /data/workqueue.fio | grep READ
>    READ: bw=23.6MiB/s (24.8MB/s), 23.6MiB/s-23.6MiB/s (24.8MB/s-24.8MB/s),
>    io=512MiB (537MB), run=21688-21688msec
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> ---
>  drivers/md/dm-bufio.c         | 14 +++---
>  drivers/md/dm-verity-target.c | 87 ++++++++++++++++++++++++++++++-----
>  drivers/md/dm-verity.h        |  5 ++
>  3 files changed, 87 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 3edeca7cfca6..039f39c29594 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -92,7 +92,7 @@ struct dm_bufio_client {
>  	s8 sectors_per_block_bits;
>  	void (*alloc_callback)(struct dm_buffer *);
>  	void (*write_callback)(struct dm_buffer *);
> -	bool may_sleep;
> +	bool get_may_sleep;
>  
>  	struct kmem_cache *slab_buffer;
>  	struct kmem_cache *slab_cache;
> @@ -170,7 +170,7 @@ struct dm_buffer {
>  
>  static void dm_bufio_lock(struct dm_bufio_client *c)
>  {
> -	if (c->may_sleep)
> +	if (c->get_may_sleep)
>  		mutex_lock_nested(&c->lock, dm_bufio_in_request());
>  	else
>  		spin_lock_irqsave_nested(&c->spinlock, c->spinlock_flags, dm_bufio_in_request());
> @@ -178,7 +178,7 @@ static void dm_bufio_lock(struct dm_bufio_client *c)
>  
>  static int dm_bufio_trylock(struct dm_bufio_client *c)
>  {
> -	if (c->may_sleep)
> +	if (c->get_may_sleep)
>  		return mutex_trylock(&c->lock);
>  	else
>  		return spin_trylock_irqsave(&c->spinlock, c->spinlock_flags);
> @@ -186,7 +186,7 @@ static int dm_bufio_trylock(struct dm_bufio_client *c)
>  
>  static void dm_bufio_unlock(struct dm_bufio_client *c)
>  {
> -	if (c->may_sleep)
> +	if (c->get_may_sleep)
>  		mutex_unlock(&c->lock);
>  	else
>  		spin_unlock_irqrestore(&c->spinlock, c->spinlock_flags);
> @@ -890,7 +890,7 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  	 * be allocated.
>  	 */
>  	while (1) {
> -		if (dm_bufio_cache_size_latch != 1 && c->may_sleep) {
> +		if (dm_bufio_cache_size_latch != 1 && c->get_may_sleep) {
>  			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
>  			if (b)
>  				return b;
> @@ -1761,9 +1761,9 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
>  	c->alloc_callback = alloc_callback;
>  	c->write_callback = write_callback;
>  
> -	c->may_sleep = true;
> +	c->get_may_sleep = true;
>  	if (flags & DM_BUFIO_GET_CANT_SLEEP)
> -		c->may_sleep = false;
> +		c->get_may_sleep = false;
>  
>  	for (i = 0; i < LIST_SIZE; i++) {
>  		INIT_LIST_HEAD(&c->lru[i]);

I ended up inverting the logic and went with the name "no_sleep", see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.20&id=fa9b59cc264f350c1e34ea784ac4c12fcee1aed1

My reasoning is that: the bufio change has broader implications than
just the _get method. So I expanded the scope of the naming to reflect
that the locking and buffers allocations will not sleep if
DM_BUFIO_CLIENT_NO_SLEEP is set.

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 5d3fc58a3c34..e4d1b674a278 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -34,6 +34,7 @@
>  #define DM_VERITY_OPT_PANIC		"panic_on_corruption"
>  #define DM_VERITY_OPT_IGN_ZEROES	"ignore_zero_blocks"
>  #define DM_VERITY_OPT_AT_MOST_ONCE	"check_at_most_once"
> +#define DM_VERITY_OPT_TASKLET_VERIFY	"try_verify_in_tasklet"
>  
>  #define DM_VERITY_OPTS_MAX		(3 + DM_VERITY_OPTS_FEC + \
>  					 DM_VERITY_ROOT_HASH_VERIFICATION_OPTS)
> @@ -286,7 +287,20 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
>  
>  	verity_hash_at_level(v, block, level, &hash_block, &offset);
>  
> -	data = dm_bufio_read(v->bufio, hash_block, &buf);
> +	if (io->in_tasklet)
> +		data = dm_bufio_get(v->bufio, hash_block, &buf);
> +	else
> +		data = dm_bufio_read(v->bufio, hash_block, &buf);
> +
> +	if (data == NULL) {
> +		/*
> +		 * We're running as a tasklet and the hash was not in the bufio
> +		 * cache.  Return early and resume execution from a work-queue
> +		 * so that we can read the hash from disk.
> +		 */
> +		return -EAGAIN;
> +	}
> +
>  	if (IS_ERR(data))
>  		return PTR_ERR(data);
>  

I tweaked various things in the dm-verity-target.c portion of this
patch.  Ranging from whitespace and style tweaks to code flow tweaks.
I'll include an incremental patch at the end of this email.

<snip>

> @@ -1156,7 +1217,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  		goto bad;
>  	}
>  
> -	v->tfm = crypto_alloc_ahash(v->alg_name, 0, 0);
> +	v->tfm = crypto_alloc_ahash(v->alg_name, 0, CRYPTO_ALG_ASYNC);
>  	if (IS_ERR(v->tfm)) {
>  		ti->error = "Cannot initialize hash function";
>  		r = PTR_ERR(v->tfm);

This hunk that adds the CRYPTO_ALG_ASYNC flag _seems_ unrelated.

> @@ -1281,7 +1343,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	}
>  
>  	/* WQ_UNBOUND greatly improves performance when running on ramdisk */
> -	v->verify_wq = alloc_workqueue("kverityd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
> +	v->verify_wq = alloc_workqueue("kverityd", WQ_HIGHPRI | WQ_MEM_RECLAIM |
> +						   WQ_UNBOUND, num_online_cpus());
>  	if (!v->verify_wq) {
>  		ti->error = "Cannot allocate workqueue";
>  		r = -ENOMEM;

Likewise, the removal of WQ_CPU_INTENSIVE _seems_ unrelated to this
patch.  If you'd like these 2 changes made please send an incremental
patch with a header that explains these changes.

Here is an earlier incremental patch that I folded into this commit:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.20&id=a5beaa11a1a225860fdf9ae80f0bd54bf9125c4c

(Also, if the performance you quoted in the commit header depends on
the 2 above flags changes (which I dropped) please let me know.)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 73215a4baf1f..356a11f36100 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -221,7 +221,7 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
 	struct mapped_device *md = dm_table_get_md(v->ti->table);
 
 	/* Corruption should be visible in device status in all modes */
-	v->hash_failed = 1;
+	v->hash_failed = true;
 
 	if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS)
 		goto out;
@@ -287,20 +287,19 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 
 	verity_hash_at_level(v, block, level, &hash_block, &offset);
 
-	if (io->in_tasklet)
+	if (io->in_tasklet) {
 		data = dm_bufio_get(v->bufio, hash_block, &buf);
-	else
+		if (data == NULL) {
+			/*
+			 * In tasklet and the hash was not in the bufio cache.
+			 * Return early and resume execution from a work-queue
+			 * to read the hash from disk.
+			 */
+			return -EAGAIN;
+		}
+	} else
 		data = dm_bufio_read(v->bufio, hash_block, &buf);
 
-	if (data == NULL) {
-		/*
-		 * We're running as a tasklet and the hash was not in the bufio
-		 * cache.  Return early and resume execution from a work-queue
-		 * so that we can read the hash from disk.
-		 */
-		return -EAGAIN;
-	}
-
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
@@ -321,14 +320,12 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
 				  v->digest_size) == 0))
 			aux->hash_verified = 1;
-		else if (io->in_tasklet) {
+		else if (io->in_tasklet)
 			/*
 			 * FEC code cannot be run in a tasklet since it may
-			 * sleep.  We need to resume execution in a work-queue
-			 * to handle FEC.
+			 * sleep, so fallback to using a work-queue.
 			 */
 			return -EAGAIN;
-		}
 		else if (verity_fec_decode(v, io,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
 					   hash_block, data, NULL) == 0)
@@ -527,13 +524,6 @@ static int verity_verify_io(struct dm_verity_io *io)
 				return r;
 
 			continue;
-		} else if (io->in_tasklet) {
-			/*
-			 * FEC code cannot be run in a tasklet since it may
-			 * sleep.  We need to resume execution in a work-queue
-			 * to handle FEC.
-			 */
-			return -EAGAIN;
 		}
 
 		r = verity_hash_init(v, req, &wait);
@@ -555,8 +545,14 @@ static int verity_verify_io(struct dm_verity_io *io)
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
@@ -603,22 +599,20 @@ static void verity_finish_io(struct dm_verity_io *io, blk_status_t status)
 static void verity_work(struct work_struct *w)
 {
 	struct dm_verity_io *io = container_of(w, struct dm_verity_io, work);
-	int err;
 
-	io->in_tasklet = false;
-	err = verity_verify_io(io);
-
-	verity_finish_io(io, errno_to_blk_status(err));
+	verity_finish_io(io, errno_to_blk_status(verity_verify_io(io)));
 }
 
 static void verity_tasklet(unsigned long data)
 {
-	struct dm_verity_io *io = (struct dm_verity_io *) data;
+	struct dm_verity_io *io = (struct dm_verity_io *)data;
 	int err;
 
 	io->in_tasklet = true;
 	err = verity_verify_io(io);
-	if (err) {
+	if (err == -EAGAIN) {
+		/* fallback to retrying with work-queue */
+		io->in_tasklet = false;
 		INIT_WORK(&io->work, verity_work);
 		queue_work(io->v->verify_wq, &io->work);
 		return;
@@ -1069,13 +1063,13 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
 			v->use_tasklet = true;
 			continue;
-		}
 
-		else if (verity_is_fec_opt_arg(arg_name)) {
+		} else if (verity_is_fec_opt_arg(arg_name)) {
 			r = verity_fec_parse_opt_args(as, v, &argc, arg_name);
 			if (r)
 				return r;
 			continue;
+
 		} else if (verity_verify_is_sig_opt_arg(arg_name)) {
 			r = verity_verify_sig_parse_opt_args(as, v,
 							     verify_args,
@@ -1083,7 +1077,6 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 			if (r)
 				return r;
 			continue;
-
 		}
 
 		ti->error = "Unrecognized verity feature request";
@@ -1127,7 +1120,6 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 	ti->private = v;
 	v->ti = ti;
-	v->use_tasklet = false;
 
 	r = verity_fec_ctr_alloc(v);
 	if (r)
@@ -1216,7 +1208,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
-	v->tfm = crypto_alloc_ahash(v->alg_name, 0, CRYPTO_ALG_ASYNC);
+	v->tfm = crypto_alloc_ahash(v->alg_name, 0, 0);
 	if (IS_ERR(v->tfm)) {
 		ti->error = "Cannot initialize hash function";
 		r = PTR_ERR(v->tfm);
@@ -1326,8 +1318,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
 		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
-		dm_bufio_alloc_callback, NULL, v->use_tasklet ?
-		DM_BUFIO_CLIENT_NO_SLEEP : 0);
+		dm_bufio_alloc_callback, NULL,
+		v->use_tasklet ? DM_BUFIO_CLIENT_NO_SLEEP : 0);
 	if (IS_ERR(v->bufio)) {
 		ti->error = "Cannot initialize dm-bufio";
 		r = PTR_ERR(v->bufio);
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 4e65f93bd8d6..26fbe553ca15 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -51,11 +51,11 @@ struct dm_verity {
 	unsigned char hash_dev_block_bits;	/* log2(hash blocksize) */
 	unsigned char hash_per_block_bits;	/* log2(hashes in hash block) */
 	unsigned char levels;	/* the number of tree levels */
-	bool use_tasklet;	/* try to verify in tasklet before work-queue */
 	unsigned char version;
 	unsigned digest_size;	/* digest size for the current hash algorithm */
 	unsigned int ahash_reqsize;/* the size of temporary space for crypto */
-	int hash_failed;	/* set to 1 if hash of any block failed */
+	bool hash_failed:1;	/* set to 1 if hash of any block failed */
+	bool use_tasklet:1;	/* try to verify in tasklet before work-queue */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	unsigned corrupted_errs;/* Number of errors for corrupted blocks */
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

