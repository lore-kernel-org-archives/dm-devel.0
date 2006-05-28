From: "John Vaughan" <jvaughan@dataroad.com>
Subject: Multipath and LVM2 with hsg80
Date: Sun, 28 May 2006 18:44:42 -0400
Message-ID: <2E9EB7DC6BB8164485F079DC23A61C2A632040@SRV08.dataroad.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1179510935=="
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

--===============1179510935==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C682A8.4FDC7702"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C682A8.4FDC7702
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

=20
=20
Folks,
=20
I have an hsg80 controller that I am trying to get to work with Redhat
ES 4 update 3.
=20
I want to multipath and put LVM2 on top of the dm-# devices.
=20
First,  Does this work and has it been tested?
=20
Second,  Do I need to add the hp_sw handler to this release or is in
there already?
=20
Third,  How do I get this to all work cleanly on boot?
=20
=20
I am asking  because I have not been able to get the correct
combination. And Redhat support has not been much help.
=20
Thanks for the help
=20
=20

------_=_NextPart_001_01C682A8.4FDC7702
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2900.2873" name=3DGENERATOR></HEAD>
<BODY>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff=20
size=3D2></FONT>&nbsp;</DIV>
<DIV class=3DOutlookMessageHeader lang=3Den-us dir=3Dltr =
align=3Dleft>&nbsp;</DIV>
<DIV></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D603592922-28052006>Folks,</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D603592922-28052006></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D603592922-28052006>I have =
an hsg80=20
controller that I am trying to get to work with Redhat ES 4 update=20
3.</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D603592922-28052006></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D603592922-28052006>I want =
to multipath=20
and put LVM2 on top of the dm-# devices.</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D603592922-28052006></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN =
class=3D603592922-28052006>First,&nbsp; Does=20
this work and has it been tested?</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D603592922-28052006></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN =
class=3D603592922-28052006>Second,&nbsp; Do I=20
need to add the hp_sw handler to this release or is in there=20
already?</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D603592922-28052006></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN =
class=3D603592922-28052006>Third,&nbsp; How do=20
I get this to all work cleanly on boot?</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D603592922-28052006></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D603592922-28052006></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D603592922-28052006>I am =
asking&nbsp;=20
because I have not been able to get the correct combination. And Redhat =
support=20
has not been much help.</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D603592922-28052006></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D603592922-28052006>Thanks =
for the=20
help</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D603592922-28052006></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D603592922-28052006></SPAN></FONT>&nbsp;</DIV></BODY></HTML>

------_=_NextPart_001_01C682A8.4FDC7702--


--===============1179510935==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1179510935==--
