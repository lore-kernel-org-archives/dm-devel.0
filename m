From: Christophe BOULLANGER <cbo@info-services.biz>
Subject: Multipath conf
Date: Fri, 10 Jun 2011 10:46:30 -0400
Message-ID: <80B8E0EA896B3E489A5802234274BA9C77C968B828@sandy.IS972DH.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1735898580905003483=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: fr-FR
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1735898580905003483==
Content-Language: fr-FR
Content-Type: multipart/related;
	boundary="_004_80B8E0EA896B3E489A5802234274BA9C77C968B828sandyIS972DHc_";
	type="multipart/alternative"

--_004_80B8E0EA896B3E489A5802234274BA9C77C968B828sandyIS972DHc_
Content-Type: multipart/alternative;
	boundary="_000_80B8E0EA896B3E489A5802234274BA9C77C968B828sandyIS972DHc_"

--_000_80B8E0EA896B3E489A5802234274BA9C77C968B828sandyIS972DHc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

i wanna know what is that difference of both stout of multipath -ll
<Anti-T> multipath -ll
<Anti-T> mpath2 (350010b900004b868) dm-3 IBM-ESXS,GNA073C3ESTT0Z
<Anti-T> [size=3D68G][features=3D0][hwhandler=3D0]
<Anti-T> \_ round-robin 0 [prio=3D1][active]
<Anti-T>  \_ 1:0:1:0 sdc 8:32  [active][ready]
<Anti-T> \_ round-robin 0 [prio=3D1][enabled]
<Anti-T>  \_ 1:0:3:0 sde 8:64  [active][ready]
<Anti-T> c quoi la diff entre ca
<Anti-T> et ca
<Anti-T> orasm (36005076b0755627f4dee6fd70000002d) dm-6 IBM,1820N00
<Anti-T> size=3D250G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Dr=
w
<Anti-T> `-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
<Anti-T>   |- 0:0:3:0 sdb 8:16 active ready running
<Anti-T>   `- 0:0:2:0 sda 8:0  active ready running

One have 2 tree and one both disk is on the same branch

One is more secure ?

Thank you for your help.
Have a nice day.
_______________________________
Christophe BOULLANGER
Informatique Services
Immeuble Rubix
Zone de Manhity
97232 Le Lamentin
Tel : 0596 66 69 98
[cid:624074314@10062011-1FE1]<http://www.isbackup.fr/>


