From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [dm-devel] [for-4.16 PATCH v2 2/3] block: cope with gendisk's
 'queue' being added later
Date: Wed, 10 Jan 2018 11:46:32 +0800
Message-ID: <CACVXFVPWEsfv+xEWiAL5nT1p9FazgMcH1U7h7zCA_CSQqrEMiw@mail.gmail.com>
References: <20180110024104.34885-1-snitzer@redhat.com> <20180110024104.34885-3-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180110024104.34885-3-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Hi Mike,

On Wed, Jan 10, 2018 at 10:41 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> Since I can remember DM has forced the block layer to allow the
> allocation and initialization of the request_queue to be distinct
> operations.  Reason for this was block/genhd.c:add_disk() has required
> that the request_queue (and associated bdi) be tied to the gendisk
> before add_disk() is called -- because add_disk() also deals with
> exposing the request_queue via blk_register_queue().
>
> DM's dynamic creation of arbitrary device types (and associated
> request_queue types) requires the DM device's gendisk be available so
> that DM table loads can establish a master/slave relationship with
> subordinate devices that are referenced by loaded DM tables -- using
> bd_link_disk_holder().  But until these DM tables, and their associated
> subordinate devices, are known DM cannot know what type of request_queue
> it needs -- nor what its queue_limits should be.

Maybe DM is the only kind of this case, but it is easy to cause
trouble by adding
disk before setting up queue.

In theory, once disk is added, it becomes visible for external world, and
IO starts to come and sysfs operations come too, then block has to deal
with these cases.

Another related issue is that blk-mq debugfs can't work yet for dm-mpath.

So I am just wondering if it is possible to follow the usual way to add disk
after setting up queue for DM? If it is possible, it may avoid lots of trouble
for us.

Thanks,
Ming

