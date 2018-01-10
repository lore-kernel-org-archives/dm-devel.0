From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCHv2] Fill NVMe specific path info
Date: Wed, 10 Jan 2018 17:07:07 +0100
Message-ID: <0455c3f8-423e-a639-da1f-8492cd3843fb@gmail.com>
References: <1487715151-1179-1-git-send-email-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1487715151-1179-1-git-send-email-keith.busch@intel.com>
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
To: Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 02/21/2017 11:12 PM, Keith Busch wrote:

> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index f5a5f7b..8409261 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1073,6 +1073,16 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = PRIO_ALUA,
>  		.no_path_retry = 30,
>  	},
> +	/*
> +	 * Generic NVMe devices
> +	 */
> +	{
> +		.vendor	       = "NVME",
> +		.product       = ".*",
> +		.uid_attribute = "ID_WWN",
> +		.checker_name  = DIRECTIO,
> +		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
> +	},

Try #2.

"NVME" is a too generic regex, could it be replaced by "^NVME" and a "product name"?

Thanks.
