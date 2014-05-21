From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: multipath-tools: mismatch between CDB allocation
 length and SG_IO dxfer_len
Date: Wed, 21 May 2014 22:31:45 +0200
Message-ID: <CABr-Gne7+-ev1X8VFeKOMn4UjK-5vEmonk+QT-CsoD+cOQoieA@mail.gmail.com>
References: <20140405131323.00000d4b@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2991116014632538666=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140405131323.00000d4b@localhost>
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

--===============2991116014632538666==
Content-Type: multipart/alternative; boundary=089e01176cad9572f204f9eee2e3

--089e01176cad9572f204f9eee2e3
Content-Type: text/plain; charset=UTF-8

Hi,

have you verified this part is not enough to fix the problem, without
shrinking the response size to 128 ?

        unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0, 0,
-                                               sizeof(sb), 0};
+                                               sizeof(sense_buffer), 0};

Is it me or the variable name is just plain misleading ?

Best regards,
Christophe Varoqui
www.opensvc.com



On Sat, Apr 5, 2014 at 1:13 PM, Sebastian Herbszt <herbszt@gmx.de> wrote:

> Hello,
>
> while playing with multipath-tools and scst I got the following warning:
>
> [ 6382.467569] [3806]: scst: scst_parse_cmd:826:Warning: expected
> transfer length 256 for opcode 0x12 (handler vdisk_blockio, target
> scst_local) doesn't match decoded value 128
> [ 6382.467574] [3806]: scst_parse_cmd:828:Suspicious CDB:
> [ 6382.467579]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
> [ 6382.467581]    0: 12 01 c0 00 80 00   ......
>
> This happened when my scst target pretended to be a CLARiiON.
> I noticed a mismatch in emc_clariion_prio (libmultipath/prioritizers/emc.c)
> between the allocation length and dxfer_len:
>
> int emc_clariion_prio(const char *dev, int fd)
> {
>         unsigned char sense_buffer[256];
>         unsigned char sb[128];
>         unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0, 0,
>                                                 sizeof(sb), 0};
>
> ...
>
>         memset(&sense_buffer, 0, 256);
>         io_hdr.interface_id = 'S';
>         io_hdr.cmd_len = sizeof (inqCmdBlk);
>         io_hdr.mx_sb_len = sizeof (sb);
>         io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
>         io_hdr.dxfer_len = sizeof (sense_buffer);
>         io_hdr.dxferp = sense_buffer;
>         io_hdr.cmdp = inqCmdBlk;
>         io_hdr.sbp = sb;
>         io_hdr.timeout = 60000;
>         io_hdr.pack_id = 0;
>
> The following change shrinks the size of sense_buffer to 128.
>
> Sebastian
>
> diff --git a/libmultipath/prioritizers/emc.c
> b/libmultipath/prioritizers/emc.c
> index 87e9a8d..91b3d90 100644
> --- a/libmultipath/prioritizers/emc.c
> +++ b/libmultipath/prioritizers/emc.c
> @@ -14,15 +14,15 @@
>
>  int emc_clariion_prio(const char *dev, int fd)
>  {
> -       unsigned char sense_buffer[256];
> +       unsigned char sense_buffer[128];
>         unsigned char sb[128];
>         unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0, 0,
> -                                               sizeof(sb), 0};
> +                                               sizeof(sense_buffer), 0};
>         struct sg_io_hdr io_hdr;
>         int ret = PRIO_UNDEF;
>
>         memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
> -       memset(&sense_buffer, 0, 256);
> +       memset(&sense_buffer, 0, 128);
>         io_hdr.interface_id = 'S';
>         io_hdr.cmd_len = sizeof (inqCmdBlk);
>         io_hdr.mx_sb_len = sizeof (sb);
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--089e01176cad9572f204f9eee2e3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>have you verified this part is not =
enough to fix the problem, without shrinking the response size to 128 ?</di=
v><div><br></div><div><span style=3D"font-family:arial,sans-serif;font-size=
:19.428571701049805px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char inqCmdBlk[=
INQUIRY_CMDLEN] =3D {INQUIRY_CMD, 1, 0xC0, 0,</span><br style=3D"font-famil=
y:arial,sans-serif;font-size:19.428571701049805px">
<span style=3D"font-family:arial,sans-serif;font-size:19.428571701049805px"=
>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 sizeof(sb), 0};</span><br style=3D"font-family:arial,sans=
-serif;font-size:19.428571701049805px"><span style=3D"font-family:arial,san=
s-serif;font-size:19.428571701049805px">+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof(sense_buffer=
), 0};</span><br style=3D"font-family:arial,sans-serif;font-size:19.4285717=
01049805px">
</div><div><span style=3D"font-family:arial,sans-serif;font-size:19.4285717=
01049805px"><br></span></div><div><div>Is it me or the variable name is jus=
t plain misleading ?</div></div><div><br></div><div>Best regards,</div><div=
>
Christophe Varoqui</div><div><a href=3D"http://www.opensvc.com">www.opensvc=
.com</a></div><div><br></div></div><div class=3D"gmail_extra"><br><br><div =
class=3D"gmail_quote">On Sat, Apr 5, 2014 at 1:13 PM, Sebastian Herbszt <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:herbszt@gmx.de" target=3D"_blank">herb=
szt@gmx.de</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hello,<br>
<br>
while playing with multipath-tools and scst I got the following warning:<br=
>
<br>
[ 6382.467569] [3806]: scst: scst_parse_cmd:826:Warning: expected<br>
transfer length 256 for opcode 0x12 (handler vdisk_blockio, target<br>
scst_local) doesn&#39;t match decoded value 128<br>
[ 6382.467574] [3806]: scst_parse_cmd:828:Suspicious CDB:<br>
[ 6382.467579] =C2=A0(h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F<b=
r>
[ 6382.467581] =C2=A0 =C2=A00: 12 01 c0 00 80 00 =C2=A0 ......<br>
<br>
This happened when my scst target pretended to be a CLARiiON.<br>
I noticed a mismatch in emc_clariion_prio (libmultipath/prioritizers/emc.c)=
<br>
between the allocation length and dxfer_len:<br>
<br>
int emc_clariion_prio(const char *dev, int fd)<br>
{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char sense_buffer[256];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char sb[128];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char inqCmdBlk[INQUIRY_CMDLEN] =3D {IN=
QUIRY_CMD, 1, 0xC0, 0,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 sizeof(sb), 0};<br>
<br>
...<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(&amp;sense_buffer, 0, 256);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.interface_id =3D &#39;S&#39;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.cmd_len =3D sizeof (inqCmdBlk);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.mx_sb_len =3D sizeof (sb);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.dxfer_direction =3D SG_DXFER_FROM_DEV;<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.dxfer_len =3D sizeof (sense_buffer);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.dxferp =3D sense_buffer;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.cmdp =3D inqCmdBlk;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.sbp =3D sb;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D 60000;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.pack_id =3D 0;<br>
<br>
The following change shrinks the size of sense_buffer to 128.<br>
<br>
Sebastian<br>
<br>
diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/em=
c.c<br>
index 87e9a8d..91b3d90 100644<br>
--- a/libmultipath/prioritizers/emc.c<br>
+++ b/libmultipath/prioritizers/emc.c<br>
@@ -14,15 +14,15 @@<br>
<br>
=C2=A0int emc_clariion_prio(const char *dev, int fd)<br>
=C2=A0{<br>
- =C2=A0 =C2=A0 =C2=A0 unsigned char sense_buffer[256];<br>
+ =C2=A0 =C2=A0 =C2=A0 unsigned char sense_buffer[128];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char sb[128];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char inqCmdBlk[INQUIRY_CMDLEN] =3D {IN=
QUIRY_CMD, 1, 0xC0, 0,<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 sizeof(sb), 0};<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 sizeof(sense_buffer), 0};<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct sg_io_hdr io_hdr;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret =3D PRIO_UNDEF;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(&amp;io_hdr, 0, sizeof (struct sg_io_hdr=
));<br>
- =C2=A0 =C2=A0 =C2=A0 memset(&amp;sense_buffer, 0, 256);<br>
+ =C2=A0 =C2=A0 =C2=A0 memset(&amp;sense_buffer, 0, 128);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.interface_id =3D &#39;S&#39;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.cmd_len =3D sizeof (inqCmdBlk);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.mx_sb_len =3D sizeof (sb);<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</blockquote></div><br></div>

--089e01176cad9572f204f9eee2e3--


--===============2991116014632538666==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2991116014632538666==--
