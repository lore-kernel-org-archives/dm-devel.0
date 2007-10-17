From: "Gerald Nowitzky" <Nowitzky@igne.de>
Subject: multibus / failover and EMC CX600
Date: Wed, 17 Oct 2007 12:23:42 +0200
Message-ID: <061401c810a7$cac685d0$0a00a8c0@ALDI2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
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

Hello!

I am a little stuck with my multipath. kpartx is doing well now, my failover 
works, but failback doesn't. Some strange things in the syslog - but 
one-by-one:

- I have a host with two HBAs (HBA-A and B)
- these are connected to two Switches (HBA-A to SW-A and HBA-B to SW-B)
- each of Switches is connected to both Service Processors (SP-A and SP-B) 
of my EMC CX600
- The CX600 is not multihomed, thus either SP-A or SP-B is servicing my LUN.

What I'd like to have is multibus via HBA-A -> SW-A -> SP-A  and HBA-B -> 
SW-B -> SP-A to the active SP and, in case both paths to the active SP fail, 
a trespas of my LUN to SP-B, multibus to the other SP-B and vice versa.

I thought "group_by_serial" should do for that, but it doesn't

I get messages about failing and recovering paths in the syslog, but the 
failover von SP-B to SP-A works, but then I get strange things in the log 
and failing back doesn't work:

-> All paths ok, SP-A is holding the LUN:

SANfile_m ~ # multipath -l
hcfshare (360060160c820080063502869e459dc11) dm-0 DGC     ,RAID 5
[size=3.4T][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=0][active]
 \_ 2:0:1:0 sde 8:64  [active][undef]
 \_ 2:0:0:0 sdd 8:48  [active][undef]
 \_ 1:0:1:0 sdc 8:32  [active][undef]
 \_ 1:0:0:0 sdb 8:16  [active][undef]

SANfile_m ~ # dmsetup table
hcfshare1: 0 7263453117 linear 253:0 34
hcfshare: 0 7263453184 multipath 1 queue_if_no_path 1 emc 1 1 round-robin 0 
4 1 8:64 1000 8:48 1000 8:32 1000 8:16 1000

