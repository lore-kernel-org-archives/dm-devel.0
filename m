From: "Michael L. Semon" <mlsemon35@gmail.com>
Subject: xfstests "free active" issue on x86?
Date: Wed, 25 Sep 2013 21:32:01 -0400
Message-ID: <52438E91.4070606@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi!  I turned on the kernel's kobject debugging for the first time 
in months, to see what it would do during xfstests.  During 
xfstests test generic/311, I got some output that looks like this:

kobject: 'dm-0' (c8eee464): kobject_uevent_env
kobject: 'dm-0' (c8eee464): fill_kobj_path: path = '/devices/virtual/block/dm-0'
kobject: 'dm' (db0db2e0): kobject_release, parent c8eee464 (delayed)
kobject: '254:0' (c42df408): kobject_uevent_env
kobject: '254:0' (c42df408): fill_kobj_path: path = '/devices/virtual/bdi/254:0'
kobject: '254:0' (c42df408): kobject_release, parent   (null) (delayed)
kobject: 'queue' (ddc489c8): kobject_uevent_env
kobject: 'queue' (ddc489c8): kobject_uevent_env: filter function caused the event to drop!
kobject: 'holders' (d5b7cd80): kobject_release, parent c8eee464 (delayed)
kobject: 'slaves' (d5b7cf00): kobject_release, parent c8eee464 (delayed)
kobject: 'dm-0' (c8eee464): kobject_uevent_env
kobject: 'dm-0' (c8eee464): fill_kobj_path: path = '/devices/virtual/block/dm-0'
------------[ cut here ]------------
WARNING: CPU: 0 PID: 15689 at lib/debugobjects.c:260 debug_print_object+0x7f/0x93()
ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x17
CPU: 0 PID: 15689 Comm: dmsetup Not tainted 3.11.0+ #2
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
 dd459c9c dd459c9c dd459c5c c15433b8 dd459c8c c102f64d c16d7774 dd459cb8
 00003d49 c16d6cc3 00000104 c130ed8f c130ed8f c5eea2b8 c173f6ac db0db328
 dd459ca4 c102f6be 00000009 dd459c9c c16d7774 dd459cb8 dd459cd8 c130ed8f
Call Trace:
 [<c15433b8>] dump_stack+0x16/0x18
 [<c102f64d>] warn_slowpath_common+0x75/0x8c
 [<c130ed8f>] ? debug_print_object+0x7f/0x93
 [<c130ed8f>] ? debug_print_object+0x7f/0x93
 [<c102f6be>] warn_slowpath_fmt+0x33/0x35
 [<c130ed8f>] debug_print_object+0x7f/0x93
 [<c1046e3f>] ? __queue_work+0x3b0/0x3b0
 [<c130f909>] debug_check_no_obj_freed+0x163/0x1a2
 [<c10f8552>] kfree+0xad/0x245
 [<c15495e5>] ? _raw_spin_unlock_irq+0x27/0x36
 [<c140eb19>] ? __dm_destroy+0x1cd/0x221
 [<c140eb19>] __dm_destroy+0x1cd/0x221
 [<c140f9af>] dm_destroy+0x12/0x14
 [<c14144a9>] dev_remove+0x7f/0xc4
 [<c141484d>] ctl_ioctl+0x21b/0x461
 [<c141442a>] ? __hash_remove+0x78/0x78
 [<c1414a93>] ? ctl_ioctl+0x461/0x461
 [<c1414aa4>] dm_ctl_ioctl+0x11/0x13
 [<c110ee60>] do_vfs_ioctl+0x2f6/0x4cc
 [<c10254ed>] ? __do_page_fault+0x1b8/0x3ee
 [<c11076b1>] ? final_putname+0x1d/0x36
 [<c1107822>] ? putname+0x23/0x32
 [<c11193e8>] ? fget_light+0x22e/0x410
 [<c10e8e05>] ? vm_munmap+0x3f/0x49
 [<c110f075>] SyS_ioctl+0x3f/0x6a
 [<c138fd04>] ? perf_trace_scsi_dispatch_cmd_start+0xef/0x131
 [<c154a9bb>] sysenter_do_call+0x12/0x32
 [<c138fd04>] ? perf_trace_scsi_dispatch_cmd_start+0xef/0x131
---[ end trace 270dd251caf4e8bb ]---
 [failed, exit status 1] - output mismatch (see /var/lib/xfstests/results//generic/311.out.bad)
    --- tests/generic/311.out	2013-09-23 03:55:36.568877480 -0400
    +++ /var/lib/xfstests/results//generic/311.out.bad	2013-09-24 09:03:35.115593488 -0400
    @@ -1,321 +1,74 @@
     QA output created by 311
    +mount: wrong fs type, bad option, bad superblock on /dev/mapper/flakey-test,
    +       missing codepage or helper program, or other error
    +       In some cases useful info is found in syslog - try
    +       dmesg | tail  or so
    +
     Running test 1 buffered, normal suspend
     ...
     (Run 'diff -u tests/generic/311.out /var/lib/xfstests/results//generic/311.out.bad' to see the entire diff)
kobject: '254:0' (c42df408): kobject_cleanup, parent   (null)
kobject: '254:0' (c42df408): calling ktype release
kobject: '254:0': free name
kobject: 'holders' (d5b7cd80): kobject_cleanup, parent c8eee464
kobject: 'holders' (d5b7cd80): auto cleanup kobject_del
kobject: 'holders' (d5b7cd80): calling ktype release
kobject: (d5b7cd80): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (d5b7cf00): kobject_cleanup, parent c8eee464
kobject: 'slaves' (d5b7cf00): auto cleanup kobject_del
kobject: 'slaves' (d5b7cf00): calling ktype release
kobject: (d5b7cf00): dynamic_kobj_release
kobject: 'slaves': free name

My FS setup (XFS + external journal) was not kind to this test, and 
nothing really worked correctly.  However, is there anything worth 
chasing in this message?  If nothing else, reproducibility is 100% 
right now.  I have a newer trace, but it has only kobject-release 
debugging, not the full kobject debugging.

The PC in use is a 32-bit x86 Pentium 4, 512 MB RAM, running 
slackware-current.  udevd is not active, though I think the kernel's 
devtmpfs facility is in use (need to double-check).

Thanks!

Michael
