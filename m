From: <Thomas.vonSteiger@swisscom.com>
Subject: Problem with dm-multipath,
	Remounting filesystem read-only after "Detected aborted journal"
Date: Tue, 9 May 2006 17:10:30 +0200
Message-ID: <A5220515092FCE4CAA66663B2FEF094C071B0CA5@sxmbx03.corproot.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

Hello,

I found
https://www.redhat.com/archives/dm-devel/2006-April/msg00046.html
And it looks like a similar problem.

I have running full multipath blade rhel4/u3 on san storage only.
failover and multibus multipath config with running oracle io on top
running without problem if we are disable one san path. Kernel detectes
LOOP UP immediate an revory of disabled path running fast.

Suddenly we have "IO Errors" and kernel remounts filesystem read-only on
all RHEL4 Blades inside this bladecenter.
It was not a multipath test!
I found on a RHEL3 Blade in the same bladecenter (with kernel modul
multipath) in /var/log/messages

May  9 14:49:03 rhel3 kernel: scsi(0): RSCN database changed -0x2ce,0x0.
May  9 14:49:03 rhel3 kernel: scsi(0): Waiting for LIP to complete...
May  9 14:49:03 rhel3 kernel: scsi(0): Topology - (F_Port), Host Loop
address 0xffff

at this time where several RHEL4 filesystem are going readonly.

