From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: Re: [dm-devel] Error when compiling drivers/md/dm-bufio.c
Date: Mon, 7 Nov 2011 17:15:14 +0100
Message-ID: <20111107161514.GE18221@smp.if.uj.edu.pl>
References: <20111107082231.GB18221@smp.if.uj.edu.pl>
 <20111107134601.GH12886@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1111071035380.5814@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1111071035380.5814@hs20-bc2-1.build.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 11-07 10:36, Mikulas Patocka wrote:
>=20
>=20
> On Mon, 7 Nov 2011, Alasdair G Kergon wrote:
>=20
> > On Mon, Nov 07, 2011 at 09:22:31AM +0100, Witold Baryluk wrote:
> > > I just got error on todays Linus' tree
> > >   CC [M]  drivers/md/dm-bufio.o
> > > drivers/md/dm-bufio.c:988:1: warning: type defaults to =E2=80=98i=
nt=E2=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wim=
plicit-int]
> >=20
> > Probably related to this merge:
> >   commit 32aaeffbd4a7457bf2f7448b33b5946ff2a960eb
> >   Merge branch 'modsplit-Oct31_2011' of git://git.kernel.org/pub/sc=
m/linux/ker
> >=20
> > Previously module.h was included via another header file.
> > Now, bufio.c needs an explicit
> >=20
> > #include <linux/module.h>
> >=20
> > Alasdair
> >=20
>=20
> Yes, apply this patch:
>=20
> dm-bufio: Include <linux/module.h>
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>=20
> ---
>  drivers/md/dm-bufio.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> Index: linux-2.6-compile/drivers/md/dm-bufio.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6-compile.orig/drivers/md/dm-bufio.c	2011-11-07 16:31:34.=
000000000 +0100
> +++ linux-2.6-compile/drivers/md/dm-bufio.c	2011-11-07 16:31:41.00000=
0000 +0100
> @@ -8,6 +8,7 @@
> =20
>  #include "dm-bufio.h"
> =20
> +#include <linux/module.h>
>  #include <linux/device-mapper.h>
>  #include <linux/dm-io.h>
>  #include <linux/slab.h>
>=20
> Mikulas

Compiles.

However, I get similar warnings (not errors this times,
because only variables are used probably, and implicitly used as ints)

  CC [M]  drivers/md/persistent-data/dm-space-map-checker.o
drivers/md/persistent-data/dm-space-map-checker.c:427:1: warning: data =
definition has no type or storage class [enabled by default]
drivers/md/persistent-data/dm-space-map-checker.c:427:1: warning: type =
defaults to =E2=80=98int=E2=80=99 in declaration of =E2=80=98EXPORT_SYM=
BOL_GPL=E2=80=99 [-Wimplicit-int]
drivers/md/persistent-data/dm-space-map-checker.c:427:1: warning: param=
eter names (without types) in function declaration [enabled by default]
drivers/md/persistent-data/dm-space-map-checker.c:433:1: warning: data =
definition has no type or storage class [enabled by default]
drivers/md/persistent-data/dm-space-map-checker.c:433:1: warning: type =
defaults to =E2=80=98int=E2=80=99 in declaration of =E2=80=98EXPORT_SYM=
BOL_GPL=E2=80=99 [-Wimplicit-int]
drivers/md/persistent-data/dm-space-map-checker.c:433:1: warning: param=
eter names (without types) in function declaration [enabled by default]
  CC [M]  drivers/md/persistent-data/dm-space-map-common.o

Adding similar include to dm-space-map-checker.c, resolves problem.

No further problems found (however I do not have all CONFIG_DM_* enable=
d).

Regards,
Witek



--=20
Witold Baryluk
JID: witold.baryluk // jabster.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
