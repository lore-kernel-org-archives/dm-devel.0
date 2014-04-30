From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Fix segfault when fast_io_fail_tmo is empty
 in config file.
Date: Wed, 30 Apr 2014 15:53:45 +0200
Message-ID: <CABr-GndQ8fg4-Ki=u8msEFU8R3=xA4BJArcn3mzM82QNCMJnkA@mail.gmail.com>
References: <1398846013-2601-1-git-send-email-jcastillo@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5249271363677904250=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1398846013-2601-1-git-send-email-jcastillo@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============5249271363677904250==
Content-Type: multipart/alternative; boundary=001a11c319388c138304f842e060

--001a11c319388c138304f842e060
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.


On Wed, Apr 30, 2014 at 10:20 AM, Jose Castillo <jcastillo@redhat.com>wrote:

> If the option "fast_io_fail_tmo" is specified in multipath.conf, without a
> value, the command 'multipathd reconfigure' segfaults.
> With the patch included here, multipathd returns "error parsing config
> file" and does not segfaults.
>
> Signed-off-by: Jose Castillo <jcastillo@redhat.com>
> ---
>  libmultipath/dict.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 9db4725..91d9b83 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -43,6 +43,9 @@ def_fast_io_fail_handler(vector strvec)
>         char * buff;
>
>         buff = set_value(strvec);
> +       if (!buff)
> +               return 1;
> +
>         if (strlen(buff) == 3 && !strcmp(buff, "off"))
>                 conf->fast_io_fail = MP_FAST_IO_FAIL_OFF;
>         else if (sscanf(buff, "%d", &conf->fast_io_fail) != 1 ||
> --
> 1.9.0
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11c319388c138304f842e060
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><br><div class=3D"gmail_quote">On Wed, Apr 30, 2014 at 10:20 AM, Jose =
Castillo <span dir=3D"ltr">&lt;<a href=3D"mailto:jcastillo@redhat.com" targ=
et=3D"_blank">jcastillo@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">If the option &quot;fast_io_fail_tmo&quot; i=
s specified in multipath.conf, without a value, the command &#39;multipathd=
 reconfigure&#39; segfaults.<br>

With the patch included here, multipathd returns &quot;error parsing config=
 file&quot; and does not segfaults.<br>
<br>
Signed-off-by: Jose Castillo &lt;<a href=3D"mailto:jcastillo@redhat.com">jc=
astillo@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/dict.c | 3 +++<br>
=C2=A01 file changed, 3 insertions(+)<br>
<br>
diff --git a/libmultipath/dict.c b/libmultipath/dict.c<br>
index 9db4725..91d9b83 100644<br>
--- a/libmultipath/dict.c<br>
+++ b/libmultipath/dict.c<br>
@@ -43,6 +43,9 @@ def_fast_io_fail_handler(vector strvec)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * buff;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 buff =3D set_value(strvec);<br>
+ =C2=A0 =C2=A0 =C2=A0 if (!buff)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (strlen(buff) =3D=3D 3 &amp;&amp; !strcmp(bu=
ff, &quot;off&quot;))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;fast_io_fa=
il =3D MP_FAST_IO_FAIL_OFF;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (sscanf(buff, &quot;%d&quot;, &amp;conf=
-&gt;fast_io_fail) !=3D 1 ||<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.9.0<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></span></blockquote></div><br></div>

--001a11c319388c138304f842e060--


--===============5249271363677904250==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5249271363677904250==--
