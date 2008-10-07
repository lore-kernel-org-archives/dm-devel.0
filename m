From: <Yanqing_Liu@Dell.com>
Subject: Rdac checker in device unmap/remove situation
Date: Tue, 7 Oct 2008 14:23:28 -0500
Message-ID: <00FE57DD11E3A94893D5BD54C3358BE884BF4E@AUSX3MPC128.aus.amer.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0702833502=="
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
Cc: Jacob_Cherian@Dell.com, mchristi@redhat.com, Shyam_Iyer@Dell.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0702833502==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C928B2.2CF50002"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C928B2.2CF50002
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable


In a test with device unmapping/deletion for rdac device handler, a
problems comes up with rdac checker improperly marking all device path
as active state after device is unmapped from the host.

If a device is unmapped from a storage array to a host,  peripheral
qualifier files in the standard inquiry indicates no connected logical
unit, although command can go through with success status.

TUR command would fail with sense code 0x59100, sense key: illegal
request, additional sense: logical unit not supported.

VPD inquiry such as volume access control inquiry can succeed also, but
it has a peripheral qualifier field to indicate the device is not there.


RDAC checker uses VPD page 0xC9, however it only checks the return
status, which is good even after device is unmapped. That results in
RDAC checker restoring the paths to good state even after device is
unmapped.

So, after a device is unmapped,  >> mode select queue to fail over to
the other controller >> mode select command failed with 0x59100 >> rdac
checker restored the path>> mode select tried again.

All the paths for the unmapped device are shown as "active" instead of
"failed".

We should add a simple check for peripheral qualifier in 0xC9 inquiry
after inquiry result comes back, to determine is the logical unit is not
connected anymore. If the device is either unmapped or deleted, we can
trigger sysfs to remove the device. Or at least, we can mark all paths
as failed or offlined. The changes would be like

If (peripheral qualifier !=3D device not connected && inquiry succeeds)
   report path up
else
   report path down
end if


Thanks,
Yanqing


------_=_NextPart_001_01C928B2.2CF50002
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7653.38">
<TITLE>Rdac checker in device unmap/remove situation</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->
<BR>

<P><FONT SIZE=3D2 FACE=3D"Arial">In a test with device =
unmapping/deletion for rdac device handler, a problems comes up with =
rdac checker improperly marking all device path as active state after =
device is unmapped from the host.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">If a device is unmapped from a storage =
array to a host,&nbsp; peripheral qualifier files in the standard =
inquiry indicates no connected logical unit, although command can go =
through with success status.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">TUR command would fail with sense code =
0x59100, sense key: illegal request, additional sense: logical unit not =
supported.<BR>
</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">VPD inquiry such as volume access =
control inquiry can succeed also, but it has a peripheral qualifier =
field to indicate the device is not there. </FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">RDAC checker uses VPD page 0xC9, =
however it only checks the return status, which is good even after =
device is unmapped. That results in RDAC checker restoring the paths to =
good state even after device is unmapped.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">So, after a device is unmapped,&nbsp; =
&gt;&gt; mode select queue to fail over to the other controller &gt;&gt; =
mode select command failed with 0x59100 &gt;&gt; rdac checker restored =
the path&gt;&gt; mode select tried again.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">All the paths for the unmapped device =
are shown as &quot;active&quot; instead of &quot;failed&quot;.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">We should add a simple check for =
peripheral qualifier in 0xC9 inquiry after inquiry result comes back, to =
determine is the logical unit is not connected anymore. If the device is =
either unmapped or deleted, we can trigger sysfs to remove the device. =
Or at least, we can mark all paths as failed or offlined. The changes =
would be like</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">If (peripheral qualifier !=3D device =
not connected &amp;&amp; inquiry succeeds)</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp; report path up</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">else</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp; report path down</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">end if</FONT>
</P>
<BR>

<P><FONT SIZE=3D2 FACE=3D"Arial">Thanks,</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Yanqing</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C928B2.2CF50002--


--===============0702833502==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0702833502==--
