From: "Charles Batchelor" <Charles.Batchelor@glasgow.newsquest.co.uk>
Subject: Fdisk Multipath Disks on NetApp / IBM N series SAN with
	intention for Oracle 10G RAC OCR and Voting Disks
Date: Thu, 25 Oct 2007 13:28:29 +0100
Message-ID: <A5CA8967E48A23468EE061D2E5AAAE760207A6B5@gexcnt05.gl.ad.newsquest.co.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1591016477=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is a multi-part message in MIME format.

--===============1591016477==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C81702.8CB05357"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C81702.8CB05357
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

=20

I am having a problem with a correct method for fdisk raw partitions in
preparation for Oracle OCR. I know that you cant fdisk the /dev/mapper
or /dev/dm-1 disks directly. Currently we have the following setup

=20

mpath11 (360a98000433543364734454a6f533061)

[size=3D300 MB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]

\_ round-robin 0 [prio=3D8][active]

 \_ 3:0:0:1 sdb 8:16  [active][ready]

 \_ 4:0:0:1 sdl 8:176 [active][ready]

\_ round-robin 0 [prio=3D2][enabled]

 \_ 3:0:1:1 sdg 8:96  [active][ready]

 \_ 4:0:1:1 sdq 65:0  [active][ready]

=20

I have fdisk'ed the sbd (underlying) disk and rebooted to bring
multipath into sync.

=20

/dev/mpath now has the following entries

=20

lrwxrwxrwx   1 root root    7 Oct 25 11:53 mpath11 -> ../dm-0

lrwxrwxrwx   1 root root    7 Oct 25 11:53 mpath11p1 -> ../dm-9

=20

/dev/mapper

=20

brw-rw----   1 oracle oinstall 253,  4 Oct 25 11:53 mpath11

brw-rw----   1 oracle oinstall 253,  5 Oct 25 11:53 mpath11p1

=20

I have tried addressing the=20

=20

I have specified the raw devices /etc/sysconfig/rawdevices using the
major minor id's

=20

/dev/raw/raw5 253 5

=20

However when trying to exchange data between the shared luns

=20

Dd if=3D/etc/hosts of=3D/dev/raw/raw5 I am getting an error.=20

=20

However if I do the following dd if=3D/etc/hosts of=3D/dev/mpath/mpath11p1
the transfer works successfully.=20

=20

This has come about as each of the servers is reporting the /mpath's
back as different numbers. The /dev/dm-1 etc are all fine, how do I
bring the mpath back into sync, e.g. mpath1 across all boxes. Also am I
going about things the right way or fundamentally flawed?

=20

Regards

=20

Charles Batchelor

=20

Charles Batchelor

Senior Technical Specialist

* Herald and Times Group

        200 Renfield Street

        Glasgow G2 3QB

        Scotland

*  Tel:  0141 - 302 7011

       Fax: 0141 - 302 7901
*  Email: charles.batchelor@glasgow.newsquest.co.uk

=20

Please take the time to fill out the IT Satisfaction survey form @
http://intranet/informationtechnology/itsurvey.shtml
<http://intranet/IT/survey.asp>=20

=20

=20


--------------------------------------------------------------------
This email has been scanned for viruses and other threats  using Newsquest'=
s Ironport email filters

This e-mail, including any attachment, is private and confidential.=20
It should not be read, copied, disclosed or otherwise used by any person ot=
her than the intended recipient(s). =20
If you have received this e-mail in error, please notify the sender immedia=
tely.=20
Newsquest reserves the right to monitor e-mails in accordance with the Tele=
communications (Lawful Business Practice)=20
(Interception of Communications) Regulations 2000.
=20
Newsquest Limited.=20
Registered in England, number 3105111 .  Registered office: 58 Church Stree=
t, Weybridge, Surrey KT13 8DP
--------------------------------------------------------------------

------_=_NextPart_001_01C81702.8CB05357
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" xmlns=3D"http://ww=
w=2Ew3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"place"/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"country-region"/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"City"/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"Street"/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"address"/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"PersonName"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:"Albertus Medium";
	panose-1:0 0 0 0 0 0 0 0 0 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
p=2EMsoHeader, li.MsoHeader, div.MsoHeader
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
p=2EMsoFooter, li.MsoFooter, div.MsoFooter
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
p=2ECheckboxes, li.Checkboxes, div.Checkboxes
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
span.EmailStyle20
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
 /* Page Definitions */
 @page
	{mso-endnote-separator:url("cid:header.htm\@01C8170A.EE5D8FC0") es;
	mso-endnote-continuation-separator:url("cid:header.htm\@01C8170A.EE5D8FC0"=
) ecs;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;
	mso-footer:url("cid:header.htm\@01C8170A.EE5D8FC0") f1;}
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

