From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/13] block, dax: introduce dax_operations
Date: Fri, 20 Jan 2017 09:28:26 -0800
Message-ID: <CAPcyv4ihKqqR-bzNXeeTZ--F4MbEfqnmCyiQ2s3Ngc0oq488WQ@mail.gmail.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148488422405.37913.13366670089124790849.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <148488422405.37913.13366670089124790849.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Jan 19, 2017 at 7:50 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Prepare for the removal of memcpy_to_pmem() and copy_from_iter_pmem() by
> introducing dax_ops. This allows for driver specific overrides for the
> routines that transfer data to a dax capable block device.
>
> Cc: <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
> Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
> Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/powerpc/sysdev/axonram.c |    6 +++++-
>  drivers/block/brd.c           |    6 +++++-
>  drivers/md/dm.c               |    6 +++++-
>  drivers/nvdimm/pmem.c         |    6 +++++-
>  drivers/s390/block/dcssblk.c  |    6 +++++-
>  fs/block_dev.c                |    6 ++++--
>  include/linux/blkdev.h        |    8 ++++++--
>  7 files changed, 35 insertions(+), 9 deletions(-)
>
[..]
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3086da5664f3..87920a379d20 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2725,13 +2725,17 @@ static const struct pr_ops dm_pr_ops = {
>         .pr_clear       = dm_pr_clear,
>  };
>
> +static const struct dax_operations dm_dax_ops = {
> +       .direct_access = dm_blk_direct_access,
> +};
> +
>  static const struct block_device_operations dm_blk_dops = {
>         .open = dm_blk_open,
>         .release = dm_blk_close,
>         .ioctl = dm_blk_ioctl,
> -       .direct_access = dm_blk_direct_access,
>         .getgeo = dm_blk_getgeo,
>         .pr_ops = &dm_pr_ops,
> +       .dax_ops = &dm_dax_ops,
>         .owner = THIS_MODULE
>  };

I just realized we need to do a bit more plumbing to support the
device-mapper case. We need to implement all the dax_operations at the
dm_dax_ops level and pass in the physical sector so that device-mapper
can look up the backing block-device to call the real dax_operation if
it is implemented.
