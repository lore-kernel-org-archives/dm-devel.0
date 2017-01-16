From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 04/11] multipathd: add need_do_map to
 indicate whether need calling domap() in ev_add_path()
Date: Mon, 16 Jan 2017 15:38:29 -0600
Message-ID: <20170116213829.GV2732@octiron.msp.redhat.com>
References: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
	<1484200347-11188-5-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1484200347-11188-5-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: tang.wenjun3@zte.com.cn, zhang.kai16@zte.com.cn, dm-devel@redhat.com, bart.vanassche@sandisk.com, mwilck@suse.com
List-Id: dm-devel.ids

On Thu, Jan 12, 2017 at 01:52:20PM +0800, tang.junhui@zte.com.cn wrote:
> From: tang.junhui <tang.junhui@zte.com.cn>
> 
> Usually calling domap() in ev_add_path() is needed, but only last path
> need to call domap() in processing for merged uevents to reduce the
> count of calling domap() and promote efficiency. So add input parameter
> need_do_map to indicate whether need calling domap() in ev_add_path().

With the addition of checking if the merge_id equals the wwid, you are
protected against accidentially merging paths that shouldn't be merged,
which is great.  But setting need_do_map for these paths doesn't
completely make sure that if the wwid and merge_id differ, you will
always call domap.

A contrived situation where this fails would look like:

add path1, path2, path3

where merge_id equals the wwid for path1 and path2, but there is a
different wwid for path3.  In this case, you would call domap on just
the multipath device for path3, but since path1 and path2 matched the
merge_id, they wouldn't force a call to domap.

A less contrived example would be

add path1, path2, path3, path4

Where these were devices that were actually pointing at two different
LUNs, but all set ID_SERIAL the same. path1 and path2 pointed to one
LUN, while path3 and path4 pointed to another LUN.  In this case the
wwid of path1 and path2 matched the merge_id, while the wwid of path3
and path4 was different. In this case you would call domap twice, on
both path3 and path4, but nothing would call domap to create a multipath
device for path1 and path2.

In general, the code to set need_do_map if the wwid and merge_id don't
match only works if either none of the device in a merged set have wwids
that match the merge_id, or if the last device has a wwid that matches
the merge_id. If there are devices with wwids that match the merge_id,
but the last device in the set isn't one of them, then some devices will
not get a multipath device created for them.

Now, I don't know of any device that works like my above example, so
your code will likely work fine for all real-world devices.  Also,
fixing this is a pain, as you don't find out until processing the last
path in a set that things went wrong, and then you would have to go back
and run the skipped functions on one of the paths you have already
processed.

The easy way to fix it is to use the other possibility that I mentioned
before, which is to not have the merge_id, and just use the udev
provided wwid, instead of fetching it from pathinfo.  Like I mentioned,
if you do this, you want to make sure that you only try to grab the wwid
from the udev events for devices with the correct kernel name: ID_SERIAL
only for "sd.*" devices, and ID_UID only for "dasd.*" devices. I also
think that this should be configurable.

Otherwise, you can either go through the messy work of calling domap
correctly when the last device of a set has a wwid that doesn't match
the merge_id, or we can decide that this won't acutally cause problems
with any known device, and punt fixing it for now. And if it causes
problems with some future devices, we can deal with it then.

-Ben

