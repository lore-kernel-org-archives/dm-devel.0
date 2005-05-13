From: <cfeng@plasmon.cn>
Subject: snapshot deadlock when logical volume is busy?
Date: Fri, 13 May 2005 17:43:44 +0800
Message-ID: <200505131043.j4DAhvio028158@mx1.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0810940519=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============0810940519==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0181_01C557E3.4F0E5820"

This is a multi-part message in MIME format.

------=_NextPart_000_0181_01C557E3.4F0E5820
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Hi folks,

       When I create multiple snapshots on a logical volume that is being
busy written to, the lvcreate command becomes dead when the third or fourth
snapshot is created on a single logical volume. The process that writes to
the logical volume also dies. "Dies" here means the program doesn't return,
nor can it be killed by pressing CTRL-C or "kill" command. The system is
still responsive though, and I can login to run some other commands. But
once the error condition happens if I run any command that accesses the
logical volume, it also dies.

       This problem was found on Fedora Core 4 (2.6.11-1). I also tried it
with the unstable dm patches and it doesn't cure.

       Is this a known problem? I've searched the Internet and found some
folks discussing I/O scheduler issue in 2.6 kernel snapshot. Any plan to fix
it?

 

Thanks,

Charles

        

 


------=_NextPart_000_0181_01C557E3.4F0E5820
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Tahoma;
	color:windowtext;
	font-weight:normal;
	font-style:normal;
	text-decoration:none none;}
 /* Page Definitions */
 @page Section1
	{size:595.3pt 841.9pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;
	layout-grid:15.6pt;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DZH-CN link=3Dblue vlink=3Dpurple =
style=3D'text-justify-trim:punctuation'>

<div class=3DSection1 style=3D'layout-grid:15.6pt'>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.5pt'>Hi folks,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.5pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; When I =
create multiple snapshots on a logical
volume that is being busy written to, the lvcreate command becomes dead =
when the
third or fourth snapshot is created on a single logical volume. The =
process
that writes to the logical volume also dies. &#8220;Dies&#8221; here =
means the program
doesn&#8217;t return, nor can it be killed by pressing CTRL-C or =
&#8220;kill&#8221; command. The
system is still responsive though, and I can login to run some other =
commands.
But once the error condition happens if I run any command that accesses =
the logical
volume, it also dies.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.5pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span><span lang=3DEN-US>This problem was found
on Fedora Core 4 (2.6.11-1). I also tried it with the unstable dm =
patches and it
doesn&#8217;t cure.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.5pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Is this =
a known problem? I&#8217;ve searched the Internet
and found some folks discussing I/O scheduler issue in 2.6 kernel =
snapshot. Any
plan to fix it?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.5pt'>Thanks,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.5pt'>Charles<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.5pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span><span lang=3DEN-US>&nbsp;</span><span
lang=3DEN-US><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------=_NextPart_000_0181_01C557E3.4F0E5820--



--===============0810940519==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0810940519==--
