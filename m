From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 6/7] kpartx: Fix a compiler warning
Date: Thu, 18 May 2017 00:24:51 +0200
Message-ID: <CABr-GneZYGnRt_z7vrUxq+0pY1aODcqUPFGPOtx5bEfx+WxBWA@mail.gmail.com>
References: <20170517154309.17787-1-bart.vanassche@sandisk.com>
	<20170517154309.17787-7-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7678724341187732700=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517154309.17787-7-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7678724341187732700==
Content-Type: multipart/alternative; boundary="001a113e1f54c238a2054fbfc1cf"

--001a113e1f54c238a2054fbfc1cf
Content-Type: text/plain; charset="UTF-8"

This patch is dropped, due to
Martin's 8b9cda51f5c64bc869188ca0b2e1ac0e7eb7c667 patch switching to
sys/sysmacros.h

Otherwise, the rest of the set is now merged.
Thanks.

On Wed, May 17, 2017 at 5:43 PM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> Avoid that building against glibc >= 2.25 triggers the following
> compiler warning:
>
> lopart.c: In function 'is_loop_device':
> lopart.c:93:13: warning: In the GNU C Library, "major" is defined
>  by <sys/sysmacros.h>. For historical compatibility, it is
>  currently defined by <sys/types.h> as well, but we plan to
>  remove this soon. To use "major", include <sys/sysmacros.h>
>  directly. If you did not intend to use a system-defined macro
>  "major", you should undefine it after including <sys/types.h>.
>    major(statbuf.st_rdev) == loopmajor);
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  kpartx/Makefile    | 4 ++++
>  kpartx/sysmacros.h | 6 ++++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/kpartx/Makefile b/kpartx/Makefile
> index 9441a2ba..2d2a249e 100644
> --- a/kpartx/Makefile
> +++ b/kpartx/Makefile
> @@ -10,6 +10,10 @@ LIBDEPS += -ldevmapper
>  ifneq ($(call check_func,dm_task_set_cookie,/usr/include/libdevmapper.h),
> 0)
>         CFLAGS += -DLIBDM_API_COOKIE
>  endif
> +ifneq ($(call check_func,major,/usr/include/sys/sysmacros.h),0)
> +       CFLAGS += -DHAVE_SYS_SYSMACROS_H
> +endif
> +
>
>  OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o sun.o \
>         gpt.o mac.o ps3.o crc32.o lopart.o xstrncpy.o devmapper.o
> diff --git a/kpartx/sysmacros.h b/kpartx/sysmacros.h
> index 171b33d4..dc5077ec 100644
> --- a/kpartx/sysmacros.h
> +++ b/kpartx/sysmacros.h
> @@ -1,5 +1,10 @@
>  /* versions to be used with > 16-bit dev_t - leave unused for now */
>
> +#ifdef HAVE_SYS_SYSMACROS_H
> +#include <sys/sysmacros.h>
> +#else
> +#include <sys/types.h>
> +
>  #ifndef major
>  #define major(dev)     ((dev) >> 8)
>  #endif
> @@ -7,3 +12,4 @@
>  #ifndef minor
>  #define minor(dev)     ((dev) & 0xff)
>  #endif
> +#endif
> --
> 2.12.2
>
>

--001a113e1f54c238a2054fbfc1cf
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">This patch is dropped, due to Martin&#39;s=C2=A08b9cda51f5=
c64bc869188ca0b2e1ac0e7eb7c667 patch switching to sys/sysmacros.h<div><br><=
/div><div>Otherwise, the rest of the set is now merged.</div><div>Thanks.</=
div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Wed,=
 May 17, 2017 at 5:43 PM, Bart Van Assche <span dir=3D"ltr">&lt;<a href=3D"=
mailto:bart.vanassche@sandisk.com" target=3D"_blank">bart.vanassche@sandisk=
.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Avoid that bui=
lding against glibc &gt;=3D 2.25 triggers the following<br>
compiler warning:<br>
<br>
lopart.c: In function &#39;is_loop_device&#39;:<br>
lopart.c:93:13: warning: In the GNU C Library, &quot;major&quot; is defined=
<br>
=C2=A0by &lt;sys/sysmacros.h&gt;. For historical compatibility, it is<br>
=C2=A0currently defined by &lt;sys/types.h&gt; as well, but we plan to<br>
=C2=A0remove this soon. To use &quot;major&quot;, include &lt;sys/sysmacros=
.h&gt;<br>
=C2=A0directly. If you did not intend to use a system-defined macro<br>
=C2=A0&quot;major&quot;, you should undefine it after including &lt;sys/typ=
es.h&gt;.<br>
=C2=A0 =C2=A0major(statbuf.st_rdev) =3D=3D loopmajor);<br>
<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com">bart.vanassche@sandisk.com</a>&gt;<br>
---<br>
=C2=A0kpartx/Makefile=C2=A0 =C2=A0 | 4 ++++<br>
=C2=A0kpartx/sysmacros.h | 6 ++++++<br>
=C2=A02 files changed, 10 insertions(+)<br>
<br>
diff --git a/kpartx/Makefile b/kpartx/Makefile<br>
index 9441a2ba..2d2a249e 100644<br>
--- a/kpartx/Makefile<br>
+++ b/kpartx/Makefile<br>
@@ -10,6 +10,10 @@ LIBDEPS +=3D -ldevmapper<br>
=C2=A0ifneq ($(call check_func,dm_task_set_cookie,<wbr>/usr/include/libdevm=
apper.h),<wbr>0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CFLAGS +=3D -DLIBDM_API_COOKIE<br>
=C2=A0endif<br>
+ifneq ($(call check_func,major,/usr/include/<wbr>sys/sysmacros.h),0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0CFLAGS +=3D -DHAVE_SYS_SYSMACROS_H<br>
+endif<br>
+<br>
<br>
=C2=A0OBJS =3D bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o sun.o \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 gpt.o mac.o ps3.o crc32.o lopart.o xstrncpy.o d=
evmapper.o<br>
diff --git a/kpartx/sysmacros.h b/kpartx/sysmacros.h<br>
index 171b33d4..dc5077ec 100644<br>
--- a/kpartx/sysmacros.h<br>
+++ b/kpartx/sysmacros.h<br>
@@ -1,5 +1,10 @@<br>
=C2=A0/* versions to be used with &gt; 16-bit dev_t - leave unused for now =
*/<br>
<br>
+#ifdef HAVE_SYS_SYSMACROS_H<br>
+#include &lt;sys/sysmacros.h&gt;<br>
+#else<br>
+#include &lt;sys/types.h&gt;<br>
+<br>
=C2=A0#ifndef major<br>
=C2=A0#define major(dev)=C2=A0 =C2=A0 =C2=A0((dev) &gt;&gt; 8)<br>
=C2=A0#endif<br>
@@ -7,3 +12,4 @@<br>
=C2=A0#ifndef minor<br>
=C2=A0#define minor(dev)=C2=A0 =C2=A0 =C2=A0((dev) &amp; 0xff)<br>
=C2=A0#endif<br>
+#endif<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.12.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a113e1f54c238a2054fbfc1cf--


--===============7678724341187732700==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7678724341187732700==--
