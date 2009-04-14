From: Kurt Bechstein <bkurt@bgsu.edu>
Subject: RE: Dell MD3000i issues with dm mp
Date: Tue, 14 Apr 2009 11:56:44 -0400
Message-ID: <D192143E8D8E6749B56F630ABC78B7331CEA46C3A5@MAIL3.bgsu.edu>
References: <D192143E8D8E6749B56F630ABC78B7331CEA46C2C5@MAIL3.bgsu.edu>
	<E463DF2B2E584B4A82673F53D62C2EF4669B59A6@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1937364097=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4669B59A6@cosmail01.lsi.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============1937364097==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D192143E8D8E6749B56F630ABC78B7331CEA46C3A5MAIL3bgsuedu_"

--_000_D192143E8D8E6749B56F630ABC78B7331CEA46C3A5MAIL3bgsuedu_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I actually tried doing that by doing a mkinitrd /boot/initrdfile -preload=
=3Dscsi_dh_rdac kernelversion and booted using the initrd and it still seem=
ed to crank out quite a few errors.  With doing it this way, should I still=
 expect to see a good deal of I/O errors or should they pretty sparse?

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Moger, Babu
Sent: Tuesday, April 14, 2009 11:38 AM
To: device-mapper development
Subject: [dm-devel] RE: Dell MD3000i issues with dm mp

Yes, this could happen during the boot where the scsi_dh_rdac handler is no=
t yet loaded. You might want to try adding scsi_dh_rdac in the initrd.  Thi=
s will help to cut short all your error messages. I don't see any problem w=
ith your multipath.conf.

Thanks
Babu Moger
________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Kurt Bechstein
Sent: Tuesday, April 14, 2009 9:54 AM
To: dm-devel@redhat.com
Subject: [dm-devel] Dell MD3000i issues with dm mp

Greetings everyone, I have a RHEL 5.3 host attached to two Dell MD3000i sto=
rage arrays via iscsi.  I'm having some interesting issues upon bootup in t=
his setup.  Between the two arrays I'm accessing 24 luns so after my iscsi =
service kicks in I get tons and tons of I/O error messages going across the=
 screen.  This can go on for 15-20 minutes or longer.  It would appear that=
 some I/O is being sent to the passive paths and they are returning errors.=
  It would seem the scsi layer is doing its thing to scan for partitions an=
d probably causing the I/O that is being seen.  Is there any way to suppres=
s/avoid this scenario?  Also, I thought I would post my multipath.conf file=
 just to have some other eyes have a look at it and make sure I'm not missi=
ng something obvious so that is below.  Thanks in advance!


devices {
        device {
               vendor                  "DELL"
               product                 "MD3000i"
               features                 "0"
               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
               hardware_handler        "1 rdac"
               path_grouping_policy    group_by_prio
               failback                immediate
               path_checker            rdac
               prio                     "rdac"

       }
}
multipaths {
        mulitpath {
                device {
                        vendor DELL
                        product MD3000i
                }
        }
}

--_000_D192143E8D8E6749B56F630ABC78B7331CEA46C3A5MAIL3bgsuedu_
Content-Type: text/html; charset="us-ascii"
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
xmlns:q=3D"http://schemas.xmlsoap.org/soap/envelope/" xmlns:D=3D"DAV:" xmln=
s:mt=3D"http://schemas.microsoft.com/sharepoint/soap/meetings/" xmlns:x2=3D=
"http://schemas.microsoft.com/office/excel/2003/xml" xmlns:ois=3D"http://sc=
hemas.microsoft.com/sharepoint/soap/ois/" xmlns:dir=3D"http://schemas.micro=
soft.com/sharepoint/soap/directory/" xmlns:ds=3D"http://www.w3.org/2000/09/=
xmldsig#" xmlns:dsp=3D"http://schemas.microsoft.com/sharepoint/dsp" xmlns:u=
dc=3D"http://schemas.microsoft.com/data/udc" xmlns:xsd=3D"http://www.w3.org=
/2001/XMLSchema" xmlns:sub=3D"http://schemas.microsoft.com/sharepoint/soap/=
2002/1/alerts/" xmlns:ec=3D"http://www.w3.org/2001/04/xmlenc#" xmlns:sp=3D"=
http://schemas.microsoft.com/sharepoint/" xmlns:sps=3D"http://schemas.micro=
soft.com/sharepoint/soap/" xmlns:xsi=3D"http://www.w3.org/2001/XMLSchema-in=
stance" xmlns:udcs=3D"http://schemas.microsoft.com/data/udc/soap" xmlns:udc=
xf=3D"http://schemas.microsoft.com/data/udc/xmlfile" xmlns:udcp2p=3D"http:/=
/schemas.microsoft.com/data/udc/parttopart" xmlns:wf=3D"http://schemas.micr=
osoft.com/sharepoint/soap/workflow/" xmlns:dsss=3D"http://schemas.microsoft=
.com/office/2006/digsig-setup" xmlns:dssi=3D"http://schemas.microsoft.com/o=
ffice/2006/digsig" xmlns:mdssi=3D"http://schemas.openxmlformats.org/package=
/2006/digital-signature" xmlns:mver=3D"http://schemas.openxmlformats.org/ma=
rkup-compatibility/2006" xmlns:m=3D"http://schemas.microsoft.com/office/200=
4/12/omml" xmlns:mrels=3D"http://schemas.openxmlformats.org/package/2006/re=
lationships" xmlns:spwp=3D"http://microsoft.com/sharepoint/webpartpages" xm=
lns:ex12t=3D"http://schemas.microsoft.com/exchange/services/2006/types" xml=
ns:ex12m=3D"http://schemas.microsoft.com/exchange/services/2006/messages" x=
mlns:pptsl=3D"http://schemas.microsoft.com/sharepoint/soap/SlideLibrary/" x=
mlns:spsl=3D"http://microsoft.com/webservices/SharePointPortalServer/Publis=
hedLinksService" xmlns:Z=3D"urn:schemas-microsoft-com:" xmlns:st=3D"&#1;" x=
mlns=3D"http://www.w3.org/TR/REC-html40">

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
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
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

