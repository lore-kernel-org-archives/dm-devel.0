From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 1/2] multipath: Merge the DELL MD3xxx device
	configs
Date: Sun, 7 May 2017 02:32:33 +0200
Message-ID: <fb475d15-1a7b-fe56-7977-578d44ceaaf4@gmail.com>
References: <1492035310-27525-1-git-send-email-bmarzins@redhat.com>
	<1492035310-27525-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1492035310-27525-2-git-send-email-bmarzins@redhat.com>
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
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Vijay Chauhan <Vijay.Chauhan@netapp.com>, "Stewart,
	Sean" <Sean.Stewart@netapp.com>, "Schremmer,
	Steven" <Steve.Schremmer@netapp.com>
List-Id: dm-devel.ids

On 04/13/2017 12:15 AM, Benjamin Marzinski wrote:

> All of the Dell MD3xxx configs are identical, so we can't just use
> one config for them.

If you do that to simplify the config file or minimize the number of
RDAC entries. More of them, from (NETAPP|LSI|ENGENIO) IBM SGI STK SUN,
can be consolidated: grep -B7 -A2 "PRIO_RDAC" libmultipath/hwtable.c


BTW, I did send time ago a kernel patch related to RDAC arrays and
it's still waiting for ACK: https://marc.info/?l=linux-scsi&m=147585935707470

> Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/hwtable.c | 26 +-------------------------
>  1 file changed, 1 insertion(+), 25 deletions(-)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index c944015..54309ef 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -227,31 +227,7 @@ static struct hwentry default_hw[] = {
>  		/* MD Series */
>  	{
>  		.vendor        = "DELL",
> -		.product       = "MD3000",
> -		.bl_product    = "Universal Xport",
> -		.pgpolicy      = GROUP_BY_PRIO,
> -		.checker_name  = RDAC,
> -		.features      = "2 pg_init_retries 50",
> -		.hwhandler     = "1 rdac",
> -		.prio_name     = PRIO_RDAC,
> -		.pgfailback    = -FAILBACK_IMMEDIATE,
> -		.no_path_retry = 30,
> -	},
> -	{
> -		.vendor        = "DELL",
> -		.product       = "(MD32xx|MD36xx)",
> -		.bl_product    = "Universal Xport",
> -		.pgpolicy      = GROUP_BY_PRIO,
> -		.checker_name  = RDAC,
> -		.features      = "2 pg_init_retries 50",
> -		.hwhandler     = "1 rdac",
> -		.prio_name     = PRIO_RDAC,
> -		.pgfailback    = -FAILBACK_IMMEDIATE,
> -		.no_path_retry = 30,
> -	},
> -	{
> -		.vendor        = "DELL",
> -		.product       = "(MD34xx|MD38xx)",
> +		.product       = "^MD3",
>  		.bl_product    = "Universal Xport",
>  		.pgpolicy      = GROUP_BY_PRIO,
>  		.checker_name  = RDAC,
>
