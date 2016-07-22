From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/6] multipath-tools: delete attributes with
 DEFAULT_* values in hwtable.c
Date: Fri, 22 Jul 2016 11:40:25 +0200
Message-ID: <CABr-GnebnrL9fKiMhoMQTv-BJOcHAN8K47Wg=w8VVmuZ3PD=sw@mail.gmail.com>
References: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
	<1468022328-5905-2-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2615049453737133511=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468022328-5905-2-git-send-email-xose.vazquez@gmail.com>
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

--===============2615049453737133511==
Content-Type: multipart/alternative; boundary=001a1142b9986d4021053836398c

--001a1142b9986d4021053836398c
Content-Type: text/plain; charset=UTF-8

Merged.

On Sat, Jul 9, 2016 at 1:58 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

>      48                 .features      = DEFAULT_FEATURES,
>      44                 .hwhandler     = DEFAULT_HWHANDLER,
>      28                 .prio_name     = DEFAULT_PRIO,
>       1                 .minio         = DEFAULT_MINIO,
>       1                 .minio_rq      = DEFAULT_MINIO_RQ,
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 122
> -------------------------------------------------
>  1 file changed, 122 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index a89ea87..6d87cf4 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -28,13 +28,10 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "COMPELNT",
>                 .product       = "Compellent Vol",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         /*
> @@ -46,13 +43,10 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "APPLE.*",
>                 .product       = "Xserve RAID",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         /*
> @@ -61,13 +55,10 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "3PARdata",
>                 .product       = "VV",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
> @@ -86,13 +77,10 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "HP",
>                 .product       = "A6189A",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = 12,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
> @@ -114,8 +102,6 @@ static struct hwentry default_hw[] = {
>                 /* MSA 1000/1500 with new firmware */
>                 .vendor        = "(COMPAQ|HP)",
>                 .product       = "MSA VOLUME",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -128,8 +114,6 @@ static struct hwentry default_hw[] = {
>                 /* EVA 3000/5000 with new firmware, EVA 4000/6000/8000 */
>                 .vendor        = "(COMPAQ|HP)",
>                 .product       =
> "HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -142,22 +126,17 @@ static struct hwentry default_hw[] = {
>                 /* HP MSA2000 family with old firmware */
>                 .vendor        = "HP",
>                 .product       = "MSA2[02]12fc|MSA2012i",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = 18,
>                 .minio         = 100,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
>                 /* HP MSA2000 family with new firmware */
>                 .vendor        = "HP",
>                 .product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s
> VOLUME",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -170,8 +149,6 @@ static struct hwentry default_hw[] = {
>                 /* HP MSA 1040/2040 family */
>                 .vendor        = "HP",
>                 .product       = "MSA (1|2)040 SA(N|S)",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -184,7 +161,6 @@ static struct hwentry default_hw[] = {
>                 /* HP SVSP */
>                 .vendor        = "HP",
>                 .product       = "HSVX700",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -198,21 +174,16 @@ static struct hwentry default_hw[] = {
>                 /* HP Smart Array */
>                 .vendor        = "HP",
>                 .product       = "LOGICAL VOLUME.*",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = 12,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
>                 /* HP P2000 family */
>                 .vendor        = "HP",
>                 .product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3
> SAS|P2000 G3 iSCSI",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -227,13 +198,10 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "DDN",
>                 .product       = "SAN DataDirector",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         /*
> @@ -245,13 +213,10 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "EMC",
>                 .product       = "SYMMETRIX",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = 6,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
> @@ -275,25 +240,19 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "EMC",
>                 .product       = "Invista",
>                 .bl_product    = "LUNZ",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = 5,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
>                 .vendor        = "XtremIO",
>                 .product       = "XtremApp",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .selector      = "queue-length 0",
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .fast_io_fail  = 5,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         /*
> @@ -302,20 +261,16 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "FSC",
>                 .product       = "CentricStor",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_SERIAL,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
>                 .vendor        = "FUJITSU",
>                 .product       = "ETERNUS_DX(H|L|M|400|8000)",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -332,20 +287,16 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "(HITACHI|HP)",
>                 .product       = "OPEN-.*",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
>                 .vendor        = "HITACHI",
>                 .product       = "DF.*",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -362,13 +313,10 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "IBM",
>                 .product       = "ProFibre 4000R",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
> @@ -421,7 +369,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^1742",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -450,7 +397,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^1814",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -465,7 +411,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^1815",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -480,7 +425,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^1818",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -495,7 +439,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^3526",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -509,13 +452,10 @@ static struct hwentry default_hw[] = {
>                 /* IBM DS4200 / FAStT200 */
>                 .vendor        = "IBM",
>                 .product       = "^3542",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_SERIAL,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
> @@ -523,12 +463,10 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^2105800",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_SERIAL,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
> @@ -536,12 +474,10 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^2105F20",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_SERIAL,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
> @@ -549,7 +485,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^1750500",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -562,12 +497,10 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^2107900",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
> @@ -575,7 +508,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^2145",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -590,12 +522,10 @@ static struct hwentry default_hw[] = {
>                 .bl_product    = "S/390.*",
>                 .uid_attribute = "ID_UID",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
> @@ -605,12 +535,10 @@ static struct hwentry default_hw[] = {
>                 .bl_product    = "S/390.*",
>                 .uid_attribute = "ID_UID",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
> @@ -630,8 +558,6 @@ static struct hwentry default_hw[] = {
>                 /* IBM RSSM */
>                 .vendor        = "IBM",
>                 .product       = "1820N00",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -645,13 +571,11 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "2810XIV",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = 15,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
>                 .minio         = 15,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         /*
> @@ -664,33 +588,26 @@ static struct hwentry default_hw[] = {
>                 /* AIX VDASD */
>                 .vendor        = "AIX",
>                 .product       = "VDASD",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = (300 / DEFAULT_CHECKINT),
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
>                 /* IBM 3303 NVDISK */
>                 .vendor        = "IBM",
>                 .product       = "3303      NVDISK",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = FAILOVER,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = (300 / DEFAULT_CHECKINT),
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
>                 /* AIX NVDISK */
>                 .vendor        = "AIX",
>                 .product       = "NVDISK",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -757,7 +674,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "NETAPP",
>                 .product       = "LUN.*",
>                 .features      = "3 queue_if_no_path pg_init_retries 50",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .flush_on_last_del = FLUSH_ENABLED,
> @@ -775,7 +691,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "Nseries.*",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -794,13 +709,11 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "NEXENTA",
>                 .product       = "COMSTAR",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_SERIAL,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = 30,
>                 .minio         = 128,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         /*
> @@ -812,8 +725,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "Pillar",
>                 .product       = "Axiom.*",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -827,20 +738,16 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "SGI",
>                 .product       = "TP9[13]00",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
>                 .vendor        = "SGI",
>                 .product       = "TP9[45]00",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -871,7 +778,6 @@ static struct hwentry default_hw[] = {
>                 /* M-Series */
>                 .vendor        = "NEC",
>                 .product       = "DISK ARRAY",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -887,7 +793,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "STK",
>                 .product       = "OPENstorage D280",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -903,20 +808,16 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "SUN",
>                 .product       = "(StorEdge 3510|T4)",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
>                 .vendor        = "SUN",
>                 .product       = "STK6580_6780",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -929,13 +830,10 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "EUROLOGC",
>                 .product       = "FC2502",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         /*
> @@ -948,20 +846,17 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "PIVOT3",
>                 .product       = "RAIGE VOLUME",
>                 .features      = "1 queue_if_no_path",
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
>                 .minio         = 100,
> -               .prio_name     = DEFAULT_PRIO,
>                 .prio_args     = NULL,
>         },
>         {
>                 .vendor        = "SUN",
>                 .product       = "CSM200_R",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -976,7 +871,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "SUN",
>                 .product       = "LCSM100_[IEFS]",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -991,14 +885,11 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "SUN",
>                 .product       = "SUN_6180",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> -               .minio         = DEFAULT_MINIO,
> -               .minio_rq      = DEFAULT_MINIO_RQ,
>                 .checker_name  = RDAC,
>                 .prio_name     = PRIO_RDAC,
>         },
> @@ -1027,7 +918,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "STK",
>                 .product       = "FLEXLINE 380",
>                 .bl_product    = "Universal Xport",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 rdac",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -1040,7 +930,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "Intel",
>                 .product       = "Multi-Flex",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -1052,7 +941,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "(LIO-ORG|SUSE)",
>                 .product       = "RBD",
> -               .features      = DEFAULT_FEATURES,
>                 .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -1065,8 +953,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "DataCore",
>                 .product       = "SANmelody",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -1077,8 +963,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "DataCore",
>                 .product       = "Virtual Disk",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .rr_weight     = RR_WEIGHT_NONE,
> @@ -1089,13 +973,10 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "PURE",
>                 .product       = "FlashArray",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .selector      = "queue-length 0",
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .fast_io_fail  = 10,
> -               .prio_name     = DEFAULT_PRIO,
>                 .no_path_retry = 0,
>                 .dev_loss      = 60,
>                 .prio_args     = NULL,
> @@ -1103,8 +984,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "HUAWEI",
>                 .product       = "XSG1",
> -               .features      = DEFAULT_FEATURES,
> -               .hwhandler     = DEFAULT_HWHANDLER,
>                 .pgpolicy      = MULTIBUS,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>         },
> @@ -1132,7 +1011,6 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .selector      = "round-robin 0",
> -               .features      = DEFAULT_FEATURES,
>                 .pgfailback    = 30,
>                 .rr_weight     = RR_WEIGHT_PRIO,
>                 .no_path_retry = NO_PATH_RETRY_FAIL,
> --
> 2.7.4
>
>

--001a1142b9986d4021053836398c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+TWVyZ2VkLjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI+
PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIFNhdCwgSnVsIDksIDIwMTYgYXQgMTo1OCBBTSwg
WG9zZSBWYXpxdWV6IFBlcmV6IDxzcGFuIGRpcj0ibHRyIj4mbHQ7PGEgaHJlZj0ibWFpbHRvOnhv
c2UudmF6cXVlekBnbWFpbC5jb20iIHRhcmdldD0iX2JsYW5rIj54b3NlLnZhenF1ZXpAZ21haWwu
Y29tPC9hPiZndDs8L3NwYW4+IHdyb3RlOjxicj48YmxvY2txdW90ZSBjbGFzcz0iZ21haWxfcXVv
dGUiIHN0eWxlPSJtYXJnaW46MCAwIDAgLjhleDtib3JkZXItbGVmdDoxcHggI2NjYyBzb2xpZDtw
YWRkaW5nLWxlZnQ6MWV4Ij7CoCDCoCDCoDQ4wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVh
dHVyZXPCoCDCoCDCoCA9IERFRkFVTFRfRkVBVFVSRVMsPGJyPg0KwqAgwqAgwqA0NMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hXSEFORExFUiw8
YnI+DQrCoCDCoCDCoDI4wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAg
wqA9IERFRkFVTFRfUFJJTyw8YnI+DQrCoCDCoCDCoCAxwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAubWluaW/CoCDCoCDCoCDCoCDCoD0gREVGQVVMVF9NSU5JTyw8YnI+DQrCoCDCoCDCoCAxwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAubWluaW9fcnHCoCDCoCDCoCA9IERFRkFVTFRfTUlOSU9f
UlEsPGJyPg0KPGJyPg0KQ2M6IENocmlzdG9waGUgVmFyb3F1aSAmbHQ7PGEgaHJlZj0ibWFpbHRv
OmNocmlzdG9waGUudmFyb3F1aUBvcGVuc3ZjLmNvbSI+Y2hyaXN0b3BoZS52YXJvcXVpQG9wZW5z
dmMuY29tPC9hPiZndDs8YnI+DQpDYzogZGV2aWNlLW1hcHBlciBkZXZlbG9wbWVudCAmbHQ7PGEg
aHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRtLWRldmVsQHJlZGhhdC5jb208L2E+
Jmd0Ozxicj4NClNpZ25lZC1vZmYtYnk6IFhvc2UgVmF6cXVleiBQZXJleiAmbHQ7PGEgaHJlZj0i
bWFpbHRvOnhvc2UudmF6cXVlekBnbWFpbC5jb20iPnhvc2UudmF6cXVlekBnbWFpbC5jb208L2E+
Jmd0Ozxicj4NCi0tLTxicj4NCsKgbGlibXVsdGlwYXRoL2h3dGFibGUuYyB8IDEyMiAtLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tPGJyPg0KwqAxIGZpbGUg
Y2hhbmdlZCwgMTIyIGRlbGV0aW9ucygtKTxicj4NCjxicj4NCmRpZmYgLS1naXQgYS9saWJtdWx0
aXBhdGgvaHd0YWJsZS5jIGIvbGlibXVsdGlwYXRoL2h3dGFibGUuYzxicj4NCmluZGV4IGE4OWVh
ODcuLjZkODdjZjQgMTAwNjQ0PGJyPg0KLS0tIGEvbGlibXVsdGlwYXRoL2h3dGFibGUuYzxicj4N
CisrKyBiL2xpYm11bHRpcGF0aC9od3RhYmxlLmM8YnI+DQpAQCAtMjgsMTMgKzI4LDEwIEBAIHN0
YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgezxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0NP
TVBFTE5UJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAg
wqAgwqA9ICZxdW90O0NvbXBlbGxlbnQgVm9sJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJFUyw8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9IERFRkFVTFRfSFdIQU5ETEVSLDxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMs
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IC1GQUlMQkFD
S19JTU1FRElBVEUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnJyX3dlaWdodMKgIMKg
IMKgPSBSUl9XRUlHSFRfTk9ORSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0
aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfUVVFVUUsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgLnByaW9fbmFtZcKgIMKgIMKgPSBERUZBVUxUX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgLnByaW9fYXJnc8KgIMKgIMKgPSBOVUxMLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJy
Pg0KwqAgwqAgwqAgwqAgLyo8YnI+DQpAQCAtNDYsMTMgKzQzLDEwIEBAIHN0YXRpYyBzdHJ1Y3Qg
aHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0FQUExFLiomcXVvdDss
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7
WHNlcnZlIFJBSUQmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZlYXR1cmVz
wqAgwqAgwqAgPSBERUZBVUxUX0ZFQVRVUkVTLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oC5od2hhbmRsZXLCoCDCoCDCoD0gREVGQVVMVF9IV0hBTkRMRVIsPGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLnJyX3dlaWdodMKgIMKgIMKgPSBSUl9XRUlHSFRfTk9ORSw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVU
UllfVU5ERUYsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByaW9fbmFtZcKgIMKgIMKg
PSBERUZBVUxUX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9fYXJnc8Kg
IMKgIMKgPSBOVUxMLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgLyo8YnI+
DQpAQCAtNjEsMTMgKzU1LDEwIEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10g
PSB7PGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5k
b3LCoCDCoCDCoCDCoCA9ICZxdW90OzNQQVJkYXRhJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O1ZWJnF1b3Q7LDxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJFUyw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9IERFRkFVTFRf
SFdIQU5ETEVSLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKg
ID0gTVVMVElCVVMsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDC
oCA9IEZBSUxCQUNLX1VOREVGLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ycl93ZWln
aHTCoCDCoCDCoD0gUlJfV0VJR0hUX05PTkUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
Lm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1VOREVGLDxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC5wcmlvX25hbWXCoCDCoCDCoD0gREVGQVVMVF9QUklPLDxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC5wcmlvX2FyZ3PCoCDCoCDCoD0gTlVMTCw8YnI+DQrCoCDCoCDCoCDC
oCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQpAQCAtODYsMTMgKzc3LDEwIEBAIHN0YXRpYyBz
dHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0hQJnF1b3Q7
LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90
O0E2MTg5QSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDC
oCDCoCA9IERFRkFVTFRfRkVBVFVSRVMsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3
aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hXSEFORExFUiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gMTIsPGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLnByaW9fbmFtZcKgIMKgIMKgPSBERUZBVUxUX1BSSU8sPGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9fYXJnc8KgIMKgIMKgPSBOVUxMLDxicj4NCsKg
IMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCkBAIC0xMTQsOCArMTAyLDYgQEAg
c3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAvKiBNU0EgMTAwMC8xNTAwIHdpdGggbmV3IGZpcm13YXJlICovPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7KENPTVBBUXxI
UCkmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDC
oD0gJnF1b3Q7TVNBIFZPTFVNRSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAu
ZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFVTFRfRkVBVFVSRVMsPGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hXSEFORExFUiw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1BSSU8sPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IC1GQUlMQkFDS19J
TU1FRElBVEUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnJyX3dlaWdodMKgIMKgIMKg
PSBSUl9XRUlHSFRfTk9ORSw8YnI+DQpAQCAtMTI4LDggKzExNCw2IEBAIHN0YXRpYyBzdHJ1Y3Qg
aHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLyog
RVZBIDMwMDAvNTAwMCB3aXRoIG5ldyBmaXJtd2FyZSwgRVZBIDQwMDAvNjAwMC84MDAwICovPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7KENP
TVBBUXxIUCkmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDC
oCDCoCDCoD0gJnF1b3Q7SFNWMVswMV0xfEhTVjJbMDFdMHxIU1YzWzA0Nl0wfEhTVjRbMDVdMCZx
dW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9IERF
RkFVTFRfRkVBVFVSRVMsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKg
IMKgIMKgPSBERUZBVUxUX0hXSEFORExFUiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAu
cGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IC1GQUlMQkFDS19JTU1FRElBVEUsPGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLnJyX3dlaWdodMKgIMKgIMKgPSBSUl9XRUlHSFRfTk9ORSw8YnI+
DQpAQCAtMTQyLDIyICsxMjYsMTcgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdb
XSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBIUCBNU0EyMDAwIGZhbWlseSB3
aXRoIG9sZCBmaXJtd2FyZSAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LC
oCDCoCDCoCDCoCA9ICZxdW90O0hQJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O01TQTJbMDJdMTJmY3xNU0EyMDEyaSZxdW90Oyw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFVTFRf
RkVBVFVSRVMsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKg
PSBERUZBVUxUX0hXSEFORExFUiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xp
Y3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2Zh
aWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5ycl93ZWlnaHTCoCDCoCDCoD0gUlJfV0VJR0hUX05PTkUsPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLm5vX3BhdGhfcmV0cnkgPSAxOCw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAubWluaW/CoCDCoCDCoCDCoCDCoD0gMTAwLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoC5wcmlvX25hbWXCoCDCoCDCoD0gREVGQVVMVF9QUklPLDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5wcmlvX2FyZ3PCoCDCoCDCoD0gTlVMTCw8YnI+DQrCoCDCoCDCoCDCoCB9
LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBIUCBN
U0EyMDAwIGZhbWlseSB3aXRoIG5ldyBmaXJtd2FyZSAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0hQJnF1b3Q7LDxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O01TQTIwMTJzYXxNU0Ey
MygxMnwyNCkoZmN8aXxzYSl8TVNBMjAwMHMgVk9MVU1FJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJFUyw8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9IERFRkFVTFRfSFdIQU5E
TEVSLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gR1JP
VVBfQllfUFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKg
ID0gLUZBSUxCQUNLX0lNTUVESUFURSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJf
d2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCkBAIC0xNzAsOCArMTQ5LDYgQEAg
c3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAvKiBIUCBNU0EgMTA0MC8yMDQwIGZhbWlseSAqLzxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0hQJnF1b3Q7LDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O01TQSAoMXwy
KTA0MCBTQShOfFMpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJl
c8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJFUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAuaHdoYW5kbGVywqAgwqAgwqA9IERFRkFVTFRfSFdIQU5ETEVSLDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gR1JPVVBfQllfUFJJTyw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lNTUVESUFU
RSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dF
SUdIVF9OT05FLDxicj4NCkBAIC0xODQsNyArMTYxLDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5
IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBIUCBTVlNQ
ICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1
b3Q7SFAmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDC
oCDCoD0gJnF1b3Q7SFNWWDcwMCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAu
ZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFVTFRfRkVBVFVSRVMsPGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgLmh3aGFuZGxlcsKgIMKgIMKgPSAmcXVvdDsxIGFsdWEmcXVvdDssPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9QUklPLDxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tf
SU1NRURJQVRFLDxicj4NCkBAIC0xOTgsMjEgKzE3NCwxNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50
cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC8qIEhQIFNt
YXJ0IEFycmF5ICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKg
IMKgID0gJnF1b3Q7SFAmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1
Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7TE9HSUNBTCBWT0xVTUUuKiZxdW90Oyw8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFVTFRfRkVBVFVSRVMsPGJy
Pg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hX
SEFORExFUiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9
IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAg
PSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0
wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5u
b19wYXRoX3JldHJ5ID0gMTIsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByaW9fbmFt
ZcKgIMKgIMKgPSBERUZBVUxUX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBy
aW9fYXJnc8KgIMKgIMKgPSBOVUxMLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAg
wqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC8qIEhQIFAyMDAwIGZhbWlseSAqLzxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0hQ
JnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9
ICZxdW90O1AyMDAwIEczIEZDfFAyMDAwRzMgRkMvaVNDU0l8UDIwMDAgRzMgU0FTfFAyMDAwIEcz
IGlTQ1NJJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKg
IMKgID0gREVGQVVMVF9GRUFUVVJFUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdo
YW5kbGVywqAgwqAgwqA9IERFRkFVTFRfSFdIQU5ETEVSLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gR1JPVVBfQllfUFJJTyw8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lNTUVESUFURSw8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9O
T05FLDxicj4NCkBAIC0yMjcsMTMgKzE5OCwxMCBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVm
YXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtERE4mcXVvdDssPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7U0FOIERhdGFEaXJlY3Rv
ciZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9
IERFRkFVTFRfRkVBVFVSRVMsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxl
csKgIMKgIMKgPSBERUZBVUxUX0hXSEFORExFUiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9VTkRFRiw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IERFRkFVTFRf
UFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19hcmdzwqAgwqAgwqA9IE5V
TEwsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCAvKjxicj4NCkBAIC0yNDUs
MTMgKzIxMywxMCBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4N
CsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAg
wqAgwqAgPSAmcXVvdDtFTUMmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBy
b2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7U1lNTUVUUklYJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJFUyw8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9IERFRkFVTFRfSFdIQU5E
TEVSLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gTVVM
VElCVVMsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IEZB
SUxCQUNLX1VOREVGLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ycl93ZWlnaHTCoCDC
oCDCoD0gUlJfV0VJR0hUX05PTkUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLm5vX3Bh
dGhfcmV0cnkgPSA2LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcmlvX25hbWXCoCDC
oCDCoD0gREVGQVVMVF9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX2Fy
Z3PCoCDCoCDCoD0gTlVMTCw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8
YnI+DQpAQCAtMjc1LDI1ICsyNDAsMTkgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRf
aHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAg
PSAmcXVvdDtFTUMmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TC
oCDCoCDCoCDCoD0gJnF1b3Q7SW52aXN0YSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAuYmxfcHJvZHVjdMKgIMKgID0gJnF1b3Q7TFVOWiZxdW90Oyw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFVTFRfRkVBVFVSRVMsPGJyPg0K
LcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hXSEFO
RExFUiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IE1V
TFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSBG
QUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAg
wqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19w
YXRoX3JldHJ5ID0gNSw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAg
wqAgwqA9IERFRkFVTFRfUFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19h
cmdzwqAgwqAgwqA9IE5VTEwsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7
WHRyZW1JTyZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKg
IMKgIMKgPSAmcXVvdDtYdHJlbUFwcCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAuZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFVTFRfRkVBVFVSRVMsPGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hXSEFORExFUiw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuc2VsZWN0b3LCoCDCoCDCoCA9ICZxdW90O3F1ZXVlLWxl
bmd0aCAwJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKg
IMKgID0gTVVMVElCVVMsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vC
oCDCoCA9IEZBSUxCQUNLX1VOREVGLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5mYXN0
X2lvX2ZhaWzCoCA9IDUsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByaW9fbmFtZcKg
IMKgIMKgPSBERUZBVUxUX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9f
YXJnc8KgIMKgIMKgPSBOVUxMLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAg
Lyo8YnI+DQpAQCAtMzAyLDIwICsyNjEsMTYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1
bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7RlNDJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O0NlbnRyaWNTdG9yJnF1b3Q7
LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVM
VF9GRUFUVVJFUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAg
wqA9IERFRkFVTFRfSFdIQU5ETEVSLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3Bv
bGljecKgIMKgIMKgID0gR1JPVVBfQllfU0VSSUFMLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9VTkRFRiw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IERFRkFVTFRf
UFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19hcmdzwqAgwqAgwqA9IE5V
TEwsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7RlVKSVRTVSZxdW90Oyw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtF
VEVSTlVTX0RYKEh8THxNfDQwMHw4MDAwKSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAuZmVhdHVyZXPCoCDCoCDCoCA9ICZxdW90OzEgcXVldWVfaWZfbm9fcGF0aCZxdW90Oyw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9IERFRkFVTFRf
SFdIQU5ETEVSLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKg
ID0gR1JPVVBfQllfUFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFj
a8KgIMKgID0gLUZBSUxCQUNLX0lNTUVESUFURSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAucnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCkBAIC0zMzIsMjAgKzI4
NywxNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKg
IMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAg
PSAmcXVvdDsoSElUQUNISXxIUCkmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7T1BFTi0uKiZxdW90Oyw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFVTFRfRkVBVFVSRVMsPGJyPg0K
LcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hXSEFO
RExFUiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IE1V
TFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSBG
QUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAg
wqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19w
YXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9VTkRFRiw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IERFRkFVTFRfUFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAucHJpb19hcmdzwqAgwqAgwqA9IE5VTEwsPGJyPg0KwqAgwqAgwqAgwqAgfSw8
YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKg
IMKgIMKgIMKgID0gJnF1b3Q7SElUQUNISSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtERi4qJnF1b3Q7LDxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC5mZWF0dXJlc8KgIMKgIMKgID0gJnF1b3Q7MSBxdWV1ZV9pZl9ub19w
YXRoJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5od2hhbmRsZXLCoCDCoCDC
oD0gREVGQVVMVF9IV0hBTkRMRVIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9s
aWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC5wZ2ZhaWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5ycl93ZWlnaHTCoCDCoCDCoD0gUlJfV0VJR0hUX05PTkUsPGJyPg0KQEAg
LTM2MiwxMyArMzEzLDEwIEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7
PGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LC
oCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtQcm9GaWJyZSA0MDAwUiZxdW90Oyw8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFVTFRfRkVBVFVS
RVMsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSBERUZB
VUxUX0hXSEFORExFUiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDC
oCDCoCA9IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNr
wqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJf
d2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9VTkRFRiw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IERFRkFVTFRfUFJJTyw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19hcmdzwqAgwqAgwqA9IE5VTEwsPGJyPg0KwqAgwqAg
wqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KQEAgLTQyMSw3ICszNjksNiBAQCBzdGF0
aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDteMTc0MiZxdW90Oyw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuYmxfcHJvZHVjdMKgIMKgID0gJnF1b3Q7VW5p
dmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJl
c8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJFUyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEgcmRhYyZxdW90Oyw8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1BSSU8sPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IC1GQUlMQkFDS19JTU1FRElB
VEUsPGJyPg0KQEAgLTQ1MCw3ICszOTcsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVs
dF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDC
oCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVj
dMKgIMKgIMKgIMKgPSAmcXVvdDteMTgxNCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAuYmxfcHJvZHVjdMKgIMKgID0gJnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFU
VVJFUyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuaHdoYW5kbGVywqAgwqAgwqA9ICZx
dW90OzEgcmRhYyZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nC
oCDCoCDCoCA9IEdST1VQX0JZX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBn
ZmFpbGJhY2vCoCDCoCA9IC1GQUlMQkFDS19JTU1FRElBVEUsPGJyPg0KQEAgLTQ2NSw3ICs0MTEs
NiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDteMTgx
NSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuYmxfcHJvZHVjdMKgIMKgID0g
JnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJFUyw8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEgcmRhYyZxdW90Oyw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1BSSU8s
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IC1GQUlMQkFD
S19JTU1FRElBVEUsPGJyPg0KQEAgLTQ4MCw3ICs0MjUsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50
cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LC
oCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDteMTgxOCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAuYmxfcHJvZHVjdMKgIMKgID0gJnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1
b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVG
QVVMVF9GRUFUVVJFUyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuaHdoYW5kbGVywqAg
wqAgwqA9ICZxdW90OzEgcmRhYyZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAu
cGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IC1GQUlMQkFDS19JTU1FRElBVEUsPGJyPg0KQEAgLTQ5
NSw3ICs0MzksNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZx
dW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAm
cXVvdDteMzUyNiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuYmxfcHJvZHVj
dMKgIMKgID0gJnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJFUyw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEgcmRhYyZxdW90
Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQ
X0JZX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9
IC1GQUlMQkFDS19JTU1FRElBVEUsPGJyPg0KQEAgLTUwOSwxMyArNDUyLDEwIEBAIHN0YXRpYyBz
dHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLyogSUJNIERTNDIwMCAvIEZBU3RUMjAwICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SUJNJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O14zNTQyJnF1b3Q7LDxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFU
VVJFUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9IERF
RkFVTFRfSFdIQU5ETEVSLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKg
IMKgIMKgID0gR1JPVVBfQllfU0VSSUFMLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5w
Z2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9VTkRFRiw8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IERFRkFVTFRfUFJJTyw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19hcmdzwqAgwqAgwqA9IE5VTEwsPGJy
Pg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KQEAgLTUyMywxMiArNDYz
LDEwIEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SUJNJnF1b3Q7LDxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O14y
MTA1ODAwJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5mZWF0dXJlc8KgIMKg
IMKgID0gJnF1b3Q7MSBxdWV1ZV9pZl9ub19wYXRoJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC5od2hhbmRsZXLCoCDCoCDCoD0gREVGQVVMVF9IV0hBTkRMRVIsPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9TRVJJQUws
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IEZBSUxCQUNL
X1VOREVGLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ycl93ZWlnaHTCoCDCoCDCoD0g
UlJfV0VJR0hUX05PTkUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLm5vX3BhdGhfcmV0
cnkgPSBOT19QQVRIX1JFVFJZX1VOREVGLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5w
cmlvX25hbWXCoCDCoCDCoD0gREVGQVVMVF9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wcmlvX2FyZ3PCoCDCoCDCoD0gTlVMTCw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKg
IMKgIMKgIMKgIHs8YnI+DQpAQCAtNTM2LDEyICs0NzQsMTAgQEAgc3RhdGljIHN0cnVjdCBod2Vu
dHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9y
wqAgwqAgwqAgwqAgPSAmcXVvdDtJQk0mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7XjIxMDVGMjAmcXVvdDssPGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLmZlYXR1cmVzwqAgwqAgwqAgPSAmcXVvdDsxIHF1ZXVlX2lmX25v
X3BhdGgmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKg
IMKgPSBERUZBVUxUX0hXSEFORExFUiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdw
b2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1NFUklBTCw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLnJyX3dlaWdodMKgIMKgIMKgPSBSUl9XRUlHSFRfTk9ORSw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYs
PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByaW9fbmFtZcKgIMKgIMKgPSBERUZBVUxU
X1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9fYXJnc8KgIMKgIMKgPSBO
VUxMLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCkBAIC01NDks
NyArNDg1LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtJQk0mcXVv
dDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1
b3Q7XjE3NTA1MDAmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmZlYXR1cmVz
wqAgwqAgwqAgPSAmcXVvdDsxIHF1ZXVlX2lmX25vX3BhdGgmcXVvdDssPGJyPg0KLcKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hXSEFORExFUiw8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1BS
SU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IC1GQUlM
QkFDS19JTU1FRElBVEUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnJyX3dlaWdodMKg
IMKgIMKgPSBSUl9XRUlHSFRfTk9ORSw8YnI+DQpAQCAtNTYyLDEyICs0OTcsMTAgQEAgc3RhdGlj
IHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtJQk0mcXVvdDssPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7XjIxMDc5MDAmcXVvdDss
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmZlYXR1cmVzwqAgwqAgwqAgPSAmcXVvdDsx
IHF1ZXVlX2lmX25vX3BhdGgmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3
aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hXSEFORExFUiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9V
TkRFRiw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IERF
RkFVTFRfUFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19hcmdzwqAgwqAg
wqA9IE5VTEwsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KQEAg
LTU3NSw3ICs1MDgsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lC
TSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKg
PSAmcXVvdDteMjE0NSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuZmVhdHVy
ZXPCoCDCoCDCoCA9ICZxdW90OzEgcXVldWVfaWZfbm9fcGF0aCZxdW90Oyw8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9IERFRkFVTFRfSFdIQU5ETEVSLDxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gR1JPVVBfQllf
UFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gLUZB
SUxCQUNLX0lNTUVESUFURSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0
wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCkBAIC01OTAsMTIgKzUyMiwxMCBAQCBzdGF0
aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5ibF9wcm9kdWN0wqAgwqAgPSAmcXVvdDtTLzM5MC4qJnF1b3Q7LDxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC51aWRfYXR0cmlidXRlID0gJnF1b3Q7SURfVUlEJnF1b3Q7LDxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5mZWF0dXJlc8KgIMKgIMKgID0gJnF1b3Q7MSBx
dWV1ZV9pZl9ub19wYXRoJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5od2hh
bmRsZXLCoCDCoCDCoD0gREVGQVVMVF9IV0hBTkRMRVIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnJyX3dlaWdodMKgIMKgIMKgPSBSUl9XRUlHSFRfTk9ORSw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5E
RUYsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByaW9fbmFtZcKgIMKgIMKgPSBERUZB
VUxUX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9fYXJnc8KgIMKgIMKg
PSBOVUxMLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCkBAIC02
MDUsMTIgKzUzNSwxMCBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ibF9wcm9kdWN0wqAgwqAgPSAmcXVvdDtTLzM5
MC4qJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC51aWRfYXR0cmlidXRlID0g
JnF1b3Q7SURfVUlEJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5mZWF0dXJl
c8KgIMKgIMKgID0gJnF1b3Q7MSBxdWV1ZV9pZl9ub19wYXRoJnF1b3Q7LDxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC5od2hhbmRsZXLCoCDCoCDCoD0gREVGQVVMVF9IV0hBTkRMRVIsPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tf
VU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnJyX3dlaWdodMKgIMKgIMKgPSBS
Ul9XRUlHSFRfTk9ORSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRy
eSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBy
aW9fbmFtZcKgIMKgIMKgPSBERUZBVUxUX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnByaW9fYXJnc8KgIMKgIMKgPSBOVUxMLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAg
wqAgwqAgwqAgezxicj4NCkBAIC02MzAsOCArNTU4LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5
IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBJQk0gUlNT
TSAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZx
dW90O0lCTSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKg
IMKgIMKgPSAmcXVvdDsxODIwTjAwJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJFUyw8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9IERFRkFVTFRfSFdIQU5ETEVSLDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gR1JPVVBfQllfUFJJTyw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNL
X0lNTUVESUFURSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAg
wqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCkBAIC02NDUsMTMgKzU3MSwxMSBAQCBzdGF0aWMgc3Ry
dWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDsyODEwWElWJnF1b3Q7LDxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5mZWF0dXJlc8KgIMKgIMKgID0gJnF1b3Q7MSBxdWV1
ZV9pZl9ub19wYXRoJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5od2hhbmRs
ZXLCoCDCoCDCoD0gREVGQVVMVF9IV0hBTkRMRVIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucGdmYWlsYmFja8KgIMKgID0gMTUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LnJyX3dlaWdodMKgIMKgIMKgPSBSUl9XRUlHSFRfTk9ORSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsPGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLm1pbmlvwqAgwqAgwqAgwqAgwqA9IDE1LDxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC5wcmlvX25hbWXCoCDCoCDCoD0gREVGQVVMVF9QUklPLDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX2FyZ3PCoCDCoCDCoD0gTlVMTCw8YnI+DQrCoCDC
oCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIC8qPGJyPg0KQEAgLTY2NCwzMyArNTg4LDI2IEBA
IHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLyogQUlYIFZEQVNEICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7QUlYJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O1ZEQVNEJnF1b3Q7LDxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJF
Uyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9IERFRkFV
TFRfSFdIQU5ETEVSLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKg
IMKgID0gTVVMVElCVVMsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vC
oCDCoCA9IC1GQUlMQkFDS19JTU1FRElBVEUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LnJyX3dlaWdodMKgIMKgIMKgPSBSUl9XRUlHSFRfTk9ORSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9ICgzMDAgLyBERUZBVUxUX0NIRUNLSU5UKSw8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IERFRkFVTFRfUFJJTyw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19hcmdzwqAgwqAgwqA9IE5VTEwsPGJy
Pg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgLyogSUJNIDMzMDMgTlZESVNLICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SUJNJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90OzMzMDPCoCDCoCDCoCBOVkRJ
U0smcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAg
PSBERUZBVUxUX0ZFQVRVUkVTLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5od2hhbmRs
ZXLCoCDCoCDCoD0gREVGQVVMVF9IV0hBTkRMRVIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnBncG9saWN5wqAgwqAgwqAgPSBGQUlMT1ZFUiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lNTUVESUFURSw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gKDMwMCAvIERFRkFVTFRf
Q0hFQ0tJTlQpLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcmlvX25hbWXCoCDCoCDC
oD0gREVGQVVMVF9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX2FyZ3PC
oCDCoCDCoD0gTlVMTCw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBBSVggTlZESVNLICovPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7QUlYJnF1b3Q7LDxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O05WRElT
SyZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9
IERFRkFVTFRfRkVBVFVSRVMsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmh3aGFuZGxl
csKgIMKgIMKgPSAmcXVvdDsxIGFsdWEmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnBncG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCkBA
IC03NTcsNyArNjc0LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtO
RVRBUFAmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDC
oCDCoD0gJnF1b3Q7TFVOLiomcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmZl
YXR1cmVzwqAgwqAgwqAgPSAmcXVvdDszIHF1ZXVlX2lmX25vX3BhdGggcGdfaW5pdF9yZXRyaWVz
IDUwJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5od2hhbmRsZXLCoCDCoCDC
oD0gREVGQVVMVF9IV0hBTkRMRVIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9s
aWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC5wZ2ZhaWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5mbHVzaF9vbl9sYXN0X2RlbCA9IEZMVVNIX0VOQUJMRUQsPGJyPg0KQEAg
LTc3NSw3ICs2OTEsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lC
TSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKg
PSAmcXVvdDtOc2VyaWVzLiomcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmZl
YXR1cmVzwqAgwqAgwqAgPSAmcXVvdDsxIHF1ZXVlX2lmX25vX3BhdGgmcXVvdDssPGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hXSEFORExF
Uiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQ
X0JZX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9
IC1GQUlMQkFDS19JTU1FRElBVEUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnJyX3dl
aWdodMKgIMKgIMKgPSBSUl9XRUlHSFRfTk9ORSw8YnI+DQpAQCAtNzk0LDEzICs3MDksMTEgQEAg
c3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtORVhFTlRBJnF1b3Q7LDxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O0NPTVNU
QVImcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmZlYXR1cmVzwqAgwqAgwqAg
PSAmcXVvdDsxIHF1ZXVlX2lmX25vX3BhdGgmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hXSEFORExFUiw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1NFUklBTCw8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lN
TUVESUFURSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAgwqA9
IFJSX1dFSUdIVF9OT05FLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3Jl
dHJ5ID0gMzAsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLm1pbmlvwqAgwqAgwqAgwqAg
wqA9IDEyOCw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9
IERFRkFVTFRfUFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19hcmdzwqAg
wqAgwqA9IE5VTEwsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCAvKjxicj4N
CkBAIC04MTIsOCArNzI1LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9
IHs8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRv
csKgIMKgIMKgIMKgID0gJnF1b3Q7UGlsbGFyJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O0F4aW9tLiomcXVvdDssPGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAgPSBERUZBVUxUX0ZFQVRVUkVT
LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5od2hhbmRsZXLCoCDCoCDCoD0gREVGQVVM
VF9IV0hBTkRMRVIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAg
wqAgPSBHUk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxi
YWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAu
cnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCkBAIC04MjcsMjAgKzczOCwx
NiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKg
IMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAm
cXVvdDtTR0kmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDC
oCDCoCDCoD0gJnF1b3Q7VFA5WzEzXTAwJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJFUyw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9IERFRkFVTFRfSFdIQU5ETEVSLDxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IEZBSUxCQUNLX1VO
REVGLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ycl93ZWlnaHTCoCDCoCDCoD0gUlJf
V0VJR0hUX05PTkUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLm5vX3BhdGhfcmV0cnkg
PSBOT19QQVRIX1JFVFJZX1VOREVGLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcmlv
X25hbWXCoCDCoCDCoD0gREVGQVVMVF9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC5wcmlvX2FyZ3PCoCDCoCDCoD0gTlVMTCw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKg
IMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAg
PSAmcXVvdDtTR0kmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TC
oCDCoCDCoCDCoD0gJnF1b3Q7VFA5WzQ1XTAwJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5ibF9wcm9kdWN0wqAgwqAgPSAmcXVvdDtVbml2ZXJzYWwgWHBvcnQmcXVvdDssPGJy
Pg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAgPSBERUZBVUxUX0ZF
QVRVUkVTLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5od2hhbmRsZXLCoCDCoCDCoD0g
JnF1b3Q7MSByZGFjJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGlj
ecKgIMKgIMKgID0gR1JPVVBfQllfUFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAu
cGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lNTUVESUFURSw8YnI+DQpAQCAtODcxLDcgKzc3
OCw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLyogTS1TZXJpZXMgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtORUMmcXVvdDssPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7RElTSyBBUlJBWSZxdW90
Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFV
TFRfRkVBVFVSRVMsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmh3aGFuZGxlcsKgIMKg
IMKgPSAmcXVvdDsxIGFsdWEmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBn
cG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCkBAIC04ODcs
NyArNzkzLDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtTVEsmcXVv
dDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1
b3Q7T1BFTnN0b3JhZ2UgRDI4MCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAu
YmxfcHJvZHVjdMKgIMKgID0gJnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJFUyw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEg
cmRhYyZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDC
oCA9IEdST1VQX0JZX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJh
Y2vCoCDCoCA9IC1GQUlMQkFDS19JTU1FRElBVEUsPGJyPg0KQEAgLTkwMywyMCArODA4LDE2IEBA
IHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAg
ezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90
O1NVTiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKg
IMKgPSAmcXVvdDsoU3RvckVkZ2UgMzUxMHxUNCkmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAgPSBERUZBVUxUX0ZFQVRVUkVTLDxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoC5od2hhbmRsZXLCoCDCoCDCoD0gREVGQVVMVF9IV0hBTkRMRVIs
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJV
Uyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJB
Q0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnJyX3dlaWdodMKgIMKgIMKg
PSBSUl9XRUlHSFRfTk9ORSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9y
ZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
LnByaW9fbmFtZcKgIMKgIMKgPSBERUZBVUxUX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLnByaW9fYXJnc8KgIMKgIMKgPSBOVUxMLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0K
wqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDC
oCDCoCA9ICZxdW90O1NVTiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJv
ZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtTVEs2NTgwXzY3ODAmcXVvdDssPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90O1VuaXZlcnNhbCBYcG9ydCZx
dW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9IERF
RkFVTFRfRkVBVFVSRVMsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmh3aGFuZGxlcsKg
IMKgIMKgPSAmcXVvdDsxIHJkYWMmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LnBncG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCkBAIC05
MjksMTMgKzgzMCwxMCBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxi
cj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAg
wqAgwqAgwqAgPSAmcXVvdDtFVVJPTE9HQyZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtGQzI1MDImcXVvdDssPGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAgPSBERUZBVUxUX0ZFQVRVUkVTLDxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5od2hhbmRsZXLCoCDCoCDCoD0gREVGQVVMVF9I
V0hBTkRMRVIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAg
PSBHUk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNr
wqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJf
d2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9VTkRFRiw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IERFRkFVTFRfUFJJTyw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19hcmdzwqAgwqAgwqA9IE5VTEwsPGJyPg0KwqAgwqAg
wqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCAvKjxicj4NCkBAIC05NDgsMjAgKzg0NiwxNyBAQCBz
dGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O1BJVk9UMyZxdW90Oyw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtSQUlHRSBW
T0xVTUUmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmZlYXR1cmVzwqAgwqAg
wqAgPSAmcXVvdDsxIHF1ZXVlX2lmX25vX3BhdGgmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSBERUZBVUxUX0hXSEFORExFUiw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdI
VF9OT05FLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gTk9f
UEFUSF9SRVRSWV9VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubWluaW/CoCDC
oCDCoCDCoCDCoD0gMTAwLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcmlvX25hbWXC
oCDCoCDCoD0gREVGQVVMVF9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlv
X2FyZ3PCoCDCoCDCoD0gTlVMTCw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKg
IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVv
dDtTVU4mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDC
oCDCoD0gJnF1b3Q7Q1NNMjAwX1ImcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90O1VuaXZlcnNhbCBYcG9ydCZxdW90Oyw8YnI+DQotwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFVTFRfRkVBVFVSRVMs
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmh3aGFuZGxlcsKgIMKgIMKgPSAmcXVvdDsx
IHJkYWMmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAg
wqAgPSBHUk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxi
YWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCkBAIC05NzYsNyArODcxLDYgQEAg
c3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtTVU4mcXVvdDssPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7TENTTTEwMF9b
SUVGU10mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmJsX3Byb2R1Y3TCoCDC
oCA9ICZxdW90O1VuaXZlcnNhbCBYcG9ydCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFVTFRfRkVBVFVSRVMsPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLmh3aGFuZGxlcsKgIMKgIMKgPSAmcXVvdDsxIHJkYWMmcXVvdDssPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9Q
UklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSAtRkFJ
TEJBQ0tfSU1NRURJQVRFLDxicj4NCkBAIC05OTEsMTQgKzg4NSwxMSBAQCBzdGF0aWMgc3RydWN0
IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52
ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O1NVTiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtTVU5fNjE4MCZxdW90Oyw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuYmxfcHJvZHVjdMKgIMKgID0gJnF1b3Q7VW5pdmVyc2Fs
IFhwb3J0JnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKg
IMKgID0gREVGQVVMVF9GRUFUVVJFUyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuaHdo
YW5kbGVywqAgwqAgwqA9ICZxdW90OzEgcmRhYyZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1BSSU8sPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IC1GQUlMQkFDS19JTU1FRElBVEUsPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnJyX3dlaWdodMKgIMKgIMKgPSBSUl9XRUlHSFRf
Tk9ORSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IE5PX1BB
VEhfUkVUUllfUVVFVUUsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLm1pbmlvwqAgwqAg
wqAgwqAgwqA9IERFRkFVTFRfTUlOSU8sPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLm1p
bmlvX3JxwqAgwqAgwqAgPSBERUZBVUxUX01JTklPX1JRLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5jaGVja2VyX25hbWXCoCA9IFJEQUMsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnByaW9fbmFtZcKgIMKgIMKgPSBQUklPX1JEQUMsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+
DQpAQCAtMTAyNyw3ICs5MTgsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1td
ID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZx
dW90O1NUSyZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKg
IMKgIMKgPSAmcXVvdDtGTEVYTElORSAzODAmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90O1VuaXZlcnNhbCBYcG9ydCZxdW90Oyw8YnI+
DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9IERFRkFVTFRfRkVB
VFVSRVMsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmh3aGFuZGxlcsKgIMKgIMKgPSAm
cXVvdDsxIHJkYWMmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5
wqAgwqAgwqAgPSBHUk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5w
Z2ZhaWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCkBAIC0xMDQwLDcgKzkz
MCw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAg
wqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9
ICZxdW90O0ludGVsJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0
wqAgwqAgwqAgwqA9ICZxdW90O011bHRpLUZsZXgmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAgPSBERUZBVUxUX0ZFQVRVUkVTLDxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC5od2hhbmRsZXLCoCDCoCDCoD0gJnF1b3Q7MSBhbHVhJnF1b3Q7
LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gR1JPVVBf
QllfUFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0g
LUZBSUxCQUNLX0lNTUVESUFURSw8YnI+DQpAQCAtMTA1Miw3ICs5NDEsNiBAQCBzdGF0aWMgc3Ry
dWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDsoTElPLU9SR3xT
VVNFKSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKg
IMKgPSAmcXVvdDtSQkQmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZlYXR1
cmVzwqAgwqAgwqAgPSBERUZBVUxUX0ZFQVRVUkVTLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5od2hhbmRsZXLCoCDCoCDCoD0gJnF1b3Q7MSBhbHVhJnF1b3Q7LDxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gR1JPVVBfQllfUFJJTyw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lNTUVE
SUFURSw8YnI+DQpAQCAtMTA2NSw4ICs5NTMsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVm
YXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtEYXRhQ29yZSZxdW90Oyw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtTQU5tZWxvZHkm
cXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAgPSBE
RUZBVUxUX0ZFQVRVUkVTLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5od2hhbmRsZXLC
oCDCoCDCoD0gREVGQVVMVF9IV0hBTkRMRVIsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LnBncG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC5ycl93ZWlnaHTCoCDCoCDCoD0gUlJfV0VJR0hUX05PTkUsPGJy
Pg0KQEAgLTEwNzcsOCArOTYzLDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdb
XSA9IHs8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZl
bmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7RGF0YUNvcmUmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7VmlydHVhbCBEaXNrJnF1b3Q7
LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVM
VF9GRUFUVVJFUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAg
wqA9IERFRkFVTFRfSFdIQU5ETEVSLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3Bv
bGljecKgIMKgIMKgID0gR1JPVVBfQllfUFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAucGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lNTUVESUFURSw8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCkBA
IC0xMDg5LDEzICs5NzMsMTAgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9
IHs8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRv
csKgIMKgIMKgIMKgID0gJnF1b3Q7UFVSRSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtGbGFzaEFycmF5JnF1b3Q7LDxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mZWF0dXJlc8KgIMKgIMKgID0gREVGQVVMVF9GRUFUVVJF
Uyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9IERFRkFV
TFRfSFdIQU5ETEVSLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5zZWxlY3RvcsKgIMKg
IMKgID0gJnF1b3Q7cXVldWUtbGVuZ3RoIDAmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lNTUVESUFURSw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAuZmFzdF9pb19mYWlswqAgPSAxMCw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IERFRkFVTFRfUFJJTyw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IDAsPGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLmRldl9sb3NzwqAgwqAgwqAgPSA2MCw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucHJpb19hcmdzwqAgwqAgwqA9IE5VTEwsPGJyPg0KQEAgLTExMDMsOCArOTg0LDYg
QEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDC
oCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1
b3Q7SFVBV0VJJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAg
wqAgwqAgwqA9ICZxdW90O1hTRzEmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
LmZlYXR1cmVzwqAgwqAgwqAgPSBERUZBVUxUX0ZFQVRVUkVTLDxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC5od2hhbmRsZXLCoCDCoCDCoD0gREVGQVVMVF9IV0hBTkRMRVIsPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lNTUVE
SUFURSw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCkBAIC0xMTMyLDcgKzEwMTEsNiBAQCBzdGF0
aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19BTFVBLDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gR1JPVVBfQllfUFJJTyw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAuc2VsZWN0b3LCoCDCoCDCoCA9ICZxdW90O3JvdW5kLXJvYmluIDAm
cXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAgPSBE
RUZBVUxUX0ZFQVRVUkVTLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNr
wqAgwqAgPSAzMCw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucnJfd2VpZ2h0wqAgwqAg
wqA9IFJSX1dFSUdIVF9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRo
X3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9GQUlMLDxicj4NCjxzcGFuIGNsYXNzPSJIT0VuWmIiPjxm
b250IGNvbG9yPSIjODg4ODg4Ij4tLTxicj4NCjIuNy40PGJyPg0KPGJyPg0KPC9mb250Pjwvc3Bh
bj48L2Jsb2NrcXVvdGU+PC9kaXY+PGJyPjwvZGl2Pg0K
--001a1142b9986d4021053836398c--


--===============2615049453737133511==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2615049453737133511==--
