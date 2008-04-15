From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: bdev size not updated correctly after underlying device is
 resized
Date: Tue, 15 Apr 2008 16:03:14 -0700
Message-ID: <20080415160314.11e9b7e1.akpm@linux-foundation.org>
References: <1207783782.31821.80.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754548AbYDOXEp@vger.kernel.org>
In-Reply-To: <1207783782.31821.80.camel@bluto.andrew>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, dm-devel@redhat.com, axboe@kernel.dk, andmike@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Wed, 09 Apr 2008 17:29:42 -0600
Andrew Patterson <andrew.patterson@hp.com> wrote:

> I ran into this problem while trying to resize a mounted file-system
> after growing/shrinking the size of the underlying block device (in this
> case, a fibre-channel LUN). The kernel recognizes the device size change
> when revalidate_disk() is called, but the bdev->bd_inode->i_size will
> not be updated for any new openers if there are already openers of the
> device.  In my case I was using LVM thusly:
> 
>      1. Create a volume group with a physical volume on something that
>         can be resized (usually some sort of SCSI RAID device).
>      2. Create a logical volume on that VG.  This holds the underlying
>         PV block device open as long at the LV is activated
>      3. Run blockdev --getsize <block dev>
>      4. Resize the underlying block device.
>      5. Get the OS to notice the change.  For fibre-channel LUN's you
>         can use /sys/class/scsi_device/<device>/device/rescan.
>      6. Size is correctly changed in /dev/block/<device>/size
>      7. Run blockdev --getsize again (no change in size reported)
>      8. Inactivate the LV (there are now no longer any openers on the
>         block device)
>      9. Run blockdev --getsize again.  Size is now correct as there are
>         no openers on the device when blockdev is run.
> 
> This problem has been reported before at:
> 
>   http://lkml.org/lkml/2007/7/3/83
> 
> The following patch is a suggestion on how to fix this problem.  It is
> not a complete solution as it is probably a bad thing to change other
> openers device size without at least protecting the change with a lock.
> And user-apps and other sub-systems might not like the reported device
> size being changed underneath them. It looks like the following
> sub-systems access this value:
> 
> ndb
> dm
> md
> affs
> hfs
> jfs
> reiserfs
> udf
> 
> 
> Subject: [PATCH] Reset bdev size regardless of other openers.
> 
> A block device may be resized while online.  If the revalidate_disk
> routine is called after the resize, the gendisk->capacity value is
> updated for the device.  However, the bdev->bd_inode->i_size is not
> updated when the block device is opened if there are any other openers
> on the device.  This means that apps like LVM are unlikely to see the
> size change as they tend to keep their block devices open.  There is a
> discussion of this problem at:
> 
>   http://lkml.org/lkml/2007/7/3/83
> 
> This patch changes block_dev.c:do_open() to call bd_set_size()
> regardless if there are other openers on the device.  It should not be
> applied in its existing state as changing i_size should be protected by
> a lock. Also, there needs to be some analysis on the effects of changing
> the device size underneath an app.
> 
> Andrew Patterson
> 
> Subject: [PATCH] Reset bdev size regardless of other openers.
> 
> A block device may be resized while online.  If the revalidate_disk
> routine is called after the resize, the gendisk->capacity value is
> updated for the device.  However, the bdev->bd_inode->i_size is not
> updated when the block device is opened if there are any other openers
> on the device.  This means that apps like LVM are unlikely to see the
> size change as they tend to keep their block devices open.  There is a
> discussion of this problem at:
> 
>   http://lkml.org/lkml/2007/7/3/83
> 
> This patch changes block_dev.c:do_open() to call bd_set_size()
> regardless if there are other openers on the device.  It should not be
> applied in its existing state as changing i_size should be protected by
> a lock. Also, there needs to be some analysis on the effects of changing
> the device size underneath an app.

hm, tricky.

I don't know what problems a change like this might cause - probably few,
given the rarity and slowness of block device resizing.

Presumably increasing the device size will cause les problems than
decreasing it would.  Do we even support device shrinking?

> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 7d822fa..d13a4e5 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -992,6 +992,9 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
>  				ret = bdev->bd_disk->fops->open(bdev->bd_inode, file);
>  				if (ret)
>  					goto out;
> +				/* device may have been resized with revalidate_disk */
> +				if (!part)
> +					bd_set_size(bdev, (loff_t)get_capacity(disk)<<9);
>  			}
>  			if (bdev->bd_invalidated)
>  				rescan_partitions(bdev->bd_disk, bdev);

I'd have thought that an appropriate way to fix all this would be to
perform the i_size update between freeze_bdev() and thaw_bdev(), when the
fs is quiesced.  But it's not really in my comfort zone.
