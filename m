From: "Gerald Nowitzky" <Nowitzky@igne.de>
Subject: Re: Problem using dm-multipath on first of 2 LUNs on system
Date: Tue, 29 Jan 2008 17:58:48 +0100
Message-ID: <008b01c86298$3c1a3280$0602a8c0@sams>
References: <08F3F42DB42FBF4E87512A3AB4596D4A03F72CBF@HERSHEY.aeo.ae.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0089684763=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0089684763==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0088_01C862A0.991FB2E0"

This is a multi-part message in MIME format.

------=_NextPart_000_0088_01C862A0.991FB2E0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

try and remove dm-0 to dm-4 from the blacklist. The devices in =
/dev/mapper are links to /dev/dm-x
(Gerald)
  ----- Original Message -----=20
  From: LittleJ@AE.com=20
  To: dm-devel@redhat.com=20
  Sent: Tuesday, January 29, 2008 4:42 PM
  Subject: [dm-devel] Problem using dm-multipath on first of 2 LUNs on =
system


  I am attempting to implement dm-multipath on a RHEL4U6 server and I =
have been successful in enabling it on the second of 2 LUNs on the =
server but for whatever reason it will not create the device special =
files in /dev/mapper for the fist LUN.  `multipath -d` shows that it =
identifies the first LUN and wants to create the mpath0 files:

  =20

  [root@svwdcvispay01 etc]# multipath -d

  create: mpath0 (36005076801810085c800000000000194)

  [size=3D12 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]

  \_ round-robin 0 [prio=3D50]

   \_ 1:0:0:0 sda 8:0  [ready]

  \_ round-robin 0 [prio=3D10]

   \_ 1:0:1:0 sdc 8:32 [ready]

  =20

  switchpg: mpath1 (36005076801810085c8000000000001a2)

  [size=3D50 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]

  \_ round-robin 0 [prio=3D50]

   \_ 1:0:1:1 sdd 8:48 [active][ready]

  \_ round-robin 0 [prio=3D10]

   \_ 1:0:0:1 sdb 8:16 [active][ready]

  =20

  [root@svwdcvispay01 etc]#

  =20

  =20

  However `multipath -v3` generates a "set ACT_CREATE: map does not =
exists" error in the mpath0 section:

  =20

  [root@svwdcvispay01 etc]# multipath -v3

  load path identifiers cache

  #

  # all paths in cache :

  #

  36005076801810085c800000000000194  1:0:0:0 sda 8:0   IBM     /2145

  36005076801810085c8000000000001a2  1:0:0:1 sdb 8:16 10 [active] IBM    =
 /2145

  36005076801810085c800000000000194  1:0:1:0 sdc 8:32   IBM     /2145

  36005076801810085c8000000000001a2  1:0:1:1 sdd 8:48 50 [active] IBM    =
 /2145

  dm-0 blacklisted

  dm-1 blacklisted

  dm-2 blacklisted

  dm-3 blacklisted

  dm-4 blacklisted

  md0 blacklisted

  ram0 blacklisted

  ram10 blacklisted

  ram11 blacklisted

  ram12 blacklisted

  ram13 blacklisted

  ram14 blacklisted

  ram15 blacklisted

  ram1 blacklisted

  ram2 blacklisted

  ram3 blacklisted

  ram4 blacklisted

  ram5 blacklisted

  ram6 blacklisted

  ram7 blacklisted

  ram8 blacklisted

  ram9 blacklisted

  =3D=3D=3D=3D=3D path info sda (mask 0x1f) =3D=3D=3D=3D=3D

  bus =3D 1

  dev_t =3D 8:0

  size =3D 25165824

  vendor =3D IBM

  product =3D 2145

  rev =3D 0000

  h:b:t:l =3D 1:0:0:0

  tgt_node_name =3D 0x50050768010010b9

  serial =3D 020060402172XX00

  path checker =3D tur (controler setting)

  state =3D 2

  getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)

  prio =3D 50

  uid =3D 36005076801810085c800000000000194 (cache)

  =3D=3D=3D=3D=3D path info sdb (mask 0x1f) =3D=3D=3D=3D=3D

  bus =3D 1

  dev_t =3D 8:16

  size =3D 104857600

  vendor =3D IBM

  product =3D 2145

  rev =3D 0000

  h:b:t:l =3D 1:0:0:1

  tgt_node_name =3D 0x50050768010010b9

  serial =3D 020060402172XX00

  path checker =3D tur (controler setting)

  state =3D 2

  getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)

  prio =3D 10

  uid =3D 36005076801810085c8000000000001a2 (cache)

  =3D=3D=3D=3D=3D path info sdc (mask 0x1f) =3D=3D=3D=3D=3D

  bus =3D 1

  dev_t =3D 8:32

  size =3D 25165824

  vendor =3D IBM

  product =3D 2145

  rev =3D 0000

  h:b:t:l =3D 1:0:1:0

  tgt_node_name =3D 0x5005076801001082

  serial =3D 020060402172XX00

  path checker =3D tur (controler setting)

  state =3D 2

  getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)

  prio =3D 10

  uid =3D 36005076801810085c800000000000194 (cache)

  =3D=3D=3D=3D=3D path info sdd (mask 0x1f) =3D=3D=3D=3D=3D

  bus =3D 1

  dev_t =3D 8:48

  size =3D 104857600

  vendor =3D IBM

  product =3D 2145

  rev =3D 0000

  h:b:t:l =3D 1:0:1:1

  tgt_node_name =3D 0x5005076801001082

  serial =3D 020060402172XX00

  path checker =3D tur (controler setting)

  state =3D 2

  getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)

  prio =3D 50

  uid =3D 36005076801810085c8000000000001a2 (cache)

  #

  # all paths :

  #

  36005076801810085c800000000000194  1:0:0:0 sda 8:0 50 [ready] IBM     =
