From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 5/5] multipath-tools: hwtable housekeeping
Date: Sun, 31 Jul 2016 10:55:46 +0200
Message-ID: <CABr-Gnfo1zGZRJSnd=gBKFFpww2f_GOdMk2t-Gx_rxybD3C=rw@mail.gmail.com>
References: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
	<1469233752-11708-5-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8936800173422747733=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469233752-11708-5-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8936800173422747733==
Content-Type: multipart/alternative; boundary=001a11410fec4b49300538eaa6cf

--001a11410fec4b49300538eaa6cf
Content-Type: text/plain; charset=UTF-8

The "change default failback from manual to immediate" patch is reverted,
as requested by Hannes.

I rebased and merged your patches 1 to 4 of this set.

Can you rebase this 5-5 patch and resubmit ?

Thanks.

On Sat, Jul 23, 2016 at 2:29 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Mainly: arrange some families, clean redundant labels, detail IBM devices,
> add remaining attributes to last member(NULL) and add missing vendor
> labels.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 299
> +++++++++++++++++++++++++++----------------------
>  1 file changed, 162 insertions(+), 137 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 44fc309..1efaeee 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -25,15 +25,6 @@
>   */
>  static struct hwentry default_hw[] = {
>         /*
> -        * Compellent Technologies/DELL
> -        */
> -       {
> -               .vendor        = "COMPELNT",
> -               .product       = "Compellent Vol",
> -               .pgpolicy      = MULTIBUS,
> -               .no_path_retry = NO_PATH_RETRY_QUEUE,
> -       },
> -       /*
>          * Apple
>          *
>          * Maintainer : Shyam Sundar
> @@ -46,7 +37,7 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         /*
> -        * StorageWorks/HPE
> +        * HPE
>          */
>         {
>                 .vendor        = "3PARdata",
> @@ -99,7 +90,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>         },
>         {
> -               /* HP MSA2000 family with old firmware */
> +               /* MSA2000 family with old firmware */
>                 .vendor        = "HP",
>                 .product       = "(MSA2[02]12fc|MSA2012i)",
>                 .pgpolicy      = MULTIBUS,
> @@ -107,7 +98,7 @@ static struct hwentry default_hw[] = {
>                 .minio         = 100,
>         },
>         {
> -               /* HP MSA2000 family with new firmware */
> +               /* MSA2000 family with new firmware */
>                 .vendor        = "HP",
>                 .product       =
> "(MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME)",
>                 .no_path_retry = 18,
> @@ -115,7 +106,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>         },
>         {
> -               /* HP MSA 1040/2040 family */
> +               /* MSA 1040/2040 family */
>                 .vendor        = "HP",
>                 .product       = "MSA (1|2)040 SA(N|S)",
>                 .no_path_retry = 18,
> @@ -123,7 +114,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>         },
>         {
> -               /* HP SVSP */
> +               /* SVSP */
>                 .vendor        = "HP",
>                 .product       = "HSVX700",
>                 .hwhandler     = "1 alua",
> @@ -132,7 +123,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>         },
>         {
> -               /* HP Smart Array */
> +               /* Smart Array */
>                 .vendor        = "HP",
>                 .product       = "LOGICAL VOLUME.*",
>                 .pgpolicy      = MULTIBUS,
> @@ -140,7 +131,7 @@ static struct hwentry default_hw[] = {
>                 .no_path_retry = 12,
>         },
>         {
> -               /* HP P2000 family */
> +               /* P2000 family */
>                 .vendor        = "HP",
>                 .product       = "(P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3
> SAS|P2000 G3 iSCSI)",
>                 .no_path_retry = 18,
> @@ -148,7 +139,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>         },
>         /*
> -        * DDN
> +        * DataDirect Networks
>          */
>         {
>                 .vendor        = "DDN",
> @@ -196,6 +187,49 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         /*
> +        * DELL
> +        */
> +       {
> +               /* Compellent family */
> +               .vendor        = "COMPELNT",
> +               .product       = "Compellent Vol",
> +               .pgpolicy      = MULTIBUS,
> +               .no_path_retry = NO_PATH_RETRY_QUEUE,
> +       },
> +       {
> +               /* MD3000 */
> +               .vendor        = "DELL",
> +               .product       = "MD3000",
> +               .bl_product    = "Universal Xport",
> +               .features      = "2 pg_init_retries 50",
> +               .hwhandler     = "1 rdac",
> +               .no_path_retry = 15,
> +               .checker_name  = RDAC,
> +               .prio_name     = PRIO_RDAC,
> +       },
> +       {
> +               /* MD32xx/MD36xx */
> +               .vendor        = "DELL",
> +               .product       = "(MD32xx|MD36xx)",
> +               .bl_product    = "Universal Xport",
> +               .features      = "2 pg_init_retries 50",
> +               .hwhandler     = "1 rdac",
> +               .no_path_retry = 15,
> +               .checker_name  = RDAC,
> +               .prio_name     = PRIO_RDAC,
> +       },
> +       {
> +               /* MD34xx/MD38xx */
> +               .vendor        = "DELL",
> +               .product       = "(MD34xx|MD38xx)",
> +               .bl_product    = "Universal Xport",
> +               .features      = "2 pg_init_retries 50",
> +               .hwhandler     = "1 rdac",
> +               .no_path_retry = 15,
> +               .checker_name  = RDAC,
> +               .prio_name     = PRIO_RDAC,
> +       },
> +       /*
>          * Fujitsu
>          */
>         {
> @@ -211,6 +245,12 @@ static struct hwentry default_hw[] = {
>                 .no_path_retry = 10,
>                 .prio_name     = PRIO_ALUA,
>         },
> +               /* FibreCAT S80 */
> +       {
> +               .vendor        = "EUROLOGC",
> +               .product       = "FC2502",
> +               .pgfailback    = FAILBACK_UNDEF,
> +       },
>         /*
>          * Hitachi
>          *
> @@ -242,7 +282,7 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
> -               /* IBM FAStT 1722-600 */
> +               /* DS4300 / FAStT600 */
>                 .vendor        = "IBM",
>                 .product       = "^1722-600",
>                 .bl_product    = "Universal Xport",
> @@ -253,7 +293,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_RDAC,
>         },
>         {
> -               /* IBM DS4100 */
> +               /* DS4100 / FAStT100 */
>                 .vendor        = "IBM",
>                 .product       = "^1724",
>                 .bl_product    = "Universal Xport",
> @@ -264,7 +304,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_RDAC,
>         },
>         {
> -               /* IBM DS3200 / DS3300 / DS3400 */
> +               /* DS3200 / DS3300 / DS3400 / Boot DS */
>                 .vendor        = "IBM",
>                 .product       = "^1726",
>                 .bl_product    = "Universal Xport",
> @@ -275,7 +315,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_RDAC,
>         },
>         {
> -               /* IBM DS4400 / DS4500 / FAStT700 */
> +               /* DS4400 / DS4500 / FAStT700 / FAStT900 */
>                 .vendor        = "IBM",
>                 .product       = "^1742",
>                 .bl_product    = "Universal Xport",
> @@ -285,6 +325,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_RDAC,
>         },
>         {
> +               /* DS3500 / DS3512 / DS3524 */
>                 .vendor        = "IBM",
>                 .product       = "^(1745|1746)",
>                 .bl_product    = "Universal Xport",
> @@ -295,7 +336,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_RDAC,
>         },
>         {
> -               /* IBM DS4700 */
> +               /* DS3950 / DS4200 / DS4700 / DS5020 */
>                 .vendor        = "IBM",
>                 .product       = "^1814",
>                 .bl_product    = "Universal Xport",
> @@ -305,7 +346,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_RDAC,
>         },
>         {
> -               /* IBM DS4800 */
> +               /* DS4800 */
>                 .vendor        = "IBM",
>                 .product       = "^1815",
>                 .bl_product    = "Universal Xport",
> @@ -315,7 +356,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_RDAC,
>         },
>         {
> -               /* IBM DS5000 */
> +               /* DS5000 / DS5100 / DS5300 / DCS3700 */
>                 .vendor        = "IBM",
>                 .product       = "^1818",
>                 .bl_product    = "Universal Xport",
> @@ -325,7 +366,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_RDAC,
>         },
>         {
> -               /* IBM Netfinity Fibre Channel RAID Controller Unit */
> +               /* Netfinity Fibre Channel RAID Controller Unit */
>                 .vendor        = "IBM",
>                 .product       = "^3526",
>                 .bl_product    = "Universal Xport",
> @@ -335,14 +376,14 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_RDAC,
>         },
>         {
> -               /* IBM DS4200 / FAStT200 */
> +               /* DS4200 / FAStT200 */
>                 .vendor        = "IBM",
>                 .product       = "^3542",
>                 .pgpolicy      = GROUP_BY_SERIAL,
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
> -               /* IBM ESS F20 aka Shark */
> +               /* Enterprise Storage Server / Shark 800 */
>                 .vendor        = "IBM",
>                 .product       = "^2105800",
>                 .features      = "1 queue_if_no_path",
> @@ -350,7 +391,7 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
> -               /* IBM ESS F20 aka Shark */
> +               /* Enterprise Storage Server / Shark F20 */
>                 .vendor        = "IBM",
>                 .product       = "^2105F20",
>                 .features      = "1 queue_if_no_path",
> @@ -358,14 +399,14 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
> -               /* IBM DS6000 */
> +               /* DS6000 */
>                 .vendor        = "IBM",
>                 .product       = "^1750500",
>                 .features      = "1 queue_if_no_path",
>                 .prio_name     = PRIO_ALUA,
>         },
>         {
> -               /* IBM DS8000 */
> +               /* DS8000 */
>                 .vendor        = "IBM",
>                 .product       = "^2107900",
>                 .features      = "1 queue_if_no_path",
> @@ -373,14 +414,14 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
> -               /* IBM SAN Volume Controller */
> +               /* SAN Volume Controller / Storwize */
>                 .vendor        = "IBM",
>                 .product       = "^2145",
>                 .features      = "1 queue_if_no_path",
>                 .prio_name     = PRIO_ALUA,
>         },
>         {
> -               /* IBM S/390 ECKD DASD */
> +               /* S/390 ECKD DASD */
>                 .vendor        = "IBM",
>                 .product       = "S/390 DASD ECKD",
>                 .bl_product    = "S/390.*",
> @@ -390,7 +431,7 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
> -               /* IBM S/390 FBA DASD */
> +               /* S/390 FBA DASD */
>                 .vendor        = "IBM",
>                 .product       = "S/390 DASD FBA",
>                 .bl_product    = "S/390.*",
> @@ -400,7 +441,7 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
> -               /* IBM IPR */
> +               /* Power RAID (IPR) */
>                 .vendor        = "IBM",
>                 .product       = "^IPR.*",
>                 .features      = "1 queue_if_no_path",
> @@ -408,7 +449,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>         },
>         {
> -               /* IBM RSSM */
> +               /* SAS RAID Controller Module (RSSM) */
>                 .vendor        = "IBM",
>                 .product       = "1820N00",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> @@ -416,7 +457,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>         },
>         {
> -               /* IBM XIV Storage System */
> +               /* XIV Storage System */
>                 .vendor        = "IBM",
>                 .product       = "2810XIV",
>                 .features      = "1 queue_if_no_path",
> @@ -438,7 +479,7 @@ static struct hwentry default_hw[] = {
>                 .no_path_retry = (300 / DEFAULT_CHECKINT),
>         },
>         {
> -               /* IBM 3303 NVDISK */
> +               /* 3303 NVDISK */
>                 .vendor        = "IBM",
>                 .product       = "3303      NVDISK",
>                 .no_path_retry = (300 / DEFAULT_CHECKINT),
> @@ -453,43 +494,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>         },
>         /*
> -        * DELL
> -        */
> -       {
> -               /* DELL MD3000 */
> -               .vendor        = "DELL",
> -               .product       = "MD3000",
> -               .bl_product    = "Universal Xport",
> -               .features      = "2 pg_init_retries 50",
> -               .hwhandler     = "1 rdac",
> -               .no_path_retry = 15,
> -               .checker_name  = RDAC,
> -               .prio_name     = PRIO_RDAC,
> -       },
> -       {
> -               /* DELL MD32xx/MD36xx */
> -               .vendor        = "DELL",
> -               .product       = "(MD32xx|MD36xx)",
> -               .bl_product    = "Universal Xport",
> -               .features      = "2 pg_init_retries 50",
> -               .hwhandler     = "1 rdac",
> -               .no_path_retry = 15,
> -               .checker_name  = RDAC,
> -               .prio_name     = PRIO_RDAC,
> -       },
> -       {
> -               /* DELL MD34xx/MD38xx */
> -               .vendor        = "DELL",
> -               .product       = "(MD34xx|MD38xx)",
> -               .bl_product    = "Universal Xport",
> -               .features      = "2 pg_init_retries 50",
> -               .hwhandler     = "1 rdac",
> -               .no_path_retry = 15,
> -               .checker_name  = RDAC,
> -               .prio_name     = PRIO_RDAC,
> -       },
> -       /*
> -        * NETAPP ONTAP family
> +        * NetApp ONTAP family
>          *
>          * Maintainer : Martin George
>          * Mail : marting@netapp.com
> @@ -511,8 +516,23 @@ static struct hwentry default_hw[] = {
>                 .minio         = 128,
>                 .prio_name     = PRIO_ONTAP,
>         },
> +       /* LSI/Engenio/NetApp RDAC family
> +        *
> +        * Maintainer : Sean Stewart
> +        * Mail : sean.stewart@netapp.com
> +        */
> +       {
> +               .vendor        = "(NETAPP|LSI|ENGENIO)",
> +               .product       = "INF-01-00",
> +               .bl_product    = "Universal Xport",
> +               .features      = "2 pg_init_retries 50",
> +               .hwhandler     = "1 rdac",
> +               .no_path_retry = 30,
> +               .checker_name  = RDAC,
> +               .prio_name     = PRIO_RDAC,
> +       },
>         /*
> -        * NEXENTA
> +        * Nexenta
>          *
>          * Maintainer : Yacine Kheddache
>          * Mail : yacine@alyseo.com
> @@ -526,18 +546,6 @@ static struct hwentry default_hw[] = {
>                 .minio         = 128,
>         },
>         /*
> -        * Pillar Data/Oracle
> -        *
> -        * Maintainer : Srinivasan Ramani
> -        * Mail : srinivas.ramani@oracle.com
> -        */
> -       {
> -               .vendor        = "Pillar",
> -               .product       = "Axiom.*",
> -               .pgfailback    = FAILBACK_UNDEF,
> -               .prio_name     = PRIO_ALUA,
> -       },
> -       /*
>          * SGI
>          */
>         {
> @@ -576,9 +584,22 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>         },
>         /*
> -        * STK/Oracle
> +        * Oracle
>          */
>         {
> +               /*
> +                * Pillar Data
> +                *
> +                * Maintainer : Srinivasan Ramani
> +                * Mail : srinivas.ramani@oracle.com
> +                */
> +               .vendor        = "Pillar",
> +               .product       = "Axiom.*",
> +               .pgfailback    = FAILBACK_UNDEF,
> +               .prio_name     = PRIO_ALUA,
> +       },
> +               /* StorageTek */
> +       {
>                 .vendor        = "STK",
>                 .product       = "OPENstorage D280",
>                 .bl_product    = "Universal Xport",
> @@ -586,9 +607,16 @@ static struct hwentry default_hw[] = {
>                 .checker_name  = RDAC,
>                 .prio_name     = PRIO_RDAC,
>         },
> -       /*
> -        * SUN/Oracle
> -        */
> +       {
> +               .vendor        = "STK",
> +               .product       = "FLEXLINE 380",
> +               .bl_product    = "Universal Xport",
> +               .hwhandler     = "1 rdac",
> +               .no_path_retry = NO_PATH_RETRY_QUEUE,
> +               .checker_name  = RDAC,
> +               .prio_name     = PRIO_RDAC,
> +       },
> +               /* SUN */
>         {
>                 .vendor        = "SUN",
>                 .product       = "(StorEdge 3510|T4)",
> @@ -604,25 +632,6 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_RDAC,
>         },
>         {
> -               .vendor        = "EUROLOGC",
> -               .product       = "FC2502",
> -               .pgfailback    = FAILBACK_UNDEF,
> -       },
> -       /*
> -        * Pivot3
> -        *
> -        * Maintainer : Bart Brooks, Pivot3
> -        * Mail : bartb@pivot3.com
> -        */
> -       {
> -               .vendor        = "PIVOT3",
> -               .product       = "RAIGE VOLUME",
> -               .features      = "1 queue_if_no_path",
> -               .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
> -               .minio         = 100,
> -       },
> -       {
>                 .vendor        = "SUN",
>                 .product       = "CSM200_R",
>                 .bl_product    = "Universal Xport",
> @@ -631,8 +640,8 @@ static struct hwentry default_hw[] = {
>                 .checker_name  = RDAC,
>                 .prio_name     = PRIO_RDAC,
>         },
> -       /* SUN/LSI 2510, 2540, 2530, 2540 */
>         {
> +               /* 2510 / 2540 / 2530 / 2540 */
>                 .vendor        = "SUN",
>                 .product       = "LCSM100_[IEFS]",
>                 .bl_product    = "Universal Xport",
> @@ -641,8 +650,8 @@ static struct hwentry default_hw[] = {
>                 .checker_name  = RDAC,
>                 .prio_name     = PRIO_RDAC,
>         },
> -       /* StorageTek 6180 */
>         {
> +               /* StorageTek 6180 */
>                 .vendor        = "SUN",
>                 .product       = "SUN_6180",
>                 .bl_product    = "Universal Xport",
> @@ -651,30 +660,23 @@ static struct hwentry default_hw[] = {
>                 .checker_name  = RDAC,
>                 .prio_name     = PRIO_RDAC,
>         },
> -       /* LSI/Engenio/NetApp RDAC
> +       /*
> +        * Pivot3
>          *
> -        * Maintainer : Sean Stewart
> -        * Mail : sean.stewart@netapp.com
> +        * Maintainer : Bart Brooks, Pivot3
> +        * Mail : bartb@pivot3.com
>          */
>         {
> -               .vendor        = "(NETAPP|LSI|ENGENIO)",
> -               .product       = "INF-01-00",
> -               .bl_product    = "Universal Xport",
> -               .features      = "2 pg_init_retries 50",
> -               .hwhandler     = "1 rdac",
> -               .no_path_retry = 30,
> -               .checker_name  = RDAC,
> -               .prio_name     = PRIO_RDAC,
> -       },
> -       {
> -               .vendor        = "STK",
> -               .product       = "FLEXLINE 380",
> -               .bl_product    = "Universal Xport",
> -               .hwhandler     = "1 rdac",
> -               .no_path_retry = NO_PATH_RETRY_QUEUE,
> -               .checker_name  = RDAC,
> -               .prio_name     = PRIO_RDAC,
> +               .vendor        = "PIVOT3",
> +               .product       = "RAIGE VOLUME",
> +               .features      = "1 queue_if_no_path",
> +               .pgpolicy      = MULTIBUS,
> +               .pgfailback    = FAILBACK_UNDEF,
> +               .minio         = 100,
>         },
> +       /*
> +        * Intel
> +        */
>         {
>                 .vendor        = "Intel",
>                 .product       = "Multi-Flex",
> @@ -682,6 +684,9 @@ static struct hwentry default_hw[] = {
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>                 .prio_name     = PRIO_ALUA,
>         },
> +       /*
> +        * Linux-IO Target
> +        */
>         {
>                 .vendor        = "(LIO-ORG|SUSE)",
>                 .product       = "RBD",
> @@ -690,6 +695,9 @@ static struct hwentry default_hw[] = {
>                 .minio         = 100,
>                 .prio_name     = PRIO_ALUA,
>         },
> +       /*
> +        * DataCore
> +        */
>         {
>                 .vendor        = "DataCore",
>                 .product       = "SANmelody",
> @@ -702,6 +710,9 @@ static struct hwentry default_hw[] = {
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>                 .prio_name     = PRIO_ALUA,
>         },
> +       /*
> +        * Pure Storage
> +        */
>         {
>                 .vendor        = "PURE",
>                 .product       = "FlashArray",
> @@ -710,6 +721,9 @@ static struct hwentry default_hw[] = {
>                 .fast_io_fail  = 10,
>                 .dev_loss      = 60,
>         },
> +       /*
> +        * Huawei
> +        */
>         {
>                 .vendor        = "HUAWEI",
>                 .product       = "XSG1",
> @@ -804,18 +818,29 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = NULL,
>                 .product       = NULL,
> +               .revision      = NULL,
> +               .bl_product    = NULL,
> +               .pgpolicy      = 0,
> +               .uid_attribute = NULL,
> +               .selector      = NULL,
> +               .checker_name  = NULL,
>                 .features      = NULL,
>                 .hwhandler     = NULL,
> -               .selector      = NULL,
> -               .pgpolicy      = 0,
> +               .prio_name     = NULL,
> +               .prio_args     = NULL,
>                 .pgfailback    = 0,
>                 .rr_weight     = 0,
>                 .no_path_retry = 0,
>                 .minio         = 0,
>                 .minio_rq      = 0,
> -               .checker_name  = NULL,
> -               .prio_name     = NULL,
> -               .prio_args     = NULL,
> +               .flush_on_last_del = 0,
> +               .fast_io_fail  = 0,
> +               .dev_loss      = 0,
> +               .retain_hwhandler = NULL,
> +               .detect_prio   = NULL,
> +               .deferred_remove = NULL,
> +               .delay_watch_checks = 0,
> +               .delay_wait_checks = 0,
>         },
>  };
>
> --
> 2.7.4
>
>

--001a11410fec4b49300538eaa6cf
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+VGhlICZxdW90O2NoYW5nZSBkZWZhdWx0IGZhaWxiYWNrIGZyb20gbWFu
dWFsIHRvIGltbWVkaWF0ZSZxdW90OyBwYXRjaCBpcyByZXZlcnRlZCwgYXMgcmVxdWVzdGVkIGJ5
IEhhbm5lcy48ZGl2Pjxicj48L2Rpdj48ZGl2PkkgcmViYXNlZCBhbmQgbWVyZ2VkIHlvdXIgcGF0
Y2hlcyAxIHRvIDQgb2YgdGhpcyBzZXQuPC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5DYW4geW91
IHJlYmFzZSB0aGlzIDUtNSBwYXRjaCBhbmQgcmVzdWJtaXQgPzwvZGl2PjxkaXY+PGJyPjwvZGl2
PjxkaXY+VGhhbmtzLjwvZGl2PjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI+PGRp
diBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIFNhdCwgSnVsIDIzLCAyMDE2IGF0IDI6MjkgQU0sIFhv
c2UgVmF6cXVleiBQZXJleiA8c3BhbiBkaXI9Imx0ciI+Jmx0OzxhIGhyZWY9Im1haWx0bzp4b3Nl
LnZhenF1ZXpAZ21haWwuY29tIiB0YXJnZXQ9Il9ibGFuayI+eG9zZS52YXpxdWV6QGdtYWlsLmNv
bTwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+PGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3Rl
IiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFk
ZGluZy1sZWZ0OjFleCI+TWFpbmx5OiBhcnJhbmdlIHNvbWUgZmFtaWxpZXMsIGNsZWFuIHJlZHVu
ZGFudCBsYWJlbHMsIGRldGFpbCBJQk0gZGV2aWNlcyw8YnI+DQphZGQgcmVtYWluaW5nIGF0dHJp
YnV0ZXMgdG8gbGFzdCBtZW1iZXIoTlVMTCkgYW5kIGFkZCBtaXNzaW5nIHZlbmRvciBsYWJlbHMu
PGJyPg0KPGJyPg0KQ2M6IENocmlzdG9waGUgVmFyb3F1aSAmbHQ7PGEgaHJlZj0ibWFpbHRvOmNo
cmlzdG9waGUudmFyb3F1aUBvcGVuc3ZjLmNvbSI+Y2hyaXN0b3BoZS52YXJvcXVpQG9wZW5zdmMu
Y29tPC9hPiZndDs8YnI+DQpDYzogZGV2aWNlLW1hcHBlciBkZXZlbG9wbWVudCAmbHQ7PGEgaHJl
Zj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+Jmd0
Ozxicj4NClNpZ25lZC1vZmYtYnk6IFhvc2UgVmF6cXVleiBQZXJleiAmbHQ7PGEgaHJlZj0ibWFp
bHRvOnhvc2UudmF6cXVlekBnbWFpbC5jb20iPnhvc2UudmF6cXVlekBnbWFpbC5jb208L2E+Jmd0
Ozxicj4NCi0tLTxicj4NCsKgbGlibXVsdGlwYXRoL2h3dGFibGUuYyB8IDI5OSArKysrKysrKysr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tPGJyPg0KwqAxIGZpbGUgY2hh
bmdlZCwgMTYyIGluc2VydGlvbnMoKyksIDEzNyBkZWxldGlvbnMoLSk8YnI+DQo8YnI+DQpkaWZm
IC0tZ2l0IGEvbGlibXVsdGlwYXRoL2h3dGFibGUuYyBiL2xpYm11bHRpcGF0aC9od3RhYmxlLmM8
YnI+DQppbmRleCA0NGZjMzA5Li4xZWZhZWVlIDEwMDY0NDxicj4NCi0tLSBhL2xpYm11bHRpcGF0
aC9od3RhYmxlLmM8YnI+DQorKysgYi9saWJtdWx0aXBhdGgvaHd0YWJsZS5jPGJyPg0KQEAgLTI1
LDE1ICsyNSw2IEBAPGJyPg0KwqAgKi88YnI+DQrCoHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZh
dWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgLyo8YnI+DQotwqAgwqAgwqAgwqAgKiBDb21w
ZWxsZW50IFRlY2hub2xvZ2llcy9ERUxMPGJyPg0KLcKgIMKgIMKgIMKgICovPGJyPg0KLcKgIMKg
IMKgIMKgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC52ZW5kb3LCoCDCoCDCoCDCoCA9
ICZxdW90O0NPTVBFTE5UJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcm9k
dWN0wqAgwqAgwqAgwqA9ICZxdW90O0NvbXBlbGxlbnQgVm9sJnF1b3Q7LDxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1FVRVVFLDxi
cj4NCi3CoCDCoCDCoCDCoH0sPGJyPg0KLcKgIMKgIMKgIMKgLyo8YnI+DQrCoCDCoCDCoCDCoCDC
oCogQXBwbGU8YnI+DQrCoCDCoCDCoCDCoCDCoCo8YnI+DQrCoCDCoCDCoCDCoCDCoCogTWFpbnRh
aW5lciA6IFNoeWFtIFN1bmRhcjxicj4NCkBAIC00Niw3ICszNyw3IEBAIHN0YXRpYyBzdHJ1Y3Qg
aHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBn
ZmFpbGJhY2vCoCDCoCA9IEZBSUxCQUNLX1VOREVGLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0K
wqAgwqAgwqAgwqAgLyo8YnI+DQotwqAgwqAgwqAgwqAgKiBTdG9yYWdlV29ya3MvSFBFPGJyPg0K
K8KgIMKgIMKgIMKgICogSFBFPGJyPg0KwqAgwqAgwqAgwqAgwqAqLzxicj4NCsKgIMKgIMKgIMKg
IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVv
dDszUEFSZGF0YSZxdW90Oyw8YnI+DQpAQCAtOTksNyArOTAsNyBAQCBzdGF0aWMgc3RydWN0IGh3
ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlv
X25hbWXCoCDCoCDCoD0gUFJJT19BTFVBLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAg
wqAgwqAgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC8qIEhQIE1TQTIwMDAgZmFtaWx5
IHdpdGggb2xkIGZpcm13YXJlICovPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogTVNB
MjAwMCBmYW1pbHkgd2l0aCBvbGQgZmlybXdhcmUgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtIUCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDsoTVNBMlswMl0xMmZjfE1T
QTIwMTJpKSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDC
oCDCoCA9IE1VTFRJQlVTLDxicj4NCkBAIC0xMDcsNyArOTgsNyBAQCBzdGF0aWMgc3RydWN0IGh3
ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5taW5p
b8KgIMKgIMKgIMKgIMKgPSAxMDAsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDC
oCB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogSFAgTVNBMjAwMCBmYW1pbHkgd2l0
aCBuZXcgZmlybXdhcmUgKi88YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBNU0EyMDAw
IGZhbWlseSB3aXRoIG5ldyBmaXJtd2FyZSAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0hQJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90OyhNU0EyMDEyc2F8TVNBMjMoMTJ8
MjQpKGZjfGl8c2EpfE1TQTIwMDBzIFZPTFVNRSkmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgLm5vX3BhdGhfcmV0cnkgPSAxOCw8YnI+DQpAQCAtMTE1LDcgKzEwNiw3IEBAIHN0
YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgLnByaW9fbmFtZcKgIMKgIMKgPSBQUklPX0FMVUEsPGJyPg0KwqAgwqAgwqAgwqAg
fSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogSFAg
TVNBIDEwNDAvMjA0MCBmYW1pbHkgKi88YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBN
U0EgMTA0MC8yMDQwIGZhbWlseSAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5k
b3LCoCDCoCDCoCDCoCA9ICZxdW90O0hQJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O01TQSAoMXwyKTA0MCBTQShOfFMpJnF1b3Q7
LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gMTgsPGJyPg0K
QEAgLTEyMyw3ICsxMTQsNyBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0g
ezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19B
TFVBLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC8qIEhQIFNWU1AgKi88YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAvKiBTVlNQICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKg
IMKgID0gJnF1b3Q7SFAmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1
Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7SFNWWDcwMCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEgYWx1YSZxdW90Oyw8YnI+DQpAQCAt
MTMyLDcgKzEyMyw3IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9fbmFtZcKgIMKgIMKgPSBQUklPX0FMVUEs
PGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgLyogSFAgU21hcnQgQXJyYXkgKi88YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAvKiBTbWFydCBBcnJheSAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5k
b3LCoCDCoCDCoCDCoCA9ICZxdW90O0hQJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O0xPR0lDQUwgVk9MVU1FLiomcXVvdDssPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8
YnI+DQpAQCAtMTQwLDcgKzEzMSw3IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3
W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLm5vX3BhdGhfcmV0cnkgPSAxMiw8
YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAvKiBIUCBQMjAwMCBmYW1pbHkgKi88YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAvKiBQMjAwMCBmYW1pbHkgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVu
ZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtIUCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDsoUDIwMDAgRzMgRkN8UDIwMDBHMyBGQy9p
U0NTSXxQMjAwMCBHMyBTQVN8UDIwMDAgRzMgaVNDU0kpJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gMTgsPGJyPg0KQEAgLTE0OCw3ICsxMzksNyBA
QCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19BTFVBLDxicj4NCsKgIMKgIMKg
IMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgLyo8YnI+DQotwqAgwqAgwqAgwqAgKiBERE48YnI+DQor
wqAgwqAgwqAgwqAgKiBEYXRhRGlyZWN0IE5ldHdvcmtzPGJyPg0KwqAgwqAgwqAgwqAgwqAqLzxi
cj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAg
wqAgwqAgwqAgPSAmcXVvdDtERE4mcXVvdDssPGJyPg0KQEAgLTE5Niw2ICsxODcsNDkgQEAgc3Rh
dGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAg
wqAgfSw8YnI+DQrCoCDCoCDCoCDCoCAvKjxicj4NCivCoCDCoCDCoCDCoCAqIERFTEw8YnI+DQor
wqAgwqAgwqAgwqAgKi88YnI+DQorwqAgwqAgwqAgwqB7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgLyogQ29tcGVsbGVudCBmYW1pbHkgKi88YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtDT01QRUxOVCZxdW90Oyw8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtDb21wZWxsZW50IFZv
bCZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdwb2xpY3nCoCDCoCDCoCA9
IE1VTFRJQlVTLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5ub19wYXRoX3JldHJ5ID0g
Tk9fUEFUSF9SRVRSWV9RVUVVRSw8YnI+DQorwqAgwqAgwqAgwqB9LDxicj4NCivCoCDCoCDCoCDC
oHs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBNRDMwMDAgKi88YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtERUxMJnF1b3Q7LDxi
cj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O01E
MzAwMCZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuYmxfcHJvZHVjdMKgIMKg
ID0gJnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gJnF1b3Q7MiBwZ19pbml0X3JldHJpZXMgNTAmcXVvdDss
PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSAmcXVvdDsx
IHJkYWMmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLm5vX3BhdGhfcmV0cnkg
PSAxNSw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuY2hlY2tlcl9uYW1lwqAgPSBSREFD
LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19S
REFDLDxicj4NCivCoCDCoCDCoCDCoH0sPGJyPg0KK8KgIMKgIMKgIMKgezxicj4NCivCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC8qIE1EMzJ4eC9NRDM2eHggKi88YnI+DQorwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtERUxMJnF1b3Q7LDxicj4NCivCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90OyhNRDMyeHh8TUQz
Nnh4KSZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuYmxfcHJvZHVjdMKgIMKg
ID0gJnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gJnF1b3Q7MiBwZ19pbml0X3JldHJpZXMgNTAmcXVvdDss
PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSAmcXVvdDsx
IHJkYWMmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLm5vX3BhdGhfcmV0cnkg
PSAxNSw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuY2hlY2tlcl9uYW1lwqAgPSBSREFD
LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19S
REFDLDxicj4NCivCoCDCoCDCoCDCoH0sPGJyPg0KK8KgIMKgIMKgIMKgezxicj4NCivCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC8qIE1EMzR4eC9NRDM4eHggKi88YnI+DQorwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtERUxMJnF1b3Q7LDxicj4NCivCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90OyhNRDM0eHh8TUQz
OHh4KSZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuYmxfcHJvZHVjdMKgIMKg
ID0gJnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gJnF1b3Q7MiBwZ19pbml0X3JldHJpZXMgNTAmcXVvdDss
PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSAmcXVvdDsx
IHJkYWMmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLm5vX3BhdGhfcmV0cnkg
PSAxNSw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuY2hlY2tlcl9uYW1lwqAgPSBSREFD
LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19S
REFDLDxicj4NCivCoCDCoCDCoCDCoH0sPGJyPg0KK8KgIMKgIMKgIMKgLyo8YnI+DQrCoCDCoCDC
oCDCoCDCoCogRnVqaXRzdTxicj4NCsKgIMKgIMKgIMKgIMKgKi88YnI+DQrCoCDCoCDCoCDCoCB7
PGJyPg0KQEAgLTIxMSw2ICsyNDUsMTIgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRf
aHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IDEw
LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19B
TFVBLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyog
RmlicmVDQVQgUzgwICovPGJyPg0KK8KgIMKgIMKgIMKgezxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0VVUk9MT0dDJnF1b3Q7LDxicj4NCivC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O0ZDMjUwMiZx
dW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdmYWlsYmFja8KgIMKgID0gRkFJ
TEJBQ0tfVU5ERUYsPGJyPg0KK8KgIMKgIMKgIMKgfSw8YnI+DQrCoCDCoCDCoCDCoCAvKjxicj4N
CsKgIMKgIMKgIMKgIMKgKiBIaXRhY2hpPGJyPg0KwqAgwqAgwqAgwqAgwqAqPGJyPg0KQEAgLTI0
Miw3ICsyODIsNyBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRF
Riw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAvKiBJQk0gRkFTdFQgMTcyMi02MDAgKi88YnI+DQorwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAvKiBEUzQzMDAgLyBGQVN0VDYwMCAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDteMTcyMi02MDAmcXVv
dDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90
O1VuaXZlcnNhbCBYcG9ydCZxdW90Oyw8YnI+DQpAQCAtMjUzLDcgKzI5Myw3IEBAIHN0YXRpYyBz
dHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnByaW9fbmFtZcKgIMKgIMKgPSBQUklPX1JEQUMsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+
DQrCoCDCoCDCoCDCoCB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogSUJNIERTNDEw
MCAqLzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC8qIERTNDEwMCAvIEZBU3RUMTAwICov
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7
SUJNJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAg
wqA9ICZxdW90O14xNzI0JnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ibF9w
cm9kdWN0wqAgwqAgPSAmcXVvdDtVbml2ZXJzYWwgWHBvcnQmcXVvdDssPGJyPg0KQEAgLTI2NCw3
ICszMDQsNyBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19SREFDLDxicj4N
CsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoC8qIElCTSBEUzMyMDAgLyBEUzMzMDAgLyBEUzM0MDAgKi88YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAvKiBEUzMyMDAgLyBEUzMzMDAgLyBEUzM0MDAgLyBCb290IERTICovPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SUJN
JnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9
ICZxdW90O14xNzI2JnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ibF9wcm9k
dWN0wqAgwqAgPSAmcXVvdDtVbml2ZXJzYWwgWHBvcnQmcXVvdDssPGJyPg0KQEAgLTI3NSw3ICsz
MTUsNyBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19SREFDLDxicj4NCsKg
IMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC8qIElCTSBEUzQ0MDAgLyBEUzQ1MDAgLyBGQVN0VDcwMCAqLzxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoC8qIERTNDQwMCAvIERTNDUwMCAvIEZBU3RUNzAwIC8gRkFTdFQ5MDAgKi88
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtJ
Qk0mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDC
oD0gJnF1b3Q7XjE3NDImcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmJsX3By
b2R1Y3TCoCDCoCA9ICZxdW90O1VuaXZlcnNhbCBYcG9ydCZxdW90Oyw8YnI+DQpAQCAtMjg1LDYg
KzMyNSw3IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9fbmFtZcKgIMKgIMKgPSBQUklPX1JEQUMsPGJyPg0K
wqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgLyogRFMzNTAwIC8gRFMzNTEyIC8gRFMzNTI0ICovPGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SUJNJnF1b3Q7LDxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O14oMTc0NXwxNzQ2
KSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuYmxfcHJvZHVjdMKgIMKgID0g
JnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4NCkBAIC0yOTUsNyArMzM2LDcgQEAgc3Rh
dGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fUkRBQyw8YnI+DQrCoCDCoCDCoCDCoCB9
LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBJQk0g
RFM0NzAwICovPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogRFMzOTUwIC8gRFM0MjAw
IC8gRFM0NzAwIC8gRFM1MDIwICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRv
csKgIMKgIMKgIMKgID0gJnF1b3Q7SUJNJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O14xODE0JnF1b3Q7LDxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC5ibF9wcm9kdWN0wqAgwqAgPSAmcXVvdDtVbml2ZXJzYWwgWHBvcnQm
cXVvdDssPGJyPg0KQEAgLTMwNSw3ICszNDYsNyBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVm
YXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX25hbWXCoCDC
oCDCoD0gUFJJT19SREFDLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC8qIElCTSBEUzQ4MDAgKi88YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAvKiBEUzQ4MDAgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtJQk0mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7XjE4MTUmcXVvdDssPGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90O1VuaXZlcnNh
bCBYcG9ydCZxdW90Oyw8YnI+DQpAQCAtMzE1LDcgKzM1Niw3IEBAIHN0YXRpYyBzdHJ1Y3QgaHdl
bnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9f
bmFtZcKgIMKgIMKgPSBQUklPX1JEQUMsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDC
oCDCoCB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogSUJNIERTNTAwMCAqLzxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC8qIERTNTAwMCAvIERTNTEwMCAvIERTNTMwMCAvIERD
UzM3MDAgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAg
PSAmcXVvdDtJQk0mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TC
oCDCoCDCoCDCoD0gJnF1b3Q7XjE4MTgmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90O1VuaXZlcnNhbCBYcG9ydCZxdW90Oyw8YnI+DQpA
QCAtMzI1LDcgKzM2Niw3IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9fbmFtZcKgIMKgIMKgPSBQUklPX1JE
QUMsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KLcKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgLyogSUJNIE5ldGZpbml0eSBGaWJyZSBDaGFubmVsIFJBSUQgQ29udHJv
bGxlciBVbml0ICovPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogTmV0ZmluaXR5IEZp
YnJlIENoYW5uZWwgUkFJRCBDb250cm9sbGVyIFVuaXQgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtJQk0mcXVvdDssPGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7XjM1MjYmcXVvdDss
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90O1Vu
aXZlcnNhbCBYcG9ydCZxdW90Oyw8YnI+DQpAQCAtMzM1LDE0ICszNzYsMTQgQEAgc3RhdGljIHN0
cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fUkRBQyw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4N
CsKgIMKgIMKgIMKgIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBJQk0gRFM0MjAw
IC8gRkFTdFQyMDAgKi88YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBEUzQyMDAgLyBG
QVN0VDIwMCAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDC
oCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVj
dMKgIMKgIMKgIMKgPSAmcXVvdDteMzU0MiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1NFUklBTCw8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAg
wqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgLyogSUJNIEVTUyBGMjAgYWthIFNoYXJrICovPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgLyogRW50ZXJwcmlzZSBTdG9yYWdlIFNlcnZlciAvIFNoYXJrIDgwMCAqLzxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDte
MjEwNTgwMCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuZmVhdHVyZXPCoCDC
oCDCoCA9ICZxdW90OzEgcXVldWVfaWZfbm9fcGF0aCZxdW90Oyw8YnI+DQpAQCAtMzUwLDcgKzM5
MSw3IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IEZBSUxCQUNLX1VOREVGLDxicj4N
CsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoC8qIElCTSBFU1MgRjIwIGFrYSBTaGFyayAqLzxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoC8qIEVudGVycHJpc2UgU3RvcmFnZSBTZXJ2ZXIgLyBTaGFyayBGMjAgKi88YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtJQk0mcXVv
dDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1
b3Q7XjIxMDVGMjAmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmZlYXR1cmVz
wqAgwqAgwqAgPSAmcXVvdDsxIHF1ZXVlX2lmX25vX3BhdGgmcXVvdDssPGJyPg0KQEAgLTM1OCwx
NCArMzk5LDE0IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IEZBSUxCQUNLX1VOREVG
LDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCi3CoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoC8qIElCTSBEUzYwMDAgKi88YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAvKiBEUzYwMDAgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAg
wqAgwqAgPSAmcXVvdDtJQk0mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBy
b2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7XjE3NTA1MDAmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLmZlYXR1cmVzwqAgwqAgwqAgPSAmcXVvdDsxIHF1ZXVlX2lmX25vX3BhdGgm
cXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9fbmFtZcKgIMKgIMKgPSBQ
UklPX0FMVUEsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogSUJNIERTODAwMCAqLzxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC8qIERTODAwMCAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5k
b3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDteMjEwNzkwMCZxdW90Oyw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAuZmVhdHVyZXPCoCDCoCDCoCA9ICZxdW90OzEgcXVldWVfaWZf
bm9fcGF0aCZxdW90Oyw8YnI+DQpAQCAtMzczLDE0ICs0MTQsMTQgQEAgc3RhdGljIHN0cnVjdCBo
d2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdm
YWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrC
oCDCoCDCoCDCoCB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogSUJNIFNBTiBWb2x1
bWUgQ29udHJvbGxlciAqLzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC8qIFNBTiBWb2x1
bWUgQ29udHJvbGxlciAvIFN0b3J3aXplICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SUJNJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O14yMTQ1JnF1b3Q7LDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5mZWF0dXJlc8KgIMKgIMKgID0gJnF1b3Q7MSBxdWV1ZV9p
Zl9ub19wYXRoJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX25hbWXC
oCDCoCDCoD0gUFJJT19BTFVBLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAg
ezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC8qIElCTSBTLzM5MCBFQ0tEIERBU0QgKi88
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBTLzM5MCBFQ0tEIERBU0QgKi88YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtJQk0mcXVv
dDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1
b3Q7Uy8zOTAgREFTRCBFQ0tEJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5i
bF9wcm9kdWN0wqAgwqAgPSAmcXVvdDtTLzM5MC4qJnF1b3Q7LDxicj4NCkBAIC0zOTAsNyArNDMx
LDcgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0K
wqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgLyogSUJNIFMvMzkwIEZCQSBEQVNEICovPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgLyogUy8zOTAgRkJBIERBU0QgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVu
ZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtJQk0mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7Uy8zOTAgREFTRCBGQkEmcXVvdDssPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90O1MvMzkw
LiomcXVvdDssPGJyPg0KQEAgLTQwMCw3ICs0NDEsNyBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkg
ZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNr
wqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKg
IMKgIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBJQk0gSVBSICovPGJyPg0KK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogUG93ZXIgUkFJRCAoSVBSKSAqLzxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDteSVBS
LiomcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmZlYXR1cmVzwqAgwqAgwqAg
PSAmcXVvdDsxIHF1ZXVlX2lmX25vX3BhdGgmcXVvdDssPGJyPg0KQEAgLTQwOCw3ICs0NDksNyBA
QCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19BTFVBLDxicj4NCsKgIMKgIMKg
IMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC8q
IElCTSBSU1NNICovPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogU0FTIFJBSUQgQ29u
dHJvbGxlciBNb2R1bGUgKFJTU00pICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZl
bmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SUJNJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90OzE4MjBOMDAmcXVvdDssPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1FVRVVF
LDxicj4NCkBAIC00MTYsNyArNDU3LDcgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRf
aHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19uYW1lwqAgwqAgwqA9
IFBSSU9fQUxVQSw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBJQk0gWElWIFN0b3JhZ2UgU3lzdGVtICovPGJyPg0K
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogWElWIFN0b3JhZ2UgU3lzdGVtICovPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SUJNJnF1b3Q7
LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90
OzI4MTBYSVYmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmZlYXR1cmVzwqAg
wqAgwqAgPSAmcXVvdDsxIHF1ZXVlX2lmX25vX3BhdGgmcXVvdDssPGJyPg0KQEAgLTQzOCw3ICs0
NzksNyBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gKDMwMCAvIERFRkFVTFRfQ0hFQ0tJ
TlQpLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC8qIElCTSAzMzAzIE5WRElTSyAqLzxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC8qIDMzMDMgTlZESVNLICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SUJNJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90OzMzMDPCoCDCoCDCoCBOVkRJU0sm
cXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLm5vX3BhdGhfcmV0cnkgPSAoMzAw
IC8gREVGQVVMVF9DSEVDS0lOVCksPGJyPg0KQEAgLTQ1Myw0MyArNDk0LDcgQEAgc3RhdGljIHN0
cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fQUxVQSw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4N
CsKgIMKgIMKgIMKgIC8qPGJyPg0KLcKgIMKgIMKgIMKgICogREVMTDxicj4NCi3CoCDCoCDCoCDC
oCAqLzxicj4NCi3CoCDCoCDCoCDCoHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBE
RUxMIE1EMzAwMCAqLzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC52ZW5kb3LCoCDCoCDC
oCDCoCA9ICZxdW90O0RFTEwmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBy
b2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7TUQzMDAwJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC5ibF9wcm9kdWN0wqAgwqAgPSAmcXVvdDtVbml2ZXJzYWwgWHBvcnQmcXVvdDss
PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAgPSAmcXVvdDsy
IHBnX2luaXRfcmV0cmllcyA1MCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAu
aHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEgcmRhYyZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAubm9fcGF0aF9yZXRyeSA9IDE1LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC5jaGVja2VyX25hbWXCoCA9IFJEQUMsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
LnByaW9fbmFtZcKgIMKgIMKgPSBQUklPX1JEQUMsPGJyPg0KLcKgIMKgIMKgIMKgfSw8YnI+DQot
wqAgwqAgwqAgwqB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogREVMTCBNRDMyeHgv
TUQzNnh4ICovPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnZlbmRvcsKgIMKgIMKgIMKg
ID0gJnF1b3Q7REVMTCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJvZHVj
dMKgIMKgIMKgIMKgPSAmcXVvdDsoTUQzMnh4fE1EMzZ4eCkmcXVvdDssPGJyPg0KLcKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgLmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90O1VuaXZlcnNhbCBYcG9ydCZx
dW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9ICZx
dW90OzIgcGdfaW5pdF9yZXRyaWVzIDUwJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC5od2hhbmRsZXLCoCDCoCDCoD0gJnF1b3Q7MSByZGFjJnF1b3Q7LDxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC5ub19wYXRoX3JldHJ5ID0gMTUsPGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLmNoZWNrZXJfbmFtZcKgID0gUkRBQyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fUkRBQyw8YnI+DQotwqAgwqAgwqAgwqB9LDxi
cj4NCi3CoCDCoCDCoCDCoHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBERUxMIE1E
MzR4eC9NRDM4eHggKi88YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAudmVuZG9ywqAgwqAg
wqAgwqAgPSAmcXVvdDtERUxMJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5w
cm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90OyhNRDM0eHh8TUQzOHh4KSZxdW90Oyw8YnI+DQotwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAuYmxfcHJvZHVjdMKgIMKgID0gJnF1b3Q7VW5pdmVyc2FsIFhw
b3J0JnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKg
ID0gJnF1b3Q7MiBwZ19pbml0X3JldHJpZXMgNTAmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSAmcXVvdDsxIHJkYWMmcXVvdDssPGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgLm5vX3BhdGhfcmV0cnkgPSAxNSw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAuY2hlY2tlcl9uYW1lwqAgPSBSREFDLDxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19SREFDLDxicj4NCi3CoCDCoCDCoCDC
oH0sPGJyPg0KLcKgIMKgIMKgIMKgLyo8YnI+DQotwqAgwqAgwqAgwqAgKiBORVRBUFAgT05UQVAg
ZmFtaWx5PGJyPg0KK8KgIMKgIMKgIMKgICogTmV0QXBwIE9OVEFQIGZhbWlseTxicj4NCsKgIMKg
IMKgIMKgIMKgKjxicj4NCsKgIMKgIMKgIMKgIMKgKiBNYWludGFpbmVyIDogTWFydGluIEdlb3Jn
ZTxicj4NCsKgIMKgIMKgIMKgIMKgKiBNYWlsIDogPGEgaHJlZj0ibWFpbHRvOm1hcnRpbmdAbmV0
YXBwLmNvbSI+bWFydGluZ0BuZXRhcHAuY29tPC9hPjxicj4NCkBAIC01MTEsOCArNTE2LDIzIEBA
IHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLm1pbmlvwqAgwqAgwqAgwqAgwqA9IDEyOCw8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fT05UQVAsPGJyPg0KwqAgwqAgwqAg
wqAgfSw8YnI+DQorwqAgwqAgwqAgwqAvKiBMU0kvRW5nZW5pby9OZXRBcHAgUkRBQyBmYW1pbHk8
YnI+DQorwqAgwqAgwqAgwqAgKjxicj4NCivCoCDCoCDCoCDCoCAqIE1haW50YWluZXIgOiBTZWFu
IFN0ZXdhcnQ8YnI+DQorwqAgwqAgwqAgwqAgKiBNYWlsIDogPGEgaHJlZj0ibWFpbHRvOnNlYW4u
c3Rld2FydEBuZXRhcHAuY29tIj5zZWFuLnN0ZXdhcnRAbmV0YXBwLmNvbTwvYT48YnI+DQorwqAg
wqAgwqAgwqAgKi88YnI+DQorwqAgwqAgwqAgwqB7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7KE5FVEFQUHxMU0l8RU5HRU5JTykmcXVvdDss
PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7
SU5GLTAxLTAwJnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5ibF9wcm9kdWN0
wqAgwqAgPSAmcXVvdDtVbml2ZXJzYWwgWHBvcnQmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAgPSAmcXVvdDsyIHBnX2luaXRfcmV0cmllcyA1MCZx
dW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9ICZx
dW90OzEgcmRhYyZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAubm9fcGF0aF9y
ZXRyeSA9IDMwLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5jaGVja2VyX25hbWXCoCA9
IFJEQUMsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByaW9fbmFtZcKgIMKgIMKgPSBQ
UklPX1JEQUMsPGJyPg0KK8KgIMKgIMKgIMKgfSw8YnI+DQrCoCDCoCDCoCDCoCAvKjxicj4NCi3C
oCDCoCDCoCDCoCAqIE5FWEVOVEE8YnI+DQorwqAgwqAgwqAgwqAgKiBOZXhlbnRhPGJyPg0KwqAg
wqAgwqAgwqAgwqAqPGJyPg0KwqAgwqAgwqAgwqAgwqAqIE1haW50YWluZXIgOiBZYWNpbmUgS2hl
ZGRhY2hlPGJyPg0KwqAgwqAgwqAgwqAgwqAqIE1haWwgOiA8YSBocmVmPSJtYWlsdG86eWFjaW5l
QGFseXNlby5jb20iPnlhY2luZUBhbHlzZW8uY29tPC9hPjxicj4NCkBAIC01MjYsMTggKzU0Niw2
IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLm1pbmlvwqAgwqAgwqAgwqAgwqA9IDEyOCw8YnI+DQrCoCDCoCDCoCDC
oCB9LDxicj4NCsKgIMKgIMKgIMKgIC8qPGJyPg0KLcKgIMKgIMKgIMKgICogUGlsbGFyIERhdGEv
T3JhY2xlPGJyPg0KLcKgIMKgIMKgIMKgICo8YnI+DQotwqAgwqAgwqAgwqAgKiBNYWludGFpbmVy
IDogU3Jpbml2YXNhbiBSYW1hbmk8YnI+DQotwqAgwqAgwqAgwqAgKiBNYWlsIDogPGEgaHJlZj0i
bWFpbHRvOnNyaW5pdmFzLnJhbWFuaUBvcmFjbGUuY29tIj5zcmluaXZhcy5yYW1hbmlAb3JhY2xl
LmNvbTwvYT48YnI+DQotwqAgwqAgwqAgwqAgKi88YnI+DQotwqAgwqAgwqAgwqB7PGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7UGlsbGFyJnF1
b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZx
dW90O0F4aW9tLiomcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBnZmFpbGJh
Y2vCoCDCoCA9IEZBSUxCQUNLX1VOREVGLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5w
cmlvX25hbWXCoCDCoCDCoD0gUFJJT19BTFVBLDxicj4NCi3CoCDCoCDCoCDCoH0sPGJyPg0KLcKg
IMKgIMKgIMKgLyo8YnI+DQrCoCDCoCDCoCDCoCDCoCogU0dJPGJyPg0KwqAgwqAgwqAgwqAgwqAq
Lzxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQpAQCAtNTc2LDkgKzU4NCwyMiBAQCBzdGF0aWMgc3Ry
dWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19BTFVBLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0K
wqAgwqAgwqAgwqAgLyo8YnI+DQotwqAgwqAgwqAgwqAgKiBTVEsvT3JhY2xlPGJyPg0KK8KgIMKg
IMKgIMKgICogT3JhY2xlPGJyPg0KwqAgwqAgwqAgwqAgwqAqLzxicj4NCsKgIMKgIMKgIMKgIHs8
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKjxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAqIFBpbGxhciBEYXRhPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgICo8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgKiBNYWludGFpbmVyIDogU3Jpbml2YXNhbiBSYW1hbmk8
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgKiBNYWlsIDogPGEgaHJlZj0ibWFpbHRvOnNy
aW5pdmFzLnJhbWFuaUBvcmFjbGUuY29tIj5zcmluaXZhcy5yYW1hbmlAb3JhY2xlLmNvbTwvYT48
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgKi88YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtQaWxsYXImcXVvdDssPGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7QXhpb20uKiZxdW90
Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJB
Q0tfVU5ERUYsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByaW9fbmFtZcKgIMKgIMKg
PSBQUklPX0FMVUEsPGJyPg0KK8KgIMKgIMKgIMKgfSw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAvKiBTdG9yYWdlVGVrICovPGJyPg0KK8KgIMKgIMKgIMKgezxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O1NUSyZxdW90Oyw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtPUEVOc3Rv
cmFnZSBEMjgwJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ibF9wcm9kdWN0
wqAgwqAgPSAmcXVvdDtVbml2ZXJzYWwgWHBvcnQmcXVvdDssPGJyPg0KQEAgLTU4Niw5ICs2MDcs
MTYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAuY2hlY2tlcl9uYW1lwqAgPSBSREFDLDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19SREFDLDxicj4NCsKgIMKgIMKg
IMKgIH0sPGJyPg0KLcKgIMKgIMKgIMKgLyo8YnI+DQotwqAgwqAgwqAgwqAgKiBTVU4vT3JhY2xl
PGJyPg0KLcKgIMKgIMKgIMKgICovPGJyPg0KK8KgIMKgIMKgIMKgezxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O1NUSyZxdW90Oyw8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtGTEVYTElO
RSAzODAmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmJsX3Byb2R1Y3TCoCDC
oCA9ICZxdW90O1VuaXZlcnNhbCBYcG9ydCZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEgcmRhYyZxdW90Oyw8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfUVVFVUUsPGJy
Pg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmNoZWNrZXJfbmFtZcKgID0gUkRBQyw8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fUkRBQyw8YnI+
DQorwqAgwqAgwqAgwqB9LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC8qIFNVTiAqLzxi
cj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAg
wqAgwqAgwqAgPSAmcXVvdDtTVU4mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7KFN0b3JFZGdlIDM1MTB8VDQpJnF1b3Q7LDxicj4N
CkBAIC02MDQsMjUgKzYzMiw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10g
PSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9fbmFtZcKgIMKgIMKgPSBQUklP
X1JEQUMsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7RVVST0xPR0MmcXVv
dDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1
b3Q7RkMyNTAyJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ2ZhaWxiYWNr
wqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQotwqAgwqAgwqAgwqB9LDxicj4NCi3CoCDCoCDC
oCDCoC8qPGJyPg0KLcKgIMKgIMKgIMKgICogUGl2b3QzPGJyPg0KLcKgIMKgIMKgIMKgICo8YnI+
DQotwqAgwqAgwqAgwqAgKiBNYWludGFpbmVyIDogQmFydCBCcm9va3MsIFBpdm90Mzxicj4NCi3C
oCDCoCDCoCDCoCAqIE1haWwgOiA8YSBocmVmPSJtYWlsdG86YmFydGJAcGl2b3QzLmNvbSI+YmFy
dGJAcGl2b3QzLmNvbTwvYT48YnI+DQotwqAgwqAgwqAgwqAgKi88YnI+DQotwqAgwqAgwqAgwqB7
PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7
UElWT1QzJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcm9kdWN0wqAgwqAg
wqAgwqA9ICZxdW90O1JBSUdFIFZPTFVNRSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9ICZxdW90OzEgcXVldWVfaWZfbm9fcGF0aCZxdW90Oyw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVT
LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFD
S19VTkRFRiw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAubWluaW/CoCDCoCDCoCDCoCDC
oD0gMTAwLDxicj4NCi3CoCDCoCDCoCDCoH0sPGJyPg0KLcKgIMKgIMKgIMKgezxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O1NVTiZxdW90Oyw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtD
U00yMDBfUiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuYmxfcHJvZHVjdMKg
IMKgID0gJnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4NCkBAIC02MzEsOCArNjQwLDgg
QEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAuY2hlY2tlcl9uYW1lwqAgPSBSREFDLDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19SREFDLDxicj4NCsKgIMKgIMKgIMKg
IH0sPGJyPg0KLcKgIMKgIMKgIMKgLyogU1VOL0xTSSAyNTEwLCAyNTQwLCAyNTMwLCAyNTQwICov
PGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC8qIDI1MTAg
LyAyNTQwIC8gMjUzMCAvIDI1NDAgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVu
ZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtTVU4mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7TENTTTEwMF9bSUVGU10mcXVvdDssPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90O1VuaXZl
cnNhbCBYcG9ydCZxdW90Oyw8YnI+DQpAQCAtNjQxLDggKzY1MCw4IEBAIHN0YXRpYyBzdHJ1Y3Qg
aHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmNo
ZWNrZXJfbmFtZcKgID0gUkRBQyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19u
YW1lwqAgwqAgwqA9IFBSSU9fUkRBQyw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCi3CoCDCoCDC
oCDCoC8qIFN0b3JhZ2VUZWsgNjE4MCAqLzxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAvKiBTdG9yYWdlVGVrIDYxODAgKi88YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtTVU4mcXVvdDssPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7U1VOXzYxODAm
cXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmJsX3Byb2R1Y3TCoCDCoCA9ICZx
dW90O1VuaXZlcnNhbCBYcG9ydCZxdW90Oyw8YnI+DQpAQCAtNjUxLDMwICs2NjAsMjMgQEAgc3Rh
dGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAuY2hlY2tlcl9uYW1lwqAgPSBSREFDLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19SREFDLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJy
Pg0KLcKgIMKgIMKgIMKgLyogTFNJL0VuZ2VuaW8vTmV0QXBwIFJEQUM8YnI+DQorwqAgwqAgwqAg
wqAvKjxicj4NCivCoCDCoCDCoCDCoCAqIFBpdm90Mzxicj4NCsKgIMKgIMKgIMKgIMKgKjxicj4N
Ci3CoCDCoCDCoCDCoCAqIE1haW50YWluZXIgOiBTZWFuIFN0ZXdhcnQ8YnI+DQotwqAgwqAgwqAg
wqAgKiBNYWlsIDogPGEgaHJlZj0ibWFpbHRvOnNlYW4uc3Rld2FydEBuZXRhcHAuY29tIj5zZWFu
LnN0ZXdhcnRAbmV0YXBwLmNvbTwvYT48YnI+DQorwqAgwqAgwqAgwqAgKiBNYWludGFpbmVyIDog
QmFydCBCcm9va3MsIFBpdm90Mzxicj4NCivCoCDCoCDCoCDCoCAqIE1haWwgOiA8YSBocmVmPSJt
YWlsdG86YmFydGJAcGl2b3QzLmNvbSI+YmFydGJAcGl2b3QzLmNvbTwvYT48YnI+DQrCoCDCoCDC
oCDCoCDCoCovPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90OyhORVRBUFB8TFNJfEVOR0VOSU8pJnF1b3Q7LDxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O0lO
Ri0wMS0wMCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuYmxfcHJvZHVjdMKg
IMKgID0gJnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gJnF1b3Q7MiBwZ19pbml0X3JldHJpZXMgNTAmcXVv
dDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSAmcXVv
dDsxIHJkYWMmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLm5vX3BhdGhfcmV0
cnkgPSAzMCw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuY2hlY2tlcl9uYW1lwqAgPSBS
REFDLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJ
T19SREFDLDxicj4NCi3CoCDCoCDCoCDCoH0sPGJyPg0KLcKgIMKgIMKgIMKgezxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O1NUSyZxdW90Oyw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtG
TEVYTElORSAzODAmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmJsX3Byb2R1
Y3TCoCDCoCA9ICZxdW90O1VuaXZlcnNhbCBYcG9ydCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEgcmRhYyZxdW90Oyw8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfUVVF
VUUsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmNoZWNrZXJfbmFtZcKgID0gUkRBQyw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fUkRB
Qyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVv
dDtQSVZPVDMmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByb2R1Y3TCoCDC
oCDCoCDCoD0gJnF1b3Q7UkFJR0UgVk9MVU1FJnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gJnF1b3Q7MSBxdWV1ZV9pZl9ub19wYXRoJnF1b3Q7
LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElC
VVMsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBnZmFpbGJhY2vCoCDCoCA9IEZBSUxC
QUNLX1VOREVGLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5taW5pb8KgIMKgIMKgIMKg
IMKgPSAxMDAsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQorwqAgwqAgwqAgwqAvKjxicj4NCivC
oCDCoCDCoCDCoCAqIEludGVsPGJyPg0KK8KgIMKgIMKgIMKgICovPGJyPg0KwqAgwqAgwqAgwqAg
ezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90
O0ludGVsJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAg
wqAgwqA9ICZxdW90O011bHRpLUZsZXgmcXVvdDssPGJyPg0KQEAgLTY4Miw2ICs2ODQsOSBAQCBz
dGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9RVUVVRSw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fQUxVQSw8YnI+DQrC
oCDCoCDCoCDCoCB9LDxicj4NCivCoCDCoCDCoCDCoC8qPGJyPg0KK8KgIMKgIMKgIMKgICogTGlu
dXgtSU8gVGFyZ2V0PGJyPg0KK8KgIMKgIMKgIMKgICovPGJyPg0KwqAgwqAgwqAgwqAgezxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90OyhMSU8t
T1JHfFNVU0UpJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAg
wqAgwqAgwqA9ICZxdW90O1JCRCZxdW90Oyw8YnI+DQpAQCAtNjkwLDYgKzY5NSw5IEBAIHN0YXRp
YyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLm1pbmlvwqAgwqAgwqAgwqAgwqA9IDEwMCw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fQUxVQSw8YnI+DQrCoCDCoCDCoCDCoCB9LDxi
cj4NCivCoCDCoCDCoCDCoC8qPGJyPg0KK8KgIMKgIMKgIMKgICogRGF0YUNvcmU8YnI+DQorwqAg
wqAgwqAgwqAgKi88YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7RGF0YUNvcmUmcXVvdDssPGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7U0FObWVsb2R5JnF1
b3Q7LDxicj4NCkBAIC03MDIsNiArNzEwLDkgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1
bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9
IE5PX1BBVEhfUkVUUllfUVVFVUUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9f
bmFtZcKgIMKgIMKgPSBQUklPX0FMVUEsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQorwqAgwqAg
wqAgwqAvKjxicj4NCivCoCDCoCDCoCDCoCAqIFB1cmUgU3RvcmFnZTxicj4NCivCoCDCoCDCoCDC
oCAqLzxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVu
ZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtQVVJFJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O0ZsYXNoQXJyYXkmcXVvdDssPGJyPg0K
QEAgLTcxMCw2ICs3MjEsOSBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0g
ezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5mYXN0X2lvX2ZhaWzCoCA9IDEwLDxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5kZXZfbG9zc8KgIMKgIMKgID0gNjAsPGJyPg0KwqAg
wqAgwqAgwqAgfSw8YnI+DQorwqAgwqAgwqAgwqAvKjxicj4NCivCoCDCoCDCoCDCoCAqIEh1YXdl
aTxicj4NCivCoCDCoCDCoCDCoCAqLzxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtIVUFXRUkmcXVvdDssPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7WFNH
MSZxdW90Oyw8YnI+DQpAQCAtODA0LDE4ICs4MTgsMjkgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5
IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gTlVMTCw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSBOVUxMLDxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoC5yZXZpc2lvbsKgIMKgIMKgID0gTlVMTCw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAuYmxfcHJvZHVjdMKgIMKgID0gTlVMTCw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAucGdwb2xpY3nCoCDCoCDCoCA9IDAsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnVp
ZF9hdHRyaWJ1dGUgPSBOVUxMLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5zZWxlY3Rv
csKgIMKgIMKgID0gTlVMTCw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuY2hlY2tlcl9u
YW1lwqAgPSBOVUxMLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5mZWF0dXJlc8KgIMKg
IMKgID0gTlVMTCw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuaHdoYW5kbGVywqAgwqAg
wqA9IE5VTEwsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnNlbGVjdG9ywqAgwqAgwqAg
PSBOVUxMLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ3BvbGljecKgIMKgIMKgID0g
MCw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IE5VTEws
PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByaW9fYXJnc8KgIMKgIMKgPSBOVUxMLDxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSAwLDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ycl93ZWlnaHTCoCDCoCDCoD0gMCw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IDAsPGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgLm1pbmlvwqAgwqAgwqAgwqAgwqA9IDAsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLm1pbmlvX3JxwqAgwqAgwqAgPSAwLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oC5jaGVja2VyX25hbWXCoCA9IE5VTEwsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBy
aW9fbmFtZcKgIMKgIMKgPSBOVUxMLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcmlv
X2FyZ3PCoCDCoCDCoD0gTlVMTCw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmx1c2hf
b25fbGFzdF9kZWwgPSAwLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mYXN0X2lvX2Zh
aWzCoCA9IDAsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmRldl9sb3NzwqAgwqAgwqAg
PSAwLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5yZXRhaW5faHdoYW5kbGVyID0gTlVM
TCw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZGV0ZWN0X3ByaW/CoCDCoD0gTlVMTCw8
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZGVmZXJyZWRfcmVtb3ZlID0gTlVMTCw8YnI+
DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZGVsYXlfd2F0Y2hfY2hlY2tzID0gMCw8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZGVsYXlfd2FpdF9jaGVja3MgPSAwLDxicj4NCsKgIMKg
IMKgIMKgIH0sPGJyPg0KwqB9Ozxicj4NCjxzcGFuIGNsYXNzPSJIT0VuWmIiPjxmb250IGNvbG9y
PSIjODg4ODg4Ij48YnI+DQotLTxicj4NCjIuNy40PGJyPg0KPGJyPg0KPC9mb250Pjwvc3Bhbj48
L2Jsb2NrcXVvdGU+PC9kaXY+PGJyPjwvZGl2Pg0K
--001a11410fec4b49300538eaa6cf--


--===============8936800173422747733==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8936800173422747733==--
