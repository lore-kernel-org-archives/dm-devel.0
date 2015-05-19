From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v2 RESEND] block: discard bdi_unregister() in favour of
 bdi_destroy()
Date: Tue, 19 May 2015 18:40:17 +0900
Message-ID: <20150519094017.GA546@swordfish>
References: <20150519155837.456ad30e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150519155837.456ad30e@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: NeilBrown <neilb@suse.de>, device-mapper development <dm-devel@redhat.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Greg KH <gregkh@linuxfoundation.org>
List-Id: dm-devel.ids

On (05/19/15 15:58), NeilBrown wrote:
> 
> bdi_unregister() now contains very little functionality.
> 
> It contains a "WARN_ON" if bdi->dev is NULL.  This warning is of no
> real consequence as bdi->dev isn't needed by anything else in the function,
> and it triggers if
>    blk_cleanup_queue() -> bdi_destroy()
> is called before bdi_unregister, which happens since
>   Commit: 6cd18e711dd8 ("block: destroy bdi before blockdev is unregistered.")
> 
> So this isn't wanted.
> 
> It also calls bdi_set_min_ratio().  This needs to be called after
> writes through the bdi have all been flushed, and before the bdi is destroyed.
> Calling it early is better than calling it late as it frees up a global
> resource.
> 
> Calling it immediately after bdi_wb_shutdown() in bdi_destroy()
> perfectly fits these requirements.
> 
> So bdi_unregister() can be discarded with the important content moved to
> bdi_destroy(), as can the
>   writeback_bdi_unregister
> event which is already not used.
> 

just to boost/support this patch: fixes del_gendisk() warning (loop, zram, etc.)

[ 6298.249018] WARNING: CPU: 2 PID: 29935 at mm/backing-dev.c:372 bdi_unregister+0x2d/0x3f()
[ 6298.249065] Call Trace:
[ 6298.249070]  [<ffffffff814fe3ca>] dump_stack+0x4c/0x6e
[ 6298.249073]  [<ffffffff810768e7>] ? up+0x39/0x3e
[ 6298.249076]  [<ffffffff8103b792>] warn_slowpath_common+0x9b/0xb5
[ 6298.249077]  [<ffffffff811080d8>] ? bdi_unregister+0x2d/0x3f
[ 6298.249079]  [<ffffffff8103b84f>] warn_slowpath_null+0x1a/0x1c
[ 6298.249081]  [<ffffffff811080d8>] bdi_unregister+0x2d/0x3f
[ 6298.249084]  [<ffffffff8122c7ae>] del_gendisk+0xf7/0x1c2

	-ss

> Reported-by: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@vger.kernel.org (v4.0)
> Fixes: c4db59d31e39 ("fs: don't reassign dirty inodes to default_backing_dev_info")
> Fixes: 6cd18e711dd8 ("block: destroy bdi before blockdev is unregistered.")
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Tested-by: Nicholas Moulin <nicholas.w.moulin@linux.intel.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> ---
> 
> hi Jens,
>  It seems you might have missed this, possibly buried in a long thread.
> It would be good you it could get to Linux and thence to -stable promptly.
> 
> Thanks,
> NeilBrown
> 
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index e351fc521053..1d4435478e8a 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -657,7 +657,6 @@ void del_gendisk(struct gendisk *disk)
>  	disk->flags &= ~GENHD_FL_UP;
>  
>  	sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
> -	bdi_unregister(&disk->queue->backing_dev_info);
>  	blk_unregister_queue(disk);
>  	blk_unregister_region(disk_devt(disk), disk->minors);
>  
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index aff923ae8c4b..d87d8eced064 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -116,7 +116,6 @@ __printf(3, 4)
>  int bdi_register(struct backing_dev_info *bdi, struct device *parent,
>  		const char *fmt, ...);
>  int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
> -void bdi_unregister(struct backing_dev_info *bdi);
>  int __must_check bdi_setup_and_register(struct backing_dev_info *, char *);
>  void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
>  			enum wb_reason reason);
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index 880dd7437172..c178d13d6f4c 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -250,7 +250,6 @@ DEFINE_EVENT(writeback_class, name, \
>  DEFINE_WRITEBACK_EVENT(writeback_nowork);
>  DEFINE_WRITEBACK_EVENT(writeback_wake_background);
>  DEFINE_WRITEBACK_EVENT(writeback_bdi_register);
> -DEFINE_WRITEBACK_EVENT(writeback_bdi_unregister);
>  
>  DECLARE_EVENT_CLASS(wbc_class,
>  	TP_PROTO(struct writeback_control *wbc, struct backing_dev_info *bdi),
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 6dc4580df2af..000e7b3b9896 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -359,23 +359,6 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
>  	flush_delayed_work(&bdi->wb.dwork);
>  }
>  
> -/*
> - * Called when the device behind @bdi has been removed or ejected.
> - *
> - * We can't really do much here except for reducing the dirty ratio at
> - * the moment.  In the future we should be able to set a flag so that
> - * the filesystem can handle errors at mark_inode_dirty time instead
> - * of only at writeback time.
> - */
> -void bdi_unregister(struct backing_dev_info *bdi)
> -{
> -	if (WARN_ON_ONCE(!bdi->dev))
> -		return;
> -
> -	bdi_set_min_ratio(bdi, 0);
> -}
> -EXPORT_SYMBOL(bdi_unregister);
> -
>  static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
>  {
>  	memset(wb, 0, sizeof(*wb));
> @@ -443,6 +426,7 @@ void bdi_destroy(struct backing_dev_info *bdi)
>  	int i;
>  
>  	bdi_wb_shutdown(bdi);
> +	bdi_set_min_ratio(bdi, 0);
>  
>  	WARN_ON(!list_empty(&bdi->work_list));
>  	WARN_ON(delayed_work_pending(&bdi->wb.dwork));
