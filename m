From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 18/20] dm: clean up GFP_NIO usage
Date: Thu, 28 Apr 2016 10:20:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1604281016520.14065@file01.intranet.prod.int.rdu2.redhat.com>
References: <1461849846-27209-1-git-send-email-mhocko@kernel.org> <1461849846-27209-19-git-send-email-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1461849846-27209-19-git-send-email-mhocko@kernel.org>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids



On Thu, 28 Apr 2016, Michal Hocko wrote:

> From: Michal Hocko <mhocko@suse.com>
> 
> copy_params uses GFP_NOIO for explicit allocation requests because this
> might be called from the suspend path. To quote Mikulas:
> : The LVM tool calls suspend and resume ioctls on device mapper block
> : devices.
> :
> : When a device is suspended, any bio sent to the device is held. If the
> : resume ioctl did GFP_KERNEL allocation, the allocation could get stuck
> : trying to write some dirty cached pages to the suspended device.
> :
> : The LVM tool and the dmeventd daemon use mlock to lock its address space,
> : so the copy_from_user/copy_to_user call cannot trigger a page fault.
> 
> Relying on the mlock is quite fragile and we have a better way in kernel
> to enfore NOIO which is already used for the vmalloc fallback. Just use
> memalloc_noio_{save,restore} around the whole copy_params function which
> will force the same also to the page fult paths via copy_{from,to}_user.

The userspace memory is locked, so we don't need to use memalloc_noio_save 
around copy_from_user. If the memory weren't locked, memalloc_noio_save 
wouldn't help us to prevent the IO.

We don't need this change (unless you show that it fixes real bug).

Mikulas

> While we are there we can also remove __GFP_NOMEMALLOC because copy_params
> is never called from MEMALLOC context (e.g. during the reclaim).
> 
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: dm-devel@redhat.com
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> ---
>  drivers/md/dm-ioctl.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 2c7ca258c4e4..fe0b57d7573c 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1715,16 +1715,13 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
>  	 */
>  	dmi = NULL;
>  	if (param_kernel->data_size <= KMALLOC_MAX_SIZE) {
> -		dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +		dmi = kmalloc(param_kernel->data_size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
>  		if (dmi)
>  			*param_flags |= DM_PARAMS_KMALLOC;
>  	}
>  
>  	if (!dmi) {
> -		unsigned noio_flag;
> -		noio_flag = memalloc_noio_save();
> -		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
> -		memalloc_noio_restore(noio_flag);
> +		dmi = __vmalloc(param_kernel->data_size, GFP_KERNEL | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
>  		if (dmi)
>  			*param_flags |= DM_PARAMS_VMALLOC;
>  	}
> @@ -1801,6 +1798,7 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
>  	ioctl_fn fn = NULL;
>  	size_t input_param_size;
>  	struct dm_ioctl param_kernel;
> +	unsigned noio_flag;
>  
>  	/* only root can play with this */
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -1832,9 +1830,12 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
>  	}
>  
>  	/*
> -	 * Copy the parameters into kernel space.
> +	 * Copy the parameters into kernel space. Make sure that no IO is triggered
> +	 * from the allocation paths because this might be called during the suspend.
>  	 */
> +	noio_flag = memalloc_noio_save();
>  	r = copy_params(user, &param_kernel, ioctl_flags, &param, &param_flags);
> +	memalloc_noio_restore(noio_flag);
>  
>  	if (r)
>  		return r;
> -- 
> 2.8.0.rc3
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
