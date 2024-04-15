Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4DA74429
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 14:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713190108; cv=none; b=aU0kkx015y1tR5vkNacAZmkeRcWlytkp54ttS3NHbB5vSOLGqKJJcHVtzELgqlksDcyn04quE9QvJm2WW/tD4aqcjFozFdmkjbesGhMtS16L3JpX7zo4w8/0z//KViptBMLLCYiPVDIB/ersAFVH3bHBmc+eqnKIbXZTWU6XEew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713190108; c=relaxed/simple;
	bh=BQlCSR2pBKBQsRrJ8eRJ7jCIrsC96goMvznhaclK4Ho=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aCIjGHyOCNig4KQElSx+k8p9h64MOSQVgs8K81GkSphvWYLz9NrtcAs0LPJEJbD1QUq5Bug5PcVyeqUbeG3/FsMuGW93llc4AfcNYf6MKg8EW+nDZ0XMx2cN4U9BgPNxRYE1HANxzALYCooVneArZPFIVu1o9Nct6jgHAZNXhJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CN2VhDzo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CN2VhDzo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713190105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4ewC4IHdX9Ac1Zdo5H+mNDvPTNL43IwaWU7wkXn44k=;
	b=CN2VhDzo/uk50DrkxIUwvLawU97bD7qYDYa/4rSNHcDQDKyB8pjoBzgXGz65TcZ7NfNSzC
	9tdm/JdwysxNlqHqHIwMzqN+4utN+m5BhKkurZeGfXgGI9CUplVLBJIEwdVuz98ridyc4S
	O6t6BeWdcHARHPoubEjqah0CFjIbWEY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-y39HoyG-P5qxTwOuipouQQ-1; Mon,
 15 Apr 2024 10:08:19 -0400
X-MC-Unique: y39HoyG-P5qxTwOuipouQQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBFE43806278;
	Mon, 15 Apr 2024 14:08:17 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 47946C13FA3;
	Mon, 15 Apr 2024 14:08:17 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 1B5B530BFEC2; Mon, 15 Apr 2024 14:08:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 16D9B3FD51;
	Mon, 15 Apr 2024 16:08:17 +0200 (CEST)
Date: Mon, 15 Apr 2024 16:08:17 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: hch@lst.de, axboe@kernel.dk, dm-devel@lists.linux.dev, 
    linux-block@vger.kernel.org, Abelardo Ricart III <aricart@memnix.com>, 
    Brandon Smith <freedom@reardencode.com>, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH for-6.10 1/2] dm-crypt: stop constraining max_segment_size
 to PAGE_SIZE
In-Reply-To: <20240411201529.44846-2-snitzer@kernel.org>
Message-ID: <41339ac6-579b-399e-9c60-d4f0628ab09f@redhat.com>
References: <ZfDeMn6V8WzRUws3@infradead.org> <20240411201529.44846-2-snitzer@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8



On Thu, 11 Apr 2024, Mike Snitzer wrote:

> This change effectively reverts commit 586b286b110e ("dm crypt:
> constrain crypt device's max_segment_size to PAGE_SIZE") and relies on
> block core's late bio-splitting to ensure that dm-crypt's encryption
> bios are split accordingly if they exceed the underlying device's
> limits (e.g. max_segment_size).
> 
> Commit 586b286b110e was applied as a 4.3 fix for the benefit of
> stable@ kernels 4.0+ just after block core's late bio-splitting was
> introduced in 4.3 with commit 54efd50bfd873 ("block: make
> generic_make_request handle arbitrarily sized bios"). Given block
> core's late bio-splitting it is past time that dm-crypt make use of
> it.
> 
> Also, given the recent need to revert meaningful progress that was
> attempted during the 6.9 merge window (see commit bff4b74625fe Revert
> "dm: use queue_limits_set") this change allows DM core to safely make
> use of queue_limits_set() without risk of breaking dm-crypt on NVMe.
> Though it should be noted this commit isn't a prereq for reinstating
> DM core's use of queue_limits_set() because blk_validate_limits() was
> made less strict with commit b561ea56a264 ("block: allow device to
> have both virt_boundary_mask and max segment size").
> 
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-crypt.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 5bfa35760167..f43a2c0b3d77 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1656,8 +1656,8 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
>  
>  /*
>   * Generate a new unfragmented bio with the given size
> - * This should never violate the device limitations (but only because
> - * max_segment_size is being constrained to PAGE_SIZE).
> + * This should never violate the device limitations (but if it did then block
> + * core should split the bio as needed).
>   *
>   * This function may be called concurrently. If we allocate from the mempool
>   * concurrently, there is a possibility of deadlock. For example, if we have
> @@ -3717,14 +3717,6 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  {
>  	struct crypt_config *cc = ti->private;
>  
> -	/*
> -	 * Unfortunate constraint that is required to avoid the potential
> -	 * for exceeding underlying device's max_segments limits -- due to
> -	 * crypt_alloc_buffer() possibly allocating pages for the encryption
> -	 * bio that are not as physically contiguous as the original bio.
> -	 */
> -	limits->max_segment_size = PAGE_SIZE;
> -
>  	limits->logical_block_size =
>  		max_t(unsigned int, limits->logical_block_size, cc->sector_size);
>  	limits->physical_block_size =
> -- 
> 2.40.0
> 

