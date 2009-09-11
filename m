From: Andy <genanr@emsphone.com>
Subject: multipath-tools and queue-length/service-time path
	selectors oops
Date: Fri, 11 Sep 2009 16:34:35 -0500
Message-ID: <20090911213435.GA1590@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

When I try to change the path selector in multipath.conf to queue-length or
service-time I get a kernel oops.

Sep 11 15:33:32 linuxdev1 kernel: Modules linked in: kvm_intel kvm autofs4 cpufreq_powersave cpufreq_userspace cpufreq_ondemand cpufreq_conservative fuse qla2xxx dcdbas
Sep 11 15:33:32 linuxdev1 kernel: Pid: 6611, comm: multipath Not tainted 2.6.31 #34 PowerEdge 1950
Sep 11 15:33:32 linuxdev1 kernel: RIP: 0010:[<ffffffff8134207d>]  [<ffffffff8134207d>] multipath_ctr+0x7dd/0x980
Sep 11 15:33:32 linuxdev1 kernel: RSP: 0018:ffff880227d41c88  EFLAGS: 00010207
Sep 11 15:33:32 linuxdev1 kernel: RAX: 0000000000000002 RBX: 0000000000000000 RCX: ffff880226d41e40
Sep 11 15:33:32 linuxdev1 kernel: RDX: ffff88022de41980 RSI: 0000000000000286 RDI: 0000000000000286
Sep 11 15:33:32 linuxdev1 kernel: RBP: ffff880227d41d48 R08: 000000000000000a R09: 000000000000000a
Sep 11 15:33:32 linuxdev1 kernel: R10: 000000000000003c R11: 0000000000000000 R12: 0000000000000000
Sep 11 15:33:32 linuxdev1 kernel: R13: 0000000000000003 R14: 0000000000000003 R15: 0000000000000000
Sep 11 15:33:32 linuxdev1 kernel: FS:  00007f8d06dff790(0000) GS:ffff8800280ca000(0000) knlGS:0000000000000000
Sep 11 15:33:32 linuxdev1 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep 11 15:33:32 linuxdev1 kernel: CR2: 0000000000000030 CR3: 0000000227d37000 CR4: 00000000000026e0
Sep 11 15:33:32 linuxdev1 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Sep 11 15:33:32 linuxdev1 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Sep 11 15:33:32 linuxdev1 kernel: Process multipath (pid: 6611, threadinfo ffff880227d40000, task ffff88022ddb22d0)
Sep 11 15:33:32 linuxdev1 kernel: 00000000ffffffff 8000000000000163 ffffc90004f2a040 000000001cc2f800
Sep 11 15:33:32 linuxdev1 kernel: <0> ffff88022de41980 0000000000000040 ffff88022de419b0 ffff880227d41d70
Sep 11 15:33:32 linuxdev1 kernel: <0> ffff880226d41e78 ffffc90004f2a040 ffffc90004f24160 ffff880226d41e58
Sep 11 15:33:32 linuxdev1 kernel: [<ffffffff8133b4d2>] dm_table_add_target+0x172/0x220
Sep 11 15:33:32 linuxdev1 kernel: [<ffffffff8133d549>] table_load+0xe9/0x290
Sep 11 15:33:32 linuxdev1 kernel: [<ffffffff8133d460>] ? table_load+0x0/0x290
Sep 11 15:33:32 linuxdev1 kernel: [<ffffffff8133e4e1>] ctl_ioctl+0x1e1/0x260
Sep 11 15:33:32 linuxdev1 kernel: [<ffffffff810aad15>] ? cache_alloc_refill+0x85/0x270
Sep 11 15:33:32 linuxdev1 kernel: [<ffffffff8133e56e>] dm_ctl_ioctl+0xe/0x20
Sep 11 15:33:32 linuxdev1 kernel: [<ffffffff810bf811>] vfs_ioctl+0x31/0xa0
Sep 11 15:33:32 linuxdev1 kernel: [<ffffffff810bfd03>] do_vfs_ioctl+0x3f3/0x580
Sep 11 15:33:32 linuxdev1 kernel: [<ffffffff810bfeda>] sys_ioctl+0x4a/0x80
Sep 11 15:33:32 linuxdev1 kernel: [<ffffffff8100b4c2>] system_call_fastpath+0x16/0x1b
Sep 11 15:33:32 linuxdev1 kernel: RSP <ffff880227d41c88>
Sep 11 15:33:32 linuxdev1 kernel: ---[ end trace a1499fdf6de0e5c0 ]---

Any ideas,
	Andy
