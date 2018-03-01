From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 19/20] multipathd: use foreign API
Date: Wed, 28 Feb 2018 23:13:06 -0600
Message-ID: <20180301051306.GO14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-20-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180220132658.22295-20-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 20, 2018 at 02:26:57PM +0100, Martin Wilck wrote:
> Call into the foreign library code when paths are discovered, uevents
> are received, and in the checker loop. Furthermore, use the foreign
> code to print information in the "multipathd show paths", "multipathd
> show maps", and "multipathd show topology" client commands.
> 
> We don't support foreign data in the individual "show map" and "show path"
> commands, and neither in the "json" commands. The former is a deliberate
> decision, the latter could be added if desired.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/discovery.c  |  4 +++-
>  multipathd/cli_handlers.c | 39 ++++++++++++++++++++++++++++++++++-----
>  multipathd/main.c         | 43 ++++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 77 insertions(+), 9 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 645224c1029c..45a4d8378893 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -31,6 +31,7 @@
>  #include "prio.h"
>  #include "defaults.h"
>  #include "prioritizers/alua_rtpg.h"
> +#include "foreign.h"
>  
>  int
>  alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
> @@ -1909,7 +1910,8 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
>  	 * limited by DI_BLACKLIST and occurs before this debug
>  	 * message with the mask value.
>  	 */
> -	if (pp->udev && filter_property(conf, pp->udev) > 0)
> +	if (pp->udev && (is_claimed_by_foreign(pp->udev) ||
> +			 filter_property(conf, pp->udev) > 0))
>  		return PATHINFO_SKIPPED;
>  
>  	if (filter_devnode(conf->blist_devnode,
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 78f2a12bc2f8..c0ae54aae841 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -27,6 +27,7 @@
>  #include "main.h"
>  #include "cli.h"
>  #include "uevent.h"
> +#include "foreign.h"
>  
>  int
>  show_paths (char ** r, int * len, struct vectors * vecs, char * style,
> @@ -35,11 +36,13 @@ show_paths (char ** r, int * len, struct vectors * vecs, char * style,
>  	int i;
>  	struct path * pp;
>  	char * c;
> -	char * reply;
> +	char * reply, * header;
>  	unsigned int maxlen = INITIAL_REPLY_LEN;
>  	int again = 1;
>  
>  	get_path_layout(vecs->pathvec, 1);
> +	foreign_path_layout();
> +
>  	reply = MALLOC(maxlen);
>  
>  	while (again) {
> @@ -48,18 +51,29 @@ show_paths (char ** r, int * len, struct vectors * vecs, char * style,
>  
>  		c = reply;
>  
> -		if (pretty && VECTOR_SIZE(vecs->pathvec) > 0)
> +		if (pretty)
>  			c += snprint_path_header(c, reply + maxlen - c,
>  						 style);
> +		header = c;
>  
>  		vector_foreach_slot(vecs->pathvec, pp, i)
>  			c += snprint_path(c, reply + maxlen - c,
>  					  style, pp, pretty);
>  
> +		c += snprint_foreign_paths(c, reply + maxlen - c,
> +					   style, pretty);
> +
>  		again = ((c - reply) == (maxlen - 1));
>  
>  		REALLOC_REPLY(reply, again, maxlen);
>  	}
> +
> +	if (pretty && c == header) {
> +		/* No output - clear header */
> +		*reply = '\0';
> +		c = reply;
> +	}
> +
>  	*r = reply;
>  	*len = (int)(c - reply + 1);
>  	return 0;
> @@ -134,6 +148,8 @@ show_maps_topology (char ** r, int * len, struct vectors * vecs)
>  	int again = 1;
>  
>  	get_path_layout(vecs->pathvec, 0);
> +	foreign_path_layout();
> +
>  	reply = MALLOC(maxlen);
>  
>  	while (again) {
> @@ -150,11 +166,13 @@ show_maps_topology (char ** r, int * len, struct vectors * vecs)
>  			c += snprint_multipath_topology(c, reply + maxlen - c,
>  							mpp, 2);
>  		}
> +		c += snprint_foreign_topology(c, reply + maxlen - c, 2);
>  
>  		again = ((c - reply) == (maxlen - 1));
>  
>  		REALLOC_REPLY(reply, again, maxlen);
>  	}
> +
>  	*r = reply;
>  	*len = (int)(c - reply + 1);
>  	return 0;
> @@ -499,12 +517,14 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style,
>  {
>  	int i;
>  	struct multipath * mpp;
> -	char * c;
> +	char * c, *header;
>  	char * reply;
>  	unsigned int maxlen = INITIAL_REPLY_LEN;
>  	int again = 1;
>  
>  	get_multipath_layout(vecs->mpvec, 1);
> +	foreign_multipath_layout();
> +
>  	reply = MALLOC(maxlen);
>  
>  	while (again) {
> @@ -512,9 +532,10 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style,
>  			return 1;
>  
>  		c = reply;
> -		if (pretty && VECTOR_SIZE(vecs->mpvec) > 0)
> +		if (pretty)
>  			c += snprint_multipath_header(c, reply + maxlen - c,
>  						      style);
> +		header = c;
>  
>  		vector_foreach_slot(vecs->mpvec, mpp, i) {
>  			if (update_multipath(vecs, mpp->alias, 0)) {
> @@ -523,12 +544,20 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style,
>  			}
>  			c += snprint_multipath(c, reply + maxlen - c,
>  					       style, mpp, pretty);
> -		}
>  
> +		}
> +		c += snprint_foreign_multipaths(c, reply + maxlen - c,
> +						style, pretty);
>  		again = ((c - reply) == (maxlen - 1));
>  
>  		REALLOC_REPLY(reply, again, maxlen);
>  	}
> +
> +	if (pretty && c == header) {
> +		/* No output - clear header */
> +		*reply = '\0';
> +		c = reply;
> +	}
>  	*r = reply;
>  	*len = (int)(c - reply + 1);
>  	return 0;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index b900bb3ec2e3..e1d98861a841 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -84,6 +84,7 @@ static int use_watchdog;
>  #include "waiter.h"
>  #include "io_err_stat.h"
>  #include "wwids.h"
> +#include "foreign.h"
>  #include "../third-party/valgrind/drd.h"
>  
>  #define FILE_NAME_SIZE 256
> @@ -699,6 +700,15 @@ rescan:
>  		mpp->action = ACT_RELOAD;
>  		extract_hwe_from_path(mpp);
>  	} else {
> +		switch (add_foreign(pp->udev)) {

There's a rather convoluted issue here. This function will eventually
call _find_slaves() in the nvme code, which calls glob(), which isn't
strictly multithreading safe for a number of reasons. The only one that
effects multipathd is its use of SIGALRM. Now assuming signal processing
worked correctly in multipathd (it doesn't. commit 534ec4c broke it. I'm
planning on fixing that shortly) there would still be a problem, because
of the strict_timing option.  strict_timing calls setitimer(), which
sets an alarm in checkerloop, without any locking.  strict_timing also
messes with any call to lock_file(). lock_file() and _find_slaves() will
never interfere with eachother, since both are only called with the vecs
lock held (I think. See below). strict_timing probably needs to get
reimplemented using nanosleep() or some other non-signal method, so that
there aren't two threads setting alarms and waiting for SIGARLM at the
same time.

> +		case FOREIGN_CLAIMED:
> +		case FOREIGN_OK:
> +			orphan_path(pp, "claimed by foreign library");
> +			return 0;
> +		default:
> +			break;

Is there a purpose to this break?


> +		}
> +
>  		if (!should_multipath(pp, vecs->pathvec)) {
>  			orphan_path(pp, "only one path");
>  			return 0;
> @@ -798,6 +808,8 @@ uev_remove_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
>  	int ret;
>  
>  	condlog(2, "%s: remove path (uevent)", uev->kernel);
> +	delete_foreign(uev->udev);
> +
>  	pthread_cleanup_push(cleanup_lock, &vecs->lock);
>  	lock(&vecs->lock);
>  	pthread_testcancel();
> @@ -917,12 +929,27 @@ fail:
>  static int
>  uev_update_path (struct uevent *uev, struct vectors * vecs)
>  {
> -	int ro, retval = 0;
> +	int ro, retval = 0, rc;
>  	struct path * pp;
>  	struct config *conf;
>  	int disable_changed_wwids;
>  	int needs_reinit = 0;
>  
> +	switch ((rc = change_foreign(uev->udev))) {
> +	case FOREIGN_OK:
> +		/* known foreign path, ignore event */
> +		return 0;
> +	case FOREIGN_IGNORED:
> +		break;
> +	case FOREIGN_ERR:
> +		condlog(3, "%s: error in change_foreign", __func__);
> +		break;
> +	default:
> +		condlog(1, "%s: return code %d of change_forein is unsupported",
> +			__func__, rc);
> +		break;
> +	}
> +
>  	conf = get_multipath_config();
>  	disable_changed_wwids = conf->disable_changed_wwids;
>  	put_multipath_config(conf);
> @@ -1122,8 +1149,13 @@ uev_trigger (struct uevent * uev, void * trigger_data)
>  	 * are not fully initialised then.
>  	 */
>  	if (!strncmp(uev->kernel, "dm-", 3)) {
> -		if (!uevent_is_mpath(uev))
> +		if (!uevent_is_mpath(uev)) {
> +			if (!strncmp(uev->action, "change", 6))
> +				(void)add_foreign(uev->udev);
> +			else if (!strncmp(uev->action, "remove", 6))
> +				(void)delete_foreign(uev->udev);
>  			goto out;
> +		}

I'm confused. Should foreign maps ever have uev->kernel set to "dm-"?
If this is correct, these calls probably need to get called with the
vecs lock held, otherwise they can interfere with calls to lock_file().

-Ben

>  		if (!strncmp(uev->action, "change", 6)) {
>  			r = uev_add_map(uev, vecs);
>  
> @@ -1932,7 +1964,7 @@ checkerloop (void *ap)
>  						diff_time.tv_sec);
>  			}
>  		}
> -
> +		check_foreign();
>  		post_config_state(DAEMON_IDLE);
>  		conf = get_multipath_config();
>  		strict_timing = conf->strict_timing;
> @@ -2121,6 +2153,7 @@ reconfigure (struct vectors * vecs)
>  
>  	free_pathvec(vecs->pathvec, FREE_PATHS);
>  	vecs->pathvec = NULL;
> +	delete_all_foreign();
>  
>  	/* Re-read any timezone changes */
>  	tzset();
> @@ -2372,6 +2405,9 @@ child (void * param)
>  		condlog(0, "failed to initialize prioritizers");
>  		goto failed;
>  	}
> +	/* Failing this is non-fatal */
> +
> +	init_foreign(conf->multipath_dir);
>  
>  	setlogmask(LOG_UPTO(conf->verbosity + 3));
>  
> @@ -2529,6 +2565,7 @@ child (void * param)
>  	FREE(vecs);
>  	vecs = NULL;
>  
> +	cleanup_foreign();
>  	cleanup_checkers();
>  	cleanup_prio();
>  
> -- 
> 2.16.1
