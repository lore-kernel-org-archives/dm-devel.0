From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH v2] simplify multipath signal handlers
Date: Mon, 13 May 2013 20:02:47 +0200
Message-ID: <1368468167.28586.0.camel@lapoo.opensvc.com>
References: <20130508183604.GW6253@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130508183604.GW6253@ether.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On mer., 2013-05-08 at 13:36 -0500, Benjamin Marzinski wrote:
> This patch changes how multipath's signal handlers work.  Instead of
> having sighup and sigusr1 acquire locks and call functions directly,
> they now both simply set atomic variables.  These two signals are
> blocked in child(), and all other threads inherit this sigmask. The
> only place in all the multipath code that doesn't block these signals
> is now the ppoll() call by the uxlsnr thread.  When it is interrupted
> by a signal, the uxlsnr thread does the actual processing work.
> 
> Instead of sigend using mutex locks and condition variables to tell
> the child() function to exit, it now uses a signal_handler safe
> semaphore that child() waits on and exit_daemon() increments.
> 
> This patch also switches all the sigprocmask() calls to
> pthread_sigmask()
> 
Applied.

Thanks,
Christophe Varoqui
www.opensvc.com

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/file.c        |  4 +--
>  libmultipath/lock.c        |  9 -----
>  libmultipath/lock.h        |  1 -
>  libmultipath/log_pthread.c | 22 ------------
>  libmultipath/waiter.c      |  2 --
>  multipathd/cli_handlers.c  |  4 +--
>  multipathd/main.c          | 90 +++++++++++++++++++++-------------------------
>  multipathd/main.h          |  3 +-
>  multipathd/uxlsnr.c        | 21 +++++++----
>  multipathd/uxlsnr.h        |  3 ++
>  10 files changed, 65 insertions(+), 94 deletions(-)
> 
> diff --git a/libmultipath/file.c b/libmultipath/file.c
> index 5ee46dc..74cde64 100644
> --- a/libmultipath/file.c
> +++ b/libmultipath/file.c
> @@ -98,7 +98,7 @@ lock_file(int fd, char *file_name)
>  	sigaddset(&set, SIGALRM);
>  
>  	sigaction(SIGALRM, &act, &oldact);
> -	sigprocmask(SIG_UNBLOCK, &set, &oldset);
> +	pthread_sigmask(SIG_UNBLOCK, &set, &oldset);
>  
>  	alarm(FILE_TIMEOUT);
>  	err = fcntl(fd, F_SETLKW, &lock);
> @@ -112,7 +112,7 @@ lock_file(int fd, char *file_name)
>  			condlog(0, "%s is locked. Giving up.", file_name);
>  	}
>  
> -	sigprocmask(SIG_SETMASK, &oldset, NULL);
> +	pthread_sigmask(SIG_SETMASK, &oldset, NULL);
>  	sigaction(SIGALRM, &oldact, NULL);
>  	return err;
>  }
> diff --git a/libmultipath/lock.c b/libmultipath/lock.c
> index 4439a51..6ce9a74 100644
> --- a/libmultipath/lock.c
> +++ b/libmultipath/lock.c
> @@ -1,16 +1,7 @@
>  #include <pthread.h>
> -#include <signal.h>
>  #include "lock.h"
>  #include <stdio.h>
>  
> -void block_signal (int signum, sigset_t *old)
> -{
> -	sigset_t set;
> -	sigemptyset(&set);
> -	sigaddset(&set, signum);
> -	pthread_sigmask(SIG_BLOCK, &set, old);
> -}
> -
>  void cleanup_lock (void * data)
>  {
>  	unlock ((*(struct mutex_lock *)data));
> diff --git a/libmultipath/lock.h b/libmultipath/lock.h
> index 6897a74..04ef78d 100644
> --- a/libmultipath/lock.h
> +++ b/libmultipath/lock.h
> @@ -29,6 +29,5 @@ struct mutex_lock {
>  #endif
>  
>  void cleanup_lock (void * data);
> -void block_signal(int signum, sigset_t *old);
>  
>  #endif /* _LOCK_H */
> diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
> index b8f9119..47d75a1 100644
> --- a/libmultipath/log_pthread.c
> +++ b/libmultipath/log_pthread.c
> @@ -22,26 +22,13 @@ pthread_cond_t logev_cond;
>  
>  int logq_running;
>  
> -static void
> -sigusr1 (int sig)
> -{
> -	pthread_mutex_lock(&logq_lock);
> -	log_reset("multipathd");
> -	pthread_mutex_unlock(&logq_lock);
> -}
> -
>  void log_safe (int prio, const char * fmt, va_list ap)
>  {
> -	sigset_t old;
> -
>  	if (log_thr == (pthread_t)0) {
>  		syslog(prio, fmt, ap);
>  		return;
>  	}
>  
> -	block_signal(SIGUSR1, &old);
> -	block_signal(SIGHUP, NULL);
> -
>  	pthread_mutex_lock(&logq_lock);
>  	log_enqueue(prio, fmt, ap);
>  	pthread_mutex_unlock(&logq_lock);
> @@ -49,8 +36,6 @@ void log_safe (int prio, const char * fmt, va_list ap)
>  	pthread_mutex_lock(&logev_lock);
>  	pthread_cond_signal(&logev_cond);
>  	pthread_mutex_unlock(&logev_lock);
> -
> -	pthread_sigmask(SIG_SETMASK, &old, NULL);
>  }
>  
>  void log_thread_flush (void)
> @@ -81,15 +66,8 @@ static void flush_logqueue (void)
>  
>  static void * log_thread (void * et)
>  {
> -	struct sigaction sig;
>  	int running;
>  
> -	sig.sa_handler = sigusr1;
> -	sigemptyset(&sig.sa_mask);
> -	sig.sa_flags = 0;
> -	if (sigaction(SIGUSR1, &sig, NULL) < 0)
> -		logdbg(stderr, "Cannot set signal handler");
> -
>  	pthread_mutex_lock(&logev_lock);
>  	logq_running = 1;
>  	pthread_mutex_unlock(&logev_lock);
> diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
> index da71543..5094290 100644
> --- a/libmultipath/waiter.c
> +++ b/libmultipath/waiter.c
> @@ -157,8 +157,6 @@ void *waitevent (void *et)
>  	waiter = (struct event_thread *)et;
>  	pthread_cleanup_push(free_waiter, et);
>  
> -	block_signal(SIGUSR1, NULL);
> -	block_signal(SIGHUP, NULL);
>  	while (1) {
>  		r = waiteventloop(waiter);
>  
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index ac648ad..7b1cb62 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -939,8 +939,8 @@ int
>  cli_shutdown (void * v, char ** reply, int * len, void * data)
>  {
>  	condlog(3, "shutdown (operator)");
> -
> -	return exit_daemon(0);
> +	exit_daemon();
> +	return 0;
>  }
>  
>  int
> diff --git a/multipathd/main.c b/multipathd/main.c
> index eb4bc8a..0fa1b17 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -17,6 +17,7 @@
>  #include <limits.h>
>  #include <linux/oom.h>
>  #include <libudev.h>
> +#include <semaphore.h>
>  #include <mpath_persist.h>
>  
>  /*
> @@ -51,6 +52,7 @@
>  #include <prio.h>
>  #include <pgpolicies.h>
>  #include <uevent.h>
> +#include <log.h>
>  
>  #include "main.h"
>  #include "pidfile.h"
> @@ -81,13 +83,11 @@ struct mpath_event_param
>  
>  unsigned int mpath_mx_alloc_len;
>  
> -pthread_cond_t exit_cond = PTHREAD_COND_INITIALIZER;
> -pthread_mutex_t exit_mutex = PTHREAD_MUTEX_INITIALIZER;
> -
>  int logsink;
>  enum daemon_status running_state;
>  pid_t daemon_pid;
>  
> +static sem_t exit_sem;
>  /*
>   * global copy of vecs for use in sig handlers
>   */
> @@ -833,9 +833,6 @@ out:
>  static void *
>  ueventloop (void * ap)
>  {
> -	block_signal(SIGUSR1, NULL);
> -	block_signal(SIGHUP, NULL);
> -
>  	if (uevent_listen())
>  		condlog(0, "error starting uevent listener");
>  
> @@ -845,9 +842,6 @@ ueventloop (void * ap)
>  static void *
>  uevqloop (void * ap)
>  {
> -	block_signal(SIGUSR1, NULL);
> -	block_signal(SIGHUP, NULL);
> -
>  	if (uevent_dispatch(&uev_trigger, ap))
>  		condlog(0, "error starting uevent dispatcher");
>  
> @@ -856,9 +850,6 @@ uevqloop (void * ap)
>  static void *
>  uxlsnrloop (void * ap)
>  {
> -	block_signal(SIGUSR1, NULL);
> -	block_signal(SIGHUP, NULL);
> -
>  	if (cli_init())
>  		return NULL;
>  
> @@ -908,18 +899,10 @@ uxlsnrloop (void * ap)
>  	return NULL;
>  }
>  
> -int
> -exit_daemon (int status)
> +void
> +exit_daemon (void)
>  {
> -	if (status != 0)
> -		fprintf(stderr, "bad exit status. see daemon.log\n");
> -
> -	if (running_state != DAEMON_SHUTDOWN) {
> -		pthread_mutex_lock(&exit_mutex);
> -		pthread_cond_signal(&exit_cond);
> -		pthread_mutex_unlock(&exit_mutex);
> -	}
> -	return status;
> +	sem_post(&exit_sem);
>  }
>  
>  const char *
> @@ -1282,7 +1265,6 @@ checkerloop (void *ap)
>  	struct path *pp;
>  	int count = 0;
>  	unsigned int i;
> -	sigset_t old;
>  
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
>  	vecs = (struct vectors *)ap;
> @@ -1296,7 +1278,6 @@ checkerloop (void *ap)
>  	}
>  
>  	while (1) {
> -		block_signal(SIGHUP, &old);
>  		pthread_cleanup_push(cleanup_lock, &vecs->lock);
>  		lock(vecs->lock);
>  		pthread_testcancel();
> @@ -1320,7 +1301,6 @@ checkerloop (void *ap)
>  		}
>  
>  		lock_cleanup_pop(vecs->lock);
> -		pthread_sigmask(SIG_SETMASK, &old, NULL);
>  		sleep(1);
>  	}
>  	return NULL;
> @@ -1480,36 +1460,56 @@ signal_set(int signo, void (*func) (int))
>  		return (osig.sa_handler);
>  }
>  
> +void
> +handle_signals(void)
> +{
> +	if (reconfig_sig && running_state == DAEMON_RUNNING) {
> +		condlog(2, "reconfigure (signal)");
> +		pthread_cleanup_push(cleanup_lock,
> +				&gvecs->lock);
> +		lock(gvecs->lock);
> +		pthread_testcancel();
> +		reconfigure(gvecs);
> +		lock_cleanup_pop(gvecs->lock);
> +	}
> +	if (log_reset_sig) {
> +		condlog(2, "reset log (signal)");
> +		pthread_mutex_lock(&logq_lock);
> +		log_reset("multipathd");
> +		pthread_mutex_unlock(&logq_lock);
> +	}
> +	reconfig_sig = 0;
> +	log_reset_sig = 0;
> +}
> +
>  static void
>  sighup (int sig)
>  {
> -	condlog(2, "reconfigure (SIGHUP)");
> -
> -	if (running_state != DAEMON_RUNNING)
> -		return;
> -
> -	reconfigure(gvecs);
> -
> -#ifdef _DEBUG_
> -	dbg_free_final(NULL);
> -#endif
> +	reconfig_sig = 1;
>  }
>  
>  static void
>  sigend (int sig)
>  {
> -	exit_daemon(0);
> +	exit_daemon();
>  }
>  
>  static void
>  sigusr1 (int sig)
>  {
> -	condlog(3, "SIGUSR1 received");
> +	log_reset_sig = 1;
>  }
>  
>  static void
>  signal_init(void)
>  {
> +	sigset_t set;
> +
> +	sigemptyset(&set);
> +	sigaddset(&set, SIGHUP);
> +	sigaddset(&set, SIGUSR1);
> +	pthread_sigmask(SIG_BLOCK, &set, NULL);
> +
>  	signal_set(SIGHUP, sighup);
>  	signal_set(SIGUSR1, sigusr1);
>  	signal_set(SIGINT, sigend);
> @@ -1582,10 +1582,11 @@ child (void * param)
>  	struct vectors * vecs;
>  	struct multipath * mpp;
>  	int i;
> -	sigset_t set;
>  	int rc, pid_rc;
>  
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
> +	sem_init(&exit_sem, 0, 0);
> +	signal_init();
>  
>  	setup_thread_attr(&misc_attr, 64 * 1024, 1);
>  	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
> @@ -1645,7 +1646,6 @@ child (void * param)
>  	if (!vecs)
>  		exit(1);
>  
> -	signal_init();
>  	setscheduler();
>  	set_oom_adj();
>  
> @@ -1688,25 +1688,17 @@ child (void * param)
>  	}
>  	pthread_attr_destroy(&misc_attr);
>  
> -	pthread_mutex_lock(&exit_mutex);
>  	/* Startup complete, create logfile */
>  	pid_rc = pidfile_create(DEFAULT_PIDFILE, daemon_pid);
>  	/* Ignore errors, we can live without */
>  
>  	running_state = DAEMON_RUNNING;
> -	pthread_cond_wait(&exit_cond, &exit_mutex);
> -	/* Need to block these to avoid deadlocking */
> -	sigemptyset(&set);
> -	sigaddset(&set, SIGTERM);
> -	sigaddset(&set, SIGINT);
> -	pthread_sigmask(SIG_BLOCK, &set, NULL);
>  
>  	/*
>  	 * exit path
>  	 */
> +	while(sem_wait(&exit_sem) != 0); /* Do nothing */
>  	running_state = DAEMON_SHUTDOWN;
> -	pthread_sigmask(SIG_UNBLOCK, &set, NULL);
> -	block_signal(SIGHUP, NULL);
>  	lock(vecs->lock);
>  	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
>  		vector_foreach_slot(vecs->mpvec, mpp, i)
> diff --git a/multipathd/main.h b/multipathd/main.h
> index 242f5e1..10378ef 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -16,7 +16,7 @@ struct prin_resp;
>  
>  extern pid_t daemon_pid;
>  
> -int exit_daemon(int);
> +void exit_daemon(void);
>  const char * daemon_status(void);
>  int reconfigure (struct vectors *);
>  int ev_add_path (struct path *, struct vectors *);
> @@ -35,5 +35,6 @@ int mpath_pr_event_handle(struct path *pp);
>  void * mpath_pr_event_handler_fn (void * );
>  int update_map_pr(struct multipath *mpp);
>  void * mpath_pr_event_handler_fn (void * pathp );
> +void handle_signals(void);
>  
>  #endif /* MAIN_H */
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 71fc3b4..c0ddd8d 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -8,6 +8,7 @@
>  /*
>   * A simple domain socket listener
>   */
> +#define _GNU_SOURCE
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <unistd.h>
> @@ -19,20 +20,21 @@
>  #include <sys/socket.h>
>  #include <sys/un.h>
>  #include <sys/poll.h>
> -
> +#include <signal.h>
>  #include <checkers.h>
> -
>  #include <memory.h>
>  #include <debug.h>
>  #include <vector.h>
>  #include <structs.h>
> +#include <structs_vec.h>
>  #include <uxsock.h>
>  #include <defaults.h>
>  
> +#include "main.h"
>  #include "cli.h"
>  #include "uxlsnr.h"
>  
> -#define SLEEP_TIME 5000
> +struct timespec sleep_time = {5, 0};
>  
>  struct client {
>  	int fd;
> @@ -42,6 +44,8 @@ struct client {
>  static struct client *clients;
>  static unsigned num_clients;
>  struct pollfd *polls;
> +volatile sig_atomic_t reconfig_sig = 0;
> +volatile sig_atomic_t log_reset_sig = 0;
>  
>  /*
>   * handle a new client joining
> @@ -104,6 +108,7 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
>  	int rlen;
>  	char *inbuf;
>  	char *reply;
> +	sigset_t mask;
>  
>  	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
>  
> @@ -115,7 +120,9 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
>  	pthread_cleanup_push(uxsock_cleanup, NULL);
>  
>  	polls = (struct pollfd *)MALLOC(0);
> -
> +	pthread_sigmask(SIG_SETMASK, NULL, &mask);
> +	sigdelset(&mask, SIGHUP);
> +	sigdelset(&mask, SIGUSR1);
>  	while (1) {
>  		struct client *c;
>  		int i, poll_count;
> @@ -132,11 +139,13 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
>  		}
>  
>  		/* most of our life is spent in this call */
> -		poll_count = poll(polls, i, SLEEP_TIME);
> +		poll_count = ppoll(polls, i, &sleep_time, &mask);
>  
>  		if (poll_count == -1) {
> -			if (errno == EINTR)
> +			if (errno == EINTR) {
> +				handle_signals();
>  				continue;
> +			}
>  
>  			/* something went badly wrong! */
>  			condlog(0, "poll");
> diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
> index c646d5d..8b5a525 100644
> --- a/multipathd/uxlsnr.h
> +++ b/multipathd/uxlsnr.h
> @@ -4,5 +4,8 @@
>  void * uxsock_listen(int (*uxsock_trigger)
>  			(char *, char **, int *, void *),
>  			void * trigger_data);
> +
> +extern volatile sig_atomic_t reconfig_sig;
> +extern volatile sig_atomic_t log_reset_sig;
>  #endif
>  
