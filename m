From: Darryl Dixon <esrever_otua@pythonhacker.is-a-geek.net>
Subject: Re: Multipath not re-activating failed paths? [SOLVED]
	and Multipath on root [SOLVED]
Date: Fri, 15 Sep 2006 21:08:53 +1200
Message-ID: <1158311333.2718.39.camel@darrylsfc3box.ddnet.co.nz>
References: <7EB526165496DF4ABE1A64C5CE0BB59B03858645@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7EB526165496DF4ABE1A64C5CE0BB59B03858645@bgeexc01.asiapacific.cpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Arumugam, Anburaja (STSD)" <anburaja.arumugam@hp.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Anbu,

For the benefit of the list, I tracked the problem of paths not
re-activating down to (ironically) the interaction between the
supposedly 'enhanced' HP-supplied GPL'ed QLogic drivers and our SUN
3510 :) What I noticed was that when the link was brought back up, two
of my four LUNs would have their second path re-activated, but the other
two wouldn't. In /var/log/messages whenever a cable was unplugged for
testing, I'd see messages like this:

----------8<----------[cut]
kernel: qla2300 0000:06:01.1: qla2xxx_eh_abort scsi(1:0:1:0):
cmd_timeout_in_sec=0x3c.
kernel: qla2300 0000:06:01.1: scsi(1:0:1:0): DEVICE RESET ISSUED.
kernel: qla2300 0000:06:01.1: qla2xxx_eh_device_reset: device reset
failed
kernel: qla2300 0000:06:01.1: scsi(1:0:1:0): LOOP RESET ISSUED.
kernel: qla2300 0000:06:01.1: qla2xxx_eh_bus_reset: reset failed
kernel: qla2300 0000:06:01.1: scsi(1:0:1:0): ADAPTER RESET issued.
kernel: qla2300 0000:06:01.1: Performing ISP error recovery - ha=
00000100f54903c8.
kernel: Performing ISP error recovery - ha= 00000100f54903c8.
kernel: qla2300 0000:06:01.1: LIP reset occured (f8f7).
kernel: qla2300 0000:06:01.1: LIP occured (f7f7).
kernel: qla2300 0000:06:01.1: LOOP UP detected (2 Gbps).
kernel: qla2300 0000:06:01.1: qla2xxx_eh_host_reset: reset succeded
kernel: scsi: Device offlined - not ready after error recovery: host 1
channel 0 id 2 lun 0
last message repeated 15 times
kernel: scsi: Device offlined - not ready after error recovery: host 1
channel 0 id 0 lun 0
----------8<----------[cut]

Sure enough, when I rolled back to use the standard RHEL qla2300.ko and
qla2xxx.ko kernel modules that are supplied in the distribution,
everything started working as expected, and I no longer saw the above
messages any more.

In summary, I *was* using the 'enhanced' QLogic drivers available from
HP et al, but the Qlogic drivers that are packaged by RedHat with RHEL 4
work better in this situation.

To answer your second question (HOW-TO multipath on root)...

In terms of changes to a default RHEL install, I needed to unpack the
standard initrd that is created with `mkinitrd` and then modify it as
follows:

* copy in the following files: bin/dmsetup.static, bin/kpartx.static,
bin/multipath.static, bin/scsi_id.static (these are available
from /sbin/ in a standard RHEL install), and then create symlinks in the
initrd that pointed the 'normal' names for each to the staticly compiled
version, eg bin/dmsetup -> bin/dmsetup.static

* copy /etc/multipath.conf (as outlined below in my earlier mail) to
etc/multipath.conf in the initrd

* edit the standard /etc/udev/rules.d/40-multipath.rules to use
different rules (THIS IS CRITICAL) that look like:
----------8<----------[cut]
# multipath wants the devmaps presented as meaninglful device names
# so name them after their devmap name

#The Blockdev
ACTION=="add", SUBSYSTEM=="block", KERNEL=="dm-*", \
PROGRAM="/sbin/dmsetup -j %M -m %m --noopencount --noheadings -c -o name
info"

