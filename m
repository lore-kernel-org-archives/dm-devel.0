From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: [PATCH 1/1]: missing call to pg_init_done causes I/O
 to be hung forever
Date: Tue, 14 Dec 2010 09:42:16 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4F544063C@cosmail01.lsi.com>
References: <D8C50530D6022F40A817A35C40CC06A7064AF923A3@DUBX7MCDUB01.EMEA.DELL.COM>
	<E463DF2B2E584B4A82673F53D62C2EF4F53CB7E3@cosmail01.lsi.com>
	<D8C50530D6022F40A817A35C40CC06A7064AF92581@DUBX7MCDUB01.EMEA.DELL.COM>
	<D8C50530D6022F40A817A35C40CC06A7064AF92675@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0036402058139097951=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A7064AF92675@DUBX7MCDUB01.EMEA.DELL.COM>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0036402058139097951==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_E463DF2B2E584B4A82673F53D62C2EF4F544063Ccosmail01lsicom_"

--_000_E463DF2B2E584B4A82673F53D62C2EF4F544063Ccosmail01lsicom_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

I don=92t see this problem in rdac_activate.  When h->lun_state =3D=3D RDAC=
_LUN_UNOWNED, then send_mode_select will take care of calling callback func=
tion.

You might want to separate the patches into two (one for dm_mpath.c and one=
 for scsi_dh.c), because you are changing two modules. That is what the mai=
ntainers expect. Otherwise patches look good to me.


________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Menny_Hamburger@dell.com
Sent: Tuesday, December 14, 2010 2:38 AM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/1]: missing call to pg_init_done causes I/=
O to be hung forever

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

I tried that as one of my options when I worked on this issue =96 it works,=
 however it seemed to general to me back then since it required testing add=
itional areas such as other H/W handlers and perhaps other md modules. I do=
 not have the required resources for testing this, however I would gladly s=
end the other version of the patch.

Best Regards,
Menny



From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Moger, Babu
Sent: 13 December, 2010 20:03
To: device-mapper development
Subject: Re: [dm-devel] [PATCH 1/1]: missing call to pg_init_done causes I/=
O to be hung forever

Menny,
   Yes, I agree there is a problem. Wouldn=92t it be simpler if you could h=
andle everything scsi_dh.c..  See my response below..
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



--_000_E463DF2B2E584B4A82673F53D62C2EF4F544063Ccosmail01lsicom_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" xmlns:p=3D"urn:schemas-m=
icrosoft-com:office:powerpoint" xmlns:a=3D"urn:schemas-microsoft-com:office=
:access" xmlns:dt=3D"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:s=3D"=
uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882" xmlns:rs=3D"urn:schemas-microsof=
t-com:rowset" xmlns:z=3D"#RowsetSchema" xmlns:b=3D"urn:schemas-microsoft-co=
m:office:publisher" xmlns:ss=3D"urn:schemas-microsoft-com:office:spreadshee=
t" xmlns:c=3D"urn:schemas-microsoft-com:office:component:spreadsheet" xmlns=
:odc=3D"urn:schemas-microsoft-com:office:odc" xmlns:oa=3D"urn:schemas-micro=
soft-com:office:activation" xmlns:html=3D"http://www.w3.org/TR/REC-html40" =
xmlns:q=3D"http://schemas.xmlsoap.org/soap/envelope/" xmlns:rtc=3D"http://m=
icrosoft.com/officenet/conferencing" xmlns:D=3D"DAV:" xmlns:Repl=3D"http://=
schemas.microsoft.com/repl/" xmlns:mt=3D"http://schemas.microsoft.com/share=
point/soap/meetings/" xmlns:x2=3D"http://schemas.microsoft.com/office/excel=
/2003/xml" xmlns:ppda=3D"http://www.passport.com/NameSpace.xsd" xmlns:ois=
=3D"http://schemas.microsoft.com/sharepoint/soap/ois/" xmlns:dir=3D"http://=
schemas.microsoft.com/sharepoint/soap/directory/" xmlns:ds=3D"http://www.w3=
.org/2000/09/xmldsig#" xmlns:dsp=3D"http://schemas.microsoft.com/sharepoint=
/dsp" xmlns:udc=3D"http://schemas.microsoft.com/data/udc" xmlns:xsd=3D"http=
://www.w3.org/2001/XMLSchema" xmlns:sub=3D"http://schemas.microsoft.com/sha=
repoint/soap/2002/1/alerts/" xmlns:ec=3D"http://www.w3.org/2001/04/xmlenc#"=
 xmlns:sp=3D"http://schemas.microsoft.com/sharepoint/" xmlns:sps=3D"http://=
