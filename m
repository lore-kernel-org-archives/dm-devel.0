Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE76C43E073
	for <dm-devel@lists.linux.dev>; Tue, 11 Aug 2026 11:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786449365; cv=none; b=UrD0WADZuUzEcp4nujExWpQOZ6fgSrjzoGAa0xCkj/PHkQkaA0Oe46zrM3nto8XO9sXB78pp9evY4hODeY2LeJTpFSiyqo/2tN/mTnKECXhyTge2ghQIzr5IpCdgjiscrtdyECC3bmMbVX590Ra2PuzsU3idozQH0ECCRyJdJ4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786449365; c=relaxed/simple;
	bh=VpXQfXngakJfo7ga64cgG3sWB8g2iI45dnecQycX/9c=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=chKgd5Rt4JA/yqhwViZIG+aSiNCFbKS4PPftlm6xg0EYJdWG/IOdK+CgqyXg6fVeSeJgd5cWuuwc34Ien44ZYr//Y0WoUcs1lkm+HtSigfcwbMW1gAw/PmXxiTLyyEDrhqGvcfdA/bfdg2+XX0mJ6JzRcXV8z956sShspx229zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LHagdpcy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LHagdpcy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786449362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cCkcAt6r5PxJdIU9chDgup1OPs8wdTfU3Ncllkia+CM=;
	b=LHagdpcyYsIDDzgPTL3Gfv/Pq0bxS1aqBfZQReWdRxE+lshg2T+zS8EheNfaKdgfZepQMH
	jo0ei0JOkbgt4BR9+ZARGJsgg6yNR6KOPjurSFYqNX3SXqVRJOlqO3OlyDWxCoVBwKP8Lo
	/g/nIj2yr1pVOXUM3z7+eS68euj+kAs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-dCBxUCxyNPSiHcBx8HxfCg-1; Tue,
 11 Aug 2026 07:55:57 -0400
X-MC-Unique: dCBxUCxyNPSiHcBx8HxfCg-1
X-Mimecast-MFC-AGG-ID: dCBxUCxyNPSiHcBx8HxfCg_1786449356
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5ED0180034C;
	Tue, 11 Aug 2026 11:55:55 +0000 (UTC)
Received: from [10.44.32.79] (unknown [10.44.32.79])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D44E6423;
	Tue, 11 Aug 2026 11:55:52 +0000 (UTC)
Date: Tue, 11 Aug 2026 13:55:47 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Bart Van Assche <bvanassche@acm.org>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH v2] dm-crypt: refactor buffer allocation retry handling
In-Reply-To: <20260811031421.319489-1-runyu.xiao@seu.edu.cn>
Message-ID: <d7a670e5-ff67-0248-f514-e2e20603739a@redhat.com>
References: <cc5ed697-e769-4f40-aa9c-19c90b79fa7b@acm.org> <20260811031421.319489-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: LiROfXKGxuvrbDqNsXg5armKbiJRq1Um3TLa_k66-dc_1786449356
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 11 Aug 2026, Runyu Xiao wrote:

> crypt_alloc_buffer() conditionally acquires bio_alloc_lock around the
> allocation path and also contains the retry logic for the reclaim
> fallback.
> 
> Move one allocation attempt into crypt_alloc_buffer_try() so that
> bio_alloc_lock is always acquired and released in crypt_alloc_buffer(),
> and the retry decision is made only after the mutex has been dropped.
> 
> This keeps the retry path outside the locked region and makes the
> locking context easier to analyze.
> 
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

Hi

I wouldn't do this. The patch just moves code around and increases code 
size with no benefit.

Mikulas

> ---
> Changes in v2:
> - Move one allocation attempt into crypt_alloc_buffer_try(), as suggested
>   by Bart Van Assche.
> - Keep bio_alloc_lock acquisition and release in crypt_alloc_buffer(), and
>   make the retry decision only after releasing the lock.
> - Preserve the distinction between a page-pool retry and a final integrity
>   allocation failure.
> 
> v1: https://lore.kernel.org/r/20260809051839.3504080-1-runyu.xiao@seu.edu.cn
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 608b617fb817..7c68fad12960 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1627,18 +1627,16 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
>   * In order to reduce allocation overhead, we try to allocate compound pages in
>   * the first pass. If they are not available, we fall back to the mempool.
>   */
> -static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
> +static struct bio *crypt_alloc_buffer_try(struct dm_crypt_io *io,
> +					  unsigned int size, gfp_t gfp_mask,
> +					  unsigned int order, bool *retry)
>  {
>  	struct crypt_config *cc = io->cc;
>  	struct bio *clone;
>  	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
>  	unsigned int remaining_size;
> -	unsigned int order = MAX_PAGE_ORDER;
>  
> -retry:
> -	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
> -		mutex_lock(&cc->bio_alloc_lock);
> +	*retry = false;
>  
>  	clone = bio_alloc_bioset(cc->dev->bdev, nr_iovecs, io->base_bio->bi_opf,
>  				 GFP_NOIO, &cc->bs);
> @@ -1674,9 +1672,8 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
>  		if (!pages) {
>  			crypt_free_buffer_pages(cc, clone);
>  			bio_put(clone);
> -			gfp_mask |= __GFP_DIRECT_RECLAIM;
> -			order = 0;
> -			goto retry;
> +			*retry = true;
> +			return NULL;
>  		}
>  
>  have_pages:
> @@ -1692,12 +1689,34 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
>  		clone = NULL;
>  	}
>  
> -	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
> -		mutex_unlock(&cc->bio_alloc_lock);
> -
>  	return clone;
>  }
>  
> +static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
> +{
> +	struct crypt_config *cc = io->cc;
> +	struct bio *clone;
> +	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
> +	unsigned int order = MAX_PAGE_ORDER;
> +	bool retry;
> +
> +	for (;;) {
> +		if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
> +			mutex_lock(&cc->bio_alloc_lock);
> +
> +		clone = crypt_alloc_buffer_try(io, size, gfp_mask, order, &retry);
> +
> +		if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
> +			mutex_unlock(&cc->bio_alloc_lock);
> +
> +		if (!retry)
> +			return clone;
> +
> +		gfp_mask |= __GFP_DIRECT_RECLAIM;
> +		order = 0;
> +	}
> +}
> +
>  static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
>  {
>  	struct folio_iter fi;
> -- 
> 2.34.1
> 

