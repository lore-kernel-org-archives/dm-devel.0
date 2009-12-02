From: Jose Nuno Neto <j.neto@eib.org>
Subject: Too many paths from multipath?
Date: Wed, 02 Dec 2009 16:45:03 +0100
Message-ID: <4B168B7F.6060307@eib.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: quoted-printable
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I'm setting up and testing multipath on a RedHat 5.3,=20
device-mapper-multipath-0.4.7-23.el5
I have 2 HBAs connected to one LUN on a Hitachi Storage. Only two=20
connections have been zoned
And that appears on sys fc_remote_ports information, but on multipath I=20
see 4paths per HBA
I'm a little puzzled with this can you explain why? The Fabric we're=20
using has several switch, could be this the reason?
Any hints on this are welcomed
Thanks
Jose



Info:

systool -c fc_remote_ports -v

Class =3D "fc_remote_ports"

Class Device =3D "0-0"
Class Device path =3D "/sys/class/fc_remote_ports/rport-3:0-0"
dev_loss_tmo =3D "30"
fast_io_fail_tmo =3D "off"
node_name =3D "0x50060e8004f3ca72"
port_id =3D "0x2a1f00"
port_name =3D "0x50060e8004f3ca72"
port_state =3D "Online"
roles =3D "FCP Target"
scsi_target_id =3D "0"
supported_classes =3D "Class 3"
uevent =3D <store method only>

Device =3D "rport-3:0-0"
Device path =3D=20
"/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:00.0/0000:03:0=
0.0/0000:04:02.0/0000:05:00.0/host3/rport-3:0-0"
uevent =3D <store method only>


Class Device =3D "0-0"
Class Device path =3D "/sys/class/fc_remote_ports/rport-5:0-0"
dev_loss_tmo =3D "30"
fast_io_fail_tmo =3D "off"
node_name =3D "0x50060e8004f3ca62"
port_id =3D "0x201f00"
port_name =3D "0x50060e8004f3ca62"
port_state =3D "Online"
roles =3D "FCP Target"
scsi_target_id =3D "0"
supported_classes =3D "Class 3"
uevent =3D <store method only>

Device =3D "rport-5:0-0"
Device path =3D=20
"/sys/devices/pci0000:00/0000:00:04.0/0000:0d:00.0/0000:0e:02.0/0000:0f:0=
0.0/host5/rport-5:0-0"
uevent =3D <store method only>

####################################

multipath -ll
mpath1 (360060e8004f3ca000000f3ca00000066) dm-8 HITACHI,OPEN-V -SU
[size=3D26G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D4][active]
\_ 3:0:0:1 sdk 8:160 [active][ready]
\_ 3:0:0:16385 sdl 8:176 [active][ready]
\_ 3:0:0:32769 sdm 8:192 [active][ready]
\_ 3:0:0:49153 sdo 8:224 [active][ready]
\_ round-robin 0 [prio=3D4][enabled]
\_ 5:0:0:1 sdn 8:208 [active][ready]
\_ 5:0:0:16385 sdp 8:240 [active][ready]
\_ 5:0:0:32769 sdq 65:0 [active][ready]
\_ 5:0:0:49153 sdr 65:16 [active][ready]
mpath0 (360060e8004f3ca000000f3ca0000017d) dm-7 HITACHI,OPEN-V*3 -SU
[size=3D79G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]
\_ round-robin 0 [prio=3D4][active]
\_ 3:0:0:0 sdc 8:32 [active][ready]
\_ 3:0:0:16384 sde 8:64 [active][ready]
\_ 3:0:0:32768 sdg 8:96 [active][ready]
\_ 3:0:0:49152 sdi 8:128 [active][ready]
\_ round-robin 0 [prio=3D4][enabled]
\_ 5:0:0:0 sdd 8:48 [active][ready]
\_ 5:0:0:16384 sdf 8:80 [active][ready]
\_ 5:0:0:32768 sdh 8:112 [active][ready]
\_ 5:0:0:49152 sdj 8:144 [active][ready]


####################################

systool -c fc_host -v host3
Class =3D "fc_host"

Class Device =3D "host3"
Class Device path =3D "/sys/class/fc_host/host3"
fabric_name =3D "0x1000006069909274"
issue_lip =3D <store method only>
node_name =3D "0x2000001b3214cfc7"
port_id =3D "0x2a1100"
port_name =3D "0x2100001b3214cfc7"
port_state =3D "Online"
port_type =3D "NPort (fabric via point-to-point)"
speed =3D "2 Gbit"
supported_classes =3D "Class 3"
symbolic_name =3D "QEM3472 FW:v4.04.05 DVR:v8.02.00.06.05.03-k"
system_hostname =3D ""
tgtid_bind_type =3D "wwpn (World Wide Port Name)"
uevent =3D <store method only>

Device =3D "host3"
Device path =3D=20
"/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:00.0/0000:03:0=
0.0/0000:04:02.0/0000:05:00.0/host3"
ct =3D
els =3D
fw_dump =3D
nvram =3D "ISP "
optrom_ctl =3D <store method only>
optrom =3D
sfp =3D ""
uevent =3D <store method only>
vpd =3D "=C2=82r"
systool -c fc_host -v host5
Class =3D "fc_host"

Class Device =3D "host5"
Class Device path =3D "/sys/class/fc_host/host5"
fabric_name =3D "0x10000060699093ae"
issue_lip =3D <store method only>
node_name =3D "0x2000001b3281eb3f"
port_id =3D "0x201100"
port_name =3D "0x2100001b3281eb3f"
port_state =3D "Online"
port_type =3D "NPort (fabric via point-to-point)"
speed =3D "2 Gbit"
supported_classes =3D "Class 3"
symbolic_name =3D "QEM3472 FW:v4.04.05 DVR:v8.02.00.06.05.03-k"
system_hostname =3D ""
tgtid_bind_type =3D "wwpn (World Wide Port Name)"
uevent =3D <store method only>

Device =3D "host5"
Device path =3D=20
"/sys/devices/pci0000:00/0000:00:04.0/0000:0d:00.0/0000:0e:02.0/0000:0f:0=
0.0/host5"
ct =3D
els =3D
fw_dump =3D
nvram =3D "ISP "
optrom_ctl =3D <store method only>
optrom =3D
sfp =3D ""
uevent =3D <store method only>
vpd =3D "=C2=82r"



--------------------------------------------------------------------

Les informations contenues dans ce message et/ou ses annexes sont=20
reservees a l'attention et a l'utilisation de leur destinataire et peuven=
t etre=20
confidentielles. Si vous n'etes pas destinataire de ce message, vous etes=
=20
informes que vous l'avez recu par erreur et que toute utilisation en est=20
interdite. Dans ce cas, vous etes pries de le detruire et d'en informer l=
a=20
Banque Europeenne d'Investissement.

The information in this message and/or attachments is intended solely for=
=20
the attention and use of the named addressee and may be confidential. If=20
you are not the intended recipient, you are hereby notified that you have=
=20
received this transmittal in error and that any use of it is prohibited. =
In=20
such a case please delete this message and kindly notify the European=20
Investment Bank accordingly.
--------------------------------------------------------------------
=20
