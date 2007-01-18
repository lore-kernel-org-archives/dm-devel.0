From: Sebastian Ewert <ewerts@iai.uni-bonn.de>
Subject: multipath: alternative path routing not working (EMC
 clariion AX100, Ubuntu 6.06)
Date: Thu, 18 Jan 2007 19:16:13 +0100
Message-ID: <45AFB96D.50907@iai.uni-bonn.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080706090203000403080604"
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
Cc: edv@jura.uni-bonn.de
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080706090203000403080604
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

_System_
Ubuntu 6.06, 2x Emulex HBAs, EMC Clariion AX100 with three virtual disks 
attached. Kernel is an ubuntu stock kernel (amd64).

_Problem summary_
when I unplug any of the two fibrechannel cords, multipath does not use the 
alternative path and I can't access my data anymore. Even when I replug it I 
can't access the multipath anymore at all. failback is set to immediate.

_reproducible_
always

_Attached files_
syslog.error : a part of my syslog showing what happened after I unplugged 
and replugged the cord. Looks good to me but in line 69 (16:02:04) you can 
see what happens if I try to access the device (this is the response to a 
umount I did on the directory where the multipath is mounted. Similar 
happens if I just do a 'ls' in that directory).

syslog.reboot: This is the relevant part of syslog when I do a restart. The 
dm versions in my kernel are here.

multipath.conf: the multipath config I used striped from comments

multipath.conf.minimal: An extrem striped down version of my multipath conf 
using almost just default options. This was a test, but nothing really changed.


_Problem details_
For installation I followed basically this guide:

http://www.pri.univie.ac.at/index.php?m=D&t=main&c=show&CEWebS_what=Installing~32~a~32~SAN~32~Clariion~32~EMC-AX100~32~on~32~a~32~Debian~32~Server

except that the kernel in ubuntu 6.06 is 2.6.15 and has already working 
emulex hba drivers. With the attached multipath config I get my aliases 
under /dev/mapper (for example ax100backup). I partitioned that and got the 
partioned dev node under /dev/evms (f.e. ax100backup5). I used that as an 
lvm physical volume and created an logical volume out of it (to be able to 
expand later the space). That logical volume appears under f.e. 
/dev/mybackupvg/mybackuplv (just an example name).

After formating those logical volumes I can mount them and I have no problem 
using them.

But: When I unplug one of the fibrechannel cords (and so temporarily 
disabling a path) I can't access the multipath anymore and I just get syslog 
messages like:
3:0:0:1: rejecting I/O to dead device
Buffer I/O error on device dm-4, logical block 607
lost page write due to I/O error on dm-4

Even after replugging the cord it doesn't work. A complete reboot solves the 
error.

I don't know it if this is relevant: I found here (point 5): 
http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=FAQ
that I need certain udev rules. In my udev rules the ignore rule mentioned 
there is active. But since everything works after a reboot I thought it 
might not be important.


I hope I didn't forget any relevant information you might need.

Thank you very very much in advance for any hint or answer...


Sebastian Ewert

--------------080706090203000403080604
Content-Type: text/plain;
 name="syslog.error"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="syslog.error"

