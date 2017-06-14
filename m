From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 03/14] filesystem-dax: convert to dax_copy_from_iter()
Date: Wed, 14 Jun 2017 12:58:33 +0200
Message-ID: <20170614105833.GH21506@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703984208.20620.7803227571371078891.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <149703984208.20620.7803227571371078891.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

On Fri 09-06-17 13:24:02, Dan Williams wrote:
> Now that all possible providers of the dax_operations copy_from_iter
> method are implemented, switch filesytem-dax to call the driver rather
> than copy_to_iter_pmem.
> 
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  arch/x86/include/asm/pmem.h |   50 -------------------------------------------
>  fs/dax.c                    |    3 ++-
>  include/linux/pmem.h        |   24 ---------------------
>  3 files changed, 2 insertions(+), 75 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
> index 0ff8fe71b255..60e8edbe0205 100644
> --- a/arch/x86/include/asm/pmem.h
> +++ b/arch/x86/include/asm/pmem.h
> @@ -66,56 +66,6 @@ static inline void arch_wb_cache_pmem(void *addr, size_t size)
>  }
>  
>  /**
> - * arch_copy_from_iter_pmem - copy data from an iterator to PMEM
> - * @addr:	PMEM destination address
> - * @bytes:	number of bytes to copy
> - * @i:		iterator with source data
> - *
> - * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
> - */
> -static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
> -		struct iov_iter *i)
> -{
> -	size_t len;
> -
> -	/* TODO: skip the write-back by always using non-temporal stores */
> -	len = copy_from_iter_nocache(addr, bytes, i);
> -
> -	/*
> -	 * In the iovec case on x86_64 copy_from_iter_nocache() uses
> -	 * non-temporal stores for the bulk of the transfer, but we need
> -	 * to manually flush if the transfer is unaligned. A cached
> -	 * memory copy is used when destination or size is not naturally
> -	 * aligned. That is:
> -	 *   - Require 8-byte alignment when size is 8 bytes or larger.
> -	 *   - Require 4-byte alignment when size is 4 bytes.
> -	 *
> -	 * In the non-iovec case the entire destination needs to be
> -	 * flushed.
> -	 */
> -	if (iter_is_iovec(i)) {
> -		unsigned long flushed, dest = (unsigned long) addr;
> -
> -		if (bytes < 8) {
> -			if (!IS_ALIGNED(dest, 4) || (bytes != 4))
> -				arch_wb_cache_pmem(addr, bytes);
> -		} else {
> -			if (!IS_ALIGNED(dest, 8)) {
> -				dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
> -				arch_wb_cache_pmem(addr, 1);
> -			}
> -
> -			flushed = dest - (unsigned long) addr;
> -			if (bytes > flushed && !IS_ALIGNED(bytes - flushed, 8))
> -				arch_wb_cache_pmem(addr + bytes - 1, 1);
> -		}
> -	} else
> -		arch_wb_cache_pmem(addr, bytes);
> -
> -	return len;
> -}
> -
> -/**
>   * arch_clear_pmem - zero a PMEM memory range
>   * @addr:	virtual start address
>   * @size:	number of bytes to zero
> diff --git a/fs/dax.c b/fs/dax.c
> index 2a6889b3585f..b459948de427 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1054,7 +1054,8 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  			map_len = end - pos;
>  
>  		if (iov_iter_rw(iter) == WRITE)
> -			map_len = copy_from_iter_pmem(kaddr, map_len, iter);
> +			map_len = dax_copy_from_iter(dax_dev, pgoff, kaddr,
> +					map_len, iter);
>  		else
>  			map_len = copy_to_iter(kaddr, map_len, iter);
>  		if (map_len <= 0) {
> diff --git a/include/linux/pmem.h b/include/linux/pmem.h
> index 71ecf3d46aac..9d542a5600e4 100644
> --- a/include/linux/pmem.h
> +++ b/include/linux/pmem.h
> @@ -31,13 +31,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
>  	BUG();
>  }
>  
> -static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
> -		struct iov_iter *i)
> -{
> -	BUG();
> -	return 0;
> -}
> -
>  static inline void arch_clear_pmem(void *addr, size_t size)
>  {
>  	BUG();
> @@ -80,23 +73,6 @@ static inline void memcpy_to_pmem(void *dst, const void *src, size_t n)
>  }
>  
>  /**
> - * copy_from_iter_pmem - copy data from an iterator to PMEM
> - * @addr:	PMEM destination address
> - * @bytes:	number of bytes to copy
> - * @i:		iterator with source data
> - *
> - * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
> - * See blkdev_issue_flush() note for memcpy_to_pmem().
> - */
> -static inline size_t copy_from_iter_pmem(void *addr, size_t bytes,
> -		struct iov_iter *i)
> -{
> -	if (arch_has_pmem_api())
> -		return arch_copy_from_iter_pmem(addr, bytes, i);
> -	return copy_from_iter_nocache(addr, bytes, i);
> -}
> -
> -/**
>   * clear_pmem - zero a PMEM memory range
>   * @addr:	virtual start address
>   * @size:	number of bytes to zero
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
