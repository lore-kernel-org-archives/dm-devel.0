From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: [TAKE 2] Document queue_if_no_path behavior
Date: Mon, 11 Feb 2008 20:09:42 +0530
Message-ID: <200802112009.47308.rrs@researchut.com>
Reply-To: Ritesh Raj Sarraf <rrs@researchut.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1323422654=="
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
To: dm-devel@redhat.com
Cc: rsarraf@netapp.com
List-Id: dm-devel.ids

--===============1323422654==
Content-Type: multipart/signed; boundary="nextPart7970004.QUL9VOczJG";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart7970004.QUL9VOczJG
Content-Type: multipart/mixed;
  boundary="Boundary-01=_v4FsHPbz+c85xMd"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_v4FsHPbz+c85xMd
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ben/Others,

As discussed at:
https://bugzilla.redhat.com/show_bug.cgi?id=3D419581

Can we see it into the man pages ?

Ritesh
=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."

--Boundary-01=_v4FsHPbz+c85xMd
Content-Type: text/x-diff; charset="us-ascii";
	name="0001-Document-queue_if_no_path-behavior.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Document-queue_if_no_path-behavior.patch"

=46rom 6098672f9f22ad60dcab1fd46682b88b390d307c Mon Sep 17 00:00:00 2001
=46rom: Ritesh Raj Sarraf <rrs@researchut.com>
Date: Wed, 19 Dec 2007 00:50:22 +0530
Subject: [PATCH] Document queue_if_no_path behavior

Document the queue_if_no_path behavior in situations where
all the paths to the LUN go offline.

Signed-off-by: Ritesh Raj Sarraf <rrs@researchut.com>
=2D--
 multipath/multipath.conf.5 |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index c8ab6b0..c66d7fc 100644
=2D-- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -374,6 +374,15 @@ section:
 .RE
 .PD
 .LP
+.SH "KNOWN ISSUES"
+The usage of
+.B queue_if_no_path
+option can lead to
+.B D state
+processes being hung and not killable in situations where all the paths to=
 the LUN go offline.
+It is advisable to use the
+.B no_path_retry
+option instead.
 .SH "SEE ALSO"
 .BR udev (8),
 .BR dmsetup (8)
=2D-=20
1.5.3.8


--Boundary-01=_v4FsHPbz+c85xMd--

--nextPart7970004.QUL9VOczJG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHsF4z4Rhi6gTxMLwRAudRAKCDw/YzEf1G6QwrdN1J3P/B/uxFIQCfeyEU
SJjogpGVTu1V9D64KgRBA8A=
=gWF4
-----END PGP SIGNATURE-----

--nextPart7970004.QUL9VOczJG--


--===============1323422654==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1323422654==--
