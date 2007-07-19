From: Brian De Wolf <bldewolf@csupomona.edu>
Subject: multipath-tools causes path to come back as different
	block device
Date: Thu, 19 Jul 2007 15:54:51 -0700
Message-ID: <469FEBBB.5040507@csupomona.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello again,

I've been testing multipath-tool's rdac capability with a qla2xxx HBA and an IBM
DS4800 some more and I've hit another stumbling block.  When I test unplugging
one of the HBA ports and plugging it back in with multipath running, it seems to
cause bad things to happen.  Here is what the syslog looks like (note:  sdb is a
path, sdd is initially unused, and sde is the second path):

Jul 19 14:30:35 jimbo kernel: qla2xxx 0000:02:01.1: LOOP DOWN detected (2).
Jul 19 14:30:41 jimbo kernel: rport-4:0-0: blocked FC remote port time out:
removing target and saving binding
Jul 19 14:30:41 jimbo kernel: sd 4:0:0:0: [sde] Synchronizing SCSI cache
Jul 19 14:30:41 jimbo kernel: sd 4:0:0:0: [sde] Result: hostbyte=0x01
driverbyte=0x00
Jul 19 14:30:48 jimbo multipathd: sde: rdac checker reports path is down
Jul 19 14:30:48 jimbo multipathd: checker failed path 8:64 in map test
Jul 19 14:30:48 jimbo kernel: scsi 4:0:0:0: rejecting I/O to dead device
Jul 19 14:30:48 jimbo kernel: device-mapper: multipath: Failing path 8:64.
Jul 19 14:30:48 jimbo multipathd: test: remaining active paths: 1
Jul 19 14:30:48 jimbo multipathd: test: switch to path group #2
Jul 19 14:30:52 jimbo kernel: qla2xxx 0000:02:01.1: LIP reset occured (f700).
Jul 19 14:30:52 jimbo kernel: qla2xxx 0000:02:01.1: LIP occured (f700).
Jul 19 14:30:52 jimbo kernel: qla2xxx 0000:02:01.1: LIP reset occured (f7f7).
Jul 19 14:30:53 jimbo kernel: scsi 4:0:0:0: rejecting I/O to dead device
Jul 19 14:30:53 jimbo multipathd: sde: rdac checker reports path is down
Jul 19 14:30:53 jimbo kernel: qla2xxx 0000:02:01.1: LOOP UP detected (4 Gbps).
Jul 19 14:30:53 jimbo kernel: scsi 4:0:0:0: Direct-Access     IBM      1815
 FAStT  0914 PQ: 0 ANSI: 3
Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] 6291456 512-byte hardware
sectors (3221 MB)
Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Write Protect is off
Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Mode Sense: 77 00 10 08
Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Write cache: enabled, read
cache: enabled, supports DPO and FUA
Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] 6291456 512-byte hardware
sectors (3221 MB)
Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Write Protect is off
Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Mode Sense: 77 00 10 08
Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Write cache: enabled, read
cache: enabled, supports DPO and FUA
Jul 19 14:30:53 jimbo kernel: sdd: sdd1
Jul 19 14:30:53 jimbo kernel: sd 4:0:0:0: [sdd] Attached SCSI disk
Jul 19 14:30:53 jimbo kernel: scsi 4:0:0:0: Direct-Access     IBM      1815
 FAStT  0914 PQ: 0 ANSI: 3
