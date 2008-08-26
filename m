From: "Vardaris, C - SPLXM" <Christos.Vardaris@klm.com>
Subject: Losing paths
Date: Tue, 26 Aug 2008 09:33:16 +0200
Message-ID: <E6D1DDD48426A44EB25DF27F5AAE7A6505F95DD7@KL1010XG.cs.ad.klmcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2134299574=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

This is a multi-part message in MIME format.


--===============2134299574==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C9074D.FFF04489"

This is a multi-part message in MIME format.


------_=_NextPart_001_01C9074D.FFF04489
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

To all,=0D=0A=0D=0A =0D=0A=0D=0AMy colleague Menno tried the readsector0 se=
tting and had better results=0D=0Abut tur is still the preferred setting=2E=
=0D=0A=0D=0ASo we try to come to a solution with tur as a setting=2E=0D=0A=
=0D=0A =0D=0A=0D=0AThe official response about the (SVC) SCSI responses of =
IBM support you=0D=0Acan find below=2E=0D=0A=0D=0AWe unmapped and mapped ex=
isting luns on a Linux server and IBM analyzed=0D=0Athe SVC dump=2E=0D=0A=
=0D=0A =0D=0A=0D=0ACan the solution be that there is an extra option where =
tur checks xx=0D=0Atimes if there is a SCSI check condition=0D=0A=0D=0Aand =
then reports the path down=2E This instead of reporting him down after=0D=
=0Aone SCSI check condition=2E=0D=0A=0D=0A =0D=0A=0D=0AFrom IBM support:=0D=
=0A=0D=0AWhen the mappings change between a SVC and a host server, SVC will=
=0D=0A=0D=0A=0D=0Aalways set a SCSI Unit Attention:  "Reported Luns Data Ha=
s Changed"=2E=0D=0A=0D=0A=0D=0AThis means the next SCSI command to arrive f=
rom the host for each=0D=0A=0D=0A=0D=0AInitiator Port/Target Port/Vdisk com=
bination will be failed with that=0D=0A=0D=0A=0D=0ASCSI Check condition=2E =
 This is the method by which SVC (as a passive=0D=0A=0D=0A=0D=0ASCSI Target=
) can alert the host server (SCSI Initiator) that something=0D=0A=0D=0A=0D=
=0Aabout the configuration has changed=2E=0D=0A=0D=0A=0D=0A =0D=0A=0D=0A=0D=
=0AIn this case specifically, the host has 7 Vdisks mapped - then one is=0D=
=0A=0D=0A=0D=0Aunmapped=2E  The next SCSI command (Test Unit Ready) to arri=
ve at SVC for=0D=0A=0D=0A=0D=0Aeach SCSI lun is failed as follows:  The 6 t=
o the still mapped luns are=0D=0A=0D=0A=0D=0Afailed with the SCSI Unit Atte=
ntion:  "Reported Luns Data Has Changed"=0D=0A=0D=0A=0D=0ACheck condition, =
and the one command to the now unmapped lun is failed=0D=0A=0D=0A=0D=0Awith=
 a SCSI Check Condition:  Illegal Request, "Logical Unit Not=0D=0A=0D=0A=0D=
=0ASupported"=2E=0D=0A=0D=0A=0D=0A =0D=0A=0D=0A=0D=0AOver the next minute o=
r so, many more SCSI Test Unit Ready and Inquiry=0D=0A=0D=0A=0D=0A(Page 0x8=
3) commands are failed for the unmapped lun=2E=0D=0A=0D=0AThat is, the host=
 continues to send commands so SCSI Lun 1, and SVC=0D=0Acontinues to fail t=
