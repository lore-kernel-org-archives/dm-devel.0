From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 2/3] md: multipath: Pass io_start_time to
 the path selector
Date: Tue, 28 Apr 2020 13:25:35 -0400
Message-ID: <20200428172534.GB17285@redhat.com>
References: <20200428005146.242231-1-krisman@collabora.com>
	<20200428005146.242231-3-krisman@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200428005146.242231-3-krisman@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: dm-devel@redhat.com, kernel@collabora.com, khazhy@google.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 27 2020 at  8:51pm -0400,
Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> HST need to know the IO start time in order to predict path
> performance. For request-based multipath use the block layer
> io_start_time, while for BIO use the dm_io start_time.
> 
> The dm_start_time_ns_from_clone function was suggested and implemented
> by Mike Snitzer <snitzer@redhat.com>.
> 
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> ---
>  drivers/md/dm-mpath.c         | 25 +++++++++++++++----------
>  drivers/md/dm-path-selector.h |  1 +
>  drivers/md/dm.c               | 10 ++++++++++
>  include/linux/device-mapper.h |  2 ++
>  4 files changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 1ef4fc2e745b..7af3249948be 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -500,8 +500,9 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
>  	struct dm_mpath_io *mpio = get_mpio(map_context);
>  	struct request_queue *q;
>  	struct request *clone;
> -	struct path_selector_io_data io_data = {
> +	struct path_selector_io_data ps_io_data = {
>  		.nr_bytes = nr_bytes,
> +		.io_start_time = rq->io_start_time_ns
>  	};
>  
>  	/* Do we need to select a new pgpath? */
> @@ -552,7 +553,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
>  	if (pgpath->pg->ps.type->start_io)
>  		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
>  					      &pgpath->path,
> -					      &io_data);
> +					      &ps_io_data);
>  	return DM_MAPIO_REMAPPED;
>  }
>  
> @@ -568,6 +569,7 @@ static void multipath_release_clone(struct request *clone,
>  		struct pgpath *pgpath = mpio->pgpath;
>  		struct path_selector_io_data ps_io_data = {
>  			.nr_bytes = mpio->nr_bytes,
> +			.io_start_time = clone->io_start_time_ns,
>  		};
>  
>  		if (pgpath && pgpath->pg->ps.type->end_io)
> @@ -623,8 +625,9 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
>  			       struct dm_mpath_io *mpio)
>  {
>  	struct pgpath *pgpath = __map_bio(m, bio);
> -	struct path_selector_io_data io_data = {
> +	struct path_selector_io_data ps_io_data = {
>  		.nr_bytes = mpio->nr_bytes,
> +		.io_start_time = dm_start_time_ns_from_clone(bio)
>  	};
>  
>  	if (IS_ERR(pgpath))
> @@ -646,7 +649,7 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
>  	if (pgpath->pg->ps.type->start_io)
>  		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
>  					      &pgpath->path,
> -					      &io_data);
> +					      &ps_io_data);
>  	return DM_MAPIO_REMAPPED;
>  }
>  

io_start_time_ns isn't needed by any path selector's start_io method.
Please drop that from start_io and only pass it to the end_io hook.

(the need for dm_start_time_ns_from_clone() to access the more nested
nature of a bio clone's start_time showcases why we should avoid
needless collection of parameters that aren't required).

Thanks,
Mike
