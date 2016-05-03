From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 55/57] multipathd: asynchronous configuration
Date: Tue, 3 May 2016 13:23:05 -0500
Message-ID: <20160503182305.GG26117@octiron.msp.redhat.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-56-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1461755458-29225-56-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Wed, Apr 27, 2016 at 01:10:56PM +0200, Hannes Reinecke wrote:
> For initial configuration multipathd waits until it has synchronized
> with the existing setup. On larger systems this takes up quite
> some time (I've measured 80 seconds on a system with 1024 paths)
> causing systemd to stall and the system to fail booting.
> This patch makes the initial configuration asynchronous, and
> using the same codepath as the existing 'reconfigure' CLI
> command.

After you call reconfigure, you need to clear conf->delayed_reconfig,
otherwise ev_add_map will keep triggering reconfigures whenever a new
map is added.  This isn't actually your bug.  I forgot to do that when I
added the delayed_reconfig code in the first place. And since the patch
is already accepted, there's no reason to mess with it.

I'll send a fix.

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/uevent.c     |  10 +--
>  multipathd/cli_handlers.c |  14 ++-
>  multipathd/main.c         | 219 ++++++++++++++++++++++++++++++----------------
>  multipathd/main.h         |   2 +
>  4 files changed, 157 insertions(+), 88 deletions(-)
> 
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index 478c6ce..fbe9c44 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -529,8 +529,6 @@ int uevent_listen(struct udev *udev)
>  	}
>  
>  	pthread_sigmask(SIG_SETMASK, NULL, &mask);
> -	sigdelset(&mask, SIGHUP);
> -	sigdelset(&mask, SIGUSR1);
>  	events = 0;
>  	while (1) {
>  		struct uevent *uev;
> @@ -561,9 +559,11 @@ int uevent_listen(struct udev *udev)
>  			continue;
>  		}
>  		if (fdcount < 0) {
> -			if (errno != EINTR)
> -				condlog(0, "error receiving "
> -					"uevent message: %m");
> +			if (errno == EINTR)
> +				continue;
> +
> +			condlog(0, "error receiving "
> +				"uevent message: %m");
>  			err = -errno;
>  			break;
>  		}
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index dbdcbc2..0397353 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -909,17 +909,13 @@ cli_switch_group(void * v, char ** reply, int * len, void * data)
>  int
>  cli_reconfigure(void * v, char ** reply, int * len, void * data)
>  {
> -	struct vectors * vecs = (struct vectors *)data;
> -
> -	if (need_to_delay_reconfig(vecs)) {
> -		conf->delayed_reconfig = 1;
> -		condlog(2, "delaying reconfigure (operator)");
> -		return 0;
> -	}
> -
>  	condlog(2, "reconfigure (operator)");
>  
> -	return reconfigure(vecs);
> +	if (set_config_state(DAEMON_CONFIGURE) == ETIMEDOUT) {
> +		condlog(2, "timeout starting reconfiguration");
> +		return 1;
> +	}
> +	return 0;
>  }
>  
>  int
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 77eb498..41b5a49 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -97,10 +97,11 @@ struct mpath_event_param
>  unsigned int mpath_mx_alloc_len;
>  
>  int logsink;
> -enum daemon_status running_state;
> +enum daemon_status running_state = DAEMON_INIT;
>  pid_t daemon_pid;
> +pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
> +pthread_cond_t config_cond = PTHREAD_COND_INITIALIZER;
>  
> -static sem_t exit_sem;
>  /*
>   * global copy of vecs for use in sig handlers
>   */
> @@ -108,6 +109,94 @@ struct vectors * gvecs;
>  
>  struct udev * udev;
>  
> +const char *
> +daemon_status(void)
> +{
> +	switch (running_state) {
> +	case DAEMON_INIT:
> +		return "init";
> +	case DAEMON_START:
> +		return "startup";
> +	case DAEMON_CONFIGURE:
> +		return "configure";
> +	case DAEMON_IDLE:
> +		return "idle";
> +	case DAEMON_RUNNING:
> +		return "running";
> +	case DAEMON_SHUTDOWN:
> +		return "shutdown";
> +	}
> +	return NULL;
> +}
> +
> +/*
> + * I love you too, systemd ...
> + */
> +const char *
> +sd_notify_status(void)
> +{
> +	switch (running_state) {
> +	case DAEMON_INIT:
> +		return "STATUS=init";
> +	case DAEMON_START:
> +		return "STATUS=startup";
> +	case DAEMON_CONFIGURE:
> +		return "STATUS=configure";
> +	case DAEMON_IDLE:
> +		return "STATUS=idle";
> +	case DAEMON_RUNNING:
> +		return "STATUS=running";
> +	case DAEMON_SHUTDOWN:
> +		return "STATUS=shutdown";
> +	}
> +	return NULL;
> +}
> +
> +static void config_cleanup(void *arg)
> +{
> +	pthread_mutex_unlock(&config_lock);
> +}
> +
> +void post_config_state(enum daemon_status state)
> +{
> +	pthread_mutex_lock(&config_lock);
> +	if (state != running_state) {
> +		running_state = state;
> +		pthread_cond_broadcast(&config_cond);
> +#ifdef USE_SYSTEMD
> +		sd_notify(0, sd_notify_status());
> +#endif
> +	}
> +	pthread_mutex_unlock(&config_lock);
> +}
> +
> +int set_config_state(enum daemon_status state)
> +{
> +	int rc = 0;
> +
> +	pthread_cleanup_push(config_cleanup, NULL);
> +	pthread_mutex_lock(&config_lock);
> +	if (running_state != state) {
> +		if (running_state != DAEMON_IDLE) {
> +			struct timespec ts;
> +
> +			clock_gettime(CLOCK_REALTIME, &ts);
> +			ts.tv_sec += 1;
> +			rc = pthread_cond_timedwait(&config_cond,
> +						    &config_lock, &ts);
> +		}
> +		if (!rc) {
> +			running_state = state;
> +			pthread_cond_broadcast(&config_cond);
> +#ifdef USE_SYSTEMD
> +			sd_notify(0, sd_notify_status());
> +#endif
> +		}
> +	}
> +	pthread_cleanup_pop(1);
> +	return rc;
> +}
> +
>  static int
>  need_switch_pathgroup (struct multipath * mpp, int refresh)
>  {
> @@ -352,7 +441,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
>  	if (mpp) {
>  		if (mpp->wait_for_udev > 1) {
>  			if (update_map(mpp, vecs))
> -			/* setup multipathd removed the map */
> +				/* setup multipathd removed the map */
>  				return 1;
>  		}
>  		if (mpp->wait_for_udev) {
> @@ -360,7 +449,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
>  			if (conf->delayed_reconfig &&
>  			    !need_to_delay_reconfig(vecs)) {
>  				condlog(2, "reconfigure (delayed)");
> -				reconfigure(vecs);
> +				set_config_state(DAEMON_CONFIGURE);
>  				return 0;
>  			}
>  		}
> @@ -903,6 +992,16 @@ uev_trigger (struct uevent * uev, void * trigger_data)
>  	if (uev_discard(uev->devpath))
>  		return 0;
>  
> +	pthread_cleanup_push(config_cleanup, NULL);
> +	pthread_mutex_lock(&config_lock);
> +	if (running_state != DAEMON_IDLE &&
> +	    running_state != DAEMON_RUNNING)
> +		pthread_cond_wait(&config_cond, &config_lock);
> +	pthread_cleanup_pop(1);
> +
> +	if (running_state == DAEMON_SHUTDOWN)
> +		return 0;
> +
>  	pthread_cleanup_push(cleanup_lock, &vecs->lock);
>  	lock(vecs->lock);
>  	pthread_testcancel();
> @@ -1031,25 +1130,7 @@ uxlsnrloop (void * ap)
>  void
>  exit_daemon (void)
>  {
> -	sem_post(&exit_sem);
> -}
> -
> -const char *
> -daemon_status(void)
> -{
> -	switch (running_state) {
> -	case DAEMON_INIT:
> -		return "init";
> -	case DAEMON_START:
> -		return "startup";
> -	case DAEMON_CONFIGURE:
> -		return "configure";
> -	case DAEMON_RUNNING:
> -		return "running";
> -	case DAEMON_SHUTDOWN:
> -		return "shutdown";
> -	}
> -	return NULL;
> +	post_config_state(DAEMON_SHUTDOWN);
>  }
>  
>  static void
> @@ -1178,7 +1259,7 @@ missing_uev_wait_tick(struct vectors *vecs)
>  	if (timed_out && conf->delayed_reconfig &&
>  	    !need_to_delay_reconfig(vecs)) {
>  		condlog(2, "reconfigure (delayed)");
> -		reconfigure(vecs);
> +		set_config_state(DAEMON_CONFIGURE);
>  	}
>  }
>  
> @@ -1541,11 +1622,18 @@ checkerloop (void *ap)
>  
>  	while (1) {
>  		struct timeval diff_time, start_time, end_time;
> -		int num_paths = 0, ticks = 0, signo, strict_timing;
> +		int num_paths = 0, ticks = 0, signo, strict_timing, rc = 0;
>  		sigset_t mask;
>  
>  		if (gettimeofday(&start_time, NULL) != 0)
>  			start_time.tv_sec = 0;
> +
> +		rc = set_config_state(DAEMON_RUNNING);
> +		if (rc == ETIMEDOUT) {
> +			condlog(4, "timeout waiting for DAEMON_IDLE");
> +			continue;
> +		}
> +
>  		pthread_cleanup_push(cleanup_lock, &vecs->lock);
>  		lock(vecs->lock);
>  		pthread_testcancel();
> @@ -1600,6 +1688,7 @@ checkerloop (void *ap)
>  			}
>  		}
>  
> +		post_config_state(DAEMON_IDLE);
>  		if (!strict_timing)
>  			sleep(1);
>  		else {
> @@ -1734,8 +1823,6 @@ reconfigure (struct vectors * vecs)
>  	struct config * old = conf;
>  	int retval = 1;
>  
> -	running_state = DAEMON_CONFIGURE;
> -
>  	/*
>  	 * free old map and path vectors ... they use old conf state
>  	 */
> @@ -1765,8 +1852,6 @@ reconfigure (struct vectors * vecs)
>  	}
>  	uxsock_timeout = conf->uxsock_timeout;
>  
> -	running_state = DAEMON_RUNNING;
> -
>  	return retval;
>  }
>  
> @@ -1819,20 +1904,9 @@ signal_set(int signo, void (*func) (int))
>  void
>  handle_signals(void)
>  {
> -	if (reconfig_sig && running_state == DAEMON_RUNNING) {
> -		pthread_cleanup_push(cleanup_lock,
> -				&gvecs->lock);
> -		lock(gvecs->lock);
> -		pthread_testcancel();
> -		if (need_to_delay_reconfig(gvecs)) {
> -			conf->delayed_reconfig = 1;
> -			condlog(2, "delaying reconfigure (signal)");
> -		}
> -		else {
> -			condlog(2, "reconfigure (signal)");
> -			reconfigure(gvecs);
> -		}
> -		lock_cleanup_pop(gvecs->lock);
> +	if (reconfig_sig) {
> +		condlog(2, "reconfigure (signal)");
> +		set_config_state(DAEMON_CONFIGURE);
>  	}
>  	if (log_reset_sig) {
>  		condlog(2, "reset log (signal)");
> @@ -1966,7 +2040,6 @@ child (void * param)
>  	char *envp;
>  
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
> -	sem_init(&exit_sem, 0, 0);
>  	signal_init();
>  
>  	udev = udev_new();
> @@ -1987,11 +2060,8 @@ child (void * param)
>  		exit(1);
>  	}
>  
> -	running_state = DAEMON_START;
> +	post_config_state(DAEMON_START);
>  
> -#ifdef USE_SYSTEMD
> -	sd_notify(0, "STATUS=startup");
> -#endif
>  	condlog(2, "--------start up--------");
>  	condlog(2, "read " DEFAULT_CONFIGFILE);
>  
> @@ -2067,6 +2137,11 @@ child (void * param)
>  	}
>  #endif
>  	/*
> +	 * Signal start of configuration
> +	 */
> +	post_config_state(DAEMON_CONFIGURE);
> +
> +	/*
>  	 * Start uevent listener early to catch events
>  	 */
>  	if ((rc = pthread_create(&uevent_thr, &uevent_attr, ueventloop, udev))) {
> @@ -2078,21 +2153,6 @@ child (void * param)
>  		condlog(0, "failed to create cli listener: %d", rc);
>  		goto failed;
>  	}
> -	/*
> -	 * fetch and configure both paths and multipaths
> -	 */
> -#ifdef USE_SYSTEMD
> -	sd_notify(0, "STATUS=configure");
> -#endif
> -	running_state = DAEMON_CONFIGURE;
> -
> -	lock(vecs->lock);
> -	if (configure(vecs, 1)) {
> -		unlock(vecs->lock);
> -		condlog(0, "failure during configuration");
> -		goto failed;
> -	}
> -	unlock(vecs->lock);
>  
>  	/*
>  	 * start threads
> @@ -2107,20 +2167,32 @@ child (void * param)
>  	}
>  	pthread_attr_destroy(&misc_attr);
>  
> -	running_state = DAEMON_RUNNING;
>  #ifdef USE_SYSTEMD
> -	sd_notify(0, "READY=1\nSTATUS=running");
> +	sd_notify(0, "READY=1");
>  #endif
>  
> -	/*
> -	 * exit path
> -	 */
> -	while(sem_wait(&exit_sem) != 0); /* Do nothing */
> +	while (running_state != DAEMON_SHUTDOWN) {
> +		pthread_cleanup_push(config_cleanup, NULL);
> +		pthread_mutex_lock(&config_lock);
> +		if (running_state != DAEMON_CONFIGURE &&
> +		    running_state != DAEMON_SHUTDOWN) {
> +			pthread_cond_wait(&config_cond, &config_lock);
> +		}
> +		pthread_cleanup_pop(1);
> +		if (running_state == DAEMON_CONFIGURE) {
> +			pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +			lock(vecs->lock);
> +			pthread_testcancel();
> +			if (!need_to_delay_reconfig(vecs)) {
> +				reconfigure(vecs);
> +			} else {
> +				conf->delayed_reconfig = 1;
> +			}
> +			lock_cleanup_pop(vecs->lock);
> +			post_config_state(DAEMON_IDLE);
> +		}
> +	}
>  
> -#ifdef USE_SYSTEMD
> -	sd_notify(0, "STATUS=shutdown");
> -#endif
> -	running_state = DAEMON_SHUTDOWN;
>  	lock(vecs->lock);
>  	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
>  		vector_foreach_slot(vecs->mpvec, mpp, i)
> @@ -2253,7 +2325,6 @@ main (int argc, char *argv[])
>  	int foreground = 0;
>  
>  	logsink = 1;
> -	running_state = DAEMON_INIT;
>  	dm_init();
>  
>  	if (getuid() != 0) {
> diff --git a/multipathd/main.h b/multipathd/main.h
> index d1a6d71..10b3a6d 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -7,6 +7,7 @@ enum daemon_status {
>      DAEMON_INIT,
>      DAEMON_START,
>      DAEMON_CONFIGURE,
> +    DAEMON_IDLE,
>      DAEMON_RUNNING,
>      DAEMON_SHUTDOWN,
>  };
> @@ -26,6 +27,7 @@ int ev_remove_path (struct path *, struct vectors *);
>  int ev_add_map (char *, char *, struct vectors *);
>  int ev_remove_map (char *, char *, int, struct vectors *);
>  void sync_map_state (struct multipath *);
> +int set_config_state(enum daemon_status);
>  void * mpath_alloc_prin_response(int prin_sa);
>  int prin_do_scsi_ioctl(char *, int rq_servact, struct prin_resp * resp,
>         int noisy);
> -- 
> 2.6.6
