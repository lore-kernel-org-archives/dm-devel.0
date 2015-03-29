From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 30/78] Update hwtable for EMC XtremIO
Date: Sun, 29 Mar 2015 22:24:51 +0200
Message-ID: <55185F93.9090604@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, device-mapper development <dm-devel@redhat.com>, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

Hannes Reinecke wrote:

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/hwtable.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index ead4d48..13611fe 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -289,6 +289,19 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = DEFAULT_PRIO,
>  		.prio_args     = NULL,
>  	},
> +	{
> +		.vendor        = "XtremIO",
> +		.product       = "XtremApp",
> +		.features      = DEFAULT_FEATURES,
> +		.hwhandler     = DEFAULT_HWHANDLER,
> +		.pgpolicy      = MULTIBUS,
> +		.pgfailback    = FAILBACK_UNDEF,
> +		.rr_weight     = RR_WEIGHT_NONE,
> +		.no_path_retry = 5,
> +		.checker_name  = TUR,
> +		.prio_name     = DEFAULT_PRIO,
> +		.prio_args     = NULL,
> +	},
>  	/*
>  	 * Fujitsu controller family
>  	 *

This patch[b47e607408e1edce3a03744b4aefa292723c7fc6] *add* a new
XtremIO/XtremApp entry. Instead of replacing the old values.
