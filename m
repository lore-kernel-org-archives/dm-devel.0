From: "Jeffry R. Abramson" <vze2pq4d@verizon.net>
Subject: multipath on IBM/Adaptec DS400 disk arrays on RHEL4U2
	x86_64
Date: Thu, 05 Jan 2006 15:03:17 -0600 (CST)
Message-ID: <3980938.1136494997224.JavaMail.root@vms170.mailsrvcs.net>
Reply-To: jabramson@alumni.virginia.edu,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Like the subject says, has anyone gotten this to work?  Our hardware
configuration is an IBM blade chassis with LS20 blades running RHEL4
Update 2 x86_64.  Each blade is equipped with two internal SCSI drives
mirrored via a LSI 53C1030 RAID controller. Fiber channel connectivity
is through a dual port Qlogic QLA2312 adapter and Qlogic 5202
switches.  Two independent SAN fabric's are used.  The DS400 disk
arrays are equipped with two controllers in an active/passive A/B
configuration.  For now, the passive controller is zoned out to
simplify debugging.  Each controller has two FC interfaces configured
as follows:

----[ Initiator 'blade6_FC0' ]------------------------------------------

                 WWN:  21000011259350e8
                Name:  blade6_FC0
                  ID:  0
         Port access:
                       Port A0        Port A1        Port B0        Port B1
---------------------------------------------------------------------------
                       YES            NO             YES            NO


        LUN Mappings:
                 LUN                 logical        [Capacity]
---------------------------------------------------------------------------

                 0                   Device-1       [683.48GB]
                 1                   Device-2       [683.48GB]

----[ Initiator 'blade6_FC1' ]------------------------------------------

                 WWN:  21000011259350e9
                Name:  blade6_FC1
                  ID:  2
         Port access:
                       Port A0        Port A1        Port B0        Port B1
---------------------------------------------------------------------------
                       NO             YES            NO             YES


        LUN Mappings:
                 LUN                 logical        [Capacity]
---------------------------------------------------------------------------

                 0                   Device-1       [683.48GB]
                 1                   Device-2       [683.48GB]

The two san fabrics are completely independent so with this
configuration there should be two paths to each logical device.  fdisk
-l yields the following:

Disk /dev/sda: 73.2 GB, 73272393728 bytes
255 heads, 63 sectors/track, 8908 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          33      265041   83  Linux
/dev/sda2              34        1077     8385930   82  Linux swap
/dev/sda3            1078        8908    62902507+  8e  Linux LVM

Disk /dev/sdb: 733.8 GB, 733877370880 bytes
255 heads, 63 sectors/track, 89222 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sdb doesn't contain a valid partition table

Disk /dev/sdc: 733.8 GB, 733877370880 bytes
255 heads, 63 sectors/track, 89222 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sdc doesn't contain a valid partition table

Disk /dev/sdd: 733.8 GB, 733877370880 bytes
255 heads, 63 sectors/track, 89222 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sdd doesn't contain a valid partition table

Disk /dev/sde: 733.8 GB, 733877370880 bytes
255 heads, 63 sectors/track, 89222 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sde doesn't contain a valid partition table

pvs yields the following:
  PV         VG          Fmt  Attr PSize  PFree
  /dev/sda3  VolGroup_OS lvm2 a-   59.97G 5.97G

lvs yields the following:
  LV   VG          Attr   LSize  Origin Snap%  Move Log Copy%
  home VolGroup_OS -wi-ao  8.00G
  opt  VolGroup_OS -wi-ao  8.00G
  root VolGroup_OS -wi-ao  2.00G
  tmp  VolGroup_OS -wi-ao  8.00G
  usr  VolGroup_OS -wi-ao 24.00G
  var  VolGroup_OS -wi-ao  4.00G

cat /proc/scsi/scsi returns the following:

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: LSILOGIC Model: 1030          IM Rev: 1000
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: DS400    S320    Rev: 7.00
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 01
  Vendor: IBM      Model: DS400    S320    Rev: 7.00
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: DS400    S320    Rev: 7.00
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi2 Channel: 00 Id: 00 Lun: 01
  Vendor: IBM      Model: DS400    S320    Rev: 7.00
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: TEAC     Model: FD-05PUB         Rev: 3200
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVD-ROM GDR8082N Rev: 0L03
  Type:   CD-ROM                           ANSI SCSI revision: 02

cat /proc/scsi/qla2xxx/1 returns:
QLogic PCI to Fibre Channel Host Adapter for IBM FCEC:
        Firmware version 3.03.15 IPX, Driver version 8.01.00b5-rh2
ISP: ISP2312, Serial# N04656
Request Queue = 0x11fd80000, Response Queue = 0x11fca0000
Request Queue count = 4096, Response Queue count = 512
Total number of active commands = 0
Total number of interrupts = 358
    Device queue depth = 0x20
Number of free request entries = 3779
Number of mailbox timeouts = 0
Number of ISP aborts = 0
Number of loop resyncs = 0
Number of retries for empty slots = 0
Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
Host adapter:loop state = <READY>, flags = 0x1a03
Dpc flags = 0x0
MBX flags = 0x0
Link down Timeout = 030
Port down retry = 030
Login retry count = 030
Commands retried with dropped frame(s) = 0
Product ID = 4953 5020 2020 0002


