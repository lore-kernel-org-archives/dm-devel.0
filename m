Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015D314037F
	for <dm-devel@lists.linux.dev>; Mon,  3 Feb 2025 20:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738613857; cv=none; b=Wo4LZe/h75T1D5ocrPA8mvhNi9YOYv0iO3DzMJVT3LePLz6PkIROla2eQKIK/Nhak/Vy2RUzntdJm1UoDv/58KYNfnzyTCsrieZMcsk+spykZheSPQt/OuH8Mp6DiPGwHALZtgLwt2MTvKvZGNTq6V0I9hAX423a32yx31F1t+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738613857; c=relaxed/simple;
	bh=PyioCnq/JMJkRIL69bSycxrE6Wtoc20EqGZBp9AeUaw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kYA7B+zgwJAQ2FPP2g3QMWs4EJt1RQC1YxfULcLW6cH6bDiWgNClIyb9mkJI0D7W8pAm+bwZk3+K+T9vXDe/iVxqI8y4K9X8mwGq+Bt/PDRdGX3cUut/I5GwXBJzhcua3VdBBPyssb+HrjJXVfoYvCvJ1vJGb5pUnK8o+05EpEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJCbog9l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJCbog9l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738613853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=msp8A+i2BKS4EFWKdaMvMmBFxzrfRJfs0UIePiNzDAk=;
	b=aJCbog9l9it3K8wl1kJCLODi1DvPaVTxkkfHLHnsVX4c+p3I7yPdbIFlY4rF2jUKcwR+N4
	XmfzaIRDmdTYe8L64A7NNPxqlRWENnTGEj2Cmj4fWnV8JrxZXU+RViMbY+FKsl0irJ7p7/
	g/eOeTviUFB6NNz15ZzRUvahsQvr8+k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-xuWwA42oPA2h9GPcViUNwA-1; Mon,
 03 Feb 2025 15:17:30 -0500
X-MC-Unique: xuWwA42oPA2h9GPcViUNwA-1
X-Mimecast-MFC-AGG-ID: xuWwA42oPA2h9GPcViUNwA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95E301801F1C;
	Mon,  3 Feb 2025 20:17:28 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17EFF19560AD;
	Mon,  3 Feb 2025 20:17:25 +0000 (UTC)
Date: Mon, 3 Feb 2025 21:17:21 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Harald Freudenberger <freude@linux.ibm.com>
cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com, agk@redhat.com, 
    snitzer@kernel.org, linux-s390@vger.kernel.org, dm-devel@lists.linux.dev, 
    herbert@gondor.apana.org.au
Subject: Re: [PATCH v3 2/2] dm-integrity: introduce ahash support for the
 internal hash
In-Reply-To: <20250131100304.932064-3-freude@linux.ibm.com>
Message-ID: <1743b5fc-f401-c416-5733-6757bda963ca@redhat.com>
References: <20250131100304.932064-1-freude@linux.ibm.com> <20250131100304.932064-3-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi

I looked at the patch and found two problems:

1. dm_integrity_end_io may be called in an interrupt context, so it 
shouldn't call the ahash version of integrity_sector_checksum. It should 
call the shash version. So, the shash version should be available even 
when using ahash.

2. There's a problem with memory allocation. You shouldn't allocate any 
memory from I/O processing path. Suppose that the user is swapping to a 
swap device that is backed by dm-integrity. If the system runs out of 
memory, it attempts to write some pages to the swap device, this triggers 
memory allocation (see ahash_request_alloc and kmalloc in your patch). 
This memory allocation will wait until some memory is available, causing a 
deadlock.

"sector_le = kmalloc(sizeof(__le64), GFP_KERNEL);"

- this field may be moved to the struct dm_integrity_io, you don't need to 
allocate it at all. Note that struct dm_integrity_io is already allocated 
from a mempool, so there is forward progress guarantee even if the system 
has no free memory.

"req = ahash_request_alloc(ic->internal_ahash, GFP_KERNEL);"

- this may be moved after struct dm_integrity_io. I.e. change:
"ti->per_io_data_size = sizeof(struct dm_integrity_io)" to
"ti->per_io_data_size = sizeof(struct dm_integrity_io) + sizeof(struct 
ahash_request) + crypto_ahash_reqsize(tfm)".

Then, instead of calling "req = ahash_request_alloc", you can do
req = (struct ahash_request *)(dio + 1);

