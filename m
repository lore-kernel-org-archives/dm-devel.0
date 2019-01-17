From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 6/6] multipathd: uxlsnr: handle signals
	while busy
Date: Wed, 16 Jan 2019 18:04:59 -0600
Message-ID: <20190117000459.GV11315@octiron.msp.redhat.com>
References: <20190104175914.22784-1-mwilck@suse.com>
	<20190104175914.22784-7-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190104175914.22784-7-mwilck@suse.com>
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

On Fri, Jan 04, 2019 at 06:59:14PM +0100, Martin Wilck wrote:
> The uxlsnr thread is responsible for receiving and handling
> signals in multipathd. This works well while it is idle and
> waiting for connections in ppoll(). But if it's busy, cli commands
> may need to take the vecs lock, which might take a long time.
> 
> Use multipathd's ability to handle pending signals to avoid
> shutdown delays.
> 
> If we find a deadly signal pending, try to use the remaining cycles
> to provide a meaningful error message to the client rather than
> simply break the connection.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/cli.c  | 50 ++++++++++++++++++++++++++++++++++-------------
>  multipathd/cli.h  |  2 +-
>  multipathd/main.c |  4 +++-
>  3 files changed, 40 insertions(+), 16 deletions(-)
> 
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index a75afe3f..824c01b6 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -12,7 +12,7 @@
>  #include "util.h"
>  #include "version.h"
>  #include <readline/readline.h>
> -
> +#include "main.h"
>  #include "cli.h"
>  
>  static vector keys;
> @@ -453,13 +453,45 @@ genhelp_handler (const char *cmd, int error)
>  	return reply;
>  }
>  
> +static int cli_timedlock(struct mutex_lock *a, long ms)
> +{
> +	struct timespec tmo;
> +	const long delta_ms = 100;
> +	const long MILLION = 1000L * 1000;
> +	const long delta_ns = MILLION * delta_ms;
> +	const long BILLION = 1000L * MILLION;
> +	int r;
> +
> +	if (ms <= 0 || clock_gettime(CLOCK_REALTIME, &tmo) != 0) {
> +		if (deliver_pending_signals())
> +			return EINTR;

Why call pthread_testcancel() before pthread_mutex_lock()?

I realize that the cancels are no longer blocked by holding the vecs
lock, but deliver_pending_signals() should have already told us if we
are about to shutdown. If we're not, it's very unlikely that we will be
cancelled between that check and the pthread_testcancel(). However, the
pthread_mutex_lock() might take some time, so it makes more sense to
check if we were cancelled after that. Or is there some other reason for
the check being there?

-Ben

> +		pthread_testcancel();
> +		pthread_mutex_lock(&a->mutex);
> +		return 0;
> +	}
> +
> +	for(; ms > 0; ms -= delta_ms) {
> +		if (deliver_pending_signals())
> +			return EINTR;
> +		pthread_testcancel();
> +		tmo.tv_nsec += (ms >= delta_ms ? delta_ns : MILLION * ms);
> +		if (tmo.tv_nsec >= BILLION) {
> +			tmo.tv_nsec -= BILLION;
> +			tmo.tv_sec++;
> +		}
> +		r = pthread_mutex_timedlock(&a->mutex, &tmo);
> +		if (r != ETIMEDOUT)
> +			return r;
> +	}
> +	return ETIMEDOUT;
> +}
> +
>  int
> -parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
> +parse_cmd(char *cmd, char **reply, int *len, void *data, long timeout_ms)
>  {
>  	int r;
>  	struct handler * h;
>  	vector cmdvec = NULL;
> -	struct timespec tmo;
>  
>  	r = get_cmdvec(cmd, &cmdvec);
>  
> @@ -481,22 +513,12 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
>  	/*
>  	 * execute handler
>  	 */
> -	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
> -		tmo.tv_sec += timeout;
> -	} else {
> -		tmo.tv_sec = 0;
> -	}
>  	if (h->locked) {
>  		int locked = 0;
>  		struct vectors * vecs = (struct vectors *)data;
>  
>  		pthread_cleanup_push(cleanup_lock, &vecs->lock);
> -		if (tmo.tv_sec) {
> -			r = timedlock(&vecs->lock, &tmo);
> -		} else {
> -			lock(&vecs->lock);
> -			r = 0;
> -		}
> +		r = cli_timedlock(&vecs->lock, timeout_ms);
>  		if (r == 0) {
>  			locked = 1;
>  			pthread_testcancel();
> diff --git a/multipathd/cli.h b/multipathd/cli.h
> index 7cc7e4be..fb20e0d2 100644
> --- a/multipathd/cli.h
> +++ b/multipathd/cli.h
> @@ -123,7 +123,7 @@ int alloc_handlers (void);
>  int add_handler (uint64_t fp, int (*fn)(void *, char **, int *, void *));
>  int set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *));
>  int set_unlocked_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *));
> -int parse_cmd (char * cmd, char ** reply, int * len, void *, int);
> +int parse_cmd(char *cmd, char **reply, int *len, void *data, long timeout_ms);
>  int load_keys (void);
>  char * get_keyparam (vector v, uint64_t code);
>  void free_keys (vector vec);
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 6276d34c..9ed0cadd 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1395,11 +1395,13 @@ uxsock_trigger (char * str, char ** reply, int * len, bool is_root,
>  		return 1;
>  	}
>  
> -	r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
> +	r = parse_cmd(str, reply, len, vecs, uxsock_timeout);
>  
>  	if (r > 0) {
>  		if (r == ETIMEDOUT)
>  			*reply = STRDUP("timeout\n");
> +		else if (r == EINTR)
> +			*reply = STRDUP("daemon exiting\n");
>  		else
>  			*reply = STRDUP("fail\n");
>  		if (*reply)
> -- 
> 2.19.2
