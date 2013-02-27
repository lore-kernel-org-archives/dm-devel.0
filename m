From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH]multipath-tools: Adding major:minor to
 multipathd logging for device discovery and removal
Date: Wed, 27 Feb 2013 21:54:01 +0100
Message-ID: <1361998441.3199.0.camel@lapoo.opensvc.com>
References: <F200AD42A082BC4088B232D13A916A89271FC620@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F200AD42A082BC4088B232D13A916A89271FC620@SACEXCMBX02-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On mer., 2013-02-27 at 14:05 +0000, Chauhan, Vijay wrote:
> Path name, HCTL and major:minor (for ex: srp and mptsas) could change during subsequent
> rediscovery of path and it becomes difficult to associate the paths with dm device using
> default verbosity in the syslog (when there are large number of dm device configured).
> multipathd logs few messages with path name and others with major:minor. We need to have
> association between  major:minor and device name with default verbosity.
> 
Right, applied.

Best regards,
Christophe Varoqui
www.opensvc.com

> Signed-off-by: Vijay Chauhan <vijay.chauhan@netapp.com>
> ---
> multipathd/main.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> This patch adds major:minor to log for path addition and path removal.
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7f83a7a..95264fc 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -531,7 +531,8 @@ rescan:
>  			goto fail_map;
>  
>  	if (retries >= 0) {
> -		condlog(2, "%s path added to devmap %s", pp->dev, mpp->alias);
> +		condlog(2, "%s [%s]: path added to devmap %s",
> +			pp->dev, pp->dev_t, mpp->alias);
>  		return 0;
>  	}
>  	else
> @@ -636,8 +637,8 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
>  			}
>  			sync_map_state(mpp);
>  
> -			condlog(2, "%s: path removed from map %s",
> -				pp->dev, mpp->alias);
> +			condlog(2, "%s [%s]: path removed from map %s",
> +				pp->dev, pp->dev_t, mpp->alias);
>  		}
>  	}
> 
> --
