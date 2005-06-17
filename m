From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: RE: regarding path failback using HSV110 array.
Date: Fri, 17 Jun 2005 15:11:59 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA00220F911@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C57320.D04A4B27"
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
To: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C57320.D04A4B27
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_002_01C57320.D04A4B27"


------_=_NextPart_002_01C57320.D04A4B27
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

In the previous logs, the multipath daemon wasn't running. Attached is
the new log file, which has the path checker logs too.

-Murthy

=20

________________________________

From: Murthy, Narasimha Doraswamy (STSD)=20
Sent: Friday, June 17, 2005 1:02 PM
To: 'dm-devel@redhat.com'
Subject: regarding path failback using HSV110 array.

=20

Hi Alasdair,

As per yesterday's teleconf, I am sending the snapshot of the
/var/log/messages, which has the messages logged when testing the basic
failback functionality.  The testing is conducted on the host with RHEL
U1 and single controller of HP Storageworks HSV110 array. As each HSV110
controller has 2 ports, we effectively see 2 paths per lun. I am using
0.4.5.44 version of multipath tools. =20

=20

Following is the observation during testing the path failback.

=20

a) When the path is made unavailable (/dev/sdd) for a logical device
"mp1" on a  multipath target, the status of the path becomes
[faulty][active]

=20

mp1

[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]

\_ round-robin 0 [active][best]

  \_ 0:0:0:1 sda  8:0     [faulty][active]

\_ round-robin 0 [enabled]

  \_ 1:0:0:1 sdd  8:48    [ready][active]

=20

b) When an dd is executed on /dev/mapper/mp1 (dd if=3D/dev/zero
of=3D/dev/devmapper/mp1), the state of the paths is as follows

mp1

[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]

\_ round-robin 0 [enabled]

  \_ 0:0:0:1 sda  8:0     [faulty][failed]

\_ round-robin 0 [active][best]

  \_ 1:0:0:1 sdd  8:48    [ready ][active]

=20

=20

c) Now if the path (/dev/sda) is made available for the same logical
device, the status is as follows

mp1

[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]

\_ round-robin 0 [enabled]

  \_ 0:0:0:1 sda  8:0     [ready ][failed]

\_ round-robin 0 [active][best]

  \_ 1:0:0:1 sdd  8:48    [ready ][active]

=20

Note the path "/dev/sda" has become [ready][failed] not [ready][active].
For this to change to [ready][active], "multipath -v0" needs to be
executed manually.

=20

d) Now if path "/dev/sdd" is made unavailable, then if "dd" is run on
/dev/mapper/mp1, it returns with input/output error, as none of the path
will be in [ready][active] state. The following is the state now:

=20

mp1

[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]

\_ round-robin 0 [enabled][best]

  \_ 0:0:0:1 sda  8:0     [ready ][failed]

\_ round-robin 0 [enabled]

  \_ 1:0:0:1 sdd  8:48    [faulty][failed]

=20

=20

If "multipath -v0" executed from the command prompt the states get
updated properly as

=20

mp1

[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]

\_ round-robin 0 [active][best]

  \_ 0:0:0:1 sda  8:0     [ready ][active]

\_ round-robin 0 [enabled]

  \_ 1:0:0:1 sdd  8:48    [faulty][active]

=20

After this I will be able to do IO using "dd".   How do we make the path
state update properly with out manually invoking "multipath -v0"?=20

I am not sure on how to get the debug build of multipath and multipathd
binaries, if the information in the messages.txt is insufficient, I need
to test with the debug build and send the new log.

=20

Any help in resolving this problem is appreciated.

=20

Thanks and regards

Murthy

=20


------_=_NextPart_002_01C57320.D04A4B27
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
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:"MS Sans Serif";
	panose-1:0 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Microsoft Sans Serif";
	panose-1:2 11 6 4 2 2 2 2 2 4;}
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
	font-family:"Microsoft Sans Serif";
	color:navy;
	font-weight:normal;
	font-style:normal;
	text-decoration:none none;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3D"Microsoft Sans =
