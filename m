From: Michael Shigorin <mike@osdn.org.ua>
Subject: [PATCH] libdm: add "|" to _is_whitelisted_char()
Date: Tue, 27 Nov 2012 21:11:23 +0200
Message-ID: <20121127191123.GZ19704@osdn.org.ua>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0533132687845265865=="
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
Cc: Sergey Vlasov <vsu@altlinux.ru>, "Dmitry V. Levin" <ldv@altlinux.org>
List-Id: dm-devel.ids


--===============0533132687845265865==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8MZM6zh5Bb05FW+3"
Content-Disposition: inline


--8MZM6zh5Bb05FW+3
Content-Type: multipart/mixed; boundary="EOHJn1TVIJfeVXv2"
Content-Disposition: inline


--EOHJn1TVIJfeVXv2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

	Hello,
please find attached a silly one-liner that was mentioned
on #device-mapper yesterday and discussed with asalor today.

It adds "|" to a whitelist of chars allowed in devnode names
for the sake of legacy compatibility with EVMS2 LVM plugin
which uses to name the nodes like "lvm2|vg|lv".

I'm going to add it to ALT Linux lvm2 package for that matter
but would definitely prefer not to fork even a single byte
for no good reason.

TIA

--=20
 ---- WBR, Michael Shigorin <mike@altlinux.ru>
  ------ Linux.Kiev http://www.linux.kiev.ua/

--EOHJn1TVIJfeVXv2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-libdm-add-to-_is_whitelisted_char.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 6c36767acfbc6f72ad7ffed298200088b9bb123b Mon Sep 17 00:00:00 2001
From: Michael Shigorin <mike@altlinux.org>
Date: Fri, 23 Nov 2012 17:21:33 +0200
Subject: [PATCH] libdm: add "|" to _is_whitelisted_char()

The issue is that EVMS' lvm2 plugin would yield names like
"/dev/mapper/lvm2|vg|lv" and the current libdevmapper will
turn these down; this makes migrating legacy environments
involving devmapper-aware tools in the target configuration
a somewhat harder task than it might be.

There's a potential security consideration with any faulty
scripts which wouldn't get device names quoted as noted by
asalor on #device-mapper; this is rather mitigated by the
fact that one needs to have EVMS activated for the devices
in question, even if these are USB flash ones.  Speaking of
such scripts, these are prone to misbehave upon "=3D" either.
---
 libdm/libdm-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libdm/libdm-common.c b/libdm/libdm-common.c
index afdac89..e715629 100644
--- a/libdm/libdm-common.c
+++ b/libdm/libdm-common.c
@@ -320,7 +320,7 @@ static int _is_whitelisted_char(char c)
         if ((c >=3D '0' && c <=3D '9') ||
             (c >=3D 'A' && c <=3D 'Z') ||
             (c >=3D 'a' && c <=3D 'z') ||
-            strchr("#+-.:=3D@_", c) !=3D NULL)
+            strchr("#+-.:=3D@_|", c) !=3D NULL)
                 return 1;
=20
         return 0;
--=20
1.7.12.4


--EOHJn1TVIJfeVXv2--

--8MZM6zh5Bb05FW+3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFQtRBbbsPDprYMm3IRAtGhAKCtCVFVgKBVrgIeBD7hpwh/rPthWQCdFt1S
/yY/4Ls6v+X9iMQGp8Ysefc=
=LrSL
-----END PGP SIGNATURE-----

--8MZM6zh5Bb05FW+3--


--===============0533132687845265865==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0533132687845265865==--
