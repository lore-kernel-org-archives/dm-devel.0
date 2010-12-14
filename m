From: <Menny_Hamburger@Dell.com>
Subject: Re: [PATCH 1/1]: missing call to pg_init_done causes I/O
 to be hung forever
Date: Tue, 14 Dec 2010 08:38:19 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A7064AF92675@DUBX7MCDUB01.EMEA.DELL.COM>
References: <D8C50530D6022F40A817A35C40CC06A7064AF923A3@DUBX7MCDUB01.EMEA.DELL.COM>
	<E463DF2B2E584B4A82673F53D62C2EF4F53CB7E3@cosmail01.lsi.com>
	<D8C50530D6022F40A817A35C40CC06A7064AF92581@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_D8C50530D6022F40A817A35C40CC06A7064AF92675DUBX7MCDUB01E_"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A7064AF92581@DUBX7MCDUB01.EMEA.DELL.COM>
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

--_004_D8C50530D6022F40A817A35C40CC06A7064AF92675DUBX7MCDUB01E_
Content-Type: multipart/alternative;
	boundary="_000_D8C50530D6022F40A817A35C40CC06A7064AF92675DUBX7MCDUB01E_"

--_000_D8C50530D6022F40A817A35C40CC06A7064AF92675DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi

Attached is the updated patch file.
I added testing instructions for non ISCSI environments.

From looking into the code,  I have a question on a path that may cause the=
 same problems:
In rdac_activate, when (h->lun_state =3D=3D RDAC_LUN_UNOWNED) the callback =
function is also not called.
Could there be a scenario, where this would have the same effects?

Thanks,
Menny

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Hamburger, Menny
Sent: 14 December, 2010 09:32
To: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/1]: missing call to pg_init_done causes I/=
O to be hung forever

Hi,

I tried that as one of my options when I worked on this issue - it works, h=
owever it seemed to general to me back then since it required testing addit=
ional areas such as other H/W handlers and perhaps other md modules. I do n=
ot have the required resources for testing this, however I would gladly sen=
d the other version of the patch.

Best Regards,
Menny



From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Moger, Babu
Sent: 13 December, 2010 20:03
To: device-mapper development
Subject: Re: [dm-devel] [PATCH 1/1]: missing call to pg_init_done causes I/=
O to be hung forever

Menny,
   Yes, I agree there is a problem. Wouldn't it be simpler if you could han=
dle everything scsi_dh.c..  See my response below..
Thanks
Babu

________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Menny_Hamburger@Dell.com
Sent: Monday, December 13, 2010 9:35 AM
To: dm-devel@redhat.com
Subject: [dm-devel] [PATCH 1/1]: missing call to pg_init_done causes I/O to=
 be hung forever

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

If you are not doing anything special then I would let default take care of=
 it.  No need of this change..

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
You can move this to scsi_dh.c


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
You can change it something like below..
      if (err) {
                         if(fn)
fn(data, err);
            return err;
          }



--_000_D8C50530D6022F40A817A35C40CC06A7064AF92675DUBX7MCDUB01E_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]-->
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
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
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
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.EmailStyle18
	{mso-style-type:personal;
	font-family:"Arial","sans-serif";
	color:navy;}
span.EmailStyle19
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
span.EmailStyle20
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
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

<p class=3DMsoNormal><span style=3D'color:#1F497D'>Hi <o:p></o:p></span></p=
>

<p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span>=
</p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>Attached is the updated =
patch
file.<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>I added testing instruct=
ions for
non ISCSI environments.<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span>=
</p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>From looking into the
code,&nbsp; I have a question on a path that may cause the same problems:<o=
:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>In rdac_activate, when
(h-&gt;lun_state =3D=3D RDAC_LUN_UNOWNED) the callback function is also not=
 called.<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>Could there be a scenari=
o, where
this would have the same effects?<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span>=
</p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>Thanks,<o:p></o:p></span=
></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>Menny<o:p></o:p></span><=
/p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span>=
</p>