hem  =0D=0A=0D=0Awith Check Condition:  Illegal Request "Logical Unit Not S=
upported"=2E=0D=0A=0D=0A=0D=0AThen the Vdisk is mapped again, and SVC sets =
the SCSI Unit Attention:=0D=0A=0D=0A=0D=0AReported Luns Data Has Changed ch=
eck condition again, which, again,=0D=0A=0D=0A=0D=0Acauses another set of c=
ommands to be failed to all luns - 7 commands in=0D=0A=0D=0A=0D=0Atotal thi=
s time - one to each lun=2E=0D=0A=0D=0A=0D=0A =0D=0A=0D=0A=0D=0AAside from =
the commands failed as described above, all other SCSI=0D=0A=0D=0A=0D=0Acom=
mands (e=2Eg=2E  Test Unit Ready, Inquir, Maintenance In (with Sevice=0D=0A=
=0D=0A=0D=0AAction:  Report Target Port Groups)) complete promptly with Goo=
d status=2E=0D=0A=0D=0A=0D=0A =0D=0A=0D=0A=0D=0AThis pattern repeats a coup=
le more times - for vdisk 15 and then for=0D=0A=0D=0A=0D=0Avdisk 14=2E=0D=
=0A=0D=0A=0D=0A =0D=0A=0D=0A=0D=0AWhether the Test Unit Ready commands succ=
eed or are failed with the=0D=0A=0D=0A=0D=0ACheck conditions described abov=
e does not seem to make a difference to=0D=0A=0D=0A=0D=0Athe SVC response t=
ime - of the couple of thousand we have details for,=0D=0A=0D=0A=0D=0Aall e=
xcept for 4 took less than 100us to complete=2E  The 'slowest' 4 took=0D=0A=
=0D=0A=0D=0A1, 1=2E2, 1=2E4 and 6 ms to complete=2E=0D=0A=0D=0A=0D=0A =0D=
=0A=0D=0A=0D=0ASVC is working as designed here and nothing suspicious is fo=
und from=0D=0A=0D=0A=0D=0ASVC side=2E We guess something about the check co=
nditions=0D=0A=0D=0A=0D=0ASVC is reporting when the mappings are changed is=
 leading to the delay=0D=0A=0D=0A=0D=0Aon the host perhaps?=0D=0A=0D=0A=0D=
=0A =0D=0A=0D=0A =0D=0A=0D=0A =0D=0A=0D=0AKind regards,=0D=0A=0D=0AChris =
=0D=0A=0D=0A =0D=0A=0D=0A =0D=0A=0D=0A =0D=0A=0D=0A =0D=0A=0D=0A=0D=0A=0D=
=0A**********************************************************************=
=0D=0AFor information, services and offers, please visit our web site:=0Aht=
tp://www=2Eklm=2Ecom=2E This e-mail and any attachment may contain=0Aconfid=
ential and privileged material intended for the addressee=0Aonly=2E If you =
are not the addressee, you are notified that no part=0Aof the e-mail or any=
 attachment may be disclosed, copied or=0Adistributed, and that any other a=
ction related to this e-mail or=0Aattachment is strictly prohibited, and ma=
y be unlawful=2E If you have=0Areceived this e-mail by error, please notify=
 the sender immediately=0Aby return e-mail, and delete this message=2E =0D=
