From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
Subject: Re: [PATCH 9/9] libmultipath: hwtable: add Lenovo DE
	series
Date: Fri, 15 Mar 2019 16:33:42 +0000
Message-ID: <BN8PR06MB579317ED3B7E69E11BC1DEEE8C440@BN8PR06MB5793.namprd06.prod.outlook.com>
References: <20190315161155.24062-1-mwilck@suse.com>
	<20190315161155.24062-10-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190315161155.24062-10-mwilck@suse.com>
Content-Language: en-US
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
Cc: ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

> +        /*
> +         * Lenovo
> +         */
> +        {
> +                /*
> +                * DE Series
> +                *
> +                * Maintainer: Steve Schremmer <Steve.Schremmer@netapp.com>
> +                */
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
>         /*
>          * NetApp
>          */

If you're going to list a netapp.com address, may as well be
ng-eseries-upstream-maintainers@netapp.com
