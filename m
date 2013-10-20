From: rihad <rihad@mail.ru>
Subject: LVM2 volume not recognised on cold restart
Date: Sun, 20 Oct 2013 17:36:28 +0500
Message-ID: <5263CE4C.5020505@mail.ru>
Reply-To: rihad <rihad@mail.ru>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
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

Hi, all. I'm using Kubuntu for a few years now. Distribution kernels 
after vmlinuz-2.6.35-28-generic fail to properly detect the Intel 
Software Raid (isw) 2 SATA disk stripe volume I have, and since my root 
FS is there, booting halts. Warm reboot then leaves my disks in a messed 
up offline state (according to BIOS). Only cold restart brings them back 
to life. The only way to correctly boot the PC is to first boot into 
vmlinuz-2.6.35-28-generic, which correctly recognises & initialises my 
disk setup, and then do a warm reboot into 3.0, 3.2, 3.10 kernel or 
whatever. Which I've been doing for the past 2 years. I also tried 
grabbing 3.10 vanilla sources from kernel.org, built the kernel, but 
alas, same failing to find root fs. Both kernels are booted as: "Kernel 
command line: root=/dev/mapper/vg0-root ro quiet splash" (where vg0-root 
is my root FS logical volume).

I'm no kernel hacker, but having analyzed dmesg output from running both 
kernels, it appears device-mapper broke compatibility  in the newer version.

3.2.0-54-generic kernel (failing to properly boot after cold reboot):
[    0.743048] device-mapper: uevent: version 1.0.3
[    0.743131] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) 
initialised: dm-devel@redhat.com
[    8.760596] device-mapper: dm-raid45: initialized v0.2594b
[   13.138634] device-mapper: multipath: version 1.3.1 loaded


2.6.35 kernel (working after cold/warm reboot):
[    0.634400] device-mapper: uevent: version 1.0.3
[    0.634526] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) 
initialised: dm-devel@redhat.com
[    0.634645] device-mapper: multipath: version 1.1.1 loaded
[    0.634691] device-mapper: multipath round-robin: version 1.0.0 loaded
[    4.378056] device-mapper: dm-raid45: initialized v0.2594b
[    5.281816] device-mapper: ioctl: device doesn't appear to be in the 
dev hash table.
[    9.083852] device-mapper: table: 252:6: dm-2 too small for target: 
start=218129509, len=1701990410, dev_size=48821472
[    9.085147] device-mapper: table: 252:7: dm-2 too small for target: 
start=218129509, len=1701990410, dev_size=48821472
[    9.104142] device-mapper: table: 252:7: dm-2 too small for target: 
start=729050177, len=543974724, dev_size=48821472
[    9.104697] device-mapper: table: 252:6: dm-2 too small for target: 
start=729050177, len=543974724, dev_size=48821472
[    9.123294] device-mapper: table: 252:6: dm-2 too small for target: 
start=2692939776, len=51635, dev_size=48821472
[    9.123776] device-mapper: table: 252:7: dm-2 too small for target: 
start=2692939776, len=51635, dev_size=48821472

(still working fine)
