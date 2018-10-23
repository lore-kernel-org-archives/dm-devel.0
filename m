From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 08/10] multipathd: handle repeated udev
 retrigger failure
Date: Tue, 23 Oct 2018 14:56:05 -0500
Message-ID: <20181023195605.GB7100@octiron.msp.redhat.com>
References: <20181023134348.17915-1-mwilck@suse.com>
	<20181023134348.17915-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181023134348.17915-3-mwilck@suse.com>
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

On Tue, Oct 23, 2018 at 03:43:46PM +0200, Martin Wilck wrote:
> If a path was still not properly initialized after exhausting the
> retrigger tries, it used to remain in INIT_MISSING_UDEV state forever.
> get_uid() might fall back to non-udev-based methods to determine
> the WWID, but it would never be called for a path in this state any more.
> 
> This patch changes this behavior by resetting the path back to FAILED
> state if udev can't provide the WWID even after retriggering. Now, if
> the path ever happens to be in PATH_UP or PATH_GHOST state again,
> pathinfo(DI_ALL) will be called from check_path(), and there's at least
> some chance to obtain a WWID for it.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipathd/main.c | 32 +++++++++++++++++++++++---------
>  1 file changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 2d45d989..a9e1a4bd 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1828,15 +1828,29 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  	retrigger_tries = conf->retrigger_tries;
>  	checkint = conf->checkint;
>  	put_multipath_config(conf);
> -	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV &&
> -	    pp->retriggers < retrigger_tries) {
> -		condlog(2, "%s: triggering change event to reinitialize",
> -			pp->dev);
> -		pp->initialized = INIT_REQUESTED_UDEV;
> -		pp->retriggers++;
> -		sysfs_attr_set_value(pp->udev, "uevent", "change",
> -				     strlen("change"));
> -		return 0;
> +	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV) {
> +		if (pp->retriggers < retrigger_tries) {
> +			condlog(2, "%s: triggering change event to reinitialize",
> +				pp->dev);
> +			pp->initialized = INIT_REQUESTED_UDEV;
> +			pp->retriggers++;
> +			sysfs_attr_set_value(pp->udev, "uevent", "change",
> +					     strlen("change"));
> +			return 0;
> +		} else {
> +			condlog(1, "%s: not initialized after %d udev retriggers",
> +				pp->dev, retrigger_tries);
> +			/*
> +			 * Make sure that the "add missing path" code path
> +			 * below may reinstate the path later, if it ever
> +			 * comes up again.
> +			 * The WWID needs not be cleared; if it was set, the
> +			 * state hadn't been INIT_MISSING_UDEV in the first
> +			 * place.
> +			 */
> +			pp->initialized = INIT_FAILED;
> +			return 0;
> +		}
>  	}
>  
>  	/*
> -- 
> 2.19.1
