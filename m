From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH] multipathd: strict_timing without signals
Date: Wed, 7 Mar 2018 23:19:58 -0600
Message-ID: <20180308051958.GA14513@octiron.msp.redhat.com>
References: <20180307141751.29084-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180307141751.29084-1-mwilck@suse.com>
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

On Wed, Mar 07, 2018 at 03:17:51PM +0100, Martin Wilck wrote:
> The internal usage of SIGALRM by setitimer() function may cause subtle
> conflicts with other uses of SIGALRM, either by multipath-tools code itself
> (e.g. lock_file()) or libc (e.g. glob()).
> 
> This patch changes the checkerloop to use an interval timer and a pthread
> condition variable. No signals are used except those used by libpthread
> behind the scenes.
> 

I'm not sure that I'd call this simpler. Personally, I prefer using
nanosleep(), since it is just a system call instead of a library that
creates a thread every second to wake up the checker thread. But I don't
actually think that there's anything wrong with this, and I'm sure it
will come closer to waking the checker loop on the second, so if you're
strongly in favor of it, that's fine. Otherwise, I'll just rebase my
nanosleep patch.

-Ben


> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/Makefile |   2 +-
>  multipathd/main.c   | 113 ++++++++++++++++++++++++++++++++++++++--------------
>  2 files changed, 85 insertions(+), 30 deletions(-)
> 
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 4c9d29634160..c348f02ef7f8 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -10,7 +10,7 @@ CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir) \
>  	  -I$(mpathcmddir) -I$(thirdpartydir)
>  LDFLAGS += $(BIN_LDFLAGS)
>  LIBDEPS += -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist \
> -	   -L$(mpathcmddir) -lmpathcmd -ludev -ldl -lurcu -lpthread \
> +	   -L$(mpathcmddir) -lmpathcmd -ludev -ldl -lurcu -lpthread -lrt \
>  	   -ldevmapper -lreadline
>  
>  ifdef SYSTEMD
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 6e6c52a52783..c9c57c5baece 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1848,6 +1848,68 @@ static void init_path_check_interval(struct vectors *vecs)
>  	}
>  }
>  
> +static pthread_mutex_t checker_lock = PTHREAD_MUTEX_INITIALIZER;
> +static pthread_cond_t checker_cond = PTHREAD_COND_INITIALIZER;
> +
> +static void checker_notify(union sigval sv) {
> +
> +	pthread_mutex_lock(&checker_lock);
> +	pthread_cond_broadcast(&checker_cond);
> +	pthread_mutex_unlock(&checker_lock);
> +}
> +
> +static void unlock_mutex(void *arg)
> +{
> +	pthread_mutex_unlock((pthread_mutex_t*)arg);
> +}
> +
> +void cleanup_timer(void *arg)
> +{
> +	timer_t tmr = (timer_t)arg;
> +
> +	if (tmr != 0)
> +		timer_delete(tmr);
> +}
> +
> +static timer_t setup_check_timer(void)
> +{
> +	timer_t tmr = (timer_t)0;
> +	struct sigevent se;
> +
> +	memset(&se, 0, sizeof(se));
> +	se.sigev_notify = SIGEV_THREAD;
> +	se.sigev_notify_function = checker_notify;
> +
> +	if (timer_create(CLOCK_MONOTONIC, &se, &tmr)) {
> +		condlog(2, "%s: errno %d creating monotonic timer",
> +			__func__, errno);
> +		if (timer_create(CLOCK_REALTIME, &se, &tmr))
> +			condlog(0, "%s: errno %d creating timer",
> +				__func__, errno);
> +	}
> +	return tmr;
> +}
> +
> +static int set_check_timer(timer_t tmr, bool arm)
> +{
> +	struct itimerspec is;
> +
> +	if (tmr == 0)
> +		return -1;
> +
> +	if (arm) {
> +		is.it_value.tv_sec = 1;
> +		is.it_interval.tv_sec = 1;
> +	} else {
> +		is.it_value.tv_sec = 0;
> +		is.it_interval.tv_sec = 0;
> +	}
> +	is.it_value.tv_nsec = 0;
> +	is.it_interval.tv_nsec = 0;
> +
> +	return timer_settime(tmr, 0, &is, NULL);
> +}
> +
>  static void *
>  checkerloop (void *ap)
>  {
> @@ -1855,9 +1917,10 @@ checkerloop (void *ap)
>  	struct path *pp;
>  	int count = 0;
>  	unsigned int i;
> -	struct itimerval timer_tick_it;
>  	struct timespec last_time;
>  	struct config *conf;
> +	timer_t check_timer;
> +	int old_strict_timing = 0;
>  
>  	pthread_cleanup_push(rcu_unregister, NULL);
>  	rcu_register_thread();
> @@ -1865,6 +1928,9 @@ checkerloop (void *ap)
>  	vecs = (struct vectors *)ap;
>  	condlog(2, "path checkers start up");
>  
> +	check_timer = setup_check_timer();
> +	pthread_cleanup_push(cleanup_timer, (void*)check_timer);
> +
>  	/* Tweak start time for initial path check */
>  	if (clock_gettime(CLOCK_MONOTONIC, &last_time) != 0)
>  		last_time.tv_sec = 0;
> @@ -1873,8 +1939,7 @@ checkerloop (void *ap)
>  
>  	while (1) {
>  		struct timespec diff_time, start_time, end_time;
> -		int num_paths = 0, ticks = 0, signo, strict_timing, rc = 0;
> -		sigset_t mask;
> +		int num_paths = 0, ticks = 0, strict_timing, rc = 0;
>  
>  		if (clock_gettime(CLOCK_MONOTONIC, &start_time) != 0)
>  			start_time.tv_sec = 0;
> @@ -1956,40 +2021,30 @@ checkerloop (void *ap)
>  		}
>  		check_foreign();
>  		post_config_state(DAEMON_IDLE);
> +
>  		conf = get_multipath_config();
>  		strict_timing = conf->strict_timing;
>  		put_multipath_config(conf);
> -		if (!strict_timing)
> +
> +		if (check_timer && (old_strict_timing != strict_timing) &&
> +		    set_check_timer(check_timer, !!strict_timing) != 0) {
> +			condlog(1, "%s: errno %d %sarming interrupt timer",
> +				__func__, errno, strict_timing ? "" : "dis");
> +			strict_timing = 0;
> +		}
> +		old_strict_timing = strict_timing;
> +
> +		if (!strict_timing || !check_timer)
>  			sleep(1);
>  		else {
> -			timer_tick_it.it_interval.tv_sec = 0;
> -			timer_tick_it.it_interval.tv_usec = 0;
> -			if (diff_time.tv_nsec) {
> -				timer_tick_it.it_value.tv_sec = 0;
> -				timer_tick_it.it_value.tv_usec =
> -				     1000UL * 1000 * 1000 - diff_time.tv_nsec;
> -			} else {
> -				timer_tick_it.it_value.tv_sec = 1;
> -				timer_tick_it.it_value.tv_usec = 0;
> -			}
> -			setitimer(ITIMER_REAL, &timer_tick_it, NULL);
> -
> -			sigemptyset(&mask);
> -			sigaddset(&mask, SIGALRM);
> -			condlog(3, "waiting for %lu.%06lu secs",
> -				timer_tick_it.it_value.tv_sec,
> -				timer_tick_it.it_value.tv_usec);
> -			if (sigwait(&mask, &signo) != 0) {
> -				condlog(3, "sigwait failed with error %d",
> -					errno);
> -				conf = get_multipath_config();
> -				conf->strict_timing = 0;
> -				put_multipath_config(conf);
> -				break;
> -			}
> +			pthread_mutex_lock(&checker_lock);
> +			pthread_cleanup_push(unlock_mutex, &checker_lock);
> +			pthread_cond_wait(&checker_cond, &checker_lock);
> +			pthread_cleanup_pop(1);
>  		}
>  	}
>  	pthread_cleanup_pop(1);
> +	pthread_cleanup_pop(1);
>  	return NULL;
>  }
>  
> -- 
> 2.16.1
