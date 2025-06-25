Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5064225BEF6
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869017; cv=none; b=nXvVH10rMzRvuF8pTHgcIBW99poasQB2pIepgk8ZGZKIpJP0lI0sQWUMnISLLDxXXZxYyPgL+sQWfsqG9JmwBNVO0HdiIkzl/xIDecw3fSMSV4KuiR1HEGhLaR5+sb08itui4uydLEVVz86CGXe3WN7Whkda6SBTHf5qfKpQb+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869017; c=relaxed/simple;
	bh=KUChHfNXMlDuBgG8BFBtvEPIS6vYXcZr//lATkLrIhc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=vAV7aayUSmRuEkJ4ZL48QcKfrR3SVSpVsCk2qHsqJptI0Ax0iiiSgojvFrGZjBtZUSF31gJS5gngvfK77K3aEKpIyV35fL4fipjAwUCWwWvi2G/nJrhaM9QHvmFTdLz0Zkas8uwpipCfqtthR5cMf1ftjwgeXboEMW5O6m8C9/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FGSQVC7y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FGSQVC7y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750869014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JAX5hMoQWuxauXmiy4c5s8KSsTRfMuSMORF/65Dx9Jw=;
	b=FGSQVC7yCV2Ja7RnJN6oCFqsIGmaH/9DbjEN01Fl4uFKpwYuVVMNbiwornClTv7XC2H7lB
	C/GGywfT4abIoeIhXwVaQVAQ48R60wTMDAaaig4mIWpV377E2rwyNMjsFgQ3t19T7Yh6b5
	U5pGL2EbMT6nGfM6KbNpYr8XUOCKM/s=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-145-RNyzA55ePGm5_AXvX74Y1A-1; Wed,
 25 Jun 2025 12:30:10 -0400
X-MC-Unique: RNyzA55ePGm5_AXvX74Y1A-1
X-Mimecast-MFC-AGG-ID: RNyzA55ePGm5_AXvX74Y1A_1750869009
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF7DC1956089;
	Wed, 25 Jun 2025 16:30:08 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA53B30001A1;
	Wed, 25 Jun 2025 16:30:06 +0000 (UTC)
Date: Wed, 25 Jun 2025 18:30:00 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
    dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 3/5] dm: Always split write BIOs to zoned device
 limits
In-Reply-To: <20250625093327.548866-4-dlemoal@kernel.org>
Message-ID: <7b80992f-b1bc-7873-4d27-708836b5599b@redhat.com>
References: <20250625093327.548866-1-dlemoal@kernel.org> <20250625093327.548866-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4



On Wed, 25 Jun 2025, Damien Le Moal wrote:

> Any zoned DM target that requires zone append emulation will use the
> block layer zone write plugging. In such case, DM target drivers must
> not split BIOs using dm_accept_partial_bio() as doing so can potentially
> lead to deadlocks with queue freeze operations. Regular write operations
> used to emulate zone append operations also cannot be split by the
> target driver as that would result in an invalid writen sector value
> return using the BIO sector.
> 
> In order for zoned DM target drivers to avoid such incorrect BIO
> splitting, we must ensure that large BIOs are split before being passed
> to the map() function of the target, thus guaranteeing that the
> limits for the mapped device are not exceeded.
> 
> dm-crypt and dm-flakey are the only target drivers supporting zoned
> devices and using dm_accept_partial_bio().
> 
> In the case of dm-crypt, this function is used to split BIOs to the
> internal max_write_size limit (which will be suppressed in a different
> patch). However, since crypt_alloc_buffer() uses a bioset allowing only
> up to BIO_MAX_VECS (256) vectors in a BIO. The dm-crypt device
> max_segments limit, which is not set and so default to BLK_MAX_SEGMENTS
> (128), must thus be respected and write BIOs split accordingly.
> 
> In the case of dm-flakey, since zone append emulation is not required,
> the block layer zone write plugging is not used and no splitting of BIOs
> required.
> 
> Modify the function dm_zone_bio_needs_split() to use the block layer
> helper function bio_needs_zone_write_plugging() to force a call to
> bio_split_to_limits() in dm_split_and_process_bio(). This allows DM
> target drivers to avoid using dm_accept_partial_bio() for write
> operations on zoned DM devices.
> 
> Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm.c | 29 ++++++++++++++++++++++-------
>  1 file changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index e477765cdd27..f1e63c1808b4 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1773,12 +1773,29 @@ static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
>  					   struct bio *bio)
>  {
>  	/*
> -	 * For mapped device that need zone append emulation, we must
> -	 * split any large BIO that straddles zone boundaries.
> +	 * Special case the zone operations that cannot or should not be split.
>  	 */
> -	return dm_emulate_zone_append(md) && bio_straddles_zones(bio) &&
> -		!bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING);
> +	switch (bio_op(bio)) {
> +	case REQ_OP_ZONE_APPEND:
> +	case REQ_OP_ZONE_FINISH:
> +	case REQ_OP_ZONE_RESET:
> +	case REQ_OP_ZONE_RESET_ALL:
> +		return false;
> +	default:
> +		break;
> +	}
> +
> +	/*
> +	 * Mapped devices that require zone append emulation will use the block
> +	 * layer zone write plugging. In such case, we must split any large BIO
> +	 * to the mapped device limits to avoid potential deadlocks with queue
> +	 * freeze operations.
> +	 */
> +	if (!dm_emulate_zone_append(md))
> +		return false;
> +	return bio_needs_zone_write_plugging(bio) || bio_straddles_zones(bio);
>  }
> +
>  static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio *bio)
>  {
>  	if (!bio_needs_zone_write_plugging(bio))
> @@ -1927,9 +1944,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
>  
>  	is_abnormal = is_abnormal_io(bio);
>  	if (static_branch_unlikely(&zoned_enabled)) {
> -		/* Special case REQ_OP_ZONE_RESET_ALL as it cannot be split. */
> -		need_split = (bio_op(bio) != REQ_OP_ZONE_RESET_ALL) &&
> -			(is_abnormal || dm_zone_bio_needs_split(md, bio));
> +		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);
>  	} else {
>  		need_split = is_abnormal;
>  	}
> -- 
> 2.49.0
> 

