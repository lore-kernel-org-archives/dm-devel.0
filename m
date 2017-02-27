From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v3 1/7] kpartx: don't keep creating recursive
	partitions
Date: Mon, 27 Feb 2017 07:03:09 +0100
Message-ID: <CABr-Gnd_0cUExPmJmOFJmmcJJYc_qAN8yg9mOysUs82+FKg9wQ@mail.gmail.com>
References: <1487125017-22049-1-git-send-email-bmarzins@redhat.com>
	<1487125017-22049-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6548296325367107450=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1487125017-22049-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6548296325367107450==
Content-Type: multipart/alternative; boundary=001a11c0004475fca905497cd5f4

--001a11c0004475fca905497cd5f4
Content-Type: text/plain; charset=UTF-8

Applied.

On Wed, Feb 15, 2017 at 3:16 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> If the dos partition table is corrupted, kpartx can just keep creating
> the same partitions until it runs out of partition numbers. This check
> catches the recursion.
>
> Signed-off-by: Cedric Buissart <cbuissar@redhat.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  kpartx/dos.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kpartx/dos.c b/kpartx/dos.c
> index 64b27b6..4985152 100644
> --- a/kpartx/dos.c
> +++ b/kpartx/dos.c
> @@ -46,7 +46,7 @@ read_extended_partition(int fd, struct partition *ep,
> int en,
>                 for (i=0; i<2; i++) {
>                         memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof
> (p));
>                         if (is_extended(p.sys_type)) {
> -                               if (p.nr_sects && !moretodo) {
> +                               if (p.start_sect && p.nr_sects &&
> !moretodo) {
>                                         next = start + sector_size_mul *
> le32_to_cpu(p.start_sect);
>                                         moretodo = 1;
>                                 }
> --
> 1.8.3.1
>
>

--001a11c0004475fca905497cd5f4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.</div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Wed, Feb 15, 2017 at 3:16 AM, Benjamin Marzinski <span dir=
=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarz=
ins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">If t=
he dos partition table is corrupted, kpartx can just keep creating<br>
the same partitions until it runs out of partition numbers. This check<br>
catches the recursion.<br>
<br>
Signed-off-by: Cedric Buissart &lt;<a href=3D"mailto:cbuissar@redhat.com">c=
buissar@redhat.com</a>&gt;<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0kpartx/dos.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/kpartx/dos.c b/kpartx/dos.c<br>
index 64b27b6..4985152 100644<br>
--- a/kpartx/dos.c<br>
+++ b/kpartx/dos.c<br>
@@ -46,7 +46,7 @@ read_extended_partition(int fd, struct partition *ep, int=
 en,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i=3D0; i&lt;2;=
 i++) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 memcpy(&amp;p, bp + 0x1be + i * sizeof (p), sizeof (p));<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (is_extended(p.sys_type)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (p.nr_sects &amp;&amp; !moretodo) =
{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (p.start_sect &amp;&amp; p.nr_sect=
s &amp;&amp; !moretodo) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 next =3D=
 start + sector_size_mul * le32_to_cpu(p.start_sect);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 moretodo=
 =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a11c0004475fca905497cd5f4--


--===============6548296325367107450==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6548296325367107450==--
