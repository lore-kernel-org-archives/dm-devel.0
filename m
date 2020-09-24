From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 02/11] libmultipath: copy mpp->hwe from
	pp->hwe
Date: Thu, 24 Sep 2020 15:12:45 -0500
Message-ID: <20200924201245.GH11108@octiron.msp.redhat.com>
References: <20200924133644.14034-1-mwilck@suse.com>
	<20200924133644.14034-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133644.14034-3-mwilck@suse.com>
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
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 24, 2020 at 03:36:35PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since f0462f0 ("libmultipath: use vector for for pp->hwe and mp->hwe"),
> we've been trying to fix issues caused by paths getting freed and mpp->hwe
> dangling. This approach couldn't work because we need mpp->hwe to persist,
> even if all paths are removed from the map. Before f0462f0, a simple
> assignment worked, because the lifetime of the hwe wasn't bound to the
> path. But now, we need to copy the vector. It turns out that we need to set
> mpp->hwe only in two places, add_map_with_path() and setup_map(), and
> that the code is simplified overall.

Unless I'm missing someting, it looks like
__mpath_persistent_reserve_out() will call select_all_tg_pt(), which
uses mpp->hwe, without ever setting it.  Granted, I don't see how this
was supposed to work before your patch either.

-Ben

> 
> Even now, it can happen that a map is added with add_map_without_paths(),
> and has no paths. In that case, calling do_set_from_hwe() with a NULL
> pointer is not a bug, so remove the message.
> 
> Fixes: f0462f0 ("libmultipath: use vector for for pp->hwe and mp->hwe")
> ---
>  libmultipath/configure.c   |  7 +++++
>  libmultipath/propsel.c     |  4 +--
>  libmultipath/structs.c     | 15 +++++++++++
>  libmultipath/structs.h     |  1 +
>  libmultipath/structs_vec.c | 54 ++++++++++++++++----------------------
>  multipathd/main.c          | 10 -------
>  6 files changed, 46 insertions(+), 45 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 6fb477f..d7afc91 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -311,6 +311,13 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
>  	if (mpp->disable_queueing && VECTOR_SIZE(mpp->paths) != 0)
>  		mpp->disable_queueing = 0;
>  
> +	/*
> +	 * If this map was created with add_map_without_path(),
> +	 * mpp->hwe might not be set yet.
> +	 */
> +	if (!mpp->hwe)
> +		extract_hwe_from_path(mpp);
> +
>  	/*
>  	 * properties selectors
>  	 *
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 7e6e0d6..4020134 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -65,9 +65,7 @@ do {									\
>  	__do_set_from_vec(struct hwentry, var, (src)->hwe, dest)
>  
>  #define do_set_from_hwe(var, src, dest, msg)				\
> -	if (!src->hwe) {						\
> -		condlog(0, "BUG: do_set_from_hwe called with hwe == NULL"); \
> -	} else if (__do_set_from_hwe(var, src, dest)) {			\
> +	if (src->hwe && __do_set_from_hwe(var, src, dest)) {		\
>  		origin = msg;						\
>  		goto out;						\
>  	}
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 464596f..2efad6f 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -234,6 +234,17 @@ alloc_multipath (void)
>  	return mpp;
>  }
>  
> +void *set_mpp_hwe(struct multipath *mpp, const struct path *pp)
> +{
> +	if (!mpp || !pp || !pp->hwe)
> +		return NULL;
> +	if (mpp->hwe)
> +		return mpp->hwe;
> +	mpp->hwe = vector_convert(NULL, pp->hwe,
> +				  struct hwentry, identity);
> +	return mpp->hwe;
> +}
> +
>  void free_multipath_attributes(struct multipath *mpp)
>  {
>  	if (!mpp)
> @@ -290,6 +301,10 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
>  
>  	free_pathvec(mpp->paths, free_paths);
>  	free_pgvec(mpp->pg, free_paths);
> +	if (mpp->hwe) {
> +		vector_free(mpp->hwe);
> +		mpp->hwe = NULL;
> +	}
>  	FREE_PTR(mpp->mpcontext);
>  	FREE(mpp);
>  }
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 4afd3e8..3bd2bbd 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -421,6 +421,7 @@ struct host_group {
>  struct path * alloc_path (void);
>  struct pathgroup * alloc_pathgroup (void);
>  struct multipath * alloc_multipath (void);
> +void *set_mpp_hwe(struct multipath *mpp, const struct path *pp);
>  void uninitialize_path(struct path *pp);
>  void free_path (struct path *);
>  void free_pathvec (vector vec, enum free_path_mode free_paths);
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 7fd860e..b10d347 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -282,11 +282,6 @@ err:
>  void orphan_path(struct path *pp, const char *reason)
>  {
>  	condlog(3, "%s: orphan path, %s", pp->dev, reason);
> -	if (pp->mpp && pp->hwe && pp->mpp->hwe == pp->hwe) {
> -		condlog(0, "BUG: orphaning path %s that holds hwe of %s",
> -			pp->dev, pp->mpp->alias);
> -		pp->mpp->hwe = NULL;
> -	}
>  	pp->mpp = NULL;
>  	uninitialize_path(pp);
>  }
> @@ -296,8 +291,6 @@ void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
>  	int i;
>  	struct path * pp;
>  
> -	/* Avoid BUG message from orphan_path() */
> -	mpp->hwe = NULL;
>  	vector_foreach_slot (pathvec, pp, i) {
>  		if (pp->mpp == mpp) {
>  			if (pp->initialized == INIT_REMOVED) {
> @@ -385,24 +378,26 @@ extract_hwe_from_path(struct multipath * mpp)
>  	if (mpp->hwe || !mpp->paths)
>  		return;
>  
> -	condlog(3, "%s: searching paths for valid hwe", mpp->alias);
> +	condlog(4, "%s: searching paths for valid hwe", mpp->alias);
>  	/* doing this in two passes seems like paranoia to me */
>  	vector_foreach_slot(mpp->paths, pp, i) {
> -		if (pp->state != PATH_UP)
> -			continue;
> -		if (pp->hwe) {
> -			mpp->hwe = pp->hwe;
> -			return;
> -		}
> +		if (pp->state == PATH_UP &&
> +		    pp->initialized != INIT_REMOVED && pp->hwe)
> +			goto done;
>  	}
>  	vector_foreach_slot(mpp->paths, pp, i) {
> -		if (pp->state == PATH_UP)
> -			continue;
> -		if (pp->hwe) {
> -			mpp->hwe = pp->hwe;
> -			return;
> -		}
> +		if (pp->state != PATH_UP &&
> +		    pp->initialized != INIT_REMOVED && pp->hwe)
> +			goto done;
>  	}
> +done:
> +	if (i < VECTOR_SIZE(mpp->paths))
> +		(void)set_mpp_hwe(mpp, pp);
> +
> +	if (mpp->hwe)
> +		condlog(3, "%s: got hwe from path %s", mpp->alias, pp->dev);
> +	else
> +		condlog(2, "%s: no hwe found", mpp->alias);
>  }
>  
>  int
> @@ -502,8 +497,6 @@ void sync_paths(struct multipath *mpp, vector pathvec)
>  		}
>  		if (!found) {
>  			condlog(3, "%s dropped path %s", mpp->alias, pp->dev);
> -			if (mpp->hwe == pp->hwe)
> -				mpp->hwe = NULL;
>  			vector_del_slot(mpp->paths, i--);
>  			orphan_path(pp, "path removed externally");
>  		}
> @@ -512,8 +505,6 @@ void sync_paths(struct multipath *mpp, vector pathvec)
>  	update_mpp_paths(mpp, pathvec);
>  	vector_foreach_slot (mpp->paths, pp, i)
>  		pp->mpp = mpp;
> -	if (mpp->hwe == NULL)
> -		extract_hwe_from_path(mpp);
>  }
>  
>  int
> @@ -689,9 +680,15 @@ struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
>  
>  	conf = get_multipath_config();
>  	mpp->mpe = find_mpe(conf->mptable, pp->wwid);
> -	mpp->hwe = pp->hwe;
>  	put_multipath_config(conf);
>  
> +	/*
> +	 * We need to call this before select_alias(),
> +	 * because that accesses hwe properties.
> +	 */
> +	if (pp->hwe && !set_mpp_hwe(mpp, pp))
> +		goto out;
> +
>  	strcpy(mpp->wwid, pp->wwid);
>  	find_existing_alias(mpp, vecs);
>  	if (select_alias(conf, mpp))
> @@ -742,12 +739,6 @@ int verify_paths(struct multipath *mpp)
>  			vector_del_slot(mpp->paths, i);
>  			i--;
>  
> -			/* Make sure mpp->hwe doesn't point to freed memory.
> -			 * We call extract_hwe_from_path() below to restore
> -			 * mpp->hwe
> -			 */
> -			if (mpp->hwe == pp->hwe)
> -				mpp->hwe = NULL;
>  			/*
>  			 * Don't delete path from pathvec yet. We'll do this
>  			 * after the path has been removed from the map, in
> @@ -759,7 +750,6 @@ int verify_paths(struct multipath *mpp)
>  				mpp->alias, pp->dev, pp->dev_t);
>  		}
>  	}
> -	extract_hwe_from_path(mpp);
>  	return count;
>  }
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index a4abbb2..eedc6c1 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1153,13 +1153,6 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
>  		if (i != -1)
>  			vector_del_slot(mpp->paths, i);
>  
> -		/*
> -		 * Make sure mpp->hwe doesn't point to freed memory
> -		 * We call extract_hwe_from_path() below to restore mpp->hwe
> -		 */
> -		if (mpp->hwe == pp->hwe)
> -			mpp->hwe = NULL;
> -
>  		/*
>  		 * remove the map IF removing the last path
>  		 */
> @@ -1191,9 +1184,6 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
>  			 */
>  		}
>  
> -		if (mpp->hwe == NULL)
> -			extract_hwe_from_path(mpp);
> -
>  		if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
>  			condlog(0, "%s: failed to setup map for"
>  				" removal of path %s", mpp->alias, pp->dev);
> -- 
> 2.28.0
