From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: add VIOLIN/CONCERTO ARRAY
 to hardware table
Date: Wed, 15 Jun 2016 18:21:44 +0200
Message-ID: <2a0c5539-94a1-3d37-7207-392bb3e56511@gmail.com>
References: <1465566967-8417-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1465566967-8417-1-git-send-email-xose.vazquez@gmail.com>
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

On 06/10/2016 03:56 PM, Xose Vazquez Perez wrote:

> based on documentation provided by manufacturer:
> https://drive.google.com/open?id=0B_B6YmEmO7cDQlMzc1BsaUxZRVU

Please, DROP this patch. It's buggy.

>  libmultipath/hwtable.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 66b5123..a9cd080 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1176,6 +1176,25 @@ static struct hwentry default_hw[] = {
>  		.checker_name  = TUR,
>  	},
>  	/*
> +	 * Violin Memory, Inc.
> +	 *
> +	 * Maintainer : Christophe Varoqui
> +	 * Mail : christophe.varoqui@opensvc.com
> +	 */
> +	{
> +		.vendor        = "VIOLIN",
> +		.product       = "CONCERTO ARRAY",
> +		.selector      = "round-robin 0",
> +		.pgpolicy      = MULTIBUS,
> +		.prio_name     = PRIO_ALUA,
> +		.checker_name  = TUR,
> +		.minio         = 100,
> +		.rr_weight     = priorities,
                                 ^^^^^^^^^^^
It should be  RR_WEIGHT_PRIO

> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.features      = "1 queue_if_no_path",
> +		.no_path_retry = 300,
> +	},
> +	/*
>  	 * EOL
>  	 */
>  	{
> 
