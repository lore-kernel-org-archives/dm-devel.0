From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: update bl info for nvme in
	multipath.conf.5
Date: Sun, 20 Nov 2016 14:24:37 +0100
Message-ID: <CABr-Gnc=teESLQaVNDtsOH9pQFsH1Bcyi_jpXT1tCygq18tQiQ@mail.gmail.com>
References: <20161116162021.3525-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7051035166569165761=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161116162021.3525-1-xose.vazquez@gmail.com>
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

--===============7051035166569165761==
Content-Type: multipart/alternative; boundary=001a113ebff80102080541bb7686

--001a113ebff80102080541bb7686
Content-Type: text/plain; charset=UTF-8

Applied,
thanks.

On Wed, Nov 16, 2016 at 5:20 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipath/multipath.conf.5 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index f8e413c..fb2bc5b 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -873,7 +873,7 @@ The following keywords are recognized:
>  Regular expression of the device nodes to be excluded.
>  .RS
>  .TP
> -Default value is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]\fR,
> \fB^(td|hd|vd)[a-z]\fR and \fB^nvme\fR
> +Default value is: \fB^(ram|raw|loop|fd|md|dm-|
> sr|scd|st|dcssblk|nvme)[0-9]\fR and \fB^(td|hd|vd)[a-z]\fR
>  .RE
>  .TP
>  .B wwid
> --
> 2.10.2
>
>

--001a113ebff80102080541bb7686
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Wed, Nov 16, 2016 at 5:20 PM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe=
.varoqui@opensvc.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0multipath/multipath.conf.5 | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index f8e413c..fb2bc5b 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -873,7 +873,7 @@ The following keywords are recognized:<br>
=C2=A0Regular expression of the device nodes to be excluded.<br>
=C2=A0.RS<br>
=C2=A0.TP<br>
-Default value is: \fB^(ram|raw|loop|fd|md|dm-|<wbr>sr|scd|st|dcssblk)[0-9]=
\fR, \fB^(td|hd|vd)[a-z]\fR and \fB^nvme\fR<br>
+Default value is: \fB^(ram|raw|loop|fd|md|dm-|<wbr>sr|scd|st|dcssblk|nvme)=
[0-9]\<wbr>fR and \fB^(td|hd|vd)[a-z]\fR<br>
=C2=A0.RE<br>
=C2=A0.TP<br>
=C2=A0.B wwid<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a113ebff80102080541bb7686--


--===============7051035166569165761==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7051035166569165761==--
