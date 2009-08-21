From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: expose dm-stripe target's topology I/O hints
Date: Fri, 21 Aug 2009 10:16:39 -0400
Message-ID: <20090821141638.GA4086@redhat.com>
References: <1247261592-9803-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1247261592-9803-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jul 10 2009 at  5:33pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Add .io_hints to 'struct target_type' to allow the I/O hints portion of
> the 'struct queue_limits' to be set by each target.  Expose dm-stripe
> target's topology I/O hints.
> 
> NOTE: This patch makes use of blk_limits_io_min(); which will be
> upstream, via the block tree, in the near future.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
> 
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index b240e85..9350566 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -328,6 +328,16 @@ static int stripe_iterate_devices(struct dm_target *ti,
>  	return ret;
>  }
>  
> +static void stripe_io_hints(struct dm_target *ti,
> +			    struct queue_limits *limits)
> +{
> +	struct stripe_c *sc = ti->private;
> +	unsigned chunk_size = (sc->chunk_mask + 1) << 9;
> +
> +	blk_limits_io_min(chunk_size);
> +	limits->io_opt = chunk_size * sc->stripes;
> +}

The call to blk_limits_io_min() is missing the first queue_limits arg.

I'll send v2 of this patch.
