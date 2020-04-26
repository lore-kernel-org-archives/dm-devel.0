From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/3] bcache: remove a duplicate ->make_request_fn
 assignment
Date: Sun, 26 Apr 2020 17:35:41 +0800
Message-ID: <bbeb7895-78c3-da7b-78e8-e3a376146b2e@suse.de>
References: <20200425075336.721021-1-hch@lst.de>
 <20200425075336.721021-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200425075336.721021-2-hch@lst.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 2020/4/25 15:53, Christoph Hellwig wrote:
> The make_request_fn pointer should only be assigned by blk_alloc_queue.
> Fix a left over manual initialization.
> 
> Fixes: ff27668ce809 ("bcache: pass the make_request methods to blk_queue_make_request")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It looks good to me.

Reviewed-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  drivers/md/bcache/request.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 71a90fbec314b..77d1a26975174 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1372,7 +1372,6 @@ void bch_flash_dev_request_init(struct bcache_device *d)
>  {
>  	struct gendisk *g = d->disk;
>  
> -	g->queue->make_request_fn		= flash_dev_make_request;
>  	g->queue->backing_dev_info->congested_fn = flash_dev_congested;
>  	d->cache_miss				= flash_dev_cache_miss;
>  	d->ioctl				= flash_dev_ioctl;
> 
