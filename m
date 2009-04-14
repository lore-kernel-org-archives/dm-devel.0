From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: Dell MD3000i issues with dm mp
Date: Tue, 14 Apr 2009 13:33:56 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4669B5B48@cosmail01.lsi.com>
References: <D192143E8D8E6749B56F630ABC78B7331CEA46C2C5@MAIL3.bgsu.edu>
	<E463DF2B2E584B4A82673F53D62C2EF4669B59A6@cosmail01.lsi.com>
	<D192143E8D8E6749B56F630ABC78B7331CEA46C3A5@MAIL3.bgsu.edu>
	<E463DF2B2E584B4A82673F53D62C2EF4669B59E1@cosmail01.lsi.com>
	<D192143E8D8E6749B56F630ABC78B7331CEA46C46E@MAIL3.bgsu.edu>
	<E463DF2B2E584B4A82673F53D62C2EF4669B5A91@cosmail01.lsi.com>
	<D192143E8D8E6749B56F630ABC78B7331CEA46C4F9@MAIL3.bgsu.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0665011187=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D192143E8D8E6749B56F630ABC78B7331CEA46C4F9@MAIL3.bgsu.edu>
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

--===============0665011187==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_E463DF2B2E584B4A82673F53D62C2EF4669B5B48cosmail01lsicom_"

--_000_E463DF2B2E584B4A82673F53D62C2EF4669B5B48cosmail01lsicom_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

I don=92t see any apparent reason for these messages(=93rdac Dettached=94) =
by looking at the log. There are some issci session failure messages.  I do=
n=92t understand those messages very well.  You may have to ask some iscsi =
experts to look at it.

________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Kurt Bechstein
Sent: Tuesday, April 14, 2009 12:44 PM
To: device-mapper development
Subject: [dm-devel] RE: Dell MD3000i issues with dm mp

No devices were detached during this sequence at least not physically anywa=
ys.

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Moger, Babu
Sent: Tuesday, April 14, 2009 1:38 PM
To: device-mapper development
Subject: [dm-devel] RE: Dell MD3000i issues with dm mp

I am seeing few =93rdac Dettached=94 messages. There are only messages I am=
 bit concerned about (unless you disconnected some devices purposefully dur=
ing the test). I am not concerned about other messages.

Thanks
Babu Moger
________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Kurt Bechstein
Sent: Tuesday, April 14, 2009 12:10 PM
To: device-mapper development
Subject: [dm-devel] RE: Dell MD3000i issues with dm mp

Here is a snippet of my /var/log/messages from this morning=92s boot sequen=
ce after iscsi started and some of the output I=92m seeing.  Seems like qui=
te a bit to me.

http://pastebin.com/d97ae1ad

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Moger, Babu
Sent: Tuesday, April 14, 2009 12:12 PM
To: device-mapper development
Subject: [dm-devel] RE: Dell MD3000i issues with dm mp

I would think it should be pretty sparse.

Thanks
Babu Moger
________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Kurt Bechstein
Sent: Tuesday, April 14, 2009 10:57 AM
To: device-mapper development
Subject: [dm-devel] RE: Dell MD3000i issues with dm mp

I actually tried doing that by doing a mkinitrd /boot/initrdfile =96preload=
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
s will help to cut short all your error messages. I don=92t see any problem=
 with your multipath.conf.

Thanks
Babu Moger
________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Kurt Bechstein
Sent: Tuesday, April 14, 2009 9:54 AM
To: dm-devel@redhat.com
Subject: [dm-devel] Dell MD3000i issues with dm mp

Greetings everyone, I have a RHEL 5.3 host attached to two Dell MD3000i sto=
rage arrays via iscsi.  I=92m having some interesting issues upon bootup in=
 this setup.  Between the two arrays I=92m accessing 24 luns so after my is=
csi service kicks in I get tons and tons of I/O error messages going across=
 the screen.  This can go on for 15-20 minutes or longer.  It would appear =
that some I/O is being sent to the passive paths and they are returning err=
ors.  It would seem the scsi layer is doing its thing to scan for partition=
s and probably causing the I/O that is being seen.  Is there any way to sup=
press/avoid this scenario?  Also, I thought I would post my multipath.conf =
file just to have some other eyes have a look at it and make sure I=92m not=
 missing something obvious so that is below.  Thanks in advance!


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

