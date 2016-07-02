From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH V3 1/3] multipath-tools: Increase
 MAX_REPLY_LEN.
Date: Sat, 2 Jul 2016 08:25:37 +0800
Message-ID: <20160702002537.GA1361@redhat.com>
References: <1455264623-16199-2-git-send-email-fge@redhat.com>
	<20160701124656.169890-1-fge@redhat.com>
	<20160701124656.169890-2-fge@redhat.com> <5776825D.8050202@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7935746991624584643=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5776825D.8050202@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============7935746991624584643==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 01, 2016 at 04:46:53PM +0200, Hannes Reinecke wrote:
> > -#define MAX_REPLY_LEN		65536
> > +#define MAX_REPLY_LEN		10485760
> > +/* ^ 10 MiB, enough for 'show maps json' command with 10k paths which
> > + *   requires about 8 MiB */
> > =20
> > =20
> Huh.
> Can't say I like it. The limit is pretty much self-imposed, so I'd
> rather bite the bullet and make it size-independent.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		   Teamlead Storage & Networking

Hi Hannes Reinecke,

How about limit the input command string size and let multipathd
output size-independent?

Best regards.

--=20
Gris Ge

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXdwn8AAoJEGzN5Y/kHij/ZhcP/AruJQaITgU6uBetneim9+tb
WLPeODXFJ/fxBr1sQnnUNDSjv9mUmqIL2k5PuH2D+NwwqJ+mcjw3naK2wD6CFCtp
dYkGDR75+HprqtKfHmdsSZXNfqlbRWbzVurDjIZLj1bqfq38WiFAX0oymT0+2paS
EmA6+v+OfhOfe+kZ3hhzR1slGcjYeiLQjLo29dZcD+caaMPNW1j5qffhtGnkxlbZ
fwecTDai/SI/ADC60RO3dpsIb9eAcJx5Qpv2BMFZzcQkMCbVY2XDUwYiSukCzB2X
2t42huiEDU/4BPN5rr72xb3Loep/1eFTdMGYtV+eAeF7khuN31sAgFxzimq+LDPv
MAIqTNlWVcrlbt1ZPz0W5OGBi3ijHHZ71vdsC+IgdeEY3zX52aB/vt3SpWWhLoEn
bkb6j2gx9mMuxIKL9TkMuG2JR/Q0WLEMklnfCoDtfjIpx+DSWRTWVdvYCETCIG5r
zIzk206g66sZeAW+r7twDi/Lzij4ye2A+17XiYnKPM+CuJz27MCOpvoXS7eaEoYM
izSZ0aRV7ZohHtwFasv68D3a/OMtluEvDJgqins7riUEqtkelpCrsonasqw6B+HA
rcDICY2PFCcZDMtoNNAjUt68Skrm/0rK9PTiMMgxM52SQRfGG0BYtSNlBTwG5KEC
Hnd8RcUiwDXckkGd4YTO
=Xba+
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--


--===============7935746991624584643==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7935746991624584643==--
