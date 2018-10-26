From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 6/7] multipathd: make DAEMON_SHUTDOWN a
	terminal state
Date: Fri, 26 Oct 2018 15:50:11 -0500
Message-ID: <20181026205011.GK7100@octiron.msp.redhat.com>
References: <20181023220552.1306-1-mwilck@suse.com>
	<20181023220552.1306-7-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181023220552.1306-7-mwilck@suse.com>
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

On Wed, Oct 24, 2018 at 12:05:51AM +0200, Martin Wilck wrote:
> It can happen that, before the main thread reacts on DAEMON_SHUTDOWN
> and starts cancelling threads, another thread resets the state to
> something else. Fix that.
> 

Reviewed-by: Benjamin Marzinsk <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/cli_handlers.c |  9 +++++++--
>  multipathd/main.c         | 10 +++++++---
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 4aea4ce7..a0d57a53 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1124,12 +1124,17 @@ cli_switch_group(void * v, char ** reply, int * len, void * data)
>  int
>  cli_reconfigure(void * v, char ** reply, int * len, void * data)
>  {
> +	int rc;
> +
>  	condlog(2, "reconfigure (operator)");
>  
> -	if (set_config_state(DAEMON_CONFIGURE) == ETIMEDOUT) {
> +	rc = set_config_state(DAEMON_CONFIGURE); 
> +	if (rc == ETIMEDOUT) {
>  		condlog(2, "timeout starting reconfiguration");
>  		return 1;
> -	}
> +	} else if (rc == EINVAL)
> +		/* daemon shutting down */
> +		return 1;
>  	return 0;
>  }
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index c71e7d03..768da8da 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -207,7 +207,7 @@ static void config_cleanup(void *arg)
>  
>  static void __post_config_state(enum daemon_status state)
>  {
> -	if (state != running_state) {
> +	if (state != running_state && running_state != DAEMON_SHUTDOWN) {
>  		enum daemon_status old_state = running_state;
>  
>  		running_state = state;
> @@ -235,7 +235,9 @@ int set_config_state(enum daemon_status state)
>  	if (running_state != state) {
>  		enum daemon_status old_state = running_state;
>  
> -		if (running_state != DAEMON_IDLE) {
> +		if (running_state == DAEMON_SHUTDOWN)
> +			rc = EINVAL;
> +		else if (running_state != DAEMON_IDLE) {
>  			struct timespec ts;
>  
>  			clock_gettime(CLOCK_MONOTONIC, &ts);
> @@ -2204,7 +2206,9 @@ checkerloop (void *ap)
>  		if (rc == ETIMEDOUT) {
>  			condlog(4, "timeout waiting for DAEMON_IDLE");
>  			continue;
> -		}
> +		} else if (rc == EINVAL)
> +			/* daemon shutdown */
> +			break;
>  
>  		pthread_cleanup_push(cleanup_lock, &vecs->lock);
>  		lock(&vecs->lock);
> -- 
> 2.19.1
