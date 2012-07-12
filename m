From: NeilBrown <neilb@suse.de>
Subject: Re: Linux RAID subsystem future
Date: Fri, 13 Jul 2012 06:35:01 +1000
Message-ID: <20120713063501.3f9a3bd8@notabene.brown>
References: <jtn1c5$q0u$1@dough.gmane.org>
	<CACJz6Qsx-xNxDRw5kUqUpf9ogVp23jokHOdGL9xO=kqFXmiNZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QkVBy74KTShRqRDJY0XGaGJ"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACJz6Qsx-xNxDRw5kUqUpf9ogVp23jokHOdGL9xO=kqFXmiNZg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Zdenek Kaspar <zkaspar82@gmail.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--Sig_/QkVBy74KTShRqRDJY0XGaGJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jul 2012 13:28:24 -0700 Drew <drew.kay@gmail.com> wrote:

> > Hello lists,
> >
> > I noticed recent patches added MD RAID compatibility into the DM
> > subsystem. Is there a valid reason to duplicate efforts ?
> >
> > Hopefully its not silent preparation step for DM takeover. Can someone
> > shed more light on this topic ?
> >
> > TIA, Z.
>=20
> I'm not a developer by any stretch of the word so take what I say with
> a grain of salt.
>=20
> I think it's more just a case of dm using md's RAID algorithms, which
> IMHO are better tested, to support fakeraid controllers like Intel's
> Matrix RAID. Besides, we're all one big happy linux family so why not
> borrow your brother's socks? :-)
>=20
>=20
Indeed!

It isn't duplication of effort - it is avoiding or removing duplication of
effort.  That's the theory any way.

There is no "DM takeover" - just engineers working together to try to find
optimal solutions.

NeilBrown


--Sig_/QkVBy74KTShRqRDJY0XGaGJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/809Tnsnt1WYoG5AQJhoxAAhsLilRHw4iseSEc92o7Pl3N40DMzs3xM
FTsNRLBrxhoDMQytN+vJz5tcIisvesCENUvRnMzCRNJkt0eJVRIEEeKZh21ntB2Y
2pvWo3Xc+URsLEGdtDCTsHvk/+ULdGAPtgDSxN9Zr5OoGYRGB5dFjhDgzo7/3q7N
PR7EYCvT6DJXbeF3MNoVtURb4dzyHbDcxawGMo9lOSVet1BY/MTEmpvuKLNczenI
uZj18SGCHkcTPQrX5r3BcPANga2CRhAtZIyDXTZSpEHVJvSekaPpQbfuxo+4/2TO
4Di2jCcJU9UVDS8RnO6xhEc+6shLe7IafP+BvAyy6CAC4TjJ7Ik6h1xgfU9N1vnJ
jPUiUJRLK5AIlOyYmn5r8AVUFBq/NWdWGwqEqZVabty69PwMW3o5oiZoTzK7pYC8
L7RnPpxXm2/TUacF/5OcFUR8UMZTOIiS9cSj8kaZ+t2Vgzd03uLicgtvURjq91Bl
yAZxv1ilNGGan2z57F32Hk0j2v/DcJ9aoA7c6FioDxdTr4tTrCzmU1xOFJsQz8yY
x/ZgX0xF2L98EXkLcjg1vNbwkKkwSVeHXkYOL11jJgjg5zj5HKbLmGgpbM7NxwJP
QQ/dw2Kx00yEreTn6hI8hDosI5do7MdmH8rQBS4XoYRm+jjxis3WsNZr8MyUvcaV
OnsmaKm03So=
=6DXF
-----END PGP SIGNATURE-----

--Sig_/QkVBy74KTShRqRDJY0XGaGJ--