schemas.microsoft.com/sharepoint/soap/" xmlns:xsi=3D"http://www.w3.org/2001=
/XMLSchema-instance" xmlns:udcs=3D"http://schemas.microsoft.com/data/udc/so=
ap" xmlns:udcxf=3D"http://schemas.microsoft.com/data/udc/xmlfile" xmlns:udc=
p2p=3D"http://schemas.microsoft.com/data/udc/parttopart" xmlns:st=3D"&#1;" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" xmlns=3D"http://ww=
w.w3.org/TR/REC-html40"
xmlns:ns0=3D"http://schemas.microsoft.com/office/2004/12/omml">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dwindows-125=
2">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]--><o:SmartTagType
 namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags" name=3D"Person=
Name"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--a:link
	{mso-style-priority:99;}
span.MSOHYPERLINK
	{mso-style-priority:99;}
a:visited
	{mso-style-priority:99;}
span.MSOHYPERLINKFOLLOWED
	{mso-style-priority:99;}

 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:Calibri;}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal;
	font-family:Calibri;
	color:windowtext;}
span.EmailStyle18
	{mso-style-type:personal;
	font-family:Arial;
	color:navy;}
span.EmailStyle19
	{mso-style-type:personal;
	font-family:Calibri;
	color:#1F497D;}
span.EmailStyle20
	{mso-style-type:personal;
	font-family:Calibri;
	color:#1F497D;}
span.EmailStyle21
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.Section1
	{page:Section1;}
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

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>I don=92t see this problem in </span><=
/font><font
color=3D"#1f497d"><span style=3D'color:#1F497D'>rdac_activate. =A0When h-&g=
t;lun_state
=3D=3D RDAC_LUN_UNOWNED, then send_mode_select will take care of calling ca=
llback
function.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>You might want to separate the pat=
ches
into two (one for dm_mpath.c and one for scsi_dh.c), because you are changi=
ng
two modules. That is what the maintainers expect. Otherwise patches look go=
od
to me.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>=A0=A0 </span></font><font size=3D=
2
color=3Dnavy face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial=
;
color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div style=3D'border:none;border-left:solid blue 1.5pt;padding:0in 0in 0in =
4.0pt'>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font siz=
e=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt;font-family:"Times=
 New Roman"'>

<hr size=3D2 width=3D"100%" align=3Dcenter tabindex=3D-1>

</span></font></div>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span style=3D'font-si=
ze:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] <b><span
style=3D'font-weight:bold'>On Behalf Of </span></b>Menny_Hamburger@dell.com=
<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Tuesday, December 14, =
2010
2:38 AM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> dm-devel@redhat.com<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> Re: [dm-devel] [PAT=
CH
1/1]: missing call to pg_init_done causes I/O to be hung forever</span></fo=
nt><font
size=3D3 face=3D"Times New Roman"><span style=3D'font-size:12.0pt;font-fami=
ly:"Times New Roman"'><o:p></o:p></span></font></p>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Hi <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Attached is the updated patch file=
.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>I added testing instructions for n=
on
ISCSI environments.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>From looking into the code,&nbsp; =
I have
a question on a path that may cause the same problems:<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>In rdac_activate, when (h-&gt;lun_=
state
=3D=3D RDAC_LUN_UNOWNED) the callback function is also not called.<o:p></o:=
p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Could there be a scenario, where t=
his
would have the same effects?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Thanks,<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Menny<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<div>

<div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0in =
0in 0in'>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span style=3D'font-si=
ze:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] <b><span
style=3D'font-weight:bold'>On Behalf Of </span></b>Hamburger, Menny<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> 14 December, 2010 09:3=
2<br>
<b><span style=3D'font-weight:bold'>To:</span></b> dm-devel@redhat.com<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> Re: [dm-devel] [PAT=
CH
1/1]: missing call to pg_init_done causes I/O to be hung forever<o:p></o:p>=
</span></font></p>

