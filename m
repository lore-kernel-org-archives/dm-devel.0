From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] HP SW support take 3
Date: Mon, 13 Jun 2005 15:10:12 +0200
Message-ID: <20050613131012.GE28625@averon.dyndns.org>
References: <1118614380.5318.11.camel@mina>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1118614380.5318.11.camel@mina>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I confirm a robust behaviour now with take 3.
Here is a take 4 that move to an appropriate "best effort mode", ie always return success.

The point is, whenever DM start submitting io the an asleep controler, precede with a START command. If it fails ... too bad, the consecutive io will fail and DM will try another PG. Had to do that because take 3 interprets an error where the controler switch have correctly happened.

I guess we could suppress the sense buffer allocation if this "best effort mode" is agreed on.

I also added path->dev->name to DMINFO() calls to make for a more informative output.
And packaged as an out-of-tree module, though it needs the blk patch you sent applied to the tree. (left bellow)

http://christophe.varoqui.free.fr/multipath-tools/dm-hp-sw.tar.bz2

Regards,
cvaroqui

On Sun, Jun 12, 2005 at 03:13:00PM -0700, Mike Christie wrote:
> Fix locking bug. Will have to send the block layer stuff to
> Jens Axboe when we get hp-sw support finished. For now I included
> everything in one patch (reminder - don't use things like rd,
> dm, md, aoe, or anything without a real queue under dm-mpath
> if you are using a hw_hanlder that injects a failover command).
> 
> This was only tested with scsi_debug.
> 
> 
> diff -Naurp linux-2.6.12-rc5.orig/drivers/block/ll_rw_blk.c linux-2.6.12-rc5/drivers/block/ll_rw_blk.c
> --- linux-2.6.12-rc5.orig/drivers/block/ll_rw_blk.c	2005-06-08 19:30:08.000000000 -0700
> +++ linux-2.6.12-rc5/drivers/block/ll_rw_blk.c	2005-06-12 14:40:29.000000000 -0700
> @@ -2369,7 +2369,7 @@ void disk_round_stats(struct gendisk *di
>  /*
>   * queue lock must be held
>   */
> -static void __blk_put_request(request_queue_t *q, struct request *req)
> +void __blk_put_request(request_queue_t *q, struct request *req)
>  {
>  	struct request_list *rl = req->rl;
>  
> @@ -2398,6 +2398,8 @@ static void __blk_put_request(request_qu
>  	}
>  }
>  
> +EXPORT_SYMBOL(__blk_put_request);
> +
>  void blk_put_request(struct request *req)
>  {
>  	/*
> diff -Naurp linux-2.6.12-rc5.orig/include/linux/blkdev.h linux-2.6.12-rc5/include/linux/blkdev.h
> --- linux-2.6.12-rc5.orig/include/linux/blkdev.h	2005-06-08 19:28:52.000000000 -0700
> +++ linux-2.6.12-rc5/include/linux/blkdev.h	2005-06-12 14:40:00.000000000 -0700
> @@ -540,6 +540,7 @@ extern void blk_unregister_queue(struct 
>  extern void register_disk(struct gendisk *dev);
>  extern void generic_make_request(struct bio *bio);
>  extern void blk_put_request(struct request *);
> +extern void __blk_put_request(request_queue_t *, struct request *);
>  extern void blk_end_sync_rq(struct request *rq);
>  extern void blk_attempt_remerge(request_queue_t *, struct request *);
>  extern void __blk_attempt_remerge(request_queue_t *, struct request *);
> 
