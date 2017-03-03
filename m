From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Re: scsi timeout on multipath
Date: Fri, 3 Mar 2017 09:17:40 +0000
Message-ID: <af3abc2148c64309a4773bc6f92016ac@BRMWP-EXMB11.corp.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1947555099070472508=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1947555099070472508==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_af3abc2148c64309a4773bc6f92016acBRMWPEXMB11corpbrocadec_"

--_000_af3abc2148c64309a4773bc6f92016acBRMWPEXMB11corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Any input here will help me a lot.

Regards,
Muneendra.

From: Muneendra Kumar M
Sent: Tuesday, February 21, 2017 6:58 PM
To: 'dm-devel@redhat.com' <dm-devel@redhat.com>
Subject: scsi timeout on multipath

Hi ,
On a multipath network if we see a scsi timeout  on a particular path at what instance we will mark the path as failed.

Whether we will mark the path as failed when SCSI mid level failed to attempts error recovery by doing the below steps.

*        the SCSI command that has timed out is aborted

*        a SCSI device reset is attempted

*        a SCSI bus reset is attempted. Note this may have an adverse effect on other devices sharing that SCSI bus.

*        a SCSI host (bus adapter) reset is attempted. This is an attempt to re-initialize the adapter card associated with the SCSI device that has the timed out command.
Any info here will help me a lot.

Regards,
Muneendra.


--_000_af3abc2148c64309a4773bc6f92016acBRMWPEXMB11corpbrocadec_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
p
	{mso-style-priority:99;
	mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman",serif;}
span.EmailStyle18
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.EmailStyle19
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:#1F497D;}
span.EmailStyle20
	{mso-style-type:personal-reply;
	font-family:"Calibri",sans-serif;
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:930167181;
	mso-list-template-ids:292036308;}
@list l0:level1
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Symbol;}
@list l0:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:1.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:"Courier New";
	mso-bidi-font-family:"Times New Roman";}
@list l0:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:1.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:2.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level5
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:2.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:3.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:3.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level8
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:4.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:4.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Any input here will he=
lp me a lot.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Regards,<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Muneendra.<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><a name=3D"_MailEndCompose"><span style=3D"color:#1F=
497D"><o:p>&nbsp;</o:p></span></a></p>
<div>
<div style=3D"border:none;border-top:solid #E1E1E1 1.0pt;padding:3.0pt 0in =
0in 0in">
<p class=3D"MsoNormal"><b>From:</b> Muneendra Kumar M <br>
<b>Sent:</b> Tuesday, February 21, 2017 6:58 PM<br>
<b>To:</b> 'dm-devel@redhat.com' &lt;dm-devel@redhat.com&gt;<br>
<b>Subject:</b> scsi timeout on multipath<o:p></o:p></p>
</div>
</div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Hi ,<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">On a multipath network=
 if we see a scsi timeout&nbsp; on a particular path at what instance we wi=
ll mark the path as failed.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Whether we will mark t=
he path as failed when SCSI mid level failed to attempts error recovery by =
doing the below steps.<o:p></o:p></span></p>
<p style=3D"margin-left:.5in;text-indent:-.25in;mso-list:l0 level1 lfo2;bac=
kground:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Symbol;col=
or:#1F497D"><span style=3D"mso-list:Ignore">&middot;<span style=3D"font:7.0=
pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span style=3D"font-size:11.0pt;font-family:=
&quot;Calibri&quot;,sans-serif;color:#1F497D">the SCSI command that has tim=
ed out is aborted&nbsp;<o:p></o:p></span></p>
<p style=3D"margin-left:.5in;text-indent:-.25in;mso-list:l0 level1 lfo2;bac=
kground:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Symbol;col=
or:#1F497D"><span style=3D"mso-list:Ignore">&middot;<span style=3D"font:7.0=
pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span style=3D"font-size:11.0pt;font-family:=
&quot;Calibri&quot;,sans-serif;color:#1F497D">a SCSI device reset is attemp=
ted<o:p></o:p></span></p>
<p style=3D"margin-left:.5in;text-indent:-.25in;mso-list:l0 level1 lfo2;bac=
kground:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Symbol;col=
or:#1F497D"><span style=3D"mso-list:Ignore">&middot;<span style=3D"font:7.0=
pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span style=3D"font-size:11.0pt;font-family:=
&quot;Calibri&quot;,sans-serif;color:#1F497D">a SCSI bus reset is attempted=
. Note this may have an adverse effect on other devices sharing that SCSI b=
us.<o:p></o:p></span></p>
<p style=3D"margin-left:.5in;text-indent:-.25in;mso-list:l0 level1 lfo2;bac=
kground:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Symbol;col=
or:#1F497D"><span style=3D"mso-list:Ignore">&middot;<span style=3D"font:7.0=
pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span style=3D"font-size:11.0pt;font-family:=
&quot;Calibri&quot;,sans-serif;color:#1F497D">a SCSI host (bus adapter) res=
et is attempted. This is an attempt to re-initialize the adapter card assoc=
iated with the SCSI device that has the timed
 out command.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Any info here will hel=
p me a lot.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Regards,<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Muneendra.<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_af3abc2148c64309a4773bc6f92016acBRMWPEXMB11corpbrocadec_--


--===============1947555099070472508==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1947555099070472508==--