Jul 19 14:30:53 jimbo kernel: kobject_add failed for 4:0:0:0 with -EEXIST, don't
try to register things with the same name in the same directory.
Jul 19 14:30:53 jimbo kernel:
Jul 19 14:30:53 jimbo kernel: Call Trace:
Jul 19 14:30:53 jimbo kernel: [<ffffffff802e1d9b>] kobject_shadow_add+0x187/0x191
Jul 19 14:30:53 jimbo kernel: [<ffffffff8033a495>] device_add+0xa1/0x59d
Jul 19 14:30:53 jimbo kernel: [<ffffffff803638e8>] scsi_sysfs_add_sdev+0x2e/0x24a
Jul 19 14:30:53 jimbo kernel: [<ffffffff80361f18>]
scsi_probe_and_add_lun+0x6ff/0x80f
Jul 19 14:30:53 jimbo kernel: [<ffffffff803612c8>] scsi_alloc_sdev+0x195/0x1ea
Jul 19 14:30:53 jimbo kernel: [<ffffffff80362580>] __scsi_scan_target+0x3e9/0x549
Jul 19 14:30:53 jimbo kernel: [<ffffffff80416d83>] thread_return+0x0/0xe2
Jul 19 14:30:53 jimbo kernel: [<ffffffff80362777>] scsi_scan_target+0x97/0xbc
Jul 19 14:30:53 jimbo kernel: [<ffffffff88003668>]
:scsi_transport_fc:fc_scsi_scan_rport+0x59/0x79
Jul 19 14:30:53 jimbo kernel: [<ffffffff8800360f>]
:scsi_transport_fc:fc_scsi_scan_rport+0x0/0x79
Jul 19 14:30:53 jimbo kernel: [<ffffffff802379c4>] run_workqueue+0x84/0x105
Jul 19 14:30:53 jimbo kernel: [<ffffffff80237a45>] worker_thread+0x0/0xf4
Jul 19 14:30:53 jimbo kernel: [<ffffffff80237b2f>] worker_thread+0xea/0xf4
Jul 19 14:30:53 jimbo kernel: [<ffffffff8023addd>] autoremove_wake_function+0x0/0x2e
Jul 19 14:30:53 jimbo kernel: [<ffffffff8023addd>] autoremove_wake_function+0x0/0x2e
Jul 19 14:30:53 jimbo kernel: [<ffffffff8023a888>] kthread+0x3d/0x63
Jul 19 14:30:53 jimbo kernel: [<ffffffff8020a338>] child_rip+0xa/0x12
Jul 19 14:30:53 jimbo kernel: [<ffffffff8023a84b>] kthread+0x0/0x63
Jul 19 14:30:53 jimbo kernel: [<ffffffff8020a32e>] child_rip+0x0/0x12
Jul 19 14:30:53 jimbo kernel:
Jul 19 14:30:53 jimbo kernel: error 1
Jul 19 14:30:53 jimbo kernel: scsi 4:0:0:0: Unexpected response from lun 0 while
scanning, scan aborted
Jul 19 14:30:53 jimbo scsi.agent[8613]: disk at
/devices/pci0000:00/0000:00:02.0/0000:02:01.1/host4/rport-4:0-0/target4:0:0/4:0:0:0
Jul 19 14:30:53 jimbo multipathd: sdd: add path (uevent)
Jul 19 14:30:53 jimbo kernel: scsi 4:0:0:0: rejecting I/O to dead device
Jul 19 14:30:53 jimbo multipathd: sde: checker msg is "rdac checker reports path
is down"
Jul 19 14:30:53 jimbo kernel: device-mapper: multipath rdac: using RDAC command
with timeout 15000
Jul 19 14:30:53 jimbo kernel: device-mapper: table: 254:6: multipath: error
getting device
Jul 19 14:30:53 jimbo kernel: device-mapper: ioctl: error adding target to table
Jul 19 14:30:53 jimbo multipathd: test: failed in domap for addition of new path sdd
Jul 19 14:30:53 jimbo multipathd: test: uev_add_path sleep
...

From here, the last 5 lines get repeated until I 'kill -9' the multipathd
process.  I'm not too keen on kernel internals (though playing with multipathing
is bringing me up to speed pretty quick), but I'm wondering if multipathd is
causing the call trace by not letting /dev/sde disappear so that the HBA's scsi
device can grab that name again.  I noticed this via lsof:
multipath 8390     root    5r      BLK               8,64              22254
/dev/sde (deleted)
multipath 8390     root    6r      BLK               8,16               1100
/dev/sdb
multipath 8390     root   10r      BLK               8,48              23647
/dev/sdd

When multipathd is running, unplugging and plugging in one of the ports causes
it to grab the next sd* device name.  As this is repeated, the number of deleted
block devices multipathd holds on to grows, along with the number of unhappy
rdac checkers.  As I said before, it takes a 'kill -9' to stop multipathd, and
subsequent plugging ins choose sd* names that were previously used but were held
onto as (deleted) by multipathd.

However, this behavior is not seen when multipathd is not running.  When the
port is unplugged, the /dev/sd* device disappears, and when it is plugged back
in, it takes the same name it had before (I assume it's just taking the lowest
name, and its old name has been freed) cleanly, with no call traces or anything.

Any ideas on how to correct this behavior?

Thanks!
Brian De Wolf
