From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-bufio: prefetch
Date: Tue, 13 Mar 2012 23:04:50 +0000
Message-ID: <20120313230450.GE3775@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1203121744510.3313@file.rdu.redhat.com>
	<20120313130044.GB3415@redhat.com>
	<Pine.LNX.4.64.1203131043480.18405@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203131043480.18405@file.rdu.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Let's move this 'found_buffer' code after both places that use it, I think.
(goto an earlier point in the function would normally mean a loop, which
this isn't)

Alasdair


On Tue, Mar 13, 2012 at 10:46:00AM -0400, Mikulas Patocka wrote:
> @@ -882,6 +888,19 @@ static struct dm_buffer *__bufio_new(str
>  
>  	b = __find(c, block);
>  	if (b) {
> +found_buffer:
> +		if (nf == NF_PREFETCH)
> +			return NULL;
> +		/*
> +		 * Note: it is essential that we don't wait for the buffer to be
> +		 * read if dm_bufio_get function is used. Both dm_bufio_get and
> +		 * dm_bufio_prefetch can be used in the driver request routine.
> +		 * If the user called both dm_bufio_prefetch and dm_bufio_get on
> +		 * the same buffer, it would deadlock if we waited.
> +		 */
> +		if (nf == NF_GET && unlikely(test_bit(B_READING, &b->state)))
> +			return NULL;
> +
>  		b->hold_count++;
>  		__relink_lru(b, test_bit(B_DIRTY, &b->state) ||
>  			     test_bit(B_WRITING, &b->state));

> @@ -900,10 +921,7 @@ static struct dm_buffer *__bufio_new(str
>  	b = __find(c, block);
>  	if (b) {
>  		__free_buffer_wake(new_b);
> -		b->hold_count++;
> -		__relink_lru(b, test_bit(B_DIRTY, &b->state) ||
> -			     test_bit(B_WRITING, &b->state));
> -		return b;
> +		goto found_buffer;
>  	}
