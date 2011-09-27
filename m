From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: add default hardware configs.
Date: Tue, 27 Sep 2011 23:04:06 +0200
Message-ID: <1317157446.26449.2.camel@lapoo.opensvc.com>
References: <20110927205052.GX24133@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110927205052.GX24133@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On mar., 2011-09-27 at 15:50 -0500, Benjamin Marzinski wrote:
> Here are some hardware configs I've received from vendors, that haven't made it
> upstream yet, along with a little bit of cleanup. The changes come from Redhat
> BZ #622569, #636213, and #694602
> 
ok. applied.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/hwtable.c |   60 ++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 40 insertions(+), 20 deletions(-)
> 
> Index: multipath-tools-110916/libmultipath/hwtable.c
> ===================================================================
> --- multipath-tools-110916.orig/libmultipath/hwtable.c
> +++ multipath-tools-110916/libmultipath/hwtable.c
> @@ -242,6 +242,24 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = DEFAULT_PRIO,
>  		.prio_args     = NULL,
>  	},
> +	{
> +		/* HP P2000 family arrays */
> +		.vendor        = "HP",
> +		.product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI",
> +		.getuid        = DEFAULT_GETUID,
> +		.features      = DEFAULT_FEATURES,
> +		.hwhandler     = DEFAULT_HWHANDLER,
> +		.selector      = DEFAULT_SELECTOR,
> +		.pgpolicy      = GROUP_BY_PRIO,
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.rr_weight     = RR_WEIGHT_NONE,
> +		.no_path_retry = 18,
> +		.minio         = 100,
> +		.minio_rq      = DEFAULT_MINIO_RQ,
> +		.checker_name  = TUR,
> +		.prio_name     = PRIO_ALUA,
> +		.prio_args     = NULL,
> +	},
>  	/*
>  	 * DDN controller family
>  	 *
> @@ -281,10 +299,10 @@ static struct hwentry default_hw[] = {
>  		.pgpolicy      = MULTIBUS,
>  		.pgfailback    = FAILBACK_UNDEF,
>  		.rr_weight     = RR_WEIGHT_NONE,
> -		.no_path_retry = NO_PATH_RETRY_UNDEF,
> +		.no_path_retry = 6,
>  		.minio         = DEFAULT_MINIO,
>  		.minio_rq      = DEFAULT_MINIO_RQ,
> -		.checker_name  = DIRECTIO,
> +		.checker_name  = TUR,
>  		.prio_name     = DEFAULT_PRIO,
>  		.prio_args     = NULL,
>  	},
> @@ -320,6 +338,7 @@ static struct hwentry default_hw[] = {
>  		.no_path_retry = 5,
>  		.minio         = DEFAULT_MINIO,
>  		.minio_rq      = DEFAULT_MINIO_RQ,
> +		.checker_name  = TUR,
>  		.prio_name     = DEFAULT_PRIO,
>  		.prio_args     = NULL,
>  	},
> @@ -346,24 +365,6 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = DEFAULT_PRIO,
>  		.prio_args     = NULL,
>  	},
> -	{
> -		.vendor        = "EMC",
> -		.product       = "Invista",
> -		.bl_product    = "LUNZ",
> -		.getuid        = DEFAULT_GETUID,
> -		.features      = DEFAULT_FEATURES,
> -		.hwhandler     = DEFAULT_HWHANDLER,
> -		.selector      = DEFAULT_SELECTOR,
> -		.pgpolicy      = FAILOVER,
> -		.pgfailback    = FAILBACK_UNDEF,
> -		.rr_weight     = RR_WEIGHT_NONE,
> -		.no_path_retry = 5,
> -		.minio         = DEFAULT_MINIO,
> -		.minio_rq      = DEFAULT_MINIO_RQ,
> -		.checker_name  = TUR,
> -		.prio_name     = DEFAULT_PRIO,
> -		.prio_args     = NULL,
> -	},
>  	/*
>  	 * Hitachi controller family
>  	 *
> @@ -752,6 +753,24 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = PRIO_ALUA,
>  		.prio_args     = NULL,
>  	},
> +	{
> +		/* IBM RSSM */
> +		.vendor        = "IBM",
> +		.product       = "1820N00",
> +		.getuid        = DEFAULT_GETUID,
> +		.features      = DEFAULT_FEATURES,
> +		.hwhandler     = DEFAULT_HWHANDLER,
> +		.selector      = DEFAULT_SELECTOR,
> +		.pgpolicy      = GROUP_BY_PRIO,
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.rr_weight     = RR_WEIGHT_NONE,
> +		.no_path_retry = NO_PATH_RETRY_QUEUE,
> +		.minio         = 100,
> +		.minio_rq      = DEFAULT_MINIO_RQ,
> +		.checker_name  = TUR,
> +		.prio_name     = PRIO_ALUA,
> +		.prio_args     = NULL,
> +	},
>  	/*
>  	 * IBM Power Virtual SCSI Devices
>  	 *
> @@ -1110,6 +1129,7 @@ static struct hwentry default_hw[] = {
>  		.minio_rq      = DEFAULT_MINIO_RQ,
>  		.checker_name  = DEFAULT_CHECKER,
>  		.prio_name     = DEFAULT_PRIO,
> +		.prio_args     = NULL,
>  	},
>  	/*
>  	 * Pivot3 RAIGE