<body lang=3DEN-GB link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>I am having a problem with a correct method for fdisk raw
partitions in preparation for Oracle OCR. I know that you cant fdisk the
/dev/mapper or /dev/dm-1 disks directly. Currently we have the following se=
tup<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>mpath11 (360a98000433543364734454a6f533061)<o:p></o:p></=

span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>[size=3D300 MB][features=3D&quot;1
queue_if_no_path&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>\_ round-robin 0 [prio=3D8][active]<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;\_ 3:0:0:1 sdb 8:16&nbsp; [active][ready]<o:p></o:=
p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;\_ 4:0:0:1 sdl 8:176 [active][ready]<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>\_ round-robin 0 [prio=3D2][enabled]<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;\_ 3:0:1:1 sdg 8:96&nbsp; [active][ready]<o:p></o:=
p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>&nbsp;\_ 4:0:1:1 sdq 65:0&nbsp; [active][ready]<o:p></o:=
p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>I have fdisk&#8217;ed the sbd (underlying) disk and rebo=
oted
to bring multipath into sync.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>/dev/mpath now has the following entries<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>lrwxrwxrwx&nbsp;&nbsp; 1 root root&nbsp;&nbsp;&nbsp; 7 O=
ct
25 11:53 mpath11 -&gt; ../dm-0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>lrwxrwxrwx&nbsp;&nbsp; 1 root root&nbsp;&nbsp;&nbsp; 7 O=
ct
25 11:53 mpath11p1 -&gt; ../dm-9<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>/dev/mapper<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>brw-rw----&nbsp;&nbsp; 1 oracle oinstall 253,&nbsp; 4 Oc=
t 25
11:53 mpath11<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>brw-rw----&nbsp;&nbsp; 1 oracle oinstall 253,&nbsp; 5 Oc=
t 25
11:53 mpath11p1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>I have tried addressing the <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>I have specified the raw devices /etc/sysconfig/rawdevic=
es using
the major minor id&#8217;s<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>/dev/raw/raw5 253 5<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>However when trying to exchange data between the shared =
luns<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>Dd if=3D/etc/hosts of=3D/dev/raw/raw5 I am getting an er=
ror. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>However if I do the following dd if=3D/etc/hosts
of=3D/dev/mpath/mpath11p1 the transfer works successfully. <o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>This has come about as each of the servers is reporting =
the
/mpath&#8217;s back as different numbers. The /dev/dm-1 etc are all fine, h=
ow
do I bring the mpath back into sync, e.g. mpath1 across all boxes. Also am I
going about things the right way or fundamentally flawed?<o:p></o:p></span>=
</font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>Regards<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'>Charles Batchelor<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt=
:auto'><font
size=3D2 color=3Dpurple face=3DTahoma><span style=3D'font-size:10.0pt;font-=
family:Tahoma;
color:purple'>Charles Batchelor</span></font><o:p></o:p></p>

<p class=3DMsoNormal style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt=
:auto'><font
size=3D2 color=3Dpurple face=3DTahoma><span style=3D'font-size:10.0pt;font-=
family:Tahoma;
color:purple'>Senior Technical Specialist</span></font><o:p></o:p></p>

<p class=3DMsoNormal style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt=
:auto'><font
size=3D5 color=3Dpurple face=3DWingdings><span style=3D'font-size:18.0pt;fo=
nt-family:
Wingdings;color:purple'>+</span></font><font size=3D2 color=3Dnavy face=3DT=
ahoma><span
style=3D'font-size:10.0pt;font-family:Tahoma;color:navy'> Herald and Times =
Group</span></font><o:p></o:p></p>

<p class=3DMsoNormal style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt=
:auto'><font
size=3D2 color=3Dnavy face=3DTahoma><span style=3D'font-size:10.0pt;font-fa=
mily:Tahoma;
color:navy'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <st1:Street w:st=3D"=
on"><st1:address
 tabIndex=3D"0"
 style=3D"BACKGROUND-POSITION: left bottom; BACKGROUND-IMAGE: url(res://iet=
ag.dll/#34/#1001); BACKGROUND-REPEAT: repeat-x"
 w:st=3D"on">200 Renfield Street</st1:address></st1:Street></span></font><f=
ont
face=3DArial><span style=3D'font-family:Arial'><o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt=
:auto'><font
size=3D3 face=3DArial><span style=3D'font-size:12.0pt;font-family:Arial'>&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></font><font size=3D2 color=3Dnavy face=3DTahoma><span style=3D'font=
-size:10.0pt;
font-family:Tahoma;color:navy'>&nbsp;<st1:City w:st=3D"on"><st1:place w:st=
=3D"on">Glasgow</st1:place></st1:City>
G2 3QB</span></font><font face=3DArial><span style=3D'font-family:Arial'><o=
:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt=
:auto'><font
size=3D3 face=3DArial><span style=3D'font-size:12.0pt;font-family:Arial'>&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></font><st1:country-region w:st=3D"on"><st1:place w:st=3D"on"><font =
size=3D2
  color=3Dnavy face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Ta=
homa;
  color:navy'>Scotland</span></font></st1:place></st1:country-region><font
face=3DArial><span style=3D'font-family:Arial'><o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt=
:auto'><font
size=3D4 color=3Dpurple face=3DWingdings><span style=3D'font-size:14.0pt;fo=
nt-family:
Wingdings;color:purple'>(</span></font><font size=3D2 color=3Dnavy
face=3D"Albertus Medium"><span style=3D'font-size:10.0pt;font-family:"Alber=
tus Medium";
color:navy'> </span></font><font face=3DArial><span style=3D'font-family:Ar=
ial'>&nbsp;</span></font><font
size=3D2 color=3Dpurple face=3D"Albertus Medium"><span style=3D'font-size:1=
0=2E0pt;
font-family:"Albertus Medium";color:purple'>Tel:</span></font><font size=3D2
color=3Dnavy face=3D"Albertus Medium"><span style=3D'font-size:10.0pt;font-=
family:
"Albertus Medium";color:navy'> &nbsp;0141 - 302 7011</span></font><o:p></o:=
p></p>

<p class=3DMsoNormal style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt=
:auto'><font
size=3D3 face=3DArial><span style=3D'font-size:12.0pt;font-family:Arial'>&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></font><font size=3D2 color=3Dpurple face=3D"Albertus Medium"><span
style=3D'font-size:10.0pt;font-family:"Albertus Medium";color:purple'>Fax:<=
/span></font><font
size=3D2 color=3Dnavy face=3D"Albertus Medium"><span style=3D'font-size:10.=
0pt;
font-family:"Albertus Medium";color:navy'> 0141 - 302 7901</span></font><fo=
nt
face=3DArial><span style=3D'font-family:Arial'><br>
</span></font><font size=3D4 color=3Dpurple face=3DWingdings><span style=3D=
'font-size:
14.0pt;font-family:Wingdings;color:purple'>:</span></font><font size=3D2
color=3Dnavy face=3D"Albertus Medium"><span style=3D'font-size:10.0pt;font-=
family:
"Albertus Medium";color:navy'>&nbsp; </span></font><font size=3D2 color=3Dp=
urple
face=3D"Albertus Medium"><span style=3D'font-size:10.0pt;font-family:"Alber=
tus Medium";
color:purple'>Email:</span></font><font size=3D2 color=3Dnavy face=3D"Alber=
tus Medium"><span
style=3D'font-size:10.0pt;font-family:"Albertus Medium";color:navy'> </span=
></font><st1:PersonName
w:st=3D"on"><font size=3D2 color=3Dnavy face=3DTahoma><span style=3D'font-s=
ize:10.0pt;
 font-family:Tahoma;color:navy'>charles.batchelor@glasgow.newsquest.co.uk</=
span></font></st1:PersonName><o:p></o:p></p>

<p class=3DMsoNormal style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt=
:auto'><font
size=3D2 face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial'><o=
:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt=
:auto'><font
size=3D1 color=3Dpurple face=3DTahoma><span style=3D'font-size:9.0pt;font-f=
amily:Tahoma;
color:purple'>Please take the time to fill out the IT Satisfaction survey f=
orm
@ <a href=3D"http://intranet/informationtechnology/itsurvey.shtml">http://i=
ntranet/informationtechnology/itsurvey.shtml</a></span></font><font
size=3D1 color=3Dnavy face=3DTahoma><span style=3D'font-size:9.0pt;font-fam=
ily:Tahoma;
color:navy'><a href=3D"http://intranet/IT/survey.asp"
title=3D"http://intranet/IT/survey.asp"></a></span></font><font size=3D2
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial'><o:p></o:p>=
</span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>&nbsp;</span><o:p></o:p></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<pre>
--------------------------------------------------------------------
This email has been scanned for viruses and other threats  using Newsquest'=
s Ironport email filters

This e-mail, including any attachment, is private and confidential.=20
It should not be read, copied, disclosed or otherwise used by any person ot=
her than the intended recipient(s). =20
If you have received this e-mail in error, please notify the sender immedia=
tely.=20
Newsquest reserves the right to monitor e-mails in accordance with the Tele=
communications (Lawful Business Practice)=20
(Interception of Communications) Regulations 2000.
=20
Newsquest Limited.=20
Registered in England, number 3105111 .  Registered office: 58 Church Stree=
t, Weybridge, Surrey KT13 8DP
--------------------------------------------------------------------
</pre></body>

</html>

------_=_NextPart_001_01C81702.8CB05357--


--===============1591016477==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1591016477==--
