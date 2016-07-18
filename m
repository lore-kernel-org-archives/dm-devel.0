From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH V6 1/3] multipath-tools: New way to limit the
 IPC command length.
Date: Mon, 18 Jul 2016 20:38:32 +0800
Message-ID: <20160718123832.GA39932@redhat.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<20160712065038.17565-1-fge@redhat.com>
	<20160712065038.17565-2-fge@redhat.com>
	<20160715213545.GP8095@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4904085947003482748=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160715213545.GP8095@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============4904085947003482748==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 15, 2016 at 04:35:45PM -0500, Benjamin Marzinski wrote:
> On Tue, Jul 12, 2016 at 02:50:36PM +0800, Gris Ge wrote:
>=20
> The only thing that I wonder about with this patch is, when previously
> the multipath client code would have failed with EPIPE, and (at least in
> some cases) spit out a semi-useful message, the program will now
> terminate because of the SIGPIPE signal.  I'm not sure it makes any real
> difference, since we weren't very diligent with returning useful error
> messages in this case, and the client code isn't very likely to get
> SIGPIPE.
>=20
> I'm not very concerned if nobody else thinks this is important, I just
> though I should bring it up.
>=20
> -Ben
>=20
Thanks Ben, I will make next version of patch to handle/ignore
SIGPIPE.

--=20
Gris Ge

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXjM3IAAoJEGzN5Y/kHij/BxIP/3rHGYoQrJSFYMMG/l8fLtas
w5Pj7V/SXUaESEixh6hsYYCLjGT582bgCPdTV9AxvPffJLUm+RQvjJeepVCS1O6j
YySvf3OJBC+aflOVVZOuXgplMK2+baO2L3tDVBn6DlL+O67sdbg+pTSK+dMul9C0
11C7498Ba3XVjzoYgB2QCMIrAqaUEAfxabNAOlBUkc6pcZmQOMksqvbwQ0xdisgZ
fQYp06mmHfFH9vt9A1w85pmyYvYRXSbew4ZWGA00bDoU3dWCMVM68axhLxpPxYkq
hO4tlGt/78Uee694RBZqrBdWLuiii1yYGIwZ/r32m1vlvxZSB5YZu6JVHP6/Fgcd
JeR0I1bMp8S40M4tJfsMI7VqxDO22iMrCyFGIGMJ85XyQ2ZJNdLlykPwuigGL9vv
uoSVyye6Q788qKeUeJV3qa/+DhlfWFWUzRnYAKqdOQlMuuyGKRoiQNHr4qF6uH/1
K7txuKOcxaWh4cXKQ4WbMS2O8XYZVjbkZFbNht096hE85GOBJoyjQ8ByPy0j//lY
xGYiHknxjlPpJoCpWhXH9jUGXWKagIyNSoocpYMHlzhImXmVX6IqDKXP7IPTV4yE
aOyKPFZ8fRPTFk6tSXYRX1/dzcpRNCw8g2lvY4EouLg7bSrCDp95ZvX9UNbUJB2q
TskFJEmmOs0vatgh//0f
=R77h
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--


--===============4904085947003482748==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4904085947003482748==--