/2145

  36005076801810085c8000000000001a2  1:0:0:1 sdb 8:16 10 [active][ready] =
IBM

  36005076801810085c800000000000194  1:0:1:0 sdc 8:32 10 [ready] IBM     =
/2145

  36005076801810085c8000000000001a2  1:0:1:1 sdd 8:48 50 [active][ready] =
IBM

  params =3D 1 queue_if_no_path 0 2 1 round-robin 0 1 1 8:48 1000 =
round-robin 0 1 1 8:16 1000

  status =3D 1 0 0 2 1 A 0 1 0 8:48 A 0 E 0 1 0 8:16 A 0

  Found matching wwid [36005076801810085c800000000000194] in bindings =
file.

  Setting alias to mpath0

  pgpolicy =3D group_by_prio (controler setting)

  selector =3D round-robin 0 (internal default)

  features =3D 1 queue_if_no_path (controler setting)

  hwhandler =3D 0 (controler setting)

  rr_weight =3D 1 (internal default)

  rr_min_io =3D 1000 (config file default)

  no_path_retry =3D NONE (internal default)

  pg_timeout =3D NONE (internal default)

  0 25165824 multipath 1 queue_if_no_path 0 2 1 round-robin 0 1 1 8:0 =
1000 round-robin 0 1 1 8:32 1000

  set ACT_CREATE: map does not exists

  Found matching wwid [36005076801810085c8000000000001a2] in bindings =
file.

  Setting alias to mpath1

  pgpolicy =3D group_by_prio (controler setting)

  selector =3D round-robin 0 (internal default)

  features =3D 1 queue_if_no_path (controler setting)

  hwhandler =3D 0 (controler setting)

  rr_weight =3D 1 (internal default)

  rr_min_io =3D 1000 (config file default)

  no_path_retry =3D NONE (internal default)

  pg_timeout =3D NONE (internal default)

  0 104857600 multipath 1 queue_if_no_path 0 2 1 round-robin 0 1 1 8:48 =
1000 round-robin 0 1 1 8:16 1000

  set ACT_NOTHING: map unchanged

  [root@svwdcvispay01 etc]#

  =20

  =20

  And notice that no /dev/mapper/mpath0 device special files were =
