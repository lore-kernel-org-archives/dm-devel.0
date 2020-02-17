From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/7] dax, pmem: Add a dax operation zero_page_range
Date: Mon, 17 Feb 2020 05:26:07 -0800
Message-ID: <20200217132607.GD14490@infradead.org>
References: <20200207202652.1439-1-vgoyal@redhat.com>
 <20200207202652.1439-4-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200207202652.1439-4-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com, dm-devel@redhat.com, vishal.l.verma@intel.com
List-Id: dm-devel.ids

> +	int rc;
> +	struct pmem_device *pmem = dax_get_private(dax_dev);
> +	struct page *page = ZERO_PAGE(0);

Nit: I tend to find code easier to read if variable declarations
with assignments are above those without.

Also I don't think we need the page variable here.

> +	rc = pmem_do_write(pmem, page, 0, offset, len);
> +	if (rc > 0)
> +		return -EIO;

pmem_do_write returns a blk_status_t, so the type of rc and the > check
seem odd.  But I think pmem_do_write (and pmem_do_read) might be better
off returning a normal errno anyway.
