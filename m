From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
Subject: Fibre Channel Transport Services on Linux
Date: Thu, 6 Jun 2019 16:23:48 +0530
Message-ID: <df68aab687f8520a3404b2976074e1f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1231869251720431936=="
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Anand Nataraja Sundaram <anand.sundaram@broadcom.com>, Ganesh Murugesan <ganesh.murugesan@broadcom.com>, Ganesh Manjunath Pai <ganesh.pai@broadcom.com>, Howard Johnson <howard.johnson@broadcom.com>
List-Id: dm-devel.ids

--===============1231869251720431936==
Content-Type: multipart/alternative; boundary="00000000000073aa45058aa5870f"

--00000000000073aa45058aa5870f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Introduction:

The Fibre Channel Transport Service provides FC network intelligence in hos=
t

applications and also provide the host intelligence in FC network. This
service

can act as a bridge or transport mechanism between applications running on
host

and the FC network connected to the host.



Presently, the service automates the marginal path failover by utilizing th=
e

FC network intelligence. The service uses Fabric Performance Impact
Notification

(FPIN) frames, as defined in the FC standards by T11 Committee, to perform =
a

deterministic path failover.



How it works:

When the FC network detects a shaky or marginal link in the Fabric, it find=
s

the impacted devices, gets the device's unique World-Wide-Name (WWNs) and

populates the FPIN Link Integrity frame with the WWNs of these impacted
devices.

This frame is then sent to the FC host, through the Host Bus Adapters
(HBAs).



The FC transport service interprets the data received through HBA, and fail=
s

the corresponding marginal paths using the device mapper and multipath

libraries.



Below are the ways where the marginal path can be moved to active.

1.port toggling after resolving the link issues in fabric

2.Host intervention using multipathd utilities.



The code is available in the below GIT repository.



https://github.com/brocade/bsn-linux-open-os-contributions





Please refer to the README for more details regarding compilation, service

functionality and usage.



https://github.com/brocade/bsn-linux-open-os-contributions/tree/master/mpio=
/Fabric_Assist/FC_Transport_Daemon





Contributors:

Benjamin:bmarzins@redhat.com,

Muneendra:(muneendra.kumar@broadcom.com)

Ganesh:(ganesh.pai@broadcom.com)



Future Work:

Instead of moving the path to fail state we are planning to move the path
to special priority group

as defined by dm-multipath(which is to be implemented)



History:



The kernel related changes to send the ELS notifications to the user space
is already available in the upstream.

Below are the links related to the same.



Linux:

All the HBA and scsi transport related changes are available in linux
upstream



https://github.com/torvalds/linux/



CommitId:

1a61e5486aeb90d94dd6116c9749e36edd10bf9b =C3=A8
https://github.com/torvalds/linux/commit/1a61e5486aeb90d94dd6116c9749e36edd=
10bf9b



c39e0af64bce3bba61c3986d6083df7b8f29a310 =C3=A8
https://github.com/torvalds/linux/commit/c39e0af64bce3bba61c3986d6083df7b8f=
29a310



2b1be55819dc7ae35576b3ba621c7fed0c323e04 =C3=A8
https://github.com/torvalds/linux/commit/2b1be55819dc7ae35576b3ba621c7fed0c=
323e04



a7dff3ad4787381a3aa831d558fb720b8f354435 =C3=A8
https://github.com/torvalds/linux/commit/a7dff3ad4787381a3aa831d558fb720b8f=
354435



Regards,

Muneendra.

