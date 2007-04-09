From: "Paul Tader" <ptader@linuxscope.com>
Subject: New disk under /dev/mapper control??
Date: Mon, 9 Apr 2007 16:29:26 -0500 (CDT)
Message-ID: <44864.131.225.80.2.1176154166.squirrel@mail.linuxscope.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
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

I've added a new, single IDE disk to a system.  I've run though fdisk,
mkfs and then attempted a mount command but mount failed with "already
mounted or /mnt/ busy".  I see that now device-mapper is "claiming" this
disk and newly created partitions and doesn't allow me to mount the
partitions by addressing the /dev/hdb1 device file. In other words,
/dev/mapper files are being automatically created only for this (new)
disk.  Is there a way to have device-mapper relinquish control of this
disk?

I've tried removing and clearing the devices with dmsetup, all to no avai=
l.

Thanks much,
Paul


(device files removed and no paritions present on /dev/hdb):
[root@server ~]# ls -l /dev/mapper/
total 0
crw-------  1 root root 10, 63 Apr  9 12:03 control


(after a reboot a new device appears (for the hdb device?))
[root@server ~]# ls -l /dev/mapper/
total 0
crw-------  1 root root  10, 63 Apr  9 15:04 control
brw-rw----  1 root disk 253,  0 Apr  9 15:04 pdc_bjajcgbifh


(Now fdisk, create a new primary partition, mkfs, and then mount attempte=
d):
[root@server ~]# mount /dev/hdb1 /mnt/
mount: /dev/hdb1 already mounted or /mnt/ busy

(no device for the new partition, yet)
[root@server ~]# ls -l /dev/mapper
total 0
crw-------  1 root root  10, 63 Apr  9 15:04 control
brw-rw----  1 root disk 253,  0 Apr  9 15:04 pdc_bjajcgbifh

(..but after a reboot, a new mapper device is present)
[root@server ~]# ls -l /dev/mapper
total 0
crw-------  1 root root  10, 63 Apr  9 15:54 control
brw-rw----  1 root disk 253,  0 Apr  9 15:54 pdc_bjajcgbifh
brw-rw----  1 root disk 253,  1 Apr  9 15:54 pdc_bjajcgbifh1

(still can't mount using traditional device)
[root@server ~]# mount /dev/hdb1 /mnt/
mount: /dev/hdb1 already mounted or /mnt/ busy

(...but can using the special mapper device)
[root@server ~]# mount /dev/mapper/pdc_bjajcgbifh1 /mnt
[root@server ~]# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
...
/dev/mapper/pdc_bjajcgbifh1
                      23078680     77800  23000880   1% /mnt


-------------------------
Linux 2.6.9-42.0.10.ELsmp #1 SMP Tue Feb 27 12:38:15 EST 2007 x86_64
x86_64 x86_64 GNU/Linux

# rpm -q device-mapper
device-mapper-1.02.07-4.0.RHEL4
device-mapper-1.02.07-4.0.RHEL4

64bit and 32bit RPM's installed.


[root@server ~]# fdisk -l

Disk /dev/hdb: 400.0 GB, 400088457216 bytes
255 heads, 63 sectors/track, 48641 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hdb1               1        2919    23446836   83  Linux

Disk /dev/sda: 120.0 GB, 120033075200 bytes
255 heads, 63 sectors/track, 14593 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        1044     8385898+  83  Linux
/dev/sda2            1045        2088     8385930   82  Linux swap
/dev/sda3            2089        3132     8385930   83  Linux
/dev/sda4            3133       14593    92060482+   5  Extended
/dev/sda5            3133        3654     4192933+  83  Linux
/dev/sda6            3655        4176     4192933+  83  Linux
