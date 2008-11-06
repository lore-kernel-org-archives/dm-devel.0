From: "Sebastian Reitenbach" <sebastia@l00-bugdead-prods.de>
Subject: problem with multipathd,
	not all paths added to a disk on boot
Date: Thu, 06 Nov 2008 14:30:59 -0000
Message-ID: <20081106143100.0FBC013375@smtp.l00-bugdead-prods.de>
Reply-To: Sebastian Reitenbach <sebastia@l00-bugdead-prods.de>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

Hi,

I have an IBM DS4700 connected to an SLES10SP2 server, there are two paths 
through the SAN to each of the four presented LUN's.

after boot, on some of the groups, some of the disks are not added to the 
group. As far as I saw now, it 
this only happens for one of the groups at a time, e.g.:

multipath -l
test2 (3600a0b800048b3100000054c4910492e) dm-15 IBM,1814      FAStT
[size=100G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=-1][active]
 \_ 1:0:1:3 sdi 8:128 [active][undef]
\_ round-robin 0 [prio=-1][enabled]
 \_ 1:0:0:3 sde 8:64  [active][undef]
test1 (3600a0b800048b31000000462490efaac) dm-2 IBM,1814      FAStT
[size=100G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=-1][active]
 \_ 1:0:1:1 sdg 8:96  [active][undef]
\_ round-robin 0 [prio=-1][enabled]
 \_ 1:0:0:1 sdc 8:32  [active][undef]
vm-store (3600a0b800048b3fe00000431490e90ce) dm-1 IBM,1814      FAStT
[size=200G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=-1][active]
 \_ 1:0:1:0 sdf 8:80  [active][undef]
test3 (3600a0b800048b3fe0000056a49104475) dm-0 IBM,1814      FAStT
[size=100G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=-1][active]
 \_ 1:0:0:2 sdd 8:48  [active][undef]
\_ round-robin 0 [prio=-1][enabled]
 \_ 1:0:1:2 sdh 8:112 [active][undef]

/dev/sdb in group vm-store, on 1:0:0:0 is not listed, however, lsscsi
has the disk in the list:
[1:0:0:0]    disk    IBM      1814      FAStT  0916  /dev/sdb

for the disk that is not added to the group, I see sth like this 
in /var/log/messages:
Nov  6 12:32:36 srv24 kernel: end_request: I/O error, dev sdb, sector 0
Nov  6 12:32:39 srv24 kernel: end_request: I/O error, dev sdb, sector 0
Nov  6 12:32:39 srv24 kernel: end_request: I/O error, dev sdb, sector 8
Nov  6 12:32:42 srv24 kernel: end_request: I/O error, dev sdb, sector 0
Nov  6 12:32:42 srv24 multipathd: sdb: add path (uevent)
Nov  6 12:32:42 srv24 multipathd: sdb: spurious uevent, path already in 
pathvec
Nov  6 12:32:42 srv24 multipathd: sdb: failed to get path uid
Nov  6 12:32:45 srv24 kernel: end_request: I/O error, dev sdb, sector 0

I have found this thread here:
http://osdir.com/ml/kernel.device-mapper.devel/2006-08/msg00001.html

and when I do what they suggest:
echo "scsi remove-single-device 1 0 0 0" > /proc/scsi/scsi
echo "scsi add-single-device 1 0 0 0" > /proc/scsi/scsi
then after a while, the disk is added to the group:

multipath -l
test2 (3600a0b800048b3100000054c4910492e) dm-15 IBM,1814      FAStT
[size=100G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=-1][enabled]
 \_ 1:0:1:3 sdi 8:128 [active][undef]
\_ round-robin 0 [prio=-1][enabled]
 \_ 1:0:0:3 sde 8:64  [active][undef]
test1 (3600a0b800048b31000000462490efaac) dm-2 IBM,1814      FAStT
[size=100G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=-1][active]
 \_ 1:0:0:1 sdc 8:32  [active][undef]
\_ round-robin 0 [prio=-1][enabled]
 \_ 1:0:1:1 sdg 8:96  [active][undef]
vm-store (3600a0b800048b3fe00000431490e90ce) dm-1 IBM,1814      FAStT
[size=200G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=-1][active]
 \_ 1:0:1:0 sdf 8:80  [active][undef]
\_ round-robin 0 [prio=-1][enabled]
 \_ 1:0:0:0 sdb 8:16  [active][undef]
test3 (3600a0b800048b3fe0000056a49104475) dm-0 IBM,1814      FAStT
[size=100G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=-1][active]
 \_ 1:0:0:2 sdd 8:48  [active][undef]
\_ round-robin 0 [prio=-1][enabled]
 \_ 1:0:1:2 sdh 8:112 [active][undef]

Further, for the disk, /dev/sdb there are no partition devices, 
only for the disk /dev/sdf there are the partition devices.

When I change the preferred path for the LUN in the IBM Storage Manager,
then this is the other way around, partitions for disk b, but not
for disk f.
However, under /dev/mapper/vm-store-partX all partitions are there.


cat /etc/multipath.conf | grep -v "^#"
defaults {
        udev_dir        /dev
        path_grouping_policy    multibus
        getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        prio    "alua"
        user_friendly_names yes

        default_features        "0"
}
blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*|sda"
}
multipaths {
        multipath {
                wwid                    3600a0b800048b3fe0000056a49104475
                alias                   test3
        }
        multipath {
                wwid 3600a0b800048b31000000462490efaac
                alias test1
        }
        multipath {
                wwid 3600a0b800048b3100000054c4910492e
                alias test2
        }
        multipath {
                wwid 3600a0b800048b3fe00000431490e90ce
                alias vm-store
        }
}


cat /etc/modprobe.conf.local
options qla2xxx qlport_down_retry=1 ql2xlogintimeout=2

multipath-tools-0.4.7-34.38
Linux srv24 2.6.16.60-0.30-xen #1 SMP Thu Aug 28 09:26:55 UTC 2008 x86_64 
x86_64 x86_64 GNU/Linux

any idea what to do to have all disks assigned to groups after boot up 
automatically?

kind regards
Sebastian
