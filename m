Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678852701C0
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 11:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407998; cv=none; b=N46ZZPE6w80Hly7mjG2u/NiUpRGJJQ0tHxVfA3m1WfBBvUhA1kiGI3T0rAhywzarA6eLOOIjE7PI5G8qpY5E1reDPCP21wNAzJrmiJTiXXajfYpY+Oa7QQ80+ajWLPVR8y1mvNRAAm8Sxb8WzjaN2ERQvIGEEVL6zv5cq+o8eak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407998; c=relaxed/simple;
	bh=BF9iOD6eEJxhZOcY9xznB+hFU1EaN5moI5vJnr9Eqrw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gjVK5wonHXdTu4YUTpNkfD9U8eBgAYw6Wo3kymCbEJ0SZO/+5mjRQrQNOaZdB3HkacPgum7CRxn++YLP5lLvV0zTXN0odNDNatjdr7af041+nDF2WfSwdoZNfI0ipLrtvyYn6xMFKh8Vpba7poKQkJD2IpGG6D48SoqyROHUhRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XhxN55DF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XhxN55DF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745407995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Y+dQ7xFG0vUO1j1QN7IjhogOlB+ppElyLHKMKSNmF8=;
	b=XhxN55DFNipkTlJo/N0p8sZAXvSRUETwowYq+beniTAzKxiKnard00GjLgw0jnyREnlNk6
	h5lFpgvpI3GXXis9Iaz2ogfOlbUsE6OW/o4I+UPjk0J5E/v0F9H5/6bdvTDsU+5G6d6lc0
	e4PmtwZnSIfv+1ol/xYWX09geHmybJA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-kqMeoIt0MMi6nvTuvxItsA-1; Wed,
 23 Apr 2025 07:33:14 -0400
X-MC-Unique: kqMeoIt0MMi6nvTuvxItsA-1
X-Mimecast-MFC-AGG-ID: kqMeoIt0MMi6nvTuvxItsA_1745407992
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 944931955E7A;
	Wed, 23 Apr 2025 11:33:12 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76E3F1800947;
	Wed, 23 Apr 2025 11:33:10 +0000 (UTC)
Date: Wed, 23 Apr 2025 13:33:07 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, LongPing Wei <weilongping@oppo.com>, 
    Eran Messeri <eranm@google.com>, Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm-bufio: remove maximum age based eviction
In-Reply-To: <20250422200735.92144-1-ebiggers@kernel.org>
Message-ID: <7b8ad7d6-35fc-b8d9-d5eb-03fb2568971d@redhat.com>
References: <20250422200735.92144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: swuK9yvEzBpdn_YuvX3P4Hw9QpU1YrQUKs2KafFMibw_1745407992
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

OK, accepted.

Mikulas


