From: Ben Hutchings <ben@decadent.org.uk>
Subject: Bug#648367: device-mapper devices such as dm-crypt always have rotational=1; should inherit "rotational" setting from underlying devices
Date: Mon, 14 Nov 2011 01:05:29 +0000
Message-ID: <1321232729.3059.42.camel@deadeye>
References: <20111110195943.12083.93273.reportbug@leaf>
Reply-To: Ben Hutchings <ben@decadent.org.uk>, 648367@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fX6TJLeVxP/rNjId2pxj"
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.648367.B648367.132123274910182@bugs.debian.org>
In-Reply-To: <20111110195943.12083.93273.reportbug@leaf>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Josh Triplett <josh@joshtriplett.org>, 648367@bugs.debian.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--=-fX6TJLeVxP/rNjId2pxj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-11-10 at 11:59 -0800, Josh Triplett wrote:
> Source: linux-2.6
> Version: 3.1.0-1~experimental.1
> Severity: normal
>=20
> I use dm-crypt on my system, and I have an SSD.  The underlying disk
> device, sda, has rotational=3D0:
>=20
> ~$ cat /sys/block/sda/queue/rotational
> 0
>=20
> However, the device-mapper devices have rotational=3D1:
>=20
> ~$ head /sys/block/dm-*/queue/rotational
> =3D=3D> /sys/block/dm-0/queue/rotational <=3D=3D
> 1
>=20
> =3D=3D> /sys/block/dm-1/queue/rotational <=3D=3D
> 1
>=20
> =3D=3D> /sys/block/dm-2/queue/rotational <=3D=3D
> 1
>=20
> The device-mapper devices should inherit the setting for "rotational"
> from their underlying devices.

I'm not sure that's true.  Since their queues should feed into the
queues for the underlying devices, it may be that they shouldn't
themselves be scheduled as if they are rotating media.

I do wonder whether rotational should still be the default - almost all
real disks are handled by a small number of drivers like sd, while there
is a wide variety of networked, stacked and virtual disk drivers in use.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-fX6TJLeVxP/rNjId2pxj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATsBpWee/yOyVhhEJAQpj+w/9GldrewLzU3C+UobcgLp9B1SqZCO39btk
g4yhCculkyl4JrZbck3Z9bkQ2x97fouEYOYJmQAgD1x8PwoRLLnzKBy1D6Udg7hh
VxbwqgqeckkMh0KlxLSlMhls7LTe2xz7X8dGEv/CbcQMMP/+KbslW6LX0O2cm8+z
GPioJE25w8HpGNE2uZyRDFgdl0JTCnNxM4LdV4AO6IU41IPXTR7sBMxyiI5AFnye
d7oqOXvxw5pITFWLOvhHYvDbXcBI4uw9fur7gPSe3QjYpwcUMn1ksm0JptBIdOSS
iUbkCgI5MIiRL0MfhFkPAb0SNwr7ecU9ORvug3qw9nY5gGkYvJqxXEOKt11V3abF
nZsjvhj8i8iurKpRnakWK/oZwV3+AYVnf4ZNu5wWnDlpFkDEqa/FvVnXVRiYk579
XHZvt+7wtqNeSgZpJwsviXc0iyu15eaQns3ZkoMagnVZqhZwofQlHMChVCBYWO3B
FnxBCJpu3lSQUaHt4uegiQygnOwObnqRqg39XeiW0OXzIvHmI+SPh+ZxYsMS3gff
Y/AjRu+Pt2B6r6feyRmEqjc4FrXJ+CjjX7BQmhB2tqZbw8CwRHIRskoe9QYELIdY
p/VUxOOkezBtSM9hEW9OqaAJJ1OZNwnw+5vYRmeewWULnoREb+LhvJlz+BoyJUr1
3gPLMihUljw=
=dYba
-----END PGP SIGNATURE-----

--=-fX6TJLeVxP/rNjId2pxj--
