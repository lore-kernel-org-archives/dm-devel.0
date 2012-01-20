From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: Invalidate the cache for a parent
	block-device
Date: Thu, 19 Jan 2012 20:54:09 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1201192036500.10677@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Niels De Vos <ndevos@redhat.com>
Cc: bmr@redhat.com, linux-kernel@vger.kerne.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This definitely doesn't belong to blkdev_issue_flush.

blkdev_issue_flush is called by filesystems each time they want to 
synchronize hardware disk cache (for example, when committing a journal).

The patch may cause serious performance regressions (each time a 
filesystem commits journal, the patch causes it to walk all buffers in the 
whole-disk device).

You should put this code into fsync_bdev (so that it is called only on 
fsync or BLKFLSBUF) and not to blkdev_issue_flush.

Mikulas

> Executing a BLKFLSBUF-ioctl on a partition flushes the caches for that
> partition but reading data through the parent device will still return
> the old cached data.
> 
> The cache for the block-device is not synced if the block-device is kept
> open (due to a mounted partition, for example). Only when all users for
> the disk have exited, the cache for the disk is made consistent again.
> 
> Calling invalidate_bdev() on the parent block-device in case
> blkdev_issue_flush() was called for a partition fixes this.
> 
> The problem can be worked around by forcing the caches to be flushed
> with either
>         # blockdev --flushbufs ${dev_disk}
> or
>         # echo 3 > /proc/sys/vm/drop_caches
> 
> CC: Bryn M. Reeves <bmr <at> redhat.com>
> Signed-off-by: Niels de Vos <ndevos <at> redhat.com>
> ---
>  block/blk-flush.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 720ad60..e876f8e 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -448,6 +448,9 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_
> 
>         if (!bio_flagged(bio, BIO_UPTODATE))
>                 ret = -EIO;
> +       else if (bdev != bdev->bd_contains)
> +               /* invalidate parent block_device */
> +               invalidate_bdev(bdev->bd_contains);
> 
>         bio_put(bio);
>         return ret;
> --
> 1.7.6.5
> 