=0A=0D=0AKoninklijke Luchtvaart Maatschappij NV (KLM), its subsidiaries=0Aa=
nd/or its employees shall not be liable for the incorrect or=0Aincomplete t=
ransmission of this e-mail or any attachments, nor=0Aresponsible for any de=
lay in receipt=2E=0D=0AKoninklijke Luchtvaart Maatschappij N=2EV=2E (also k=
nown as KLM Royal=0ADutch Airlines) is registered in Amstelveen, The Nether=
lands, with=0Aregistered number 33014286 =0D=0A****************************=
******************************************
------_=_NextPart_001_01C9074D.FFF04489
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" xmlns:w=3D"urn:sc=
hemas-microsoft-com:office:word" xmlns=3D"http://www=2Ew3=2Eorg/TR/REC-html=
40">=0D=0A=0D=0A<head>=0D=0A<meta http-equiv=3DContent-Type content=3D"text=
/html; charset=3Dus-ascii">=0D=0A<meta name=3DGenerator content=3D"Microsof=
t Word 11 (filtered medium)">=0D=0A<style>=0D=0A<!--=0D=0A /* Style Definit=
ions */=0D=0A p=2EMsoNormal, li=2EMsoNormal, div=2EMsoNormal=0D=0A	{margin:=
0in;=0D=0A	margin-bottom:=2E0001pt;=0D=0A	font-size:11=2E0pt;=0D=0A	font-fa=
mily:Arial;}=0D=0Aa:link, span=2EMsoHyperlink=0D=0A	{color:blue;=0D=0A	text=
-decoration:underline;}=0D=0Aa:visited, span=2EMsoHyperlinkFollowed=0D=0A	{=
color:purple;=0D=0A	text-decoration:underline;}=0D=0Aspan=2EEmailStyle17=0D=
=0A	{mso-style-type:personal-compose;=0D=0A	font-family:Arial;=0D=0A	color:=
windowtext;}=0D=0A@page Section1=0D=0A	{size:595=2E35pt 842=2E0pt;=0D=0A	ma=
rgin:1=2E0in 89=2E85pt 1=2E0in 89=2E85pt;}=0D=0Adiv=2ESection1=0D=0A	{page:=
Section1;}=0D=0A-->=0D=0A</style>=0D=0A=0D=0A</head>=0D=0A=0D=0A<body lang=
=3DEN-US link=3Dblue vlink=3Dpurple>=0D=0A=0D=0A<div class=3DSection1>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DNL s=
tyle=3D'font-size:10=2E0pt'>To=0D=0Aall,<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DNL styl=
e=3D'font-size:10=2E0pt'><o:p>&nbsp;</o:p></span></font></p>=0D=0A=0D=0A<p =
class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>My colleague=0D=0AMenno tried the readsector0 setting and had bette=
r results but tur is still the=0D=0Apreferred setting=2E<o:p></o:p></span><=
/font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><spa=
n style=3D'font-size:10=2E0pt'>So we=0D=0Atry to come to a solution with tu=
r as a setting=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNor=
mal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'><o:p>&nb=
sp;</o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 =
face=3DArial><span style=3D'font-size:10=2E0pt'>The=0D=0Aofficial response =
about the (SVC) SCSI responses of IBM support you can find=0D=0Abelow=2E<o:=
p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 f=
ace=3DArial><span style=3D'font-size:10=2E0pt'>We=0D=0Aunmapped and mapped =
existing luns on a Linux server and IBM analyzed the SVC=0D=0Adump=2E<o:p><=
/o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=
=3DArial><span style=3D'font-size:10=2E0pt'><o:p>&nbsp;</o:p></span></font>=
</p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span styl=
e=3D'font-size:10=2E0pt'>Can=0D=0Athe solution be that there is an extra op=
tion where tur checks xx times if there=0D=0Ais a SCSI check condition<o:p>=
</o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fac=
e=3DArial><span style=3D'font-size:10=2E0pt'>and then=0D=0Areports the path=
 down=2E This instead of reporting him down after one SCSI check=0D=0Acondi=
tion=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font =
size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'><o:p>&nbsp;</o:p><=
/span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DAri=
al><span style=3D'font-size:10=2E0pt'>From=0D=0AIBM support:<o:p></o:p></sp=
an></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none=
'><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0p=
t;font-family:"Courier New"'>When the mappings change=0D=0Abetween a SVC an=
d a host server, SVC=0D=0Awill&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o=
:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-a=
utospace:none'><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font=
-size:10=2E0pt;font-family:"Courier New"'>always set a SCSI Unit=0D=0AAtten=
tion:&nbsp; &quot;Reported Luns Data Has=0D=0AChanged&quot;=2E&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNo=
rmal style=3D'text-autospace:none'><font size=3D2 face=3D"Courier New"><spa=
n=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'>This means th=
e next SCSI=0D=0Acommand to arrive from the host for=0D=0Aeach&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=
=0A<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=
=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courie=
r New"'>Initiator Port/Target=0D=0APort/Vdisk combination will be failed wi=
th that&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=0A<p=
 class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"Cou=
