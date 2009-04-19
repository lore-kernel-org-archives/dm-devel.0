From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH 2/4] multipath-tools: install
	libmultipath.so in $syslibdir
Date: Mon, 20 Apr 2009 00:10:25 +0200
Message-ID: <1240179025.25083.2.camel@plop>
References: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
	<1240006080-27892-3-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1240006080-27892-3-git-send-email-snitzer@redhat.com>
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

Le vendredi 17 avril 2009 =C3=A0 18:07 -0400, Mike Snitzer a =C3=A9crit :
> Allows libmultipath.so to be installed in the proper lib dir
> (e.g. /lib64).  $libdir is already used for /lib/multipath
>=20

Mike,
am I missing something ... I don't the lib/lib64 switching code.

> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  Makefile.inc          |    1 +
>  libmultipath/Makefile |    6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/Makefile.inc b/Makefile.inc
> index 3e5bca0..1fe9782 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -21,6 +21,7 @@ multipathdir =3D $(TOPDIR)/libmultipath
>  mandir      =3D $(prefix)/usr/share/man/man8
>  man5dir     =3D $(prefix)/usr/share/man/man5
>  rcdir	    =3D $(prefix)/etc/init.d
> +syslibdir   =3D $(prefix)/lib
>  libdir	    =3D $(prefix)/lib/multipath
> =20
>  GZIP        =3D /bin/gzip -9 -c
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 35cb911..503223d 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -26,12 +26,12 @@ $(LIBS): $(OBJS)
>  	$(CC) $(SHARED_FLAGS) -Wl,-soname,$@ $(CFLAGS) -o $@ $(OBJS)
> =20
>  install:
> -	$(INSTALL_PROGRAM) -d $(DESTDIR)$(prefix)/lib
> -	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(prefix)/lib/$(LIBS)
> +	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
> +	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
>  	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(libdir)
> =20
>  uninstall:
> -	rm -f $(DESTDIR)$(prefix)/lib/$(LIBS)
> +	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
> =20
>  clean:
>  	rm -f core *.a *.o *.gz *.so
