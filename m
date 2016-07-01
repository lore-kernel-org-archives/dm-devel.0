From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 17/26] libmultipath: use 'struct config' as
 argument for pathinfo()
Date: Fri, 1 Jul 2016 15:25:37 -0500
Message-ID: <20160701202537.GY8095@octiron.msp.redhat.com>
References: <1466410153-23896-1-git-send-email-hare@suse.de>
	<1466410153-23896-18-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1466410153-23896-18-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Mon, Jun 20, 2016 at 10:09:04AM +0200, Hannes Reinecke wrote:
> pathinfo() requires access to the entire configuration, not just
> hwtable. So don't pretend this is the case.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  libmpathpersist/mpath_persist.c |  6 +++---
>  libmultipath/configure.c        |  8 ++++----
>  libmultipath/discovery.c        | 37 ++++++++++++++++++-------------------
>  libmultipath/discovery.h        |  8 ++++----
>  libmultipath/structs_vec.c      |  2 +-
>  multipath/main.c                |  6 +++---
>  multipathd/cli_handlers.c       |  2 +-
>  multipathd/main.c               | 16 ++++++++--------
>  8 files changed, 42 insertions(+), 43 deletions(-)
> 

<snip>

> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -32,7 +32,7 @@
>  #include "defaults.h"
>  
>  int
> -alloc_path_with_pathinfo (vector hwtable, struct udev_device *udevice,
> +alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
>  			  int flag, struct path **pp_ptr)
>  {
>  	int err = PATHINFO_FAILED;
> @@ -55,7 +55,7 @@ alloc_path_with_pathinfo (vector hwtable, struct udev_device *udevice,
>  		condlog(0, "pp->dev too small");
>  	} else {
>  		pp->udev = udev_device_ref(udevice);
> -		err = pathinfo(pp, hwtable, flag | DI_BLACKLIST);
> +		err = pathinfo(pp, conf, flag | DI_BLACKLIST);
>  	}
>  
>  	if (err)
> @@ -66,8 +66,8 @@ alloc_path_with_pathinfo (vector hwtable, struct udev_device *udevice,
>  }
>  
>  int
> -store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
> -		int flag, struct path **pp_ptr)
> +store_pathinfo (vector pathvec, struct config *conf,
> +		struct udev_device *udevice, int flag, struct path **pp_ptr)
>  {
>  	int err = PATHINFO_FAILED;
>  	struct path * pp;
> @@ -90,7 +90,7 @@ store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
>  		goto out;
>  	}
>  	pp->udev = udev_device_ref(udevice);
> -	err = pathinfo(pp, hwtable, flag);
> +	err = pathinfo(pp, conf, flag);
>  	if (err)
>  		goto out;
>  
> @@ -126,10 +126,10 @@ path_discover (vector pathvec, struct config * conf,
>  
>  	pp = find_path_by_dev(pathvec, (char *)devname);
>  	if (!pp) {
> -		return store_pathinfo(pathvec, conf->hwtable,
> +		return store_pathinfo(pathvec, conf,
>  				      udevice, flag, NULL);
>  	}
> -	return pathinfo(pp, conf->hwtable, flag);
> +	return pathinfo(pp, conf, flag);
>  }
>  
>  int
> @@ -1397,7 +1397,7 @@ cciss_ioctl_pathinfo (struct path * pp, int mask)
>  }
>  
>  int
> -get_state (struct path * pp, vector hwtable, int daemon)
> +get_state (struct path * pp, struct config *conf)
>  {
>  	struct checker * c = &pp->checker;
>  	int state;
> @@ -1405,8 +1405,8 @@ get_state (struct path * pp, vector hwtable, int daemon)
>  	condlog(3, "%s: get_state", pp->dev);
>  
>  	if (!checker_selected(c)) {
> -		if (daemon) {
> -			if (pathinfo(pp, hwtable, DI_SYSFS) != PATHINFO_OK) {
> +		if (!pp->hwe) {
> +			if (pathinfo(pp, conf, DI_SYSFS) != PATHINFO_OK) {
>  				condlog(3, "%s: couldn't get sysfs pathinfo",
>  					pp->dev);
>  				return PATH_UNCHECKED;
> @@ -1425,12 +1425,11 @@ get_state (struct path * pp, vector hwtable, int daemon)
>  		}
>  	}
>  	checker_clear_message(c);
> -	if (daemon) {
> -		if (conf->force_sync == 0)
> -			checker_set_async(c);
> -		else
> -			checker_set_sync(c);
> -	}
> +	if (conf->force_sync == 0)
> +		checker_set_async(c);
> +	else
> +		checker_set_sync(c);
> +
>  	if (!conf->checker_timeout &&
>  	    sysfs_get_timeout(pp, &(c->timeout)) <= 0)
>  		c->timeout = DEF_TIMEOUT;

I don't think that this change to get_state is correct. Previously,
we've always had the checker set to synchronous mode when run by the
multipath command.  With this change the checker will now run in async
mode by default.  It should be easy to just overwrite conf->force_sync
when running the multipath command to fix this.

-Ben
