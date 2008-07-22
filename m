From: "Daniel Keisling" <daniel.keisling@austin.ppdi.com>
Subject: Re: Losing paths
Date: Tue, 22 Jul 2008 11:21:53 -0500
Message-ID: <65F9ACC78BD8304BAAEB817634C62D4C060CFB67@AUSMAIL01.americas.ppdi.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1886213281=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============1886213281==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C8EC17.0E72F690"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8EC17.0E72F690
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

FWIW, I have the same issue under an HP EVA8000.  I'm not really certain if=
 directio is a solution as I have only seen the tur checker being used with=
 an EVA.=0D=0A=20=0D=0ADaniel=0D=0A=20=0D=0A=20=0D=0A----------------------=
-----------------------------------------------------------------------=0D=0A=
Date: Tue, 22 Jul 2008 16:55:27 +0200=0D=0AFrom: Hannes Reinecke <hare@suse=
=2Ede>=0D=0ASubject: Re: [dm-devel] Losing paths=0D=0ATo: device-mapper dev=
elopment <dm-devel@redhat.com>=0D=0AMessage-ID: <4885F4DF.8010000@suse.de>=0D=
=0AContent-Type: text/plain; charset=3DISO-8859-1; format=3Dflowed=0D=0A =0D=
=0AHi John,=0D=0A=20=0D=0ARomanowski, John (OFT) wrote:=0D=0A> Hi,=0D=0A> W=
e had similar problem last year using sles9 and SVC 4.2.0.2,  as you descri=
be: adding/deleting a LUN causes=0D=0A> brief path failures for the host's =
remaining, unaffected LUNs.=0D=0A>=20=0D=0A> We were using tur checker and =
it turned out that while adding/deleting a LUN (and some other admin tasks)=0D=
=0A> the SVC does not respond well to test-unit-ready tur requests; but it =
responds perfectly well to normal read=0D=0A> commands. I opened IBM PMR 43=
118 on that if you want to ask the SVC folks about it. =20=0D=0A>=20=0D=0A>=
 Workaround for us was to use readsector0 instead of  tur as multipath path=
 checker.=20=0D=0A> =20=0D=0A> Recent post here (see July 8, 2008)  said mu=
ltipath-tools is deprecating readsector0, and to use directio as=0D=0A> pat=
h checker, but directio was said to be much slower than tur, implying tur w=
as better replacement than=0D=0A> directio for readsector0.=20=0D=0A>=0D=0A=
Only for those cases where no actual read-access is necessary.=0D=0A=20=0D=0A=
> Not sure what deprecating readsector0 means for us SVC users. =20=0D=0A> =0D=
=0AIt means you should be using directio there.=0D=0A=20=0D=0AThanks for th=
e information, I'll see to have it included in SLES10.=0D=0A=20=0D=0ACheers=
,=0D=0A=20=0D=0AHannes=0D=0A--=20=0D=0ADr. Hannes Reinecke        zSeries &=
 Storage=0D=0Ahare@suse.de         +49 911 74053 688=0D=0ASUSE LINUX Produc=
ts GmbH, Maxfeldstr. 5, 90409 N=FCrnberg=0D=0AGF: Markus Rex, HRB 16746 (AG=
 N=FCrnberg)=0D=0A=0D=0A=0D=0A_____________________________________________=
_________________________=0D=0AThis email transmission and any documents, f=
iles or previous email=0D=0Amessages attached to it may contain information=
 that is confidential or=0D=0Alegally privileged. If you are not the intend=
