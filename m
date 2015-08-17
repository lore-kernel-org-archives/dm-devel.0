From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-snap deadlock in pending_complete()
Date: Mon, 17 Aug 2015 06:55:37 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1508170650460.29294@file01.intranet.prod.int.rdu2.redhat.com>
References: <20150810135551.64d7dbac@noble>
	<alpine.LRH.2.02.1508110509420.2623@file01.intranet.prod.int.rdu2.redhat.com>
	<20150812114631.15268065@noble>
	<alpine.LRH.2.02.1508121006370.5295@file01.intranet.prod.int.rdu2.redhat.com>
	<20150813112316.628f0de6@noble>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150813112316.628f0de6@noble>
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



On Thu, 13 Aug 2015, NeilBrown wrote:

> On Wed, 12 Aug 2015 10:16:17 -0400 (EDT) Mikulas Patocka
> <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Wed, 12 Aug 2015, NeilBrown wrote:
> > 
> > > Ahh - thanks for the explanation.  That makes sense.
> > > Presumably you need to wait for old reads that you don't have a read
> > > returning old data after a write has confirmed the new data is written?
> > > Is there some other reason?
> > > 
> > > As soon as the new "proper" exception is installed, no new reads will
> > > use the old address, so it should be safe to wait without holding the
> > > lock.
> > > 
> > > So what about this?
> > 
> > This is wrong too - when you add the exception to the complete hash table 
> > and drop the lock, writes to the chunk in the origin target are can modify 
> > the origin volume. These writes race with pending reads to the snapshot 
> > (__chunk_is_tracked tests for those reads). If the I/O scheduler schedules 
> > the write to the origin before the read from the snapshot, the read from 
> > the snapshot returns corrupted data.
> > 
> > There can be more problems with snapshot merging - if the chunk is on the 
> > complete hash table, the merging code assumes that it can be safely 
> > merged.
> > 
> 
> Thanks again.
> 
> I came up with the following which should address the origin-write
> issue, but I'm not so sure about snapshot merging, and it is becoming a
> lot less simple that I had hoped.
> 
> I'll see if I can come up with code for a more general solution that is
> still localised to dm - along the lines of my bio_split suggestion.
> 
> Thanks,
> NeilBrown
> 
> 
> 
> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> index 7c82d3ccce87..7f9e1b0429c8 100644
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -1461,14 +1461,22 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
>  		goto out;
>  	}
>  
> -	/* Check for conflicting reads */
> -	__check_for_conflicting_io(s, pe->e.old_chunk);
> +	/* Add proper exception.  Now all reads will be
> +	 * redirected, so no new reads can be started on
> +	 * 'old_chunk'.
> +	 */
> +	dm_insert_exception(&s->complete, e);
> +
> +	/* Drain conflicting reads */
> +	if (__chunk_is_tracked(s, pe->e.old_chunk)) {
> +		up_write(&s->lock);
> +		__check_for_conflicting_io(s, pe->e.old_chunk);
> +		down_write(&s->lock);
> +	}
>  
>  	/*
> -	 * Add a proper exception, and remove the
> -	 * in-flight exception from the list.
> +	 * And now we can remove the temporary exception.
>  	 */
> -	dm_insert_exception(&s->complete, e);
>  
>  out:
>  	dm_remove_exception(&pe->e);
> @@ -2089,17 +2097,17 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
>  		 */
>  		chunk = sector_to_chunk(snap->store, sector);
>  
> -		/*
> -		 * Check exception table to see if block
> -		 * is already remapped in this snapshot
> -		 * and trigger an exception if not.
> -		 */
> -		e = dm_lookup_exception(&snap->complete, chunk);
> -		if (e)
> -			goto next_snapshot;
> -
>  		pe = __lookup_pending_exception(snap, chunk);
>  		if (!pe) {
> +			/*
> +			 * Check exception table to see if block
> +			 * is already remapped in this snapshot
> +			 * and trigger an exception if not.
> +			 */
> +			e = dm_lookup_exception(&snap->complete, chunk);
> +			if (e)
> +				goto next_snapshot;
> +
>  			up_write(&snap->lock);
>  			pe = alloc_pending_exception(snap);
>  			down_write(&snap->lock);

You forgot about another race after these calls to up_write/down_write - 
after the lock is taken again, you must call both dm_lookup_exception and 
__lookup_pending_exception.

Mikulas
