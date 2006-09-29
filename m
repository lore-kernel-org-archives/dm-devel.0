From: Edward Goggin <egoggin@emc.com>
Subject: RE: Device Access Question
Date: Fri, 29 Sep 2006 11:49:28 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D13FF@CORPUSMX40A.corp.emc.com>
References: <C514D40EFDB5C84083DAEB84A1186A8F266AEE@msc-ex02.msc-ge.mscnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0226091713=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <C514D40EFDB5C84083DAEB84A1186A8F266AEE@msc-ex02.msc-ge.mscnet>
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

--===============0226091713==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C6E3DE.D8DF8BE1"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6E3DE.D8DF8BE1
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I suggest you use the dm-multipath mapped device names instead of the
target device ones.  Otherwise, you can run into problems caused by the
fact that the cached partition table for each of the possibly multiple
target paths are not kept in synch with the partition table of the
multipath mapped device.
=20
In this case, fdisk is failing because it attempts to read the partition
table (MBR block 0) of the disk and /dev/sdq is the passive path to the
disk.  This is correct behavior for Linux dm-multipath since it does not
attempt to provide multipathing for accesses to the target device paths,
e.g., /dev/sdq.
=20
Also, be careful because this behavior can be intermittent since this
operation would have succeeded if this logical block was resident in the
page cache, which could happen if /dev/sdq was an active path to the
logical unit just a little while beforehand.


________________________________

	From: dm-devel-bounces@redhat.com
[mailto:dm-devel-bounces@redhat.com] On Behalf Of Herr, Manuel
	Sent: Thursday, September 28, 2006 6:03 AM
	To: dm-devel@redhat.com
	Subject: [dm-devel] Device Access Question
=09
=09

	Is it correct that if an LUN is seen over 2 Paths,=20
	1 active 1 standby i cannot fdisk the standby device?=20
=09

	#multipath -l=20
	(3600601604032190097fd5fbefd22db11)=20
	[size=3D11 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"1 emc"]=20
	\_ round-robin 0 [active]=20
	 \_ 3:0:0:7 sdi 8:128 [active][ready]=20
	\_ round-robin 0 [enabled]=20
	 \_ 3:0:1:7 sdq 65:0  [active][ready]=20

	#fdisk -l /dev/sdi=20
	Disk /dev/sdi: 11.8 GB, 11811160064 bytes=20
	255 heads, 63 sectors/track, 1435 cylinders=20
	Units =3D cylinders of 16065 * 512 =3D 8225280 bytes=20

	   Device Boot      Start         End      Blocks   Id  System=20
	/dev/sdi1               1        1435    11526606   83  Linux=20

	#fdisk -l /dev/sdq=20
	--> creates in /var/log/messages=20
	Sep 28 12:01:22 saptf2 kernel: end_request: I/O error, dev sdq,
sector 0=20
	Sep 28 12:01:22 saptf2 kernel: Buffer I/O error on device sdq,
logical block 0=20

	Regards Manuel Herr=20


------_=_NextPart_001_01C6E3DE.D8DF8BE1
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>Device Access Question</TITLE>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2800.1561" name=3DGENERATOR></HEAD>
<BODY>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><SPAN=20
class=3D807473315-29092006><FONT face=3DArial color=3D#0000ff size=3D2>I =
suggest you use=20
the dm-multipath mapped device names instead of the target device =
ones.&nbsp;=20
Otherwise, you can run into problems caused by the fact that =
the&nbsp;cached=20
partition table for each of the possibly multiple target paths are not =
kept=20
in&nbsp;synch with the partition table of the multipath mapped=20
device.</FONT></SPAN></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><SPAN=20
class=3D807473315-29092006><FONT face=3DArial color=3D#0000ff=20
size=3D2></FONT></SPAN></FONT>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><SPAN=20
class=3D807473315-29092006><FONT face=3DArial color=3D#0000ff =
size=3D2>In this case,=20
fdisk is failing because it attempts to read the partition table (MBR =
block 0)=20
of the disk and /dev/sdq is the passive path to the disk.&nbsp; This is =
correct=20
behavior for Linux&nbsp;dm-multipath since it does not attempt to =
provide=20
multipathing for accesses to the target device paths, e.g.,=20
/dev/sdq.</FONT></SPAN></FONT></DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><SPAN=20
class=3D807473315-29092006></SPAN></FONT>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><FONT face=3DArial color=3D#0000ff =
size=3D2><SPAN=20
class=3D807473315-29092006></SPAN><SPAN class=3D807473315-29092006><FONT =
face=3DArial=20
color=3D#0000ff size=3D2>Also, be careful because this behavior can be =
intermittent=20
since this operation would have succeeded if this logical block was =
resident in=20
the page cache, which could happen if /dev/sdq was an active path to the =
logical=20
unit just a little while beforehand.</FONT></SPAN></FONT><BR></DIV>
<BLOCKQUOTE dir=3Dltr=20
style=3D"PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: #0000ff 2px =
solid; MARGIN-RIGHT: 0px">
  <DIV class=3DOutlookMessageHeader lang=3Den-us dir=3Dltr align=3Dleft>
  <HR tabIndex=3D-1>
  <FONT face=3DTahoma size=3D2><B>From:</B> dm-devel-bounces@redhat.com=20
  [mailto:dm-devel-bounces@redhat.com] <B>On Behalf Of </B>Herr,=20
  Manuel<BR><B>Sent:</B> Thursday, September 28, 2006 6:03 =
