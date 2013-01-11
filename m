From: Andreas.Bleischwitz@continental-corporation.com
Subject: Priozier for remote port on fibre channel devices
Date: Fri, 11 Jan 2013 08:11:34 +0100
Message-ID: <OF21470796.D356BC7E-ONC1257AF0.0022D29F-C1257AF0.00278317@continental-corporation.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0776464599483393692=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

This is a multipart message in MIME format.
--===============0776464599483393692==
Content-Type: multipart/alternative;
	boundary="=_alternative 00278316C1257AF0_="

This is a multipart message in MIME format.
--=_alternative 00278316C1257AF0_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="ISO-8859-1"

Hello List,

I'm currently facing a problem with a storage virtualization device which=
=20
is located in two different datacenters and shows up as another path to a=
=20
configured SAN-LUN.
The virtualization device is from EMC=B2 and is called V-PLEX.

So I have something like this:

        DC A
Host ---VPLEX-DC A---LUN storage A
  =7C           =7C
..=7C...........=7C...................
  =7C     DC B  =7C
  ------VPLEX-DC B---LUN storage B

The VPLEX device itself is for storage based mirroring and synchronizes=20
write access to storage A to storage B and the other way around.

My problem is, that the virtual LUN I get from the VPLEX does not have any=
=20
prioritization given by dm-multipath and looks like this:

mpath3 (36000144000000010e06d8f12ec30dfef) dm-9 EMC,Invista
=5Bsize=3D5.0G=5D=5Bfeatures=3D1 queue_if_no_path=5D=5Bhwhandler=3D0=5D=5Br=
w=5D
=5C_ round-robin 0 =5Bprio=3D1=5D=5Bactive=5D
 =5C_ 5:0:1:2 sdad 65:208 =5Bactive=5D=5Bready=5D
 =5C_ 5:0:4:2 sdak 66:64  =5Bactive=5D=5Bready=5D
 =5C_ 5:0:5:2 sdap 66:144 =5Bactive=5D=5Bready=5D
 =5C_ 4:0:0:2 sdc  8:32   =5Bactive=5D=5Bready=5D
 =5C_ 4:0:1:2 sdh  8:112  =5Bactive=5D=5Bready=5D
 =5C_ 4:0:4:2 sdo  8:224  =5Bactive=5D=5Bready=5D
 =5C_ 4:0:5:2 sdt  65:48  =5Bactive=5D=5Bready=5D
 =5C_ 5:0:0:2 sdy  65:128 =5Bactive=5D=5Bready=5D

That way, write access is made round-robin and access to the=20
=22remote-devices=22 - device located in the other DC - creating duplicate=
=20
traffic through the
SAN switches as the access has to be routed to the remote VPLEX-B and it=20=

will write to the local VPLEX-A.

I wanted to solve this problem by giving priorities to a path by its=20
remote-port - which is different for each connection to a SAN device.=20
Unfortunately
there currently doesn't exist any priorizer and I have to write one on my=
=20
own.
To make the definition flexible, I would like to have a file with a list=20=

of port-wwns associated with a priority.

For versions shipped with RHEL5 this could be a simple shell script which=
=20
simply looks up the sysfs file structures of a given device. For RHEL6=20
this has to be
a binary library. So writing a binary version will make more sense than=20
maintaining two different solutions.

A P-o-c script I wrote runs fine on RHEL5 - althouh a bit slow - but shows=
=20
the results I wanted to see:

--------- script --------
=23=21 /bin/bash

PRIO_DEF=3D=22/etc/dm-multipath-vplex.conf=22

