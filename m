From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: clean up code for stopping the
	waiter threads
Date: Sun, 20 May 2012 12:34:08 +0200
Message-ID: <1337510048.27070.5.camel@lapoo.opensvc.com>
References: <20120519063703.GK3343@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120519063703.GK3343@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On sam., 2012-05-19 at 01:37 -0500, Benjamin Marzinski wrote:
> The way multipathd currently stops the waiter threads needs some work.
> Right now they are stopped by being sent the SIGUSR1 signal. However their
> cleanup code assumes that they are being cancelled, just like all the other
> threads are.  There's no reason for them to be so unnecessarily
> complicated and different from the other threads
> 
> This patch does a couple of things.  First, it removes the mutex from
> the event_thread.  This wasn't doing anything. It was designed to protect
> the wp->mapname variable, which the waiter threads were checking to see
> if they should quit. However, the mutex was only ever being used by the
> thread itself, and it clearly didn't need to serialize with itself.  Also,
> the function to clear the mapname, signal_waiter(), was set with
> pthread_cleanup_push(), which never got called early, since the threads
> weren't being cancelled.  Thus, the mapname never got cleared
> until the pthreads were about to shut down.
> 
> The patch also rips out all the signal stopping code, and just uses
> pthread_cancel.  There already are cancellation points in the waiter
> thread code. Between the cancellation points, both explicit and implicit,
> and the fact that the waiter threads will never be killed except when the
> killer is holding the vecs lock, there shouldn't be any place where the
> waiter thread can access freed data.
> 
> To make sure the waiter thread cleans itself up properly, the dmt
> has been moved into the event_thread structure, and is destroyed in
> free_waiter() if necessary.
> 
Applied.

