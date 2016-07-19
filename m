From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 4/4] multipath-tools: Add rbd to the hwtable
Date: Tue, 19 Jul 2016 14:28:46 +0200
Message-ID: <51fbbde1-0d01-09b6-3c22-8624ad4685c2@gmail.com>
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
To: Mike Christie <mchristi@redhat.com>, device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

Mike Christie wrote:

> Add rbd to hwtable. These defaults are for the HA type of setup
> supported by the checker. We do no support features like multibus
> at the dm-multipath level yet.

Please use this patch as guide:
https://patchwork.kernel.org/patch/9225521/

> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  libmultipath/hwtable.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 6116124..27a6ff1 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1206,6 +1206,21 @@ static struct hwentry default_hw[] = {
>  		.pgfailback    = 30,
>  		.minio         = 128,
>  	},
> +	{
> +		.vendor        = "Ceph",
> +		.product       = "RBD",
> +		.features      = DEFAULT_FEATURES,
> +		.hwhandler     = DEFAULT_HWHANDLER,
> +		.pgpolicy      = FAILOVER,
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.no_path_retry = NO_PATH_RETRY_FAIL,
> +		.checker_name  = RBD,
> +		.user_friendly_names = USER_FRIENDLY_NAMES_ON,

USER_FRIENDLY_NAMES_ON is highly inadvisable.

> +		.uid_attribute = "ID_UID",
> +		.prio_name     = PRIO_CONST,
> +		.deferred_remove = DEFERRED_REMOVE_ON,
