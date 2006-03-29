From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: IO error on DM device
Date: Wed, 29 Mar 2006 21:33:03 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA003BB5226@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1297543330=="
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Securelinux <securelinux@hp.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============1297543330==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C6534A.42AA7A42"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6534A.42AA7A42
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

We are seeing an IO error problem on a DM device, when the HBA ports of
another host, seen through the same switch are disabled/enable. We are
not understanding on why the paths are failed when ports on other hosts
are disabled. Please explain.=20
Below is the problem description and steps to reproduce.

Problem     :  I/O Error on DM device on one host when HBA ports of
another host are disabled.
OS distros :  RHEL4.0 U2/U3.

HOW-TO reproduce the problem:

1. Configure 2 storage arrays (A1, A2) and two host (H1, H2) in the same
zone, so that both the hosts can see both the arrays. Create and present
LUNs (L1, L2) from array (A1) to host (H1)

2. Stop the multipathd daemon (for testing purpose on why the IO error
when ports of other hosts are failed). Not stopping it may take long
time to reproduce the problem.

3. Start I/O on DM device representing luns L1 and L2 on host H1. We
used dt tool for IO exercising.

4. Disable host ports of host H2 or any port of array A2 one after the
other (few times) OR disable and enable the same port of the other host
- few times (may be 4-5 times).

5. Application (dt tool) aborts with IO error on host H1.


=3D=3D=3D=3D=3D
 Snippet of sys log output (while doing I/O on /dev/dm-0)


Feb  1 11:47:14 apwtest52 kernel: SCSI error : <2 0 0 1> return code =3D
0x20000           =20
Feb  1 11:47:14 apwtest52 kernel: end_request: I/O error, dev sda,
sector 1584600
Feb  1 11:47:14 apwtest52 kernel: device-mapper: dm-multipath: Failing
path 8:0.     <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dpath =
failed, after disabling/enabling
the H2 host port 1=20
Feb  1 11:47:14 apwtest52 kernel: end_request: I/O error, dev sda,
sector 1584608
Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 1 1> return code =3D
0x20000                =20
Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sdg,
sector 861400=20
Feb  1 11:47:45 apwtest52 kernel: device-mapper: dm-multipath: Failing
path 8:96.   <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dpath =
failed, after disabling/enabling
the H2 host port 2
Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sdg,
sector 861408=20
Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return code =3D
0x20000
Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
sector 452760=20
Feb  1 11:47:45 apwtest52 kernel: device-mapper: dm-multipath: Failing
path 8:64.  <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dpath =
failed after disabling/enabling the
H2 host port 1
Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
sector 452768=20
Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return code =3D
0x20000
Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
sector 453784=20
Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
sector 453792=20
Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return code =3D
0x20000
Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
sector 454808=20
Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
sector 454816
Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return code =3D
0x20000
Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
sector 863960
Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde,
sector 863968=20
Feb  1 11:48:40 apwtest52 kernel: SCSI error : <2 0 1 1> return code =3D
0x20000
Feb  1 11:48:40 apwtest52 kernel: end_request: I/O error, dev sdc,
sector 935384=20
Feb  1 11:48:40 apwtest52 kernel: device-mapper: dm-multipath: Failing
path 8:32.  <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D after =
disabling/enabling  the H2 host
port 2
Feb  1 11:48:40 apwtest52 kernel: end_request: I/O error, dev sdc,
sector 935392=20
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116924    <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DAll path to =
the device /dev/dm-0
failed
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116925
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116926
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116927
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116928
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116929
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116930
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116931
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116932
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116933
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116934
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116935
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116936
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116937
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116938
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116939
Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,
logical block 116940
                        =20
Observations :

      As we do the port failure on the other host, paths of the dm
device is failed and the subsequent port (i.e A2 or H2 ports)
disabling/enabling results into more numbers of path failure and that
leads into all path failure condition, which in turn results into IO
error on RHEL4.0 U2/U3.

     Through the device-mapper debug driver we are finding that the
there is no valid path in __choose_pgpath() and  m->current_pgpath (m is
pointer to struct multipath) is null when it comes to map_io() in
dm-mpath.c.

Another observation is that we are not seeing any IO errors when the
same test is executed on SLES9 SP3/SP4.=20

Please provide some pointers on why we are seeing this behavior or is
this a known thing at this point in time?

Thanks and regards
-Murthy







=20

 =20



