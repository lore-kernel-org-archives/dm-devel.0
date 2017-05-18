From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: Replace multipath
	configuration output
Date: Thu, 18 May 2017 02:06:27 +0200
Message-ID: <1a35a769-0d7d-7ed7-17b8-1d8c5093059a@gmail.com>
References: <20170418000756.13970-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170418000756.13970-1-xose.vazquez@gmail.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 04/18/2017 02:07 AM, Xose Vazquez Perez wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

This is missing.

> ---
>  libmultipath/propsel.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 09fe728..782f039 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -286,11 +286,11 @@ out:
>  		if (mp->no_path_retry == NO_PATH_RETRY_UNDEF)
>  			mp->no_path_retry = NO_PATH_RETRY_QUEUE;
>  		else if (mp->no_path_retry == NO_PATH_RETRY_FAIL) {
> -			condlog(1, "%s: config error, overriding 'no_path_retry' value",
> +			condlog(1, "%s: config ERROR (setting: overriding 'no_path_retry' value)",
>  				mp->alias);
>  			mp->no_path_retry = NO_PATH_RETRY_QUEUE;
>  		} else if (mp->no_path_retry != NO_PATH_RETRY_QUEUE)
> -			condlog(1, "%s: config error, ignoring 'queue_if_no_path' because no_path_retry=%d",
> +			condlog(1, "%s: config ERROR (setting: ignoring 'queue_if_no_path' because no_path_retry = %d)",
>  				mp->alias, mp->no_path_retry);
>  	}
>  	return 0;
> @@ -470,7 +470,7 @@ out:
>  		condlog(3, "%s: no_path_retry = %s %s", mp->alias, buff,
>  			origin);
>  	else if (mp->no_path_retry != NO_PATH_RETRY_UNDEF)
> -		condlog(3, "%s: no_path_retry = %s (inherited setting)",
> +		condlog(3, "%s: no_path_retry = %s (setting: inherited value)",
>  			mp->alias, buff);
>  	else
>  		condlog(3, "%s: no_path_retry = undef (setting: multipath internal)",
> 
