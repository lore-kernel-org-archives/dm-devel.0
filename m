From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 4/8] dax, pmem: Add a dax operation zero_page_range
Date: Tue, 31 Mar 2020 12:38:16 -0700
Message-ID: <CAPcyv4jKHxy5c8BZodePeCu5+Z=cwhtEfw3RnOD1ZDNob382bQ@mail.gmail.com>
References: <20200218214841.10076-1-vgoyal@redhat.com> <20200218214841.10076-5-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200218214841.10076-5-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Tue, Feb 18, 2020 at 1:49 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Add a dax operation zero_page_range, to zero a range of memory. This will
> also clear any poison in the range being zeroed.
>
> As of now, zeroing of up to one page is allowed in a single call. There
> are no callers which are trying to zero more than a page in a single call.
> Once we grow the callers which zero more than a page in single call, we
> can add that support. Primary reason for not doing that yet is that this
> will add little complexity in dm implementation where a range might be
> spanning multiple underlying targets and one will have to split the range
> into multiple sub ranges and call zero_page_range() on individual targets.
>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  drivers/dax/super.c   | 19 +++++++++++++++++++
>  drivers/nvdimm/pmem.c | 10 ++++++++++
>  include/linux/dax.h   |  3 +++
>  3 files changed, 32 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 0aa4b6bc5101..c912808bc886 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -344,6 +344,25 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>  }
>  EXPORT_SYMBOL_GPL(dax_copy_to_iter);
>
> +int dax_zero_page_range(struct dax_device *dax_dev, u64 offset, size_t len)
> +{
> +       if (!dax_alive(dax_dev))
> +               return -ENXIO;
> +
> +       if (!dax_dev->ops->zero_page_range)
> +               return -EOPNOTSUPP;

This seems too late to be doing the validation. It would be odd for
random filesystem operations to see this error. I would move the check
to alloc_dax() and fail that if the caller fails to implement the
operation.

An incremental patch on top to fix this up would be ok. Something like
"Now that all dax_operations providers implement zero_page_range()
mandate it at alloc_dax time".
