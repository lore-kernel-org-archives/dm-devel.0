From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] multipath: change default configuration
 parameters
Date: Fri, 11 Jan 2013 08:00:22 +0100
Message-ID: <50EFB886.7050707@suse.de>
References: <20130110200508.GO19059@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130110200508.GO19059@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 01/10/2013 09:05 PM, Benjamin Marzinski wrote:
> This patch makes multipath devices default to setting fast_io_fail,
> switches the default selector to service-time and removes the
> round-robin setting of the builtin device configurations. The goal is
> to give multipath devices better performance "out of the box".
>
Couldn't you split it off in three patches?
(Bad) experience tells me one always run into problems when
munching together unrelated pieces ...

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>   libmultipath/config.c   |    1
>   libmultipath/defaults.h |    2 -
>   libmultipath/hwtable.c  |   65 ----------------------------------------=
--------
>   3 files changed, 2 insertions(+), 66 deletions(-)
>
> Index: multipath-tools-120821/libmultipath/config.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-120821.orig/libmultipath/config.c
> +++ multipath-tools-120821/libmultipath/config.c
> @@ -516,6 +516,7 @@ load_config (char * file)
>   	conf->reassign_maps =3D DEFAULT_REASSIGN_MAPS;
>   	conf->checkint =3D DEFAULT_CHECKINT;
>   	conf->max_checkint =3D MAX_CHECKINT(conf->checkint);
> +	conf->fast_io_fail =3D 5;
>
>   	/*
>   	 * preload default hwtable

Please use #define DEFAULT_FAST_IO_FAIL here.

> Index: multipath-tools-120821/libmultipath/hwtable.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-120821.orig/libmultipath/hwtable.c
> +++ multipath-tools-120821/libmultipath/hwtable.c
> @@ -28,7 +28,6 @@ static struct hwentry default_hw[] =3D {
>   		.product       =3D "Compellent Vol",
>   		.features      =3D DEFAULT_FEATURES,
>   		.hwhandler     =3D DEFAULT_HWHANDLER,
> -		.selector      =3D DEFAULT_SELECTOR,
>   		.pgpolicy      =3D MULTIBUS,
>   		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>   		.rr_weight     =3D RR_WEIGHT_NONE,

Can't we get rid of _all_ 'DEFAULT_XXX' settings in the
hardware table? They _should_ be set to default during
init anyway, shouldn't they?
And that would shorten the hardware table by quite a lot ...


> Index: multipath-tools-120821/libmultipath/defaults.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-120821.orig/libmultipath/defaults.h
> +++ multipath-tools-120821/libmultipath/defaults.h
> @@ -1,7 +1,7 @@
>   #define DEFAULT_UID_ATTRIBUTE	"ID_SERIAL"
>   #define DEFAULT_UDEVDIR		"/dev"
>   #define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
> -#define DEFAULT_SELECTOR	"round-robin 0"
> +#define DEFAULT_SELECTOR	"service-time 0"
>   #define DEFAULT_ALIAS_PREFIX	"mpath"
>   #define DEFAULT_FEATURES	"0"
>   #define DEFAULT_HWHANDLER	"0"
>
Hmm.

And you _have_ tested 'service-time' thoroughly, now have you?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
