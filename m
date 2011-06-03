From: "Sandra Escandor" <sescandor@evertz.com>
Subject: question about output of dmsetup status
Date: Fri, 3 Jun 2011 09:13:37 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFACBAEAB@otis.burlington.evertz.tv>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6129257228937042562=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

This is a multi-part message in MIME format.

--===============6129257228937042562==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CC21EF.9571D4A0"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CC21EF.9571D4A0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I've been experimenting a bit with dmraid eventing, and I notice that
when I do the following, the result is not what I expect - but perhaps
someone can enlighten me on what is truly expected:

=20

1.	Setup a RAID0+1 with dmraid
2.	Register the RAID using dm_dso_reg_tool. I also ensure that it
is properly registerd using "dm_dso_reg_tool -m".
3.	I note the major and minor number of the devices that comprise
the RAID, using "dmsetup status".
4.	I start a write onto the RAID volume using a large file (3GB).
5.	During the write process, I pull one of the RAID member disks
out so that I may simulate a RAID failure.
6.	I notice that the "dmsetup status" command shows one of the
disks as being marked disabled - which is good. I take note of the
disabled disk's major:minor numbers.=20
7.	I reconnect the RAID member disk that I pulled out in step 5.
When I look for that disk's major:minor numbers using "ls -l /dev/sd*",
I don't see that major:minor number pair.=20
8.	When I run "dmsetup status" again, the major:minor numbers for
the pulled disk is still the same as the one I saw in Step 3.

=20

What I expected was that the major:minor number pair for the pulled disk
would correspond to the one that I saw in Step 7. Is my assumption
incorrect? The reason why I was expecting it this way was because I was
thinking that if I use dmsetup to determine the RAID status and see a
disabled drive, I can follow it back to a /dev/sd* and then get the hard
drive's serial number - then I would know which member disk to replace.
Is there a better way?

=20

Thanks for clarifying,

Sandra


------_=_NextPart_001_01CC21EF.9571D4A0
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
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 @list l0
	{mso-list-id:1933925337;
	mso-list-type:hybrid;
	mso-list-template-ids:-941055260 67698703 67698713 67698715 67698703 =
67698713 67698715 67698703 67698713 67698715;}
@list l0:level1
	{mso-level-tab-stop:.5in;
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

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I&#8217;ve been experimenting a bit with dmraid =
eventing,
and I notice that when I do the following, the result is not what I =
expect &#8211;
but perhaps someone can enlighten me on what is truly =
expected:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<ol style=3D'margin-top:0in' start=3D1 type=3D1>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1'><font size=3D2 =
face=3DArial><span
     style=3D'font-size:10.0pt;font-family:Arial'>Setup a RAID0+1 with =
dmraid<o:p></o:p></span></font></li>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1'><font size=3D2 =
face=3DArial><span
     style=3D'font-size:10.0pt;font-family:Arial'>Register the RAID =
using
     dm_dso_reg_tool. I also ensure that it is properly registerd using =
&#8220;dm_dso_reg_tool
     &#8211;m&#8221;.<o:p></o:p></span></font></li>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1'><font size=3D2 =
face=3DArial><span
     style=3D'font-size:10.0pt;font-family:Arial'>I note the major and =
minor
     number of the devices that comprise the RAID, using &#8220;dmsetup =
status&#8221;.<o:p></o:p></span></font></li>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1'><font size=3D2 =
face=3DArial><span
     style=3D'font-size:10.0pt;font-family:Arial'>I start a write onto =
the RAID
     volume using a large file (3GB).<o:p></o:p></span></font></li>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1'><font size=3D2 =
face=3DArial><span
     style=3D'font-size:10.0pt;font-family:Arial'>During the write =
process, I
     pull one of the RAID member disks out so that I may simulate a RAID
     failure.<o:p></o:p></span></font></li>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1'><font size=3D2 =
face=3DArial><span
     style=3D'font-size:10.0pt;font-family:Arial'>I notice that the =
&#8220;dmsetup
     status&#8221; command shows one of the disks as being marked =
disabled &#8211;
     which is good. I take note of the disabled disk&#8217;s major:minor
     numbers. <o:p></o:p></span></font></li>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1'><font size=3D2 =
face=3DArial><span
     style=3D'font-size:10.0pt;font-family:Arial'>I reconnect the RAID =
member
     disk that I pulled out in step 5. When I look for that disk&#8217;s
     major:minor numbers using &#8220;ls &#8211;l /dev/sd*&#8221;, I =
don&#8217;t
     see that major:minor number pair. <o:p></o:p></span></font></li>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1'><font size=3D2 =
face=3DArial><span
     style=3D'font-size:10.0pt;font-family:Arial'>When I run =
&#8220;dmsetup
     status&#8221; again, the major:minor numbers for the pulled disk is =
still
     the same as the one I saw in Step 3.<o:p></o:p></span></font></li>
</ol>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>What I expected was that the major:minor number pair =
for the
pulled disk would correspond to the one that I saw in Step 7. Is my =
assumption
incorrect? The reason why I was expecting it this way was because I was
thinking that if I use dmsetup to determine the RAID status and see a =
disabled
drive, I can follow it back to a /dev/sd* and then get the hard =
drive&#8217;s
serial number &#8211; then I would know which member disk to replace. Is =
there
a better way?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Thanks for clarifying,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Sandra<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01CC21EF.9571D4A0--


--===============6129257228937042562==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6129257228937042562==--
