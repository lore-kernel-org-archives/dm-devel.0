Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837772EEE84
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 11:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782299659; cv=none; b=GauXbn5//RM9VqcqmEoIwBjGZn+47PqFou5smq0redbaK+7Vqnw7XMVZh0HN6x8+j2TUW7Ev14DGX+3HDQkzbn0ypvKoMRABUZfC5ayGr902a7VD5DB72cpJwSpeUItuPZdyN/XXDXNKS2rjTMjpqnxubs5P8LlAu/2gmNUedrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782299659; c=relaxed/simple;
	bh=54qls6R4s7vy2wgeognek0uR5HEWVSyZbQnUs7k/Jys=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=F1JptmmHoU2krMI66vrsDTQhNdIRRopT8OdrkW3YYwO41QdfTNEVkyFZIR1JRrddgfqJU095+xICng+eJCk4h2YIazhBQmaaCZXdd10xDUWN+QxWQI9km0gAyWVuaTc7XFzyT1FR3pH3ZcLJ8c07JLCrByrDPg+LneYUtFnZDaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WgHtcTRi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WgHtcTRi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782299657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8AKRT0241Rnsq/fzi/nga+xD3qqPVq9mAC76/E0+lFc=;
	b=WgHtcTRiric3hW6ON2ZzbdrNusbpaV6gU06QCsUgoDHQg/FbKfjLNLG1PnHhccbfdYeB9E
	d8p3E0SoJ+U2g+zUjBtH2LbQ2iPm5ip7n7fANDa9xgAO9sEtKvKVHrUPnipRs9sGboPNHu
	Xt+QTklu8WC9Jihu+miSsxsE007uChQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-410-oWcfJ-k6PHyO5_CVgGhzDg-1; Wed,
 24 Jun 2026 07:14:12 -0400
X-MC-Unique: oWcfJ-k6PHyO5_CVgGhzDg-1
X-Mimecast-MFC-AGG-ID: oWcfJ-k6PHyO5_CVgGhzDg_1782299651
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 117E019560B6;
	Wed, 24 Jun 2026 11:14:11 +0000 (UTC)
Received: from [10.44.32.26] (unknown [10.44.32.26])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DFC83195609E;
	Wed, 24 Jun 2026 11:14:08 +0000 (UTC)
Date: Wed, 24 Jun 2026 13:14:03 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Keith Busch <kbusch@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>
cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev, 
    linux-block@vger.kernel.org, "Dr. David Alan Gilbert" <linux@treblig.org>, 
    Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
In-Reply-To: <ajFyuoMqnvQm738z@kbusch-mbp>
Message-ID: <0bd687cf-82ac-eacf-844b-c179a52dc72c@redhat.com>
References: <20260616150554.1686662-1-kbusch@meta.com> <ajFyuoMqnvQm738z@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: iTvC17JNGkBZEB96NJryeye6j5c8hUn1-ZM_rnDlRAA_1782299651
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

This approach is OK, I will stage the patches when 7.2-rc1 comes out and 
when I'll fork the dm git branches.

I suggest one change - it is kind of hacky when multiple I/O completion 
callbacks write into io->orig_bio->bi_status concurrently - so it would be 
better to not do it and maintain and return separate bit mask for 
non-retryable errors.

For example:

static void complete_io(struct io *io)
{
        unsigned long error_bits = io->error_bits;
        unsigned long nonretryable_error_bits = io->nonretryable_error_bits;
        io_notify_fn fn = io->callback;
        void *context = io->context;

        if (io->vma_invalidate_size)
                invalidate_kernel_vmap_range(io->vma_invalidate_address,
                                             io->vma_invalidate_size);

        mempool_free(io, &io->client->pool);
        fn(error_bits, nonretryable_error_bits, context);
}

static void dec_count(struct io *io, unsigned int region, blk_status_t error)
{
        if (unlikely(error == BLK_STS_NOTSUPP) || unlikely(error == BLK_STS_INVAL))
		set_bit(region, &io->nonretryable_error_bits);
        else if (unlikely(error != BLK_STS_OK))
                set_bit(region, &io->error_bits);

        if (atomic_dec_and_test(&io->count))
                complete_io(io);
}

Please send the updated patch that uses this approach.

BTW. I think that blk_path_error should also test for BLK_STS_INVAL and 
return false, otherwise, dm-multipath would be suffering from this bug 
too. Ben, could you test it?

Mikulas


On Tue, 16 Jun 2026, Keith Busch wrote:

