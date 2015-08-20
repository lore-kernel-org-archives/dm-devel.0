From: Artem Danielov <artem@flashgrid.io>
Subject: Re: multipathd removing DM devices that don't belong to
	it
Date: Thu, 20 Aug 2015 19:17:06 +0000
Message-ID: <DM3PR1101MB1183B45E72F8E2EF8E3E6DD4D5660@DM3PR1101MB1183.namprd11.prod.outlook.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8139251440169984643=="
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
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8139251440169984643==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DM3PR1101MB1183B45E72F8E2EF8E3E6DD4D5660DM3PR1101MB1183_"

--_000_DM3PR1101MB1183B45E72F8E2EF8E3E6DD4D5660DM3PR1101MB1183_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Ben,
Unfortunately, I missed your response two months ago. Somehow it didn't get=
 to my mailbox. Found it on the web. I would like to revisit this question.

I think I understood your explanation. Our proposal is to add an ignore_mul=
tipaths section to multipath.conf that looks like the following:

ignore_multipaths
{
    name "flashgrid*"
}

This example should prevent multipathd from touching any DM devices with na=
mes starting with 'flashgrid'
The justification is that this will allow custom implementations of multipa=
th management that also use dmsetup and that can co-exist on the same syste=
m with multipathd.

Is this possible to do? We will be happy to do testing.

Thank you!
-Artem


________________________________

  *   From: "Benjamin Marzinski" <bmarzins redhat com>
  *   To: device-mapper development <dm-devel redhat com>
  *   Subject: Re: [dm-devel] multipathd removing DM devices that don't bel=
ong to it
  *   Date: Mon, 22 Jun 2015 11:04:38 -0500

________________________________

On Tue, Jun 16, 2015 at 10:02:23PM +0000, Artem Danielov wrote:

>    Hello,

>

>    Looking for an advice on whether this is an expected behavior or a bug=
.

>

>    device-mapper-multipath-0.4.9-77.el7.x86_64

>

>

>

>    When multipathd service starts it will remove any DM devices with

>    multipath target, even if the underlying devices are blacklisted.

>

>    We are trying to use dmsetup directly  to implement custom multipath

>    management logic separate from multipathd. But unfortunately if multip=
athd

>    is present and enabled it removes DM devices with multipath target tha=
t we

>    create.

>

>

>

>    Is this a bug?



I don't know if I'd call it a bug. It is certainly how multipath is

designed to work.  The issue is this.  When you start multipathd up do a

reconfigure.  It doesn't know if the configuration has changed. So, if

there are devices configured and it doesn't think they should be, it

assumes that you've changed your configuration, and you'd like it to use

your current configuration, which means removing devices that no longer

are allowed.



I don't see any way of making this work, without adding a section to the

multipath.conf file to ignore devices with certain wwids entirely (which

is different from blacklisting them).



-Ben



>

>

>

>    Thanks for your help!

>

>

>

>    Artem Danielov | Chief Technology Officer | FlashGrid Inc. |

>    [1]artem flashgrid io | +1-503-568-5249

>

>

>

> References

>

>    Visible links

>    1. mailto:artem flashgrid io



> --

> dm-devel mailing list

> dm-devel redhat com

> https://www.redhat.com/mailman/listinfo/dm-devel




--_000_DM3PR1101MB1183B45E72F8E2EF8E3E6DD4D5660DM3PR1101MB1183_
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
<!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
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
pre
	{mso-style-priority:99;
	mso-style-link:"HTML Preformatted Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New",serif;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-priority:99;
	mso-style-link:"HTML Preformatted";
	font-family:"Courier New",serif;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:2057927646;
	mso-list-template-ids:-2050201166;}
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
	font-family:"Courier New",serif;
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
<p class=3D"MsoNormal">Hi Ben,<o:p></o:p></p>
<p class=3D"MsoNormal">Unfortunately, I missed your response two months ago=
. Somehow it didn&#8217;t get to my mailbox. Found it on the web. I would l=
ike to revisit this question.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I think I understood your explanation. Our proposal =
is to add an ignore_multipaths section to multipath.conf that looks like th=
e following:<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;,s=
erif">ignore_multipaths<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;,s=
erif">{<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;,s=
erif">&nbsp;&nbsp;&nbsp; name &quot;flashgrid*&quot;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;,s=
erif">}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Courier New&quot;,s=
erif"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal">This example should prevent multipathd from touching=
 any DM devices with names starting with &#8216;flashgrid&#8217;<o:p></o:p>=
</p>
<p class=3D"MsoNormal">The justification is that this will allow custom imp=
lementations of multipath management that also use dmsetup and that can co-=
exist on the same system with multipathd.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Is this possible to do? We will be happy to do testi=
ng.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thank you!<o:p></o:p></p>
<p class=3D"MsoNormal">-Artem<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt"><o:p>&nbsp;</o:p></s=
pan></p>
<div class=3D"MsoNormal" align=3D"center" style=3D"text-align:center"><span=
 style=3D"font-size:9.0pt">
