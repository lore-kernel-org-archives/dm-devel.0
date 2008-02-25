From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: dm-multipath loosing data
Date: Mon, 25 Feb 2008 12:06:29 +0100
Message-ID: <20080225110629.GA2449@rere.qmqm.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi,

There's a problem with dm-multipath (log attached). With 'queue_if_no_path'
feature enabled it's supposed to queue I/Os to the device indefinitely,
but it isn't. I'll try to reproduce this during next week if some more data
is needed.

Best Regards,
Michal Miroslaw

sanmgt: ~ # multipath -ll
mpath2 (350002ac0035902df) dm-0 ,
[size=17G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:# -   #:#   [failed][faulty]
sanmgt: ~ # dmsetup table
mpath2: 0 35651584 multipath 1 queue_if_no_path 0 1 1 round-robin 0 1 1 8:144 10 
sanmgt: ~ # ls -l /dev/sd{i,j}
ls: /dev/sdi: No such file or directory
ls: /dev/sdj: No such file or directory

Feb 22 15:52:08 sanmgt kernel:  rport-1:0-0: blocked FC remote port time out: removing target and saving binding
Feb 22 15:52:08 sanmgt kernel: device-mapper: multipath: Failing path 8:32.
Feb 22 15:52:08 sanmgt kernel: sd 1:0:0:1: [sdc] Synchronizing SCSI cache
Feb 22 15:52:08 sanmgt kernel: sd 1:0:0:1: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Feb 22 15:52:10 sanmgt kernel:  rport-2:0-0: blocked FC remote port time out: removing target and saving binding
Feb 22 15:52:10 sanmgt kernel: device-mapper: multipath: Failing path 8:80.
Feb 22 15:52:10 sanmgt kernel: sd 2:0:0:1: [sdf] Synchronizing SCSI cache
Feb 22 15:52:10 sanmgt kernel: sd 2:0:0:1: [sdf] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Feb 22 15:52:11 sanmgt kernel: device-mapper: table: 254:0: multipath: error getting device
Feb 22 15:52:11 sanmgt kernel: device-mapper: ioctl: error adding target to table
Feb 22 15:52:17 sanmgt kernel: scsi 2:0:0:1: rejecting I/O to dead device
Feb 22 15:52:45 sanmgt last message repeated 4 times
Feb 22 15:52:50 sanmgt kernel: scsi 2:0:0:0: scsi scan: INQUIRY pass 1 length 36
Feb 22 15:52:50 sanmgt kernel: scsi scan: INQUIRY successful with code 0x0
Feb 22 15:52:50 sanmgt kernel: scsi scan: peripheral device type of 31, no device added
Feb 22 15:52:50 sanmgt kernel: scsi scan: Sending REPORT LUNS to host 2 channel 0 id 0 (try 0)
Feb 22 15:52:50 sanmgt kernel: scsi scan: REPORT LUNS successful (try 0) result 0x0
Feb 22 15:52:50 sanmgt kernel: scsi 2:0:0:0: scsi scan: REPORT LUN scan
Feb 22 15:52:50 sanmgt kernel: scsi 2:0:0:1: scsi scan: INQUIRY pass 1 length 36
Feb 22 15:52:50 sanmgt kernel: scsi scan: INQUIRY successful with code 0x0
Feb 22 15:52:50 sanmgt kernel: scsi 2:0:0:1: scsi scan: INQUIRY pass 2 length 144
Feb 22 15:52:50 sanmgt kernel: scsi scan: INQUIRY successful with code 0x0
Feb 22 15:52:50 sanmgt kernel: scsi 2:0:0:1: Direct-Access     3PARdata VV               0000 PQ: 0 ANSI: 5
Feb 22 15:52:50 sanmgt kernel: sd 2:0:0:1: [sdi] 35651584 512-byte hardware sectors (18254 MB)
Feb 22 15:52:50 sanmgt kernel: sd 2:0:0:1: [sdi] Write Protect is off
Feb 22 15:52:50 sanmgt kernel: sd 2:0:0:1: [sdi] Mode Sense: 7f 00 10 08
Feb 22 15:52:50 sanmgt kernel: sd 2:0:0:1: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 22 15:52:50 sanmgt kernel: sd 2:0:0:1: [sdi] 35651584 512-byte hardware sectors (18254 MB)
Feb 22 15:52:50 sanmgt kernel: sd 2:0:0:1: [sdi] Write Protect is off
Feb 22 15:52:50 sanmgt kernel: sd 2:0:0:1: [sdi] Mode Sense: 7f 00 10 08
Feb 22 15:52:50 sanmgt kernel: sd 2:0:0:1: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 22 15:52:50 sanmgt kernel:  sdi: unknown partition table
Feb 22 15:52:50 sanmgt kernel: sd 2:0:0:1: [sdi] Attached SCSI disk
Feb 22 15:52:50 sanmgt kernel: sd 2:0:0:1: Attached scsi generic sg3 type 0
Feb 22 15:52:51 sanmgt kernel: scsi 2:0:0:1: rejecting I/O to dead device
Feb 22 15:52:54 sanmgt kernel: scsi 1:0:0:0: scsi scan: INQUIRY pass 1 length 36
Feb 22 15:52:54 sanmgt kernel: scsi scan: INQUIRY successful with code 0x0
Feb 22 15:52:54 sanmgt kernel: scsi scan: peripheral device type of 31, no device added
Feb 22 15:52:54 sanmgt kernel: scsi scan: Sending REPORT LUNS to host 1 channel 0 id 0 (try 0)
Feb 22 15:52:54 sanmgt kernel: scsi scan: REPORT LUNS successful (try 0) result 0x0
Feb 22 15:52:54 sanmgt kernel: scsi 1:0:0:0: scsi scan: REPORT LUN scan
Feb 22 15:52:54 sanmgt kernel: scsi 1:0:0:1: scsi scan: INQUIRY pass 1 length 36
Feb 22 15:52:54 sanmgt kernel: scsi scan: INQUIRY successful with code 0x0
Feb 22 15:52:54 sanmgt kernel: scsi 1:0:0:1: scsi scan: INQUIRY pass 2 length 144
Feb 22 15:52:54 sanmgt kernel: scsi scan: INQUIRY successful with code 0x0
Feb 22 15:52:54 sanmgt kernel: scsi 1:0:0:1: Direct-Access     3PARdata VV               0000 PQ: 0 ANSI: 5
Feb 22 15:52:54 sanmgt kernel: sd 1:0:0:1: [sdj] 35651584 512-byte hardware sectors (18254 MB)
Feb 22 15:52:54 sanmgt kernel: sd 1:0:0:1: [sdj] Write Protect is off
Feb 22 15:52:54 sanmgt kernel: sd 1:0:0:1: [sdj] Mode Sense: 7f 00 10 08
Feb 22 15:52:54 sanmgt kernel: sd 1:0:0:1: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 22 15:52:54 sanmgt kernel: sd 1:0:0:1: [sdj] 35651584 512-byte hardware sectors (18254 MB)
Feb 22 15:52:54 sanmgt kernel: sd 1:0:0:1: [sdj] Write Protect is off
Feb 22 15:52:54 sanmgt kernel: sd 1:0:0:1: [sdj] Mode Sense: 7f 00 10 08
Feb 22 15:52:54 sanmgt kernel: sd 1:0:0:1: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 22 15:52:54 sanmgt kernel:  sdj: unknown partition table
Feb 22 15:52:54 sanmgt kernel: sd 1:0:0:1: [sdj] Attached SCSI disk
Feb 22 15:52:54 sanmgt kernel: sd 1:0:0:1: Attached scsi generic sg6 type 0
Feb 22 15:52:55 sanmgt kernel: journal_bmap: journal block not found at offset 12 on dm-0
Feb 22 15:52:55 sanmgt kernel: Aborting journal on device dm-0.
Feb 22 15:52:55 sanmgt kernel: Buffer I/O error on device dm-0, logical block 1481
Feb 22 15:52:55 sanmgt kernel: lost page write due to I/O error on dm-0
Feb 22 15:52:55 sanmgt kernel: journal commit I/O error
Feb 22 15:52:55 sanmgt kernel: Buffer I/O error on device dm-0, logical block 963
Feb 22 15:52:55 sanmgt kernel: lost page write due to I/O error on dm-0
Feb 22 15:52:55 sanmgt kernel: WARNING: at fs/buffer.c:1169 mark_buffer_dirty()
Feb 22 15:52:55 sanmgt kernel: Pid: 3153, comm: multipathd Not tainted 2.6.24.2 #6
Feb 22 15:52:55 sanmgt kernel:  [<c0180d27>] mark_buffer_dirty+0x49/0xa4
Feb 22 15:52:55 sanmgt kernel:  [<f89baf33>] journal_update_superblock+0x5d/0xa5 [jbd]
Feb 22 15:52:55 sanmgt kernel:  [<f89bb464>] journal_flush+0xd3/0x13a [jbd]
Feb 22 15:52:55 sanmgt kernel:  [<f8b9fbaf>] ext3_write_super_lockfs+0x28/0x4f [ext3]
Feb 22 15:52:55 sanmgt kernel:  [<c017fe2d>] freeze_bdev+0x66/0x72
Feb 22 15:52:55 sanmgt kernel:  [<c02d6e39>] lock_fs+0x43/0x6c
Feb 22 15:52:55 sanmgt kernel:  [<c0184d28>] bdev_set+0x0/0xb
Feb 22 15:52:55 sanmgt kernel:  [<c02d6f68>] dm_suspend+0xd3/0x26a
Feb 22 15:52:55 sanmgt kernel:  [<c011786e>] default_wake_function+0x0/0xc
Feb 22 15:52:55 sanmgt kernel:  [<c013ad8c>] __lock_acquired+0x25/0x138
Feb 22 15:52:55 sanmgt kernel:  [<c02d9b64>] do_resume+0x67/0x119
Feb 22 15:52:55 sanmgt kernel:  [<c011786e>] default_wake_function+0x0/0xc
Feb 22 15:52:55 sanmgt kernel:  [<c02d9b94>] do_resume+0x97/0x119
Feb 22 15:52:55 sanmgt kernel:  [<c02da55f>] ctl_ioctl+0xd8/0x10b
Feb 22 15:52:55 sanmgt kernel:  [<c02d9c16>] dev_suspend+0x0/0x10
Feb 22 15:52:55 sanmgt kernel:  [<c016e389>] do_ioctl+0x55/0x65
Feb 22 15:52:55 sanmgt kernel:  [<c016e5e5>] vfs_ioctl+0x179/0x185
Feb 22 15:52:55 sanmgt kernel:  [<c0393dba>] error_code+0x72/0x78
Feb 22 15:52:55 sanmgt kernel:  [<c013a8de>] __lock_release+0x1a/0x4e
Feb 22 15:52:55 sanmgt kernel:  [<c016e638>] sys_ioctl+0x47/0x63
Feb 22 15:52:55 sanmgt kernel:  [<c01026a6>] syscall_call+0x7/0xb
Feb 22 15:52:55 sanmgt kernel:  =======================
Feb 22 15:52:55 sanmgt kernel: Buffer I/O error on device dm-0, logical block 1481
Feb 22 15:52:55 sanmgt kernel: lost page write due to I/O error on dm-0
Feb 22 15:52:55 sanmgt kernel: Buffer I/O error on device dm-0, logical block 0
Feb 22 15:52:55 sanmgt kernel: lost page write due to I/O error on dm-0
Feb 22 16:12:00 sanmgt kernel:  rport-2:0-0: blocked FC remote port time out: removing target and saving binding
Feb 22 16:12:00 sanmgt kernel: device-mapper: multipath: Failing path 8:128.
Feb 22 16:12:00 sanmgt kernel: sd 2:0:0:1: [sdi] Synchronizing SCSI cache
Feb 22 16:12:00 sanmgt kernel: sd 2:0:0:1: [sdi] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Feb 22 16:12:02 sanmgt kernel:  rport-1:0-0: blocked FC remote port time out: removing target and saving binding
Feb 22 16:12:02 sanmgt kernel: device-mapper: multipath: Failing path 8:144.
Feb 22 16:12:02 sanmgt kernel: sd 1:0:0:1: [sdj] Synchronizing SCSI cache
Feb 22 16:12:02 sanmgt kernel: Buffer I/O error on device dm-0, logical block 0
Feb 22 16:12:02 sanmgt kernel: lost page write due to I/O error on dm-0
Feb 22 16:12:02 sanmgt kernel: device-mapper: multipath: Failing path 8:144.
Feb 22 16:12:02 sanmgt kernel: sd 1:0:0:1: [sdj] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Feb 22 16:13:32 sanmgt kernel: scsi 1:0:0:0: scsi scan: INQUIRY pass 1 length 36
Feb 22 16:13:35 sanmgt kernel: scsi 2:0:0:0: scsi scan: INQUIRY pass 1 length 36
Feb 22 16:14:07 sanmgt kernel:  rport-1:0-0: blocked FC remote port time out: removing target and saving binding
Feb 22 16:14:07 sanmgt kernel: scsi scan: INQUIRY failed with code 0x10000
Feb 22 16:14:10 sanmgt kernel:  rport-2:0-0: blocked FC remote port time out: removing target and saving binding
Feb 22 16:14:10 sanmgt kernel: scsi scan: INQUIRY failed with code 0x10000
