From: =?ISO-8859-1?Q?=C9tienne?= BERSAC <etienne.bersac@nonstop.fr>
Subject: dm-cache caching network volume
Date: Tue, 18 Jun 2013 11:32:52 +0200
Message-ID: <1371547972.6128.8.camel@expiron>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6743504841615577598=="
Return-path: <dm-devel-bounces@redhat.com>
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


--===============6743504841615577598==
Content-Type: multipart/signed; micalg="pgp-sha1";
	protocol="application/pgp-signature";
	boundary="=-u83p5oP2xjTp2pYJzo8l"


--=-u83p5oP2xjTp2pYJzo8l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I'm testing dm-cache for using a local SSD as a cache for a network
volume. My goal is to test dm-cache behaviour when network is down.

The device is shared through iSCSI. The first test is filling a huge
file with dd from /dev/zero. So, this is sequential access. While dd is
running, i remove the tun iface from the bridge on the host. iSCSI
properly detects the network failure.

I expected dm-cache to continue filling dirty blocks, even if the
network device is blocking. But it doesn't. The status shows that dirty
blocks count stays the same. dd is blocking.

I'm wondering if there is some cache desactivation due to
sequential_threshold. But increasing sequential_threshold did not help.
Where does dm-cache blocks ?

Is it possible to have dm-cache "bufferize" blocks for network
failures ?

Regards,
--=20
=C3=89tienne BERSAC <etienne.bersac@nonstop.fr>
NON STOP Systems

--=-u83p5oP2xjTp2pYJzo8l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRwClEAAoJEF5WQ9pdAIwZPJsH/3DmIaSvcjTjiPMJT6mrJG1K
jbp4kqWiFBv6Ihc/LBJwXi8zPwMsaQTFkuxJOUCGhcASliU3JOwXXR2Sr3FJn7Vs
J2Qw7tu5Md7irvvEX1Bd9QoT1v1+vgDKSIzawr5sVIuRQ8bpc4sL0lM57m/xf/AJ
t9xExlHbt+zJqC8DNxRvL4V4BYIW5n/gABR1OfOVBaCusmKZdJGFZPyGcp9K2I+4
CY5u5sOAchr8GXMmAuQk9aBu/2wxX8fLQqyVJ+Vp5TCaSleuaZktm/x+W/OrZ6zm
/bnueT0ElUkm/Axg39ceaiIV9UZGeceIzVHxK4sogn07P9Gs/EkssepYcDaY2C8=
=Fs+T
-----END PGP SIGNATURE-----

--=-u83p5oP2xjTp2pYJzo8l--


--===============6743504841615577598==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6743504841615577598==--
