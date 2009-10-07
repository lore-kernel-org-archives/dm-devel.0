From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 4/4]
	dm-exception-store-dont-read-metadata-if-going-to-handover
Date: Wed, 7 Oct 2009 12:48:41 -0500
Message-ID: <9CC39E3C-BD6F-48E3-A754-04D18E0C81DA@redhat.com>
References: <1254769231-12053-1-git-send-email-snitzer@redhat.com>
	<1254769231-12053-5-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254769231-12053-5-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

I don't think the extra parameter is necessary...  Couldn't you use  
the functionality of your future "re-read metadata" patch (or my old  
"allow metadata re-read" patch) to achieve the same thing here?  (It  
is possible that idea won't work, because when re-reading the  
metadata, I like to read the COW header to ensure someone else didn't  
invalidate the exception store.)

Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

  brassow


On Oct 5, 2009, at 2:00 PM, Mike Snitzer wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
>
> Don't read metadata if we are going to do handover.
> This saves memory (without the patch, the exception store would  
> consume twice
> more memory while doing handover).
>
> If the handover doesn't happen (due to user abusing dmsetup), the  
> snapshot is
> marked as invalid.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>
> ---
> drivers/md/dm-exception-store.h |    6 +++++-
> drivers/md/dm-snap-persistent.c |    5 +++--
> drivers/md/dm-snap-transient.c  |    2 +-
> drivers/md/dm-snap.c            |    2 +-
> 4 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm- 
> exception-store.h
> index 4e8086f..5737796 100644
> --- a/drivers/md/dm-exception-store.h
> +++ b/drivers/md/dm-exception-store.h
> @@ -54,11 +54,15 @@ struct dm_exception_store_type {
> 	 * The target shouldn't read the COW device until this is
> 	 * called.  As exceptions are read from the COW, they are
> 	 * reported back via the callback.
> +	 *
> +	 * will_handover means that there is another snapshot active;
> +	 * chunk size must be setup but no exceptions need to be read
> +	 * because they will be handed over from the active snapshot.
> 	 */
> 	int (*read_metadata) (struct dm_exception_store *store,
> 			      int (*callback)(void *callback_context,
> 					      chunk_t old, chunk_t new),
> -			      void *callback_context);
> +			      void *callback_context, int will_handover);
>
> 	/*
> 	 * Find somewhere to store the next exception.
> diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap- 
> persistent.c
> index 746602b..fbcedc3 100644
> --- a/drivers/md/dm-snap-persistent.c
> +++ b/drivers/md/dm-snap-persistent.c
> @@ -518,7 +518,7 @@ static void persistent_dtr(struct  
> dm_exception_store *store)
> static int persistent_read_metadata(struct dm_exception_store *store,
> 				    int (*callback)(void *callback_context,
> 						    chunk_t old, chunk_t new),
> -				    void *callback_context)
> +				    void *callback_context, int will_handover)
> {
> 	int r, uninitialized_var(new_snapshot);
> 	struct pstore *ps = get_info(store);
> @@ -575,7 +575,8 @@ static int persistent_read_metadata(struct  
> dm_exception_store *store,
> 	/*
> 	 * Read the metadata.
> 	 */
> -	r = read_exceptions(ps, callback, callback_context);
> +	if (!will_handover)
> +		r = read_exceptions(ps, callback, callback_context);
>
> 	return r;
> }
> diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap- 
> transient.c
> index 3d9fd91..7f4f825 100644
> --- a/drivers/md/dm-snap-transient.c
> +++ b/drivers/md/dm-snap-transient.c
> @@ -30,7 +30,7 @@ static void transient_dtr(struct  
> dm_exception_store *store)
> static int transient_read_metadata(struct dm_exception_store *store,
> 				   int (*callback)(void *callback_context,
> 						   chunk_t old, chunk_t new),
> -				   void *callback_context)
> +				   void *callback_context, int will_handover)
> {
> 	return 0;
> }
> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> index 8d3efa0..275ae33 100644
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -708,7 +708,7 @@ static int snapshot_ctr(struct dm_target *ti,  
> unsigned int argc, char **argv)
>
> 	/* Metadata must only be loaded into one table at once */
> 	r = s->store->type->read_metadata(s->store, dm_add_exception,
> -					  (void *)s);
> +					  (void *)s, s->handover);
> 	if (r < 0) {
> 		ti->error = "Failed to read snapshot metadata";
> 		goto bad_load_and_register;
> -- 
> 1.6.2.5
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
