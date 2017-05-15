From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/4] dm rq: add a missing break to map_request
Date: Mon, 15 May 2017 14:25:06 -0400
Message-ID: <20170515182506.GA6257@redhat.com>
References: <20170515152839.23375-1-hch@lst.de>
 <20170515152839.23375-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170515152839.23375-2-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 15 2017 at 11:28am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> We don't want to bug when receiving a DM_MAPIO_KILL value..
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-rq.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 2af27026aa2e..b639fa7246ee 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -507,6 +507,7 @@ static int map_request(struct dm_rq_target_io *tio)
>  	case DM_MAPIO_KILL:
>  		/* The target wants to complete the I/O */
>  		dm_kill_unmapped_request(rq, -EIO);
> +		break;
>  	default:
>  		DMWARN("unimplemented target map return value: %d", r);
>  		BUG();
> -- 
> 2.11.0
> 

Thanks, but I have no idea how this happened.  I specifically recall
fixing this very same issue (missing break).  Grr...
