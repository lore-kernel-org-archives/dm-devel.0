From: "Allen, Jack" <Jack.Allen@mckesson.com>
Subject: Changing SAN vendors
Date: Tue, 3 Feb 2009 17:44:57 -0600
Message-ID: <4905EFD192EEDF4A9A19EEE98C32B7F70EFB4A29@DBQV3005.na.corp.mckesson.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0122264696=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

--===============0122264696==
Content-class: urn:content-classes:message
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C98659.6C28B66D"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C98659.6C28B66D
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello:=20
        Our IT group has decided to switch SAN Vendors. The switch over
for a couple of systems has gone fine, but I have some questions on =
some
things that have changed.

        First a little information on how the switch over is taking
place. The old SAN is a EMC CX and the new SAN is a HP XP. The system =
is
connected to a SAN switch which is then connected to both SANs. We shut
down the system, and then rezone the switch/SAN to access the XP now
instead of the CX. The XP passes through all the I/O request to the CX.
When we know the data can be seen correctly, they do some commands that
copies the data from the CX to the XP and then the I/O takes place on
the XP from that point on. All this works fine.

        When only connected to the CX, I had /dev/mapper/mpath1 and
/dev/mapper/mpath2. After the reboot and rezoning /dev/mapper/mpath1 =
and
/dev/mapper/mpath2 are gone and /dev/mapper/mpath3 and
/dev/mapper/mpath4 are there. LVM finds the Volume Group and all =
Logical
Volumes with no problem.

        My question is what do I have to change in some configuration
file or what ever to make /dev/mapper/mpath1 and /dev/mapper/mpath2 be
in place instead of /dev/mapper/mpath3 and /dev/mapper/mpath4?

        I know this is not creating any real problem, but it is kind of
misleading, because it looks like 2 paths are missing.

-----=20
Thanks=20
Jack Allen=20


------_=_NextPart_001_01C98659.6C28B66D
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>

<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7652.24">
<TITLE>Changing SAN vendors</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Arial">Hello:</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">Our IT group has decided to switch SAN Vendors. The =
switch over for a couple of systems has gone fine, but I have some =
questions on some things that have changed.</FONT></P>

<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">First a little information on how the switch over is =
taking place. The old SAN is a EMC CX and the new SAN is a HP XP. The =
system is connected to a SAN switch which is then connected to both =
SANs. We shut down the system, and then rezone the switch/SAN to access =
the XP now instead of the CX. The XP passes through all the I/O request =
to the CX. When we know the data can be seen correctly, they do some =
commands that copies the data from the CX to the XP and then the I/O =
takes place on the XP from that point on. All this works =
fine.</FONT></P>

<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">When only connected to the CX, I had /dev/mapper/mpath1 =
and /dev/mapper/mpath2. After the reboot and rezoning =
/dev/mapper/mpath1 and /dev/mapper/mpath2 are gone and =
/dev/mapper/mpath3 and /dev/mapper/mpath4 are there. LVM finds the =
Volume Group and all Logical Volumes with no problem.</FONT></P>

<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">My question is what do I have to change in some =
configuration file or what ever to make /dev/mapper/mpath1 and =
/dev/mapper/mpath2 be in place instead of /dev/mapper/mpath3 and =
/dev/mapper/mpath4?</FONT></P>

<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">I know this is not creating any real problem, but it is =
kind of misleading, because it looks like 2 paths are =
missing.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">-----</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Thanks</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Jack Allen</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C98659.6C28B66D--


--===============0122264696==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0122264696==--
