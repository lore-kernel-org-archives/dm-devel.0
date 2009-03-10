From: Javier Barroso <javibarroso@gmail.com>
Subject: Clariion EMC RX300 and "long trespass command will be
	send" message
Date: Tue, 10 Mar 2009 11:41:34 +0100
Message-ID: <81c921f30903100341h59740b3dtedb61960b5e5daf7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0356043167=="
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

--===============0356043167==
Content-Type: multipart/alternative; boundary=000e0cd28e9c1e45ff0464c16508

--000e0cd28e9c1e45ff0464c16508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi list,

We have debian lenny a iscsi + multipath system with a Clariion EMC RX300 as
iscsi server. It is working fine, but from some days ago, it is writting
(continously) on syslog:

[5078349.903410] scsi 6:0:0:0: rejecting I/O to dead device
[5078349.903410] scsi 7:0:0:0: rejecting I/O to dead device
[5078349.903410] device-mapper: multipath emc: long trespass command will be
send
[5078349.903410] device-mapper: multipath emc: honor reservation bit will
not be set (default)
[5078349.947653] device-mapper: table: 254:6: multipath: unknown path
selector type
[5078349.947708] device-mapper: ioctl: error adding target to table

scsi 6:0:0:0 not exist at lsscsi:

# lscsi
[8:0:0:0]    disk    DGC      RAID 5           0324  /dev/sdc
[9:0:0:0]    disk    DGC      RAID 5           0324  /dev/sdd
[10:0:0:0]   disk    DGC      RAID 5           0324  /dev/sda
[11:0:0:0]   disk    DGC      RAID 5           0324  /dev/sdb

multipath is working fine:
# multipath -ll
mpath0 (360060160e5101f0020efc45a01cddd11) dm-6 DGC     ,RAID 5
[size=512G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=2][active]
 \_ 8:0:0:0  sdc 8:32  [active][ready]
 \_ 9:0:0:0  sdd 8:48  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 10:0:0:0 sda 8:0   [active][ready]
 \_ 11:0:0:0 sdb 8:16  [active][ready]

Dispositve 254:6 is mpath0:
# devmap_name 254 6
mpath0

How could can I stop scsi system / multipath from this messages ?

Is there any command who could help us ?

Thank you for any advice
PD: Sorry for my english

--000e0cd28e9c1e45ff0464c16508
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi list,<br><br>We have debian lenny a iscsi + multipath system with a Clar=
iion EMC RX300 as iscsi server. It is working fine, but from some days ago,=
 it is writting (continously) on syslog:<br><br>[5078349.903410] scsi 6:0:0=
:0: rejecting I/O to dead device<br>
[5078349.903410] scsi 7:0:0:0: rejecting I/O to dead device<br>[5078349.903=
410] device-mapper: multipath emc: long trespass command will be send<br>[5=
078349.903410] device-mapper: multipath emc: honor reservation bit will not=
 be set (default)<br>
[5078349.947653] device-mapper: table: 254:6: multipath: unknown path selec=
tor type<br>[5078349.947708] device-mapper: ioctl: error adding target to t=
able<br><br>scsi 6:0:0:0 not exist at lsscsi:<br><br># lscsi<br>[8:0:0:0]=
=A0=A0=A0 disk=A0=A0=A0 DGC=A0=A0=A0=A0=A0 RAID 5=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 0324=A0 /dev/sdc<br>
[9:0:0:0]=A0=A0=A0 disk=A0=A0=A0 DGC=A0=A0=A0=A0=A0 RAID 5=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 0324=A0 /dev/sdd<br>[10:0:0:0]=A0=A0 disk=A0=A0=A0 DGC=A0=
=A0=A0=A0=A0 RAID 5=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0324=A0 /dev/sda<br>[11:0=
:0:0]=A0=A0 disk=A0=A0=A0 DGC=A0=A0=A0=A0=A0 RAID 5=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 0324=A0 /dev/sdb<br><br>multipath is working fine:<br>
# multipath -ll<br>mpath0 (360060160e5101f0020efc45a01cddd11) dm-6 DGC=A0=
=A0=A0=A0 ,RAID 5<br>[size=3D512G][features=3D1 queue_if_no_path][hwhandler=
=3D1 emc]<br>\_ round-robin 0 [prio=3D2][active]<br>=A0\_ 8:0:0:0=A0 sdc 8:=
32=A0 [active][ready]<br>
=A0\_ 9:0:0:0=A0 sdd 8:48=A0 [active][ready]<br>\_ round-robin 0 [prio=3D0]=
[enabled]<br>=A0\_ 10:0:0:0 sda 8:0=A0=A0 [active][ready]<br>=A0\_ 11:0:0:0=
 sdb 8:16=A0 [active][ready]<br><br>Dispositve 254:6 is mpath0:<br># devmap=
_name 254 6<br>
mpath0<br><br>How could can I stop scsi system / multipath from this messag=
es ?<br><br>Is there any command who could help us ?<br><br>Thank you for a=
ny advice<br>PD: Sorry for my english<br>

--000e0cd28e9c1e45ff0464c16508--


--===============0356043167==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0356043167==--
