From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 08/14] x86, dax, libnvdimm: move wb_cache_pmem() to
 libnvdimm
Date: Wed, 14 Jun 2017 12:54:25 +0200
Message-ID: <20170614105425.GD21506@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703986971.20620.10303247412197996310.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <149703986971.20620.10303247412197996310.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>, dm-devel@redhat.com, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, hch@lst.de, Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@redhat.com>, Oliver O'Halloran <oohall@gmail.com>, viro@zeniv.linux.org.uk, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: dm-devel.ids

On Fri 09-06-17 13:24:29, Dan Williams wrote:
> With all calls to this routine re-directed through the pmem driver, we can kill
> the pmem api indirection. arch_wb_cache_pmem() is now optionally supplied by
> the arch specific asm/pmem.h.  Same as before, pmem flushing is only defined
> for x86_64, but it is straightforward to add other archs in the future.
> 
> Cc: <x86@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Oliver O'Halloran <oohall@gmail.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. Just one question below...

> -/**
> - * arch_wb_cache_pmem - write back a cache range with CLWB
> - * @vaddr:	virtual start address
> - * @size:	number of bytes to write back
> - *
> - * Write back a cache range using the CLWB (cache line write back)
> - * instruction. Note that @size is internally rounded up to be cache
> - * line size aligned.
> - */
>  static inline void arch_wb_cache_pmem(void *addr, size_t size)
>  {
> -	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
> -	unsigned long clflush_mask = x86_clflush_size - 1;
> -	void *vend = addr + size;
> -	void *p;
> -
> -	for (p = (void *)((unsigned long)addr & ~clflush_mask);
> -	     p < vend; p += x86_clflush_size)
> -		clwb(p);
> +	clean_cache_range(addr,size);
>  }

So this will make compilation break on 32-bit x86 as it does not define
clean_cache_range(). Do we somewhere force we are on x86_64 when pmem is
enabled?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
