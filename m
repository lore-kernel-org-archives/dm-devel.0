From: Roberto Giordani <dreamdrawers@gmail.com>
Subject: multipathd: 8:80 mark as failed - BUG: unable to handle
 kernel NULL pointer dereference at (null)
Date: Thu, 17 May 2012 11:56:46 +0200
Message-ID: <4FB4CB5E.9040600@libero.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0191351416987050642=="
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

This is a multi-part message in MIME format.
--===============0191351416987050642==
Content-Type: multipart/alternative;
	boundary="------------060705010603070502000908"

This is a multi-part message in MIME format.
--------------060705010603070502000908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,
I've compiled and installed on January on Opensuse 11.4 x64 from
git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-tools.git
the multipath-tools but previous 14 of May the module hang as described
below.
Now I've got
git-clone -b sles11-sp2
git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-tools.git
.
and reinstalled, but I'd like to know if this problem was already resolved.

Regards,
Roberto.

/May 14 10:39:20 nodo4 multipathd: 8:80: mark as failed
May 14 10:39:20 nodo4 multipathd: xenimages2: remaining active paths: 3
May 14 10:39:20 nodo4 kernel: [9480398.044082]  rport-3:0-1: blocked FC
remote port time out: removing target and saving binding
May 14 10:39:20 nodo4 kernel: [9480398.044146]  rport-3:0-0: blocked FC
remote port time out: removing target and saving binding
May 14 10:39:20 nodo4 kernel: [9480398.044238] sd 3:0:1:0: [sdf]
Unhandled error code
May 14 10:39:20 nodo4 kernel: [9480398.044241] sd 3:0:1:0: [sdf] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:39:20 nodo4 kernel: [9480398.044245] sd 3:0:1:0: [sdf] CDB:
Write(10): 2a 00 00 17 a8 28 00 00 08 00
May 14 10:39:20 nodo4 kernel: [9480398.044254] end_request: I/O error,
dev sdf, sector 1550376
May 14 10:39:20 nodo4 kernel: [9480398.044267] device-mapper: multipath:
Failing path 8:80.
May 14 10:39:20 nodo4 multipathd: sdf: remove path (uevent)
May 14 10:39:20 nodo4 kernel: [9480398.076176] sd 3:0:1:0: [sdf]
Synchronizing SCSI cache
May 14 10:39:20 nodo4 kernel: [9480398.076246] sd 3:0:1:0: [sdf] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:39:20 nodo4 kernel: [9480398.108164] sd 3:0:1:1: [sdh]
Synchronizing SCSI cache
May 14 10:39:20 nodo4 kernel: [9480398.108211] sd 3:0:1:1: [sdh] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:39:20 nodo4 kernel: [9480398.132151] sd 3:0:0:0: [sdb]
Synchronizing SCSI cache
May 14 10:39:20 nodo4 kernel: [9480398.132192] sd 3:0:0:0: [sdb] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:39:20 nodo4 kernel: [9480398.164158] sd 3:0:0:1: [sdd]
Synchronizing SCSI cache
May 14 10:39:20 nodo4 kernel: [9480398.164200] sd 3:0:0:1: [sdd] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:39:20 nodo4 multipathd: xenimages2: load table [0 419430400
multipath 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 8:32 1
round-robin 0 2 1 8:16 1 8:96 1]
May 14 10:39:20 nodo4 multipathd: sdf: path removed from map xenimages2
May 14 10:39:20 nodo4 multipathd: sdh: remove path (uevent)
May 14 10:39:20 nodo4 kernel: [9480398.172072]  rport-4:0-0: blocked FC
remote port time out: removing target and saving binding
May 14 10:39:20 nodo4 kernel: [9480398.172111]  rport-4:0-1: blocked FC
remote port time out: removing target and saving binding
May 14 10:39:20 nodo4 kernel: [9480398.172144] sd 4:0:0:0: [sdc]
Unhandled error code
May 14 10:39:20 nodo4 kernel: [9480398.172146] sd 4:0:0:0: [sdc] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:39:20 nodo4 kernel: [9480398.172150] sd 4:0:0:0: [sdc] CDB:
Write(10): 2a 00 00 17 a8 28 00 00 08 00
May 14 10:39:20 nodo4 kernel: [9480398.172158] end_request: I/O error,
dev sdc, sector 1550376
May 14 10:39:20 nodo4 kernel: [9480398.172166] device-mapper: multipath:
Failing path 8:32.
May 14 10:39:20 nodo4 kernel: [9480398.172685] device-mapper: multipath:
Failing path 8:32.
May 14 10:39:20 nodo4 kernel: [9480398.172752] scsi 3:0:0:0: rejecting
I/O to dead device
May 14 10:39:20 nodo4 kernel: [9480398.172758] device-mapper: multipath:
Failing path 8:16.
May 14 10:39:20 nodo4 kernel: [9480398.172818] device-mapper: multipath:
Failing path 8:96.
May 14 10:39:20 nodo4 kernel: [9480398.174732] device-mapper: multipath:
Failing path 8:32.
May 14 10:39:20 nodo4 kernel: [9480398.174789] scsi 3:0:0:0: rejecting
I/O to dead device
May 14 10:39:20 nodo4 kernel: [9480398.174793] device-mapper: multipath:
Failing path 8:16.
May 14 10:39:20 nodo4 kernel: [9480398.174816] device-mapper: multipath:
Failing path 8:96.
May 14 10:39:20 nodo4 kernel: [9480398.181204] device-mapper: multipath:
adding disabled device 8:48
May 14 10:39:20 nodo4 kernel: [9480398.181565] BUG: unable to handle
kernel NULL pointer dereference at           (null)
May 14 10:39:20 nodo4 kernel: [9480398.181582] IP: [<ffffffffa0843a63>]
dm_set_device_limits+0x23/0x140 [dm_mod]
May 14 10:39:20 nodo4 kernel: [9480398.181601] PGD 34c6f5067 PUD
34be31067 PMD 0
May 14 10:39:20 nodo4 kernel: [9480398.181608] Oops: 0000 [#1] SMP
May 14 10:39:20 nodo4 kernel: [9480398.181613] last sysfs file:
/sys/module/scsi_dh_rdac/initstate
May 14 10:39:20 nodo4 kernel: [9480398.181618] CPU 0
May 14 10:39:20 nodo4 kernel: [9480398.181620] Modules linked in:
af_packet loop 8021q garp ocfs2 ocfs2_nodemanager quota_tree
ocfs2_stack_user ocfs2_stackglue dlm configfs scsi_dh_rdac
dm_round_robin nbd usbbk netbk dm_multipath blkbk blkback_pagemap blktap
domctl scsi_dh xenbus_be gntdev evtchn bridge stp llc bonding edd ext4
jbd2 crc16 dm_mod 8250_pnp i5k_amb e1000e ses bnx2 iTCO_wdt
iTCO_vendor_support ibmpex ibmaem qla2xxx sg sr_mod 8250 enclosure
pcspkr ipmi_msghandler i5000_edac ioatdma i2c_i801 ics932s401 joydev
edac_core shpchp pci_hotplug serio_raw button serial_core reiserfs
usbhid hid uhci_hcd radeon ttm drm_kms_helper drm i2c_algo_bit ehci_hcd
usbcore i2c_core xenblk cdrom xennet fan processor ata_generic thermal
thermal_sys hwmon aacraid
May 14 10:39:20 nodo4 kernel: [9480398.181723]
May 14 10:39:20 nodo4 kernel: [9480398.181727] Pid: 3608, comm:
multipathd Not tainted 2.6.37.6-0.9-xen #1 IBM IBM System x3650
-[7979AC1]-/System Planar
May 14 10:39:20 nodo4 kernel: [9480398.181737] RIP:
e030:[<ffffffffa0843a63>]  [<ffffffffa0843a63>]
dm_set_device_limits+0x23/0x140 [dm_mod]
May 14 10:39:20 nodo4 kernel: [9480398.181748] RSP:
e02b:ffff88034cdddc78  EFLAGS: 00010296
May 14 10:39:20 nodo4 kernel: [9480398.181752] RAX: ffff88020f3b5b40
RBX: ffff88020f3b5bc0 RCX: 0000000000200000
May 14 10:39:20 nodo4 kernel: [9480398.181757] RDX: 0000000000000000
RSI: 0000000000000000 RDI: ffffc9000007d040
May 14 10:39:20 nodo4 kernel: [9480398.181761] RBP: ffffc9000007d040
R08: ffff88034cdddd58 R09: 0000000000000200
May 14 10:39:20 nodo4 kernel: [9480398.181766] R10: 0000000000000008
R11: 00003ffffffff000 R12: ffff88020f3b5c78
May 14 10:39:20 nodo4 kernel: [9480398.181771] R13: 0000000000000000
R14: ffff88034cdddd58 R15: ffff88020f3b5c40
May 14 10:39:20 nodo4 kernel: [9480398.181779] FS: 
00007fd29961d700(0000) GS:ffff8803602bf000(0000) knlGS:0000000000000000
May 14 10:39:20 nodo4 kernel: [9480398.181785] CS:  e033 DS: 0000 ES:
0000 CR0: 0000000080050033
May 14 10:39:20 nodo4 kernel: [9480398.181789] CR2: 0000000000000000
CR3: 000000034e657000 CR4: 0000000000042660
May 14 10:39:20 nodo4 kernel: [9480398.181794] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
May 14 10:39:20 nodo4 kernel: [9480398.181799] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 14 10:39:20 nodo4 kernel: [9480398.181804] Process multipathd (pid:
3608, threadinfo ffff88034cddc000, task ffff88034cdda780)
May 14 10:39:20 nodo4 kernel: [9480398.181809] Stack:
May 14 10:39:20 nodo4 kernel: [9480398.181811]  00000000000000d2
ffff880351c50b80 ffff88034cdddcc8 0000000000000007
May 14 10:39:20 nodo4 kernel: [9480398.181819]  ffff880351c50bf0
0000000000000001 ffff880351c50ba0 ffffffff8005e61f
May 14 10:39:20 nodo4 kernel: [9480398.181827]  ffff88034cdddce8
ffffffff8002e082 ffff88020f3b5bc0 ffffc9000007d040
May 14 10:39:20 nodo4 kernel: [9480398.181834] Call Trace:
May 14 10:39:20 nodo4 kernel: [9480398.181864]  [<ffffffffa09c2425>]
multipath_iterate_devices+0x55/0x80 [dm_multipath]
May 14 10:39:20 nodo4 kernel: [9480398.181878]  [<ffffffffa084482c>]
dm_calculate_queue_limits+0x8c/0x130 [dm_mod]
May 14 10:39:20 nodo4 kernel: [9480398.181899]  [<ffffffffa084273b>]
dm_swap_table+0x6b/0x90 [dm_mod]
May 14 10:39:20 nodo4 kernel: [9480398.181915]  [<ffffffffa0847048>]
do_resume+0x88/0x1b0 [dm_mod]
May 14 10:39:20 nodo4 kernel: [9480398.181940]  [<ffffffffa0847e6c>]
ctl_ioctl+0x1ac/0x250 [dm_mod]
May 14 10:39:20 nodo4 kernel: [9480398.181966]  [<ffffffffa0847f1e>]
dm_ctl_ioctl+0xe/0x20 [dm_mod]
May 14 10:39:20 nodo4 kernel: [9480398.181992]  [<ffffffff8012da89>]
do_vfs_ioctl+0x89/0x340
May 14 10:39:20 nodo4 kernel: [9480398.182001]  [<ffffffff8012ddc0>]
sys_ioctl+0x80/0xa0
May 14 10:39:20 nodo4 kernel: [9480398.182009]  [<ffffffff80007448>]
system_call_fastpath+0x16/0x1b
May 14 10:39:20 nodo4 kernel: [9480398.182018]  [<00007fd29848ed87>]
0x7fd29848ed87
May 14 10:39:20 nodo4 kernel: [9480398.182021] Code: fd ff ff 0f 1f 44
00 00 48 83 ec 78 48 89 6c 24 58 4c 89 64 24 60 48 89 fd 4c 89 6c 24 68
48 89 5c 24 50 49 89 d5 4c 89 74 24 70 <4c> 8b 36 4d 89 c4 49 8b 86 a0
00 00 00 48 8b 98 10 03 00 00 48
May 14 10:39:20 nodo4 kernel: [9480398.182074] RIP  [<ffffffffa0843a63>]
dm_set_device_limits+0x23/0x140 [dm_mod]
May 14 10:39:20 nodo4 kernel: [9480398.182083]  RSP <ffff88034cdddc78>
May 14 10:39:20 nodo4 kernel: [9480398.182086] CR2: 0000000000000000
May 14 10:39:20 nodo4 kernel: [9480398.182666] ---[ end trace
47ea050a3e10cad9 ]---
May 14 10:39:20 nodo4 kernel: [9480398.216228] sd 4:0:0:0: [sdc]
Synchronizing SCSI cache
May 14 10:39:20 nodo4 kernel: [9480398.216281] sd 4:0:0:0: [sdc] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:39:21 nodo4 kernel: [9480398.244149] sd 4:0:0:1: [sde]
Synchronizing SCSI cache
May 14 10:39:21 nodo4 kernel: [9480398.244188] sd 4:0:0:1: [sde] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:39:21 nodo4 kernel: [9480398.276178] sd 4:0:1:0: [sdg]
Synchronizing SCSI cache
May 14 10:39:21 nodo4 kernel: [9480398.276218] sd 4:0:1:0: [sdg] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:39:21 nodo4 kernel: [9480398.312146] sd 4:0:1:1: [sdi]
Synchronizing SCSI cache
May 14 10:39:21 nodo4 kernel: [9480398.312185] sd 4:0:1:1: [sdi] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:39:43 nodo4 kernel: [9480420.907033] scsi 3:0:0:0:
Direct-Access     IBM      1726-4xx  FAStT  0617 PQ: 0 ANSI: 5
May 14 10:39:43 nodo4 kernel: [9480420.907804] scsi 3:0:0:0: rdac: LUN 0
(unowned)
May 14 10:39:43 nodo4 kernel: [9480420.908038] sd 3:0:0:0: Attached scsi
generic sg8 type 0
May 14 10:39:43 nodo4 kernel: [9480420.908044] sd 3:0:0:0: Embedded
Enclosure Device
May 14 10:39:44 nodo4 kernel: [9480421.369100] scsi 4:0:0:0:
Direct-Access     IBM      1726-4xx  FAStT  0617 PQ: 0 ANSI: 5
May 14 10:39:44 nodo4 kernel: [9480421.369856] scsi 4:0:0:0: rdac: LUN 0
(owned)
May 14 10:39:44 nodo4 kernel: [9480421.904087] sd 3:0:0:0: Failed to get
diagnostic page 0x10000
May 14 10:39:44 nodo4 kernel: [9480421.904094] sd 3:0:0:0: Failed to
bind enclosure -19
May 14 10:39:44 nodo4 kernel: [9480421.904268] sd 4:0:0:0: Attached scsi
generic sg9 type 0
May 14 10:39:44 nodo4 kernel: [9480421.904285] sd 4:0:0:0: Embedded
Enclosure Device
May 14 10:39:44 nodo4 kernel: [9480421.911840] scsi 3:0:0:1:
Direct-Access     IBM      1726-4xx  FAStT  0617 PQ: 0 ANSI: 5
May 14 10:39:44 nodo4 kernel: [9480421.912615] scsi 3:0:0:1: rdac: LUN 1
(unowned)
May 14 10:40:12 nodo4 kernel: [9480449.864814] sd 3:0:0:0: [sdf]
419430400 512-byte logical blocks: (214 GB/200 GiB)
May 14 10:40:24 nodo4 kernel: [9480462.172112] sd 3:0:0:0: [sdf] Write
Protect is off
May 14 10:40:24 nodo4 kernel: [9480462.172126] sd 3:0:0:0: [sdf] Mode
Sense: 77 00 10 08
May 14 10:40:24 nodo4 kernel: [9480462.172262] sd 3:0:0:1: [sdk] 2097152
512-byte logical blocks: (1.07 GB/1.00 GiB)
May 14 10:40:24 nodo4 kernel: [9480462.209408] sd 3:0:0:0: [sdf] Write
cache: enabled, read cache: enabled, supports DPO and FUA
May 14 10:40:25 nodo4 kernel: [9480462.238939] sd 3:0:0:1: [sdk] Write
Protect is off
May 14 10:40:25 nodo4 kernel: [9480462.238945] sd 3:0:0:1: [sdk] Mode
Sense: 77 00 10 08
May 14 10:40:25 nodo4 kernel: [9480462.260063] sd 3:0:0:1: [sdk] Write
cache: enabled, read cache: enabled, supports DPO and FUA
May 14 10:40:25 nodo4 kernel: [9480462.282119]
ldm_validate_partition_table(): Disk read failed.
May 14 10:40:25 nodo4 kernel: [9480462.282206]  sdf: unable to read
partition table
May 14 10:40:25 nodo4 kernel: [9480462.299524]
ldm_validate_partition_table(): Disk read failed.
May 14 10:40:25 nodo4 kernel: [9480462.299608]  sdk: unable to read
partition table
May 14 10:40:25 nodo4 kernel: [9480462.334705] sd 3:0:0:0: [sdf]
Attached SCSI disk
May 14 10:40:25 nodo4 kernel: [9480462.346239] sd 3:0:0:1: [sdk]
Attached SCSI disk
May 14 10:40:42 nodo4 kernel: [9480480.156067]  rport-3:0-1: blocked FC
remote port time out: removing target and saving binding
May 14 10:40:42 nodo4 kernel: [9480480.220064]  rport-4:0-0: blocked FC
remote port time out: removing target and saving binding
May 14 10:40:42 nodo4 kernel: [9480480.220133] sd 4:0:0:0: Failed to get
diagnostic page 0x10000
May 14 10:40:42 nodo4 kernel: [9480480.220151] sd 4:0:0:0: Failed to
bind enclosure -19
May 14 10:40:42 nodo4 kernel: [9480480.220166] sd 4:0:0:0: [sdj] READ
CAPACITY(16) failed
May 14 10:40:42 nodo4 kernel: [9480480.220178] sd 4:0:0:0: [sdj] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:40:42 nodo4 kernel: [9480480.220186] sd 4:0:0:0: [sdj] Sense
not available.
May 14 10:40:42 nodo4 kernel: [9480480.220218] sd 4:0:0:0: [sdj] READ
CAPACITY failed
May 14 10:40:42 nodo4 kernel: [9480480.220222] sd 4:0:0:0: [sdj] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:40:42 nodo4 kernel: [9480480.220229] sd 4:0:0:0: [sdj] Sense
not available.
May 14 10:40:42 nodo4 kernel: [9480480.220263] sd 4:0:0:0: [sdj] Write
Protect is off
May 14 10:40:42 nodo4 kernel: [9480480.220269] sd 4:0:0:0: [sdj] Mode
Sense: 00 00 00 00
May 14 10:40:42 nodo4 kernel: [9480480.220284] sd 4:0:0:0: [sdj] Asking
for cache data failed
May 14 10:40:42 nodo4 kernel: [9480480.220288] sd 4:0:0:0: [sdj]
Assuming drive cache: write through
May 14 10:40:42 nodo4 kernel: [9480480.220497] sd 3:0:0:1: Attached scsi
generic sg10 type 0
May 14 10:40:42 nodo4 kernel: [9480480.220509] sd 3:0:0:1: Embedded
Enclosure Device
May 14 10:40:42 nodo4 kernel: [9480480.220623] sd 4:0:0:0: [sdj] READ
CAPACITY(16) failed
May 14 10:40:42 nodo4 kernel: [9480480.220634] sd 4:0:0:0: [sdj] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:40:42 nodo4 kernel: [9480480.220641] sd 4:0:0:0: [sdj] Sense
not available.
May 14 10:40:42 nodo4 kernel: [9480480.220675] sd 4:0:0:0: [sdj] READ
CAPACITY failed
May 14 10:40:42 nodo4 kernel: [9480480.220679] sd 4:0:0:0: [sdj] 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 14 10:40:42 nodo4 kernel: [9480480.220685] sd 4:0:0:0: [sdj] Sense
not available.
May 14 10:40:42 nodo4 kernel: [9480480.220726] sd 4:0:0:0: [sdj] Asking
for cache data failed
May 14 10:40:42 nodo4 kernel: [9480480.220731] sd 4:0:0:0: [sdj]
Assuming drive cache: write through
May 14 10:40:42 nodo4 kernel: [9480480.220735] sd 4:0:0:0: [sdj]
Attached SCSI disk
May 14 10:40:43 nodo4 kernel: [9480480.224842] scsi 4:0:1:0:
Direct-Access     IBM      1726-4xx  FAStT  0617 PQ: 0 ANSI: 5
May 14 10:40:43 nodo4 kernel: [9480480.226028] scsi 4:0:1:0: rdac: LUN 0
(owned)
May 14 10:40:43 nodo4 kernel: [9480480.226896] sd 4:0:1:0: [sdl]
419430400 512-byte logical blocks: (214 GB/200 GiB)
May 14 10:40:43 nodo4 kernel: [9480480.228114] sd 4:0:1:0: [sdl] Write
Protect is off
May 14 10:40:43 nodo4 kernel: [9480480.228121] sd 4:0:1:0: [sdl] Mode
Sense: 77 00 10 08
May 14 10:40:43 nodo4 kernel: [9480480.228481] sd 4:0:1:0: [sdl] Write
cache: enabled, read cache: enabled, supports DPO and FUA
May 14 10:40:43 nodo4 kernel: [9480480.230883]  sdl: sdl1
May 14 10:40:43 nodo4 kernel: [9480480.234706] sd 4:0:1:0: [sdl]
Attached SCSI disk
May 14 10:40:43 nodo4 kernel: [9480480.484994] sd 3:0:0:1: FIXME driver
has no support for subenclosures (1)
May 14 10:40:43 nodo4 kernel: [9480480.485001] sd 3:0:0:1: Failed to
bind enclosure -12
May 14 10:40:43 nodo4 kernel: [9480480.485222] sd 4:0:1:0: Attached scsi
generic sg11 type 0
May 14 10:40:43 nodo4 kernel: [9480480.485228] sd 4:0:1:0: Embedded
Enclosure Device
May 14 10:40:43 nodo4 kernel: [9480480.486067] scsi 3:0:0:31:
Direct-Access     IBM      Universal Xport  0617 PQ: 0 ANSI: 5
May 14 10:40:43 nodo4 kernel: [9480480.772006] sd 4:0:1:0: FIXME driver
has no support for subenclosures (1)
May 14 10:40:43 nodo4 kernel: [9480480.772013] sd 4:0:1:0: Failed to
bind enclosure -12
May 14 10:40:43 nodo4 kernel: [9480480.772173] scsi 3:0:0:31: Attached
scsi generic sg12 type 0
May 14 10:40:43 nodo4 kernel: [9480480.772187] scsi 3:0:0:31: Embedded
Enclosure Device
May 14 10:40:43 nodo4 kernel: [9480480.772708] scsi 3:0:0:31: Failed to
get diagnostic page 0x8000002
May 14 10:40:43 nodo4 kernel: [9480480.772714] scsi 3:0:0:31: Failed to
bind enclosure -19
May 14 10:40:43 nodo4 kernel: [9480480.783457] scsi 4:0:1:1:
Direct-Access     IBM      1726-4xx  FAStT  0617 PQ: 0 ANSI: 5
May 14 10:40:43 nodo4 kernel: [9480480.802754] scsi 4:0:1:1: rdac: LUN 1
(owned)
May 14 10:40:43 nodo4 kernel: [9480480.802898] sd 4:0:1:1: Attached scsi
generic sg13 type 0
May 14 10:40:43 nodo4 kernel: [9480480.802904] sd 4:0:1:1: Embedded
Enclosure Device
May 14 10:40:43 nodo4 kernel: [9480480.803595] sd 4:0:1:1: Failed to get
diagnostic page 0x8000002
May 14 10:40:43 nodo4 kernel: [9480480.803601] sd 4:0:1:1: Failed to
bind enclosure -19
May 14 10:40:43 nodo4 kernel: [9480480.804166] sd 4:0:1:1: [sdm] 2097152
512-byte logical blocks: (1.07 GB/1.00 GiB)
May 14 10:40:43 nodo4 kernel: [9480480.804492] scsi 4:0:1:31:
Direct-Access     IBM      Universal Xport  0617 PQ: 0 ANSI: 5
May 14 10:40:43 nodo4 kernel: [9480480.804891] scsi 4:0:1:31: Attached
scsi generic sg14 type 0
May 14 10:40:43 nodo4 kernel: [9480480.804896] scsi 4:0:1:31: Embedded
Enclosure Device
May 14 10:40:43 nodo4 kernel: [9480480.805276] scsi 4:0:1:31: Failed to
get diagnostic page 0x8000002
May 14 10:40:43 nodo4 kernel: [9480480.805282] scsi 4:0:1:31: Failed to
bind enclosure -19
May 14 10:40:43 nodo4 kernel: [9480480.805602] sd 4:0:0:0: rdac: Detached
May 14 10:40:43 nodo4 kernel: [9480480.806204] sd 4:0:1:1: [sdm] Write
Protect is off
May 14 10:40:43 nodo4 kernel: [9480480.806216] sd 4:0:1:1: [sdm] Mode
Sense: 77 00 10 08
May 14 10:40:43 nodo4 kernel: [9480480.806609] sd 4:0:1:1: [sdm] Write
cache: enabled, read cache: enabled, supports DPO and FUA
May 14 10:40:43 nodo4 kernel: [9480480.808631]  sdm: sdm1
May 14 10:40:43 nodo4 kernel: [9480480.810486] sd 4:0:1:1: [sdm]
Attached SCSI disk
May 14 10:41:17 nodo4 kernel: [9480514.905354] scsi 3:0:1:0:
Direct-Access     IBM      1726-4xx  FAStT  0617 PQ: 0 ANSI: 5
May 14 10:41:17 nodo4 kernel: [9480514.906146] scsi 3:0:1:0: rdac: LUN 0
(unowned)
May 14 10:41:17 nodo4 kernel: [9480514.906376] sd 3:0:1:0: Attached scsi
generic sg9 type 0
May 14 10:41:17 nodo4 kernel: [9480514.906381] sd 3:0:1:0: Embedded
Enclosure Device
May 14 10:41:18 nodo4 kernel: [9480515.369473] scsi 4:0:0:0:
Direct-Access     IBM      1726-4xx  FAStT  0617 PQ: 0 ANSI: 5
May 14 10:41:18 nodo4 kernel: [9480515.370229] scsi 4:0:0:0: rdac: LUN 0
(unowned)
May 14 10:41:46 nodo4 kernel: [9480543.616449] sd 4:0:0:0: [sdn]
419430400 512-byte logical blocks: (214 GB/200 GiB)
May 14 10:41:46 nodo4 kernel: [9480543.616528] sd 3:0:1:0: [sdj]
419430400 512-byte logical blocks: (214 GB/200 GiB)
May 14 10:41:46 nodo4 kernel: [9480543.683122] sd 3:0:1:0: FIXME driver
has no support for subenclosures (1)
May 14 10:41:46 nodo4 kernel: [9480543.683128] sd 3:0:1:0: Failed to
bind enclosure -12
May 14 10:41:46 nodo4 kernel: [9480543.683369] sd 4:0:0:0: Attached scsi
generic sg15 type 0
May 14 10:41:46 nodo4 kernel: [9480543.683375] sd 4:0:0:0: Embedded
Enclosure Device
May 14 10:41:46 nodo4 kernel: [9480544.223913] sd 4:0:0:0: [sdn] Write
Protect is off
May 14 10:41:46 nodo4 kernel: [9480544.223920] sd 4:0:0:0: [sdn] Mode
Sense: 77 00 10 08
May 14 10:41:47 nodo4 kernel: [9480544.224710] sd 3:0:1:0: [sdj] Write
Protect is off
May 14 10:41:47 nodo4 kernel: [9480544.224716] sd 3:0:1:0: [sdj] Mode
Sense: 77 00 10 08
May 14 10:41:47 nodo4 kernel: [9480544.240556] scsi 3:0:1:1:
Direct-Access     IBM      1726-4xx  FAStT  0617 PQ: 0 ANSI: 5
May 14 10:41:47 nodo4 kernel: [9480544.259638] sd 4:0:0:0: [sdn] Write
cache: enabled, read cache: enabled, supports DPO and FUA
May 14 10:41:47 nodo4 kernel: [9480544.260276] sd 3:0:1:0: [sdj] Write
cache: enabled, read cache: enabled, supports DPO and FUA
May 14 10:41:48 nodo4 kernel: [9480546.038746] sd 4:0:0:0: FIXME driver
has no support for subenclosures (1)
May 14 10:41:48 nodo4 kernel: [9480546.038754] sd 4:0:0:0: Failed to
bind enclosure -12
May 14 10:41:48 nodo4 kernel: [9480546.039500] scsi 3:0:1:1: rdac: LUN 1
(unowned)
May 14 10:41:48 nodo4 kernel: [9480546.039678] sd 3:0:1:1: Attached scsi
generic sg16 type 0
May 14 10:41:48 nodo4 kernel: [9480546.039684] sd 3:0:1:1: Embedded
Enclosure Device
May 14 10:41:48 nodo4 kernel: [9480546.087292] scsi 4:0:0:1:
Direct-Access     IBM      1726-4xx  FAStT  0617 PQ: 0 ANSI: 5
May 14 10:41:48 nodo4 kernel: [9480546.094112]
ldm_validate_partition_table(): Disk read failed.
May 14 10:41:48 nodo4 kernel: [9480546.094271]
ldm_validate_partition_table(): Disk read failed.
May 14 10:41:48 nodo4 kernel: [9480546.094357]  sdj: unable to read
partition table
May 14 10:41:48 nodo4 kernel: [9480546.094464]  sdn: unable to read
partition table
May 14 10:41:48 nodo4 kernel: [9480546.104559] scsi 4:0:0:1: rdac: LUN 1
(unowned)
May 14 10:41:49 nodo4 kernel: [9480546.287268] sd 3:0:1:1: FIXME driver
has no support for subenclosures (1)
May 14 10:41:49 nodo4 kernel: [9480546.287274] sd 3:0:1:1: Failed to
bind enclosure -12
May 14 10:41:49 nodo4 kernel: [9480546.287434] sd 4:0:0:1: Attached scsi
generic sg17 type 0
May 14 10:41:49 nodo4 kernel: [9480546.287440] sd 4:0:0:1: Embedded
Enclosure Device
May 14 10:41:49 nodo4 kernel: [9480546.303619] sd 4:0:0:1: [sdp] 2097152
512-byte logical blocks: (1.07 GB/1.00 GiB)
May 14 10:41:49 nodo4 kernel: [9480546.304315] sd 3:0:1:1: [sdo] 2097152
512-byte logical blocks: (1.07 GB/1.00 GiB)
May 14 10:41:49 nodo4 kernel: [9480546.305037] scsi 3:0:1:31:
Direct-Access     IBM      Universal Xport  0617 PQ: 0 ANSI: 5
May 14 10:41:49 nodo4 kernel: [9480546.310818] sd 4:0:0:0: [sdn]
Attached SCSI disk
May 14 10:41:49 nodo4 kernel: [9480546.311119] sd 3:0:1:0: [sdj]
Attached SCSI disk
May 14 10:41:49 nodo4 kernel: [9480546.325288] sd 4:0:0:1: [sdp] Write
Protect is off
May 14 10:41:49 nodo4 kernel: [9480546.325295] sd 4:0:0:1: [sdp] Mode
Sense: 77 00 10 08
May 14 10:41:49 nodo4 kernel: [9480546.325684] sd 3:0:1:1: [sdo] Write
Protect is off
May 14 10:41:49 nodo4 kernel: [9480546.325689] sd 3:0:1:1: [sdo] Mode
Sense: 77 00 10 08
May 14 10:41:49 nodo4 kernel: [9480546.330743] sd 4:0:0:1: [sdp] Write
cache: enabled, read cache: enabled, supports DPO and FUA
May 14 10:41:49 nodo4 kernel: [9480546.331160] sd 3:0:1:1: [sdo] Write
cache: enabled, read cache: enabled, supports DPO and FUA
May 14 10:41:49 nodo4 kernel: [9480546.656447]
ldm_validate_partition_table(): Disk read failed.
May 14 10:41:49 nodo4 kernel: [9480546.656584]
ldm_validate_partition_table(): Disk read failed.
May 14 10:41:49 nodo4 kernel: [9480546.656668]  sdo: unable to read
partition table
May 14 10:41:49 nodo4 kernel: [9480546.656797]  sdp: unable to read
partition table
May 14 10:41:49 nodo4 kernel: [9480546.673418] sd 4:0:0:1: FIXME driver
has no support for subenclosures (1)
May 14 10:41:49 nodo4 kernel: [9480546.673431] sd 4:0:0:1: Failed to
bind enclosure -12
May 14 10:41:49 nodo4 kernel: [9480546.673645] scsi 3:0:1:31: Attached
scsi generic sg18 type 0
May 14 10:41:49 nodo4 kernel: [9480546.673653] scsi 3:0:1:31: Embedded
Enclosure Device
May 14 10:41:49 nodo4 kernel: [9480546.674071] scsi 3:0:1:31: Failed to
get diagnostic page 0x8000002
May 14 10:41:49 nodo4 kernel: [9480546.674076] scsi 3:0:1:31: Failed to
bind enclosure -19
May 14 10:41:49 nodo4 kernel: [9480546.674709] sd 3:0:1:1: [sdo]
Attached SCSI disk
May 14 10:41:49 nodo4 kernel: [9480546.675193] sd 4:0:0:1: [sdp]
Attached SCSI disk
May 14 10:41:49 nodo4 kernel: [9480546.676734] scsi 4:0:0:31:
Direct-Access     IBM      Universal Xport  0617 PQ: 0 ANSI: 5
May 14 10:41:49 nodo4 kernel: [9480546.676886] scsi 4:0:0:31: Attached
scsi generic sg19 type 0
May 14 10:41:49 nodo4 kernel: [9480546.676891] scsi 4:0:0:31: Embedded
Enclosure Device
May 14 10:41:49 nodo4 kernel: [9480546.677767] scsi 4:0:0:31: Failed to
get diagnostic page 0x8000002
May 14 10:41:49 nodo4 kernel: [9480546.677773] scsi 4:0:0:31: Failed to
bind enclosure -19
May 14 10:41:49 nodo4 udevd-work[2477]: symlink '../../sdo'
'/dev/disk/by-id/scsi-3600a0b80003696ab000014c64ef2ee5b.udev-tmp'
failed: File exists
May 14 10:42:20 nodo4 udevd[388]: worker [28740] unexpectedly returned
with status 0x0100
May 14 10:42:20 nodo4 udevd[388]: worker [28740] failed while handling
'/devices/virtual/block/dm-0'
May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdb, open() failed: No
such device
May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdc, open() failed: No
such device
May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdd, open() failed: No
such device
May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sde, open() failed: No
such device
May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdg, open() failed: No
such device
May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdh, open() failed: No
such device
May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdi, open() failed: No
such device






/

--------------060705010603070502000908
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    Hello,<br>
    I've compiled and installed on January on Opensuse 11.4 x64 from
    git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-tools.git
    the multipath-tools but previous 14 of May the module hang as
    described below.<br>
    Now I've got <br>
    git-clone -b sles11-sp2
git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-tools.git
    .<br>
    and reinstalled, but I'd like to know if this problem was already
    resolved.<br>
    <br>
    Regards,<br>
    Roberto.<br>
    <br>
    <i><small>May 14 10:39:20 nodo4 multipathd: 8:80: mark as failed<br>
        May 14 10:39:20 nodo4 multipathd: xenimages2: remaining active
        paths: 3<br>
        May 14 10:39:20 nodo4 kernel: [9480398.044082]&nbsp; rport-3:0-1:
        blocked FC remote port time out: removing target and saving
        binding<br>
        May 14 10:39:20 nodo4 kernel: [9480398.044146]&nbsp; rport-3:0-0:
        blocked FC remote port time out: removing target and saving
        binding<br>
        May 14 10:39:20 nodo4 kernel: [9480398.044238] sd 3:0:1:0: [sdf]
        Unhandled error code<br>
        May 14 10:39:20 nodo4 kernel: [9480398.044241] sd 3:0:1:0:
        [sdf]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:39:20 nodo4 kernel: [9480398.044245] sd 3:0:1:0: [sdf]
        CDB: Write(10): 2a 00 00 17 a8 28 00 00 08 00<br>
        May 14 10:39:20 nodo4 kernel: [9480398.044254] end_request: I/O
        error, dev sdf, sector 1550376<br>
        May 14 10:39:20 nodo4 kernel: [9480398.044267] device-mapper:
        multipath: Failing path 8:80.<br>
        May 14 10:39:20 nodo4 multipathd: sdf: remove path (uevent)<br>
        May 14 10:39:20 nodo4 kernel: [9480398.076176] sd 3:0:1:0: [sdf]
        Synchronizing SCSI cache<br>
        May 14 10:39:20 nodo4 kernel: [9480398.076246] sd 3:0:1:0:
        [sdf]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:39:20 nodo4 kernel: [9480398.108164] sd 3:0:1:1: [sdh]
        Synchronizing SCSI cache<br>
        May 14 10:39:20 nodo4 kernel: [9480398.108211] sd 3:0:1:1:
        [sdh]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:39:20 nodo4 kernel: [9480398.132151] sd 3:0:0:0: [sdb]
        Synchronizing SCSI cache<br>
        May 14 10:39:20 nodo4 kernel: [9480398.132192] sd 3:0:0:0:
        [sdb]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:39:20 nodo4 kernel: [9480398.164158] sd 3:0:0:1: [sdd]
        Synchronizing SCSI cache<br>
        May 14 10:39:20 nodo4 kernel: [9480398.164200] sd 3:0:0:1:
        [sdd]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:39:20 nodo4 multipathd: xenimages2: load table [0
        419430400 multipath 1 queue_if_no_path 1 rdac 2 1 round-robin 0
        1 1 8:32 1 round-robin 0 2 1 8:16 1 8:96 1]<br>
        May 14 10:39:20 nodo4 multipathd: sdf: path removed from map
        xenimages2<br>
        May 14 10:39:20 nodo4 multipathd: sdh: remove path (uevent)<br>
        May 14 10:39:20 nodo4 kernel: [9480398.172072]&nbsp; rport-4:0-0:
        blocked FC remote port time out: removing target and saving
        binding<br>
        May 14 10:39:20 nodo4 kernel: [9480398.172111]&nbsp; rport-4:0-1:
        blocked FC remote port time out: removing target and saving
        binding<br>
        May 14 10:39:20 nodo4 kernel: [9480398.172144] sd 4:0:0:0: [sdc]
        Unhandled error code<br>
        May 14 10:39:20 nodo4 kernel: [9480398.172146] sd 4:0:0:0:
        [sdc]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:39:20 nodo4 kernel: [9480398.172150] sd 4:0:0:0: [sdc]
        CDB: Write(10): 2a 00 00 17 a8 28 00 00 08 00<br>
        May 14 10:39:20 nodo4 kernel: [9480398.172158] end_request: I/O
        error, dev sdc, sector 1550376<br>
        May 14 10:39:20 nodo4 kernel: [9480398.172166] device-mapper:
        multipath: Failing path 8:32.<br>
        May 14 10:39:20 nodo4 kernel: [9480398.172685] device-mapper:
        multipath: Failing path 8:32.<br>
        May 14 10:39:20 nodo4 kernel: [9480398.172752] scsi 3:0:0:0:
        rejecting I/O to dead device<br>
        May 14 10:39:20 nodo4 kernel: [9480398.172758] device-mapper:
        multipath: Failing path 8:16.<br>
        May 14 10:39:20 nodo4 kernel: [9480398.172818] device-mapper:
        multipath: Failing path 8:96.<br>
        May 14 10:39:20 nodo4 kernel: [9480398.174732] device-mapper:
        multipath: Failing path 8:32.<br>
        May 14 10:39:20 nodo4 kernel: [9480398.174789] scsi 3:0:0:0:
        rejecting I/O to dead device<br>
        May 14 10:39:20 nodo4 kernel: [9480398.174793] device-mapper:
        multipath: Failing path 8:16.<br>
        May 14 10:39:20 nodo4 kernel: [9480398.174816] device-mapper:
        multipath: Failing path 8:96.<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181204] device-mapper:
        multipath: adding disabled device 8:48<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181565] BUG: unable to
        handle kernel NULL pointer dereference at&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (null)<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181582] IP:
        [&lt;ffffffffa0843a63&gt;] dm_set_device_limits+0x23/0x140
        [dm_mod]<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181601] PGD 34c6f5067 PUD
        34be31067 PMD 0 <br>
        May 14 10:39:20 nodo4 kernel: [9480398.181608] Oops: 0000 [#1]
        SMP <br>
        May 14 10:39:20 nodo4 kernel: [9480398.181613] last sysfs file:
        /sys/module/scsi_dh_rdac/initstate<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181618] CPU 0 <br>
        May 14 10:39:20 nodo4 kernel: [9480398.181620] Modules linked
        in: af_packet loop 8021q garp ocfs2 ocfs2_nodemanager quota_tree
        ocfs2_stack_user ocfs2_stackglue dlm configfs scsi_dh_rdac
        dm_round_robin nbd usbbk netbk dm_multipath blkbk
        blkback_pagemap blktap domctl scsi_dh xenbus_be gntdev evtchn
        bridge stp llc bonding edd ext4 jbd2 crc16 dm_mod 8250_pnp
        i5k_amb e1000e ses bnx2 iTCO_wdt iTCO_vendor_support ibmpex
        ibmaem qla2xxx sg sr_mod 8250 enclosure pcspkr ipmi_msghandler
        i5000_edac ioatdma i2c_i801 ics932s401 joydev edac_core shpchp
        pci_hotplug serio_raw button serial_core reiserfs usbhid hid
        uhci_hcd radeon ttm drm_kms_helper drm i2c_algo_bit ehci_hcd
        usbcore i2c_core xenblk cdrom xennet fan processor ata_generic
        thermal thermal_sys hwmon aacraid<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181723] <br>
        May 14 10:39:20 nodo4 kernel: [9480398.181727] Pid: 3608, comm:
        multipathd Not tainted 2.6.37.6-0.9-xen #1 IBM IBM System x3650
        -[7979AC1]-/System Planar<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181737] RIP:
        e030:[&lt;ffffffffa0843a63&gt;]&nbsp; [&lt;ffffffffa0843a63&gt;]
        dm_set_device_limits+0x23/0x140 [dm_mod]<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181748] RSP:
        e02b:ffff88034cdddc78&nbsp; EFLAGS: 00010296<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181752] RAX:
        ffff88020f3b5b40 RBX: ffff88020f3b5bc0 RCX: 0000000000200000<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181757] RDX:
        0000000000000000 RSI: 0000000000000000 RDI: ffffc9000007d040<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181761] RBP:
        ffffc9000007d040 R08: ffff88034cdddd58 R09: 0000000000000200<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181766] R10:
        0000000000000008 R11: 00003ffffffff000 R12: ffff88020f3b5c78<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181771] R13:
        0000000000000000 R14: ffff88034cdddd58 R15: ffff88020f3b5c40<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181779] FS:&nbsp;
        00007fd29961d700(0000) GS:ffff8803602bf000(0000)
        knlGS:0000000000000000<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181785] CS:&nbsp; e033 DS:
        0000 ES: 0000 CR0: 0000000080050033<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181789] CR2:
        0000000000000000 CR3: 000000034e657000 CR4: 0000000000042660<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181794] DR0:
        0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181799] DR3:
        0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181804] Process
        multipathd (pid: 3608, threadinfo ffff88034cddc000, task
        ffff88034cdda780)<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181809] Stack:<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181811]&nbsp; 00000000000000d2
        ffff880351c50b80 ffff88034cdddcc8 0000000000000007<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181819]&nbsp; ffff880351c50bf0
        0000000000000001 ffff880351c50ba0 ffffffff8005e61f<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181827]&nbsp; ffff88034cdddce8
        ffffffff8002e082 ffff88020f3b5bc0 ffffc9000007d040<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181834] Call Trace:<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181864]&nbsp;
        [&lt;ffffffffa09c2425&gt;] multipath_iterate_devices+0x55/0x80
        [dm_multipath]<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181878]&nbsp;
        [&lt;ffffffffa084482c&gt;] dm_calculate_queue_limits+0x8c/0x130
        [dm_mod]<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181899]&nbsp;
        [&lt;ffffffffa084273b&gt;] dm_swap_table+0x6b/0x90 [dm_mod]<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181915]&nbsp;
        [&lt;ffffffffa0847048&gt;] do_resume+0x88/0x1b0 [dm_mod]<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181940]&nbsp;
        [&lt;ffffffffa0847e6c&gt;] ctl_ioctl+0x1ac/0x250 [dm_mod]<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181966]&nbsp;
        [&lt;ffffffffa0847f1e&gt;] dm_ctl_ioctl+0xe/0x20 [dm_mod]<br>
        May 14 10:39:20 nodo4 kernel: [9480398.181992]&nbsp;
        [&lt;ffffffff8012da89&gt;] do_vfs_ioctl+0x89/0x340<br>
        May 14 10:39:20 nodo4 kernel: [9480398.182001]&nbsp;
        [&lt;ffffffff8012ddc0&gt;] sys_ioctl+0x80/0xa0<br>
        May 14 10:39:20 nodo4 kernel: [9480398.182009]&nbsp;
        [&lt;ffffffff80007448&gt;] system_call_fastpath+0x16/0x1b<br>
        May 14 10:39:20 nodo4 kernel: [9480398.182018]&nbsp;
        [&lt;00007fd29848ed87&gt;] 0x7fd29848ed87<br>
        May 14 10:39:20 nodo4 kernel: [9480398.182021] Code: fd ff ff 0f
        1f 44 00 00 48 83 ec 78 48 89 6c 24 58 4c 89 64 24 60 48 89 fd
        4c 89 6c 24 68 48 89 5c 24 50 49 89 d5 4c 89 74 24 70 &lt;4c&gt;
        8b 36 4d 89 c4 49 8b 86 a0 00 00 00 48 8b 98 10 03 00 00 48 <br>
        May 14 10:39:20 nodo4 kernel: [9480398.182074] RIP&nbsp;
        [&lt;ffffffffa0843a63&gt;] dm_set_device_limits+0x23/0x140
        [dm_mod]<br>
        May 14 10:39:20 nodo4 kernel: [9480398.182083]&nbsp; RSP
        &lt;ffff88034cdddc78&gt;<br>
        May 14 10:39:20 nodo4 kernel: [9480398.182086] CR2:
        0000000000000000<br>
        May 14 10:39:20 nodo4 kernel: [9480398.182666] ---[ end trace
        47ea050a3e10cad9 ]---<br>
        May 14 10:39:20 nodo4 kernel: [9480398.216228] sd 4:0:0:0: [sdc]
        Synchronizing SCSI cache<br>
        May 14 10:39:20 nodo4 kernel: [9480398.216281] sd 4:0:0:0:
        [sdc]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:39:21 nodo4 kernel: [9480398.244149] sd 4:0:0:1: [sde]
        Synchronizing SCSI cache<br>
        May 14 10:39:21 nodo4 kernel: [9480398.244188] sd 4:0:0:1:
        [sde]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:39:21 nodo4 kernel: [9480398.276178] sd 4:0:1:0: [sdg]
        Synchronizing SCSI cache<br>
        May 14 10:39:21 nodo4 kernel: [9480398.276218] sd 4:0:1:0:
        [sdg]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:39:21 nodo4 kernel: [9480398.312146] sd 4:0:1:1: [sdi]
        Synchronizing SCSI cache<br>
        May 14 10:39:21 nodo4 kernel: [9480398.312185] sd 4:0:1:1:
        [sdi]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:39:43 nodo4 kernel: [9480420.907033] scsi 3:0:0:0:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:39:43 nodo4 kernel: [9480420.907804] scsi 3:0:0:0:
        rdac: LUN 0 (unowned)<br>
        May 14 10:39:43 nodo4 kernel: [9480420.908038] sd 3:0:0:0:
        Attached scsi generic sg8 type 0<br>
        May 14 10:39:43 nodo4 kernel: [9480420.908044] sd 3:0:0:0:
        Embedded Enclosure Device<br>
        May 14 10:39:44 nodo4 kernel: [9480421.369100] scsi 4:0:0:0:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:39:44 nodo4 kernel: [9480421.369856] scsi 4:0:0:0:
        rdac: LUN 0 (owned)<br>
        May 14 10:39:44 nodo4 kernel: [9480421.904087] sd 3:0:0:0:
        Failed to get diagnostic page 0x10000<br>
        May 14 10:39:44 nodo4 kernel: [9480421.904094] sd 3:0:0:0:
        Failed to bind enclosure -19<br>
        May 14 10:39:44 nodo4 kernel: [9480421.904268] sd 4:0:0:0:
        Attached scsi generic sg9 type 0<br>
        May 14 10:39:44 nodo4 kernel: [9480421.904285] sd 4:0:0:0:
        Embedded Enclosure Device<br>
        May 14 10:39:44 nodo4 kernel: [9480421.911840] scsi 3:0:0:1:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:39:44 nodo4 kernel: [9480421.912615] scsi 3:0:0:1:
        rdac: LUN 1 (unowned)<br>
        May 14 10:40:12 nodo4 kernel: [9480449.864814] sd 3:0:0:0: [sdf]
        419430400 512-byte logical blocks: (214 GB/200 GiB)<br>
        May 14 10:40:24 nodo4 kernel: [9480462.172112] sd 3:0:0:0: [sdf]
        Write Protect is off<br>
        May 14 10:40:24 nodo4 kernel: [9480462.172126] sd 3:0:0:0: [sdf]
        Mode Sense: 77 00 10 08<br>
        May 14 10:40:24 nodo4 kernel: [9480462.172262] sd 3:0:0:1: [sdk]
        2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)<br>
        May 14 10:40:24 nodo4 kernel: [9480462.209408] sd 3:0:0:0: [sdf]
        Write cache: enabled, read cache: enabled, supports DPO and FUA<br>
        May 14 10:40:25 nodo4 kernel: [9480462.238939] sd 3:0:0:1: [sdk]
        Write Protect is off<br>
        May 14 10:40:25 nodo4 kernel: [9480462.238945] sd 3:0:0:1: [sdk]
        Mode Sense: 77 00 10 08<br>
        May 14 10:40:25 nodo4 kernel: [9480462.260063] sd 3:0:0:1: [sdk]
        Write cache: enabled, read cache: enabled, supports DPO and FUA<br>
        May 14 10:40:25 nodo4 kernel: [9480462.282119]
        ldm_validate_partition_table(): Disk read failed.<br>
        May 14 10:40:25 nodo4 kernel: [9480462.282206]&nbsp; sdf: unable to
        read partition table<br>
        May 14 10:40:25 nodo4 kernel: [9480462.299524]
        ldm_validate_partition_table(): Disk read failed.<br>
        May 14 10:40:25 nodo4 kernel: [9480462.299608]&nbsp; sdk: unable to
        read partition table<br>
        May 14 10:40:25 nodo4 kernel: [9480462.334705] sd 3:0:0:0: [sdf]
        Attached SCSI disk<br>
        May 14 10:40:25 nodo4 kernel: [9480462.346239] sd 3:0:0:1: [sdk]
        Attached SCSI disk<br>
        May 14 10:40:42 nodo4 kernel: [9480480.156067]&nbsp; rport-3:0-1:
        blocked FC remote port time out: removing target and saving
        binding<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220064]&nbsp; rport-4:0-0:
        blocked FC remote port time out: removing target and saving
        binding<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220133] sd 4:0:0:0:
        Failed to get diagnostic page 0x10000<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220151] sd 4:0:0:0:
        Failed to bind enclosure -19<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220166] sd 4:0:0:0: [sdj]
        READ CAPACITY(16) failed<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220178] sd 4:0:0:0:
        [sdj]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220186] sd 4:0:0:0: [sdj]
        Sense not available.<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220218] sd 4:0:0:0: [sdj]
        READ CAPACITY failed<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220222] sd 4:0:0:0:
        [sdj]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220229] sd 4:0:0:0: [sdj]
        Sense not available.<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220263] sd 4:0:0:0: [sdj]
        Write Protect is off<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220269] sd 4:0:0:0: [sdj]
        Mode Sense: 00 00 00 00<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220284] sd 4:0:0:0: [sdj]
        Asking for cache data failed<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220288] sd 4:0:0:0: [sdj]
        Assuming drive cache: write through<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220497] sd 3:0:0:1:
        Attached scsi generic sg10 type 0<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220509] sd 3:0:0:1:
        Embedded Enclosure Device<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220623] sd 4:0:0:0: [sdj]
        READ CAPACITY(16) failed<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220634] sd 4:0:0:0:
        [sdj]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220641] sd 4:0:0:0: [sdj]
        Sense not available.<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220675] sd 4:0:0:0: [sdj]
        READ CAPACITY failed<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220679] sd 4:0:0:0:
        [sdj]&nbsp; Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220685] sd 4:0:0:0: [sdj]
        Sense not available.<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220726] sd 4:0:0:0: [sdj]
        Asking for cache data failed<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220731] sd 4:0:0:0: [sdj]
        Assuming drive cache: write through<br>
        May 14 10:40:42 nodo4 kernel: [9480480.220735] sd 4:0:0:0: [sdj]
        Attached SCSI disk<br>
        May 14 10:40:43 nodo4 kernel: [9480480.224842] scsi 4:0:1:0:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:40:43 nodo4 kernel: [9480480.226028] scsi 4:0:1:0:
        rdac: LUN 0 (owned)<br>
        May 14 10:40:43 nodo4 kernel: [9480480.226896] sd 4:0:1:0: [sdl]
        419430400 512-byte logical blocks: (214 GB/200 GiB)<br>
        May 14 10:40:43 nodo4 kernel: [9480480.228114] sd 4:0:1:0: [sdl]
        Write Protect is off<br>
        May 14 10:40:43 nodo4 kernel: [9480480.228121] sd 4:0:1:0: [sdl]
        Mode Sense: 77 00 10 08<br>
        May 14 10:40:43 nodo4 kernel: [9480480.228481] sd 4:0:1:0: [sdl]
        Write cache: enabled, read cache: enabled, supports DPO and FUA<br>
        May 14 10:40:43 nodo4 kernel: [9480480.230883]&nbsp; sdl: sdl1<br>
        May 14 10:40:43 nodo4 kernel: [9480480.234706] sd 4:0:1:0: [sdl]
        Attached SCSI disk<br>
        May 14 10:40:43 nodo4 kernel: [9480480.484994] sd 3:0:0:1: FIXME
        driver has no support for subenclosures (1)<br>
        May 14 10:40:43 nodo4 kernel: [9480480.485001] sd 3:0:0:1:
        Failed to bind enclosure -12<br>
        May 14 10:40:43 nodo4 kernel: [9480480.485222] sd 4:0:1:0:
        Attached scsi generic sg11 type 0<br>
        May 14 10:40:43 nodo4 kernel: [9480480.485228] sd 4:0:1:0:
        Embedded Enclosure Device<br>
        May 14 10:40:43 nodo4 kernel: [9480480.486067] scsi 3:0:0:31:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Universal Xport&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:40:43 nodo4 kernel: [9480480.772006] sd 4:0:1:0: FIXME
        driver has no support for subenclosures (1)<br>
        May 14 10:40:43 nodo4 kernel: [9480480.772013] sd 4:0:1:0:
        Failed to bind enclosure -12<br>
        May 14 10:40:43 nodo4 kernel: [9480480.772173] scsi 3:0:0:31:
        Attached scsi generic sg12 type 0<br>
        May 14 10:40:43 nodo4 kernel: [9480480.772187] scsi 3:0:0:31:
        Embedded Enclosure Device<br>
        May 14 10:40:43 nodo4 kernel: [9480480.772708] scsi 3:0:0:31:
        Failed to get diagnostic page 0x8000002<br>
        May 14 10:40:43 nodo4 kernel: [9480480.772714] scsi 3:0:0:31:
        Failed to bind enclosure -19<br>
        May 14 10:40:43 nodo4 kernel: [9480480.783457] scsi 4:0:1:1:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:40:43 nodo4 kernel: [9480480.802754] scsi 4:0:1:1:
        rdac: LUN 1 (owned)<br>
        May 14 10:40:43 nodo4 kernel: [9480480.802898] sd 4:0:1:1:
        Attached scsi generic sg13 type 0<br>
        May 14 10:40:43 nodo4 kernel: [9480480.802904] sd 4:0:1:1:
        Embedded Enclosure Device<br>
        May 14 10:40:43 nodo4 kernel: [9480480.803595] sd 4:0:1:1:
        Failed to get diagnostic page 0x8000002<br>
        May 14 10:40:43 nodo4 kernel: [9480480.803601] sd 4:0:1:1:
        Failed to bind enclosure -19<br>
        May 14 10:40:43 nodo4 kernel: [9480480.804166] sd 4:0:1:1: [sdm]
        2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)<br>
        May 14 10:40:43 nodo4 kernel: [9480480.804492] scsi 4:0:1:31:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Universal Xport&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:40:43 nodo4 kernel: [9480480.804891] scsi 4:0:1:31:
        Attached scsi generic sg14 type 0<br>
        May 14 10:40:43 nodo4 kernel: [9480480.804896] scsi 4:0:1:31:
        Embedded Enclosure Device<br>
        May 14 10:40:43 nodo4 kernel: [9480480.805276] scsi 4:0:1:31:
        Failed to get diagnostic page 0x8000002<br>
        May 14 10:40:43 nodo4 kernel: [9480480.805282] scsi 4:0:1:31:
        Failed to bind enclosure -19<br>
        May 14 10:40:43 nodo4 kernel: [9480480.805602] sd 4:0:0:0: rdac:
        Detached<br>
        May 14 10:40:43 nodo4 kernel: [9480480.806204] sd 4:0:1:1: [sdm]
        Write Protect is off<br>
        May 14 10:40:43 nodo4 kernel: [9480480.806216] sd 4:0:1:1: [sdm]
        Mode Sense: 77 00 10 08<br>
        May 14 10:40:43 nodo4 kernel: [9480480.806609] sd 4:0:1:1: [sdm]
        Write cache: enabled, read cache: enabled, supports DPO and FUA<br>
        May 14 10:40:43 nodo4 kernel: [9480480.808631]&nbsp; sdm: sdm1<br>
        May 14 10:40:43 nodo4 kernel: [9480480.810486] sd 4:0:1:1: [sdm]
        Attached SCSI disk<br>
        May 14 10:41:17 nodo4 kernel: [9480514.905354] scsi 3:0:1:0:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:41:17 nodo4 kernel: [9480514.906146] scsi 3:0:1:0:
        rdac: LUN 0 (unowned)<br>
        May 14 10:41:17 nodo4 kernel: [9480514.906376] sd 3:0:1:0:
        Attached scsi generic sg9 type 0<br>
        May 14 10:41:17 nodo4 kernel: [9480514.906381] sd 3:0:1:0:
        Embedded Enclosure Device<br>
        May 14 10:41:18 nodo4 kernel: [9480515.369473] scsi 4:0:0:0:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:41:18 nodo4 kernel: [9480515.370229] scsi 4:0:0:0:
        rdac: LUN 0 (unowned)<br>
        May 14 10:41:46 nodo4 kernel: [9480543.616449] sd 4:0:0:0: [sdn]
        419430400 512-byte logical blocks: (214 GB/200 GiB)<br>
        May 14 10:41:46 nodo4 kernel: [9480543.616528] sd 3:0:1:0: [sdj]
        419430400 512-byte logical blocks: (214 GB/200 GiB)<br>
        May 14 10:41:46 nodo4 kernel: [9480543.683122] sd 3:0:1:0: FIXME
        driver has no support for subenclosures (1)<br>
        May 14 10:41:46 nodo4 kernel: [9480543.683128] sd 3:0:1:0:
        Failed to bind enclosure -12<br>
        May 14 10:41:46 nodo4 kernel: [9480543.683369] sd 4:0:0:0:
        Attached scsi generic sg15 type 0<br>
        May 14 10:41:46 nodo4 kernel: [9480543.683375] sd 4:0:0:0:
        Embedded Enclosure Device<br>
        May 14 10:41:46 nodo4 kernel: [9480544.223913] sd 4:0:0:0: [sdn]
        Write Protect is off<br>
        May 14 10:41:46 nodo4 kernel: [9480544.223920] sd 4:0:0:0: [sdn]
        Mode Sense: 77 00 10 08<br>
        May 14 10:41:47 nodo4 kernel: [9480544.224710] sd 3:0:1:0: [sdj]
        Write Protect is off<br>
        May 14 10:41:47 nodo4 kernel: [9480544.224716] sd 3:0:1:0: [sdj]
        Mode Sense: 77 00 10 08<br>
        May 14 10:41:47 nodo4 kernel: [9480544.240556] scsi 3:0:1:1:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:41:47 nodo4 kernel: [9480544.259638] sd 4:0:0:0: [sdn]
        Write cache: enabled, read cache: enabled, supports DPO and FUA<br>
        May 14 10:41:47 nodo4 kernel: [9480544.260276] sd 3:0:1:0: [sdj]
        Write cache: enabled, read cache: enabled, supports DPO and FUA<br>
        May 14 10:41:48 nodo4 kernel: [9480546.038746] sd 4:0:0:0: FIXME
        driver has no support for subenclosures (1)<br>
        May 14 10:41:48 nodo4 kernel: [9480546.038754] sd 4:0:0:0:
        Failed to bind enclosure -12<br>
        May 14 10:41:48 nodo4 kernel: [9480546.039500] scsi 3:0:1:1:
        rdac: LUN 1 (unowned)<br>
        May 14 10:41:48 nodo4 kernel: [9480546.039678] sd 3:0:1:1:
        Attached scsi generic sg16 type 0<br>
        May 14 10:41:48 nodo4 kernel: [9480546.039684] sd 3:0:1:1:
        Embedded Enclosure Device<br>
        May 14 10:41:48 nodo4 kernel: [9480546.087292] scsi 4:0:0:1:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1726-4xx&nbsp; FAStT&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:41:48 nodo4 kernel: [9480546.094112]
        ldm_validate_partition_table(): Disk read failed.<br>
        May 14 10:41:48 nodo4 kernel: [9480546.094271]
        ldm_validate_partition_table(): Disk read failed.<br>
        May 14 10:41:48 nodo4 kernel: [9480546.094357]&nbsp; sdj: unable to
        read partition table<br>
        May 14 10:41:48 nodo4 kernel: [9480546.094464]&nbsp; sdn: unable to
        read partition table<br>
        May 14 10:41:48 nodo4 kernel: [9480546.104559] scsi 4:0:0:1:
        rdac: LUN 1 (unowned)<br>
        May 14 10:41:49 nodo4 kernel: [9480546.287268] sd 3:0:1:1: FIXME
        driver has no support for subenclosures (1)<br>
        May 14 10:41:49 nodo4 kernel: [9480546.287274] sd 3:0:1:1:
        Failed to bind enclosure -12<br>
        May 14 10:41:49 nodo4 kernel: [9480546.287434] sd 4:0:0:1:
        Attached scsi generic sg17 type 0<br>
        May 14 10:41:49 nodo4 kernel: [9480546.287440] sd 4:0:0:1:
        Embedded Enclosure Device<br>
        May 14 10:41:49 nodo4 kernel: [9480546.303619] sd 4:0:0:1: [sdp]
        2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)<br>
        May 14 10:41:49 nodo4 kernel: [9480546.304315] sd 3:0:1:1: [sdo]
        2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)<br>
        May 14 10:41:49 nodo4 kernel: [9480546.305037] scsi 3:0:1:31:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Universal Xport&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:41:49 nodo4 kernel: [9480546.310818] sd 4:0:0:0: [sdn]
        Attached SCSI disk<br>
        May 14 10:41:49 nodo4 kernel: [9480546.311119] sd 3:0:1:0: [sdj]
        Attached SCSI disk<br>
        May 14 10:41:49 nodo4 kernel: [9480546.325288] sd 4:0:0:1: [sdp]
        Write Protect is off<br>
        May 14 10:41:49 nodo4 kernel: [9480546.325295] sd 4:0:0:1: [sdp]
        Mode Sense: 77 00 10 08<br>
        May 14 10:41:49 nodo4 kernel: [9480546.325684] sd 3:0:1:1: [sdo]
        Write Protect is off<br>
        May 14 10:41:49 nodo4 kernel: [9480546.325689] sd 3:0:1:1: [sdo]
        Mode Sense: 77 00 10 08<br>
        May 14 10:41:49 nodo4 kernel: [9480546.330743] sd 4:0:0:1: [sdp]
        Write cache: enabled, read cache: enabled, supports DPO and FUA<br>
        May 14 10:41:49 nodo4 kernel: [9480546.331160] sd 3:0:1:1: [sdo]
        Write cache: enabled, read cache: enabled, supports DPO and FUA<br>
        May 14 10:41:49 nodo4 kernel: [9480546.656447]
        ldm_validate_partition_table(): Disk read failed.<br>
        May 14 10:41:49 nodo4 kernel: [9480546.656584]
        ldm_validate_partition_table(): Disk read failed.<br>
        May 14 10:41:49 nodo4 kernel: [9480546.656668]&nbsp; sdo: unable to
        read partition table<br>
        May 14 10:41:49 nodo4 kernel: [9480546.656797]&nbsp; sdp: unable to
        read partition table<br>
        May 14 10:41:49 nodo4 kernel: [9480546.673418] sd 4:0:0:1: FIXME
        driver has no support for subenclosures (1)<br>
        May 14 10:41:49 nodo4 kernel: [9480546.673431] sd 4:0:0:1:
        Failed to bind enclosure -12<br>
        May 14 10:41:49 nodo4 kernel: [9480546.673645] scsi 3:0:1:31:
        Attached scsi generic sg18 type 0<br>
        May 14 10:41:49 nodo4 kernel: [9480546.673653] scsi 3:0:1:31:
        Embedded Enclosure Device<br>
        May 14 10:41:49 nodo4 kernel: [9480546.674071] scsi 3:0:1:31:
        Failed to get diagnostic page 0x8000002<br>
        May 14 10:41:49 nodo4 kernel: [9480546.674076] scsi 3:0:1:31:
        Failed to bind enclosure -19<br>
        May 14 10:41:49 nodo4 kernel: [9480546.674709] sd 3:0:1:1: [sdo]
        Attached SCSI disk<br>
        May 14 10:41:49 nodo4 kernel: [9480546.675193] sd 4:0:0:1: [sdp]
        Attached SCSI disk<br>
        May 14 10:41:49 nodo4 kernel: [9480546.676734] scsi 4:0:0:31:
        Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Universal Xport&nbsp; 0617 PQ: 0 ANSI: 5<br>
        May 14 10:41:49 nodo4 kernel: [9480546.676886] scsi 4:0:0:31:
        Attached scsi generic sg19 type 0<br>
        May 14 10:41:49 nodo4 kernel: [9480546.676891] scsi 4:0:0:31:
        Embedded Enclosure Device<br>
        May 14 10:41:49 nodo4 kernel: [9480546.677767] scsi 4:0:0:31:
        Failed to get diagnostic page 0x8000002<br>
        May 14 10:41:49 nodo4 kernel: [9480546.677773] scsi 4:0:0:31:
        Failed to bind enclosure -19<br>
        May 14 10:41:49 nodo4 udevd-work[2477]: symlink '../../sdo'
        '/dev/disk/by-id/scsi-3600a0b80003696ab000014c64ef2ee5b.udev-tmp'
        failed: File exists<br>
        May 14 10:42:20 nodo4 udevd[388]: worker [28740] unexpectedly
        returned with status 0x0100<br>
        May 14 10:42:20 nodo4 udevd[388]: worker [28740] failed while
        handling '/devices/virtual/block/dm-0'<br>
        May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdb, open()
        failed: No such device<br>
        May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdc, open()
        failed: No such device<br>
        May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdd, open()
        failed: No such device<br>
        May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sde, open()
        failed: No such device<br>
        May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdg, open()
        failed: No such device<br>
        May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdh, open()
        failed: No such device<br>
        May 14 10:44:59 nodo4 smartd[3504]: Device: /dev/sdi, open()
        failed: No such device<br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
      </small></i><br>
  </body>
</html>

--------------060705010603070502000908--


--===============0191351416987050642==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0191351416987050642==--
