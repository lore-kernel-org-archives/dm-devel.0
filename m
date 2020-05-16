From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 4/6] Unit tests for is_path_valid()
Date: Sat, 16 May 2020 11:51:28 +0000
Message-ID: <068058f2f546c6ef2474d8a704097dfbb0be05b3.camel@suse.com>
References: <1589507962-6895-1-git-send-email-bmarzins@redhat.com>
	<1589507962-6895-5-git-send-email-bmarzins@redhat.com>
	<9b472a9cdcea88daf12e74733eb579e489daded5.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9b472a9cdcea88daf12e74733eb579e489daded5.camel@suse.com>
Content-Language: en-US
Content-ID: <C9B2C319B857D443B69558A1855D1872@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2020-05-15 at 22:37 +0200, Martin Wilck wrote:
> On Thu, 2020-05-14 at 20:59 -0500, Benjamin Marzinski wrote:
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Two minor nits below, otherwise ack.
>=20
> > ---
> >  tests/Makefile |   4 +-
> >  tests/valid.c  | 424
> > +++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 427 insertions(+), 1 deletion(-)
> >  create mode 100644 tests/valid.c
> >=20
> > diff --git a/tests/Makefile b/tests/Makefile
> > index 1b8706a7..125553b8 100644
> > --- a/tests/Makefile
> > +++ b/tests/Makefile
> > @@ -13,7 +13,7 @@ CFLAGS +=3D $(BIN_CFLAGS) -I$(multipathdir)
> > -I$(mpathcmddir) \
> >  LIBDEPS +=3D -L$(multipathdir) -L$(mpathcmddir) -lmultipath
> > -lmpathcmd
> > -lcmocka
> > =20
> >  TESTS :=3D uevent parser util dmevents hwtable blacklist unaligned
> > vpd
> > pgpolicy \
> > -=09 alias directio
> > +=09 alias directio valid
> > =20
> >  .SILENT: $(TESTS:%=3D%.o)
> >  .PRECIOUS: $(TESTS:%=3D%-test)
> > @@ -50,6 +50,8 @@ vpd-test_OBJDEPS :=3D  ../libmultipath/discovery.o
> >  vpd-test_LIBDEPS :=3D -ludev -lpthread -ldl
> >  alias-test_TESTDEPS :=3D test-log.o
> >  alias-test_LIBDEPS :=3D -lpthread -ldl
> > +valid-test_OBJDEPS :=3D ../libmultipath/valid.o
> > +valid-test_LIBDEPS :=3D -ludev -lpthread -ldl
> >  ifneq ($(DIO_TEST_DEV),)
> >  directio-test_LIBDEPS :=3D -laio
> >  endif
> > diff --git a/tests/valid.c b/tests/valid.c
> > new file mode 100644
> > index 00000000..b128b029
> > --- /dev/null
> > +++ b/tests/valid.c
> > @@ -0,0 +1,424 @@
> > +/*
> > + * Copyright (c) 2020 Benjamin Marzinski, Redhat
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
> > License
> > + * along with this program.  If not, see <
> > https://www.gnu.org/licenses/>;;.
> > + *
> > + */
> > +
> > +#define _GNU_SOURCE
> > +#include <stdint.h>
> > +#include <stdbool.h>
> > +#include <stdarg.h>
> > +#include <stddef.h>
> > +#include <setjmp.h>
> > +#include <stdlib.h>
> > +#include <errno.h>
> > +#include <cmocka.h>
> > +#include "globals.c"
> > +#include "util.h"
> > +#include "discovery.h"
> > +#include "wwids.h"
> > +#include "valid.h"
> > +
> > +int test_fd;
> > +struct udev_device {
> > +=09int unused;
> > +} test_udev;
> > +
> > +bool __wrap_sysfs_is_multipathed(struct path *pp, bool set_wwid)
> > +{
> > +=09bool is_multipathed =3D mock_type(bool);
> > +=09assert_non_null(pp);

One general remark, just occured to me as I was looking at cmocka for a
different project: Perhaps we should rather use cmockas's
check_expected() functionality for testing parameter validity than the
assert...() macros.

We haven't done this consequently so far, but we could try to improve.

Regards
Martin


--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
