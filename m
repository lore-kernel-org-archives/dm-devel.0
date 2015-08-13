From: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] device mapper support for strace
Date: Thu, 13 Aug 2015 03:05:02 -0400
Message-ID: <20150813070502.GD25069@vapier>
References: <alpine.LRH.2.02.1507311043370.4689@file01.intranet.prod.int.rdu2.redhat.com>
	<20150731153520.GA20404@altlinux.org>
	<alpine.LRH.2.02.1507311202320.29679@file01.intranet.prod.int.rdu2.redhat.com>
	<20150801175400.GA3943@altlinux.org>
	<alpine.LRH.2.02.1508111310290.20408@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3068726598186291966=="
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <alpine.LRH.2.02.1508111310290.20408-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids


--===============3068726598186291966==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Content-Disposition: inline


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11 Aug 2015 13:11, Mikulas Patocka wrote:
> --- /dev/null
> +++ strace/dm.c
> @@ -0,0 +1,354 @@
> +#include "defs.h"

all files should have a comment block at the top.  see mtd.c as an example.

> +{
> +	switch (code) {
> +		case DM_REMOVE_ALL:

case statements should be at the same indent level as the switch.  see mtd.=
c.

> +	size_t offset =3D ioc->data_start;

data_start is a __u32, so this should be uint32_t instead of size_t

> +			tprintf(", {sector_start=3D%llu, length=3D%llu",
> +				(unsigned long long)s->sector_start,
> +				(unsigned long long)s->length);

sector_start/length are uint64_t, not unsigned long long.  please use PRIu6=
4=20
defines from inttypes.h instead of random casts.  you can find plenty of=20
examples in the tree already.

> +			if (!entering(tcp))
> +				tprintf(", status=3D%d", (int)s->status);

status is int32_t, not int, so please use PRId32 instead of int casts.

> +static void
> +dm_decode_dm_target_deps(const struct dm_ioctl *ioc, const char *extra,
> +			 size_t extra_size)
> +{
> +	size_t offset =3D ioc->data_start;

uint32_t, not size_t

> +	if (offset + offsetof(struct dm_target_deps, dev) >=3D offset &&
> +	    offset + offsetof(struct dm_target_deps, dev) <=3D extra_size) {
> +		uint32_t i;
> +		size_t space =3D (extra_size - (offset +
> +			offsetof(struct dm_target_deps, dev))) / sizeof(__u64);
> +		const struct dm_target_deps *s =3D
> +			(const struct dm_target_deps *)(extra + offset);
> +		if (s->count > space)
> +			goto misplaced;

count is __u32, so space should probably be uint32_t instead of size_t

> +misplaced:

it's not standard in strace, but personal preference is to put a
single space before labels to help out with diff context

> +	size_t offset =3D ioc->data_start;

uint32_t

> +misplaced:

add a space

looks like many of these comments apply to the rest of this file,
so i'll refrain from repeating myself
-mike

--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVzEGeAAoJEEFjO5/oN/WBAsUP+wSxQl/WdIzYfu4AJA8RGRF4
obxP91OKrkflfmb8idA/BKrUMEj8PQEAjOamLNf8Iep9/dYiCg7otGHp2ixMf+ry
XqpUNIkrObHnFhogJUSCVFWKaXOKu0jIInQWp0JBDCuQvltKiohZp+rWt6y4hKuG
HKuj/lV0MP8Defwrv3S0J+SJPE/SGXDnCajaUV4+VN8Qbwq80ob/WH57eV2qJpvB
mKlmUdO/TS/i2UYpunPNzHuzUrAQiXLudJstBVxyIoCZVOvLxMUHb2WcrLdM1FqU
ZCqopuSPuy4DnKW8y+n3+mBorNrxVdfqQLlZ7YxnnMBut2oIZss3ubQGcDoGStxJ
L3l8/+qdV5E/QpCvbzZ8kEBGinagAA9sOo7X3HGeFz5fL+Lx1TJrcPzh//QGlfyp
P06nQLhi3ZVWEObeGxOUzijalO8w55L9WXhy5rNMCSNhzMNeMaGj/fmqpH6f56Yv
cHvAeMYpA3xFM4c+pE+NkB8cx4AN7q5ZA1FnPJbTB/USHwMa2N1knBgpQymczREl
EcnRDx5DgkAyGJE64qrKUWX9BmLVt3ctkQQ+e1/bL+3G9yyv3mOw8iX+fYfHGxWF
7SFvVxGFX5vj8FCd+P+ymD6g+auk1HXOjaQZL4TJYosnKuhZb69NUYGPbL2JnxeL
9eUEdnrBABh8hzTIUwit
=JSVB
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--


--===============3068726598186291966==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============3068726598186291966==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Strace-devel mailing list
Strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/strace-devel

--===============3068726598186291966==--
