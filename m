From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 7/7] dm snapshot: use bufio prefetch
Date: Mon, 13 Jan 2014 17:00:44 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401131659250.12957@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401111222400.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111228220.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229150.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229390.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111230080.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111230330.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111231000.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111231420.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<20140113213758.GC3268@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140113213758.GC3268@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

No.

This changed patch inefficiently loops in bufio_prefetch_chunks for each 
buffer that is read.

Mikulas


On Mon, 13 Jan 2014, Mike Snitzer wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> This patch modifies dm-snapshot so that it prefetches the buffers when
> loading the exceptions.
> 
> The number of chunk-sized buffers read ahead is specified in the
> DM_PREFETCH_CHUNKS macro.  The current default for DM_PREFETCH_CHUNKS
> (12) may need to be adjusted to improve performance on different types
> of storage -- a future patch should make this configurable.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-snap-persistent.c |   34 +++++++++++++++++++++++++++++++++-
>  1 files changed, 33 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
> index 1692750..ea45b3b 100644
> --- a/drivers/md/dm-snap-persistent.c
> +++ b/drivers/md/dm-snap-persistent.c
> @@ -18,6 +18,8 @@
>  #define DM_MSG_PREFIX "persistent snapshot"
>  #define DM_CHUNK_SIZE_DEFAULT_SECTORS 32	/* 16KB */
>  
> +#define DM_PREFETCH_CHUNKS		12
> +
>  /*-----------------------------------------------------------------
>   * Persistent snapshots, by persistent we mean that the snapshot
>   * will survive a reboot.
> @@ -490,6 +492,30 @@ static int insert_exceptions(struct pstore *ps, void *ps_area,
>  	return 0;
>  }
>  
> +static void bufio_prefetch_chunks(struct dm_bufio_client *client,
> +				  struct pstore *ps)
> +{
> +	chunk_t prefetch_area = 0;
> +	chunk_t pf_chunk;
> +
> +	if (!DM_PREFETCH_CHUNKS)
> +		return;
> +
> +	if (prefetch_area < ps->current_area)
> +		prefetch_area = ps->current_area;
> +
> +	do {
> +		pf_chunk = area_location(ps, prefetch_area);
> +		if (unlikely(pf_chunk >= dm_bufio_get_device_size(client)))
> +			break;
> +		if (unlikely(!dm_bufio_prefetch(client, pf_chunk, 1)))
> +			break;
> +		prefetch_area++;
> +		if (unlikely(!prefetch_area))
> +			break;
> +	} while (prefetch_area <= ps->current_area + DM_PREFETCH_CHUNKS);
> +}
> +
>  static int read_exceptions(struct pstore *ps,
>  			   int (*callback)(void *callback_context, chunk_t old,
>  					   chunk_t new),
> @@ -505,6 +531,8 @@ static int read_exceptions(struct pstore *ps,
>  	if (IS_ERR(client))
>  		return PTR_ERR(client);
>  
> +	dm_bufio_set_minimum_buffers(client, DM_PREFETCH_CHUNKS + 1);
> +
>  	/*
>  	 * Keeping reading chunks and inserting exceptions until
>  	 * we find a partially full area.
> @@ -512,7 +540,11 @@ static int read_exceptions(struct pstore *ps,
>  	for (ps->current_area = 0; full; ps->current_area++) {
>  		struct dm_buffer *bp;
>  		void *area;
> -		chunk_t chunk = area_location(ps, ps->current_area);
> +		chunk_t chunk;
> +
> +		bufio_prefetch_chunks(client, ps);
> +
> +		chunk = area_location(ps, ps->current_area);
>  
>  		area = dm_bufio_read(client, chunk, &bp);
>  		if (unlikely(IS_ERR(area))) {
> -- 
> 1.7.4.4
> 
