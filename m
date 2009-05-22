From: "Harikrishnan Padidakul" <hpadidakul@inmage.net>
Subject: "multipath -l" not displaying all the paths if we have
	more than 3000 paths.
Date: Thu, 21 May 2009 23:38:17 -0700
Message-ID: <4F2CC79CDB05B844AEEA72F36255835403FD4ED5@bunker.inside.abhaisystems.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1976888518=="
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
To: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============1976888518==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C9DAA8.3DA46C87"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9DAA8.3DA46C87
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi All

I downloaded the latest multipath tool from git-clone =
http://kernel.org/pub/scm/linux/storage/multipath-tools/ =
<http://kernel.org/pub/scm/linux/storage/multipath-tools/.git>=20
1) Tested with around 4000 paths(1000LUN exported to four port), and I =
observed multipath -l is not displaying all the paths.
2) And when we fail a path by disabling the port, all the path which are =
failed are not shown in multipath.

Have we tested multipath with more than 3000 paths?

Thanks in advance.

Regards,
Hari

------_=_NextPart_001_01C9DAA8.3DA46C87
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML dir=3Dltr><HEAD>=0A=
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dunicode">=0A=
<META content=3D"MSHTML 6.00.6000.16825" name=3DGENERATOR></HEAD>=0A=
<BODY>=0A=
<DIV><FONT face=3DArial color=3D#000000 size=3D2><FONT face=3D"Times New =
Roman" size=3D3>Hi All<BR><BR>I downloaded the latest multipath =
tool&nbsp;from </FONT><TT><FONT size=3D2>git-clone <A =
href=3D"http://kernel.org/pub/scm/linux/storage/multipath-tools/.git">htt=
p://kernel.org/pub/scm/linux/storage/multipath-tools/</A></TT></FONT><BR>=
<FONT face=3D"Times New Roman" size=3D3>1) Tested with around 4000 =
paths(1000LUN exported to four port), and I observed multipath -l is not =
displaying all the paths.<BR>2) And when we fail a path by disabling the =
port, all the path which are failed are not shown in =
multipath.<BR><BR>Have we tested multipath with more than 3000 =
paths?<BR><BR>Thanks in =
advance.<BR><BR>Regards,<BR>Hari</FONT></FONT></DIV></BODY></HTML>
------_=_NextPart_001_01C9DAA8.3DA46C87--


--===============1976888518==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1976888518==--
