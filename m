From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH]multipath-tools: Mismatch between allocation
 length and transfer length in rdac prio
Date: Tue, 10 Jun 2014 07:59:24 +0200
Message-ID: <CABr-GneU-aqRCmW_un4t817uSwszn_CukvreSRBdoWPk7s2nPw@mail.gmail.com>
References: <7973fb83653f408fa27af8d60da6e8c6@hioexcmbx08-prd.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2789973019344589682=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7973fb83653f408fa27af8d60da6e8c6@hioexcmbx08-prd.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2789973019344589682==
Content-Type: multipart/alternative; boundary=001a11c1f61e9adefb04fb750751

--001a11c1f61e9adefb04fb750751
Content-Type: text/plain; charset=UTF-8

Applied, thanks.

Christophe Varoqui
www.opensvc.com


On Mon, May 19, 2014 at 4:49 PM, Merla, ShivaKrishna <
ShivaKrishna.Merla@netapp.com> wrote:

> Fix mismatch between allocation length and dxfer len in rdac prio.
>
> Signed-off-by: shiva krishna merla <shivakrishna.merla@netapp.com>
> ---
> --- a/libmultipath/prioritizers/rdac.c  2014-02-10 08:55:09.017765026 -0600
> +++ b/libmultipath/prioritizers/rdac.c  2014-05-19 07:48:29.416854704 -0500
> @@ -14,15 +14,15 @@
>
>  int rdac_prio(const char *dev, int fd)
>  {
> -       unsigned char sense_buffer[256];
> +       unsigned char sense_buffer[128];
>         unsigned char sb[128];
>         unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC9, 0,
> -                                               sizeof(sb), 0};
> +                                               sizeof(sense_buffer), 0};
>         struct sg_io_hdr io_hdr;
>         int ret = 0;
>
>         memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
> -       memset(sense_buffer, 0, 256);
> +       memset(sense_buffer, 0, 128);
>         io_hdr.interface_id = 'S';
>         io_hdr.cmd_len = sizeof (inqCmdBlk);
>         io_hdr.mx_sb_len = sizeof (sb);
> --
>

--001a11c1f61e9adefb04fb750751
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Applied, thanks.<br><br></div>Christophe Varoqui=
<br></div><a href=3D"http://www.opensvc.com">www.opensvc.com</a><br></div><=
div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Mon, May 19=
, 2014 at 4:49 PM, Merla, ShivaKrishna <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:ShivaKrishna.Merla@netapp.com" target=3D"_blank">ShivaKrishna.Merla@net=
app.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Fix mismatch between allocation length and d=
xfer len in rdac prio.<br>
<br>
Signed-off-by: shiva krishna merla &lt;<a href=3D"mailto:shivakrishna.merla=
@netapp.com">shivakrishna.merla@netapp.com</a>&gt;<br>
---<br>
--- a/libmultipath/prioritizers/rdac.c =C2=A02014-02-10 08:55:09.017765026 =
-0600<br>
+++ b/libmultipath/prioritizers/rdac.c =C2=A02014-05-19 07:48:29.416854704 =
-0500<br>
@@ -14,15 +14,15 @@<br>
<br>
=C2=A0int rdac_prio(const char *dev, int fd)<br>
=C2=A0{<br>
- =C2=A0 =C2=A0 =C2=A0 unsigned char sense_buffer[256];<br>
+ =C2=A0 =C2=A0 =C2=A0 unsigned char sense_buffer[128];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char sb[128];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char inqCmdBlk[INQUIRY_CMDLEN] =3D {IN=
QUIRY_CMD, 1, 0xC9, 0,<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 sizeof(sb), 0};<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 sizeof(sense_buffer), 0};<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct sg_io_hdr io_hdr;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(&amp;io_hdr, 0, sizeof (struct sg_io_hdr=
));<br>
- =C2=A0 =C2=A0 =C2=A0 memset(sense_buffer, 0, 256);<br>
+ =C2=A0 =C2=A0 =C2=A0 memset(sense_buffer, 0, 128);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.interface_id =3D &#39;S&#39;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.cmd_len =3D sizeof (inqCmdBlk);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.mx_sb_len =3D sizeof (sb);<br>
--<br>
</blockquote></div><br></div>

--001a11c1f61e9adefb04fb750751--


--===============2789973019344589682==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2789973019344589682==--
