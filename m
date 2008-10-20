From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: multipath rdac - recover from both paths lost
Date: Mon, 20 Oct 2008 08:23:14 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45BC83276@cosmail01.lsi.com>
References: <bd4583d00810200329x652c28b8xbfa1aa23c22912e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0596881157=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bd4583d00810200329x652c28b8xbfa1aa23c22912e@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0596881157==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_E463DF2B2E584B4A82673F53D62C2EF45BC83276cosmail01lsicom_"

--_000_E463DF2B2E584B4A82673F53D62C2EF45BC83276cosmail01lsicom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

You can try stopping (/etc/init.d/multipathd stop) and re-starting ((/etc/i=
nit.d/multipathd start) the multipathd daemon again.

Thanks
Babu Moger
________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Greg Cockburn
Sent: Monday, October 20, 2008 5:29 AM
To: dm-devel@redhat.com
Subject: [dm-devel] multipath rdac - recover from both paths lost

Hi,

I am trying to get back from a strage situation.

I have had both paths in a RDAC setup fail and then come back.

I want to know if there is a way to recover from this without a reboot.

(OS =3D CentOS 5.1)

multipath -ll
mpath2 (3600a0b800035ebc8000001a94652ae50) dm-4 IBM,1726-4xx  FAStT
[size=3D1.4T][features=3D0][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 2:0:0:1 sde 8:80  [failed][ghost]
\_ round-robin 0 [prio=3D100][active]
 \_ 1:0:0:1 sdf 8:96  [failed][ready]

dmsetup info mpath2
Name:              mpath2
State:             ACTIVE
Tables present:    LIVE
Open count:        20
Event number:      3
Major, minor:      253, 4
Number of targets: 1
UUID: mpath-3600a0b800035ebc8000001a94652ae50

vgscan
  Reading all physical volumes.  This may take a while...
  /dev/mapper/mpath2: read failed after 0 of 4096 at 1497314033664: Input/o=
utput error
  /dev/mapper/mpath2: read failed after 0 of 4096 at 0: Input/output error

dmsetup remove --force mpath2



device-mapper: remove ioctl failed: Device or resource busy
Command failed

multipath -f mpath2 (just exits with return code 1)


dmesg

    <<vendor>> ASC=3D0xe0 ASCQ=3D0x6ASC=3D0xe0 ASCQ=3D0x6

sde: Current: sense key: Recovered Error
    <<vendor>> ASC=3D0xe0 ASCQ=3D0x6ASC=3D0xe0 ASCQ=3D0x6

sdf: Current: sense key: Recovered Error
    <<vendor>> ASC=3D0xe0 ASCQ=3D0x6ASC=3D0xe0 ASCQ=3D0x6

end_request: I/O error, dev sdf, sector 61118720
device-mapper: multipath: Failing path 8:80.
end_request: I/O error, dev sdf, sector 599510512

device-mapper: ioctl: unable to remove open device mpath2
device-mapper: ioctl: unable to remove open device mpath2

Any advice would be greatly appreciated.

Thanks,
Greg.

--_000_E463DF2B2E584B4A82673F53D62C2EF45BC83276cosmail01lsicom_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=3Dus-ascii"=
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
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
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

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>You can try stopping (/etc/init.d/mult=
ipathd
stop) and re-starting ((/etc/init.d/multipathd start) the multipathd daemon
again. &nbsp;<o:p></o:p></span></font></p>

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
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] <b><span
style=3D'font-weight:bold'>On Behalf Of </span></b>Greg Cockburn<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Monday, October 20, 20=
08
5:29 AM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> dm-devel@redhat.com<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> [dm-devel] multipat=
h rdac
- recover from both paths lost</span></font><o:p></o:p></p>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Hi,<br>
<br>
I am trying to get back from a strage situation.<br>
<br>
I have had both paths in a RDAC setup fail and then come back.<br>
<br>
I want to know if there is a way to recover from this without a reboot.<br>
<br>
(OS =3D CentOS 5.1)<br>
<br>
multipath -ll<br>
mpath2 (3600a0b800035ebc8000001a94652ae50) dm-4 IBM,1726-4xx&nbsp; FAStT<br=
>
[size=3D1.4T][features=3D0][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D0][enabled]<br>
&nbsp;\_ 2:0:0:1 sde 8:80&nbsp; [failed][ghost]<br>
\_ round-robin 0 [prio=3D100][active]<br>
&nbsp;\_ 1:0:0:1 sdf 8:96&nbsp; [failed][ready]<br>
<br>
dmsetup info mpath2<br>
Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;
mpath2<br>
State:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;
ACTIVE<br>
Tables present:&nbsp;&nbsp;&nbsp; LIVE<br>
Open count:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20<br>
Event number:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3<br>
Major, minor:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 253, 4<br>
Number of targets: 1<br>
UUID: mpath-3600a0b800035ebc8000001a94652ae50<br>
<br>
vgscan<br>
&nbsp; Reading all physical volumes.&nbsp; This may take a while...<br>
&nbsp; /dev/mapper/mpath2: read failed after 0 of 4096 at 1497314033664:
Input/output error<br>
&nbsp; /dev/mapper/mpath2: read failed after 0 of 4096 at 0: Input/output e=
rror<br>
<br>
dmsetup remove --force mpath2<br>
<br>
<br>
<br>
device-mapper: remove ioctl failed: Device or resource busy<br>
Command failed<br>
<br>
multipath -f mpath2 (just exits with return code 1)<br>
<br>
<br>
dmesg<br>
<br>
&nbsp;&nbsp;&nbsp; &lt;&lt;vendor&gt;&gt; ASC=3D0xe0 ASCQ=3D0x6ASC=3D0xe0 A=
SCQ=3D0x6<br>
<br>
sde: Current: sense key: Recovered Error<br>
&nbsp;&nbsp;&nbsp; &lt;&lt;vendor&gt;&gt; ASC=3D0xe0 ASCQ=3D0x6ASC=3D0xe0 A=
SCQ=3D0x6<br>
<br>
sdf: Current: sense key: Recovered Error<br>
&nbsp;&nbsp;&nbsp; &lt;&lt;vendor&gt;&gt; ASC=3D0xe0 ASCQ=3D0x6ASC=3D0xe0 A=
SCQ=3D0x6<br>
<br>
end_request: I/O error, dev sdf, sector 61118720<br>
device-mapper: multipath: Failing path 8:80.<br>
end_request: I/O error, dev sdf, sector 599510512<br>
<br>
device-mapper: ioctl: unable to remove open device mpath2<br>
device-mapper: ioctl: unable to remove open device mpath2<br>
<br>
Any advice would be greatly appreciated.<br>
<br>
Thanks,<br>
Greg.<o:p></o:p></span></font></p>

</div>

</div>

</body>

</html>

--_000_E463DF2B2E584B4A82673F53D62C2EF45BC83276cosmail01lsicom_--


--===============0596881157==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0596881157==--