Serif"><span
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif";color:navy'>In the
previous logs, the multipath daemon wasn&#8217;t running. Attached is =
the new
log file, which has the path checker logs =
too.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3D"Microsoft Sans =
Serif"><span
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif";color:navy'>-Murthy<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3D"Microsoft Sans =
Serif"><span
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif";color:navy'><o:p>&nbsp;</o:p></span></font></p>

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
<b><span style=3D'font-weight:bold'>Sent:</span></b> Friday, June 17, =
2005 1:02 PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> '<st1:PersonName =
w:st=3D"on">dm-devel@redhat.com</st1:PersonName>'<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> regarding path =
failback
using HSV110 array.</span></font><o:p></o:p></p>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>Hi =
Alasdair,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>As per yesterday&#8217;s =
teleconf, I am
sending the snapshot of the /var/log/messages, which has the messages =
logged
when testing the basic failback functionality. &nbsp;The testing is =
conducted on
the host with RHEL U1 and single controller of HP Storageworks HSV110 =
array. As
each HSV110 controller has 2 ports, we effectively see 2 paths per lun. =
I am
using 0.4.5.44 version of multipath tools. =
&nbsp;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>Following is the observation =
during
testing the path failback.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>a) When the path is made =
unavailable
(/dev/sdd) for a logical device &#8220;mp1&#8221; on a &nbsp;multipath =
target,
the status of the path becomes =
[faulty][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>mp1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>[size=3D1
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span style=3D'font-size:11.0pt;color:black'>\_
round-robin 0 [active][best]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>&nbsp; \_
0:0:0:1 sda&nbsp; 8:0&nbsp;&nbsp;&nbsp;&nbsp; =
[faulty][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span style=3D'font-size:11.0pt;color:black'>\_
round-robin 0 [enabled]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>&nbsp; \_
1:0:0:1 sdd&nbsp; 8:48&nbsp;&nbsp;&nbsp; =
[ready][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>b) When an dd is executed on
/dev/mapper/mp1 (dd if=3D/dev/zero of=3D/dev/devmapper/mp1), the state =
of the paths
is as follows<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>mp1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>[size=3D1
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span style=3D'font-size:11.0pt;color:black'>\_
round-robin 0 [enabled]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>&nbsp; \_
0:0:0:1 sda&nbsp; 8:0&nbsp;&nbsp;&nbsp;&nbsp; =
[faulty][failed]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span style=3D'font-size:11.0pt;color:black'>\_
round-robin 0 [active][best]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>&nbsp; \_
1:0:0:1 sdd&nbsp; 8:48&nbsp;&nbsp;&nbsp; [ready =
][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>c) Now if the path (/dev/sda) is =
made
available for the same logical device, the status is as =
follows<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>mp1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>[size=3D1
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span style=3D'font-size:11.0pt;color:black'>\_
round-robin 0 [enabled]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>&nbsp; \_
0:0:0:1 sda&nbsp; 8:0&nbsp;&nbsp;&nbsp;&nbsp; [ready =
][failed]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span style=3D'font-size:11.0pt;color:black'>\_
round-robin 0 [active][best]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>&nbsp; \_
1:0:0:1 sdd&nbsp; 8:48&nbsp;&nbsp;&nbsp; [ready =
][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>Note the path =
&#8220;/dev/sda&#8221; has
become [ready][failed] not [ready][active]. For this to change to
[ready][active], &#8220;multipath &#8211;v0&#8221; needs to be executed
manually.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>d) Now if path =
&#8220;/dev/sdd&#8221; is
made unavailable, then if &#8220;dd&#8221; is run on /dev/mapper/mp1, it
returns with input/output error, as none of the path will be in =
[ready][active]
state. The following is the state now:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>mp1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>[size=3D1
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span style=3D'font-size:11.0pt;color:black'>\_
round-robin 0 [enabled][best]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>&nbsp; \_
0:0:0:1 sda&nbsp; 8:0&nbsp;&nbsp;&nbsp;&nbsp; [ready =
][failed]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span style=3D'font-size:11.0pt;color:black'>\_
round-robin 0 [enabled]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>&nbsp; \_
1:0:0:1 sdd&nbsp; 8:48&nbsp;&nbsp;&nbsp; =
[faulty][failed]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>If &#8220;multipath =
&#8211;v0&#8221;
executed&nbsp;from the command prompt the states get updated properly =
as<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>mp1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>[size=3D1
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span style=3D'font-size:11.0pt;color:black'>\_
round-robin 0 [active][best]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>&nbsp; \_
0:0:0:1 sda&nbsp; 8:0&nbsp;&nbsp;&nbsp;&nbsp; [ready =
][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span style=3D'font-size:11.0pt;color:black'>\_
round-robin 0 [enabled]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
color=3Dblack
face=3D"Times New Roman"><span =
style=3D'font-size:11.0pt;color:black'>&nbsp; \_
1:0:0:1 sdd&nbsp; 8:48&nbsp;&nbsp;&nbsp; =
[faulty][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>After this I will be able to do =
IO using
&#8220;dd&#8221;. &nbsp;&nbsp;How do we make the path state update =
properly
with out manually invoking &#8220;multipath &#8211;v0&#8221;? =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>I am not sure on how to get the =
debug
build of multipath and multipathd binaries, if the information in the
messages.txt is insufficient, I need to test with the debug build and =
send the
new log.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>Any help in resolving this =
problem is
appreciated.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>Thanks and =
regards<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dblack face=3D"Times New =
Roman"><span
style=3D'font-size:11.0pt;color:black'>Murthy<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
style=3D'font-size:
11.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_002_01C57320.D04A4B27--

------_=_NextPart_001_01C57320.D04A4B27
Content-Type: text/plain;
	name="messages.txt"
Content-Transfer-Encoding: base64
Content-Description: messages.txt
Content-Disposition: attachment;
	filename="messages.txt"

SnVuIDE3IDE0OjU4OjU3IGx4ZWFnbGUgbXVsdGlwYXRoZDogLS0tLS0tLS1zdGFydCB1cC0tLS0t
LS0tDQpKdW4gMTcgMTQ6NTg6NTcgbHhlYWdsZSBtdWx0aXBhdGhkOiByZWFkIC9ldGMvbXVsdGlw
YXRoLmNvbmYNCkp1biAxNyAxNDo1ODo1NyBseGVhZ2xlIGtlcm5lbDogU0VMaW51eDogaW5pdGlh
bGl6ZWQgKGRldiByYW1mcywgdHlwZSByYW1mcyksIHVzZXMgZ2VuZnNfY29udGV4dHMNCkp1biAx
NyAxNDo1ODo1NyBseGVhZ2xlIG11bHRpcGF0aGQ6IG1wMTogZXZlbnQgY2hlY2tlciBzdGFydGVk
DQpKdW4gMTcgMTQ6NTg6NTcgbHhlYWdsZSBtdWx0aXBhdGhkOiAzNjAwNTA4YjQwMDEwMTk5MTAw
MDBhMDAwMDE3MjAwMDA6IGV2ZW50IGNoZWNrZXIgc3RhcnRlZA0KSnVuIDE3IDE0OjU4OjU3IGx4
ZWFnbGUgbXVsdGlwYXRoZDogMzYwMDUwOGI0MDAxMDE5OTEwMDAwYTAwMDAxNzgwMDAwOiBldmVu
dCBjaGVja2VyIHN0YXJ0ZWQNCkp1biAxNyAxNDo1ODo1NyBseGVhZ2xlIG11bHRpcGF0aGQ6IDM2
MDA1MDhiNDAwMTAxOTkxMDAwMGEwMDAwMTZjMDAwMDogZXZlbnQgY2hlY2tlciBzdGFydGVkDQpK
dW4gMTcgMTQ6NTg6NTcgbHhlYWdsZSBtdWx0aXBhdGhkOiBwYXRoIGNoZWNrZXJzIHN0YXJ0IHVw
DQpKdW4gMTcgMTQ6NTg6NTcgbHhlYWdsZSBtdWx0aXBhdGhkOiA4OjA6IHR1ciBjaGVja2VyIHJl
cG9ydHMgcGF0aCBpcyB1cCANCkp1biAxNyAxNDo1ODo1NyBseGVhZ2xlIG11bHRpcGF0aGQ6IDg6
MDogcmVpbnN0YXRlZA0KSnVuIDE3IDE0OjU4OjU3IGx4ZWFnbGUgbXVsdGlwYXRoZDogODoxNjog
dHVyIGNoZWNrZXIgcmVwb3J0cyBwYXRoIGlzIHVwIA0KSnVuIDE3IDE0OjU4OjU3IGx4ZWFnbGUg
bXVsdGlwYXRoZDogODoxNjogcmVpbnN0YXRlZA0KSnVuIDE3IDE0OjU4OjU3IGx4ZWFnbGUgbXVs
dGlwYXRoZDogODozMjogdHVyIGNoZWNrZXIgcmVwb3J0cyBwYXRoIGlzIHVwIA0KSnVuIDE3IDE0
OjU4OjU3IGx4ZWFnbGUgbXVsdGlwYXRoZDogODozMjogcmVpbnN0YXRlZA0KSnVuIDE3IDE0OjU4
OjU3IGx4ZWFnbGUgbXVsdGlwYXRoZDogODo0ODogdHVyIGNoZWNrZXIgcmVwb3J0cyBwYXRoIGlz
IHVwIA0KSnVuIDE3IDE0OjU4OjU3IGx4ZWFnbGUgbXVsdGlwYXRoZDogODo0ODogcmVpbnN0YXRl
ZA0KSnVuIDE3IDE0OjU4OjU3IGx4ZWFnbGUgbXVsdGlwYXRoZDogODo2NDogdHVyIGNoZWNrZXIg
cmVwb3J0cyBwYXRoIGlzIHVwIA0KSnVuIDE3IDE0OjU4OjU3IGx4ZWFnbGUgbXVsdGlwYXRoZDog
ODo2NDogcmVpbnN0YXRlZA0KSnVuIDE3IDE0OjU4OjU3IGx4ZWFnbGUgbXVsdGlwYXRoZDogODo4
MDogdHVyIGNoZWNrZXIgcmVwb3J0cyBwYXRoIGlzIHVwIA0KSnVuIDE3IDE0OjU4OjU3IGx4ZWFn
bGUgbXVsdGlwYXRoZDogODo4MDogcmVpbnN0YXRlZA0KSnVuIDE3IDE0OjU5OjAzIGx4ZWFnbGUg
a2VybmVsOiBxbGEyMzAwIDAwMDA6MDU6MDMuMDogTE9PUCBET1dOIGRldGVjdGVkLiAgIDw8PT09
IFBBVEggMSBNQURFIFVOQVZBSUxBQkxFDQpKdW4gMTcgMTU6MDA6MDMgbHhlYWdsZSBrZXJuZWw6
IFNDU0kgZXJyb3IgOiA8MCAwIDAgMT4gcmV0dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6
MDA6MDMgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGEsIHNl
Y3RvciAwDQpKdW4gMTcgMTU6MDA6MDMgbHhlYWdsZSBrZXJuZWw6IGRldmljZS1tYXBwZXI6IGRt
LW11bHRpcGF0aDogRmFpbGluZyBwYXRoIDg6MC4NCkp1biAxNyAxNTowMDowMyBseGVhZ2xlIG11
bHRpcGF0aGQ6IDg6MDogdHVyIGNoZWNrZXIgcmVwb3J0cyBwYXRoIGlzIGRvd24gDQpKdW4gMTcg
MTU6MDA6MDMgbHhlYWdsZSBtdWx0aXBhdGhkOiBjaGVja2VyIGZhaWxlZCBwYXRoIDg6MCBpbiBt
YXAgMzYwMDUwOGI0MDAxMDE5OTEwMDAwYTAwMDAxNmMwMDAwDQpKdW4gMTcgMTU6MDA6MDMgbHhl
YWdsZSBtdWx0aXBhdGhkOiBkZXZtYXAgZXZlbnQgKDQxKSBvbiBtcDENCkp1biAxNyAxNTowMDow
MyBseGVhZ2xlIG11bHRpcGF0aGQ6IGRldm1hcCBldmVudCAoNDIpIG9uIDM2MDA1MDhiNDAwMTAx
OTkxMDAwMGEwMDAwMTZjMDAwMA0KSnVuIDE3IDE1OjAwOjAzIGx4ZWFnbGUgbXVsdGlwYXRoZDog
ODoxNjogdHVyIGNoZWNrZXIgcmVwb3J0cyBwYXRoIGlzIGRvd24gDQpKdW4gMTcgMTU6MDA6MDMg
bHhlYWdsZSBtdWx0aXBhdGhkOiBjaGVja2VyIGZhaWxlZCBwYXRoIDg6MTYgaW4gbWFwIDM2MDA1
MDhiNDAwMTAxOTkxMDAwMGEwMDAwMTcyMDAwMA0KSnVuIDE3IDE1OjAwOjAzIGx4ZWFnbGUga2Vy
bmVsOiBkZXZpY2UtbWFwcGVyOiBkbS1tdWx0aXBhdGg6IEZhaWxpbmcgcGF0aCA4OjAuDQpKdW4g
MTcgMTU6MDA6MDMgbHhlYWdsZSBrZXJuZWw6IGRldmljZS1tYXBwZXI6IGRtLW11bHRpcGF0aDog
RmFpbGluZyBwYXRoIDg6MTYuDQpKdW4gMTcgMTU6MDA6MDMgbHhlYWdsZSBrZXJuZWw6IGRldmlj
ZS1tYXBwZXI6IGRtLW11bHRpcGF0aDogRmFpbGluZyBwYXRoIDg6MzIuDQpKdW4gMTcgMTU6MDA6
MDMgbHhlYWdsZSBtdWx0aXBhdGhkOiBkZXZtYXAgZXZlbnQgKDUwKSBvbiAzNjAwNTA4YjQwMDEw
MTk5MTAwMDBhMDAwMDE3MjAwMDANCkp1biAxNyAxNTowMDowMyBseGVhZ2xlIG11bHRpcGF0aGQ6
IDg6MzI6IHR1ciBjaGVja2VyIHJlcG9ydHMgcGF0aCBpcyBkb3duIA0KSnVuIDE3IDE1OjAwOjAz
IGx4ZWFnbGUgbXVsdGlwYXRoZDogY2hlY2tlciBmYWlsZWQgcGF0aCA4OjMyIGluIG1hcCAzNjAw
NTA4YjQwMDEwMTk5MTAwMDBhMDAwMDE3ODAwMDANCkp1biAxNyAxNTowMDowMyBseGVhZ2xlIG11
bHRpcGF0aGQ6IGRldm1hcCBldmVudCAoNTApIG9uIDM2MDA1MDhiNDAwMTAxOTkxMDAwMGEwMDAw
MTc4MDAwMA0KSnVuIDE3IDE1OjAwOjUyIGx4ZWFnbGUga2VybmVsOiBxbGEyMzAwIDAwMDA6MDU6
MDMuMDogTElQIHJlc2V0IG9jY3VyZWQgKGY3ZjcpLg0KSnVuIDE3IDE1OjAwOjUyIGx4ZWFnbGUg
a2VybmVsOiBxbGEyMzAwIDAwMDA6MDU6MDMuMDogTE9PUCBVUCBkZXRlY3RlZCAoMiBHYnBzKS4g
ICA8PD09PSBQQVRIIDEgTUFERSBBVkFJTEFCTEUNCkp1biAxNyAxNTowMTowMSBseGVhZ2xlIGNy
b25kKHBhbV91bml4KVs1NDE4XTogc2Vzc2lvbiBvcGVuZWQgZm9yIHVzZXIgcm9vdCBieSAodWlk
PTApDQpKdW4gMTcgMTU6MDE6MDEgbHhlYWdsZSBjcm9uZChwYW1fdW5peClbNTQxOF06IHNlc3Np
b24gY2xvc2VkIGZvciB1c2VyIHJvb3QNCkp1biAxNyAxNTowMTowOSBseGVhZ2xlIG11bHRpcGF0
aGQ6IDg6MDogdHVyIGNoZWNrZXIgcmVwb3J0cyBwYXRoIGlzIHVwIA0KSnVuIDE3IDE1OjAxOjA5
IGx4ZWFnbGUgbXVsdGlwYXRoZDogODowOiByZWluc3RhdGVkDQpKdW4gMTcgMTU6MDE6MDkgbHhl
YWdsZSBtdWx0aXBhdGhkOiA4OjE2OiB0dXIgY2hlY2tlciByZXBvcnRzIHBhdGggaXMgdXAgDQpK
dW4gMTcgMTU6MDE6MDkgbHhlYWdsZSBtdWx0aXBhdGhkOiBkZXZtYXAgZXZlbnQgKDQzKSBvbiAz
NjAwNTA4YjQwMDEwMTk5MTAwMDBhMDAwMDE2YzAwMDANCkp1biAxNyAxNTowMTowOSBseGVhZ2xl
IG11bHRpcGF0aGQ6IDg6MTY6IHJlaW5zdGF0ZWQNCkp1biAxNyAxNTowMTowOSBseGVhZ2xlIG11
bHRpcGF0aGQ6IGRldm1hcCBldmVudCAoNTEpIG9uIDM2MDA1MDhiNDAwMTAxOTkxMDAwMGEwMDAw
MTcyMDAwMA0KSnVuIDE3IDE1OjAxOjA5IGx4ZWFnbGUgbXVsdGlwYXRoZDogODozMjogdHVyIGNo
ZWNrZXIgcmVwb3J0cyBwYXRoIGlzIHVwIA0KSnVuIDE3IDE1OjAxOjA5IGx4ZWFnbGUgbXVsdGlw
YXRoZDogODozMjogcmVpbnN0YXRlZA0KSnVuIDE3IDE1OjAxOjA5IGx4ZWFnbGUgbXVsdGlwYXRo
ZDogZGV2bWFwIGV2ZW50ICg1MSkgb24gMzYwMDUwOGI0MDAxMDE5OTEwMDAwYTAwMDAxNzgwMDAw
DQpKdW4gMTcgMTU6MDE6NTEgbHhlYWdsZSBrZXJuZWw6IHFsYTIzMDAgMDAwMDowNTowNC4wOiBM
T09QIERPV04gZGV0ZWN0ZWQuICAgICAgICAgIDw8PT09IFBBVEggMiBNQURFIFVOQVZBSUxBQkxF
DQpKdW4gMTcgMTU6MDI6NDggbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAwIDAgMT4g
cmV0dXJuIGNvZGUgPSAweDIwMDAwDQpKdW4gMTcgMTU6MDI6NDggbHhlYWdsZSBrZXJuZWw6IGVu
ZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMjQ2MjAwDQpKdW4gMTcgMTU6
MDI6NDggbHhlYWdsZSBrZXJuZWw6IGRldmljZS1tYXBwZXI6IGRtLW11bHRpcGF0aDogRmFpbGlu
ZyBwYXRoIDg6NDguDQpKdW4gMTcgMTU6MDI6NDggbHhlYWdsZSBtdWx0aXBhdGhkOiBkZXZtYXAg
ZXZlbnQgKDQyKSBvbiBtcDENCkp1biAxNyAxNTowMjo0OCBseGVhZ2xlIGtlcm5lbDogcHJpbnRr
OiAyNTUwNSBtZXNzYWdlcyBzdXBwcmVzc2VkLg0KSnVuIDE3IDE1OjAyOjQ4IGx4ZWFnbGUga2Vy
bmVsOiBCdWZmZXIgSS9PIGVycm9yIG9uIGRldmljZSBkbS0wLCBsb2dpY2FsIGJsb2NrIDE0MzY4
NA0KSnVuIDE3IDE1OjAyOjQ4IGx4ZWFnbGUga2VybmVsOiBsb3N0IHBhZ2Ugd3JpdGUgZHVlIHRv
IEkvTyBlcnJvciBvbiBkbS0wDQpKdW4gMTcgMTU6MDI6NDggbHhlYWdsZSBrZXJuZWw6IEJ1ZmZl
ciBJL08gZXJyb3Igb24gZGV2aWNlIGRtLTAsIGxvZ2ljYWwgYmxvY2sgMTQzNjg1DQpKdW4gMTcg
MTU6MDI6NDggbHhlYWdsZSBrZXJuZWw6IGxvc3QgcGFnZSB3cml0ZSBkdWUgdG8gSS9PIGVycm9y
IG9uIGRtLTANCkp1biAxNyAxNTowMjo0OCBseGVhZ2xlIGtlcm5lbDogQnVmZmVyIEkvTyBlcnJv
ciBvbiBkZXZpY2UgZG0tMCwgbG9naWNhbCBibG9jayAxNDM2ODYNCkp1biAxNyAxNTowMjo0OCBs
eGVhZ2xlIGtlcm5lbDogbG9zdCBwYWdlIHdyaXRlIGR1ZSB0byBJL08gZXJyb3Igb24gZG0tMA0K
SnVuIDE3IDE1OjAyOjQ4IGx4ZWFnbGUga2VybmVsOiBCdWZmZXIgSS9PIGVycm9yIG9uIGRldmlj
ZSBkbS0wLCBsb2dpY2FsIGJsb2NrIDE0MzY4Nw0KSnVuIDE3IDE1OjAyOjQ4IGx4ZWFnbGUga2Vy
bmVsOiBsb3N0IHBhZ2Ugd3JpdGUgZHVlIHRvIEkvTyBlcnJvciBvbiBkbS0wDQpKdW4gMTcgMTU6
MDI6NDggbHhlYWdsZSBrZXJuZWw6IEJ1ZmZlciBJL08gZXJyb3Igb24gZGV2aWNlIGRtLTAsIGxv
Z2ljYWwgYmxvY2sgMTQzNjg4DQpKdW4gMTcgMTU6MDI6NDggbHhlYWdsZSBrZXJuZWw6IGxvc3Qg
cGFnZSB3cml0ZSBkdWUgdG8gSS9PIGVycm9yIG9uIGRtLTANCkp1biAxNyAxNTowMjo0OCBseGVh
Z2xlIGtlcm5lbDogQnVmZmVyIEkvTyBlcnJvciBvbiBkZXZpY2UgZG0tMCwgbG9naWNhbCBibG9j
ayAxNDM2ODkNCkp1biAxNyAxNTowMjo0OCBseGVhZ2xlIGtlcm5lbDogbG9zdCBwYWdlIHdyaXRl
IGR1ZSB0byBJL08gZXJyb3Igb24gZG0tMA0KSnVuIDE3IDE1OjAyOjQ4IGx4ZWFnbGUga2VybmVs
OiBCdWZmZXIgSS9PIGVycm9yIG9uIGRldmljZSBkbS0wLCBsb2dpY2FsIGJsb2NrIDE0MzY5MA0K
SnVuIDE3IDE1OjAyOjQ4IGx4ZWFnbGUga2VybmVsOiBsb3N0IHBhZ2Ugd3JpdGUgZHVlIHRvIEkv
TyBlcnJvciBvbiBkbS0wDQpKdW4gMTcgMTU6MDI6NDggbHhlYWdsZSBrZXJuZWw6IEJ1ZmZlciBJ
L08gZXJyb3Igb24gZGV2aWNlIGRtLTAsIGxvZ2ljYWwgYmxvY2sgMTQzNjkxDQpKdW4gMTcgMTU6
MDI6NDggbHhlYWdsZSBrZXJuZWw6IGxvc3QgcGFnZSB3cml0ZSBkdWUgdG8gSS9PIGVycm9yIG9u
IGRtLTANCkp1biAxNyAxNTowMjo0OCBseGVhZ2xlIGtlcm5lbDogQnVmZmVyIEkvTyBlcnJvciBv
biBkZXZpY2UgZG0tMCwgbG9naWNhbCBibG9jayAxNDM2OTINCkp1biAxNyAxNTowMjo0OSBseGVh
Z2xlIGtlcm5lbDogbG9zdCBwYWdlIHdyaXRlIGR1ZSB0byBJL08gZXJyb3Igb24gZG0tMA0KSnVu
IDE3IDE1OjAyOjQ5IGx4ZWFnbGUga2VybmVsOiBCdWZmZXIgSS9PIGVycm9yIG9uIGRldmljZSBk
bS0wLCBsb2dpY2FsIGJsb2NrIDE0MzY5Mw0KSnVuIDE3IDE1OjAyOjQ5IGx4ZWFnbGUga2VybmVs
OiBsb3N0IHBhZ2Ugd3JpdGUgZHVlIHRvIEkvTyBlcnJvciBvbiBkbS0wDQpKdW4gMTcgMTU6MDI6
NTAgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAwIDAgMT4gcmV0dXJuIGNvZGUgPSAw
eDEwMDAwDQpKdW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08g
ZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDQ1NzYwDQpKdW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBr
ZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDQ1NzY4DQpK
dW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAwIDAgMT4gcmV0
dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBrZXJuZWw6IGVuZF9y
ZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDQ2Nzg0DQpKdW4gMTcgMTU6MDI6
NTAgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3Rv
ciAxMDQ2NzkyDQpKdW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8
MSAwIDAgMT4gcmV0dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBr
ZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDQ3ODA4DQpK
dW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAwIDAgMT4gcmV0
dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBrZXJuZWw6IGVuZF9y
ZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDQ3ODE2DQpKdW4gMTcgMTU6MDI6
NTAgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3Rv
ciAxMDQ3ODI0DQpKdW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8
MSAwIDAgMT4gcmV0dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBr
ZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDQ4ODQwDQpK
dW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRl
diBzZGQsIHNlY3RvciAxMDQ4ODQ4DQpKdW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBtdWx0aXBhdGhk
OiA4OjQ4OiB0dXIgY2hlY2tlciByZXBvcnRzIHBhdGggaXMgZG93biANCkp1biAxNyAxNTowMjo1
MCBseGVhZ2xlIGtlcm5lbDogU0NTSSBlcnJvciA6IDwxIDAgMCAxPiByZXR1cm4gY29kZSA9IDB4
MTAwMDANCkp1biAxNyAxNTowMjo1MCBseGVhZ2xlIG11bHRpcGF0aGQ6IGNoZWNrZXIgZmFpbGVk
IHBhdGggODo0OCBpbiBtYXAgMzYwMDUwOGI0MDAxMDE5OTEwMDAwYTAwMDAxNmMwMDAwDQpKdW4g
MTcgMTU6MDI6NTAgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBz
ZGQsIHNlY3RvciAxMDQ5ODY0DQpKdW4gMTcgMTU6MDI6NTAgbHhlYWdsZSBtdWx0aXBhdGhkOiBk
ZXZtYXAgZXZlbnQgKDQ0KSBvbiAzNjAwNTA4YjQwMDEwMTk5MTAwMDBhMDAwMDE2YzAwMDANCkp1
biAxNyAxNTowMjo1MCBseGVhZ2xlIGtlcm5lbDogU0NTSSBlcnJvciA6IDwxIDAgMCAxPiByZXR1
cm4gY29kZSA9IDB4MTAwMDANCkp1biAxNyAxNTowMjo1MCBseGVhZ2xlIG11bHRpcGF0aGQ6IDg6
NjQ6IHR1ciBjaGVja2VyIHJlcG9ydHMgcGF0aCBpcyBkb3duIA0KSnVuIDE3IDE1OjAyOjUwIGx4
ZWFnbGUga2VybmVsOiBlbmRfcmVxdWVzdDogSS9PIGVycm9yLCBkZXYgc2RkLCBzZWN0b3IgMTA0
OTg3Mg0KSnVuIDE3IDE1OjAyOjUwIGx4ZWFnbGUgbXVsdGlwYXRoZDogY2hlY2tlciBmYWlsZWQg
cGF0aCA4OjY0IGluIG1hcCAzNjAwNTA4YjQwMDEwMTk5MTAwMDBhMDAwMDE3MjAwMDANCkp1biAx
NyAxNTowMjo1MSBseGVhZ2xlIGtlcm5lbDogZW5kX3JlcXVlc3Q6IEkvTyBlcnJvciwgZGV2IHNk
ZCwgc2VjdG9yIDEwNDk4ODANCkp1biAxNyAxNTowMjo1MSBseGVhZ2xlIG11bHRpcGF0aGQ6IGRl
dm1hcCBldmVudCAoNTIpIG9uIDM2MDA1MDhiNDAwMTAxOTkxMDAwMGEwMDAwMTcyMDAwMA0KSnVu
IDE3IDE1OjAyOjUxIGx4ZWFnbGUga2VybmVsOiBTQ1NJIGVycm9yIDogPDEgMCAwIDE+IHJldHVy
biBjb2RlID0gMHgxMDAwMA0KSnVuIDE3IDE1OjAyOjUxIGx4ZWFnbGUgbXVsdGlwYXRoZDogODo4
MDogdHVyIGNoZWNrZXIgcmVwb3J0cyBwYXRoIGlzIGRvd24gDQpKdW4gMTcgMTU6MDI6NTEgbHhl
YWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDUw
ODk2DQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBtdWx0aXBhdGhkOiBjaGVja2VyIGZhaWxlZCBw
YXRoIDg6ODAgaW4gbWFwIDM2MDA1MDhiNDAwMTAxOTkxMDAwMGEwMDAwMTc4MDAwMA0KSnVuIDE3
IDE1OjAyOjUxIGx4ZWFnbGUga2VybmVsOiBlbmRfcmVxdWVzdDogSS9PIGVycm9yLCBkZXYgc2Rk
LCBzZWN0b3IgMTA1MDkwNA0KSnVuIDE3IDE1OjAyOjUxIGx4ZWFnbGUgbXVsdGlwYXRoZDogODow
OiBtYXJrIGFzIGZhaWxlZA0KSnVuIDE3IDE1OjAyOjUxIGx4ZWFnbGUga2VybmVsOiBTQ1NJIGVy
cm9yIDogPDEgMCAwIDE+IHJldHVybiBjb2RlID0gMHgxMDAwMA0KSnVuIDE3IDE1OjAyOjUxIGx4
ZWFnbGUgbXVsdGlwYXRoZDogZGV2bWFwIGV2ZW50ICg1Mikgb24gMzYwMDUwOGI0MDAxMDE5OTEw
MDAwYTAwMDAxNzgwMDAwDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1
ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDUxOTIwDQpKdW4gMTcgMTU6MDI6NTEg
bHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAwIDAgMT4gcmV0dXJuIGNvZGUgPSAweDEw
MDAwDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJy
b3IsIGRldiBzZGQsIHNlY3RvciAxMDUxOTI4DQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJu
ZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDUxOTM2DQpKdW4g
MTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAwIDAgMT4gcmV0dXJu
IGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1
ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDUyOTUyDQpKdW4gMTcgMTU6MDI6NTEg
bHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAx
MDUyOTYwDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAw
IDAgMT4gcmV0dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJu
ZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDUzOTc2DQpKdW4g
MTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAwIDAgMT4gcmV0dXJu
IGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1
ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDUzOTg0DQpKdW4gMTcgMTU6MDI6NTEg
bHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAx
MDUzOTkyDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAw
IDAgMT4gcmV0dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJu
ZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDU1MDA4DQpKdW4g
MTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBz
ZGQsIHNlY3RvciAxMDU1MDE2DQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IFNDU0kg
ZXJyb3IgOiA8MSAwIDAgMT4gcmV0dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTEg
bHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAx
MDU2MDMyDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAw
IDAgMT4gcmV0dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJu
ZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDU2MDQwDQpKdW4g
MTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBz
ZGQsIHNlY3RvciAxMDU2MDQ4DQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IFNDU0kg
ZXJyb3IgOiA8MSAwIDAgMT4gcmV0dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTEg
bHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAx
MDU3MDY0DQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08g
ZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDU3MDcyDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBr
ZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAwIDAgMT4gcmV0dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4g
MTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBz
ZGQsIHNlY3RvciAxMDU4MDg4DQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IFNDU0kg
ZXJyb3IgOiA8MSAwIDAgMT4gcmV0dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDI6NTEg
bHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAx
MDU4MDk2DQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08g
ZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDU4MTA0DQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBr
ZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAwIDAgMT4gcmV0dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4g
MTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBz
ZGQsIHNlY3RvciAxMDU5MTIwDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9y
ZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDU5MTI4DQpKdW4gMTcgMTU6MDI6
NTEgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAwIDAgMT4gcmV0dXJuIGNvZGUgPSAw
eDEwMDAwDQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08g
ZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDU5NzY4DQpKdW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBr
ZXJuZWw6IGVuZF9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGQsIHNlY3RvciAxMDU5Nzc2DQpK
dW4gMTcgMTU6MDI6NTEgbHhlYWdsZSBrZXJuZWw6IFNDU0kgZXJyb3IgOiA8MSAwIDAgMT4gcmV0
dXJuIGNvZGUgPSAweDEwMDAwDQpKdW4gMTcgMTU6MDM6MDEgbHhlYWdsZSBtdWx0aXBhdGhkOiA4
OjA6IHR1ciBjaGVja2VyIHJlcG9ydHMgcGF0aCBpcyB1cCANCkp1biAxNyAxNTowMzowMSBseGVh
Z2xlIG11bHRpcGF0aGQ6IDg6MDogcmVpbnN0YXRlZA0KSnVuIDE3IDE1OjAzOjIyIGx4ZWFnbGUg
a2VybmVsOiBxbGEyMzAwIDAwMDA6MDU6MDQuMDogTElQIHJlc2V0IG9jY3VyZWQgKGY3ZjcpLg0K
SnVuIDE3IDE1OjAzOjIyIGx4ZWFnbGUga2VybmVsOiBxbGEyMzAwIDAwMDA6MDU6MDQuMDogTE9P
UCBVUCBkZXRlY3RlZCAoMiBHYnBzKS4gICA8PD09PSBQQVRIIDIgTUFERSBBVkFJTEFCTEUNCkp1
biAxNyAxNTowMzozNCBseGVhZ2xlIG11bHRpcGF0aGQ6IDg6NDg6IHR1ciBjaGVja2VyIHJlcG9y
dHMgcGF0aCBpcyB1cCANCkp1biAxNyAxNTowMzozNCBseGVhZ2xlIG11bHRpcGF0aGQ6IDg6NDg6
IHJlaW5zdGF0ZWQNCkp1biAxNyAxNTowMzozNCBseGVhZ2xlIG11bHRpcGF0aGQ6IDg6NjQ6IHR1
ciBjaGVja2VyIHJlcG9ydHMgcGF0aCBpcyB1cCANCkp1biAxNyAxNTowMzozNCBseGVhZ2xlIG11
bHRpcGF0aGQ6IGRldm1hcCBldmVudCAoNDUpIG9uIDM2MDA1MDhiNDAwMTAxOTkxMDAwMGEwMDAw
MTZjMDAwMA0KSnVuIDE3IDE1OjAzOjM0IGx4ZWFnbGUgbXVsdGlwYXRoZDogODo2NDogcmVpbnN0
YXRlZA0KSnVuIDE3IDE1OjAzOjM0IGx4ZWFnbGUgbXVsdGlwYXRoZDogZGV2bWFwIGV2ZW50ICg1
Mykgb24gMzYwMDUwOGI0MDAxMDE5OTEwMDAwYTAwMDAxNzIwMDAwDQpKdW4gMTcgMTU6MDM6MzQg
bHhlYWdsZSBtdWx0aXBhdGhkOiA4OjgwOiB0dXIgY2hlY2tlciByZXBvcnRzIHBhdGggaXMgdXAg
DQpKdW4gMTcgMTU6MDM6MzQgbHhlYWdsZSBtdWx0aXBhdGhkOiA4OjgwOiByZWluc3RhdGVkDQpK
dW4gMTcgMTU6MDM6MzQgbHhlYWdsZSBtdWx0aXBhdGhkOiBkZXZtYXAgZXZlbnQgKDUzKSBvbiAz
NjAwNTA4YjQwMDEwMTk5MTAwMDBhMDAwMDE3ODAwMDANCg==

------_=_NextPart_001_01C57320.D04A4B27
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C57320.D04A4B27--