syslog:
Oct 16 21:29:50 SANfile_m multipathd: sdd: emc_clariion_checker: Passive 
path is healthy.
Oct 16 21:29:50 SANfile_m multipathd: 8:48: reinstated
Oct 16 21:29:50 SANfile_m multipathd: hcfshare: remaining active paths: 3
Oct 16 21:29:50 SANfile_m kernel: sd 2:0:0:0: [sdd] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:29:50 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:29:50 SANfile_m kernel: end_request: I/O error, dev sdd, sector 
6609990458
Oct 16 21:29:50 SANfile_m kernel: device-mapper: multipath: Failing path 
8:48.
Oct 16 21:29:50 SANfile_m multipathd: sdb: emc_clariion_checker: Passive 
path is healthy.
Oct 16 21:29:50 SANfile_m multipathd: 8:16: reinstated
Oct 16 21:29:50 SANfile_m multipathd: hcfshare: remaining active paths: 4
Oct 16 21:29:50 SANfile_m kernel: sd 1:0:0:0: [sdb] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:29:50 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:29:50 SANfile_m kernel: end_request: I/O error, dev sdb, sector 
6609991482
Oct 16 21:29:50 SANfile_m kernel: device-mapper: multipath: Failing path 
8:16.
Oct 16 21:29:50 SANfile_m multipathd: 8:48: mark as failed
Oct 16 21:29:50 SANfile_m multipathd: hcfshare: remaining active paths: 3
Oct 16 21:29:50 SANfile_m multipathd: 8:16: mark as failed
Oct 16 21:29:50 SANfile_m multipathd: hcfshare: remaining active paths: 2
Oct 16 21:29:55 SANfile_m multipathd: sdd: emc_clariion_checker: Passive 
path is healthy.
Oct 16 21:29:55 SANfile_m multipathd: 8:48: reinstated
Oct 16 21:29:55 SANfile_m multipathd: hcfshare: remaining active paths: 3
Oct 16 21:29:55 SANfile_m kernel: sd 2:0:0:0: [sdd] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:29:55 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:29:55 SANfile_m kernel: end_request: I/O error, dev sdd, sector 
2072001426
Oct 16 21:29:55 SANfile_m kernel: device-mapper: multipath: Failing path 
8:48.
Oct 16 21:29:55 SANfile_m multipathd: sdb: emc_clariion_checker: Passive 
path is healthy.
Oct 16 21:29:55 SANfile_m multipathd: 8:16: reinstated
Oct 16 21:29:55 SANfile_m multipathd: hcfshare: remaining active paths: 4
Oct 16 21:29:55 SANfile_m kernel: sd 1:0:0:0: [sdb] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:29:55 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:29:55 SANfile_m kernel: end_request: I/O error, dev sdb, sector 
2072001938
Oct 16 21:29:55 SANfile_m kernel: device-mapper: multipath: Failing path 
8:16.
Oct 16 21:29:55 SANfile_m multipathd: 8:48: mark as failed
Oct 16 21:29:55 SANfile_m multipathd: hcfshare: remaining active paths: 3
Oct 16 21:29:55 SANfile_m multipathd: 8:16: mark as failed
Oct 16 21:29:55 SANfile_m multipathd: hcfshare: remaining active paths: 2
Oct 16 21:30:00 SANfile_m multipathd: sdd: emc_clariion_checker: Passive 
path is healthy.
Oct 16 21:30:00 SANfile_m multipathd: 8:48: reinstated
Oct 16 21:30:00 SANfile_m multipathd: hcfshare: remaining active paths: 3
Oct 16 21:30:00 SANfile_m kernel: sd 2:0:0:0: [sdd] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:30:00 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:30:00 SANfile_m kernel: end_request: I/O error, dev sdd, sector 
3208345898
Oct 16 21:30:00 SANfile_m kernel: device-mapper: multipath: Failing path 
8:48.
Oct 16 21:30:00 SANfile_m multipathd: sdb: emc_clariion_checker: Passive 
path is healthy.
Oct 16 21:30:00 SANfile_m multipathd: 8:16: reinstated
Oct 16 21:30:00 SANfile_m multipathd: hcfshare: remaining active paths: 4
Oct 16 21:30:00 SANfile_m multipathd: 8:48: mark as failed
Oct 16 21:30:00 SANfile_m multipathd: hcfshare: remaining active paths: 3
Oct 16 21:30:00 SANfile_m kernel: sd 1:0:0:0: [sdb] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:30:00 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:30:00 SANfile_m kernel: end_request: I/O error, dev sdb, sector 
3208346410
Oct 16 21:30:00 SANfile_m kernel: device-mapper: multipath: Failing path 
8:16.

