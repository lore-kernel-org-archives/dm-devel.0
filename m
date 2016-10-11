From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: uxsock_timeout should be
 assigned by conf->uxsock_timeout
Date: Tue, 11 Oct 2016 08:45:16 +0200
Message-ID: <CABr-GnfFPyLkDJePE7TgPtjRBmNvyDncZDAGA7tizRPV+dk_PQ@mail.gmail.com>
References: <1473761329-8712-1-git-send-email-tang.junhui@zte.com.cn>
	<OF78C25DBE.68C1AA2B-ON48258049.0024B703-48258049.0024E27C@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0892030712394547672=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF78C25DBE.68C1AA2B-ON48258049.0024B703-48258049.0024E27C@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, zhang.kai16@zte.com.cn
List-Id: dm-devel.ids

--===============0892030712394547672==
Content-Type: multipart/alternative; boundary=001a113f18862f7843053e9138e1

--001a113f18862f7843053e9138e1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Good,
Merged.

On Tue, Oct 11, 2016 at 8:42 AM, <tang.junhui@zte.com.cn> wrote:

> Please have a review for this patch, any comment will be highly
> appreciated.
>
>
>
>
> =E5=8F=91=E4=BB=B6=E4=BA=BA:         tang.junhui@zte.com.cn
> =E6=94=B6=E4=BB=B6=E4=BA=BA:         christophe varoqui <christophe.varoq=
ui@free.fr>,
> =E6=8A=84=E9=80=81:        zhang.kai16@zte.com.cn, dm-devel@redhat.com, "=
tang.junhui" <
> tang.junhui@zte.com.cn>
> =E6=97=A5=E6=9C=9F:         2016/09/13 18:17
> =E4=B8=BB=E9=A2=98:        [dm-devel] [PATCH] multipathd: uxsock_timeout =
should be
> assigned by        conf->uxsock_timeout
> =E5=8F=91=E4=BB=B6=E4=BA=BA:        dm-devel-bounces@redhat.com
> ------------------------------
>
>
>
> From: "tang.junhui" <tang.junhui@zte.com.cn>
>
> uxsock_timeout should be assigned by conf->uxsock_timeout
> before using it in uxclnt() as a CLI client timeout value,
> otherwise its default value is 0, and the CLI client timeout
> value is 0 + 100(ms), so the CLI client will be timeout very
> quickly.
>
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
> multipathd/main.c | 2 ++
> 1 file changed, 2 insertions(+)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 96ef01f..a08f1a5 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2549,6 +2549,7 @@ main (int argc, char *argv[])
>
> exit(1);
>                                                    if (verbosity)
>
> conf->verbosity =3D verbosity;
> +                                                   uxsock_timeout =3D
> conf->uxsock_timeout;
>                                                    uxclnt(optarg,
> uxsock_timeout + 100);
>                                                    exit(0);
>                                   case 'B':
> @@ -2573,6 +2574,7 @@ main (int argc, char *argv[])
>                                                    exit(1);
>                                   if (verbosity)
>                                                    conf->verbosity =3D
> verbosity;
> +                                  uxsock_timeout =3D conf->uxsock_timeou=
t;
>                                   memset(cmd, 0x0, CMDSIZE);
>                                   while (optind < argc) {
>                                                    if
> (strchr(argv[optind], ' '))
> --
> 2.8.1.windows.1
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>

--001a113f18862f7843053e9138e1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Good,<div>Merged.</div></div><div class=3D"gmail_extra"><b=
r><div class=3D"gmail_quote">On Tue, Oct 11, 2016 at 8:42 AM,  <span dir=3D=
"ltr">&lt;<a href=3D"mailto:tang.junhui@zte.com.cn" target=3D"_blank">tang.=
junhui@zte.com.cn</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><=
font size=3D"2">Please have a review</font><font size=3D"2" face=3D"sans-se=
rif">
for this patch, any comment will be highly appreciated.</font><font size=3D=
"2" face=3D"sans-serif"><br>
</font>
<br>
<br>
<br>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E5=8F=91=E4=BB=
=B6=E4=BA=BA: =C2=A0 =C2=A0
=C2=A0 =C2=A0 </font><font size=3D"1" face=3D"sans-serif"><a href=3D"mailto=
:tang.junhui@zte.com.cn" target=3D"_blank">tang.junhui@zte.com.cn</a></font=
>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E6=94=B6=E4=BB=
=B6=E4=BA=BA: =C2=A0 =C2=A0
=C2=A0 =C2=A0 </font><font size=3D"1" face=3D"sans-serif">christophe
varoqui &lt;<a href=3D"mailto:christophe.varoqui@free.fr" target=3D"_blank"=
>christophe.varoqui@free.fr</a>&gt;, </font>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E6=8A=84=E9=80=
=81: =C2=A0 =C2=A0
=C2=A0 =C2=A0</font><font size=3D"1" face=3D"sans-serif"><a href=3D"mailto:=
zhang.kai16@zte.com.cn" target=3D"_blank">zhang.kai16@zte.com.cn</a>,
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a>, &quot;tang.junhui&quot; &lt;<a href=3D"mailto:tang.junhui@zte.com.cn=
" target=3D"_blank">tang.junhui@zte.com.cn</a>&gt;</font>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E6=97=A5=E6=9C=
=9F: =C2=A0 =C2=A0
=C2=A0 =C2=A0 </font><font size=3D"1" face=3D"sans-serif">2016/09/13
18:17</font>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E4=B8=BB=E9=A2=
=98: =C2=A0 =C2=A0
=C2=A0 =C2=A0</font><font size=3D"1" face=3D"sans-serif">[dm-devel] [PATCH]
multipathd: uxsock_timeout should be assigned by =C2=A0 =C2=A0 =C2=A0 =C2=
=A0conf-&gt;uxsock_timeout</font>
<br><font size=3D"1" color=3D"#5f5f5f" face=3D"sans-serif">=E5=8F=91=E4=BB=
=B6=E4=BA=BA: =C2=A0 =C2=A0
=C2=A0 =C2=A0</font><font size=3D"1" face=3D"sans-serif"><a href=3D"mailto:=
dm-devel-bounces@redhat.com" target=3D"_blank">dm-devel-bounces@redhat.com<=
/a></font>
<br>
<hr noshade><div class=3D"HOEnZb"><div class=3D"h5">
<br>
<br>
<br><tt><font size=3D"2">From: &quot;tang.junhui&quot; &lt;<a href=3D"mailt=
o:tang.junhui@zte.com.cn" target=3D"_blank">tang.junhui@zte.com.cn</a>&gt;<=
br>
<br>
uxsock_timeout should be assigned by conf-&gt;uxsock_timeout<br>
before using it in uxclnt() as a CLI client timeout value,<br>
otherwise its default value is 0, and the CLI client timeout<br>
value is 0 + 100(ms), so the CLI client will be timeout very<br>
quickly.<br>
<br>
Signed-off-by: tang.junhui &lt;<a href=3D"mailto:tang.junhui@zte.com.cn" ta=
rget=3D"_blank">tang.junhui@zte.com.cn</a>&gt;<br>
---<br>
 multipathd/main.c | 2 ++<br>
 1 file changed, 2 insertions(+)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 96ef01f..a08f1a5 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -2549,6 +2549,7 @@ main (int argc, char *argv[])<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
exit(1);<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if
(verbosity)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
conf-&gt;verbosity =3D verbosity;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
uxsock_timeout =3D conf-&gt;uxsock_timeout;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uxclnt(optarg=
,
uxsock_timeout + 100);<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit(0);<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
case &#39;B&#39;:<br>
@@ -2573,6 +2574,7 @@ main (int argc, char *argv[])<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit(1);<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
if (verbosity)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;verb=
osity
=3D verbosity;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uxsock_timeou=
t
=3D conf-&gt;uxsock_timeout;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
memset(cmd, 0x0, CMDSIZE);<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
while (optind &lt; argc) {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if
(strchr(argv[optind], &#39; &#39;))<br>
-- <br>
2.8.1.windows.1<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
</font></tt><a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" ta=
rget=3D"_blank"><tt><font size=3D"2">https://www.redhat.com/<wbr>mailman/li=
stinfo/dm-devel</font></tt></a><tt><font size=3D"2"><br>
</font></tt>
<br>
</div></div></blockquote></div><br></div>

--001a113f18862f7843053e9138e1--


--===============0892030712394547672==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0892030712394547672==--
