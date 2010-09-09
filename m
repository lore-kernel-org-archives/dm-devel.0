From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] virtio-blk: put request that was created to retrieve the
 device id
Date: Thu, 9 Sep 2010 17:15:04 -0400
Message-ID: <20100909211504.GA24506@infradead.org>
References: <20100909154442.GI30086@us.ibm.com>
 <20100909155726.GA9081@redhat.com>
 <20100909160324.GJ30086@us.ibm.com>
 <20100909175537.GA9589@redhat.com>
 <20100909183554.GK30086@us.ibm.com>
 <20100909191555.GA14486@redhat.com>
 <20100909194300.GA16908@redhat.com>
 <20100909201445.GA19656@redhat.com>
 <20100909203052.GL30086@us.ibm.com>
 <20100909210042.GA22092@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100909210042.GA22092@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ryan Harper <ryanh@us.ibm.com>, Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, john.cooper@redhat.com, rusty@rustcorp.com.au, hch@infradead.org, kvm@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Sep 09, 2010 at 05:00:42PM -0400, Mike Snitzer wrote:
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 1260628..831e75c 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -199,6 +199,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
>  	struct virtio_blk *vblk = disk->private_data;
>  	struct request *req;
>  	struct bio *bio;
> +	int err;
>  
>  	bio = bio_map_kern(vblk->disk->queue, id_str, VIRTIO_BLK_ID_BYTES,
>  			   GFP_KERNEL);
> @@ -212,7 +213,10 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
>  	}
>  
>  	req->cmd_type = REQ_TYPE_SPECIAL;
> -	return blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
> +	err = blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
> +	blk_put_request(req);

This looks correct as far as the request is concerned, but we're still
leaking the bio.

