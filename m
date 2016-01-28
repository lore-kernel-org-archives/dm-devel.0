From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH] Introducing multipath C API
 <libdmmp/libdmmp.h>
Date: Thu, 28 Jan 2016 17:40:12 +0800
Message-ID: <20160128094012.GA13102@redhat.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<56A9DC24.3050507@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7846218325842721875=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56A9DC24.3050507@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


--===============7846218325842721875==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 28, 2016 at 10:15:16AM +0100, Hannes Reinecke wrote:
> On 01/28/2016 04:52 AM, Gris Ge wrote:
> > FAQ:
> >=20
> >  1. Why not use better approach like wrapping multipathd IPC
> >  output?
> >=20
> >     That often means a lot changes to existing code which might be
> >     rejected.
> >     I would like to create a stable set of API, while its internal
> >     implementation could be changed without breaking binary
> >     compatibility.
> >=20
>=20
> Rather ... not.
>=20
> I would very much advocate to use the IPC interface into multipathd;
> we can easily define a stable ABI for that.
Hi Hannes Reinecke,

OK. I will try that approach.
Thanks for the suggestions.
>=20
> Cheers,
>=20
> Hannes

--=20
Gris Ge

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWqeH4AAoJEGzN5Y/kHij/x98QAIup+Yte6v/Ast3mE2vfdWc0
k+TqZhWeaGJKoAaAxXhL+2NL7Y3BNBYQMU2QNkXkXLcsWTeR8KygHQ5a8xvVk0Ce
57M7R6rQ9r2az/9h/3cKC9JZrKygUVHDTITxwkaLvU+hG+HTz4XaJdlYW1o592ml
1NDwcX5XywUFJ6+tRzsHrPjn1Y+/tGRKppxvJD/PVYEbCL79BTm68ZLA2kOFAvDM
Wx0tX6Q+wZW9Rqri3wD3Hj0CRqyBlXj5Jlucja8udhdscPghrb9hHgZbwWjzRfi3
EtxqSELJuKXM0CTz3r40B4EScInBXLV2RIiHNK6+0oqomZLG8q8p7Uh5C2c/L2Wt
ZSafYDiafPXopeUnKyQ8GhIhuLGzjK3462KQP2LLuiku/tu7qeYuDf2rBSEzAAaS
iiE9frRDSYymemmfCKgHwtTViONs0bxIVcLBC5zsjQJny9z42+319q5xmzG7NmYI
MIaUPJBGHTBDvI5Kb8InEi2yWs/IgViEkIpY01xSttkti3nG2wnxZEjU0YT3kPwc
KL7hgDN7UOzdez19rZl6ubI2tr4/R9HTOFyiQkmdn81pKnHuy87OcIdnSxzH0b1j
qNHwG5hiqJ+yx0bwAF0WkEEzlUTI3WFzyMlHrKZF5bg10ypn6R5p1Wiv9lWFTS8H
3VkzAr9z1pG51wfBq3oz
=yz72
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--


--===============7846218325842721875==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7846218325842721875==--
