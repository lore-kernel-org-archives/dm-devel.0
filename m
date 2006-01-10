From: Jeff DiNisco <jdinisco@cptech.com>
Subject: multipathing buffer I/O error
Date: Tue, 10 Jan 2006 14:57:36 -0500
Message-ID: <1136923056.3161.41.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

I'm running multipath-tools on RHEL AS 4 update1.

I have 2 qlogic 2340 cards (qlogic multipathing disabled) attached to a
Sun StorEdge 3510 w/ dual controllers.  

Multipathing appears to be working well.  The devs are created
in /dev/mapper, kpartx creates the partitons, and multipath -l reports
multiple paths to a single device.  I created an ext3 fs on a
multipathed dev and mounted it.  To test, I ran a script to generate
constant i/o to the fs then pulled the fiber cable from one of the
qlogic cards.  At this point, things still look good.  My log reports...

Jan 10 14:15:01 v20z-d kernel: SCSI error : <4 0 0 4> return code =
0x10000
Jan 10 14:15:01 v20z-d kernel: end_request: I/O error, dev sdo, sector
5207
Jan 10 14:15:01 v20z-d kernel: device-mapper: dm-multipath: Failing path
8:224.

multipath -l shows a failed and active path for the device and the
script is still successfully generating i/o.  The problem occurs when I
plug the fiber cable back in.  My log reports...

Jan 10 14:15:53 v20z-d kernel: qla2300 0000:02:05.0: LIP reset occured
(f7f7).
Jan 10 14:15:53 v20z-d kernel: qla2300 0000:02:05.0: LIP occured (f7f7).
Jan 10 14:15:53 v20z-d kernel: qla2300 0000:03:01.0: LIP reset occured
(f7f7).
Jan 10 14:15:54 v20z-d kernel: qla2300 0000:02:05.0: LIP reset occured
(f8f7).
Jan 10 14:15:54 v20z-d kernel: qla2300 0000:03:01.0: LIP occured (f7f7).
Jan 10 14:15:54 v20z-d kernel: qla2300 0000:02:05.0: LIP occured (f8f7).
Jan 10 14:15:54 v20z-d kernel: qla2300 0000:03:01.0: LOOP UP detected (2
Gbps).
Jan 10 14:15:54 v20z-d kernel: SCSI error : <3 0 0 4> return code =
0x20000
Jan 10 14:15:54 v20z-d kernel: end_request: I/O error, dev sdf, sector
2952647
Jan 10 14:15:54 v20z-d kernel: device-mapper: dm-multipath: Failing path
8:80.
Jan 10 14:15:54 v20z-d kernel: end_request: I/O error, dev sdf, sector
2952655
Jan 10 14:15:54 v20z-d kernel: printk: 10821 messages suppressed.
Jan 10 14:15:54 v20z-d kernel: Buffer I/O error on device dm-9, logical
block 369074
Jan 10 14:15:54 v20z-d kernel: lost page write due to I/O error on dm-9
Jan 10 14:15:54 v20z-d kernel: Buffer I/O error on device dm-9, logical
block 369075
Jan 10 14:15:54 v20z-d kernel: lost page write due to I/O error on dm-9


there are many more of these errors and it ends w/...

Jan 10 14:15:55 v20z-d kernel: SCSI error : <3 0 0 4> return code =
0x20000
Jan 10 14:15:55 v20z-d kernel: end_request: I/O error, dev sdf, sector
1570127
Jan 10 14:15:55 v20z-d kernel: Aborting journal on device dm-9.
Jan 10 14:15:55 v20z-d kernel: ext3_abort called.
Jan 10 14:15:55 v20z-d kernel: EXT3-fs error (device dm-9):
ext3_journal_start_sb: Detected aborted journal
Jan 10 14:15:55 v20z-d kernel: Remounting filesystem read-only

I've tried a few different options in multipath.conf to no avail.
Here's what it looked like when these errors were generated...

defaults {
        multipath_tool  "/sbin/multipath -v0"
        udev_dir        /dev
        polling_interval 120
        default_selector        "round-robin 0"
        default_path_grouping_policy    multibus
#
# From StorEdge 3510 section
        default_path_checker    tur
#
        default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout    "/bin/true"
        default_features        "0"
        rr_wmin_io              100
        failback                immediate
}


software versions...

device-mapper-1.01.01-1.RHEL4
device-mapper-multipath-0.4.5-6.0.RHEL4
udev-039-10.8.EL4
kernel version - 2.6.9-11.EL

Any help would be greatly appreciated.