> BLK_STS_INVAL indicates the I/O request itself was invalid (for example a
> misaligned direct I/O), not that the device has failed. dm-raid1 treated
> any read or write completion error as a device failure: it failed the
> mirror leg, retried on the alternatives - which fail identically - and
> eventually returned EIO while spuriously degrading the array.
> 
> Since commit 5ff3f74e145a ("block: simplify direct io validity check") the
> direct I/O path no longer rejects misaligned buffers up front, so an
> invalid bio now reaches the lower block layers, which fail it with
> BLK_STS_INVAL. dm-io collapses the block status into a per-region error
> bit before invoking the completion callback, so record BLK_STS_INVAL on
> the originating bio and have the dm-raid1 read, write and end_io paths
> propagate it instead of failing the device.
> 
> This mirrors the raid1/raid10 fix in commit f7b24c7b41f23
> ("md/raid1,raid10: don't fail devices for invalid IO errors") for the
> device-mapper mirror target.
> 
> Fixes: 7eac33186957 ("iomap: simplify direct io validity check")
> Fixes: 5ff3f74e145a ("block: simplify direct io validity check")
> Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
> Reported-by: Vjaceslavs Klimovs <vklimovs@gmail.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
> Resending patch 2/2 from a different machine. For some reason, only 1/2
> is getting through with git-send-email, so manually replying to the
> thread with the missing second patch.
> 
>  drivers/md/dm-io.c    | 14 +++++++++++++-
>  drivers/md/dm-raid1.c | 28 +++++++++++++++++++++++++++-
>  2 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
> index 28adfeb58f240..f382e9f9be059 100644
> --- a/drivers/md/dm-io.c
> +++ b/drivers/md/dm-io.c
> @@ -37,6 +37,7 @@ struct io {
>  	struct dm_io_client *client;
>  	io_notify_fn callback;
>  	void *context;
> +	struct bio *orig_bio;
>  	void *vma_invalidate_address;
>  	unsigned long vma_invalidate_size;
>  } __aligned(DM_IO_MAX_REGIONS);
> @@ -132,8 +133,18 @@ static void complete_io(struct io *io)
>  
>  static void dec_count(struct io *io, unsigned int region, blk_status_t error)
>  {
> -	if (error)
> +	if (error) {
>  		set_bit(region, &io->error_bits);
> +		/*
> +		 * BLK_STS_INVAL means the bio was not valid for the underlying
> +		 * device (e.g. a misaligned direct I/O), which is a caller error
> +		 * rather than a device failure. Record it on the original bio so
> +		 * bio-based targets can propagate it instead of treating it as a
> +		 * media error and failing the device.
> +		 */
> +		if (error == BLK_STS_INVAL && io->orig_bio)
> +			io->orig_bio->bi_status = error;
> +	}
>  
>  	if (atomic_dec_and_test(&io->count))
>  		complete_io(io);
> @@ -398,6 +409,7 @@ static void async_io(struct dm_io_client *client, unsigned int num_regions,
>  	io->client = client;
>  	io->callback = fn;
>  	io->context = context;
> +	io->orig_bio = dp->orig_bio;
>  
>  	io->vma_invalidate_address = dp->vma_invalidate_address;
>  	io->vma_invalidate_size = dp->vma_invalidate_size;
> diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
> index de5c00704e69c..022ad791c2957 100644
> --- a/drivers/md/dm-raid1.c
> +++ b/drivers/md/dm-raid1.c
> @@ -524,6 +524,17 @@ static void read_callback(unsigned long error, void *context)
>  		return;
>  	}
>  
> +	/*
> +	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
> +	 * e.g. a misaligned direct I/O. That is a caller error, not a device
> +	 * failure, so propagate it rather than failing the mirror and retrying
> +	 * on the other legs, which would fail the same way.
> +	 */
> +	if (bio->bi_status == BLK_STS_INVAL) {
> +		bio_endio(bio);
> +		return;
> +	}
> +
>  	fail_mirror(m, DM_RAID1_READ_ERROR);
>  
>  	if (likely(default_ok(m)) || mirror_available(m->ms, bio)) {
> @@ -622,6 +633,16 @@ static void write_callback(unsigned long error, void *context)
>  		return;
>  	}
>  
> +	/*
> +	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
> +	 * e.g. a misaligned direct I/O. Propagate the error without degrading
> +	 * the array.
> +	 */
> +	if (bio->bi_status == BLK_STS_INVAL) {
> +		bio_endio(bio);
> +		return;
> +	}
> +
>  	/*
>  	 * If the bio is discard, return an error, but do not
>  	 * degrade the array.
> @@ -1262,7 +1283,12 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio,
>  		return DM_ENDIO_DONE;
>  	}
>  
> -	if (*error == BLK_STS_NOTSUPP)
> +	/*
> +	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
> +	 * e.g. a misaligned direct I/O. Propagate it rather than failing the
> +	 * mirror and retrying, which would fail the same way on every leg.
> +	 */
> +	if (*error == BLK_STS_NOTSUPP || *error == BLK_STS_INVAL)
>  		goto out;
>  
>  	if (bio->bi_opf & REQ_RAHEAD)
> -- 
> 2.52.0
> 
> 

