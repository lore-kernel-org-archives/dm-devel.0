From: "Fiederling, Daniel" <daniel.fiederling@warema.de>
Subject: multipath setup with emc clariion
Date: Wed, 19 Jul 2006 15:55:51 +0200
Message-ID: <7CA7BBF7F95AA245ACAB8E28A6285EB905191DD8@s01edv50.warema.de>
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

currently I'm trying to set up a SuSE 10.1 box with two qlogic adapters
("suse shipped" qla2xxx module), each one is connected to one of our two
emc clariions that are offering 50GB disks. I have four paths to each
clariion. When I start the multipath config init script "boot.multipath"
the script hangs and never returns, no chance to abort. I put a lot of
debug stuff here so maybe someone can tell me why the script (or better
said kpartx) hangs (see the following "ps ax").
I guess one of the kernel modules is waiting for some init stuff of the
disks because I even can't "kill -9 <kpartx>".

The multipath.conf is mostly derived from a pdf by emc. The multipaths
{} section is written by me.

What does the following message from multipath mean:
sdX: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
What do I have to do to resolve this "problem"?

Ciao
Daniel

btw.: I also tried using the latest qlogic drivers, same result.


# cat /etc/multipath.conf
blacklist {
	wwid 20010b9fd080b7321
	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
	devnode "^hd[a-z][[0-9]*]"
	devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}

devices {
	device {
		vendor "EMC "
		product "SYMMETRIX"
		path_grouping_policy multibus
		getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
		path_selector "round-robin 0"
		features "0"
		hardware_handler "0"
		failback immediate
	}
	device {
		vendor "DGC"
		product "*"
		path_grouping_policy group_by_prio
		getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
		prio_callout "/sbin/mpath_prio_emc /dev/%n"
		hardware_handler "1 emc"
		features "1 queue_if_no_path"
		no_path_retry 300
		path_checker emc_clariion
		failback immediate
	}
}

multipaths {
	multipath {
		wwid
3600601608d1e170090af86321308db11
		alias			san1
		path_grouping_policy	failover
		failback		immediate
	}
	multipath {
		wwid
360060160a1f4160072ee88ba1208db11
		alias			san2
		path_grouping_policy	failover
		failback		immediate
	}
}


# uname -r
2.6.16.13-4-smp

# dmsetup version
Library version:   1.02.03 (2006-02-08)
Driver version:    4.5.0



# lsscsi
[0:0:0:0]    disk    DGC      RAID 5           0219  /dev/sda
[0:0:1:0]    disk    DGC      LUNZ             0219  /dev/sdb
[0:0:2:0]    disk    DGC      LUNZ             0219  /dev/sdc
[0:0:3:0]    disk    DGC      LUNZ             0219  /dev/sdd
[1:0:0:0]    disk    DGC      RAID 5           0219  /dev/sde
[1:0:1:0]    disk    DGC      LUNZ             0219  /dev/sdf
[1:0:2:0]    disk    DGC      LUNZ             0219  /dev/sdg
[1:0:3:0]    disk    DGC      LUNZ             0219  /dev/sdh

# ps ax
...
 3568 pts/0    S+     0:00 /bin/sh /etc/init.d/boot.multipath start
 3584 ?        S<     0:00 [kmpathd/0]
 3585 ?        S<     0:00 [kmpathd/1]
 3620 ?        S<     0:00 /sbin/udevd --daemon
 3621 ?        D<     0:00 /sbin/vol_id --export /dev/.tmp-253-1
 3625 ?        S<     0:00 /sbin/udevd --daemon
 3626 ?        D<     0:00 /sbin/vol_id --export /dev/.tmp-253-2
 3630 pts/0    S+     0:00 /sbin/dmsetup ls --target multipath --exec
/sbin/kpartx -a -p -part
 3632 pts/0    D+     0:00 /sbin/kpartx -a -p -part
/dev/mapper/350060160b02217df50060160b02217df

# lsmod | grep dm
dm_round_robin          7168  1
dm_emc                  9472  1
dm_multipath           22152  3 dm_round_robin,dm_emc
dm_mod                 57936  9 dm_multipath

# multipath -d v4 (after starting the config script!)
sda: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sde: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"

# multipath -ll (after starting the config script!)
sda: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sde: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
350060160b02217df50060160b02217df
[size=3D1 GB][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D3][enabled]
 \_ 0:0:2:0 sdc 8:32  [failed][ready]
 \_ 0:0:3:0 sdd 8:48  [failed][ready]
 \_ 1:0:1:0 sdf 8:80  [failed][ready]
350060160b022151c50060160b022151c
[size=3D1 GB][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D3][enabled]
 \_ 0:0:1:0 sdb 8:16  [failed][ready]
 \_ 1:0:2:0 sdg 8:96  [failed][ready]
 \_ 1:0:3:0 sdh 8:112 [failed][ready]
san2 (360060160a1f4160072ee88ba1208db11)
[size=3D50 GB][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D0][active]
 \_ 1:0:0:0 sde 8:64  [active][faulty]
san1 (3600601608d1e170090af86321308db11)
[size=3D50 GB][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:0:0 sda 8:0   [active][faulty]

# dmesg (after starting the config script!)
device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
dm-netlink version 0.0.2 loaded
device-mapper: dm-multipath version 1.0.4 loaded
device-mapper: dm-emc version 0.0.3 loaded
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-round-robin version 1.0.0 loaded
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: emc_pg_init: sending switch-over command
end_request: I/O error, dev sdh, sector 2097024
device-mapper: dm-multipath: Failing path 8:112.
end_request: I/O error, dev sdg, sector 2097024
device-mapper: dm-multipath: Failing path 8:96.
end_request: I/O error, dev sdb, sector 2097024
device-mapper: dm-multipath: Failing path 8:16.
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: emc_pg_init: sending switch-over command
end_request: I/O error, dev sdf, sector 2097024
device-mapper: dm-multipath: Failing path 8:80.
end_request: I/O error, dev sdd, sector 2097024
device-mapper: dm-multipath: Failing path 8:48.
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
end_request: I/O error, dev sdc, sector 2097024
device-mapper: dm-multipath: Failing path 8:32.
device-mapper: dm-emc: emc_pg_init: sending switch-over command

# dmsetup table
350060160b02217df50060160b02217df: 0 2097152 multipath 1
queue_if_no_path 1 emc 1 1 round-robin 0 3 1 8:32 1000 8:48 1000 8:80
1000
350060160b022151c50060160b022151c: 0 2097152 multipath 1
queue_if_no_path 1 emc 1 1 round-robin 0 3 1 8:16 1000 8:96 1000 8:112
1000
san2: 0 104857600 multipath 1 queue_if_no_path 1 emc 1 1 round-robin 0 1
1 8:64 1000
san1: 0 104857600 multipath 1 queue_if_no_path 1 emc 1 1 round-robin 0 1
1 8:0 1000
