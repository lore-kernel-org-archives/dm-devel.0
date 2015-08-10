From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] fs/block_dev.c: Remove WARN_ON() when inode writeback
 fails
Date: Mon, 10 Aug 2015 15:37:25 -0400
Message-ID: <20150810193725.GC19173@redhat.com>
References: <20150622184118.GA11277@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150622184118.GA11277@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids


Hi Jens,

Do you have concerns with this patch? If not, can you please include it.

Thanks
Vivek

On Mon, Jun 22, 2015 at 02:41:18PM -0400, Vivek Goyal wrote:
> If a block device is hot removed and later last reference to devices
> is put, we try to writeback the dirty inode. But device is gone and
> that writeback fails.
> 
> Currently we do a WARN_ON() which does not seem to be the right thing.
> Convert it to a ratelimited kernel warning.
> 
> Reported-by: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/block_dev.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> Index: rhvgoyal-linux/fs/block_dev.c
> ===================================================================
> --- rhvgoyal-linux.orig/fs/block_dev.c	2015-06-18 15:54:52.339383237 -0400
> +++ rhvgoyal-linux/fs/block_dev.c	2015-06-22 14:32:29.112594493 -0400
> @@ -48,12 +48,20 @@ inline struct block_device *I_BDEV(struc
>  }
>  EXPORT_SYMBOL(I_BDEV);
>  
> -static void bdev_write_inode(struct inode *inode)
> +static void bdev_write_inode(struct block_device *bdev)
>  {
> +	struct inode *inode = bdev->bd_inode;
> +	int ret;
> +
>  	spin_lock(&inode->i_lock);
>  	while (inode->i_state & I_DIRTY) {
>  		spin_unlock(&inode->i_lock);
> -		WARN_ON_ONCE(write_inode_now(inode, true));
> +		ret = write_inode_now(inode, true);
> +		if (ret) {
> +			char name[BDEVNAME_SIZE] = "";
> +			pr_warn_ratelimited("VFS: Dirty inode writeback failed for block device %s (err= %d).\n",
> +					    bdevname(bdev, name), ret);
> +		}
>  		spin_lock(&inode->i_lock);
>  	}
>  	spin_unlock(&inode->i_lock);
> @@ -1489,7 +1497,7 @@ static void __blkdev_put(struct block_de
>  		 * ->release can cause the queue to disappear, so flush all
>  		 * dirty data before.
>  		 */
> -		bdev_write_inode(bdev->bd_inode);
> +		bdev_write_inode(bdev);
>  	}
>  	if (bdev->bd_contains == bdev) {
>  		if (disk->fops->release)
