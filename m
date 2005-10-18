From: Axel Thimm <Axel.Thimm@ATrpms.net>
Subject: Performance and HSV100
Date: Tue, 18 Oct 2005 11:25:50 +0200
Message-ID: <20051018092550.GK2417@neu.nirvana>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1751136930=="
Return-path: <dm-devel-bounces@redhat.com>
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


--===============1751136930==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Content-Disposition: inline


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I'm getting poor performance from a qla2340 adapter attached to a 2GB
switch and an EVA3000 behind it, so I hoped to improve it by pulling
from both active paths. The host is RHEL4U2 dual opteron using 0.4.5
multipath tools.

I used group_by_serial and had some improvement, but less than I
hoped. I remember that there were some performance issues with
group_by_serial and storageworks tagged as 20% loss. Is this still
true?

A bit off-topic, but I'm trying to benchmark the throughput. Does
anyone have numbers for qla2340/brocade 2GB/HSV100 or a pointer?

Thanks!
--=20
Axel.Thimm at ATrpms.net

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDVL+eQBVS1GOamfERAk3rAJ9HkfIFkR266uy+57jOTaBn6qdtKACfTX8I
RXQGJihdaX07RieP/F+e2X0=
=x9fD
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--


--===============1751136930==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1751136930==--
