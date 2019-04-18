From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [patch V2 03/29] lib/stackdepot: Provide functions which operate
 on plain storage arrays
Date: Thu, 18 Apr 2019 14:51:53 +0300
Message-ID: <20190418115152.GA13304@rapoport-lnx>
References: <20190418084119.056416939@linutronix.de>
 <20190418084253.337266121@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190418084253.337266121@linutronix.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Alexander Potapenko <glider@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Apr 18, 2019 at 10:41:22AM +0200, Thomas Gleixner wrote:
> The struct stack_trace indirection in the stack depot functions is a truly
> pointless excercise which requires horrible code at the callsites.
> 
> Provide interfaces based on plain storage arrays.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Alexander Potapenko <glider@google.com>
> ---
>  include/linux/stackdepot.h |    4 ++
>  lib/stackdepot.c           |   66 ++++++++++++++++++++++++++++++++-------------
>  2 files changed, 51 insertions(+), 19 deletions(-)
> 
> --- a/include/linux/stackdepot.h
> +++ b/include/linux/stackdepot.h
> @@ -26,7 +26,11 @@ typedef u32 depot_stack_handle_t;
>  struct stack_trace;
> 
>  depot_stack_handle_t depot_save_stack(struct stack_trace *trace, gfp_t flags);
> +depot_stack_handle_t stack_depot_save(unsigned long *entries,
> +				      unsigned int nr_entries, gfp_t gfp_flags);
> 
>  void depot_fetch_stack(depot_stack_handle_t handle, struct stack_trace *trace);
> +unsigned int stack_depot_fetch(depot_stack_handle_t handle,
> +			       unsigned long **entries);
> 
>  #endif
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -194,40 +194,56 @@ static inline struct stack_record *find_
>  	return NULL;
>  }
> 
> -void depot_fetch_stack(depot_stack_handle_t handle, struct stack_trace *trace)
> +/**
> + * stack_depot_fetch - Fetch stack entries from a depot
> + *

Nit: kernel-doc will complain about missing description of @handle.

> + * @entries:		Pointer to store the entries address
> + */
> +unsigned int stack_depot_fetch(depot_stack_handle_t handle,
> +			       unsigned long **entries)
>  {
>  	union handle_parts parts = { .handle = handle };
>  	void *slab = stack_slabs[parts.slabindex];
>  	size_t offset = parts.offset << STACK_ALLOC_ALIGN;
>  	struct stack_record *stack = slab + offset;
> 
> -	trace->nr_entries = trace->max_entries = stack->size;
> -	trace->entries = stack->entries;
> -	trace->skip = 0;
> +	*entries = stack->entries;
> +	return stack->size;
> +}
> +EXPORT_SYMBOL_GPL(stack_depot_fetch);
> +
> +void depot_fetch_stack(depot_stack_handle_t handle, struct stack_trace *trace)
> +{
> +	unsigned int nent = stack_depot_fetch(handle, &trace->entries);
> +
> +	trace->max_entries = trace->nr_entries = nent;
>  }
>  EXPORT_SYMBOL_GPL(depot_fetch_stack);
> 
>  /**
> - * depot_save_stack - save stack in a stack depot.
> - * @trace - the stacktrace to save.
> - * @alloc_flags - flags for allocating additional memory if required.
> + * stack_depot_save - Save a stack trace from an array
>   *
> - * Returns the handle of the stack struct stored in depot.
> + * @entries:		Pointer to storage array
> + * @nr_entries:		Size of the storage array
> + * @alloc_flags:	Allocation gfp flags
> + *
> + * Returns the handle of the stack struct stored in depot

Can you please s/Returns/Return:/ so that kernel-doc will recognize this as
return section.

>   */
> -depot_stack_handle_t depot_save_stack(struct stack_trace *trace,
> -				    gfp_t alloc_flags)
> +depot_stack_handle_t stack_depot_save(unsigned long *entries,
> +				      unsigned int nr_entries,
> +				      gfp_t alloc_flags)
>  {
> -	u32 hash;
> -	depot_stack_handle_t retval = 0;
>  	struct stack_record *found = NULL, **bucket;
> -	unsigned long flags;
> +	depot_stack_handle_t retval = 0;
>  	struct page *page = NULL;
>  	void *prealloc = NULL;
> +	unsigned long flags;
> +	u32 hash;
> 
> -	if (unlikely(trace->nr_entries == 0))
> +	if (unlikely(nr_entries == 0))
>  		goto fast_exit;
> 
> -	hash = hash_stack(trace->entries, trace->nr_entries);
> +	hash = hash_stack(entries, nr_entries);
>  	bucket = &stack_table[hash & STACK_HASH_MASK];
> 
>  	/*
> @@ -235,8 +251,8 @@ depot_stack_handle_t depot_save_stack(st
>  	 * The smp_load_acquire() here pairs with smp_store_release() to
>  	 * |bucket| below.
>  	 */
> -	found = find_stack(smp_load_acquire(bucket), trace->entries,
> -			   trace->nr_entries, hash);
> +	found = find_stack(smp_load_acquire(bucket), entries,
> +			   nr_entries, hash);
>  	if (found)
>  		goto exit;
> 
> @@ -264,10 +280,10 @@ depot_stack_handle_t depot_save_stack(st
> 
>  	spin_lock_irqsave(&depot_lock, flags);
> 
> -	found = find_stack(*bucket, trace->entries, trace->nr_entries, hash);
> +	found = find_stack(*bucket, entries, nr_entries, hash);
>  	if (!found) {
>  		struct stack_record *new =
> -			depot_alloc_stack(trace->entries, trace->nr_entries,
> +			depot_alloc_stack(entries, nr_entries,
>  					  hash, &prealloc, alloc_flags);
>  		if (new) {
>  			new->next = *bucket;
> @@ -297,4 +313,16 @@ depot_stack_handle_t depot_save_stack(st
>  fast_exit:
>  	return retval;
>  }
> +EXPORT_SYMBOL_GPL(stack_depot_save);
> +
> +/**
> + * depot_save_stack - save stack in a stack depot.
> + * @trace - the stacktrace to save.
> + * @alloc_flags - flags for allocating additional memory if required.
> + */
> +depot_stack_handle_t depot_save_stack(struct stack_trace *trace,
> +				      gfp_t alloc_flags)
> +{
> +	return stack_depot_save(trace->entries, trace->nr_entries, alloc_flags);
> +}
>  EXPORT_SYMBOL_GPL(depot_save_stack);
> 
> 

-- 
Sincerely yours,
Mike.
