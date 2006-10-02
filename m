From: Brice Figureau <brice@daysofwonder.com>
Subject: dm_snapshot: Unable to handle kernel NULL pointer after
	lvremove...
Date: Mon, 02 Oct 2006 17:52:40 +0200
Message-ID: <1159804360.3118.28.camel@localhost.localdomain>
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

Hi,

I just found the following oops after lvremove'ing a snapshot which was
used to backup a mysql database (ie there were high I/O on the snapshot,
and a few I/O on the original LV).

After that a lvdisplay is stuck in D+ state (I guess there are some
locks in the kernel that hadn't been released because of the crash). 
Is there a mean to 'unfreeze' this situation?

All this is on an amd64 debian etch with custom compiled kernel version
2.6.17, and lvm2 version 2.02.06-2, and libdevmapper is at 1.02.08-1.

Here is the trace information:

attempt to access beyond end of device
dm-8: rw=17, want=4194320, limit=4194304
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
<ffffffff8804c121>{:dm_snapshot:exit_exception_table+81}
PGD 5e9eb067 PUD 1d537067 PMD 0 
Oops: 0000 [1] SMP 
CPU 1 
Modules linked in: ip_conntrack_ftp ipt_REJECT xt_tcpudp ipt_LOG xt_limit xt_state iptable_filter ip_conntrack nfnetlink ipmi_watchdog button ac battery ip_tables x_tables megaraid ipmi_devintf ipmi_si ipmi_msghandler psmouse e752x_edac serio_raw pcspkr hw_random edac_mc dm_mirror dm_snapshot dm_mod megaraid_mbox ehci_hcd uhci_hcd megaraid_mm thermal processor fan
Pid: 4452, comm: lvremove Not tainted 2.6.17 #2
RIP: 0010:[<ffffffff8804c121>] <ffffffff8804c121>{:dm_snapshot:exit_exception_table+81}
RSP: 0018:ffff810076957c38  EFLAGS: 00010282
RAX: 0000000000000001 RBX: ffffc20010400e00 RCX: 0000000000000004
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff81007f5eb200
RBP: ffff810076957c68 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff81007f5eb200 R14: 00000000000021e0 R15: ffff8100770b86e8
FS:  00002b05cb22bc80(0000) GS:ffff81007ffae3c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000063d52000 CR4: 00000000000006e0
Process lvremove (pid: 4452, threadinfo ffff810076956000, task ffff81007e89eb50)
Stack: 0000400000000282 ffff8100770b8680 ffffc20000061080 0000000000000000 
       00000000005b7cd0 ffffffff8803d330 ffff810076957c88 ffffffff8804c7ba 
       ffffc20000061080 ffff81007e9bbc00 
Call Trace: <ffffffff8803d330>{:dm_mod:dev_remove+0}
       <ffffffff8804c7ba>{:dm_snapshot:snapshot_dtr+170} <ffffffff8803ab09>{:dm_mod:dm_table_put+121}
       <ffffffff8803a107>{:dm_mod:dm_put+87} <ffffffff8803c9c0>{:dm_mod:__hash_remove+144}
       <ffffffff8803d37c>{:dm_mod:dev_remove+76} <ffffffff8803e370>{:dm_mod:ctl_ioctl+640}
       <ffffffff8028bffd>{do_ioctl+125} <ffffffff8028c2cd>{vfs_ioctl+685}
       <ffffffff8028c33d>{sys_ioctl+77} <ffffffff80209c8a>{system_call+126}


As this process is used to backup a mysql server, I'd like it to work
without rebooting the server each day. 
Is it a known problem? has it been fixed in a subsequent kernel release?

Thank you for your help, if someone needs more information I can send
it.
-- 
Brice Figureau
Days of Wonder
