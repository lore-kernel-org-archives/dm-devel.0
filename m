From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: might_sleep warning in multipath_dtr
Date: Wed, 7 May 2008 10:37:16 +0200
Message-ID: <20080507083716.GA30401@schmichrtp.de.ibm.com>
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

A test with multipathing and periodic path failures (2.6.25 on s390x)
hit this problem:

   <3>BUG: sleeping function called from invalid context at /home/autobuild/BUILD/linux-2.6.25-20080430/kernel/workqueue.c:396
    <4>in_atomic():1, irqs_disabled():0
    <4>CPU: 1 Not tainted 2.6.25-28.x.20080430-s390xdefault #1
    <4>Process pdflush (pid: 19981, task: 0000000008914538, ksp: 000000001418fba8)
    <4>0000000000000000 000000001418fac0 0000000000000002 0000000000000000 
    <4>       000000001418fb60 000000001418fad8 000000001418fad8 000000000010563c 
    <4>       0000000000000000 000000001418fba8 0000000000000000 0000000000000000 
    <4>       000000001418fac0 000000000000000c 000000001418fac0 000000001418fb30 
    <4>       0000000000464aa0 000000000010563c 000000001418fac0 000000001418fb10 
    <4>Call Trace:
    <4>([<00000000001055c2>] show_trace+0x12e/0x13c)
    <4> [<0000000000105696>] show_stack+0xc6/0xf8
    <4> [<0000000000105e58>] dump_stack+0xb0/0xc0
    <4> [<0000000000129092>] __might_sleep+0x106/0x128
    <4> [<000000000014e344>] flush_workqueue+0x44/0x9c
    <4> [<000003e00008f79c>] multipath_dtr+0x38/0x50 [dm_multipath]
    <4> [<000003e000077e4a>] dm_table_put+0xae/0x134 [dm_mod]
    <4> [<000003e000076020>] dm_any_congested+0x50/0x88 [dm_mod]
    <4> [<00000000001e09c0>] sync_sb_inodes+0xa4/0x334
    <4> [<00000000001e0f9e>] writeback_inodes+0xfa/0x130
    <4> [<0000000000189e04>] wb_kupdate+0xd0/0x170
    <4> [<000000000018a65a>] pdflush+0x14a/0x22c
    <4> [<0000000000152bec>] kthread+0x68/0xa0
    <4> [<000000000010a0be>] kernel_thread_starter+0x6/0xc
    <4> [<000000000010a0b8>] kernel_thread_starter+0x0/0xc

After the bug message, the CPU is waiting in _raw_spin_relax:

================================================================
TASK HAS CPU (1): 0x8914538 (pdflush):
 LOWCORE INFO:
  -psw      : 0x0704100180000000 0x00000000002aa8f6
  -function : _raw_spin_relax+94
  -prefix   : 0x1fb04000
  -cpu timer: 0x7fffd1ed 0xa3fc6a40
  -clock cmp: 0x00c25518 0x4f9f8839
  -general registers:
     000000000000000000 0x0000000000000004
     0x000000000067b728 0x0000000000000002
     0x0000000000455632 0x0000000000485ec0
     000000000000000000 0x000000001af244b8
     0x000000001e6daf60 0x000000000021bfd4
     0x0000000001046ca0 0x000000001418f8a8
     0x00000000006abdc0 0x000000000046f218
     0x000000000045561e 0x000000001418f8a8
  -access registers:
     0000000000 0000000000 0000000000 0000000000
     0000000000 0000000000 0000000000 0000000000
     0000000000 0000000000 0000000000 0000000000
     0000000000 0000000000 0000000000 0000000000
  -control registers:
     0x0000000014354e12 0x0000000000676007
     0x0000000000011200 000000000000000000
     0x0000000000004e0d 0x0000000000011200
     0x0000000011000000 0x0000000000676007
     000000000000000000 000000000000000000
     000000000000000000 000000000000000000
     000000000000000000 0x00000000154641c7
     0x00000000db000000 000000000000000000
  -floating point registers:
     000000000000000000 000000000000000000
     000000000000000000 000000000000000000
     000000000000000000 000000000000000000
     000000000000000000 000000000000000000
     000000000000000000 000000000000000000
     000000000000000000 000000000000000000
     000000000000000000 000000000000000000
     000000000000000000 000000000000000000

 STACK:
 0 ifind+66 [0x1d299e]
 1 ilookup5_nowait+90 [0x1d2af2]
 2 sysfs_addrm_start+98 [0x21c506]
 3 sysfs_hash_and_remove+66 [0x21ac82]
 4 sysfs_remove_link+44 [0x21d8b4]
 5 del_symlink+60 [0x1edeb8]
 6 bd_release_from_disk+218 [0x1edfd6]
 7 close_dev+74 [0x3e000077202]
 8 dm_put_device+88 [0x3e000077280]
 9 free_priority_group+138 [0x3e00008f672]
10 free_multipath+100 [0x3e00008f708]
11 multipath_dtr+66 [0x3e00008f7a6]
12 dm_table_put+174 [0x3e000077e4a]
13 dm_any_congested+80 [0x3e000076020]
14 sync_sb_inodes+164 [0x1e09c0]
15 writeback_inodes+250 [0x1e0f9e]
16 wb_kupdate+208 [0x189e04]
17 pdflush+330 [0x18a65a]
18 kthread+104 [0x152bec]
19 kernel_thread_starter+6 [0x10a0be]

I don't know, if this exact situation is reproducible, but we have a
memory dump that should have some more data.

Any ideas how to debug this problem?

Christof
