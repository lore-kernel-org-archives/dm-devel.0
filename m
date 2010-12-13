From: <Menny_Hamburger@Dell.com>
Subject: [PATCH 1/1]: missing call to pg_init_done causes I/O to
 be hung forever
Date: Mon, 13 Dec 2010 15:35:17 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A7064AF923A3@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2786052642258559216=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2786052642258559216==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D8C50530D6022F40A817A35C40CC06A7064AF923A3DUBX7MCDUB01E_"

--_000_D8C50530D6022F40A817A35C40CC06A7064AF923A3DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

When scsi_dh_activate returns SCSI_DH_NOSYS the H/W handler callback is not=
 called, pg_init_done is not called in
the multipath layer and pending I/O is requeued forever; this situation cau=
ses all userland processes currently performing I/O
on the device to I/O hang. A similar situation occurs when the device has t=
ransitioned to SDEV_CANCEL/SDEV_DEL and the device
handler data had not yet been deleted.

The easiest way to reproduce this is in an ISCSI environment:
  dd if=3D/dev/dm-0 of=3D/dev/zero bs=3D8k count=3D1000000 &
  /etc/init.d/iscsi stop
In this example, dd will I/O hang forever and the only way to release it wi=
ll be to reboot the machine

This patch calls pg_init_done directly from the mpath code when the scsi_dh=
_activate returns a non SCSI_DH_OK error.

Note:
The patch is over RHEL5.5.
When running an upstream kernel, the above scenario may not occur because t=
he request queue is aborted in dm-mpath.c:fail_path.
This patch makes sure the problem does not occur at all, rather than handli=
ng it when it does. In addition, it seems too risky to apply
request queue abort functionality on RHEL5 at this stage.

diff -r -U 2 a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c   2010-12-13 09:16:31.358858000 +0200
+++ b/drivers/md/dm-mpath.c   2010-12-13 09:16:31.796998000 +0200
@@ -1190,4 +1190,5 @@
      case SCSI_DH_OK:
            break;
+     case SCSI_DH_DEV_OFFLINED:
      case SCSI_DH_NOSYS:
            if (!m->hw_handler_name) {
@@ -1252,7 +1253,15 @@
 {
      struct pgpath *pgpath =3D (struct pgpath *) data;
+     int err;

-     scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
+     err =3D scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
                        pg_init_done, &pgpath->path);
+
+     /*
+     * If error is not SCSI_DH_OK, we have not entered the scsi_dh H/W han=
dler and did not call pg_init_done -
+     * need to call pg_init_done directly.
+     */
+     if (err)
+           pg_init_done(&pgpath->path, err);
 }

diff -r -U 2 a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_=
handler/scsi_dh.c
--- a/drivers/scsi/device_handler/scsi_dh.c     2010-12-13 09:16:31.6165540=
00 +0200
+++ b/drivers/scsi/device_handler/scsi_dh.c     2010-12-13 09:16:31.8781700=
00 +0200
@@ -443,4 +443,9 @@
      spin_unlock_irqrestore(q->queue_lock, flags);

+     if (sdev->sdev_state =3D=3D SDEV_CANCEL ||
+         sdev->sdev_state =3D=3D SDEV_DEL ||
+         sdev->sdev_state =3D=3D SDEV_OFFLINE)
+           err =3D SCSI_DH_DEV_OFFLINED;
+
      if (err)
            return err;
diff -r -U 2 a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/de=
vice_handler/scsi_dh_rdac.c
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c      2010-12-13 09:16:31.7=
47755000 +0200
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c      2010-12-13 09:16:31.9=
12827000 +0200
@@ -665,4 +665,5 @@
      if (fn)
            fn(data, err);
+
      return 0;
 }



Menny Hamburger
Engineer
Dell | IDC
office +972 97698789,  fax +972 97698889
Dell IDC. 4 Hacharoshet St, Raanana 43657, Israel


--_000_D8C50530D6022F40A817A35C40CC06A7064AF923A3DUBX7MCDUB01E_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"Trebuchet MS";
	panose-1:2 11 6 3 2 2 2 2 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DWordSection1>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>When scsi_dh_activate returns SCSI_DH_NOSYS the =
H/W
handler callback is not called, pg_init_done is not called in <o:p></o:p></=
span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>the multipath layer and pending I/O is requeued
forever; this situation causes all userland processes currently performing =
I/O<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>on the device to I/O hang. A similar situation
occurs when the device has transitioned to SDEV_CANCEL/SDEV_DEL and the dev=
ice<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>handler data had not yet been deleted.<o:p></o:p=
></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>The easiest way to reproduce this is in an ISCSI
environment:<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp; dd if=3D/dev/dm-0 of=3D/dev/zero bs=3D8k
count=3D1000000 &amp;<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp; /etc/init.d/iscsi stop<o:p></o:p></span><=
/p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>In this example, dd will I/O hang forever and th=
e
only way to release it will be to reboot the machine<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>This patch calls pg_init_done directly from the
mpath code when the scsi_dh_activate returns a non SCSI_DH_OK error.<o:p></=
o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>Note:<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>The patch is over RHEL5.5.<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>When running an upstream kernel, the above scena=
rio
may not occur because the request queue is aborted in dm-mpath.c:fail_path.=
<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>This patch makes sure the problem does not occur=
 at