>
> This chicken and egg scenario has created all manner of problems for DM
> and, at times, the block layer.
>
> Summary of changes:
>
> - Adjust device_add_disk() so that that it can cope with the gendisk _not_
>   having its 'queue' established yet.
>
> - Move "bdi" symlink creation from register_disk() to the end of
>   blk_register_queue() -- it is more logical in that the bdi is part of
>   the request_queue.
>
> - Move extra request_queue reference count (on behalf of gendisk) from
>   device_add_disk() to end of blk_register_queue().
>
> - Make device_add_disk()'s calls to bdi_register_owner() and
>   blk_register_queue() conditional on disk->queue not being NULL.
>
> - Export blk_register_queue()
>
> - Move "bdi" symlink removal and bdi_unregister() from del_gendisk() to
>   blk_unregister_queue().  Suggested by Bart.
>
> - Remove del_gendisk()'s WARN_ON() if disk->queue is NULL
>
> These changes allow DM to use device_add_disk() to anchor its gendisk as
> the "master" for master/slave relationships DM must establish with
> subordinate devices referenced in DM tables that get loaded.  Once all
> "slave" devices for a DM device are known a request_queue can be
> properly initialized and then advertised via sysfs -- important
> improvement being that no request_queue resource initialization is
> missed.
>
> These changes have been tested to work without any IO races because the
> request_queue and associated bdi don't even exist at the time that the
> gendisk's "struct device"s are established by device_add_disk().  I've
> been mindful of historic bugs, and haven't experienced them with DM,
> e.g.: https://bugzilla.kernel.org/show_bug.cgi?id=16312 (fixed by commit
> 01ea5063 "block: Fix race during disk initialization")
>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-sysfs.c | 23 ++++++++++++++++++++++-
>  block/genhd.c     | 39 +++++++++------------------------------
>  2 files changed, 31 insertions(+), 31 deletions(-)
>
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 870484eaed1f..d888ecb95a2a 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -919,8 +919,21 @@ int blk_register_queue(struct gendisk *disk)
>         ret = 0;
>  unlock:
>         mutex_unlock(&q->sysfs_lock);
> +
> +       /*
> +        * Take an extra ref on queue which will be put on disk_release()
> +        * so that it sticks around as long as @disk is there.
> +        */
> +       WARN_ON_ONCE(!blk_get_queue(q));
> +
> +       if (!(disk->flags & GENHD_FL_HIDDEN))
> +               WARN_ON(sysfs_create_link(&dev->kobj,
> +                                         &q->backing_dev_info->dev->kobj,
> +                                         "bdi"));
> +
>         return ret;
>  }
> +EXPORT_SYMBOL_GPL(blk_register_queue);
>
>  void blk_unregister_queue(struct gendisk *disk)
>  {
> @@ -929,13 +942,21 @@ void blk_unregister_queue(struct gendisk *disk)
>         if (WARN_ON(!q))
>                 return;
>
> +       if (!(disk->flags & GENHD_FL_HIDDEN)) {
> +               sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
> +               /*
> +                * Unregister bdi before releasing device numbers (as they can
> +                * get reused and we'd get clashes in sysfs).
> +                */
> +               bdi_unregister(q->backing_dev_info);
> +       }
> +
>         mutex_lock(&q->sysfs_lock);
>         queue_flag_clear_unlocked(QUEUE_FLAG_REGISTERED, q);
>         mutex_unlock(&q->sysfs_lock);
>
>         wbt_exit(q);
>
> -
>         if (q->mq_ops)
>                 blk_mq_unregister_dev(disk_to_dev(disk), q);
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 00620e01e043..4a71aea1a1ef 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -621,11 +621,6 @@ static void register_disk(struct device *parent, struct gendisk *disk)
>         while ((part = disk_part_iter_next(&piter)))
>                 kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
>         disk_part_iter_exit(&piter);
> -
> -       err = sysfs_create_link(&ddev->kobj,
> -                               &disk->queue->backing_dev_info->dev->kobj,
> -                               "bdi");
> -       WARN_ON(err);
>  }
>
>  /**
> @@ -671,24 +666,19 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
>                 disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
>                 disk->flags |= GENHD_FL_NO_PART_SCAN;
>         } else {
> -               int ret;
> -
> -               /* Register BDI before referencing it from bdev */
>                 disk_to_dev(disk)->devt = devt;
> -               ret = bdi_register_owner(disk->queue->backing_dev_info,
> -                                               disk_to_dev(disk));
> -               WARN_ON(ret);
> +               /* Register BDI before referencing it from bdev */
> +               if (disk->queue) {
> +                       retval = bdi_register_owner(disk->queue->backing_dev_info,
> +                                                   disk_to_dev(disk));
> +                       WARN_ON(retval);
> +               }
>                 blk_register_region(disk_devt(disk), disk->minors, NULL,
>                                     exact_match, exact_lock, disk);
>         }
>         register_disk(parent, disk);
> -       blk_register_queue(disk);
> -
> -       /*
> -        * Take an extra ref on queue which will be put on disk_release()
> -        * so that it sticks around as long as @disk is there.
> -        */
> -       WARN_ON_ONCE(!blk_get_queue(disk->queue));
> +       if (disk->queue)
> +               blk_register_queue(disk);
>
>         disk_add_events(disk);
>         blk_integrity_add(disk);
> @@ -718,19 +708,8 @@ void del_gendisk(struct gendisk *disk)
>         set_capacity(disk, 0);
>         disk->flags &= ~GENHD_FL_UP;
>
> -       if (!(disk->flags & GENHD_FL_HIDDEN))
> -               sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
> -       if (disk->queue) {
> -               /*
> -                * Unregister bdi before releasing device numbers (as they can
> -                * get reused and we'd get clashes in sysfs).
> -                */
> -               if (!(disk->flags & GENHD_FL_HIDDEN))
> -                       bdi_unregister(disk->queue->backing_dev_info);
> +       if (disk->queue)
>                 blk_unregister_queue(disk);
> -       } else {
> -               WARN_ON(1);
> -       }
>
>         if (!(disk->flags & GENHD_FL_HIDDEN))
>                 blk_unregister_region(disk_devt(disk), disk->minors);
> --
> 2.15.0
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel



-- 
Ming Lei
