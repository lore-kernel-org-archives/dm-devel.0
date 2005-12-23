From: "=?GB2312?B?y++/oc6w?=" <sunjw@onewaveinc.com>
Subject: re: dm-multipath: kernel paniced when I pull out one HBA
	card
Date: Fri, 23 Dec 2005 11:04:13 +0800
Message-ID: <SERVERgGhPdRPC8aITM000085f0@mail.onewaveinc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
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
To: dm-devel <dm-devel@redhat.com>, "christophe.varoqui" <christophe.varoqui@free.fr>, bwong <bwong@pillardata.com>
List-Id: dm-devel.ids

Hi,all

>looks like a failure in sysfs support code in the scsi module.  might be=
 worth posting to the LKML.
But after I use dmsetup to remove the dm device, and "rmmod" the kernel m=
odule "dm_round_robin" and "dm_multipath"=A3=AC
the kernel works fine as I pull out one HBA card for about 1 minutes and =
plug in it again. the messages are:

Dec 23 18:26:30 nd03 kernel: qla2300 0000:07:01.1: LOOP DOWN detected (2)=
.
Dec 23 18:27:05 nd03 kernel:  rport-1:0-1: blocked FC remote port time ou=
t: removing target
Dec 23 18:27:05 nd03 kernel: Synchronizing SCSI cache for disk sdb:
Dec 23 18:27:05 nd03 kernel: FAILED
Dec 23 18:27:05 nd03 kernel:   status =3D 0, message =3D 00, host =3D 1, =
driver =3D 00
Dec 23 18:27:05 nd03 udev[3991]: udev_db.c: unable to read db file '/dev/=
.udevdb/block@sdb@sdb1'
Dec 23 18:27:05 nd03 udev[3991]: udev_remove.c: 'sdb1' not found in datab=
ase, falling back on default name
Dec 23 18:27:05 nd03 udev[3991]: udev_remove.c: removing device node '/de=
v/sdb1'
Dec 23 18:27:05 nd03 udev[3989]: udev_db.c: unable to read db file '/dev/=
.udevdb/class@scsi_generic@sg1'
Dec 23 18:27:05 nd03 udev[3989]: udev_remove.c: 'sg1' not found in databa=
se, falling back on default name
Dec 23 18:27:05 nd03 udev[3989]: udev_remove.c: removing device node '/de=
v/sg1'
Dec 23 18:27:05 nd03 udev[4026]: udev_db.c: unable to read db file '/dev/=
.udevdb/block@sdb'
Dec 23 18:27:05 nd03 udev[4026]: udev_remove.c: 'sdb' not found in databa=
se, falling back on default name
Dec 23 18:27:05 nd03 udev[4026]: udev_remove.c: removing device node '/de=
v/sdb'
Dec 23 18:27:49 nd03 kernel:   <6>qla2300 0000:07:01.1: LIP reset occured=
 (f8f7).
Dec 23 18:27:51 nd03 kernel: qla2300 0000:07:01.1: LIP occured (f8f7).
Dec 23 18:27:51 nd03 kernel: qla2300 0000:07:01.1: LOOP UP detected (2 Gb=
ps).
Dec 23 18:27:52 nd03 kernel:   Vendor: TOYOU     Model: NetStor DA9220F  =
 Rev: 342R
Dec 23 18:27:52 nd03 kernel:   Type:   Direct-Access                     =
 ANSI SCSI revision: 03
Dec 23 18:27:52 nd03 kernel: SCSI device sdb: 999950336 512-byte hdwr sec=
tors (511975 MB)
Dec 23 18:27:52 nd03 kernel: SCSI device sdb: drive cache: write back
Dec 23 18:27:52 nd03 kernel: SCSI device sdb: 999950336 512-byte hdwr sec=
tors (511975 MB)
Dec 23 18:27:52 nd03 kernel: SCSI device sdb: drive cache: write back
Dec 23 18:27:52 nd03 kernel:  sdb: sdb1
Dec 23 18:27:52 nd03 kernel: Attached scsi disk sdb at scsi1, channel 0, =
id 0, lun 0
Dec 23 18:27:52 nd03 kernel: Attached scsi generic sg1 at scsi1, channel =
0, id 0, lun 0,  type 0
Dec 23 18:27:52 nd03 scsi.agent[4049]: disk at /devices/pci0000:00/0000:0=
0:02.0/0000:05:1d.0/0000:07:01.1/host1/rport-1:0-1/t
arget1:0:0/1:0:0:0
Dec 23 18:27:52 nd03 udev[4059]: udev_rules.c: no rule found, use kernel =
name 'sdb'
Dec 23 18:27:52 nd03 udev[4059]: udev_add.c: creating device node '/dev/s=
db'
Dec 23 18:27:52 nd03 udev[4060]: udev_rules.c: no rule found, use kernel =
name 'sg1'
Dec 23 18:27:52 nd03 udev[4060]: udev_add.c: creating device node '/dev/s=
g1'
Dec 23 18:27:53 nd03 udev[4082]: udev_rules.c: no rule found, use kernel =
name 'sdb1'
Dec 23 18:27:53 nd03 udev[4082]: udev_add.c: creating device node '/dev/s=
db1'

In summary:
kernel with module dm_multipath loaded:
	When I plug in the HBA card, the kernel finds a new device named "/dev/s=
dc" which is "/dev/sdb" orginally,
	and then kernel painc.

kernel without module dm_multipath loaded:
	When I plug in the HBA card, the kernel finds a new device named as the =
old one "/dev/sdb",
	and all works fine.

What's the matter?  where would be the bug ?

Best regards!
Luckey
