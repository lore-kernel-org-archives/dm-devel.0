From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 11/21] multipathd: improve checker message
	logging
Date: Thu, 25 Oct 2018 16:32:59 -0500
Message-ID: <20181025213259.GT7100@octiron.msp.redhat.com>
References: <20181011222707.3631-1-mwilck@suse.com>
	<20181011222707.3631-12-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181011222707.3631-12-mwilck@suse.com>
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

On Fri, Oct 12, 2018 at 12:26:57AM +0200, Martin Wilck wrote:
> Don't rely on any variables being defined in LOG_MSG.
> If message log level is low, don't bother to fetch the message.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index a9e1a4bd..1bd1518a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -89,12 +89,22 @@ static int use_watchdog;
>  #define FILE_NAME_SIZE 256
>  #define CMDSIZE 160
>  
> -#define LOG_MSG(a, b) \
> -do { \
> -	if (pp->offline) \
> -		condlog(a, "%s: %s - path offline", pp->mpp->alias, pp->dev); \
> -	else if (strlen(b)) \
> -		condlog(a, "%s: %s - %s", pp->mpp->alias, pp->dev, b); \
> +#define LOG_MSG(lvl, verb, pp)					\
> +do {								\
> +	if (lvl <= verb) {					\
> +		if (pp->offline)				\
> +			condlog(lvl, "%s: %s - path offline",	\
> +				pp->mpp->alias, pp->dev);	\
> +		else {						\
> +			const char *__m =			\
> +				checker_message(&pp->checker);	\
> +								\
> +			if (strlen(__m))			\
> +				condlog(lvl, "%s: %s - %s",	\
> +					pp->mpp->alias,		\
> +					pp->dev, __m);		\
> +		}						\
> +	}							\
>  } while(0)
>  
>  struct mpath_event_param
> @@ -1811,7 +1821,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  	int add_active;
>  	int disable_reinstate = 0;
>  	int oldchkrstate = pp->chkrstate;
> -	int retrigger_tries, checkint;
> +	int retrigger_tries, checkint, verbosity;
>  	struct config *conf;
>  	int ret;
>  
> @@ -1827,6 +1837,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  	conf = get_multipath_config();
>  	retrigger_tries = conf->retrigger_tries;
>  	checkint = conf->checkint;
> +	verbosity = conf->verbosity;
>  	put_multipath_config(conf);
>  	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV) {
>  		if (pp->retriggers < retrigger_tries) {
> @@ -1961,7 +1972,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  		int oldstate = pp->state;
>  		pp->state = newstate;
>  
> -		LOG_MSG(1, checker_message(&pp->checker));
> +		LOG_MSG(1, verbosity, pp);
>  
>  		/*
>  		 * upon state change, reset the checkint
> @@ -2050,7 +2061,8 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  			}
>  		} else {
>  			unsigned int max_checkint;
> -			LOG_MSG(4, checker_message(&pp->checker));
> +
> +			LOG_MSG(4, verbosity, pp);
>  			conf = get_multipath_config();
>  			max_checkint = conf->max_checkint;
>  			put_multipath_config(conf);
> @@ -2083,9 +2095,9 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  			log_checker_err = conf->log_checker_err;
>  			put_multipath_config(conf);
>  			if (log_checker_err == LOG_CHKR_ERR_ONCE)
> -				LOG_MSG(3, checker_message(&pp->checker));
> +				LOG_MSG(3, verbosity, pp);
>  			else
> -				LOG_MSG(2, checker_message(&pp->checker));
> +				LOG_MSG(2, verbosity, pp);
>  		}
>  	}
>  
> -- 
> 2.19.0
