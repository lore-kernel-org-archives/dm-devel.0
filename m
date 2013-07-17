From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] [RESEND] hwtable: Add vendor ID and update
 defaults for NetApp E-Series storage
Date: Wed, 17 Jul 2013 22:23:03 +0200
Message-ID: <1374092583.9409.13.camel@lapoo.opensvc.com>
References: <51E5C526.9090602@gmail.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <51E5C526.9090602@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

> >  	{
> > -		.vendor        = "(LSI|ENGENIO)",
> > +		.vendor        = "(NETAPP|LSI|ENGENIO)",
> >  		.product       = "INF-01-00",
> >  		.bl_product    = "Universal Xport",
> >  		.features      = "2 pg_init_retries 50",
> > @@ -1145,12 +1149,14 @@ static struct hwentry default_hw[] = {
> >  		.pgpolicy      = GROUP_BY_PRIO,
> >  		.pgfailback    = -FAILBACK_IMMEDIATE,
> >  		.rr_weight     = RR_WEIGHT_NONE,
> > -		.no_path_retry = 15,
> > +		.no_path_retry = 30,
> >  		.minio         = DEFAULT_MINIO,
> >  		.minio_rq      = DEFAULT_MINIO_RQ,
> >  		.checker_name  = RDAC,
> >  		.prio_name     = PRIO_RDAC,
> >  		.prio_args     = NULL,
> > +		.detect_prio   = DETECT_PRIO_ON,
> > +		.retain_hwhandler = RETAIN_HWHANDLER_ON,
> >  	},
> >  	{
> >  		.vendor        = "STK",
> > 
> > --
> 
> This change should be also propagated to multipath.conf.defaults

Done.

Thanks,
Christophe Varoqui
OpenSVC
