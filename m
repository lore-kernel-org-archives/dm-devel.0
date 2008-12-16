From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] linux-next: 20081209 - kernel bug at
	__rcu_process_callbacks, while booting up
Date: Tue, 16 Dec 2008 20:00:01 +0530
Message-ID: <20081216143001.GA4365@linux.vnet.ibm.com>
References: <20081209185237.8bb715d7.sfr@canb.auug.org.au> <20081210115721.GB6107@linux.vnet.ibm.com> <20081210145414.GA6945@linux.vnet.ibm.com> <20081210163007.GA6391@linux.vnet.ibm.com> <20081210175338.GB6745@linux.vnet.ibm.com> <20081210180936.GD6391@linux.vnet.ibm.com> <20081210183302.GD6745@linux.vnet.ibm.com> <20081212194026.GA5455@linux.vnet.ibm.com> <20081212221611.GG6950@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081212221611.GG6950@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, tglx@linutronix.de, mel@csn.ul.ie, jens.axboe@oracle.com
List-Id: dm-devel.ids

* Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-12 14:16:11]:

> On Sat, Dec 13, 2008 at 01:10:26AM +0530, Kamalesh Babulal wrote:
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-10 10:33:02]:
> > 
> > > On Wed, Dec 10, 2008 at 11:39:36PM +0530, Kamalesh Babulal wrote:
> > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-10 09:53:38]:
> > > > 
> > > > > On Wed, Dec 10, 2008 at 10:00:07PM +0530, Kamalesh Babulal wrote:
> > > > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-10 06:54:14]:
> > > > > > 
> > > > > > > On Wed, Dec 10, 2008 at 05:27:21PM +0530, Kamalesh Babulal wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > 	Kernel bug is hit while booting up the next-20081208/09 kernels over
> > > > > > > > the x86_64 box. The IP is pointing to 0x0 and its stuck at
> > > > > > > > __rcu_process_callbacks.
> > > > > > > 
> > > > > > > Kernel config?
> > > > > > > 
> > > > > > > 							Thanx, Paul
> > > > > > > 
> > > > > > Hi Paul,
> > > > > > 
> > > > > > 	I have attached the kernel config file.
> > > > > 
> > > > > Hello, Kamalesh,
> > > > > 
> > > > > No significant recent changes in this area.  Is this consistent?
> > > > > Any chance of "git bisect"?
> > > > > 
> > > > > 							Thanx, Paul
> > > > > 
> > > > Hi Paul,
> > > > 
> > > > 	I tried reproducing it for three times and I was successfull in reproducing it thrice.
> > > > I have already started the git bisect, will update the results soon.
> > > 
> > > Very good, looking forward to seeing the result!
> > > 
> > > 							Thanx, Paul
> > > 
> > Hi Paul,
> > 
> > 	After a Complete round of git bisect, I was not able to reproduce the oops,
> > but when I tried again with complete next-20081209 patch, I am getting
> > different warning message altogether this time
> 
> Might be that the two oopses are different manifestations of the same
> underlying problem, right?
> 
> 							Thanx, Paul
> 
Hi Paul,

	Your were right, those were the manifestation of the same problem. Adding to it
another calltrace was commonly visible during the git-bisect.

Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
INFO: task init:1 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
init          D ffffffff805497a0     0     1      0
 ffff88003fa31648 0000000000000086 ffff88003fa315c8 ffffffff80342d0f
 ffff88003fa315c8 ffff88003fa2f850 ffff88003fad3310 ffff88003fa2fa90
 000000033fa31628 00000000fffef3ea ffff88003fa315f8 ffff88003e489400
