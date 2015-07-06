From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/7] dm: introduce dm_kvmalloc
Date: Mon, 6 Jul 2015 09:47:50 -0400
Message-ID: <20150706134750.GA31600@redhat.com>
References: <alpine.LRH.2.02.1507031658500.28837@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1507031658500.28837@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Jul 03 2015 at  4:59pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Introduce the functions dm_kvmalloc and dm_kvmalloc_node. These functions
> attempt to do allocation with kmalloc and if it fails, use vmalloc. Memory
> allocated with these functions should be freed with kvfree (that function
> is already present in the Linux kernel).
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-ioctl.c         |   26 +++++---------------------
>  drivers/md/dm-table.c         |   37 +++++++++++++++++++++++++++++++++++++
>  include/linux/device-mapper.h |    2 ++
>  3 files changed, 44 insertions(+), 21 deletions(-)
> 
> Index: linux-4.1/drivers/md/dm-ioctl.c
> ===================================================================
> --- linux-4.1.orig/drivers/md/dm-ioctl.c	2015-07-02 19:21:15.000000000 +0200
> +++ linux-4.1/drivers/md/dm-ioctl.c	2015-07-02 19:21:21.000000000 +0200
> @@ -1676,12 +1676,8 @@ static void free_params(struct dm_ioctl 
>  	if (param_flags & DM_WIPE_BUFFER)
>  		memset(param, 0, param_size);
>  
> -	if (param_flags & DM_PARAMS_ALLOC) {
> -		if (is_vmalloc_addr(param))
> -			vfree(param);
> -		else
> -			kfree(param);
> -	}
> +	if (param_flags & DM_PARAMS_ALLOC)
> +		kvfree(param);
>  }
>  
>  static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,
> @@ -1712,21 +1708,7 @@ static int copy_params(struct dm_ioctl _
>  	 * Try to avoid low memory issues when a device is suspended.
>  	 * Use kmalloc() rather than vmalloc() when we can.
>  	 */
> -	dmi = NULL;
> -	if (param_kernel->data_size <= KMALLOC_MAX_SIZE) {
> -		dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> -		if (dmi)
> -			*param_flags |= DM_PARAMS_ALLOC;
> -	}
> -
> -	if (!dmi) {
> -		unsigned noio_flag;
> -		noio_flag = memalloc_noio_save();
> -		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
> -		memalloc_noio_restore(noio_flag);
> -		if (dmi)
> -			*param_flags |= DM_PARAMS_ALLOC;
> -	}
> +	dmi = dm_kvmalloc(param_kernel->data_size, GFP_NOIO);
>  
>  	if (!dmi) {
>  		if (secure_data && clear_user(user, param_kernel->data_size))
> @@ -1734,6 +1716,8 @@ static int copy_params(struct dm_ioctl _
>  		return -ENOMEM;
>  	}
>  
> +	*param_flags |= DM_PARAMS_ALLOC;
> +
>  	if (copy_from_user(dmi, user, param_kernel->data_size))
>  		goto bad;
>  
> Index: linux-4.1/include/linux/device-mapper.h
> ===================================================================
> --- linux-4.1.orig/include/linux/device-mapper.h	2015-07-02 19:21:16.000000000 +0200
> +++ linux-4.1/include/linux/device-mapper.h	2015-07-02 19:21:21.000000000 +0200
> @@ -475,6 +475,8 @@ struct dm_table *dm_swap_table(struct ma
>  /*
>   * A wrapper around vmalloc.
>   */
> +void *dm_kvmalloc_node(size_t size, gfp_t gfp, int node);
> +void *dm_kvmalloc(size_t size, gfp_t gfp);
>  void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
>  
>  /*-----------------------------------------------------------------
> Index: linux-4.1/drivers/md/dm-table.c
> ===================================================================
> --- linux-4.1.orig/drivers/md/dm-table.c	2015-07-02 19:21:16.000000000 +0200
> +++ linux-4.1/drivers/md/dm-table.c	2015-07-02 19:28:18.000000000 +0200
> @@ -131,6 +131,43 @@ static int setup_btree_index(unsigned in
>  	return 0;
>  }
>  
> +void *dm_kvmalloc_node(size_t size, gfp_t gfp, int node)
> +{
> +	void *p;
> +	unsigned uninitialized_var(noio_flag);
> +
> +	/* vmalloc doesn't support no-wait allocations */
> +	WARN_ON(!(gfp & __GFP_WAIT));
> +
> +	if (likely(size <= KMALLOC_MAX_SIZE)) {
> +		p = kmalloc_node(size, gfp | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN, node);
> +		if (likely(p != NULL))
> +			return p;
> +	}
> +	if ((gfp & (__GFP_IO | __GFP_FS)) != (__GFP_IO | __GFP_FS)) {
> +		/*
> +		 * vmalloc allocates page tables with GFP_KERNEL, regardless
> +		 * of GFP flags passed to it. If we are no GFP_NOIO context,
> +		 * we call memalloc_noio_save, so that all allocations are
> +		 * implicitly done with GFP_NOIO.
> +		 */
> +		noio_flag = memalloc_noio_save();
> +		gfp |= __GFP_HIGH;
> +	}
> +	p = __vmalloc_node_flags(size, node, gfp | __GFP_REPEAT | __GFP_HIGHMEM);
> +	if ((gfp & (__GFP_IO | __GFP_FS)) != (__GFP_IO | __GFP_FS)) {
> +		memalloc_noio_restore(noio_flag);
> +	}
> +	return p;
> +}
> +EXPORT_SYMBOL(dm_kvmalloc_node);
> +
> +void *dm_kvmalloc(size_t size, gfp_t gfp)
> +{
> +	return dm_kvmalloc_node(size, gfp, NUMA_NO_NODE);
> +}
> +EXPORT_SYMBOL(dm_kvmalloc);
> +
>  void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size)
>  {
>  	unsigned long size;
> 

In general I like what you've done with this patchset _except_ I'm not
seeing why dm_kvmalloc() should be in DM at all.  It should probably be
elevated to an kvmalloc() export from mm/util.c and include/linux/mm.h
along-side kvfree().

David and/or Andrew, what do you think?

FYI, full patchset starts here:
https://www.redhat.com/archives/dm-devel/2015-July/msg00004.html

(but Mikulas didn't chain the reply so the 7 patches aren't properly
threaded/navigated, you can dig out the patches toward the top of the
list here: https://patchwork.kernel.org/project/dm-devel/list/ )
