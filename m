From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] Clean up multipath linking
Date: Fri, 3 Apr 2009 23:37:30 +0200
Message-ID: <20090403233730.31578b3d@plop>
References: <20090403041935.GV15911@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090403041935.GV15911@ether.msp.redhat.com>
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

Le Thu, 2 Apr 2009 23:19:36 -0500,
Benjamin Marzinski <bmarzins@redhat.com> a =C3=A9crit :

> This is a patch to fix up the linking. It does two things.  First, it
> makes libmultipath.so install to /lib/ just like a normal shared
> library, so you don't have to use -rpath to link to it.  Second, and
> more importantly, it moves the libaio linking into
> libcheckdirectio.so, where it belongs.  Since libcheckdirectio.so is
> a dynamic shared object, multipath and multipathd don't know what
> functions they need to link in from libaio. This fixes the directio
> lockup for me.
>=20
How grateful I am. I was so focused on finding a bug in the async code,
I missed this linking regression.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/Makefile          |    7 ++++---
>  libmultipath/checkers/Makefile |    3 +++
>  multipath/Makefile             |    5 ++---
>  multipathd/Makefile            |    4 ++--
>  4 files changed, 11 insertions(+), 8 deletions(-)
>=20
> Index: multipath-tools-090402/libmultipath/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-090402.orig/libmultipath/Makefile
> +++ multipath-tools-090402/libmultipath/Makefile
> @@ -23,14 +23,15 @@ endif
>  all: $(LIBS)
> =20
>  $(LIBS): $(OBJS)
> -	$(CC) $(SHARED_FLAGS) $(CFLAGS) -o $@ $(OBJS)
> +	$(CC) $(SHARED_FLAGS) -Wl,-soname,$@ $(CFLAGS) -o $@ $(OBJS)
> =20
>  install:
> +	$(INSTALL_PROGRAM) -d $(DESTDIR)$(prefix)/lib
> +	$(INSTALL_PROGRAM) -m 755 $(LIBS)
> $(DESTDIR)$(prefix)/lib/$(LIBS) $(INSTALL_PROGRAM) -m 755 -d
> $(DESTDIR)$(libdir)
> -	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)/$(LIBS)
> =20
>  uninstall:
> -	rm -f $(DESTDIR)$(libdir)/$(LIBS)
> +	rm -f $(DESTDIR)$(prefix)/lib/$(LIBS)
> =20
>  clean:
>  	rm -f core *.a *.o *.gz *.so
> Index: multipath-tools-090402/multipath/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-090402.orig/multipath/Makefile
> +++ multipath-tools-090402/multipath/Makefile
> @@ -6,9 +6,8 @@ include ../Makefile.inc
> =20
>  OBJS =3D main.o
> =20
> -CFLAGS +=3D -I$(multipathdir) -Wl,-rpath,$(libdir)
> -LDFLAGS +=3D -lpthread -ldevmapper -laio -ldl \
> -	   -lmultipath -L$(multipathdir)
> +CFLAGS +=3D -I$(multipathdir)
> +LDFLAGS +=3D -lpthread -ldevmapper -ldl -lmultipath -L$(multipathdir)
> =20
>  EXEC =3D multipath
> =20
> Index: multipath-tools-090402/multipathd/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-090402.orig/multipathd/Makefile
> +++ multipath-tools-090402/multipathd/Makefile
> @@ -5,8 +5,8 @@ include ../Makefile.inc
>  #
>  # basic flags setting
>  #
> -CFLAGS +=3D -I$(multipathdir) -Wl,-rpath,$(libdir)
> -LDFLAGS +=3D -lpthread -ldevmapper -lreadline -lncurses -laio -ldl \
> +CFLAGS +=3D -I$(multipathdir)
> +LDFLAGS +=3D -lpthread -ldevmapper -lreadline -lncurses -ldl \
>  	   -lmultipath -L$(multipathdir)
> =20
>  #
> Index: multipath-tools-090402/libmultipath/checkers/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-090402.orig/libmultipath/checkers/Makefile
> +++ multipath-tools-090402/libmultipath/checkers/Makefile
> @@ -17,6 +17,9 @@ CFLAGS +=3D -I..
> =20
>  all: $(LIBS)
> =20
> +libcheckdirectio.so: libsg.o directio.o
> +	$(CC) $(SHARED_FLAGS) -o $@ $^ -laio
> +
>  libcheck%.so: libsg.o %.o
>  	$(CC) $(SHARED_FLAGS) -o $@ $^
> =20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