--_000_E463DF2B2E584B4A82673F53D62C2EF4669B5B48cosmail01lsicom_
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
/schemas.microsoft.com/data/udc/parttopart" xmlns:st=3D"&#1;" xmlns:st1=3D"=
urn:schemas-microsoft-com:office:smarttags" xmlns=3D"http://www.w3.org/TR/R=
EC-html40"
xmlns:ns2=3D"http://schemas.microsoft.com/sharepoint/soap/workflow/"
xmlns:ns3=3D"http://schemas.microsoft.com/office/2006/digsig-setup"
xmlns:ns4=3D"http://schemas.microsoft.com/office/2006/digsig"
xmlns:ns5=3D"http://schemas.openxmlformats.org/package/2006/digital-signatu=
re"
xmlns:ns6=3D"http://schemas.openxmlformats.org/markup-compatibility/2006"
xmlns:ns0=3D"http://schemas.microsoft.com/office/2004/12/omml"
xmlns:ns7=3D"http://schemas.openxmlformats.org/package/2006/relationships"
xmlns:ns8=3D"http://microsoft.com/sharepoint/webpartpages"
xmlns:ns9=3D"http://schemas.microsoft.com/exchange/services/2006/types"
xmlns:ns10=3D"http://schemas.microsoft.com/exchange/services/2006/messages"
xmlns:ns11=3D"http://schemas.microsoft.com/sharepoint/soap/SlideLibrary/"
xmlns:ns12=3D"http://microsoft.com/webservices/SharePointPortalServer/Publi=
shedLinksService"
xmlns:ns13=3D"urn:schemas-microsoft-com:">

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
	font-family:Arial;
	color:navy;}