</div>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>I tried that as one of my options =
when I
worked on this issue =96 it works, however it seemed to general to me back =
then
since it required testing additional areas such as other H/W handlers and
perhaps other md modules. I do not have the required resources for testing
this, however I would gladly send the other version of the patch.<o:p></o:p=
></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Best Regards,<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Menny <o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<div>

<div style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0in =
0in 0in'>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span style=3D'font-si=
ze:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] <b><span
style=3D'font-weight:bold'>On Behalf Of </span></b><st1:PersonName w:st=3D"=
on">Moger,
 Babu</st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> 13 December, 2010 20:0=
3<br>
<b><span style=3D'font-weight:bold'>To:</span></b> <st1:PersonName w:st=3D"=
on">device-mapper
 development</st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> Re: [dm-devel] [PAT=
CH
1/1]: missing call to pg_init_done causes I/O to be hung forever<o:p></o:p>=
</span></font></p>

</div>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Menny,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>&nbsp;&nbsp; Yes, I agree there is a
problem. Wouldn=92t it be simpler if you could handle everything
scsi_dh.c..&nbsp; See my response below.. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Thanks<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Babu<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>&nbsp; <o:p></o:p></span></font></p>

<div style=3D'border:none;border-left:solid blue 1.5pt;padding:0in 0in 0in =
4.0pt'>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font siz=
e=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt;font-family:"Times=
 New Roman"'>

<hr size=3D2 width=3D"100%" align=3Dcenter>

</span></font></div>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span style=3D'font-si=
ze:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] <b><span
style=3D'font-weight:bold'>On Behalf Of </span></b>Menny_Hamburger@Dell.com=
<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Monday, December 13, 2=
010
9:35 AM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> dm-devel@redhat.com<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> [dm-devel] [PATCH 1=
/1]:
missing call to pg_init_done causes I/O to be hung forever</span></font><fo=
nt
size=3D3 face=3D"Times New Roman"><span style=3D'font-size:12.0pt;font-fami=
ly:"Times New Roman"'><o:p></o:p></span></font></p>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>When scsi_dh_activate
returns SCSI_DH_NOSYS the H/W handler callback is not called, pg_init_done =
is
not called in <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>the multipath layer an=
d
pending I/O is requeued forever; this situation causes all userland process=
es
currently performing I/O<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>on the device to I/O h=
ang. A
similar situation occurs when the device has transitioned to
SDEV_CANCEL/SDEV_DEL and the device<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>handler data had not y=
et
been deleted.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'><o:p>&nbsp;</o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>The easiest way to rep=
roduce
this is in an ISCSI environment:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp; dd if=3D/dev/dm=
-0
of=3D/dev/zero bs=3D8k count=3D1000000 &amp;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp; /etc/init.d/isc=
si
stop<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>In this example, dd wi=
ll I/O
hang forever and the only way to release it will be to reboot the machine<o=
:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'><o:p>&nbsp;</o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>This patch calls
pg_init_done directly from the mpath code when the scsi_dh_activate returns=
 a
