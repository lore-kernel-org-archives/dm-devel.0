From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: update docs
Date: Tue, 19 Apr 2016 18:36:33 +0200
Message-ID: <CABr-Gnc90eityDsiZgnRy999wthaLQVx9HoU5VtZvzGB-NnWpg@mail.gmail.com>
References: <1461080106-18818-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5575638705443741723=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461080106-18818-1-git-send-email-xose.vazquez@gmail.com>
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

--===============5575638705443741723==
Content-Type: multipart/alternative; boundary=001a1136c8c8872fbd0530d91462

--001a1136c8c8872fbd0530d91462
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Tue, Apr 19, 2016 at 5:35 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> removes TODO, adds meaningful information to README
> and replaces dead urls in ChangeLog.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  ChangeLog |  4 ++--
>  README    | 15 ++++++++++++++-
>  TODO      |  1 -
>  3 files changed, 16 insertions(+), 4 deletions(-)
>  delete mode 100644 TODO
>
> diff --git a/ChangeLog b/ChangeLog
> index 73026b3..4b547bb 100644
> --- a/ChangeLog
> +++ b/ChangeLog
> @@ -1,6 +1,6 @@
>  Change logs are at :
>
>  - pre-0.4.5
> -  http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=ChangeLog
> +
> http://web.archive.org/web/20070309224034/http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=ChangeLog
>  - post-0.4.5
> -
> http://www.kernel.org/git/gitweb.cgi?p=linux/storage/multipath-tools/.git;a=log
> +  http://git.opensvc.com/?p=multipath-tools/.git;a=log
> diff --git a/README b/README
> index b0b9dfa..1914e38 100644
> --- a/README
> +++ b/README
> @@ -1 +1,14 @@
> -Things to read
> +multipath-tools for Linux <http://christophe.varoqui.free.fr/>
> +
> +This package provides the following binaries to drive the
> +Device Mapper multipathing driver:
> +
> +multipath - Device mapper target autoconfig.
> +multipathd - Multipath daemon.
> +mpathpersist - Manages SCSI persistent reservations on dm multipath
> devices.
> +kpartxrtx - Create device maps from partition tables.
> +
> +To get latest code: git clone http://git.opensvc.com/multipath-tools/.git
> +
> +Mailing list: http://www.redhat.com/mailman/listinfo/dm-devel
> +Gitweb: http://git.opensvc.com/?p=multipath-tools/.git
> diff --git a/TODO b/TODO
> deleted file mode 100644
> index 690ea03..0000000
> --- a/TODO
> +++ /dev/null
> @@ -1 +0,0 @@
> -Things to do
> --
> 2.5.5
>
>

--001a1136c8c8872fbd0530d91462
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Apr 19, 2016 at 5:35 PM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">removes TODO, adds meaningful information to README<br>
and replaces dead urls in ChangeLog.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0ChangeLog |=C2=A0 4 ++--<br>
=C2=A0README=C2=A0 =C2=A0 | 15 ++++++++++++++-<br>
=C2=A0TODO=C2=A0 =C2=A0 =C2=A0 |=C2=A0 1 -<br>
=C2=A03 files changed, 16 insertions(+), 4 deletions(-)<br>
=C2=A0delete mode 100644 TODO<br>
<br>
diff --git a/ChangeLog b/ChangeLog<br>
index 73026b3..4b547bb 100644<br>
--- a/ChangeLog<br>
+++ b/ChangeLog<br>
@@ -1,6 +1,6 @@<br>
=C2=A0Change logs are at :<br>
<br>
=C2=A0- pre-0.4.5<br>
-=C2=A0 <a href=3D"http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=3D=
ChangeLog" rel=3D"noreferrer" target=3D"_blank">http://christophe.varoqui.f=
ree.fr/wiki/wakka.php?wiki=3DChangeLog</a><br>
+=C2=A0 <a href=3D"http://web.archive.org/web/20070309224034/http://christo=
phe.varoqui.free.fr/wiki/wakka.php?wiki=3DChangeLog" rel=3D"noreferrer" tar=
get=3D"_blank">http://web.archive.org/web/20070309224034/http://christophe.=
varoqui.free.fr/wiki/wakka.php?wiki=3DChangeLog</a><br>
=C2=A0- post-0.4.5<br>
-=C2=A0 <a href=3D"http://www.kernel.org/git/gitweb.cgi?p=3Dlinux/storage/m=
ultipath-tools/.git;a=3Dlog" rel=3D"noreferrer" target=3D"_blank">http://ww=
w.kernel.org/git/gitweb.cgi?p=3Dlinux/storage/multipath-tools/.git;a=3Dlog<=
/a><br>
+=C2=A0 <a href=3D"http://git.opensvc.com/?p=3Dmultipath-tools/.git;a=3Dlog=
" rel=3D"noreferrer" target=3D"_blank">http://git.opensvc.com/?p=3Dmultipat=
h-tools/.git;a=3Dlog</a><br>
diff --git a/README b/README<br>
index b0b9dfa..1914e38 100644<br>
--- a/README<br>
+++ b/README<br>
@@ -1 +1,14 @@<br>
-Things to read<br>
+multipath-tools for Linux &lt;<a href=3D"http://christophe.varoqui.free.fr=
/" rel=3D"noreferrer" target=3D"_blank">http://christophe.varoqui.free.fr/<=
/a>&gt;<br>
+<br>
+This package provides the following binaries to drive the<br>
+Device Mapper multipathing driver:<br>
+<br>
+multipath - Device mapper target autoconfig.<br>
+multipathd - Multipath daemon.<br>
+mpathpersist - Manages SCSI persistent reservations on dm multipath device=
s.<br>
+kpartxrtx - Create device maps from partition tables.<br>
+<br>
+To get latest code: git clone <a href=3D"http://git.opensvc.com/multipath-=
tools/.git" rel=3D"noreferrer" target=3D"_blank">http://git.opensvc.com/mul=
tipath-tools/.git</a><br>
+<br>
+Mailing list: <a href=3D"http://www.redhat.com/mailman/listinfo/dm-devel" =
rel=3D"noreferrer" target=3D"_blank">http://www.redhat.com/mailman/listinfo=
/dm-devel</a><br>
+Gitweb: <a href=3D"http://git.opensvc.com/?p=3Dmultipath-tools/.git" rel=
=3D"noreferrer" target=3D"_blank">http://git.opensvc.com/?p=3Dmultipath-too=
ls/.git</a><br>
diff --git a/TODO b/TODO<br>
deleted file mode 100644<br>
index 690ea03..0000000<br>
--- a/TODO<br>
+++ /dev/null<br>
@@ -1 +0,0 @@<br>
-Things to do<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.5.5<br>
<br>
</font></span></blockquote></div><br></div>

--001a1136c8c8872fbd0530d91462--


--===============5575638705443741723==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5575638705443741723==--
