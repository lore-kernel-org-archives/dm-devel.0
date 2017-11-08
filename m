From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vmalloc: introduce vmap_pfn for persistent memory
Date: Wed, 8 Nov 2017 01:59:09 -0800
Message-ID: <20171108095909.GA7390@infradead.org>
References: <alpine.LRH.2.02.1711071645240.1339@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1711071645240.1339@file01.intranet.prod.int.rdu2.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, dm-devel@redhat.com, Laura Abbott <labbott@redhat.com>, Christoph Hellwig <hch@lst.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: dm-devel.ids

On Tue, Nov 07, 2017 at 05:03:11PM -0500, Mikulas Patocka wrote:
> Hi
> 
> I am developing a driver that uses persistent memory for caching. A 
> persistent memory device can be mapped in several discontiguous ranges.
> 
> The kernel has a function vmap that takes an array of pointers to pages 
> and maps these pages to contiguous linear address space. However, it can't 
> be used on persistent memory because persistent memory may not be backed 
> by page structures.
> 
> This patch introduces a new function vmap_pfn, it works like vmap, but 
> takes an array of pfn_t - so it can be used on persistent memory.

How is cache flushing going to work for this interface assuming
that your write to/from the virtual address and expect it to be
persisted on pmem?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