Thanks.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/waiter.c |   74 +++++++++++---------------------------------------
>  libmultipath/waiter.h |    4 +-
>  2 files changed, 19 insertions(+), 59 deletions(-)
> 
> Index: multipath-tools-120518/libmultipath/waiter.c
> ===================================================================
> --- multipath-tools-120518.orig/libmultipath/waiter.c
> +++ multipath-tools-120518/libmultipath/waiter.c
> @@ -29,23 +29,17 @@ struct event_thread *alloc_waiter (void)
>  
>  	wp = (struct event_thread *)MALLOC(sizeof(struct event_thread));
>  	memset(wp, 0, sizeof(struct event_thread));
> -	pthread_mutex_init(&wp->lock, NULL);
>  
>  	return wp;
>  }
>  
> -void signal_waiter (void *data)
> +void free_waiter (void *data)
>  {
>  	struct event_thread *wp = (struct event_thread *)data;
>  
> -	pthread_mutex_lock(&wp->lock);
> -	memset(wp->mapname, 0, WWID_SIZE);
> -	pthread_mutex_unlock(&wp->lock);
> -}
> +	if (wp->dmt)
> +		dm_task_destroy(wp->dmt);
>  
> -void free_waiter (struct event_thread *wp)
> -{
> -	pthread_mutex_destroy(&wp->lock);
>  	FREE(wp);
>  }
>  
> @@ -58,83 +52,56 @@ void stop_waiter_thread (struct multipat
>  	}
>  	condlog(2, "%s: stop event checker thread (%lu)", mpp->alias,
>  		mpp->waiter);
> -	pthread_kill(mpp->waiter, SIGUSR1);
> +	pthread_cancel(mpp->waiter);
>  	mpp->waiter = (pthread_t)0;
>  }
>  
> -static sigset_t unblock_signals(void)
> -{
> -	sigset_t set, old;
> -
> -	sigemptyset(&set);
> -	sigaddset(&set, SIGHUP);
> -	sigaddset(&set, SIGUSR1);
> -	pthread_sigmask(SIG_UNBLOCK, &set, &old);
> -	return old;
> -}
> -
>  /*
>   * returns the reschedule delay
>   * negative means *stop*
>   */
>  int waiteventloop (struct event_thread *waiter)
>  {
> -	sigset_t set;
> -	struct dm_task *dmt = NULL;
>  	int event_nr;
>  	int r;
>  
> -	pthread_mutex_lock(&waiter->lock);
>  	if (!waiter->event_nr)
>  		waiter->event_nr = dm_geteventnr(waiter->mapname);
>  
> -	if (!(dmt = dm_task_create(DM_DEVICE_WAITEVENT))) {
> +	if (!(waiter->dmt = dm_task_create(DM_DEVICE_WAITEVENT))) {
>  		condlog(0, "%s: devmap event #%i dm_task_create error",
>  				waiter->mapname, waiter->event_nr);
> -		pthread_mutex_unlock(&waiter->lock);
>  		return 1;
>  	}
>  
> -	if (!dm_task_set_name(dmt, waiter->mapname)) {
> +	if (!dm_task_set_name(waiter->dmt, waiter->mapname)) {
>  		condlog(0, "%s: devmap event #%i dm_task_set_name error",
>  				waiter->mapname, waiter->event_nr);
> -		dm_task_destroy(dmt);
> -		pthread_mutex_unlock(&waiter->lock);
> +		dm_task_destroy(waiter->dmt);
> +		waiter->dmt = NULL;
>  		return 1;
>  	}
>  
> -	if (waiter->event_nr && !dm_task_set_event_nr(dmt,
> +	if (waiter->event_nr && !dm_task_set_event_nr(waiter->dmt,
>  						      waiter->event_nr)) {
>  		condlog(0, "%s: devmap event #%i dm_task_set_event_nr error",
>  				waiter->mapname, waiter->event_nr);
> -		dm_task_destroy(dmt);
> -		pthread_mutex_unlock(&waiter->lock);
> +		dm_task_destroy(waiter->dmt);
> +		waiter->dmt = NULL;
>  		return 1;
>  	}
> -	pthread_mutex_unlock(&waiter->lock);
>  
> -	dm_task_no_open_count(dmt);
> -
> -	/* accept wait interruption */
> -	set = unblock_signals();
> +	dm_task_no_open_count(waiter->dmt);
>  
>  	/* wait */
> -	r = dm_task_run(dmt);
> -
> -	/* wait is over : event or interrupt */
> -	pthread_sigmask(SIG_SETMASK, &set, NULL);
> +	r = dm_task_run(waiter->dmt);
>  
> -	dm_task_destroy(dmt);
> +	dm_task_destroy(waiter->dmt);
> +	waiter->dmt = NULL;
>  
>  	if (!r)	/* wait interrupted by signal */
>  		return -1;
>  
> -	pthread_mutex_lock(&waiter->lock);
> -	if (!strlen(waiter->mapname)) {
> -		/* waiter should exit */
> -		pthread_mutex_unlock(&waiter->lock);
> -		return -1;
> -	}
>  	waiter->event_nr++;
>  
>  	/*
> @@ -164,20 +131,16 @@ int waiteventloop (struct event_thread *
>  		if (r) {
>  			condlog(2, "%s: event checker exit",
>  				waiter->mapname);
> -			pthread_mutex_unlock(&waiter->lock);
>  			return -1; /* stop the thread */
>  		}
>  
>  		event_nr = dm_geteventnr(waiter->mapname);
>  
> -		if (waiter->event_nr == event_nr) {
> -			pthread_mutex_unlock(&waiter->lock);
> +		if (waiter->event_nr == event_nr)
>  			return 1; /* upon problem reschedule 1s later */
> -		}
>  
>  		waiter->event_nr = event_nr;
>  	}
> -	pthread_mutex_unlock(&waiter->lock);
>  	return -1; /* never reach there */
>  }
>  
> @@ -189,7 +152,7 @@ void *waitevent (void *et)
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
>  
>  	waiter = (struct event_thread *)et;
> -	pthread_cleanup_push(signal_waiter, et);
> +	pthread_cleanup_push(free_waiter, et);
>  
>  	block_signal(SIGUSR1, NULL);
>  	block_signal(SIGHUP, NULL);
> @@ -203,7 +166,6 @@ void *waitevent (void *et)
>  	}
>  
>  	pthread_cleanup_pop(1);
> -	free_waiter(waiter);
>  	return NULL;
>  }
>  
> @@ -219,10 +181,8 @@ int start_waiter_thread (struct multipat
>  	if (!wp)
>  		goto out;
>  
> -	pthread_mutex_lock(&wp->lock);
>  	strncpy(wp->mapname, mpp->alias, WWID_SIZE);
>  	wp->vecs = vecs;
> -	pthread_mutex_unlock(&wp->lock);
>  
>  	if (pthread_create(&wp->thread, &waiter_attr, waitevent, wp)) {
>  		condlog(0, "%s: cannot create event checker", wp->mapname);
> Index: multipath-tools-120518/libmultipath/waiter.h
> ===================================================================
> --- multipath-tools-120518.orig/libmultipath/waiter.h
> +++ multipath-tools-120518/libmultipath/waiter.h
> @@ -4,15 +4,15 @@
>  extern pthread_attr_t waiter_attr;
>  
>  struct event_thread {
> +	struct dm_task *dmt;
>  	pthread_t thread;
> -	pthread_mutex_t lock;
>  	int event_nr;
>  	char mapname[WWID_SIZE];
>  	struct vectors *vecs;
>  };
>  
>  struct event_thread * alloc_waiter (void);
> -void signal_waiter (void *data);
> +void free_waiter (void *data);
>  void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs);
>  int start_waiter_thread (struct multipath *mpp, struct vectors *vecs);
>  int waiteventloop (struct event_thread *waiter);
