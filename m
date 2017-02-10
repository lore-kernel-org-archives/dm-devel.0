From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Include sys/sysmacros.h
Date: Fri, 10 Feb 2017 15:41:46 +0100
Message-ID: <CABr-Gnc6hPCKZrY4OdS3BVsx2PuMuNUKti+VkAFjVHiPGAQtxA@mail.gmail.com>
References: <CACqULmPQdDPnHkM701=XJ1qSc8y87-6Fb=kbvEGGeHyrrBXvEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3461776691448887755=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACqULmPQdDPnHkM701=XJ1qSc8y87-6Fb=kbvEGGeHyrrBXvEg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Anthony Ryan <anthonyryan1@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3461776691448887755==
Content-Type: multipart/alternative; boundary=94eb2c047d4add991f05482e18cd

--94eb2c047d4add991f05482e18cd
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Wed, Jan 4, 2017 at 5:34 AM, Anthony Ryan <anthonyryan1@gmail.com> wrote:

> The major, minor & makedev macros are not supposed to be included
> with sys/types.h but glibc has done this against POSIX standards.
>
> Alternative libcs aren't able to be used because of this and glibc
> has expressed interest in correcting this behaviour in a future
> release.
> ---
>  kpartx/dasd.c               | 1 +
>  kpartx/kpartx.c             | 1 +
>  libmultipath/checkers/tur.c | 1 +
>  libmultipath/devmapper.c    | 1 +
>  libmultipath/util.c         | 1 +
>  5 files changed, 5 insertions(+)
>
> diff --git a/kpartx/dasd.c b/kpartx/dasd.c
> index 1206e45..f50c1bd 100644
> --- a/kpartx/dasd.c
> +++ b/kpartx/dasd.c
> @@ -28,6 +28,7 @@
>  #include <inttypes.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> +#include <sys/sysmacros.h>
>  #include <sys/ioctl.h>
>  #include <linux/hdreg.h>
>  #include <errno.h>
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index d31fea8..3452787 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -28,6 +28,7 @@
>  #include <stdint.h>
>  #include <sys/ioctl.h>
>  #include <sys/stat.h>
> +#include <sys/sysmacros.h>
>  #include <sys/types.h>
>  #include <ctype.h>
>  #include <libdevmapper.h>
> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index 4d6c3c2..d9a9e67 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -11,6 +11,7 @@
>  #include <unistd.h>
>  #include <fcntl.h>
>  #include <sys/ioctl.h>
> +#include <sys/sysmacros.h>
>  #include <errno.h>
>  #include <sys/time.h>
>  #include <pthread.h>
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 4f8ef13..9c0b240 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -12,6 +12,7 @@
>  #include <ctype.h>
>  #include <unistd.h>
>  #include <errno.h>
> +#include <sys/sysmacros.h>
>
>  #include "checkers.h"
>  #include "vector.h"
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index 03a5738..1841f35 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -4,6 +4,7 @@
>  #include <pthread.h>
>  #include <string.h>
>  #include <sys/stat.h>
> +#include <sys/sysmacros.h>
>  #include <sys/types.h>
>  #include <unistd.h>
>
> --
> 2.11.0
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--94eb2c047d4add991f05482e18cd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Wed, Jan 4, 2017 at 5:34 AM, Anthony Rya=
n <span dir=3D"ltr">&lt;<a href=3D"mailto:anthonyryan1@gmail.com" target=3D=
"_blank">anthonyryan1@gmail.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">The major, minor &amp; makedev macros are not supposed to be =
included<br>
with sys/types.h but glibc has done this against POSIX standards.<br>
<br>
Alternative libcs aren&#39;t able to be used because of this and glibc<br>
has expressed interest in correcting this behaviour in a future<br>
release.<br>
---<br>
=C2=A0kpartx/dasd.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
 1 +<br>
=C2=A0kpartx/kpartx.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 1 +<=
br>
=C2=A0libmultipath/checkers/tur.c | 1 +<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0 | 1 +<br>
=C2=A0libmultipath/util.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 1 +<br>
=C2=A05 files changed, 5 insertions(+)<br>
<br>
diff --git a/kpartx/dasd.c b/kpartx/dasd.c<br>
index 1206e45..f50c1bd 100644<br>
--- a/kpartx/dasd.c<br>
+++ b/kpartx/dasd.c<br>
@@ -28,6 +28,7 @@<br>
=C2=A0#include &lt;inttypes.h&gt;<br>
=C2=A0#include &lt;sys/types.h&gt;<br>
=C2=A0#include &lt;sys/stat.h&gt;<br>
+#include &lt;sys/sysmacros.h&gt;<br>
=C2=A0#include &lt;sys/ioctl.h&gt;<br>
=C2=A0#include &lt;linux/hdreg.h&gt;<br>
=C2=A0#include &lt;errno.h&gt;<br>
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c<br>
index d31fea8..3452787 100644<br>
--- a/kpartx/kpartx.c<br>
+++ b/kpartx/kpartx.c<br>
@@ -28,6 +28,7 @@<br>
=C2=A0#include &lt;stdint.h&gt;<br>
=C2=A0#include &lt;sys/ioctl.h&gt;<br>
=C2=A0#include &lt;sys/stat.h&gt;<br>
+#include &lt;sys/sysmacros.h&gt;<br>
=C2=A0#include &lt;sys/types.h&gt;<br>
=C2=A0#include &lt;ctype.h&gt;<br>
=C2=A0#include &lt;libdevmapper.h&gt;<br>
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c<br>
index 4d6c3c2..d9a9e67 100644<br>
--- a/libmultipath/checkers/tur.c<br>
+++ b/libmultipath/checkers/tur.c<br>
@@ -11,6 +11,7 @@<br>
=C2=A0#include &lt;unistd.h&gt;<br>
=C2=A0#include &lt;fcntl.h&gt;<br>
=C2=A0#include &lt;sys/ioctl.h&gt;<br>
+#include &lt;sys/sysmacros.h&gt;<br>
=C2=A0#include &lt;errno.h&gt;<br>
=C2=A0#include &lt;sys/time.h&gt;<br>
=C2=A0#include &lt;pthread.h&gt;<br>
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c<br>
index 4f8ef13..9c0b240 100644<br>
--- a/libmultipath/devmapper.c<br>
+++ b/libmultipath/devmapper.c<br>
@@ -12,6 +12,7 @@<br>
=C2=A0#include &lt;ctype.h&gt;<br>
=C2=A0#include &lt;unistd.h&gt;<br>
=C2=A0#include &lt;errno.h&gt;<br>
+#include &lt;sys/sysmacros.h&gt;<br>
<br>
=C2=A0#include &quot;checkers.h&quot;<br>
=C2=A0#include &quot;vector.h&quot;<br>
diff --git a/libmultipath/util.c b/libmultipath/util.c<br>
index 03a5738..1841f35 100644<br>
--- a/libmultipath/util.c<br>
+++ b/libmultipath/util.c<br>
@@ -4,6 +4,7 @@<br>
=C2=A0#include &lt;pthread.h&gt;<br>
=C2=A0#include &lt;string.h&gt;<br>
=C2=A0#include &lt;sys/stat.h&gt;<br>
+#include &lt;sys/sysmacros.h&gt;<br>
=C2=A0#include &lt;sys/types.h&gt;<br>
=C2=A0#include &lt;unistd.h&gt;<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.11.0<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br>
</font></span></blockquote></div><br></div>

--94eb2c047d4add991f05482e18cd--


--===============3461776691448887755==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3461776691448887755==--
