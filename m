From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH v4 3/7] dax, pmem: Add a dax operation
 zero_page_range
Date: Tue, 18 Feb 2020 09:10:06 -0800
Message-ID: <20200218171006.GC30766@infradead.org>
References: <20200217181653.4706-1-vgoyal@redhat.com>
 <20200217181653.4706-4-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200217181653.4706-4-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com, vishal.l.verma@intel.com, dm-devel@redhat.com
List-Id: dm-devel.ids

> +static int pmem_dax_zero_page_range(struct dax_device *dax_dev, u64 offset,
> +				    size_t len)
> +{
> +	struct pmem_device *pmem = dax_get_private(dax_dev);
> +	blk_status_t rc;
> +
> +	rc = pmem_do_write(pmem, ZERO_PAGE(0), 0, offset, len);
> +	return blk_status_to_errno(rc);

No real need for the rc variable here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
