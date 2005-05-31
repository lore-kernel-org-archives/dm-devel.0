From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: path state change
Date: Tue, 31 May 2005 21:28:40 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA00204663B@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0361776521=="
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
Cc: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0361776521==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C565F9.9D611901"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C565F9.9D611901
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

In the process of testing path failover I noticed the following:

a) when the path is made unavailable(/dev/sdd) for a logical device
"mp1" on a  multipath target, the status of the path becomes
[faulty][active]

                mp1

[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]

\_ round-robin 0 [enabled]

  \_ 0:0:0:1 sda  8:0     [ready][active]

\_ round-robin 0 [active][first]

  \_ 1:0:0:1 sdd  8:48    [faulty ][active]

=20

b) When an dd is executed on /dev/mapper/mp1, the state of the paths is
as follows

                mp1

[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]

\_ round-robin 0 [active][first]

  \_ 0:0:0:1 sda  8:0     [ready][active]

\_ round-robin 0 [enabled]

  \_ 1:0:0:1 sdd  8:48    [faulty ][failed]

=20

=20

b) Now if the path is made available for the same logical device
(/dev/sdd), the status is as follows

                mp1

[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]

\_ round-robin 0 [active][first]

  \_ 0:0:0:1 sda  8:0     [ready][active]

\_ round-robin 0 [enabled]

  \_ 1:0:0:1 sdd  8:48    [ready ][failed]

=20

Note the path /dev/sdd has become [ready][failed] not [ready][active].

=20

Now if path /dev/sda is made unavailable, then if "dd" is run on
/dev/mapper/mp1, it returns with input/output error, as none of the path
will be in [ready][active] state. The following is the state now:

=20

                mp1

[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]

\_ round-robin 0 [active][first]

  \_ 0:0:0:1 sda  8:0     [faulty]][active]

\_ round-robin 0 [enabled]

  \_ 1:0:0:1 sdd  8:48    [ready ][failed]

=20

Kindly explain me what the two states for each path infer. Like
[ready][active] or [faulty][active] or [faulty][failed] or
[ready][failed]. Also let me know how to failover to other path
(/dev/sdd) as it shows [ready][failed] status. If I execute just
"multipath" tool  from the command prompt the states get updated
properly as

=20

                mp1

[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]

\_ round-robin 0 [active][first]

  \_ 0:0:0:1 sda  8:0     [faulty]][active]

\_ round-robin 0 [enabled]

  \_ 1:0:0:1 sdd  8:48    [ready ][active]

=20

After this I will be able to do IO using "dd".  I suspect that I haven't
configured my hotplug to call "multipath" tool as the path is made
available/unavailable.  I am not sure on where I get hotplug script for
multipath and how to configure hotplug for calling the "multipath" tool.
I appreciate if anyone can help me out in this regard.

=20

Thanks and regards

Murthy

=20

=20

=20

=20

=20

=20

=20

=20


------_=_NextPart_001_01C565F9.9D611901
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
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

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'>In the process of testing path =
failover I
noticed the following:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'>a) when the path is made
unavailable(/dev/sdd) for a logical device &#8220;mp1&#8221; on a
&nbsp;multipath target, the status of the path becomes =
[faulty][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans =
Serif"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
mp1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>[size=3D1 =
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>\_ round-robin 0 =
[enabled]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>&nbsp; \_ 0:0:0:1 =
sda&nbsp;
8:0&nbsp;&nbsp;&nbsp;&nbsp; [ready][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>\_ round-robin 0
[active][first]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>&nbsp; \_ 1:0:0:1 =
sdd&nbsp;
8:48&nbsp;&nbsp;&nbsp; [faulty ][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'>b) When an dd is executed on
/dev/mapper/mp1, the state of the paths is as =
follows<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans =
Serif"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
mp1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>[size=3D1
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>\_ round-robin 0
[active][first]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>&nbsp; \_ 0:0:0:1 =
sda&nbsp;
8:0&nbsp;&nbsp;&nbsp;&nbsp; [ready][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>\_ round-robin 0 =
[enabled]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>&nbsp; \_ 1:0:0:1 =
sdd&nbsp;
8:48&nbsp;&nbsp;&nbsp; [faulty ][failed]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'>b) Now if the path is made available =
for the
same logical device (/dev/sdd), the status is as =
follows<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans =
Serif"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
mp1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>[size=3D1
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>\_ round-robin 0
[active][first]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>&nbsp; \_ 0:0:0:1 =
sda&nbsp;
8:0&nbsp;&nbsp;&nbsp;&nbsp; [ready][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>\_ round-robin 0 =
[enabled]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>&nbsp; \_ 1:0:0:1 =
sdd&nbsp;
8:48&nbsp;&nbsp;&nbsp; [ready ][failed]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'>Note the path /dev/sdd has become
[ready][failed] not [ready][active].<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'>Now if path /dev/sda is made =
unavailable,
then if &#8220;dd&#8221; is run on /dev/mapper/mp1, it returns with
input/output error, as none of the path will be in [ready][active] =
state. The following
is the state now:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans =
Serif"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
mp1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>[size=3D1
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>\_ round-robin 0
[active][first]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>&nbsp; \_ 0:0:0:1 =
sda&nbsp;
8:0&nbsp;&nbsp;&nbsp;&nbsp; =
[faulty]][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>\_ round-robin 0 =
[enabled]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>&nbsp; \_ 1:0:0:1 =
sdd&nbsp;
8:48&nbsp;&nbsp;&nbsp; [ready ][failed]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'>Kindly explain me what the two states =
for
each path infer. Like [ready][active] or [faulty][active] or =
[faulty][failed]
or [ready][failed]. Also let me know how to failover to other path =
(/dev/sdd)
as it shows [ready][failed] status. If I execute just =
&#8220;multipath&#8221;
tool &nbsp;from the command prompt the states get updated properly =
as<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans =
Serif"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
mp1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>[size=3D1
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>\_ round-robin 0
[active][first]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>&nbsp; \_ 0:0:0:1 =
sda&nbsp;
8:0&nbsp;&nbsp;&nbsp;&nbsp; =
[faulty]][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>\_ round-robin 0 =
[enabled]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D1 =
face=3D"MS Sans Serif"><span
style=3D'font-size:9.0pt;font-family:"MS Sans Serif"'>&nbsp; \_ 1:0:0:1 =
sdd&nbsp;
8:48&nbsp;&nbsp;&nbsp; [ready ][active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'>After this I will be able to do IO =
using
&#8220;dd&#8221;. &nbsp;I suspect that I haven&#8217;t configured my =
hotplug to
call &#8220;multipath&#8221; tool as the path is made =
available/unavailable.
&nbsp;I am not sure on where I get hotplug script for multipath and how =
to
configure hotplug for calling the &#8220;multipath&#8221; tool. I =
appreciate if
anyone can help me out in this regard.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'>Thanks and =
regards<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'>Murthy<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3D"MS Sans Serif"><span =
style=3D'font-size:
9.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C565F9.9D611901--


--===============0361776521==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0361776521==--
