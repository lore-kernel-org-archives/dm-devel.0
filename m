From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
Subject: Re: [PATCH v3 10/10] libmultipath: hwtable: add Lenovo
	DE series
Date: Fri, 12 Apr 2019 17:27:25 +0000
Message-ID: <BN8PR06MB5793EA58EA440AC1F232EA4B8C280@BN8PR06MB5793.namprd06.prod.outlook.com>
References: <20190318112445.6636-1-mwilck@suse.com>
	<20190318112445.6636-11-mwilck@suse.com>
	<BN8PR06MB5793386E7E8196C4E7BF306B8C470@BN8PR06MB5793.namprd06.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BN8PR06MB5793386E7E8196C4E7BF306B8C470@BN8PR06MB5793.namprd06.prod.outlook.com>
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



> From: Schremmer, Steven <Steve.Schremmer@netapp.com>
> > From: Martin Wilck <mwilck@suse.com>
> > Sent: Monday, March 18, 2019 6:25 AM
> > To: Christophe Varoqui <christophe.varoqui@opensvc.com>; Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: dm-devel@redhat.com; Martin Wilck <mwilck@suse.com>; Schremmer, Steven
> > <Steve.Schremmer@netapp.com>; ng-eseries-upstream-maintainers <ng-eseries-upstream-
> > maintainers@netapp.com>; xose.vazquez@gmail.com
> > Subject: [PATCH v3 10/10] libmultipath: hwtable: add Lenovo DE series
> >
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  libmultipath/hwtable.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index d3a8d9ba..b8285818 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -701,6 +701,26 @@ static struct hwentry default_hw[] = {
> >                 .no_path_retry = (300 / DEFAULT_CHECKINT),
> >                 .prio_name     = PRIO_ALUA,
> >         },
> > +        /*
> > +         * Lenovo
> > +         */
> > +        {
> > +                /*
> > +                * DE Series
> > +                *
> > +                * Maintainer: ng-eseries-upstream-maintainers@netapp.com
> > +                */
> > +                .vendor        = "LENOVO",
> > +                .product       = "DE_Series",
> > +                .bl_product    = "Universal Xport",
> > +                .pgpolicy      = GROUP_BY_PRIO,
> > +                .checker_name  = RDAC,
> > +                .features      = "2 pg_init_retries 50",
> > +                .hwhandler     = "1 rdac",
> > +                .prio_name     = PRIO_RDAC,
> > +                .pgfailback    = -FAILBACK_IMMEDIATE,
> > +                .no_path_retry = 30,
> > +        },
> >         /*
> >          * NetApp
> >          */
> > --
> > 2.21.0
> 
> Looks good.
> 
> Reviewed-by: Steven Schremmer <steven.schremmer@netapp.com>
> 
> Thanks for submitting it,
> Steve

Did this patch get accepted?

Thanks,
Steve
