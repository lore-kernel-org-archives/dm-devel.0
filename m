From: "A M, Ashalatha" <ashalatha-a.a@hpe.com>
Subject: dm stats
Date: Wed, 21 Dec 2016 10:49:06 +0000
Message-ID: <DF4PR84MB01530961D1F61928EF4B4101A0930@DF4PR84MB0153.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5125863906138618676=="
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

--===============5125863906138618676==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DF4PR84MB01530961D1F61928EF4B4101A0930DF4PR84MB0153NAMP_"

--_000_DF4PR84MB01530961D1F61928EF4B4101A0930DF4PR84MB0153NAMP_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

Just want a clarification about device mapper stats:

http://lxr.free-electrons.com/source/Documentation/device-mapper/statistics=
.txt?v=3D3.14

In this documentation, would like to know what is the command to be used to=
 create/print/list stats.

@stats_create <range> <step> [<program_id> [<aux_data>]]

@stats_print <region_id> [<starting_line> <number_of_lines>]

@stats_list [<program_id>]



Also, it is documented that 11 stats(Documentation/iostats.txt) would be re=
ported and additional counters as well:



12. the total time spent reading in milliseconds

13. the total time spent writing in milliseconds

So are these same as "read_ticks" and "write_ticks" else how different from=
 the ticks?

Thanks,
Asha

--_000_DF4PR84MB01530961D1F61928EF4B4101A0930DF4PR84MB0153NAMP_
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
pre
	{mso-style-priority:99;
	mso-style-link:"HTML Preformatted Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-priority:99;
	mso-style-link:"HTML Preformatted";
	font-family:"Courier New";}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Hi,<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">Just want a clarificat=
ion about device mapper stats:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><a href=3D"http://lxr.=
free-electrons.com/source/Documentation/device-mapper/statistics.txt?v=3D3.=
14">http://lxr.free-electrons.com/source/Documentation/device-mapper/statis=
tics.txt?v=3D3.14</a><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">In this documentation,=
 would like to know what is the command to be used to create/print/list sta=
ts.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal" style=3D"background:white"><b><span style=3D"font-si=
ze:11.5pt;font-family:&quot;Courier New&quot;;color:#787878">@stats_create =
&lt;range&gt; &lt;step&gt; [&lt;program_id&gt; [&lt;aux_data&gt;]]<o:p></o:=
p></span></b></p>
<pre style=3D"background:white"><b><span style=3D"font-size:11.5pt;color:#7=
87878">@stats_print &lt;region_id&gt; [&lt;starting_line&gt; &lt;number_of_=
lines&gt;]<o:p></o:p></span></b></pre>
<pre style=3D"background:white"><b><span style=3D"font-size:11.5pt;color:#7=
87878">@stats_list [&lt;program_id&gt;]<o:p></o:p></span></b></pre>
<pre style=3D"background:white"><b><span style=3D"font-size:11.5pt;color:#7=
87878"><o:p>&nbsp;</o:p></span></b></pre>
<pre style=3D"background:white"><b><span style=3D"font-size:11.5pt;color:#7=
87878">Also, it is documented that 11 stats(Documentation/iostats.txt) woul=
d be reported and additional counters as well:<o:p></o:p></span></b></pre>
<pre style=3D"background:white"><b><span style=3D"font-size:11.5pt;color:#7=
87878"><o:p>&nbsp;</o:p></span></b></pre>
<pre style=3D"background:white"><b><span style=3D"font-size:11.5pt;color:#7=
87878">12. the total time spent reading in milliseconds<o:p></o:p></span></=
b></pre>
<pre style=3D"background:white"><b><span style=3D"font-size:11.5pt;color:#7=
87878">13. the total time spent writing in milliseconds<o:p></o:p></span></=
b></pre>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">So are these same as &=
#8220;read_ticks&#8221; and &#8220;write_ticks&#8221; else how different fr=
om the ticks?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks,<o:p></o:p></p>
<p class=3D"MsoNormal">Asha<o:p></o:p></p>
</div>
</body>
</html>

--_000_DF4PR84MB01530961D1F61928EF4B4101A0930DF4PR84MB0153NAMP_--


--===============5125863906138618676==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5125863906138618676==--
