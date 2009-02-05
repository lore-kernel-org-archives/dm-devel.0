From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: FW: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 13:48:37 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF46653B597@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4663976BB@cosmail01.lsi.com>
	<1a4a774c0902051223g3a70ee45k946b9338d5d3c2df@mail.gmail.com>
	<E463DF2B2E584B4A82673F53D62C2EF46653B584@cosmail01.lsi.com>
	<1a4a774c0902051245k68db6848w8e4ede611fc1f05e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1241386205=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1a4a774c0902051245k68db6848w8e4ede611fc1f05e@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?iso-8859-1?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1241386205==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_E463DF2B2E584B4A82673F53D62C2EF46653B597cosmail01lsicom_"

--_000_E463DF2B2E584B4A82673F53D62C2EF46653B597cosmail01lsicom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

This is looks good to me.  Now your are ready to run your tests..

Thanks
Babu Moger
________________________________
From: Christian R=F8snes [mailto:christian.rosnes@gmail.com]
Sent: Thursday, February 05, 2009 2:45 PM
To: Moger, Babu
Cc: dm-devel@redhat.com
Subject: Re: FW: [dm-devel] Multipath setup and rdac questions


On Thu, Feb 5, 2009 at 9:32 PM, Moger, Babu <Babu.Moger@lsi.com<mailto:Babu=
.Moger@lsi.com>> wrote:

Your Vendor id is DELL   and Product id is MD3000i



Now update the multipath.conf with the above information and reboot the sys=
tem.



vendor                  "DELL"

      product                 "MD3000i"



You should see the devices.  Let me know if you need more information..
Ok. Changed multipath.conf and now multipath -ll shows:

# multipath -ll
mpathe (36002219000918b4c00005b6c497e6632) dm-4 DELL,MD3000i
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D12][active]
 \_ 4:0:0:1  sdm  8:192  [active][ready]
 \_ 3:0:0:1  sdl  8:176  [active][ready]
\_ round-robin 0 [prio=3D2][enabled]
 \_ 2:0:0:1  sds  65:32  [active][ghost]
 \_ 1:0:0:1  sdr  65:16  [active][ghost]
mpathd (36002219000918b3300002e6e497e6315) dm-6 DELL,MD3000i
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D6][active]
 \_ 4:0:0:2  sdo  8:224  [active][ready]
 \_ 3:0:0:2  sdn  8:208  [active][ready]
mpathc (36002219000918b4c00005b6f497e6695) dm-1 DELL,MD3000i
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D6][active]
 \_ 3:0:0:3  sdz  65:144 [active][ready]
mpatha (36002219000918b4c00005b72497e66f3) dm-0 DELL,MD3000i
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D3][active]
 \_ 2:0:0:5  sdba 67:64  [active][ready]
mpathl (36002219000918b3300002e6b497e62a6) dm-8 DELL,MD3000i
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D12][active]
 \_ 4:0:0:0  sde  8:64   [active][ready]
 \_ 3:0:0:0  sdd  8:48   [active][ready]
\_ round-robin 0 [prio=3D2][enabled]
 \_ 2:0:0:0  sdc  8:32   [active][ghost]
 \_ 1:0:0:0  sdb  8:16   [active][ghost]
mpathk (36002219000922cdf000004a4497e53f5) dm-7 DELL,MD3000i
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D12][active]
 \_ 6:0:0:10 sdi  8:128  [active][ready]
 \_ 5:0:0:10 sdh  8:112  [active][ready]
\_ round-robin 0 [prio=3D2][enabled]
 \_ 8:0:0:10 sdg  8:96   [active][ghost]
 \_ 7:0:0:10 sdf  8:80   [active][ghost]
mpathj (36002219000918b2e000004b2497e581c) dm-5 DELL,MD3000i
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D12][active]
 \_ 8:0:0:11 sdq  65:0   [active][ready]
 \_ 7:0:0:11 sdp  8:240  [active][ready]
\_ round-robin 0 [prio=3D2][enabled]
 \_ 6:0:0:11 sdk  8:160  [active][ghost]
 \_ 5:0:0:11 sdj  8:144  [active][ghost]
