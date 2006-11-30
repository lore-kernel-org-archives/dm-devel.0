From: "Wayne Cass" <WCass@criadvantage.com>
Subject: DM-MP cannot be run on either the root or boot device
Date: Thu, 30 Nov 2006 15:28:12 -0700
Message-ID: <EA4ABA1D3EF49C4993A576069C887B2BCCCF23@mail.corp.criadvantage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0511033846=="
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

--===============0511033846==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C714CE.D2A5818E"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C714CE.D2A5818E
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

DM-MP cannot be run on either the root or boot device
=20
=20
I am booting from a SAN.    Configuration:
=20
LUN 1
        /boot
        /
        /var
        /swap
=20
=20
Question:  Can I just blacklist   "/"  and "/boot" ?
=20
How do you do it?   I am using a HP  xp-1024   SAN.
=20
=20
thanks
=20
=20

------_=_NextPart_001_01C714CE.D2A5818E
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2900.2180" name=3DGENERATOR></HEAD>
<BODY>
<DIV><FONT face=3DArial>DM-MP cannot be run on either the root or boot=20
device</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial size=3D2>I am =
booting from a=20
SAN.&nbsp;&nbsp;&nbsp; Configuration:</FONT></SPAN></DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial size=3D2>LUN=20
1</FONT></SPAN></DIV>
<DIV><SPAN =
class=3D370561422-30112006>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
<FONT face=3DArial size=3D2>/boot</FONT></SPAN></DIV>
<DIV><SPAN =
class=3D370561422-30112006>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
<FONT face=3DArial size=3D2>/</FONT></SPAN></DIV>
<DIV><SPAN =
class=3D370561422-30112006>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
<FONT face=3DArial size=3D2>/var</FONT></SPAN></DIV>
<DIV><SPAN =
class=3D370561422-30112006>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
<FONT face=3DArial size=3D2>/swap</FONT></SPAN></DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial =
size=3D2>Question:&nbsp; Can=20
I just blacklist&nbsp;&nbsp; "/"&nbsp; and "/boot" ?</FONT></SPAN></DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial size=3D2>How do =
you do=20
it?&nbsp;&nbsp; I am using a HP&nbsp; xp-1024&nbsp;&nbsp;=20
SAN.</FONT></SPAN></DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial=20
size=3D2>thanks</FONT></SPAN></DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D370561422-30112006><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV></BODY></HTML>

------_=_NextPart_001_01C714CE.D2A5818E--


--===============0511033846==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0511033846==--
