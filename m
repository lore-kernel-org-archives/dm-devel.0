From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] device mapper support for strace
Date: Sat, 1 Aug 2015 20:54:00 +0300
Message-ID: <20150801175400.GA3943@altlinux.org>
References: <alpine.LRH.2.02.1507311043370.4689@file01.intranet.prod.int.rdu2.redhat.com>
	<20150731153520.GA20404@altlinux.org>
	<alpine.LRH.2.02.1507311202320.29679@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7988892270514070056=="
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <alpine.LRH.2.02.1507311202320.29679-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
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


--===============7988892270514070056==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2015 at 12:04:48PM -0400, Mikulas Patocka wrote:
> On Fri, 31 Jul 2015, Dmitry V. Levin wrote:
> > On Fri, Jul 31, 2015 at 10:49:44AM -0400, Mikulas Patocka wrote:
> > > Hi
> > >=20
> > > Here I'm sending a patch that makes it possible to decode device mapp=
er=20
> > > ioctls in strace.
> > >=20
> > > How to apply the patch:
> > >=20
> > > Download strace 4.10 from=20
> > > http://downloads.sourceforge.net/project/strace/strace/4.10/strace-4.=
10.tar.xz
> >=20
> > Please rebase onto strace.git HEAD (v4.10-277-gd9fb450 at this moment).
> > Use ./bootstrap to regenerate dev files.
>=20
> This is the updated patch for strace.git.

Thanks.

Unfortunately, this one doesn't apply at all, you must be using a quite
outdated strace.git repository.

The up to date strace.git is located at git://git.code.sf.net/p/strace/code=
=2Egit,
and when it is not available because of sf.net issues (which are quite
often nowadays), one can use mirrors at https://github.com/ldv-alt/strace.g=
it
and git://git.altlinux.org/people/ldv/public/strace.git

Just a few comments after very cursory look at your patch:

> --- /dev/null
> +++ strace/dm.c
> @@ -0,0 +1,335 @@
> +#include "defs.h"
> +
> +#ifdef HAVE_LINUX_DM_IOCTL_H
> +
> +#include <sys/ioctl.h>

Please include <linux/ioctl.h> instead.

