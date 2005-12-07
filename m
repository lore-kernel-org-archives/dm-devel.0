From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [PATCH] IBM hwtable update
Date: Wed, 7 Dec 2005 12:45:00 +0100
Message-ID: <OF3BAED142.4E324BA7-ONC12570D0.003FCC56-C12570D0.00406650@de.ibm.com>
References: <4396C35B.7030109@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4396C35B.7030109@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Hi Christophe, Hannes,

I thought I had already sent parts of these but they don't seem to be in=20
the git head when
I look now. I'd suggest a small change for the DS6000 aka 1750500. Since=20
paths with
higher prio are more appreciated, wouldn'T FAILBACK_IMMEDIATE make more=20
sense?

Regards,
Stefan

SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
-------------------------------------------------------------------------=
---------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 07.12.2005 12:11:23:

> Hi Christophe,
>=20
> attached is a patch to update hwtable.c with some IBM Storage Servers.
> Especially the DS6000 should be handled properly as it again has
> asymmetric paths.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke         hare@suse.de
> SuSE Linux Products GmbH      S390 & zSeries
> Maxfeldstra=DFe 5            +49 911 74053 688
> 90409 N=FCrnberg            http://www.suse.de
> Subject: Hardware entries for IBM Storage Servers
>=20
> Several IBM Storage Servers (most notably the DS range) need
> specific hardware entries. This patch adds hardware entries
> for:
>=20
> - IBM ESS F20 (aka Shark)
> - IBM DS6000
> - IBM DS8000
> - IBM SVC
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>=20
> ---
>=20
>  libmultipath/hwtable.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -39,6 +39,20 @@ setup_default_hwtable (vector hw)
>           "1 queue_if_no_path", "emc_clariion", -FAILBACK_IMMEDIATE);
>     r +=3D store_hwe_ext(hw, "IBM", "3542", GROUP_BY_SERIAL,=20
DEFAULT_GETUID,
>           NULL, "0", "0", "tur", FAILBACK_UNDEF);
> +   /* IBM ESS F20 aka Shark */
> +   r +=3D store_hwe_ext(hw, "IBM", "2105F20", GROUP_BY_SERIAL,
> +         DEFAULT_GETUID, NULL, "0", "1 queue_if_no_path",
> +         "tur", FAILBACK_UNDEF);
> +       /* IBM DS6000 */
> +   r +=3D store_hwe_ext(hw, "IBM", "1750500", GROUP_BY_PRIO,=20
DEFAULT_GETUID,
> +         "/sbin/mpath_prio_alua /dev/%n", "0", "1 queue_if_no_path",
> +         "tur", FAILBACK_UNDEF);
> +   /* IBM DS8000 */
> +   r +=3D store_hwe_ext(hw, "IBM", "2107900", GROUP_BY_SERIAL,=20
DEFAULT_GETUID,
> +         NULL, "0", "1 queue_if_no_path", "tur", FAILBACK_UNDEF);
> +   /* IBM SAN Volume Controller */
> +   r +=3D store_hwe_ext(hw, "IBM", "2145", MULTIBUS, DEFAULT_GETUID,
> +         NULL, "0", "1 queue_if_no_path", "tur", FAILBACK_UNDEF);
>     r +=3D store_hwe_ext(hw, "NETAPP", "LUN", GROUP_BY_PRIO,=20
DEFAULT_GETUID,
>          "/sbin/mpath_prio_netapp /dev/%n", NULL,
>          "1 queue_if_no_path", "readsector0", FAILBACK_UNDEF);
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
