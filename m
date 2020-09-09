From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 4/9] md: don't detour through bd_contains for the gendisk
Date: Tue, 8 Sep 2020 17:55:48 -0700
Message-ID: <CAPhsuW62Cd329s-LUR9uQVcFvn4pbOj7H0434P7zwRhbNVScgA@mail.gmail.com>
References: <20200903054104.228829-1-hch@lst.de> <20200903054104.228829-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200903054104.228829-5-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Linux Doc Mailing List <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, linux-mmc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Sep 2, 2020 at 10:43 PM Christoph Hellwig <hch@lst.de> wrote:
>
> bd_disk is set on all block devices, including those for partitions.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <song@kernel.org>

> ---
>  drivers/md/md.c | 2 +-
>  drivers/md/md.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3f33562d10d6f5..5a0fd93769a70e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8444,7 +8444,7 @@ static int is_mddev_idle(struct mddev *mddev, int init)
>         idle = 1;
>         rcu_read_lock();
>         rdev_for_each_rcu(rdev, mddev) {
> -               struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
> +               struct gendisk *disk = rdev->bdev->bd_disk;
>                 curr_events = (int)part_stat_read_accum(&disk->part0, sectors) -
>                               atomic_read(&disk->sync_io);
>                 /* sync IO will cause sync_io to increase before the disk_stats
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index f9e2ccdd22c478..2175a5ac4f7c68 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -551,7 +551,7 @@ extern void mddev_unlock(struct mddev *mddev);
>
>  static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
>  {
> -       atomic_add(nr_sectors, &bdev->bd_contains->bd_disk->sync_io);
> +       atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
>  }
>
>  static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
> --
> 2.28.0
>
