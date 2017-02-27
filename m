From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/2] Don't blacklist nvme
Date: Mon, 27 Feb 2017 06:37:54 +0100
Message-ID: <CABr-Gncn88-yNY7Zebu1RP5PMgdjCqMJuvCG0wLLv84hf31=-Q@mail.gmail.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6073420047843643204=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6073420047843643204==
Content-Type: multipart/alternative; boundary=94eb2c1924d225bbed05497c7b8e

--94eb2c1924d225bbed05497c7b8e
Content-Type: text/plain; charset=UTF-8

Applied.

On Tue, Feb 14, 2017 at 10:19 PM, Keith Busch <keith.busch@intel.com> wrote:

> These devices are mulitpath capable, and have been able to stack with
> dm-mpath since kernel 4.2.
>
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  libmultipath/blacklist.c   | 2 +-
>  multipath/multipath.conf.5 | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index 36af282..ee396e2 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -169,7 +169,7 @@ setup_default_blist (struct config * conf)
>         char * str;
>         int i;
>
> -       str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk|nvme)[0-
> 9]");
> +       str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]");
>         if (!str)
>                 return 1;
>         if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 7de8bc7..d6c6c52 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -943,7 +943,7 @@ The following keywords are recognized:
>  Regular expression of the device nodes to be excluded.
>  .RS
>  .TP
> -The default is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk|nvme)[0-9]\fR
> and \fB^(td|hd|vd)[a-z]\fR
> +The default is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]\fR
> and \fB^(td|hd|vd)[a-z]\fR
>  .RE
>  .TP
>  .B wwid
> --
> 2.5.5
>
>

--94eb2c1924d225bbed05497c7b8e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.</div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Tue, Feb 14, 2017 at 10:19 PM, Keith Busch <span dir=3D"lt=
r">&lt;<a href=3D"mailto:keith.busch@intel.com" target=3D"_blank">keith.bus=
ch@intel.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">These =
devices are mulitpath capable, and have been able to stack with<br>
dm-mpath since kernel 4.2.<br>
<br>
Signed-off-by: Keith Busch &lt;<a href=3D"mailto:keith.busch@intel.com">kei=
th.busch@intel.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/blacklist.c=C2=A0 =C2=A0| 2 +-<br>
=C2=A0multipath/multipath.conf.5 | 2 +-<br>
=C2=A02 files changed, 2 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c<br>
index 36af282..ee396e2 100644<br>
--- a/libmultipath/blacklist.c<br>
+++ b/libmultipath/blacklist.c<br>
@@ -169,7 +169,7 @@ setup_default_blist (struct config * conf)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * str;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^(ram|raw|loop|fd|md|<wbr>=
dm-|sr|scd|st|dcssblk|nvme)[0-<wbr>9]&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^(ram|raw|loop|fd|md|<wbr>=
dm-|sr|scd|st|dcssblk)[0-9]&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!str)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (store_ble(conf-&gt;blist_<wbr>devnode, str,=
 ORIGIN_DEFAULT))<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 7de8bc7..d6c6c52 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -943,7 +943,7 @@ The following keywords are recognized:<br>
=C2=A0Regular expression of the device nodes to be excluded.<br>
=C2=A0.RS<br>
=C2=A0.TP<br>
-The default is: \fB^(ram|raw|loop|fd|md|dm-|<wbr>sr|scd|st|dcssblk|nvme)[0=
-9]\<wbr>fR and \fB^(td|hd|vd)[a-z]\fR<br>
+The default is: \fB^(ram|raw|loop|fd|md|dm-|<wbr>sr|scd|st|dcssblk)[0-9]\f=
R and \fB^(td|hd|vd)[a-z]\fR<br>
=C2=A0.RE<br>
=C2=A0.TP<br>
=C2=A0.B wwid<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.5.5<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c1924d225bbed05497c7b8e--


--===============6073420047843643204==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6073420047843643204==--
