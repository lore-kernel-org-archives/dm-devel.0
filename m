From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Update kpartx manpage with current output
Date: Mon, 20 Jun 2016 09:30:49 +0200
Message-ID: <CABr-GncGgOGUW3-WttK=bTYfGBMrE3fG6ucKXMMLOE=bNP2byQ@mail.gmail.com>
References: <1465807247-15392-1-git-send-email-rrs@debian.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2558026207736582574=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1465807247-15392-1-git-send-email-rrs@debian.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ritesh Raj Sarraf <rrs@debian.org>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============2558026207736582574==
Content-Type: multipart/alternative; boundary=001a113fc0a8068e340535b0afb9

--001a113fc0a8068e340535b0afb9
Content-Type: text/plain; charset=UTF-8

Applied.

On Mon, Jun 13, 2016 at 10:40 AM, Ritesh Raj Sarraf <rrs@debian.org> wrote:

> See Debian Bug #796948 for details
> Many users are reported to be consuming the output in a scripted setup
>
> Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
> ---
>  kpartx/kpartx.8 | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
> index 021ddc0..564d93b 100644
> --- a/kpartx/kpartx.8
> +++ b/kpartx/kpartx.8
> @@ -50,15 +50,15 @@ kpartx \-av disk.img
>  .PP
>  This will output lines such as:
>  .IP
> -loop3p1 : 0 20964762 /dev/loop3 63
> +add map loop1p1 (254:4): 0 409597 linear 7:1 3
>  .PP
>  The
> -.I loop3p1
> +.I loop1p1
>  is the name of a device file under
>  .I /dev/mapper
>  which you can use to access the partition, for example to fsck it:
>  .IP
> -fsck /dev/mapper/loop3p1
> +fsck /dev/mapper/loop1p1
>  .PP
>  When you're done, you need to remove the devices:
>  .IP
> --
> 2.8.1
>
>

--001a113fc0a8068e340535b0afb9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.</div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Mon, Jun 13, 2016 at 10:40 AM, Ritesh Raj Sarraf <span dir=
=3D"ltr">&lt;<a href=3D"mailto:rrs@debian.org" target=3D"_blank">rrs@debian=
.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">See Debian Bug=
 #796948 for details<br>
Many users are reported to be consuming the output in a scripted setup<br>
<br>
Signed-off-by: Ritesh Raj Sarraf &lt;<a href=3D"mailto:rrs@debian.org">rrs@=
debian.org</a>&gt;<br>
---<br>
=C2=A0kpartx/kpartx.8 | 6 +++---<br>
=C2=A01 file changed, 3 insertions(+), 3 deletions(-)<br>
<br>
diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8<br>
index 021ddc0..564d93b 100644<br>
--- a/kpartx/kpartx.8<br>
+++ b/kpartx/kpartx.8<br>
@@ -50,15 +50,15 @@ kpartx \-av disk.img<br>
=C2=A0.PP<br>
=C2=A0This will output lines such as:<br>
=C2=A0.IP<br>
-loop3p1 : 0 20964762 /dev/loop3 63<br>
+add map loop1p1 (254:4): 0 409597 linear 7:1 3<br>
=C2=A0.PP<br>
=C2=A0The<br>
-.I loop3p1<br>
+.I loop1p1<br>
=C2=A0is the name of a device file under<br>
=C2=A0.I /dev/mapper<br>
=C2=A0which you can use to access the partition, for example to fsck it:<br=
>
=C2=A0.IP<br>
-fsck /dev/mapper/loop3p1<br>
+fsck /dev/mapper/loop1p1<br>
=C2=A0.PP<br>
=C2=A0When you&#39;re done, you need to remove the devices:<br>
=C2=A0.IP<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.8.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a113fc0a8068e340535b0afb9--


--===============2558026207736582574==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2558026207736582574==--