rier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'=
>SCSI Check condition=2E&nbsp;=0D=0AThis is the method by which SVC (as a p=
assive&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=
=0A<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=
=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courie=
r New"'>SCSI Target) can alert the=0D=0Ahost server (SCSI Initiator) that s=
omething&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=0A<p clas=
s=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"Courier =
New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'>abou=
t the configuration has=0D=0Achanged=2E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=0D=0A<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Co=
urier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
=0D=0A<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=
=3D'text-autospace:none'><font size=3D2 face=3D"Courier New"><span=0D=0Asty=
le=3D'font-size:10=2E0pt;font-family:"Courier New"'>In this case specifical=
ly,=0D=0Athe host has 7 Vdisks mapped - then one is&nbsp;&nbsp;&nbsp;&nbsp;=
 <o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'tex=
t-autospace:none'><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'f=
ont-size:10=2E0pt;font-family:"Courier New"'>unmapped=2E&nbsp; The next=0D=
=0ASCSI command (Test Unit Ready) to arrive at SVC for&nbsp;&nbsp; <o:p></o=
:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospa=
ce:none'><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:=
10=2E0pt;font-family:"Courier New"'>each SCSI lun is failed as=0D=0Afollows=
:&nbsp; The 6 to the still mapped luns are&nbsp;&nbsp; <o:p></o:p></span></=
font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'><fo=
nt size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;fon=
t-family:"Courier New"'>failed with the SCSI Unit=0D=0AAttention:&nbsp; &qu=
ot;Reported Luns Data Has Changed&quot;&nbsp;&nbsp;&nbsp; <o:p></o:p></span=
></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'>=
<font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;=
font-family:"Courier New"'>Check condition, and the one=0D=0Acommand to the=
 now unmapped lun is failed&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'><font size=
=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-famil=
y:"Courier New"'>with a SCSI Check=0D=0ACondition:&nbsp; Illegal Request, &=
quot;Logical Unit=0D=0ANot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=
=3D'text-autospace:none'><font size=3D2 face=3D"Courier New"><span=0D=0Asty=
le=3D'font-size:10=2E0pt;font-family:"Courier New"'>Supported&quot;=2E&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=0D=0A<o=
:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-a=
utospace:none'><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font=
-size:10=2E0pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=0D=0A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<o:p></o:p></span></font></p>=0D=0A=0D=
=0A<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=
=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courie=
r New"'>Over the next minute or so,=0D=0Amany more SCSI Test Unit Ready and=
 Inquiry&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=0A<p clas=
s=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"Courier =
New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'>(Pag=
e 0x83) commands are=0D=0Afailed for the unmapped lun=2E<o:p></o:p></span><=
/font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'><f=
ont size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;fo=
nt-family:"Courier New"'>That is, the host continues=0D=0Ato send commands =
so SCSI Lun 1, and SVC continues to fail them&nbsp; <o:p></o:p></span></fon=
t></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'><font =
size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-f=
amily:"Courier New"'>with Check Condition:&nbsp;=0D=0AIllegal Request &quot=
;Logical Unit Not=0D=0ASupported&quot;=2E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:=
p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-au=
tospace:none'><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-=
size:10=2E0pt;font-family:"Courier New"'>Then the Vdisk is mapped=0D=0Aagai=
n, and SVC sets the SCSI Unit Attention:&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p=
></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace=
:none'><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=
=2E0pt;font-family:"Courier New"'>Reported Luns Data Has=0D=0AChanged check=
 condition again, which,=0D=0Aagain,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o=
:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-a=
utospace:none'><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font=
-size:10=2E0pt;font-family:"Courier New"'>causes another set of=0D=0Acomman=
ds to be failed to all luns - 7 commands in&nbsp;&nbsp; <o:p></o:p></span><=
/font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'><f=
ont size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;fo=
nt-family:"Courier New"'>total this time - one to=0D=0Aeach=0D=0Alun=2E&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;=0D=0A<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal st=
yle=3D'text-autospace:none'><font size=3D2 face=3D"Courier New"><span=0D=0A=
style=3D'font-size:10=2E0pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=0D=0A<o:p></o:p></span></font><=
/p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'><font siz=
e=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-fami=
ly:"Courier New"'>Aside from the commands=0D=0Afailed as described above, a=
ll other SCSI&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<o:p></o:p></=
span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:no=
ne'><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E=
0pt;font-family:"Courier New"'>commands (e=2Eg=2E&nbsp; Test=0D=0AUnit Read=
y, Inquir, Maintenance In (with Sevice&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p><=
/o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autos=
pace:none'><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-siz=
e:10=2E0pt;font-family:"Courier New"'>Action:&nbsp; Report Target=0D=0APort=
 Groups)) complete promptly with Good status=2E&nbsp; <o:p></o:p></span></f=
ont></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'><fon=
t size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font=
-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;=0D=0A<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNor=
mal style=3D'text-autospace:none'><font size=3D2 face=3D"Courier New"><span=
=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'>This pattern r=
epeats a couple=0D=0Amore times - for vdisk 15 and then for&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNorma=
l style=3D'text-autospace:none'><font size=3D2 face=3D"Courier New"><span=
=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'>vdisk=0D=0A14=
=2E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;=0D=0A<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNo=
rmal style=3D'text-autospace:none'><font size=3D2 face=3D"Courier New"><spa=
n=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'>&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=0D=0A<o:p></o:p></span><=
/font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'><f=
ont size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;fo=
nt-family:"Courier New"'>Whether the Test Unit Ready=0D=0Acommands succeed =
or are failed with the&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></spa=
n></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'=
><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt=
;font-family:"Courier New"'>Check conditions described=0D=0Aabove does not =
seem to make a difference to&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p=
>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:none'><font size=
=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-famil=
y:"Courier New"'>the SVC response time - of=0D=0Athe couple of thousand we =
have details for,&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=
=0A<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=
=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courie=
r New"'>all except for 4 took less=0D=0Athan 100us to complete=2E&nbsp; The=
 'slowest' 4 took&nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"Courier N=