<div>

<div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0in =
0in 0in'>

<p class=3DMsoNormal><b><span style=3D'font-size:10.0pt;font-family:"Tahoma=
","sans-serif"'>From:</span></b><span
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] <b>On Beha=
lf Of
</b>Hamburger, Menny<br>
<b>Sent:</b> 14 December, 2010 09:32<br>
<b>To:</b> dm-devel@redhat.com<br>
<b>Subject:</b> Re: [dm-devel] [PATCH 1/1]: missing call to pg_init_done ca=
uses
I/O to be hung forever<o:p></o:p></span></p>

</div>

</div>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>Hi,<o:p></o:p></span></p=
>

<p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span>=
</p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>I tried that as one of m=
y
options when I worked on this issue &#8211; it works, however it seemed to
general to me back then since it required testing additional areas such as
other H/W handlers and perhaps other md modules. I do not have the required
resources for testing this, however I would gladly send the other version o=
f
the patch.<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span>=
</p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>Best Regards,<o:p></o:p>=
</span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>Menny <o:p></o:p></span>=
</p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span>=
</p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span>=
</p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'><o:p>&nbsp;</o:p></span>=
</p>

<div>

<div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0in =
0in 0in'>

<p class=3DMsoNormal><b><span style=3D'font-size:10.0pt;font-family:"Tahoma=
","sans-serif"'>From:</span></b><span
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] <b>On Beha=
lf
Of </b>Moger, Babu<br>
<b>Sent:</b> 13 December, 2010 20:03<br>
<b>To:</b> device-mapper development<br>
<b>Subject:</b> Re: [dm-devel] [PATCH 1/1]: missing call to pg_init_done ca=
uses
I/O to be hung forever<o:p></o:p></span></p>

</div>

</div>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><span style=3D'font-size:10.0pt;font-family:"Arial","s=
ans-serif";
color:navy'>Menny,<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'font-size:10.0pt;font-family:"Arial","s=
ans-serif";
color:navy'>&nbsp;&nbsp; Yes, I agree there is a problem. Wouldn&#8217;t it=
 be
simpler if you could handle everything scsi_dh.c..&nbsp; See my response
below.. <o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'font-size:10.0pt;font-family:"Arial","s=
ans-serif";
color:navy'>Thanks<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'font-size:10.0pt;font-family:"Arial","s=
ans-serif";
color:navy'>Babu<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'font-size:10.0pt;font-family:"Arial","s=
ans-serif";
color:navy'>&nbsp; <o:p></o:p></span></p>

<div style=3D'border:none;border-left:solid blue 1.5pt;padding:0in 0in 0in =
4.0pt'>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><span
style=3D'font-size:12.0pt;font-family:"Times New Roman","serif"'>

<hr size=3D2 width=3D"100%" align=3Dcenter>

</span></div>

<p class=3DMsoNormal><b><span style=3D'font-size:10.0pt;font-family:"Tahoma=
","sans-serif"'>From:</span></b><span
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] <b>On Beha=
lf
Of </b>Menny_Hamburger@Dell.com<br>
<b>Sent:</b> Monday, December 13, 2010 9:35 AM<br>
<b>To:</b> dm-devel@redhat.com<br>
<b>Subject:</b> [dm-devel] [PATCH 1/1]: missing call to pg_init_done causes=
 I/O
to be hung forever</span><span style=3D'font-size:12.0pt;font-family:"Times=
 New Roman","serif"'><o:p></o:p></span></p>