SCSI Device Information:
scsi-qla0-adapter-node=20000011259350e8;
scsi-qla0-adapter-port=21000011259350e8;
scsi-qla0-target-0=21000000d12671dd;

FC Port Information:
scsi-qla0-port-0=20000000d12671dd:21000000d12671dd:010f00:81;

SCSI LUN Information:
(Id:Lun)  * - indicates lun is not registered with the OS.
( 0: 0): Total reqs 132, Pending reqs 0, flags 0x0, 0:0:81 00
( 0: 1): Total reqs 131, Pending reqs 0, flags 0x0, 0:0:81 00

cat  /proc/scsi/qla2xxx/2 returns:

QLogic PCI to Fibre Channel Host Adapter for IBM FCEC:
        Firmware version 3.03.15 IPX, Driver version 8.01.00b5-rh2
ISP: ISP2312, Serial# N04912
Request Queue = 0xdfc00000, Response Queue = 0x11fcf0000
Request Queue count = 4096, Response Queue count = 512
Total number of active commands = 0
Total number of interrupts = 653
    Device queue depth = 0x20
Number of free request entries = 3775
Number of mailbox timeouts = 0
Number of ISP aborts = 0
Number of loop resyncs = 0
Number of retries for empty slots = 0
Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
Host adapter:loop state = <READY>, flags = 0x1a03
Dpc flags = 0x0
MBX flags = 0x0
Link down Timeout = 030
Port down retry = 030
Login retry count = 030
Commands retried with dropped frame(s) = 0
Product ID = 4953 5020 2020 0002


SCSI Device Information:
scsi-qla1-adapter-node=20000011259350e9;
scsi-qla1-adapter-port=21000011259350e9;
scsi-qla1-target-0=21010000d12671dd;

FC Port Information:
scsi-qla1-port-0=20000000d12671dd:21010000d12671dd:010f00:81;

SCSI LUN Information:
(Id:Lun)  * - indicates lun is not registered with the OS.
( 0: 0): Total reqs 132, Pending reqs 0, flags 0x0, 1:0:81 00
( 0: 1): Total reqs 119, Pending reqs 0, flags 0x0, 1:0:81 00

Instructions seem relatively simple (comment out everything from
/etc/multipath.conf, run multipathd and everything should work).
Because /dev/sda is not a multipath device, we use the following
/etc/multipath.conf:

devnode_blacklist {
        devnode "^(sda)[0-9]*"
}

Running for x in sdb sdc sdd sde ; do echo -n "Device $x " ;
/sbin/scsi_id -g -u -s /block/$x; done returns the following:

Device sdb 20000d12671dd29cd
Device sdc 20000d12671dd29ce
Device sdd 20000d12671dd29cd
Device sde 20000d12671dd29ce

So it looks like sdb and sdd refer to the same volume as do sdc and
sdd.  After enabling and running multipathd, multipath -v2 returns
nothing.  Running multipath -v3 returns the following:

sda blacklisted
path sdb not found in pathvec

===== path sdb =====
bus = 1
dev_t = 8:16
size = 1433354240
vendor = IBM
product = DS400    S320
rev = 7.00
h:b:t:l = 1:0:0:0
tgt_node_name = 0x20000000d12671dd
serial = 00000000002671DD423829CD000d12671dd
path checker = readsector0 (internal default)
state = 2
getprio = (null) (internal default)
prio = 1
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = 20000d12671dd29cd (callout)
path sdc not found in pathvec

===== path sdc =====
bus = 1
dev_t = 8:32
size = 1433354240
vendor = IBM
product = DS400    S320
rev = 7.00
h:b:t:l = 1:0:0:1
tgt_node_name = 0x20000000d12671dd
serial = 00000000002671DD423829CE000d12671dd
path checker = readsector0 (internal default)
state = 2
getprio = (null) (internal default)
prio = 1
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = 20000d12671dd29ce (callout)
path sdd not found in pathvec

===== path sdd =====
bus = 1
dev_t = 8:48
size = 1433354240
vendor = IBM
product = DS400    S320
rev = 7.00
h:b:t:l = 2:0:0:0
tgt_node_name = 0x20000000d12671dd
serial = 00000000002671DD423829CD000d12671dd
path checker = readsector0 (internal default)
state = 2
getprio = (null) (internal default)
prio = 1
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = 20000d12671dd29cd (callout)
path sde not found in pathvec

===== path sde =====
bus = 1
dev_t = 8:64
size = 1433354240
vendor = IBM
product = DS400    S320
rev = 7.00
h:b:t:l = 2:0:0:1
tgt_node_name = 0x20000000d12671dd
serial = 00000000002671DD423829CE000d12671dd
path checker = readsector0 (internal default)
state = 2
getprio = (null) (internal default)
prio = 1
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = 20000d12671dd29ce (callout)
path sdf not found in pathvec

===== path sdf =====
bus = 1
dev_t = 8:80

Based on recommendations from Axel.Thimm at ATrpms.net we've tried
changing path_grouping_policy to group_by_serial and path_checker to
tur.  Neither had any effect.  Any ideas what to look at next? -- Jeff
