From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/6] dax: Define a helper dax_pgoff() which takes in
 dax_offset as argument
Date: Mon, 17 Feb 2020 05:37:47 -0800
Message-ID: <20200217133747.GJ7778@bombadil.infradead.org>
References: <20200212170733.8092-1-vgoyal@redhat.com>
 <20200212170733.8092-2-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200212170733.8092-2-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org, dm-devel@redhat.com, jack@suse.cz
List-Id: dm-devel.ids

On Wed, Feb 12, 2020 at 12:07:28PM -0500, Vivek Goyal wrote:
> +int dax_pgoff(sector_t dax_offset, sector_t sector, size_t size, pgoff_t *pgoff)
> +{
> +	phys_addr_t phys_off = (dax_offset + sector) * 512;
> +
> +	if (pgoff)
> +		*pgoff = PHYS_PFN(phys_off);
> +	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
> +		return -EINVAL;
> +	return 0;

This is why we have IS_ERR_VALUE().  Just make this function return
a pgoff_t.
