From: AJ Lewis <alewis@rackable.com>
Subject: Re: tiny patch: avoid an unnecessary test
Date: Fri, 16 Mar 2007 08:47:02 -0500
Message-ID: <20070316134701.GA5454@fenrir.local>
References: <87fy85bnic.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1014750697=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87fy85bnic.fsf@rho.meyering.net>
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
List-Id: dm-devel.ids


--===============1014750697==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ul2mxMk0z4RYCW0d"
Content-Disposition: inline


--Ul2mxMk0z4RYCW0d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Actually, there's a chance you'd get a NULL pointer error if you don't have
that check if I'm reading the context right.  Linux doesn't guarantee malloc
will return NULL if memory is unavailable, you only get the error when you
attempt to write to memory.  So if there is an allocation error, you're only
going to see it in the memset.

--
AJ

On Fri, Mar 16, 2007 at 09:28:43AM +0100, Jim Meyering wrote:
> Not a big deal (barely worth mentioning), but it might save
> someone else a little time wondering "why".
>=20
> 2007-03-11  Jim Meyering  <jim@meyering.net>
>=20
> 	Remove unnecessary test.
> 	* dmeventd/dmeventd.c (_alloc_dso_data): Don't test known-non-NULL
> 	memset return value.
>=20
> 2007-03-11  Jim Meyering  <jim@meyering.net>
> Index: dmeventd/dmeventd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> RCS file: /cvs/dm/device-mapper/dmeventd/dmeventd.c,v
> retrieving revision 1.46
> diff -u -p -r1.46 dmeventd.c
> --- dmeventd/dmeventd.c	2 Feb 2007 17:08:51 -0000	1.46
> +++ dmeventd/dmeventd.c	12 Mar 2007 14:39:35 -0000
> @@ -258,8 +258,8 @@ static struct dso_data *_alloc_dso_data(
>  	if (!ret)
>  		return NULL;
>=20
> -	if (!memset(ret, 0, sizeof(*ret)) ||
> -	    !(ret->dso_name =3D dm_strdup(data->dso_name))) {
> +	memset(ret, 0, sizeof(*ret));
> +	if (!(ret->dso_name =3D dm_strdup(data->dso_name))) {
>  		dm_free(ret);
>  		return NULL;
>  	}
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--Ul2mxMk0z4RYCW0d
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (Darwin)

iD8DBQFF+p/Vn95okVnkz6cRAvYhAKCEle3+fXSweP5grDf/cglqfk2pcQCgjQ/w
CKolyNT1XnG8HhIzIyH5tJg=
=xMxU
-----END PGP SIGNATURE-----

--Ul2mxMk0z4RYCW0d--


--===============1014750697==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1014750697==--
