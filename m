From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] libmultipath: update INFINIDAT builtin config
Date: Fri, 25 Aug 2017 02:26:55 +0200
Message-ID: <364c3650-ef7d-5a17-6e34-a32f34ab31e7@gmail.com>
References: <392CDE41-4C36-41B1-8811-B7EC93F0864C@infinidat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <392CDE41-4C36-41B1-8811-B7EC93F0864C@infinidat.com>
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
To: Arnon Yaari <arnony@infinidat.com>, dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 08/22/2017 03:37 PM, Arnon Yaari wrote:

> Based on the manufacturer documentation:
> https://support.infinidat.com/hc/en-us/articles/202319222
> 
> Signed-off-by: Arnon Yaari <arnony@infinidat.com>

NACK.

> ---
>  libmultipath/hwtable.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 9e14ec1e..1ea48d58 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -969,8 +969,18 @@ static struct hwentry default_hw[] = {
>  		.vendor        = "NFINIDAT",
>  		.product       = "InfiniBox",
>  		.pgpolicy      = GROUP_BY_PRIO,

> -		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.pgfailback    = 30,

Why is it needed?

>  		.prio_name     = PRIO_ALUA,
> +		.checker_name  = TUR,

Default value.

> +		.selector      = "round-robin 0",

round-robin is the dumbest, queue-length is smarter and
service-time is the smartest and default selector.

> +		.features      = "0",

Default value.

> +		.rr_weight     = RR_WEIGHT_PRIO,

Useless with service-time

> +		.no_path_retry = NO_PATH_RETRY_FAIL,

Default value.

> +		.minio         = 1,

Useless with service-time

> +		.minio_rq      = 1,

Useless with service-time

> +		.flush_on_last_del = FLUSH_ENABLED,

Why is it needed?

> +		.fast_io_fail  = 15,

Why is it needed?

> +		.dev_loss      = 15,

Why is it needed?

>  	},
>  	/*
>  	 * Nimble Storage
> 
There is minimal info on how to send patches at the header of hwtable.c
$ grep -A64 "Tuning suggestions" libmultipath/hwtable.c | less -S


Thank you.
