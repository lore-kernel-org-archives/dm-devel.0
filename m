From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath-tools: change checker in RDAC
 devices with the native
Date: Tue, 14 Jun 2016 07:58:54 +0200
Message-ID: <575F9D1E.1060301@suse.de>
References: <1465837340-20257-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1465837340-20257-1-git-send-email-xose.vazquez@gmail.com>
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

On 06/13/2016 07:02 PM, Xose Vazquez Perez wrote:
> Replace TUR checker with RDAC for:
> "OPENstorage D280"
> "STK6580_6780"
> =

> I don't know if it's a bug or feature, but for all other RDAC devices
> "hwhandler" "checker" and "prio" are rdac.
> =

> *This patch needs an explicit ACK from Hannes and Christophe*
> =

> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> =

> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index c4258e1..44a4669 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -949,7 +949,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D RDAC,
>  		.prio_name     =3D PRIO_RDAC,
>  		.prio_args     =3D NULL,
>  	},
> @@ -981,7 +981,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D RDAC,
>  		.prio_name     =3D PRIO_RDAC,
>  		.prio_args     =3D NULL,
>  	},
> =

Actually it doesn't matter; 'TUR' will work better under high I/O load,
whereas RDAC has quirks for some array-specific settings.
But for consistencies sake we should be switching to 'RDAC' here, too.

Acked-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
