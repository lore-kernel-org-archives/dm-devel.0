From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] multipath-tools: Change path checker for
 IBM IPR devices
Date: Thu, 25 Sep 2014 08:29:56 +0200
Message-ID: <5423B664.2020007@suse.de>
References: <20140924195721.148637349@linux.vnet.ibm.com>
	<20140924195752.289011902@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140924195752.289011902@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 09/24/2014 09:57 PM, wenxiong@linux.vnet.ibm.com wrote:
> We would like to change path checker to directio for IBM IPR devices.
> =

> Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> ---
>  libmultipath/hwtable.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> =

> Index: b/libmultipath/hwtable.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/libmultipath/hwtable.c	2014-09-23 17:39:27.000000000 -0500
> +++ b/libmultipath/hwtable.c	2014-09-23 17:40:31.419667000 -0500
> @@ -630,7 +630,7 @@ static struct hwentry default_hw[] =3D {
>  		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>  		.rr_weight     =3D RR_WEIGHT_NONE,
>  		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
> -		.checker_name  =3D TUR,
> +		.checker_name  =3D DIRECTIO,
>  		.prio_name     =3D PRIO_ALUA,
>  		.prio_args     =3D NULL,
>  	},
> =

> -- -- dm-devel mailing list dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
Any particular reason for doing so?

Using 'directio' has the drawback that it might stall under higher
load, as it's being added to the _tail_ of the request queue.
TUR is using the 'SG_IO' ioctl, which is added to the head of the
request_queue and hence won't be stalled ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