ew"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'>1, 1=
=2E2, 1=2E4 and 6 ms to=0D=0Acomplete=2E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=0D=0A<o:p></o:p></s=
pan></font></p>=0D=0A=0D=0A<p class=3DMsoNormal style=3D'text-autospace:non=
e'><font size=3D2 face=3D"Courier New"><span=0D=0Astyle=3D'font-size:10=2E0=
pt;font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;=0D=0A<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"Courier N=
ew"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'>SVC i=
s working as designed=0D=0Ahere and nothing suspicious is found from&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"Courier N=
ew"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'>SVC s=
ide=2E We guess something=0D=0Aabout the check=0D=0Aconditions&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;=0D=0A<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"Courier N=
ew"><span=0D=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'>SVC i=
s reporting when the=0D=0Amappings are changed is leading to the delay&nbsp=
;&nbsp;&nbsp; <o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal=
 style=3D'text-autospace:none'><font size=3D2 face=3D"Courier New"><span=0D=
=0Astyle=3D'font-size:10=2E0pt;font-family:"Courier New"'>on the host=0D=0A=
perhaps?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;=0D=0A<o:p></o:p></span></font></p>=0D=0A=0D=0A<p=
 class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'><o:p>&nbsp;</o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal=
><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'><o:p>&nbsp;=
</o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 col=
or=3Dnavy face=3DArial><span style=3D'font-size:=0D=0A10=2E0pt;color:navy'>=
&nbsp;</span></font><font size=3D2><span style=3D'font-size:=0D=0A10=2E0pt'=
><o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 color=3Dnavy face=3DArial><span style=3D'font-size:=0D=0A10=2E0pt;colo=
r:navy;layout-grid-mode:line'>Kind regards,<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><spa=
n style=3D'font-size:=0D=0A10=2E0pt;color:navy;layout-grid-mode:line'>Chris=
 </span></font><o:p></o:p></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 face=3DArial><span style=3D'font-size:11=2E0pt'>&nbsp;<b><font=0D=0Aco=
lor=3Dnavy><span style=3D'color:navy;layout-grid-mode:line;font-weight:bold=
'><o:p></o:p></span></font></b></span></font></p>=0D=0A=0D=0A<p class=3DMso=
Normal><b><font size=3D2 color=3Dnavy face=3DArial><span=0D=0Astyle=3D'font=
-size:11=2E0pt;color:navy;layout-grid-mode:line;font-weight:bold'><o:p>&nbs=
p;</o:p></span></font></b></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 face=3DArial><span style=3D'font-size:11=2E0pt'>&nbsp;<font=0D=0Acolor=
=3Dnavy><span style=3D'color:navy;layout-grid-mode:line'><o:p></o:p></span>=
</font></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fa=
ce=3DArial><span style=3D'font-size:11=2E0pt'><o:p>&nbsp;</o:p></span></fon=
t></p>=0D=0A=0D=0A</div>=0D=0A=0D=0A</body>=0D=0A=0D=0A</html>=0D=0A=0D=0A*=
********************************************************************* <br>F=
or information, services and offers, please visit our web site: http://www=
=2Eklm=2Ecom=2E This e-mail and any attachment may contain confidential and=
 privileged material intended for the addressee only=2E If you are not the =
addressee, you are notified that no part of the e-mail or any attachment ma=
y be disclosed, copied or distributed, and that any other action related to=
 this e-mail or attachment is strictly prohibited, and may be unlawful=2E I=
f you have received this e-mail by error, please notify the sender immediat=
ely by return e-mail, and delete this message=2E =0D=0A=0D=0AKoninklijke Lu=
chtvaart Maatschappij NV (KLM), its subsidiaries and/or its employees shall=
 not be liable for the incorrect or incomplete transmission of this e-mail =
or any attachments, nor responsible for any delay in receipt=2E Koninklijke=
 Luchtvaart Maatschappij N=2EV=2E (also known as KLM Royal Dutch Airlines) =
is registered in Amstelveen, The Netherlands, with registered number 330142=
86 **********************************************************************  =
=0D=0A
------_=_NextPart_001_01C9074D.FFF04489--


--===============2134299574==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2134299574==--