created:

  =20

  [root@svwdcvispay01 etc]# ls -la /dev/mapper

  total 0

  drwxr-xr-x  2 root root     160 Jan 29 09:53 .

  drwxr-xr-x  9 root root    4900 Jan 29 09:51 ..

  crw-------  1 root root  10, 63 Jan 21 16:15 control

  brw-rw----  1 root disk 253,  0 Jan 21 16:15 mpath1

  brw-rw----  1 root disk 253,  1 Jan 21 16:15 mpath1p1

  brw-rw----  1 root disk 253,  2 Jan 21 16:15 mpath1p2

  brw-rw----  1 root disk 253,  3 Jan 21 16:15 mpath1p3

  brw-rw----  1 root disk 253,  4 Jan 21 16:15 mpath1p5

  [root@svwdcvispay01 etc]#

  =20

My /etc/multipath.conf file is basic but I have tried creating an alias =
entry that looks like "multipaths {multipath {wwid   =
36005076801810085c800000000000194 alias os}}" for the first LUN but the =
results are the same, it still won't create any device special files for =
the first LUN.=20

  [root@svwdcvispay01 mapper]# cat /etc/multipath.conf | grep -v "#"

  =20

  defaults {

          user_friendly_names yes

  }

  =20

  [root@svwdcvispay01 mapper]#

  =20

  I have been working this issue for over a week with IBM and RedHat =
tech support and they have been unhelpful.  I need to get this =
functional because the server in question has been unstable using a =
single path to the SAN due to stability issues we have had periodically =
with one of the SAN Volume Controllers.  If additional information is =
needed to troubleshoot this please let me know.

  =20

  Joe little

  littlej@ae.com

  =20



-------------------------------------------------------------------------=
-----


  --
  dm-devel mailing list
  dm-devel@redhat.com
  https://www.redhat.com/mailman/listinfo/dm-devel
------=_NextPart_000_0088_01C862A0.991FB2E0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML xmlns=3D"http://www.w3.org/TR/REC-html40" xmlns:o =3D=20
"urn:schemas-microsoft-com:office:office" xmlns:w =3D=20
"urn:schemas-microsoft-com:office:word"><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2900.2802" name=3DGENERATOR>
<STYLE>@font-face {
	font-family: Verdana;
}
@page Section1 {size: 8.5in 11.0in; margin: 1.0in 1.25in 1.0in 1.25in; }
P.MsoNormal {
	FONT-SIZE: 12pt; MARGIN: 0in 0in 0pt; FONT-FAMILY: "Times New Roman"
}
LI.MsoNormal {
	FONT-SIZE: 12pt; MARGIN: 0in 0in 0pt; FONT-FAMILY: "Times New Roman"
}
DIV.MsoNormal {
	FONT-SIZE: 12pt; MARGIN: 0in 0in 0pt; FONT-FAMILY: "Times New Roman"
}
A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
SPAN.MsoHyperlink {
	COLOR: blue; TEXT-DECORATION: underline
}
A:visited {
	COLOR: purple; TEXT-DECORATION: underline
}
SPAN.MsoHyperlinkFollowed {
	COLOR: purple; TEXT-DECORATION: underline
}
PRE {
	FONT-SIZE: 10pt; MARGIN: 0in 0in 0pt; COLOR: black; FONT-FAMILY: =
"Courier New"
}
SPAN.EmailStyle17 {
	FONT-WEIGHT: normal; COLOR: windowtext; FONT-STYLE: normal; =
FONT-FAMILY: Verdana; TEXT-DECORATION: none; mso-style-type: =
personal-compose
}
DIV.Section1 {
	page: Section1
}
</STYLE>
</HEAD>
<BODY lang=3DEN-US vLink=3Dpurple link=3Dblue bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>try and remove dm-0 to dm-4 from the =
blacklist. The=20
devices in /dev/mapper are links to /dev/dm-x</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>(Gerald)</FONT></DIV>
<BLOCKQUOTE=20
style=3D"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; =
BORDER-LEFT: #000000 2px solid; MARGIN-RIGHT: 0px">
  <DIV style=3D"FONT: 10pt arial">----- Original Message ----- </DIV>
  <DIV=20
  style=3D"BACKGROUND: #e4e4e4; FONT: 10pt arial; font-color: =
black"><B>From:</B>=20
  <A title=3DLittleJ@AE.com =
href=3D"mailto:LittleJ@AE.com">LittleJ@AE.com</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>To:</B> <A =
title=3Ddm-devel@redhat.com=20
  href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Sent:</B> Tuesday, January 29, 2008 =
4:42=20
  PM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> [dm-devel] Problem =
