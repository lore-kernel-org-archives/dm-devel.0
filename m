From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] Re: your dm patch for strace
Date: Mon, 12 Sep 2016 20:10:29 +0300
Message-ID: <20160912171029.GA5263@altlinux.org>
References: <alpine.LRH.2.02.1608221155410.17400@file01.intranet.prod.int.rdu2.redhat.com>
	<20160822170920.GA5147@altlinux.org>
	<alpine.LRH.2.02.1608231303510.7049@file01.intranet.prod.int.rdu2.redhat.com>
	<20160824.233543.198328104871315294.yamato@redhat.com>
	<alpine.LRH.2.02.1608250823130.24332@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1518321700850782350=="
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <alpine.LRH.2.02.1608250823130.24332-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: dm-devel.ids


--===============1518321700850782350==
Content-Type: multipart/signed; micalg=x-unknown;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 25, 2016 at 08:27:21AM -0400, Mikulas Patocka wrote:
> On Wed, 24 Aug 2016, Masatake YAMATO wrote:
>=20
> > >> Are you talking about https://sourceforge.net/p/strace/mailman/messa=
ge/34370586/ ?
> > >=20
> > > Yes.
> > >=20
> > >> The thread has apparently died without any follow-up from your side.
> > >=20
> > > I didn't receive that last message, it was probably sent only to the=
=20
> > > mailing list address, not to my address.
> >=20
> > Can I expect you will submit updated version of the patch?
> >=20
> > Masatake YAMATO
>=20
> Here I'm sending the updated device mapper strace patch with the comments=
=20
> addressed. (please send replies to my email address, I'm not on the strac=
e=20
> mailing list)
>=20
> Mikulas
>=20
> Index: strace/configure.ac
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- strace.orig/configure.ac
> +++ strace/configure.ac
> @@ -363,6 +363,7 @@ AC_CHECK_HEADERS(m4_normalize([
>  	elf.h
>  	inttypes.h
>  	linux/bsg.h
> +	linux/dm-ioctl.h
>  	linux/falloc.h
>  	linux/fiemap.h
>  	linux/filter.h
> Index: strace/dm.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ strace/dm.c
> @@ -0,0 +1,351 @@
> +#include "defs.h"
> +
> +#ifdef HAVE_LINUX_DM_IOCTL_H
> +
> +#include <sys/ioctl.h>
> +#include <linux/dm-ioctl.h>
> +
> +static void
> +dm_decode_device(const unsigned int code, const struct dm_ioctl *ioc)
> +{
> +	switch (code) {
> +	case DM_REMOVE_ALL:
> +	case DM_LIST_DEVICES:
> +	case DM_LIST_VERSIONS:
> +		break;
> +	default:
> +		if (ioc->dev)
> +			tprintf(", dev=3Dmakedev(%u, %u)",
> +				major(ioc->dev), minor(ioc->dev));
> +		if (ioc->name[0]) {
> +			tprints(", name=3D");
> +			print_quoted_string(ioc->name, DM_NAME_LEN,
> +					    QUOTE_0_TERMINATED);
> +		}
> +		if (ioc->uuid[0]) {
> +			tprints(", uuid=3D");
> +			print_quoted_string(ioc->uuid, DM_UUID_LEN,
> +					    QUOTE_0_TERMINATED);
> +		}
> +		break;
> +	}
> +}
> +
> +static void
> +dm_decode_values(struct tcb *tcp, const unsigned int code,
> +		 const struct dm_ioctl *ioc)
> +{
> +	if (entering(tcp)) {
> +		switch (code) {
> +		case DM_TABLE_LOAD:
> +			tprintf(", target_count=3D%"PRIu32"",
> +				ioc->target_count);
> +			break;
> +		case DM_DEV_SUSPEND:
> +			if (ioc->flags & DM_SUSPEND_FLAG)
> +				break;
> +		case DM_DEV_RENAME:
> +		case DM_DEV_REMOVE:
> +		case DM_DEV_WAIT:
> +			tprintf(", event_nr=3D%"PRIu32"",
> +				ioc->event_nr);
> +			break;
> +		}
> +	} else if (!syserror(tcp)) {
> +		switch (code) {
> +		case DM_DEV_CREATE:
> +		case DM_DEV_RENAME:
> +		case DM_DEV_SUSPEND:
> +		case DM_DEV_STATUS:
> +		case DM_DEV_WAIT:
> +		case DM_TABLE_LOAD:
> +		case DM_TABLE_CLEAR:
> +		case DM_TABLE_DEPS:
> +		case DM_TABLE_STATUS:
> +		case DM_TARGET_MSG:
> +			tprintf(", target_count=3D%"PRIu32"",
> +				ioc->target_count);
> +			tprintf(", open_count=3D%"PRIu32"",
> +				ioc->open_count);
> +			tprintf(", event_nr=3D%"PRIu32"",
> +				ioc->event_nr);
> +			break;
> +		}
> +	}
> +}
> +
> +#include "xlat/dm_flags.h"
> +
> +static void
> +dm_decode_flags(const struct dm_ioctl *ioc)
> +{
> +	tprints(", flags=3D");
> +	printflags(dm_flags, ioc->flags, "DM_???");
> +}
> +
> +static void
> +dm_decode_dm_target_spec(struct tcb *tcp, const struct dm_ioctl *ioc,
> +			 const char *extra, uint32_t extra_size)
> +{
> +	uint32_t i;
> +	uint32_t offset =3D ioc->data_start;
> +	for (i =3D 0; i < ioc->target_count; i++) {
> +		if (offset + (uint32_t)sizeof(struct dm_target_spec) >=3D offset &&
> +		    offset + (uint32_t)sizeof(struct dm_target_spec) < extra_size) {
> +			const struct dm_target_spec *s =3D
> +				(const struct dm_target_spec *)(extra + offset);
> +			tprintf(", {sector_start=3D%"PRIu64", length=3D%"PRIu64"",
> +				(uint64_t)s->sector_start, (uint64_t)s->length);
> +			if (!entering(tcp))
> +				tprintf(", status=3D%"PRId32"", s->status);
> +			tprints(", target_type=3D");
> +			print_quoted_string(s->target_type, DM_MAX_TYPE_NAME,
> +					    QUOTE_0_TERMINATED);
> +			tprints(", string=3D");
> +			print_quoted_string((const char *)(s + 1), extra_size -
> +					    (offset +
> +					    sizeof(struct dm_target_spec)),
> +					    QUOTE_0_TERMINATED);
> +			tprintf("}");
> +			if (entering(tcp))
> +				offset =3D offset + s->next;
> +			else
> +				offset =3D ioc->data_start + s->next;

This code trusts s->next; unfortunately, strace cannot trust syscall
arguments, otherwise anything may happen, e.g.

$ cat ioctl_dm.c
#include <sys/ioctl.h>
#include <linux/dm-ioctl.h>
int main(void)
{
	struct {
		struct dm_ioctl ioc;
		struct dm_target_spec spec;
		int i;
	} s =3D {
		.spec =3D { 0 },
		.ioc =3D {
			.version[0] =3D DM_VERSION_MAJOR,
			.data_size =3D sizeof(s),
			.data_start =3D sizeof(s.ioc),
			.target_count =3D -1U
		}
	};
	return !ioctl(-1, DM_TABLE_LOAD, &s);
}
$ strace -veioctl ./ioctl_dm

btw, this parser lacks tests.  How one can easily verify that it works
correctly?  For example how a test for strace ioctl parser may look like
see tests/ioctl_* files.


--=20
ldv

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJX1uGFAAoJEAVFT+BVnCUIJkcP/2gQM6PvMN59Lg84s4ZpMX92
5FtofbxdAWHGztpirbREssnasf5ZCN66HkMM1m0+sljlGVMGI644Ip79uma6cqWQ
C7c08pw01SOhuF7ljX9XT1/KR1/fOlnd+arkPBFWdKhgbFNb2+3bRUiqCU3Qp626
3clTcfYfmU2Y0w6NDwT+K8hRBFq/WUyMr0kF34wvrkdcY54Jp23mf6/v2IIEhR8Z
Lr9scklU3tq9Su8gxfM0vBhtqxWAjk0u+Qt9efX7kVlO1xygTJBTiKw9OpDpiR7M
nRnC9MqY1trV4Rahhw+JHy/6LMyldDw8SYoCp1pF3gjz9socE4sCIdlWQwuQbBVv
sTDMk+FbtkDOBTV9bh2z9BK2yAuzclOoZMsSctxNwjGWPltrUw5qCs8EnjLhNxHm
SM61CNjMp40Xm0PHPjJP2umnqz5abYfYY6XjXouzt5sJQEHSsg4pSo5LaBQ/mnlc
tVBx8/DyId/R3LLx8W9L1dSavITF66RfvHizVdav7X9q/kKOO1SVLDVL52i6jrnR
LxjJOi2/5rdVHN1gYnpawGxh6UxigQKEq4uF1SvWXokjcVbJ9dJ6PAtudeduA5Iu
EKUs+l77WuCyDKE5lPiTXxq8sxOlZBICalQHCyei01XSbxQh553XH4McRoPgFmSx
5Mn3541ONXRTpAd7Xko9
=+MEp
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--


--===============1518321700850782350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
--===============1518321700850782350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Strace-devel mailing list
Strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/strace-devel

--===============1518321700850782350==--
