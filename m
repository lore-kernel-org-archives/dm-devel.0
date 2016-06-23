From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] multipath-tools: replace TUR with
 DEFAULT_CHECKER in hwtable
Date: Thu, 23 Jun 2016 15:49:02 +0200
Message-ID: <576BE8CE.9040201@suse.de>
References: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
	<1466689340-5590-4-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466689340-5590-4-git-send-email-xose.vazquez@gmail.com>
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
Cc: Matthias Rudolph <matthias.rudolph@hds.com>, Yacine Kheddache <yacine@alyseo.com>, device-mapper development <dm-devel@redhat.com>, "Brian King,
	IBM" <brking@linux.vnet.ibm.com>, Srinivasan Ramani <srinivas.ramani@oracle.com>, Sean Stewart <sean.stewart@netapp.com>, Shyam Sundar <g.shyamsundar@yahoo.co.in>, "Bart Brooks,
	Pivot3" <bartb@pivot3.com>, "Edward Goggin, EMC" <egoggin@emc.com>
List-Id: dm-devel.ids

On 06/23/2016 03:42 PM, Xose Vazquez Perez wrote:
> DEFAULT_CHECKER already is TUR
> =

> Cc: Shyam Sundar <g.shyamsundar@yahoo.co.in>
> Cc: Edward Goggin, EMC <egoggin@emc.com>
> Cc: Matthias Rudolph <matthias.rudolph@hds.com>
> Cc: Brian King, IBM <brking@linux.vnet.ibm.com>
> Cc: Yacine Kheddache <yacine@alyseo.com>
> Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>
> Cc: Bart Brooks, Pivot3 <bartb@pivot3.com>
> Cc: Martin George <marting@netapp.com>
> Cc: Sean Stewart <sean.stewart@netapp.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 78 +++++++++++++++++++++++++-------------------=
------
>  1 file changed, 39 insertions(+), 39 deletions(-)
> =

> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index fb334ab..6e73e67 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -34,7 +34,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_QUEUE,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -125,7 +125,7 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 12,
>  		.minio         =3D 100,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -140,7 +140,7 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 12,
>  		.minio         =3D 100,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -155,7 +155,7 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 18,
>  		.minio         =3D 100,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -170,7 +170,7 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 18,
>  		.minio         =3D 100,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -185,7 +185,7 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 18,
>  		.minio         =3D 100,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -200,7 +200,7 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 12,
>  		.minio         =3D 100,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -214,7 +214,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D FAILBACK_UNDEF,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 12,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -229,7 +229,7 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 18,
>  		.minio         =3D 100,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -264,7 +264,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D FAILBACK_UNDEF,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 6,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -295,7 +295,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D FAILBACK_UNDEF,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 5,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -307,7 +307,7 @@ static struct hwentry default_hw[] =3D {
>  		.selector      =3D "queue-length 0",
>  		.pgpolicy      =3D MULTIBUS,
>  		.pgfailback    =3D FAILBACK_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.fast_io_fail  =3D 5,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
> @@ -337,7 +337,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 10,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -356,7 +356,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D FAILBACK_UNDEF,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -369,7 +369,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_HDS,
>  		.prio_args     =3D NULL,
>  	},
> @@ -536,7 +536,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D FAILBACK_UNDEF,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -550,7 +550,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D FAILBACK_UNDEF,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -564,7 +564,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D FAILBACK_UNDEF,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -578,7 +578,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -592,7 +592,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D FAILBACK_UNDEF,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -606,7 +606,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -652,7 +652,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -667,7 +667,7 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_QUEUE,
>  		.minio         =3D 100,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -682,7 +682,7 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D 15,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -716,7 +716,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D (300 / DEFAULT_CHECKINT),
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -730,7 +730,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D (300 / DEFAULT_CHECKINT),
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -797,7 +797,7 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D 128,
>  		.dev_loss      =3D MAX_DEV_LOSS_TMO,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ONTAP,
>  		.prio_args     =3D NULL,
>  		.retain_hwhandler =3D RETAIN_HWHANDLER_ON,
> @@ -855,7 +855,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D FAILBACK_UNDEF,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -916,7 +916,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -996,7 +996,7 @@ static struct hwentry default_hw[] =3D {
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>  		.minio         =3D 100,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.prio_args     =3D NULL,
>  	},
> @@ -1089,7 +1089,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_QUEUE,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -1102,7 +1102,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D 12,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.minio         =3D 100,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
> @@ -1116,7 +1116,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_QUEUE,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -1129,7 +1129,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_QUEUE,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> @@ -1141,7 +1141,7 @@ static struct hwentry default_hw[] =3D {
>  		.selector      =3D "queue-length 0",
>  		.pgpolicy      =3D MULTIBUS,
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.fast_io_fail  =3D 10,
>  		.prio_name     =3D DEFAULT_PRIO,
>  		.no_path_retry =3D 0,
> @@ -1155,7 +1155,7 @@ static struct hwentry default_hw[] =3D {
>  		.hwhandler     =3D DEFAULT_HWHANDLER,
>  		.pgpolicy      =3D MULTIBUS,
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  	},
>  	/*
>  	 * Violin Memory
> @@ -1166,7 +1166,7 @@ static struct hwentry default_hw[] =3D {
>  		.selector      =3D "round-robin 0",
>  		.pgpolicy      =3D MULTIBUS,
>  		.prio_name     =3D PRIO_ALUA,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.minio         =3D 100,
>  		.rr_weight     =3D RR_WEIGHT_PRIO,
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
> @@ -1181,7 +1181,7 @@ static struct hwentry default_hw[] =3D {
>  		.product       =3D "InfiniBox.*",
>  		.prio_name     =3D PRIO_ALUA,
>  		.pgpolicy      =3D GROUP_BY_PRIO,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.selector      =3D "round-robin 0",
>  		.features      =3D DEFAULT_FEATURES,
>  		.pgfailback    =3D 30,
> @@ -1203,7 +1203,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgpolicy      =3D GROUP_BY_PRIO,
>  		.no_path_retry =3D 10,
>  		.dev_loss      =3D 50,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DEFAULT_CHECKER,
>  		.prio_name     =3D PRIO_ALUA,
>  		.pgfailback    =3D 30,
>  		.minio         =3D 128,
> =

Why do you need to set it to 'DEFAULT_CHECKER'?
It's the default, right?
So it should be sufficient to just delete those lines...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
