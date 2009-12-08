From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v5 03/13] dm exception store: snapshot-merge
 usage accounting
Date: Mon, 7 Dec 2009 21:46:12 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0912072145200.16299@hs20-bc2-1.build.redhat.com>
References: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
	<1259893434-10792-4-git-send-email-snitzer@redhat.com>
	<20091207211053.GE16769@redhat.com>
	<20091207234453.GE30941@agk-dp.fab.redhat.com>
	<20091207235300.GA31492@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091207235300.GA31492@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 7 Dec 2009, Mike Snitzer wrote:

> On Mon, Dec 07 2009 at  6:44pm -0500,
> Alasdair G Kergon <agk@redhat.com> wrote:
> 
> > On Mon, Dec 07, 2009 at 04:10:53PM -0500, Mike Snitzer wrote:
> > > Subject: dm exception store: snapshot-merge usage accounting
> > 
> > Comments updated a bit and folded into
> > dm-exception-store-add-merge-specific-methods.patch # 64745
> 
> OK, I did the following based on our chat.. but haven't looked at your
> version yet (ftp://sources.redhat.com appears to be down?).
> 
> Mike
> ---
> 
> From: Mike Snitzer <snitzer@redhat.com>
> Subject: dm exception store: snapshot-merge usage accounting
> 
> Adjust the persistent exception store's next_free to the last chunk that
> was processed in persistent_commit_merge().  prepare_merge() may change
> ps->current_area but not before commit_merge() processes 'nr_merged'
> chunks from it.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> ---
>  drivers/md/dm-snap-persistent.c |   33 ++++++++++++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 5 deletions(-)
> 
> Index: linux-rhel6/drivers/md/dm-snap-persistent.c
> ===================================================================
> --- linux-rhel6.orig/drivers/md/dm-snap-persistent.c
> +++ linux-rhel6/drivers/md/dm-snap-persistent.c
> @@ -119,7 +119,24 @@ struct pstore {
>  	chunk_t current_area;
>  
>  	/*
> -	 * The next free chunk for an exception.
> +	 * 'next_free' can have two meanings.
> +	 *
> +	 * When creating exceptions:
> +	 * The next free chunk for an exception.  'next_free' means all
> +	 * the slots here and above are free.  Though there may be
> +	 * holes in the exception store because chunks can be committed
> +	 * out of order -- if the system halts abruptly it could
> +	 * leave a hole.
> +	 *
> +	 * When merging exceptions:
> +	 * The last chunk that was merged from a linear extent of
> +	 * chunks [returned from persistent_prepare_merge()].
> +	 * When merging 'next_free' does _not_ mean all the slots here
> +	 * and above are free.  It holds the value it would have held
> +	 * if all chunks in an area had been committed in order.  So
> +	 * the value may occasionally be slightly inaccurate, because
> +	 * chunks can be committed out of order, but since it's only
> +	 * used for 'status' this doesn't matter.
>  	 */
>  	chunk_t next_free;
>  
> @@ -753,10 +770,16 @@ static int persistent_commit_merge(struc
>  	ps->current_committed -= nr_merged;
>  
>  	/*
> -	 * Note that we make no attempt to keep ps->next_free up-to-date
> -	 * as exceptions may have been allocated out-of-order.
> -	 * Once a snapshot has become merging, nothing further uses it.
> -	 */
> +	 * Update ps->next_free so persistent_usage() is accurate
> +	 * - it may be less than the actual 'next_free' chunk but we
> +	 *   will not allocate exceptions again so this doesn't matter
> +	 * - must account for the first two metadata chunks
> +	 * - prepare_merge() may change ps->current_area but not before
> +	 *   commit_merge() processes 'nr_merged' from the current_area
> +	 */
> +	ps->next_free =
> +		(area_location(ps, ps->current_area) - 1 +
> +		 ps->current_committed + 2);
>  
>  	return 0;
>  }
> 

Acked-By: Mikulas Patocka <mpatocka@redhat.com>