Now both paths to SP-A fail, the failover to SP-B works:
syslog:
Oct 16 21:32:15 SANfile_m kernel:  rport-2:0-1: blocked FC remote port time 
out: removing target and saving binding
Oct 16 21:32:17 SANfile_m kernel:  rport-1:0-1: blocked FC remote port time 
out: removing target and saving binding
Oct 16 21:32:17 SANfile_m multipathd: 8:64: mark as failed
Oct 16 21:32:17 SANfile_m multipathd: hcfshare: remaining active paths: 3
Oct 16 21:32:17 SANfile_m multipathd: 8:48: mark as failed
Oct 16 21:32:17 SANfile_m multipathd: hcfshare: remaining active paths: 2
Oct 16 21:32:17 SANfile_m multipathd: 8:32: mark as failed
Oct 16 21:32:17 SANfile_m multipathd: hcfshare: remaining active paths: 1
Oct 16 21:32:17 SANfile_m multipathd: 8:16: mark as failed
Oct 16 21:32:17 SANfile_m multipathd: hcfshare: Entering recovery mode: 
max_retries=60
Oct 16 21:32:17 SANfile_m multipathd: hcfshare: remaining active paths: 0
Oct 16 21:32:17 SANfile_m multipathd: hcfshare: Entering recovery mode: 
max_retries=60
Oct 16 21:32:22 SANfile_m kernel: scsi 2:0:1:0: rejecting I/O to dead device
Oct 16 21:32:22 SANfile_m multipathd: sde: emc_clariion_checker: query 
command indicates error
Oct 16 21:32:22 SANfile_m multipathd: sdd: emc_clariion_checker: Passive 
path is healthy.
Oct 16 21:32:22 SANfile_m multipathd: 8:48: reinstated
Oct 16 21:32:22 SANfile_m multipathd: hcfshare: queue_if_no_path enabled
Oct 16 21:32:22 SANfile_m multipathd: hcfshare: Recovered to normal mode
Oct 16 21:32:22 SANfile_m kernel: device-mapper: multipath emc: emc_pg_init: 
sending switch-over command
Oct 16 21:32:22 SANfile_m multipathd: hcfshare: remaining active paths: 1
Oct 16 21:32:22 SANfile_m kernel: scsi 1:0:1:0: rejecting I/O to dead device
Oct 16 21:32:22 SANfile_m multipathd: sdc: emc_clariion_checker: query 
command indicates error
Oct 16 21:32:22 SANfile_m multipathd: sdb: emc_clariion_checker: Active path 
is healthy.
Oct 16 21:32:22 SANfile_m multipathd: 8:16: reinstated
Oct 16 21:32:22 SANfile_m multipathd: hcfshare: remaining active paths: 2
Oct 16 21:32:27 SANfile_m kernel: scsi 2:0:1:0: rejecting I/O to dead device
Oct 16 21:32:27 SANfile_m multipathd: sde: emc_clariion_checker: query 
command indicates error
Oct 16 21:32:27 SANfile_m kernel: scsi 1:0:1:0: rejecting I/O to dead device
Oct 16 21:32:27 SANfile_m multipathd: sdc: emc_clariion_checker: query 
command indicates error
Oct 16 21:32:32 SANfile_m kernel: scsi 2:0:1:0: rejecting I/O to dead device
Oct 16 21:32:32 SANfile_m kernel: scsi 1:0:1:0: rejecting I/O to dead device
Oct 16 21:32:32 SANfile_m multipathd: sde: emc_clariion_checker: query 
command indicates error
Oct 16 21:32:32 SANfile_m multipathd: sdc: emc_clariion_checker: query 
command indicates error
Oct 16 21:32:37 SANfile_m kernel: scsi 2:0:1:0: rejecting I/O to dead device
Oct 16 21:32:37 SANfile_m multipathd: sde: emc_clariion_checker: query 
command indicates error
Oct 16 21:32:37 SANfile_m kernel: scsi 1:0:1:0: rejecting I/O to dead device
Oct 16 21:32:37 SANfile_m multipathd: sdc: emc_clariion_checker: query 
command indicates error
Oct 16 21:32:42 SANfile_m multipathd: sde: emc_clariion_checker: query 
command indicates error
Oct 16 21:32:42 SANfile_m multipathd: sdc: emc_clariion_checker: query 
command indicates error
Oct 16 21:32:42 SANfile_m kernel: scsi 2:0:1:0: rejecting I/O to dead device
Oct 16 21:32:42 SANfile_m kernel: scsi 1:0:1:0: rejecting I/O to dead device


hcfshare (360060160c820080063502869e459dc11) dm-0 ,
[size=3.4T][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=0][active]
 \_ #:#:#:# -   #:#   [failed][undef]
 \_ 2:0:0:0 sdd 8:48  [active][undef]
 \_ #:#:#:# -   #:#   [failed][undef]
 \_ 1:0:0:0 sdb 8:16  [active][undef]

SANfile_m ~ # dmsetup table
hcfshare1: 0 7263453117 linear 253:0 34
hcfshare: 0 7263453184 multipath 1 queue_if_no_path 1 emc 1 1 round-robin 0 
4 1 8:64 1000 8:48 1000 8:32 1000 8:16 1000