using=20
  dm-multipath on first of 2 LUNs on system</DIV>
  <DIV><BR></DIV>
  <DIV class=3DSection1>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: Verdana">I am attempting to =
implement=20
  dm-multipath on a RHEL4U6 server and I have been successful in =
enabling it on=20
  the second of 2 LUNs on the server but for whatever reason it will not =
create=20
  the device special files in /dev/mapper for the fist LUN.&nbsp; =
`multipath =96d`=20
  shows that it identifies the first LUN and wants to create the mpath0=20
  files:<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">[root@svwdcvispay01 etc]#=20
  multipath -d<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">create: mpath0=20
  (36005076801810085c800000000000194)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">[size=3D12 =
GB][features=3D"1=20
  queue_if_no_path"][hwhandler=3D"0"]<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">\_ round-robin 0 =

  [prio=3D50]<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">&nbsp;\_ 1:0:0:0 =
sda=20
  8:0&nbsp; [ready]<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">\_ round-robin 0 =

  [prio=3D10]<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">&nbsp;\_ 1:0:1:0 =
sdc 8:32=20
  [ready]<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">switchpg: mpath1 =

  (36005076801810085c8000000000001a2)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">[size=3D50 =
GB][features=3D"1=20
  queue_if_no_path"][hwhandler=3D"0"]<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">\_ round-robin 0 =

  [prio=3D50]<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">&nbsp;\_ 1:0:1:1 =
sdd 8:48=20
  [active][ready]<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">\_ round-robin 0 =

  [prio=3D10]<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">&nbsp;\_ 1:0:0:1 =
sdb 8:16=20
  [active][ready]<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">[root@svwdcvispay01=20
  etc]#<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: Verdana">However `multipath =