--00000000000073aa45058aa5870f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; charset=
=3Dus-ascii"><meta name=3D"Generator" content=3D"Microsoft Word 15 (filtere=
d medium)"><style><!--
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
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style></head><body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72"><=
div class=3D"WordSection1"><p class=3D"MsoNormal">Introduction:</p><p class=
=3D"MsoNormal">The Fibre Channel Transport Service provides FC network inte=
lligence in host</p><p class=3D"MsoNormal">applications and also provide th=
e host intelligence in FC network. This service</p><p class=3D"MsoNormal">c=
an act as a bridge or transport mechanism between applications running on h=
ost</p><p class=3D"MsoNormal">and the FC network connected to the host.</p>=
<p class=3D"MsoNormal">=C2=A0</p><p class=3D"MsoNormal">Presently, the serv=
ice automates the marginal path failover by utilizing the</p><p class=3D"Ms=
oNormal">FC network intelligence. The service uses Fabric Performance Impac=
t Notification</p><p class=3D"MsoNormal">(FPIN) frames, as defined in the F=
C standards by T11 Committee, to perform a</p><p class=3D"MsoNormal">determ=
inistic path failover.</p><p class=3D"MsoNormal">=C2=A0</p><p class=3D"MsoN=
ormal">How it works:</p><p class=3D"MsoNormal">When the FC network detects =
a shaky or marginal link in the Fabric, it finds</p><p class=3D"MsoNormal">=
the impacted devices, gets the device&#39;s unique World-Wide-Name (WWNs) a=
nd</p><p class=3D"MsoNormal">populates the FPIN Link Integrity frame with t=
he WWNs of these impacted devices.</p><p class=3D"MsoNormal">This frame is =
then sent to the FC host, through the Host Bus Adapters (HBAs).</p><p class=
=3D"MsoNormal">=C2=A0</p><p class=3D"MsoNormal">The FC transport service in=
terprets the data received through HBA, and fails</p><p class=3D"MsoNormal"=
>the corresponding marginal paths using the device mapper and multipath</p>=
<p class=3D"MsoNormal">libraries.</p><p class=3D"MsoNormal">=C2=A0</p><p cl=
ass=3D"MsoNormal">Below are the ways where the marginal path can be moved t=
o active.</p><p class=3D"MsoNormal">1.port toggling after resolving the lin=
k issues in fabric</p><p class=3D"MsoNormal">2.Host intervention using mult=
ipathd utilities.</p><p class=3D"MsoNormal">=C2=A0</p><p class=3D"MsoNormal=
">The code is available in the below GIT repository.</p><p class=3D"MsoNorm=
al">=C2=A0</p><p class=3D"MsoNormal"><a href=3D"https://github.com/brocade/=
bsn-linux-open-os-contributions">https://github.com/brocade/bsn-linux-open-=
os-contributions</a></p><p class=3D"MsoNormal">=C2=A0</p><p class=3D"MsoNor=
mal">=C2=A0</p><p class=3D"MsoNormal">Please refer to the README for more d=
etails regarding compilation, service</p><p class=3D"MsoNormal">functionali=
ty and usage.</p><p class=3D"MsoNormal">=C2=A0</p><p class=3D"MsoNormal"><a=
 href=3D"https://github.com/brocade/bsn-linux-open-os-contributions/tree/ma=