Now the paths to SP-A are coming up again but multipath still shows them as 
failed, and some disturbing messages in the
syslog:

SANfile_m ~ # multipath -l
hcfshare (360060160c820080063502869e459dc11) dm-0 ,
[size=3.4T][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=0][active]
 \_ #:#:#:# -   #:#   [failed][undef]
 \_ 2:0:0:0 sdd 8:48  [active][undef]
 \_ #:#:#:# -   #:#   [failed][undef]
 \_ 1:0:0:0 sdb 8:16  [active][undef]

SANfile_m ~ # dmsetup table
hcfshare1: 0 7263453117 linear 253:0 34
hcfshare: 0 7263453184 multipath 1 queue_if_no_path 1 emc 1 1 round-robin 0 
4 1 8:64 1000 8:48 1000 8:32 1000 8:16 1000

syslog:
Oct 16 21:35:27 SANfile_m kernel: scsi 1:0:1:0: Direct-Access     DGC 
RAID 5           0219 PQ: 0 ANSI: 4
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Very big device. Trying 
to use READ CAPACITY(16).
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] 7263453184 512-byte 
hardware sectors (3718888 MB)
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Test WP failed, assume 
Write Enabled
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Asking for cache data 
failed
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Assuming drive cache: 
write through
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Very big device. Trying 
to use READ CAPACITY(16).
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] 7263453184 512-byte 
hardware sectors (3718888 MB)
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Test WP failed, assume 
Write Enabled
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Asking for cache data 
failed
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Assuming drive cache: 
write through
Oct 16 21:35:27 SANfile_m kernel:  sdg:<6>sd 1:0:1:0: [sdg] Device not 
ready: <6>: Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: printk: 35 messages suppressed.
Oct 16 21:35:27 SANfile_m kernel: Buffer I/O error on device sdg, logical 
block 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: Buffer I/O error on device sdg, logical 
block 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: Buffer I/O error on device sdg, logical 
block 0
Oct 16 21:35:27 SANfile_m kernel: ldm_validate_partition_table(): Disk read 
failed.
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: Buffer I/O error on device sdg, logical 
block 0
Oct 16 21:35:27 SANfile_m kernel:  unable to read partition table
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Attached SCSI disk
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: Attached scsi generic sg4 type 
0
Oct 16 21:35:27 SANfile_m kernel: scsi 1:0:1:0: Direct-Access     DGC 
RAID 5           0219 PQ: 0 ANSI: 4
Oct 16 21:35:27 SANfile_m kernel: kobject_add failed for 1:0:1:0 
with -EEXIST, don't try to register things with the same name in the same 
directory.
Oct 16 21:35:27 SANfile_m kernel:  [number+85/816] 
kobject_shadow_add+0x115/0x1b0
Oct 16 21:35:27 SANfile_m kernel:  [<c02f95f5>] 
kobject_shadow_add+0x115/0x1b0
Oct 16 21:35:27 SANfile_m kernel:  [lo_ioctl+1125/2528] 
device_add+0xc5/0x570
Oct 16 21:35:27 SANfile_m kernel:  [<c03aefd5>] device_add+0xc5/0x570
Oct 16 21:35:27 SANfile_m kernel:  [fc_remote_port_rolechg+127/320] 
scsi_adjust_queue_depth+0x9f/0xf0
Oct 16 21:35:27 SANfile_m kernel:  [<c03f9d7f>] 
scsi_adjust_queue_depth+0x9f/0xf0
Oct 16 21:35:27 SANfile_m kernel:  [blk_register_region+18/64] 
__blk_queue_init_tags+0x32/0x70
Oct 16 21:35:27 SANfile_m kernel:  [<c02eeb72>] 
__blk_queue_init_tags+0x32/0x70
Oct 16 21:35:27 SANfile_m kernel:  [sr_get_mcn+2/240] 
scsi_sysfs_add_sdev+0x32/0x230
Oct 16 21:35:27 SANfile_m kernel:  [<c0402882>] 
scsi_sysfs_add_sdev+0x32/0x230
Oct 16 21:35:27 SANfile_m kernel:  [<f99445b7>] 
qla2xxx_slave_configure+0x77/0x110 [qla2xxx]
Oct 16 21:35:27 SANfile_m kernel:  [sd_init_command+313/1088] 
scsi_probe_and_add_lun+0x8c9/0x940
Oct 16 21:35:27 SANfile_m kernel:  [<c0400859>] 
scsi_probe_and_add_lun+0x8c9/0x940
Oct 16 21:35:27 SANfile_m kernel:  [sr_probe+72/1472] 
__scsi_scan_target+0x518/0x5c0
Oct 16 21:35:27 SANfile_m kernel:  [<c04012c8>] 
__scsi_scan_target+0x518/0x5c0
Oct 16 21:35:27 SANfile_m kernel:  [kallsyms_addresses+36259/130252] 
schedule+0x2df/0x940
Oct 16 21:35:27 SANfile_m kernel:  [<c053695f>] schedule+0x2df/0x940
Oct 16 21:35:27 SANfile_m kernel:  [sr_init_command+54/944] 
scsi_scan_target+0xb6/0xe0
Oct 16 21:35:27 SANfile_m kernel:  [<c04019f6>] scsi_scan_target+0xb6/0xe0
Oct 16 21:35:27 SANfile_m kernel:  [SendIocInit+224/784] 
fc_scsi_scan_rport+0x0/0x90
Oct 16 21:35:27 SANfile_m kernel:  [<c04084b0>] fc_scsi_scan_rport+0x0/0x90
Oct 16 21:35:27 SANfile_m kernel:  [SendIocInit+344/784] 
fc_scsi_scan_rport+0x78/0x90
Oct 16 21:35:27 SANfile_m kernel:  [<c0408528>] fc_scsi_scan_rport+0x78/0x90
Oct 16 21:35:27 SANfile_m kernel:  [run_workqueue+131/256] 
run_workqueue+0x73/0x100
Oct 16 21:35:27 SANfile_m kernel:  [<c0131dc3>] run_workqueue+0x73/0x100
Oct 16 21:35:27 SANfile_m kernel:  [autoremove_wake_function+16/80] 
autoremove_wake_function+0x0/0x50
Oct 16 21:35:27 SANfile_m kernel:  [<c01354e0>] 
autoremove_wake_function+0x0/0x50
Oct 16 21:35:27 SANfile_m kernel:  [worker_thread+172/256] 
worker_thread+0x9c/0x100
Oct 16 21:35:27 SANfile_m kernel:  [<c01326dc>] worker_thread+0x9c/0x100
Oct 16 21:35:27 SANfile_m kernel:  [autoremove_wake_function+16/80] 
autoremove_wake_function+0x0/0x50
Oct 16 21:35:27 SANfile_m kernel:  [<c01354e0>] 
autoremove_wake_function+0x0/0x50
Oct 16 21:35:27 SANfile_m kernel:  [worker_thread+16/256] 
worker_thread+0x0/0x100
Oct 16 21:35:27 SANfile_m kernel:  [<c0132640>] worker_thread+0x0/0x100
Oct 16 21:35:27 SANfile_m kernel:  [kthread+82/112] kthread+0x42/0x70
Oct 16 21:35:27 SANfile_m kernel:  [<c0135212>] kthread+0x42/0x70
Oct 16 21:35:27 SANfile_m kernel:  [kthread+16/112] kthread+0x0/0x70
Oct 16 21:35:27 SANfile_m kernel:  [<c01351d0>] kthread+0x0/0x70
Oct 16 21:35:27 SANfile_m kernel:  [print_trace_stack+3/16] 
kernel_thread_helper+0x7/0x14
Oct 16 21:35:27 SANfile_m kernel:  [<c0104763>] 
kernel_thread_helper+0x7/0x14
Oct 16 21:35:27 SANfile_m kernel:  =======================
Oct 16 21:35:27 SANfile_m kernel: error 1
Oct 16 21:35:27 SANfile_m kernel: scsi 1:0:1:0: Unexpected response from lun 
0 while scanning, scan aborted
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453056
Oct 16 21:35:27 SANfile_m kernel: Buffer I/O error on device sdg, logical 
block 907931632
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453056
Oct 16 21:35:27 SANfile_m kernel: Buffer I/O error on device sdg, logical 
block 907931632
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453056
Oct 16 21:35:27 SANfile_m kernel: Buffer I/O error on device sdg, logical 
block 907931632
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453176
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453176
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453176
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453176
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453176
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453176
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453120
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453168
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453176
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 
7263453176
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:27 SANfile_m kernel: sd 1:0:1:0: [sdg] Device not ready: <6>: 
Sense Key : 0x2 [current]
Oct 16 21:35:27 SANfile_m kernel: : ASC=0x4 ASCQ=0x3
Oct 16 21:35:27 SANfile_m kernel: end_request: I/O error, dev sdg, sector 0
Oct 16 21:35:28 SANfile_m kernel: scsi 2:0:1:0: rejecting I/O to dead device
Oct 16 21:35:28 SANfile_m kernel: scsi 1:0:1:0: rejecting I/O to dead device
Oct 16 21:35:28 SANfile_m multipathd: sde: emc_clariion_checker: query 
command indicates error
Oct 16 21:35:33 SANfile_m kernel: scsi 2:0:1:0: rejecting I/O to dead device
Oct 16 21:35:33 SANfile_m kernel: scsi 1:0:1:0: rejecting I/O to dead device
Oct 16 21:35:33 SANfile_m multipathd: sdc: emc_clariion_checker: query 
command indicates error
Oct 16 21:35:33 SANfile_m multipathd: sde: emc_clariion_checker: query 
command indicates error
Oct 16 21:35:33 SANfile_m multipathd: sdc: emc_clariion_checker: query 
command indicates error
Oct 16 21:35:38 SANfile_m kernel: scsi 2:0:1:0: rejecting I/O to dead device
Oct 16 21:35:38 SANfile_m multipathd: sde: emc_clariion_checker: query 
command indicates error
Oct 16 21:35:38 SANfile_m kernel: scsi 1:0:1:0: rejecting I/O to dead device
Oct 16 21:35:38 SANfile_m multipathd: sdc: emc_clariion_checker: query 
command indicates error
Oct 16 21:35:43 SANfile_m kernel: scsi 2:0:1:0: rejecting I/O to dead device
Oct 16 21:35:43 SANfile_m kernel: scsi 1:0:1:0: rejecting I/O to dead device
Oct 16 21:35:43 SANfile_m multipathd: sde: emc_clariion_checker: query 
command indicates error
Oct 16 21:35:43 SANfile_m multipathd: sdc: emc_clariion_checker: query 
command indicates error



multipath -l still shows:
hcfshare (360060160c820080063502869e459dc11) dm-0 ,
[size=3.4T][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=0][active]
 \_ #:#:#:# -   #:#   [failed][undef]
 \_ 2:0:0:0 sdd 8:48  [active][undef]
 \_ #:#:#:# -   #:#   [failed][undef]
 \_ 1:0:0:0 sdb 8:16  [active][undef]

of course, failback won't work then.

My config:

defaults {
       udev_dir                 /dev
       polling_interval         5
       selector                 "round-robin 0"
       path_grouping_policy     group_by_serial
       failback                 immediate
       getuid_callout           "/sbin/scsi_id -g -u -s /block/%n"
}

multipaths {
        multipath {
                wwid                    360060160c820080063502869e459dc11
                alias                   hcfshare
                path_grouping_policy    group_by_serial
                path_checker            emc_clariion
                path_selector           "round-robin 0"
                failback                immediate
        }
}

Does that tell somebody something?

Thanks,
(Gerald) 
