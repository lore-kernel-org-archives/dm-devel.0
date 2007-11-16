From: Dushyanth <dushyanth@gmail.com>
Subject: LVM2, Multipath & iSCSI Volumes
Date: Fri, 16 Nov 2007 08:41:23 +0000 (UTC)
Message-ID: <loom.20071116T082815-74@post.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hey,

Iam using linux-isci-utils default rpm with Centos 4.5. The targets are on a
Hitachi WMS 100. The LUNs are exposed via both iSCSI ports for multipathing.

There are three LUNs exposed via both ports and I can see disks from sdb to sdg.
After start iscsi initiator i created a primary partition (type set to LVM)
using parted on sdb, sdc and sde.

I then configured multipath and i can see all devices mapped cleanly.

hitachi03 (36000000000000000043b8bff00000002)
[size=943 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 3:0:0:2 sdf 8:80 [active][ready]
 \_ 4:0:0:2 sdg 8:96 [active][ready]

hitachi02 (36000000000000000043b8bff00000001)
[size=2047 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2][active]
 \_ 4:0:0:1 sde 8:64 [active][ready]
 \_ 3:0:0:1 sdd 8:48 [active][ready]

hitachi01 (36000000000000000043b8bff00000000)
[size=2047 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 3:0:0:0 sdb 8:16 [active][ready]
 \_ 4:0:0:0 sdc 8:32 [active][ready]

[root@localhost ~]# ll /dev/mapper/
total 0
crw-------  1 root root  10, 63 Nov 15 19:52 control
brw-rw----  1 root disk 253,  2 Nov 15 20:08 hitachi01
brw-rw----  1 root disk 253,  5 Nov 15 20:08 hitachi01p1
brw-rw----  1 root disk 253,  1 Nov 15 20:08 hitachi02
brw-rw----  1 root disk 253,  3 Nov 15 20:08 hitachi02p1
brw-rw----  1 root disk 253,  0 Nov 15 20:08 hitachi03
brw-rw----  1 root disk 253,  4 Nov 15 20:08 hitachi03p1

I want to use hitachi01p1, hitachi02p1 and hitachi03p1 as PVs in a LVM2 VG. So i
did a pvcreate, but pvdisplay shows a weird result.

[root@localhost ~]# pvcreate /dev/mapper/hitachi01p1
  Physical volume "/dev/mapper/hitachi01p1" successfully created

[root@localhost ~]# pvdisplay
  --- NEW Physical volume ---
  PV Name               /dev/mapper/hitachi01p1
  VG Name
  PV Size               101.94 MB
  Allocatable           NO
  PE Size (KByte)       0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               mPcYnl-OIHH-QK1U-f7vV-GV0t-NOBA-S2JFdf

PV Size is is only 101 MB whereas the LUN size is 2 TB.

My lvm.conf has...

    filter = [ "a|/dev/mapper/hitachi0.p.$|","r/.*/" ]
    types = [ "device-mapper", 1 ]

# vgscan -vvvv 

#filters/filter-regex.c:170         /dev/mapper/hitachi02p1: New preferred name
#device/dev-io.c:440         Opened /dev/mapper/hitachi02p1 RO
#device/dev-io.c:264       /dev/mapper/hitachi02p1: size is 208782 sectors
#device/dev-io.c:486         Closed /dev/mapper/hitachi02p1
#device/dev-io.c:264       /dev/mapper/hitachi02p1: size is 208782 sectors
#device/dev-io.c:440         Opened /dev/mapper/hitachi02p1 RO O_DIRECT
#device/dev-io.c:134         /dev/mapper/hitachi02p1: block size is 1024 bytes
#device/dev-io.c:486         Closed /dev/mapper/hitachi02p1
#filters/filter-composite.c:31         Using /dev/mapper/hitachi02p1
#device/dev-io.c:440         Opened /dev/mapper/hitachi02p1 RO O_DIRECT
#device/dev-io.c:134         /dev/mapper/hitachi02p1: block size is 1024 bytes
#label/label.c:180       /dev/mapper/hitachi02p1: No label detected
#label/label.c:278         <backtrace>
#device/dev-io.c:486         Closed /dev/mapper/hitachi02p1

#filters/filter-regex.c:170         /dev/mapper/hitachi03p1: New preferred name
#device/dev-io.c:440         Opened /dev/mapper/hitachi03p1 RO
#device/dev-io.c:264       /dev/mapper/hitachi03p1: size is 208782 sectors
#device/dev-io.c:486         Closed /dev/mapper/hitachi03p1
#device/dev-io.c:264       /dev/mapper/hitachi03p1: size is 208782 sectors
#device/dev-io.c:440         Opened /dev/mapper/hitachi03p1 RO O_DIRECT
#device/dev-io.c:134         /dev/mapper/hitachi03p1: block size is 1024 bytes
#device/dev-io.c:486         Closed /dev/mapper/hitachi03p1
#filters/filter-composite.c:31         Using /dev/mapper/hitachi03p1
#device/dev-io.c:440         Opened /dev/mapper/hitachi03p1 RO O_DIRECT
#device/dev-io.c:134         /dev/mapper/hitachi03p1: block size is 1024 bytes
#label/label.c:180       /dev/mapper/hitachi03p1: No label detected
#label/label.c:278         <backtrace>
#device/dev-io.c:486         Closed /dev/mapper/hitachi03p1

#filters/filter-regex.c:170         /dev/mapper/hitachi01p1: New preferred name
#device/dev-io.c:440         Opened /dev/mapper/hitachi01p1 RO
#device/dev-io.c:264       /dev/mapper/hitachi01p1: size is 208782 sectors
#device/dev-io.c:486         Closed /dev/mapper/hitachi01p1
#device/dev-io.c:264       /dev/mapper/hitachi01p1: size is 208782 sectors
#device/dev-io.c:440         Opened /dev/mapper/hitachi01p1 RO O_DIRECT
#device/dev-io.c:134         /dev/mapper/hitachi01p1: block size is 1024 bytes
#device/dev-io.c:486         Closed /dev/mapper/hitachi01p1
#filters/filter-composite.c:31         Using /dev/mapper/hitachi01p1
#device/dev-io.c:440         Opened /dev/mapper/hitachi01p1 RO O_DIRECT
#device/dev-io.c:134         /dev/mapper/hitachi01p1: block size is 1024 bytes
#label/label.c:158       /dev/mapper/hitachi01p1: lvm2 label detected
#cache/lvmcache.c:656         lvmcache: /dev/mapper/hitachi01p1: now orphaned
#format_text/format-text.c:921         <backtrace>
#device/dev-io.c:486         Closed /dev/mapper/hitachi01p1

Im not using udev rules to create persistance naming for iscsi devices. I dont
think its required as multipath already maps the devices.

How can i fix this ?

TIA
Dushyanth
