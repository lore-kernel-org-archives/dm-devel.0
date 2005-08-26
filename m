From: Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be>
Subject: fibre channel/multipath questions
Date: Fri, 26 Aug 2005 18:12:22 +0200
Message-ID: <200508261812.22181.Rik.Bobbaers@cc.kuleuven.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hey guys,

Let me introduce myself.
I'm Rik Bobbaers, working at the KULeuven (university in belgium)
I'm a linux sysadmin, followed a linux kernel internals course and a device 
drivers course.

I have some machines that i want to connect to a SAN, which also has an 
IBM/ESS (shark) connection. The san is split in 2 (for failover). each server 
has 2 qlogic fibrechannel cards, which are both connected to different san 
switches. I want failover/loadbalancing over those (du'uh ;))

hardware: Dell PE 1750, dual  xeon cpu, 1 gig ram
distro: Debian/unstable (normally it's a stable)
kernel version: vanilla 2.6.13-rc6
bootloader: lilo (maybe switch to grub necessary?)
udev version: 0.067-1
multipath version: 0.4.2.4-2
fibre channel cards:
0000:01:04.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 
02)
0000:03:06.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 
02)


Now the questions:
1. If i unplug one cable (simulating a sanswitch breakdown/upgrade/...), the 
timer starts, giving a timeout after fc_dev_loss_tmo seconds. In the normal 
situation, this is 35 seconds (the qlogic driver adds 5 seconds to the normal 
30). This timer can be set to a max of SCSI_DEVICE_BLOCK_MAX_TIMEOUT, being 
15000 it seems, which is 4 hours 10 minutes.
If you plug your cable in again before this timer reached 0, it reactivates 
the device, making reintegration in the multipath possible (disks keep the 
same major:minor number). If the timer runs out, the devices are removed 
permanently. When you plug the cable back in, it gives the newly found disks 
other major:minor numbers and device names (same major, but well... ;)), 
which makes reintegration in the multipath impossible unless you unmount 
everything etc... This is not the behaviour you want on a SAN network in a 
failover/loadbalancing environment imho. Is there a way you can make the 
disks be rerecognised as "the same disks as before"? So that the devices can 
be removed by the driver, but re-made when the san connection returns after 
an undetermined amount of time?
If not, is it dangerous to set the SCSI_DEVICE_BLOCK_MAX_TIMEOUT to ... let's 
say 2^32 (uint_32)? Or redefine it in drivers/scsi/scsi_transport_fc.c ? What 
would be the consequences? I can imagine that this could cause memory 
problems, workqueue problems or so. I didn't find anything on this on the 
lkml list archives or so.

2. Is it possible to make the fibrechannel driver get loaded AFTER the others? 
(Our kernels have no modules support, so i built it all in the kernel for 
security reasons etc...) The reason is very simple. If I have 1 disk on ESS, 
it now becomes /dev/sda on scsi0, /dev/sdb on scsi1 and the local disks 
are /dev/sdc and /dev/sdd. If I add another ESS disk , it will be /dev/sde 
and /dev/sdf, after a reboot, they will be /dev/sdc and /dev/sdd, the  local 
disks will become /dev/sde and /dev/sdf. At first i thought, use e2label, but 
that's only for ext2/3 filesystems, our systems run on reiserfs. Are there 
any sollutions for this in a monolythical kernel or is the only way to fix 
this, compile the driver as modules and load them at boottime?

I tried patching the current code a little bit, which was quite hard (since 
i've never done this before). I allready learned a lot, but I would like to 
learn some more so that I could eventually even try to help out on these 
things.

I hope this is enough information, if not, please ask!

thanks a million,

-- 
harry
aka Rik Bobbaers

K.U.Leuven - LUDIT          -=- Tel: +32 485 52 71 50
Rik.Bobbaers@cc.kuleuven.be -=- http://harry.ulyssis.org
