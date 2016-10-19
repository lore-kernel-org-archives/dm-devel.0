From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: integrate Changelog file in
 README and update it
Date: Wed, 19 Oct 2016 08:09:59 +0200
Message-ID: <CABr-GnfZWGaxXw61hLLHE0mt2WwdxTR-u1gn_mpvcqpO0Nk_JA@mail.gmail.com>
References: <20161018233422.5001-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8538200667079296603=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161018233422.5001-1-xose.vazquez@gmail.com>
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

--===============8538200667079296603==
Content-Type: multipart/alternative; boundary=001a113f1886b8fe61053f31a8fb

--001a113f1886b8fe61053f31a8fb
Content-Type: text/plain; charset=UTF-8

Merged.

On Wed, Oct 19, 2016 at 1:34 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> and httpS for everyone.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  ChangeLog |  6 ------
>  README    | 38 ++++++++++++++++++++++++++++----------
>  2 files changed, 28 insertions(+), 16 deletions(-)
>  delete mode 100644 ChangeLog
>
> diff --git a/ChangeLog b/ChangeLog
> deleted file mode 100644
> index 4b547bb..0000000
> --- a/ChangeLog
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -Change logs are at :
> -
> -- pre-0.4.5
> -  http://web.archive.org/web/20070309224034/http://
> christophe.varoqui.free.fr/wiki/wakka.php?wiki=ChangeLog
> -- post-0.4.5
> -  http://git.opensvc.com/?p=multipath-tools/.git;a=log
> diff --git a/README b/README
> index 77b79b8..a18b325 100644
> --- a/README
> +++ b/README
> @@ -1,8 +1,8 @@
> -multipath-tools for Linux <http://christophe.varoqui.free.fr/>
> +       multipath-tools for Linux <http://christophe.varoqui.free.fr/>
>
>
> -This package provides the following binaries to drive the
> -Device Mapper multipathing driver:
> +This package provides the following binaries to drive the Device Mapper
> +multipathing driver:
>
>  multipath - Device mapper target autoconfig.
>  multipathd - Multipath daemon.
> @@ -10,20 +10,38 @@ mpathpersist - Manages SCSI persistent reservations on
> dm multipath devices.
>  kpartx - Create device maps from partition tables.
>
>
> -tarballs are not generated anymore, to get a specific release do:
> -git clone http://git.opensvc.com/multipath-tools/.git
> +Releases
> +========
> +Tarballs are not generated anymore, to get a specific release do:
> +git clone https://git.opensvc.com/multipath-tools/.git
>  cd multipath-tools
>  git tag
>  git archive --format=tar.gz --prefix=multipath-tools-X.Y.Z/ X.Y.Z >
> ../multipath-tools-X.Y.Z.tar.gz
>
>  Alternatively it may be obtained from gitweb, go to:
> -http://git.opensvc.com/?p=multipath-tools/.git;a=tags
> +https://git.opensvc.com/?p=multipath-tools/.git;a=tags
>  select a release-tag and then click on "snapshot".
>
>
> -To get latest devel code: git clone http://git.opensvc.com/
> multipath-tools/.git
> +Source code
> +===========
> +To get latest devel code: git clone https://git.opensvc.com/
> multipath-tools/.git
> +Gitweb: https://git.opensvc.com/?p=multipath-tools/.git
>
> -Mailing list: http://www.redhat.com/mailman/listinfo/dm-devel
> -Gitweb: http://git.opensvc.com/?p=multipath-tools/.git
>
> -Current maintainer is Christophe Varoqui <christophe.varoqui@opensvc.com>
> +Mailing list (subscribers-only)
> +============
> +To subscribe and archives: https://www.redhat.com/
> mailman/listinfo/dm-devel
> +Searchable: https://marc.info/?l=dm-devel
> +
> +
> +Changelog
> +=========
> +pre-0.4.5: https://web.archive.org/web/20070309224034/http://
> christophe.varoqui.free.fr/wiki/wakka.php?wiki=ChangeLog
> +post-0.4.5: https://git.opensvc.com/?p=multipath-tools/.git;a=log
> +
> +
> +Maintainer
> +==========
> +Christophe Varoqui <christophe.varoqui@opensvc.com>
> +Device-mapper development mailing list <dm-devel@redhat.com>
> --
> 2.10.1
>
>