On Tue, 22 Apr 2025, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> Every 30 seconds, dm-bufio evicts all buffers that were not accessed
> within the last max_age_seconds, except those pinned in memory via
> retain_bytes.  By default max_age_seconds is 300 (i.e. 5 minutes), and
> retain_bytes is 262144 (i.e. 256 KiB) per dm-bufio client.
> 
> This eviction algorithm is much too eager and is also redundant with the
> shinker based eviction.
> 
> Testing on an Android phone shows that about 30 MB of dm-bufio buffers
> (from dm-verity Merkle tree blocks) are loaded at boot time, and then
> about 90% of them are suddenly thrown away 5 minutes after boot.  This
> results in unnecessary Merkle tree I/O later.
> 
> Meanwhile, if the system actually encounters memory pressure, testing
> also shows that the shrinker is effective at evicting the buffers.
> 
> Other major Linux kernel caches, such as the page cache, do not enforce
> a maximum age, instead relying on the shrinker.
> 
> For these reasons, Android is now setting max_age_seconds to 86400
> (i.e. 1 day), which mostly disables it; see
> https://android.googlesource.com/platform/system/core/+/cadad290a79d5b0a30add935aaadab7c1b1ef5e9%5E%21/
> 
> That is a much better default, but really the maximum age based eviction
> should not exist at all.  Let's remove it.
> 
> Note that this also eliminates the need to run work every 30 seconds,
> which is beneficial too.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/md/dm-bufio.c | 189 ++++++++----------------------------------
>  1 file changed, 36 insertions(+), 153 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 9c8ed65cd87e6..8f5ac14bb3b74 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -38,20 +38,10 @@
>  #define DM_BUFIO_MEMORY_PERCENT		2
>  #define DM_BUFIO_VMALLOC_PERCENT	25
>  #define DM_BUFIO_WRITEBACK_RATIO	3
>  #define DM_BUFIO_LOW_WATERMARK_RATIO	16
>  
> -/*
> - * Check buffer ages in this interval (seconds)
> - */
> -#define DM_BUFIO_WORK_TIMER_SECS	30
> -
> -/*
> - * Free buffers when they are older than this (seconds)
> - */
> -#define DM_BUFIO_DEFAULT_AGE_SECS	300
> -
>  /*
>   * The nr of bytes of cached data to keep around.
>   */
>  #define DM_BUFIO_DEFAULT_RETAIN_BYTES   (256 * 1024)
>  
> @@ -1053,14 +1043,12 @@ static unsigned long dm_bufio_cache_size;
>   */
>  static unsigned long dm_bufio_cache_size_latch;
>  
>  static DEFINE_SPINLOCK(global_spinlock);
>  
> -/*
> - * Buffers are freed after this timeout
> - */
> -static unsigned int dm_bufio_max_age = DM_BUFIO_DEFAULT_AGE_SECS;
> +static unsigned int dm_bufio_max_age; /* No longer does anything */
> +
>  static unsigned long dm_bufio_retain_bytes = DM_BUFIO_DEFAULT_RETAIN_BYTES;
>  
>  static unsigned long dm_bufio_peak_allocated;
>  static unsigned long dm_bufio_allocated_kmem_cache;
>  static unsigned long dm_bufio_allocated_kmalloc;
> @@ -1084,11 +1072,10 @@ static LIST_HEAD(dm_bufio_all_clients);
>   * This mutex protects dm_bufio_cache_size_latch and dm_bufio_client_count
>   */
>  static DEFINE_MUTEX(dm_bufio_clients_lock);
>  
>  static struct workqueue_struct *dm_bufio_wq;
> -static struct delayed_work dm_bufio_cleanup_old_work;
>  static struct work_struct dm_bufio_replacement_work;
>  
>  
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
>  static void buffer_record_stack(struct dm_buffer *b)
> @@ -2671,134 +2658,10 @@ void dm_bufio_set_sector_offset(struct dm_bufio_client *c, sector_t start)
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_set_sector_offset);
>  
>  /*--------------------------------------------------------------*/
>  
> -static unsigned int get_max_age_hz(void)
> -{
> -	unsigned int max_age = READ_ONCE(dm_bufio_max_age);
> -
> -	if (max_age > UINT_MAX / HZ)
> -		max_age = UINT_MAX / HZ;
> -
> -	return max_age * HZ;
> -}
> -
> -static bool older_than(struct dm_buffer *b, unsigned long age_hz)
> -{
> -	return time_after_eq(jiffies, READ_ONCE(b->last_accessed) + age_hz);
> -}
> -
> -struct evict_params {
> -	gfp_t gfp;
> -	unsigned long age_hz;
> -
> -	/*
> -	 * This gets updated with the largest last_accessed (ie. most
> -	 * recently used) of the evicted buffers.  It will not be reinitialised
> -	 * by __evict_many(), so you can use it across multiple invocations.
> -	 */
> -	unsigned long last_accessed;
> -};
> -
> -/*
> - * We may not be able to evict this buffer if IO pending or the client
> - * is still using it.
> - *
> - * And if GFP_NOFS is used, we must not do any I/O because we hold
> - * dm_bufio_clients_lock and we would risk deadlock if the I/O gets
> - * rerouted to different bufio client.
> - */
> -static enum evict_result select_for_evict(struct dm_buffer *b, void *context)
> -{
> -	struct evict_params *params = context;
> -
> -	if (!(params->gfp & __GFP_FS) ||
> -	    (static_branch_unlikely(&no_sleep_enabled) && b->c->no_sleep)) {
> -		if (test_bit_acquire(B_READING, &b->state) ||
> -		    test_bit(B_WRITING, &b->state) ||
> -		    test_bit(B_DIRTY, &b->state))
> -			return ER_DONT_EVICT;
> -	}
> -
> -	return older_than(b, params->age_hz) ? ER_EVICT : ER_STOP;
> -}
> -
> -static unsigned long __evict_many(struct dm_bufio_client *c,
> -				  struct evict_params *params,
> -				  int list_mode, unsigned long max_count)
> -{
> -	unsigned long count;
> -	unsigned long last_accessed;
> -	struct dm_buffer *b;
> -
> -	for (count = 0; count < max_count; count++) {
> -		b = cache_evict(&c->cache, list_mode, select_for_evict, params);
> -		if (!b)
> -			break;
> -
> -		last_accessed = READ_ONCE(b->last_accessed);
> -		if (time_after_eq(params->last_accessed, last_accessed))
> -			params->last_accessed = last_accessed;
> -
> -		__make_buffer_clean(b);
> -		__free_buffer_wake(b);
> -
> -		cond_resched();
> -	}
> -
> -	return count;
> -}
> -
> -static void evict_old_buffers(struct dm_bufio_client *c, unsigned long age_hz)
> -{
> -	struct evict_params params = {.gfp = 0, .age_hz = age_hz, .last_accessed = 0};
> -	unsigned long retain = get_retain_buffers(c);
> -	unsigned long count;
> -	LIST_HEAD(write_list);
> -
> -	dm_bufio_lock(c);
> -
> -	__check_watermark(c, &write_list);
> -	if (unlikely(!list_empty(&write_list))) {
> -		dm_bufio_unlock(c);
> -		__flush_write_list(&write_list);
> -		dm_bufio_lock(c);
> -	}
> -
> -	count = cache_total(&c->cache);
> -	if (count > retain)
> -		__evict_many(c, &params, LIST_CLEAN, count - retain);
> -
> -	dm_bufio_unlock(c);
> -}
> -
> -static void cleanup_old_buffers(void)
> -{
> -	unsigned long max_age_hz = get_max_age_hz();
> -	struct dm_bufio_client *c;
> -
> -	mutex_lock(&dm_bufio_clients_lock);
> -
> -	__cache_size_refresh();
> -
> -	list_for_each_entry(c, &dm_bufio_all_clients, client_list)
> -		evict_old_buffers(c, max_age_hz);
> -
> -	mutex_unlock(&dm_bufio_clients_lock);
> -}
> -
> -static void work_fn(struct work_struct *w)
> -{
> -	cleanup_old_buffers();
> -
> -	queue_delayed_work(dm_bufio_wq, &dm_bufio_cleanup_old_work,
> -			   DM_BUFIO_WORK_TIMER_SECS * HZ);
> -}
> -
> -/*--------------------------------------------------------------*/
> -
>  /*
>   * Global cleanup tries to evict the oldest buffers from across _all_
>   * the clients.  It does this by repeatedly evicting a few buffers from
>   * the client that holds the oldest buffer.  It's approximate, but hopefully
>   * good enough.
> @@ -2832,31 +2695,55 @@ static void __insert_client(struct dm_bufio_client *new_client)
>  	}
>  
>  	list_add_tail(&new_client->client_list, h);
>  }
>  
> +static enum evict_result select_for_evict(struct dm_buffer *b, void *context)
> +{
> +	/* In no-sleep mode, we cannot wait on IO. */
> +	if (static_branch_unlikely(&no_sleep_enabled) && b->c->no_sleep) {
> +		if (test_bit_acquire(B_READING, &b->state) ||
> +		    test_bit(B_WRITING, &b->state) ||
> +		    test_bit(B_DIRTY, &b->state))
> +			return ER_DONT_EVICT;
> +	}
> +	return ER_EVICT;
> +}
> +
>  static unsigned long __evict_a_few(unsigned long nr_buffers)
>  {
> -	unsigned long count;
>  	struct dm_bufio_client *c;
> -	struct evict_params params = {
> -		.gfp = GFP_KERNEL,
> -		.age_hz = 0,
> -		/* set to jiffies in case there are no buffers in this client */
> -		.last_accessed = jiffies
> -	};
> +	unsigned long oldest_buffer = jiffies;
> +	unsigned long last_accessed;
> +	unsigned long count;
> +	struct dm_buffer *b;
>  
>  	c = __pop_client();
>  	if (!c)
>  		return 0;
>  
>  	dm_bufio_lock(c);
> -	count = __evict_many(c, &params, LIST_CLEAN, nr_buffers);
> +
> +	for (count = 0; count < nr_buffers; count++) {
> +		b = cache_evict(&c->cache, LIST_CLEAN, select_for_evict, NULL);
> +		if (!b)
> +			break;
> +
> +		last_accessed = READ_ONCE(b->last_accessed);
> +		if (time_after_eq(oldest_buffer, last_accessed))
> +			oldest_buffer = last_accessed;
> +
> +		__make_buffer_clean(b);
> +		__free_buffer_wake(b);
> +
> +		cond_resched();
> +	}
> +
>  	dm_bufio_unlock(c);
>  
>  	if (count)
> -		c->oldest_buffer = params.last_accessed;
> +		c->oldest_buffer = oldest_buffer;
>  	__insert_client(c);
>  
>  	return count;
>  }
>  
> @@ -2935,14 +2822,11 @@ static int __init dm_bufio_init(void)
>  
>  	dm_bufio_wq = alloc_workqueue("dm_bufio_cache", WQ_MEM_RECLAIM, 0);
>  	if (!dm_bufio_wq)
>  		return -ENOMEM;
>  
> -	INIT_DELAYED_WORK(&dm_bufio_cleanup_old_work, work_fn);
>  	INIT_WORK(&dm_bufio_replacement_work, do_global_cleanup);
> -	queue_delayed_work(dm_bufio_wq, &dm_bufio_cleanup_old_work,
> -			   DM_BUFIO_WORK_TIMER_SECS * HZ);
>  
>  	return 0;
>  }
>  
>  /*
> @@ -2950,11 +2834,10 @@ static int __init dm_bufio_init(void)
>   */
>  static void __exit dm_bufio_exit(void)
>  {
>  	int bug = 0;
>  
> -	cancel_delayed_work_sync(&dm_bufio_cleanup_old_work);
>  	destroy_workqueue(dm_bufio_wq);
>  
>  	if (dm_bufio_client_count) {
>  		DMCRIT("%s: dm_bufio_client_count leaked: %d",
>  			__func__, dm_bufio_client_count);
> @@ -2987,11 +2870,11 @@ module_exit(dm_bufio_exit)
>  
>  module_param_named(max_cache_size_bytes, dm_bufio_cache_size, ulong, 0644);
>  MODULE_PARM_DESC(max_cache_size_bytes, "Size of metadata cache");
>  
>  module_param_named(max_age_seconds, dm_bufio_max_age, uint, 0644);
> -MODULE_PARM_DESC(max_age_seconds, "Max age of a buffer in seconds");
> +MODULE_PARM_DESC(max_age_seconds, "No longer does anything");
>  
>  module_param_named(retain_bytes, dm_bufio_retain_bytes, ulong, 0644);
>  MODULE_PARM_DESC(retain_bytes, "Try to keep at least this many bytes cached in memory");
>  
>  module_param_named(peak_allocated_bytes, dm_bufio_peak_allocated, ulong, 0644);
> 
> base-commit: a33b5a08cbbdd7aadff95f40cbb45ab86841679e
> -- 
> 2.49.0
> 

