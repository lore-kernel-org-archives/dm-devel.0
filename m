From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 18/23] libmultipath: fix log_thread startup
	and teardown
Date: Mon, 28 Sep 2020 15:15:23 -0500
Message-ID: <20200928201523.GO3384@octiron.msp.redhat.com>
References: <20200924134054.14632-1-mwilck@suse.com>
	<20200924134054.14632-19-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-19-mwilck@suse.com>
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

On Thu, Sep 24, 2020 at 03:40:49PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This fixes several issues with the log_thread. First, the running
> flag logq_running should be set by the thread itself, not by
> log_thread_start()/_stop(). Second, the thread was both cancelled and
> terminated via a flag (again, logq_running). It's sufficient,
> and better, to just cancel it and use logq_running as indication for
> successful termination. Third, the locking wasn't cancel-safe in some
> places. Forth, log_thread_start() and log_thread_stop() didn't wait for
> startup/teardown properly. Fifth, using (pthread_t)0 is wrong (pthread_t is
> opaque; there's no guarantee that 0 is not a valid pthread_t value). Finally,
> pthread_cancel() was called under logq_lock, which doesn't make sense to
> me at all.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/log_pthread.c | 59 ++++++++++++++++++++++++++++----------
>  1 file changed, 44 insertions(+), 15 deletions(-)
> 
> diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
> index 0c327ff..5825e66 100644
> --- a/libmultipath/log_pthread.c
> +++ b/libmultipath/log_pthread.c
> @@ -13,6 +13,7 @@
>  #include "log_pthread.h"
>  #include "log.h"
>  #include "lock.h"
> +#include "util.h"
>  
>  static pthread_t log_thr;
>  
> @@ -56,28 +57,45 @@ static void flush_logqueue (void)
>  	} while (empty == 0);
>  }
>  
> +static void cleanup_log_thread(__attribute((unused)) void *arg)
> +{
> +	logdbg(stderr, "log thread exiting");
> +	pthread_mutex_lock(&logev_lock);
> +	logq_running = 0;
> +	pthread_cond_signal(&logev_cond);
> +	pthread_mutex_unlock(&logev_lock);
> +}
> +
>  static void * log_thread (__attribute__((unused)) void * et)
>  {
>  	int running;
>  
>  	pthread_mutex_lock(&logev_lock);
> -	logq_running = 1;
> +	running = logq_running;
> +	if (!running)
> +		logq_running = 1;
> +	pthread_cond_signal(&logev_cond);
>  	pthread_mutex_unlock(&logev_lock);
> +	if (running)
> +		/* already started */
> +		return NULL;
> +	pthread_cleanup_push(cleanup_log_thread, NULL);
>  
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
>  	logdbg(stderr,"enter log_thread\n");
>  
>  	while (1) {
>  		pthread_mutex_lock(&logev_lock);
> -		if (logq_running && !log_messages_pending)
> +		pthread_cleanup_push(cleanup_mutex, &logev_lock);
> +		while (!log_messages_pending)
> +			/* this is a cancellation point */
>  			pthread_cond_wait(&logev_cond, &logev_lock);
>  		log_messages_pending = 0;
> -		running = logq_running;
> -		pthread_mutex_unlock(&logev_lock);
> -		if (!running)
> -			break;
> +		pthread_cleanup_pop(1);
> +
>  		flush_logqueue();
>  	}
> +	pthread_cleanup_pop(1);
>  	return NULL;
>  }
>  
> @@ -98,6 +116,12 @@ void log_thread_start (pthread_attr_t *attr)
>  		exit(1);
>  	}
>  
> +	pthread_mutex_lock(&logev_lock);
> +	pthread_cleanup_push(cleanup_mutex, &logev_lock);
> +	/* wait for thread startup */
> +	while (!logq_running)
> +		pthread_cond_wait(&logev_cond, &logev_lock);
> +	pthread_cleanup_pop(1);
>  	return;
>  }
>  
> @@ -112,21 +136,26 @@ void log_thread_reset (void)
>  
>  void log_thread_stop (void)
>  {
> +	int running;
> +
>  	if (!la)
>  		return;
> -
>  	logdbg(stderr,"enter log_thread_stop\n");
>  
>  	pthread_mutex_lock(&logev_lock);
> -	logq_running = 0;
> -	pthread_cond_signal(&logev_cond);
> -	pthread_mutex_unlock(&logev_lock);
> +	pthread_cleanup_push(cleanup_mutex, &logev_lock);
> +	running = logq_running;
> +	if (running) {
> +		pthread_cancel(log_thr);
> +		pthread_cond_signal(&logev_cond);
> +	}
> +	while (logq_running)
> +		pthread_cond_wait(&logev_cond, &logev_lock);

If we're already going to join the thread, why do we have to wait for
the cleanup handler first? Won't the join do the waiting we need?

-Ben

> +	pthread_cleanup_pop(1);
> +
> +	if (running)
> +		pthread_join(log_thr, NULL);
>  
> -	pthread_mutex_lock(&logq_lock);
> -	pthread_cancel(log_thr);
> -	pthread_mutex_unlock(&logq_lock);
> -	pthread_join(log_thr, NULL);
> -	log_thr = (pthread_t)0;
>  
>  	flush_logqueue();
>  
> -- 
> 2.28.0
