From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 07/19] multipathd: set_config_state(): avoid
 code duplication
Date: Sat, 19 Sep 2020 14:01:01 -0500
Message-ID: <20200919190101.GV11108@octiron.msp.redhat.com>
References: <20200916153718.582-1-mwilck@suse.com>
	<20200916153718.582-8-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200916153718.582-8-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 16, 2020 at 05:37:06PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Use __post_config_state() and __wait_for_state_change(). This
> way __post_config_state() is the only place where running_state
> is ever changed, and we avoid code duplication.
> 

It's only tangentially related to this patch, but it's possible for
set_conf_state() to timeout, and we'd don't always retry it. That's
fine, be we don't always check for failure and notify the user that the
reconfigure isn't happening, and we probably should. But the patch
itself is fine.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com> 

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 23 +++++------------------
>  1 file changed, 5 insertions(+), 18 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 49809e0..a5c4031 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -292,27 +292,14 @@ int set_config_state(enum daemon_status state)
>  	pthread_cleanup_push(config_cleanup, NULL);
>  	pthread_mutex_lock(&config_lock);
>  	if (running_state != state) {
> -#ifdef USE_SYSTEMD
> -		enum daemon_status old_state = running_state;
> -#endif
>  
>  		if (running_state == DAEMON_SHUTDOWN)
>  			rc = EINVAL;
> -		else if (running_state != DAEMON_IDLE) {
> -			struct timespec ts;
> -
> -			get_monotonic_time(&ts);
> -			ts.tv_sec += 1;
> -			rc = pthread_cond_timedwait(&config_cond,
> -						    &config_lock, &ts);
> -		}
> -		if (!rc && (running_state != DAEMON_SHUTDOWN)) {
> -			running_state = state;
> -			pthread_cond_broadcast(&config_cond);
> -#ifdef USE_SYSTEMD
> -			do_sd_notify(old_state, state);
> -#endif
> -		}
> +		else
> +			rc = __wait_for_state_change(
> +				running_state != DAEMON_IDLE, 1000);
> +		if (!rc)
> +			__post_config_state(state);
>  	}
>  	pthread_cleanup_pop(1);
>  	return rc;
> -- 
> 2.28.0