ster/mpio/Fabric_Assist/FC_Transport_Daemon">https://github.com/brocade/bsn=
-linux-open-os-contributions/tree/master/mpio/Fabric_Assist/FC_Transport_Da=
emon</a></p><p class=3D"MsoNormal">=C2=A0</p><p class=3D"MsoNormal">=C2=A0<=
/p><p class=3D"MsoNormal">Contributors:</p><p class=3D"MsoNormal"><a href=
=3D"mailto:Benjamin%3Abmarzins@redhat.com">Benjamin:bmarzins@redhat.com</a>=
,</p><p class=3D"MsoNormal">Muneendra:(<a href=3D"mailto:muneendra.kumar@br=
oadcom.com">muneendra.kumar@broadcom.com</a>)</p><p class=3D"MsoNormal">Gan=
esh:(<a href=3D"mailto:ganesh.pai@broadcom.com">ganesh.pai@broadcom.com</a>=
)</p><p class=3D"MsoNormal">=C2=A0</p><p class=3D"MsoNormal">Future Work:</=
p><p class=3D"MsoNormal">Instead of moving the path to fail state we are pl=
anning to move the path to special priority group</p><p class=3D"MsoNormal"=
>as defined by dm-multipath(which is to be implemented)</p><p class=3D"MsoN=
ormal">=C2=A0</p><p class=3D"MsoNormal">History:</p><p class=3D"MsoNormal">=
=C2=A0</p><p class=3D"MsoNormal">The kernel related changes to send the ELS=
 notifications to the user space is already available in the upstream.</p><=
p class=3D"MsoNormal">Below are the links related to the same.</p><p class=
=3D"MsoNormal">=C2=A0</p><p class=3D"MsoNormal"><span style=3D"font-size:9.=
0pt;font-family:Consolas;color:#444d56;background:white">Linux:</span></p><=
p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:Consolas;c=
olor:#444d56;background:white">All the HBA and scsi transport related chang=
es are available in linux upstream</span></p><p class=3D"MsoNormal"><span s=
tyle=3D"font-size:9.0pt;font-family:Consolas;color:#444d56;background:white=
">=C2=A0</span></p><p class=3D"MsoNormal"><a href=3D"https://github.com/tor=
valds/linux/">https://github.com/torvalds/linux/</a><span style=3D"color:#1=
f497d">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 </span></p><p class=3D"MsoNormal"><span style=3D"color:#1f497d=
">=C2=A0</span></p><p class=3D"MsoNormal"><span style=3D"color:#1f497d">Com=
mitId:</span></p><p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font=
-family:Consolas;color:#444d56;background:white">1a61e5486aeb90d94dd6116c97=
49e36edd10bf9b </span><span style=3D"font-size:9.0pt;font-family:Wingdings;=
color:#444d56;background:white">=C3=A8</span><a href=3D"https://github.com/=
torvalds/linux/commit/1a61e5486aeb90d94dd6116c9749e36edd10bf9b">https://git=
hub.com/torvalds/linux/commit/1a61e5486aeb90d94dd6116c9749e36edd10bf9b</a><=
span style=3D"font-size:9.0pt;font-family:Consolas;color:#444d56;background=
:white"></span></p><p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;fo=
nt-family:Consolas;color:#444d56;background:white">=C2=A0</span></p><p clas=
s=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:Consolas;color:#=
444d56;background:white">c39e0af64bce3bba61c3986d6083df7b8f29a310 </span><s=
pan style=3D"font-size:9.0pt;font-family:Wingdings;color:#444d56;background=
:white">=C3=A8</span><a href=3D"https://github.com/torvalds/linux/commit/c3=
9e0af64bce3bba61c3986d6083df7b8f29a310">https://github.com/torvalds/linux/c=
ommit/c39e0af64bce3bba61c3986d6083df7b8f29a310</a></p><p class=3D"MsoNormal=
"><span style=3D"font-size:9.0pt;font-family:Consolas;color:#444d56;backgro=
und:white">=C2=A0</span></p><p class=3D"MsoNormal"><span style=3D"font-size=
:9.0pt;font-family:Consolas;color:#444d56;background:white">2b1be55819dc7ae=
35576b3ba621c7fed0c323e04 </span><span style=3D"font-size:9.0pt;font-family=
:Wingdings;color:#444d56;background:white">=C3=A8</span><a href=3D"https://=
github.com/torvalds/linux/commit/2b1be55819dc7ae35576b3ba621c7fed0c323e04">=
https://github.com/torvalds/linux/commit/2b1be55819dc7ae35576b3ba621c7fed0c=
323e04</a></p><p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-fa=
mily:Consolas;color:#444d56;background:white">=C2=A0</span></p><p class=3D"=
MsoNormal"><span style=3D"font-size:9.0pt;font-family:Consolas;color:#444d5=
6;background:white">a7dff3ad4787381a3aa831d558fb720b8f354435 </span><span s=
tyle=3D"font-size:9.0pt;font-family:Wingdings;color:#444d56;background:whit=
e">=C3=A8</span><a href=3D"https://github.com/torvalds/linux/commit/a7dff3a=
d4787381a3aa831d558fb720b8f354435">https://github.com/torvalds/linux/commit=
/a7dff3ad4787381a3aa831d558fb720b8f354435</a><span style=3D"font-size:9.0pt=
;font-family:Consolas;color:#444d56;background:white"></span></p><p class=
=3D"MsoNormal"><span style=3D"color:#1f497d">=C2=A0</span></p><p class=3D"M=
soNormal">Regards,</p><p class=3D"MsoNormal">Muneendra.</p></div></body></h=
tml>

--00000000000073aa45058aa5870f--


--===============1231869251720431936==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1231869251720431936==--
