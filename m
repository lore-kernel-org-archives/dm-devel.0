Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59DA20DF4
	for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 16:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716394222; cv=none; b=dwbXOpVd518fUolkX9YmdF5l3cbdu9MN0D1Dw9vJq/gdQPFi7iYM9Oq+PlFnCd3Db0IIgKjmRCxqRd9h3sVl4CrWV8ARX5QQuzYyl0LRyxxBW2x5S0DlNIyT8l15k7f8iKl3jCDh8FNz5CKjQL4Z3ffWyIcbOduMBy1dZAb/esk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716394222; c=relaxed/simple;
	bh=vIA3o5CDNg2W1Q7Es/uuPPV0r3thdTYoBWXCd12Z1w8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivHfkTI9BOoaa0ooi8O7iLuBvYhfS1IzmNK7kXj8XZVpAx2IUHSqBtkGTPzzRS+vSeY4UbGjWQY45n5+ZTyg5MbfrHRhDPHIkb4qcuDt+IhSHLh6CFtF57Jkhh7GIQOUDCBcckSm7lKUwBucnWRupU9k1Y4jpWKTptMi6NWv3QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6a8691d736cso7490146d6.0
        for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 09:10:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716394219; x=1716999019;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pnUnYOodm15w+vcbjW3XrSJhRreyDxJQSwZnRb8cVP0=;
        b=PSXyebCimmA/ugtsfI5ZS7Qg3SK0G8hB+Y1k4NfyZBts8WnE/L9Wq1SVcmSgBAlgY5
         M1xIOHym1ql/oogG8sTIeJcWqiTdSmCwYdTwKZklgQ393R1Q48E4yJswyKjs1ISFxUO9
         b6XbL5wwkWExA8YJPUZ/wmHRhAPxjkpgR9i2Y5TSElOPcOYHUNpvFnlPHno3Ho5TH/td
         jF6wCmMV3RJpnqRVC4JaatZ8rlvXtDQRYuVkb1zioFhEbg3WsrPQP1Lcf+j9J36Ar/Rt
         Sd7OASuYKzm/iWo3HGKHOdzeHkpfBbxPT5lahRRJ48RO0ZXZsH+u4Is3J9H1hn9QeXOR
         Qy3w==
X-Forwarded-Encrypted: i=1; AJvYcCV6LZHL5bPSOeIRbmxz/39p7vYmtqtTPJ4HP+SqG8hszkNtixkYuZJyr0S+CzvROZMUxf/7eoGrNz/i9GlMgvoZwPzBcsYGCR8=
X-Gm-Message-State: AOJu0YwjeG17YTX7BdhiysCkNMNn0Xf8WmqpLzzZPcGK8adtcHtFyARG
	mdKJpm3F3CKfOrSIczJQFoNAxKa56COkcFarav5dkyqKiEfLH+xAeI5oQdqvEYuR1QBc/YS9ppW
	IthWIdw==
X-Google-Smtp-Source: AGHT+IGvT/RPF8joSYz7Z55ErMWVmiFrPIpbi5XcMJQVWlYahMVe5C7vSV9FYIsjR9dcEoJU1BrTDA==
X-Received: by 2002:ad4:5942:0:b0:6ab:7b2a:c922 with SMTP id 6a1803df08f44-6ab7b2acc9bmr58159796d6.7.1716394218527;
        Wed, 22 May 2024 09:10:18 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7930b43aaccsm642907585a.114.2024.05.22.09.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 09:10:18 -0700 (PDT)
Date: Wed, 22 May 2024 12:10:16 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Yang Yang <yang.yang@vivo.com>, Alasdair Kergon <agk@redhat.com>,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: dm: optimize flushes
Message-ID: <Zk4Y6DMgK71UuoKd@kernel.org>
References: <20240514090445.2847-1-yang.yang@vivo.com>
 <20240514090445.2847-4-yang.yang@vivo.com>
 <ZkTXzG1yrPmW64Z6@redhat.com>
 <60bd4b9-8edd-7e22-ce8b-e5d0e43da195@redhat.com>
 <90f4beb-2e15-3f9-4bc2-0d13872e8ea@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90f4beb-2e15-3f9-4bc2-0d13872e8ea@redhat.com>

