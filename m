From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 9/9] libmultipath: hwtable: add Lenovo DE
	series
Date: Fri, 15 Mar 2019 17:21:24 +0100
Message-ID: <13d53b8d-9ce1-09fa-fc50-15e390e59672@gmail.com>
References: <20190315161155.24062-1-mwilck@suse.com>
	<20190315161155.24062-10-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190315161155.24062-10-mwilck@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, dm-devel@redhat.com, Steve.Schremmer@netapp.com
List-Id: dm-devel.ids

On 3/15/19 5:11 PM, Martin Wilck wrote:

> I got this from Steven.
> 
> Cc: Steve.Schremmer@netapp.com
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Cc: xose.vazquez@gmail.com
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/hwtable.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

Do not forget the kernel side:
drivers/scsi/{scsi_devinfo.c,scsi_dh.c}
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index d3a8d9ba..fd9afc75 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -701,6 +701,26 @@ static struct hwentry default_hw[] = {
>  		.no_path_retry = (300 / DEFAULT_CHECKINT),
>  		.prio_name     = PRIO_ALUA,
>  	},
> +        /*
> +         * Lenovo
> +         */
> +        {
> +                /*
> +		 * DE Series
> +		 *
> +		 * Maintainer: Steve Schremmer <Steve.Schremmer@netapp.com>
> +		 */
> +                .vendor        = "LENOVO",
> +                .product       = "DE_Series",
> +                .bl_product    = "Universal Xport",
> +                .pgpolicy      = GROUP_BY_PRIO,
> +                .checker_name  = RDAC,
> +                .features      = "2 pg_init_retries 50",
> +                .hwhandler     = "1 rdac",
> +                .prio_name     = PRIO_RDAC,
> +                .pgfailback    = -FAILBACK_IMMEDIATE,
> +                .no_path_retry = 30,
> +        },
>  	/*
>  	 * NetApp
>  	 */
> 
