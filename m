From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 15/33] libmultipath: move suspend logic to
 _dm_flush_map
Date: Wed, 5 Apr 2017 17:44:02 -0500
Message-ID: <20170405224402.GI19236@octiron.msp.redhat.com>
References: <20170228162329.14517-1-mwilck@suse.com>
	<20170228162329.14517-16-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170228162329.14517-16-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 28, 2017 at 05:23:11PM +0100, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.de>
> 
> The function dm_suspend_and_flush() introduced in 9a4ff93
> tries to remove child maps (partitions) after suspending
> the mpath device. This may lock up if removing the partitions
> requires I/O. It's better to use the following sequence
> of actions: 1) clear queue_if_no_path; 2) remove partitions;
> 3) suspend; 4) remove (or resume and restore queue_if_no_path
> in case of failure).
> 
> This patch modifies the implementation by moving the
> queue_if_no_path/suspend logic into _dm_flush_map().
> A call to _dm_flush_map() with need_suspend=1 replaces
> the previous call to dm_suspend_and_flush().
> 
> With this change, the mpath device is only suspended after
> removing partmaps, avoiding the deadlock.

This patch drops support for disabling partitions, by removing
-       /* if the device currently has no partitions, do not
-          run kpartx on it if you fail to delete it */
-       if (do_foreach_partmaps(mapname, has_partmap, NULL) == 0)
-               udev_flags |= MPATH_UDEV_NO_KPARTX_FLAG;

 
> Fixes: 9a4ff93 "Switch off 'queue_if_no_path' before removing maps"
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 102 ++++++++++++++++++++---------------------------
>  libmultipath/devmapper.h |   9 +++--
>  2 files changed, 49 insertions(+), 62 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 1576dd01..044be2be 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -760,12 +760,6 @@ out:
>  }
>  
>  static int
> -has_partmap(const char *name, void *data)
> -{
> -	return 1;
> -}
> -
> -static int
>  partmap_in_use(const char *name, void *data)
>  {
>  	int part_count, *ret_count = (int *)data;
> @@ -785,9 +779,13 @@ partmap_in_use(const char *name, void *data)
>  	return 0;
>  }
>  
> -int _dm_flush_map(const char *mapname, int need_sync, int deferred_remove)
> +int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
> +		   int need_suspend, int retries)
>  {
>  	int r;
> +	int queue_if_no_path = 0;
> +	unsigned long long mapsize;
> +	char params[PARAMS_SIZE] = {0};
>  
>  	if (!dm_is_mpath(mapname))
>  		return 0; /* nothing to do */
> @@ -797,6 +795,16 @@ int _dm_flush_map(const char *mapname, int need_sync, int deferred_remove)
>  	if (!do_deferred(deferred_remove) && partmap_in_use(mapname, NULL))
>  			return 1;
>  
> +	if (need_suspend &&
> +	    !dm_get_map(mapname, &mapsize, params) &&
> +	    strstr(params, "queue_if_no_path")) {
> +		if (!dm_queue_if_no_path((char *)mapname, 0))
> +			queue_if_no_path = 1;
> +		else
> +			/* Leave queue_if_no_path alone if unset failed */
> +			queue_if_no_path = -1;
> +	}
> +
>  	if (dm_remove_partmaps(mapname, need_sync, deferred_remove))
>  		return 1;
>  
> @@ -805,17 +813,36 @@ int _dm_flush_map(const char *mapname, int need_sync, int deferred_remove)
>  		return 1;
>  	}
>  
> -	r = dm_device_remove(mapname, need_sync, deferred_remove);
> +	do {
> +		if (need_suspend && queue_if_no_path != -1)
> +			dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 0);
>  
> -	if (r) {
> -		if (do_deferred(deferred_remove) && dm_map_present(mapname)) {
> -			condlog(4, "multipath map %s remove deferred",
> +		r = dm_device_remove(mapname, need_sync, deferred_remove);
> +
> +		if (r) {
> +			if (do_deferred(deferred_remove)
> +			    && dm_map_present(mapname)) {
> +				condlog(4, "multipath map %s remove deferred",
> +					mapname);
> +				return 2;
> +			}
> +			condlog(4, "multipath map %s removed", mapname);
> +			return 0;
> +		} else {
> +			condlog(2, "failed to remove multipath map %s",
>  				mapname);
> -			return 2;

This resume command needs to disable adding back partitions if there
aren't any, otherwise it could create partitions on a device that wasn't
supposed to have any.

> +			if (need_suspend && queue_if_no_path != -1) {
> +				dm_simplecmd_noflush(DM_DEVICE_RESUME,
> +						     mapname, 0);
> +			}
>  		}
> -		condlog(4, "multipath map %s removed", mapname);
> -		return 0;
> -	}
> +		if (retries)
> +			sleep(1);
> +	} while (retries-- > 0);
> +
> +	if (queue_if_no_path == 1)
> +		dm_queue_if_no_path((char *)mapname, 1);
> +
>  	return 1;
>  }
>  
> @@ -824,7 +851,7 @@ int _dm_flush_map(const char *mapname, int need_sync, int deferred_remove)
>  int
>  dm_flush_map_nopaths(const char * mapname, int deferred_remove)
>  {
> -	return _dm_flush_map(mapname, 1, deferred_remove);
> +	return _dm_flush_map(mapname, 1, deferred_remove, 0, 0);
>  }
>  
>  #else
> @@ -832,52 +859,11 @@ dm_flush_map_nopaths(const char * mapname, int deferred_remove)
>  int
>  dm_flush_map_nopaths(const char * mapname, int deferred_remove)
>  {
> -	return _dm_flush_map(mapname, 1, 0);
> +	return _dm_flush_map(mapname, 1, 0, 0, 0);
>  }
>  
>  #endif
>  
> -int dm_suspend_and_flush_map (const char * mapname, int retries)
> -{
> -	int need_reset = 0, queue_if_no_path = 0;
> -	unsigned long long mapsize;
> -	char params[PARAMS_SIZE] = {0};
> -	int udev_flags = 0;
> -
> -	if (!dm_is_mpath(mapname))
> -		return 0; /* nothing to do */
> -
> -	/* if the device currently has no partitions, do not
> -	   run kpartx on it if you fail to delete it */
> -	if (do_foreach_partmaps(mapname, has_partmap, NULL) == 0)
> -		udev_flags |= MPATH_UDEV_NO_KPARTX_FLAG;
> -
> -	if (!dm_get_map(mapname, &mapsize, params)) {
> -		if (strstr(params, "queue_if_no_path"))
> -			queue_if_no_path = 1;
> -	}
> -
> -	if (queue_if_no_path && dm_queue_if_no_path((char *)mapname, 0) == 0)
> -		need_reset = 1;
> -
> -	do {
> -		if (!queue_if_no_path || need_reset)
> -			dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 0);
> -
> -		if (!dm_flush_map(mapname)) {
> -			condlog(4, "multipath map %s removed", mapname);
> -			return 0;
> -		}
> -		dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, udev_flags);
> -		if (retries)
> -			sleep(1);
> -	} while (retries-- > 0);
> -	condlog(2, "failed to remove multipath map %s", mapname);
> -	if (need_reset)
> -		dm_queue_if_no_path((char *)mapname, 1);
> -	return 1;
> -}
> -
>  int dm_flush_maps (int retries)
>  {
>  	int r = 0;
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index 3ea43297..aca4454b 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -36,12 +36,13 @@ int dm_get_map(const char *, unsigned long long *, char *);
>  int dm_get_status(char *, char *);
>  int dm_type(const char *, char *);
>  int dm_is_mpath(const char *);
> -int _dm_flush_map (const char *, int, int);
> +int _dm_flush_map (const char *, int, int, int, int);
>  int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
> -#define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0)
> -#define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0, 0)
> +#define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0, 0, 0)
> +#define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0, 0, 0, 0)
> +#define dm_suspend_and_flush_map(mapname, retries) \
> +	_dm_flush_map(mapname, 1, 0, 1, retries)
>  int dm_cancel_deferred_remove(struct multipath *mpp);
> -int dm_suspend_and_flush_map(const char * mapname, int retries);
>  int dm_flush_maps (int retries);
>  int dm_fail_path(char * mapname, char * path);
>  int dm_reinstate_path(char * mapname, char * path);
> -- 
> 2.11.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
