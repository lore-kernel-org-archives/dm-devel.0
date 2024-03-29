Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4441D1804A
	for <dm-devel@lists.linux.dev>; Fri, 29 Mar 2024 01:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711675899; cv=none; b=qiDpVhiyAQL3acyMVaaEfpQ8cob0YWSzvJr9Go6Hu96tgrd8tiBfuFitwQD6E1jPYUhxONHuYLcsrXosOJEuJXCOPzdkeO0rNUOcb8gh/ZB4Rz7v4p1NtVjYFBKSvLb8hfnZ5H1P9pK1+kgOkPKvKKObH8YdR4msGz/ILU16kxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711675899; c=relaxed/simple;
	bh=x8+vLQdDl6AWLoiYfzSQzCyhpD0rGFbo8zT8dGRPxYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=adoF7+pBj3nEJE9oqcLt1ahh+PEsK74w94xMrlUVjJF9/ibm64/QRMgJvJVU+s+rmzfdkG7lCDCubfyXGrQFftmjVfkM0AD7uFO3mo8YHIt7h7ThHA8m1BKxlHkBAd1We7fnU3mBf/LnJPOUBh3H+fUEGxOOy264/zIx1KFoXOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DG7uXgZf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DG7uXgZf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711675896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iN3x73gOojteLy+t/0nbZ2MLb4v3F8mbntSlr0U9MPo=;
	b=DG7uXgZfK2mE0ji/KO+5ls+W89GsrgPn6GjB41cJmhz0RSsOYFVKblYEAtoAHcMyjkgFdU
	mJjQ71W6TzJrPeyfZKAAYS9Sej/ebtn8BctqI93ryHnLHgUoSYUwkBuQnjF/sl+a4PbWBJ
	pgXN9JqQzrFBf+XLCC7dno7ZzuOaDhs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-135-nvf4v4vsOuaHEJmj2ejAuQ-1; Thu,
 28 Mar 2024 21:31:30 -0400
X-MC-Unique: nvf4v4vsOuaHEJmj2ejAuQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD5512804805;
	Fri, 29 Mar 2024 01:31:29 +0000 (UTC)
Received: from redhat.com (unknown [10.2.16.33])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15559492BD7;
	Fri, 29 Mar 2024 01:31:27 +0000 (UTC)
Date: Thu, 28 Mar 2024 20:31:21 -0500
From: Eric Blake <eblake@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	David Teigland <teigland@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@lst.de>, Joe Thornber <ejt@redhat.com>
Subject: Re: [RFC 8/9] dm thin: add llseek(SEEK_HOLE/SEEK_DATA) support
Message-ID: <c4pit5qf3sgiynx3jcnngdj7d3m62c5fdsgmla7twxynh6wfai@7jvhgxya4xo6>
References: <20240328203910.2370087-1-stefanha@redhat.com>
 <20240328203910.2370087-9-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328203910.2370087-9-stefanha@redhat.com>
User-Agent: NeoMutt/20240201
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Thu, Mar 28, 2024 at 04:39:09PM -0400, Stefan Hajnoczi wrote:
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
> Open issues:
> - Locking?
> - thin_seek_hole_data() does not run as a bio or request. This patch
>   assumes dm_thin_find_mapped_range() synchronously performs I/O if
>   metadata needs to be loaded from disk. Is that a valid assumption?
> ---
>  drivers/md/dm-thin.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 77 insertions(+)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 4793ad2aa1f7e..3c5dc4f0fe8a3 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -4501,6 +4501,82 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  	}
>  }
>  
> +static dm_block_t loff_to_block(struct pool *pool, loff_t offset)
> +{
> +	sector_t offset_sectors = offset >> SECTOR_SHIFT;
> +	dm_block_t ret;
> +
> +	if (block_size_is_power_of_two(pool))
> +		ret = offset_sectors >> pool->sectors_per_block_shift;
> +	else {
> +		ret = offset_sectors;
> +		(void) sector_div(ret, pool->sectors_per_block);
> +	}
> +
> +	return ret;
> +}
> +
> +static loff_t block_to_loff(struct pool *pool, dm_block_t block)
> +{
> +	return block_to_sectors(pool, block) << SECTOR_SHIFT;
> +}
> +
> +static loff_t thin_seek_hole_data(struct dm_target *ti, loff_t offset,
> +		int whence)
> +{
> +	struct thin_c *tc = ti->private;
> +	struct dm_thin_device *td = tc->td;
> +	struct pool *pool = tc->pool;
> +	dm_block_t begin;
> +	dm_block_t end;
> +	dm_block_t mapped_begin;
> +	dm_block_t mapped_end;
> +	dm_block_t pool_begin;
> +	bool maybe_shared;
> +	int ret;
> +
> +	/* TODO locking? */
> +
> +	if (block_size_is_power_of_two(pool))
> +		end = ti->len >> pool->sectors_per_block_shift;
> +	else {
> +		end = ti->len;
> +		(void) sector_div(end, pool->sectors_per_block);
> +	}
> +
> +	offset -= ti->begin << SECTOR_SHIFT;
> +
> +	while (true) {
> +		begin = loff_to_block(pool, offset);
> +		ret = dm_thin_find_mapped_range(td, begin, end,
> +						&mapped_begin, &mapped_end,
> +						&pool_begin, &maybe_shared);
> +		if (ret == -ENODATA) {
> +			if (whence == SEEK_DATA)
> +				return -ENXIO;
> +			break;
> +		} else if (ret < 0) {
> +			/* TODO handle EWOULDBLOCK? */
> +			return -ENXIO;

This should probably be -EIO, not -ENXIO.

> +		}
> +
> +		/* SEEK_DATA finishes here... */
> +		if (whence == SEEK_DATA) {
> +			if (mapped_begin != begin)
> +				offset = block_to_loff(pool, mapped_begin);
> +			break;
> +		}
> +
> +		/* ...while SEEK_HOLE may need to look further */
> +		if (mapped_begin != begin)
> +			break; /* offset is in a hole */
> +
> +		offset = block_to_loff(pool, mapped_end);
> +	}
> +
> +	return offset + (ti->begin << SECTOR_SHIFT);

It's hard to follow, but I'm fairly certain that if whence ==
SEEK_HOLE, you end up returning ti->begin + ti->len instead of -ENXIO
if the range from begin to end is fully mapped; which is inconsistent
with the semantics you have in 4/9 (although in 6/9 I argue that
having all of the dm callbacks return ti->begin + ti->len instead of
-ENXIO might make logic easier for iterating through consecutive ti,
and then convert to -ENXIO only in the caller).

> +}
> +
>  static struct target_type thin_target = {
>  	.name = "thin",
>  	.version = {1, 23, 0},
> @@ -4515,6 +4591,7 @@ static struct target_type thin_target = {
>  	.status = thin_status,
>  	.iterate_devices = thin_iterate_devices,
>  	.io_hints = thin_io_hints,
> +	.seek_hole_data = thin_seek_hole_data,
>  };
>  
>  /*----------------------------------------------------------------*/
> -- 
> 2.44.0
> 

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.
Virtualization:  qemu.org | libguestfs.org