--001a113f1886b8fe61053f31a8fb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Wed, Oct 19, 2016 at 1:34 AM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">and httpS for everyone.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0ChangeLog |=C2=A0 6 ------<br>
=C2=A0README=C2=A0 =C2=A0 | 38 ++++++++++++++++++++++++++++--<wbr>--------<=
br>
=C2=A02 files changed, 28 insertions(+), 16 deletions(-)<br>
=C2=A0delete mode 100644 ChangeLog<br>
<br>
diff --git a/ChangeLog b/ChangeLog<br>
deleted file mode 100644<br>
index 4b547bb..0000000<br>
--- a/ChangeLog<br>
+++ /dev/null<br>
@@ -1,6 +0,0 @@<br>
-Change logs are at :<br>
-<br>
-- pre-0.4.5<br>
-=C2=A0 <a href=3D"http://web.archive.org/web/20070309224034/http://christo=
phe.varoqui.free.fr/wiki/wakka.php?wiki=3DChangeLog" rel=3D"noreferrer" tar=
get=3D"_blank">http://web.archive.org/web/<wbr>20070309224034/http://<wbr>c=
hristophe.varoqui.free.fr/<wbr>wiki/wakka.php?wiki=3DChangeLog</a><br>
-- post-0.4.5<br>
-=C2=A0 <a href=3D"http://git.opensvc.com/?p=3Dmultipath-tools/.git;a=3Dlog=
" rel=3D"noreferrer" target=3D"_blank">http://git.opensvc.com/?p=3D<wbr>mul=
tipath-tools/.git;a=3Dlog</a><br>
diff --git a/README b/README<br>
index 77b79b8..a18b325 100644<br>
--- a/README<br>
+++ b/README<br>
@@ -1,8 +1,8 @@<br>
-multipath-tools for Linux &lt;<a href=3D"http://christophe.varoqui.free.fr=
/" rel=3D"noreferrer" target=3D"_blank">http://christophe.varoqui.<wbr>free=
.fr/</a>&gt;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0multipath-tools for Linux &lt;<a href=3D"http:/=
/christophe.varoqui.free.fr/" rel=3D"noreferrer" target=3D"_blank">http://c=
hristophe.varoqui.<wbr>free.fr/</a>&gt;<br>
<br>
<br>
-This package provides the following binaries to drive the<br>
-Device Mapper multipathing driver:<br>
+This package provides the following binaries to drive the Device Mapper<br=
>
+multipathing driver:<br>
<br>
=C2=A0multipath - Device mapper target autoconfig.<br>
=C2=A0multipathd - Multipath daemon.<br>
@@ -10,20 +10,38 @@ mpathpersist - Manages SCSI persistent reservations on =
dm multipath devices.<br>
=C2=A0kpartx - Create device maps from partition tables.<br>
<br>
<br>
-tarballs are not generated anymore, to get a specific release do:<br>
-git clone <a href=3D"http://git.opensvc.com/multipath-tools/.git" rel=3D"n=
oreferrer" target=3D"_blank">http://git.opensvc.com/<wbr>multipath-tools/.g=
it</a><br>
+Releases<br>
+=3D=3D=3D=3D=3D=3D=3D=3D<br>
+Tarballs are not generated anymore, to get a specific release do:<br>
+git clone <a href=3D"https://git.opensvc.com/multipath-tools/.git" rel=3D"=
noreferrer" target=3D"_blank">https://git.opensvc.com/<wbr>multipath-tools/=
.git</a><br>
=C2=A0cd multipath-tools<br>
=C2=A0git tag<br>
=C2=A0git archive --format=3Dtar.gz --prefix=3Dmultipath-tools-X.Y.<wbr>Z/ =
X.Y.Z &gt; ../multipath-tools-X.Y.Z.tar.<wbr>gz<br>
<br>
=C2=A0Alternatively it may be obtained from gitweb, go to:<br>
-<a href=3D"http://git.opensvc.com/?p=3Dmultipath-tools/.git;a=3Dtags" rel=
=3D"noreferrer" target=3D"_blank">http://git.opensvc.com/?p=3D<wbr>multipat=
h-tools/.git;a=3Dtags</a><br>
+<a href=3D"https://git.opensvc.com/?p=3Dmultipath-tools/.git;a=3Dtags" rel=
=3D"noreferrer" target=3D"_blank">https://git.opensvc.com/?p=3D<wbr>multipa=
th-tools/.git;a=3Dtags</a><br>
=C2=A0select a release-tag and then click on &quot;snapshot&quot;.<br>
<br>
<br>
-To get latest devel code: git clone <a href=3D"http://git.opensvc.com/mult=
ipath-tools/.git" rel=3D"noreferrer" target=3D"_blank">http://git.opensvc.c=
om/<wbr>multipath-tools/.git</a><br>
+Source code<br>
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
+To get latest devel code: git clone <a href=3D"https://git.opensvc.com/mul=
tipath-tools/.git" rel=3D"noreferrer" target=3D"_blank">https://git.opensvc=
.com/<wbr>multipath-tools/.git</a><br>
+Gitweb: <a href=3D"https://git.opensvc.com/?p=3Dmultipath-tools/.git" rel=
=3D"noreferrer" target=3D"_blank">https://git.opensvc.com/?p=3D<wbr>multipa=
th-tools/.git</a><br>
<br>
-Mailing list: <a href=3D"http://www.redhat.com/mailman/listinfo/dm-devel" =
rel=3D"noreferrer" target=3D"_blank">http://www.redhat.com/mailman/<wbr>lis=
tinfo/dm-devel</a><br>
-Gitweb: <a href=3D"http://git.opensvc.com/?p=3Dmultipath-tools/.git" rel=
=3D"noreferrer" target=3D"_blank">http://git.opensvc.com/?p=3D<wbr>multipat=
h-tools/.git</a><br>
<br>
-Current maintainer is Christophe Varoqui &lt;<a href=3D"mailto:christophe.=
varoqui@opensvc.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
+Mailing list (subscribers-only)<br>
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
+To subscribe and archives: <a href=3D"https://www.redhat.com/mailman/listi=
nfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/<=
wbr>mailman/listinfo/dm-devel</a><br>
+Searchable: <a href=3D"https://marc.info/?l=3Ddm-devel" rel=3D"noreferrer"=
 target=3D"_blank">https://marc.info/?l=3Ddm-devel</a><br>
+<br>
+<br>
+Changelog<br>
+=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
+pre-0.4.5: <a href=3D"https://web.archive.org/web/20070309224034/http://ch=
ristophe.varoqui.free.fr/wiki/wakka.php?wiki=3DChangeLog
+post-0.4.5" rel=3D"noreferrer" target=3D"_blank">https://web.archive.org/w=
eb/<wbr>20070309224034/http://<wbr>christophe.varoqui.free.fr/<wbr>wiki/wak=
ka.php?wiki=3DChangeLog<br>
+post-0.4.5</a>: <a href=3D"https://git.opensvc.com/?p=3Dmultipath-tools/.g=
it;a=3Dlog" rel=3D"noreferrer" target=3D"_blank">https://git.opensvc.com/?p=
=3D<wbr>multipath-tools/.git;a=3Dlog</a><br>
+<br>
+<br>
+Maintainer<br>
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
+Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com">c=
hristophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
+Device-mapper development mailing list &lt;<a href=3D"mailto:dm-devel@redh=
at.com">dm-devel@redhat.com</a>&gt;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a113f1886b8fe61053f31a8fb--


--===============8538200667079296603==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8538200667079296603==--
