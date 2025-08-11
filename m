Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476132C17A1
	for <dm-devel@lists.linux.dev>; Mon, 11 Aug 2025 11:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754911434; cv=none; b=EW1xORT0valLEIC+1vkqrT186yMoU53MgxDFp5jecjpsxqV9Iq0tBQIlk9baA1a4D5LCpxtKNYDNcM+ZckNPbushKHT3QgBcXgXcoBJg2Ti2qwLOAd7MOHJtUVkdYjxswtxdcSXNgKXGQDLrZrnVoM2czLySvBJj2Zy4VrEO4l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754911434; c=relaxed/simple;
	bh=Tr1PDV72f8SxG2vSQOsMJUwUHTueO9mpx6Y10Lr1jlc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bm4bvo0e6jYcq3gpTNlEc4mcU3CR2OXdb1jEBnttqHskfN0qa9aGLW09IwBTt1UcRkk1No9JfYFq7c0qPcgjCTqWYJiWlczZrz5fq9IMnyjjUtP40wGHE6hknG8UX0BHj7MfRRzxtiQrx7ZrE/e5yNIadlj7EnHqL+850hrKesA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d1bdvuIJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d1bdvuIJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3EcE+Ww1+cUz2ETnyTdPt53gzWYEyrvawI1y/8RN51s=;
	b=d1bdvuIJ/WZxinaQPTphDQ8WFSAV+vbD+5SeeEAh6ISyTWdAHzey2hL0dTSviVC/rOubPk
	85svNQWlKILiuHKhkZ4x5Ux5l7L+hkzABxT7OdGG8xAyog4UaxiorKe+bOoMwO17WjCPK0
	aKSugVxnvY946zzphue/sIF9PTQ1T0I=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-qPIbAS7iNG6dTkql56phhg-1; Mon,
 11 Aug 2025 07:23:48 -0400
X-MC-Unique: qPIbAS7iNG6dTkql56phhg-1
X-Mimecast-MFC-AGG-ID: qPIbAS7iNG6dTkql56phhg_1754911427
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CFE91956080;
	Mon, 11 Aug 2025 11:23:46 +0000 (UTC)
Received: from [10.22.80.50] (unknown [10.22.80.50])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BB651800291;
	Mon, 11 Aug 2025 11:23:43 +0000 (UTC)
Date: Mon, 11 Aug 2025 13:23:39 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: Use vmalloc_array to simplify code
In-Reply-To: <20250805091448.124183-1-rongqianfeng@vivo.com>
Message-ID: <7ed910b3-aac6-8c15-ba65-c81ed267de7a@redhat.com>
References: <20250805091448.124183-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Applied.thanks.

Mikulas



On Tue, 5 Aug 2025, Qianfeng Rong wrote:

> Remove array_size() calls and replace vmalloc() with
> vmalloc_array() to simplify the code.
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> ---
>  drivers/md/dm-cache-policy-smq.c | 2 +-
>  drivers/md/dm-region-hash.c      | 2 +-
>  drivers/md/dm-switch.c           | 4 ++--
>  drivers/md/dm-thin.c             | 4 ++--
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
> index 2ed894155cab..7e1e8cc0e33a 100644
> --- a/drivers/md/dm-cache-policy-smq.c
> +++ b/drivers/md/dm-cache-policy-smq.c
> @@ -590,7 +590,7 @@ static int h_init(struct smq_hash_table *ht, struct entry_space *es, unsigned in
>  	nr_buckets = roundup_pow_of_two(max(nr_entries / 4u, 16u));
>  	ht->hash_bits = __ffs(nr_buckets);
>  
> -	ht->buckets = vmalloc(array_size(nr_buckets, sizeof(*ht->buckets)));
> +	ht->buckets = vmalloc_array(nr_buckets, sizeof(*ht->buckets));
>  	if (!ht->buckets)
>  		return -ENOMEM;
>  
> diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
> index a4550975c27d..e9b47b659976 100644
> --- a/drivers/md/dm-region-hash.c
> +++ b/drivers/md/dm-region-hash.c
> @@ -206,7 +206,7 @@ struct dm_region_hash *dm_region_hash_create(
>  	rh->shift = RH_HASH_SHIFT;
>  	rh->prime = RH_HASH_MULT;
>  
> -	rh->buckets = vmalloc(array_size(nr_buckets, sizeof(*rh->buckets)));
> +	rh->buckets = vmalloc_array(nr_buckets, sizeof(*rh->buckets));
>  	if (!rh->buckets) {
>  		DMERR("unable to allocate region hash bucket memory");
>  		kfree(rh);
> diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
> index bb1a70b5a215..50a52ca50b34 100644
> --- a/drivers/md/dm-switch.c
> +++ b/drivers/md/dm-switch.c
> @@ -114,8 +114,8 @@ static int alloc_region_table(struct dm_target *ti, unsigned int nr_paths)
>  		return -EINVAL;
>  	}
>  
> -	sctx->region_table = vmalloc(array_size(nr_slots,
> -						sizeof(region_table_slot_t)));
> +	sctx->region_table = vmalloc_array(nr_slots,
> +					   sizeof(region_table_slot_t));
>  	if (!sctx->region_table) {
>  		ti->error = "Cannot allocate region table";
>  		return -ENOMEM;
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 007bb93e5fca..c84149ba4e38 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -3031,8 +3031,8 @@ static struct pool *pool_create(struct mapped_device *pool_md,
>  	}
>  
>  	pool->cell_sort_array =
> -		vmalloc(array_size(CELL_SORT_ARRAY_SIZE,
> -				   sizeof(*pool->cell_sort_array)));
> +		vmalloc_array(CELL_SORT_ARRAY_SIZE,
> +			      sizeof(*pool->cell_sort_array));
>  	if (!pool->cell_sort_array) {
>  		*error = "Error allocating cell sort array";
>  		err_p = ERR_PTR(-ENOMEM);
> -- 
> 2.34.1
> 

