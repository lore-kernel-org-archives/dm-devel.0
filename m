From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 44/54] libmultipath: adopt_paths(): don't
 bail out on single path failure
Date: Thu, 13 Aug 2020 17:55:05 -0500
Message-ID: <20200813225505.GZ19233@octiron.msp.redhat.com>
References: <20200812113429.26314-1-mwilck@suse.com>
	<20200812113429.26314-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113429.26314-2-mwilck@suse.com>
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

On Wed, Aug 12, 2020 at 01:34:28PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If pathinfo fails for one path to be adopted, we currently
> fail the entire function. This may cause ev_add_path() for a valid
> path to fail because some other path is broken. Fix it by just
> skipping paths that don't look healthy.
> 
> adopt_paths() may now succeed even if some paths couldn't be
> added (e.g. because of pathinfo() failure). If this happens while we are
> trying to add a specific path, we need to check after successful call to
> adopt_paths() if that specific path had been actually added, and fail in the
> caller otherwise.
> 
The changes the patch makes look fine, but right before the first line of the
patch, isn't there a line with

pp->mpp = mpp;

It seems like we should reset this if we don't actually add the path the
the multipath device. But since that bug was already there we can fix it
in a seperate patch, so

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs_vec.c | 17 +++++++++++------
>  multipathd/main.c          |  3 ++-
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index b1f83c6..fb225f1 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -75,16 +75,20 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
>  			if (!mpp->paths && !(mpp->paths = vector_alloc()))
>  				return 1;
>  
> -			if (!find_path_by_devt(mpp->paths, pp->dev_t) &&
> -			    store_path(mpp->paths, pp))
> -					return 1;
>  			conf = get_multipath_config();
>  			pthread_cleanup_push(put_multipath_config, conf);
>  			ret = pathinfo(pp, conf,
>  				       DI_PRIO | DI_CHECKER);
>  			pthread_cleanup_pop(1);
> -			if (ret)
> -				return 1;
> +			if (ret) {
> +				condlog(3, "%s: pathinfo failed for %s",
> +					__func__, pp->dev);
> +				continue;
> +			}
> +
> +			if (!find_path_by_devt(mpp->paths, pp->dev_t) &&
> +			    store_path(mpp->paths, pp))
> +					return 1;
>  		}
>  	}
>  	return 0;
> @@ -456,7 +460,8 @@ struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
>  		goto out;
>  	mpp->size = pp->size;
>  
> -	if (adopt_paths(vecs->pathvec, mpp))
> +	if (adopt_paths(vecs->pathvec, mpp) ||
> +	    find_slot(vecs->pathvec, pp) == -1)
>  		goto out;
>  
>  	if (add_vec) {
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 61929a7..5902e7c 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -956,7 +956,8 @@ rescan:
>  	if (mpp) {
>  		condlog(4,"%s: adopting all paths for path %s",
>  			mpp->alias, pp->dev);
> -		if (adopt_paths(vecs->pathvec, mpp))
> +		if (adopt_paths(vecs->pathvec, mpp) ||
> +		    find_slot(vecs->pathvec, pp) == -1)
>  			goto fail; /* leave path added to pathvec */
>  
>  		verify_paths(mpp, vecs);
> -- 
> 2.28.0