Call Trace:
 [<ffffffff80342d0f>] ? generic_unplug_device+0x35/0x39
 [<ffffffff805348a6>] ? _read_unlock+0x9/0xb
 [<ffffffff8053333c>] io_schedule+0x28/0x33
 [<ffffffff802b69b5>] sync_buffer+0x3e/0x42
 [<ffffffff80533598>] __wait_on_bit+0x45/0x77
 [<ffffffff802b6977>] ? sync_buffer+0x0/0x42
 [<ffffffff802b6977>] ? sync_buffer+0x0/0x42
 [<ffffffff80533638>] out_of_line_wait_on_bit+0x6e/0x7b
 [<ffffffff8024a327>] ? wake_bit_function+0x0/0x2a
 [<ffffffff802b6901>] __wait_on_buffer+0x1f/0x21
 [<ffffffff802b8108>] __bread+0x9a/0xb0
 [<ffffffff802eb558>] ext3_get_branch+0x6b/0xe0
 [<ffffffff802eb802>] ext3_get_blocks_handle+0x9e/0x903
 [<ffffffff8033f8aa>] ? elv_rq_merge_ok+0x8e/0x9c
 [<ffffffff8033ff29>] ? elv_rqhash_reposition+0x3f/0x41
 [<ffffffff8033ffb5>] ? elv_merged_request+0x39/0x46
 [<ffffffff805349c3>] ? _spin_unlock_irq+0x9/0xc
 [<ffffffff803430bd>] ? __make_request+0x388/0x399
 [<ffffffff802ec2f0>] ext3_get_block+0xc4/0x102
 [<ffffffff80343182>] ? submit_bio+0xb4/0xbe
 [<ffffffff802bd80d>] do_mpage_readpage+0x18e/0x4d0
 [<ffffffff805349c3>] ? _spin_unlock_irq+0x9/0xc
 [<ffffffff8026bbfd>] ? add_to_page_cache_locked+0x98/0xa8
 [<ffffffff802ec22c>] ? ext3_get_block+0x0/0x102
 [<ffffffff802bdcb9>] mpage_readpages+0xa6/0xe6
 [<ffffffff802ec22c>] ? ext3_get_block+0x0/0x102
 [<ffffffff802717b2>] ? __alloc_pages_internal+0xe7/0x3b9
 [<ffffffff802eb6e8>] ext3_readpages+0x1a/0x1c
 [<ffffffff802733aa>] __do_page_cache_readahead+0xf7/0x189
 [<ffffffff80273867>] do_page_cache_readahead+0x55/0x62
 [<ffffffff8026d76f>] filemap_fault+0x163/0x340
 [<ffffffff8027a224>] __do_fault+0x50/0x3b0
 [<ffffffff8027bd10>] handle_mm_fault+0x1c0/0x6a2
 [<ffffffff80536c4e>] do_page_fault+0x421/0x7cd
 [<ffffffff80534b59>] error_exit+0x0/0x51
 [<ffffffff80354acd>] ? copy_user_generic_string+0x2d/0x40
 [<ffffffff8032bea6>] ? sel_write_load+0x97/0x664
 [<ffffffff8032a2c2>] ? selinux_file_permission+0x59/0x104
 [<ffffffff80321639>] ? security_file_permission+0x11/0x13
 [<ffffffff80298cc0>] vfs_write+0xae/0x137
 [<ffffffff80299169>] sys_write+0x47/0x6f
 [<ffffffff8020be6b>] system_call_fastpath+0x16/0x1b

Reverting the commit below, the next-20081209 kernel bootup without the kernel oops.

commit 30e62ce1ce96ff01d4826b0e476941169c94041d
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Dec 5 13:58:19 2008 +0100

    bio: add experimental support for inlining a number of bio_vecs inside the bio

