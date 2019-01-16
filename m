From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 3/6] multipathd: allow shutdown during
	configure()
Date: Wed, 16 Jan 2019 17:12:14 -0600
Message-ID: <20190116231214.GS11315@octiron.msp.redhat.com>
References: <20190104175914.22784-1-mwilck@suse.com>
	<20190104175914.22784-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190104175914.22784-4-mwilck@suse.com>
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
Cc: Chongyun Wu <wu.chongyun@h3c.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jan 04, 2019 at 06:59:11PM +0100, Martin Wilck wrote:
> reconfigure() can be a long-running operation; both initial path
> discovery and initial map setup can take a long time. Allow
> the main program to indicate that the process should be
> interrupted if a shutdown signal was received.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c |  5 +++++
>  libmultipath/discovery.c |  4 ++++
>  libmultipath/exit.h      |  5 +++++
>  mpathpersist/main.c      |  5 +++++
>  multipath/main.c         |  6 ++++++
>  multipathd/main.c        | 18 ++++++++++++++++++
>  6 files changed, 43 insertions(+)
>  create mode 100644 libmultipath/exit.h
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 84ae5f56..2b062b35 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -43,6 +43,7 @@
>  #include "wwids.h"
>  #include "sysfs.h"
>  #include "io_err_stat.h"
> +#include "exit.h"
>  
>  /* group paths in pg by host adapter
>   */
> @@ -1021,6 +1022,10 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  
>  	vector_foreach_slot (pathvec, pp1, k) {
>  		int invalid;
> +
> +		if (should_exit())
> +			return CP_FAIL;

Admittedly, we are about to exit here, so it's not a big deal, but
simply returning instead of doing

	ret = CP_FAIL;
	goto out;

will leak "size_mismatch_seen".


> +
>  		/* skip this path for some reason */
>  
>  		/* 1. if path has no unique id or wwid blacklisted */
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 7f983a63..3834685c 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -33,6 +33,7 @@
>  #include "unaligned.h"
>  #include "prioritizers/alua_rtpg.h"
>  #include "foreign.h"
> +#include "exit.h"
>  
>  int
>  alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
> @@ -160,6 +161,9 @@ path_discovery (vector pathvec, int flag)
>  	udev_list_entry_foreach(entry,
>  				udev_enumerate_get_list_entry(udev_iter)) {
>  		const char *devtype;
> +
> +		if (should_exit())
> +			break;
>  		devpath = udev_list_entry_get_name(entry);
>  		condlog(4, "Discover device %s", devpath);
>  		udevice = udev_device_new_from_syspath(udev, devpath);
> diff --git a/libmultipath/exit.h b/libmultipath/exit.h
> new file mode 100644
> index 00000000..1954c5ce
> --- /dev/null
> +++ b/libmultipath/exit.h
> @@ -0,0 +1,5 @@
> +#ifndef _EXIT_H
> +#define _EXIT_H
> +
> +extern int should_exit(void);
> +#endif /* _EXIT_H */
> diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> index 10cba452..fa831a07 100644
> --- a/mpathpersist/main.c
> +++ b/mpathpersist/main.c
> @@ -7,6 +7,7 @@
>  #include "vector.h"
>  #include "config.h"
>  #include "structs.h"
> +#include "exit.h"
>  #include <getopt.h>
>  #include <libudev.h>
>  #include "mpath_persist.h"
> @@ -42,6 +43,10 @@ int construct_transportid(const char * inp, struct transportid transid[], int nu
>  
>  int logsink;
>  struct config *multipath_conf;
> +int should_exit(void)
> +{
> +	return 0;
> +}
>  
>  struct config *get_multipath_config(void)
>  {
> diff --git a/multipath/main.c b/multipath/main.c
> index f40c179b..a5ca10ca 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -63,8 +63,14 @@
>  #include "propsel.h"
>  #include "time-util.h"
>  #include "file.h"
> +#include "exit.h"
>  
>  int logsink;
> +int should_exit(void)
> +{
> +	return 0;
> +}
> +
>  struct udev *udev;
>  struct config *multipath_conf;
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 6fc6a3ac..413beee0 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c

In child(), if we break out of this initial config early (which is
unlikely, but since uxlsnr is up, it is possible), we probably shouldn't
be doing

	sd_notify(0, "READY=1");

-Ben

> @@ -67,6 +67,7 @@ static int use_watchdog;
>  #include "uevent.h"
>  #include "log.h"
>  #include "uxsock.h"
> +#include "exit.h"
>  
>  #include "mpath_cmd.h"
>  #include "mpath_persist.h"
> @@ -141,6 +142,11 @@ static inline enum daemon_status get_running_state(void)
>  	return st;
>  }
>  
> +int should_exit(void)
> +{
> +	return get_running_state() == DAEMON_SHUTDOWN;
> +}
> +
>  /*
>   * global copy of vecs for use in sig handlers
>   */
> @@ -2355,6 +2361,9 @@ configure (struct vectors * vecs)
>  		goto fail;
>  	}
>  
> +	if (should_exit())
> +		goto fail;
> +
>  	conf = get_multipath_config();
>  	pthread_cleanup_push(put_multipath_config, conf);
>  	vector_foreach_slot (vecs->pathvec, pp, i){
> @@ -2371,6 +2380,9 @@ configure (struct vectors * vecs)
>  		goto fail;
>  	}
>  
> +	if (should_exit())
> +		goto fail;
> +
>  	/*
>  	 * create new set of maps & push changed ones into dm
>  	 * In the first call, use FORCE_RELOAD_WEAK to avoid making
> @@ -2385,6 +2397,9 @@ configure (struct vectors * vecs)
>  		goto fail;
>  	}
>  
> +	if (should_exit())
> +		goto fail;
> +
>  	/*
>  	 * may need to remove some maps which are no longer relevant
>  	 * e.g., due to blacklist changes in conf file
> @@ -2396,6 +2411,9 @@ configure (struct vectors * vecs)
>  
>  	dm_lib_release();
>  
> +	if (should_exit())
> +		goto fail;
> +
>  	sync_maps_state(mpvec);
>  	vector_foreach_slot(mpvec, mpp, i){
>  		if (remember_wwid(mpp->wwid) == 1)
> -- 
> 2.19.2
