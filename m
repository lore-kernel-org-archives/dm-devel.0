From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 4/7] libmultipath: merge_hwe: fix
	queue_if_no_path logic
Date: Thu, 15 Jun 2017 14:55:56 -0500
Message-ID: <20170615195556.GF2940@octiron.msp.redhat.com>
References: <20170613225554.11181-1-mwilck@suse.com>
	<20170613225554.11181-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170613225554.11181-5-mwilck@suse.com>
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

On Wed, Jun 14, 2017 at 12:55:51AM +0200, Martin Wilck wrote:
> The logic applied here should match the logic in select_features().
> If no_path_retry is anything but "undef", queue_if_no_path can be
> removed from the feature string, assemble_map() will infer it
> correctly.
> The case where no_path_retry is undefined and "queue_if_no_path"
> is set is treated as if "no_path_retry queue" had been set.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 61bbba91..b928fbe7 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -355,12 +355,24 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
>  
>  	/*
>  	 * Make sure features is consistent with
> -	 * no_path_retry
> +	 * no_path_retry.
> +	 * The logic should be consistent with select_features().
> +	 * The actual queue_if_no_path feature is set in assemble_map().
>  	 */
> -	if (dst->no_path_retry == NO_PATH_RETRY_FAIL)
> +	if (dst->no_path_retry == NO_PATH_RETRY_UNDEF &&
> +	    strstr(dst->features, "queue_if_no_path")) {
> +		condlog(3, "%s/%s: 'queue_if_no_path' is set, assuming no_path_retry='queue'",
> +			dst->vendor, dst->product);
> +		dst->no_path_retry = NO_PATH_RETRY_QUEUE;
> +	}
> +	else if (dst->no_path_retry != NO_PATH_RETRY_UNDEF) {
> +		condlog(3, "%s/%s: 'no_path_retry' is set, ignoring 'queue_if_no_path'",
> +			dst->vendor, dst->product);
>  		remove_feature(&dst->features, "queue_if_no_path");

This has the same nit as [PATCH 3/7], and it's just as unimportant to
fix here as there.

-Ben

> -	else if (dst->no_path_retry != NO_PATH_RETRY_UNDEF)
> -		add_feature(&dst->features, "queue_if_no_path");
> +	}
> +
> +	if (dst->retain_hwhandler != RETAIN_HWHANDLER_UNDEF)
> +		remove_feature(&dst->features, "retain_attached_hw_handler");
>  
>  	return 0;
>  }
> -- 
> 2.13.0