AM<BR><B>To:</B>=20
  dm-devel@redhat.com<BR><B>Subject:</B> [dm-devel] Device Access=20
  Question<BR></FONT><BR></DIV>
  <DIV></DIV><!-- Converted from text/rtf format -->
  <P><FONT face=3DArial size=3D2>Is it correct that if an LUN is seen =
over 2=20
  Paths,</FONT> <BR><FONT face=3DArial size=3D2>1 active 1 standby i =
cannot fdisk=20
  the standby device?</FONT> <BR></P>
  <P><FONT face=3DArial size=3D2>#multipath -l</FONT> <BR><FONT =
face=3DArial=20
  size=3D2>(3600601604032190097fd5fbefd22db11)</FONT> <BR><FONT =
face=3DArial=20
  size=3D2>[size=3D11 GB][features=3D"1 =
queue_if_no_path"][hwhandler=3D"1 emc"]</FONT>=20
  <BR><FONT face=3DArial size=3D2>\_ round-robin 0 [active]</FONT> =
<BR><FONT=20
  face=3DArial size=3D2>&nbsp;\_ 3:0:0:7 sdi 8:128 =
[active][ready]</FONT> <BR><FONT=20
  face=3DArial size=3D2>\_ round-robin 0 [enabled]</FONT> <BR><FONT =
face=3DArial=20
  size=3D2>&nbsp;\_ 3:0:1:7 sdq 65:0&nbsp; [active][ready]</FONT> </P>
  <P><FONT face=3DArial size=3D2>#fdisk -l /dev/sdi</FONT> <BR><FONT =
face=3DArial=20
  size=3D2>Disk /dev/sdi: 11.8 GB, 11811160064 bytes</FONT> <BR><FONT =
face=3DArial=20
  size=3D2>255 heads, 63 sectors/track, 1435 cylinders</FONT> <BR><FONT =
face=3DArial=20
  size=3D2>Units =3D cylinders of 16065 * 512 =3D 8225280 bytes</FONT> =
</P>
  <P><FONT face=3DArial size=3D2>&nbsp;&nbsp; Device=20
  Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System</FONT>=20
  <BR><FONT face=3DArial=20
  =
size=3D2>/dev/sdi1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1435&nbsp;&nbsp;&nbsp;=20
  11526606&nbsp;&nbsp; 83&nbsp; Linux</FONT> </P>
  <P><FONT face=3DArial size=3D2>#fdisk -l /dev/sdq</FONT> <BR><FONT =
face=3DArial=20
  size=3D2>--&gt; creates in /var/log/messages</FONT> <BR><FONT =
face=3DArial=20
  size=3D2>Sep 28 12:01:22 saptf2 kernel: end_request: I/O error, dev =
sdq, sector=20
  0</FONT> <BR><FONT face=3DArial size=3D2>Sep 28 12:01:22 saptf2 =
kernel: Buffer I/O=20
  error on device sdq, logical block 0</FONT> </P>
  <P><FONT face=3DArial size=3D2>Regards Manuel Herr</FONT>=20
</P></BLOCKQUOTE></BODY></HTML>

------_=_NextPart_001_01C6E3DE.D8DF8BE1--


--===============0226091713==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0226091713==--