## RHEL4/U3
[root@rhel4 ~]# multipath -l
sys001 (360060e8004eb2d000000eb2d00001600)
[size=3D9 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 0:0:0:0 sda 8:0  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdc 8:32 [active][ready]
=20
lun001 (360060e8004eb2d000000eb2d00000500)
[size=3D14 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 0:0:0:1 sdb 8:16 [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdd 8:48 [active][ready]


## /var/log/messages
May  9 14:49:03 rhel4 kernel: SCSI error : <0 0 0 1> return code =3D
0x20000
May  9 14:49:03 rhel4 kernel: end_request: I/O error, dev sdb, sector
19893656
May  9 14:49:03 rhel4 kernel: device-mapper: dm-multipath: Failing path
8:16.
May  9 14:49:03 rhel4 multipathd: 8:16: mark as failed
May  9 14:49:03 rhel4 multipathd: lun001: remaining active paths: 1
May  9 14:49:03 rhel4 kernel: SCSI error : <0 0 0 0> return code =3D
0x20000
May  9 14:49:03 rhel4 kernel: end_request: I/O error, dev sda, sector
13374414
May  9 14:49:03 rhel4 kernel: device-mapper: dm-multipath: Failing path
8:0.
May  9 14:49:03 rhel4 multipathd: 8:0: mark as failed
May  9 14:49:03 rhel4 multipathd: sys001: remaining active paths: 1
May  9 14:49:09 rhel4 kernel: SCSI error : <1 0 0 1> return code =3D
0x20000
May  9 14:49:09 rhel4 kernel: end_request: I/O error, dev sdd, sector
15485360
May  9 14:49:09 rhel4 kernel: device-mapper: dm-multipath: Failing path
8:48.
May  9 14:49:09 rhel4 kernel: end_request: I/O error, dev sdd, sector
15485368
May  9 14:49:09 rhel4 kernel: Buffer I/O error on device dm-20, logical
block 137223
May  9 14:49:09 rhel4 kernel: lost page write due to I/O error on dm-20
May  9 14:49:09 rhel4 multipathd: 8:48: mark as failed
May  9 14:49:09 rhel4 multipathd: lun001: remaining active paths: 0
May  9 14:49:09 rhel4 kernel: Buffer I/O error on device dm-20, logical
block 137222
May  9 14:49:09 rhel4 kernel: lost page write due to I/O error on dm-20
May  9 14:49:09 rhel4 kernel: Buffer I/O error on device dm-21, logical
block 366598
May  9 14:49:09 rhel4 kernel: lost page write due to I/O error on dm-21
May  9 14:49:09 rhel4 kernel: Buffer I/O error on device dm-21, logical
block 366599
May  9 14:49:09 rhel4 kernel: lost page write due to I/O error on dm-21
May  9 14:49:09 rhel4 kernel: EXT3-fs error (device dm-18):
ext3_get_inode_loc: unable to read inode block - inode=3D642553,
block=3D1278104
May  9 14:49:09 rhel4 kernel: Aborting journal on device dm-18.
May  9 14:49:09 rhel4 kernel: Buffer I/O error on device dm-18, logical
block 895
May  9 14:49:09 rhel4 kernel: lost page write due to I/O error on dm-18
May  9 14:49:09 rhel4 kernel: Buffer I/O error on device dm-18, logical
block 0
May  9 14:49:09 rhel4 kernel: lost page write due to I/O error on dm-18
May  9 14:49:09 rhel4 kernel: EXT3-fs error (device dm-18) in
ext3_reserve_inode_write: IO failure
May  9 14:49:09 rhel4 kernel: Buffer I/O error on device dm-18, logical
block 0
May  9 14:49:09 rhel4 kernel: lost page write due to I/O error on dm-18
May  9 14:49:09 rhel4 kernel: EXT3-fs error (device dm-18) in
ext3_dirty_inode: IO failure
May  9 14:49:09 rhel4 kernel: Buffer I/O error on device dm-18, logical
block 0
May  9 14:49:09 rhel4 kernel: lost page write due to I/O error on dm-18
May  9 14:49:09 rhel4 kernel: EXT3-fs error (device dm-19):
ext3_find_entry: reading directory #65537 offset 0
May  9 14:49:09 rhel4 kernel:
May  9 14:49:09 rhel4 kernel: Aborting journal on device dm-19.
May  9 14:49:09 rhel4 kernel: Buffer I/O error on device dm-19, logical
block 585
May  9 14:49:09 rhel4 kernel: lost page write due to I/O error on dm-19
May  9 14:49:09 rhel4 kernel: Buffer I/O error on device dm-19, logical
block 0
May  9 14:49:09 rhel4 kernel: lost page write due to I/O error on dm-19
May  9 14:49:09 rhel4 kernel: ext3_abort called.
May  9 14:49:09 rhel4 kernel: EXT3-fs error (device dm-19):
ext3_journal_start_sb: Detected aborted journal
May  9 14:49:09 rhel4 kernel: Remounting filesystem read-only

--> Oracle on dm-19 is crashing after remount. After Server reboot
oracle is running fin again.

## Other Blade in the same Bladecenter with RHEL3 with kernelmodul
multipath:

May  9 14:49:03 rhel3 kernel: scsi(0): RSCN database changed -0x2ce,0x0.
May  9 14:49:03 rhel3 kernel: scsi(0): Waiting for LIP to complete...
May  9 14:49:03 rhel3 kernel: scsi(0): Topology - (F_Port), Host Loop
address 0xffff
May  9 14:49:05 rhel3 kernel: scsi(0): RSCN database changed -0x2ce,0x0.
May  9 14:49:05 rhel3 kernel: scsi(0): Waiting for LIP to complete...
May  9 14:49:05 rhel3 kernel: scsi(0): Topology - (F_Port), Host Loop
address 0xffff
May  9 14:49:08 rhel3 kernel: scsi(0): RSCN database changed -0x2ce,0x0.
May  9 14:49:08 rhel3 kernel: scsi(0): Waiting for LIP to complete...
May  9 14:49:08 rhel3 kernel: scsi(0): Topology - (F_Port), Host Loop
address 0xffff
May  9 14:49:08 rhel3 kernel: scsi(1): RSCN database changed -0x2d8,0x0.
May  9 14:49:08 rhel3 kernel: scsi(1): Waiting for LIP to complete...
May  9 14:49:08 rhel3 kernel: scsi(1): Topology - (F_Port), Host Loop
address 0xffff
May  9 14:49:11 rhel3 kernel: scsi(1): RSCN database changed -0x2d8,0x0.
May  9 14:49:11 rhel3 kernel: scsi(1): Waiting for LIP to complete...
May  9 14:49:11 rhel3 kernel: scsi(1): Topology - (F_Port), Host Loop
address 0xffff
May  9 14:49:14 rhel3 kernel: scsi(1): RSCN database changed -0x2d8,0x0.
May  9 14:49:14 rhel3 kernel: scsi(1): Waiting for LIP to complete...
May  9 14:49:14 rhel3 kernel: scsi(1): Topology - (F_Port), Host Loop
address 0xffff


What can we to now ?
Are there a kernelparamter with timeout configuration ?

regards
Thomas
