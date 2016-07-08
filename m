From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipah: fix 'multipath -p' with invalid
	policy
Date: Fri, 8 Jul 2016 09:57:31 +0200
Message-ID: <CABr-Gnd74jEErxhNsbqiBq5hNhVMHRzaBPhLR9ipC9p1jucw5w@mail.gmail.com>
References: <OFEF0477A6.E2A8E55E-ON48257FE8.001271D0-48257FE8.0022DD1A@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3620326631624172763=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OFEF0477A6.E2A8E55E-ON48257FE8.001271D0-48257FE8.0022DD1A@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: zhang.kai16@zte.com.cn
Cc: device-mapper development <dm-devel@redhat.com>, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

--===============3620326631624172763==
Content-Type: multipart/alternative; boundary=001a114b1574a5d25105371b2743

--001a114b1574a5d25105371b2743
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Merged.

For your information,
- the patches you send are not applicable through git am.
- please don't use my @free.fr email address. You can use @opensvc.com
instead.

Thanks.

On Wed, Jul 6, 2016 at 8:21 AM, <zhang.kai16@zte.com.cn> wrote:

> hi,
>
> When we excute 'multipath -p' with invalid policy, get_pgpolicy_id()
> returns IOPOLICY_UNDEF.
> We should compare conf->pgpolicy_flag with IOPOLICY_UNDEF, otherwise, it
> couldn't get what we want.
>
>
>  ---
> multipath/main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/multipath/main.c b/multipath/main.c
> index c33f689..af7cf5b 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -532,7 +532,7 @@ main (int argc, char *argv[])
>                                                    break;
>                                   case 'p':
>                                                    conf->pgpolicy_flag =
=3D
> get_pgpolicy_id(optarg);
> -                                                   if
> (conf->pgpolicy_flag =3D=3D -1) {
> +                                                   if
> (conf->pgpolicy_flag =3D=3D IOPOLICY_UNDEF) {
>
> printf("'%s' is not a valid policy\n", optarg);
>
> usage(argv[0]);
>
> exit(1);
> --
> 1.9.1
>
>
>
>
> --------------------------------------------------------
> ZTE Information Security Notice: The information contained in this mail (=
and any attachment transmitted herewith) is privileged and confidential and=
 is intended for the exclusive use of the addressee(s).  If you are not an =
intended recipient, any disclosure, reproduction, distribution or other dis=
semination or use of the information contained is strictly prohibited.  If =
you have received this mail in error, please delete it and notify us immedi=
ately.
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a114b1574a5d25105371b2743
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div><br></div><div>For your information,</div><div=
>- the patches you send are not applicable through git am.</div><div>- plea=
se don&#39;t use my @<a href=3D"http://free.fr">free.fr</a> email address. =
You can use @<a href=3D"http://opensvc.com">opensvc.com</a> instead.</div><=
div><br></div><div>Thanks.</div></div><div class=3D"gmail_extra"><br><div c=
lass=3D"gmail_quote">On Wed, Jul 6, 2016 at 8:21 AM,  <span dir=3D"ltr">&lt=
;<a href=3D"mailto:zhang.kai16@zte.com.cn" target=3D"_blank">zhang.kai16@zt=
e.com.cn</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><font si=
ze=3D"2" face=3D"sans-serif">hi,</font>
<br>
<br><font size=3D"2" face=3D"sans-serif">When we excute &#39;multipath -p&#=
39; with invalid
policy, get_pgpolicy_id() returns IOPOLICY_UNDEF. </font>
<br><font size=3D"2" face=3D"sans-serif">We should compare conf-&gt;pgpolic=
y_flag
with IOPOLICY_UNDEF, otherwise, it couldn&#39;t get what we want.</font>
<br><font size=3D"2" face=3D"sans-serif"><br>
</font>
<br><font size=3D"2">=C2=A0</font><tt><font size=3D"2">---<br>
 multipath/main.c | 2 +-<br>
 1 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/multipath/main.c b/multipath/main.c<br>
index c33f689..af7cf5b 100644<br>
--- a/multipath/main.c<br>
+++ b/multipath/main.c<br>
@@ -532,7 +532,7 @@ main (int argc, char *argv[])<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
case &#39;p&#39;:<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;pgpo=
licy_flag
=3D get_pgpolicy_id(optarg);<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
if (conf-&gt;pgpolicy_flag =3D=3D -1) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
if (conf-&gt;pgpolicy_flag =3D=3D IOPOLICY_UNDEF) {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
printf(&quot;&#39;%s&#39; is not a valid policy\n&quot;, optarg);<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
usage(argv[0]);<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
exit(1);<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-- <br>
1.9.1</font></span></font></tt><span class=3D"HOEnZb"><font color=3D"#88888=
8"><tt><font size=3D"3"><br>
</font></tt>
<br>
<br>

<br><pre><font color=3D"blue">
--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (an=
d any attachment transmitted herewith) is privileged and confidential and i=
s intended for the exclusive use of the addressee(s).  If you are not an in=
tended recipient, any disclosure, reproduction, distribution or other disse=
mination or use of the information contained is strictly prohibited.  If yo=
u have received this mail in error, please delete it and notify us immediat=
ely.

</font></pre><br>
</font></span><br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br></blockquote></div><br></div>

--001a114b1574a5d25105371b2743--


--===============3620326631624172763==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3620326631624172763==--
