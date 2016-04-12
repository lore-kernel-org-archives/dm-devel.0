From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 4.5 052/238] dm cache: make sure every
 metadata function checks fail_io
Date: Tue, 12 Apr 2016 02:27:03 +0100
Message-ID: <1460424423.25201.87.camel@decadent.org.uk>
References: <20160410183456.398741366@linuxfoundation.org>
	<20160410183459.304585887@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8314172458002729245=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160410183459.304585887@linuxfoundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids


--===============8314172458002729245==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YhxKHPVSavo43q4XwrGk"


--=-YhxKHPVSavo43q4XwrGk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2016-04-10 at 11:33 -0700, Greg Kroah-Hartman wrote:
> 4.5-stable review patch.=C2=A0=C2=A0If anyone has any objections, please =
let me know.

I've dropped stable because this isn't actually broken, but...

> ------------------
>=20
> From: Joe Thornber <ejt@redhat.com>
>=20
> commit d14fcf3dd79c0b8a8d0ba469c44a6b04f3a1403b upstream.
>=20
> Otherwise operations may be attempted that will only ever go on to crash
> (since the metadata device is either missing or unreliable if 'fail_io'
> is set).
>=20
> Signed-off-by: Joe Thornber <ejt@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
> =C2=A0drivers/md/dm-cache-metadata.c |=C2=A0=C2=A0=C2=A098 ++++++++++++++=
++++++++++-----------------
> =C2=A0drivers/md/dm-cache-metadata.h |=C2=A0=C2=A0=C2=A0=C2=A04 -
> =C2=A0drivers/md/dm-cache-target.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A012=
 ++++-
> =C2=A03 files changed, 71 insertions(+), 43 deletions(-)
>=20
> --- a/drivers/md/dm-cache-metadata.c
> +++ b/drivers/md/dm-cache-metadata.c
> @@ -867,19 +867,40 @@ static int blocks_are_unmapped_or_clean(
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> -#define WRITE_LOCK(cmd) \
> -	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) \
> +#define WRITE_LOCK(cmd)	\
> +	down_write(&cmd->root_lock); \
> +	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) { \
> +		up_write(&cmd->root_lock); \
> =C2=A0		return -EINVAL; \
> -	down_write(&cmd->root_lock)
> +	}
> =C2=A0
> =C2=A0#define WRITE_LOCK_VOID(cmd) \
> -	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) \
> +	down_write(&cmd->root_lock); \
> +	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) { \
> +		up_write(&cmd->root_lock); \
> =C2=A0		return; \
> -	down_write(&cmd->root_lock)
> +	}

Whenever a macro expands to multiple statements they should be wrapped
up in do { ... } while (0) so the macro is safe to use in other
compound statements.

That's not a regression for these existing macros, but:

> =C2=A0#define WRITE_UNLOCK(cmd) \
> =C2=A0	up_write(&cmd->root_lock)
> =C2=A0
> +#define READ_LOCK(cmd) \
> +	down_read(&cmd->root_lock); \
> +	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) { \
> +		up_read(&cmd->root_lock); \
> +		return -EINVAL; \
> +	}
> +
> +#define READ_LOCK_VOID(cmd)	\
> +	down_read(&cmd->root_lock); \
> +	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) { \
> +		up_read(&cmd->root_lock); \
> +		return; \
> +	}
[...]

here you're repeating the same broken pattern in new macros. =C2=A0Which
checkpatch.pl would have complained about, if you'd thought to run it.

Hiding return statements in macros is another bad idea (who expects
exceptions in C?). =C2=A0And once we reject that bad idea, all these macros
can be inline functions, like:

static inline bool dm_cm_read_lock(struct dm_cache_metadata *cmd)
{
	down_read(&cmd->root_lock);
	if (cmd->fail_io || dm_bm_is_read_only(cmd->bm)) {
		up_read(&cmd->root_lock);
		return false;
	}
	return true;
}

/* ... */

	if (!dm_cm_read_lock(cmd))
		return -EINVAL;

Actually... I said this wasn't broken, but should the READ_LOCK macros
really fail in case dm_bm_is_read_only(), or only if cmd->fail_io?

Ben.

--=C2=A0
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.
--=-YhxKHPVSavo43q4XwrGk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXDE7oAAoJEOe/yOyVhhEJgHEQAMYO6m+m8IYgs3xiSe4Nx802
u9qWazvBplPDcWuGUamD8Dmmcy32kfAXtYOnrc1yzLNm99HIS0JotyI9m9OX1J2H
jyd1mc8O+aXyNdIHnHixO9bd9YqyQ9+MC+4FxK5JFwUQODHejfNiRnLMAeWJ1WaR
AfVJ/Uke9TZ8Qt81fz98szI1kmsvDi5Ywd/C5vs+MyM9rMhfCWiXVW1GbFeYYcfh
q688BHe/NvPf2j9j7T7wSYDNgLgg2q5wHZgoL9FN0nn6VUaPf4EcO84iuWSW66Mh
WIdAKuPQbaYO3IEi+aLHW5RDpG12dnAA5XkN0+ZizFiH3ddkEadOgyNf3WoXC+db
rYgzasZUvrEd1LYx287DkWLWye8nTRIGSZutOkZl1QDNBkcqm5UkdIrIhlfLKFu3
oir3I/HmfKsFw3gPjigQcOjdPJI2FB+e7ZBQG3Z46oQhquigEpPfycQ2PcdVfKx1
aHqZd1vv30DWqYR8eDdHkKNZLdHHNSQLDPTq0sd8jl3stU1FpDKvQvX4otjzKRjL
RPBj1XM4u7zpx8avpL4n1pxNEFA2pSDmQAr3MxbrAXsggdfEn+jp+228JL1Xy4V3
v4So/ahOHH4RaNASBfcJv6sQvelJEfYDW6zcJJPuZG9u8J6ICSvss35PRvGQ/tLx
CyLU7Y0r6QyMvQA0OAjL
=Ajob
-----END PGP SIGNATURE-----

--=-YhxKHPVSavo43q4XwrGk--


--===============8314172458002729245==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8314172458002729245==--
