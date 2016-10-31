From: "Andy D'Arcy Jewell" <Andy.D'ArcyJewell@csiltd.co.uk>
Subject: Multipaths getting cross-linked on IBM Power-8 after
	adding wwids
Date: Mon, 31 Oct 2016 13:40:33 +0000
Message-ID: <3B555D3246724D4EB3187D3CFCD9D0482DC98E20@NOTTSVEX01.uk.csi>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4624217358409655990=="
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
Cc: Mike Leigh <Mike.Leigh@csiltd.co.uk>
List-Id: dm-devel.ids

--===============4624217358409655990==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_3B555D3246724D4EB3187D3CFCD9D0482DC98E20NOTTSVEX01ukcsi_"

--_000_3B555D3246724D4EB3187D3CFCD9D0482DC98E20NOTTSVEX01ukcsi_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,

We have been battling with this issue with help from IBM support, but I'd l=
ike to understand the situation a bit better, so thought I'd go to the sour=
ce ;-)

We seem to have a work-around, but it seems rather woolly and sledge-hammer=
 like: re-run dracut to rebuild the initramfs copy of /etc/multipaths/bindi=
ngs and wwids files, and effectively tore down, and re-built the multipaths=
, and overlying LVM storage from scratch. It appears that the copy of bindi=
ngs in initramfs assigned a different mpath id to the affected wwids than t=
he copy in /etc/multipath. I would not have expected multipathd to be inspe=
cting the contents of initramfs (and don't think it is), but I'm also not s=
ure if this is a symptom or a cause.

The multipaths had been added several weeks earlier, and had been working p=
roperly ever since, but I don't believe there had been a re-boot since they=
 had been added, nor had the intitramfs been updated. We had a scheduled SA=
N hardware maintenance restart, and later noticed strange filesystem corrup=
tion on a guest server.

The issue is that several mpath devices ended up with overlapping block dev=
ices after an interruption to half of the paths, due to a hardware re-start=
 of one of the SAN nodes. All the block devices from mpathn ended up being =
used by another mpathm too:

Truncated output of multipath -ll:

mpathn (360050763008080eef80000000000002d) dm-13 IBM     ,2145
| |- 1:0:0:12 sdm  8:192  active undef running
| `- 3:0:0:12 sdao 66:128 active undef running
  |- 3:0:1:12 sdbc 67:96  failed undef running
  `- 1:0:1:12 sdaa 65:160 active undef running
mpathm (360050763008080eef80000000000002c) dm-12 IBM     ,2145
| |- 1:0:1:12 sdaa 65:160 active undef running
| `- 3:0:1:12 sdbc 67:96  active undef running
| |- 1:0:1:11 sdz  65:144 active undef running
| |- 3:0:1:11 sdbb 67:80  failed undef running
| |- 1:0:0:12 sdm  8:192  active undef running
| `- 3:0:0:12 sdao 66:128 active undef running
  |- 1:0:0:11 sdl  8:176  active undef running
  `- 3:0:0:11 sdan 66:112 active undef running

Note: that failed sdbb device eventually came back as active, as this was t=
aken just after the hardware was reset, but before everything had settled d=
own again. However, the overlap never resolved itself.

Environment:
uname -a
Linux p8-srvr1 3.10.82-2042.1.pkvm2_1_1.71.ppc64 #1 SMP Fri Jul 31 09:52:38=
 CDT 2015 ppc64 ppc64 ppc64 GNU/Linux

cat /etc/issue
IBM_PowerKVM release 2.1.1 build 62 service (pkvm2_1_1)
Kernel \r on a \m (\l)

rpm -qa |grep multipath
device-mapper-multipath-libs-0.4.9-51.pkvm2_1.5.ppc64
device-mapper-multipath-0.4.9-51.pkvm2_1.5.ppc64

So my questions are:
a) Is this expected behaviour or a bug?
b) If a bug, is there a fix?
c) Is there any further information you need to help diagnose?

Regards,

Andy D'Arcy Jewell
Linux/FOSS Operations
CSI LTD



******************************************************************
IMPORTANT NOTICE
'This e-mail message is intended solely for the person to whom it is addres=
sed and may contain confidential or privileged information. If you have rec=
eived it in error, please notify postmaster@csiltd.co.uk and destroy this e=
-mail and any attachments. In addition, you must not disclose, copy, distri=
bute or take any action in reliance on this e-mail or any attachments. Any =
liability (in negligence or otherwise) arising from any third party acting,=
 or refraining from acting, on any information contained in this e-mail is =
excluded. Any views or opinions presented in this e-mail are solely those o=
f the author and do not necessarily represent those of the company.=20
When addressed to our customers any quotations contained in this e-mail are=
 subject to contract and are on the terms of the company's standard Conditi=
ons, a copy of which is available on request. Any errors or omissions in an=
y quotations or other information issued by the company shall be subject to=
 correction without any liability on the part of the company. Copyright in =
documents created by or on behalf of this company remains vested in the com=
pany, and we assert our moral rights, unless the terms of our relevant clie=
nt's agreement provide otherwise.=20
Due to the nature of Internet communications CSI cannot guarantee that this=
 communication or any attachments do not contain software viruses. We have =
taken every precaution to minimise this probability but cannot accept any l=
iability for damage which you may sustain as a result of software viruses. =
We recommend you carry out your own virus checks before opening attachments=
.=20
CSI reserves the right to monitor all e-mail communications through its int=
ernal and external networks.
This communication is from Computer Systems Integration Limited=20
Registered in England and Wales
Registered number: 1748591
Registered address: Lynton House, 7-12 Tavistock Square. London WC1H 9BQ
******************************************************************

--_000_3B555D3246724D4EB3187D3CFCD9D0482DC98E20NOTTSVEX01ukcsi_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html dir=3D"ltr">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style id=3D"owaParaStyle" type=3D"text/css">P {margin-top:0;margin-bottom:=
0;}</style>
</head>
<body ocsi=3D"0" fpstyle=3D"1">
<div style=3D"direction: ltr;font-family: Helvetica;color: #000000;font-siz=
e: 10pt;">
Hi all,<br>
<br>
We have been battling with this issue with help from IBM support, but I'd l=
ike to understand the situation a bit better, so thought I'd go to the sour=
ce ;-)<br>
<br>
We seem to have a work-around, but it seems rather woolly and sledge-hammer=
 like: re-run dracut to rebuild the initramfs copy of /etc/multipaths/bindi=
ngs and wwids files, and effectively tore down, and re-built the multipaths=
, and overlying LVM storage from
 scratch. It appears that the copy of bindings in initramfs assigned a diff=
erent mpath id to the affected wwids than the copy in /etc/multipath. I wou=
ld not have expected multipathd to be inspecting the contents of initramfs =
(and don't think it is), but I'm
 also not sure if this is a symptom or a cause.<br>
<br>
The multipaths had been added several weeks earlier, and had been working p=
roperly ever since, but I don't believe there had been a re-boot since they=
 had been added, nor had the intitramfs been updated. We had a scheduled SA=
N hardware maintenance restart,
 and later noticed strange filesystem corruption on a guest server.<br>
<br>
The issue is that several mpath devices ended up with overlapping block dev=
ices after an interruption to half of the paths, due to a hardware re-start=
 of one of the SAN nodes. All the block devices from mpathn ended up being =
used by another mpathm too:<br>
<br>
<div><font color=3D"black" face=3D"Helvetica" size=3D"2"><span style=3D"fon=
t-size:10pt;" dir=3D"ltr">Truncated output of multipath -ll:<br>
<br>
mpathn (360050763008080eef80000000000002d) dm-13 IBM&nbsp;&nbsp;&nbsp;&nbsp=
; ,2145&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <=
br>
| |- 1:0:0:12 sdm&nbsp; 8:192&nbsp; active undef running<br>
| `- 3:0:0:12 sdao 66:128 active undef running<br>
&nbsp; |- 3:0:1:12 sdbc 67:96&nbsp; failed undef running<br>
&nbsp; `- 1:0:1:12 sdaa 65:160 active undef running</span></font><font colo=
r=3D"black" face=3D"Helvetica" size=3D"2"><span style=3D"font-size:10pt;" d=
ir=3D"ltr"><br>
mpathm (360050763008080eef80000000000002c) dm-12 IBM&nbsp;&nbsp;&nbsp;&nbsp=
; ,2145&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <=
br>
| |- 1:0:1:12 sdaa 65:160 active undef running<br>
| `- 3:0:1:12 sdbc 67:96&nbsp; active undef running<br>
| |- 1:0:1:11 sdz&nbsp; 65:144 active undef running<br>
| |- 3:0:1:11 sdbb 67:80&nbsp; failed undef running<br>
| |- 1:0:0:12 sdm&nbsp; 8:192&nbsp; active undef running<br>
| `- 3:0:0:12 sdao 66:128 active undef running<br>
&nbsp; |- 1:0:0:11 sdl&nbsp; 8:176&nbsp; active undef running<br>
&nbsp; `- 3:0:0:11 sdan 66:112 active undef running<br>
<br>
Note: that failed </span></font><font color=3D"black" face=3D"Helvetica" si=
ze=3D"2"><span style=3D"font-size:10pt;" dir=3D"ltr">sdbb device</span></fo=
nt> eventually came back as active, as this was taken just after the hardwa=
re was reset, but before everything had settled
 down again. However, the overlap never resolved itself.<br>
<br>
Environment:<br>
uname -a<br>
Linux p8-srvr1 3.10.82-2042.1.pkvm2_1_1.71.ppc64 #1 SMP Fri Jul 31 09:52:38=
 CDT 2015 ppc64 ppc64 ppc64 GNU/Linux<br>
<br>
cat /etc/issue<br>
IBM_PowerKVM release 2.1.1 build 62 service (pkvm2_1_1)<br>
Kernel \r on a \m (\l)<br>
<br>
rpm -qa |grep multipath<br>
device-mapper-multipath-libs-0.4.9-51.pkvm2_1.5.ppc64<br>
device-mapper-multipath-0.4.9-51.pkvm2_1.5.ppc64<br>
<br>
So my questions are:<br>
a) Is this expected behaviour or a bug?<br>
b) If a bug, is there a fix?<br>
c) Is there any further information you need to help diagnose?<br>
<br>
<div style=3D"font-family:Tahoma; font-size:13px">
<div style=3D"font-family:Tahoma; font-size:13px">
<div style=3D"margin:0"><font face=3D"Calibri,sans-serif" size=3D"2"><span =
style=3D"font-size:11pt"></span></font></div>
<div style=3D"margin:0"><font face=3D"Calibri,sans-serif" size=3D"2"><span =
style=3D"font-size:11pt">Regards,<br>
<br>
Andy D'Arcy Jewell<br>
</span></font></div>
<div style=3D"margin:0"><font face=3D"Calibri,sans-serif" size=3D"2"><span =
style=3D"font-size:11pt">Linux/FOSS Operations<br>
</span></font></div>
<div style=3D"margin:0"><font face=3D"Calibri,sans-serif" size=3D"2"><span =
style=3D"font-size:11pt">CSI LTD</span></font></div>
<div style=3D"margin:0"><font face=3D"Calibri,sans-serif" size=3D"2"><span =
style=3D"font-size:11pt"><br>
</span></font></div>
<br>
</div>
</div>
</div>
</div>
=0A<font size=3D"2" face=3D"arial,helvetica,sans-serif" color=3D"#666666">&=
nbsp;</font><p><font size=3D"2" face=3D"arial,helvetica,sans-serif" color=
=3D"#666666">**************************************************************=
****</font></p><p><font size=3D"2" face=3D"arial,helvetica,sans-serif" colo=
r=3D"#666666">IMPORTANT NOTICE<br />'This e-mail message is intended solely=
 for the person to whom it is addressed and may contain confidential or pri=
