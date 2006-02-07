From: "Brad Johnson" <bradjohn263@comcast.net>
Subject: Multipath selector policy additions
Date: Tue, 7 Feb 2006 16:10:19 -0600
Message-ID: <00f901c62c33$48a82090$060aa8c0@workshop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1808461140=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============1808461140==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_00F6_01C62C00.FDDE6330"

This is a multi-part message in MIME format.

------=_NextPart_000_00F6_01C62C00.FDDE6330
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I am a software developer that is new to this list. I understand that =
currently round-robin is the only implemented path selector type. I am =
scoping (for a major storage vendor) the effort required to implement =
additional selector types, as well as other work required to function =
properly with their hardware (possibly special device-specific hardware =
handlers, config file changes, etc.). I assume there is a procedure in =
place to allow developers to submit changes such as these to the public =
domain, and hope that eventually they may be included in some future =
distributions.

My questions are:

What is the procedure for submitting kernel patches for the device =
mapper?
Who (or what organization) owns responsibility for the device mapper =
kernel modules?
Who owns responsibility for the user-space multipath pieces?
Is anyone else currently developing additional path selector types?

I am sorry if my newbie questions are naive, but any help to point me in =
the right direction will be greatly appreciated.

Regards,
Brad Johnson

------=_NextPart_000_00F6_01C62C00.FDDE6330
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2900.2802" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>I am a software developer that is new =
to this list.=20
I understand that currently round-robin is the only implemented path =
selector=20
type. I am scoping (for a major storage vendor) the effort required to =
implement=20
additional selector types, as well as other work required to function =
properly=20
with their hardware (possibly special device-specific hardware handlers, =
config=20
file changes, etc.). I assume there is a procedure in place to allow =
developers=20
to submit changes such as these to the public domain, and hope that =
eventually=20
they may be included in some future distributions.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>My questions are:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>What is the procedure for submitting =
kernel=20
patches&nbsp;for the device mapper?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Who (or what organization) owns =
responsibility for=20
the device mapper kernel modules?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Who owns responsibility for the =
user-space=20
multipath pieces?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Is anyone else currently developing =
additional path=20
selector types?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I am sorry if my newbie questions are =
naive, but=20
any help to point me in the right direction will be greatly=20
appreciated.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Regards,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Brad Johnson</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_00F6_01C62C00.FDDE6330--


--===============1808461140==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1808461140==--