<hr size=3D"2" width=3D"100%" noshade=3D"" style=3D"color:black" align=3D"c=
enter">
</span></div>
<ul type=3D"disc">
<li class=3D"MsoNormal" style=3D"color:black;mso-margin-top-alt:auto;mso-ma=
rgin-bottom-alt:auto;mso-list:l0 level1 lfo1">
<em><span style=3D"font-family:&quot;Calibri&quot;,sans-serif">From</span><=
/em>: &quot;Benjamin Marzinski&quot; &lt;bmarzins redhat com&gt;<o:p></o:p>=
</li><li class=3D"MsoNormal" style=3D"color:black;mso-margin-top-alt:auto;m=
so-margin-bottom-alt:auto;mso-list:l0 level1 lfo1">
<em><span style=3D"font-family:&quot;Calibri&quot;,sans-serif">To</span></e=
m>: device-mapper development &lt;dm-devel redhat com&gt;<o:p></o:p></li><l=
i class=3D"MsoNormal" style=3D"color:black;mso-margin-top-alt:auto;mso-marg=
in-bottom-alt:auto;mso-list:l0 level1 lfo1">
<em><span style=3D"font-family:&quot;Calibri&quot;,sans-serif">Subject</spa=
n></em>: Re: [dm-devel] multipathd removing DM devices that don't belong to=
 it<o:p></o:p></li><li class=3D"MsoNormal" style=3D"color:black;mso-margin-=
top-alt:auto;mso-margin-bottom-alt:auto;mso-list:l0 level1 lfo1">
<em><span style=3D"font-family:&quot;Calibri&quot;,sans-serif">Date</span><=
/em>: Mon, 22 Jun 2015 11:04:38 -0500<o:p></o:p></li></ul>
<div class=3D"MsoNormal" align=3D"center" style=3D"text-align:center"><span=
 style=3D"font-size:9.0pt">
<hr size=3D"2" width=3D"100%" noshade=3D"" style=3D"color:black" align=3D"c=
enter">
</span></div>
<pre style=3D"orphans: auto;text-align:start;widows: 1;-webkit-text-stroke-=
width: 0px;word-spacing:0px"><span style=3D"color:black">On Tue, Jun 16, 20=
15 at 10:02:23PM &#43;0000, Artem Danielov wrote:<o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; Hello,<o:p></o:p></=
span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; Looking for an advi=
ce on whether this is an expected behavior or a bug.<o:p></o:p></span></pre=
>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; device-mapper-multi=
path-0.4.9-77.el7.x86_64<o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; &nbsp;<o:p></o:p></=
span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; When multipathd ser=
vice starts it will remove any DM devices with<o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; multipath target, e=
ven if the underlying devices are blacklisted.<o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; We are trying to us=
e dmsetup directly &nbsp;to implement custom multipath<o:p></o:p></span></p=
re>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; management logic se=
parate from multipathd. But unfortunately if multipathd<o:p></o:p></span></=
pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; is present and enab=
led it removes DM devices with multipath target that we<o:p></o:p></span></=
pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; create.<o:p></o:p><=
/span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; &nbsp;<o:p></o:p></=
span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; Is this a bug?<o:p>=
</o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">I don't know if I'd call it a bug. It is c=
ertainly how multipath is<o:p></o:p></span></pre>
<pre><span style=3D"color:black">designed to work.&nbsp; The issue is this.=
&nbsp; When you start multipathd up do a<o:p></o:p></span></pre>
<pre><span style=3D"color:black">reconfigure.&nbsp; It doesn't know if the =
configuration has changed. So, if<o:p></o:p></span></pre>
<pre><span style=3D"color:black">there are devices configured and it doesn'=
t think they should be, it<o:p></o:p></span></pre>
<pre><span style=3D"color:black">assumes that you've changed your configura=
tion, and you'd like it to use<o:p></o:p></span></pre>
<pre><span style=3D"color:black">your current configuration, which means re=
moving devices that no longer<o:p></o:p></span></pre>
<pre><span style=3D"color:black">are allowed.<o:p></o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">I don't see any way of making this work, w=
ithout adding a section to the<o:p></o:p></span></pre>
<pre><span style=3D"color:black">multipath.conf file to ignore devices with=
 certain wwids entirely (which<o:p></o:p></span></pre>
<pre><span style=3D"color:black">is different from blacklisting them).<o:p>=
</o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">-Ben<o:p></o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; &nbsp;<o:p></o:p></=
span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; Thanks for your hel=
p!<o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; &nbsp;<o:p></o:p></=
span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; Artem Danielov | Ch=
ief Technology Officer | FlashGrid Inc. |<o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; [1]artem flashgrid =
io | &#43;1-503-568-5249<o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; &nbsp;<o:p></o:p></=
span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt; References<o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; Visible links<o:p><=
/o:p></span></pre>
<pre><span style=3D"color:black">&gt;&nbsp;&nbsp;&nbsp; 1. <a href=3D"mailt=
o:artem">mailto:artem</a> flashgrid io<o:p></o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">&gt; --<o:p></o:p></span></pre>
<pre><span style=3D"color:black">&gt; dm-devel mailing list<o:p></o:p></spa=
n></pre>
<pre><span style=3D"color:black">&gt; dm-devel redhat com<o:p></o:p></span>=
</pre>
<pre><span style=3D"color:black">&gt; <a href=3D"https://www.redhat.com/mai=
lman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a=
><o:p></o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_DM3PR1101MB1183B45E72F8E2EF8E3E6DD4D5660DM3PR1101MB1183_--


--===============8139251440169984643==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8139251440169984643==--