<p class=3DMsoNormal><span style=3D'color:#1F497D'>I actually tried doing t=
hat by
doing a mkinitrd /boot/initrdfile &#8211;preload=3Dscsi_dh_rdac kernelversi=
on and
booted using the initrd and it still seemed to crank out quite a few
errors.&nbsp; With doing it this way, should I still expect to see a good d=
eal
of I/O errors or should they pretty sparse?<o:p></o:p></span></p>

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
<b>Sent:</b> Tuesday, April 14, 2009 11:38 AM<br>
<b>To:</b> device-mapper development<br>
<b>Subject:</b> [dm-devel] RE: Dell MD3000i issues with dm mp<o:p></o:p></s=
pan></p>

</div>

</div>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><span style=3D'font-size:10.0pt;font-family:"Arial","s=
ans-serif";
color:navy'>Yes, this could happen during the boot where the </span><span
lang=3DEN>scsi_dh_rdac handler is not yet loaded. You might want to try add=
ing
scsi_dh_rdac in the initrd. &nbsp;This will help to cut short all your erro=
r
messages. I don&#8217;t see any problem with your multipath.conf. &nbsp;<o:=
p></o:p></span></p>

<p class=3DMsoNormal><span lang=3DEN>&nbsp;</span><span style=3D'font-size:=
10.0pt;
font-family:"Arial","sans-serif";color:navy'><o:p></o:p></span></p>

<div>

<p class=3DMsoNormal><span style=3D'font-size:10.0pt;font-family:"Arial","s=
ans-serif";
color:navy'>Thanks</span><span style=3D'color:navy'><o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'font-size:10.0pt;font-family:"Arial","s=
ans-serif";
color:navy'>Babu Moger </span><o:p></o:p></p>

</div>

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
Of </b>Kurt Bechstein<br>
<b>Sent:</b> Tuesday, April 14, 2009 9:54 AM<br>
<b>To:</b> dm-devel@redhat.com<br>
<b>Subject:</b> [dm-devel] Dell MD3000i issues with dm mp</span><span
style=3D'font-size:12.0pt;font-family:"Times New Roman","serif"'><o:p></o:p=
></span></p>

</div>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Greetings everyone, I have a RHEL 5.3 host attached to=
 two
Dell MD3000i storage arrays via iscsi.&nbsp; I&#8217;m having some interest=
ing
issues upon bootup in this setup.&nbsp; Between the two arrays I&#8217;m
accessing 24 luns so after my iscsi service kicks in I get tons and tons of=
 I/O
error messages going across the screen.&nbsp; This can go on for 15-20 minu=
tes
or longer.&nbsp; It would appear that some I/O is being sent to the passive
paths and they are returning errors.&nbsp; It would seem the scsi layer is
doing its thing to scan for partitions and probably causing the I/O that is
being seen.&nbsp; Is there any way to suppress/avoid this scenario?&nbsp; A=
lso,
I thought I would post my multipath.conf file just to have some other eyes =
have
a look at it and make sure I&#8217;m not missing something obvious so that =
is
below.&nbsp; Thanks in advance!<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>devices {<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device {<o:=
p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;DELL&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
product&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&quot;MD3000i&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;0&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;/sbin/scsi_id -g -u -s /block/%n&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;
&quot;/sbin/mpath_prio_rdac /dev/%n&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
hardware_handler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;1 rdac&quo=
t;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
path_grouping_policy&nbsp;&nbsp;&nbsp; group_by_prio<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;
immediate<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;
rdac<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
prio&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;rdac&quot;<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>}<o:p></o:p></p>

<p class=3DMsoNormal>multipaths {<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mulitpath {=
<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
device {<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;
vendor DELL<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;
product MD3000i<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p=
></p>

<p class=3DMsoNormal>}<o:p></o:p></p>

</div>

</body>

</html>

--_000_D192143E8D8E6749B56F630ABC78B7331CEA46C3A5MAIL3bgsuedu_--


--===============1937364097==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1937364097==--
