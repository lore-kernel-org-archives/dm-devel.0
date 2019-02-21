From: Suoben <suoben@huawei.com>
Subject: Consult about revert PATH_GOST in tur_check
Date: Thu, 21 Feb 2019 13:02:50 +0000
Message-ID: <B1BDF08B4A5F7B4A9F894A239CD487B39B47AF3D@dggeml505-mbx.china.huawei.com>
References: <90F81145D0562E42B2CB5DE6FF4F3DBEAE0704@DGGEMA505-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2973150120725010709=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <90F81145D0562E42B2CB5DE6FF4F3DBEAE0704@DGGEMA505-MBX.china.huawei.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hare@suse.de" <hare@suse.de>, "christophe.varoqui@free.fr" <christophe.varoqui@free.fr>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: hanyandong <hanyandong1@huawei.com>, "chenminhua (A)" <chenminhua1@huawei.com>, "Wanghui (John)" <john.wanghui@huawei.com>
List-Id: dm-devel.ids

--===============2973150120725010709==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_B1BDF08B4A5F7B4A9F894A239CD487B39B47AF3Ddggeml505mbxchi_"

--_000_B1BDF08B4A5F7B4A9F894A239CD487B39B47AF3Ddggeml505mbxchi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hi Reinecke
Description of problem:

1.       As network issue, System is disconnected from the Storage.

2.       When network recover, we found two path are in "ghost" state

3.       We need to register PRKEY. But it failed when register PRKEY throu=
gh the two "ghost" path.

4.       It seems wired, maybe the Storage hardware have issue. but now we =
want to work around this issue in multipath first.

5.       Our work around solution is as following

a)         Revert this patch "Return 'ghost' state when port is in standby"=
(5da642ff71254ecda685e82c681e78cab4c75b87)

b)         Then all PATH_GHOST will be treated as PATH_FAILED

c)         and multipath will only register PRKEY by PATH_UP pathes.
Questions:
so we want to consult whether there some potential issue after we revert th=
e patch?
We know it will lead to some performance and reliability loss. We mainly wo=
rry about
whether there are some potential functional and fundamental issues?
Thanks a lot.

Environment Info:

mpathal (2e0176ad6309077166c9ce90033bfa248_1) dm-2 TestSAN

size=3D20G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw

`-+- policy=3D'round-robin 0' prio=3D50 status=3Dactive

  |- 8:0:5:1 sddg 8:96  active ready running

  `- 9:0:6:1 sdwh 12:112 active ready running

`-+- policy=3D'round-robin 0' prio=3D10 status=3Denabled

  |- 10:0:5:1 sdga 21:96  active ready running

  `- 11:0:6:1 sdhb 81:112 active ready running

`-+- policy=3D'round-robin 0' prio=3D1 status=3D enabled

  |- 12:0:5:1 sdgj 15:6  active ghost running

  `- 13:0:6:1 sdhk 16:112 active ghost running


defaults {
                   path_checker            tur
                   no_path_retry           18
                   path_grouping_policy    group_by_prio
                   prio                    const
                   deferred_remove         yes
                   uid_attribute           "ID_SERIAL"
                   reassign_maps           no
                   failback                immediate
                   log_checker_err         once
}

devices {
      device {
       vendor                              "TestSAN"
       product                             "LU"
       path_grouping_policy       group_by_prio
       no_path_retry                   30
       prio                                    alua
       path_checker                     tur
       path_selector                    "round-robin 0"
       hardware_handler               "0"
       failback                                15
        }
}


--_000_B1BDF08B4A5F7B4A9F894A239CD487B39B47AF3Ddggeml505mbxchi_
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
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
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
	mso-style-link:"HTML \9884\8BBE\683C\5F0F Char";
	margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:SimSun;}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	text-indent:21.0pt;
	font-size:10.5pt;
	font-family:"Calibri",sans-serif;}
span.HTMLChar
	{mso-style-name:"HTML \9884\8BBE\683C\5F0F Char";
	mso-style-priority:99;
	mso-style-link:"HTML \9884\8BBE\683C\5F0F";
	font-family:SimSun;}
span.EmailStyle20
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.EmailStyle21
	{mso-style-type:personal-reply;
	font-family:"Calibri",sans-serif;
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:2027636495;
	mso-list-type:hybrid;
	mso-list-template-ids:2077397728 1288478264 67698713 67698715 67698703 676=
98713 67698715 67698703 67698713 67698715;}
@list l0:level1
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:18.0pt;
	text-indent:-18.0pt;}
@list l0:level2
	{mso-level-number-format:alpha-lower;
	mso-level-text:"%2\)";
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:42.0pt;
	text-indent:-21.0pt;}
