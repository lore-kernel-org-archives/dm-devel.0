From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: [PATCH] kpartx: partitions of mapped devices cannot
 be created in redhat OS
Date: Tue, 06 Sep 2016 17:09:28 +0530
Message-ID: <1473161968.15423.1.camel@researchut.com>
References: <1472469122-12952-1-git-send-email-tang.junhui@zte.com.cn>
Reply-To: rrs@researchut.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7062248932135321509=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1472469122-12952-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============7062248932135321509==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ndu5wW+05G1XPaRxHLWn"


--=-ndu5wW+05G1XPaRxHLWn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yes. In Debian too, we've been hit by something similar.

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D827412
https://anonscm.debian.org/cgit/pkg-lvm/multipath-tools.git/tree/debian/dms=
etup_
env



On Mon, 2016-08-29 at 19:12 +0800, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
>=20
> Environment variables such as DM_TABLE_STATE are used in kpartx.rules whi=
ch
> exported
> by "dmsetup export" in previous udev rules in SuSE OS, however, there is =
no
> such command
> "dmsetup export" in redhat OS, so these environment variables are not
> initialized and
> partitions cannot be created. This patch replace "dmsetup export" with
> "dmsetup info"
> to get the status of mapped device, which can work well both in SuSE and
> redhat OS.
--=20
Given the large number of mailing lists I follow, I request you to CC
me in replies for quicker response
--=-ndu5wW+05G1XPaRxHLWn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJXzqrwAAoJEKY6WKPy4XVpK/UP+gNDuQ/v5y6DwvRXaMMIpIFr
WdQMmHUHwubFjfNHePpDkBBahlqweftlm3Fp6xDuTK5Q8TUnmFHJ7rbdmQtgdkgf
dnCakBxm2gZFL9JSx+bVChVvVsDQNyFU5lRPzIluqgDUb6caDNUp8U4AxuM/zfne
7+r+7xjIx+5Fg2SvRKCE847HCrRPUh8Kwxpm/f2rgmuH6xPvYehjowq8OElwpqaM
gdzEw5adfGoYvxHZ7h1i2/aXh8nSnz+b15g9Wij9t0KrwoGI048K6PgWmoLBrSYI
33OxAyHzx66HVxsw6AuACCHo6cWCwAwGM+En2dLacFz7dVue92x5kl45sACTmZlB
tzsUR4WbYTIZn4VgxmmQaceoHj7KUWN9xGfC1bHB2/iTghi/uMP3r7f5HJNBhNiW
zcVIg04urtHOciyFadCHD+4KjX0X5tdTMPjiYdifMEqht8WiwL1jFlgp9clOxplX
SmkkkDYLmOtZoUYyspzgxjHXmURH+08qhAJVBQqMCxjVKGg4fCrHZj/s/LMV8qoi
c/+olhIc5Axd6Wc1RBWW51k/3p65sUSIB/FSXj9T9UIIL7tCOz2CFcctucahdVxL
o+4vR1dKjEqBPwkethRelpKi5VvU/IGYBJNdmva9NmKSOsZ6W/BfsUrkFXobMF6U
QGuzbNnUZZi2Ia8uNkYB
=g28E
-----END PGP SIGNATURE-----

--=-ndu5wW+05G1XPaRxHLWn--



--===============7062248932135321509==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7062248932135321509==--