integrity_sector_checksum is also called from code where there is no 
associated "dm_integrity_io" (such as integrity_recalc_inline, 
integrity_recalc) - in this situation, you can preallocate a dummy 
dm_integrity_io structure before you take any locks (i.e. "dio = 
kmalloc(sizeof(struct dm_integrity_io) + sizeof(struct ahash_request) + 
crypto_ahash_reqsize(tfm), GFP_NOIO)". If you allocated it while holding 
the range lock, the deadlock may be possible.

Another place where integrity_sector_checksum is called without 
"dm_integrity_io" is do_journal_write - in this case, you can use the 
synchronous hash version because it is not performance-critical.

Please, send a new version of your patch where these problems are fixed.

Also, test your patch with the cryptsetup testsuite - download it with 
"git clone https://gitlab.com/cryptsetup/cryptsetup" and run "./autogen.sh 
&& ./configure && make && make check". Make sure that the ahash interface 
is preferred while testing - so that you can catch bugs like scheduling in 
interrupt that happens in dm_integrity_end_io (I'm not sure if the 
testsuite tests the 'Inline' mode of dm-integrity; maybe not).

Mikulas


On Fri, 31 Jan 2025, Harald Freudenberger wrote:

> Introduce ahash support for the "internal hash" algorithm.
> 
> Rework the dm-integrity code to be able to run the "internal hash"
> either with a synchronous ("shash") or asynchronous ("ahash") hash
> algorithm implementation.
> 
> The get_mac() function now tries to decide which of the digest
> implemenations to use if there is a choice:
> - If an ahash and shash tfm is available and both are backed by the
>   same driver name it is assumed that the shash is the faster
>   implementation and thus the shash tfm is delivered to the caller.
> - If an ahash and shash tfm is available but the backing device driver
>   divers (different driver names) it is assumed that the ahash
>   implementation is a "better" hardware based implementation and thus
>   the ahash tfm is delivered to the caller.
> - If there is no choice, for example only an ahash or an shash
>   implementation is available then this tfm is delivered to the
>   caller. Especially in cases where only an ahash implementation is
>   available this is now used instead of failing.
> - The caller can steer this choice by passing a NULL to the ahash or
>   shash parameter, thus enforcing to only allocate an algorithm of the
>   remaining possibility.
> 
> The function integrity_sector_checksum() is now only a dispatcher
> function calling one of the two new functions
> integrity_ahash_sector_checksum() or integrity_shash_sector_checksum()
> based on which tfm is allocated based on the two new fields
> internal_shash and internal_ahash in struct dm_integrity_c.
> 
> Together with this comes some slight rework around availability and
> digest size of the internal hash in use.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> ---
>  drivers/md/dm-integrity.c | 221 +++++++++++++++++++++++++++++---------
>  1 file changed, 172 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 9ab0f0836c86..418bdc57054b 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -221,7 +221,9 @@ struct dm_integrity_c {
>  
>  	int failed;
>  
> -	struct crypto_shash *internal_hash;
> +	bool have_internal_hash;
> +	struct crypto_shash *internal_shash;
> +	struct crypto_ahash *internal_ahash;
>  	unsigned int internal_hash_digestsize;
>  
>  	struct dm_target *ti;
> @@ -1635,57 +1637,128 @@ static void integrity_end_io(struct bio *bio)
>  	dec_in_flight(dio);
>  }
>  
> -static void integrity_sector_checksum(struct dm_integrity_c *ic, sector_t sector,
> -				      const char *data, char *result)
> +static bool integrity_shash_sector_checksum(struct dm_integrity_c *ic,
> +					    sector_t sector, const char *data,
> +					    char *result)
>  {
>  	__le64 sector_le = cpu_to_le64(sector);
> -	SHASH_DESC_ON_STACK(req, ic->internal_hash);
> +	SHASH_DESC_ON_STACK(req, ic->internal_shash);
>  	int r;
> -	unsigned int digest_size;
>  
> -	req->tfm = ic->internal_hash;
> +	req->tfm = ic->internal_shash;
>  
>  	r = crypto_shash_init(req);
>  	if (unlikely(r < 0)) {
>  		dm_integrity_io_error(ic, "crypto_shash_init", r);
> -		goto failed;
> +		return false;
>  	}
>  
>  	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
>  		r = crypto_shash_update(req, (__u8 *)&ic->sb->salt, SALT_SIZE);
>  		if (unlikely(r < 0)) {
>  			dm_integrity_io_error(ic, "crypto_shash_update", r);
> -			goto failed;
> +			return false;
>  		}
>  	}
>  
>  	r = crypto_shash_update(req, (const __u8 *)&sector_le, sizeof(sector_le));
>  	if (unlikely(r < 0)) {
>  		dm_integrity_io_error(ic, "crypto_shash_update", r);
> -		goto failed;
> +		return false;
>  	}
>  
>  	r = crypto_shash_update(req, data, ic->sectors_per_block << SECTOR_SHIFT);
>  	if (unlikely(r < 0)) {
>  		dm_integrity_io_error(ic, "crypto_shash_update", r);
> -		goto failed;
> +		return false;
>  	}
>  
>  	r = crypto_shash_final(req, result);
>  	if (unlikely(r < 0)) {
>  		dm_integrity_io_error(ic, "crypto_shash_final", r);
> -		goto failed;
> +		return false;
>  	}
>  
> -	digest_size = ic->internal_hash_digestsize;
> -	if (unlikely(digest_size < ic->tag_size))
> -		memset(result + digest_size, 0, ic->tag_size - digest_size);
> +	if (unlikely(ic->internal_hash_digestsize < ic->tag_size))
> +		memset(result + ic->internal_hash_digestsize,
> +		       0, ic->tag_size - ic->internal_hash_digestsize);
>  
> -	return;
> +	return true;
> +}
> +
> +static bool integrity_ahash_sector_checksum(struct dm_integrity_c *ic,
> +					    sector_t sector, const char *data,
> +					    char *result)
> +{
> +	struct ahash_request *req = NULL;
> +	struct scatterlist sg[3], *s;
> +	DECLARE_CRYPTO_WAIT(wait);
> +	__le64 *sector_le = NULL;
> +	unsigned int nbytes = 0;
> +	int r = -ENOMEM;
> +
> +	req = ahash_request_alloc(ic->internal_ahash, GFP_KERNEL);
> +	if (unlikely(!req)) {
> +		dm_integrity_io_error(ic, "ahash_request_alloc", r);
> +		return false;
> +	}
> +	ahash_request_set_callback(req, 0, crypto_req_done, &wait);
> +
> +	s = sg;
> +	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
> +		sg_init_table(sg, 3);
> +		sg_set_buf(s, (const __u8 *)&ic->sb->salt, SALT_SIZE);
> +		nbytes += SALT_SIZE;
> +		s++;
> +	} else {
> +		sg_init_table(sg, 2);
> +	}
> +
> +	sector_le = kmalloc(sizeof(__le64), GFP_KERNEL);
> +	if (unlikely(!sector_le)) {
> +		dm_integrity_io_error(ic, "kmalloc(sizeof(__le64))", r);
> +		goto out;
> +	}
> +	*sector_le = cpu_to_le64(sector);
> +	sg_set_buf(s, (const __u8 *)sector_le, sizeof(*sector_le));
> +	nbytes += sizeof(*sector_le);
> +	s++;
> +
> +	sg_set_buf(s, data, ic->sectors_per_block << SECTOR_SHIFT);
> +	nbytes += ic->sectors_per_block << SECTOR_SHIFT;
> +
> +	ahash_request_set_crypt(req, sg, result, nbytes);
> +
> +	r = crypto_wait_req(crypto_ahash_digest(req), &wait);
> +	if (r) {
> +		dm_integrity_io_error(ic, "crypto_ahash_digest", r);
> +		goto out;
> +	}
> +
> +	if (unlikely(ic->internal_hash_digestsize < ic->tag_size))
> +		memset(result + ic->internal_hash_digestsize,
> +		       0, ic->tag_size - ic->internal_hash_digestsize);
>  
> -failed:
> -	/* this shouldn't happen anyway, the hash functions have no reason to fail */
> -	get_random_bytes(result, ic->tag_size);
> +out:
> +	ahash_request_free(req);
> +	kfree(sector_le);
> +
> +	return r ? false : true;
> +}
> +
> +static void integrity_sector_checksum(struct dm_integrity_c *ic,
> +				      sector_t sector, const char *data,
> +				      char *result)
> +{
> +	bool r;
> +
> +	if (likely(ic->internal_shash))
> +		r = integrity_shash_sector_checksum(ic, sector, data, result);
> +	else
> +		r = integrity_ahash_sector_checksum(ic, sector, data, result);
> +
> +	if (unlikely(!r))
> +		get_random_bytes(result, ic->tag_size);
>  }
>  
>  static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checksum)
> @@ -1774,7 +1847,7 @@ static void integrity_metadata(struct work_struct *w)
>  
>  	int r;
>  
> -	if (ic->internal_hash) {
> +	if (ic->have_internal_hash) {
>  		struct bvec_iter iter;
>  		struct bio_vec bv;
>  		unsigned int digest_size = ic->internal_hash_digestsize;
> @@ -1992,7 +2065,7 @@ static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
>  		return DM_MAPIO_KILL;
>  
>  	bip = bio_integrity(bio);
> -	if (!ic->internal_hash) {
> +	if (!ic->have_internal_hash) {
>  		if (bip) {
>  			unsigned int wanted_tag_size = bio_sectors(bio) >> ic->sb->log2_sectors_per_block;
>  
> @@ -2073,7 +2146,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
>  					mem_ptr += 1 << SECTOR_SHIFT;
>  				} while (++s < ic->sectors_per_block);
>  #ifdef INTERNAL_VERIFY
> -				if (ic->internal_hash) {
> +				if (ic->have_internal_hash) {
>  					char checksums_onstack[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
>  
>  					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
> @@ -2087,7 +2160,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
>  #endif
>  			}
>  
> -			if (!ic->internal_hash) {
> +			if (!ic->have_internal_hash) {
>  				struct bio_integrity_payload *bip = bio_integrity(bio);
>  				unsigned int tag_todo = ic->tag_size;
>  				char *tag_ptr = journal_entry_tag(ic, je);
> @@ -2124,7 +2197,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
>  					je->last_bytes[s] = js[s].commit_id;
>  				} while (++s < ic->sectors_per_block);
>  
> -				if (ic->internal_hash) {
> +				if (ic->have_internal_hash) {
>  					unsigned int digest_size = ic->internal_hash_digestsize;
>  
>  					if (unlikely(digest_size > ic->tag_size)) {
> @@ -2187,7 +2260,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
>  	sector_t recalc_sector;
>  	struct completion read_comp;
>  	bool discard_retried = false;
> -	bool need_sync_io = ic->internal_hash && dio->op == REQ_OP_READ;
> +	bool need_sync_io = ic->have_internal_hash && dio->op == REQ_OP_READ;
>  
>  	if (unlikely(dio->op == REQ_OP_DISCARD) && ic->mode != 'D')
>  		need_sync_io = true;
> @@ -2908,7 +2981,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned int write_start
>  #ifndef INTERNAL_VERIFY
>  				    unlikely(from_replay) &&
>  #endif
> -				    ic->internal_hash) {
> +				    ic->have_internal_hash) {
>  					char test_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
>  
>  					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
> @@ -3905,7 +3978,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
>  		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
>  	}
>  
> -	if (!ic->internal_hash) {
> +	if (!ic->have_internal_hash) {
>  		struct blk_integrity *bi = &limits->integrity;
>  
>  		memset(bi, 0, sizeof(*bi));
> @@ -4213,32 +4286,76 @@ static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, ch
>  	return -ENOMEM;
>  }
>  
> -static int get_mac(struct crypto_shash **hash, struct alg_spec *a, char **error,
> +static int get_mac(struct crypto_shash **shash, struct crypto_ahash **ahash,
> +		   struct alg_spec *a, char **error,
>  		   char *error_alg, char *error_key)
>  {
> +	const char *ahash_driver_name = NULL;
>  	int r;
>  
> -	if (a->alg_string) {
> -		*hash = crypto_alloc_shash(a->alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
> -		if (IS_ERR(*hash)) {
> +	if (!a->alg_string || !(shash || ahash))
> +		return 0;
> +
> +	if (ahash) {
> +		*ahash = crypto_alloc_ahash(a->alg_string, 0, 0);
> +		if (IS_ERR(*ahash)) {
>  			*error = error_alg;
> -			r = PTR_ERR(*hash);
> -			*hash = NULL;
> +			r = PTR_ERR(*ahash);
> +			*ahash = NULL;
>  			return r;
>  		}
> +		ahash_driver_name = crypto_ahash_driver_name(*ahash);
> +	}
>  
> -		if (a->key) {
> -			r = crypto_shash_setkey(*hash, a->key, a->key_size);
> -			if (r) {
> -				*error = error_key;
> -				return r;
> +	if (shash) {
> +		*shash = crypto_alloc_shash(a->alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
> +		if (IS_ERR(*shash) && !ahash_driver_name) {
> +			*error = error_alg;
> +			r = PTR_ERR(*shash);
> +			*shash = NULL;
> +			return r;
> +		}
> +		if (!IS_ERR(shash) && ahash_driver_name) {
> +			if (strcmp(crypto_shash_driver_name(*shash), ahash_driver_name)) {
> +				/*
> +				 * ahash gave a different driver than shash, so probably
> +				 * this is a case of real hardware offload.  Use ahash.
> +				 */
> +				crypto_free_shash(*shash);
> +				*shash = NULL;
> +			} else {
> +				/* ahash and shash are same driver. Use shash. */
> +				crypto_free_ahash(*ahash);
> +				*ahash = NULL;
>  			}
> -		} else if (crypto_shash_get_flags(*hash) & CRYPTO_TFM_NEED_KEY) {
> +		}
> +	}
> +
> +	/* either *ahash or *shash is set now */
> +
> +	if (a->key) {
> +		r = shash && *shash ?
> +			crypto_shash_setkey(*shash, a->key, a->key_size) :
> +			crypto_ahash_setkey(*ahash, a->key, a->key_size);
> +		if (r) {
>  			*error = error_key;
> -			return -ENOKEY;
> +			return r;
>  		}
> +	} else if ((shash && *shash ?
> +		    crypto_shash_get_flags(*shash) :
> +		    crypto_ahash_get_flags(*ahash))
> +		   & CRYPTO_TFM_NEED_KEY) {
> +		*error = error_key;
> +		return -ENOKEY;
>  	}
>  
> +	pr_debug("Using %s %s (driver name %s)\n",
> +		 ahash && *ahash ? "ahash" : "shash",
> +		 a->alg_string,
> +		 ahash && *ahash ?
> +		 crypto_ahash_driver_name(*ahash) :
> +		 crypto_shash_driver_name(*shash));
> +
>  	return 0;
>  }
>  
> @@ -4693,20 +4810,24 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
>  		buffer_sectors = 1;
>  	ic->log2_buffer_sectors = min((int)__fls(buffer_sectors), 31 - SECTOR_SHIFT);
>  
> -	r = get_mac(&ic->internal_hash, &ic->internal_hash_alg, &ti->error,
> +	r = get_mac(&ic->internal_shash, &ic->internal_ahash,
> +		    &ic->internal_hash_alg, &ti->error,
>  		    "Invalid internal hash", "Error setting internal hash key");
>  	if (r)
>  		goto bad;
> -	if (ic->internal_hash)
> -		ic->internal_hash_digestsize = crypto_shash_digestsize(ic->internal_hash);
> +	ic->have_internal_hash = ic->internal_shash || ic->internal_ahash;
> +	if (ic->have_internal_hash)
> +		ic->internal_hash_digestsize = ic->internal_shash ?
> +			crypto_shash_digestsize(ic->internal_shash) :
> +			crypto_ahash_digestsize(ic->internal_ahash);
>  
> -	r = get_mac(&ic->journal_mac, &ic->journal_mac_alg, &ti->error,
> +	r = get_mac(&ic->journal_mac, NULL, &ic->journal_mac_alg, &ti->error,
>  		    "Invalid journal mac", "Error setting journal mac key");
>  	if (r)
>  		goto bad;
>  
>  	if (!ic->tag_size) {
> -		if (!ic->internal_hash) {
> +		if (!ic->have_internal_hash) {
>  			ti->error = "Unknown tag size";
>  			r = -EINVAL;
>  			goto bad;
> @@ -4770,13 +4891,13 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
>  		}
>  	}
>  
> -	if (ic->mode == 'B' && !ic->internal_hash) {
> +	if (ic->mode == 'B' && !ic->have_internal_hash) {
>  		r = -EINVAL;
>  		ti->error = "Bitmap mode can be only used with internal hash";
>  		goto bad;
>  	}
>  
> -	if (ic->discard && !ic->internal_hash) {
> +	if (ic->discard && !ic->have_internal_hash) {
>  		r = -EINVAL;
>  		ti->error = "Discard can be only used with internal hash";
>  		goto bad;
> @@ -5038,7 +5159,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
>  		ic->sb->recalc_sector = cpu_to_le64(0);
>  	}
>  
> -	if (ic->internal_hash) {
> +	if (ic->have_internal_hash) {
>  		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
>  		if (!ic->recalc_wq) {
>  			ti->error = "Cannot allocate workqueue";
> @@ -5229,8 +5350,10 @@ static void dm_integrity_dtr(struct dm_target *ti)
>  	if (ic->sb)
>  		free_pages_exact(ic->sb, SB_SECTORS << SECTOR_SHIFT);
>  
> -	if (ic->internal_hash)
> -		crypto_free_shash(ic->internal_hash);
> +	if (ic->internal_shash)
> +		crypto_free_shash(ic->internal_shash);
> +	if (ic->internal_ahash)
> +		crypto_free_ahash(ic->internal_ahash);
>  	free_alg(&ic->internal_hash_alg);
>  
>  	if (ic->journal_crypt)
> -- 
> 2.43.0
> 

