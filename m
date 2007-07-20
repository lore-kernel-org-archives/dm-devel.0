From: Brian De Wolf <bldewolf@csupomona.edu>
Subject: Re: multipath-tools causes path to come back as different
	block device
Date: Fri, 20 Jul 2007 10:05:47 -0700
Message-ID: <46A0EB6B.1030004@csupomona.edu>
References: <469FEBBB.5040507@csupomona.edu> <46A0631F.4030404@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46A0631F.4030404@suse.de>
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

Hannes Reinecke wrote:
> Hmm. multipathd really should react to the 'remove' events for sdX.
> Checking ...
> 
> Looks as if it does. And it even is supposed to stop the path checker.
> 
> Care to run multipathd with full debugging (ie -v 4) and post the output?
> My guess is that somehow the path checker is not stopped and the fd is kept
> open, so that the device is not released properly.
> 
> Cheers,
> 
> Hannes

Here's the log, as requested:

Jul 20 09:12:59 jimbo kernel: qla2xxx 0000:02:01.1: LOOP DOWN detected (2).
Jul 20 09:12:59 jimbo multipathd: tick
Jul 20 09:13:00 jimbo multipathd: tick
Jul 20 09:13:01 jimbo multipathd: tick
Jul 20 09:13:05 jimbo kernel: rport-4:0-0: blocked FC remote port time out:
removing target and saving binding
Jul 20 09:13:05 jimbo multipathd: sdd: rdac checker reports path is down
Jul 20 09:13:05 jimbo multipathd: checker failed path 8:48 in map test
Jul 20 09:13:05 jimbo multipathd: test: remaining active paths: 1
Jul 20 09:13:05 jimbo kernel: device-mapper: multipath: Failing path 8:48.
Jul 20 09:13:05 jimbo kernel: sd 4:0:0:0: [sdd] Synchronizing SCSI cache
Jul 20 09:13:05 jimbo kernel: sd 4:0:0:0: [sdd] Result: hostbyte=0x01
driverbyte=0x00
Jul 20 09:13:05 jimbo multipathd: test: devmap event #5
Jul 20 09:13:05 jimbo multipathd: 8:16: delay next check 20s
Jul 20 09:13:05 jimbo multipathd: path prio refresh
Jul 20 09:13:05 jimbo multipathd: sdb: mask = 0x8
Jul 20 09:13:05 jimbo multipathd: sdb: prio = 1
Jul 20 09:13:05 jimbo multipathd: test: switch to path group #2
Jul 20 09:13:05 jimbo multipathd: test: discover
Jul 20 09:13:05 jimbo multipathd: *word = 0, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = rdac, len = 4
Jul 20 09:13:05 jimbo multipathd: *word = 2, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 2, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 8:48, len = 4
Jul 20 09:13:05 jimbo multipathd: *word = 1000, len = 4
Jul 20 09:13:05 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 8:16, len = 4
Jul 20 09:13:05 jimbo multipathd: *word = 1000, len = 4
Jul 20 09:13:05 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 0, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 2, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = E, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 0, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = F, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = E, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 0, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = A, len = 1
Jul 20 09:13:05 jimbo multipathd: *word = 0, len = 1
Jul 20 09:13:05 jimbo multipathd: test: rr_weight = 1 (internal default)
Jul 20 09:13:05 jimbo multipathd: test: pgfailback = -2 (LUN setting)
Jul 20 09:13:05 jimbo multipathd: test: no_path_retry = NONE (internal default)
Jul 20 09:13:05 jimbo multipathd: pg_timeout = NONE (internal default)
Jul 20 09:13:05 jimbo multipathd: uevent 'remove' from '/class/scsi_device/4:0:0:0'
Jul 20 09:13:05 jimbo multipathd: UDEV_LOG=3
Jul 20 09:13:05 jimbo multipathd: ACTION=remove
Jul 20 09:13:05 jimbo multipathd: DEVPATH=/class/scsi_device/4:0:0:0
Jul 20 09:13:05 jimbo multipathd: SUBSYSTEM=scsi_device
Jul 20 09:13:05 jimbo multipathd: SEQNUM=944
Jul 20 09:13:05 jimbo multipathd:
PHYSDEVPATH=/devices/pci0000:00/0000:00:02.0/0000:02:01.1/host4/rport-4:0-0/target4:0:0/4:0:0:0
Jul 20 09:13:05 jimbo multipathd: PHYSDEVBUS=scsi
Jul 20 09:13:05 jimbo multipathd: PHYSDEVDRIVER=sd
Jul 20 09:13:05 jimbo multipathd: UDEVD_EVENT=1
Jul 20 09:13:05 jimbo multipathd: IN_HOTPLUG=1
Jul 20 09:13:05 jimbo multipathd: discard event on /class/scsi_device/4:0:0:0
Jul 20 09:13:05 jimbo multipathd: uevent 'remove' from '/class/scsi_disk/4:0:0:0'
Jul 20 09:13:05 jimbo multipathd: UDEV_LOG=3
Jul 20 09:13:05 jimbo multipathd: ACTION=remove
Jul 20 09:13:05 jimbo multipathd: DEVPATH=/class/scsi_disk/4:0:0:0
Jul 20 09:13:05 jimbo multipathd: SUBSYSTEM=scsi_disk
Jul 20 09:13:05 jimbo multipathd: SEQNUM=945
Jul 20 09:13:05 jimbo multipathd:
PHYSDEVPATH=/devices/pci0000:00/0000:00:02.0/0000:02:01.1/host4/rport-4:0-0/target4:0:0/4:0:0:0
Jul 20 09:13:05 jimbo multipathd: PHYSDEVBUS=scsi
Jul 20 09:13:05 jimbo multipathd: PHYSDEVDRIVER=sd
Jul 20 09:13:05 jimbo multipathd: UDEVD_EVENT=1
Jul 20 09:13:05 jimbo multipathd: IN_HOTPLUG=1
Jul 20 09:13:05 jimbo multipathd: discard event on /class/scsi_disk/4:0:0:0
Jul 20 09:13:05 jimbo multipathd: uevent 'remove' from '/block/sdd/sdd1'
Jul 20 09:13:05 jimbo multipathd: UDEV_LOG=3
Jul 20 09:13:05 jimbo multipathd: ACTION=remove
Jul 20 09:13:05 jimbo multipathd: DEVPATH=/block/sdd/sdd1
Jul 20 09:13:05 jimbo multipathd: SUBSYSTEM=block
Jul 20 09:13:05 jimbo multipathd: SEQNUM=946
Jul 20 09:13:05 jimbo multipathd: MINOR=49
Jul 20 09:13:05 jimbo multipathd: MAJOR=8
Jul 20 09:13:05 jimbo multipathd:
PHYSDEVPATH=/devices/pci0000:00/0000:00:02.0/0000:02:01.1/host4/rport-4:0-0/target4:0:0/4:0:0:0
Jul 20 09:13:05 jimbo multipathd: PHYSDEVBUS=scsi
Jul 20 09:13:05 jimbo multipathd: PHYSDEVDRIVER=sd
Jul 20 09:13:05 jimbo multipathd: UDEVD_EVENT=1
Jul 20 09:13:05 jimbo multipathd: IN_HOTPLUG=1
Jul 20 09:13:05 jimbo multipathd: ID_VENDOR=IBM
Jul 20 09:13:05 jimbo multipathd: ID_MODEL=1815_FAStT
Jul 20 09:13:05 jimbo multipathd: ID_REVISION=0914
Jul 20 09:13:05 jimbo multipathd: ID_SERIAL=3600a0b80001199100000a624468e6438
Jul 20 09:13:05 jimbo multipathd: ID_SERIAL_SHORT=600a0b80001199100000a624468e6438
Jul 20 09:13:05 jimbo multipathd: ID_TYPE=disk
Jul 20 09:13:05 jimbo multipathd: ID_BUS=scsi
Jul 20 09:13:05 jimbo multipathd:
ID_PATH=pci-0000:02:01.1-fc-0x202700a0b8119910:0x0000000000000000
Jul 20 09:13:05 jimbo multipathd: ID_FS_USAGE=filesystem
Jul 20 09:13:05 jimbo multipathd: ID_FS_TYPE=ext3
Jul 20 09:13:05 jimbo multipathd: ID_FS_VERSION=1.0
Jul 20 09:13:05 jimbo multipathd: ID_FS_UUID=8fe0f813-4d2b-4ed1-9b67-ba8805a37561
Jul 20 09:13:05 jimbo multipathd: ID_FS_LABEL=
Jul 20 09:13:05 jimbo multipathd: ID_FS_LABEL_SAFE=
Jul 20 09:13:05 jimbo multipathd:
DEVLINKS=/dev/disk/by-id/scsi-3600a0b80001199100000a624468e6438-part1
/dev/disk/by-path/pci-0000:02:01.1-fc-0x202700a0b8119
910:
Jul 20 09:13:05 jimbo multipathd: DEVNAME=/dev/sdd1
Jul 20 09:13:05 jimbo multipathd: discard event on /block/sdd/sdd1
Jul 20 09:13:05 jimbo multipathd: uevent 'remove' from
'/devices/pci0000:00/0000:00:02.0/0000:02:01.1/host4/rport-4:0-0/target4:0:0/4:0:0:0'
Jul 20 09:13:05 jimbo multipathd: UDEV_LOG=3
Jul 20 09:13:05 jimbo multipathd: ACTION=remove
Jul 20 09:13:05 jimbo multipathd:
DEVPATH=/devices/pci0000:00/0000:00:02.0/0000:02:01.1/host4/rport-4:0-0/target4:0:0/4:0:0:0
Jul 20 09:13:05 jimbo multipathd: SUBSYSTEM=scsi
Jul 20 09:13:05 jimbo multipathd: SEQNUM=948
Jul 20 09:13:05 jimbo multipathd: PHYSDEVBUS=scsi
Jul 20 09:13:05 jimbo multipathd: MODALIAS=scsi:t-0x00
Jul 20 09:13:05 jimbo multipathd: UDEVD_EVENT=1
Jul 20 09:13:05 jimbo multipathd: IN_HOTPLUG=1
Jul 20 09:13:05 jimbo multipathd: discard event on
/devices/pci0000:00/0000:00:02.0/0000:02:01.1/host4/rport-4:0-0/target4:0:0/4:0:0:0
Jul 20 09:13:05 jimbo multipathd: uevent 'remove' from '/block/sdd'
Jul 20 09:13:05 jimbo multipathd: UDEV_LOG=3
Jul 20 09:13:05 jimbo multipathd: ACTION=remove
Jul 20 09:13:05 jimbo multipathd: DEVPATH=/block/sdd
Jul 20 09:13:05 jimbo multipathd: SUBSYSTEM=block
Jul 20 09:13:05 jimbo multipathd: SEQNUM=947
Jul 20 09:13:05 jimbo multipathd: MINOR=48
Jul 20 09:13:05 jimbo multipathd: MAJOR=8
Jul 20 09:13:05 jimbo multipathd:
PHYSDEVPATH=/devices/pci0000:00/0000:00:02.0/0000:02:01.1/host4/rport-4:0-0/target4:0:0/4:0:0:0
Jul 20 09:13:05 jimbo multipathd: PHYSDEVBUS=scsi
Jul 20 09:13:05 jimbo multipathd: PHYSDEVDRIVER=sd
Jul 20 09:13:05 jimbo multipathd: UDEVD_EVENT=1
Jul 20 09:13:05 jimbo multipathd: IN_HOTPLUG=1
Jul 20 09:13:05 jimbo multipathd: ID_VENDOR=IBM
Jul 20 09:13:05 jimbo multipathd: ID_MODEL=1815_FAStT
Jul 20 09:13:05 jimbo multipathd: ID_REVISION=0914
Jul 20 09:13:05 jimbo multipathd: ID_SERIAL=3600a0b80001199100000a624468e6438
Jul 20 09:13:05 jimbo multipathd: ID_SERIAL_SHORT=600a0b80001199100000a624468e6438
Jul 20 09:13:05 jimbo multipathd: ID_TYPE=disk
Jul 20 09:13:05 jimbo multipathd: ID_BUS=scsi
Jul 20 09:13:05 jimbo multipathd:
ID_PATH=pci-0000:02:01.1-fc-0x202700a0b8119910:0x0000000000000000
Jul 20 09:13:05 jimbo multipathd:
DEVLINKS=/dev/disk/by-id/scsi-3600a0b80001199100000a624468e6438
/dev/disk/by-path/pci-0000:02:01.1-fc-0x202700a0b8119910:0x
0000
Jul 20 09:13:05 jimbo multipathd: DEVNAME=/dev/sdd
Jul 20 09:13:06 jimbo multipathd: tick
Jul 20 09:13:06 jimbo multipathd: test: devmap event #6
Jul 20 09:13:06 jimbo multipathd: test: discover
Jul 20 09:13:06 jimbo multipathd: *word = 0, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = rdac, len = 4
Jul 20 09:13:06 jimbo multipathd: *word = 2, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 2, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 8:48, len = 4
Jul 20 09:13:06 jimbo multipathd: *word = 1000, len = 4
Jul 20 09:13:06 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 8:16, len = 4
Jul 20 09:13:06 jimbo multipathd: *word = 1000, len = 4
Jul 20 09:13:06 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 0, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 2, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = E, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 0, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = F, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = E, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 1, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 0, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = A, len = 1
Jul 20 09:13:06 jimbo multipathd: *word = 0, len = 1
Jul 20 09:13:06 jimbo multipathd: test: rr_weight = 1 (internal default)
Jul 20 09:13:06 jimbo multipathd: test: pgfailback = -2 (LUN setting)
Jul 20 09:13:06 jimbo multipathd: test: no_path_retry = NONE (internal default)
Jul 20 09:13:06 jimbo multipathd: pg_timeout = NONE (internal default)
Jul 20 09:13:07 jimbo multipathd: tick
Jul 20 09:13:07 jimbo multipathd: map garbage collection
Jul 20 09:13:08 jimbo multipathd: tick
Jul 20 09:13:09 jimbo multipathd: tick
Jul 20 09:13:10 jimbo multipathd: tick
Jul 20 09:13:10 jimbo kernel: scsi 4:0:0:0: rejecting I/O to dead device
Jul 20 09:13:10 jimbo multipathd: sdd: rdac checker reports path is down
Jul 20 09:13:10 jimbo multipathd: path prio refresh
Jul 20 09:13:10 jimbo multipathd: sdd: mask = 0x8
Jul 20 09:13:11 jimbo multipathd: tick
...

After that, the last five lines keep repeating until it's killed.