--_000_80B8E0EA896B3E489A5802234274BA9C77C968B828sandyIS972DHc_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META content=3D"text/html; charset=3Dus-ascii" http-equiv=3DContent-Type>
<META name=3DGENERATOR content=3D"MSHTML 8.00.6001.19019"></HEAD>
<BODY>
<DIV><FONT size=3D2 face=3DArial><SPAN=20
class=3D624074314-10062011>Hi,</SPAN></FONT></DIV>
<DIV><FONT size=3D2 face=3DArial><SPAN=20
class=3D624074314-10062011></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial><SPAN class=3D624074314-10062011>i wanna k=
now what is=20
that difference of both stout of multipath -ll</SPAN></FONT></DIV>
<DIV><FONT size=3D2 face=3DArial><SPAN class=3D624074314-10062011>&lt;Anti-=
T&gt;=20
multipath -ll <BR>&lt;Anti-T&gt; mpath2 (350010b900004b868) dm-3=20
IBM-ESXS,GNA073C3ESTT0Z <BR>&lt;Anti-T&gt; [size=3D68G][features=3D0][hwhan=
dler=3D0]=20
<BR>&lt;Anti-T&gt; \_ round-robin 0 [prio=3D1][active] <BR>&lt;Anti-T&gt;&n=
bsp; \_=20
1:0:1:0 sdc 8:32&nbsp; [active][ready] <BR>&lt;Anti-T&gt; \_ round-robin 0=
=20
[prio=3D1][enabled] <BR>&lt;Anti-T&gt;&nbsp; \_ 1:0:3:0 sde 8:64&nbsp;=20
[active][ready] <BR>&lt;Anti-T&gt; c quoi la diff entre ca<BR>&lt;Anti-T&gt=
; et=20
ca<BR>&lt;Anti-T&gt; orasm (36005076b0755627f4dee6fd70000002d) dm-6=20
IBM,1820N00<BR>&lt;Anti-T&gt; size=3D250G features=3D'1 queue_if_no_path'=20
hwhandler=3D'0' wp=3Drw<BR>&lt;Anti-T&gt; `-+- policy=3D'round-robin 0' pri=
o=3D1=20
status=3Dactive<BR>&lt;Anti-T&gt;&nbsp;&nbsp; |- 0:0:3:0 sdb 8:16 active re=
ady=20
running<BR>&lt;Anti-T&gt;&nbsp;&nbsp; `- 0:0:2:0 sda 8:0&nbsp; active ready=
=20
running</SPAN></FONT></DIV>
<DIV><FONT size=3D2 face=3DArial><SPAN=20
class=3D624074314-10062011></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial><SPAN class=3D624074314-10062011>One have =
2 tree and=20
one both disk is on the same branch</SPAN></FONT></DIV>
<DIV><FONT size=3D2 face=3DArial><SPAN=20
class=3D624074314-10062011></SPAN></FONT>&nbsp;</DIV>
<DIV><SPAN class=3D624074314-10062011><FONT size=3D2 face=3DArial>One is mo=
re secure=20
?</FONT></SPAN></DIV>
<DIV><SPAN class=3D624074314-10062011><FONT size=3D2=20
face=3DArial></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D624074314-10062011><FONT size=3D2 face=3DArial>Thank you=
 for your=20
help.</FONT></SPAN></DIV>
<DIV><SPAN class=3D624074314-10062011><FONT size=3D2 face=3DArial>Have a ni=
ce=20
day.</FONT></SPAN></DIV>
<DIV style=3D"TEXT-ALIGN: right" align=3Dleft><SMALL><SPAN=20
style=3D"FONT-WEIGHT: bold">_______________________________<BR>Christophe=20
BOULLANGER<BR>Informatique Services<BR>Immeuble Rubix<BR>Zone de=20
Manhity<BR>97232 Le Lamentin</SPAN></SMALL></DIV>
<DIV style=3D"TEXT-ALIGN: right" align=3Dleft><SMALL><SPAN=20
style=3D"FONT-WEIGHT: bold">Tel : 0596 66 69 98</SMALL><BR></SPAN><A=20
href=3D"http://www.isbackup.fr/"><IMG=20
style=3D"BORDER-BOTTOM: 0px solid; BORDER-LEFT: 0px solid; WIDTH: 200px; HE=
IGHT: 61px; BORDER-TOP: 0px solid; BORDER-RIGHT: 0px solid"=20
alt=3DisBackup src=3D"cid:624074314@10062011-1FE1"></A><BR></DIV>
<DIV>&nbsp;</DIV></BODY></HTML>

--_000_80B8E0EA896B3E489A5802234274BA9C77C968B828sandyIS972DHc_--

--_004_80B8E0EA896B3E489A5802234274BA9C77C968B828sandyIS972DHc_
Content-Type: image/gif; name="image001.gif"
Content-Description: image001.gif
Content-Disposition: inline; filename="image001.gif"; size=4352;
	creation-date="Fri, 10 Jun 2011 10:46:30 GMT";
	modification-date="Fri, 10 Jun 2011 10:46:30 GMT"
Content-ID: <624074314@10062011-1FE1>
Content-Transfer-Encoding: base64

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
BnuwCJuwCruwDNuwDvuwDBsQADs=

--_004_80B8E0EA896B3E489A5802234274BA9C77C968B828sandyIS972DHc_--


--===============1735898580905003483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1735898580905003483==--
