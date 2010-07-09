From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/1] dm-mpath: Extend path selector interface
 for supporting Dell EqualLogic path selector
Date: Fri, 9 Jul 2010 12:10:35 -0400
Message-ID: <20100709161035.GA10205@redhat.com>
References: <86A3089001A44141B76B882059E7E53B01E87A3B@M31.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <86A3089001A44141B76B882059E7E53B01E87A3B@M31.equallogic.com>
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
Cc: Parind Shah <Parind_Shah@dell.com>, Jason Shamberger <Jason_Shamberger@dell.com>, agk@redhat.com, Narendran Ganapathy <Narendran_Ganapathy@dell.com>
List-Id: dm-devel.ids

On Mon, Jun 28 2010 at  9:53am -0400,
Narendran Ganapathy <Narendran_Ganapathy@dell.com> wrote:

> We propose to extend the path selector interface to pass the entire
> request pointer to the 'select_path' / 'start_io' /  'end_io'
> functions so that the path selector can use any information therein to
> route the I/O.

So passing the entire request aside (Kiyoshi already shared that this is
not desirable)...

> We also propose extending the dm_mpath_io structure used to hold
> information about each I/O to include extra fields for the path
> selector to store I/O specific flags and a timestamp, so the path
> selector can determine the latency of I/Os on different paths and that
> information is passed to the 'select_path' / 'start_io' /  'end_io'
> functions for path selector usage. These additions to the dm_mpath_io
> allow future flexibility in developing algorithms that route IO based
> on other information from the request in the future.

How can you reasonably pass "extra fields for the path selector to store
I/O specific flags and a timestamp"?

'nr_bytes' and 'struct dm_ps_io_ctx' are mutually exclussive
(side-effect of using a 'union dm_mpath_ps_io').

Yet I'm not seeing where the existing 'select_path' / 'start_io' /
'end_io' interfaces are weened off of their potential dependency on
'nr_bytes'.

dm-service-time path selector uses nr_bytes (and obviously doesn't use
dm_ps_io_ctx).  But what if a path selector had a need for both
'nr_bytes' and 'dm_ps_io_ctx'?  Presummably the future might require us
to add additional members to dm_ps_io_ctx or dm_mpath_ps_io too.

Long story short, I do not think you should be using a union for
dm_mpath_ps_io (it should just be a struct).

But I'd imagine you've likely already switched away from a union in
order to store the relevant members of the 'struct request' (rather than
passing the request to the path selectors) in dm_mpath_ps_io.

Mike

> diff --git a/drivers/md/dm-mpath.h b/drivers/md/dm-mpath.h
> index e230f71..45e9c58 100644
> --- a/drivers/md/dm-mpath.h
> +++ b/drivers/md/dm-mpath.h
> @@ -16,6 +16,26 @@ struct dm_path {
>  	void *pscontext;	/* For path-selector use */
>  };
>  
> +
> +/*
> + * Context information attached to each bio we process.
> + */
> +struct dm_ps_io_ctx {
> +	uint32_t flags;
> +	unsigned long iotime;
> +};
> +
> +union dm_mpath_ps_io {
> +	size_t nr_bytes;
> +	struct dm_ps_io_ctx ps_ctx;
> +};
> +
> +struct dm_mpath_io {
> +	struct pgpath *pgpath;
> +	union dm_mpath_ps_io u;
> +};
> +
> +
>  /* Callback for hwh_pg_init_fn to use when complete */
>  void dm_pg_init_complete(struct dm_path *path, unsigned err_flags);
>  
> diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
> index e7d1fa8..cff8ca5 100644
> --- a/drivers/md/dm-path-selector.h
> +++ b/drivers/md/dm-path-selector.h
> @@ -57,7 +57,8 @@ struct path_selector_type {
>  	 */
>  	struct dm_path *(*select_path) (struct path_selector *ps,
>  					unsigned *repeat_count,
> -					size_t nr_bytes);
> +					union dm_mpath_ps_io *psio,
> +					struct request *clone);
>  
>  	/*
>  	 * Notify the selector that a path has failed.
> @@ -77,9 +78,9 @@ struct path_selector_type {
>  		       status_type_t type, char *result, unsigned int maxlen);
>  
>  	int (*start_io) (struct path_selector *ps, struct dm_path *path,
> -			 size_t nr_bytes);
> +			 union dm_mpath_ps_io *psio, struct request *clone);
>  	int (*end_io) (struct path_selector *ps, struct dm_path *path,
> -		       size_t nr_bytes);
> +			 union dm_mpath_ps_io *psio, struct request *clone);
>  };
>  
>  /* Register a path selector */