Jan 18 14:24:21 midgard2 kernel: [667861.006420] lpfc 0000:08:0b.0: 1:1305 Link Down Event x2 received Data: x2 x20 x0
Jan 18 14:24:56 midgard2 kernel: [667895.913158]  rport-3:0-0: blocked FC remote port time out: removing target and saving binding
Jan 18 14:24:56 midgard2 multipathd: 8:64: emc_clariion_checker: query command indicates error
Jan 18 14:24:56 midgard2 multipathd: checker failed path 8:64 in map ax100backup
Jan 18 14:24:56 midgard2 multipathd: ax100backup: remaining active paths: 1
Jan 18 14:24:56 midgard2 multipathd: 8:80: emc_clariion_checker: query command indicates error
Jan 18 14:24:56 midgard2 multipathd: checker failed path 8:80 in map ax100big
Jan 18 14:24:56 midgard2 multipathd: ax100big: remaining active paths: 1
Jan 18 14:24:56 midgard2 multipathd: 8:96: emc_clariion_checker: query command indicates error
Jan 18 14:24:56 midgard2 multipathd: checker failed path 8:96 in map ax100edv
Jan 18 14:24:56 midgard2 multipathd: ax100edv: remaining active paths: 1
Jan 18 14:24:56 midgard2 multipathd: sde: remove path (uevent)
Jan 18 14:24:56 midgard2 kernel: [667895.927550] device-mapper: dm-multipath: Failing path 8:64.
Jan 18 14:24:56 midgard2 multipathd: ax100backup: load table [0 419430400 multipath 0 1 emc 1 1 round-robin 0 1 1 8:16 100]
Jan 18 14:24:56 midgard2 multipathd: sdf: remove path (uevent)
Jan 18 14:24:56 midgard2 multipathd: ax100big: load table [0 2894069760 multipath 0 1 emc 1 1 round-robin 0 1 1 8:32 100]
Jan 18 14:24:56 midgard2 multipathd: sdg: remove path (uevent)
Jan 18 14:24:56 midgard2 multipathd: ax100edv: load table [0 528751104 multipath 0 1 emc 1 1 round-robin 0 1 1 8:48 100]
Jan 18 14:24:56 midgard2 kernel: [667895.927605]  3:0:0:1: rejecting I/O to dead device
Jan 18 14:24:56 midgard2 kernel: [667895.934218] device-mapper: dm-multipath: Failing path 8:80.
Jan 18 14:24:56 midgard2 kernel: [667895.934241]  3:0:0:2: rejecting I/O to dead device
Jan 18 14:24:56 midgard2 kernel: [667895.940596] device-mapper: dm-multipath: Failing path 8:96.
Jan 18 14:24:56 midgard2 kernel: [667895.940822] device-mapper: dm-emc: long trespass command will be send
Jan 18 14:24:56 midgard2 kernel: [667895.940826] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 14:24:56 midgard2 kernel: [667895.941375] device-mapper: dm-emc: long trespass command will be send
Jan 18 14:24:56 midgard2 kernel: [667895.941378] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 14:24:56 midgard2 kernel: [667895.941790] device-mapper: dm-emc: long trespass command will be send
Jan 18 14:24:56 midgard2 kernel: [667895.941793] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 15:55:04 midgard2 kernel: [673287.060008] lpfc 0000:08:0b.0: 1:1303 Link Up Event x3 received Data: x3 x1 x8 x2
Jan 18 15:55:04 midgard2 kernel: [673287.074963]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 15:55:04 midgard2 kernel: [673287.074985]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 15:55:04 midgard2 kernel: [673287.075345] SCSI device sdh: 419430400 512-byte hdwr sectors (214748 MB)
Jan 18 15:55:04 midgard2 multipathd: sdh: add path (uevent)
Jan 18 15:55:04 midgard2 kernel: [673287.075600] SCSI device sdh: drive cache: write through
Jan 18 15:55:04 midgard2 kernel: [673287.075870] SCSI device sdh: 419430400 512-byte hdwr sectors (214748 MB)
Jan 18 15:55:04 midgard2 kernel: [673287.076075] SCSI device sdh: drive cache: write through
Jan 18 15:55:04 midgard2 kernel: [673287.076085]  sdh: sdh1 < sdh5 >
Jan 18 15:55:04 midgard2 kernel: [673287.076680] sd 3:0:1:0: Attached scsi disk sdh
Jan 18 15:55:04 midgard2 kernel: [673287.076758] sd 3:0:1:0: Attached scsi generic sg5 type 0
Jan 18 15:55:04 midgard2 kernel: [673287.081228]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 15:55:04 midgard2 kernel: [673287.081278]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 15:55:04 midgard2 kernel: [673287.081651] SCSI device sdi: 2894069760 512-byte hdwr sectors (1481764 MB)
Jan 18 15:55:04 midgard2 kernel: [673287.081874] SCSI device sdi: drive cache: write through
Jan 18 15:55:04 midgard2 kernel: [673287.082138] SCSI device sdi: 2894069760 512-byte hdwr sectors (1481764 MB)
Jan 18 15:55:04 midgard2 kernel: [673287.082359] SCSI device sdi: drive cache: write through
Jan 18 15:55:04 midgard2 kernel: [673287.082366]  sdi: sdi1 < sdi5 >
Jan 18 15:55:04 midgard2 kernel: [673287.083111] sd 3:0:1:1: Attached scsi disk sdi
Jan 18 15:55:04 midgard2 kernel: [673287.083185] sd 3:0:1:1: Attached scsi generic sg6 type 0
Jan 18 15:55:04 midgard2 kernel: [673287.083486]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 15:55:04 midgard2 kernel: [673287.083506]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 15:55:04 midgard2 kernel: [673287.083863] SCSI device sdj: 528751104 512-byte hdwr sectors (270721 MB)
Jan 18 15:55:04 midgard2 kernel: [673287.084160] SCSI device sdj: drive cache: write through
Jan 18 15:55:04 midgard2 kernel: [673287.084449] SCSI device sdj: 528751104 512-byte hdwr sectors (270721 MB)
Jan 18 15:55:04 midgard2 kernel: [673287.084670] SCSI device sdj: drive cache: write through
Jan 18 15:55:04 midgard2 kernel: [673287.084679]  sdj: sdj1 < sdj5 >
Jan 18 15:55:04 midgard2 kernel: [673287.085182] sd 3:0:1:2: Attached scsi disk sdj
Jan 18 15:55:04 midgard2 kernel: [673287.085259] sd 3:0:1:2: Attached scsi generic sg7 type 0
Jan 18 15:55:04 midgard2 kernel: [673287.289299] device-mapper: dm-emc: long trespass command will be send
Jan 18 15:55:04 midgard2 kernel: [673287.289306] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 15:55:04 midgard2 multipathd: ax100backup: load table [0 419430400 multipath 0 1 emc 1 1 round-robin 0 2 1 8:16 100 8:112 100]
Jan 18 15:55:04 midgard2 multipathd: sdi: add path (uevent)
Jan 18 15:55:04 midgard2 multipathd: ax100big: load table [0 2894069760 multipath 0 1 emc 1 1 round-robin 0 2 1 8:32 100 8:128 100]
Jan 18 15:55:04 midgard2 kernel: [673287.300162] device-mapper: dm-emc: long trespass command will be send
Jan 18 15:55:04 midgard2 kernel: [673287.300168] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 15:55:04 midgard2 multipathd: sdj: add path (uevent)
Jan 18 15:55:04 midgard2 multipathd: ax100edv: load table [0 528751104 multipath 0 1 emc 1 1 round-robin 0 2 1 8:48 100 8:144 100]
Jan 18 15:55:04 midgard2 kernel: [673287.316147] device-mapper: dm-emc: long trespass command will be send
Jan 18 15:55:04 midgard2 kernel: [673287.316153] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 16:02:04 midgard2 kernel: [673705.544444]  3:0:0:1: rejecting I/O to dead device
Jan 18 16:02:04 midgard2 kernel: [673705.551701] Buffer I/O error on device dm-4, logical block 607
Jan 18 16:02:04 midgard2 kernel: [673705.559085] lost page write due to I/O error on dm-4
Jan 18 16:02:04 midgard2 kernel: [673705.559114]  3:0:0:1: rejecting I/O to dead device
Jan 18 16:02:04 midgard2 kernel: [673705.566741] Buffer I/O error on device dm-4, logical block 607
Jan 18 16:02:04 midgard2 kernel: [673705.574445] lost page write due to I/O error on dm-4
Jan 18 16:02:04 midgard2 kernel: [673705.574805]  3:0:0:1: rejecting I/O to dead device
Jan 18 16:02:04 midgard2 kernel: [673705.582713] Buffer I/O error on device dm-4, logical block 607
Jan 18 16:02:04 midgard2 kernel: [673705.590814] lost page write due to I/O error on dm-4
Jan 18 16:02:04 midgard2 kernel: [673705.590868]  3:0:0:1: rejecting I/O to dead device
Jan 18 16:02:04 midgard2 kernel: [673705.599204] Buffer I/O error on device dm-4, logical block 607
Jan 18 16:02:04 midgard2 kernel: [673705.607547] lost page write due to I/O error on dm-4
Jan 18 16:02:04 midgard2 kernel: [673705.608441]  3:0:0:1: rejecting I/O to dead device
Jan 18 16:02:04 midgard2 kernel: [673705.616816] Buffer I/O error on device dm-4, logical block 0
Jan 18 16:02:04 midgard2 kernel: [673705.625160] lost page write due to I/O error on dm-4
Jan 18 16:02:07 midgard2 multipathd: dm-3: umount map (uevent)
Jan 18 16:02:07 midgard2 kernel: [673708.602577]  3:0:0:2: rejecting I/O to dead device
Jan 18 16:02:07 midgard2 kernel: [673708.611077] Buffer I/O error on device dm-3, logical block 0
Jan 18 16:02:07 midgard2 kernel: [673708.619874] lost page write due to I/O error on dm-3
Jan 18 16:02:55 midgard2 kernel: [673756.929648] device-mapper: dm-emc: emc_pg_init: sending switch-over command
Jan 18 16:02:55 midgard2 kernel: [673756.943775] device-mapper: dm-emc: emc_pg_init: sending switch-over command
Jan 18 16:02:55 midgard2 kernel: [673756.952112] device-mapper: dm-emc: emc_pg_init: sending switch-over command
Jan 18 16:02:55 midgard2 kernel: [673756.960104]  3:0:0:2: rejecting I/O to dead device
Jan 18 16:02:55 midgard2 kernel: [673756.969469]  3:0:0:2: rejecting I/O to dead device
Jan 18 16:02:55 midgard2 kernel: [673756.978313]  3:0:0:1: rejecting I/O to dead device
Jan 18 16:02:55 midgard2 kernel: [673756.986955]  3:0:0:1: rejecting I/O to dead device
Jan 18 16:02:55 midgard2 kernel: [673757.006554]  3:0:0:0: rejecting I/O to dead device
Jan 18 16:02:55 midgard2 kernel: [673757.014836]  3:0:0:0: rejecting I/O to dead device
Jan 18 16:03:21 midgard2 kernel: [673782.977303]  3:0:0:1: rejecting I/O to dead device
Jan 18 16:03:21 midgard2 kernel: [673782.984522] EXT3-fs: unable to read superblock
Jan 18 16:03:21 midgard2 multipathd: dm-4: umount map (uevent)
Jan 18 16:04:20 midgard2 shutdown[14256]: shutting down for system reboot
Jan 18 16:04:20 midgard2 init: Switching to runlevel: 6
Jan 18 16:04:24 midgard2 multipathd: ax100big: stop event checker thread
Jan 18 16:04:24 midgard2 multipathd: ax100edv: stop event checker thread

