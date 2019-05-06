From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Date: Mon, 6 May 2019 12:50:55 -0400
Message-ID: <CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
References: <20190430223722.20845-1-gpiccoli@canonical.com> <20190430223722.20845-2-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190430223722.20845-2-gpiccoli@canonical.com>
Sender: stable-owner@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>, Jay Vosburgh <jay.vosburgh@canonical.com>, kernel@gpiccoli.net, Ming Lei <ming.lei@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, stable@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Apr 30, 2019 at 6:38 PM Guilherme G. Piccoli
<gpiccoli@canonical.com> wrote:
>
> Commit cd4a4ae4683d ("block: don't use blocking queue entered for
> recursive bio submits") introduced the flag BIO_QUEUE_ENTERED in order
> split bios bypass the blocking queue entering routine and use the live
> non-blocking version. It was a result of an extensive discussion in
> a linux-block thread[0], and the purpose of this change was to prevent
> a hung task waiting on a reference to drop.
>
> Happens that md raid0 split bios all the time, and more important,
> it changes their underlying device to the raid member. After the change
> introduced by this flag's usage, we experience various crashes if a raid0
> member is removed during a large write. This happens because the bio
> reaches the live queue entering function when the queue of the raid0
> member is dying.
>
> A simple reproducer of this behavior is presented below:
> a) Build kernel v5.1-rc7 with CONFIG_BLK_DEV_THROTTLING=y.
>
> b) Create a raid0 md array with 2 NVMe devices as members, and mount it
> with an ext4 filesystem.
>
> c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
> (dd of=/mnt/tmp if=/dev/zero bs=1M count=999 &); sleep 0.3;
> echo 1 > /sys/block/nvme0n1/device/device/remove
> (whereas nvme0n1 is the 2nd array member)
>
> This will trigger the following warning/oops:
>
> ------------[ cut here ]------------
> no blkg associated for bio on block-device: nvme0n1
> WARNING: CPU: 9 PID: 184 at ./include/linux/blk-cgroup.h:785
> generic_make_request_checks+0x4dd/0x690
> [...]
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000155
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> RIP: 0010:blk_throtl_bio+0x45/0x970
> [...]
> Call Trace:
>  generic_make_request_checks+0x1bf/0x690
>  generic_make_request+0x64/0x3f0
>  raid0_make_request+0x184/0x620 [raid0]
>  ? raid0_make_request+0x184/0x620 [raid0]
>  ? blk_queue_split+0x384/0x6d0
>  md_handle_request+0x126/0x1a0
>  md_make_request+0x7b/0x180
>  generic_make_request+0x19e/0x3f0
>  submit_bio+0x73/0x140
> [...]
>
> This patch changes raid0 driver to fallback to the "old" blocking queue
> entering procedure, by clearing the BIO_QUEUE_ENTERED from raid0 bios.
> This prevents the crashes and restores the regular behavior of raid0
> arrays when a member is removed during a large write.
>
> [0] https://marc.info/?l=linux-block&m=152638475806811
>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: stable@vger.kernel.org # v4.18
> Fixes: cd4a4ae4683d ("block: don't use blocking queue entered for recursive bio submits")
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>

IIUC, we need this for all raid types. Is it possible to fix that in md.c so
all types get the fix?

Thanks,
Song

> ---
>  drivers/md/raid0.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index f3fb5bb8c82a..d5bdc79e0835 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -547,6 +547,7 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>                         trace_block_bio_remap(bdev_get_queue(rdev->bdev),
>                                 discard_bio, disk_devt(mddev->gendisk),
>                                 bio->bi_iter.bi_sector);
> +               bio_clear_flag(bio, BIO_QUEUE_ENTERED);
>                 generic_make_request(discard_bio);
>         }
>         bio_endio(bio);
> @@ -602,6 +603,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
>                                 disk_devt(mddev->gendisk), bio_sector);
>         mddev_check_writesame(mddev, bio);
>         mddev_check_write_zeroes(mddev, bio);
> +       bio_clear_flag(bio, BIO_QUEUE_ENTERED);
>         generic_make_request(bio);
>         return true;
>  }
> --
> 2.21.0
>
