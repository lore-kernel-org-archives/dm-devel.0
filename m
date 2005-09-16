From: Ray Stell <stellr@cns.vt.edu>
Subject: lvm - No matching physical volumes found
Date: Fri, 16 Sep 2005 10:22:11 -0400
Message-ID: <20050916142211.GA10521@locust.cns.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Can you tell what's going wrong here.  TIA: 

[root@pecan ~]# pvscan
  No matching physical volumes found

--------------------------------------

[root@pecan ~]# lvm dumpconfig
devices {
        dir="/dev"
        scan="/dev"
        filter=["r/sd.*/", "a/.*/"]
        cache="/etc/lvm/.cache"
        write_cache_state=1
        types=["device-mapper", 1]
        sysfs_scan=1
        md_component_detection=1
}
activation {
        missing_stripe_filler="/dev/ioerror"
        mirror_region_size=512
        reserved_stack=256
        reserved_memory=8192
        process_priority=-18
}
global {
        umask=63
        test=0
        activation=1
        proc="/proc"
        locking_type=1
        locking_dir="/var/lock/lvm"
}
shell {
        history_size=100
}
backup {
        backup=1
        backup_dir="/etc/lvm/backup"
        archive=1
        archive_dir="/etc/lvm/archive"
        retain_min=10
        retain_days=30
}
log {
        verbose=0
        syslog=1
        overwrite=0
        level=0
        indent=1
        command_names=0
        prefix="  "
}

--------------------------------------

[root@pecan dev]# ls -l /dev/dm-*
brw-r-----  1 root root 253, 0 Sep 16 09:32 /dev/dm-0
brw-r-----  1 root root 253, 1 Sep 16 09:32 /dev/dm-1
brw-r-----  1 root root 253, 2 Sep 16 09:32 /dev/dm-2
brw-r-----  1 root root 253, 3 Sep 16 09:32 /dev/dm-3

[root@pecan dev]# ls -l /dev/mapper/
crw-------  1 root root  10, 63 Sep 16 09:30 control
brw-rw----  1 root disk 253,  1 Sep 16 09:32 LUN30A
brw-rw----  1 root disk 253,  0 Sep 16 09:32 LUN50A
brw-rw----  1 root disk 253,  2 Sep 16 09:32 LUN726
brw-rw----  1 root disk 253,  3 Sep 16 09:32 LUN727

[root@pecan dev]# dmsetup table
LUN30A: 0 41015680 multipath 0 0 1 1 round-robin 0 3 1 8:16 1000 8:144 1000 8:208 1000
LUN50A: 0 41015680 multipath 0 0 1 1 round-robin 0 3 1 8:0 1000 8:64 1000 8:128 1000
LUN727: 0 41015680 multipath 0 0 1 1 round-robin 0 3 1 8:48 1000 8:176 1000 8:240 1000
LUN726: 0 41015680 multipath 0 0 1 1 round-robin 0 4 1 8:32 1000 8:96 1000 8:160 1000 8:224 1000

--------------------------------------

[root@pecan ~]# multipath -ll
LUN30A (1IBM_____2105____________30A22206)
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:1 sdb  8:16    [ready ][active]
  \_ 1:0:0:1 sdj  8:144   [ready ][active]
  \_ 1:0:1:1 sdn  8:208   [ready ][active]

LUN50A (1IBM_____2105____________50A22206)
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:0 sda  8:0     [ready ][active]
  \_ 0:0:1:0 sde  8:64    [ready ][active]
  \_ 1:0:0:0 sdi  8:128   [ready ][active]

LUN727 (1IBM_____2105____________72722206)
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:3 sdd  8:48    [ready ][active]
  \_ 1:0:0:3 sdl  8:176   [ready ][active]
  \_ 1:0:1:3 sdp  8:240   [ready ][active]

LUN726 (1IBM_____2105____________72622206)
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:2 sdc  8:32    [ready ][active]
  \_ 0:0:1:2 sdg  8:96    [ready ][active]
  \_ 1:0:0:2 sdk  8:160   [ready ][active]
  \_ 1:0:1:2 sdo  8:224   [ready ][active]

--------------------------------------

environment:
 - rhas4 U2 Beta - Linux pecan 2.6.9-16.EL #1 Mon Aug 15 19:58:49 EDT 2005 i686 i686 i386 GNU/Linux
 - multipath-tools-0.4.5.49. compiled from ftp://sources.redhat.com/pub/dm/multipath-tools 
 - 2 QLogic PCI to Fibre Channel Host Adapters for QLA2340:
   Firmware version 3.03.15 IPX, Driver version 8.01.00b5-rh2
 - IBM ESS 2105F20 4 paths
============================================================
Ray Stell  stellr@vt.edu  (540) 231-4109  Tempus fugit  28^D