--------------080706090203000403080604
Content-Type: text/plain;
 name="syslog.reboot"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="syslog.reboot"

Jan 18 16:06:54 midgard2 kernel: [   99.273919] Emulex LightPulse Fibre Channel SCSI driver 8.1.4
Jan 18 16:06:54 midgard2 kernel: [   99.763116] scsi2 :  on PCI bus 08 device 50 irq 217
Jan 18 16:06:54 midgard2 kernel: [  105.837397] lpfc 0000:08:0a.0: 0:1303 Link Up Event x1 received Data: x1 x1 x8 x2
Jan 18 16:06:54 midgard2 kernel: [  105.938462]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 16:06:54 midgard2 kernel: [  105.938477]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 16:06:54 midgard2 kernel: [  105.938819] SCSI device sdb: 419430400 512-byte hdwr sectors (214748 MB)
Jan 18 16:06:54 midgard2 kernel: [  105.939023] SCSI device sdb: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  105.939262] SCSI device sdb: 419430400 512-byte hdwr sectors (214748 MB)
Jan 18 16:06:54 midgard2 kernel: [  105.939460] SCSI device sdb: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  105.939463]  sdb: sdb1 < sdb5 >
Jan 18 16:06:54 midgard2 kernel: [  105.939988] sd 2:0:0:0: Attached scsi disk sdb
Jan 18 16:06:54 midgard2 kernel: [  105.944559]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 16:06:54 midgard2 kernel: [  105.944574]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 16:06:54 midgard2 kernel: [  105.944901] SCSI device sdc: 2894069760 512-byte hdwr sectors (1481764 MB)
Jan 18 16:06:54 midgard2 kernel: [  105.945101] SCSI device sdc: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  105.945328] SCSI device sdc: 2894069760 512-byte hdwr sectors (1481764 MB)
Jan 18 16:06:54 midgard2 kernel: [  105.945525] SCSI device sdc: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  105.945528]  sdc: sdc1 < sdc5 >
Jan 18 16:06:54 midgard2 kernel: [  105.945989] sd 2:0:0:1: Attached scsi disk sdc
Jan 18 16:06:54 midgard2 kernel: [  105.946338]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 16:06:54 midgard2 kernel: [  105.946353]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 16:06:54 midgard2 kernel: [  105.946675] SCSI device sdd: 528751104 512-byte hdwr sectors (270721 MB)
Jan 18 16:06:54 midgard2 kernel: [  105.946875] SCSI device sdd: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  105.947100] SCSI device sdd: 528751104 512-byte hdwr sectors (270721 MB)
Jan 18 16:06:54 midgard2 kernel: [  105.947299] SCSI device sdd: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  105.947302]  sdd: sdd1 < sdd5 >
Jan 18 16:06:54 midgard2 kernel: [  105.947727] sd 2:0:0:2: Attached scsi disk sdd
Jan 18 16:06:54 midgard2 kernel: [  106.665841] scsi3 :  on PCI bus 08 device 58 irq 225
Jan 18 16:06:54 midgard2 kernel: [  111.166368] lpfc 0000:08:0b.0: 1:0442 Adapter failed to init, mbxCmd x88 CONFIG_PORT, mbxStatus x12 Data: x0
Jan 18 16:06:54 midgard2 kernel: [  117.238596] lpfc 0000:08:0b.0: 1:1303 Link Up Event x1 received Data: x1 x1 x8 x2
Jan 18 16:06:54 midgard2 kernel: [  117.339041]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 16:06:54 midgard2 kernel: [  117.339055]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 16:06:54 midgard2 kernel: [  117.339399] SCSI device sde: 419430400 512-byte hdwr sectors (214748 MB)
Jan 18 16:06:54 midgard2 kernel: [  117.339603] SCSI device sde: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  117.339839] SCSI device sde: 419430400 512-byte hdwr sectors (214748 MB)
Jan 18 16:06:54 midgard2 kernel: [  117.340037] SCSI device sde: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  117.340043]  sde: sde1 < sde5 >
Jan 18 16:06:54 midgard2 kernel: [  117.340577] sd 3:0:0:0: Attached scsi disk sde
Jan 18 16:06:54 midgard2 kernel: [  117.345117]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 16:06:54 midgard2 kernel: [  117.345131]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 16:06:54 midgard2 kernel: [  117.345458] SCSI device sdf: 2894069760 512-byte hdwr sectors (1481764 MB)
Jan 18 16:06:54 midgard2 kernel: [  117.345659] SCSI device sdf: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  117.345883] SCSI device sdf: 2894069760 512-byte hdwr sectors (1481764 MB)
Jan 18 16:06:54 midgard2 kernel: [  117.346083] SCSI device sdf: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  117.346086]  sdf: sdf1 < sdf5 >
Jan 18 16:06:54 midgard2 kernel: [  117.346534] sd 3:0:0:1: Attached scsi disk sdf
Jan 18 16:06:54 midgard2 kernel: [  117.346888]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 16:06:54 midgard2 kernel: [  117.346902]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 16:06:54 midgard2 kernel: [  117.347228] SCSI device sdg: 528751104 512-byte hdwr sectors (270721 MB)
Jan 18 16:06:54 midgard2 kernel: [  117.347429] SCSI device sdg: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  117.347651] SCSI device sdg: 528751104 512-byte hdwr sectors (270721 MB)
Jan 18 16:06:54 midgard2 kernel: [  117.347849] SCSI device sdg: drive cache: write through
Jan 18 16:06:54 midgard2 kernel: [  117.347852]  sdg: sdg1 < sdg5 >
Jan 18 16:06:54 midgard2 kernel: [  117.348298] sd 3:0:0:2: Attached scsi disk sdg
Jan 18 16:06:54 midgard2 kernel: [  119.532499] device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
Jan 18 16:06:54 midgard2 kernel: [  119.533808] device-mapper: dm-multipath version 1.0.4 loaded
Jan 18 16:06:54 midgard2 kernel: [  119.661109] device-mapper: dm-emc version 0.0.3 loaded
Jan 18 16:06:54 midgard2 kernel: [  119.661240] device-mapper: dm-emc: long trespass command will be send
Jan 18 16:06:54 midgard2 kernel: [  119.661244] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 16:06:54 midgard2 kernel: [  119.668833] device-mapper: dm-round-robin version 1.0.0 loaded
Jan 18 16:06:54 midgard2 kernel: [  119.671261] device-mapper: dm-emc: long trespass command will be send
Jan 18 16:06:54 midgard2 kernel: [  119.671265] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 16:06:54 midgard2 kernel: [  119.673392] device-mapper: dm-emc: long trespass command will be send
Jan 18 16:06:54 midgard2 kernel: [  119.673395] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 16:06:54 midgard2 kernel: [  120.983433] sd 0:0:0:0: Attached scsi generic sg0 type 0
Jan 18 16:06:54 midgard2 kernel: [  120.983467]  0:0:8:0: Attached scsi generic sg1 type 3
Jan 18 16:06:54 midgard2 kernel: [  120.983502] sd 2:0:0:0: Attached scsi generic sg2 type 0
Jan 18 16:06:54 midgard2 kernel: [  120.983532] sd 2:0:0:1: Attached scsi generic sg3 type 0
Jan 18 16:06:54 midgard2 kernel: [  120.983567] sd 2:0:0:2: Attached scsi generic sg4 type 0
Jan 18 16:06:54 midgard2 kernel: [  120.983592] sd 3:0:0:0: Attached scsi generic sg5 type 0
Jan 18 16:06:54 midgard2 kernel: [  120.983624] sd 3:0:0:1: Attached scsi generic sg6 type 0
Jan 18 16:06:54 midgard2 kernel: [  120.983650] sd 3:0:0:2: Attached scsi generic sg7 type 0
Jan 18 16:06:54 midgard2 kernel: [  124.194384] device-mapper: dm-emc: emc_pg_init: sending switch-over command
Jan 18 16:06:54 midgard2 kernel: [  124.230192] device-mapper: dm-emc: emc_pg_init: sending switch-over command
Jan 18 16:06:54 midgard2 kernel: [  124.245753] device-mapper: dm-emc: emc_pg_init: sending switch-over command
Jan 18 16:06:54 midgard2 kernel: [  126.140735] EXT3 FS on dm-4, internal journal
Jan 18 16:06:54 midgard2 kernel: [  126.140740] EXT3-fs: mounted filesystem with ordered data mode.
Jan 18 16:06:54 midgard2 kernel: [  126.145687] kjournald starting.  Commit interval 5 seconds
Jan 18 16:06:54 midgard2 kernel: [  126.146355] EXT3 FS on dm-3, internal journal
Jan 18 16:06:54 midgard2 kernel: [  126.146360] EXT3-fs: mounted filesystem with ordered data mode.
Jan 18 16:06:55 midgard2 multipathd: ax100backup: event checker started
Jan 18 16:06:55 midgard2 multipathd: ax100big: event checker started
Jan 18 16:06:55 midgard2 multipathd: ax100edv: event checker started
Jan 18 16:06:55 midgard2 multipathd: path checkers start up
Jan 18 16:18:33 midgard2 multipathd: sde: remove path (uevent)
Jan 18 16:18:33 midgard2 multipathd: ax100backup: load table [0 419430400 multipath 0 1 emc 1 1 round-robin 0 1 1 8:16 100]
Jan 18 16:18:33 midgard2 kernel: [  825.451613] device-mapper: dm-emc: long trespass command will be send
Jan 18 16:18:33 midgard2 kernel: [  825.451620] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 16:18:33 midgard2 kernel: [  825.452232] device-mapper: dm-emc: long trespass command will be send
Jan 18 16:18:33 midgard2 kernel: [  825.452237] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 16:18:33 midgard2 kernel: [  825.452616] device-mapper: dm-emc: long trespass command will be send
Jan 18 16:18:33 midgard2 kernel: [  825.452619] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 16:18:33 midgard2 multipathd: sdf: remove path (uevent)
Jan 18 16:18:33 midgard2 multipathd: ax100big: load table [0 2894069760 multipath 0 1 emc 1 1 round-robin 0 1 1 8:32 100]
Jan 18 16:18:33 midgard2 multipathd: sdg: remove path (uevent)
Jan 18 16:18:33 midgard2 multipathd: ax100edv: load table [0 528751104 multipath 0 1 emc 1 1 round-robin 0 1 1 8:48 100]
Jan 18 16:19:01 midgard2 kernel: [  853.601475] lpfc 0000:08:0b.0: 1:1303 Link Up Event x3 received Data: x3 x1 x8 x2
Jan 18 16:19:01 midgard2 kernel: [  853.616921]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 16:19:01 midgard2 kernel: [  853.616945]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 16:19:01 midgard2 kernel: [  853.617307] SCSI device sdh: 419430400 512-byte hdwr sectors (214748 MB)
Jan 18 16:19:01 midgard2 multipathd: sdh: add path (uevent)
Jan 18 16:19:01 midgard2 kernel: [  853.617529] SCSI device sdh: drive cache: write through
Jan 18 16:19:01 midgard2 kernel: [  853.617811] SCSI device sdh: 419430400 512-byte hdwr sectors (214748 MB)
Jan 18 16:19:01 midgard2 kernel: [  853.618026] SCSI device sdh: drive cache: write through
Jan 18 16:19:01 midgard2 kernel: [  853.618036]  sdh: sdh1 < sdh5 >
Jan 18 16:19:01 midgard2 kernel: [  853.618715] sd 3:0:1:0: Attached scsi disk sdh
Jan 18 16:19:01 midgard2 kernel: [  853.618782] sd 3:0:1:0: Attached scsi generic sg5 type 0
Jan 18 16:19:01 midgard2 kernel: [  853.623261]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 16:19:01 midgard2 kernel: [  853.623310]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 16:19:01 midgard2 kernel: [  853.623675] SCSI device sdi: 2894069760 512-byte hdwr sectors (1481764 MB)
Jan 18 16:19:01 midgard2 kernel: [  853.623895] SCSI device sdi: drive cache: write through
Jan 18 16:19:01 midgard2 kernel: [  853.624155] SCSI device sdi: 2894069760 512-byte hdwr sectors (1481764 MB)
Jan 18 16:19:01 midgard2 kernel: [  853.624371] SCSI device sdi: drive cache: write through
Jan 18 16:19:01 midgard2 kernel: [  853.624376]  sdi: sdi1 < sdi5 >
Jan 18 16:19:01 midgard2 kernel: [  853.624882] sd 3:0:1:1: Attached scsi disk sdi
Jan 18 16:19:01 midgard2 kernel: [  853.624938] sd 3:0:1:1: Attached scsi generic sg6 type 0
Jan 18 16:19:01 midgard2 kernel: [  853.625239]   Vendor: DGC       Model: RAID 5            Rev: 0219
Jan 18 16:19:01 midgard2 kernel: [  853.625315]   Type:   Direct-Access                      ANSI SCSI revision: 04
Jan 18 16:19:01 midgard2 kernel: [  853.625680] SCSI device sdj: 528751104 512-byte hdwr sectors (270721 MB)
Jan 18 16:19:01 midgard2 kernel: [  853.625902] SCSI device sdj: drive cache: write through
Jan 18 16:19:01 midgard2 kernel: [  853.626156] SCSI device sdj: 528751104 512-byte hdwr sectors (270721 MB)
Jan 18 16:19:01 midgard2 kernel: [  853.626370] SCSI device sdj: drive cache: write through
Jan 18 16:19:01 midgard2 kernel: [  853.626376]  sdj: sdj1 < sdj5 >
Jan 18 16:19:01 midgard2 kernel: [  853.626880] sd 3:0:1:2: Attached scsi disk sdj
Jan 18 16:19:01 midgard2 kernel: [  853.626933] sd 3:0:1:2: Attached scsi generic sg7 type 0
Jan 18 16:19:01 midgard2 multipathd: ax100backup: load table [0 419430400 multipath 0 1 emc 1 1 round-robin 0 2 1 8:16 100 8:112 100]
Jan 18 16:19:01 midgard2 multipathd: sdi: add path (uevent)
Jan 18 16:19:01 midgard2 kernel: [  853.828930] device-mapper: dm-emc: long trespass command will be send
Jan 18 16:19:01 midgard2 kernel: [  853.828936] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 16:19:01 midgard2 multipathd: ax100big: load table [0 2894069760 multipath 0 1 emc 1 1 round-robin 0 2 1 8:32 100 8:128 100]
Jan 18 16:19:01 midgard2 multipathd: sdj: add path (uevent)
Jan 18 16:19:01 midgard2 kernel: [  853.839709] device-mapper: dm-emc: long trespass command will be send
Jan 18 16:19:01 midgard2 kernel: [  853.839715] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 16:19:01 midgard2 multipathd: ax100edv: load table [0 528751104 multipath 0 1 emc 1 1 round-robin 0 2 1 8:48 100 8:144 100]
Jan 18 16:19:01 midgard2 kernel: [  853.850332] device-mapper: dm-emc: long trespass command will be send
Jan 18 16:19:01 midgard2 kernel: [  853.850338] device-mapper: dm-emc: honor reservation bit will not be set (default)
Jan 18 16:24:04 midgard2 kernel: [ 1155.389846]  3:0:0:0: rejecting I/O to dead device
Jan 18 16:24:04 midgard2 kernel: [ 1155.397413] EXT3-fs error (device dm-5): ext3_readdir: directory #2 contains a hole at offset 0
Jan 18 16:24:10 midgard2 kernel: [ 1161.100818]  3:0:0:0: rejecting I/O to dead device
Jan 18 16:24:10 midgard2 kernel: [ 1161.108886] EXT3-fs error (device dm-5): ext3_readdir: directory #2 contains a hole at offset 0

