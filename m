From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 10/20] libmultipath: indicate wwid failure
 in dm_addmap_create()
Date: Mon, 26 Mar 2018 12:52:28 -0500
Message-ID: <20180326175228.GO3103@octiron.msp.redhat.com>
References: <20180319150155.5363-1-mwilck@suse.com>
	<20180319150155.5363-11-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180319150155.5363-11-mwilck@suse.com>
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

On Mon, Mar 19, 2018 at 04:01:45PM +0100, Martin Wilck wrote:
> dm_addmap_create() is where we actually try to set up a new
> multipath map. Depending on the result, mark the wwid as
> failed (or not), and re-trigger an uevent if necessary.
> If a path changes from multipath to non-multipath, use an "add"
> event to make sure LVM2 rules pick it up. Increase log level
> of this event to 3.

I'm not sure of a specific problem with this patch, but I am a little
leery of sending out our own "add" events. Unless I am mistaken there is
usually there is only one add event per device, and there is extra work
done on add events that we might not want to do twice. I wonder if it
would be better to make other udev rules be able to respond to change
events from ex-multipath paths.  Have you looked into the implications
of sending out these add events?

-Ben

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c | 37 ++++++++++++++++++++++++++++---------
>  libmultipath/configure.h |  2 +-
>  libmultipath/devmapper.c |  8 +++++++-
>  libmultipath/structs.h   |  1 +
>  multipathd/main.c        |  2 +-
>  5 files changed, 38 insertions(+), 12 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 838d145a5aa2..88e6687849f8 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -443,11 +443,18 @@ trigger_udev_change(const struct multipath *mpp)
>  }
>  
>  void
> -trigger_paths_udev_change(const struct multipath *mpp)
> +trigger_paths_udev_change(struct multipath *mpp, bool is_mpath)
>  {
>  	struct pathgroup * pgp;
>  	struct path * pp;
>  	int i, j;
> +	/*
> +	 * If a path changes from multipath to non-multipath, we must
> +	 * synthesize an artificial "add" event, otherwise the LVM2 rules
> +	 * (69-lvm2-lvmetad.rules) won't pick it up. Otherwise, we'd just
> +	 * irritate ourselves with an "add", so use "change".
> +	 */
> +	const char *action = is_mpath ? "change" : "add";
>  
>  	if (!mpp || !mpp->pg)
>  		return;
> @@ -466,14 +473,21 @@ trigger_paths_udev_change(const struct multipath *mpp)
>  			 */
>  			env = udev_device_get_property_value(
>  				pp->udev, "DM_MULTIPATH_DEVICE_PATH");
> -			if (env != NULL && !strcmp(env, "1"))
> -					continue;
>  
> -			condlog(4, "triggering change uevent for %s", pp->dev);
> -			sysfs_attr_set_value(pp->udev, "uevent", "change",
> -					     strlen("change"));
> +			if (is_mpath && env != NULL && !strcmp(env, "1"))
> +				continue;
> +			else if (!is_mpath &&
> +				   (env == NULL || !strcmp(env, "0")))
> +				continue;
> +
> +			condlog(3, "triggering %s uevent for %s (is %smultipath member)",
> +				action, pp->dev, is_mpath ? "" : "no ");
> +			sysfs_attr_set_value(pp->udev, "uevent",
> +					     action, strlen(action));
>  		}
>  	}
> +
> +	mpp->needs_paths_uevent = 0;
>  }
>  
>  static int
> @@ -870,8 +884,10 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
>  		 * succeeded
>  		 */
>  		mpp->force_udev_reload = 0;
> -		if (mpp->action == ACT_CREATE && remember_wwid(mpp->wwid) == 1)
> -			trigger_paths_udev_change(mpp);
> +		if (mpp->action == ACT_CREATE &&
> +		    (remember_wwid(mpp->wwid) == 1 ||
> +		     mpp->needs_paths_uevent))
> +			trigger_paths_udev_change(mpp, true);
>  		if (!is_daemon) {
>  			/* multipath client mode */
>  			dm_switchgroup(mpp->alias, mpp->bestpg);
> @@ -896,7 +912,10 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
>  		}
>  		dm_setgeometry(mpp);
>  		return DOMAP_OK;
> -	}
> +	} else if (r == DOMAP_FAIL && mpp->action == ACT_CREATE &&
> +		   mpp->needs_paths_uevent)
> +		trigger_paths_udev_change(mpp, false);
> +
>  	return DOMAP_FAIL;
>  }
>  
> diff --git a/libmultipath/configure.h b/libmultipath/configure.h
> index 545cbc209793..8b56d33a1d0b 100644
> --- a/libmultipath/configure.h
> +++ b/libmultipath/configure.h
> @@ -37,4 +37,4 @@ int get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
>  		 vector pathvec, char **wwid);
>  int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon);
>  struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type);
> -void trigger_paths_udev_change(const struct multipath *mpp);
> +void trigger_paths_udev_change(struct multipath *mpp, bool is_mpath);
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 9bafbc6a239a..bd595f4fa40b 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -22,6 +22,7 @@
>  #include "devmapper.h"
>  #include "sysfs.h"
>  #include "config.h"
> +#include "wwids.h"
>  
>  #include "log_pthread.h"
>  #include <sys/types.h>
> @@ -411,8 +412,11 @@ int dm_addmap_create (struct multipath *mpp, char * params)
>  		int err;
>  
>  		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro,
> -			      udev_flags))
> +			      udev_flags)) {
> +			if (unmark_failed_wwid(mpp->wwid) == 1)
> +				mpp->needs_paths_uevent = 1;
>  			return 1;
> +		}
>  		/*
>  		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
>  		 * Failing the second part leaves an empty map. Clean it up.
> @@ -428,6 +432,8 @@ int dm_addmap_create (struct multipath *mpp, char * params)
>  			break;
>  		}
>  	}
> +	if (mark_failed_wwid(mpp->wwid) == 1)
> +		mpp->needs_paths_uevent = 1;
>  	return 0;
>  }
>  
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index d6482f84f0e6..32f4b2d0696c 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -322,6 +322,7 @@ struct multipath {
>  	int max_sectors_kb;
>  	int force_readonly;
>  	int force_udev_reload;
> +	int needs_paths_uevent;
>  	int ghost_delay;
>  	int ghost_delay_tick;
>  	unsigned int dev_loss;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index bfbe5f66b324..ea8c413f28c6 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2310,7 +2310,7 @@ configure (struct vectors * vecs)
>  	sync_maps_state(mpvec);
>  	vector_foreach_slot(mpvec, mpp, i){
>  		if (remember_wwid(mpp->wwid) == 1)
> -			trigger_paths_udev_change(mpp);
> +			trigger_paths_udev_change(mpp, true);
>  		update_map_pr(mpp);
>  	}
>  
> -- 
> 2.16.1