On Thu, May 16, 2024 at 10:49:55PM +0200, Mikulas Patocka wrote:
> Device mapper sends flush bios to all the targets and the targets send it
> to the underlying device. That may be inefficient, for example if a table
> contains 10 linear targets pointing to the same physical device, then
> device mapper would send 10 flush bios to that device - despite the fact
> that only one bio would be sufficient.
> 
> This commit optimizes the flush behavior. It introduces a per-target
> variable flush_pass_around - it is set when the target supports flush
> optimization - currently, the dm-linear and dm-stripe targets support it.
> When all the targets in a table have flush_pass_around, flush_pass_around
> on the table is set. __send_empty_flush tests if the table has
> flush_pass_around - and if it has, no flush bios are sent to the targets
> and the list dm_table->devices is iterated and the flush bios are sent to
> each member of the list.

What does "pass around" mean?  Seems like an awkward name for this.
(Naming can be hard, I don't have better suggestions at the moment.)

> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Yang Yang <yang.yang@vivo.com>
> 
> ---
>  drivers/md/dm-core.h          |    4 ++-
>  drivers/md/dm-linear.c        |    1 
>  drivers/md/dm-stripe.c        |    1 
>  drivers/md/dm-table.c         |    4 +++
>  drivers/md/dm.c               |   47 +++++++++++++++++++++++++++++-------------
>  include/linux/device-mapper.h |    5 ++++
>  6 files changed, 47 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-core.h
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-core.h	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm-core.h	2024-05-15 16:56:49.000000000 +0200
> @@ -206,7 +206,9 @@ struct dm_table {
>  
>  	bool integrity_supported:1;
>  	bool singleton:1;
> -	unsigned integrity_added:1;
> +	bool integrity_added:1;
> +	/* set if all the targets in the table have "flush_pass_around" set */
> +	bool flush_pass_around:1;
>  
>  	/*
>  	 * Indicates the rw permissions for the new logical device.  This
> Index: linux-2.6/drivers/md/dm-linear.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-linear.c	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm-linear.c	2024-05-15 16:56:49.000000000 +0200
> @@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *
>  	ti->num_discard_bios = 1;
>  	ti->num_secure_erase_bios = 1;
>  	ti->num_write_zeroes_bios = 1;
> +	ti->flush_pass_around = true;
>  	ti->private = lc;
>  	return 0;
>  
> Index: linux-2.6/drivers/md/dm-stripe.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-stripe.c	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm-stripe.c	2024-05-15 16:56:49.000000000 +0200
> @@ -157,6 +157,7 @@ static int stripe_ctr(struct dm_target *
>  	ti->num_discard_bios = stripes;
>  	ti->num_secure_erase_bios = stripes;
>  	ti->num_write_zeroes_bios = stripes;
> +	ti->flush_pass_around = true;
>  
>  	sc->chunk_size = chunk_size;
>  	if (chunk_size & (chunk_size - 1))
> Index: linux-2.6/drivers/md/dm-table.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-table.c	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm-table.c	2024-05-15 16:56:49.000000000 +0200
> @@ -160,6 +160,7 @@ int dm_table_create(struct dm_table **re
>  	t->type = DM_TYPE_NONE;
>  	t->mode = mode;
>  	t->md = md;
> +	t->flush_pass_around = 1;
>  	*result = t;
>  	return 0;
>  }

Should be: t->flush_pass_around = true;

> @@ -738,6 +739,9 @@ int dm_table_add_target(struct dm_table
>  	if (ti->limit_swap_bios && !static_key_enabled(&swap_bios_enabled.key))
>  		static_branch_enable(&swap_bios_enabled);
>  
> +	if (!ti->flush_pass_around)
> +		t->flush_pass_around = false;
> +
>  	return 0;
>  
>   bad:
> Index: linux-2.6/include/linux/device-mapper.h
> ===================================================================
> --- linux-2.6.orig/include/linux/device-mapper.h	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/include/linux/device-mapper.h	2024-05-15 16:56:49.000000000 +0200
> @@ -397,6 +397,11 @@ struct dm_target {
>  	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
>  	 */
>  	bool needs_bio_set_dev:1;
> +
> +	/*
> +	 * Set if the target supports flush optimization
> +	 */
> +	bool flush_pass_around:1;
>  };

How does a developer _know_ if a target can set this flag?  Please
elaborate on the requirements in this code comment.

>  
>  void *dm_per_bio_data(struct bio *bio, size_t data_size);
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm.c	2024-05-16 20:06:32.000000000 +0200
> @@ -645,7 +645,7 @@ static struct bio *alloc_tio(struct clon
>  
>  	/* Set default bdev, but target must bio_set_dev() before issuing IO */
>  	clone->bi_bdev = md->disk->part0;
> -	if (unlikely(ti->needs_bio_set_dev))
> +	if (likely(ti != NULL) && unlikely(ti->needs_bio_set_dev))
>  		bio_set_dev(clone, md->disk->part0);
>  
>  	if (len) {
> @@ -1107,7 +1107,7 @@ static void clone_endio(struct bio *bio)
>  	blk_status_t error = bio->bi_status;
>  	struct dm_target_io *tio = clone_to_tio(bio);
>  	struct dm_target *ti = tio->ti;
> -	dm_endio_fn endio = ti->type->end_io;
> +	dm_endio_fn endio = likely(ti != NULL) ? ti->type->end_io : NULL;
>  	struct dm_io *io = tio->io;
>  	struct mapped_device *md = io->md;
>  
> @@ -1154,7 +1154,7 @@ static void clone_endio(struct bio *bio)
>  	}
>  
>  	if (static_branch_unlikely(&swap_bios_enabled) &&
> -	    unlikely(swap_bios_limit(ti, bio)))
> +	    likely(ti != NULL) && unlikely(swap_bios_limit(ti, bio)))
>  		up(&md->swap_bios_semaphore);
>  
>  	free_tio(bio);

What is it about this commit that makes it important to verify ti
isn't NULL in the above 3 hunks?

Should these NULL checks be factored out as a separate fix?

Or can these hunks be dropped?

> @@ -1566,17 +1566,36 @@ static void __send_empty_flush(struct cl
>  	ci->sector_count = 0;
>  	ci->io->tio.clone.bi_iter.bi_size = 0;
>  
> -	for (unsigned int i = 0; i < t->num_targets; i++) {
> -		unsigned int bios;
> -		struct dm_target *ti = dm_table_get_target(t, i);
> -
> -		if (unlikely(ti->num_flush_bios == 0))
> -			continue;
> -
> -		atomic_add(ti->num_flush_bios, &ci->io->io_count);
> -		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
> -					     NULL, GFP_NOWAIT);
> -		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
> +	if (!t->flush_pass_around) {
> +		for (unsigned int i = 0; i < t->num_targets; i++) {
> +			unsigned int bios;
> +			struct dm_target *ti = dm_table_get_target(t, i);
> +
> +			if (unlikely(ti->num_flush_bios == 0))
> +				continue;
> +
> +			atomic_add(ti->num_flush_bios, &ci->io->io_count);
> +			bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
> +						     NULL, GFP_NOWAIT);
> +			atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
> +		}
> +	} else {
> +		/*
> +		 * Note that there's no need to grab t->devices_lock here
> +		 * because the targets that support flush pass-around don't
> +		 * modify the list of devices.
> +		 */
> +		struct list_head *devices = dm_table_get_devices(t);
> +		unsigned int len = 0;
> +		struct dm_dev_internal *dd;
> +		list_for_each_entry(dd, devices, list) {
> +			struct bio *clone;
> +			clone = alloc_tio(ci, NULL, 0, &len, GFP_NOIO);
> +			atomic_add(1, &ci->io->io_count);
> +			bio_set_dev(clone, dd->dm_dev->bdev);
> +			clone->bi_end_io = clone_endio;
> +			dm_submit_bio_remap(clone, NULL);
> +		}
>  	}
>  
>  	/*
> 
> 

Still missing what "pass-around" is meant to convey given that you
aren't passing around the same flush... you're cloning a new flush and
issuing one per device.  Probably worth explaining that's what you
mean by "flush_pass_around" (both in commit header and elaborate in
code)?

Also, you're issuing a flush to _all_ devices in a table. Not just
the data devices.  .iterate_devices returns only the data devices.
If/when there is a need to extend this feature to targets that have
metadata devices (e.g. dm-thin, cache, etc): would it make sense to
filter out non-data devices (by stepping through each target in the
table and using iterate_devices)?

Mike
