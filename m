From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath-tools: add VIOLIN arrays to
 hardware table
Date: Sun, 16 Oct 2016 18:56:46 +0200
Message-ID: <8a7363a9-43ad-92ac-c237-c6bbe8bcf5b3@suse.de>
References: <20161015115023.6773-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161015115023.6773-1-xose.vazquez@gmail.com>
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

On 10/15/2016 01:50 PM, Xose Vazquez Perez wrote:
> Based on documentation provided by the manufacturer:
> https://drive.google.com/open?id=3D0B_B6YmEmO7cDQlMzc1BsaUxZRVU
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index aca46ab..e34032d 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -944,6 +944,32 @@ static struct hwentry default_hw[] =3D {
>  		.pgpolicy      =3D MULTIBUS,
>  		.no_path_retry =3D 12,
>  	},
> +	/*
> +	 * Violin Memory
> +	 */
> +	{
> +		/* V3000 / V6000 Series */
> +		.vendor        =3D "VIOLIN",
> +		.product       =3D "SAN ARRAY$",
> +		.pgpolicy      =3D GROUP_BY_SERIAL,
> +		.no_path_retry =3D 30,
> +	},
> +	{
> +		.vendor        =3D "VIOLIN",
> +		.product       =3D "SAN ARRAY ALUA",
> +		.hwhandler     =3D "1 alua",
> +		.pgpolicy      =3D GROUP_BY_PRIO,
> +		.pgfailback    =3D -FAILBACK_IMMEDIATE,
> +		.prio_name     =3D PRIO_ALUA,
> +		.no_path_retry =3D 30,
> +	},
> +	{
> +		/* FSP 7000 family */
> +		.vendor        =3D "VIOLIN",
> +		.product       =3D "CONCERTO ARRAY",
> +		.pgpolicy      =3D MULTIBUS,
> +		.no_path_retry =3D 30,
> +	},
>  #if 0
>  	/*
>  	 * Copy this TEMPLATE to add new hardware.
>
Where's the point of the first and the third entry?
They'll be identical to the default settings, no?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
