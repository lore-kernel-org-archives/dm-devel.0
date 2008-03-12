From: Jacek Lipkowski <sq5bpf@lipkowski.org>
Subject: Re: dm-rdac problem
Date: Wed, 12 Mar 2008 20:21:19 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803121950240.5697@paranoid.lipkowski.org>
References: <Pine.LNX.4.64.0803121506220.5697@paranoid.lipkowski.org>
	<1205345663.31859.47.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1205345663.31859.47.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 12 Mar 2008, Chandra Seetharaman wrote:

> Can you send the o/p of "multipath -v4".

The full log is attached at the end (discovering the scsi devices, 
loading dm_multipath, with a tail -f of the logs in the 
background.

> Also, can you change the prio_callout from mpath_prio_rdac to 
> mpath_prio_tpc.

But aren't they the same thing? The only change between pp_tpc.c from 
0.4.7 and pp_rdac.c from 0.4.8 seems to be renaming sgi_tpc_prio() to 
rdac_prio(). There is no mpath_prio_tpc in 0.4.8.

mpath_prio_rdac seems to work correctly:
[root@xfs-pco ~]# /sbin/mpath_prio_rdac /dev/sda
0
[root@xfs-pco ~]# /sbin/mpath_prio_rdac /dev/sdb
3
[root@xfs-pco ~]# /sbin/mpath_prio_rdac /dev/sdc
3
[root@xfs-pco ~]# /sbin/mpath_prio_rdac /dev/sdd
0

> If you are running in AVT, you do not need dm-rdac (or the rdac path
> checker) at all. Do you see any problems if you do not have them in your
> multipath.conf file ?

Because i've thought, that the switchover will be faster. Also i don't 
have to set which paths are preferred, and which are not, mpath_prio_rdac 
takes care of that.

jacek

The logs from (uname -a, lsmod, modprobe qla2xxx, multipath -v4)

Script started on Wed 12 Mar 2008 09:28:03 PM CET
[root@xfs-pco ~]# uname -a
Linux xfs-pco 2.6.24.3-sq5bpf1 #1 SMP Mon Mar 10 21:15:09 CET 2008 i686 i686 i386 GNU/Linux
[root@xfs-pco ~]# lsmod
Module                  Size  Used by
ipv6                  243076  18 
hidp                   22400  2 
l2cap                  26880  5 hidp
bluetooth              57700  2 hidp,l2cap
dm_mirror              25472  0 
dm_mod                 59844  1 dm_mirror
sbs                    18440  0 
sbshc                  10880  1 sbs
battery                17668  0 
ac                     10244  0 
lp                     16036  0 
ide_cd                 40224  0 
floppy                 57988  0 
parport_pc             30628  1 
cdrom                  36640  1 ide_cd
button                 12560  0 
parport                38216  2 lp,parport_pc
serio_raw              10756  0 
cpqphp                 62024  0 
e1000                 116800  0 
e100                   38412  0 
pcspkr                  7168  0 
i2c_piix4              12300  0 
mii                     9344  1 e100
i2c_core               26496  1 i2c_piix4
scsi_transport_fc      44420  0 
sd_mod                 30976  0 
scsi_mod              144396  2 scsi_transport_fc,sd_mod
DAC960                 69704  4 
ext3                  126216  2 
jbd                    47252  1 ext3
ehci_hcd               36364  0 
ohci_hcd               25860  0 
uhci_hcd               27152  0 
[root@xfs-pco ~]# tail -f /var/log/syslg &
[1] 2707
[root@xfs-pco ~]# Mar 12 21:25:37 xfs-pco kernel: Bluetooth: HCI device and connection manager initialized
Mar 12 21:25:37 xfs-pco kernel: Bluetooth: HCI socket layer initialized
Mar 12 21:25:37 xfs-pco kernel: Bluetooth: L2CAP ver 2.9
Mar 12 21:25:37 xfs-pco kernel: Bluetooth: L2CAP socket layer initialized
Mar 12 21:25:37 xfs-pco kernel: Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Mar 12 21:25:37 xfs-pco kernel: NET: Registered protocol family 10
Mar 12 21:25:37 xfs-pco kernel: lo: Disabled Privacy Extensions
Mar 12 21:25:37 xfs-pco kernel: eth0: no IPv6 routers present
Mar 12 21:27:45 xfs-pco sshd[2645]: Accepted password for root from 172.18.5.1 port 44603 ssh2
Mar 12 21:27:45 xfs-pco sshd[2645]: pam_unix(sshd:session): session opened for user root by (uid=0)

[root@xfs-pco ~]# modprobe qla2xxx
Mar 12 21:28:47 xfs-pco kernel: QLogic Fibre Channel HBA Driver
Mar 12 21:28:47 xfs-pco kernel: ACPI: PCI Interrupt 0000:07:0d.0[A] -> GSI 17 (level, low) -> IRQ 17
Mar 12 21:28:47 xfs-pco kernel: qla2xxx 0000:07:0d.0: Found an ISP2312, irq 17, iobase 0xf88ce000
Mar 12 21:28:47 xfs-pco kernel: qla2xxx 0000:07:0d.0: Configuring PCI space...
Mar 12 21:28:47 xfs-pco kernel: qla2xxx 0000:07:0d.0: Configure NVRAM parameters...
Mar 12 21:28:47 xfs-pco kernel: qla2xxx 0000:07:0d.0: Verifying loaded RISC code...
Mar 12 21:28:47 xfs-pco kernel: qla2xxx 0000:07:0d.0: Allocated (412 KB) for firmware dump...
Mar 12 21:28:47 xfs-pco kernel: qla2xxx 0000:07:0d.0: LIP reset occured (f7f7).
Mar 12 21:28:47 xfs-pco kernel: scsi2 : qla2xxx
Mar 12 21:28:47 xfs-pco kernel: qla2xxx 0000:07:0d.0: LOOP UP detected (2 Gbps).
Mar 12 21:28:48 xfs-pco kernel: scsi 2:0:0:1: Direct-Access     IBM      1742-900         0914 PQ: 0 ANSI: 5
Mar 12 21:28:48 xfs-pco kernel: sd 2:0:0:1: [sda] 3145728000 512-byte hardware sectors (1610613 MB)
Mar 12 21:28:48 xfs-pco kernel: sd 2:0:0:1: [sda] Write Protect is off
Mar 12 21:28:48 xfs-pco kernel: sd 2:0:0:1: [sda] Mode Sense: 77 00 10 08
Mar 12 21:28:48 xfs-pco kernel: sd 2:0:0:1: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
Mar 12 21:28:48 xfs-pco kernel: sd 2:0:0:1: [sda] 3145728000 512-byte hardware sectors (1610613 MB)
Mar 12 21:28:48 xfs-pco kernel: sd 2:0:0:1: [sda] Write Protect is off
Mar 12 21:28:48 xfs-pco kernel: sd 2:0:0:1: [sda] Mode Sense: 77 00 10 08
Mar 12 21:28:48 xfs-pco kernel: sd 2:0:0:1: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
Mar 12 21:28:48 xfs-pco kernel:  sda:<6>qla2xxx 0000:07:0d.0: 
Mar 12 21:28:48 xfs-pco kernel:  QLogic Fibre Channel HBA Driver: 8.02.00-k5
Mar 12 21:28:48 xfs-pco kernel:   QLogic QLA2340 - 133MHz PCI-X to 2Gb FC, Single Channel
Mar 12 21:28:48 xfs-pco kernel:   ISP2312: PCI (66 MHz) @ 0000:07:0d.0 hdma+, host#=2, fw=3.03.20 IPX
Mar 12 21:28:48 xfs-pco kernel: ACPI: PCI Interrupt 0000:07:0e.0[A] -> GSI 19 (level, low) -> IRQ 18
Mar 12 21:28:48 xfs-pco kernel: qla2xxx 0000:07:0e.0: Found an ISP2312, irq 18, iobase 0xf89f6000
Mar 12 21:28:48 xfs-pco kernel: qla2xxx 0000:07:0e.0: Configuring PCI space...
Mar 12 21:28:48 xfs-pco kernel: qla2xxx 0000:07:0e.0: Configure NVRAM parameters...
Mar 12 21:28:48 xfs-pco kernel: qla2xxx 0000:07:0e.0: Verifying loaded RISC code...
Mar 12 21:28:48 xfs-pco kernel: qla2xxx 0000:07:0e.0: Allocated (412 KB) for firmware dump...
Mar 12 21:28:48 xfs-pco kernel: qla2xxx 0000:07:0e.0: LIP reset occured (f7f7).
Mar 12 21:28:48 xfs-pco kernel: scsi3 : qla2xxx
Mar 12 21:28:48 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:28:49 xfs-pco kernel: qla2xxx 0000:07:0e.0: LOOP UP detected (2 Gbps).
Mar 12 21:28:49 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:28:49 xfs-pco kernel: printk: 1 messages suppressed.
Mar 12 21:28:49 xfs-pco kernel: Buffer I/O error on device sda, logical block 0
[root@xfs-pco ~]# Mar 12 21:28:49 xfs-pco kernel: scsi 3:0:0:1: Direct-Access     IBM      1742-900         0914 PQ: 0 ANSI: 5
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:1: [sdb] 3145728000 512-byte hardware sectors (1610613 MB)
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:1: [sdb] Write Protect is off
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:1: [sdb] Mode Sense: 77 00 10 08
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:1: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:1: [sdb] 3145728000 512-byte hardware sectors (1610613 MB)
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:1: [sdb] Write Protect is off
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:1: [sdb] Mode Sense: 77 00 10 08
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:1: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
Mar 12 21:28:49 xfs-pco kernel:  sdb: unknown partition table
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:1: [sdb] Attached SCSI disk
Mar 12 21:28:49 xfs-pco kernel: scsi 3:0:0:2: Direct-Access     IBM      1742-900         0914 PQ: 0 ANSI: 5
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:2: [sdc] 204800 512-byte hardware sectors (105 MB)
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:2: [sdc] Write Protect is off
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:2: [sdc] Mode Sense: 77 00 10 08
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:2: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
Mar 12 21:28:49 xfs-pco kernel: qla2xxx 0000:07:0e.0: 
Mar 12 21:28:49 xfs-pco kernel:  QLogic Fibre Channel HBA Driver: 8.02.00-k5
Mar 12 21:28:49 xfs-pco kernel:   QLogic QLA2340 - 133MHz PCI-X to 2Gb FC, Single Channel
Mar 12 21:28:49 xfs-pco kernel:   ISP2312: PCI (66 MHz) @ 0000:07:0e.0 hdma+, host#=3, fw=3.03.20 IPX
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:2: [sdc] 204800 512-byte hardware sectors (105 MB)
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:2: [sdc] Write Protect is off
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:2: [sdc] Mode Sense: 77 00 10 08
Mar 12 21:28:49 xfs-pco kernel: sd 3:0:0:2: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
Mar 12 21:28:49 xfs-pco kernel:  sdc: unknown partition table
Mar 12 21:28:50 xfs-pco kernel: sd 3:0:0:2: [sdc] Attached SCSI disk
Mar 12 21:28:50 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:28:50 xfs-pco kernel: sd 3:0:0:1: Attached scsi generic sg0 type 0
Mar 12 21:28:50 xfs-pco kernel: sd 3:0:0:2: Attached scsi generic sg1 type 0
Mar 12 21:28:50 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:28:51 xfs-pco last message repeated 3 times
Mar 12 21:28:51 xfs-pco kernel: Dev sda: unable to read RDB block 0
Mar 12 21:28:52 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:28:52 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:28:52 xfs-pco kernel:  unable to read partition table
Mar 12 21:28:52 xfs-pco kernel: sd 2:0:0:1: [sda] Attached SCSI disk
Mar 12 21:28:52 xfs-pco kernel: sd 2:0:0:1: Attached scsi generic sg2 type 0
Mar 12 21:28:52 xfs-pco kernel: scsi 2:0:0:2: Direct-Access     IBM      1742-900         0914 PQ: 0 ANSI: 5
Mar 12 21:28:52 xfs-pco kernel: sd 2:0:0:2: [sdd] 204800 512-byte hardware sectors (105 MB)
Mar 12 21:28:52 xfs-pco kernel: sd 2:0:0:2: [sdd] Write Protect is off
Mar 12 21:28:52 xfs-pco kernel: sd 2:0:0:2: [sdd] Mode Sense: 77 00 10 08
Mar 12 21:28:52 xfs-pco kernel: sd 2:0:0:2: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
Mar 12 21:28:52 xfs-pco kernel: sd 2:0:0:2: [sdd] 204800 512-byte hardware sectors (105 MB)
Mar 12 21:28:52 xfs-pco kernel: sd 2:0:0:2: [sdd] Write Protect is off
Mar 12 21:28:52 xfs-pco kernel: sd 2:0:0:2: [sdd] Mode Sense: 77 00 10 08
Mar 12 21:28:52 xfs-pco kernel: sd 2:0:0:2: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
Mar 12 21:28:53 xfs-pco kernel:  sdd:end_request: I/O error, dev sdd, sector 0
Mar 12 21:28:53 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727872
Mar 12 21:28:53 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:28:54 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727872
Mar 12 21:28:54 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:28:54 xfs-pco kernel: printk: 11 messages suppressed.
Mar 12 21:28:54 xfs-pco kernel: Buffer I/O error on device sdd, logical block 0
Mar 12 21:28:54 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:28:54 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:28:55 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:28:55 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:28:55 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:28:55 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:28:56 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:28:56 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:28:56 xfs-pco kernel: Dev sdd: unable to read RDB block 0
Mar 12 21:28:56 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:28:56 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:28:57 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:28:57 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:28:57 xfs-pco kernel:  unable to read partition table
Mar 12 21:28:57 xfs-pco kernel: sd 2:0:0:2: [sdd] Attached SCSI disk
Mar 12 21:28:57 xfs-pco kernel: sd 2:0:0:2: Attached scsi generic sg3 type 0
Mar 12 21:28:57 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727936
Mar 12 21:28:57 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204672
Mar 12 21:28:58 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727984
Mar 12 21:28:58 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204672
Mar 12 21:28:58 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:28:58 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204792
Mar 12 21:28:59 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:28:59 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204792
Mar 12 21:28:59 xfs-pco kernel: printk: 19 messages suppressed.
Mar 12 21:28:59 xfs-pco kernel: Buffer I/O error on device sdd, logical block 25599
Mar 12 21:28:59 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:28:59 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204792
Mar 12 21:29:00 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:00 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204792
Mar 12 21:29:00 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:00 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204792
Mar 12 21:29:01 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:01 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204792
Mar 12 21:29:01 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:01 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204736
Mar 12 21:29:02 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:02 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204784
Mar 12 21:29:02 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:02 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204792
Mar 12 21:29:03 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:03 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204792
Mar 12 21:29:03 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:03 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:04 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:04 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:04 xfs-pco kernel: printk: 19 messages suppressed.
Mar 12 21:29:04 xfs-pco kernel: Buffer I/O error on device sdd, logical block 0
Mar 12 21:29:04 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:04 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:05 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:05 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:05 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:05 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:06 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:06 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:06 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:06 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:07 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:07 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:07 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:07 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:08 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:08 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:08 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:08 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:09 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:09 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:09 xfs-pco kernel: printk: 19 messages suppressed.
Mar 12 21:29:09 xfs-pco kernel: Buffer I/O error on device sdd, logical block 0
Mar 12 21:29:09 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:10 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:10 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:10 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:10 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:11 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:11 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:11 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:11 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:12 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:12 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:12 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:12 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:13 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:13 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:13 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:13 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727872
Mar 12 21:29:14 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:14 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727872
Mar 12 21:29:14 xfs-pco kernel: printk: 18 messages suppressed.
Mar 12 21:29:14 xfs-pco kernel: Buffer I/O error on device sda, logical block 393215984
Mar 12 21:29:14 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:14 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:29:15 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:15 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:29:15 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:15 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:29:16 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:16 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:29:16 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:16 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:29:17 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:17 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:29:17 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:17 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727936
Mar 12 21:29:18 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727984
Mar 12 21:29:18 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:29:19 xfs-pco kernel: end_request: I/O error, dev sda, sector 3145727992
Mar 12 21:29:19 xfs-pco kernel: printk: 16 messages suppressed.
Mar 12 21:29:19 xfs-pco kernel: Buffer I/O error on device sda, logical block 393215999
Mar 12 21:29:19 xfs-pco kernel: end_request: I/O error, dev sda, sector 0
Mar 12 21:29:23 xfs-pco last message repeated 7 times
Mar 12 21:29:23 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204672
Mar 12 21:29:24 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204672
Mar 12 21:29:24 xfs-pco kernel: printk: 9 messages suppressed.
Mar 12 21:29:24 xfs-pco kernel: Buffer I/O error on device sdd, logical block 25584
Mar 12 21:29:24 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204792
Mar 12 21:29:27 xfs-pco last message repeated 5 times
Mar 12 21:29:27 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204736
Mar 12 21:29:28 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204784
Mar 12 21:29:28 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204792
Mar 12 21:29:29 xfs-pco kernel: end_request: I/O error, dev sdd, sector 204792
Mar 12 21:29:29 xfs-pco kernel: printk: 9 messages suppressed.
Mar 12 21:29:29 xfs-pco kernel: Buffer I/O error on device sdd, logical block 25599
Mar 12 21:29:29 xfs-pco kernel: end_request: I/O error, dev sdd, sector 0
Mar 12 21:29:33 xfs-pco last message repeated 7 times
Mar 12 21:30:05 xfs-pco sshd[2918]: Accepted password for root from 172.18.5.1 port 41392 ssh2
Mar 12 21:30:05 xfs-pco sshd[2918]: pam_unix(sshd:session): session opened for user root by (uid=0)

[root@xfs-pco ~]# modprobe dm_multipath
[root@xfs-pco ~]# Mar 12 21:30:56 xfs-pco kernel: device-mapper: multipath: version 1.0.5 loaded
multipath -v4
Discover device /sys/block/ram0
ram0: device node name blacklisted
Discover device /sys/block/ram1
ram1: device node name blacklisted
Discover device /sys/block/ram2
ram2: device node name blacklisted
Discover device /sys/block/ram3
ram3: device node name blacklisted
Discover device /sys/block/ram4
ram4: device node name blacklisted
Discover device /sys/block/ram5
ram5: device node name blacklisted
Discover device /sys/block/ram6
ram6: device node name blacklisted
Discover device /sys/block/ram7
ram7: device node name blacklisted
Discover device /sys/block/ram8
ram8: device node name blacklisted
Discover device /sys/block/ram9
ram9: device node name blacklisted
Discover device /sys/block/ram10
ram10: device node name blacklisted
Discover device /sys/block/ram11
ram11: device node name blacklisted
Discover device /sys/block/ram12
ram12: device node name blacklisted
Discover device /sys/block/ram13
ram13: device node name blacklisted
Discover device /sys/block/ram14
ram14: device node name blacklisted
Discover device /sys/block/ram15
ram15: device node name blacklisted
Discover device /sys/block/rd!c0d0
path /sys/block/rd!c0d0/device not present
Discover device /sys/block/rd!c0d1
path /sys/block/rd!c0d1/device not present
Discover device /sys/block/rd!c0d2
path /sys/block/rd!c0d2/device not present
Discover device /sys/block/rd!c0d3
path /sys/block/rd!c0d3/device not present
Discover device /sys/block/rd!c0d4
path /sys/block/rd!c0d4/device not present
Discover device /sys/block/rd!c0d5
path /sys/block/rd!c0d5/device not present
Discover device /sys/block/rd!c0d6
path /sys/block/rd!c0d6/device not present
Discover device /sys/block/rd!c0d7
path /sys/block/rd!c0d7/device not present
Discover device /sys/block/rd!c0d8
path /sys/block/rd!c0d8/device not present
Discover device /sys/block/rd!c0d9
path /sys/block/rd!c0d9/device not present
Discover device /sys/block/rd!c0d10
path /sys/block/rd!c0d10/device not present
Discover device /sys/block/rd!c0d11
path /sys/block/rd!c0d11/device not present
Discover device /sys/block/rd!c0d12
path /sys/block/rd!c0d12/device not present
Discover device /sys/block/rd!c0d13
path /sys/block/rd!c0d13/device not present
Discover device /sys/block/rd!c0d14
path /sys/block/rd!c0d14/device not present
Discover device /sys/block/rd!c0d15
path /sys/block/rd!c0d15/device not present
Discover device /sys/block/rd!c0d16
path /sys/block/rd!c0d16/device not present
Discover device /sys/block/rd!c0d17
path /sys/block/rd!c0d17/device not present
Discover device /sys/block/rd!c0d18
path /sys/block/rd!c0d18/device not present
Discover device /sys/block/rd!c0d19
path /sys/block/rd!c0d19/device not present
Discover device /sys/block/rd!c0d20
path /sys/block/rd!c0d20/device not present
Discover device /sys/block/rd!c0d21
path /sys/block/rd!c0d21/device not present
Discover device /sys/block/rd!c0d22
path /sys/block/rd!c0d22/device not present
Discover device /sys/block/rd!c0d23
path /sys/block/rd!c0d23/device not present
Discover device /sys/block/rd!c0d24
path /sys/block/rd!c0d24/device not present
Discover device /sys/block/rd!c0d25
path /sys/block/rd!c0d25/device not present
Discover device /sys/block/rd!c0d26
path /sys/block/rd!c0d26/device not present
Discover device /sys/block/rd!c0d27
path /sys/block/rd!c0d27/device not present
Discover device /sys/block/rd!c0d28
path /sys/block/rd!c0d28/device not present
Discover device /sys/block/rd!c0d29
path /sys/block/rd!c0d29/device not present
Discover device /sys/block/rd!c0d30
path /sys/block/rd!c0d30/device not present
Discover device /sys/block/rd!c0d31
path /sys/block/rd!c0d31/device not present
Discover device /sys/block/fd0
fd0: device node name blacklisted
Discover device /sys/block/hda
hda: device node name blacklisted
Discover device /sys/block/md0
md0: device node name blacklisted
Discover device /sys/block/sda
sda: not found in pathvec
sda: mask = 0x1f
sda: dev_t = 8:0
sda: size = 3145728000
sda: subsystem = scsi
sda: vendor = IBM 
sda: product = 1742-900 
sda: rev = 0914
sda: h:b:t:l = 2:0:0:1
sda: tgt_node_name = 0x200600a0b80feca
sda: serial = 1T32184792 
sda: getprio = /sbin/mpath_prio_rdac /dev/%n (controller setting)
sda: prio = 0
sda: getuid = /sbin/scsi_id -g -u -s /block/%n (controller setting)
sda: uid = 3600a0b80000f897f00000a4d47c63cf7 (callout)
Discover device /sys/block/sdb
sdb: not found in pathvec
sdb: mask = 0x1f
sdb: dev_t = 8:16
sdb: size = 3145728000
sdb: subsystem = scsi
sdb: vendor = IBM 
sdb: product = 1742-900 
sdb: rev = 0914
sdb: h:b:t:l = 3:0:0:1
sdb: tgt_node_name = 0x200600a0b80feca
sdb: serial = 1T32287661 
sdb: getprio = /sbin/mpath_prio_rdac /dev/%n (controller setting)
sdb: prio = 3
sdb: getuid = /sbin/scsi_id -g -u -s /block/%n (controller setting)
sdb: uid = 3600a0b80000f897f00000a4d47c63cf7 (callout)
Discover device /sys/block/sdc
sdc: not found in pathvec
sdc: mask = 0x1f
sdc: dev_t = 8:32
sdc: size = 204800
sdc: subsystem = scsi
sdc: vendor = IBM 
sdc: product = 1742-900 
sdc: rev = 0914
sdc: h:b:t:l = 3:0:0:2
sdc: tgt_node_name = 0x200600a0b80feca
sdc: serial = 1T32287661 
sdc: getprio = /sbin/mpath_prio_rdac /dev/%n (controller setting)
sdc: prio = 3
sdc: getuid = /sbin/scsi_id -g -u -s /block/%n (controller setting)
sdc: uid = 3600a0b80000f897f00000a9347d0bec1 (callout)
Discover device /sys/block/sdd
sdd: not found in pathvec
sdd: mask = 0x1f
sdd: dev_t = 8:48
sdd: size = 204800
sdd: subsystem = scsi
sdd: vendor = IBM 
sdd: product = 1742-900 
sdd: rev = 0914
sdd: h:b:t:l = 2:0:0:2
sdd: tgt_node_name = 0x200600a0b80feca
sdd: serial = 1T32184792 
sdd: getprio = /sbin/mpath_prio_rdac /dev/%n (controller setting)
sdd: prio = 0
sdd: getuid = /sbin/scsi_id -g -u -s /block/%n (controller setting)
sdd: uid = 3600a0b80000f897f00000a9347d0bec1 (callout)
Discovery status 0
===== paths list =====
uuid                              hcil    dev dev_t pri dm_st  chk_st  vend/pr
3600a0b80000f897f00000a4d47c63cf7 2:0:0:1 sda 8:0   0   [undef][undef] IBM 
3600a0b80000f897f00000a4d47c63cf7 3:0:0:1 sdb 8:16  3   [undef][undef] IBM 
3600a0b80000f897f00000a9347d0bec1 3:0:0:2 sdc 8:32  3   [undef][undef] IBM 
3600a0b80000f897f00000a9347d0bec1 2:0:0:2 sdd 8:48  0   [undef][undef] IBM 
Found matching wwid [3600a0b80000f897f00000a4d47c63cf7] in bindings file. Setting alias to mpath0
sda: ownership set to mpath0
sda: not found in pathvec
sda: mask = 0xc
sda: path checker = rdac (controller setting)
sda: state = 4
sda: prio = 0
sdb: ownership set to mpath0
sdb: not found in pathvec
sdb: mask = 0xc
sdb: path checker = rdac (controller setting)
sdb: state = 2
sdb: prio = 3
mpath0: pgfailback = -2 (controller setting)
mpath0: pgpolicy = group_by_prio (controller setting)
mpath0: selector = round-robin (internal default)
mpath0: features = 0 (internal default)
mpath0: hwhandler = 1 rdac (controller setting)
mpath0: rr_weight = 1 (internal default)
mpath0: minio = 1000 (config file default)
mpath0: no_path_retry = NONE (internal default)
pg_timeout = NONE (internal default)
mpath0: set ACT_CREATE (map does not exist)
libdevmapper: ioctl/libdm-iface.c(1589): device-mapper: reload ioctl failed: Invalid argument
mpath0: domap (0) failure for create/reload map
mpath0: remove multipath map
sda: orphaned
sdb: orphaned
Found matching wwid [3600a0b80000f897f00000a4d47c63cf7] in bindings file. Setting alias to mpath0
sda: ownership set to mpath0
sda: not found in pathvec
sda: mask = 0xc
sda: path checker = rdac (controller setting)
sda: state = 4
sda: getprio = /sbin/mpath_prio_rdac /dev/%n (controller setting)
sda: prio = 0
sdb: ownership set to mpath0
sdb: not found in pathvec
sdb: mask = 0xc
sdb: path checker = rdac (controller setting)
sdb: state = 2
sdb: getprio = /sbin/mpath_prio_rdac /dev/%n (controller setting)
sdb: prio = 3
mpath0: pgfailback = -2 (controller setting)
mpath0: pgpolicy = group_by_prio (controller setting)
mpath0: selector = round-robin (internal default)
mpath0: features = 0 (internal default)
mpath0: hwhandler = 1 rdac (controller setting)
mpath0: rr_weight = 1 (internal default)
mpath0: minio = 1000 (config file default)
mpath0: no_path_retry = NONE (internal default)
pg_timeout = NONE (internal default)
mpath0: set ACT_CREATE (map does not exist)
libdevmapper: ioctl/libdm-iface.c(1589): device-mapper: reload ioctl failed: Invalid argument
mpath0: domap (0) failure for create/reload map
mpath0: remove multipath map
sda: orphaned
sdb: orphaned
Found matching wwid [3600a0b80000f897f00000a9347d0bec1] in bindings file. Setting alias to mpath1
sdc: ownership set to mpath1
sdc: not found in pathvec
sdc: mask = 0xc
sdc: path checker = rdac (controller setting)
sdc: state = 2
sdc: prio = 3
sdd: ownership set to mpath1
sdd: not found in pathvec
sdd: mask = 0xc
sdd: path checker = rdac (controller setting)
sdd: state = 4
sdd: prio = 0
mpath1: pgfailback = -2 (controller setting)
mpath1: pgpolicy = group_by_prio (controller setting)
mpath1: selector = round-robin (internal default)
mpath1: features = 0 (internal default)
mpath1: hwhandler = 1 rdac (controller setting)
mpath1: rr_weight = 1 (internal default)
mpath1: minio = 1000 (config file default)
mpath1: no_path_retry = NONE (internal default)
pg_timeout = NONE (internal default)
mpath1: set ACT_CREATE (map does not exist)
libdevmapper: ioctl/libdm-iface.c(1589): device-mapper: reload ioctl failed: Invalid argument
mpath1: domap (0) failure for create/reload map
mpath1: remove multipath map
sdc: orphaned
sdd: orphaned
Found matching wwid [3600a0b80000f897f00000a9347d0bec1] in bindings file. Setting alias to mpath1
sdc: ownership set to mpath1
sdc: not found in pathvec
sdc: mask = 0xc
sdc: path checker = rdac (controller setting)
sdc: state = 2
sdc: getprio = /sbin/mpath_prio_rdac /dev/%n (controller setting)
sdc: prio = 3
sdd: ownership set to mpath1
sdd: not found in pathvec
sdd: mask = 0xc
sdd: path checker = rdac (controller setting)
sdd: state = 4
sdd: getprio = /sbin/mpath_prio_rdac /dev/%n (controller setting)
sdd: prio = 0
mpath1: pgfailback = -2 (controller setting)
mpath1: pgpolicy = group_by_prio (controller setting)
mpath1: selector = round-robin (internal default)
mpath1: features = 0 (internal default)
mpath1: hwhandler = 1 rdac (controller setting)
mpath1: rr_weight = 1 (internal default)
mpath1: minio = 1000 (config file default)
mpath1: no_path_retry = NONE (internal default)
pg_timeout = NONE (internal default)
mpath1: set ACT_CREATE (map does not exist)
libdevmapper: ioctl/libdm-iface.c(1589): device-mapper: reload ioctl failed: Invalid argument
mpath1: domap (0) failure for create/reload map
mpath1: remove multipath map
sdc: orphaned
sdd: orphaned
[root@xfs-pco ~]# Mar 12 21:31:06 xfs-pco kernel: device-mapper: multipath rdac: rdac: version 0.4 loaded
Mar 12 21:31:06 xfs-pco kernel: device-mapper: multipath rdac: using RDAC command with timeout 60000
Mar 12 21:31:06 xfs-pco kernel: device-mapper: multipath round-robin: version 1.0.0 loaded
Mar 12 21:31:06 xfs-pco kernel: device-mapper: table: 253:0: multipath: Unknown error
Mar 12 21:31:06 xfs-pco kernel: device-mapper: ioctl: error adding target to table
Mar 12 21:31:06 xfs-pco kernel: device-mapper: multipath rdac: using RDAC command with timeout 60000
Mar 12 21:31:06 xfs-pco kernel: device-mapper: table: 253:0: multipath: Unknown error
Mar 12 21:31:06 xfs-pco kernel: device-mapper: ioctl: error adding target to table
Mar 12 21:31:06 xfs-pco kernel: device-mapper: multipath rdac: using RDAC command with timeout 60000
Mar 12 21:31:06 xfs-pco kernel: device-mapper: table: 253:0: multipath: Unknown error
Mar 12 21:31:06 xfs-pco kernel: device-mapper: ioctl: error adding target to table
Mar 12 21:31:06 xfs-pco kernel: device-mapper: multipath rdac: using RDAC command with timeout 60000
Mar 12 21:31:06 xfs-pco kernel: device-mapper: table: 253:0: multipath: Unknown error
Mar 12 21:31:06 xfs-pco kernel: device-mapper: ioctl: error adding target to table

[root@xfs-pco ~]# multipath -ll
[root@xfs-pco ~]#

Script done on Wed 12 Mar 2008 09:33:56 PM CET