</div>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

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
font-family:"Courier New"'>&nbsp; dd if=3D/dev/dm-0 of=3D/dev/zero bs=3D8k =
count=3D1000000
&amp;<o:p></o:p></span></p>

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
&nbsp;&nbsp;&nbsp;
break;<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; case SCSI_DH_DEV_OFFLI=
NED:<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Arial","sans-serif";color:navy'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Arial","sans-serif";color:navy'>If you are not doing anything
special then I would let default take care of it.&nbsp; No need of this
change..<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Arial","sans-serif";color:navy'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case SCSI_DH_NOSY=
S:<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
if (!m-&gt;hw_handler_name) {<o:p></o:p></span></p>

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
font-family:"Courier New"'>-&nbsp;&nbsp;&nbsp;&nbsp;
scsi_dh_activate(bdev_get_queue(pgpath-&gt;path.dev-&gt;bdev),<o:p></o:p></=
span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; err =3D scsi_dh_activa=
te(bdev_get_queue(pgpath-&gt;path.dev-&gt;bdev),<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;
pg_init_done, &amp;pgpath-&gt;path);<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; /*<o:p></o:p></span></=
p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; * If error is not
SCSI_DH_OK, we have not entered the scsi_dh H/W handler and did not call
pg_init_done - <o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; * need to call pg_init=
_done
directly.<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; */<o:p></o:p></span></=
p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp; if (err) <o:p></o:p></=
span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;
pg_init_done(&amp;pgpath-&gt;path, err);<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;}<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New";color:navy'>You can move this to scsi_dh.c<o:p></=
o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Arial","sans-serif";color:navy'><o:p>&nbsp;</o:p></span></p>

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
;&nbsp;&nbsp;&nbsp;
2010-12-13 09:16:31.616554000 +0200<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+++
b/drivers/scsi/device_handler/scsi_dh.c&nbsp;&nbsp;&nbsp;&nbsp; 2010-12-13
09:16:31.878170000 +0200<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>@@ -443,4 +443,9 @@<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
spin_unlock_irqrestore(q-&gt;queue_lock, flags);<o:p></o:p></span></p>

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
;&nbsp;&nbsp;
err =3D SCSI_DH_DEV_OFFLINED;<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>+<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Arial","sans-serif";color:navy'>You can change it something li=
ke
below..<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (err)<span
style=3D'color:navy'> {</span><o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Arial","sans-serif";color:navy'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp; if(fn)<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'margin-left:77.25pt;text-indent:30.75pt;text-=
autospace:
none'><span style=3D'font-size:10.0pt;font-family:"Arial","sans-serif";
color:navy'>fn(data, err);<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
return err;<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Arial","sans-serif";color:navy'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;
}<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Arial","sans-serif";color:navy'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><span style=3D'font-size=
:10.0pt;
font-family:"Arial","sans-serif";color:navy'><o:p>&nbsp;</o:p></span></p>

</div>

</div>

</body>

</html>

--_000_D8C50530D6022F40A817A35C40CC06A7064AF92675DUBX7MCDUB01E_--

--_004_D8C50530D6022F40A817A35C40CC06A7064AF92675DUBX7MCDUB01E_
Content-Type: application/octet-stream; name="missing_pg_init_done.patch"
Content-Description: missing_pg_init_done.patch
Content-Disposition: attachment; filename="missing_pg_init_done.patch";
	size=2530; creation-date="Tue, 14 Dec 2010 08:11:37 GMT";
	modification-date="Tue, 14 Dec 2010 07:59:41 GMT"
Content-Transfer-Encoding: base64

RnJvbTogTWVubnkgSGFtYnVyZ2VyIDxNZW5ueV9IYW1idXJnZXJARGVsbC5jb20+ClN1YmplY3Q6
IFtzY3NpX2RoXTogY2FsbCBjYWxsYmFjayBmdW5jdGlvbiBpbiBzY3NpX2RoX2FjdGl2YXRlIGRp
cmVjdGx5IG9uIGFuIGVycm9yCkJ1Z3ppbGxhOiA2NDUzNDMKCldoZW4gc2NzaV9kaF9hY3RpdmF0
ZSByZXR1cm5zIFNDU0lfREhfTk9TWVMgdGhlIEgvVyBoYW5kbGVyIGNhbGxiYWNrIGlzIG5vdCBj
YWxsZWQsIHBnX2luaXRfZG9uZSBpcyBub3QgY2FsbGVkIGluIAp0aGUgbXVsdGlwYXRoIGxheWVy
IGFuZCBwZW5kaW5nIEkvTyBpcyByZXF1ZXVlZCBmb3JldmVyOyB0aGlzIHNpdHVhdGlvbiBjYXVz
ZXMgYWxsIHVzZXJsYW5kIHByb2Nlc3NlcyBjdXJyZW50bHkgcGVyZm9ybWluZyBJL08Kb24gdGhl
IGRldmljZSB0byBJL08gaGFuZy4gQSBzaW1pbGFyIHNpdHVhdGlvbiBvY2N1cnMgd2hlbiB0aGUg
ZGV2aWNlIGhhcyB0cmFuc2l0aW9uZWQgdG8gU0RFVl9DQU5DRUwvU0RFVl9ERUwgYW5kIHRoZSBk
ZXZpY2UKaGFuZGxlciBkYXRhIGhhZCBub3QgeWV0IGJlZW4gZGVsZXRlZC4KClRoZSBlYXNpZXN0
IHdheSB0byByZXByb2R1Y2UgdGhpcyBpcyBpbiBhbiBJU0NTSSBlbnZpcm9ubWVudDoKICBkZCBp
Zj0vZGV2L2RtLTAgb2Y9L2Rldi96ZXJvIGJzPThrIGNvdW50PTEwMDAwMDAgJgogIC9ldGMvaW5p
dC5kL2lzY3NpIHN0b3AKSW4gdGhpcyBleGFtcGxlLCBkZCB3aWxsIEkvTyBoYW5nIGZvcmV2ZXIg
YW5kIHRoZSBvbmx5IHdheSB0byByZWxlYXNlIGl0IHdpbGwgYmUgdG8gcmVib290IHRoZSBtYWNo
aW5lCgpPbiBhIG5vbiBJU0NTSSBlbnZpcm9ubWVudCwgdGhlIGZvbGxvd2luZyBiYXNoIHNjcmlw
dGxldCBjYW4gYmUgYXBwbGllZDoKZG1fZGV2cz0kKGxzIC9zeXMvYmxvY2svIHwgZ3JlcCBkbS0g
fCB4YXJncykKZm9yIGRtX2RldiBpbiAkZG1fZGV2czsgZG8KICBkZXZpY2VzPSQobHMgL3N5cy9i
bG9jay8kZG1fZGV2L3NsYXZlcykKICBmb3IgZGV2aWNlIGluICRkZXZpY2VzOyBkbwogICAgZWNo
byAxID4gL3N5cy9ibG9jay8kZGV2aWNlL2RldmljZS9kZWxldGUKICBkb25lCmRvbmUKClRoaXMg
cGF0Y2ggY2FsbHMgdGhlIGNhbGxiYWNrIGZ1bmN0aW9uIGZyb20gc2NzaV9kaF9hY3RpdmF0ZSB3
aGVuIGVpdGhlciB0aGUgc2NzaV9kaCBpbnRlcm5hbCBkYXRhIGhhcyBhbHJlYWR5IGJlZW4gZGVs
ZXRlZAooU0NTSV9ESF9OT1NZUykgb3IgaXQgaXMgYWJvdXQgdG8gYmUgZGVsZXRlZCAoU0RFVl9D
QU5DRUwvU0RFVl9ERUwpLgoKTm90ZToKVGhpcyBwYXRjaCBpcyBvdmVyIFJIRUw1LjUuCldoZW4g
cnVubmluZyBhbiB1cHN0cmVhbSBrZXJuZWwsIHRoZSBhYm92ZSBzY2VuYXJpbyBtYXkgbm90IG9j
Y3VyIGJlY2F1c2UgdGhlIHJlcXVlc3QgcXVldWUgaXMgYWJvcnRlZCBpbiBkbS1tcGF0aC5jOmZh
aWxfcGF0aC4KVGhpcyBwYXRjaCBtYWtlcyBzdXJlIHRoZSBwcm9ibGVtIGRvZXMgbm90IG9jY3Vy
IGF0IGFsbCwgcmF0aGVyIHRoYW4gaGFuZGxpbmcgaXQgd2hlbiBpdCBkb2VzLiBJbiBhZGRpdGlv
biwgaXQgc2VlbXMgdG9vIHJpc2t5IHRvIGFwcGx5IApyZXF1ZXN0IHF1ZXVlIGFib3J0IGZ1bmN0
aW9uYWxpdHkgb24gUkhFTDUgYXQgdGhpcyBzdGFnZS4KCmRpZmYgLXIgLVUgMiBhL2RyaXZlcnMv
bWQvZG0tbXBhdGguYyBiL2RyaXZlcnMvbWQvZG0tbXBhdGguYwotLS0gYS9kcml2ZXJzL21kL2Rt
LW1wYXRoLmMJMjAxMC0xMi0xNCAwOTo1OTo0MC43OTM3MjUwMDAgKzAyMDAKKysrIGIvZHJpdmVy
cy9tZC9kbS1tcGF0aC5jCTIwMTAtMTItMTQgMDk6NTk6NDAuOTQ5OTk2MDAwICswMjAwCkBAIC0x
MTkwLDQgKzExOTAsNSBAQAogCWNhc2UgU0NTSV9ESF9PSzoKIAkJYnJlYWs7CisJY2FzZSBTQ1NJ
X0RIX0RFVl9PRkZMSU5FRDoKIAljYXNlIFNDU0lfREhfTk9TWVM6CiAJCWlmICghbS0+aHdfaGFu
ZGxlcl9uYW1lKSB7CmRpZmYgLXIgLVUgMiBhL2RyaXZlcnMvc2NzaS9kZXZpY2VfaGFuZGxlci9z
Y3NpX2RoLmMgYi9kcml2ZXJzL3Njc2kvZGV2aWNlX2hhbmRsZXIvc2NzaV9kaC5jCi0tLSBhL2Ry
aXZlcnMvc2NzaS9kZXZpY2VfaGFuZGxlci9zY3NpX2RoLmMJMjAxMC0xMi0xNCAwOTo1OTo0MC44
NzkxNDAwMDAgKzAyMDAKKysrIGIvZHJpdmVycy9zY3NpL2RldmljZV9oYW5kbGVyL3Njc2lfZGgu
YwkyMDEwLTEyLTE0IDA5OjU5OjQxLjA0NTU1ODAwMCArMDIwMApAQCAtNDQzLDYgKzQ0MywxNCBA
QAogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUocS0+cXVldWVfbG9jaywgZmxhZ3MpOwogCi0JaWYg
KGVycikKKwlpZiAoc2Rldi0+c2Rldl9zdGF0ZSA9PSBTREVWX0NBTkNFTCB8fAorCSAgICBzZGV2
LT5zZGV2X3N0YXRlID09IFNERVZfREVMIHx8CisJICAgIHNkZXYtPnNkZXZfc3RhdGUgPT0gU0RF
Vl9PRkZMSU5FKQorCQllcnIgPSBTQ1NJX0RIX0RFVl9PRkZMSU5FRDsKKworCWlmIChlcnIpIHsK
KwkJaWYgKGZuKQorCQkJZm4oZm5fZGF0YSwgZXJyKTsKIAkJcmV0dXJuIGVycjsKKwl9CiAKIAlp
ZiAoc2NzaV9kaC0+YWN0aXZhdGUpCg==

--_004_D8C50530D6022F40A817A35C40CC06A7064AF92675DUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_004_D8C50530D6022F40A817A35C40CC06A7064AF92675DUBX7MCDUB01E_--
