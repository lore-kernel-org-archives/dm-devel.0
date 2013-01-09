From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 25/42] Make log_pthread more robust
Date: Wed, 09 Jan 2013 01:16:12 +0100
Message-ID: <1357690572.12137.17.camel@lapoo.opensvc.com>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
	<1357653259-62650-26-git-send-email-hare@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-26-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On mar., 2013-01-08 at 14:54 +0100, Hannes Reinecke wrote:
> We don't need to allocate memory for mutexes, we can just
> be using static variables. And valgrind complained about
> logqueue flush from shutdown, so don't do this.
> The normal shutdown process should be flushing the log
> queue anyway.
> 
It seems the log_thread_flush() function is missing from the patchset.
Care to send the incremental patch ?

Regards,
Christophe Varoqui
www.opensvc.com

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/log_pthread.c |  101 +++++++++++++++++++++++++++++--------------
>  libmultipath/log_pthread.h |   10 +++--
>  2 files changed, 74 insertions(+), 37 deletions(-)
> 
> diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
> index d701ba1..9e92a70 100644
> --- a/libmultipath/log_pthread.c
> +++ b/libmultipath/log_pthread.c
> @@ -13,20 +13,41 @@
>  #include "log.h"
>  #include "lock.h"
>  
> +pthread_t log_thr;
> +
> +pthread_mutex_t logq_lock;
> +pthread_mutex_t logev_lock;
> +pthread_cond_t logev_cond;
> +
> +int logq_running;
> +
> +static void
> +sigusr1 (int sig)
> +{
> +	pthread_mutex_lock(&logq_lock);
> +	log_reset("multipathd");
> +	pthread_mutex_unlock(&logq_lock);
> +}
> +
>  void log_safe (int prio, const char * fmt, va_list ap)
>  {
>  	sigset_t old;
>  
> +	if (log_thr == (pthread_t)0) {
> +		syslog(prio, fmt, ap);
> +		return;
> +	}
> +
>  	block_signal(SIGUSR1, &old);
>  	block_signal(SIGHUP, NULL);
>  
> -	pthread_mutex_lock(logq_lock);
> +	pthread_mutex_lock(&logq_lock);
>  	log_enqueue(prio, fmt, ap);
> -	pthread_mutex_unlock(logq_lock);
> +	pthread_mutex_unlock(&logq_lock);
>  
> -	pthread_mutex_lock(logev_lock);
> -	pthread_cond_signal(logev_cond);
> -	pthread_mutex_unlock(logev_lock);
> +	pthread_mutex_lock(&logev_lock);
> +	pthread_cond_signal(&logev_cond);
> +	pthread_mutex_unlock(&logev_lock);
>  
>  	pthread_sigmask(SIG_SETMASK, &old, NULL);
>  }
> @@ -36,9 +57,9 @@ static void flush_logqueue (void)
>  	int empty;
>  
>  	do {
> -		pthread_mutex_lock(logq_lock);
> +		pthread_mutex_lock(&logq_lock);
>  		empty = log_dequeue(la->buff);
> -		pthread_mutex_unlock(logq_lock);
> +		pthread_mutex_unlock(&logq_lock);
>  		if (!empty)
>  			log_syslog(la->buff);
>  	} while (empty == 0);
> @@ -46,15 +67,30 @@ static void flush_logqueue (void)
>  
>  static void * log_thread (void * et)
>  {
> +	struct sigaction sig;
> +	int running;
> +
> +	sig.sa_handler = sigusr1;
> +	sigemptyset(&sig.sa_mask);
> +	sig.sa_flags = 0;
> +	if (sigaction(SIGUSR1, &sig, NULL) < 0)
> +		logdbg(stderr, "Cannot set signal handler");
> +
> +	pthread_mutex_lock(&logev_lock);
> +	logq_running = 1;
> +	pthread_mutex_unlock(&logev_lock);
> +
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
>  	logdbg(stderr,"enter log_thread\n");
>  
>  	while (1) {
> -		pthread_mutex_lock(logev_lock);
> -		pthread_cond_wait(logev_cond, logev_lock);
> -		pthread_mutex_unlock(logev_lock);
> -
> -		flush_logqueue();
> +		pthread_mutex_lock(&logev_lock);
> +		pthread_cond_wait(&logev_cond, &logev_lock);
> +		running = logq_running;
> +		pthread_mutex_unlock(&logev_lock);
> +		if (!running)
> +			break;
> +		log_thread_flush();
>  	}
>  	return NULL;
>  }
> @@ -63,19 +99,18 @@ void log_thread_start (pthread_attr_t *attr)
>  {
>  	logdbg(stderr,"enter log_thread_start\n");
>  
> -	logq_lock = (pthread_mutex_t *) malloc(sizeof(pthread_mutex_t));
> -	logev_lock = (pthread_mutex_t *) malloc(sizeof(pthread_mutex_t));
> -	logev_cond = (pthread_cond_t *) malloc(sizeof(pthread_cond_t));
> -
> -	pthread_mutex_init(logq_lock, NULL);
> -	pthread_mutex_init(logev_lock, NULL);
> -	pthread_cond_init(logev_cond, NULL);
> +	pthread_mutex_init(&logq_lock, NULL);
> +	pthread_mutex_init(&logev_lock, NULL);
> +	pthread_cond_init(&logev_cond, NULL);
>  
>  	if (log_init("multipathd", 0)) {
>  		fprintf(stderr,"can't initialize log buffer\n");
>  		exit(1);
>  	}
> -	pthread_create(&log_thr, attr, log_thread, NULL);
> +	if (pthread_create(&log_thr, attr, log_thread, NULL)) {
> +		fprintf(stderr,"can't start log thread\n");
> +		exit(1);
> +	}
>  
>  	return;
>  }
> @@ -84,22 +119,22 @@ void log_thread_stop (void)
>  {
>  	logdbg(stderr,"enter log_thread_stop\n");
>  
> -	pthread_mutex_lock(logq_lock);
> +	pthread_mutex_lock(&logev_lock);
> +	logq_running = 0;
> +	pthread_cond_signal(&logev_cond);
> +	pthread_mutex_unlock(&logev_lock);
> +
> +	pthread_mutex_lock(&logq_lock);
>  	pthread_cancel(log_thr);
> -	pthread_mutex_unlock(logq_lock);
> +	pthread_mutex_unlock(&logq_lock);
>  	pthread_join(log_thr, NULL);
> +	log_thr = (pthread_t)0;
>  
>  	flush_logqueue();
>  
> -	pthread_mutex_destroy(logq_lock);
> -	pthread_mutex_destroy(logev_lock);
> -	pthread_cond_destroy(logev_cond);
> -
> -	free(logq_lock);
> -	logq_lock = NULL;
> -	free(logev_lock);
> -	logev_lock = NULL;
> -	free(logev_cond);
> -	logev_cond = NULL;
> -	free_logarea();
> +	pthread_mutex_destroy(&logq_lock);
> +	pthread_mutex_destroy(&logev_lock);
> +	pthread_cond_destroy(&logev_cond);
> +
> +	log_close();
>  }
> diff --git a/libmultipath/log_pthread.h b/libmultipath/log_pthread.h
> index 77780d8..f3b70ea 100644
> --- a/libmultipath/log_pthread.h
> +++ b/libmultipath/log_pthread.h
> @@ -3,11 +3,13 @@
>  
>  #include <pthread.h>
>  
> -pthread_t log_thr;
> +extern pthread_t log_thr;
>  
> -pthread_mutex_t *logq_lock;
> -pthread_mutex_t *logev_lock;
> -pthread_cond_t *logev_cond;
> +extern pthread_mutex_t logq_lock;
> +extern pthread_mutex_t logev_lock;
> +extern pthread_cond_t logev_cond;
> +
> +extern int logq_running;
>  
>  void log_safe(int prio, const char * fmt, va_list ap);
>  void log_thread_start(pthread_attr_t *attr);
