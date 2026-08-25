Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC924964F
	for <dm-devel@lists.linux.dev>; Tue, 25 Aug 2026 20:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787689328; cv=none; b=MuPsWpERVWREE9871kERiAB1o0fG447cmcU4JUcd8Fgo9cSEzqPfh7sGgZgv29ot4atoABM6NyaFjHim3swdlL5BBbAnOfVJO4kvrqezwXpqYojhpbZqDM0orn5ud4/ptsx7E6nNsp0Liby75m7ZL8Ip5dHCq3njMAwT27CN7B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787689328; c=relaxed/simple;
	bh=pPtGwwZdBGz4f++jUMLPVeKvLYuyk1IjhsH5KbKxci8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PU6XhtzZBxNVG83QKQCHQqsqh5CB+96sbmoNL2QA9Vc6ahRKUVw5TqLRzHzOb9OtEV5gMoc79MrSuv0RunHOndbDR7E4ethxHanNXM3iigeQ0a+RnyeDKFXsMOW2v5n4ohxQarbME+7rbcNdGr/cqUWuN8X9sl96BG1fNMEqRI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ax3Cae8H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ax3Cae8H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787689325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tlnILVIwaPpngDBE+T1nuhVKu6/VwH4ug/3hRnEV9FE=;
	b=ax3Cae8HZup6rxSJ+ZMeBrw2OMf2VDkfAS8BYU16HTj599sOoSbiPxG2b2t5wPr6ua/wOr
	oBmv5jMv8jF6ypPQ0fbm4B+2iYYMmYo2rEU6SmL65sNcSid+9miV/PstcRK+VvAH0L8kCU
	PjPVLiwHpqDRNkA4vZ88R8Daqj1RnOI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-JsJQytWBMceo3coIlTwFEQ-1; Tue, 25 Aug 2026 16:22:04 -0400
X-MC-Unique: JsJQytWBMceo3coIlTwFEQ-1
X-Mimecast-MFC-AGG-ID: JsJQytWBMceo3coIlTwFEQ_1787689323
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90a91f4c6f1so1993626d6.3
        for <dm-devel@lists.linux.dev>; Tue, 25 Aug 2026 13:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787689323; x=1788294123;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tlnILVIwaPpngDBE+T1nuhVKu6/VwH4ug/3hRnEV9FE=;
        b=mvBuv7BIwXt0eD/K56+5oTcn8AnwCShfkOZj7g8cyCasx9+GACJZlmMiZix/fPB8Dd
         gGPEV4c2UIF75j1mLNtoz0fAYGMtuvjq3thu+dCz4OxeofulVmIxOlitgjSO5bPm8y/t
         Gt4z7GoebZ1HSljK0e3j9i47UijayK0+qbRnW0+1cJlIVXbk4LtORL8b1zm29+BICYy2
         AYtcwjU5mGPDEvbZqU01kXsf776nRUUm97f84yZCxyK0hs16tykgZX53zfW15iK9D7WR
         hm65AbdaFRVyOahwVirjOejC43s2RYxd4X8gtA9GvVgTJxOmN7zUduslNgWwic4UvoIA
         I5og==
X-Forwarded-Encrypted: i=1; AHgh+RqI5M19xK//r+kLQ0sZWu8fhgAugB9nTN6aHSgPh8c+bu0VILs0Wx1KVILpQ5VxNwyxadAWl8OdUw==@lists.linux.dev
X-Gm-Message-State: AFuF++mo8TnhfUYU33pOMVk0Sa0gp0TRNS+6TLTlkRNyHs1wj9uNp0VQ
	pANXwQV0OKGM07w/MDAxptAfRbg9KwyHRxXfkAd7UAxc8ycovQDd8wdLWJl48SVSZHf/w2DDQpg
	SJB0Fy4lmUxnGbUyi3Ks4yCI0WMWuXJ5rPzT191HDTYQNLxH2s+7VWskcivWY
