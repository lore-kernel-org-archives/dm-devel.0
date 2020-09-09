From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 3/9] md: compare bd_disk instead of bd_contains
Date: Tue, 8 Sep 2020 17:55:29 -0700
Message-ID: <CAPhsuW7ZtGruPhBWZpjCDoyq1DwoA3t_p3UXbSPrHGMnHh7enw@mail.gmail.com>
References: <20200903054104.228829-1-hch@lst.de> <20200903054104.228829-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200903054104.228829-4-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Linux Doc Mailing List <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, linux-mmc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Sep 2, 2020 at 10:43 PM Christoph Hellwig <hch@lst.de> wrote:
>
> To check for partitions of the same disk bd_contains works as well, but
> bd_disk is way more obvious.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <song@kernel.org>

> ---
>  drivers/md/md.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9562ef598ae1f4..3f33562d10d6f5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2322,8 +2322,7 @@ static int match_mddev_units(struct mddev *mddev1, struct mddev *mddev2)
>                             test_bit(Journal, &rdev2->flags) ||
>                             rdev2->raid_disk == -1)
>                                 continue;
> -                       if (rdev->bdev->bd_contains ==
> -                           rdev2->bdev->bd_contains) {
> +                       if (rdev->bdev->bd_disk == rdev2->bdev->bd_disk) {
>                                 rcu_read_unlock();
>                                 return 1;
>                         }
> @@ -5944,8 +5943,8 @@ int md_run(struct mddev *mddev)
>                 rdev_for_each(rdev, mddev)
>                         rdev_for_each(rdev2, mddev) {
>                                 if (rdev < rdev2 &&
> -                                   rdev->bdev->bd_contains ==
> -                                   rdev2->bdev->bd_contains) {
> +                                   rdev->bdev->bd_disk ==
> +                                   rdev2->bdev->bd_disk) {
>                                         pr_warn("%s: WARNING: %s appears to be on the same physical disk as %s.\n",
>                                                 mdname(mddev),
>                                                 bdevname(rdev->bdev,b),
> --
> 2.28.0
>
