From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: Makefiles housekeeping
Date: Mon, 29 Aug 2016 09:25:42 +0200
Message-ID: <CABr-Gnf8qP+Ly-xZ5j6rRbsH0MdS=BcHcYXO4tDYjMU1G_UAjQ@mail.gmail.com>
References: <1472422242-9343-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2795737525496550859=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1472422242-9343-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2795737525496550859==
Content-Type: multipart/alternative; boundary=001a1142c2f6938252053b30c5a6

--001a1142c2f6938252053b30c5a6
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Mon, Aug 29, 2016 at 12:10 AM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> replace mandir with man8dir and put KRNL variables in place.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  Makefile              | 5 ++---
>  Makefile.inc          | 2 +-
>  kpartx/Makefile       | 6 +++---
>  mpathpersist/Makefile | 6 +++---
>  multipath/Makefile    | 6 +++---
>  multipathd/Makefile   | 6 +++---
>  6 files changed, 15 insertions(+), 16 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 95c7dfb..228d9ac 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -14,6 +14,8 @@ ifeq ($(KRNLSRC),)
>                 KRNLSRC = $(KRNLLIB)/build
>                 KRNLOBJ = $(KRNLLIB)/build
>         endif
> +       export KRNLSRC
> +       export KRNLOBJ
>  endif
>
>  ifeq ($(MULTIPATH_VERSION),)
> @@ -22,9 +24,6 @@ else
>         VERSION = $(MULTIPATH_VERSION)
>  endif
>
> -export KRNLSRC
> -export KRNLOBJ
> -
>  BUILDDIRS = \
>         libmpathcmd \
>         libmultipath \
> diff --git a/Makefile.inc b/Makefile.inc
> index 0808e64..56705c4 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -45,7 +45,7 @@ bindir                = $(exec_prefix)/sbin
>  libudevdir     = $(prefix)/$(SYSTEMDPATH)/udev
>  udevrulesdir   = $(libudevdir)/rules.d
>  multipathdir   = $(TOPDIR)/libmultipath
> -mandir         = $(prefix)/usr/share/man/man8
> +man8dir                = $(prefix)/usr/share/man/man8
>  man5dir                = $(prefix)/usr/share/man/man5
>  man3dir                = $(prefix)/usr/share/man/man3
>  syslibdir      = $(prefix)/$(LIB)
> diff --git a/kpartx/Makefile b/kpartx/Makefile
> index 853288f..e8a59f2 100644
> --- a/kpartx/Makefile
> +++ b/kpartx/Makefile
> @@ -31,12 +31,12 @@ install: $(EXEC) $(EXEC).8
>         $(INSTALL_PROGRAM) -m 755 kpartx_id $(DESTDIR)$(libudevdir)
>         $(INSTALL_PROGRAM) -d $(DESTDIR)$(libudevdir)/rules.d
>         $(INSTALL_PROGRAM) -m 644 kpartx.rules
> $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
> -       $(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
> -       $(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
> +       $(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
> +       $(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
>
>  uninstall:
>         $(RM) $(DESTDIR)$(bindir)/$(EXEC)
> -       $(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
> +       $(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
>         $(RM) $(DESTDIR)$(libudevdir)/kpartx_id
>         $(RM) $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
>         $(RM) $(DESTDIR)$(libudevdir)/rules.d/67-kpartx-compat.rules
> diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
> index 7921619..47043bb 100644
> --- a/mpathpersist/Makefile
> +++ b/mpathpersist/Makefile
> @@ -18,12 +18,12 @@ $(EXEC): $(OBJS)
>  install:
>         $(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
>         $(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
> -       $(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
> -       $(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
> +       $(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
> +       $(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
>
>  clean:
>         $(RM) core *.o $(EXEC) *.gz
>
>  uninstall:
>         $(RM) $(DESTDIR)$(bindir)/$(EXEC)
> -       $(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
> +       $(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
> diff --git a/multipath/Makefile b/multipath/Makefile
> index f296add..cad34bf 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -25,8 +25,8 @@ install:
>         $(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
>         $(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules
> $(DESTDIR)$(udevrulesdir)
>         $(INSTALL_PROGRAM) -m 644 $(EXEC).rules
> $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
> -       $(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
> -       $(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
> +       $(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
> +       $(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
>         $(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
>         $(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5.gz $(DESTDIR)$(man5dir)
>
> @@ -34,7 +34,7 @@ uninstall:
>         $(RM) $(DESTDIR)$(bindir)/$(EXEC)
>         $(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
>         $(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
> -       $(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
> +       $(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
>         $(RM) $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
>
>  clean:
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 8524efa..fd3d543 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -39,12 +39,12 @@ ifdef SYSTEMD
>         $(INSTALL_PROGRAM) -m 644 $(EXEC).service $(DESTDIR)$(unitdir)
>         $(INSTALL_PROGRAM) -m 644 $(EXEC).socket $(DESTDIR)$(unitdir)
>  endif
> -       $(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
> -       $(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
> +       $(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
> +       $(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
>
>  uninstall:
>         $(RM) $(DESTDIR)$(bindir)/$(EXEC)
> -       $(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
> +       $(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
>         $(RM) $(DESTDIR)$(unitdir)/$(EXEC).service
>         $(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
>
> --
> 2.7.4
>
>

--001a1142c2f6938252053b30c5a6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Aug 29, 2016 at 12:10 AM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">replace mandir with man8dir and put KRNL variables in p=
lace.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 5 ++---<br=
>
=C2=A0Makefile.inc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 2 +-<br>
=C2=A0kpartx/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0| 6 +++---<br>
=C2=A0mpathpersist/Makefile | 6 +++---<br>
=C2=A0multipath/Makefile=C2=A0 =C2=A0 | 6 +++---<br>
=C2=A0multipathd/Makefile=C2=A0 =C2=A0| 6 +++---<br>
=C2=A06 files changed, 15 insertions(+), 16 deletions(-)<br>
<br>
diff --git a/Makefile b/Makefile<br>
index 95c7dfb..228d9ac 100644<br>
--- a/Makefile<br>
+++ b/Makefile<br>
@@ -14,6 +14,8 @@ ifeq ($(KRNLSRC),)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 KRNLSRC =3D $(KRNLL=
IB)/build<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 KRNLOBJ =3D $(KRNLL=
IB)/build<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 endif<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0export KRNLSRC<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0export KRNLOBJ<br>
=C2=A0endif<br>
<br>
=C2=A0ifeq ($(MULTIPATH_VERSION),)<br>
@@ -22,9 +24,6 @@ else<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 VERSION =3D $(MULTIPATH_VERSION)<br>
=C2=A0endif<br>
<br>
-export KRNLSRC<br>
-export KRNLOBJ<br>
-<br>
=C2=A0BUILDDIRS =3D \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 libmpathcmd \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 libmultipath \<br>
diff --git a/Makefile.inc b/Makefile.inc<br>
index 0808e64..56705c4 100644<br>
--- a/Makefile.inc<br>
+++ b/Makefile.inc<br>
@@ -45,7 +45,7 @@ bindir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =3D $(exec_prefix)/sbin<br>
=C2=A0libudevdir=C2=A0 =C2=A0 =C2=A0=3D $(prefix)/$(SYSTEMDPATH)/udev<br>
=C2=A0udevrulesdir=C2=A0 =C2=A0=3D $(libudevdir)/rules.d<br>
=C2=A0multipathdir=C2=A0 =C2=A0=3D $(TOPDIR)/libmultipath<br>
-mandir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D $(prefix)/usr/share/man/man8<b=
r>
+man8dir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D $(prefi=
x)/usr/share/man/man8<br>
=C2=A0man5dir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D $(=
prefix)/usr/share/man/man5<br>
=C2=A0man3dir=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D $(=
prefix)/usr/share/man/man3<br>
=C2=A0syslibdir=C2=A0 =C2=A0 =C2=A0 =3D $(prefix)/$(LIB)<br>
diff --git a/kpartx/Makefile b/kpartx/Makefile<br>
index 853288f..e8a59f2 100644<br>
--- a/kpartx/Makefile<br>
+++ b/kpartx/Makefile<br>
@@ -31,12 +31,12 @@ install: $(EXEC) $(EXEC).8<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -m 755 kpartx_id $(DESTDIR)$=
(libudevdir)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -d $(DESTDIR)$(libudevdir)/r=
ules.<wbr>d<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -m 644 kpartx.rules $(DESTDI=
R)$(libudevdir)/rules.<wbr>d/66-kpartx.rules<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDI=
R)$(mandir)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDI=
R)$(man8dir)<br>
<br>
=C2=A0uninstall:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(bindir)/$(EXEC)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.<wbr>gz<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(man8dir)/$(EXEC).<wbr>8.gz<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(libudevdir)/<wbr>kpartx_id<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(libudevdir)/rules.<wbr>d/66-k=
partx.rules<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(libudevdir)/rules.<wbr>d/67-k=
partx-compat.rules<br>
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile<br>
index 7921619..47043bb 100644<br>
--- a/mpathpersist/Makefile<br>
+++ b/mpathpersist/Makefile<br>
@@ -18,12 +18,12 @@ $(EXEC): $(OBJS)<br>
=C2=A0install:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(b=
indir)/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDI=
R)$(mandir)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDI=
R)$(man8dir)<br>
<br>
=C2=A0clean:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) core *.o $(EXEC) *.gz<br>
<br>
=C2=A0uninstall:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(bindir)/$(EXEC)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.<wbr>gz<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(man8dir)/$(EXEC).<wbr>8.gz<br=
>
diff --git a/multipath/Makefile b/multipath/Makefile<br>
index f296add..cad34bf 100644<br>
--- a/multipath/Makefile<br>
+++ b/multipath/Makefile<br>
@@ -25,8 +25,8 @@ install:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(D=
ESTDIR)$(udevrulesdir)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTD=
IR)$(libudevdir)/rules.<wbr>d/56-multipath.rules<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDI=
R)$(mandir)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDI=
R)$(man8dir)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5.gz $(D=
ESTDIR)$(man5dir)<br>
<br>
@@ -34,7 +34,7 @@ uninstall:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(bindir)/$(EXEC)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(udevrulesdir)/11-<wbr>dm-mpat=
h.rules<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(libudevdir)/rules.<wbr>d/56-m=
ultipath.rules<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.<wbr>gz<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(man8dir)/$(EXEC).<wbr>8.gz<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(man5dir)/$(EXEC).<wbr>conf.5.=
gz<br>
<br>
=C2=A0clean:<br>
diff --git a/multipathd/Makefile b/multipathd/Makefile<br>
index 8524efa..fd3d543 100644<br>
--- a/multipathd/Makefile<br>
+++ b/multipathd/Makefile<br>
@@ -39,12 +39,12 @@ ifdef SYSTEMD<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -m 644 $(EXEC).service $(DES=
TDIR)$(unitdir)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -m 644 $(EXEC).socket $(DEST=
DIR)$(unitdir)<br>
=C2=A0endif<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDI=
R)$(mandir)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDI=
R)$(man8dir)<br>
<br>
=C2=A0uninstall:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(bindir)/$(EXEC)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.<wbr>gz<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(RM) $(DESTDIR)$(man8dir)/$(EXEC).<wbr>8.gz<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(unitdir)/$(EXEC).<wbr>service=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(RM) $(DESTDIR)$(unitdir)/$(EXEC).<wbr>socket<=
br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a1142c2f6938252053b30c5a6--


--===============2795737525496550859==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2795737525496550859==--