ed recipient or a person=0D=0Aresponsible for delivering this transmission =
to the intended recipient,=0D=0Ayou are hereby notified that you must not r=
ead this transmission and=0D=0Athat any disclosure, copying, printing, dist=
ribution or use of this=0D=0Atransmission is strictly prohibited. If you ha=
ve received this transmission=0D=0Ain error, please immediately notify the =
sender by telephone or return email=0D=0Aand delete the original transmissi=
on and its attachments without reading=0D=0Aor saving in any manner.=0D=0A
------_=_NextPart_001_01C8EC17.0E72F690
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">=0D=0A<HTML><=
HEAD>=0D=0A<META http-equiv=3DContent-Type content=3D"text/html; charset=3D=
iso-8859-1">=0D=0A<META content=3D"MSHTML 6.00.2900.3354" name=3DGENERATOR>=
</HEAD>=0D=0A<BODY>=0D=0A<DIV><SPAN class=3D827301916-22072008><FONT face=3D=
Arial size=3D2>FWIW, I have the=20=0D=0Asame issue under an HP EVA8000.&nbs=
p; I'm not really certain if directio is a=20=0D=0Asolution as I have only =
seen the tur checker being used with an=20=0D=0AEVA.</FONT></SPAN></DIV>=0D=
=0A<DIV><SPAN class=3D827301916-22072008><FONT face=3DArial=20=0D=0Asize=3D=
2></FONT></SPAN>&nbsp;</DIV>=0D=0A<DIV><SPAN class=3D827301916-22072008><FO=
NT face=3DArial=20=0D=0Asize=3D2>Daniel</FONT></SPAN></DIV>=0D=0A<DIV><SPAN=
 class=3D827301916-22072008><FONT face=3DArial=20=0D=0Asize=3D2></FONT></SP=
AN>&nbsp;</DIV>=0D=0A<DIV><SPAN class=3D827301916-22072008><FONT face=3DAri=
al=20=0D=0Asize=3D2></FONT></SPAN>&nbsp;</DIV>=0D=0A<DIV><SPAN class=3D8273=
01916-22072008><FONT face=3DArial=20=0D=0Asize=3D2>------------------------=
---------------------------------------------------------------------</FONT=
></SPAN></DIV>=0D=0A<DIV><SPAN class=3D827301916-22072008><FONT face=3DAria=
l size=3D2>Date: Tue, 22 Jul=20=0D=0A2008 16:55:27 +0200<BR>From: Hannes Re=
inecke &lt;<A=20=0D=0Ahref=3D"mailto:hare@suse.de">hare@suse.de</A>&gt;<BR>=
Subject: Re: [dm-devel]=20=0D=0ALosing paths<BR>To: device-mapper developme=
nt &lt;<A=20=0D=0Ahref=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</=
A>&gt;<BR>Message-ID:=20=0D=0A&lt;<A=20=0D=0Ahref=3D"mailto:4885F4DF.801000=
0@suse.de">4885F4DF.8010000@suse.de</A>&gt;<BR>Content-Type:=20=0D=0Atext/p=
lain; charset=3DISO-8859-1; format=3Dflowed</FONT></SPAN></DIV>=0D=0A<DIV>&=
nbsp;</DIV>=0D=0A<DIV><SPAN class=3D827301916-22072008><FONT face=3DArial s=
ize=3D2>Hi=20=0D=0AJohn,</FONT></SPAN></DIV>=0D=0A<DIV>&nbsp;</DIV>=0D=0A<D=
IV><SPAN class=3D827301916-22072008><FONT face=3DArial size=3D2>Romanowski,=
 John=20=0D=0A(OFT) wrote:<BR>&gt; Hi,<BR>&gt; We had similar problem last =
year using sles9=20=0D=0Aand SVC 4.2.0.2,&nbsp; as you describe: adding/del=
eting a LUN causes<BR>&gt;=20=0D=0Abrief path failures for the host's remai=
ning, unaffected LUNs.<BR>&gt; <BR>&gt;=20=0D=0AWe were using tur checker a=
nd it turned out that while adding/deleting a LUN=20=0D=0A(and some other a=
dmin tasks)<BR>&gt; the SVC does not respond well to=20=0D=0Atest-unit-read=
y tur requests; but it responds perfectly well to normal=20=0D=0Aread<BR>&g=
t; commands. I opened IBM PMR 43118 on that if you want to ask the SVC=20=0D=
=0Afolks about it.&nbsp; <BR>&gt; <BR>&gt; Workaround for us was to use rea=
dsector0=20=0D=0Ainstead of&nbsp; tur as multipath path checker. <BR>&gt;&n=
bsp; <BR>&gt; Recent=20=0D=0Apost here (see July 8, 2008)&nbsp; said multip=
ath-tools is deprecating=20=0D=0Areadsector0, and to use directio as<BR>&gt=
; path checker, but directio was said=20=0D=0Ato be much slower than tur, i=
mplying tur was better replacement than<BR>&gt;=20=0D=0Adirectio for readse=
ctor0. <BR>&gt;<BR>Only for those cases where no actual=20=0D=0Aread-access=
 is necessary.<BR>&nbsp;<BR>&gt; Not sure what deprecating=20=0D=0Areadsect=
