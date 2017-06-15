From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 3/7] libmultipath: clarify option conflicts
	for "features"
Date: Thu, 15 Jun 2017 14:54:36 -0500
Message-ID: <20170615195436.GE2940@octiron.msp.redhat.com>
References: <20170613225554.11181-1-mwilck@suse.com>
	<20170613225554.11181-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170613225554.11181-4-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Wed, Jun 14, 2017 at 12:55:50AM +0200, Martin Wilck wrote:
> The "features" option in multipath.conf can possibly conflict
> with the "no_path_retry" and "retain_attached_hw_handler" options.
> 
> Currently, "no_path_retry" takes precedence, unless it is set to
> "fail", in which case it's overridden. No precedence rules are
> defined for "retain_attached_hw_handler".
> 
> Make this behavior more consistent by always giving precedence
> to the explicit config file options, and improve logging.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c |  4 ++--
>  libmultipath/propsel.c   | 37 ++++++++++++++++++++++++-------------
>  2 files changed, 26 insertions(+), 15 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index bd090d9a..fd4721dd 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -280,11 +280,11 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
>  	select_pgfailback(conf, mpp);
>  	select_pgpolicy(conf, mpp);
>  	select_selector(conf, mpp);
> -	select_features(conf, mpp);
>  	select_hwhandler(conf, mpp);
> +	select_no_path_retry(conf, mpp);
> +	select_features(conf, mpp);
>  	select_rr_weight(conf, mpp);
>  	select_minio(conf, mpp);
> -	select_no_path_retry(conf, mpp);
>  	select_mode(conf, mpp);
>  	select_uid(conf, mpp);
>  	select_gid(conf, mpp);
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 99d17e65..4267aa04 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -272,6 +272,9 @@ out:
>  int select_features(struct config *conf, struct multipath *mp)
>  {
>  	char *origin;
> +	char buff[12];
> +	static const char q_i_n_p[] = "queue_if_no_path";
> +	static const char r_a_h_h[] = "retain_attached_hw_handler";
>  
>  	mp_set_mpe(features);
>  	mp_set_ovr(features);
> @@ -280,19 +283,30 @@ int select_features(struct config *conf, struct multipath *mp)
>  	mp_set_default(features, DEFAULT_FEATURES);
>  out:
>  	mp->features = STRDUP(mp->features);
> -	condlog(3, "%s: features = \"%s\" %s", mp->alias, mp->features, origin);
>  
> -	if (strstr(mp->features, "queue_if_no_path")) {
> -		if (mp->no_path_retry == NO_PATH_RETRY_UNDEF)
> +	if (strstr(mp->features, q_i_n_p)) {
> +		if (mp->no_path_retry == NO_PATH_RETRY_UNDEF) {
>  			mp->no_path_retry = NO_PATH_RETRY_QUEUE;
> -		else if (mp->no_path_retry == NO_PATH_RETRY_FAIL) {
> -			condlog(1, "%s: config error, overriding 'no_path_retry' value",
> -				mp->alias);
> -			mp->no_path_retry = NO_PATH_RETRY_QUEUE;
> -		} else if (mp->no_path_retry != NO_PATH_RETRY_QUEUE)
> -			condlog(1, "%s: config error, ignoring 'queue_if_no_path' because no_path_retry=%d",
> -				mp->alias, mp->no_path_retry);
> +			print_no_path_retry(buff, sizeof(buff),
> +					    &mp->no_path_retry);
> +			condlog(3, "%s: no_path_retry = %s (inherited setting from feature '%s')",
> +				mp->alias, buff, q_i_n_p);
> +		} else {
> +			print_no_path_retry(buff, sizeof(buff),
> +					    &mp->no_path_retry);
> +			condlog(2, "%s: ignoring feature '%s' because no_path_retry is set to '%s'",
> +				mp->alias, q_i_n_p, buff);
> +			remove_feature(&mp->features, q_i_n_p);
> +		};

This is just a nit, and it won't hurt anything by remaining unfixed, but
it is odd that if you go into select_features() with no_path_retry set
to queue (for any length of time) and features includes
"queue_if_no_path", you will exit with no_path_retry still set to queue
and "queue_if_no_path" removed from features. However if you go into
select_features with no_path_retry set to undef and features includes
"queue_if_no_path", you will exit with no_path_retry set to queue and
"queue_if_no_path" still included in features. It seems odd that in the
second case, you explicitly set these options to the values that you
started with in the first case (which you later changed). A perhaps more
sensible option would be to only remove "queue_if_no_path" from features
if no_path_retry is set to something other than NO_PATH_RETRY_QUEUE.

-Ben

>  	}
> +	if (strstr(mp->features, r_a_h_h) &&
> +	    mp->retain_hwhandler == RETAIN_HWHANDLER_OFF) {
> +		condlog(2, "%s: ignoring feature '%s' because %s is set to 'off'",
> +			mp->alias, r_a_h_h, r_a_h_h);
> +		remove_feature(&mp->features, r_a_h_h);
> +	}
> +
> +	condlog(3, "%s: features = \"%s\" %s", mp->alias, mp->features, origin);
>  	return 0;
>  }
>  
> @@ -469,9 +483,6 @@ out:
>  	if (origin)
>  		condlog(3, "%s: no_path_retry = %s %s", mp->alias, buff,
>  			origin);
> -	else if (mp->no_path_retry != NO_PATH_RETRY_UNDEF)
> -		condlog(3, "%s: no_path_retry = %s (inherited setting)",
> -			mp->alias, buff);
>  	else
>  		condlog(3, "%s: no_path_retry = undef (setting: multipath internal)",
>  			mp->alias);
> -- 
> 2.13.0