@list l0:level3
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	margin-left:63.0pt;
	text-indent:-21.0pt;}
@list l0:level4
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:84.0pt;
	text-indent:-21.0pt;}
@list l0:level5
	{mso-level-number-format:alpha-lower;
	mso-level-text:"%5\)";
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:105.0pt;
	text-indent:-21.0pt;}
@list l0:level6
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	margin-left:126.0pt;
	text-indent:-21.0pt;}
@list l0:level7
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:147.0pt;
	text-indent:-21.0pt;}
@list l0:level8
	{mso-level-number-format:alpha-lower;
	mso-level-text:"%8\)";
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:168.0pt;
	text-indent:-21.0pt;}
@list l0:level9
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	margin-left:189.0pt;
	text-indent:-21.0pt;}
ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"ZH-CN" link=3D"#0563C1" vlink=3D"#954F72" style=3D"text-justi=
fy-trim:punctuation">
<div class=3D"WordSection1">
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Hi <span style=3D"color:#1F497D=
">Reinecke</span><o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">Description of problem:<o:p></o:p></span></p>
<p class=3D"MsoListParagraph" align=3D"left" style=3D"mso-margin-top-alt:12=
.0pt;margin-right:12.0pt;margin-bottom:12.0pt;margin-left:18.0pt;text-align=
:left;text-indent:-18.0pt;mso-list:l0 level1 lfo2;background:white">
<![if !supportLists]><span lang=3D"EN-US"><span style=3D"mso-list:Ignore">1=
.<span style=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span lang=3D"EN-US">As network issue, Syste=
m is disconnected from the Storage.<o:p></o:p></span></p>
<p class=3D"MsoListParagraph" align=3D"left" style=3D"mso-margin-top-alt:12=
.0pt;margin-right:12.0pt;margin-bottom:12.0pt;margin-left:18.0pt;text-align=
:left;text-indent:-18.0pt;mso-list:l0 level1 lfo2;background:white">
<![if !supportLists]><span lang=3D"EN-US"><span style=3D"mso-list:Ignore">2=
.<span style=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span lang=3D"EN-US">When network recover, w=
e found two path are in &#8220;ghost&#8221; state<o:p></o:p></span></p>
<p class=3D"MsoListParagraph" align=3D"left" style=3D"mso-margin-top-alt:12=
.0pt;margin-right:12.0pt;margin-bottom:12.0pt;margin-left:18.0pt;text-align=
:left;text-indent:-18.0pt;mso-list:l0 level1 lfo2;background:white">
<![if !supportLists]><span lang=3D"EN-US"><span style=3D"mso-list:Ignore">3=
.<span style=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span lang=3D"EN-US">We need to register PRK=
EY. But it failed when register PRKEY through the two &#8220;ghost&#8221; p=
ath.<o:p></o:p></span></p>
<p class=3D"MsoListParagraph" align=3D"left" style=3D"mso-margin-top-alt:12=
.0pt;margin-right:12.0pt;margin-bottom:12.0pt;margin-left:18.0pt;text-align=
:left;text-indent:-18.0pt;mso-list:l0 level1 lfo2;background:white">
<![if !supportLists]><span lang=3D"EN-US"><span style=3D"mso-list:Ignore">4=
.<span style=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span lang=3D"EN-US">It seems wired, maybe t=
he Storage hardware have issue. but now we want to work around this issue i=
n multipath first.<o:p></o:p></span></p>
<p class=3D"MsoListParagraph" align=3D"left" style=3D"mso-margin-top-alt:12=
.0pt;margin-right:12.0pt;margin-bottom:12.0pt;margin-left:18.0pt;text-align=
:left;text-indent:-18.0pt;mso-list:l0 level1 lfo2;background:white">
<![if !supportLists]><span lang=3D"EN-US"><span style=3D"mso-list:Ignore">5=
.<span style=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span lang=3D"EN-US">Our work around solutio=
n is as following<o:p></o:p></span></p>
<p class=3D"MsoListParagraph" align=3D"left" style=3D"mso-margin-top-alt:12=
.0pt;margin-right:12.0pt;margin-bottom:12.0pt;margin-left:42.0pt;text-align=
:left;text-indent:-21.0pt;mso-list:l0 level2 lfo2;background:white">
<![if !supportLists]><span lang=3D"EN-US"><span style=3D"mso-list:Ignore">a=
)<span style=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span lang=3D"EN-US">Revert this patch &#822=
0;Return&nbsp;'ghost'&nbsp;state&nbsp;when&nbsp;port&nbsp;is&nbsp;in&nbsp;s=
tandby&#8221;(5da642ff71254ecda685e82c681e78cab4c75b87)<o:p></o:p></span></=
p>
<p class=3D"MsoListParagraph" align=3D"left" style=3D"mso-margin-top-alt:12=
.0pt;margin-right:12.0pt;margin-bottom:12.0pt;margin-left:42.0pt;text-align=
:left;text-indent:-21.0pt;mso-list:l0 level2 lfo2;background:white">
<![if !supportLists]><span lang=3D"EN-US"><span style=3D"mso-list:Ignore">b=
)<span style=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span lang=3D"EN-US">Then all PATH_GHOST wil=
l be treated as PATH_FAILED<o:p></o:p></span></p>
<p class=3D"MsoListParagraph" align=3D"left" style=3D"mso-margin-top-alt:12=
.0pt;margin-right:12.0pt;margin-bottom:12.0pt;margin-left:42.0pt;text-align=
:left;text-indent:-21.0pt;mso-list:l0 level2 lfo2;background:white">
<![if !supportLists]><span lang=3D"EN-US"><span style=3D"mso-list:Ignore">c=
)<span style=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span lang=3D"EN-US">and multipath will only=
 register PRKEY by PATH_UP pathes.<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">Questions:<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">so we want to consult whether there some potential iss=
