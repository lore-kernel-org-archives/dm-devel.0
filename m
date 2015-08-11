From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-snap deadlock in pending_complete()
Date: Tue, 11 Aug 2015 05:14:33 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1508110509420.2623@file01.intranet.prod.int.rdu2.redhat.com>
References: <20150810135551.64d7dbac@noble>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150810135551.64d7dbac@noble>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

On Mon, 10 Aug 2015, NeilBrown wrote:

> 
> Hi Mikulas,
>  I have a customer hitting the deadlock you described over a year ago
>  in:
> 
> Subject: [dm-devel] [PATCH] block: flush queued bios when the process
>          blocks

Ask block layer maintainers to accept that patch.

> I notice that patch never went upstream.
> 
> Has anything else been done to fix this deadlock?
> 
> My thought was that something like the below would be sufficient.  Do
> you see any problem with that?  It avoids the deadlock by dropping the
> lock while sleeping.

The patch below introduces a bug - if the user is continuously reading the 
same chunk (for example, by issuing multiple direct i/o requests to the 
same chunk), the function pending_complete never finishes.

We need to hold the lock while waiting to make sure that no new read 
requests are submitted.

Mikulas

> Thanks
> NeilBrown
> 
> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> index 7c82d3ccce87..d29bcd02f9cf 100644
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -1454,6 +1454,7 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
>  	}
>  	*e = pe->e;
>  
> +retry:
>  	down_write(&s->lock);
>  	if (!s->valid) {
>  		free_completed_exception(e);
> @@ -1462,7 +1463,11 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
>  	}
>  
>  	/* Check for conflicting reads */
> -	__check_for_conflicting_io(s, pe->e.old_chunk);
> +	if (__chunk_size_tracked(s, pe->e.old_chunk)) {
> +		up_write(&s->lock);
> +		msleep(1);
> +		goto retry;
> +	}
>  
>  	/*
>  	 * Add a proper exception, and remove the
> 
