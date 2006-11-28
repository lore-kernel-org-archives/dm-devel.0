From: "Yarangatta, Asha Ramamurthy (STSD)" <asha.yarangatta@hp.com>
Subject: Logical volumes with persistent minor numbers
Date: Tue, 28 Nov 2006 17:22:00 +0530
Message-ID: <FFE5D42C74BFBE48A79FA506C15E1E7C050BF350@bgeexc04.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1973621169=="
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

--===============1973621169==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C712E3.9D82FC06"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C712E3.9D82FC06
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

Problem: In RHEL 4 U4, the dynamic logical volume device node is not
created with a persistent minor number.

Description:
Initially, no vg is active.  At this  point, the directory /dev/mapper
looked like the following:

#  ll /dev/mapper
total 0
crw-------  1 root root  10, 63 Nov 28 08:57 control

Volume group vg1 is created. Logical volume is created with persistent
minor number (lvcreate  -M y --major 253 --minor 51 -n lvol1 -L 100M
vg1).
This logical volume device node should be created with minor number
"51". But it is created with dynamic minor number.
                   =20
Expected Behavior: ll /dev/mapper should show "brw-------   1 root root
253, 51 22 Nov 28 15:06 vg1-lvol1

Actual Behavior: ll /dev/mapper should show "brw-------   1 root root
253, 0 22 Nov 28 15:06 vg1-lvol1

Please let me know if there is any solution or workaround for this
problem.

Thanks
Asha

------_=_NextPart_001_01C712E3.9D82FC06
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7651.16">
<TITLE>Logical volumes with persistent minor numbers</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Arial">Hi,</FONT>
</P>

<P><B><FONT SIZE=3D2 FACE=3D"Arial">Problem</FONT></B><FONT SIZE=3D2 =
FACE=3D"Arial">: In RHEL 4 U4, the dynamic logical volume device node is =
not created with a persistent minor number.</FONT>
</P>

<P><B><FONT SIZE=3D2 FACE=3D"Arial">Description</FONT></B><FONT SIZE=3D2 =
FACE=3D"Arial">:</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Initially, no vg is active.&nbsp; At =
this&nbsp; point, the directory /dev/mapper looked like the =
following:</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">#&nbsp; ll /dev/mapper</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">total 0</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">crw-------&nbsp; 1 root root&nbsp; 10, =
63 Nov 28 08:57 control</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Volume group vg1 is created. Logical =
volume is created with persistent minor number (lvcreate&nbsp; -M y =
--major 253 --minor 51 -n lvol1 -L 100M vg1).</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">This logical volume device node should =
be created with minor number &quot;51&quot;. But it is created with =
dynamic minor number.</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT>

<BR><B><FONT SIZE=3D2 FACE=3D"Arial">Expected Behavior</FONT></B><FONT =
SIZE=3D2 FACE=3D"Arial">: ll /dev/mapper should show =
&quot;brw-------&nbsp;&nbsp; 1 root root</FONT><B> <FONT SIZE=3D2 =
FACE=3D"Arial">253, 51</FONT></B> <FONT SIZE=3D2 FACE=3D"Arial">22 Nov =
28 15:06 vg1-lvol1</FONT>
</P>

<P><B><FONT SIZE=3D2 FACE=3D"Arial">Actual Behavior</FONT></B><FONT =
SIZE=3D2 FACE=3D"Arial">: ll /dev/mapper should show =
&quot;brw-------&nbsp;&nbsp; 1 root root</FONT><B><FONT SIZE=3D2 =
FACE=3D"Arial"> 253, 0</FONT></B> <FONT SIZE=3D2 FACE=3D"Arial">22 Nov =
28 15:06 vg1-lvol1</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Please let me know if there is any =
solution or workaround for this problem.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Thanks</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Asha</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C712E3.9D82FC06--


--===============1973621169==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1973621169==--
