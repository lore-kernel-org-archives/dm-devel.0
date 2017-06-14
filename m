From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 04/14] dax, pmem: introduce an optional 'flush'
 dax_operation
Date: Wed, 14 Jun 2017 12:57:31 +0200
Message-ID: <20170614105731.GG21506@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703984722.20620.1577767383686219477.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <149703984722.20620.1577767383686219477.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

On Fri 09-06-17 13:24:07, Dan Williams wrote:
> Filesystem-DAX flushes caches whenever it writes to the address returned
> through dax_direct_access() and when writing back dirty radix entries.
> That flushing is only required in the pmem case, so add a dax operation
> to allow pmem to take this extra action, but skip it for other dax
> capable devices that do not provide a flush routine.
> 
> An example for this differentiation might be a volatile ram disk where
> there is no expectation of persistence. In fact the pmem driver itself might
> front such an address range specified by the NFIT. So, this "no flush"
> property might be something passed down by the bus / libnvdimm.
> 
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  drivers/nvdimm/pmem.c |    7 +++++++
>  include/linux/dax.h   |    2 ++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 2f3aefe565c6..823b07774244 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -242,9 +242,16 @@ static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>  	return copy_from_iter_flushcache(addr, bytes, i);
>  }
>  
> +static void pmem_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff,
> +		void *addr, size_t size)
> +{
> +	wb_cache_pmem(addr, size);
> +}
> +
>  static const struct dax_operations pmem_dax_ops = {
>  	.direct_access = pmem_dax_direct_access,
>  	.copy_from_iter = pmem_copy_from_iter,
> +	.flush = pmem_dax_flush,
>  };
>  
>  static void pmem_release_queue(void *q)
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 28e398f8c59e..407dd3ff6e54 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -19,6 +19,8 @@ struct dax_operations {
>  	/* copy_from_iter: dax-driver override for default copy_from_iter */
>  	size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
>  			struct iov_iter *);
> +	/* flush: optional driver-specific cache management after writes */
> +	void (*flush)(struct dax_device *, pgoff_t, void *, size_t);
>  };
>  
>  #if IS_ENABLED(CONFIG_DAX)
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