> +#include <linux/dm-ioctl.h>
> +
> +static void
> +dm_decode_device(const unsigned int code, const struct dm_ioctl *ioc)
> +{
> +	if (code !=3D DM_REMOVE_ALL &&
> +	    code !=3D DM_LIST_DEVICES &&
> +	    code !=3D DM_LIST_VERSIONS) {

Please use switch statement instead.

> +		if (ioc->dev)
> +			tprintf(", dev=3Dmakedev(%u, %u)", major(ioc->dev), minor(ioc->dev));
> +		if (ioc->name[0]) {
> +			tprints(", name=3D");
> +			print_quoted_string(ioc->name, DM_NAME_LEN, QUOTE_0_TERMINATED);
> +		}
> +		if (ioc->uuid[0]) {
> +			tprints(", uuid=3D");
> +			print_quoted_string(ioc->uuid, DM_UUID_LEN, QUOTE_0_TERMINATED);
> +		}
> +	}
> +}
> +
> +static void
> +dm_decode_values(struct tcb *tcp, const unsigned int code, const struct =
dm_ioctl *ioc)
> +{
> +	if (entering(tcp)) {
> +		if (code =3D=3D DM_TABLE_LOAD)
> +			tprintf(", target_count=3D%u", (unsigned)ioc->target_count);
> +		if (code =3D=3D DM_DEV_RENAME ||
> +		    code =3D=3D DM_DEV_REMOVE ||
> +		    (code =3D=3D DM_DEV_SUSPEND && !(ioc->flags & DM_SUSPEND_FLAG)) ||
> +		    code =3D=3D DM_DEV_WAIT)

Please use switch statement instead.

> +			tprintf(", event_nr=3D%u", (unsigned)ioc->event_nr);
> +	} else if (!tcp->u_error) {

Please use !syserror(tcp) instead.

> +		if (code =3D=3D DM_DEV_CREATE ||
> +		    code =3D=3D DM_DEV_RENAME ||
> +		    code =3D=3D DM_DEV_SUSPEND ||
> +		    code =3D=3D DM_DEV_STATUS ||
> +		    code =3D=3D DM_DEV_WAIT ||
> +		    code =3D=3D DM_TABLE_LOAD ||
> +		    code =3D=3D DM_TABLE_CLEAR ||
> +		    code =3D=3D DM_TABLE_DEPS ||
> +		    code =3D=3D DM_TABLE_STATUS ||
> +		    code =3D=3D DM_TARGET_MSG) {

Please use switch statement instead.

> +			tprintf(", target_count=3D%u", (unsigned)ioc->target_count);
> +			tprintf(", open_count=3D%u", (unsigned)ioc->open_count);
> +			tprintf(", event_nr=3D%u", (unsigned)ioc->event_nr);
> +		}
> +	}
> +}
> +
> +static void
> +dm_decode_flags(const struct dm_ioctl *ioc)
> +{
> +	if (ioc->flags) {
> +		static const struct {
> +			uint32_t flag;
> +			const char *string;
> +		} dm_flags[] =3D {
> +			{ DM_READONLY_FLAG, "DM_READONLY_FLAG" },
> +			{ DM_SUSPEND_FLAG, "DM_SUSPEND_FLAG" },
> +			{ DM_PERSISTENT_DEV_FLAG, "DM_PERSISTENT_DEV_FLAG" },
> +			{ DM_STATUS_TABLE_FLAG, "DM_STATUS_TABLE_FLAG" },
> +			{ DM_ACTIVE_PRESENT_FLAG, "DM_ACTIVE_PRESENT_FLAG" },
> +			{ DM_INACTIVE_PRESENT_FLAG, "DM_INACTIVE_PRESENT_FLAG" },
> +			{ DM_BUFFER_FULL_FLAG, "DM_BUFFER_FULL_FLAG" },
> +			{ DM_SKIP_BDGET_FLAG, "DM_SKIP_BDGET_FLAG" },
> +#ifdef DM_SKIP_LOCKFS_FLAG
> +			{ DM_SKIP_LOCKFS_FLAG, "DM_SKIP_LOCKFS_FLAG" },
> +#endif
> +#ifdef DM_NOFLUSH_FLAG
> +			{ DM_NOFLUSH_FLAG, "DM_NOFLUSH_FLAG" },
> +#endif
> +#ifdef DM_QUERY_INACTIVE_TABLE_FLAG
> +			{ DM_QUERY_INACTIVE_TABLE_FLAG, "DM_QUERY_INACTIVE_TABLE_FLAG" },
> +#endif
> +#ifdef DM_UEVENT_GENERATED_FLAG
> +			{ DM_UEVENT_GENERATED_FLAG, "DM_UEVENT_GENERATED_FLAG" },
> +#endif
> +#ifdef DM_UUID_FLAG
> +			{ DM_UUID_FLAG, "DM_UUID_FLAG" },
> +#endif
> +#ifdef DM_SECURE_DATA_FLAG
> +			{ DM_SECURE_DATA_FLAG, "DM_SECURE_DATA_FLAG" },
> +#endif
> +#ifdef DM_DATA_OUT_FLAG
> +			{ DM_DATA_OUT_FLAG, "DM_DATA_OUT_FLAG" },
> +#endif
> +#ifdef DM_DEFERRED_REMOVE
> +			{ DM_DEFERRED_REMOVE, "DM_DEFERRED_REMOVE" },
> +#endif
> +#ifdef DM_INTERNAL_SUSPEND_FLAG
> +			{ DM_INTERNAL_SUSPEND_FLAG, "DM_INTERNAL_SUSPEND_FLAG" },
> +#endif
> +		};

Please create an xlat file instead.
See e.g. xlat/evdev_*.in files.

> +		uint32_t flags =3D ioc->flags;
> +		bool first =3D true;
> +		unsigned i;
> +		tprints(", flags=3D");
> +		for (i =3D 0; i < sizeof(dm_flags) / sizeof(*dm_flags); i++) {
> +			if (flags & dm_flags[i].flag) {
> +				if (!first)
> +					tprints("|");
> +				else
> +					first =3D false;
> +				tprints(dm_flags[i].string);
> +				flags &=3D ~dm_flags[i].flag;
> +			}
> +		}
> +		if (flags) {
> +			if (!first)
> +				tprints("|");
> +			else
> +				first =3D false;
> +			tprintf("0x%x", (unsigned)flags);
> +		}

Please use printflags instead.

> +
> +	}
> +}
> +
> +static void
> +dm_decode_dm_target_spec(struct tcb *tcp, const struct dm_ioctl *ioc, co=
nst char *extra, size_t extra_size)
> +{
> +	uint32_t i;
> +	size_t offset =3D ioc->data_start;
> +	for (i =3D 0; i < ioc->target_count; i++) {
> +		if (offset + sizeof(struct dm_target_spec) >=3D offset &&
> +		    offset + sizeof(struct dm_target_spec) < extra_size) {
> +			const struct dm_target_spec *s =3D (const struct dm_target_spec *)(ex=
tra + offset);
> +			tprintf(", {sector_start=3D%llu, length=3D%llu", (unsigned long long)=
s->sector_start, (unsigned long long)s->length);
> +			if (!entering(tcp))
> +				tprintf(", status=3D%d", (int)s->status);
> +			tprints(", target_type=3D");
> +			print_quoted_string(s->target_type, DM_MAX_TYPE_NAME, QUOTE_0_TERMINA=
TED);
> +			tprints(", string=3D");
> +			print_quoted_string((const char *)(s + 1), extra_size - (offset + siz=
eof(struct dm_target_spec)), QUOTE_0_TERMINATED);

Please wrap long lines so they won't exceed 80 symbols.


--=20
ldv

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlW9B7gACgkQfKvmrJ41Nh6n9QCfdgGGFIpaHlBi133IxZalmnzU
RIEAnAthUlANY43dL6QvxXY4fZoMuBFQ
=1PbR
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--


--===============7988892270514070056==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============7988892270514070056==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Strace-devel mailing list
Strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/strace-devel

--===============7988892270514070056==--
