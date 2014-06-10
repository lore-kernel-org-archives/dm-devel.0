From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] kpartx: fix extended partition size for
	>512b sectors
Date: Tue, 10 Jun 2014 07:59:58 +0200
Message-ID: <CABr-Gnd=NTnn5rRW_qPtT8WQBZRTNazL8VaNGzqA_gNUUbTABQ@mail.gmail.com>
References: <1402327498-19669-1-git-send-email-psusi@ubuntu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8210035390428746341=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1402327498-19669-1-git-send-email-psusi@ubuntu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8210035390428746341==
Content-Type: multipart/alternative; boundary=001a11c1d89aa82daf04fb750962

--001a11c1d89aa82daf04fb750962
Content-Type: text/plain; charset=UTF-8

Applied, thanks

Christophe Varoqui
www.opensvc.com


On Mon, Jun 9, 2014 at 5:24 PM, Phillip Susi <psusi@ubuntu.com> wrote:

> Extended partitions only get 2 sectors for 512 byte sector size,
> to allow LILO the 1024 bytes of room it needs.  Larger sector size
> disks already have room and so only use 1 sector.
>
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>
> ---
>  kpartx/dos.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kpartx/dos.c b/kpartx/dos.c
> index 0e57f0e..90ad3bd 100644
> --- a/kpartx/dos.c
> +++ b/kpartx/dos.c
> @@ -101,8 +101,12 @@ read_dos_pt(int fd, struct slice all, struct slice
> *sp, int ns) {
>                         break;
>                 }
>                 if (is_extended(p.sys_type)) {
> -                       sp[i].size = sector_size_mul * 2; /* extended
> partitions only get two
> -                                          sectors mapped for LILO to
> install */
> +                       /* extended partitions only get one or
> +                          two sectors mapped for LILO to install,
> +                          whichever is needed to have 1kb of space */
> +                       if (sector_size_mul == 1)
> +                               sp[i].size = 2;
> +                       else sp[i].size = sector_size_mul;
>                         n += read_extended_partition(fd, &p, i, sp+n,
> ns-n);
>                 }
>         }
> --
> 1.9.1
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11c1d89aa82daf04fb750962
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Applied, thanks<br><br></div>Christophe Varoqui<=
br></div><a href=3D"http://www.opensvc.com">www.opensvc.com</a><br><div cla=
ss=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Mon, Jun 9, 2014 a=
t 5:24 PM, Phillip Susi <span dir=3D"ltr">&lt;<a href=3D"mailto:psusi@ubunt=
u.com" target=3D"_blank">psusi@ubuntu.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Extended partitions only get 2 sectors for 5=
12 byte sector size,<br>
to allow LILO the 1024 bytes of room it needs. =C2=A0Larger sector size<br>
disks already have room and so only use 1 sector.<br>
<br>
Signed-off-by: Phillip Susi &lt;<a href=3D"mailto:psusi@ubuntu.com">psusi@u=
buntu.com</a>&gt;<br>
---<br>
=C2=A0kpartx/dos.c | 8 ++++++--<br>
=C2=A01 file changed, 6 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/kpartx/dos.c b/kpartx/dos.c<br>
index 0e57f0e..90ad3bd 100644<br>
--- a/kpartx/dos.c<br>
+++ b/kpartx/dos.c<br>
@@ -101,8 +101,12 @@ read_dos_pt(int fd, struct slice all, struct slice *sp=
, int ns) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (is_extended(p.s=
ys_type)) {<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 sp[i].size =3D sector_size_mul * 2; /* extended partitions only get two=
<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0se=
ctors mapped for LILO to install */<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* extended partitions only get one or<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0two sectors mapped for LILO to install,<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0whichever is needed to have 1kb of space */<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (sector_size_mul =3D=3D 1)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sp[i].size =3D 2;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 else sp[i].size =3D sector_size_mul;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 n +=3D read_extended_partition(fd, &amp;p, i, sp+n, ns-n);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.9.1<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></span></blockquote></div><br></div></div>

--001a11c1d89aa82daf04fb750962--


--===============8210035390428746341==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8210035390428746341==--
