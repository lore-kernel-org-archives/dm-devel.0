From: <phillip.carswell@barclays.com>
Subject: Device mapper single device display
Date: Fri, 31 Mar 2017 11:01:29 +0000
Message-ID: <bcdfb87504ad4670a0a3fcafa4094b74@MUKPBCC4XSN0005.collab.barclayscorp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3984147587938873742=="
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
Cc: thomas.lievesley@barclays.com
List-Id: dm-devel.ids

--===============3984147587938873742==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_bcdfb87504ad4670a0a3fcafa4094b74MUKPBCC4XSN0005collabba_"

--_000_bcdfb87504ad4670a0a3fcafa4094b74MUKPBCC4XSN0005collabba_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I'm trying to use dmsetup to query specific devices rather than using `dm=
setup ls --tree` and having to use some bash or scripting to pull out the=
=20specific device. Example below ;

# dmsetup ls --tree
root_vg-mqm_lv (253:7)
`-mpath4 (253:4)
=20   |- (65:48)
=20   |- (8:192)
=20   |- (8:80)
=20   `- (65:160)
root_vg-kdump (253:2)
`- (104:2)
root_vg-mqmerr_lv (253:8)
`-mpath4 (253:4)
=20   |- (65:48)
=20   |- (8:192)
=20   |- (8:80)
=20   `- (65:160)
root_vg-apps (253:5)
|-mpath4 (253:4)
|  |- (65:48)
|  |- (8:192)
|  |- (8:80)
|  `- (65:160)
`- (104:2)
root_vg-var (253:1)
`- (104:2)
root_vg-inf (253:3)
`- (104:2)
root_vg-tws (253:10)
`-mpath4 (253:4)
=20   |- (65:48)
=20   |- (8:192)
=20   |- (8:80)
=20   `- (65:160)
root_vg-swap (253:6)
|-mpath4 (253:4)
|  |- (65:48)
|  |- (8:192)
|  |- (8:80)
|  `- (65:160)
`- (104:2)
root_vg-root (253:0)
`- (104:2)
root_vg-cdunix (253:9)
`-mpath4 (253:4)
=20   |- (65:48)
=20   |- (8:192)
=20   |- (8:80)
=20   `- (65:160)


If I only wanted to look at root_vg-mqm_lv I want to just see
root_vg-mqm_lv (253:7)
`-mpath4 (253:4)
=20   |- (65:48)
=20   |- (8:192)
=20   |- (8:80)
=20   `- (65:160)

I can't seem to find this flag within the command, does this exist ? Or c=
an it be added into future releases? This would make scripting around the=
=20command a lot easier and would also make diagnosing where we have devi=
ces that are not utilising multipath, as below ;

root_vg-mqm_lv (253:6)
`- (8:192)



Phil Carswell | UNIX L3 | IaaS | Infrastructure Services
Tel 00 44 (0)3301 535 884 | Mobile 00 44 (0)7775 544 375 | Email phillip.=
carswell@barclays.com
Barclays, 2nd floor (G7), Block 10, BTCR, Knutsford, Cheshire, England, W=
A16 9EU
barclays.com<http://www.barclays.com/>

Unix Sharepoint
http://teams.barclays.intranet/sites/unix/SitePages/Home.aspx


Respect  |  Integrity  |  Service  |  Excellence  |  Stewardship
Helping people achieve their ambitions - in the right way

P Please consider the environment before printing this email

Advanced Leave notification : tbc




This e-mail and any attachments are confidential and intended solely for =
the addressee and may also be privileged or exempt from disclosure under =
applicable law. If you are not the addressee, or have received this e-mai=
l in error, please notify the sender immediately, delete it from your sys=
tem and do not copy, disclose or otherwise act upon any part of this e-ma=
il or its attachments.

Internet communications are not guaranteed to be secure or virus-free. Th=
e Barclays Group does not accept responsibility for any loss arising from=
=20unauthorised access to, or interference with, any Internet communicati=
ons by any third party, or from the transmission of any viruses. Replies =
to this e-mail may be monitored by the Barclays Group for operational or =
business reasons.

Any opinion or other information in this e-mail or its attachments that d=
oes not relate to the business of the Barclays Group is personal to the s=
ender and is not given or endorsed by the Barclays Group.

Barclays Bank PLC. Registered in England and Wales (registered no. 102616=
7). Registered Office: 1 Churchill Place, London, E14 5HP, United Kingdom=
.=20

Barclays Bank PLC is authorised by the Prudential Regulation Authority an=
d regulated by the Financial Conduct Authority and the Prudential Regulat=
ion Authority (Financial Services Register No. 122702).

