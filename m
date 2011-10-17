From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-bufio
Date: Mon, 17 Oct 2011 11:54:23 +0100
Message-ID: <20111017105423.GD13963@ubuntu>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 14, 2011 at 03:14:34PM -0400, Mikulas Patocka wrote:
> -static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block, enum new_flag nf,
> -				     struct dm_buffer **bp, int *need_submit)
> +static void read_endio(struct bio *bio, int error);
> +
> +static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
> +				     enum new_flag nf, struct dm_buffer **bp)
>  {
>  	struct dm_buffer *b, *new_b = NULL;
>  
> -	*need_submit = 0;
>  	b = __find(c, block);
>  	if (b) {
>  		b->hold_count++;
> @@ -821,7 +837,9 @@ static struct dm_buffer *__bufio_new(str
>  	}
>  
>  	b->state = 1 << B_READING;
> -	*need_submit = 1;
> +
> +	submit_io(b, READ, b->block, read_endio);
> +
>  	return b;
>  }
>  
> @@ -849,22 +867,18 @@ static void read_endio(struct bio *bio, 
>  static void *new_read(struct dm_bufio_client *c, sector_t block, enum new_flag nf,
>  		      struct dm_buffer **bp)
>  {
> -	int need_submit;
>  	struct dm_buffer *b;
>  
>  	dm_bufio_lock(c);
> -	b = __bufio_new(c, block, nf, bp, &need_submit);
> +	b = __bufio_new(c, block, nf, bp);
>  	dm_bufio_unlock(c);
>  
> 	if (!b || IS_ERR(b))
>  		return b;
>  	else {
> -		if (need_submit)
> -			submit_io(b, READ, b->block, read_endio);
> -
>  		wait_on_bit(&b->state, B_READING,
>  			    do_io_schedule, TASK_UNINTERRUPTIBLE);


This change means submit_io(), which can block, will be called with
the client lock held.  I don't see this as an improvement.  NACK.
