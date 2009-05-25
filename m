From: "Harikrishnan Padidakul" <hpadidakul@inmage.net>
Subject: RE: "multipath -l" not displaying all the paths if we
	have more than 3000 paths.
Date: Mon, 25 May 2009 04:06:01 -0700
Message-ID: <4F2CC79CDB05B844AEEA72F36255835403FD4ED7@bunker.inside.abhaisystems.com>
References: <4F2CC79CDB05B844AEEA72F36255835403FD4ED5@bunker.inside.abhaisystems.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2027010973=="
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

--===============2027010973==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C9DD28.F8FEEDDC"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9DD28.F8FEEDDC
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi All,=20
=20
Could please look into this.
=20
Thanks,
Hari

________________________________

From: Harikrishnan Padidakul
Sent: Fri 5/22/2009 12:08 PM
To: dm-devel@redhat.com; christophe.varoqui@free.fr
Subject: "multipath -l" not displaying all the paths if we have more =
than 3000 paths.


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

------_=_NextPart_001_01C9DD28.F8FEEDDC
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML dir=3Dltr><HEAD>=0A=
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dunicode">=0A=
<META content=3D"MSHTML 6.00.6000.16825" name=3DGENERATOR></HEAD>=0A=
<BODY>=0A=
<DIV id=3DidOWAReplyText20216 dir=3Dltr>=0A=
<DIV dir=3Dltr><FONT face=3DArial color=3D#000000 size=3D2>Hi All, =
</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>Could please look into =
this.</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>Thanks,</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>Hari</FONT></DIV></DIV>=0A=
<DIV dir=3Dltr><BR>=0A=
<HR tabIndex=3D-1>=0A=
<FONT face=3DTahoma size=3D2><B>From:</B> Harikrishnan =
Padidakul<BR><B>Sent:</B> Fri 5/22/2009 12:08 PM<BR><B>To:</B> =
dm-devel@redhat.com; christophe.varoqui@free.fr<BR><B>Subject:</B> =
"multipath -l" not displaying all the paths if we have more than 3000 =
paths.<BR></FONT><BR></DIV>=0A=
<DIV dir=3Dltr>=0A=
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
advance.<BR><BR>Regards,<BR>Hari</FONT></FONT></DIV></DIV></BODY></HTML>
------_=_NextPart_001_01C9DD28.F8FEEDDC--


--===============2027010973==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2027010973==--
