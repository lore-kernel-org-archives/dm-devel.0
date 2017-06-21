From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: enable libdmmp installation
 in alternative directory
Date: Wed, 21 Jun 2017 12:31:42 +0200
Message-ID: <CABr-GndwW-g9_mUh5BYaDLvzkxuxqZuHzmh06vg+GPVnZVqEKQ@mail.gmail.com>
References: <20170515203325.22170-1-mwilck@suse.com>
	<20170518170515.GR22856@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2857600614143403397=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170518170515.GR22856@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--===============2857600614143403397==
Content-Type: multipart/alternative; boundary="001a113e2ce6c795c2055275df8a"

--001a113e2ce6c795c2055275df8a
Content-Type: text/plain; charset="UTF-8"

Merged,
Thanks.

On Thu, May 18, 2017 at 7:05 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Mon, May 15, 2017 at 10:33:25PM +0200, Martin Wilck wrote:
>
> Fine by me.
>
> -Ben
>
> > Introduce a new Makefile variable, usr_prefix, to be used for
> > libdmmp and the associated pkgconfig file.
> >
> > Some distributions install those libraries which are  necessary
> > for booting (and mounting /usr) in a different location (/lib or
> > /lib64) than other libraries (/usr/lib or /usr/lib64). On such
> > distributions, installation to the different paths can be achieved
> > by setting "usr_prefix=/usr". This will affect only libdmmp at this
> > time, as all other libaries in the multipath-tools package may be
> > relevant for booting.
> >
> > For distributions on which /lib and /lib64 are just symlinks to their
> > /usr counterparts, nothing changes.
> >
> > Comments are welcome.
> >
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  Makefile.inc     |  4 +++-
> >  libdmmp/Makefile | 11 ++++++-----
> >  2 files changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/Makefile.inc b/Makefile.inc
> > index ad55aa10..ad08f307 100644
> > --- a/Makefile.inc
> > +++ b/Makefile.inc
> > @@ -47,6 +47,7 @@ endif
> >
> >  prefix               =
> >  exec_prefix  = $(prefix)
> > +usr_prefix   = $(prefix)
> >  bindir               = $(exec_prefix)/sbin
> >  libudevdir   = $(prefix)/$(SYSTEMDPATH)/udev
> >  udevrulesdir = $(libudevdir)/rules.d
> > @@ -55,6 +56,7 @@ man8dir             = $(prefix)/usr/share/man/man8
> >  man5dir              = $(prefix)/usr/share/man/man5
> >  man3dir              = $(prefix)/usr/share/man/man3
> >  syslibdir    = $(prefix)/$(LIB)
> > +usrlibdir    = $(usr_prefix)/$(LIB)
> >  libdir               = $(prefix)/$(LIB)/multipath
> >  unitdir              = $(prefix)/$(SYSTEMDPATH)/systemd/system
> >  mpathpersistdir      = $(TOPDIR)/libmpathpersist
> > @@ -62,7 +64,7 @@ mpathcmddir = $(TOPDIR)/libmpathcmd
> >  thirdpartydir        = $(TOPDIR)/third-party
> >  libdmmpdir   = $(TOPDIR)/libdmmp
> >  includedir   = $(prefix)/usr/include
> > -pkgconfdir   = $(prefix)/$(LIB)/pkgconfig
> > +pkgconfdir   = $(usrlibdir)/pkgconfig
> >
> >  GZIP         = gzip -9 -c
> >  RM           = rm -f
> > diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> > index 1c5329aa..908e294b 100644
> > --- a/libdmmp/Makefile
> > +++ b/libdmmp/Makefile
> > @@ -27,15 +27,16 @@ $(LIBS): $(OBJS)
> >       $(LN) $@ $(DEVLIB)
> >
> >  install:
> > -     $(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
> > +     mkdir -p $(DESTDIR)$(usrlibdir)
> > +     $(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(usrlibdir)/$(LIBS)
> >       $(INSTALL_PROGRAM) -m 644 -D \
> >               $(HEADERS) $(DESTDIR)$(includedir)/$(HEADERS)
> > -     $(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
> > +     $(LN) $(LIBS) $(DESTDIR)$(usrlibdir)/$(DEVLIB)
> >       $(INSTALL_PROGRAM) -m 644 -D \
> >               $(PKGFILE).in $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
> >       perl -i -pe 's|__VERSION__|$(LIBDMMP_VERSION)|g' \
> >               $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
> > -     perl -i -pe 's|__LIBDIR__|$(syslibdir)|g' \
> > +     perl -i -pe 's|__LIBDIR__|$(usrlibdir)|g' \
> >               $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
> >       perl -i -pe 's|__INCLUDEDIR__|$(includedir)|g' \
> >               $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
> > @@ -46,9 +47,9 @@ install:
> >       done
> >
> >  uninstall:
> > -     $(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
> > +     $(RM) $(DESTDIR)$(usrlibdir)/$(LIBS)
> >       $(RM) $(DESTDIR)$(includedir)/$(HEADERS)
> > -     $(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
> > +     $(RM) $(DESTDIR)$(usrlibdir)/$(DEVLIB)
> >       @for file in $(DESTDIR)$(man3dir)/dmmp_*; do \
> >               $(RM) $$file; \
> >       done
> > --
> > 2.12.2
>

--001a113e2ce6c795c2055275df8a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Thu, May 18, 2017 at 7:05 PM, Benjamin Ma=
rzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=
=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">On Mon, May 15, 2017 at 10:33:25PM +0200, Martin Wilck wrote:=
<br>
<br>
Fine by me.<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Introduce a new Makefile variable, usr_prefix, to be used for<br>
&gt; libdmmp and the associated pkgconfig file.<br>
&gt;<br>
&gt; Some distributions install those libraries which are=C2=A0 necessary<b=
r>
&gt; for booting (and mounting /usr) in a different location (/lib or<br>
&gt; /lib64) than other libraries (/usr/lib or /usr/lib64). On such<br>
&gt; distributions, installation to the different paths can be achieved<br>
&gt; by setting &quot;usr_prefix=3D/usr&quot;. This will affect only libdmm=
p at this<br>
&gt; time, as all other libaries in the multipath-tools package may be<br>
&gt; relevant for booting.<br>
&gt;<br>
&gt; For distributions on which /lib and /lib64 are just symlinks to their<=
br>
&gt; /usr counterparts, nothing changes.<br>
&gt;<br>
&gt; Comments are welcome.<br>
&gt;<br>
&gt; Signed-off-by: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwi=
lck@suse.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 Makefile.inc=C2=A0 =C2=A0 =C2=A0|=C2=A0 4 +++-<br>
&gt;=C2=A0 libdmmp/Makefile | 11 ++++++-----<br>
&gt;=C2=A0 2 files changed, 9 insertions(+), 6 deletions(-)<br>
&gt;<br>
&gt; diff --git a/Makefile.inc b/Makefile.inc<br>
&gt; index ad55aa10..ad08f307 100644<br>
&gt; --- a/Makefile.inc<br>
&gt; +++ b/Makefile.inc<br>
&gt; @@ -47,6 +47,7 @@ endif<br>
&gt;<br>
&gt;=C2=A0 prefix=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
<br>
&gt;=C2=A0 exec_prefix=C2=A0 =3D $(prefix)<br>
&gt; +usr_prefix=C2=A0 =C2=A0=3D $(prefix)<br>
&gt;=C2=A0 bindir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
 $(exec_prefix)/sbin<br>
&gt;=C2=A0 libudevdir=C2=A0 =C2=A0=3D $(prefix)/$(SYSTEMDPATH)/udev<br>
&gt;=C2=A0 udevrulesdir =3D $(libudevdir)/rules.d<br>
&gt; @@ -55,6 +56,7 @@ man8dir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D $(prefix)/usr/share/man/man8<br>
&gt;=C2=A0 man5dir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D $(pr=
efix)/usr/share/man/man5<br>
&gt;=C2=A0 man3dir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D $(pr=
efix)/usr/share/man/man3<br>
&gt;=C2=A0 syslibdir=C2=A0 =C2=A0 =3D $(prefix)/$(LIB)<br>
&gt; +usrlibdir=C2=A0 =C2=A0 =3D $(usr_prefix)/$(LIB)<br>
&gt;=C2=A0 libdir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
 $(prefix)/$(LIB)/multipath<br>
&gt;=C2=A0 unitdir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D $(pr=
efix)/$(SYSTEMDPATH)/<wbr>systemd/system<br>
&gt;=C2=A0 mpathpersistdir=C2=A0 =C2=A0 =C2=A0 =3D $(TOPDIR)/libmpathpersis=
t<br>
&gt; @@ -62,7 +64,7 @@ mpathcmddir =3D $(TOPDIR)/libmpathcmd<br>
&gt;=C2=A0 thirdpartydir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D $(TOPDIR)/third-par=
ty<br>
&gt;=C2=A0 libdmmpdir=C2=A0 =C2=A0=3D $(TOPDIR)/libdmmp<br>
&gt;=C2=A0 includedir=C2=A0 =C2=A0=3D $(prefix)/usr/include<br>
&gt; -pkgconfdir=C2=A0 =C2=A0=3D $(prefix)/$(LIB)/pkgconfig<br>
&gt; +pkgconfdir=C2=A0 =C2=A0=3D $(usrlibdir)/pkgconfig<br>
&gt;<br>
&gt;=C2=A0 GZIP=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D gzip -9 -c<br>
&gt;=C2=A0 RM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D rm -f<br>
&gt; diff --git a/libdmmp/Makefile b/libdmmp/Makefile<br>
&gt; index 1c5329aa..908e294b 100644<br>
&gt; --- a/libdmmp/Makefile<br>
&gt; +++ b/libdmmp/Makefile<br>
&gt; @@ -27,15 +27,16 @@ $(LIBS): $(OBJS)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0$(LN) $@ $(DEVLIB)<br>
&gt;<br>
&gt;=C2=A0 install:<br>
&gt; -=C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(sys=
libdir)/$(LIBS)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0mkdir -p $(DESTDIR)$(usrlibdir)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(usr=
libdir)/$(LIBS)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 644 -D \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$(HEADERS) $(DES=
TDIR)$(includedir)/$(<wbr>HEADERS)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(<wbr>DEVLI=
B)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0$(LN) $(LIBS) $(DESTDIR)$(usrlibdir)/$(<wbr>DEVLI=
B)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 644 -D \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$(PKGFILE).in $(=
DESTDIR)$(pkgconfdir)/$(<wbr>PKGFILE)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0perl -i -pe &#39;s|__VERSION__|$(LIBDMMP_<wb=
r>VERSION)|g&#39; \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$(DESTDIR)$(pkgc=
onfdir)/$(<wbr>PKGFILE)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0perl -i -pe &#39;s|__LIBDIR__|$(syslibdir)|g&#39;=
 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0perl -i -pe &#39;s|__LIBDIR__|$(usrlibdir)|g&#39;=
 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$(DESTDIR)$(pkgc=
onfdir)/$(<wbr>PKGFILE)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0perl -i -pe &#39;s|__INCLUDEDIR__|$(<wbr>inc=
ludedir)|g&#39; \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$(DESTDIR)$(pkgc=
onfdir)/$(<wbr>PKGFILE)<br>
&gt; @@ -46,9 +47,9 @@ install:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
&gt;<br>
&gt;=C2=A0 uninstall:<br>
&gt; -=C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(usrlibdir)/$(LIBS)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(includedir)/$(<wbr>HEADERS=
)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(syslibdir)/$(<wbr>DEVLIB)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(usrlibdir)/$(<wbr>DEVLIB)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0@for file in $(DESTDIR)$(man3dir)/dmmp_*; do=
 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) $$file; \<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
&gt; --<br>
&gt; 2.12.2<br>
</div></div></blockquote></div><br></div>

--001a113e2ce6c795c2055275df8a--


--===============2857600614143403397==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2857600614143403397==--