non SCSI_DH_OK error.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'><o:p>&nbsp;</o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>Note:<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>The patch is over RHEL=
5.5.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>When running an upstre=
am
kernel, the above scenario may not occur because the request queue is abort=
ed
in dm-mpath.c:fail_path.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>This patch makes sure =
the
problem does not occur at all, rather than handling it when it does. In
addition, it seems too risky to apply <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>request queue abort
functionality on RHEL5 at this stage.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'><o:p>&nbsp;</o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>diff -r -U 2
a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>---
a/drivers/md/dm-mpath.c&nbsp;&nbsp; 2010-12-13 09:16:31.358858000 +0200<o:p=
></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+++
b/drivers/md/dm-mpath.c&nbsp;&nbsp; 2010-12-13 09:16:31.796998000 +0200<o:p=
></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>@@ -1190,4 +1190,5 @@<=
o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;
case SCSI_DH_OK:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
break;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp;
case SCSI_DH_DEV_OFFLINED:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 color=3Dn=
avy
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial;color:navy'>=
<o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 color=3Dn=
avy
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial;color:navy'>=
If you
are not doing anything special then I would let default take care of it.&nb=
sp;
No need of this change..<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 color=3Dn=
avy
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial;color:navy'>=
<o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;
case SCSI_DH_NOSYS:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
if (!m-&gt;hw_handler_name) {<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>@@ -1252,7 +1253,15 @@=
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;{<o:p></o:p></sp=
an></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;
struct pgpath *pgpath =3D (struct pgpath *) data;<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp;
int err;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>-&nbsp;&nbsp;&nbsp;&nb=
sp;
scsi_dh_activate(bdev_get_queue(pgpath-&gt;path.dev-&gt;bdev),<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp;
err =3D scsi_dh_activate(bdev_get_queue(pgpath-&gt;path.dev-&gt;bdev),<o:p>=
</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
pg_init_done, &amp;pgpath-&gt;path);<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp; /*<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp; *
If error is not SCSI_DH_OK, we have not entered the scsi_dh H/W handler and=
 did
not call pg_init_done - <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp; *
need to call pg_init_done directly.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp; */<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp; if
(err) <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
pg_init_done(&amp;pgpath-&gt;path, err);<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;}<o:p></o:p></sp=
an></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 color=3Dn=
avy
face=3D"Courier New"><span style=3D'font-size:10.0pt;font-family:"Courier N=
ew";
color:navy'>You can move this to scsi_dh.c<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 color=3Dn=
avy
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial;color:navy'>=
<o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>diff -r -U 2
a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_=
dh.c<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>---
a/drivers/scsi/device_handler/scsi_dh.c&nbsp;&nbsp;&nbsp;&nbsp; 2010-12-13
09:16:31.616554000 +0200<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+++
b/drivers/scsi/device_handler/scsi_dh.c&nbsp;&nbsp;&nbsp;&nbsp; 2010-12-13
09:16:31.878170000 +0200<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>@@ -443,4 +443,9 @@<o:=
p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;
spin_unlock_irqrestore(q-&gt;queue_lock, flags);<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp; if
(sdev-&gt;sdev_state =3D=3D SDEV_CANCEL ||<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp;
&nbsp;&nbsp;&nbsp; sdev-&gt;sdev_state =3D=3D SDEV_DEL ||<o:p></o:p></span>=
</font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp;
&nbsp;&nbsp;&nbsp; sdev-&gt;sdev_state =3D=3D SDEV_OFFLINE)<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
err =3D SCSI_DH_DEV_OFFLINED;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>+<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 color=3Dn=
avy
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial;color:navy'>=
You can
change it something like below..<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;
if (err)<font color=3Dnavy><span style=3D'color:navy'> {</span></font><o:p>=
</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 color=3Dn=
avy
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial;color:navy'>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp; if(fn)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:77.25pt;text-indent:30.75pt;text-=
autospace:
none'><font size=3D2 color=3Dnavy face=3DArial><span style=3D'font-size:10.=
0pt;
font-family:Arial;color:navy'>fn(data, err);<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
return err;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 color=3Dn=
avy
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial;color:navy'>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 color=3Dn=
avy
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial;color:navy'>=
<o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 color=3Dn=
avy
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial;color:navy'>=
<o:p>&nbsp;</o:p></span></font></p>

</div>

</div>

</div>

</body>

</html>

--_000_E463DF2B2E584B4A82673F53D62C2EF4F544063Ccosmail01lsicom_--


--===============0036402058139097951==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0036402058139097951==--