------_=_NextPart_001_01C6534A.42AA7A42
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7650.21">
<TITLE>IO error on DM device</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">Hi =
Alasdair,</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">We =
are seeing</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">an IO error problem on a =
DM device, when the</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">HBA</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> <FONT SIZE=3D2 =
FACE=3D"Arial">ports of another host</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">,</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial"> seen through the same =
switch</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> =
<FONT SIZE=3D2 FACE=3D"Arial">are</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> disabled/enable</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">. We are n</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">ot understanding on why the =
paths are failed when ports on other hosts are disabled. Please explain. =
</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">Below =
is the problem description and steps to reproduce.</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><B><FONT SIZE=3D2 =
FACE=3D"Arial">Problem&nbsp;&nbsp;&nbsp;&nbsp; =
:&nbsp;</FONT></B></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">I/O Error on DM =
device</FONT></SPAN><SPAN LANG=3D"en-us"><B><I></I></B></SPAN><SPAN =
LANG=3D"en-us"><B><I><FONT COLOR=3D"#000080" SIZE=3D2 =
FACE=3D"Arial"></FONT></I></B></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">on one host =
when</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT =
SIZE=3D2 FACE=3D"Arial"> HBA ports of</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> <FONT SIZE=3D2 =
FACE=3D"Arial">another</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial"> host</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> are disabled.</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><B><FONT SIZE=3D2 FACE=3D"Arial">OS =
distros :</FONT></B></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">&nbsp; RHEL4.0 =
U2/U3.</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><B><FONT SIZE=3D2 =
FACE=3D"Arial">HOW-TO</FONT></B></SPAN><SPAN =
LANG=3D"en-us"><B></B></SPAN><SPAN LANG=3D"en-us"><B><FONT SIZE=3D2 =
FACE=3D"Arial"> reproduce the problem</FONT></B></SPAN><SPAN =
LANG=3D"en-us"><B></B></SPAN><SPAN LANG=3D"en-us"><B><FONT =
COLOR=3D"#000080" SIZE=3D2 FACE=3D"Arial">:</FONT></B></SPAN><SPAN =
LANG=3D"en-us"><B></B></SPAN><SPAN LANG=3D"en-us"><B></B></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">1. =
Configure</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial"> 2 =
storage</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> =
<FONT SIZE=3D2 FACE=3D"Arial">arrays</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> (</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">A1</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">, A2</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">) and =
two</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> <FONT =
SIZE=3D2 FACE=3D"Arial">host (</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">H1</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">, H2) in</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> the same zone, so that both the hosts can =
see</FONT></SPAN><SPAN LANG=3D"en-us"><B><I></I></B></SPAN><SPAN =
LANG=3D"en-us"><B><I><FONT COLOR=3D"#000080" SIZE=3D2 =
FACE=3D"Arial"></FONT></I></B></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT COLOR=3D"#000080" SIZE=3D2 =
FACE=3D"Arial">both</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial"> the =
arrays.</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT COLOR=3D"#000080" SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">Create and =
p</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT =
SIZE=3D2 FACE=3D"Arial">resent LUNs</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">(L1,</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">L2) from =
array</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial"></FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> <FONT SIZE=3D2 =
FACE=3D"Arial">(A1) to host</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">(H1)</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">2. =
Stop the multipathd daemon</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">(for testing purpose on =
why the</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> =
<FONT SIZE=3D2 FACE=3D"Arial">IO error when ports of other hosts are =
failed)</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">.</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT COLOR=3D"#000080" =
SIZE=3D2 FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">Not stopping it may take =
long time to reproduce the problem.</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">3. =
Start I/O on</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">DM device =
representing</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT COLOR=3D"#000080" SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">luns L1 and =
L2</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> <FONT =
SIZE=3D2 FACE=3D"Arial">on host H1</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">. We used</FONT></SPAN><SPAN =
LANG=3D"en-us"><B></B></SPAN><SPAN LANG=3D"en-us"><B> <FONT SIZE=3D2 =
FACE=3D"Arial">dt tool</FONT></B></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> for IO exercising.</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">4.</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">Disable</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> host ports of host H2 or any port of array =
A2</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT =
SIZE=3D2 FACE=3D"Arial"> one after the other</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> (few times)</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> OR disable and enable</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> <FONT SIZE=3D2 =
FACE=3D"Arial">the same</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial"> port of the other =
host</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> =
<FONT SIZE=3D2 FACE=3D"Arial">&#8211;</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> few times (may be 4-5 times).</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">5. =
Applicatio</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">n (dt =
tool)</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial"> aborts with IO error on =
host H1.</FONT></SPAN></P>
<BR>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">=3D=3D=3D=3D=3D</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us">&nbsp;<FONT SIZE=3D2 FACE=3D"Arial">Snippet =
of</FONT></SPAN><SPAN LANG=3D"en-us"><B></B></SPAN><SPAN =
LANG=3D"en-us"><B><FONT COLOR=3D"#000080" SIZE=3D2 FACE=3D"Arial"> =
s</FONT></B></SPAN><SPAN LANG=3D"en-us"><B></B></SPAN><SPAN =
LANG=3D"en-us"><B><FONT SIZE=3D2 FACE=3D"Arial">ys log =
output</FONT></B></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial"> (while</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> <FONT SIZE=3D2 =
FACE=3D"Arial">d</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">o</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">ing</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial"> I/O on =
/dev/dm-0</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">)</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"></SPAN></P>
<BR>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:14 apwtest52 kernel: SCSI error : &lt;2 =
0 0 1&gt; return code =3D =
0x20000&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:14 apwtest52 kernel: end_request: I/O =
error, dev sda, sector 1584600</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:14 apwtest52 kernel: device-mapper: =
dm-multipath: Failing path 8:0.&nbsp;&nbsp;&nbsp;&nbsp; =
&lt;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dpath failed, =
after disabling/enabling the H2 host port 1 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:14 apwtest52 kernel: end_request: I/O =
error, dev sda, sector 1584608</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: SCSI error : &lt;3 =
0 1 1&gt; return code =3D =
0x20000&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O =
error, dev sdg, sector 861400 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: device-mapper: =
dm-multipath: Failing path 8:96.&nbsp;&nbsp; =
&lt;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dpath failed, =
after disabling/enabling&nbsp; the H2 host port 2</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O =
error, dev sdg, sector 861408 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: SCSI error : &lt;3 =
0 0 1&gt; return code =3D 0x20000</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O =
error, dev sde, sector 452760 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: device-mapper: =
dm-multipath: Failing path 8:64.&nbsp; =
&lt;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dpath failed after =
disabling/enabling the H2 host port 1</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O =
error, dev sde, sector 452768 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: SCSI error : &lt;3 =
0 0 1&gt; return code =3D 0x20000</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O =
error, dev sde, sector 453784 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O =
error, dev sde, sector 453792 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: SCSI error : &lt;3 =
0 0 1&gt; return code =3D 0x20000</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O =
error, dev sde, sector 454808 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O =
error, dev sde, sector 454816</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: SCSI error : &lt;3 =
0 0 1&gt; return code =3D 0x20000</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O =
error, dev sde, sector 863960</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O =
error, dev sde, sector 863968 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: SCSI error : &lt;2 =
0 1 1&gt; return code =3D 0x20000</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: end_request: I/O =
error, dev sdc, sector 935384 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: device-mapper: =
dm-multipath: Failing path 8:32.&nbsp; =
&lt;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D after =
disabling/enabling&nbsp; the H2 host port 2</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: end_request: I/O =
error, dev sdc, sector 935392 </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116924&nbsp;&nbsp;&nbsp; =
&lt;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DAll path to the device /dev/dm-0 =
failed</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116925</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116926</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116927</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116928</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116929</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116930</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116931</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116932</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116933</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116934</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116935</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116936</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116937</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116938</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116939</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error =
on device dm-0, logical block 116940</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; </FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><B><FONT SIZE=3D2 =
FACE=3D"Arial">Observations :</FONT></B></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; As we do the port =
failur</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">e</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> <FONT SIZE=3D2 =
FACE=3D"Arial">on the other host</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">, paths of the dm device is failed and the subsequent =
por</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT =
SIZE=3D2 FACE=3D"Arial">t</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">(i.e A2 or H2 ports) =
disabling/enabling results into more numbers of path failure and that =
leads into all path failure condition</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">, w</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">hich in turn results into =
IO error on RHEL4.0 U2/U3.</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp; Through the device-mapper =
debug</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> =
<FONT SIZE=3D2 FACE=3D"Arial">driver we</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> are finding that the there is no valid path =
in</FONT></SPAN><SPAN LANG=3D"en-us"><B><I></I></B></SPAN><SPAN =
LANG=3D"en-us"><B><I> <FONT SIZE=3D2 =
FACE=3D"Arial">__choose_pgpath()</FONT></I></B></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> and&nbsp;</FONT></SPAN><SPAN =
LANG=3D"en-us"><B><I></I></B></SPAN><SPAN LANG=3D"en-us"><B><I> <FONT =
SIZE=3D2 FACE=3D"Arial">m-&gt;current_pgpath</FONT></I></B></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">(m is pointer to struct =
multipath)</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">is null when it comes to =
map_io() in dm-mpath.c.</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Another observation</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> <FONT SIZE=3D2 =
FACE=3D"Arial">is that we are not seeing any IO errors when =
the</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> <FONT =
SIZE=3D2 FACE=3D"Arial">same</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> test is executed on SLES9 SP3/SP4.</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> </SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Please provide some pointers on why we are seeing =
this</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"> =
<FONT SIZE=3D2 FACE=3D"Arial">behavior</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">or</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial"> is this</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"> <FONT SIZE=3D2 FACE=3D"Arial">a know</FONT></SPAN><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">n</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial"> thing at this point in =
time</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT =
SIZE=3D2 FACE=3D"Arial">?</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><SPAN =
LANG=3D"en-us"></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">Thanks and regards</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">-Murthy</FONT></SPAN></P>
<BR>
<BR>
<BR>
<BR>
<BR>
<BR>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;</FONT></SPAN></P>

<P ALIGN=3DLEFT><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp; </FONT></SPAN></P>
<BR>

</BODY>
</HTML>
------_=_NextPart_001_01C6534A.42AA7A42--


--===============1297543330==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1297543330==--