X-Gm-Gg: AR+sD11x4DoSLBHxHMlFnA5GI3B3oE5IntZNg5i9Vd+vt975Z7npdKKBGW3jo/5s8lc
	6Bay6W8IIaiPUqx0D4oHaRpTra8ZU3m37RN/ETGZmC6XUUI0DR6Ey7eTKXD+5S67xfniacR7/Fn
	QCwt/jKnX6EFlrYBpICg/ZWK8MT+uHnZuCx/2hZ2XBl847oQLLGMJIleCmD2mIzqGDybKwJGgS7
	dKfYJZVz9yA/ZqgDPFfuV8QYkiAdxN6puXZZAXZwEdsk6uCqomLqR9tkzRztkXbgQiXSPgPOh45
	ZHeFt2hZRfMS2SpVk2aQwQCZ0K6/e+Xu97xmdy1K0rkeKDuld0wxPQ+uwrn9UPi6F59+ZpBuBoz
	a9rXkOe41yfemyITZ6OlJYIN0KIqywEzcpCsTp4u7FMcqz3QI
X-Received: by 2002:ad4:4ea4:0:b0:90a:3b62:805d with SMTP id 6a1803df08f44-90cc78a800bmr16011316d6.4.1787689323410;
        Tue, 25 Aug 2026 13:22:03 -0700 (PDT)
X-Received: by 2002:ad4:4ea4:0:b0:90a:3b62:805d with SMTP id 6a1803df08f44-90cc78a800bmr16010546d6.4.1787689322912;
        Tue, 25 Aug 2026 13:22:02 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:b400:d348:ae32:97a6:8a0d? ([2600:4040:530f:b400:d348:ae32:97a6:8a0d])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc650a0ecsm7120546d6.28.2026.08.25.13.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 13:22:02 -0700 (PDT)
Message-ID: <e7c72200-790d-45d4-9ce5-1fe556a9a3d9@redhat.com>
Date: Tue, 25 Aug 2026 16:22:01 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm cache: fix issue with background work locking
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: Ming-Hung Tsai <mtsai@redhat.com>, dm-devel@lists.linux.dev
References: <20260825192226.4191036-1-bmarzins@redhat.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20260825192226.4191036-1-bmarzins@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ySytwwLc1vfMNN0M9TEonJG7OhJ46AMDvRyS-34IlHI_1787689323
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/25/26 3:22 PM, Benjamin Marzinski wrote:
> dm cache used a rw_semaphore for background_work_lock. Write locks on
> rw_semaphores have strict owner semantics, but there was no guarantee
> that the process that locked background_work_lock was the same process
> that unlocked it. This can be easily seen using a kernel compiled with
> CONFIG_DEBUG_RWSEMS. Given a dm cache device <cache>, run: 'dmsetup
> suspend <cache> && dmsetup resume <cache>'. This will tigger a kernel

typo: trigger

> warning:
> 
> DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE))
> 
> triggered by cache_resume(). To fix this, switch from a rw_semaphore to
> a spinlock and a wait queue. dm cache already hasd a wait queue and

typo: has

> associated counter, migration_wait and nr_allocated_migrations, that was
> getting woken up when background work was getting completed, but wasn't
> actually used by anything. This is replaced by the background_work queue
> and counter.
> 
> Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Aside from the above, feel free to add

Reviewed-by: Matthew Sakai <msakai@redhat.com>