#The Partitions
ACTION=="add", SUBSYSTEM=="block", KERNEL=="dm-*", \
RUN+="/sbin/kpartx -a /dev/mapper/%c"
----------8<----------[cut]

* ...and then copy the contents of /etc/udev/rules.d/* into the same
directory in the initrd

* Copy all the dm-* kernel modules and the qla* modules (if using QLogic
HBA) into lib/ in the initrd

* Edit the 'init' script in the initrd.  Here's what mine looks like
now. I added the insmod lines for the dm-* modules and the qla* modules.
I also added the two lines beginning with 'multipath' and 'dmsetup',
which are critical, it won't work without them there (although I'm still
not certain on ~why~). Also, I seemed to need to load the qla2300 HBA
module *after* all the dm-* modules.
----------8<----------[cut]
#!/bin/nash

mount -t proc /proc /proc
setquiet
echo Mounted /proc filesystem
echo Mounting sysfs
mount -t sysfs none /sys
echo Creating /dev
mount -o mode=0755 -t tmpfs none /dev
mknod /dev/console c 5 1
mknod /dev/null c 1 3
mknod /dev/zero c 1 5
mkdir /dev/pts
mkdir /dev/shm
echo Starting udev
/sbin/udevstart
echo -n "/sbin/hotplug" > /proc/sys/kernel/hotplug
echo "Loading scsi_mod.ko module"
insmod /lib/scsi_mod.ko
echo "Loading sd_mod.ko module"
insmod /lib/sd_mod.ko
echo "Loading cciss.ko module"
insmod /lib/cciss.ko
echo "Loading scsi_transport_fc.ko module"
insmod /lib/scsi_transport_fc.ko
echo "Loading qla2xxx.ko module"
insmod /lib/qla2xxx.ko
echo "Loading dm-mod.ko module"
insmod /lib/dm-mod.ko
echo "Loading dm-multipath.ko module"
insmod /lib/dm-multipath.ko
echo "Loading dm-round-robin.ko module"
insmod /lib/dm-round-robin.ko
echo "Loading dm-mirror.ko module"
insmod /lib/dm-mirror.ko
# LOAD THE HBA DRIVER LAST
echo "Loading qla2300.ko module"
insmod /lib/qla2300.ko
/sbin/udevstart
# THE NEXT TWO LINES ARE CRITICAL
multipath
dmsetup ls --target multipath --exec "/sbin/kpartx -a"
echo Creating root device
mkrootdev /dev/root
umount /sys
echo Mounting root filesystem
mount -o defaults --ro -t ext2 /dev/root /sysroot
mount -t tmpfs --bind /dev /sysroot/dev
echo Switching to new root
switchroot /sysroot
umount /initrd/dev
----------8<----------[cut]

* Now re-pack the initrd and copy the image into /boot, then edit the
appropriate entry in your grub.conf so that the root= option points to
the mapper device (eg, mine is root=/dev/mapper/os2), and change the
initrd line to point at your newly modified initrd image.

* Finally, make sure that you have the appropriate entry in
your /etc/fstab; in my case /dev/mapper/os2 is the device to use for
root, as 'os' was the alias that I set up for the root LUN.

Now reboot :)

I hope that this helps anyone else trying to do what I have done, it was
the better part of a week's worth of work :)

many regards,
Darryl Dixon
http://www.winterhouseconsulting.com



On Fri, 2006-09-15 at 12:41 +0530, Arumugam, Anburaja (STSD) wrote:
> Hi Darryl,
> 
> Not sure if this hint helps you, if you haven't tried this before. But
> you may want to check the process status of your 'multipathd' daemon
> which initiates the path verification, after the failure of one path.
> B'cos, for some reason if the 'multipathd' daemon is in "stopped" state,
> then there is no way for the multipath configurator to get the path back
> as online.
> 
> You can check the status of the 'multipathd' daemon by using
> "/etc/init.d/multipathd status" on your host.
> 
> Hope this helps!!
> 
> We are curious of the fact that you have a working multipath root device
> setup on your side. Could you please give some pointers on how do we
> have the working multipath boot setup? What we are looking at is, what
> kind of changes you need to do at the grub.conf, and what kind of steps
> you should follow to get the multipath/udev/multipath.conf in the
> 'initrd', if we need to do so.
> 
> Thanks in advance,
> Anbu
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Darryl Dixon
> Sent: Friday, September 15, 2006 5:24 AM
> To: dm-devel@redhat.com
> Subject: [dm-devel] Multipath not re-activating failed paths?
> 
> Hi All,
> 
> I have a working dm-multipath set up with a multipath root device. For
> some reason, while multipath seems to correctly use both paths, and will
> gracefully handle the failing of a path (uninterrupted IO works OK), it
> does not seem to want to detect once the failed path has come back up
> again. In other words, in my two-path setup, it will load balance
> between the paths, continue successfully on one path when one fails, but
> it will then be 'stuck' on that path forever until the next reboot, even
> if the first path is back up and otherwise working fine.
> 
> >From what I can understand of the multipath.conf settings, the paths
> should be tested every 5 seconds, and should be marked 'active' once
> they come back up.
> 
> How can I best go about debugging/investigating this?
> 
> My setup details:
> Machine:     HP Blade BL25P with QLogic dual-ported HBA
> Storage:     Two paths to SUN 3510
> OS:          RHEL4 x86_64
> DM package:  device-mapper-multipath-0.4.5-16.1.RHEL4
> uname -r:    2.6.9-42.0.2.ELsmp
> 
> contents of /etc/multipath.conf:
> ----------8<----------[cut]
> devnode_blacklist {
>        devnode "^cciss!c[0-9]d[0-9]*"
> }
> 
> defaults {
>     user_friendly_names yes
>     no_path_retry fail
>     path_grouping_policy multibus
>     failback immediate
> 
> }
> 
> multipaths {
>     multipath {
>         wwid   3500000e01190e340
>         alias  os
>     }
> }
> ----------8<----------[cut]
> 
> Output of multipath -l:
> ----------8<----------[cut]
> 3500000e01190e100
> [size=68 GB][features="0"][hwhandler="0"] \_ round-robin 0 [active]  \_
> 0:0:3:0 sdd 8:48  [active]  \_ 1:0:3:0 sdh 8:112 [active]
> 
> 3500000e01190e3f0
> [size=68 GB][features="0"][hwhandler="0"] \_ round-robin 0 [active]  \_
> 0:0:1:0 sdb 8:16  [active]  \_ 1:0:0:0 sde 8:64  [active]
> 
> os (3500000e01190e340)
> [size=68 GB][features="0"][hwhandler="0"] \_ round-robin 0 [active]
>  \_ 0:0:0:0 sda 8:0   [active]
>  \_ 1:0:2:0 sdg 8:96  [active]
> 
> 3500000e01190e310
> [size=68 GB][features="0"][hwhandler="0"] \_ round-robin 0 [active]  \_
> 0:0:2:0 sdc 8:32  [active]  \_ 1:0:1:0 sdf 8:80  [active]
> ----------8<----------[cut]
> 
> Contents of /dev/mapper/:
> ----------8<----------[cut]
> brw-rw----  1 root disk 253,  3 Sep 15  2006 3500000e01190e100
> brw-rw----  1 root disk 253,  2 Sep 15  2006 3500000e01190e310
> brw-rw----  1 root disk 253,  1 Sep 15  2006 3500000e01190e3f0
> crw-------  1 root root  10, 63 Sep 15  2006 control
> brw-rw----  1 root disk 253,  0 Sep 15  2006 os
> brw-rw----  1 root disk 253,  4 Sep 15  2006 os1
> brw-rw----  1 root disk 253,  5 Sep 15  2006 os2
> brw-rw----  1 root disk 253,  6 Sep 15  2006 os3
> ----------8<----------[cut]
> 
> Output of df -k:
> ----------8<----------[cut]
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/mapper/os2       50394996  29944792  17890248  63% /
> /dev/mapper/os1         101086     23801     72066  25% /boot
> none                   5036176         0   5036176   0% /dev/shm
> ----------8<----------[cut]
> 
> 
> Any and all pointers or assistance appreciated.
> 
> regards,
> Darryl Dixon
> http://www.winterhouseconsulting.com
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
