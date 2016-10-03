From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: remove pointless ".*" from
	devnode blacklists
Date: Mon, 3 Oct 2016 18:05:40 +0200
Message-ID: <CABr-Gnff1NL5vs0oSURjyWOi6TAQ6Gfq1JGKVDg7Ase_sdL=kA@mail.gmail.com>
References: <20161003155320.17792-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8383558823333835372=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161003155320.17792-1-xose.vazquez@gmail.com>
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

--===============8383558823333835372==
Content-Type: multipart/alternative; boundary=001a11408126984c34053df81dce

--001a11408126984c34053df81dce
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Mon, Oct 3, 2016 at 5:53 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> ".*" is useless at the end of a regex, and just "*" is a bug.
> And document them.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/blacklist.c   | 8 ++++----
>  multipath/multipath.conf.5 | 6 +++++-
>  2 files changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index 9687399..aa8d975 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -172,7 +172,7 @@ setup_default_blist (struct config * conf)
>         char * str;
>         int i;
>
> -       str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*");
> +       str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]");
>         if (!str)
>                 return 1;
>         if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
> @@ -184,19 +184,19 @@ setup_default_blist (struct config * conf)
>         if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>                 return 1;
>
> -       str = STRDUP("^dcssblk[0-9]*");
> +       str = STRDUP("^dcssblk[0-9]");
>         if (!str)
>                 return 1;
>         if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>                 return 1;
>
> -       str = STRDUP("^nvme.*");
> +       str = STRDUP("^nvme");
>         if (!str)
>                 return 1;
>         if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>                 return 1;
>
> -       str = STRDUP("(SCSI_IDENT_.*|ID_WWN)");
> +       str = STRDUP("(SCSI_IDENT_|ID_WWN)");
>         if (!str)
>                 return 1;
>         if (store_ble(conf->elist_property, str, ORIGIN_DEFAULT))
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 7dd997a..7bb847a 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -849,6 +849,10 @@ The following keywords are recognized:
>  .TP 17
>  .B devnode
>  Regular expression of the device nodes to be excluded.
> +.RS
> +.TP
> +Default value is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]\fR,
> \fB^(td|hd|vd)[a-z]\fR, \fB^dcssblk[0-9]\fR and \fB^nvme\fR
> +.RE
>  .TP
>  .B wwid
>  The \fIWorld Wide Identification\fR of a device.
> @@ -888,7 +892,7 @@ The \fIWorld Wide Identification\fR of a device.
>  Regular expression of the udev property to be whitelisted.
>  .RS
>  .TP
> -Default value is: \fB(ID_WWN|SCSI_IDENT_.*)\fR
> +Default value is: \fB(SCSI_IDENT_|ID_WWN)\fR
>  .RE
>  .TP
>  .B device
> --
> 2.10.0
>
>

--001a11408126984c34053df81dce
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Oct 3, 2016 at 5:53 PM, Xose Vazquez=
 Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" targ=
et=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">&quot;.*&quot; is useless at the end of a regex, and just=
 &quot;*&quot; is a bug.<br>
And document them.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/blacklist.c=C2=A0 =C2=A0| 8 ++++----<br>
=C2=A0multipath/multipath.conf.5 | 6 +++++-<br>
=C2=A02 files changed, 9 insertions(+), 5 deletions(-)<br>
<br>
diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c<br>
index 9687399..aa8d975 100644<br>
--- a/libmultipath/blacklist.c<br>
+++ b/libmultipath/blacklist.c<br>
@@ -172,7 +172,7 @@ setup_default_blist (struct config * conf)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * str;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^(ram|raw|loop|fd|md|<wbr>=
dm-|sr|scd|st)[0-9]*&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^(ram|raw|loop|fd|md|<wbr>=
dm-|sr|scd|st)[0-9]&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!str)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (store_ble(conf-&gt;blist_<wbr>devnode, str,=
 ORIGIN_DEFAULT))<br>
@@ -184,19 +184,19 @@ setup_default_blist (struct config * conf)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (store_ble(conf-&gt;blist_<wbr>devnode, str,=
 ORIGIN_DEFAULT))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^dcssblk[0-9]*&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^dcssblk[0-9]&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!str)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (store_ble(conf-&gt;blist_<wbr>devnode, str,=
 ORIGIN_DEFAULT))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^nvme.*&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^nvme&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!str)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (store_ble(conf-&gt;blist_<wbr>devnode, str,=
 ORIGIN_DEFAULT))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;(SCSI_IDENT_.*|ID_WWN)<wbr=
>&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;(SCSI_IDENT_|ID_WWN)&quot;=
)<wbr>;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!str)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (store_ble(conf-&gt;elist_<wbr>property, str=
, ORIGIN_DEFAULT))<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 7dd997a..7bb847a 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -849,6 +849,10 @@ The following keywords are recognized:<br>
=C2=A0.TP 17<br>
=C2=A0.B devnode<br>
=C2=A0Regular expression of the device nodes to be excluded.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB^(ram|raw|loop|fd|md|dm-|<wbr>sr|scd|st)[0-9]\fR, \fB=
^(td|hd|vd)[a-z]\fR, \fB^dcssblk[0-9]\fR and \fB^nvme\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B wwid<br>
=C2=A0The \fIWorld Wide Identification\fR of a device.<br>
@@ -888,7 +892,7 @@ The \fIWorld Wide Identification\fR of a device.<br>
=C2=A0Regular expression of the udev property to be whitelisted.<br>
=C2=A0.RS<br>
=C2=A0.TP<br>
-Default value is: \fB(ID_WWN|SCSI_IDENT_.*)\fR<br>
+Default value is: \fB(SCSI_IDENT_|ID_WWN)\fR<br>
=C2=A0.RE<br>
=C2=A0.TP<br>
=C2=A0.B device<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.0<br>
<br>
</font></span></blockquote></div><br></div>

--001a11408126984c34053df81dce--


--===============8383558823333835372==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8383558823333835372==--
