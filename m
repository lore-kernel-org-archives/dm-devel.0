From: "Arumugam, Anburaja (STSD)" <anburaja.arumugam@hp.com>
Subject: RE: [dm-multipath] Issue in Root partition from SAN as
	device-mapper-multipath device
Date: Mon, 10 Jul 2006 21:00:13 +0530
Message-ID: <7EB526165496DF4ABE1A64C5CE0BB59B030571C1@bgeexc01.asiapacific.cpqcorp.net>
References: <1151650097.14739.0.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1151650097.14739.0.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>, dm-multipath@redhat.com, dm-devel@redhat.com
Cc: "P S, Suresh (STSD)" <suresh.pathamadai@hp.com>
List-Id: dm-devel.ids

Hi Christophe and All,

I tried inserting the udevstart in the 'init' script as you have
mentioned and it didn't help.

The latest information what I found when I tried root partition on SAN
is as follows:
Initrd is loaded and when the "multipath -v3" got executed as part of
"init" script in initrd, there is no action happening related to map
creation. To be more specific here, I don't find "set ACT_CREATE: map
does not exists" message as part of "multipath -v3" execution. And hence
there is no multipathed DM device got created.


Following is the "init" script as part of "initrd" I'm using.

#!/bin/nash

mount -t proc /proc /proc
#setquiet
echo Mounted /proc filesystem
echo Mounting sysfs
mount -t sysfs none /sys
echo Creating /dev
mount -o mode=3D0755 -t tmpfs none /dev
mknod /dev/console c 5 1
mknod /dev/null c 1 3
mknod /dev/zero c 1 5
mkdir /dev/pts
mkdir /dev/shm
echo Starting udev  >> /proc/file
/sbin/udevstart
echo -n "/sbin/hotplug" > /proc/sys/kernel/hotplug
echo "Loading scsi_mod.ko module"
insmod /lib/scsi_mod.ko
echo "Loading sd_mod.ko module"
insmod /lib/sd_mod.ko
echo "Loading scsi_transport_fc.ko module"
insmod /lib/scsi_transport_fc.ko
echo "Loading qla2xxx.ko module"
insmod /lib/qla2xxx.ko
echo "Loading qla2300.ko module"
insmod /lib/qla2300.ko
echo "Loading DM Module"
insmod /lib/dm-mod.ko
echo "Loading jbd.ko module"
insmod /lib/jbd.ko
echo "Loading ext3.ko module"
insmod /lib/ext3.ko
echo "Loading DM Multipath Module"
insmod /lib/dm-multipath.ko
echo "Loading dm-zero.ko module"
insmod /lib/dm-zero.ko
/sbin/udevstart
echo "Making device-mapper control node"
mkdmnod
echo "Find device-mapper control node"
find /dev/mapper/ -name control
echo "Execution multipath -v3"
/sbin/multipath -v3
echo "Execution dmsetup"
/sbin/dmsetup ls --target /bin/multipath --exec "/sbin/kpartx -a"
echo "Starting udev"
/sbin/udevstart
echo "Creating root device"
mkrootdev /dev/root
umount /sys
echo "Mounting root filesystem"
mount -o defaults --ro -t ext3 /dev/root /sysroot
mount -t tmpfs --bind /dev /sysroot/dev
echo "Switching to new root"
switchroot /sysroot
umount /initrd/dev


Could someone help me in pointing out what I am missing here.

Thanks in advance,
Anbu.

-----Original Message-----
From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
Sent: Friday, June 30, 2006 12:18 PM
To: Arumugam, Anburaja (STSD)
Subject: Re: [dm-multipath] Issue in Root partition from SAN
asdevice-mapper-multipath device


> echo "Loading jbd.ko module"=20
> insmod /lib/jbd.ko
> echo "Loading ext3.ko module"=20
> insmod /lib/ext3.ko
> /sbin/udevstart
> echo "Loading DM Module"=20
> insmod /lib/dm-mod.ko
> echo "Loading DM Multipath Module"=20
> insmod /lib/dm-multipath.ko
> echo "Execution multipath binary with v0"=20
> /sbin/multipath -v 0
> echo "Execution dmsetup"=20
> /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a"=20

Have you tried inserting a udevstart there ?

> echo Creating root device
> mkrootdev /dev/root
> umount /sys
> echo Mounting root filesystem
> mount -o defaults --ro -t ext3 /dev/root /sysroot mount -t tmpfs=20
> --bind /dev /sysroot/dev echo Switching to new root switchroot=20
> /sysroot umount /initrd/dev

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Arumugam, Anburaja (STSD)
Sent: Thursday, June 29, 2006 9:00 PM
To: dm-devel@redhat.com
Cc: P S, Suresh (STSD)
Subject: RE: [dm-devel] Issue in Root partition from SAN
asdevice-mapper-multipath device


Hi,=20

We are trying to get the root partition in a multipath device from a
SAN, in RHEL 4 U4 Beta. For this we have done the following things:

1. We set up a boot from SAN environment, with 3 partitions(/boot, /,
swap respectively) from a LUN on the SAN.=20
2. Without DM multipath, in GRUB.conf we had the parameter as
root=3D/dev/sda2, and it worked fine as expected=20
3. We want to set the / partition as a DM multipath device, and we
repackaged the initrd with the following as we felt these are required
by DM multipath to work at boot time:

3.1 modules in lib: dm-multipath.ko, multipath.ko, dm-round-robin.ko,
dm-zero.ko, dm-mod.ko=20
3.2 binaries in sbin (all static binaries): dmsetup, multipath, kpartx=20
3.2 config files in etc: multipath.conf, scsi_id.config,
40-multipath.rules=20
4. Our modified  init script in initrd looks as ;=20
.........=20
echo "Loading jbd.ko module"=20
insmod /lib/jbd.ko=20
echo "Loading ext3.ko module"=20
insmod /lib/ext3.ko=20
/sbin/udevstart=20
echo "Loading DM Module"=20
insmod /lib/dm-mod.ko=20
echo "Loading DM Multipath Module"=20
insmod /lib/dm-multipath.ko=20
echo "Execution multipath binary with v0"=20
/sbin/multipath -v 0=20
echo "Execution dmsetup"=20
/sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a"=20
echo Creating root device=20
mkrootdev /dev/root=20
umount /sys=20
echo Mounting root filesystem=20
mount -o defaults --ro -t ext3 /dev/root /sysroot=20
mount -t tmpfs --bind /dev /sysroot/dev=20
echo Switching to new root=20
switchroot /sysroot=20
umount /initrd/dev=20
5. Having the UUID returned by scsi_id for the root Lun is,
3600508b400102be10000100023750000, in GRUB.conf, we changed the
parameter as root=3D/dev/mapper/3600508b400102be10000100023750000p2=20

6. rebooted the host, and it gave the following error.=20
"No devices found"=20
"mount: error  mounting ext3"=20

The reason behind this is as you know, No DM multipath device has been
created under /dev/mapper/ for root partition from the Lun, its unable
to mount the root '/' file system.

Can anyone help us by letting us know that, what are we missing in our
approach to create the DM multipath mapped devices for the root
partition diuring boot?

Thanks for your valuable inputs.=20

Regards,=20
Anbu=20
