From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] Error when compiling drivers/md/dm-bufio.c
Date: Mon, 7 Nov 2011 10:36:34 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1111071035380.5814@hs20-bc2-1.build.redhat.com>
References: <20111107082231.GB18221@smp.if.uj.edu.pl>
 <20111107134601.GH12886@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168436252-658836247-1320680194=:5814"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111107134601.GH12886@agk-dp.fab.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168436252-658836247-1320680194=:5814
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 7 Nov 2011, Alasdair G Kergon wrote:

> On Mon, Nov 07, 2011 at 09:22:31AM +0100, Witold Baryluk wrote:
> > I just got error on todays Linus' tree
> >   CC [M]  drivers/md/dm-bufio.o
> > drivers/md/dm-bufio.c:988:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplicit-in=
t]
>=20
> Probably related to this merge:
>   commit 32aaeffbd4a7457bf2f7448b33b5946ff2a960eb
>   Merge branch 'modsplit-Oct31_2011' of git://git.kernel.org/pub/scm/linu=
x/ker
>=20
> Previously module.h was included via another header file.
> Now, bufio.c needs an explicit
>=20
> #include <linux/module.h>
>=20
> Alasdair
>=20

Yes, apply this patch:

dm-bufio: Include <linux/module.h>

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-compile/drivers/md/dm-bufio.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6-compile.orig/drivers/md/dm-bufio.c=092011-11-07 16:31:34.0000=
00000 +0100
+++ linux-2.6-compile/drivers/md/dm-bufio.c=092011-11-07 16:31:41.000000000=
 +0100
@@ -8,6 +8,7 @@
=20
 #include "dm-bufio.h"
=20
+#include <linux/module.h>
 #include <linux/device-mapper.h>
 #include <linux/dm-io.h>
 #include <linux/slab.h>

Mikulas
--168436252-658836247-1320680194=:5814--
