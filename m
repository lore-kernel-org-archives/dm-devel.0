From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Makefile.inc: Remove -fexceptions from CFLAGS
Date: Mon, 29 Aug 2016 09:20:16 +0200
Message-ID: <CABr-GnfP0O1npZkL4sR6AmocdRgBNqYec8gPK-O3LoO0HaFtYQ@mail.gmail.com>
References: <e832fbcf-dde0-5b84-980a-cd0745d027c6@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2553291167158823473=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e832fbcf-dde0-5b84-980a-cd0745d027c6@sandisk.com>
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

--===============2553291167158823473==
Content-Type: multipart/alternative; boundary=001a114002f828b591053b30b218

--001a114002f828b591053b30b218
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Tue, Aug 16, 2016 at 9:56 PM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> No code in the multipath-tools project calls a C++ function that
> generates an exception. Hence remove -fexceptions. From the gcc
> manual:
>
> -fexceptions
>
>   Enable exception handling. Generates extra code needed to
>   propagate exceptions. For some targets, this implies GCC
>   generates frame unwind information for all functions, which can
>   produce significant data size overhead, although it does not
>   affect execution. If you do not specify this option, GCC
>   enables it by default for languages like C++ that normally
>   require exception handling, and disables it for languages like
>   C that do not normally require it. However, you may need to
>   enable this option when compiling C code that needs to
>   interoperate properly with exception handlers written in
>   C++. You may also wish to disable this option if you are
>   compiling older C++ programs that don't use exception handling.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  Makefile.inc | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile.inc b/Makefile.inc
> index 0808e64..0631ca2 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -61,7 +61,7 @@ LN            = ln -sf
>  INSTALL_PROGRAM        = install
>
>  OPTFLAGS       = -Wunused -Wstrict-prototypes -O2 -g -pipe
> -Wformat-security -Wall \
> -                 -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector
> --param=ssp-buffer-size=4
> +                 -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector
> --param=ssp-buffer-size=4
>
>  CFLAGS         = $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\"
> -DRUN_DIR=\"${RUN}\"
>  SHARED_FLAGS   = -shared
> --
> 2.9.2
>
>

--001a114002f828b591053b30b218
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Aug 16, 2016 at 9:56 PM, Bart Van As=
sche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandisk.com" ta=
rget=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<br><blockq=
uote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc =
solid;padding-left:1ex">No code in the multipath-tools project calls a C++ =
function that<br>
generates an exception. Hence remove -fexceptions. From the gcc<br>
manual:<br>
<br>
-fexceptions<br>
<br>
=C2=A0 Enable exception handling. Generates extra code needed to<br>
=C2=A0 propagate exceptions. For some targets, this implies GCC<br>
=C2=A0 generates frame unwind information for all functions, which can<br>
=C2=A0 produce significant data size overhead, although it does not<br>
=C2=A0 affect execution. If you do not specify this option, GCC<br>
=C2=A0 enables it by default for languages like C++ that normally<br>
=C2=A0 require exception handling, and disables it for languages like<br>
=C2=A0 C that do not normally require it. However, you may need to<br>
=C2=A0 enable this option when compiling C code that needs to<br>
=C2=A0 interoperate properly with exception handlers written in<br>
=C2=A0 C++. You may also wish to disable this option if you are<br>
=C2=A0 compiling older C++ programs that don&#39;t use exception handling.<=
br>
<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com">bart.vanassche@sandisk.com</a>&gt;<br>
---<br>
=C2=A0Makefile.inc | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/Makefile.inc b/Makefile.inc<br>
index 0808e64..0631ca2 100644<br>
--- a/Makefile.inc<br>
+++ b/Makefile.inc<br>
@@ -61,7 +61,7 @@ LN=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D ln -sf<br=
>
=C2=A0INSTALL_PROGRAM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D install<br>
<br>
=C2=A0OPTFLAGS=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D -Wunused -Wstrict-prototypes -=
O2 -g -pipe -Wformat-security -Wall \<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-Wp,-D_FORTI=
FY_SOURCE=3D2 -fexceptions -fstack-protector --param=3Dssp-buffer-size=3D4<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-Wp,-D_FORTI=
FY_SOURCE=3D2 -fstack-protector --param=3Dssp-buffer-size=3D4<br>
<br>
=C2=A0CFLAGS=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D $(OPTFLAGS) -fPIC -DLIB_S=
TRING=3D\&quot;${LIB}\&quot; -DRUN_DIR=3D\&quot;${RUN}\&quot;<br>
=C2=A0SHARED_FLAGS=C2=A0 =C2=A0=3D -shared<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.9.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a114002f828b591053b30b218--


--===============2553291167158823473==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2553291167158823473==--
