From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 65/74] libmultipath: add
	update_pathvec_from_dm()
Date: Sat, 18 Jul 2020 23:46:45 -0500
Message-ID: <20200719044645.GV11089@octiron.msp.redhat.com>
References: <20200709105145.9211-1-mwilck@suse.com>
	<20200709105145.9211-13-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-13-mwilck@suse.com>
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

On Thu, Jul 09, 2020 at 12:51:36PM +0200, mwilck@suse.com wrote:
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

I don't really understand the reason for adding paths to pathvec, just
because they appear in disassemble_map(). If multipathd sees a map with
a path that it doesn't have in pathvec, then that path should either
sortly appear, or multipathd likely doesn't have it for a reason.  I
agree that it's possible that uevent got missed, but it seems more
likely that the user updated multipath.conf and hasn't reconfigured
multipathd. 

Maybe when I read future patches this will make more sense, but can't
multipathd add paths to the pathvec that it is configured to blacklist.
I would like to think that multipathd is definitive for the multipath
devices that it controls.  If multipathd doesn't think a path belongs in
a multipath device, then the path doesn't belong in the multipath
device. There are corner cases where a path can appear in a multipath
device before multipathd gets notified about the path, but they all seem
pretty rare. Someone running "multipath" before multipathd has seen the
path addition uevent, for instance. Perhaps if pathinfo() should always
set DI_BLACKLIST, and if the path is skipped, flag the device for
reloading.
 
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
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs_vec.c | 134 +++++++++++++++++++++++++++++++++++++
>  libmultipath/structs_vec.h |   2 +
>  2 files changed, 136 insertions(+)
> 
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 1e0f109..5dd37d5 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -59,6 +59,140 @@ int update_mpp_paths(struct multipath *mpp, vector pathvec)
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
> +	mpp_has_wwid = guess_mpp_wwid(mpp);
> +
> +	vector_foreach_slot(mpp->pg, pgp, i) {
> +		if (!pgp->paths)
> +			goto delete_pg;
> +
> +		vector_foreach_slot(pgp->paths, pp, j) {
> +			pp->mpp = mpp;
> +
> +			if (pp->udev) {
> +				if (pathinfo_flags) {
> +					conf = get_multipath_config();
> +					pthread_cleanup_push(put_multipath_config,
> +							     conf);
> +					pathinfo(pp, conf, pathinfo_flags);
> +					pthread_cleanup_pop(1);
> +				}
> +				continue;

I suppose that if pp->udev is set then the path is in pathvec, but the
lack of check seemed odd to me. 

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
> +
> +				devt2devname(pp->dev, sizeof(pp->dev),
> +					     pp->dev_t);
> +				conf = get_multipath_config();
> +				pthread_cleanup_push(put_multipath_config,
> +						     conf);
> +				pp->checkint = conf->checkint;
> +				if (pathinfo(pp, conf,
> +					     DI_SYSFS|DI_WWID|pathinfo_flags)
> +				    != PATHINFO_OK)
> +					condlog(1, "%s: error in pathinfo",
> +						pp->dev);

This seems wrong to me.  A blacklisted path shouldn't be added to
pathvec.

> +				pthread_cleanup_pop(1);
> +				if (mpp_has_wwid && !strlen(pp->wwid)) {
> +					condlog(3, "%s: setting wwid from map: %s",
> +						pp->dev, mpp->wwid);
> +					strlcpy(pp->wwid, mpp->wwid,
> +						sizeof(pp->wwid));
> +				} else if (mpp_has_wwid &&
> +					   strcmp(mpp->wwid, pp->wwid)) {
> +
> +					condlog(0, "%s: path %s WWID %s doesn't match, removing from map",
> +						mpp->wwid, pp->dev_t, pp->wwid);
> +					/*
> +					 * This path exists, but in the wong map.
> +					 * We can't reload the map from here.
> +					 * Instead, treat this path like "missing udev",
> +					 * which it probably is.
> +					 * check_path() will trigger an uevent
> +					 * and reset pp->tick.
> +					 */
> +					must_reload = true;
> +					pp->mpp = NULL;
> +					dm_fail_path(mpp->alias, pp->dev_t);
> +					vector_del_slot(pgp->paths, j--);
> +					pp->initialized = INIT_MISSING_UDEV;
> +					pp->tick = 1;
> +				}
> +				condlog(2, "%s: adding new path %s",
> +					mpp->alias, pp->dev);
> +				store_path(pathvec, pp);
> +			}
> +		}
> +		if (VECTOR_SIZE(pgp->paths) != 0)
> +			continue;
> +	delete_pg:
> +		condlog(2, "%s: removing empty pathgroup %d", mpp->alias, i);
> +		vector_del_slot(mpp->pg, i--);
> +		free_pathgroup(pgp, KEEP_PATHS);

Should this flag the device for reloading, to remove the useless path
group?

> +	}
> +	return must_reload;
> +}
> +
>  int adopt_paths(vector pathvec, struct multipath *mpp)
>  {
>  	int i, ret;
> diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
> index cd3ef76..4c28148 100644
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
> 2.26.2
