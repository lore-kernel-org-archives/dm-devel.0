From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/4] Test chunk size against both origin and
 snapshot sector size
Date: Mon, 15 Mar 2010 10:52:24 -0400
Message-ID: <20100315145224.GE6853@redhat.com>
References: <Pine.LNX.4.64.1003150201270.12526@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003150201270.12526@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 15 2010 at  2:04am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Test chunk size against both origin and snapshot sector size
> 
> Don't allow chunk size smaller than either origin or snapshot logical
> sector size. Reading or writing data unaligned to sector size is not allowed
> and causes immediate errors.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-exception-store.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.34-rc1-devel/drivers/md/dm-exception-store.c
> ===================================================================
> --- linux-2.6.34-rc1-devel.orig/drivers/md/dm-exception-store.c	2010-03-12 14:38:31.000000000 +0100
> +++ linux-2.6.34-rc1-devel/drivers/md/dm-exception-store.c	2010-03-12 14:39:56.000000000 +0100
> @@ -173,7 +173,9 @@ int dm_exception_store_set_chunk_size(st
>  
>  	/* Validate the chunk size against the device block size */
>  	if (chunk_size %
> -	    (bdev_logical_block_size(dm_snap_cow(store->snap)->bdev) >> 9)) {
> +	    (bdev_logical_block_size(dm_snap_cow(store->snap)->bdev) >> 9) ||
> +	    chunk_size %
> +	    (bdev_logical_block_size(dm_snap_origin(store->snap)->bdev) >> 9)) {
>  		*error = "Chunk size is not a multiple of device blocksize";
>  		return -EINVAL;
>  	}

Shouldn't we split these checks out so that we can have more precise
error reporting?  Ideally we'd share that chunk_size was not a multiple
of the "origin" or "snapshot" device's blocksize.

I was also thinking that we should avoid using %, e.g.: 
(chunk_size & (bdev_logical_block_size(...) - 1))

but AFAIK bdev_logical_block_size() may not be a power of 2 (MD allows
for obscure non-power of 2 blocksizes doesn't it?  Or is that just for
MD chunk and stripe size?).

Mike