> ---
>   drivers/md/dm-cache-target.c | 55 ++++++++++++++++++------------------
>   1 file changed, 28 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 33dbc71b730f..d8d9c63d2a67 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -340,8 +340,6 @@ struct cache {
>   	struct list_head invalidation_requests;
>   
>   	sector_t migration_threshold;
> -	wait_queue_head_t migration_wait;
> -	atomic_t nr_allocated_migrations;
>   
>   	/*
>   	 * The number of in flight migrations that are performing
> @@ -397,7 +395,11 @@ struct cache {
>   	bool loaded_mappings:1;
>   	bool loaded_discards:1;
>   
> -	struct rw_semaphore background_work_lock;
> +	/* background work management */
> +	bool background_work_allowed;
> +	unsigned background_work_nr;
> +	spinlock_t background_work_lock;
> +	wait_queue_head_t background_work_wait;
>   
>   	struct batcher committer;
>   	struct work_struct commit_ws;
> @@ -488,19 +490,13 @@ static struct dm_cache_migration *alloc_migration(struct cache *cache)
>   	memset(mg, 0, sizeof(*mg));
>   
>   	mg->cache = cache;
> -	atomic_inc(&cache->nr_allocated_migrations);
>   
>   	return mg;
>   }
>   
>   static void free_migration(struct dm_cache_migration *mg)
>   {
> -	struct cache *cache = mg->cache;
> -
> -	if (atomic_dec_and_test(&cache->nr_allocated_migrations))
> -		wake_up(&cache->migration_wait);
> -
> -	mempool_free(mg, &cache->migration_pool);
> +	mempool_free(mg, &mg->cache->migration_pool);
>   }
>   
>   /*----------------------------------------------------------------*/
> @@ -1030,34 +1026,39 @@ static void calc_discard_block_range(struct cache *cache, struct bio *bio,
>   
>   static void prevent_background_work(struct cache *cache)
>   {
> -	lockdep_off();
> -	down_write(&cache->background_work_lock);
> -	lockdep_on();
> +	spin_lock_irq(&cache->background_work_lock);
> +	cache->background_work_allowed = false;
> +	wait_event_lock_irq(cache->background_work_wait,
> +			    cache->background_work_nr == 0,
> +			    cache->background_work_lock);
> +	spin_unlock_irq(&cache->background_work_lock);
>   }
>   
>   static void allow_background_work(struct cache *cache)
>   {
> -	lockdep_off();
> -	up_write(&cache->background_work_lock);
> -	lockdep_on();
> +	spin_lock_irq(&cache->background_work_lock);
> +	cache->background_work_allowed = true;
> +	spin_unlock_irq(&cache->background_work_lock);
>   }
>   
>   static bool background_work_begin(struct cache *cache)
>   {
>   	bool r;
>   
> -	lockdep_off();
> -	r = down_read_trylock(&cache->background_work_lock);
> -	lockdep_on();
> -
> +	spin_lock_irq(&cache->background_work_lock);
> +	r = cache->background_work_allowed;
> +	if (r)
> +		cache->background_work_nr++;
> +	spin_unlock_irq(&cache->background_work_lock);
>   	return r;
>   }
>   
>   static void background_work_end(struct cache *cache)
>   {
> -	lockdep_off();
> -	up_read(&cache->background_work_lock);
> -	lockdep_on();
> +	spin_lock_irq(&cache->background_work_lock);
> +	if (--cache->background_work_nr == 0)
> +		wake_up(&cache->background_work_wait);
> +	spin_unlock_irq(&cache->background_work_lock);
>   }
>   
>   /*----------------------------------------------------------------*/
> @@ -2507,9 +2508,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
>   
>   	spin_lock_init(&cache->lock);
>   	bio_list_init(&cache->deferred_bios);
> -	atomic_set(&cache->nr_allocated_migrations, 0);
>   	atomic_set(&cache->nr_io_migrations, 0);
> -	init_waitqueue_head(&cache->migration_wait);
>   
>   	r = -ENOMEM;
>   	atomic_set(&cache->nr_dirty, 0);
> @@ -2592,8 +2591,10 @@ static int cache_create(struct cache_args *ca, struct cache **result)
>   		     issue_op, cache, cache->wq);
>   	dm_iot_init(&cache->tracker);
>   
> -	init_rwsem(&cache->background_work_lock);
> -	prevent_background_work(cache);
> +	init_waitqueue_head(&cache->background_work_wait);
> +	spin_lock_init(&cache->background_work_lock);
> +	cache->background_work_allowed = false;
> +	cache->background_work_nr = 0;
>   
>   	*result = cache;
>   	return 0;

