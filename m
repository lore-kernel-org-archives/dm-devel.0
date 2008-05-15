From: KAIZUKA Hiroyuki <kaizuka@valinux.co.jp>
Subject: Make use of dm-ioband (I/O bandwidth controller) device
	as root device
Date: Fri, 16 May 2008 08:33:40 +0900
Message-ID: <482CC854.6080803@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
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

Hi,

This is how to make use of dm-ioband device as root device. You can
apply I/O bandwidth control to your root partition by this means.

Dm-ioband (http://people.valinux.co.jp/~ryov/dm-ioband/) is an I/O
bandwidth controller implemented as a device-mapper driver, which
gives specified bandwidth to each job running on the same physical
device.

See also http://people.valinux.co.jp/~kaizuka/dm-ioband/iobandctl/
for more information.

================================
I'm sure that you will want to apply I/O bandwidth control to root device.
But It's difficult to mount an ioband device as root device after booting
the kernel. This document describes how to create an ioband device and
mount it as root device in the initrd script.

Prerequisites
  * kernel 2.6.25-mm1 & Fedora 8
    o Verified on kernel 2.6.18-53.1.4.el5xen & CentOS 5.1 too
  * Already possible to boot from LVM as a root device (though LVM is not
    mandatory).
    o Old root device: LVM /dev/VolGroup00/LogVol00
    o New root device: ioband /dev/mapper/ioband-LogVol00

Modifying initrd image
  * Extract initrd
  * mkdir /tmp/initrd
  * cd /tmp/initrd
  * zcat /boot/initrd-2.6.25-mm1.img | cpio -idm
  * Modify init in initrd
    o Insert "insmod dm-ioband.ko"
    o Insert "dmsetup create ioband-LogVol00 --table <parameters>".
    o Modify the root device path which "mkrootdev" specifies.
    o An example is as follows:
      --- tmp_old/init        2008-04-30 09:16:42.000000000 +0900
      +++ tmp/init    2008-04-30 11:37:08.000000000 +0900
      @@ -40,6 +40,8 @@
       hotplug
       echo Creating block device nodes.
       mkblkdevs
      +echo "Loading dm-ioband.ko module"
      +insmod /lib/dm-ioband.ko
       echo Making device-mapper control node
       mkdmnod
       mkblkdevs
      @@ -48,8 +50,10 @@
       echo Activating logical volumes
       lvm vgchange -ay --ignorelockingfailure  VolGroup00
       resume /dev/VolGroup00/LogVol01
      +echo Creating ioband devices
      +dmsetup create ioband-LogVol00 --table "0 15204352 ioband 254:0 /dev/VolGroup00 0 0 none weight 0 :1"
       echo Creating root device.
      -mkrootdev -t ext3 -o defaults,ro /dev/VolGroup00/LogVol00
      +mkrootdev -t ext3 -o defaults,ro /dev/mapper/ioband-LogVol00
       echo Mounting root filesystem.
       mount /sysroot
       echo Setting up other filesystems.
    o "0 15204352 ioband 254:0 /dev/VolGroup00 0 0 none weight 0 :1" means:
      These are fixed values.
        * The first "0": it must be always "0".
        * "ioband": it must be always "ioband".
      The following items should be set properly, because these can't be changed
      later.
        * "15204352": the number of sectors the old root device has. You can
          calculate it by "blockdev --getsize device".
        * "254:0": the device number (major:minor) of the old root device.
        * "/dev/VolGroup00": a VG name (if new root device is a LV) or a physical
          volume name (if new root device is a partition) to which the underlying
          device where new root (ioband) device maps belongs. If you don't set
          this parameter properly, you cannot use "iobandctl" to do bandwidth
          control settings later.
      The following items should be set properly, because these can't be changed
      by "iobandctl". (Though you can change them using "dmsetup".)
        * The second "0": throttle. The recommended value is "0", which means
          to use default value of dm-ioband.
        * The third "0": limit. The recommended value is "0", which means to use
          default value of dm-ioband.
        * The fourth "0": token_base. The recommended value is "0", which means
          to use default value of dm-ioband.
      The following items should be set valid values. It is highly recommended
      to set the following values because you can set these parameters more
      easily and properly by "iobandctl" later.
        * "none": device type.
        * "weight": policy. "weight" is the only value supported at this time.
        * ":1": weight. This is temporary value. You should set this by
          "iobandctl" later.
      Refer to the dm-ioband command reference for more details of these
      parameters.
  * Include "dmsetup" command
    o Copy the "dmsetup" command to /sbin in initrd.
    o Copy library files needed by "dmsetup" to /lib in initrd.
      * You can check what libraries are needed by "ldd `which dmsetup`".
      * There is the "dmsetup.static" command in CentOS 5.1. If you use this
        instead of "dmsetup", library files are not necessary.
  * Include "dm-ioband.ko"
    o Copy "dm-ioband.ko" to /lib in initrd.
  * Create initrd
  * find . | cpio -H newc -o | gzip -9 > /boot/initrd-2.6.25-mm1-ioband.img

Modifying grub
  * Specify the new root device and the new initrd
  * An Example is as follows
    --- grub.conf_old       2008-04-30 14:13:37.000000000 +0900
    +++ grub.conf   2008-04-30 14:13:25.000000000 +0900
    @@ -11,9 +11,9 @@
     timeout=5
     splashimage=(hd0,0)/grub/splash.xpm.gz
     hiddenmenu
    -title Fedora (2.6.25-mm1)
    +title Fedora (2.6.25-mm1-ioband)
            root (hd0,0)
    -       kernel /vmlinuz-2.6.25-mm1 ro root=/dev/VolGroup00/LogVol00 rhgb quiet
    -       initrd /initrd-2.6.25-mm1.img
    +       kernel /vmlinuz-2.6.25-mm1 ro root=/dev/mapper/ioband-LogVol00 rhgb quiet
    +       initrd /initrd-2.6.25-mm1.img

Modifying fstab
  * Modify the block device name of mount point "/"
  * An Example is as follows
    --- fstab_old   2008-04-30 11:42:33.000000000 +0900
    +++ fstab       2008-04-30 11:44:12.000000000 +0900
    @@ -1,4 +1,4 @@
    -/dev/VolGroup00/LogVol00 /                      ext3    defaults        1 1
    +/dev/mapper/ioband-LogVol00 /                   ext3    defaults        1 1
     LABEL=/boot             /boot                   ext3    defaults        1 2
     tmpfs                   /dev/shm                tmpfs   defaults        0 0
     devpts                  /dev/pts                devpts  gid=5,mode=620  0 0

And more
  * Create more ioband devices you need, set weight, create groups and so on
    using "iobandctl" after booting the kernel.
================================

Thanks,
KAIZUKA Hiroyuki