or0 means for us SVC users.&nbsp; <BR>&gt; <BR>It means you should be=20=0D=
=0Ausing directio there.</FONT></SPAN></DIV>=0D=0A<DIV>&nbsp;</DIV>=0D=0A<D=
IV><SPAN class=3D827301916-22072008><FONT face=3DArial size=3D2>Thanks for =
the=20=0D=0Ainformation, I'll see to have it included in SLES10.</FONT></SP=
AN></DIV>=0D=0A<DIV>&nbsp;</DIV>=0D=0A<DIV><SPAN class=3D827301916-22072008=
><FONT face=3DArial=20=0D=0Asize=3D2>Cheers,</FONT></SPAN></DIV>=0D=0A<DIV>=
&nbsp;</DIV>=0D=0A<DIV><SPAN class=3D827301916-22072008><FONT face=3DArial =
size=3D2>Hannes<BR>-- <BR>Dr.=20=0D=0AHannes Reinecke&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; zSeries &amp;=20=0D=0AStorage<BR><A=20=0D=0Ahref=3D"ma=
ilto:hare@suse.de">hare@suse.de</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;=20=0D=0A+49 911 74053 688<BR>SUSE LINUX Products GmbH, Maxfeldstr.=
 5, 90409=20=0D=0AN=FCrnberg<BR>GF: Markus Rex, HRB 16746 (AG=20=0D=0AN=FCr=
nberg)<BR></FONT></SPAN></DIV><br><br><table bgcolor=3Dwhite style=3D"color=
:black"><tr><td><br><br>=0D=0A_____________________________________________=
_________________________<br>=0D=0AThis&nbsp;email&nbsp;transmission&nbsp;a=
nd&nbsp;any&nbsp;documents,&nbsp;files&nbsp;or&nbsp;previous&nbsp;email<br>=0D=
=0Amessages&nbsp;attached&nbsp;to&nbsp;it&nbsp;may&nbsp;contain&nbsp;inform=
ation&nbsp;that&nbsp;is&nbsp;confidential&nbsp;or<br>=0D=0Alegally&nbsp;pri=
vileged.&nbsp;If&nbsp;you&nbsp;are&nbsp;not&nbsp;the&nbsp;intended&nbsp;rec=
ipient&nbsp;or&nbsp;a&nbsp;person<br>=0D=0Aresponsible&nbsp;for&nbsp;delive=
ring&nbsp;this&nbsp;transmission&nbsp;to&nbsp;the&nbsp;intended&nbsp;recipi=
ent,<br>=0D=0Ayou&nbsp;are&nbsp;hereby&nbsp;notified&nbsp;that&nbsp;you&nbs=
p;must&nbsp;not&nbsp;read&nbsp;this&nbsp;transmission&nbsp;and<br>=0D=0Atha=
t&nbsp;any&nbsp;disclosure,&nbsp;copying,&nbsp;printing,&nbsp;distribution&=
nbsp;or&nbsp;use&nbsp;of&nbsp;this<br>=0D=0Atransmission&nbsp;is&nbsp;stric=
tly&nbsp;prohibited.&nbsp;If&nbsp;you&nbsp;have&nbsp;received&nbsp;this&nbs=
p;transmission<br>=0D=0Ain&nbsp;error,&nbsp;please&nbsp;immediately&nbsp;no=
tify&nbsp;the&nbsp;sender&nbsp;by&nbsp;telephone&nbsp;or&nbsp;return&nbsp;e=
mail<br>=0D=0Aand&nbsp;delete&nbsp;the&nbsp;original&nbsp;transmission&nbsp=
;and&nbsp;its&nbsp;attachments&nbsp;without&nbsp;reading<br>=0D=0Aor&nbsp;s=
aving&nbsp;in&nbsp;any&nbsp;manner.<br>=0D=0A</td></tr></table></BODY></HTM=
L>=0D=0A
------_=_NextPart_001_01C8EC17.0E72F690--


--===============1886213281==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1886213281==--
