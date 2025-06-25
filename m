Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16E32D4B67
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 16:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869078; cv=none; b=j+QYAtnC3jUkEul9UFLk6e+Ysn8mv/0IGOxxPYqbpenjojKeZk921hpyxadKrbzR4fpnLxDDXqfGqN68RwIW0amqY5knDLELcqxN4uwNjIa2DeoHff7skyeU1Nf/vfYjjayYjb9Sh2HX0tZo/k1Y1OztXhMf7IdkYwAIOUTJ8mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869078; c=relaxed/simple;
	bh=DcVV/T8cztYxvRvFnkyze3vTfAzBA3dxMCVZT2Dxybw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DOyvqwdWY8419O2w2VDGQkWHWpFAYMN/7PdQ2aGCLi12nyh42I/dx0vD2t30YnHJvZD9XEeMZkQNYMgPJDeg5X9F8Imag4a3rH74noLJ6VhoU1dVOxSxxsluAcZI2O/tQtpoWhkkBAdveLOBh8kDJueEPOoH2ntVSHAz8Fkp5Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TiFSFFc3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TiFSFFc3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750869075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZtJBqwq5wZlT1Cguyt5dV46yY0O5gY+TvoWgP3fm6U=;
	b=TiFSFFc3gV0zR+1g5syRlZ5W3B6SwOERpMHsE6Is+I7oDaDW5pGtERf9nmaCLgvtRRFSr+
	LS8Ah+1L6Ev3E1Er4GTQcWb8qZGdXaZHMT77JodYcZuV8scsg4F1v2L0ZxalGGvf/u7TwF
	KPkOkc5oTxZ+9fDvmwQWddfN7IQ5JxE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-154-sTyQSQZkOdi-_XgnOZCk4Q-1; Wed,
 25 Jun 2025 12:31:13 -0400
X-MC-Unique: sTyQSQZkOdi-_XgnOZCk4Q-1
X-Mimecast-MFC-AGG-ID: sTyQSQZkOdi-_XgnOZCk4Q_1750869072
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79751180ABFC;
	Wed, 25 Jun 2025 16:31:09 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9569F180045B;
	Wed, 25 Jun 2025 16:31:07 +0000 (UTC)
Date: Wed, 25 Jun 2025 18:31:04 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
    dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 4/5] dm: dm-crypt: Do not partially accept write BIOs
 with zoned targets
In-Reply-To: <20250625093327.548866-5-dlemoal@kernel.org>
Message-ID: <574374f0-1ce5-ebc4-76ff-95c21b1ccc65@redhat.com>
References: <20250625093327.548866-1-dlemoal@kernel.org> <20250625093327.548866-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Wed, 25 Jun 2025, Damien Le Moal wrote:

> Read and write operations issued to a dm-crypt target may be split
> according to the dm-crypt internal limits defined by the max_read_size
> and max_write_size module parameters (default is 128 KB). The intent is
> to improve processing time of large BIOs by splitting them into smaller
> operations that can be parallelized on different CPUs.
> 
> For zoned dm-crypt targets, this BIO splitting is still done but without
> the parallel execution to ensure that the issuing order of write
> operations to the underlying devices remains sequential. However, the
> splitting itself causes other problems:
> 
> 1) Since dm-crypt relies on the block layer zone write plugging to
>    handle zone append emulation using regular write operations, the
>    reminder of a split write BIO will always be plugged into the target
>    zone write plugged. Once the on-going write BIO finishes, this
>    reminder BIO is unplugged and issued from the zone write plug work.
>    If this reminder BIO itself needs to be split, the reminder will be
>    re-issued and plugged again, but that causes a call to a
>    blk_queue_enter(), which may block if a queue freeze operation was
>    initiated. This results in a deadlock as DM submission still holds
>    BIOs that the queue freeze side is waiting for.
> 
> 2) dm-crypt relies on the emulation done by the block layer using
>    regular write operations for processing zone append operations. This
>    still requires to properly return the written sector as the BIO
>    sector of the original BIO. However, this can be done correctly only
>    and only if there is a single clone BIO used for processing the
>    original zone append operation issued by the user. If the size of a
>    zone append operation is larger than dm-crypt max_write_size, then
>    the orginal BIO will be split and processed as a chain of regular
>    write operations. Such chaining result in an incorrect written sector
>    being returned to the zone append issuer using the original BIO
>    sector.  This in turn results in file system data corruptions using
>    xfs or btrfs.
> 
> Fix this by modifying get_max_request_size() to always return the size
> of the BIO to avoid it being split with dm_accpet_partial_bio() in
> crypt_map(). get_max_request_size() is renamed to
> get_max_request_sectors() to clarify the unit of the value returned
> and its interface is changed to take a struct dm_target pointer and a
> pointer to the struct bio being processed. In addition to this change,
> to ensure that crypt_alloc_buffer() works correctly, set the dm-crypt
> device max_hw_sectors limit to be at most
> BIO_MAX_VECS << PAGE_SECTORS_SHIFT (1 MB with a 4KB page architecture).
> This forces DM core to split write BIOs before passing them to
> crypt_map(), and thus guaranteeing that dm-crypt can always accept an
> entire write BIO without needing to split it.
> 
> This change does not have any effect on the read path of dm-crypt. Read
> operations can still be split and the BIO fragments processed in
> parallel. There is also no impact on the performance of the write path
> given that all zone write BIOs were already processed inline instead of
> in parallel.
> 
> This change also does not affect in any way regular dm-crypt block
> devices.
> 
> Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-crypt.c | 49 ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 39 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 17157c4216a5..4e80784d1734 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -253,17 +253,35 @@ MODULE_PARM_DESC(max_read_size, "Maximum size of a read request");
>  static unsigned int max_write_size = 0;
>  module_param(max_write_size, uint, 0644);
>  MODULE_PARM_DESC(max_write_size, "Maximum size of a write request");
> -static unsigned get_max_request_size(struct crypt_config *cc, bool wrt)
> +
> +static unsigned get_max_request_sectors(struct dm_target *ti, struct bio *bio)
>  {
> +	struct crypt_config *cc = ti->private;
>  	unsigned val, sector_align;
> -	val = !wrt ? READ_ONCE(max_read_size) : READ_ONCE(max_write_size);
> -	if (likely(!val))
> -		val = !wrt ? DM_CRYPT_DEFAULT_MAX_READ_SIZE : DM_CRYPT_DEFAULT_MAX_WRITE_SIZE;
> -	if (wrt || cc->used_tag_size) {
> -		if (unlikely(val > BIO_MAX_VECS << PAGE_SHIFT))
> -			val = BIO_MAX_VECS << PAGE_SHIFT;
> -	}
> -	sector_align = max(bdev_logical_block_size(cc->dev->bdev), (unsigned)cc->sector_size);
> +	bool wrt = op_is_write(bio_op(bio));
> +
> +	if (wrt) {
> +		/*
> +		 * For zoned devices, splitting write operations creates the
> +		 * risk of deadlocking queue freeze operations with zone write
> +		 * plugging BIO work when the reminder of a split BIO is
> +		 * issued. So always allow the entire BIO to proceed.
> +		 */
> +		if (ti->emulate_zone_append)
> +			return bio_sectors(bio);
> +
> +		val = min_not_zero(READ_ONCE(max_write_size),
> +				   DM_CRYPT_DEFAULT_MAX_WRITE_SIZE);
> +	} else {
> +		val = min_not_zero(READ_ONCE(max_read_size),
> +				   DM_CRYPT_DEFAULT_MAX_READ_SIZE);
> +	}
> +
> +	if (wrt || cc->used_tag_size)
> +		val = min(val, BIO_MAX_VECS << PAGE_SHIFT);
> +
> +	sector_align = max(bdev_logical_block_size(cc->dev->bdev),
> +			   (unsigned)cc->sector_size);
>  	val = round_down(val, sector_align);
>  	if (unlikely(!val))
>  		val = sector_align;
> @@ -3496,7 +3514,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  	/*
>  	 * Check if bio is too large, split as needed.
>  	 */
> -	max_sectors = get_max_request_size(cc, bio_data_dir(bio) == WRITE);
> +	max_sectors = get_max_request_sectors(ti, bio);
>  	if (unlikely(bio_sectors(bio) > max_sectors))
>  		dm_accept_partial_bio(bio, max_sectors);
>  
> @@ -3733,6 +3751,17 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
>  	limits->io_min = max_t(unsigned int, limits->io_min, cc->sector_size);
>  	limits->dma_alignment = limits->logical_block_size - 1;
> +
> +	/*
> +	 * For zoned dm-crypt targets, there will be no internal splitting of
> +	 * write BIOs to avoid exceeding BIO_MAX_VECS vectors per BIO. But
> +	 * without respecting this limit, crypt_alloc_buffer() will trigger a
> +	 * BUG(). Avoid this by forcing DM core to split write BIOs to this
> +	 * limit.
> +	 */
> +	if (ti->emulate_zone_append)
> +		limits->max_hw_sectors = min(limits->max_hw_sectors,
> +					     BIO_MAX_VECS << PAGE_SECTORS_SHIFT);
>  }
>  
>  static struct target_type crypt_target = {
> -- 
> 2.49.0
> 

