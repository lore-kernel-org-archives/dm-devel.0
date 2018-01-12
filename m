From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 10/14] libmultipath: hwtable: multibus for
 NetApp NVMe-FC
Date: Sat, 13 Jan 2018 00:42:41 +0100
Message-ID: <0e9bf2af-d2ff-7f02-321c-665258c9f00f@gmail.com>
References: <20180112220743.11513-1-mwilck@suse.com>
	<20180112220743.11513-11-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180112220743.11513-11-mwilck@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

On 01/12/2018 11:07 PM, Martin Wilck wrote:

> Use multibus policy for NetApp NVMe-FC namespace controllers.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/hwtable.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 40c4724fcd1b..bae280c835e6 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1142,6 +1142,19 @@ static struct hwentry default_hw[] = {
>  		.checker_name  = NONE,
>  		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
>  	},
> +	/*
> +	 * NetApp NVMe-FC namespace devices: MULTIBUS preferred
> +	 *
> +	 * The table is searched backwards, so place this after generic NVMe

Too tricky.

> +	 */
> +	{
> +		.vendor	       = "NVME",
> +		.product       = "(NetApp |)ONTAP Controller)",
                                          ^^ Is this correct?

> +		.uid_attribute = "ID_WWN",
> +		.checker_name  = NONE,
> +		.pgpolicy      = MULTIBUS,
> +		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
> +	},

Place it inside NetApp vendor entry, and remove:
        /*
         * Generic NVMe devices
         */
        {
                .vendor        = "NVME",
                .product       = ".*",
                .uid_attribute = "ID_WWN",
                .checker_name  = NONE,
                .retain_hwhandler = RETAIN_HWHANDLER_OFF,
        },


Thanks.
