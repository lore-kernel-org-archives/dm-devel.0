From: Axel Thimm <Axel.Thimm@ATrpms.net>
Subject: kpartx & dm-multipath kernel module: Where/when should they be
	called (wrt FC4)?
Date: Fri, 20 May 2005 15:20:23 +0200
Message-ID: <200505201626.j4KGQrnj012380@neu.nirvana>
Reply-To: Development discussions related to Fedora Core <fedora-devel-list@redhat.com>
Content-Type: multipart/mixed; boundary="===============0850574188=="
Return-path: <fedora-devel-list-bounces@redhat.com>
Resent-Message-Id: <200505201626.j4KGQrnj012380@neu.nirvana>
Resent-To: fedora-devel-list@redhat.com
List-Unsubscribe: <http://www.redhat.com/mailman/listinfo/fedora-devel-list>,
	<mailto:fedora-devel-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/fedora-devel-list>
List-Post: <mailto:fedora-devel-list@redhat.com>
List-Help: <mailto:fedora-devel-list-request@redhat.com?subject=help>
List-Subscribe: <http://www.redhat.com/mailman/listinfo/fedora-devel-list>,
	<mailto:fedora-devel-list-request@redhat.com?subject=subscribe>
Sender: fedora-devel-list-bounces@redhat.com
Errors-To: fedora-devel-list-bounces@redhat.com
To: fedora-devel-list@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============0850574188==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I successfully managed to get multipath support on an EVA 3000
(HSV100). BTW shouldn't the policy for HSV100 be group_by_serial
(former group_by_tur)?

--- multipath.conf~        2005-04-01 22:56:49.000000000 +0200
+++ multipath.conf 2005-05-20 14:38:14.000000000 +0200
@@ -60,7 +60,7 @@
        device {
                vendor                  "HP      "
                product                 "HSV100          "
-               path_grouping_policy    multibus
+               path_grouping_policy    group_by_serial
                path_checker            tur
        }
        device {

Anyway now I have my /dev/dm-2 block device and I had to get to the
partitions on it. After some search I found that

	   kpartx -a /dev/dm-2

did the right job and extracted "/dev/dm-2p1" onto /dev/dm-3 (is that
the indented bahaviour? Getting a new device name?).

What I wonder now, is where and how kpartx should be embedded into the
distribution's init scripts. It needs to come before any lvm parts
as this is an lvm partition.

OTOH dm-multipath needs to be modprobed even earlier and currently I'm
using a new interface in the init scripts (/etc/sysconfig/modules)
which is called after lvm setup. :(

Any chance this could still hit FC4? <8-)

Thanks!
--=20
Axel.Thimm at ATrpms.net

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCjeQXQBVS1GOamfERAs3HAJwNp0iz07vkuwSsOtEsfzLTcuG8owCggKBo
nhSvo4mUFGxhanPpvonoL/E=
=0H2f
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--


--===============0850574188==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
fedora-devel-list mailing list
fedora-devel-list@redhat.com
http://www.redhat.com/mailman/listinfo/fedora-devel-list
--===============0850574188==--
