From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 07/14] x86, dax: replace clear_pmem() with open coded
 memset + dax_ops->flush
Date: Wed, 14 Jun 2017 12:55:42 +0200
Message-ID: <20170614105542.GE21506@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703986417.20620.16200765147913100718.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <149703986417.20620.16200765147913100718.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

On Fri 09-06-17 13:24:24, Dan Williams wrote:
> The clear_pmem() helper simply combines a memset() plus a cache flush.
> Now that the flush routine is optionally provided by the dax device
> driver we can avoid unnecessary cache management on dax devices fronting
> volatile memory.
> 
> With clear_pmem() gone we can follow on with a patch to make pmem cache
> management completely defined within the pmem driver.
> 
> Cc: <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza


> ---
>  arch/x86/include/asm/pmem.h |   13 -------------
>  fs/dax.c                    |    3 ++-
>  include/linux/pmem.h        |   21 ---------------------
>  3 files changed, 2 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
> index 60e8edbe0205..f4c119d253f3 100644
> --- a/arch/x86/include/asm/pmem.h
> +++ b/arch/x86/include/asm/pmem.h
> @@ -65,19 +65,6 @@ static inline void arch_wb_cache_pmem(void *addr, size_t size)
>  		clwb(p);
>  }
>  
> -/**
> - * arch_clear_pmem - zero a PMEM memory range
> - * @addr:	virtual start address
> - * @size:	number of bytes to zero
> - *
> - * Write zeros into the memory range starting at 'addr' for 'size' bytes.
> - */
> -static inline void arch_clear_pmem(void *addr, size_t size)
> -{
> -	memset(addr, 0, size);
> -	arch_wb_cache_pmem(addr, size);
> -}
> -
>  static inline void arch_invalidate_pmem(void *addr, size_t size)
>  {
>  	clflush_cache_range(addr, size);
> diff --git a/fs/dax.c b/fs/dax.c
> index 0933fc460ada..554b8e7d921c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -975,7 +975,8 @@ int __dax_zero_page_range(struct block_device *bdev,
>  			dax_read_unlock(id);
>  			return rc;
>  		}
> -		clear_pmem(kaddr + offset, size);
> +		memset(kaddr + offset, 0, size);
> +		dax_flush(dax_dev, pgoff, kaddr + offset, size);
>  		dax_read_unlock(id);
>  	}
>  	return 0;
> diff --git a/include/linux/pmem.h b/include/linux/pmem.h
> index 9d542a5600e4..772bd02a5b52 100644
> --- a/include/linux/pmem.h
> +++ b/include/linux/pmem.h
> @@ -31,11 +31,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
>  	BUG();
>  }
>  
> -static inline void arch_clear_pmem(void *addr, size_t size)
> -{
> -	BUG();
> -}
> -
>  static inline void arch_wb_cache_pmem(void *addr, size_t size)
>  {
>  	BUG();
> @@ -73,22 +68,6 @@ static inline void memcpy_to_pmem(void *dst, const void *src, size_t n)
>  }
>  
>  /**
> - * clear_pmem - zero a PMEM memory range
> - * @addr:	virtual start address
> - * @size:	number of bytes to zero
> - *
> - * Write zeros into the memory range starting at 'addr' for 'size' bytes.
> - * See blkdev_issue_flush() note for memcpy_to_pmem().
> - */
> -static inline void clear_pmem(void *addr, size_t size)
> -{
> -	if (arch_has_pmem_api())
> -		arch_clear_pmem(addr, size);
> -	else
> -		memset(addr, 0, size);
> -}
> -
> -/**
>   * invalidate_pmem - flush a pmem range from the cache hierarchy
>   * @addr:	virtual start address
>   * @size:	bytes to invalidate (internally aligned to cache line size)
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
