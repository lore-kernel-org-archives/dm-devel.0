Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692AE2F0C43
	for <dm-devel@lists.linux.dev>; Thu, 17 Jul 2025 15:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752764908; cv=none; b=o/EP9VFLBh2M2EkLbIp6N+C8FJWjVC0+EUDo9UIJ8MkA7CnsaElE4OgyEhUFrquVIhHqL9VmFZ8l045TOCosIyDXAkmBFYOmcQdD8OlSDZVOGPZ46q5ibS0Oz5AvTzdlnBxHKFQWpF4WC6rIjXhZB/Gyu6+TdQPT59lWhc0EFZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752764908; c=relaxed/simple;
	bh=SdTF45f2CqE+tJlq5vr+z6KonmFUYs+YWBuzNlYQyGw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=dcYf/4MmXPlcwjI3SgmTKPGgZAdWPy1F2t8lHZAqrLsHAYI7wV5Is+mmm7042rZSL0k0CFhDOOCe34kPSW2TB/lb+K2k6CS0jCNas4S6/hP3VowlWAmicdBYuOuFiuc+GRqr8Q7h/gCy8fn0i733b2OH9lKqvyV6DIUz98DT694=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fS1vUpmh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fS1vUpmh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752764905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nn1Bxakyg/nAOoFSayQZ3wcICLe556aV8nn9mfsonsk=;
	b=fS1vUpmhqlNr7gA35AOPqTwH3dbytUwGsy40qxBaC+rwaJ3cZHeh7zgnLsSJgsS13TR5tb
	lAxcncLX/Vp2Af+AP7APbETdhFYho36Pl22+VBXfVOEKJYBbSy2pmgVxQZadXaoGBA6sd+
	YeIQmMhZc24RgyiFDRUgHp7LCMUK4BI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-ECgbPyj9PreFMC3WpWPJXQ-1; Thu,
 17 Jul 2025 11:08:20 -0400
X-MC-Unique: ECgbPyj9PreFMC3WpWPJXQ-1
X-Mimecast-MFC-AGG-ID: ECgbPyj9PreFMC3WpWPJXQ_1752764899
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D3E51956046;
	Thu, 17 Jul 2025 15:08:18 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA9671966663;
	Thu, 17 Jul 2025 15:08:16 +0000 (UTC)
Date: Thu, 17 Jul 2025 17:08:11 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eran Messeri <eranm@google.com>
cc: Mike Snitzer <snitzer@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
    ebiggers@google.com, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-verity: Rename bh-related fields
In-Reply-To: <20250717111750.1423232-1-eranm@google.com>
Message-ID: <ce7553fe-320c-33e2-6e94-c597d0aa2205@redhat.com>
References: <20250717111750.1423232-1-eranm@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f2ShLZawCjmBS39UkeA47vrK42I4TOeK-EJbcyIrxwE_1752764899
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I wouldn't do this - these sorts of changes will cause problems when 
backporting bugfixes to the stable kernel branches.

Mikulas



On Thu, 17 Jul 2025, Eran Messeri wrote:

> Rename the "in_bh" / "use_bh" fields to indicate the work is done
> in-line, not in the "bottom half" (as a synonym to softirq). In
> certain situations (e.g. dm-verity on top of a loopback device)
> the verification will not be done in a softirq context but in a
> task context.
> 
> There are no functional changes to the code.
> 
> Signed-off-by: Eran Messeri <eranm@google.com>
> ---
>  drivers/md/dm-verity-target.c | 85 ++++++++++++++++++++---------------
>  drivers/md/dm-verity.h        | 10 +++--
>  2 files changed, 55 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 66a00a8ccb39..be9f6d9fccf4 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -29,7 +29,7 @@
>  #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
>  
>  #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
> -#define DM_VERITY_USE_BH_DEFAULT_BYTES	8192
> +#define DM_VERITY_DEFAULT_MAX_INLINE_SIZE	8192
>  
>  #define DM_VERITY_MAX_CORRUPTED_ERRS	100
>  
> @@ -49,16 +49,16 @@ static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE
>  
>  module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
>  
> -static unsigned int dm_verity_use_bh_bytes[4] = {
> -	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_NONE
> -	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_RT
> -	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_BE
> +static unsigned int dm_verity_max_inline_size_bytes[4] = {
> +	DM_VERITY_DEFAULT_MAX_INLINE_SIZE,	// IOPRIO_CLASS_NONE
> +	DM_VERITY_DEFAULT_MAX_INLINE_SIZE,	// IOPRIO_CLASS_RT
> +	DM_VERITY_DEFAULT_MAX_INLINE_SIZE,	// IOPRIO_CLASS_BE
>  	0				// IOPRIO_CLASS_IDLE
>  };
>  
> -module_param_array_named(use_bh_bytes, dm_verity_use_bh_bytes, uint, NULL, 0644);
> +module_param_array_named(use_bh_bytes, dm_verity_max_inline_size_bytes, uint, NULL, 0644);
>  
> -static DEFINE_STATIC_KEY_FALSE(use_bh_wq_enabled);
> +static DEFINE_STATIC_KEY_FALSE(inline_verification_enabled);
>  
>  struct dm_verity_prefetch_work {
>  	struct work_struct work;
> @@ -236,13 +236,14 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
>  
>  	verity_hash_at_level(v, block, level, &hash_block, &offset);
>  
> -	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
> +	if (static_branch_unlikely(&inline_verification_enabled) &&
> +	    !io->may_sleep) {
>  		data = dm_bufio_get(v->bufio, hash_block, &buf);
>  		if (IS_ERR_OR_NULL(data)) {
>  			/*
> -			 * In tasklet and the hash was not in the bufio cache.
> -			 * Return early and resume execution from a work-queue
> -			 * to read the hash from disk.
> +			 * In atomic context and the hash was not in the bufio
> +			 * cache. Return early and resume execution from a
> +			 * work-queue to read the hash from disk.
>  			 */
>  			return -EAGAIN;
>  		}
> @@ -286,10 +287,12 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
>  		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
>  				  v->digest_size) == 0))
>  			aux->hash_verified = 1;
> -		else if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
> +		else if (static_branch_unlikely(&inline_verification_enabled) &&
> +			 !io->may_sleep) {
>  			/*
> -			 * Error handling code (FEC included) cannot be run in a
> -			 * tasklet since it may sleep, so fallback to work-queue.
> +			 * Error handling code (FEC included) cannot be run in
> +			 * atomic context since it may sleep,
> +			 * so fallback to work-queue.
>  			 */
>  			r = -EAGAIN;
>  			goto release_ret_r;
> @@ -405,10 +408,11 @@ static int verity_handle_data_hash_mismatch(struct dm_verity *v,
>  					    struct bio *bio, sector_t blkno,
>  					    u8 *data)
>  {
> -	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
> +	if (static_branch_unlikely(&inline_verification_enabled) &&
> +	    !io->may_sleep) {
>  		/*
> -		 * Error handling code (FEC included) cannot be run in the
> -		 * BH workqueue, so fallback to a standard workqueue.
> +		 * Error handling code (FEC included) cannot be run in atomic
> +		 * context so fallback to a standard workqueue.
>  		 */
>  		return -EAGAIN;
>  	}
> @@ -445,7 +449,8 @@ static int verity_verify_io(struct dm_verity_io *io)
>  	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
>  	unsigned int b;
>  
> -	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
> +	if (static_branch_unlikely(&inline_verification_enabled) &&
> +	    !io->may_sleep) {
>  		/*
>  		 * Copy the iterator in case we need to restart
>  		 * verification in a work-queue.
> @@ -546,7 +551,8 @@ static void verity_finish_io(struct dm_verity_io *io, blk_status_t status)
>  	bio->bi_end_io = io->orig_bi_end_io;
>  	bio->bi_status = status;
>  
> -	if (!static_branch_unlikely(&use_bh_wq_enabled) || !io->in_bh)
> +	if (!static_branch_unlikely(&inline_verification_enabled) ||
> +	    io->may_sleep)
>  		verity_fec_finish_io(io);
>  
>  	if (unlikely(status != BLK_STS_OK) &&
> @@ -574,17 +580,22 @@ static void verity_work(struct work_struct *w)
>  {
>  	struct dm_verity_io *io = container_of(w, struct dm_verity_io, work);
>  
> -	io->in_bh = false;
> +	io->may_sleep = true;
>  
>  	verity_finish_io(io, errno_to_blk_status(verity_verify_io(io)));
>  }
>  
> -static void verity_bh_work(struct work_struct *w)
> +static void verity_verify_inline(struct work_struct *w)
>  {
> -	struct dm_verity_io *io = container_of(w, struct dm_verity_io, bh_work);
> +	struct dm_verity_io *io = container_of(w, struct dm_verity_io, inline_work);
>  	int err;
>  
> -	io->in_bh = true;
> +	/*
> +	 * Set may_sleep to false here regardless of the context for simplicity.
> +	 * This ensures that we do not try to read missing hashes in contexts
> +	 * where we should not block.
> +	 */
> +	io->may_sleep = false;
>  	err = verity_verify_io(io);
>  	if (err == -EAGAIN || err == -ENOMEM) {
>  		/* fallback to retrying with work-queue */
> @@ -596,10 +607,10 @@ static void verity_bh_work(struct work_struct *w)
>  	verity_finish_io(io, errno_to_blk_status(err));
>  }
>  
> -static inline bool verity_use_bh(unsigned int bytes, unsigned short ioprio)
> +static inline bool verity_should_verify_inline(unsigned int bytes, unsigned short ioprio)
>  {
>  	return ioprio <= IOPRIO_CLASS_IDLE &&
> -		bytes <= READ_ONCE(dm_verity_use_bh_bytes[ioprio]) &&
> +		bytes <= READ_ONCE(dm_verity_max_inline_size_bytes[ioprio]) &&
>  		!need_resched();
>  }
>  
> @@ -617,13 +628,13 @@ static void verity_end_io(struct bio *bio)
>  		return;
>  	}
>  
> -	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq &&
> -		verity_use_bh(bytes, ioprio)) {
> +	if (static_branch_unlikely(&inline_verification_enabled) && io->v->verify_inline &&
> +		verity_should_verify_inline(bytes, ioprio)) {
>  		if (in_hardirq() || irqs_disabled()) {
> -			INIT_WORK(&io->bh_work, verity_bh_work);
> -			queue_work(system_bh_wq, &io->bh_work);
> +			INIT_WORK(&io->inline_work, verity_verify_inline);
> +			queue_work(system_bh_wq, &io->inline_work);
>  		} else {
> -			verity_bh_work(&io->bh_work);
> +			verity_verify_inline(&io->inline_work);
>  		}
>  	} else {
>  		INIT_WORK(&io->work, verity_work);
> @@ -805,7 +816,7 @@ static void verity_status(struct dm_target *ti, status_type_t type,
>  			args++;
>  		if (v->validated_blocks)
>  			args++;
> -		if (v->use_bh_wq)
> +		if (v->verify_inline)
>  			args++;
>  		if (v->signature_key_desc)
>  			args += DM_VERITY_ROOT_HASH_VERIFICATION_OPTS;
> @@ -845,7 +856,7 @@ static void verity_status(struct dm_target *ti, status_type_t type,
>  			DMEMIT(" " DM_VERITY_OPT_IGN_ZEROES);
>  		if (v->validated_blocks)
>  			DMEMIT(" " DM_VERITY_OPT_AT_MOST_ONCE);
> -		if (v->use_bh_wq)
> +		if (v->verify_inline)
>  			DMEMIT(" " DM_VERITY_OPT_TASKLET_VERIFY);
>  		sz = verity_fec_status_table(v, sz, result, maxlen);
>  		if (v->signature_key_desc)
> @@ -1023,8 +1034,8 @@ static void verity_dtr(struct dm_target *ti)
>  
>  	kfree(v->signature_key_desc);
>  
> -	if (v->use_bh_wq)
> -		static_branch_dec(&use_bh_wq_enabled);
> +	if (v->verify_inline)
> +		static_branch_dec(&inline_verification_enabled);
>  
>  	kfree(v);
>  
> @@ -1194,8 +1205,8 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
>  			continue;
>  
>  		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
> -			v->use_bh_wq = true;
> -			static_branch_inc(&use_bh_wq_enabled);
> +			v->verify_inline = true;
> +			static_branch_inc(&inline_verification_enabled);
>  			continue;
>  
>  		} else if (verity_is_fec_opt_arg(arg_name)) {
> @@ -1526,7 +1537,7 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
>  		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
>  		dm_bufio_alloc_callback, NULL,
> -		v->use_bh_wq ? DM_BUFIO_CLIENT_NO_SLEEP : 0);
> +		v->verify_inline ? DM_BUFIO_CLIENT_NO_SLEEP : 0);
>  	if (IS_ERR(v->bufio)) {
>  		ti->error = "Cannot initialize dm-bufio";
>  		r = PTR_ERR(v->bufio);
> diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
> index 6d141abd965c..1a5233c92e54 100644
> --- a/drivers/md/dm-verity.h
> +++ b/drivers/md/dm-verity.h
> @@ -58,7 +58,7 @@ struct dm_verity {
>  	unsigned char levels;	/* the number of tree levels */
>  	unsigned char version;
>  	bool hash_failed:1;	/* set if hash of any block failed */
> -	bool use_bh_wq:1;	/* try to verify in BH wq before normal work-queue */
> +	bool verify_inline:1;	/* try to verify inline before normal work-queue */
>  	unsigned int digest_size;	/* digest size for the current hash algorithm */
>  	enum verity_mode mode;	/* mode for handling verification errors */
>  	enum verity_mode error_mode;/* mode for handling I/O errors */
> @@ -88,11 +88,15 @@ struct dm_verity_io {
>  
>  	sector_t block;
>  	unsigned int n_blocks;
> -	bool in_bh;
> +	/*
> +	 * Keeps track of whether the request is being processed in
> +	 * the kworker or inline.
> +	 */
> +	bool may_sleep;
>  	bool had_mismatch;
>  
>  	struct work_struct work;
> -	struct work_struct bh_work;
> +	struct work_struct inline_work;
>  
>  	u8 real_digest[HASH_MAX_DIGESTSIZE];
>  	u8 want_digest[HASH_MAX_DIGESTSIZE];
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 