> 
> Change-Id: I7f33de49a1d89d91180dcb95cd94e4944ae7ff36
> Signed-off-by: tang.wenjun <tang.wenjun3@zte.com.cn>
> ---
>  multipathd/cli_handlers.c |  3 ++-
>  multipathd/main.c         | 47 ++++++++++++++++++++++++++++++++++++-----------
>  multipathd/main.h         |  2 +-
>  3 files changed, 39 insertions(+), 13 deletions(-)
> 
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index b0eeca6..3a46c09 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -670,7 +670,8 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
>  		pp->checkint = conf->checkint;
>  	}
>  	put_multipath_config(conf);
> -	return ev_add_path(pp, vecs);
> +	return ev_add_path(pp, vecs, 1);
> +
>  blacklisted:
>  	*reply = strdup("blacklisted\n");
>  	*len = strlen(*reply) + 1;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index adc3258..ebd7de1 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -608,7 +608,7 @@ ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
>  }
>  
>  static int
> -uev_add_path (struct uevent *uev, struct vectors * vecs)
> +uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
>  {
>  	struct path *pp;
>  	int ret = 0, i;
> @@ -640,9 +640,18 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
>  			r = pathinfo(pp, conf,
>  				     DI_ALL | DI_BLACKLIST);
>  			put_multipath_config(conf);
> -			if (r == PATHINFO_OK)
> -				ret = ev_add_path(pp, vecs);
> -			else if (r == PATHINFO_SKIPPED) {
> +			if (r == PATHINFO_OK) {
> +				/*
> +				 * Make sure merging use the correct wwid
> +				 * Othterwise calling domap()
> +				 */
> +				if (!need_do_map &&
> +				    uev->merge_id &&
> +				    strcmp(uev->merge_id, pp->wwid))
> +					need_do_map = 1;
> +
> +				ret = ev_add_path(pp, vecs, need_do_map);
> +			} else if (r == PATHINFO_SKIPPED) {
>  				condlog(3, "%s: remove blacklisted path",
>  					uev->kernel);
>  				i = find_slot(vecs->pathvec, (void *)pp);
> @@ -681,7 +690,16 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
>  		conf = get_multipath_config();
>  		pp->checkint = conf->checkint;
>  		put_multipath_config(conf);
> -		ret = ev_add_path(pp, vecs);
> +		/*
> +		 * Make sure merging use the correct wwid
> +		 * Othterwise calling domap()
> +		 */
> +		if (!need_do_map &&
> +		    uev->merge_id &&
> +		    strcmp(uev->merge_id, pp->wwid))
> +			need_do_map = 1;
> +
> +		ret = ev_add_path(pp, vecs, need_do_map);
>  	} else {
>  		condlog(0, "%s: failed to store path info, "
>  			"dropping event",
> @@ -699,7 +717,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
>   * 1: error
>   */
>  int
> -ev_add_path (struct path * pp, struct vectors * vecs)
> +ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
>  {
>  	struct multipath * mpp;
>  	char params[PARAMS_SIZE] = {0};
> @@ -767,6 +785,13 @@ rescan:
>  	/* persistent reservation check*/
>  	mpath_pr_event_handle(pp);
>  
> +	if (!need_do_map)
> +		return 0;
> +
> +	if (!dm_map_present(mpp->alias)) {
> +		mpp->action = ACT_CREATE;
> +		start_waiter = 1;
> +	}
>  	/*
>  	 * push the map to the device-mapper
>  	 */
> @@ -995,7 +1020,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
>  		}
>  
>  		if (pp->initialized == INIT_REQUESTED_UDEV)
> -			retval = uev_add_path(uev, vecs);
> +			retval = uev_add_path(uev, vecs, 1);
>  		else if (mpp && ro >= 0) {
>  			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
>  
> @@ -1150,7 +1175,7 @@ uev_trigger (struct uevent * uev, void * trigger_data)
>  	put_multipath_config(conf);
>  
>  	if (!strncmp(uev->action, "add", 3)) {
> -		r = uev_add_path(uev, vecs);
> +		r = uev_add_path(uev, vecs, 1);
>  		goto out;
>  	}
>  	if (!strncmp(uev->action, "remove", 6)) {
> @@ -1570,7 +1595,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  			conf = get_multipath_config();
>  			ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
>  			if (ret == PATHINFO_OK) {
> -				ev_add_path(pp, vecs);
> +				ev_add_path(pp, vecs, 1);
>  				pp->tick = 1;
>  			} else if (ret == PATHINFO_SKIPPED) {
>  				put_multipath_config(conf);
> @@ -1686,7 +1711,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  		}
>  		if (!disable_reinstate && reinstate_path(pp, add_active)) {
>  			condlog(3, "%s: reload map", pp->dev);
> -			ev_add_path(pp, vecs);
> +			ev_add_path(pp, vecs, 1);
>  			pp->tick = 1;
>  			return 0;
>  		}
> @@ -1709,7 +1734,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  			/* Clear IO errors */
>  			if (reinstate_path(pp, 0)) {
>  				condlog(3, "%s: reload map", pp->dev);
> -				ev_add_path(pp, vecs);
> +				ev_add_path(pp, vecs, 1);
>  				pp->tick = 1;
>  				return 0;
>  			}
> diff --git a/multipathd/main.h b/multipathd/main.h
> index f72580d..f810d41 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -22,7 +22,7 @@ void exit_daemon(void);
>  const char * daemon_status(void);
>  int need_to_delay_reconfig (struct vectors *);
>  int reconfigure (struct vectors *);
> -int ev_add_path (struct path *, struct vectors *);
> +int ev_add_path (struct path *, struct vectors *, int);
>  int ev_remove_path (struct path *, struct vectors *);
>  int ev_add_map (char *, char *, struct vectors *);
>  int ev_remove_map (char *, char *, int, struct vectors *);
> -- 
> 2.8.1.windows.1
> 