vileged information. If you have received it in error, please notify </font=
><a href=3D"mailto:postmaster@csiltd.co.uk"><font size=3D"2" face=3D"arial,=
helvetica,sans-serif" color=3D"#666666">postmaster@csiltd.co.uk</font></a><=
font size=3D"2" face=3D"arial,helvetica,sans-serif" color=3D"#666666"> and =
destroy this e-mail and any attachments. In addition, you must not disclose=
, copy, distribute or take any action in reliance on this e-mail or any att=
achments. Any liability (in negligence or otherwise) arising from any third=
 party acting, or refraining from acting, on any information contained in t=
his e-mail is excluded. Any views or opinions presented in this e-mail are =
solely those of the author and do not necessarily represent those of the co=
mpany. <br />When addressed to our customers any quotations contained in th=
is e-mail are subject to contract and are on the terms of the company's sta=
ndard Conditions, a copy of which is available on request.=A0Any errors or =
omissions in any quotations or other information issued by the company shal=
l be subject to correction without any liability on the part of the company=
. Copyright in documents created by or on behalf of this company remains ve=
sted in the company, and we assert our moral rights, unless the terms of ou=
r relevant client's agreement provide otherwise.<br />Due to the nature of =
Internet communications CSI cannot guarantee that this communication or any=
 attachments do not contain software viruses. We have taken every precautio=
n to minimise this probability but cannot accept any liability for damage w=
hich you may sustain as a result of software viruses. We recommend you carr=
y out your own virus checks before opening attachments. <br />CSI reserves =
the right to monitor all e-mail communications through its internal and ext=
ernal networks.<br />This communication is from Computer Systems Integratio=
n Limited <br />Registered in England and Wales<br />Registered number: 174=
8591<br />Registered address: Lynton House, 7-12 Tavistock Square. London W=
C1H 9BQ<br />**************************************************************=
***</font></p><font size=3D"2" face=3D"arial,helvetica,sans-serif" color=3D=
"#666666">&nbsp;</font>=0A=0A</body>
</html>

--_000_3B555D3246724D4EB3187D3CFCD9D0482DC98E20NOTTSVEX01ukcsi_--


--===============4624217358409655990==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4624217358409655990==--
