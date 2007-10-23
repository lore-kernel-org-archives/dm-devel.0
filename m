From: "Vega Forneris" <vega.forneris@sic.rm.cnr.it>
Subject: - info about dm
Date: Tue, 23 Oct 2007 18:06:22 +0200
Message-ID: <008201c8158e$a7f5c3e0$27819296@wegaprise>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0369496742=="
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

--===============0369496742==
Content-Type: multipart/related;
	boundary="----=_NextPart_000_0083_01C8159F.6B7E93E0"

This is a multi-part message in MIME format.

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_001_0084_01C8159F.6B7E93E0"


------=_NextPart_001_0084_01C8159F.6B7E93E0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Dear all,
 
I just installed Scientific Linux 5 and I used for the first time DM
drivers for working with the embedded RAID (the servers are IBM xSeries,
with an Adaptec HostRAID ASR - SATA). I really appreciate the fact that
now Linux is able to recognize such devices, but I had some troubles
configuring it and I'd like to have some info for better understanding
how things work. 
 
I'll be a little "verbose" for clarifying what I did and which are my
doubts.
 
1)       Installation & Configuration
 
I installed SL5 on a system which was running SL3 with HW drivers
released by IBM. Linux was able to identify correctly the device
(installed through CD), mapped it as /dev/mapper/asr_ and proceeded with
he installation.
 
Anyway, I found a little problematic configuring it manually: I tried to
install SL5 on a node which was misconfigured: instead of seeing one
device, it was managing the 2 HD (/dev/sda and /dev/sdb) as 2 separate
devices an if I tried to configure them (at install time, via CD or
network boot) with  DM, I got many errors about the RAID table ("ERROR:
asr: Invalid RAID config table checksum on /dev/sda" or even "asr:
Invalid magic number in RAID table; saw 0x0 expected."). I tried to
reconfigure the RAID card first via BIOS and then trying again to
configure it via Linux ("dmsetup create .") but even if it seemed
working (exit code 0), then querying the device asr_ (i.e. "dmraid -r")
resulted in errors as reported above.or better, dmraid commands (-r,
-ay, -tay,.) reported errors, while dmsetup commands  (status, ls,.)
worked normally. The only way I found for well-configuring the device
was to install SL3 with specific drivers, and then to install SL5 with
DM.all both commands now work perfectly
 
In brief:
If I try to configure DM-RAID from scratch and I get such errors, how
can I do? What's that "RAID table"? Where is it written? Not in the MBR
of an HD, 'cause I tried to copy the MBR of the cloned disk which had no
problem (still recognized as "good" for RAID and DM) and nothing
changed.
 
2)       Managing disks
 
I configured disks in RAID 1 (mirror) but I wonder how to manage this
RAID; in particular, how can I do for:
 - stopping a device (disk) and put it offline/and viceversa? 
 - reconfiguring/rebuilding it (due to broken/faulting HD)? 
 
At the moment I should change a couple of disks (SMARTD warnings
reported), but I'm scared about the "RAID table error".
 
 
Many Thanks in advance for all help you can give me.
 
Best Regards
 
Vega Forneris
 
+--------------------------------------+
 Vega Forneris

 CNR - Servizi Informatici di Campo
 Gestione servizi GRID

 Area di Ricerca Roma II - Tor Vergata
 Via del Fosso del Cavaliere, 100
 00133 Roma

 Tel:   +39 06 4993 4667
 Fax:   +39 06 4993 4650
 Email:  <mailto:Vega.Forneris@sic.rm.cnr.it>
Vega.Forneris@sic.rm.cnr.it
+--------------------------------------+
 

------=_NextPart_001_0084_01C8159F.6B7E93E0
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">