ue after we revert the pat<span style=3D"color:#1F497D">c</span>h?<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">We know it will lead to some performance and reliabili=
ty loss. We mainly worry about
<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">whether there are some potential functional and fundam=
ental issues?<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">Thanks a lot.<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">Environment Info:<o:p></o:p></span></p>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif">mpathal (2e0176ad63=
09077166c9ce90033bfa248_1) dm-2 </span><span lang=3D"EN-US">TestSAN</span><=
span lang=3D"EN-US" style=3D"font-size:10.5pt;font-family:&quot;Calibri&quo=
t;,sans-serif"><o:p></o:p></span></pre>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif">size=3D20G features=
=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<o:p></o:p></span></pre>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif">`-&#43;- policy=3D'=
round-robin 0' prio=3D50 status=3Dactive<o:p></o:p></span></pre>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif">&nbsp; |- 8:0:5:1 s=
ddg 8:96&nbsp; active ready running<o:p></o:p></span></pre>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif">&nbsp; `- 9:0:6:1 s=
dwh 12:112 active ready running<o:p></o:p></span></pre>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif">`-&#43;- policy=3D'=
round-robin 0' prio=3D10 status=3Denabled<o:p></o:p></span></pre>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif">&nbsp; |- 10:0:5:1 =
sdga 21:96&nbsp; active ready running<o:p></o:p></span></pre>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif">&nbsp; `- 11:0:6:1 =
sdhb 81:112 active ready running<o:p></o:p></span></pre>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif">`-&#43;- policy=3D'=
round-robin 0' prio=3D1 status=3D enabled<o:p></o:p></span></pre>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif">&nbsp; |- 12:0:5:1 =
sdgj 15:6&nbsp; active ghost running<o:p></o:p></span></pre>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif">&nbsp; `- 13:0:6:1 =
sdhk 16:112 active ghost running<o:p></o:p></span></pre>
<pre style=3D"mso-margin-top-alt:12.0pt;margin-right:12.0pt;margin-bottom:1=
2.0pt;margin-left:0cm;background:white"><span lang=3D"EN-US" style=3D"font-=
size:10.5pt;font-family:&quot;Calibri&quot;,sans-serif"><o:p>&nbsp;</o:p></=
span></pre>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">defaults {<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_checker&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; tur<o:p></o:p></=
span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; no_path_retry&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grouping_policy=
&nbsp;&nbsp;&nbsp; group_by_prio<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prio&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; const<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; deferred_remove&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; yes<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uid_attribute&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;ID_SERIAL&quot;=
<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; reassign_maps&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; no<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback&nbsp;&nbsp;=
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;immediate<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; log_checker_err&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; once<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">}<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">devices {<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device {<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vendor&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; &quot;TestSAN&quot;<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; product&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; &quot;LU&quot;<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grouping_pol=
icy&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; group_by_prio<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; no_path_retry&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 30<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prio&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; alua<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_checker&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; tur<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_selector&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;round-robin 0&quot;<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; hardware_handler&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; &quot;0&quot;<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback&nbsp;&nb=
sp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;15<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:12.0pt;ma=
rgin-right:12.0pt;margin-bottom:12.0pt;margin-left:0cm;text-align:left;back=
ground:white">
<span lang=3D"EN-US">}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
</div>
</body>
</html>

--_000_B1BDF08B4A5F7B4A9F894A239CD487B39B47AF3Ddggeml505mbxchi_--


--===============2973150120725010709==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2973150120725010709==--
