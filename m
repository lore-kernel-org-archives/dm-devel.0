From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/7] dm-bufio: return success or failure on
	prefetch
Date: Mon, 13 Jan 2014 16:21:17 -0500
Message-ID: <20140113212116.GA3268@redhat.com>
References: <alpine.LRH.2.02.1401111222400.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111228220.4018@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401111228220.4018@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Sat, Jan 11 2014 at 12:29pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> This patch makes dm_bufio_prefetch return 1 on success and 0 on failure.
> A prefetch failure may happen in case of temporary memory shortage.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-bufio.c |    8 ++++++--
>  drivers/md/dm-bufio.h |    4 ++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> Index: linux-3.13-rc7/drivers/md/dm-bufio.c
> ===================================================================
> --- linux-3.13-rc7.orig/drivers/md/dm-bufio.c	2014-01-09 16:11:31.000000000 +0100
> +++ linux-3.13-rc7/drivers/md/dm-bufio.c	2014-01-09 16:16:43.000000000 +0100
> @@ -1068,10 +1068,11 @@ void *dm_bufio_new(struct dm_bufio_clien
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_new);
>  
> -void dm_bufio_prefetch(struct dm_bufio_client *c,
> +int dm_bufio_prefetch(struct dm_bufio_client *c,
>  		       sector_t block, unsigned n_blocks)
>  {
>  	struct blk_plug plug;
> +	int success = 1;
>  
>  	LIST_HEAD(write_list);
>  

I'd prefer to see a bool used here.  Or an actual error code like
-ENOMEM.

> @@ -1104,13 +1105,16 @@ void dm_bufio_prefetch(struct dm_bufio_c
>  			if (!n_blocks)
>  				goto flush_plug;
>  			dm_bufio_lock(c);
> -		}
> +		} else
> +			success = 0;

Why do you continue to do work if a prefetch failed?  Why not return
early here?
