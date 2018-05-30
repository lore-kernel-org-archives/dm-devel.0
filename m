From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-writecache: fix compilation issue with !DAX
Date: Wed, 30 May 2018 08:22:47 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1805300821510.24812@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180529175216.24937-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529175216.24937-1-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Matthew Wilcox <mawilcox@microsoft.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Heinz Mauelshagen <heinzm@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Tue, 29 May 2018, Ross Zwisler wrote:

> As reported by Arnd (https://lkml.org/lkml/2018/5/28/1697), dm-writecache
> will fail with link errors in configs where DAX isn't present:
> 
> drivers/md/dm-writecache.o: In function `writecache_ctr':
> dm-writecache.c:(.text+0x1fdc): undefined reference to `dax_read_lock'
> dm-writecache.c:(.text+0x2004): undefined reference to `dax_direct_access'
> dm-writecache.c:(.text+0x21cc): undefined reference to `dax_read_unlock'
> 
> Fix this by following the lead of the other DM modules and wrapping calls
> to the generic DAX code in #if IS_ENABLED(CONFIG_DAX_DRIVER) blocks.
> 
> We also expand the failure case for the 'p' (persistent memory) flag so
> that fails on both architectures that don't support persistent memory and
> on kernels that don't have DAX support configured.  This prevents us from
> ever hitting the BUG() in the persistent_memory_claim() stub.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/md/dm-writecache.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 92af65fdf4af..1c2b53ae1a96 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -253,6 +253,7 @@ static void wc_unlock(struct dm_writecache *wc)
>  	mutex_unlock(&wc->lock);
>  }
>  
> +#if IS_ENABLED(CONFIG_DAX_DRIVER)

We already have #if(n)def DM_WRITECACHE_ONLY_SSD

There is no need to use another macro for the same purpose.

Mikulas

>  static int persistent_memory_claim(struct dm_writecache *wc)
>  {
>  	int r;
> @@ -337,6 +338,12 @@ static int persistent_memory_claim(struct dm_writecache *wc)
>  err1:
>  	return r;
>  }
> +#else
> +static int persistent_memory_claim(struct dm_writecache *wc)
> +{
> +	BUG();
> +}
> +#endif
>  
>  static void persistent_memory_release(struct dm_writecache *wc)
>  {
> @@ -1901,16 +1908,17 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	if (!strcasecmp(string, "s")) {
>  		wc->pmem_mode = false;
>  	} else if (!strcasecmp(string, "p")) {
> -#ifdef CONFIG_ARCH_HAS_PMEM_API
> +#if defined(CONFIG_ARCH_HAS_PMEM_API) && IS_ENABLED(CONFIG_DAX_DRIVER)
>  		wc->pmem_mode = true;
>  		wc->writeback_fua = true;
>  #else
>  		/*
> -		 * If the architecture doesn't support persistent memory, this
> -		 * driver can only be used in SSD-only mode.
> +		 * If the architecture doesn't support persistent memory or
> +		 * the kernel doesn't support any DAX drivers, this driver can
> +		 * only be used in SSD-only mode.
>  		 */
>  		r = -EOPNOTSUPP;
> -		ti->error = "Persistent memory not supported on this architecture";
> +		ti->error = "Persistent memory or DAX not supported on this system";
>  		goto bad;
>  #endif
>  	} else {
> -- 
> 2.14.3
> 
