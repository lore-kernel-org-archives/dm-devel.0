From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 75/78] Push down vector lock during uevent
	processing
Date: Fri, 27 Mar 2015 00:46:41 -0500
Message-ID: <20150327054641.GV29132@octiron.msp.redhat.com>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
	<1426509425-15978-76-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1426509425-15978-76-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 16, 2015 at 01:37:02PM +0100, Hannes Reinecke wrote:
> When adding lots of paths the vector lock which is taken at the
> start of the uevent handler will become a bottleneck as it'll
> compete with the checkerloop.
> So move the vector handling down into the individual event
> handler.

Again, with these changes, there are places in these code paths where
conf is dereferenced without vecs being held, and there's nothing to
keep reconfigure from running at the same time as these functions.

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  multipathd/main.c | 67 +++++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 48 insertions(+), 19 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index ab2a3a7..77a1241 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -279,7 +279,11 @@ uev_add_map (struct uevent * uev, struct vectors * vecs)
>  			return 1;
>  		}
>  	}
> +	pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +	lock(vecs->lock);
> +	pthread_testcancel();
>  	rc = ev_add_map(uev->kernel, alias, vecs);
> +	lock_cleanup_pop(vecs->lock);
>  	FREE(alias);
>  	return rc;
>  }
> @@ -361,6 +365,10 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
>  		return 0;
>  	}
>  	minor = uevent_get_minor(uev);
> +
> +	pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +	lock(vecs->lock);
> +	pthread_testcancel();
>  	mpp = find_mp_by_minor(vecs->mpvec, minor);
>  
>  	if (!mpp) {
> @@ -377,10 +385,12 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
>  	orphan_paths(vecs->pathvec, mpp);
>  	remove_map_and_stop_waiter(mpp, vecs, 1);
>  out:
> +	lock_cleanup_pop(vecs->lock);
>  	FREE(alias);
>  	return 0;
>  }
>  
> +/* Called from CLI handler */
>  int
>  ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
>  {
> @@ -416,6 +426,9 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
>  		return 1;
>  	}
>  
> +	pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +	lock(vecs->lock);
> +	pthread_testcancel();
>  	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
>  	if (pp) {
>  		int r;
> @@ -443,8 +456,15 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
>  				ret = 1;
>  			}
>  		}
> -		return ret;
>  	}
> +	/*
> +	 * The linux implementation of pthread_lock() and pthread_unlock()
> +	 * requires that both must be at the same indentation level,
> +	 * hence the slightly odd coding.
> +	 */
> +	lock_cleanup_pop(vecs->lock);
> +	if (pp)
> +		return ret;
>  
>  	/*
>  	 * get path vital state
> @@ -462,6 +482,9 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
>  		free_path(pp);
>  		return 1;
>  	}
> +	pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +	lock(vecs->lock);
> +	pthread_testcancel();
>  	ret = store_path(vecs->pathvec, pp);
>  	if (!ret) {
>  		pp->checkint = conf->checkint;
> @@ -473,7 +496,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
>  		free_path(pp);
>  		ret = 1;
>  	}
> -
> +	lock_cleanup_pop(vecs->lock);
>  	return ret;
>  }
>  
> @@ -535,12 +558,12 @@ rescan:
>  			 */
>  			start_waiter = 1;
>  		}
> -		else
> +		if (!start_waiter)
>  			goto fail; /* leave path added to pathvec */
>  	}
>  
> -	/* persistent reseravtion check*/
> -	mpath_pr_event_handle(pp);	
> +	/* persistent reservation check*/
> +	mpath_pr_event_handle(pp);
>  
>  	/*
>  	 * push the map to the device-mapper
> @@ -568,7 +591,7 @@ retry:
>  		 * deal with asynchronous uevents :((
>  		 */
>  		if (mpp->action == ACT_RELOAD && retries-- > 0) {
> -			condlog(0, "%s: uev_add_path sleep", mpp->alias);
> +			condlog(0, "%s: ev_add_path sleep", mpp->alias);
>  			sleep(1);
>  			update_mpp_paths(mpp, vecs->pathvec);
>  			goto rescan;
> @@ -597,8 +620,7 @@ retry:
>  		condlog(2, "%s [%s]: path added to devmap %s",
>  			pp->dev, pp->dev_t, mpp->alias);
>  		return 0;
> -	}
> -	else
> +	} else
>  		goto fail;
>  
>  fail_map:
> @@ -612,17 +634,22 @@ static int
>  uev_remove_path (struct uevent *uev, struct vectors * vecs)
>  {
>  	struct path *pp;
> +	int ret;
>  
>  	condlog(2, "%s: remove path (uevent)", uev->kernel);
> +	pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +	lock(vecs->lock);
> +	pthread_testcancel();
>  	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
> -
> +	if (pp)
> +		ret = ev_remove_path(pp, vecs);
> +	lock_cleanup_pop(vecs->lock);
>  	if (!pp) {
>  		/* Not an error; path might have been purged earlier */
>  		condlog(0, "%s: path already removed", uev->kernel);
>  		return 0;
>  	}
> -
> -	return ev_remove_path(pp, vecs);
> +	return ret;
>  }
>  
>  int
> @@ -726,20 +753,27 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
>  
>  	if (ro >= 0) {
>  		struct path * pp;
> +		struct multipath *mpp = NULL;
>  
>  		condlog(2, "%s: update path write_protect to '%d' (uevent)",
>  			uev->kernel, ro);
> +		pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +		lock(vecs->lock);
> +		pthread_testcancel();
>  		pp = find_path_by_dev(vecs->pathvec, uev->kernel);
> +		if (pp)
> +			mpp = pp->mpp;
> +		lock_cleanup_pop(vecs->lock);
>  		if (!pp) {
>  			condlog(0, "%s: spurious uevent, path not found",
>  				uev->kernel);
>  			return 1;
>  		}
> -		if (pp->mpp) {
> -			retval = reload_map(vecs, pp->mpp, 0);
> +		if (mpp) {
> +			retval = reload_map(vecs, mpp, 0);
>  
>  			condlog(2, "%s: map %s reloaded (retval %d)",
> -				uev->kernel, pp->mpp->alias, retval);
> +				uev->kernel, mpp->alias, retval);
>  		}
>  
>  	}
> @@ -823,10 +857,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
>  	if (uev_discard(uev->devpath))
>  		return 0;
>  
> -	pthread_cleanup_push(cleanup_lock, &vecs->lock);
> -	lock(vecs->lock);
> -	pthread_testcancel();
> -
>  	/*
>  	 * device map event
>  	 * Add events are ignored here as the tables
> @@ -865,7 +895,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
>  	}
>  
>  out:
> -	lock_cleanup_pop(vecs->lock);
>  	return r;
>  }
>  
> -- 
> 1.8.4.5
