From: <Yanqing_Liu@Dell.com>
Subject: lsi rdac device handler issue in non-redundant
	environment
Date: Wed, 2 Jul 2008 14:28:46 -0500
Message-ID: <00FE57DD11E3A94893D5BD54C3358BE884BDED@AUSX3MPC128.aus.amer.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0415389613=="
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
To: sekharan@us.ibm.com, dm-devel@redhat.com
Cc: Jacob_Cherian@Dell.com, Charles_Rose@Dell.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0415389613==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C8DC79.D8809357"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8DC79.D8809357
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable


Hi Chandra,

This is regarding your patch for lsi rdac device handler posted in this
link:

https://www.redhat.com/archives/dm-devel/2008-May/msg00003.html

There is a single controller connection scenario that we may also need
to consider in the rdac device handler as below.

1) The host is only connected to one of the controllers from boot time.
Say, Controller A.

2) The virtual disks mapped to the host are evenly distributed between
the two controllers, say, Controller A owns virtual disk 1 and 3,
Controller B owns virtual disk 2 and 4.

3) The host needs to access the data on VD 2 and VD 4.

In this scenario, the DM-RDAC handler should be able to transfer the
ownership of VD 2 and 4 to Controller A, to access data on these virtual
disks.  It seems the current handler cannot initiate failover operation
in this scenario.=20

Please correct me if I am wrong here.

Thanks,
Yanqing

------_=_NextPart_001_01C8DC79.D8809357
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7653.21">
<TITLE>  lsi rdac device handler issue in non-redundant =
environment</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->
<BR>

<P><FONT SIZE=3D2 FACE=3D"Arial">Hi Chandra,</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">This is regarding your patch for lsi =
rdac device handler posted in this link:</FONT>
</P>

<P><A =
HREF=3D"https://www.redhat.com/archives/dm-devel/2008-May/msg00003.html">=
<U><FONT COLOR=3D"#0000FF" SIZE=3D2 =
FACE=3D"Arial">https://www.redhat.com/archives/dm-devel/2008-May/msg00003=
.html</FONT></U></A>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">There is a single controller connection =
scenario that we may also need to consider in the rdac device handler as =
below.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">1) The host is only connected to one of =
the controllers from boot time. Say, Controller A.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">2) The virtual disks mapped to the host =
are evenly distributed between the two controllers, say, Controller A =
owns virtual disk 1 and 3, Controller B owns virtual disk 2 and =
4.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">3) The host needs to access the data on =
VD 2 and VD 4.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">In this scenario, the DM-RDAC handler =
should be able to transfer the ownership of VD 2 and 4 to Controller A, =
to access data on these virtual disks.&nbsp; It seems the current =
handler cannot initiate failover operation in this scenario. </FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Please correct me if I am wrong =
here.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Thanks,</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Yanqing</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C8DC79.D8809357--


--===============0415389613==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0415389613==--
