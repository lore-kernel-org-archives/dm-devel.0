From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] Fix typo in new udev rule.
Date: Fri, 05 May 2017 15:16:15 +1000
Message-ID: <87r303opcw.fsf@notabene.neil.brown.name>
References: <149265560315.31004.3851231165281498425.stgit@noble> <149265600601.31004.323865505557190368.stgit@noble> <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com> <87mvbasqx6.fsf@notabene.neil.brown.name> <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com> <87h919ruj5.fsf@notabene.neil.brown.name> <85c9e9e1-3d2c-9f88-e923-235fb69a4188@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <85c9e9e1-3d2c-9f88-e923-235fb69a4188@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rajnoha <prajnoha@redhat.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


As pointed out by Peter Rajnoha, the correct usage in udev is
TEST=3D=3D"file", not TEST=3D"file".

Also improve a related comment which was a bit informal.

Reported-by: Peter Rajnoha <prajnoha@redhat.com>
Fixes: cd6cbb08c458 ("Create: tell udev md device is not ready when first c=
reated.")
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

Thanks Peter!  Properly tested as well :-)

NeilBrown


 lib.c                       | 2 +-
 udev-md-raid-creating.rules | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib.c b/lib.c
index 7e44b1f27fcc..be093e8c30cb 100644
=2D-- a/lib.c
+++ b/lib.c
@@ -165,7 +165,7 @@ char *fd2devnm(int fd)
=20
 /* When we create a new array, we don't want the content to
  * be immediately examined by udev - it is probably meaningless.
=2D * So create /run/mdadm/creating-FOO and expect that a udev
+ * So create /run/mdadm/creating-mdXXX and expect that a udev
  * rule will noticed this and act accordingly.
  */
 static char block_path[] =3D "/run/mdadm/creating-%s";
diff --git a/udev-md-raid-creating.rules b/udev-md-raid-creating.rules
index 2be466bcefd2..9bef8d1103f5 100644
=2D-- a/udev-md-raid-creating.rules
+++ b/udev-md-raid-creating.rules
@@ -4,4 +4,4 @@
 # the array is not "ready" and we should make sure the
 # content is ignored.
=20
=2DKERNEL=3D=3D"md*", TEST=3D"/run/mdadm/creating-$kernel", ENV{SYSTEMD_REA=
DY}=3D"0"
+KERNEL=3D=3D"md*", TEST=3D=3D"/run/mdadm/creating-$kernel", ENV{SYSTEMD_RE=
ADY}=3D"0"
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkMCp8ACgkQOeye3VZi
gbmwCg/+Oiq3AZ7hYKWNIEMK3ZszUzl2wRR4jvHSaiBYdFivxrB4MmJdq8EnH7J4
DnmHEtUpQ86p02+6XD3B116Tp2jsRreCpV/xFSllghQUcR3zuYv/x4UPb5L/0u4v
QFSRSRrhbkNekQtlMe6gaMwopNHiXE2fFVdKL8qsNX0WhBtlF7su9T82cJHeeqNi
RKIMETmrcZ49i4XNk9p+SGkJ5Lp2xLArCMhPihQ1Rva+PtG4xSLzzGgO0HcGagNM
nTZf+Dl21uGI60D3PLxGa1f9kSlhJ+sqA7u6WNgF6jO9sFuZqund/aLr3D9h6NEZ
7fhzs3r+k5hrJG3tYJiCZjNcBxydN5HW68d8aUINrbEvavs47D6RZr5yHAGMT+j/
bkNdR+tbVae5Nhi87QxHupAeKJYm6+bAHijjSe5STVZaFnuRgsj5affMt7B78W/O
ojhitfDcZLdcH0Vo+qUjnZJK6NsHy9NtDwT5iZcBeUD73TgEVOVYByCsUM9tQfsv
HcFYcgc+qu86cZF4pyBBrZqgx1VzvsoH+hvoqqcUt79qDnFgwHDcp0wxCcfn62m7
GHcgKreXal5T7qDCKyt3AbkkbOZc37TuAmc1AuACuxD3n5F9Ma0GoLm/0/mmiqp6
evQ7MLP3Rr8j7MLzCUypCt+TwoOw7oV8OVRrWAM4U+s2x8sIU4o=
=ycDs
-----END PGP SIGNATURE-----
--=-=-=--
