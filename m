From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 65/74] libmultipath: add
	update_pathvec_from_dm()
Date: Fri, 14 Aug 2020 00:08:25 -0500
Message-ID: <20200814050825.GE19233@octiron.msp.redhat.com>
References: <20200812113511.26469-1-mwilck@suse.com>
	<20200812113511.26469-7-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113511.26469-7-mwilck@suse.com>
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

On Wed, Aug 12, 2020 at 01:35:09PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> It can happen in particular during boot or startup that we encounter
> paths as map members which haven't been discovered or fully initialized
> yet, and are thus not in the pathvec. These paths need special treatment
> in various ways. Currently this is dealt with in disassemble_map(). That's
> a layer violation, and the way it is done is suboptimal in various ways.
> 
> As a preparation to change that, this patch introduces a new function,
> update_pathvec_from_dm(), that is supposed to deal with newly discovered
> paths from disassemble_map(). It has to be called after disassemble_map()
> has finished.
> 
> The logic of the new function is similar but not identical to what
> disassemble_map() was doing before. Firstly, the function will simply
> remove path devices that don't exist - there's no point in carrying these
> around. Map reloads can't be called from this code for reasons of the
> overall program logic. But it's prepared to signal to the caller that
> a map reload is in order. Using this return value will be future work.
> 
> Second, pathinfo() is now called on new paths rather than just setting
> pp->dev. The pathinfo flags can be passed as argument to make the function
> flexible for different callers.
> 
> Finally, treatment of WWIDs is different now. There'll be only one attempt
> at guessing the map WWID if it's not set yet. If a non-matching path WWID
> is found, the path is removed, and a new uevent triggered (this is the
> most important change wrt the dangerous previous code that would simply
> overwrite the path WWID). If the path WWID is empty, it will still be
> set from the map WWID, which I consider not perfect, but no worse
> than what we did before.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs_vec.c | 136 +++++++++++++++++++++++++++++++++++++
>  libmultipath/structs_vec.h |   2 +
>  2 files changed, 138 insertions(+)
> 
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index b644d3f..bd2d13b 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -59,6 +59,142 @@ int update_mpp_paths(struct multipath *mpp, vector pathvec)
>  	return store_failure;
>  }
>  
> +static bool guess_mpp_wwid(struct multipath *mpp)
> +{
> +	int i, j;
> +	struct pathgroup *pgp;
> +	struct path *pp;
> +
> +	if (strlen(mpp->wwid) || !mpp->pg)
> +		return true;
> +
> +	vector_foreach_slot(mpp->pg, pgp, i) {
> +		if (!pgp->paths)
> +			continue;
> +		vector_foreach_slot(pgp->paths, pp, j) {
> +			if (pp->initialized == INIT_OK && strlen(pp->wwid)) {
> +				strlcpy(mpp->wwid, pp->wwid, sizeof(mpp->wwid));
> +				condlog(2, "%s: guessed WWID %s from path %s",
> +					mpp->alias, mpp->wwid, pp->dev);
> +				return true;
> +			}
> +		}
> +	}
> +	condlog(1, "%s: unable to guess WWID", mpp->alias);
> +	return false;
> +}
> +
> +/*
> + * update_pathvec_from_dm() - update pathvec after disassemble_map()
> + *
> + * disassemble_map() may return block devices that are members in
> + * multipath maps but haven't been discovered. Check whether they
> + * need to be added to pathvec or discarded.
> + *
> + * Returns: true if immediate map reload is desirable
> + *
> + * Side effects:
> + * - may delete non-existing paths and empty pathgroups from mpp
> + * - may set pp->wwid and / or mpp->wwid
> + * - calls pathinfo() on existing paths is pathinfo_flags is not 0
> + */
> +bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
> +	int pathinfo_flags)
> +{
> +	int i, j;
> +	struct pathgroup *pgp;
> +	struct path *pp;
> +	struct config *conf;
> +	bool mpp_has_wwid;
> +	bool must_reload = false;
> +
> +	if (!mpp->pg)
> +		return false;
> +
> +	/*
> +	 * This will initialize mpp->wwid with an educated guess,
> +	 * either from the dm uuid or from a member path with properly
> +	 * determined WWID.
> +	 */
> +	mpp_has_wwid = guess_mpp_wwid(mpp);
> +
> +	vector_foreach_slot(mpp->pg, pgp, i) {
> +		if (!pgp->paths)
> +			goto delete_pg;
> +
> +		vector_foreach_slot(pgp->paths, pp, j) {
> +			pp->mpp = mpp;
> +
> +			/*
> +			 * The way disassemble_map() works: If it encounters a
> +			 * path device which isn't found in pathvec, it adds an
> +			 * uninitialized struct path to pgp->paths, with only
> +			 * pp->dev_t filled in. Thus if pp->udev is set here,
> +			 * we know that the path is in pathvec already.
> +			 */
> +			if (pp->udev) {
> +				if (pathinfo_flags) {
> +					conf = get_multipath_config();
> +					pthread_cleanup_push(put_multipath_config,
> +							     conf);
> +					pathinfo(pp, conf, pathinfo_flags);
> +					pthread_cleanup_pop(1);
> +				}
> +				continue;
> +			}
> +
> +			/* If this fails, the device is not in sysfs */
> +			pp->udev = get_udev_device(pp->dev_t, DEV_DEVT);
> +			if (!pp->udev) {
> +				condlog(2, "%s: discarding non-existing path %s",
> +					mpp->alias, pp->dev_t);
> +				vector_del_slot(pgp->paths, j--);
> +				free_path(pp);
> +				must_reload = true;
> +			} else {
> +				int rc;
> +
> +				devt2devname(pp->dev, sizeof(pp->dev),
> +					     pp->dev_t);
> +				conf = get_multipath_config();
> +				pthread_cleanup_push(put_multipath_config,
> +						     conf);
> +				pp->checkint = conf->checkint;
> +				rc = pathinfo(pp, conf,
> +					      DI_SYSFS|DI_WWID|DI_BLACKLIST|
> +					      pathinfo_flags);
> +				pthread_cleanup_pop(1);
> +				if (rc != PATHINFO_OK) {
> +					condlog(1, "%s: error %d in pathinfo, discarding path",
> +						pp->dev, rc);
> +					vector_del_slot(pgp->paths, j--);
> +					free_path(pp);
> +					must_reload = true;
> +				} else {
> +					if (mpp_has_wwid && !strlen(pp->wwid)) {
> +						condlog(3, "%s: setting wwid from map: %s",
> +							pp->dev, mpp->wwid);
> +						strlcpy(pp->wwid, mpp->wwid,
> +							sizeof(pp->wwid));
> +					}
> +					condlog(2, "%s: adding new path %s",
> +						mpp->alias, pp->dev);
> +					store_path(pathvec, pp);
> +					pp->tick = 1;
> +				}
> +			}
> +		}
> +		if (VECTOR_SIZE(pgp->paths) != 0)
> +			continue;
> +	delete_pg:
> +		condlog(2, "%s: removing empty pathgroup %d", mpp->alias, i);
> +		vector_del_slot(mpp->pg, i--);
> +		free_pathgroup(pgp, KEEP_PATHS);
> +		must_reload = true;
> +	}
> +	return must_reload;
> +}
> +
>  int adopt_paths(vector pathvec, struct multipath *mpp)
>  {
>  	int i, ret;
> diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
> index d7dfe32..6c79069 100644
> --- a/libmultipath/structs_vec.h
> +++ b/libmultipath/structs_vec.h
> @@ -21,6 +21,8 @@ void orphan_path (struct path * pp, const char *reason);
>  void set_path_removed(struct path *pp);
>  
>  int verify_paths(struct multipath *mpp);
> +bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
> +			    int pathinfo_flags);
>  int update_mpp_paths(struct multipath * mpp, vector pathvec);
>  int update_multipath_strings (struct multipath *mpp, vector pathvec,
>  			      int is_daemon);
> -- 
> 2.28.0
