From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/7] dm: fix test for DAX device support
Date: Fri, 1 Jun 2018 16:19:25 -0400
Message-ID: <20180601201924.GA1144@redhat.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-4-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180529195106.14268-4-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

On Tue, May 29 2018 at  3:51P -0400,
Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

> Currently device_supports_dax() just checks to see if the QUEUE_FLAG_DAX
> flag is set on the device's request queue to decide whether or not the
> device supports filesystem DAX.  This is insufficient because there are
> devices like PMEM namespaces in raw mode which have QUEUE_FLAG_DAX set but
> which don't actually support DAX.

Isn't that a PMEM bug then?

What is the point of setting QUEUE_FLAG_DAX if it cannot be trusted?
 
> This means that you could create a dm-linear device, for example, where the
> first part of the dm-linear device was a PMEM namespace in fsdax mode and
> the second part was a PMEM namespace in raw mode.  Both DM and the
> filesystem you put on that dm-linear device would think the whole device
> supports DAX, which would lead to bad behavior once your raw PMEM namespace
> part using DAX needed struct page for something.

The PMEM namespace in raw mode shouldn't be setting QUEUE_FLAG_DAX, if
it didn't then the stacked-up linear DM wouldn't 

> Fix this by using bdev_dax_supported() like filesystems do at mount time.
> This checks for raw mode and also performs other tests like checking to
> make sure the dax_direct_access() path works.

Sorry "This" does those things where?

> 
> Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Fixes: commit 545ed20e6df6 ("dm: add infrastructure for DAX support")
> ---
>  drivers/md/dm-table.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 0589a4da12bb..5bb994b012ca 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -885,9 +885,7 @@ EXPORT_SYMBOL_GPL(dm_table_set_type);
>  static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
>  			       sector_t start, sector_t len, void *data)
>  {
> -	struct request_queue *q = bdev_get_queue(dev->bdev);
> -
> -	return q && blk_queue_dax(q);
> +	return bdev_dax_supported(dev->bdev, PAGE_SIZE);
>  }
>  
>  static bool dm_table_supports_dax(struct dm_table *t)
> -- 
> 2.14.3
> 
