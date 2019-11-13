From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH RT 1/2 v2] dm-snapshot: fix crash with the realtime kernel
Date: Wed, 13 Nov 2019 11:20:35 +0200
Message-ID: <ab6fa08d-256a-1f8c-24dd-e5c23b3328bf@arrikto.com>
References: <alpine.LRH.2.02.1911121057490.12815@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1911121057490.12815@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: Scott Wood <swood@redhat.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-rt-users@vger.kernel.org, tglx@linutronix.de
List-Id: dm-devel.ids

On 11/12/19 6:09 PM, Mikulas Patocka wrote:
> Snapshot doesn't work with realtime kernels since the commit f79ae415b64c.
> hlist_bl is implemented as a raw spinlock and the code takes two non-raw
> spinlocks while holding hlist_bl (non-raw spinlocks are blocking mutexes
> in the realtime kernel).
> 
> We can't change hlist_bl to use non-raw spinlocks, this triggers warnings 
> in dentry lookup code, because the dentry lookup code uses hlist_bl while 
> holding a seqlock.
> 
> This patch fixes the problem by using non-raw spinlock 
> exception_table_lock instead of the hlist_bl lock.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: f79ae415b64c ("dm snapshot: Make exception tables scalable")
> 

Reviewed-by: Nikos Tsironis <ntsironis@arrikto.com>

> ---
>  drivers/md/dm-snap.c |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> Index: linux-2.6/drivers/md/dm-snap.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-snap.c	2019-11-12 16:44:36.000000000 +0100
> +++ linux-2.6/drivers/md/dm-snap.c	2019-11-12 17:01:46.000000000 +0100
> @@ -141,6 +141,10 @@ struct dm_snapshot {
>  	 * for them to be committed.
>  	 */
>  	struct bio_list bios_queued_during_merge;
> +
> +#ifdef CONFIG_PREEMPT_RT_BASE
> +	spinlock_t exception_table_lock;
> +#endif
>  };
>  
>  /*
> @@ -625,30 +629,46 @@ static uint32_t exception_hash(struct dm
>  
>  /* Lock to protect access to the completed and pending exception hash tables. */
>  struct dm_exception_table_lock {
> +#ifndef CONFIG_PREEMPT_RT_BASE
>  	struct hlist_bl_head *complete_slot;
>  	struct hlist_bl_head *pending_slot;
> +#else
> +	spinlock_t *lock;
> +#endif
>  };
>  
>  static void dm_exception_table_lock_init(struct dm_snapshot *s, chunk_t chunk,
>  					 struct dm_exception_table_lock *lock)
>  {
> +#ifndef CONFIG_PREEMPT_RT_BASE
>  	struct dm_exception_table *complete = &s->complete;
>  	struct dm_exception_table *pending = &s->pending;
>  
>  	lock->complete_slot = &complete->table[exception_hash(complete, chunk)];
>  	lock->pending_slot = &pending->table[exception_hash(pending, chunk)];
> +#else
> +	lock->lock = &s->exception_table_lock;
> +#endif
>  }
>  
>  static void dm_exception_table_lock(struct dm_exception_table_lock *lock)
>  {
> +#ifndef CONFIG_PREEMPT_RT_BASE
>  	hlist_bl_lock(lock->complete_slot);
>  	hlist_bl_lock(lock->pending_slot);
> +#else
> +	spin_lock(lock->lock);
> +#endif
>  }
>  
>  static void dm_exception_table_unlock(struct dm_exception_table_lock *lock)
>  {
> +#ifndef CONFIG_PREEMPT_RT_BASE
>  	hlist_bl_unlock(lock->pending_slot);
>  	hlist_bl_unlock(lock->complete_slot);
> +#else
> +	spin_unlock(lock->lock);
> +#endif
>  }
>  
>  static int dm_exception_table_init(struct dm_exception_table *et,
> @@ -1318,6 +1338,9 @@ static int snapshot_ctr(struct dm_target
>  	s->first_merging_chunk = 0;
>  	s->num_merging_chunks = 0;
>  	bio_list_init(&s->bios_queued_during_merge);
> +#ifdef CONFIG_PREEMPT_RT_BASE
> +	spin_lock_init(&s->exception_table_lock);
> +#endif
>  
>  	/* Allocate hash table for COW data */
>  	if (init_hash_tables(s)) {
> 
