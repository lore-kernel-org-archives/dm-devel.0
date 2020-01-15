From: <Sreenivas.Honnur@dell.com>
Subject: device blacklisting and suspend issue
Date: Wed, 15 Jan 2020 07:11:39 +0000
Message-ID: <451c7e3b120e4880b9ed178850f15285@BLRX13MDC423.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7129444931359559740=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============7129444931359559740==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_451c7e3b120e4880b9ed178850f15285BLRX13MDC423AMERDELLCOM_"

--_000_451c7e3b120e4880b9ed178850f15285BLRX13MDC423AMERDELLCOM_
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

I have two queries:

  1.  We have an issue with device blacklisting. We add an entry in /etc/mu=
ltipath.conf" and do "service multipathd reload".
After this to check if device is blacklisted we issue "multipathd show blac=
klist" command in a loop(with a delay of 1 second).
Sometimes I see that this command takes too much time to come out or someti=
mes it just hangs. Is this the correct way to check if device is blackliste=
d? Or is there any other way to do it?


  1.  After suspending (dmsetup suspend wwid) a device,  is there a way to =
inform multipathd not to make it active if some events happen on this devic=
e(like new path added..etc...I see that the table is reloaded and device be=
comes active)

How to avoid this i.e. the device should be in "suspended" state until I do=
 a "resume" on it, "multipathd" should not enable it until I do "dmsetup re=
sume"







--_000_451c7e3b120e4880b9ed178850f15285BLRX13MDC423AMERDELLCOM_
Content-Type: text/html; charset=WINDOWS-1252
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
=09{font-family:"Cambria Math";
=09panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0in;
=09margin-bottom:.0001pt;
=09font-size:11.0pt;
=09font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:#0563C1;
=09text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
=09{mso-style-priority:99;
=09color:#954F72;
=09text-decoration:underline;}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
=09{mso-style-priority:34;
=09margin-top:0in;
=09margin-right:0in;
=09margin-bottom:0in;
=09margin-left:.5in;
=09margin-bottom:.0001pt;
=09font-size:11.0pt;
=09font-family:"Calibri",sans-serif;}
span.EmailStyle17
=09{mso-style-type:personal-compose;
=09font-family:"Calibri",sans-serif;
=09color:windowtext;}
.MsoChpDefault
=09{mso-style-type:export-only;
=09font-family:"Calibri",sans-serif;}
@page WordSection1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
=09{page:WordSection1;}
/* List Definitions */
@list l0
=09{mso-list-id:847448017;
=09mso-list-type:hybrid;
=09mso-list-template-ids:-612727868 67698703 67698713 67698715 67698703 676=
98713 67698715 67698703 67698713 67698715;}
@list l0:level1
=09{mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level2
=09{mso-level-number-format:alpha-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level3
=09{mso-level-number-format:roman-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:right;
=09text-indent:-9.0pt;}
@list l0:level4
=09{mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level5
=09{mso-level-number-format:alpha-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level6
=09{mso-level-number-format:roman-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:right;
=09text-indent:-9.0pt;}
@list l0:level7
=09{mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level8
=09{mso-level-number-format:alpha-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l0:level9
=09{mso-level-number-format:roman-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:right;
=09text-indent:-9.0pt;}
@list l1
=09{mso-list-id:1682581990;
=09mso-list-type:hybrid;
=09mso-list-template-ids:1190816600 67698703 67698713 67698715 67698703 676=
98713 67698715 67698703 67698713 67698715;}
@list l1:level1
=09{mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l1:level2
=09{mso-level-number-format:alpha-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l1:level3
=09{mso-level-number-format:roman-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:right;
=09text-indent:-9.0pt;}
@list l1:level4
=09{mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l1:level5
=09{mso-level-number-format:alpha-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l1:level6
=09{mso-level-number-format:roman-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:right;
=09text-indent:-9.0pt;}
@list l1:level7
=09{mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l1:level8
=09{mso-level-number-format:alpha-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:left;
=09text-indent:-.25in;}
@list l1:level9
=09{mso-level-number-format:roman-lower;
=09mso-level-tab-stop:none;
=09mso-level-number-position:right;
=09text-indent:-9.0pt;}
ol
=09{margin-bottom:0in;}
ul
=09{margin-bottom:0in;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">I have two queries:<o:p></o:p></p>
<ol style=3D"margin-top:0in" start=3D"1" type=3D"1">
<li class=3D"MsoListParagraph" style=3D"margin-left:0in;mso-list:l0 level1 =
lfo2">We have an issue with device blacklisting. We add an entry in /etc/mu=
ltipath.conf&#8221; and do &#8220;service multipathd reload&#8221;.<o:p></o=
:p></li></ol>
<p class=3D"MsoNormal">After this to check if device is blacklisted we issu=
e &#8220;multipathd show blacklist&#8221; command in a loop(with a delay of=
 1 second).<o:p></o:p></p>
<p class=3D"MsoNormal">Sometimes I see that this command takes too much tim=
e to come out or sometimes it just hangs. Is this the correct way to check =
if device is blacklisted? Or is there any other way to do it?<o:p></o:p></p=
>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<ol style=3D"margin-top:0in" start=3D"2" type=3D"1">
<li class=3D"MsoListParagraph" style=3D"margin-left:0in;mso-list:l0 level1 =
lfo2">After suspending (dmsetup suspend wwid) a device, &nbsp;is there a wa=
y to inform multipathd not to make it active if some events happen on this =
device(like new path added..etc&#8230;I see that
 the table is reloaded and device becomes active)<o:p></o:p></li></ol>
<p class=3D"MsoListParagraph">How to avoid this i.e. the device should be i=
n &#8220;suspended&#8221; state until I do a &#8220;resume&#8221; on it, &#=
8220;multipathd&#8221; should not enable it until I do &#8220;dmsetup resum=
e&#8221;<o:p></o:p></p>
<p class=3D"MsoListParagraph"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoListParagraph"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoListParagraph"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_451c7e3b120e4880b9ed178850f15285BLRX13MDC423AMERDELLCOM_--

--===============7129444931359559740==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7129444931359559740==--
