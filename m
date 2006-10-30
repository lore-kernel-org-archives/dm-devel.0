From: Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [BUG] dmsetup table output changed from 2.6.18 to 2.6.19-rc3 and breaks yaird.
Date: Mon, 30 Oct 2006 16:19:30 +0100
Message-ID: <20061030151930.GQ27337@susi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ELk+q2VdTjIkPHaj"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030535AbWJ3PeH@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: herbert@gondor.apana.org.au, dm-devel@redhat.com
List-Id: dm-devel.ids


--ELk+q2VdTjIkPHaj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

Today the build of an initrd from a 2.6.19-rc3 kernel failed.

fairlight:/boot# yaird -o /tmp/foo.initrd 2.6.19-rc3-fairlight
yaird error: Could not read output for /sbin/modprobe -v -n --show-depends =
--set-version 2.6.19-rc3-fairlight cbc(aes) (fatal)

dmsetup table has changed the report for luks cipher.=20

dmsetup table on 2.6.18 reports: aes-cbc-essiv:sha256

dmsetup table on 2.6.19-rc3 reports: cbc(aes)-cbc-essiv:sha256

The problem seems to be on the kernel side here. Herbert Xu changed
the output with d1806f6a97a536b043fe50e6d8a25b061755cf50

http://kernel.org/git/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
it;h=3Dd1806f6a97a536b043fe50e6d8a25b061755cf50

The question is if this change was intentional and yaird should be
fixed, or it's a kernel API breakage.

regards
Stefan Schmidt

--ELk+q2VdTjIkPHaj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: http://www.datenfreihafen.org/contact.html

iD8DBQFFRhgCbNSsvd31FmURAlW+AJ9JZCVK8bdFzgYhAOU6DK9htXFgagCfZ8uC
A3QKnY87YLC2y2Yybr9GTBg=
=enYW
-----END PGP SIGNATURE-----

--ELk+q2VdTjIkPHaj--