DEVICE=3D=24=7B1=23/dev/*=7D

=23 find scsi-device address
SCSI_ADDR=3D=22=24(basename =24(readlink /sys/block/=24DEVICE/device/scsi_d=
evice*)=20
)=22
=23 3:0:2:0

=23 remove trailing :0
SCSI_ADDR=3D=24=7BSCSI_ADDR%:*=7D
=23 3:0:2

=23 change x:x:x to x:x-x
SCSI_ADDR=3D=24(echo =22=24SCSI_ADDR=22 =7C sed -e 's/:=5C(=5B0-9=5D=5C)=24=
/-=5C1/' )

=23 get port_name for scsi-remote-port
RPORT=3D=24(cat =22/sys/class/fc_remote_ports/rport-=24SCSI_ADDR/port_name=
=22)

=23 return prio
IGNORECASE=3D1
awk =22/=24RPORT/ =7B print =5C=241 =7D=22  =24PRIO_DEF
------------------------------------------

---------- dm-multipath-vplex.conf --------
=23 VPLEX DC A
1 0x50001442606d8f00
1 0x50001442606d8f01
1 0x50001442606d8f02
1 0x50001442606d8f03
1 0x50001442706d8f00
1 0x50001442706d8f01
1 0x50001442706d8f02
1 0x50001442706d8f03
=23 VPLEX DC B
2 0x5000144260641900
2 0x5000144260641901
2 0x5000144260641902
2 0x5000144260641903
2 0x5000144270641900
2 0x5000144270641901
2 0x5000144270641902
2 0x5000144270641903
--------------------------------------------

Do you think that this solutions is worth including it as rport-prio into=
=20
device mappers source? My C language skills are a bit rusty, but I at=20
least managed to
find out the SCSI-address of a given device and build the sysfs-path to=20
the remote port.
The rest should also be manageable, but I wanted to ask as early a=20
possible to have it included into mainstream and get some feedback on=20
this.


Best regrads,

Andreas Bleischwitz


--=_alternative 00278316C1257AF0_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="ISO-8859-1"

<font size=3D2 face=3D=22DejaVu Sans Mono=22>Hello List,</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>I'm currently facing a pro=
blem
with a storage virtualization device which is located in two different
datacenters and shows up as another path to a configured SAN-LUN.</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>The virtualization device =
is from
EMC=B2 and is called V-PLEX.</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>So I have something like t=
his:</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp; &nbsp; &nbsp; &nbsp=
; DC
A</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>Host ---VPLEX-DC A---LUN s=
torage
A</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp; =7C &nbsp; &nbsp; &=
nbsp;
&nbsp; &nbsp; =7C</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>..=7C...........=7C.......=
............</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp; =7C &nbsp; &nbsp; D=
C B &nbsp;=7C</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp; ------VPLEX-DC B---=
LUN
storage B</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>The VPLEX device itself is=
 for
storage based mirroring and synchronizes write access to storage A to stora=
ge
B and the other way around.</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>My problem is, that the vi=
rtual
LUN I get from the VPLEX does not have any prioritization given by dm-multi=
path
and looks like this:</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>mpath3 (36000144000000010e=
06d8f12ec30dfef)
dm-9 EMC,Invista</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=5Bsize=3D5.0G=5D=5Bfeatur=
es=3D1 queue_if_no_path=5D=5Bhwhandler=3D0=5D=5Brw=5D</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=5C_ round-robin 0 =5Bprio=
=3D1=5D=5Bactive=5D</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp;=5C_ 5:0:1:2 sdad 65=
:208 =5Bactive=5D=5Bready=5D</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp;=5C_ 5:0:4:2 sdak 66=
:64 &nbsp;=5Bactive=5D=5Bready=5D</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp;=5C_ 5:0:5:2 sdap 66=
:144 =5Bactive=5D=5Bready=5D</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp;=5C_ 4:0:0:2 sdc &nb=
sp;8:32
&nbsp; =5Bactive=5D=5Bready=5D</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp;=5C_ 4:0:1:2 sdh &nb=
sp;8:112
&nbsp;=5Bactive=5D=5Bready=5D</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp;=5C_ 4:0:4:2 sdo &nb=
sp;8:224
&nbsp;=5Bactive=5D=5Bready=5D</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp;=5C_ 4:0:5:2 sdt &nb=
sp;65:48
&nbsp;=5Bactive=5D=5Bready=5D</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>&nbsp;=5C_ 5:0:0:2 sdy &nb=
sp;65:128
=5Bactive=5D=5Bready=5D</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>That way, write access is =
made
round-robin and access to the &quot;remote-devices&quot; - device located
in the other DC - creating duplicate traffic through the</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>SAN switches as the access=
 has
to be routed to the remote VPLEX-B and it will write to the local VPLEX-A.<=
/font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>I wanted to solve this pro=
blem
by giving priorities to a path by its remote-port - which is different
for each connection to a SAN device. Unfortunately</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>there currently doesn't ex=
ist
any priorizer and I have to write one on my own.</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>To make the definition fle=
xible,
I would like to have a file with a list of port-wwns associated with a
priority.</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>For versions shipped with =
RHEL5
this could be a simple shell script which simply looks up the sysfs file
structures of a given device. For RHEL6 this has to be</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>a binary library. So writi=
ng a
binary version will make more sense than maintaining two different solution=
s.</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>A P-o-c script I wrote run=
s fine
on RHEL5 - althouh a bit slow - but shows the results I wanted to see:</fon=
t>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>--------- script --------<=
/font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=23=21 /bin/bash</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>PRIO_DEF=3D&quot;/etc/dm-m=
ultipath-vplex.conf&quot;</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>DEVICE=3D=24=7B1=23/dev/*=
=7D</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=23 find scsi-device addre=
ss</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>SCSI_ADDR=3D&quot;=24(base=
name =24(readlink
/sys/block/=24DEVICE/device/scsi_device*) )&quot;</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=23 3:0:2:0</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=23 remove trailing :0</fo=
nt>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>SCSI_ADDR=3D=24=7BSCSI_ADD=
R%:*=7D</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=23 3:0:2</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=23 change x:x:x to x:x-x<=
/font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>SCSI_ADDR=3D=24(echo &quot=
;=24SCSI_ADDR&quot;
=7C sed -e 's/:=5C(=5B0-9=5D=5C)=24/-=5C1/' )</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=23 get port_name for scsi=
-remote-port</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>RPORT=3D=24(cat &quot;/sys=
/class/fc_remote_ports/rport-=24SCSI_ADDR/port_name&quot;)</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=23 return prio</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>IGNORECASE=3D1</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>awk &quot;/=24RPORT/ =7B p=
rint =5C=241
=7D&quot; &nbsp;=24PRIO_DEF</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>--------------------------=
----------------</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>---------- dm-multipath-vp=
lex.conf
--------</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=23 VPLEX DC A</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>1 0x50001442606d8f00</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>1 0x50001442606d8f01</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>1 0x50001442606d8f02</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>1 0x50001442606d8f03</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>1 0x50001442706d8f00</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>1 0x50001442706d8f01</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>1 0x50001442706d8f02</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>1 0x50001442706d8f03</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>=23 VPLEX DC B</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>2 0x5000144260641900</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>2 0x5000144260641901</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>2 0x5000144260641902</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>2 0x5000144260641903</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>2 0x5000144270641900</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>2 0x5000144270641901</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>2 0x5000144270641902</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>2 0x5000144270641903</font=
>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>--------------------------=
------------------</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>Do you think that this sol=
utions
is worth including it as rport-prio into device mappers source? My C langua=
ge
skills are a bit rusty, but I at least managed to</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>find out the SCSI-address =
of a
given device and build the sysfs-path to the remote port.</font>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>The rest should also be ma=
nageable,
but I wanted to ask as early a possible to have it included into mainstream=

and get some feedback on this.</font>
<br>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>Best regrads,</font>
<br>
<br><font size=3D2 face=3D=22DejaVu Sans Mono=22>Andreas Bleischwitz</font>=

<br>
<br>
--=_alternative 00278316C1257AF0_=--


--===============0776464599483393692==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0776464599483393692==--
