From: "Madovsky" <infos@madovsky.org>
Subject: dmraid and intel 631xESB/632xESB raid controller
Date: Thu, 14 Feb 2013 00:59:04 -0500
Message-ID: <075C1BC8DACF4F80B80F9AAA4A246348@e1705>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6688329712594933250=="
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
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============6688329712594933250==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_012B_01CE0A4E.7BF34370"

This is a multi-part message in MIME format.

------=_NextPart_000_012B_01CE0A4E.7BF34370
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Hi,

I noticed since kernel 3.6.7 that
my raid 1 partition from onboard raid controller 632xESB
of the S5000PAL intel mobo is not mounted anymore.
it shows 2 distincts hd /dev/sda and /dev/sdb
so it boots linux but starts to crush raid inodes so I have
to go back to kernel 3.6.6 to be ok.

when I type dmraid -a y on kernel 3.6.6 (which works)
I can see strangely
RAID set "ddf1_4c5349202020202080862682000000004711471100001450" already =
active
RAID set "ddf1_4c5349202020202080862682000000004711471100001450" was not =
activated
RAID set "ddf1_4c5349202020202080862682000000004711471100001450p1" =
already active
RAID set "ddf1_4c5349202020202080862682000000004711471100001450p1" was =
not activated

on kernel 3.6.7 I have the same result but the raid partition is not =
mounted.

any idea ?

Thank you very much

Franck




------=_NextPart_000_012B_01CE0A4E.7BF34370
Content-Type: text/html;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META content=3D"text/html; charset=3Dwindows-1252" =
http-equiv=3DContent-Type>
<META name=3DGENERATOR content=3D"MSHTML 8.00.6001.19394">
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT size=3D2>Hi,</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>I noticed since kernel 3.6.7 that</FONT></DIV>
<DIV><FONT size=3D2>my raid 1 partition from onboard raid controller=20
632xESB</FONT></DIV>
<DIV><FONT size=3D2>of the S5000PAL intel mobo is not mounted=20
anymore.</FONT></DIV>
<DIV><FONT size=3D2>it shows 2 distincts hd /dev/sda and =
/dev/sdb</FONT></DIV>
<DIV><FONT size=3D2>so it boots linux but starts to crush raid inodes so =
I=20
have</FONT></DIV>
<DIV><FONT size=3D2>to go back to kernel 3.6.6 to be ok.</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>when I type dmraid -a y on kernel 3.6.6 (which=20
works)</FONT></DIV>
<DIV><FONT size=3D2>I can see strangely</FONT></DIV>
<DIV><FONT size=3D2>RAID set=20
"ddf1_4c5349202020202080862682000000004711471100001450" already =
active<BR>RAID=20
set "ddf1_4c5349202020202080862682000000004711471100001450" was not=20
activated<BR>RAID set =
"ddf1_4c5349202020202080862682000000004711471100001450p1"=20
already active<BR>RAID set=20
"ddf1_4c5349202020202080862682000000004711471100001450p1" was not=20
activated</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>on kernel 3.6.7 I have the same result but the raid =
partition=20
is not mounted.</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>any idea ?</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>Thank you very much</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>Franck</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_012B_01CE0A4E.7BF34370--


--===============6688329712594933250==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6688329712594933250==--
