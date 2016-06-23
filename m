From: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH v2 1/3] block: add QUEUE_FLAG_DAX for devices to advertise
 their DAX support
Date: Thu, 23 Jun 2016 19:31:45 +0300
Message-ID: <CACTTzNYAxtY-d8+8Vo=Y2WpuXVaSkJk9PC7DcHXKJuU=gqvXFw@mail.gmail.com>
References: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
 <1466639694-25394-2-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1466639694-25394-2-git-send-email-toshi.kani-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Thu, Jun 23, 2016 at 2:54 AM, Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
>
> Currently, presence of direct_access() in block_device_operations
> indicates support of DAX on its block device.  Because
> block_device_operations is instantiated with 'const', this DAX
> capablity may not be enabled conditinally.
>
> In preparation for supporting DAX to device-mapper devices, add
> QUEUE_FLAG_DAX to request_queue flags to advertise their DAX
> support.  This will allow to set the DAX capability based on how
> mapped device is composed.


Hi Toshi,
This patch is very helpful!
I think QUEUE_FLAG_DAX can also help with identifying dax devices in userspace.
Perhaps you'd be willing to squash the patch below with this one or
add it to your submission?

Thanks,
Yigal


[PATCH] block: expose QUEUE_FLAG_DAX in sysfs

There's currently no way to identify DAX enabled devices in userspace.

Signed-off-by: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
---
 block/blk-sysfs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 9920596..d55126d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -379,6 +379,15 @@ static ssize_t queue_wc_store(struct
request_queue *q, const char *page,
        return count;
 }

+static ssize_t queue_dax_show(struct request_queue *q, char *page)
+{
+       int bit;
+
+       bit = test_bit(QUEUE_FLAG_DAX, &q->queue_flags);
+
+       return queue_var_show(bit, page);
+}
+
 static struct queue_sysfs_entry queue_requests_entry = {
        .attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
        .show = queue_requests_show,
@@ -516,6 +525,11 @@ static struct queue_sysfs_entry queue_wc_entry = {
        .store = queue_wc_store,
 };

+static struct queue_sysfs_entry queue_dax_entry = {
+       .attr = {.name = "dax", .mode = S_IRUGO },
+       .show = queue_dax_show,
+};
+
 static struct attribute *default_attrs[] = {
        &queue_requests_entry.attr,
        &queue_ra_entry.attr,
@@ -542,6 +556,7 @@ static struct attribute *default_attrs[] = {
        &queue_random_entry.attr,
        &queue_poll_entry.attr,
        &queue_wc_entry.attr,
+       &queue_dax_entry.attr,
        NULL,
 };

--
1.9.3

>
>
> Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> Cc: Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> Cc: <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> ---
>  drivers/block/brd.c          |    4 +++-
>  drivers/nvdimm/pmem.c        |    1 +
>  drivers/s390/block/dcssblk.c |    1 +
>  fs/block_dev.c               |    5 +++--
>  include/linux/blkdev.h       |    2 ++
>  5 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index f5b0d6f..dd96a93 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -509,7 +509,9 @@ static struct brd_device *brd_alloc(int i)
>         blk_queue_max_discard_sectors(brd->brd_queue, UINT_MAX);
>         brd->brd_queue->limits.discard_zeroes_data = 1;
>         queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, brd->brd_queue);
> -
> +#ifdef CONFIG_BLK_DEV_RAM_DAX
> +       queue_flag_set_unlocked(QUEUE_FLAG_DAX, brd->brd_queue);
> +#endif
>         disk = brd->brd_disk = alloc_disk(max_part);
>         if (!disk)
>                 goto out_free_queue;
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 608fc44..53b701b 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -283,6 +283,7 @@ static int pmem_attach_disk(struct device *dev,
>         blk_queue_max_hw_sectors(q, UINT_MAX);
>         blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
>         queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
> +       queue_flag_set_unlocked(QUEUE_FLAG_DAX, q);
>         q->queuedata = pmem;
>
>         disk = alloc_disk_node(0, nid);
> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index bed53c4..093e9e1 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -618,6 +618,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
>         dev_info->gd->driverfs_dev = &dev_info->dev;
>         blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
>         blk_queue_logical_block_size(dev_info->dcssblk_queue, 4096);
> +       queue_flag_set_unlocked(QUEUE_FLAG_DAX, dev_info->dcssblk_queue);
>
>         seg_byte_size = (dev_info->end - dev_info->start + 1);
>         set_capacity(dev_info->gd, seg_byte_size >> 9); // size in sectors
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 71ccab1..d012be4 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -493,7 +493,7 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
>
>         if (size < 0)
>                 return size;
> -       if (!ops->direct_access)
> +       if (!blk_queue_dax(bdev_get_queue(bdev)) || !ops->direct_access)
>                 return -EOPNOTSUPP;
>         if ((sector + DIV_ROUND_UP(size, 512)) >
>                                         part_nr_sects_read(bdev->bd_part))
> @@ -1287,7 +1287,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
>                 bdev->bd_disk = disk;
>                 bdev->bd_queue = disk->queue;
>                 bdev->bd_contains = bdev;
> -               if (IS_ENABLED(CONFIG_BLK_DEV_DAX) && disk->fops->direct_access)
> +               if (IS_ENABLED(CONFIG_BLK_DEV_DAX) &&
> +                   blk_queue_dax(disk->queue))
>                         bdev->bd_inode->i_flags = S_DAX;
>                 else
>                         bdev->bd_inode->i_flags = 0;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 9746d22..1493ab3 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -505,6 +505,7 @@ struct request_queue {
>  #define QUEUE_FLAG_WC         23       /* Write back caching */
>  #define QUEUE_FLAG_FUA        24       /* device supports FUA writes */
>  #define QUEUE_FLAG_FLUSH_NQ    25      /* flush not queueuable */
> +#define QUEUE_FLAG_DAX         26      /* device supports DAX */
>
>  #define QUEUE_FLAG_DEFAULT     ((1 << QUEUE_FLAG_IO_STAT) |            \
>                                  (1 << QUEUE_FLAG_STACKABLE)    |       \
> @@ -594,6 +595,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
>  #define blk_queue_discard(q)   test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
>  #define blk_queue_secdiscard(q)        (blk_queue_discard(q) && \
>         test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
> +#define blk_queue_dax(q)       test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
>
>  #define blk_noretry_request(rq) \
>         ((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
