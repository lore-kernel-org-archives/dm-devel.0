From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 2/6] multipathd: protect all access to
	running_state
Date: Wed, 16 Jan 2019 18:06:17 -0600
Message-ID: <20190117000617.GX11315@octiron.msp.redhat.com>
References: <20190104175914.22784-1-mwilck@suse.com>
	<20190104175914.22784-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190104175914.22784-3-mwilck@suse.com>
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

On Fri, Jan 04, 2019 at 06:59:10PM +0100, Martin Wilck wrote:
> Chonyun Wu's latest patch has shown that the handling of the daemon
> state variable running_state is racy and difficult to get right. It's
> not a good candidate for a "benign race" annotation. So, as a first
> step to sanitizing it, make sure all accesses to the state variable
> are protected by config_lock.
> 
> The patch also replaces "if" with "while" in several places where the
> code was supposed to wait until a certain state was reached. It's
> important that DAEMON_SHUTDOWN terminates all loops of this kind.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 79 ++++++++++++++++++++++++++++-------------------
>  1 file changed, 48 insertions(+), 31 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 6a5d105a..6fc6a3ac 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -126,11 +126,21 @@ int poll_dmevents = 0;
>  #else
>  int poll_dmevents = 1;
>  #endif
> -enum daemon_status running_state = DAEMON_INIT;
> +enum daemon_status _running_state = DAEMON_INIT;
>  pid_t daemon_pid;
>  pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
>  pthread_cond_t config_cond;
>  
> +static inline enum daemon_status get_running_state(void)
> +{
> +	enum daemon_status st;
> +
> +	pthread_mutex_lock(&config_lock);
> +	st = _running_state;
> +	pthread_mutex_unlock(&config_lock);
> +	return st;
> +}
> +
>  /*
>   * global copy of vecs for use in sig handlers
>   */
> @@ -148,7 +158,7 @@ static volatile sig_atomic_t log_reset_sig;
>  const char *
>  daemon_status(void)
>  {
> -	switch (running_state) {
> +	switch (get_running_state()) {
>  	case DAEMON_INIT:
>  		return "init";
>  	case DAEMON_START:
> @@ -168,10 +178,10 @@ daemon_status(void)
>  /*
>   * I love you too, systemd ...
>   */
> -const char *
> -sd_notify_status(void)
> +static const char *
> +sd_notify_status(enum daemon_status state)
>  {
> -	switch (running_state) {
> +	switch (state) {
>  	case DAEMON_INIT:
>  		return "STATUS=init";
>  	case DAEMON_START:
> @@ -188,17 +198,18 @@ sd_notify_status(void)
>  }
>  
>  #ifdef USE_SYSTEMD
> -static void do_sd_notify(enum daemon_status old_state)
> +static void do_sd_notify(enum daemon_status old_state,
> +			 enum daemon_status new_state)
>  {
>  	/*
>  	 * Checkerloop switches back and forth between idle and running state.
>  	 * No need to tell systemd each time.
>  	 * These notifications cause a lot of overhead on dbus.
>  	 */
> -	if ((running_state == DAEMON_IDLE || running_state == DAEMON_RUNNING) &&
> +	if ((new_state == DAEMON_IDLE || new_state == DAEMON_RUNNING) &&
>  	    (old_state == DAEMON_IDLE || old_state == DAEMON_RUNNING))
>  		return;
> -	sd_notify(0, sd_notify_status());
> +	sd_notify(0, sd_notify_status(new_state));
>  }
>  #endif
>  
> @@ -207,15 +218,16 @@ static void config_cleanup(void *arg)
>  	pthread_mutex_unlock(&config_lock);
>  }
>  
> +/* must be called with config_lock held */
>  static void __post_config_state(enum daemon_status state)
>  {
> -	if (state != running_state && running_state != DAEMON_SHUTDOWN) {
> -		enum daemon_status old_state = running_state;
> +	if (state != _running_state && _running_state != DAEMON_SHUTDOWN) {
> +		enum daemon_status old_state = _running_state;
>  
> -		running_state = state;
> +		_running_state = state;
>  		pthread_cond_broadcast(&config_cond);
>  #ifdef USE_SYSTEMD
> -		do_sd_notify(old_state);
> +		do_sd_notify(old_state, state);
>  #endif
>  	}
>  }
> @@ -234,12 +246,12 @@ int set_config_state(enum daemon_status state)
>  
>  	pthread_cleanup_push(config_cleanup, NULL);
>  	pthread_mutex_lock(&config_lock);
> -	if (running_state != state) {
> -		enum daemon_status old_state = running_state;
> +	if (_running_state != state) {
> +		enum daemon_status old_state = _running_state;
>  
> -		if (running_state == DAEMON_SHUTDOWN)
> +		if (_running_state == DAEMON_SHUTDOWN)
>  			rc = EINVAL;
> -		else if (running_state != DAEMON_IDLE) {
> +		else if (_running_state != DAEMON_IDLE) {
>  			struct timespec ts;
>  
>  			clock_gettime(CLOCK_MONOTONIC, &ts);
> @@ -247,11 +259,11 @@ int set_config_state(enum daemon_status state)
>  			rc = pthread_cond_timedwait(&config_cond,
>  						    &config_lock, &ts);
>  		}
> -		if (!rc && (running_state != DAEMON_SHUTDOWN)) {
> -			running_state = state;
> +		if (!rc && (_running_state != DAEMON_SHUTDOWN)) {
> +			_running_state = state;
>  			pthread_cond_broadcast(&config_cond);
>  #ifdef USE_SYSTEMD
> -			do_sd_notify(old_state);
> +			do_sd_notify(old_state, state);
>  #endif
>  		}
>  	}
> @@ -1405,17 +1417,20 @@ uev_trigger (struct uevent * uev, void * trigger_data)
>  	int r = 0;
>  	struct vectors * vecs;
>  	struct uevent *merge_uev, *tmp;
> +	enum daemon_status state;
>  
>  	vecs = (struct vectors *)trigger_data;
>  
>  	pthread_cleanup_push(config_cleanup, NULL);
>  	pthread_mutex_lock(&config_lock);
> -	if (running_state != DAEMON_IDLE &&
> -	    running_state != DAEMON_RUNNING)
> +	while (_running_state != DAEMON_IDLE &&
> +	       _running_state != DAEMON_RUNNING &&
> +	       _running_state != DAEMON_SHUTDOWN)
>  		pthread_cond_wait(&config_cond, &config_lock);
> +	state = _running_state;
>  	pthread_cleanup_pop(1);
>  
> -	if (running_state == DAEMON_SHUTDOWN)
> +	if (state == DAEMON_SHUTDOWN)
>  		return 0;
>  
>  	/*
> @@ -2661,6 +2676,7 @@ child (void * param)
>  	struct config *conf;
>  	char *envp;
>  	int queue_without_daemon;
> +	enum daemon_status state;
>  
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
>  	signal_init();
> @@ -2756,8 +2772,9 @@ child (void * param)
>  	rc = pthread_create(&uxlsnr_thr, &misc_attr, uxlsnrloop, vecs);
>  	if (!rc) {
>  		/* Wait for uxlsnr startup */
> -		while (running_state == DAEMON_IDLE)
> +		while (_running_state == DAEMON_IDLE)
>  			pthread_cond_wait(&config_cond, &config_lock);
> +		state = _running_state;
>  	}
>  	pthread_cleanup_pop(1);
>  
> @@ -2765,7 +2782,7 @@ child (void * param)
>  		condlog(0, "failed to create cli listener: %d", rc);
>  		goto failed;
>  	}
> -	else if (running_state != DAEMON_CONFIGURE) {
> +	else if (state != DAEMON_CONFIGURE) {
>  		condlog(0, "cli listener failed to start");
>  		goto failed;
>  	}
> @@ -2805,15 +2822,17 @@ child (void * param)
>  	}
>  	pthread_attr_destroy(&misc_attr);
>  
> -	while (running_state != DAEMON_SHUTDOWN) {
> +	while (1) {
>  		pthread_cleanup_push(config_cleanup, NULL);
>  		pthread_mutex_lock(&config_lock);
> -		if (running_state != DAEMON_CONFIGURE &&
> -		    running_state != DAEMON_SHUTDOWN) {
> +		while (_running_state != DAEMON_CONFIGURE &&
> +		       _running_state != DAEMON_SHUTDOWN)
>  			pthread_cond_wait(&config_cond, &config_lock);
> -		}
> +		state = _running_state;
>  		pthread_cleanup_pop(1);
> -		if (running_state == DAEMON_CONFIGURE) {
> +		if (state == DAEMON_SHUTDOWN)
> +			break;
> +		if (state == DAEMON_CONFIGURE) {
>  			pthread_cleanup_push(cleanup_lock, &vecs->lock);
>  			lock(&vecs->lock);
>  			pthread_testcancel();
> @@ -2983,8 +3002,6 @@ main (int argc, char *argv[])
>  
>  	ANNOTATE_BENIGN_RACE_SIZED(&multipath_conf, sizeof(multipath_conf),
>  				   "Manipulated through RCU");
> -	ANNOTATE_BENIGN_RACE_SIZED(&running_state, sizeof(running_state),
> -		"Suppress complaints about unprotected running_state reads");
>  	ANNOTATE_BENIGN_RACE_SIZED(&uxsock_timeout, sizeof(uxsock_timeout),
>  		"Suppress complaints about this scalar variable");
>  
> -- 
> 2.19.2
