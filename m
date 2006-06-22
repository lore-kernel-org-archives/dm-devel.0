From: "Charlie Sharkey" <charlie.sharkey@bustech.com>
Subject: RE: DM-MP failover with Emulex HBAs
Date: Thu, 22 Jun 2006 08:22:26 -0400
Message-ID: <03FB5D708BE3C8448E8079186A56CDE6815AA7@BTIBURMAIL.bustech.com>
References: <7026BCCA258BA2438F885772CA0B431302BEEC8C@exbtc01.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1869805675=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <7026BCCA258BA2438F885772CA0B431302BEEC8C@exbtc01.hq.netapp.com>
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

--===============1869805675==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C695F6.8650A52E"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C695F6.8650A52E
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I have been wondering about Emulex Parameters also. Here's what I've
come up with so far.
=20
// some info from Emulex
http://www.emulex.com/pdfs/wp_linux2_6.pdf
=20
// some info here, (page 13). HP recommendations
http://h20000.www2.hp.com/bc/docs/support/SupportManual/c00635587/c00635
587.pdf?jumpid=3Dreg_R1002_USEN
=20
=20
=20
=20
________________________________

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of George, Martin
Sent: Tuesday, June 20, 2006 8:17 AM
To: dm-devel@redhat.com
Subject: [dm-devel] DM-MP failover with Emulex HBAs


Hi,
     Just as you had specified low timeout values in the Qlogic HBA for
faster DM-MP failover in
http://www.redhat.com/archives/dm-devel/2005-April/msg00158.html, do you
have anything similar for Emulex HBAs?
=20
=20
Regards,
=20
Martin George
Netapp

------_=_NextPart_001_01C695F6.8650A52E
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2900.2912" name=3DGENERATOR></HEAD>
<BODY>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><SPAN=20
class=3D837511312-22062006>I have been wondering about&nbsp;Emulex=20
Parameters&nbsp;also. Here's what I've come up with so =
far.</SPAN></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff=20
size=3D2></FONT>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><SPAN=20
class=3D837511312-22062006>// some info from Emulex</SPAN></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><A=20
href=3D"http://www.emulex.com/pdfs/wp_linux2_6.pdf">http://www.emulex.com=
/pdfs/wp_linux2_6.pdf</A></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff=20
size=3D2></FONT>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><SPAN=20
class=3D837511312-22062006>// some info here, (page 13). HP=20
recommendations</SPAN></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><A=20
href=3D"http://h20000.www2.hp.com/bc/docs/support/SupportManual/c00635587=
/c00635587.pdf?jumpid=3Dreg_R1002_USEN">http://h20000.www2.hp.com/bc/docs=
/support/SupportManual/c00635587/c00635587.pdf?jumpid=3Dreg_R1002_USEN</A=
></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff=20
size=3D2></FONT>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff=20
size=3D2></FONT>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><SPAN class=3D837511312-22062006><FONT =
face=3DArial=20
color=3D#0000ff size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff=20
size=3D2></FONT>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft>
<HR tabIndex=3D-1>
<FONT face=3DTahoma size=3D2><B>From:</B> dm-devel-bounces@redhat.com=20
[mailto:dm-devel-bounces@redhat.com] <B>On Behalf Of </B>George,=20
Martin<BR><B>Sent:</B> Tuesday, June 20, 2006 8:17 AM<BR><B>To:</B>=20
dm-devel@redhat.com<BR><B>Subject:</B> [dm-devel] DM-MP failover with =
Emulex=20
HBAs<BR></FONT><BR></DIV>
<DIV></DIV>
<DIV><SPAN class=3D138291212-20062006><FONT face=3DArial=20
size=3D2>Hi,</FONT></SPAN></DIV>
<DIV><SPAN class=3D138291212-20062006><FONT face=3DArial=20
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp; Just as you had specified low timeout =
values in=20
the Qlogic HBA for faster DM-MP failover in <A=20
href=3D"http://www.redhat.com/archives/dm-devel/2005-April/msg00158.html"=
>http://www.redhat.com/archives/dm-devel/2005-April/msg00158.html</A>,=20
do you have anything similar for Emulex HBAs?</FONT></SPAN></DIV>
<DIV><SPAN class=3D138291212-20062006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D138291212-20062006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D138291212-20062006><FONT face=3DArial=20
size=3D2>Regards,</FONT></SPAN></DIV>
<DIV><SPAN class=3D138291212-20062006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D138291212-20062006><FONT face=3DArial size=3D2>Martin =

George</FONT></SPAN></DIV>
<DIV><SPAN class=3D138291212-20062006><FONT face=3DArial=20
size=3D2>Netapp</FONT></SPAN></DIV></BODY></HTML>

------_=_NextPart_001_01C695F6.8650A52E--


--===============1869805675==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1869805675==--
