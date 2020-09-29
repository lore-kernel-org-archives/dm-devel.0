From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 11/21] libmultipath: protect racy
 libdevmapper calls with a mutex
Date: Tue, 29 Sep 2020 00:57:15 -0500
Message-ID: <20200929055715.GR3384@octiron.msp.redhat.com>
References: <20200924133716.14120-1-mwilck@suse.com>
	<20200924133716.14120-12-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133716.14120-12-mwilck@suse.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 24, 2020 at 03:37:06PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> dm_udev_wait() and dm_task_run() may access global / static state
> in libdevmapper. They need to be protected by a lock in in our
> multithreaded library.
> 

This breaks the dmevents unit tests. dm_task_run is no longer called in
dmevents.c. Intead, its only called in devmapper.c, so this needs to be
in dmevents-test_OBJDEPS

> Cc: lixiaokeng@huawei.com
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c          | 73 +++++++++++++++++++------------
>  libmultipath/devmapper.h          |  2 +
>  libmultipath/libmultipath.version |  6 +++
>  libmultipath/util.c               |  5 +++
>  libmultipath/util.h               |  1 +
>  multipathd/dmevents.c             |  2 +-
>  multipathd/waiter.c               |  2 +-
>  7 files changed, 62 insertions(+), 29 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 08aa09f..2e3ae8a 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -42,6 +42,7 @@ static unsigned int dm_mpath_target_version[3] = { INVALID_VERSION, };
>  
>  static pthread_once_t dm_initialized = PTHREAD_ONCE_INIT;
>  static pthread_once_t versions_initialized = PTHREAD_ONCE_INIT;
> +static pthread_mutex_t libmp_dm_lock = PTHREAD_MUTEX_INITIALIZER;
>  
>  static int dm_conf_verbosity;
>  
> @@ -59,16 +60,34 @@ static inline int dm_task_set_cookie(struct dm_task *dmt, uint32_t *c, int a)
>  	return 1;
>  }
>  
> -void dm_udev_wait(unsigned int c)
> +static void libmp_udev_wait(unsigned int c)
>  {
>  }
>  
> -void dm_udev_set_sync_support(int c)
> +static void dm_udev_set_sync_support(int c)
>  {
>  }
> -
> +#else
> +static void libmp_udev_wait(unsigned int c)
> +{
> +	pthread_mutex_lock(&libmp_dm_lock);
> +	pthread_cleanup_push(cleanup_mutex, &libmp_dm_lock);
> +	dm_udev_wait(c);
> +	pthread_cleanup_pop(1);
> +}
>  #endif
>  
> +int libmp_dm_task_run(struct dm_task *dmt)
> +{
> +	int r;
> +
> +	pthread_mutex_lock(&libmp_dm_lock);
> +	pthread_cleanup_push(cleanup_mutex, &libmp_dm_lock);
> +	r = dm_task_run(dmt);
> +	pthread_cleanup_pop(1);
> +	return r;
> +}
> +
>  __attribute__((format(printf, 4, 5))) static void
>  dm_write_log (int level, const char *file, int line, const char *f, ...)
>  {
> @@ -196,7 +215,7 @@ static int dm_tgt_version (unsigned int *version, char *str)
>  
>  	dm_task_no_open_count(dmt);
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(2, DM_DEVICE_LIST_VERSIONS, dmt);
>  		condlog(0, "Can not communicate with kernel DM");
>  		goto out;
> @@ -380,12 +399,12 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
>  				DM_UDEV_DISABLE_LIBRARY_FALLBACK | udev_flags))
>  		goto out;
>  
> -	r = dm_task_run (dmt);
> +	r = libmp_dm_task_run (dmt);
>  	if (!r)
>  		dm_log_error(2, task, dmt);
>  
>  	if (udev_wait_flag)
> -			dm_udev_wait(cookie);
> +			libmp_udev_wait(cookie);
>  out:
>  	dm_task_destroy (dmt);
>  	return r;
> @@ -472,12 +491,12 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
>  	    !dm_task_set_cookie(dmt, &cookie, udev_flags))
>  		goto freeout;
>  
> -	r = dm_task_run (dmt);
> +	r = libmp_dm_task_run (dmt);
>  	if (!r)
>  		dm_log_error(2, task, dmt);
>  
>  	if (task == DM_DEVICE_CREATE)
> -			dm_udev_wait(cookie);
> +			libmp_udev_wait(cookie);
>  freeout:
>  	if (prefixed_uuid)
>  		FREE(prefixed_uuid);
> @@ -587,7 +606,7 @@ do_get_info(const char *name, struct dm_info *info)
>  
>  	dm_task_no_open_count(dmt);
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_INFO, dmt);
>  		goto out;
>  	}
> @@ -628,7 +647,7 @@ int dm_get_map(const char *name, unsigned long long *size, char *outparams)
>  	dm_task_no_open_count(dmt);
>  
>  	errno = 0;
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_TABLE, dmt);
>  		if (dm_task_get_errno(dmt) == ENXIO)
>  			r = DMP_NOT_FOUND;
> @@ -670,7 +689,7 @@ dm_get_prefixed_uuid(const char *name, char *uuid, int uuid_len)
>  	if (!dm_task_set_name (dmt, name))
>  		goto uuidout;
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_INFO, dmt);
>  		goto uuidout;
>  	}
> @@ -741,7 +760,7 @@ int dm_get_status(const char *name, char *outstatus)
>  	dm_task_no_open_count(dmt);
>  
>  	errno = 0;
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_STATUS, dmt);
>  		if (dm_task_get_errno(dmt) == ENXIO)
>  			r = DMP_NOT_FOUND;
> @@ -794,7 +813,7 @@ int dm_type(const char *name, char *type)
>  
>  	dm_task_no_open_count(dmt);
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_TABLE, dmt);
>  		goto out;
>  	}
> @@ -838,7 +857,7 @@ int dm_is_mpath(const char *name)
>  
>  	dm_task_no_open_count(dmt);
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_TABLE, dmt);
>  		goto out_task;
>  	}
> @@ -902,7 +921,7 @@ dm_map_present_by_uuid(const char *uuid)
>  	if (!dm_task_set_uuid(dmt, prefixed_uuid))
>  		goto out_task;
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_INFO, dmt);
>  		goto out_task;
>  	}
> @@ -948,7 +967,7 @@ dm_get_opencount (const char * mapname)
>  	if (!dm_task_set_name(dmt, mapname))
>  		goto out;
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_INFO, dmt);
>  		goto out;
>  	}
> @@ -1108,7 +1127,7 @@ int dm_flush_maps (int need_suspend, int retries)
>  
>  	dm_task_no_open_count(dmt);
>  
> -	if (!dm_task_run (dmt)) {
> +	if (!libmp_dm_task_run (dmt)) {
>  		dm_log_error(3, DM_DEVICE_LIST, dmt);
>  		goto out;
>  	}
> @@ -1154,7 +1173,7 @@ dm_message(const char * mapname, char * message)
>  
>  	dm_task_no_open_count(dmt);
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(2, DM_DEVICE_TARGET_MSG, dmt);
>  		goto out;
>  	}
> @@ -1274,7 +1293,7 @@ dm_get_maps (vector mp)
>  
>  	dm_task_no_open_count(dmt);
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_LIST, dmt);
>  		goto out;
>  	}
> @@ -1359,7 +1378,7 @@ dm_mapname(int major, int minor)
>  	 * daemon uev_trigger -> uev_add_map
>  	 */
>  	while (--loop) {
> -		r = dm_task_run(dmt);
> +		r = libmp_dm_task_run(dmt);
>  
>  		if (r)
>  			break;
> @@ -1404,7 +1423,7 @@ do_foreach_partmaps (const char * mapname,
>  
>  	dm_task_no_open_count(dmt);
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_LIST, dmt);
>  		goto out;
>  	}
> @@ -1639,11 +1658,11 @@ dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
>  
>  	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
>  		goto out;
> -	r = dm_task_run(dmt);
> +	r = libmp_dm_task_run(dmt);
>  	if (!r)
>  		dm_log_error(2, DM_DEVICE_RENAME, dmt);
>  
> -	dm_udev_wait(cookie);
> +	libmp_udev_wait(cookie);
>  
>  out:
>  	dm_task_destroy(dmt);
> @@ -1685,7 +1704,7 @@ int dm_reassign_table(const char *name, char *old, char *new)
>  
>  	dm_task_no_open_count(dmt);
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_TABLE, dmt);
>  		goto out;
>  	}
> @@ -1718,7 +1737,7 @@ int dm_reassign_table(const char *name, char *old, char *new)
>  	if (modified) {
>  		dm_task_no_open_count(reload_dmt);
>  
> -		if (!dm_task_run(reload_dmt)) {
> +		if (!libmp_dm_task_run(reload_dmt)) {
>  			dm_log_error(3, DM_DEVICE_RELOAD, reload_dmt);
>  			condlog(3, "%s: failed to reassign targets", name);
>  			goto out_reload;
> @@ -1765,7 +1784,7 @@ int dm_reassign(const char *mapname)
>  
>  	dm_task_no_open_count(dmt);
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_DEPS, dmt);
>  		goto out;
>  	}
> @@ -1833,7 +1852,7 @@ int dm_setgeometry(struct multipath *mpp)
>  		goto out;
>  	}
>  
> -	r = dm_task_run(dmt);
> +	r = libmp_dm_task_run(dmt);
>  	if (!r)
>  		dm_log_error(3, DM_DEVICE_SET_GEOMETRY, dmt);
>  out:
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index c8b37e1..158057e 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -89,6 +89,8 @@ enum {
>  	MULTIPATH_VERSION
>  };
>  int libmp_get_version(int which, unsigned int version[3]);
> +struct dm_task;
> +int libmp_dm_task_run(struct dm_task *dmt);
>  
>  #define dm_log_error(lvl, cmd, dmt)			      \
>  	condlog(lvl, "%s: libdm task=%d error: %s", __func__, \
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 5699a0b..0a96010 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -212,3 +212,9 @@ global:
>  local:
>  	*;
>  };
> +
> +LIBMULTIPATH_0.8.4.2 {
> +global:
> +	libmp_dm_task_run;
> +	cleanup_mutex;
> +} LIBMULTIPATH_0.8.4.1;
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index 66cd721..41da6ce 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -409,6 +409,11 @@ void cleanup_free_ptr(void *arg)
>  		free(*p);
>  }
>  
> +void cleanup_mutex(void *arg)
> +{
> +	pthread_mutex_unlock(arg);
> +}
> +
>  struct bitfield *alloc_bitfield(unsigned int maxbit)
>  {
>  	unsigned int n;
> diff --git a/libmultipath/util.h b/libmultipath/util.h
> index c1ae878..b8481af 100644
> --- a/libmultipath/util.h
> +++ b/libmultipath/util.h
> @@ -49,6 +49,7 @@ int should_exit(void);
>  
>  void close_fd(void *arg);
>  void cleanup_free_ptr(void *arg);
> +void cleanup_mutex(void *arg);
>  
>  struct scandir_result {
>  	struct dirent **di;
> diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
> index fc97c8a..b561cbf 100644
> --- a/multipathd/dmevents.c
> +++ b/multipathd/dmevents.c
> @@ -156,7 +156,7 @@ static int dm_get_events(void)
>  
>  	dm_task_no_open_count(dmt);
>  
> -	if (!dm_task_run(dmt)) {
> +	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_LIST, dmt);
>  		goto fail;
>  	}
> diff --git a/multipathd/waiter.c b/multipathd/waiter.c
> index 16fbdc8..620bfa7 100644
> --- a/multipathd/waiter.c
> +++ b/multipathd/waiter.c
> @@ -118,7 +118,7 @@ static int waiteventloop (struct event_thread *waiter)
>  	pthread_sigmask(SIG_UNBLOCK, &set, &oldset);
>  
>  	pthread_testcancel();
> -	r = dm_task_run(waiter->dmt);
> +	r = libmp_dm_task_run(waiter->dmt);
>  	if (!r)
>  		dm_log_error(2, DM_DEVICE_WAITEVENT, waiter->dmt);
>  	pthread_testcancel();
> -- 
> 2.28.0
