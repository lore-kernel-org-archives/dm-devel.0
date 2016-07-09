From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: document uid_attribute for
	scsi and dasd devices
Date: Sat, 9 Jul 2016 10:03:04 +0200
Message-ID: <CABr-Gnf1f9=-1JgeP_5=dapoi5yTjk3V3gCwRENEC-CPbTqOVQ@mail.gmail.com>
References: <1468015308-4063-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6532468514512657420=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468015308-4063-1-git-send-email-xose.vazquez@gmail.com>
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

--===============6532468514512657420==
Content-Type: multipart/alternative; boundary=001a113fb59c4c713205372f59af

--001a113fb59c4c713205372f59af
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Sat, Jul 9, 2016 at 12:01 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Default for SCSI devices is ID_SERIAL, a standard udev variable.
> Default for DASD devices is ID_UID, returned by dasdinfo from 390-tools
> package.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipath/multipath.conf.5 | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 794275e..709ab3c 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -191,7 +191,9 @@ Default value is: \fBfailover\fR
>  The udev attribute providing a unique path identifier.
>  .RS
>  .TP
> -Default value is: \fBID_SERIAL\fR
> +Default value is: \fBID_SERIAL\fR for SCSI devices
> +.TP
> +Default value is: \fBID_UID\fR for DASD devices
>  .RE
>  .TP
>  .B getuid_callout
> --
> 2.7.4
>
>

--001a113fb59c4c713205372f59af
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Sat, Jul 9, 2016 at 12:01 AM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">Default for SCSI devices is ID_SERIAL, a standard udev v=
ariable.<br>
Default for DASD devices is ID_UID, returned by dasdinfo from 390-tools pac=
kage.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0multipath/multipath.conf.5 | 4 +++-<br>
=C2=A01 file changed, 3 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 794275e..709ab3c 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -191,7 +191,9 @@ Default value is: \fBfailover\fR<br>
=C2=A0The udev attribute providing a unique path identifier.<br>
=C2=A0.RS<br>
=C2=A0.TP<br>
-Default value is: \fBID_SERIAL\fR<br>
+Default value is: \fBID_SERIAL\fR for SCSI devices<br>
+.TP<br>
+Default value is: \fBID_UID\fR for DASD devices<br>
=C2=A0.RE<br>
=C2=A0.TP<br>
=C2=A0.B getuid_callout<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a113fb59c4c713205372f59af--


--===============6532468514512657420==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6532468514512657420==--
