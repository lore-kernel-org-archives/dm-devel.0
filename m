Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15EF25BEF6
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869107; cv=none; b=J7biKpByl1qX01njahJaDHrKANKJ1AV5JjlEjlv7npDsBcighskRzVDRMr9DyDAAijsQ25Ntre1KRAQ6vNbdqiUzVgk78WfEaOrv7PCBLoqB9z6+9O6t/WHLmKUebeLyjLbBzLHl7tBKAy2tGp++GS5wZoscWklDKsRDK88Mckk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869107; c=relaxed/simple;
	bh=09WLRS/c9p9fTeSZBLQxnGFevl+gGyFgvnERMRoWfbc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=naAKfHpjhY0QamU2ME/ekt+xwk17mYA0u1rg39AVcyDjQdu3vjJVUkOVDyaE549T69EPg8ucB92EnYgflQoVV6sHkYKdHS7NO3l2B0qpMocRsXkau4n5LRlrNsaA3XxK+xwyAasaz2EaCjKoLQxCcZlqsxsSEr1a+AC3ub6PgyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U7WZWyg0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U7WZWyg0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750869104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ip9Ezor3LD44mzEA5HXJXS43s0DnYzmTcGgOvhb5UBE=;
	b=U7WZWyg0QskxoQpQRsS0K2GHM+9p/d83hvT0QL7LgPYCYRJ+bNVHwX2truYH0kZ7pns45b
	jTGbt9UcTw5YSLYAsHFqee3bLewzOtin1cheEfxUkdUyo7U+KM2yBP+m6eGsY49yLUgLGB
	EC9cixsLdj7HjevmJ+fJOMM/LOtFZpU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-208-LJf0N5DUMfSdxpJGnwLTDw-1; Wed,
 25 Jun 2025 12:31:43 -0400
X-MC-Unique: LJf0N5DUMfSdxpJGnwLTDw-1
X-Mimecast-MFC-AGG-ID: LJf0N5DUMfSdxpJGnwLTDw_1750869101
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF7DF1955D5A;
	Wed, 25 Jun 2025 16:31:41 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D421B1956096;
	Wed, 25 Jun 2025 16:31:39 +0000 (UTC)
Date: Wed, 25 Jun 2025 18:31:35 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
    dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 5/5] dm: Check for forbidden splitting of zone write
 operations
In-Reply-To: <20250625093327.548866-6-dlemoal@kernel.org>
Message-ID: <aa216c0f-db15-05c4-cf4b-e24d418de761@redhat.com>
References: <20250625093327.548866-1-dlemoal@kernel.org> <20250625093327.548866-6-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15



On Wed, 25 Jun 2025, Damien Le Moal wrote:

> DM targets must not split zone append and write operations using
> dm_accept_partial_bio() as doing so is forbidden for zone append BIOs,
> breaks zone append emulation using regular write BIOs and potentially
> creates deadlock situations with queue freeze operations.
> 
> Modify dm_accept_partial_bio() to add missing BUG_ON() checks for all
> these cases, that is, check that the BIO is a write or write zeroes
> operation. This change packs all the zone related checks together under
> a static_branch_unlikely(&zoned_enabled) and done only if the target is
> a zoned device.
> 
> Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index f1e63c1808b4..f82457e7eed1 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1286,8 +1286,9 @@ static size_t dm_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
>  /*
>   * A target may call dm_accept_partial_bio only from the map routine.  It is
>   * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_* zone management
> - * operations, REQ_OP_ZONE_APPEND (zone append writes) and any bio serviced by
> - * __send_duplicate_bios().
> + * operations, zone append writes (native with REQ_OP_ZONE_APPEND or emulated
> + * with write BIOs flagged with BIO_EMULATES_ZONE_APPEND) and any bio serviced
> + * by __send_duplicate_bios().
>   *
>   * dm_accept_partial_bio informs the dm that the target only wants to process
>   * additional n_sectors sectors of the bio and the rest of the data should be
> @@ -1320,11 +1321,19 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
>  	unsigned int bio_sectors = bio_sectors(bio);
>  
>  	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
> -	BUG_ON(op_is_zone_mgmt(bio_op(bio)));
> -	BUG_ON(bio_op(bio) == REQ_OP_ZONE_APPEND);
>  	BUG_ON(bio_sectors > *tio->len_ptr);
>  	BUG_ON(n_sectors > bio_sectors);
>  
> +	if (static_branch_unlikely(&zoned_enabled) &&
> +	    unlikely(bdev_is_zoned(bio->bi_bdev))) {
> +		enum req_op op = bio_op(bio);
> +
> +		BUG_ON(op_is_zone_mgmt(op));
> +		BUG_ON(op == REQ_OP_WRITE);
> +		BUG_ON(op == REQ_OP_WRITE_ZEROES);
> +		BUG_ON(op == REQ_OP_ZONE_APPEND);
> +	}
> +
>  	*tio->len_ptr -= bio_sectors - n_sectors;
>  	bio->bi_iter.bi_size = n_sectors << SECTOR_SHIFT;
>  
> -- 
> 2.49.0
> 

