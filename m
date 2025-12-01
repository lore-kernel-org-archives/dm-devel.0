Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99230207A0B
	for <dm-devel@lists.linux.dev>; Mon,  1 Dec 2025 22:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764627688; cv=none; b=cGFTiovMAKwpp5OsNlhKgcaqEj8QH0cwqBOA9FaerwxREaaDNbsS9U6TwGdUWYPM7goFYn1Ythl2pcG9q8HeIqZv9fqHP6QcTN/W5paN873WOtcRwXis+FrBmxHEhtGmHjfGuglyIT1COuGUCYpZ5H8Rsjsp74wlVtbjmNQrl+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764627688; c=relaxed/simple;
	bh=MFpn0A271Vky723N4Nz8nSAQkw/uS/GpyiO35DOAC5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=NAcOYxnLUCO30n9uWnKR1mbThUKEBIxfu6PQnKUkHgWcq+NG/NwY+AWEDLUPdz4+cxPcNOEK8WHvLHnhfpUKPLZCB7dPNy0CMDJmIqtVG4HJD2nq9U3Hfv5ArJj6YXueGw291nO5Xdo8775HJPzACKFHrpXT6hSJ5WNyyvAHIJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XDdmiFBg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XDdmiFBg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764627684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DL1x8mBNAUtKmvhRD/OZVpDYiBDYBCoE1YF3n5++hEo=;
	b=XDdmiFBglK9ybBfQK1a6O+VllL7SuK36s3F0CZhkn/qTxxep0RzTO2shVPOA+RCQ0+dYgA
	k6LVqUZaUUJi1eydUOq6uzc4dIw8laVI8k5qAz2f1jL4nv2Vi97jMJt0N/gUqpNgO0lHGO
	cKhi/+pE8mvuePcdoyDZUQhd4t5Lnjg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362-iLNnKXknPOCCumefXvMfQg-1; Mon,
 01 Dec 2025 17:21:23 -0500
X-MC-Unique: iLNnKXknPOCCumefXvMfQg-1
X-Mimecast-MFC-AGG-ID: iLNnKXknPOCCumefXvMfQg_1764627682
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B7C31955F11;
	Mon,  1 Dec 2025 22:21:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9F32180047F;
	Mon,  1 Dec 2025 22:21:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B1MLKVD1425181
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 1 Dec 2025 17:21:20 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B1MLJ821425180;
	Mon, 1 Dec 2025 17:21:19 -0500
Date: Mon, 1 Dec 2025 17:21:19 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Jiping Ma <jiping.ma2@windriver.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-snapshot: fix 'scheduling while atomic' on real-time
 kernels
Message-ID: <aS4U3zt_jUkpjLlR@redhat.com>
References: <747444e7-6884-cc1b-a761-c1e3bb7b888f@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <747444e7-6884-cc1b-a761-c1e3bb7b888f@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gNP7_5ev7tOu7GN0Vjzo1TCRziST42aAaPWs6xP2Umo_1764627682
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 01, 2025 at 10:13:10PM +0100, Mikulas Patocka wrote:
> There is reported 'scheduling while atomic' bug when using dm-snapshot on
> real-time kernels. The reason for the bug is that the hlist_bl code does
> preempt_disable() when taking the lock and the kernel attempts to take
> other spinlocks while holding the hlist_bl lock.
> 
> Fix this by converting a hlist_bl spinlock into a regular spinlock.

This looks correct, but it will either cause an increase in the memory
used, or a possible performance hit due to lock contention on a smaller
number of hash buckets, depending on whether the number of hash buckets
calculated by the device/chunk size is larger than the new, smaller
calc_max_buckets() limit. Since calc_max_buckets() limits the memory use
to 2MB, I suspect that for most devices, this will result in fewer
buckets (a 2G cow device with a 16K chunk size on a 64bit machine would
hit the calc_max_buckets() limit of 262144 buckets before.  Depending on
how the kernel is configured, the limit is now likely half that, so cow
devices of over 1G are likely to start having fewer buckets).  

I wonder if we should double the calc_max_buckets() memory limit, or
perhaps play some #ifdef games so that only real-time kernels are
effected by this change.

-Ben

> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-exception-store.h |    2 -
>  drivers/md/dm-snap.c            |   73 ++++++++++++++++++----------------------
>  2 files changed, 35 insertions(+), 40 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-exception-store.h
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-exception-store.h	2023-09-05 14:45:58.000000000 +0200
> +++ linux-2.6/drivers/md/dm-exception-store.h	2025-12-01 16:46:21.000000000 +0100
> @@ -29,7 +29,7 @@ typedef sector_t chunk_t;
>   * chunk within the device.
>   */
>  struct dm_exception {
> -	struct hlist_bl_node hash_list;
> +	struct hlist_node hash_list;
>  
>  	chunk_t old_chunk;
>  	chunk_t new_chunk;
> Index: linux-2.6/drivers/md/dm-snap.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-snap.c	2025-11-30 21:47:53.000000000 +0100
> +++ linux-2.6/drivers/md/dm-snap.c	2025-12-01 21:48:42.000000000 +0100
> @@ -40,10 +40,15 @@ static const char dm_snapshot_merge_targ
>  #define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
>  					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
>  
> +struct dm_hlist_head {
> +	struct hlist_head head;
> +	spinlock_t lock;
> +};
> +
>  struct dm_exception_table {
>  	uint32_t hash_mask;
>  	unsigned int hash_shift;
> -	struct hlist_bl_head *table;
> +	struct dm_hlist_head *table;
>  };
>  
>  struct dm_snapshot {
> @@ -628,8 +633,8 @@ static uint32_t exception_hash(struct dm
>  
>  /* Lock to protect access to the completed and pending exception hash tables. */
>  struct dm_exception_table_lock {
> -	struct hlist_bl_head *complete_slot;
> -	struct hlist_bl_head *pending_slot;
> +	spinlock_t *complete_slot;
> +	spinlock_t *pending_slot;
>  };
>  
>  static void dm_exception_table_lock_init(struct dm_snapshot *s, chunk_t chunk,
> @@ -638,20 +643,20 @@ static void dm_exception_table_lock_init
>  	struct dm_exception_table *complete = &s->complete;
>  	struct dm_exception_table *pending = &s->pending;
>  
> -	lock->complete_slot = &complete->table[exception_hash(complete, chunk)];
> -	lock->pending_slot = &pending->table[exception_hash(pending, chunk)];
> +	lock->complete_slot = &complete->table[exception_hash(complete, chunk)].lock;
> +	lock->pending_slot = &pending->table[exception_hash(pending, chunk)].lock;
>  }
>  
>  static void dm_exception_table_lock(struct dm_exception_table_lock *lock)
>  {
> -	hlist_bl_lock(lock->complete_slot);
> -	hlist_bl_lock(lock->pending_slot);
> +	spin_lock_nested(lock->complete_slot, 1);
> +	spin_lock_nested(lock->pending_slot, 2);
>  }
>  
>  static void dm_exception_table_unlock(struct dm_exception_table_lock *lock)
>  {
> -	hlist_bl_unlock(lock->pending_slot);
> -	hlist_bl_unlock(lock->complete_slot);
> +	spin_unlock(lock->pending_slot);
> +	spin_unlock(lock->complete_slot);
>  }
>  
>  static int dm_exception_table_init(struct dm_exception_table *et,
> @@ -661,13 +666,15 @@ static int dm_exception_table_init(struc
>  
>  	et->hash_shift = hash_shift;
>  	et->hash_mask = size - 1;
> -	et->table = kvmalloc_array(size, sizeof(struct hlist_bl_head),
> +	et->table = kvmalloc_array(size, sizeof(struct dm_hlist_head),
>  				   GFP_KERNEL);
>  	if (!et->table)
>  		return -ENOMEM;
>  
> -	for (i = 0; i < size; i++)
> -		INIT_HLIST_BL_HEAD(et->table + i);
> +	for (i = 0; i < size; i++) {
> +		INIT_HLIST_HEAD(&et->table[i].head);
> +		spin_lock_init(&et->table[i].lock);
> +	}
>  
>  	return 0;
>  }
> @@ -675,16 +682,17 @@ static int dm_exception_table_init(struc
>  static void dm_exception_table_exit(struct dm_exception_table *et,
>  				    struct kmem_cache *mem)
>  {
> -	struct hlist_bl_head *slot;
> +	struct dm_hlist_head *slot;
>  	struct dm_exception *ex;
> -	struct hlist_bl_node *pos, *n;
> +	struct hlist_node *pos;
>  	int i, size;
>  
>  	size = et->hash_mask + 1;
>  	for (i = 0; i < size; i++) {
>  		slot = et->table + i;
>  
> -		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
> +		hlist_for_each_entry_safe(ex, pos, &slot->head, hash_list) {
> +			hlist_del(&ex->hash_list);
>  			kmem_cache_free(mem, ex);
>  			cond_resched();
>  		}
> @@ -700,7 +708,7 @@ static uint32_t exception_hash(struct dm
>  
>  static void dm_remove_exception(struct dm_exception *e)
>  {
> -	hlist_bl_del(&e->hash_list);
> +	hlist_del(&e->hash_list);
>  }
>  
>  /*
> @@ -710,12 +718,11 @@ static void dm_remove_exception(struct d
>  static struct dm_exception *dm_lookup_exception(struct dm_exception_table *et,
>  						chunk_t chunk)
>  {
> -	struct hlist_bl_head *slot;
> -	struct hlist_bl_node *pos;
> +	struct hlist_head *slot;
>  	struct dm_exception *e;
>  
> -	slot = &et->table[exception_hash(et, chunk)];
> -	hlist_bl_for_each_entry(e, pos, slot, hash_list)
> +	slot = &et->table[exception_hash(et, chunk)].head;
> +	hlist_for_each_entry(e, slot, hash_list)
>  		if (chunk >= e->old_chunk &&
>  		    chunk <= e->old_chunk + dm_consecutive_chunk_count(e))
>  			return e;
> @@ -762,18 +769,17 @@ static void free_pending_exception(struc
>  static void dm_insert_exception(struct dm_exception_table *eh,
>  				struct dm_exception *new_e)
>  {
> -	struct hlist_bl_head *l;
> -	struct hlist_bl_node *pos;
> +	struct hlist_head *l;
>  	struct dm_exception *e = NULL;
>  
> -	l = &eh->table[exception_hash(eh, new_e->old_chunk)];
> +	l = &eh->table[exception_hash(eh, new_e->old_chunk)].head;
>  
>  	/* Add immediately if this table doesn't support consecutive chunks */
>  	if (!eh->hash_shift)
>  		goto out;
>  
>  	/* List is ordered by old_chunk */
> -	hlist_bl_for_each_entry(e, pos, l, hash_list) {
> +	hlist_for_each_entry(e, l, hash_list) {
>  		/* Insert after an existing chunk? */
>  		if (new_e->old_chunk == (e->old_chunk +
>  					 dm_consecutive_chunk_count(e) + 1) &&
> @@ -804,13 +810,13 @@ out:
>  		 * Either the table doesn't support consecutive chunks or slot
>  		 * l is empty.
>  		 */
> -		hlist_bl_add_head(&new_e->hash_list, l);
> +		hlist_add_head(&new_e->hash_list, l);
>  	} else if (new_e->old_chunk < e->old_chunk) {
>  		/* Add before an existing exception */
> -		hlist_bl_add_before(&new_e->hash_list, &e->hash_list);
> +		hlist_add_before(&new_e->hash_list, &e->hash_list);
>  	} else {
>  		/* Add to l's tail: e is the last exception in this slot */
> -		hlist_bl_add_behind(&new_e->hash_list, &e->hash_list);
> +		hlist_add_behind(&new_e->hash_list, &e->hash_list);
>  	}
>  }
>  
> @@ -820,7 +826,6 @@ out:
>   */
>  static int dm_add_exception(void *context, chunk_t old, chunk_t new)
>  {
> -	struct dm_exception_table_lock lock;
>  	struct dm_snapshot *s = context;
>  	struct dm_exception *e;
>  
> @@ -833,17 +838,7 @@ static int dm_add_exception(void *contex
>  	/* Consecutive_count is implicitly initialised to zero */
>  	e->new_chunk = new;
>  
> -	/*
> -	 * Although there is no need to lock access to the exception tables
> -	 * here, if we don't then hlist_bl_add_head(), called by
> -	 * dm_insert_exception(), will complain about accessing the
> -	 * corresponding list without locking it first.
> -	 */
> -	dm_exception_table_lock_init(s, old, &lock);
> -
> -	dm_exception_table_lock(&lock);
>  	dm_insert_exception(&s->complete, e);
> -	dm_exception_table_unlock(&lock);
>  
>  	return 0;
>  }
> @@ -873,7 +868,7 @@ static int calc_max_buckets(void)
>  	/* use a fixed size of 2MB */
>  	unsigned long mem = 2 * 1024 * 1024;
>  
> -	mem /= sizeof(struct hlist_bl_head);
> +	mem /= sizeof(struct dm_hlist_head);
>  
>  	return mem;
>  }