<meta name=3DProgId content=3DWord.Document>
<meta name=3DGenerator content=3D"Microsoft Word 10">
<meta name=3DOriginator content=3D"Microsoft Word 10">
<link rel=3DFile-List href=3D"cid:filelist.xml@01C8159F.6B04F710">
<link rel=3DEdit-Time-Data href=3D"cid:editdata.mso@01C8159F.6B04F710">
<!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:DoNotRelyOnCSS/>
 </o:OfficeDocumentSettings>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:SpellingState>Clean</w:SpellingState>
  <w:GrammarState>Clean</w:GrammarState>
  <w:DocumentKind>DocumentEmail</w:DocumentKind>
  <w:HyphenationZone>14</w:HyphenationZone>
  <w:EnvelopeVis/>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:ApplyBreakingRules/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:UseFELayout/>
  </w:Compatibility>
  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>
 </w:WordDocument>
</xml><![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;
	mso-font-alt:\5B8B\4F53;
	mso-font-charset:134;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:3 135135232 16 0 262145 0;}
@font-face
	{font-family:"\@SimSun";
	panose-1:2 1 6 0 3 1 1 1 1 1;
	mso-font-charset:134;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:3 135135232 16 0 262145 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-parent:"";
	margin:0cm;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:SimSun;}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;
	text-underline:single;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;
	text-underline:single;}
span.StileMessaggioDiPostaElettronica17
	{mso-style-type:personal;
	mso-style-noshow:yes;
	mso-ansi-font-size:10.0pt;
	mso-bidi-font-size:10.0pt;
	font-family:Arial;
	mso-ascii-font-family:Arial;
	mso-hansi-font-family:Arial;
	mso-bidi-font-family:Arial;
	color:windowtext;}
span.StileMessaggioDiPostaElettronica18
	{mso-style-type:personal-reply;
	mso-style-noshow:yes;
	mso-ansi-font-size:10.0pt;
	mso-bidi-font-size:10.0pt;
	font-family:Arial;
	mso-ascii-font-family:Arial;
	mso-hansi-font-family:Arial;
	mso-bidi-font-family:Arial;
	color:navy;}
span.SpellE
	{mso-style-name:"";
	mso-spl-e:yes;}
