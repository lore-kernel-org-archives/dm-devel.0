From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: tarballs are not generated
	anymore
Date: Thu, 2 Jun 2016 15:13:06 +0200
Message-ID: <CABr-GneO=Q_GQOngHN0tvdUCs-bcbdDY9S4OGiwtWuw-F_Y9cQ@mail.gmail.com>
References: <1464871629-5370-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9049018466273977571=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1464871629-5370-1-git-send-email-xose.vazquez@gmail.com>
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

--===============9049018466273977571==
Content-Type: multipart/alternative; boundary=001a11402104f1fd1a05344b5db0

--001a11402104f1fd1a05344b5db0
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Thu, Jun 2, 2016 at 2:47 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Add info how to get a specific release from git.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  README | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/README b/README
> index a81666c..25a194e 100644
> --- a/README
> +++ b/README
> @@ -1,5 +1,6 @@
>  multipath-tools for Linux <http://christophe.varoqui.free.fr/>
>
> +
>  This package provides the following binaries to drive the
>  Device Mapper multipathing driver:
>
> @@ -8,7 +9,15 @@ multipathd - Multipath daemon.
>  mpathpersist - Manages SCSI persistent reservations on dm multipath
> devices.
>  kpartx - Create device maps from partition tables.
>
> -To get latest code: git clone http://git.opensvc.com/multipath-tools/.git
> +
> +tarballs are not generated anymore, to get a specific release do:
> +git clone http://git.opensvc.com/multipath-tools/.git
> +cd multipath-tools
> +git tag
> +git archive --format=tar.gz --prefix=multipath-tools-X.Y.Z/ X.Y.Z >
> ../multipath-tools-X.Y.Z.tar.gz
> +
> +
> +To get latest devel code: git clone
> http://git.opensvc.com/multipath-tools/.git
>
>  Mailing list: http://www.redhat.com/mailman/listinfo/dm-devel
>  Gitweb: http://git.opensvc.com/?p=multipath-tools/.git
> --
> 2.5.5
>
>

--001a11402104f1fd1a05344b5db0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Thu, Jun 2, 2016 at 2:47 PM, Xose Vazquez=
 Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" targ=
et=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">Add info how to get a specific release from git.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0README | 11 ++++++++++-<br>
=C2=A01 file changed, 10 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/README b/README<br>
index a81666c..25a194e 100644<br>
--- a/README<br>
+++ b/README<br>
@@ -1,5 +1,6 @@<br>
=C2=A0multipath-tools for Linux &lt;<a href=3D"http://christophe.varoqui.fr=
ee.fr/" rel=3D"noreferrer" target=3D"_blank">http://christophe.varoqui.free=
.fr/</a>&gt;<br>
<br>
+<br>
=C2=A0This package provides the following binaries to drive the<br>
=C2=A0Device Mapper multipathing driver:<br>
<br>
@@ -8,7 +9,15 @@ multipathd - Multipath daemon.<br>
=C2=A0mpathpersist - Manages SCSI persistent reservations on dm multipath d=
evices.<br>
=C2=A0kpartx - Create device maps from partition tables.<br>
<br>
-To get latest code: git clone <a href=3D"http://git.opensvc.com/multipath-=
tools/.git" rel=3D"noreferrer" target=3D"_blank">http://git.opensvc.com/mul=
tipath-tools/.git</a><br>
+<br>
+tarballs are not generated anymore, to get a specific release do:<br>
+git clone <a href=3D"http://git.opensvc.com/multipath-tools/.git" rel=3D"n=
oreferrer" target=3D"_blank">http://git.opensvc.com/multipath-tools/.git</a=
><br>
+cd multipath-tools<br>
+git tag<br>
+git archive --format=3Dtar.gz --prefix=3Dmultipath-tools-X.Y.Z/ X.Y.Z &gt;=
 ../multipath-tools-X.Y.Z.tar.gz<br>
+<br>
+<br>
+To get latest devel code: git clone <a href=3D"http://git.opensvc.com/mult=
ipath-tools/.git" rel=3D"noreferrer" target=3D"_blank">http://git.opensvc.c=
om/multipath-tools/.git</a><br>
<br>
=C2=A0Mailing list: <a href=3D"http://www.redhat.com/mailman/listinfo/dm-de=
vel" rel=3D"noreferrer" target=3D"_blank">http://www.redhat.com/mailman/lis=
tinfo/dm-devel</a><br>
=C2=A0Gitweb: <a href=3D"http://git.opensvc.com/?p=3Dmultipath-tools/.git" =
rel=3D"noreferrer" target=3D"_blank">http://git.opensvc.com/?p=3Dmultipath-=
tools/.git</a><br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.5.5<br>
<br>
</font></span></blockquote></div><br></div>

--001a11402104f1fd1a05344b5db0--


--===============9049018466273977571==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9049018466273977571==--