span.EmailStyle21
	{mso-style-type:personal;
	font-family:Calibri;
	color:#1F497D;}
span.EmailStyle22
	{mso-style-type:personal;
	font-family:Arial;
	color:navy;}
span.EmailStyle23
	{mso-style-type:personal;
	font-family:Calibri;
	color:#1F497D;}
span.EmailStyle24
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
10.0pt;font-family:Arial;color:navy'>I don=92t see any apparent reason for =
these
messages(=93</span></font><font face=3D"Courier New"><span lang=3DEN
style=3D'font-family:"Courier New"'>rdac Dettached=94)</span></font><font s=
ize=3D2
color=3Dnavy face=3DArial><span lang=3DEN style=3D'font-size:10.0pt;font-fa=
mily:Arial;
color:navy'> </span></font><font size=3D2 color=3Dnavy face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;color:navy'>by looking at the l=
og. There
are some issci session failure messages.=A0 I don=92t understand those mess=
ages
very well. =A0You may have to ask some iscsi experts to look at it. =A0<o:p=
></o:p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt;font-family:"Times New Roman"'><o:p>&nbsp;</o:p></span></font></p>

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
style=3D'font-weight:bold'>On Behalf Of </span></b>Kurt Bechstein<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Tuesday, April 14, 200=
9
12:44 PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> <st1:PersonName w:st=3D"=
on">device-mapper
 development</st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> [dm-devel] RE: Dell
MD3000i issues with dm mp</span></font><font size=3D3 face=3D"Times New Rom=
an"><span
style=3D'font-size:12.0pt;font-family:"Times New Roman"'><o:p></o:p></span>=
</font></p>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>No devices were detached during th=
is
sequence at least not physically anyways.<o:p></o:p></span></font></p>

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
style=3D'font-weight:bold'>On Behalf Of </span></b>Moger, Babu<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Tuesday, April 14, 200=
9 1:38
PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> <st1:PersonName w:st=3D"=
on">device-mapper
 development</st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> [dm-devel] RE: Dell
MD3000i issues with dm mp<o:p></o:p></span></font></p>

</div>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>I am seeing few =93</span></font><font
face=3D"Courier New"><span lang=3DEN style=3D'font-family:"Courier New"'>rd=
ac
Dettached=94 messages. There are only messages I am bit concerned about (un=
less
you disconnected some devices purposefully during the test). I am not conce=
rned
about other messages.</span></font><font size=3D2 color=3Dnavy face=3DArial=
><span
lang=3DEN style=3D'font-size:10.0pt;font-family:Arial;color:navy'> </span><=
/font><font
size=3D2 color=3Dnavy face=3DArial><span style=3D'font-size:10.0pt;font-fam=
ily:Arial;
color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Thanks</span></font><font color=3Dnavy=
><span
style=3D'color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Babu Moger </span></font><o:p></o:p></=
p>

</div>

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
style=3D'font-weight:bold'>On Behalf Of </span></b>Kurt Bechstein<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Tuesday, April 14, 200=
9
12:10 PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> <st1:PersonName w:st=3D"=
on">device-mapper
 development</st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> [dm-devel] RE: Dell
MD3000i issues with dm mp</span></font><font size=3D3 face=3D"Times New Rom=
an"><span
style=3D'font-size:12.0pt;font-family:"Times New Roman"'><o:p></o:p></span>=
</font></p>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>Here is a snippet of my
/var/log/messages from this morning=92s boot sequence after iscsi started a=
nd
some of the output I=92m seeing.&nbsp; Seems like quite a bit to me.<o:p></=
o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>http://pastebin.com/d97ae1ad<o:p><=
/o:p></span></font></p>

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
style=3D'font-weight:bold'>On Behalf Of </span></b>Moger, Babu<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Tuesday, April 14, 200=
9
12:12 PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> <st1:PersonName w:st=3D"=
on">device-mapper
 development</st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> [dm-devel] RE: Dell
MD3000i issues with dm mp<o:p></o:p></span></font></p>

</div>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>I would think it should be </span></fo=
nt><font
color=3D"#1f497d"><span style=3D'color:#1F497D'>pretty sparse. </span></fon=
t><font
size=3D2 color=3Dnavy face=3DArial><span style=3D'font-size:10.0pt;font-fam=
ily:Arial;
color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Thanks</span></font><font color=3Dnavy=
><span
style=3D'color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Babu Moger </span></font><o:p></o:p></=
p>

</div>

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
style=3D'font-weight:bold'>On Behalf Of </span></b>Kurt Bechstein<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Tuesday, April 14, 200=
9
10:57 AM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> <st1:PersonName w:st=3D"=
on">device-mapper
 development</st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> [dm-devel] RE: Dell
MD3000i issues with dm mp</span></font><font size=3D3 face=3D"Times New Rom=
an"><span
style=3D'font-size:12.0pt;font-family:"Times New Roman"'><o:p></o:p></span>=
</font></p>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3D"#1f497d" face=3DCalibri><span
style=3D'font-size:11.0pt;color:#1F497D'>I actually tried doing that by doi=
ng a
mkinitrd /boot/initrdfile =96preload=3Dscsi_dh_rdac kernelversion and boote=
d using
the initrd and it still seemed to crank out quite a few errors.&nbsp; With
doing it this way, should I still expect to see a good deal of I/O errors o=
r
should they pretty sparse?<o:p></o:p></span></font></p>

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
style=3D'font-weight:bold'>On Behalf Of </span></b>Moger, Babu<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Tuesday, April 14, 200=
9
11:38 AM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> <st1:PersonName w:st=3D"=
on">device-mapper
 development</st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> [dm-devel] RE: Dell
MD3000i issues with dm mp<o:p></o:p></span></font></p>

</div>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Yes, this could happen during the boot
where the </span></font><span lang=3DEN>scsi_dh_rdac handler is not yet loa=
ded.
You might want to try adding scsi_dh_rdac in the initrd. &nbsp;This will <s=
t1:PersonName
w:st=3D"on">help</st1:PersonName> to cut short all your error messages. I d=
on=92t
see any problem with your multipath.conf. &nbsp;<o:p></o:p></span></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span lang=3DEN style=3D=
'font-size:
11.0pt'>&nbsp;</span></font><font size=3D2 color=3Dnavy face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;color:navy'><o:p></o:p></span><=
/font></p>

<div>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Thanks</span></font><font color=3Dnavy=
><span
style=3D'color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Babu Moger </span></font><o:p></o:p></=
p>

</div>

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
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'> dm-devel=
-bounces@redhat.com
[mailto:dm-devel-bounces@redhat.com] <b><span style=3D'font-weight:bold'>On
Behalf Of </span></b>Kurt Bechstein<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Tuesday, April 14, 200=
9 9:54
AM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> dm-devel@redhat.com<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> [dm-devel] Dell MD3=
000i
issues with dm mp</span></font><font size=3D3 face=3D"Times New Roman"><spa=
n
style=3D'font-size:12.0pt;font-family:"Times New Roman"'><o:p></o:p></span>=
</font></p>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>Greetings
everyone, I have a RHEL 5.3 host attached to two Dell MD3000i storage array=
s
via iscsi.&nbsp; I=92m having some interesting issues upon bootup in this
setup.&nbsp; Between the two arrays I=92m accessing 24 luns so after my isc=
si
service kicks in I get tons and tons of I/O error messages going across the
screen.&nbsp; This can go on for 15-20 minutes or longer.&nbsp; It would ap=
pear
that some I/O is being sent to the passive paths and they are returning
errors.&nbsp; It would seem the scsi layer is doing its thing to scan for
partitions and probably causing the I/O that is being seen.&nbsp; Is there =
any
way to suppress/avoid this scenario?&nbsp; Also, I thought I would post my
multipath.conf file just to have some other eyes have a look at it and make
sure I=92m not missing something obvious so that is below.&nbsp; Thanks in =
advance!<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>devices
{<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
device {<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;DELL&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
product&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&quot;MD3000i&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;0&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;/sbin/scsi_id -g -u -s /block/%n&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;
&quot;/sbin/mpath_prio_rdac /dev/%n&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
hardware_handler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;1 rdac&quo=
t;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
path_grouping_policy&nbsp;&nbsp;&nbsp; group_by_prio<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;
immediate<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;
rdac<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;
prio&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;rdac&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>multipaths
{<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
mulitpath {<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;
device {<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
vendor DELL<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
product MD3000i<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;
}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DCalibri><span style=3D'font-size=
:11.0pt'>}<o:p></o:p></span></font></p>

</div>

</body>

</html>

--_000_E463DF2B2E584B4A82673F53D62C2EF4669B5B48cosmail01lsicom_--


--===============0665011187==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0665011187==--
