From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 01/10] pktcdvd: remove the call to blk_queue_bounce
Date: Mon, 19 Jun 2017 22:34:36 +0800
Message-ID: <CACVXFVMxgKk1kzL=rgAzdw8X5qgWn8Z_Hv-gUHSKfp1rXRArxA@mail.gmail.com>
References: <20170619072628.12894-1-hch@lst.de> <20170619072628.12894-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170619072628.12894-2-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 19, 2017 at 3:26 PM, Christoph Hellwig <hch@lst.de> wrote:
> pktcdvd is a make_request based stacking driver and thus doesn't have any
> addressing limits on it's own.  It also doesn't use bio_data() or
> page_address(), so it doesn't need a lowmem bounce either.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/pktcdvd.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index 26c04baae967..7f2eca31eb6a 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -2413,8 +2413,6 @@ static blk_qc_t pkt_make_request(struct request_queue *q, struct bio *bio)
>         char b[BDEVNAME_SIZE];
>         struct bio *split;
>
> -       blk_queue_bounce(q, &bio);
> -
>         blk_queue_split(q, &bio);
>
>         pd = q->queuedata;
> --
> 2.11.0
>

blk_queue_make_request() sets bounce for any highmem page for long time,
and in theory this patch might cause regression on 32bit arch, when
the controller can't handle higmem page really(especially in case of PAE), so
we may need to be careful about this change, especially on some old hardware.

thanks,
Ming Lei