--------------080706090203000403080604
Content-Type: text/plain;
 name="multipath.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath.conf"

defaults {
	udev_dir	/dev
	polling_interval 10
	selector	"round-robin 0"
	path_grouping_policy	multibus
	getuid_callout	"/lib/udev/scsi_id -g -u -s /block/%n"
	rr_min_io	100
	rr_weight	priorities
	failback	immediate
	user_friendly_names no
}
	

blacklist {
	wwid 26353900f02796769
	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
	devnode "^hd[a-z][[0-9]*]"
	devnode "^sda[[0-9]*]"
	devnode "^sda"
	devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
	device {
		vendor DEC.*
		product MSA[15]00
	}
}

multipaths {
	multipath {
		wwid			360060160d8c31201b072ab33e482db11
		alias			ax100backup
		path_grouping_policy	multibus
		path_selector		"round-robin 0"
		failback		immediate
		rr_min_io	100
	}

	multipath {
		wwid			360060160d8c3120166e30680e382db11
        alias                   ax100big
        path_grouping_policy    multibus
        path_selector           "round-robin 0"
        failback                immediate
        rr_min_io       100
	}

	multipath {
		wwid			360060160d8c31201e4001ee3c698db11
        alias                   ax100edv
        path_grouping_policy    multibus
        path_selector           "round-robin 0"
        failback                immediate
        rr_min_io       100
    }

}

devices {
	device {
		vendor			"DGC     "
		product			"RAID 5        "
		path_grouping_policy	multibus
		getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
		prio_callout          "/sbin/mpath_prio_balance_units %d"
		path_checker		emc_clariion
		path_selector		"round-robin 0"
		failback		immediate
		rr_min_io	100
		hardware_handler "1 emc"
	}
}

--------------080706090203000403080604
Content-Type: text/plain;
 name="multipath.conf.minimal"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath.conf.minimal"

blacklist {
        wwid 26353900f02796769
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z][[0-9]*]"
        devnode "^sda[[0-9]*]"
        devnode "^sda"
        devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
        device {
                vendor DEC.*
                product MSA[15]00
        }
}

multipaths {
        multipath {
                wwid                    360060160d8c31201b072ab33e482db11
                alias                   ax100backup
        }

        multipath {
                wwid                    360060160d8c3120166e30680e382db11
                alias                   ax100big
        }

        multipath {
                wwid                    360060160d8c31201e4001ee3c698db11
                alias                   ax100edv
        }

}

--------------080706090203000403080604
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080706090203000403080604--
