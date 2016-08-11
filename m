From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/15] multipath-tools: replace queue-length
 by default selector
Date: Thu, 11 Aug 2016 07:58:32 +0200
Message-ID: <411eb480-d21d-051b-1f7b-12631cae1f25@suse.de>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
	<1470846038-6590-14-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470846038-6590-14-git-send-email-xose.vazquez@gmail.com>
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

On 08/10/2016 06:20 PM, Xose Vazquez Perez wrote:
> service-time is more advanced, and it works better in asymmetric and
> asymmetric environments.
> =

> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 2 --
>  1 file changed, 2 deletions(-)
> =

> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index bc2d407..edfd8fe 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -198,7 +198,6 @@ static struct hwentry default_hw[] =3D {
>  	{
>  		.vendor        =3D "XtremIO",
>  		.product       =3D "XtremApp",
> -		.selector      =3D "queue-length 0",
>  		.pgpolicy      =3D MULTIBUS,
>  		.pgfailback    =3D FAILBACK_UNDEF,
>  	},
> @@ -823,7 +822,6 @@ static struct hwentry default_hw[] =3D {
>  	{
>  		.vendor        =3D "PURE",
>  		.product       =3D "FlashArray",
> -		.selector      =3D "queue-length 0",
>  		.pgpolicy      =3D MULTIBUS,
>  		.pgfailback    =3D FAILBACK_UNDEF,
>  		.fast_io_fail  =3D 10,
> =

I would _not_ do this, unless tested on the real hardware.
Just claiming 'the other one is more advanced' is not enough here.

NACK.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
