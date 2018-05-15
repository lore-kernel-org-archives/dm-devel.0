From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: fix error parsing
	"find_multipaths strict"
Date: Tue, 15 May 2018 14:58:24 +0200
Message-ID: <CABr-GneQ98mJLDPWV8qb4CVmpp3m4QA8YtEULpS=5Rbx6xkL7w@mail.gmail.com>
References: <20180515123244.6017-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0215935768436622305=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180515123244.6017-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0215935768436622305==
Content-Type: multipart/alternative; boundary="000000000000699f8c056c3e28a7"

--000000000000699f8c056c3e28a7
Content-Type: text/plain; charset="UTF-8"

Merged,
thanks.

On Tue, May 15, 2018 at 2:32 PM, Martin Wilck <mwilck@suse.com> wrote:

> If "find_multipaths strict" is set in multipath.conf, the error message
> "illegal value for find_multipaths: strict" is printed. This causes no
> functional problem, as "strict" happens to be the default, fallback
> value. It should be fixed nonetheless. FIND_MULTIPATHS_STRICT, having
> the highest numeric value, must be last in the enum.
>
> Fixes: c36f2f42 "libmultipath: change find_multipaths option to
> multi-value"
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index eb6a1788..e424b150 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -122,9 +122,9 @@ enum find_multipaths_states {
>         FIND_MULTIPATHS_UNDEF = YNU_UNDEF,
>         FIND_MULTIPATHS_OFF = YNU_NO,
>         FIND_MULTIPATHS_ON = _FIND_MULTIPATHS_F,
> -       FIND_MULTIPATHS_STRICT = _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_N,
>         FIND_MULTIPATHS_GREEDY = _FIND_MULTIPATHS_I,
>         FIND_MULTIPATHS_SMART = _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_I,
> +       FIND_MULTIPATHS_STRICT = _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_N,
>         __FIND_MULTIPATHS_LAST,
>  };
>
> --
> 2.16.3
>
>

--000000000000699f8c056c3e28a7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, May 15, 2018 at 2:32 PM, Martin Wilc=
k <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank=
">mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">I=
f &quot;find_multipaths strict&quot; is set in multipath.conf, the error me=
ssage<br>
&quot;illegal value for find_multipaths: strict&quot; is printed. This caus=
es no<br>
functional problem, as &quot;strict&quot; happens to be the default, fallba=
ck<br>
value. It should be fixed nonetheless. FIND_MULTIPATHS_STRICT, having<br>
the highest numeric value, must be last in the enum.<br>
<br>
Fixes: c36f2f42 &quot;libmultipath: change find_multipaths option to multi-=
value&quot;<br>
Signed-off-by: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@s=
use.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/structs.h | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/structs.h b/libmultipath/structs.h<br>
index eb6a1788..e424b150 100644<br>
--- a/libmultipath/structs.h<br>
+++ b/libmultipath/structs.h<br>
@@ -122,9 +122,9 @@ enum find_multipaths_states {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FIND_MULTIPATHS_UNDEF =3D YNU_UNDEF,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FIND_MULTIPATHS_OFF =3D YNU_NO,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FIND_MULTIPATHS_ON =3D _FIND_MULTIPATHS_F,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0FIND_MULTIPATHS_STRICT =3D _FIND_MULTIPATHS_F|_=
FIND_<wbr>MULTIPATHS_N,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FIND_MULTIPATHS_GREEDY =3D _FIND_MULTIPATHS_I,<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FIND_MULTIPATHS_SMART =3D _FIND_MULTIPATHS_F|_F=
IND_<wbr>MULTIPATHS_I,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0FIND_MULTIPATHS_STRICT =3D _FIND_MULTIPATHS_F|_=
FIND_<wbr>MULTIPATHS_N,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __FIND_MULTIPATHS_LAST,<br>
=C2=A0};<br>
<span class=3D"HOEnZb"><font color=3D"#888888">=C2=A0<br>
-- <br>
2.16.3<br>
<br>
</font></span></blockquote></div><br></div>

--000000000000699f8c056c3e28a7--


--===============0215935768436622305==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0215935768436622305==--
