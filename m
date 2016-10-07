From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: add NexGen arrays to hwtable
Date: Fri, 7 Oct 2016 16:03:20 +0200
Message-ID: <d5356e17-547b-0f89-5a48-4d15e4c363b5@gmail.com>
References: <20161007133344.3858-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161007133344.3858-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brian Auld <bauld@pivot3.com>, Bart Brooks <bbrooks@pivot3.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/07/2016 03:33 PM, Xose Vazquez Perez wrote:

> Based on info provided by the manufacturer.

Please drop this one, replaced by v2.
Thank you.

> Cc: Brian Auld <bauld@pivot3.com>
> Cc: Bart Brooks <bbrooks@pivot3.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index ff6989d..5ec63c8 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -776,6 +776,14 @@ static struct hwentry default_hw[] = {
>  		.no_path_retry = NO_PATH_RETRY_QUEUE,
>  		.pgpolicy      = MULTIBUS,
>  	},
> +	{
> +		.vendor        = "(NexGen|Pivot3)",
> +		.product       = "TierStore",
> +		.pgpolicy      = GROUP_BY_PRIO,
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.prio_name     = PRIO_ALUA,
> +		.no_path_retry = NO_PATH_RETRY_QUEUE,
> +	},
>  	/*
>  	 * Intel
>  	 */
> 