> > INIT: version 2.86 booting
> > BUG: unable to handle kernel paging request at ffffffff0000000a
> > IP: [<ffffffff8033f4e4>] blk_recalc_rq_sectors+0x5c/0xd9
> > PGD 203067 PUD 0 
> > Oops: 0000 [#1] SMP 
> > last sysfs file: /sys/block/dm-3/removable
> > CPU 3 
> > Modules linked in:
> > Pid: 0, comm: swapper Not tainted 2.6.28-rc7-next-20081209-autokern1 #1
> > RIP: 0010:[<ffffffff8033f4e4>]  [<ffffffff8033f4e4>] blk_recalc_rq_sectors+0x5c/0xd9
> > RSP: 0018:ffff88003fae3e08  EFLAGS: 00010256
> > RAX: 0000000000000000 RBX: ffff88003e970338 RCX: ffff88000100b018
> > RDX: ffffffff00000002 RSI: 0000000000000008 RDI: ffff88003e970338
> > RBP: ffff88003e970338 R08: ffff88003e49d7c0 R09: ffff8800010472b0
> > R10: 0000000000000000 R11: 0000000000001000 R12: ffffe20000dfe080
> > R13: 0000000000000000 R14: 0000000000000008 R15: 0000000000000000
> > FS:  00007f149c33e6f0(0000) GS:ffff88003fa56840(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: ffffffff0000000a CR3: 000000003e4a2000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process swapper (pid: 0, threadinfo ffff88003fada000, task ffff88003fad72b0)
> > Stack:
> >  0000000000000000 ffffffff8033b3f5 0000000000000fe0 ffff88003e970338
> >  0000000000000000 0000000000000000 0000000000000000 ffff88003e970338
> >  ffff88003eae2180 ffffffff8033b42d 0000000000000000 ffff88003e970338
> > Call Trace:
> >  <IRQ> <0> [<ffffffff8033b3f5>] ? __end_that_request_first+0x231/0x24e
> >  [<ffffffff8033b42d>] ? end_that_request_data+0x1b/0x4c
> >  [<ffffffff8033bba7>] ? blk_end_io+0x1c/0x76
> >  [<ffffffff803f6f61>] ? scsi_io_completion+0x1bc/0x452
> >  [<ffffffff8033f9e2>] ? blk_done_softirq+0x5c/0x6a
> >  [<ffffffff8023b895>] ? __do_softirq+0x76/0x136
> >  [<ffffffff8021f88e>] ? ack_apic_level+0x66/0xe3
> >  [<ffffffff8020d03c>] ? call_softirq+0x1c/0x28
> >  [<ffffffff8020e091>] ? do_softirq+0x2c/0x6c
> >  [<ffffffff8020e193>] ? do_IRQ+0xc2/0xdf
> >  [<ffffffff8020c913>] ? ret_from_intr+0x0/0xa
> >  <EOI> <0>Code: 8b 43 60 48 39 43 58 77 7f 48 89 53 68 48 8b 93 80 00 00 00 48 89 43 58 66 83 7a 28 00 74 12 0f b7 42 2a 48 8b 52 48 48 c1 e0 04 <8b> 44 10 08 eb 03 8b 42 30 48 8b 93 80 00 00 00 c1 e8 09 89 43 
> > RIP  [<ffffffff8033f4e4>] blk_recalc_rq_sectors+0x5c/0xd9
> >  RSP <ffff88003fae3e08>
> > CR2: ffffffff0000000a
> > ---[ end trace 38c705e1b1fe7ae3 ]---
> > Kernel panic - not syncing: Fatal exception in interrupt
> > Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc7-next-20081209-autokern1 #1
> > Call Trace:
> >  <IRQ>  [<ffffffff80236e81>] panic+0x86/0x144
> >  [<ffffffff8020e751>] show_registers+0x21d/0x228
> >  [<ffffffff803b0511>] do_unblank_screen+0x2c/0x12c
> >  [<ffffffff805207fa>] oops_end+0xa0/0xad
> >  [<ffffffff80522010>] do_page_fault+0x748/0x801
> >  [<ffffffff8022b44a>] __wake_up_common+0x3f/0x71
> >  [<ffffffff8051fdff>] page_fault+0x1f/0x30
> >  [<ffffffff8033f4e4>] blk_recalc_rq_sectors+0x5c/0xd9
> >  [<ffffffff8033b3f5>] __end_that_request_first+0x231/0x24e
> >  [<ffffffff8033b42d>] end_that_request_data+0x1b/0x4c
> >  [<ffffffff8033bba7>] blk_end_io+0x1c/0x76
> >  [<ffffffff803f6f61>] scsi_io_completion+0x1bc/0x452
> >  [<ffffffff8033f9e2>] blk_done_softirq+0x5c/0x6a
> >  [<ffffffff8023b895>] __do_softirq+0x76/0x136
> >  [<ffffffff8021f88e>] ack_apic_level+0x66/0xe3
> >  [<ffffffff8020d03c>] call_softirq+0x1c/0x28
> >  [<ffffffff8020e091>] do_softirq+0x2c/0x6c
> >  [<ffffffff8020e193>] do_IRQ+0xc2/0xdf
> >  [<ffffffff8020c913>] ret_from_intr+0x0/0xa
> >  <EOI> <4>------------[ cut here ]------------
> > WARNING: at kernel/smp.c:293 smp_call_function_many+0x37/0x220()
> > Hardware name: IBM eServer BladeCenter LS20 -[885055U]-
> > Modules linked in:
> > Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc7-next-20081209-autokern1 #1
> > Call Trace:
> >  <IRQ>  [<ffffffff80236dd4>] warn_slowpath+0xd8/0xf5
> >  [<ffffffff8020c913>] ret_from_intr+0x0/0xa
> >  [<ffffffff8020c913>] ret_from_intr+0x0/0xa
> >  [<ffffffff8020c913>] ret_from_intr+0x0/0xa
> >  [<ffffffff8020c913>] ret_from_intr+0x0/0xa
> >  [<ffffffff80237a22>] printk+0x4e/0x56
> >  [<ffffffff8020f1b9>] print_trace_address+0x1d/0x2d
> >  [<ffffffff80253a01>] smp_call_function_many+0x37/0x220
> >  [<ffffffff8020e525>] dump_trace+0x223/0x232
> >  [<ffffffff8020f1b9>] print_trace_address+0x1d/0x2d
> >  [<ffffffff80253c0a>] smp_call_function+0x20/0x24
> >  [<ffffffff8021ccc1>] native_smp_send_stop+0x1a/0x26
> >  [<ffffffff80236e95>] panic+0x9a/0x144
> >  [<ffffffff8020e751>] show_registers+0x21d/0x228
> >  [<ffffffff803b0511>] do_unblank_screen+0x2c/0x12c
> >  [<ffffffff805207fa>] oops_end+0xa0/0xad
> >  [<ffffffff80522010>] do_page_fault+0x748/0x801
> >  [<ffffffff8022b44a>] __wake_up_common+0x3f/0x71
> >  [<ffffffff8051fdff>] page_fault+0x1f/0x30
> >  [<ffffffff8033f4e4>] blk_recalc_rq_sectors+0x5c/0xd9
> >  [<ffffffff8033b3f5>] __end_that_request_first+0x231/0x24e
> >  [<ffffffff8033b42d>] end_that_request_data+0x1b/0x4c
> >  [<ffffffff8033bba7>] blk_end_io+0x1c/0x76
> >  [<ffffffff803f6f61>] scsi_io_completion+0x1bc/0x452
> >  [<ffffffff8033f9e2>] blk_done_softirq+0x5c/0x6a
> >  [<ffffffff8023b895>] __do_softirq+0x76/0x136
> >  [<ffffffff8021f88e>] ack_apic_level+0x66/0xe3
> >  [<ffffffff8020d03c>] call_softirq+0x1c/0x28
> >  [<ffffffff8020e091>] do_softirq+0x2c/0x6c
> >  [<ffffffff8020e193>] do_IRQ+0xc2/0xdf
> >  [<ffffffff8020c913>] ret_from_intr+0x0/0xa
> >  <EOI> <4>---[ end trace 38c705e1b1fe7ae3 ]---
> > 
> > 
> > > > > > > > Activating logical volumes
> > > > > > > >   4 logical volume(s) in volume group "VolGroup00"BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> > > > > > > > IP: [<0000000000000000>] 0x0
> > > > > > > > PGD 3e8ad067 PUD 3e8ac067 PMD 0 
> > > > > > > > Oops: 0010 [#1] SMP 
> > > > > > > > last sysfs file: /sys/block/dm-1/removable
> > > > > > > > CPU 3 
> > > > > > > > Modules linked in:
> > > > > > > > Pid: 0, comm: swapper Not tainted 2.6.28-rc7-next-20081209-autotest #1
> > > > > > > > RIP: 0010:[<0000000000000000>]  [<0000000000000000>] 0x0
> > > > > > > > RSP: 0018:ffff88003fa73ef0  EFLAGS: 00010286
> > > > > > > > RAX: ffff88003eae0500 RBX: ffff880001047040 RCX: ffffffff80268f66
> > > > > > > > RDX: 0000000000000000 RSI: ffffe20000fab800 RDI: ffff88003eae0500
> > > > > > > > RBP: 0000000000000000 R08: ffff880001047040 R09: ffffffff80853950
> > > > > > > > R10: 0000000000000038 R11: ffffffff8032222d R12: 0000000000000005
> > > > > > > > R13: 0000000000000038 R14: 0000000000000009 R15: 0000000000000018
> > > > > > > > FS:  000000000066d870(0000) GS:ffff88003f803f00(0000) knlGS:0000000000000000
> > > > > > > > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > > > > > > > CR2: 0000000000000000 CR3: 000000003e8a9000 CR4: 00000000000006e0
> > > > > > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > > > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > > > > > Process swapper (pid: 0, threadinfo ffff88003fa64000, task ffff88003f9dde00)
> > > > > > > > Stack:
> > > > > > > >  ffffffff80268f66 ffff88003fa73ef8 0000000000000100 0000000000000001
> > > > > > > >  ffffffff807400b8 0000000000000038 ffffffff80269001 0000000000000018
> > > > > > > >  ffffffff8023b891 ffffffff8020e79e 0000000000000046 ffff88003fa73f80
> > > > > > > > Call Trace:
> > > > > > > >  <IRQ> <0> [<ffffffff80268f66>] __rcu_process_callbacks+0x14e/0x1c3
> > > > > > > >  [<ffffffff80269001>] rcu_process_callbacks+0x26/0x4a
> > > > > > > >  [<ffffffff8023b891>] __do_softirq+0x76/0x136
> > > > > > > >  [<ffffffff8020e79e>] profile_pc+0x21/0x5b
> > > > > > > >  [<ffffffff8020d03c>] call_softirq+0x1c/0x28
> > > > > > > >  [<ffffffff8020e091>] do_softirq+0x2c/0x6c
> > > > > > > >  [<ffffffff8021e018>] smp_apic_timer_interrupt+0x93/0xac
> > > > > > > >  [<ffffffff8020ca73>] apic_timer_interrupt+0x13/0x20
> > > > > > > >  <EOI> <0>Code:  Bad RIP value.
> > > > > > > > RIP  [<0000000000000000>] 0x0
> > > > > > > >  RSP <ffff88003fa73ef0>
> > > > > > > > CR2: 0000000000000000
> > > > > > > > ---[ end trace 69ecde41a682e571 ]---
> > > > > > > > Kernel panic - not syncing: Fatal exception in interrupt
> > > > > > > > Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc7-next-20081209-autotest #1
> > > > > > > > Call Trace:
> > > > > > > > Mounting root fi <IRQ> lesystem.
> > > > > > > >  [<ffffffff80236e7d>] panic+0x86/0x144
> > > > > > > >  [<ffffffff8020ca73>] apic_timer_interrupt+0x13/0x20
> > > > > > > >  [<ffffffff8051fd57>] oops_end+0x61/0xad
> > > > > > > >  [<ffffffff8051fd96>] oops_end+0xa0/0xad
> > > > > > > >  [<ffffffff805215ac>] do_page_fault+0x748/0x801
> > > > > > > >  [<ffffffff8051f3af>] page_fault+0x1f/0x30
> > > > > > > >  [<ffffffff8032222d>] selinux_cred_free+0x0/0x14
> > > > > > > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
> > > > > > > > IP: [<ffffffff802926da>] kmem_cache_alloc+0x6a/0x99
> > > > > > > > PGD 3e8ad067 PUD 3e8ac067 PMD 0 
> > > > > > > > Oops: 0000 [#2] SMP 
> > > > > > > > last sysfs file: /sys/block/ram7/removable
> > > > > > > > CPU 2 
> > > > > > > > Modules linked in:
> > > > > > > > Pid: 1, comm: init Tainted: G      D    2.6.28-rc7-next-20081209-autotest #1
> > > > > > > > RIP: 0010:[<ffffffff802926da>]  [<ffffffff802926da>] kmem_cache_alloc+0x6a/0x99
> > > > > > > > RSP: 0018:ffff88003f9d7db8  EFLAGS: 00010002
> > > > > > > > RAX: 0000000000000000 RBX: 0000000000000246 RCX: 0000000000000001
> > > > > > > > RDX: ffff880001037800 RSI: 0000000000000002 RDI: ffffffff80854f70
> > > > > > > > RBP: 0000000000000020 R08: 0000000000000000 R09: ffffffff80859a80
> > > > > > > > R10: 0000000000000001 R11: ffff88003f426018 R12: ffffffff80854f70
> > > > > > > > R13: ffffffff80253ab1 R14: 0000000000000080 R15: ffffffff802b4141
> > > > > > > > FS:  000000000066d870(0063) GS:ffff88003f803c80(0000) knlGS:0000000000000000
> > > > > > > > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > > > > > > CR2: 0000000000000002 CR3: 000000003e8a9000 CR4: 00000000000006e0
> > > > > > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > > > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > > > > > Process init (pid: 1, threadinfo ffff88003f9d6000, task ffff88003f9d8000)
> > > > > > > > Stack:
> > > > > > > >  00000000ffffffff ffff88003f426000 ffffffff80859a80 ffffffff80859a80
> > > > > > > >  0000000000000000 ffffffff80253ab1 00000000006f1db0 0000000000000000
> > > > > > > >  ffff88003eb6a2f8 ffff88003f9d7e48 0000000000000000 01ff88003e97c400
> > > > > > > > Call Trace:
> > > > > > > >  [<ffffffff80253ab1>] ? smp_call_function_many+0xdb/0x220
> > > > > > > >  [<ffffffff802704ca>] ? do_writepages+0x23/0x30
> > > > > > > >  [<ffffffff802b4141>] ? invalidate_bh_lru+0x0/0x42
> > > > > > > >  [<ffffffff80253c16>] ? smp_call_function+0x20/0x24
> > > > > > > >  [<ffffffff8023b483>] ? on_each_cpu+0x10/0x22
> > > > > > > >  [<ffffffff802b919b>] ? kill_bdev+0x1b/0x30
> > > > > > > >  [<ffffffff802b9892>] ? __blkdev_put+0x54/0x151
> > > > > > > >  [<ffffffff8029899f>] ? __fput+0xe7/0x1b4
> > > > > > > >  [<ffffffff802961ea>] ? filp_close+0x5e/0x66
> > > > > > > >  [<ffffffff8029627f>] ? sys_close+0x8d/0xd1
> > > > > > > >  [<ffffffff8020bf5b>] ? system_call_fastpath+0x16/0x1b
> > > > > > > > Code: 18 03 00 00 48 8b 32 44 8b 72 18 48 85 f6 75 18 49 89 d0 89 ee 4c 89 e9 83 ca ff 4c 89 e7 e8 57 f8 ff ff 48 89 c6 eb 0a 8b 42 14 <48> 8b 04 c6 48 89 02 53 9d 31 c0 c1 ed 0f 48 85 f6 0f 95 c0 85 
> > > > > > > > RIP  [<ffffffff802926da>] kmem_cache_alloc+0x6a/0x99
> > > > > > > >  RSP <ffff88003f9d7db8>
> > > > > > > > CR2: 0000000000000002
> > > > > > > > ---[ end trace 69ecde41a682e571 ]---
> > > > > > > > Kernel panic - not syncing: Attempted to kill init!
> > > > > > > > Pid: 1, comm: init Tainted: G      D    2.6.28-rc7-next-20081209-autotest #1
> > > > > > > > Call Trace:
> > > > > > > >  [<ffffffff80236e7d>] panic+0x86/0x144
> > > > > > > >  [<ffffffff802abbfb>] mntput_no_expire+0x1e/0x139
> > > > > > > >  [<ffffffff802961ea>] filp_close+0x5e/0x66
> > > > > > > >  [<ffffffff8023870d>] exit_fs+0x35/0x46
> > > > > > > >  [<ffffffff80239b7a>] do_exit+0x75/0x766
> > > > > > > >  [<ffffffff8051fd9e>] oops_end+0xa8/0xad
> > > > > > > >  [<ffffffff805215ac>] do_page_fault+0x748/0x801
> > > > > > > >  [<ffffffff80253ab1>] smp_call_function_many+0xdb/0x220
> > > > > > > >  [<ffffffff802b4141>] invalidate_bh_lru+0x0/0x42
> > > > > > > >  [<ffffffff8051f3af>] page_fault+0x1f/0x30
> > > > > > > >  [<ffffffff802b4141>] invalidate_bh_lru+0x0/0x42
> > > > > > > >  [<ffffffff80253ab1>] smp_call_function_many+0xdb/0x220
> > > > > > > >  [<ffffffff802926da>] kmem_cache_alloc+0x6a/0x99
> > > > > > > >  [<ffffffff80253ab1>] smp_call_function_many+0xdb/0x220
> > > > > > > >  [<ffffffff802704ca>] do_writepages+0x23/0x30
> > > > > > > >  [<ffffffff802b4141>] invalidate_bh_lru+0x0/0x42
> > > > > > > >  [<ffffffff80253c16>] smp_call_function+0x20/0x24
> > > > > > > >  [<ffffffff8023b483>] on_each_cpu+0x10/0x22
> > > > > > > >  [<ffffffff802b919b>] kill_bdev+0x1b/0x30
> > > > > > > >  [<ffffffff802b9892>] __blkdev_put+0x54/0x151
> > > > > > > >  [<ffffffff8029899f>] __fput+0xe7/0x1b4
> > > > > > > >  [<ffffffff802961ea>] filp_close+0x5e/0x66
> > > > > > > >  [<ffffffff8029627f>] sys_close+0x8d/0xd1
> > > > > > > >  [<ffffffff8020bf5b>] system_call_fastpath+0x16/0x1b
> > > > > > > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
> > > > > > > > IP: [<ffffffff802926da>] kmem_cache_alloc+0x6a/0x99
> > > > > > > > PGD 0 
> > > > > > > > Oops: 0000 [#3] SMP 
> > > > > > > > last sysfs file: /sys/block/ram7/removable
> > > > > > > > CPU 2 
> > > > > > > > Modules linked in:
> > > > > > > > Pid: 1, comm: init Tainted: G      D    2.6.28-rc7-next-20081209-autotest #1
> > > > > > > > RIP: 0010:[<ffffffff802926da>]  [<ffffffff802926da>] kmem_cache_alloc+0x6a/0x99
> > > > > > > > RSP: 0018:ffff88003f9d7a58  EFLAGS: 00010002
> > > > > > > > RAX: 0000000000000000 RBX: 0000000000000246 RCX: 0000000000000001
> > > > > > > > RDX: ffff880001037800 RSI: 0000000000000002 RDI: ffffffff80854f70
> > > > > > > > RBP: 0000000000000020 R08: ffffffff8052a5c0 R09: ffffffff80859a80
> > > > > > > > R10: 0000000000000000 R11: ffffffff8067c887 R12: ffffffff80854f70
> > > > > > > > R13: ffffffff80253ab1 R14: 0000000000000080 R15: ffffffff80211dd3
> > > > > > > > FS:  000000000066d870(0000) GS:ffff88003f803c80(0000) knlGS:0000000000000000
> > > > > > > > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > > > > > > CR2: 0000000000000002 CR3: 0000000000201000 CR4: 00000000000006e0
> > > > > > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > > > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > > > > > Process init (pid: 1, threadinfo ffff88003f9d6000, task ffff88003f9d8000)
> > > > > > > > Stack:
> > > > > > > >  00000000ffffffff ffff88003f9d8000 ffffffff80859a80 ffffffff80859a80
> > > > > > > >  0000000000000000 ffffffff80253ab1 ffffffff8052a5c0 ffff88003fa3bfc0
> > > > > > > >  0000000000000000 ffffffff8020e525 0000000000000010 000000003e943800
> > > > > > > > Call Trace:
> > > > > > > >  [<ffffffff80253ab1>] ? smp_call_function_many+0xdb/0x220
> > > > > > > >  [<ffffffff8020e525>] ? dump_trace+0x223/0x232
> > > > > > > >  [<ffffffff80253c16>] ? smp_call_function+0x20/0x24
> > > > > > > >  [<ffffffff8021ccc1>] ? native_smp_send_stop+0x1a/0x26
> > > > > > > >  [<ffffffff80236e91>] ? panic+0x9a/0x144
> > > > > > > >  [<ffffffff802abbfb>] ? mntput_no_expire+0x1e/0x139
> > > > > > > >  [<ffffffff802961ea>] ? filp_close+0x5e/0x66
> > > > > > > >  [<ffffffff8023870d>] ? exit_fs+0x35/0x46
> > > > > > > >  [<ffffffff80239b7a>] ? do_exit+0x75/0x766
> > > > > > > >  [<ffffffff8051fd9e>] ? oops_end+0xa8/0xad
> > > > > > > >  [<ffffffff805215ac>] ? do_page_fault+0x748/0x801
> > > > > > > >  [<ffffffff80253ab1>] ? smp_call_function_many+0xdb/0x220
> > > > > > > >  [<ffffffff802b4141>] ? invalidate_bh_lru+0x0/0x42
> > > > > > > >  [<ffffffff8051f3af>] ? page_fault+0x1f/0x30
> > > > > > > >  [<ffffffff802b4141>] ? invalidate_bh_lru+0x0/0x42
> > > > > > > >  [<ffffffff80253ab1>] ? smp_call_function_many+0xdb/0x220
> > > > > > > >  [<ffffffff802926da>] ? kmem_cache_alloc+0x6a/0x99
> > > > > > > >  [<ffffffff80253ab1>] ? smp_call_function_many+0xdb/0x220
> > > > > > > >  [<ffffffff802704ca>] ? do_writepages+0x23/0x30
> > > > > > > >  [<ffffffff802b4141>] ? invalidate_bh_lru+0x0/0x42
> > > > > > > >  [<ffffffff80253c16>] ? smp_call_function+0x20/0x24
> > > > > > > >  [<ffffffff8023b483>] ? on_each_cpu+0x10/0x22
> > > > > > > >  [<ffffffff802b919b>] ? kill_bdev+0x1b/0x30
> > > > > > > >  [<ffffffff802b9892>] ? __blkdev_put+0x54/0x151
> > > > > > > >  [<ffffffff8029899f>] ? __fput+0xe7/0x1b4
> > > > > > > >  [<ffffffff802961ea>] ? filp_close+0x5e/0x66
> > > > > > > >  [<ffffffff8029627f>] ? sys_close+0x8d/0xd1
> > > > > > > >  [<ffffffff8020bf5b>] ? system_call_fastpath+0x16/0x1b
> > > > > > > > Code: 18 03 00 00 48 8b 32 44 8b 72 18 48 85 f6 75 18 49 89 d0 89 ee 4c 89 e9 83 ca ff 4c 89 e7 e8 57 f8 ff ff 48 89 c6 eb 0a 8b 42 14 <48> 8b 04 c6 48 89 02 53 9d 31 c0 c1 ed 0f 48 85 f6 0f 95 c0 85 
> > > > > > > > RIP  [<ffffffff802926da>] kmem_cache_alloc+0x6a/0x99
> > > > > > > >  RSP <ffff88003f9d7a58>
> > > > > > > > CR2: 0000000000000002
> > > > > > > > ---[ end trace 69ecde41a682e571 ]---
> > > > > > > > Fixing recursive fault but reboot is needed!
> > > > > > > >  [<ffffffff80268f66>] __rcu_process_callbacks+0x14e/0x1c3
> > > > > > > >  [<ffffffff80268f66>] __rcu_process_callbacks+0x14e/0x1c3
> > > > > > > >  [<ffffffff80269001>] rcu_process_callbacks+0x26/0x4a
> > > > > > > >  [<ffffffff8023b891>] __do_softirq+0x76/0x136
> > > > > > > >  [<ffffffff8020e79e>] profile_pc+0x21/0x5b
> > > > > > > >  [<ffffffff8020d03c>] call_softirq+0x1c/0x28
> > > > > > > >  [<ffffffff8020e091>] do_softirq+0x2c/0x6c
> > > > > > > >  [<ffffffff8021e018>] smp_apic_timer_interrupt+0x93/0xac
> > > > > > > >  [<ffffffff8020ca73>] apic_timer_interrupt+0x13/0x20
> > > > > > > >  <EOI> 
> > > > > > 
> > <snip the .config file>

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