span.GramE
	{mso-style-name:"";
	mso-gram-e:yes;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:70.85pt 2.0cm 2.0cm 2.0cm;
	mso-header-margin:35.4pt;
	mso-footer-margin:35.4pt;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 @list l0
	{mso-list-id:60444377;
	mso-list-type:hybrid;
	mso-list-template-ids:-1459162004 68157457 68157465 68157467 68157455 =
68157465 68157467 68157455 68157465 68157467;}
@list l0:level1
	{mso-level-text:"%1\)";
	mso-level-tab-stop:36.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level2
	{mso-level-tab-stop:72.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level3
	{mso-level-tab-stop:108.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level4
	{mso-level-tab-stop:144.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level5
	{mso-level-tab-stop:180.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level6
	{mso-level-tab-stop:216.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level7
	{mso-level-tab-stop:252.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level8
	{mso-level-tab-stop:288.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level9
	{mso-level-tab-stop:324.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
-->
</style>
<!--[if gte mso 10]>
<style>
 /* Style Definitions */=20
 table.MsoNormalTable
	{mso-style-name:"Tabella normale";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-parent:"";
	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
	mso-para-margin:0cm;
	mso-para-margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:10.0pt;
	font-family:"Times New Roman";}
</style>
<![endif]-->
</head>

<body lang=3DIT link=3Dblue vlink=3Dpurple =
style=3D'tab-interval:35.4pt'>

<div class=3DSection1>

<p class=3DMsoNormal><span class=3DSpellE><font size=3D2 =
face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial'>Dear</span></font></span><fo=
nt
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'> =
all,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial;mso-ansi-language:EN-GB'>I just installed =
Scientific
Linux 5 and I used for the first time DM drivers for working with the =
embedded
RAID (the servers are IBM xSeries, with an Adaptec HostRAID ASR - SATA). =
I
really appreciate the fact that now Linux is able to recognize such =
devices,
but I had some troubles configuring it and I&#8217;d like to have some =
info for
better understanding how things work. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><o:p>&nbsp;</o:p></span=
></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial;mso-ansi-language:EN-GB'>I&#8217;ll be a little
&#8220;verbose&#8221; for clarifying what I did and which are my =
doubts&#8230;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><o:p>&nbsp;</o:p></span=
></font></p>

<p class=3DMsoNormal =
style=3D'margin-left:36.0pt;text-indent:-18.0pt;mso-list:l0 level1 lfo2;
tab-stops:list 36.0pt'><![if !supportLists]><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-fareast-font-family:
Arial;mso-ansi-language:EN-GB'><span style=3D'mso-list:Ignore'>1)<font =
size=3D1
face=3D"Times New Roman"><span style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></font></span></span></font><![endif]><span dir=3DLTR><font =
size=3D2
face=3DArial><span lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;
mso-ansi-language:EN-GB'>Installation &amp; =
Configuration<o:p></o:p></span></font></span></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><o:p=
>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'>I
installed SL5 on a system which was running SL3 with HW drivers released =
by
IBM. Linux was able to identify correctly the device (installed through =
CD),
mapped it as /dev/mapper/asr_ and proceeded with he =
installation.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><o:p=
>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'>Anyw=
ay,
I found a little problematic configuring it manually: I tried to install =
SL5 on
a node which was misconfigured: instead of seeing one device, it was =
managing
the 2 HD (/dev/sda and /dev/sdb) as 2 separate devices an if I tried to
configure them (at install time, via CD or network boot) with<span
style=3D'mso-spacerun:yes'>&nbsp; </span>DM, I got many errors about the =
RAID
table (&#8220;ERROR: asr: Invalid RAID config table checksum on =
/dev/sda&#8221;
or even &#8220;asr: Invalid magic number in RAID table; saw 0x0
expected&#8230;&#8221;). I tried to reconfigure the RAID card first via =
BIOS
and then trying<font color=3Dnavy><span style=3D'color:navy'> =
</span></font>again
to configure it via Linux (&#8220;dmsetup create &#8230;&#8221;) but =
even if it
seemed working (exit code 0), then querying the device asr_ (i.e. =
&#8220;dmraid
&#8211;r&#8221;) resulted in errors as reported above&#8230;or better, =
dmraid
commands (-r, -ay, -tay,&#8230;) reported errors, while dmsetup commands =
<span
style=3D'mso-spacerun:yes'>&nbsp;</span>(status, ls,&#8230;) worked =
normally. The
only way I found for well-configuring the device was to install SL3 with
specific drivers, and then to install SL5 with DM&#8230;all both =
commands now
work perfectly<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><o:p=
>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'>In
brief:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'>If
I try to configure DM-RAID from scratch and I get such errors, how can I =
do?
What&#8217;s that &#8220;RAID table&#8221;? Where is it written? Not in =
the MBR
of an HD, &#8216;cause I tried to copy the MBR of the cloned disk which =
had no
problem (still recognized as &#8220;good&#8221; for RAID and DM) and =
nothing
changed&#8230;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><o:p=
>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'margin-left:36.0pt;text-indent:-18.0pt;mso-list:l0 level1 lfo2;
tab-stops:list 36.0pt'><![if !supportLists]><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-fareast-font-family:
Arial;mso-ansi-language:EN-GB'><span style=3D'mso-list:Ignore'>2)<font =
size=3D1
face=3D"Times New Roman"><span style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></font></span></span></font><![endif]><span dir=3DLTR><font =
size=3D2
face=3DArial><span lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;
mso-ansi-language:EN-GB'>Managing =
disks<o:p></o:p></span></font></span></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><o:p=
>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'>I
configured disks in RAID 1 (mirror) but I wonder how to manage this =
RAID; in
particular, how can I do for:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><spa=
n
style=3D'mso-spacerun:yes'>&nbsp;</span>- stopping a device (disk) and =
put it
offline/and viceversa? <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><spa=
n
style=3D'mso-spacerun:yes'>&nbsp;</span>- reconfiguring/rebuilding it =
(due to
broken/faulting HD)? <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
lang=3DEN-GB
style=3D'font-size:10.0pt;font-family:Arial;color:navy;mso-ansi-language:=
EN-GB'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'>At
the moment I should change a couple of disks (SMARTD warnings reported), =
but I&#8217;m
scared about the &#8220;RAID table =
error&#8221;&#8230;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:18.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><o:p=
>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><o:p>&nbsp;</o:p></span=
></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial;mso-ansi-language:EN-GB'>Many Thanks in advance =
for
all help you can give me&#8230;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><o:p>&nbsp;</o:p></span=
></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial;mso-ansi-language:EN-GB'>Best =
Regards<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial;mso-ansi-language:EN-GB'><o:p>&nbsp;</o:p></span=
></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Vega Forneris<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier =
New";mso-no-proof:yes'>+--------------------------------------+</span></f=
ont><span
style=3D'mso-no-proof:yes'><o:p></o:p></span></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New";mso-no-proof:yes'>&nbsp;Vega =
Forneris</span></font><span
style=3D'mso-no-proof:yes'><o:p></o:p></span></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New";mso-no-proof:yes'><br>
&nbsp;CNR &#8211; Servizi Informatici di =
Campo<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New";mso-no-proof:yes'>&nbsp;Gestione servizi =
GRID<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New";mso-no-proof:yes'><br>
&nbsp;Area di Ricerca Roma II - Tor Vergata<br>
&nbsp;Via del Fosso del Cavaliere, 100<br>
&nbsp;00133 Roma</span></font><span =
style=3D'mso-no-proof:yes'><o:p></o:p></span></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt;mso-no-proof:yes'><br>
</span></font><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New";mso-no-proof:yes'>&nbsp;Tel:&nbsp; &nbsp;+39 =
06 4993
4667</span></font><span =
style=3D'mso-no-proof:yes'><o:p></o:p></span></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New";mso-no-proof:yes'>&nbsp;Fax:&nbsp;&nbsp; +39 =
06 4993
4650</span></font><span =
style=3D'mso-no-proof:yes'><o:p></o:p></span></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New";mso-no-proof:yes'>&nbsp;Email: =
</span></font><span
style=3D'mso-no-proof:yes'><a =
href=3D"mailto:Vega.Forneris@sic.rm.cnr.it"><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Vega.Forneris@sic.rm.cnr.it</span></font></a><o:p></o:p></span></p>=


<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier =
New";mso-no-proof:yes'>+--------------------------------------+</span></f=
ont><o:p></o:p></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------=_NextPart_001_0084_01C8159F.6B7E93E0--

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814CC.125D7DE0>

QWN0aXZlTWltZQAAAfAEAAAA/////3AADfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814CC.8116FB30>

QWN0aXZlTWltZQAAAfAEAAAA/////4AADfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814CC.F21B2BD0>

QWN0aXZlTWltZQAAAfAEAAAA/////5AADfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814CD.7949A5A0>

QWN0aXZlTWltZQAAAfAEAAAA/////6AADfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814CE.0FE91090>

QWN0aXZlTWltZQAAAfAEAAAA/////7AADfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814CE.A7C0D470>

QWN0aXZlTWltZQAAAfAEAAAA/////8AADfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814CF.21AE8390>

QWN0aXZlTWltZQAAAfAEAAAA/////9AADfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814CF.8EF42590>

QWN0aXZlTWltZQAAAfAEAAAA/////+AADfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814CF.FE4D8C60>

QWN0aXZlTWltZQAAAfAEAAAA//////AADfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814D0.6AE78510>

QWN0aXZlTWltZQAAAfAEAAAA/////wABDfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814D0.D6FE6B10>

QWN0aXZlTWltZQAAAfAEAAAA/////xABDfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814D1.65EC8960>

QWN0aXZlTWltZQAAAfAEAAAA/////yABDfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C814D1.B85AFBF0>

QWN0aXZlTWltZQAAAfAEAAAA/////zABDfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C8159E.F9A3D960>

QWN0aXZlTWltZQAAAfAEAAAA/////0AADfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0
Content-Type: application/octet-stream;
	name="editdata.mso"
Content-Transfer-Encoding: base64
Content-ID: <editdata.mso@01C8159F.6B04F710>

QWN0aXZlTWltZQAAAfAEAAAA/////1AADfASAAAAAQEAAAIAAAAAAAAAEAQAAP9AAAAL8AQAAAAS
NFZ4

------=_NextPart_000_0083_01C8159F.6B7E93E0--


--===============0369496742==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0369496742==--
