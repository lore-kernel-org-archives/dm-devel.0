Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE519233954
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 11:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789989470; cv=none; b=oiXvxiky12ogPhgeBZHvDn7NhEcXPk6XWR8ocf4T/u4wws16lKPS4pTLWpIb7XSZg+fjA6AGFT7q3iHE9vWKKSj2+aVwEpi+beHcwmz/EbMneshSSv2dRsWkZzX/0tXx7dnto9jYRiuRYiu3o6qKwJRzIidA7kVpAdkITk2PRUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789989470; c=relaxed/simple;
	bh=pxNg++pIiCxMyiicFTcnm5kLi+svMsksymQt12Npea0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=SkCfnzFCg/lD26Q3zG/JIAsLjwPVSS+rwoE8+ih5OkOdocQgLiIyOkEPUhbkpB9V8VVVZgZ8JHvJqOkic25ZfsYMVxtEoq7u8v06xohZoRSsnoEMbadr9zfJAK+JJvgt5oxmnJ3chwKkiz0AoXjgqAXWcasoFbw79PfyDWRPZ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XqlKtZxr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XqlKtZxr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789989467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Znlz6nWrm29FlIh7Yb0OMt2uX919Za9IzqWLsmyjuE=;
	b=XqlKtZxr1jkQbRdJKHwfUEmW1EeOwcX1latGu88cpUFVsdI4I7jXtEnhXVXgS9HME3voAU
	zSD1n+m5Pmh39Euy4MC9IzhhTTugv1VpbsSv75QM432P9O8F0isL4sPzT/opCE44IdS/oh
	z1hXiVOE1BMGYgtot849eF9M/jV2QcM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-XC5N-dWpOdmv75ajmLVCWw-1; Mon,
 21 Sep 2026 07:17:46 -0400
X-MC-Unique: XC5N-dWpOdmv75ajmLVCWw-1
X-Mimecast-MFC-AGG-ID: XC5N-dWpOdmv75ajmLVCWw_1789989465
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30B131955DD3;
	Mon, 21 Sep 2026 11:17:45 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3970E426;
	Mon, 21 Sep 2026 11:17:43 +0000 (UTC)
Date: Mon, 21 Sep 2026 13:17:41 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Henry Wong <henry@stuffedcow.net>
cc: dm-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] dm-writecache: Reduce metadata memory use by 8 bytes
 per cache block.
In-Reply-To: <20260907214648.3691695-2-henry@stuffedcow.net>
Message-ID: <9b99a057-c371-c0ec-e4a3-794a6b64fe83@redhat.com>
References: <20260907214648.3691695-1-henry@stuffedcow.net> <20260907214648.3691695-2-henry@stuffedcow.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BY5jlMPji4cGt2cHSIxKuRMHBg9AWNcgoaIftPdZYkE_1789989465
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I accepted this patch. Thanks.

Mikulas


On Mon, 7 Sep 2026, Henry Wong wrote:

> wc_entry.index removed: This can be computed by pointer arithmetic without storage.
> wc_entry.age reduced to 32 bits: It only needs to be big enough to hold max_age, which is limited to well below 32-bit range.
> 
> Reduces wc_entry size from 56 bytes to 48 bytes (from 72 to 64 bytes if DM_WRITECACHE_HANDLE_HARDWARE_ERRORS enabled).
> 
> Signed-off-by: Henry Wong <henry@stuffedcow.net>
> ---
>  drivers/md/dm-writecache.c | 39 ++++++++++++++++++--------------------
>  1 file changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 978646f71f99..68e3fb300fc1 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -81,15 +81,9 @@ struct wc_memory_superblock {
>  struct wc_entry {
>  	struct rb_node rb_node;
>  	struct list_head lru;
> +	u32 age; // jiffies
>  	unsigned short wc_list_contiguous;
> -#if BITS_PER_LONG == 64
> -	bool write_in_progress : 1;
> -	unsigned long index : 47;
> -#else
>  	bool write_in_progress;
> -	unsigned long index;
> -#endif
> -	unsigned long age;
>  #ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
>  	uint64_t original_sector;
>  	uint64_t seq_count;
> @@ -389,20 +383,28 @@ static struct wc_memory_superblock *sb(struct dm_writecache *wc)
>  	return wc->memory_map;
>  }
>  
> +static inline unsigned long wc_entry_index(const struct wc_entry *base, const struct wc_entry *entry)
> +{
> +	return entry - base;
> +}
> +
>  static struct wc_memory_entry *memory_entry(struct dm_writecache *wc, struct wc_entry *e)
>  {
> -	return &sb(wc)->entries[e->index];
> +	const unsigned long index = wc_entry_index(wc->entries, e);
> +	return &sb(wc)->entries[index];
>  }
>  
>  static void *memory_data(struct dm_writecache *wc, struct wc_entry *e)
>  {
> -	return (char *)wc->block_start + (e->index << wc->block_size_bits);
> +	const unsigned long index = wc_entry_index(wc->entries, e);
> +	return (char *)wc->block_start + (index << wc->block_size_bits);
>  }
>  
>  static sector_t cache_sector(struct dm_writecache *wc, struct wc_entry *e)
>  {
> +	const unsigned long index = wc_entry_index(wc->entries, e);
>  	return wc->start_sector + wc->metadata_sectors +
> -		((sector_t)e->index << (wc->block_size_bits - SECTOR_SHIFT));
> +		((sector_t)index << (wc->block_size_bits - SECTOR_SHIFT));
>  }
>  
>  static uint64_t read_original_sector(struct dm_writecache *wc, struct wc_entry *e)
> @@ -668,7 +670,7 @@ static void writecache_insert_entry(struct dm_writecache *wc, struct wc_entry *i
>  	rb_link_node(&ins->rb_node, parent, node);
>  	rb_insert_color(&ins->rb_node, &wc->tree);
>  	list_add(&ins->lru, &wc->lru);
> -	ins->age = jiffies;
> +	ins->age = (u32)jiffies;
>  }
>  
>  static void writecache_unlink(struct dm_writecache *wc, struct wc_entry *e)
> @@ -969,7 +971,6 @@ static int writecache_alloc_entries(struct dm_writecache *wc)
>  	for (b = 0; b < wc->n_blocks; b++) {
>  		struct wc_entry *e = &wc->entries[b];
>  
> -		e->index = b;
>  		e->write_in_progress = false;
>  		cond_resched();
>  	}
> @@ -1986,7 +1987,7 @@ static void writecache_writeback(struct work_struct *work)
>  	while (!list_empty(&wc->lru) &&
>  	       (wc->writeback_all ||
>  		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
> -		(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age >=
> +		((u32)(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age) >=
>  		 wc->max_age - wc->max_age / MAX_AGE_DIV))) {
>  
>  		n_walked++;
> @@ -2107,7 +2108,6 @@ static int calculate_memory_size(uint64_t device_size, unsigned int block_size,
>  				 size_t *n_blocks_p, size_t *n_metadata_blocks_p)
>  {
>  	uint64_t n_blocks, offset;
> -	struct wc_entry e;
>  
>  	n_blocks = device_size;
>  	do_div(n_blocks, block_size + sizeof(struct wc_memory_entry));
> @@ -2126,11 +2126,6 @@ static int calculate_memory_size(uint64_t device_size, unsigned int block_size,
>  		n_blocks--;
>  	}
>  
> -	/* check if the bit field overflows */
> -	e.index = n_blocks;
> -	if (e.index != n_blocks)
> -		return -EFBIG;
> -
>  	if (n_blocks_p)
>  		*n_blocks_p = n_blocks;
>  	if (n_metadata_blocks_p)
> @@ -2444,13 +2439,15 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  			wc->autocommit_time_set = true;
>  		} else if (!strcasecmp(string, "max_age") && opt_params >= 1) {
>  			unsigned int max_age_msecs;
> +			unsigned long max_age_jiffies;
>  
>  			string = dm_shift_arg(&as), opt_params--;
>  			if (sscanf(string, "%u%c", &max_age_msecs, &dummy) != 1)
>  				goto invalid_optional;
> -			if (max_age_msecs > 86400000)
> +			max_age_jiffies = msecs_to_jiffies(max_age_msecs);
> +			if (max_age_jiffies >= min(MAX_JIFFY_OFFSET, (7 << 28))) // 7/8ths of 1 << 31
>  				goto invalid_optional;
> -			wc->max_age = msecs_to_jiffies(max_age_msecs);
> +			wc->max_age = max_age_jiffies;
>  			wc->max_age_set = true;
>  			wc->max_age_value = max_age_msecs;
>  		} else if (!strcasecmp(string, "cleaner")) {
> -- 
> 2.52.0
> 

