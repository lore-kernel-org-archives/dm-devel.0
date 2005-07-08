From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: Path status updation on HP arrays.
Date: Fri, 8 Jul 2005 18:55:43 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA0023F84E6@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0196608433=="
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
Cc: "Reilly, Stephen (MRO)" <steve.reilly@hp.com>, "P S,  Suresh (STSD)" <suresh.pathamadai@hp.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0196608433==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C583C0.8B12C4D4"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C583C0.8B12C4D4
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I am seeing path updation issues with multipath tools versions 0.4.4 and
0.4.5, when tested with EVA HSV 200, MSA and XP (Active Active arrays)
on RHEL U1.=20

Failover works fine and fails to the other path in the path group, but
when the failed path comes back online,  the status of this path is
[ready][failed]. This doesn't change unless "multipath" is executed
manually from the command prompt. =20

Some of the unique observations seen are:

In MSA, when failed path comes back online, this path and currently
active path goes to [ready][failed] state.

=20

In EVA HSV 200, where the path groups are created using
"group_by_serial" policy,

If IO is pumped on a dm device, a path is failed and when the failed
path in a particular path group (each path group having 2 paths to 2
ports of the controller) comes back online, the status on these paths in
that path group is going to [ready][failed],  then the IO starts
continuing on the other path group.=20

=20

Any pointers for this would be really helpful.  I would like to know if
this kind of behaviour (partially or fully) is seen in any other storage
systems?

=20

In general when a path can go to [ready][failed] state?

=20

Thanks and regards

-Murthy

=20


------_=_NextPart_001_01C583C0.8B12C4D4
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"MS Sans Serif";
	panose-1:0 0 0 0 0 0 0 0 0 0;}
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
	{mso-style-type:personal-compose;
	font-family:"MS Sans Serif";
	color:windowtext;
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

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>I am seeing path updation issues =
with multipath
tools versions 0.4.4 and 0.4.5, when tested with EVA HSV 200, MSA and XP =
(Active
Active arrays) on RHEL U1. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Failover works fine and fails to the =
other
path in the path group, but when the failed path comes back online, =
&nbsp;the
status of this path is [ready][failed]. This doesn&#8217;t change unless =
&#8220;multipath&#8221;
is executed manually from the command prompt. =
&nbsp;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Some of the unique observations seen =
are:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>In MSA, when failed path comes back =
online,
this path and currently active path goes to [ready][failed] =
state.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>In EVA HSV 200, where the path =
groups are
created using &#8220;group_by_serial&#8221; =
policy,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>If IO is pumped on a dm device, a =
path is
failed and when the failed path in a particular path group (each path =
group
having 2 paths to 2 ports of the controller) comes back online, the =
status on
these paths in that path group is going to [ready][failed], &nbsp;then =
the IO
starts continuing on the other path group. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>Any pointers for this would be =
really
helpful. &nbsp;I would like to know if this kind of behaviour (partially =
or
fully) is seen in any other storage =
systems?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>In general when a path can go to =
[ready][failed]
state?<o:p></o:p></span></font></p>

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

------_=_NextPart_001_01C583C0.8B12C4D4--


--===============0196608433==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0196608433==--
