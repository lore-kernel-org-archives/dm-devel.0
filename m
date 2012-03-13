From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio: prefetch
Date: Tue, 13 Mar 2012 09:00:44 -0400
Message-ID: <20120313130044.GB3415@redhat.com>
References: <Pine.LNX.4.64.1203121744510.3313@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203121744510.3313@file.rdu.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 12 2012 at  5:48pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> This patch adds prefetch function to dm-bufio. I'm adding Joe to CC, 
> because he may use it in his code too.
> 
> Mikulas
> 
> ---
> 
> dm-bufio: prefetch
> 
> This patch introduces a new function dm_bufio_prefetch. It prefetches
> the specified range of blocks into dm-bufio cache without waiting
> for i/o completion.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-bufio.c |   88 +++++++++++++++++++++++++++++++++++++++-----------
>  drivers/md/dm-bufio.h |    8 ++++
>  2 files changed, 77 insertions(+), 19 deletions(-)
> 
> Index: linux-3.3-rc6-fast/drivers/md/dm-bufio.c
> ===================================================================
> --- linux-3.3-rc6-fast.orig/drivers/md/dm-bufio.c	2012-03-12 22:20:47.000000000 +0100
> +++ linux-3.3-rc6-fast/drivers/md/dm-bufio.c	2012-03-12 22:38:01.000000000 +0100

...

> @@ -1006,13 +1024,42 @@ void *dm_bufio_new(struct dm_bufio_clien
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_new);
>  
> +void dm_bufio_prefetch(struct dm_bufio_client *c,
> +		       sector_t block, unsigned n_blocks)
> +{
> +	struct blk_plug plug;
> +
> +	blk_start_plug(&plug);
> +	dm_bufio_lock(c);
> +
> +	for (; n_blocks--; block++) {
> +		int need_submit;
> +		struct dm_buffer *b;
> +		b = __bufio_new(c, block, NF_PREFETCH, &need_submit);
> +		if (unlikely(b != NULL)) {
> +			dm_bufio_unlock(c);
> +
> +			if (need_submit)
> +				submit_io(b, READ, b->block, read_endio);
> +			dm_bufio_release(b);
> +
> +			dm_bufio_cond_resched();
> +			dm_bufio_lock(c);
> +		}
> +
> +	}
> +
> +	dm_bufio_unlock(c);
> +	blk_finish_plug(&plug);
> +}
> +EXPORT_SYMBOL(dm_bufio_prefetch);

Shouldn't this be EXPORT_SYMBOL_GPL (to match other bufio exports)?
