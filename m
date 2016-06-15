From: Chris Friesen <chris.friesen@windriver.com>
Subject: [bug?]  "vgs" command hanging after running "targetctl clear"
Date: Wed, 15 Jun 2016 12:27:19 -0600
Message-ID: <57619E07.2030406@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, target-devel@vger.kernel.org
List-Id: dm-devel.ids

I'm running a CentOS-7 based system, so if that disqualifies me due to the 
amount of kernel patches please let me know. :)

Anyways, I've run into some weird behaviour.  I have a single system.  I'm 
exporting an ISCSI target using targetctl.  The backing store is a 
thinly-provisioned LVM volume, where the underlying PV is a single drbd device, 
which in turn is backed by /dev/sdb1.  The LVM/drbd setup (as well as other 
configuration) is done by scripts and I'm not aware of all the exact config details.

I'm using iscsiadm to discover and then login to the target, so that "ls -l 
/dev/disk/by-path" shows this:

lrwxrwxrwx 1 root root  9 Jun 15 16:36 
ip-127.0.0.1:3260-iscsi-iqn.2014-10.com.example.server1:iscsi-1-lun-0 -> ../../sdc


Now here's where it gets a bit odd.  If I run "targetctl clear", then run "vgs", 
the vgs command hangs.  /proc/<pid>/stack for the hung process looks like this:

controller-0:/home/wrsroot# cat /proc/15379/stack
[<ffffffff81081ae5>] flush_work+0x105/0x1d0
[<ffffffff81081c39>] __cancel_work_timer+0x89/0x120
[<ffffffff81081d03>] cancel_delayed_work_sync+0x13/0x20
[<ffffffff812dba60>] disk_block_events+0x80/0x90
[<ffffffff811dee0e>] __blkdev_get+0x6e/0x4d0
[<ffffffff811df445>] blkdev_get+0x1d5/0x360
[<ffffffff811df67b>] blkdev_open+0x5b/0x80
[<ffffffff811a1cc7>] do_dentry_open+0x1a7/0x2e0
[<ffffffff811a1ef9>] vfs_open+0x39/0x70
[<ffffffff811b131d>] do_last+0x1ed/0x1270
[<ffffffff811b4082>] path_openat+0xc2/0x490
[<ffffffff811b584b>] do_filp_open+0x4b/0xb0
[<ffffffff811a33c3>] do_sys_open+0xf3/0x1f0
[<ffffffff811a34de>] SyS_open+0x1e/0x20
[<ffffffff81681249>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

After 900 seconds it unblocks, and I get kernel logs that look like this:
[ 5655.520252]  session1: session recovery timed out after 900 secs
[ 5655.520281] sd 3:0:0:0: rejecting I/O to offline device

In this case, "sd 3:0:0:0" corresponds to /dev/sdc, which is the iscsi device 
created via iscsiadm.

It makes sense that accesses to /dev/sdc would block, but why is that causing 
the "vgs" command to block?


Just to make things confusing, if I take the same userspace/kernel and don't do 
the automatic setup, I can manually set up drbd/LVM, then use the same targetctl 
config script to export the iscsi target, and the same commands to discover and 
login to it.  In this case, if I run "targetctl clear" and then run "vgs" the 
command does NOT hang.

Anyone have any ideas what might be going on, or how to track it down?

Thanks,
Chris