mpathi (36002219000922cdf000004a7497e54dd) dm-3 DELL,MD3000i
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D12][active]
 \_ 6:0:0:12 sdw  65:96  [active][ready]
 \_ 5:0:0:12 sdv  65:80  [active][ready]
\_ round-robin 0 [prio=3D2][enabled]
 \_ 8:0:0:12 sdu  65:64  [active][ghost]
 \_ 7:0:0:12 sdt  65:48  [active][ghost]
mpathh (36002219000918b2e000004b5497e587e) dm-2 DELL,MD3000i
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D6][active]
 \_ 6:0:0:13 sdy  65:128 [active][ready]
 \_ 5:0:0:13 sdx  65:112 [active][ready]

Thank you
Christian

--_000_E463DF2B2E584B4A82673F53D62C2EF46653B597cosmail01lsicom_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Diso-8859-1"=
>
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
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
	{color:blue;
	text-decoration:underline;}
p
	{mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman";}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dblue>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>This is looks good to me.=A0 Now your =
are
ready to run your tests.. =A0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Thanks</span></font><font color=3Dnavy=
><span
style=3D'color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Babu Moger </span></font><o:p></o:p></=
p>

</div>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font siz=
e=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'>

<hr size=3D2 width=3D"100%" align=3Dcenter tabindex=3D-1>

</span></font></div>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span style=3D'font-si=
ze:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'> Christia=
n R=F8snes
[mailto:christian.rosnes@gmail.com] <br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Thursday, February 05,=
 2009
2:45 PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> Moger, Babu<br>
<b><span style=3D'font-weight:bold'>Cc:</span></b> dm-devel@redhat.com<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> Re: FW: [dm-devel]
Multipath setup and rdac questions</span></font><o:p></o:p></p>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-bottom:12.0pt'><font size=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'><o:p>&nbsp;</o:p>=
</span></font></p>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>On Thu, Feb 5, 2009 at 9:32 PM, Moger, Babu &lt;<a
href=3D"mailto:Babu.Moger@lsi.com">Babu.Moger@lsi.com</a>&gt; wrote:<o:p></=
o:p></span></font></p>

<div link=3Dblue vlink=3Dblue>

<div>

<p><font size=3D3 face=3D"Times New Roman"><span style=3D'font-size:12.0pt'=
>Your
Vendor id is DELL&nbsp;&nbsp;&nbsp;and Product id is
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<o:p></o:p></s=
pan></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span style=3D'font-size:12.0pt'=
>&nbsp;<o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span style=3D'font-size:12.0pt'=
>Now
update the multipath.conf with the above information and reboot the system.=
<o:p></o:p></span></font></p>

<p><font size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt;font=
-family:
"Courier New"'>&nbsp;</span></font><o:p></o:p></p>

<p style=3D'text-indent:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>vendor&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;
&quot;DELL&quot;</span></font><o:p></o:p></p>

<p><font size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt;font=
-family:
"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;MD3000i&quot;</span></font><o:p></o:p></p>

<p><font size=3D2 color=3Dnavy face=3DArial><span style=3D'font-size:10.0pt=
;font-family:
Arial;color:navy'>&nbsp;</span></font><o:p></o:p></p>

<p><font size=3D2 color=3Dnavy face=3DArial><span style=3D'font-size:10.0pt=
;font-family:
Arial;color:navy'>You should see the devices. &nbsp;Let me know if you need
more information..</span></font><o:p></o:p></p>

</div>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Ok. Changed multipath.conf and now multipath -ll shows:<br>
<br>
# multipath -ll<br>
mpathe (36002219000918b4c00005b6c497e6632) dm-4 DELL,MD3000i<br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D12][active]<br>
&nbsp;\_ 4:0:0:1&nbsp; sdm&nbsp; 8:192&nbsp; [active][ready]<br>
&nbsp;\_ 3:0:0:1&nbsp; sdl&nbsp; 8:176&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=3D2][enabled]<br>
&nbsp;\_ 2:0:0:1&nbsp; sds&nbsp; 65:32&nbsp; [active][ghost]<br>
&nbsp;\_ 1:0:0:1&nbsp; sdr&nbsp; 65:16&nbsp; [active][ghost]<br>
mpathd (36002219000918b3300002e6e497e6315) dm-6 DELL,MD3000i<br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D6][active]<br>
&nbsp;\_ 4:0:0:2&nbsp; sdo&nbsp; 8:224&nbsp; [active][ready]<br>
&nbsp;\_ 3:0:0:2&nbsp; sdn&nbsp; 8:208&nbsp; [active][ready]<br>
mpathc (36002219000918b4c00005b6f497e6695) dm-1 DELL,MD3000i<br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D6][active]<br>
&nbsp;\_ 3:0:0:3&nbsp; sdz&nbsp; 65:144 [active][ready]<br>
mpatha (36002219000918b4c00005b72497e66f3) dm-0 DELL,MD3000i<br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D3][active]<br>
&nbsp;\_ 2:0:0:5&nbsp; sdba 67:64&nbsp; [active][ready]<br>
mpathl (36002219000918b3300002e6b497e62a6) dm-8 DELL,MD3000i<br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D12][active]<br>
&nbsp;\_ 4:0:0:0&nbsp; sde&nbsp; 8:64&nbsp;&nbsp; [active][ready]<br>
&nbsp;\_ 3:0:0:0&nbsp; sdd&nbsp; 8:48&nbsp;&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=3D2][enabled]<br>
&nbsp;\_ 2:0:0:0&nbsp; sdc&nbsp; 8:32&nbsp;&nbsp; [active][ghost]<br>
&nbsp;\_ 1:0:0:0&nbsp; sdb&nbsp; 8:16&nbsp;&nbsp; [active][ghost]<br>
mpathk (36002219000922cdf000004a4497e53f5) dm-7 DELL,MD3000i<br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D12][active]<br>
&nbsp;\_ 6:0:0:10 sdi&nbsp; 8:128&nbsp; [active][ready]<br>
&nbsp;\_ 5:0:0:10 sdh&nbsp; 8:112&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=3D2][enabled]<br>
&nbsp;\_ 8:0:0:10 sdg&nbsp; 8:96&nbsp;&nbsp; [active][ghost]<br>
&nbsp;\_ 7:0:0:10 sdf&nbsp; 8:80&nbsp;&nbsp; [active][ghost]<br>
mpathj (36002219000918b2e000004b2497e581c) dm-5 DELL,MD3000i<br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D12][active]<br>
&nbsp;\_ 8:0:0:11 sdq&nbsp; 65:0&nbsp;&nbsp; [active][ready]<br>
&nbsp;\_ 7:0:0:11 sdp&nbsp; 8:240&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=3D2][enabled]<br>
&nbsp;\_ 6:0:0:11 sdk&nbsp; 8:160&nbsp; [active][ghost]<br>
&nbsp;\_ 5:0:0:11 sdj&nbsp; 8:144&nbsp; [active][ghost]<br>
mpathi (36002219000922cdf000004a7497e54dd) dm-3 DELL,MD3000i<br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D12][active]<br>
&nbsp;\_ 6:0:0:12 sdw&nbsp; 65:96&nbsp; [active][ready]<br>
&nbsp;\_ 5:0:0:12 sdv&nbsp; 65:80&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=3D2][enabled]<br>
&nbsp;\_ 8:0:0:12 sdu&nbsp; 65:64&nbsp; [active][ghost]<br>
&nbsp;\_ 7:0:0:12 sdt&nbsp; 65:48&nbsp; [active][ghost]<br>
mpathh (36002219000918b2e000004b5497e587e) dm-2 DELL,MD3000i<br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D6][active]<br>
&nbsp;\_ 6:0:0:13 sdy&nbsp; 65:128 [active][ready]<br>
&nbsp;\_ 5:0:0:13 sdx&nbsp; 65:112 [active][ready]<br>
&nbsp;<o:p></o:p></span></font></p>

</div>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Thank you<br>
Christian<o:p></o:p></span></font></p>

</div>

</body>

</html>

--_000_E463DF2B2E584B4A82673F53D62C2EF46653B597cosmail01lsicom_--


--===============1241386205==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1241386205==--