all, rather than handling it when it does. In addition, it seems too risky =
to
apply <o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>request queue abort functionality on RHEL5 at th=
is
stage.<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>diff -r -U 2 a/drivers/md/dm-mpath.c
b/drivers/md/dm-mpath.c<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>--- a/drivers/md/dm-mpath.c&nbsp;&nbsp; 2010-12-=
13
09:16:31.358858000 +0200<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+++ b/drivers/md/dm-mpath.c&nbsp;&nbsp; 2010-12-=
13
09:16:31.796998000 +0200<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>@@ -1190,4 +1190,5 @@<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case SCSI_DH_OK:<=
o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; break;<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; case SCSI_DH_DEV_OFFLI=
NED:<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case SCSI_DH_NOSY=
S:<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; if
(!m-&gt;hw_handler_name) {<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>@@ -1252,7 +1253,15 @@<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;{<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pgpath *pg=
path
=3D (struct pgpath *) data;<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; int err;<o:p></o:p></s=
pan></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>-&nbsp;&nbsp;&nbsp;&nbsp; scsi_dh_activate(bdev_=
get_queue(pgpath-&gt;path.dev-&gt;bdev),<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; err =3D
scsi_dh_activate(bdev_get_queue(pgpath-&gt;path.dev-&gt;bdev),<o:p></o:p></=
span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; pg_init_done,
&amp;pgpath-&gt;path);<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; /*<o:p></o:p></span></=
p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp;  * If error is not
SCSI_DH_OK, we have not entered the scsi_dh H/W handler and did not call
pg_init_done - <o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp;  * need to call
pg_init_done directly.<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp;  */<o:p></o:p></span><=
/p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; if (err) <o:p></o:p></=
span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; pg_init_done(&amp;pgpath-&gt;path,
err);<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;}<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>diff -r -U 2 a/drivers/scsi/device_handler/scsi_=
dh.c
b/drivers/scsi/device_handler/scsi_dh.c<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>--- a/drivers/scsi/device_handler/scsi_dh.c&nbsp=
;&nbsp;&nbsp;&nbsp; 2010-12-13
09:16:31.616554000 +0200<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+++ b/drivers/scsi/device_handler/scsi_dh.c&nbsp=
;&nbsp;&nbsp;&nbsp; 2010-12-13
09:16:31.878170000 +0200<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>@@ -443,4 +443,9 @@<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; spin_unlock_irqre=
store(q-&gt;queue_lock,
flags);<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; if (sdev-&gt;sdev_stat=
e =3D=3D
SDEV_CANCEL ||<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
sdev-&gt;sdev_state =3D=3D SDEV_DEL ||<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
sdev-&gt;sdev_state =3D=3D SDEV_OFFLINE)<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; err
=3D SCSI_DH_DEV_OFFLINED;<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (err)<o:p></o:=
p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; return
err;<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>diff -r -U 2
a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/=
scsi_dh_rdac.c<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>--- a/drivers/scsi/device_handler/scsi_dh_rdac.c=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2010-12-13
09:16:31.747755000 +0200<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2010-12-13
09:16:31.912827000 +0200<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>@@ -665,4 +665,5 @@<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (fn)<o:p></o:p=
></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; fn(data,
err);<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<o:p></o=
:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;}<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><b><span style=3D'font-size:10.0pt;font-family:"Trebuc=
het MS","sans-serif";
color:#444444'>Menny Hamburger</span></b><span style=3D'font-size:8.0pt;
font-family:"Trebuchet MS","sans-serif";color:#444444'><o:p></o:p></span></=
p>

<p class=3DMsoNormal><span style=3D'font-size:8.0pt;font-family:"Trebuchet =
MS","sans-serif";
color:#444444'>Engineer<o:p></o:p></span></p>

<p class=3DMsoNormal><b><span style=3D'font-size:8.0pt;font-family:"Trebuch=
et MS","sans-serif";
color:#0085C3'>Dell</span></b><span style=3D'font-size:8.0pt;font-family:"T=
rebuchet MS","sans-serif";
color:#444444'> | IDC<b><o:p></o:p></b></span></p>

<p class=3DMsoNormal><b><span style=3D'font-size:8.0pt;font-family:"Trebuch=
et MS","sans-serif";
color:#444444'>office </span></b><span style=3D'font-size:8.0pt;font-family=
:"Trebuchet MS","sans-serif";
color:#444444'>+972 97698789<b>,&nbsp; fax </b>+972 97698889<b><o:p></o:p><=
/b></span></p>

<p class=3DMsoNormal><span style=3D'font-size:8.0pt;font-family:"Trebuchet =
MS","sans-serif";
color:#444444'>Dell IDC. 4 Hacharoshet St, Raanana 43657, Israel</span><spa=
n
style=3D'color:#1F497D'><o:p></o:p></span></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

--_000_D8C50530D6022F40A817A35C40CC06A7064AF923A3DUBX7MCDUB01E_--


--===============2786052642258559216==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2786052642258559216==--
