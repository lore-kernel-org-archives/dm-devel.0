From: Bastian Blank <bastian@waldi.eu.org>
Subject: [PATCH] multipath-tools/kpartx - loop support
Date: Thu, 29 Sep 2005 15:17:23 +0200
Message-ID: <20050929131723.GA16105@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0352879002=="
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============0352879002==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christophe

The following patches makes kpartx loop support buildable.

You can also pull this changes from
http://137.250.31.225/rsync/git/linux/storage/multipath-tools.git.

Bastian


Use kernel definition of __kernel_old_dev_t.

---
commit 283cc1fbbd7a212f1f18f1cc2a5cb0c2d3aebd9b
tree 14fc95286dd53aa21a2cd15fedd35f7488f26c45
parent 1d586d3a1a998b64fa27e61777478d8735d4152a
author Bastian Blank <waldi@debian.org> Thu, 29 Sep 2005 14:10:23 +0000
committer Bastian Blank <waldi@debian.org> Thu, 29 Sep 2005 14:10:23 +0000

 kpartx/lopart.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -27,17 +27,6 @@
 #include <sys/mman.h>
 #include <sysmacros.h>
=20
-#if defined(__hppa__) || defined(__powerpc64__) || defined (__alpha__) \
- || defined (__x86_64__)
-typedef unsigned long __kernel_old_dev_t;
-#elif defined(__powerpc__) || defined(__ia64__)
-typedef unsigned int __kernel_old_dev_t;
-#else
-typedef unsigned short __kernel_old_dev_t;
-#endif
-
-#define dev_t __kernel_old_dev_t
-
 #include <linux/loop.h>
=20
 #include "lopart.h"


=0C
!-------------------------------------------------------------flip-


Use C99 type uintptr_t.

---
commit 1dc2104b2a9a7db25dceaa37304abf83436813de
tree b81ec33c94cc0f5731bac9fd6eeec6134615c340
parent 283cc1fbbd7a212f1f18f1cc2a5cb0c2d3aebd9b
author Bastian Blank <waldi@debian.org> Thu, 29 Sep 2005 14:11:53 +0000
committer Bastian Blank <waldi@debian.org> Thu, 29 Sep 2005 14:11:53 +0000

 kpartx/lopart.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -26,18 +26,14 @@
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <sysmacros.h>
+#include <stdint.h>
=20
 #include <linux/loop.h>
=20
 #include "lopart.h"
 #include "xstrncpy.h"
=20
-#if !defined (__alpha__) && !defined (__ia64__) && !defined (__x86_64__) \
-        && !defined (__s390x__)
-#define int2ptr(x)	((void *) ((int) x))
-#else
-#define int2ptr(x)	((void *) ((long) x))
-#endif
+#define int2ptr(x)	((void *) ((uintptr_t) x))
=20
 static char *
 xstrdup (const char *s)


=0C
!-------------------------------------------------------------flip-



--=20
It would seem that evil retreats when forcibly confronted.
		-- Yarnek of Excalbia, "The Savage Curtain", stardate 5906.5

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iEYEARECAAYFAkM76WMACgkQnw66O/MvCNG5TQCfa+XO9G+oy7dZzUFHMP0Hefac
KAwAn3ixK/Lt4FbXe/eL8xwYQrIs7oDs
=DEFp
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--


--===============0352879002==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0352879002==--
