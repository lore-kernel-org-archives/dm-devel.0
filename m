From: Joe Harvell <jharvell@dogpad.net>
Subject: LVM2 tools<-->library<-->driver compatibility
Date: Mon, 15 May 2006 14:01:23 -0500
Message-ID: <4468D003.6010703@dogpad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

I am installing Gentoo Linux on my machine and I'm running into LVM
problems.  The installer CD is 2.6 kernel based, but I am installing a
2.4 kernel based system.  Gentoo has an install profile for this to
prevent programs and libraries that have a dependency on 2.6 kernel
headers from being installed when a 2.4 profile is being used.

As part of the install process, I created an LVM2 volume group
containing LVs for /, /usr, /var, /opt, and /home.  I created
filesystems on these LVs and performed the installation no problem.  I
also configured and compiled the kernel, which is a 2.4.32 based kernel
with LVM2 backported into it by the Gentoo developer team.

I created the initrd which is based on an initrd I created myself and
have been using successfully on 2.4 and 2.6 based kernels.  It contains
the LVM tools and libraries, along with disk drivers and the
device-mapper driver.

When I run vgscan, it finds the volume group no problem.  However, when
I run 'vgchange -ay <vgname>', I see three problems.

1.  There are entries in /dev/mapper/<vgname>-<lvname>, but no symlinks
in the form /dev/<vgname>/<lvname> --> /dev/mapper/<vgname>/<lvname>.  I
run 'lvm vgmknodes' and it remedies this.

2. I see five complaints from 'vgchange -ay <vgname>' (one for each LV)
as follows:

on stderr:   device-mapper: table ioctl failed: Invalid argument
on console (from dm-mod driver): device-mapper: one of name or uuid must
be supplied, cmd (12)

I ran vgchange under strace and here is the following snippet:

open("/dev/mapper/control", O_RDWR|O_LARGEFILE) = 9
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
mlockall(MCL_CURRENT|MCL_FUTURE)        = 0
brk(0x8936000)                          = 0x8936000
brk(0x8b1e000)                          = 0x8b1e000
getpriority(PRIO_PROCESS, 0)            = 20
setpriority(PRIO_PROCESS, 0, -18)       = 0
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
ioctl(9, DM_DEV_STATUS, 0x8109958)      = -1 ENXIO (No such device or
address)
stat64("/dev/ide/host0/bus0/target0/lun0/part10", {st_mode=S_IFBLK|0600,
st_rdev=makedev(3, 10), ...}) = 0
stat64("/dev/ide/host0/bus0/target0/lun0/part11", {st_mode=S_IFBLK|0600,
st_rdev=makedev(3, 11), ...}) = 0
stat64("/dev/ide/host0/bus0/target0/lun0/part12", {st_mode=S_IFBLK|0600,
st_rdev=makedev(3, 12), ...}) = 0
ioctl(9, DM_DEV_CREATE, 0x8109958)      = 0
ioctl(9, DM_TABLE_STATUS, 0x8109958)    = -1 EINVAL (Invalid argument)
write(2, "  ", 2)                       = 2
write(2, "device-mapper: table ioctl faile"..., 51) = 51
write(2, "\n", 1)                       = 1

3.  When I try to mount the filesystem in that LV, it fails.  I tried
with different filesystem types and it's the same result.  From within
the 2.4 kernel based initrd, it fails.  If I reboot into the 2.6 kernel
based installer environment, no problem.

This looks like an incompatibility between the lvm2 and/or device-mapper
library code and the kernel device-mapper code.  Here are the versions
installed in the install environment (the one that works):

lvm> version
   LVM version:     2.02.05 (2006-04-21)
   Library version: 1.02.03 (2006-02-08)
   Driver version:  4.4.0

In the initrd, the only thing different would be the driver version.
Later today I will have access to the machine again and I can run the
lvm version command there to see what the driver version is.  In the
meantime, I am looking at the kernel sources and I don't see anything
obvious in the driver/md directory.