--_000_bcdfb87504ad4670a0a3fcafa4094b74MUKPBCC4XSN0005collabba_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-mi=
crosoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:wo=
rd" xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D=
"http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-asci=
i">
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">=

<style><!--
/* Font Definitions */
@font-face
=09{font-family:"Cambria Math";
=09panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
=09{font-family:Webdings;
=09panose-1:5 3 1 2 1 5 9 6 7 3;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0cm;
=09margin-bottom:.0001pt;
=09font-size:11.0pt;
=09font-family:"Calibri",sans-serif;
=09mso-fareast-language:EN-US;}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:#0563C1;
=09text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
=09{mso-style-priority:99;
=09color:#954F72;
=09text-decoration:underline;}
span.EmailStyle17
=09{mso-style-type:personal-compose;
=09font-family:"Calibri",sans-serif;
=09color:windowtext;}
.MsoChpDefault
=09{mso-style-type:export-only;
=09font-family:"Calibri",sans-serif;
=09mso-fareast-language:EN-US;}
@page WordSection1
=09{size:612.0pt 792.0pt;
=09margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
=09{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-GB" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I&#8217;m trying to use dmsetup to query specific =
devices rather than using `dmsetup ls --tree` and having to use some bash=
=20or scripting to pull out the specific device. Example below ;<o:p></o:=
p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;"># dmsetup ls --tree<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-mqm_lv (253:7)<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`-mpath4 (253:4)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (65:48)<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (8:192)<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (8:80)<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; `- (65:160)<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-kdump (253:2)<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`- (104:2)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-mqmerr_lv (253:8)<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`-mpath4 (253:4)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (65:48)<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (8:192)<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (8:80)<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; `- (65:160)<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-apps (253:5)<o:p></o:p></span></p>=

<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">|-mpath4 (253:4)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">|&nbsp; |- (65:48)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">|&nbsp; |- (8:192)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">|&nbsp; |- (8:80)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">|&nbsp; `- (65:160)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`- (104:2)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-var (253:1)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`- (104:2)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-inf (253:3)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`- (104:2)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-tws (253:10)<o:p></o:p></span></p>=

<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`-mpath4 (253:4)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (65:48)<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (8:192)<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (8:80)<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; `- (65:160)<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-swap (253:6)<o:p></o:p></span></p>=

<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">|-mpath4 (253:4)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">|&nbsp; |- (65:48)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">|&nbsp; |- (8:192)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">|&nbsp; |- (8:80)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">|&nbsp; `- (65:160)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`- (104:2)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-root (253:0)<o:p></o:p></span></p>=

<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`- (104:2)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-cdunix (253:9)<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`-mpath4 (253:4)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (65:48)<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (8:192)<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (8:80)<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; `- (65:160)<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">If I only wanted to look at root_vg-mqm_lv I want =
to just see
<o:p></o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-mqm_lv (253:7)<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`-mpath4 (253:4)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (65:48)<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (8:192)<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; |- (8:80)<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">&nbsp;&nbsp;&nbsp; `- (65:160)<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I can&#8217;t seem to find this flag within the co=
mmand, does this exist ? Or can it be added into future releases? This wo=
uld make scripting around the command a lot easier and would also make di=
agnosing where we have devices that are not utilising
=20multipath, as below ;<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">root_vg-mqm_lv (253:6)<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.0pt;font-family:&quot;=
Courier New&quot;;color:black">`- (8:192)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:5.0pt;margin-right:0cm=
;margin-bottom:5.0pt;margin-left:0cm;text-autospace:none">
<span style=3D"font-size:8.0pt;color:#A6A6A6;mso-fareast-language:EN-GB">=
Phil Carswell | UNIX L3 |
</span><span style=3D"font-size:8.0pt;color:gray;mso-fareast-language:EN-=
GB">IaaS |
</span><span style=3D"font-size:8.0pt;color:gray;mso-fareast-language:JA"=
>Infrastructure Services</span><span style=3D"font-size:8.0pt;color:#A6A6=
A6;mso-fareast-language:EN-GB"><br>
Tel 00 44 (0)3301 535 884 | Mobile 00 44 (0)7775 544 375 | Email <u>phill=
ip.carswell@barclays.com</u><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-=
size:8.0pt;color:#A6A6A6;mso-fareast-language:EN-GB">Barclays, 2nd floor =
(G7), Block 10, BTCR, Knutsford, Cheshire, England, WA16 9EU</span><span =
style=3D"font-size:8.0pt;mso-fareast-language:EN-GB"><br>
<span style=3D"color:#8496B0"><a href=3D"http://www.barclays.com/"><span =
style=3D"color:#8496B0">barclays.com</span></a></span><o:p></o:p></span><=
/p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-=
size:8.0pt;mso-fareast-language:EN-GB"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt;color:#ACB9CA;mso-f=
areast-language:EN-GB">Unix Sharepoint<br>
</span><span style=3D"font-size:8.0pt;mso-fareast-language:EN-GB"><a href=
=3D"http://teams.barclays.intranet/sites/unix/SitePages/Home.aspx"><span =
style=3D"color:blue">http://teams.barclays.intranet/sites/unix/SitePages/=
Home.aspx</span></a><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-=
size:8.0pt;color:#8496B0;mso-fareast-language:EN-GB"><o:p>&nbsp;</o:p></s=
pan></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-=
size:8.0pt;color:#8496B0;mso-fareast-language:EN-GB"><o:p>&nbsp;</o:p></s=
pan></p>
<p class=3D"MsoNormal" style=3D"vertical-align:baseline"><span style=3D"f=
ont-size:8.0pt;color:#007EB6;mso-fareast-language:EN-GB">Respect&nbsp; |&=
nbsp; Integrity&nbsp; |&nbsp;&nbsp;Service&nbsp; |&nbsp;&nbsp;Excellence&=
nbsp; |&nbsp; Stewardship</span><span style=3D"font-size:8.0pt;color:#00A=
EEF;mso-fareast-language:EN-GB"><br>
</span><span style=3D"font-size:8.0pt;color:gray;mso-fareast-language:EN-=
GB">Helping people achieve their ambitions &#8211; in the right way&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;</span><span style=3D"fo=
nt-size:8.0pt;mso-fareast-language:EN-GB"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-=
size:8.0pt;font-family:&quot;Arial&quot;,sans-serif;color:gray;mso-fareas=
t-language:EN-GB"><br>
</span><span style=3D"font-size:8.0pt;font-family:Webdings;color:#00B050;=
mso-fareast-language:EN-GB">P</span><span style=3D"font-size:8.0pt;font-f=
amily:&quot;Arial&quot;,sans-serif;color:#00B050;mso-fareast-language:EN-=
GB"> Please consider the environment before printing
=20this email</span><span style=3D"font-size:8.0pt;font-family:&quot;Aria=
l&quot;,sans-serif;color:#ACB9CA;mso-fareast-language:EN-GB"><o:p></o:p><=
/span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-=
size:8.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-fareast-language:=
EN-GB"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-=
size:8.0pt;font-family:&quot;Arial&quot;,sans-serif;color:red;mso-fareast=
-language:EN-GB">Advanced Leave notification : tbc<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-=
size:8.0pt;font-family:&quot;Arial&quot;,sans-serif;color:red;mso-fareast=
-language:EN-GB">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-=
size:8.0pt;font-family:&quot;Arial&quot;,sans-serif;color:red;mso-fareast=
-language:EN-GB"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>

<P>This e-mail and any attachments are confidential and intended solely f=
or the=20
addressee and may also be privileged or exempt from disclosure under appl=
icable=20
law. If you are not the addressee, or have received this e-mail in error,=
=20please=20
notify the sender immediately, delete it from your system and do not copy=
,=20
disclose or otherwise act upon any part of this e-mail or its attachments=
.</P>
<P>Internet communications are not guaranteed to be secure or virus-free.=
=20The=20
Barclays Group does not accept responsibility for any loss arising from=20
unauthorised access to, or interference with, any Internet communications=
=20by any=20
third party, or from the transmission of any viruses. Replies to this e-m=
ail may=20
be monitored by the Barclays Group for operational or business reasons.</=
P>
<P>Any opinion or other information in this e-mail or its attachments tha=
t does=20
not relate to the business of the Barclays Group is personal to the sende=
r and=20
is not given or endorsed by the Barclays Group.</P>
<P>Barclays Bank PLC. Registered in England and Wales (registered no. 102=
6167).=20
Registered Office: 1 Churchill Place, London, E14 5HP, United Kingdom. Ba=
rclays=20
Bank PLC is authorised by the Prudential Regulation Authority and regulat=
ed by=20
the Financial Conduct Authority and the Prudential Regulation Authority=20
(Financial Services Register No. 122702).&nbsp; </P>
</body>
</html>

--_000_bcdfb87504ad4670a0a3fcafa4094b74MUKPBCC4XSN0005collabba_--


--===============3984147587938873742==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3984147587938873742==--
