From: "Reilly, Stephen (MRO)" <Steve.Reilly@hp.com>
Subject: RE: regarding DM device for a single path.
Date: Thu, 4 Aug 2005 14:43:19 -0400
Message-ID: <E8C532D801BE5B479B28B626184E8CDD07C7F2FB@tayexc14.americas.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0866203976=="
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
To: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>, Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0866203976==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C59924.625CAB81"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C59924.625CAB81
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Did anyone respond to this...

=20

________________________________

From: Murthy, Narasimha Doraswamy (STSD)=20
Sent: Wednesday, August 03, 2005 10:21 AM
To: Alasdair G Kergon
Cc: device-mapper development; Reilly, Stephen (MRO)
Subject: regarding DM device for a single path.

=20

Hi Alasdair,

Kindly clarify on the following,

=20

1.	I tested your latest user space tools with 2.6.9-11.41 kernel.
Used the default created devices for multipathing. The path status is
getting updated appropriately for HSV200 arrays.  However the failback
functionality is not working for me. I have configure value for
"failback" variable in /etc/multipath.conf as zero for immediate
failback, but when the failed path in the original path group comes back
online, the IO is not failed back the old pathgroup.

=20

=20

2.	In yesterday's discussion, you mentioned that DM device nodes
will not be created for the physical devices which are having single
path.  Assuming one particular device had 2 paths and DM device was
created and used by the applications. While the system is rebooted for
some reasons, and if one of the paths for this device is lost, then the
subsequent reboot will not create the DM device as it sees only one path
for this device. And the DM device might be created only if the other
path comes back online and the HBA driver is rescanned for new devices.
This may not be desired multipathing behaviour, as the DM device does
not exist if we one path for the device.

=20

Thanks and regards

-Murthy

=20


------_=_NextPart_001_01C59924.625CAB81
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]--><o:SmartTagType
 namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags" =
name=3D"PersonName"
 downloadurl=3D"http://www.microsoft.com"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:"MS Sans Serif";}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal;
	font-family:"MS Sans Serif";
	color:windowtext;
	font-weight:normal;
	font-style:normal;
	text-decoration:none none;}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 @list l0
	{mso-list-id:235896059;
	mso-list-type:hybrid;
	mso-list-template-ids:509359278 67698703 67698713 67698715 67698703 =
67698713 67698715 67698703 67698713 67698715;}
@list l0:level1
	{mso-level-tab-stop:.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level2
	{mso-level-tab-stop:1.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level3
	{mso-level-tab-stop:1.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level4
	{mso-level-tab-stop:2.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level5
	{mso-level-tab-stop:2.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level6
	{mso-level-tab-stop:3.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level7
	{mso-level-tab-stop:3.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level8
	{mso-level-tab-stop:4.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level9
	{mso-level-tab-stop:4.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l1
	{mso-list-id:293215466;
	mso-list-template-ids:-1003182262;}
@list l2
	{mso-list-id:733352869;
	mso-list-template-ids:-1133615016;}
@list l2:level1
	{mso-level-start-at:2;
	mso-level-tab-stop:.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Did anyone respond to =
this&#8230;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font =
size=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'>

<hr size=3D2 width=3D"100%" align=3Dcenter tabindex=3D-1>

</span></font></div>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font =
size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'> =
<st1:PersonName
w:st=3D"on">Murthy, Narasimha Doraswamy</st1:PersonName> (STSD) <br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Wednesday, August =
03, 2005
10:21 AM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> Alasdair G Kergon<br>
<b><span style=3D'font-weight:bold'>Cc:</span></b> device-mapper =
development; <st1:PersonName
w:st=3D"on">Reilly, Stephen</st1:PersonName> (MRO)<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> regarding DM =
device for a
single path.</span></font><o:p></o:p></p>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Hi =
Alasdair,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Kindly clarify on the =
following,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<ol style=3D'margin-top:0in' start=3D1 type=3D1>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo3'><font size=3D2
     face=3D"MS Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"MS Sans Serif"'>I
     tested your latest user space tools with 2.6.9-11.41 kernel. Used =
the
     default created devices for multipathing. The path status is =
getting
     updated appropriately for HSV200 arrays. &nbsp;However the failback =
functionality
     is not working for me. I have configure value for =
&#8220;failback&#8221;
     variable in /etc/multipath.conf as zero for immediate failback, but =
when
     the failed path in the original path group comes back online, the =
IO is
     not failed back the old pathgroup.<o:p></o:p></span></font></li>
</ol>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<ol style=3D'margin-top:0in' start=3D2 type=3D1>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo3'><font size=3D2
     face=3D"MS Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"MS Sans Serif"'>In
     yesterday&#8217;s discussion, you mentioned that DM device nodes =
will not
     be created for the physical devices which are having single path. =
&nbsp;Assuming
     one particular device had 2 paths and DM device was created and =
used by
     the applications. While the system is rebooted for some reasons, =
and if
     one of the paths for this device is lost, then the subsequent =
reboot will
     not create the DM device as it sees only one path for this device. =
And the
     DM device might be created only if the other path comes back online =
and
     the HBA driver is rescanned for new devices. &nbsp;This may not be =
desired
     multipathing behaviour, as the DM device does not exist if we one =
path for
     the device.<o:p></o:p></span></font></li>
</ol>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Thanks and =
regards<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>-Murthy<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C59924.625CAB81--


--===============0866203976==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0866203976==--