=96v3`=20
  generates a =93</SPAN></FONT><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: Verdana">set ACT_CREATE: map =
does not=20
  exists=94 error in the mpath0 section:<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">[root@svwdcvispay01 etc]#=20
  multipath -v3<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">load path =
identifiers=20
  cache<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">#<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'"># all paths in =
cache=20
  :<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">#<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">36005076801810085c800000000000194&nbsp;=20
  1:0:0:0 sda 8:0&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;=20
  /2145<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">36005076801810085c8000000000001a2&nbsp;=20
  1:0:0:1 sdb 8:16 10 [active] IBM&nbsp;&nbsp;&nbsp;&nbsp;=20
  /2145<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">36005076801810085c800000000000194&nbsp;=20
  1:0:1:0 sdc 8:32&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;=20
  /2145<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">36005076801810085c8000000000001a2&nbsp;=20
  1:0:1:1 sdd 8:48 50 [active] IBM&nbsp;&nbsp;&nbsp;&nbsp;=20
  /2145<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">dm-0=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">dm-1=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">dm-2=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">dm-3=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">dm-4=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">md0=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram0=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram10=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram11=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram12=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram13=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram14=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram15=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram1=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram2=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram3=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram4=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram5=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram6=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram7=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram8=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">ram9=20
  blacklisted<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">=3D=3D=3D=3D=3D =
path info sda (mask=20
  0x1f) =3D=3D=3D=3D=3D<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">bus =3D=20
  1<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">dev_t =3D=20
  8:0<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">size =3D=20
  25165824<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">vendor =3D=20
  IBM<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">product =3D=20
  2145<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">rev =3D=20
  0000<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">h:b:t:l =3D=20
  1:0:0:0<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">tgt_node_name =
=3D=20
  0x50050768010010b9<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">serial =3D=20
  020060402172XX00<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">path checker =3D =
tur=20
  (controler setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">state =3D=20
  2<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">getprio =3D=20
  /sbin/mpath_prio_alua /dev/%n (controler =
setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">prio =3D=20
  50<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">uid =3D=20
  36005076801810085c800000000000194 (cache)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">=3D=3D=3D=3D=3D =
path info sdb (mask=20
  0x1f) =3D=3D=3D=3D=3D<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">bus =3D=20
  1<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">dev_t =3D=20
  8:16<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">size =3D=20
  104857600<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">vendor =3D=20
  IBM<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">product =3D=20
  2145<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">rev =3D=20
  0000<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">h:b:t:l =3D=20
  1:0:0:1<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">tgt_node_name =
=3D=20
  0x50050768010010b9<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">serial =3D=20
  020060402172XX00<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">path checker =3D =
tur=20
  (controler setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">state =3D=20
  2<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">getprio =3D=20
  /sbin/mpath_prio_alua /dev/%n (controler =
setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">prio =3D=20
  10<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">uid =3D=20
  36005076801810085c8000000000001a2 (cache)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">=3D=3D=3D=3D=3D =
path info sdc (mask=20
  0x1f) =3D=3D=3D=3D=3D<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">bus =3D=20
  1<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">dev_t =3D=20
  8:32<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">size =3D=20
  25165824<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">vendor =3D=20
  IBM<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">product =3D=20
  2145<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">rev =3D=20
  0000<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">h:b:t:l =3D=20
  1:0:1:0<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">tgt_node_name =
=3D=20
  0x5005076801001082<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">serial =3D=20
  020060402172XX00<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">path checker =3D =
tur=20
  (controler setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">state =3D=20
  2<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">getprio =3D=20
  /sbin/mpath_prio_alua /dev/%n (controler =
setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">prio =3D=20
  10<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">uid =3D=20
  36005076801810085c800000000000194 (cache)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">=3D=3D=3D=3D=3D =
path info sdd (mask=20
  0x1f) =3D=3D=3D=3D=3D<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">bus =3D=20
  1<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">dev_t =3D=20
  8:48<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">size =3D=20
  104857600<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">vendor =3D=20
  IBM<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">product =3D=20
  2145<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">rev =3D=20
  0000<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">h:b:t:l =3D=20
  1:0:1:1<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">tgt_node_name =
=3D=20
  0x5005076801001082<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">serial =3D=20
  020060402172XX00<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">path checker =3D =
tur=20
  (controler setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">state =3D=20
  2<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">getprio =3D=20
  /sbin/mpath_prio_alua /dev/%n (controler =
setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">prio =3D=20
  50<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">uid =3D=20
  36005076801810085c8000000000001a2 (cache)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">#<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'"># all paths=20
  :<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">#<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">36005076801810085c800000000000194&nbsp;=20
  1:0:0:0 sda 8:0 50 [ready] IBM&nbsp;&nbsp;&nbsp;&nbsp;=20
  /2145<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">36005076801810085c8000000000001a2&nbsp;=20
  1:0:0:1 sdb 8:16 10 [active][ready] IBM<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">36005076801810085c800000000000194&nbsp;=20
  1:0:1:0 sdc 8:32 10 [ready] IBM&nbsp;&nbsp;&nbsp;&nbsp;=20
  /2145<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">36005076801810085c8000000000001a2&nbsp;=20
  1:0:1:1 sdd 8:48 50 [active][ready] IBM<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">params =3D 1=20
  queue_if_no_path 0 2 1 round-robin 0 1 1 8:48 1000 round-robin 0 1 1 =
8:16=20
  1000<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">status =3D 1 0 0 =
2 1 A 0 1 0=20
  8:48 A 0 E 0 1 0 8:16 A 0<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">Found matching =
wwid=20
  [36005076801810085c800000000000194] in bindings=20
  file.<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">Setting alias to =

  mpath0<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">pgpolicy =3D =
group_by_prio=20
  (controler setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">selector =3D =
round-robin 0=20
  (internal default)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">features =3D 1=20
  queue_if_no_path (controler setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">hwhandler =3D 0 =
(controler=20
  setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">rr_weight =3D 1 =
(internal=20
  default)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">rr_min_io =3D =
1000 (config=20
  file default)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">no_path_retry =
=3D NONE=20
  (internal default)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">pg_timeout =3D =
NONE=20
  (internal default)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">0 25165824 =
multipath 1=20
  queue_if_no_path 0 2 1 round-robin 0 1 1 8:0 1000 round-robin 0 1 1 =
8:32=20
  1000<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">set ACT_CREATE: =
map does=20
  not exists<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">Found matching =
wwid=20
  [36005076801810085c8000000000001a2] in bindings=20
  file.<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">Setting alias to =

  mpath1<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">pgpolicy =3D =
group_by_prio=20
  (controler setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">selector =3D =
round-robin 0=20
  (internal default)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">features =3D 1=20
  queue_if_no_path (controler setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">hwhandler =3D 0 =
(controler=20
  setting)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">rr_weight =3D 1 =
(internal=20
  default)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">rr_min_io =3D =
1000 (config=20
  file default)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">no_path_retry =
=3D NONE=20
  (internal default)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">pg_timeout =3D =
NONE=20
  (internal default)<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">0 104857600 =
multipath 1=20
  queue_if_no_path 0 2 1 round-robin 0 1 1 8:48 1000 round-robin 0 1 1 =
8:16=20
  1000<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">set ACT_NOTHING: =
map=20
  unchanged<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">[root@svwdcvispay01=20
  etc]#<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: Verdana">And notice that no=20
  /dev/mapper/mpath0 device special files were=20
  created:<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">[root@svwdcvispay01 etc]#=20
  ls -la /dev/mapper<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">total=20
  0<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">drwxr-xr-x&nbsp; =
2 root=20
  root&nbsp;&nbsp;&nbsp;&nbsp; 160 Jan 29 09:53 =
.<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">drwxr-xr-x&nbsp; =
9 root=20
  root&nbsp;&nbsp;&nbsp; 4900 Jan 29 09:51 =
..<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">crw-------&nbsp; =
1 root=20
  root&nbsp; 10, 63 Jan 21 16:15 control<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">brw-rw----&nbsp; =
1 root=20
  disk 253,&nbsp; 0 Jan 21 16:15 mpath1<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">brw-rw----&nbsp; =
1 root=20
  disk 253,&nbsp; 1 Jan 21 16:15 mpath1p1<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">brw-rw----&nbsp; =
1 root=20
  disk 253,&nbsp; 2 Jan 21 16:15 mpath1p2<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">brw-rw----&nbsp; =
1 root=20
  disk 253,&nbsp; 3 Jan 21 16:15 mpath1p3<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">brw-rw----&nbsp; =
1 root=20
  disk 253,&nbsp; 4 Jan 21 16:15 mpath1p5<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">[root@svwdcvispay01=20
  etc]#<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P><PRE><FONT face=3DVerdana =
color=3Dblack size=3D2><SPAN style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana">My /etc/multipath.conf file is basic but I have tried creating =
an alias entry that looks like</SPAN></FONT> =93multipaths {multipath =
{wwid&nbsp;&nbsp; 36005076801810085c800000000000194 alias os}}=94<FONT =
face=3DVerdana><SPAN style=3D"FONT-FAMILY: Verdana"> for the first LUN =
but the results are the same, it still won=92t create any device special =
files for the first LUN.</SPAN></FONT><o:p></o:p></PRE>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">[root@svwdcvispay01=20
  mapper]# cat /etc/multipath.conf | grep -v =
"#"<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">defaults=20
  {<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  user_friendly_names yes<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">}<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D"Courier New" size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: 'Courier =
New'">[root@svwdcvispay01=20
  mapper]#<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: Verdana">I have been working =
this issue=20
  for over a week with IBM and RedHat tech support and they have been=20
  unhelpful.&nbsp; I need to get this functional because the server in =
question=20
  has been unstable using a single path to the SAN due to stability =
issues we=20
  have had periodically with one of the SAN Volume Controllers.&nbsp; If =

  additional information is needed to troubleshoot this please let me=20
  know.<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: Verdana">Joe=20
  little<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: Verdana"><A=20
  =
href=3D"mailto:littlej@ae.com">littlej@ae.com</A><o:p></o:p></SPAN></FONT=
></P>
  <P class=3DMsoNormal><FONT face=3DVerdana size=3D2><SPAN=20
  style=3D"FONT-SIZE: 10pt; FONT-FAMILY: =
Verdana"><o:p>&nbsp;</o:p></SPAN></FONT></P></DIV>
  <P>
  <HR>

  <P></P>--<BR>dm-devel mailing=20
  =
list<BR>dm-devel@redhat.com<BR>https://www.redhat.com/mailman/listinfo/dm=
-devel</BLOCKQUOTE></BODY></HTML>

------=_NextPart_000_0088_01C862A0.991FB2E0--


--===============0089684763==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0089684763==--
