From: "Herr, Manuel" <mher@msc-ge.com>
Subject: Device Access Question
Date: Thu, 28 Sep 2006 12:02:58 +0200
Message-ID: <C514D40EFDB5C84083DAEB84A1186A8F266AEE@msc-ex02.msc-ge.mscnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0424464116=="
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

--===============0424464116==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C6E2E5.46B012F4"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6E2E5.46B012F4
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Is it correct that if an LUN is seen over 2 Paths,
1 active 1 standby i cannot fdisk the standby device?

#multipath -l
(3600601604032190097fd5fbefd22db11)
[size=3D11 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"1 emc"]
\_ round-robin 0 [active]
 \_ 3:0:0:7 sdi 8:128 [active][ready]
\_ round-robin 0 [enabled]
 \_ 3:0:1:7 sdq 65:0  [active][ready]

#fdisk -l /dev/sdi
Disk /dev/sdi: 11.8 GB, 11811160064 bytes
255 heads, 63 sectors/track, 1435 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdi1               1        1435    11526606   83  Linux

#fdisk -l /dev/sdq
--> creates in /var/log/messages
Sep 28 12:01:22 saptf2 kernel: end_request: I/O error, dev sdq, sector 0
Sep 28 12:01:22 saptf2 kernel: Buffer I/O error on device sdq, logical =
block 0

Regards Manuel Herr

------_=_NextPart_001_01C6E2E5.46B012F4
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7650.28">
<TITLE>Device Access Question</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Arial">Is it correct that if an LUN is seen =
over 2 Paths,</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">1 active 1 standby i cannot fdisk the =
standby device?</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">#multipath -l</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">(3600601604032190097fd5fbefd22db11)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[size=3D11 GB][features=3D&quot;1 =
queue_if_no_path&quot;][hwhandler=3D&quot;1 emc&quot;]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">\_ round-robin 0 [active]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;\_ 3:0:0:7 sdi 8:128 =
[active][ready]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">\_ round-robin 0 [enabled]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;\_ 3:0:1:7 sdq 65:0&nbsp; =
[active][ready]</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">#fdisk -l /dev/sdi</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Disk /dev/sdi: 11.8 GB, 11811160064 =
bytes</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">255 heads, 63 sectors/track, 1435 =
cylinders</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Units =3D cylinders of 16065 * 512 =3D =
8225280 bytes</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp; Device =
Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">/dev/sdi1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1435&nbsp;&nbsp;&nbsp; =
11526606&nbsp;&nbsp; 83&nbsp; Linux</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">#fdisk -l /dev/sdq</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">--&gt; creates in =
/var/log/messages</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Sep 28 12:01:22 saptf2 kernel: =
end_request: I/O error, dev sdq, sector 0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Sep 28 12:01:22 saptf2 kernel: Buffer =
I/O error on device sdq, logical block 0</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Regards Manuel Herr</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C6E2E5.46B012F4--


--===============0424464116==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0424464116==--
