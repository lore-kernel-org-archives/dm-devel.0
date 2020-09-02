From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 4/9] block: add a new revalidate_disk_size helper
Date: Tue, 1 Sep 2020 23:06:52 -0700
Message-ID: <CAPhsuW5-nfKQK_178R-Y+ps6KLNMrwvWe0Rh5=M1-xvcKHYTgg@mail.gmail.com>
References: <20200901155748.2884-1-hch@lst.de> <20200901155748.2884-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200901155748.2884-5-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Dan Williams <dan.j.williams@intel.com>, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, open list <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, nbd@other.debian.org, ceph-devel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-raid <linux-raid@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Sep 1, 2020 at 9:00 AM Christoph Hellwig <hch@lst.de> wrote:
>
[...]

>  drivers/md/md-cluster.c       |  6 ++---
>  drivers/md/md-linear.c        |  2 +-
>  drivers/md/md.c               | 10 ++++-----

For md bits:
Acked-by: Song Liu <song@kernel.org>

[...]
>
> +/**
> + * revalidate_disk_size - checks for disk size change and adjusts bdev size.
> + * @disk: struct gendisk to check
> + * @verbose: if %true log a message about a size change if there is any
> + *
> + * This routine checks to see if the bdev size does not match the disk size
> + * and adjusts it if it differs. When shrinking the bdev size, its all caches
> + * are freed.
> + */
> +void revalidate_disk_size(struct gendisk *disk, bool verbose)
> +{
> +       struct block_device *bdev;
> +
> +       /*
> +        * Hidden disks don't have associated bdev so there's no point in
> +        * revalidating them.
> +        */
> +       if (disk->flags & GENHD_FL_HIDDEN)
> +               return;
> +
> +       bdev = bdget_disk(disk, 0);
> +       if (bdev) {
> +               check_disk_size_change(disk, bdev, verbose);
> +               bdput(bdev);
> +       }
> +}
> +EXPORT_SYMBOL(revalidate_disk_size);

Shall we use EXPORT_SYMBOL_GPL() here?

[...]
