From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] multipath-tools: Fix compiler warnings when
 built without systemd.
Date: Tue, 16 Jun 2020 23:53:22 +0200
Message-ID: <d909fc0a2383f028ae7c3ad00c142193ca8d9ae7.camel@suse.com>
References: <20200516175508.12412-1-marius@devup.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200516175508.12412-1-marius@devup.no>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Marius Bakke <marius@devup.no>, dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Hello Marius,

On Sat, 2020-05-16 at 19:55 +0200, Marius Bakke wrote:
> ---
>  libmultipath/config.c |  2 +-
>  multipathd/main.c     | 19 +++++++++++++------
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 

thank you for the patch, and sorry for the late reply.
Thanks to Xose, too, for making me aware of it.

This patch needs some improvements, see remarks below.

In general, please note that the development and in particular the
testing of multipath-tools has been done almost exclusively on systems
using systemd for several years now. The compilation issues you
encountered may only be the tip of the iceberg. In particular, the udev
rules shipped with multipath-tools rely on systemd for proper device
setup.

> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index b4d87689..a28dc4f2 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -696,7 +696,7 @@ process_config_dir(struct config *conf, char
> *dir)
>  	pthread_cleanup_pop(1);
>  }
>  
> -static void set_max_checkint_from_watchdog(struct config *conf)
> +static void set_max_checkint_from_watchdog(__attribute__((unused))
> struct config *conf)

Rather than adding the attribute, please put the whole function in an
#if conditional, and the call in load_config(), too. We don't need this
without systemd.

>  {
>  #ifdef USE_SYSTEMD
>  	char *envp = getenv("WATCHDOG_USEC");
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 8baf9abe..8d3eace6 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -176,6 +176,7 @@ daemon_status(void)
>  /*
>   * I love you too, systemd ...
>   */
> +#ifdef USE_SYSTEMD
>  static const char *
>  sd_notify_status(enum daemon_status state)
>  {
> @@ -195,7 +196,6 @@ sd_notify_status(enum daemon_status state)
>  	return NULL;
>  }
>  
> -#ifdef USE_SYSTEMD
>  static void do_sd_notify(enum daemon_status old_state,
>  			 enum daemon_status new_state)
>  {
> @@ -247,7 +247,9 @@ enum daemon_status wait_for_state_change_if(enum
> daemon_status oldstate,
>  static void __post_config_state(enum daemon_status state)
>  {
>  	if (state != running_state && running_state != DAEMON_SHUTDOWN)
> {
> -		enum daemon_status old_state = running_state;
> +		/* save state for sd_notify */
> +		enum daemon_status
> +			__attribute__((unused)) old_state =
> running_state;

again, please put the declaration of old_state in an #if conditional.

>  
>  		running_state = state;
>  		pthread_cond_broadcast(&config_cond);
> @@ -272,7 +274,9 @@ int set_config_state(enum daemon_status state)
>  	pthread_cleanup_push(config_cleanup, NULL);
>  	pthread_mutex_lock(&config_lock);
>  	if (running_state != state) {
> -		enum daemon_status old_state = running_state;
> +		/* save state for sd_notify */
> +		enum daemon_status
> +			__attribute__((unused)) old_state =
> running_state;

likewise

>  
>  		if (running_state == DAEMON_SHUTDOWN)
>  			rc = EINVAL;
> @@ -2280,7 +2284,6 @@ checkerloop (void *ap)
>  	struct timespec last_time;
>  	struct config *conf;
>  	int foreign_tick = 0;
> -	bool use_watchdog;
>  
>  	pthread_cleanup_push(rcu_unregister, NULL);
>  	rcu_register_thread();
> @@ -2292,11 +2295,15 @@ checkerloop (void *ap)
>  	get_monotonic_time(&last_time);
>  	last_time.tv_sec -= 1;
>  
> -	/* use_watchdog is set from process environment and never
> changes */
>  	conf = get_multipath_config();
> -	use_watchdog = conf->use_watchdog;
>  	put_multipath_config(conf);
>  
> +#ifdef USE_SYSTEMD
> +	/* use_watchdog is set from process environment and never
> changes */
> +	bool use_watchdog;
> +	use_watchdog = conf->use_watchdog;
> +#endif
> +

This is wrong. You have to access conf between get_multipath_config()
and put_multipath_config().

I'd prefer to simply add conditionals around the declaration of
use_watchdog, both in the function header and where it's set.

Regards,
Martin

>  	while (1) {
>  		struct timespec diff_time, start_time, end_time;
>  		int num_paths = 0, strict_timing, rc = 0;
