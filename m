From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 05/57] Add HP MSA 2040 to the hardware table
Date: Fri, 29 Apr 2016 00:06:05 +0200
Message-ID: <20160429000605.00006561@localhost>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-6-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Sebastian Herbszt <herbszt@gmx.de>, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/hwtable.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)

You missed adding it to multipath.conf.defaults.

> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index a4ae053..28ee595 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -175,6 +175,21 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = PRIO_ALUA,
>  		.prio_args     = NULL,
>  	},
> +	{
> +		/* HP MSA 1040/2040 product family */
> +		.vendor        = "HP",
> +		.product       = "MSA (1|2)040 SA(N|S)",
> +		.features      = DEFAULT_FEATURES,
> +		.hwhandler     = DEFAULT_HWHANDLER,
> +		.pgpolicy      = GROUP_BY_PRIO,
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.rr_weight     = RR_WEIGHT_NONE,
> +		.no_path_retry = 18,
> +		.minio         = 100,
> +		.checker_name  = TUR,
> +		.prio_name     = PRIO_ALUA,
> +		.prio_args     = NULL,
> +	},
>  
>  	{
>  		/* HP SVSP */

Any reason for a separate entry and not merging it with
"HP MSA2000 product family with new firmware" ?

Sebastian
