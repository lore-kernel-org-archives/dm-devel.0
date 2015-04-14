From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/7] fs: use gendisk->disk_name where possible
Date: Tue, 14 Apr 2015 11:13:14 +0200
Message-ID: <20150414091314.GD23327@quack.suse.cz>
References: <1428928300-9132-1-git-send-email-dmonakhov@openvz.org>
 <1428928300-9132-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428928300-9132-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon 13-04-15 16:31:34, Dmitry Monakhov wrote:
> gendisk with part==0 is obviously gendisk->disk_name.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Looks good to me. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/block_dev.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 79b4fa3..f123b02 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1011,12 +1011,9 @@ EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
>  static void flush_disk(struct block_device *bdev, bool kill_dirty)
>  {
>  	if (__invalidate_device(bdev, kill_dirty)) {
> -		char name[BDEVNAME_SIZE] = "";
> -
> -		if (bdev->bd_disk)
> -			disk_name(bdev->bd_disk, 0, name);
>  		printk(KERN_WARNING "VFS: busy inodes on changed media or "
> -		       "resized disk %s\n", name);
> +		       "resized disk %s\n",
> +		       bdev->bd_disk ? bdev->bd_disk->disk_name : "");
>  	}
>  
>  	if (!bdev->bd_disk)
> @@ -1040,12 +1037,9 @@ void check_disk_size_change(struct gendisk *disk, struct block_device *bdev)
>  	disk_size = (loff_t)get_capacity(disk) << 9;
>  	bdev_size = i_size_read(bdev->bd_inode);
>  	if (disk_size != bdev_size) {
> -		char name[BDEVNAME_SIZE];
> -
> -		disk_name(disk, 0, name);
>  		printk(KERN_INFO
>  		       "%s: detected capacity change from %lld to %lld\n",
> -		       name, bdev_size, disk_size);
> +		       disk->disk_name, bdev_size, disk_size);
>  		i_size_write(bdev->bd_inode, disk_size);
>  		flush_disk(bdev, false);
>  	}
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
